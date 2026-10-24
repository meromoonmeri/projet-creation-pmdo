#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — KYA1 : Grotte Cyclopéenne — Sanctuaire de Glace Noire & Blizzard 360° (Kyurem).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks) :
  - `00` (`BG`, 24p) : Gouffre polaire & paroi arrière concave du Blizzard Cyclonique 360° (`G → D`, `24 × 5t`)
  - `01` (`BG`, 24p) : Colonnes tangentielles Ouest/Est & rubans hélicoïdaux *Ère Glaciaire* (`24 × 5t`)
  - `02` (`BG`,  4p) : Douve annulaire d'Eau Métano Gelée (`Metano_Town_River` refroidie, `4 × 10t`)
  - `03` (`BG`,  4p) : Scintillements glaciaires `1×` natifs `Metano_Town_River_Sparkles.tile` (`4 × 10t`)
  - `04` (`BG`,  1p) : Rempart météoritique d'obsidienne & escarpement rocheux de l'île centrale (`1` pose)
  - `05` (`BG`,  1p) : Escalier-chaussée Sud→Nord sculpté en pierre sombre et glace (`1` pose)
  - `06` (`BG`,  1p) : Plateau d'arène simple et nu de Glace Noire & pierre météoritique (`1` pose, `0` objet)
  - `07` (`BG`,  1p) : Couronne périphérique de pitons de glace noire cyan (`1` pose)
  - `08` (`BG`, 24p) : Éclats de glace vive, sillages cryo, reflets des pitons & poudreuse `W03P03` (`24 × 5t`)
  - `09` (`Top`,24p) : Lèvre avant en surplomb du Blizzard 360° (`D → G`) & bourrasques `W03P03` Top (`24 × 5t`)
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

