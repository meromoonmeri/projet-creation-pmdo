#!/usr/bin/env python3
"""Constructeur PMDO `0.8.12.0` — `FAE1` (*Fosse d'Argent — Entrée Engloutie / Silver Trench Entrance*).

Architecture `768 × 576` (`96 × 72` tuiles `8×8`), `10` calques (`9 BG` + `1 Top`), `0 px` de ciel :
  - Base `1×` native GBA *PMD Red* `H01P03` (*Serene Sea* : portail englouti Nord à colonnes cannelées,
    marches antiques sous-marines, récifs de coraux turquoises, fûts de marbre brisés) ;
  - Mouvements d'eau sous-marine 4 phases issus de `Metano_Town_River_Animation_1..4.tile` dans les fosses
    sombres du plancher océanique + éclats caustiques natifs `Metano_Town_River_Sparkles.tile` ;
  - Les **5 faisceaux lumineux sous-marins verticaux officiels Chunsoft `H02P02W`** (*Deep-Sea Current*)
    sur le calque `09 Top` à faible opacité translucide + fines bulles d'argent ascendantes.
"""

from __future__ import annotations

import json
import math
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[2]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from source.moteur_cyclones_cylindriques_unova import sanitize_rgba_binary
from source.moteur_forets_pmd_red import _q8_u8, _sanitize_rgb_no_magenta
from source.moteur_fosse_argent_lugia import (
    H_CANON,
    TILE_SIZE,
    W_CANON,
    build_h02p02w_light_shafts_top,
    build_metano_abyssal_water_4phases,
    build_metano_caustic_sparkles_frames,
)
from source.moteur_gba_pmd_red_natif import (
    PURE_MAGENTA,
    load_gba_map_bundle,
    make_layer_rgba,
    render_gba_native,
    resize_nearest_mask,
    resize_nearest_rgba,
)
from source.tour_celeste_moteur_nuages import LayerEntry, build_rsground_package

HERE = Path(__file__).resolve().parent
RAW_DIR = HERE / "bruts"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "fosse_argent_entree_v1"

DECOR_MAGENTA_RAW = RAW_DIR / "decor_entree_fosse_argent_magenta.png"
H01P03_REF = REF_DIR / "H01P03_native_pmd_red.png"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / "FAE1_PMDO_0.8.12.zip"

