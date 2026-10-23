#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
FGA1 — Forêt Givrée — Sanctuaire d'Artikodin (`POV PMD`, référence canonique `h24p01_articuno_sanctuary_native.png`).

Fidélité maximale à `H24P01` (*Articuno Snow Sanctuary — PMD Red*) + découpe 100 % `#FF00FF` :
- Tous les cristaux, stalagmites, piliers-flocons et le Trône de Glace demeurent **100 % statiques** ;
- Les 2 bassins & cascades glaciaires latéraux sont détourés en `#FF00FF` sur `bruts/base_foret_givree_sanctuaire.png`
  et animés par les vraies textures `1×` *PMD* (`Metano_Town_River_Animation_1..4.tile` + `Cascades_Metano_Exact`) ;
- `FGA1_00` (`BG`, `1` pose) : Ciel polaire du sanctuaire Nord ;
- `FGA1_01` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Aurore Boréale dans les arches de glace Nord ;
- `FGA1_02` (`BG`, `4` poses @ `10` ticks = `40` ticks) : Bassins d'eau glaciaire canonique PMD `1×` ;
- `FGA1_03` (`BG`, `4` poses @ `10` ticks = `40` ticks) : Cascades `1×` `Cascades_Metano_Exact` & écume de vasque ;
- `FGA1_04` (`BG`, `1` pose) : Socle continu de neige sacrée `H24P01` ;
- `FGA1_05` (`BG`, `1` pose) : Sentier enneigé à empreintes de pas Sud-Nord & Grand Médaillon Flocon d'Artikodin ;
- `FGA1_06` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Reflet spéculaire glissant sur l'anneau de glace lisse ;
- `FGA1_07` (`BG`, `1` pose) : Trône de Glace Nord, marches suspendues, totems flocons & falaises (100 % statiques) ;
- `FGA1_08` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Souffle polaire rasant la vallée de neige ;
- `FGA1_09` (`Top`, `24` poses @ `5` ticks = `120` ticks) : Chute sereine de flocons pixel-art sur le sanctuaire.
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

from moteur_eau_et_glace_canonique_pmd import (  # type: ignore
    build_canonical_pmd_water_frames,
    build_canonical_pmd_waterfall_and_shore_frames,
    build_frost_mist_and_snowfall_layers,
    build_polar_sky_and_aurora_layers,
    sanitize_palette_no_magenta,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
    extract_canonical_palette,
    quantize_rgb_to_palette,
)

