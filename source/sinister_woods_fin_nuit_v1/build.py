#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — SWFN : Bois Sinistre — Clairière Fin (Version Nuit).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles) — parité géométrique `1:1` avec `SWF1` :
  - `00` (`BG`,  1p) : Ciel étoilé de minuit du Bois Sinistre (`0 px` brume spectrale cyan)
  - `01` (`BG`, 48p) : Brume toxique générée à faible opacité sur les mares (`48 × 18` ticks)
  - `02` (`BG`, 24p) : Mares d'eau usée nocturne Metano 4 phases (`4 × 10` ticks)
  - `03` (`BG`, 24p) : Reflets troubles nocturnes sur les mares (`Metano_Town_River_Sparkles`)
  - `04` (`BG`,  1p) : Arène centrale nocturne de l'Équipe Méchants & berges sombres
  - `05` (`BG`,  1p) : Chaussée moussue nocturne d'arrivée Sud entre les mares
  - `06` (`BG`,  1p) : Souche creuse monolithique `H07P01` & toiles d'araignée sous la lune `H07P08`
  - `07` (`BG`,  1p) : Enceinte d'arbres bleu-nuit `D04P01`, ombres profondes & souches coupées
  - `08` (`BG`, 24p) : Champignons rouges & violets bioluminescents dans la nuit
  - `09` (`Top`,24p) : Canopée nocturne, volutes toxiques & feux follets à faible opacité Top
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

from source.moteur_cyclones_cylindriques_unova import H as H_NAT, W as W_NAT, sanitize_rgba_binary
from source.moteur_forets_pmd_red import (
    build_forest_flora_layer_24,
    build_forest_water_and_sparkles_layers,
    build_sinister_toxic_mist_and_wisps_layers,
    inpaint_grass_under_flora,
)
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "SWFN"
MAP_TITLE = "Bois Sinistre — Clairière Fin (Version Nuit)"

