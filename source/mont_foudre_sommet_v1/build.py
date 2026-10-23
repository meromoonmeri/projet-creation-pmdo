#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MFA1 — Cime du Mont Foudre — Électhor (`1×` natif Chunsoft GBA `H17P01` + Arcs `H17P01W`).

Fidélité texture & pixel-art `100 %` native à `H17P01` (*Thunder Meadow / Mt. Thunder Peak — Électhor, PMD Red*) :
- Décodage matériel direct `H17P01.{bpl,bpc,bma}` (`27` frames matérielles `.bpl` d'illumination d'orage)
  et `H17P01W.{bpl,bpc,bma,1.bpa}` (`22` frames matérielles d'étincelles électriques, `0` vortex noir Zekrom !) ;
- Ciel d'orage & faille centrale `pal_map == 0` découpés en `#FF00FF` pur sur `bruts/base_mont_foudre_sommet.png` ;
- Arbre central foudroyé, rochers ardoise (`pal_map == 5`) et esplanade d'Électhor à `1×` exact Chunsoft.
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

MAP_ID = "MFA1"
MAP_TITLE = "Cime du Mont Foudre — Électhor"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_mont_foudre_sommet.png"
REF_DIR = HERE / "references"
H17P01_REF = REF_DIR / "h17p01_thunder_meadow_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_foudre_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"

# Courbe matérielle exacte de l'éclair `H17P01.bpl` (12 poses × 10 ticks = 120 ticks)
H17_FLASH_SEQ_12 = [0, 0, 0, 8, 13, 14, 15, 18, 21, 24, 26, 0]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    nat_h17_0, nat_pm, _ = render_gba_native("H17P01", phase=None, bpa_frame=0)
    rgb0 = resize_nearest_rgba(nat_h17_0, w, h)[:, :, :3]

    # Slots matériels Chunsoft exacts de `H17P01` :
    # - `pal_map == 0` : Ciel d'orage sombre & faille centrale Nord (`#FF00FF` dans le brut !)
    # - `pal_map ∈ {1, 2, 4}` : Plateau jaune électrique d'Électhor illuminé par les 27 frames de `H17P01.bpl`
    # - `pal_map == 3` : Franges de nuages bas, talus herbeux & arbre central foudroyé (statique)
    # - `pal_map == 5` : Rochers bleutés d'ardoise (statiques)
    storm_sky_mask = resize_nearest_mask(nat_pm == 0, w, h)
    lit_plateau_mask = resize_nearest_mask(np.isin(nat_pm, [1, 2, 4]), w, h) & (~storm_sky_mask)
    slate_boulders_mask = resize_nearest_mask(nat_pm == 5, w, h) & (~storm_sky_mask)

    if w == W_CANON and h == H_CANON:
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        brut = rgb0.copy()
        brut[storm_sky_mask] = PURE_MAGENTA
        Image.fromarray(brut, mode="RGB").save(DECOR_MAGENTA_RAW)

    terrain_mask = ~storm_sky_mask
    yy, xx = np.mgrid[:h, :w]

    b_h17 = load_gba_map_bundle("H17P01")
    pal = np.unique(b_h17["base_pals"][:, 1:, :3].reshape(-1, 3), axis=0).astype(np.uint8)

    # Arène praticable Sud (`y = 71`) -> Esplanade Nord de la faille d'Électhor (`y = 20..28, x = 44..52`)
    tree_obstacle = (
        (yy >= int(0.41 * h))
        & (yy <= int(0.55 * h))
        & (xx >= int(0.46 * w))
        & (xx <= int(0.54 * w))
    )
    walkable_pixels = (
        terrain_mask
        & (~slate_boulders_mask)
        & (~tree_obstacle)
        & (
            ((yy >= int(0.24 * h)) & (yy <= int(0.78 * h)) & (xx >= int(0.20 * w)) & (xx <= int(0.80 * w)))
            | ((yy >= int(0.68 * h)) & (xx >= int(0.32 * w)) & (xx <= int(0.68 * w)))
        )
    )

    static_crags_all = terrain_mask & (~lit_plateau_mask)
    central_tree_and_boulders = (static_crags_all & (yy >= int(0.36 * h)) & (yy <= int(0.64 * h))) | slate_boulders_mask
    south_turf_crags = static_crags_all & (~central_tree_and_boulders) & (yy >= int(0.64 * h))
    north_cloud_ledge = static_crags_all & (~central_tree_and_boulders) & (~south_turf_crags)

    # Couche 00 : Fond d'orage exact `H17P01` au repos (`0.00` écart à `pose0` !)
    im_00_bg = make_layer_rgba(rgb0, np.ones((h, w), dtype=bool))

    # Couches 01 (ciel d'orage `H17P01.bpl`), 02 (foudre pixel-art dans la faille Nord), 03 (plateau illuminé `H17P01.bpl`)
    frames_01_sky: List[Image.Image] = []
    frames_02_fissure_bolt: List[Image.Image] = []
    frames_03_plateau: List[Image.Image] = []

    for f, k_h17 in enumerate(H17_FLASH_SEQ_12):
        nat_hk, _, _ = render_gba_native("H17P01", phase=(k_h17 / 27.0 if k_h17 > 0 else None), bpa_frame=0)
        rk = resize_nearest_rgba(nat_hk, w, h)[:, :, :3]
        frames_01_sky.append(make_layer_rgba(rk, storm_sky_mask))
        frames_03_plateau.append(make_layer_rgba(rk, lit_plateau_mask))

        bolt_arr = np.zeros((h, w, 4), dtype=np.uint8)
        if k_h17 >= 13:
            # Sillon de foudre pixel-art à 2 px tombant dans la faille centrale Nord d'Électhor (`x ≈ 0.50w`)
            zig = int(0.50 * w) + (((yy // 6) * 5) % 12) - 6
            on_outer = storm_sky_mask & (yy <= int(0.36 * h)) & (np.abs(xx - zig) <= 2)
            on_core = storm_sky_mask & (yy <= int(0.36 * h)) & (np.abs(xx - zig) <= 0)
            bolt_arr[on_outer] = np.array([248, 224, 96, 255], dtype=np.uint8)
            bolt_arr[on_core] = np.array([248, 248, 248, 255], dtype=np.uint8)
        frames_02_fissure_bolt.append(Image.fromarray(bolt_arr, mode="RGBA"))

    im_04_plateau_base = make_layer_rgba(rgb0, lit_plateau_mask)
    im_05_south = make_layer_rgba(rgb0, south_turf_crags)
    im_06_north = make_layer_rgba(rgb0, north_cloud_ledge)
    im_07_tree_rocks = make_layer_rgba(rgb0, central_tree_and_boulders)

    # Couches 08 & 09 : Étincelles & arcs électriques matériels GBA `H17P01W` (`H17P01W1.bpa`, `22` frames GBA !)
    frames_08_arcs: List[Image.Image] = []
    frames_09_sparks_top: List[Image.Image] = []
    for f in range(15):
        arr_bg = np.zeros((h, w, 4), dtype=np.uint8)
        arr_top = np.zeros((h, w, 4), dtype=np.uint8)
        if f > 0:
            w_nat, _, _ = render_gba_native("H17P01W", phase=None, bpa_frame=(f * 22) // 15)
            w_up = resize_nearest_rgba(w_nat, w, h)
            sp = (w_up[:, :, 3] > 0) & (w_up[:, :, 0] >= 104)
            sp_fissure = sp & storm_sky_mask
            sp_arena = sp & terrain_mask & ((((xx // 8) + (yy // 8) + f) % 2) == 0)
            arr_bg[sp_fissure] = np.array([248, 232, 120, 255], dtype=np.uint8)
            arr_top[sp_arena] = np.array([248, 244, 168, 255], dtype=np.uint8)
        frames_08_arcs.append(Image.fromarray(arr_bg, mode="RGBA"))
        frames_09_sparks_top.append(Image.fromarray(arr_top, mode="RGBA"))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_pixels[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.50

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_socle_orage_h17p01", "Socle d'Orage Natif H17P01 1×", "BG", [im_00_bg], frame_length=5),
        LayerEntry("01_ciel_orage_et_faille_h17p01", "Ciel d'Orage & Faille GBA H17P01.bpl", "BG", frames_01_sky, frame_length=10),
        LayerEntry("02_foudre_faille_nord_h17p01", "Sillon de Foudre de la Faille Nord", "BG", frames_02_fissure_bolt, frame_length=10),
        LayerEntry("03_plateau_electrique_illumine_h17p01", "Plateau Doré Illuminé GBA H17P01.bpl", "BG", frames_03_plateau, frame_length=10),
        LayerEntry("04_assise_plateau_dore_h17p01", "Assise du Plateau d'Électhor H17P01", "BG", [im_04_plateau_base], frame_length=5),
        LayerEntry("05_talus_et_rochers_sud_h17p01", "Talus & Escarpements Sud H17P01", "BG", [im_05_south], frame_length=5),
        LayerEntry("06_franges_nuageuses_nord_h17p01", "Franges Nuageuses &Rebords Nord H17P01", "BG", [im_06_north], frame_length=5),
        LayerEntry("07_arbre_foudroye_et_blocs_ardoise_h17p01", "Arbre Foudroyé & Blocs Ardoise H17P01", "BG", [im_07_tree_rocks], frame_length=5),
        LayerEntry("08_arcs_faille_h17p01w", "Arcs Électriques de Faille GBA H17P01W", "BG", frames_08_arcs, frame_length=8),
        LayerEntry("09_etincelles_cime_h17p01w_top", "Étincelles Électriques GBA H17P01W 1×", "Top", frames_09_sparks_top, frame_length=8),
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
        canonical_ref_for_fidelity=H17P01_REF,
        max_fidelity_distance=3.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mont_foudre_mfa1",
        asset_name_override="mont_foudre_sommet",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
