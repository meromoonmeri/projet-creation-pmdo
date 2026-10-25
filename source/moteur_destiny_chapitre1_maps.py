#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Moteur partagé multicalque PMDO `0.8.12.0` — Suite Aventure `PMD : Destiny` (Chapitre I, 4 maps inédites).

Quatre maps `768 × 576` (`96 × 72` tuiles `8×8`), `10` calques (`BG` + `Top`), `0 %` ciel,
textures canoniques PMD (*Altere Pond*, *Vast Steppe*, *Mt. Cleft*, *Brine Cave*, *Boulder Cave*),
liquides canoniques animés (`Metano_Town_River_Animation_1..4.tile` + `Sparkles.tile` `4 × 10t`,
cascades natives `1×` *Foggy Forest* `P03P01A` `3 × 10t`, fleurs natives `1×` *Vast Steppe* `4 × 12t`)
et effets VFX pixel-art générés en multi-frames (`24 poses @ 5 ticks`, `< 24 000` tuiles/banque) :

  1. `DSV1` (`destiny_village_port_aube_v1`) — *Bourg-Écume · Village Portuaire des Explorateurs*
  2. `DSR1` (`destiny_route_passe_corail_v1`) — *Passe Rocheuse des Écumes · Route Côtière*
  3. `DSD1` (`destiny_donjon1_grotte_maree_entree_v1`) — *Grotte des Marées Prismatiques · Entrée*
  4. `DSB1` (`destiny_donjon1_grotte_maree_boss_v1`) — *Cœur Rocheux de l'Écho Marin · Arène Boss*
