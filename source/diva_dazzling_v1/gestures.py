#!/usr/bin/env python3
"""Gestes de diva, dessinés pour chaque morphologie — aucun mouvement générique.

  * Lopunny : les deux pompons-mains s'ouvrent en éventail vers l'extérieur et vers
    le haut, tenue scintillante, puis révérence (buste incliné) et retour au repos.
  * Tsareena : les deux fleurs des hanches montent en arc jusqu'aux épaules,
    éclosion (pétales + éclat), ondulation de la robe, révérence de reine.
  * Mawile : les cornes-mâchoires s'écartent, claquent avec un éclat, la tête se
    renverse, puis tout revient au repos.

Chaque phase d'une direction repart de l'image native de cette direction. Les
régions déplacées sont sélectionnées par couleur native + bande latérale, jamais
par un rectangle arbitraire recouvrant le visage.
"""
from __future__ import annotations

import numpy as np

from diva import (MARKERS, Palette, Sprite, bloom, curve, ease, shift_region, sparkle)

# --- couleurs natives repères -------------------------------------------------
LOP_CREAM = (255, 247, 159)
TSA_YELLOW = (255, 231, 119)
MAW_STEEL = (127, 143, 151)


# --------------------------------------------------------------------------- régions
def comps(mask: np.ndarray) -> list[np.ndarray]:
    h, w = mask.shape
    seen = np.zeros((h, w), bool)
    out = []
    for y in range(h):
        for x in range(w):
            if mask[y, x] and not seen[y, x]:
                st = [(y, x)]
                seen[y, x] = True
                pix = []
                while st:
                    cy, cx = st.pop()
                    pix.append((cy, cx))
                    for dy in (-1, 0, 1):
                        for dx in (-1, 0, 1):
                            ny, nx = cy + dy, cx + dx
                            if 0 <= ny < h and 0 <= nx < w and mask[ny, nx] and not seen[ny, nx]:
                                seen[ny, nx] = True
                                st.append((ny, nx))
                m = np.zeros((h, w), bool)
                for cy, cx in pix:
                    m[cy, cx] = True
                out.append(m)
    return out


def dilate(mask: np.ndarray, n: int = 1) -> np.ndarray:
    out = mask.copy()
    for _ in range(n):
        g = out.copy()
        for dy in (-1, 0, 1):
            for dx in (-1, 0, 1):
                g |= np.roll(np.roll(out, dy, 0), dx, 1)
        out = g
    return out


def region(img: np.ndarray, colors: list[tuple[int, int, int]], band: tuple[int, int, int, int],
           outline: bool = True, grow: int = 1) -> np.ndarray:
    """Composantes natives de `colors` touchant la bande (x0, x1, y0, y1), + liseré."""
    h, w = img.shape[:2]
    colmask = np.zeros((h, w), bool)
    for c in colors:
        colmask |= np.all(img[:, :, :3] == np.array(c, np.uint8), axis=2) & (img[:, :, 3] > 0)
    x0, x1, y0, y1 = band
    bandmask = np.zeros((h, w), bool)
    bandmask[max(0, y0):min(h, y1 + 1), max(0, x0):min(w, x1 + 1)] = True
    keep = np.zeros((h, w), bool)
    for m in comps(colmask):
        if (m & bandmask).any() and m.sum() >= 3:
            keep |= m
    keep = dilate(keep, grow)
    if outline:
        dark = (img[:, :, 3] > 0) & (img[:, :, :3].astype(int).sum(axis=2) < 160)
        keep |= dilate(keep, 1) & dark
    return keep & (img[:, :, 3] > 0)


def bounds(img: np.ndarray) -> tuple[int, int, int, int]:
    ys, xs = np.nonzero(img[:, :, 3])
    return int(xs.min()), int(ys.min()), int(xs.max()), int(ys.max())


def move(img: np.ndarray, mask: np.ndarray, dx: int, dy: int) -> np.ndarray:
    """Déplace la région ; le vide laissé devient transparent (aucun pixel inventé)."""
    out = img.copy()
    src = img.copy()
    out[mask] = 0
    ys, xs = np.nonzero(mask)
    ty, tx = ys + dy, xs + dx
    keep = (ty >= 0) & (ty < img.shape[0]) & (tx >= 0) & (tx < img.shape[1])
    out[ty[keep], tx[keep]] = src[ys[keep], xs[keep]]
    return out


