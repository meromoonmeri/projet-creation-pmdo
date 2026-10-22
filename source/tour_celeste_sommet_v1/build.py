#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (24 trames @ 5 ticks = 120 ticks) :
STC1 — Sommet de la Tour Céleste — Arène de Rayquaza (`b71` + Planète Terre & Chemin Sud-Nord).

Garanties visuelles :
1. Zéro halo atmosphérique sur l'horizon terrestre ni autour de l'arène de Rayquaza : la Planète Terre
   (`STC1_02`, statique `1` pose) présente un contour net sur le cosmos étoilé (`STC1_00` & `STC1_01`).
2. Zéro liseré / coin blanc séparant l'arène `b71` des nuages périphériques : l'ourlet externe de `b71`
   est strictement pervenche (`[127, 167, 255]`) et s'adosse directement au massif nuageux bleu outremer
   (`STC1_03`, statique `1` pose) flanqué de ses croissants de vent (`STC1_04`, statique `1` pose).
3. Alizés terrestres, couronne nuageuse autour de l'arène et cumulus d'avant-plan (`STC1_09`, `Top`)
   strictement statiques (`poses = 1`) ; étoiles cosmiques (`STC1_00`, `STC1_01`) et reflets internes
   du sol nuageux (`STC1_08`) animés en `24` poses.
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
REPO_ROOT = HERE.parents[1]
if str(REPO_ROOT / "source") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "source"))

from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
    extract_canonical_palette,
    key_magenta,
    load_bpl_cyan_ramp,
    quantize_rgb_to_palette,
    quantize_rgba_to_palette,
)

MAP_ID = "STC1"
MAP_TITLE = "Sommet de la Tour Céleste — Arène de Rayquaza"
RAW_DIR = HERE / "bruts"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_celeste_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"

B71_RIM_SKYBLUE_RGB = np.array([127, 167, 255], dtype=np.uint8)
B71_RIM_DEEP_RGB = np.array([103, 143, 235], dtype=np.uint8)


def build_palettes() -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    b71_all = extract_canonical_palette([REF_DIR / "b71_sky_tower_summit.png"], max_colors=56, min_pixels=2)
    b71_cloud_list = [
        c.tolist()
        for c in b71_all
        if (
            not (int(c[0]) < 45 and int(c[1]) < 45 and int(c[2]) > 150)
            and (int(c[1]) >= int(c[0]) - 2)
            and (int(c[2]) >= 220)
        )
    ]
    b71_pal = np.array(b71_cloud_list, dtype=np.uint8)

    earth_pal = extract_canonical_palette(
        [
            REF_DIR / "ref_sommet_planete_rayquaza.png",
            RAW_DIR / "planete_terre_reference_exacte.png",
        ],
        max_colors=84,
        min_pixels=10,
    )
    extra_atmos = np.array(
        [
            [2, 6, 36],
            [4, 10, 52],
            [7, 18, 74],
            [12, 30, 102],
            [14, 58, 174],
            [18, 78, 192],
            [24, 96, 206],
            [30, 56, 164],
            [44, 74, 186],
            [62, 98, 208],
            [84, 126, 228],
            [108, 156, 242],
            [138, 188, 252],
            [36, 148, 226],
            [68, 182, 240],
        ],
        dtype=np.uint8,
    )
    earth_full = np.unique(np.vstack([earth_pal, extra_atmos]), axis=0).astype(np.uint8)
    unified_pal = np.unique(np.vstack([b71_pal, earth_full]), axis=0).astype(np.uint8)
    return b71_pal, earth_full, unified_pal


