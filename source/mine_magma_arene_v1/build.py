#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MMA1 — Mine Magma — Arène de Groudon (`POV PMD` `d41p41a` + Mer Assombrie + Lames Pangéennes).

Conformité stricte aux consignes utilisateur :
1. **ZÉRO lave à l'entrée Nord de Groudon** : tout le massif montagneux Nord et le gouffre noir profond
   Nord-Sud (`#050404`) d'arrivée de Groudon sont `100 %` basalte noir volcanique sans aucune fente/cascade ;
2. **Mer de magma de la caldeira légèrement plus sombre** (`sea_darken=True` sur `d41p41a` `1×` `96 × 96`
   en `12 × 10 = 120` ticks : cramoisi volcanique profond & ambre en fusion, `0` couture, `0` jaune aveuglant) ;
3. **Lames Pangéennes (*Precipice Blades*) jaillissant de la lave autour de l'arène de Groudon** :
   couche dédiée `MMA1_07` (`24` poses @ `5` ticks = `120` ticks) propulsant `8` monolithes obliques
   d'obsidienne taillée parcourus de veines incandescentes de Primo-Groudon en amphithéâtre autour du
   plateau central avec ébullition et projections de magma à leur base ;
4. **4 colonnes géantes ascendantes** (`MMA1_08`, `24` poses @ `5` ticks = `120` ticks, `-8 px/pose`)
   et **animation visqueuse de rive strictement limitée aux rives basses (`z = 0`)** du plateau central.
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

