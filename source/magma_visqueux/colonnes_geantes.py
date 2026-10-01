"""Colonnes de magma géantes — jaillissement continu qui sort par le haut de la carte (AGM2).

Demande : « de nouvelles colonnes de magma, plus grandes, qu'on n'en voie pas le bout sur la map, et plus
impressionnantes ». Chaque colonne part d'une bouche dans le lac et monte jusqu'au bord haut de l'image (y = 0) : son sommet
n'est jamais visible.

Matière : la même que le lac et les cascades (magma.py : rampe relevée sur la lave de Dark_Crater_Pit_TDS.png, Worley
périodique), étirée x2 dans l'axe du jet. Toutes les lois sont périodiques sur PHASES, la boucle est donc fermée :
- montée : la matière monte de 3 périodes de texture (3 x 96 x 2 = 576 px) par boucle, soit 12 px par phase ;
- serpentement : l'axe ondule (ondes à fréquence temporelle entière) ;
- poussées : deux renflements clairs par boucle naissent à la bouche et montent jusqu'à sortir du cadre ;
- profil : cœur jaune vif, flancs orange puis rouges, lisière rouge, croûte de 2 px qui roule, contour sombre ;
- bouche : couronne évasée et bouillonnante (bourrelet de croûte, crêtes claires qui tournent) ;
- pluie : des gouttes retombent de la colonne en paraboles et font un anneau sur le lac ;
- ondes : trois anneaux concentriques s'éloignent de la bouche sur le lac visible.
"""
import numpy as np

from importlib import util as _u
from pathlib import Path as _P

_sp = _u.spec_from_file_location('magma_visqueux_mg', _P(__file__).with_name('magma.py'))
MG = _u.module_from_spec(_sp); _sp.loader.exec_module(MG)

PHASES, TICKS = 48, 5                        # 240 ticks = 4 s
RISE_PERIODS = 3                             # périodes de texture montées par boucle
STRETCH = 2.0                                # étirement de la matière dans l'axe du jet
SURGES = 2                                   # poussées par boucle
N_DROPS = 14
RIPPLES = 3


def _paint(a, m, idx):
    idx = np.clip(np.rint(idx).astype(int), 0, 12)
    a[m, :3] = MG.PAL_NP[idx[m] if np.ndim(idx) else idx]; a[m, 3] = 255


def window(c, H, W):
    """Fenêtre (x0, x1, y1) qui contient la colonne, sa couronne, ses gouttes et ses ondes ; y0 = 0 (bord haut)."""
    m = c['demi'] + 30
    return max(0, c['x'] - int(3 * m) - 4), min(W, c['x'] + int(3 * m) + 5), min(H, c['y'] + int(2.9 * 17) + 6)


