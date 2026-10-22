#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MMA1 — Mine Magma — Arène de Groudon (`100 %` Roche Noire Magma + `H26P01.bpl` `1×` + Rive Visqueuse + `#FF00FF`).

Continuité géologique et chromatique `100 %` avec `MME1` (`CONTINUITE.md`) :
- `MMA1_00` (`BG`, `31` phases @ `4` ticks = `124` ticks) : Mer caldeira de magma canonique `H26P01` `1×`
  avec palette cycling matériel exact `H26P01.bpl` (palettes `5, 6, 7, 8`) ;
- `MMA1_01` (`BG`, `1` pose) : Sol basaltique sombre continu sans couture (`sol_pavage_basalte_complet.png`) ;
- `MMA1_02` (`BG`, `31` phases @ `4` ticks = `124` ticks) : **Veines de magma détourées depuis `#FF00FF`**
  dans le massif de roche noire magma et les flancs de l'île (`decor_arene_veines_magenta.png` -> `H26P01.bpl` `1×`) ;
- `MMA1_03` (`BG`, `15` phases @ `8` ticks = `120` ticks) : **Animation visqueuse de rive & croûte de
  bordure rocher** (`render_viscous_shoreline_border`, `0` damier, collerette de croûte figée + radeaux
  cellulaires Worley + rides visqueuses roulant vers chaque paroi rocheuse) ;
- `MMA1_04` (`BG`, `8` phases @ `3` ticks = `24` ticks) : Grande cascade de lave Nord sous l'arche pointue
  + 4 colonnes cylindriques canoniques `H26P01` `1×` (`pal 4`) jaillissant sous les surplombs de basalte noir
  dans la mer caldeira (ZÉRO mini-volcan !) ;
- `MMA1_05` (`BG`, `1` pose) : Grand plateau radial de boss de Groudon & pont Sud -> Nord praticable ;
- `MMA1_06` (`BG`, `1` pose) : Falaises basses & éperons de basalte noir magma ;
- `MMA1_07` (`BG`, `1` pose) : Couronne monumentale d'orgues de roche noire magma, arche Nord & crocs d'ivoire ;
- `MMA1_08` (`BG`, `15` phases @ `8` ticks = `120` ticks) : Incandescence thermique de bordure rocher (`H26P01.bpl`) ;
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

