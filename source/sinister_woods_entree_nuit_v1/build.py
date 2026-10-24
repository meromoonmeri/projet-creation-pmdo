#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — SWEN : Bois Sinistre — Entrée (Version Nuit).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles) — parité géométrique `1:1` avec `SWE1` :
  - `00` (`BG`,  1p) : Ciel étoilé de minuit du Bois Sinistre (`0 px` brume spectrale cyan)
  - `01` (`BG`, 48p) : Brume toxique générée à faible opacité (`alpha ~ 15%..28%`, `48 × 18` ticks)
  - `02` (`BG`, 24p) : Ruisseau d'eau usée nocturne Metano 4 phases (`4 × 10` ticks)
  - `03` (`BG`, 24p) : Reflets troubles nocturnes sur l'eau usée (`Metano_Town_River_Sparkles`)
  - `04` (`BG`,  1p) : Herbe mousseuse nocturne sous clair de lune & berges sombres
  - `05` (`BG`,  1p) : Sentier de mousse argenté par la lune & vieux pont de bois nocturne
  - `06` (`BG`,  1p) : Tunnel forestier indigo-noir d'entrée `D04P01` & racines
  - `07` (`BG`,  1p) : Arbres bleu-nuit `D04P01`, ombres profondes & souches annelées
  - `08` (`BG`, 24p) : Champignons écarlates bioluminescents & spores lumineuses
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

MAP_ID = "SWEN"
MAP_TITLE = "Bois Sinistre — Entrée (Version Nuit)"

