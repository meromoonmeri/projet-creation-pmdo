#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MFE1 — Mont Foudre — Entrée (`POV PMD`, référence canonique `d06p01_mt_thunder_native.png`).

Architecture fidèle à `D06P01` (*Mt. Thunder Entrance — PMD Red*) + découpe 100 % `#FF00FF` :
- La crête céleste d'orage au Nord et les 2 vasques rocheuses latérales sont détourées en `#FF00FF`
  sur `bruts/base_mont_foudre_entree.png` (zéro eau ni ciel statiques cuits sur le brut) ;
- `MFE1_00` (`BG`, `1` pose) : Voûte de cumulo-nimbus d'orage `H17P01` `1×` ;
- `MFE1_01` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Nuées d'orage dérivantes & flashs intra-nuageux ;
- `MFE1_02` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Arcs électriques GBA `H17P01W1.bpa` `1×` & éclairs ramifiés ;
- `MFE1_03` (`BG`, `12` poses @ `10` ticks = `120` ticks) : Vasques d'eau d'orage GBA `H10P02.bpl` `1×` ;
- `MFE1_04` (`BG`, `1` pose) : Socle minéral continu du Mont Foudre ;
- `MFE1_05` (`BG`, `1` pose) : Sentier sablonneux Sud-Nord praticable ;
- `MFE1_06` (`BG`, `1` pose) : Hautes parois calcaires escarpées `D06P01` (`100 %` statiques) ;
- `MFE1_07` (`BG`, `1` pose) : Arbres foudroyés, aiguilles rocheuses & grotte Nord (`100 %` statiques) ;
- `MFE1_08` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Reflets d'éclairs sur les crêtes rocheuses ;
- `MFE1_09` (`Top`, `24` poses @ `5` ticks = `120` ticks) : Étincelles statiques dorées & bleutées d'Électhor.
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
    build_abyssal_water_and_current_layers,
    build_electric_sparks_top_frames,
    build_storm_and_lightning_layers,
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