HERE = Path(__file__).resolve().parent
DAY_BRUT_PATH = SOURCE_DIR / "sinister_woods_fin_v1" / "bruts" / "base_sinister_woods_fin.png"
BRUT_PATH = HERE / "bruts" / "base_sinister_woods_fin_nuit.png"
CANOPY_PATH = HERE / "bruts" / "canopee_arbres_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_sinister_woods_fin_nuit.png"
RENDERS_DIR = REPO_ROOT / "renders" / "sinister_woods_fin_nuit_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    if not BRUT_PATH.is_file() or not CANOPY_PATH.is_file() or not CANON_REF.is_file():
        from source.sinister_woods_fin_nuit_v1.make_brut import main as make_brut_main

        make_brut_main()

    rgb_day = np.asarray(Image.open(DAY_BRUT_PATH).convert("RGB"), dtype=np.uint8)
    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    canopy_nat = np.asarray(Image.open(CANOPY_PATH).convert("RGBA"), dtype=np.uint8)

    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]
    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    sky_mask_nat = mag_nat & (yy_n < 96)
    water_mask_nat = mag_nat & (~sky_mask_nat)
    solid_nat = ~mag_nat

    # Partitionnement 1:1 calé sur les masques exacts de `SWF1`
    r_c = rgb_day[:, :, 0].astype(np.int16)
    g_c = rgb_day[:, :, 1].astype(np.int16)
    b_c = rgb_day[:, :, 2].astype(np.int16)

    mushroom_red = (yy_n >= 165) & (yy_n <= 415) & (r_c >= 125) & (r_c > g_c + 32)
    mushroom_purple = (yy_n >= 165) & (yy_n <= 415) & (r_c >= 80) & (b_c >= 155) & (b_c > g_c + 20)
    stump_glow_spots = (yy_n >= 65) & (yy_n <= 185) & (xx_n >= 310) & (xx_n <= 460) & (r_c >= 200) & (g_c >= 150)
    flora_mask = solid_nat & (mushroom_red | mushroom_purple | stump_glow_spots)
    flora_mask = ndimage.binary_dilation(flora_mask, iterations=1) & solid_nat

    sky_1, toxic_bg_48, top_24 = build_sinister_toxic_mist_and_wisps_layers(
        sky_mask=sky_mask_nat,
        canopy_nat=canopy_nat,
        is_arena_fin=True,
        is_night=True,
    )
    water_24, sparkle_24 = build_forest_water_and_sparkles_layers(
        mode="sinister_woods_wastewater_night",
        water_mask=water_mask_nat,
        bridge_mask=None,
    )
    flora_24 = build_forest_flora_layer_24(
        mode="sinister_woods_mist",
        flora_mask=flora_mask,
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
    )

    in_glade_ellipse = (((xx_n - 384.0) / 245.0) ** 2 + ((yy_n - 295.0) / 138.0) ** 2) <= 1.0
    is_glade_turf = in_glade_ellipse & (g_c >= 120) & (r_c >= 55) & (~mushroom_red) & (~mushroom_purple)

    is_south_causeway = solid_nat & (xx_n >= 312) & (xx_n <= 456) & (yy_n >= 385) & (g_c >= 115) & (r_c >= 60)

    monolith_zone = (xx_n >= 235) & (xx_n <= 535) & (yy_n >= 24) & (yy_n <= 205)
    is_monolith_cobwebs = solid_nat & monolith_zone & (~is_glade_turf)

    near_pools = ndimage.binary_dilation(water_mask_nat, iterations=14)
    is_pool_bank = near_pools & (yy_n >= 390) & (g_c >= 80) & (xx_n >= 42) & (xx_n <= 726)
    is_stump = in_glade_ellipse & (r_c >= 115) & (np.abs(r_c - g_c) <= 32) & (~mushroom_red) & (~mushroom_purple)
    is_perimeter_trees = (~is_glade_turf) & (~is_pool_bank) & (~mushroom_red) & (~mushroom_purple)
    is_trees_props = solid_nat & (~is_monolith_cobwebs) & (~is_south_causeway) & (is_perimeter_trees | is_stump)

    is_arena_banks = solid_nat & (~is_monolith_cobwebs) & (~is_south_causeway) & (~is_trees_props)
    rgb_arena = inpaint_grass_under_flora(rgb_nat, is_arena_banks, flora_mask)

    def mk_static_scaled(mask_bool: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        rgba[mask_bool, :3] = src_rgb[mask_bool]
        rgba[mask_bool, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(rgba))
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    bank_cliff = ndimage.binary_dilation(water_mask_nat, iterations=6)
    walk_nat = (is_arena_banks | is_south_causeway) & (~bank_cliff)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    stump_base_t = max(2, int(round(0.35 * gh)))
    for ty in range(stump_base_t, gh):
        walk_grid[ty, max(0, cx_t - 3) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_ciel_etoile_minuit_bois_sinistre", "Ciel Étoilé de Minuit du Bois Sinistre", "BG", _resize_frames(sky_1, w, h), frame_length=5),
        LayerEntry("01_brume_toxique_mares_nuit_basse_opacite", "Brume Toxique Nocturne Générée à Faible Opacité", "BG", _resize_frames(toxic_bg_48, w, h), frame_length=18),
        LayerEntry("02_mares_eau_usee_nocturne", "Mares d'Eau Usée Nocturne Metano 4 Phases", "BG", _resize_frames(water_24, w, h), frame_length=5),
        LayerEntry("03_reflets_troubles_mares_nocturnes", "Reflets Troubles Nocturnes sur l'Eau Usée 1×", "BG", _resize_frames(sparkle_24, w, h), frame_length=5),
        LayerEntry("04_arene_clairiere_nuit_equipe_mechants", "Arène Centrale Nocturne de la Clairière & Berges", "BG", [mk_static_scaled(is_arena_banks, rgb_arena)], frame_length=5),
        LayerEntry("05_sentier_arene_nuit_bois_sinistre", "Chaussée Moussue Nocturne d'Arrivée Sud", "BG", [mk_static_scaled(is_south_causeway)], frame_length=5),
        LayerEntry("06_souche_creuse_et_toiles_lune_h07", "Souche Creuse Monolithique H07P01 & Toiles sous la Lune", "BG", [mk_static_scaled(is_monolith_cobwebs)], frame_length=5),
        LayerEntry("07_enceinte_arbres_bleu_nuit_d04", "Enceinte d'Arbres Bleu-Nuit D04P01 & Souches", "BG", [mk_static_scaled(is_trees_props)], frame_length=5),
        LayerEntry("08_champignons_bioluminescents_arene_nuit", "Champignons Rouges & Violets Bioluminescents", "BG", _resize_frames(flora_24, w, h), frame_length=5),
        LayerEntry("09_canopee_nuit_brume_feux_follets_top", "Canopée Nocturne, Brume Toxique & Feux Follets Top", "Top", _resize_frames(top_24, w, h), frame_length=8),
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
        namespace_override="sinister_woods_swfn",
        asset_name_override="sinister_woods_fin_nuit",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
