"""Entrée Sables mouvants sud -> nord V1 (EQS1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « Poursuis le projet » (27 septembre, après EUL1) : carte suivante de la série, biome choisi par l'agent
comme pour EUL1. Référence `witheringdesert.png` (Furnace Desert, zone amie de PMD Rescue Team), jamais utilisée
dans la série des entrées 4:3 sud → nord (déjà servie au duo désert DB1 de dungeon_biomes_v1 et, sur une branche
ancienne, à un biome swap en eau ; relevé du 27 septembre). Méthode « textures canoniques » =
rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor_magenta.png : décor complet 4:3 (1200 x 896), fosse de sable mouvant ET deux chutes de sable en magenta ;
- sol_complet.png : édité depuis le décor (sable seul, stries ocre gardées), recalé (0, 0) ;
- poussiere_poses.png : planche sur magenta (bouffée de poussière, tourbillon de grains).
Calques : sol complet, sable, ombres au pied des roches, bord de la fosse, roches, pierres dressées, entrée sombre.
Animations, chacune sur son calque, boucles fermées :
- fosse de sable mouvant : lignes de 1 px aux 4 couleurs EXACTES du rip (séquence # o . - . o mesurée), lobes qui
  tournent et anneaux qui s'enfoncent vers le centre, 12 x 10 ticks (animation créée) ;
- chutes de sable : chevrons aux 4 couleurs EXACTES du rip, défilement 4 px vers le sud, 24 x 5 ticks ;
- poussière au pied des chutes et tourbillons de grains (poses générées), 24 x 5 ticks ;
- rayons de soleil : overlay (255,255,191) à alpha par paliers (couleur du rip, alpha ajusté sur le rip), qui
  respirent, 12 x 10 ticks.
Scène : PPCM(120, 120, 120, 120) = 120 ticks = 2 s.
Lancer : .venv/bin/python source/entree_sables_mouvants_sud_nord_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF = R / 'witheringdesert.png'
OUT = R / 'renders/entree_sables_mouvants_sud_nord_v1'
STAGE = R / '.cache/entree_sables_mouvants_sud_nord_v1/entree_sables_mouvants_sud_nord'
NAMESPACE = 'entree_sables_mouvants_sud_nord'
ASSET = 'eqs1_entree_sables_mouvants'
PFX = 'EQS1'
W, H = 768, 576
SRC = (1200, 896)
PIT_PHASES, PIT_TICKS = 12, 10            # fosse : 12 x 10 = 120 ticks
FALL_PHASES, FALL_TICKS = 24, 5           # chutes : 24 x 5 = 120 ticks
DUST_PHASES, DUST_TICKS = 24, 5           # poussière : 24 x 5 = 120 ticks
RAY_PHASES, RAY_TICKS = 12, 10            # rayons : 12 x 10 = 120 ticks
LOOP_TICKS = 120
GEN = [
    {'file': 'decor_magenta.png', 'images': ['witheringdesert.png'], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery Dungeon '
     'Explorers of Sky desert): same bright yellow sand with darker ochre wavy ripple strokes, same olive-khaki rock '
     'formations made of stacked flat rounded rock layers with dark gaps, same small standing stones. Make a NEW '
     'top-down map seen from above, WIDE LANDSCAPE 4:3, zoomed out so the desert feels vast. Layout: the player arrives '
     'at the SOUTH (bottom edge center) on sand between rock formations; the sand opens into a wide desert basin; a big '
     'rocky cliff of stacked olive rock layers spans the whole top edge, with a dark cave entrance at the top center '
     'reached by dry sand; two tall vertical sandfalls pour down the cliff face, one on each side of the cave, landing '
     'in small sand piles; a large round quicksand pit sits in the right part of the basin, away from the path; layered '
     'rock formations fill the left and right edges. IMPORTANT: the quicksand pit and the two sandfalls are filled with '
     'flat pure magenta #FF00FF, no texture. No sky, no light rays, no characters, no text, no UI, no border.',
     'essais': 'premier essai, bon du premier coup'},
    {'file': 'sol_complet.png', 'images': ['source/entree_sables_mouvants_sud_nord_v1/bruts/decor_magenta.png'], 'prompt':
     'Same image, same framing and pixel-art style. Remove all rocks, cliffs, standing stones, the cave, the sandfalls '
     'and the magenta pit: replace them with the same bright yellow sand with the same darker ochre wavy ripple strokes '
     'and pale sand patches, so the whole picture is only sand ground.',
     'essais': 'deuxieme essai ; le premier (« only plain bright yellow desert sand ground everywhere ») a rendu un '
               'aplat jaune lisse sans stries ni pixel-art : ecarte (non conserve)'},
    {'file': 'poussiere_poses.png', 'images': ['witheringdesert.png'], 'prompt':
     'Pixel-art sprite sheet on a flat pure magenta #FF00FF background, same style and colors as the reference. 2 rows '
     'of 6 small separate sprites. Row 1: a pale yellow sand dust puff growing from small to big then fading into sparse '
     'grains. Row 2: a small swirl of yellow sand grains blown by the wind, turning. Sprites well separated, no text.',
     'essais': 'premier essai ; 3 rangees rendues au lieu de 2 (la 3e repete le tourbillon) : rangees 1 et 2 seules, '
               'fenetres choisies a la main'},
]
# Couleurs EXACTES du rip (1757 couleurs, dont les dégradés des rayons).
# Fosse : lignes de 1 px, séquence mesurée du bord vers le centre : # o . - . o (période 6 px).
PIT_SEQ = [(255, 255, 95), (255, 239, 95), (255, 223, 95), (255, 231, 95), (255, 223, 95), (255, 239, 95)]
PIT_LOBES, PIT_LOBE_A, PIT_SINK = 6, 2.5, 0.5          # 6 lobes ; 0,5 px/phase vers le centre -> 6 px en 12 phases
# Chutes : fond (255,215,95) + chevrons ; paires (liseré, cœur) dans l'ordre mesuré sur le rip (# / o, o / x, x / o).
FALL_BASE = (255, 215, 95)
FALL_PAIRS = [((255, 255, 95), (255, 231, 95)), ((255, 231, 95), (255, 247, 95)), ((255, 247, 95), (255, 231, 95))]
FALL_PX, FALL_RY = 15, 16                 # treillis : pas horizontal 15 px (mesuré 15), rangées 16 px (mesuré ~18)
FALL_V, FALL_BAND = 8, 5                  # profondeur du V (rip : 7-9 px) et épaisseur de bande (rip : 4-6 px)
FALL_PERIOD = FALL_RY * 6                 # 96 px : quinconce (2 rangées) x cycle des couleurs (3 rangées)
FALL_STEP = FALL_PERIOD // FALL_PHASES    # 4 px vers le sud par phase (48 px/s)
# Rayons : sur le rip, l'éclaircissement est additif (+53 sur le ciel en haut, ~+19 sur le sable plus bas) et
# s'estompe vers le bas. Rendu : overlay (255,255,191) (couleur du rip) ; alpha 0,28-0,41 sur le ciel et 0,30 sur le
# sable -> alpha max 80/255 (0,31), paliers de 16, dernier palier au bord.
RAY_COLOR = (255, 255, 191)
RAY_ALPHA_MAX, RAY_ALPHA_STEP = 80, 16
RAY_SLOPE = 0.95                          # dx/dy mesuré sur le rip (bord du rayon : x 111 à y 40, x 215 à y 150)
RAY_FADE_Y = 0.62                         # fraction de H où l'alpha atteint 0
RAYS = [(-40, 30, 0.0), (110, 20, 2.1), (372, 34, 4.2), (520, 22, 1.0), (650, 16, 3.1)]   # (x en haut, largeur, phase)
RAY_BREATH = 1.5
# Planche : fenêtres (cy, cx, côté multiple de 8) choisies à la main ; réduction x1/8 pour toutes les poses.
POSE_K = 8
POSE_COV = 0.25
POSE_WIN = {'bouffee_0': (127, 97, 48), 'bouffee_1': (128, 296, 80), 'bouffee_2': (130, 500, 128),
            'bouffee_3': (127, 700, 184), 'bouffee_4': (129, 901, 168), 'bouffee_5': (128, 1104, 112),
            'tourbillon_0': (336, 99, 80), 'tourbillon_1': (336, 295, 104), 'tourbillon_2': (338, 497, 104),
            'tourbillon_3': (340, 697, 128), 'tourbillon_4': (340, 899, 152), 'tourbillon_5': (338, 1097, 160)}
PUFF_SEQ = (['bouffee_0', 'bouffee_0', 'bouffee_1', 'bouffee_1', 'bouffee_2', 'bouffee_2', 'bouffee_3', 'bouffee_3',
             'bouffee_3', 'bouffee_4', 'bouffee_4', 'bouffee_5', 'bouffee_5'] + [None] * 11)
SWIRL_SEQ = (['tourbillon_0', 'tourbillon_0', 'tourbillon_1', 'tourbillon_1', 'tourbillon_2', 'tourbillon_2',
              'tourbillon_3', 'tourbillon_3', 'tourbillon_4', 'tourbillon_4', 'tourbillon_5', 'tourbillon_5'] + [None] * 12)
SWIRL_DRIFT = 1                           # px vers l'est par phase active (vent)
assert len(PUFF_SEQ) == len(SWIRL_SEQ) == DUST_PHASES


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, place, cell_grid, close_ = V1.keep_large, V1.place, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'terrain': (['sol_complet', 'sable', 'ombres', 'bord_fosse'], 96),
                  'roche': (['roche', 'pierres'], 64), 'profondeur': (['profondeur'], 12)}
STATIC = ['sable', 'ombres', 'bord_fosse', 'roche', 'pierres', 'profondeur']
ANIMS = ['fosse', 'chutes', 'poussiere', 'rayons']


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


# ---------------------------------------------------------------- fidélité au rip (même classifieur des deux côtés)
def materials(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]; sat = a.max(2) - a.min(2)
    mag = (r - g > 60) & (b - g > 60)
    sand = (r - b > 95) & (r > 175) & ~mag
    rock = (r >= b) & (g >= b) & (r - b < 90) & (lum > 35) & (lum < 200) & (sat < 100) & ~mag
    return {'sable': sand, 'roche': rock}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    """a : décor. Seuils mesurés sur le brut (fenêtres de contrôle) :
    sable (255,237,109) r-b ~146 ; stries ocre r-b 138-180 ; ombre orangée au pied des roches (214,184,94) r-b ~120 ;
    roche olive r-b 7-79, lum 47-171 ; dalles grises sat < 15 ; bouche (26,36,41) lum ~33."""
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    mag = nd.binary_dilation((r - g > 60) & (b - g > 60), iterations=2)            # frange rose antialiasée incluse
    lab, n = nd.label(mag); objs = nd.find_objects(lab)
    falls = np.zeros_like(mag); pit = np.zeros_like(mag)
    for i, s in enumerate(objs):                                                   # chutes : touchent le haut
        (falls if s[0].start == 0 else pit)[lab == i + 1] = True
    # Entrée sombre : aplat lum < 55 près du haut-centre ; ouverture de 4 px (les fentes sombres des roches formaient
    # des filaments reliés), puis dilatation limitée au sombre.
    dark = (lum < 55) & (yy < 260) & (xx > 480) & (xx < 720)
    core = open_(dark, 4); cl, _ = nd.label(core)
    box = np.zeros_like(dark); box[150:200, 580:630] = True
    ids = [i for i in np.unique(cl[box]) if i]
    opening = nd.binary_fill_holes(nd.binary_dilation(cl == ids[0], iterations=4) & dark)
    # Sable (ombres orangées comprises) : r-b > 95 et r > 175 ; grande composante, trous < 400 px (stries) comblés.
    sandish = (r - b > 95) & (r > 175) & ~mag & ~opening
    sand = keep_large(open_(close_(sandish, 2), 1), 20000)
    holes = nd.binary_fill_holes(sand) & ~sand; hl, _ = nd.label(holes)
    hs = nd.sum(holes, hl, range(1, hl.max() + 1)) if hl.max() else []
    sand = (sand | np.isin(hl, [i + 1 for i, v in enumerate(hs) if v < 400])) & ~mag & ~opening
    rock = ~sand & ~mag & ~opening
    Ls = nd.uniform_filter(lum, 5)
    # Bord de la fosse : lèvre sombre (classée roche) et sable assombri à <= 14 px de la fosse.
    dp = nd.distance_transform_edt(~pit)
    bord = (dp <= 14) & ~pit & (rock | (sand & (Ls < 205)))
    sand &= ~bord; rock &= ~bord
    # Ombres : le sable s'assombrit au pied des roches (lum lissée 174 à 0-3 px, 193 à 3-6, 201 à 6-10, 209 à 10-15,
    # 216 au-delà de 20 px).
    dr = nd.distance_transform_edt(~rock)
    shade = keep_large(close_(sand & (dr <= 16) & (Ls < 200), 1), 60) & sand
    # Pierres dressées : composantes de roche de moins de 5000 px (les masses rocheuses font 80 000 px et plus).
    rl, rn = nd.label(rock); rs = nd.sum(rock, rl, range(1, rn + 1))
    stones = np.isin(rl, [i + 1 for i, v in enumerate(rs) if 150 <= v < 5000])
    specks = np.isin(rl, [i + 1 for i, v in enumerate(rs) if v < 150])            # miettes : rendues au sable
    sand |= specks & ~bord
    masks = dict(fosse=pit, chutes=falls, profondeur=opening, sable=sand & ~shade, ombres=shade, bord_fosse=bord,
                 pierres=stones, roche=rock & ~stones & ~specks)
    seg = {'pierres': int(len([v for v in rs if 150 <= v < 5000])), 'miettes_rendues_au_sable': int((rs < 150).sum()),
           'trous_combles': int(sum(1 for v in hs if v < 400))}
    return masks, seg


# ---------------------------------------------------------------- animations
def pit_frames(pit, ts=range(PIT_PHASES)):
    """Lignes de 1 px (séquence du rip) indexées par la distance au bord ; lobes (6) qui tournent ; les anneaux
    s'enfoncent de 0,5 px par phase. Période 12 : v se décale de 6 px (une séquence) et les lobes d'un tour."""
    d = nd.distance_transform_edt(pit); ys, xs = np.nonzero(pit)
    cy, cx = ys.mean(), xs.mean(); ry, rx = (ys.max() - ys.min()) / 2, (xs.max() - xs.min()) / 2
    yy, xx = np.mgrid[:H, :W]; th = np.arctan2((yy - cy) / ry, (xx - cx) / rx)
    amp = PIT_LOBE_A * np.minimum(1, d / 6)
    frames = []
    for t in ts:
        v = d - PIT_SINK * t + amp * np.sin(PIT_LOBES * th - 2 * np.pi * t / PIT_PHASES)
        idx = np.floor(v).astype(int) % len(PIT_SEQ)
        a = np.zeros((H, W, 4), 'uint8')
        for i, c in enumerate(PIT_SEQ):
            a[pit & (idx == i)] = (*c, 255)
        a[pit & (d < 1.5)] = (*PIT_SEQ[0], 255)                                    # liseré clair du bord, fixe
        frames.append(a)
    return frames


def chevron(u, y):
    """Motif des chutes du rip : bandes horizontales en zigzag, pointes des « V » vers le bas (pas horizontal
    15 px, profondeur du V 8 px) ; liseré de 2 px en haut de la bande, cœur de 3 px dessous ; rangées toutes les
    16 px, décalées d'un demi-pas une fois sur deux ; paires de couleurs du rip en cycle de 3 (période 96 px)."""
    out = np.zeros(u.shape + (3,), 'uint8'); out[:] = FALL_BASE
    for k0 in (-1, 0, 1):                                  # rangée courante et voisines (le V déborde de 8 px)
        k = np.floor_divide(y, FALL_RY) + k0
        cu = 7.5 + (FALL_PX / 2) * (k % 2)
        tri = 1 - np.abs(np.mod(u - cu + FALL_PX / 2, FALL_PX) - FALL_PX / 2) / (FALL_PX / 2)
        dy = y - (FALL_RY * k + np.round(FALL_V * tri))
        for c, (rim, fill) in enumerate(FALL_PAIRS):
            sel = np.mod(k, len(FALL_PAIRS)) == c
            out[sel & (dy >= 0) & (dy < 2)] = rim
            out[sel & (dy >= 2) & (dy < FALL_BAND)] = fill
    return out


