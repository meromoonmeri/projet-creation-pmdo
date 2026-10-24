#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — TWF1 : Petit Bois — Clairière Fin (Tiny Woods D01P02 + Metano Town).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks = `24 × 5`) :
  - `00` (`BG`,  1p) : Sous-bois profond de sécurité `D01P02` (zéro ciel visible)
  - `01` (`BG`,  1p) : Berges rocheuses et moussues des bassins jumeaux
  - `02` (`BG`, 24p) : Eau des bassins 100 % native `Metano_Town_River_Animation_1..4` (`4 × 10` ticks)
  - `03` (`BG`, 24p) : Scintillements 100 % natifs `Metano_Town_River_Sparkles.tile` (`4 × 10` ticks)
  - `04` (`BG`,  1p) : Clairière herbeuse du Petit Bois `D01P02`
  - `05` (`BG`,  1p) : Allée centrale herbeuse d'arrivée Sud vers la clairière
  - `06` (`BG`,  1p) : Grand Chêne Ancestral (`H07P06` *Healing Forest*) & racines moussues
  - `07` (`BG`,  1p) : Couronne dense d'arbres `D01P01` fermant 100 % du Nord (0 % ciel), souches & buissons
  - `08` (`BG`, 24p) : Fleurs animées natives `Metano_Town_Animation_Tileset.tile` dans la clairière
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

MAP_ID = "TWF1"
MAP_TITLE = "Petit Bois — Clairière Fin (Tiny Woods)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_tiny_woods_fin.png"
CANOPY_PATH = HERE / "bruts" / "canopee_arbres_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_tiny_woods_fin.png"
NATIVE_H07_REF = HERE / "references" / "h07p06_healing_forest_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "tiny_woods_fin_v1"
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
    # ZÉRO ciel : tout le `#FF00FF` correspond aux bassins jumeaux !
    water_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Bûches & souches 100 % statiques : seules les fleurs natives Metano Town s'animent !
    flora_mask = np.zeros_like(solid_nat)

    # Eau & scintillements 100 % natifs Metano Town (`Metano_Town_River_Animation_1..4` + `Sparkles`)
    water_24, sparkle_24 = build_forest_water_and_sparkles_layers(
        mode="tiny_woods_sunlit",
        water_mask=water_mask_nat,
        bridge_mask=None,
    )

    is_grass_bright = (g_c >= 205) & (r_c >= 145) & (g_c > b_c + 60)

    # Calque 06 : Grand Chêne Ancestral H07P06 & ses racines moussues au Nord-Centre (x=250..518, y=0..252)
    oak_zone = (xx_n >= 250) & (xx_n <= 518) & (yy_n <= 252)
    is_great_oak = solid_nat & oak_zone & (~is_grass_bright)

    # Calque 05 : Allée centrale d'arrivée Sud -> centre de la clairière (x=326..442, y=340..575)
    is_path_causeway = solid_nat & (~is_great_oak) & (xx_n >= 326) & (xx_n <= 442) & (yy_n >= 340) & is_grass_bright

    # Calque 01 : Berges moussues & rocheuses sculptées autour des deux bassins Metano
    near_pools = ndimage.binary_dilation(water_mask_nat, iterations=18)
    is_pool_bank = (
        solid_nat
        & (~is_great_oak)
        & (~is_path_causeway)
        & near_pools
        & (~is_grass_bright)
        & (yy_n >= 336)
        & (xx_n >= 84)
        & (xx_n <= 684)
    )

    # Calque 07 : Couronne dense d'arbres ronds D01P01 fermant tout le Nord (0 % ciel), souches & buissons
    stump_zone = (yy_n >= 225) & (yy_n <= 335) & (xx_n >= 165) & (xx_n <= 605)
    is_stump = stump_zone & (~is_grass_bright)
    is_perimeter_trees = (~is_grass_bright) & (~is_pool_bank)
    is_trees_props = solid_nat & (~is_great_oak) & (~is_path_causeway) & (~is_pool_bank) & (is_perimeter_trees | is_stump)

    # Calque 04 : Clairière herbeuse D01P02
    is_meadow = solid_nat & (~is_great_oak) & (~is_path_causeway) & (~is_pool_bank) & (~is_trees_props)
    rgb_meadow = inpaint_grass_under_flora(rgb_nat, is_meadow, flora_mask)

    # Calques 08 & 09 : Fleurs animées natives Metano Town + Canopée Top sans aucun rayon lumineux
    pure_meadow_for_flowers = is_meadow & is_grass_bright & (~ndimage.binary_dilation(water_mask_nat, iterations=12))
    flora_24, top_24 = build_tiny_woods_metano_flowers_and_canopy_layers(
        pure_grass_mask=pure_meadow_for_flowers,
        flora_mask=flora_mask,
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
        canopy_nat=canopy_nat,
        seed=202,
    )

    def mk_static_scaled(mask_bool: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        rgba[mask_bool, :3] = src_rgb[mask_bool]
        rgba[mask_bool, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(rgba))
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    bank_cliff = ndimage.binary_dilation(water_mask_nat, iterations=8) | is_pool_bank
    walk_nat = (is_meadow | is_path_causeway) & (~bank_cliff)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    oak_base_t = max(2, int(round(0.38 * gh)))
    for ty in range(oak_base_t, gh):
        walk_grid[ty, max(0, cx_t - 3) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_sous_bois_profond_d01p02", "Sous-Bois Profond de Sécurité D01P02 (Zéro Ciel)", "BG", [_build_undergrowth_backdrop(w, h)], frame_length=5),
        LayerEntry("01_berges_moussues_bassins_metano", "Berges Rocheuses et Moussues des Bassins Jumeaux", "BG", [mk_static_scaled(is_pool_bank)], frame_length=5),
        LayerEntry("02_bassins_eau_metano_town", "Eau des Bassins Native Metano Town 4 Phases (10t)", "BG", _resize_frames(water_24, w, h), frame_length=5),
        LayerEntry("03_sparkles_natifs_metano_town", "Scintillements d'Eau Natifs Metano Town Sparkles 1×", "BG", _resize_frames(sparkle_24, w, h), frame_length=5),
        LayerEntry("04_clairiere_herbeuse_d01p02", "Clairière Herbeuse du Petit Bois D01P02", "BG", [mk_static_scaled(is_meadow, rgb_meadow)], frame_length=5),
        LayerEntry("05_allee_centrale_sud", "Allée Centrale Herbeuse d'Arrivée Sud", "BG", [mk_static_scaled(is_path_causeway)], frame_length=5),
        LayerEntry("06_grand_chene_ancestral_h07", "Grand Chêne Ancestral H07P06 & Racines Sacrées", "BG", [mk_static_scaled(is_great_oak)], frame_length=5),
        LayerEntry("07_couronne_arbres_souches_d01", "Couronne Dense d'Arbres Tiny Woods D01P01 (0 % Ciel) & Souches", "BG", [mk_static_scaled(is_trees_props)], frame_length=5),
        LayerEntry("08_fleurs_animees_metano_town", "Fleurs Animées Natives Metano Town dans la Clairière", "BG", _resize_frames(flora_24, w, h), frame_length=5),
        LayerEntry("09_canopee_cimes_et_feuilles_top", "Cimes Surplombantes du Grand Chêne & Feuilles dans la Brise Top", "Top", _resize_frames(top_24, w, h), frame_length=5),
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
        namespace_override="tiny_woods_twf1",
        asset_name_override="tiny_woods_fin",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
