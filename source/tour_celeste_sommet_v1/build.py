#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (24 trames @ 5 ticks = 120 ticks) :
STC1 — Sommet de la Tour Céleste — Arène de Rayquaza (`b71 / D13P03` + `D13P01.bpl`).

Proportions et cinématique physique 100 % fidèles à `b71_sky_tower_summit.png` :
- La couronne nuageuse de Rayquaza occupe `y = 0.34*h .. h` (`200..576`), laissant toute la voûte
  cosmique bleu outremer `#0000A8` (`y = 0..220`) et le limbe courbe de la Terre (`y = 220..315`)
  s'épanouir majestueusement au-dessus de l'arène exactement comme dans `b71` !
- Cinématique multi-trames harmonieuse :
  1. `01_etoiles_stratosphere` (24 poses) : étoiles de haute stratosphère scintillant doucement.
  2. `02_horizon_planetaire_courbe` (24 poses) : nappes nuageuses fines glissant d'ouest en est
     (`dx = +8 px/trame`, période `192 px`) le long de l'arc courbe exact du limbe terrestre `b71`.
  3. `03_nappes_altitude_profondes` (24 poses) : courants d'altitude pervenche s'écartant
     symétriquement vers l'extérieur et le bas (`dx = -8, dy = +8` à gauche ; `dx = +8, dy = +8` à droite).
  4. `04_ailes_vent_sculptees_proches` (24 poses) : grandes ailes de vent lavande/blanches `b71`
     s'écartant à double vitesse horizontale (`dx = -16, dy = +8` à gauche ; `dx = +16, dy = +8` à droite)
     sous la couronne de Rayquaza.
  5. `08_respiration_bpl_couronne` (24 poses) : souffle lumineux `D13P01.bpl` sur l'ourlet de la couronne.
  6. `09_sillages_courants_jet` (`Top` `Layer = 4`, 24 poses) : panaches éoliens et bouffées cumulus
     s'échappant symétriquement sous les flancs gauche et droit de la couronne vers l'horizon bas.
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
RAW_DIR = REPO_ROOT / ".cache" / "tour_celeste_sommet_v1" / "raw"
ENTREE_RAW_DIR = REPO_ROOT / ".cache" / "tour_celeste_entree_v1" / "raw"
RELAIS_RAW_DIR = REPO_ROOT / ".cache" / "tour_celeste_relais_v1" / "raw"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_celeste_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_clean_b71_stratosphere_and_limb(
    b71_up: np.ndarray,
    plume_src: Image.Image,
    w: int,
    h: int,
    palette: np.ndarray,
) -> Tuple[Image.Image, List[Image.Image], np.ndarray]:
    """Reconstitue le fond stratosphérique pur de `b71` (cosmos `#0000A8` en haut + arc courbe
    du limbe terrestre `y ≈ 0.39*h .. 0.54*h` + atmosphère pervenche `#6888E8` en bas) en utilisant
    la géométrie parabolique exacte du limbe de `b71`, puis anime un ruban de nuages d'altitude
    glissant d'ouest en est (`dx = +8 px/trame`) le long de cette courbe planétaire !"""
    xs = np.arange(w, dtype=np.float32)
    u_norm = (xs - 0.5 * w) / (0.5 * w)
    # Dans `b71_sky_tower_summit.png`, l'arc lumineux de la Terre culmine vers `0.40 * h` au centre et descend à `0.50 * h` aux bords !
    arc_drop = 0.098 * h * (u_norm**2)

    # Profil vertical de référence pris sur la colonne `x = 0` de `b71` (100 % exempt de la couronne centrale !)
    col_left_profile = b71_up[:, 0, :]  # shape (h, 3), limbe situé à `y_edge` (où `u_norm = -1`, soit `+0.098 * h`)
    yy = np.arange(h, dtype=np.float32)[:, None]
    # Ramène chaque colonne `x` sur le profil pur du bord `u_norm = -1` en décalant `y` selon la parabole du limbe !
    y_lookup = np.clip(np.rint(yy + (0.098 * h - arc_drop[None, :])).astype(np.int32), 0, h - 1)
    bg_pure = col_left_profile[y_lookup]
    bg_pure_q = quantize_rgb_to_palette(bg_pure, palette)
    bg_img = Image.fromarray(
        np.concatenate([bg_pure_q, np.full((h, w, 1), 255, dtype=np.uint8)], axis=2),
        mode="RGBA",
    )

    # Ruban nuageux fin d'horizon (`pw = 192 = 24 * 8 px`, `ph = 64 px`) glissant d'ouest en est le long de l'arc !
    pw_h = max(96, ((w // 4) // 24) * 24)  # 192 px -> `dx = +8 px/trame`
    step_h = pw_h // N_FRAMES
    horiz_pal = palette[
        (0.299 * palette[:, 0] + 0.587 * palette[:, 1] + 0.114 * palette[:, 2]) >= 175.0
    ]
    if len(horiz_pal) < 3:
        horiz_pal = palette

    horiz_strip = make_fullscale_periodic_strip(
        plume_src,
        canvas_w=w,
        canvas_h=h,
        crop_box=(int(w * 0.08), int(h * 0.30), int(w * 0.08) + pw_h, int(h * 0.30) + 64),
        period_w=pw_h,
        period_h=64,
        palette=palette,
        keep_mask_fn=lambda rgb: (
            0.299 * rgb[:, :, 0] + 0.587 * rgb[:, :, 1] + 0.114 * rgb[:, :, 2]
        ) >= 175.0,
        min_blob_area=48,
    )

    y_limb_crest = 0.506 * h + arc_drop  # fondu directement sous le halo du limbe terrestre
    rel_y = yy - y_limb_crest[None, :]
    in_limb_band = (rel_y >= 0.0) & (rel_y < 52.0)
    v_idx = np.clip((np.rint(rel_y / 4.0).astype(np.int32) * 4), 0, 63)
    x_row = np.arange(w, dtype=np.int32)[None, :]

    horizon_frames: List[Image.Image] = []
    for t in range(N_FRAMES):
        ux = (x_row - step_h * t) % pw_h  # dérive fluide vers la DROITE (`dx = +8 px/trame`) le long du limbe !
        fr = horiz_strip[v_idx, ux].copy()
        fr[~in_limb_band] = 0
        horizon_frames.append(Image.fromarray(fr, mode="RGBA"))

    below_limb_mask = yy >= (y_limb_crest[None, :] + 18.0)
    return bg_img, horizon_frames, below_limb_mask


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    ref_b71 = REF_DIR / "b71_sky_tower_summit.png"
    bpl_path = REF_DIR / "rom_d13p01_bpl.json"

    palette = extract_canonical_palette([ref_b71], max_colors=48, min_pixels=4)
    b71_up = np.asarray(
        Image.open(ref_b71).convert("RGB").resize((w, h), Image.Resampling.NEAREST),
        dtype=np.uint8,
    )

    # 1. Couronne nuageuse de Rayquaza ancrée à sa vraie hauteur canonique `b71` (`y_top = 0.35 * h`) !
    #    Ainsi tout le tiers supérieur (`y = 0 .. 0.35 * h`) dévoile l'immensité bleu outremer `#0000A8`
    #    et l'horizon courbe de la planète exactement comme dans `b71_sky_tower_summit.png` !
    y_crown_top = (int(round(h * 0.355)) // 8) * 8  # 200 px pour h=576
    crown_h = h - y_crown_top
    crown_w = int(round(w * 0.72))
    crown_x0 = (w - crown_w) // 2

    couronne_raw = Image.open(RAW_DIR / "ile_couronne_magenta.png")
    couronne_scaled = key_magenta(couronne_raw, size=(crown_w, crown_h), erode_fringe=2, min_component_area=96)
    couronne_canvas = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    couronne_canvas.paste(couronne_scaled, (crown_x0, y_crown_top))
    couronne_q = quantize_rgba_to_palette(couronne_canvas, palette)
    couronne_arr = np.asarray(couronne_q, dtype=np.uint8).copy()
    crown_alpha = couronne_arr[:, :, 3] > 0

    luma_c = (
        0.299 * couronne_arr[:, :, 0].astype(np.float32)
        + 0.587 * couronne_arr[:, :, 1].astype(np.float32)
        + 0.114 * couronne_arr[:, :, 2].astype(np.float32)
    )
    erode_px = max(5, int(round(min(w, h) * 0.022)))
    walk_px_mask = ndimage.binary_erosion(crown_alpha & (luma_c >= 202.0), iterations=erode_px)
    south_cols = crown_alpha[h - 4 : h, :].any(axis=0)
    if np.any(south_cols):
        bx0 = int(np.where(south_cols)[0].min()) + max(3, erode_px // 2)
        bx1 = int(np.where(south_cols)[0].max()) - max(3, erode_px // 2)
        if bx1 > bx0:
            walk_px_mask[int(h * 0.74) : h, bx0:bx1] |= crown_alpha[int(h * 0.74) : h, bx0:bx1] & (
                luma_c[int(h * 0.74) : h, bx0:bx1] >= 198.0
            )

    under_crown_mask = crown_alpha & (~walk_px_mask) & (luma_c < 228.0)
    crest_rim_mask = crown_alpha & (~walk_px_mask) & (~under_crown_mask)

    layer05_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer05_arr[under_crown_mask] = couronne_arr[under_crown_mask]

    layer06_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer06_arr[walk_px_mask] = couronne_arr[walk_px_mask]

    layer07_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer07_arr[crest_rim_mask] = couronne_arr[crest_rim_mask]

    # 2. Fond stratosphérique pur `b71` + étoiles discrètes + horizon planétaire courbe animé !
    plume_src = Image.open(ENTREE_RAW_DIR / "nuages_courant_convergent.png").convert("RGB")
    layer00_img, frames_02, below_limb_mask = build_clean_b71_stratosphere_and_limb(
        b71_up, plume_src, w, h, palette
    )

    # Étoiles fines de haute stratosphère scintillant doucement dans le cosmos `#0000A8` (`y < 0.30 * h`)
    bright_star_rgb = quantize_rgb_to_palette(np.array([[[208, 224, 255]]], dtype=np.uint8), palette)[0, 0]
    dim_star_rgb = quantize_rgb_to_palette(np.array([[[88, 108, 224]]], dtype=np.uint8), palette)[0, 0]
    star_coords = [
        (0.08, 0.08, 0),
        (0.21, 0.14, 6),
        (0.34, 0.07, 13),
        (0.49, 0.11, 19),
        (0.65, 0.06, 4),
        (0.79, 0.13, 11),
        (0.91, 0.08, 17),
        (0.14, 0.25, 9),
        (0.86, 0.24, 21),
    ]
    frames_01: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr_st = np.zeros((h, w, 4), dtype=np.uint8)
        for fx, fy, ph_s in star_coords:
            s_val = np.sin(2.0 * np.pi * ((t + ph_s) / float(N_FRAMES)))
            if s_val < 0.05:
                continue
            cx, cy = int(w * fx), int(h * fy)
            if s_val > 0.65:
                # Petite étoile croix 3x3 pixel-art GBA
                arr_st[cy, max(0, cx - 1) : min(w, cx + 2), :3] = bright_star_rgb
                arr_st[cy, max(0, cx - 1) : min(w, cx + 2), 3] = 255
                arr_st[max(0, cy - 1) : min(h, cy + 2), cx, :3] = bright_star_rgb
                arr_st[max(0, cy - 1) : min(h, cy + 2), cx, 3] = 255
            else:
                arr_st[cy, cx, :3] = dim_star_rgb
                arr_st[cy, cx, 3] = 255
        frames_01.append(Image.fromarray(arr_st, mode="RGBA"))

    # 3. Deux plans d'ailes de vent d'altitude 1:1 s'écartant symétriquement vers l'EXTÉRIEUR et le BAS !
    # Palette dédiée aux vraies nuances pervenche/lavande des ailes de `b71[h//2:, :w//3]` pour que
    # l'atmosphère reste 100 % fidèle au bleu pervenche doux de `b71` !
    wing_sample_colors = b71_up[int(h * 0.52) :, : int(w * 0.30)].reshape(-1, 3)
    wing_pal_deep = quantize_rgb_to_palette(
        np.array([[[122, 148, 232], [140, 166, 240], [160, 186, 248]]], dtype=np.uint8),
        palette,
    )[0]
    wing_pal_near = quantize_rgb_to_palette(
        np.array([[[152, 178, 244], [184, 206, 252], [214, 232, 255]]], dtype=np.uint8),
        palette,
    )[0]

    pw_half = max(96, (w // 2 // 24) * 24)  # 384 px
    ph_band = max(96, (h // 3 // 24) * 24)  # 192 px
    pw_slow = max(96, (pw_half // 2 // 24) * 24)  # 192 px
    step_fast = pw_half // N_FRAMES  # 16 px/trame
    step_slow = pw_slow // N_FRAMES  # 8 px/trame

    wings_src = plume_src.transpose(Image.Transpose.FLIP_TOP_BOTTOM)

    # Plan 03 : nappes d'altitude profondes (`dx = -8, dy = +8` à gauche ; `dx = +8, dy = +8` à droite)
    tile_wings_deep = make_fullscale_periodic_strip(
        wings_src,
        canvas_w=w,
        canvas_h=h,
        crop_box=(0, int(h * 0.25), pw_slow, int(h * 0.25) + ph_band),
        period_w=pw_slow,
        period_h=ph_band,
        palette=wing_pal_deep,
        keep_mask_fn=lambda rgb: rgb[:, :, 2] >= wing_pal_deep[1, 2],
        min_blob_area=240,
    )
    frames_03 = render_symmetric_stream_frames(
        tile_wings_deep,
        w,
        h,
        step_inward_x=-step_slow,
        step_upward_y=-step_slow,
        mask_keep=below_limb_mask,
    )

    # Plan 04 : grandes ailes de vent sculptées proches (`dx = -16, dy = +8` à gauche ; `dx = +16, dy = +8` à droite)
    lower_wings_zone = below_limb_mask & (np.arange(h)[:, None] >= int(h * 0.50))
    tile_wings_near = make_fullscale_periodic_strip(
        wings_src,
        canvas_w=w,
        canvas_h=h,
        crop_box=(int(w * 0.12), int(h * 0.16), int(w * 0.12) + pw_half, int(h * 0.16) + ph_band),
        period_w=pw_half,
        period_h=ph_band,
        palette=wing_pal_near,
        keep_mask_fn=lambda rgb: rgb[:, :, 0] >= wing_pal_near[1, 0],
        min_blob_area=320,
    )
    frames_04 = render_symmetric_stream_frames(
        tile_wings_near,
        w,
        h,
        step_inward_x=-step_fast,
        step_upward_y=-step_slow,
        mask_keep=lower_wings_zone,
    )

    # Couche 08 : souffle lumineux `D13P01.bpl` sur l'ourlet de la couronne de Rayquaza
    bpl_ramp = load_bpl_cyan_ramp(bpl_path, palette)
    glow_rim = under_crown_mask & (luma_c >= 204.0)
    frames_08: List[Image.Image] = []
    for t in range(N_FRAMES):
        c_rgb = bpl_ramp[t]
        arr_08 = np.zeros((h, w, 4), dtype=np.uint8)
        arr_08[glow_rim, :3] = c_rgb
        arr_08[glow_rim, 3] = 255
        frames_08.append(Image.fromarray(arr_08, mode="RGBA"))

    # Couche 09 (`Top` `Layer = 4`) : panaches éoliens et bouffées s'échappant sous les flancs de la couronne !
    summit_sprites = extract_whole_cloud_sprites(
        ENTREE_RAW_DIR / "poses_nuages_magenta.png",
        palette=wing_pal_near,
        scale_div=max(2, int(round(1450 / max(w, 1)))),
        min_area=24,
    )
    top_arrays = [np.zeros((h, w, 4), dtype=np.uint8) for _ in range(N_FRAMES)]
    if summit_sprites:
        sp_jet_r = summit_sprites[min(1, len(summit_sprites) - 1)].transpose(Image.Transpose.FLIP_TOP_BOTTOM)
        sp_jet_l = sp_jet_r.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        sp_puff_l = summit_sprites[min(4, len(summit_sprites) - 1)]
        sp_puff_r = sp_puff_l.transpose(Image.Transpose.FLIP_LEFT_RIGHT)

        jet_paths = [
            (sp_jet_l, w * 0.22, h * 0.66, w * 0.04, h * 0.92, 0, -w * 0.014),
            (sp_jet_r, w * 0.78, h * 0.66, w * 0.96, h * 0.92, 0, +w * 0.014),
            (sp_puff_l, w * 0.26, h * 0.80, w * 0.09, h * 0.96, 12, -w * 0.010),
            (sp_puff_r, w * 0.74, h * 0.80, w * 0.91, h * 0.96, 12, +w * 0.010),
        ]
        for sp, x0, y0, x1, y1, ph_s, arc_s in jet_paths:
            composite_sprite_periodic_path(top_arrays, sp, x0, y0, x1, y1, phase=ph_s, arc_px=arc_s)
        inner_safe = ndimage.binary_erosion(walk_px_mask, iterations=3)
        for a in top_arrays:
            a[inner_safe] = 0

    frames_09 = [Image.fromarray(a, mode="RGBA") for a in top_arrays]

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            block = walk_px_mask[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(block.mean()) >= 0.72

    labeled_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        south_labels = set(labeled_w[-1, :].tolist()) - {0}
        if south_labels:
            walk_grid = np.isin(labeled_w, list(south_labels))
        else:
            counts_w = ndimage.sum(walk_grid, labeled_w, index=range(1, n_w + 1))
            walk_grid = labeled_w == (int(np.argmax(counts_w)) + 1)

    layers = [
        LayerEntry("00_stratosphere_ultramarine", "Stratosphere Ultramarine", "BG", [layer00_img]),
        LayerEntry("01_etoiles_stratosphere", "Etoiles Stratosphere", "BG", frames_01),
        LayerEntry("02_horizon_planetaire_courbe", "Horizon Planetaire Courbe", "BG", frames_02),
        LayerEntry("03_nappes_altitude_profondes", "Nappes Altitude Profondes", "BG", frames_03),
        LayerEntry("04_ailes_vent_sculptees_proches", "Ailes Vent Sculptees Proches", "BG", frames_04),
        LayerEntry("05_couronne_volumetrique_ombre", "Couronne Volumetrique Ombre", "BG", [Image.fromarray(layer05_arr, "RGBA")]),
        LayerEntry("06_sol_couronne_rayquaza", "Sol Couronne Rayquaza", "BG", [Image.fromarray(layer06_arr, "RGBA")]),
        LayerEntry("07_reliefs_cretes_couronne", "Reliefs Cretes Couronne", "BG", [Image.fromarray(layer07_arr, "RGBA")]),
        LayerEntry("08_respiration_bpl_couronne", "Respiration BPL Couronne", "BG", frames_08),
        LayerEntry("09_sillages_courants_jet", "Sillages Courants Jet", "Top", frames_09),
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
