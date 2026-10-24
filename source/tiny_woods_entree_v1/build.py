#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — TWE1 : Petit Bois — Entrée (Tiny Woods D01P01).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks = `24 × 5`) :
  - `00` (`BG`, 24p) : Ciel clairière ensoleillé style Friend Area PMD Red (`H05P02`)
  - `01` (`BG`, 24p) : Rayons de lumière solaires sur l'horizon du Petit Bois
  - `02` (`BG`, 24p) : Ruisseau clair du Petit Bois (`4 × 10` ticks façon Metano / `H10P02`)
  - `03` (`BG`, 24p) : Reflets scintillants de l'eau (`Metano_Town_River_Sparkles`)
  - `04` (`BG`,  1p) : Prairie d'herbe tendre `D01P01` & berges naturelles
  - `05` (`BG`,  1p) : Sentier sablonneux Sud-Nord & pont en rondins de bois
  - `06` (`BG`,  1p) : Arche feuillue ombragée d'entrée du Petit Bois (Nord)
  - `07` (`BG`,  1p) : Arbres ronds Chunsoft `D01P01`, souches annelées & buissons
  - `08` (`BG`, 24p) : Fleurs sauvages du Petit Bois bercées par la brise
  - `09` (`Top`,24p) : Canopée feuillue en surplomb, rayons dorés Friend Area & pollen flottant
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
    build_forest_sky_and_atmosphere_layers,
    build_forest_water_and_sparkles_layers,
    inpaint_grass_under_flora,
)
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "TWE1"
MAP_TITLE = "Petit Bois — Entrée (Tiny Woods)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_tiny_woods_entree.png"
CANOPY_PATH = HERE / "bruts" / "canopee_arbres_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_tiny_woods_entree.png"
NATIVE_D01_REF = HERE / "references" / "d01p01_tiny_woods_entry_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "tiny_woods_entree_v1"
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

    # Pont en rondins central (x=324..444, y=312..416) : continuité du ruisseau dessous
    bridge_box = (xx_n >= 324) & (xx_n <= 444) & (yy_n >= 312) & (yy_n <= 416) & solid_nat
    water_full_nat = water_mask_nat | ((xx_n >= 328) & (xx_n <= 440) & (yy_n >= 340) & (yy_n <= 398))

    # Fleurs roses & jaunes du Petit Bois (animées sur Calque 08)
    flora_mask = (
        solid_nat
        & (yy_n >= 200)
        & (np.abs(xx_n - 384) > 54)
        & (r_c >= 195)
        & ((r_c > g_c + 18) | ((g_c >= 195) & (b_c <= 128) & (r_c >= 220)))
    )
    # Dilatation d'1 px pour englober le coeur et les pétales
    flora_mask = ndimage.binary_dilation(flora_mask, iterations=1) & solid_nat & (~bridge_box)

    sky_24, horizon_24, top_fx_24 = build_forest_sky_and_atmosphere_layers(
        mode="tiny_woods_sunlit",
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

    # Partition disjointe exacte des 4 calques de terrain statiques (04, 05, 06, 07)
    # Calque 06 : Arche feuillue ombragée d'entrée du Petit Bois (x=320..448, y=68..184)
    portal_zone = (xx_n >= 320) & (xx_n <= 448) & (yy_n >= 68) & (yy_n <= 184)
    is_grass_bright = (g_c >= 208) & (r_c >= 150) & (g_c > b_c + 65)
    is_portal = solid_nat & portal_zone & (~is_grass_bright)

    # Calque 05 : Sentier sablonneux Sud-Nord + pont en rondins de bois
    path_corridor = (xx_n >= 324) & (xx_n <= 444) & (yy_n >= 295)
    is_sandy_or_wood = (r_c > g_c - 15) & (r_c > b_c + 28) & (~is_grass_bright)
    is_path_bridge = solid_nat & (~is_portal) & (bridge_box | (path_corridor & is_sandy_or_wood))

    # Calque 07 : Arbres ronds D01P01, ombres sombres au sol, souches annelées & buissons ronds
    near_water = ndimage.binary_dilation(water_mask_nat, iterations=16)
    is_bank_earth = near_water & (yy_n >= 316) & (yy_n <= 414) & (r_c > b_c + 18) & (g_c < 185)
    is_dark_tree_or_shadow = (g_c < 208) & (~is_bank_earth) & (b_c >= 42) & ((g_c > r_c + 20) | (b_c > r_c + 8))
    # Souches de bois annelées (hors pont et hors berges)
    stump_zone = (~near_water) & (np.abs(xx_n - 384) > 58) & (yy_n >= 175) & (yy_n <= 490)
    is_stump = stump_zone & (~is_grass_bright) & (r_c >= 110) & (r_c >= g_c - 12) & (~flora_mask)
    is_trees_props = solid_nat & (~is_portal) & (~is_path_bridge) & (is_dark_tree_or_shadow | is_stump)

    # Calque 04 : Prairie lumineuse D01P01 & berges naturelles (couvre tout le reste de solid_nat)
    is_meadow_banks = solid_nat & (~is_portal) & (~is_path_bridge) & (~is_trees_props)
    rgb_meadow = inpaint_grass_under_flora(rgb_nat, is_meadow_banks, flora_mask)

    def mk_static_scaled(mask_bool: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        rgba[mask_bool, :3] = src_rgb[mask_bool]
        rgba[mask_bool, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(rgba))
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Calque 09 `Top` : Canopée supérieure + rayons solaires Friend Area + pollen doré
    top_24: List[Image.Image] = []
    can_op = canopy_nat[:, :, 3] >= 128
    for f in range(N_POSES):
        arr = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        arr[can_op] = canopy_nat[can_op]
        sp = np.asarray(top_fx_24[f], dtype=np.uint8)
        sp_op = sp[:, :, 3] >= 128
        arr[sp_op] = sp[sp_op]
        top_24.append(Image.fromarray(sanitize_rgba_binary(arr)))

    # Grille de collision marchable (96 x 72 tuiles à l'échelle 1.0)
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_nat = is_meadow_banks | is_path_bridge
    # Bloquer les talus de berge immédiats au bord de l'eau (sauf sur le pont central)
    bank_cliff = ndimage.binary_dilation(water_mask_nat, iterations=6) & (~bridge_box)
    walk_nat = walk_nat & (~bank_cliff)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    # Garantir le corridor continu Sud -> Pont -> Clairière -> Arche d'entrée du Petit Bois
    cx_t = gw // 2
    portal_top_t = max(2, int(round(0.22 * gh)))
    for ty in range(portal_top_t, gh):
        walk_grid[ty, max(0, cx_t - 2) : min(gw, cx_t + 2)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_ciel_clairiere_petit_bois", "Ciel Clairière Ensoleillé Friend Area PMD Red", "BG", _resize_frames(sky_24, w, h), frame_length=5),
        LayerEntry("01_rayons_soleil_horizon_bois", "Rayons de Lumière Solaires Friend Area (Ciel)", "BG", _resize_frames(horizon_24, w, h), frame_length=5),
        LayerEntry("02_ruisseau_clair_petit_bois", "Ruisseau Clair du Petit Bois 4 Phases", "BG", _resize_frames(water_24, w, h), frame_length=5),
        LayerEntry("03_reflets_eau_petit_bois", "Reflets Scintillants Ruisseau Metano 1×", "BG", _resize_frames(sparkle_24, w, h), frame_length=5),
        LayerEntry("04_prairie_herbe_tendre_d01", "Prairie d'Herbe Tendre Tiny Woods D01P01 & Berges", "BG", [mk_static_scaled(is_meadow_banks, rgb_meadow)], frame_length=5),
        LayerEntry("05_sentier_et_pont_rondins", "Sentier Forestier & Pont en Rondins de Bois", "BG", [mk_static_scaled(is_path_bridge)], frame_length=5),
        LayerEntry("06_arche_entree_petit_bois", "Arche Feuillue Ombragée d'Entrée du Petit Bois", "BG", [mk_static_scaled(is_portal)], frame_length=5),
        LayerEntry("07_arbres_ronds_souches_buissons", "Arbres Ronds Tiny Woods D01P01, Souches & Buissons", "BG", [mk_static_scaled(is_trees_props)], frame_length=5),
        LayerEntry("08_fleurs_et_herbes_brise", "Fleurs Sauvages du Petit Bois dans la Brise", "BG", _resize_frames(flora_24, w, h), frame_length=5),
        LayerEntry("09_canopee_rayons_feuilles_top", "Canopée Tiny Woods, Rayons Friend Area & Pollen Top", "Top", _resize_frames(top_24, w, h), frame_length=5),
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
        namespace_override="tiny_woods_twe1",
        asset_name_override="tiny_woods_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
