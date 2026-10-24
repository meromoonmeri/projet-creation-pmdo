#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — ZKE1 : Taïga d'Orage & Orgues Basaltiques — Rivière Metano (Zekrom).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, `0 px` de ciel !) :
  - `00` (`BG`,  1p) : Assise minérale d'ardoise basaltique de sécurité (`0 %` ciel)
  - `01` (`BG`,  1p) : Berges rocheuses d'ardoise entaillées du torrent de montagne
  - `02` (`BG`, 24p) : Eau de torrent 100 % native Metano Town (`Metano_Town_River_Animation_1..4.tile`)
  - `03` (`BG`, 24p) : Scintillements d'eau 100 % natifs `Metano_Town_River_Sparkles.tile`
  - `04` (`BG`,  1p) : Lande boréale de mousse vert-ardoise & clairière de taïga
  - `05` (`BG`,  1p) : Chaussée pavée d'ardoise grise & pont runique en pierre sculptée
  - `06` (`BG`,  1p) : Rempart vertical d'orgues basaltiques (`y = 0..272`, `0 %` ciel) & grotte d'orage
  - `07` (`BG`,  1p) : Grands sapins bleutés coniques de taïga & blocs de granit
  - `08` (`BG`, 24p) : Cristaux de quartz bleu-électrique résonnants & fleurs natives Metano Town
  - `09` (`Top`,24p) : Cimes coniques des sapins en surplomb & arcs électriques bleu-cyan de Zekrom Top
