#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — SCF1 : Gouffre Silencieux — Fond (Silent Chasm End D05P02 / H13P02).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks = `24 × 5`) :
  - `00` (`BG`, 24p) : Faille céleste d'orage au zénith (avant la descente d'Électhor)
  - `01` (`BG`, 24p) : Éclairs dorés d'Électhor zébrant la faille haute
  - `02` (`BG`, 24p) : Gouffre souterrain sans fond & nappes de brouillard GBA `D05P01`
  - `03` (`BG`, 24p) : Cristaux d'abîme `H13P02` & étincelles statiques ascendantes
  - `04` (`BG`,  1p) : Plateau central d'ocre craquelé `D05P02` (sauvetage de Tengalice)
  - `05` (`BG`,  1p) : Chaussée étroite de basalte Sud `H13P02`
  - `06` (`BG`,  1p) : Orgues basaltiques & monolithe sculpté Nord `H13P02`
  - `07` (`BG`,  1p) : Parois rocheuses latérales & colonnes de stalagmites `H13P02`
  - `08` (`BG`, 24p) : Résonance statique sur les chapeaux turquoise des colonnes basaltiques
  - `09` (`Top`,24p) : Pointes de stalagmites, voiles de brume `D05P01` & statique Top
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

from source.moteur_cyclones_cylindriques_unova import H as H_NAT, N_POSES, W as W_NAT, sanitize_rgba_binary
from source.moteur_forets_pmd_red import build_forest_flora_layer_24
from source.moteur_gouffre_et_canyon_pmd_red import build_silent_chasm_layers
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "SCF1"
MAP_TITLE = "Gouffre Silencieux — Fond (Silent Chasm)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_silent_chasm_fin.png"
CANOPY_PATH = HERE / "bruts" / "stalagmites_gouffre_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_silent_chasm_fin.png"
RENDERS_DIR = REPO_ROOT / "renders" / "silent_chasm_fin_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    canopy_nat = np.asarray(Image.open(CANOPY_PATH).convert("RGBA"), dtype=np.uint8)

    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]
    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    sky_mask_nat = mag_nat & (yy_n < 110) & (xx_n >= 220) & (xx_n <= 548)
    abyss_mask_nat = mag_nat & (~sky_mask_nat)
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Chapeaux turquoise-ardoise H13P02 des colonnes basaltiques vibrant d'électricité statique (Calque 08)
    cap_glow_mask = (
        solid_nat
        & (b_c >= 150)
        & (g_c >= 160)
        & (g_c >= r_c + 10)
        & (yy_n >= 24)
        & (yy_n <= 560)
    )

    sky_24, hor_24, aby_24, spk_24, top_fx_24 = build_silent_chasm_layers(
        mode="silent_chasm_end",
        sky_mask=sky_mask_nat,
        abyss_mask=abyss_mask_nat,
        base_rgb=rgb_nat,
    )
    cap_24 = build_forest_flora_layer_24(
        mode="sinister_woods_mist",
        flora_mask=cap_glow_mask,
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
    )

    # Partition disjointe des 4 calques statiques (04, 05, 06, 07)
    is_ochre_arena_surface = (
        solid_nat
        & (xx_n >= 180)
        & (xx_n <= 588)
        & (yy_n >= 155)
        & (yy_n <= 405)
        & (r_c >= 175)
        & (g_c >= 145)
        & (r_c > b_c + 35)
    )

    # Calque 05 : Chaussée étroite Sud (x=312..456, y=355..575)
    is_causeway = (
        solid_nat
        & (~is_ochre_arena_surface)
        & (xx_n >= 312)
        & (xx_n <= 456)
        & (yy_n >= 355)
        & (r_c >= 90)
        & (g_c >= 95)
    )

    # Calque 06 : Orgues basaltiques & monolithe sculpté Nord (x=210..558, y=0..225, hors sol d'ocre)
    is_north_basalt = (
        solid_nat
        & (~is_ochre_arena_surface)
        & (~is_causeway)
        & (xx_n >= 210)
        & (xx_n <= 558)
        & (yy_n <= 225)
    )

    # Calque 04 : Plateau central d'ocre craquelé D05P02 & son rebord d'ardoise
    arena_rim = solid_nat & (~is_causeway) & (~is_north_basalt) & (xx_n >= 180) & (xx_n <= 588) & (yy_n >= 165) & (yy_n <= 465)
    is_arena_plateau = is_ochre_arena_surface | arena_rim

    # Calque 07 : Parois latérales sombres & stalagmites H13P02
    is_side_walls = solid_nat & (~is_arena_plateau) & (~is_causeway) & (~is_north_basalt)

    def mk_static_scaled(mask_bool: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        rgba[mask_bool, :3] = src_rgb[mask_bool]
        rgba[mask_bool, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(rgba))
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    top_24: List[Image.Image] = []
    can_op = canopy_nat[:, :, 3] >= 128
    for f in range(N_POSES):
        arr = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        arr[can_op] = canopy_nat[can_op]
        sp = np.asarray(top_fx_24[f], dtype=np.uint8)
        sp_op = sp[:, :, 3] >= 128
        arr[sp_op] = sp[sp_op]
        top_24.append(Image.fromarray(sanitize_rgba_binary(arr)))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_nat = is_ochre_arena_surface | ((xx_n >= 340) & (xx_n <= 428) & (yy_n >= 340) & solid_nat)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    arena_center_t = int(round(0.46 * gh))
    for ty in range(arena_center_t, gh):
        walk_grid[ty, max(0, cx_t - 3) : min(gw, cx_t + 3)] = True
    walk_grid[:4, :] = False
    walk_grid[:, :4] = False
    walk_grid[:, -4:] = False

    layers = [
        LayerEntry("00_faille_celeste_orage_zenith", "Faille Céleste d'Orage au Zénith", "BG", _resize_frames(sky_24, w, h), frame_length=5),
        LayerEntry("01_eclairs_electhor_faille_haute", "Éclairs Dorés d'Électhor dans la Faille Haute", "BG", _resize_frames(hor_24, w, h), frame_length=5),
        LayerEntry("02_gouffre_souterrain_brouillard_d05", "Gouffre Souterrain & Nappes GBA D05P01", "BG", _resize_frames(aby_24, w, h), frame_length=5),
        LayerEntry("03_cristaux_h13_etincelles_electhor", "Cristaux d'Abîme H13P02 & Étincelles d'Électhor", "BG", _resize_frames(spk_24, w, h), frame_length=5),
        LayerEntry("04_plateau_ocre_craquele_d05p02", "Plateau Central d'Ocre Craquelé D05P02 (Tengalice)", "BG", [mk_static_scaled(is_arena_plateau)], frame_length=5),
        LayerEntry("05_chaussee_basalte_sud_h13p02", "Chaussée Étroite de Basalte Sud H13P02", "BG", [mk_static_scaled(is_causeway)], frame_length=5),
        LayerEntry("06_orgues_basaltiques_monolithe_nord", "Orgues Basaltiques & Monolithe Nord H13P02", "BG", [mk_static_scaled(is_north_basalt)], frame_length=5),
        LayerEntry("07_parois_sombres_stalagmites_h13p02", "Parois Latérales & Stalagmites H13P02", "BG", [mk_static_scaled(is_side_walls)], frame_length=5),
        LayerEntry("08_resonance_statique_colonnes", "Résonance Statique sur les Colonnes Basaltiques", "BG", _resize_frames(cap_24, w, h), frame_length=5),
        LayerEntry("09_stalagmites_brume_d05_top", "Stalagmites Hautes, Brume D05P01 & Statique Top", "Top", _resize_frames(top_24, w, h), frame_length=5),
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
        namespace_override="silent_chasm_scf1",
        asset_name_override="silent_chasm_fin",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
