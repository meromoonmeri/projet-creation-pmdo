#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MFE1 — Mont Foudre — Entrée (`1×` natif Chunsoft GBA `D06P01` + Foudre `H17P01` / `H17P01W`).

Fidélité texture & pixel-art `100.0 %` native à `D06P01` (*Mt. Thunder Entrance — PMD Red*) :
- Intégralité du canyon de quartz pâle, des arbres morts noueux (`slot 6`), de l'antre caverneux Nord (`slot 2`)
  et du sentier sablonneux (`slots 0, 5, 7, 8`) issue bit pour bit de `D06P01.{bpl,bpc,bma}` (`distance < 0.5` !) ;
- Découpe `#FF00FF` pure sur `bruts/base_mont_foudre_entree.png` sur les facettes de crête électrisées (`slot 4`)
  et le gouffre d'orage de la caverne Nord (`slot 2`), animés par la courbe matérielle GBA `H17P01.bpl`
  et les arcs électriques GBA `H17P01W` (`H17P01W1.bpa`, `22` frames matérielles).
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

MAP_ID = "MFE1"
MAP_TITLE = "Mont Foudre — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_mont_foudre_entree.png"
REF_DIR = HERE / "references"
D06P01_REF = REF_DIR / "d06p01_mt_thunder_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_foudre_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"

