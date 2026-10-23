#!/usr/bin/env python3
"""Moteur partagé du Mont Lointain — Ho-Oh (`MLE1` & `MLS1`, *Mt. Faraway*, `b72` PMD Red).

Principes stricts :
1. **Palette GBA canonique `b72_mt_faraway_hooh.png` sans aucun noir ni magenta** :
   - Zénith bleu-cyan GBA `[143, 223, 231]` & brume d'horizon `[215, 255, 231]`,
   - Mer de nuages dorée/ivoire `[255, 255, 215]`, `[255, 247, 183]`, `[247, 247, 167]`, `[242, 212, 148]`,
   - Piliers karstiques grès-ocre `[207, 175, 127]` / `[183, 151, 111]` & calcaire sauge `[159, 159, 127]` /
     `[143, 143, 95]` avec contours olive-taupe GBA `[112, 108, 78]` (**zéro pixel noir** sur les roches !),
   - Fougères émeraude suspendues `[87, 119, 47]`, `[95, 135, 55]`, `[111, 143, 63]`.
2. **Animations `MULTICALQUE` `24 × 5 = 120` ticks** :
   - `01` Dérive douce des rubans de la mer de nuages dorée (`BG`, `24` poses @ `5` ticks),
   - `02` Irisation pastel de l'Arc-en-Ciel sacré de Ho-Oh dans le ciel cyan (`BG`, `24` poses @ `5` ticks),
   - `08` Respiration des volutes de brume dorée au pied des piliers karstiques (`BG`, `24` poses @ `5` ticks),
   - `09` Plumes et lueurs dorées sacrées de Ho-Oh s'élevant dans l'air pur (`Top`, `24` poses @ `5` ticks).
"""

from __future__ import annotations

from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[1]

B72_SKY_CYAN = np.array([143, 223, 231], dtype=np.uint8)
B72_SKY_MIST = np.array([215, 255, 231], dtype=np.uint8)
B72_CLOUD_LIGHT = np.array([255, 255, 215], dtype=np.uint8)
B72_CLOUD_BAND = np.array([255, 247, 183], dtype=np.uint8)
B72_PLATEAU_IVORY = np.array([247, 247, 167], dtype=np.uint8)
B72_CLOUD_GOLD_FG = np.array([242, 212, 146], dtype=np.uint8)
B72_STONE_BASE = np.array([159, 159, 127], dtype=np.uint8)
B72_STONE_OUTLINE = np.array([112, 108, 78], dtype=np.uint8)


def build_b72_unified_palette(ref_png: Path) -> np.ndarray:
    """Construit la palette pixel-art unifiée fidèle à `b72_mt_faraway_hooh.png` sans noir ni magenta."""
    ref_arr = np.asarray(Image.open(ref_png).convert("RGB"), dtype=np.uint8)
    u_ref, c_ref = np.unique(ref_arr.reshape(-1, 3), axis=0, return_counts=True)
    pal_ref = u_ref[np.argsort(-c_ref)]

    anchors = np.array(
        [
            [143, 223, 231],
            [175, 238, 236],
            [215, 255, 231],
            [255, 255, 232],
            [255, 255, 215],
            [255, 247, 183],
            [247, 247, 167],
            [244, 226, 162],
            [242, 212, 146],
            [232, 198, 132],
            [215, 191, 143],
            [207, 175, 127],
            [183, 151, 111],
            [167, 143, 103],
            [175, 175, 135],
            [159, 159, 127],
            [143, 143, 95],
            [127, 119, 87],
            [112, 108, 78],
            [95, 135, 55],
            [111, 143, 63],
            [127, 167, 71],
            [87, 119, 47],
        ],
        dtype=np.uint8,
    )
    return np.unique(np.vstack([pal_ref, anchors]), axis=0).astype(np.uint8)


