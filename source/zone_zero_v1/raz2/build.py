"""Route Zone Zéro 2 (RAZ2) — terrasses aux cascades, réseau de routes vers l'entrée du donjon Zone Zéro, 4:3 (768 x 576).

.venv/bin/python source/zone_zero_v1/raz2/build.py

Demande : réseau de routes dans un abîme façon Zone Zéro (Pokémon Écarlate / Violet), avec des cascades, jusqu'à la map
d'entrée du donjon Zone Zéro (Pokémon Paradoxe). Défauts annoncés : RAZ1 lèvre du cratère, RAZ2 terrasses aux cascades,
RAZ3 fond cristallin, EAZ1 entrée (grotte de cristal).

- Référence canonique : P03P01A (zone des cascades de la jungle, PMD Sky ; capture junglewaterfallzonepmdsky.png vérifiée au
  pixel près par source/outil_maps_pmdsky). Rendu généré référencé : découpe de style x2 donnée au générateur, abîme en magenta.
- Layout RAZ2 : deux terrasses de prairie séparées par une bande de falaise ocre ; escalier taillé au centre ; trois
  cascades qui tombent du bord haut sur la terrasse haute, deux chutes qui passent la falaise du milieu ; abîme à l'est ;
  corniche d'herbe le long du vide jusqu'aux marches du bord haut (sortie vers RAZ3).
- Sol complet : plage de prairie du brut, en miroir (méthode AGM1).
- Escaliers : pierre ocre (couleur des falaises) comptée comme sol par rectangles mesurés sur le brut (STAIRS).
- Calques : abîme (anim), sol complet, eau (rides, anim), sol, falaises, buissons, cascades (anim), écume (anim).
- Lois : source/zone_zero_v1/commun.py (cascades à la loi de P03P01A : 96 px, 32 px par image, 3 x 10 ticks).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
ZZ = HERE.parent
R = HERE.parents[2]
RAW = HERE / 'bruts'
LOT = 'zone_zero_v1/raz2'
OUT = R / 'renders' / 'zone_zero_v1' / 'RAZ2'
NAMESPACE = 'route_zone_zero_2'
STAGE = R / '.cache' / 'zone_zero_v1' / NAMESPACE
ASSET = 'raz2_terrasses_cascades'
PFX = 'RAZ2'
REF = ZZ / 'reference/P03P01A.png'
REF_CROPS = {'prairie': (300, 400, 440, 480), 'pelouse': (40, 780, 240, 980), 'falaises': (280, 40, 470, 300)}
SOL_PATCH = (656, 744, 456, 544)            # plage de prairie propre du brut (y0, y1, x0, x1), mesurée
MEADOW, PATH, LAWN = (75, 140, 69), (152, 200, 87), (42, 128, 31)   # tons du brut (prairie, chemin, pelouse), mesurés
STAIRS = [(425, 568, 356, 436), (0, 16, 968, 1027)]   # escalier de la falaise du milieu, marches de sortie (y0, y1, x0, x1), mesurés
FALL_MIN = 90                               # hauteur mini d'une chute (px du brut)
W, H = 768, 576
SRC = (1200, 896)
LOOP_TICKS = 240
FIDELITY_MAX = 35


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


C = loadmod('zone_zero_commun', ZZ / 'commun.py')
JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')    # down_class, down_full, rgba
BM = JM.BM
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
ANIM = {'abime': C.ABYSS_TICKS, 'eau': C.RIPPLE_TICKS, 'cascades': C.CASC_TICKS, 'ecume': C.FOAM_TICKS}
PHASES = {'abime': C.ABYSS_PHASES, 'eau': C.RIPPLE_PHASES, 'cascades': C.CASC_PHASES, 'ecume': C.FOAM_PHASES}
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


def make_sol(decor):
    y0, y1, x0, x1 = SOL_PATCH; p = decor[y0:y1, x0:x1].astype('uint8')
    row = np.concatenate([p, p[:, ::-1]], 1); tile = np.concatenate([row, row[::-1]], 0)
    return np.tile(tile, (SRC[1] // tile.shape[0] + 1, SRC[0] // tile.shape[1] + 1, 1))[:SRC[1], :SRC[0]]


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    Hs, Ws = a.shape[:2]
    r, g, b = a.transpose(2, 0, 1); mn = a.min(2)
    mag = (r > 170) & (b > 170) & (g < 110)
    void = morph(nd.binary_dilation, morph(nd.binary_closing, keep_big(mag, 3000), 2), 2)
    blue = (b > r + 40) & (b >= g) & ~void
    white = (mn > 165) & (b >= r - 5) & ~void
    pool = (g > r + 30) & (b > g) & (r < 50) & (b < 120) & ~void
    fallw = (blue & (b > 100)) | white                                          # chute : bleu vif ou blanc (les bassins ont B < 100)
    wetm = nd.binary_closing(fallw, structure=np.ones((7, 1)))                # stries sombres comprises
    longm = np.zeros((Hs, Ws), bool)                                            # pixels des courses verticales >= FALL_MIN
    for x in range(Ws):
        col = np.concatenate([[0], wetm[:, x].astype(int), [0]]); dd = np.diff(col)
        for st, en in zip(np.nonzero(dd == 1)[0], np.nonzero(dd == -1)[0]):
            if en - st >= FALL_MIN:
                longm[st:en, x] = True
    longm = nd.binary_closing(longm, structure=np.ones((1, 7)))
    lab, n = nd.label(longm)
    wh = morph(nd.binary_closing, white, 2)
    casc = np.zeros((Hs, Ws), bool); falls = []
    for i in range(1, n + 1):                                                   # une composante = une chute
        comp = lab == i
        cov = comp.sum(0); xs = np.nonzero(cov >= 0.5 * cov.max())[0]
        if len(xs) < 6 or cov.max() < FALL_MIN:
            continue
        x0, x1 = int(xs.min()), int(xs.max()) + 1
        tops = [int(np.nonzero(comp[:, x])[0].min()) for x in range(x0 + 2, x1 - 2)]
        top = int(np.median(tops)); top = 0 if top < 8 else top                # chute qui part du bord haut
        rows = np.nonzero(comp[:, x0:x1].mean(1) > 0.5)[0]
        y = int(rows.max()) + 1                                                 # bas de la course d'eau (écume comprise)
        wide = np.minimum(wh[:, max(0, x0 - 10):x0].mean(1), wh[:, x1:x1 + 10].mean(1))   # l'écume déborde des deux côtés
        yb = next((yy for yy in range(top + (y - top) // 2, min(Hs, y + 40)) if wide[yy] > 0.3), y)
        falls.append({'x0': x0, 'x1': x1, 'y0': top, 'y_ecume': int(yb)}); casc[top:yb, x0:x1] = True
    falls.sort(key=lambda f: (f['y0'], f['x0']))
    lab, _ = nd.label(wh & ~casc); foam = np.zeros_like(casc)
    for f in falls:
        for i in set(np.unique(lab[f['y_ecume']:f['y_ecume'] + 30, f['x0']:f['x1']])) - {0}:
            comp = lab == i
            if comp.sum() < 60000:
                foam |= comp
    foam = morph(nd.binary_dilation, nd.binary_fill_holes(morph(nd.binary_closing, foam, 3)), 1) & ~casc
    water = (blue | pool | white) & ~casc & ~foam
    water = morph(nd.binary_opening, nd.binary_fill_holes(morph(nd.binary_closing, water, 3)), 2) & ~casc & ~foam & ~void
    water = keep_big(water, 300)
    lum = a @ [.299, .587, .114]
    lstd = np.sqrt(np.clip(nd.uniform_filter(lum ** 2, 11) - nd.uniform_filter(lum, 11) ** 2, 0, None))
    near = lambda c, t: np.sqrt(((a - c) ** 2).sum(2)) < t
    meadow, path, lawn = near(MEADOW, 38), near(PATH, 45), near(LAWN, 34) & (lstd < 15)   # pelouse : lisse (les buissons contrastent)
    wet_any = void | water | casc | foam
    fl = (nd.uniform_filter((meadow | path | lawn).astype(float), 9) > 0.55) & ~wet_any
    holes = nd.binary_fill_holes(fl) & ~fl
    hl, hn = nd.label(holes); hs = nd.sum(holes, hl, range(1, hn + 1))
    fl |= np.isin(hl, [i + 1 for i, v in enumerate(hs) if v < 1800]) & ~wet_any   # cailloux et touffes rebouchés
    for y0, y1, x0, x1 in STAIRS:                                              # escaliers : pierre ocre praticable
        fl[y0:y1, x0:x1] = True
    fl = keep_big(morph(nd.binary_opening, fl, 4), 15000)
    green = (g > r + 25) & (g > b + 20) & ~fl & ~wet_any
    bush = keep_big(morph(nd.binary_opening, green, 2), 200)
    bush = nd.binary_fill_holes(morph(nd.binary_closing, bush, 3)) & ~fl & ~wet_any
    walls = ~(wet_any | fl | bush)
    # matières du sol (pour la fidélité) : ton le plus proche, lissé
    dm = np.stack([nd.uniform_filter(np.sqrt(((a - c) ** 2).sum(2)).astype(float), 7) for c in (MEADOW, PATH, LAWN)])
    mat = dm.argmin(0)
    return dict(void=void, casc=casc, foam=foam, water=water, floor=fl, bush=bush, walls=walls), falls, mat


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png')
    assert a.shape[:2] == (SRC[1], SRC[0])
    f = make_sol(a)
    m, falls, mat = classify(a)
    order = ['void', 'casc', 'foam', 'water', 'floor', 'bush', 'walls']
    ex, cols = JM.down_class(a, m, order)
    full = JM.down_full(a)
    # miettes de sol isolées -> buissons (non praticables)
    lab, n = nd.label(ex['floor']); s = nd.sum(ex['floor'], lab, range(1, n + 1))
    speck = ex['floor'] & np.isin(lab, [i + 1 for i, v in enumerate(s) if v < 400]); n_speck = int(speck.sum())
    ex['floor'] &= ~speck; ex['bush'] |= speck; cols['bush'][speck] = full[speck]
    # cascades : rectangles de y = 0 jusqu'un peu sous le haut de l'écume
    rects = []
    for i, fa in enumerate(falls):
        x0 = int(round(fa['x0'] * S)) - JM.CROP_X; x1 = int(round(fa['x1'] * S)) - JM.CROP_X
        y0 = int(round(fa['y0'] * S))
        rects.append({'x0': x0, 'x1': x1, 'y0': y0, 'y1': int(round(fa['y_ecume'] * S)) + 4, 'graine': 11 + i})
    casc = np.zeros((H, W), bool)
    for c in rects:
        casc[c['y0']:c['y1'], c['x0']:c['x1']] = True
    foam = ex['foam'].copy()
    wet = ex['water'] | foam | (ex['casc'] & ~casc)                            # eau sous l'écume et sous les bords de cascade
    # eau fixe : tons du brut, trous (sous l'écume) remplis par l'eau la plus proche
    wl = JM.rgba(cols['water'], ex['water'])
    idx = nd.distance_transform_edt(~ex['water'], return_distances=False, return_indices=True)
    base = wl.copy(); fill = wet & ~ex['water']
    base[fill] = wl[idx[0][fill], idx[1][fill]]; base[..., 3] = np.where(wet, 255, 0)
    layers = BM.quantize_layers({'sol_complet': JM.rgba(JM.down_full(f), ~ex['void']), 'sol': JM.rgba(cols['floor'], ex['floor'])})
    for nm, e, nc in (('falaises', JM.rgba(cols['walls'], ex['walls'] & ~casc), 32), ('buissons', JM.rgba(cols['bush'], ex['bush'] & ~casc), 24),
                      ('eau_fixe', base, 16)):                                   # palettes propres : sinon les verts dominent
        m_ = e[..., 3] == 255
        q = Image.fromarray(e[..., :3]).quantize(colors=nc, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        e[..., :3] = np.array(q.convert('RGB')); e[~m_] = 0; layers[nm] = e
    # escaliers : pierre ocre, palette propre (la palette commune, dominée par la prairie, les verdit)
    stairs = np.zeros((H, W), bool)
    for y0, y1, x0, x1 in STAIRS:
        stairs[int(y0 * S):int(np.ceil(y1 * S)), int(x0 * S) - JM.CROP_X:int(np.ceil(x1 * S)) - JM.CROP_X] = True
    stairs &= ex['floor']
    q = Image.fromarray(np.where(stairs[..., None], full, 0).astype('uint8')).quantize(colors=17, method=Image.Quantize.MEDIANCUT,
                                                                                       dither=Image.Dither.NONE)
    layers['sol'][stairs, :3] = np.array(q.convert('RGB'))[stairs]
    # animations
    af, glints, depth = C.abyss_frames(ex['void'])
    lab, n = nd.label(foam); sources = []
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i)
        if len(ys) < 30:
            continue
        sources.append({'centre': [round(float(xs.mean()), 1), round(float(ys.mean()), 1)],
                        'demi_axes': [round((xs.max() - xs.min()) / 2 + 2, 1), round((ys.max() - ys.min()) / 2 + 2, 1)]})
    rf = C.ripple_frames(layers['eau_fixe'], wet, foam, sources)
    cf = C.cascade_frames(H, W, rects)
    puffs = C.foam_puffs(foam, 5)
    ff = C.foam_frames(H, W, foam, puffs)
    for fr_ in ff:                                                             # l'écume ne déborde pas sur la terre
        fr_[~nd.binary_dilation(wet | casc, iterations=1)] = 0
    return dict(a=a, m=m, ex=ex, layers=layers, af=af, glints=glints, rf=rf, cf=cf, ff=ff, rects=rects, falls=falls,
                sources=sources, puffs=puffs, wet=wet, casc=casc, mat=mat, n_speck=n_speck, stairs=stairs)


def fidelity(D):
    rip = rgb(REF); out = {}
    ys = np.minimum(((np.arange(H) + 0.5) / S).astype(int), SRC[1] - 1); xs = np.minimum(((np.arange(W) + JM.CROP_X + 0.5) / S).astype(int), SRC[0] - 1)
    m768 = D['mat'][ys[:, None], xs[None, :]]
    mat768 = {k: m768 == i for i, k in enumerate(('prairie', 'chemin', 'pelouse'))}
    sol = D['layers']['sol']; walk = (sol[..., 3] == 255) & ~D['stairs']            # escaliers : matière à part, hors mesure
    mats = [('prairie', sol, walk & mat768['prairie'])]
    if (walk & mat768['pelouse']).sum() > 0.05 * walk.sum():                  # pelouse mesurée seulement si c'est une vraie matière
        mats.append(('pelouse', sol, walk & mat768['pelouse']))
    for nm, lay, mask in mats + [
                          ('sol_complet', D['layers']['sol_complet'], D['layers']['sol_complet'][..., 3] == 255),
                          ('falaises', D['layers']['falaises'], D['layers']['falaises'][..., 3] == 255)]:
        crop = REF_CROPS['prairie' if nm == 'sol_complet' else nm]
        px = lay[mask][:, :3].astype(float); x0, y0, x1, y1 = crop
        ref = rip[y0:y1, x0:x1].reshape(-1, 3).mean(0); ours = px.mean(0)
        out[nm] = {'ref_rgb': [round(float(v), 1) for v in ref], 'rgb': [round(float(v), 1) for v in ours], 'pixels': int(len(px)),
                   'distance': round(float(np.linalg.norm(ref - ours)), 2), 'decoupe_ref': list(crop)}
    px = sol[walk & mat768['chemin']][:, :3].astype(float)
    out['chemin'] = {'rgb': [round(float(v), 1) for v in px.mean(0)], 'pixels': int(len(px)),
                     'note': 'herbe rase claire : ton absent de P03P01A (choix du generateur, garde comme matiere a part), non seuille'}
    if 'pelouse' not in out:
        out['pelouse_absente'] = {'pixels': int((walk & mat768['pelouse']).sum()),
                                  'note': 'pas de pelouse dans ce brut (pixels isoles mal classes, non mesures)'}
    out['seuil'] = FIDELITY_MAX
    return out


def ground_project(stack, blocked, markers, gfx, tools):
    for k in ('STAGE', 'PFX', 'ASSET', 'NAMESPACE', 'HERE', 'W', 'H'):
        setattr(FV, k, globals()[k])
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['sortie'],
                                                'source': markers['belvedere']}, gfx, tools)
    doc_p = STAGE / f'Data/Ground/{ASSET}.rsground'
    doc = json.loads(doc_p.read_text()); o = doc['Object']
    o['Name'] = {'DefaultText': 'Route Zone Zero 2 - terrasses aux cascades (4:3)', 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Route generee 4:3 (ref. P03P01A, zone des cascades) : terrasses aux cascades de la Zone Zero, abime '
                    'en brume a l est, cinq cascades a la loi de P03P01A (trois du bord haut, deux par-dessus la falaise du milieu), '
                    'ecume, rides. Arrivee au sud, escalier, sortie au nord par la corniche. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        mk['EntName'] = {'boss': 'sortie', 'source': 'belvedere'}.get(mk['EntName'], mk['EntName'])
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (STAGE / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', 'Route Zone Zero 2 (terrasses aux cascades) 4:3')
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "route generee au format 4:3 (ref. P03P01A), terrasses aux cascades de la Zone Zero, abime, cascades, ecume")
    (STAGE / 'Mod.xml').write_text(x)
    return counts


EDIT_ZONE = (0, 896, 0, 170)                # zone de l'édition (y0, y1, x0, x1) dans le brut : bande du bord gauche


def edit_gap():
    a, b = rgb(RAW / 'decor_magenta_v0.png'), rgb(RAW / 'decor_magenta.png')
    d = np.abs(a - b).sum(2); z = np.zeros(d.shape, bool); y0, y1, x0, x1 = EDIT_ZONE; z[y0:y1, x0:x1] = True
    return {'zone_y0_y1_x0_x1': list(EDIT_ZONE), 'somme_rvb_moyenne': round(float(d[~z].mean()), 2),
            'part_pixels_ecart_60': round(float((d[~z] > 60).mean()), 4)}


def reach_map(blocked, start):
    """Cases (coin haut-gauche d'un personnage 2 x 2) atteignables depuis start, 4-voisinage."""
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
    assert all(fid[k]['distance'] < FIDELITY_MAX for k in ('prairie', 'pelouse', 'sol_complet', 'falaises') if k in fid), fid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    Image.fromarray((D['casc'] * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_cascades_rect.png')
    Image.fromarray((D['stairs'] * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_escaliers.png')
    stack_named = [('abime', D['af'], C.ABYSS_TICKS), ('sol_complet', [layers['sol_complet']], 60), ('eau', D['rf'], C.RIPPLE_TICKS),
                   ('sol', [layers['sol']], 60), ('falaises', [layers['falaises']], 60), ('buissons', [layers['buissons']], 60),
                   ('cascades', D['cf'], C.CASC_TICKS), ('ecume', D['ff'], C.FOAM_TICKS)]
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
    col_top = [c for c in range(gw_ - 1) if not blocked[0:2, c:c + 2].any()]
    assert col_top, 'pas de sortie nord'
    medt = int(np.median(np.nonzero(walk[3])[0])) // 8
    st = min(col_top, key=lambda c: abs(c - medt)); sortie = [st * 8, 0]
    # belvédère : case atteignable la plus proche du bord de l'abîme, à l'ouest de la corniche, au sud du vide
    reach = reach_map(blocked, (entrance[1] // 8, entrance[0] // 8))
    vy, vx = np.nonzero(ex['void']); best = None
    for gy in range(gh_ - 1):
        for gx in range(gw_ - 1):
            if not reach[gy, gx] or gy * 8 < 40:
                continue
            d = np.min(np.hypot(vx - (gx * 8 + 8), vy - (gy * 8 + 8)))
            if d < 14 and gx * 8 < sortie[0] - 40 and (best is None or gy > best[1]):
                best = (gx * 8, gy * 8)
    belvedere = list(best)
    markers = {'entrance': entrance, 'sortie': sortie, 'belvedere': belvedere}
    paths = {}
    for k in ('sortie', 'belvedere'):
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
    for k, c in (('entrance', (255, 230, 40, 255)), ('sortie', (60, 220, 255, 255)), ('belvedere', (255, 80, 200, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    z = Image.new('RGB', (3 * 240 + 20, 320), (20, 20, 20))                   # zoom cascade + écume, 3 phases, x2
    fa = D['rects'][2]
    for t in range(3):
        im = scene(t * 10).crop((fa['x0'] - 50, fa['y1'] - 120, fa['x0'] + 70, fa['y1'] + 40)).convert('RGB')
        z.paste(im.resize((240, 320), Image.NEAREST), (t * 250, 0))
    z.save(OUT / 'review' / f'{PFX}_zoom_cascade.png')
    BM.write_ora(OUT / f'{PFX}_route_zone_zero_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'reseau Zone Zero (routes RAZ, entree EAZ)', 'biome': 'terrasses aux cascades de la Zone Zero',
        'demande': ["reseau de routes dans un abime facon Zone Zero avec des cascades jusqu'a la map d'entree du donjon Zone Zero "
                    "(Pokemon Paradoxe)", 'la suite !! (RAZ1)', 'la suite !! (RAZ2)'],
        'choix_agent': {'reseau': 'RAZ1 levre du cratere -> RAZ2 terrasses aux cascades -> RAZ3 fond cristallin -> EAZ1 entree '
                                  '(grotte de cristal) ; 4:3, arrivee au sud, sortie au nord (defauts annonces, questions sans reponse)',
                        'reference': 'P03P01A (zone des cascades de la jungle) : falaises ocre, cascades, bassins, ecume, prairie',
                        'layout': 'deux terrasses de prairie separees par une bande de falaise ocre, escalier taille au centre ; '
                                  'trois cascades du bord haut vers les bassins de la terrasse haute, deux chutes par-dessus la '
                                  'falaise du milieu ; abime (magenta) sur le tiers est ; corniche d herbe le long du vide jusqu aux '
                                  'marches du bord haut ; buissons le long du bord gauche',
                        'abime': 'calcule : profondeur par distance au bord, brume qui ondule, eclats de cristal lointains (annonce '
                                 'du fond cristallin)'},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet avec abime en magenta (decoupe de style de P03P01A x2) ; sol complet = '
                  'plage de prairie du brut en miroir',
        'reference_da': {'code': 'P03P01A', 'fichier': 'source/zone_zero_v1/reference/P03P01A.png', 'sha256': sha(REF),
                         'origine': 'capture junglewaterfallzonepmdsky.png, identifiee P03P01A au pixel pres par source/outil_maps_pmdsky'},
        'raw_inputs': [{'file': f'source/{LOT}/bruts/decor_magenta_v0.png', 'sha256': sha(RAW / 'decor_magenta_v0.png'), 'size': list(SRC),
                        'images': ['source/zone_zero_v1/reference/P03P01A_decoupe_style_x2.png'], 'utilise': False,
                        'note': 'premier rendu ; la prairie touchait le bord gauche (y 400-440 et 750-885 : sorties laterales)'},
                       {'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'), 'size': list(SRC),
                        'images': [f'source/{LOT}/bruts/decor_magenta_v0.png'], 'utilise': True,
                        'edition': 'un seul changement : bande continue de buissons (~110 px) le long du bord gauche',
                        'ecart_hors_zone': edit_gap()}],
        'sol_complet': {'methode': 'plage du brut en miroir', 'plage_y0_y1_x0_x1': list(SOL_PATCH),
                        'note': 'deux sols generes ecartes (trop sature, distance ~35 ; puis generateur sans reponse)'},
        'normalization': {'scale': S, 'crop_x': JM.CROP_X, 'miettes_vers_buissons_px': D['n_speck'],
                          'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs (sol complet, sol) ; palettes propres : '
                                     'falaises 32, buissons 24, eau 16 ; animations calculees'},
        'segmentation': {'abime': 'magenta pur (R, B > 170, G < 110), composantes >= 3000 px, ferme 2, dilate 2',
                         'cascades': 'eau de chute (bleu vif B > 100 ou blanc ; les bassins ont B < 100) fermee 7 px en vertical ; '
                                     'courses verticales >= 90 px, une composante = une chute (haut < 8 px -> bord haut) ; bas = '
                                     'premiere ligne ou l ecume deborde des deux cotes',
                         'escaliers': f'rectangles mesures sur le brut comptes comme sol : {STAIRS}',
                         'ecume': 'blanc (min > 165) ferme 2 au pied de chaque cascade, rebouche, dilate 1',
                         'eau': 'bleu (B > R + 40) ou bassin sombre (G > R + 30, B > G, R < 50), ferme 3, rebouche, ouvert 2',
                         'sol': f'prairie {list(MEADOW)} +- 38, chemin {list(PATH)} +- 45, pelouse {list(LAWN)} +- 34 et ecart-type local < 15 ; '
                                'lisse 9, cailloux rebouches, ouvert 4, composantes >= 15000 px',
                         'buissons': 'vert (G > R + 25, G > B + 20) hors sol, ouvert 2, >= 200 px, ferme 3',
                         'falaises': 'le reste (falaises, rochers, bords de la corniche)'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'abime': {'phases': C.ABYSS_PHASES, 'frame_length_ticks': C.ABYSS_TICKS, 'tons': [list(c) for c in C.ABYSS_TONES],
                  'eclats': D['glints'], 'sequence_eclat': C.GLINT_SEQ,
                  'loi': 'niveau = 2,3 + 1,2 (1 - p) + 1,9 brume + 0,9 sin(y / 17 - x / 90 + phi), p = min(distance au bord / 90, 1) ; brume = '
                         'somme de 3 sinus a frequences temporelles 1, 2, 1 sur 24 phases ; ombre sous la levre (< 4 px) ; tramage ordonne 2 x 2'},
        'eau': {'phases': C.RIPPLE_PHASES, 'frame_length_ticks': C.RIPPLE_TICKS, 'sources': D['sources'], 'tons_rides': [list(c) for c in C.RIPPLE_PAL],
                'loi': '3 arcs par source a rho = 1,08 + 0,2 (k + t / 3) (ellipse de l ecume), trait 0,022 + 0,004 k, coupes par sin(9 theta + 2 k)'},
        'cascades': {'phases': C.CASC_PHASES, 'frame_length_ticks': C.CASC_TICKS, 'periode_px': C.CASC_PERIOD, 'pas_px': C.CASC_STEP,
                     'colonnes': D['rects'], 'palette': [list(c) for c in C.CASC_PAL],
                     'origine': 'loi relevee sur P03P01A (ROM : 3 images de 10 ticks, motif de 96 px qui descend de 32 px par image) ; '
                                'motif recalcule (pas de pixels natifs) avec les 14 tons de la cascade de P03P01A'},
        'ecume': {'phases': C.FOAM_PHASES, 'frame_length_ticks': C.FOAM_TICKS, 'bouillons': len(D['puffs']), 'palette': [list(c) for c in C.FOAM_PAL],
                  'loi': 'chaque bouillon grossit de 0 / 1 / 0,4 px selon (t + phase) mod 3 et glisse de 1 px a la phase 1 ; ombrage haut-gauche'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol ; abime, eau, cascades, ecume, falaises et buissons bloquants',
                   'sortie_nord': 'corniche et marches jusqu au bord haut (vers RAZ3)', 'escalier': 'seul passage entre les terrasses'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun (raccords RAZ1 -> RAZ2 -> RAZ3 a scripter)'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': fid, 'markers': markers, 'cascades': D['rects'], 'bouillons': len(D['puffs']),
                      'sources': len(D['sources']), 'eclats': len(D['glints']), 'miettes': D['n_speck'],
                      'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
