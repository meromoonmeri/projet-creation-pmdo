"""Magma visqueux — module partagé par l'entrée Cratère magma (ECM1) et l'arène de Groudon (AGM1).

Demande : « faut que le magma de la zone bouge de manière visqueuse ». Le magma n'est pas la lave « façon rivière
Métano » des lots précédents (bandes qui oscillent) : c'est une matière épaisse dont les cellules dérivent lentement,
se plient et se déforment, avec des plaques de croûte sombre qui flottent et des fissures qui luisent.

Matière : rampe de 11 tons RELEVÉE sur la lave du rip Dark_Crater_Pit_TDS.png (PMD Sky), du rouge (247,39,31) au
jaune (255,255,47), plus les deux croûtes de l'entrée Cratère (ECN1) et un ton intermédiaire interpolé. Motif cellulaire
de la lave du rip (cellules rouges, bords orange, lignes jaunes) = bruit de Worley périodique ; pixels calculés,
aucune tuile native.

Mouvement visqueux (chaque terme est périodique sur N phases, donc la boucle est fermée) :
- dérive lente : le motif avance de exactement une période de texture sur la boucle ;
- pliage : déformation de coordonnées par deux ondes lentes qui voyagent (la matière s'étire puis se tasse) ;
- gonflement : des bosses lentes remontent et éclaircissent la surface d'un ou deux tons, puis retombent ;
- croûte : les cellules « froides » (tirage par cellule, donc elles voyagent avec la matière) forment des plaques
  sombres à bord incandescent ; elles fondent près du pied des cascades et figent près des rives ;
- rides : autour du pied d'une cascade, des plis concentriques s'éloignent lentement.
Cascades : même matière étirée verticalement qui descend, profil clair au centre, bords de croûte qui ondulent.
Colonnes : jet procédural (gonflement, jaillissement, colonne, retombée en gouttes, anneau), 48 phases, décalées.
"""
import numpy as np
from scipy import ndimage as nd

# Rampe du rip (quantification des pixels de lave de Dark_Crater_Pit_TDS.png, couleurs exactes présentes dans le rip).
RIP_RAMP = [(247, 39, 31), (247, 63, 31), (247, 95, 31), (247, 119, 31), (247, 135, 31), (247, 151, 39),
            (255, 167, 39), (255, 199, 47), (255, 223, 55), (255, 255, 47)]
CROUTE = [(70, 20, 26), (120, 26, 22), (184, 32, 26)]      # lip, bande de ECN1 ; braise = milieu bande / rouge du rip
PAL = CROUTE + RIP_RAMP                                     # 13 tons, index 0 (croûte noire) -> 12 (jaune vif)
PAL_NP = np.array(PAL, 'uint8')
N_RIP0 = len(CROUTE)                                        # premier index de la rampe du rip

PHASES, TICKS = 32, 15                                      # 480 ticks = 8 s
CELL = 24                                                   # taille des cellules (lave du rip : 20 à 30 px)
PERIOD = (192, 96)                                          # période de la texture (x, y) ; y = axe de dérive
COL_PHASES, COL_TICKS = 48, 5                               # colonnes : 240 ticks


# ---------------------------------------------------------------- bruit de Worley périodique
def _grid(P, cell, seed):
    nx, ny = P[0] // cell, P[1] // cell
    rng = np.random.default_rng(seed)
    return nx, ny, 0.15 + 0.7 * rng.random((ny, nx)), 0.15 + 0.7 * rng.random((ny, nx)), rng.random((ny, nx))


def worley(u, v, P=PERIOD, cell=CELL, seed=3):
    """f1, f2 (distances aux deux germes les plus proches, px) et tirage [0,1) de la cellule la plus proche."""
    nx, ny, jx, jy, hid = _grid(P, cell, seed)
    iu = np.floor(u / cell).astype(int); iv = np.floor(v / cell).astype(int)
    f1 = np.full(u.shape, 1e9); f2 = np.full(u.shape, 1e9); h = np.zeros(u.shape)
    for dj in (-1, 0, 1):
        for di in (-1, 0, 1):
            ci, cj = iu + di, iv + dj
            gi, gj = ci % nx, cj % ny
            d = np.hypot(u - (ci + jx[gj, gi]) * cell, v - (cj + jy[gj, gi]) * cell)
            closer = d < f1
            f2 = np.where(closer, f1, np.minimum(f2, d)); h = np.where(closer, hid[gj, gi], h); f1 = np.minimum(f1, d)
    return f1, f2, h


