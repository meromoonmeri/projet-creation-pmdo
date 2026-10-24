#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — GCE1 : Grand Canyon — Entrée (Great Canyon D07P01).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks = `24 × 5`) :
  - `00` (`BG`, 24p) : Ciel aride azur-ambré du Grand Canyon (`H06P05`)
  - `01` (`BG`, 24p) : Cumulus dorés de chaleur à l'horizon des mesas
  - `02` (`BG`, 24p) : Oued turquoise du canyon (`4 × 10` ticks sans écume de berge)
  - `03` (`BG`, 24p) : Reflets solaires scintillants (`Metano_Town_River_Sparkles`)
  - `04` (`BG`,  1p) : Sol sablonneux craquelé d'ocre `D07P01` & berges rocheuses
  - `05` (`BG`,  1p) : Piste centrale claire & pont arche naturel de grès rouge
  - `06` (`BG`,  1p) : Défilé étroit ombragé d'entrée du Grand Canyon (Nord `D07P01`)
  - `07` (`BG`,  1p) : Mesas striées de terre cuite `D07P01` & cheminées de fée
  - `08` (`BG`, 24p) : Cactus & touffes désertiques ondulant dans le vent chaud
  - `09` (`Top`,24p) : Crêtes supérieures des mesas, rayons solaires & poussière d'ocre Top
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
    inpaint_grass_under_flora,
)
from source.moteur_gouffre_et_canyon_pmd_red import build_great_canyon_sky_and_top_layers
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "GCE1"
MAP_TITLE = "Grand Canyon — Entrée (Great Canyon)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_great_canyon_entree.png"
CANOPY_PATH = HERE / "bruts" / "cretes_mesas_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_great_canyon_entree.png"
RENDERS_DIR = REPO_ROOT / "renders" / "great_canyon_entree_v1"
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
    sky_mask_nat = mag_nat & (yy_n < 140)
    water_mask_nat = mag_nat & (~sky_mask_nat)
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Pont arche naturel de grès rouge central (x=275..495, y=350..480) : continuité de l'oued dessous
    bridge_box = (xx_n >= 275) & (xx_n <= 495) & (yy_n >= 350) & (yy_n <= 480) & solid_nat
    water_full_nat = water_mask_nat | ((xx_n >= 275) & (xx_n <= 495) & (yy_n >= 398) & (yy_n <= 462))

    # Cactus & touffes désertiques vert-olive (Calque 08)
    scrub_seed = (
        solid_nat
        & (yy_n >= 420)
        & (yy_n <= 540)
        & (~bridge_box)
        & ((g_c >= r_c - 6) & (g_c > b_c + 24) & (r_c <= 165))
    )
    lbl_s, _ = ndimage.label(ndimage.binary_dilation(scrub_seed, iterations=1))
    s_sizes = np.bincount(lbl_s.ravel())
    keep_s = (s_sizes >= 8) & (s_sizes <= 1600)
    keep_s[0] = False
    flora_mask = ndimage.binary_dilation(keep_s[lbl_s], iterations=1) & solid_nat & (~bridge_box)

    sky_24, cum_24, top_fx_24 = build_great_canyon_sky_and_top_layers(
        sky_mask=sky_mask_nat,
        base_rgb=rgb_nat,
    )
    water_24, sparkle_24 = build_forest_water_and_sparkles_layers(
        mode="tiny_woods_sunlit",
        water_mask=water_full_nat,
        bridge_mask=bridge_box,
    )
    flora_24 = build_forest_flora_layer_24(
        mode="tiny_woods_sunlit",
        flora_mask=flora_mask,
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
    )

    # Partition disjointe des 4 calques statiques (04, 05, 06, 07)
    is_pale_sand_floor = (r_c >= 188) & (g_c >= 132) & (b_c >= 90) & (yy_n >= 185)

    # Calque 06 : Défilé étroit d'entrée du Grand Canyon au Nord-Centre (x=316..452, y=42..208)
    gorge_zone = (xx_n >= 316) & (xx_n <= 452) & (yy_n >= 42) & (yy_n <= 208)
    is_slot_gorge = solid_nat & gorge_zone & (~(is_pale_sand_floor & (yy_n >= 188)))

    # Calque 05 : Piste centrale claire + pont arche naturel de grès rouge
    trail_corridor = (xx_n >= 285) & (xx_n <= 483) & (yy_n >= 185)
    is_very_pale_trail = (r_c >= 208) & (g_c >= 156) & (b_c >= 112)
    is_trail_and_bridge = solid_nat & (~is_slot_gorge) & (bridge_box | (trail_corridor & is_very_pale_trail))

    # Calque 07 : Mesas striées de terre cuite D07P01 (Nord y<=360) & cheminées de fée Sud
    is_hoodoo_south = (yy_n >= 460) & ((xx_n <= 95) | (xx_n >= 673)) & (r_c < 188)
    is_mesa_north = (yy_n <= 375) & (~is_pale_sand_floor) & (~bridge_box)
    is_mesas_cliffs = solid_nat & (~is_slot_gorge) & (~is_trail_and_bridge) & (is_mesa_north | is_hoodoo_south)

    # Calque 04 : Sol sablonneux craquelé d'ocre D07P01 & berges de l'oued
    is_canyon_sand = solid_nat & (~is_slot_gorge) & (~is_trail_and_bridge) & (~is_mesas_cliffs)
    rgb_sand_clean = inpaint_grass_under_flora(rgb_nat, is_canyon_sand, flora_mask)

    def mk_static_scaled(mask_bool: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        rgba[mask_bool, :3] = src_rgb[mask_bool]
        rgba[mask_bool, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(rgba))
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    top_24: List[Image.Image] = []
    can_op = canopy_nat[:, :, 3] >= 128
    for f in range(N_POSES):
        arr = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        arr[can_op] = canopy_nat[can_op]
        sp = np.asarray(top_fx_24[f], dtype=np.uint8)
        sp_op = sp[:, :, 3] >= 128
        arr[sp_op] = sp[sp_op]
        top_24.append(Image.fromarray(sanitize_rgba_binary(arr)))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    bank_cliff = ndimage.binary_dilation(water_mask_nat, iterations=5) & (~bridge_box)
    walk_nat = (is_canyon_sand | is_trail_and_bridge) & (~bank_cliff) & (~flora_mask)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    gorge_top_t = max(2, int(round(0.24 * gh)))
    for ty in range(gorge_top_t, gh):
        walk_grid[ty, max(0, cx_t - 3) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_ciel_aride_grand_canyon", "Ciel Aride Azur-Ambré du Grand Canyon", "BG", _resize_frames(sky_24, w, h), frame_length=5),
        LayerEntry("01_cumulus_dores_chaleur_h06", "Cumulus Dorés de Chaleur H06P05", "BG", _resize_frames(cum_24, w, h), frame_length=5),
        LayerEntry("02_oued_turquoise_grand_canyon", "Oued Turquoise du Grand Canyon 4 Phases", "BG", _resize_frames(water_24, w, h), frame_length=5),
        LayerEntry("03_reflets_solaires_oued_metano", "Reflets Solaires de l'Oued Metano 1×", "BG", _resize_frames(sparkle_24, w, h), frame_length=5),
        LayerEntry("04_sol_sablonneux_craquele_d07", "Sol Sablonneux Craquelé d'Ocre D07P01 & Berges", "BG", [mk_static_scaled(is_canyon_sand, rgb_sand_clean)], frame_length=5),
        LayerEntry("05_piste_et_pont_arche_gres", "Piste Centrale & Pont Arche de Grès Rouge", "BG", [mk_static_scaled(is_trail_and_bridge)], frame_length=5),
        LayerEntry("06_defile_entree_grand_canyon", "Défilé Étroit d'Entrée du Grand Canyon D07P01", "BG", [mk_static_scaled(is_slot_gorge)], frame_length=5),
        LayerEntry("07_mesas_striees_terre_cuite_d07", "Mesas Striées de Terre Cuite D07P01 & Cheminées", "BG", [mk_static_scaled(is_mesas_cliffs)], frame_length=5),
        LayerEntry("08_cactus_et_touffes_vent_chaud", "Cactus & Touffes Désertiques dans le Vent Chaud", "BG", _resize_frames(flora_24, w, h), frame_length=5),
        LayerEntry("09_cretes_rayons_poussiere_top", "Crêtes des Mesas, Rayons Solaires & Poussière Top", "Top", _resize_frames(top_24, w, h), frame_length=5),
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
        namespace_override="great_canyon_gce1",
        asset_name_override="great_canyon_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
