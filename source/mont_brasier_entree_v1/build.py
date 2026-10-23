#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MBE1 — Mont Brasier — Entrée (`1×` natif Chunsoft GBA `D09P01` + Flammèches `W04`).

Fidélité texture & pixel-art `100 %` native à `D09P01` (*Mt. Blaze Entrance — PMD Red*) :
- Décodage matériel direct `D09P01.{bpl,bpc,bma}` (`6` poses matérielles GBA `.bpl` sur les bassins de lave,
  les deux cascades verticales Nord et les parois de basalte chauffées) ;
- Découpe `#FF00FF` pure sur `bruts/base_mont_brasier_entree.png` couvrant l'intégralité des lacs & cascades de lave ;
- Flammèches volcaniques authentiques GBA `W04` (`W041.bpa`).
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
    build_gba_weather_overlay_frames,
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

MAP_ID = "MBE1"
MAP_TITLE = "Mont Brasier — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_mont_brasier_entree.png"
REF_DIR = HERE / "references"
D09P01_REF = REF_DIR / "d09p01_mt_blaze_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_brasier_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"

# Séquence ping-pong 10 poses × 12 ticks = 120 ticks sur les 6 frames matérielles `D09P01.bpl` :
# - tick 0 (`pose0`, idx 0) = frame GBA `0` (fidélité `0.00` au repos !)
# - tick 60 (`pose12`, idx 5) = frame GBA `5` (contraste thermique maximal !)
GBA_PINGPONG_10 = [0, 1, 2, 3, 4, 5, 4, 3, 2, 1]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    # Pré-décodage des 6 frames matérielles exactes de `D09P01.bpl`
    gba_frames_rgb: List[np.ndarray] = []
    nat_pm0 = None
    for k in range(6):
        nat_rgba_k, pm_k, _ = render_gba_native("D09P01", phase=(k / 6.0 if k > 0 else None), bpa_frame=0)
        if nat_pm0 is None:
            nat_pm0 = pm_k
        gba_frames_rgb.append(resize_nearest_rgba(nat_rgba_k, w, h)[:, :, :3])

    assert nat_pm0 is not None
    rgb0 = gba_frames_rgb[0]

    # Slots matériels Chunsoft de `D09P01` :
    # - `pal_map ∈ {0, 3, 5}` : Bassins de lave en fusion + 2 cascades verticales de lave au Nord (`#FF00FF` dans le brut !)
    # - `pal_map ∈ {2, 4}` : Colonnes & falaises de basalte rougies par la réverbération thermique
    # - `pal_map ∈ {1, 6}` : Arche caverneuse Nord & sentier de pierre volcanique craquelée
    # Détection exacte de la lave incandescente & des 2 cascades verticales de `D09P01` (`R - B >= 52 & R >= 104`)
    # ZÉRO sélection des parois sombres de l'arche caverneuse Nord !
    molten_rgb = (
        ((rgb0[:, :, 0].astype(np.int16) - rgb0[:, :, 1].astype(np.int16) >= 28) & (rgb0[:, :, 0] >= 64))
        | ((rgb0[:, :, 0].astype(np.int16) - rgb0[:, :, 2].astype(np.int16) >= 52) & (rgb0[:, :, 0] >= 104))
    )
    lava_mask = resize_nearest_mask(np.isin(nat_pm0, [0, 3, 5]), w, h) & molten_rgb
    yy_tmp, _ = np.mgrid[:h, :w]
    cascade_mask = lava_mask & (yy_tmp < int(0.42 * h))
    lake_mask = lava_mask & (~cascade_mask)
    heat_cliff_mask = resize_nearest_mask(np.isin(nat_pm0, [2, 4]), w, h) & (~lava_mask)

    if w == W_CANON and h == H_CANON:
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        brut = rgb0.copy()
        brut[lava_mask] = PURE_MAGENTA
        Image.fromarray(brut, mode="RGB").save(DECOR_MAGENTA_RAW)

    rock_mask = ~lava_mask
    yy, xx = np.mgrid[:h, :w]

    b_d09 = load_gba_map_bundle("D09P01")
    pal = np.unique(b_d09["base_pals"][:, 1:, :3].reshape(-1, 3), axis=0).astype(np.uint8)

    # Sentier central praticable Sud (`y = 71`) -> Arche de grotte Nord (`y = 24..31, x = 44..52`)
    central_spine = (yy >= int(0.32 * h)) & (xx >= int(0.45 * w)) & (xx <= int(0.55 * w))
    path_corridor = central_spine | (
        (yy >= int(0.45 * h))
        & (yy <= int(0.76 * h))
        & (xx >= int(0.32 * w))
        & (xx <= int(0.68 * w))
        & rock_mask
    )
    walkable_pixels = path_corridor
    path_rock_pixels = path_corridor & rock_mask
    north_arch_and_columns = rock_mask & (~path_rock_pixels) & (yy < int(0.46 * h))
    south_crags = rock_mask & (~path_rock_pixels) & (~north_arch_and_columns) & (yy >= int(0.68 * h))
    side_basalt = rock_mask & (~path_rock_pixels) & (~north_arch_and_columns) & (~south_crags)

    # Couche 00 : Fond magmatique exact `D09P01` au repos
    im_00_bg = make_layer_rgba(rgb0, np.ones((h, w), dtype=bool))

    # Couches 01 & 02 : Bassins de lave (`slots 0, 3`) & Cascades jumelles Nord (`slot 5`) animés par `D09P01.bpl` !
    frames_01_lakes: List[Image.Image] = []
    frames_02_cascades: List[Image.Image] = []
    frames_08_heat_cliffs: List[Image.Image] = []
    tau = 2.0 * np.pi
    for idx_f, k_gba in enumerate([0, 1, 2, 3, 4, 3, 5, 4, 2, 1]):
        rk = gba_frames_rgb[k_gba].copy()
        # Sur les cœurs jaune d'or des bassins & cascades, onde descendante/radiale fidèle aux teintes `D09P01.bpl`
        if idx_f > 0:
            # Modulation thermique strictement proportionnelle sur le pixel-art `D09P01` (zéro aplat rectangulaire !)
            pulse = 0.5 - 0.5 * np.cos(tau * idx_f / 10.0)
            wave_lake = np.sin(tau * ((xx.astype(np.float32) * 0.5 + yy.astype(np.float32)) / max(48.0, w * 0.14) - idx_f / 10.0))
            d_lake = np.round((16.0 + 10.0 * wave_lake) * pulse).astype(np.int32)
            mod_l = rk.copy()
            mod_l[:, :, 0] = np.clip(rk[:, :, 0].astype(np.int32) + d_lake, 0, 248).astype(np.uint8)
            mod_l[:, :, 1] = np.clip(rk[:, :, 1].astype(np.int32) + d_lake, 0, 232).astype(np.uint8)
            rk[lake_mask] = mod_l[lake_mask]

            wave_fall = np.sin(tau * (yy.astype(np.float32) / max(28.0, h * 0.09) - idx_f / 10.0))
            d_fall = np.round((18.0 + 12.0 * wave_fall) * pulse).astype(np.int32)
            mod_c = rk.copy()
            mod_c[:, :, 0] = np.clip(rk[:, :, 0].astype(np.int32) + d_fall, 0, 252).astype(np.uint8)
            mod_c[:, :, 1] = np.clip(rk[:, :, 1].astype(np.int32) + d_fall, 0, 240).astype(np.uint8)
            rk[cascade_mask] = mod_c[cascade_mask]

        frames_01_lakes.append(make_layer_rgba(rk, lake_mask))
        frames_02_cascades.append(make_layer_rgba(rk, cascade_mask))
        if idx_f == 0:
            frames_08_heat_cliffs.append(Image.fromarray(np.zeros((h, w, 4), dtype=np.uint8), mode="RGBA"))
        else:
            changed_cliff = heat_cliff_mask & np.any(gba_frames_rgb[k_gba] != rgb0, axis=2)
            frames_08_heat_cliffs.append(make_layer_rgba(gba_frames_rgb[k_gba], changed_cliff))

    # Couche 03 : Remous de rive incandescents au pied des berges basses uniquement (`15 × 8 = 120` ticks, `pose0` vide)
    shore_band = ndimage.binary_dilation(rock_mask, iterations=2) & lava_mask & (yy >= int(0.40 * h))
    frames_03_shore: List[Image.Image] = []
    for f in range(15):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if f > 0:
            sw = np.sin(tau * ((xx.astype(np.float32) + yy.astype(np.float32)) / max(32.0, w * 0.09) - f / 15.0))
            lit = shore_band & (sw > 0.45)
            arr[lit, :3] = np.array([248, 208, 96], dtype=np.uint8)
            arr[lit, 3] = 255
        frames_03_shore.append(Image.fromarray(arr, mode="RGBA"))

    im_04_path = make_layer_rgba(rgb0, path_rock_pixels)
    im_05_south = make_layer_rgba(rgb0, south_crags)
    im_06_sides = make_layer_rgba(rgb0, side_basalt)
    im_07_arch = make_layer_rgba(rgb0, north_arch_and_columns)

    # Couche 09 (`Top`) : Flammèches volcaniques authentiques GBA `W04` (`W041.bpa`, `15 × 8 = 120` ticks)
    embers_top = build_gba_weather_overlay_frames(
        "W04",
        w=w,
        h=h,
        n_frames=15,
        scroll_dx_per_loop=-24,
        scroll_dy_per_loop=-64,
        tint_palette=[(248, 152, 48), (248, 224, 120)],
        subsample_keep_mod=6,
    )

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_pixels[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.55

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_socle_magma_d09p01", "Socle de Lave Natif D09P01 1×", "BG", [im_00_bg], frame_length=5),
        LayerEntry("01_bassins_lave_fusion_d09p01", "Bassins de Lave en Fusion GBA D09P01", "BG", frames_01_lakes, frame_length=12),
        LayerEntry("02_cascades_lave_nord_d09p01", "Cascades Jumelles de Lave Nord GBA D09P01", "BG", frames_02_cascades, frame_length=12),
        LayerEntry("03_remous_rives_lave_d09p01", "Remous Incandescents des Berges Basses", "BG", frames_03_shore, frame_length=8),
        LayerEntry("04_sentier_basalte_craquele_d09p01", "Sentier Central de Pierre Volcanique D09P01", "BG", [im_04_path], frame_length=5),
        LayerEntry("05_escarpements_sud_d09p01", "Escarpements Volcaniques Sud D09P01", "BG", [im_05_south], frame_length=5),
        LayerEntry("06_colonnes_basalte_laterales_d09p01", "Colonnes Basaltiques Est & Ouest D09P01", "BG", [im_06_sides], frame_length=5),
        LayerEntry("07_arche_caverneuse_nord_d09p01", "Arche Caverneuse Nord du Mont Brasier D09P01", "BG", [im_07_arch], frame_length=5),
        LayerEntry("08_reflets_thermiques_parois_d09p01", "Reflets Thermiques GBA sur Parois D09P01", "BG", frames_08_heat_cliffs, frame_length=12),
        LayerEntry("09_flammeches_volcaniques_w04_top", "Flammèches Volcaniques Canoniques GBA W04 1×", "Top", embers_top, frame_length=8),
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
        canonical_ref_for_fidelity=D09P01_REF,
        max_fidelity_distance=4.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mont_brasier_mbe1",
        asset_name_override="mont_brasier_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
