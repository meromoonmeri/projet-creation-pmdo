"""Ruines Zarbi, déchirures 1 (RZD1) — fin de zone : ruines que la réalité déchire, d'où sortent les Zarbi, 4:3 (768 x 576).

.venv/bin/python source/ruines_zarbi_v1/build.py

- Références (rendues depuis la ROM par source/outil_maps_pmdsky, recuperer_maps.py rom --only D28,D30) :
  D28P44A (ruines de dalles grises, terre ocre, linteaux sur piliers) pour les matières de la ruine ;
  D30P34A (sommet de tour en ruine : dallage de briques fendu, colonnes brisées, rochers en lévitation, ciel rouge) pour
  la réalité qui se désagrège. Les noms de lieu ne sont PAS affirmés (le préfixe dNN n'est pas le DUNGEON_ID) : seuls les
  codes comptent.
- Rendu généré référencé : deux petites découpes de style x2 (sans les compositions entières), nouveau layout.
  Le brut peint en magenta pur le vide autour du fragment de ruine ET cinq failles dans le dallage ; tout le magenta est
  remplacé par des calques calculés.
- Loi relevée dans la ROM sur D30P34A : seul le vitrail s'anime, animation de palette de 3 rampes de 7 tons (rouge vif ->
  violet sombre -> retour), 7 pas de 10 ticks. Appliquée telle quelle (tons ROM) au bord des failles et, décalée selon la
  distance, aux crevasses peintes autour : l'énergie court le long des fissures.
- Calques : sol complet, vide (anim), sol, ruines, rochers (anim), failles (anim), débris (anim), zarbi (anim).
- Zarbi : Z A R B I ! ? calculés (zarbi.py) ; chacun sort petit d'une faille, en fait le tour en flottant, puis y rentre.
- Marqueurs : entrance (chemin de dalles au sud), autel (dais devant le mur de tablettes à glyphes), faille (devant la
  faille centrale).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'ruines_zarbi_v1'
OUT = R / 'renders' / 'ruines_zarbi_v1' / 'RZD1'
NAMESPACE = 'ruines_zarbi'
STAGE = R / '.cache' / 'ruines_zarbi_v1' / NAMESPACE
ASSET = 'rzd1_ruines_zarbi'
PFX = 'RZD1'
REFS = {'D28P44A': HERE / 'reference/D28P44A.png', 'D30P34A': HERE / 'reference/D30P34A.png'}
STYLE = ['source/ruines_zarbi_v1/reference/D28P44A_decoupe_style_x2.png',
         'source/ruines_zarbi_v1/reference/D30P34A_decoupe_style_x2.png']
W, H = 768, 576
SRC = (1200, 896)
PATH_BOX = (600, 896, 500, 700)             # chemin de dalles dans le brut (y0, y1, x0, x1) : joints rebouchés
LOOP_TICKS = 420
FIDELITY_MAX = 35
# Loi ROM D30P34A : 21 tons du vitrail, 3 rampes de 7 pas (indices dans ROM_TONES), 10 ticks par pas.
ROM_TONES = [(79, 0, 95), (87, 15, 87), (87, 23, 79), (87, 31, 71), (95, 15, 87), (103, 0, 103), (111, 23, 79), (119, 15, 95),
             (127, 15, 119), (127, 23, 79), (127, 31, 71), (135, 15, 95), (135, 31, 63), (151, 23, 95), (167, 23, 79),
             (167, 31, 71), (175, 23, 95), (183, 31, 39), (199, 31, 63), (215, 31, 71), (255, 31, 39)]
RAMP = {'vive': [20, 19, 16, 8, 13, 15, 17], 'moyenne': [18, 14, 11, 5, 7, 9, 12], 'sombre': [10, 6, 4, 0, 1, 2, 3]}
ROM_STEPS, ROM_TICKS = 7, 10
RIFT_PHASES = 21                            # 3 tours de la loi ROM pendant un tour du tourbillon
VOID_PHASES, VOID_TICKS = 7, 30
ROCK_PHASES, ROCK_TICKS = 21, 10
DEBRIS_PHASES, DEBRIS_TICKS = 21, 10
ZARBI_PHASES, ZARBI_TICKS = 84, 5
Z_OUT, Z_ORBIT, Z_BACK, Z_HIDE = 10, 64, 8, 2   # sortie, tour, retour, caché (pas)
# Tons du vide : 3 tons ROM (sombre et moyenne), 3 plus sombres dérivés (même teinte, luminance réduite), étoiles rosées.
VOID_TONES = [(14, 4, 22), (30, 6, 42), (52, 6, 68), (79, 0, 95), (103, 0, 103), (135, 15, 95)]
RIFT_TONES = [(6, 2, 12), (24, 4, 34), (79, 0, 95), (127, 15, 119), (175, 23, 95)]
STAR = [(255, 196, 214), (199, 120, 160)]
# (lettre, faille, décalage en pas, sens) : deux Zarbi d'une même faille tournent dans le même sens, à 42 pas d'écart
LETTERS_RIFT = [('Z', 0, 0, 1), ('A', 1, 6, -1), ('R', 2, 12, 1), ('B', 3, 24, -1), ('I', 4, 36, 1), ('!', 2, 54, 1), ('?', 1, 48, -1)]

ANIM = {'vide': VOID_TICKS, 'rochers': ROCK_TICKS, 'failles': ROM_TICKS, 'debris': DEBRIS_TICKS, 'zarbi': ZARBI_TICKS}
PHASES = {'vide': VOID_PHASES, 'rochers': ROCK_PHASES, 'failles': RIFT_PHASES, 'debris': DEBRIS_PHASES, 'zarbi': ZARBI_PHASES}
assert all(LOOP_TICKS % (PHASES[k] * ANIM[k]) == 0 for k in ANIM)
assert RIFT_PHASES % ROM_STEPS == 0 and ZARBI_TICKS * 2 == ROM_TICKS and Z_OUT + Z_ORBIT + Z_BACK + Z_HIDE == ZARBI_PHASES


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba
BM = JM.BM
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
Z = loadmod('rzd1_zarbi', HERE / 'zarbi.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def morph(fn, m, it):
    p = it + 2
    return fn(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def keep_big(m, n_min):
    lab, n = nd.label(m)
    if not n:
        return m
    s = nd.sum(m, lab, range(1, n + 1))
    return np.isin(lab, [i + 1 for i, v in enumerate(s) if v >= n_min])


def tone(ramp, s):
    return ROM_TONES[RAMP[ramp][s % ROM_STEPS]]


# ---------------------------------------------------------------- segmentation pleine résolution
FLOOR_TONES = {'briques': ((178, 146, 130), 40), 'terre': ((166, 121, 76), 45), 'dalles': ((159, 151, 146), 38),
               'terre_vive': ((200, 150, 70), 50)}


def classify(a):
    Hs, Ws = a.shape[:2]
    r, g, b = a.transpose(2, 0, 1)
    mag = (r > 200) & (b > 200) & (g < 80)
    lab, n = nd.label(mag)
    edge = set(np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]])) - {0}
    s = nd.sum(mag, lab, range(1, n + 1))
    void = np.isin(lab, sorted(edge))
    rift = np.isin(lab, [i + 1 for i, v in enumerate(s) if v >= 800 and i + 1 not in edge])
    void = morph(nd.binary_dilation, morph(nd.binary_closing, void, 2), 1)                  # liseré antialiasé compris
    rift = nd.binary_fill_holes(morph(nd.binary_dilation, rift, 1)) & ~void                 # failles, liseré compris
    nl, nn = nd.label(~void & ~rift)
    ss = nd.sum(~void & ~rift, nl, range(1, nn + 1))
    plat = nl == (int(np.argmax(ss)) + 1)                                                   # le fragment de ruine
    rocks = nd.binary_fill_holes(~void & ~plat & ~rift) & ~plat & ~rift                     # rochers en lévitation
    near = lambda c, t: np.sqrt(((a - np.array(c)) ** 2).sum(2)) < t
    seed = np.zeros((Hs, Ws), bool)
    for c, t in FLOOR_TONES.values():
        seed |= near(c, t)
    fl = nd.uniform_filter((seed & ~mag).astype(float), 11) > 0.6
    fl &= plat & ~morph(nd.binary_dilation, rift, 3)
    fl = keep_big(morph(nd.binary_opening, fl, 3), 20000)
    y0, y1, x0, x1 = PATH_BOX                                                               # joints du chemin de dalles
    box = np.zeros((Hs, Ws), bool); box[y0:y1, x0:x1] = True
    path = nd.binary_fill_holes(morph(nd.binary_closing, fl & box, 6)) & box & plat
    lab2, _ = nd.label(~fl & plat); add = np.zeros((Hs, Ws), bool)                          # petits trous (< 400 px)
    for i, sl in enumerate(nd.find_objects(lab2), 1):
        mm = lab2[sl] == i
        if mm.sum() < 400 and not (rift[sl] & mm).any():
            add[sl] |= mm
    floor = fl | path | add
    floor &= ~morph(nd.binary_dilation, rift, 3)
    ruins = plat & ~floor & ~rift
    return dict(floor=floor, dalles=(path | add) & ~fl, ruins=ruins, rift=rift, void=void, rocks=rocks, plat=plat)


def sol_patch(a, floor, target):
    best = None; ii = nd.uniform_filter(floor.astype(float), 96)
    for y0 in range(0, SRC[1] - 96, 8):
        for x0 in range(0, SRC[0] - 96, 8):
            if ii[y0 + 48, x0 + 48] < 0.999:
                continue
            p = a[y0:y0 + 96, x0:x0 + 96].reshape(-1, 3)
            sc = float(np.abs(p.mean(0) - target).sum()) + float(p.std(0).mean())
            if best is None or sc < best[0]:
                best = (sc, y0, x0)
    return (best[1], best[1] + 96, best[2], best[2] + 96)


def make_sol(decor, patch):
    y0, y1, x0, x1 = patch; p = decor[y0:y1, x0:x1].astype('uint8')
    row = np.concatenate([p, p[:, ::-1]], 1); tile = np.concatenate([row, row[::-1]], 0)
    return np.tile(tile, (SRC[1] // tile.shape[0] + 1, SRC[0] // tile.shape[1] + 1, 1))[:SRC[1], :SRC[0]]


# ---------------------------------------------------------------- lois animées
def void_frames(mask, seed=5):
    """Vide de la distorsion : bandes qui coulent (fréquences temporelles entières sur 7 pas) + étoiles qui clignotent."""
    yy, xx = np.mgrid[:H, :W].astype(float)
    rng = np.random.default_rng(seed)
    jag = nd.gaussian_filter(rng.random((H, W)), 2.0); jag = (jag - jag.min()) / np.ptp(jag)
    stars = [(int(y), int(x), int(rng.integers(VOID_PHASES))) for y, x in np.argwhere(mask)[rng.choice(int(mask.sum()), 90, replace=False)]]
    frames = []
    for t in range(VOID_PHASES):
        ph = 2 * np.pi * t / VOID_PHASES
        v = (0.55 * np.sin(0.045 * xx + 0.028 * yy - ph) + 0.35 * np.sin(0.021 * xx - 0.052 * yy + 1.7 + 2 * ph)
             + 0.25 * np.sin(np.hypot(xx - W / 2, yy - H / 2) * 0.06 - ph) + 0.5 * (jag - 0.5))
        lvl = np.clip(((v + 1.3) / 2.6 * len(VOID_TONES)).astype(int), 0, len(VOID_TONES) - 1)
        e = np.zeros((H, W, 4), 'uint8'); e[..., :3] = np.array(VOID_TONES, 'uint8')[lvl]; e[..., 3] = 255
        for y, x, p in stars:
            u = (t - p) % VOID_PHASES
            if u < 3:
                e[y, x, :3] = STAR[0] if u == 1 else STAR[1]
        e[~mask] = 0
        frames.append(e)
    return frames, stars


def rift_info(ex_rift):
    lab, n = nd.label(ex_rift)
    out = []
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i)
        out.append({'id': i, 'centre': [float(xs.mean()), float(ys.mean())], 'px': int(len(ys)),
                    'bbox': [int(xs.min()), int(ys.min()), int(xs.max()), int(ys.max())]})
    out.sort(key=lambda d: (d['centre'][0]))
    return lab, out


def rift_frames(ex_rift, cracks, base, rifts, lab):
    """Failles : tourbillon intérieur (21 pas) ; bord interne en rampe vive, 2e rang en rampe moyenne, lueur externe (1-2 px
    sur le sol, largeur qui bat) en rampe sombre ; crevasses peintes rallumées en rampe moyenne avec un retard d'un pas par
    6 px de distance à la faille."""
    din = nd.distance_transform_edt(ex_rift)
    dout = nd.distance_transform_edt(~ex_rift)
    yy, xx = np.mgrid[:H, :W].astype(float)
    ang = np.zeros((H, W)); rad = np.zeros((H, W))
    for rf in rifts:
        m = nd.binary_dilation(lab == rf['id'], iterations=3)
        cx, cy = rf['centre']; x0, y0, x1, y1 = rf['bbox']
        sx, sy = max((x1 - x0) / 2, 4), max((y1 - y0) / 2, 4)
        ang[m] = np.arctan2((yy[m] - cy) / sy, (xx[m] - cx) / sx); rad[m] = np.hypot((yy[m] - cy) / sy, (xx[m] - cx) / sx)
    dcr = np.where(cracks, dout, 0)
    frames = []
    for t in range(RIFT_PHASES):
        s = t % ROM_STEPS; ph = 2 * np.pi * t / RIFT_PHASES
        e = np.zeros((H, W, 4), 'uint8')
        v = np.sin(3 * ang - 5 * rad + ph) * 0.5 + 0.5 * (1 - np.clip(rad, 0, 1)) * np.sin(ph * 2 + 7 * rad) - 0.6 * (1 - np.clip(rad, 0, 1))
        lvl = np.clip(((v + 1.2) / 2.4 * len(RIFT_TONES)).astype(int), 0, len(RIFT_TONES) - 1)
        e[ex_rift, :3] = np.array(RIFT_TONES, 'uint8')[lvl[ex_rift]]
        e[ex_rift & (din <= 1), :3] = tone('vive', s)
        e[ex_rift & (din > 1) & (din <= 2), :3] = tone('moyenne', s)
        wide = 2 if sum(tone('vive', s)) >= 300 else 1                                       # la lueur s'élargit au pic
        outer = ~ex_rift & (dout <= wide)
        e[outer, :3] = tone('sombre', s)
        cr = cracks & ~outer & ~ex_rift
        e[cr, :3] = base[cr]
        lit = cr & (((t - (dcr // 6).astype(int)) % ROM_STEPS) < 3)                        # l'onde court le long des fissures
        sl = ((t - (dcr // 6).astype(int)) % ROM_STEPS)
        for k in range(3):
            e[lit & (sl == k), :3] = tone('moyenne', k)
        e[ex_rift | outer | cr, 3] = 255
        frames.append(e)
    return frames


def rock_frames(layer, ex_rocks, seed=11):
    """Rochers en lévitation : chaque rocher monte et descend de 2 px (sinus sur 21 pas, phase propre)."""
    lab, n = nd.label(ex_rocks)
    rng = np.random.default_rng(seed)
    info = [{'id': i, 'phase': int(rng.integers(ROCK_PHASES)), 'amp': int(rng.integers(1, 3))} for i in range(1, n + 1)]
    frames = []
    for t in range(ROCK_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for d in info:
            dy = int(round(d['amp'] * np.sin(2 * np.pi * (t - d['phase']) / ROCK_PHASES)))
            m = lab == d['id']; ys, xs = np.nonzero(m)
            ok = (ys + dy >= 0) & (ys + dy < H)
            e[ys[ok] + dy, xs[ok]] = layer[ys[ok], xs[ok]]
        frames.append(e)
    return frames, info


DEBRIS_TONES = [(150, 128, 118), (112, 96, 90), (70, 58, 60)]


def debris_frames(rifts, allowed, seed=17, per=6):
    """Éclats de pierre aspirés : spirale vers le centre de la faille en 21 pas, rayon 38 -> 0, ton ROM au dernier tiers."""
    rng = np.random.default_rng(seed); shards = []
    for rf in rifts:
        for j in range(per):
            shards.append({'faille': rf['id'], 'centre': rf['centre'], 'r0': float(rng.uniform(28, 44)),
                           'a0': float(rng.uniform(0, 2 * np.pi)), 'phase': int(rng.integers(DEBRIS_PHASES)),
                           'sens': int(rng.choice([-1, 1])), 'ton': int(j % 3)})
    frames = []
    for t in range(DEBRIS_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        s = t % ROM_STEPS
        for d in shards:
            u = (t - d['phase']) % DEBRIS_PHASES
            f = 1 - u / DEBRIS_PHASES
            rr = d['r0'] * f; aa = d['a0'] + d['sens'] * 2.2 * (1 - f)
            x = int(round(d['centre'][0] + rr * np.cos(aa))); y = int(round(d['centre'][1] + 0.7 * rr * np.sin(aa)))
            sz = 2 if f > 0.45 else 1
            c = DEBRIS_TONES[d['ton']] if u < 14 else tone('vive', s)
            for dy in range(sz):
                for dx in range(sz):
                    if 0 <= y + dy < H and 0 <= x + dx < W and allowed[y + dy, x + dx]:
                        e[y + dy, x + dx] = (*c, 255)
        frames.append(e)
    return frames, shards


def zarbi_path(k, cx, cy, rx, ry, a0, sens):
    """Position (x, y), échelle et visibilité du Zarbi au pas k (0-83). Sortie 10 pas, tour 64 pas, retour 8 pas, caché 2 pas."""
    px, py = cx + rx * np.cos(a0), cy + ry * np.sin(a0)
    bob = 1.5 * np.sin(2 * np.pi * k / 12)
    if k < Z_OUT:
        f = (k + 1) / Z_OUT; sc = [0.34, 0.34, 0.34, 0.67, 0.67, 0.67, 1, 1, 1, 1][k]
        return cx + (px - cx) * f, cy + (py - cy) * f + bob * f, sc, True
    k -= Z_OUT
    if k < Z_ORBIT:
        a = a0 + sens * 2 * np.pi * k / Z_ORBIT
        return cx + rx * np.cos(a), cy + ry * np.sin(a) + bob, 1, True
    k -= Z_ORBIT
    if k < Z_BACK:
        f = (Z_BACK - 1 - k) / Z_BACK; sc = [1, 1, 0.67, 0.67, 0.67, 0.34, 0.34, 0.34][k]
        return cx + (px - cx) * f, cy + (py - cy) * f + bob * f, sc, True
    return cx, cy, 0, False


def zarbi_frames(rifts, base, walk, seed=23):
    rng = np.random.default_rng(seed); zs = []
    seen = {}
    for j, (letter, ri, dec, sens) in enumerate(LETTERS_RIFT):
        rf = rifts[ri]; n = seen.get(ri, 0); seen[ri] = n + 1
        zs.append({'lettre': letter, 'faille': rf['id'], 'centre': rf['centre'], 'rx': float(rng.uniform(36, 44)) + 12 * n,
                   'ry': float(rng.uniform(24, 30)) + 8 * n, 'a0': float(rng.uniform(0, 2 * np.pi)), 'sens': sens,
                   'decalage': dec})
    glyphs = {z['lettre']: Z.glyph(z['lettre'])[1] for z in zs}
    frames = []; track = []
    for k in range(ZARBI_PHASES):
        e = np.zeros((H, W, 4), 'uint8'); spr = []; pos = []
        s = (k // 2) % ROM_STEPS
        for z in zs:
            u = (k - z['decalage']) % ZARBI_PHASES
            x, y, f, vis = zarbi_path(u, *z['centre'], z['rx'], z['ry'], z['a0'], z['sens'])
            pos.append([round(x, 2), round(y, 2), f, vis])
            if not vis:
                continue
            g = Z.scaled(glyphs[z['lettre']], f); n = g.shape[0]
            x0, y0 = int(round(x - n / 2)), int(round(y - n / 2))
            sw = max(2, int(round(6 * f)))                                                       # ombre au sol, 18 px plus bas
            for dx in range(-sw, sw + 1):
                for dy in (-1, 0, 1):
                    if (dx / (sw + 0.5)) ** 2 + (dy / 1.5) ** 2 > 1:
                        continue
                    xx_, yy_ = int(round(x)) + dx, int(round(y)) + 18 + dy
                    if 0 <= xx_ < W and 0 <= yy_ < H and walk[yy_, xx_] and e[yy_, xx_, 3] == 0:
                        e[yy_, xx_, :3] = (base[yy_, xx_] * 0.62).astype('uint8'); e[yy_, xx_, 3] = 255
            spr.append((x0, y0, g, f < 1))
        for x0, y0, g, halo in spr:
            m = g[..., 3] == 255
            if halo:                                                                             # halo de la faille en sortie
                hm = nd.binary_dilation(np.pad(m, 1)) & ~np.pad(m, 1)
                for yy_, xx_ in np.argwhere(hm):
                    X, Y = x0 - 1 + xx_, y0 - 1 + yy_
                    if 0 <= X < W and 0 <= Y < H:
                        e[Y, X] = (*tone('moyenne', s), 255)
            for yy_, xx_ in np.argwhere(m):
                X, Y = x0 + xx_, y0 + yy_
                if 0 <= X < W and 0 <= Y < H:
                    e[Y, X] = g[yy_, xx_]
        frames.append(e); track.append(pos)
    return frames, zs, track


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png')
    assert a.shape[:2] == (SRC[1], SRC[0])
    m = classify(a)
    ref = rgb(REFS['D30P34A'])
    y0, x0, y1, x1 = REF_BOXES['briques'][1]
    patch = sol_patch(a, m['floor'] & ~m['dalles'], ref[y0:y1, x0:x1].reshape(-1, 3).mean(0))
    f = make_sol(a, patch)
    order = ['floor', 'ruins', 'rift', 'void', 'rocks']
    ex, cols = JM.down_class(a, m, order)
    layers = BM.quantize_layers({'sol_complet': JM.rgba(JM.down_full(f), np.ones((H, W), bool)),
                                 'sol': JM.rgba(cols['floor'], ex['floor'])})
    for nm, key, nc in (('ruines', 'ruins', 48), ('rochers', 'rocks', 24)):
        e = JM.rgba(cols[key], ex[key]); m_ = e[..., 3] == 255
        q = Image.fromarray(e[..., :3]).quantize(colors=nc, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        e[..., :3] = np.array(q.convert('RGB')); e[~m_] = 0; layers[nm] = e
    base = np.array(layers['sol_complet'])[..., :3].copy()
    for nm in ('sol', 'ruines'):
        mm = layers[nm][..., 3] == 255; base[mm] = layers[nm][mm, :3]
    lab, rifts = rift_info(ex['rift'])
    lum = base.astype(float) @ [.299, .587, .114]
    dist = nd.distance_transform_edt(~ex['rift'])
    cracks = (lum < 62) & (dist <= 30) & (dist > 2) & (ex['ruins'] | ex['floor'])
    vide_mask = ex['void'] | ex['rocks']
    vf, stars = void_frames(vide_mask)
    rf = rift_frames(ex['rift'], cracks, base, rifts, lab)
    rkf, rocks = rock_frames(layers['rochers'], ex['rocks'])
    walk = ex['floor']
    df, shards = debris_frames(rifts, ex['floor'] | ex['ruins'] | ex['rift'])
    zf, zs, track = zarbi_frames(rifts, base, walk)
    return dict(a=a, m=m, ex=ex, layers=layers, vf=vf, stars=stars, rf=rf, rkf=rkf, rocks=rocks, df=df, shards=shards,
                zf=zf, zs=zs, track=track, rifts=rifts, cracks=cracks, patch=patch)


# boîtes (image, (y0, x0, y1, x1)) : même matière mesurée à la main dans la référence et dans le brut (coordonnées brut
# 1200 x 896, ramenées à la scène 768 x 576 par l'échelle du lot)
REF_BOXES = {'briques': ('D30P34A', (340, 240, 400, 300)), 'dalles': ('D28P44A', (150, 170, 320, 330)),
             'linteaux': ('D28P44A', (72, 25, 98, 110))}
RAW_BOXES = {'briques': (350, 480, 390, 560), 'dalles': (780, 540, 860, 640), 'linteaux': (185, 130, 215, 270)}


def terre_rule(x):
    """Terre ocre : même règle sur D28P44A entière et sur la scène (une boîte à la main tombait sur des gravillons)."""
    r, g, b = x.transpose(2, 0, 1)
    return (r - b > 50) & (g > b + 15) & (r > 90)


def fidelity(D, scene0):
    x = np.array(scene0.convert('RGB')).astype(int); out = {}
    for nm, (code, (y0, x0, y1, x1)) in REF_BOXES.items():
        r_ = rgb(REFS[code])[y0:y1, x0:x1].reshape(-1, 3).mean(0)
        b0, a0, b1, a1 = [int(round(v * S)) for v in RAW_BOXES[nm]]
        a0 -= JM.CROP_X; a1 -= JM.CROP_X
        o_ = x[b0:b1, a0:a1].reshape(-1, 3).mean(0)
        out[nm] = {'ref': code, 'boite_ref_y0x0y1x1': [y0, x0, y1, x1], 'boite_scene_y0x0y1x1': [b0, a0, b1, a1],
                   'ref_rgb': [round(float(v), 1) for v in r_], 'rgb': [round(float(v), 1) for v in o_],
                   'distance': round(float(np.linalg.norm(r_ - o_)), 2)}
    ref = rgb(REFS['D28P44A']); mr, mx = terre_rule(ref), terre_rule(x)
    r_, o_ = ref[mr].mean(0), x[mx].mean(0)
    out['terre'] = {'ref': 'D28P44A', 'regle': '(R - B > 50) et (G > B + 15) et (R > 90), image entiere',
                    'part_ref': round(float(mr.mean()), 3), 'part_rendu': round(float(mx.mean()), 3),
                    'ref_rgb': [round(float(v), 1) for v in r_], 'rgb': [round(float(v), 1) for v in o_],
                    'distance': round(float(np.linalg.norm(r_ - o_)), 2)}
    L = D['layers']['sol_complet']; o_ = L[..., :3].reshape(-1, 3).mean(0)
    y0, x0, y1, x1 = REF_BOXES['briques'][1]; r_ = rgb(REFS['D30P34A'])[y0:y1, x0:x1].reshape(-1, 3).mean(0)
    out['sol_complet'] = {'ref': 'D30P34A', 'ref_rgb': [round(float(v), 1) for v in r_], 'rgb': [round(float(v), 1) for v in o_],
                          'distance': round(float(np.linalg.norm(r_ - o_)), 2)}
    out['methode'] = ('boites de meme matiere mesurees a la main dans la reference et dans la scene t000 (briques D30P34A ; '
                      'dalles, linteaux D28P44A) ; terre : meme regle de couleur sur D28P44A entiere et sur la scene (la '
                      'premiere boite de reference tombait sur des gravillons gris : 45) ; moyennes comparees')
    out['seuil'] = FIDELITY_MAX
    out['seuille'] = ['briques', 'terre', 'dalles', 'linteaux', 'sol_complet']
    return out


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['autel'],
                                                'source': markers['faille']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text()); o = doc['Object']
    o['Name'] = {'DefaultText': 'Ruines Zarbi - dechirures (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Fin de zone generee 4:3 (ref. D28P44A + D30P34A) : fragment de ruine que la realite dechire, '
                    'vide de la distorsion autour, cinq failles dans le dallage dont sortent les Zarbi (Z A R B I ! ?), '
                    'rochers en levitation, debris aspires. Bord des failles a la loi de palette de D30P34A (7 x 10). '
                    'Arrivee au sud, autel au nord. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        mk['EntName'] = {'boss': 'autel', 'source': 'faille'}.get(mk['EntName'], mk['EntName'])
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Ruines Zarbi (dechirures) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "fin de zone generee au format 4:3 (ref. D28P44A + D30P34A), ruines dechirees, Zarbi qui sortent des failles")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def reach_map(blocked, start):
    gh, gw = blocked.shape
    free = np.zeros((gh, gw), bool)
    free[:-1, :-1] = ~(blocked[:-1, :-1] | blocked[1:, :-1] | blocked[:-1, 1:] | blocked[1:, 1:])
    lab, _ = nd.label(free)
    return lab == lab[start]


def nearest_reach(reach, target, dy=8):
    gh, gw = reach.shape
    cand = [(abs(gx * 8 + 8 - target[0]) + abs(gy * 8 + dy - target[1]), gx, gy) for gy in range(gh - 1) for gx in range(gw - 1) if reach[gy, gx]]
    _, gx, gy = min(cand); return [gx * 8, gy * 8]


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'masques', 'review'] + [f'animation/{k}' for k in ANIM]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, ex = D['layers'], D['ex']
    ex = dict(ex, dalles=ex['floor'] & (JM.resize_plane(D['m']['dalles'].astype(np.float32)) > 0.5), fissures=D['cracks'])
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('vide', D['vf'], VOID_TICKS), ('sol', [layers['sol']], 60),
                   ('ruines', [layers['ruines']], 60), ('rochers', D['rkf'], ROCK_TICKS), ('failles', D['rf'], ROM_TICKS),
                   ('debris', D['df'], DEBRIS_TICKS), ('zarbi', D['zf'], ZARBI_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    walk = layers['sol'][..., 3] == 255
    blocked = BM.cell_grid(~walk)
    gh_, gw_ = blocked.shape
    col_bottom = [c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()]
    med = int(np.median(np.nonzero(walk[H - 4])[0])) // 8
    ex_ = min(col_bottom, key=lambda c: abs(c - med)); entrance = [ex_ * 8, H - 16]
    reach = reach_map(blocked, (entrance[1] // 8, entrance[0] // 8))
    autel = nearest_reach(reach, (int(595 * S), int(150 * S)))                             # dais devant le mur de tablettes
    mid = min(D['rifts'], key=lambda r: abs(r['centre'][0] - W / 2))
    faille = nearest_reach(reach, (int(mid['centre'][0]), int(mid['bbox'][3]) + 16))
    markers = {'entrance': entrance, 'autel': autel, 'faille': faille}
    paths = {}
    for k in ('autel', 'faille'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for title, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ANIM[title]) % len(frames)] if title in ANIM else frames[0]))
        return im
    scenes = [scene(t * 5) for t in range(LOOP_TICKS // 5)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    fid = fidelity(D, scenes[0])
    assert all(fid[k]['distance'] < FIDELITY_MAX for k in fid['seuille']), fid
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(5 * 1000 / 60), loop=0, lossless=True)
    colim = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, c in (('entrance', (255, 230, 40, 255)), ('autel', (60, 220, 255, 255)), ('faille', (255, 80, 200, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    z = Image.new('RGB', (4 * 300, 300), (20, 20, 20))                                     # zoom faille centrale, 4 instants
    cx0, cy0 = max(int(mid['centre'][0]) - 75, 0), max(int(mid['centre'][1]) - 75, 0)
    for j, t in enumerate((0, 25, 60, 115)):
        im = scene(t).crop((cx0, cy0, cx0 + 150, cy0 + 150)).convert('RGB')
        z.paste(im.resize((300, 300), Image.NEAREST), (j * 300, 0))
    z.save(OUT / 'review' / f'{PFX}_zoom_faille.png')
    BM.write_ora(OUT / f'{PFX}_ruines_zarbi_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'ruines Zarbi (fin de zone)', 'biome': 'ruines dechirees par la realite, Zarbi',
        'demande': ["une zone de ruine avec des Zarbi qui sortent de dechirures / failles dans la realite, etc",
                    "je choisis toutes les options recommandees, choisis les textures de reference"],
        'choix_agent': {'references': 'D28P44A (matieres de la ruine) + D30P34A (realite qui se desagrege : dallage fendu, colonnes '
                                      'brisees, rochers en levitation) ; decoupes de style x2 seulement, sans leurs compositions',
                        'layout': 'fragment de ruine flottant dans le vide de la distorsion ; esplanade de briques fendue de cinq '
                                  'failles ; bandes de terre ocre et linteaux sur piliers a l ouest et a l est ; dais et mur de '
                                  'tablettes a glyphes au nord ; chemin de dalles depuis le bord sud',
                        'zarbi': 'Z A R B I ! ? (le mot ZARBI), sprites calcules, chacun lie a une faille',
                        'noms_de_lieux': 'non affirmes (prefixe dNN non fiable), seuls les codes ROM comptent'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference (2 decoupes de style x2), magenta pur pour le vide et les failles, calques calcules ; '
                  'sol complet = plage de briques du brut en miroir',
        'references_da': {k: {'fichier': str(p.relative_to(R)), 'sha256': sha(p), 'source': 'recuperer_maps.py rom (pret/pmd-sky c8073235)'}
                          for k, p in REFS.items()},
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC), 'images': STYLE,
                        'utilise': True, 'editions': 0, 'note': 'premier rendu garde tel quel'}],
        'sol_complet': {'methode': 'plage de briques du brut en miroir (la plus proche des briques de D30P34A, peu contrastee)',
                        'plage_y0_y1_x0_x1': list(D['patch'])},
        'normalization': {'scale': S, 'crop_x': JM.CROP_X,
                          'methode': 'moyenne ponderee par classe, palette commune 96 couleurs (sol complet, sol) ; palettes propres : '
                                     'ruines 48, rochers 24 ; vide, failles, debris et zarbi calcules'},
        'segmentation': {'magenta': 'R > 200, B > 200, G < 80',
                         'vide': 'composantes magenta touchant un bord, fermees 2, dilatees 1',
                         'failles': 'composantes magenta fermees >= 800 px, dilatees 1, trous rebouches',
                         'rochers': 'composantes hors magenta separees du fragment de ruine',
                         'sol': 'proche des tons ' + json.dumps({k: v for k, v in FLOOR_TONES.items()}) + ', lisse 11 (> 0,6), ouvert 3, '
                                '>= 20000 px, a plus de 3 px d une faille',
                         'dalles': f'joints du chemin rebouches dans {list(PATH_BOX)} (ferme 6) + trous de moins de 400 px',
                         'ruines': 'le reste du fragment (colonnes, linteaux, piliers, mur de tablettes, falaises, crevasses)'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'loi_rom': {'source': 'D30P34A, vitrail anime (seul element anime de la map)', 'tons': [list(c) for c in ROM_TONES],
                    'rampes_indices': RAMP, 'pas': ROM_STEPS, 'ticks_par_pas': ROM_TICKS},
        'vide': {'phases': VOID_PHASES, 'frame_length_ticks': VOID_TICKS, 'tons': [list(c) for c in VOID_TONES],
                 'tons_rom': [list(c) for c in VOID_TONES[3:]], 'etoiles': len(D['stars']),
                 'loi': 'bandes qui coulent, frequences temporelles entieres sur 7 pas ; etoiles allumees 3 pas sur 7'},
        'failles': {'phases': RIFT_PHASES, 'frame_length_ticks': ROM_TICKS, 'liste': D['rifts'], 'tons_interieur': [list(c) for c in RIFT_TONES],
                    'loi': 'interieur : tourbillon 21 pas ; bord interne rampe vive, 2e rang rampe moyenne, lueur externe rampe '
                           'sombre (2 px au pic, sinon 1) ; crevasses peintes a moins de 30 px : rampe moyenne pas 0-2 avec un '
                           'retard d un pas par 6 px', 'crevasses_px': int(D['cracks'].sum())},
        'rochers': {'phases': ROCK_PHASES, 'frame_length_ticks': ROCK_TICKS, 'liste': D['rocks'],
                    'loi': 'dy = round(amp * sin(2 pi (t - phase) / 21)), amp 1 ou 2 px'},
        'debris': {'phases': DEBRIS_PHASES, 'frame_length_ticks': DEBRIS_TICKS, 'eclats': len(D['shards']),
                   'loi': 'spirale vers le centre de la faille, rayon r0 (1 - u/21), 2,2 rad sur la vie, ton ROM vif les 7 derniers pas'},
        'zarbi': {'phases': ZARBI_PHASES, 'frame_length_ticks': ZARBI_TICKS, 'lettres': D['zs'],
                  'cycle': 'sortie 10 pas (echelle 1/3 -> 1, halo rampe moyenne) ; tour de la faille 64 pas (ellipse, flottement '
                           '1,5 px sur 12 pas) ; retour 8 pas ; cache 2 pas ; 84 pas de 5 ticks = boucle de scene 420 ticks (7 s)',
                  'sprites': 'calcules (zarbi.py) : contour, corps, reflet, oeil blanc, pupille ; 24 x 24 ; ombre au sol 18 px sous le Zarbi',
                  'tons': [list(c) for c in Z.TONES]},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol ; vide, failles, crevasses, colonnes, linteaux et mur bloquants',
                   'autel': 'sur le dais devant le mur de tablettes (evenement a scripter)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun (raccords a scripter)'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': {k: v['distance'] for k, v in fid.items() if isinstance(v, dict)}, 'markers': markers,
                      'patch': D['patch'], 'failles': len(D['rifts']), 'rochers': len(D['rocks']),
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
