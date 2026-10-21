#!/usr/bin/env python3
"""
Scène du Réveil V2 (`zone_reveil_prairie_horizon_v2` : Jour · Aube · Crépuscule · Nuit)
appliquée aux 10 Falaises Côtières Centrées au Premier Plan (100 % Textures Canoniques Grass Métano).

Produit les 40 cartes PMDO 0.8.12 (`10 falaises × 4 ambiances = 40 .rsground`) :
  - `jour`       : Ciel clair V24P04A + cumulus d'horizon + mer V24P04A 12 crans (houle, crêtes à double bosse,
                   ligne de houle 1px continue, ondes en orbite, scintillement d'horizon) + plateau Grass Métano canonique
  - `aube`       : Ciel violet -> rose-pêche doré + grand Soleil levant doré + colonne de reflet doré ondulant sur 12 crans
                   + crêtes illuminées d'or au passage dans le reflet + nuages rosés-dorés + plateau Métano lumière d'aube
  - `crepuscule` : Ciel violet profond -> orange-vermillon + grand Soleil couchant rouge-orangé caressé par les nuages
                   + colonne de reflet orange ardent ondulant sur 12 crans + crêtes embrasées + plateau Métano lumière du soir
  - `nuit`       : Exacte Nuit de la Scène du Réveil (PMD Sky) : ciel bleu nuit profond + 58 étoiles scintillantes animées
                   (12 phases, loi 5 états éteint -> cœur -> plein -> cœur -> éteint) + grande Pleine Lune cratérisée jaune-ivoire
                   + nuages nocturnes gris-bleu éclairés par la lune + océan bleu saphir-outremer ZRV1/ZRV2 + grande colonne de
                   reflet lunaire argent-ivoire ondulant sur 12 crans + crêtes de vagues illuminées d'argent sous la lune
                   + plateau Grass Métano Nuit canonique Abyss V4 (`entire_base_cliffs_fringe_night_sheets_equal = true`).
"""
from __future__ import annotations

import copy
import hashlib
import io
import json
import math
import shutil
import sys
import uuid
import zipfile
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image
from scipy.ndimage import binary_dilation, label

ROOT = Path("/home/user/projet-creation-pmdo")
sys.path.insert(0, str(ROOT / "source/cliff_nord_centre_v1"))

from build import (  # noqa: E402
    ANIM_DIR,
    GW,
    GH,
    H,
    HORIZON_Y,
    INSTALLER_SRC,
    OUT_DIR,
    PNG_DIR,
    W,
    WEB_DIR,
    CompactTileBank,
    encode_layer_from_frames,
    load_template_ground,
    make_empty_layer,
    make_map_bg,
    make_obstacles_grid,
    write_dir_sheet,
    write_tile_index_idx,
)

BRUTS = ROOT / "source/cliff_nord_centre_v1/reveil_bruts"
PROV_DIR = OUT_DIR / "provenance_canonique"
INDIV_DIR = OUT_DIR / "mods_individuels"
STAGE_DIR = Path("/tmp/stage_reveil_cliff_pmdo")

MODES = ("jour", "aube", "crepuscule", "nuit")
MODE_LABELS = {
    "jour": "Jour — V24P04A",
    "aube": "Aube — Soleil Levant",
    "crepuscule": "Crépuscule — Soleil Couchant",
    "nuit": "Nuit — Scène du Réveil (Pleine Lune)",
}

SWELL_STEPS = 12
SWELL_TICKS = 10  # Exact ROM V24P04A cadence: 12 * 10 ticks = 120 ticks (2.00 s @ 60 Hz)
PERIOD_X = 96     # 12 tiles * 8 px -> seamless horizontal periodicity outside the reflection column!
CLOUD_W = 1440    # 180 tiles * 8 px seamless RepeatX strip

SEA_H = H - HORIZON_Y  # 584 px (y = 296 .. 880)

# Positions des astres choisies dans les grands golfes marins Nord-Ouest / Nord-Est
# où 150..420 px de mer ouverte sont 100 % dégagés sur CHACUNE des 10 versions de falaise :
ASTRE_CFG = {
    "aube": {
        "cx": 240,
        "cy": 138,
        "radius_glow": 175,
        "glow_rgb": (255, 226, 172),
        "glow_strength": 0.34,
        "src_box": (504, 187, 904, 581),
        "target_w": 84,
        "reflet_col": 1,
        "core_rgb": (254, 246, 176),
        "mid_rgb": (247, 208, 122),
        "halo_rgb": (232, 182, 138),
        "glint_rgb": (255, 240, 188),
        "light_rgb": (254, 238, 172),
    },
    "crepuscule": {
        "cx": 960,
        "cy": 182,  # Bas sur l'horizon : le haut des cumulus embrasés passe juste devant le bas du disque !
        "radius_glow": 195,
        "glow_rgb": (255, 148, 66),
        "glow_strength": 0.40,
        "src_box": (950, 187, 1356, 581),
        "target_w": 88,
        "reflet_col": 2,
        "core_rgb": (252, 146, 52),
        "mid_rgb": (232, 88, 28),
        "halo_rgb": (178, 52, 24),
        "glint_rgb": (250, 152, 74),
        "light_rgb": (246, 132, 58),
    },
    "nuit": {
        "cx": 960,
        "cy": 96,   # Grande Pleine Lune haute dans le ciel étoilé au-dessus des nuages nocturnes !
        "radius_glow": 165,
        "glow_rgb": (132, 168, 232),
        "glow_strength": 0.24,
        "src_box": (52, 188, 458, 580),
        "target_w": 88,
        "reflet_col": 0,
        "core_rgb": (250, 244, 216),
        "mid_rgb": (218, 224, 212),
        "halo_rgb": (152, 176, 222),
        "glint_rgb": (222, 232, 250),
        "light_rgb": (232, 236, 242),
    },
}

# Dégradés verticaux du ciel (fidèles à `ZRV1` & `ZRV2`)
SKY_STOPS = {
    "jour": [
        (0.00, (58, 126, 244)),
        (0.42, (96, 162, 248)),
        (0.76, (138, 198, 252)),
        (1.00, (182, 230, 255)),
    ],
    "aube": [
        (0.00, (98, 82, 158)),
        (0.35, (156, 112, 172)),
        (0.68, (218, 158, 182)),
        (0.88, (246, 192, 180)),
        (1.00, (254, 220, 186)),
    ],
    "crepuscule": [
        (0.00, (40, 26, 84)),
        (0.34, (98, 44, 96)),
        (0.66, (178, 76, 84)),
        (0.86, (232, 112, 62)),
        (1.00, (250, 152, 58)),
    ],
    "nuit": [
        (0.00, (5, 15, 56)),
        (0.38, (12, 34, 92)),
        (0.72, (24, 58, 128)),
        (1.00, (44, 88, 162)),
    ],
}

# Palettes exactes de mer `ZRV1/ZRV2` (de l'horizon `t=0` vers le premier plan `t=1`)
SEA_STOPS = {
    "jour": [
        (0.000, (167, 215, 255)),
        (0.030, (95, 175, 231)),
        (0.090, (29, 157, 196)),
        (0.260, (16, 142, 198)),
        (0.550, (11, 126, 186)),
        (1.000, (18, 98, 152)),
    ],
    "aube": [
        (0.000, (248, 212, 198)),
        (0.045, (217, 174, 164)),
        (0.140, (184, 152, 152)),
        (0.360, (152, 131, 139)),
        (0.680, (116, 113, 132)),
        (1.000, (89, 100, 126)),
    ],
    "crepuscule": [
        (0.000, (226, 156, 141)),
        (0.045, (185, 116, 116)),
        (0.140, (146, 91, 104)),
        (0.360, (111, 72, 96)),
        (0.680, (76, 57, 94)),
        (1.000, (57, 50, 89)),
    ],
    "nuit": [
        (0.000, (102, 134, 196)),
        (0.045, (68, 108, 174)),
        (0.140, (36, 83, 157)),
        (0.360, (10, 59, 140)),
        (0.680, (2, 42, 128)),
        (1.000, (0, 26, 121)),
    ],
}

