"""Réseau Zone Zéro V2, routes fleuries (RAF1, RAF2) — 4:3 (768 x 576).

.venv/bin/python source/zone_zero_v2/build.py raf1      (puis raf2)

Demande : « pour les zone area faut la texture sky peak et les fleur de différente couleur et les arbre pmd et les cascade
garde les doit avoir leurs propre calque les trou faut que genere vraiment cette effet de profondeur etc vasy go ! »
Lecture de l'agent : les routes Zone Zéro à cascades et à trous d'abîme, RAZ1 et RAZ2, refaites en V2 (RAZ1 et RAZ2 gardées).

- Bruts (générateur d'images, référencés) :
  * decor : le brut RAZ de la V1 repeint avec la découpe x2 de Sky Peak (GIF 2cwdrrs469f61.gif, frame 0) et la découpe x2
    des arbres d'Apple Woods : herbe et falaises de Sky Peak, fleurs de cinq couleurs, arbres PMD ; mêmes cascades, bassins
    et chemins ; l'abîme reste en magenta pur (= masque du vide).
  * gouffre : édition du décor où SEUL le magenta devient un gouffre profond. Le générateur a aussi retouché le reste :
    on ne prend ses pixels QUE dans le masque magenta du décor.
  * arbres : les arbres PMD peints dans les bruts de décor sont découpés et replantés en lisière (miroirs compris). Deux
    planches d'arbres générées à part ont été REJETÉES (couleurs hors Apple Woods : émeraude, puis kaki).
- Calques : sol complet, abîme (généré, fixe), brume profonde et brume haute (parallaxe), lueurs, eau (rides), sol,
  falaises, fleurs (anim), buissons, arbres, cascades (anim, loi P03P01A), écume.
- Tout est généré ou calculé : aucun pixel natif. La loi des fleurs est celle du GIF Sky Peak (A B A C, 12 ticks, cf. ZRV2),
  celle des cascades celle de P03P01A (source/zone_zero_v1/commun.py).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil, sys

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
REFD = HERE / 'reference'
W, H = 768, 576
SRC = (1200, 896)
FIDELITY_MAX = 35
LOOP_TICKS = 480
FLOWER_PHASES, FLOWER_TICKS = 4, 12              # GIF Sky Peak : 4 images de 200 ms, A B A C
DEEP_PHASES, DEEP_TICKS, DEEP_STEP = 24, 20, 4   # brume profonde : +4 px / phase vers l'est, période 96 px
HIGH_PHASES, HIGH_TICKS, HIGH_STEP = 24, 10, -8  # brume haute : -8 px / phase vers l'ouest, période 192 px
GLINT_PHASES, GLINT_TICKS = 24, 10
BAYER4 = np.array([[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]) / 16.0
DEEP_TONES = [(26, 58, 74), (38, 80, 96), (58, 104, 118), (84, 130, 142)]          # brume du fond (bleu-vert sombre)
HIGH_TONES = [(118, 150, 166), (146, 176, 190), (176, 200, 210)]                   # voiles de brume clairs à mi-hauteur
GLINT_TINTS = [(240, 170, 226), (150, 236, 236), (255, 255, 255), (190, 170, 255)]  # éclats téra lointains
GLINT_SEQ = [1, 2, 3, 2, 1] + [0] * 19
DEPTH_GRADE, DEPTH_NIGHT = 0.45, (10, 30, 44)       # dégradé statique du gouffre vers le bleu nuit

CFG = {
    'raf1': dict(PFX='RAF1', base='raz1', NAMESPACE='route_zone_zero_fleurie_1', ASSET='raf1_levre_cratere_fleurie',
                 titre='Route Zone Zero 1 fleurie - levre du cratere (4:3)',
                 decor='decor_magenta_b.png', chaine=['decor_magenta.png', 'decor_magenta_b.png'], gouffre='decor_gouffre.png',
                 stairs=[], entree_x=357, sortie=(383, 4), belvedere=(300, 236), graine=3,
                 edition_b='arbres et fleurs en plus (demande : buissons des coins -> arbres ; le generateur a peu change)'),
    'raf2': dict(PFX='RAF2', base='raz2', NAMESPACE='route_zone_zero_fleurie_2', ASSET='raf2_terrasses_fleuries',
                 titre='Route Zone Zero 2 fleurie - terrasses aux cascades (4:3)',
                 decor='decor_magenta.png', chaine=['decor_magenta.png'], gouffre='decor_gouffre.png',
                 stairs=[(425, 568, 340, 452), (0, 18, 966, 1030)], entree_x=249, sortie=(639, 4), belvedere=(470, 452), graine=5,
                 edition_b=None, massifs_falaise=[(22, 548, 54, 576), (443, 543, 480, 576)]),
    'raf3': dict(PFX='RAF3', base='raz3', NAMESPACE='route_zone_zero_fleurie_3', ASSET='raf3_fond_fleuri',
                 titre='Route Zone Zero 3 fleurie - fond du cratere et tunnel (4:3)',
                 decor='decor_magenta.png', chaine=['decor_magenta.png'], gouffre='decor_gouffre.png',
                 stairs=[(275, 338, 548, 668)], entree_x=390, sortie=(388, 64), belvedere=(236, 372), graine=9,
                 edition_b=None, sortie_grotte=True, retouche_magenta=True, chutes_x=[(300, 395), (820, 915)], cristaux=True,
                 massifs_falaise=[(245, 170, 298, 202), (430, 277, 477, 311), (272, 400, 332, 442), (270, 445, 302, 477),
                                 (134, 143, 162, 170), (596, 148, 622, 174)]),
    'eaf1': dict(PFX='EAF1', base='eaz1', base_raw='source/zone_zero_v1/eaz1/bruts/decor.png',
                 NAMESPACE='entree_zone_zero_fleurie', ASSET='eaf1_entree_zone_zero_fleurie',
                 titre='Entree Zone Zero fleurie - la geode du donjon (4:3)',
                 decor='decor_magenta_c.png', chaine=['decor_magenta.png', 'decor_magenta_b.png', 'decor_magenta_c.png'],
                 gouffre='decor_gouffre.png', stairs=[], entree_x=384, sortie=(530, 196), sortie_y_max=220, belvedere=(632, 264), aplat_max=52,
                 arbres_min=10, massifs_falaise=[(270, 400, 334, 444), (268, 444, 304, 480)],
                 graine=13, edition_b=None, sortie_grotte=True, retouche_magenta=True, chutes_x=[(430, 515), (570, 665)],
                 dalles=(178, 197, 152), cristaux=True,
                 demande='la suite ! (apres la passe haute qualite des routes Zone Zero : faut que les zone route area zero soit magnifique avec la verdure sky peak hight qualite les fleur avec plein de couleur des cascade de la brume etc)',
                 lecture='suite du reseau fleuri : EAZ1 (grotte de cristal sombre, gardee) refaite en entree fleurie haute qualite, RAF3 -> EAF1 -> ATP1'),
}
GRASS = (128, 240, 104)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


C = loadmod('zone_zero_commun', R / 'source/zone_zero_v1/commun.py')
JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')
BM = JM.BM
FV = loadmod('fvs1_fin', R / 'source/fin_vapeur_sommet_v1/build.py')
HQ = loadmod('zone_zero_v2_hq', HERE / 'haute_qualite.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE
ANIM = {'brume_profonde': DEEP_TICKS, 'brume_haute': HIGH_TICKS, 'lueurs': GLINT_TICKS, 'eau': C.RIPPLE_TICKS,
        'herbes': HQ.HERBES_TICKS, 'fleurs': FLOWER_TICKS, 'cascades': C.CASC_TICKS, 'ecume': C.FOAM_TICKS,
        'embruns': HQ.EMBRUNS_TICKS, 'papillons': HQ.PAPILLONS_TICKS, 'reflets': HQ.REFLETS_TICKS}
PHASES = {'brume_profonde': DEEP_PHASES, 'brume_haute': HIGH_PHASES, 'lueurs': GLINT_PHASES, 'eau': C.RIPPLE_PHASES,
          'herbes': HQ.HERBES_PHASES, 'fleurs': FLOWER_PHASES, 'cascades': C.CASC_PHASES, 'ecume': C.FOAM_PHASES,
          'embruns': HQ.EMBRUNS_PHASES, 'papillons': HQ.PAPILLONS_PHASES, 'reflets': HQ.REFLETS_PHASES}
assert all(LOOP_TICKS % (PHASES[k] * ANIM[k]) == 0 for k in ANIM)
assert DEEP_PHASES * DEEP_STEP == 96 and -HIGH_PHASES * HIGH_STEP == 192


def paths(m):
    c = CFG[m]; lot = HERE / m
    return dict(lot=lot, raw=lot / 'bruts', out=R / 'renders/zone_zero_v2' / c['PFX'],
                stage=R / '.cache/zone_zero_v2' / c['NAMESPACE'])


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


def hsh(i, k):
    return (i * 2654435761 + k * 40503) % 4294967296


def to768(y, x):
    return int(round(y * S)), int(round(x * S)) - JM.CROP_X


# ---------------------------------------------------------------- règles de couleur (mêmes sur la référence et la scène)
def grass_rule(a):
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    return (g > 185) & (g - r > 40) & (g - b > 70)


def rock_rule(a):
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    return (b >= g - 6) & (g >= r - 4) & (b - r < 70) & (a.max(-1) - a.min(-1) < 75) & (a.min(-1) > 40)


def tree_rule(a):
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    return (g > r + 25) & (g > b + 30) & (g < 185)


def magenta(a):
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    mag = (r > 170) & (b > 170) & (g < 110)
    return mag | (morph(nd.binary_dilation, mag, 2) & (r - g > 45) & (b - g > 35))


# ---------------------------------------------------------------- composite et segmentation pleine résolution
def composite(m):
    P = paths(m); c = CFG[m]
    dec, gf = rgb(P['raw'] / c['decor']), rgb(P['raw'] / c['gouffre'])
    assert dec.shape[:2] == (SRC[1], SRC[0]) == gf.shape[:2]
    void = keep_big(magenta(dec), 3000)
    void = morph(nd.binary_dilation, morph(nd.binary_closing, void, 2), 1)
    a = dec.copy(); a[void] = gf[void]
    if c.get('retouche_magenta'):                                                 # miettes de magenta pur hors du vide -> pixel voisin
        pure = (dec[..., 0] > 230) & (dec[..., 1] < 40) & (dec[..., 2] > 230) & ~void
        pure = morph(nd.binary_dilation, pure, 1) & ~void
        if pure.any():
            iy, ix = nd.distance_transform_edt(pure | void, return_distances=False, return_indices=True)
            a[pure] = dec[iy[pure], ix[pure]]
    return a, void, dec, gf


def classify(a, void, stairs, falls_x=None, dalles=None):
    Hs, Ws = a.shape[:2]
    r, g, b = a.transpose(2, 0, 1); mn = a.min(2)
    stm = np.zeros((Hs, Ws), bool)
    for y0, y1, x0, x1 in stairs:                                                # escaliers de pierre : jamais de l'eau
        stm[y0:y1, x0:x1] = True
    blue = (b > r + 40) & (b >= g) & ~void & ~stm
    white = (mn > 165) & (b >= r - 5) & ~void & ~stm
    pool = (g > r + 30) & (b > g) & (r < 50) & (b < 120) & ~void & ~stm
    fallw = (blue & (b > 100)) | white
    wetm = nd.binary_closing(fallw, structure=np.ones((7, 1)))
    longm = np.zeros((Hs, Ws), bool)
    for x in range(Ws):
        col = np.concatenate([[0], wetm[:, x].astype(int), [0]]); dd = np.diff(col)
        for st, en in zip(np.nonzero(dd == 1)[0], np.nonzero(dd == -1)[0]):
            if en - st >= 90:
                longm[st:en, x] = True
    longm = nd.binary_closing(longm, structure=np.ones((1, 7)))
    lab, n = nd.label(longm)
    wh = morph(nd.binary_closing, white, 2)
    casc = np.zeros((Hs, Ws), bool); falls = []
    for i in range(1, n + 1):
        comp = lab == i
        cov = comp.sum(0); xs = np.nonzero(cov >= 0.5 * cov.max())[0]
        if len(xs) < 6 or cov.max() < 90:
            continue
        x0, x1 = int(xs.min()), int(xs.max()) + 1
        tops = [int(np.nonzero(comp[:, x])[0].min()) for x in range(x0 + 2, x1 - 2)]
        top = int(np.median(tops)); top = 0 if top < 8 else top
        rows = np.nonzero(comp[:, x0:x1].mean(1) > 0.5)[0]
        y = int(rows.max()) + 1
        wide = np.minimum(wh[:, max(0, x0 - 10):x0].mean(1), wh[:, x1:x1 + 10].mean(1))
        yb = next((yy for yy in range(top + (y - top) // 2, min(Hs, y + 40)) if wide[yy] > 0.3), y)
        if falls_x is not None and (top > 10 or not any(x0 >= fx0 and x1 <= fx1 for fx0, fx1 in falls_x)):
            continue                                                              # cristaux clairs, pas une chute peinte
        falls.append({'x0': x0, 'x1': x1, 'y0': top, 'y_ecume': int(yb)}); casc[top:yb, x0:x1] = True
    falls.sort(key=lambda f: (f['y0'], f['x0']))
    lab, _ = nd.label(wh & ~casc); foam = np.zeros_like(casc)
    for f in falls:
        for i in set(np.unique(lab[f['y_ecume']:f['y_ecume'] + 30, f['x0']:f['x1']])) - {0}:
            comp = lab == i
            if comp.sum() < 60000:
                foam |= comp
    foam = morph(nd.binary_dilation, nd.binary_fill_holes(morph(nd.binary_closing, foam, 3)), 1) & ~casc
    if falls_x is not None:                                                       # RAF3 : falaises gris-bleu -> eau = bleu sombre des bassins
        lum0 = a @ [.299, .587, .114]
        water = (((b > g + 12) & (b > r + 25) & (lum0 < 105)) | pool) & ~casc & ~foam & ~void
    else:
        water = (blue | pool | white) & ~casc & ~foam
    water = morph(nd.binary_opening, nd.binary_fill_holes(morph(nd.binary_closing, water, 3)), 2) & ~casc & ~foam & ~void
    if falls_x is not None:                                                       # bassin = sous l'écume de chaque chute
        box = np.zeros_like(water)
        for f in falls:
            box[max(0, f['y_ecume'] - 22):f['y_ecume'] + 90, max(0, f['x0'] - 75):f['x1'] + 75] = True
        water &= box
        water = nd.binary_fill_holes(morph(nd.binary_closing, water, 3)) & box & ~casc & ~foam & ~void
    wl_, wn_ = nd.label(water)                                                   # eau = bassins : touche une chute ou l'écume,
    near_fall = morph(nd.binary_dilation, casc | foam, 6)                          # ou >= 6000 px (pas les massifs de fleurs bleues)
    ws_ = nd.sum(water, wl_, range(1, wn_ + 1)); wt_ = nd.maximum(near_fall, wl_, range(1, wn_ + 1))
    water = np.isin(wl_, [i + 1 for i in range(wn_) if ws_[i] >= 300 and (wt_[i] or (ws_[i] >= 6000 and falls_x is None))])
    wet_any = void | water | casc | foam
    lum = a @ [.299, .587, .114]
    path2 = np.sqrt(((a - (240, 232, 192)) ** 2).sum(2)) < 40                   # chemin beige (RAF2)
    if dalles is not None:                                                        # EAF1 : pas japonais vert sauge
        path2 |= np.sqrt(((a - dalles) ** 2).sum(2)) < 32
    fl = (nd.uniform_filter((grass_rule(a) | path2).astype(float), 9) > 0.55) & ~wet_any
    holes = nd.binary_fill_holes(fl) & ~fl
    hl, hn = nd.label(holes); hs = nd.sum(holes, hl, range(1, hn + 1))
    sat0 = a.max(2) - a.min(2)
    flowerish = ~grass_rule(a) & ~((g > r + 12) & (g > b + 30)) & (lum > 95) & ((sat0 > 60) | (mn > 205))
    fr_ = nd.sum(flowerish, hl, range(1, hn + 1)) / np.maximum(hs, 1)
    fl |= np.isin(hl, [i + 1 for i, v in enumerate(hs) if v < 2500 or (v < 25000 and fr_[i] > 0.3)]) & ~wet_any   # fleurs (grands massifs compris), cailloux, touffes
    fl = keep_big(morph(nd.binary_opening, fl | stm, 4), 4000) & ~wet_any
    veg = tree_rule(a) & ~fl & ~wet_any
    veg = keep_big(morph(nd.binary_opening, veg, 2), 200)
    veg = nd.binary_fill_holes(morph(nd.binary_closing, veg, 3)) & ~fl & ~wet_any
    walls = ~(wet_any | fl | veg)
    # fleurs : petites taches non vertes sur l'herbe, saturées ou blanches, pas les cailloux bruns ni gris
    sat = a.max(2) - a.min(2)
    greenish = (g > r + 12) & (g > b + 30)                                     # bords du chemin, touffes : vert-jaune
    petal = fl & ~grass_rule(a) & ~greenish & ~path2 & ~stm & (lum > 95) & ((sat > 60) | (mn > 205))
    brown = (r > g) & (g > b) & (r < 215) & (r - b > 30) & (r - b < 140)
    petal &= ~brown
    if falls_x is not None:                                                       # RAF3 : éclats de cristal menthe, pas des fleurs
        petal &= ~((g > r + 20) & (np.abs(b - g) < 25) & (mn > 150))
    pl, pn = nd.label(petal); ps = nd.sum(petal, pl, range(1, pn + 1))
    petal = np.isin(pl, [i + 1 for i, v in enumerate(ps) if 6 <= v <= 900])
    return dict(void=void, casc=casc, foam=foam, water=water, floor=fl, veg=veg, walls=walls, stairs=stm, petal=petal), falls


# ---------------------------------------------------------------- arbres de la planche
def raw_tree_sprites():
    """Arbres PMD peints par le générateur DANS les bruts de décor (RAF1 et RAF2) : composantes de feuillage entières (hors
    bords, 5000-12500 px, remplissage > 0,55, hauteur/largeur 0,9-1,3) + tronc brun sous le feuillage ; réduits à l'échelle de
    la scène, puis miroirs. Les planches d'arbres générées à part ont été rejetées (couleurs hors Apple Woods)."""
    out = []
    for m in ('raf1', 'raf2'):
        a = rgb(paths(m)['raw'] / CFG[m]['decor'])
        r, g, b = a.transpose(2, 0, 1)
        leaf = (g > r + 25) & (g > b + 30) & ~grass_rule(a)
        lab, n = nd.label(morph(nd.binary_closing, tree_rule(a), 2))
        for i, sl in enumerate(nd.find_objects(lab)):
            comp = lab[sl] == i + 1; sz = int(comp.sum()); h, w = comp.shape
            if not (5000 < sz < 12500 and sz / (h * w) > 0.55 and 0.9 <= h / w <= 1.3):
                continue
            if sl[0].start == 0 or sl[1].start == 0 or sl[1].stop >= a.shape[1] or sl[0].stop >= a.shape[0]:
                continue
            y0, y1, x0, x1 = sl[0].start, min(a.shape[0], sl[0].stop + int(0.3 * h)), sl[1].start, sl[1].stop
            sub = a[y0:y1, x0:x1]; cz = np.zeros(sub.shape[:2], bool); cz[:h] = comp
            canopy = nd.binary_fill_holes(cz | (leaf[y0:y1, x0:x1] & morph(nd.binary_dilation, cz, 2)))
            sr, sg, sb = sub.transpose(2, 0, 1)
            brown = (sr > sg) & (sg > sb) & (sr - sb > 30) & ((sub @ [.299, .587, .114]) < 150)
            lab2, _ = nd.label(brown | canopy); keep = set(np.unique(lab2[canopy])) - {0}
            msk = nd.binary_fill_holes(np.isin(lab2, list(keep)))
            rows = np.nonzero(msk.any(1))[0]; msk = msk[:rows.max() + 1]; sub = sub[:rows.max() + 1]
            rgba = np.zeros(msk.shape + (4,), 'uint8'); rgba[..., :3] = sub; rgba[..., 3] = msk * 255
            hh, ww = msk.shape; nw, nh = max(1, round(ww * S)), max(1, round(hh * S))
            pre = rgba.astype(float); pre[..., :3] *= pre[..., 3:] / 255
            small = np.array(Image.fromarray(pre.astype('uint8')).resize((nw, nh), Image.BOX)).astype(float)
            al = small[..., 3]; mm = al > 140
            col = np.zeros((nh, nw, 4), 'uint8')
            col[mm, :3] = np.clip(small[mm, :3] / (al[mm, None] / 255), 0, 255); col[mm, 3] = 255
            src = {'brut': m, 'boite_y0x0y1x1': [int(y0), int(x0), int(y0 + hh), int(x1)]}
            out.append({'rgba': col, 'source': dict(src, miroir=False)})
            out.append({'rgba': col[:, ::-1].copy(), 'source': dict(src, miroir=True)})
    return out


