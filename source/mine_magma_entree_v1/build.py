#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MME1 — Mine Magma — Entrée (`POV PMD` `d40p11a` + Roche Noire Sculptée + Mer de Magma Assombrie `d41p41a` `1×`).

Conformité stricte aux consignes utilisateur :
1. **Mer et lacs de magma & lave assombrie (`sea_darken=True`) restaurés dans les gouffres `#FF00FF`**
   en continuité exacte avec `MMA1` (*Arène de Groudon*) ;
2. **ZÉRO coulée de lave sur le massif rocheux et l'arche de l'entrée Nord** (`entrance_arch_box`) ;
3. **Rive visqueuse (`MME1_04`) strictement limitée aux rives basses (`low_waterline_bank`)** (`0` sur les pitons) ;
4. **Roche volcanique noire sculptée bien visible (`lum ≈ 35–39`)** + chaussée Sud -> Nord vers la grotte Nord (`#060505`).
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
    build_dark_crater_pit_magma_frames,
    build_dark_crater_rim_glow_frames,
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

MAP_ID = "MME1"
MAP_TITLE = "Mine Magma — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "decor_entree_veines_magenta.png"
SOL_NOIR_RAW = RAW_DIR / "sol_basalte_noir_complet.png"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "mine_magma_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_unified_dark_crater_black_palette(decor_rgb: np.ndarray, rock_mask: np.ndarray) -> np.ndarray:
    """Palette unifiée : roche noire volcanique sculptée (`POV PMD`) + cendre sombre + lave `Dark Crater Pit`."""
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

    sol_raw = Image.open(SOL_NOIR_RAW).convert("RGB")
    sol_rgb = np.asarray(sol_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    yy, xx = np.mgrid[:h, :w]
    min_chasm = max(500, int(round(3500 * (w * h) / float(W_CANON * H_CANON))))
    all_magenta, open_chasm, rock_veins_raw = split_magenta_chasms_and_veins(
        decor_rgb, min_open_chasm_area=min_chasm
    )
    raw_rock_mask = ~all_magenta

    # ZÉRO coulée de lave sur les parois rocheuses et l'arche d'entrée : seuls les deux grands lacs `#FF00FF` contiennent le magma !
    entrance_arch_box = (yy < int(0.45 * h)) & (xx >= int(0.28 * w)) & (xx <= int(0.72 * w))
    arch_clefts = rock_veins_raw
    rock_veins = np.zeros_like(open_chasm)
    active_magenta = open_chasm
    rock_mask = ~active_magenta

    volcanic_pal = build_unified_dark_crater_black_palette(decor_rgb, raw_rock_mask)
    q_decor = quantize_rgb_to_palette(decor_rgb, volcanic_pal)
    q_sol = quantize_rgb_to_palette(sol_rgb, volcanic_pal)
    q_decor[arch_clefts] = q_sol[arch_clefts]

    lum = (
        0.299 * decor_rgb[:, :, 0].astype(np.float32)
        + 0.587 * decor_rgb[:, :, 1].astype(np.float32)
        + 0.114 * decor_rgb[:, :, 2].astype(np.float32)
    )
    lum[arch_clefts] = 34.0

    # 1. Bouche caverneuse Nord (`donjon_seuil`, `POV PMD` de `d40p11a`)
    mouth_box = (yy >= int(0.16 * h)) & (yy <= int(0.41 * h)) & (xx >= int(0.40 * w)) & (xx <= int(0.60 * w))
    cave_mouth = raw_rock_mask & mouth_box & (decor_rgb.max(axis=2) <= 10)
    q_decor[cave_mouth] = np.array([6, 5, 5], dtype=np.uint8)

    # 2. Plateau praticable de cendre volcanique noire `POV PMD` (du Sud `y = h - 1` jusqu'à la grotte Nord !)
    L_smooth = ndimage.uniform_filter(lum, size=max(3, int(round(9 * w / 768.0))))
    ash_corridor = (
        ((yy >= int(0.32 * h)) & (xx >= int(0.36 * w)) & (xx <= int(0.64 * w)))
        | ((yy >= int(0.56 * h)) & (xx >= int(0.26 * w)) & (xx <= int(0.74 * w)))
        | ((yy >= int(0.76 * h)) & (xx >= int(0.11 * w)) & (xx <= int(0.89 * w)))
    )
    floor_cand = (
        rock_mask
        & (~cave_mouth)
        & ash_corridor
        & (L_smooth >= 31.0)
        & (~ndimage.binary_dilation(active_magenta, iterations=max(2, int(round(5 * w / 768.0)))))
    )
    floor_smooth = ndimage.binary_closing(floor_cand, iterations=max(2, int(round(5 * w / 768.0))))
    south_rows = max(3, int(round(8 * h / 576.0)))
    floor_smooth[h - south_rows :, :] = (
        rock_mask[h - south_rows :, :]
        & ash_corridor[h - south_rows :, :]
        & (L_smooth[h - south_rows :, :] >= 28.0)
    )
    lbl_p, _ = ndimage.label(floor_smooth)
    south_seed_labels = [
        lbl_id
        for lbl_id in set(lbl_p[h - 6 :, int(0.35 * w) : int(0.65 * w)].ravel().tolist())
        if lbl_id != 0
    ]
    walkable_causeway = np.isin(lbl_p, south_seed_labels) & rock_mask & (~cave_mouth) & (~active_magenta)
    walkable_causeway = ndimage.binary_fill_holes(walkable_causeway) & rock_mask & (~cave_mouth) & (~active_magenta)

    # 3. Partition sémantique `POV PMD` de toute la roche noire volcanique :
    lbl_rk, _ = ndimage.label(rock_mask)
    main_rk_ids = set(lbl_rk[0:20, :].ravel().tolist()) | set(lbl_rk[h - 10 :, :].ravel().tolist())
    sea_spires = rock_mask & (~np.isin(lbl_rk, list(main_rk_ids)))

    rim_px = max(2, int(round(5 * w / float(W_CANON))))
    rim_and_spires = (
        rock_mask
        & (~walkable_causeway)
        & (~cave_mouth)
        & (sea_spires | (ndimage.distance_transform_edt(~walkable_causeway) <= rim_px))
    )
    upper_crater = (
        (rock_mask & (~walkable_causeway) & (~rim_and_spires) & (yy < int(0.50 * h)))
        | cave_mouth
    )
    lower_cliffs = rock_mask & (~walkable_causeway) & (~rim_and_spires) & (~upper_crater)

    # 4. Couche 00 : Lacs de lave & magma canoniques `Dark Crater Pit` assombris (`sea_darken=True`, `12 × 10 = 120` ticks)
    frames_00_sea = build_dark_crater_pit_magma_frames(w=w, h=h, mask=None, phase_offset=0, sea_darken=True)

    # 5. Couche 01 : Sol complet de cendre volcanique noire continue (`sol_basalte_noir_complet.png`)
    arr_01_sol = np.zeros((h, w, 4), dtype=np.uint8)
    arr_01_sol[rock_mask, :3] = q_sol[rock_mask]
    arr_01_sol[rock_mask, 3] = 255

    # 6. Couche 02 : Courants magmatiques profonds au cœur des deux lacs latéraux `#FF00FF` (`0` veine sur les falaises !)
    inner_currents = ndimage.binary_erosion(open_chasm, iterations=max(4, int(round(14 * w / 768.0))))
    frames_02_veins = build_dark_crater_pit_magma_frames(
        w=w,
        h=h,
        mask=inner_currents,
        phase_offset=6,
        roll_xy=(32, 24),
        sea_darken=True,
    )

    # 7. Couche 04 : Rive visqueuse & croûte de bordure rocher `Dark Crater Pit` (`sea_darken=True`)
    #    Strictement limitée aux SEULES rives basses (`low_waterline_bank`) de la chaussée centrale :
    #    ZÉRO animation de rive sur les pitons pointus, parois hautes Nord et falaises latérales en hauteur !
    sx = w / float(W_CANON)
    dist_walk = ndimage.distance_transform_edt(~walkable_causeway)
    tall_vertical_cones = (
        sea_spires
        | (((xx < int(0.305 * w)) | (xx > int(0.695 * w))) & (L_smooth < 28.5))
    )
    low_waterline_bank = (
        rock_mask
        & (yy >= int(0.495 * h))
        & (xx >= int(0.145 * w))
        & (xx <= int(0.855 * w))
        & (dist_walk <= max(8.0, 28.0 * sx))
        & (~tall_vertical_cones)
    )
    shore_open_mask = ~low_waterline_bank

    band_px = max(11.0, 23.0 * sx)
    frames_04_raw = render_dark_crater_viscous_shoreline(
        shore_open_mask,
        n_frames=15,
        band_px=band_px,
        sea_darken=True,
    )
    frames_04_viscous_shore = []
    for im_s in frames_04_raw:
        arr_s = np.asarray(im_s, dtype=np.uint8).copy()
        arr_s[~open_chasm] = 0
        frames_04_viscous_shore.append(Image.fromarray(arr_s, mode="RGBA"))

    def _layer_from_mask(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_decor[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_03_floor = _layer_from_mask(walkable_causeway)
    im_05_cliffs = _layer_from_mask(lower_cliffs)
    im_06_arch = _layer_from_mask(upper_crater)
    im_07_spires = _layer_from_mask(rim_and_spires)

    # 8. Couche 08 : Incandescence thermique uniquement sur les rives basses & veines latérales (`0` sur l'arche Nord !)
    full_rock_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    non_walk_rock = rock_mask & (~walkable_causeway) & (~cave_mouth) & (~entrance_arch_box)
    full_rock_rgba[non_walk_rock, :3] = q_decor[non_walk_rock]
    full_rock_rgba[non_walk_rock, 3] = 255
    low_shore_contact = open_chasm & ndimage.binary_dilation(low_waterline_bank, iterations=2)
    frames_08_glow = build_dark_crater_rim_glow_frames(
        full_rock_rgba,
        low_shore_contact | rock_veins,
    )

    # 9. Couche 09 (`Top`, `Layer = 4`) : Braises volcaniques montantes `W04` `1×` (`16 × 7` ticks),
    #    masquées devant tout le massif d'arche Nord !
    cave_keepout = entrance_arch_box | ndimage.binary_dilation(cave_mouth, iterations=max(2, int(round(4 * sx))))
    frames_09_raw = build_canonical_w04_embers_frames(w=w, h=h)
    frames_09_embers = []
    for im_e in frames_09_raw:
        arr_e = np.asarray(im_e, dtype=np.uint8).copy()
        arr_e[cave_keepout] = 0
        frames_09_embers.append(Image.fromarray(arr_e, mode="RGBA"))

    # 10. Grille de collision `96 × 72` : large chaussée `POV PMD` continue du bord Sud jusqu'à la grotte Nord !
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_causeway[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            mag_blk = active_magenta[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = (float(blk.mean()) >= 0.65) and (not bool(mag_blk.any()))

    lbl_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        south_ids = set(lbl_w[-1, :].tolist()) - {0}
        if south_ids:
            walk_grid = np.isin(lbl_w, list(south_ids))

    layers = [
        LayerEntry("00_mer_et_gouffres_magma_dcp", "Lacs Magma Dark Crater Pit Assombris 1x", "BG", frames_00_sea, frame_length=10),
        LayerEntry("01_sol_basalte_noir_continu", "Sol Cendre & Basalte Noir Continu", "BG", [Image.fromarray(arr_01_sol, "RGBA")], frame_length=5),
        LayerEntry("02_veines_magma_magenta_dcp", "Fissures Magma Magenta Dark Crater Pit", "BG", frames_02_veins, frame_length=10),
        LayerEntry("03_chaussee_praticable_sud_nord", "Plateau Cendre Noire POV PMD Sud-Nord", "BG", [im_03_floor], frame_length=5),
        LayerEntry("04_rive_magma_visqueux_bordure", "Rive Magma Visqueux & Bordure Rocher", "BG", frames_04_viscous_shore, frame_length=8),
        LayerEntry("05_falaises_roche_noire_magma", "Parois Basalte Noir & Surplombs", "BG", [im_05_cliffs], frame_length=5),
        LayerEntry("06_massif_et_arche_roche_noire", "Massif Cratere Noir & Seuil Nord", "BG", [im_06_arch], frame_length=5),
        LayerEntry("07_pitons_et_rebords_roche_noire", "Pitons Obsidienne & Rebords Rocher", "BG", [im_07_spires], frame_length=5),
        LayerEntry("08_incandescence_rives_dcp", "Incandescence Bordure Rocher DCP", "BG", frames_08_glow, frame_length=8),
        LayerEntry("09_braises_volcaniques_w04_top", "Braises Volcaniques Canoniques W04", "Top", frames_09_embers, frame_length=7),
    ]
    return layers, walk_grid, volcanic_pal


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    h = max(64, int(round(H_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    layers, walk_grid, _ = build_layers_for_size(w, h)
    # Met à jour la référence canonique locale d'entrée avec mer de magma assombrie & roche noire relevée
    if output_override is None:
        comp = np.zeros((h, w, 4), dtype=np.uint8)
        for lyr in layers:
            fr = np.asarray(lyr.frames[0], dtype=np.uint8)
            nz = fr[:, :, 3] > 0
            comp[nz] = fr[nz]
        Image.fromarray(comp[:, :, :3], mode="RGB").save(REF_DIR / "dark_crater_entree_ref.png")
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=REF_DIR / "dark_crater_entree_ref.png",
        max_fidelity_distance=30.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mine_magma_mme1",
        asset_name_override="mine_magma_entree",
    )
    meta["width"] = w
    meta["height"] = h
    return meta


def main() -> None:
    meta = build()
    print(json.dumps(meta, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
