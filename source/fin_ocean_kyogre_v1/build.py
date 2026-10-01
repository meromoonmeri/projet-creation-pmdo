"""Fin Océan (FOC1) — zone de fin de donjon sous l'océan, arène de Kyogre, 4:3 (768 x 576).

.venv/bin/python source/fin_ocean_kyogre_v1/build.py

Demande : « fait une zone de fin donjon sous l'ocean avec des motif sur toute la zone et des nuance deau des effet de bulle
etc une zone ou y'aura kyogre apres etc elle doit etre magnifique ».

- Référence canonique : D42P41A (fond marin bleu, anneaux de bulles gravés et fissures de corail sur tout le sol, anneau de
  roche bleue, scintillements multicolores). Rendu par source/outil_maps_pmdsky (pret/pmd-sky + skytemple-files), copie
  dans reference/. Aucune map sous-marine jouable n'existe dans PMD Sky : c'est la plus proche (choix de l'agent).
- Décor : rendu généré référencé (découpe de style x3 donnée au générateur), fosse abyssale en magenta pur.
- Sol complet : généré depuis une découpe du sol de la référence (x4).
- Calques : sol complet, abysse (anim), sol, nuances d'eau (anim), motifs lumineux (anim), parois, coraux, algues (anim),
  bulles (anim), scintillements (anim). Toutes les boucles sont fermées sur 240 ticks.
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd
from scipy.spatial import cKDTree

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'fin_ocean_kyogre_v1'
OUT = R / 'renders' / LOT
NAMESPACE = 'fin_ocean_kyogre'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'foc1_fin_ocean_kyogre'
PFX = 'FOC1'
REF = HERE / 'reference/D42P41A.png'
FLOOR_REF_CROP = (170, 190, 330, 330)      # sol gravé de D42P41A
WALL_REF_CROP = (60, 60, 150, 150)         # anneau de roche de D42P41A (haut gauche)

W, H = 768, 576
SRC = (1200, 896)
EMBLEM_SRC = (600, 477, 156)               # sceau de Kyogre dans le brut : centre, rayon (mesuré)
RIM_SRC = (602, 192, 240, 114)             # ellipse des corniches en gradins autour de la fosse (centre, demi-axes), mesurée
LOOP_TICKS = 240
ABYSS_PHASES, ABYSS_TICKS = 24, 10
LIGHT_PHASES, LIGHT_TICKS = 16, 15
WAVE_PHASES, WAVE_TICKS = 24, 10
WEED_PHASES, WEED_TICKS = 12, 20
BUBBLE_PHASES, BUBBLE_TICKS = 48, 5
SPARK_PHASES, SPARK_TICKS = 12, 5
SPARK_SEQ = [1, 2, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0]
FIDELITY_MAX = 35
# Abysse : tons sombres de la fosse (bord mesuré sur le brut (6, 49, 90)) vers le cyan de la référence.
ABYSS_TONES = [(2, 14, 36), (4, 26, 58), (6, 40, 80), (10, 58, 104), (22, 84, 130), (48, 124, 164), (110, 190, 220)]
LIGHT = np.array([168, 232, 246], float)   # lumière de surface (reflets clairs de la référence)
GLOW = [(46, 128, 176), (72, 168, 210), (122, 214, 240), (196, 246, 255)]   # gravures qui s'allument
BUBBLE_EDGE, BUBBLE_HI, BUBBLE_IN = (168, 226, 246), (250, 255, 255), (90, 168, 206)
SPARK_TINTS = [(236, 244, 255), (126, 232, 196), (232, 166, 236), (150, 196, 255)]   # teintes des scintillements de D42P41A


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba
BM = JM.BM                                                                       # quantize_layers, cell_grid, write_ora
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
assert all(LOOP_TICKS % (p * t) == 0 for p, t in ((ABYSS_PHASES, ABYSS_TICKS), (LIGHT_PHASES, LIGHT_TICKS), (WAVE_PHASES, WAVE_TICKS),
                                                  (WEED_PHASES, WEED_TICKS), (BUBBLE_PHASES, BUBBLE_TICKS), (SPARK_PHASES, SPARK_TICKS)))


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def morph(fn, m, it):
    p = it + 2
    return fn(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sm(m, k):
    return nd.uniform_filter(m.astype(float), k)


def keep_big(m, n_min):
    lab, n = nd.label(m)
    if not n:
        return m
    s = nd.sum(m, lab, range(1, n + 1))
    return np.isin(lab, [i + 1 for i, v in enumerate(s) if v >= n_min])


def out_xy(x, y):
    return (x * S - JM.CROP_X, y * S)


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    r, g, b = a.transpose(2, 0, 1)
    mag = (r > 170) & (b > 170) & (g < 110)
    lab, n = nd.label(mag); s = nd.sum(mag, lab, range(1, n + 1))
    mag = lab == int(np.argmax(s)) + 1                                            # la fosse seule (pas les scintillements roses)
    lip = (r > 110) & (b > 140) & (g < 70) & nd.binary_dilation(mag, iterations=10)   # liseré violet intérieur
    trench = nd.binary_dilation(nd.binary_fill_holes(morph(nd.binary_closing, mag | lip, 3)), iterations=2)
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    rim = (((xx - RIM_SRC[0]) / RIM_SRC[2]) ** 2 + ((yy - RIM_SRC[1]) / RIM_SRC[3]) ** 2 <= 1) & ~trench   # corniches en gradins
    floor_c = np.sqrt(((a - [51, 122, 160]) ** 2).sum(2)) < 22                  # ton du sol mesuré sur le brut
    fl = sm(floor_c, 9) > 0.45
    fl = nd.binary_fill_holes(morph(nd.binary_closing, fl, 6))                    # gravures, sceau, coquillages rebouchés
    fl = morph(nd.binary_opening, fl, 5)
    fl &= ~trench & ~rim
    fl = morph(nd.binary_opening, fl, 3)
    lab, _ = nd.label(fl); fl = np.isin(lab, [v for v in np.unique(lab[-3:]) if v])
    green = keep_big((g - r > 55) & (g >= b - 25) & (g > 80) & ~fl & ~trench, 150)
    pink = keep_big((r > 110) & (r - g > 12) & (b > 100) & ~fl & ~trench & ~green, 150)
    weed = nd.binary_dilation(green, iterations=1) & ~fl & ~trench               # contour sombre des algues compris
    coral = nd.binary_dilation(pink, iterations=1) & ~fl & ~trench & ~weed
    walls = ~(trench | fl | weed | coral)
    return dict(trench=trench, floor=fl, weed=weed, coral=coral, walls=walls), rim


# ---------------------------------------------------------------- abysse : tourbillon lent dans la fosse
def abyss_frames(mask):
    ys, xs = np.nonzero(mask)
    cx, cy = xs.mean(), ys.mean(); rx, ry = (xs.max() - xs.min()) / 2 + 1, (ys.max() - ys.min()) / 2 + 1
    yy, xx = np.mgrid[:H, :W]
    u, v = (xx - cx) / rx, (yy - cy) / ry
    rho = np.clip(np.hypot(u, v), 0, 1); th = np.arctan2(v, u)
    shade = np.clip((yy - (cy - ry)) / (2 * ry), 0, 1)                             # bord nord dans l'ombre de la corniche
    frames = []
    for t in range(ABYSS_PHASES):
        ph = 2 * np.pi * t / ABYSS_PHASES
        arm = np.sin(3 * th + 11 * rho - ph)                                          # 3 bras : tour de 2 pi / 3 par boucle
        arm2 = np.sin(5 * th - 7 * rho + 2 * ph)
        lev = 1.2 + 3.2 * rho ** 1.3 + 0.9 * arm + 0.35 * arm2 - 1.4 * (1 - shade) * rho
        lev = np.clip(np.round(lev), 0, len(ABYSS_TONES) - 2).astype(int)
        glint = (arm > 0.96) & (rho > 0.35) & (rho < 0.85) & (shade > 0.4)             # crêtes qui accrochent la lumière
        lev[glint] = len(ABYSS_TONES) - 1
        e = np.zeros((H, W, 4), 'uint8'); e[mask, :3] = np.array(ABYSS_TONES)[lev[mask]]; e[mask, 3] = 255
        frames.append(e)
    return frames, dict(centre=[round(float(cx), 1), round(float(cy), 1)], rayons=[round(float(rx), 1), round(float(ry), 1)])


# ---------------------------------------------------------------- nuances d'eau : caustiques + nappes de lumière
def light_frames(floor_layer, mask, rng):
    """Nuances d'eau : caustiques fines et ondulées (réseau F2 - F1 serré, domaine déformé, traits discontinus) et nappes douces."""
    base = floor_layer[..., :3].astype(float)
    n = 420; p0 = rng.uniform([-30, -30], [W + 30, H + 30], (n, 2)); rad = rng.uniform(2.5, 6, n); phi = rng.uniform(0, 2 * np.pi, n)
    yy, xx = np.nonzero(mask)
    waves = [(rng.uniform(0.010, 0.022), rng.uniform(0, 2 * np.pi), rng.uniform(0, 2 * np.pi), m) for m in (1, 1, 2)]
    gate_w = [(rng.uniform(0.02, 0.04), rng.uniform(0, 2 * np.pi), rng.uniform(0, 2 * np.pi), m) for m in (1, 2)]
    frames = []
    for t in range(LIGHT_PHASES):
        ph = 2 * np.pi * t / LIGHT_PHASES
        p = p0 + np.stack([rad * np.cos(ph + phi), rad * np.sin(ph + phi)], 1)
        wx = xx + 3.0 * np.sin(yy / 11.0 + ph) + 1.5 * np.sin(yy / 5.3 - 2 * ph)          # traits ondulés
        wy = yy + 2.0 * np.sin(xx / 13.0 - ph)
        d, _ = cKDTree(p).query(np.stack([wx, wy], 1), k=2)
        gap = d[:, 1] - d[:, 0]
        wv = sum(np.sin(k * (xx * np.cos(a0) + yy * np.sin(a0)) + m * ph + b0) for k, a0, b0, m in waves) / 3
        gate = sum(np.sin(k * (xx * np.cos(a0) + yy * np.sin(a0)) - m * ph + b0) for k, a0, b0, m in gate_w) / 2
        k = np.zeros(len(yy))
        k[wv > 0.42] = 0.07; k[wv < -0.5] = -0.08                                       # nappes claires / ombres douces
        line = (gap < 1.1) & (gate > -0.35)                                              # traits discontinus
        k[line] = np.maximum(k[line], 0.17)
        k[line & (gap < 0.55) & (gate > 0.3)] = 0.28                                     # nœuds plus vifs
        c = base[yy, xx]
        col = np.where(k[:, None] >= 0, c + (LIGHT - c) * k[:, None], c * (1 + k[:, None]))
        e = np.zeros((H, W, 4), 'uint8'); on = k != 0
        e[yy[on], xx[on], :3] = np.clip(np.round(col[on]), 0, 255); e[yy[on], xx[on], 3] = 255
        frames.append(e)
    return frames


