"""Segmentation pleine résolution du brut de jour (1200 x 896) — module importé par build.py."""
import numpy as np
from scipy import ndimage as nd


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


def close_(m, it):
    p = it + 1
    return nd.binary_closing(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def keep_large(m, n):
    lab, k = nd.label(m)
    if k == 0:
        return m.copy()
    s = nd.sum(m, lab, range(1, k + 1))
    return np.isin(lab, [i + 1 for i, v in enumerate(s) if v >= n])


def largest(m):
    lab, k = nd.label(m)
    if k == 0:
        return m.copy()
    return lab == int(np.argmax(nd.sum(m, lab, range(1, k + 1)))) + 1


def classify(a):
    """Seuils mesurés sur le brut de jour (1200 x 896) :
    horizon = première rangée (sous y 120) où plus de 90 % des pixels sont bleu mer (b > 150, b > r + 80, lum < 170) ;
    prairie = plus grande composante verte (g > 170, g > r + 60, g > b + 60) sous l'horizon, fermée 4 px, trous bouchés
    (fleurs, rochers, buissons et chemin compris ; les creux ouverts sur les bords sud et latéraux, sous 60 % de la
    hauteur, aussi) ; mer = sous l'horizon, hors prairie ; panorama = tout ce qui est au-dessus de l'horizon (ciel,
    cimes, mer de nuages : le bas du dégradé du ciel (81,186,251) a la couleur de la neige du pic (130,194,246),
    une séparation par couleur serait arbitraire ; c'est un fond fixe et bloqué).
    Dans la prairie : herbe = distance RGB < 38 au vert médian de la prairie ou vert (g > r + 55, g > b + 55,
    lum > 150) ; objets = le reste, fermé 2 px, trous bouchés, >= 25 px : chemin = sable (r > 180, g > 160, b < 170,
    r > b + 30) en grande composante (>= 4000 px) près du bord sud, fermé 4 px ; fleurs = composantes à >= 8 % de
    pixels roses (r > 190, g < 185, r > g + 35) ou jaunes (r > 200, g > 190, b < 120) ; rochers = gris-bleu (|r - g| < 28,
    b >= g - 5, b - r < 45, 60 < lum < 215) >= 35 % ; buissons = le reste >= 900 px ; miettes (touffes) = herbe."""
    a = a.astype(int); h, w = a.shape[:2]; yy, xx = np.mgrid[:h, :w]
    r, g, b = a[..., 0], a[..., 1], a[..., 2]; la = lum_of(a)
    seablue = (b > 150) & (b > r + 80) & (la < 170)
    rows = seablue.mean(1)
    yh = int(next(y for y in range(120, h) if rows[y] > 0.9))
    green = (g > 170) & (g > r + 60) & (g > b + 60) & (yy > yh)
    prairie = nd.binary_fill_holes(close_(largest(green), 4))
    # Le bord sud et les bords latéraux : la prairie touche le cadre ; on bouche aussi les creux ouverts sur le cadre.
    pad = np.pad(prairie, 1, constant_values=False); pad[-1, :] = True
    pad[:, 0] |= np.r_[False, prairie[:, 0], False] | (np.arange(h + 2) > h * 0.6)
    pad[:, -1] |= np.r_[False, prairie[:, -1], False] | (np.arange(h + 2) > h * 0.6)
    prairie = nd.binary_fill_holes(pad)[1:-1, 1:-1] & (yy > yh)
    mer = (yy >= yh) & ~prairie
    panorama = yy < yh
    # --- prairie
    med = np.median(a[prairie & green], 0)
    grass = ((np.abs(a - med).sum(2) < 38 * 1.7) | ((g > r + 55) & (g > b + 55) & (la > 150))) & prairie
    obj = keep_large(nd.binary_fill_holes(close_(prairie & ~grass, 2)) & prairie, 25)
    sand = (r > 180) & (g > 160) & (b < 170) & (r > b + 30) & prairie
    chemin = keep_large(close_(sand, 4) & prairie, 4000)
    lab, _ = nd.label(chemin)
    south = np.unique(lab[yy > h - 40][chemin[yy > h - 40]]) if chemin.any() else []
    chemin = np.isin(lab, south[south > 0]) if len(south) else chemin
    chemin = nd.binary_fill_holes(chemin)
    pink = (r > 190) & (g < 185) & (r > g + 35)
    yellow = (r > 200) & (g > 190) & (b < 120)
    grey = (np.abs(r - g) < 28) & (b >= g - 5) & (b - r < 45) & (la > 60) & (la < 215)
    ol, on = nd.label(obj & ~chemin)
    fle = np.zeros_like(obj); roc = np.zeros_like(obj); bui = np.zeros_like(obj); crumbs = np.zeros_like(obj)
    nf = nr = nb = 0
    for i, s in enumerate(nd.find_objects(ol)):
        m = ol[s] == i + 1
        if (pink[s][m] | yellow[s][m]).mean() >= 0.08:
            fle[s] |= m; nf += 1
        elif grey[s][m].mean() >= 0.35:
            roc[s] |= m; nr += 1
        elif m.sum() >= 900:
            bui[s] |= m; nb += 1
        else:
            crumbs[s] |= m
    herbe = prairie & ~fle & ~roc & ~bui & ~chemin
    masks = dict(panorama=panorama, mer=mer, herbe=herbe, chemin=chemin, fleurs=fle,
                 rochers=roc, buissons=bui)
    seg = {'horizon_y': yh, 'vert_median_prairie': [round(float(v), 1) for v in med], 'objets': int(on),
           'fleurs': nf, 'rochers': nr, 'buissons': nb, 'touffes_rendues_a_l_herbe_px': int(crumbs.sum()),
           'prairie_px': int(prairie.sum()), 'mer_px': int(mer.sum())}
    return masks, seg
