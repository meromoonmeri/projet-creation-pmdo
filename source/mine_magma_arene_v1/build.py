#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MMA1 — Mine Magma — Arène de Groudon (`H26P01` `1×` + `H26P01.bpl` Palette Cycling + Veines `#FF00FF`).

Architecture canonique + découpe magenta `#FF00FF` stricte (ZÉRO mini-volcan !) :
- `MMA1_00` (`BG`, `31` phases @ `4` ticks = `124` ticks) : Mer caldeira de magma canonique `H26P01`
  à l'échelle `1×` native avec animation matérielle `H26P01.bpl` (palettes `5, 6, 7, 8`) ;
- `MMA1_01` (`BG`, `1` pose) : Sol basaltique polygonal continu (`sol_pavage_basalte_complet.png`) ;
- `MMA1_02` (`BG`, `31` phases @ `4` ticks = `124` ticks) : **Veines & cratères de magma détourés depuis `#FF00FF`**
  dans le cirque volcanique, les falaises et les contreforts (`decor_arene_veines_magenta.png` -> `H26P01.bpl` `1×`) ;
- `MMA1_03` (`BG`, `1` pose) : Plateau praticable de l'arène de boss & pont Sud -> Nord unifié ;
- `MMA1_04` (`BG`, `1` pose) : Rebords rocheux et crocs de pierre bordant le pont et l'arène ;
- `MMA1_05` (`BG`, `1` pose) : Contreforts basaltiques sombres & éperons de lave refroidie ;
- `MMA1_06` (`BG`, `1` pose) : Cirque monumental d'orgues dorées & couronne de crocs Nord ;
- `MMA1_07` (`BG`, `15` phases @ `8` ticks = `120` ticks) : Incandescence thermique des parois & veines (`H26P01.bpl` pal `0`) ;
- `MMA1_08` (`BG`, `8` phases @ `3` ticks = `24` ticks) : Grande cascade de lave Nord & colonnes cylindriques
  canoniques `H26P01` `1×` (`pal 4`) tombant du plafond dans la mer de magma (ZÉRO mini-volcan !) ;
- `MMA1_09` (`Top`, `16` phases @ `7` ticks = `112` ticks) : Braises volcaniques ascendantes `W04` `1×` natives.
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
    extract_canonical_h26p01_pillar_module,
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

MAP_ID = "MMA1"
MAP_TITLE = "Mine Magma — Arène de Groudon"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "decor_arene_veines_magenta.png"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "mine_magma_arene_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_unified_arena_palette(decor_rgb: np.ndarray, rock_mask: np.ndarray) -> np.ndarray:
    canon = extract_canonical_palette(
        [
            REF_DIR / "native_H26P01.png",
            REF_DIR / "b70_groudon_boss_arena.png",
        ],
        max_colors=88,
        min_pixels=4,
    )
    rock_px = decor_rgb[rock_mask]
    uniq, cnt = np.unique(rock_px, axis=0, return_counts=True)
    top_rock = uniq[np.argsort(-cnt)[:72]]
    return np.unique(np.vstack([canon, top_rock]), axis=0).astype(np.uint8)


