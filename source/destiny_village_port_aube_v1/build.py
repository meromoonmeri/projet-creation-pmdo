#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur PMDO 0.8.12.0 — DSV1 : Bourg-Écume — Village Portuaire des Explorateurs (PMD : Destiny).

Architecture `768 × 576` (`96 × 72` tuiles `8×8`), `10` calques (`9 BG` + `1 Top`), `0 %` ciel :
  - `00` (`BG`,  1p) : Assise sous-marine turquoise du port (`0 %` ciel)
  - `01` (`BG`,  4p) : Eau Portuaire Métano Turquoise (`Metano_Town_River_Animation_1..4.tile`, `4×10t`)
  - `02` (`BG`,  4p) : Scintillements Solaires `1×` Natifs (`Metano_Town_River_Sparkles.tile`, `4×10t`)
  - `03` (`BG`,  3p) : 2 Cascades Côtières Canoniques `1×` *Foggy Forest* (`P03P01A`, `3×10t`)
  - `04` (`BG`,  1p) : Quai en bois des explorateurs, parvis pavé & Fontaine de l'Œuf Ailé
  - `05` (`BG`,  1p) : Pelouse d'émeraude canonique (*Vast Steppe*), huttes Pokémon, caisses & tableau
  - `06` (`BG`,  1p) : Falaise étagée de grès doré (*Altere Pond*, `0 %` ciel) & grand escalier Nord
  - `07` (`BG`,  4p) : Fleurs Sauvages Animées Canoniques `1×` *Vast Steppe* (`4×12t`)
  - `08` (`BG`, 24p) : VFX Multi-Frames — Jet d'eau & ondes de la Fontaine + ressac des pilotis (`24×5t`)
  - `09` (`Top`,24p) : Couronnes feuillues hautes des huttes + VFX Lanternes dorées & Bulles d'écume (`24×5t`)
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
    build_dsv1_vfx_layers,
    build_placed_p03p01a_cascades,
    build_vast_steppe_flowers_layer,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "DSV1"
MAP_TITLE = "PMD : Destiny — Bourg-Écume · Village Portuaire des Explorateurs"

