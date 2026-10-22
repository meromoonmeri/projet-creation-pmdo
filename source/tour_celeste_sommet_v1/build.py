#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (24 trames @ 5 ticks = 120 ticks) :
STC1 — Sommet de la Tour Céleste — Arène de Rayquaza (`b71 / D13P03` + `D13P01.bpl`).

Architecture fidèle à 100 % à la référence canonique du dépôt `b71_sky_tower_summit.png`
(`b71_sol_crop_4x.png`) combinée au cosmos étoilé et à la planète courbe animée en multicalque :
- `00_stratosphere_ultramarine` (24 poses) : cosmos outremer étoilé + halo cyan atmosphérique
  + globe planétaire courbe (`planete_cosmos_base.png`) se fondant continûment dans la mer de
  nuages stratosphérique `#6F97EF` de `b71_sky_tower_summit.png`.
- `01_etoiles_stratosphere` (24 poses) : étoiles pixel-art GBA scintillant à phases décalées
  dans l'espace profond au-dessus du limbe planétaire.
- `02_horizon_planetaire_courbe` (24 poses) : spirales cycloniques & bandes nuageuses planétaires
  (`bande_nuages_planete_magenta.png`) tournant d'ouest en est (`dx = +16 px/trame`, période `384 px`)
  le long de la courbure sphérique de la planète derrière le sommet de Rayquaza.
- `03_nappes_altitude_profondes` (24 poses) : rubans nuageux planétaires lents (`dx = +8 px/trame`)
  en parallaxe sur le globe + courants d'altitude profonds divergents (`dx = -8/+8, dy = +8`).
- `04_ailes_vent_sculptees_proches` (24 poses) : grandes ailes de vent stratosphériques pervenche
  s'écartant à double vitesse horizontale (`dx = -16, dy = +8` à gauche ; `dx = +16, dy = +8` à droite).
- `05_couronne_volumetrique_ombre` (statique canonique `1:1`) : anneaux cumulus festonnés externes,
  cascades latérales effilées et ondes concentriques de base extraits pixel pour pixel de `b71`
  (`(G - R) >= 32`, zéro trapèze d'horizon résiduel, zéro tige artificielle).
- `06_sol_couronne_rayquaza` (statique canonique `1:1`) : dôme d'arène praticable `#CFF7FF` exact de
  `b71_sky_tower_summit.png` (`b71_sol_crop_4x.png`) avec ses croissants `#FFFFFF` et pointes `#8FBFFF`.
- `07_reliefs_cretes_couronne` (statique canonique `1:1`) : crêtes supérieures et rehauts `#CFF7FF` / `#B7E7FF`
  du dôme `b71` sans aucun contour noir.
- `08_respiration_bpl_couronne` (24 poses) : souffle lumineux `D13P01.bpl` sur l'ourlet des festons,
  pulsation harmonique des ondes concentriques de base `b71` et fines lames de vent courbes encadrant les flancs.
- `09_sillages_courants_jet` (`Top` `Layer = 4`, 24 poses) : bancs cumulus d'avant-plan aux angles inférieurs
  gauche et droit + sillages éoliens encadrant l'arène en parallaxe haute sans jamais masquer le dôme `b71`.
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
    make_fullscale_periodic_strip,
    quantize_rgb_to_palette,
    quantize_rgba_to_palette,
    render_symmetric_stream_frames,
)

MAP_ID = "STC1"
MAP_TITLE = "Sommet de la Tour Céleste — Arène de Rayquaza"
RAW_DIR = HERE / "bruts"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_celeste_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"

B71_SEA_RGB = np.array([98, 134, 234], dtype=np.uint8)
B71_RIM_SKYBLUE_RGB = np.array([127, 167, 255], dtype=np.uint8)