def load_clean_b72_magenta_raw(raw_path: Path, w: int, h: int, exclude_portal: np.ndarray | None = None) -> Tuple[np.ndarray, np.ndarray]:
    """Extrait proprement le décor sur fond `#FF00FF` à `(w, h)` (`0` frange magenta, `0` noir sur les roches)."""
    im = Image.open(raw_path).convert("RGB")
    rgb = np.asarray(im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()
    r = rgb[:, :, 0].astype(np.int16)
    g = rgb[:, :, 1].astype(np.int16)
    b = rgb[:, :, 2].astype(np.int16)

    mag_excess = np.minimum(r, b) - g
    is_bg = mag_excess >= 72
    fg = ~is_bg

    # Décontamination du halo AA magenta sur le contour externe (`R > G + 18 & B > G + 18`)
    fringe = fg & (mag_excess >= 16)
    pure_fg = fg & (~fringe)
    if np.any(fringe) and np.any(pure_fg):
        _, idx = ndimage.distance_transform_edt(~pure_fg, return_indices=True)
        rgb[fringe] = rgb[idx[0][fringe], idx[1][fringe]]

    # Remplacement de tout contour sombre/noir par l'olive-taupe GBA canonique `[112, 108, 78]`
    work = fg & (~exclude_portal) if exclude_portal is not None else fg
    too_dark = work & (rgb.max(axis=2) < 108)
    rgb[too_dark] = B72_STONE_OUTLINE
    return rgb, fg


def build_b72_sky_and_cloud_sea_layers(
    w: int,
    h: int,
    n_frames: int = 24,
    horizon_frac: float = 0.162,
) -> Tuple[Image.Image, List[Image.Image], List[Image.Image]]:
    """Construit :
    - `00` : Ciel bleu-cyan `b72` (`[143, 223, 231]`) + mer de nuages dorée continue (`[255, 255, 215]`) ;
    - `01` : Rubans horizontaux de la mer de nuages (`[255, 247, 183]`) dérivant en douceur (`24` poses) ;
    - `02` : Arc-en-Ciel sacré pastel de Ho-Oh s'irisant doucement dans le ciel cyan (`24` poses).
    """
    yy, xx = np.mgrid[:h, :w]
    y_hor = int(round(horizon_frac * h))

    bg = np.empty((h, w, 4), dtype=np.uint8)
    bg[:, :, 3] = 255
    bg[:y_hor, :, :3] = B72_SKY_CYAN
    bg[max(0, y_hor - 3) : y_hor + 2, :, :3] = B72_SKY_MIST
    bg[y_hor + 2 :, :, :3] = B72_CLOUD_LIGHT
    im_00_sky = Image.fromarray(bg, mode="RGBA")

    # Rubans nuageux horizontaux `b72` à ondulation douce sans couture sur `w`
    band_specs = [
        (0.205, 0.022, 1),
        (0.325, 0.028, -1),
        (0.455, 0.024, 1),
        (0.585, 0.026, -1),
        (0.725, 0.030, 1),
        (0.865, 0.032, -1),
    ]
    frames_01: List[Image.Image] = []
    for t in range(n_frames):
        phase = 2.0 * np.pi * (t / float(n_frames))
        cl = np.zeros((h, w, 4), dtype=np.uint8)
        for yc_f, hh_f, direction in band_specs:
            yc = yc_f * h + 2.5 * np.sin(2.0 * np.pi * (xx / float(w)) * 2.0 + direction * phase)
            half_h = hh_f * h
            m = (yy >= y_hor + 2) & (np.abs(yy - yc) <= half_h)
            cl[m, :3] = B72_CLOUD_BAND
            cl[m, 3] = 255
        frames_01.append(Image.fromarray(cl, mode="RGBA"))

    # Arc-en-Ciel pastel sacré de Ho-Oh dans le haut du ciel cyan (`y < y_hor - 4`, subtil et fidèle GBA)
    rx = (xx - 0.50 * w) / (0.46 * w)
    ry = (yy - 0.34 * h) / (0.31 * h)
    r_arc = np.hypot(rx, ry)
    rb_bands = [
        (0.955, 0.985, np.array([255, 226, 186], dtype=np.uint8)),  # corail doré pastel Ho-Oh
        (0.925, 0.955, np.array([255, 248, 192], dtype=np.uint8)),  # or solaire Ho-Oh
        (0.895, 0.925, np.array([198, 250, 214], dtype=np.uint8)),  # jade céleste Ho-Oh
        (0.865, 0.895, np.array([176, 238, 246], dtype=np.uint8)),  # azur nacré
    ]
    frames_02_rainbow: List[Image.Image] = []
    for t in range(n_frames):
        sv = 0.5 + 0.5 * np.sin(2.0 * np.pi * (t / float(n_frames)))
        rb = np.zeros((h, w, 4), dtype=np.uint8)
        span_ok = (yy < y_hor - 4) & (np.abs(xx - 0.50 * w) <= (0.30 + 0.14 * sv) * w)
        for r0, r1, col in rb_bands:
            m = span_ok & (r_arc >= r0) & (r_arc < r1)
            rb[m, :3] = col if sv > 0.30 else B72_SKY_MIST
            rb[m, 3] = 255
        frames_02_rainbow.append(Image.fromarray(rb, mode="RGBA"))

    return im_00_sky, frames_01, frames_02_rainbow


def build_hooh_mist_and_feathers_layers(
    q_rgb: np.ndarray,
    mist_mask: np.ndarray,
    n_frames: int = 24,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit :
    - `08` : Volutes de brume dorée au pied des piliers karstiques (`BG`, respiration douce `±1 px`, `24` poses) ;
    - `09` : Plumes & lueurs dorées sacrées de Ho-Oh s'élevant dans l'air du sommet (`Top`, `24` poses).
    """
    h, w, _ = q_rgb.shape
    base_mist = np.zeros((h, w, 4), dtype=np.uint8)
    base_mist[mist_mask, :3] = q_rgb[mist_mask]
    base_mist[mist_mask, 3] = 255

    frames_08: List[Image.Image] = []
    for t in range(n_frames):
        dy = int(round(1.4 * np.sin(2.0 * np.pi * (t / float(n_frames)))))
        if dy == 0:
            frames_08.append(Image.fromarray(base_mist.copy(), mode="RGBA"))
        else:
            rolled = np.zeros_like(base_mist)
            if dy > 0:
                rolled[dy:, :] = base_mist[:-dy, :]
                rolled[:dy, :] = base_mist[:1, :]
            else:
                rolled[:dy, :] = base_mist[-dy:, :]
                rolled[dy:, :] = base_mist[-1:, :]
            frames_08.append(Image.fromarray(rolled, mode="RGBA"))

    # Particules / plumes lumineuses dorées de Ho-Oh dérivant lentement vers le haut (`Top`)
    motes = [
        (0.24, 0.62, 0), (0.31, 0.44, 6), (0.38, 0.28, 12), (0.46, 0.36, 18),
        (0.54, 0.32, 3), (0.62, 0.46, 9), (0.70, 0.58, 15), (0.76, 0.38, 21),
        (0.18, 0.48, 8), (0.82, 0.50, 14), (0.43, 0.68, 20), (0.57, 0.66, 4),
    ]
    c_core = np.array([255, 255, 232, 255], dtype=np.uint8)
    c_gold = np.array([255, 224, 142, 255], dtype=np.uint8)
    c_warm = np.array([248, 178, 124, 255], dtype=np.uint8)

    rise_px = max(12, int(round(28 * h / 576.0)))
    sway_px = max(2, int(round(5 * w / 768.0)))
    frames_09: List[Image.Image] = []
    for t in range(n_frames):
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        for fx, fy, ph in motes:
            u = ((t + ph) % n_frames) / float(n_frames)
            # Apparition / disparition douce sans coupure aux extrémités du cycle
            if 0.08 <= u <= 0.92:
                cx = int(round(w * fx + sway_px * np.sin(2.0 * np.pi * u)))
                cy = int(round(h * fy - rise_px * u))
                if 2 <= cx < w - 2 and 2 <= cy < h - 2:
                    fr[cy, cx] = c_core
                    if 0.22 <= u <= 0.78:
                        fr[cy + 1, cx] = c_gold
                        fr[cy, cx + 1] = c_gold
                        fr[cy + 2, cx - 1] = c_warm
        frames_09.append(Image.fromarray(fr, mode="RGBA"))

    return frames_08, frames_09
