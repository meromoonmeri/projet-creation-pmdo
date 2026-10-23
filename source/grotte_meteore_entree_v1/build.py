#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
GME1 — Grotte Météore — Entrée (`POV PMD` `b74_meteor_cave_deoxys.png` + Ciel Bleu Nuit Étoilé & Étoiles Filantes).

Principes stricts :
- **Zéro noir sur les roches** : toutes les ombres et contours des parois/météorites sont reconstruits en
  facettes minérales `b74` prune/améthyste/indigo royal (`max(R, G, B) >= 95`), et l'arche caverneuse Nord
  (`donjon_seuil`) s'enfonce en perspective indigo nuit cosmique traversée par un conduit psionique ;
- **Vrai ciel Bleu Nuit Profond de l'Espace (`00`, `01`)** : voiles nébulaires saphir/indigo, plus de `250`
  étoiles scintillantes et `6` étoiles filantes cométaires traversant le ciel sur `24 × 5 = 120` ticks ;
- **Continuité Sud -> Nord** : pont praticable depuis `y = 71` jusqu'au seuil de la caverne Nord.
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
    B74_NEON_PSI,
    B74_SLAB_INDIGO,
    build_b74_cosmic_space_layers,
    build_b74_psychic_wave_frames,
    build_b74_unified_palette,
    build_crystal_glint_frames,
    extract_whole_floating_meteorites,
    lift_dark_rock_shadows_to_b74,
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

