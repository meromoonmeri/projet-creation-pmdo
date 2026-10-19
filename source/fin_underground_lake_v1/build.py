"""Fin Underground Lake : rive du lac souterrain V1 (FUL2) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Prolonge l'entrée EUL1 (source/entree_underground_lake_sud_nord_v1) dans la série des fins de donjon, d'après la
capture `Underground_Lake_shore_TDS.png` (PMD Explorers). Préfixe FUL2 (FUL1 est déjà pris sur les branches sœurs
01a0ea8f et 01a0eaca). Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor_magenta.png : décor complet 4:3 (1200 x 896), l'eau du lac en magenta pur (#FF00FF), sans bouche de tunnel ;
- sol_complet.png : édité depuis le décor ; le générateur a retiré lac, piliers et stalagmites en les remplaçant par du
  sable, mais a GARDÉ les parois (recalées au pixel près : écart 3,76 contre 7,11 à 1 px) : il sert de sol sous tout et
  de témoin pour isoler les piliers et stalagmites ;
- gouttes_ronds_poses.png : planche sur magenta réutilisée à l'identique depuis EUL1.
Calques fixes : sol complet, sable, ombres au pied des parois, berge du lac, parois, piliers et stalagmites.
Animations, chacune sur son calque, boucles fermées :
- lac façon rivière Métano (structure, cadence 4 x 10), couleurs EXACTES du rip, sans liseré clair de rive ;
- lueur du lac : anneaux aux 9 couleurs exactes du rip qui respirent entre les deux piliers, 12 x 10 ticks ;
- scintillements Métano natifs, 4 x 10 ticks ;
- gouttes qui tombent du plafond et ronds dans l'eau (poses générées d'EUL1), 24 x 5 ticks.
Scène : PPCM(40, 120, 120) = 120 ticks = 2 s.
Lancer : .venv/bin/python source/fin_underground_lake_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF = R / 'Underground_Lake_shore_TDS.png'
OUT = R / 'renders/fin_underground_lake_v1'
STAGE = R / '.cache/fin_underground_lake_v1/fin_underground_lake'
NAMESPACE = 'fin_underground_lake'
ASSET = 'ful2_fin_underground_lake'
PFX = 'FUL2'
W, H = 768, 576
SRC = (1200, 896)
WATER_PHASES, WATER_TICKS = 4, 10
GLOW_PHASES, GLOW_TICKS = 12, 10          # lueur : 12 x 10 = 120 ticks
DROP_PHASES, DROP_TICKS = 24, 5           # gouttes : 24 x 5 = 120 ticks
LOOP_TICKS = 120
GEN = [
    {'file': 'decor_magenta.png', 'images': ['Underground_Lake_shore_TDS.png'], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery Dungeon '
     'Explorers of Sky, Underground Lake shore): same pale yellow sand with soft stippled texture, same olive-khaki '
     'bumpy cave walls made of stacked rounded rock lumps with dark gaps, same tall rock pillars rising from the water, '
     'same small pointed stalagmites standing in the water. Make a NEW, larger top-down map. WIDE LANDSCAPE 4:3 '
     '(1200x896), zoomed out so the cave feels vast. Layout: the player arrives at the SOUTH (bottom edge center) on a '
     'wide pale-yellow sand path between bumpy olive-khaki rock walls; the path opens into a wide rounded pale-yellow '
     'sand shore arena in the lower-middle of the map; the entire NORTHERN half of the map (and wrapping slightly '
     'around the left and right flanks of the sand shore) is a vast underground lake. Two massive tall rock pillars '
     'stand in the lake at the north on the left and right of center, with several small pointed stalagmites dotting '
     'the lake water around them; thick bumpy olive-khaki cave rock walls frame the left edge, right edge, bottom '
     'corners, and upper-left/upper-right corners. No dark tunnel opening at the top. IMPORTANT: fill the entire '
     'underground lake water surface with flat pure solid magenta #FF00FF (RGB 255, 0, 255), with no ripples, no cyan '
     'glow, and no reflections painted on the water. No characters, no text, no UI, no border.'},
    {'file': 'sol_complet.png', 'images': ['source/fin_underground_lake_v1/bruts/decor_magenta.png'], 'prompt':
     'Same image, same framing and pixel-art style (1200x896), but remove the magenta lake, the two tall rock pillars, '
     'and all small pointed stalagmites in the lake, replacing them with seamless plain pale yellow stippled sand '
     'ground; keep the outer olive-khaki bumpy cave walls at the exact same pixel positions. No characters, no text, '
     'no UI, no border.'},
    {'file': 'gouttes_ronds_poses.png', 'images': ['Underground_Lake_shore_TDS.png'],
     'reutilise_de': 'source/entree_underground_lake_sud_nord_v1/bruts/gouttes_ronds_poses.png', 'prompt':
     'Pixel-art sprite sheet on a flat pure magenta #FF00FF background, same style and colors as the reference. 2 rows '
     'of 6 small separate sprites. Row 1: a pale blue water drop falling then splashing. Row 2: a thin pale blue ripple '
     'ring growing from small to large. Sprites well separated, no text.'},
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


EUL1 = loadmod('eul1_build', R / 'source/entree_underground_lake_sud_nord_v1/build.py')
V2, V1 = EUL1.V2, EUL1.V1
JM, BM = EUL1.JM, EUL1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, place, cell_grid, close_, open_ = EUL1.keep_large, EUL1.place, EUL1.cell_grid, EUL1.close_, EUL1.open_
down_class, down_full, rgba, resize_plane, quantize_group = (
    EUL1.down_class, EUL1.down_full, EUL1.rgba, EUL1.resize_plane, EUL1.quantize_group
)
WPAL, GLOW, GLOW_RING_PX, GLOW_BREATH, GLOW_WOBBLE = (
    EUL1.WPAL, EUL1.GLOW, EUL1.GLOW_RING_PX, EUL1.GLOW_BREATH, EUL1.GLOW_WOBBLE
)
POSE_K, POSE_COV, POSE_WIN, DROP_SEQ = EUL1.POSE_K, EUL1.POSE_COV, EUL1.POSE_WIN, EUL1.DROP_SEQ
materials, fidelity = EUL1.materials, EUL1.fidelity
lake_water, glow_frames, sheet_poses, reduce_pose, paste, drop_frames = (
    EUL1.lake_water, EUL1.glow_frames, EUL1.sheet_poses, EUL1.reduce_pose, EUL1.paste, EUL1.drop_frames
)
PALETTE_GROUPS = {'terrain': (['sol_complet', 'sable', 'ombres', 'berge'], 96),
                  'roche': (['roche', 'piliers'], 64)}
STATIC = ['sable', 'ombres', 'berge', 'roche', 'piliers']


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a, f):
    """a : décor, f : sol complet (parois recalées (0, 0) : écart 3,76 contre 7,11 à 1 px)."""
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]
    # Eau : magenta et sa frange violette antialiasée (r-g et b-g > 60), dilatée de 2 px.
    water = nd.binary_dilation((r - g > 60) & (b - g > 60), iterations=2)
    # Sable : grande composante jaune claire, petits trous comblés.
    sandish = (r > 150) & (r - b > 50) & (lum > 140) & ~water
    sand = keep_large(open_(close_(sandish, 2), 1), 20000)
    holes = nd.binary_fill_holes(sand) & ~sand; hl, _ = nd.label(holes)
    hs = nd.sum(holes, hl, range(1, hl.max() + 1)) if hl.max() else []
    sand = (sand | np.isin(hl, [i + 1 for i, v in enumerate(hs) if v < 300])) & ~water
    rockish = ~sand & ~water
    # Ombres : le sable s'assombrit au pied des parois.
    Ls = nd.uniform_filter(lum, 5); dr = nd.distance_transform_edt(~rockish)
    shade = sand & (dr <= 16) & (Ls < 187)
    shade = keep_large(close_(shade, 1), 60) & sand
    # Berge : rebord entre le lac et le sable (<= 34 px de l'eau ET du sable).
    dw = nd.distance_transform_edt(~water); ds = nd.distance_transform_edt(~sand)
    berge = rockish & (dw <= 34) & (ds <= 34)
    # Piliers et stalagmites : roche du décor là où le sol complet diffère (le générateur les a retirés, parois gardées).
    diff = nd.uniform_filter(np.abs(a - f).mean(2).astype(float), 5)
    rest = rockish & ~berge
    pil = rest & (diff > 25)
    pil = nd.binary_fill_holes(keep_large(open_(close_(pil, 2), 2), 120)) & rest
    roche = rest & ~pil
    pl, pn = nd.label(pil)
    return dict(water=water, sable=sand & ~shade, ombres=shade, berge=berge, piliers=pil,
                roche=roche), {'ecart_parois': round(float(diff[roche].mean()), 2),
                               'ecart_piliers': round(float(diff[pil].mean()), 2),
                               'composantes_piliers': int(pn)}


def glow_centres(water):
    """Grande lueur centrale au bord nord du lac, entre et derrière les deux piliers comme sur le rip."""
    return [(W // 2, 16, 176, 84)]


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Underground Lake V1 (FUL2)')
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


def ground_project(stack, blocked, entry_px, boss_px, objectif_px, gfx, tools):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl = json.loads((R / 'cliffdaytest.rsground').read_text(encoding='utf-8-sig'))
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
    o.update(Name={'DefaultText': 'Fin Underground Lake - rive du lac souterrain (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Fin de donjon 4:3 referencee sur le rip Underground Lake (prolonge EUL1) ; lac '
                     'facon Metano aux couleurs exactes du rip sans liseré clair, lueur du lac animee, scintillements '
                     'Metano natifs, gouttes et ronds generes. Marqueurs entrance, boss, objectif ; aucune sortie.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', entry_px), mk('boss', boss_px), mk('objectif', objectif_px)]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
             f'-- {ASSET} : fin de donjon, base d edition, aucune sortie ni warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Underground Lake 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : fin de donjon generee au format 4:3 (ref. rip Underground Lake), lac facon Metano, lueur, gouttes et ronds animes. Pas une aventure jouable.</Description>
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
    poses, pose_pal = sheet_poses(RAW / 'gouttes_ronds_poses.png')
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    fall_ok = visible & (dist > 6)
    ok = visible & (dist > 20) & ~nd.binary_dilation(glow_any, iterations=10) & ~taken
    for s in range(1, 19):
        ok &= np.roll(fall_ok, s, axis=0)
    cand = np.argwhere(ok); emitters, used = [], []
    for y, x in cand[np.random.default_rng(12).permutation(len(cand))]:
        if all(abs(x - ux) > 56 or abs(y - uy) > 56 for uy, ux in used):
            used.append((y, x)); emitters.append((int(x), int(y), (len(emitters) * 3) % DROP_PHASES))
        if len(emitters) == 8:
            break
    gouttes = drop_frames(poses, emitters, visible)
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
    walk_px = (layers['sable'][..., 3] == 255) | (layers['ombres'][..., 3] == 255)
    blocked = cell_grid(~walk_px); gh_, gw_ = blocked.shape
    blocked[0, :] = True; blocked[:, 0] = True; blocked[:, -1] = True
    Image.fromarray(((~blocked) * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    pxs = np.nonzero(walk_px[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    arena = walk_px & (np.arange(H)[:, None] < 432)
    cy, cx = nd.center_of_mass(arena)
    free2 = [(r, c) for r in range(gh_ - 1) for c in range(gw_ - 1) if not blocked[r:r + 2, c:c + 2].any()]
    br, bc = min(free2, key=lambda rc: (rc[0] * 8 + 8 - cy) ** 2 + (rc[1] * 8 + 8 - cx) ** 2)
    boss_px = [bc * 8, br * 8]
    orow, ocol = min((rc for rc in free2 if abs(rc[1] * 8 + 8 - W // 2) <= 64),
                     key=lambda rc: (rc[0], abs(rc[1] * 8 + 8 - W // 2)))
    objectif_px = [ocol * 8, orow * 8]
    reach_eb, exp_eb = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    reach_bo, exp_bo = v1.reachable(blocked, (boss_px[1] // 8, boss_px[0] // 8), (objectif_px[1] // 8, objectif_px[0] // 8))
    assert reach_eb and reach_bo, (reach_eb, reach_bo)

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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 70, 220, 255)), (objectif_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    names = list(POSE_WIN); cw = 36 * 4 + 8
    sheet = Image.new('RGBA', (len(names) * cw + 8, cw + 8), (*WPAL['surface'], 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm]); im = im.resize((im.width * 4, im.height * 4), Image.Resampling.NEAREST)
        sheet.alpha_composite(im, (8 + i * cw + (cw - 8 - im.width) // 2, 8 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_fin_underground_lake_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objectif_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('sable', 'sable'), ('roche', 'roche'), ('roche', 'piliers')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'fin_underground_lake_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'prolonge EUL1 (source/entree_underground_lake_sud_nord_v1) ; aucun emprunt aux branches soeurs',
        'biome': 'Fin Underground Lake : rive du lac souterrain, prolongeant EUL1 ; a confirmer',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet sur magenta '
                  '(lac = magenta), sol complet edite depuis le decor, planche gouttes/ronds reutilisee d EUL1',
        'reference_da': {'file': REF.name, 'sha256': sha(REF), 'titre': 'Rive du lac souterrain (Underground Lake, PMD Explorers)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'source/fin_underground_lake_v1/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'sol_complet': {'recalage_px': [0, 0], 'ecart_moyen_parois': 3.76, 'ecart_decale_1px': 7.11,
                        'note': 'le generateur a garde les parois (sous le calque parois) ; lac, piliers et stalagmites '
                                'remplaces par du sable', 'ecarts_segmentation': seg},
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne',
                         'brut': fid, 'calques_finaux': final_fid,
                         'eau_et_lueur': 'couleurs EXACTES du rip (test : sous-ensemble des 69 couleurs du rip)'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': 'eau = magenta et frange violette (r-g > 60 et b-g > 60) dilates 2 px ; sable = jaune clair '
                        '(r > 150, r-b > 50, lum > 140), grande composante, trous < 300 px combles ; ombres = sable a '
                        '<= 16 px des parois et lum lissee 5 px < 187 ; berge = ni sable ni eau a <= 34 px de l eau et '
                        'du sable ; piliers = roche ou le sol complet differe (ecart lisse 5 px > 25) ; parois = le reste',
        'layers': layer_list,
        'water': {'phases': WATER_PHASES, 'frame_length_ticks': WATER_TICKS, 'couleurs': {k: list(v) for k, v in WPAL.items()},
                  'modele': 'structure et cadence riviere Metano (bande, frange dentelee, accent, aplat, onde voyageuse), '
                            'couleurs EXACTES du rip ; bande = intermediaire ; sans liseré clair de rive',
                  'origine': 'pixels recalcules, pas de tuiles natives'},
        'lueur': {'phases': GLOW_PHASES, 'frame_length_ticks': GLOW_TICKS, 'couleurs': [list(c) for c in GLOW],
                  'centres': [list(c) for c in centres], 'anneau_px': GLOW_RING_PX, 'respiration': GLOW_BREATH,
                  'ondulation': GLOW_WOBBLE,
                  'origine': 'couleurs EXACTES du rip (coeur + 8 anneaux) ; forme, respiration et ondulation creees par nous'},
        'sparkles': {'source': 'source/eau_metano/natifs/Metano_Town_River_Sparkles.tile', 'placements': sparkles,
                     'origine': 'pixels et couleurs Metano NATIFS inchanges (aplat de surface retire)',
                     'zone': 'coeur de la lueur (commun aux 12 phases), pas l eau sombre'},
        'gouttes': {'poses': {k: list(v) for k, v in POSE_WIN.items()}, 'reduction': f'x1/{POSE_K} pour toutes les poses',
                    'palette': [[int(round(c)) for c in p] for p in pose_pal], 'chronologie': DROP_SEQ,
                    'emetteurs': [list(e) for e in emitters], 'phases': DROP_PHASES, 'frame_length_ticks': DROP_TICKS,
                    'origine': 'dessin GENERE reutilise d EUL1 (8 couleurs tirees de la planche) ; chronologie, chute et placement crees par nous'},
        'shadows': 'calque ombres = bande de sable assombrie au pied des parois, separee du rendu genere (pas inventee)',
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objectif_px': objectif_px,
                   'path_found_16x16': bool(reach_eb and reach_bo), 'cells_explored': exp_eb,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors sable (ombres comprises) ; bords nord, gauche et droit bloques ; aucune sortie'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(json.dumps({'sparkles': len(sparkles), 'entry': entry_px, 'boss': boss_px, 'objectif': objectif_px,
                      'blocked': int(blocked.sum()), 'walkable': int((~blocked).sum()), 'emitters': len(emitters),
                      'centres': centres, 'seg': seg, 'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': sum(counts.values())}, indent=1))


if __name__ == '__main__':
    build()