def smooth_field(shape, seed, sigma):
    f = nd.gaussian_filter(np.random.default_rng(seed).random(shape), sigma, mode='wrap')
    return (f - f.mean()) / (f.std() + 1e-9)


# ---------------------------------------------------------------- mares de magma
ANISO = 0.6                      # cellules étirées à l'horizontale (lave du rip : environ 2:1)


def tex_noise(seed, sigma=3.0, P=PERIOD):
    """Bruit lisse périodique (période P) : il ondule les bords des cellules et voyage avec la matière."""
    return smooth_field((P[1], P[0]), seed, sigma)


def sample(tile, u, v):
    Py, Px = tile.shape
    return tile[np.floor(v).astype(int) % Py, np.floor(u).astype(int) % Px]


def cell_level(u, v, seed, heave):
    """Niveau de palette de la matière (sans croûte) + q (0 au germe, 1 sur la fissure) + tirage de cellule."""
    nu, nv = tex_noise(seed + 7), tex_noise(seed + 8)
    us = u * ANISO + 2.4 * sample(nu, u * ANISO, v)
    vs = v + 2.4 * sample(nv, u * ANISO, v)
    f1, f2, h = worley(us, vs, seed=seed)
    q = 2 * f1 / (f1 + f2 + 1e-9)                                   # 0 au centre, 1 sur la fissure
    core = 0.30 + 0.18 * h                                          # cœurs rouges de tailles variées
    lvl = np.where(q < core, 3.4 + 1.6 * q / core,
          np.where(q < 0.80, 5.0 + 4.0 * (q - core) / (0.80 - core),
          np.where(q < 0.94, 8.8, 11.0)))
    return np.clip(lvl + heave, N_RIP0, 12), q, h, us, vs


def magma_phases(mask, visible, feet=(), drift=(0, 1), seed=3, crust=0.12, phases=PHASES):
    """Phases RGBA du magma visqueux sur `mask` (bool H x W).

    drift : (dx, dy) en périodes par boucle (entiers) ; (0, 1) = vers le sud, (0, 0) = brassage sur place.
    feet : points (x, y) où tombe une cascade (rides concentriques, croûte fondue).
    Retourne (frames, dist_rive, index) ; index = liste des cartes d'index de palette (tests).
    """
    H, W = mask.shape
    yy, xx = np.mgrid[:H, :W].astype(float)
    d = nd.distance_transform_edt(visible)
    gx, gy, gh = smooth_field((H, W), seed + 1, 22), smooth_field((H, W), seed + 2, 22), smooth_field((H, W), seed + 3, 30)
    psi = 2 * np.pi * (gh - gh.min()) / (np.ptp(gh) + 1e-9)          # phase locale des gonflements
    rf = np.full((H, W), 1e9)
    for fx, fy in feet:
        rf = np.minimum(rf, np.hypot((xx - fx) / 1.4, yy - fy))
    hot = np.exp(-rf / 55.0)
    crust_frac = np.clip(crust + 0.30 * np.exp(-d / 12.0) - 0.5 * hot, 0.0, 0.6)
    grain = tex_noise(seed + 9, 0.8)
    frames, idxs = [], []
    for t in range(phases):
        s = t / phases; ph = 2 * np.pi * s
        # pliage : deux ondes lentes qui voyagent + champ aléatoire qui respire
        wu = 5.0 * np.sin(2 * np.pi * yy / 173.0 + ph) + 3.0 * gx * np.sin(ph + 1.7)
        wv = 4.0 * np.sin(2 * np.pi * xx / 211.0 - ph + 0.8) + 3.0 * gy * np.cos(ph + 0.4)
        u = xx - drift[0] * PERIOD[0] / ANISO * s + wu
        v = yy - drift[1] * PERIOD[1] * s + wv
        heave = 1.1 * np.sin(ph + psi)                                   # bosses qui montent et retombent
        ripple = np.maximum(np.cos(2 * np.pi * (rf / 26.0 - s * 4)), 0) * 2.0 * hot   # plis qui s'éloignent du pied
        lvl, q, h, us, vs = cell_level(u, v, seed, heave + ripple)
        # croûte : plaque arrondie sombre, bord incandescent, grain qui voyage avec elle
        is_crust = (h < crust_frac) & (q < 0.86)
        g = sample(grain, us, vs)
        cl = np.where(q > 0.74, 6.0 + heave, np.where(q > 0.62, 2.0, np.where(g > 0.9, 2.0, np.where(g > -0.3, 1.0, 0.0))))
        lvl = np.where(is_crust, cl, lvl)
        # rive : croûte figée (1 px noir, 1 px bande), qui respire d'un pixel
        rim = 1.0 + 0.8 * (np.sin(xx * 0.31 + yy * 0.17 + ph) > 0.3)
        lvl = np.where(d <= rim, 0, np.where(d <= rim + 1.2, np.minimum(lvl, 1), lvl))
        idx = np.rint(lvl).astype(int); idx[~mask] = 0
        a = np.zeros((H, W, 4), 'uint8'); a[..., :3] = PAL_NP[idx]; a[..., 3] = 255
        a[~mask] = 0; a[mask & ~visible, :3] = PAL_NP[1]
        frames.append(a); idxs.append(idx)
    return frames, d, idxs


