#!/usr/bin/env python3
"""Constructeur PMDO `0.8.12.0` (`768 × 576`, `10` calques `BG + Top`, `0 %` ciel) :
`DSB2` — *Caldeira du Cœur Solaire — 2e Donjon Boss* (`PMD : Destiny · Chapitre II`).

Biome canonique : Caldeira d'Obsidienne & Roche Volcanique `D09P01` / `Dark Crater`.
Liquides animés : Mer annulaire de magma en fusion `1×` `H26P01` (`10×9t`),
                  bordure visqueuse incandescente (`8×8t`), et `2` colonnes/cascades cylindriques
                  de lave `1×` `H26P01` (`8×4t`) tombant des orgues basaltiques nord.
VFX multi-frames : Sceau Solaire gravé incandescent + Cristal d'Autel rubis-ambre (`16×6t`),
                  braises matérielles GBA `W04` (`16×7t`, `Top`) et vortex d'étincelles solaires (`24×5t`, `Top`).
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
    H_CANON,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    assemble_chapitre2_brut_and_ref,
    build_canonical_w04_embers_frames,
    build_clean_lava_rim_layers,
    build_placed_lava_cascades,
    build_rsground_package,
    build_solar_seal_floor_glow_frames,
    build_volcanic_sparks_vfx_frames,
    mk_static_layer_im,
    resize_frames_nn,
    snap_frame_binary,
    subsample_magma_frames,
    write_halcyon_ground_script,
)

MAP_ID = "DSB2"
MAP_TITLE = "PMD : Destiny — Caldeira du Cœur Solaire · 2e Donjon Boss"
ASSET_NAME = "destiny_caldeira_coeur_solaire_boss"

HERE = Path(__file__).resolve().parent
RAW_MAGENTA = HERE / "intermediates" / "decor_magenta_raw.png"
BRUT_PATH = HERE / "intermediates" / "base_caldeira_boss.png"
CANON_REF = HERE / "references" / "ref_canon_caldeira_boss.png"
RENDERS_DIR = REPO_ROOT / "renders" / "destiny_donjon2_caldeira_boss_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    rgb_nat, solid_nat = assemble_chapitre2_brut_and_ref(
        RAW_MAGENTA,
        BRUT_PATH,
        CANON_REF,
        liquid_fill_rgb=(218, 72, 18),
        top_guard_y=48,
    )
    lava_mask_nat = ~solid_nat
    yy, xx = np.mgrid[:H_CANON, :W_CANON]

    # Assise abyssale volcanique couvrant 100 % du canevas (0 % ciel)
    underlay_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    underlay_rgba[:, :, :3] = (24, 10, 12)
    underlay_rgba[:, :, 3] = 255
    underlay_1 = [Image.fromarray(underlay_rgba, mode="RGBA")]

    # Mer annulaire de magma 1× H26P01 (10 phases matérielles GBA × 9 ticks -> ~12 900 tuiles << 24 000 !)
    magma_10 = resize_frames_nn(subsample_magma_frames(lava_mask_nat, n_phases=10, phase_offset=3), w, h)

    # Bordure visqueuse incandescente & lueur rocheuse des rives (8×8t)
    visc_8_nat, rim_glow_8_nat = build_clean_lava_rim_layers(lava_mask_nat, rgb_nat)
    visc_8 = resize_frames_nn(visc_8_nat, w, h)
    rim_glow_8 = resize_frames_nn(rim_glow_8_nat, w, h)

    # Découpe multi-calques sémantique de la Caldeira d'Obsidienne
    # 1. Pont de pierre basaltique sud
    is_south_bridge = (
        solid_nat
        & (xx >= 316)
        & (xx <= 454)
        & (yy >= 404)
    )

    # 2. Plateforme octogonale centrale gravée du Sceau Solaire
    is_octagonal_arena = (
        solid_nat
        & (~is_south_bridge)
        & (xx >= 186)
        & (xx <= 582)
        & (yy >= 134)
        & (yy <= 488)
        & (~((yy < 168) & ((xx < 276) | (xx > 492))))
    )

    # 3. Muraille d'orgues basaltiques nord, autel du Cristal Rubis-Ambre & couronne rocheuse externe
    is_caldera_obsidian_ring_and_altar = (
        solid_nat
        & (~is_south_bridge)
        & (~is_octagonal_arena)
    )

    # 2 Cascades cylindriques de lave 1× H26P01 tombant de la muraille nord dans le lac annulaire (8×4t)
    lava_pillars_8 = build_placed_lava_cascades(
        w,
        h,
        specs=[
            {"variant": "medium", "cx": 212, "top_y": 98, "base_y": 196, "phase": 0, "mirror": False},
            {"variant": "medium", "cx": 555, "top_y": 98, "base_y": 196, "phase": 4, "mirror": True},
        ],
        fg_rgb_mut=rgb_nat,
        solid_mask=solid_nat,
    )

    # Sceau Solaire gravé incandescent au centre (383, 291) + Cristal d'Autel nord (385, 66) + Lueur de rive (8×8t)
    solar_and_cryst_8_nat = build_solar_seal_floor_glow_frames(
        rgb_nat, solid_nat, seal_center=(383, 291), n_frames=8
    )
    solar_and_rim_8: List[Image.Image] = []
    for f in range(8):
        rg = np.asarray(rim_glow_8_nat[f], dtype=np.uint8).copy()
        sc = np.asarray(solar_and_cryst_8_nat[f], dtype=np.uint8)
        m = sc[:, :, 3] > 0
        rg[m] = sc[m]
        solar_and_rim_8.append(Image.fromarray(rg, mode="RGBA"))
    solar_and_rim_8 = resize_frames_nn(solar_and_rim_8, w, h)

    # Braises volcaniques montantes matérielles GBA W04 (16×7t, Top)
    w04_embers_16 = [snap_frame_binary(im) for im in build_canonical_w04_embers_frames(w, h)]

    # Vortex d'étincelles solaires & éclats de feu multi-frames (24×5t, Top)
    sparks_top_24 = resize_frames_nn(
        build_volcanic_sparks_vfx_frames(
            lava_mask_nat,
            extra_emitters=[(385, 72), (345, 290), (422, 290), (383, 248), (383, 334)],
            n_frames=24,
            seed=204,
        ),
        w,
        h,
    )

    # Grille de collision : pont sud + dalle octogonale supérieure de l'arène Boss
    lava_margin = ndimage.binary_dilation(lava_mask_nat, iterations=5)
    arena_top_deck = (
        ((xx >= 224) & (xx <= 544) & (yy >= 158) & (yy <= 412))
        | ((xx >= 340) & (xx <= 428) & (yy >= 400) & (yy <= 568))
    )
    walk_nat = solid_nat & (~lava_margin) & arena_top_deck
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
        LayerEntry("00_assise_caldeira_abyssale", "Assise Abyssale de la Caldeira Solaire (0 % Ciel)", "BG", resize_frames_nn(underlay_1, w, h), frame_length=5),
        LayerEntry("01_mer_magma_annulaire_h26p01_1x", "Mer Annulaire de Magma Canonique 1× H26P01 (10×9t)", "BG", magma_10, frame_length=9),
        LayerEntry("02_rive_visqueuse_incandescente", "Bordure Visqueuse Incandescente du Gouffre (8×8t)", "BG", visc_8, frame_length=8),
        LayerEntry("03_couronne_obsidienne_et_autel_nord", "Orgues Basaltiques d'Obsidienne & Autel du Cristal Igné", "BG", [mk_static_layer_im(rgb_nat, is_caldera_obsidian_ring_and_altar, w, h)], frame_length=5),
        LayerEntry("04_arene_octogonale_sceau_solaire", "Plateforme Octogonale de Basalte du Cœur Solaire", "BG", [mk_static_layer_im(rgb_nat, is_octagonal_arena, w, h)], frame_length=5),
        LayerEntry("05_pont_pierre_volcanique_sud", "Pont Massif de Pierre Volcanique Sud", "BG", [mk_static_layer_im(rgb_nat, is_south_bridge, w, h)], frame_length=5),
        LayerEntry("06_cascades_lave_muraille_nord", "Cascades Cylindriques de Lave 1× H26P01 (8×4t)", "BG", lava_pillars_8, frame_length=4),
        LayerEntry("07_sceau_solaire_et_cristal_pulsants_8f", "VFX Sceau Solaire Incandescent, Cristal Rubis & Rives (8×8t)", "BG", solar_and_rim_8, frame_length=8),
        LayerEntry("08_braises_materielles_w04_top_16f", "Braises Volcaniques Montantes Canoniques GBA W04 Top (16×7t)", "Top", w04_embers_16, frame_length=7),
        LayerEntry("09_vortex_etincelles_solaires_top_24f", "VFX Vortex d'Étincelles Solaires & Éclats Ignés Top (24×5t)", "Top", sparks_top_24, frame_length=5),
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
        namespace_override="pmd_destiny_dsb2",
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
