"""Entrée Grotte aux vasques sud -> nord V1 (EGV1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases de 8 px).

Demande (16 octobre 2026) : « Poursuis le projet [...] méthode création de map pmd texture canonique ! Méthode de
production des maps PMD (générateur + pipeline natif) ». Les quatre fins restantes de la série (Clairière tropicale,
Couloir violet, Mt. Thunder, Jardin secret) existent déjà sur les branches sœurs et l'utilisateur y a demandé de passer
aux zones inédites : biome NEUF choisi par l'agent (à confirmer), sur une référence ROM utilisée par AUCUNE branche des
dépôts projet-pmdo et projet-creation-pmdo (relevé du 16 octobre) : D56P12A, grotte dorée à vasques turquoise en
terrasses (PMD Explorers of Sky, rendu skytemple depuis pret/pmd-sky, voir `reference.py`). Nom du lieu non identifié
par une capture : « Grotte aux vasques » est un nom de travail.

Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rips passés au générateur en images=) + pipeline natif :
- decor.png : décor complet 4:3 (1200 x 896), références D56P12A + D56P41A ;
- sol_complet.png : édité depuis le décor (sable seul, bord à bord), recalé (0, 0) ;
- source_poses.png : planche sur magenta (bulle de source qui naît puis éclate, anneaux dans l'eau).
Réduction par classe (BOX, attribution exclusive), palettes MEDIANCUT sans tramage, calques transparents 8 px.
L'eau des vasques est ramenée aux 12 couleurs EXACTES de l'eau du rip (plus proche luminance) ; les pixels qui
tombent sur les 5 couleurs animées du rip forment le calque de reflets, animé avec l'animation de palette EXACTE du
BPL (palette 13 : 5 emplacements, 32 frames x 2 ticks, couleurs et séquence relevées dans la ROM).
Calques : sol complet, sol, ombres, vasques, parois, flèches rocheuses, profondeur (bouche du tunnel et fond sarcelle).
Animations, chacune sur son calque, boucles fermées :
- reflets_vasques : 32 x 2 ticks = 64 ticks (cadence du BPL) ;
- bulles_source : 32 x 4 ticks = 128 ticks, poses générées, couleurs ramenées à l'eau du rip, découpées sur l'eau.
Scène : PPCM(64, 128) = 128 ticks.
Lancer : .venv/bin/python source/entree_grotte_vasques_sud_nord_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REFDIR = HERE / 'references'
REF = REFDIR / 'D56P12A.png'
REF2 = REFDIR / 'D56P41A.png'
TEMPLATE = R / 'cliffdaytest.rsground'
OUT = R / 'renders/entree_grotte_vasques_sud_nord_v1'
STAGE = R / '.cache/entree_grotte_vasques_sud_nord_v1/entree_grotte_vasques_sud_nord'
NAMESPACE = 'entree_grotte_vasques_sud_nord'
ASSET = 'egv1_entree_grotte_vasques'
PFX = 'EGV1'
W, H = 768, 576
SRC = (1200, 896)
SAND = (162, 147, 82)                     # sable du décor (fenêtre de contrôle 350:700, 520:760)
REF_CODE = 'D56P12A'
RIP_PHASES, RIP_TICKS = 32, 2             # animation de palette du BPL : 32 frames x 2 ticks
BUB_PHASES, BUB_TICKS = 32, 4             # bulles : 32 x 4 = 128 ticks
LOOP_TICKS = 128
GEN = [
    {'file': 'decor.png', 'images': ['references/D56P12A.png', 'references/D56P41A.png'], 'prompt':
     "Use the reference images' exact pixel-art style, palette and textures (Pokemon Mystery Dungeon Explorers of Sky, "
     'golden spring cave): flat golden-ochre sandy cave floor with fine speckled pixel texture; cave walls made of '
     'piled rounded golden sandstone boulders; cascading travertine terraces of small rounded turquoise water pools '
     'with scalloped pale-gold stone rims and bright cyan-white ripple highlights; small pale rock spires; stalactites '
     'hanging along the top cave wall. Create a NEW map, WIDE LANDSCAPE 4:3, zoomed out, top-down view (1200 x 896). '
     'The player arrives from the SOUTH edge on a wide sandy path between boulder walls, which opens into a large open '
     'golden-sand cave chamber. At the NORTH, in the middle of the back wall under the stalactites, a dark cave tunnel '
     'entrance; the sand floor leads right up to it, with no water in front of it. On the left and right sides of the '
     'chamber, big stepped terraces of turquoise travertine pools climb up between the boulder walls. Four small pale '
     'rock spires stand on the sand, away from the central path. Boulder walls fill the map corners and edges, no '
     'empty black void. IMPORTANT: no characters, no text, no UI, no border, no sparkles.',
     'essais': 'premier essai, 1200 x 896 du premier coup ; vasques sur les pentes de blocs comme dans le rip '
               '(pas de grandes terrasses separees) ; 6 fleches rocheuses au lieu de 4'},
    {'file': 'sol_complet.png', 'images': ['bruts/decor.png'], 'prompt':
     'Edit this pixel-art cave map, same framing and same pixel style: remove everything except the sand floor. Fill '
     'the whole image, edge to edge, with exactly the same sand floor as in the middle of this image: the same muted, '
     'desaturated olive-ochre khaki colour (not bright yellow, not orange), the same small darker speckles and the same '
     'fine pixel texture, same brightness. Keep the floor that is already visible in the middle exactly where it is. '
     'No boulders, no pools, no rocks, no stalactites, no tunnel, no shadows, no border.',
     'essais': 'quatrieme essai : deux appels avec decor + rip D56P12A en images= sans image renvoyee (reponse vide du '
               'modele) ; un troisieme (decor seul, consigne courte) a rendu un sable jaune sature (moyenne 193,157,55 '
               'contre 162,147,82) : ecarte, non conserve ; le quatrieme (teinte imposee) est garde'},
    {'file': 'source_poses.png', 'images': ['references/D56P12A.png'], 'prompt':
     'Pixel-art sprite sheet on a flat pure magenta #FF00FF background, same pixel style and palette as the reference '
     'image (the light cyan and near-white ripple highlights of its turquoise pools). Two rows of six separate small '
     'sprites, evenly spaced, each one centered in its own cell, wide magenta gaps between them. Top row: a spring '
     'bubble welling up from water, six poses: tiny dot, small bubble, round bubble, big bubble, bursting bubble with '
     'tiny droplets, small splash. Bottom row: ripple rings spreading on water, six poses: small ring, larger ring, two '
     'concentric rings, wider double ring, faint wide ring, last faint broken ring. Draw only the light cyan and white '
     'strokes of the bubbles and rings, with no water patch behind them. Hard pixel edges, no anti-aliasing, no glow, '
     'no text, no numbers, no grid lines.',
     'essais': 'premier essai ; 992 x 1068, quatre rangees (21 poses) au lieu de deux : 10 poses retenues (les 6 '
               'bulles, les 4 anneaux epais de la rangee 2) ; anneaux d un pixel ecartes (effaces par la reduction)'},
]
# ---- Poses : fenêtres (cy, cx, h, w) mesurées par composante sur la planche, et réduction (ky, kx).
POSE_COV = 0.25
POSE_WIN = {'bulle_0': (138, 81, 24, 24), 'bulle_1': (138, 246, 60, 60), 'bulle_2': (138, 413, 84, 84),
            'bulle_3': (138, 578, 120, 120), 'bulle_4': (110, 745, 180, 120), 'bulle_5': (138, 915, 108, 132),
            'anneau_0': (401, 81, 64, 60), 'anneau_1': (401, 246, 96, 100), 'anneau_2': (401, 413, 112, 120),
            'anneau_3': (401, 579, 128, 140)}
POSE_K = {k: ((12, 12) if k.startswith('bulle') else (16, 10)) for k in POSE_WIN}   # anneaux aplatis (perspective)
POSES_ECARTEES = {'rangee_2_poses_5_6': 'anneaux d un pixel (944 a 2564 px) : effaces par la reduction',
                  'rangees_3_4': 'poses supplementaires non demandees (11 anneaux), non utilisees'}
BUB_SEQ = (['bulle_0', 'bulle_0', 'bulle_1', 'bulle_1', 'bulle_2', 'bulle_2', 'bulle_3', 'bulle_3', 'bulle_4', 'bulle_5',
            'anneau_0', 'anneau_0', 'anneau_1', 'anneau_1', 'anneau_2', 'anneau_2', 'anneau_3', 'anneau_3']
           + [None] * 14)
BUB_N = 10
assert len(BUB_SEQ) == BUB_PHASES


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM = V1.JM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'terrain': (['sol_complet', 'sol', 'ombres'], 96),
                  'roche': (['parois', 'blocs', 'profondeur'], 96),
                  'rebords': (['rebords'], 64)}
STATIC = ['sol', 'ombres', 'vasques', 'parois', 'blocs', 'profondeur']
ANIMS = ['reflets_vasques', 'bulles_source']


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


# ---------------------------------------------------------------- fidélité au rip (même classifieur des deux côtés)
def materials(a):
    """Sable (rip ~(166,150,90)), eau des vasques (turquoise, lum > 80 : exclut le fond sarcelle (0,71,63)), roche
    (blocs dorés, lum 55-128). Écart-type local sur 5 px pour le sable lisse."""
    r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    m1 = nd.uniform_filter(lum, 5); sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 5) - m1 ** 2, 0))
    sable = (lum > 128) & (lum < 182) & (r - g >= 6) & (r - g <= 26) & (g - b >= 45) & (g - b <= 82) & (sd < 10)
    eau = (g - r > 60) & (b - r > 40) & (lum > 80)
    roche = (r >= g) & (g >= b) & (lum > 55) & (lum < 128) & (r - b > 18) & ~sable
    return {'sable': sable, 'eau': eau, 'roche': roche}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


# ---------------------------------------------------------------- couleurs exactes de l'eau du rip
def rip_water_palette(rip):
    """Couleurs de l'eau DANS les vasques du rip (composantes turquoise claires >= 20 px, dilatées de 2 px, trous
    bouchés), sans la couleur verte du rebord (b/g < 0,8) ; triées par luminance, avec leur nombre de pixels."""
    r, g, b = rip.transpose(2, 0, 1); lum = lum_of(rip)
    bright = (g - r > 60) & (b - r > 40) & (lum > 80)
    lab, n = nd.label(nd.binary_dilation(bright, iterations=2))
    sizes = nd.sum(bright, lab, range(1, n + 1))
    pool = nd.binary_fill_holes(np.isin(lab, 1 + np.flatnonzero(sizes >= 20)))
    water = pool & (g - r > 35) & (b > r + 20) & (b >= 0.8 * g)
    cols, cnt = np.unique(rip[water].reshape(-1, 3), axis=0, return_counts=True)
    o = np.argsort(lum_of(cols))
    return [tuple(int(v) for v in cols[i]) for i in o], [int(cnt[i]) for i in o]


def palette_slots():
    """Animation de palette du BPL (references/palette_anim.json, écrit par reference.py) : 5 emplacements triés par
    luminance de leur couleur en frame 0, 32 couleurs chacun."""
    pa = json.loads((REFDIR / 'palette_anim.json').read_text())['maps'][REF_CODE]
    slots = [[tuple(c) for c in s['couleurs_par_frame']] for s in pa['emplacements']]
    spec = pa['specs_bpl'][0]
    assert len(slots) == 5 and all(len(s) == RIP_PHASES for s in slots)
    assert (spec['frames'], spec['duree_par_frame']) == (RIP_PHASES, RIP_TICKS)
    return slots, pa


def remap_water(colors, water, pal):
    """Chaque pixel d'eau prend la couleur d'eau du rip de luminance la plus proche (ordre des tons conservé)."""
    out = colors.copy()
    pl = lum_of(np.array(pal, float))
    idx = np.abs(lum_of(colors[water].astype(float))[:, None] - pl[None]).argmin(1)
    out[water] = np.array(pal, 'uint8')[idx]
    return out


def reflet_frames(slot_map, slots, ts=range(RIP_PHASES)):
    """slot_map : -1 hors reflet, sinon numéro d'emplacement. Chaque emplacement prend sa couleur EXACTE du BPL."""
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for k, seq in enumerate(slots):
            a[slot_map == k] = (*seq[t % RIP_PHASES], 255)
        frames.append(a)
    return frames


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    """a : décor. Mesures sur le brut (fenêtres de contrôle) : sable (162,147,82), écart-type 5-6 ; bouche du tunnel
    (34,31,41) lum 33 ; fond sarcelle derrière les stalactites (10,76,71) ; eau turquoise (55,166,159) ; blocs dorés
    lum 60-200, écart-type 20-35."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    m1 = nd.uniform_filter(lum, 7); sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 7) - m1 ** 2, 0))
    # Sol : couleur du sable à ±18, fermé 3 px (mouchetures) puis ouvert 2 px, grande composante.
    pure = np.abs(a - SAND).max(-1) <= 18
    core = keep_large(open_(close_(pure, 3), 2), 50000)
    holes = nd.binary_fill_holes(core) & ~core; hl, hn = nd.label(holes)
    hs = nd.sum(holes, hl, range(1, hn + 1)) if hn else np.array([])
    big = np.isin(hl, [i + 1 for i, v in enumerate(hs) if v >= 150])           # flèches rocheuses posées sur le sable
    core |= holes & ~big                                                        # mouchetures : sable
    # Ombres : sable assombri (même teinte, lum 60-140, peu texturé), à <= 30 px du sable ; ombres portées des flèches.
    sandhue = (r > g) & (g > b) & (g - b > 30) & (r - g < 30)
    dcore = nd.distance_transform_edt(~core)
    shade = (dcore > 0) & (dcore <= 30) & sandhue & (sd < 9) & (lum > 60) & (lum < 140)
    # Bouche du tunnel : plus grande tache sombre (lum < 50) du haut-centre, ouverte 3 px, étendue au sombre (< 70).
    dark = (lum < 50) & (yy < 300) & (xx > 450) & (xx < 750)
    cl, cn = nd.label(open_(dark, 3)); sz = nd.sum(dark, cl, range(1, cn + 1))
    mouth = nd.binary_fill_holes(nd.binary_dilation(cl == 1 + int(np.argmax(sz)), iterations=3) & (lum < 70))
    # Fond sarcelle derrière les stalactites : composantes sombres du bandeau du haut (sommet y < 140, y < 175), loin
    # de l'eau claire (l'eau sombre des vasques hautes n'en fait pas partie) : profondeur aussi.
    bright_w = (g - r > 55) & (b - r > 40) & (lum > 60)
    teal0 = ((yy < 175) & (g - r > 25) & (b - r > 15) & (lum < 100) & ~nd.binary_dilation(mouth, iterations=2)
             & ~nd.binary_dilation(bright_w, iterations=4))
    tl, tn = nd.label(teal0)
    tops = nd.minimum(yy, tl, range(1, tn + 1)) if tn else np.array([]); tsz = nd.sum(teal0, tl, range(1, tn + 1)) if tn else np.array([])
    teal = np.isin(tl, 1 + np.flatnonzero((tops < 140) & (tsz >= 40)))
    # Eau des vasques : turquoise franc fermé 1 px, trous bouchés (traînées sombres), plus les pixels de teinte eau,
    # même sombres, à <= 2 px ; rebords : couronne de 6 px autour de l'eau, hors sable.
    wb = close_(bright_w, 1) & (g - r > 30) & (b - r > 25)
    hue = (g - r > 15) & (b - r > 10)
    water = (nd.binary_fill_holes(wb) & hue) | (nd.binary_dilation(wb, iterations=2) & hue)
    water &= ~teal & ~mouth
    shade &= ~mouth & ~water
    shade = keep_large(close_(shade, 1), 120) & ~core & ~mouth & ~water
    blocs = big & ~shade
    rim = nd.binary_dilation(water, iterations=6) & ~water & ~core & ~shade & ~mouth & ~blocs & ~teal
    deep = mouth | teal
    walls = ~core & ~shade & ~deep & ~water & ~rim & ~blocs
    masks = dict(profondeur=deep, sol=core, ombres=shade, eau=water, rebords=rim, blocs=blocs, parois=walls)
    seg = {'fleches_rocheuses': int((hs >= 150).sum()), 'mouchetures_rendues_au_sol': int((hs < 150).sum()),
           'bouche_px': int(mouth.sum()), 'fond_sarcelle_px': int(teal.sum()),
           'bouche_touche_ombres': bool((nd.binary_dilation(mouth, iterations=2) & shade).any())}
    return masks, mouth, seg


# ---------------------------------------------------------------- poses générées (planche sur magenta)
def sheet_poses(path, pal):
    """Fond = magenta pur (g < 90, r-g et b-g > 130) ET pixels teintés de magenta (r-g > 60 et b-g > 60), ni gardés ni
    recolorés. Couleurs des poses ramenées à la couleur d'eau du rip la plus proche (RGB)."""
    src = rgb(path); r, g, b = src.transpose(2, 0, 1)
    bg = ((g < 90) & (r - g > 130) & (b - g > 130)) | ((r - g > 60) & (b - g > 60))
    p = np.array(pal, float)
    return {name: reduce_pose(src, bg, cy, cx, hh, ww, *POSE_K[name], p, POSE_COV)
            for name, (cy, cx, hh, ww) in POSE_WIN.items()}, int((((r - g > 60) & (b - g > 60)) & ~(g < 90)).sum())