def plant_trees(zone, forbid, sprites, seed, grass_tone, edge):
    """Plante des arbres de la planche dans `zone` (768), base du tronc sur des points tirés en quinconce, jamais sur `forbid`."""
    rng = np.random.default_rng(seed)
    layer = np.zeros((H, W, 4), 'uint8'); trunks = np.zeros((H, W), bool); placed = []
    pts = []
    for y in range(8, H + 40, 22):
        for x in range(-10, W + 20, 26):
            xx, yy = x + (13 if (y // 22) % 2 else 0) + int(rng.integers(-5, 6)), y + int(rng.integers(-4, 5))
            if 0 <= yy < H and 0 <= xx < W and zone[yy, xx]:
                pts.append((yy, xx))
    pts.sort()
    shade = tuple(int(v * 0.72) for v in grass_tone)
    for yy, xx in pts:
        k = int(rng.integers(len(sprites))); sp = sprites[k]['rgba']; h, w = sp.shape[:2]
        y0, x0 = yy - h + 1, xx - w // 2
        m = sp[..., 3] == 255
        ys, xs = np.nonzero(m); Y, X = ys + y0, xs + x0; ok = (Y >= 0) & (Y < H) & (X >= 0) & (X < W)
        if forbid[Y[ok], X[ok]].any():
            continue
        cov = zone[Y[ok], X[ok]].mean() if ok.any() else 0
        if cov < 0.35 and not edge[yy, xx]:                                       # bandes de bord : le pied suffit
            continue
        # ombre douce sous le tronc (tramée), sous l'arbre
        ey, ex = np.mgrid[-4:5, -(w // 3):(w // 3) + 1]
        em = (ex / max(1, w / 3)) ** 2 + (ey / 4.5) ** 2 <= 1
        for dy, dx in zip(ey[em], ex[em]):
            Yy, Xx = yy + dy, xx + dx
            if 0 <= Yy < H and 0 <= Xx < W and layer[Yy, Xx, 3] == 0 and not forbid[Yy, Xx] and (Yy + Xx) % 2 == 0:
                layer[Yy, Xx, :3] = shade; layer[Yy, Xx, 3] = 255
        layer[Y[ok], X[ok]] = sp[ys[ok], xs[ok]]
        tb = (ys >= h - max(6, h // 5)) & (np.abs(xs - w // 2) <= max(3, w // 7))    # pied du tronc : bloquant
        trunks[Y[ok & tb], X[ok & tb]] = True
        placed.append({'y': int(yy), 'x': int(xx), 'arbre': k, 'taille': [int(w), int(h)]})
    return layer, trunks, placed


# ---------------------------------------------------------------- lois animées
def flower_heads(fl):
    a = fl[..., :3].astype(int); sat = a.max(2) - a.min(2)
    greenish = (a[..., 1] > a[..., 0] + 12) & (a[..., 1] > a[..., 2] + 30)
    m = (fl[..., 3] == 255) & ~grass_rule(a) & ~greenish & ((sat > 60) | (a.min(2) > 205)) & ((a @ [.299, .587, .114]) > 95)
    seeds, n = nd.label(morph(nd.binary_erosion, m, 1) | (m & (nd.uniform_filter(m.astype(float), 3) > 0.99)))
    if n == 0:
        seeds, n = nd.label(m)
    _, (iy, ix) = nd.distance_transform_edt(seeds == 0, return_indices=True)
    lab = np.where(m, seeds[iy, ix], 0)
    return lab, n


def flower_frames(fl, lab, n):
    """Loi du GIF Sky Peak : A B A C ; en B et C chaque tête descend de 1 px et penche de ±1 px (sens propre à la tête)."""
    head = lab > 0; leaf = (fl[..., 3] == 255) & ~head
    d, (iy, ix) = nd.distance_transform_edt(~leaf, return_indices=True)
    base = fl.copy(); fillable = head & (d <= 3)
    base[head] = 0; base[fillable] = fl[iy[fillable], ix[fillable]]
    sign = np.array([0] + [1 if hsh(i, 7) % 2 else -1 for i in range(1, n + 1)])
    ys, xs = np.nonzero(head); ids = lab[ys, xs]; order = np.argsort(ys, kind='stable')
    ys, xs, ids = ys[order], xs[order], ids[order]

    def shifted(k):
        f = base.copy(); dx = sign[ids] * k
        ty, tx = np.clip(ys + 1, 0, H - 1), np.clip(xs + dx, 0, W - 1)
        f[ty, tx] = fl[ys, xs]
        return f
    A = fl.copy(); B = shifted(1); Cc = shifted(-1)
    return [A, B, A.copy(), Cc]


def depth_map(abyss, void):
    lum = abyss[..., :3].astype(float) @ [.299, .587, .114]
    dark = nd.gaussian_filter(np.where(void, 255 - lum, 0), 6) / np.maximum(nd.gaussian_filter(void.astype(float), 6), 1e-3)
    v = dark[void]; lo, hi = np.percentile(v, 5), np.percentile(v, 95)
    dep = np.clip((dark - lo) / max(1.0, hi - lo), 0, 1)
    rim = nd.distance_transform_edt(void)
    return np.where(void, dep * np.clip(rim / 10, 0, 1), 0)


def periodic_noise(period, phase_seed, yy, xx, ky):
    rng = np.random.default_rng(phase_seed); n = np.zeros(yy.shape)
    for k, amp in ((1, 0.55), (2, 0.3), (3, 0.18)):
        p = rng.uniform(0, 2 * np.pi, 2)
        n += amp * np.sin(2 * np.pi * k * xx / period + yy / ky[k - 1] + p[0]) * (0.7 + 0.3 * np.sin(yy / (ky[k - 1] * 2.3) + p[1]))
    return n


def mist_frames(void, dep, phases, step, period, tones, gain, bias, seed, ky, minimum):
    yy, xx = np.mgrid[:H, :W].astype(float)
    frames = []; bay = BAYER4[(yy.astype(int) % 4), (xx.astype(int) % 4)]
    for t in range(phases):
        n = periodic_noise(period, seed, yy, xx - step * t, ky)                    # translation exacte : raccord à t = phases
        dens = np.clip(gain * n + bias + 0.8 * dep, 0, 1) * (dep > minimum)
        on = void & (dens > bay) & (dens > 0.18)
        lev = np.clip((dens * len(tones)).astype(int), 0, len(tones) - 1)
        e = np.zeros((H, W, 4), 'uint8')
        e[on, :3] = np.array(tones, 'uint8')[lev[on]]; e[on, 3] = 255
        frames.append(e)
    return frames


def glint_frames(void, dep, seed, n_glints=34):
    rng = np.random.default_rng(seed); glints = []
    cand = np.argwhere(void & (dep > 0.7)); rng.shuffle(cand)
    for y, x in cand:
        if len(glints) >= n_glints:
            break
        if all(max(abs(x - g['xy'][0]), abs(y - g['xy'][1])) > 12 for g in glints):
            glints.append({'xy': [int(x), int(y)], 'teinte': list(GLINT_TINTS[len(glints) % 4]), 'phase': int(rng.integers(0, GLINT_PHASES))})
    frames = []
    for t in range(GLINT_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for g in glints:
            L = GLINT_SEQ[(t - g['phase']) % GLINT_PHASES]
            if not L:
                continue
            x, y = g['xy']; c = g['teinte']
            for dd in range(1, L):
                for dx, dy in ((dd, 0), (-dd, 0), (0, dd), (0, -dd)):
                    if 0 <= x + dx < W and 0 <= y + dy < H and void[y + dy, x + dx]:
                        e[y + dy, x + dx] = (*c, 255)
            e[y, x] = (255, 255, 255, 255) if L >= 2 else (*c, 255)
        frames.append(e)
    return frames, glints


# ---------------------------------------------------------------- calcul
def make_all(m):
    c = CFG[m]
    a, void_full, dec, gf = composite(m)
    mk, falls = classify(a, void_full, c['stairs'], c.get('chutes_x'), c.get('dalles'))
    order = ['void', 'casc', 'foam', 'water', 'floor', 'veg', 'walls']
    ex, cols = JM.down_class(a, {k: mk[k] for k in order}, order)
    full = JM.down_full(a)
    sc = lambda k: JM.resize_plane(k.astype(np.float32)) > 0.5
    stairs = sc(mk['stairs']) & ex['floor']
    petal = sc(morph(nd.binary_dilation, mk['petal'], 1)) & ex['floor']
    # miettes de sol isolées -> végétation
    lab, n = nd.label(ex['floor']); s = nd.sum(ex['floor'], lab, range(1, n + 1))
    speck = ex['floor'] & np.isin(lab, [i + 1 for i, v in enumerate(s) if v < 400])
    ex['floor'] &= ~speck; ex['veg'] |= speck; cols['veg'][speck] = full[speck]
    # cascades
    rects = []
    for i, fa in enumerate(falls):
        x0 = int(round(fa['x0'] * S)) - JM.CROP_X; x1 = int(round(fa['x1'] * S)) - JM.CROP_X
        rects.append({'x0': x0, 'x1': x1, 'y0': int(round(fa['y0'] * S)), 'y1': int(round(fa['y_ecume'] * S)) + 4, 'graine': 11 + i})
    casc = np.zeros((H, W), bool)
    for r_ in rects:
        casc[r_['y0']:r_['y1'], r_['x0']:r_['x1']] = True
    foam = ex['foam'] & ~casc
    wet = (ex['water'] | foam | (ex['casc'] & ~casc)) & ~ex['void']
    wl = JM.rgba(cols['water'], ex['water'])
    idx = nd.distance_transform_edt(~ex['water'], return_distances=False, return_indices=True)
    base = wl.copy(); fill = wet & ~ex['water']
    base[fill] = wl[idx[0][fill], idx[1][fill]]; base[..., 3] = np.where(wet, 255, 0)
    # sol complet : herbe du sol (fleurs retirées), propagée partout hors du vide
    grass = ex['floor'] & ~petal & ~stairs & grass_rule(full)
    gi = nd.distance_transform_edt(~grass, return_distances=False, return_indices=True)
    solc = full[gi[0], gi[1]]
    def q_(e, nc):                                                                # quantification propre à chaque calque
        m_ = e[..., 3] == 255
        qq = Image.fromarray(e[..., :3]).quantize(colors=nc, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        e[..., :3] = np.array(qq.convert('RGB')); e[~m_] = 0
        return e
    # HQ : sol quantifié seul sur 128 couleurs (la palette commune dominée par l'herbe écrasait les buissons ronds en olive)
    layers = {'sol_complet': q_(JM.rgba(solc, ~ex['void']), 64), 'sol': q_(JM.rgba(cols['floor'], ex['floor']), 128)}
    # fleurs : taches de pétales + 1 px autour, retirées du sol (le sol montre l'herbe voisine dessous)
    fmask = morph(nd.binary_dilation, petal, 1) & ex['floor'] & ~stairs
    fl = np.zeros((H, W, 4), 'uint8'); fl[fmask, :3] = full[fmask]; fl[fmask, 3] = 255
    sol = layers['sol']; g_under = solc
    sol[fmask, :3] = g_under[fmask]
    layers['sol'] = sol
    abyss = np.zeros((H, W, 4), 'uint8'); abyss[ex['void'], :3] = full[ex['void']]; abyss[ex['void'], 3] = 255
    for nm, e, nc in (('abime', abyss, 64), ('falaises', JM.rgba(cols['walls'], ex['walls'] & ~casc), 96),
                      ('buissons', JM.rgba(cols['veg'], ex['veg'] & ~casc), 96), ('eau_fixe', base, 16), ('fleurs', fl, 48)):
        m_ = e[..., 3] == 255
        q = Image.fromarray(e[..., :3]).quantize(colors=nc, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        e[..., :3] = np.array(q.convert('RGB')); e[~m_] = 0; layers[nm] = e
    # arbres : lisière plantée sur les masses de buissons et le long des bords ouverts (hors couloirs d'entrée et de sortie)
    walk0 = ex['floor']
    lab, n = nd.label(ex['veg']); s = nd.sum(ex['veg'], lab, range(1, n + 1))
    masses = np.isin(lab, [i + 1 for i, v in enumerate(s) if v >= 1500])
    yy, xx = np.mgrid[:H, :W]
    ent_x, (sx, sy) = c['entree_x'], c['sortie']              # (x, y)
    band = walk0 & ((xx < 40) | (xx > W - 40) | ((yy > H - 34) & (np.abs(xx - ent_x) > 64)) | ((yy < 30) & (np.abs(xx - sx) > 44)))
    zone = masses | band
    forbid = ex['void'] | casc | wet | foam | stairs | ((np.abs(xx - ent_x) < 56) & (yy > H - 90)) | ((np.abs(xx - sx) < 36) & (yy < 60))
    forbid |= morph(nd.binary_dilation, casc | wet, 2)
    sprites = raw_tree_sprites()
    tl, trunks, placed = plant_trees(zone, forbid, sprites, c['graine'], np.array(GRASS), band)
    # arbres du brut (composantes moyennes de végétation avec tronc) -> calque arbres aussi
    single = np.isin(lab, [i + 1 for i, v in enumerate(s) if 350 <= v < 1500])
    trees_raw = single & ~masses
    tl2 = np.zeros((H, W, 4), 'uint8'); tl2[trees_raw] = layers['buissons'][trees_raw]
    layers['buissons'][trees_raw] = 0
    comp = tl2.copy(); mt = tl[..., 3] == 255; comp[mt] = tl[mt]
    layers['arbres'] = comp
    # animations
    dep = depth_map(abyss, ex['void'])
    # dégradé de profondeur : plus on descend, plus le gouffre généré tire vers le bleu nuit (perspective atmosphérique)
    k = (DEPTH_GRADE * dep ** 1.2)[..., None]
    g_ = abyss[..., :3].astype(float) * (1 - k) + np.array(DEPTH_NIGHT, float) * k
    q = Image.fromarray(np.clip(g_, 0, 255).astype('uint8')).quantize(colors=64, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    abyss[..., :3] = np.array(q.convert('RGB')); abyss[~ex['void']] = 0; layers['abime'] = abyss
    deep = mist_frames(ex['void'], dep, DEEP_PHASES, DEEP_STEP, 96, DEEP_TONES, 0.55, -0.32, 21, (31, 17, 11), 0.22)
    high = mist_frames(ex['void'], dep, HIGH_PHASES, HIGH_STEP, 192, HIGH_TONES, 0.62, -0.58, 33, (46, 31, 23), 0.08)
    gfr, glints = glint_frames(ex['void'], dep, 7)
    lab2, n2 = flower_heads(layers['fleurs'])
    ffr = flower_frames(layers['fleurs'], lab2, n2)
    lab3, n3 = nd.label(foam); sources = []
    for i in range(1, n3 + 1):
        ys, xs = np.nonzero(lab3 == i)
        if len(ys) < 30:
            continue
        sources.append({'centre': [round(float(xs.mean()), 1), round(float(ys.mean()), 1)],
                        'demi_axes': [round((xs.max() - xs.min()) / 2 + 2, 1), round((ys.max() - ys.min()) / 2 + 2, 1)]})
    rf = C.ripple_frames(layers['eau_fixe'], wet, foam, sources)
    cf = C.cascade_frames(H, W, rects)
    puffs = C.foam_puffs(foam, 5)
    ff = C.foam_frames(H, W, foam, puffs)
    for fr_ in ff:
        fr_[~nd.binary_dilation(wet | casc, iterations=1)] = 0
    return dict(a=a, dec=dec, gf=gf, void_full=void_full, mk=mk, falls=falls, ex=ex, layers=layers, rects=rects, casc=casc,
                wet=wet, foam=foam, stairs=stairs, petal=petal, fmask=fmask, zone=zone, masses=masses, band=band, trunks=trunks,
                placed=placed, sprites=sprites, trees_raw=trees_raw, dep=dep, deep=deep, high=high, gfr=gfr, glints=glints,
                ffr=ffr, n_fleurs=n2, rf=rf, cf=cf, ff=ff, sources=sources, puffs=puffs)


APPLE_CANOPY = [(245, 135, 275, 165), (305, 35, 335, 65), (250, 390, 280, 420), (315, 485, 345, 515)]   # y0, x0, y1, x1 : coeurs de 4 feuillages


def fidelity(D):
    sky = rgb(REFD / 'skypeak_gif_f0.png')[120:]                                    # sous le ciel et la mer de nuages
    apple = rgb(REFD / 'Apple_Woods_entrance_TDS.png')
    L = D['layers']; out = {}
    for nm, lay, rule in (('herbe', 'sol', grass_rule), ('falaises', 'falaises', rock_rule)):
        e = L[lay]; m = (e[..., 3] == 255) & rule(e[..., :3].astype(int)); mr = rule(sky)
        r_, o_ = sky[mr].mean(0), e[m][:, :3].astype(float).mean(0)
        out[nm] = {'ref': 'skypeak_gif_f0 (y >= 120)', 'ref_rgb': [round(float(v), 1) for v in r_],
                   'rgb': [round(float(v), 1) for v in o_], 'pixels_ref': int(mr.sum()), 'pixels': int(m.sum()),
                   'distance': round(float(np.linalg.norm(r_ - o_)), 2)}
    ref = np.concatenate([apple[y0:y1, x0:x1].reshape(-1, 3) for y0, x0, y1, x1 in APPLE_CANOPY]).mean(0)
    t = np.concatenate([sp['rgba'][sp['rgba'][..., 3] == 255][:, :3] for sp in D['sprites']]).astype(float)
    leaf = (t[:, 1] > t[:, 0] + 25) & (t[:, 1] > t[:, 2] + 30)
    out['arbres'] = {'ref': 'Apple_Woods_entrance_TDS, coeurs de 4 feuillages (boites 30 x 30 verifiees a l oeil)',
                     'boites_ref_y0x0y1x1': APPLE_CANOPY, 'ref_rgb': [round(float(v), 1) for v in ref],
                     'rgb': [round(float(v), 1) for v in t[leaf].mean(0)], 'pixels': int(leaf.sum()),
                     'distance': round(float(np.linalg.norm(ref - t[leaf].mean(0))), 2)}
    out['regles'] = {'herbe': 'G > 185, G - R > 40, G - B > 70', 'falaises': 'gris-bleu peu sature (B >= G - 6, G >= R - 4, ecart < 75, min > 40)',
                     'arbres': 'feuillage des modeles (G > R + 25, G > B + 30) contre les coeurs de feuillage d Apple Woods'}
    out['seuil'] = FIDELITY_MAX
    out['seuille'] = ['herbe', 'arbres']
    out['signale'] = {'falaises': 'matiere secondaire, signalee et non seuillee (precedent RAZ3) : le generateur les a faites plus sombres que Sky Peak'}
    return out


def ground_project(m, stack, blocked, markers, gfx, tools):
    c = CFG[m]; P = paths(m)
    vals = dict(STAGE=P['stage'], PFX=c['PFX'], ASSET=c['ASSET'], NAMESPACE=c['NAMESPACE'], HERE=P['lot'], W=W, H=H)
    for k, v in vals.items():
        setattr(FV, k, v)
    counts = FV.ground_project(stack, blocked, {'entrance': markers['entrance'], 'boss': markers['sortie'],
                                                'source': markers['belvedere']}, gfx, tools)
    doc_p = P['stage'] / f"Data/Ground/{c['ASSET']}.rsground"
    doc = json.loads(doc_p.read_text()); o = doc['Object']
    o['Name'] = {'DefaultText': c['titre'], 'LocalTexts': {}}
    o['Comment'] = ('PMDO 0.8.12. Route generee 4:3 (ref. Sky Peak + Apple Woods, cascades a la loi de P03P01A) : herbe et falaises '
                    'de Sky Peak, fleurs multicolores animees (A B A C), arbres PMD, gouffre genere avec degrade de profondeur et brume en parallaxe. '
                    'Arrivee au sud, sortie au nord. Aucun warp.')
    for mk in o['Entities'][0]['Markers']:
        mk['EntName'] = {'boss': 'sortie', 'source': 'belvedere'}.get(mk['EntName'], mk['EntName'])
    gfx.save(doc_p, json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode())
    x = (P['stage'] / 'Mod.xml').read_text()
    assert 'Fin Vapeur (sommet de Steam Cave) 4:3' in x and 'events de vapeur animes' in x
    x = x.replace('Fin Vapeur (sommet de Steam Cave) 4:3', c['titre'])
    x = x.replace("fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes",
                  "route generee au format 4:3 (ref. Sky Peak), fleurs, arbres PMD, cascades, gouffre profond")
    (P['stage'] / 'Mod.xml').write_text(x)
    return counts


def reach_map(blocked, start):
    gh, gw = blocked.shape
    ok = ~(blocked[:-1, :-1] | blocked[1:, :-1] | blocked[:-1, 1:] | blocked[1:, 1:])
    seen = np.zeros_like(ok); st = [start]
    while st:
        y, x = st.pop()
        if not (0 <= y < gh - 1 and 0 <= x < gw - 1) or seen[y, x] or not ok[y, x]:
            continue
        seen[y, x] = True; st += [(y + 1, x), (y - 1, x), (y, x + 1), (y, x - 1)]
    return seen


def nearest_reach(reach, target):
    ys, xs = np.nonzero(reach); tx, ty = target
    i = int(np.argmin((xs * 8 - tx) ** 2 + (ys * 8 - ty) ** 2))
    return [int(xs[i] * 8), int(ys[i] * 8)]


def build(m):
    c = CFG[m]; P = paths(m); PFX = c['PFX']; OUT = P['out']
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    for d in ['calques', 'animation', 'masques', 'review']:
        shutil.rmtree(OUT / d, ignore_errors=True)
    anims = ['brume_profonde', 'brume_haute', 'lueurs', 'eau', 'herbes', 'fleurs', 'cascades', 'ecume', 'embruns', 'papillons']
    if c.get('cristaux'):
        anims.append('reflets')
    for d in ['calques', 'masques', 'review'] + [f'animation/{k}' for k in anims]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(m); L, ex = D['layers'], D['ex']
    D = HQ.apply(D, grass_rule, c['graine'] * 10 + 1, c.get('massifs_falaise', ()), c.get('aplat_max', 40), c.get('cristaux', False))   # passe haute qualité
    masks = dict(sol=ex['floor'], vide=ex['void'], falaises=ex['walls'], vegetation=ex['veg'], eau=D['wet'], cascades=D['casc'],
                 escaliers=D['stairs'], fleurs=D['fmask'], lisiere=D['zone'], troncs=D['trunks'], arbres_brut=D['trees_raw'])
    for k, v in masks.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    Image.fromarray((D['dep'] * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_profondeur.png')
    stack_named = [('sol_complet', [L['sol_complet']], 60), ('abime', [L['abime']], 60),
                   ('brume_profonde', D['deep'], DEEP_TICKS), ('brume_haute', D['high'], HIGH_TICKS), ('lueurs', D['gfr'], GLINT_TICKS),
                   ('eau', D['rf'], C.RIPPLE_TICKS), ('sol', [L['sol']], 60), ('falaises', [L['falaises']], 60)] + (
                  [('cristaux', [D['cristaux']], 60), ('reflets', D['reflets'], HQ.REFLETS_TICKS)] if D['cristaux'] is not None else []) + [
                   ('herbes', D['herbes'], HQ.HERBES_TICKS), ('fleurs', D['ffr'], FLOWER_TICKS), ('buissons', [L['buissons']], 60),
                   ('arbres', [L['arbres']], 60), ('cascades', D['cf'], C.CASC_TICKS), ('ecume', D['ff'], C.FOAM_TICKS),
                   ('embruns', D['embruns'], HQ.EMBRUNS_TICKS), ('papillons', D['papillons'], HQ.PAPILLONS_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    # praticable : sol, hors lisière, végétation, troncs
    walk_px = ex['floor'] & ~D['zone'] & ~ex['veg'] & ~D['trunks'] & ~(L['arbres'][..., 3] == 255) | D['stairs']
    walk_px &= ~D['zone']
    Image.fromarray((walk_px * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    blocked = BM.cell_grid(~walk_px)
    gh_, gw_ = blocked.shape
    col_bottom = [cc for cc in range(gw_ - 1) if not blocked[gh_ - 2:, cc:cc + 2].any()]
    ex_ = min(col_bottom, key=lambda cc: abs(cc * 8 + 8 - c['entree_x'])); entrance = [ex_ * 8, H - 16]
    reach = reach_map(blocked, (entrance[1] // 8, entrance[0] // 8))
    sortie = nearest_reach(reach, c['sortie'])
    belv = nearest_reach(reach, c['belvedere'])
    markers = {'entrance': entrance, 'sortie': sortie, 'belvedere': belv}
    pths = {}
    for k in ('sortie', 'belvedere'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        pths[k] = {'ok': ok, 'cases_explorees': explored}

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for title, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ANIM[title]) % len(frames)] if title in ANIM else frames[0]))
        return im
    scenes = [scene(t * 10) for t in range(LOOP_TICKS // 10)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    fid = fidelity(D)
    assert all(fid[k]['distance'] < FIDELITY_MAX for k in fid['seuille']), fid
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(10 * 1000 / 60), loop=0, quality=90, method=4)
    colim = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, cl in (('entrance', (255, 230, 40, 255)), ('sortie', (60, 220, 255, 255)), ('belvedere', (255, 80, 200, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=cl, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    # profondeur : zoom x2 sur le gouffre, 4 instants
    ys, xs = np.nonzero(ex['void']); cy, cx = int(np.median(ys)), int(np.median(xs))
    x0, y0 = int(np.clip(cx - 96, 0, W - 192)), int(np.clip(cy - 72, 0, H - 144))
    z = Image.new('RGB', (4 * 384, 288))
    for j, t in enumerate((0, 120, 240, 360)):
        z.paste(scene(t).crop((x0, y0, x0 + 192, y0 + 144)).convert('RGB').resize((384, 288), Image.NEAREST), (j * 384, 0))
    z.save(OUT / 'review' / f'{PFX}_zoom_gouffre.png')
    BM.write_ora(OUT / f'{PFX}_route_fleurie_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project(m, [(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                                for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    raw_inputs = []
    for fn in c['chaine'] + [c['gouffre']]:
        p = P['raw'] / fn
        with Image.open(p) as im:
            size = list(im.size)
        raw_inputs.append({'file': str(p.relative_to(R)), 'sha256': sha(p), 'size': size})
    base_raw = R / c.get('base_raw', f"source/zone_zero_v1/{c['base']}/bruts/decor_magenta.png")
    manifest = {
        'lot': c['PFX'], 'serie': 'Reseau Zone Zero V2 (routes fleuries)', 'remplace_pas': f"{c['base'].upper()} (gardee)",
        'demande': c.get('demande', ('pour les zone area faut la texture sky peak et les fleur de differente couleur et les arbre pmd et les cascade '
                    'garde les doit avoir leurs propre calque les trou faut que genere vraiment cette effet de profondeur etc')),
        'lecture_agent': c.get('lecture', 'zones Area Zero = routes RAZ1 et RAZ2 (cascades et trous d abime) ; RAZ3 et EAZ1 (cristal) non touchees'),
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'references': {
            'sky_peak': {'fichier': 'source/zone_zero_v2/reference/skypeak_gif_f0.png', 'sha256': sha(REFD / 'skypeak_gif_f0.png'),
                         'source': '2cwdrrs469f61.gif (racine), frame 0'},
            'apple_woods': {'fichier': 'source/zone_zero_v2/reference/Apple_Woods_entrance_TDS.png',
                            'sha256': sha(REFD / 'Apple_Woods_entrance_TDS.png'), 'source': 'Apple_Woods_entrance_TDS.png (racine)'},
            'decoupes': ['source/zone_zero_v2/reference/skypeak_decoupe_x2.png', 'source/zone_zero_v2/reference/applewoods_arbres_decoupe_x2.png'],
            'brut_v1': {'fichier': str(base_raw.relative_to(R)), 'sha256': sha(base_raw)},
            'cascades': 'loi de P03P01A (source/zone_zero_v1/commun.py)'},
        'raw_inputs': raw_inputs,
        'arbres_source': {'modeles': [t['source'] for t in D['sprites']], 'echelle': S,
                          'regle': 'feuillage entier des bruts de decor (5000-12500 px, remplissage > 0,55, h/l 0,9-1,3, hors bords) + tronc brun',
                          'planches_rejetees': [
                              {'nom': 'arbres_magenta v0', 'feuillage_rgb': [30, 101, 10], 'distance_apple_woods': 56,
                               'motif': 'vert emeraude trop sature'},
                              {'nom': 'arbres_magenta v1', 'feuillage_rgb': [81, 80, 31], 'distance_apple_woods': 51,
                               'motif': 'kaki, trop jaune et sombre'}]},
        'methode': ('decor = brut V1 repeint (images : brut V1, decoupe Sky Peak x2, decoupe arbres Apple Woods x2), abime en magenta ; '
                    'gouffre = edition du decor, pixels pris SEULEMENT dans le masque magenta du decor (le reste de l edition, qui '
                    'mangeait la prairie et le chemin, est jete) ; arbres = feuillages entiers decoupes dans les bruts de decor (pas de planche '
                    'generee : les deux essais ont ete rejetes), plantes en lisiere et sur les massifs'),
        'edition_b': c['edition_b'],
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'profondeur': {'carte': 'assombrissement lisse (gaussienne 6) du gouffre genere, normalise p5-p95, nul au bord (10 px)',
                       'brume_profonde': {'phases': DEEP_PHASES, 'frame_length_ticks': DEEP_TICKS, 'pas_px': DEEP_STEP, 'periode_px': 96,
                                          'tons': DEEP_TONES, 'loi': 'bruit periodique (96 px) translate de +4 px par phase ; densite = bruit + profondeur ; trame de Bayer 4 x 4 ; seulement profondeur > 0,35'},
                       'brume_haute': {'phases': HIGH_PHASES, 'frame_length_ticks': HIGH_TICKS, 'pas_px': HIGH_STEP, 'periode_px': 192,
                                       'tons': HIGH_TONES, 'loi': 'voiles clairs, bruit periodique (192 px) translate de -8 px par phase (sens oppose, 4 fois plus vite : parallaxe)'},
                       'lueurs': {'phases': GLINT_PHASES, 'frame_length_ticks': GLINT_TICKS, 'nombre': len(D['glints']),
                                  'loi': 'eclats 1-2-3-2-1 puis repos, seulement profondeur > 0,7'}},
        'fleurs': {'phases': FLOWER_PHASES, 'frame_length_ticks': FLOWER_TICKS, 'tetes': D['n_fleurs'], 'couleurs': D['hq']['couleurs'],
                   'dessin': 'fleurs nettes de 7 px calculees (petale, 4 encoches, bord sombre, reflet en damier, coeur) + ombre verte ; massifs du rendu redessines dans leur couleur, massifs en plus de toutes les couleurs',
                   'palettes': {k: [list(t) for t in v] for k, v in HQ.PALETTES.items()},
                   'loi': 'A B A C (GIF Sky Peak) : en B et C chaque fleur descend de 1 px et penche de +-1 px'},
        'haute_qualite': {'demande': 'faut que les zone route area zero soit magnifique avec la verdure sky peak hight qualite les fleur avec plein de couleur des cascade de la brume etc',
                          'stats': {k: v for k, v in D['hq'].items() if k not in ('papillons', 'trajets')},
                          'herbe': {'ton': list(HQ.SKY_GRASS),
                                    'regle': 'pixels d herbe (regle herbe) a moins de 40 du ton dominant du lot -> aplat au ton dominant du GIF Sky Peak ; restes flous <= 60 px entoures d herbe -> aplat ; le chemin clair reste'},
                          'herbes': {'phases': HQ.HERBES_PHASES, 'frame_length_ticks': HQ.HERBES_TICKS, 'touffes': D['hq']['touffes'],
                                     'tons': [list(t) for t in HQ.TUFT_TONES],
                                     'loi': 'etoiles de 6 brins de 5 px, grille de 26 px en quinconce ; A B A C, brins du haut penches de +-1 px en B et C (GIF Sky Peak : toute la prairie se balance)'},
                          'embruns': {'phases': HQ.EMBRUNS_PHASES, 'frame_length_ticks': HQ.EMBRUNS_TICKS, 'gouttelettes': D['hq']['gouttelettes'],
                                      'loi': 'au pied de chaque cascade, chaque gouttelette part du bord haut de l ecume et monte de 34 px sur la boucle, derive en sinus et s efface (trame de Bayer)'},
                          'papillons': {'phases': HQ.PAPILLONS_PHASES, 'frame_length_ticks': HQ.PAPILLONS_TICKS, 'liste': D['hq']['papillons'],
                                        'trajets': D['hq']['trajets'],
                                        'loi': 'Lissajous fermee x = cx + ax sin(2 pi t / 48 + phi), y = cy + ay sin(4 pi t / 48 + psi) ; ailes ouvertes / fermees une phase sur deux'},
                          'nature': 'pixels calcules (pas des tuiles natives) ; seuls les tons de l herbe, des touffes et des fleurs corail sont releves sur le GIF Sky Peak'},
        'arbres': {'plantes': D['placed'], 'du_brut_pixels': int(D['trees_raw'].sum()),
                   'lisiere': 'masses de buissons du brut (>= 1500 px) + bandes de 40 px aux bords gauche et droit, 34 px au bas (hors couloir d entree), 30 px en haut (hors sortie)'},
        'cascades': {'phases': C.CASC_PHASES, 'frame_length_ticks': C.CASC_TICKS, 'rects': D['rects'], 'loi': 'P03P01A : motif 96 px, 32 px par image'},
        'animations': {k: {'phases': PHASES[k], 'frame_length_ticks': ANIM[k], 'boucle_ticks': PHASES[k] * ANIM[k]} for k in ANIM
                       if k in [t for t, _, _ in stack_named]},
        'cristaux': None if D['cristaux'] is None else dict(D['cristaux_stats'], phases=HQ.REFLETS_PHASES, frame_length_ticks=HQ.REFLETS_TICKS,
            demande='je veux que les cristal et des reflet et que ce soit comme area zero blanc de base a reflet arc en ciel qui change de couleur rouge mauve etc',
            loi=('cristaux (regle : vert menthe pale, g - r > 45, g - b < 50, lum > 125, + reflets blancs ; composantes gardees si >= 5 % de facettes tres claires, lum > 205, pour laisser les reflets de roche) sortis du calque falaises, bases menthe des piliers du calque sol rattachees ; '
                 'base blanche en 5 tons selon la luminance d origine (les facettes restent) + contour indigo ; reflets : bande diagonale '
                 'de 34 px (periode 96 px, +4 px par phase) aux 8 teintes de l arc-en-ciel posees sur le blanc, teinte = ((x + y) / 8 + t / 3) mod 8 '
                 '(la couleur tourne : rouge, orange, jaune, vert, cyan, bleu, mauve, rose) ; 36 eclats 1-2-3-2-1'),
            nature='pixels calcules (recoloration des cristaux du brut genere), pas des tuiles natives'),
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': pths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol praticable (masque praticable = sol, fleurs et massifs compris, + escaliers ; '
                            'lisiere, vegetation, troncs et arbres exclus)'},
        'pmdo': {'target': '0.8.12', 'asset': c['ASSET'], 'namespace': c['NAMESPACE'], 'tiles_per_bank': counts, 'banks': sorted(counts),
                 'runtime_tested': False, 'warp': 'aucun (raccords a scripter)'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, indent=1, ensure_ascii=False))
    print(json.dumps({'fidelite': {k: fid[k]['distance'] for k in fid['seuille']}, 'markers': markers, 'arbres': len(D['placed']),
                      'fleurs': D['n_fleurs'], 'cascades': len(D['rects']), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build(sys.argv[1] if len(sys.argv) > 1 else 'raf1')
