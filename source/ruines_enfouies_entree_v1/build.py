#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur PMDO 0.8.12.0 — RUE1 : Ruines Enfouies — Ziggourat à Double Escalier & Bassins Sacrés (`H22P01`).

Layout fidèle à la Zone d'Accueil officielle `H22P01` (*Ancient Relic*, `768 × 576`, `0 %` ciel,
aucune rivière horizontale ni pont central : chaussée centrale surélevée en dalles carrées `3×3` +
deux bassins sacrés rectangulaires encaissés `#FF00FF` G/D + double escalier en diagonale) :
  - `00` (`BG`,  1p) : Assise de calcaire antique des Ruines Enfouies (`0 %` ciel)
  - `01` (`BG`,  1p) : Margelles & balustrades sculptées des deux bassins sacrés encaissés
  - `02` (`BG`,  4p) : Eau Métano Sacrée des Deux Bassins (`Metano_Town_River`, `4 × 10t`)
  - `03` (`BG`,  4p) : Scintillements sacrés `1×` natifs `Metano_Town_River_Sparkles.tile` (`4 × 10t`)
  - `04` (`BG`,  1p) : Terrasse supérieure aux 5 stèles hiéroglyphiques & parvis latéraux (`H22P01`)
  - `05` (`BG`,  1p) : Chaussée monumentale `3×3` Sud→Nord & double escalier convergeant en diagonale
  - `06` (`BG`,  1p) : Façade en gradins de la Ziggourat (`0 %` ciel), disque solaire & porte Nord
  - `07` (`BG`,  1p) : Lianes d'émeraude tropicales & blocs d'angle moussus (`H22P01`)
  - `08` (`BG`, 24p) : Lueur dorée des hiéroglyphes ancestraux & fleurs sacrées Metano (`24 × 5t`)
  - `09` (`Top`,24p) : Frondes de lianes suspendues & bulles nacrées / pollen d'or de Mew Top (`24 × 5t`)
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
    assemble_rue1_brut,
    build_rue1_glyphs_flowers_and_canopy_top,
    build_themed_metano_water_layers,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "RUE1"
