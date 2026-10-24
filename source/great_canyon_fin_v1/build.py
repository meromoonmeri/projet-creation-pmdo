#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — GCF1 : Grand Canyon — Colline des Anciens / Xatu (D07P02 / A04P01).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks = `24 × 5`) :
  - `00` (`BG`,  1p) : Ciel crépusculaire étoilé natif `D07P02` + étoiles fixes natives (`A04P01`)
  - `01` (`BG`, 24p) : Familles de nuages PMD générées lointaines du couchant (`16 px/pose`)
  - `02` (`BG`, 24p) : Soleil animé canonique `D07P02` + étoiles scintillantes & étoile filante (`A04P011.bpa` + `D07P02.bpl`)
  - `03` (`BG`, 24p) : Familles de cumulus PMD générées du couchant (`32 px/pose`)
  - `04` (`BG`,  1p) : Promontoire sacré de grès craquelé de la Colline des Anciens `D07P02`
  - `05` (`BG`,  1p) : Sentier central des Anciens vers le belvédère de Xatu `D07P02`
  - `06` (`BG`,  1p) : Horizon panoramique de mesas étagées & buttes témoins `D07P02`
  - `07` (`BG`,  1p) : Parois escarpées du promontoire & ravins ombragés du canyon
  - `08` (`BG`, 24p) : Cailloux clairs & reflets dorés du couchant sur le plateau de Xatu
  - `09` (`Top`,24p) : Crêtes latérales & poussières d'or thermiques Top
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
    sky_mask_nat = mag_nat
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Cailloux clairs D07P02 & éclats dorés sur le promontoire de Xatu (Calque 08)
    pebble_glint = (
        solid_nat
        & (yy_n >= 265)
        & (yy_n <= 560)
        & (xx_n >= 80)
        & (xx_n <= 688)
        & (r_c >= 220)
        & (g_c >= 176)
        & (b_c >= 134)
    )
    lbl_g, _ = ndimage.label(pebble_glint)
    g_sizes = np.bincount(lbl_g.ravel())
    keep_g = (g_sizes >= 2) & (g_sizes <= 96)
    keep_g[0] = False
    glint_mask = ndimage.binary_dilation(keep_g[lbl_g], iterations=1) & solid_nat

    sky_1, cld_far_64, sun_stars_24, cld_near_64, top_fx_24 = build_hill_of_ancients_layers(
        sky_mask=sky_mask_nat,
        abyss_mask=np.zeros_like(sky_mask_nat),
        base_rgb=rgb_nat,
    )

    # Partition disjointe des 5 calques statiques du panorama D07P02 (04, 05, 06, 07, 08)
    is_plateau_tan = (r_c >= 196) & (g_c >= 142) & (b_c >= 96) & (yy_n >= 262)

    # Calque 08 (statique, poses=1) : Cailloux clairs & petits reliefs rocheux du promontoire
    is_pebbles = glint_mask & solid_nat

    # Calque 05 : Sentier central usé des Anciens vers le belvédère de Xatu (x=316..452, y>=266)
    is_pale_trail = (xx_n >= 316) & (xx_n <= 452) & (yy_n >= 266) & (r_c >= 214) & (g_c >= 166) & (b_c >= 120)
    is_xatu_trail = solid_nat & (~is_pebbles) & is_pale_trail

    # Calque 06 : Mer panoramique de mesas étagées & buttes témoins à l'horizon (y=184..340 hors plateau central)
    in_central_promontory_box = (xx_n >= 168) & (xx_n <= 600) & (yy_n >= 264)
    is_distant_mesas = solid_nat & (~is_pebbles) & (~is_xatu_trail) & (yy_n <= 340) & (~(is_plateau_tan & in_central_promontory_box))

    # Calque 04 : Grand promontoire sacré de grès craquelé D07P02
    is_promontory_sand = solid_nat & (~is_pebbles) & (~is_xatu_trail) & (~is_distant_mesas) & is_plateau_tan

    # Calque 07 : Parois escarpées du promontoire & ravins ombragés latéraux
    is_flank_cliffs = solid_nat & (~is_pebbles) & (~is_xatu_trail) & (~is_distant_mesas) & (~is_promontory_sand)

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
    walk_nat = (is_promontory_sand | is_xatu_trail) & (yy_n >= 274)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    overlook_t = max(34, int(round(0.48 * gh)))
    for ty in range(overlook_t, gh):
        walk_grid[ty, max(0, cx_t - 4) : min(gw, cx_t + 4)] = True
    walk_grid[:33, :] = False
    walk_grid[:, :4] = False
    walk_grid[:, -4:] = False

    layers = [
        LayerEntry("00_ciel_crepusculaire_etoile_d07p02", "Ciel Crépusculaire Étoilé Natif D07P02", "BG", _resize_frames(sky_1, w, h), frame_length=5),
        LayerEntry("01_nuages_pmd_couchant_lointains", "Familles de Nuages PMD Lointaines Ultra-Lentes", "BG", _resize_frames(cld_far_64, w, h), frame_length=45),
        LayerEntry("02_soleil_canonique_et_etoiles_bpa", "Soleil Animé Canonique D07P02 & Étoiles A04P011.bpa", "BG", _resize_frames(sun_stars_24, w, h), frame_length=5),
        LayerEntry("03_familles_cumulus_pmd_couchant", "Familles de Cumulus Style PMD Dérive Lente", "BG", _resize_frames(cld_near_64, w, h), frame_length=36),
        LayerEntry("04_promontoire_gres_craquele_d07p02", "Promontoire Sacré de Grès Craquelé D07P02", "BG", [mk_static_scaled(is_promontory_sand)], frame_length=5),
        LayerEntry("05_sentier_anciens_belvedere_xatu", "Sentier des Anciens vers le Belvédère de Xatu", "BG", [mk_static_scaled(is_xatu_trail)], frame_length=5),
        LayerEntry("06_horizon_mesas_et_buttes_d07p02", "Horizon Panoramique de Mesas & Buttes D07P02", "BG", [mk_static_scaled(is_distant_mesas)], frame_length=5),
        LayerEntry("07_parois_escarpees_promontoire", "Parois Escarpées du Promontoire & Ravins", "BG", [mk_static_scaled(is_flank_cliffs)], frame_length=5),
        LayerEntry("08_cailloux_sacres_promontoire", "Cailloux & Pierres Statiques du Promontoire D07P02", "BG", [mk_static_scaled(is_pebbles)], frame_length=5),
        LayerEntry("09_rebords_et_brise_thermique_top", "Crêtes Latérales & Brise Thermique d'Or Top", "Top", _resize_frames(top_24, w, h), frame_length=5),
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
