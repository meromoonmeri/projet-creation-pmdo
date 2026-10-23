#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MLE1 — Mont Lointain — Entrée (`1×` natif Chunsoft GBA `H05P02` *Rainbow Peak* + Portail Karstique Sacré).

Fidélité texture & pixel-art `100 %` native à `H05P02` (*Rainbow Peak — Ho-Oh, PMD Red*) :
- Décodage matériel direct `H05P02.{bpl,bpc,bma}` (`0` illustration IA lissée, `0` contour noir dur) ;
- Séparation exacte sur les slots matériels Chunsoft :
  * `slots 0, 2` : Ciel stratosphérique azur courbé (`#FF00FF` sur `bruts/decor_entree_magenta.png`) ;
  * `slot 3` : Mer de nuages dorés & crème (`#FF00FF` sur le brut, dérive fluide sur 120 ticks) ;
  * `slots 5..9` : Les 4 arcs-en-ciel pixel-art authentiques Chunsoft (`#FF00FF` sur le brut) ;
  * `slot 4` : Massif karstique central, grand escalier sacré & portail caverneux menant au Mont Lointain ;
  * `slot 1` : Piliers karstiques extérieurs & fougères suspendues émeraude.
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

from moteur_gba_pmd_red_natif import (  # type: ignore
    PURE_MAGENTA,
    load_gba_map_bundle,
    make_layer_rgba,
    render_gba_native,
    resize_nearest_mask,
    resize_nearest_rgba,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "MLE1"
MAP_TITLE = "Mont Lointain — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "decor_entree_magenta.png"
REF_DIR = HERE / "references"
H05P02_REF = REF_DIR / "h05p02_rainbow_peak_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_lointain_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _carve_pixel_karst_portal(rgb: np.ndarray, w: int, h: int) -> Tuple[np.ndarray, np.ndarray]:
    """Sculpte en pixel-art `1×` (palette stricte `H05P02.bpl`, `max(R,G,B) >= 92`) l'arche sacrée
    au sommet du grand escalier central de `H05P02` menant aux 40 étages du Mont Lointain."""
    out = rgb.copy()
    yy, xx = np.mgrid[:h, :w]
    cx = w // 2
    y_bot = int(round(0.415 * h / 2.0)) * 2
    rx_in = max(14, int(round(0.036 * w / 2.0)) * 2)
    ry_in = max(18, int(round(0.068 * h / 2.0)) * 2)
    rx_arch = rx_in + max(6, int(round(0.014 * w / 2.0)) * 2)
    ry_arch = ry_in + max(6, int(round(0.018 * h / 2.0)) * 2)

    # Coordonnées quantifiées au pas de 2 px (grain pixel-art GBA net, zéro anti-aliasing)
    qx = ((xx // 2) * 2 - cx).astype(np.float32)
    qy = ((yy // 2) * 2 - y_bot).astype(np.float32)

    in_arch_outer = (yy <= y_bot) & (
        ((qy >= -ry_arch * 0.45) & (np.abs(qx) <= rx_arch))
        | (((qx / float(rx_arch)) ** 2 + ((qy + ry_arch * 0.45) / float(ry_arch * 0.55)) ** 2) <= 1.0)
    )
    in_cavity = (yy <= y_bot) & (
        ((qy >= -ry_in * 0.45) & (np.abs(qx) <= rx_in))
        | (((qx / float(rx_in)) ** 2 + ((qy + ry_in * 0.45) / float(ry_in * 0.55)) ** 2) <= 1.0)
    )
    arch_ring = in_arch_outer & (~in_cavity)
    bevel = arch_ring & (qy < -ry_in * 0.45)

    # Couleurs exactes de pierre mousseuse & d'ombre douce issues de `H05P02.bpl` (`max >= 96`, zéro noir !)
    out[arch_ring] = np.array([152, 152, 120], dtype=np.uint8)
    out[bevel] = np.array([208, 208, 168], dtype=np.uint8)
    deep_shadow = in_cavity & (yy < y_bot - max(4, h // 96))
    threshold_step = in_cavity & (~deep_shadow)
    out[deep_shadow] = np.array([96, 104, 88], dtype=np.uint8)
    out[threshold_step] = np.array([128, 136, 112], dtype=np.uint8)
    return out, in_cavity


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    nat_rgba, nat_pm, _ = render_gba_native("H05P02", phase=None, bpa_frame=0)
    REF_DIR.mkdir(parents=True, exist_ok=True)
    if not H05P02_REF.is_file():
        Image.fromarray(nat_rgba[:, :, :3], mode="RGB").save(H05P02_REF)

    # Plancher lumineux doux pastel de `H05P02` (`max(R,G,B) >= 92` garanti partout)
    nat_rgb = nat_rgba[:, :, :3].copy()
    maxc = nat_rgb.max(axis=2)
    too_dark = maxc < 92
    if np.any(too_dark):
        lift = (92 - maxc[too_dark])[:, None]
        nat_rgb[too_dark] = np.clip(nat_rgb[too_dark].astype(np.int32) + lift, 0, 255).astype(np.uint8)

    nat_rgba_clean = np.dstack([nat_rgb, np.full(nat_rgb.shape[:2], 255, dtype=np.uint8)])
    rgb_base = resize_nearest_rgba(nat_rgba_clean, w, h)[:, :, :3]
    rgb, portal_mask = _carve_pixel_karst_portal(rgb_base, w, h)

    # Slots matériels Chunsoft exacts de `H05P02` :
    sky_mask = resize_nearest_mask(np.isin(nat_pm, [0, 2]), w, h)
    clouds_mask = resize_nearest_mask(nat_pm == 3, w, h) & (~sky_mask)
    rainbows_mask = resize_nearest_mask(np.isin(nat_pm, [5, 6, 7, 8, 9]), w, h)
    central_massif_mask = (resize_nearest_mask(nat_pm == 4, w, h) | portal_mask) & (~rainbows_mask)
    outer_karst_ferns_mask = resize_nearest_mask(nat_pm == 1, w, h) & (~rainbows_mask) & (~central_massif_mask)

    magenta_bg_mask = (sky_mask | clouds_mask | rainbows_mask) & (~central_massif_mask) & (~outer_karst_ferns_mask)

    if w == W_CANON and h == H_CANON:
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        brut = rgb.copy()
        brut[magenta_bg_mask] = PURE_MAGENTA
        Image.fromarray(brut, mode="RGB").save(DECOR_MAGENTA_RAW)

    yy, xx = np.mgrid[:h, :w]
    b_h05 = load_gba_map_bundle("H05P02")
    pal = np.unique(b_h05["base_pals"][:, 1:, :3].reshape(-1, 3), axis=0).astype(np.uint8)

    # Escalier sacré central reliant `y = 71` (Sud) jusqu'au portail karstique Nord (`y = 22..32, x = 44..52`)
    stairway_corridor = (
        ((yy >= int(0.30 * h)) & (xx >= int(0.42 * w)) & (xx <= int(0.58 * w)))
        | ((yy >= int(0.72 * h)) & (xx >= int(0.36 * w)) & (xx <= int(0.64 * w)))
    )
    walkable_pixels = (central_massif_mask | rainbows_mask | clouds_mask) & stairway_corridor

    stairs_and_portal = central_massif_mask & (yy >= int(0.28 * h)) & (xx >= int(0.40 * w)) & (xx <= int(0.60 * w))
    upper_sanctuary_cliff = central_massif_mask & (~stairs_and_portal)
    distant_spires = outer_karst_ferns_mask & (yy < int(0.42 * h))
    fg_karst_and_ferns = outer_karst_ferns_mask & (~distant_spires)

    # Fond continu ciel + nuages (les zones sous les arcs-en-ciel reçoivent les nuages dorés de la même ligne)
    cloud_bg_rgb = rgb.copy()
    for y_row in range(h):
        row_cl = clouds_mask[y_row]
        if np.any(row_cl):
            med_col = np.median(rgb[y_row, row_cl], axis=0).astype(np.uint8)
            fill_m = rainbows_mask[y_row] | central_massif_mask[y_row] | outer_karst_ferns_mask[y_row]
            cloud_bg_rgb[y_row, fill_m] = med_col

    im_00_sky = make_layer_rgba(cloud_bg_rgb, np.ones((h, w), dtype=bool))

    # Couche 01 : Mer de nuages dorés `H05P02` en dérive horizontale douce (`12 × 10 = 120` ticks, `pose0` = 0 décalage !)
    frames_01_clouds: List[Image.Image] = []
    for f in range(12):
        sh = 0 if f == 0 else int(round(np.sin(2.0 * np.pi * f / 12.0) * max(4.0, w * 0.025)))
        rolled = np.roll(cloud_bg_rgb, shift=sh, axis=1)
        frames_01_clouds.append(make_layer_rgba(rolled, clouds_mask | rainbows_mask))

    # Couche 02 : Les 4 Arcs-en-Ciel Pixel-Art Chunsoft `H05P02` (`slots 5..9`, chatoiement pastel `12 × 10 = 120` ticks)
    frames_02_rainbows: List[Image.Image] = []
    for f in range(12):
        rb_rgb = rgb.copy()
        if f > 0:
            wave = np.sin(2.0 * np.pi * (yy.astype(np.float32) / max(32.0, h * 0.14) - f / 12.0))
            shimmer = rainbows_mask & (wave > 0.15)
            rb_rgb[shimmer] = np.clip(rb_rgb[shimmer].astype(np.int32) + 14, 96, 252).astype(np.uint8)
        frames_02_rainbows.append(make_layer_rgba(rb_rgb, rainbows_mask))

    im_03_distant = make_layer_rgba(rgb, distant_spires)
    im_04_stairs = make_layer_rgba(rgb, stairs_and_portal)
    im_05_massif = make_layer_rgba(rgb, upper_sanctuary_cliff)
    im_06_karst_fg = make_layer_rgba(rgb, fg_karst_and_ferns & (rgb[:, :, 1].astype(int) - rgb[:, :, 0].astype(int) <= 12))
    im_07_ferns = make_layer_rgba(rgb, fg_karst_and_ferns & (rgb[:, :, 1].astype(int) - rgb[:, :, 0].astype(int) > 12))

    # Couches 08 & 09 : Volutes nuageuses naturelles `H05P02` & poussière irisée de Ho-Oh (`0` strie géométrique !)
    cloud_crests = clouds_mask & (rgb[:, :, 0] >= 246) & (rgb[:, :, 1] >= 244) & (rgb[:, :, 2] >= 220)
    frames_08_mist: List[Image.Image] = []
    for f in range(12):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if f > 0:
            sh = int(round(np.sin(2.0 * np.pi * f / 12.0) * max(8.0, w * 0.04)))
            wisp = np.roll(cloud_crests, shift=sh, axis=1) & clouds_mask
            arr[wisp] = np.array([252, 250, 228, 255], dtype=np.uint8)
        frames_08_mist.append(Image.fromarray(arr, mode="RGBA"))

    spark_colors = [
        (252, 236, 176),
        (232, 248, 200),
        (216, 244, 248),
        (248, 224, 224),
    ]
    frames_09_sparks: List[Image.Image] = []
    for f in range(15):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if f > 0:
            sp = (
                (rainbows_mask | stairs_and_portal)
                & ((((xx // 4) * 19 + (yy // 4) * 13 + f * 7) % 97) == 0)
            )
            col = spark_colors[f % len(spark_colors)]
            arr[sp] = np.array([col[0], col[1], col[2], 255], dtype=np.uint8)
        frames_09_sparks.append(Image.fromarray(arr, mode="RGBA"))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_pixels[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.45

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_ciel_azur_stratosphere_h05p02", "Ciel Azur Stratosphérique H05P02 1×", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_mer_nuages_doree_h05p02", "Mer de Nuages Dorés GBA H05P02", "BG", frames_01_clouds, frame_length=10),
        LayerEntry("02_quatre_arcs_en_ciel_h05p02", "Quadruple Arc-en-Ciel Pixel-Art H05P02", "BG", frames_02_rainbows, frame_length=10),
        LayerEntry("03_aiguilles_karst_lointaines_h05p02", "Aiguilles Karstiques d'Horizon H05P02", "BG", [im_03_distant], frame_length=5),
        LayerEntry("04_grand_escalier_et_portail_h05p02", "Grand Escalier Sacré & Portail Nord H05P02", "BG", [im_04_stairs], frame_length=5),
        LayerEntry("05_massif_central_sacree_h05p02", "Massif Karstique Central H05P02", "BG", [im_05_massif], frame_length=5),
        LayerEntry("06_piliers_karstiques_avant_h05p02", "Piliers Karstiques d'Avant-Plan H05P02", "BG", [im_06_karst_fg], frame_length=5),
        LayerEntry("07_fougeres_emeraude_suspendues_h05p02", "Fougères Émeraude Suspendues H05P02", "BG", [im_07_ferns], frame_length=5),
        LayerEntry("08_brumes_dorees_ascendantes_h05p02", "Écharpes de Brume Dorée H05P02", "BG", frames_08_mist, frame_length=10),
        LayerEntry("09_eclats_irises_hooh_top", "Éclats Irisés de Plume Arc-en-Ciel", "Top", frames_09_sparks, frame_length=8),
    ]
    return layers, walk_grid, pal


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    h = max(64, int(round(H_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    layers, walk_grid, _ = build_layers_for_size(w, h)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=H05P02_REF,
        max_fidelity_distance=5.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mont_lointain_mle1",
        asset_name_override="mont_lointain_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