def arm(img: np.ndarray, pts: list[tuple[int, int]], pal: Palette) -> None:
    """Bras en polyline (épaule → coude → main), 1 px de pelage + contour sombre.

    Seuls des pixels transparents sont peints : aucune texture native n'est écrasée.
    Couleurs prises dans la palette native de l'espèce.
    """
    h, w = img.shape[:2]
    fur = pal.near((215, 191, 103))
    edge = pal.near((119, 63, 0))
    path: list[tuple[int, int]] = []
    for (x0, y0), (x1, y1) in zip(pts, pts[1:]):
        steps = max(abs(x1 - x0), abs(y1 - y0), 1)
        for i in range(steps + 1):
            t = i / steps
            path.append((int(round(x0 + (x1 - x0) * t)), int(round(y0 + (y1 - y0) * t))))
    drawn = []
    for x, y in path:
        if 0 <= x < w and 0 <= y < h and img[y, x, 3] == 0:
            img[y, x] = (*fur, 255)
            drawn.append((x, y))
    # liseré uniquement le long du bras réellement dessiné (pas de point orphelin)
    for x, y in drawn:
        for xx, yy in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= xx < w and 0 <= yy < h and img[yy, xx, 3] == 0:
                img[yy, xx] = (*edge, 255)


def move_markers(markers: dict[str, tuple[int, int]], masks: list[tuple[np.ndarray, int, int]]
                 ) -> dict[str, tuple[int, int]]:
    out = {}
    for k, (x, y) in markers.items():
        nx, ny = x, y
        for m, dx, dy in masks:
            if 0 <= y < m.shape[0] and 0 <= x < m.shape[1] and m[y, x]:
                nx, ny = x + dx, y + dy
        out[k] = (nx, ny)
    return out


def head_tilt(img: np.ndarray, markers: dict[str, tuple[int, int]], head_mask: np.ndarray,
              drop: int = 0, shear: float = 0.0) -> tuple[np.ndarray, dict]:
    """Inclinaison du buste : cisaille des rangées de tête + translation verticale."""
    out = shift_region(img, head_mask, drop)
    if shear:
        h, w = out.shape[:2]
        rows = np.nonzero(head_mask.any(axis=1))[0]
        base = int(rows.max()) if len(rows) else h - 1
        base += drop
        shifted = out.copy()
        for y in rows + drop:
            if not (0 <= y < h):
                continue
            off = int(round(shear * (y - base)))
            if off:
                shifted[y] = np.roll(out[y], off, axis=0)
                if off > 0:
                    shifted[y, :off] = 0
                else:
                    shifted[y, off:] = 0
        out = shifted
    mk = dict(markers)
    if "head" in mk:
        hx, hy = mk["head"]
        if 0 <= hy < head_mask.shape[0] and 0 <= hx < head_mask.shape[1] and head_mask[hy, hx]:
            mk["head"] = (hx, hy + drop)
        else:
            mk["head"] = (hx, hy + (drop if drop else 0))
    return out, mk


# --------------------------------------------------------------------------- Lopunny
def _bbox(mask: np.ndarray) -> tuple[int, int, int, int]:
    ys, xs = np.nonzero(mask)
    return int(xs.min()), int(ys.min()), int(xs.max()), int(ys.max())


