#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — FSA0 : Faille Spatiale — Sanctuaire Scellé & Brisure de la Réalité (Pré-Portail).

Conçue en alignement pixel-pour-pixel (`1:1` strict sur `768 × 576`, `96 × 72` tuiles) avec `FSA1`
(*Faille Spatiale — Cœur Dimensionnel de Palkia*, réf. `D45P42A`) afin d'enchaîner en jeu :
  `FSA0` (paroi Nord scellée où la réalité se fend en éclats de verre *Spatio-Rift* sur la silhouette exacte du portail)
    ──▶ `FSA1` (portail *Spatio-Rift* grand ouvert au Nord)
sans aucun saut d'un seul pixel sur le cosmos, l'escalier Sud, les remparts ni le cercle central de dalles.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

HERE = Path(__file__).resolve().parent
SOURCE_DIR = HERE.parent
REPO_ROOT = SOURCE_DIR.parent
if str(SOURCE_DIR) not in sys.path:
    sys.path.insert(0, str(SOURCE_DIR))

from moteur_legendaires_zekrom_dialga_palkia import (  # type: ignore
    build_spatial_rift_layers,
    clean_brut_magenta_fringe,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "FSA0"
MAP_TITLE = "Faille Spatiale — Brisure de la Réalité (Pré-Portail)"

FSA1_DIR = SOURCE_DIR / "faille_spatiale_sanctuaire_v1"
FSA1_BRUT = FSA1_DIR / "bruts" / "base_faille_spatiale_sanctuaire.png"
FSA1_REF = FSA1_DIR / "references" / "d45p42a_deep_spatial_rift_boss_native.png"

RAW_DIR = HERE / "bruts"
BRUT_PATH = RAW_DIR / "base_faille_spatiale_sanctuaire_avant_portail.png"
SEALED_WALL_PNG = RAW_DIR / "paroi_nord_scellee_avant_portail.png"
REF_DIR = HERE / "references"
CANON_REF = REF_DIR / "d45p42a_deep_spatial_rift_boss_native.png"

RENDERS_DIR = REPO_ROOT / "renders" / "faille_spatiale_sanctuaire_avant_portail_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _to_imgs(arrs: List[np.ndarray]) -> List[Image.Image]:
    return [Image.fromarray(a, mode="RGBA") for a in arrs]


def _draw_crisp_line_mask(mask: np.ndarray, x0: float, y0: float, x1: float, y1: float) -> None:
    """Trace un segment rectiligne pixel-art 1 px parfaitement net (Bresenham vectorisé, 0 flou)."""
    h, w = mask.shape
    steps = max(int(round(max(abs(x1 - x0), abs(y1 - y0)))), 1)
    xs = np.rint(np.linspace(x0, x1, steps + 1)).astype(np.int32)
    ys = np.rint(np.linspace(y0, y1, steps + 1)).astype(np.int32)
    ok = (xs >= 0) & (xs < w) & (ys >= 0) & (ys < h)
    mask[ys[ok], xs[ok]] = True


def _dp_min_error_seam_vertical(patch_l: np.ndarray, patch_r: np.ndarray) -> np.ndarray:
    """Calcule la coupe verticale de coût minimal (Efros-Freeman DP, 0 flou, 100 % pixel-art net)."""
    hp, wov, _ = patch_l.shape
    diff = np.sum((patch_l.astype(np.float32) - patch_r.astype(np.float32)) ** 2, axis=2)
    cost = diff.copy()
    back = np.zeros((hp, wov), dtype=np.int32)
    for y in range(1, hp):
        prev = cost[y - 1]
        for x in range(wov):
            x0 = max(0, x - 1)
            x1 = min(wov, x + 2)
            idx = x0 + int(np.argmin(prev[x0:x1]))
            cost[y, x] += prev[idx]
            back[y, x] = idx
    seam = np.zeros(hp, dtype=np.int32)
    seam[-1] = int(np.argmin(cost[-1]))
    for y in range(hp - 2, -1, -1):
        seam[y] = back[y + 1, seam[y + 1]]
    out = patch_r.copy()
    xx = np.arange(wov)[None, :]
    use_l = xx <= seam[:, None]
    out[use_l] = patch_l[use_l]
    return out


def _reconstruct_sealed_north_rock_wall(
    rgb_fsa1: np.ndarray,
    solid_mask: np.ndarray,
    portal_mask: np.ndarray,
) -> Tuple[np.ndarray, np.ndarray]:
    """Reconstruit la paroi rocheuse Nord scellée (`sealed_rgb`) par couture DP sans flou
    à partir des vrais blocs de roche sombre indigo-violette de `FSA1` (`99.7 %` purs, `0` halo rose)."""
    h, w, _ = rgb_fsa1.shape
    sx = w / float(W_CANON)
    sy = h / float(H_CANON)

    ly0, ly1 = int(round(220 * sy)), int(round(390 * sy))
    lx0, lx1 = int(round(130 * sx)), int(round(260 * sx))
    rx0, rx1 = int(round(508 * sx)), int(round(638 * sx))

    patch_left = rgb_fsa1[ly0:ly1, lx0:lx1].copy()
    patch_right = rgb_fsa1[ly0:ly1, rx0:rx1].copy()
    hp = min(patch_left.shape[0], patch_right.shape[0])
    wp_l, wp_r = patch_left.shape[1], patch_right.shape[1]
    patch_left = patch_left[:hp]
    patch_right = patch_right[:hp]

    ov = max(8, int(round(36 * sx)))
    quilt_w = wp_l + wp_r - ov
    quilted = np.zeros((hp, quilt_w, 3), dtype=np.uint8)
    quilted[:, : wp_l - ov] = patch_left[:, : wp_l - ov]
    quilted[:, wp_l - ov : wp_l] = _dp_min_error_seam_vertical(
        patch_left[:, wp_l - ov :], patch_right[:, :ov]
    )
    quilted[:, wp_l:] = patch_right[:, ov:]

    dil_px = max(4, int(round(13 * sx)))
    r_c = rgb_fsa1[:, :, 0].astype(np.int32)
    g_c = rgb_fsa1[:, :, 1].astype(np.int32)
    b_c = rgb_fsa1[:, :, 2].astype(np.int32)
    purple_halo = solid_mask & ndimage.binary_dilation(portal_mask, iterations=dil_px) & (
        ((r_c - g_c) >= 18) | (b_c >= 128)
    )
    seal_zone = (portal_mask | purple_halo) & (~((~solid_mask) & (~portal_mask)))

    ys_p, xs_p = np.where(seal_zone)
    y_top = max(0, int(ys_p.min()) - max(2, int(round(8 * sy))))
    x_left = max(0, (w - quilt_w) // 2)

    sealed = rgb_fsa1.copy()
    canvas_rock = sealed.copy()
    y_end = min(h, y_top + hp)
    x_end = min(w, x_left + quilt_w)
    canvas_rock[y_top:y_end, x_left:x_end] = quilted[: y_end - y_top, : x_end - x_left]
    if int(ys_p.max()) >= y_end:
        extra_y1 = min(h, int(ys_p.max()) + 4)
        canvas_rock[y_end:extra_y1, x_left:x_end] = quilted[: extra_y1 - y_end, : x_end - x_left]

    dist_out = ndimage.distance_transform_edt(~portal_mask).astype(np.float32)
    yy, xx = np.mgrid[0:h, 0:w]
    ang = np.arctan2((yy - h * 0.19), (xx - w * 0.50))
    jagged_limit = (9.5 + 3.5 * np.sin(7.0 * ang + 0.6) + 2.5 * np.cos(13.0 * ang)) * sx
    organic_patch = (portal_mask | purple_halo | (dist_out <= jagged_limit)) & (solid_mask | portal_mask)
    organic_patch &= yy < int(round(0.345 * h))

    sealed[organic_patch] = canvas_rock[organic_patch]

    seam_edge = organic_patch & (~ndimage.binary_erosion(organic_patch, iterations=1)) & (~portal_mask)
    lum_s = sealed[:, :, 0].astype(np.int32) + sealed[:, :, 1].astype(np.int32) + sealed[:, :, 2].astype(np.int32)
    soft_seam = seam_edge & (lum_s > 165)
    sealed[soft_seam] = np.clip(sealed[soft_seam].astype(np.int32) * 58 // 100, 18, 255).astype(np.uint8)

    full_solid_sealed = solid_mask | portal_mask
    return sealed, full_solid_sealed


def _build_spatio_rift_shatter_sequence(
    sealed_rgb: np.ndarray,
    north_wall_mask: np.ndarray,
    portal_mask: np.ndarray,
    cosmos_24: List[np.ndarray],
    arena_floor_mask: np.ndarray,
    rgb_fsa1: np.ndarray,
    n_frames: int = N_FRAMES,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image], List[np.ndarray]]:
    """Moteur cinématique *Spatio-Rift* à facettes planes de verre brisé (diagramme de puissance euclidien) :
      - ZÉRO vague molle, ZÉRO zigzag symétrique artificiel, ZÉRO halo circulaire dur !
      - Arêtes de brisure 100 % rectilignes et asymétriques (comme une vitre / l'espace-temps fracassé par Palkia) ;
      - Au repos (`pose 0`), la paroi Nord est presque intacte avec une unique faille naissante en `Y` au centre ;
      - À l'apogée (`pose 12`), les tessons polygonaux s'écartent et pivotent légèrement dans la silhouette
        EXACTE du portail de `FSA1`, certains tessons reflétant le cosmos dimensionnel violet tandis que le cœur
        blanc-perle aveuglant du portail de `FSA1` jaillit par toutes les failles !
    """
    h, w, _ = sealed_rgb.shape
    sx = w / float(W_CANON)
    sy = h / float(H_CANON)
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)

    ys_p, xs_p = np.where(portal_mask)
    pcx = float(xs_p.mean())
    pcy = float(ys_p.mean())
    max_r = max(16.0, 84.0 * sx)

    # 1. Diagramme de Voronoi EUCLIDIEN PUR (sans distorsion sinusoïdale => arêtes 100 % DROITES façon verre brisé !)
    rng = np.random.default_rng(48477)
    cell_centers = []
    # 5 éclats triangulaires aigus au cœur (disparaissent à l'apogée pour révéler l'œil blanc du portail FSA1)
    for k in range(5):
        th = (2.0 * np.pi * k) / 5.0 + float(rng.uniform(-0.22, 0.22))
        rr = float(rng.uniform(11.0, 22.0)) * sx
        cell_centers.append((pcx + rr * np.cos(th), pcy + rr * 0.86 * np.sin(th), 0, float(rng.uniform(0.0, 1.0))))
    # 9 grands tessons polygonaux intermédiaires asymétriques
    for k in range(9):
        th = (2.0 * np.pi * k) / 9.0 + float(rng.uniform(-0.20, 0.20))
        rr = float(rng.uniform(32.0, 50.0)) * sx
        cell_centers.append((pcx + rr * 1.06 * np.cos(th), pcy + rr * 0.84 * np.sin(th), 1, float(rng.uniform(0.0, 1.0))))
    # 10 tessons périphériques épousant exactement les pointes déchiquetées de `portal_mask`
    for k in range(10):
        th = (2.0 * np.pi * k) / 10.0 + float(rng.uniform(-0.16, 0.16))
        rr = float(rng.uniform(62.0, 82.0)) * sx
        cell_centers.append((pcx + rr * 1.08 * np.cos(th), pcy + rr * 0.84 * np.sin(th), 2, float(rng.uniform(0.0, 1.0))))

    best_d = np.full((h, w), 1e9, dtype=np.float32)
    second_d = np.full((h, w), 1e9, dtype=np.float32)
    cell_id = np.zeros((h, w), dtype=np.int32)
    for cid, (cx_i, cy_i, _, _) in enumerate(cell_centers):
        d = np.hypot(xx - cx_i, yy - cy_i)
        better = d < best_d
        second_d = np.where(better, best_d, np.minimum(second_d, d))
        best_d = np.where(better, d, best_d)
        cell_id = np.where(better, cid, cell_id)

    # Distance exacte en pixels aux droites de cassure entre tessons (`0` = trait droit pur !)
    crack_metric = (second_d - best_d) * 0.5
    dist_center = np.hypot((xx - pcx) * 0.90, (yy - pcy) * 1.12)

    # 2. Réseau asymétrique de 9 fissures rectilignes bifurquées (façon verre fendu, ZÉRO zigzag périodique !)
    #    Partent du point d'impact `(pcx, pcy)` et filent en lignes droites brisées jusqu'aux crocs Nord.
    glass_ray_angles = [-2.78, -2.14, -1.62, -1.04, -0.46, 0.14, 0.68, 1.38, 2.28]
    branch_defs = []
    for idx_r, base_a in enumerate(glass_ray_angles):
        r1 = float(rng.uniform(0.42, 0.62)) * max_r
        r2 = float(rng.uniform(0.92, 1.24)) * max_r
        bend = float(rng.uniform(-0.24, 0.24))
        x1 = pcx + r1 * 1.05 * np.cos(base_a)
        y1 = pcy + r1 * 0.80 * np.sin(base_a)
        x2 = x1 + (r2 - r1) * 1.08 * np.cos(base_a + bend)
        y2 = y1 + (r2 - r1) * 0.82 * np.sin(base_a + bend)
        # Petite fourche secondaire droite en bout de cassure (signature visuelle du verre brisé !)
        fork_a = base_a + bend + (0.44 if idx_r % 2 == 0 else -0.44)
        rf = float(rng.uniform(0.20, 0.34)) * max_r
        xf = x1 + rf * 1.05 * np.cos(fork_a)
        yf = y1 + rf * 0.80 * np.sin(fork_a)
        branch_defs.append(((pcx, pcy), (x1, y1), (x2, y2), (xf, yf)))

    # 3. Cercle central de dalles de Palkia + veines rocheuses naturelles
    lum_f = (
        0.299 * rgb_fsa1[:, :, 0].astype(np.float32)
        + 0.587 * rgb_fsa1[:, :, 1].astype(np.float32)
        + 0.114 * rgb_fsa1[:, :, 2].astype(np.float32)
    )
    ell_arena = np.hypot((xx - w * 0.50) / max(1.0, 0.255 * w), (yy - h * 0.545) / max(1.0, 0.265 * h))
    thin_dark = (ndimage.uniform_filter(lum_f, size=max(3, int(round(5 * sx)))) - lum_f) >= 13.5
    circle_seams = arena_floor_mask & thin_dark & (ell_arena <= 0.74)
    north_bridge_seams = (
        arena_floor_mask
        & thin_dark
        & (yy <= h * 0.45)
        & (np.abs(xx - pcx) <= 0.14 * w)
    )
    theta_a = np.arctan2(yy - h * 0.545, xx - w * 0.50)

    static_surround_north = north_wall_mask & (~portal_mask)
    dist_from_portal = ndimage.distance_transform_edt(~portal_mask).astype(np.float32)
    sealed_lum = (
        0.299 * sealed_rgb[:, :, 0].astype(np.float32)
        + 0.587 * sealed_rgb[:, :, 1].astype(np.float32)
        + 0.114 * sealed_rgb[:, :, 2].astype(np.float32)
    )
    # Uniquement les faces éclairées des rochers tournées vers la brèche (ZÉRO cercle artificiel !)
    facing_rock_facets = static_surround_north & (sealed_lum >= 42.0)

    floating_debris = []
    for k in range(22):
        ang = float(rng.uniform(0.0, 2.0 * np.pi))
        rad0 = float(rng.uniform(10.0, 72.0)) * sx
        bx = pcx + rad0 * np.cos(ang)
        by = pcy + rad0 * 0.80 * np.sin(ang)
        sz = int(rng.choice([1, 2, 2]))
        floating_debris.append((bx, by, ang, sz))

    l6_frames: List[Image.Image] = []
    l7_frames: List[Image.Image] = []
    l8_frames: List[Image.Image] = []
    top_debris_frames: List[np.ndarray] = []

    for f in range(n_frames):
        ph1 = (2.0 * np.pi * f) / n_frames
        ph3 = (2.0 * np.pi * 3.0 * f) / n_frames
        raw_s = 0.5 - 0.5 * np.cos(ph1)
        s = float(raw_s ** 0.85)
        cos_rgb_f = cosmos_24[f][:, :, :3]

        # --- Calque 06 : Paroi Nord scellée + tessons plans de verre/roche au-dessus du portail `FSA1` ---
        f6 = np.zeros((h, w, 4), dtype=np.uint8)
        f6[static_surround_north, :3] = sealed_rgb[static_surround_north]
        f6[static_surround_north, 3] = 255

        for cid, (cx_i, cy_i, ring_tier, glass_seed) in enumerate(cell_centers):
            shard_m = portal_mask & (cell_id == cid)
            if not np.any(shard_m):
                continue

            if f == 0:
                # À `pose 0`, paroi scellée 100 % unie (seule la fine entaille en Y de `f8` brille au cœur !)
                f6[shard_m, :3] = sealed_rgb[shard_m]
                f6[shard_m, 3] = 255
                continue

            local_open = float(np.clip((s - 0.16 * ring_tier) / max(0.22, 1.0 - 0.16 * ring_tier), 0.0, 1.0))

            # À l'apogée (`s > 0.72`), les 5 petits éclats centraux disparaissent complètement
            # pour ouvrir le cœur blanc aveuglant exact du portail de `FSA1` !
            if ring_tier == 0 and local_open > 0.72:
                continue

            erode_px = int(
                round(
                    (2.8 if ring_tier == 0 else (2.0 if ring_tier == 1 else 1.2))
                    * local_open
                    * sx
                )
            )
            keep_shard = (
                ndimage.binary_erosion(shard_m, iterations=erode_px)
                if erode_px >= 1
                else shard_m
            )
            if not np.any(keep_shard):
                continue

            vx = (cx_i - pcx) / max(12.0, max_r)
            vy = (cy_i - pcy) / max(12.0, max_r)
            amp = (6.5 if ring_tier == 0 else (4.6 if ring_tier == 1 else 2.6)) * local_open * sx
            dx_i = int(round(vx * amp + 0.7 * sx * np.sin(ph3 + cid)))
            dy_i = int(round(vy * amp - 1.2 * local_open * sy))

            sy_idx, sx_idx = np.where(keep_shard)
            ty_idx = np.clip(sy_idx + dy_i, 0, h - 1)
            tx_idx = np.clip(sx_idx + dx_i, 0, w - 1)
            valid_dst = north_wall_mask[ty_idx, tx_idx]
            sy_idx, sx_idx = sy_idx[valid_dst], sx_idx[valid_dst]
            ty_idx, tx_idx = ty_idx[valid_dst], tx_idx[valid_dst]

            cols = sealed_rgb[sy_idx, sx_idx].copy()
            # Certains tessons basculés reflètent l'autre dimension (miroitement violet *Spatio-Rift*) !
            if glass_seed > 0.48 and local_open > 0.28:
                mix_w = 0.42 * local_open
                ref_c = cos_rgb_f[sy_idx, sx_idx].astype(np.float32)
                cols = np.clip(
                    cols.astype(np.float32) * (1.0 - mix_w)
                    + (ref_c * 1.25 + np.array([46.0, 22.0, 74.0])) * mix_w,
                    0,
                    255,
                ).astype(np.uint8)

            # Biseau cristallin net 1 px sur l'arête vive du tesson brisé
            if local_open > 0.15:
                inner_edge = keep_shard & (~ndimage.binary_erosion(keep_shard, iterations=1))
                bevel_flags = inner_edge[sy_idx, sx_idx]
                if np.any(bevel_flags):
                    cols[bevel_flags] = (
                        np.array([255, 226, 255], dtype=np.uint8)
                        if local_open >= 0.50
                        else np.array([204, 108, 244], dtype=np.uint8)
                    )

            f6[ty_idx, tx_idx, :3] = cols
            f6[ty_idx, tx_idx, 3] = 255

        l6_frames.append(Image.fromarray(f6, mode="RGBA"))

        # --- Calque 07 : Résonance du cercle central de Palkia + veines montantes vers la brèche ---
        f7 = np.zeros((h, w, 4), dtype=np.uint8)
        ang_wave = np.sin(4.0 * theta_a - ph1)
        lit_circle = circle_seams & (ang_wave > (0.42 - 0.58 * s))
        f7[lit_circle] = (224, 134, 252, 255) if s < 0.65 else (252, 206, 255, 255)
        if s > 0.25:
            pulse_y = h * (0.50 - 0.20 * s)
            bridge_on = north_bridge_seams & (np.abs(yy - pulse_y) <= max(10.0, 34.0 * sy * s))
            f7[bridge_on] = (242, 166, 255, 255)
        l7_frames.append(Image.fromarray(f7, mode="RGBA"))

        # --- Calque 08 : Fissures rectilignes façon verre brisé + éclairage rasant naturel des rochers ---
        f8 = np.zeros((h, w, 4), dtype=np.uint8)

        # Éclairage volumétrique progressif par facettes rocheuses (3 paliers doux, ZÉRO anneau dur !)
        if s > 0.08:
            b1 = facing_rock_facets & (dist_from_portal <= 7.0 * sx)
            b2 = facing_rock_facets & (dist_from_portal > 7.0 * sx) & (dist_from_portal <= 15.0 * sx)
            b3 = facing_rock_facets & (dist_from_portal > 15.0 * sx) & (dist_from_portal <= 24.0 * sx)
            for b_mask, scale_b in ((b1, 1.0), (b2, 0.55), (b3, 0.25)):
                amp_b = int(round(38.0 * s * scale_b))
                if amp_b > 0 and np.any(b_mask):
                    f8[b_mask, :3] = np.clip(
                        sealed_rgb[b_mask].astype(np.int32)
                        + np.array([amp_b, amp_b // 2, amp_b + 12]),
                        0,
                        255,
                    ).astype(np.uint8)
                    f8[b_mask, 3] = 255

        # Arêtes de verre droites entre les tessons à l'intérieur de `portal_mask`
        front_r = (0.18 + 0.90 * s) * max_r
        if f > 0:
            active_cracks = (
                portal_mask
                & (dist_center <= front_r)
                & (crack_metric <= max(0.75, (0.80 + 0.65 * s) * sx))
                & (f6[:, :, 3] == 255)
            )
            f8[active_cracks] = (232, 132, 252, 255)

        # Fissures rectilignes bifurquées (façon impact sur du cristal/verre, 1 px ultra-net !)
        core_lines = np.zeros((h, w), dtype=bool)
        for idx_r, (p0_b, p1_b, p2_b, pf_b) in enumerate(branch_defs):
            # À `pose 0` : seulement 3 fines branches courtes en `Y` au centre exact `(pcx, pcy)` !
            if f == 0:
                if idx_r not in (0, 3, 6):
                    continue
                u1 = 0.42
                ex = p0_b[0] + (p1_b[0] - p0_b[0]) * u1
                ey = p0_b[1] + (p1_b[1] - p0_b[1]) * u1
                _draw_crisp_line_mask(core_lines, p0_b[0], p0_b[1], ex, ey)
            else:
                reach = float(np.clip(s * 1.25 - 0.04 * (idx_r % 3), 0.0, 1.0))
                if reach <= 0.02:
                    continue
                if reach <= 0.55:
                    u = reach / 0.55
                    ex = p0_b[0] + (p1_b[0] - p0_b[0]) * u
                    ey = p0_b[1] + (p1_b[1] - p0_b[1]) * u
                    _draw_crisp_line_mask(core_lines, p0_b[0], p0_b[1], ex, ey)
                else:
                    _draw_crisp_line_mask(core_lines, p0_b[0], p0_b[1], p1_b[0], p1_b[1])
                    u2 = (reach - 0.55) / 0.45
                    ex2 = p1_b[0] + (p2_b[0] - p1_b[0]) * u2
                    ey2 = p1_b[1] + (p2_b[1] - p1_b[1]) * u2
                    _draw_crisp_line_mask(core_lines, p1_b[0], p1_b[1], ex2, ey2)
                    if reach > 0.72:
                        uf = (reach - 0.72) / 0.28
                        exf = p1_b[0] + (pf_b[0] - p1_b[0]) * uf
                        eyf = p1_b[1] + (pf_b[1] - p1_b[1]) * uf
                        _draw_crisp_line_mask(core_lines, p1_b[0], p1_b[1], exf, eyf)

        core_lines &= north_wall_mask
        halo_lines = ndimage.binary_dilation(core_lines, iterations=1) & north_wall_mask & (~core_lines)
        f8[halo_lines] = (176, 72, 232, 255)
        f8[core_lines] = (255, 248, 255, 255)

        l8_frames.append(Image.fromarray(f8, mode="RGBA"))

        # --- Éclats cristallins arrachés en apesanteur (`Top`) ---
        f_deb = np.zeros((h, w, 4), dtype=np.uint8)
        if s > 0.15:
            for idx_d, (bx, by, ang_d, sz) in enumerate(floating_debris):
                if (idx_d % 3 == 0) or (s > 0.50):
                    lift = (5.0 + 16.0 * s) * sy
                    rx_d = int(round(bx + np.cos(ang_d) * 8.0 * s * sx))
                    ry_d = int(round(by - lift + 2.5 * np.sin(ph3 + idx_d) * sy))
                    if 2 <= rx_d < w - 3 and 2 <= ry_d < h - 3:
                        f_deb[ry_d : ry_d + sz, rx_d : rx_d + sz] = (
                            (255, 236, 255, 255) if (idx_d % 2 == 0) else (204, 118, 250, 255)
                        )
        top_debris_frames.append(f_deb)

    return l6_frames, l7_frames, l8_frames, top_debris_frames


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    REF_DIR.mkdir(parents=True, exist_ok=True)
    if not CANON_REF.is_file():
        CANON_REF.write_bytes(FSA1_REF.read_bytes())

    im_raw = Image.open(FSA1_BRUT).convert("RGB")
    if im_raw.size != (w, h):
        im_raw = im_raw.resize((w, h), Image.Resampling.NEAREST)
    rgb_raw = np.asarray(im_raw, dtype=np.uint8).copy()

    r = rgb_raw[:, :, 0].astype(np.int32)
    g = rgb_raw[:, :, 1].astype(np.int32)
    b = rgb_raw[:, :, 2].astype(np.int32)
    mag_mask = (r >= 215) & (g <= 50) & (b >= 215)
    rgb_fsa1 = clean_brut_magenta_fringe(rgb_raw, mag_mask)
    solid_mask_fsa1 = ~mag_mask

    yy, xx = np.mgrid[0:h, 0:w]
    labels, n_comp = ndimage.label(mag_mask)
    portal_mask = np.zeros_like(mag_mask)
    for lab in range(1, n_comp + 1):
        comp = labels == lab
        touches_side = bool(comp[:, 0].any() or comp[:, -1].any() or comp[-1, :].any())
        if not touches_side:
            portal_mask |= comp
    if not np.any(portal_mask):
        portal_mask = (
            mag_mask
            & (np.abs(xx - w // 2) <= int(0.145 * w))
            & (yy >= int(0.06 * h))
            & (yy <= int(0.34 * h))
        )
    void_mask = mag_mask & (~portal_mask)

    sealed_rgb, full_solid_sealed = _reconstruct_sealed_north_rock_wall(
        rgb_fsa1, solid_mask_fsa1, portal_mask
    )

    if w == W_CANON and h == H_CANON:
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        brut_rift = sealed_rgb.copy()
        brut_rift[void_mask | portal_mask] = (255, 0, 255)
        Image.fromarray(brut_rift, mode="RGB").save(BRUT_PATH)

        brut_sealed = sealed_rgb.copy()
        brut_sealed[void_mask] = (255, 0, 255)
        Image.fromarray(brut_sealed, mode="RGB").save(SEALED_WALL_PNG)

    cosmos_24, portal_24, shock_24, shard_24 = build_spatial_rift_layers(
        h=h,
        w=w,
        void_mask=void_mask,
        portal_mask=portal_mask,
        portal_center_xy=(w * 0.50, h * 0.19),
        n_frames=N_FRAMES,
    )

    ell_arena = np.hypot((xx - w * 0.50) / max(1.0, 0.255 * w), (yy - h * 0.545) / max(1.0, 0.265 * h))
    is_south_stairs = solid_mask_fsa1 & (yy >= int(0.78 * h)) & (np.abs(xx - w // 2) <= int(0.145 * w))
    is_arena_floor = solid_mask_fsa1 & (ell_arena <= 0.92) & (~is_south_stairs)
    is_north_jaws_fsa1 = solid_mask_fsa1 & (~is_arena_floor) & (yy < int(0.40 * h))
    is_crater_walls = solid_mask_fsa1 & (~is_arena_floor) & (~is_south_stairs) & (~is_north_jaws_fsa1)
    covered = is_south_stairs | is_arena_floor | is_north_jaws_fsa1 | is_crater_walls
    is_crater_walls |= solid_mask_fsa1 & (~covered)

    north_wall_sealed_mask = (is_north_jaws_fsa1 | portal_mask) & full_solid_sealed

    def mk_static_fsa1(mask: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[mask, :3] = rgb_fsa1[mask]
        out[mask, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    l6_shatter, l7_resonance, l8_cracks, extra_top_debris = _build_spatio_rift_shatter_sequence(
        sealed_rgb=sealed_rgb,
        north_wall_mask=north_wall_sealed_mask,
        portal_mask=portal_mask,
        cosmos_24=cosmos_24,
        arena_floor_mask=is_arena_floor,
        rgb_fsa1=rgb_fsa1,
        n_frames=N_FRAMES,
    )

    top_combined: List[Image.Image] = []
    for f in range(N_FRAMES):
        arr_t = shard_24[f].copy()
        deb = extra_top_debris[f]
        has_d = deb[:, :, 3] == 255
        arr_t[has_d] = deb[has_d]
        top_combined.append(Image.fromarray(arr_t, mode="RGBA"))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            sub_a = is_arena_floor[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            sub_s = is_south_stairs[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            sub_m = mag_mask[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            if (float(sub_a.mean()) >= 0.65 or float(sub_s.mean()) >= 0.55) and float(sub_m.mean()) == 0.0:
                walk_grid[ty, tx] = True
    cx_t = gw // 2
    for ty in range(max(4, int(round(0.36 * gh))), gh):
        walk_grid[ty, max(0, cx_t - 2) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False

    layers = [
        LayerEntry("00_cosmos_indigo_distordu_d45p42a", "Cosmos Indigo-Violet Distordu D45P42A (Calé FSA1)", "BG", _to_imgs(cosmos_24), frame_length=5),
        LayerEntry("01_noyau_spatio_rift_sous_paroi", "Lueur Spatio-Rift Sous-Jacente (Silhouette Portail FSA1)", "BG", _to_imgs(portal_24), frame_length=5),
        LayerEntry("02_anneaux_choc_dimensionnels", "Éclairs & Ondes Spatio-Rift du Vide", "BG", _to_imgs(shock_24), frame_length=5),
        LayerEntry("03_dalles_antiques_arene_palkia", "Dalles Antiques & Cercle Central (Calé 1:1 FSA1)", "BG", [mk_static_fsa1(is_arena_floor)], frame_length=5),
        LayerEntry("04_escalier_acces_sud_cratere", "Chaussée Sud-Nord d'Accès (Calée 1:1 FSA1)", "BG", [mk_static_fsa1(is_south_stairs)], frame_length=5),
        LayerEntry("05_remparts_cratere_violets_statiques", "Remparts Rocheux Est & Ouest (Calés 1:1 FSA1)", "BG", [mk_static_fsa1(is_crater_walls)], frame_length=5),
        LayerEntry("06_paroi_nord_scellee_eclats_spatio_rift", "Paroi Nord Scellée & Éclats de Réalité Spatio-Rift", "BG", l6_shatter, frame_length=5),
        LayerEntry("07_resonance_cercle_central_palkia", "Résonance du Cercle Central & Veines Spatiales", "BG", l7_resonance, frame_length=5),
        LayerEntry("08_lezardes_cristallines_brisure_nord", "Lézardes de Verre Dimensionnel & Halo Nord", "BG", l8_cracks, frame_length=5),
        LayerEntry("09_fragments_realite_apesanteur_top", "Fragments de Réalité & Perles en Apesanteur Top", "Top", top_combined, frame_length=5),
    ]
    return layers, walk_grid


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    h = max(64, int(round(H_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    VIRTUAL_ZIP.parent.mkdir(parents=True, exist_ok=True)
    layers, walk_grid = build_layers_for_size(w, h)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=CANON_REF,
        max_fidelity_distance=30.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="faille_spatiale_fsa0",
        asset_name_override="faille_spatiale_sanctuaire_avant_portail",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
