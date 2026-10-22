#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (24 trames @ 5 ticks = 120 ticks) :
ETC1 — Entrée de la Tour Céleste (PMD Équipe de Secours Rouge `D13P01` + `A04P02`).

Cinématique physique harmonieuse à l'échelle 1:1 pixel-art GBA (zéro miniaturisation en confettis) :
1. `01_mer_nuages_lointaine` (24 poses) : mer céleste lointaine `A04P02` dérivant vers l'axe
   central et le nord (`dx = +8, dy = -8` à gauche ; `dx = -8, dy = -8` à droite ; `192x192`).
2. `02_courants_nuages_medians` (24 poses) : longs sillages pervenche `D13P01` convergeant vers
   la tour (`dx = +8, dy = -8` à gauche ; `dx = -8, dy = -8` à droite ; `384x192`).
3. `03_panaches_convergents_proches` (24 poses) : grands massifs cumulus blancs `D13P01` à
   l'échelle 1:1 filant en diagonale rapide (`dx = +16, dy = -8` à gauche ; `dx = -16, dy = -8`
   à droite ; `384x192`) vers le portail nord en laissant respirer le bleu cobalt dans les angles bas.
4. `07_spirale_cyclone_portail` (24 poses) : rotation cyclonique continue sur `360°` (`15°/trame`)
   de l'anneau nuageux autour de l'ouverture noire `(0, 0, 0)` du donjon.
5. `08_reflets_bpl_canoniques` (24 poses) : onde lumineuse matérielle GBA `D13P01.bpl`.
6. `09_bouffees_nuages_derive` (`Top` `Layer = 4`, 24 poses) : bouffées cumulus et volutes entières
   glissant dans le ciel périphérique (hors esplanade praticable) jusque dans la bouche du vortex.
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