def extract_quadrant_sprite(
    raw_path: Path,
    quadrant: Tuple[float, float, float, float],
    palette: np.ndarray,
    target_size: Tuple[int, int],
) -> Image.Image | None:
    keyed = key_magenta(Image.open(raw_path), erode_fringe=3, min_component_area=80)
    raw_arr = np.asarray(keyed, dtype=np.uint8).copy()
    sh, sw = raw_arr.shape[:2]
    x0, y0, x1, y1 = (
        int(round(sw * quadrant[0])),
        int(round(sh * quadrant[1])),
        int(round(sw * quadrant[2])),
        int(round(sh * quadrant[3])),
    )
    sub = raw_arr[y0:y1, x0:x1, :].copy()
    ys, xs = np.where(sub[:, :, 3] > 0)
    if ys.size < 32:
        return None
    crop = sub[int(ys.min()) : int(ys.max()) + 1, int(xs.min()) : int(xs.max()) + 1].copy()
    crop = np.asarray(quantize_rgba_to_palette(Image.fromarray(crop, mode="RGBA"), palette), dtype=np.uint8)
    tw = max(16, int(target_size[0]))
    th = max(16, int(target_size[1]))
    return Image.fromarray(crop, mode="RGBA").resize((tw, th), Image.Resampling.NEAREST)


def extract_reference_arena_collar_layers(
    w: int,
    h: int,
    unified_pal: np.ndarray,
    arena_opaque_mask: np.ndarray,
) -> Tuple[Image.Image, Image.Image]:
    """Extrait le socle nuageux sculpté (`STC1_03`) et les deux grands croissants de vent latéraux
    (`STC1_04`) **sans aucun blanc résiduel autour de l'extrémité de l'arène** :
    - toute calotte blanche dépassant en haut ou sur les flancs immédiats de `arena_opaque_mask` est
      purgée / ramenée dans les bleus profonds du socle nuageux ;
    - `STC1_04` ne conserve que les deux grands croissants de vent extérieurs gauche et droit."""
    keyed = key_magenta(
        Image.open(RAW_DIR / "couronne_nuages_autour_arene_magenta.png"),
        erode_fringe=3,
        min_component_area=40,
    )
    k_arr = np.asarray(keyed, dtype=np.uint8).copy()
    ys_k, _ = np.where(k_arr[:, :, 3] > 0)
    if ys_k.size > 0:
        y_top_keep = max(0, int(ys_k.min()) - int(round(0.165 * k_arr.shape[0])))
        k_arr = k_arr[y_top_keep : int(ys_k.max()) + 1, :, :]
        keyed = Image.fromarray(k_arr, mode="RGBA")
    scaled = keyed.resize((w, h), Image.Resampling.NEAREST)
    s_arr = np.asarray(scaled, dtype=np.uint8).copy()

    yy, xx = np.mgrid[:h, :w]
    opaque_raw = s_arr[:, :, 3] > 0
    lum_raw = (
        0.299 * s_arr[:, :, 0].astype(np.float32)
        + 0.587 * s_arr[:, :, 1].astype(np.float32)
        + 0.114 * s_arr[:, :, 2].astype(np.float32)
    )

    # 1. Sélectionne par propagation de composantes connexes (`binary_propagation`) UNIQUEMENT les
    #    masses claires (`lum_raw >= 134`) qui touchent le voisinage immédiat de `arena_opaque_mask`
    #    afin de purger tout blanc collé à l'arène SANS AUCUNE coupure verticale rectiligne !
    touch_seed = ndimage.binary_dilation(arena_opaque_mask, iterations=max(5, int(round(0.035 * min(w, h)))))
    bright_blobs = opaque_raw & (lum_raw >= 134.0)
    bright_touching_arena = ndimage.binary_propagation(bright_blobs & touch_seed, mask=bright_blobs)

    # En haut de l'arène (`y < 0.34 * h`), cette calotte blanche dépassait dans le ciel -> supprimée
    top_cap_white = bright_touching_arena & (~arena_opaque_mask) & (yy < int(round(0.34 * h)))
    s_arr[top_cap_white] = 0
    opaque_raw = s_arr[:, :, 3] > 0

    # Sur les flancs de l'arène (`y >= 0.34 * h`), elle est ramenée en bleu cobalt profond du socle
    collar_bright = bright_touching_arena & (~arena_opaque_mask) & (~top_cap_white)
    s_arr[collar_bright, 0] = np.clip(s_arr[collar_bright, 0].astype(np.float32) * 0.34, 26, 82).astype(np.uint8)
    s_arr[collar_bright, 1] = np.clip(s_arr[collar_bright, 1].astype(np.float32) * 0.46, 54, 118).astype(np.uint8)
    s_arr[collar_bright, 2] = np.clip(s_arr[collar_bright, 2].astype(np.float32) * 0.84, 150, 212).astype(np.uint8)

    deep_collar = opaque_raw & (~collar_bright) & (lum_raw < 166.0)
    s_arr[deep_collar, 0] = np.clip(s_arr[deep_collar, 0].astype(np.float32) * 0.72, 0, 255).astype(np.uint8)
    s_arr[deep_collar, 1] = np.clip(s_arr[deep_collar, 1].astype(np.float32) * 0.78, 0, 255).astype(np.uint8)
    s_arr[deep_collar, 2] = np.clip(s_arr[deep_collar, 2].astype(np.float32) * 0.94, 0, 255).astype(np.uint8)

    q_rgba = np.asarray(quantize_rgba_to_palette(Image.fromarray(s_arr, mode="RGBA"), unified_pal), dtype=np.uint8)
    opaque = q_rgba[:, :, 3] > 0
    lum = (
        0.299 * q_rgba[:, :, 0].astype(np.float32)
        + 0.587 * q_rgba[:, :, 1].astype(np.float32)
        + 0.114 * q_rgba[:, :, 2].astype(np.float32)
    )
    crescent_mask = opaque & (~bright_touching_arena) & (lum >= 152.0)
    pedestal_mask = opaque & (~crescent_mask)

    arr_03 = np.zeros((h, w, 4), dtype=np.uint8)
    arr_03[pedestal_mask] = q_rgba[pedestal_mask]

    arr_04 = np.zeros((h, w, 4), dtype=np.uint8)
    arr_04[crescent_mask] = q_rgba[crescent_mask]

    return Image.fromarray(arr_03, mode="RGBA"), Image.fromarray(arr_04, mode="RGBA")