# Palettes de crêtes d'écume `V24P04A` par ambiance (`[ombre_creux, mi_teinte, écume_claire]`)
CREST_PALETTES = {
    "jour": ((16, 108, 168), (126, 212, 246), (246, 253, 255)),
    "aube": ((112, 102, 124), (218, 178, 168), (254, 232, 210)),
    "crepuscule": ((68, 48, 84), (176, 110, 112), (234, 166, 148)),
    "nuit": ((2, 34, 122), (82, 122, 190), (162, 190, 238)),
}

# Palettes exactes de nuages `ZRV1/ZRV2` (du bas ombré vers le sommet éclairé)
CLOUD_PALETTES = {
    "jour": [
        (0.00, (142, 178, 213)),
        (0.38, (168, 198, 228)),
        (0.72, (214, 232, 248)),
        (1.00, (250, 253, 255)),
    ],
    "aube": [
        (0.00, (214, 158, 178)),
        (0.35, (242, 192, 196)),
        (0.72, (252, 218, 206)),
        (1.00, (254, 240, 212)),
    ],
    "crepuscule": [
        (0.00, (86, 54, 92)),
        (0.36, (142, 76, 98)),
        (0.72, (214, 122, 98)),
        (1.00, (252, 182, 126)),
    ],
    "nuit": [
        (0.00, (39, 79, 143)),
        (0.36, (79, 111, 175)),
        (0.72, (135, 167, 207)),
        (1.00, (191, 199, 223)),
    ],
}


def save_png_compact(im: Image.Image, path: Path, indexed: bool = True) -> None:
    """Sauvegarde PNG 1× sans perte : quantifié P-mode sur images opaques, RGBA direct sans perte sur calques transparents."""
    path.parent.mkdir(parents=True, exist_ok=True)
    rgba = im.convert("RGBA")
    arr = np.asarray(rgba)
    if indexed and np.all(arr[..., 3] == 255):
        uniq = np.unique(arr[..., :3].reshape(-1, 3), axis=0)
        if len(uniq) <= 256:
            q = rgba.convert("RGB").quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
            q.save(path, format="PNG", optimize=True, compress_level=9)
            return
    rgba.save(path, format="PNG", optimize=True, compress_level=9)


def interp_stops(stops: List[Tuple[float, Tuple[int, int, int]]], t: np.ndarray) -> np.ndarray:
    ts = np.array([s[0] for s in stops], dtype=np.float64)
    cs = np.array([s[1] for s in stops], dtype=np.float64)
    tf = np.asarray(t, dtype=np.float64)
    out = np.zeros(tf.shape + (3,), dtype=np.float64)
    for c in range(3):
        out[..., c] = np.interp(tf, ts, cs[:, c])
    return np.clip(np.rint(out), 0, 255).astype(np.uint8)