MAP_ID = "MFE1"
MAP_TITLE = "Mont Foudre — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_mont_foudre_entree.png"
REF_DIR = HERE / "references"
D06P01_REF = REF_DIR / "d06p01_mt_thunder_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_foudre_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_ridge_flash_frames(
    w: int,
    h: int,
    q_rgb: np.ndarray,
    sky_mask: np.ndarray,
    terrain_mask: np.ndarray,
    n_frames: int = 24,
) -> List[Image.Image]:
    """Liseré d'illumination jaune-ivoire sur les arêtes rocheuses hautes synchronisé aux flashs d'orage."""
    dil = ndimage.binary_dilation(sky_mask, iterations=max(2, int(round(4 * w / 768.0))))
    rim = dil & terrain_mask & (q_rgb[:, :, 0] >= 180)
    bright_rgb = np.clip(
        q_rgb.astype(np.int16) + np.array([32, 30, 12], dtype=np.int16),
        0,
        255,
    ).astype(np.uint8)
    frames: List[Image.Image] = []
    for t in range(n_frames):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if t in (3, 4, 12, 13):
            arr[rim, :3] = bright_rgb[rim]
            arr[rim, 3] = 255
        frames.append(Image.fromarray(arr, mode="RGBA"))
    return frames


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_im = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    raw_rgb = np.asarray(raw_im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    yy, xx = np.mgrid[:h, :w]
    r = raw_rgb[:, :, 0].astype(np.int16)
    g = raw_rgb[:, :, 1].astype(np.int16)
    b = raw_rgb[:, :, 2].astype(np.int16)

    # 1. Découpe stricte des zones `#FF00FF` : crête céleste Nord vs vasques d'eau d'orage Sud-Ouest / Sud-Est
    all_magenta = (r >= 220) & (g <= 35) & (b >= 220)
    sky_mask = all_magenta & (yy < int(0.30 * h))
    pool_mask = all_magenta & (~sky_mask)
    terrain_mask = ~all_magenta

    # 2. Palette canonique `D06P01` sans aucune dérive magenta
    ref_pal = extract_canonical_palette([D06P01_REF], max_colors=64, min_pixels=8)
    terr_px = raw_rgb[terrain_mask]
    uniq, cnt = np.unique(terr_px, axis=0, return_counts=True)
    top_terr = uniq[np.argsort(-cnt)[:64]]
    pal = sanitize_palette_no_magenta(np.vstack([ref_pal, top_terr]), max_gap=22)
    q_rgb = quantize_rgb_to_palette(raw_rgb, pal)

    # 3. Partition sémantique :
    #    - `walkable_path` : sentier sablonneux Sud-Nord menant jusqu'à l'entrée de la grotte Nord
    #    - `trees_and_cave` : arbres calcinés sombres, rochers isolés & ouverture sombre de la grotte
    #    - `cliffs` : hautes parois calcaires latérales
    pool_guard = ndimage.binary_dilation(pool_mask, iterations=max(2, int(round(4 * w / 768.0))))
    is_dark_tree_or_cave = terrain_mask & (q_rgb[:, :, 0] < 135) & (q_rgb[:, :, 1] < 130)
    sand_cand = (
        terrain_mask
        & (~pool_guard)
        & (~is_dark_tree_or_cave)
        & (yy >= int(0.30 * h))
        & (q_rgb[:, :, 0] >= 196)
        & (q_rgb[:, :, 1] >= 162)
        & ((q_rgb[:, :, 0].astype(np.int16) - q_rgb[:, :, 2].astype(np.int16)) >= 38)
    )
    # Couloir central garantissant la continuité franche jusqu'au seuil de la grotte (`y = 0.305h..1.0h`)
    corridor = (
        terrain_mask
        & (~pool_guard)
        & (~is_dark_tree_or_cave)
        & (yy >= int(0.305 * h))
        & (xx >= int(0.41 * w))
        & (xx <= int(0.59 * w))
    )
    walkable_area = ndimage.binary_closing(sand_cand | corridor, iterations=max(2, int(round(3 * w / 768.0))))
    walkable_area = walkable_area & terrain_mask & (~pool_guard) & (~is_dark_tree_or_cave)

    trees_and_cave = terrain_mask & (~walkable_area) & (
        is_dark_tree_or_cave | ((yy >= int(0.42 * h)) & (q_rgb[:, :, 1] < 158))
    )
    cliffs = terrain_mask & (~walkable_area) & (~trees_and_cave)

    # 4. Animations matérielles GBA (H17P01 + H17P01W1.bpa + H10P02.bpl)
    im_00_sky, frames_01_clouds, frames_02_bolts, _ = build_storm_and_lightning_layers(
        w=w,
        h=h,
        sky_mask=sky_mask,
        fissure_mask=None,
        bolt_anchors_xy=[(0.19, 0.01, 0.16), (0.50, 0.01, 0.12), (0.81, 0.01, 0.16)],
        n_frames=N_FRAMES,
    )
    frames_03_pools, _, _ = build_abyssal_water_and_current_layers(
        w=w,
        h=h,
        water_mask=pool_mask,
        mode="storm_pool",
    )

    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[terrain_mask, :3] = np.array([216, 192, 142], dtype=np.uint8)
    base_arr[terrain_mask, 3] = 255
    im_04_base = Image.fromarray(base_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_rgb[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_05_path = _mk_layer(walkable_area)
    im_06_cliffs = _mk_layer(cliffs)
    im_07_trees_cave = _mk_layer(trees_and_cave)
    frames_08_flash = build_ridge_flash_frames(w=w, h=h, q_rgb=q_rgb, sky_mask=sky_mask, terrain_mask=terrain_mask)
    frames_09_sparks = build_electric_sparks_top_frames(w=w, h=h, n_frames=N_FRAMES, seed=20261101)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_area[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.50

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_ciel_orage_mont_foudre", "Voûte d'Orage H17P01 1×", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_nuees_orageuses_et_flashs", "Nuées d'Orage & Flashs Intra-Nuageux", "BG", frames_01_clouds, frame_length=5),
        LayerEntry("02_arcs_foudre_gba_h17p01w", "Arcs Électriques GBA H17P01W1.bpa 1×", "BG", frames_02_bolts, frame_length=5),
        LayerEntry("03_vasques_eau_orage_h10p02", "Vasques d'Eau d'Orage GBA H10P02.bpl 1×", "BG", frames_03_pools, frame_length=10),
        LayerEntry("04_socle_canyon_foudre", "Socle Minéral du Défilé Foudroyé", "BG", [im_04_base], frame_length=5),
        LayerEntry("05_sentier_canyon_sud_nord", "Sentier Sablonneux Sud-Nord", "BG", [im_05_path], frame_length=5),
        LayerEntry("06_falaises_calcaires_d06p01", "Hautes Falaises Escarpées D06P01", "BG", [im_06_cliffs], frame_length=5),
        LayerEntry("07_arbres_foudroyes_et_grotte", "Arbres Foudroyés & Portail Caverneux Nord", "BG", [im_07_trees_cave], frame_length=5),
        LayerEntry("08_reflets_foudre_cretes", "Reflets d'Éclairs sur les Crêtes", "BG", frames_08_flash, frame_length=5),
        LayerEntry("09_etincelles_electhor_top", "Étincelles Électriques d'Orage Top", "Top", frames_09_sparks, frame_length=5),
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
        canonical_ref_for_fidelity=D06P01_REF,
        max_fidelity_distance=30.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mont_foudre_mfe1",
        asset_name_override="mont_foudre_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
