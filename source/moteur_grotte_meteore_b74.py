#!/usr/bin/env python3
"""Moteur partagé de la Grotte Météore (`GME1` & `GMA1`, *Meteor Cave — Deoxys*, `b74` PMD Red).

Principes stricts :
1. **Zéro noir sur les roches (`0` pixel sombre `< 72` sur les parois/météorites)** :
   - Toute ombre ou contour noir issu du brut est reconstruit en facettes minérales canoniques `b74`
     (prune royale `[111, 0, 143]`, améthyste `[135, 0, 159]`, magenta cramoisi `[159, 0, 127]`,
     contour indigo profond `[56, 12, 148]`), fidèles à `b74_meteor_cave_deoxys.png`.
   - Zéro pixel verdâtre (`G <= B - 6` partout).
2. **Fond spatial Bleu Nuit Profond, Voûte Étoilée Dense & Étoiles Filantes (`00` & `01`, `24` poses)** :
   - Dégradé pixel-art bleu nuit profond de l'espace (`[4, 9, 42]` -> `[9, 18, 68]` -> `[15, 28, 94]`)
     enrichi de voiles nébulaires saphir/indigo sans tramage damier ;
   - Plus de `220` étoiles lointaines et moyennes scintillant de façon asynchrone ;
   - `34` grandes étoiles à aigrettes en croix (`3×3` à `7×7`) + **`6` étoiles filantes pixel-art**
     traversant en diagonale le ciel étoilé avec traînée ionisée et poussière d'étoiles (`24` poses @ `5` ticks).
3. **Extraction par composantes connexes entières (`ndimage.label`) & Onde `b74canm`** :
   - Météorites flottantes entières sans aucune découpe (`03` fixes, `09` `Top` en lévitation `±2.5 px`) ;
   - Onde psionique radiale centrifuge `b74canm` sur les circuits néon et l'orbe central de Deoxys (`07`).
"""

from __future__ import annotations

from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[1]

B74_SPACE_MIDNIGHT = np.array([7, 14, 56], dtype=np.uint8)
B74_SLAB_INDIGO = np.array([79, 23, 199], dtype=np.uint8)
B74_GROOVE_BLUE = np.array([31, 0, 239], dtype=np.uint8)
B74_CORE_CYAN = np.array([31, 111, 239], dtype=np.uint8)
B74_NEON_PSI = np.array([255, 39, 215], dtype=np.uint8)


def build_b74_unified_palette(ref_png: Path, raw_rgb: np.ndarray, fg_mask: np.ndarray) -> np.ndarray:
    """Construit la palette pixel-art unifiée fidèle à `b74_meteor_cave_deoxys.png` :
    - ZÉRO couleur noire ou grisâtre (`max(R, G, B) >= 95` sur toute la palette roche/sol !) ;
    - ZÉRO ton verdâtre (`G <= 24` ou `G <= B - 6`)."""
    ref_arr = np.asarray(Image.open(ref_png).convert("RGB"), dtype=np.uint8)
    u_ref, c_ref = np.unique(ref_arr.reshape(-1, 3), axis=0, return_counts=True)
    pal_ref = u_ref[np.argsort(-c_ref)]
    # Conserver toutes les vraies teintes minérales `b74` hors noirs/ombres trop sombres
    pal_ref = pal_ref[(pal_ref.max(axis=1) >= 95) & ~((pal_ref[:, 0] == 0) & (pal_ref[:, 1] == 0))]

    fg_px = raw_rgb[fg_mask]
    # Uniquement les tons lumineux/cristallins du brut (aucun noir ni gris sombre !)
    bright_fg = fg_px[(fg_px.max(axis=1) >= 120) & ((fg_px[:, 2] >= 110) | (fg_px[:, 0] >= 145))]
    if bright_fg.size > 0:
        u_raw, c_raw = np.unique(bright_fg, axis=0, return_counts=True)
        pal_raw = u_raw[np.argsort(-c_raw)[:48]]
    else:
        pal_raw = np.zeros((0, 3), dtype=np.uint8)

    anchors = np.array(
        [
            [52, 12, 138],
            [63, 15, 167],
            [79, 23, 199],
            [31, 0, 239],
            [95, 12, 159],
            [111, 0, 143],
            [127, 0, 127],
            [135, 0, 159],
            [159, 0, 127],
            [167, 15, 183],
            [199, 0, 151],
            [255, 39, 215],
            [127, 63, 223],
            [31, 111, 239],
            [47, 159, 255],
            [95, 207, 255],
            [159, 232, 255],
            [242, 246, 255],
        ],
        dtype=np.uint8,
    )
    pal = np.unique(np.vstack([pal_ref, pal_raw, anchors]), axis=0).astype(np.uint8)
    valid = (pal.max(axis=1) >= 95) & (
        (pal[:, 1].astype(int) <= 24) | (pal[:, 1].astype(int) <= pal[:, 2].astype(int) - 6)
    )
    return pal[valid]