def reduce_pose(src, bg, cy, cx, hh, ww, ky, kx, pal, cov_min):
    h, w = bg.shape; y0, x0 = int(cy) - hh // 2, int(cx) - ww // 2; ny, nx = hh // ky, ww // kx
    assert hh % ky == 0 and ww % kx == 0
    pad = np.zeros((hh, ww, 3)); pm = np.zeros((hh, ww), bool)
    sy0, sx0, sy1, sx1 = max(0, y0), max(0, x0), min(h, y0 + hh), min(w, x0 + ww)
    pad[sy0 - y0:sy1 - y0, sx0 - x0:sx1 - x0] = src[sy0:sy1, sx0:sx1]
    pm[sy0 - y0:sy1 - y0, sx0 - x0:sx1 - x0] = ~bg[sy0:sy1, sx0:sx1]
    blk = pm.reshape(ny, ky, nx, kx); cov = blk.mean((1, 3))
    col = (pad * pm[..., None]).reshape(ny, ky, nx, kx, 3).sum((1, 3)) / np.maximum(blk.sum((1, 3)), 1)[..., None]
    o = np.zeros((ny, nx, 4), 'uint8'); o[..., :3] = pal[((col[..., None, :] - pal[None, None]) ** 2).sum(-1).argmin(-1)]
    o[..., 3] = 255; o[cov < cov_min] = 0
    return o


