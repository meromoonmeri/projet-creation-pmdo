#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur PMDO 0.8.12.0 — RUA1 : Île Finale — Archipel Céleste de Mew (`H29P04`).

Layout fidèle à la Zone d'Accueil officielle de Mew `H29P04` (*Final Island*, `768 × 576`,
archipel ouvert ciel + mer céleste sans mur annulaire : `1` île-prairie centrale + `11` îlots flottants) :
  - `00` (`BG`,  1p) : Ciel céruléen & horizon de cumulus `H29P04` `100 %` statiques (`1` pose)
  - `01` (`BG`,  4p) : Mer Céleste Metano Town (`Metano_Town_River`, `y >= 144`, `4 × 10t`)
  - `02` (`BG`,  4p) : Scintillements marins `1×` natifs `Metano_Town_River_Sparkles.tile` (`4 × 10t`)
  - `03` (`BG`, 24p) : 11 Îlots Rocheux & Herbeux en Lévitation Douce (`H29P04`, `24 × 5t`)
  - `04` (`BG`,  1p) : Soubassement rocheux conique suspendu de l'Île Finale (`1` pose)
  - `05` (`BG`,  1p) : Rampe herbeuse Sud d'accès au plateau (`1` pose)
  - `06` (`BG`,  1p) : Prairie d'émeraude nue & sceau circulaire affleurant de Mew (`0` objet)
  - `07` (`BG`,  1p) : Couronne rocheuse crénelée ceinturant la prairie (`H29P04`, `1` pose)
  - `08` (`BG`, 24p) : Fleurs de prairie Metano & nacre irisée du sceau antique (`24 × 5t`)
  - `09` (`Top`,24p) : Bulles psychiques rose-nacré & poussière d'or de Mew Top (`24 × 5t`)
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
    assemble_rua1_brut,
    build_final_island_static_sky_horizon,
    build_rua1_floating_islets_flowers_and_mew_bubbles,
    build_themed_metano_water_layers,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "RUA1"