def build_unified_summit_palette() -> np.ndarray:
    """Construit la palette GBA unifiée réunissant toutes les teintes exactes de `b71_sky_tower_summit.png`,
    les bleus outremer cosmiques GBA et les nuances cyan-azur du limbe planétaire."""
    b71_pal = extract_canonical_palette([REF_DIR / "b71_sky_tower_summit.png"], max_colors=56, min_pixels=2)
    cosmos_pal = extract_canonical_palette(
        [RAW_DIR / "planete_cosmos_base.png", RAW_DIR / "bande_nuages_planete_magenta.png"],
        max_colors=24,
        min_pixels=24,
    )
    keep_cosmos = []
    for c in cosmos_pal:
        r, g, b = int(c[0]), int(c[1]), int(c[2])
        if r >= 165 and b >= 165 and g <= 120:
            continue
        keep_cosmos.append([r, g, b])
    extra_steps = [
        [2, 6, 136],
        [4, 12, 154],
        [6, 18, 170],
        [10, 28, 184],
        [16, 48, 198],
        [22, 84, 214],
        [28, 120, 232],
        [44, 160, 246],
        [84, 206, 255],
        [152, 242, 255],
        [95, 127, 231],
        [98, 134, 234],
        [111, 151, 239],
    ]
    merged = np.vstack([b71_pal, np.array(keep_cosmos + extra_steps, dtype=np.uint8)])
    return np.unique(merged, axis=0).astype(np.uint8)


def extract_canonical_b71_arena_layers(
    w: int,
    h: int,
    palette: np.ndarray,
) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Extrait pixel pour pixel à l'échelle `1:1` l'arène centrale `b71_sky_tower_summit.png` :
    - Tous les nuages sculptés, anneaux festonnés, cascades latérales et ondes concentriques de `b71`
      vérifient exactement `(G - R) >= 30` ou `R >= 240` (`#FFFFFF`), tandis que 100 % de la brume
      d'horizon lavande de `b71` vérifie `(G - R) <= 24` -> zéro découpe rectangulaire sur les côtés !"""
    b71_img = Image.open(REF_DIR / "b71_sky_tower_summit.png").convert("RGB")
    bw0, bh0 = b71_img.size  # 552 x 576
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

    r_ch = b71_scaled[:, :, 0].astype(np.int16)
    g_ch = b71_scaled[:, :, 1].astype(np.int16)
    b_ch = b71_scaled[:, :, 2].astype(np.int16)

    # Critère spectral exact mesuré sur les 76 couleurs de `b71_sky_tower_summit.png` :
    # - Exclus explicitement la mer de nuages de fond `#6F97EF` `(111,151,239)` & `#7797EF` `(119,151,239)` (`g <= 155`)
    #   ainsi que la brume lavande d'horizon (`(g - r) <= 24`) !
    # - Conserve à 100 % le dôme, tous les festons, toutes les cascades effilées et toutes les ondes en croissant (`g >= 158` et `g - r >= 30`) !
    fg_cloud_pixels = (((g_ch - r_ch) >= 30) & (g_ch >= 158) & (b_ch >= 225)) | (
        (r_ch >= 235) & (g_ch >= 235) & (b_ch >= 235)
    )

    # Liseré anti-aliasé supérieur des festons (`#372FC7` / `#4F4FD7` en haut du dôme) remappé en `#7FA7FF`
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

    # Sphère centrale compacte bouchée (`binary_fill_holes`) pour conserver intacts ses creux d'ombre `#6F97EF` internes
    # sans jamais déborder sur les cascades latérales externes !
    dome_seed = (g_ch >= 183) & ((g_ch - r_ch) >= 40) & (r_ch >= 135)
    lbl_s, n_s = ndimage.label(dome_seed)
    if n_s > 0:
        sz_s = ndimage.sum(dome_seed, lbl_s, index=range(1, n_s + 1))
        main_dome = lbl_s == (int(np.argmax(sz_s)) + 1)
    else:
        main_dome = dome_seed
    main_dome_filled = ndimage.binary_fill_holes(ndimage.binary_dilation(main_dome, iterations=2))
    fg_complete = fg_raw | main_dome_filled

    full_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    sub_rgba = np.zeros((bh, bw, 4), dtype=np.uint8)
    q_sub = quantize_rgb_to_palette(b71_clean, palette)
    sub_rgba[fg_complete, :3] = q_sub[fg_complete]
    sub_rgba[fg_complete, 3] = 255
    full_rgba[:, x_off : x_off + bw, :] = sub_rgba

    full_mask = full_rgba[:, :, 3] > 0
    full_dome_solid = np.zeros((h, w), dtype=bool)
    full_dome_solid[:, x_off : x_off + bw] = main_dome_filled

    # Plateau praticable central `#CFF7FF` (+ croissants `#FFFFFF` et pointes `#8FBFFF` internes)
    is_bright_plateau = full_mask & (full_rgba[:, :, 1] >= 225) & (full_rgba[:, :, 0] >= 180)
    lbl_plat, n_plat = ndimage.label(is_bright_plateau)
    if n_plat > 0:
        sz_plat = ndimage.sum(is_bright_plateau, lbl_plat, index=range(1, n_plat + 1))
        plateau_filled = ndimage.binary_fill_holes(lbl_plat == (int(np.argmax(sz_plat)) + 1))
    else:
        plateau_filled = is_bright_plateau

    erode_rim = max(2, int(round(min(w, h) * 0.012)))
    arena_inner_mask = ndimage.binary_erosion(plateau_filled, iterations=erode_rim)
    crest_rim_mask = plateau_filled & (~arena_inner_mask)
    outer_crown_and_cascades_mask = full_mask & (~plateau_filled)

    layer05_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer05_arr[outer_crown_and_cascades_mask] = full_rgba[outer_crown_and_cascades_mask]

    layer06_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer06_arr[arena_inner_mask] = full_rgba[arena_inner_mask]

    layer07_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer07_arr[crest_rim_mask] = full_rgba[crest_rim_mask]

    return layer05_arr, layer06_arr, layer07_arr, full_dome_solid, arena_inner_mask