def load_clean_meteor_raw(raw_path: Path, w: int, h: int) -> Tuple[np.ndarray, np.ndarray]:
    """Charge le décor brut sur fond `#00FF00` à `(w, h)` en purifiant `100 %` du fond et de toute
    frange verte résiduelle (`G >= 28 & G > B - 8`)."""
    im = Image.open(raw_path).convert("RGB")
    rgb = np.asarray(im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()
    r = rgb[:, :, 0].astype(np.int16)
    g = rgb[:, :, 1].astype(np.int16)
    b = rgb[:, :, 2].astype(np.int16)
    is_bg = ((g >= 28) & (g > b - 8)) | ((g >= 170) & (r < 120) & (b < 120))
    return rgb, (~is_bg)


def lift_dark_rock_shadows_to_b74(
    raw_rgb: np.ndarray,
    fg_mask: np.ndarray,
    exclude_mask: np.ndarray | None = None,
) -> np.ndarray:
    """Élimine `100 %` des pixels noirs ou charbonneux sur toutes les roches et météorites :
    - Les contours fins (`dist <= 2.2 px`) deviennent un contour pixel-art indigo royal `[54, 12, 142]` ;
    - Les aplats d'ombre épais (`dist > 2.2 px`, ex. parois internes et dessous de falaises de `GME1`)
      sont facettisés par cellules de Voronoï cristallines en pans rocheux `b74` prune/améthyste/cramoisi
      (`[96, 12, 156]`, `[118, 8, 152]`, `[138, 12, 168]`, `[156, 10, 138]`) avec arêtes nettes `[58, 12, 146]` !
    """
    out = raw_rgb.copy()
    h, w, _ = out.shape
    work_fg = fg_mask & (~exclude_mask) if exclude_mask is not None else fg_mask

    mx = out.max(axis=2)
    very_dark = work_fg & (mx < 112)
    if np.any(very_dark):
        dist = ndimage.distance_transform_edt(very_dark)
        thin_outline = very_dark & (dist <= 2.2)
        thick_shadow = very_dark & (dist > 2.2)

        # 1. Contours fins rocheux -> indigo cosmique profond (jamais noir !)
        out[thin_outline] = np.array([54, 12, 142], dtype=np.uint8)

        # 2. Grandes zones d'ombre -> vraies facettes rocheuses polygonales de météorite `b74`
        if np.any(thick_shadow):
            step = max(8, int(round(15 * w / 768.0)))
            rng = np.random.default_rng(74028)
            gy = np.arange(step // 2, h, step)
            gx = np.arange(step // 2, w, step)
            seeds_y, seeds_x, seed_tone = [], [], []
            for iy, sy0 in enumerate(gy):
                for ix, sx0 in enumerate(gx):
                    jy = int(np.clip(sy0 + rng.integers(-step // 3, step // 3 + 1), 0, h - 1))
                    jx = int(np.clip(sx0 + rng.integers(-step // 3, step // 3 + 1), 0, w - 1))
                    seeds_y.append(jy)
                    seeds_x.append(jx)
                    seed_tone.append((iy * 7 + ix * 13 + int(rng.integers(0, 4))) % 4)

            seed_map = np.ones((h, w), dtype=bool)
            id_grid = np.zeros((h, w), dtype=np.int32)
            for idx_s, (sy0, sx0) in enumerate(zip(seeds_y, seeds_x)):
                seed_map[sy0, sx0] = False
                id_grid[sy0, sx0] = idx_s
            _, nearest_idx = ndimage.distance_transform_edt(seed_map, return_indices=True)
            cell_id = id_grid[nearest_idx[0], nearest_idx[1]]

            # Arête fine de 1 px entre deux facettes rocheuses adjacentes
            edge_seam = (cell_id != np.roll(cell_id, 1, axis=1)) | (cell_id != np.roll(cell_id, 1, axis=0))
            facet_shades = np.array(
                [
                    [96, 12, 156],   # violet royal ombré
                    [118, 6, 148],   # prune météoritique b74
                    [138, 12, 168],  # améthyste facettée b74
                    [152, 8, 134],   # cramoisi pourpre b74
                ],
                dtype=np.uint8,
            )
            tone_lut = np.array(seed_tone, dtype=np.int32)
            mapped = facet_shades[tone_lut[cell_id]]
            out[thick_shadow] = mapped[thick_shadow]
            out[thick_shadow & edge_seam] = np.array([62, 14, 158], dtype=np.uint8)

    # 3. Relèvement doux des tons sombres intermédiaires (`112 <= max < 138`) pour garantir zéro tache terne
    mid_dark = work_fg & (out.max(axis=2) < 118)
    if np.any(mid_dark):
        out[mid_dark, 0] = np.maximum(out[mid_dark, 0], 62)
        out[mid_dark, 2] = np.maximum(out[mid_dark, 2], 142)

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
    """Dessine une étoile filante pixel-art nette (tête diamant brillante + traînée cométaire dégradée
    saphir/cyan + poussière d'étoiles scintillante, `G <= B - 6` partout)."""
    h, w, _ = canvas.shape
    norm = float(np.hypot(dx, dy)) or 1.0
    ux, uy = dx / norm, dy / norm

    c_head = np.array([245, 248, 255, 255], dtype=np.uint8)
    c_cyan = np.array([132, 214, 255, 255], dtype=np.uint8)
    c_blue = np.array([68, 142, 250, 255], dtype=np.uint8)
    c_indigo = np.array([38, 78, 196, 255], dtype=np.uint8)
    c_wake = np.array([22, 44, 136, 255], dtype=np.uint8)

    # Traînée de la queue vers la tête pour que la tête recouvre toujours l'avant
    for s in range(tail_len, 0, -1):
        px = int(round(hx - ux * s))
        py = int(round(hy - uy * s))
        frac = s / float(max(1, tail_len))
        if not (0 <= px < w and 0 <= py < h):
            continue
        if frac < 0.18:
            col = c_head if frac < 0.07 else c_cyan
            # Épaisseur 2 px près de la tête
            for ox, oy in ((0, 0), (0, 1), (1, 0)):
                if 0 <= px + ox < w and 0 <= py + oy < h:
                    canvas[py + oy, px + ox] = col
        elif frac < 0.45:
            canvas[py, px] = c_blue
            if s % 2 == 0 and 0 <= py + 1 < h:
                canvas[py + 1, px] = c_indigo
        elif frac < 0.75:
            canvas[py, px] = c_indigo
        else:
            if s % 2 == 0:
                canvas[py, px] = c_wake

    # Poussière d'étoiles scintillante dans le sillage
    for k in (5, 11, 18, 26):
        if k < tail_len:
            sx = int(round(hx - ux * k + ((k + sparkle_seed) % 3 - 1)))
            sy = int(round(hy - uy * k + ((k * 2 + sparkle_seed) % 3 - 1)))
            if 0 <= sx < w and 0 <= sy < h:
                canvas[sy, sx] = c_cyan if k < 14 else c_blue

    # Tête étoilée en croix diamant (`5×5`) à `(hx, hy)`
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
    """Construit :
    - `00` : Vrai ciel **Bleu Nuit Profond de l'Espace** (`[5, 11, 46]` -> `[9, 18, 68]` -> `[15, 28, 96]`
      + rubans nébulaires saphir/indigo sans damier) + **`220` étoiles lointaines et moyennes** scintillantes ;
    - `01` : **`34` grandes étoiles brillantes à aigrettes** + **`6` étoiles filantes animées** traversant
      le ciel étoilé sur `24` poses @ `5` ticks (`120` ticks sans coupure).
    """
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    nx = (xx - 0.5 * w) / (0.5 * w)
    ny = (yy - 0.5 * h) / (0.5 * h)
    rn = np.hypot(nx, ny)

    # Rubans nébulaires diagonaux organiques sans aucun damier
    wave1 = 0.14 * np.sin(3.1 * nx + 2.2 * ny) + 0.08 * np.cos(5.3 * nx - 3.7 * ny)
    neb_field = rn - wave1

    base_space = np.empty((h, w, 3), dtype=np.uint8)
    base_space[:, :] = np.array([12, 22, 94], dtype=np.uint8)          # halo bleu nuit cosmique autour de l'astéroïde
    base_space[neb_field > 0.84] = np.array([9, 18, 76], dtype=np.uint8)
    base_space[neb_field > 1.02] = np.array([7, 14, 58], dtype=np.uint8)
    base_space[neb_field > 1.18] = np.array([5, 10, 44], dtype=np.uint8)  # bleu nuit abyssal des confins

    # Voiles de nébuleuse saphir & indigo cosmique dans les ailes gauche/droite
    ribbon_a = (np.abs((ny - 0.55 * nx - 0.18 * np.sin(4.0 * nx)) + 0.28) < 0.075) & (rn > 0.58)
    ribbon_b = (np.abs((ny + 0.48 * nx + 0.15 * np.cos(3.6 * ny)) - 0.34) < 0.068) & (rn > 0.62)
    base_space[ribbon_a] = np.array([20, 38, 118], dtype=np.uint8)
    base_space[ribbon_b] = np.array([26, 30, 116], dtype=np.uint8)

    # 220 étoiles de fond réparties sur toute la voûte spatiale (suite quasi-aléatoire déterministe)
    bg_stars = []
    for i in range(220):
        # Suite de Halton base 2 / base 3 pour couvrir uniformément tout le ciel `w × h`
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
        np.array([238, 245, 255], dtype=np.uint8),  # blanc stellaire pur
        np.array([142, 208, 255], dtype=np.uint8),  # bleu glacier
        np.array([96, 158, 255], dtype=np.uint8),   # saphir clair
        np.array([196, 178, 255], dtype=np.uint8),  # lavande céleste
        np.array([172, 222, 255], dtype=np.uint8),  # cyan stellaire
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
                # 1 étoile sur 4 forme un petit doublet `2 px` au pic d'éclat
                if idx_s % 4 == 0 and sv > 0.65 and px + 1 < w:
                    arr[py, px + 1, :3] = star_dim
            else:
                # Toujours légèrement visible comme poussière d'étoile lointaine
                arr[py, px, :3] = np.array([34, 62, 148], dtype=np.uint8)
        frames_00.append(Image.fromarray(arr, mode="RGBA"))

    # 34 grandes étoiles scintillantes en croix (`+`) dans tout le ciel spatial
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
    c_cyan = np.array([124, 210, 255], dtype=np.uint8)
    c_sapphire = np.array([68, 138, 248], dtype=np.uint8)
    c_diag = np.array([168, 196, 255], dtype=np.uint8)

    # 6 étoiles filantes échelonnées sur les 24 poses (dont 2 visibles dès pose 0, pose 6, pose 12, pose 18 !)
    # Chaque tuple : (x_start_frac, y_start_frac, x_end_frac, y_end_frac, t_start, duration)
    shooting_stars = [
        (0.215, 0.055, 0.045, 0.235, 21, 8),   # active sur poses 21,22,23,0,1,2,3,4 (visible pose 0 !)
        (0.955, 0.145, 0.785, 0.335, 23, 8),   # active sur poses 23,0,1,2,3,4,5,6 (visible pose 0 & 6 !)
        (0.195, 0.565, 0.035, 0.755, 4, 8),    # active sur poses 4..11 (visible pose 6 !)
        (0.965, 0.545, 0.795, 0.735, 9, 8),    # active sur poses 9..16 (visible pose 12 !)
        (0.245, 0.735, 0.075, 0.925, 11, 8),   # active sur poses 11..18 (visible pose 12 & 18 !)
        (0.935, 0.065, 0.765, 0.245, 15, 8),   # active sur poses 15..22 (visible pose 18 !)
    ]

    frames_01: List[Image.Image] = []
    tail_base = max(14, int(round(34 * w / 768.0)))
    for t in range(n_frames):
        st = np.zeros((h, w, 4), dtype=np.uint8)
        # 1. Grandes étoiles à aigrettes scintillantes
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

        # 2. Étoiles filantes cométaires traversant le cosmos
        for idx_sh, (sx0, sy0, sx1, sy1, t0, dur) in enumerate(shooting_stars):
            age = (t - t0) % n_frames
            if age < dur:
                u = (age + 0.5) / float(dur)
                hx = int(round(w * (sx0 + (sx1 - sx0) * u)))
                hy = int(round(h * (sy0 + (sy1 - sy0) * u)))
                dx = w * (sx1 - sx0)
                dy = h * (sy1 - sy0)
                cur_tail = max(10, int(round(tail_base * np.sin(np.pi * min(0.92, max(0.25, u))))))
                _draw_shooting_star(st, hx, hy, dx, dy, cur_tail, idx_sh + age)

        frames_01.append(Image.fromarray(st, mode="RGBA"))

    return frames_00, frames_01


def extract_whole_floating_meteorites(
    q_rgb: np.ndarray,
    fg_mask: np.ndarray,
    n_levitating: int = 8,
    n_frames: int = 24,
) -> Tuple[np.ndarray, Image.Image, List[Image.Image]]:
    """Sépare l'île principale (`main_island`) de toutes les météorites flottantes entières
    (`ndimage.label`, `0` cristal coupé !), place la ceinture fixe sur `im_static_belt` et fait
    léviter en apesanteur (`±2.5 px`) `n_levitating` météorites entières sur `frames_levitation`."""
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


def build_b74_psychic_wave_frames(
    q_rgb: np.ndarray,
    circuit_mask: np.ndarray,
    core_mask: np.ndarray,
    center_xy: Tuple[float, float],
    n_frames: int = 24,
) -> List[Image.Image]:
    """Onde psionique radiale centrifuge `b74canm` sur les circuits gravés et l'anneau externe de
    l'orbe central de Deoxys (`24` poses @ `5` ticks, `0` damier, couleurs natives `b74`)."""
    h, w, _ = q_rgb.shape
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    rad = np.hypot(xx - center_xy[0], yy - center_xy[1])
    band_w = max(8.0, 26.0 * (w / 768.0))
    ring_band = (rad / band_w).astype(np.int32)

    core_inner = ndimage.binary_erosion(core_mask, iterations=max(2, int(round(4 * w / 768.0))))
    core_rim = core_mask & (~core_inner)

    c_bright = B74_NEON_PSI
    c_flash = np.array([127, 215, 255], dtype=np.uint8)
    c_mid = np.array([183, 15, 191], dtype=np.uint8)
    c_rest = np.array([127, 39, 215], dtype=np.uint8)

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
            fr[m0, :3] = c_flash
            fr[m0, 3] = 255
            fr[m1, :3] = c_bright
            fr[m1, 3] = 255
            fr[m2, :3] = c_mid
            fr[m2, 3] = 255
            fr[m3, :3] = c_rest
            fr[m3, 3] = 255

            fr[core_mask, :3] = q_rgb[core_mask]
            fr[core_mask, 3] = 255
            if t in (5, 6, 7, 8, 17, 18, 19, 20):
                fr[core_rim, :3] = c_flash if t in (6, 7, 18, 19) else c_bright
        frames.append(Image.fromarray(fr, mode="RGBA"))
    return frames


def build_crystal_glint_frames(
    q_rgb: np.ndarray,
    cyan_glint_mask: np.ndarray,
    n_frames: int = 24,
) -> List[Image.Image]:
    """Scintillement prismatique doux des pointes cristallines cyan des remparts (`24` poses)."""
    h, w, _ = q_rgb.shape
    lbl, n_c = ndimage.label(cyan_glint_mask)
    c_peak = np.array([215, 244, 255], dtype=np.uint8)
    c_mid = np.array([95, 207, 255], dtype=np.uint8)
    frames: List[Image.Image] = []
    for t in range(n_frames):
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        fr[cyan_glint_mask, :3] = q_rgb[cyan_glint_mask]
        fr[cyan_glint_mask, 3] = 255
        if n_c > 0:
            active_ids = [cid for cid in range(1, n_c + 1) if ((t + cid * 3) % 12) in (0, 1, 2)]
            if active_ids:
                spark = np.isin(lbl, active_ids) & (q_rgb[:, :, 1] >= 185)
                fr[spark, :3] = c_peak if (t % 2 == 0) else c_mid
        frames.append(Image.fromarray(fr, mode="RGBA"))
    return frames
