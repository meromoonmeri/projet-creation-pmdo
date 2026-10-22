#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MME1 — Mine Magma — Entrée (`100 %` Roche Noire Magma Basalte/Obsidienne + `H26P01.bpl` `1×` + `#FF00FF`).

Cohérence géologique intégrale de l'entrée volcanique :
- **Fond rocheux & falaises `100 %` roche noire magma** : massif continu de basalte noir fumé,
  colonnes d'obsidienne, corniches et arche caverneuse monumentale (`donjon_seuil`) sans aucune
  roche ocre/jaune étrangère ni pavage incohérent en arrière-plan.
- **Chaussée Sud -> Nord** en dalles polygonales de basalte cendré bordée de crocs de pierre,
  identique aux matériaux canoniques de l'îlot de `H26P01` (`native_H26P01.png`).
- **Veines & gouffres de magma `100 %` Magenta `#FF00FF`** (`decor_entree_veines_magenta.png`),
  animés par le **vrai magma canonique `H26P01` `1×`** et son **palette cycling matériel `H26P01.bpl`**.
- **Zéro cascade et zéro petit volcan à l'entrée** : animation visqueuse de rive et de croûte de
  **bordure rocher** (`04_rive_magma_visqueux_bordure`, `15 × 8` ticks) partout où le magma touche la
  roche noire, couplée en phase à l'incandescence thermique de bordure rocher (`08_incandescence_rives_bpl`)
  et aux braises volcaniques `W04` (`Top`, `16 × 7` ticks).
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
    render_viscous_shoreline_border,
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
SOL_NOIR_RAW = RAW_DIR / "sol_basalte_noir_complet.png"
REF_DIR = HERE / "references"
ARENA_REF_DIR = REPO_ROOT / "source" / "mine_magma_arene_v1" / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "mine_magma_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_unified_black_magma_palette(decor_rgb: np.ndarray, rock_mask: np.ndarray) -> np.ndarray:
    """Construit la palette unifiée roche noire magma + dalles cendrées + magma canonique `H26P01`."""
    canon = extract_canonical_palette(
        [ARENA_REF_DIR / "native_H26P01.png"],
        max_colors=64,
        min_pixels=4,
    )
    rock_px = decor_rgb[rock_mask]
    uniq, cnt = np.unique(rock_px, axis=0, return_counts=True)
    top_rock = uniq[np.argsort(-cnt)[:96]]
    black_obsidian = np.array(
        [
            [8, 3, 3],
            [14, 5, 4],
            [22, 8, 6],
            [32, 14, 11],
            [44, 24, 19],
            [58, 36, 28],
        ],
        dtype=np.uint8,
    )
    return np.unique(np.vstack([canon, top_rock, black_obsidian]), axis=0).astype(np.uint8)


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    decor_raw = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    decor_rgb = np.asarray(decor_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    sol_raw = Image.open(SOL_NOIR_RAW).convert("RGB")
    sol_rgb = np.asarray(sol_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    min_chasm = max(500, int(round(3500 * (w * h) / float(W_CANON * H_CANON))))
    all_magenta, open_chasm, rock_veins = split_magenta_chasms_and_veins(
        decor_rgb, min_open_chasm_area=min_chasm
    )
    rock_mask = ~all_magenta

    volcanic_pal = build_unified_black_magma_palette(decor_rgb, rock_mask)
    q_decor = quantize_rgb_to_palette(decor_rgb, volcanic_pal)
    q_sol = quantize_rgb_to_palette(sol_rgb, volcanic_pal)

    yy, xx = np.mgrid[:h, :w]
    lum = (
        0.299 * decor_rgb[:, :, 0].astype(np.float32)
        + 0.587 * decor_rgb[:, :, 1].astype(np.float32)
        + 0.114 * decor_rgb[:, :, 2].astype(np.float32)
    )

    # 1. Intérieur noir profond de la bouche caverneuse Nord (`donjon_seuil`, conserve 100 % des stalactites noires !)
    mouth_box = (yy >= int(0.30 * h)) & (yy <= int(0.445 * h)) & (xx >= int(0.425 * w)) & (xx <= int(0.575 * w))
    cave_mouth = rock_mask & mouth_box & (decor_rgb.max(axis=2) <= 12)
    q_decor[cave_mouth] = np.array([8, 3, 3], dtype=np.uint8)

    # 2. Crocs de pierre clairs (`bone_fangs`) bordant la chaussée centrale
    bone_fangs = rock_mask & (decor_rgb[:, :, 0] >= 145)

    # 3. Chaussée praticable Sud -> Nord en dalles de basalte cendré (du bord Sud `y = h - 1` jusqu'au seuil `y ≈ 0.45 * h`)
    corridor_box = (
        ((yy >= int(0.445 * h)) & (xx >= int(0.40 * w)) & (xx <= int(0.60 * w)))
        | ((yy >= int(0.83 * h)) & (xx >= int(0.18 * w)) & (xx <= int(0.82 * w)))
    )
    slab_cand = (
        rock_mask
        & (~cave_mouth)
        & (~bone_fangs)
        & corridor_box
        & ((decor_rgb[:, :, 0] >= 75) | ((yy >= int(0.445 * h)) & (yy <= int(0.51 * h)) & (decor_rgb[:, :, 0] >= 22)))
    )
    slab_smooth = ndimage.binary_closing(slab_cand, iterations=max(2, int(round(5 * w / 768.0))))
    slab_smooth[h - max(3, int(round(8 * h / 576.0))) :, :] = (
        rock_mask[h - max(3, int(round(8 * h / 576.0))) :, :]
        & (~bone_fangs[h - max(3, int(round(8 * h / 576.0))) :, :])
        & corridor_box[h - max(3, int(round(8 * h / 576.0))) :, :]
        & (decor_rgb[h - max(3, int(round(8 * h / 576.0))) :, :, 0] >= 58)
    )
    lbl_p, _ = ndimage.label(slab_smooth)
    south_seed_labels = [
        lbl_id
        for lbl_id in set(lbl_p[h - 6 :, int(0.40 * w) : int(0.60 * w)].ravel().tolist())
        if lbl_id != 0
    ]
    walkable_causeway = np.isin(lbl_p, south_seed_labels) & rock_mask & (~cave_mouth) & (~bone_fangs) & corridor_box
    walkable_causeway = ndimage.binary_fill_holes(walkable_causeway) & rock_mask & (~cave_mouth) & (~all_magenta)

    # 4. Partition sémantique nette de l'ensemble du massif de roche noire magma :
    #    - `rim_and_fangs` : crocs de pierre clairs + rebords rocheux immédiats de la chaussée,
    #    - `arch_and_wall` : paroi montagneuse supérieure & arche caverneuse Nord (`y < 0.56 * h`),
    #    - `lower_cliffs`  : falaises abruptes de basalte noir surplombant les gouffres de magma.
    rim_px = max(2, int(round(5 * w / float(W_CANON))))
    rim_and_fangs = (
        rock_mask
        & (~walkable_causeway)
        & (~cave_mouth)
        & (bone_fangs | (ndimage.distance_transform_edt(~walkable_causeway) <= rim_px))
    )
    arch_and_wall = (
        (rock_mask & (~walkable_causeway) & (~rim_and_fangs) & (yy < int(0.56 * h)))
        | cave_mouth
    )
    lower_cliffs = rock_mask & (~walkable_causeway) & (~rim_and_fangs) & (~arch_and_wall)

    # 5. Couche 00 : Gouffres de magma canonique `H26P01` `1×` (palette cycling matériel `31 × 4` ticks)
    frames_00_sea = build_canonical_h26p01_magma_frames(w=w, h=h, mask=None, phase_offset=0)

    # 6. Couche 01 : Sol complet de basalte cendré continu (`sol_basalte_noir_complet.png`)
    arr_01_sol = np.zeros((h, w, 4), dtype=np.uint8)
    arr_01_sol[rock_mask, :3] = q_sol[rock_mask]
    arr_01_sol[rock_mask, 3] = 255

    # 7. Couche 02 : **Veines de magma dans la roche noire** (`#FF00FF` -> rivières ardentes `H26P01.bpl` `1×`)
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
    im_04_rim = _layer_from_mask(rim_and_fangs)
    im_05_cliffs = _layer_from_mask(lower_cliffs)
    im_06_arch = _layer_from_mask(arch_and_wall)

    # 8. Couche 07 : Incandescence thermique `H26P01.bpl` (`15 × 8` ticks) sur les bords de la roche noire
    full_rock_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    non_walk_rock = rock_mask & (~walkable_causeway) & (~cave_mouth)
    full_rock_rgba[non_walk_rock, :3] = q_decor[non_walk_rock]
    full_rock_rgba[non_walk_rock, 3] = 255
    frames_07_glow = build_h26p01_rim_glow_frames(full_rock_rgba, all_magenta)

    # 9. Couche 04 : Animation visqueuse de rive & croûte de bordure rocher (`15 × 8` ticks = `120` ticks)
    #    ZÉRO cascade à l'entrée (`retire les cascade a l'entrée`) ! Partout où le magma des gouffres
    #    touche la roche noire (`open_chasm`), le magma s'épaissit en plaques de croûte refroidies au
    #    contact du basalte, ondule visqueusement vers la rive et craque de fissures incandescentes !
    band_px = max(8.0, 24.0 * (w / float(W_CANON)))
    frames_04_viscous_shore = render_viscous_shoreline_border(
        open_chasm,
        n_frames=15,
        band_px=band_px,
    )

    # 10. Couche 09 (`Top`, `Layer = 4`) : Braises volcaniques `W04` `1×` natives (`16 × 7` ticks)
    frames_09_embers = build_canonical_w04_embers_frames(w=w, h=h)

    # 11. Grille de collision `96 × 72` : chaussée Sud -> Nord continue de `y = gh - 1` jusqu'au seuil de la grotte !
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
        LayerEntry("01_sol_basalte_noir_continu", "Sol Basalte Volcanique Continu", "BG", [Image.fromarray(arr_01_sol, "RGBA")], frame_length=5),
        LayerEntry("02_veines_magma_magenta_h26", "Veines Magma Decoupe Magenta H26P01.bpl", "BG", frames_02_veins, frame_length=4),
        LayerEntry("03_chaussee_praticable_sud_nord", "Chaussee Basalte Cendre Sud-Nord", "BG", [im_03_floor], frame_length=5),
        LayerEntry("04_rive_magma_visqueux_bordure", "Rive Magma Visqueux & Bordure Rocher", "BG", frames_04_viscous_shore, frame_length=8),
        LayerEntry("05_falaises_roche_noire_magma", "Falaises Basalte Noir & Surplombs", "BG", [im_05_cliffs], frame_length=5),
        LayerEntry("06_massif_et_arche_roche_noire", "Massif Roche Noire Magma & Arche Nord", "BG", [im_06_arch], frame_length=5),
        LayerEntry("07_crocs_et_rebords_chaussee", "Crocs Volcaniques & Rebords Chaussee", "BG", [im_04_rim], frame_length=5),
        LayerEntry("08_incandescence_rives_bpl", "Incandescence Bordure Rocher BPL", "BG", frames_07_glow, frame_length=8),
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
        canonical_ref_for_fidelity=REF_DIR / "native_h26p01_roche_noire_ref.png",
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