MAP_ID = "FGA1"
MAP_TITLE = "Forêt Givrée — Sanctuaire d'Artikodin"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_foret_givree_sanctuaire.png"
REF_DIR = HERE / "references"
H24P01_REF = REF_DIR / "h24p01_articuno_sanctuary_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "foret_givree_sanctuaire_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_medallion_ice_sheen_frames(w: int, h: int, ring_mask: np.ndarray, n_frames: int = 24) -> List[Image.Image]:
    """Reflet spéculaire diagonal glissant uniquement sur le disque de glace plane du médaillon central
    (sans jamais toucher un seul cristal, stalagmite ou totem de glace !)."""
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    diag = (xx + 0.72 * yy) / float(w)
    c_hi = np.array([250, 253, 255], dtype=np.uint8)
    c_mid = np.array([226, 240, 254], dtype=np.uint8)
    frames: List[Image.Image] = []
    for t in range(n_frames):
        center = 0.22 + 0.96 * (float(t) / float(n_frames))
        # Repli périodique doux sur [0.22, 1.18]
        d = np.abs(((diag - center + 0.48) % 0.96) - 0.48)
        core = ring_mask & (d <= 0.018)
        halo = ring_mask & (~core) & (d <= 0.036)
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[halo, :3] = c_mid
        arr[halo, 3] = 255
        arr[core, :3] = c_hi
        arr[core, 3] = 255
        frames.append(Image.fromarray(arr, mode="RGBA"))
    return frames


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_im = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    raw_rgb = np.asarray(raw_im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    yy, xx = np.mgrid[:h, :w]
    r = raw_rgb[:, :, 0].astype(np.int16)
    g = raw_rgb[:, :, 1].astype(np.int16)
    b = raw_rgb[:, :, 2].astype(np.int16)

    # 1. Découpe stricte des zones `#FF00FF` : arches du ciel Nord vs vasques & cascades d'eau Sud-Est/Sud-Ouest
    all_magenta = (np.minimum(r, b) - g) >= 26
    sky_mask = all_magenta & (yy < int(0.18 * h))
    water_all = all_magenta & (~sky_mask)
    # Les chenaux étroits supérieurs (`y < 0.722h`) correspondent aux 2 cascades nourrissant les 2 vasques !
    cascade_mask = water_all & (yy <= int(0.725 * h))
    terrain_mask = ~all_magenta

    # 2. Palette unifiée fidèle à `H24P01` sans aucune dérive magenta (`min(R,B) - G <= 22`)
    ref_pal = extract_canonical_palette([H24P01_REF], max_colors=64, min_pixels=8)
    terr_px = raw_rgb[terrain_mask]
    uniq, cnt = np.unique(terr_px, axis=0, return_counts=True)
    top_terr = uniq[np.argsort(-cnt)[:64]]
    pal = sanitize_palette_no_magenta(np.vstack([ref_pal, top_terr]), max_gap=22)
    q_rgb = quantize_rgb_to_palette(raw_rgb, pal)

    # 3. Partition sémantique :
    #    - `walkable_arena` : allée Sud à empreintes de pas + amphithéâtre central + Médaillon Flocon d'Artikodin
    #    - `throne_cliffs`  : Trône de Glace Nord, marches suspendues, totems flocons et falaises basses (100 % statiques)
    medallion_ellipse = (((xx - 0.50 * w) / (0.21 * w)) ** 2 + ((yy - 0.485 * h) / (0.165 * h)) ** 2) <= 1.0
    snow_arena_cand = (
        terrain_mask
        & (
            medallion_ellipse
            | (
                (yy >= int(0.31 * h))
                & (xx >= int(0.24 * w))
                & (xx <= int(0.76 * w))
                & (q_rgb[:, :, 2] >= 224)
                & (q_rgb[:, :, 0] >= 205)
            )
            | ((yy >= int(0.66 * h)) & (xx >= int(0.34 * w)) & (xx <= int(0.66 * w)) & (q_rgb[:, :, 0] >= 210))
        )
        & (~ndimage.binary_dilation(water_all, iterations=max(2, int(round(3 * w / 768.0)))))
    )
    snow_arena_smooth = ndimage.binary_closing(snow_arena_cand, iterations=max(2, int(round(4 * w / 768.0)))) & terrain_mask
    lbl_a, _ = ndimage.label(snow_arena_smooth)
    south_ids = set(lbl_a[h - 6 :, int(0.38 * w) : int(0.62 * w)].ravel().tolist()) - {0}
    walkable_arena = np.isin(lbl_a, list(south_ids)) & terrain_mask
    walkable_arena = ndimage.binary_fill_holes(walkable_arena) & terrain_mask

    throne_and_cliffs = terrain_mask & (~walkable_arena)

    # Disque périphérique clair du Médaillon Flocon pour le reflet de glace (hors gravure bleue du flocon)
    ice_ring_mask = (
        medallion_ellipse
        & walkable_arena
        & (q_rgb[:, :, 0] >= 226)
        & (q_rgb[:, :, 1] >= 234)
    )

    # 4. Couches 00..09
    im_00_sky, frames_01_aurora = build_polar_sky_and_aurora_layers(
        w=w, h=h, sky_max_y_frac=0.16, n_frames=N_FRAMES
    )
    frames_02_water = build_canonical_pmd_water_frames(w=w, h=h, water_mask=water_all)
    frames_03_cascades = build_canonical_pmd_waterfall_and_shore_frames(
        w=w, h=h, water_mask=water_all, cascade_mask=cascade_mask
    )

    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[terrain_mask, :3] = np.array([232, 240, 252], dtype=np.uint8)
    base_arr[terrain_mask, 3] = 255
    im_04_base = Image.fromarray(base_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_rgb[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_05_floor_medallion = _mk_layer(walkable_arena)
    frames_06_sheen = build_medallion_ice_sheen_frames(w=w, h=h, ring_mask=ice_ring_mask, n_frames=N_FRAMES)
    im_07_throne_static = _mk_layer(throne_and_cliffs)

    mist_band = walkable_arena & (~medallion_ellipse) & (yy >= int(0.64 * h))
    frames_08_wind, frames_09_snow = build_frost_mist_and_snowfall_layers(
        w=w, h=h, mist_band_mask=mist_band, n_frames=N_FRAMES
    )

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_arena[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.55

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_ciel_sanctuaire_h24p01", "Ciel Polaire du Sanctuaire H24P01", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_aurore_boreale_artikodin", "Aurore Boréale d'Artikodin", "BG", frames_01_aurora, frame_length=5),
        LayerEntry("02_bassins_eau_pmd_canonique", "Vasques d'Eau Glaciaire Canonique PMD 1×", "BG", frames_02_water, frame_length=10),
        LayerEntry("03_cascades_eau_pmd_canonique", "Cascades Glaciaires & Écume PMD 1×", "BG", frames_03_cascades, frame_length=10),
        LayerEntry("04_socle_glacier_continu", "Socle Neigeux du Sanctuaire H24P01", "BG", [im_04_base], frame_length=5),
        LayerEntry("05_chemin_pas_et_blason_flocon", "Allée d'Empreintes & Médaillon Flocon", "BG", [im_05_floor_medallion], frame_length=5),
        LayerEntry("06_reflet_glace_medaillon", "Reflet Spéculaire du Médaillon de Glace", "BG", frames_06_sheen, frame_length=5),
        LayerEntry("07_trone_et_totems_statiques", "Trône de Glace, Piliers-Flocons & Cristaux Statiques", "BG", [im_07_throne_static], frame_length=5),
        LayerEntry("08_souffle_neigeux_vallee", "Souffle Polaire de la Vallée", "BG", frames_08_wind, frame_length=5),
        LayerEntry("09_flocons_artikodin_top", "Blizzard Canonique GBA W03P03 1×", "Top", frames_09_snow, frame_length=5),
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
        canonical_ref_for_fidelity=H24P01_REF,
        max_fidelity_distance=34.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="foret_givree_fga1",
        asset_name_override="foret_givree_sanctuaire",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
