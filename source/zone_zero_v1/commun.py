"""Zone Zéro (réseau RAZ / EAZ) — lois d'animation partagées, calculées (pas de pixels natifs).

- Cascades : loi relevée sur P03P01A (ROM PMD Sky, rendu par source/outil_maps_pmdsky) : motif vertical de 96 px qui descend
  de 32 px par image, 3 images de 10 ticks (boucle fermée). Motif « ikat » recalculé : stries verticales de 1 px à bord en
  flammes, bande blanche en V toutes les 96 px, cœur marine, flancs bleu clair, bords blancs. Palette : les 14 tons de la
  cascade de P03P01A.
- Écume : bouillons ronds ombrés (haut clair, bas bleuté, contour), qui changent de forme sur les 3 mêmes images (P03P01A).
- Rides : arcs clairs qui s'éloignent de l'écume sur les bassins, 3 images.
- Abîme : vide du cratère, profondeur par distance au bord, brume qui ondule (sinus à fréquences temporelles entières) et
  éclats de cristal lointains qui scintillent ; 24 images de 10 ticks, tramage ordonné 2 x 2.
"""
import numpy as np
from scipy import ndimage as nd

CASC_PHASES, CASC_TICKS, CASC_PERIOD, CASC_STEP = 3, 10, 96, 32
assert CASC_PHASES * CASC_STEP == CASC_PERIOD                               # boucle fermée
FOAM_PHASES, FOAM_TICKS = 3, 10
RIPPLE_PHASES, RIPPLE_TICKS = 3, 10
ABYSS_PHASES, ABYSS_TICKS = 24, 10

# 14 tons de la cascade de P03P01A (x 200-264, y 0-288), du plus sombre au plus clair
CASC_PAL = [(16, 66, 123), (33, 82, 148), (57, 99, 165), (74, 123, 181), (82, 148, 198), (123, 140, 198), (132, 165, 206),
            (156, 181, 222), (181, 198, 231), (189, 206, 239), (214, 222, 239), (239, 239, 247), (247, 255, 255), (255, 255, 255)]
NAVY, DEEP, MID, BLUE, SIDE, LILAC, PALE1, PALE2, PALE3, PALE4, MIST, WHITE1, WHITE2, WHITE3 = CASC_PAL
FOAM_PAL = [LILAC, PALE2, PALE4, MIST, WHITE1, WHITE2]                    # contour -> lumière (tons de l'écume de P03P01A)
RIPPLE_PAL = [SIDE, PALE1]
# Abîme : vert-bleu profond de la Zone Zéro vers la brume claire (choix de l'agent)
ABYSS_TONES = [(8, 26, 36), (14, 42, 52), (24, 62, 70), (40, 86, 90), (62, 112, 112), (92, 142, 138), (132, 176, 168), (182, 214, 204), (224, 240, 232)]
GLINT_TINTS = [(240, 170, 226), (150, 236, 236), (255, 255, 255), (190, 170, 255)]
GLINT_SEQ = [1, 2, 3, 2, 1] + [0] * 19
BAYER = np.array([[0, 2], [3, 1]]) / 4.0


def _rng(seed):
    return np.random.default_rng(seed)


# ---------------------------------------------------------------- cascades
def cascade_column(w, h, t, seed):
    """RGB (h, w, 3) d'une cascade de largeur w, phase t : motif périodique 96 px décalé de 32 px par phase."""
    rng = _rng(seed)
    x = np.arange(w)
    u = np.abs((x + 0.5) / w * 2 - 1)[None, :]                               # 0 au centre, 1 aux bords
    n1 = rng.integers(0, 13, w)[None, :].astype(float)                       # flammes sous la bande blanche (par colonne de 1 px)
    n2 = rng.integers(0, 11, w)[None, :].astype(float)                       # stries des zones bleues
    n3 = rng.integers(0, 7, w)[None, :].astype(float)                        # flammes au-dessus de la bande
    y = np.arange(h)[:, None]
    d = (y - CASC_STEP * t - np.round(8 * (1 - u)).astype(int)) % CASC_PERIOD   # V (décalage entier : raccord exact)
    par = (x[None, :] + y) % 2
    reach = 0.78 - 0.66 * np.clip((d - 20 - 0.5 * n2) / 68, 0, 1) + 0.05 * (n2 - 5) / 5   # cœur marine en pointe vers le bas
    lvl = np.where(u < reach, 0, np.where(u < reach + 0.1, 1, np.where(u > 0.58, np.where(n2 % 3 == 0, 3, 4), np.where(n2 % 2 == 0, 3, 2))))
    lvl = np.where(d > 78 + 2.5 * n3, np.where(n2 % 2 == 0, 7, 9), lvl)      # flammes blanches qui montent de la bande suivante
    lvl = np.where(d < 24 + n1, np.where(u > 0.5, 6, 3), lvl)
    lvl = np.where(d < 17 + 0.6 * n1, np.where(par == 0, 7, 9), lvl)
    lvl = np.where(d < 11 + 0.4 * n1, np.where(par == 0, 12, 11), lvl)
    lvl = np.where(u > 0.8 + 0.04 * (n3 % 2), np.where(d < 40 + n1, 11, 7), lvl)   # bords clairs
    lvl = np.where(u > 0.9, np.where(par == 0, 12, 11), lvl)
    return np.array(CASC_PAL, 'uint8')[lvl]