from magma_visqueux.lames_pangeennes import (  # type: ignore
    PRECIPICE_BLADE_SITES_768,
    build_precipice_blades_frames,
)
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

    # 1. ZÉRO lave à l'entrée Nord de Groudon (`north_breach_mask` vide, `0` coulée sur le massif Nord) !
    yy, xx = np.mgrid[:h, :w]
    north_breach_mask = np.zeros((h, w), dtype=bool)
    open_chasm = open_chasm_raw.copy()

    volcanic_pal = build_unified_arena_palette(decor_rgb, rock_mask)
    q_decor = quantize_rgb_to_palette(decor_rgb, volcanic_pal)
    q_sol = quantize_rgb_to_palette(sol_rgb, volcanic_pal)

    lum = (
        0.299 * decor_rgb[:, :, 0].astype(np.float32)
        + 0.587 * decor_rgb[:, :, 1].astype(np.float32)
        + 0.114 * decor_rgb[:, :, 2].astype(np.float32)
    )
    # Préserve le noir abyssal (`[5, 4, 4]`) de l'entrée caverneuse Nord-Sud d'arrivée de Groudon
    groudon_north_cave = (
        rock_mask
        & (xx >= int(0.42 * w))
        & (xx <= int(0.58 * w))
        & (yy >= int(0.16 * h))
        & (yy <= int(0.41 * h))
        & (decor_rgb.max(axis=2) <= 10)
    )
    q_decor[groudon_north_cave] = np.array([5, 4, 4], dtype=np.uint8)
    L_smooth = ndimage.uniform_filter(lum, size=max(3, int(round(9 * w / 768.0))))

    # 2. Grand plateau central `POV PMD` (`d41p41a`) + pont basaltique Sud -> Nord :
    island_corridor = (
        ((yy >= int(0.36 * h)) & (yy <= int(0.84 * h)) & (xx >= int(0.28 * w)) & (xx <= int(0.72 * w)))
        | ((yy >= int(0.76 * h)) & (xx >= int(0.42 * w)) & (xx <= int(0.58 * w)))
    )
    floor_cand = (
        rock_mask
        & (~groudon_north_cave)
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
    walkable_arena_floor = np.isin(lbl_p, south_seed_labels) & rock_mask & (~groudon_north_cave) & (~all_magenta)
    walkable_arena_floor = ndimage.binary_fill_holes(walkable_arena_floor) & rock_mask & (~groudon_north_cave) & (~all_magenta)

    all_non_walk_rock = rock_mask & (~walkable_arena_floor)

    # Restriction stricte des animations de rive aux SEULES rives basses (`z = 0`) du plateau central
    lbl_rock, _ = ndimage.label(rock_mask)
    center_island_ids = [
        rid
        for rid in set(lbl_rock[int(0.56 * h) : int(0.68 * h), int(0.44 * w) : int(0.56 * w)].ravel().tolist())
        if rid != 0
    ]
    low_waterline_rock = np.isin(lbl_rock, center_island_ids) & (yy >= int(0.545 * h))
    shore_open_mask = ~low_waterline_rock

    sx = w / float(W_CANON)
    sy = h / float(H_CANON)

    # 3. Couche 00 : Océan caldeira `Dark Crater Pit` légèrement plus sombre (`sea_darken=True`, `12 × 10 = 120` ticks)
    frames_00_sea = build_dark_crater_pit_magma_frames(w=w, h=h, mask=None, phase_offset=0, sea_darken=True)

    # 4. Couche 01 : Sol basaltique noir continu sans couture
    arr_01_sol = np.zeros((h, w, 4), dtype=np.uint8)
    arr_01_sol[rock_mask, :3] = q_sol[rock_mask]
    arr_01_sol[rock_mask, 3] = 255

    # 5. Couche 02 : Failles sous-marines irrégulières sous les `8` foyers des Lames Pangéennes (`12 × 10 = 120` ticks)
    fault_mask = np.zeros((h, w), dtype=bool)
    for s_cfg in PRECIPICE_BLADE_SITES_768:
        bx, by, hw, sd = s_cfg["x"], s_cfg["y"], s_cfg["half_w"], int(s_cfg["seed"])
        dx_f = (xx.astype(np.float32) - bx * sx) / max(4.0, 1.55 * hw * sx)
        dy_f = (yy.astype(np.float32) - by * sy) / max(3.0, 0.62 * hw * sy)
        ang_f = np.arctan2(dy_f, dx_f)
        jag_f = 0.80 + 0.22 * np.sin(5.0 * ang_f + sd) + 0.15 * np.cos(8.0 * ang_f - 2.0 * sd)
        fault_mask |= open_chasm & (np.hypot(dx_f, dy_f) <= jag_f)
    frames_02_faults = build_dark_crater_pit_magma_frames(
        w=w,
        h=h,
        mask=fault_mask,
        phase_offset=4,
        roll_xy=(40, 24),
        sea_darken=True,
    )

    # 6. Couche 03 : Animation visqueuse de rive & croûte de bordure rocher assombrie (`15 × 8 = 120` ticks)
    band_px = max(6.0, 11.5 * sx)
    frames_03_raw = render_dark_crater_viscous_shoreline(
        shore_open_mask,
        n_frames=15,
        band_px=band_px,
        sea_darken=True,
    )
    frames_03_viscous_shore = []
    for im_s in frames_03_raw:
        arr_s = np.asarray(im_s, dtype=np.uint8).copy()
        arr_s[~open_chasm] = 0
        frames_03_viscous_shore.append(Image.fromarray(arr_s, mode="RGBA"))

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

    # 9. Couche 06 : Couronne Nord `100 %` basalte noir + gouffre noir profond & falaises périphériques (`POV PMD`)
    out_rock = np.zeros((h, w, 4), dtype=np.uint8)
    out_rock[all_non_walk_rock, :3] = q_decor[all_non_walk_rock]
    out_rock[all_non_walk_rock, 3] = 255
    low_shore_contact = open_chasm & ndimage.binary_dilation(low_waterline_rock, iterations=2)
    frames_06_cliffs = build_dark_crater_rim_glow_frames(out_rock, low_shore_contact)
    # Superpose la roche noire intacte en dessous pour garantir 100 % d'opacité sur le massif Nord et les falaises
    frames_06_rock_with_low_rim = []
    for im_g in frames_06_cliffs:
        base_r = out_rock.copy()
        ga = np.asarray(im_g, dtype=np.uint8)
        m_g = ga[:, :, 3] > 0
        base_r[m_g] = ga[m_g]
        frames_06_rock_with_low_rim.append(Image.fromarray(base_r, mode="RGBA"))

    # 10. Couche 07 : **Lames Pangéennes (*Precipice Blades*) jaillissant de la lave autour de l'arène (`24 × 5 = 120` ticks)**
    frames_07_blades = build_precipice_blades_frames(
        w=w,
        h=h,
        open_sea_mask=open_chasm,
        walk_floor_mask=walkable_arena_floor,
        n_phases=24,
    )

    # 11. Couche 08 : **4 Colonnes Géantes ascendantes (`24 × 5 = 120` ticks, `0` coulée à l'entrée Nord)**
    col_specs = [
        {"nom": "gauche_fond", "x": int(round(92 * sx)), "y": int(round(202 * sy)), "demi": max(7, int(round(14 * sx))), "decalage": 0, "graine": 1},
        {"nom": "gauche_devant", "x": int(round(76 * sx)), "y": int(round(456 * sy)), "demi": max(9, int(round(19 * sx))), "decalage": 12, "graine": 2},
        {"nom": "droite_fond", "x": int(round(676 * sx)), "y": int(round(202 * sy)), "demi": max(7, int(round(14 * sx))), "decalage": 18, "graine": 3},
        {"nom": "droite_devant", "x": int(round(692 * sx)), "y": int(round(456 * sy)), "demi": max(9, int(round(19 * sx))), "decalage": 6, "graine": 4},
    ]
    frames_08_cols = build_dark_crater_cascade_and_giant_columns(
        w=w,
        h=h,
        open_sea_mask=open_chasm,
        north_breach_mask=north_breach_mask,
        col_specs=col_specs,
        n_phases=24,
    )

    # 12. Couche 09 (`Top`, `Layer = 4`) : Braises volcaniques montantes `W04` `1×` (`16 × 7` ticks),
    #     masquées sur tout le massif rocheux d'entrée Nord pour préserver 0 pixel chaud sur l'entrée de Groudon !
    north_keepout = ndimage.binary_dilation(
        rock_mask & (yy <= int(0.43 * h)) & (xx >= int(0.20 * w)) & (xx <= int(0.80 * w)),
        iterations=max(2, int(round(4 * sx))),
    )
    frames_09_raw = build_canonical_w04_embers_frames(w=w, h=h)
    frames_09_embers = []
    for im_e in frames_09_raw:
        arr_e = np.asarray(im_e, dtype=np.uint8).copy()
        arr_e[north_keepout] = 0
        frames_09_embers.append(Image.fromarray(arr_e, mode="RGBA"))

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
        LayerEntry("00_mer_caldeira_magma_dcp", "Mer Caldeira Magma Sombre DCP 1x", "BG", frames_00_sea, frame_length=10),
        LayerEntry("01_sol_basalte_continu", "Sol Volcanique Noir Continu", "BG", [Image.fromarray(arr_01_sol, "RGBA")], frame_length=5),
        LayerEntry("02_failles_sismiques_magma_dcp", "Failles Sismiques Sous-Marines DCP", "BG", frames_02_faults, frame_length=10),
        LayerEntry("03_rive_magma_visqueux_bordure", "Rive Magma Visqueux & Bordure Basse", "BG", frames_03_viscous_shore, frame_length=8),
        LayerEntry("04_plateau_et_pont_arene", "Plateau Cratere Noir & Pont Sud-Nord", "BG", [im_04_floor], frame_length=5),
        LayerEntry("05_rune_primo_groudon_sol", "Symbole Primo-Groudon Grave Pulsant", "BG", frames_05_rune, frame_length=10),
        LayerEntry("06_falaises_roche_noire_magma", "Couronne Nord & Falaises Basalte Noir", "BG", frames_06_rock_with_low_rim, frame_length=8),
        LayerEntry("07_lames_pangeennes_groudon", "Lames Pangeennes Jaillissantes Groudon", "BG", frames_07_blades, frame_length=5),
        LayerEntry("08_colonnes_geantes_magma_dcp", "Colonnes Geantes Ascendantes DCP", "BG", frames_08_cols, frame_length=5),
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