HERE = Path(__file__).resolve().parent
DAY_BRUT_PATH = SOURCE_DIR / "sinister_woods_entree_v1" / "bruts" / "base_sinister_woods_entree.png"
BRUT_PATH = HERE / "bruts" / "base_sinister_woods_entree_nuit.png"
CANOPY_PATH = HERE / "bruts" / "canopee_arbres_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_sinister_woods_entree_nuit.png"
RENDERS_DIR = REPO_ROOT / "renders" / "sinister_woods_entree_nuit_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    if not BRUT_PATH.is_file() or not CANOPY_PATH.is_file() or not CANON_REF.is_file():
        from source.sinister_woods_entree_nuit_v1.make_brut import main as make_brut_main

        make_brut_main()

    rgb_day = np.asarray(Image.open(DAY_BRUT_PATH).convert("RGB"), dtype=np.uint8)
    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    canopy_nat = np.asarray(Image.open(CANOPY_PATH).convert("RGBA"), dtype=np.uint8)

    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]
    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    sky_mask_nat = mag_nat & (yy_n < 96)
    water_mask_nat = mag_nat & (~sky_mask_nat)
    solid_nat = ~mag_nat

    # Partitionnement 1:1 calé sur les masques exacts de `SWE1` pour une transition Jour/Nuit parfaite
    r_c = rgb_day[:, :, 0].astype(np.int16)
    g_c = rgb_day[:, :, 1].astype(np.int16)
    b_c = rgb_day[:, :, 2].astype(np.int16)

    bridge_box = (xx_n >= 324) & (xx_n <= 444) & (yy_n >= 274) & (yy_n <= 376) & solid_nat
    water_full_nat = water_mask_nat | ((xx_n >= 328) & (xx_n <= 440) & (yy_n >= 306) & (yy_n <= 366))

    mushroom_mask = (
        solid_nat
        & (yy_n >= 165)
        & (yy_n <= 315)
        & (~bridge_box)
        & (r_c >= 125)
        & (r_c > g_c + 35)
        & (r_c > b_c + 25)
    )
    mushroom_mask = ndimage.binary_dilation(mushroom_mask, iterations=1) & solid_nat & (~bridge_box)

    sky_1, toxic_bg_48, top_24 = build_sinister_toxic_mist_and_wisps_layers(
        sky_mask=sky_mask_nat,
        canopy_nat=canopy_nat,
        is_arena_fin=False,
        is_night=True,
    )
    water_24, sparkle_24 = build_forest_water_and_sparkles_layers(
        mode="sinister_woods_wastewater_night",
        water_mask=water_full_nat,
        bridge_mask=bridge_box,
    )
    flora_24 = build_forest_flora_layer_24(
        mode="sinister_woods_mist",
        flora_mask=mushroom_mask,
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
    )

    is_meadow_green = (g_c >= 132) & (g_c > b_c + 12) & (r_c >= 72)
    tunnel_zone = (xx_n >= 316) & (xx_n <= 452) & (yy_n >= 82) & (yy_n <= 182)
    is_tunnel = solid_nat & tunnel_zone & (~is_meadow_green)

    is_pale_moss_path = (xx_n >= 336) & (xx_n <= 432) & (yy_n >= 175) & (
        ((yy_n >= 372) & (r_c >= 145) & (g_c >= 210))
        | ((yy_n < 305) & (g_c >= 140) & (r_c >= 92) & (np.abs(xx_n - 384) <= 32))
    )
    is_path_bridge = solid_nat & (~is_tunnel) & (bridge_box | is_pale_moss_path)

    near_water = ndimage.binary_dilation(water_mask_nat, iterations=14)
    is_creek_bank = near_water & (yy_n >= 286) & (yy_n <= 376) & (~bridge_box) & (g_c >= 88) & (r_c >= 65)
    is_teal_tree_or_shadow = (~is_meadow_green) & (~is_creek_bank) & (~mushroom_mask)
    stump_zone = (yy_n >= 220) & (yy_n <= 450) & (np.abs(xx_n - 384) > 52) & (~near_water)
    is_stump = stump_zone & (r_c >= 115) & (np.abs(r_c - g_c) <= 35)
    is_trees_props = solid_nat & (~is_tunnel) & (~is_path_bridge) & (is_teal_tree_or_shadow | is_stump)

    is_meadow_banks = solid_nat & (~is_tunnel) & (~is_path_bridge) & (~is_trees_props)
    rgb_meadow = inpaint_grass_under_flora(rgb_nat, is_meadow_banks, mushroom_mask)

    def mk_static_scaled(mask_bool: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        rgba[mask_bool, :3] = src_rgb[mask_bool]
        rgba[mask_bool, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(rgba))
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    bank_cliff = ndimage.binary_dilation(water_mask_nat, iterations=5) & (~bridge_box)
    walk_nat = (is_meadow_banks | is_path_bridge) & (~bank_cliff)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    portal_y_t = max(2, int(round(0.28 * gh)))
    for ty in range(portal_y_t, gh):
        walk_grid[ty, max(0, cx_t - 3) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_ciel_etoile_minuit_sinistre", "Ciel Étoilé de Minuit du Bois Sinistre", "BG", _resize_frames(sky_1, w, h), frame_length=5),
        LayerEntry("01_brume_toxique_nuit_basse_opacite", "Brume Toxique Nocturne Générée à Faible Opacité", "BG", _resize_frames(toxic_bg_48, w, h), frame_length=18),
        LayerEntry("02_eau_usee_nocturne_ruisseau", "Ruisseau d'Eau Usée Nocturne Metano 4 Phases", "BG", _resize_frames(water_24, w, h), frame_length=5),
        LayerEntry("03_reflets_troubles_nocturnes", "Reflets Troubles Nocturnes sur l'Eau Usée 1×", "BG", _resize_frames(sparkle_24, w, h), frame_length=5),
        LayerEntry("04_herbe_mousse_nuit_bois_sinistre", "Herbe Mousseuse Nocturne sous Clair de Lune & Berges", "BG", [mk_static_scaled(is_meadow_banks, rgb_meadow)], frame_length=5),
        LayerEntry("05_sentier_lune_et_vieux_pont_nuit", "Sentier de Mousse Nocturne & Vieux Pont de Bois", "BG", [mk_static_scaled(is_path_bridge)], frame_length=5),
        LayerEntry("06_tunnel_sombre_et_racines_nuit", "Tunnel Forestier Sombre Nocturne D04P01", "BG", [mk_static_scaled(is_tunnel)], frame_length=5),
        LayerEntry("07_arbres_bleu_nuit_et_souches", "Arbres Bleu-Nuit D04P01 & Souches Annelées", "BG", [mk_static_scaled(is_trees_props)], frame_length=5),
        LayerEntry("08_champignons_bioluminescents_nuit", "Champignons Écarlates Bioluminescents & Spores", "BG", _resize_frames(flora_24, w, h), frame_length=5),
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
        namespace_override="sinister_woods_swen",
        asset_name_override="sinister_woods_entree_nuit",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