def paste(frame, spr, cx, cy, clip=None):
    hh, ww = spr.shape[:2]; y0, x0 = int(round(cy)) - hh // 2, int(round(cx)) - ww // 2
    ys0, xs0 = max(0, -y0), max(0, -x0); ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]; m = s[..., 3] > 0
    if clip is not None:
        m &= clip[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1]
    frame[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1][m] = s[m]


def bubble_frames(poses, emitters, water, pools, ts=range(BUB_PHASES)):
    """Chaque émetteur (x, y, décalage) : une bulle naît au centre d'une vasque, grossit, éclate, puis des anneaux
    s'élargissent. Bulles découpées sur la vasque (eau + rebord), anneaux sur l'eau seule."""
    frames = [np.zeros((H, W, 4), 'uint8') for _ in ts]
    for (cx, cy, off) in emitters:
        for i, t in enumerate(ts):
            nm = BUB_SEQ[(t + off) % BUB_PHASES]
            if nm:
                paste(frames[i], poses[nm], cx, cy, clip=water if nm.startswith('anneau') else pools)
    return frames


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Entree Grotte aux vasques V1 (EGV1)')
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


def ground_project(stack, blocked, entry_px, threshold_px, gfx, tools):
    """Gabarit : `cliffdaytest.rsground` (Ground PMDO 0.8.12 enregistré par l'utilisateur, racine du dépôt) ; le ZIP
    Métano des anciens lots n'est pas dans ce dépôt. Fond (MapBG vide), BlankBG, rand et NoSwitching du gabarit gardés."""
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl = json.loads(TEMPLATE.read_text(encoding='utf-8-sig'))
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
    o.update(Name={'DefaultText': 'Entree Grotte aux vasques - sud vers nord (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip PMD Sky D56P12A (grotte doree a vasques) ; '
                     'eau des vasques aux couleurs exactes du rip, reflets animes avec l animation de palette exacte du '
                     'BPL (32 x 2 ticks), bulles de source generees. Marqueur donjon_seuil sans warp ni destination. '
                     'Collisions de base a verifier. Biome et portee choisis par l agent.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', entry_px), mk('donjon_seuil', threshold_px)]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
             f'-- {ASSET} : marqueur de seuil seulement, aucun warp ni destination.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Entree Grotte aux vasques 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : entree de donjon sud vers nord dans une grotte doree a vasques turquoise, generee au format 4:3 (ref. rip PMD Sky D56P12A), reflets des vasques animes avec l'animation de palette du jeu, bulles de source. Pas une aventure jouable.</Description>
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
def recalage(a, f):
    """Écart moyen décor / sol complet sur le sable dégagé du centre de la salle, à (0, 0) et au meilleur décalage de
    1 px (le minimum doit être en (0, 0))."""
    zone = np.zeros(a.shape[:2], bool); zone[330:720, 470:800] = True
    zone &= np.abs(a - SAND).max(-1) <= 30
    err = {(dy, dx): float(np.abs(a - np.roll(np.roll(f, dy, 0), dx, 1))[zone].mean())
           for dy in (-1, 0, 1) for dx in (-1, 0, 1)}
    assert min(err, key=err.get) == (0, 0), err
    return {'ecart_moyen_sol': round(err[(0, 0)], 2),
            'ecart_decale_1px': round(min(v for k, v in err.items() if k != (0, 0)), 2)}


