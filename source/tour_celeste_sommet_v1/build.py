#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (24 trames @ 5 ticks = 120 ticks) :
STC1 — Sommet de la Tour Céleste — Arène de Rayquaza (`b71` + Planète Terre & Chemin Sud-Nord).

Réunit à l'échelle pixel exacte :
1. La Planète Terre vue de l'orbite fidèle à `references/ref_sommet_planete_rayquaza.png`
   (`bruts/planete_terre_reference_exacte.png` recalée exactement sur la courbure d'horizon
   `y = 75 px` au centre -> `y = 136 px` aux bords, continents turquoise lumineux sans contour noir,
   archipels, océans saphir-outremer continus jusqu'en bas sans aucune coupure horizontale,
   halo atmosphérique blanc-cyan et cosmos profond étoilé).
2. Deux plans indépendants de formations nuageuses orbitales en perspective rasante
   (`bruts/nuages_terre_perspective_magenta.png`, `dx = +16` et `dx = +8 px/trame`) dérivant
   d'ouest en est sur le globe sans masquer les continents.
3. L'arène circulaire de Rayquaza extraite `1:1` de `references/b71_sky_tower_summit.png`
   (`y_sommet = 103 px`), soutenue par son massif nuageux volumétrique bleu outremer profond
   et encadrée par ses deux ailes de vent incurvées en croissant (`ailes_et_cumulus_avant_magenta.png`),
   fusionnée sans aucune couture avec un chemin de nuages praticable **Sud -> Nord** à la même
   échelle de croissants `1:1` `b71` (`bruts/chemin_sud_nord_b71_magenta.png`, `y = 576 -> 352 px`).
4. Souffle lumineux `D13P01.bpl` et massifs cumulus d'avant-plan (`Top`, `Layer = 4`) aux coins bas.
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
    composite_sprite_periodic_path,
    extract_canonical_palette,
    extract_whole_cloud_sprites,
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