def fall_frames(falls, ts=range(FALL_PHASES)):
    lab, n = nd.label(falls); yy, xx = np.mgrid[:H, :W]
    x0 = np.zeros((H, W), int)
    for i in range(1, n + 1):
        x0[lab == i] = np.nonzero(lab == i)[1].min()
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        c = chevron(xx - x0, yy - FALL_STEP * t)
        a[falls, :3] = c[falls]; a[falls, 3] = 255
        frames.append(a)
    return frames


def ray_frames(ts=range(RAY_PHASES)):
    yy, xx = np.mgrid[:H, :W]; cosv = 1 / np.hypot(1, RAY_SLOPE)
    fade = np.clip(1 - yy / (RAY_FADE_Y * H), 0, 1)
    lvl = np.floor(RAY_ALPHA_MAX * fade / RAY_ALPHA_STEP) * RAY_ALPHA_STEP
    frames = []
    for t in ts:
        al = np.zeros((H, W))
        for x0, w, ph in RAYS:
            hw = w / 2 + RAY_BREATH * np.sin(2 * np.pi * t / RAY_PHASES + ph)
            dist = np.abs(xx - (x0 + RAY_SLOPE * yy)) * cosv
            inside = np.round(dist) <= np.round(hw)
            edge = inside & (np.round(dist) >= np.round(hw) - 1)
            v = np.where(edge, lvl - RAY_ALPHA_STEP, lvl)
            al = np.maximum(al, np.where(inside, np.maximum(v, 0), 0))
        a = np.zeros((H, W, 4), 'uint8'); m = al > 0
        a[m, :3] = RAY_COLOR; a[..., 3] = al.astype('uint8')
        frames.append(a)
    return frames


