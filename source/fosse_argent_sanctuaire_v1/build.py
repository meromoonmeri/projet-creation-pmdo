#!/usr/bin/env python3
"""Constructeur PMDO `0.8.12.0` — `FAS1` (*Caverne des Tourb'Îles — Arène de Lugia façon Pokémon SoulSilver*).

Architecture `768 × 576` (`96 × 72` tuiles `8×8`), `10` calques (`9 BG` + `1 Top`), `0 px` de ciel :
  - **Arène centrale 100 % simple et nue (`0` objet, `0` colonne, `0` cristal, `0` décor)** en pierre
    humide sombre façon *Pokémon SoulSilver* (*Tourb'Îles / Whirl Islands*), reliée au Sud par un
    chemin droit Sud→Nord à marches de pierre ;
  - **Eau Metano Town sombre autour de l'arène et du chemin** (`Metano_Town_River_Animation_1..4.tile`
    + `Metano_Town_River_Sparkles.tile`, `4 poses × 10 ticks` assombries selon la courbe nocturne Metano) ;
  - **9 cascades authentiques de *Foggy Forest* (`P03P01A` — *Plateau Sylvestre / Forêt Brumeuse*,
    *PMD Explorers of Sky*, `3 poses BPA × 10 ticks` à l'échelle `1×` native)** entourant l'arrière de
    l'arène avec leurs vasques d'écume bouillonnantes et rides concentriques ;
  - **2 tornades d'eau 3D géantes hors-cadre sur CHAQUE côté du chemin Sud→Nord** (`2` à Gauche + `2` à Droite,
    `y = 0 .. h-1` sans extrémité haute ni basse visible, exactement comme *Sky Tower Entrance* `TCE1`,
    `8 poses @ 5 ticks` à symétrie hélicoïdale d'ordre 3, `< 24 000` tuiles `8×8` par banque).
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[2]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from source.moteur_forets_pmd_red import _downsample_non_mixing
from source.moteur_fosse_argent_lugia import (
    H_CANON,
    TILE_SIZE,
    W_CANON,
    build_colossal_sky_tower_water_tornado_layers,
    build_dark_metano_town_water_layers,
    build_foggy_forest_waterfalls_frames,
    clean_magenta_cutout_strict,
    quantize_foreground_96_abyssal,
    segment_soulsilver_cavern_clean,
)
from source.moteur_gba_pmd_red_natif import make_layer_rgba, render_gba_native
from source.tour_celeste_moteur_nuages import LayerEntry, build_rsground_package

HERE = Path(__file__).resolve().parent
RAW_DIR = HERE / "bruts"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "fosse_argent_sanctuaire_v1"

DECOR_MAGENTA_RAW = RAW_DIR / "decor_sanctuaire_lugia_fosse_argent_magenta.png"
CANONICAL_REF = REF_DIR / "FAS1_canonical_lugia_sanctuary.png"
H02P02_REF = REF_DIR / "H02P02_deep_sea_current_pmd_red.png"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / "FAS1_PMDO_0.8.12.zip"

MAP_ID = "FAS1"
MAP_TITLE = "Tourb'Îles — Arène de Lugia (SoulSilver)"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    REF_DIR.mkdir(parents=True, exist_ok=True)
    if not H02P02_REF.is_file():
        h02_rgba, _, _ = render_gba_native("H02P02", phase=None, bpa_frame=0)
        Image.fromarray(h02_rgba[:, :, :3], mode="RGB").save(H02P02_REF)

    raw_src = np.asarray(Image.open(DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)
    clean_src, fg_src = clean_magenta_cutout_strict(raw_src)
    fg_rgb_ds, fg_mask_ds = _downsample_non_mixing(clean_src, fg_src, out_w=w, out_h=h)
    fg_rgb_q = quantize_foreground_96_abyssal(fg_rgb_ds, fg_mask_ds)

    fg_rgb, cliff_mask, arena_mask, south_path_mask = segment_soulsilver_cavern_clean(
        fg_rgb_q, fg_mask_ds
    )
    fg_all = cliff_mask | arena_mask | south_path_mask
    water_mask = ~fg_all

    # Calques 00, 01, 02 : Eau Metano Town sombre authentique autour de l'arène & du chemin Sud→Nord (4 poses @ 10 ticks)
    im_00_metano_dark_base, frames_01_metano_waves, frames_02_metano_sparkles = build_dark_metano_town_water_layers(
        w, h, water_mask, seed=24915
    )

    # Calque 04 : Les 9 cascades authentiques de Foggy Forest (`P03P01A`, PMD Explorers of Sky, 3 poses BPA @ 10 ticks)
    # (Creuse également les bouches de caverne sombres dans `fg_rgb` juste avant la création de `im_03_back_cliff` !)
    frames_04_foggy_waterfalls = build_foggy_forest_waterfalls_frames(
        w, h, cliff_mask, arena_mask, fg_rgb
    )

    # Calques 03, 05, 06 : Architecture rocheuse SoulSilver 100 % statique et épurée (`0` objet sur l'arène !)
    im_03_back_cliff = make_layer_rgba(fg_rgb, cliff_mask)
    im_05_south_path = make_layer_rgba(fg_rgb, south_path_mask)
    im_06_simple_arena = make_layer_rgba(fg_rgb, arena_mask)

    # Calques 07, 08, 09 : 2 tornades d'eau géantes hors-cadre sur CHAQUE côté du chemin Sud→Nord (façon Sky Tower Entrance TCE1)
    frames_07_outer_tornadoes, frames_08_inner_tornadoes, frames_09_top_whips = build_colossal_sky_tower_water_tornado_layers(
        w, h, arena_mask, n_frames=8
    )

    # Met à jour la référence canonique `768 × 576` de la pose 0 dans l'ordre exact des 10 calques
    if w == W_CANON and h == H_CANON:
        comp0 = Image.new("RGBA", (w, h), (0, 0, 0, 255))
        for im_l in (
            im_00_metano_dark_base,
            frames_01_metano_waves[0],
            frames_02_metano_sparkles[0],
            im_03_back_cliff,
            frames_04_foggy_waterfalls[0],
            im_05_south_path,
            im_06_simple_arena,
            frames_07_outer_tornadoes[0],
            frames_08_inner_tornadoes[0],
            frames_09_top_whips[0],
        ):
            comp0 = Image.alpha_composite(comp0, im_l)
        comp0.convert("RGB").save(CANONICAL_REF)

    # Grille de marche : Chemin Sud→Nord continu + TOUTE la dalle plate de l'arène ovale simple (`0` obstacle interne !)
    yy, xx = np.mgrid[:h, :w]
    lum = (
        0.25 * fg_rgb[:, :, 0].astype(np.float32)
        + 0.50 * fg_rgb[:, :, 1].astype(np.float32)
        + 0.25 * fg_rgb[:, :, 2].astype(np.float32)
    )
    arena_top_flat = ndimage.binary_erosion(arena_mask & (lum >= 56.0), iterations=max(1, w // 384))
    path_walk_px = south_path_mask & (xx >= int(round(0.458 * w))) & (xx <= int(round(0.542 * w)))
    stair_bridge_px = (
        (arena_mask | south_path_mask)
        & (xx >= int(round(0.458 * w)))
        & (xx <= int(round(0.542 * w)))
        & (yy >= int(round(0.55 * h)))
    )

    walkable_px = arena_top_flat | path_walk_px | stair_bridge_px

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_px[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.45

    walk_grid = ndimage.binary_fill_holes(walk_grid)
    walk_grid[int(0.62 * gh) : gh, int(0.465 * gw) : int(0.535 * gw)] = True

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    pal = np.unique(fg_rgb[fg_all].reshape(-1, 3), axis=0).astype(np.uint8)

    layers = [
        LayerEntry("00_eau_metano_sombre_fond", "Eau Metano Town Sombre — Nappe Profonde", "BG", [im_00_metano_dark_base], frame_length=5),
        LayerEntry("01_eau_metano_sombre_ondes_4phases", "Eau Metano Town Sombre — Ondes 4 Phases", "BG", frames_01_metano_waves, frame_length=10),
        LayerEntry("02_reflets_metano_sombre_sparkles", "Reflets & Éclats Metano Town Sombre (4×10t)", "BG", frames_02_metano_sparkles, frame_length=10),
        LayerEntry("03_paroi_rocheuse_amphitheatre_caverne", "Falaise Caverneuse Semi-Circulaire SoulSilver", "BG", [im_03_back_cliff], frame_length=5),
        LayerEntry("04_cascades_foggy_forest_p03p01a", "9 Cascades Foggy Forest (P03P01A PMD Sky)", "BG", frames_04_foggy_waterfalls, frame_length=10),
        LayerEntry("05_chemin_pierre_sud_vers_nord", "Chemin & Marches de Pierre Sud → Nord", "BG", [im_05_south_path], frame_length=5),
        LayerEntry("06_arene_simple_nue_lugia", "Arène Ovale Simple & Nue de Lugia (0 Objet)", "BG", [im_06_simple_arena], frame_length=5),
        LayerEntry("07_tornades_eau_geantes_exterieures_3d", "Tornades d'Eau Géantes Hors-Cadre Externes (TCE1)", "BG", frames_07_outer_tornadoes, frame_length=5),
        LayerEntry("08_tornades_eau_geantes_interieures_3d", "Tornades d'Eau Géantes Hors-Cadre Internes (TCE1)", "BG", frames_08_inner_tornadoes, frame_length=5),
        LayerEntry("09_crochets_ecume_et_embruns_top", "Crochets d'Écume 3D & Embruns Cycloniques Top", "Top", frames_09_top_whips, frame_length=5),
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
        canonical_ref_for_fidelity=CANONICAL_REF if CANONICAL_REF.is_file() else H02P02_REF,
        max_fidelity_distance=6.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="fosse_argent_fas1",
        asset_name_override="fosse_argent_sanctuaire_lugia",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
