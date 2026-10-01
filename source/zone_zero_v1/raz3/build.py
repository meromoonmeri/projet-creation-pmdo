"""Route Zone Zéro 3 (RAZ3) — fond cristallin du cratère, dernière route avant l'entrée du donjon Zone Zéro, 4:3 (768 x 576).

.venv/bin/python source/zone_zero_v1/raz3/build.py

Demande : réseau de routes dans un abîme façon Zone Zéro, avec des cascades, jusqu'à la map d'entrée du donjon (Pokémon
Paradoxe) ; « 3 routes, choisis les textures de référence pour composer cette zone inédite ».

- Références composées (choix de l'agent), toutes vérifiées au pixel près par source/outil_maps_pmdsky :
  D17P34A (lac de cristal : sol hexagonal lumineux, piliers et amas de cristaux, eau à réseau de reflets) pour le sol, les
  cristaux et l'eau ; P03P01A (zone des cascades, référence de RAZ1-2) pour les cascades du fond du cratère.
- Rendu généré référencé : les deux découpes de style x2 données au générateur, lac en magenta.
- Eau : réseau de reflets de D17P34A recalculé (cellules de Worley arrondies, méthode FWC1) avec les 12 tons exacts de l'eau
  de D17P34A et SA loi (ROM : 4 images de 10 ticks, le réseau ondule sur place sans défiler, boucle 0-1-2-3).
- Cascades, écume et rides : lois de commun.py (P03P01A). Chutes mesurées sur le brut (FALLS) : la roche bleue et les
  cristaux ont les tons de l'eau de chute, la détection automatique de RAZ2 ne s'applique pas.
- Scintillements « téra » : étoiles aux 4 teintes du réseau (commun.GLINT_TINTS) sur les cristaux, 12 x 5.
- Calques : eau (anim), rides (anim), sol complet, sol, parois, cristaux, cascades (anim), écume (anim), scintillements (anim).
- Sortie : le tunnel sombre au bout du chemin, dans la paroi nord (vers EAZ1, la grotte de cristal).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd
from scipy.spatial import cKDTree

HERE = Path(__file__).resolve().parent
ZZ = HERE.parent
R = HERE.parents[2]
RAW = HERE / 'bruts'
LOT = 'zone_zero_v1/raz3'
OUT = R / 'renders' / 'zone_zero_v1' / 'RAZ3'
NAMESPACE = 'route_zone_zero_3'
STAGE = R / '.cache' / 'zone_zero_v1' / NAMESPACE
ASSET = 'raz3_fond_cristallin'
PFX = 'RAZ3'
REFS = {'D17P34A': ZZ / 'reference/D17P34A.png', 'P03P01A': ZZ / 'reference/P03P01A.png', 'D17P11A': ZZ / 'reference/D17P11A.png'}
STYLE = ['source/zone_zero_v1/reference/D17P34A_decoupe_style_x2.png', 'source/zone_zero_v1/reference/P03P01A_decoupe_style_x2.png']
# découpes de fidélité (x0, y0, x1, y1) dans les références
REF_CROPS = {'sol': ('D17P34A', (300, 250, 400, 350)), 'cristaux': ('D17P34A', (150, 100, 230, 180)),
             'parois': ('D17P11A', (20, 80, 120, 180))}
W, H = 768, 576
SRC = (1200, 896)
FLOOR = (110, 220, 244)                     # sol hexagonal du brut, mesuré
FALLS = [(316, 376, 189), (836, 896, 188)]  # chutes (x0, x1, haut de l'écume) mesurées sur le brut, du bord haut
TUNNEL_BOX = (20, 120, 540, 660)            # zone du tunnel nord dans le brut (y0, y1, x0, x1)
SLABS = [(300, 336, 540, 690)]              # rangée de dalles hexagonales plates entre la place et le chemin nord (y0, y1, x0, x1), mesurée
LOOP_TICKS = 240
FIDELITY_MAX = 35
# Eau de D17P34A : 12 tons comptés sur la ROM (x 0-96, y 0-96), du plus sombre au plus clair
WATER_TONES = [(55, 103, 143), (55, 111, 143), (55, 111, 151), (55, 119, 159), (47, 119, 159), (47, 119, 167), (47, 119, 175),
               (47, 127, 175), (47, 127, 183), (47, 135, 183), (47, 135, 191), (47, 151, 191)]
WATER_PHASES, WATER_TICKS = 4, 10           # loi ROM de D17P34A : 4 images de 10 ticks (167 ms)
CELL = (52, 24)                             # cellules de la ROM ~ 52 x 24 px (ovales couchés)
ASPECT = CELL[0] / CELL[1]
ORBIT = (1.5, 3.0)
Q_LINE, Q_EDGE, Q_HALO, Q_NEAR = 0.9, 0.85, 0.79, 0.68
SPARK_PHASES, SPARK_TICKS = 12, 5
SPARK_SEQ = [1, 2, 3, 3, 2, 1, 0, 0, 0, 0, 0, 0]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


C = loadmod('zone_zero_commun', ZZ / 'commun.py')
JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba
BM = JM.BM
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
ANIM = {'eau': WATER_TICKS, 'rides': C.RIPPLE_TICKS, 'cascades': C.CASC_TICKS, 'ecume': C.FOAM_TICKS, 'scintillements': SPARK_TICKS}
PHASES = {'eau': WATER_PHASES, 'rides': C.RIPPLE_PHASES, 'cascades': C.CASC_PHASES, 'ecume': C.FOAM_PHASES, 'scintillements': SPARK_PHASES}
assert all(LOOP_TICKS % (PHASES[k] * ANIM[k]) == 0 for k in ANIM)


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


def lstd_of(a, k=11):
    lum = a @ [.299, .587, .114]
    return np.sqrt(np.clip(nd.uniform_filter(lum ** 2, k) - nd.uniform_filter(lum, k) ** 2, 0, None))


def sol_patch(a, floor):
    """Plage 96 x 96 entièrement dans le sol, la plus proche du ton moyen du sol (pas de 8 px)."""
    best = None; ii = nd.uniform_filter(floor.astype(float), 96)
    for y0 in range(0, SRC[1] - 96, 8):
        for x0 in range(0, SRC[0] - 96, 8):
            if ii[y0 + 48, x0 + 48] < 0.999:
                continue
            p = a[y0:y0 + 96, x0:x0 + 96].reshape(-1, 3)
            sc = float(np.abs(p.mean(0) - FLOOR).sum())
            if best is None or sc < best[0]:
                best = (sc, y0, x0)
    return (best[1], best[1] + 96, best[2], best[2] + 96)


def make_sol(decor, patch):
    y0, y1, x0, x1 = patch; p = decor[y0:y1, x0:x1].astype('uint8')
    row = np.concatenate([p, p[:, ::-1]], 1); tile = np.concatenate([row, row[::-1]], 0)
    return np.tile(tile, (SRC[1] // tile.shape[0] + 1, SRC[0] // tile.shape[1] + 1, 1))[:SRC[1], :SRC[0]]


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    Hs, Ws = a.shape[:2]
    r, g, b = a.transpose(2, 0, 1); mn = a.min(2)
    mag = ((r > 170) & (b > 170) & (g < 110)) | ((r > 180) & (b > 180) & (g < np.minimum(r, b) - 40))   # lac et anneaux roses
    lake = morph(nd.binary_dilation, morph(nd.binary_closing, keep_big(mag, 3000), 2), 1)
    casc = np.zeros((Hs, Ws), bool); white = mn > 190
    foam = np.zeros((Hs, Ws), bool)
    for x0, x1, ye in FALLS:
        casc[:ye, x0:x1] = True
        box = np.zeros((Hs, Ws), bool); box[ye - 6:ye + 40, x0 - 40:x1 + 40] = True
        lab, _ = nd.label(white & box)
        for i in set(np.unique(lab[ye:ye + 20, x0:x1])) - {0}:
            foam |= lab == i
    foam = morph(nd.binary_dilation, nd.binary_fill_holes(morph(nd.binary_closing, foam, 3)), 1) & ~casc
    ls = lstd_of(a)
    near = np.sqrt(((a - FLOOR) ** 2).sum(2)) < 60
    fl = (nd.uniform_filter((near & (ls < 30)).astype(float), 9) > 0.55) & ~lake & ~casc & ~foam
    for y0, y1, x0, x1 in SLABS:                                               # dalles plates : praticables
        fl[y0:y1, x0:x1] |= ~lake[y0:y1, x0:x1]
    fl = nd.binary_fill_holes(fl) & ~lake & ~casc & ~foam
    fl = keep_big(morph(nd.binary_opening, fl, 3), 6000)
    y0, y1, x0, x1 = TUNNEL_BOX
    dark = (a @ [.299, .587, .114] < 60) & (b < 110); tb = np.zeros((Hs, Ws), bool); tb[y0:y1, x0:x1] = True
    tunnel = keep_big(dark & tb, 800)
    tunnel = nd.binary_fill_holes(morph(nd.binary_closing, tunnel, 2))
    rest = ~(lake | casc | foam | fl | tunnel)
    crystal = rest & ((a @ [.299, .587, .114] > 120) | ((b > 170) & (g > 150)))
    crystal = nd.binary_fill_holes(morph(nd.binary_closing, keep_big(crystal, 30), 1)) & rest
    walls = rest & ~crystal
    return dict(lake=lake, casc=casc, foam=foam, floor=fl, tunnel=tunnel, crystal=crystal, walls=walls)


# ---------------------------------------------------------------- eau de D17P34A
def water_sites(rng):
    ys, xs = np.mgrid[-CELL[1]:H + 2 * CELL[1]:CELL[1], -CELL[0]:W + 2 * CELL[0]:CELL[0]]
    xs = xs + (np.arange(xs.shape[0])[:, None] % 2) * CELL[0] / 2
    p0 = np.stack([xs.ravel(), ys.ravel()], 1).astype(float)
    p0 += rng.uniform(-1, 1, p0.shape) * [CELL[0] * 0.35, CELL[1] * 0.35]
    return p0, rng.uniform(*ORBIT, len(p0)), rng.uniform(0, 2 * np.pi, len(p0))


def water_frames(mask, seed=17):
    rng = np.random.default_rng(seed); p0, rad, phi = water_sites(rng)
    n = nd.gaussian_filter(rng.standard_normal((H, W)), (0.8, 2.5)); n /= n.std()        # traînées du fond des cellules
    yy, xx = np.nonzero(mask); nz = n[yy, xx]
    wx = xx + 5.0 * np.sin(yy / 13.0 + 0.7) + 2.5 * np.sin(yy / 5.3 + xx / 29.0)          # domaine déformé (fixe) : traits ondulés
    wy = yy + 3.0 * np.sin(xx / 17.0 + 1.9) + 1.5 * np.sin(xx / 7.1 - yy / 23.0)
    T = np.array(WATER_TONES)
    frames = []
    for t in range(WATER_PHASES):
        th = 2 * np.pi * t / WATER_PHASES + phi
        p = p0 + np.stack([rad * np.cos(th), 0.6 * rad * np.sin(th)], 1)
        d, _ = cKDTree(p * [1, ASPECT]).query(np.stack([wx, wy * ASPECT], 1).astype(float), k=3)
        q = d[:, 0] / d[:, 1]; qj = d[:, 0] / d[:, 2]
        lvl = np.where(nz > 1.0, 0, np.where(nz < -1.0, 2, 1))                          # fond : 3 tons sombres
        lvl = np.where(q > Q_NEAR, 3 + (nz > 0) + 2 * (nz > 0.8), lvl)                    # près du trait
        lvl = np.where((q > Q_HALO) | (qj > Q_HALO - 0.06), 7 + (nz > 0), lvl)
        lvl = np.where((q > Q_EDGE) | (qj > Q_EDGE - 0.05), 9 + (nz > 0), lvl)
        lvl = np.where(q > Q_LINE, 11, lvl)
        e = np.zeros((H, W, 4), 'uint8'); e[yy, xx, :3] = T[lvl]; e[yy, xx, 3] = 255
        frames.append(e)
    return frames


# ---------------------------------------------------------------- scintillements téra
def spark_frames(cr_layer, crystal, seed=23, n_max=90):
    rng = np.random.default_rng(seed)
    lum = cr_layer[..., :3].astype(float) @ [.299, .587, .114]
    cand = np.argwhere(crystal & (lum > np.percentile(lum[crystal], 85)))
    rng.shuffle(cand); stars = []
    for y, x in cand:
        if len(stars) >= n_max:
            break
        if 3 <= x < W - 3 and 3 <= y < H - 3 and all(max(abs(x - s['xy'][0]), abs(y - s['xy'][1])) > 7 for s in stars):
            stars.append({'xy': [int(x), int(y)], 'phase': int(rng.integers(SPARK_PHASES)),
                          'teinte': list(C.GLINT_TINTS[len(stars) % len(C.GLINT_TINTS)])})
    frames = []
    for t in range(SPARK_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for s in stars:
            L = SPARK_SEQ[(t - s['phase']) % SPARK_PHASES]
            if not L:
                continue
            x, y = s['xy']; tint = tuple(s['teinte'])
            for dd in range(1, L + 1):
                c = tint if dd == L and L > 1 else (236, 244, 255)
                for dx, dy in ((dd, 0), (-dd, 0), (0, dd), (0, -dd)):
                    e[y + dy, x + dx] = (*c, 255)
            e[y, x] = (255, 255, 255, 255)
        frames.append(e)
    return frames, stars


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png')
    assert a.shape[:2] == (SRC[1], SRC[0])
    m = classify(a)
    patch = sol_patch(a, m['floor'])
    f = make_sol(a, patch)
    order = ['lake', 'casc', 'foam', 'floor', 'tunnel', 'crystal', 'walls']
    ex, cols = JM.down_class(a, m, order)
    full = JM.down_full(a)
    ex['walls'] |= ex['tunnel']; cols['walls'][ex['tunnel']] = cols['tunnel'][ex['tunnel']]
    lab, n = nd.label(ex['floor']); s = nd.sum(ex['floor'], lab, range(1, n + 1))       # miettes de sol -> cristaux
    speck = ex['floor'] & np.isin(lab, [i + 1 for i, v in enumerate(s) if v < 400]); n_speck = int(speck.sum())
    ex['floor'] &= ~speck; ex['crystal'] |= speck; cols['crystal'][speck] = full[speck]
    rects = []
    for i, (x0, x1, ye) in enumerate(FALLS):
        rects.append({'x0': int(round(x0 * S)) - JM.CROP_X, 'x1': int(round(x1 * S)) - JM.CROP_X, 'y0': 0,
                      'y1': int(round(ye * S)) + 4, 'graine': 31 + i})
    casc = np.zeros((H, W), bool)
    for c in rects:
        casc[c['y0']:c['y1'], c['x0']:c['x1']] = True
    foam = ex['foam'] & ~casc
    wet = ex['lake'] | foam | (ex['casc'] & ~casc)                                        # l'eau passe sous l'écume
    layers = BM.quantize_layers({'sol_complet': JM.rgba(JM.down_full(f), ~wet), 'sol': JM.rgba(cols['floor'], ex['floor'])})
    for nm, e, nc in (('parois', JM.rgba(cols['walls'], ex['walls'] & ~casc), 32), ('cristaux', JM.rgba(cols['crystal'], ex['crystal'] & ~casc), 32)):
        m_ = e[..., 3] == 255
        q = Image.fromarray(e[..., :3]).quantize(colors=nc, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        e[..., :3] = np.array(q.convert('RGB')); e[~m_] = 0; layers[nm] = e
    wf = water_frames(wet)
    lab, n = nd.label(foam); sources = []
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i)
        if len(ys) < 30:
            continue
        sources.append({'centre': [round(float(xs.mean()), 1), round(float(ys.mean()), 1)],
                        'demi_axes': [round((xs.max() - xs.min()) / 2 + 2, 1), round((ys.max() - ys.min()) / 2 + 2, 1)]})
    empty = np.zeros((H, W, 4), 'uint8')
    rf = C.ripple_frames(empty, wet, foam, sources)
    for e in rf:                                                                          # arcs seuls, sur le lac
        e[..., 3] = np.where(e[..., :3].any(2) & ex['lake'], 255, 0); e[e[..., 3] == 0] = 0
    cf = C.cascade_frames(H, W, rects)
    puffs = C.foam_puffs(foam, 5)
    ff = C.foam_frames(H, W, foam, puffs)
    for fr_ in ff:
        fr_[~nd.binary_dilation(wet | casc, iterations=1)] = 0
    sf, stars = spark_frames(layers['cristaux'], layers['cristaux'][..., 3] == 255)
    return dict(a=a, m=m, ex=ex, layers=layers, wf=wf, rf=rf, cf=cf, ff=ff, sf=sf, stars=stars, rects=rects, sources=sources,
                puffs=puffs, wet=wet, casc=casc, patch=patch, n_speck=n_speck)


def fidelity(D):
    out = {}
    for nm, lay in (('sol', 'sol'), ('sol_complet', 'sol_complet'), ('cristaux', 'cristaux'), ('parois', 'parois')):
        code, (x0, y0, x1, y1) = REF_CROPS['sol' if nm == 'sol_complet' else nm]
        ref = rgb(REFS[code])[y0:y1, x0:x1].reshape(-1, 3).astype(float)
        L = D['layers'][lay]; px = L[L[..., 3] == 255][:, :3].astype(float)
        if nm == 'cristaux':                                                              # les découpes contiennent de l'eau
            ref = ref[ref @ [.299, .587, .114] > 140]; px = px[px @ [.299, .587, .114] > 140]
        r_, o_ = ref.mean(0), px.mean(0)
        out[nm] = {'ref': code, 'decoupe_ref': [x0, y0, x1, y1], 'ref_rgb': [round(float(v), 1) for v in r_],
                   'rgb': [round(float(v), 1) for v in o_], 'pixels': int(len(px)), 'distance': round(float(np.linalg.norm(r_ - o_)), 2)}
    out['parois']['note'] = ('roche bleue du cratere : aucune matiere equivalente dans D17P34A ; comparee a la roche de D17P11A, '
                             'signalee, non seuillee')
    out['seuil'] = FIDELITY_MAX
    out['seuille'] = ['sol', 'sol_complet', 'cristaux']
    return out


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['sortie'],
                                                'source': markers['place']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text()); o = doc['Object']
    o['Name'] = {'DefaultText': 'Route Zone Zero 3 - fond cristallin (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Route generee 4:3 (ref. D17P34A + P03P01A) : fond cristallin du cratere de la Zone Zero, lac a '
                    'reseau de reflets (loi ROM de D17P34A, 4 x 10), deux cascades a la loi de P03P01A, ecume, rides, scintillements '
                    'tera. Arrivee au sud, place de cristal, sortie par le tunnel nord (vers EAZ1). Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        mk['EntName'] = {'boss': 'sortie', 'source': 'place'}.get(mk['EntName'], mk['EntName'])
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Route Zone Zero 3 (fond cristallin) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "route generee au format 4:3 (ref. D17P34A + P03P01A), fond cristallin de la Zone Zero, lac, cascades, cristaux")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


def reach_map(blocked, start):
    gh, gw = blocked.shape
    free = np.zeros((gh, gw), bool)
    free[:-1, :-1] = ~(blocked[:-1, :-1] | blocked[1:, :-1] | blocked[:-1, 1:] | blocked[1:, 1:])
    lab, _ = nd.label(free)
    return lab == lab[start]


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
    fid = fidelity(D)
    assert all(fid[k]['distance'] < FIDELITY_MAX for k in fid['seuille']), fid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    Image.fromarray((D['casc'] * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_cascades_rect.png')
    Image.fromarray((D['wet'] * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_eau.png')
    stack_named = [('eau', D['wf'], WATER_TICKS), ('rides', D['rf'], C.RIPPLE_TICKS), ('sol_complet', [layers['sol_complet']], 60),
                   ('sol', [layers['sol']], 60), ('parois', [layers['parois']], 60), ('cristaux', [layers['cristaux']], 60),
                   ('cascades', D['cf'], C.CASC_TICKS), ('ecume', D['ff'], C.FOAM_TICKS), ('scintillements', D['sf'], SPARK_TICKS)]
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
    # sortie : case atteignable la plus proche du bas du tunnel ; place : case atteignable au centre de la place
    ty, tx = np.nonzero(ex['tunnel']); tb = (int(tx.mean()), int(ty.max()))
    cand = [(abs(gx * 8 + 8 - tb[0]) + abs(gy * 8 - tb[1]), gx, gy) for gy in range(gh_ - 1) for gx in range(gw_ - 1) if reach[gy, gx]]
    _, sx, sy = min(cand); sortie = [sx * 8, sy * 8]
    fy, fx = np.nonzero(walk & (np.arange(H)[:, None] > 180) & (np.arange(H)[:, None] < 420))
    pc = (int(np.median(fx)), int(np.median(fy)))
    cand = [(abs(gx * 8 + 8 - pc[0]) + abs(gy * 8 + 8 - pc[1]), gx, gy) for gy in range(gh_ - 1) for gx in range(gw_ - 1) if reach[gy, gx]]
    _, px_, py_ = min(cand); place = [px_ * 8, py_ * 8]
    markers = {'entrance': entrance, 'sortie': sortie, 'place': place}
    paths = {}
    for k in ('sortie', 'place'):
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
    for k, c in (('entrance', (255, 230, 40, 255)), ('sortie', (60, 220, 255, 255)), ('place', (255, 80, 200, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    z = Image.new('RGB', (4 * 250, 250), (20, 20, 20))                                    # zoom eau, 4 phases, x2
    for t in range(4):
        im = scene(t * 10).crop((40, 300, 165, 425)).convert('RGB')
        z.paste(im.resize((250, 250), Image.NEAREST), (t * 250, 0))
    z.save(OUT / 'review' / f'{PFX}_zoom_eau.png')
    BM.write_ora(OUT / f'{PFX}_route_zone_zero_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'reseau Zone Zero (routes RAZ, entree EAZ)', 'biome': 'fond cristallin du cratere de la Zone Zero',
        'demande': ["reseau de routes dans un abime facon Zone Zero avec des cascades jusqu'a la map d'entree du donjon Zone Zero "
                    "(Pokemon Paradoxe)", 'la suite !! (RAZ1, RAZ2)',
                    "je choisis toutes les options recommandees + 3 routes, choisis les textures de reference pour composer cette zone inedite"],
        'choix_agent': {'reseau': 'RAZ1 levre -> RAZ2 terrasses -> RAZ3 fond cristallin (derniere route) -> EAZ1 entree (grotte de cristal)',
                        'references': 'D17P34A (lac de cristal : sol hexagonal, cristaux, eau) + P03P01A (cascades) ; D17P11A pour la roche',
                        'layout': 'lac (magenta) sur toute la carte ; chemin de sol hexagonal du sud a une grande place de cristal, puis '
                                  'vers le tunnel de la paroi nord ; amas et piliers de cristal le long du chemin ; paroi de roche bleue '
                                  'incrustee de cristaux ; deux cascades du bord haut ; ilots de cristal'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet avec lac en magenta (decoupes de style x2 de D17P34A et P03P01A) ; sol complet '
                  '= plage de sol du brut en miroir',
        'references_da': {k: {'fichier': str(p.relative_to(R)), 'sha256': sha(p)} for k, p in REFS.items()},
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC),
                        'images': STYLE, 'utilise': True}],
        'sol_complet': {'methode': 'plage du brut en miroir', 'plage_y0_y1_x0_x1': list(D['patch'])},
        'normalization': {'scale': S, 'crop_x': JM.CROP_X, 'miettes_vers_cristaux_px': D['n_speck'],
                          'methode': 'moyenne ponderee par classe, palette commune 96 couleurs (sol complet, sol) ; palettes propres : '
                                     'parois 32, cristaux 32 ; animations calculees'},
        'segmentation': {'lac': 'magenta pur ou anneaux roses (R, B > 180, G < min(R, B) - 40), >= 3000 px, ferme 2, dilate 1',
                         'cascades': f'rectangles mesures sur le brut (x0, x1, haut de l ecume) : {FALLS}',
                         'ecume': 'blanc (min > 190) relie au pied de chaque chute, ferme 3, rebouche, dilate 1',
                         'sol': f'ton {list(FLOOR)} +- 60 et ecart-type local < 30 (pas japonais hexagonaux), lisse 9, rebouche, ouvert 3, >= 6000 px',
                         'dalles': f'rectangle mesure compte comme sol (dalles hexagonales plates, claires comme les cristaux) : {SLABS}',
                         'tunnel': f'sombre (lum < 60, B < 110) dans {list(TUNNEL_BOX)}, >= 800 px, rebouche (bloquant, compte en parois)',
                         'cristaux': 'reste clair (lum > 120 ou B > 170 et G > 150), >= 30 px, ferme 1, rebouche',
                         'parois': 'le reste (roche bleue)'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'eau': {'phases': WATER_PHASES, 'frame_length_ticks': WATER_TICKS, 'tons': [list(c) for c in WATER_TONES],
                'cellule_px': list(CELL), 'orbite_px': list(ORBIT),
                'loi': 'ROM D17P34A : 4 images de 10 ticks, reseau de reflets qui ondule sur place (0-1-2-3, sans aller-retour ni '
                       'defilement) ; recalcule : cellules de Worley arrondies q = F1 / F2 dans un domaine deforme par des sinus fixes '
                       '(traits ondules), chaque centre fait un tour de son petit cercle en 4 phases'},
        'rides': {'phases': C.RIPPLE_PHASES, 'frame_length_ticks': C.RIPPLE_TICKS, 'sources': D['sources'], 'tons': [list(c) for c in C.RIPPLE_PAL]},
        'cascades': {'phases': C.CASC_PHASES, 'frame_length_ticks': C.CASC_TICKS, 'periode_px': C.CASC_PERIOD, 'pas_px': C.CASC_STEP,
                     'colonnes': D['rects'], 'palette': [list(c) for c in C.CASC_PAL], 'origine': 'loi de P03P01A (commun.py)'},
        'ecume': {'phases': C.FOAM_PHASES, 'frame_length_ticks': C.FOAM_TICKS, 'bouillons': len(D['puffs']), 'palette': [list(c) for c in C.FOAM_PAL]},
        'scintillements': {'phases': SPARK_PHASES, 'frame_length_ticks': SPARK_TICKS, 'sequence': SPARK_SEQ, 'etoiles': D['stars'],
                           'teintes': [list(c) for c in C.GLINT_TINTS], 'note': 'teintes tera du reseau (commun.GLINT_TINTS)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol ; lac, cascades, ecume, parois, tunnel et cristaux bloquants',
                   'sortie_nord': 'devant le tunnel de la paroi nord (vers EAZ1)'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun (raccords RAZ2 -> RAZ3 -> EAZ1 a scripter)'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': fid, 'markers': markers, 'cascades': D['rects'], 'bouillons': len(D['puffs']),
                      'sources': len(D['sources']), 'etoiles': len(D['stars']), 'patch': D['patch'],
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