def cascade_frames(H, W, rects):
    """rects : liste de dicts x0, x1, y1 (bas, sous l'écume), graine, et y0 facultatif (haut de la chute, 0 par défaut :
    chute qui part du bord de la carte ; > 0 : chute qui passe une falaise au milieu de la carte). Colonnes de y0 à y1."""
    frames = []
    for t in range(CASC_PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for c in rects:
            x0, x1, y0, y1 = c['x0'], c['x1'], c.get('y0', 0), c['y1']
            e[y0:y1, x0:x1, :3] = cascade_column(x1 - x0, y1 - y0, t, c['graine']); e[y0:y1, x0:x1, 3] = 255
        frames.append(e)
    return frames


# ---------------------------------------------------------------- écume
def foam_puffs(mask, seed, r_min=4.0, r_max=8.0):
    """Bouillons : centres tirés dans le masque d'écume (distance mini), rayon selon la place."""
    rng = _rng(seed); dist = nd.distance_transform_edt(mask)
    ys, xs = np.nonzero(mask); order = rng.permutation(len(ys)); puffs = []
    for i in order:
        y, x = int(ys[i]), int(xs[i])
        if dist[y, x] < 1.5 or any((x - p['x']) ** 2 + (y - p['y']) ** 2 < (0.9 * p['r']) ** 2 for p in puffs):
            continue
        r = float(np.clip(dist[y, x] + 1.2, r_min, r_max))
        puffs.append({'x': x, 'y': y, 'r': round(r, 2), 'phase': int(rng.integers(0, FOAM_PHASES)), 'dx': int(rng.choice([-1, 1]))})
    return puffs


def foam_frames(H, W, mask, puffs):
    """Chaque bouillon gonfle et dégonfle (3 tailles) en glissant de 1 px ; ombrage haut-gauche clair, contour lilas."""
    yy, xx = np.mgrid[:H, :W]
    ys, xs = np.nonzero(nd.binary_dilation(mask, iterations=3))
    y0, y1, x0, x1 = ys.min(), ys.max() + 1, xs.min(), xs.max() + 1
    sy, sx = yy[y0:y1, x0:x1], xx[y0:y1, x0:x1]
    grow = [0.0, 1.0, 0.4]
    frames = []
    for t in range(FOAM_PHASES):
        best = np.full(sy.shape, np.inf); shade = np.zeros(sy.shape)
        for p in puffs:
            k = (t + p['phase']) % FOAM_PHASES
            r = p['r'] + grow[k]; cx = p['x'] + p['dx'] * (k == 1); cy = p['y'] - (k == 1)
            d = np.hypot(sx - cx, sy - cy) / r
            hi = np.hypot(sx - (cx - 0.35 * r), sy - (cy - 0.4 * r)) / r      # reflet haut-gauche
            m = d < best
            best = np.where(m, d, best); shade = np.where(m, hi, shade)
        inside = best <= 1.0
        edge = inside & ~nd.binary_erosion(inside)
        lvl = np.where(shade < 0.4, 5, np.where(shade < 0.7, 4, np.where(shade < 0.95, 3, np.where(shade < 1.15, 2, 1))))
        lvl = np.where((best > 0.86) & (shade > 0.9), 1, lvl)
        lvl = np.where(edge, 0, lvl)
        e = np.zeros((H, W, 4), 'uint8')
        sub = e[y0:y1, x0:x1]
        sub[inside, :3] = np.array(FOAM_PAL, 'uint8')[lvl[inside]]; sub[inside, 3] = 255
        frames.append(e)
    return frames


# ---------------------------------------------------------------- rides des bassins
def ripple_frames(base, water, foam, sources):
    """base : RGBA de l'eau (fixe) ; arcs clairs autour de chaque source (centre, demi-axes) qui s'éloignent (3 phases)."""
    H, W = water.shape
    yy, xx = np.mgrid[:H, :W]
    free = water & ~nd.binary_dilation(foam, iterations=1)
    frames = []
    for t in range(RIPPLE_PHASES):
        e = base.copy()
        for s in sources:
            cx, cy = s['centre']; ax, ay = s['demi_axes']
            rho = np.hypot((xx - cx) / ax, (yy - cy) / ay)
            for k in range(3):
                r0 = 1.08 + 0.2 * (k + t / RIPPLE_PHASES)
                band = free & (np.abs(rho - r0) < 0.022 + 0.004 * k) & (np.sin(9 * np.arctan2(yy - cy, xx - cx) + 2 * k) > -0.3)
                e[band, :3] = RIPPLE_PAL[0] if k < 2 else RIPPLE_PAL[1]
        frames.append(e)
    return frames


# ---------------------------------------------------------------- abîme
def abyss_frames(void, rim_side='south', seed=7, n_glints=36):
    """void : masque du vide. Profondeur = distance au bord ; brume ondulante ; éclats de cristal lointains."""
    H, W = void.shape
    yy, xx = np.mgrid[:H, :W].astype(float)
    dist = nd.distance_transform_edt(np.pad(void, ((0, 1), (1, 1)), mode='constant', constant_values=False))[:-1, 1:-1]
    if rim_side == 'south':                                                   # le haut de l'image s'ouvre vers le fond du cratère
        dist = np.where(void, np.minimum(dist, 400), 0)
    depth = np.clip(dist / 90, 0, 1)
    rng = _rng(seed); glints = []
    cand = np.argwhere(void & (dist > 28))
    rng.shuffle(cand)
    for y, x in cand:
        if len(glints) >= n_glints:
            break
        if all(max(abs(x - g['xy'][0]), abs(y - g['xy'][1])) > 9 for g in glints):
            glints.append({'xy': [int(x), int(y)], 'teinte': list(GLINT_TINTS[len(glints) % 4]), 'phase': int(rng.integers(0, ABYSS_PHASES))})
    frames = []
    n = len(ABYSS_TONES)
    for t in range(ABYSS_PHASES):
        ph = 2 * np.pi * t / ABYSS_PHASES
        mist = (0.55 * np.sin(xx / 23 + yy / 41 - ph) + 0.35 * np.sin(xx / 13 - yy / 29 + 2 * ph + 1.3)
                + 0.25 * np.sin(yy / 9 + xx / 57 + ph + 0.4))
        lev = 2.3 + 1.2 * (1 - depth) + 1.9 * mist + 0.9 * np.sin(yy / 17 - xx / 90 + ph)      # bancs de brume et trouées sombres
        lev = np.where(dist < 4, np.minimum(lev, 1.2), lev)                     # ombre fine sous la lèvre
        lev = np.floor(lev + BAYER[(yy.astype(int) % 2), (xx.astype(int) % 2)])
        lev = np.clip(lev, 0, n - 1).astype(int)
        e = np.zeros((H, W, 4), 'uint8')
        e[..., :3] = np.array(ABYSS_TONES, 'uint8')[lev]; e[..., 3] = 255; e[~void] = 0
        for g in glints:
            L = GLINT_SEQ[(t - g['phase']) % ABYSS_PHASES]
            if not L:
                continue
            x, y = g['xy']; c = g['teinte']
            for dd in range(1, L):
                for dx, dy in ((dd, 0), (-dd, 0), (0, dd), (0, -dd)):
                    if 0 <= x + dx < W and 0 <= y + dy < H and void[y + dy, x + dx]:
                        e[y + dy, x + dx] = (*c, 255)
            e[y, x] = (255, 255, 255, 255) if L >= 2 else (*c, 255)
        frames.append(e)
    return frames, glints, dist