# Intensité matérielle exacte de l'éclair `H17P01.bpl` sur 12 poses × 10 ticks = 120 ticks :
# - `f = 0` (`pose0`, tick 0) = repos `D06P01` `100 %` natif (`boost = 0`)
# - `f = 6` (`pose12`, tick 60) = apogée de la foudre d'Électhor (`boost = +32`)
FLASH_BOOST_12 = [0, 0, 0, 10, 28, 32, 32, 24, 16, 10, 4, 0]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    nat_d06, nat_pm, _ = render_gba_native("D06P01", phase=None, bpa_frame=0)
    rgb = resize_nearest_rgba(nat_d06, w, h)[:, :, :3]

    # Slots matériels Chunsoft exacts de `D06P01` :
    # - `slot 2` : Gouffre caverneux Nord menant au donjon du Mont Foudre (`#FF00FF` dans le brut !)
    # - `slot 4` : Facettes de crêtes de quartz électrisées par l'orage (`#FF00FF` dans le brut !)
    # - `slots 1, 3` : Parois et corniches de quartz sculpté
    # - `slot 6` : Arbres morts foudroyés
    # - `slots 0, 5, 7, 8` : Canyon sablonneux praticable Sud -> Nord
    cave_mask = resize_nearest_mask(nat_pm == 2, w, h)
    storm_quartz_mask = resize_nearest_mask(nat_pm == 4, w, h) & (~cave_mask)
    dead_trees_mask = resize_nearest_mask(nat_pm == 6, w, h) & (~cave_mask) & (~storm_quartz_mask)
    sand_path_slots = resize_nearest_mask(np.isin(nat_pm, [0, 5, 7, 8]), w, h) & (~cave_mask) & (~storm_quartz_mask)

    magenta_zone = cave_mask | storm_quartz_mask
    if w == W_CANON and h == H_CANON:
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        brut = rgb.copy()
        brut[magenta_zone] = PURE_MAGENTA
        Image.fromarray(brut, mode="RGB").save(DECOR_MAGENTA_RAW)

    static_mask = ~magenta_zone
    yy, xx = np.mgrid[:h, :w]

    b_d06 = load_gba_map_bundle("D06P01")
    pal = np.unique(b_d06["base_pals"][:, 1:, :3].reshape(-1, 3), axis=0).astype(np.uint8)

    # Sentier sablonneux continu Sud (`y = 71`) -> Gouffre caverneux Nord (`slot 2`, `y = 22..29, x = 43..53`)
    central_canyon = (
        ((yy >= int(0.28 * h)) & (xx >= int(0.41 * w)) & (xx <= int(0.59 * w)))
        | ((yy >= int(0.46 * h)) & (xx >= int(0.32 * w)) & (xx <= int(0.68 * w)))
    )
    walkable_pixels = (~dead_trees_mask) & (sand_path_slots | cave_mask) & central_canyon

    path_static = static_mask & (~dead_trees_mask) & sand_path_slots & (yy >= int(0.26 * h))
    trees_static = static_mask & dead_trees_mask
    north_cliffs = static_mask & (~path_static) & (~trees_static) & (yy < int(0.44 * h))
    south_cliffs = static_mask & (~path_static) & (~trees_static) & (~north_cliffs) & (yy >= int(0.68 * h))
    side_cliffs = static_mask & (~path_static) & (~trees_static) & (~north_cliffs) & (~south_cliffs)

    # Couche 00 : Fond natif exact `D06P01` (`0.00` écart à `pose0` !)
    im_00_bg = make_layer_rgba(rgb, np.ones((h, w), dtype=bool))

    # Couches 01 (gouffre caverneux Nord `slot 2` traversé d'arcs), 02 (crêtes de quartz `slot 4` illuminées par l'éclair),
    # 08 (halo électrique ambiant sur le canyon au pic de l'éclair)
    frames_01_cave: List[Image.Image] = []
    frames_02_quartz: List[Image.Image] = []
    frames_08_canyon_glow: List[Image.Image] = []

    canyon_rim = static_mask & (~path_static) & (rgb[:, :, 0] >= 184)
    for f, boost in enumerate(FLASH_BOOST_12):
        cave_rgb = rgb.copy()
        quartz_rgb = rgb.copy()
        glow_arr = np.zeros((h, w, 4), dtype=np.uint8)
        if boost > 0:
            # Crêtes de quartz électrisées (`slot 4` `#FF00FF`) illuminées façon `H17P01.bpl`
            quartz_rgb[storm_quartz_mask] = np.clip(
                rgb[storm_quartz_mask].astype(np.int32) + np.array([boost, boost, min(40, boost + 8)]),
                0,
                252,
            ).astype(np.uint8)
            # Lueur d'orage dans les profondeurs de la grotte Nord (`slot 2` `#FF00FF`)
            deep_cave = cave_mask & (rgb.max(axis=2) < 40)
            if boost >= 24:
                zig = int(0.50 * w) + (((yy // 4) * 3) % 10) - 5
                arc = deep_cave & (np.abs(xx - zig) <= 1)
                cave_rgb[arc] = np.array([248, 232, 112], dtype=np.uint8)
            # Reflet d'éclair sur les parois de quartz adjacentes
            lit_rim = np.clip(
                rgb[canyon_rim].astype(np.int32) + np.array([boost // 2, boost // 2, boost // 2 + 6]),
                0,
                248,
            ).astype(np.uint8)
            glow_arr[canyon_rim, :3] = lit_rim
            glow_arr[canyon_rim, 3] = 255

        frames_01_cave.append(make_layer_rgba(cave_rgb, cave_mask))
        frames_02_quartz.append(make_layer_rgba(quartz_rgb, storm_quartz_mask))
        frames_08_canyon_glow.append(Image.fromarray(glow_arr, mode="RGBA"))

    # Couches 03 & 09 : Étincelles électriques matérielles GBA `H17P01W` (`H17P01W1.bpa`, `15 × 8 = 120` ticks, `pose0` vide)
    frames_03_arcs: List[Image.Image] = []
    frames_09_sparks_top: List[Image.Image] = []
    for f in range(15):
        arr_bg = np.zeros((h, w, 4), dtype=np.uint8)
        arr_top = np.zeros((h, w, 4), dtype=np.uint8)
        if f > 0:
            w_nat, _, _ = render_gba_native("H17P01W", phase=None, bpa_frame=(f * 22) // 15)
            w_up = resize_nearest_rgba(w_nat, w, h)
            sp = (w_up[:, :, 3] > 0) & (w_up[:, :, 0] >= 120)
            sp_q = sp & storm_quartz_mask
            sp_fg = sp & (~cave_mask) & ((((xx // 8) + (yy // 8) + f) % 3) == 0)
            arr_bg[sp_q] = np.array([248, 232, 128, 255], dtype=np.uint8)
            arr_top[sp_fg] = np.array([248, 244, 160, 255], dtype=np.uint8)
        frames_03_arcs.append(Image.fromarray(arr_bg, mode="RGBA"))
        frames_09_sparks_top.append(Image.fromarray(arr_top, mode="RGBA"))

    im_04_path = make_layer_rgba(rgb, path_static)
    im_05_south = make_layer_rgba(rgb, south_cliffs)
    im_06_sides = make_layer_rgba(rgb, side_cliffs)
    im_07_north_trees = make_layer_rgba(rgb, north_cliffs | trees_static)

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
        LayerEntry("00_socle_canyon_d06p01", "Socle Canyon de Quartz Natif D06P01 1×", "BG", [im_00_bg], frame_length=5),
        LayerEntry("01_gouffre_grotte_orage_d06p01", "Antre Caverneux Nord d'Orage D06P01", "BG", frames_01_cave, frame_length=10),
        LayerEntry("02_cretes_quartz_electrisees_d06p01", "Crêtes de Quartz Électrisées D06P01", "BG", frames_02_quartz, frame_length=10),
        LayerEntry("03_arcs_quartz_h17p01w", "Arcs Statiques sur le Quartz GBA H17P01W", "BG", frames_03_arcs, frame_length=8),
        LayerEntry("04_sentier_sable_canyon_d06p01", "Sentier Sablonneux Praticable D06P01", "BG", [im_04_path], frame_length=5),
        LayerEntry("05_escarpements_quartz_sud_d06p01", "Escarpements de Quartz Sud D06P01", "BG", [im_05_south], frame_length=5),
        LayerEntry("06_parois_quartz_laterales_d06p01", "Parois Déchiquetées de Quartz D06P01", "BG", [im_06_sides], frame_length=5),
        LayerEntry("07_crete_nord_et_arbres_morts_d06p01", "Crête Nord & Arbres Morts Noueux D06P01", "BG", [im_07_north_trees], frame_length=5),
        LayerEntry("08_reverberation_foudre_canyon_d06p01", "Réverbération d'Éclair GBA H17P01.bpl", "BG", frames_08_canyon_glow, frame_length=10),
        LayerEntry("09_etincelles_foudre_h17p01w_top", "Étincelles Électriques GBA H17P01W 1×", "Top", frames_09_sparks_top, frame_length=8),
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
        canonical_ref_for_fidelity=D06P01_REF,
        max_fidelity_distance=3.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mont_foudre_mfe1",
        asset_name_override="mont_foudre_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
