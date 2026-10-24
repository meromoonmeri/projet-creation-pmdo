#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — GCE1 : Grand Canyon — Entrée (Great Canyon D07P01).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks = `24 × 5`) :
  - `00` (`BG`,  1p) : Ciel chaud du Grand Canyon (`azur doré -> orange solaire canonique`)
  - `01` (`BG`, 24p) : Familles de nuages PMD générées lointaines (`16 px/pose`, parallaxe)
  - `02` (`BG`, 24p) : Soleil animé canonique `D07P02` (`A04P011.bpa` + `D07P02.bpl`, `2× NEAREST`)
  - `03` (`BG`, 24p) : Familles de cumulus PMD générées à base plate (`32 px/pose`)
  - `04` (`BG`,  1p) : Sol sablonneux craquelé d'ocre `D07P01` & cailloutis
  - `05` (`BG`,  1p) : Piste centrale claire vers le défilé Nord `D07P01`
  - `06` (`BG`,  1p) : Défilé étroit ombragé d'entrée du Grand Canyon (Nord `D07P01`)
  - `07` (`BG`,  1p) : Parois étagées de terre cuite `D07P01`, corniches & cheminées de fée
  - `08` (`BG`, 24p) : Cactus désertiques ondulant dans le vent chaud
  - `09` (`Top`,24p) : Crêtes supérieures, sommets de hoodoos & brise de sable doré Top
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
    sky_mask_nat = mag_nat
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    sky_1, cld_far_64, sun_24, cld_near_64, top_fx_24 = build_great_canyon_sky_and_top_layers(
        sky_mask=sky_mask_nat,
        base_rgb=rgb_nat,
    )

    # Partition disjointe des 5 calques statiques du canyon D07P01 (04, 05, 06, 07, 08 — ZÉRO cactus !)
    is_pale_sand_floor = (r_c >= 188) & (g_c >= 132) & (b_c >= 88) & (yy_n >= 260)

    # Calque 08 (statique, poses=1) : Rochers isolés & cailloux du fond du canyon (hors parois et cheminées)
    rock_cand = (
        solid_nat
        & (yy_n >= 375)
        & (yy_n <= 545)
        & (xx_n >= 92)
        & (xx_n <= 676)
        & (r_c < 186)
    )
    lbl_rk, _ = ndimage.label(ndimage.binary_dilation(rock_cand, iterations=1))
    rk_sizes = np.bincount(lbl_rk.ravel())
    keep_rk = (rk_sizes >= 18) & (rk_sizes <= 1600)
    keep_rk[0] = False
    is_boulders = keep_rk[lbl_rk] & solid_nat

    # Calque 06 : Défilé étroit d'entrée du Grand Canyon au Nord-Centre (x=304..464, y=130..332)
    gorge_zone = (xx_n >= 304) & (xx_n <= 464) & (yy_n >= 130) & (yy_n <= 332)
    is_slot_gorge = solid_nat & (~is_boulders) & gorge_zone & (~(is_pale_sand_floor & (yy_n >= 312)))

    # Calque 05 : Piste centrale claire de sable foulé menant du Sud vers le défilé Nord
    trail_corridor = (xx_n >= 256) & (xx_n <= 512) & (yy_n >= 290)
    is_very_pale_trail = (r_c >= 206) & (g_c >= 154) & (b_c >= 110)
    is_central_trail = solid_nat & (~is_boulders) & (~is_slot_gorge) & trail_corridor & is_very_pale_trail

    # Calque 07 : Parois étagées de terre cuite D07P01, corniches & cheminées de fée Sud
    is_hoodoo_south = (yy_n >= 470) & ((xx_n <= 102) | (xx_n >= 666)) & (r_c < 190)
    is_mesa_walls = ((yy_n <= 430) & (~is_pale_sand_floor)) | ((xx_n <= 118) & (yy_n <= 485)) | ((xx_n >= 650) & (yy_n <= 485))
    is_mesas_cliffs = solid_nat & (~is_boulders) & (~is_slot_gorge) & (~is_central_trail) & (is_mesa_walls | is_hoodoo_south)

    # Calque 04 : Sol sablonneux craquelé d'ocre D07P01 & cailloutis
    is_canyon_sand = solid_nat & (~is_boulders) & (~is_slot_gorge) & (~is_central_trail) & (~is_mesas_cliffs)

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
    walk_nat = (is_canyon_sand | is_central_trail) & (yy_n >= 296) & (~is_boulders)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    gorge_top_t = max(24, int(round(0.36 * gh)))
    for ty in range(gorge_top_t, gh):
        walk_grid[ty, max(0, cx_t - 3) : min(gw, cx_t + 3)] = True
    walk_grid[:22, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_ciel_aride_grand_canyon", "Ciel Chaud du Grand Canyon D07P01", "BG", _resize_frames(sky_1, w, h), frame_length=5),
        LayerEntry("01_nuages_pmd_lointains_parallaxe", "Familles de Nuages PMD Lointaines Ultra-Lentes", "BG", _resize_frames(cld_far_64, w, h), frame_length=45),
        LayerEntry("02_soleil_canonique_anime_d07p02", "Soleil Animé Canonique D07P02 A04P011.bpa", "BG", _resize_frames(sun_24, w, h), frame_length=5),
        LayerEntry("03_familles_cumulus_pmd_generes", "Familles de Cumulus Style PMD Dérive Lente", "BG", _resize_frames(cld_near_64, w, h), frame_length=36),
        LayerEntry("04_sol_sablonneux_craquele_d07", "Sol Sablonneux Craquelé d'Ocre D07P01", "BG", [mk_static_scaled(is_canyon_sand)], frame_length=5),
        LayerEntry("05_piste_sableuse_centrale_d07", "Piste Centrale de Sable vers le Défilé", "BG", [mk_static_scaled(is_central_trail)], frame_length=5),
        LayerEntry("06_defile_entree_grand_canyon", "Défilé Étroit d'Entrée du Grand Canyon D07P01", "BG", [mk_static_scaled(is_slot_gorge)], frame_length=5),
        LayerEntry("07_mesas_striees_terre_cuite_d07", "Mesas Étagées de Terre Cuite D07P01 & Hoodoos", "BG", [mk_static_scaled(is_mesas_cliffs)], frame_length=5),
        LayerEntry("08_rochers_et_cailloux_canyon_d07", "Rochers & Blocs de Grès Statiques du Canyon D07P01", "BG", [mk_static_scaled(is_boulders)], frame_length=5),
        LayerEntry("09_cretes_hoodoos_et_brise_top", "Crêtes des Mesas, Hoodoos & Brise Dorée Top", "Top", _resize_frames(top_24, w, h), frame_length=5),
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