HERE = Path(__file__).resolve().parent
RAW_MAGENTA = HERE / "bruts" / "decor_village_port_magenta.png"
BRUT_PATH = HERE / "bruts" / "base_village_port_aube.png"
CANON_REF = HERE / "references" / "ref_canon_village_port_aube.png"
RENDERS_DIR = REPO_ROOT / "renders" / "destiny_village_port_aube_v1"
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
        assemble_destiny_brut(RAW_MAGENTA, BRUT_PATH, CANON_REF, pal_key="harbor_turquoise")

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8).copy()
    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]

    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    water_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    # 1) Eau portuaire Métano turquoise + Sparkles 1× (4×10t)
    water_4, sparkle_4 = build_canonical_metano_liquid_layers(
        W_NAT, H_NAT, water_mask=water_mask_nat, pal_key="harbor_turquoise", seed=28101
    )

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Couronnes de feuilles hautes des 2 huttes Pokémon (extraites sur Top pour profondeur 3/4)
    in_hut_crowns_box = ((xx_n >= 114) & (xx_n <= 246) & (yy_n >= 184) & (yy_n <= 258)) | (
        (xx_n >= 546) & (xx_n <= 674) & (yy_n >= 184) & (yy_n <= 258)
    )
    is_hut_roof_top = solid_nat & in_hut_crowns_box & (g_c >= r_c + 18) & (g_c >= b_c + 22)

    # Falaise étagée de grès doré Altere Pond & grand escalier Nord (y < 192 ou ailes hautes)
    is_north_cliff_and_stairs = (
        solid_nat
        & (~is_hut_roof_top)
        & ((yy_n < 192) | ((yy_n < 276) & ((xx_n < 96) | (xx_n > 672))))
    )

    # Quai en bois Sud (planches sur l'eau)
    is_wooden_pier = solid_nat & (~is_hut_roof_top) & (~is_north_cliff_and_stairs) & (xx_n >= 326) & (xx_n <= 442) & (yy_n >= 402)

    # Parvis pavé central & Fontaine de l'Œuf Ailé
    is_cobble_plaza_and_fountain = (
        solid_nat
        & (~is_hut_roof_top)
        & (~is_north_cliff_and_stairs)
        & (~is_wooden_pier)
        & (xx_n >= 278)
        & (xx_n <= 490)
        & (yy_n >= 206)
        & (yy_n <= 404)
        & ((r_c >= g_c - 6) | ((b_c - r_c) >= 28))
    )

    # Pelouse d'émeraude Vast Steppe, façades basses des huttes, tableau de missions, caisses & palmiers
    is_village_terrace = (
        solid_nat
        & (~is_hut_roof_top)
        & (~is_north_cliff_and_stairs)
        & (~is_wooden_pier)
        & (~is_cobble_plaza_and_fountain)
    )

    # Masque d'herbe pure pour les fleurs animées 1× Vast Steppe
    pure_grass_mask = (
        is_village_terrace
        & (yy_n >= 230)
        & (yy_n <= 416)
        & (g_c >= r_c + 24)
        & (g_c >= 148)
        & (~in_hut_crowns_box)
    )
    flowers_4 = build_vast_steppe_flowers_layer(w, h, pure_grass_mask, seed=28107, max_flowers=18)

    # VFX Multi-Frames (24×5t) + fusion propre des toits feuillus sur le calque Top
    bg_vfx_24, top_vfx_only_24 = build_dsv1_vfx_layers(W_NAT, H_NAT, water_mask=water_mask_nat)
    roof_rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    roof_rgba[is_hut_roof_top, :3] = rgb_nat[is_hut_roof_top]
    roof_rgba[is_hut_roof_top, 3] = 255
    top_24: List[Image.Image] = []
    for fr_vfx in top_vfx_only_24:
        arr = roof_rgba.copy()
        v_arr = np.asarray(fr_vfx, dtype=np.uint8)
        nz = v_arr[:, :, 3] == 255
        arr[nz] = v_arr[nz]
        im_t = Image.fromarray(sanitize_rgba_binary(arr))
        top_24.append(im_t if (w, h) == (W_NAT, H_NAT) else im_t.resize((w, h), Image.Resampling.NEAREST))

    underlay = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    underlay[:, :] = (18, 92, 152, 255)
    underlay_1 = [Image.fromarray(underlay, mode="RGBA")]

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = rgb_nat[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Grille de collision marchable (quai Sud -> place autour de la fontaine -> portes des huttes -> escalier Nord)
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    fountain_obstacle = (xx_n >= 352) & (xx_n <= 414) & (yy_n >= 254) & (yy_n <= 324)
    hut_bodies = ((xx_n >= 116) & (xx_n <= 246) & (yy_n >= 220) & (yy_n <= 326)) | (
        (xx_n >= 546) & (xx_n <= 674) & (yy_n >= 220) & (yy_n <= 326)
    )
    north_stairs_corridor = (xx_n >= 344) & (xx_n <= 424) & (yy_n <= 204)
    pier_corridor = (xx_n >= 346) & (xx_n <= 422) & (yy_n >= 400)
    sea_margin = ndimage.binary_dilation(water_mask_nat & (~pier_corridor), iterations=5)

    walk_nat = (
        solid_nat
        & (~sea_margin)
        & (~fountain_obstacle)
        & (~hut_bodies)
        & ((~is_north_cliff_and_stairs) | north_stairs_corridor)
    ) | (pier_corridor & solid_nat)
    walk_grid = np.asarray(
        Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    ) >= 128
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_assise_portuaire_turquoise", "Assise Sous-Marine du Port (0 % Ciel)", "BG", _resize_frames(underlay_1, w, h), frame_length=5),
        LayerEntry("01_eau_port_metano_turquoise", "Eau Portuaire Métano Turquoise (4×10t)", "BG", _resize_frames(water_4, w, h), frame_length=10),
        LayerEntry("02_sparkles_port_metano_1x", "Scintillements Marins Natifs Metano Town 1× (4×10t)", "BG", _resize_frames(sparkle_4, w, h), frame_length=10),
        LayerEntry("03_quai_en_bois_explorateurs", "Quai en Bois des Explorateurs sur le Port", "BG", [mk_static(is_wooden_pier)], frame_length=5),
        LayerEntry("04_parvis_pave_et_fontaine", "Parvis Pavé Central & Fontaine de l'Œuf Ailé", "BG", [mk_static(is_cobble_plaza_and_fountain)], frame_length=5),
        LayerEntry("05_terrasse_herbe_et_huttes_pokemon", "Pelouse Vast Steppe, Huttes Pokémon & Tableau de Missions", "BG", [mk_static(is_village_terrace)], frame_length=5),
        LayerEntry("06_falaise_gres_dore_et_escalier_nord", "Falaise Étagée Altere Pond (0 % Ciel) & Grand Escalier Nord", "BG", [mk_static(is_north_cliff_and_stairs)], frame_length=5),
        LayerEntry("07_fleurs_animees_vast_steppe_1x", "Fleurs Sauvages Animées Canoniques 1× Vast Steppe (4×12t)", "BG", flowers_4, frame_length=12),
        LayerEntry("08_vfx_fontaine_et_ressac_pilotis", "VFX Multi-Frames : Jet & Ondes de la Fontaine + Ressac Pilotis (24×5t)", "BG", _resize_frames(bg_vfx_24, w, h), frame_length=5),
        LayerEntry("09_toits_huttes_lanternes_et_bulles_top", "Toits Feuillus + VFX Lanternes Portuaires & Bulles d'Écume Top (24×5t)", "Top", top_24, frame_length=5),
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
        namespace_override="pmd_destiny_dsv1",
        asset_name_override="destiny_bourg_ecume_port",
    )
    _write_halcyon_ground_script(out_dir / "package", "destiny_bourg_ecume_port")
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    print(json.dumps(build(), indent=2, ensure_ascii=False))
