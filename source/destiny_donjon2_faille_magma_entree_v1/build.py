#!/usr/bin/env python3
"""Constructeur PMDO `0.8.12.0` (`768 × 576`, `10` calques `BG + Top`, `0 %` ciel) :
`DSM2` — *Gorge Basaltique des Sources Brûlantes — 2e Donjon Entrée* (`PMD : Destiny · Chapitre II`).

Biome canonique : Gorge Rocheuse Volcanique `D09P01` (*Mt. Blaze*, *PMD Red*).
Liquides animés : Vrai magma en fusion `1×` `H26P01` par palette cycling matériel GBA (`12×8t`),
                  bordure visqueuse incandescente (`8×8t`), lueur rocheuse des rives (`8×8t`),
                  et `2` colonnes/cascades cylindriques de lave `1×` `H26P01` (`8×4t`).
VFX multi-frames : Pulsation des cristaux ignés ambre-or (`16×6t`), vraies braises montantes
                  matérielles GBA `W04` (`16×7t`, `Top`) et étincelles volcaniques (`24×5t`, `Top`).
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
    build_igneous_crystal_pulse_frames,
    build_placed_lava_cascades,
    build_rsground_package,
    build_volcanic_sparks_vfx_frames,
    mk_static_layer_im,
    resize_frames_nn,
    snap_frame_binary,
    subsample_magma_frames,
    write_halcyon_ground_script,
)

MAP_ID = "DSM2"
MAP_TITLE = "PMD : Destiny — Gorge Basaltique des Sources Brûlantes · 2e Donjon Entrée"
ASSET_NAME = "destiny_gorge_basaltique_magma_entree"

HERE = Path(__file__).resolve().parent
RAW_MAGENTA = HERE / "intermediates" / "decor_magenta_raw.png"
BRUT_PATH = HERE / "intermediates" / "base_gorge_basaltique.png"
CANON_REF = HERE / "references" / "ref_canon_gorge_basaltique.png"
RENDERS_DIR = REPO_ROOT / "renders" / "destiny_donjon2_faille_magma_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    rgb_nat, solid_nat = assemble_chapitre2_brut_and_ref(
        RAW_MAGENTA,
        BRUT_PATH,
        CANON_REF,
        liquid_fill_rgb=(214, 68, 18),
        top_guard_y=48,
    )
    lava_mask_nat = ~solid_nat
    yy, xx = np.mgrid[:H_CANON, :W_CANON]

    # Assise volcanique sombre couvrant 100 % du canevas (0 % ciel)
    underlay_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    underlay_rgba[:, :, :3] = (34, 12, 10)
    underlay_rgba[:, :, 3] = 255
    underlay_1 = [Image.fromarray(underlay_rgba, mode="RGBA")]

    # Magma en fusion canonique 1× H26P01 (12 phases matérielles GBA × 8 ticks)
    magma_12 = resize_frames_nn(subsample_magma_frames(lava_mask_nat, n_phases=12, phase_offset=0), w, h)

    # Bordure visqueuse incandescente & lueur pulsante sur les parois rocheuses (8×8t)
    visc_8_nat, rim_glow_8_nat = build_clean_lava_rim_layers(lava_mask_nat, rgb_nat)
    visc_8 = resize_frames_nn(visc_8_nat, w, h)
    rim_glow_8 = resize_frames_nn(rim_glow_8_nat, w, h)

    # Découpe multi-calques fidèle à D09P01 (Mt. Blaze)
    r_c = rgb_nat[:, :, 0].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Bouche caverneuse nord & piliers prismatiques de basalte sertis de cristaux ignés
    is_dungeon_mouth_and_pillars = (
        solid_nat
        & (
            (yy < 248)
            | ((yy < 312) & (xx >= 205) & (xx <= 564) & ((r_c - b_c) < 28))
        )
    )

    # Parois étagées extérieures de basalte gris-cendré à gauche et à droite
    is_outer_basalt_walls = (
        solid_nat
        & (~is_dungeon_mouth_and_pillars)
        & ((xx < 176) | (xx > 592))
    )

    # Chaussée centrale de dalles volcaniques d'ocre craquelé D09P01 & rebords des fosses
    is_ochre_walkway_and_ledges = (
        solid_nat
        & (~is_dungeon_mouth_and_pillars)
        & (~is_outer_basalt_walls)
    )

    # 2 Colonnes/Cascades cylindriques de lave 1× H26P01 (8 frames × 4 ticks) jaillissant des parois dans les 2 bassins
    lava_pillars_8 = build_placed_lava_cascades(
        w,
        h,
        specs=[
            {"variant": "small", "cx": 233, "top_y": 266, "base_y": 338, "phase": 0, "mirror": False},
            {"variant": "small", "cx": 533, "top_y": 266, "base_y": 338, "phase": 4, "mirror": True},
        ],
        fg_rgb_mut=rgb_nat,
        solid_mask=solid_nat,
    )

    # Pulsation des cristaux ignés ambre-or sertis sur les piliers d'entrée (16×6t)
    crystal_pulse_16 = resize_frames_nn(
        build_igneous_crystal_pulse_frames(rgb_nat, solid_nat, n_frames=16),
        w,
        h,
    )

    # Vraies braises volcaniques montantes matérielles GBA W04 (16×7t, Top)
    w04_embers_16 = [snap_frame_binary(im) for im in build_canonical_w04_embers_frames(w, h)]

    # Étincelles ignées & flammèches multi-frames (24×5t, Top) montant des fosses et des cristaux
    sparks_top_24 = resize_frames_nn(
        build_volcanic_sparks_vfx_frames(
            lava_mask_nat,
            extra_emitters=[(265, 138), (502, 138), (384, 218)],
            n_frames=24,
            seed=203,
        ),
        w,
        h,
    )

    # Grille de collision : chaussée centrale d'ocre menant du sud jusqu'à la bouche du donjon nord
    lava_margin = ndimage.binary_dilation(lava_mask_nat, iterations=4)
    walk_corridor = (
        ((xx >= 306) & (xx <= 460) & (yy >= 216) & (yy <= 566))
        | ((xx >= 210) & (xx <= 558) & (yy >= 496) & (yy <= 568))
    )
    walk_nat = solid_nat & (~lava_margin) & walk_corridor
    walk_grid = (
        np.asarray(
            Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
        )
        >= 128
    )
    walk_grid[:4, :] = False
    walk_grid[:, :6] = False
    walk_grid[:, -6:] = False

    # Fusionne lueur de rive + pulsation cristalline dans 07 pour garder exactement 10 calques riches !
    rim_and_cryst_16: List[Image.Image] = []
    for f in range(16):
        rg = np.asarray(rim_glow_8[f % 8], dtype=np.uint8).copy()
        cp = np.asarray(crystal_pulse_16[f], dtype=np.uint8)
        m = cp[:, :, 3] > 0
        rg[m] = cp[m]
        rim_and_cryst_16.append(Image.fromarray(rg, mode="RGBA"))

    layers = [
        LayerEntry("00_assise_faille_volcanique", "Assise Basaltique des Sources Brûlantes (0 % Ciel)", "BG", resize_frames_nn(underlay_1, w, h), frame_length=5),
        LayerEntry("01_magma_canonique_h26p01_1x", "Magma en Fusion Canonique 1× H26P01 GBA (12×8t)", "BG", magma_12, frame_length=8),
        LayerEntry("02_bordure_visqueuse_incandescente", "Bordure Visqueuse Incandescente du Magma (8×8t)", "BG", visc_8, frame_length=8),
        LayerEntry("03_chaussee_ocre_craquelee_d09p01", "Chaussée Centrale en Dalles Volcaniques D09P01", "BG", [mk_static_layer_im(rgb_nat, is_ochre_walkway_and_ledges, w, h)], frame_length=5),
        LayerEntry("04_parois_etagees_basalte_gris", "Parois Étagées Extérieures de Basalte Gris-Cendré", "BG", [mk_static_layer_im(rgb_nat, is_outer_basalt_walls, w, h)], frame_length=5),
        LayerEntry("05_bouche_donjon_et_piliers_ignes", "Bouche Caverneuse du 2e Donjon & Piliers à Cristaux Ignés", "BG", [mk_static_layer_im(rgb_nat, is_dungeon_mouth_and_pillars, w, h)], frame_length=5),
        LayerEntry("06_cascades_lave_cylindriques_h26p01", "Cascades Cylindriques de Lave 1× H26P01 (8×4t)", "BG", lava_pillars_8, frame_length=4),
        LayerEntry("07_lueur_rives_et_cristaux_ignes_16f", "Lueur Rocheuse des Rives & Pulsation des Cristaux Ignés (16×6t)", "BG", rim_and_cryst_16, frame_length=6),
        LayerEntry("08_braises_materielles_w04_top_16f", "Braises Volcaniques Montantes Canoniques GBA W04 Top (16×7t)", "Top", w04_embers_16, frame_length=7),
        LayerEntry("09_etincelles_et_flammeches_top_24f", "VFX Étincelles Ignées & Souffle Brûlant du Donjon Top (24×5t)", "Top", sparks_top_24, frame_length=5),
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
        namespace_override="pmd_destiny_dsm2",
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
