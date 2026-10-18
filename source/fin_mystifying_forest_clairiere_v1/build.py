#!/usr/bin/env python3
"""Fin Mystifying Forest — Clairière de la Source Lumineuse V1 (FMF3) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Fin de donjon appairée à l'entrée `entree_mystifying_forest_sud_nord_v1` (EMF1).
Références canoniques ROM rendues par `source/outil_maps_pmdsky/recuperer_maps.py rom` :
- `reference/D31P31A.png` : Clairière de la Forêt Trompeuse (Mystifying Forest Clearing, PMD Explorers of Sky) ;
- `reference/D31P11A.png` : Entrée de la Forêt Trompeuse (Mystifying Forest Entrance, chemin de terre et rochers) ;
- `reference/D31P41A.png` : Source Lumineuse (Luminous Spring, 8 tons dorés NDS 5 bits exacts).

Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rips passés au générateur en images=) :
- `bruts/decor_magenta.png` : décor complet 4:3 (1200 x 896), bassin nord-centre de la Source Lumineuse et deux mares
  latérales peints en magenta #FF00FF ;
- `bruts/sol_complet.png` : herbe émeraude complète (1200 x 896) éditée depuis le décor et D31P31A ;
- `bruts/feuilles_lucioles_poses.png` : planche sur magenta #FF00FF (6 poses de feuille en rotation, 6 poses de luciole).

Calques statiques : sol_complet, herbe, chemin, herbes_hautes, rochers, vasque, arbres.
Animations, chacune sur son calque, boucles fermées (PPCM(40, 240) = 240 ticks = 4 s) :
- `eau` : mares latérales façon rivière Métano, couleurs Métano exactes, SANS liseré clair de rive, 4 x 10 ticks ;
- `scintillements` : scintillements Métano natifs sur les mares, 4 x 10 ticks ;
- `source_lumineuse` : bassin sacré au nord-centre animé aux 8 couleurs dorées exactes de D31P41A, 12 x 20 ticks ;
- `feuilles` : feuilles qui tombent des houppiers (poses générées), 48 x 5 ticks ;
- `lucioles` : lucioles dorées à l'orée et autour de la Source Lumineuse (poses générées), 48 x 5 ticks.

Lancer : .venv/bin/python source/fin_mystifying_forest_clairiere_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_CLEAR = HERE / 'reference/D31P31A.png'
REF_ENTRY = HERE / 'reference/D31P11A.png'
REF_SPRING = HERE / 'reference/D31P41A.png'
OUT = R / 'renders/fin_mystifying_forest_clairiere_v1'
STAGE = R / '.cache/fin_mystifying_forest_clairiere_v1/fin_mystifying_forest_clairiere'
NAMESPACE = 'fin_mystifying_forest_clairiere'
ASSET = 'fmf3_fin_mystifying_forest'
PFX = 'FMF3'
W, H = 768, 576
SRC = (1200, 896)
WATER_PHASES, WATER_TICKS = 4, 10
SPRING_PHASES, SPRING_TICKS = 12, 20      # source lumineuse : 12 x 20 = 240 ticks
ANIM_PHASES, ANIM_TICKS = 48, 5           # feuilles et lucioles : 48 x 5 = 240 ticks
LOOP_TICKS = 240

# 8 tons dorés NDS 5 bits exacts relevés au centre de D31P41A.png (Source Lumineuse), du plus lumineux au plus ambré.
SPRING_PAL = [
    (207, 159, 55),
    (199, 159, 55),
    (207, 151, 55),
    (199, 151, 55),
    (199, 151, 47),
    (199, 143, 55),
    (199, 143, 47),
    (199, 135, 55),
]

GEN = [
    {'file': 'decor_magenta.png',
     'images': ['source/fin_mystifying_forest_clairiere_v1/reference/D31P31A.png',
                'source/fin_mystifying_forest_clairiere_v1/reference/D31P11A.png'],
     'prompt': 'Use EXACTLY the same textures, palette and 2D Nintendo DS pixel-art style as the two reference images '
               '(Pokemon Mystery Dungeon Explorers of Sky, Mystifying Forest D31P31A and D31P11A): same bright '
               'emerald-green grass with fine blades, same pinkish-brown dirt path with ragged grass edges, same huge '
               'dark green trees with round clumpy canopies and pale twisted exposed roots wrapping grey-green mossy '
               'boulders, and same dark green tall grass patches along the tree line. Make a NEW, larger top-down '
               'dungeon-end boss clearing map in WIDE LANDSCAPE 4:3 (1200x896), zoomed out so the clearing feels vast. '
               'Pure natural forest decor (no buildings, no statues, no altars, no characters, no text, no UI, no '
               'border): the player arrives at the SOUTH (bottom edge center) on the pinkish-brown dirt path; the path '
               'opens into a wide central oval clearing of bright emerald-green grass. Huge ancient trees with clumpy '
               'green canopies, pale twisted roots and mossy boulders completely enclose the left, right and top '
               '(NORTH) edges of the clearing so there is no north exit tunnel and no sky visible. At the NORTH-CENTER '
               'of the clearing in front of the northern tree roots is a natural circular spring basin rimmed with '
               'mossy stones and pale roots, and on the left and right sides of the clearing near the trees are two '
               'small calm forest ponds. IMPORTANT: fill the water surface inside the north-center circular spring '
               'basin and inside the two small side ponds with flat solid pure magenta #FF00FF (RGB 255, 0, 255), with '
               'no ripples or reflections inside the magenta.'},
    {'file': 'sol_complet.png',
     'images': ['source/fin_mystifying_forest_clairiere_v1/bruts/decor_magenta.png'],
     'prompt': 'Generate an image: edit this 4:3 pixel-art forest clearing map by removing the trees, boulders, dirt '
               'path, and pink ponds so the bright green grass meadow covers the entire 1200x896 canvas.'},
    {'file': 'feuilles_lucioles_poses.png',
     'images': ['source/fin_mystifying_forest_clairiere_v1/reference/D31P11A.png'],
     'prompt': 'Sprite sheet on a flat pure magenta #FF00FF background, in EXACTLY the 2D Nintendo DS pixel-art style '
               'and colors of the reference image (Pokemon Mystery Dungeon Explorers of Sky forest). 2 rows x 6 '
               'columns of separate small sprites. Row 1: a single green forest leaf (same greens as the tree '
               'canopies) falling and fluttering, 6 distinct rotation poses. Row 2: a small glowing firefly light mote '
               '(pale yellow-green and golden glow), 6 poses from dim to bright to dim. Each sprite isolated and '
               'centered in its cell with wide flat #FF00FF magenta spacing, no overlap, no text, no grid lines.'},
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V2 = loadmod('ewc2_build', R / 'source/entree_waterfall_cave_sud_nord_v2/build.py')
V1 = V2.V1
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, place, cell_grid, close_ = V1.keep_large, V1.place, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PAL = BM.PAL
STATIC = ['herbe', 'chemin', 'herbes_hautes', 'rochers', 'vasque', 'arbres']
PALETTE_GROUPS = {
    'terrain': (['sol_complet', 'herbe', 'herbes_hautes'], 80),
    'chemin': (['chemin'], 16),
    'arbres': (['arbres'], 40),
    'pierre': (['rochers', 'vasque'], 24),
}


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


# ---------------------------------------------------------------- fidélité aux rips D31P31A / D31P11A
def materials(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]; sat = a.max(2) - a.min(2)
    mag = (r > g * 1.4) & (b > g * 1.25) & (r > 140) & (b > 120)
    path = (r >= g - 6) & (r - b > 10) & (lum > 110) & (lum < 215) & ~mag
    grass = (g > r + 40) & (g > b + 35) & (lum > 95) & ~mag
    canopy = (b > 0.72 * g) & (g > r + 12) & (lum < 92) & (lum > 32) & ~mag
    rock = (sat < 55) & (lum > 105) & (g >= r - 4) & ~path & ~mag
    return {'herbe': grass, 'chemin': path, 'feuillage_sombre': canopy, 'roche_racines': rock}


def fidelity(decor, ref_clear, ref_entry):
    fc, fe, fd = materials(ref_clear), materials(ref_entry), materials(decor)
    out = {}
    for k in ('herbe', 'chemin', 'feuillage_sombre', 'roche_racines'):
        ref_arr = ref_entry if k == 'chemin' else ref_clear
        ref_mask = fe[k] if k == 'chemin' else fc[k]
        mr, md = ref_arr[ref_mask].mean(0), decor[fd[k]].mean(0)
        out[k] = {
            'ref': 'D31P11A.png' if k == 'chemin' else 'D31P31A.png',
            'rip_rgb': [round(float(v), 1) for v in mr],
            'decor_rgb': [round(float(v), 1) for v in md],
            'distance': round(float(np.linalg.norm(mr - md)), 1),
        }
    return out


# ---------------------------------------------------------------- segmentation pleine résolution (1200 x 896)
def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]; sat = a.max(2) - a.min(2)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    mag = (r > g * 1.4) & (b > g * 1.25) & (r > 140) & (b > 120)
    mag_dil = nd.binary_dilation(mag, iterations=2)
    # Bassin nord-centre = Source Lumineuse ; mares gauche/droite = eau Métano.
    spring = mag_dil & (yy < 340)
    water = mag_dil & ~spring
    # Vasque circulaire de pierres moussues et de racines entourant la Source Lumineuse.
    dist_spring = nd.distance_transform_edt(~spring)
    pale = (sat < 65) & (lum > 85) & ~water & ~spring
    vasque = (dist_spring <= 44) & (yy > 165) & (yy < 325) & (xx > 495) & (xx < 705) & ~spring & (pale | (dist_spring <= 26))
    vasque = nd.binary_fill_holes(close_(vasque, 2)) & ~spring & ~water
    # Chemin de terre rose-brun au sud.
    path = (r >= g - 6) & (r - b > 10) & (lum > 110) & (lum < 215) & (yy > 600) & ~water & ~spring & ~vasque
    path = nd.binary_fill_holes(keep_large(open_(close_(path, 2), 1), 3000)) & ~water & ~spring & ~vasque
    # Le liseré herbe/terre autour du chemin ne doit pas être pris pour de la roche/racine pâle.
    pale = (sat < 65) & (lum > 85) & ~water & ~spring & ~nd.binary_dilation(path, iterations=12)
    # Herbe claire praticable de la grande clairière centrale.
    bg = nd.uniform_filter(b / np.maximum(g, 1), 11); L = nd.uniform_filter(lum, 11)
    clear = (L > 92) & (bg < 0.65) & ~path & ~water & ~spring & ~vasque & ~pale
    clear = open_(close_(clear, 2), 2)
    cl, _ = nd.label(clear); touch = set(np.unique(cl[nd.binary_dilation(path, iterations=8) & clear])) - {0}
    walk = keep_large(np.isin(cl, list(touch)), 5000)
    U = close_(walk | path, 6)
    holes = nd.binary_fill_holes(U) & ~U; hl, _ = nd.label(holes)
    sizes = nd.sum(holes, hl, range(1, hl.max() + 1)) if hl.max() else []
    small = np.isin(hl, [i + 1 for i, v in enumerate(sizes) if v < 1500])
    walk = (U | small) & ~path & ~water & ~spring & ~vasque
    # Toute frange entre le chemin et l'herbe de la clairière reste dans l'herbe praticable.
    seam = nd.binary_dilation(path, iterations=8) & nd.binary_dilation(walk, iterations=8) & ~path & ~water & ~spring & ~vasque
    walk |= seam
    # Rocher isolé dans la clairière et rochers de l'orée.
    inner_rock = keep_large(pale & walk, 150)
    walk = walk & ~inner_rock
    nonwalk = ~(water | spring | vasque | path | walk)
    hd = nd.uniform_filter((lum > 115).astype(float), 15)
    canopy = nonwalk & ~pale & (((bg > 0.72) & (L < 110)) | (hd > 0.12))
    canopy = nd.binary_fill_holes(keep_large(open_(close_(canopy, 3), 3), 1500)) & nonwalk & ~pale
    yk, xk = np.mgrid[-6:7, -6:7]; disk = (xk ** 2 + yk ** 2) <= 36
    seed = nd.binary_opening(np.pad(pale & nonwalk, 8, mode='edge'), structure=disk)[8:-8, 8:-8]
    blobs = keep_large(nd.binary_dilation(seed, iterations=3) & pale & nonwalk, 200)
    bl, _ = nd.label(blobs); rocks = np.zeros_like(blobs)
    for i, sl in enumerate(nd.find_objects(bl), 1):
        comp = bl[sl] == i; px = a[sl][comp]
        if (px[:, 0] - px[:, 2]).mean() < 12:
            rocks[sl] |= comp
    rocks = ((nd.binary_fill_holes(close_(rocks, 3)) & nonwalk) | inner_rock) & ~vasque
    trees = (canopy | (pale & nonwalk)) & ~rocks & ~vasque & nonwalk
    tall = nonwalk & ~trees & ~rocks & ~vasque
    return dict(water=water, source_lumineuse=spring, vasque=vasque, chemin=path, rochers=rocks, arbres=trees,
                herbes_hautes=tall, herbe=walk)


# ---------------------------------------------------------------- Source Lumineuse (8 tons dorés exacts de D31P41A)
def spring_frames(spring_mask, visible_spring, ts=range(SPRING_PHASES)):
    """Onde concentrique dorée dans la vasque nord-centre aux 8 couleurs exactes de D31P41A.png (12 phases x 20 ticks)."""
    ys, xs = np.nonzero(spring_mask)
    cy, cx = float(ys.mean()), float(xs.mean())
    ry = max(float(ys.max() - ys.min()) * 0.52, 1.0)
    rx = max(float(xs.max() - xs.min()) * 0.52, 1.0)
    yy, xx = np.mgrid[:H, :W]
    dx, dy = (xx - cx) / rx, (yy - cy) / ry
    rho = np.hypot(dx, dy)
    ang = np.arctan2(dy, dx)
    n_pal = len(SPRING_PAL)
    frames = []
    for t in ts:
        ph = 2 * np.pi * t / SPRING_PHASES
        # Respiration concentrique + ondulation douce à 3 lobes
        wobble = 0.08 * np.sin(3 * ang - ph) + 0.06 * np.cos(2 * ang + ph)
        breath = 1.0 + 0.07 * np.sin(ph)
        val = (rho / breath + wobble) * (n_pal - 1) - 0.65 * np.sin(ph - rho * 2.2)
        idx = np.clip(np.floor(val).astype(int), 0, n_pal - 1)
        a = np.zeros((H, W, 4), 'uint8')
        for i, col in enumerate(SPRING_PAL):
            sel = spring_mask & (idx == i)
            a[sel] = (*col, 255)
        # Bord immédiat contre la vasque : ton ambré le plus profond
        rim = spring_mask & ~visible_spring
        a[rim] = (*SPRING_PAL[-1], 255)
        frames.append(a)
    return frames, [round(cx, 1), round(cy, 1), round(rx, 1), round(ry, 1)]


# ---------------------------------------------------------------- poses générées (feuilles et lucioles)
def sheet_poses(path):
    src = rgb(path); r, g, b = src.transpose(2, 0, 1)
    bg = ((r - g) > 25) & ((b - g) > 10)
    obj = nd.binary_dilation(~bg, iterations=6); lab, n = nd.label(obj)
    items = []
    for i, sl in enumerate(nd.find_objects(lab), 1):
        m = (lab[sl] == i) & ~bg[sl]
        if m.sum() < 120:
            continue
        ys, xs = np.nonzero(m); items.append(((sl[0].start + ys.mean()), (sl[1].start + xs.mean()), sl, m))
    row_top = sorted([it for it in items if it[0] < 380], key=lambda t: t[1])[:6]
    # Les 6 colonnes de lucioles en rangée basse (x ~ 114, 343, 572, 801, 1031, 1259)
    bot_cols = [114, 343, 572, 801, 1031, 1259]
    row_bot = []
    for cx_t in bot_cols:
         m = np.zeros_like(bg)
         m[470:680, max(0, cx_t - 95):min(bg.shape[1], cx_t + 95)] = ~bg[470:680, max(0, cx_t - 95):min(bg.shape[1], cx_t + 95)]
         ys, xs = np.nonzero(m)
         sl = (slice(int(ys.min()), int(ys.max()) + 1), slice(int(xs.min()), int(xs.max()) + 1))
         row_bot.append((float(ys.mean()), float(xs.mean()), sl, m[sl]))
    return src, bg, [row_top, row_bot]


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


def paste(frame, spr, cx, cy):
    hh, ww = spr.shape[:2]; y0, x0 = int(round(cy)) - hh // 2, int(round(cx)) - ww // 2
    ys0, xs0 = max(0, -y0), max(0, -x0); ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]; m = s[..., 3] > 0
    frame[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1][m] = s[m]


LEAF_FALL = 30
FLY_PULSE = [0, 1, 2, 3, 3, 2, 3, 4, 5, -1, -1, -1]


def leaf_frames(poses, starts, clip, ts=range(ANIM_PHASES)):
    frames = [np.zeros((H, W, 4), 'uint8') for _ in ts]
    for cx, cy, off, drift in starts:
        for i, t in enumerate(ts):
            u = (t + off) % ANIM_PHASES
            if u >= LEAF_FALL:
                continue
            y = cy + u * 1.25
            x = cx + drift * u * 0.25 + 6 * np.sin(2 * np.pi * u / 15)
            paste(frames[i], poses[(u // 2) % len(poses)], x, y)
    for f in frames:
        f[~clip] = 0
    return frames


def firefly_frames(poses, spots, ts=range(ANIM_PHASES)):
    frames = [np.zeros((H, W, 4), 'uint8') for _ in ts]
    for cx, cy, off, rad in spots:
        for i, t in enumerate(ts):
            p = FLY_PULSE[(t + off) % len(FLY_PULSE)]
            if p < 0:
                continue
            ph = 2 * np.pi * (t + off) / ANIM_PHASES
            paste(frames[i], poses[p], cx + rad * np.sin(ph), cy + 0.6 * rad * np.sin(2 * ph))
    return frames


# ---------------------------------------------------------------- ORA et Ground PMDO 0.8.12
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Mystifying Forest - Clairiere Source Lumineuse V1 (FMF3)')
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
    o.update(Name={'DefaultText': 'Fin Mystifying Forest - Clairiere Source Lumineuse (4:3)', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Fin de donjon 4:3 appairee a EMF1, referencee sur D31P31A, D31P11A et D31P41A ; '
                     'mares facon Metano sans lisere clair, scintillements Metano natifs, Source Lumineuse aux 8 tons '
                     'dores exacts de D31P41A, feuilles et lucioles generees. Collisions de base a verifier.')
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
  <Name>Fin Mystifying Forest - Clairiere Source Lumineuse 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : fin de donjon de Mystifying Forest au format 4:3 (ref. D31P31A, D31P11A, D31P41A), Source Lumineuse animee, mares facon Metano, feuilles et lucioles.</Description>
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
    ANIMS = ['eau', 'scintillements', 'source_lumineuse', 'feuilles', 'lucioles']
    if OUT.exists():
        for d in ['calques', 'animation', 'poses', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png')
    ref_clear = rgb(REF_CLEAR); ref_entry = rgb(REF_ENTRY); ref_spring = rgb(REF_SPRING)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m = classify(a)
    order = ['water', 'source_lumineuse', 'vasque', 'chemin', 'rochers', 'arbres', 'herbes_hautes', 'herbe']
    ex, cols = down_class(a, m, order)
    water, spring = ex['water'], ex['source_lumineuse']
    layers = {'sol_complet': rgba(down_full(f), ~(water | spring))}
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
    visible_water = water & ~land
    visible_spring = spring & ~land
    wf, dist = V2.water_phases(water, visible_water)
    sp_frames, sp_geom = spring_frames(spring, visible_spring)
    fams = BM.sparkle_families(); taken = np.zeros((H, W), bool)
    sf = [np.zeros((H, W, 4), 'uint8') for _ in range(WATER_PHASES)]; sparkles = []
    for fi, (name, frames) in enumerate(fams.items()):
        hh, ww = frames[0].shape[:2]
        for (y, x) in place(visible_water & (dist > 4), (hh, ww), 2, 61 + fi, taken, core=8):
            sparkles.append({'famille': name, 'xy': [x, y]})
            for t in range(WATER_PHASES):
                mm = frames[t][..., 3] > 0; sf[t][y:y+hh, x:x+ww][mm] = frames[t][mm]
    for arr in sf:
        arr[~visible_water] = 0
    # Poses générées : feuilles (palette des arbres) et lucioles (8 couleurs).
    src, bgm, rows = sheet_poses(RAW / 'feuilles_lucioles_poses.png')
    assert len(rows) == 2 and len(rows[0]) == 6 and len(rows[1]) == 6, [len(r_) for r_ in rows]
    tree_pal = np.unique(layers['arbres'][ex['arbres']][:, :3], axis=0).astype(float)
    leaves = [reduce_pose(src, bgm, cy, cx, 240, 24, tree_pal, 0.25) for cy, cx, _, _ in rows[0]]
    fly_px = np.concatenate([src[sl][mm] for _, _, sl, mm in rows[1]])
    qf = Image.fromarray(fly_px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=8, method=Image.Quantize.MEDIANCUT)
    fly_pal = np.array(qf.getpalette()[:24], float).reshape(-1, 3)
    flies = [reduce_pose(src, bgm, cy, cx, 144, 24, fly_pal, 0.12) for cy, cx, _, _ in rows[1]]
    for i, p in enumerate(leaves):
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_feuille_{i}.png')
    for i, p in enumerate(flies):
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_luciole_{i}.png')
    # Feuilles : départs sous le bord inférieur des houppiers qui dominent l'herbe praticable.
    walk_px = (layers['herbe'][..., 3] == 255) | (layers['chemin'][..., 3] == 255)
    can = ex['arbres']; edge = can & ~nd.binary_erosion(can, iterations=2) & np.roll(walk_px | ex['herbes_hautes'], -6, axis=0)
    rng = np.random.default_rng(7); cand = np.argwhere(edge[36:H - 70, 30:W - 30]) + [36, 30]
    starts, used = [], []
    for y, x in cand[rng.permutation(len(cand))]:
        if all(abs(x - ux) > 60 or abs(y - uy) > 60 for uy, ux in used):
            used.append((y, x)); starts.append((int(x), int(y) - 4, (len(starts) * 6) % ANIM_PHASES, 1 if len(starts) % 2 else -1))
        if len(starts) == 8:
            break
    feuilles = leaf_frames(leaves, starts, np.ones((H, W), bool))
    # Lucioles : autour de la vasque de la Source Lumineuse et à l'orée sombre de la clairière.
    darkish = (ex['herbes_hautes'] | nd.binary_dilation(ex['vasque'], iterations=8) | (ex['arbres'] & nd.binary_dilation(walk_px, iterations=10)))
    darkish &= ~nd.binary_dilation(ex['water'] | ex['source_lumineuse'], iterations=4)
    cand = np.argwhere(darkish[24:H - 24, 24:W - 24]) + [24, 24]; spots, used = [], []
    for y, x in cand[np.random.default_rng(11).permutation(len(cand))]:
        if all(abs(x - ux) > 48 or abs(y - uy) > 48 for uy, ux in used):
            used.append((y, x)); spots.append((int(x), int(y), (len(spots) * 5) % ANIM_PHASES, 4 + (len(spots) % 3) * 2))
        if len(spots) == 14:
            break
    lucioles = firefly_frames(flies, spots)
    # Exports
    anim = {
        'eau': (wf, WATER_TICKS),
        'scintillements': (sf, WATER_TICKS),
        'source_lumineuse': (sp_frames, SPRING_TICKS),
        'feuilles': (feuilles, ANIM_TICKS),
        'lucioles': (lucioles, ANIM_TICKS),
    }
    order_names = ['eau', 'scintillements', 'source_lumineuse', 'sol_complet'] + STATIC + ['feuilles', 'lucioles']
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
    # Collisions et marqueurs : entrance au sud sur le chemin, boss au centre de la clairière, objectif devant la vasque nord.
    blocked = cell_grid(~walk_px); gh_, gw_ = blocked.shape
    pth = layers['chemin'][..., 3] == 255
    pxs = np.nonzero(pth[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    boss_px = [W // 2 - 8, H // 2 + 8]
    while blocked[boss_px[1] // 8:boss_px[1] // 8 + 2, boss_px[0] // 8:boss_px[0] // 8 + 2].any():
        boss_px[1] += 8
    vy, vx = np.nonzero(ex['vasque'])
    goal_px = [int(round(vx.mean() / 8)) * 8 - 8, (int(vy.max()) // 8 + 1) * 8]
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
    sheet = Image.new('RGBA', (6 * 68, 2 * 68), (60, 110, 60, 255))
    for r_, seq in enumerate((leaves, flies)):
        for i, p in enumerate(seq):
            im = Image.fromarray(p); sc = 60 // max(im.size)
            sheet.alpha_composite(im.resize((im.width * sc, im.height * sc), Image.Resampling.NEAREST), (i * 68 + 4, r_ * 68 + 4))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_fin_mystifying_forest_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, goal_px, gfx, tools)
    fid = fidelity(a, ref_clear, ref_entry)
    final_fid = {}
    for k, nm in (('herbe', 'herbe'), ('chemin', 'chemin'), ('feuillage_sombre', 'arbres'), ('roche_racines', 'rochers')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[k] = {'calque': nm, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                        'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'fin_mystifying_forest_clairiere_v1', 'prefix': PFX, 'associated_entry': 'EMF1',
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'base': 'branche de session ; appairee a entree_mystifying_forest_sud_nord_v1 (EMF1)',
        'biome': 'Mystifying Forest Clearing & Luminous Spring (D31P31A, D31P11A, D31P41A)',
        'method': 'textures canoniques = rendu genere REFERENCE : rips D31P31A et D31P11A passes au generateur ; '
                  'decor complet sur magenta (Source Lumineuse et mares = magenta), herbe complete editee depuis le decor, '
                  'planche feuilles/lucioles sur magenta',
        'reference_da': {
            'file': 'source/fin_mystifying_forest_clairiere_v1/reference/D31P31A.png',
            'sha256': sha(REF_CLEAR),
            'entry_file': 'source/fin_mystifying_forest_clairiere_v1/reference/D31P11A.png',
            'entry_sha256': sha(REF_ENTRY),
            'spring_file': 'source/fin_mystifying_forest_clairiere_v1/reference/D31P41A.png',
            'spring_sha256': sha(REF_SPRING),
            'titre': 'Clairiere et Source Lumineuse de Mystifying Forest (PMD Explorers of Sky, D31P31A / D31P11A / D31P41A)',
        },
        'generation': GEN,
        'raw_inputs': [{'file': f'source/fin_mystifying_forest_clairiere_v1/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur les rips D31P31A/D31P11A et sur le brut ; distance euclidienne',
                         'brut': fid, 'calques_finaux': final_fid},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'layers': layer_list,
        'water': {'phases': WATER_PHASES, 'frame_length_ticks': WATER_TICKS,
                  'couleurs': {k: list(v) for k, v in PAL.items() if k != 'clair'},
                  'modele': 'structure et cadence riviere Metano, couleurs Metano EXACTES, sans lisere de rive',
                  'origine': 'pixels recalcules, pas de tuiles natives'},
        'source_lumineuse': {'phases': SPRING_PHASES, 'frame_length_ticks': SPRING_TICKS,
                             'couleurs': [list(c) for c in SPRING_PAL], 'geometrie': sp_geom,
                             'origine': '8 tons dores NDS 5 bits EXACTS de D31P41A.png ; onde concentrique et respiration creees par nous'},
        'sparkles': {'source': 'source/eau_metano/natifs/Metano_Town_River_Sparkles.tile', 'placements': sparkles,
                     'origine': 'pixels et couleurs Metano NATIFS inchanges (aplat de surface retire)'},
        'feuilles': {'poses': len(leaves), 'taille_px': list(leaves[0].shape[:2]), 'reduction': 'fenetre 240 px -> 10 px (x1/24)',
                     'palette': 'couleurs du calque arbres', 'departs': [list(s) for s in starts],
                     'chute_phases': LEAF_FALL, 'phases': ANIM_PHASES, 'frame_length_ticks': ANIM_TICKS,
                     'origine': 'dessin GENERE ; trajectoires et chronologie creees par nous'},
        'lucioles': {'poses': len(flies), 'taille_px': list(flies[0].shape[:2]), 'reduction': 'fenetre 144 px -> 6 px (x1/24)',
                     'palette': '8 couleurs tirees des lucioles generees', 'pulsation': FLY_PULSE,
                     'points': [list(s) for s in spots], 'phases': ANIM_PHASES, 'frame_length_ticks': ANIM_TICKS,
                     'origine': 'dessin GENERE ; boucles de Lissajous et pulsation creees par nous'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'threshold_px': goal_px, 'path_found_16x16': bool(ok1 and ok2),
                   'cells_explored': exp1, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors herbe de la clairiere et chemin',
                   'seuil': 'devant la vasque nord-centre de la Source Lumineuse'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'sparkles': len(sparkles), 'entry': entry_px, 'boss': boss_px, 'goal': goal_px,
                      'blocked': int(blocked.sum()), 'walkable': int((~blocked).sum()),
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()},
                      'tiles': sum(counts.values())}, indent=1))


if __name__ == '__main__':
    build()
