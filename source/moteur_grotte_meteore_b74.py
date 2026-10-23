#!/usr/bin/env python3
"""Moteur partagé de la Grotte Météore — Biome Deoxys (`GME1` & `GMA1`, `b74` PMD Red).

Principes stricts :
1. **Palette identitaire Deoxys + `b74_meteor_cave_deoxys.png` sans aucun noir (`max >= 92`)** :
   - Plaques et strates minérales **Vermeil / Corail Deoxys** (`#F0583C`, `#FF7654`, `#CC3A34`),
   - Formations cristallines & noyau **Turquoise / Cyan Deoxys** (`#1CA8B8`, `#2CE4D4`, `#84FFF2`),
   - Roche spatiale & dalles **Violet-Indigo Royal Deoxys / `b74`** (`#4F17C7`, `#6E2EE0`, `#381690`, `#FF27D7`).
2. **Cristaux `100 %` STATIQUES (`poses = 1`)** :
   - Sur `GME1` comme sur `GMA1`, la couche `08` des cristaux solides est strictement fixe (`1` pose unique).
3. **Vrai fond Bleu Nuit Profond de l'Espace, `220+` Étoiles & `6` Étoiles Filantes (`00` & `01`, `24` poses)** :
   - Ciel spatial bleu nuit profond sans damier + voiles nébulaires + voûte étoilée scintillante + étoiles filantes.
4. **Animations `MULTICALQUE` `24 × 5 = 120` ticks** :
   - `GME1` : énergie plasma turquoise/corail pulsant dans les fissures profondes de la météorite brisée (`07`)
     + `10` fragments entiers de météorite Deoxys en lévitation (`09` `Top`).
   - `GMA1` : onde psionique `b74canm` turquoise/corail/magenta depuis l'orbe central de Deoxys (`07`)
     + `10` météorites entières en lévitation (`09` `Top`).
"""

from __future__ import annotations

from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[1]

B74_SPACE_MIDNIGHT = np.array([7, 14, 58], dtype=np.uint8)
B74_SLAB_INDIGO = np.array([79, 23, 199], dtype=np.uint8)
B74_GROOVE_BLUE = np.array([38, 16, 224], dtype=np.uint8)
DEOXYS_CORAL_MAIN = np.array([240, 88, 60], dtype=np.uint8)
DEOXYS_CORAL_LIGHT = np.array([255, 122, 86], dtype=np.uint8)
DEOXYS_CORAL_DEEP = np.array([196, 52, 56], dtype=np.uint8)
DEOXYS_TEAL_DARK = np.array([26, 158, 178], dtype=np.uint8)
DEOXYS_TEAL_MAIN = np.array([44, 228, 212], dtype=np.uint8)
DEOXYS_TEAL_GLOW = np.array([132, 252, 240], dtype=np.uint8)
B74_NEON_PSI = np.array([255, 48, 208], dtype=np.uint8)


