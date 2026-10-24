#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — KYE1 : Grotte Cyclopéenne — Cratère Boisé Gelé & Eau Metano Glacée (Kyurem).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, `0 px` de ciel !) :
  - `00` (`BG`,  1p) : Assise météoritique et permafrost gelé de sécurité (`0 %` ciel)
  - `01` (`BG`,  1p) : Berges rocheuses et banquise entaillées du chenal glaciaire
  - `02` (`BG`,  4p) : Eau Métano Gelée (`Metano_Town_River_Animation_1..4.tile` refroidie, `4 × 10t`)
  - `03` (`BG`,  4p) : Scintillements glaciaires `1×` natifs `Metano_Town_River_Sparkles.tile` (`4 × 10t`)
  - `04` (`BG`,  1p) : Clairière enneigée et toundra glacée du cratère
  - `05` (`BG`,  1p) : Sentier de pierre météoritique Sud→Nord & pont sculpté de pierre et glace
  - `06` (`BG`,  1p) : Rempart du cratère météoritique, falaises de glace vive (`y = 0..268`) & grotte Nord
  - `07` (`BG`,  1p) : Sapins enneigés façon *Frosty Forest* (`D10P01`) & blocs météoritiques givrés
  - `08` (`BG`, 24p) : Cristaux cryo cyan & gemmes ambrées de Kyurem + fleurs hivernales Metano (`24 × 5t`)
  - `09` (`Top`,24p) : Cimes des sapins enneigés & chute de neige matérielle GBA `W03P03` `1×` Top (`24 × 5t`)