# ---------------------------------------------------------------- motifs : le sceau pulse, l'onde parcourt toutes les gravures
def engraved(floor_layer, mask):
    lum = floor_layer[..., :3].astype(float) @ [.299, .587, .114]
    med = nd.median_filter(np.where(mask, lum, np.nan_to_num(lum)), 9)
    return mask & (lum < med - 10)


def wave_frames(eng, emblem, centre):
    yy, xx = np.mgrid[:H, :W]
    d = np.hypot(xx - centre[0], yy - centre[1])
    rmax = float(d[eng].max()) + 30
    frames = []
    for t in range(WAVE_PHASES):
        front = (rmax + 120) * t / WAVE_PHASES                                           # traîne éteinte avant le raccord
        lag = front - d                                                              # > 0 derrière le front
        lev = np.full((H, W), -1)
        lev[(lag >= 0) & (lag < 14)] = 3
        lev[(lag >= 14) & (lag < 34)] = 2
        lev[(lag >= 34) & (lag < 70)] = 1
        lev[(lag >= 70) & (lag < 120)] = 0
        pulse = [3, 3, 2, 2, 1, 1] + [0] * (WAVE_PHASES - 6)                          # le sceau s'allume d'abord, puis reste veillé
        lev = np.where(emblem, np.maximum(lev, pulse[t]), lev)
        on = eng & (lev >= 0)
        e = np.zeros((H, W, 4), 'uint8'); e[on, :3] = np.array(GLOW)[lev[on]]; e[on, 3] = 255
        frames.append(e)
    return frames, rmax