from source.moteur_cyclones_cylindriques_unova import sanitize_rgba_binary
from source.moteur_grotte_cyclopeenne_kyurem import (
    H_CANON as H_NAT,
    TILE_SIZE,
    W_CANON as W_NAT,
    assemble_kyurem_sanctuaire_glace_brut,
    build_glacial_metano_water_layers,
    build_kyurem_cylindrical_blizzard_layers,
    split_sanctuary_outer_vortex_and_inner_moat,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "KYA1"
MAP_TITLE = "Grotte Cyclopéenne — Sanctuaire de Glace Noire & Blizzard 360° (Kyurem)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_kyurem_sanctuaire_glace.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_kyurem_sanctuaire_glace.png"
RENDERS_DIR = REPO_ROOT / "renders" / "kyurem_sanctuaire_glace_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    if not BRUT_PATH.is_file() or not CANON_REF.is_file():
        assemble_kyurem_sanctuaire_glace_brut(HERE)

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]

    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    outer_vortex_nat, inner_moat_nat = split_sanctuary_outer_vortex_and_inner_moat(mag_nat)
    solid_nat = ~mag_nat

    # Partitionnement géométrique exact des 4 calques statiques (04, 05, 06, 07)
    causeway_mask = solid_nat & (np.abs(xx_n - 384) <= 68) & (yy_n >= 380)
    rem_solid = solid_nat & (~causeway_mask)
    lbl_s, n_s = ndimage.label(rem_solid)

    central_island = np.zeros_like(solid_nat, dtype=bool)
    outer_ring = np.zeros_like(solid_nat, dtype=bool)
    for cid in range(1, n_s + 1):
        comp = lbl_s == cid
        if int(comp.sum()) == 0:
            continue
        if comp[260:320, 350:418].any():
            central_island |= comp
        else:
            outer_ring |= comp

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)
    lum = 0.299 * r_c.astype(np.float32) + 0.587 * g_c.astype(np.float32) + 0.114 * b_c.astype(np.float32)

    dist_island_edge = ndimage.distance_transform_edt(central_island)
    arena_floor = (
        ndimage.binary_closing(
            central_island & (yy_n <= 392) & (dist_island_edge >= 8.0) & (lum >= 72.0),
            iterations=2,
        )
        & central_island
    )
    island_skirt = central_island & (~arena_floor)

    cyan_spires = outer_ring & (g_c >= 165) & (b_c >= 180) & ((b_c - r_c) >= 36)
    meteor_ring_wall = outer_ring & (~cyan_spires)
    escarpment_and_ring = meteor_ring_wall | island_skirt

    # Douve annulaire intérieure d'Eau Métano Gelée (4 poses @ 10 ticks)
    moat_under_causeway = (np.abs(xx_n - 384) <= 72) & (yy_n >= 446) & (yy_n <= 504)
    moat_full = inner_moat_nat | (moat_under_causeway & solid_nat)
    water_4, sparkle_4 = build_glacial_metano_water_layers(
        W_NAT,
        H_NAT,
        water_mask=moat_full,
        bridge_mask=solid_nat,
        seed=26202,
    )

    # Blizzard Cyclonique Cylindrique 3D 360° (Ère Glaciaire) autour de la couronne extérieure
    opaque_interior = solid_nat | inner_moat_nat
    dist_solid_outer = ndimage.distance_transform_edt(solid_nat)
    rim_spire_glow = cyan_spires & (dist_solid_outer >= 1.5) & (dist_solid_outer <= 5.0)
    arena_safe = central_island | inner_moat_nat | causeway_mask

    bliz = build_kyurem_cylindrical_blizzard_layers(
        opaque_interior_mask=opaque_interior,
        solid_rock_mask=solid_nat,
        arena_safe_mask=arena_safe,
        rim_spire_glow_mask=rim_spire_glow,
    )

    def mk_static_scaled(mask: np.ndarray) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = rgb_nat[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Grille de marche continue : escalier-chaussée Sud -> arène simple et nue de Glace Noire
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    scale_x, scale_y = W_NAT / float(w), H_NAT / float(h)
    walkable_px = (
        ndimage.binary_erosion(arena_floor, iterations=4)
        | (causeway_mask & (np.abs(xx_n - 384) <= 34))
        | ((np.abs(xx_n - 384) <= 28) & (yy_n >= 340) & (yy_n <= 575) & solid_nat)
    ) & (~mag_nat)

    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        y0_n = int(round(ty * TILE_SIZE * scale_y))
        y1_n = max(y0_n + 1, int(round((ty + 1) * TILE_SIZE * scale_y)))
        for tx in range(gw):
            x0_n = int(round(tx * TILE_SIZE * scale_x))
            x1_n = max(x0_n + 1, int(round((tx + 1) * TILE_SIZE * scale_x)))
            sub_w = walkable_px[y0_n:y1_n, x0_n:x1_n]
            sub_m = mag_nat[y0_n:y1_n, x0_n:x1_n]
            walk_grid[ty, tx] = (not bool(sub_m.any())) and (float(sub_w.mean()) >= 0.55)

    cx_t = gw // 2
    arena_bot_t = int(round(0.56 * gh))
    for ty in range(arena_bot_t, gh):
        walk_grid[ty, max(0, cx_t - 2) : min(gw, cx_t + 2)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry(
            "00_paroi_arriere_et_oeil_blizzard_360",
            "Paroi Arrière Concave & Gouffre du Blizzard 360° (G->D)",
            "BG",
            _resize_frames(bliz["00_paroi_et_gouffre"], w, h),
            frame_length=5,
        ),
        LayerEntry(
            "01_colonnes_tangentes_et_rubans_cryo",
            "Colonnes Latérales & Hélices Ère Glaciaire de Kyurem",
            "BG",
            _resize_frames(bliz["01_colonnes_et_rubans"], w, h),
            frame_length=5,
        ),
        LayerEntry(
            "02_douve_eau_metano_gelee_4phases",
            "Douve Annulaire d'Eau Métano Gelée (4×10t)",
            "BG",
            _resize_frames(water_4, w, h),
            frame_length=10,
        ),
        LayerEntry(
            "03_sparkles_glaciaires_douve_metano",
            "Reflets Scintillants Glaciaires Natifs Metano Town 1× (4×10t)",
            "BG",
            _resize_frames(sparkle_4, w, h),
            frame_length=10,
        ),
        LayerEntry(
            "04_rempart_meteorite_et_escarpement",
            "Rempart Météoritique d'Obsidienne & Escarpement Central",
            "BG",
            [mk_static_scaled(escarpment_and_ring)],
            frame_length=5,
        ),
        LayerEntry(
            "05_chaussee_sud_pierre_et_glace",
            "Escalier-Chaussée Sud→Nord en Pierre Météoritique & Glace",
            "BG",
            [mk_static_scaled(causeway_mask)],
            frame_length=5,
        ),
        LayerEntry(
            "06_plateau_arene_glace_noire",
            "Plateau d'Arène Simple & Nu de Glace Noire (Sanctuaire Kyurem)",
            "BG",
            [mk_static_scaled(arena_floor)],
            frame_length=5,
        ),
        LayerEntry(
            "07_pitons_glace_noire_couronne",
            "Couronne Périphérique de Pitons de Glace Noire Cyan",
            "BG",
            [mk_static_scaled(cyan_spires)],
            frame_length=5,
        ),
        LayerEntry(
            "08_eclats_ere_glaciaire_et_reflets",
            "Éclats Cryo, Reflets des Pitons & Poudreuse GBA W03P03",
            "BG",
            _resize_frames(bliz["08_eclats_et_reflets_bg"], w, h),
            frame_length=5,
        ),
        LayerEntry(
            "09_levre_blizzard_avant_et_neige_top",
            "Lèvre Avant du Blizzard 360° (D->G) & Neige W03P03 Top",
            "Top",
            _resize_frames(bliz["09_levre_blizzard_et_neige_top"], w, h),
            frame_length=5,
        ),
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
        namespace_override="kyurem_sanctuaire_kya1",
        asset_name_override="kyurem_sanctuaire_glace",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
