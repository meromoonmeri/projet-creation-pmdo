#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — SWE1 : Bois Sinistre — Entrée (Sinister Woods D04P01).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks = `24 × 5`) :
  - `00` (`BG`, 24p) : Ciel crépusculaire mystique style Friend Area PMD Red (`H07P08`)
  - `01` (`BG`, 24p) : Rubans de brume spectrale lointaine (`H07P01` *Mist-Rise Forest*)
  - `02` (`BG`, 24p) : Ruisseau sombre du Bois Sinistre (`4 × 10` ticks bleu-sarcelle)
  - `03` (`BG`, 24p) : Reflets cyan-jade sur le ruisseau (`Metano_Town_River_Sparkles`)
  - `04` (`BG`,  1p) : Sol moussu émeraude-sauge `D04P01` & berges ombragées
  - `05` (`BG`,  1p) : Sentier de mousse pâle `D04P01` & vieux pont en bois sombre
  - `06` (`BG`,  1p) : Tunnel forestier indigo sombre d'entrée `D04P01` & racines
  - `07` (`BG`,  1p) : Arbres bleutés Chunsoft `D04P01`, ombres ardoise & souches annelées
  - `08` (`BG`, 24p) : Champignons rouges `D04P01` à lueur de spores animée
  - `09` (`Top`,24p) : Canopée bleutée en surplomb, voile de brume `H07P01` & feux follets Top
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

from source.moteur_cyclones_cylindriques_unova import H as H_NAT, N_POSES, W as W_NAT, sanitize_rgba_binary
from source.moteur_forets_pmd_red import (
    build_forest_flora_layer_24,
    build_forest_water_and_sparkles_layers,
    build_sinister_toxic_mist_and_wisps_layers,
    inpaint_grass_under_flora,
)
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "SWE1"
MAP_TITLE = "Bois Sinistre — Entrée (Sinister Woods)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_sinister_woods_entree.png"
CANOPY_PATH = HERE / "bruts" / "canopee_arbres_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_sinister_woods_entree.png"
NATIVE_D04_REF = HERE / "references" / "d04p01_sinister_woods_entry_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "sinister_woods_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    canopy_nat = np.asarray(Image.open(CANOPY_PATH).convert("RGBA"), dtype=np.uint8)

    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]
    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    sky_mask_nat = mag_nat & (yy_n < 96)
    water_mask_nat = mag_nat & (~sky_mask_nat)
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Vieux pont en bois sombre (x=324..444, y=274..376) : continuité du ruisseau dessous
    bridge_box = (xx_n >= 324) & (xx_n <= 444) & (yy_n >= 274) & (yy_n <= 376) & solid_nat
    water_full_nat = water_mask_nat | ((xx_n >= 328) & (xx_n <= 440) & (yy_n >= 306) & (yy_n <= 366))

    # Champignons rouges caractéristiques de Sinister Woods D04P01 (Calque 08)
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
    )
    water_24, sparkle_24 = build_forest_water_and_sparkles_layers(
        mode="sinister_woods_wastewater",
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

    # Calque 06 : Tunnel forestier indigo sombre D04P01 au Nord-Centre (x=316..452, y=82..182)
    tunnel_zone = (xx_n >= 316) & (xx_n <= 452) & (yy_n >= 82) & (yy_n <= 182)
    is_tunnel = solid_nat & tunnel_zone & (~is_meadow_green)

    # Calque 05 : Sentier de mousse pâle D04P01 + vieux pont de bois central
    is_pale_moss_path = (xx_n >= 336) & (xx_n <= 432) & (yy_n >= 175) & (
        ((yy_n >= 372) & (r_c >= 145) & (g_c >= 210))
        | ((yy_n < 305) & (g_c >= 140) & (r_c >= 92) & (np.abs(xx_n - 384) <= 32))
    )
    is_path_bridge = solid_nat & (~is_tunnel) & (bridge_box | is_pale_moss_path)

    # Calque 07 : Arbres bleu-sarcelle D04P01, ombres indigo au sol & souches annelées
    near_water = ndimage.binary_dilation(water_mask_nat, iterations=14)
    is_creek_bank = near_water & (yy_n >= 286) & (yy_n <= 376) & (~bridge_box) & (g_c >= 88) & (r_c >= 65)
    is_teal_tree_or_shadow = (~is_meadow_green) & (~is_creek_bank) & (~mushroom_mask)
    stump_zone = (yy_n >= 220) & (yy_n <= 450) & (np.abs(xx_n - 384) > 52) & (~near_water)
    is_stump = stump_zone & (r_c >= 115) & (np.abs(r_c - g_c) <= 35)
    is_trees_props = solid_nat & (~is_tunnel) & (~is_path_bridge) & (is_teal_tree_or_shadow | is_stump)

    # Calque 04 : Herbe sauge-émeraude D04P01 & berges moussues
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
    tunnel_top_t = max(2, int(round(0.22 * gh)))
    for ty in range(tunnel_top_t, gh):
        walk_grid[ty, max(0, cx_t - 2) : min(gw, cx_t + 2)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_ciel_crepuscule_sinistre", "Ciel Nocturne Sombre du Bois Sinistre", "BG", _resize_frames(sky_1, w, h), frame_length=5),
        LayerEntry("01_brume_toxique_basse_opacite", "Brume Toxique Générée à Faible Opacité", "BG", _resize_frames(toxic_bg_48, w, h), frame_length=18),
        LayerEntry("02_eau_usee_ruisseau_sinistre", "Ruisseau d'Eau Usée Trouble Metano 4 Phases", "BG", _resize_frames(water_24, w, h), frame_length=5),
        LayerEntry("03_reflets_troubles_eau_usee", "Reflets Troubles sur l'Eau Usée 1×", "BG", _resize_frames(sparkle_24, w, h), frame_length=5),
        LayerEntry("04_herbe_mousse_bois_sinistre", "Herbe Sauge-Émeraude Sinister Woods D04P01 & Berges", "BG", [mk_static_scaled(is_meadow_banks, rgb_meadow)], frame_length=5),
        LayerEntry("05_sentier_mousse_et_vieux_pont", "Sentier de Mousse Pâle D04P01 & Vieux Pont de Bois", "BG", [mk_static_scaled(is_path_bridge)], frame_length=5),
        LayerEntry("06_tunnel_sombre_et_racines_d04", "Tunnel Forestier Sombre Sinister Woods D04P01", "BG", [mk_static_scaled(is_tunnel)], frame_length=5),
        LayerEntry("07_arbres_bleutes_et_souches_d04", "Arbres Bleutés Sinister Woods D04P01 & Souches", "BG", [mk_static_scaled(is_trees_props)], frame_length=5),
        LayerEntry("08_champignons_rouges_spores", "Champignons Rouges D04P01 & Spores Luminescentes", "BG", _resize_frames(flora_24, w, h), frame_length=5),
        LayerEntry("09_canopee_brume_toxique_feux_follets_top", "Canopée, Brume Toxique & Feux Follets Faible Opacité Top", "Top", _resize_frames(top_24, w, h), frame_length=8),
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
        namespace_override="sinister_woods_swe1",
        asset_name_override="sinister_woods_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
