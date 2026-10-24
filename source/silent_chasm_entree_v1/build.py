#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — SCE1 : Gouffre Silencieux — Entrée (Silent Chasm D05P01).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks = `24 × 5`) :
  - `00` (`BG`, 24p) : Ciel brumeux d'altitude `D05P01`
  - `01` (`BG`, 24p) : Rubans de nuages d'ardoise sur les crêtes
  - `02` (`BG`, 24p) : Abîme sans fond & brouillard parallaxe GBA natif `D05P01` Couche 0
  - `03` (`BG`, 24p) : Courants ascendants du gouffre
  - `04` (`BG`,  1p) : Versants boisés d'épicéas sombres `D05P01` & sommets lointains
  - `05` (`BG`,  1p) : Éperon rocheux étroit & sentier central Sud-Nord `D05P01`
  - `06` (`BG`,  1p) : Gueule rocheuse d'entrée du Gouffre Silencieux (Nord)
  - `07` (`BG`,  1p) : Parois d'ardoise escarpées & arêtes latérales
  - `08` (`BG`, 24p) : Cailloux & touffes des falaises frémissant dans le courant d'air
  - `09` (`Top`,24p) : Crêtes latérales & voiles de brume GBA `D05P01` dérivant au-dessus de l'éperon
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
from source.moteur_forets_pmd_red import build_forest_flora_layer_24, inpaint_grass_under_flora
from source.moteur_gouffre_et_canyon_pmd_red import build_silent_chasm_layers
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "SCE1"
MAP_TITLE = "Gouffre Silencieux — Entrée (Silent Chasm)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_silent_chasm_entree.png"
CANOPY_PATH = HERE / "bruts" / "cretes_gouffre_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_silent_chasm_entree.png"
RENDERS_DIR = REPO_ROOT / "renders" / "silent_chasm_entree_v1"
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
    sky_mask_nat = mag_nat & (yy_n < 165)
    abyss_mask_nat = mag_nat & (~sky_mask_nat)
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Touffes d'épicéas claires & petits cailloux sur l'éperon et les versants (Calque 08)
    pebble_or_tuft = (
        solid_nat
        & (yy_n >= 165)
        & (yy_n <= 555)
        & (
            ((xx_n >= 245) & (xx_n <= 523) & (r_c >= 158) & (g_c >= 165) & (b_c >= 165))
            | (((xx_n < 235) | (xx_n > 533)) & (g_c >= r_c + 6) & (g_c > b_c + 24) & (g_c >= 86) & (g_c <= 115))
        )
    )
    lbl_p, _ = ndimage.label(pebble_or_tuft)
    p_sizes = np.bincount(lbl_p.ravel())
    keep_p = (p_sizes >= 3) & (p_sizes <= 280)
    keep_p[0] = False
    detail_mask = ndimage.binary_dilation(keep_p[lbl_p], iterations=1) & solid_nat

    sky_24, hor_24, aby_24, spk_24, top_fx_24 = build_silent_chasm_layers(
        mode="silent_chasm_entry",
        sky_mask=sky_mask_nat,
        abyss_mask=abyss_mask_nat,
        base_rgb=rgb_nat,
    )
    detail_24 = build_forest_flora_layer_24(
        mode="sinister_woods_mist",
        flora_mask=detail_mask,
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
    )

    # Partition disjointe des 4 calques statiques (04, 05, 06, 07)
    # Calque 06 : Gueule rocheuse d'entrée du Gouffre Silencieux (x=296..472, y=64..204)
    maw_zone = (xx_n >= 296) & (xx_n <= 472) & (yy_n >= 64) & (yy_n <= 204)
    is_taupe_floor = (np.abs(r_c - g_c) <= 18) & (r_c > b_c + 6) & (r_c >= 115) & (r_c <= 172)
    is_cave_maw = solid_nat & maw_zone & (~(is_taupe_floor & (yy_n >= 178)))

    # Calque 05 : Éperon rocheux étroit & sentier poussiéreux gris-taupe D05P01 (x=220..548, y>=175)
    ridge_corridor = (xx_n >= 220) & (xx_n <= 548) & (yy_n >= 175)
    is_ridge_path = solid_nat & (~is_cave_maw) & ridge_corridor & is_taupe_floor

    # Calque 04 : Versants boisés d'épicéas vert-olive sombres D05P01 & pics lointains
    is_pine_or_far_peak = (
        solid_nat
        & (~is_cave_maw)
        & (~is_ridge_path)
        & (((xx_n < 250) | (xx_n > 518)) & ((g_c > b_c + 8) | (yy_n < 145)))
    )

    # Calque 07 : Parois d'ardoise escarpées du gouffre (reste exact de solid_nat)
    is_slate_cliffs = solid_nat & (~is_cave_maw) & (~is_ridge_path) & (~is_pine_or_far_peak)
    rgb_clean = inpaint_grass_under_flora(rgb_nat, is_ridge_path | is_pine_or_far_peak, detail_mask)

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
    abyss_cliff = ndimage.binary_dilation(abyss_mask_nat, iterations=6)
    walk_nat = is_ridge_path & (~abyss_cliff)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    maw_top_t = max(2, int(round(0.24 * gh)))
    for ty in range(maw_top_t, gh):
        walk_grid[ty, max(0, cx_t - 3) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_ciel_brumeux_gouffre_d05", "Ciel Brumeux d'Altitude D05P01", "BG", _resize_frames(sky_24, w, h), frame_length=5),
        LayerEntry("01_nuages_cretes_gouffre", "Rubans de Nuages d'Ardoise des Crêtes", "BG", _resize_frames(hor_24, w, h), frame_length=5),
        LayerEntry("02_abime_et_brouillard_gba_d05", "Abîme Sans Fond & Brouillard GBA D05P01 1×", "BG", _resize_frames(aby_24, w, h), frame_length=5),
        LayerEntry("03_courants_ascendants_gouffre", "Courants Ascendants du Gouffre Silencieux", "BG", _resize_frames(spk_24, w, h), frame_length=5),
        LayerEntry("04_versants_epiceas_sombres_d05", "Versants d'Épicéas Sombres D05P01 & Pics Lointains", "BG", [mk_static_scaled(is_pine_or_far_peak, rgb_clean)], frame_length=5),
        LayerEntry("05_eperon_et_sentier_gouffre_d05", "Éperon Rocheux Étroit & Sentier D05P01", "BG", [mk_static_scaled(is_ridge_path, rgb_clean)], frame_length=5),
        LayerEntry("06_gueule_rocheuse_entree_d05", "Gueule Rocheuse du Gouffre Silencieux D05P01", "BG", [mk_static_scaled(is_cave_maw)], frame_length=5),
        LayerEntry("07_parois_ardoise_escarpees_d05", "Parois d'Ardoise Escarpées & Arêtes Rocheuses", "BG", [mk_static_scaled(is_slate_cliffs)], frame_length=5),
        LayerEntry("08_cailloux_et_touffes_rafale", "Cailloux & Mousses des Falaises dans la Rafale", "BG", _resize_frames(detail_24, w, h), frame_length=5),
        LayerEntry("09_brume_gba_d05_et_cretes_top", "Voiles de Brume GBA D05P01 & Crêtes Top", "Top", _resize_frames(top_24, w, h), frame_length=5),
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
        namespace_override="silent_chasm_sce1",
        asset_name_override="silent_chasm_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
