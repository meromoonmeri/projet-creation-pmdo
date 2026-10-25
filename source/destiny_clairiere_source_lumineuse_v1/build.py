#!/usr/bin/env python3
"""Constructeur PMDO `0.8.12.0` (`768 × 576`, `10` calques `BG + Top`, `0 %` ciel) :
`DSS2` — *Clairière de la Source Lumineuse* (`PMD : Destiny · Chapitre II`).

Biome canonique : Source Lumineuse (`P14P01A`, *PMD Explorers of Sky*).
Liquides animés : Eau sacrée émeraude-turquoise `1×` (`4×10t`), scintillements `1×` (`4×10t`),
                  ondes concentriques sacrées (`16×6t`), cascades cristallines `1×` `P03P01A` (`3×10t`).
VFX multi-frames : Flore animée `1×` `Vast Steppe` (`4×12t`), couronne d'arbres anciens `Top`
                  et faisceau sacré zénithal d'évolution + particules cristallines (`24×5t`).
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

SOURCE_DIR = Path(__file__).resolve().parent.parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_destiny_chapitre2_maps import (  # type: ignore
    DESTINY_WATER_PALS,
    H_CANON,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    assemble_chapitre2_brut_and_ref,
    build_canonical_metano_liquid_layers,
    build_luminous_spring_zenith_ray_vfx,
    build_placed_p03p01a_cascades,
    build_rsground_package,
    build_sacred_spring_concentric_ripples,
    build_vast_steppe_flowers_layer,
    mk_static_layer_im,
    resize_frames_nn,
    write_halcyon_ground_script,
)

MAP_ID = "DSS2"
MAP_TITLE = "PMD : Destiny — Clairière de la Source Lumineuse · Chapitre II"
ASSET_NAME = "destiny_clairiere_source_lumineuse"

HERE = Path(__file__).resolve().parent
RAW_MAGENTA = HERE / "intermediates" / "decor_magenta_raw.png"
BRUT_PATH = HERE / "intermediates" / "base_clairiere_source.png"
CANON_REF = HERE / "references" / "ref_canon_clairiere_source.png"
RENDERS_DIR = REPO_ROOT / "renders" / "destiny_clairiere_source_lumineuse_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    rgb_nat, solid_nat = assemble_chapitre2_brut_and_ref(
        RAW_MAGENTA,
        BRUT_PATH,
        CANON_REF,
        liquid_fill_rgb=DESTINY_WATER_PALS["luminous_emerald"]["surface"],
        top_guard_y=40,
    )
    yy, xx = np.mgrid[:H_CANON, :W_CANON]
    # Referme les micro-rigoles < 5 px dans l'herbe latérale pour un bassin circulaire P14P01A pur
    hairline_side = (~solid_nat) & ((xx < 252) | (xx > 514))
    if np.any(hairline_side):
        _, n_idx = ndimage.distance_transform_edt(~solid_nat, return_indices=True)
        hy, hx = np.where(hairline_side)
        rgb_nat[hy, hx] = rgb_nat[n_idx[0, hy, hx], n_idx[1, hy, hx]]
        solid_nat[hairline_side] = True
        preview = rgb_nat.copy()
        preview[~solid_nat] = DESTINY_WATER_PALS["luminous_emerald"]["surface"]
        Image.fromarray(preview, mode="RGB").save(CANON_REF)
    water_mask_nat = ~solid_nat

    # Assise profonde émeraude sombre (0 % ciel)
    underlay_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    underlay_rgba[:, :, :3] = (10, 48, 46)
    underlay_rgba[:, :, 3] = 255
    underlay_1 = [Image.fromarray(underlay_rgba, mode="RGBA")]

    # Eau sacrée émeraude-turquoise canonique 1× + scintillements 1×
    water_4, sparkle_4 = build_canonical_metano_liquid_layers(
        w, h, water_mask_nat, pal_key="luminous_emerald", seed=202622
    )

    # Anneaux concentriques d'onde lumineuse sacrée dans le bassin circulaire (16 frames × 6 ticks)
    sacred_ripples_16 = resize_frames_nn(
        build_sacred_spring_concentric_ripples(water_mask_nat, center_xy=(383, 208), n_frames=16),
        w,
        h,
    )

    # Découpe multi-calques fidèle à P14P01A (Luminous Spring)
    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Couronne latérale haute des grands arbres anciens bleu-vert en Top
    is_outer_tree_crowns_top = (
        solid_nat
        & ((xx < 142) | (xx > 626))
        & ((yy < 206) | ((yy > 350) & (yy < 495)))
        & (g_c >= r_c + 10)
    )

    # Paroi rocheuse nord, rochers moussus et stèle cristalline sacrée (y < 145)
    is_north_cliff_and_stele = (
        solid_nat
        & (~is_outer_tree_crowns_top)
        & (yy < 156)
        & (xx >= 186)
        & (xx <= 582)
    )

    # Promontoire de pierre polie en escalier surplombant le bassin & stèles runiques sud
    is_stone_terrace_and_runes = (
        solid_nat
        & (~is_outer_tree_crowns_top)
        & (~is_north_cliff_and_stele)
        & (
            ((xx >= 248) & (xx <= 518) & (yy >= 294) & (yy <= 394) & ((g_c - r_c) <= 26))
            | ((xx >= 304) & (xx <= 464) & (yy >= 488) & ((g_c - r_c) <= 22))
        )
    )

    # Pelouse d'émeraude P14P01A, sous-bois fougères et fûts des grands arbres périphériques
    is_glade_meadow_and_woods = (
        solid_nat
        & (~is_outer_tree_crowns_top)
        & (~is_north_cliff_and_stele)
        & (~is_stone_terrace_and_runes)
    )

    # Cascades cristallines 1× P03P01A jaillissant de la paroi rocheuse nord dans la Source
    cascades_3 = build_placed_p03p01a_cascades(
        w,
        h,
        specs=[
            (310, 50, 118, "narrow_16", 0),
            (456, 50, 118, "narrow_16", 2),
        ],
        fg_rgb_mut=rgb_nat,
        solid_mask=solid_nat,
    )

    # Fleurs sauvages animées 1× Vast Steppe dans la pelouse émeraude centrale
    meadow_grass = (
        is_glade_meadow_and_woods
        & (xx >= 236)
        & (xx <= 532)
        & (yy >= 240)
        & (yy <= 548)
        & (g_c >= r_c + 24)
        & (g_c >= 105)
    )
    flowers_4 = build_vast_steppe_flowers_layer(w, h, meadow_grass, seed=5202, max_flowers=14)

    # Calque Top combinant les cimes d'arbres anciens P14P01A + le Rayon Zénithal & Aura (24×5t)
    top_crowns_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    top_crowns_rgba[is_outer_tree_crowns_top, :3] = rgb_nat[is_outer_tree_crowns_top]
    top_crowns_rgba[is_outer_tree_crowns_top, 3] = 255

    raw_ray_24 = build_luminous_spring_zenith_ray_vfx(center_xy=(383, 206), n_frames=24, seed=202)
    zenith_and_crowns_24: List[Image.Image] = []
    for im_r in raw_ray_24:
        c = top_crowns_rgba.copy()
        r_arr = np.asarray(im_r, dtype=np.uint8)
        m = r_arr[:, :, 3] > 0
        c[m] = r_arr[m]
        zenith_and_crowns_24.append(Image.fromarray(c, mode="RGBA"))
    zenith_ray_24 = resize_frames_nn(zenith_and_crowns_24, w, h)

    # Grille de collision : allée des pierres runiques + clairière d'émeraude + promontoire sacré
    water_margin = ndimage.binary_dilation(water_mask_nat, iterations=4)
    walk_corridor = (xx >= 262) & (xx <= 504) & (yy >= 292) & (yy <= 568)
    walk_nat = solid_nat & (~water_margin) & walk_corridor
    walk_grid = (
        np.asarray(
            Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
        )
        >= 128
    )
    walk_grid[:4, :] = False
    walk_grid[:, :6] = False
    walk_grid[:, -6:] = False

    layers = [
        LayerEntry("00_assise_source_emeraude", "Assise Sacrée de la Source (0 % Ciel)", "BG", resize_frames_nn(underlay_1, w, h), frame_length=5),
        LayerEntry("01_eau_source_emeraude_1x", "Eau Sacrée Émeraude-Turquoise Canonique 1× (4×10t)", "BG", water_4, frame_length=10),
        LayerEntry("02_ondes_concentriques_sacrees_16f", "Ondes Lumineuses Concentriques de la Source P14P01A (16×6t)", "BG", sacred_ripples_16, frame_length=6),
        LayerEntry("03_sparkles_source_lumineuse_1x", "Scintillements Cristallins Natifs 1× (4×10t)", "BG", sparkle_4, frame_length=10),
        LayerEntry("04_clairiere_emeraude_et_sous_bois", "Pelouse Émeraude P14P01A & Sous-Bois Ancien", "BG", [mk_static_layer_im(rgb_nat, is_glade_meadow_and_woods, w, h)], frame_length=5),
        LayerEntry("05_promontoire_pierre_et_steles_runes", "Promontoire en Escalier & Stèles Runiques Moussues", "BG", [mk_static_layer_im(rgb_nat, is_stone_terrace_and_runes, w, h)], frame_length=5),
        LayerEntry("06_paroi_nord_et_stele_cristal", "Paroi Rocheuse Nord & Stèle Cristalline d'Évolution", "BG", [mk_static_layer_im(rgb_nat, is_north_cliff_and_stele, w, h)], frame_length=5),
        LayerEntry("07_cascades_cristallines_p03p01a_1x", "Cascades Cristallines Canoniques 1× P03P01A (3×10t)", "BG", cascades_3, frame_length=10),
        LayerEntry("08_fleurs_clairiere_vast_steppe_1x", "Fleurs Sauvages Animées Canoniques 1× Vast Steppe (4×12t)", "BG", flowers_4, frame_length=12),
        LayerEntry("09_cimes_rayon_zenithal_et_aura_top", "Cimes Anciennes + VFX Rayon Sacré Zénithal & Aura d'Évolution Top (24×5t)", "Top", zenith_ray_24, frame_length=5),
    ]
    return layers, walk_grid


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    h = max(64, int(round(H_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    VIRTUAL_ZIP.parent.mkdir(parents=True, exist_ok=True)
    layers, walk_grid = build_layers_for_size(w, h)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=CANON_REF,
        max_fidelity_distance=30.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="pmd_destiny_dss2",
        asset_name_override=ASSET_NAME,
    )
    write_halcyon_ground_script(out_dir / "package", ASSET_NAME)
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    print(json.dumps(build(), indent=2, ensure_ascii=False))