MAP_ID = "FAE1"
MAP_TITLE = "Fosse d'Argent — Entrée Engloutie (Silver Trench Entrance)"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    nat_rgba, nat_pm, _ = render_gba_native("H01P03", phase=None, bpa_frame=0)
    REF_DIR.mkdir(parents=True, exist_ok=True)
    if not H01P03_REF.is_file():
        Image.fromarray(nat_rgba[:, :, :3], mode="RGB").save(H01P03_REF)

    rgb = resize_nearest_rgba(nat_rgba, w, h)[:, :, :3].copy()
    rgb = _sanitize_rgb_no_magenta(rgb, np.ones((h, w), dtype=bool))

    # Décomposition exacte par slots matériels GBA `H01P03` :
    # slot 1 = fond sablonneux/rocheux ouvert du bassin englouti
    # slots 0 & 4 = parois abyssales profondes & fosses sombres
    # slot 3 = terrasses d'algues émeraude-bleu
    # slot 2 = colonnes cannelées antiques, escalier Nord & portail englouti
    # slot 5 = coraux bioluminescents turquoises
    seafloor_open = resize_nearest_mask(nat_pm == 1, w, h)
    deep_walls = resize_nearest_mask(np.isin(nat_pm, [0, 4]), w, h)
    kelp_terraces = resize_nearest_mask(nat_pm == 3, w, h)
    marble_ruins = resize_nearest_mask(nat_pm == 2, w, h)
    glow_corals = resize_nearest_mask(nat_pm == 5, w, h)

    yy, xx = np.mgrid[:h, :w]
    # Cuvettes abyssales profondes au centre du plancher océanique (`max(R,G,B) <= 108` hors récifs hauts)
    trench_pools = (deep_walls | seafloor_open) & (rgb.max(axis=2) <= 108) & (yy >= int(0.22 * h))
    water_basin_mask = seafloor_open | trench_pools

    if w == W_CANON and h == H_CANON:
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        brut = rgb.copy()
        brut[water_basin_mask] = PURE_MAGENTA
        Image.fromarray(brut, mode="RGB").save(DECOR_MAGENTA_RAW)

    # Calque 00 : Fond marin `H01P03` statique (`poses = 1`, fidélité `1×` exacte à Chunsoft)
    im_00_seafloor = make_layer_rgba(rgb, water_basin_mask)

    # Calque 01 : Courants sous-marins 4 phases `Metano_Town_River_Animation_1..4.tile` dans les cuvettes abyssales
    metano_4 = build_metano_abyssal_water_4phases(w, h, tint_mode="serene_entrance")
    frames_01_currents: List[Image.Image] = []
    for k in range(4):
        cur_rgb = rgb.copy()
        if k > 0:
            blend = (0.72 * rgb.astype(np.float32) + 0.28 * metano_4[k].astype(np.float32))
            cur_rgb[trench_pools] = _sanitize_rgb_no_magenta(_q8_u8(blend), trench_pools)[trench_pools]
        frames_01_currents.append(make_layer_rgba(cur_rgb, trench_pools))

    # Calque 02 : Éclats caustiques d'argent `Metano_Town_River_Sparkles.tile` (`6 poses @ 20t = 120t`)
    frames_02_caustics = build_metano_caustic_sparkles_frames(w, h, seafloor_open, n_frames=6, seed=10301)

    # Calques 03..07 : Architecture engloutie & récifs coralliens `H01P03` (`100 %` statiques `poses = 1`)
    im_03_deep_walls = make_layer_rgba(rgb, deep_walls & (~trench_pools))
    im_04_terraces = make_layer_rgba(rgb, kelp_terraces)

    portal_zone = (yy <= int(0.30 * h)) & (xx >= int(0.34 * w)) & (xx <= int(0.66 * w))
    stairs_and_portal = marble_ruins & portal_zone
    columns_and_shafts = marble_ruins & (~portal_zone)

    im_05_portal = make_layer_rgba(rgb, stairs_and_portal)
    im_06_columns = make_layer_rgba(rgb, columns_and_shafts)
    im_07_corals = make_layer_rgba(rgb, glow_corals)

    # Calque 08 : Bulles d'argent ascendantes & pulsation bioluminescente des pointes de corail (`8 poses @ 15t = 120t`)
    coral_tips = glow_corals & (rgb[:, :, 2] >= 224) & (rgb[:, :, 1] >= 188)
    rng_b = np.random.default_rng(10388)
    n_bub = 24
    bx0 = rng_b.integers(max(8, w // 12), max(16, w - w // 12), size=n_bub)
    by0 = rng_b.integers(max(12, h // 8), max(24, h - h // 10), size=n_bub)
    bph = rng_b.uniform(0.0, 2.0 * math.pi, size=n_bub)

    frames_08_bubbles: List[Image.Image] = []
    for f in range(8):
        theta = 2.0 * math.pi * f / 8.0
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if f in (2, 3, 4, 5):
            shimmer = coral_tips & (((xx + yy + f) % 3) == 0)
            arr[shimmer] = np.array([216, 252, 255, 255], dtype=np.uint8)
        for i in range(n_bub):
            px = int(round(bx0[i] + 2.0 * math.sin(theta + bph[i])))
            py = int((by0[i] - int(round((f / 8.0) * max(16, h // 10)))) % (h - 16)) + 8
            if 4 <= px < w - 4 and 4 <= py < h - 4:
                arr[py, px] = (200, 248, 255, 255)
                if py + 1 < h - 4:
                    arr[py + 1, px] = (96, 200, 240, 255)
        frames_08_bubbles.append(Image.fromarray(sanitize_rgba_binary(arr)))

    # Calque 09 Top : Les 5 faisceaux sous-marins verticaux officiels Chunsoft `H02P02W` (`8 poses @ 15t = 120t`)
    # + linteau supérieur du portail Nord en surplomb (`y < 0.08 * h`)
    lintel_mask = marble_ruins & (yy < int(0.08 * h)) & (xx >= int(0.38 * w)) & (xx <= int(0.62 * w))
    canopy_rgba = np.asarray(make_layer_rgba(rgb, lintel_mask), dtype=np.uint8)
    frames_09_top = build_h02p02w_light_shafts_top(w, h, canopy_rgba, n_frames=8, shaft_alpha=40)

    # Grille de marche continue depuis le bord Sud (`y = gh - 1`) jusqu'au portail englouti Nord (`y ≈ 0.08..0.22 * h`)
    central_stair_corridor = (xx >= int(0.42 * w)) & (xx <= int(0.58 * w)) & (yy >= int(0.08 * h)) & (yy <= int(0.32 * h))
    south_entry_corridor = (xx >= int(0.34 * w)) & (xx <= int(0.66 * w)) & (yy >= int(0.84 * h))
    walkable_px = (
        ((seafloor_open | trench_pools) & (~glow_corals) & (~kelp_terraces))
        | central_stair_corridor
        | south_entry_corridor
    )
    # Bloque les grands massifs coralliens latéraux
    side_reefs = (kelp_terraces | glow_corals) & (~central_stair_corridor)
    walkable_px &= ~ndimage.binary_dilation(side_reefs, iterations=max(1, w // 384))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_px[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.45

    # Assure le couloir central continu du Sud au Portail Nord
    cx0, cx1 = int(0.45 * gw), int(0.55 * gw)
    walk_grid[int(0.10 * gh) : gh, cx0:cx1] = True

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    b_h01 = load_gba_map_bundle("H01P03")
    pal = np.unique(b_h01["base_pals"][:, 1:, :3].reshape(-1, 3), axis=0).astype(np.uint8)

    layers = [
        LayerEntry("00_fond_marin_abyssal_h01p03", "Plancher Océanique Englouti H01P03 1×", "BG", [im_00_seafloor], frame_length=5),
        LayerEntry("01_courants_abyssaux_metano", "Courants Sous-Marins 4 Phases Metano", "BG", frames_01_currents, frame_length=30),
        LayerEntry("02_caustiques_argent_metano", "Éclats Caustiques d'Argent Metano", "BG", frames_02_caustics, frame_length=20),
        LayerEntry("03_parois_fosse_profonde_h01p03", "Parois Rocheuses de la Fosse H01P03", "BG", [im_03_deep_walls], frame_length=5),
        LayerEntry("04_terrasses_et_recifs_h01p03", "Terrasses d'Algues & Récifs H01P03", "BG", [im_04_terraces], frame_length=5),
        LayerEntry("05_escalier_et_portail_nord_h01p03", "Escalier Englouti & Portail Nord H01P03", "BG", [im_05_portal], frame_length=5),
        LayerEntry("06_colonnes_cannelees_antiques_h01p03", "Colonnes Antiques Cannelées H01P03", "BG", [im_06_columns], frame_length=5),
        LayerEntry("07_coraux_turquoises_fosse_h01p03", "Coraux Bioluminescents Turquoises H01P03", "BG", [im_07_corals], frame_length=5),
        LayerEntry("08_bulles_abyssales_ascendantes", "Bulles d'Argent Ascendantes & Éclats Coralliens", "BG", frames_08_bubbles, frame_length=15),
        LayerEntry("09_rayons_sous_marins_h02p02w_top", "Rayons Sous-Marins H02P02W & Linteau Top", "Top", frames_09_top, frame_length=15),
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
        canonical_ref_for_fidelity=H01P03_REF,
        max_fidelity_distance=6.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="fosse_argent_fae1",
        asset_name_override="fosse_argent_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