MAP_ID = "MMA1"
MAP_TITLE = "Mine Magma — Arène de Groudon"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "decor_arene_veines_magenta.png"
REF_DIR = HERE / "references"
ENTREE_REF_DIR = REPO_ROOT / "source" / "mine_magma_entree_v1" / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "mine_magma_arene_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_unified_arena_palette(decor_rgb: np.ndarray, rock_mask: np.ndarray) -> np.ndarray:
    """Palette unifiée 100 % cohérente avec `MME1` : basalte noir fumé + dalles cendrées + `H26P01`."""
    canon = extract_canonical_palette(
        [REF_DIR / "native_H26P01.png"],
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


def _render_north_arch_waterfall_and_sea_pillars(
    w: int,
    h: int,
    open_chasm: np.ndarray,
    north_breach_mask: np.ndarray,
) -> List[Image.Image]:
    """Combine dans une seule piste matérielle `8` frames × `3` ticks (`H26P01` palette `4`, `1×`)
    placée SOUS les falaises et la couronne de roche noire magma (`occlusion 3D naturelle` !) :
    1. Les 4 colonnes cylindriques canoniques `H26P01` jaillissant exactement sous le rebord dentelé
       des surplombs de basalte noir à l'Ouest (`cx = 44, 98`) et à l'Est (`cx = 668, 724`) sans
       jamais transparaître à travers les veines rocheuses supérieures (`open_magma_mask = open_chasm`),
    2. La grande cascade centrale Nord rugissant strictement à l'intérieur de la cavité fermée de
       l'arche pointue de basalte noir (`north_breach_mask` connexe) derrière les crocs Nord !"""
    sx = w / float(W_CANON)
    sy = h / float(H_CANON)
    sea_specs = [
        {"variant": "medium", "cx": int(round(44 * sx)), "top_y": int(round(140 * sy)), "base_y": int(round(344 * sy)), "phase": 2, "mirror": False},
        {"variant": "large", "cx": int(round(98 * sx)), "top_y": int(round(136 * sy)), "base_y": int(round(488 * sy)), "phase": 0, "mirror": False},
        {"variant": "large", "cx": int(round(668 * sx)), "top_y": int(round(184 * sy)), "base_y": int(round(502 * sy)), "phase": 5, "mirror": True},
        {"variant": "medium", "cx": int(round(724 * sx)), "top_y": int(round(196 * sy)), "base_y": int(round(384 * sy)), "phase": 7, "mirror": True},
    ]
    pillar_imgs = render_extended_canonical_pillars(
        w=w,
        h=h,
        specs=sea_specs,
        open_magma_mask=open_chasm,
    )

    ys_b, xs_b = np.where(north_breach_mask)
    if ys_b.size < 32:
        return pillar_imgs

    bx0, bx1 = int(xs_b.min()), int(xs_b.max()) + 1
    by0, by1 = int(ys_b.min()), int(ys_b.max()) + 1
    bw_slot = bx1 - bx0
    bh_slot = by1 - by0

    mod_large = extract_canonical_h26p01_pillar_module("large")
    out_frames: List[Image.Image] = []
    for f in range(8):
        arr = np.asarray(pillar_imgs[f], dtype=np.uint8).copy()
        src_f = mod_large[(f + 1) % 8]
        core_strip = src_f[8:24, 8:40, :3]
        reps_y = bh_slot // 16 + 2
        reps_x = bw_slot // 32 + 2
        fall_rgb = np.tile(core_strip, (reps_y, reps_x, 1))[:bh_slot, :bw_slot, :]

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
    decor_raw = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    decor_rgb = np.asarray(decor_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    sol_raw = Image.open(RAW_DIR / "sol_pavage_basalte_complet.png").convert("RGB")
    sol_rgb = np.asarray(sol_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    min_chasm = max(500, int(round(3500 * (w * h) / float(W_CANON * H_CANON))))
    all_magenta, open_chasm_raw, _ = split_magenta_chasms_and_veins(
        decor_rgb, min_open_chasm_area=min_chasm
    )
    rock_mask = ~all_magenta

    # 1. Cavité exacte fermée par l'arche pointue de basalte noir au Nord du plateau de Groudon :
    #    extraction par composante connexe exacte (`ndimage.label(all_magenta)` au point graine
    #    `(0.28 * h, 0.50 * w)`) => ZÉRO débordement hors de l'arche rocheuse !
    yy, xx = np.mgrid[:h, :w]
    lbl_mag, _ = ndimage.label(all_magenta)
    seed_arch_id = int(lbl_mag[int(0.28 * h), w // 2])
    arch_core = (lbl_mag == seed_arch_id) if seed_arch_id != 0 else np.zeros((h, w), dtype=bool)
    north_breach_mask = ndimage.binary_dilation(arch_core, iterations=1) & all_magenta
    open_chasm = open_chasm_raw & (~north_breach_mask)
    rock_veins = all_magenta & (~open_chasm) & (~north_breach_mask)

    volcanic_pal = build_unified_arena_palette(decor_rgb, rock_mask)
    q_decor = quantize_rgb_to_palette(decor_rgb, volcanic_pal)
    q_sol = quantize_rgb_to_palette(sol_rgb, volcanic_pal)

    # 2. Crocs d'ivoire volcanique bordant le pont et la couronne radiale de Groudon
    bone_fangs = rock_mask & (decor_rgb[:, :, 0] >= 145)

    # 3. Grand plateau radial central de Groudon + pont Sud -> Nord + rive Sud praticable :
    #    enveloppe géométrique fidèle au disque à pétales de basalte + pont pavé, fermant les joints sombres !
    boss_ellipse = (
        ((xx - 0.50 * w) / (0.184 * w)) ** 2 + ((yy - 0.462 * h) / (0.100 * h)) ** 2
    ) <= 1.0
    south_bridge = (yy >= int(0.51 * h)) & (xx >= int(0.405 * w)) & (xx <= int(0.595 * w))
    south_bank = (yy >= int(0.865 * h)) & (xx >= int(0.22 * w)) & (xx <= int(0.78 * w))
    arena_zone = boss_ellipse | south_bridge | south_bank

    slab_cand = (
        rock_mask
        & (~bone_fangs)
        & arena_zone
        & ((decor_rgb[:, :, 0] >= 52) | boss_ellipse)
    )
    slab_smooth = ndimage.binary_closing(
        slab_cand, iterations=max(2, int(round(6 * w / 768.0)))
    )
    south_rows = max(3, int(round(8 * h / 576.0)))
    slab_smooth[h - south_rows :, :] = (
        rock_mask[h - south_rows :, :]
        & (~bone_fangs[h - south_rows :, :])
        & south_bank[h - south_rows :, :]
        & (decor_rgb[h - south_rows :, :, 0] >= 48)
    )
    lbl_p, _ = ndimage.label(slab_smooth)
    south_seed_labels = [
        lbl_id
        for lbl_id in set(lbl_p[h - 6 :, int(0.35 * w) : int(0.65 * w)].ravel().tolist())
        if lbl_id != 0
    ]
    walkable_arena_floor = (
        np.isin(lbl_p, south_seed_labels)
        & rock_mask
        & (~bone_fangs)
        & (~all_magenta)
    )
    walkable_arena_floor = ndimage.binary_fill_holes(walkable_arena_floor) & rock_mask & (~bone_fangs) & (~all_magenta)

    # 4. Partition sémantique nette du massif de roche noire magma :
    rim_px = max(2, int(round(5 * w / float(W_CANON))))
    fangs_and_crown = (
        rock_mask
        & (~walkable_arena_floor)
        & (bone_fangs | (yy < int(0.46 * h)) | (ndimage.distance_transform_edt(~walkable_arena_floor) <= rim_px))
    )
    lower_black_cliffs = rock_mask & (~walkable_arena_floor) & (~fangs_and_crown)

    # 5. Couche 00 : Mer caldeira de magma canonique `H26P01` `1×` (`31 × 4` ticks)
    frames_00_sea = build_canonical_h26p01_magma_frames(w=w, h=h, mask=None, phase_offset=0)

    # 6. Couche 01 : Sol basaltique sombre continu sans couture (`sol_pavage_basalte_complet.png`)
    arr_01_sol = np.zeros((h, w, 4), dtype=np.uint8)
    arr_01_sol[rock_mask, :3] = q_sol[rock_mask]
    arr_01_sol[rock_mask, 3] = 255

    # 7. Couche 02 : **Veines de magma détourées depuis `#FF00FF`** (`H26P01.bpl` `1×`, `31 × 4` ticks)
    veins_mask = ndimage.binary_dilation(rock_veins, iterations=1) & all_magenta
    frames_02_veins = build_canonical_h26p01_magma_frames(
        w=w,
        h=h,
        mask=veins_mask,
        phase_offset=11,
        index_roll=(32, 24),
        pure_molten_only=True,
    )

    # 8. Couche 03 : **Animation visqueuse de rive & croûte de bordure rocher** (`15 × 8` ticks, `0` damier !)
    band_px = max(8.0, 22.0 * (w / float(W_CANON)))
    frames_03_viscous_shore = render_viscous_shoreline_border(
        open_chasm,
        n_frames=15,
        band_px=band_px,
    )

    # 9. Couche 04 : Grande cascade Nord sous l'arche + 4 colonnes canoniques `H26P01` `1×` (`8 × 3` ticks)
    #    placée SOUS les falaises et la couronne de roche noire magma pour une occlusion 3D naturelle !
    frames_04_falls_and_pillars = _render_north_arch_waterfall_and_sea_pillars(
        w=w,
        h=h,
        open_chasm=open_chasm,
        north_breach_mask=north_breach_mask,
    )

    def _layer_from_mask(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_decor[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_05_floor = _layer_from_mask(walkable_arena_floor)
    im_06_cliffs = _layer_from_mask(lower_black_cliffs)
    im_07_crown = _layer_from_mask(fangs_and_crown)

    # 10. Couche 08 : Incandescence thermique de bordure rocher (`15 × 8` ticks)
    full_rock_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    non_walk_rock = rock_mask & (~walkable_arena_floor)
    full_rock_rgba[non_walk_rock, :3] = q_decor[non_walk_rock]
    full_rock_rgba[non_walk_rock, 3] = 255
    frames_08_glow = build_h26p01_rim_glow_frames(full_rock_rgba, all_magenta)

    # 11. Couche 09 (`Top`, `Layer = 4`) : Braises volcaniques `W04` `1×` natives (`16 × 7` ticks)
    frames_09_embers = build_canonical_w04_embers_frames(w=w, h=h)

    # 12. Grille de collision `96 × 72` : pont praticable continu Sud (`y = gh - 1`) -> grand plateau de Groudon !
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
        LayerEntry("03_rive_magma_visqueux_bordure", "Rive Magma Visqueux & Bordure Rocher", "BG", frames_03_viscous_shore, frame_length=8),
        LayerEntry("04_cascade_arche_et_colonnes_h26", "Cascade Arche Nord & Colonnes H26P01.bpl", "BG", frames_04_falls_and_pillars, frame_length=3),
        LayerEntry("05_plateau_et_pont_arene", "Plateau Boss Groudon & Pont Sud-Nord", "BG", [im_05_floor], frame_length=5),
        LayerEntry("06_falaises_roche_noire_magma", "Falaises Basalte Noir & Contreforts", "BG", [im_06_cliffs], frame_length=5),
        LayerEntry("07_couronne_arche_roche_noire", "Couronne Roche Noire Magma & Crocs", "BG", [im_07_crown], frame_length=5),
        LayerEntry("08_incandescence_parois_bpl", "Incandescence Bordure Rocher BPL", "BG", frames_08_glow, frame_length=8),
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
        canonical_ref_for_fidelity=ENTREE_REF_DIR / "native_h26p01_roche_noire_ref.png",
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
