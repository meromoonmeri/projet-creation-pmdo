#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — TWE1 : Petit Bois — Lisière & Entrée (Tiny Woods D01P01 + Metano Town).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks = `24 × 5`) :
  - `00` (`BG`,  1p) : Sous-bois profond de sécurité `D01P01` (zéro ciel visible)
  - `01` (`BG`,  1p) : Talus de berge en terre & rebords herbeux du ruisseau
  - `02` (`BG`, 24p) : Eau de rivière 100 % native `Metano_Town_River_Animation_1..4` (`4 × 10` ticks)
  - `03` (`BG`, 24p) : Scintillements 100 % natifs `Metano_Town_River_Sparkles.tile` (`4 × 10` ticks)
  - `04` (`BG`,  1p) : Prairie ouverte du Sud & herbe tendre de lisière `D01P01`
  - `05` (`BG`,  1p) : Sentier sablonneux Sud-Nord & pont rustique en planches de bois
  - `06` (`BG`,  1p) : Entrée ombragée du Petit Bois entre les deux grands troncs (Nord)
  - `07` (`BG`,  1p) : Mur dense d'arbres `D01P01` au Nord (0 % ciel), lisière, souches & buissons
  - `08` (`BG`, 24p) : Fleurs animées natives `Metano_Town_Animation_Tileset.tile` dans la prairie
  - `09` (`Top`,24p) : Cimes feuillues surplombantes & feuilles vertes dans la brise (zéro rayon lumineux)
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
    build_forest_water_and_sparkles_layers,
    build_tiny_woods_metano_flowers_and_canopy_layers,
    inpaint_grass_under_flora,
)
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "TWE1"
MAP_TITLE = "Petit Bois — Lisière & Entrée (Tiny Woods)"

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


