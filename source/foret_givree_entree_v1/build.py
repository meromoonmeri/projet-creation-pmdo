#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
FGE1 — Forêt Givrée — Entrée (`1×` natif Chunsoft GBA `D10P01` + Neige `W03P03`).

Fidélité texture & pixel-art `100 %` native à `D10P01` (*Frosty Forest Entrance — PMD Red*) :
- Décodage matériel direct `D10P01.{bpl,bpc,bma}` (`0` rivière bleue inventée, `0` aurore verte, `0` lissage) ;
- Découpe `#FF00FF` pure sur `bruts/base_foret_givree_entree.png` pour le ciel d'hiver & les plaques de glace vive ;
- Neige tombante matérielle authentique GBA `W03P03` (`W03P031.bpa`, `16` poses matérielles).
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

from moteur_gba_pmd_red_natif import (  # type: ignore
    PURE_MAGENTA,
    build_gba_weather_overlay_frames,
    load_gba_map_bundle,
    make_layer_rgba,
    render_gba_native,
    resize_nearest_mask,
    resize_nearest_rgba,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "FGE1"
MAP_TITLE = "Forêt Givrée — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_foret_givree_entree.png"
REF_DIR = HERE / "references"
D10P01_REF = REF_DIR / "d10p01_frosty_forest_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "foret_givree_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    nat_rgba, nat_pm, _ = render_gba_native("D10P01", phase=None, bpa_frame=0)
    nh, nw, _ = nat_rgba.shape
    nyy, nxx = np.mgrid[:nh, :nw]
    nr = nat_rgba[:, :, 0].astype(np.int16)
    ng = nat_rgba[:, :, 1].astype(np.int16)
    nb = nat_rgba[:, :, 2].astype(np.int16)

    # 1. Ciel d'hiver `D10P01` connecté au bord Nord (`0` coupe dans les sapins enneigés !)
    sky_seed_candidates = (nyy < 145) & (nb >= 236) & (nb - nr >= 36) & (nr <= 212)
    lbl_sky, _ = ndimage.label(sky_seed_candidates)
    top_ids = set(lbl_sky[0, :].tolist()) - {0}
    nat_sky = np.isin(lbl_sky, list(top_ids))

    # 2. Plaques de glace vive & dalles gelées du sentier `D10P01` (`#FF00FF` dans le brut, `0` rivière bleue factice !)
    nat_ice_patches = (~nat_sky) & (nyy >= 168) & (nb - nr >= 16) & (nr <= 176)

    # 3. Souche givrée emblématique de `D10P01` (isolée nativement dans `pal_map == 1` par Chunsoft !)
    nat_stump = (nat_pm == 1) & (~nat_sky) & (~nat_ice_patches)

    full_rgba = resize_nearest_rgba(nat_rgba, w, h)
    rgb = full_rgba[:, :, :3]
    sky_mask = resize_nearest_mask(nat_sky, w, h)
    ice_mask = resize_nearest_mask(nat_ice_patches, w, h) & (~sky_mask)
    stump_mask = resize_nearest_mask(nat_stump, w, h) & (~sky_mask) & (~ice_mask)

    # Sauvegarde du brut `#FF00FF` canonique à résolution nominale
    if w == W_CANON and h == H_CANON:
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        brut = rgb.copy()
        brut[sky_mask | ice_mask] = PURE_MAGENTA
        Image.fromarray(brut, mode="RGB").save(DECOR_MAGENTA_RAW)

    terrain_mask = ~(sky_mask | ice_mask)
    yy, xx = np.mgrid[:h, :w]

    # Palette exacte `D10P01.bpl` (couleurs matérielles Chunsoft exclusivement)
    b_d10 = load_gba_map_bundle("D10P01")
    pal = np.unique(b_d10["base_pals"][:, 1:, :3].reshape(-1, 3), axis=0).astype(np.uint8)

    # Partition sémantique `1×` Chunsoft des sapins, congères et sentier enneigé
    path_corridor = (
        ((yy >= int(0.46 * h)) & (xx >= int(0.30 * w)) & (xx <= int(0.68 * w)))
        | ((yy >= int(0.72 * h)) & (xx >= int(0.24 * w)) & (xx <= int(0.76 * w)))
    )
    walkable_pixels = (sky_mask == False) & (~stump_mask) & path_corridor & (yy >= int(0.45 * h))
    snow_path_static = terrain_mask & (~stump_mask) & path_corridor & (yy >= int(0.50 * h))
    rear_pines = terrain_mask & (~snow_path_static) & (~stump_mask) & (yy < int(0.44 * h))
    lateral_drifts = (
        terrain_mask & (~snow_path_static) & (~rear_pines) & (~stump_mask) & (yy >= int(0.62 * h))
    )
    fg_pines_and_stump = (
        terrain_mask & (~snow_path_static) & (~rear_pines) & (~lateral_drifts)
    ) | stump_mask

    # Couche 00 : Ciel d'hiver exact `D10P01`
    im_00_sky = make_layer_rgba(rgb, np.ones((h, w), dtype=bool))

    # Couche 01 : Nuées polaires d'horizon dérivant le long du relief `D10P01` (`12 × 10 = 120` ticks, `pose0` = repos exact)
    sky_horizon_edge = ndimage.binary_dilation(~sky_mask, iterations=max(4, h // 48)) & sky_mask
    frames_01_mist: List[Image.Image] = []
    for f in range(12):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if f > 0:
            sh = int(round(np.sin(2.0 * np.pi * f / 12.0) * max(6.0, w * 0.04)))
            rolled_edge = np.roll(sky_horizon_edge, shift=sh, axis=1) & sky_mask
            arr[rolled_edge, :3] = np.array([196, 208, 248], dtype=np.uint8)
            arr[rolled_edge, 3] = 255
        frames_01_mist.append(Image.fromarray(arr, mode="RGBA"))

    # Couche 02 : Dalles & plaques de glace vive `#FF00FF` (`12 × 10 = 120` ticks, préserve 100 % du grain `D10P01` !)
    frames_02_ice: List[Image.Image] = []
    for f in range(12):
        arr = make_layer_rgba(rgb, ice_mask)
        a = np.asarray(arr, dtype=np.uint8).copy()
        if f > 0:
            # Modulation douce strictement additive sur la texture native `D10P01` (zéro bande géométrique !)
            pulse = 0.5 - 0.5 * np.cos(2.0 * np.pi * f / 12.0)
            delta = int(round(18.0 * pulse))
            glint = ice_mask & (rgb[:, :, 2] >= 152)
            a[glint, :3] = np.clip(rgb[glint].astype(np.int32) + delta, 0, 248).astype(np.uint8)
        frames_02_ice.append(Image.fromarray(a, mode="RGBA"))

    # Couche 03 : Scintillements cristallins sur les crêtes de neige (`15 × 8 = 120` ticks, `pose0` vide)
    ice_edge = ndimage.binary_dilation(ice_mask, iterations=1) & terrain_mask
    frames_03_glints: List[Image.Image] = []
    for f in range(15):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if f > 0:
            tw = ice_edge & ((((xx // 4) * 13 + (yy // 4) * 7 + f * 3) % 11) == 0)
            arr[tw, :3] = np.array([248, 248, 248], dtype=np.uint8)
            arr[tw, 3] = 255
        frames_03_glints.append(Image.fromarray(arr, mode="RGBA"))

    im_04_path = make_layer_rgba(rgb, snow_path_static)
    im_05_rear = make_layer_rgba(rgb, rear_pines)
    im_06_drifts = make_layer_rgba(rgb, lateral_drifts)
    im_07_fg = make_layer_rgba(rgb, fg_pines_and_stump)

    # Couches 08 & 09 : Chute de neige authentique GBA `W03P03` (`W03P031.bpa`, `pose0` sobre, `100 %` binaire)
    snow_bg_raw = build_gba_weather_overlay_frames(
        "W03P03",
        w=w,
        h=h,
        n_frames=12,
        scroll_dx_per_loop=-24,
        scroll_dy_per_loop=48,
        tint_palette=[(216, 224, 248), (240, 244, 252)],
        subsample_keep_mod=5,
    )
    snow_top_raw = build_gba_weather_overlay_frames(
        "W03P03",
        w=w,
        h=h,
        n_frames=15,
        scroll_dx_per_loop=-32,
        scroll_dy_per_loop=72,
        tint_palette=[(232, 240, 252), (248, 248, 252)],
        subsample_keep_mod=6,
    )

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_pixels[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.55

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_ciel_hivernal_d10p01", "Ciel Hivernal Natif D10P01 1×", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_brume_polaire_horizon_d10p01", "Brume Polaire d'Horizon D10P01", "BG", frames_01_mist, frame_length=10),
        LayerEntry("02_plaques_glace_vive_d10p01", "Dalles & Plaques de Glace Vive D10P01", "BG", frames_02_ice, frame_length=10),
        LayerEntry("03_scintillements_cristaux_givre", "Scintillements Cristallins de Givre", "BG", frames_03_glints, frame_length=8),
        LayerEntry("04_sentier_enneige_continu_d10p01", "Sentier Enneigé Praticable Sud-Nord D10P01", "BG", [im_04_path], frame_length=5),
        LayerEntry("05_sapins_arriere_plan_d10p01", "Sapins Enneigés d'Arrière-Plan D10P01", "BG", [im_05_rear], frame_length=5),
        LayerEntry("06_congeres_neige_laterales_d10p01", "Congères Latérales de Neige D10P01", "BG", [im_06_drifts], frame_length=5),
        LayerEntry("07_sapins_avant_et_souche_d10p01", "Sapins d'Avant-Plan & Souche Givrée D10P01", "BG", [im_07_fg], frame_length=5),
        LayerEntry("08_poudreuse_arriere_w03p03", "Poudreuse Lointaine GBA W03P03 1×", "BG", snow_bg_raw, frame_length=10),
        LayerEntry("09_flocons_neige_w03p03_top", "Chute de Neige Canonique GBA W03P03 1×", "Top", snow_top_raw, frame_length=8),
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
        canonical_ref_for_fidelity=D10P01_REF,
        max_fidelity_distance=6.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="foret_givree_fge1",
        asset_name_override="foret_givree_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