def extract_b71_arena_with_south_north_path(
    w: int,
    h: int,
    b71_pal: np.ndarray,
) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Assemble sans couture l'arène circulaire `1:1` de `b71_sky_tower_summit.png` et le chemin
    de nuages praticable **Sud -> Nord**, en garantissant **zéro pixel blanc sur tout le bord
    extérieur** (seul l'ourlet bleu pervenche entoure l'arène et le pont)."""
    b71_img = Image.open(REF_DIR / "b71_sky_tower_summit.png").convert("RGB")
    bw0, bh0 = b71_img.size
    if h == bh0 and w >= bw0:
        b71_scaled = np.asarray(b71_img, dtype=np.uint8).copy()
    else:
        target_bw = min(w, max(64, int(round(bw0 * (h / float(bh0))))))
        b71_scaled = np.asarray(
            b71_img.resize((target_bw, h), Image.Resampling.NEAREST),
            dtype=np.uint8,
        ).copy()

    bh, bw, _ = b71_scaled.shape
    x_off = (w - bw) // 2
    y_shift_up = (int(round(0.194 * h)) // TILE_SIZE) * TILE_SIZE

    r_ch = b71_scaled[:, :, 0].astype(np.int16)
    g_ch = b71_scaled[:, :, 1].astype(np.int16)
    b_ch = b71_scaled[:, :, 2].astype(np.int16)

    dome_seed = (g_ch >= 183) & ((g_ch - r_ch) >= 40) & (r_ch >= 135)
    lbl_s, n_s = ndimage.label(dome_seed)
    main_dome = (
        (lbl_s == (int(np.argmax(ndimage.sum(dome_seed, lbl_s, index=range(1, n_s + 1)))) + 1))
        if n_s > 0
        else dome_seed
    )
    main_dome_filled = ndimage.binary_fill_holes(ndimage.binary_dilation(main_dome, iterations=1))

    # À l'extérieur strict de `main_dome_filled`, on ne retient QUE le fin liseré bleu pervenche
    # de l'arène (`r < 176`, jamais les nuages blancs extérieurs de `b71_sky_tower_summit.png` !)
    blue_scallop_rim = (
        ndimage.binary_dilation(main_dome_filled, iterations=3)
        & (~main_dome_filled)
        & (b_ch >= 210)
        & (g_ch >= 120)
        & (r_ch < 176)
    )
    outer_1px_aa = (
        ndimage.binary_dilation(main_dome_filled | blue_scallop_rim, iterations=1)
        & (~(main_dome_filled | blue_scallop_rim))
    )
    b71_clean = b71_scaled.copy()
    b71_clean[outer_1px_aa] = B71_RIM_DEEP_RGB
    # Tout pixel dans une bande de 2 px à l'intérieur du bord extrême de `main_dome_filled` qui serait
    # blanc pur est adouci en bleu ciel `b71` pour éviter tout éclat blanc à l'extrémité
    dome_inner_edge = main_dome_filled & (~ndimage.binary_erosion(main_dome_filled, iterations=2))
    white_on_edge = dome_inner_edge & (r_ch >= 210) & (g_ch >= 235)
    b71_clean[white_on_edge] = B71_RIM_SKYBLUE_RGB

    fg_complete = main_dome_filled | blue_scallop_rim | outer_1px_aa

    arena_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    arena_dome_mask = np.zeros((h, w), dtype=bool)
    q_b71 = quantize_rgb_to_palette(b71_clean, b71_pal)

    src_y0 = y_shift_up
    dst_h = bh - src_y0
    sub_rgba = np.zeros((dst_h, bw, 4), dtype=np.uint8)
    m_sub = fg_complete[src_y0:, :]
    sub_rgba[m_sub, :3] = q_b71[src_y0:, :][m_sub]
    sub_rgba[m_sub, 3] = 255
    arena_rgba[:dst_h, x_off : x_off + bw, :] = sub_rgba
    arena_dome_mask[:dst_h, x_off : x_off + bw] = main_dome_filled[src_y0:, :]

    path_raw = Image.open(RAW_DIR / "chemin_sud_nord_b71_magenta.png")
    path_keyed = key_magenta(path_raw, erode_fringe=3, min_component_area=120)
    path_q = quantize_rgba_to_palette(path_keyed, b71_pal)
    p_arr = np.asarray(path_q, dtype=np.uint8)
    ps0 = int(p_arr.shape[0] * 0.08)
    ps1 = int(p_arr.shape[0] * 0.42)
    p_sub = p_arr[ps0:ps1, :, :]
    ys_p, xs_p = np.where(p_sub[:, :, 3] > 0)

    path_canvas = np.zeros((h, w, 4), dtype=np.uint8)
    if ys_p.size > 0:
        x0_p, x1_p = int(xs_p.min()), int(xs_p.max()) + 1
        strip_src = p_sub[:, x0_p:x1_p, :]
        sh_p, sw_p = strip_src.shape[:2]

        y_path_top = int(round(0.58 * h))
        path_len = max(16, h - y_path_top)
        for dy_i in range(path_len):
            y_dst = y_path_top + dy_i
            t_south = dy_i / float(max(1, path_len - 1))
            cur_w = max(24, int(round(w * (0.205 + 0.068 * t_south))))
            sy = min(sh_p - 1, int(round(t_south * (sh_p - 1))))
            sx_idx = np.clip(np.rint(np.linspace(0, sw_p - 1, cur_w)).astype(np.int32), 0, sw_p - 1)
            row_px = strip_src[sy, sx_idx, :].copy()
            # Adoucit les extrémités latérales du pont en bleu pervenche (jamais de blanc au bord !)
            edge_w = max(2, int(round(cur_w * 0.08)))
            row_px[:edge_w, :3] = B71_RIM_DEEP_RGB
            row_px[-edge_w:, :3] = B71_RIM_DEEP_RGB
            x_left = (w - cur_w) // 2
            path_canvas[y_dst, x_left : x_left + cur_w, :] = row_px

    def _extract_plateau_mask(rgba_in: np.ndarray) -> np.ndarray:
        m_valid = rgba_in[:, :, 3] > 0
        bright = m_valid & (rgba_in[:, :, 1] >= 225) & (rgba_in[:, :, 0] >= 180)
        lbl_b, n_b = ndimage.label(bright)
        if n_b == 0:
            return bright
        sz_b = ndimage.sum(bright, lbl_b, index=range(1, n_b + 1))
        return ndimage.binary_fill_holes(lbl_b == (int(np.argmax(sz_b)) + 1))

    arena_plateau = _extract_plateau_mask(arena_rgba)
    path_plateau = _extract_plateau_mask(path_canvas)
    path_solid = ndimage.binary_fill_holes(path_canvas[:, :, 3] > 0)

    combined_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    m_path_all = path_canvas[:, :, 3] > 0
    combined_rgba[m_path_all] = path_canvas[m_path_all]

    m_arena_all = arena_rgba[:, :, 3] > 0
    combined_rgba[m_arena_all] = arena_rgba[m_arena_all]

    throat_mask = path_plateau & (~arena_plateau)
    combined_rgba[throat_mask] = path_canvas[throat_mask]

    total_walkable_plateau = ndimage.binary_fill_holes(arena_plateau | path_plateau)
    total_solid_mask = arena_dome_mask | path_solid

    erode_rim = max(2, int(round(min(w, h) * 0.011)))
    inner_walk_mask = ndimage.binary_erosion(total_walkable_plateau, iterations=erode_rim)
    south_throat = total_walkable_plateau[-erode_rim - 2 :, :]
    inner_walk_mask[-erode_rim - 2 :, :] |= ndimage.binary_erosion(
        south_throat, structure=np.array([[0, 0, 0], [1, 1, 1], [0, 0, 0]], dtype=bool), iterations=erode_rim
    )

    crest_rim_mask = total_walkable_plateau & (~inner_walk_mask)
    outer_crown_mask = (combined_rgba[:, :, 3] > 0) & (~total_walkable_plateau)

    # Garantie absolue : sur `outer_crown_mask`, AUCUN pixel blanc (`R >= 185`) n'est autorisé !
    white_outer = outer_crown_mask & (combined_rgba[:, :, 0] >= 185)
    combined_rgba[white_outer, :3] = B71_RIM_SKYBLUE_RGB

    layer05_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer05_arr[outer_crown_mask] = combined_rgba[outer_crown_mask]

    layer06_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer06_arr[inner_walk_mask] = combined_rgba[inner_walk_mask]

    layer07_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer07_arr[crest_rim_mask] = combined_rgba[crest_rim_mask]

    return layer05_arr, layer06_arr, layer07_arr, total_solid_mask, inner_walk_mask


def build_earth_and_cosmos_layers(
    w: int,
    h: int,
    earth_pal: np.ndarray,
    unified_pal: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit :
    - `STC1_00` (`poses = 24`) : fond spatial bleu nuit profond + étoiles lointaines scintillantes,
    - `STC1_01` (`poses = 24`) : étoiles proches scintillantes du cosmos,
    - `STC1_02` (`poses = 1`)  : Planète Terre statique à contour net **SANS halo atmosphérique**
      (tout halo lumineux débordant dans l'espace ou clignotant sur l'horizon est supprimé)."""
    earth_src = np.asarray(
        Image.open(RAW_DIR / "planete_terre_reference_exacte.png")
        .convert("RGB")
        .resize((w, h), Image.Resampling.NEAREST),
        dtype=np.uint8,
    )

    xs = np.arange(w, dtype=np.float32)
    u_norm = (xs - 0.5 * w) / (0.5 * w)
    yy = np.arange(h, dtype=np.float32)[:, None]

    y_ref_limb = (0.130 * h + 0.106 * h * (u_norm**2))[None, :]
    y_src_limb = (0.222 * h + 0.188 * h * (u_norm**2))[None, :]

    rel_y = yy - y_ref_limb
    mapped_src_y = np.where(
        rel_y < 0.0,
        y_src_limb + rel_y,
        y_src_limb + rel_y * 0.88,
    )
    sy_idx = np.clip(np.rint(mapped_src_y).astype(np.int32), 0, h - 1)
    sx_idx = np.arange(w, dtype=np.int32)[None, :]
    warped_earth = earth_src[sy_idx, sx_idx].copy()

    inside_planet = rel_y >= 0.0
    depth_t = np.clip(rel_y / max(1.0, 0.72 * h), 0.0, 1.0)
    dark_coast_ink = inside_planet & (
        (warped_earth[:, :, 2] < 142) | ((warped_earth[:, :, 1] < 58) & (warped_earth[:, :, 2] < 172))
    )
    ocean_r = np.clip(np.rint(12.0 + 16.0 * depth_t), 0, 255).astype(np.uint8)
    ocean_g = np.clip(np.rint(82.0 - 34.0 * depth_t), 0, 255).astype(np.uint8)
    ocean_b = np.clip(np.rint(196.0 - 38.0 * depth_t), 0, 255).astype(np.uint8)
    ocean_floor = np.stack([ocean_r, ocean_g, ocean_b], axis=2)
    warped_earth[dark_coast_ink] = ocean_floor[dark_coast_ink]

    # Atténue également la bande blanche aveuglante de halo interne en haut du globe (`rel_y` dans `[0, 22]`)
    # afin d'obtenir une surface océanique/atmosphérique nette sans halo lumineux sur la zone Rayquaza
    bright_halo_cap = inside_planet & (rel_y < 24.0) & (warped_earth[:, :, 0] >= 150) & (warped_earth[:, :, 1] >= 220)
    t_limb = np.clip(rel_y / 24.0, 0.0, 1.0)
    cap_rgb = np.stack(
        [
            np.clip(np.rint(34.0 + 38.0 * t_limb), 0, 255).astype(np.uint8),
            np.clip(np.rint(142.0 + 46.0 * t_limb), 0, 255).astype(np.uint8),
            np.clip(np.rint(224.0 + 20.0 * t_limb), 0, 255).astype(np.uint8),
        ],
        axis=2,
    )
    warped_earth[bright_halo_cap] = cap_rgb[bright_halo_cap]

    planet_edge_1px = (rel_y >= -1.0) & (rel_y < 1.0)
    warped_earth[planet_edge_1px] = np.array([24, 96, 206], dtype=np.uint8)

    planet_q = quantize_rgb_to_palette(warped_earth, earth_pal)
    planet_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    planet_mask = rel_y >= -1.0
    planet_rgba[planet_mask, :3] = planet_q[planet_mask]
    planet_rgba[planet_mask, 3] = 255
    static_planet_02 = [Image.fromarray(planet_rgba, mode="RGBA")]

    # Espace sidéral pur sans halo (`STC1_00`) + étoiles lointaines scintillantes
    space_grad = np.clip((-rel_y) / max(1.0, 0.24 * h), 0.0, 1.0)
    space_step = np.round(space_grad * 3.0) / 3.0
    c_space_top = np.array([2.0, 6.0, 36.0], dtype=np.float32)[None, None, :]
    c_space_low = np.array([6.0, 14.0, 56.0], dtype=np.float32)[None, None, :]
    space_rgb = np.clip(
        np.rint(c_space_low * (1.0 - space_step[:, :, None]) + c_space_top * space_step[:, :, None]),
        0,
        255,
    ).astype(np.uint8)
    space_q = quantize_rgb_to_palette(space_rgb, earth_pal)

    deep_stars = [
        (0.04, 0.05, 1), (0.11, 0.13, 8), (0.18, 0.04, 15), (0.25, 0.09, 3),
        (0.34, 0.03, 11), (0.42, 0.08, 19), (0.58, 0.07, 6), (0.66, 0.03, 14),
        (0.75, 0.09, 21), (0.83, 0.05, 4), (0.90, 0.14, 12), (0.96, 0.06, 17),
        (0.07, 0.19, 20), (0.93, 0.19, 9),
    ]
    c_dim = quantize_rgb_to_palette(np.array([[[72, 112, 196]]], dtype=np.uint8), unified_pal)[0, 0]
    c_mid = quantize_rgb_to_palette(np.array([[[156, 212, 255]]], dtype=np.uint8), unified_pal)[0, 0]

    frames_00: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr0 = np.concatenate([space_q.copy(), np.full((h, w, 1), 255, dtype=np.uint8)], axis=2)
        for fx, fy, ph in deep_stars:
            px, py = int(w * fx), int(h * fy)
            if py >= int(y_ref_limb[0, px]) - 4:
                continue
            sv = np.sin(2.0 * np.pi * ((t + ph) / float(N_FRAMES)))
            if sv > 0.15:
                arr0[py, px, :3] = c_mid if sv > 0.68 else c_dim
        frames_00.append(Image.fromarray(arr0, mode="RGBA"))

    c_white = quantize_rgb_to_palette(np.array([[[255, 255, 255]]], dtype=np.uint8), unified_pal)[0, 0]
    c_cyan = quantize_rgb_to_palette(np.array([[[168, 240, 255]]], dtype=np.uint8), unified_pal)[0, 0]
    c_blue = quantize_rgb_to_palette(np.array([[[86, 152, 240]]], dtype=np.uint8), unified_pal)[0, 0]

    hero_stars = [
        (0.06, 0.09, 0, True),
        (0.15, 0.05, 6, False),
        (0.22, 0.11, 13, True),
        (0.31, 0.06, 19, False),
        (0.47, 0.05, 4, True),
        (0.55, 0.08, 11, False),
        (0.69, 0.05, 17, False),
        (0.79, 0.10, 22, True),
        (0.87, 0.06, 8, False),
        (0.94, 0.12, 15, True),
        (0.03, 0.16, 12, False),
        (0.97, 0.17, 3, False),
    ]
    frames_01: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr_st = np.zeros((h, w, 4), dtype=np.uint8)
        for fx, fy, ph_s, is_major in hero_stars:
            cx, cy = int(w * fx), int(h * fy)
            if cy >= int(y_ref_limb[0, cx]) - 5:
                continue
            s_val = np.sin(2.0 * np.pi * ((t + ph_s) / float(N_FRAMES)))
            if s_val < -0.35:
                arr_st[cy, cx, :3] = c_blue
                arr_st[cy, cx, 3] = 255
            elif s_val < 0.30:
                arr_st[cy, cx, :3] = c_cyan
                arr_st[cy, cx, 3] = 255
            elif s_val < 0.74 or not is_major:
                arr_st[cy, max(0, cx - 1) : min(w, cx + 2), :3] = c_cyan
                arr_st[cy, max(0, cx - 1) : min(w, cx + 2), 3] = 255
                arr_st[max(0, cy - 1) : min(h, cy + 2), cx, :3] = c_cyan
                arr_st[max(0, cy - 1) : min(h, cy + 2), cx, 3] = 255
                arr_st[cy, cx, :3] = c_white
            else:
                for arm in (-2, -1, 1, 2):
                    if 0 <= cx + arm < w:
                        arr_st[cy, cx + arm, :3] = c_blue if abs(arm) == 2 else c_cyan
                        arr_st[cy, cx + arm, 3] = 255
                    if 0 <= cy + arm < h:
                        arr_st[cy + arm, cx, :3] = c_blue if abs(arm) == 2 else c_cyan
                        arr_st[cy + arm, cx, 3] = 255
                arr_st[cy, cx, :3] = c_white
                arr_st[cy, cx, 3] = 255
        frames_01.append(Image.fromarray(arr_st, mode="RGBA"))

    return frames_00, frames_01, static_planet_02


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    bpl_path = REF_DIR / "rom_d13p01_bpl.json"
    b71_pal, earth_pal, unified_pal = build_palettes()

    # 1. Arène `1:1` de `b71_sky_tower_summit.png` + Chemin de nuages Sud -> Nord (zéro blanc aux bords !)
    layer05_arr, layer06_arr, layer07_arr, dome_solid_mask, arena_inner_mask = extract_b71_arena_with_south_north_path(
        w, h, b71_pal
    )
    arena_opaque_mask = (
        (layer05_arr[:, :, 3] > 0) | (layer06_arr[:, :, 3] > 0) | (layer07_arr[:, :, 3] > 0)
    )

    # 2. Cosmos étoilé scintillant (`00`, `01`) + Planète Terre nette SANS halo atmosphérique (`02` statique)
    frames_00, frames_01, static_planet_02 = build_earth_and_cosmos_layers(w, h, earth_pal, unified_pal)

    # 3. Massif nuageux sculpté & grands croissants de vent latéraux (`03` et `04` statiques, zéro blanc contre l'arène)
    static_collar_03, static_crescents_04 = extract_reference_arena_collar_layers(
        w, h, unified_pal, arena_opaque_mask
    )

    # 4. `STC1_08` : scintillement discret `D13P01.bpl` strictement confiné AUX CROISSANTS INTERNES du pavage `b71`
    #    (zéro halo périphérique autour de l'arène !)
    bpl_ramp = load_bpl_cyan_ramp(bpl_path, b71_pal)
    strictly_inside = ndimage.binary_erosion(arena_inner_mask, iterations=max(4, int(round(0.03 * min(w, h)))))
    inner_crescents = (
        strictly_inside
        & (layer06_arr[:, :, 0] >= 232)
        & (layer06_arr[:, :, 1] >= 245)
    )
    frames_08: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr_08 = np.zeros((h, w, 4), dtype=np.uint8)
        arr_08[inner_crescents, :3] = bpl_ramp[t]
        arr_08[inner_crescents, 3] = 255
        frames_08.append(Image.fromarray(arr_08, mode="RGBA"))

    # 5. `STC1_09` (`Top` `Layer = 4`) : cumulus d'avant-plan aux coins bas gauche et droit, STRICTEMENT STATIQUES (`poses = 1`)
    corner_pal = quantize_rgb_to_palette(
        np.array([[[88, 128, 224], [111, 151, 239], [135, 183, 255], [167, 215, 255]]], dtype=np.uint8),
        b71_pal,
    )[0]
    corner_bank_img = extract_quadrant_sprite(
        RAW_DIR / "ailes_et_cumulus_avant_magenta.png",
        (0.0, 0.50, 0.50, 1.0),
        corner_pal,
        (int(round(w * 0.255)), int(round(h * 0.39))),
    )
    im_top_static = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    if corner_bank_img is not None:
        bank_r = corner_bank_img.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        im_top_static.alpha_composite(corner_bank_img, (0, h - corner_bank_img.height))
        im_top_static.alpha_composite(bank_r, (w - bank_r.width, h - bank_r.height))
    arr_top_static = np.asarray(im_top_static, dtype=np.uint8).copy()
    arr_top_static[dome_solid_mask] = 0
    static_top_09 = Image.fromarray(arr_top_static, mode="RGBA")

    # Grille de collision 100 % visuelle : chemin Sud -> Nord continu jusqu'au plateau d'arène `b71`
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            block = arena_inner_mask[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(block.mean()) >= 0.65

    labeled_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        south_labels = set(labeled_w[-1, :].tolist()) - {0}
        if south_labels:
            walk_grid = np.isin(labeled_w, list(south_labels))

    layers = [
        LayerEntry("00_stratosphere_ultramarine", "Cosmos Etoile Profond", "BG", frames_00),
        LayerEntry("01_etoiles_stratosphere", "Etoiles Scintillantes Cosmos", "BG", frames_01),
        LayerEntry("02_horizon_planetaire_courbe", "Planete Terre Statique Sans Halo", "BG", static_planet_02),
        LayerEntry("03_nappes_altitude_profondes", "Massif Nuageux Autour Arene", "BG", [static_collar_03]),
        LayerEntry("04_ailes_vent_sculptees_proches", "Croissants Vent Autour Arene", "BG", [static_crescents_04]),
        LayerEntry("05_couronne_volumetrique_ombre", "Bordure Pervenche Arene & Pont b71", "BG", [Image.fromarray(layer05_arr, "RGBA")]),
        LayerEntry("06_sol_couronne_rayquaza", "Sol Arene & Chemin Sud-Nord b71", "BG", [Image.fromarray(layer06_arr, "RGBA")]),
        LayerEntry("07_reliefs_cretes_couronne", "Reliefs Cretes Arene & Chemin b71", "BG", [Image.fromarray(layer07_arr, "RGBA")]),
        LayerEntry("08_respiration_bpl_couronne", "Reflets Internes Nuages BPL", "BG", frames_08),
        LayerEntry("09_sillages_courants_jet", "Cumulus Avant-Plan Statiques", "Top", [static_top_09]),
    ]
    return layers, walk_grid, unified_pal


def main() -> None:
    layers, walk_grid, _ = build_layers_for_size(W_CANON, H_CANON)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=RENDERS_DIR,
        virtual_zip_path=VIRTUAL_ZIP,
        canonical_ref_for_fidelity=REF_DIR / "ref_sommet_planete_rayquaza.png",
        max_fidelity_distance=25.0,
    )
    print(json.dumps(meta, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