def _build_undergrowth_backdrop(w: int, h: int) -> Image.Image:
    """Fond de sécurité forestier sombre tuilé `16×16` (zéro ciel, ultra-léger en `.tile`)."""
    pat = np.full((16, 16, 4), (20, 64, 40, 255), dtype=np.uint8)
    pat[::4, ::4, :3] = (28, 84, 48)
    pat[2::4, 2::4, :3] = (14, 48, 32)
    tiled = np.tile(pat, (h // 16 + 1, w // 16 + 1, 1))[:h, :w]
    return Image.fromarray(tiled, mode="RGBA")


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    canopy_nat = np.asarray(Image.open(CANOPY_PATH).convert("RGBA"), dtype=np.uint8)

    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]
    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    # ZÉRO ciel : tout le `#FF00FF` correspond au ruisseau de lisière !
    water_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Pont en planches et rondins central (x=328..440, y=362..470) : continuité de l'eau Metano dessous
    bridge_box = (xx_n >= 328) & (xx_n <= 440) & (yy_n >= 362) & (yy_n <= 470) & solid_nat
    water_full_nat = water_mask_nat | ((xx_n >= 332) & (xx_n <= 436) & (yy_n >= 398) & (yy_n <= 452))

    # Bûches & souches 100 % statiques : seules les fleurs natives Metano Town (posées sur l'herbe franche) s'animent !
    flora_mask = np.zeros_like(solid_nat)

    # Eau & scintillements 100 % natifs Metano Town (`Metano_Town_River_Animation_1..4` + `Sparkles`)
    water_24, sparkle_24 = build_forest_water_and_sparkles_layers(
        mode="tiny_woods_sunlit",
        water_mask=water_full_nat,
        bridge_mask=bridge_box,
    )

    is_grass_bright = (g_c >= 200) & (r_c >= 140) & (g_c > b_c + 60)

    # Calque 06 : Entrée forestière ombragée au Nord entre les deux grands troncs (x=282..486, y=80..226)
    portal_zone = (xx_n >= 282) & (xx_n <= 486) & (yy_n >= 80) & (yy_n <= 226)
    is_portal = solid_nat & portal_zone & (~is_grass_bright)

    # Calque 05 : Sentier sablonneux Sud-Nord + pont en planches de bois
    path_corridor = (xx_n >= 326) & (xx_n <= 442) & (yy_n >= 188)
    is_sandy_or_wood = (r_c > g_c - 18) & (r_c > b_c + 26) & (~is_grass_bright)
    is_path_bridge = solid_nat & (~is_portal) & (bridge_box | (path_corridor & is_sandy_or_wood))

    # Calque 01 : Talus de berge en terre brune sculptée le long du ruisseau Metano
    near_water = ndimage.binary_dilation(water_mask_nat, iterations=22)
    is_bank_earth = (
        solid_nat
        & (~is_portal)
        & (~is_path_bridge)
        & near_water
        & (yy_n >= 340)
        & (yy_n <= 462)
        & (r_c > b_c + 18)
        & (g_c < 192)
    )

    # Calque 07 : Mur dense d'arbres D01P01 au Nord (0 % ciel), arbres de lisière, souches & buissons
    is_dark_tree_or_shadow = (g_c < 200) & (~is_bank_earth) & (b_c >= 36) & ((g_c > r_c + 18) | (b_c > r_c + 6))
    stump_zone = (~near_water) & (np.abs(xx_n - 384) > 58) & (yy_n >= 220) & (yy_n <= 525)
    is_stump = stump_zone & (~is_grass_bright) & (r_c >= 105) & (r_c >= g_c - 14) & (~flora_mask)
    is_trees_props = solid_nat & (~is_portal) & (~is_path_bridge) & (~is_bank_earth) & (is_dark_tree_or_shadow | is_stump)

    # Calque 04 : Prairie ouverte Sud & herbe tendre de lisière D01P01
    is_meadow = solid_nat & (~is_portal) & (~is_path_bridge) & (~is_bank_earth) & (~is_trees_props)
    rgb_meadow = inpaint_grass_under_flora(rgb_nat, is_meadow, flora_mask)

    # Calques 08 & 09 : Fleurs animées natives Metano Town + Canopée Top sans aucun rayon lumineux
    pure_meadow_for_flowers = is_meadow & is_grass_bright & (~ndimage.binary_dilation(water_mask_nat, iterations=12))
    flora_24, top_24 = build_tiny_woods_metano_flowers_and_canopy_layers(
        pure_grass_mask=pure_meadow_for_flowers,
        flora_mask=flora_mask,
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
        canopy_nat=canopy_nat,
        seed=101,
    )

    def mk_static_scaled(mask_bool: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        rgba[mask_bool, :3] = src_rgb[mask_bool]
        rgba[mask_bool, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(rgba))
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Grille de collision marchable (96 x 72 tuiles) : vaste prairie Sud -> Pont -> Lisière -> Entrée Nord
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    bank_cliff = (ndimage.binary_dilation(water_mask_nat, iterations=6) | is_bank_earth) & (~bridge_box)
    walk_nat = (is_meadow | is_path_bridge) & (~bank_cliff)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    portal_top_t = max(2, int(round(0.24 * gh)))
    for ty in range(portal_top_t, gh):
        walk_grid[ty, max(0, cx_t - 2) : min(gw, cx_t + 2)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_sous_bois_profond_d01", "Sous-Bois Profond de Sécurité D01P01 (Zéro Ciel)", "BG", [_build_undergrowth_backdrop(w, h)], frame_length=5),
        LayerEntry("01_berges_terre_ruisseau_metano", "Talus de Berge en Terre du Ruisseau de Lisière", "BG", [mk_static_scaled(is_bank_earth)], frame_length=5),
        LayerEntry("02_eau_riviere_metano_town", "Eau de Rivière Native Metano Town 4 Phases (10t)", "BG", _resize_frames(water_24, w, h), frame_length=5),
        LayerEntry("03_sparkles_natifs_metano_town", "Scintillements d'Eau Natifs Metano Town Sparkles 1×", "BG", _resize_frames(sparkle_24, w, h), frame_length=5),
        LayerEntry("04_prairie_ouverte_lisiere_d01", "Prairie Ouverte Sud & Herbe de Lisière D01P01", "BG", [mk_static_scaled(is_meadow, rgb_meadow)], frame_length=5),
        LayerEntry("05_sentier_terre_et_pont_bois", "Sentier Sablonneux & Pont Rustique en Planches", "BG", [mk_static_scaled(is_path_bridge)], frame_length=5),
        LayerEntry("06_entree_ombragee_foret_nord", "Entrée Ombragée du Petit Bois entre les Grands Troncs", "BG", [mk_static_scaled(is_portal)], frame_length=5),
        LayerEntry("07_mur_arbres_lisiere_souches", "Mur Dense d'Arbres Tiny Woods D01P01, Lisière & Souches", "BG", [mk_static_scaled(is_trees_props)], frame_length=5),
        LayerEntry("08_fleurs_animees_metano_town", "Fleurs Animées Natives Metano Town dans la Prairie", "BG", _resize_frames(flora_24, w, h), frame_length=5),
        LayerEntry("09_canopee_cimes_et_feuilles_top", "Cimes Surplombantes Tiny Woods & Feuilles dans la Brise Top", "Top", _resize_frames(top_24, w, h), frame_length=5),
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
