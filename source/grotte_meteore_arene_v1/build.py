#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
GMA1 — Grotte Météore — Arène de Deoxys (`POV PMD` `b74_meteor_cave_deoxys.png` améliorée).

Suite directe de `GME1` et fidélité canonique à `b74` (*Meteor Cave — Deoxys*, *PMD Red*) :
- Vide cosmique abyssal canonique `b74` (`[0, 0, 95]`) & étoiles scintillantes (`00`, `01` `24` poses) ;
- Dalle carrée-octogonale indigo royal (`[79, 23, 199]`), anneaux sombres (`[31, 0, 239]`), orbe central
  céruléen de Deoxys (`[31, 111, 239]`), circuits psioniques néon (`[255, 39, 215]`) animés par l'onde
  radiale `b74canm` (`07` `24` poses) et pont cristallin Sud -> Nord continu depuis `y = 575` ;
- Couronne Nord de météorites taillées & grands prismes cyan (`05`, `06`, `08`) et météorites entières
  en lévitation douce (`09` `Top` `24` poses, `0` cristal coupé).
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

from moteur_grotte_meteore_b74 import (  # type: ignore
    B74_GROOVE_BLUE,
    B74_SLAB_INDIGO,
    build_b74_cosmic_space_layers,
    build_b74_psychic_wave_frames,
    build_b74_unified_palette,
    build_crystal_glint_frames,
    extract_whole_floating_meteorites,
    load_clean_meteor_raw,
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

MAP_ID = "GMA1"
MAP_TITLE = "Grotte Météore — Arène de Deoxys"
RAW_DIR = HERE / "bruts"
DECOR_RAW = RAW_DIR / "decor_arene_cle_verte.png"
REF_DIR = HERE / "references"
B74_REF = REF_DIR / "b74_meteor_cave_deoxys.png"
RENDERS_DIR = REPO_ROOT / "renders" / "grotte_meteore_arene_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_rgb, fg_mask = load_clean_meteor_raw(DECOR_RAW, w, h)
    pal = build_b74_unified_palette(B74_REF, raw_rgb, fg_mask)
    q_rgb = quantize_rgb_to_palette(raw_rgb, pal)

    yy, xx = np.mgrid[:h, :w]

    # 1. Extraction sans aucune découpe des météorites flottantes entières (`03` fixes, `09` `Top` lévitation)
    main_island, im_03_belt, frames_09_lev = extract_whole_floating_meteorites(
        q_rgb, fg_mask, n_levitating=10, n_frames=N_FRAMES
    )

    # 2. Segmentation fidèle à `b74` de la grande chambre carrée de Deoxys + pont Sud -> Nord :
    r = q_rgb[:, :, 0].astype(np.int16)
    g = q_rgb[:, :, 1].astype(np.int16)
    b = q_rgb[:, :, 2].astype(np.int16)

    arena_corridor = (
        ((yy >= int(0.20 * h)) & (yy <= int(0.71 * h)) & (xx >= int(0.29 * w)) & (xx <= int(0.71 * w)))
        | ((yy >= int(0.65 * h)) & (xx >= int(0.45 * w)) & (xx <= int(0.55 * w)))
    )
    core_orb = main_island & (np.abs(xx - 0.50 * w) <= 0.08 * w) & (np.abs(yy - 0.455 * h) <= 0.09 * h) & (g >= 80) & (b >= 195) & (r < 95)
    is_indigo_slab = main_island & arena_corridor & (b >= 145) & (r < 110)
    floor_seed = is_indigo_slab | core_orb
    walkable_slab = ndimage.binary_fill_holes(
        ndimage.binary_closing(floor_seed, iterations=max(2, int(round(5 * w / 768.0))))
    ) & main_island

    lbl_w0, _ = ndimage.label(walkable_slab)
    south_ids = [lid for lid in set(lbl_w0[h - 6 :, int(0.45 * w) : int(0.55 * w)].ravel().tolist()) if lid != 0]
    walkable_slab = np.isin(lbl_w0, south_ids) & main_island

    psi_circuits = walkable_slab & (r >= 155) & (b >= 145) & (~core_orb)
    # Conduit psionique central `b74` prolongé tout le long du pont Sud jusqu'à `y = h - 1`
    bridge_rows = walkable_slab & (yy >= int(0.67 * h))
    if np.any(bridge_rows):
        bx_mid = int(round(float(np.where(bridge_rows)[1].mean())))
        lw = max(1, int(round(2 * w / 768.0)))
        step_y = max(12, int(round(44 * h / 576.0)))
        jag = np.where(((yy // step_y) % 2) == 0, -int(round(9 * w / 768.0)), int(round(9 * w / 768.0)))
        vert_seg = bridge_rows & (np.abs(xx - (bx_mid + jag)) <= lw)
        turn_seg = bridge_rows & ((yy % step_y) < (2 * lw)) & (np.abs(xx - bx_mid) <= int(round(9 * w / 768.0)) + lw)
        bridge_psi = (vert_seg | turn_seg) & (~core_orb)
        q_rgb[bridge_psi] = np.array([255, 39, 215], dtype=np.uint8)
        psi_circuits = psi_circuits | bridge_psi
    static_slab_only = walkable_slab & (~psi_circuits) & (~core_orb)

    walls = main_island & (~walkable_slab)
    cyan_crystals = walls & (g >= 115) & (b >= 205) & (r < 135)
    bright_facets = walls & (~cyan_crystals) & (r >= 170)
    dark_ramparts = walls & (~cyan_crystals) & (~bright_facets)

    # 3. Couche 02 : Dalle météoritique continue sous toute l'île
    sol_arr = np.zeros((h, w, 4), dtype=np.uint8)
    grid_line = ((xx % 24 == 0) | (yy % 24 == 0)) & main_island
    sol_arr[main_island, :3] = B74_SLAB_INDIGO
    sol_arr[grid_line, :3] = B74_GROOVE_BLUE
    sol_arr[main_island, 3] = 255
    im_02_sol = Image.fromarray(sol_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[m, :3] = q_rgb[m]
        arr[m, 3] = 255
        return Image.fromarray(arr, mode="RGBA")

    frames_00, frames_01 = build_b74_cosmic_space_layers(w, h, n_frames=N_FRAMES)
    im_04_floor = _mk_layer(static_slab_only)
    im_05_ramparts = _mk_layer(dark_ramparts)
    im_06_facets = _mk_layer(bright_facets)

    ys_c, xs_c = np.where(core_orb)
    c_xy = (float(xs_c.mean()), float(ys_c.mean())) if ys_c.size else (0.5 * w, 0.455 * h)
    frames_07_psi = build_b74_psychic_wave_frames(q_rgb, psi_circuits, core_orb, c_xy, n_frames=N_FRAMES)
    frames_08_glint = build_crystal_glint_frames(q_rgb, cyan_crystals, n_frames=N_FRAMES)

    # Grille de collision `96 × 72` : pont Sud continu jusqu'à l'orbe central de Deoxys !
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_slab[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.65

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_vide_cosmique_abyssal_b74", "Vide Cosmique Abyssal b74", "BG", frames_00, frame_length=5),
        LayerEntry("01_etoiles_et_eclats_cosmos", "Etoiles Scintillantes Cosmos", "BG", frames_01, frame_length=5),
        LayerEntry("02_sol_dalle_meteorite_continu", "Dalle Meteorite Indigo Continue", "BG", [im_02_sol], frame_length=5),
        LayerEntry("03_meteorites_fixes_ceinture", "Ceinture Meteorites Flottantes", "BG", [im_03_belt], frame_length=5),
        LayerEntry("04_chambre_deoxys_et_pont", "Chambre Gravee b74 & Pont Sud-Nord", "BG", [im_04_floor], frame_length=5),
        LayerEntry("05_remparts_meteorite_sombres", "Couronne Nord & Remparts Sombres", "BG", [im_05_ramparts], frame_length=5),
        LayerEntry("06_facettes_pourpres_cristaux", "Facettes Vives Meteorite b74", "BG", [im_06_facets], frame_length=5),
        LayerEntry("07_onde_psionique_circuits_b74", "Onde Psionique Circuits b74canm", "BG", frames_07_psi, frame_length=5),
        LayerEntry("08_scintillement_cristaux_cyan", "Grands Prismes Cristallins Cyan", "BG", frames_08_glint, frame_length=5),
        LayerEntry("09_levitation_meteorites_top", "Meteorites Entieres en Levitation", "Top", frames_09_lev, frame_length=5),
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
        canonical_ref_for_fidelity=B74_REF,
        max_fidelity_distance=32.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="grotte_meteore_gma1",
        asset_name_override="grotte_meteore_arene",
    )
    meta["width"] = w
    meta["height"] = h
    return meta


def main() -> None:
    meta = build()
    print(json.dumps(meta, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
