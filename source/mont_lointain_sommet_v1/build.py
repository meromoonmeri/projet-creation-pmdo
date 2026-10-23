#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MLS1 — Mont Lointain — Sommet Arc-en-Ciel de Ho-Oh (`POV PMD`, référence `b72_mt_faraway_hooh.png`).

Fidélité maximale à `b72` (*Mt. Faraway Peak — Ho-Oh*) :
- Plateau sacré d'ivoire doré aux craquelures canoniques, piliers karstiques ocre/sauge intacts,
  fougères suspendues émeraude et pitons lointains dans la mer de nuages ;
- Grand escalier et chaussée de pierre taillée prolongés sans couture jusqu'au bord Sud (`y = 71`) ;
- Animations `MULTICALQUE` `24 × 5 = 120` ticks : dérive des rubans de nuages (`01`), Arc-en-Ciel
  pastel sacré de Ho-Oh (`02`), respiration des volutes nuageuses d'avant-plan (`08`) et plumes dorées (`09` `Top`).
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
if str(REPO_ROOT / "source") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "source"))

from moteur_mont_lointain_b72 import (  # type: ignore
    B72_PLATEAU_IVORY,
    B72_STONE_BASE,
    B72_STONE_OUTLINE,
    build_b72_sky_and_cloud_sea_layers,
    build_b72_unified_palette,
    build_hooh_mist_and_feathers_layers,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
    quantize_rgb_to_palette,
)

MAP_ID = "MLS1"
MAP_TITLE = "Mont Lointain — Sommet de Ho-Oh"
RAW_DIR = HERE / "bruts"
DECOR_RAW = RAW_DIR / "decor_sommet_hooh_ref_widescreen.png"
REF_DIR = HERE / "references"
B72_REF = REF_DIR / "b72_mt_faraway_hooh.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_lointain_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    im = Image.open(DECOR_RAW).convert("RGB")
    raw_rgb = np.asarray(im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()
    raw_rgb[raw_rgb.max(axis=2) < 105] = B72_STONE_OUTLINE

    pal = build_b72_unified_palette(B72_REF)
    q_rgb = quantize_rgb_to_palette(raw_rgb, pal)

    yy, xx = np.mgrid[:h, :w]
    r = q_rgb[:, :, 0].astype(np.int16)
    g = q_rgb[:, :, 1].astype(np.int16)
    b = q_rgb[:, :, 2].astype(np.int16)

    # 1. Ciel cyan (`b > r + 40`) & mer de nuages de fond (`r >= 244 & g >= 238 & b >= 165` hors plateau central)
    plateau_box = (yy >= int(0.24 * h)) & (yy <= int(0.68 * h)) & (xx >= int(0.30 * w)) & (xx <= int(0.70 * w))
    stair_box = (yy >= int(0.64 * h)) & (xx >= int(0.425 * w)) & (xx <= int(0.555 * w))
    is_sky = (b - r) >= 35
    # Nuages dorés d'avant-plan dans les coins Sud-Ouest et Sud-Est (`Couche 08` animée)
    fg_cumulus = (
        (yy >= int(0.73 * h))
        & (~stair_box)
        & (r >= 225)
        & (g >= 190)
        & (g <= 246)
        & (b <= 170)
    )
    bg_cloud_sea = (~plateau_box) & (~stair_box) & (~fg_cumulus) & (~is_sky) & (r >= 242) & (g >= 236)

    # Tout le relief rocheux solide = tout ce qui n'est ni ciel, ni mer de nuages de fond, ni cumulus avant-plan
    solid_relief = (~is_sky) & (~bg_cloud_sea) & (~fg_cumulus)

    # Pitons karstiques lointains dans la mer de nuages (Nord + ailes Est/Ouest)
    far_spires = solid_relief & (
        (yy < int(0.185 * h)) | (xx < int(0.16 * w)) | (xx > int(0.84 * w))
    )
    main_summit = solid_relief & (~far_spires)

    ferns = main_summit & (g >= r + 8) & (g >= b + 28)

    # Plateau sacré d'ivoire de Ho-Oh + grand escalier/chaussée Sud (`y = h - 1` -> `y ≈ 0.26h`)
    plateau_surface = main_summit & plateau_box & (~ferns) & (r >= 220) & (g >= 220)
    #Inclure les fines craquelures du plateau (`binary_fill_holes`) pour que tout le plateau soit praticable !
    plateau_walk = ndimage.binary_fill_holes(
        ndimage.binary_closing(plateau_surface, iterations=max(2, int(round(4 * w / 768.0))))
    ) & main_summit
    stair_walk = main_summit & (yy >= int(0.62 * h)) & (xx >= int(0.435 * w)) & (xx <= int(0.542 * w)) & (~ferns)
    walkable_surface = plateau_walk | stair_walk

    karst_pillars = main_summit & (~walkable_surface) & (~ferns)

    # Socle continu sous tout `main_summit`
    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[main_summit, :3] = B72_STONE_BASE
    base_arr[walkable_surface, :3] = B72_PLATEAU_IVORY
    base_arr[main_summit, 3] = 255
    im_04_base = Image.fromarray(base_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[m, :3] = q_rgb[m]
        arr[m, 3] = 255
        return Image.fromarray(arr, mode="RGBA")

    im_00_sky, frames_01_clouds, frames_02_rainbow = build_b72_sky_and_cloud_sea_layers(
        w, h, n_frames=N_FRAMES, horizon_frac=0.162
    )
    im_03_far = _mk_layer(far_spires)
    im_05_pillars = _mk_layer(karst_pillars)
    im_06_plateau = _mk_layer(walkable_surface)
    im_07_ferns = _mk_layer(ferns)
    frames_08_mist, frames_09_feathers = build_hooh_mist_and_feathers_layers(q_rgb, fg_cumulus, n_frames=N_FRAMES)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_surface[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.60

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_ciel_azur_et_mer_nuages_b72", "Ciel Azur b72 & Mer de Nuages", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_rubans_nuages_altitude_derive", "Rubans de Nuages Dorés en Dérive", "BG", frames_01_clouds, frame_length=5),
        LayerEntry("02_arc_en_ciel_sacre_hooh", "Arc-en-Ciel Sacré de Ho-Oh", "BG", frames_02_rainbow, frame_length=5),
        LayerEntry("03_pitons_karstiques_lointains", "Pitons Karstiques Lointains", "BG", [im_03_far], frame_length=5),
        LayerEntry("04_socle_rocheux_continu", "Socle du Sommet Sacré Continu", "BG", [im_04_base], frame_length=5),
        LayerEntry("05_piliers_karstiques_ocre_sauge", "Piliers Karstiques Ocre & Sauge", "BG", [im_05_pillars], frame_length=5),
        LayerEntry("06_plateau_sacre_hooh_et_escalier", "Plateau d'Ivoire de Ho-Oh & Escalier Sud", "BG", [im_06_plateau], frame_length=5),
        LayerEntry("07_fougeres_emeraude_parois", "Fougères Émeraude du Sommet", "BG", [im_07_ferns], frame_length=5),
        LayerEntry("08_nuages_dores_avant_plan", "Cumulus Dorés d'Avant-Plan", "BG", frames_08_mist, frame_length=5),
        LayerEntry("09_plumes_dorees_hooh_top", "Plumes & Lueurs Sacrées de Ho-Oh", "Top", frames_09_feathers, frame_length=5),
    ]
    return layers, walk_grid, pal


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    h = max(64, int(round(H_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    layers, walk_grid, _ = build_layers_for_size(w, h)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=B72_REF,
        namespace_override="mont_lointain_mls1",
        asset_name_override="mont_lointain_sommet",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