# ---------------------------------------------------------------- poses générées (planche sur magenta)
def sheet_poses(path):
    src = rgb(path); r, g, b = src.transpose(2, 0, 1)
    bg = ((r - g) > 40) & ((b - g) > 40)
    px = np.concatenate([src[cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2][~bg[cy - s // 2:cy + s // 2, cx - s // 2:cx + s // 2]]
                         for cy, cx, s in POSE_WIN.values()])
    q = Image.fromarray(px.reshape(-1, 1, 3).astype('uint8')).quantize(colors=8, method=Image.Quantize.MEDIANCUT)
    pal = np.array(q.getpalette()[:24], float).reshape(-1, 3)
    return {name: reduce_pose(src, bg, cy, cx, s, POSE_K, pal, POSE_COV) for name, (cy, cx, s) in POSE_WIN.items()}, pal


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


def paste(frame, spr, cx, cy, clip=None):
    hh, ww = spr.shape[:2]; y0, x0 = int(round(cy)) - hh // 2, int(round(cx)) - ww // 2
    ys0, xs0 = max(0, -y0), max(0, -x0); ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]; m = s[..., 3] > 0
    if clip is not None:
        m &= clip[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1]
    frame[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1][m] = s[m]


def dust_frames(poses, puffs, swirls, ground, ts=range(DUST_PHASES)):
    """Bouffées au pied des chutes (non détourées : elles sont en l'air) ; tourbillons détourés au sable, qui dérivent
    vers l'est pendant leur vie."""
    frames = [np.zeros((H, W, 4), 'uint8') for _ in ts]
    for (cx, cy, off) in puffs:
        for i, t in enumerate(ts):
            nm = PUFF_SEQ[(t + off) % DUST_PHASES]
            if nm:
                paste(frames[i], poses[nm], cx, cy)
    for (cx, cy, off) in swirls:
        for i, t in enumerate(ts):
            k = (t + off) % DUST_PHASES; nm = SWIRL_SEQ[k]
            if nm:
                paste(frames[i], poses[nm], cx + SWIRL_DRIFT * k, cy, ground)
    return frames


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Entree Sables mouvants sud-nord V1 (EQS1)')
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
    if STAGE.exists():
        shutil.rmtree(STAGE)
    with zipfile.ZipFile(R / 'mod_metano_expeditions_pmdo_0812.zip') as z:
        tpl = json.loads(z.read('metano_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground'))
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
    o.update(Name={'DefaultText': 'Entree Sables mouvants - sud vers nord (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip du desert aux sables mouvants ; fosse et chutes '
                     'de sable animees aux couleurs exactes du rip, poussiere et tourbillons generes, rayons de soleil '
                     'en overlay alpha. Collisions de base a verifier. Seuil non raccorde. Biome choisi par l agent.')
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
             f'-- {ASSET} : base d edition, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Entree Sables mouvants sud-nord 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : entree de grotte dans un desert, generee au format 4:3 (ref. rip desert aux sables mouvants), fosse et chutes de sable animees, poussiere, tourbillons et rayons de soleil. Pas une aventure jouable.</Description>
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
    """Écart moyen décor / sol complet sur le sable dégagé du bassin, à (0, 0) et au meilleur décalage de 1 px."""
    r, g, b = a.transpose(2, 0, 1)
    zone = np.zeros(a.shape[:2], bool); zone[380:880, 300:900] = True
    zone &= (r > 200) & (g > 150) & (b < 170) & ~((r - g > 60) & (b - g > 60))
    err = {(dy, dx): float(np.abs(a - np.roll(np.roll(f, dy, 0), dx, 1))[zone].mean())
           for dy in (-1, 0, 1) for dx in (-1, 0, 1)}
    assert min(err, key=err.get) == (0, 0), err
    return {'ecart_moyen_sable': round(err[(0, 0)], 2),
            'ecart_decale_1px': round(min(v for k, v in err.items() if k != (0, 0)), 2)}


def fall_feet(falls):
    """Pied de chaque chute : (x du centre, y du bas au centre), de l'ouest vers l'est."""
    lab, n = nd.label(falls); out = []
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i); cx = int(round(xs.mean()))
        out.append((cx, int(np.nonzero(lab[:, cx] == i)[0].max())))
    return sorted(out)


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
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png'); ref = rgb(REF)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a)
    order = ['fosse', 'chutes', 'profondeur', 'sable', 'ombres', 'bord_fosse', 'pierres', 'roche']
    ex, cols = down_class(a, m, order)
    pit, falls = ex['fosse'], ex['chutes']
    layers = {'sol_complet': rgba(down_full(f), ~pit)}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    fosse = pit_frames(pit)
    chutes = fall_frames(falls)
    rayons = ray_frames()
    # Poussière : 2 bouffées décalées d'une demi-vie au pied de chaque chute ; 3 tourbillons sur le sable dégagé.
    poses, pose_pal = sheet_poses(RAW / 'poussiere_poses.png')
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    feet = fall_feet(falls)
    puffs = []
    for cx, yb in feet:
        puffs += [(cx - 6, yb + 2, 0), (cx + 7, yb + 5, 12)]
    walk = (layers['sable'][..., 3] == 255) | (layers['ombres'][..., 3] == 255)
    dro = nd.distance_transform_edt(walk)
    dpit = nd.distance_transform_edt(~pit)
    ok = walk & (dro > 22) & (dpit > 40)
    ok[:, W - 40:] = False; ok[H - 60:, :] = False
    for cx, yb in feet:
        ok[max(0, yb - 40):yb + 60, cx - 60:cx + 60] = False
    for s in range(0, 13):                                                       # dérive de 12 px vers l'est
        ok &= np.roll(dro > 12, -s, axis=1)
    cand = np.argwhere(ok); rng = np.random.default_rng(23); rng.shuffle(cand); swirls = []
    for y, x in cand:
        if all(abs(int(y) - sy) + abs(int(x) - sx) > 140 for sx, sy, _ in swirls):
            swirls.append((int(x), int(y), 8 * len(swirls)))
        if len(swirls) == 3:
            break
    assert len(swirls) == 3
    poussiere = dust_frames(poses, puffs, swirls, walk)
    anim = {'fosse': (fosse, PIT_TICKS), 'chutes': (chutes, FALL_TICKS), 'poussiere': (poussiere, DUST_TICKS),
            'rayons': (rayons, RAY_TICKS)}
    order_names = ['fosse', 'sol_complet'] + STATIC + ['chutes', 'poussiere', 'rayons']
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
    # Collisions : sable (ombres comprises) praticable ; fosse, bord, roches, pierres, chutes et bouche bloqués.
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    dys, dxs = np.nonzero(ex['profondeur'])
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
    step = 5
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
    names = list(POSE_WIN); cw = 23 * 4 + 8                               # même échelle x4 pour toutes les poses
    sheet = Image.new('RGBA', (6 * cw + 8, 2 * cw + 8), (160, 120, 60, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm]); im = im.resize((im.width * 4, im.height * 4), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 6) * cw, 8 + (i // 6) * cw
        sheet.alpha_composite(im, (cx0 + (cw - 8 - im.width) // 2, cy0 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_entree_sables_mouvants_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, threshold_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('sable', 'sable'), ('roche', 'roche'), ('roche', 'pierres')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'entree_sables_mouvants_sud_nord_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EWC1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'desert aux sables mouvants, choisi par l agent (« Poursuis le projet », suite de « go carte suivante choisis ! »)',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet sur magenta '
                  '(fosse et chutes = magenta), sol complet edite depuis le decor, planche poussiere/tourbillon sur magenta',
        'reference_da': {'file': REF.name, 'sha256': sha(REF), 'titre': 'Furnace Desert, version originale (zone amie de PMD Rescue Team) ; le prompt du decor disait par erreur Explorers of Sky, l image de reference fait foi'},
        'generation': GEN,
        'raw_inputs': [{'file': f'source/entree_sables_mouvants_sud_nord_v1/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'sol_complet': {'recalage_px': [0, 0], **recalage(a, f),
                        'note': 'stries ocre et tas de sable au pied des chutes gardes ; zones pales sous les roches '
                                '(cachees par le calque roches)'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne',
                         'brut': fid, 'calques_finaux': final_fid,
                         'fosse_et_chutes': 'couleurs EXACTES du rip (test : sous-ensemble des couleurs du rip)'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': 'fosse et chutes = magenta et frange (r-g > 60 et b-g > 60) dilates 2 px, chutes = composantes '
                        'qui touchent le haut ; entree sombre = lum < 55 au haut-centre, ouverture 4 px ; sable = r-b > 95 '
                        'et r > 175, grande composante, trous < 400 px combles ; bord de fosse = roche ou sable assombri '
                        '(lum lissee < 205) a <= 14 px de la fosse ; ombres = sable a <= 16 px des roches et lum lissee '
                        '< 200 ; pierres = composantes de roche de 150 a 5000 px ; roches = le reste',
        'layers': layer_list,
        'fosse': {'phases': PIT_PHASES, 'frame_length_ticks': PIT_TICKS, 'sequence': [list(c) for c in PIT_SEQ],
                  'lobes': PIT_LOBES, 'amplitude_lobes_px': PIT_LOBE_A, 'enfoncement_px_par_phase': PIT_SINK,
                  'origine': 'couleurs et sequence de lignes de 1 px EXACTES du rip ; lobes, rotation et enfoncement crees par nous'},
        'chutes': {'phases': FALL_PHASES, 'frame_length_ticks': FALL_TICKS, 'fond': list(FALL_BASE),
                   'paires': [[list(a_), list(b_)] for a_, b_ in FALL_PAIRS], 'pas_px': FALL_STEP, 'periode_px': FALL_PERIOD,
                   'treillis_px': [FALL_PX, FALL_RY], 'pieds': [list(p) for p in feet],
                   'origine': 'couleurs EXACTES du rip ; motif de losanges redessine d apres le rip (treillis mesure), '
                              'defilement cree par nous'},
        'poussiere': {'poses': {k: list(v) for k, v in POSE_WIN.items()}, 'reduction': f'x1/{POSE_K} pour toutes les poses',
                      'palette': [[int(round(c)) for c in p] for p in pose_pal], 'bouffees': [list(p) for p in puffs],
                      'tourbillons': [list(s) for s in swirls], 'sequence_bouffee': PUFF_SEQ, 'sequence_tourbillon': SWIRL_SEQ,
                      'derive_px_par_phase': SWIRL_DRIFT, 'phases': DUST_PHASES, 'frame_length_ticks': DUST_TICKS,
                      'origine': 'dessin GENERE (8 couleurs tirees de la planche) ; chronologie, derive et placement crees par nous'},
        'rayons': {'phases': RAY_PHASES, 'frame_length_ticks': RAY_TICKS, 'couleur': list(RAY_COLOR),
                   'alpha_max': RAY_ALPHA_MAX, 'palier_alpha': RAY_ALPHA_STEP, 'pente_dx_dy': RAY_SLOPE,
                   'fondu_fraction_h': RAY_FADE_Y, 'rayons': [list(r_) for r_ in RAYS], 'respiration_px': RAY_BREATH,
                   'mesure_rip': 'additif sur le rip : +53 sur le ciel (63,127,255) -> (116,180,255), ~+19 sur le halo de '
                                 'sable plus bas ; alpha equivalent 0,28-0,41 (ciel) et 0,30 (sable) avec (255,255,191)',
                   'origine': 'couleur du rip ; overlay alpha (seul calque a alpha intermediaire), respiration creee par nous'},
        'shadows': 'calque ombres = sable assombri orange au pied des roches, separe du rendu genere (pas invente)',
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors sable (ombres comprises)',
                   'seuil': 'premiere case 2 x 2 libre sous l entree sombre'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'threshold': threshold_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'feet': feet, 'swirls': swirls, 'seg': seg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': sum(counts.values())}, indent=1))


if __name__ == '__main__':
    build()
