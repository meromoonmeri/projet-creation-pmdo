#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur PMDO 0.8.12.0 — DSD1 : 1er Donjon (Entrée) — Grotte des Marées Prismatiques (PMD : Destiny).

Architecture `768 × 576` (`96 × 72` tuiles `8×8`), `10` calques (`9 BG` + `1 Top`), `0 %` ciel :
  - `00` (`BG`,  1p) : Abîme sous-marin de la grotte côtière (`0 %` ciel)
  - `01` (`BG`,  4p) : Courants de Marée Métano Saphir (`Metano_Town_River_Animation_1..4.tile`, `4×10t`)
  - `02` (`BG`,  4p) : Scintillements Marins `1×` Natifs (`Metano_Town_River_Sparkles.tile`, `4×10t`)
  - `03` (`BG`,  3p) : 4 Cascades Souterraines Canoniques `1×` *Foggy Forest* (`P03P01A`, `3×10t`)
  - `04` (`BG`,  1p) : Îlots rocheux Sud-Ouest / Sud-Est & berges basses battues par la marée
  - `05` (`BG`,  1p) : Chaussée rocheuse Sud→Nord & marches taillées dans le roc humide
  - `06` (`BG`,  1p) : Parvis rocheux central, stalagmites *Boulder Cave* & cristaux prismatiques
  - `07` (`BG`,  1p) : Haute paroi rocheuse stratifiée *Brine Cave* (`0 %` ciel) & bouche du donjon Nord
  - `08` (`BG`, 24p) : VFX Multi-Frames — 2 Tourbillons de marée en spirale & halo des cristaux (`24×5t`)
  - `09` (`Top`,24p) : VFX Multi-Frames — Gouttes d'eau tombantes avec ondes d'impact & étoiles Top (`24×5t`)
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

