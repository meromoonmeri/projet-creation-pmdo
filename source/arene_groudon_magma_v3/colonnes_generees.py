"""Colonnes de magma GÉNÉRÉES (AGM3) : les pixels viennent du générateur d'images, référencé sur la lave de Dark_Crater_Pit_TDS.png.

Demande : « je veux que tu génères les colonnes de magma ». Brut : bruts/colonne_magenta.png (colonne organique à renflements,
cœur blanc-jaune, flancs rouges, croûtes, couronne d'éclaboussures et gouttes, sur magenta pur). Aucun pixel de colonne calculé :
le module découpe, réduit, raccorde et déplace les pixels générés.

- Corps : lignes 0 -> BODY_END du brut (silhouette + matière). Réduit par moyenne pondérée par le masque, ramené à la palette de
  la colonne (32 tons tirés du brut), puis rendu PÉRIODIQUE en hauteur : les SEAM dernières lignes sont fondues dans les
  premières (masque et couleurs), puis re-quantifiées sur la palette et recontourées (1 px, ton du contour généré).
  La bande monte d'une période par boucle, vitesse modulée (deux poussées) : décalage(u) = P (u - A sin(4 pi u) / 4 pi),
  croissant car A < 1. Les renflements montent donc avec la matière : jaillissement visqueux. Le sommet n'est jamais visible.
- Couronne : lignes CROWN_TOP -> bas du brut, recentrée sur la bouche (MOUTH_ROW du brut = bouche de la colonne). Au-dessus de
  la bouche, le canal central est laissé au corps qui monte. Sous la bouche, le brut est coupé net par le bas de l'image :
  on n'en garde qu'une ellipse irrégulière (bord ondulé), qui se fond dans le lac. Bouillonnement : animation de palette par rang de luminance
  (les tons clairs glissent de ± 1 à 2 rangs en ondes qui tournent autour de la bouche), comme les BPA de lave de PMD.
- Gouttes : les petites composantes du brut (gouttes générées), projetées en paraboles depuis la bouche, deux vols par boucle.
- Jamais sur la roche : couronne et gouttes seulement sur le lac visible (ou dans le canal du corps).
"""
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
RAW = HERE / 'bruts' / 'colonne_magenta.png'
PHASES, TICKS = 48, 5
BODY_END = 930           # fin du corps dans le brut (la couronne s'élargit dès ~940 : largeur x 1,4)
CROWN_TOP = 780          # les bras d'éclaboussure commencent vers 800 (au-dessus, seul le corps : laissé au canal)
MOUTH_ROW = 1105         # bouche : là où le cœur clair entre dans la couronne
CROWN_X = (40, 810)      # toute la gerbe générée (elle s'arrête vers x 56-794)
SEAM = 0.2               # part de la bande fondue pour le raccord périodique
SURGE_A = 0.6            # modulation de vitesse (deux poussées par boucle)
N_COLORS = 32
DROP_FLIGHTS = 2
# attributs lus par le manifeste hérité d'AGM2 (réécrits ensuite par build.py)
RISE_PERIODS, STRETCH, SURGES, N_DROPS, RIPPLES = 1, 1.0, 2, 0, 0


def magenta(a):
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    return (r > 180) & (b > 180) & (g < 110)


def load_raw():
    a = np.array(Image.open(RAW).convert('RGB')).astype(float)
    obj = ~magenta(a)
    lab, n = nd.label(obj)
    s = nd.sum(obj, lab, range(1, n + 1))
    main = lab == (int(np.argmax(s)) + 1)
    main = nd.binary_fill_holes(main)
    drops = [lab == i + 1 for i, v in enumerate(s) if v >= 150 and i + 1 != int(np.argmax(s)) + 1]
    return a, main, drops


_CACHE = {}


