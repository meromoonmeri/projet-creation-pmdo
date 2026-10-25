#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur PMDO 0.8.12.0 — DSR1 : Passe Rocheuse des Écumes — Route Côtière (PMD : Destiny).

Architecture `768 × 576` (`96 × 72` tuiles `8×8`), `10` calques (`9 BG` + `1 Top`), `0 %` ciel :
  - `00` (`BG`,  1p) : Lit rocheux submergé du canyon côtier (`0 %` ciel)
  - `01` (`BG`,  4p) : Torrent Vif Métano Émeraude-Azur (`Metano_Town_River_Animation_1..4.tile`, `4×10t`)
  - `02` (`BG`,  4p) : Scintillements du Torrent `1×` Natifs (`Metano_Town_River_Sparkles.tile`, `4×10t`)
  - `03` (`BG`,  3p) : 3 Cascades Rocheuses Canoniques `1×` *Foggy Forest* (`P03P01A`, `3×10t`)
  - `04` (`BG`,  1p) : Parois rocheuses stratifiées externes & défilé Nord (*Mt. Cleft* + *Altere Pond*)
  - `05` (`BG`,  1p) : Paliers rocheux étagés, éboulis & cristaux d'aigue-marine
  - `06` (`BG`,  1p) : Sentier pavé Sud & escaliers taillés dans la roche
  - `07` (`BG`,  1p) : Arche rocheuse naturelle franchissant le torrent
  - `08` (`BG`, 24p) : VFX Multi-Frames — Rapides d'écume vive & halo résonnant des cristaux (`24×5t`)
  - `09` (`Top`,24p) : VFX Multi-Frames — Rubans de brise côtière & étoiles cristallines Top (`24×5t`)
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
    build_dsr1_vfx_layers,
    build_placed_p03p01a_cascades,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "DSR1"
MAP_TITLE = "PMD : Destiny — Passe Rocheuse des Écumes · Route Côtière"

HERE = Path(__file__).resolve().parent
RAW_MAGENTA = HERE / "bruts" / "decor_route_rocheuse_magenta.png"
BRUT_PATH = HERE / "bruts" / "base_route_passe_corail.png"
CANON_REF = HERE / "references" / "ref_canon_route_passe_corail.png"
RENDERS_DIR = REPO_ROOT / "renders" / "destiny_route_passe_corail_v1"
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
        assemble_destiny_brut(RAW_MAGENTA, BRUT_PATH, CANON_REF, pal_key="gorge_torrent")

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8).copy()
    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]

    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    water_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    # 1) Torrent vif Métano + Sparkles 1× (4×10t)
    water_4, sparkle_4 = build_canonical_metano_liquid_layers(
        W_NAT, H_NAT, water_mask=water_mask_nat, pal_key="gorge_torrent", seed=28201
    )

    # 2) 3 cascades rocheuses canoniques 1× Foggy Forest P03P01A tombant de l'escarpement Nord-Est dans le torrent
    stone_bridge_mask = solid_nat & (xx_n >= 312) & (xx_n <= 504) & (yy_n >= 204) & (yy_n <= 356)
    cascade_specs = [
        (536, 178, 262, "narrow_16", 0),
        (618, 152, 224, "medium_48", 1),
        (686, 146, 214, "narrow_16", 2),
    ]
    cascades_3 = build_placed_p03p01a_cascades(
        w, h, specs=cascade_specs, fg_rgb_mut=rgb_nat, solid_mask=solid_nat, exclude_mask=stone_bridge_mask
    )

    # Segmentation architecturale rocheuse exacte (sans trou)
    is_arch_bridge = stone_bridge_mask
    is_south_stairs_and_promontory = (
        solid_nat & (~is_arch_bridge) & (yy_n >= 316) & (xx_n >= 216) & (xx_n <= 624)
    )
    is_outer_canyon_walls = (
        solid_nat
        & (~is_arch_bridge)
        & (~is_south_stairs_and_promontory)
        & ((yy_n < 88) | (xx_n < 74) | (xx_n > 684) | ((yy_n >= 240) & (xx_n > 590)))
    )
    is_terraced_rock_ledges = (
        solid_nat
        & (~is_arch_bridge)
        & (~is_south_stairs_and_promontory)
        & (~is_outer_canyon_walls)
    )

    # 3) VFX Multi-Frames (24×5t) : rapides d'écume, cristaux pulsants & rubans de brise côtière
    bg_vfx_24, top_vfx_24 = build_dsr1_vfx_layers(w, h, rgb_nat, solid_nat, water_mask_nat)

    underlay = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    underlay[:, :] = (16, 68, 114, 255)
    underlay_1 = [Image.fromarray(underlay, mode="RGBA")]

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = rgb_nat[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    water_margin = ndimage.binary_dilation(water_mask_nat & (~is_arch_bridge), iterations=4)
    north_exit_corridor = (xx_n >= 344) & (xx_n <= 412) & (yy_n <= 108)
    walk_nat = (
        solid_nat
        & (~water_margin)
        & ((~is_outer_canyon_walls) | north_exit_corridor)
    )
    walk_grid = np.asarray(
        Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    ) >= 128
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_lit_rocheux_torrent", "Lit Rocheux Submergé du Canyon (0 % Ciel)", "BG", _resize_frames(underlay_1, w, h), frame_length=5),
        LayerEntry("01_torrent_metano_emeraude", "Torrent Vif Métano Émeraude-Azur (4×10t)", "BG", _resize_frames(water_4, w, h), frame_length=10),
        LayerEntry("02_sparkles_torrent_metano_1x", "Scintillements Natifs Metano Town 1× (4×10t)", "BG", _resize_frames(sparkle_4, w, h), frame_length=10),
        LayerEntry("03_remparts_rocheux_et_defile_nord", "Parois Rocheuses Stratifiées Mt. Cleft / Altere Pond (0 % Ciel)", "BG", [mk_static(is_outer_canyon_walls)], frame_length=5),
        LayerEntry("04_paliers_rocheux_et_cristaux", "Terrasses Rocheuses Étagées & Cristaux d'Aigue-Marine", "BG", [mk_static(is_terraced_rock_ledges)], frame_length=5),
        LayerEntry("05_escalier_sud_et_promontoire", "Escalier Sud Taillé dans le Roc & Promontoire Médian", "BG", [mk_static(is_south_stairs_and_promontory)], frame_length=5),
        LayerEntry("06_pont_arche_pierre_naturelle", "Arche Rocheuse Naturelle Franchissant le Torrent", "BG", [mk_static(is_arch_bridge)], frame_length=5),
        LayerEntry("07_cascades_rocheuses_p03p01a", "3 Cascades Rocheuses Natives 1× Foggy Forest P03P01A (3×10t)", "BG", cascades_3, frame_length=10),
        LayerEntry("08_vfx_rapides_ecume_et_cristaux", "VFX Multi-Frames : Rapides d'Écume & Halo des Cristaux (24×5t)", "BG", bg_vfx_24, frame_length=5),
        LayerEntry("09_vfx_brise_cotiere_et_eclats_top", "VFX Multi-Frames : Rubans de Brise Côtière & Étoiles Cristallines Top (24×5t)", "Top", top_vfx_24, frame_length=5),
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
        namespace_override="pmd_destiny_dsr1",
        asset_name_override="destiny_passe_rocheuse_ecumes",
    )
    _write_halcyon_ground_script(out_dir / "package", "destiny_passe_rocheuse_ecumes")
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    print(json.dumps(build(), indent=2, ensure_ascii=False))