def _render_north_breach_waterfall_and_sea_pillars(
    w: int,
    h: int,
    open_chasm: np.ndarray,
    north_breach_mask: np.ndarray,
) -> List[Image.Image]:
    """Combine dans une seule piste matérielle `8` frames × `3` ticks (`H26P01` palette `4`, `1×`) :
    1. Les 4 grandes colonnes cylindriques canoniques `H26P01` tombant du bord haut `y = 0`
       dans la mer de magma ouverte à gauche et à droite (exactement comme `native_H26P01.png`,
       ZÉRO petit volcan !),
    2. La grande cascade centrale Nord rugissant à travers la brèche magenta du bastion Nord
       jusqu'à son bouillonnement au pied de la falaise !"""
    sx = w / float(W_CANON)
    sy = h / float(H_CANON)
    sea_specs = [
        {"variant": "medium", "cx": int(round(36 * sx)), "top_y": 0, "base_y": int(round(148 * sy)), "phase": 2, "mirror": False},
        {"variant": "large", "cx": int(round(84 * sx)), "top_y": 0, "base_y": int(round(244 * sy)), "phase": 0, "mirror": False},
        {"variant": "large", "cx": int(round(684 * sx)), "top_y": 0, "base_y": int(round(244 * sy)), "phase": 5, "mirror": True},
        {"variant": "medium", "cx": int(round(732 * sx)), "top_y": 0, "base_y": int(round(148 * sy)), "phase": 7, "mirror": True},
        {"variant": "large", "cx": int(round(136 * sx)), "top_y": int(round(336 * sy)), "base_y": int(round(524 * sy)), "phase": 3, "mirror": False},
        {"variant": "large", "cx": int(round(640 * sx)), "top_y": int(round(336 * sy)), "base_y": int(round(524 * sy)), "phase": 6, "mirror": True},
    ]
    pillar_imgs = render_extended_canonical_pillars(
        w=w,
        h=h,
        specs=sea_specs,
        open_magma_mask=open_chasm if w >= 768 else None,
    )

    # Remplit également la grande brèche de cascade Nord (`north_breach_mask`) avec le fût `1×`
    # `H26P01` palette `4` juxtaposé sans couture + bassin d'écume en bas de la brèche !
    ys_b, xs_b = np.where(north_breach_mask)
    if ys_b.size < 32:
        return pillar_imgs

    bx0, bx1 = int(xs_b.min()), int(xs_b.max()) + 1
    by0, by1 = int(ys_b.min()), int(ys_b.max()) + 1
    bw_slot = bx1 - bx0
    bh_slot = by1 - by0

    mod_large = extract_canonical_h26p01_pillar_module("large")  # 48 px de large, cœur doré x = 8..40 (`32 px`)
    out_frames: List[Image.Image] = []
    for f in range(8):
        arr = np.asarray(pillar_imgs[f], dtype=np.uint8).copy()
        src_f = mod_large[(f + 1) % 8]
        core_strip = src_f[8:24, 8:40, :3]  # 16 × 32 px de pure coulée d'or `palette 4` !
        reps_y = bh_slot // 16 + 2
        reps_x = bw_slot // 32 + 2
        fall_rgb = np.tile(core_strip, (reps_y, reps_x, 1))[:bh_slot, :bw_slot, :]

        # Pied bouillonnant en bas de la chute (`foot_rows = 28 px`)
        foot_rows = min(28, bh_slot // 2)
        foot_src = src_f[-foot_rows:, :, :]
        foot_resized = np.asarray(
            Image.fromarray(foot_src, mode="RGBA").resize((bw_slot, foot_rows), Image.Resampling.NEAREST),
            dtype=np.uint8,
        )
        m_foot = foot_resized[:, :, 3] > 0
        fall_rgb[-foot_rows:, :][m_foot] = foot_resized[:, :, :3][m_foot]

        slot_sub = north_breach_mask[by0:by1, bx0:bx1]
        arr[by0:by1, bx0:bx1, :3][slot_sub] = fall_rgb[slot_sub]
        arr[by0:by1, bx0:bx1, 3][slot_sub] = 255
        out_frames.append(Image.fromarray(arr, mode="RGBA"))

    return out_frames


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    decor_raw = Image.open(RAW_DIR / "decor_arene_veines_magenta.png").convert("RGB")
    decor_rgb = np.asarray(decor_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    sol_raw = Image.open(RAW_DIR / "sol_pavage_basalte_complet.png").convert("RGB")
    sol_rgb = np.asarray(sol_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    min_chasm = max(500, int(round(6000 * (w * h) / float(W_CANON * H_CANON))))
    all_magenta, open_chasm_raw, rock_veins_raw = split_magenta_chasms_and_veins(
        decor_rgb, min_open_chasm_area=min_chasm
    )
    rock_mask = ~all_magenta

    # Identifie la brèche centrale de la cascade Nord (`x ∈ [0.42*w, 0.58*w], y ∈ [0.05*h, 0.37*h]`)
    yy, xx = np.mgrid[:h, :w]
    breach_box = (xx >= int(0.42 * w)) & (xx <= int(0.58 * w)) & (yy >= int(0.05 * h)) & (yy <= int(0.365 * h))
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
    sat = (
        np.maximum(np.maximum(decor_rgb[:, :, 0], decor_rgb[:, :, 1]), decor_rgb[:, :, 2]).astype(np.float32)
        - np.minimum(np.minimum(decor_rgb[:, :, 0], decor_rgb[:, :, 1]), decor_rgb[:, :, 2]).astype(np.float32)
    )

    # 1. Plateau d'arène central & pont Sud -> Nord praticable :
    #    exclut les orgues dorées (`sat >= 102`), les crocs de pierre clairs (`lum >= 126`) et les parois noires (`lum < 42`)
    paver_cand = (
        rock_mask
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
    walkable_arena_floor = np.isin(lbl_p, south_seed_labels) & rock_mask
    walkable_arena_floor = ndimage.binary_fill_holes(walkable_arena_floor) & rock_mask & (~all_magenta)

    # 2. Séparation sémantique nette des reliefs de l'arène :
    #    - `fangs_and_rim` : crocs de pierre clairs (`lum >= 128`) + rebord immédiat du plateau/pont,
    #    - `upper_crown`   : amphithéâtre d'orgues dorées du cirque Nord (`sat >= 70` ou `y < 0.48 * h`),
    #    - `dark_buttress` : contreforts d'obsidienne sombre et éperons côtiers (`reste`).
    rim_px = max(2, int(round(5 * w / float(W_CANON))))
    fangs_and_rim = (
        rock_mask
        & (~walkable_arena_floor)
        & ((lum >= 128.0) | (ndimage.distance_transform_edt(~walkable_arena_floor) <= rim_px))
    )
    upper_crown = (
        rock_mask
        & (~walkable_arena_floor)
        & (~fangs_and_rim)
        & ((sat >= 68.0) | (yy < int(0.46 * h)))
    )
    dark_buttress = rock_mask & (~walkable_arena_floor) & (~fangs_and_rim) & (~upper_crown)

    # 3. Couche 00 : Mer caldeira de magma canonique `H26P01` `1×` (`31` phases @ `4` ticks)
    frames_00_sea = build_canonical_h26p01_magma_frames(w=w, h=h, mask=None, phase_offset=0)

    # 4. Couche 01 : Sol basaltique complet sous toute l'île et le pont (`~all_magenta`)
    arr_01_sol = np.zeros((h, w, 4), dtype=np.uint8)
    arr_01_sol[rock_mask, :3] = q_sol[rock_mask]
    arr_01_sol[rock_mask, 3] = 255

    # 5. Couche 02 : **Veines & cratères de magma détourés depuis `#FF00FF`** (`H26P01` `1×` `31 × 4` ticks)
    veins_mask = ndimage.binary_dilation(rock_veins, iterations=1) & all_magenta
    frames_02_veins = build_canonical_h26p01_magma_frames(
        w=w,
        h=h,
        mask=veins_mask,
        phase_offset=11,
        index_roll=(32, 24),
        pure_molten_only=True,
    )

    def _layer_from_mask(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_decor[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_03_floor = _layer_from_mask(walkable_arena_floor)
    im_04_fangs = _layer_from_mask(fangs_and_rim)
    im_05_buttress = _layer_from_mask(dark_buttress)
    im_06_crown = _layer_from_mask(upper_crown)

    # 6. Couche 07 : Incandescence thermique `H26P01.bpl` (`15 × 8` ticks) le long des parois & veines
    full_rock_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    non_walk_rock = rock_mask & (~walkable_arena_floor)
    full_rock_rgba[non_walk_rock, :3] = q_decor[non_walk_rock]
    full_rock_rgba[non_walk_rock, 3] = 255
    frames_07_glow = build_h26p01_rim_glow_frames(full_rock_rgba, all_magenta)

    # 7. Couche 08 : Cascade centrale Nord + Colonnes cylindriques canoniques `H26P01` `1×` (`8 × 3` ticks)
    frames_08_falls_and_pillars = _render_north_breach_waterfall_and_sea_pillars(
        w=w,
        h=h,
        open_chasm=open_chasm,
        north_breach_mask=north_breach_mask,
    )

    # 8. Couche 09 (`Top`, `Layer = 4`) : Braises volcaniques `W04` `1×` natives (`16 × 7` ticks)
    frames_09_embers = build_canonical_w04_embers_frames(w=w, h=h)

    # 9. Grille de collision `96 × 72` : pont praticable continu Sud (`y = gh - 1`) -> grand plateau de Groudon !
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_arena_floor[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            mag_blk = all_magenta[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = (float(blk.mean()) >= 0.65) and (not bool(mag_blk.any()))

    lbl_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        south_ids = set(lbl_w[-1, :].tolist()) - {0}
        if south_ids:
            walk_grid = np.isin(lbl_w, list(south_ids))

    layers = [
        LayerEntry("00_mer_caldeira_magma_h26", "Mer Caldeira Magma Canonique H26P01.bpl", "BG", frames_00_sea, frame_length=4),
        LayerEntry("01_sol_basalte_continu", "Sol Basalte Volcanique Continu", "BG", [Image.fromarray(arr_01_sol, "RGBA")], frame_length=5),
        LayerEntry("02_veines_magma_magenta_h26", "Veines Magma Decoupe Magenta H26P01.bpl", "BG", frames_02_veins, frame_length=4),
        LayerEntry("03_plateau_et_pont_arene", "Plateau Boss Groudon & Pont Sud-Nord", "BG", [im_03_floor], frame_length=5),
        LayerEntry("04_crocs_et_rebords_arene", "Crocs Volcaniques & Rebords Pont", "BG", [im_04_fangs], frame_length=5),
        LayerEntry("05_contreforts_obsidienne", "Contreforts Basalte & Rives Croute", "BG", [im_05_buttress], frame_length=5),
        LayerEntry("06_cirque_orgues_couronne_nord", "Cirque Orgues Basaltiques Nord", "BG", [im_06_crown], frame_length=5),
        LayerEntry("07_incandescence_parois_bpl", "Incandescence Thermique Parois BPL", "BG", frames_07_glow, frame_length=8),
        LayerEntry("08_cascade_nord_et_colonnes_h26", "Cascade Nord & Colonnes Lave H26P01.bpl", "BG", frames_08_falls_and_pillars, frame_length=3),
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
        canonical_ref_for_fidelity=REF_DIR / "native_H26P01.png",
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