# ---------------------------------------------------------------- algues : ondulation par cisaillement depuis la base
def weed_frames(layer, mask, rng):
    lab, n = nd.label(mask)
    frames = [np.zeros((H, W, 4), 'uint8') for _ in range(WEED_PHASES)]
    info = []
    for i in range(1, n + 1):
        m = lab == i; ys, xs = np.nonzero(m)
        if len(ys) < 8:
            for f in frames:
                f[m] = layer[m]
            continue
        base, top = ys.max(), ys.min(); hgt = max(base - top, 1); phi = float(rng.uniform(0, 2 * np.pi))
        amp = min(2.4, 0.9 + hgt / 22)
        info.append({'base': [int(xs.mean()), int(base)], 'hauteur': int(hgt), 'phase': round(phi, 3), 'amplitude_px': round(amp, 2)})
        for t, f in enumerate(frames):
            dx = np.round(amp * ((base - ys) / hgt) ** 1.4 * np.sin(2 * np.pi * t / WEED_PHASES + phi)).astype(int)
            nx = np.clip(xs + dx, 0, W - 1)
            f[ys, nx] = layer[ys, xs]
    return frames, info


def fill_under(layer, hole, support):
    """Pixels de paroi sous les algues : couleur du pixel de paroi le plus proche (les algues oscillent de 1 à 2 px)."""
    idx = nd.distance_transform_edt(~support, return_distances=False, return_indices=True)
    out = layer.copy(); out[hole] = layer[idx[0][hole], idx[1][hole]]; out[hole, 3] = 255
    return out


