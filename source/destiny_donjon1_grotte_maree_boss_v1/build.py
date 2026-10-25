#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur PMDO 0.8.12.0 — DSB1 : 1er Donjon (Boss) — Cœur Rocheux de l'Écho Marin (PMD : Destiny).

Architecture `768 × 576` (`96 × 72` tuiles `8×8`), `10` calques (`9 BG` + `1 Top`), `0 %` ciel :
  - `00` (`BG`,  1p) : Fosse rocheuse abyssale sous-marine (`0 %` ciel)
  - `01` (`BG`,  4p) : Eau Abyssale Bioluminescente Métano (`Metano_Town_River_Animation_1..4.tile`, `4×10t`)
  - `02` (`BG`,  4p) : Scintillements Abyssaux `1×` Natifs (`Metano_Town_River_Sparkles.tile`, `4×10t`)
  - `03` (`BG`,  3p) : 2 Cascades Géantes Canoniques `1×` *Foggy Forest* (`P03P01A`, `3×10t`)
  - `04` (`BG`,  1p) : Rempart rocheux externe & stalagmites *Boulder Cave* (`0 %` ciel)
  - `05` (`BG`,  1p) : Seuil rocheux Sud & escalier de pierre franchissant la douve
  - `06` (`BG`,  1p) : Grande arène circulaire nue en roche humide (`0` obstacle sur la dalle !)
  - `07` (`BG`,  1p) : Autel rocheux étagé Nord & Sceau Spiral de l'Écho Marin
  - `08` (`BG`, 24p) : VFX Multi-Frames — Spirale runique pulsante, onde d'arène & 2 geysers (`24×5t`)
  - `09` (`Top`,24p) : VFX Multi-Frames — Anneaux soniques d'Écho Marin & bulles luminescentes Top (`24×5t`)
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
from source.moteur_destiny_chapitre1_maps import (
    H_CANON as H_NAT,
    TILE_SIZE,
    W_CANON as W_NAT,
    assemble_destiny_brut,
    build_canonical_metano_liquid_layers,
    build_dsb1_vfx_layers,
    build_placed_p03p01a_cascades,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "DSB1"
MAP_TITLE = "PMD : Destiny — Cœur Rocheux de l'Écho Marin · Arène Boss du 1er Donjon"

HERE = Path(__file__).resolve().parent
RAW_MAGENTA = HERE / "bruts" / "decor_grotte_maree_boss_magenta.png"
BRUT_PATH = HERE / "bruts" / "base_grotte_maree_boss.png"
CANON_REF = HERE / "references" / "ref_canon_grotte_maree_boss.png"
RENDERS_DIR = REPO_ROOT / "renders" / "destiny_donjon1_grotte_maree_boss_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def _write_halcyon_ground_script(pkg_dir: Path, ground_id: str) -> None:
    hdir = pkg_dir / "Data" / "Script" / "halcyon" / "ground" / ground_id
    hdir.mkdir(parents=True, exist_ok=True)
    (hdir / "init.lua").write_text(
        f"require 'origin.common'\n"
        f"local {ground_id} = {{}}\n"
        f"function {ground_id}.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies() end\n"
        f"function {ground_id}.Enter(map) GAME:FadeIn(20) end\n"
        f"function {ground_id}.Exit(map) end\n"
        f"function {ground_id}.Update(map) end\n"
        f"function {ground_id}.GameSave(map) end\n"
        f"function {ground_id}.GameLoad(map) GAME:FadeIn(20) end\n"
        f"return {ground_id}\n",
        encoding="utf-8",
    )


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    if not BRUT_PATH.is_file() or not CANON_REF.is_file():
        assemble_destiny_brut(
            RAW_MAGENTA, BRUT_PATH, CANON_REF, pal_key="abyssal_echo", heal_boss_pebble=True
        )

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8).copy()
    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]

    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    water_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    # 1) Eau abyssale bioluminescente Métano + Sparkles 1× (4×10t)
    water_4, sparkle_4 = build_canonical_metano_liquid_layers(
        W_NAT, H_NAT, water_mask=water_mask_nat, pal_key="abyssal_echo", seed=28401
    )

    # Segmentation rocheuse Boulder Cave / Brine Cave (sans trou)
    ell_arena = np.hypot((xx_n - 384.0) / 248.0, (yy_n - 318.0) / 146.0)
    is_south_stairs = solid_nat & (yy_n >= 424) & (xx_n >= 220) & (xx_n <= 548)
    is_arena_slab = solid_nat & (~is_south_stairs) & (ell_arena <= 1.02) & (yy_n >= 198)
    is_north_altar = solid_nat & (~is_arena_slab) & (yy_n < 218) & (xx_n >= 210) & (xx_n <= 558)
    is_outer_amphitheater = solid_nat & (~is_south_stairs) & (~is_arena_slab) & (~is_north_altar)

    # 2) 2 cascades géantes canoniques 1× Foggy Forest P03P01A tombant dans les ailes de la douve
    cascade_specs = [
        (118, 212, 292, "medium_48", 0),
        (650, 212, 292, "medium_48", 1),
    ]
    cascades_3 = build_placed_p03p01a_cascades(
        w, h, specs=cascade_specs, fg_rgb_mut=rgb_nat, solid_mask=solid_nat, exclude_mask=is_arena_slab
    )

    # 3) VFX Multi-Frames (24×5t) : spirale runique de l'autel, onde d'arène, geysers & anneaux soniques
    arena_top_flat = ndimage.binary_erosion(is_arena_slab & (yy_n <= 410), iterations=8)
    bg_vfx_24, top_vfx_24 = build_dsb1_vfx_layers(w, h, solid_nat, arena_top_flat, water_mask_nat)

    underlay = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    underlay[:, :] = (8, 24, 54, 255)
    underlay_1 = [Image.fromarray(underlay, mode="RGBA")]

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = rgb_nat[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    south_corridor = (xx_n >= 346) & (xx_n <= 422) & (yy_n >= 412)
    walk_nat = arena_top_flat | (south_corridor & solid_nat)
    walk_grid = np.asarray(
        Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    ) >= 128
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_fosse_abyssale_boss", "Fosse Rocheuse Abyssale Sous-Marine (0 % Ciel)", "BG", _resize_frames(underlay_1, w, h), frame_length=5),
        LayerEntry("01_eau_abyssale_metano_echo", "Eau Abyssale Bioluminescente Métano (4×10t)", "BG", _resize_frames(water_4, w, h), frame_length=10),
        LayerEntry("02_sparkles_abyssaux_metano_1x", "Scintillements Abyssaux Natifs Metano Town 1× (4×10t)", "BG", _resize_frames(sparkle_4, w, h), frame_length=10),
        LayerEntry("03_rempart_stalagmites_boulder_cave", "Rempart Rocheux Externe & Stalagmites Boulder Cave (0 % Ciel)", "BG", [mk_static(is_outer_amphitheater)], frame_length=5),
        LayerEntry("04_autel_nord_sceau_spiral", "Autel Rocheux Étagé Nord & Sceau Spiral de l'Écho Marin", "BG", [mk_static(is_north_altar)], frame_length=5),
        LayerEntry("05_cascades_amphitheatre_p03p01a", "2 Cascades Géantes Natives 1× Foggy Forest P03P01A (3×10t)", "BG", cascades_3, frame_length=10),
        LayerEntry("06_arene_circulaire_roche_nue", "Grande Arène Circulaire Nue en Roche Humide (0 Obstacle)", "BG", [mk_static(is_arena_slab)], frame_length=5),
        LayerEntry("07_escalier_rocheux_sud", "Seuil Rocheux Sud & Escalier Franchissant la Douve", "BG", [mk_static(is_south_stairs)], frame_length=5),
        LayerEntry("08_vfx_spirale_autel_onde_et_geysers", "VFX Multi-Frames : Spirale Pulsante, Onde d'Arène & Geysers (24×5t)", "BG", bg_vfx_24, frame_length=5),
        LayerEntry("09_vfx_anneaux_soniques_et_bulles_top", "VFX Multi-Frames : Anneaux Soniques d'Écho Marin & Bulles Top (24×5t)", "Top", top_vfx_24, frame_length=5),
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
        namespace_override="pmd_destiny_dsb1",
        asset_name_override="destiny_grotte_maree_boss",
    )
    _write_halcyon_ground_script(out_dir / "package", "destiny_grotte_maree_boss")
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    print(json.dumps(build(), indent=2, ensure_ascii=False))
