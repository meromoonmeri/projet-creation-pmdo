#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur PMDO 0.8.12.0 — MWE1 : Grotte Ouest — Crique Marine Secrète & Eau Métano Abyssale (Mewtwo).

Layout 100 % original de péninsule côtière asymétrique en S (`768 × 576`, `96 × 72` tuiles, `0 %` ciel,
aucun pont ni rivière horizontale — fidèle au récit officiel `D20P01` et aux orgues de `H13P02`) :
  - `00` (`BG`,  1p) : Assise sous-marine d'obsidienne côtière (`0 %` ciel)
  - `01` (`BG`,  1p) : Récifs & berges basaltiques battus par la crique marine
  - `02` (`BG`,  4p) : Eau Métano Abyssale (`Metano_Town_River_Animation_1..4.tile` assombrie, `4 × 10t`)
  - `03` (`BG`,  4p) : Scintillements marins `1×` natifs `Metano_Town_River_Sparkles.tile` (`4 × 10t`)
  - `04` (`BG`,  1p) : Promontoire côtier d'ardoise & terrasses rocheuses
  - `05` (`BG`,  1p) : Escalier côtier naturel en S grimpant du rivage Sud vers la faille Nord
  - `06` (`BG`,  1p) : Haute falaise maritime d'ardoise (`0 %` ciel) & bouche de la Grotte Ouest
  - `07` (`BG`,  1p) : Orgues stalagmitiques hexagonales `H13P02` à couronnes bleu-jade
  - `08` (`BG`, 24p) : Pulsation psychique des couronnes de jade & ressac télékinétique (`24 × 5t`)
  - `09` (`Top`,24p) : Voûte de la faille & étoiles psychiques à 4 branches `H13P02` Top (`24 × 5t`)