# ---------------------------------------------------------------- cascades
def cascade_phases(mask, seed=11, falls=1, phases=PHASES, foot_rows=7):
    """Cascades visqueuses sur `mask` : la matière descend de `falls` périodes (y, x2,5) par boucle.

    Les bords sont une croûte sombre d'épaisseur variable qui descend avec la coulée : la lame claire serpente
    dans le rectangle de la cascade au lieu d'en suivre les bords droits."""
    H, W = mask.shape
    yy, xx = np.mgrid[:H, :W].astype(float)
    lab, n = nd.label(mask)
    xl = np.zeros((H, W)); xrr = np.zeros((H, W)); bottom = np.zeros((H, W)); wid = np.ones((H, W))
    for i in range(1, n + 1):
        m = lab == i
        for y in np.nonzero(m.any(1))[0]:
            xs = np.nonzero(m[y])[0]; x0, x1 = xs.min(), xs.max()
            xl[y, xs] = xs - x0; xrr[y, xs] = x1 - xs; wid[y, xs] = x1 - x0 + 1
        ys = np.nonzero(m.any(1))[0]
        bottom[m] = ys.max() - yy[m]
    edge_tile = tex_noise(seed + 5, 6.0, (64, 96))
    grain_t = tex_noise(seed + 9, 0.8)
    frames, idxs = [], []
    for t in range(phases):
        s = t / phases; ph = 2 * np.pi * s
        vf = yy / 2.5 - falls * PERIOD[1] * s                            # coordonnée de matière (descend)
        # lame : axe qui serpente et largeur qui gonfle, portés par la matière qui descend
        off = 0.14 * wid * sample(edge_tile, np.full_like(yy, 3), vf)
        half = wid * (0.34 + 0.07 * sample(edge_tile, np.full_like(yy, 40), vf))
        c = (xl - xrr) / 2 - off                                         # position par rapport à l'axe
        dx = np.abs(c)
        blade = dx <= half
        xr = np.clip(c / np.maximum(half, 1) * 0.5 + 0.5, 0, 1)
        prof = 1 - np.abs(2 * xr - 1) ** 2
        u = xx + 2.0 * np.sin(yy / 23.0 - ph * 3)
        lvl_m, q, h, _, _ = cell_level(u / ANISO * 0.5, vf, seed, 0)
        lvl = np.clip(lvl_m - 3.0 + 3.6 * prof, N_RIP0, 12)
        g = sample(grain_t, u, vf)
        crust = np.where(g > 0.8, 2, 1)
        lvl = np.where(dx > half - 3.2, crust, lvl)                      # croûte de 2 px qui roule sur les bords
        lvl = np.where((dx > half - 4.2) & (dx <= half - 3.2), 4, lvl)   # lisière rouge de la lame
        lvl = np.where(dx > half - 1.2, 0, lvl)
        mask_t = mask & blade
        idx = np.rint(lvl).astype(int)
        a = np.zeros((H, W, 4), 'uint8'); a[..., :3] = PAL_NP[idx]; a[..., 3] = 255
        # pied : rideau déchiqueté qui s'enfonce dans la mare (bas de la chute retiré selon un bruit animé)
        jag = foot_rows * (0.55 + 0.45 * np.sin(xx * 0.9 + ph * 6) * np.cos(xx * 0.37 - ph * 3))
        cut = mask & (bottom < jag)
        a[~mask_t | cut] = 0; idx[~mask_t | cut] = -1
        frames.append(a); idxs.append(idx)
    return frames, idxs


