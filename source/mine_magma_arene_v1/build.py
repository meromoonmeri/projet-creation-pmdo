#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MMA1 — Mine Magma — Arène de Groudon (`POV PMD` `d41p41a` + Roche Noire + Lave `Dark Crater Pit` `1×`).

Continuité totale `POV PMD` + `Dark Crater Pit` (`d41p41a`) avec `MME1` :
- `MMA1_00` (`BG`, `12` phases @ `10` ticks = `120` ticks) : Océan caldeira de magma canonique
  `Dark Crater Pit` (`d41p41a` `1×` natif NDS, `96 × 96` sans aucune couture) ;
- `MMA1_01` (`BG`, `1` pose) : Sol volcanique noir continu (`sol_pavage_basalte_complet.png`) ;
- `MMA1_02` (`BG`, `12` phases @ `10` ticks = `120` ticks) : Fissures `#FF00FF` dans la couronne de roche noire ;
- `MMA1_03` (`BG`, `15` phases @ `8` ticks = `120` ticks) : **Animation visqueuse de rive & croûte de
  bordure rocher** (`Dark Crater Pit` 13 tons : halo d'ébullition jaune d'or + plaques de croûte sombre) ;
- `MMA1_04` (`BG`, `1` pose) : Grand plateau central praticable de roche volcanique noire & pont Sud -> Nord ;
- `MMA1_05` (`BG`, `12` phases @ `10` ticks = `120` ticks) : Symbole `Ω` de Primo-Groudon gravé à plat à même
  le sol sombre du plateau central et pulsant dans la rampe `Dark Crater Pit` ;
- `MMA1_06` (`BG`, `1` pose) : Falaises basses, pitons marins d'obsidienne & couronne Nord de roche noire ;
- `MMA1_07` (`BG`, `15` phases @ `8` ticks = `120` ticks) : Incandescence thermique de bordure rocher ;
- `MMA1_08` (`BG`, `24` phases @ `5` ticks = `120` ticks) : Grande cascade visqueuse centrale Nord + 4 colonnes
  géantes de magma `Dark Crater Pit` (`colonnes_geantes.py`) montant jusqu'au bord haut `y = 0` ;
- `MMA1_09` (`Top`, `16` phases @ `7` ticks = `112` ticks) : Braises volcaniques montantes `W04` `1×` natives.
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

from moteur_magma_canonique_pmd_red import (  # type: ignore
    DARK_CRATER_VISCOUS_PAL,
    build_canonical_w04_embers_frames,
    build_dark_crater_cascade_and_giant_columns,
    build_dark_crater_pit_magma_frames,
    build_dark_crater_rim_glow_frames,
    build_primal_groudon_floor_rune_frames,
    render_dark_crater_viscous_shoreline,
    split_magenta_chasms_and_veins,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
    quantize_rgb_to_palette,
)

