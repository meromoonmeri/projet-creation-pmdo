#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (24 trames @ 5 ticks = 120 ticks) :
STC1 — Sommet de la Tour Céleste — Arène de Rayquaza (`ref_sommet_planete_rayquaza.png`).

Fidélité maximale au fond spatial/planétaire ET à l'arène de nuages volumétrique de référence :
- `STC1_00` (`BG`, `24` poses @ `5` ticks) : Cosmos nocturne profond (`#020624`) & étoiles lointaines ;
- `STC1_01` (`BG`, `24` poses @ `5` ticks) : Étoiles héroïques scintillantes du cosmos ;
- `STC1_02` (`BG`, `1` pose statique) : **Planète Terre complète continue & alizés spiralés de référence**
  (limbe stratosphérique lumineux bleu-cyan, bandes océaniques céruléen -> cobalt -> bleu roi sans taches
  continentales parasites ni fantômes, strictement statique) ;
- `STC1_03` (`BG`, `1` pose statique) : Massif nuageux cumulonimbus profond (assises cobalt & indigo) ;
- `STC1_04` (`BG`, `1` pose statique) : Grands croissants de vent latéraux gauche & droit ;
- `STC1_05` (`BG`, `1` pose statique) : Assise pervenche sculptée de la couronne & flancs du pont ;
- `STC1_06` (`BG`, `1` pose statique) : **Cuvette circulaire praticable de l'arène nuageuse & chemin Sud -> Nord** ;
- `STC1_07` (`BG`, `1` pose statique) : Bourrelets cumulus blancs & bleu glace du rebord d'arène et du pont ;
- `STC1_08` (`BG`, `24` poses @ `5` ticks) : Reflets internes `D13P01.bpl` sur les croissants blancs de la cuvette ;
- `STC1_09` (`Top`, `1` pose statique) : Cumulus d'avant-plan aux coins bas gauche & droit (calottes blanches + ombres bleues).
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
if str(REPO_ROOT / "source") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "source"))

from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
    extract_canonical_palette,
    key_magenta,
    load_bpl_cyan_ramp,
    quantize_rgb_to_palette,
    quantize_rgba_to_palette,
)

