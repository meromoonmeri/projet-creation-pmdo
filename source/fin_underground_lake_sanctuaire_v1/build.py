#!/usr/bin/env python3
"""Fin Underground Lake — Sanctuaire Bioluminescent V1 (FUL2) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Fin de donjon appairée à l'entrée `entree_underground_lake_sud_nord_v1` (EUL1).
Référence canonique ROM rendue par `source/outil_maps_pmdsky/recuperer_maps.py rom` :
- `reference/D15P41A.png` (Underground_Lake_shore_TDS.png, PMD Explorers of Sky, 69 couleurs exactes).

Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- `bruts/decor_magenta.png` : décor complet 4:3 (1200 x 896), l'eau du lac souterrain en magenta #FF00FF ;
- `bruts/sol_complet.png` : édité depuis le décor ; le générateur a retiré le lac, les 4 grands piliers et les
  stalagmites, mais a GARDÉ les parois externes recalées à (0, 0) : il sert de sol sous tout et de témoin pour isoler
  les piliers et stalagmites ;
- `bruts/gouttes_ronds_poses.png` : planche sur magenta #FF00FF (gouttes, impact, éclaboussures et ronds dans l'eau).

Calques statiques : sol_complet, sable, ombres, berge, roche, piliers.
Animations, chacune sur son calque, boucles fermées (PPCM(40, 120, 120) = 120 ticks = 2 s) :
- `eau` : lac façon rivière Métano (structure, cadence 4 x 10), couleurs EXACTES du rip, sans liseré clair de rive ;
- `lueur` : anneaux aux 9 couleurs EXACTES du rip qui respirent, 12 x 10 ticks ;
- `scintillements` : scintillements Métano natifs sur le cœur de la lueur, 4 x 10 ticks ;
- `gouttes` : gouttes qui tombent du plafond et ronds dans l'eau (poses générées), 24 x 5 ticks.

Lancer : .venv/bin/python source/fin_underground_lake_sanctuaire_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF = HERE / 'reference/D15P41A.png'
OUT = R / 'renders/fin_underground_lake_sanctuaire_v1'
STAGE = R / '.cache/fin_underground_lake_sanctuaire_v1/fin_underground_lake_sanctuaire'
NAMESPACE = 'fin_underground_lake_sanctuaire'
ASSET = 'ful2_fin_underground_lake'
PFX = 'FUL2'
W, H = 768, 576
SRC = (1200, 896)
WATER_PHASES, WATER_TICKS = 4, 10
GLOW_PHASES, GLOW_TICKS = 12, 10          # lueur : 12 x 10 = 120 ticks
DROP_PHASES, DROP_TICKS = 24, 5           # gouttes : 24 x 5 = 120 ticks
LOOP_TICKS = 120

GEN = [
    {'file': 'decor_magenta.png',
     'images': ['source/fin_underground_lake_sanctuaire_v1/reference/D15P41A.png'],
     'prompt': 'Use EXACTLY the same textures, palette and 2D Nintendo DS pixel-art style as the reference image '
               '(Pokemon Mystery Dungeon Explorers of Sky, Underground Lake D15P41A): same pale yellow sand with soft '
               'stippled texture and warm tan shore edge, same olive-khaki bumpy cavern walls made of stacked rounded '
               'rock lumps with dark crevices, same tall cylindrical rock pillars with wider rocky bases rising from '
               'the water, and same small pointed conical stalagmites standing in the water. Make a NEW, larger '
               'top-down dungeon-end boss sanctuary map in WIDE LANDSCAPE 4:3 (1200x896), zoomed out so the '
               'subterranean lake cavern feels vast. Pure natural cavern decor (no buildings, no statues, no altars, '
               'no characters, no text, no UI, no border): the player arrives at the SOUTH (bottom edge center) on a '
               'wide pale-yellow sand corridor between olive-khaki bumpy cavern rock walls; the sand opens northward '
               'into a large rounded central pale-yellow sand peninsula (the boss arena) jutting out into the vast '
               'underground lake. The underground lake surrounds the sand peninsula on the left, right, and entire '
               'upper (NORTH) half of the map. Four tall cylindrical rock pillars and several small pointed '
               'stalagmites rise from the lake in the northern half, and olive-khaki bumpy rock walls frame the '
               'lower-left and lower-right corners. IMPORTANT: fill the ENTIRE underground lake water surface with '
               'flat solid pure magenta #FF00FF (RGB 255, 0, 255), with no blue or cyan water, no glow rings, and no '
               'ripples on the magenta.'},
    {'file': 'sol_complet.png',
     'images': ['source/fin_underground_lake_sanctuaire_v1/bruts/decor_magenta.png'],
     'prompt': 'Generate an image: edit this 4:3 pixel-art underground cavern map by removing the pink water, rock '
               'pillars, and stalagmites so the pale yellow cavern sand ground covers the center and upper area.'},
    {'file': 'gouttes_ronds_poses.png',
     'images': ['source/fin_underground_lake_sanctuaire_v1/reference/D15P41A.png'],
     'prompt': 'Pixel-art sprite sheet on a flat pure magenta #FF00FF background, same 2D Nintendo DS style and '
               'cyan-blue colors as the reference image (Pokemon Mystery Dungeon Explorers of Sky Underground Lake). '
               '2 rows of 6 small separate sprites. Row 1: a pale cyan-blue water droplet falling, stretching, hitting '
               'the water, and splashing. Row 2: a thin pale cyan-blue concentric ripple ring growing from tiny to '
               'wide across 6 steps. Each sprite isolated on flat #FF00FF magenta, well separated, no text, no grid '
               'lines.'},
]

# Couleurs EXACTES de D15P41A.png (mesurées : 69 couleurs). Eau : aplat (39,39,95) ; bande de rive (55,55,111) ; accent (63,63,119).
WPAL = {'surface': (39, 39, 95), 'bande': (55, 55, 111), 'accent': (63, 63, 119)}
# Lueur : cœur puis 8 anneaux aux 9 couleurs EXACTES de D15P41A.png, du plus clair au plus sombre.
GLOW = [
    (31, 223, 167),
    (31, 207, 167),
    (31, 183, 167),
    (31, 151, 159),
    (39, 135, 151),
    (39, 119, 135),
    (39, 95, 135),
    (39, 79, 119),
    (39, 63, 111),
]
GLOW_RING_PX = 4
GLOW_BREATH, GLOW_WOBBLE = 0.04, 0.02

POSE_K = 8
POSE_WIN = {
    'goutte': (387, 90, 64),
    'goutte_etiree': (394, 255, 96),
    'impact': (416, 584, 128),
    'eclaboussure': (408, 750, 144),
    'rond_0': (624, 89, 48),
    'rond_1': (624, 255, 80),
    'rond_2': (624, 420, 112),
    'rond_3': (624, 585, 144),
    'rond_4': (624, 749, 160),
    'rond_5': (623, 917, 176),
}
DROP_SEQ = ([('goutte', -16), ('goutte', -12), ('goutte', -8), ('goutte_etiree', -4), ('impact', 0), ('eclaboussure', 0),
             ('rond_0', 0), ('rond_1', 0), ('rond_1', 0), ('rond_2', 0), ('rond_2', 0), ('rond_3', 0), ('rond_3', 0),
             ('rond_4', 0), ('rond_4', 0), ('rond_5', 0), ('rond_5', 0)] + [None] * 7)
assert len(DROP_SEQ) == DROP_PHASES


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V2 = loadmod('ewc2_build', R / 'source/entree_waterfall_cave_sud_nord_v2/build.py')
V1 = V2.V1
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, place, cell_grid, close_ = V1.keep_large, V1.place, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {
    'terrain': (['sol_complet', 'sable', 'ombres', 'berge'], 96),
    'roche': (['roche', 'piliers'], 64),
}
STATIC = ['sable', 'ombres', 'berge', 'roche', 'piliers']


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


# ---------------------------------------------------------------- fidélité au rip D15P41A.png
def materials(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]; sat = a.max(2) - a.min(2)
    mag = (r - g > 60) & (b - g > 60)
    sand = (r > 150) & (r - b > 50) & (lum > 140) & ~mag
    rock = (r >= b + 15) & (g >= b + 10) & (lum > 40) & (lum < 175) & (sat < 90) & ~sand & ~mag
    return {'sable': sand, 'roche': rock}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {
            'rip_rgb': [round(float(v), 1) for v in mr],
            'decor_rgb': [round(float(v), 1) for v in md],
            'distance': round(float(np.linalg.norm(mr - md)), 1),
        }
    return out


# ---------------------------------------------------------------- segmentation pleine résolution (1200 x 896)
def classify(a, f):
    """a : décor, f : sol complet (parois recalées (0, 0) : écart 4,01 sur les parois contre 82,39 sur les piliers)."""
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    water = nd.binary_dilation((r - g > 60) & (b - g > 60), iterations=2)
    sandish = (r > 150) & (r - b > 50) & (lum > 140) & ~water
    sand = keep_large(open_(close_(sandish, 2), 1), 20000)
    holes = nd.binary_fill_holes(sand) & ~sand; hl, _ = nd.label(holes)
    hs = nd.sum(holes, hl, range(1, hl.max() + 1)) if hl.max() else []
    sand = (sand | np.isin(hl, [i + 1 for i, v in enumerate(hs) if v < 400])) & ~water
    rockish = ~sand & ~water
    Ls = nd.uniform_filter(lum, 5); dr = nd.distance_transform_edt(~rockish)
    shade = sand & (dr <= 16) & (Ls < 187)
    shade = keep_large(close_(shade, 1), 60) & sand
    dw = nd.distance_transform_edt(~water); ds = nd.distance_transform_edt(~sand)
    berge = rockish & (dw <= 14) & (ds <= 14)
    diff = nd.uniform_filter(np.abs(a - f).mean(2), 5)
    rest = rockish & ~berge
    pil = rest & (diff > 20) & (yy < 420) & (xx > 75) & (xx < 1125)
    pil = nd.binary_fill_holes(keep_large(open_(close_(pil, 2), 1), 120)) & rest
    roche = rest & ~pil
    return dict(water=water, sable=sand & ~shade, ombres=shade, berge=berge, piliers=pil,
                roche=roche), {'ecart_parois': round(float(diff[roche].mean()), 2),
                               'ecart_piliers': round(float(diff[pil].mean()), 2)}


# ---------------------------------------------------------------- eau et lueur bioluminescente
def lake_water(water, visible):
    d = nd.distance_transform_edt(visible); yy, xx = np.mgrid[:H, :W]
    jag = nd.gaussian_filter(np.random.default_rng(9).random((H, W)), 1.0); jag = (jag - jag.min()) / np.ptp(jag)
    frames = []
    for t in range(WATER_PHASES):
        ph = 2 * np.pi * t / WATER_PHASES
        n = 0.6 * np.sin(yy * 0.23 + xx * 0.08 - ph) + 0.4 * np.sin(yy * 0.09 - xx * 0.19 + 1.3 - ph)
        T = 4.5 + 1.1 * n; jr = np.roll(jag, t * 2, axis=0); fringe = T + 0.6 + 2.6 * jr
        a = np.zeros((H, W, 4), 'uint8'); a[..., 3] = 255; a[..., :3] = WPAL['surface']
        a[d <= fringe] = (*WPAL['bande'], 255)
        a[(d <= fringe) & (jr > 0.62)] = (*WPAL['accent'], 255)
        a[d <= T] = (*WPAL['bande'], 255)
        a[~water] = 0; a[water & ~visible] = (*WPAL['bande'], 255)
        frames.append(a)
    return frames, d


def glow_centres(water):
    """Lueur principale au nord-centre (entre les piliers, comme sur D15P41A.png) et deux bassins secondaires latéraux."""
    return [
        [W // 2, 48, 172, 68],
        [156, 212, 58, 38],
        [W - 156, 212, 58, 38],
    ]


def glow_frames(visible, centres, ts=range(GLOW_PHASES)):
    yy, xx = np.mgrid[:H, :W]; frames = []
    for t in ts:
        ph = 2 * np.pi * t / GLOW_PHASES; a = np.zeros((H, W, 4), 'uint8')
        core_union = np.zeros((H, W), bool)
        for cx, cy, rx, ry in centres:
            dx, dy = (xx - cx) / rx, (yy - cy) / ry
            rho = np.hypot(dx, dy) * (1 + GLOW_WOBBLE * np.sin(5 * np.arctan2(dy, dx) - ph)) / (1 + GLOW_BREATH * np.sin(ph))
            core_union |= (rho < 1)
        ring = np.ceil(nd.distance_transform_edt(~core_union) / GLOW_RING_PX).astype(int)
        for i, c in enumerate(GLOW):
            a[visible & (ring == i)] = (*c, 255)
        frames.append(a)
    return frames


# ---------------------------------------------------------------- poses générées (gouttes et ronds)
def reduce_pose(src, bg, cy, cx, win, k, pal, cov_min):
    h, w = bg.shape; y0, x0 = int(cy) - win // 2, int(cx) - win // 2; n = win // k
    pad = np.zeros((win, win, 3)); pm = np.zeros((win, win), bool)
    sy0, sx0, sy1, sx1 = max(0, y0), max(0, x0), min(h, y0 + win), min(w, x0 + win)
    pad[sy0 - y0:sy1 - y0, sx0 - x0:sx1 - x0] = src[sy0:sy1, sx0:sx1]
    pm[sy0 - y0:sy1 - y0, sx0 - x0:sx1 - x0] = ~bg[sy0:sy1, sx0:sx1]
    blk = pm.reshape(n, k, n, k); cov = blk.mean((1, 3))
    col = (pad * pm[..., None]).reshape(n, k, n, k, 3).sum((1, 3)) / np.maximum(blk.sum((1, 3)), 1)[..., None]
    o = np.zeros((n, n, 4), 'uint8'); o[..., :3] = pal[((col[..., None, :] - pal[None, None]) ** 2).sum(-1).argmin(-1)]
    o[..., 3] = 255; o[cov < cov_min] = 0
    return o


def sheet_poses(path):
    src = rgb(path); r, g, b = src.transpose(2, 0, 1)
    bg = ((r - g) > 40) & ((b - g) > 40)
    px = np.concatenate([src[cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2][~bg[cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2]]
                         for cy, cx, s in POSE_WIN.values()])
    q = Image.fromarray(px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=8, method=Image.Quantize.MEDIANCUT)
    pal = np.array(q.getpalette()[:24], float).reshape(-1, 3)
    poses = {}
    for name, (cy, cx, s) in POSE_WIN.items():
        cov_min = 0.08 if name == 'rond_5' else 0.22
        poses[name] = reduce_pose(src, bg, cy, cx, s, POSE_K, pal, cov_min)
    return poses, pal


def paste(frame, spr, cx, cy, clip=None):
    hh, ww = spr.shape[:2]; y0, x0 = int(round(cy)) - hh // 2, int(round(cx)) - ww // 2
    ys0, xs0 = max(0, -y0), max(0, -x0); ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]; m = s[..., 3] > 0
    if clip is not None:
        m &= clip[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1]
    frame[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1][m] = s[m]


def drop_frames(poses, emitters, visible, ts=range(DROP_PHASES)):
    frames = [np.zeros((H, W, 4), 'uint8') for _ in ts]
    for cx, cy, off in emitters:
        for i, t in enumerate(ts):
            st = DROP_SEQ[(t + off) % DROP_PHASES]
            if st is None:
                continue
            name, dy = st
            paste(frames[i], poses[name], cx, cy + dy, None if name.startswith('goutte') else visible)
    return frames


# ---------------------------------------------------------------- ORA et Ground PMDO 0.8.12
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Underground Lake - Sanctuaire Bioluminescent V1 (FUL2)')
    stack = ET.SubElement(root, 'stack'); comp = Image.new('RGBA', (W, H))
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0', visibility='visible',
                          **{'composite-op': 'svg:src-over'})
            b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); z.writestr(fn, b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO(); comp.save(b, format='PNG'); z.writestr('mergedimage.png', b.getvalue())
        th = comp.copy(); th.thumbnail((256, 256)); b = io.BytesIO(); th.save(b, format='PNG')
        z.writestr('Thumbnails/thumbnail.png', b.getvalue())
        z.writestr('stack.xml', ET.tostring(root, encoding='utf-8', xml_declaration=True))


def ground_project(stack, blocked, entry_px, boss_px, goal_px, gfx, tools):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl_path = R / 'source/cote_v5_expeditions/references/ExplorersOfSkyOrigins__drenched_bluff_entrance.rsground'
    tpl = json.loads(tpl_path.read_text(encoding='utf-8-sig'))
    o = tpl['Object']; gw, gh = W // 8, H // 8; layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack):
        bank = gfx.TileBank(f'{PFX}_{i:02d}_{title.split()[0].upper()}')
        bank.ids[bytes(256)] = (0, 0); bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            fs = []
            for a in frames:
                f = bank.add(Image.fromarray(a[y*8:y*8+8, x*8:x*8+8]), x, y)
                fs.append(f if f else {'Sheet': bank.name, 'TexLoc': {'X': 0, 'Y': 0}})
            if all(f['TexLoc'] == {'X': 0, 'Y': 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs
        layers.append(gfx.layer(f'{i:02d} {title}', gw, gh, cell, ticks)); banks.append(bank)
    layers.append(gfx.layer(f'{len(layers):02d} Vos elements avant-plan (Top)', gw, gh, draw=4))
    for bank in banks:
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')
    o.update(Name={'DefaultText': 'Fin Underground Lake - Sanctuaire Bioluminescent (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Fin de donjon 4:3 appairee a EUL1, referencee sur D15P41A ; lac facon Metano aux '
                     'couleurs exactes du rip sans lisere clair, lueur bioluminescente aux 9 couleurs exactes du rip, '
                     'scintillements Metano natifs, gouttes et ronds generes. Collisions de base a verifier.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
                      'Spawners': [], 'Markers': [mk('entrance', entry_px), mk('boss', boss_px), mk('objectif', goal_px)]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
             f'-- {ASSET} : base d edition, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Underground Lake - Sanctuaire Bioluminescent 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : fin de donjon d'Underground Lake au format 4:3 (ref. D15P41A), lac facon Metano, lueur bioluminescente, gouttes et ronds animes.</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''')
    script = (R / 'source/pmdo_cote/INSTALLER.py').read_text()
    needle = '            relative = src.relative_to(source)\n'
    assert needle in script
    script = script.replace(needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n")
    (STAGE / 'INSTALLER.py').write_text(script)
    shutil.copyfile(HERE / 'README_PACK.md', STAGE / 'README.md')
    return {b.name: len(b.data) for b in banks}


# ---------------------------------------------------------------- main
def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    ANIMS = ['eau', 'lueur', 'scintillements', 'gouttes']
    if OUT.exists():
        for d in ['calques', 'animation', 'poses', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png'); ref = rgb(REF)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a, f)
    order = ['water', 'sable', 'ombres', 'berge', 'piliers', 'roche']
    ex, cols = down_class(a, m, order)
    water = ex['water']
    layers = {'sol_complet': rgba(down_full(f), ~water)}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    land = np.zeros((H, W), bool)
    for k in STATIC:
        land |= layers[k][..., 3] == 255
    visible = water & ~land
    wf, dist = lake_water(water, visible)
    centres = glow_centres(water)
    lueur = glow_frames(visible, centres)
    glow_any = np.zeros((H, W), bool); glow_core = np.ones((H, W), bool)
    for fr in lueur:
        glow_any |= fr[..., 3] == 255
        glow_core &= (fr[..., :3] == GLOW[0]).all(-1) & (fr[..., 3] == 255)
    # Scintillements natifs sur le cœur de la lueur (commun aux 12 phases).
    free = visible & (dist > 4) & nd.binary_erosion(glow_core, iterations=2)
    fams = BM.sparkle_families(); taken = np.zeros((H, W), bool)
    sf = [np.zeros((H, W, 4), 'uint8') for _ in range(WATER_PHASES)]; sparkles = []
    for fi, (name, frames) in enumerate(fams.items()):
        hh, ww = frames[0].shape[:2]
        for (y, x) in place(free, (hh, ww), 2, 71 + fi, taken, core=8):
            sparkles.append({'famille': name, 'xy': [x, y]})
            for t in range(WATER_PHASES):
                mm = frames[t][..., 3] > 0; sf[t][y:y+hh, x:x+ww][mm] = frames[t][mm]
    for arr in sf:
        arr[~visible] = 0
    # Gouttes : poses générées ; émetteurs sur l'eau sombre dégagée.
    poses, pose_pal = sheet_poses(RAW / 'gouttes_ronds_poses.png')
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    fall_ok = visible & (dist > 6)
    ok = visible & (dist > 14) & ~nd.binary_dilation(glow_core, iterations=6) & ~taken
    for s in range(1, 19):
        ok &= np.roll(fall_ok, s, axis=0)
    cand = np.argwhere(ok); emitters, used = [], []
    for y, x in cand[np.random.default_rng(14).permutation(len(cand))]:
        if all(abs(x - ux) > 48 or abs(y - uy) > 48 for uy, ux in used):
            used.append((y, x)); emitters.append((int(x), int(y), (len(emitters) * 3) % DROP_PHASES))
        if len(emitters) == 8:
            break
    gouttes = drop_frames(poses, emitters, visible)
    # Exports
    anim = {'eau': (wf, WATER_TICKS), 'lueur': (lueur, GLOW_TICKS), 'scintillements': (sf, WATER_TICKS),
            'gouttes': (gouttes, DROP_TICKS)}
    order_names = ['eau', 'lueur', 'scintillements', 'gouttes', 'sol_complet'] + STATIC
    stack_named, layer_list = [], []
    for i, nm in enumerate(order_names):
        if nm in anim:
            frames, ticks = anim[nm]
            for t, fr in enumerate(frames):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{t:02d}.png')
            layer_list.append({'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frames), 'ticks': ticks})
        else:
            frames, ticks = [layers[nm]], 60
            Image.fromarray(layers[nm]).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
        stack_named.append((nm, frames, ticks))
    # Collisions : sable (ombres comprises) praticable.
    walk_px = (layers['sable'][..., 3] == 255) | (layers['ombres'][..., 3] == 255)
    blocked = cell_grid(~walk_px); gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk_px[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    boss_px = [W // 2 - 8, H // 2 + 16]
    while blocked[boss_px[1] // 8:boss_px[1] // 8 + 2, boss_px[0] // 8:boss_px[0] // 8 + 2].any():
        boss_px[1] += 8
    py, px_ = np.nonzero(walk_px); top_y = int(py.min()); tx = int(np.median(px_[py < top_y + 16]))
    goal_px = [tx // 8 * 8 - 8, (top_y // 8 + 1) * 8]
    while blocked[goal_px[1] // 8:goal_px[1] // 8 + 2, goal_px[0] // 8:goal_px[0] // 8 + 2].any():
        goal_px[1] += 8
    ok1, exp1 = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    ok2, exp2 = v1.reachable(blocked, (boss_px[1] // 8, boss_px[0] // 8), (goal_px[1] // 8, goal_px[0] // 8))
    assert ok1 and ok2, f'pas de chemin 16x16: {ok1}, {ok2}'

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for _, frames, ticks in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
        return im
    step = 5
    scenes = [scene(t) for t in range(0, LOOP_TICKS, step)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(step * 1000 / 60), loop=0, lossless=True)
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 120, 40, 255)), (goal_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    names = list(POSE_WIN); cw = 24 * 4 + 8
    sheet = Image.new('RGBA', (len(names) * cw + 8, cw + 8), (*WPAL['surface'], 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm]); im = im.resize((im.width * 4, im.height * 4), Image.Resampling.NEAREST)
        sheet.alpha_composite(im, (8 + i * cw + (cw - 8 - im.width) // 2, 8 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_fin_underground_lake_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, goal_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('sable', 'sable'), ('roche', 'roche'), ('roche', 'piliers')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'fin_underground_lake_sanctuaire_v1', 'prefix': PFX, 'associated_entry': 'EUL1',
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'base': 'branche de session ; appairee a entree_underground_lake_sud_nord_v1 (EUL1)',
        'biome': 'Underground Lake Sanctuary (D15P41A)',
        'method': 'textures canoniques = rendu genere REFERENCE : rip D15P41A passe au generateur ; decor complet sur '
                  'magenta (lac = magenta), sol complet edite depuis le decor, planche gouttes/ronds sur magenta',
        'reference_da': {
            'file': 'source/fin_underground_lake_sanctuaire_v1/reference/D15P41A.png',
            'sha256': sha(REF),
            'titre': 'Rive du lac souterrain (Underground Lake, PMD Explorers of Sky, D15P41A)',
        },
        'generation': GEN,
        'raw_inputs': [{'file': f'source/fin_underground_lake_sanctuaire_v1/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'sol_complet': {'recalage_px': [0, 0], 'ecarts_segmentation': seg,
                        'note': 'le generateur a garde les parois externes (sous le calque roche) et retire le lac, '
                                'les 4 piliers et les stalagmites'},
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip D15P41A et sur le brut ; distance euclidienne',
                         'brut': fid, 'calques_finaux': final_fid,
                         'eau_et_lueur': 'couleurs EXACTES du rip D15P41A (sous-ensemble des 69 couleurs du rip)'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'layers': layer_list,
        'water': {'phases': WATER_PHASES, 'frame_length_ticks': WATER_TICKS, 'couleurs': {k: list(v) for k, v in WPAL.items()},
                  'modele': 'structure et cadence riviere Metano, couleurs EXACTES du rip D15P41A, sans lisere clair de rive',
                  'origine': 'pixels recalcules, pas de tuiles natives'},
        'lueur': {'phases': GLOW_PHASES, 'frame_length_ticks': GLOW_TICKS, 'couleurs': [list(c) for c in GLOW],
                  'centres': centres, 'anneau_px': GLOW_RING_PX, 'respiration': GLOW_BREATH, 'ondulation': GLOW_WOBBLE,
                  'origine': 'couleurs EXACTES du rip D15P41A (coeur + 8 anneaux) ; forme, respiration et ondulation creees par nous'},
        'sparkles': {'source': 'source/eau_metano/natifs/Metano_Town_River_Sparkles.tile', 'placements': sparkles,
                     'origine': 'pixels et couleurs Metano NATIFS inchanges (aplat de surface retire)',
                     'zone': 'coeur de la lueur (commun aux 12 phases)'},
        'gouttes': {'poses': {k: list(v) for k, v in POSE_WIN.items()}, 'reduction': f'x1/{POSE_K} pour toutes les poses',
                    'palette': [[int(round(c)) for c in p] for p in pose_pal], 'chronologie': DROP_SEQ,
                    'emetteurs': [list(e) for e in emitters], 'phases': DROP_PHASES, 'frame_length_ticks': DROP_TICKS,
                    'origine': 'dessin GENERE (8 couleurs tirees de la planche) ; chronologie, chute et placement crees par nous'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'threshold_px': goal_px, 'path_found_16x16': bool(ok1 and ok2),
                   'cells_explored': exp1, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors sable (ombres comprises)',
                   'seuil': 'pointe nord du promontoire de sable face au lac bioluminescent'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'sparkles': len(sparkles), 'entry': entry_px, 'boss': boss_px, 'goal': goal_px,
                      'blocked': int(blocked.sum()), 'walkable': int((~blocked).sum()), 'emitters': len(emitters),
                      'seg': seg, 'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': sum(counts.values())}, indent=1))


if __name__ == '__main__':
    build()
