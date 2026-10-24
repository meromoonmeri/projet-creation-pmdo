#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur PMDO 0.8.12.0 — MWA1 : Grotte Ouest 99É — Gouffre Stalagmitique de Mewtwo (`H13P02`).

Layout fidèle à la Zone d'Accueil officielle de Mewtwo `H13P02` (*Cryptic Cave*, `768 × 576`, `0 %` ciel,
aucun anneau circulaire ni douve : double abîme latéral `#FF00FF` + étroite arête rocheuse Sud→Nord +
promontoire hexagonal 100 % simple et nu + mur d'orgues stalagmitiques Nord) :
  - `00` (`BG`, 24p) : Abîme noir-ardoise `H13P02` & nappes psychiques profondes (`24 × 5t`)
  - `01` (`BG`, 24p) : Courants télékinétiques jade-cyan dans les deux failles latérales (`24 × 5t`)
  - `02` (`BG`,  4p) : Ondes graves de résonance au fond du gouffre (`4 × 10t`)
  - `03` (`BG`,  4p) : Éclats cristallins lointains dans l'abîme (`4 × 10t`)
  - `04` (`BG`,  1p) : Parois latérales d'ardoise sombre & soubassement de l'éperon (`1` pose)
  - `05` (`BG`,  1p) : Arête rocheuse naturelle Sud→Nord franchissant le gouffre (`1` pose)
  - `06` (`BG`,  1p) : Promontoire d'arène hexagonal simple et nu en pierre gris-jade (`0` objet)
  - `07` (`BG`,  1p) : Grand mur d'orgues stalagmitiques Nord & crocs de premier plan (`H13P02`)
  - `08` (`BG`, 24p) : Fragments de roche en lévitation & facettes cristal jade-cyan (`24 × 5t`)
  - `09` (`Top`,24p) : Étoiles psychiques à 4 branches `H13P02` au-dessus de l'abîme Top (`24 × 5t`)
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
from source.moteur_kanto_mewtwo_mew import (
    H_CANON as H_NAT,
    TILE_SIZE,
    W_CANON as W_NAT,
    assemble_mwa1_brut,
    build_mwa1_cryptic_chasm_layers,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "MWA1"
MAP_TITLE = "Grotte Ouest 99É — Gouffre Stalagmitique de Mewtwo (H13P02)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_grotte_ouest_sanctuaire.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_grotte_ouest_sanctuaire.png"
RENDERS_DIR = REPO_ROOT / "renders" / "grotte_ouest_sanctuaire_v1"
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
        assemble_mwa1_brut(HERE)

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]

    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Poches sombres de fond de caverne (< 28) laissées transparentes sur les solides pour voir le gouffre 00
    deep_void_pockets = solid_nat & (r_c <= 28) & (g_c <= 30) & (b_c <= 36) & (np.abs(xx_n - 384) >= 136)
    rock_solid = solid_nat & (~deep_void_pockets)

    # 1) Calque 06 : Promontoire hexagonal nu central de Mewtwo (y=118..258, x=284..472, pierre pâle gris-jade)
    raw_hex_plateau = (
        rock_solid
        & (yy_n >= 116)
        & (yy_n <= 258)
        & (xx_n >= 282)
        & (xx_n <= 474)
        & (r_c >= 145)
        & (g_c >= 165)
        & ((g_c - r_c) <= 32)
    )
    hex_plateau = ndimage.binary_closing(raw_hex_plateau, iterations=2) & rock_solid

    # 2) Calque 05 : Étroite arête rocheuse naturelle Sud->Nord & éperon d'arrivée Sud (H13P02)
    in_ridge_box = (yy_n > 250) & (np.abs(xx_n - 388) <= 92)
    raw_ridge = (
        rock_solid
        & (~hex_plateau)
        & in_ridge_box
        & (r_c >= 105)
        & (g_c >= 108)
        & ((g_c - r_c) <= 32)
    )
    ridge_path = ndimage.binary_closing(raw_ridge, iterations=2) & rock_solid & (~hex_plateau)

    # 3) Calque 07 : Grand mur d'orgues stalagmitiques Nord & aiguilles de cristal jade-cyan avant-plan
    organ_stalagmites = (
        rock_solid
        & (~hex_plateau)
        & (~ridge_path)
        & (
            (yy_n < 210)
            | ((g_c >= 140) & (b_c >= 120))
            | ((yy_n >= 360) & (np.abs(xx_n - 388) >= 76) & (r_c >= 88))
        )
    )

    # 4) Calque 04 : Parois latérales d'ardoise sombre & soubassement de l'éperon (complément exact)
    slate_chasm_walls = rock_solid & (~hex_plateau) & (~ridge_path) & (~organ_stalagmites)

    walk_safe_nat = hex_plateau | ridge_path
    chasm_dict = build_mwa1_cryptic_chasm_layers(
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
        chasm_mask=mag_nat,
        walk_safe_mask=walk_safe_nat,
    )

    def mk_static_scaled(mask: np.ndarray) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = rgb_nat[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Grille de marche continue : Éperon Sud -> Arête étroite -> Promontoire hexagonal nu de Mewtwo
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_eroded = ndimage.binary_erosion(walk_safe_nat, iterations=4)
    walk_img = Image.fromarray((walk_eroded.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = int(round(390 * gw / W_NAT))
    hex_top_t = int(round(136 * gh / H_NAT))
    for ty in range(hex_top_t, gh):
        walk_grid[ty, max(2, cx_t - 2) : min(gw - 2, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry(
            "00_gouffre_cryptic_cave",
            "Gouffre Abyssal Noir-Ardoise H13P02 & Nappes Psychiques (24×5t)",
            "BG",
            _resize_frames(chasm_dict["00_gouffre_cryptic_cave"], w, h),
            frame_length=5,
        ),
        LayerEntry(
            "01_courants_telekinetiques",
            "Courants Télékinétiques Jade-Cyan dans l'Abîme Latéral (24×5t)",
            "BG",
            _resize_frames(chasm_dict["01_courants_telekinetiques"], w, h),
            frame_length=5,
        ),
        LayerEntry(
            "02_ondes_abime_profond",
            "Ondes Graves de Résonance au Fond des Failles (4×10t)",
            "BG",
            _resize_frames(chasm_dict["02_ondes_abime_profond"], w, h),
            frame_length=10,
        ),
        LayerEntry(
            "03_eclats_cristallins_abime",
            "Éclats Cristallins Lointains dans l'Abîme (4×10t)",
            "BG",
            _resize_frames(chasm_dict["03_eclats_cristallins_abime"], w, h),
            frame_length=10,
        ),
        LayerEntry(
            "04_parois_ardoise_gouffre",
            "Parois Latérales d'Ardoise Sombre & Socle de l'Éperon",
            "BG",
            [mk_static_scaled(slate_chasm_walls)],
            frame_length=5,
        ),
        LayerEntry(
            "05_arete_rocheuse_sud_nord",
            "Arête Rocheuse Naturelle Sud→Nord sur l'Abîme (H13P02)",
            "BG",
            [mk_static_scaled(ridge_path)],
            frame_length=5,
        ),
        LayerEntry(
            "06_promontoire_hexagonal_nu",
            "Promontoire Hexagonal Simple & Nu de Mewtwo (0 Objet)",
            "BG",
            [mk_static_scaled(hex_plateau)],
            frame_length=5,
        ),
        LayerEntry(
            "07_orgue_stalagmites_jade_h13p02",
            "Cathédrale d'Orgues Stalagmitiques Nord & Crocs Jade (H13P02)",
            "BG",
            [mk_static_scaled(organ_stalagmites)],
            frame_length=5,
        ),
        LayerEntry(
            "08_levitation_roches_et_facettes",
            "Fragments Rocheux en Lévitation & Pulsation des Couronnes Jade",
            "BG",
            _resize_frames(chasm_dict["08_levitation_roches_et_facettes"], w, h),
            frame_length=5,
        ),
        LayerEntry(
            "09_etoiles_psychiques_h13p02_top",
            "Étoiles Psychiques à 4 Branches H13P02 au-dessus de l'Abîme Top",
            "Top",
            _resize_frames(chasm_dict["09_etoiles_psychiques_h13p02_top"], w, h),
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
        namespace_override="grotte_ouest_mwa1",
        asset_name_override="grotte_ouest_sanctuaire_mewtwo",
    )
    _write_halcyon_ground_script(out_dir / "package", "grotte_ouest_sanctuaire_mewtwo")
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