def load_clean_meteor_raw(raw_path: Path, w: int, h: int) -> Tuple[np.ndarray, np.ndarray]:
    """Extrait proprement tout décor sur fond vert pur `#00FF00` tout en préservant `100 %` des cristaux
    turquoise/cyan de Deoxys (`G - max(R, B) >= 82` pour le fond `#00FF00` et son halo AA, remplacé sur
    le bord interne par la couleur rocheuse/cristalline intérieure la plus proche)."""
    im = Image.open(raw_path).convert("RGB")
    rgb = np.asarray(im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()
    r = rgb[:, :, 0].astype(np.int16)
    g = rgb[:, :, 1].astype(np.int16)
    b = rgb[:, :, 2].astype(np.int16)

    # Le vert chroma `#00FF00` a `G >> max(R, B)` alors que le turquoise Deoxys a `B >= G - 45` !
    green_excess = g - np.maximum(r, b)
    is_bg = green_excess >= 92
    fg = ~is_bg

    # Décontamination du liseré d'anti-aliasing vert sur 2 px de bordure externe (`green_excess >= 42`)
    fringe = fg & (green_excess >= 42)
    pure_fg = fg & (~fringe)
    if np.any(fringe) and np.any(pure_fg):
        _, idx = ndimage.distance_transform_edt(~pure_fg, return_indices=True)
        rgb[fringe] = rgb[idx[0][fringe], idx[1][fringe]]

    return rgb, fg


def build_deoxys_b74_palette(ref_png: Path, raw_rgb: np.ndarray, fg_mask: np.ndarray) -> np.ndarray:
    """Construit la palette pixel-art unifiée **Deoxys + `b74`** sans aucun ton noir (`max >= 92`) ni
    vert pur (`G - max(R, B) < 42`)."""
    ref_arr = np.asarray(Image.open(ref_png).convert("RGB"), dtype=np.uint8)
    u_ref, c_ref = np.unique(ref_arr.reshape(-1, 3), axis=0, return_counts=True)
    pal_ref = u_ref[np.argsort(-c_ref)]
    pal_ref = pal_ref[(pal_ref.max(axis=1) >= 95) & ~((pal_ref[:, 0] == 0) & (pal_ref[:, 1] == 0))]

    fg_px = raw_rgb[fg_mask]
    bright_fg = fg_px[fg_px.max(axis=1) >= 105]
    if bright_fg.size > 0:
        # Sous-échantillonnage rapide et représentatif des vraies teintes Deoxys du brut
        step = max(1, len(bright_fg) // 24000)
        q_bin = (bright_fg[::step] // 8) * 8 + 4
        u_raw, c_raw = np.unique(q_bin.astype(np.uint8), axis=0, return_counts=True)
        pal_raw = u_raw[np.argsort(-c_raw)[:56]]
    else:
        pal_raw = np.zeros((0, 3), dtype=np.uint8)

    deoxys_anchors = np.array(
        [
            # Contours et roche violet-indigo spatiale Deoxys (zéro noir !)
            [52, 18, 138],
            [68, 26, 168],
            [86, 38, 196],
            [108, 56, 218],
            [132, 78, 234],
            [79, 23, 199],
            [38, 16, 224],
            # Vermeil / Corail / Cramoisi Deoxys
            [168, 38, 58],
            [198, 52, 54],
            [224, 68, 56],
            [240, 88, 60],
            [252, 110, 76],
            [255, 136, 98],
            [255, 166, 128],
            # Turquoise / Teal / Mer-d'écume Deoxys (cristaux fixes + noyau)
            [20, 126, 156],
            [26, 158, 178],
            [36, 196, 198],
            [44, 228, 212],
            [84, 244, 228],
            [142, 252, 242],
            [208, 255, 250],
            # Magenta psionique `b74`
            [167, 15, 183],
            [199, 0, 151],
            [255, 39, 215],
        ],
        dtype=np.uint8,
    )
    pal = np.unique(np.vstack([pal_ref, pal_raw, deoxys_anchors]), axis=0).astype(np.uint8)
    g_ex = pal[:, 1].astype(int) - np.maximum(pal[:, 0].astype(int), pal[:, 2].astype(int))
    valid = (pal.max(axis=1) >= 92) & (g_ex < 42)
    return pal[valid]


def lift_dark_rock_shadows_to_deoxys(
    raw_rgb: np.ndarray,
    fg_mask: np.ndarray,
    exclude_mask: np.ndarray | None = None,
) -> np.ndarray:
    """Supprime `100 %` des contours et ombres noirs sur les roches en les remplaçant par des contours
    violet-indigo Deoxys (`[54, 18, 142]`) et des facettes minérales indigo/prune/corail Deoxys."""
    out = raw_rgb.copy()
    h, w, _ = out.shape
    work_fg = fg_mask & (~exclude_mask) if exclude_mask is not None else fg_mask

    mx = out.max(axis=2)
    very_dark = work_fg & (mx < 96)
    if np.any(very_dark):
        dist = ndimage.distance_transform_edt(very_dark)
        thin_outline = very_dark & (dist <= 2.4)
        thick_shadow = very_dark & (dist > 2.4)
        out[thin_outline] = np.array([54, 18, 142], dtype=np.uint8)

        if np.any(thick_shadow):
            step = max(8, int(round(15 * w / 768.0)))
            rng = np.random.default_rng(38674)
            gy = np.arange(step // 2, h, step)
            gx = np.arange(step // 2, w, step)
            seeds_y, seeds_x, seed_tone = [], [], []
            for iy, sy0 in enumerate(gy):
                for ix, sx0 in enumerate(gx):
                    seeds_y.append(int(np.clip(sy0 + rng.integers(-step // 3, step // 3 + 1), 0, h - 1)))
                    seeds_x.append(int(np.clip(sx0 + rng.integers(-step // 3, step // 3 + 1), 0, w - 1)))
                    seed_tone.append((iy * 5 + ix * 11 + int(rng.integers(0, 4))) % 4)
            seed_map = np.ones((h, w), dtype=bool)
            id_grid = np.zeros((h, w), dtype=np.int32)
            for idx_s, (sy0, sx0) in enumerate(zip(seeds_y, seeds_x)):
                seed_map[sy0, sx0] = False
                id_grid[sy0, sx0] = idx_s
            _, nearest_idx = ndimage.distance_transform_edt(seed_map, return_indices=True)
            cell_id = id_grid[nearest_idx[0], nearest_idx[1]]
            edge_seam = (cell_id != np.roll(cell_id, 1, axis=1)) | (cell_id != np.roll(cell_id, 1, axis=0))
            facet_shades = np.array(
                [
                    [78, 32, 178],   # indigo spatial Deoxys
                    [104, 44, 196],  # améthyste Deoxys
                    [168, 42, 62],   # cramoisi-corail ombré Deoxys
                    [92, 24, 162],   # prune royale b74
                ],
                dtype=np.uint8,
            )
            mapped = facet_shades[np.array(seed_tone, dtype=np.int32)[cell_id]]
            out[thick_shadow] = mapped[thick_shadow]
            out[thick_shadow & edge_seam] = np.array([56, 20, 146], dtype=np.uint8)

    mid_dark = work_fg & (out.max(axis=2) < 96)
    if np.any(mid_dark):
        out[mid_dark] = np.array([68, 26, 168], dtype=np.uint8)
    return out


def _draw_shooting_star(
    canvas: np.ndarray,
    hx: int,
    hy: int,
    dx: float,
    dy: float,
    tail_len: int,
    sparkle_seed: int,
) -> None:
    """Dessine une étoile filante pixel-art nette (tête diamant + traînée ionisée cyan/saphir)."""
    h, w, _ = canvas.shape
    norm = float(np.hypot(dx, dy)) or 1.0
    ux, uy = dx / norm, dy / norm

    c_head = np.array([245, 248, 255, 255], dtype=np.uint8)
    c_cyan = np.array([92, 236, 246, 255], dtype=np.uint8)
    c_blue = np.array([68, 142, 250, 255], dtype=np.uint8)
    c_indigo = np.array([38, 78, 196, 255], dtype=np.uint8)
    c_wake = np.array([22, 44, 136, 255], dtype=np.uint8)

    for s in range(tail_len, 0, -1):
        px = int(round(hx - ux * s))
        py = int(round(hy - uy * s))
        frac = s / float(max(1, tail_len))
        if not (0 <= px < w and 0 <= py < h):
            continue
        if frac < 0.18:
            col = c_head if frac < 0.07 else c_cyan
            for ox, oy in ((0, 0), (0, 1), (1, 0)):
                if 0 <= px + ox < w and 0 <= py + oy < h:
                    canvas[py + oy, px + ox] = col
        elif frac < 0.45:
            canvas[py, px] = c_blue
            if s % 2 == 0 and 0 <= py + 1 < h:
                canvas[py + 1, px] = c_indigo
        elif frac < 0.75:
            canvas[py, px] = c_indigo
        elif s % 2 == 0:
            canvas[py, px] = c_wake

    for k in (5, 11, 18, 26):
        if k < tail_len:
            sx = int(round(hx - ux * k + ((k + sparkle_seed) % 3 - 1)))
            sy = int(round(hy - uy * k + ((k * 2 + sparkle_seed) % 3 - 1)))
            if 0 <= sx < w and 0 <= sy < h:
                canvas[sy, sx] = c_cyan if k < 14 else c_blue

    for d in range(-2, 3):
        if 0 <= hx + d < w and 0 <= hy < h:
            canvas[hy, hx + d] = c_head if abs(d) <= 1 else c_cyan
        if 0 <= hx < w and 0 <= hy + d < h:
            canvas[hy + d, hx] = c_head if abs(d) <= 1 else c_cyan
    for ox, oy in ((-1, -1), (-1, 1), (1, -1), (1, 1)):
        if 0 <= hx + ox < w and 0 <= hy + oy < h:
            canvas[hy + oy, hx + ox] = c_cyan


def build_b74_cosmic_space_layers(
    w: int,
    h: int,
    n_frames: int = 24,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit le ciel spatial **Bleu Nuit Profond** (`00`) + **`220` étoiles lointaines** +
    **`34` étoiles à aigrettes & `6` étoiles filantes animées** (`01`, `24` poses @ `5` ticks)."""
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    nx = (xx - 0.5 * w) / (0.5 * w)
    ny = (yy - 0.5 * h) / (0.5 * h)
    rn = np.hypot(nx, ny)
    wave1 = 0.14 * np.sin(3.1 * nx + 2.2 * ny) + 0.08 * np.cos(5.3 * nx - 3.7 * ny)
    neb_field = rn - wave1

    base_space = np.empty((h, w, 3), dtype=np.uint8)
    base_space[:, :] = np.array([12, 22, 92], dtype=np.uint8)
    base_space[neb_field > 0.84] = np.array([9, 17, 74], dtype=np.uint8)
    base_space[neb_field > 1.02] = np.array([7, 13, 56], dtype=np.uint8)
    base_space[neb_field > 1.18] = np.array([5, 10, 42], dtype=np.uint8)

    ribbon_a = (np.abs((ny - 0.55 * nx - 0.18 * np.sin(4.0 * nx)) + 0.28) < 0.075) & (rn > 0.58)
    ribbon_b = (np.abs((ny + 0.48 * nx + 0.15 * np.cos(3.6 * ny)) - 0.34) < 0.068) & (rn > 0.62)
    base_space[ribbon_a] = np.array([18, 42, 118], dtype=np.uint8)
    base_space[ribbon_b] = np.array([34, 26, 114], dtype=np.uint8)

    bg_stars = []
    for i in range(220):
        u2, f2, n2 = 0.0, 0.5, i + 1
        while n2 > 0:
            u2 += f2 * (n2 % 2)
            n2 //= 2
            f2 *= 0.5
        u3, f3, n3 = 0.0, 1.0 / 3.0, i + 1
        while n3 > 0:
            u3 += f3 * (n3 % 3)
            n3 //= 3
            f3 /= 3.0
        px = min(w - 2, max(1, int(u2 * (w - 2))))
        py = min(h - 2, max(1, int(u3 * (h - 2))))
        bg_stars.append((px, py, (i * 7) % n_frames, i % 5))

    star_palette = [
        np.array([238, 245, 255], dtype=np.uint8),
        np.array([96, 232, 236], dtype=np.uint8),   # éclat turquoise Deoxys subtil dans le ciel !
        np.array([96, 158, 255], dtype=np.uint8),
        np.array([255, 138, 112], dtype=np.uint8),  # étoile orangée-corail lointaine Deoxys !
        np.array([186, 174, 255], dtype=np.uint8),
    ]
    star_dim = np.array([58, 96, 196], dtype=np.uint8)

    frames_00: List[Image.Image] = []
    for t in range(n_frames):
        arr = np.concatenate([base_space.copy(), np.full((h, w, 1), 255, dtype=np.uint8)], axis=2)
        for idx_s, (px, py, ph, c_idx) in enumerate(bg_stars):
            sv = np.sin(2.0 * np.pi * ((t + ph) / float(n_frames)))
            col = star_palette[c_idx]
            if sv > -0.35:
                arr[py, px, :3] = col if sv > 0.25 else star_dim
                if idx_s % 4 == 0 and sv > 0.65 and px + 1 < w:
                    arr[py, px + 1, :3] = star_dim
            else:
                arr[py, px, :3] = np.array([34, 62, 148], dtype=np.uint8)
        frames_00.append(Image.fromarray(arr, mode="RGBA"))

    hero_stars = [
        (0.055, 0.085, 0, True), (0.145, 0.065, 5, False), (0.235, 0.115, 11, True),
        (0.085, 0.215, 17, False), (0.175, 0.195, 3, True), (0.042, 0.355, 9, True),
        (0.118, 0.445, 15, False), (0.062, 0.565, 21, True), (0.152, 0.655, 2, False),
        (0.048, 0.745, 8, True), (0.132, 0.835, 14, True), (0.228, 0.895, 20, False),
        (0.075, 0.935, 6, False), (0.315, 0.925, 12, True), (0.285, 0.055, 18, False),
        (0.715, 0.058, 4, False), (0.785, 0.105, 10, True), (0.875, 0.072, 16, False),
        (0.945, 0.128, 22, True), (0.835, 0.205, 1, True), (0.925, 0.265, 7, False),
        (0.958, 0.385, 13, True), (0.885, 0.465, 19, False), (0.942, 0.575, 3, True),
        (0.862, 0.665, 9, False), (0.952, 0.735, 15, True), (0.885, 0.835, 21, True),
        (0.778, 0.905, 5, False), (0.928, 0.935, 11, True), (0.688, 0.932, 17, False),
        (0.032, 0.155, 13, False), (0.968, 0.215, 20, False), (0.035, 0.645, 4, False),
        (0.965, 0.825, 16, False),
    ]
    c_white = np.array([244, 248, 255], dtype=np.uint8)
    c_cyan = np.array([92, 232, 242], dtype=np.uint8)
    c_sapphire = np.array([68, 138, 248], dtype=np.uint8)
    c_diag = np.array([168, 196, 255], dtype=np.uint8)

    shooting_stars = [
        (0.215, 0.055, 0.045, 0.235, 21, 8),
        (0.955, 0.145, 0.785, 0.335, 23, 8),
        (0.195, 0.565, 0.035, 0.755, 4, 8),
        (0.965, 0.545, 0.795, 0.735, 9, 8),
        (0.245, 0.735, 0.075, 0.925, 11, 8),
        (0.935, 0.065, 0.765, 0.245, 15, 8),
    ]

    frames_01: List[Image.Image] = []
    tail_base = max(14, int(round(34 * w / 768.0)))
    for t in range(n_frames):
        st = np.zeros((h, w, 4), dtype=np.uint8)
        for fx, fy, ph, major in hero_stars:
            cx, cy = int(w * fx), int(h * fy)
            sv = np.sin(2.0 * np.pi * ((t + ph) / float(n_frames)))
            arm_max = 3 if (major and sv > 0.62) else (2 if sv > -0.05 else 1)
            for d in range(-arm_max, arm_max + 1):
                col = c_white if d == 0 else (c_cyan if abs(d) == 1 else c_sapphire)
                if 0 <= cx + d < w:
                    st[cy, cx + d, :3] = col
                    st[cy, cx + d, 3] = 255
                if 0 <= cy + d < h:
                    st[cy + d, cx, :3] = col
                    st[cy + d, cx, 3] = 255
            if arm_max >= 3:
                for ox, oy in ((-1, -1), (-1, 1), (1, -1), (1, 1)):
                    if 0 <= cx + ox < w and 0 <= cy + oy < h:
                        st[cy + oy, cx + ox, :3] = c_diag
                        st[cy + oy, cx + ox, 3] = 255

        for idx_sh, (sx0, sy0, sx1, sy1, t0, dur) in enumerate(shooting_stars):
            age = (t - t0) % n_frames
            if age < dur:
                u = (age + 0.5) / float(dur)
                hx = int(round(w * (sx0 + (sx1 - sx0) * u)))
                hy = int(round(h * (sy0 + (sy1 - sy0) * u)))
                cur_tail = max(10, int(round(tail_base * np.sin(np.pi * min(0.92, max(0.25, u))))))
                _draw_shooting_star(st, hx, hy, w * (sx1 - sx0), h * (sy1 - sy0), cur_tail, idx_sh + age)
        frames_01.append(Image.fromarray(st, mode="RGBA"))

    return frames_00, frames_01


def extract_whole_floating_meteorites(
    q_rgb: np.ndarray,
    fg_mask: np.ndarray,
    n_levitating: int = 10,
    n_frames: int = 24,
) -> Tuple[np.ndarray, Image.Image, List[Image.Image]]:
    """Sépare l'astéroïde central (`main_island`) de tous les fragments flottants entiers (`ndimage.label`,
    `0` fragment coupé !) et anime `n_levitating` fragments entiers en lévitation douce (`±2.5 px`)."""
    h, w = fg_mask.shape
    lbl, n_comp = ndimage.label(fg_mask)
    sizes = ndimage.sum(fg_mask, lbl, index=range(1, n_comp + 1))
    main_id = int(np.argmax(sizes)) + 1
    main_island = lbl == main_id

    margin_y = max(3, int(round(4 * h / 576.0)))
    cands = []
    other_ids = []
    for cid in range(1, n_comp + 1):
        if cid == main_id:
            continue
        m = lbl == cid
        ys, xs = np.where(m)
        if int(ys.min()) >= margin_y and int(ys.max()) < h - margin_y and int(m.sum()) >= 28:
            ang = float(np.arctan2(ys.mean() - 0.5 * h, xs.mean() - 0.5 * w))
            cands.append((ang, cid, m))
        else:
            other_ids.append(cid)

    cands.sort(key=lambda item: item[0])
    if len(cands) > n_levitating:
        step = len(cands) / float(n_levitating)
        chosen = [cands[int(round(i * step)) % len(cands)] for i in range(n_levitating)]
        chosen_ids = {c[1] for c in chosen}
        static_ids = other_ids + [c[1] for c in cands if c[1] not in chosen_ids]
    else:
        chosen = cands
        static_ids = other_ids

    static_mask = np.isin(lbl, static_ids) if static_ids else np.zeros((h, w), dtype=bool)
    static_arr = np.zeros((h, w, 4), dtype=np.uint8)
    static_arr[static_mask, :3] = q_rgb[static_mask]
    static_arr[static_mask, 3] = 255
    im_static_belt = Image.fromarray(static_arr, mode="RGBA")

    sprites = []
    for idx_m, (_, _, m) in enumerate(chosen):
        ys, xs = np.where(m)
        y0, y1 = int(ys.min()), int(ys.max()) + 1
        x0, x1 = int(xs.min()), int(xs.max()) + 1
        sub = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
        sm = m[y0:y1, x0:x1]
        sub[sm, :3] = q_rgb[y0:y1, x0:x1][sm]
        sub[sm, 3] = 255
        sprites.append((x0, y0, sub, idx_m * (n_frames // max(1, len(chosen)))))

    amp = max(1, int(round(2.5 * h / 576.0)))
    frames_lev: List[Image.Image] = []
    for t in range(n_frames):
        canvas = np.zeros((h, w, 4), dtype=np.uint8)
        for x0, y0, sub, ph in sprites:
            dy = int(round(amp * np.sin(2.0 * np.pi * ((t + ph) / float(n_frames)))))
            ny0 = max(0, min(h - sub.shape[0], y0 + dy))
            sm = sub[:, :, 3] > 0
            dst = canvas[ny0 : ny0 + sub.shape[0], x0 : x0 + sub.shape[1]]
            dst[sm] = sub[sm]
        frames_lev.append(Image.fromarray(canvas, mode="RGBA"))

    return main_island, im_static_belt, frames_lev


def build_deoxys_fissure_energy_frames(
    q_rgb: np.ndarray,
    fissure_teal_mask: np.ndarray,
    fissure_coral_mask: np.ndarray,
    center_xy: Tuple[float, float],
    n_frames: int = 24,
) -> List[Image.Image]:
    """Animation fluide `24` poses @ `5` ticks du plasma interne Deoxys (turquoise/écume & corail/vermeil)
    circulant au fond des failles de la météorite fracturée (`GME1`) — **sans toucher aux cristaux fixes**."""
    h, w, _ = q_rgb.shape
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    rad = np.hypot(xx - center_xy[0], yy - center_xy[1])
    band_w = max(8.0, 22.0 * (w / 768.0))
    ring_band = (rad / band_w).astype(np.int32)

    teal_shades = [
        np.array([152, 255, 244], dtype=np.uint8),
        np.array([72, 244, 228], dtype=np.uint8),
        np.array([38, 214, 206], dtype=np.uint8),
        np.array([26, 172, 186], dtype=np.uint8),
    ]
    coral_shades = [
        np.array([255, 152, 112], dtype=np.uint8),
        np.array([252, 108, 74], dtype=np.uint8),
        np.array([232, 76, 56], dtype=np.uint8),
        np.array([196, 52, 56], dtype=np.uint8),
    ]

    frames: List[Image.Image] = []
    active = fissure_teal_mask | fissure_coral_mask
    for t in range(n_frames):
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        if t == 0:
            fr[active, :3] = q_rgb[active]
            fr[active, 3] = 255
        else:
            ph = (ring_band - (t // 3)) % 4
            for k in range(4):
                mt = fissure_teal_mask & (ph == k)
                mc = fissure_coral_mask & (ph == k)
                fr[mt, :3] = teal_shades[k]
                fr[mt, 3] = 255
                fr[mc, :3] = coral_shades[k]
                fr[mc, 3] = 255
        frames.append(Image.fromarray(fr, mode="RGBA"))
    return frames


def build_b74_psychic_wave_frames(
    q_rgb: np.ndarray,
    circuit_mask: np.ndarray,
    core_mask: np.ndarray,
    center_xy: Tuple[float, float],
    n_frames: int = 24,
) -> List[Image.Image]:
    """Onde psionique radiale centrifuge `b74canm` aux couleurs ADN de Deoxys (turquoise, corail-vermeil &
    magenta psionique) sur les circuits gravés et l'anneau externe de l'orbe central (`24` poses @ `5` ticks)."""
    h, w, _ = q_rgb.shape
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    rad = np.hypot(xx - center_xy[0], yy - center_xy[1])
    band_w = max(8.0, 26.0 * (w / 768.0))
    ring_band = (rad / band_w).astype(np.int32)

    core_inner = ndimage.binary_erosion(core_mask, iterations=max(2, int(round(4 * w / 768.0))))
    core_rim = core_mask & (~core_inner)

    c_teal_flash = DEOXYS_TEAL_GLOW
    c_coral = DEOXYS_CORAL_LIGHT
    c_psi = B74_NEON_PSI
    c_rest = np.array([156, 38, 198], dtype=np.uint8)

    frames: List[Image.Image] = []
    for t in range(n_frames):
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        if t == 0:
            active = circuit_mask | core_mask
            fr[active, :3] = q_rgb[active]
            fr[active, 3] = 255
        else:
            ph = (ring_band - (t // 3)) % 4
            m0 = circuit_mask & (ph == 0)
            m1 = circuit_mask & (ph == 1)
            m2 = circuit_mask & (ph == 2)
            m3 = circuit_mask & (ph == 3)
            fr[m0, :3] = c_teal_flash
            fr[m0, 3] = 255
            fr[m1, :3] = c_coral
            fr[m1, 3] = 255
            fr[m2, :3] = c_psi
            fr[m2, 3] = 255
            fr[m3, :3] = c_rest
            fr[m3, 3] = 255

            fr[core_mask, :3] = q_rgb[core_mask]
            fr[core_mask, 3] = 255
            if t in (5, 6, 7, 8, 17, 18, 19, 20):
                fr[core_rim, :3] = c_teal_flash if t in (6, 7, 18, 19) else c_coral
        frames.append(Image.fromarray(fr, mode="RGBA"))
    return frames