def cascade_feet(mask):
    """(x, y) du milieu du bas de chaque cascade."""
    lab, n = nd.label(mask); out = []
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i); yb = ys.max()
        out.append((int(xs[ys >= yb - 2].mean()), int(yb)))
    return out


# ---------------------------------------------------------------- colonnes de magma
COL_W, COL_H = 40, 150
COL_BASE = COL_H - 12                                               # ligne de la bouche dans la case


def _ramp(level):
    return PAL_NP[np.clip(np.rint(level).astype(int), 0, 12)]


def column_frame(k, jet_h=110, seed=0):
    """Pose k (0..COL_PHASES-1) d'une colonne de magma, RGBA COL_H x COL_W, bouche en (COL_W//2, COL_BASE)."""
    a = np.zeros((COL_H, COL_W, 4), 'uint8')
    yy, xx = np.mgrid[:COL_H, :COL_W].astype(float)
    cx, by = COL_W / 2 - 0.5, COL_BASE
    rng = np.random.default_rng(seed)

    def paint(m, lvl):
        a[m, :3] = _ramp(lvl)[m] if np.ndim(lvl) else PAL_NP[int(lvl)]; a[m, 3] = 255

    # bouche : dôme bas qui palpite (toujours visible), plus grand avant l'éruption
    if k < 12:
        swell = 0.25 * (1 + np.sin(2 * np.pi * k / 6))
    elif k < 16:
        swell = 0.5 + 0.5 * (k - 12) / 3
    elif k < 38:
        swell = 1.0
    else:
        swell = max(0.0, 1.0 - (k - 38) / 8)
    rx, ry = 6 + 4 * swell, 2.5 + 2 * swell
    if 13 <= k < 38:                                                # halo : la mare s'éclaire autour de la bouche
        halo = ((xx - cx) / (rx + 6)) ** 2 + ((yy - by) / (ry + 2.5)) ** 2 <= 1
        paint(halo, 10 + 0 * yy)
    dome = ((xx - cx) / rx) ** 2 + ((yy - by) / ry) ** 2 <= 1
    paint(dome, 1); inner = ((xx - cx) / (rx - 1.5)) ** 2 + ((yy - by + 0.5) / max(ry - 1.2, 0.8)) ** 2 <= 1
    paint(inner, 6 + 4 * swell * np.ones_like(yy))
    # hauteur du jet
    if 16 <= k < 22:
        e = (k - 15) / 6; hgt = jet_h * (1 - (1 - e) ** 2)
    elif 22 <= k < 32:
        hgt = jet_h * (1 + 0.06 * np.sin(2 * np.pi * (k - 22) / 5))
    elif 32 <= k < 36:
        hgt = jet_h * (1 - (k - 31) / 5)
    else:
        hgt = 0
    if hgt > 4:
        top = by - hgt
        body = (yy <= by) & (yy >= top)
        rel = np.clip((by - yy) / hgt, 0, 1)
        hw = 7.5 + 4.5 * (1 - rel) ** 2 + 5.5 * np.exp(-((yy - top - 6) / 6) ** 2) + 1.0 * np.sin(yy * 0.37 + k * 1.3) + 0.7 * np.sin(yy * 0.13 - k * 0.9 + seed)
        dx = np.abs(xx - cx - 1.2 * np.sin(yy * 0.08 + k * 0.6))
        col = body & (dx <= hw)
        paint(col & (dx > hw - 1.2), 0)
        paint(col & (dx <= hw - 1.2) & (dx > hw - 2.4), 3)
        core = col & (dx <= hw - 2.4)
        streak = np.sin((yy + k * 9) * 0.55 + xx * 0.3)                # coulées qui montent
        paint(core, 11.6 - 8.0 * (dx / hw) ** 0.9 + 1.0 * streak)
        head = ((xx - cx) / (hw + 0.5)) ** 2 + ((yy - top - 3) / 5) ** 2 <= 1
        paint(head & ~core & (yy < top + 4), 1)
        if 20 <= k < 34:                                            # couronne : paquets de magma projetés au sommet
            for j, (ox, oy) in enumerate(((-1, 0.6), (1, 0.6), (0, -0.4))):
                bx = cx + ox * (hw.max() * 0.9 + (k % 3)); byy = top + 4 * oy - (k % 2)
                r2 = (xx - bx) ** 2 + ((yy - byy) * 1.2) ** 2
                paint(r2 <= 12, 1); paint(r2 <= 6, 9 + (j == 2) * 2)
    # gouttes : projetées au sommet, paraboles vers les côtés, puis anneau d'impact
    if 22 <= k < 46:
        for j in range(7):
            side = -1 if j % 2 else 1
            vx = side * (0.7 + 0.35 * j + rng.random() * 0.3)
            t0 = 22 + (j * 3) % 10
            tt = k - t0
            if tt < 0:
                continue
            x = cx + vx * tt * 1.6; y = by - jet_h + 4 - 7 * tt + 0.62 * tt * tt
            if y > by + 2 or not (1 <= x < COL_W - 2):
                if y > by + 2 and tt < 18 and 1 <= x < COL_W - 2:
                    ring = np.abs(np.hypot((xx - x) / 1.8, yy - by - 1) - 1.6) < 0.7
                    paint(ring, 8)
                continue
            r2 = (xx - x) ** 2 + (yy - y) ** 2
            paint(r2 <= 5.5, 0); paint(r2 <= 2.5, 9); paint(r2 <= 0.6, 11)
    # anneau d'impact de la colonne qui retombe
    if 34 <= k < 44:
        rr = 5 + (k - 34) * 1.4
        ring = np.abs(np.hypot((xx - cx) / 1.0, (yy - by) * 2.2) - rr) < 0.9
        paint(ring & (a[..., 3] == 0), 9 - (k - 34) * 0.6 * np.ones_like(yy))
    return a


def column_poses(jet_h=110, seed=0):
    return [column_frame(k, jet_h, seed) for k in range(COL_PHASES)]


def column_frames(H, W, vents, visible=None):
    """vents : liste de dict(x, y, h, decalage). Retourne les COL_PHASES calques plein cadre."""
    out = [np.zeros((H, W, 4), 'uint8') for _ in range(COL_PHASES)]
    for i, v in enumerate(vents):
        poses = column_poses(v['h'], seed=i)
        x0, y0 = v['x'] - COL_W // 2, v['y'] - COL_BASE
        for t in range(COL_PHASES):
            p = poses[(t - v['decalage']) % COL_PHASES]
            sy0, sx0 = max(0, -y0), max(0, -x0)
            sy1, sx1 = min(COL_H, H - y0), min(COL_W, W - x0)
            pp = p[sy0:sy1, sx0:sx1]; m = pp[..., 3] > 0
            out[t][y0 + sy0:y0 + sy1, x0 + sx0:x0 + sx1][m] = pp[m]
    return out
