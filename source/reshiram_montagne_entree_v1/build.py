#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — RSE1 : Vallon Doré d'Automne & Falaise Ivoire — Ruisseau Metano (Reshiram).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, `0 px` de ciel !) :
  - `00` (`BG`,  1p) : Assise calcaire ambrée de sécurité (`0 %` ciel)
  - `01` (`BG`,  1p) : Berges de terre ocre-sableuse du ruisseau sinueux & vasque Ouest
  - `02` (`BG`, 24p) : Eau du ruisseau 100 % native Metano Town (`Metano_Town_River_Animation_1..4.tile`)
  - `03` (`BG`, 24p) : Scintillements d'eau 100 % natifs `Metano_Town_River_Sparkles.tile`
  - `04` (`BG`,  1p) : Prairie dorée d'automne lumineuse & feuilles au sol
  - `05` (`BG`,  1p) : Sentier de dalles calcaires crème & passerelle claire en bois doré
  - `06` (`BG`,  1p) : Falaise étagée de marbre ivoire (`y = 0..244`, `0 %` ciel) & sanctuaire à colonnes
  - `07` (`BG`,  1p) : Bouleaux à écorce blanche, érables dorés/roux d'automne & lierre ambré
  - `08` (`BG`, 24p) : Fleurs animées 100 % natives `Metano_Town_Animation_Tileset.tile`
  - `09` (`Top`,24p) : Couronnes dorées des érables/bouleaux, feuilles d'automne & braises `W04` Top
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
    build_forest_water_and_sparkles_layers,
    extract_metano_water_and_flower_assets,
)
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "RSE1"
MAP_TITLE = "Vallon Doré d'Automne & Falaise Ivoire — Ruisseau Metano (Reshiram)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = HERE / "bruts" / "base_reshiram_montagne_entree.png"
CANOPY_PATH = HERE / "bruts" / "canopee_arbres_top.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_reshiram_montagne_entree.png"
RENDERS_DIR = REPO_ROOT / "renders" / "reshiram_montagne_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def _tint_metano_flower_grass_to_autumn(frames_4: List[np.ndarray]) -> List[np.ndarray]:
    """Harmonise uniquement les brins d'herbe vert-vif de `Metano_Town_Animation_Tileset.tile`
    avec la prairie dorée d'automne de `RSE1` (les pétales restent intacts)."""
    out_list: List[np.ndarray] = []
    for sp in frames_4:
        arr = sp.copy()
        r, g, b, a = arr[:, :, 0].astype(np.int16), arr[:, :, 1].astype(np.int16), arr[:, :, 2].astype(np.int16), arr[:, :, 3]
        is_stem_green = (a == 255) & (g > r + 22) & (g > b + 28)
        arr[is_stem_green, 0] = np.clip((g[is_stem_green] * 92) // 100 + 22, 136, 212).astype(np.uint8)
        arr[is_stem_green, 1] = np.clip((g[is_stem_green] * 82) // 100 + 18, 120, 190).astype(np.uint8)
        arr[is_stem_green, 2] = np.clip((b[is_stem_green] * 45) // 100 + 12, 18, 44).astype(np.uint8)
        out_list.append(arr)
    return out_list


def _build_reshiram_flowers_leaves_and_embers(
    pure_meadow_mask: np.ndarray,
    canopy_nat: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit `(metano_flowers_24, canopy_autumn_leaves_and_embers_top_24)` propres au biome Vallon Doré Reshiram."""
    assets = extract_metano_water_and_flower_assets()
    fl_col_4 = _tint_metano_flower_grass_to_autumn(assets["metano_flowers_color_4"])  # type: ignore[arg-type]
    fl_wht_4 = _tint_metano_flower_grass_to_autumn(assets["metano_flowers_white_4"])  # type: ignore[arg-type]

    fh, fw = fl_wht_4[0].shape[:2]
    dist_meadow = ndimage.distance_transform_edt(pure_meadow_mask)
    taken = np.zeros((H_NAT, W_NAT), dtype=bool)
    flower_sites: List[Tuple[int, int, str, int]] = []
    rng = np.random.default_rng(909)
    cands = [(sy, sx) for sy in range(250, H_NAT - fh - 12, 12) for sx in range(148, W_NAT - fw - 148, 12)]
    rng.shuffle(cands)
    for sy, sx in cands:
        if abs((sx + fw // 2) - 384) < 58:
            continue
        if dist_meadow[sy : sy + fh, sx : sx + fw].min() >= 8.0 and not taken[max(0, sy - 16) : sy + fh + 16, max(0, sx - 16) : sx + fw + 16].any():
            taken[sy : sy + fh, sx : sx + fw] = True
            kind = "white" if (len(flower_sites) % 2 == 0) else "color"
            flower_sites.append((sx, sy, kind, len(flower_sites) % 4))
            if len(flower_sites) >= 12:
                break

    # Feuilles d'automne dorées voletant près des érables/bouleaux + braises blanc-or devant le sanctuaire Nord
    leaf_anchors = [
        (118, 254, 0.0),
        (162, 418, 1.4),
        (638, 268, 2.3),
        (612, 436, 3.8),
        (214, 496, 4.9),
        (554, 492, 0.9),
    ]
    ember_anchors = [
        (338, 198, 0.4),
        (430, 196, 2.1),
        (356, 152, 3.6),
        (412, 150, 5.1),
        (308, 168, 1.2),
        (460, 166, 4.3),
    ]

    can_op = canopy_nat[:, :, 3] >= 128
    lay8_frames: List[Image.Image] = []
    top9_frames: List[Image.Image] = []

    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)
        fl_phase = (f // 2) % 4

        arr8 = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        for sx, sy, kind, ph0 in flower_sites:
            patch = (fl_wht_4 if kind == "white" else fl_col_4)[(fl_phase + ph0) % 4]
            ph_h, ph_w = patch.shape[:2]
            nz = patch[:, :, 3] == 255
            sub = arr8[sy : sy + ph_h, sx : sx + ph_w]
            sub[nz] = patch[nz]
        lay8_frames.append(Image.fromarray(sanitize_rgba_binary(arr8), mode="RGBA"))

        arr9 = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        arr9[can_op] = canopy_nat[can_op]

        # Feuilles d'érable/bouleau dorées ondulant doucement
        for lx0, ly0, lph in leaf_anchors:
            lx = int(round(lx0 + 7.0 * math.sin(theta + lph)))
            ly = int(round(ly0 + 4.0 * math.cos(theta + lph)))
            if 4 <= lx < W_NAT - 4 and 4 <= ly < H_NAT - 4:
                arr9[ly, lx : lx + 2] = (248, 196, 48, 255)
                arr9[ly + 1, lx - 1 : lx + 1] = (216, 118, 24, 255)

        # Braises sacrées blanc-or GBA `W04` s'élevant devant les colonnes du sanctuaire de Reshiram
        for ex0, ey0, eph in ember_anchors:
            ex = int(round(ex0 + 4.0 * math.sin(theta + eph)))
            ey = int(round(ey0 - 5.0 * math.cos(theta + eph)))
            if 4 <= ex < W_NAT - 4 and 4 <= ey < H_NAT - 4:
                arr9[ey, ex] = (255, 250, 214, 255)
                if math.sin(2.0 * theta + eph) > 0.0:
                    for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        arr9[ey + dy, ex + dx] = (255, 208, 96, 255)

        top9_frames.append(Image.fromarray(sanitize_rgba_binary(arr9), mode="RGBA"))

    return lay8_frames, top9_frames


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    if not BRUT_PATH.is_file() or not CANOPY_PATH.is_file() or not CANON_REF.is_file():
        from source.reshiram_montagne_entree_v1.make_brut import main as make_brut_main

        make_brut_main()

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    canopy_nat = np.asarray(Image.open(CANOPY_PATH).convert("RGBA"), dtype=np.uint8)

    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]
    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    # ZÉRO pixel de ciel : toute la zone #FF00FF correspond au ruisseau sinueux et à sa vasque Ouest !
    water_mask_nat = mag_nat.copy()
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Passerelle claire centrale en bois doré et pierre blanche (x=342..426, y=282..406)
    bridge_box = (xx_n >= 342) & (xx_n <= 426) & (yy_n >= 282) & (yy_n <= 406) & solid_nat
    water_full_nat = water_mask_nat | ((xx_n >= 342) & (xx_n <= 426) & (yy_n >= 342) & (yy_n <= 384))

    water_24, sparkle_24 = build_forest_water_and_sparkles_layers(
        mode="tiny_woods_sunlit",
        water_mask=water_full_nat,
        bridge_mask=bridge_box,
    )

    # Partitionnement disjoint à 100 % des 5 calques statiques (01, 04, 05, 06, 07)
    is_golden_meadow_color = (r_c >= 176) & (r_c <= 226) & (g_c >= 166) & (g_c <= 206) & (b_c <= 58)
    in_tree_zone = (yy_n >= 168) & ((xx_n < 176) | (xx_n > W_NAT - 176) | (yy_n >= 472))
    is_west_crown_top = (yy_n >= 168) & (yy_n < 246) & (xx_n < 152) & (r_c >= 140) & (b_c <= 56)

    # Calque 06 : Falaise étagée de calcaire/marbre ivoire (y=0..244, 0 % ciel) & sanctuaire à colonnes
    is_ivory_cliff = (
        solid_nat
        & (~bridge_box)
        & (~is_west_crown_top)
        & (
            (yy_n < 222)
            | ((yy_n < 246) & (~is_golden_meadow_color) & (xx_n >= 145) & (xx_n <= W_NAT - 96))
            | ((yy_n < 252) & (xx_n > W_NAT - 96) & (b_c >= 90))
        )
    )

    # Calque 05 : Sentier de dalles calcaires crème Sud -> Nord + passerelle claire en bois doré
    in_flagstone_corridor = (np.abs(xx_n - 384) <= 40) & (yy_n >= 238)
    is_cream_flagstone = in_flagstone_corridor & (~is_golden_meadow_color) & (b_c >= 95)
    is_path_bridge = solid_nat & (~is_ivory_cliff) & (bridge_box | is_cream_flagstone)

    # Calque 01 : Berges de terre ocre-sableuse du ruisseau sinueux et de sa vasque Ouest
    near_water = ndimage.binary_dilation(water_mask_nat, iterations=20)
    is_ochre_bank = (
        solid_nat
        & (~is_ivory_cliff)
        & (~is_path_bridge)
        & near_water
        & (yy_n >= 264)
        & (yy_n <= 404)
        & (~is_golden_meadow_color)
        & (xx_n >= 92)
        & (xx_n <= W_NAT - 120)
    )

    # Calque 07 : Bouleaux à écorce blanche & érables dorés/roux d'automne
    is_birch_or_maple = (
        solid_nat
        & (~is_ivory_cliff)
        & (~is_path_bridge)
        & (~is_ochre_bank)
        & (in_tree_zone | is_west_crown_top)
        & (~is_golden_meadow_color)
    )

    # Calque 04 : Prairie dorée d'automne lumineuse (couvre tout le reste de solid_nat sans aucun trou)
    is_golden_meadow = solid_nat & (~is_ivory_cliff) & (~is_path_bridge) & (~is_ochre_bank) & (~is_birch_or_maple)
    pure_meadow_for_flowers = is_golden_meadow & is_golden_meadow_color & (~ndimage.binary_dilation(water_mask_nat, iterations=8))

    lay8_24, top9_24 = _build_reshiram_flowers_leaves_and_embers(
        pure_meadow_mask=pure_meadow_for_flowers,
        canopy_nat=canopy_nat,
    )

    # Calque 00 : Assise calcaire ambrée de sécurité (aucun pixel de ciel)
    underlay_rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
    underlay_rgba[:, :] = (212, 178, 96, 255)
    underlay_1 = [Image.fromarray(underlay_rgba, mode="RGBA")]

    def mk_static_scaled(mask: np.ndarray, src_rgb: np.ndarray = rgb_nat) -> Image.Image:
        out = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        out[mask, :3] = src_rgb[mask]
        out[mask, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(out), mode="RGBA")
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Grille de marche continue Sud -> Passerelle claire -> Arche du sanctuaire Nord
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    bank_cliff = ndimage.binary_dilation(water_mask_nat, iterations=5) & (~bridge_box)
    walk_nat = (is_golden_meadow | is_path_bridge) & (~bank_cliff) & (~is_birch_or_maple)
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
        LayerEntry("00_assise_calcaire_securite", "Assise Calcaire Ambrée (0 % Ciel)", "BG", _resize_frames(underlay_1, w, h), frame_length=5),
        LayerEntry("01_berges_ocres_ruisseau_vallon", "Berges Ocre-Sableuses du Ruisseau Sinueux", "BG", [mk_static_scaled(is_ochre_bank)], frame_length=5),
        LayerEntry("02_ruisseau_eau_metano_4phases", "Eau du Ruisseau 100 % Native Metano Town", "BG", _resize_frames(water_24, w, h), frame_length=5),
        LayerEntry("03_sparkles_ruisseau_metano", "Reflets Scintillants Natifs Metano Town 1×", "BG", _resize_frames(sparkle_24, w, h), frame_length=5),
        LayerEntry("04_prairie_doree_automne_vallon", "Prairie Dorée d'Automne & Tapis Ambré", "BG", [mk_static_scaled(is_golden_meadow)], frame_length=5),
        LayerEntry("05_sentier_dalles_creme_et_passerelle", "Sentier de Dalles Crème & Passerelle Claire", "BG", [mk_static_scaled(is_path_bridge)], frame_length=5),
        LayerEntry("06_falaise_marbre_ivoire_et_sanctuaire", "Falaise de Marbre Ivoire sans Ciel & Sanctuaire", "BG", [mk_static_scaled(is_ivory_cliff)], frame_length=5),
        LayerEntry("07_bouleaux_blancs_et_erables_dores", "Bouleaux Blancs & Érables Dorés d'Automne", "BG", [mk_static_scaled(is_birch_or_maple)], frame_length=5),
        LayerEntry("08_fleurs_metano_prairie_doree", "Fleurs Animées Natives Metano Town 1×", "BG", _resize_frames(lay8_24, w, h), frame_length=5),
        LayerEntry("09_couronnes_erables_feuilles_braises_top", "Couronnes d'Automne, Feuilles Dorées & Braises W04 Top", "Top", _resize_frames(top9_24, w, h), frame_length=6),
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
        namespace_override="reshiram_montagne_rse1",
        asset_name_override="reshiram_montagne_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