"""
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

SOURCE_DIR = Path(__file__).resolve().parent.parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_cyclones_cylindriques_unova import sanitize_rgba_binary
from source.moteur_grotte_cyclopeenne_kyurem import (
    H_CANON as H_NAT,
    TILE_SIZE,
    W_CANON as W_NAT,
    assemble_kyurem_cratere_entree_brut,
    build_glacial_metano_water_layers,
    build_kyurem_entree_crystals_and_snow_top,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "KYE1"
MAP_TITLE = "Grotte Cyclopéenne — Cratère Boisé Gelé & Eau Metano Glacée (Kyurem)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_kyurem_cratere_entree.png"
CANOPY_PATH = HERE / "bruts" / "canopee_arbres_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_kyurem_cratere_entree.png"
D10_REF = HERE / "references" / "d10p01_frosty_forest_entry_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "kyurem_cratere_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    if not BRUT_PATH.is_file() or not CANOPY_PATH.is_file() or not CANON_REF.is_file():
        assemble_kyurem_cratere_entree_brut(HERE)

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    canopy_nat = np.asarray(Image.open(CANOPY_PATH).convert("RGBA"), dtype=np.uint8)

    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]
    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    water_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Pont symétrique central de pierre et glace (x=338..428, y=304..420) : continuité de l'eau Metano dessous
    bridge_box = (xx_n >= 338) & (xx_n <= 428) & (yy_n >= 304) & (yy_n <= 420) & solid_nat
    water_full_nat = water_mask_nat | ((xx_n >= 338) & (xx_n <= 428) & (yy_n >= 350) & (yy_n <= 398))

    water_4, sparkle_4 = build_glacial_metano_water_layers(
        W_NAT,
        H_NAT,
        water_mask=water_full_nat,
        bridge_mask=bridge_box,
        seed=26101,
    )

    # Partitionnement 100 % disjoint des 5 calques statiques de terrain (01, 04, 05, 06, 07)
    is_flat_snow = (r_c >= 224) & (g_c >= 224) & (b_c >= 238) & (np.abs(r_c - g_c) <= 12)
    in_road_corridor = (np.abs(xx_n - 384) <= 44) & (yy_n >= 200)
    is_dark_cobble = in_road_corridor & (~is_flat_snow) & (r_c <= 175) & (g_c <= 185)

    # Calque 06 : Paroi météoritique du cratère, corniches de glace vive (y=0..268, 0 % ciel) & grotte Nord
    is_crater_glacier_wall = solid_nat & (~bridge_box) & (
        (yy_n < 208)
        | ((yy_n < 268) & (np.abs(xx_n - 384) <= 152) & (~is_flat_snow) & (~is_dark_cobble))
        | ((yy_n < 248) & (~is_flat_snow))
    )

    # Calque 05 : Sentier de pierre météoritique Sud -> Nord & pont sculpté de pierre et glace
    is_path_bridge = solid_nat & (~is_crater_glacier_wall) & (bridge_box | is_dark_cobble)

    # Calque 01 : Berges rocheuses et banquise du chenal glaciaire
    near_water = ndimage.binary_dilation(water_mask_nat, iterations=18)
    is_ice_bank = (
        solid_nat
        & (~is_crater_glacier_wall)
        & (~is_path_bridge)
        & near_water
        & (~is_flat_snow)
        & (yy_n >= 220)
        & (yy_n <= 412)
    )

    # Calque 07 : Sapins enneigés façon Frosty Forest (D10P01) & blocs météoritiques givrés
    in_tree_zone = (yy_n >= 285) & ((xx_n < 235) | (xx_n > W_NAT - 235) | (yy_n >= 485))
    is_pine_or_boulder = (
        solid_nat
        & (~is_crater_glacier_wall)
        & (~is_path_bridge)
        & (~is_ice_bank)
        & in_tree_zone
        & (~is_flat_snow)
    )

    # Calque 04 : Clairière enneigée et toundra glacée du cratère (couvre tout le reste de solid_nat sans trou)
    is_snow_clearing = (
        solid_nat
        & (~is_crater_glacier_wall)
        & (~is_path_bridge)
        & (~is_ice_bank)
        & (~is_pine_or_boulder)
    )
    pure_snow_for_flowers = (
        is_snow_clearing & is_flat_snow & (~ndimage.binary_dilation(water_mask_nat, iterations=8))
    )

    lay8_24, top9_24 = build_kyurem_entree_crystals_and_snow_top(
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
        snow_meadow_mask=pure_snow_for_flowers,
        canopy_nat=canopy_nat,
    )

    # Calque 00 : Assise de permafrost météoritique sombre (0 % ciel)
    underlay_rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    underlay_rgba[:, :] = (24, 38, 60, 255)
    underlay_1 = [Image.fromarray(underlay_rgba, mode="RGBA")]

    def mk_static_scaled(mask: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = src_rgb[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Grille de marche continue Sud -> Pont de glace -> Marches de la Grotte Cyclopéenne Nord
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    bank_cliff = ndimage.binary_dilation(water_mask_nat, iterations=5) & (~bridge_box)
    walk_nat = (is_snow_clearing | is_path_bridge) & (~bank_cliff) & (~is_pine_or_boulder)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    cave_top_t = max(2, int(round(0.28 * gh)))
    for ty in range(cave_top_t, gh):
        walk_grid[ty, max(0, cx_t - 3) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry(
            "00_assise_permafrost_meteoritique",
            "Assise Météoritique Gelée Souterraine (0 % Ciel)",
            "BG",
            _resize_frames(underlay_1, w, h),
            frame_length=5,
        ),
        LayerEntry(
            "01_berges_banquise_chenal_glace",
            "Berges Rocheuses & Banquise du Chenal Glaciaire",
            "BG",
            [mk_static_scaled(is_ice_bank)],
            frame_length=5,
        ),
        LayerEntry(
            "02_chenal_eau_metano_gelee_4phases",
            "Eau Métano Gelée (Metano_Town_River Refroidie, 4×10t)",
            "BG",
            _resize_frames(water_4, w, h),
            frame_length=10,
        ),
        LayerEntry(
            "03_sparkles_glaciaires_metano_1x",
            "Reflets Scintillants Glaciaires Natifs Metano Town 1× (4×10t)",
            "BG",
            _resize_frames(sparkle_4, w, h),
            frame_length=10,
        ),
        LayerEntry(
            "04_clairiere_enneigee_toundra_cratere",
            "Clairière Enneigée & Toundra Glacée du Cratère",
            "BG",
            [mk_static_scaled(is_snow_clearing)],
            frame_length=5,
        ),
        LayerEntry(
            "05_sentier_meteoritique_et_pont_glace",
            "Sentier de Pierre Météoritique & Pont Sculpté de Glace",
            "BG",
            [mk_static_scaled(is_path_bridge)],
            frame_length=5,
        ),
        LayerEntry(
            "06_rempart_cratere_glace_et_grotte_nord",
            "Rempart Météoritique, Corniches de Glace sans Ciel & Grotte Nord",
            "BG",
            [mk_static_scaled(is_crater_glacier_wall)],
            frame_length=5,
        ),
        LayerEntry(
            "07_sapins_enneiges_et_blocs_meteorites",
            "Sapins Enneigés façon Frosty Forest & Blocs Météoritiques",
            "BG",
            [mk_static_scaled(is_pine_or_boulder)],
            frame_length=5,
        ),
        LayerEntry(
            "08_cristaux_cryo_et_fleurs_metano_givre",
            "Cristaux Cryo Cyan/Ambre de Kyurem & Fleurs Hivernales Metano",
            "BG",
            _resize_frames(lay8_24, w, h),
            frame_length=5,
        ),
        LayerEntry(
            "09_cimes_givrees_et_neige_w03p03_top",
            "Cimes des Sapins Enneigés & Chute de Neige GBA W03P03 1× Top",
            "Top",
            _resize_frames(top9_24, w, h),
            frame_length=5,
        ),
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
        namespace_override="kyurem_cratere_kye1",
        asset_name_override="kyurem_cratere_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