from source.moteur_cyclones_cylindriques_unova import sanitize_rgba_binary
from source.moteur_destiny_chapitre1_maps import (
    H_CANON as H_NAT,
    TILE_SIZE,
    W_CANON as W_NAT,
    assemble_destiny_brut,
    build_canonical_metano_liquid_layers,
    build_dsd1_vfx_layers,
    build_placed_p03p01a_cascades,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "DSD1"
MAP_TITLE = "PMD : Destiny — Grotte des Marées Prismatiques · Entrée du 1er Donjon"

HERE = Path(__file__).resolve().parent
RAW_MAGENTA = HERE / "bruts" / "decor_grotte_maree_entree_magenta.png"
BRUT_PATH = HERE / "bruts" / "base_grotte_maree_entree.png"
CANON_REF = HERE / "references" / "ref_canon_grotte_maree_entree.png"
RENDERS_DIR = REPO_ROOT / "renders" / "destiny_donjon1_grotte_maree_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def _write_halcyon_ground_script(pkg_dir: Path, ground_id: str) -> None:
    hdir = pkg_dir / "Data" / "Script" / "halcyon" / "ground" / ground_id
    hdir.mkdir(parents=True, exist_ok=True)
    (hdir / "init.lua").write_text(
        f"require 'origin.common'\n"
        f"local {ground_id} = {{}}\n"
        f"function {ground_id}.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end\n"
        f"function {ground_id}.Enter(map) GAME:FadeIn(20) end\n"
        f"function {ground_id}.Exit(map) end\n"
        f"function {ground_id}.Update(map) end\n"
        f"function {ground_id}.GameSave(map) end\n"
        f"function {ground_id}.GameLoad(map) GAME:FadeIn(20) end\n"
        f"return {ground_id}\n",
        encoding="utf-8",
    )


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    if not BRUT_PATH.is_file() or not CANON_REF.is_file():
        assemble_destiny_brut(RAW_MAGENTA, BRUT_PATH, CANON_REF, pal_key="tidal_sapphire")

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8).copy()
    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]

    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    water_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    # 1) Courants de marée Métano saphir + Sparkles 1× (4×10t)
    water_4, sparkle_4 = build_canonical_metano_liquid_layers(
        W_NAT, H_NAT, water_mask=water_mask_nat, pal_key="tidal_sapphire", seed=28301
    )

    # 2) 4 cascades souterraines canoniques 1× Foggy Forest P03P01A tombant de la corniche rocheuse
    south_causeway = solid_nat & (xx_n >= 276) & (xx_n <= 492) & (yy_n >= 354)
    cascade_specs = [
        (118, 304, 378, "medium_48", 0),
        (206, 372, 446, "narrow_16", 1),
        (562, 372, 446, "narrow_16", 2),
        (650, 304, 378, "medium_48", 0),
    ]
    cascades_3 = build_placed_p03p01a_cascades(
        w, h, specs=cascade_specs, fg_rgb_mut=rgb_nat, solid_mask=solid_nat, exclude_mask=south_causeway
    )

    # Segmentation rocheuse Brine Cave / Boulder Cave (sans trou : îlots d'angle uniquement en bas y>=448)
    is_north_sea_cliff = solid_nat & (yy_n < 214)
    is_south_causeway = south_causeway & (~is_north_sea_cliff)
    is_corner_reefs = (
        solid_nat
        & (~is_north_sea_cliff)
        & (~is_south_causeway)
        & (yy_n >= 448)
        & ((xx_n <= 158) | (xx_n >= 610))
    )
    is_cavern_forecourt = (
        solid_nat & (~is_north_sea_cliff) & (~is_south_causeway) & (~is_corner_reefs)
    )

    # 3) VFX Multi-Frames (24×5t) : tourbillons de marée, cristaux prismatiques & gouttes d'eau
    bg_vfx_24, top_vfx_24 = build_dsd1_vfx_layers(w, h, rgb_nat, solid_nat, water_mask_nat)

    underlay = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    underlay[:, :] = (10, 38, 82, 255)
    underlay_1 = [Image.fromarray(underlay, mode="RGBA")]

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = rgb_nat[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    water_margin = ndimage.binary_dilation(water_mask_nat, iterations=5)
    cave_mouth_corridor = (xx_n >= 332) & (xx_n <= 436) & (yy_n >= 168) & (yy_n <= 232)
    walk_nat = (
        solid_nat
        & (~water_margin)
        & (~is_corner_reefs)
        & ((~is_north_sea_cliff) | cave_mouth_corridor)
        & (xx_n >= 220)
        & (xx_n <= 548)
    )
    walk_grid = np.asarray(
        Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    ) >= 128
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_abime_marin_grotte", "Abîme Sous-Marin de la Grotte Côtière (0 % Ciel)", "BG", _resize_frames(underlay_1, w, h), frame_length=5),
        LayerEntry("01_courants_maree_metano_saphir", "Courants de Marée Métano Saphir (4×10t)", "BG", _resize_frames(water_4, w, h), frame_length=10),
        LayerEntry("02_sparkles_maree_metano_1x", "Scintillements Marins Natifs Metano Town 1× (4×10t)", "BG", _resize_frames(sparkle_4, w, h), frame_length=10),
        LayerEntry("03_paroi_brine_cave_et_bouche_nord", "Haute Paroi Stratifiée Brine Cave (0 % Ciel) & Bouche du Donjon", "BG", [mk_static(is_north_sea_cliff)], frame_length=5),
        LayerEntry("04_parvis_stalagmites_et_cristaux", "Parvis Rocheux, Stalagmites Boulder Cave & Cristaux de Marée", "BG", [mk_static(is_cavern_forecourt)], frame_length=5),
        LayerEntry("05_chaussee_rocheuse_sud_nord", "Chaussée Rocheuse Sud→Nord & Marches Humides", "BG", [mk_static(is_south_causeway)], frame_length=5),
        LayerEntry("06_cascades_souterraines_p03p01a", "4 Cascades Souterraines Natives 1× Foggy Forest P03P01A (3×10t)", "BG", cascades_3, frame_length=10),
        LayerEntry("07_ilots_rocheux_avant_plan", "Îlots Rocheux Sud-Ouest / Sud-Est & Berges de Marée", "BG", [mk_static(is_corner_reefs)], frame_length=5),
        LayerEntry("08_vfx_tourbillons_et_halo_cristaux", "VFX Multi-Frames : 2 Tourbillons en Spirale & Halo Cristaux (24×5t)", "BG", bg_vfx_24, frame_length=5),
        LayerEntry("09_vfx_gouttes_impacts_et_prismes_top", "VFX Multi-Frames : Gouttes Tombantes, Impacts & Étoiles Top (24×5t)", "Top", top_vfx_24, frame_length=5),
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
        namespace_override="pmd_destiny_dsd1",
        asset_name_override="destiny_grotte_maree_entree",
    )
    _write_halcyon_ground_script(out_dir / "package", "destiny_grotte_maree_entree")
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    print(json.dumps(build(), indent=2, ensure_ascii=False))
