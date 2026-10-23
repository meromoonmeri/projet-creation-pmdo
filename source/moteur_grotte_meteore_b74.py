#!/usr/bin/env python3
"""Moteur partagé de la Grotte Météore (`GME1` & `GMA1`, *Meteor Cave — Deoxys*, `b74` PMD Red).

Principes stricts :
1. **Palette GBA native `b74_meteor_cave_deoxys.png` + cristaux cyan** :
   - Vide spatial abyssal canonique `[0, 0, 95]` (`b74` exact) nuancé en bandes cosmiques nettes,
   - Dalle d'astéroïde indigo royal `[79, 23, 199]` & gravures outremer `[31, 0, 239]`,
   - Orbe central psionique céruléen de Deoxys `[31, 111, 239]`,
   - Circuits psioniques néon `[255, 39, 215]` & facettes météoritiques pourpres/améthyste/cyan ;
   - Zéro pixel vert résiduel (`G <= B - 6` partout hors noir profond de l'entrée de grotte).
2. **Extraction par composantes connexes entières (`ndimage.label`)** :
   - Chaque météorite flottante dans l'espace est extraite entière sans aucune découpe de cristal
     et flotte en apesanteur (`±2 px`, `24` poses @ `5` ticks = `120` ticks).
3. **Animation canonique `b74canm` d'onde psionique radiale (`24` poses @ `5` ticks = `120` ticks)** :
   - Onde centrifuge parcourant les circuits gravés du sol et du pont depuis l'orbe central de Deoxys.
"""

from __future__ import annotations

from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[1]

B74_SPACE_RGB = np.array([0, 0, 95], dtype=np.uint8)
B74_SLAB_INDIGO = np.array([79, 23, 199], dtype=np.uint8)
B74_GROOVE_BLUE = np.array([31, 0, 239], dtype=np.uint8)
B74_CORE_CYAN = np.array([31, 111, 239], dtype=np.uint8)
B74_NEON_PSI = np.array([255, 39, 215], dtype=np.uint8)


def build_b74_unified_palette(ref_png: Path, raw_rgb: np.ndarray, fg_mask: np.ndarray) -> np.ndarray:
    """Construit la palette pixel-art unifiée fidèle à `b74_meteor_cave_deoxys.png` sans aucun ton vert."""
    ref_arr = np.asarray(Image.open(ref_png).convert("RGB"), dtype=np.uint8)
    u_ref, c_ref = np.unique(ref_arr.reshape(-1, 3), axis=0, return_counts=True)
    pal_ref = u_ref[np.argsort(-c_ref)[:64]]

    fg_px = raw_rgb[fg_mask]
    u_raw, c_raw = np.unique(fg_px, axis=0, return_counts=True)
    pal_raw = u_raw[np.argsort(-c_raw)[:72]]

    anchors = np.array(
        [
            [0, 0, 95],
            [0, 0, 79],
            [8, 0, 63],
            [10, 4, 24],
            [18, 6, 38],
            [31, 0, 239],
            [79, 23, 199],
            [31, 111, 239],
            [47, 159, 255],
            [95, 207, 255],
            [159, 235, 255],
            [255, 39, 215],
            [199, 0, 151],
            [167, 15, 183],
            [127, 63, 223],
            [239, 247, 255],
        ],
        dtype=np.uint8,
    )
    pal = np.unique(np.vstack([pal_ref, pal_raw, anchors]), axis=0).astype(np.uint8)
    # Sécurité absolue : zéro pixel verdâtre dans la palette (G <= max(24, B - 6))
    valid = (pal[:, 1].astype(int) <= 24) | (pal[:, 1].astype(int) <= pal[:, 2].astype(int) - 6)
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