"""
from __future__ import annotations

import json
import math
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
from source.moteur_forets_pmd_red import (
    _sanitize_rgb_no_magenta,
    build_forest_water_and_sparkles_layers,
    extract_metano_water_and_flower_assets,
)
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "ZKE1"
MAP_TITLE = "Taïga d'Orage & Orgues Basaltiques — Rivière Metano (Zekrom)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_zekrom_montagne_entree.png"
CANOPY_PATH = HERE / "bruts" / "canopee_arbres_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_zekrom_montagne_entree.png"
RENDERS_DIR = REPO_ROOT / "renders" / "zekrom_montagne_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def _tint_metano_flower_grass_to_taiga(frames_4: List[np.ndarray]) -> List[np.ndarray]:
    """Harmonise uniquement les brins d'herbe vert-vif de `Metano_Town_Animation_Tileset.tile`
    avec la mousse vert-ardoise boréale de `ZKE1` (les pétales restent intacts)."""
    out_list: List[np.ndarray] = []
    for sp in frames_4:
        arr = sp.copy()
        r, g, b, a = arr[:, :, 0].astype(np.int16), arr[:, :, 1].astype(np.int16), arr[:, :, 2].astype(np.int16), arr[:, :, 3]
        is_stem_green = (a == 255) & (g > r + 22) & (g > b + 28)
        arr[is_stem_green, 0] = np.clip((r[is_stem_green] * 45) // 100 + 20, 28, 72).astype(np.uint8)
        arr[is_stem_green, 1] = np.clip((g[is_stem_green] * 58) // 100 + 18, 68, 132).astype(np.uint8)
        arr[is_stem_green, 2] = np.clip((g[is_stem_green] * 55) // 100 + 22, 66, 126).astype(np.uint8)
        out_list.append(arr)
    return out_list


def _build_zekrom_crystals_flowers_and_sparks(
    rgb_nat: np.ndarray,
    solid_nat: np.ndarray,
    pure_moor_mask: np.ndarray,
    canopy_nat: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit `(crystals_and_flowers_24, canopy_and_electric_sparks_top_24)` propres au biome Taïga/Basalte Zekrom."""
    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Cœurs intérieurs des cristaux de quartz bleu-électrique (la roche autour reste 100 % immobile !)
    crystal_core = solid_nat & (b_c >= 198) & (g_c >= 150) & (r_c <= 105)

    # Fleurs animées natives `Metano_Town_Animation_Tileset.tile` harmonisées à la mousse boréale
    assets = extract_metano_water_and_flower_assets()
    fl_wht_4 = _tint_metano_flower_grass_to_taiga(assets["metano_flowers_white_4"])  # type: ignore[arg-type]
    fl_col_4 = _tint_metano_flower_grass_to_taiga(assets["metano_flowers_color_4"])  # type: ignore[arg-type]

    fh, fw = fl_wht_4[0].shape[:2]
    dist_moor = ndimage.distance_transform_edt(pure_moor_mask)
    taken = np.zeros((H_NAT, W_NAT), dtype=bool)
    flower_sites: List[Tuple[int, int, str, int]] = []
    rng = np.random.default_rng(707)
    cands = [(sy, sx) for sy in range(384, H_NAT - fh - 12, 12) for sx in range(136, W_NAT - fw - 136, 12)]
    rng.shuffle(cands)
    for sy, sx in cands:
        if abs((sx + fw // 2) - 384) < 62:
            continue
        if dist_moor[sy : sy + fh, sx : sx + fw].min() >= 8.0 and not taken[max(0, sy - 16) : sy + fh + 16, max(0, sx - 16) : sx + fw + 16].any():
            taken[sy : sy + fh, sx : sx + fw] = True
            kind = "white" if (len(flower_sites) % 3 != 0) else "color"
            flower_sites.append((sx, sy, kind, len(flower_sites) % 4))
            if len(flower_sites) >= 8:
                break

    # Points d'ancrage d'étincelles électriques bleu-cyan autour de l'arche à cristaux & des orgues basaltiques
    spark_anchors = [
        (316, 134, 0),
        (450, 128, 1),
        (282, 198, 2),
        (482, 196, 3),
        (196, 92, 1),
        (572, 88, 3),
        (124, 148, 0),
        (644, 144, 2),
    ]

    can_op = canopy_nat[:, :, 3] >= 128
    lay8_frames: List[Image.Image] = []
    top9_frames: List[Image.Image] = []

    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)
        fl_phase = (f // 2) % 4

        # Calque 08 : Pulsation lumineuse des cristaux cyan + fleurs Metano Town
        arr8 = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        pulse = 0.5 + 0.5 * math.sin(theta)
        glow_rgb = rgb_nat.astype(np.float32)
        glow_rgb[crystal_core, 0] = np.clip(glow_rgb[crystal_core, 0] + 46.0 * pulse, 0.0, 240.0)
        glow_rgb[crystal_core, 1] = np.clip(glow_rgb[crystal_core, 1] + 28.0 * pulse, 0.0, 252.0)
        glow_rgb[crystal_core, 2] = np.clip(glow_rgb[crystal_core, 2] + 18.0 * pulse, 0.0, 255.0)
        glow_u8 = _sanitize_rgb_no_magenta((np.round(glow_rgb / 4.0) * 4.0).clip(0, 255).astype(np.uint8), crystal_core)
        arr8[crystal_core, :3] = glow_u8[crystal_core]
        arr8[crystal_core, 3] = 255

        for sx, sy, kind, ph0 in flower_sites:
            patch = (fl_wht_4 if kind == "white" else fl_col_4)[(fl_phase + ph0) % 4]
            ph_h, ph_w = patch.shape[:2]
            nz = patch[:, :, 3] == 255
            sub = arr8[sy : sy + ph_h, sx : sx + ph_w]
            sub[nz] = patch[nz]
        lay8_frames.append(Image.fromarray(sanitize_rgba_binary(arr8), mode="RGBA"))

        # Calque 09 Top : Cimes des sapins de taïga + arcs/étincelles électriques bleu-cyan Zekrom
        arr9 = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        arr9[can_op] = canopy_nat[can_op]
        for ax0, ay0, ph_s in spark_anchors:
            ph_ang = theta + ph_s * (math.pi * 0.5)
            sx_p = int(round(ax0 + 5.0 * math.sin(ph_ang)))
            sy_p = int(round(ay0 - 4.0 * math.cos(ph_ang)))
            if 4 <= sx_p < W_NAT - 4 and 4 <= sy_p < H_NAT - 4:
                arr9[sy_p, sx_p] = (224, 252, 255, 255)
                if math.sin(2.0 * theta + ph_s) > 0.15:
                    for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        arr9[sy_p + dy, sx_p + dx] = (72, 212, 252, 255)
                    # Mini-filament d'arc électrique de 2 px aux pics d'énergie
                    if math.sin(2.0 * theta + ph_s) > 0.65:
                        arr9[sy_p - 2, sx_p + 1] = (144, 236, 255, 255)
                        arr9[sy_p + 2, sx_p - 1] = (144, 236, 255, 255)
        top9_frames.append(Image.fromarray(sanitize_rgba_binary(arr9), mode="RGBA"))

    return lay8_frames, top9_frames


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    if not BRUT_PATH.is_file() or not CANOPY_PATH.is_file() or not CANON_REF.is_file():
        from source.zekrom_montagne_entree_v1.make_brut import main as make_brut_main

        make_brut_main()

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    canopy_nat = np.asarray(Image.open(CANOPY_PATH).convert("RGBA"), dtype=np.uint8)

    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]
    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    # ZÉRO pixel de ciel : toute la zone #FF00FF correspond au lit du torrent de montagne !
    water_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Pont runique central en pierre sculptée (x=326..442, y=290..424) : continuité de l'eau Metano dessous
    bridge_box = (xx_n >= 326) & (xx_n <= 442) & (yy_n >= 290) & (yy_n <= 424) & solid_nat
    water_full_nat = water_mask_nat | ((xx_n >= 326) & (xx_n <= 442) & (yy_n >= 352) & (yy_n <= 398))

    water_24, sparkle_24 = build_forest_water_and_sparkles_layers(
        mode="tiny_woods_sunlit",
        water_mask=water_full_nat,
        bridge_mask=bridge_box,
    )

    # Partitionnement disjoint à 100 % des 5 calques statiques (01, 04, 05, 06, 07)
    is_moor_turf_color = (g_c >= 94) & (np.abs(g_c - b_c) <= 20) & (r_c >= 42) & (r_c <= 78)

    # Calque 06 : Rempart d'orgues basaltiques (y=0..256) & grotte d'orage Nord (y <= 272 au centre)
    is_basalt_mountain = solid_nat & (~bridge_box) & (
        (yy_n < 244)
        | ((yy_n < 268) & (~is_moor_turf_color) & (np.abs(xx_n - 384) > 36))
        | ((yy_n < 262) & (np.abs(xx_n - 384) <= 130) & (~is_moor_turf_color))
    )

    # Calque 05 : Chaussée pavée d'ardoise grise Sud -> Nord + pont runique en pierre sculptée
    in_road_corridor = (np.abs(xx_n - 384) <= 40) & (yy_n >= 260)
    is_cobble_stone = in_road_corridor & (~is_moor_turf_color) & ((b_c >= g_c + 6) | (r_c >= 72))
    is_path_bridge = solid_nat & (~is_basalt_mountain) & (bridge_box | is_cobble_stone)

    # Calque 01 : Berges rocheuses d'ardoise entaillées du torrent de montagne
    near_water = ndimage.binary_dilation(water_mask_nat, iterations=22)
    is_slate_bank = (
        solid_nat
        & (~is_basalt_mountain)
        & (~is_path_bridge)
        & near_water
        & (yy_n >= 262)
        & (yy_n <= 408)
        & (~is_moor_turf_color)
        & (xx_n >= 40)
        & (xx_n <= W_NAT - 40)
    )

    # Calque 07 : Sapins bleutés coniques de taïga & blocs de granit gris
    in_tree_zone = (yy_n >= 290) & ((xx_n < 210) | (xx_n > W_NAT - 210) | (yy_n >= 470))
    is_spruce_or_boulder = (
        solid_nat
        & (~is_basalt_mountain)
        & (~is_path_bridge)
        & (~is_slate_bank)
        & in_tree_zone
        & (~is_moor_turf_color)
    )

    # Calque 04 : Lande boréale de mousse vert-ardoise (couvre tout le reste de solid_nat sans aucun trou)
    is_moorland = solid_nat & (~is_basalt_mountain) & (~is_path_bridge) & (~is_slate_bank) & (~is_spruce_or_boulder)
    pure_moor_for_flowers = is_moorland & is_moor_turf_color & (~ndimage.binary_dilation(water_mask_nat, iterations=8))

    lay8_24, top9_24 = _build_zekrom_crystals_flowers_and_sparks(
        rgb_nat=rgb_nat,
        solid_nat=solid_nat,
        pure_moor_mask=pure_moor_for_flowers,
        canopy_nat=canopy_nat,
    )

    # Calque 00 : Assise de basalte sombre de sécurité (aucun pixel de ciel)
    underlay_rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    underlay_rgba[:, :] = (28, 38, 58, 255)
    underlay_1 = [Image.fromarray(underlay_rgba, mode="RGBA")]

    def mk_static_scaled(mask: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = src_rgb[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Grille de marche continue Sud -> Pont runique -> Marches de grotte d'orage Nord
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    bank_cliff = ndimage.binary_dilation(water_mask_nat, iterations=5) & (~bridge_box)
    walk_nat = (is_moorland | is_path_bridge) & (~bank_cliff) & (~is_spruce_or_boulder)
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    cave_top_t = max(2, int(round(0.28 * gh)))
    for ty in range(cave_top_t, gh):
        walk_grid[ty, max(0, cx_t - 3) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_assise_basalte_securite", "Assise Basaltique Souterraine (0 % Ciel)", "BG", _resize_frames(underlay_1, w, h), frame_length=5),
        LayerEntry("01_berges_ardoise_torrent_montagne", "Berges Rocheuses d'Ardoise du Torrent", "BG", [mk_static_scaled(is_slate_bank)], frame_length=5),
        LayerEntry("02_torrent_eau_metano_4phases", "Eau du Torrent 100 % Native Metano Town", "BG", _resize_frames(water_24, w, h), frame_length=5),
        LayerEntry("03_sparkles_torrent_metano", "Reflets Scintillants Natifs Metano Town 1×", "BG", _resize_frames(sparkle_24, w, h), frame_length=5),
        LayerEntry("04_lande_boreale_mousse_taiga", "Lande Boréale de Mousse Vert-Ardoise & Taïga", "BG", [mk_static_scaled(is_moorland)], frame_length=5),
        LayerEntry("05_chaussee_pavee_et_pont_runique", "Chaussée Pavée d'Ardoise & Pont Runique Sculpté", "BG", [mk_static_scaled(is_path_bridge)], frame_length=5),
        LayerEntry("06_rempart_orgues_basaltiques_et_grotte", "Orgues Basaltiques sans Ciel & Grotte d'Orage", "BG", [mk_static_scaled(is_basalt_mountain)], frame_length=5),
        LayerEntry("07_sapins_bleutes_taiga_et_granit", "Sapins Bleutés de Taïga & Blocs de Granit", "BG", [mk_static_scaled(is_spruce_or_boulder)], frame_length=5),
        LayerEntry("08_cristaux_foudre_et_fleurs_metano", "Cristaux Électriques Résonnants & Fleurs Metano", "BG", _resize_frames(lay8_24, w, h), frame_length=5),
        LayerEntry("09_cimes_sapins_et_arcs_electriques_top", "Cimes des Sapins & Étincelles Électriques Zekrom Top", "Top", _resize_frames(top9_24, w, h), frame_length=5),
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
        namespace_override="zekrom_montagne_zke1",
        asset_name_override="zekrom_montagne_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