MAP_ID = "STC1"
MAP_TITLE = "Sommet de la Tour Céleste — Arène de Rayquaza"
RAW_DIR = HERE / "bruts"
REF_DIR = HERE / "references"
ARENA_MAGENTA_RAW = RAW_DIR / "arene_nuage_reference_magenta.png"
PLANET_CLEAN_RAW = RAW_DIR / "planete_terre_reference_exacte.png"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_celeste_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_palettes() -> Tuple[np.ndarray, np.ndarray]:
    """Construit la palette pixel-art unifiée fidèle à `ref_sommet_planete_rayquaza.png`."""
    earth_pal = extract_canonical_palette(
        [
            REF_DIR / "ref_sommet_planete_rayquaza.png",
            PLANET_CLEAN_RAW,
        ],
        max_colors=96,
        min_pixels=8,
    )
    arena_raw = np.asarray(Image.open(ARENA_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)
    non_mag = ~((arena_raw[:, :, 0] > 235) & (arena_raw[:, :, 1] < 25) & (arena_raw[:, :, 2] > 235))
    uniq, cnt = np.unique(arena_raw[non_mag], axis=0, return_counts=True)
    cloud_pal = uniq[np.argsort(-cnt)[:72]]

    anchors = np.array(
        [
            [2, 6, 36],
            [5, 12, 54],
            [10, 26, 92],
            [18, 56, 168],
            [24, 78, 192],
            [30, 108, 214],
            [48, 156, 244],
            [118, 226, 252],
            [196, 250, 254],
            [236, 255, 255],
            [250, 253, 255],
        ],
        dtype=np.uint8,
    )
    unified_pal = np.unique(np.vstack([earth_pal, cloud_pal, anchors]), axis=0).astype(np.uint8)
    # Filtre de sécurité absolue : zéro nuance violette/magenta (`R > G + 4`) dans la palette finale !
    keep = unified_pal[:, 0].astype(int) <= (unified_pal[:, 1].astype(int) + 4)
    unified_pal = unified_pal[keep]
    earth_keep = earth_pal[:, 0].astype(int) <= (earth_pal[:, 1].astype(int) + 4)
    return earth_pal[earth_keep], unified_pal


def build_earth_and_cosmos_layers(
    w: int,
    h: int,
    earth_pal: np.ndarray,
    unified_pal: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit :
    - `STC1_00` (`poses = 24`) : fond spatial bleu nuit profond + étoiles lointaines scintillantes,
    - `STC1_01` (`poses = 24`) : étoiles héroïques scintillantes du cosmos,
    - `STC1_02` (`poses = 1`)  : Planète Terre complète & alizés spiralés fidèles à la référence."""
    planet_src = np.asarray(
        Image.open(PLANET_CLEAN_RAW).convert("RGB").resize((w, h), Image.Resampling.NEAREST),
        dtype=np.uint8,
    ).copy()

    xs = np.arange(w, dtype=np.float32)
    u_norm = (xs - 0.5 * w) / (0.5 * w)
    yy = np.arange(h, dtype=np.float32)[:, None]

    # Courbe exacte du limbe lumineux mesurée sur `ref_sommet_planete_rayquaza.png` (`[b, a] = [63.7, 73.0]` à `768×576`)
    y_limb = (0.1268 * h + 0.1106 * h * (u_norm**2))[None, :]
    rel_y = yy - y_limb
    atmo_top_px = max(8.0, 20.0 * (h / float(H_CANON)))

    planet_q = quantize_rgb_to_palette(planet_src, earth_pal)
    planet_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    planet_mask = rel_y >= -atmo_top_px
    planet_rgba[planet_mask, :3] = planet_q[planet_mask]
    planet_rgba[planet_mask, 3] = 255
    static_planet_02 = [Image.fromarray(planet_rgba, mode="RGBA")]

    # Espace sidéral pur au-dessus du limbe (`rel_y < -atmo_top_px`) + étoiles lointaines
    space_grad = np.clip((-rel_y - atmo_top_px) / max(1.0, 0.20 * h), 0.0, 1.0)
    space_step = np.round(space_grad * 3.0) / 3.0
    c_space_top = np.array([2.0, 6.0, 36.0], dtype=np.float32)[None, None, :]
    c_space_low = np.array([6.0, 14.0, 56.0], dtype=np.float32)[None, None, :]
    space_rgb = np.clip(
        np.rint(c_space_low * (1.0 - space_step[:, :, None]) + c_space_top * space_step[:, :, None]),
        0,
        255,
    ).astype(np.uint8)
    space_q = quantize_rgb_to_palette(space_rgb, earth_pal)

    deep_stars = [
        (0.04, 0.05, 1), (0.11, 0.12, 8), (0.18, 0.04, 15), (0.25, 0.08, 3),
        (0.34, 0.03, 11), (0.42, 0.07, 19), (0.58, 0.07, 6), (0.66, 0.03, 14),
        (0.75, 0.08, 21), (0.83, 0.05, 4), (0.90, 0.13, 12), (0.96, 0.06, 17),
        (0.07, 0.17, 20), (0.93, 0.17, 9),
    ]
    c_dim = quantize_rgb_to_palette(np.array([[[72, 112, 196]]], dtype=np.uint8), unified_pal)[0, 0]
    c_mid = quantize_rgb_to_palette(np.array([[[156, 212, 255]]], dtype=np.uint8), unified_pal)[0, 0]

    frames_00: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr0 = np.concatenate([space_q.copy(), np.full((h, w, 1), 255, dtype=np.uint8)], axis=2)
        for fx, fy, ph in deep_stars:
            px, py = int(w * fx), int(h * fy)
            if py >= int(y_limb[0, px] - atmo_top_px) - 2:
                continue
            sv = np.sin(2.0 * np.pi * ((t + ph) / float(N_FRAMES)))
            if sv > 0.15:
                arr0[py, px, :3] = c_mid if sv > 0.68 else c_dim
        frames_00.append(Image.fromarray(arr0, mode="RGBA"))

    c_white = quantize_rgb_to_palette(np.array([[[255, 255, 255]]], dtype=np.uint8), unified_pal)[0, 0]
    c_cyan = quantize_rgb_to_palette(np.array([[[168, 240, 255]]], dtype=np.uint8), unified_pal)[0, 0]
    c_blue = quantize_rgb_to_palette(np.array([[[86, 152, 240]]], dtype=np.uint8), unified_pal)[0, 0]

    hero_stars = [
        (0.06, 0.08, 0, True),
        (0.15, 0.04, 6, False),
        (0.22, 0.09, 13, True),
        (0.31, 0.05, 19, False),
        (0.47, 0.04, 4, True),
        (0.55, 0.06, 11, False),
        (0.69, 0.04, 17, False),
        (0.79, 0.08, 22, True),
        (0.87, 0.05, 8, False),
        (0.94, 0.10, 15, True),
        (0.03, 0.14, 12, False),
        (0.97, 0.15, 3, False),
    ]
    frames_01: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr_st = np.zeros((h, w, 4), dtype=np.uint8)
        for fx, fy, ph_s, is_major in hero_stars:
            cx, cy = int(w * fx), int(h * fy)
            if cy >= int(y_limb[0, cx] - atmo_top_px) - 3:
                continue
            s_val = np.sin(2.0 * np.pi * ((t + ph_s) / float(N_FRAMES)))
            if s_val < -0.35:
                arr_st[cy, cx, :3] = c_blue
                arr_st[cy, cx, 3] = 255
            elif s_val < 0.30:
                arr_st[cy, cx, :3] = c_cyan
                arr_st[cy, cx, 3] = 255
            elif s_val < 0.74 or not is_major:
                arr_st[cy, max(0, cx - 1) : min(w, cx + 2), :3] = c_cyan
                arr_st[cy, max(0, cx - 1) : min(w, cx + 2), 3] = 255
                arr_st[max(0, cy - 1) : min(h, cy + 2), cx, :3] = c_cyan
                arr_st[max(0, cy - 1) : min(h, cy + 2), cx, 3] = 255
                arr_st[cy, cx, :3] = c_white
            else:
                for arm in (-2, -1, 1, 2):
                    if 0 <= cx + arm < w:
                        arr_st[cy, cx + arm, :3] = c_blue if abs(arm) == 2 else c_cyan
                        arr_st[cy, cx + arm, 3] = 255
                    if 0 <= cy + arm < h:
                        arr_st[cy + arm, cx, :3] = c_blue if abs(arm) == 2 else c_cyan
                        arr_st[cy + arm, cx, 3] = 255
                arr_st[cy, cx, :3] = c_white
                arr_st[cy, cx, 3] = 255
        frames_01.append(Image.fromarray(arr_st, mode="RGBA"))

    return frames_00, frames_01, static_planet_02


def extract_reference_cloud_arena_multilayer(
    w: int,
    h: int,
    unified_pal: np.ndarray,
) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Décompose sans perte ni chevauchement la grande tour nuageuse cumulonimbus et son pont
    de nuages Sud -> Nord (`arene_nuage_reference_magenta.png`) calés à `1 px` sur la référence
    `ref_sommet_planete_rayquaza.png` (`y0 = 0.160 * h`, `w_ar = 0.958 * w`) en `5` couches `BG` :
    - `arr_03` : massif cumulonimbus profond (cobalt & indigo),
    - `arr_04` : deux grands croissants de vent latéraux gauche & droit,
    - `arr_05` : assise pervenche sculptée autour de la cuvette & des flancs du pont,
    - `arr_06` : cuvette praticable de l'arène circulaire & chemin nuageux Sud -> Nord,
    - `arr_07` : bourrelets cumulus lumineux (blancs & bleu glace) du rebord d'arène et du pont."""
    raw_im = Image.open(ARENA_MAGENTA_RAW).convert("RGB")
    y0 = int(round(0.160 * h))
    w_ar = max(64, int(round(0.958 * w / 2.0)) * 2)
    h_ar = h - y0
    x0 = (w - w_ar) // 2

    scaled_rgb = np.asarray(raw_im.resize((w_ar, h_ar), Image.Resampling.NEAREST), dtype=np.uint8).copy()
    is_mag = (scaled_rgb[:, :, 0] > 235) & (scaled_rgb[:, :, 1] < 25) & (scaled_rgb[:, :, 2] > 235)
    # Purge absolue de tout éventuel pixel prune/anti-aliasé résiduel (`R > G + 4`)
    is_mag |= scaled_rgb[:, :, 0].astype(int) > (scaled_rgb[:, :, 1].astype(int) + 4)

    q_sub = quantize_rgb_to_palette(scaled_rgb, unified_pal)
    full_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    valid_sub = ~is_mag
    full_rgba[y0:, x0 : x0 + w_ar, :3][valid_sub] = q_sub[valid_sub]
    full_rgba[y0:, x0 : x0 + w_ar, 3][valid_sub] = 255

    opaque = full_rgba[:, :, 3] > 0
    lum = (
        0.299 * full_rgba[:, :, 0].astype(np.float32)
        + 0.587 * full_rgba[:, :, 1].astype(np.float32)
        + 0.114 * full_rgba[:, :, 2].astype(np.float32)
    )
    yy, xx = np.mgrid[:h, :w].astype(np.float32)

    # 1. Zone praticable continue `POV PMD` :
    #    - Cuvette circulaire sommitale de Rayquaza (`cx = 0.50w, cy = 0.372h, rx = 0.195w, ry = 0.128h`),
    #    - Chaussée nuageuse bouffante Sud -> Nord (`y >= 0.372h`, `|x - 0.50w| <= half_w(y)`) jusqu'à `y = h - 1` !
    bowl_mask = (((xx - 0.50 * w) / (0.195 * w)) ** 2 + ((yy - 0.372 * h) / (0.128 * h)) ** 2) <= 1.0
    t_south = np.clip((yy - 0.372 * h) / max(1.0, 0.628 * h), 0.0, 1.0)
    bridge_half_w = (0.068 + 0.018 * t_south) * w
    bridge_mask = (yy >= 0.372 * h) & (np.abs(xx - 0.50 * w) <= bridge_half_w)
    walkable_zone = opaque & (bowl_mask | bridge_mask)

    # 2. Grands croissants de vent latéraux gauche & droit (`|x - 0.50w| >= 0.255w` et clairs `lum >= 152`)
    wing_zone = opaque & (~walkable_zone) & (np.abs(xx - 0.50 * w) >= 0.255 * w) & (lum >= 152.0)

    # 3. Partition en 3 plans d'éclairage du reste du cumulonimbus géant (zéro chevauchement !) :
    rem = opaque & (~walkable_zone) & (~wing_zone)
    crest_puffs = rem & (lum >= 196.0)
    mid_periwinkle = rem & (lum >= 142.0) & (lum < 196.0)
    deep_collar = rem & (lum < 142.0)

    def _pack(m: np.ndarray) -> np.ndarray:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m] = full_rgba[m]
        return out

    return (
        _pack(deep_collar),
        _pack(wing_zone),
        _pack(mid_periwinkle),
        _pack(walkable_zone),
        _pack(crest_puffs),
        walkable_zone,
    )


def extract_foreground_corner_cumulus(w: int, h: int, unified_pal: np.ndarray) -> Image.Image:
    """Extrait sans écrasement d'aspect (`ratio 1.18:1` rond et duveteux fidèle à la référence)
    les cumulus d'avant-plan aux coins bas gauche et bas droit (`Layer = 4` `Top`, `poses = 1`)."""
    keyed = key_magenta(
        Image.open(RAW_DIR / "ailes_et_cumulus_avant_magenta.png"),
        erode_fringe=2,
        min_component_area=80,
    )
    raw_arr = np.asarray(keyed, dtype=np.uint8).copy()
    sh, sw = raw_arr.shape[:2]
    sub = raw_arr[sh // 2 :, : sw // 2, :].copy()
    ys, xs = np.where(sub[:, :, 3] > 0)
    im_top = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    if ys.size >= 32:
        crop = sub[int(ys.min()) : int(ys.max()) + 1, int(xs.min()) : int(xs.max()) + 1].copy()
        crop_q = quantize_rgba_to_palette(Image.fromarray(crop, mode="RGBA"), unified_pal)
        cw = max(24, int(round(w * 0.312)))
        ch = max(24, int(round(h * 0.408)))
        bank_l = crop_q.resize((cw, ch), Image.Resampling.NEAREST)
        bank_r = bank_l.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        im_top.alpha_composite(bank_l, (0, h - ch))
        im_top.alpha_composite(bank_r, (w - cw, h - ch))
    return im_top


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    bpl_path = REF_DIR / "rom_d13p01_bpl.json"
    earth_pal, unified_pal = build_palettes()

    # 1. Cosmos étoilé scintillant (`00`, `01`) + Planète Terre & alizés de référence (`02` statique)
    frames_00, frames_01, static_planet_02 = build_earth_and_cosmos_layers(w, h, earth_pal, unified_pal)

    # 2. Tour nuageuse cumulonimbus, croissants de vent, cuvette d'arène & pont Sud -> Nord (`03..07` statiques)
    arr_03, arr_04, arr_05, arr_06, arr_07, walkable_zone = extract_reference_cloud_arena_multilayer(
        w, h, unified_pal
    )

    # 3. `STC1_08` : scintillement discret `D13P01.bpl` (`24` poses) sur les croissants clairs de la cuvette
    bpl_ramp = load_bpl_cyan_ramp(bpl_path, unified_pal)
    inner_bowl_crescents = (
        walkable_zone
        & (arr_06[:, :, 0] >= 224)
        & (arr_06[:, :, 1] >= 242)
    )
    frames_08: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr_08 = np.zeros((h, w, 4), dtype=np.uint8)
        arr_08[inner_bowl_crescents, :3] = bpl_ramp[t]
        arr_08[inner_bowl_crescents, 3] = 255
        frames_08.append(Image.fromarray(arr_08, mode="RGBA"))

    # 4. `STC1_09` (`Top`, `Layer = 4`) : cumulus d'avant-plan aux coins bas gauche et droit, STATIQUES (`poses = 1`)
    static_top_09 = extract_foreground_corner_cumulus(w, h, unified_pal)

    # 5. Grille de collision `96 × 72` : pont de nuages Sud -> Nord continu jusqu'au cœur de la cuvette !
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            block = walkable_zone[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(block.mean()) >= 0.65

    labeled_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        south_labels = set(labeled_w[-1, :].tolist()) - {0}
        if south_labels:
            walk_grid = np.isin(labeled_w, list(south_labels))

    layers = [
        LayerEntry("00_stratosphere_ultramarine", "Cosmos Etoile Profond", "BG", frames_00),
        LayerEntry("01_etoiles_stratosphere", "Etoiles Scintillantes Cosmos", "BG", frames_01),
        LayerEntry("02_horizon_planetaire_courbe", "Planete Terre & Alizes Reference", "BG", static_planet_02),
        LayerEntry("03_nappes_altitude_profondes", "Massif Cumulonimbus Profond", "BG", [Image.fromarray(arr_03, "RGBA")]),
        LayerEntry("04_ailes_vent_sculptees_proches", "Croissants Vent Lateraux", "BG", [Image.fromarray(arr_04, "RGBA")]),
        LayerEntry("05_couronne_volumetrique_ombre", "Assise Pervenche Arene & Pont", "BG", [Image.fromarray(arr_05, "RGBA")]),
        LayerEntry("06_sol_couronne_rayquaza", "Cuvette Arene & Chemin Nuage", "BG", [Image.fromarray(arr_06, "RGBA")]),
        LayerEntry("07_reliefs_cretes_couronne", "Bourrelets Lumineux Couronne", "BG", [Image.fromarray(arr_07, "RGBA")]),
        LayerEntry("08_respiration_bpl_couronne", "Reflets Internes Cuvette BPL", "BG", frames_08),
        LayerEntry("09_sillages_courants_jet", "Cumulus Avant-Plan Statiques", "Top", [static_top_09]),
    ]
    return layers, walk_grid, unified_pal


def main() -> None:
    layers, walk_grid, _ = build_layers_for_size(W_CANON, H_CANON)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=RENDERS_DIR,
        virtual_zip_path=VIRTUAL_ZIP,
        canonical_ref_for_fidelity=REF_DIR / "ref_sommet_planete_rayquaza.png",
        max_fidelity_distance=15.0,
    )
    print(json.dumps(meta, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