def build_palettes() -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Construit :
    - `b71_pal` : palette stricte des nuages canoniques `b71_sky_tower_summit.png`,
    - `earth_pal` : palette fidèle du globe terrestre, de ses continents turquoise, océans saphir,
      soubassement nuageux outremer, halo atmosphérique et cosmos étoilé,
    - `unified_pal` : union complète sans doublon."""
    b71_all = extract_canonical_palette([REF_DIR / "b71_sky_tower_summit.png"], max_colors=56, min_pixels=2)
    # Garde uniquement les vraies teintes froides bleu/cyan/blanc des nuages `b71` (`B > G >= R` ou blanc pur)
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
        max_colors=60,
        min_pixels=12,
    )
    extra_atmos = np.array(
        [
            [2, 6, 36],
            [4, 10, 52],
            [7, 18, 74],
            [12, 30, 102],
            [14, 58, 174],
            [18, 78, 192],
            [38, 66, 178],
            [54, 86, 198],
            [72, 110, 218],
            [94, 136, 236],
            [76, 206, 252],
            [124, 228, 255],
            [176, 246, 255],
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
    use_quantile_ramp: bool = False,
) -> Image.Image | None:
    """Extrait par détourage `#FF00FF` strict un sprite complet dans le quadrant `(x0, y0, x1, y1)`
    normalisé de `raw_path`, préserve tout son modelé interne sur `palette` et redimensionne en `NEAREST`."""
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
    if use_quantile_ramp and len(palette) >= 4:
        m = crop[:, :, 3] > 0
        lum = 0.299 * crop[:, :, 0].astype(np.float32) + 0.587 * crop[:, :, 1].astype(np.float32) + 0.114 * crop[:, :, 2].astype(np.float32)
        q28, q58, q84 = np.quantile(lum[m], [0.28, 0.58, 0.84])
        idx = np.zeros(crop.shape[:2], dtype=np.int32)
        idx[lum >= q28] = 1
        idx[lum >= q58] = 2
        idx[lum >= q84] = 3
        idx = ndimage.median_filter(idx, size=3)
        mapped = np.zeros_like(crop)
        mapped[m, :3] = palette[idx[m]]
        mapped[m, 3] = 255
        crop = mapped
    else:
        crop = np.asarray(quantize_rgba_to_palette(Image.fromarray(crop, mode="RGBA"), palette), dtype=np.uint8)
    tw = max(16, int(target_size[0]))
    th = max(16, int(target_size[1]))
    return Image.fromarray(crop, mode="RGBA").resize((tw, th), Image.Resampling.NEAREST)


def extract_b71_arena_with_south_north_path(
    w: int,
    h: int,
    b71_pal: np.ndarray,
) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Assemble sans couture :
    1. L'arène circulaire `1:1` de `b71_sky_tower_summit.png` calée à `y_sommet = 103 px` (`-14` tuiles),
    2. Le chemin de nuages praticable **Sud -> Nord** (`chemin_sud_nord_b71_magenta.png`) échantillonné
       à l'échelle exacte des croissants `b71` (une seule travée continue `y_src = 0.08..0.44` sans
       double étranglement, s'ouvrant largement sur le bord Sud `y = h`)."""
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
    y_shift_up = (int(round(0.194 * h)) // TILE_SIZE) * TILE_SIZE  # 112 px à h = 576

    r_ch = b71_scaled[:, :, 0].astype(np.int16)
    g_ch = b71_scaled[:, :, 1].astype(np.int16)
    b_ch = b71_scaled[:, :, 2].astype(np.int16)

    fg_cloud_pixels = (((g_ch - r_ch) >= 30) & (g_ch >= 158) & (b_ch >= 225)) | (
        (r_ch >= 235) & (g_ch >= 235) & (b_ch >= 235)
    )
    top_aa = (
        ndimage.binary_dilation(fg_cloud_pixels, iterations=1)
        & (~fg_cloud_pixels)
        & (b_ch >= 195)
        & (g_ch >= 40)
        & (np.arange(bh)[:, None] < int(bh * 0.48))
    )
    b71_clean = b71_scaled.copy()
    b71_clean[top_aa] = B71_RIM_SKYBLUE_RGB
    fg_raw = fg_cloud_pixels | top_aa

    dome_seed = (g_ch >= 183) & ((g_ch - r_ch) >= 40) & (r_ch >= 135)
    lbl_s, n_s = ndimage.label(dome_seed)
    main_dome = (lbl_s == (int(np.argmax(ndimage.sum(dome_seed, lbl_s, index=range(1, n_s + 1)))) + 1)) if n_s > 0 else dome_seed
    main_dome_filled = ndimage.binary_fill_holes(ndimage.binary_dilation(main_dome, iterations=2))
    fg_complete = fg_raw | main_dome_filled

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

    # Chemin Sud -> Nord : extrait une section régulière `y_src = 0.08..0.42` de `chemin_sud_nord_b71_magenta.png`
    # afin que la taille des croissants blancs `#FFFFFF` et des pointes `#8FBFFF` soit identique à `b71`
    # et que le pont s'évase régulièrement du col nord (`0.215 * w`) vers le bord sud (`0.285 * w`) sans étranglement !
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

        y_path_top = int(round(0.61 * h))  # 351 px (pénètre largement dans le dôme `#CFF7FF` qui va jusqu'à 395 px)
        path_len = max(16, h - y_path_top)  # 225 px
        for dy_i in range(path_len):
            y_dst = y_path_top + dy_i
            t_south = dy_i / float(max(1, path_len - 1))
            cur_w = max(24, int(round(w * (0.215 + 0.072 * t_south))))
            sy = min(sh_p - 1, int(round(t_south * (sh_p - 1))))
            sx_idx = np.clip(np.rint(np.linspace(0, sw_p - 1, cur_w)).astype(np.int32), 0, sw_p - 1)
            row_px = strip_src[sy, sx_idx, :]
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
) -> Tuple[
    List[Image.Image],
    List[Image.Image],
    List[Image.Image],
    List[np.ndarray],
    np.ndarray,
]:
    """Recale exactement `bruts/planete_terre_reference_exacte.png` sur la courbure d'horizon
    de `references/ref_sommet_planete_rayquaza.png` (`y = 75 px` au centre -> `y = 136 px` aux bords),
    adoucit les côtes dans la brume océanique bleue (zéro trait noir dur autour des continents)
    et prolonge harmonieusement l'océan saphir-outremer jusqu'en bas de l'écran sans aucune coupure."""
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

    # Adoucissement atmosphérique GBA des côtes sur le disque terrestre (`rel_y > 2 px`) :
    # remplace uniquement les pixels d'encrage quasi-noirs des contours côtiers par un bleu
    # océanique profond et lumineux fidèle à `ref_sommet_planete_rayquaza.png` (zéro ligne noire !)
    inside_planet = rel_y > 2.0
    depth_t = np.clip(rel_y / max(1.0, 0.72 * h), 0.0, 1.0)
    dark_coast_ink = inside_planet & (
        (warped_earth[:, :, 2] < 142) | ((warped_earth[:, :, 1] < 58) & (warped_earth[:, :, 2] < 172))
    )
    ocean_r = np.clip(np.rint(12.0 + 16.0 * depth_t), 0, 255).astype(np.uint8)
    ocean_g = np.clip(np.rint(82.0 - 34.0 * depth_t), 0, 255).astype(np.uint8)
    ocean_b = np.clip(np.rint(196.0 - 38.0 * depth_t), 0, 255).astype(np.uint8)
    ocean_floor = np.stack([ocean_r, ocean_g, ocean_b], axis=2)
    warped_earth[dark_coast_ink] = ocean_floor[dark_coast_ink]

    # Cosmos étoilé profond au-dessus du halo atmosphérique (`rel_y < -16 px`)
    deep_space_zone = rel_y < -16.0
    space_grad = np.clip((-rel_y - 16.0) / max(1.0, 0.20 * h), 0.0, 1.0)
    space_step = np.round(space_grad * 4.0) / 4.0
    c_space_top = np.array([2.0, 6.0, 38.0], dtype=np.float32)[None, None, :]
    c_space_low = np.array([6.0, 18.0, 68.0], dtype=np.float32)[None, None, :]
    clean_space_rgb = np.clip(
        np.rint(c_space_low * (1.0 - space_step[:, :, None]) + c_space_top * space_step[:, :, None]),
        0,
        255,
    ).astype(np.uint8)
    warped_earth[deep_space_zone] = clean_space_rgb[deep_space_zone]

    base_q = quantize_rgb_to_palette(warped_earth, earth_pal)

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
        arr0 = np.concatenate([base_q.copy(), np.full((h, w, 1), 255, dtype=np.uint8)], axis=2)
        for fx, fy, ph in deep_stars:
            px, py = int(w * fx), int(h * fy)
            if py >= int(y_ref_limb[0, px]) - 10:
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
            if cy >= int(y_ref_limb[0, cx]) - 10:
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

    orb_pal_a = quantize_rgb_to_palette(
        np.array([[[62, 184, 246], [108, 218, 255], [168, 242, 255]]], dtype=np.uint8),
        unified_pal,
    )[0]
    orb_pal_b = quantize_rgb_to_palette(
        np.array([[[48, 158, 236], [88, 198, 250], [142, 230, 255]]], dtype=np.uint8),
        unified_pal,
    )[0]

    pw_orb = max(96, ((w // 2) // 24) * 24)  # 384 px -> dx = +16 px/trame
    pw_slow = max(96, ((pw_orb // 2) // 24) * 24)  # 192 px -> dx = +8 px/trame
    step_orb = pw_orb // N_FRAMES
    step_slow = pw_slow // N_FRAMES
    band_h = max(64, int(round(0.28 * h)))

    orb_sprites_a = extract_whole_cloud_sprites(
        RAW_DIR / "nuages_terre_perspective_magenta.png",
        palette=orb_pal_a,
        scale_div=max(4, int(round(3600 / max(w, 1)))),
        min_area=12,
    )
    orb_sprites_b = extract_whole_cloud_sprites(
        RAW_DIR / "nuages_terre_perspective_magenta.png",
        palette=orb_pal_b,
        scale_div=max(4, int(round(3900 / max(w, 1)))),
        min_area=12,
    )

    belt_fast = np.zeros((band_h, pw_orb, 4), dtype=np.uint8)
    if orb_sprites_a:
        belt_pil = Image.new("RGBA", (pw_orb, band_h), (0, 0, 0, 0))
        placements_a = [
            (0, int(pw_orb * 0.05), int(band_h * 0.10), 0.42, 0.24),
            (min(5, len(orb_sprites_a) - 1), int(pw_orb * 0.52), int(band_h * 0.24), 0.72, 0.36),
            (min(6, len(orb_sprites_a) - 1), int(pw_orb * 0.28), int(band_h * 0.56), 0.68, 0.34),
            (min(1, len(orb_sprites_a) - 1), int(pw_orb * 0.66), int(band_h * 0.52), 0.36, 0.22),
        ]
        for s_idx, px0, py0, sx_k, sy_k in placements_a:
            sp = orb_sprites_a[s_idx]
            nw = max(14, min(pw_orb // 2, int(round(sp.width * sx_k))))
            nh = max(6, min(band_h // 4, int(round(sp.height * sy_k))))
            sp_r = sp.resize((nw, nh), Image.Resampling.NEAREST)
            for wrap_dx in (-pw_orb, 0, pw_orb):
                belt_pil.alpha_composite(sp_r, (px0 + wrap_dx, py0))
        belt_fast = np.asarray(belt_pil, dtype=np.uint8)

    belt_slow = np.zeros((band_h, pw_slow, 4), dtype=np.uint8)
    if orb_sprites_b:
        belt_s_pil = Image.new("RGBA", (pw_slow, band_h), (0, 0, 0, 0))
        for k_idx, (pxf, pyf) in enumerate([(0.08, 0.34), (0.58, 0.72)]):
            sp = orb_sprites_b[min(len(orb_sprites_b) - 1, 5 + k_idx)]
            nw = max(12, min(pw_slow // 2, int(round(sp.width * 0.62))))
            nh = max(6, min(band_h // 5, int(round(sp.height * 0.30))))
            sp_r = sp.resize((nw, nh), Image.Resampling.NEAREST)
            for wrap_dx in (-pw_slow, 0, pw_slow):
                belt_s_pil.alpha_composite(sp_r, (int(pw_slow * pxf) + wrap_dx, int(band_h * pyf)))
        belt_slow = np.asarray(belt_s_pil, dtype=np.uint8)

    rel_planet = yy - (y_ref_limb + 0.022 * h)
    in_planet_band = (rel_planet >= 0.0) & (rel_planet < float(band_h))
    norm_p = np.clip(rel_planet / float(band_h), 0.0, 0.999)
    v_orb = np.clip(np.rint((norm_p**0.88) * (band_h - 1)).astype(np.int32), 0, band_h - 1)
    x_row = np.arange(w, dtype=np.int32)[None, :]

    frames_02: List[Image.Image] = []
    planet_sub_frames: List[np.ndarray] = []
    for t in range(N_FRAMES):
        ux = (x_row - step_orb * t) % pw_orb
        fr2 = belt_fast[v_orb, ux].copy()
        fr2[~in_planet_band] = 0
        frames_02.append(Image.fromarray(fr2, mode="RGBA"))

        ux_s = (x_row - step_slow * t) % pw_slow
        frs = belt_slow[v_orb, ux_s].copy()
        frs[~in_planet_band] = 0
        planet_sub_frames.append(frs)

    return frames_00, frames_01, frames_02, planet_sub_frames, y_ref_limb


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    bpl_path = REF_DIR / "rom_d13p01_bpl.json"
    b71_pal, earth_pal, unified_pal = build_palettes()

    # 1. Arène `1:1` de `b71_sky_tower_summit.png` + Chemin de nuages Sud -> Nord fusionné sans couture
    layer05_arr, layer06_arr, layer07_arr, dome_solid_mask, arena_inner_mask = extract_b71_arena_with_south_north_path(
        w, h, b71_pal
    )

    # 2. Planète Terre exacte de la référence + Cosmos étoilé + 2 couches de nuages orbitaux
    frames_00, frames_01, frames_02, planet_sub_frames, _ = build_earth_and_cosmos_layers(
        w, h, earth_pal, unified_pal
    )

    # 3. Soubassement nuageux volumétrique bleu outremer profond (`Layer 03`) sous le dôme `b71`,
    #    ancré jusqu'au bas de l'écran (`y = h`) pour que seul son sommet festonné en vrais cumulus
    #    se découpe organiquement devant l'océan terrestre (ZÉRO bord droit flottant à mi-hauteur !)
    under_crown_pal = quantize_rgb_to_palette(
        np.array(
            [
                [[28, 52, 166], [46, 76, 192], [72, 108, 218], [108, 150, 242]],
            ],
            dtype=np.uint8,
        ),
        unified_pal,
    )[0]
    under_bank_h = int(round(h * 0.62))
    under_bank_w = int(round(w * 0.40))
    under_bank_l = extract_quadrant_sprite(
        RAW_DIR / "ailes_et_cumulus_avant_magenta.png",
        (0.0, 0.50, 0.50, 1.0),
        under_crown_pal,
        (under_bank_w, under_bank_h),
        use_quantile_ramp=True,
    )

    frames_03: List[Image.Image] = []
    for t in range(N_FRAMES):
        im3 = Image.fromarray(planet_sub_frames[t], mode="RGBA")
        if under_bank_l is not None:
            ang = 2.0 * np.pi * (t / float(N_FRAMES))
            dx_u = int(round(np.sin(ang))) * TILE_SIZE
            dy_u = max(0, int(round(np.cos(ang)))) * TILE_SIZE
            # `flip_lr` met les plus hauts sommets cumulus côté central (sous la couronne `b71`)
            # et descend organiquement vers les flancs extérieurs, posé tout en bas sur `y = h` !
            billow_left = under_bank_l.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
            billow_right = under_bank_l
            y_base = h - under_bank_h + dy_u
            im3.alpha_composite(billow_left, (int(round(w * 0.09)) - dx_u, y_base))
            im3.alpha_composite(billow_right, (w - int(round(w * 0.09)) - under_bank_w + dx_u, y_base))
        frames_03.append(im3)

    # 4. Sillages de nuages effilés divergents (`Layer 04`) prolongeant les cascades latérales de `b71`
    #    (sans anneaux épais ni crochets parasites) !
    wind_blade_pal = quantize_rgb_to_palette(
        np.array([[[135, 183, 255], [167, 215, 255], [207, 247, 255]]], dtype=np.uint8),
        b71_pal,
    )[0]
    summit_sprites = extract_whole_cloud_sprites(
        RAW_DIR / "poses_nuages_magenta.png",
        palette=wind_blade_pal,
        scale_div=max(3, int(round(2350 / max(w, 1)))),
        min_area=20,
    )
    flank_stream_arrays = [np.zeros((h, w, 4), dtype=np.uint8) for _ in range(N_FRAMES)]
    if summit_sprites:
        sp_wisp_r = summit_sprites[min(2, len(summit_sprites) - 1)].transpose(Image.Transpose.FLIP_TOP_BOTTOM)
        sp_wisp_l = sp_wisp_r.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        for sp, x0_p, y0_p, x1_p, y1_p, ph_s, arc_s in [
            (sp_wisp_l, w * 0.24, h * 0.42, w * 0.06, h * 0.66, 0, -w * 0.018),
            (sp_wisp_r, w * 0.76, h * 0.42, w * 0.94, h * 0.66, 0, +w * 0.018),
            (sp_wisp_l, w * 0.26, h * 0.56, w * 0.09, h * 0.80, 12, -w * 0.015),
            (sp_wisp_r, w * 0.74, h * 0.56, w * 0.91, h * 0.80, 12, +w * 0.015),
        ]:
            composite_sprite_periodic_path(flank_stream_arrays, sp, x0_p, y0_p, x1_p, y1_p, phase=ph_s, arc_px=arc_s)

    frames_04: List[Image.Image] = [Image.fromarray(flank_stream_arrays[t], mode="RGBA") for t in range(N_FRAMES)]

    # `Layer 08` : souffle `D13P01.bpl` sur l'ourlet de l'arène & du chemin + ondulation des cascades `b71`
    bpl_ramp = load_bpl_cyan_ramp(bpl_path, b71_pal)
    yy_full = np.arange(h, dtype=np.float32)[:, None]
    outer_rim_band = (
        (layer05_arr[:, :, 3] > 0)
        & ndimage.binary_dilation(arena_inner_mask | (layer07_arr[:, :, 3] > 0), iterations=2)
        & (layer05_arr[:, :, 1] >= 188)
    )
    cascades_only = (layer05_arr[:, :, 3] > 0) & (~dome_solid_mask)

    frames_08: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr_08 = np.zeros((h, w, 4), dtype=np.uint8)
        wave_phase = np.sin(2.0 * np.pi * (t / float(N_FRAMES)) - (yy_full / max(12.0, 0.14 * h)))
        lit_ripples = cascades_only & (wave_phase > 0.45)
        arr_08[lit_ripples, :3] = bpl_ramp[(t + 4) % N_FRAMES]
        arr_08[lit_ripples, 3] = 255
        arr_08[dome_solid_mask] = 0
        arr_08[outer_rim_band, :3] = bpl_ramp[t]
        arr_08[outer_rim_band, 3] = 255
        frames_08.append(Image.fromarray(arr_08, mode="RGBA"))

    # `Layer 09` (`Top` `Layer = 4`) : massifs cumulus d'avant-plan aux coins bas gauche et droit
    corner_pal = quantize_rgb_to_palette(
        np.array([[[111, 151, 239], [135, 183, 255], [167, 215, 255], [207, 247, 255]]], dtype=np.uint8),
        b71_pal,
    )[0]
    corner_bank_img = extract_quadrant_sprite(
        RAW_DIR / "ailes_et_cumulus_avant_magenta.png",
        (0.0, 0.50, 0.50, 1.0),
        corner_pal,
        (int(round(w * 0.255)), int(round(h * 0.39))),
    )

    top_arrays = [np.zeros((h, w, 4), dtype=np.uint8) for _ in range(N_FRAMES)]
    if summit_sprites:
        sp_puff_r = summit_sprites[min(2, len(summit_sprites) - 1)].transpose(Image.Transpose.FLIP_TOP_BOTTOM)
        sp_puff_l = sp_puff_r.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        for sp, x0_p, y0_p, x1_p, y1_p, ph_s, arc_s in [
            (sp_puff_l, w * 0.28, h * 0.72, w * 0.12, h * 0.90, 6, -w * 0.012),
            (sp_puff_r, w * 0.72, h * 0.72, w * 0.88, h * 0.90, 6, +w * 0.012),
        ]:
            composite_sprite_periodic_path(top_arrays, sp, x0_p, y0_p, x1_p, y1_p, phase=ph_s, arc_px=arc_s)

    frames_09: List[Image.Image] = []
    for t in range(N_FRAMES):
        im_top = Image.fromarray(top_arrays[t], mode="RGBA")
        if corner_bank_img is not None:
            ang = 2.0 * np.pi * (t / float(N_FRAMES))
            drift = int(round(np.sin(ang) * max(1.0, w * 0.008)))
            lift = int(round(np.cos(ang) * max(1.0, h * 0.006)))
            bank_r = corner_bank_img.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
            im_top.alpha_composite(corner_bank_img, (min(0, -4 + drift), h - corner_bank_img.height + max(0, lift)))
            im_top.alpha_composite(
                bank_r,
                (max(w - bank_r.width, w - bank_r.width + 4 - drift), h - bank_r.height + max(0, lift)),
            )
        arr_t = np.asarray(im_top, dtype=np.uint8).copy()
        arr_t[dome_solid_mask] = 0
        frames_09.append(Image.fromarray(arr_t, mode="RGBA"))

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
        LayerEntry("00_stratosphere_ultramarine", "Cosmos Etoile & Planete Terre", "BG", frames_00),
        LayerEntry("01_etoiles_stratosphere", "Etoiles Scintillantes Cosmos", "BG", frames_01),
        LayerEntry("02_horizon_planetaire_courbe", "Nuages Orbitaux & Spirales Terre", "BG", frames_02),
        LayerEntry("03_nappes_altitude_profondes", "Alizes Planete & Massif Nuageux", "BG", frames_03),
        LayerEntry("04_ailes_vent_sculptees_proches", "Ailes Vent Croissants & Sillages", "BG", frames_04),
        LayerEntry("05_couronne_volumetrique_ombre", "Couronne & Chemin Nuages b71", "BG", [Image.fromarray(layer05_arr, "RGBA")]),
        LayerEntry("06_sol_couronne_rayquaza", "Sol Arene & Chemin Sud-Nord b71", "BG", [Image.fromarray(layer06_arr, "RGBA")]),
        LayerEntry("07_reliefs_cretes_couronne", "Reliefs Cretes Arene & Chemin b71", "BG", [Image.fromarray(layer07_arr, "RGBA")]),
        LayerEntry("08_respiration_bpl_couronne", "Ondes Eoliennes & Souffle BPL", "BG", frames_08),
        LayerEntry("09_sillages_courants_jet", "Cumulus Avant-Plan & Sillages Jet", "Top", frames_09),
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