MAP_ID = "MMA1"
MAP_TITLE = "Mine Magma — Arène de Groudon"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "decor_arene_veines_magenta.png"
REF_DIR = HERE / "references"
DCP_PREVIEW_REF = REF_DIR / "dark_crater_pit" / "dark_crater_arene_ref.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mine_magma_arene_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_unified_arena_palette(decor_rgb: np.ndarray, rock_mask: np.ndarray) -> np.ndarray:
    rock_px = decor_rgb[rock_mask]
    uniq, cnt = np.unique(rock_px, axis=0, return_counts=True)
    top_rock = uniq[np.argsort(-cnt)[:96]]
    black_anchors = np.array(
        [
            [6, 5, 5],
            [12, 11, 11],
            [18, 17, 17],
            [26, 25, 25],
            [35, 34, 34],
            [45, 44, 44],
            [56, 55, 54],
            [68, 66, 65],
        ],
        dtype=np.uint8,
    )
    return np.unique(np.vstack([DARK_CRATER_VISCOUS_PAL, top_rock, black_anchors]), axis=0).astype(np.uint8)


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    decor_raw = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    decor_rgb = np.asarray(decor_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    sol_raw = Image.open(RAW_DIR / "sol_pavage_basalte_complet.png").convert("RGB")
    sol_rgb = np.asarray(sol_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    min_chasm = max(500, int(round(3500 * (w * h) / float(W_CANON * H_CANON))))
    all_magenta, open_chasm_raw, _ = split_magenta_chasms_and_veins(
        decor_rgb, min_open_chasm_area=min_chasm
    )
    rock_mask = ~all_magenta

    # 1. Brèche centrale Nord entre les deux cornes de basalte noir (`x ∈ [0.43w, 0.57w], y ∈ [0.07h, 0.39h]`)
    yy, xx = np.mgrid[:h, :w]
    breach_box = (xx >= int(0.43 * w)) & (xx <= int(0.57 * w)) & (yy >= int(0.08 * h)) & (yy <= int(0.39 * h))
    north_breach_mask = all_magenta & breach_box
    open_chasm = open_chasm_raw & (~north_breach_mask)
    rock_veins = all_magenta & (~open_chasm) & (~north_breach_mask)

    volcanic_pal = build_unified_arena_palette(decor_rgb, rock_mask)
    q_decor = quantize_rgb_to_palette(decor_rgb, volcanic_pal)
    q_sol = quantize_rgb_to_palette(sol_rgb, volcanic_pal)

    lum = (
        0.299 * decor_rgb[:, :, 0].astype(np.float32)
        + 0.587 * decor_rgb[:, :, 1].astype(np.float32)
        + 0.114 * decor_rgb[:, :, 2].astype(np.float32)
    )
    L_smooth = ndimage.uniform_filter(lum, size=max(3, int(round(9 * w / 768.0))))

    # 2. Grand plateau central `POV PMD` (`d41p41a`) + pont basaltique Sud -> Nord :
    island_corridor = (
        ((yy >= int(0.36 * h)) & (yy <= int(0.84 * h)) & (xx >= int(0.28 * w)) & (xx <= int(0.72 * w)))
        | ((yy >= int(0.76 * h)) & (xx >= int(0.42 * w)) & (xx <= int(0.58 * w)))
    )
    floor_cand = (
        rock_mask
        & island_corridor
        & ((L_smooth >= 26.0) | ((yy >= int(0.78 * h)) & (xx >= int(0.455 * w)) & (xx <= int(0.545 * w)) & (lum >= 12.0)))
        & (~ndimage.binary_dilation(all_magenta, iterations=max(2, int(round(4 * w / 768.0)))))
    )
    floor_smooth = ndimage.binary_closing(floor_cand, iterations=max(2, int(round(5 * w / 768.0))))
    south_rows = max(3, int(round(8 * h / 576.0)))
    floor_smooth[h - south_rows :, :] = (
        rock_mask[h - south_rows :, :]
        & (xx[h - south_rows :, :] >= int(0.44 * w))
        & (xx[h - south_rows :, :] <= int(0.56 * w))
        & (lum[h - south_rows :, :] >= 12.0)
    )
    lbl_p, _ = ndimage.label(floor_smooth)
    south_seed_labels = [
        lbl_id
        for lbl_id in set(lbl_p[h - 6 :, int(0.43 * w) : int(0.57 * w)].ravel().tolist())
        if lbl_id != 0
    ]
    walkable_arena_floor = np.isin(lbl_p, south_seed_labels) & rock_mask & (~all_magenta)
    walkable_arena_floor = ndimage.binary_fill_holes(walkable_arena_floor) & rock_mask & (~all_magenta)

    all_non_walk_rock = rock_mask & (~walkable_arena_floor)

    # 3. Couche 00 : Océan caldeira `Dark Crater Pit` (`d41p41a`, `1×` natif `12 × 10 = 120` ticks)
    frames_00_sea = build_dark_crater_pit_magma_frames(w=w, h=h, mask=None, phase_offset=0)

    # 4. Couche 01 : Sol basaltique noir continu sans couture
    arr_01_sol = np.zeros((h, w, 4), dtype=np.uint8)
    arr_01_sol[rock_mask, :3] = q_sol[rock_mask]
    arr_01_sol[rock_mask, 3] = 255

    # 5. Couche 02 : Fissures `#FF00FF` dans la couronne de roche noire (`12 × 10 = 120` ticks)
    veins_mask = ndimage.binary_dilation(rock_veins, iterations=1) & all_magenta
    frames_02_veins = build_dark_crater_pit_magma_frames(
        w=w,
        h=h,
        mask=veins_mask,
        phase_offset=5,
        roll_xy=(40, 24),
    )

    # 6. Couche 03 : Animation visqueuse de rive & croûte de bordure rocher (`15 × 8 = 120` ticks)
    band_px = max(8.0, 22.0 * (w / float(W_CANON)))
    frames_03_viscous_shore = render_dark_crater_viscous_shoreline(
        open_chasm_raw,
        n_frames=15,
        band_px=band_px,
    )

    # 7. Couche 04 : Plateau central praticable & pont Sud -> Nord
    out_floor = np.zeros((h, w, 4), dtype=np.uint8)
    out_floor[walkable_arena_floor, :3] = q_decor[walkable_arena_floor]
    out_floor[walkable_arena_floor, 3] = 255
    im_04_floor = Image.fromarray(out_floor, mode="RGBA")

    # 8. Couche 05 : Symbole `Ω` de Primo-Groudon gravé à plat sur le sol rocheux (`12 × 10 = 120` ticks)
    frames_05_rune = build_primal_groudon_floor_rune_frames(
        floor_mask=walkable_arena_floor,
        center_xy=(0.50 * w, 0.585 * h),
        radii_xy=(0.145 * w, 0.115 * h),
        floor_rgb=q_decor,
    )

    # 9. Couche 06 : Couronne Nord, falaises basses & pitons marins de roche noire (`POV PMD`)
    out_rock = np.zeros((h, w, 4), dtype=np.uint8)
    out_rock[all_non_walk_rock, :3] = q_decor[all_non_walk_rock]
    out_rock[all_non_walk_rock, 3] = 255
    im_06_cliffs = Image.fromarray(out_rock, mode="RGBA")

    # 10. Couche 07 : Incandescence thermique synchronisée de bordure rocher (`15 × 8 = 120` ticks)
    frames_07_glow = build_dark_crater_rim_glow_frames(out_rock, all_magenta)

    # 11. Couche 08 : Grande cascade Nord + 4 colonnes géantes `Dark Crater Pit` sortant par `y = 0` (`24 × 5 = 120` ticks)
    sx = w / float(W_CANON)
    sy = h / float(H_CANON)
    col_specs = [
        {"nom": "gauche_fond", "x": int(round(128 * sx)), "y": int(round(206 * sy)), "demi": max(7, int(round(15 * sx))), "decalage": 0, "graine": 1},
        {"nom": "gauche_devant", "x": int(round(62 * sx)), "y": int(round(452 * sy)), "demi": max(10, int(round(21 * sx))), "decalage": 6, "graine": 2},
        {"nom": "droite_fond", "x": int(round(640 * sx)), "y": int(round(206 * sy)), "demi": max(7, int(round(15 * sx))), "decalage": 10, "graine": 3},
        {"nom": "droite_devant", "x": int(round(706 * sx)), "y": int(round(452 * sy)), "demi": max(10, int(round(21 * sx))), "decalage": 3, "graine": 4},
    ]
    frames_08_cascade_and_cols = build_dark_crater_cascade_and_giant_columns(
        w=w,
        h=h,
        open_sea_mask=open_chasm,
        north_breach_mask=north_breach_mask,
        col_specs=col_specs,
        n_phases=15,
    )

    # 12. Couche 09 (`Top`, `Layer = 4`) : Braises volcaniques montantes `W04` `1×` (`16 × 7` ticks)
    frames_09_embers = build_canonical_w04_embers_frames(w=w, h=h)

    # 13. Grille de collision `96 × 72` : pont Sud continu jusqu'au vaste plateau central de Groudon !
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_arena_floor[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            mag_blk = all_magenta[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = (float(blk.mean()) >= 0.60) and (not bool(mag_blk.any()))

    lbl_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        south_ids = set(lbl_w[-1, :].tolist()) - {0}
        if south_ids:
            walk_grid = np.isin(lbl_w, list(south_ids))

    layers = [
        LayerEntry("00_mer_caldeira_magma_dcp", "Mer Caldeira Dark Crater Pit 1x", "BG", frames_00_sea, frame_length=10),
        LayerEntry("01_sol_basalte_continu", "Sol Volcanique Noir Continu", "BG", [Image.fromarray(arr_01_sol, "RGBA")], frame_length=5),
        LayerEntry("02_veines_magma_magenta_dcp", "Fissures Magma Magenta Dark Crater Pit", "BG", frames_02_veins, frame_length=10),
        LayerEntry("03_rive_magma_visqueux_bordure", "Rive Magma Visqueux & Bordure Rocher", "BG", frames_03_viscous_shore, frame_length=8),
        LayerEntry("04_plateau_et_pont_arene", "Plateau Cratere Noir & Pont Sud-Nord", "BG", [im_04_floor], frame_length=5),
        LayerEntry("05_rune_primo_groudon_sol", "Symbole Primo-Groudon Grave Pulsant", "BG", frames_05_rune, frame_length=10),
        LayerEntry("06_falaises_roche_noire_magma", "Couronne, Falaises & Pitons Roche Noire", "BG", [im_06_cliffs], frame_length=5),
        LayerEntry("07_incandescence_parois_dcp", "Incandescence Bordure Rocher DCP", "BG", frames_07_glow, frame_length=8),
        LayerEntry("08_cascade_et_colonnes_geantes", "Cascade Nord & Colonnes Geantes DCP", "BG", frames_08_cascade_and_cols, frame_length=8),
        LayerEntry("09_braises_volcaniques_w04_top", "Braises Volcaniques Canoniques W04", "Top", frames_09_embers, frame_length=7),
    ]
    return layers, walk_grid, volcanic_pal


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
        canonical_ref_for_fidelity=DCP_PREVIEW_REF,
        max_fidelity_distance=30.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mine_magma_mma1",
        asset_name_override="mine_magma_arene",
    )
    meta["width"] = w
    meta["height"] = h
    return meta


def main() -> None:
    meta = build()
    print(json.dumps(meta, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
