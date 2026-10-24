#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — RSE1 : Montagne Solaire & Clairière — Rivière Metano (Reshiram).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks) :
  - Partie Sud/médiane : Clairière lumineuse `1×` style *Tiny Woods / Sky Peak Prairie* & *Metano Town*,
    sentier sablonneux Sud -> Nord, vrai pont en rondins de bois de *Metano Town*, arbres feuillus ronds
    (troncs au sol + canopée en surplomb `Top`), fleurs animées dans la brise et rivière turquoise animée
    sur 4 phases natives de *Metano Town* + reflets `Sparkles` + 2 cascades à rondins 4 phases.
  - Partie Nord : Montagne naturelle de grès solaire `1×` (`D07P11A`) percée d'une grotte centrale au
    sommet des marches rocheuses, dominée par un ciel d'aurore de Flamme Blanche & braises GBA `W04`.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image

SOURCE_DIR = Path(__file__).resolve().parent.parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_cyclones_cylindriques_unova import (
    H as H_NAT,
    W as W_NAT,
    build_metano_river_and_skypeak_layers,
    build_mountain_horizon_sky_layers,
    sanitize_rgba_binary,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "RSE1"
MAP_TITLE = "Montagne Solaire & Clairière — Rivière Metano (Reshiram)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_reshiram_montagne_entree.png"
CANOPY_PATH = HERE / "bruts" / "canopee_arbres_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_reshiram_montagne_entree.png"
RENDERS_DIR = REPO_ROOT / "renders" / "reshiram_montagne_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"

CASCADE_ORIGINS = [(148, 70), (586, 70)]
FLOWER_SITES: list[tuple[int, int, str, int]] = []


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    canopy_nat = np.asarray(Image.open(CANOPY_PATH).convert("RGBA"), dtype=np.uint8)

    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]
    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    sky_mask_nat = mag_nat & (yy_n < 62)
    water_mask_nat = mag_nat & (~sky_mask_nat)
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    bridge_box = (xx_n >= 344) & (xx_n <= 424) & (yy_n >= 176) & (yy_n <= 274) & solid_nat
    water_full_nat = water_mask_nat | (
        (xx_n >= 344) & (xx_n <= 424) & (yy_n >= 198) & (yy_n <= 258)
    )

    gen_flower_mask = (
        solid_nat
        & (yy_n >= 268)
        & (np.abs(xx_n - 384) > 48)
        & (xx_n >= 150)
        & (xx_n <= 624)
        & (r_c >= 195)
        & ((r_c > g_c + 18) | ((g_c >= 188) & (b_c >= 135)) | ((g_c >= 178) & (b_c <= 112)))
    )
    gen_flower_rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    gen_flower_rgba[gen_flower_mask, :3] = rgb_nat[gen_flower_mask]
    gen_flower_rgba[gen_flower_mask, 3] = 255

    sky_24, plume_24, ridge_embers_24 = build_mountain_horizon_sky_layers(
        mode="reshiram_white_flame",
        sky_mask=sky_mask_nat,
    )
    river_24, sparkle_24, flower_24 = build_metano_river_and_skypeak_layers(
        water_mask=water_full_nat,
        cascade_origins=CASCADE_ORIGINS,
        flower_sites=FLOWER_SITES,
        bridge_mask=bridge_box,
        generated_flower_rgba=gen_flower_rgba,
    )

    is_mountain = solid_nat & (yy_n < 176) & ((g_c - r_c) <= 12) & (~bridge_box) & (
        ~((np.abs(xx_n - 384) <= 36) & (yy_n >= 142) & (r_c >= 195) & (g_c >= 155))
    )
    is_path_bridge = solid_nat & (~is_mountain) & (
        bridge_box | ((np.abs(xx_n - 384) <= 38) & (yy_n >= 140) & ((r_c - b_c) >= 42) & (r_c >= 175))
    )
    is_forest_props = solid_nat & (~is_mountain) & (~is_path_bridge) & (~gen_flower_mask) & (
        (canopy_nat[:, :, 3] > 0)
        | ((g_c < 172) & (yy_n >= 210) & ((xx_n < 188) | (xx_n > 580) | (yy_n >= 488)))
        | ((r_c > 155) & (g_c < 165) & (b_c < 120) & (yy_n >= 270) & (np.abs(xx_n - 384) > 52))
    )
    is_meadow_banks = solid_nat & (~is_mountain) & (~is_path_bridge) & (~is_forest_props)

    rgb_meadow = rgb_nat.copy()
    rgb_meadow[gen_flower_mask] = (152, 224, 66)

    def mk_static_scaled(mask: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = src_rgb[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    top_24: List[Image.Image] = []
    canopy_img = Image.fromarray(sanitize_rgba_binary(canopy_nat), mode="RGBA")
    for em_im in ridge_embers_24:
        comp = canopy_img.copy()
        comp.alpha_composite(em_im)
        top_24.append(comp)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    scale_x, scale_y = W_NAT / float(w), H_NAT / float(h)
    walk_grid = np.zeros((gh, gw), dtype=bool)
    walkable_px = (is_meadow_banks | is_path_bridge) & (~mag_nat) & (~is_forest_props)
    for ty in range(gh):
        y0_n = int(round(ty * TILE_SIZE * scale_y))
        y1_n = max(y0_n + 1, int(round((ty + 1) * TILE_SIZE * scale_y)))
        for tx in range(gw):
            x0_n = int(round(tx * TILE_SIZE * scale_x))
            x1_n = max(x0_n + 1, int(round((tx + 1) * TILE_SIZE * scale_x)))
            sub_w = walkable_px[y0_n:y1_n, x0_n:x1_n]
            sub_m = mag_nat[y0_n:y1_n, x0_n:x1_n]
            if float(sub_w.mean()) >= 0.65 and float(sub_m.mean()) == 0.0:
                walk_grid[ty, tx] = True

    cx_t = gw // 2
    cave_top_t = max(2, int(round(0.20 * gh)))
    for ty in range(cave_top_t, gh):
        walk_grid[ty, max(0, cx_t - 2) : min(gw, cx_t + 2)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_ciel_aurore_flamme_blanche", "Ciel d'Aurore Ardente au-dessus de la Montagne", "BG", _resize_frames(sky_24, w, h), frame_length=5),
        LayerEntry("01_volutes_flamme_croix_horizon", "Rubans de Flamme Blanche & Flamme Bleue sur l'Horizon", "BG", _resize_frames(plume_24, w, h), frame_length=5),
        LayerEntry("02_riviere_et_cascades_metano_4phases", "Rivière & Cascades Metano Town 1× (4 Phases)", "BG", _resize_frames(river_24, w, h), frame_length=5),
        LayerEntry("03_sparkles_et_ecume_riviere_metano", "Reflets Sparkles & Écume Metano Town 1×", "BG", _resize_frames(sparkle_24, w, h), frame_length=5),
        LayerEntry("04_clairiere_skypeak_et_berges_metano", "Clairière Sky Peak Prairie & Berges Naturelles", "BG", [mk_static_scaled(is_meadow_banks, rgb_meadow)], frame_length=5),
        LayerEntry("05_sentier_et_pont_bois_metano", "Sentier Sablonneux & Pont en Rondins Metano 1×", "BG", [mk_static_scaled(is_path_bridge)], frame_length=5),
        LayerEntry("06_paroi_montagne_solaire_et_grotte", "Montagne Solaire D07P11A 1× & Grotte Centrale", "BG", [mk_static_scaled(is_mountain)], frame_length=5),
        LayerEntry("07_arbres_tiny_woods_buissons_rochers", "Arbres Ronds Tiny Woods, Buissons & Rochers 1×", "BG", [mk_static_scaled(is_forest_props)], frame_length=5),
        LayerEntry("08_fleurs_skypeak_metano_brise", "Fleurs Sky Peak Prairie & Metano dans la Brise", "BG", _resize_frames(flower_24, w, h), frame_length=5),
        LayerEntry("09_canopee_tiny_woods_et_braises_w04_top", "Canopée Tiny Woods & Braises GBA W04 Top", "Top", _resize_frames(top_24, w, h), frame_length=5),
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
        namespace_override="reshiram_montagne_rse1",
        asset_name_override="reshiram_montagne_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
