#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
GME1 — Grotte Météore — Entrée : Météorite Fissurée de Deoxys (`POV PMD`).

Spécifications :
- Météorite géante fracturée, quasiment détruite, dérivant dans l'espace bleu nuit étoilé traversé d'étoiles filantes ;
- Palette identitaire intégrale **Deoxys** sur tout l'endroit : plaques minérales **vermeil/corail** (`#F0583C`),
  cristaux et failles **turquoise/écume** (`#2CE4D4`), roche et chemin **violet-indigo spatial** (`#5624C0`, `0` noir) ;
- **Cristaux solides `100 %` STATIQUES** (`Couche 08`, `poses = 1` unique !) ;
- Seules les failles internes d'énergie plasma Deoxys (`Couche 07`, `24` poses), le ciel étoilé / étoiles filantes
  (`00`, `01`, `24` poses) et les `10` fragments entiers détachés (`09` `Top`, `24` poses) sont animés ;
- Chemin de pierre fracturée continu du bord Sud (`y = 71`) à travers le pont brisé jusqu'à la brèche caverneuse Nord.
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
    DEOXYS_TEAL_GLOW,
    DEOXYS_TEAL_MAIN,
    build_b74_cosmic_space_layers,
    build_deoxys_b74_palette,
    build_deoxys_fissure_energy_frames,
    extract_whole_floating_meteorites,
    lift_dark_rock_shadows_to_deoxys,
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
MAP_TITLE = "Grotte Météore — Entrée (Météorite Fissurée)"
RAW_DIR = HERE / "bruts"
DECOR_RAW = RAW_DIR / "decor_meteorite_fissuree_deoxys.png"
REF_DIR = HERE / "references"
B74_REF = REF_DIR / "b74_meteor_cave_deoxys.png"
RENDERS_DIR = REPO_ROOT / "renders" / "grotte_meteore_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_rgb, fg_mask = load_clean_meteor_raw(DECOR_RAW, w, h)

    # 1. Brèche caverneuse Nord (`donjon_seuil` au cœur de la météorite fracturée)
    yy, xx = np.mgrid[:h, :w]
    mouth_box = (yy >= int(0.18 * h)) & (yy <= int(0.36 * h)) & (xx >= int(0.42 * w)) & (xx <= int(0.58 * w))
    cave_seed = fg_mask & mouth_box & (raw_rgb.max(axis=2) <= 44)
    lbl_cm, n_cm = ndimage.label(cave_seed)
    if n_cm > 0:
        cm_sizes = ndimage.sum(cave_seed, lbl_cm, range(1, n_cm + 1))
        cave_mouth = lbl_cm == (int(np.argmax(cm_sizes)) + 1)
    else:
        cave_mouth = cave_seed

    # 2. Zéro noir sur toutes les roches + quantification à la palette unifiée Deoxys + `b74`
    clean_rgb = lift_dark_rock_shadows_to_deoxys(raw_rgb, fg_mask, exclude_mask=cave_mouth)
    pal = build_deoxys_b74_palette(B74_REF, clean_rgb, fg_mask & (~cave_mouth))
    q_rgb = quantize_rgb_to_palette(clean_rgb, pal)

    # Perspective indigo/turquoise Deoxys dans la brèche caverneuse Nord (zéro trou noir plat !)
    if np.any(cave_mouth):
        dist_cm = ndimage.distance_transform_edt(cave_mouth)
        q_rgb[cave_mouth] = np.array([62, 26, 158], dtype=np.uint8)
        q_rgb[cave_mouth & (dist_cm > 2.5)] = np.array([38, 28, 128], dtype=np.uint8)
        q_rgb[cave_mouth & (dist_cm > 5.5)] = np.array([22, 34, 104], dtype=np.uint8)
        q_rgb[cave_mouth & (dist_cm > 9.0)] = np.array([16, 48, 96], dtype=np.uint8)

    # 3. Séparation sans découpe des fragments flottants entiers (`03` fixes, `09` `Top` `10` éclats en lévitation)
    main_island, im_03_belt, frames_09_lev = extract_whole_floating_meteorites(
        q_rgb, fg_mask, n_levitating=10, n_frames=N_FRAMES
    )

    # 4. Distinction exacte entre :
    #    - `fissure_zone` : le gouffre fissuré de plasma interne (partie basse centrale `y=0.52..0.82, x=0.31..0.67`
    #      sous les ponts fracturés, hors chemin praticable et hors cristaux solides du rempart !) ;
    #    - `static_crystals` : TOUS les cristaux solides turquoise/cyan pointus sur les remparts -> `100 %` STATIQUES !
    r = q_rgb[:, :, 0].astype(np.int16)
    g = q_rgb[:, :, 1].astype(np.int16)
    b = q_rgb[:, :, 2].astype(np.int16)

    is_teal = main_island & (g >= 145) & (b >= 150) & (r < 165)

    # Chemin praticable continu Sud (`y = h - 1`) -> Pont brisé -> Cour intérieure -> Seuil de grotte Nord (`y ≈ 0.30h`)
    path_corridor = (
        # Pont sinueux Sud (`y = 0.56h .. 1.00h`)
        ((yy >= int(0.56 * h)) & (xx >= int(0.42 * w)) & (xx <= int(0.58 * w)))
        # Esplanade fracturée centrale (`y = 0.36h .. 0.60h`)
        | ((yy >= int(0.36 * h)) & (yy <= int(0.60 * h)) & (xx >= int(0.36 * w)) & (xx <= int(0.62 * w)))
        # Goulet menant directement à la brèche caverneuse Nord (`y = 0.28h .. 0.38h`)
        | ((yy >= int(0.28 * h)) & (yy <= int(0.38 * h)) & (xx >= int(0.45 * w)) & (xx <= int(0.54 * w)))
    )
    # Le chemin est en dalle violette fracturée avec dalles corail incrustées (jamais les cristaux turquoise)
    walkable_seed = main_island & path_corridor & (~is_teal) & (~cave_mouth)
    # Colonne vertébrale garantie le long de l'axe exact du pont sinueux et de l'entrée Nord
    spine_pts = [
        (0.495, 0.995),
        (0.495, 0.88),
        (0.525, 0.76),
        (0.525, 0.66),
        (0.495, 0.55),
        (0.495, 0.44),
        (0.495, 0.31),
    ]
    spine_mask = np.zeros((h, w), dtype=bool)
    half_w = max(8, int(round(18 * w / 768.0)))
    for (fx0, fy0), (fx1, fy1) in zip(spine_pts[:-1], spine_pts[1:]):
        for s in np.linspace(0.0, 1.0, 48):
            cx = int(round(w * (fx0 + (fx1 - fx0) * s)))
            cy = int(round(h * (fy0 + (fy1 - fy0) * s)))
            spine_mask[max(0, cy - half_w) : min(h, cy + half_w), max(0, cx - half_w) : min(w, cx + half_w)] = True

    walkable_slab = (walkable_seed | (spine_mask & main_island & (~cave_mouth))) & (~is_teal)

    # Gouffre fissuré de plasma interne Deoxys (`Couche 07` animée, strictement hors cristaux solides !)
    chasm_window = (
        main_island
        & (~walkable_slab)
        & (yy >= int(0.55 * h))
        & (yy <= int(0.84 * h))
        & (xx >= int(0.33 * w))
        & (xx <= int(0.66 * w))
    )
    # Séparer par composantes connexes les nappes de plasma au fond des crevasses des pointes cristallines externes
    fissure_teal = is_teal & chasm_window
    fissure_coral = (
        chasm_window
        & (~fissure_teal)
        & (r >= 210)
        & (g >= 65)
        & (ndimage.binary_dilation(fissure_teal, iterations=max(2, int(round(4 * w / 768.0)))))
    )
    fissure_any = fissure_teal | fissure_coral

    # TOUS les cristaux solides (`is_teal & ~fissure_teal`) sont sur la couche `08` STATIQUE (`1` pose unique !)
    static_crystals = is_teal & (~fissure_teal)
    coral_plates = main_island & (~walkable_slab) & (~static_crystals) & (~fissure_any) & (~cave_mouth) & (r >= 180)
    violet_ramparts = (
        main_island & (~walkable_slab) & (~static_crystals) & (~fissure_any) & (~coral_plates)
    )

    # 5. Couche 02 : Socle continu d'astéroïde Deoxys sous tout `main_island` (zéro trou sous l'animation `07`)
    sol_arr = np.zeros((h, w, 4), dtype=np.uint8)
    sol_arr[main_island, :3] = B74_SLAB_INDIGO
    sol_arr[fissure_any, :3] = DEOXYS_TEAL_MAIN
    sol_arr[((xx % 24 == 0) | (yy % 24 == 0)) & main_island & (~fissure_any), :3] = B74_GROOVE_BLUE
    sol_arr[main_island, 3] = 255
    im_02_sol = Image.fromarray(sol_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[m, :3] = q_rgb[m]
        arr[m, 3] = 255
        return Image.fromarray(arr, mode="RGBA")

    frames_00, frames_01 = build_b74_cosmic_space_layers(w, h, n_frames=N_FRAMES)
    im_04_path = _mk_layer(walkable_slab)
    im_05_ramparts = _mk_layer(violet_ramparts)
    im_06_coral = _mk_layer(coral_plates)
    frames_07_fissures = build_deoxys_fissure_energy_frames(
        q_rgb, fissure_teal, fissure_coral, (0.50 * w, 0.68 * h), n_frames=N_FRAMES
    )
    # COUCHE 08 : CRISTAUX 100 % STATIQUES (`poses = 1` !)
    im_08_static_crystals = _mk_layer(static_crystals)

    # Grille de collision `96 × 72` continue du bord Sud (`y = 71`) jusqu'à la brèche Nord (`y ≈ 22`) !
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_slab[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.55

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_vide_cosmique_abyssal_b74", "Espace Bleu Nuit & Voûte Étoilée", "BG", frames_00, frame_length=5),
        LayerEntry("01_etoiles_et_eclats_cosmos", "Étoiles Brillantes & Étoiles Filantes", "BG", frames_01, frame_length=5),
        LayerEntry("02_sol_dalle_meteorite_continu", "Socle Astéroïde Deoxys Continu", "BG", [im_02_sol], frame_length=5),
        LayerEntry("03_meteorites_fixes_ceinture", "Ceinture Éclats Météorite Fixes", "BG", [im_03_belt], frame_length=5),
        LayerEntry("04_dalle_labyrinthe_et_pont", "Chemin Fracturé & Pont Sud-Nord", "BG", [im_04_path], frame_length=5),
        LayerEntry("05_remparts_meteorite_sombres", "Parois Violet-Indigo & Brèche Nord", "BG", [im_05_ramparts], frame_length=5),
        LayerEntry("06_facettes_pourpres_cristaux", "Plaques Minérales Corail-Vermeil Deoxys", "BG", [im_06_coral], frame_length=5),
        LayerEntry("07_onde_psionique_circuits_b74", "Plasma des Fissures Deoxys", "BG", frames_07_fissures, frame_length=5),
        LayerEntry("08_cristaux_statiques_deoxys", "Cristaux Turquoise Deoxys (Statiques)", "BG", [im_08_static_crystals], frame_length=5),
        LayerEntry("09_levitation_meteorites_top", "Fragments Météorite en Lévitation", "Top", frames_09_lev, frame_length=5),
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
        canonical_ref_for_fidelity=None,
        namespace_override="grotte_meteore_gme1",
        asset_name_override="grotte_meteore_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