"""
from __future__ import annotations

import json
import math
from functools import lru_cache
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

from source.assembleur_bruts_unova_1x import quantize_non_magenta_mediancut
from source.moteur_cyclones_cylindriques_unova import decode_pmdo_tile, sanitize_rgba_binary
from source.moteur_forets_pmd_red import _downsample_non_mixing, _sanitize_rgb_no_magenta
from source.moteur_gba_pmd_red_natif import PURE_MAGENTA

REPO_ROOT = Path(__file__).resolve().parent.parent
W_CANON = 768
H_CANON = 576
TILE_SIZE = 8
N_VFX_FRAMES = 24

# Palettes liquides dérivées des planches natives Metano_Town_River_Animation_1..4 + Sparkles
DESTINY_WATER_PALS: Dict[str, Dict[str, Tuple[int, int, int]]] = {
    "harbor_turquoise": {
        "surface": (34, 146, 208),
        "bande": (22, 108, 172),
        "inter": (56, 172, 226),
        "accent": (98, 204, 244),
        "clair": (212, 248, 255),
        "spark_mid": (148, 228, 252),
        "spark_hi": (246, 254, 255),
    },
    "gorge_torrent": {
        "surface": (28, 128, 186),
        "bande": (18, 88, 144),
        "inter": (48, 156, 208),
        "accent": (92, 198, 234),
        "clair": (218, 250, 252),
        "spark_mid": (136, 224, 244),
        "spark_hi": (244, 255, 252),
    },
    "tidal_sapphire": {
        "surface": (24, 84, 152),
        "bande": (14, 52, 108),
        "inter": (38, 112, 182),
        "accent": (72, 158, 216),
        "clair": (178, 236, 248),
        "spark_mid": (108, 198, 236),
        "spark_hi": (228, 252, 255),
    },
    "abyssal_echo": {
        "surface": (20, 62, 118),
        "bande": (12, 36, 78),
        "inter": (32, 92, 152),
        "accent": (64, 148, 198),
        "clair": (164, 232, 244),
        "spark_mid": (96, 194, 228),
        "spark_hi": (222, 252, 248),
    },
}


# ============================================================================
# 1. DÉTOURAGE `#FF00FF` PROPRE & QUANTIFICATION CANONIQUE `<= 92` COULEURS
# ============================================================================

def clean_and_downsample_magenta_plate(raw_path: Path, out_w: int = W_CANON, out_h: int = H_CANON) -> Tuple[np.ndarray, np.ndarray]:
    """Détoure proprement le fond `#FF00FF`, purge tout liseré AA magenta par propagation EDT
    des pixels rocheux/végétaux voisins, et réduit sans mélange inter-classes en `out_w × out_h`."""
    src = np.asarray(Image.open(raw_path).convert("RGB"), dtype=np.uint8).copy()
    r = src[:, :, 0].astype(np.int16)
    g = src[:, :, 1].astype(np.int16)
    b = src[:, :, 2].astype(np.int16)

    is_mag = (r >= 210) & (g <= 58) & (b >= 210) & ((r - g) >= 150) & ((b - g) >= 150)
    fg = ~is_mag

    near_mag = ndimage.binary_dilation(is_mag, iterations=5) & fg
    fringe = (
        (fg & ((r - g >= 58) & (b - g >= 58) & (r >= 105) & (b >= 105)))
        | (near_mag & ((r - g >= 22) & (b - g >= 22)))
    )
    valid_fg = fg & (~fringe)
    if np.any(fringe) and np.any(valid_fg):
        _, idx = ndimage.distance_transform_edt(~valid_fg, return_indices=True)
        src[fringe] = src[idx[0][fringe], idx[1][fringe]]

    rgb_ds, fg_ds = _downsample_non_mixing(src, fg, out_w=out_w, out_h=out_h)

    # Purge des micro-îlots parasites (< 32 px) et garantie stricte `0 %` ciel en haut (`y < 180`)
    lbl, n_cc = ndimage.label(fg_ds)
    if n_cc > 1:
        sizes = np.bincount(lbl.ravel())
        keep = sizes >= 32
        keep[0] = False
        fg_ds = keep[lbl]

    yy, _ = np.mgrid[0:out_h, 0:out_w]
    top_hole = (~fg_ds) & (yy < 180)
    if np.any(top_hole):
        _, n_idx = ndimage.distance_transform_edt(~fg_ds, return_indices=True)
        hy, hx = np.where(top_hole)
        rgb_ds[hy, hx] = rgb_ds[n_idx[0, hy, hx], n_idx[1, hy, hx]]
        fg_ds[top_hole] = True

    quant = quantize_non_magenta_mediancut(rgb_ds, ~fg_ds, n_colors=84)
    mag_final = (quant[:, :, 0] == 255) & (quant[:, :, 1] == 0) & (quant[:, :, 2] == 255)
    solid_final = ~mag_final

    # Préserve l'éclat des cristaux cyan/ambre et de l'eau bleue de la fontaine écrasés par mediancut global
    r_d = rgb_ds[:, :, 0].astype(np.int16)
    g_d = rgb_ds[:, :, 1].astype(np.int16)
    b_d = rgb_ds[:, :, 2].astype(np.int16)
    vivid_cyan = solid_final & ((b_d - r_d) >= 55) & (g_d >= 135) & (b_d >= 175)
    if np.any(vivid_cyan):
        hi_c = vivid_cyan & (g_d >= 215) & (b_d >= 235)
        mid_c = vivid_cyan & (~hi_c) & (b_d >= 205)
        lo_c = vivid_cyan & (~hi_c) & (~mid_c)
        quant[lo_c] = (36, 156, 206)
        quant[mid_c] = (68, 212, 244)
        quant[hi_c] = (176, 250, 255)

    vivid_amber = solid_final & (r_d >= 205) & (g_d >= 120) & (b_d <= 68)
    if np.any(vivid_amber):
        hi_a = vivid_amber & (g_d >= 185)
        quant[vivid_amber & (~hi_a)] = (232, 146, 34)
        quant[hi_a] = (255, 214, 78)

    quant[solid_final] = _sanitize_rgb_no_magenta(quant, solid_final)[solid_final]
    quant[mag_final] = PURE_MAGENTA
    return quant, solid_final


def assemble_destiny_brut(
    raw_sheet: Path,
    out_brut: Path,
    out_ref_canon: Path,
    pal_key: str,
    heal_boss_pebble: bool = False,
) -> None:
    quant, solid = clean_and_downsample_magenta_plate(raw_sheet, W_CANON, H_CANON)
    if heal_boss_pebble:
        # Nettoie le petit caillou isolé au sud du plateau de boss de DSB1 pour un sol d'arène 100 % nu
        yy, xx = np.mgrid[0:H_CANON, 0:W_CANON]
        peb = (xx >= 378) & (xx <= 426) & (yy >= 404) & (yy <= 438) & solid
        sample = (xx >= 332) & (xx <= 372) & (yy >= 360) & (yy <= 398) & solid
        if np.any(peb) and np.any(sample):
            ys_s, xs_s = np.where(sample)
            py, px = np.where(peb)
            for k in range(len(px)):
                quant[py[k], px[k]] = quant[ys_s[k % len(ys_s)], xs_s[k % len(xs_s)]]

    mag = ~solid
    preview = quant.copy()
    preview[mag] = DESTINY_WATER_PALS[pal_key]["surface"]
    out_brut.parent.mkdir(parents=True, exist_ok=True)
    out_ref_canon.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(quant, mode="RGB").save(out_brut)
    Image.fromarray(preview, mode="RGB").save(out_ref_canon)


# ============================================================================
# 2. LIQUIDES CANONIQUES ANIMÉS : EAU MÉTANO (`4×10t`) & CASCADES `P03P01A` (`3×10t`)
# ============================================================================

@lru_cache(maxsize=8)
def _load_metano_liquid_families(pal_key: str) -> Dict[str, List[np.ndarray]]:
    pal = DESTINY_WATER_PALS[pal_key]
    eau_dir = REPO_ROOT / "source" / "eau_metano" / "natifs"
    sp_sheet = np.asarray(decode_pmdo_tile(eau_dir / "Metano_Town_River_Sparkles.tile"), dtype=np.uint8)
    m_surf = np.array([131, 218, 230], dtype=np.int32)

    def _cluster(cols: List[int], rows: List[int], step: int) -> List[np.ndarray]:
        seq: List[np.ndarray] = []
        ch, cw = len(rows) * 8, len(cols) * 8
        for k in range(4):
            raw = np.zeros((ch, cw, 4), dtype=np.uint8)
            for jr, r_idx in enumerate(rows):
                for ic, c_idx in enumerate(cols):
                    ty, tx = (r_idx + step * k) * 8, c_idx * 8
                    raw[jr * 8 : (jr + 1) * 8, ic * 8 : (ic + 1) * 8] = sp_sheet[ty : ty + 8, tx : tx + 8]
            diff = np.abs(raw[:, :, :3].astype(np.int32) - m_surf).sum(axis=2)
            keep = (raw[:, :, 3] == 255) & (diff > 6)
            out = np.zeros((ch, cw, 4), dtype=np.uint8)
            hi = keep & (raw[:, :, 0] >= 220)
            out[keep & (~hi)] = (*pal["spark_mid"], 255)
            out[hi] = (*pal["spark_hi"], 255)
            seq.append(out)
        return seq

    families: Dict[str, List[np.ndarray]] = {
        "A_16x24": _cluster([0, 1], [0, 1, 2], 3),
        "B_24x16": _cluster([2, 3, 4], [0, 1], 2),
        "C_16x32": _cluster([0, 1], [12, 13, 14, 15], 4),
    }
    riv_sheets = [
        np.asarray(decode_pmdo_tile(eau_dir / f"Metano_Town_River_Animation_{i}.tile"), dtype=np.uint8)
        for i in range(1, 5)
    ]
    for tag, x0, y0 in (("R1_8x32", 984, 184), ("R2_8x32", 1072, 184)):
        seq_r: List[np.ndarray] = []
        for k in range(4):
            crop = riv_sheets[k][y0 : y0 + 32, x0 : x0 + 8]
            diff = np.abs(crop[:, :, :3].astype(np.int32) - m_surf).sum(axis=2)
            keep = (crop[:, :, 3] == 255) & (diff > 6)
            out = np.zeros((32, 8, 4), dtype=np.uint8)
            brighter = keep & (crop[:, :, 1] >= 200)
            out[keep & (~brighter)] = (*pal["inter"], 255)
            out[brighter] = (*pal["accent"], 255)
            seq_r.append(out)
        families[tag] = seq_r
    return families


def build_canonical_metano_liquid_layers(
    w: int,
    h: int,
    water_mask: np.ndarray,
    pal_key: str,
    seed: int = 202610,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Retourne `(water_4_frames, sparkle_4_frames)` (`4 poses @ 10 ticks`) 100 % ancrés sur
    `Metano_Town_River_Animation_1..4.tile` et `Metano_Town_River_Sparkles.tile`."""
    pal = DESTINY_WATER_PALS[pal_key]
    dist = ndimage.distance_transform_edt(water_mask)
    yy, xx = np.mgrid[:h, :w]
    jag = ndimage.gaussian_filter(np.random.default_rng(seed % 997).random((h, w)), 1.0)
    jag = (jag - float(jag.min())) / max(1e-6, float(np.ptp(jag)))

    scale_band = max(0.65, min(1.15, w / float(W_CANON)))
    water_4: List[Image.Image] = []
    for t in range(4):
        ph = 2.0 * math.pi * t / 4.0
        n_wave = 0.60 * np.sin(yy * 0.18 + xx * 0.09 - ph) + 0.40 * np.sin(yy * 0.08 - xx * 0.14 + 0.8 - ph)
        t_inner = (6.0 + 1.5 * n_wave) * scale_band
        jr = np.roll(jag, shift=t * 2, axis=0)
        fringe = t_inner + (2.0 + 4.2 * jr) * scale_band

        a = np.zeros((h, w, 4), dtype=np.uint8)
        a[water_mask] = (*pal["surface"], 255)

        # Rubans de courant interne lents (quantifiés sans flou)
        swirl = np.sin(xx * 0.035 + yy * 0.048 - ph) + 0.55 * np.cos(xx * 0.052 - yy * 0.031 + ph)
        a[water_mask & (dist > fringe + 4.0) & (swirl > 0.92)] = (*pal["inter"], 255)
        a[water_mask & (dist > fringe + 6.0) & (swirl < -1.02)] = (*pal["bande"], 255)

        m_fringe = water_mask & (dist > 0.0) & (dist <= fringe)
        a[m_fringe] = (*pal["inter"], 255)
        a[m_fringe & (jr > 0.50)] = (*pal["accent"], 255)
        a[water_mask & (dist > 0.0) & (dist <= t_inner)] = (*pal["inter"], 255)
        a[water_mask & (dist > 0.0) & (dist <= np.maximum(1.8, t_inner - 2.2 * scale_band))] = (*pal["bande"], 255)
        m_clair = water_mask & (dist > 0.0) & (dist <= 1.8) & (np.sin(xx * 0.22 + yy * 0.34 - ph) > -0.35)
        a[m_clair] = (*pal["clair"], 255)
        water_4.append(Image.fromarray(sanitize_rgba_binary(a)))

    fams = _load_metano_liquid_families(pal_key)
    rng = np.random.default_rng(seed)
    safe_open = ndimage.binary_erosion(water_mask, iterations=max(3, int(round(4 * scale_band))))
    occupied = np.zeros((h, w), dtype=bool)
    placements: List[Tuple[str, int, int, int]] = []
    ys_o, xs_o = np.where(safe_open)
    if len(ys_o) > 0:
        order = rng.permutation(len(ys_o))
        fam_keys = ["A_16x24", "B_24x16", "C_16x32", "R1_8x32", "R2_8x32"]
        target = min(58, max(14, int(water_mask.sum()) // 950))
        for idx in order:
            if len(placements) >= target:
                break
            cy, cx = int(ys_o[idx]), int(xs_o[idx])
            fk = fam_keys[len(placements) % len(fam_keys)]
            sh, sw = fams[fk][0].shape[:2]
            x0, y0 = (cx // 8) * 8, (cy // 8) * 8
            if x0 < 8 or y0 < 8 or x0 + sw >= w - 8 or y0 + sh >= h - 8:
                continue
            if not safe_open[y0 : y0 + sh, x0 : x0 + sw].all():
                continue
            if occupied[max(0, y0 - 10) : min(h, y0 + sh + 10), max(0, x0 - 10) : min(w, x0 + sw + 10)].any():
                continue
            occupied[y0 : y0 + sh, x0 : x0 + sw] = True
            placements.append((fk, x0, y0, int(rng.integers(0, 4))))

    sparkle_4: List[Image.Image] = []
    for t in range(4):
        sp = np.zeros((h, w, 4), dtype=np.uint8)
        for fk, x0, y0, ph0 in placements:
            patch = fams[fk][(t + ph0) % 4]
            sh, sw = patch.shape[:2]
            nz = (patch[:, :, 3] == 255) & water_mask[y0 : y0 + sh, x0 : x0 + sw]
            if np.any(nz):
                sub = sp[y0 : y0 + sh, x0 : x0 + sw]
                sub[nz] = patch[nz]
        sparkle_4.append(Image.fromarray(sanitize_rgba_binary(sp)))

    return water_4, sparkle_4


@lru_cache(maxsize=1)
def _load_p03p01a_waterfalls() -> Tuple[np.ndarray, dict]:
    ref_dir = REPO_ROOT / "source" / "fosse_argent_sanctuaire_v1" / "references"
    atlas = np.asarray(Image.open(ref_dir / "foggy_forest_p03p01a_waterfalls.png").convert("RGBA"), dtype=np.uint8)
    meta = json.loads((ref_dir / "foggy_forest_p03p01a_waterfalls.json").read_text(encoding="utf-8"))
    return atlas, meta


def build_placed_p03p01a_cascades(
    w: int,
    h: int,
    specs: Sequence[Tuple[int, int, int, str, int]],
    fg_rgb_mut: Optional[np.ndarray] = None,
    solid_mask: Optional[np.ndarray] = None,
    exclude_mask: Optional[np.ndarray] = None,
) -> List[Image.Image]:
    """Place des cascades authentiques `1×` *Foggy Forest* (`P03P01A`, `3 poses @ 10 ticks`) aux ancres
    `(xc_canon, y_top_canon, y_water_canon, variant, phase_offset)` en coordonnées `768×576`."""
    atlas, meta = _load_p03p01a_waterfalls()
    yy_c, xx_c = np.mgrid[:H_CANON, :W_CANON]

    if fg_rgb_mut is not None and solid_mask is not None and fg_rgb_mut.shape[:2] == (H_CANON, W_CANON):
        for xc, y_top, _y_wat, vname, _ph in specs:
            sw_nat = int(meta["variants"][vname]["shaft_width"])
            rx = max(4.0, 0.56 * sw_nat)
            ry = max(5.0, 0.34 * sw_nat)
            mouth = (
                solid_mask
                & (yy_c >= max(0, int(y_top - ry)))
                & (yy_c <= int(y_top + 5))
                & ((((xx_c - float(xc)) / rx) ** 2 + ((yy_c - float(y_top)) / ry) ** 2) <= 1.0)
            )
            fg_rgb_mut[mouth] = (14, 24, 42)

    frames: List[Image.Image] = []
    for k in range(3):
        canvas = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        for xc, y_top, y_wat, vname, ph_off in specs:
            vd = meta["variants"][vname]
            fk = (k + ph_off) % 3
            sx, sy, sw, sh = vd["shaft_boxes_xywh"][fk]
            px, py, pw, ph = vd["plunge_boxes_xywh"][fk]
            s_im = atlas[sy : sy + sh, sx : sx + sw]
            p_im = atlas[py : py + ph, px : px + pw]

            yp0 = y_wat - int(vd["waterline_offset_in_plunge"])
            y_end = min(H_CANON, yp0 + 16)
            yt = max(0, y_top)
            if y_end > yt:
                ys_col = np.arange(yt, y_end)
                mod_rows = (ys_col - yp0 + int(vd["plunge_y0_mod96"])) % 96
                strip = s_im[mod_rows].copy()
                u_x = (np.arange(sw, dtype=np.float32) - 0.5 * (sw - 1)) / max(1.0, 0.5 * sw)
                arch = 5.0 * (1.0 - np.sqrt(np.maximum(0.0, 1.0 - np.clip(u_x, -1.0, 1.0) ** 2)))
                rel_r = np.arange(y_end - yt, dtype=np.float32)[:, None]
                strip[rel_r < arch[None, :], 3] = 0
                xs0 = xc - sw // 2
                cx0, cx1 = max(0, xs0), min(W_CANON, xs0 + sw)
                if cx1 > cx0:
                    sub_s = strip[:, cx0 - xs0 : cx1 - xs0]
                    ms = sub_s[:, :, 3] == 255
                    dst = canvas[yt:y_end, cx0:cx1]
                    dst[ms] = sub_s[ms]

            xp0 = xc - pw // 2
            py0, py1 = max(0, yp0), min(H_CANON, yp0 + ph)
            px0, px1 = max(0, xp0), min(W_CANON, xp0 + pw)
            if py1 > py0 and px1 > px0:
                sub_p = p_im[py0 - yp0 : py1 - yp0, px0 - xp0 : px1 - xp0]
                mp = sub_p[:, :, 3] == 255
                dst_p = canvas[py0:py1, px0:px1]
                dst_p[mp] = sub_p[mp]

        if exclude_mask is not None and exclude_mask.shape == (H_CANON, W_CANON):
            canvas[exclude_mask] = 0
        im = Image.fromarray(sanitize_rgba_binary(canvas))
        if (w, h) != (W_CANON, H_CANON):
            im = im.resize((w, h), Image.Resampling.NEAREST)
        frames.append(im)
    return frames


@lru_cache(maxsize=1)
def _load_vast_steppe_flower_frames() -> List[np.ndarray]:
    """Extrait les 4 poses A-B-A-C `24×24` de `Vast_Steppe_Flower_Animations.png`."""
    p = REPO_ROOT / "source" / "amp_plains_fleurie_v1" / "references" / "Vast_Steppe_Flower_Animations.png"
    sheet = np.asarray(Image.open(p).convert("RGBA"), dtype=np.uint8)
    raw3 = [sanitize_rgba_binary(sheet[:, i * 24 : (i + 1) * 24]) for i in range(3)]
    return [raw3[0], raw3[1], raw3[0], raw3[2]]


def build_vast_steppe_flowers_layer(
    w: int,
    h: int,
    grass_mask_canon: np.ndarray,
    seed: int = 4401,
    max_flowers: int = 24,
) -> List[Image.Image]:
    """Dispose les fleurs sauvages animées canoniques `1×` *Vast Steppe* (`4 poses @ 12 ticks`)."""
    fl_seq = _load_vast_steppe_flower_frames()
    safe_grass = ndimage.binary_erosion(grass_mask_canon, iterations=10)
    ys, xs = np.where(safe_grass)
    rng = np.random.default_rng(seed)
    spots: List[Tuple[int, int, int]] = []
    occ = np.zeros((H_CANON, W_CANON), dtype=bool)
    if len(ys) > 0:
        for idx in rng.permutation(len(ys)):
            if len(spots) >= max_flowers:
                break
            cy, cx = int(ys[idx]), int(xs[idx])
            x0, y0 = (cx // 8) * 8, (cy // 8) * 8
            if x0 < 16 or y0 < 16 or x0 + 24 >= W_CANON - 16 or y0 + 24 >= H_CANON - 16:
                continue
            if not safe_grass[y0 : y0 + 24, x0 : x0 + 24].all():
                continue
            if occ[max(0, y0 - 20) : min(H_CANON, y0 + 44), max(0, x0 - 20) : min(W_CANON, x0 + 44)].any():
                continue
            occ[y0 : y0 + 24, x0 : x0 + 24] = True
            spots.append((x0, y0, int(rng.integers(0, 4))))

    frames: List[Image.Image] = []
    for k in range(4):
        c = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        for x0, y0, ph in spots:
            spr = fl_seq[(k + ph) % 4]
            nz = spr[:, :, 3] == 255
            sub = c[y0 : y0 + 24, x0 : x0 + 24]
            sub[nz] = spr[nz]
        im = Image.fromarray(sanitize_rgba_binary(c))
        if (w, h) != (W_CANON, H_CANON):
            im = im.resize((w, h), Image.Resampling.NEAREST)
        frames.append(im)
    return frames


# ============================================================================
# 3. PRIMITIVES VFX PIXEL-ART MULTI-FRAMES (`24 poses @ 5 ticks`, ALPHA BINAIRE)
# ============================================================================

def _stamp_4pt_star(
    canvas: np.ndarray,
    cx: int,
    cy: int,
    arm: int,
    core_rgb: Tuple[int, int, int],
    halo_rgb: Tuple[int, int, int],
) -> None:
    h, w = canvas.shape[:2]
    if arm <= 0 or cx < arm + 1 or cy < arm + 1 or cx >= w - arm - 1 or cy >= h - arm - 1:
        return
    for d in range(1, arm + 1):
        col = (*core_rgb, 255) if d == 1 else (*halo_rgb, 255)
        canvas[cy - d, cx] = col
        canvas[cy + d, cx] = col
        canvas[cy, cx - d] = col
        canvas[cy, cx + d] = col
    if arm >= 2:
        for dy, dx in ((-1, -1), (-1, 1), (1, -1), (1, 1)):
            canvas[cy + dy, cx + dx] = (*halo_rgb, 255)
    canvas[cy, cx] = (*core_rgb, 255)


def _stamp_pixel_bubble(
    canvas: np.ndarray,
    cx: int,
    cy: int,
    rad: int,
    rim_rgb: Tuple[int, int, int],
    glint_rgb: Tuple[int, int, int] = (248, 254, 255),
) -> None:
    """Dessine une bulle d'écume pixel-art creuse à reflet spéculaire (`alpha ∈ {0, 255}`)."""
    h, w = canvas.shape[:2]
    if rad < 2 or cx < rad + 1 or cy < rad + 1 or cx >= w - rad - 1 or cy >= h - rad - 1:
        return
    for dy in range(-rad, rad + 1):
        for dx in range(-rad, rad + 1):
            d = math.hypot(dx, dy)
            if rad - 0.85 <= d <= rad + 0.35:
                canvas[cy + dy, cx + dx] = (*rim_rgb, 255)
    canvas[cy - max(1, rad // 2), cx - max(1, rad // 2)] = (*glint_rgb, 255)


def _stamp_ellipse_ring(
    canvas: np.ndarray,
    cx: float,
    cy: float,
    rx: float,
    ry: float,
    rgb: Tuple[int, int, int],
    mask_allow: Optional[np.ndarray] = None,
    dashed_phase: Optional[float] = None,
) -> None:
    if rx < 2.0 or ry < 1.5:
        return
    h, w = canvas.shape[:2]
    steps = max(24, int(round(2.4 * math.pi * max(rx, ry))))
    for s in range(steps):
        ang = 2.0 * math.pi * s / steps
        if dashed_phase is not None and math.sin(4.0 * ang + dashed_phase) < -0.15:
            continue
        px = int(round(cx + rx * math.cos(ang)))
        py = int(round(cy + ry * math.sin(ang)))
        if 0 <= px < w and 0 <= py < h:
            if mask_allow is None or mask_allow[py, px]:
                canvas[py, px] = (*rgb, 255)


def _scale_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_CANON, H_CANON):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


# ============================================================================
# 4. GÉNÉRATEURS VFX MULTI-FRAMES PAR CARTE (`24 poses @ 5 ticks`, < 16k TUILES)
# ============================================================================

def build_dsv1_vfx_layers(
    w: int,
    h: int,
    water_mask: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """VFX Multi-Frames de `DSV1` (*Bourg-Écume · Village Portuaire*) :
      - `bg_vfx_24` : Jet d'eau & ondes concentriques de la Fontaine de l'Œuf Ailé `(383, 294)` +
        ressac d'écume rythmé autour des piliers du quai en bois.
      - `top_vfx_24` : 4 lanternes dorées portuaires pulsantes + bulles d'écume irisées façon Krabby
        s'élevant du port vers le village.
    """
    fountain_box = np.zeros((H_CANON, W_CANON), dtype=bool)
    fountain_box[281:307, 361:406] = True

    pier_posts = [(340, 444), (428, 444), (340, 502), (428, 502), (340, 554), (428, 554)]
    lantern_pts = [(336, 408), (432, 408), (206, 336), (578, 336)]
    bubble_seeds = [
        (88, 510, 4, 0), (168, 536, 3, 5), (264, 520, 5, 11),
        (504, 526, 4, 3), (602, 540, 3, 14), (684, 504, 5, 19),
        (136, 462, 3, 8), (632, 456, 4, 17),
    ]

    bg_frames: List[Image.Image] = []
    top_frames: List[Image.Image] = []
    for f in range(N_VFX_FRAMES):
        ph = 2.0 * math.pi * f / N_VFX_FRAMES
        c_bg = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        c_top = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)

        # 1) Ondes concentriques dans la vasque de la Fontaine (383, 295)
        for ring_i in range(2):
            prog = ((f / float(N_VFX_FRAMES)) + 0.5 * ring_i) % 1.0
            rx = 5.0 + 15.0 * prog
            ry = 2.5 + 7.5 * prog
            col = (232, 252, 255) if prog < 0.55 else (120, 214, 246)
            _stamp_ellipse_ring(c_bg, 383.0, 295.0, rx, ry, col, mask_allow=fountain_box, dashed_phase=ph)

        # Panache d'eau retombant du sommet de l'Œuf Ailé (383, 276 -> 293)
        for jet_dx in (-6, -4, 4, 6):
            for step_j in range(5):
                jy = 278 + ((f + step_j * 3 + abs(jet_dx)) % 15)
                jx = 383 + jet_dx + (1 if jy > 286 and jet_dx > 0 else (-1 if jy > 286 else 0))
                if 280 <= jy <= 294:
                    c_bg[jy, jx] = (236, 254, 255, 255)
        # Éclat sur le blason de l'Œuf Ailé de la fontaine
        if f % 6 in (0, 1, 2):
            _stamp_4pt_star(c_top, 383, 263, 2 if f % 6 == 1 else 1, (255, 254, 232), (146, 232, 255))

        # 2) Anneaux d'écume autour des pilotis du quai en bois
        for idx_p, (px, py) in enumerate(pier_posts):
            prog_p = ((f / float(N_VFX_FRAMES)) + 0.17 * idx_p) % 1.0
            rx_p = 7.0 + 13.0 * prog_p
            ry_p = 3.5 + 6.5 * prog_p
            col_p = (218, 250, 255) if prog_p < 0.45 else (88, 196, 238)
            _stamp_ellipse_ring(c_bg, float(px), float(py), rx_p, ry_p, col_p, mask_allow=water_mask, dashed_phase=ph + idx_p)

        # 3) Lanternes dorées des explorateurs (Top)
        pulse = 0.5 + 0.5 * math.sin(ph)
        arm_l = 3 if pulse > 0.66 else 2
        for lx, ly in lantern_pts:
            _stamp_4pt_star(c_top, lx, ly, arm_l, (255, 248, 196), (250, 190, 78))

        # 4) Bulles d'écume irisées montantes (Top)
        for bx0, by0, brad, b_off in bubble_seeds:
            u = ((f + b_off) % N_VFX_FRAMES) / float(N_VFX_FRAMES)
            by = int(round(by0 - 112.0 * u))
            bx = int(round(bx0 + 6.0 * math.sin(2.0 * math.pi * u + b_off)))
            rim = (176, 238, 255) if (f + b_off) % 2 == 0 else (228, 244, 255)
            if u < 0.88:
                _stamp_pixel_bubble(c_top, bx, by, brad, rim)
            else:
                _stamp_4pt_star(c_top, bx, by, 2, (244, 254, 255), (156, 228, 252))

        bg_frames.append(Image.fromarray(sanitize_rgba_binary(c_bg)))
        top_frames.append(Image.fromarray(sanitize_rgba_binary(c_top)))

    return _scale_frames(bg_frames, w, h), _scale_frames(top_frames, w, h)


def build_dsr1_vfx_layers(
    w: int,
    h: int,
    rgb_canon: np.ndarray,
    solid_canon: np.ndarray,
    water_mask: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """VFX Multi-Frames de `DSR1` (*Passe Rocheuse des Écumes*) :
      - `bg_vfx_24` : Crêtes d'écume rapide filant dans le torrent diagonal + pulsation des cristaux
        d'aigue-marine incrustés dans la roche.
      - `top_vfx_24` : Rubans de brise côtière multi-frames & embruns montants au-dessus du pont de pierre.
    """
    r_c = rgb_canon[:, :, 0].astype(np.int16)
    g_c = rgb_canon[:, :, 1].astype(np.int16)
    b_c = rgb_canon[:, :, 2].astype(np.int16)
    aqua_cryst = solid_canon & ((b_c - r_c) >= 62) & (g_c >= 145)
    lbl, n_cc = ndimage.label(aqua_cryst)
    cryst_centers: List[Tuple[int, int]] = []
    for cid in range(1, n_cc + 1):
        ys, xs = np.where(lbl == cid)
        if len(xs) >= 14:
            cryst_centers.append((int(xs.mean()), int(ys.mean())))

    # Lignes de courant diagonales du torrent (du Nord-Est x=690,y=232 vers le Sud-Ouest x=68,y=512)
    rapid_tracks = [
        (680, 232, 480, 286),
        (510, 278, 396, 326),
        (292, 392, 92, 496),
        (256, 418, 72, 524),
    ]
    wind_ribbons = [
        (110, 168, 1), (310, 118, 7), (520, 146, 13),
        (180, 316, 4), (420, 256, 16), (590, 344, 19),
    ]

    bg_frames: List[Image.Image] = []
    top_frames: List[Image.Image] = []
    for f in range(N_VFX_FRAMES):
        ph = 2.0 * math.pi * f / N_VFX_FRAMES
        c_bg = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        c_top = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)

        # 1) Filets d'écume vive courant le long du torrent rocheux
        for t_idx, (x0, y0, x1, y1) in enumerate(rapid_tracks):
            for streak in range(4):
                u = ((f / float(N_VFX_FRAMES)) + 0.25 * streak + 0.13 * t_idx) % 1.0
                cx = int(round(x0 + (x1 - x0) * u))
                cy = int(round(y0 + (y1 - y0) * u + 3.0 * math.sin(4.0 * math.pi * u + t_idx)))
                for d_seg in range(7):
                    px = cx - d_seg * 2
                    py = cy + d_seg
                    if 0 <= px < W_CANON and 0 <= py < H_CANON and water_mask[py, px]:
                        col = (238, 254, 255, 255) if d_seg < 3 else (118, 218, 246, 255)
                        c_bg[py, px] = col
                        if py + 1 < H_CANON and water_mask[py + 1, px]:
                            c_bg[py + 1, px] = col

        # 2) Pulsation lumineuse des cristaux d'aigue-marine sur la roche
        glow_mask = ndimage.binary_dilation(aqua_cryst, iterations=1) & (~aqua_cryst) & solid_canon
        if f % 4 in (0, 1):
            c_bg[glow_mask] = (132, 236, 252, 255)
        for idx_c, (cx, cy) in enumerate(cryst_centers):
            local_p = (f + idx_c * 3) % 12
            if local_p in (0, 1, 2):
                _stamp_4pt_star(c_top, cx, cy - 2, 3 if local_p == 1 else 2, (244, 255, 255), (96, 224, 248))

        # 3) Rubans de vent côtier & gouttelettes d'embruns (Top)
        for wx0, wy0, w_off in wind_ribbons:
            u = ((f + w_off) % N_VFX_FRAMES) / float(N_VFX_FRAMES)
            if u < 0.72:
                head_x = int(round(wx0 + 96.0 * u))
                for k_px in range(18):
                    px = head_x - k_px * 2
                    py = int(round(wy0 + 4.0 * math.sin(0.22 * k_px + ph)))
                    if 8 <= px < W_CANON - 8 and 8 <= py < H_CANON - 8:
                        c_top[py, px] = (232, 250, 255, 255) if k_px < 6 else (156, 218, 242, 255)

        bg_frames.append(Image.fromarray(sanitize_rgba_binary(c_bg)))
        top_frames.append(Image.fromarray(sanitize_rgba_binary(c_top)))

    return _scale_frames(bg_frames, w, h), _scale_frames(top_frames, w, h)


def build_dsd1_vfx_layers(
    w: int,
    h: int,
    rgb_canon: np.ndarray,
    solid_canon: np.ndarray,
    water_mask: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """VFX Multi-Frames de `DSD1` (*Grotte des Marées Prismatiques · Entrée*) :
      - `bg_vfx_24` : 2 tourbillons de marée en spirale pixel-art dans les chenaux Gauche `(168, 496)` &
        Droit `(600, 496)` + aura résonnante des cristaux cyan et ambre.
      - `top_vfx_24` : Gouttes d'eau tombant de la voûte rocheuse avec anneaux d'impact à la surface +
        étoiles prismatiques à 4 branches.
    """
    r_c = rgb_canon[:, :, 0].astype(np.int16)
    g_c = rgb_canon[:, :, 1].astype(np.int16)
    b_c = rgb_canon[:, :, 2].astype(np.int16)
    cyan_cr = solid_canon & ((b_c - r_c) >= 68) & (g_c >= 155)
    amber_cr = solid_canon & (r_c >= 205) & (g_c >= 125) & (b_c <= 60)

    whirl_centers = [(168.0, 496.0, 1.0), (600.0, 496.0, -1.0)]
    drip_specs = [(142, 476, 0), (228, 518, 6), (540, 516, 12), (626, 474, 18)]
    prism_pts = [(56, 206, True), (714, 206, True), (70, 490, True), (696, 490, True), (22, 264, False), (722, 242, False)]

    bg_frames: List[Image.Image] = []
    top_frames: List[Image.Image] = []
    for f in range(N_VFX_FRAMES):
        ph = 2.0 * math.pi * f / N_VFX_FRAMES
        c_bg = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        c_top = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)

        # 1) Spirales pixel-art des 2 tourbillons de marée
        for wcx, wcy, spin_dir in whirl_centers:
            for arm_k in range(3):
                base_a = spin_dir * ph + 2.0 * math.pi * arm_k / 3.0
                for st in range(34):
                    rad = 6.0 + 1.35 * st
                    ang = base_a + spin_dir * 0.11 * st
                    px = int(round(wcx + rad * math.cos(ang)))
                    py = int(round(wcy + 0.56 * rad * math.sin(ang)))
                    if 0 <= px < W_CANON and 0 <= py < H_CANON and water_mask[py, px]:
                        col = (224, 252, 255, 255) if st < 12 else (92, 194, 242, 255)
                        c_bg[py, px] = col

        # 2) Halo de résonance des cristaux de marée cyan & ambre
        if f % 6 in (0, 1, 2):
            c_halo = ndimage.binary_dilation(cyan_cr, iterations=1) & (~cyan_cr) & solid_canon
            a_halo = ndimage.binary_dilation(amber_cr, iterations=1) & (~amber_cr) & solid_canon
            c_bg[c_halo] = (88, 224, 252, 255)
            c_bg[a_halo] = (255, 204, 82, 255)

        for idx_p, (px, py, is_cy) in enumerate(prism_pts):
            lp = (f + idx_p * 4) % 12
            if lp in (0, 1, 2):
                core = (244, 255, 255) if is_cy else (255, 250, 214)
                halo = (84, 222, 252) if is_cy else (255, 186, 64)
                _stamp_4pt_star(c_top, px, py, 3 if lp == 1 else 2, core, halo)

        # 3) Gouttes d'eau tombant du plafond rocheux + onde d'impact (Top)
        for dx, dy_hit, d_off in drip_specs:
            t_loc = (f + d_off) % N_VFX_FRAMES
            if t_loc < 10:
                drop_y = int(round((dy_hit - 120) + 12.0 * t_loc))
                for tail in range(4):
                    yy_d = drop_y - tail * 2
                    if 0 <= yy_d < H_CANON:
                        c_top[yy_d, dx] = (232, 252, 255, 255) if tail == 0 else (126, 214, 248, 255)
            elif t_loc < 20:
                prog = (t_loc - 10) / 10.0
                col_r = (228, 252, 255) if prog < 0.5 else (104, 198, 240)
                _stamp_ellipse_ring(c_top, float(dx), float(dy_hit), 4.0 + 18.0 * prog, 2.0 + 9.0 * prog, col_r, mask_allow=water_mask)

        bg_frames.append(Image.fromarray(sanitize_rgba_binary(c_bg)))
        top_frames.append(Image.fromarray(sanitize_rgba_binary(c_top)))

    return _scale_frames(bg_frames, w, h), _scale_frames(top_frames, w, h)


def build_dsb1_vfx_layers(
    w: int,
    h: int,
    solid_canon: np.ndarray,
    arena_floor_mask: np.ndarray,
    water_mask: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """VFX Multi-Frames de `DSB1` (*Cœur Rocheux de l'Écho Marin · Arène Boss*) :
      - `bg_vfx_24` : Spirale runique de l'Autel Nord `(384, 136)` qui s'illumine en onde tournante +
        anneau d'écho marin gravé à plat en périphérie de l'arène + 2 geysers d'écume dans la douve.
      - `top_vfx_24` : Anneaux soniques d'Écho Marin ascendants, étoiles cristallines à 4 branches &
        bulles abyssales bioluminescentes.
    """
    geyser_pts = [(118, 396, 0), (650, 396, 12)]
    orb_seeds = [
        (92, 430, 0), (144, 488, 5), (218, 514, 11),
        (550, 514, 3), (624, 488, 9), (676, 430, 16),
    ]

    bg_frames: List[Image.Image] = []
    top_frames: List[Image.Image] = []
    for f in range(N_VFX_FRAMES):
        ph = 2.0 * math.pi * f / N_VFX_FRAMES
        c_bg = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        c_top = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)

        # 1) Illumination spirale du Sceau Marin sur le mur d'autel Nord (384, 136)
        for st in range(52):
            r_sp = 3.0 + 0.48 * st
            ang = 0.28 * st - ph * 2.0
            px = int(round(384.0 + r_sp * math.cos(ang)))
            py = int(round(136.0 + 0.88 * r_sp * math.sin(ang)))
            if 0 <= px < W_CANON and 0 <= py < H_CANON and solid_canon[py, px]:
                bright = ((st - f * 2) % 18) < 7
                c_bg[py, px] = (224, 254, 255, 255) if bright else (76, 198, 238, 255)

        # 2) Onde runique plate sur le pourtour interne de la dalle d'arène (0 obstacle !)
        for ring_k in range(2):
            prog = ((f / float(N_VFX_FRAMES)) + 0.5 * ring_k) % 1.0
            rx = 168.0 + 36.0 * prog
            ry = 92.0 + 20.0 * prog
            col = (146, 238, 252) if prog < 0.5 else (68, 168, 216)
            _stamp_ellipse_ring(c_bg, 384.0, 312.0, rx, ry, col, mask_allow=arena_floor_mask, dashed_phase=ph)

        # 3) Deux geysers d'écume jaillissant dans la douve rocheuse Gauche & Droite
        for gx, gy, g_off in geyser_pts:
            t_g = (f + g_off) % N_VFX_FRAMES
            prog_g = t_g / float(N_VFX_FRAMES)
            _stamp_ellipse_ring(c_bg, float(gx), float(gy), 6.0 + 18.0 * prog_g, 3.5 + 10.0 * prog_g, (214, 250, 255), mask_allow=water_mask)
            if t_g < 16:
                jet_h = int(round(28.0 * math.sin(math.pi * t_g / 16.0)))
                for dy_j in range(jet_h):
                    for dx_j in (-2, 0, 2):
                        py = gy - dy_j
                        px = gx + dx_j
                        if 0 <= py < H_CANON and 0 <= px < W_CANON:
                            c_top[py, px] = (236, 254, 255, 255) if dy_j > jet_h // 2 else (120, 218, 248, 255)

        # 4) Anneaux soniques d'Écho Marin devant l'autel Nord + bulles bioluminescentes (Top)
        echo_u = (f % 12) / 12.0
        _stamp_ellipse_ring(c_top, 384.0, 136.0, 14.0 + 32.0 * echo_u, 11.0 + 24.0 * echo_u, (192, 248, 255), dashed_phase=-ph)

        for ox0, oy0, o_off in orb_seeds:
            u = ((f + o_off) % N_VFX_FRAMES) / float(N_VFX_FRAMES)
            oy = int(round(oy0 - 108.0 * u))
            ox = int(round(ox0 + 7.0 * math.sin(2.0 * math.pi * u + o_off)))
            if u < 0.84:
                _stamp_pixel_bubble(c_top, ox, oy, 3 if (o_off % 2 == 0) else 4, (132, 236, 248))
            else:
                _stamp_4pt_star(c_top, ox, oy, 2, (244, 255, 255), (96, 222, 246))

        bg_frames.append(Image.fromarray(sanitize_rgba_binary(c_bg)))
        top_frames.append(Image.fromarray(sanitize_rgba_binary(c_top)))

    return _scale_frames(bg_frames, w, h), _scale_frames(top_frames, w, h)