def build_cosmos_and_planet_layers(
    w: int,
    h: int,
    palette: np.ndarray,
) -> Tuple[
    List[Image.Image],
    List[Image.Image],
    List[Image.Image],
    List[Image.Image],
    np.ndarray,
    np.ndarray,
]:
    """Construit le cosmos outremer étoilé + le globe planétaire courbe (`planete_cosmos_base.png`)
    + DEUX couches indépendantes de nuages planétaires (`bande_nuages_planete_magenta.png`) tournant
    à deux vitesses (`dx = +16` et `dx = +8`) le long de la courbure sphérique de la planète !"""
    cosmos_src = np.asarray(
        Image.open(RAW_DIR / "planete_cosmos_base.png").convert("RGB").resize((w, h), Image.Resampling.NEAREST),
        dtype=np.float32,
    )

    xs = np.arange(w, dtype=np.float32)
    u_norm = (xs - 0.5 * w) / (0.5 * w)
    yy = np.arange(h, dtype=np.float32)[:, None]

    # Courbe sphérique du limbe de la Terre (`y = 148 px` au centre pour `h = 576`, soit `67 px` au-dessus
    # du sommet `b71` à `215 px`, et `y = 266 px` aux bords latéraux)
    y_limb = (0.257 * h + 0.205 * h * (u_norm**2))[None, :]

    c0, c1 = max(0, w // 2 - 4), min(w, w // 2 + 5)
    col_clean = np.median(cosmos_src[:, c0:c1, :], axis=1).copy()
    src_limb_y = 0.352 * h

    rel_from_limb = yy - y_limb
    src_y = np.where(
        rel_from_limb < 0.0,
        src_limb_y + rel_from_limb * (src_limb_y / max(1.0, 0.257 * h)),
        src_limb_y + rel_from_limb * 1.20,
    )
    src_y_idx = np.clip(np.rint(src_y).astype(np.int32), 0, h - 1)
    bg_rgb = col_clean[src_y_idx].copy()

    # Enrichit l'espace profond d'une vraie teinte outremer cosmique GBA (`#020688 -> #0E2AB8`) fidèle à `b71`
    # avec transition progressive continue dès la sortie du halo cyan (`rel_from_limb <= +2 px`) -> zéro liseré noir !
    w_space = np.round(np.clip((2.0 - rel_from_limb) / 10.0, 0.0, 1.0) * 5.0) / 5.0 * 0.88
    space_depth = np.clip((-rel_from_limb) / max(1.0, 0.28 * h), 0.0, 1.0)
    space_step = np.round(space_depth * 5.0) / 5.0
    space_top = np.array([2.0, 6.0, 148.0], dtype=np.float32)[None, None, :]
    space_near = np.array([12.0, 38.0, 192.0], dtype=np.float32)[None, None, :]
    space_tint = space_near * (1.0 - space_step[:, :, None]) + space_top * space_step[:, :, None]
    bg_rgb = bg_rgb * (1.0 - w_space[:, :, None]) + space_tint * w_space[:, :, None]

    # Fondu atmosphérique net en 6 paliers GBA de l'océan planétaire vers la mer de nuages `B71_SEA_RGB`
    y_blend_start = y_limb + 0.145 * h
    y_blend_end = y_limb + 0.275 * h
    t_sea = np.clip((yy - y_blend_start) / np.maximum(1.0, y_blend_end - y_blend_start), 0.0, 1.0)
    t_step = np.round(t_sea * 6.0) / 6.0
    sea_f = B71_SEA_RGB.astype(np.float32)[None, None, :]
    bg_rgb = bg_rgb * (1.0 - t_step[:, :, None]) + sea_f * t_step[:, :, None]

    base_q = quantize_rgb_to_palette(np.clip(np.rint(bg_rgb), 0, 255).astype(np.uint8), palette)

    deep_stars = [
        (0.05, 0.05, 2), (0.12, 0.18, 9), (0.19, 0.08, 16), (0.27, 0.15, 4),
        (0.36, 0.04, 12), (0.44, 0.14, 20), (0.56, 0.13, 7), (0.63, 0.05, 15),
        (0.73, 0.15, 22), (0.81, 0.07, 5), (0.89, 0.19, 13), (0.95, 0.06, 18),
        (0.07, 0.30, 11), (0.93, 0.29, 3), (0.15, 0.26, 21), (0.85, 0.25, 8),
    ]
    c_star_dim = quantize_rgb_to_palette(np.array([[[72, 108, 212]]], dtype=np.uint8), palette)[0, 0]
    c_star_mid = quantize_rgb_to_palette(np.array([[[152, 206, 255]]], dtype=np.uint8), palette)[0, 0]

    frames_00: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr0 = np.concatenate([base_q.copy(), np.full((h, w, 1), 255, dtype=np.uint8)], axis=2)
        for fx, fy, ph in deep_stars:
            px, py = int(w * fx), int(h * fy)
            if py >= int(y_limb[0, px]) - 8:
                continue
            sv = np.sin(2.0 * np.pi * ((t + ph) / float(N_FRAMES)))
            if sv > 0.20:
                arr0[py, px, :3] = c_star_mid if sv > 0.70 else c_star_dim
        frames_00.append(Image.fromarray(arr0, mode="RGBA"))

    # `Layer 01` : étoiles scintillantes & croix stellaires GBA dans l'espace profond
    c_white = quantize_rgb_to_palette(np.array([[[255, 255, 255]]], dtype=np.uint8), palette)[0, 0]
    c_cyan = quantize_rgb_to_palette(np.array([[[152, 242, 255]]], dtype=np.uint8), palette)[0, 0]
    c_blue = quantize_rgb_to_palette(np.array([[[84, 156, 248]]], dtype=np.uint8), palette)[0, 0]

    hero_stars = [
        (0.08, 0.10, 0, True),
        (0.21, 0.06, 6, False),
        (0.31, 0.16, 13, True),
        (0.45, 0.07, 19, True),
        (0.54, 0.16, 3, False),
        (0.68, 0.08, 10, True),
        (0.79, 0.17, 17, False),
        (0.91, 0.11, 22, True),
        (0.04, 0.22, 8, False),
        (0.14, 0.32, 15, False),
        (0.39, 0.11, 21, False),
        (0.61, 0.11, 5, False),
        (0.86, 0.31, 12, False),
        (0.96, 0.22, 18, False),
    ]
    frames_01: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr_st = np.zeros((h, w, 4), dtype=np.uint8)
        for fx, fy, ph_s, is_major in hero_stars:
            cx, cy = int(w * fx), int(h * fy)
            if cy >= int(y_limb[0, cx]) - 10:
                continue
            s_val = np.sin(2.0 * np.pi * ((t + ph_s) / float(N_FRAMES)))
            if s_val < -0.35:
                arr_st[cy, cx, :3] = c_blue
                arr_st[cy, cx, 3] = 255
            elif s_val < 0.30:
                arr_st[cy, cx, :3] = c_cyan
                arr_st[cy, cx, 3] = 255
            elif s_val < 0.72 or not is_major:
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

    # Extraction propre sur `#FF00FF` des spirales et rubans nuageux planétaires (`bande_nuages_planete_magenta.png`)
    planet_cloud_pal = quantize_rgb_to_palette(
        np.array([[[68, 178, 250], [116, 214, 255], [168, 238, 255], [214, 250, 255]]], dtype=np.uint8),
        palette,
    )[0]
    planet_sub_pal = quantize_rgb_to_palette(
        np.array([[[56, 152, 242], [96, 192, 252], [143, 218, 255]]], dtype=np.uint8),
        palette,
    )[0]

    pw_orb = max(96, ((w // 2) // 24) * 24)  # 384 px -> dx = +16 px/trame
    pw_slow = max(96, ((pw_orb // 2) // 24) * 24)  # 192 px -> dx = +8 px/trame
    step_orb = pw_orb // N_FRAMES
    step_slow = pw_slow // N_FRAMES
    band_h = max(48, int(round(0.185 * h)))

    planet_sprites = extract_whole_cloud_sprites(
        RAW_DIR / "bande_nuages_planete_magenta.png",
        palette=planet_cloud_pal,
        scale_div=max(3, int(round(2750 / max(w, 1)))),
        min_area=18,
    )
    ribbon_sprites = extract_whole_cloud_sprites(
        RAW_DIR / "bande_nuages_planete_magenta.png",
        palette=planet_sub_pal,
        scale_div=max(3, int(round(3000 / max(w, 1)))),
        min_area=16,
    )

    belt_fast = np.zeros((band_h, pw_orb, 4), dtype=np.uint8)
    if planet_sprites:
        belt_pil = Image.new("RGBA", (pw_orb, band_h), (0, 0, 0, 0))
        placements = [
            (0, int(pw_orb * 0.04), int(band_h * 0.14), 0.50, 0.38),
            (1 % len(planet_sprites), int(pw_orb * 0.54), int(band_h * 0.18), 0.48, 0.36),
            (2 % len(planet_sprites), int(pw_orb * 0.31), int(band_h * 0.06), 0.56, 0.30),
            (3 % len(planet_sprites), int(pw_orb * 0.78), int(band_h * 0.48), 0.56, 0.30),
        ]
        for s_idx, px0, py0, sx_k, sy_k in placements:
            sp = planet_sprites[s_idx]
            nw = max(14, min(pw_orb - 8, int(round(sp.width * sx_k))))
            nh = max(8, min(band_h - 6, int(round(sp.height * sy_k))))
            sp_r = sp.resize((nw, nh), Image.Resampling.NEAREST)
            for wrap_dx in (-pw_orb, 0, pw_orb):
                belt_pil.alpha_composite(sp_r, (px0 + wrap_dx, py0))
        belt_fast = np.asarray(belt_pil, dtype=np.uint8)

    belt_slow = np.zeros((band_h, pw_slow, 4), dtype=np.uint8)
    if len(ribbon_sprites) >= 3:
        belt_s_pil = Image.new("RGBA", (pw_slow, band_h), (0, 0, 0, 0))
        for k_idx, (pxf, pyf) in enumerate([(0.06, 0.52), (0.54, 0.64)]):
            sp = ribbon_sprites[(2 + k_idx) % len(ribbon_sprites)]
            nw = max(14, min(pw_slow - 8, int(round(sp.width * 0.58))))
            nh = max(6, min(band_h - 6, int(round(sp.height * 0.28))))
            sp_r = sp.resize((nw, nh), Image.Resampling.NEAREST)
            for wrap_dx in (-pw_slow, 0, pw_slow):
                belt_s_pil.alpha_composite(sp_r, (int(pw_slow * pxf) + wrap_dx, int(band_h * pyf)))
        belt_slow = np.asarray(belt_s_pil, dtype=np.uint8)

    rel_planet = yy - (y_limb + 0.014 * h)
    in_planet_band = (rel_planet >= 0.0) & (rel_planet < float(band_h))
    norm_p = np.clip(rel_planet / float(band_h), 0.0, 0.999)
    v_orb = np.clip(np.rint((norm_p**0.85) * (band_h - 1)).astype(np.int32), 0, band_h - 1)
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

    below_limb_mask = yy >= (y_limb + 0.215 * h)
    return frames_00, frames_01, frames_02, planet_sub_frames, y_limb, below_limb_mask


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    bpl_path = REF_DIR / "rom_d13p01_bpl.json"
    palette = build_unified_summit_palette()

    # 1. Extraction canonique 100 % pure de `b71_sky_tower_summit.png` (zéro trapèze, zéro tige !)
    layer05_arr, layer06_arr, layer07_arr, dome_solid_mask, arena_inner_mask = extract_canonical_b71_arena_layers(
        w, h, palette
    )

    # 2. Cosmos outremer étoilé + Planète courbe + 2 plans de nuages planétaires tournants
    (
        frames_00,
        frames_01,
        frames_02,
        planet_sub_frames,
        _y_limb,
        below_limb_mask,
    ) = build_cosmos_and_planet_layers(w, h, palette)

    # 3. Deux plans de nappes & ailes de vent stratosphériques pervenche divergentes
    #    (contrastées en bleu pervenche doux `#7FA7FF / #8FBFFF / #AFCFFF` comme dans `b71` pour que
    #     le dôme blanc-glace `#CFF7FF` de l'arène ressorte avec un éclat royal au centre !)
    plume_src = Image.open(RAW_DIR / "nuages_courant_altitude.png").convert("RGB")
    wings_src = plume_src.transpose(Image.Transpose.FLIP_TOP_BOTTOM)

    wing_pal_deep = quantize_rgb_to_palette(
        np.array([[[103, 139, 235], [119, 151, 239], [135, 167, 247]]], dtype=np.uint8),
        palette,
    )[0]
    wing_pal_near = quantize_rgb_to_palette(
        np.array([[[119, 159, 247], [135, 175, 255], [159, 199, 255]]], dtype=np.uint8),
        palette,
    )[0]

    pw_half = max(96, (w // 2 // 24) * 24)  # 384 px
    ph_band = max(96, (h // 3 // 24) * 24)  # 192 px
    pw_slow = max(96, (pw_half // 2 // 24) * 24)  # 192 px
    step_fast = pw_half // N_FRAMES  # 16 px/trame
    step_slow = pw_slow // N_FRAMES  # 8 px/trame

    tile_wings_deep = make_fullscale_periodic_strip(
        wings_src,
        canvas_w=w,
        canvas_h=h,
        crop_box=(0, int(h * 0.25), pw_slow, int(h * 0.25) + ph_band),
        period_w=pw_slow,
        period_h=ph_band,
        palette=wing_pal_deep,
        keep_mask_fn=lambda rgb: (0.299 * rgb[:, :, 0] + 0.587 * rgb[:, :, 1] + 0.114 * rgb[:, :, 2]) >= 166.0,
        min_blob_area=260,
    )
    frames_03_base = render_symmetric_stream_frames(
        tile_wings_deep,
        w,
        h,
        step_inward_x=-step_slow,
        step_upward_y=-step_slow,
        mask_keep=below_limb_mask,
    )
    frames_03: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr3 = np.asarray(frames_03_base[t], dtype=np.uint8).copy()
        sub_p = planet_sub_frames[t]
        m_p = sub_p[:, :, 3] > 0
        arr3[m_p] = sub_p[m_p]
        frames_03.append(Image.fromarray(arr3, mode="RGBA"))

    yy_full = np.arange(h, dtype=np.float32)[:, None]
    lower_wings_zone = yy_full >= (_y_limb + 0.245 * h)
    tile_wings_near = make_fullscale_periodic_strip(
        wings_src,
        canvas_w=w,
        canvas_h=h,
        crop_box=(int(w * 0.12), int(h * 0.16), int(w * 0.12) + pw_half, int(h * 0.16) + ph_band),
        period_w=pw_half,
        period_h=ph_band,
        palette=wing_pal_near,
        keep_mask_fn=lambda rgb: (0.299 * rgb[:, :, 0] + 0.587 * rgb[:, :, 1] + 0.114 * rgb[:, :, 2]) >= 182.0,
        min_blob_area=340,
    )
    frames_04 = render_symmetric_stream_frames(
        tile_wings_near,
        w,
        h,
        step_inward_x=-step_fast,
        step_upward_y=-step_slow,
        mask_keep=lower_wings_zone,
    )

    # `Layer 08` : souffle lumineux `D13P01.bpl` sur l'ourlet de `b71`, pulsation progressive des ondes
    # concentriques de base `b71` et fines lames éoliennes `poses_nuages_magenta.png` encadrant les flancs !
    bpl_ramp = load_bpl_cyan_ramp(bpl_path, palette)
    outer_rim_band = (
        (layer05_arr[:, :, 3] > 0)
        & ndimage.binary_dilation(arena_inner_mask | (layer07_arr[:, :, 3] > 0), iterations=2)
        & (layer05_arr[:, :, 1] >= 188)
    )
    cascades_and_ripples = (layer05_arr[:, :, 3] > 0) & (~dome_solid_mask)
    yy_idx = np.arange(h, dtype=np.float32)[:, None]

    wind_blade_pal = quantize_rgb_to_palette(
        np.array([[[135, 183, 255], [167, 215, 255], [207, 247, 255]]], dtype=np.uint8),
        palette,
    )[0]
    summit_sprites = extract_whole_cloud_sprites(
        RAW_DIR / "poses_nuages_magenta.png",
        palette=wind_blade_pal,
        scale_div=max(3, int(round(2100 / max(w, 1)))),
        min_area=20,
    )
    blade_arrays = [np.zeros((h, w, 4), dtype=np.uint8) for _ in range(N_FRAMES)]
    if summit_sprites:
        sp_streak_r = summit_sprites[min(2, len(summit_sprites) - 1)].transpose(Image.Transpose.FLIP_TOP_BOTTOM)
        sp_streak_l = sp_streak_r.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        flank_paths = [
            (sp_streak_l, w * 0.24, h * 0.50, w * 0.06, h * 0.72, 0, -w * 0.018),
            (sp_streak_r, w * 0.76, h * 0.50, w * 0.94, h * 0.72, 0, +w * 0.018),
            (sp_streak_l, w * 0.21, h * 0.60, w * 0.04, h * 0.84, 12, -w * 0.014),
            (sp_streak_r, w * 0.79, h * 0.60, w * 0.96, h * 0.84, 12, +w * 0.014),
        ]
        for sp, x0_p, y0_p, x1_p, y1_p, ph_s, arc_s in flank_paths:
            composite_sprite_periodic_path(blade_arrays, sp, x0_p, y0_p, x1_p, y1_p, phase=ph_s, arc_px=arc_s)

    frames_08: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr_08 = blade_arrays[t].copy()
        arr_08[outer_rim_band, :3] = bpl_ramp[t]
        arr_08[outer_rim_band, 3] = 255
        # Onde descendante harmonique parcourant les cascades et les croissants concentriques de `b71` !
        wave_phase = np.sin(2.0 * np.pi * (t / float(N_FRAMES)) - (yy_idx / max(12.0, 0.14 * h)))
        lit_ripples = cascades_and_ripples & (wave_phase > 0.45)
        arr_08[lit_ripples, :3] = bpl_ramp[(t + 4) % N_FRAMES]
        arr_08[lit_ripples, 3] = 255
        arr_08[dome_solid_mask] = 0
        arr_08[outer_rim_band, :3] = bpl_ramp[t]
        arr_08[outer_rim_band, 3] = 255
        frames_08.append(Image.fromarray(arr_08, mode="RGBA"))

    # `Layer 09` (`Top` `Layer = 4`) : bancs cumulus d'avant-plan aux coins inférieurs gauche & droit
    corner_pal = quantize_rgb_to_palette(
        np.array([[[111, 151, 239], [135, 183, 255], [167, 215, 255], [207, 247, 255]]], dtype=np.uint8),
        palette,
    )[0]
    corner_bank_raw = key_magenta(
        Image.open(RAW_DIR / "ailes_et_cumulus_avant_magenta.png"),
        erode_fringe=2,
        min_component_area=80,
    )
    cb_arr = np.asarray(quantize_rgba_to_palette(corner_bank_raw, corner_pal), dtype=np.uint8)
    ch_src, cw_src = cb_arr.shape[:2]
    sub_bank = cb_arr[ch_src // 2 :, : cw_src // 2, :]
    ys_b, xs_b = np.where(sub_bank[:, :, 3] > 0)
    corner_bank_img = None
    if ys_b.size > 64:
        crop_b = sub_bank[int(ys_b.min()) : int(ys_b.max()) + 1, int(xs_b.min()) : int(xs_b.max()) + 1]
        bw_c = max(24, int(round(w * 0.175)))
        bh_c = max(24, int(round(h * 0.28)))
        corner_bank_img = Image.fromarray(crop_b, mode="RGBA").resize((bw_c, bh_c), Image.Resampling.NEAREST)

    top_arrays = [np.zeros((h, w, 4), dtype=np.uint8) for _ in range(N_FRAMES)]
    if summit_sprites:
        sp_puff_l = summit_sprites[min(4, len(summit_sprites) - 1)]
        sp_puff_r = sp_puff_l.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        for sp, x0_p, y0_p, x1_p, y1_p, ph_s, arc_s in [
            (sp_puff_l, w * 0.22, h * 0.80, w * 0.05, h * 0.96, 6, -w * 0.010),
            (sp_puff_r, w * 0.78, h * 0.80, w * 0.95, h * 0.96, 6, +w * 0.010),
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

    # Grille de collision : dôme central `#CFF7FF` canonique `b71` + accès sud centré
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            block = arena_inner_mask[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(block.mean()) >= 0.70

    wy_arena, _ = np.where(walk_grid)
    if wy_arena.size > 0:
        half_corridor = max(2, gw // 24)
        cx_mid = gw // 2
        walk_grid[int(wy_arena.max()) : gh, cx_mid - half_corridor : cx_mid + half_corridor] = True

    labeled_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        south_labels = set(labeled_w[-1, :].tolist()) - {0}
        if south_labels:
            walk_grid = np.isin(labeled_w, list(south_labels))

    layers = [
        LayerEntry("00_stratosphere_ultramarine", "Cosmos Etoile & Planete Courbe", "BG", frames_00),
        LayerEntry("01_etoiles_stratosphere", "Etoiles Scintillantes Cosmos", "BG", frames_01),
        LayerEntry("02_horizon_planetaire_courbe", "Nuages Planetaires & Spirales", "BG", frames_02),
        LayerEntry("03_nappes_altitude_profondes", "Courants Planete & Nappes Altitude", "BG", frames_03),
        LayerEntry("04_ailes_vent_sculptees_proches", "Ailes Vent Sculptees Proches", "BG", frames_04),
        LayerEntry("05_couronne_volumetrique_ombre", "Couronne Cumulus & Cascades b71", "BG", [Image.fromarray(layer05_arr, "RGBA")]),
        LayerEntry("06_sol_couronne_rayquaza", "Sol Arene Rayquaza Canonique b71", "BG", [Image.fromarray(layer06_arr, "RGBA")]),
        LayerEntry("07_reliefs_cretes_couronne", "Reliefs Cretes Couronne b71", "BG", [Image.fromarray(layer07_arr, "RGBA")]),
        LayerEntry("08_respiration_bpl_couronne", "Ondes Eoliennes & Souffle BPL", "BG", frames_08),
        LayerEntry("09_sillages_courants_jet", "Cumulus Avant-Plan & Sillages Jet", "Top", frames_09),
    ]
    return layers, walk_grid, palette


def main() -> None:
    layers, walk_grid, _ = build_layers_for_size(W_CANON, H_CANON)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=RENDERS_DIR,
        virtual_zip_path=VIRTUAL_ZIP,
        canonical_ref_for_fidelity=REF_DIR / "b71_sky_tower_summit.png",
        max_fidelity_distance=30.0,
    )
    print(json.dumps(meta, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
