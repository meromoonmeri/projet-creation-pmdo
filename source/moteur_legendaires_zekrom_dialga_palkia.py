"""Moteur pixel-art multicalque canonique PMD Sky (768×576, boucle maîtresse 120 ticks)
pour la Faille Spatiale de Palkia :
  - FSE1 : Faille Spatiale — Entrée du Gouffre Dimensionnel (réf. D46P41A)
  - FSA1 : Creux de la Faille Spatiale — Sanctuaire de Palkia (réf. D45P42A)

Invariants garantis :
  - alpha strictement binaire {0, 255}, zéro frange magenta #FF00FF.
  - Harmoniques temporelles impaires (w ∈ {1, 3}) sur 24 frames (5 ticks = 120 ticks)
    garantissant une boucle 100 % sans couture (23 -> 0) ET pose 0 != pose 12.
"""
from __future__ import annotations

from typing import List, Tuple

import numpy as np
from scipy import ndimage

BAYER2 = np.array([[0.0, 0.5], [0.75, 0.25]], dtype=np.float32)


def bayer_field(h: int, w: int) -> np.ndarray:
    return np.tile(BAYER2, ((h + 1) // 2, (w + 1) // 2))[:h, :w]


def clean_brut_magenta_fringe(rgb_in: np.ndarray, mag_mask: np.ndarray) -> np.ndarray:
    """Purge toute frange demi-teinte rose/violette/magenta en bordure du masque #FF00FF
    en propageant le plus proche pixel pierre non-magenta valide.
    """
    rgb = rgb_in.copy()
    r = rgb[:, :, 0].astype(np.int32)
    g = rgb[:, :, 1].astype(np.int32)
    b = rgb[:, :, 2].astype(np.int32)
    near_mag = ndimage.binary_dilation(mag_mask, iterations=5) & (~mag_mask)
    pink_global = (~mag_mask) & ((r - g >= 52) & (b - g >= 52) & (r >= 95) & (b >= 95))
    pink_border = near_mag & ((r - g >= 18) & (b - g >= 18))
    pink_fringe = pink_global | pink_border
    if np.any(pink_fringe):
        valid = (~mag_mask) & (~pink_fringe)
        _, idx = ndimage.distance_transform_edt(~valid, return_indices=True)
        rgb[pink_fringe] = rgb[idx[0][pink_fringe], idx[1][pink_fringe]]
    return rgb


def palette_lookup_dithered(
    t_norm: np.ndarray, palette_rgb: np.ndarray, dither_amp: float = 0.72
) -> np.ndarray:
    """Projette un champ scalaire [0, 1] sur une palette pixel-art discrète."""
    h, w = t_norm.shape
    n = len(palette_rgb)
    bf = bayer_field(h, w) - 0.375
    scaled = np.clip(t_norm, 0.0, 0.9999) * (n - 1) + bf * dither_amp
    idx = np.clip(np.rint(scaled).astype(np.int32), 0, n - 1)
    return palette_rgb[idx]


def draw_bolt_segment_rgba(
    canvas: np.ndarray,
    pts: List[Tuple[int, int]],
    core_rgba: Tuple[int, int, int, int],
    mid_rgba: Tuple[int, int, int, int],
    halo_rgba: Tuple[int, int, int, int],
    thickness: int = 1,
) -> None:
    """Trace un arc pixel-art net à 3 niveaux (halo -> médian -> cœur blanc)."""
    h, w, _ = canvas.shape
    seg_px: List[Tuple[int, int]] = []
    for (x0, y0), (x1, y1) in zip(pts[:-1], pts[1:]):
        steps = max(abs(x1 - x0), abs(y1 - y0), 1)
        for s in range(steps + 1):
            px = int(round(x0 + (x1 - x0) * s / steps))
            py = int(round(y0 + (y1 - y0) * s / steps))
            seg_px.append((px, py))

    for px, py in seg_px:
        for dy in range(-thickness - 2, thickness + 3):
            for dx in range(-thickness - 2, thickness + 3):
                if abs(dx) + abs(dy) <= thickness + 2:
                    yy_i, xx_i = py + dy, px + dx
                    if 0 <= yy_i < h and 0 <= xx_i < w and canvas[yy_i, xx_i, 3] == 0:
                        canvas[yy_i, xx_i] = halo_rgba
    for px, py in seg_px:
        for dy in range(-thickness - 1, thickness + 2):
            for dx in range(-thickness - 1, thickness + 2):
                if abs(dx) + abs(dy) <= thickness + 1:
                    yy_i, xx_i = py + dy, px + dx
                    if 0 <= yy_i < h and 0 <= xx_i < w:
                        canvas[yy_i, xx_i] = mid_rgba
    for px, py in seg_px:
        for dy in range(-thickness, thickness + 1):
            for dx in range(-thickness, thickness + 1):
                yy_i, xx_i = py + dy, px + dx
                if 0 <= yy_i < h and 0 <= xx_i < w:
                    canvas[yy_i, xx_i] = core_rgba


SPATIAL_COSMOS_PAL = np.array(
    [
        [16, 11, 34],
        [26, 17, 54],
        [40, 25, 78],
        [60, 35, 108],
        [88, 48, 144],
        [126, 66, 184],
        [174, 96, 222],
        [226, 148, 250],
    ],
    dtype=np.uint8,
)

SPATIAL_PORTAL_PAL = np.array(
    [
        [52, 26, 98],
        [92, 44, 154],
        [146, 72, 208],
        [204, 116, 244],
        [242, 178, 255],
        [255, 228, 255],
        [255, 255, 255],
    ],
    dtype=np.uint8,
)


def build_spatial_rift_layers(
    h: int,
    w: int,
    void_mask: np.ndarray,
    portal_mask: np.ndarray,
    portal_center_xy: Tuple[float, float],
    n_frames: int = 24,
) -> Tuple[List[np.ndarray], List[np.ndarray], List[np.ndarray], List[np.ndarray]]:
    """Construit 4 calques animés 24 poses (5 ticks = 120 ticks) pour la Faille Spatiale (Palkia)."""
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    pcx, pcy = portal_center_xy
    pdx = (xx - pcx) * 0.82
    pdy = (yy - pcy) * 1.18
    prr = np.hypot(pdx, pdy) + 1.0
    ptheta = np.arctan2(pdy, pdx)

    rng = np.random.default_rng(48400)
    tw_p, th_p = 256, 192
    tile_stars = [
        (int(rng.integers(3, tw_p - 3)), int(rng.integers(3, th_p - 3)), int(rng.integers(0, 12)))
        for _ in range(44)
    ]
    shards = [
        (float(rng.uniform(0, w)), float(rng.uniform(0, h)), int(rng.choice([1, 3])))
        for _ in range(85)
    ]

    cosmos_frames: List[np.ndarray] = []
    portal_frames: List[np.ndarray] = []
    shock_frames: List[np.ndarray] = []
    shard_frames: List[np.ndarray] = []

    all_mag = void_mask | portal_mask
    ty_g, tx_g = np.mgrid[0:th_p, 0:tw_p].astype(np.float32)

    for f in range(n_frames):
        ph1 = (2.0 * np.pi * 1.0 * f) / n_frames
        ph3 = (2.0 * np.pi * 3.0 * f) / n_frames

        s_diag = tx_g / tw_p + ty_g / th_p + 0.09 * np.sin(2.0 * np.pi * (tx_g / tw_p - ty_g / th_p) + ph1)
        warp_tile = (
            0.22
            + 0.24 * np.sin(2.0 * np.pi * s_diag - ph1)
            + 0.14 * np.sin(4.0 * np.pi * s_diag + 2.0 * np.pi * (tx_g / tw_p) - ph3)
        )
        tile_rgb = palette_lookup_dithered(np.clip(warp_tile, 0.0, 0.62), SPATIAL_COSMOS_PAL, dither_amp=0.0)
        for sx, sy, s_off in tile_stars:
            twk = (f + s_off) % 12
            if twk < 6:
                tile_rgb[sy, sx] = (255, 245, 255)
                if twk in (1, 2):
                    for ox, oy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        tile_rgb[sy + oy, sx + ox] = (212, 162, 255)
            else:
                tile_rgb[sy, sx] = (150, 108, 224)
        cos_rgb = np.tile(tile_rgb, ((h + th_p - 1) // th_p, (w + tw_p - 1) // tw_p, 1))[:h, :w]
        f_cos = np.zeros((h, w, 4), dtype=np.uint8)
        f_cos[all_mag, :3] = cos_rgb[all_mag]
        f_cos[all_mag, 3] = 255
        cosmos_frames.append(f_cos)

        f_port = np.zeros((h, w, 4), dtype=np.uint8)
        if np.any(portal_mask):
            dist_in = ndimage.distance_transform_edt(portal_mask).astype(np.float32)
            max_d = max(float(dist_in.max()), 1.0)
            core_t = np.clip(dist_in / (max_d * 0.62), 0.0, 1.0)
            ripple = 0.16 * np.sin(5.0 * ptheta + prr / 9.0 - ph3) + 0.10 * np.sin(ph1)
            p_rgb = palette_lookup_dithered(
                np.clip(core_t + ripple, 0.0, 1.0),
                SPATIAL_PORTAL_PAL,
                dither_amp=0.0,
            )
            f_port[portal_mask, :3] = p_rgb[portal_mask]
            f_port[portal_mask, 3] = 255
        portal_frames.append(f_port)

        f_shk = np.zeros((h, w, 4), dtype=np.uint8)
        for k in range(6):
            if (f + k * 4) % 12 < 5:
                ang_k = (2.0 * np.pi * k) / 6.0 + ph1 * 0.5
                cx_k = int(round(w * 0.5 + 250.0 * np.cos(ang_k)))
                cy_k = int(round(h * 0.5 + 185.0 * np.sin(ang_k)))
                pts = [
                    (cx_k - 22, cy_k - 10),
                    (cx_k - 5, cy_k + 4),
                    (cx_k + 9, cy_k - 5),
                    (cx_k + 24, cy_k + 9),
                ]
                draw_bolt_segment_rgba(
                    f_shk,
                    pts,
                    core_rgba=(255, 255, 255, 255),
                    mid_rgba=(248, 152, 255, 255),
                    halo_rgba=(150, 56, 224, 255),
                    thickness=0,
                )
        f_shk[~all_mag] = 0
        shock_frames.append(f_shk)

        f_shd = np.zeros((h, w, 4), dtype=np.uint8)
        for mx, my, harm in shards:
            ang = ph1 if harm == 1 else ph3
            px = int(round(mx + 6.0 * np.cos(ang + my * 0.03))) % w
            py = int(round(my - 9.0 * np.sin(ang + mx * 0.02))) % h
            if all_mag[py, px]:
                f_shd[py, px] = (255, 196, 255, 255)
        shard_frames.append(f_shd)

    return cosmos_frames, portal_frames, shock_frames, shard_frames
