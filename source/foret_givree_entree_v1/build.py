#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
FGE1 — Forêt Givrée — Entrée (`POV PMD`, référence canonique `d10p01_frosty_forest_native.png`).

Fidélité maximale à `D10P01` (*Frosty Forest Entrance — PMD Red*) + découpe 100 % `#FF00FF` :
- `FGE1_00` (`BG`, `1` pose) : Ciel polaire étagé `D10P01` derrière la chaîne enneigée ;
- `FGE1_01` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Rideaux d'Aurore Boréale turquoise-émeraude ;
- `FGE1_02` (`BG`, `4` poses @ `10` ticks = `40` ticks, `3×` par boucle `120`) : Eau glaciaire vive `1×`
  native *PMD* (`Metano_Town_River_Animation_1..4.tile`) remplissant les 2 ruisseaux `#FF00FF` ;
- `FGE1_03` (`BG`, `4` poses @ `10` ticks) : Écume de berge glacée & éclats spéculaires `1×` ;
- `FGE1_04` (`BG`, `1` pose) : Socle continu de neige & roche froide ;
- `FGE1_05` (`BG`, `1` pose) : Chaîne de montagnes enneigées lointaines `D10P01` ;
- `FGE1_06` (`BG`, `1` pose) : Sentier enneigé praticable continu du Sud (`y = 71`) au seuil Nord ;
- `FGE1_07` (`BG`, `1` pose) : Sapins enneigés étagés & souche givrée emblématique de `D10P01` ;
- `FGE1_08` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Nappes de brume glacée dérivant au seuil Nord ;
- `FGE1_09` (`Top`, `24` poses @ `5` ticks = `120` ticks) : Chutes de flocons parallaxe sur toute la forêt.
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