def palette():
    if 'pal' not in _CACHE:
        a, main, _ = load_raw()
        px = a[main].astype('uint8')[::7]
        q = Image.fromarray(px.reshape(-1, 1, 3)).quantize(colors=N_COLORS, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        pal = np.array(q.getpalette()[:N_COLORS * 3]).reshape(-1, 3)
        pal = pal[np.argsort(pal @ [.299, .587, .114])]                       # rang 0 = le plus sombre
        edge = main & ~nd.binary_erosion(main, iterations=4)                  # contour généré
        body_edge = edge.copy(); body_edge[BODY_END:] = False
        oc = np.median(a[body_edge], axis=0)
        outline = int(np.argmin(((pal - oc) ** 2).sum(1)))
        _CACHE['pal'] = (pal.astype('uint8'), outline)
    return _CACHE['pal']


def nearest(c, pal):
    d = ((c[:, None, :].astype(float) - pal[None].astype(float)) ** 2).sum(2)
    return d.argmin(1)


def down(a, m, s):
    """Réduction d'un facteur s, moyenne pondérée par le masque (pas de magenta mêlé au bord)."""
    h, w = m.shape; H2, W2 = max(1, round(h * s)), max(1, round(w * s))
    rs = lambda p: np.array(Image.fromarray(p.astype(np.float32), 'F').resize((W2, H2), Image.Resampling.BOX))
    mw = rs(m.astype(np.float32))
    col = np.stack([rs(a[..., k] * m) for k in range(3)], -1) / np.maximum(mw, 1e-6)[..., None]
    return col, mw


def prepare(scale, mirror):
    """Bande périodique du corps, couronne et gouttes à l'échelle voulue (indices de palette, -1 = vide)."""
    key = (round(scale, 4), bool(mirror))
    if key in _CACHE:
        return _CACHE[key]
    a, main, drops = load_raw()
    pal, outline = palette()
    if mirror:
        a = a[:, ::-1]; main = main[:, ::-1]; drops = [d[:, ::-1] for d in drops]
    Wr = a.shape[1]
    cx_raw = float(np.median([np.nonzero(main[y])[0].mean() for y in range(0, BODY_END, 10)]))
    x0r, x1r = int(cx_raw - 230), int(cx_raw + 230)
    col, mw = down(a[:BODY_END, x0r:x1r], main[:BODY_END, x0r:x1r], scale)
    n = col.shape[0]; L = max(4, int(round(SEAM * n))); P = n - L
    Sm = mw[:P].copy(); Sc = col[:P] * mw[:P, :, None]
    for y in range(L):
        w = y / L
        Sm[y] = w * mw[y] + (1 - w) * mw[y + P]
        Sc[y] = w * mw[y, :, None] * col[y] + (1 - w) * mw[y + P, :, None] * col[y + P]
    Sc = Sc / np.maximum(Sm, 1e-6)[..., None]
    sm = Sm > 0.5
    idx = np.full(sm.shape, -1)
    idx[sm] = nearest(Sc[sm], pal)
    up, dn = np.roll(sm, 1, 0), np.roll(sm, -1, 0)                              # contour 1 px (bande périodique)
    lf = np.pad(sm, ((0, 0), (1, 0)))[:, :-1]; rt = np.pad(sm, ((0, 0), (0, 1)))[:, 1:]
    edge = sm & ~(up & dn & lf & rt)
    idx[edge] = outline
    body_cx = (cx_raw - x0r) * scale
    half = float(np.median(sm.sum(1))) / 2
    # couronne
    c0, c1 = CROWN_X if not mirror else (Wr - CROWN_X[1], Wr - CROWN_X[0])
    ccol, cmw = down(a[CROWN_TOP:, c0:c1], main[CROWN_TOP:, c0:c1], scale)
    cm = cmw > 0.5
    cidx = np.full(cm.shape, -1); cidx[cm] = nearest(ccol[cm], pal)
    mouth_r = (MOUTH_ROW - CROWN_TOP) * scale
    ccx = (cx_raw - c0) * scale
    yy, xx = np.mgrid[:cm.shape[0], :cm.shape[1]]
    chan = (yy < mouth_r - 4) & (np.abs(xx - ccx) < half - 1)                    # canal laissé au corps qui monte
    cidx[chan] = -1
    ang = np.arctan2(yy - mouth_r, xx - ccx)                                     # sous la bouche : le brut est coupé net
    rx = 0.46 * cm.shape[1] * (1 + 0.07 * np.sin(7 * ang) + 0.04 * np.sin(13 * ang + 1))    # en bas -> ellipse irrégulière
    ry = max(6.0, 0.7 * (cm.shape[0] - mouth_r)) * (1 + 0.1 * np.sin(9 * ang + 2))
    below = (yy > mouth_r) & (((xx - ccx) / rx) ** 2 + ((yy - mouth_r) / ry) ** 2 > 1)
    cidx[below] = -1
    # gouttes
    dsp = []
    for d in drops:
        ys, xs = np.nonzero(d)
        y0, y1, xa, xb = ys.min(), ys.max() + 1, xs.min(), xs.max() + 1
        dc, dm = down(a[y0:y1, xa:xb], d[y0:y1, xa:xb], scale)
        dmb = dm > 0.35
        if not dmb.any():
            continue
        di = np.full(dmb.shape, -1); di[dmb] = nearest(dc[dmb], pal)
        dsp.append({'idx': di, 'dx': (xs.mean() - cx_raw) * scale, 'dy': (ys.mean() - MOUTH_ROW) * scale})
    out = {'strip': idx, 'P': P, 'L': L, 'body_cx': body_cx, 'half': half, 'crown': cidx, 'crown_cx': ccx, 'mouth_r': mouth_r,
           'drops': dsp}
    _CACHE[key] = out
    return out


def shift_of(u, P):
    return int(round(P * (u - SURGE_A * np.sin(4 * np.pi * u) / (4 * np.pi)))) % P


def column_phase(t, H, W, c, visible):
    """Indices de palette plein cadre (-1 = vide) de la colonne c à la phase t."""
    pal, _ = palette(); K = len(pal)
    pr = prepare(c['echelle'], c.get('miroir', False))
    u = ((t - c['decalage']) % PHASES) / PHASES
    out = np.full((H, W), -1)
    x0, yb = c['x'], c['y']
    strip, P = pr['strip'], pr['P']
    sh = shift_of(u, P) + c['graine'] * 37
    sw = strip.shape[1]; ox = int(round(x0 - pr['body_cx']))
    for y in range(0, yb + 1):
        row = strip[(y + sh) % P]
        xs = np.arange(sw) + ox; ok = (row >= 0) & (xs >= 0) & (xs < W)
        out[y, xs[ok]] = row[ok]
    # couronne : ancrée sur la bouche, bouillonnement par rang de luminance
    cr = pr['crown']; ch, cw = cr.shape
    oy = int(round(yb - pr['mouth_r'])); oxc = int(round(x0 - pr['crown_cx']))
    yy, xx = np.mgrid[:ch, :cw]
    ang = np.arctan2(yy - pr['mouth_r'], xx - pr['crown_cx']); rad = np.hypot(yy - pr['mouth_r'], xx - pr['crown_cx'])
    wave = np.round(1.6 * np.sin(2 * np.pi * 2 * u - 0.18 * rad + 3 * ang + c['graine'])).astype(int)
    bright = cr >= K // 2
    cidx = np.where(bright, np.clip(cr + wave, K // 2, K - 1), cr)
    Y, X = yy + oy, xx + oxc
    inside = (cr >= 0) & (Y >= 0) & (Y < H) & (X >= 0) & (X < W)
    Yc, Xc = np.clip(Y, 0, H - 1), np.clip(X, 0, W - 1)
    allowed = visible[Yc, Xc] | (out[Yc, Xc] >= 0)                                # lac libre, ou devant son propre corps
    m = inside & allowed
    out[Y[m], X[m]] = cidx[m]
    # gouttes : paraboles depuis la bouche
    rng = np.random.default_rng(c['graine'] * 31 + 5)
    for j, d in enumerate(pr['drops']):
        ph = rng.random(); side = 1 if d['dx'] >= 0 else -1
        reach = abs(d['dx']) * 1.1 + 6; h0 = 40 + 90 * rng.random() * c['echelle'] / 0.3
        f = (u * DROP_FLIGHTS + ph) % 1
        x = x0 + side * reach * f; y = yb - 4 * h0 * f * (1 - f)
        di = d['idx']; dh, dw = di.shape
        Y0, X0 = int(round(y - dh / 2)), int(round(x - dw / 2))
        for (yy_, xx_) in np.argwhere(di >= 0):
            Yp, Xp = Y0 + yy_, X0 + xx_
            if 0 <= Yp < H and 0 <= Xp < W and visible[Yp, Xp]:
                out[Yp, Xp] = di[yy_, xx_]
    return out


def column_frames(H, W, cols, visible):
    """PHASES calques RGBA ; les colonnes de devant (bouche plus au sud) recouvrent celles de derrière."""
    pal, _ = palette()
    order = sorted(cols, key=lambda c: c['y'])
    frames = []
    for t in range(PHASES):
        e = np.zeros((H, W, 4), 'uint8')
        for c in order:
            idx = column_phase(t, H, W, c, visible)
            m = idx >= 0
            e[m, :3] = pal[idx[m]]; e[m, 3] = 255
        frames.append(e)
    return frames