MAP_ID = "GME1"
MAP_TITLE = "Grotte Météore — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_RAW = RAW_DIR / "decor_entree_cle_verte.png"
REF_DIR = HERE / "references"
B74_REF = REF_DIR / "b74_meteor_cave_deoxys.png"
RENDERS_DIR = REPO_ROOT / "renders" / "grotte_meteore_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_rgb, fg_mask = load_clean_meteor_raw(DECOR_RAW, w, h)

    # 1. Identification de la bouche caverneuse Nord (`donjon_seuil`, arche centrale au pied du rempart Nord)
    yy, xx = np.mgrid[:h, :w]
    mouth_box = (yy >= int(0.19 * h)) & (yy <= int(0.35 * h)) & (xx >= int(0.43 * w)) & (xx <= int(0.57 * w))
    cave_seed = fg_mask & mouth_box & (raw_rgb.max(axis=2) <= 28)
    lbl_cm, n_cm = ndimage.label(cave_seed)
    if n_cm > 0:
        cm_sizes = ndimage.sum(cave_seed, lbl_cm, range(1, n_cm + 1))
        cave_mouth = lbl_cm == (int(np.argmax(cm_sizes)) + 1)
    else:
        cave_mouth = cave_seed

    # 2. Suppression totale de tout noir sur les roches -> facettes minérales `b74` prune/améthyste/indigo !
    clean_rgb = lift_dark_rock_shadows_to_b74(raw_rgb, fg_mask, exclude_mask=cave_mouth)
    pal = build_b74_unified_palette(B74_REF, clean_rgb, fg_mask & (~cave_mouth))
    q_rgb = quantize_rgb_to_palette(clean_rgb, pal)

    # 3. Perspective bleu nuit / indigo cosmique dans l'arche d'entrée Nord (zéro trou noir plat !)
    if np.any(cave_mouth):
        dist_cm = ndimage.distance_transform_edt(cave_mouth)
        q_rgb[cave_mouth] = np.array([52, 16, 152], dtype=np.uint8)
        q_rgb[cave_mouth & (dist_cm > 3.0)] = np.array([34, 20, 124], dtype=np.uint8)
        q_rgb[cave_mouth & (dist_cm > 7.5)] = np.array([20, 22, 98], dtype=np.uint8)
        q_rgb[cave_mouth & (dist_cm > 12.5)] = np.array([13, 18, 78], dtype=np.uint8)

    # 4. Séparation sans découpe des météorites flottantes entières (`03` fixes, `09` `Top` en lévitation)
    main_island, im_03_belt, frames_09_lev = extract_whole_floating_meteorites(
        q_rgb, fg_mask, n_levitating=8, n_frames=N_FRAMES
    )

    # 5. Segmentation sémantique de l'île principale (`main_island`) :
    r = q_rgb[:, :, 0].astype(np.int16)
    g = q_rgb[:, :, 1].astype(np.int16)
    b = q_rgb[:, :, 2].astype(np.int16)

    slab_corridor = (
        ((yy >= int(0.30 * h)) & (yy <= int(0.70 * h)) & (xx >= int(0.20 * w)) & (xx <= int(0.80 * w)))
        | ((yy >= int(0.66 * h)) & (xx >= int(0.43 * w)) & (xx <= int(0.57 * w)))
    )
    core_orb = main_island & slab_corridor & (g >= 80) & (b >= 195) & (r < 95)
    is_indigo_slab = main_island & slab_corridor & (~cave_mouth) & (b >= 145) & (r < 110)
    floor_seed = is_indigo_slab | core_orb
    walkable_slab = ndimage.binary_fill_holes(
        ndimage.binary_closing(floor_seed, iterations=max(2, int(round(5 * w / 768.0))))
    ) & main_island & (~cave_mouth)

    lbl_w0, _ = ndimage.label(walkable_slab)
    south_ids = [lid for lid in set(lbl_w0[h - 6 :, int(0.43 * w) : int(0.57 * w)].ravel().tolist()) if lid != 0]
    walkable_slab = np.isin(lbl_w0, south_ids) & main_island & (~cave_mouth)

    # Prolongement discret du conduit psionique central jusque dans le seuil de la grotte Nord
    psi_circuits = walkable_slab & (r >= 155) & (b >= 145) & (~core_orb)
    if np.any(cave_mouth):
        cm_ys, cm_xs = np.where(cave_mouth)
        cx_mouth = int(round(float(cm_xs.mean())))
        cy_bot = int(cm_ys.max())
        lw = max(1, int(round(1.6 * w / 768.0)))
        portal_conduit = cave_mouth & (yy >= cy_bot - int(round(16 * h / 576.0))) & (np.abs(xx - cx_mouth) <= lw)
        q_rgb[portal_conduit] = B74_NEON_PSI
        psi_circuits = psi_circuits | portal_conduit

    static_slab_only = walkable_slab & (~psi_circuits) & (~core_orb)

    walls = main_island & (~walkable_slab)
    cyan_crystals = walls & (g >= 115) & (b >= 205) & (r < 130)
    bright_facets = walls & (~cyan_crystals) & (~cave_mouth) & (r >= 165)
    dark_ramparts = walls & (~cyan_crystals) & (~bright_facets)

    # 6. Couche 02 : Dalle météoritique continue sous toute l'île
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
    c_xy = (float(xs_c.mean()), float(ys_c.mean())) if ys_c.size else (0.5 * w, 0.50 * h)
    frames_07_psi = build_b74_psychic_wave_frames(q_rgb, psi_circuits, core_orb, c_xy, n_frames=N_FRAMES)
    frames_08_glint = build_crystal_glint_frames(q_rgb, cyan_crystals, n_frames=N_FRAMES)

    # Grille de collision `96 × 72` : pont Sud continu depuis `y = 71` jusqu'au seuil de grotte Nord !
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
        LayerEntry("00_vide_cosmique_abyssal_b74", "Espace Bleu Nuit & Voûte Étoilée", "BG", frames_00, frame_length=5),
        LayerEntry("01_etoiles_et_eclats_cosmos", "Étoiles Brillantes & Étoiles Filantes", "BG", frames_01, frame_length=5),
        LayerEntry("02_sol_dalle_meteorite_continu", "Dalle Meteorite Indigo Continue", "BG", [im_02_sol], frame_length=5),
        LayerEntry("03_meteorites_fixes_ceinture", "Ceinture Meteorites Flottantes", "BG", [im_03_belt], frame_length=5),
        LayerEntry("04_dalle_labyrinthe_et_pont", "Rotonde Gravee & Pont Sud-Nord", "BG", [im_04_floor], frame_length=5),
        LayerEntry("05_remparts_meteorite_sombres", "Parois Cratere & Arche Indigo Nord", "BG", [im_05_ramparts], frame_length=5),
        LayerEntry("06_facettes_pourpres_cristaux", "Facettes Vives Meteorite b74", "BG", [im_06_facets], frame_length=5),
        LayerEntry("07_onde_psionique_circuits_b74", "Onde Psionique Circuits b74canm", "BG", frames_07_psi, frame_length=5),
        LayerEntry("08_scintillement_cristaux_cyan", "Prismes Cristallins Cyan", "BG", frames_08_glint, frame_length=5),
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
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