def column_phase(t, H, W, c, visible):
    """RGBA (fenêtre) de la colonne c (dict x, y, demi, decalage, graine) à la phase t ; retourne (a, wx0)."""
    wx0, wx1, wy1 = window(c, H, W)
    a = np.zeros((wy1, wx1 - wx0, 4), 'uint8')
    visible = visible[:wy1, wx0:wx1]
    x0, yb, hw, seed = c['x'], c['y'], c['demi'], c['graine']
    s = ((t - c['decalage']) % PHASES) / PHASES; ph = 2 * np.pi * s
    yy, xx = np.mgrid[:wy1, wx0:wx1].astype(float)
    # ---------------------------------------------------------------- corps
    axis = x0 + 2.2 * np.sin(yy / 41 + ph + seed) + 1.1 * np.sin(yy / 15 - 2 * ph + 2 * seed)
    flare = 11 * np.exp(-np.clip(yb - yy, 0, None) / 13)                      # évasement à la bouche
    surge = np.zeros_like(yy)
    for k in range(SURGES):
        pos = yb - ((s + k / SURGES) % 1) * (yb + 90)                         # naît à la bouche, sort par le haut
        surge += np.exp(-((yy - pos) / 16) ** 2)
    half = hw * (1 + 0.07 * np.sin(yy / 17 - 3 * ph + seed)) + flare + 7.0 * surge
    xi = (xx - axis) / half
    body = (yy <= yb) & (np.abs(xi) <= 1)
    v = (yy + RISE_PERIODS * MG.PERIOD[1] * STRETCH * s) / STRETCH           # la matière monte
    u = (xx - axis) + 53 * seed
    lvl_m, q, h, _, _ = MG.cell_level(u / MG.ANISO * 0.5, v, seed, 0)
    prof = np.clip(1 - np.abs(xi) ** 2, 0, 1)
    lvl = np.clip(lvl_m - 5.2 + 7.0 * prof ** 0.8 + 2.6 * surge, 2, 12)          # flancs rouge sombre, cœur clair
    plate = (h < 0.2) & (q < 0.78) & (np.abs(xi) > 0.3)                       # plaques de croûte qui montent avec la matière
    lvl = np.where(plate, np.where(q > 0.62, 5, np.where(q > 0.5, 2, 1)), lvl)
    lvl = np.where(np.abs(xi) < 0.22 + 0.06 * np.sin(v / 9), np.maximum(lvl, 11.3), lvl)   # cœur jaune vif
    streak = (np.sin(xi * 9.5 + 0.9 * np.sin(v / 13 + seed)) > 0.9) & (np.abs(xi) < 0.8)
    lvl = np.where(streak, np.minimum(lvl + 2.2, 12), lvl)                    # filets clairs dans l'axe du jet
    edge = (1 - np.abs(xi)) * half                                             # distance au bord (px)
    grain = MG.sample(MG.tex_noise(seed + 9, 0.8), u, v)
    lvl = np.where(edge < 5.5, 3, lvl)                                         # lisière rouge
    lvl = np.where(edge < 4.2, np.where(grain > 0.8, 2, 1), lvl)             # croûte qui roule
    lvl = np.where(edge < 2.0, 0, lvl)                                         # contour sombre de 2 px
    _paint(a, body, lvl)
    # ---------------------------------------------------------------- bouche : couronne bouillonnante
    rx, ry = hw + 30, 17.0
    d = np.hypot((xx - x0) / rx, (yy - yb) / ry)
    ang = np.arctan2((yy - yb) / ry, (xx - x0) / rx)
    lip = 1 + 0.12 * np.sin(5 * ang + 2 * ph) + 0.08 * np.sin(9 * ang - 3 * ph + seed)
    crown = (d <= lip) & visible                                                 # gerbe autour du pied, jamais sur la roche
    crown |= (d <= lip) & (np.abs(xx - x0) <= hw + 11) & (yy >= yb - ry) & (yy <= yb)
    crest = np.sin(7 * ang - 4 * ph + 3 * d) > 0.55
    boil = np.sin(5 * ang + 3 * ph - 6 * d)                                    # bouillonnement : plaques et crêtes qui tournent
    cl = np.where(d > lip - 0.1, 0, np.where(d > lip - 0.3, np.where(np.sin(11 * ang + ph) > 0.3, 2, 1),
                  np.where(crest, 12, np.where(boil > 0.25, 2 - (boil > 0.8), 9))))
    _paint(a, crown & ~(body & (yy < yb - 0.55 * ry)), cl)                     # devant le bas du corps
    # ---------------------------------------------------------------- ondes sur le lac
    for k in range(RIPPLES):
        f = (s * 2 + k / RIPPLES) % 1
        rr = 1.25 + 1.6 * f
        ring = (np.abs(np.hypot((xx - x0) / rx, (yy - yb) / ry) - rr) < 0.045 + 0.02 * (1 - f)) & visible
        ring &= a[..., 3] == 0
        _paint(a, ring, 9 - 4 * f)
    # ---------------------------------------------------------------- pluie de gouttes
    rng = np.random.default_rng(seed * 101 + 7)
    for j in range(N_DROPS):
        side = -1 if j % 2 else 1
        start = rng.random(); life = 0.22 + 0.12 * rng.random()
        h0 = 60 + 140 * rng.random(); reach = hw + 16 + 30 * rng.random()
        tt = ((s - start) % 1) / life
        if tt > 1.25:
            continue
        if tt <= 1:
            x = x0 + side * (hw * 0.7 + (reach - hw * 0.7) * tt)
            y = yb - h0 * (1 - tt ** 2) + 6 * (rng.random() - 0.5)
            r2 = (xx - x) ** 2 + (yy - y) ** 2
            big = 1 + (j % 3 == 0)
            _paint(a, r2 <= 6.5 * big, 0); _paint(a, r2 <= 3.0 * big, 9); _paint(a, r2 <= 0.8 * big, 12)
        else:
            x = x0 + side * reach; k = (tt - 1) / 0.25
            ring = (np.abs(np.hypot((xx - x) / 2.0, yy - yb - 2) - (1.5 + 3 * k)) < 0.6) & visible & (a[..., 3] == 0)
            _paint(a, ring, 9 - 3 * k)
    return a, wx0


def column_frames(H, W, cols, visible):
    """PHASES calques plein cadre ; les colonnes de devant (bouche plus au sud) recouvrent celles de derrière."""
    out = []
    order = sorted(cols, key=lambda c: c['y'])
    for t in range(PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for c in order:
            f, wx0 = column_phase(t, H, W, c, visible)
            sub = e[:f.shape[0], wx0:wx0 + f.shape[1]]
            m = f[..., 3] > 0; sub[m] = f[m]
        out.append(e)
    return out
