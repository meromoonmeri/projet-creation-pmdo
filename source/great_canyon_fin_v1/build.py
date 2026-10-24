#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — GCF1 : Grand Canyon — Colline des Anciens / Xatu (D07P02 / A04P01).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks = `24 × 5`) :
  - `00` (`BG`, 24p) : Ciel crépusculaire étoilé natif `D07P02` (`A04P01`, indigo étoilé -> ambre ardent)
  - `01` (`BG`, 24p) : Soleil d'or scintillant de Xatu (`12` frames natives `A04P011.bpa` + `D07P02.bpl`)
  - `02` (`BG`, 24p) : Mer de nuages ambrés dans les 2 abysses latéraux du canyon
  - `03` (`BG`, 24p) : Paillettes solaires ascendantes des abysses
  - `04` (`BG`,  1p) : Promontoire sacré de grès craquelé `D07P02`
  - `05` (`BG`,  1p) : Sentier central des Anciens vers le belvédère de Xatu `D07P02`
  - `06` (`BG`,  1p) : Belvédère Nord & horizon central de mesas striées `D07P02`
  - `07` (`BG`,  1p) : Parois escarpées du promontoire & buttes témoins latérales
  - `08` (`BG`, 24p) : Cailloux clairs & reflets dorés du couchant sur le bord du belvédère
  - `09` (`Top`,24p) : Couronne de rayons solaires de Xatu & poussière d'or Top
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
from source.moteur_forets_pmd_red import build_forest_flora_layer_24
from source.moteur_gouffre_et_canyon_pmd_red import build_hill_of_ancients_layers
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "GCF1"
MAP_TITLE = "Grand Canyon — Colline des Anciens (Xatu)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_great_canyon_fin.png"
CANOPY_PATH = HERE / "bruts" / "cretes_horizon_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_great_canyon_fin.png"
RENDERS_DIR = REPO_ROOT / "renders" / "great_canyon_fin_v1"
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
    sky_mask_nat = mag_nat & (yy_n < 250)
    abyss_mask_nat = mag_nat & (~sky_mask_nat)
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Cailloux clairs D07P02 & liseré solaire du belvédère Nord (Calque 08)
    pebble_glint = (
        solid_nat
        & (yy_n >= 195)
        & (yy_n <= 550)
        & (xx_n >= 120)
        & (xx_n <= 648)
        & (r_c >= 224)
        & (g_c >= 182)
        & (b_c >= 142)
    )
    lbl_g, _ = ndimage.label(pebble_glint)
    g_sizes = np.bincount(lbl_g.ravel())
    keep_g = (g_sizes >= 2) & (g_sizes <= 90)
    keep_g[0] = False
    glint_mask = ndimage.binary_dilation(keep_g[lbl_g], iterations=1) & solid_nat

    sky_24, sun_24, cld_24, emb_24, top_fx_24 = build_hill_of_ancients_layers(
        sky_mask=sky_mask_nat,
        abyss_mask=abyss_mask_nat,
        base_rgb=rgb_nat,
    )
    glint_24 = build_forest_flora_layer_24(
        mode="sinister_woods_mist",
        flora_mask=glint_mask,
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
    )

    # Partition disjointe des 4 calques statiques (04, 05, 06, 07)
    is_plateau_surface = (r_c >= 196) & (g_c >= 142) & (b_c >= 98) & (yy_n >= 195)

    # Calque 05 : Sentier central usé des Anciens vers le belvédère de Xatu (x=315..453, y>=205)
    is_pale_trail = (xx_n >= 315) & (xx_n <= 453) & (yy_n >= 205) & (r_c >= 216) & (g_c >= 168) & (b_c >= 124)
    is_xatu_trail = solid_nat & is_pale_trail

    # Calque 06 : Belvédère Nord de Xatu & horizon central de mesas striées D07P02 (x=220..548, y<=245)
    is_overlook_mesas = solid_nat & (~is_xatu_trail) & (xx_n >= 220) & (xx_n <= 548) & (yy_n <= 245)

    # Calque 04 : Grand plateau de grès craquelé D07P02
    is_promontory_sand = solid_nat & (~is_xatu_trail) & (~is_overlook_mesas) & is_plateau_surface

    # Calque 07 : Parois escarpées du promontoire & buttes témoins latérales
    is_flank_cliffs = solid_nat & (~is_xatu_trail) & (~is_overlook_mesas) & (~is_promontory_sand)

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
    abyss_cliff = ndimage.binary_dilation(abyss_mask_nat, iterations=5)
    walk_nat = (is_promontory_sand | is_xatu_trail) & (~abyss_cliff) & (yy_n >= 210)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    overlook_t = max(28, int(round(0.38 * gh)))
    for ty in range(overlook_t, gh):
        walk_grid[ty, max(0, cx_t - 4) : min(gw, cx_t + 4)] = True
    walk_grid[:26, :] = False
    walk_grid[:, :4] = False
    walk_grid[:, -4:] = False

    layers = [
        LayerEntry("00_ciel_crepusculaire_etoile_d07p02", "Ciel Crépusculaire Étoilé Natif D07P02", "BG", _resize_frames(sky_24, w, h), frame_length=5),
        LayerEntry("01_soleil_or_scintillant_xatu_bpa", "Soleil d'Or Scintillant de Xatu A04P011.bpa", "BG", _resize_frames(sun_24, w, h), frame_length=5),
        LayerEntry("02_mer_nuages_ambres_abysses_canyon", "Mer de Nuages Ambrés des Abysses du Canyon", "BG", _resize_frames(cld_24, w, h), frame_length=5),
        LayerEntry("03_paillettes_solaires_abysses", "Paillettes Solaires Ascendantes des Abysses", "BG", _resize_frames(emb_24, w, h), frame_length=5),
        LayerEntry("04_promontoire_gres_craquele_d07p02", "Promontoire Sacré de Grès Craquelé D07P02", "BG", [mk_static_scaled(is_promontory_sand)], frame_length=5),
        LayerEntry("05_sentier_anciens_belvedere_xatu", "Sentier des Anciens vers le Belvédère de Xatu", "BG", [mk_static_scaled(is_xatu_trail)], frame_length=5),
        LayerEntry("06_belvedere_et_mesas_horizon_d07p02", "Belvédère Nord & Horizon de Mesas Striées D07P02", "BG", [mk_static_scaled(is_overlook_mesas)], frame_length=5),
        LayerEntry("07_parois_promontoire_buttes_temoins", "Parois du Promontoire & Buttes Témoins Latérales", "BG", [mk_static_scaled(is_flank_cliffs)], frame_length=5),
        LayerEntry("08_cailloux_sacres_reflets_couchant", "Cailloux Sacrés & Reflets Dorés du Couchant", "BG", _resize_frames(glint_24, w, h), frame_length=5),
        LayerEntry("09_couronne_rayons_solaires_xatu_top", "Couronne de Rayons Solaires de Xatu & Brise Top", "Top", _resize_frames(top_24, w, h), frame_length=5),
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
        namespace_override="great_canyon_gcf1",
        asset_name_override="great_canyon_fin",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