# ---------------------------------------------------------------- bulles
def bubble_sprite(rad):
    """Anneau clair, intérieur transparent sauf un reflet ; rad 0 = point, rad -1 = éclat."""
    px = {}
    if rad == 0:
        px[(0, 0)] = BUBBLE_EDGE
    elif rad == -1:
        for q in ((-2, 0), (2, 0), (0, -2), (0, 2)):
            px[q] = BUBBLE_EDGE
        px[(-1, -1)] = px[(1, 1)] = BUBBLE_HI
    else:
        for y in range(-rad - 1, rad + 2):
            for x in range(-rad - 1, rad + 2):
                d = np.hypot(x, y)
                if rad - 0.5 <= d < rad + 0.5:
                    px[(x, y)] = BUBBLE_EDGE
                elif d < rad - 0.5 and rad >= 3:
                    px[(x, y)] = BUBBLE_IN if (x, y) != (-1, -1) else BUBBLE_HI
        px[(-rad // 2, -rad // 2 - (rad > 1))] = BUBBLE_HI
    return px


def bubble_frames(sources, rng):
    bubbles = []
    for s in sources:
        for _ in range(s['n']):
            life = int(rng.integers(s['life'][0], s['life'][1] + 1))
            bubbles.append({'x0': float(s['xy'][0] + rng.uniform(-s['spread'][0], s['spread'][0])),
                            'y0': float(s['xy'][1] + rng.uniform(-s['spread'][1], s['spread'][1])),
                            'start': int(rng.integers(BUBBLE_PHASES)), 'life': life, 'rise': float(rng.uniform(*s['rise'])),
                            'rmax': int(rng.integers(s['rad'][0], s['rad'][1] + 1)), 'wob': float(rng.uniform(0.6, 1.6)),
                            'phi': float(rng.uniform(0, 2 * np.pi)), 'source': s['nom']})
    frames = []
    for t in range(BUBBLE_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for b in bubbles:
            age = (t - b['start']) % BUBBLE_PHASES
            if age > b['life']:
                continue
            k = age / b['life']
            if age == b['life']:
                rad = -1                                                              # éclat
            else:
                rad = min(b['rmax'], int(k * (b['rmax'] + 1.6)))
            x = int(round(b['x0'] + b['wob'] * np.sin(2 * np.pi * k * 2 + b['phi'])))
            y = int(round(b['y0'] - b['rise'] * k))
            for (dx, dy), c in bubble_sprite(rad).items():
                if 0 <= x + dx < W and 0 <= y + dy < H:
                    e[y + dy, x + dx] = (*c, 255)
        frames.append(e)
    return frames, bubbles


# ---------------------------------------------------------------- scintillements multicolores (façon D42P41A)
def spark_frames(zone, rng, n=80):
    ys, xs = np.nonzero(zone); stars = []
    for i in rng.permutation(len(ys)):
        if len(stars) == n:
            break
        if all(max(abs(int(xs[i]) - s['xy'][0]), abs(int(ys[i]) - s['xy'][1])) >= 7 for s in stars):   # bras jamais superposés
            stars.append({'xy': [int(xs[i]), int(ys[i])], 'phase': int(rng.integers(SPARK_PHASES)),
                          'teinte': list(SPARK_TINTS[int(rng.integers(4))])})
    frames = []
    for t in range(SPARK_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for s in stars:
            L = SPARK_SEQ[(t - s['phase']) % SPARK_PHASES]
            if not L:
                continue
            x, y = s['xy']; c = tuple(s['teinte'])
            for dd in range(1, L + 1):
                for dx, dy in ((dd, 0), (-dd, 0), (0, dd), (0, -dd)):
                    if 0 <= x + dx < W and 0 <= y + dy < H:
                        e[y + dy, x + dx] = (*c, 255)
            e[y, x] = (255, 255, 255, 255)
        frames.append(e)
    return frames, stars


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, rim_full = classify(a)
    order = ['trench', 'weed', 'coral', 'floor', 'walls']
    ex, cols = JM.down_class(a, m, order)
    lab, n = nd.label(ex['floor']); s = nd.sum(ex['floor'], lab, range(1, n + 1))
    main = lab == int(np.argmax(s)) + 1
    speck = ex['floor'] & ~main; n_speck = int(speck.sum())
    full = JM.down_full(a)
    if speck.any():
        ex['floor'] &= ~speck; ex['walls'] |= speck; cols['walls'][speck] = full[speck]
    layers = {'sol_complet': JM.rgba(JM.down_full(f), np.ones((H, W), bool)),
              'sol': JM.rgba(cols['floor'], ex['floor']), 'parois': JM.rgba(cols['walls'], ex['walls'])}
    layers = BM.quantize_layers(layers)
    for k, nm, nc in (('coral', 'coraux', 24), ('weed', 'algues', 24)):
        e = JM.rgba(cols[k], ex[k])
        q = Image.fromarray(e[..., :3]).quantize(colors=nc, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        e[..., :3] = np.array(q.convert('RGB')); e[~ex[k]] = 0; layers[nm] = e
    layers['parois'] = fill_under(layers['parois'], ex['weed'], ex['walls'])
    ex['parois_sous_algues'] = ex['weed'].copy()
    cx, cy = out_xy(*EMBLEM_SRC[:2]); cr = EMBLEM_SRC[2] * S
    yy, xx = np.mgrid[:H, :W]
    emblem = ex['floor'] & (np.hypot(xx - cx, yy - cy) <= cr)
    eng = engraved(layers['sol'], ex['floor'])
    af, abyss = abyss_frames(ex['trench'])
    lf = light_frames(layers['sol'], ex['floor'], np.random.default_rng(21))
    wf, rmax = wave_frames(eng, emblem, (cx, cy))
    gf, weeds = weed_frames(layers['algues'], ex['weed'], np.random.default_rng(5))
    rng = np.random.default_rng(8)
    ab = abyss
    sources = [{'nom': 'abysse', 'xy': ab['centre'], 'spread': [ab['rayons'][0] * 0.8, ab['rayons'][1] * 0.6], 'n': 26,
                'life': (14, 30), 'rise': (18, 46), 'rad': (1, 4)}]
    # évents : anneaux gravés du sol (hors sceau), choisis loin du chemin d'arrivée
    lab, n = nd.label(eng & ~nd.binary_dilation(emblem, iterations=6))
    rings = [c for c in nd.center_of_mass(eng, lab, range(1, n + 1))]
    rng.shuffle(rings)
    vents = [r for r in rings if abs(r[1] - cx) > 60 and r[0] < H - 110][:9]
    for i, (vy, vx) in enumerate(vents):
        sources.append({'nom': f'event_{i}', 'xy': [float(vx), float(vy)], 'spread': [1.5, 1.0], 'n': 3, 'life': (10, 18),
                        'rise': (14, 26), 'rad': (1, 2)})
    for i, wd in enumerate(sorted(weeds, key=lambda w: -w['hauteur'])[:8]):
        sources.append({'nom': f'algue_{i}', 'xy': [wd['base'][0], wd['base'][1] - wd['hauteur']], 'spread': [3, 2], 'n': 2,
                        'life': (10, 16), 'rise': (12, 22), 'rad': (1, 2)})
    bf, bubbles = bubble_frames(sources, rng)
    sf, stars = spark_frames((ex['walls'] & ~nd.binary_dilation(ex['trench'], iterations=4)) | (ex['floor'] & ~emblem),
                             np.random.default_rng(3))
    return dict(a=a, m=m, ex=ex, layers=layers, af=af, abyss=abyss, lf=lf, wf=wf, rmax=rmax, gf=gf, weeds=weeds, bf=bf,
                bubbles=bubbles, sources=sources, sf=sf, stars=stars, emblem=emblem, eng=eng, centre=(cx, cy), n_speck=n_speck)


def fidelity(layers):
    rip = rgb(REF); out = {}
    for nm, lay, crop in (('sol', layers['sol'], FLOOR_REF_CROP), ('sol_complet', layers['sol_complet'], FLOOR_REF_CROP),
                          ('parois', layers['parois'], WALL_REF_CROP)):
        px = lay[lay[..., 3] == 255][:, :3].astype(float)
        x0, y0, x1, y1 = crop
        ref = rip[y0:y1, x0:x1].reshape(-1, 3).mean(0); ours = px.mean(0)
        out[nm] = {'ref_rgb': [round(float(v), 1) for v in ref], 'rgb': [round(float(v), 1) for v in ours], 'pixels': int(len(px)),
                   'distance': round(float(np.linalg.norm(ref - ours)), 2), 'decoupe_ref': list(crop)}
    out['seuil'] = FIDELITY_MAX
    return out


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['kyogre'],
                                                'source': markers['sceau']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text())
    o = doc['Object']
    o['Name'] = {'DefaultText': 'Fin Ocean - arene de Kyogre sous la mer (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Fin de donjon generee 4:3 (ref. D42P41A, fond marin grave) ; sceau de Kyogre au centre, fosse abyssale '
                    'au nord. Abysse en tourbillon, caustiques et nappes de lumiere, onde lumineuse sur toutes les gravures, algues qui '
                    'ondulent, bulles, scintillements. Arrivee au sud, marqueur kyogre devant la fosse, marqueur sceau. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        mk['EntName'] = {'boss': 'kyogre', 'source': 'sceau'}.get(mk['EntName'], mk['EntName'])
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Fin Ocean (arene de Kyogre) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "fin de donjon sous la mer generee au format 4:3 (ref. D42P41A), sceau de Kyogre, fosse abyssale, caustiques, bulles, algues")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


ANIM = {'abysse': ABYSS_TICKS, 'nuances_eau': LIGHT_TICKS, 'motifs_lumineux': WAVE_TICKS, 'algues': WEED_TICKS,
        'bulles': BUBBLE_TICKS, 'scintillements': SPARK_TICKS}


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
    fid = fidelity(layers)
    assert all(fid[k]['distance'] < FIDELITY_MAX for k in ('sol', 'sol_complet', 'parois')), fid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('abysse', D['af'], ABYSS_TICKS), ('sol', [layers['sol']], 60),
                   ('nuances_eau', D['lf'], LIGHT_TICKS), ('motifs_lumineux', D['wf'], WAVE_TICKS), ('parois', [layers['parois']], 60),
                   ('coraux', [layers['coraux']], 60), ('algues', D['gf'], WEED_TICKS), ('bulles', D['bf'], BUBBLE_TICKS),
                   ('scintillements', D['sf'], SPARK_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    walk = ex['floor'].copy()
    blocked = BM.cell_grid(~walk)
    gh_, gw_ = blocked.shape
    col_bottom = [c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()]
    med = int(np.median(np.nonzero(walk[H - 4])[0])) // 8
    cx = min(col_bottom, key=lambda c: abs(c - med))
    entrance = [cx * 8, H - 16]

    def free_near(x, y):
        for dy in range(0, 30):
            for dx in sorted(range(-12, 13), key=abs):
                for sy in (1, -1):
                    gy, gx = y // 8 + sy * dy, x // 8 + dx
                    if 0 <= gy < gh_ - 1 and 0 <= gx < gw_ - 1 and not blocked[gy:gy + 2, gx:gx + 2].any():
                        return [gx * 8, gy * 8]
    ecx, ecy = D['centre']
    sceau = free_near(int(ecx) - 8, int(ecy) - 8)
    ty, tx = np.nonzero(ex['trench'])
    kx = int(tx.mean()) // 8 - 1; kyogre = None                                          # au bord sud de la fosse, dans l'axe
    for gy in range(int(ty.max()) // 8, gh_ - 1):
        for gx in (kx, kx - 1, kx + 1, kx - 2, kx + 2):
            if not blocked[gy:gy + 2, gx:gx + 2].any():
                kyogre = [gx * 8, gy * 8]; break
        if kyogre:
            break
    markers = {'entrance': entrance, 'sceau': sceau, 'kyogre': kyogre}
    paths = {}
    for k in ('sceau', 'kyogre'):
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
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(5 * 1000 / 60), loop=0, lossless=True)
    colim = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, c in (('entrance', (255, 230, 40, 255)), ('sceau', (60, 220, 255, 255)), ('kyogre', (255, 80, 200, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    BM.write_ora(OUT / f'{PFX}_fin_ocean_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'fins de donjon', 'biome': 'fond de l ocean (arene de Kyogre)',
        'demande': ["fait une zone de fin donjon sous l'ocean avec des motif sur toute la zone et des nuance deau des effet de bulle etc "
                    "une zone ou y'aura kyogre apres etc elle doit etre magnifique"],
        'choix_agent': {'reference': 'D42P41A : fond marin grave (anneaux de bulles, fissures de corail) sur tout le sol, anneau de roche '
                                     'bleue, scintillements multicolores ; aucune map sous-marine jouable dans PMD Sky, c est la plus proche',
                        'layout': 'chemin au sud qui s ouvre sur une grande arene ovale ; grand sceau de Kyogre grave au centre ; fosse '
                                  'abyssale au nord d ou Kyogre surgira ; algues et coraux sur les parois ; aucune sortie',
                        'kyogre': 'pas de sprite : marqueur kyogre au bord sud de la fosse, marqueur sceau au centre du sceau',
                        'animations': 'abysse en tourbillon, caustiques + nappes de lumiere (nuances d eau), onde lumineuse sur toutes '
                                      'les gravures depuis le sceau (motifs sur toute la zone), algues qui ondulent, bulles, scintillements'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet avec fosse en magenta (decoupe de style de la reference x3) ; sol complet '
                  'genere depuis une decoupe du sol de la reference (x4)',
        'reference_da': {'code': 'D42P41A', 'fichier': f'source/{LOT}/reference/D42P41A.png', 'sha256': sha(REF),
                         'origine': 'source/outil_maps_pmdsky (pret/pmd-sky c8073235 + skytemple-files, frame 0 sans collision)'},
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC),
                        'images': [f'source/{LOT}/reference/D42P41A_decoupe_style_x3.png'], 'utilise': True},
                       {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'), 'size': list(SRC),
                        'images': [f'source/{LOT}/reference/D42P41A_decoupe_sol_x4.png'], 'utilise': True}],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X, 'miettes_vers_parois_px': D['n_speck'],
                          'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs (sol complet, sol, parois) ; '
                                     'coraux et algues 24 couleurs propres ; animations calculees'},
        'segmentation': {'fosse': 'magenta pur (R, B > 170, G < 110), fermee 3, trous rebouches, dilatee 2 px',
                         'sol': 'ton du sol (51, 122, 160) +- 22, lisse 9 px, ferme 6, rebouche, ouvert 5, composante reliee au bas',
                         'algues': 'G - R > 55, G >= B - 25, G > 80, hors sol, composantes >= 150 px, dilatees 1 px',
                         'coraux': 'R > 110, R - G > 12, B > 100, hors sol, composantes >= 150 px, dilates 1 px',
                         'corniches': f'ellipse {list(RIM_SRC)} hors fosse : parois, non praticables',
                         'parois': 'le reste (corniches de la fosse comprises) ; pixels sous les algues remplis par la paroi la plus proche',
                         'sceau': f'disque mesure sur le brut, centre {list(EMBLEM_SRC[:2])} rayon {EMBLEM_SRC[2]} px',
                         'gravures': 'pixels du sol plus sombres que la mediane locale 9 x 9 de plus de 10'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'abysse': {'phases': ABYSS_PHASES, 'frame_length_ticks': ABYSS_TICKS, 'tons': [list(c) for c in ABYSS_TONES], **D['abyss'],
                   'loi': 'niveau = 1,2 + 3,2 rho^1,3 + 0,9 sin(3 theta + 11 rho - phi) + 0,35 sin(5 theta - 7 rho + 2 phi) - ombre nord ; '
                          'phi = 2 pi t / 24 ; cretes sin > 0,96 en ton clair'},
        'nuances_eau': {'phases': LIGHT_PHASES, 'frame_length_ticks': LIGHT_TICKS, 'lumiere': [int(v) for v in LIGHT],
                        'loi': 'caustiques : F2 - F1 de 420 centres qui tournent sur un cercle (2,5 a 6 px), domaine deforme par des sinus '
                               '(traits ondules), trait < 1,1 px (+17 % vers la lumiere) coupe par une porte ondulante, noeuds (+28 %) ; '
                               'nappes : 3 ondes planes a frequence temporelle entiere, > 0,42 eclaircit de 7 %, < -0,5 assombrit de 8 %',
                        'graine': 21},
        'motifs_lumineux': {'phases': WAVE_PHASES, 'frame_length_ticks': WAVE_TICKS, 'rampe': [list(c) for c in GLOW],
                            'centre_sceau': [round(float(v), 1) for v in D['centre']], 'rayon_max_px': round(D['rmax'], 1),
                            'pixels_graves': int(D['eng'].sum()), 'pixels_sceau': int((D['eng'] & D['emblem']).sum()),
                            'loi': 'front d onde r = (rmax + 120) t / 24 depuis le centre du sceau (traine eteinte au raccord) ; derriere le front : 0-14 px niveau 3, 14-34 '
                                   'niveau 2, 34-70 niveau 1, 70-120 niveau 0 ; le sceau s allume en premier (3, 3, 2, 2, 1, 1) puis reste '
                                   'veille au niveau 0'},
        'algues': {'phases': WEED_PHASES, 'frame_length_ticks': WEED_TICKS, 'touffes': D['weeds'],
                   'loi': 'dx = round(A ((base - y) / h)^1,4 sin(2 pi t / 12 + phi)), base fixe'},
        'bulles': {'phases': BUBBLE_PHASES, 'frame_length_ticks': BUBBLE_TICKS, 'nombre': len(D['bubbles']), 'sources': D['sources'],
                   'couleurs': {'bord': list(BUBBLE_EDGE), 'reflet': list(BUBBLE_HI), 'interieur': list(BUBBLE_IN)},
                   'loi': 'chaque bulle nait a sa phase, grossit, monte en oscillant puis eclate (croix) ; age = (t - debut) mod 48'},
        'scintillements': {'phases': SPARK_PHASES, 'frame_length_ticks': SPARK_TICKS, 'bras': SPARK_SEQ, 'etoiles': D['stars'],
                           'origine': 'calcule ; teintes relevees sur les scintillements de D42P41A (blanc, vert d eau, rose, bleu)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol ; fosse, parois, coraux et algues bloquants'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    np.save(R / '.cache' / LOT / 'walk.npy', walk)
    print(json.dumps({'fidelite': fid, 'markers': markers, 'etoiles': len(D['stars']), 'bulles': len(D['bubbles']),
                      'graves': int(D['eng'].sum()), 'algues': len(D['weeds']), 'miettes': D['n_speck'],
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