MAP_ID = "ETC1"
MAP_TITLE = "Entrée de la Tour Céleste"
RAW_DIR = REPO_ROOT / ".cache" / "tour_celeste_entree_v1" / "raw"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_celeste_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    ref_d13p01 = REF_DIR / "D13P01.png"
    ref_a04p02 = REF_DIR / "A04P02.png"
    bpl_path = REF_DIR / "rom_d13p01_bpl.json"

    palette = extract_canonical_palette([ref_d13p01, ref_a04p02], max_colors=48, min_pixels=4)

    # 0. Fond céleste dégradé par paliers GBA pur `D13P01` (cobalt profond en bas -> azur lumineux en haut,
    #    zéro bande blanche parasite en bas de l'écran !)
    sky_stops = np.array(
        [
            [88, 144, 248],
            [64, 120, 248],
            [44, 96, 240],
            [28, 76, 232],
            [16, 64, 224],
        ],
        dtype=np.float32,
    )
    sky_backdrop = np.zeros((h, w, 3), dtype=np.uint8)
    for y in range(h):
        t_y = (y / float(max(1, h - 1))) * (len(sky_stops) - 1)
        i0 = min(len(sky_stops) - 2, int(t_y))
        f_y = t_y - i0
        c_row = sky_stops[i0] * (1.0 - f_y) + sky_stops[i0 + 1] * f_y
        sky_backdrop[y, :] = np.clip(np.rint(c_row), 0, 255).astype(np.uint8)
    sky_backdrop_q = quantize_rgb_to_palette(sky_backdrop, palette)
    layer00_img = Image.fromarray(
        np.concatenate([sky_backdrop_q, np.full((h, w, 1), 255, dtype=np.uint8)], axis=2),
        mode="RGBA",
    )

    # 1. Île centrale + pont sud + arche portail détourés sur `#FF00FF`, ancrés légèrement plus bas (`top_pad`)
    #    pour laisser respirer toute la couronne de panaches au-dessus du vortex comme dans `D13P01` !
    top_pad = max(16, (int(round(h * 0.06)) // 8) * 8)
    ile_raw = Image.open(RAW_DIR / "ile_portail_magenta.png")
    ile_scaled = key_magenta(ile_raw, size=(w, h - top_pad), erode_fringe=2, min_component_area=120)
    ile_canvas = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    ile_canvas.paste(ile_scaled, (0, top_pad))
    ile_q = quantize_rgba_to_palette(ile_canvas, palette)
    ile_arr = np.asarray(ile_q, dtype=np.uint8).copy()
    ile_alpha = ile_arr[:, :, 3] > 0

    luma_ile = (
        0.299 * ile_arr[:, :, 0].astype(np.float32)
        + 0.587 * ile_arr[:, :, 1].astype(np.float32)
        + 0.114 * ile_arr[:, :, 2].astype(np.float32)
    )
    portal_hole = ile_alpha & (luma_ile < 38.0) & (np.arange(h)[:, None] < int(h * 0.48))
    portal_hole = ndimage.binary_fill_holes(portal_hole)
    ys_p, xs_p = np.where(portal_hole)
    portal_cx = float(xs_p.mean()) if ys_p.size else w * 0.5
    portal_cy = float(ys_p.mean()) if ys_p.size else h * 0.25
    portal_rx = max(24.0, (xs_p.max() - xs_p.min()) * 0.5) if xs_p.size else w * 0.075
    portal_ry = max(24.0, (ys_p.max() - ys_p.min()) * 0.5) if ys_p.size else h * 0.095

    yy, xx = np.mgrid[0:h, 0:w]
    norm_r = np.sqrt(((xx - portal_cx) / (portal_rx * 1.95)) ** 2 + ((yy - portal_cy) / (portal_ry * 1.90)) ** 2)
    swirl_ring_mask = ile_alpha & (norm_r <= 1.0) & (~portal_hole)
    portal_arch_mask = ile_alpha & (norm_r <= 1.16)

    erode_px = max(6, int(round(min(w, h) * 0.032)))
    walk_px_mask = ndimage.binary_erosion(ile_alpha, iterations=erode_px) & (~portal_arch_mask)
    south_bridge_cols = ile_alpha[h - 4 : h, :].any(axis=0)
    if np.any(south_bridge_cols):
        bx0 = int(np.where(south_bridge_cols)[0].min()) + max(4, erode_px // 2)
        bx1 = int(np.where(south_bridge_cols)[0].max()) - max(4, erode_px // 2)
        if bx1 > bx0:
            walk_px_mask[int(h * 0.68) : h, bx0:bx1] |= ile_alpha[int(h * 0.68) : h, bx0:bx1]

    # Texture de sol praticable canonique `D13P01_sol_crop_4x.png` + `sol_complet.png`
    sol_src = Image.open(RAW_DIR / "sol_complet.png").convert("RGB").resize((w, h), Image.Resampling.NEAREST)
    sol_crop_ref = Image.open(REF_DIR / "D13P01_sol_crop_4x.png").convert("RGB").resize((w, h), Image.Resampling.NEAREST)
    sol_q = quantize_rgb_to_palette(
        np.clip(
            0.55 * np.asarray(sol_crop_ref, dtype=np.float32) + 0.45 * np.asarray(sol_src, dtype=np.float32),
            0,
            255,
        ).astype(np.uint8),
        palette,
    )

    shadow_mask = ile_alpha & (~walk_px_mask) & (~portal_arch_mask) & (luma_ile < 226.0)
    rim_arch_mask = (ile_alpha & (~walk_px_mask) & (~shadow_mask)) | portal_arch_mask

    layer04_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer04_arr[shadow_mask] = ile_arr[shadow_mask]

    layer05_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer05_arr[walk_px_mask, :3] = sol_q[walk_px_mask]
    layer05_arr[walk_px_mask, 3] = 255

    layer06_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer06_arr[rim_arch_mask] = ile_arr[rim_arch_mask]
    layer06_arr[portal_hole] = np.array([0, 0, 0, 255], dtype=np.uint8)

    # 2. Trois plans nuageux 1:1 pixel-art GBA en mouvement convergent continu vers le nord !
    pw_half = max(96, (w // 2 // 24) * 24)  # 384 px pour w=768 (`24 * 16`)
    ph_band = max(96, (h // 3 // 24) * 24)  # 192 px pour h=576 (`24 * 8`)
    step_x_fast = pw_half // N_FRAMES       # 16 px/trame
    step_y_base = ph_band // N_FRAMES       # 8 px/trame
    pw_slow = max(96, (pw_half // 2 // 24) * 24)  # 192 px -> 8 px/trame !
    step_x_slow = pw_slow // N_FRAMES       # 8 px/trame

    plume_src = Image.open(RAW_DIR / "nuages_courant_convergent.png").convert("RGB")
    sky_deep_src = Image.open(ref_a04p02).convert("RGB")

    # Couche 01 : bancs de nuages lointains épars dérivant sur le grand ciel cobalt (`dx = ±8, dy = -8`)
    tile_far = make_fullscale_periodic_strip(
        plume_src,
        canvas_w=w,
        canvas_h=h,
        crop_box=(int(w * 0.12), int(h * 0.08), int(w * 0.12) + pw_slow, int(h * 0.08) + ph_band),
        period_w=pw_slow,
        period_h=ph_band,
        palette=palette,
        keep_mask_fn=lambda rgb: (
            0.299 * rgb[:, :, 0] + 0.587 * rgb[:, :, 1] + 0.114 * rgb[:, :, 2]
        ) >= 244.0,
        min_blob_area=200,
    )
    frames_01 = render_symmetric_stream_frames(
        tile_far, w, h, step_inward_x=step_x_slow, step_upward_y=step_y_base
    )

    # Couche 02 : sillages nuageux médians extraits à l'échelle 1:1 de `nuages_courant_convergent.png`
    tile_mid = make_fullscale_periodic_strip(
        plume_src,
        canvas_w=w,
        canvas_h=h,
        crop_box=(0, int(h * 0.18), pw_half, int(h * 0.18) + ph_band),
        period_w=pw_slow,
        period_h=ph_band,
        palette=palette,
        keep_mask_fn=lambda rgb: (
            (rgb[:, :, 2].astype(np.int32) - rgb[:, :, 0].astype(np.int32)) < 120
        ),
        min_blob_area=260,
    )
    frames_02 = render_symmetric_stream_frames(
        tile_mid, w, h, step_inward_x=step_x_slow, step_upward_y=step_y_base
    )

    # Couche 03 : grands massifs cumulus blancs `D13P01` à l'échelle 1:1 (`384x192`, `dx = ±16, dy = -8`)
    # Masque atmosphérique fidèle à `D13P01.png` : laisse briller le bleu cobalt dans les angles bas !
    upper_plume_zone = (yy < (0.86 * h - 0.22 * h * (np.abs(xx - 0.5 * w) / (0.5 * w)) ** 1.5))
    tile_near = make_fullscale_periodic_strip(
        plume_src,
        canvas_w=w,
        canvas_h=h,
        crop_box=(int(w * 0.12), int(h * 0.12), int(w * 0.12) + pw_half, int(h * 0.12) + ph_band),
        period_w=pw_half,
        period_h=ph_band,
        palette=palette,
        keep_mask_fn=lambda rgb: (
            0.299 * rgb[:, :, 0] + 0.587 * rgb[:, :, 1] + 0.114 * rgb[:, :, 2]
        ) >= 198.0,
        min_blob_area=320,
    )
    frames_03 = render_symmetric_stream_frames(
        tile_near,
        w,
        h,
        step_inward_x=step_x_fast,
        step_upward_y=step_y_base,
        mask_keep=upper_plume_zone,
    )

    # 3. Couche 07 : rotation cyclonique continue sur `360°` autour du gouffre noir du portail !
    x0_s = max(0, int(portal_cx - portal_rx * 2.15))
    x1_s = min(w, int(portal_cx + portal_rx * 2.15))
    y0_s = max(0, int(portal_cy - portal_ry * 2.15))
    y1_s = min(h, int(portal_cy + portal_ry * 2.15))
    patch_base = Image.fromarray(ile_arr[y0_s:y1_s, x0_s:x1_s], mode="RGBA")
    ring_local = swirl_ring_mask[y0_s:y1_s, x0_s:x1_s]
    yy_l, xx_l = np.mgrid[y0_s:y1_s, x0_s:x1_s]
    r_ell = np.sqrt(((xx_l - portal_cx) / (portal_rx * 1.62)) ** 2 + ((yy_l - portal_cy) / (portal_ry * 1.62)) ** 2)
    spin_zone = ring_local & (r_ell <= 1.0) & (r_ell >= 0.56)

    frames_07: List[Image.Image] = []
    for t in range(N_FRAMES):
        angle_deg = -t * (360.0 / N_FRAMES)
        rot_patch = patch_base.rotate(
            angle_deg,
            resample=Image.Resampling.BILINEAR,
            center=(portal_cx - x0_s, portal_cy - y0_s),
        )
        rot_q = np.asarray(quantize_rgba_to_palette(rot_patch, palette), dtype=np.uint8)
        canvas_07 = np.zeros((h, w, 4), dtype=np.uint8)
        sub_dst = canvas_07[y0_s:y1_s, x0_s:x1_s]
        valid_rot = spin_zone & (rot_q[:, :, 3] > 0)
        sub_dst[valid_rot] = rot_q[valid_rot]
        canvas_07[portal_hole] = np.array([0, 0, 0, 255], dtype=np.uint8)
        frames_07.append(Image.fromarray(canvas_07, mode="RGBA"))

    # 4. Couche 08 : onde lumineuse matérielle `D13P01.bpl`
    bpl_ramp = load_bpl_cyan_ramp(bpl_path, palette)
    vein_mask = rim_arch_mask & (~portal_hole) & (luma_ile >= 195.0) & (luma_ile <= 238.0)
    frames_08: List[Image.Image] = []
    for t in range(N_FRAMES):
        c_rgb = bpl_ramp[t]
        arr_08 = np.zeros((h, w, 4), dtype=np.uint8)
        arr_08[vein_mask, :3] = c_rgb
        arr_08[vein_mask, 3] = 255
        frames_08.append(Image.fromarray(arr_08, mode="RGBA"))

    # 5. Couche 09 (`Top` `Layer = 4`) : bouffées cumulus et volutes glissant UNIQUEMENT dans le ciel
    #    extérieur et dans le tourbillon nord (zéro intrusion au milieu du sol praticable !)
    sprites = extract_whole_cloud_sprites(
        RAW_DIR / "poses_nuages_magenta.png",
        palette=palette,
        scale_div=max(2, int(round(1400 / max(w, 1)))),
        min_area=24,
    )
    top_arrays = [np.zeros((h, w, 4), dtype=np.uint8) for _ in range(N_FRAMES)]
    if sprites:
        sp_puff_l = sprites[min(4, len(sprites) - 1)]
        sp_plume_l = sprites[min(1, len(sprites) - 1)]
        sp_spiral_l = sprites[min(6, len(sprites) - 1)]
        sp_puff_r = sp_puff_l.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        sp_plume_r = sp_plume_l.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        sp_spiral_r = sp_spiral_l.transpose(Image.Transpose.FLIP_LEFT_RIGHT)

        streamlines = [
            # Ciel haut-gauche & haut-droite convergeant droit dans l'arche tourbillonnante !
            (sp_plume_l, w * 0.04, h * 0.30, w * 0.36, h * 0.11, 0, -w * 0.015),
            (sp_plume_r, w * 0.96, h * 0.30, w * 0.64, h * 0.11, 0, +w * 0.015),
            (sp_spiral_l, w * 0.15, h * 0.20, w * 0.41, h * 0.13, 10, -w * 0.012),
            (sp_spiral_r, w * 0.85, h * 0.20, w * 0.59, h * 0.13, 10, +w * 0.012),
            # Ciel bas-gauche & bas-droite sous l'île remontant vers les flancs nuageux !
            (sp_puff_l, w * 0.05, h * 0.95, w * 0.30, h * 0.78, 5, -w * 0.012),
            (sp_puff_r, w * 0.95, h * 0.95, w * 0.70, h * 0.78, 5, +w * 0.012),
            (sp_puff_l, w * 0.12, h * 0.92, w * 0.34, h * 0.84, 17, -w * 0.010),
            (sp_puff_r, w * 0.88, h * 0.92, w * 0.66, h * 0.84, 17, +w * 0.010),
        ]
        for sp, x0, y0, x1, y1, ph_s, arc_s in streamlines:
            composite_sprite_periodic_path(top_arrays, sp, x0, y0, x1, y1, phase=ph_s, arc_px=arc_s)
        # Sécurité stricte : ne couvre jamais le cœur praticable de l'esplanade !
        inner_safe = ndimage.binary_erosion(walk_px_mask, iterations=4)
        for a in top_arrays:
            a[inner_safe] = 0

    frames_09 = [Image.fromarray(a, mode="RGBA") for a in top_arrays]

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            block = walk_px_mask[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(block.mean()) >= 0.75

    labeled_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        south_labels = set(labeled_w[-1, :].tolist()) - {0}
        if south_labels:
            walk_grid = np.isin(labeled_w, list(south_labels))
        else:
            counts = ndimage.sum(walk_grid, labeled_w, index=range(1, n_w + 1))
            walk_grid = labeled_w == (int(np.argmax(counts)) + 1)

    layers = [
        LayerEntry("00_fond_ciel_celeste", "Fond Ciel Celeste", "BG", [layer00_img]),
        LayerEntry("01_mer_nuages_lointaine", "Mer Nuages Lointaine", "BG", frames_01),
        LayerEntry("02_courants_nuages_medians", "Courants Nuages Medians", "BG", frames_02),
        LayerEntry("03_panaches_convergents_proches", "Panaches Convergents Proches", "BG", frames_03),
        LayerEntry("04_ombres_volumetriques_ile", "Ombres Volumetriques Ile", "BG", [Image.fromarray(layer04_arr, "RGBA")]),
        LayerEntry("05_sol_nuage_praticable", "Sol Nuage Praticable", "BG", [Image.fromarray(layer05_arr, "RGBA")]),
        LayerEntry("06_arche_portail_tourbillon", "Arche Portail Tourbillon", "BG", [Image.fromarray(layer06_arr, "RGBA")]),
        LayerEntry("07_spirale_cyclone_portail", "Spirale Cyclone Portail", "BG", frames_07),
        LayerEntry("08_reflets_bpl_canoniques", "Reflets BPL Canoniques", "BG", frames_08),
        LayerEntry("09_bouffees_nuages_derive", "Bouffees Nuages Derive", "Top", frames_09),
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
        canonical_ref_for_fidelity=REF_DIR / "D13P01.png",
        max_fidelity_distance=30.0,
    )
    print(json.dumps(meta, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
