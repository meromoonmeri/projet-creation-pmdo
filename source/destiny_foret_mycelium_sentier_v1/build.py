#!/usr/bin/env python3
"""Constructeur PMDO `0.8.12.0` (`768 × 576`, `10` calques `BG + Top`, `0 %` ciel) :
`DSF2` — *Sentier du Sous-Bois Mycelien* (`PMD : Destiny · Chapitre II`).

Biome canonique : Forêt Champignon (`H07P05`) & Forêt Guérisseuse (`H07P06`).
Liquides animés : Ruisseau sylvestre `1×` `Metano_Town_River` (`4×10t`), scintillements `1×` (`4×10t`),
                  cascades moussues `1×` `P03P01A` (`3×10t`).
VFX multi-frames : Bioluminescence des chapeaux de champignons (`16×6t`), fleurs animées `1×` `Vast Steppe`
                  (`4×12t`), et spores bioluminescentes pastel & lucioles en `Top` (`24×5t`).
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
    build_mushroom_cap_bioluminescence_frames,
    build_mycelium_spores_vfx_frames,
    build_placed_p03p01a_cascades,
    build_rsground_package,
    build_vast_steppe_flowers_layer,
    mk_static_layer_im,
    resize_frames_nn,
    write_halcyon_ground_script,
)

MAP_ID = "DSF2"
MAP_TITLE = "PMD : Destiny — Sentier du Sous-Bois Mycelien · Chapitre II"
ASSET_NAME = "destiny_sous_bois_mycelien"

HERE = Path(__file__).resolve().parent
RAW_MAGENTA = HERE / "intermediates" / "decor_magenta_raw.png"
BRUT_PATH = HERE / "intermediates" / "base_foret_mycelium.png"
CANON_REF = HERE / "references" / "ref_canon_foret_mycelium.png"
RENDERS_DIR = REPO_ROOT / "renders" / "destiny_foret_mycelium_sentier_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    rgb_nat, solid_nat = assemble_chapitre2_brut_and_ref(
        RAW_MAGENTA,
        BRUT_PATH,
        CANON_REF,
        liquid_fill_rgb=DESTINY_WATER_PALS["sylvan_stream"]["surface"],
        top_guard_y=40,
    )
    water_mask_nat = ~solid_nat
    yy, xx = np.mgrid[:H_CANON, :W_CANON]

    # Assise sous-fluviale sombre couvrant 100 % du canevas (0 % ciel / 0 vide)
    underlay_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    underlay_rgba[:, :, :3] = (12, 46, 56)
    underlay_rgba[:, :, 3] = 255
    underlay_1 = [Image.fromarray(underlay_rgba, mode="RGBA")]

    # Ruisseau sylvestre canonique 1× Metano + scintillements 1×
    water_4, sparkle_4 = build_canonical_metano_liquid_layers(
        w, h, water_mask_nat, pal_key="sylvan_stream", seed=202621
    )

    # Découpe multi-calques sémantique du décor canonique H07P05 / H07P06
    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Couronne feuillue périphérique haute placée en Top (en gardant libres les cascades nord !)
    cascade_keepout = ((xx >= 166) & (xx <= 216) & (yy >= 108) & (yy <= 228)) | (
        (xx >= 568) & (xx <= 618) & (yy >= 108) & (yy <= 228)
    )
    outer_ring = (
        (yy < 54)
        | (yy > 528)
        | (xx < 52)
        | (xx > 716)
        | (((xx < 92) | (xx > 676)) & ((yy < 130) | (yy > 450)))
    )
    is_top_canopy = (
        solid_nat
        & outer_ring
        & (~cascade_keepout)
        & (g_c >= r_c + 8)
        & (g_c >= b_c + 6)
    )

    # Pont de tronc creux moussu au centre franchissant les deux bras du ruisseau
    is_log_bridge = (
        solid_nat
        & (~is_top_canopy)
        & (xx >= 278)
        & (xx <= 502)
        & (yy >= 256)
        & (yy <= 412)
        & ((r_c + g_c) >= b_c * 2 + 12)
        & (yy >= 260 + (xx - 280) * 0.12 - 28)
        & (yy <= 388 + (xx - 280) * 0.14)
    )

    # Arche de racines géantes nord, corniches rocheuses moussues & grands champignons H07P05
    is_arch_and_giant_mushrooms = (
        solid_nat
        & (~is_top_canopy)
        & (~is_log_bridge)
        & (
            (yy < 208)
            | ((xx < 238) & (yy < 438))
            | ((xx > 542) & (yy < 438))
            | (yy > 476)
        )
    )

    # Sentier central de terre humide, pelouse moussue & petits champignons du sous-bois
    is_moss_floor_and_trail = (
        solid_nat
        & (~is_top_canopy)
        & (~is_log_bridge)
        & (~is_arch_and_giant_mushrooms)
    )

    # Cascades moussues canoniques 1× P03P01A (placées AU-DESSUS des corniches rocheuses !)
    cascades_3 = build_placed_p03p01a_cascades(
        w,
        h,
        specs=[
            (190, 126, 202, "narrow_16", 0),
            (592, 126, 196, "narrow_16", 1),
        ],
        fg_rgb_mut=rgb_nat,
        solid_mask=solid_nat,
    )

    # Fleurs sauvages animées 1× Vast Steppe sur les berges d'herbe émeraude
    grass_mask = ndimage.binary_dilation(
        solid_nat
        & (~is_top_canopy)
        & (~is_log_bridge)
        & (yy >= 195)
        & (yy <= 520)
        & (g_c >= r_c + 18)
        & (g_c >= b_c + 18)
        & (g_c >= 78),
        iterations=5,
    ) & solid_nat & (~is_log_bridge)
    flowers_4 = build_vast_steppe_flowers_layer(w, h, grass_mask, seed=5201, max_flowers=12)

    # Bioluminescence pulsante des chapeaux de champignons H07P05 (16 frames × 6 ticks)
    mush_glow_16 = resize_frames_nn(
        build_mushroom_cap_bioluminescence_frames(rgb_nat, solid_nat & (~is_top_canopy), n_frames=16),
        w,
        h,
    )

    # Couronne feuillue Top + Spores bioluminescentes pastel & lucioles (24 frames × 5 ticks)
    top_canopy_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    top_canopy_rgba[is_top_canopy, :3] = rgb_nat[is_top_canopy]
    top_canopy_rgba[is_top_canopy, 3] = 255
    spores_top_24 = resize_frames_nn(
        build_mycelium_spores_vfx_frames(top_canopy_rgba=top_canopy_rgba, n_frames=24, seed=201),
        w,
        h,
    )

    # Grille de collision : sentier central + pont de tronc moussu + clairière nord sous l'arche
    water_margin = ndimage.binary_dilation(water_mask_nat, iterations=4)
    central_corridor = (xx >= 276) & (xx <= 496) & (yy >= 112) & (yy <= 548)
    walk_nat = solid_nat & (~water_margin) & central_corridor & (~is_top_canopy)
    walk_grid = (
        np.asarray(
            Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
        )
        >= 128
    )
    walk_grid[:4, :] = False
    walk_grid[:, :4] = False
    walk_grid[:, -4:] = False

    layers = [
        LayerEntry("00_assise_sous_bois_sombre", "Assise Sous-Fluviale du Sous-Bois (0 % Ciel)", "BG", resize_frames_nn(underlay_1, w, h), frame_length=5),
        LayerEntry("01_ruisseau_sylvestre_metano_1x", "Ruisseau Sylvestre Canonique Metano 1× (4×10t)", "BG", water_4, frame_length=10),
        LayerEntry("02_reflets_cristallins_metano_1x", "Scintillements Aquatiques Canoniques 1× (4×10t)", "BG", sparkle_4, frame_length=10),
        LayerEntry("03_sentier_terre_et_pelouse_moussue", "Sentier Humide & Pelouse Moussue H07P06", "BG", [mk_static_layer_im(rgb_nat, is_moss_floor_and_trail, w, h)], frame_length=5),
        LayerEntry("04_arche_racines_et_champignons_geants", "Arche de Racines, Corniches & Grands Champignons H07P05", "BG", [mk_static_layer_im(rgb_nat, is_arch_and_giant_mushrooms, w, h)], frame_length=5),
        LayerEntry("05_pont_tronc_creux_moussu", "Pont de Tronc Creux Moussu sur le Ruisseau", "BG", [mk_static_layer_im(rgb_nat, is_log_bridge, w, h)], frame_length=5),
        LayerEntry("06_cascades_moussues_p03p01a_1x", "Cascades Sylvestres Canoniques 1× P03P01A (3×10t)", "BG", cascades_3, frame_length=10),
        LayerEntry("07_fleurs_sauvages_vast_steppe_1x", "Flore Sauvage Animée Canonique 1× Vast Steppe (4×12t)", "BG", flowers_4, frame_length=12),
        LayerEntry("08_bioluminescence_champignons_16f", "VFX Bioluminescence des Chapeaux Fongiques H07P05 (16×6t)", "BG", mush_glow_16, frame_length=6),
        LayerEntry("09_canopee_spores_et_lucioles_top_24f", "Canopée Haute + VFX Spores Bioluminescentes & Lucioles Top (24×5t)", "Top", spores_top_24, frame_length=5),
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
        namespace_override="pmd_destiny_dsf2",
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