MAP_ID = "FGE1"
MAP_TITLE = "Forêt Givrée — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_foret_givree_entree.png"
REF_DIR = HERE / "references"
D10P01_REF = REF_DIR / "d10p01_frosty_forest_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "foret_givree_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_im = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    raw_rgb = np.asarray(raw_im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    yy, xx = np.mgrid[:h, :w]
    r = raw_rgb[:, :, 0].astype(np.int16)
    g = raw_rgb[:, :, 1].astype(np.int16)
    b = raw_rgb[:, :, 2].astype(np.int16)

    # 1. Découpe stricte des zones `#FF00FF` : ciel polaire Nord vs ruisseaux d'eau glaciaire Sud
    all_magenta = (np.minimum(r, b) - g) >= 26
    sky_mask = all_magenta & (yy < int(0.34 * h))
    water_mask = all_magenta & (~sky_mask)
    terrain_mask = ~all_magenta

    # 2. Palette canonique `D10P01` enrichie des nuances pierre/sapin du décor (sans aucune teinte magenta)
    ref_pal = extract_canonical_palette([D10P01_REF], max_colors=64, min_pixels=8)
    terr_px = raw_rgb[terrain_mask]
    uniq, cnt = np.unique(terr_px, axis=0, return_counts=True)
    top_terr = uniq[np.argsort(-cnt)[:64]]
    pal = sanitize_palette_no_magenta(np.vstack([ref_pal, top_terr]), max_gap=22)
    q_rgb = quantize_rgb_to_palette(raw_rgb, pal)

    # 3. Partition sémantique du relief enneigé :
    #    - `mountains_mask` : chaîne enneigée d'arrière-plan (`y < 0.27h` hors pointes de sapins proches),
    #    - `walkable_path`  : allée centrale praticable du bord Sud (`y = h - 1`) jusqu'au seuil Nord (`y ≈ 0.44h`),
    #    - `forest_pines`   : sapins enneigés, souche givrée et berges sculptées.
    path_corridor = (
        terrain_mask
        & (yy >= int(0.43 * h))
        & (xx >= int(0.24 * w))
        & (xx <= int(0.76 * w))
        & (~ndimage.binary_dilation(water_mask, iterations=max(1, int(round(2 * w / 768.0)))))
    )
    # Seed depuis l'ouverture centrale au bord Sud (`x ∈ [0.35w, 0.65w]`, entre les deux ruisseaux `#FF00FF`)
    lbl_path, _ = ndimage.label(path_corridor)
    south_ids = set(lbl_path[h - 6 :, int(0.35 * w) : int(0.65 * w)].ravel().tolist()) - {0}
    walkable_path = np.isin(lbl_path, list(south_ids)) & terrain_mask
    walkable_path = ndimage.binary_fill_holes(walkable_path) & terrain_mask

    mountains_mask = terrain_mask & (~walkable_path) & (yy < int(0.245 * h))
    forest_pines = terrain_mask & (~walkable_path) & (~mountains_mask)

    # 4. Couches 00 & 01 : Ciel d'hiver `D10P01` + Aurore Boréale polaire (`24 × 5 = 120` ticks)
    im_00_sky, frames_01_aurora = build_polar_sky_and_aurora_layers(
        w=w, h=h, sky_max_y_frac=0.30, n_frames=N_FRAMES
    )

    # 5. Couches 02 & 03 : Eau glaciaire canonique `1×` PMD + écume/éclats dans les ruisseaux `#FF00FF`
    frames_02_water = build_canonical_pmd_water_frames(w=w, h=h, water_mask=water_mask)
    frames_03_foam = build_canonical_pmd_waterfall_and_shore_frames(
        w=w, h=h, water_mask=water_mask, cascade_mask=None
    )

    # 6. Couches statiques 04..07 : socle neigeux, montagnes Nord, sentier Sud-Nord, sapins & souche
    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[terrain_mask, :3] = np.array([216, 226, 246], dtype=np.uint8)
    base_arr[terrain_mask, 3] = 255
    im_04_base = Image.fromarray(base_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_rgb[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_05_mountains = _mk_layer(mountains_mask)
    im_06_path = _mk_layer(walkable_path)
    im_07_pines = _mk_layer(forest_pines)

    # 7. Couches 08 & 09 : Brume glacée du seuil forestier Nord + flocons parallaxe `Top`
    mist_band = terrain_mask & (yy >= int(0.32 * h)) & (yy <= int(0.58 * h)) & (xx >= int(0.28 * w)) & (xx <= int(0.72 * w))
    frames_08_mist, frames_09_snow = build_frost_mist_and_snowfall_layers(
        w=w, h=h, mist_band_mask=mist_band, n_frames=N_FRAMES
    )

    # 8. Grille `WallGrid` continue du bord Sud (`y = gh - 1`) jusqu'au seuil Nord (`y ≈ 0.45 * gh`)
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_path[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.55

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_ciel_polaire_d10p01", "Ciel Polaire d'Hiver D10P01", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_aurore_boreale_polaire", "Aurore Boréale Polaire", "BG", frames_01_aurora, frame_length=5),
        LayerEntry("02_ruisseaux_eau_pmd_canonique", "Ruisseaux d'Eau Glaciaire Canonique PMD 1×", "BG", frames_02_water, frame_length=10),
        LayerEntry("03_ecume_et_scintillements_eau", "Écume de Berge & Scintillements PMD 1×", "BG", frames_03_foam, frame_length=10),
        LayerEntry("04_socle_neigeux_continu", "Socle Neigeux Continu", "BG", [im_04_base], frame_length=5),
        LayerEntry("05_montagnes_enneigees_d10p01", "Montagnes Enneigées Lointaines D10P01", "BG", [im_05_mountains], frame_length=5),
        LayerEntry("06_chemin_enneige_sud_nord", "Sentier Enneigé Praticable Sud-Nord", "BG", [im_06_path], frame_length=5),
        LayerEntry("07_sapins_enneiges_et_souche", "Sapins Givrés & Souche Enneigée D10P01", "BG", [im_07_pines], frame_length=5),
        LayerEntry("08_brume_glacee_seuil_nord", "Brume Glacée du Seuil Nord", "BG", frames_08_mist, frame_length=5),
        LayerEntry("09_flocons_neige_blizzard_top", "Blizzard Canonique GBA W03P03 1×", "Top", frames_09_snow, frame_length=5),
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
        max_fidelity_distance=34.0,
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
