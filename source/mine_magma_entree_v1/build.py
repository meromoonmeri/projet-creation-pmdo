#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MME1 — Mine Magma — Entrée (`H26P01` `1×` + Palette Cycling matériel `H26P01.bpl` + Veines `#FF00FF`).

Architecture canonique + découpe magenta `#FF00FF` stricte :
- `MME1_00` (`BG`, `31` phases @ `4` ticks = `124` ticks) : Nappe & gouffres de magma canonique `H26P01`
  à l'échelle `1×` native avec animation matérielle `H26P01.bpl` (palettes `5, 6, 7, 8`) ;
- `MME1_01` (`BG`, `1` pose) : Sol basaltique polygonal continu (`sol_pavage_basalte_complet.png`) ;
- `MME1_02` (`BG`, `31` phases @ `4` ticks = `124` ticks) : **Veines de magma détourées depuis `#FF00FF`**
  dans les parois, l'arche et les terrasses (`decor_entree_veines_magenta.png` -> `H26P01.bpl` `1×`) ;
- `MME1_03` (`BG`, `1` pose) : Chaussée praticable Sud -> Nord en dalles volcaniques polygonales ;
- `MME1_04` (`BG`, `1` pose) : Rebords de chaussée et corniches basaltiques ;
- `MME1_05` (`BG`, `1` pose) : Parois d'orgues basaltiques et terrasses volcaniques latérales ;
- `MME1_06` (`BG`, `1` pose) : Dôme montagneux & arche caverneuse Nord (`donjon_seuil`) ;
- `MME1_07` (`BG`, `15` phases @ `8` ticks = `120` ticks) : Incandescence thermique des rives & fissures (`H26P01.bpl` pal `0`) ;
- `MME1_08` (`BG`, `8` phases @ `3` ticks = `24` ticks) : Cascades cylindriques de lave `H26P01` `1×` (`pal 4`)
  se jetant dans les gouffres SO et SE (zéro mini-volcan !) ;
- `MME1_09` (`Top`, `16` phases @ `7` ticks = `112` ticks) : Braises volcaniques ascendantes `W04` `1×` natives.
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
    build_canonical_h26p01_magma_frames,
    build_canonical_w04_embers_frames,
    build_h26p01_rim_glow_frames,
    render_extended_canonical_pillars,
    split_magenta_chasms_and_veins,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
    extract_canonical_palette,
    quantize_rgb_to_palette,
)