def build_b74_cosmic_space_layers(
    w: int,
    h: int,
    n_frames: int = 24,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit le fond spatial abyssal canonique de `b74` (`[0, 0, 95]` au centre, `[0, 0, 79]` aux
    marges) + les étoiles lointaines (`00`) et proches (`01`) scintillant sur `24` poses @ `5` ticks."""
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    rn = np.hypot((xx - 0.5 * w) / (0.55 * w), (yy - 0.5 * h) / (0.55 * h))
    base_space = np.empty((h, w, 3), dtype=np.uint8)
    base_space[:, :] = B74_SPACE_RGB
    outer_ring = rn > 1.02
    deep_corners = rn > 1.24
    base_space[outer_ring] = np.array([0, 0, 82], dtype=np.uint8)
    base_space[deep_corners] = np.array([4, 0, 68], dtype=np.uint8)

    distant_stars = [
        (0.05, 0.08, 1), (0.12, 0.22, 9), (0.07, 0.44, 17), (0.04, 0.72, 5),
        (0.14, 0.88, 13), (0.24, 0.06, 21), (0.76, 0.07, 4), (0.88, 0.19, 12),
        (0.94, 0.41, 20), (0.96, 0.69, 8), (0.86, 0.87, 16), (0.21, 0.93, 2),
        (0.79, 0.92, 11), (0.09, 0.60, 19), (0.91, 0.29, 6), (0.16, 0.12, 15),
    ]
    c_dim = np.array([79, 63, 207], dtype=np.uint8)
    c_mid = np.array([135, 167, 255], dtype=np.uint8)

    frames_00: List[Image.Image] = []
    for t in range(n_frames):
        arr = np.concatenate([base_space.copy(), np.full((h, w, 1), 255, dtype=np.uint8)], axis=2)
        for fx, fy, ph in distant_stars:
            px, py = int(w * fx), int(h * fy)
            sv = np.sin(2.0 * np.pi * ((t + ph) / float(n_frames)))
            if sv > 0.10:
                arr[py, px, :3] = c_mid if sv > 0.68 else c_dim
        frames_00.append(Image.fromarray(arr, mode="RGBA"))

    hero_stars = [
        (0.08, 0.14, 0, True),
        (0.18, 0.09, 7, False),
        (0.06, 0.33, 14, True),
        (0.13, 0.79, 20, True),
        (0.92, 0.13, 4, True),
        (0.83, 0.08, 11, False),
        (0.94, 0.54, 18, True),
        (0.87, 0.78, 2, True),
        (0.05, 0.89, 10, False),
        (0.95, 0.90, 16, False),
    ]
    c_white = np.array([239, 247, 255], dtype=np.uint8)
    c_cyan = np.array([95, 207, 255], dtype=np.uint8)
    c_lilac = np.array([199, 79, 239], dtype=np.uint8)

    frames_01: List[Image.Image] = []
    for t in range(n_frames):
        st = np.zeros((h, w, 4), dtype=np.uint8)
        for fx, fy, ph, major in hero_stars:
            cx, cy = int(w * fx), int(h * fy)
            sv = np.sin(2.0 * np.pi * ((t + ph) / float(n_frames)))
            if sv < -0.35:
                st[cy, cx, :3] = c_lilac
                st[cy, cx, 3] = 255
            elif sv < 0.35:
                st[cy, cx, :3] = c_cyan
                st[cy, cx, 3] = 255
            else:
                arm_max = 2 if (major and sv > 0.76) else 1
                for d in range(-arm_max, arm_max + 1):
                    if 0 <= cx + d < w:
                        st[cy, cx + d, :3] = c_white if d == 0 else (c_cyan if abs(d) == 1 else c_lilac)
                        st[cy, cx + d, 3] = 255
                    if 0 <= cy + d < h:
                        st[cy + d, cx, :3] = c_white if d == 0 else (c_cyan if abs(d) == 1 else c_lilac)
                        st[cy + d, cx, 3] = 255
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
    léviter en apesanteur (`±2 px`) `n_levitating` météorites entières sur `frames_levitation`."""
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
    c_peak = np.array([215, 247, 255], dtype=np.uint8)
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