def lopunny(sp: Sprite, d: int, f: int) -> tuple[np.ndarray, dict[str, tuple[int, int]]]:
    """« Salut aux pompons » : éventail des deux pompons-mains, tenue, révérence."""
    v = sp.views[d]
    img = v.img.copy()
    mk = dict(v.markers)
    x0, y0, x1, y1 = bounds(img)
    bx, by = mk.get("body", ((x0 + x1) // 2, y1))
    band_y0, band_y1 = by - 4, y1 - 5
    left = region(img, [LOP_CREAM], (x0, bx - 2, band_y0, band_y1))
    right = region(img, [LOP_CREAM], (bx + 2, x1, band_y0, band_y1))
    # courbes : montée 0→8, tenue 8→13, révérence 13→15, retour 16→18
    rise = curve(18, [(0, 0), (0.04, 0), (0.46, 1), (0.74, 1), (0.86, 0.2), (1, 0)])
    bow = curve(18, [(0, 0), (0.68, 0), (0.82, 1), (0.92, 0.85), (1, 0)])
    out = img.copy()
    up = int(round(-11 * rise[f]))
    profile = left.sum() == 0 or right.sum() == 0   # vues de profil : les deux pompons se touchent
    if profile:
        both = region(img, [LOP_CREAM], (x0, x1, band_y0, band_y1))
        left, right = both, np.zeros_like(both)
        lx0, ly0, lx1, ly1 = _bbox(both)
        rx0, ry0, rx1, ry1 = lx0, ly0, lx1, ly1
        dxl = dxr = 0
        out = move(img, both, 0, up)
    else:
        lx0, ly0, lx1, ly1 = _bbox(left)
        rx0, ry0, rx1, ry1 = _bbox(right)
        room = min(lx0 - x0 + 1, x1 - rx1 - 1, 6)      # marge disponible avant le bord
        outx = max(0, min(4, room)) * ease(rise[f])
        dxl = -int(round(outx))
        dxr = int(round(outx))
        out = move(img, left, dxl, up)
        out = move(out, right, dxr, up)
    # bras : épaule → coude → bord intérieur du pompon déplacé
    if rise[f] > 0.15 and not profile:
        lyc = (ly0 + ly1) // 2 + up + 2
        ryc = (ry0 + ry1) // 2 + up + 2
        # bras en L : sortie horizontale de l'épaule dans le vide, puis montée vers
        # le bord inférieur du pompon — le coude passe sous la main levée
        arm(out, [(bx - 3, by - 2), (lx1 + dxl - 2, by - 3), (lx1 + dxl - 2, lyc)], sp.pal)
        arm(out, [(bx + 3, by - 2), (rx0 + dxr + 2, by - 3), (rx0 + dxr + 2, ryc)], sp.pal)
    elif rise[f] > 0.15:
        lyc = (ly0 + ly1) // 2 + up
        arm(out, [(bx - 2, by - 2), (bx - 4, by - 4), (min(lx1, bx) - 1, lyc)], sp.pal)
    # révérence : oreilles et tête s'inclinent vers l'avant
    head_mask = np.zeros(img.shape[:2], bool)
    head_mask[y0:by - 1, x0:x1 + 1] = img[y0:by - 1, x0:x1 + 1, 3] > 0
    # on ne plie pas les pompons déjà levés
    head_mask &= ~left & ~right
    out, mk = head_tilt(out, mk, head_mask, drop=int(round(2 * bow[f])), shear=-0.05 * bow[f])
    # éclats au-dessus des pompons levés
    a = max(0.0, rise[f] - 0.5) * 2.0
    if a > 0:
        sparkle(out, max(1, min(out.shape[1] - 2, (lx0 + lx1) // 2 + dxl)), max(1, ly0 + up - 2), 3,
                sp.pal.near(LOP_CREAM), a)
        sparkle(out, max(1, min(out.shape[1] - 2, (rx0 + rx1) // 2 + dxr)), max(1, ry0 + up - 3), 3,
                sp.pal.near((255, 199, 215)), a * 0.9)
    mk = move_markers(mk, [(left, dxl, up), (right, dxr, up)])
    return out, mk


# --------------------------------------------------------------------------- Tsareena
def tsareena(sp: Sprite, d: int, f: int) -> tuple[np.ndarray, dict[str, tuple[int, int]]]:
    """« Éclosion royale » : les fleurs montent, éclosent, puis révérence de reine."""
    v = sp.views[d]
    img = v.img.copy()
    mk = dict(v.markers)
    x0, y0, x1, y1 = bounds(img)
    bx = mk.get("body", (img.shape[1] // 2, y1))[0]
    by = mk.get("body", (bx, y1))[1]
    left = region(img, [TSA_YELLOW], (x0, bx - 2, by, y1), grow=2)
    right = region(img, [TSA_YELLOW], (bx + 2, x1, by, y1), grow=2)
    rise = curve(18, [(0, 0), (0.06, 0), (0.5, 1), (0.72, 1), (0.9, 0.1), (1, 0)])
    bow = curve(18, [(0, 0), (0.55, 0), (0.74, 1), (0.88, 0.85), (1, 0)])
    sway = curve(18, [(0, 0), (0.12, 0), (0.3, 1), (0.5, -1), (0.7, 1), (0.9, 0), (1, 0)])
    lift = int(round(-12 * rise[f]))
    swingx = int(round(2 * sway[f]))
    dxl = -int(round(3 * rise[f])) + swingx
    dxr = int(round(3 * rise[f])) + swingx
    out = move(img, left, dxl, lift)
    out = move(out, right, dxr, lift)
    if rise[f] > 0.25:
        arm(out, [(bx - 4, by), (bx - 8, by + 2), (x0 + 1, by + lift + 4)], sp.pal)
        arm(out, [(bx + 4, by), (bx + 8, by + 2), (x1 - 1, by + lift + 4)], sp.pal)
    # robe : ondulation des rangées basses (la taille reste fixe)
    rows = np.arange(img.shape[0])
    robe = rows >= by + 3
    if abs(sway[f]) > 0.2:
        k = int(round(sway[f]))
        shifted = out.copy()
        for y in np.nonzero(robe)[0]:
            off = int(round(k * (y - by - 3) / max(1, y1 - by - 3) * 1.6))
            if off:
                shifted[y] = np.roll(out[y], off, axis=0)
                if off > 0:
                    shifted[y, :off] = 0
                else:
                    shifted[y, off:] = 0
        out = shifted
    head_mask = np.zeros(img.shape[:2], bool)
    head_mask[y0:by, x0:x1 + 1] = img[y0:by, x0:x1 + 1, 3] > 0
    out, mk = head_tilt(out, mk, head_mask, drop=int(round(2 * bow[f])))
    # éclosion : pétales et éclat autour des fleurs levées
    a = max(0.0, rise[f] - 0.45) * 1.9
    if a > 0:
        core = sp.pal.near((255, 231, 119))
        edge = sp.pal.near((193, 61, 92))
        bloom(out, max(1, x0 + 1), max(1, by + lift + 3), 2, (edge, core), a)
        bloom(out, min(out.shape[1] - 2, x1 - 1), max(1, by + lift + 2), 2, (edge, core), a)
        sparkle(out, bx, max(1, y0), 3, sp.pal.near((255, 255, 255)), max(0.0, a - 0.5))
    mk = move_markers(mk, [(left, dxl, lift), (right, dxr, lift)])
    return out, mk


# --------------------------------------------------------------------------- Mawile
def mawile(sp: Sprite, d: int, f: int) -> tuple[np.ndarray, dict[str, tuple[int, int]]]:
    """« Clac de la diva » : les cornes-mâchoires s'ouvrent, claquent, tête renversée."""
    v = sp.views[d]
    img = v.img.copy()
    mk = dict(v.markers)
    x0, y0, x1, y1 = bounds(img)
    bx = mk.get("body", (img.shape[1] // 2, y1))[0]
    by = mk.get("body", (bx, y1))[1]
    left = region(img, [MAW_STEEL], (x0, bx - 2, y0, by), grow=1)
    right = region(img, [MAW_STEEL], (bx + 2, x1, y0, by), grow=1)
    open_ = curve(18, [(0, 0), (0.08, 0), (0.45, 1), (0.58, 1), (0.66, 0.30), (0.8, 0.10), (1, 0)])
    tilt = curve(18, [(0, 0), (0.42, 0), (0.58, 1), (0.82, 1), (1, 0)])
    k = open_[f]
    dx = int(round(4 * k))
    dy = int(round(2 * abs(k)))
    out = move(img, left, -dx, dy)
    out = move(out, right, dx, dy)
    # le repère de tête de certaines vues tombe sur la corne gauche : il suit la mâchoire
    hx, hy = mk.get("head", (bx, by))
    if left[hy, hx] if (0 <= hy < left.shape[0] and 0 <= hx < left.shape[1]) else False:
        mk["head"] = (hx - dx, hy + dy)
    head_mask = np.zeros(img.shape[:2], bool)
    head_mask[y0:by, x0:x1 + 1] = img[y0:by, x0:x1 + 1, 3] > 0
    out, mk = head_tilt(out, mk, head_mask, drop=int(round(2 * tilt[f])), shear=0.05 * tilt[f])
    # clac : éclat entre les mâchoires
    snap = curve(18, [(0, 0), (0.45, 0), (0.56, 1), (0.68, 0.7), (0.8, 0.25), (1, 0)])
    if snap[f] > 0.05:
        sparkle(out, bx, max(1, by + 1), 3, sp.pal.near((255, 231, 159)), snap[f])
        sparkle(out, max(1, bx - 4), max(1, by + 2), 2, sp.pal.near((255, 255, 255)), snap[f] * 0.8)
        sparkle(out, min(out.shape[1] - 2, bx + 4), max(1, by + 2), 2, sp.pal.near((255, 255, 255)), snap[f] * 0.8)
    mk = move_markers(mk, [(left, -dx, dy), (right, dx, dy)])
    return out, mk


GESTURES = {"0428": lopunny, "0763": tsareena, "0303": mawile}
TITLES = {"0428": "Salut aux pompons", "0763": "Éclosion royale", "0303": "Clac de la diva"}
ANIM_ID = {"0428": "DivaFan", "0763": "DivaBloom", "0303": "DivaSnap"}


def render(sp: Sprite, n: int = 18) -> tuple[list[list[np.ndarray]], list[list[dict]]]:
    fn = GESTURES[sp.slot]
    frames, offsets = [], []
    for d in range(sp.dirs):
        fd, od = [], []
        for f in range(n):
            img, mk = fn(sp, d, f)
            fd.append(img)
            od.append(mk)
        frames.append(fd)
        offsets.append(od)
    return frames, offsets