MAP_ID = "MME1"
MAP_TITLE = "Mine Magma — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "decor_entree_veines_magenta.png"
REF_DIR = HERE / "references"
ARENA_RAW_DIR = REPO_ROOT / "source" / "mine_magma_arene_v1" / "bruts"
ARENA_REF_DIR = REPO_ROOT / "source" / "mine_magma_arene_v1" / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "mine_magma_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_unified_volcanic_palette(decor_rgb: np.ndarray, rock_mask: np.ndarray) -> np.ndarray:
    canon = extract_canonical_palette(
        [
            REF_DIR / "d12p01_magma_cavern_entrance.png",
            ARENA_REF_DIR / "native_H26P01.png",
        ],
        max_colors=88,
        min_pixels=4,
    )
    rock_px = decor_rgb[rock_mask]
    uniq, cnt = np.unique(rock_px, axis=0, return_counts=True)
    top_rock = uniq[np.argsort(-cnt)[:72]]
    cave_darks = np.array([[0, 0, 0], [10, 3, 2], [22, 6, 4], [36, 11, 6]], dtype=np.uint8)
    return np.unique(np.vstack([canon, top_rock, cave_darks]), axis=0).astype(np.uint8)


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    decor_raw = Image.open(RAW_DIR / "decor_entree_veines_magenta.png").convert("RGB")
    decor_rgb = np.asarray(decor_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    sol_raw = Image.open(ARENA_RAW_DIR / "sol_pavage_basalte_complet.png").convert("RGB")
    sol_rgb = np.asarray(sol_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    min_chasm = max(400, int(round(4500 * (w * h) / float(W_CANON * H_CANON))))
    all_magenta, open_chasm, rock_veins = split_magenta_chasms_and_veins(decor_rgb, min_open_chasm_area=min_chasm)
    rock_mask = ~all_magenta

    volcanic_pal = build_unified_volcanic_palette(decor_rgb, rock_mask)
    q_decor = quantize_rgb_to_palette(decor_rgb, volcanic_pal)
    q_sol = quantize_rgb_to_palette(sol_rgb, volcanic_pal)

    yy, xx = np.mgrid[:h, :w]
    lum = (
        0.299 * decor_rgb[:, :, 0].astype(np.float32)
        + 0.587 * decor_rgb[:, :, 1].astype(np.float32)
        + 0.114 * decor_rgb[:, :, 2].astype(np.float32)
    )
    sat = (
        np.maximum(np.maximum(decor_rgb[:, :, 0], decor_rgb[:, :, 1]), decor_rgb[:, :, 2]).astype(np.float32)
        - np.minimum(np.minimum(decor_rgb[:, :, 0], decor_rgb[:, :, 1]), decor_rgb[:, :, 2]).astype(np.float32)
    )

    # 1. Bouche sombre de l'arche caverneuse Nord (`donjon_seuil`)
    mouth_box = (yy >= int(0.12 * h)) & (yy <= int(0.33 * h)) & (xx >= int(0.43 * w)) & (xx <= int(0.57 * w))
    cave_mouth_seed = mouth_box & (lum < 78.0) & (sat < 55.0)
    cave_mouth = ndimage.binary_fill_holes(ndimage.binary_closing(cave_mouth_seed, iterations=3))
    rock_mask = rock_mask | cave_mouth
    q_decor[cave_mouth] = np.array([10, 2, 2], dtype=np.uint8)

    # 2. Chaussée praticable centrale Sud -> Nord (composante connexe de pavage brun partant du bord Sud `y = h - 1`)
    #    Les parois d'orgues dorées (`sat >= 105`) et les parois verticales sombres (`lum < 38`) sont exclues !
    paver_cand = (
        rock_mask
        & (~cave_mouth)
        & (yy >= int(0.35 * h))
        & (sat < 102.0)
        & (lum >= 42.0)
        & (lum < 126.0)
        & (~ndimage.binary_dilation(all_magenta, iterations=max(1, w // 384)))
    )
    paver_smooth = ndimage.binary_closing(
        paver_cand, iterations=max(2, int(round(4 * w / 768.0))), border_value=1
    )
    paver_smooth = ndimage.binary_opening(
        paver_smooth, iterations=max(1, int(round(2 * w / 768.0))), border_value=1
    )
    lbl_p, n_p = ndimage.label(paver_smooth)
    south_seed_labels = [
        lbl_id
        for lbl_id in set(lbl_p[h - 14 :, int(0.28 * w) : int(0.72 * w)].ravel().tolist())
        if lbl_id != 0
    ]
    walkable_causeway = np.isin(lbl_p, south_seed_labels) & rock_mask & (~cave_mouth) & (yy >= int(0.35 * h))
    walkable_causeway = ndimage.binary_fill_holes(walkable_causeway) & rock_mask & (~cave_mouth) & (~all_magenta)

    # 3. Séparation sémantique nette des reliefs rocheux :
    #    - `rim_mask`  : bordure immédiate de la chaussée (`<= 5 px`),
    #    - `arch_mask` : massif montagneux & arche caverneuse Nord (`cave_mouth` + dôme central haut),
    #    - `cliff_mask`: falaises d'orgues basaltiques et terrasses volcaniques latérales.
    rim_px = max(2, int(round(5 * w / float(W_CANON))))
    rim_mask = rock_mask & (~walkable_causeway) & (~cave_mouth) & (ndimage.distance_transform_edt(~walkable_causeway) <= rim_px)
    dome_region = (yy < int(0.52 * h)) & (xx >= int(0.18 * w)) & (xx <= int(0.82 * w)) & ((sat >= 72.0) | cave_mouth | (yy < int(0.34 * h)))
    arch_mask = (rock_mask & (~walkable_causeway) & (~rim_mask) & dome_region) | cave_mouth
    cliff_mask = rock_mask & (~walkable_causeway) & (~rim_mask) & (~arch_mask)

    # 4. Couche 00 : Nappe & gouffres de magma canonique `H26P01` `1×` (palette cycling matériel `31 × 4` ticks)
    #    Couvre tout le fond sous les gouffres ET sous les veines pour zéro trou d'occlusion !
    frames_00_sea = build_canonical_h26p01_magma_frames(w=w, h=h, mask=None, phase_offset=0)

    # 5. Couche 01 : Sol basaltique complet sous toute la roche (`~all_magenta`)
    arr_01_sol = np.zeros((h, w, 4), dtype=np.uint8)
    arr_01_sol[rock_mask, :3] = q_sol[rock_mask]
    arr_01_sol[rock_mask, 3] = 255

    # 6. Couche 02 : **Veines de magma dans la roche** (découpe exacte des fissures `#FF00FF` de `decor_entree_veines_magenta.png`
    #    animées par la vraie texture canonique `H26P01` + `H26P01.bpl` décalée de `+9` phases pour un relief vivant !)
    veins_dilated = ndimage.binary_dilation(rock_veins, iterations=1) & all_magenta
    frames_02_veins = build_canonical_h26p01_magma_frames(
        w=w,
        h=h,
        mask=veins_dilated,
        phase_offset=9,
        index_roll=(24, 16),
        pure_molten_only=True,
    )

    def _layer_from_mask(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_decor[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_03_floor = _layer_from_mask(walkable_causeway)
    im_04_rim = _layer_from_mask(rim_mask)
    im_05_cliffs = _layer_from_mask(cliff_mask)
    im_06_arch = _layer_from_mask(arch_mask)

    # 7. Couche 07 : Incandescence thermique `H26P01.bpl` (palette `0`, `15 × 8` ticks) au bord des veines & gouffres
    full_rock_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    non_walk_rock = rock_mask & (~walkable_causeway)
    full_rock_rgba[non_walk_rock, :3] = q_decor[non_walk_rock]
    full_rock_rgba[non_walk_rock, 3] = 255
    frames_07_glow = build_h26p01_rim_glow_frames(full_rock_rgba, all_magenta)

    # 8. Couche 08 : Cascades cylindriques de lave `H26P01` `1×` (`palette 4`, `8 × 3` ticks)
    #    jaillissant sous l'aplomb des falaises SO et SE (`top_y = 336`, ZÉRO débordement sur le haut des orgues !)
    sx = w / float(W_CANON)
    sy = h / float(H_CANON)
    pillar_specs = [
        {"variant": "large", "cx": int(round(136 * sx)), "top_y": int(round(336 * sy)), "base_y": int(round(516 * sy)), "phase": 0, "mirror": False},
        {"variant": "large", "cx": int(round(640 * sx)), "top_y": int(round(336 * sy)), "base_y": int(round(516 * sy)), "phase": 4, "mirror": True},
    ]
    frames_08_pillars = render_extended_canonical_pillars(
        w=w,
        h=h,
        specs=pillar_specs,
        open_magma_mask=open_chasm if w >= 768 else None,
    )

    # 9. Couche 09 (`Top`, `Layer = 4`) : Braises volcaniques `W04` `1×` natives (`16 × 7` ticks)
    frames_09_embers = build_canonical_w04_embers_frames(w=w, h=h)

    # 10. Grille de collision `96 × 72` : chemin praticable continu du bord Sud (`y = gh - 1`) jusqu'au seuil de la grotte !
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_causeway[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            mag_blk = all_magenta[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = (float(blk.mean()) >= 0.65) and (not bool(mag_blk.any()))

    lbl_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        south_ids = set(lbl_w[-1, :].tolist()) - {0}
        if south_ids:
            walk_grid = np.isin(lbl_w, list(south_ids))

    layers = [
        LayerEntry("00_mer_et_gouffres_magma_h26", "Gouffres Magma Canonique H26P01.bpl", "BG", frames_00_sea, frame_length=4),
        LayerEntry("01_sol_basalte_continu", "Sol Basalte Volcanique Continu", "BG", [Image.fromarray(arr_01_sol, "RGBA")], frame_length=5),
        LayerEntry("02_veines_magma_magenta_h26", "Veines Magma Decoupe Magenta H26P01.bpl", "BG", frames_02_veins, frame_length=4),
        LayerEntry("03_chaussee_praticable_sud_nord", "Chaussee Pavage Basalte Sud-Nord", "BG", [im_03_floor], frame_length=5),
        LayerEntry("04_rebords_chaussee_volcanique", "Rebords & Corniches Chaussee", "BG", [im_04_rim], frame_length=5),
        LayerEntry("05_parois_orgues_basaltiques", "Parois Orgues Basaltiques & Terrasses", "BG", [im_05_cliffs], frame_length=5),
        LayerEntry("06_dome_et_arche_entree_grotte", "Dome Volcanique & Arche Grotte Nord", "BG", [im_06_arch], frame_length=5),
        LayerEntry("07_incandescence_rives_bpl", "Incandescence Thermique Parois BPL", "BG", frames_07_glow, frame_length=8),
        LayerEntry("08_cascades_lave_gouffres_h26", "Cascades Lave Gouffres H26P01.bpl", "BG", frames_08_pillars, frame_length=3),
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
        canonical_ref_for_fidelity=ARENA_REF_DIR / "native_H26P01.png",
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