def spread(cand, n, gap, rng, taken=()):
    """Tirage de n points (y, x) espacés d'au moins gap (Chebyshev), entre eux et avec taken."""
    cand = cand.copy(); rng.shuffle(cand); out = list(taken)
    k0 = len(out)
    for y, x in cand:
        if all(max(abs(int(y) - py), abs(int(x) - px)) >= gap for py, px in out):
            out.append((int(y), int(x)))
        if len(out) - k0 == n:
            break
    return out[k0:]


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'poses', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)
    a = rgb(RAW / 'decor.png'); f = rgb(RAW / 'sol_complet.png'); ref = rgb(REF); ref2 = rgb(REF2)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, mouth_full, seg = classify(a)
    order = ['profondeur', 'sol', 'ombres', 'eau', 'rebords', 'blocs', 'parois']
    ex, cols = down_class(a, m, order)
    # Eau : couleurs EXACTES de l'eau du rip (plus proche luminance) ; rebords : palette propre de 64 couleurs.
    wpal, wcnt = rip_water_palette(ref)
    slots, pa = palette_slots()
    slot0 = [s[0] for s in slots]
    assert set(slot0) <= set(wpal), (slot0, wpal)
    water_cols = remap_water(cols['eau'], ex['eau'], wpal)
    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in ['sol', 'ombres', 'parois', 'blocs', 'profondeur', 'rebords']:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    vas = q.pop('rebords'); wl = rgba(water_cols, ex['eau'])
    vas[ex['eau']] = wl[ex['eau']]
    q['vasques'] = vas
    layers = q
    ex_l = dict(ex); ex_l['vasques'] = ex['eau'] | ex['rebords']
    for k, v in ex_l.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    walk = (layers['sol'][..., 3] == 255) | (layers['ombres'][..., 3] == 255)
    water = ex['eau']; pools = ex_l['vasques']
    # Reflets : pixels d'eau tombés sur une couleur animée du rip -> emplacement de palette correspondant.
    slot_map = np.full((H, W), -1, int)
    for k, c in enumerate(slot0):
        slot_map[water & (layers['vasques'][..., :3] == c).all(-1)] = k
    Image.fromarray(((slot_map >= 0) * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_reflets.png')
    reflets = reflet_frames(slot_map, slots)
    # Bulles : émetteurs au centre des plus grandes vasques, espacés, moitié à gauche, moitié à droite.
    poses, tinted = sheet_poses(RAW / 'source_poses.png', wpal)
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    lab, nlab = nd.label(water)
    areas = nd.sum(water, lab, range(1, nlab + 1))
    cands = []
    for i in np.argsort(-areas):
        if areas[i] < 300:
            break
        yy_, xx_ = np.nonzero(lab == i + 1)
        cy, cx = int(round(yy_.mean())), int(round(xx_.mean()))
        if not water[cy, cx]:
            j = int(np.argmin((yy_ - cy) ** 2 + (xx_ - cx) ** 2)); cy, cx = int(yy_[j]), int(xx_[j])
        cands.append((cy, cx))
    left = [c for c in cands if c[1] < W // 2]; right = [c for c in cands if c[1] >= W // 2]
    pick = []
    for side in (left, right):
        side = np.array(side)
        pick += spread(side, BUB_N // 2, 56, np.random.default_rng(11))
    assert len(pick) == BUB_N, len(pick)
    emitters = [(x, y, (j * 7) % BUB_PHASES) for j, (y, x) in enumerate(sorted(pick))]
    bulles = bubble_frames(poses, emitters, water, pools)
    anim = {'reflets_vasques': (reflets, RIP_TICKS), 'bulles_source': (bulles, BUB_TICKS)}
    order_names = ['sol_complet'] + STATIC + ANIMS
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
    # Collisions : sol et ombres praticables ; vasques, parois, flèches et profondeur bloquées.
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    mouth = layers['profondeur'][..., 3] == 255
    mouth &= JM.resize_plane(mouth_full.astype(np.float32)) > 0.3                 # la bouche seule, sans le fond sarcelle
    dys, dxs = np.nonzero(mouth)
    tx = int(round(dxs.mean())) // 8 * 8 - 8
    threshold_px = [tx, int(dys.max()) // 8 * 8]
    while blocked[threshold_px[1] // 8:threshold_px[1] // 8 + 2, threshold_px[0] // 8:threshold_px[0] // 8 + 2].any():
        threshold_px[1] += 8
    reach, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert reach, 'pas de chemin 16x16'

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for _, frames, ticks in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
        return im
    step = 2
    scenes = [scene(t) for t in range(0, LOOP_TICKS, step)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(step * 1000 / 60), loop=0, lossless=True)
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    names = list(POSE_WIN); cw = 18 * 4 + 8                                # même échelle x4 pour toutes les poses
    sheet = Image.new('RGBA', (5 * cw + 8, 2 * cw + 8), (0, 71, 63, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm]); im = im.resize((im.width * 4, im.height * 4), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 5) * cw, 8 + (i // 5) * cw
        sheet.alpha_composite(im, (cx0 + (cw - 8 - im.width) // 2, cy0 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_entree_grotte_vasques_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, threshold_px, gfx, tools)
    fid, fid2 = fidelity(a, ref), fidelity(a, ref2)
    final_fid = {}
    for k, nm in (('sable', 'sol'), ('eau', 'vasques'), ('roche', 'parois'), ('roche', 'blocs')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'entree_grotte_vasques_sud_nord_v1', 'prefix': PFX, 'format': '4:3 vaste', 'type': 'entree de donjon sud -> nord',
        'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'base': 'branche de session (main 8d2a5b8 : utilitaires EWC1/Jungle/Bristle, codec pmdo_cote) ; aucun emprunt aux branches soeurs',
        'biome': 'grotte doree a vasques turquoise (rip D56P12A), biome NEUF choisi par l agent apres le releve des branches '
                 '(« Poursuis le projet », 16 octobre), a confirmer',
        'method': 'textures canoniques = rendu genere REFERENCE (rips D56P12A + D56P41A passes au generateur) + pipeline '
                  'natif : decor complet, sol complet edite depuis le decor, planche de poses sur magenta ; reduction par '
                  'classe, palettes, calques 8 px ; eau ramenee aux couleurs exactes du rip ; reflets = animation de '
                  'palette exacte du BPL',
        'reference_da': {'file': f'references/{REF.name}', 'sha256': sha(REF), 'code_rom': REF_CODE,
                         'provenance': 'references/provenance.json (pret/pmd-sky, commit, blobs, sha256)',
                         'seconde_reference': {'file': f'references/{REF2.name}', 'sha256': sha(REF2), 'code_rom': 'D56P41A'},
                         'titre': 'grotte doree a vasques turquoise en terrasses ; nom du lieu non identifie par une capture'},
        'generation': GEN,
        'raw_inputs': [{'file': f'source/entree_grotte_vasques_sud_nord_v1/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'sol_complet': {'recalage_px': [0, 0], **recalage(a, f),
                        'note': 'sable seul bord a bord, teinte imposee (le premier essai garde etait trop jaune)'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne',
                         'brut': fid, 'brut_vs_D56P41A': fid2, 'calques_finaux': final_fid,
                         'eau_et_reflets': 'couleurs EXACTES du rip (test : sous-ensemble des couleurs du rip)'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal ; eau et '
                                     'rebords reduits separement puis reunis dans le calque vasques',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()},
                          'eau': {'couleurs_rip': [list(c) for c in wpal], 'pixels_rip': wcnt,
                                  'regle': 'couleur d eau du rip de luminance la plus proche'}},
        'segmentation': 'sol = couleur du sable a +-18, ferme 3 px puis ouvert 2 px, grande composante, trous < 150 px rendus '
                        'au sable ; fleches = trous >= 150 px hors ombres ; ombres = sable assombri contigu (<= 30 px, lum '
                        '60-140, ecart-type < 9) ; profondeur = bouche du tunnel (lum < 50 puis < 70) + fond sarcelle du '
                        'haut ; eau = turquoise franc ; rebords = couronne de 6 px autour de l eau ; parois = le reste',
        'layers': layer_list,
        'reflets_vasques': {'phases': RIP_PHASES, 'frame_length_ticks': RIP_TICKS, 'source': 'BPL D56P12A, palette 13',
                            'emplacements': [[list(c) for c in s] for s in slots],
                            'sequence_etats_distincts_rip': pa['sequence_etats_distincts'],
                            'pixels': int((slot_map >= 0).sum()),
                            'pixels_par_emplacement': [int((slot_map == k).sum()) for k in range(len(slots))],
                            'origine': 'couleurs ET sequence EXACTES de l animation de palette du jeu ; seuls les pixels '
                                       'qui la portent (eau generee ramenee aux couleurs du rip) viennent du rendu genere'},
        'bulles_source': {'poses': {k: list(v) for k, v in POSE_WIN.items()}, 'reduction': {k: list(v) for k, v in POSE_K.items()},
                          'poses_ecartees': POSES_ECARTEES, 'couverture_min': POSE_COV, 'pixels_teintes_ecartes': tinted,
                          'fond': 'magenta pur et pixels teintes de magenta (r-g > 60 et b-g > 60), ni gardes ni recolores',
                          'couleurs': 'ramenees a la couleur d eau du rip la plus proche (RGB)',
                          'emetteurs': [list(e) for e in emitters], 'sequence': BUB_SEQ,
                          'phases': BUB_PHASES, 'frame_length_ticks': BUB_TICKS,
                          'decoupe': 'bulles sur la vasque (eau + rebord), anneaux sur l eau seule',
                          'origine': 'dessin GENERE (planche) ; chronologie et placement crees par nous'},
        'shadows': 'calque ombres = sable assombri du rendu genere (devant la bouche, contre les parois, ombres portees des fleches)',
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors sol (ombres comprises)',
                   'seuil': 'premiere case 2 x 2 libre sous la bouche du tunnel', 'warp': 'aucun (donjon_seuil = repere)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'template': {'file': TEMPLATE.name, 'sha256': sha(TEMPLATE)}, 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'threshold': threshold_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'emitters': emitters, 'seg': seg,
                      'reflets_px': int((slot_map >= 0).sum()), 'px': {k: int(v.sum()) for k, v in ex_l.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'fidelite_D56P41A': {k: v['distance'] for k, v in fid2.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': sum(counts.values())}, indent=1))


if __name__ == '__main__':
    build()