"""
from __future__ import annotations

import json
import math
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
from source.moteur_kanto_mewtwo_mew import (
    H_CANON as H_NAT,
    TILE_SIZE,
    W_CANON as W_NAT,
    assemble_mwe1_brut,
    build_mwe1_psychic_crystals_and_mist_top,
    build_themed_metano_water_layers,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "MWE1"
MAP_TITLE = "Grotte Ouest — Crique Marine Secrète & Orgues Psychiques (Mewtwo)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_grotte_ouest_entree.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_grotte_ouest_entree.png"
RENDERS_DIR = REPO_ROOT / "renders" / "grotte_ouest_entree_v1"
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
        assemble_mwe1_brut(HERE)

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]

    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    water_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    water_4, sparkle_4 = build_themed_metano_water_layers(
        W_NAT,
        H_NAT,
        water_mask=water_mask_nat,
        pal_key="abyssal",
        shore_foam=True,
        seed=27150,
    )

    # Couloir en S de l'escalier côtier reliant le rivage Sud (x~320, y=575) à la faille Nord (x~284, y=212)
    t_norm = np.clip((yy_n.astype(np.float32) - 216.0) / 360.0, 0.0, 1.0)
    s_center_x = 292.0 + 188.0 * np.sin(np.pi * np.power(t_norm, 0.85)) + 32.0 * t_norm
    in_s_stair_corridor = (yy_n >= 210) & (np.abs(xx_n.astype(np.float32) - s_center_x) <= 58.0)

    # 1) Orgues stalagmitiques H13P02 (fûts clairs et couronnes bleu-jade hors chemin plat d'ardoise)
    is_stalagmite_col = solid_nat & (~in_s_stair_corridor) & (
        ((g_c >= 146) & (b_c >= 126))
        | ((r_c >= 124) & (g_c >= 134) & (yy_n >= 80))
    )

    # 2) Haute falaise maritime Nord & bouche sombre de la Grotte Ouest (0 % ciel)
    is_sea_cliff_wall = solid_nat & (~is_stalagmite_col) & (
        (yy_n < 214)
        | ((yy_n < 282) & ((xx_n < 210) | (xx_n > 420)))
    )

    # 3) Escalier côtier naturel en S & paliers d'ardoise
    is_s_stairway = solid_nat & (~is_stalagmite_col) & (~is_sea_cliff_wall) & in_s_stair_corridor

    # 4) Récifs et berges basaltiques au contact de la crique marine
    near_sea = ndimage.binary_dilation(water_mask_nat, iterations=18)
    is_coastal_reef = (
        solid_nat
        & (~is_stalagmite_col)
        & (~is_sea_cliff_wall)
        & (~is_s_stairway)
        & near_sea
    )

    # 5) Promontoire d'ardoise côtier (complément exact sans trou)
    is_promontory = (
        solid_nat
        & (~is_stalagmite_col)
        & (~is_sea_cliff_wall)
        & (~is_s_stairway)
        & (~is_coastal_reef)
    )

    lay8_24, top9_24 = build_mwe1_psychic_crystals_and_mist_top(
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
        water_mask=water_mask_nat,
    )

    underlay_rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    underlay_rgba[:, :] = (18, 30, 48, 255)
    underlay_1 = [Image.fromarray(underlay_rgba, mode="RGBA")]

    def mk_static_scaled(mask: np.ndarray) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = rgb_nat[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Grille de marche suivant fidèlement la rampe côtière en S jusqu'à la faille Nord (x~284, y~212)
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    sea_margin = ndimage.binary_dilation(water_mask_nat, iterations=6)
    walk_nat = solid_nat & (~sea_margin) & (~is_stalagmite_col) & (~is_sea_cliff_wall)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    # Assure la continuité 4-connexe le long de la courbe en S mesurée sur la péninsule solide
    solid_grid = np.asarray(
        Image.fromarray((solid_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    ) >= 128
    y_start = int(round(208 * gh / H_NAT))
    for ty in range(y_start, gh):
        tn = (ty * TILE_SIZE - 216.0) / 360.0
        tn = max(0.0, min(1.0, tn))
        cx_px = 292.0 + 188.0 * math.sin(math.pi * (tn ** 0.85)) + 32.0 * tn
        cx_t = int(round(cx_px * gw / W_NAT))
        for tx in range(max(2, cx_t - 3), min(gw - 2, cx_t + 4)):
            if solid_grid[ty, tx]:
                walk_grid[ty, tx] = True

    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry(
            "00_assise_obsidienne_sous_marine",
            "Assise Sous-Marine d'Obsidienne Côtière (0 % Ciel)",
            "BG",
            _resize_frames(underlay_1, w, h),
            frame_length=5,
        ),
        LayerEntry(
            "01_recifs_et_berges_basaltiques",
            "Récifs & Berges Basaltiques de la Crique Marine",
            "BG",
            [mk_static_scaled(is_coastal_reef)],
            frame_length=5,
        ),
        LayerEntry(
            "02_crique_eau_metano_abyssale",
            "Eau Métano Abyssale de la Crique (Metano_Town_River, 4×10t)",
            "BG",
            _resize_frames(water_4, w, h),
            frame_length=10,
        ),
        LayerEntry(
            "03_sparkles_marins_metano_1x",
            "Scintillements Marins Natifs Metano Town 1× (4×10t)",
            "BG",
            _resize_frames(sparkle_4, w, h),
            frame_length=10,
        ),
        LayerEntry(
            "04_promontoire_ardoise_cotier",
            "Promontoire Côtier d'Ardoise & Terrasses Marines",
            "BG",
            [mk_static_scaled(is_promontory)],
            frame_length=5,
        ),
        LayerEntry(
            "05_escalier_cotier_en_s",
            "Escalier Côtier Naturel en S vers la Faille Ouest",
            "BG",
            [mk_static_scaled(is_s_stairway)],
            frame_length=5,
        ),
        LayerEntry(
            "06_falaise_maritime_et_faille_nord",
            "Haute Falaise Maritime sans Ciel & Entrée de la Grotte Ouest",
            "BG",
            [mk_static_scaled(is_sea_cliff_wall)],
            frame_length=5,
        ),
        LayerEntry(
            "07_orgues_stalagmites_h13p02",
            "Orgues Stalagmitiques Hexagonales façon Cryptic Cave (H13P02)",
            "BG",
            [mk_static_scaled(is_stalagmite_col)],
            frame_length=5,
        ),
        LayerEntry(
            "08_cristaux_psy_et_ressac",
            "Pulsation Bleu-Jade des Stalagmites & Ressac Télékinétique",
            "BG",
            _resize_frames(lay8_24, w, h),
            frame_length=5,
        ),
        LayerEntry(
            "09_voute_et_etoiles_h13p02_top",
            "Voûte de la Faille & Étoiles Psychiques 4 Branches H13P02 Top",
            "Top",
            _resize_frames(top9_24, w, h),
            frame_length=5,
        ),
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
        namespace_override="grotte_ouest_mwe1",
        asset_name_override="grotte_ouest_entree",
    )
    _write_halcyon_ground_script(out_dir / "package", "grotte_ouest_entree")
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
