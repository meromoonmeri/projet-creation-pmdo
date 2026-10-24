#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — RSA1 : Sommet Mt. Thunder — Cyclone Cylindrique Flamme Blanche 360° (Reshiram).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks) :
  - Sommet rocheux naturel solaire `1×` style *Mt. Thunder Summit* (`thunder.png` + `D06P01`) centré dans l'œil :
    jupe d'escarpement vertical doré, pitons coniques périphériques, plateau d'arène craquelé dégagé au centre
    et arête/escalier rocheux Sud menant du bord Sud jusqu'au sommet (`4` calques statiques `1` pose).
  - Cyclone cylindrique creux 3D à `360°` animé autour du sommet (`24` poses @ `5` ticks) :
    paroi interne arrière concave défilant de Gauche -> Droite, colonnes tangentielles Ouest/Est,
    rubans hélicoïdaux de Flamme Blanche (`Flamme Croix`) & Flamme Bleue, braises matérielles GBA `W04` +
    `H19P01`, reflets incandescents sur les crêtes, et lèvre avant en surplomb `Top` défilant en sens
    inverse (Droite -> Gauche) pour fermer le cylindre ardent en 3D autour du joueur.
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

from source.moteur_cyclones_cylindriques_unova import (
    H as H_NAT,
    W as W_NAT,
    build_cylindrical_cyclone_layers,
    sanitize_rgba_binary,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "RSA1"
MAP_TITLE = "Sommet Mt. Thunder — Cyclone Cylindrique Flamme Blanche 360° (Reshiram)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_reshiram_sommet_flamme.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_reshiram_sommet_flamme.png"
RENDERS_DIR = REPO_ROOT / "renders" / "reshiram_sommet_flamme_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def _merge_frame_lists(a_list: List[Image.Image], b_list: List[Image.Image]) -> List[Image.Image]:
    merged: List[Image.Image] = []
    for a_im, b_im in zip(a_list, b_list):
        c = a_im.copy()
        c.alpha_composite(b_im)
        merged.append(c)
    return merged


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]

    vortex_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    rock_nat = ~vortex_nat

    lum = (
        0.299 * rgb_nat[:, :, 0].astype(np.float32)
        + 0.587 * rgb_nat[:, :, 1].astype(np.float32)
        + 0.114 * rgb_nat[:, :, 2].astype(np.float32)
    )
    is_south_stairs = rock_nat & (yy_n >= 388) & (np.abs(xx_n - 384) <= 74)
    dist_void = ndimage.distance_transform_edt(rock_nat)
    is_plateau_floor = (
        rock_nat
        & (~is_south_stairs)
        & (yy_n <= 394)
        & (dist_void >= 12.0)
        & (lum >= 148.0)
    )
    is_plateau_floor = ndimage.binary_closing(is_plateau_floor, iterations=2) & rock_nat & (~is_south_stairs)
    is_spires_rim = rock_nat & (~is_south_stairs) & (~is_plateau_floor) & (yy_n < 350)
    is_cliff_skirt = rock_nat & (~is_south_stairs) & (~is_plateau_floor) & (~is_spires_rim)

    rim_glow_mask = rock_nat & (dist_void >= 1.5) & (dist_void <= 4.5) & (yy_n < 448)
    arena_safe_mask = rock_nat & (yy_n <= 462)

    cyc = build_cylindrical_cyclone_layers(
        mode="reshiram_white_flame",
        opaque_terrain_mask=rock_nat,
        arena_safe_mask=arena_safe_mask,
        rim_glow_mask=rim_glow_mask,
    )

    l0_wall_abyss = _merge_frame_lists(cyc["00_gouffre"], cyc["01_paroi_arriere"])
    l1_cols_helix = _merge_frame_lists(cyc["02_colonnes_laterales"], cyc["03_rubans_helicoidaux"])

    def mk_static_scaled(mask: np.ndarray) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = rgb_nat[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    scale_x, scale_y = W_NAT / float(w), H_NAT / float(h)
    walk_grid = np.zeros((gh, gw), dtype=bool)
    walkable_px = (is_plateau_floor | (is_south_stairs & (np.abs(xx_n - 384) <= 36))) & (~vortex_nat)
    for ty in range(gh):
        y0_n = int(round(ty * TILE_SIZE * scale_y))
        y1_n = max(y0_n + 1, int(round((ty + 1) * TILE_SIZE * scale_y)))
        for tx in range(gw):
            x0_n = int(round(tx * TILE_SIZE * scale_x))
            x1_n = max(x0_n + 1, int(round((tx + 1) * TILE_SIZE * scale_x)))
            sub_w = walkable_px[y0_n:y1_n, x0_n:x1_n]
            sub_v = vortex_nat[y0_n:y1_n, x0_n:x1_n]
            if float(sub_w.mean()) >= 0.45 and float(sub_v.mean()) == 0.0:
                walk_grid[ty, tx] = True

    cx_t = gw // 2
    arena_center_t = max(3, int(round(0.30 * gh)))
    for ty in range(arena_center_t, gh):
        walk_grid[ty, max(0, cx_t - 2) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_paroi_arriere_et_oeil_ardent", "Paroi Arrière Concave & Gouffre du Cylindre (G->D)", "BG", _resize_frames(l0_wall_abyss, w, h), frame_length=5),
        LayerEntry("01_colonnes_et_flamme_blanche_360", "Colonnes Latérales & Hélices de Flamme Blanche / Bleue", "BG", _resize_frames(l1_cols_helix, w, h), frame_length=5),
        LayerEntry("02_braises_gba_w04_et_flamme_croix", "Braises GBA W04 / H19P01 & Rubans Flamme Croix", "BG", _resize_frames(cyc["04_decharges_ou_braises"], w, h), frame_length=5),
        LayerEntry("03_escarpement_falaise_solaire", "Escarpement Vertical Mt. Thunder Summit 1×", "BG", [mk_static_scaled(is_cliff_skirt)], frame_length=5),
        LayerEntry("04_pitons_et_rebords_solaires", "Pitons Coniques & Crêtes Mt. Thunder Summit 1×", "BG", [mk_static_scaled(is_spires_rim)], frame_length=5),
        LayerEntry("05_plateau_arene_mont_thunder_summit", "Plateau Naturel Mt. Thunder Summit 1×", "BG", [mk_static_scaled(is_plateau_floor)], frame_length=5),
        LayerEntry("06_eperon_et_escalier_rocheux_sud", "Éperon Rocheux & Escalier Sud 1×", "BG", [mk_static_scaled(is_south_stairs)], frame_length=5),
        LayerEntry("07_reflets_flamme_blanche_rebords", "Reflets Incandescents sur les Crêtes & Pitons", "BG", _resize_frames(cyc["07_reflets_rebords"], w, h), frame_length=5),
        LayerEntry("08_levre_avant_cylindre_flamme_top", "Lèvre Avant du Cyclone Cylindrique Top (D->G)", "Top", _resize_frames(cyc["08_levre_avant_top"], w, h), frame_length=5),
        LayerEntry("09_flammeches_avant_plan_cyclone_top", "Flammèches & Plasma d'Avant-Plan Top (D->G)", "Top", _resize_frames(cyc["09_arcs_avant_top"], w, h), frame_length=5),
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
        namespace_override="reshiram_sommet_rsa1",
        asset_name_override="reshiram_sommet_flamme",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