MAP_TITLE = "Ruines Enfouies — Ziggourat à Double Escalier & Bassins Sacrés (Mew)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_ruines_enfouies_entree.png"
VINES_TOP_PATH = HERE / "bruts" / "lianes_suspendues_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_ruines_enfouies_entree.png"
RENDERS_DIR = REPO_ROOT / "renders" / "ruines_enfouies_entree_v1"
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
    if not BRUT_PATH.is_file() or not VINES_TOP_PATH.is_file() or not CANON_REF.is_file():
        assemble_rue1_brut(HERE)

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    vines_top_nat = np.asarray(Image.open(VINES_TOP_PATH).convert("RGBA"), dtype=np.uint8)
    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]

    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    basins_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    water_4, sparkle_4 = build_themed_metano_water_layers(
        W_NAT,
        H_NAT,
        water_mask=basins_mask_nat,
        pal_key="sacred",
        shore_foam=True,
        seed=27151,
    )

    # 1) Calque 07 : Lianes d'émeraude tropicales & gros rochers d'angle moussus (H22P01)
    is_emerald_vine = solid_nat & (g_c >= r_c + 20) & (g_c >= b_c + 22) & (g_c >= 64)
    corner_boulders = solid_nat & (yy_n >= 500) & ((xx_n < 268) | (xx_n > 500)) & (r_c <= 118) & (g_c <= 128)
    is_vines_and_boulders = is_emerald_vine | corner_boulders

    # 2) Calque 06 : Façade en gradins de la Ziggourat Nord, colonnades G/D & grande porte (0 % ciel)
    in_upper_steps = (yy_n >= 104) & (yy_n <= 198) & (np.abs(xx_n - 384) <= 168) & (~((np.abs(xx_n - 384) <= 28) & (yy_n <= 178)))
    is_ziggurat_facade = (
        solid_nat
        & (~is_vines_and_boulders)
        & (
            ((yy_n < 196) & (~in_upper_steps))
            | ((yy_n < 368) & ((xx_n < 104) | (xx_n > 664)))
        )
    )

    # 3) Calque 01 : Margelles et balustrades sculptées encadrant les 2 bassins rectangulaires #FF00FF
    near_basins = ndimage.binary_dilation(basins_mask_nat, iterations=20)
    is_basin_parapet = (
        solid_nat
        & (~is_vines_and_boulders)
        & (~is_ziggurat_facade)
        & near_basins
        & (np.abs(xx_n - 384) > 102)
    )

    # 4) Calque 05 : Chaussée centrale surélevée en dalles 3x3 + double escalier en diagonale + marches du portail
    in_central_avenue = (np.abs(xx_n - 384) <= 104) & (yy_n >= 320)
    in_twin_diag_stairs = (yy_n >= 242) & (yy_n <= 354) & (np.abs(xx_n - 384) > 104) & (np.abs(xx_n - 384) <= 232)
    is_avenue_and_stairs = (
        solid_nat
        & (~is_vines_and_boulders)
        & (~is_ziggurat_facade)
        & (~is_basin_parapet)
        & (in_central_avenue | in_twin_diag_stairs | in_upper_steps)
    )

    # 5) Calque 04 : Terrasse supérieure aux 5 stèles hiéroglyphiques & parvis (complément exact)
    is_hieroglyph_terrace = (
        solid_nat
        & (~is_vines_and_boulders)
        & (~is_ziggurat_facade)
        & (~is_basin_parapet)
        & (~is_avenue_and_stairs)
    )

    # Zones praticables (chaussée centrale 3x3 -> 2 escaliers en diagonale -> terrasse -> marches du portail)
    in_upper_terrace = (yy_n >= 196) & (yy_n <= 262) & (xx_n >= 132) & (xx_n <= 636)
    walk_nat = solid_nat & (~ndimage.binary_dilation(basins_mask_nat, iterations=6)) & (
        in_central_avenue | in_twin_diag_stairs | in_upper_terrace | in_upper_steps
    )

    lay8_24, top9_24 = build_rue1_glyphs_flowers_and_canopy_top(
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
        vines_top_nat=vines_top_nat,
        plaza_walk_mask=walk_nat,
    )

    underlay_rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    underlay_rgba[:, :] = (46, 56, 44, 255)
    underlay_1 = [Image.fromarray(underlay_rgba, mode="RGBA")]

    def mk_static_scaled(mask: np.ndarray) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = rgb_nat[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    # Garantit la boucle complète H22P01 : avenue Sud -> escaliers G & D -> terrasse -> porte Nord
    cx_t = gw // 2
    for ty in range(int(round(324 * gh / H_NAT)), gh):
        walk_grid[ty, cx_t - 8 : cx_t + 8] = True
    # Escaliers diagonaux gauche et droite
    y_st0, y_st1 = int(round(244 * gh / H_NAT)), int(round(336 * gh / H_NAT))
    for ty in range(y_st0, y_st1 + 1):
        frac = (ty - y_st0) / max(1, (y_st1 - y_st0))
        lx = int(round((200 + 96 * frac) * gw / W_NAT))
        rx = int(round((568 - 96 * frac) * gw / W_NAT))
        walk_grid[ty, lx - 2 : lx + 3] = True
        walk_grid[ty, rx - 2 : rx + 3] = True
    # Terrasse haute + marches vers le portail Nord
    y_ter0, y_ter1 = int(round(202 * gh / H_NAT)), int(round(248 * gh / H_NAT))
    walk_grid[y_ter0:y_ter1, int(round(168 * gw / W_NAT)) : int(round(600 * gw / W_NAT))] = True
    walk_grid[int(round(168 * gh / H_NAT)) : y_ter0 + 1, cx_t - 4 : cx_t + 4] = True

    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry(
            "00_assise_calcaire_jungle",
            "Assise de Calcaire Antique & Terre de Jungle (0 % Ciel)",
            "BG",
            _resize_frames(underlay_1, w, h),
            frame_length=5,
        ),
        LayerEntry(
            "01_margelles_bassins_sacres",
            "Margelles & Balustrades des Deux Bassins Sacrés Encaissés (H22P01)",
            "BG",
            [mk_static_scaled(is_basin_parapet)],
            frame_length=5,
        ),
        LayerEntry(
            "02_bassins_eau_metano_sacree",
            "Eau Métano Sacrée des Bassins Antiques (Metano_Town_River, 4×10t)",
            "BG",
            _resize_frames(water_4, w, h),
            frame_length=10,
        ),
        LayerEntry(
            "03_sparkles_bassins_metano_1x",
            "Scintillements Sacrés Natifs Metano Town 1× (4×10t)",
            "BG",
            _resize_frames(sparkle_4, w, h),
            frame_length=10,
        ),
        LayerEntry(
            "04_terrasse_hieroglyphes_et_parvis",
            "Terrasse aux 5 Stèles Hiéroglyphiques & Parvis Latéraux (H22P01)",
            "BG",
            [mk_static_scaled(is_hieroglyph_terrace)],
            frame_length=5,
        ),
        LayerEntry(
            "05_chaussee_dalles_et_double_escalier",
            "Chaussée Centrale 3×3 & Double Escalier Convergeant en Diagonale",
            "BG",
            [mk_static_scaled(is_avenue_and_stairs)],
            frame_length=5,
        ),
        LayerEntry(
            "06_facade_ziggourat_et_porte_nord",
            "Façade en Gradins de la Ziggourat sans Ciel, Disque Solaire & Porte Nord",
            "BG",
            [mk_static_scaled(is_ziggurat_facade)],
            frame_length=5,
        ),
        LayerEntry(
            "07_lianes_emeraude_et_rochers_moussus",
            "Lianes d'Émeraude Tropicales & Blocs d'Angle Moussus (H22P01)",
            "BG",
            [mk_static_scaled(is_vines_and_boulders)],
            frame_length=5,
        ),
        LayerEntry(
            "08_glyphes_ancestraux_et_fleurs",
            "Pulsation Dorée des Stèles Hiéroglyphiques & Fleurs Metano",
            "BG",
            _resize_frames(lay8_24, w, h),
            frame_length=5,
        ),
        LayerEntry(
            "09_lianes_et_pollen_mew_top",
            "Frondes de Lianes Suspendues, Pollen d'Or & Bulles de Mew Top",
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
        namespace_override="ruines_enfouies_rue1",
        asset_name_override="ruines_enfouies_entree",
    )
    _write_halcyon_ground_script(out_dir / "package", "ruines_enfouies_entree")
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