def unkey_magenta(arr_rgb: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    """Extrait le masque avant-plan net et supprime toute frange magenta sur les bords."""
    r = arr_rgb[..., 0].astype(np.int32)
    g = arr_rgb[..., 1].astype(np.int32)
    b = arr_rgb[..., 2].astype(np.int32)
    is_mag = (r > 185) & (b > 185) & (g < 105) & ((r - g) > 95) & ((b - g) > 95)
    fg = ~is_mag
    clean = arr_rgb.copy()
    # Sur les rares pixels de bord légèrement contaminés par le magenta, remplacer par le voisin pur le plus proche
    spill = fg & ((r - g) > 70) & ((b - g) > 70)
    if np.any(spill):
        pure = fg & (~spill)
        ys, xs = np.where(spill)
        py, px = np.where(pure)
        if len(py) > 0:
            for y, x in zip(ys, xs):
                d2 = (py - y) ** 2 + (px - x) ** 2
                j = int(np.argmin(d2))
                clean[y, x] = arr_rgb[py[j], px[j]]
    return clean, fg


def extract_celestial_sprites() -> Dict[str, Image.Image]:
    """Extrait la Pleine Lune, le Soleil levant et le Soleil couchant depuis `astres.png`."""
    src = np.asarray(Image.open(BRUTS / "astres.png").convert("RGB"))
    clean, fg = unkey_magenta(src)
    out: Dict[str, Image.Image] = {}
    for mode, cfg in ASTRE_CFG.items():
        x0, y0, x1, y1 = cfg["src_box"]
        sub_rgb = clean[y0:y1, x0:x1]
        sub_fg = fg[y0:y1, x0:x1]
        rgba = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
        rgba[..., :3] = sub_rgb
        rgba[..., 3] = np.where(sub_fg, 255, 0)
        tw = cfg["target_w"]
        th = max(1, round(tw * (y1 - y0) / (x1 - x0)))
        spr = Image.fromarray(rgba, "RGBA").resize((tw, th), Image.Resampling.NEAREST)
        canvas = Image.new("RGBA", (W, HORIZON_Y), (0, 0, 0, 0))
        canvas.alpha_composite(spr, (cfg["cx"] - tw // 2, cfg["cy"] - th // 2))
        out[mode] = canvas
    return out


def build_sky_gradients() -> Dict[str, Image.Image]:
    """Construit les ciels `1200 × 880` avec bandes Chunsoft fines + halo doux autour de l'astre."""
    out: Dict[str, Image.Image] = {}
    t_row = np.linspace(0.0, 1.0, HORIZON_Y, dtype=np.float32)
    # Quantification par paliers de 2 lignes style V24P04A pour un rendu pixel-art PMD Sky authentique
    t_quant = np.floor(t_row * 96.0) / 96.0

    yy, xx = np.mgrid[0:HORIZON_Y, 0:W].astype(np.float32)
    for mode in MODES:
        row_rgb = interp_stops(SKY_STOPS[mode], t_quant)
        sky_arr = np.broadcast_to(row_rgb[:, None, :], (HORIZON_Y, W, 3)).copy().astype(np.float32)

        if mode in ASTRE_CFG:
            cfg = ASTRE_CFG[mode]
            dist = np.hypot((xx - cfg["cx"]) * 0.92, yy - cfg["cy"])
            w = np.clip(1.0 - dist / cfg["radius_glow"], 0.0, 1.0) ** 2.1
            # Paliers pixel-art doux (12 crans) sans dithering baveux
            w = (np.floor(w * 12.0) / 12.0) * cfg["glow_strength"]
            glow = np.array(cfg["glow_rgb"], dtype=np.float32)
            sky_arr = sky_arr * (1.0 - w[..., None]) + glow * w[..., None]

        full = np.zeros((H, W, 4), dtype=np.uint8)
        full[..., 3] = 255
        full[:HORIZON_Y, :, :3] = np.clip(np.rint(sky_arr), 0, 255).astype(np.uint8)
        # Remplir sous l'horizon avec la teinte moyenne d'océan par sécurité
        sea_fill = interp_stops(SEA_STOPS[mode], np.linspace(0.0, 1.0, SEA_H, dtype=np.float32))
        full[HORIZON_Y:, :, :3] = sea_fill[:, None, :]
        out[mode] = Image.fromarray(full, "RGBA")
    return out


def build_night_star_frames() -> List[Image.Image]:
    """58 étoiles PMD Sky scintillant sur 12 phases selon la loi exacte à 5 états de `ZRV1/ZRV2`."""
    rng = np.random.default_rng(20260812)
    moon_cx, moon_cy = ASTRE_CFG["nuit"]["cx"], ASTRE_CFG["nuit"]["cy"]
    stars = []
    attempts = 0
    while len(stars) < 58 and attempts < 4000:
        attempts += 1
        sx = int(rng.integers(14, W - 14))
        sy = int(rng.integers(10, 198))  # Au-dessus de la crête des cumulus nocturnes (y >= 204) !
        if math.hypot(sx - moon_cx, sy - moon_cy) < 62:
            continue
        if any(abs(sx - ox) < 22 and abs(sy - oy) < 18 for ox, oy, _, _ in stars):
            continue
        kind = int(rng.choice([0, 1, 2], p=[0.42, 0.36, 0.22]))  # 0: fine, 1: diamant 3x3, 2: croix 5x5
        ph0 = int(rng.integers(0, SWELL_STEPS))
        stars.append((sx, sy, kind, ph0))

    core_c = (246, 250, 255, 255)
    mid_c = (158, 196, 252, 255)
    dim_c = (86, 130, 212, 255)

    frames: List[Image.Image] = []
    for s in range(SWELL_STEPS):
        arr = np.zeros((H, W, 4), dtype=np.uint8)
        for sx, sy, kind, ph0 in stars:
            k = (s + ph0) % SWELL_STEPS
            # Loi exacte `star_frames` de ZRV1/ZRV2 : éteint -> cœur -> plein -> cœur -> éteint
            if k in (0, 1, 11):
                state = 0  # éteint / veille douce
            elif k in (2, 3, 9, 10):
                state = 1  # cœur
            else:
                state = 2  # plein éclat

            if kind == 0:
                if state == 1:
                    arr[sy, sx] = dim_c
                elif state == 2:
                    arr[sy, sx] = mid_c
            elif kind == 1:
                if state == 0:
                    arr[sy, sx] = dim_c
                elif state == 1:
                    arr[sy, sx] = core_c
                else:
                    arr[sy, sx] = core_c
                    for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        arr[sy + dy, sx + dx] = mid_c
            else:
                if state == 0:
                    arr[sy, sx] = mid_c
                elif state == 1:
                    arr[sy, sx] = core_c
                    for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        arr[sy + dy, sx + dx] = dim_c
                else:
                    arr[sy, sx] = core_c
                    for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        arr[sy + dy, sx + dx] = mid_c
                    for dx, dy in ((-2, 0), (2, 0), (0, -2), (0, 2)):
                        arr[sy + dy, sx + dx] = dim_c
        frames.append(Image.fromarray(arr, "RGBA"))
    return frames


def build_seamless_clouds() -> Dict[str, Dict[str, Image.Image]]:
    """Extrait `banc_nuages.png`, assure un raccord cyclique `1440 px` sans couture, et recolore selon `ZRV1/ZRV2`."""
    src = np.asarray(Image.open(BRUTS / "banc_nuages.png").convert("RGB"))
    clean, fg = unkey_magenta(src)
    ys, _ = np.where(fg)
    y0 = int(ys.min())
    sub_rgb = clean[y0:, :]
    sub_fg = fg[y0:, :]

    rgba = np.zeros(sub_rgb.shape[:2] + (4,), dtype=np.uint8)
    rgba[..., :3] = sub_rgb
    rgba[..., 3] = np.where(sub_fg, 255, 0)
    bank_im = Image.fromarray(rgba, "RGBA").resize((CLOUD_W + 96, 90), Image.Resampling.NEAREST)
    bank_arr = np.asarray(bank_im).copy()

    seam = 96
    out_arr = bank_arr[:, :CLOUD_W].copy()
    tail = bank_arr[:, CLOUD_W : CLOUD_W + seam]
    w_seam = np.linspace(0.0, 1.0, seam, dtype=np.float32)[None, :, None]
    a_head = out_arr[:, :seam, 3:4] > 0
    a_tail = tail[:, :, 3:4] > 0
    blend_alpha = np.where(w_seam < 0.5, a_tail, a_head) | (a_head & a_tail)
    blend_rgb = np.clip(
        np.rint(tail[:, :, :3].astype(np.float32) * (1.0 - w_seam) + out_arr[:, :seam, :3].astype(np.float32) * w_seam),
        0,
        255,
    ).astype(np.uint8)
    out_arr[:, :seam, :3] = blend_rgb
    out_arr[:, :seam, 3:4] = np.where(blend_alpha, 255, 0)
    out_arr[-2:, :, 3] = 255

    vis = out_arr[..., 3] > 0
    lum = (
        0.299 * out_arr[..., 0].astype(np.float32)
        + 0.587 * out_arr[..., 1].astype(np.float32)
        + 0.114 * out_arr[..., 2].astype(np.float32)
    )
    vals = lum[vis]
    pcts = np.percentile(vals, np.linspace(0, 100, 17))
    rank = np.interp(lum, pcts, np.linspace(0.0, 1.0, 17)).astype(np.float32)
    rank = np.round(rank * 7.0) / 7.0

    # Second plan de cumulus lointains posé lui aussi sur `HORIZON_Y` (100 % pur NumPy, haut du ciel dégagé !)
    back_h = 108
    idx_y = np.rint(np.linspace(0, 89, back_h)).astype(int)
    back_rank = np.roll(rank[idx_y, :], CLOUD_W // 2, axis=1)
    back_vis = np.roll(vis[idx_y, :], CLOUD_W // 2, axis=1)
    back_rank = np.round(back_rank * 5.0) / 5.0

    result: Dict[str, Dict[str, Image.Image]] = {}
    for mode in MODES:
        rgb_h = interp_stops(CLOUD_PALETTES[mode], rank)
        im_hor = np.zeros((90, CLOUD_W, 4), dtype=np.uint8)
        im_hor[..., :3] = rgb_h
        im_hor[..., 3] = np.where(vis, 255, 0)

        rgb_hi = interp_stops(CLOUD_PALETTES[mode], np.clip(back_rank * 0.70 + 0.24, 0.0, 1.0))
        im_hi = np.zeros((back_h, CLOUD_W, 4), dtype=np.uint8)
        im_hi[..., :3] = rgb_hi
        im_hi[..., 3] = np.where(back_vis, 255, 0)

        result[mode] = {
            "horizon": Image.fromarray(im_hor, "RGBA"),
            "haut": Image.fromarray(im_hi, "RGBA"),
        }
    return result


def extract_crest_sprites() -> List[Tuple[np.ndarray, np.ndarray]]:
    """Extrait les crêtes d'écume à double bosse depuis `cretes_jour.png` en 5 tailles de perspective."""
    arr = np.asarray(Image.open(BRUTS / "cretes_jour.png").convert("RGB"))
    clean, fg = unkey_magenta(arr)
    boxes = [
        ((117, 149, 120, 467), 22),
        ((311, 343, 128, 459), 38),
        ((505, 541, 16, 349), 54),
        ((650, 704, 6, 358), 70),
        ((832, 887, 6, 358), 86),
    ]
    tiers: List[Tuple[np.ndarray, np.ndarray]] = []
    for (y0, y1, x0, x1), tw in boxes:
        sub_c = clean[y0:y1, x0:x1]
        sub_m = fg[y0:y1, x0:x1]
        rgba = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
        rgba[..., :3] = sub_c
        rgba[..., 3] = np.where(sub_m, 255, 0)
        th = max(2, round(tw * (y1 - y0) / (x1 - x0)))
        im = Image.fromarray(rgba, "RGBA").resize((tw, th), Image.Resampling.NEAREST)
        a = np.asarray(im)
        m = a[..., 3] > 0
        lum = (0.299 * a[..., 0] + 0.587 * a[..., 1] + 0.114 * a[..., 2]) / 255.0
        vMin, vMax = (float(lum[m].min()), float(lum[m].max())) if np.any(m) else (0.0, 1.0)
        tone = np.clip((lum - vMin) / max(1e-4, vMax - vMin), 0.0, 1.0)
        tiers.append((tone, m))
    return tiers


def extract_reflection_dashes() -> Dict[str, List[dict]]:
    """Extrait les traits horizontaux et petites étoiles de reflet de `reflets_astres.png` (méthode `reflet_dashes` ZRV2)."""
    src = np.asarray(Image.open(BRUTS / "reflets_astres.png").convert("RGB"))
    clean, fg = unkey_magenta(src)
    # Échelle pixel-art 1:3.4 -> hauteur ~226 px exactement calée sur l'ouverture marine (y = 297 .. 522) !
    sh = 226
    sw = round(src.shape[1] * sh / src.shape[0])
    rgba = np.zeros(src.shape[:2] + (4,), dtype=np.uint8)
    rgba[..., :3] = clean
    rgba[..., 3] = np.where(fg, 255, 0)
    scaled = np.asarray(Image.fromarray(rgba, "RGBA").resize((sw, sh), Image.Resampling.NEAREST))

    col_w = sw / 3.0
    rng = np.random.default_rng(7042)
    out: Dict[str, List[dict]] = {}
    for mode, cfg in ASTRE_CFG.items():
        ci = cfg["reflet_col"]
        x0 = max(0, int(round(ci * col_w)))
        x1 = min(sw, int(round((ci + 1) * col_w)))
        sub = scaled[:, x0:x1]
        m = sub[..., 3] > 0
        ys_all, xs_all = np.where(m)
        cx_local = float(np.median(xs_all))
        y_min, y_max = int(ys_all.min()), int(ys_all.max())
        lum = (0.299 * sub[..., 0] + 0.587 * sub[..., 1] + 0.114 * sub[..., 2]) / 255.0
        p45, p82 = np.percentile(lum[m], [45, 82])

        lbl, n_comp = label(m)
        dashes = []
        for idx in range(1, n_comp + 1):
            cy_s, cx_s = np.where(lbl == idx)
            if len(cx_s) == 0:
                continue
            by0, by1 = int(cy_s.min()), int(cy_s.max()) + 1
            bx0, bx1 = int(cx_s.min()), int(cx_s.max()) + 1
            mask = lbl[by0:by1, bx0:bx1] == idx
            vals = lum[by0:by1, bx0:bx1]
            # 3 niveaux de brillance PMD Sky : 2 = cœur incandescent, 1 = mi-teinte, 0 = halo doux
            tier = np.where(vals >= p82, 2, np.where(vals >= p45, 1, 0)).astype(np.uint8)
            dy_rel = int(round((by0 - y_min) * 218.0 / max(1, y_max - y_min)))
            dashes.append(
                {
                    "dy": dy_rel,
                    "dx0": int(round(bx0 - cx_local)),
                    "mask": mask,
                    "tier": tier,
                    "phase0": float(rng.uniform(0.0, 2.0 * math.pi)),
                }
            )
        out[mode] = dashes
    return out


def build_all_ocean_12phases() -> Dict[str, List[Image.Image]]:
    """
    Construit les 12 phases d'océan `V24P04A` + reflets de Lune / Soleil levant / Soleil couchant (`1200 × 880`)
    en appliquant fidèlement les 6 lois de `source/zone_reveil_prairie_horizon_v2/build.py` :
      1. Dégradé marin de référence par ambiance (`SEA_STOPS`)
      2. Étincelles scintillantes sous l'horizon (`glint_frames`)
      3. Ondes et plaques de houle en orbite elliptique (`ondes_frames`)
      4. Houle quadratique `V24P04A` (`PERIOD_X = 96 px`) + crêtes à double bosse + ligne continue `1 px` (`swell_frames`)
      5. Colonne de reflet ondulante sous la Lune (`nuit`), le Soleil levant (`aube`) et le Soleil couchant (`crepuscule`) (`reflet_frames`)
      6. Illumination progressive des crêtes de vagues traversant la colonne de reflet (`light_crests`) !
    """
    crest_tiers = extract_crest_sprites()
    dashes_by_mode = extract_reflection_dashes()

    # Loi d'accélération quadratique V24P04A adaptée à SEA_H = 584 px : y_local(u) = D0 + A*u + B*u^2
    N_ROWS = 9.0
    D0, A, B = 5.0, 12.0, 5.6
    # Pré-calcul de `u(dy)` pour synchroniser exactement l'ondulation du reflet avec le passage des crêtes !
    dy_vec = np.arange(SEA_H, dtype=np.float32)
    u_of_dy = (-A + np.sqrt(np.maximum(0.0, A * A + 4.0 * B * np.maximum(0.0, dy_vec - D0)))) / (2.0 * B)

    # Graines périodiques sur `PERIOD_X = 96 px` pour que 100 % de la mer hors reflet se déduplique sur 12 colonnes de tuiles !
    rng = np.random.default_rng(2404)
    glints = [(int(rng.integers(0, PERIOD_X)), int(rng.integers(1, 24)), int(rng.integers(0, SWELL_STEPS))) for _ in range(34)]
    orbit_ripples = [
        (
            int(rng.integers(0, PERIOD_X)),
            int(rng.integers(26, SEA_H - 12)),
            int(rng.integers(7, 22)),
            int(rng.choice([-1, 1])),
            float(rng.uniform(0.0, 2.0 * math.pi)),
        )
        for _ in range(44)
    ]

    # Dégradé marin de base quantifié en paliers nets Chunsoft (18 tons)
    t_sea = np.linspace(0.0, 1.0, SEA_H, dtype=np.float32) ** 0.78
    t_sea_q = np.round(t_sea * 17.0) / 17.0

    ocean_out: Dict[str, List[Image.Image]] = {}
    for mode in MODES:
        base_rows = interp_stops(SEA_STOPS[mode], t_sea_q)  # (SEA_H, 3)
        shadow_c, mid_c, foam_c = [np.array(c, dtype=np.float32) for c in CREST_PALETTES[mode]]
        frames: List[Image.Image] = []

        cfg = ASTRE_CFG.get(mode)
        for s in range(SWELL_STEPS):
            # 1) Fond marin périodique de base (période `PERIOD_X = 96 px` d'abord, puis dupliqué sur `W = 1200`)
            tile_strip = np.broadcast_to(base_rows[:, None, :], (SEA_H, PERIOD_X, 3)).copy()
            # Légère texture horizontale Chunsoft d'horizon
            for ry in (1, 3, 6, 10):
                tile_strip[ry, (ry * 7 + s * 2) % 4 :: 3] = np.clip(tile_strip[ry, 0].astype(int) + 22, 0, 255)

            # 2) Étincelles scintillantes sous l'horizon (`glint_frames`)
            glint_col = np.array(cfg["glint_rgb"] if cfg else (245, 252, 255), dtype=np.uint8)
            for gx, gy, gph in glints:
                k = (s + gph) % SWELL_STEPS
                if k in (1, 2, 3, 4):
                    tile_strip[gy, gx] = glint_col
                    if k in (2, 3):
                        tile_strip[gy, (gx + 1) % PERIOD_X] = glint_col

            # 3) Ondes et plaques en orbite elliptique (`ondes_frames`)
            for rx0, ry0, rw, sgn, rph in orbit_ripples:
                ang = rph + sgn * 2.0 * math.pi * s / SWELL_STEPS
                ox = int(round(4.0 * math.cos(ang)))
                oy = int(round(1.6 * math.sin(ang)))
                yy = ry0 + oy
                if 2 <= yy < SEA_H - 2:
                    xs = (np.arange(rx0 + ox, rx0 + ox + rw) % PERIOD_X)
                    tile_strip[yy, xs] = np.clip(tile_strip[yy, xs].astype(int) - 15, 0, 255)
                    tile_strip[yy + 1, xs[1:-1]] = np.clip(tile_strip[yy + 1, xs[1:-1]].astype(int) + 14, 0, 255)

            # Étendre le ruban périodique `96 px` sur `1200 px` (`12.5` périodes exactes)
            reps = (W + PERIOD_X - 1) // PERIOD_X
            sea_rgb = np.tile(tile_strip, (1, reps, 1))[:, :W, :].copy()

            # Halo doux de reflet diffus sur l'eau sous l'astre (`reflet_palette_7` de ZRV1/ZRV2 !)
            if cfg is not None:
                yy_s = np.arange(248, dtype=np.float32)[:, None]
                xx_s = np.arange(W, dtype=np.float32)[None, :]
                cone_half = 18.0 + 62.0 * (yy_s / 248.0)
                w_cone = np.clip(1.0 - np.abs(xx_s - cfg["cx"]) / cone_half, 0.0, 1.0) ** 1.8
                w_cone *= np.clip(1.0 - yy_s / 248.0, 0.0, 1.0) ** 0.55
                w_cone = (np.floor(w_cone * 6.0) / 6.0) * 0.34
                sheen_rgb = np.array(cfg["halo_rgb"], dtype=np.float32)[None, None, :]
                sub_sea = sea_rgb[:248].astype(np.float32)
                sea_rgb[:248] = np.clip(np.rint(sub_sea * (1.0 - w_cone[..., None]) + sheen_rgb * w_cone[..., None]), 0, 255).astype(np.uint8)

            # 4) Houle quadratique V24P04A (`swell_frames`) + ligne continue 1 px + illumination des crêtes (`light_crests`)
            for k in range(int(N_ROWS) + 1):
                u = k + s / float(SWELL_STEPS)
                dy = int(round(D0 + A * u + B * u * u))
                if dy < 1 or dy >= SEA_H - 1:
                    continue
                prog = min(1.0, dy / float(SEA_H * 0.72))
                # Ligne sombre continue de 1 px sous toute la largeur de la rangée de houle (`SWELL_LINE = 0.85` de ZRV2 !)
                line_y = min(SEA_H - 1, dy + 1)
                sea_rgb[line_y, :] = np.clip(np.rint(sea_rgb[line_y, :].astype(np.float32) * 0.84), 0, 255).astype(np.uint8)

                # Sélectionner le gabarit de crête selon la distance à l'horizon
                if dy < 16:
                    # Au très loin : petits traits fins de 8..14 px comme dans V24P04A
                    off_row = (k * 48) % PERIOD_X
                    for cx0 in range(-PERIOD_X + off_row, W + PERIOD_X, PERIOD_X):
                        w_far = 8 + (dy // 2)
                        x_seg = np.arange(max(0, cx0), min(W, cx0 + w_far))
                        if len(x_seg):
                            c_far = np.clip(foam_c * 0.88 + shadow_c * 0.12, 0, 255)
                            if cfg is not None:
                                half = 34.0 + 70.0 * (dy / 220.0)
                                w_lit = np.clip(1.0 - np.abs(x_seg - cfg["cx"]) / half, 0.0, 1.0)
                                lit_arr = np.array(cfg["light_rgb"], dtype=np.float32)
                                sea_rgb[dy, x_seg] = np.clip(
                                    np.rint(c_far[None, :] * (1.0 - w_lit[:, None]) + lit_arr[None, :] * w_lit[:, None]),
                                    0,
                                    255,
                                ).astype(np.uint8)
                            else:
                                sea_rgb[dy, x_seg] = c_far.astype(np.uint8)
                    continue

                tier_idx = min(4, int(prog * 5.0))
                tone, mask = crest_tiers[tier_idx]
                ch, cw = mask.shape
                off_row = (k * 48) % PERIOD_X  # Quinconce exacte d'une rangée sur deux (`PERIOD_X // 2 = 48`) !
                y_top = dy - ch + 2
                for cx0 in range(-PERIOD_X + off_row, W + PERIOD_X, PERIOD_X):
                    x_left = cx0 - cw // 2
                    sx0 = max(0, -x_left)
                    sy0 = max(0, -y_top)
                    sx1 = min(cw, W - x_left)
                    sy1 = min(ch, SEA_H - y_top)
                    if sx0 >= sx1 or sy0 >= sy1:
                        continue
                    sub_m = mask[sy0:sy1, sx0:sx1]
                    if not np.any(sub_m):
                        continue
                    sub_t = tone[sy0:sy1, sx0:sx1]
                    c_pix = np.where(
                        sub_t[..., None] > 0.62,
                        foam_c,
                        np.where(sub_t[..., None] > 0.30, mid_c, shadow_c),
                    )
                    # `light_crests` de ZRV2 : les crêtes passant dans la colonne de Lune / Soleil s'illuminent !
                    if cfg is not None and dy < 265:
                        xs_world = np.arange(x_left + sx0, x_left + sx1, dtype=np.float32)[None, :]
                        half = 38.0 + 78.0 * min(1.0, dy / 225.0)
                        w_lit = np.clip(1.0 - np.abs(xs_world - cfg["cx"]) / half, 0.0, 1.0) * 0.90
                        lit_arr = np.array(cfg["light_rgb"], dtype=np.float32)[None, None, :]
                        c_pix = c_pix * (1.0 - w_lit[..., None]) + lit_arr * w_lit[..., None]

                    dst = sea_rgb[y_top + sy0 : y_top + sy1, x_left + sx0 : x_left + sx1]
                    dst[sub_m] = np.clip(np.rint(c_pix[sub_m]), 0, 255).astype(np.uint8)

            # 5) Colonne de reflet animée (`reflet_frames` exact de ZRV2 !)
            if cfg is not None:
                c_halo = np.array(cfg["halo_rgb"], dtype=np.uint8)
                c_mid = np.array(cfg["mid_rgb"], dtype=np.uint8)
                c_core = np.array(cfg["core_rgb"], dtype=np.uint8)
                pal3 = np.stack([c_halo, c_mid, c_core], axis=0)

                for d in dashes_by_mode[mode]:
                    dy = d["dy"]
                    if dy < 1 or dy >= SEA_H - 6:
                        continue
                    # Phase d'ondulation calée sur la houle `u(dy)` exactement comme `reflet_frames` dans ZRV2
                    ph = 2.0 * math.pi * (2.0 * s / SWELL_STEPS - float(u_of_dy[dy])) + 0.35 * d["phase0"]
                    # Extinction brève des éclats comme sur l'eau réelle (`REFLET_OFF = -0.85` dans ZRV2 !)
                    if math.sin(2.0 * ph + d["phase0"]) < -0.85:
                        continue
                    amp = 2.5 + 8.5 * min(1.0, dy / 210.0)
                    dx_osc = int(round(amp * math.sin(ph)))
                    dm = d["mask"]
                    dt = d["tier"]
                    dh, dw = dm.shape
                    px0 = cfg["cx"] + d["dx0"] + dx_osc
                    sx0 = max(0, -px0)
                    sx1 = min(dw, W - px0)
                    sy1 = min(dh, SEA_H - dy)
                    if sx0 >= sx1 or sy1 <= 0:
                        continue
                    sm = dm[:sy1, sx0:sx1]
                    st = dt[:sy1, sx0:sx1]
                    dst = sea_rgb[dy : dy + sy1, px0 + sx0 : px0 + sx1]
                    dst[sm] = pal3[st[sm]]

                # En `nuit`, ajouter aussi un discret scintillement argenté secondaire sur le golfe Ouest (`x = 228`)
                # pour que tout l'océan nocturne respire sous le clair de lune !
                if mode == "nuit":
                    for si in range(18):
                        sy_w = 8 + si * 10
                        ph_w = 2.0 * math.pi * (2.0 * s / SWELL_STEPS - float(u_of_dy[sy_w])) + si * 1.1
                        if math.sin(ph_w + si) > 0.15:
                            wx = 228 + int(round((6.0 + si * 1.4) * math.sin(ph_w * 0.7 + si * 2.3)))
                            ww = 2 + (si % 3) * 2
                            sea_rgb[sy_w, max(0, wx) : min(W, wx + ww)] = c_halo if si % 2 else c_mid

            rgba_frame = np.zeros((H, W, 4), dtype=np.uint8)
            rgba_frame[HORIZON_Y:, :, :3] = sea_rgb
            rgba_frame[HORIZON_Y:, :, 3] = 255
            frames.append(Image.fromarray(rgba_frame, "RGBA"))
        ocean_out[mode] = frames
    return ocean_out


def grade_canonical_cliff_layer(day_im: Image.Image, mode: str) -> Image.Image:
    """
    Applique l'éclairage d'ambiance `Aube` ou `Crépuscule` par pure transformation chromatique
    sans saturation sur les pixels 100 % canoniques `Metano_Town_{Base,Cliffs}.tile`
    (calibré sur `final_rgb.herbe` de `Scène du Réveil` : herbe verte dorée-rosée à l'aube,
    herbe verte ambrée-cuivrée au crépuscule, contraste de chaque brin 100 % préservé !).
    """
    arr = np.asarray(day_im.convert("RGBA")).copy()
    vis = arr[..., 3] > 0
    rgb = arr[..., :3].astype(np.float32)
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]

    if mode == "aube":
        # Exacte teinte matinale dorée-rosée de `Scène du Réveil` (aucun écrêtage à 255 !)
        nr = r * 0.94 + 8.0
        ng = g * 0.80 + 4.0
        nb = b * 1.06 + 18.0
    elif mode == "crepuscule":
        # Exacte teinte vespérale vert-ambre chaud de `Scène du Réveil` Crépuscule
        nr = r * 0.80 + 10.0
        ng = g * 0.62 + 2.0
        nb = b * 0.84 + 14.0
    else:
        return day_im

    graded = np.stack([nr, ng, nb], axis=-1)
    graded = np.clip(np.rint(graded), 0, 255).astype(np.uint8)
    arr[..., :3] = np.where(vis[..., None], graded, 0)
    return Image.fromarray(arr, "RGBA")


def compose_full_preview(
    mode: str,
    sky: Image.Image,
    stars: List[Image.Image] | None,
    astre: Image.Image | None,
    clouds: Dict[str, Image.Image],
    ocean_frames: List[Image.Image],
    cliff_layers: List[Image.Image],
    frame_idx: int,
    total_frames: int = SWELL_STEPS,
) -> Image.Image:
    im = sky.copy()
    if mode == "nuit" and stars is not None:
        im.alpha_composite(stars[frame_idx % len(stars)])
    if astre is not None:
        im.alpha_composite(astre, (0, 0))

    # Plan arrière de cumulus lointains puis banc principal de cumulus posés pile sur `HORIZON_Y = 296`
    for key, y_pos, speed_px in [("haut", HORIZON_Y - 108, 120.0), ("horizon", HORIZON_Y - 90, 240.0)]:
        strip = clouds[key]
        sw = strip.width
        dx = int(round((frame_idx / float(total_frames)) * speed_px)) % sw
        shifted = Image.new("RGBA", (W, strip.height), (0, 0, 0, 0))
        x = -dx
        while x < W:
            shifted.alpha_composite(strip, (x, 0))
            x += sw
        im.alpha_composite(shifted, (0, y_pos))

    im.alpha_composite(ocean_frames[frame_idx % len(ocean_frames)])
    for cl in cliff_layers:
        im.alpha_composite(cl)
    return im


def main() -> None:
    print("1/6 Extraction des astres PMD Sky, ciels, 58 étoiles scintillantes & cumulus sans couture...", flush=True)
    skies = build_sky_gradients()
    astres = extract_celestial_sprites()
    star_frames = build_night_star_frames()
    clouds = build_seamless_clouds()

    print("2/6 Synthèse des 4 × 12 = 48 frames d'océan V24P04A + colonnes de reflet Lune/Soleil + crêtes illuminées...", flush=True)
    ocean = build_all_ocean_12phases()

    # Nettoyer les anciennes frames viewer `00..07` obsolètes et écrire tous les calques `viewer_layers_1x/`
    for old_p in WEB_DIR.glob("*_L00_mer_*.png"):
        old_p.unlink()

    for mode in MODES:
        save_png_compact(skies[mode], WEB_DIR / f"{mode}_BG00_ciel.png")
        if mode in astres:
            save_png_compact(astres[mode], WEB_DIR / f"{mode}_BG02_astre.png")
        save_png_compact(clouds[mode]["haut"], WEB_DIR / f"{mode}_nuages_haut_1440.png")
        save_png_compact(clouds[mode]["horizon"], WEB_DIR / f"{mode}_nuages_horizon_1440.png")
        for s in range(SWELL_STEPS):
            save_png_compact(ocean[mode][s], WEB_DIR / f"{mode}_L00_mer_{s:02d}.png")

    for s in range(SWELL_STEPS):
        save_png_compact(star_frames[s], WEB_DIR / f"nuit_BG01_etoiles_{s:02d}.png")
    # Aussi conserver `nuit_BG01_astres.png` (étoiles repos + Pleine Lune combinées) pour compatibilité
    nuit_ast_combo = star_frames[5].copy()
    nuit_ast_combo.alpha_composite(astres["nuit"], (0, 0))
    save_png_compact(nuit_ast_combo, WEB_DIR / "nuit_BG01_astres.png")

    print("3/6 Application de l'éclairage Aube & Crépuscule sur les 10 plateaux canoniques Grass Métano...", flush=True)
    manifest_prev = json.loads((OUT_DIR / "manifest.json").read_text(encoding="utf-8"))
    zones = manifest_prev["zones"]
    plane_files = manifest_prev["terrain_planes"]  # L01_herbe_native.png, L02_brins_natifs.png, L03_bordure_nord_native.png

    for z in zones:
        slug = z["id"]
        land = np.asarray(Image.open(PROV_DIR / f"{slug}_mask_land.png").convert("L")) > 0
        for pf in plane_files:
            day_im = Image.open(WEB_DIR / f"{slug}_jour_{pf}").convert("RGBA")
            for mode in ("aube", "crepuscule"):
                graded = grade_canonical_cliff_layer(day_im, mode)
                # Préserver bit-à-bit l'alpha canonique exact !
                assert np.array_equal(np.asarray(graded)[..., 3] > 0, np.asarray(day_im)[..., 3] > 0)
                save_png_compact(graded, WEB_DIR / f"{slug}_{mode}_{pf}", indexed=False)
        for mode in MODES:
            shutil.copy2(WEB_DIR / f"{slug}_{mode}_L01_herbe_native.png", WEB_DIR / f"{slug}_{mode}_L01_plateau_canon.png")
            l01_a = np.asarray(Image.open(WEB_DIR / f"{slug}_{mode}_L01_herbe_native.png").convert("RGBA"))
            assert np.array_equal(l01_a[..., 3] > 0, land), f"Mask diff {slug} {mode}"

    print("4/6 Encodage des 40 cartes PMDO 0.8.12 (.rsground) + 4 banques .tile + .dir + 10 Mods individuels...", flush=True)
    if STAGE_DIR.exists():
        shutil.rmtree(STAGE_DIR)
    mod_root = STAGE_DIR / "MOD_CLIFF_NORD_CENTRE_PMDO"
    bg_dir = mod_root / "Content/BG"
    tile_dir = mod_root / "Content/Tile"
    ground_dir = mod_root / "Data/Ground"
    for d in (bg_dir, tile_dir, ground_dir):
        d.mkdir(parents=True, exist_ok=True)

    # Écrire les `.dir` de fond (`Ciel`, `Astre` Pleine Lune / Soleil levant / Soleil couchant, `Nuages_Haut`, `Nuages_Horizon`)
    bg_layers_by_mode: Dict[str, List[dict]] = {}
    dir_stats = []
    for mode in MODES:
        tag = mode.upper()
        dir_stats.append(write_dir_sheet(bg_dir / f"CLIFF_CENTRE_{tag}_CIEL.dir", skies[mode]))
        layers_bg = [{"BG": make_map_bg(f"CLIFF_CENTRE_{tag}_CIEL", 0, 0, False)}]
        if mode in astres:
            dir_stats.append(write_dir_sheet(bg_dir / f"CLIFF_CENTRE_{tag}_ASTRE.dir", astres[mode]))
            layers_bg.append({"BG": make_map_bg(f"CLIFF_CENTRE_{tag}_ASTRE", 0, 0, False)})
        dir_stats.append(write_dir_sheet(bg_dir / f"CLIFF_CENTRE_{tag}_NUAGES_HAUT.dir", clouds[mode]["haut"]))
        dir_stats.append(write_dir_sheet(bg_dir / f"CLIFF_CENTRE_{tag}_NUAGES_HORIZON.dir", clouds[mode]["horizon"]))
        layers_bg.append({"BG": make_map_bg(f"CLIFF_CENTRE_{tag}_NUAGES_HAUT", HORIZON_Y - 108, -2, True)})
        layers_bg.append({"BG": make_map_bg(f"CLIFF_CENTRE_{tag}_NUAGES_HORIZON", HORIZON_Y - 90, -4, True)})
        bg_layers_by_mode[mode] = layers_bg

    # Banques partagées pour le pack complet 40 cartes : l'océan 12 phases + étoiles ne sont encodés QU'UNE SEULE FOIS par ambiance !
    banks = {m: CompactTileBank(f"CliffCentre10_Reveil_{m.capitalize()}") for m in MODES}
    shared_sea_layer: Dict[str, dict] = {}
    for m in MODES:
        shared_sea_layer[m] = encode_layer_from_frames(
            "00_Mer_Et_Reflets_12Phases", 0, ocean[m], banks[m], frame_length=SWELL_TICKS
        )
    shared_star_layer = encode_layer_from_frames(
        "00a_Etoiles_Scintillantes_12Phases", 0, star_frames, banks["nuit"], frame_length=12
    )

    tpl_doc = load_template_ground()
    plane_specs = [
        ("01_Herbe_Metano_Native", "L01_herbe_native.png"),
        ("02_Brins_Metano_Natifs", "L02_brins_natifs.png"),
        ("03_Bordure_Nord_Metano_Native", "L03_bordure_nord_native.png"),
    ]

    rsg_by_zone_mode: Dict[Tuple[str, str], bytes] = {}
    for z in zones:
        slug = z["id"]
        title_fr = z["title"]
        land = np.asarray(Image.open(PROV_DIR / f"{slug}_mask_land.png").convert("L")) > 0
        obs = make_obstacles_grid(land)
        z["maps"] = {}

        for mode in MODES:
            layers_list = []
            if mode == "nuit":
                layers_list.append(copy.deepcopy(shared_star_layer))
            layers_list.append(copy.deepcopy(shared_sea_layer[mode]))
            for lname, pf in plane_specs:
                im = Image.open(WEB_DIR / f"{slug}_{mode}_{pf}").convert("RGBA")
                layers_list.append(encode_layer_from_frames(lname, 0, [im], banks[mode]))
            layers_list.extend(
                [
                    make_empty_layer("04_Vos_Chemins_et_Sols", 0),
                    make_empty_layer("05_Vos_Structures_Base", 0),
                    make_empty_layer("06_Votre_Canopee_Avant_Plan", 4),
                ]
            )

            asset_name = f"cliff_centre_{slug}_{mode}"
            doc = copy.deepcopy(tpl_doc)
            doc["Version"] = "0.8.12.0"
            obj = doc["Object"]
            obj["AssetName"] = asset_name
            obj["Name"]["DefaultText"] = f"{title_fr} ({MODE_LABELS[mode]})"
            obj["Comment"] = (
                f"PMDO 0.8.12 — {title_fr} ({MODE_LABELS[mode]}) : ambiance & effets marins Scène du Réveil V2 "
                f"(mer V24P04A 12 crans, astre & colonne de reflet animée) + plateau nu Grass Métano canonique."
            )
            obj["Background"] = {
                "$type": "RogueEssence.Dungeon.LayeredBG, RogueEssence",
                "Layers": copy.deepcopy(bg_layers_by_mode[mode]),
            }
            obj["Layers"] = layers_list
            obj["obstacles"] = obs
            obj["Decorations"] = []
            if obj.get("Entities") and obj["Entities"][0].get("Markers"):
                obj["Entities"][0]["Markers"] = [obj["Entities"][0]["Markers"][0]]
                obj["Entities"][0]["Markers"][0]["Name"] = "Entrance_Sud"
                obj["Entities"][0]["Markers"][0]["Loc"] = {"X": 592, "Y": 816}
                obj["Entities"][0]["Markers"][0]["Dir"] = 4

            raw_rsg = json.dumps(doc, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
            (ground_dir / f"{asset_name}.rsground").write_bytes(raw_rsg)
            rsg_by_zone_mode[(slug, mode)] = raw_rsg
            z["maps"][mode] = f"{asset_name}.rsground"

            for ns_dir in [
                mod_root / f"Data/Script/ground/{asset_name}",
                mod_root / f"Data/Script/cliff_nord_centre_pmdo/ground/{asset_name}",
            ]:
                ns_dir.mkdir(parents=True, exist_ok=True)
                (ns_dir / "init.lua").write_text(
                    f"-- {asset_name} : animations Scène du Réveil V2 100 % natives moteur PMDO 0.8.12\n"
                    f"local {asset_name} = {{}}\nfunction {asset_name}.Init(map)\n  COMMON.RespawnAllies()\nend\n"
                    f"return {asset_name}\n",
                    encoding="utf-8",
                )

    tile_stats = []
    tile_paths = []
    for mode in MODES:
        tp = tile_dir / f"{banks[mode].sheet_name}.tile"
        st = banks[mode].write(tp)
        tile_stats.append(st)
        tile_paths.append(tp)
        print(f"  Banque {st['sheet']}: {st['tile_count']} tuiles uniques ({st['bytes'] / 1024:.1f} Kio)", flush=True)
    write_tile_index_idx(tile_dir / "index.idx", tile_paths)

    ident = uuid.uuid5(uuid.NAMESPACE_URL, "https://github.com/meromoonmeri/projet-creation-pmdo/cliff_reveil_4_ambiances")
    (mod_root / "Mod.xml").write_text(
        f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>10 Falaises Metano - 4 Ambiances Scene du Reveil (Jour, Aube, Crepuscule, Nuit) (0.8.12)</Name>
  <Author>meromoonmeri</Author>
  <Description>40 Grounds PMDO 0.8.12 (10 falaises avant-plan Grass Metano x 4 ambiances Scene du Reveil : Jour, Aube, Crepuscule, Nuit Pleine Lune et reflets marins 12 phases).</Description>
  <Namespace>cliff_nord_centre_pmdo</Namespace>
  <UUID>{ident}</UUID>
  <Version>5.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
""",
        encoding="utf-8",
    )

    inst_txt = INSTALLER_SRC.read_text(encoding="utf-8")
    needle = "            relative = src.relative_to(source)\n"
    if needle in inst_txt:
        inst_txt = inst_txt.replace(
            needle,
            needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n",
        )
    (mod_root / "INSTALLER.py").write_text(inst_txt, encoding="utf-8")

    print("5/6 Génération des 40 PNG 1×, des 4 GIFs animés 12 phases et des archives ZIP PMDO 0.8.12...", flush=True)
    for old_png in PNG_DIR.glob("*.png"):
        old_png.unlink()
    for z in zones:
        slug = z["id"]
        for mode in MODES:
            c_ims = [Image.open(WEB_DIR / f"{slug}_{mode}_{pf}").convert("RGBA") for pf in plane_files]
            comp = compose_full_preview(
                mode,
                skies[mode],
                star_frames if mode == "nuit" else None,
                astres.get(mode),
                clouds[mode],
                ocean[mode],
                c_ims,
                frame_idx=5,
            )
            save_png_compact(comp, PNG_DIR / f"cliff_centre_{slug}_{mode}.png")

    for old_gif in ANIM_DIR.glob("*.gif"):
        old_gif.unlink()
    for mode in MODES:
        c_ims = [Image.open(WEB_DIR / f"01_grand_cap_panoramique_{mode}_{pf}").convert("RGBA") for pf in plane_files]
        gframes = []
        for fi in range(SWELL_STEPS):
            fr = compose_full_preview(
                mode,
                skies[mode],
                star_frames if mode == "nuit" else None,
                astres.get(mode),
                clouds[mode],
                ocean[mode],
                c_ims,
                frame_idx=fi,
            )
            gframes.append(fr.convert("RGB").quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE))
        gframes[0].save(
            ANIM_DIR / f"cliff_nord_centre_{mode}_anime.gif",
            save_all=True,
            append_images=gframes[1:],
            duration=166,
            loop=0,
            optimize=True,
        )

    # Supprimer les anciens `.rsground` bruts non compressés en racine (servis à la volée depuis `PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip`)
    for raw_loose in OUT_DIR.glob("*.rsground"):
        raw_loose.unlink()
    shutil.rmtree(INDIV_DIR, ignore_errors=True)
    INDIV_DIR.mkdir(parents=True, exist_ok=True)
    # Conserver le Mod autonome complet 4 ambiances de `01 — Le Grand Cap Panoramique` sur disque + génération instantanée des 10 via `serve_nocache.py` !
    slug01 = "01_grand_cap_panoramique"
    mod01_zip = INDIV_DIR / f"MOD_{slug01}_PMDO_0812.zip"
    with zipfile.ZipFile(mod01_zip, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zm:
        prefix = "MOD_CLIFF_01_GRAND_CAP_PANORAMIQUE"
        zm.writestr(f"{prefix}/Mod.xml", (mod_root / "Mod.xml").read_bytes())
        zm.writestr(f"{prefix}/INSTALLER.py", (mod_root / "INSTALLER.py").read_bytes())
        for p in sorted(tile_dir.glob("*")):
            zm.write(p, f"{prefix}/Content/Tile/{p.name}")
        for p in sorted(bg_dir.glob("*.dir")):
            zm.write(p, f"{prefix}/Content/BG/{p.name}")
        for mode in MODES:
            aname = f"cliff_centre_{slug01}_{mode}"
            zm.writestr(f"{prefix}/Data/Ground/{aname}.rsground", rsg_by_zone_mode[(slug01, mode)])
            lua = (
                f"-- {aname}\nlocal {aname} = {{}}\nfunction {aname}.Init(map)\n"
                f"  COMMON.RespawnAllies()\nend\nreturn {aname}\n"
            )
            zm.writestr(f"{prefix}/Data/Script/ground/{aname}/init.lua", lua)
            zm.writestr(f"{prefix}/Data/Script/cliff_nord_centre_pmdo/ground/{aname}/init.lua", lua)

    manifest = {
        "title": "Pack 10 Falaises Nord Centrées au Premier Plan — 4 Ambiances Scène du Réveil V2 (Jour · Aube · Crépuscule · Nuit Pleine Lune) (PMDO 0.8.12)",
        "pmdo_version": "0.8.12.0",
        "zones_count": 10,
        "ambiances": list(MODES),
        "ambiance_labels": MODE_LABELS,
        "maps_rsground_count": 40,
        "dimensions_px": [W, H],
        "grid_tiles_8px": [GW, GH],
        "foreground_cliff_overlook": True,
        "vertical_rock_face_pixels": 0,
        "generated_terrain_rgb_pixels": 0,
        "canonical_metano_modules": manifest_prev["canonical_metano_modules"],
        "night_filter": "Exact Abyss V4 tools/tile_night.py (blob 438383f4), bit-identical to Metano_Town_{Base,Cliffs,Fringe}_Night.tile",
        "entire_base_cliffs_fringe_night_sheets_equal": True,
        "reveil_scene_effects": {
            "reference": "zone_reveil_prairie_horizon_v2 (ZRV2) + V24P04A Explorers of Sky",
            "sea_phases": SWELL_STEPS,
            "sea_frame_ticks": SWELL_TICKS,
            "star_phases_nuit": SWELL_STEPS,
            "celestial_bodies": {k: {"cx": v["cx"], "cy": v["cy"], "target_w": v["target_w"]} for k, v in ASTRE_CFG.items()},
        },
        "sea_phases": SWELL_STEPS,
        "cloud_planes": 2,
        "terrain_planes": plane_files,
        "art_approved": False,
        "runtime_tested": False,
        "credits": [
            "Palikadude & contributeurs (PMDO Halcyon — Metano_Town_Base.tile, Metano_Town_Cliffs.tile)",
            "Abyss to Ascension (filtre nocturne exact Metano_Town_*_Night.tile)",
            "Spike Chunsoft (Pokémon Mystery Dungeon: Explorers of Time / Darkness / Sky — V24P04A & Scène du Réveil)",
        ],
        "tile_banks": tile_stats,
        "zones": zones,
    }
    (OUT_DIR / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")

    (OUT_DIR / "README.md").write_text(
        """# Pack 10 Falaises Nord Centrées au Premier Plan — 4 Ambiances `Scène du Réveil V2` (`Jour` · `Aube` · `Crépuscule` · `Nuit`) (PMDO `0.8.12`)

## Les 4 Ambiances & Effets Marins de `La Scène du Réveil` (`zone_reveil_prairie_horizon_v2`) sur les 10 Falaises (`40` cartes `.rsground`)
- **🌕 `Nuit` (`Scène du Réveil`)** : Ciel bleu nuit profond PMD Sky, **58 étoiles scintillantes animées** (`12` phases, loi à 5 états), **grande Pleine Lune cratérisée jaune-ivoire**, nuages nocturnes gris-bleu éclairés par la lune (`RepeatX`), mer saphir-outremer `V24P04A` (`12 × 10 ticks`), **grande colonne de reflet lunaire argent-ivoire ondulant au rythme des vagues** + **illumination argentée des crêtes traversant le rayon de lune**, et plateau nu `Grass Métano` Nuit canonique.
- **🌅 `Aube`** : Ciel violet → rose-pêche doré, **grand Soleil levant doré**, nuages rosés-dorés, mer nacrée mauve-rosée `12` phases, **colonne de reflet doré ondulante + crêtes dorées**, et plateau `Grass Métano` baigné de lumière matinale.
- **🌇 `Crépuscule`** : Ciel violet profond → orange-vermillon, **grand Soleil couchant rouge-orangé** effleuré par les cumulus cuivrés, mer pourpre-indigo `12` phases, **colonne de reflet orange ardent + crêtes embrasées**, et plateau `Grass Métano` lumière du soir.
- **☀️ `Jour`** : Ciel azur `V24P04A`, cumulus blancs d'horizon, mer `V24P04A` `12` phases (houle, crêtes à double bosse, ligne sombre continue `1 px`, ondes en orbite, étincelles d'horizon), et plateau `Grass Métano` canonique.

## Crédits & Statut
- **Palikadude** & contributeurs (*PMDO Halcyon*), **Abyss to Ascension**, **Spike Chunsoft**.
- Statut : `art_approved: false`, `runtime_tested: false`.
""",
        encoding="utf-8",
    )

    pack_zip = OUT_DIR / "PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip"
    with zipfile.ZipFile(pack_zip, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for p in sorted(STAGE_DIR.rglob("*")):
            if p.is_file():
                zf.write(p, p.relative_to(STAGE_DIR).as_posix())
        zf.write(OUT_DIR / "README.md", "README.md")
        zf.write(OUT_DIR / "manifest.json", "manifest.json")
        for p in sorted(PROV_DIR.glob("*")):
            zf.write(p, f"provenance_canonique/{p.name}")

    deps_zip = OUT_DIR / "TILES_ET_CIELS_REQUIS_PMDO_0812.zip"
    with zipfile.ZipFile(deps_zip, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zd:
        for p in sorted(tile_dir.glob("*")):
            zd.write(p, f"MOD_CLIFF_NORD_CENTRE_PMDO/Content/Tile/{p.name}")
        for p in sorted(bg_dir.glob("*.dir")):
            zd.write(p, f"MOD_CLIFF_NORD_CENTRE_PMDO/Content/BG/{p.name}")
        zd.write(mod_root / "INSTALLER.py", "MOD_CLIFF_NORD_CENTRE_PMDO/INSTALLER.py")
        zd.write(mod_root / "Mod.xml", "MOD_CLIFF_NORD_CENTRE_PMDO/Mod.xml")

    shutil.rmtree(STAGE_DIR, ignore_errors=True)
    print("6/6 Terminé !", flush=True)
    print(f"  PACK 40 CARTES : {pack_zip} ({pack_zip.stat().st_size / 1048576:.2f} Mio)", flush=True)
    print(f"  MOD 01 AUTONOME: {mod01_zip} ({mod01_zip.stat().st_size / 1048576:.2f} Mio)", flush=True)
    print(f"  TILES & CIELS  : {deps_zip} ({deps_zip.stat().st_size / 1048576:.2f} Mio)", flush=True)


if __name__ == "__main__":
    main()