MAP_TITLE = "Ruines Enfouies 99É — Île Finale & Archipel Céleste de Mew (H29P04)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_ruines_enfouies_sanctuaire.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_ruines_enfouies_sanctuaire.png"
RENDERS_DIR = REPO_ROOT / "renders" / "ruines_enfouies_sanctuaire_v1"
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
        assemble_rua1_brut(HERE)

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]

    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    solid_nat = ~mag_nat

    # Sépare l'île centrale (plus grande composante connexe) des 11 îlots périphériques flottants
    lbl_raw, n_comp = ndimage.label(solid_nat)
    sizes = ndimage.sum(solid_nat, lbl_raw, range(1, n_comp + 1)) if n_comp > 0 else []
    main_lbl = int(np.argmax(sizes) + 1) if len(sizes) > 0 else 1
    central_island = lbl_raw == main_lbl
    lbl = np.zeros_like(lbl_raw)
    lbl[central_island] = 1
    next_id = 2
    for cid in range(1, n_comp + 1):
        if cid != main_lbl:
            lbl[lbl_raw == cid] = next_id
            next_id += 1

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Ciel céruléen + horizon de cumulus 100 % statiques (1 pose, respectant la règle nuages statiques)
    sky_static_1 = [build_final_island_static_sky_horizon(W_NAT, H_NAT)]

    # Mer céleste Metano Town lointaine sous tout l'archipel flottant (y >= 144, zéro écume de rivage car l'île lévite !)
    sea_mask_nat = yy_n >= 144
    water_4, sparkle_4 = build_themed_metano_water_layers(
        W_NAT,
        H_NAT,
        water_mask=sea_mask_nat,
        pal_key="celestial",
        shore_foam=False,
        seed=27152,
    )

    # Partitionne l'île centrale en 4 sous-couches architecturales nettes (04..07)
    is_lush_grass = central_island & (g_c >= r_c + 24) & (g_c >= b_c + 34) & (g_c >= 112)
    is_stone_seal = (
        central_island
        & (yy_n >= 140)
        & (yy_n <= 286)
        & (np.abs(xx_n - 384) <= 96)
        & (r_c >= 136)
        & (g_c >= 146)
        & (b_c >= 148)
    )

    # 05 : Rampe herbeuse Sud d'accès au plateau (y >= 348, couloir central)
    south_ramp = central_island & (yy_n >= 348) & (np.abs(xx_n - 384) <= 58) & (is_lush_grass | (g_c >= 104))

    # 06 : Prairie d'émeraude nue & sceau circulaire affleurant de Mew (plateau y < 380)
    raw_meadow = central_island & (~south_ramp) & (yy_n >= 84) & (yy_n <= 386) & (is_lush_grass | is_stone_seal)
    meadow_and_seal = ndimage.binary_closing(raw_meadow, iterations=2) & central_island & (~south_ramp)

    # 04 : Soubassement rocheux conique suspendu sous l'île (y >= 332 hors rampe et prairie)
    island_underbelly = central_island & (~south_ramp) & (~meadow_and_seal) & (yy_n >= 332)

    # 07 : Couronne rocheuse crénelée ceinturant la prairie (complément exact sur l'île centrale)
    craggy_rim = central_island & (~south_ramp) & (~meadow_and_seal) & (~island_underbelly)

    # Anneau extérieur du sceau antique pour un reflet nacré subtil (centre laissé nu)
    seal_ring_mask = is_stone_seal & (~ndimage.binary_erosion(is_stone_seal, iterations=6))
    arena_center_clear = np.hypot(xx_n - 384, yy_n - 208) <= 98

    islets_24, lay8_24, top9_24 = build_rua1_floating_islets_flowers_and_mew_bubbles(
        rgb_nat=rgb_nat,
        islets_comp_labels=lbl,
        num_islets=next_id - 1,
        meadow_ring_mask=meadow_and_seal & (~is_stone_seal),
        seal_ring_mask=seal_ring_mask,
        arena_center_clear=arena_center_clear,
    )

    def mk_static_scaled(mask: np.ndarray) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = rgb_nat[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Grille de marche continue : Rampe Sud -> Prairie d'émeraude & Sceau de Mew
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_nat = ndimage.binary_erosion(meadow_and_seal | south_ramp, iterations=3)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    seal_top_t = int(round(132 * gh / H_NAT))
    for ty in range(seal_top_t, gh):
        walk_grid[ty, cx_t - 2 : cx_t + 2] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry(
            "00_ciel_et_horizon_h29p04_statique",
            "Ciel Céruléen & Horizon de Cumulus H29P04 100 % Statiques (1p)",
            "BG",
            _resize_frames(sky_static_1, w, h),
            frame_length=5,
        ),
        LayerEntry(
            "01_mer_celeste_metano_4p",
            "Mer Céleste Metano Town sous l'Archipel (Metano_Town_River, 4×10t)",
            "BG",
            _resize_frames(water_4, w, h),
            frame_length=10,
        ),
        LayerEntry(
            "02_sparkles_mer_celeste_1x",
            "Scintillements Marins Natifs Metano Town 1× (4×10t)",
            "BG",
            _resize_frames(sparkle_4, w, h),
            frame_length=10,
        ),
        LayerEntry(
            "03_onze_ilots_flottants_h29p04",
            "11 Îlots Rocheux & Herbeux en Lévitation Douce (H29P04, 24×5t)",
            "BG",
            _resize_frames(islets_24, w, h),
            frame_length=5,
        ),
        LayerEntry(
            "04_socle_rocheux_ile_finale",
            "Soubassement Rocheux Conique Suspendu de l'Île Finale",
            "BG",
            [mk_static_scaled(island_underbelly)],
            frame_length=5,
        ),
        LayerEntry(
            "05_rampe_herbeuse_sud",
            "Rampe Herbeuse Sud d'Accès au Sanctuaire de Mew",
            "BG",
            [mk_static_scaled(south_ramp)],
            frame_length=5,
        ),
        LayerEntry(
            "06_prairie_emeraude_et_sceau_mew",
            "Prairie d'Émeraude Nue & Sceau Circulaire Affleurant de Mew (0 Objet)",
            "BG",
            [mk_static_scaled(meadow_and_seal)],
            frame_length=5,
        ),
        LayerEntry(
            "07_couronne_rocheuse_crenelee",
            "Couronne Rocheuse Crénelée Ceinturant la Prairie (H29P04)",
            "BG",
            [mk_static_scaled(craggy_rim)],
            frame_length=5,
        ),
        LayerEntry(
            "08_fleurs_metano_et_nacre_sceau",
            "Fleurs de Prairie Metano & Reflet Nacré du Sceau Antique",
            "BG",
            _resize_frames(lay8_24, w, h),
            frame_length=5,
        ),
        LayerEntry(
            "09_bulles_rose_nacre_mew_top",
            "Bulles Psychiques Rose-Nacré & Poussière d'Or de Mew Top",
            "Top",
            _resize_frames(top9_24, w, h),
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
        namespace_override="ruines_enfouies_rua1",
        asset_name_override="ruines_enfouies_sanctuaire_mew",
    )
    _write_halcyon_ground_script(out_dir / "package", "ruines_enfouies_sanctuaire_mew")
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
