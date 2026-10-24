#!/usr/bin/env python3
"""Moteur partagé multicalque PMDO 0.8.12.0 pour le duo **Lugia (Tourb'Îles / Fosse d'Argent)** :
  - `FAE1` (*Entrée Engloutie*) : `1×` natif GBA *PMD Red* `H01P03` (*Serene Sea*) + courants 4 phases
    & éclats caustiques natifs *Metano Town* + les 5 faisceaux sous-marins officiels `H02P02W`.
  - `FAS1` (*Arène de Lugia — Caverne des Tourb'Îles façon Pokémon SoulSilver*) :
    * Arène ovale de pierre sombre humide **100 % simple et nue (`0` objet, `0` colonne, `0` décor)**
      reliée au bord Sud par un chemin droit Sud→Nord ;
    * Paroi caverneuse semi-circulaire entourant l'arrière de l'arène avec **9 grandes cascades animées**
      (`H10P02` `1×` hardware waterfall scroll + crêtes d'écume + `Metano_Town_River_Sparkles.tile`) ;
    * **2 tornades d'eau 3D rotatives (`360°`) sur CHAQUE côté du chemin Sud→Nord** (`2` à Gauche + `2` à Droite,
      `24 poses @ 5 ticks = 120 ticks`) surgissant de tourbillons d'écume dans l'eau sombre de la caverne.
"""

from __future__ import annotations

import math
from functools import lru_cache
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

from source.moteur_cyclones_cylindriques_unova import (
    extract_metano_water_and_flower_assets,
    sanitize_rgba_binary,
)
from source.moteur_eau_et_glace_canonique_pmd import (
    colorize_h10p02_indices,
    load_h10p02_native,
)
from source.moteur_forets_pmd_red import (
    _downsample_non_mixing,
    _q8_u8,
    _sanitize_rgb_no_magenta,
    extract_native_metano_river_profiles,
)
from source.moteur_gba_pmd_red_natif import (
    PURE_MAGENTA,
    make_layer_rgba,
    render_gba_native,
    resize_nearest_mask,
    resize_nearest_rgba,
)

REPO_ROOT = Path(__file__).resolve().parent.parent
W_CANON = 768
H_CANON = 576
TILE_SIZE = 8

# Palette Chunsoft 9 tons dédiée aux tornades d'eau souterraines (cobalt -> saphir -> cyan -> écume blanche)
WATER_TORNADO_PALETTE = np.array(
    [
        [8, 46, 118],      # 0 : cœur abyssal bleu-nuit
        [12, 78, 168],     # 1 : sillon saphir profond
        [16, 118, 208],    # 2 : courant céruléen
        [28, 158, 236],    # 3 : ruban d'eau vive azur
        [64, 194, 248],    # 4 : spire turquoise lumineuse
        [116, 222, 252],   # 5 : gerbe d'eau glacée
        [172, 242, 255],   # 6 : écume d'embrun clair
        [220, 250, 255],   # 7 : crête nacrée
        [252, 255, 255],   # 8 : écume blanche pure Chunsoft
    ],
    dtype=np.uint8,
)


def clean_magenta_cutout_strict(raw_rgb: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    """Détoure le fond `#FF00FF` et absorbe toute frange rose/violette en bordure d'eau ou de cascade."""
    r = raw_rgb[:, :, 0].astype(np.int32)
    g = raw_rgb[:, :, 1].astype(np.int32)
    b = raw_rgb[:, :, 2].astype(np.int32)

    pure_seed = (r >= 235) & (g <= 28) & (b >= 235)
    lbl, n_lbl = ndimage.label(pure_seed)
    bg_mask = np.zeros(raw_rgb.shape[:2], dtype=bool)
    for cid in range(1, n_lbl + 1):
        comp = lbl == cid
        if int(comp.sum()) >= 80:
            bg_mask |= comp

    pinkish = ((np.minimum(r, b) - g) >= 14) | ((r >= 125) & (b >= 145) & ((r - g) >= 16))
    for _ in range(8):
        grown = ndimage.binary_dilation(bg_mask, iterations=1) & pinkish
        if np.array_equal(grown, bg_mask):
            break
        bg_mask = grown

    fg_mask = ~bg_mask
    lbl_fg, n_fg = ndimage.label(fg_mask)
    for cid in range(1, n_fg + 1):
        comp = lbl_fg == cid
        if int(comp.sum()) < 24:
            fg_mask[comp] = False
            bg_mask[comp] = True

    cleaned = raw_rgb.copy()
    cleaned[bg_mask] = PURE_MAGENTA
    cleaned = _sanitize_rgb_no_magenta(cleaned, fg_mask)
    return cleaned, fg_mask


def quantize_foreground_96_abyssal(fg_rgb: np.ndarray, fg_mask: np.ndarray) -> np.ndarray:
    """Quantifie la roche caverneuse & l'arène simple en `<= 88` couleurs `MEDIANCUT` (`dither=NONE`)."""
    out = fg_rgb.copy()
    if not np.any(fg_mask):
        return out

    work = fg_rgb.copy()
    work[~fg_mask] = np.array([36, 56, 82], dtype=np.uint8)
    pil_q = Image.fromarray(work, mode="RGB").quantize(
        colors=88,
        method=Image.Quantize.MEDIANCUT,
        dither=Image.Dither.NONE,
    ).convert("RGB")
    q_arr = np.asarray(pil_q, dtype=np.uint8).copy()
    q_arr = _sanitize_rgb_no_magenta(q_arr, fg_mask)
    q_arr[~fg_mask] = PURE_MAGENTA
    return q_arr


@lru_cache(maxsize=4)
def build_metano_abyssal_water_4phases(w: int, h: int, tint_mode: str = "soulsilver_cavern") -> List[np.ndarray]:
    """Construit 4 phases `w × h × 3` d'eau souterraine sans rayures verticales en combinant la nappe
    aquatique `192 × 192` sans couture `H10P02` et l'ondulation 4 phases `Metano_Town_River_Animation_1..4.tile`."""
    from source.moteur_eau_et_glace_canonique_pmd import build_quilted_h10p02_index_sheet

    sheet_idx = build_quilted_h10p02_index_sheet((192, 192))
    tiled_idx = np.tile(sheet_idx, (h // 192 + 2, w // 192 + 2))[:h, :w]

    prof4 = extract_native_metano_river_profiles()
    # Utilise la variation temporelle moyenne par ligne des 4 planches Metano (zéro bande verticale de 24 px !)
    row_mod4 = prof4.astype(np.float32).mean(axis=2)  # (4, n_rows, 3)
    n_rows = row_mod4.shape[1]

    phases: List[np.ndarray] = []
    for k in range(4):
        rgb_h10 = colorize_h10p02_indices(tiled_idx, tick=k * 12).astype(np.float32)
        lum_h10 = 0.20 * rgb_h10[:, :, 0] + 0.48 * rgb_h10[:, :, 1] + 0.32 * rgb_h10[:, :, 2]
        mod_y = np.tile(row_mod4[k], (h // n_rows + 2, 1))[:h, :]
        mod_delta = (mod_y[:, 2] - mod_y[:, 2].mean())[:, None] * 0.35
        norm = np.clip((lum_h10 + mod_delta - 110.0) / 135.0, 0.0, 1.0)

        if tint_mode == "serene_entrance":
            c_r = 12.0 + 40.0 * norm
            c_g = 86.0 + 82.0 * norm
            c_b = 136.0 + 72.0 * norm
        else:
            # Eau souterraine sombre bleu-saphir profond des Tourb'Îles (SoulSilver)
            c_r = 6.0 + 34.0 * (norm ** 1.35)
            c_g = 38.0 + 86.0 * (norm ** 1.20)
            c_b = 92.0 + 104.0 * norm
        rgb = _q8_u8(np.dstack([c_r, c_g, c_b]))
        rgb = _sanitize_rgb_no_magenta(rgb, np.ones((h, w), dtype=bool))
        phases.append(rgb)
    return phases


def build_metano_caustic_sparkles_frames(
    w: int,
    h: int,
    water_mask: np.ndarray,
    n_frames: int = 6,
    seed: int = 24901,
) -> List[Image.Image]:
    """Distribue les grappes natives `Metano_Town_River_Sparkles.tile` teintées cyan-argent dans `water_mask`."""
    assets = extract_metano_water_and_flower_assets()
    clusters: List = assets["sparkle_clusters"]  # type: ignore[assignment]
    eroded = ndimage.binary_erosion(water_mask, iterations=max(2, w // 192))
    ys, xs = np.where(eroded)

    rng = np.random.default_rng(seed)
    spots: List[Tuple[int, int, int, int]] = []
    if len(ys) > 0:
        n_pick = min(40, max(12, len(ys) // 850))
        chosen = rng.choice(len(ys), size=n_pick, replace=False)
        for idx in chosen:
            spots.append((int(xs[idx]), int(ys[idx]), int(rng.integers(0, len(clusters))), int(rng.integers(0, n_frames))))

    frames: List[Image.Image] = []
    for f in range(n_frames):
        canvas = np.zeros((h, w, 4), dtype=np.uint8)
        for sx, sy, c_idx, ph in spots:
            active_phase = (f + ph) % n_frames
            if active_phase >= 3:
                continue
            seq = clusters[c_idx % len(clusters)]
            spr = seq[active_phase % len(seq)] if isinstance(seq, list) else seq
            sh, sw = spr.shape[:2]
            y0, x0 = sy - sh // 2, sx - sw // 2
            if y0 < 2 or x0 < 2 or y0 + sh >= h - 2 or x0 + sw >= w - 2:
                continue
            sub_m = eroded[y0 : y0 + sh, x0 : x0 + sw] & (spr[:, :, 3] > 128)
            if not np.any(sub_m):
                continue
            sub_c = canvas[y0 : y0 + sh, x0 : x0 + sw]
            col = np.array([200, 248, 255, 255] if active_phase == 1 else [96, 204, 244, 255], dtype=np.uint8)
            sub_c[sub_m] = col
        frames.append(Image.fromarray(sanitize_rgba_binary(canvas)))
    return frames


def segment_soulsilver_cavern_and_9_chutes(
    fg_rgb: np.ndarray,
    fg_mask: np.ndarray,
) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Sépare proprement :
      - `cliff_mask` : la grande paroi caverneuse semi-circulaire arrière (avec ajout de 2 chutes latérales extrêmes -> **9 cascades**),
      - `island_arena_mask` : l'arène ovale centrale 100 % simple et nue,
      - `south_path_mask` : le chemin droit Sud→Nord + escalier d'accès à l'arène,
      - `cascade_mask` : les **9 couloirs verticaux de cascades** encastrés dans la falaise arrière !
    """
    h, w = fg_mask.shape
    out_rgb = fg_rgb.copy()
    out_fg = fg_mask.copy()

    # Ouvre 2 chutes supplémentaires sur les ailes extrêmes Ouest (`0.034w..0.068w`) et Est (`0.932w..0.966w`)
    # afin que la couronne de cascades fasse tout le tour (9 cascades au total !)
    yy, xx = np.mgrid[:h, :w]
    for x0_f, x1_f in ((0.034, 0.068), (0.932, 0.966)):
        x0 = max(4, int(round(x0_f * w)))
        x1 = min(w - 5, int(round(x1_f * w)))
        y_top = int(round(0.445 * h))
        y_bot = int(round(0.610 * h))
        chute_box = (xx >= x0) & (xx <= x1) & (yy >= y_top) & (yy <= y_bot)
        out_fg[chute_box] = False
        out_rgb[chute_box] = PURE_MAGENTA
        # Jambages rocheux sombres ciselés de 2 px encadrant la chute
        jamb = (((xx >= x0 - 2) & (xx < x0)) | ((xx > x1) & (xx <= x1 + 2))) & (yy >= y_top) & (yy <= y_bot) & out_fg
        out_rgb[jamb] = np.array([24, 38, 56], dtype=np.uint8)

    lbl, n_cc = ndimage.label(out_fg)
    cliff_mask = np.zeros((h, w), dtype=bool)
    island_all = np.zeros((h, w), dtype=bool)
    for cid in range(1, n_cc + 1):
        comp = lbl == cid
        if np.any(comp[0, :]):
            cliff_mask |= comp
        elif np.any(comp[-1, :]):
            island_all |= comp
        else:
            # Rattache tout petit éperon rocheux haut à la falaise
            ys_c, _ = np.where(comp)
            if len(ys_c) > 0 and ys_c.mean() < 0.55 * h:
                cliff_mask |= comp
            else:
                island_all |= comp

    # Sépare le chemin Sud→Nord (`y >= 0.645h` dans le couloir central) de l'arène ovale simple
    south_path_mask = island_all & (yy >= int(round(0.642 * h))) & (xx >= int(round(0.435 * w))) & (xx <= int(round(0.565 * w)))
    island_arena_mask = island_all & (~south_path_mask)

    # Uniformise finement la dalle supérieure plate de l'arène simple (zéro halo circulaire ni artefact au sol)
    lum_fg = 0.25 * out_rgb[:, :, 0].astype(np.float32) + 0.50 * out_rgb[:, :, 1].astype(np.float32) + 0.25 * out_rgb[:, :, 2].astype(np.float32)
    flat_slab = ndimage.binary_erosion(island_arena_mask & (lum_fg >= 62.0), iterations=max(2, w // 256))
    if np.any(flat_slab):
        med_slab = np.median(out_rgb[flat_slab], axis=0).astype(np.uint8)
        out_rgb[flat_slab] = med_slab

    water_all = ~out_fg
    # Détection géométrique exacte des 9 couloirs verticaux de cascades :
    # Un pixel d'eau `(y, x)` est dans une chute SSI il est encadré à gauche ET à droite sur la même ligne `y`
    # par les parois rocheuses de `cliff_mask` (à moins de `0.042 * w` px de chaque côté) !
    max_half_chute = max(8, int(round(0.042 * w)))
    # Dilatation purement horizontale vers la droite (mur à gauche) et vers la gauche (mur à droite)
    horiz_kern = np.ones((1, 2 * max_half_chute + 1), dtype=bool)
    kern_from_left = horiz_kern.copy()
    kern_from_left[0, :max_half_chute] = False  # étend cliff_mask vers la droite
    kern_from_right = horiz_kern.copy()
    kern_from_right[0, max_half_chute + 1 :] = False  # étend cliff_mask vers la gauche

    flanked_left = ndimage.binary_dilation(cliff_mask, structure=kern_from_left)
    flanked_right = ndimage.binary_dilation(cliff_mask, structure=kern_from_right)
    dist_to_arena = ndimage.distance_transform_edt(~island_arena_mask)
    cascade_mask = water_all & flanked_left & flanked_right & (yy <= int(round(0.62 * h))) & (dist_to_arena >= max(6.0, 0.016 * h))

    # Nettoie les composantes de cascades et dessine une bouche de tunnel sombre en arche juste au-dessus de chaque chute
    lbl_cas, n_cas = ndimage.label(cascade_mask)
    clean_cas = np.zeros((h, w), dtype=bool)
    for cid in range(1, n_cas + 1):
        comp = lbl_cas == cid
        if int(comp.sum()) < max(25, (w * h) // 8000):
            continue
        clean_cas |= comp
        ys_k, xs_k = np.where(comp)
        x0_k, x1_k = int(xs_k.min()), int(xs_k.max())
        y0_k = int(ys_k.min())
        xc_k = 0.5 * (x0_k + x1_k)
        rx_k = max(3.0, 0.54 * (x1_k - x0_k + 1))
        ry_k = max(3.0, 0.015 * h)
        mouth = (
            cliff_mask
            & (yy >= max(0, int(round(y0_k - ry_k))))
            & (yy <= y0_k + 2)
            & ((((xx - xc_k) / rx_k) ** 2 + ((yy - y0_k) / ry_k) ** 2) <= 1.0)
        )
        out_rgb[mouth] = np.array([10, 22, 42], dtype=np.uint8)

    return out_rgb, cliff_mask, island_arena_mask, south_path_mask, clean_cas


def build_9_cavern_waterfalls_frames(
    w: int,
    h: int,
    water_mask: np.ndarray,
    cascade_mask: np.ndarray,
    n_frames: int = 8,
) -> List[Image.Image]:
    """Anime les **9 grandes cascades souterraines** (`H10P02` `1×` hardware waterfall + crêtes d'écume blanches)
    en boucle exacte `8 poses @ 15 ticks = 120 ticks` (`8 × 6 = 48 px` = hauteur pure sans barre d'écume interne)."""
    src_idx, _ = load_h10p02_native()
    # Tranche centrale pure `4..52` (48 px de hauteur) de la cascade H10P02 sans la frange d'écume basse !
    wf_idx = src_idx[4:52, 196:260]
    crest_idx = src_idx[62:76, 196:260]
    ch, cw = wf_idx.shape

    yy, xx = np.mgrid[:h, :w]
    lbl_c, n_c = ndimage.label(cascade_mask)
    chute_specs = []
    for cid in range(1, n_c + 1):
        comp = lbl_c == cid
        ys, xs = np.where(comp)
        if ys.size > 0:
            chute_specs.append((comp, ys, xs, int(round(float(xs.mean()))), int(ys.min()), int(ys.max()), int(xs.max() - xs.min() + 1)))

    frames: List[Image.Image] = []
    for f in range(n_frames):
        tick = f * 6
        wf_rgb = colorize_h10p02_indices(wf_idx, tick=tick)
        crest_rgb = colorize_h10p02_indices(crest_idx, tick=tick)

        out = np.zeros((h, w, 4), dtype=np.uint8)
        for idx_c, (comp, ys, xs, x_center, y_top, y_bot, span_w) in enumerate(chute_specs):
            # Défilement descendant sans couture : 6 px/pose × 8 poses = 48 px == ch !
            phase_px = ((idx_c * 13) + f * 6) % ch
            wf_local = np.roll(wf_rgb, shift=phase_px, axis=0)
            tiled_c = np.tile(wf_local, ((y_bot - y_top) // ch + 3, max(2, span_w // cw + 3), 1))
            rel_y = ys - y_top
            rel_x = np.clip(xs - x_center + (tiled_c.shape[1] // 2), 0, tiled_c.shape[1] - 1)
            cols = tiled_c[rel_y, rel_x].astype(np.int16)

            # Ombrage latéral fin de chute souterraine + lèvre d'écume en haut de chute
            edge_dist = np.minimum(xs - int(xs.min()), int(xs.max()) - xs)
            on_rim = edge_dist <= 1
            cols[on_rim] = np.clip(cols[on_rim] - np.array([28, 32, 18], dtype=np.int16), 0, 255)
            on_lip = (ys - y_top) <= 2
            cols[on_lip] = np.clip(cols[on_lip] + np.array([48, 42, 28], dtype=np.int16), 0, 255)

            out[ys, xs, :3] = cols.astype(np.uint8)
            out[ys, xs, 3] = 255

            # Vasque d'écume bouillonnante au pied exact de chacune des 9 cascades !
            rx_foam = max(7.0, min(28.0, span_w * 0.68))
            ry_foam = max(4.0, 0.015 * h)
            pulse = 1.0 + 0.14 * math.sin(2.0 * math.pi * f / float(n_frames) + idx_c)
            dx_f = (xx - float(x_center)) / (rx_foam * pulse)
            dy_f = (yy - float(y_bot + 2)) / ry_foam
            r2_f = dx_f * dx_f + dy_f * dy_f
            plunge = water_mask & (r2_f <= 1.0)
            pys, pxs = np.where(plunge)
            if pys.size > 0:
                cy_f = np.clip(pys - (y_bot - 4), 0, crest_rgb.shape[0] - 1)
                cx_f = (pxs - x_center + cw // 2) % cw
                p_cols = crest_rgb[cy_f, cx_f].copy()
                core_foam = r2_f[pys, pxs] <= 0.42
                p_cols[core_foam] = np.array([248, 254, 255], dtype=np.uint8)
                out[pys, pxs, :3] = p_cols
                out[pys, pxs, 3] = 255

            # Anneau concentrique d'onde se propageant devant chaque chute
            ring_r = 1.25 + 0.45 * ((f / float(n_frames) + 0.25 * (idx_c % 2)) % 1.0)
            ring = water_mask & (~plunge) & (np.abs(np.sqrt(np.maximum(r2_f, 0.0)) - ring_r) <= 0.14) & (yy >= y_bot)
            out[ring, :3] = np.array([152, 228, 252], dtype=np.uint8)
            out[ring, 3] = 255

        frames.append(Image.fromarray(sanitize_rgba_binary(out)))
    return frames


def _generate_water_tornado_ribbons(seed: int) -> np.ndarray:
    """Catalogue déterministe de 72 rubans hélicoïdaux d'eau & crêtes d'écume sur cylindre 360°."""
    rng = np.random.default_rng(seed)
    ribbons = []
    n_tiers = 18
    for tier in range(n_tiers):
        yn_base = -0.08 + 1.16 * (tier / float(n_tiers - 1))
        az_offset = (tier * 1.6180339) * 2.0 * np.pi
        for sector in range(4):
            phi_c = (az_offset + sector * (0.5 * np.pi) + rng.uniform(-0.22, 0.22)) % (2.0 * np.pi)
            yn_c = yn_base + rng.uniform(-0.022, 0.022)
            half_arc = rng.uniform(0.68, 1.32)
            thick_n = rng.uniform(0.036, 0.068)
            tilt = rng.uniform(-0.055, -0.018)  # hélice aquatique ascendante franche !
            tone_b = rng.uniform(0.32, 0.64)
            limb_jut = rng.uniform(0.07, 0.19)
            ribbons.append([phi_c, yn_c, half_arc, thick_n, tilt, tone_b, limb_jut])
    return np.array(ribbons, dtype=np.float32)


def _wrap_pi(delta: np.ndarray) -> np.ndarray:
    return (delta + np.pi) % (2.0 * np.pi) - np.pi


def render_single_water_tornado_into(
    canvas: np.ndarray,
    water_mask: np.ndarray,
    cx: float,
    y_top: float,
    y_base: float,
    r_mid: float,
    omega: float,
    ribbons: np.ndarray,
    spin_dir: float = 1.0,
) -> None:
    """Rend une tornade d'eau 3D complète (vortex d'assise dans l'eau + colonne funiculaire 3D rotative 360°
    + bouche concave supérieure + gouttelettes d'embruns) directement dans `canvas` (RGBA uint8)."""
    h, w, _ = canvas.shape
    yy_all, xx_all = np.mgrid[:h, :w]

    # 1) Tourbillon concentrique d'assise à la surface de l'eau (`y_base`)
    rx_pool = 1.55 * r_mid
    ry_pool = 0.52 * r_mid
    px0 = max(0, int(math.floor(cx - rx_pool - 4)))
    px1 = min(w, int(math.ceil(cx + rx_pool + 5)))
    py0 = max(0, int(math.floor(y_base - ry_pool - 4)))
    py1 = min(h, int(math.ceil(y_base + ry_pool + 5)))

    if py1 > py0 and px1 > px0:
        sub_x = (xx_all[py0:py1, px0:px1].astype(np.float32) - cx) / max(rx_pool, 1.0)
        sub_y = (yy_all[py0:py1, px0:px1].astype(np.float32) - y_base) / max(ry_pool, 1.0)
        rad = np.sqrt(sub_x * sub_x + sub_y * sub_y)
        ang = np.arctan2(sub_y, sub_x)
        in_pool = (rad <= 1.0) & water_mask[py0:py1, px0:px1]
        if np.any(in_pool):
            spiral = np.sin(3.0 * spin_dir * ang + 7.5 * rad - spin_dir * omega * 2.0)
            pool_val = np.clip(0.38 + 0.34 * spiral + 0.28 * (1.0 - rad), 0.0, 1.0)
            p_idx = np.clip(np.rint(pool_val * (len(WATER_TORNADO_PALETTE) - 1)).astype(np.int32), 1, len(WATER_TORNADO_PALETTE) - 1)
            sub_c = canvas[py0:py1, px0:px1]
            sub_c[in_pool, :3] = WATER_TORNADO_PALETTE[p_idx][in_pool]
            sub_c[in_pool, 3] = 255

    # 2) Colonne cyclonique d'eau 3D de `y_top` à `y_base`
    iy0 = max(0, int(math.floor(y_top)))
    iy1 = min(h, int(math.ceil(y_base)) + 1)
    if iy1 <= iy0 + 6:
        return

    col_h = iy1 - iy0
    yn_1d = np.linspace(0.0, 1.0, col_h, dtype=np.float32)
    # Profil en entonnoir aquatique SoulSilver : couronne évasée en haut, taille resserrée à 0.62, pied d'écume évasé en bas
    r_prof = r_mid * (
        1.24 * np.power(1.0 - yn_1d, 1.55)
        + 0.58
        + 0.44 * np.power(yn_1d, 2.40)
    )
    # Légère ondulation S vivante de l'axe
    xc_1d = cx + spin_dir * (0.10 * r_mid) * np.sin(np.pi * yn_1d + 0.35 * math.sin(omega))

    jut_left = np.zeros(col_h, dtype=np.float32)
    jut_right = np.zeros(col_h, dtype=np.float32)
    phi_g = (ribbons[:, 0] + spin_dir * omega) % (2.0 * np.pi)

    for g_idx in range(len(ribbons)):
        ph_c = float(phi_g[g_idx])
        yn_c = float(ribbons[g_idx, 1])
        h_arc = float(ribbons[g_idx, 2])
        th_n = float(ribbons[g_idx, 3])
        jut_a = float(ribbons[g_idx, 6])
        for limb_phi, target_jut in ((-0.5 * np.pi, jut_left), (0.5 * np.pi, jut_right)):
            dphi = abs(float(_wrap_pi(np.array(limb_phi - ph_c))))
            if dphi < h_arc:
                ang_w = np.cos(0.5 * np.pi * (dphi / h_arc)) ** 1.25
                yn_limb = yn_c + (r_prof / max(float(col_h), 1.0)) * 0.55 * float(np.cos(limb_phi - 0.30))
                dy = (yn_1d - yn_limb) / th_n
                prof = np.exp(-0.5 * dy * dy)
                np.maximum(target_jut, jut_a * ang_w * prof, out=target_jut)

    x_left = xc_1d - r_prof * (0.94 + jut_left)
    x_right = xc_1d + r_prof * (0.94 + jut_right)
    half_span = np.maximum(6.0, 0.5 * (x_right - x_left))
    x_mid = 0.5 * (x_left + x_right)

    bx0 = max(0, int(math.floor(float(x_left.min()))) - 3)
    bx1 = min(w, int(math.ceil(float(x_right.max()))) + 4)
    if bx1 <= bx0:
        return

    xx_sub = np.arange(bx0, bx1, dtype=np.float32)[None, :]
    yn_sub = yn_1d[:, None]
    u = (xx_sub - x_mid[:, None]) / half_span[:, None]

    # Lèvre supérieure et pied elliptiques 3D (pas de coupure horizontale plate !)
    u_cl = np.clip(u, -1.0, 1.0)
    lip_drop_px = 0.24 * r_prof[0] * np.sqrt(np.maximum(0.0, 1.0 - u_cl * u_cl))
    base_curve_px = 0.22 * r_prof[-1] * np.sqrt(np.maximum(0.0, 1.0 - u_cl * u_cl))
    yy_rel = np.arange(col_h, dtype=np.float32)[:, None]

    inside = (np.abs(u) <= 1.0) & (yy_rel >= (0.24 * r_prof[0] - lip_drop_px)) & (yy_rel <= (col_h - 1.0 - 0.22 * r_prof[-1] + base_curve_px))
    phi_px = np.arcsin(u_cl)
    r_norm_h = (r_prof / max(float(col_h), 1.0))[:, None]
    yn_surface = yn_sub - 0.56 * r_norm_h * np.cos(phi_px - 0.30 * spin_dir)

    field = (0.30 + 0.16 * (spin_dir * u_cl) + 0.12 * np.power(yn_sub, 1.6) + 0.06 * np.cos(phi_px)).astype(np.float32)

    for g_idx in range(len(ribbons)):
        ph_c = float(phi_g[g_idx])
        yn_c = float(ribbons[g_idx, 1])
        h_arc = float(ribbons[g_idx, 2])
        th_n = float(ribbons[g_idx, 3])
        tilt = float(ribbons[g_idx, 4]) * spin_dir
        tone_b = float(ribbons[g_idx, 5])

        if abs(float(_wrap_pi(np.array(-ph_c)))) > (0.5 * np.pi + h_arc):
            continue
        dphi = _wrap_pi(phi_px - ph_c)
        in_arc = np.abs(dphi) < h_arc
        if not np.any(in_arc & inside):
            continue
        cos_w = np.maximum(0.0, np.cos(0.5 * np.pi * np.clip(np.abs(dphi) / h_arc, 0.0, 1.0)))
        w_phi = np.where(in_arc, np.power(cos_w, 1.15), 0.0)
        s_vert = (yn_surface - (yn_c + tilt * dphi)) / th_n
        crest = tone_b * np.exp(-2.2 * ((s_vert + 0.24) ** 2))
        trough = -0.38 * np.exp(-2.8 * ((s_vert - 0.84) ** 2))
        field = np.clip(field + w_phi * (crest + trough), 0.0, 1.0)

    # Collerette d'écume blanche bouillonnante à la base (`yn_sub > 0.88`) et sur la couronne haute (`yn_sub < 0.09`)
    collar_boost = 0.36 * np.clip((yn_sub - 0.86) / 0.14, 0.0, 1.0) + 0.22 * np.clip((0.09 - yn_sub) / 0.09, 0.0, 1.0)
    field = np.clip(field + collar_boost, 0.0, 1.0)

    # Bouche concave 3D sombre au centre de l'entonnoir supérieur (vue 3/4 plongeante PMD !)
    mouth_rx = 0.76 * half_span[0]
    mouth_ry = max(4.0, 0.24 * r_prof[0])
    mouth_cy = 0.26 * r_prof[0]
    m_dx = (xx_sub - x_mid[0]) / max(mouth_rx, 1.0)
    m_dy = (yy_rel - mouth_cy) / max(mouth_ry, 1.0)
    m_r2 = m_dx * m_dx + m_dy * m_dy
    in_mouth = inside & (m_r2 <= 1.0)
    if np.any(in_mouth):
        # Bord d'écume blanc autour de l'œil saphir profond de la trombe
        mouth_val = np.where(m_r2 > 0.66, 0.86, 0.06 + 0.16 * m_r2)
        field = np.where(in_mouth, mouth_val.astype(np.float32), field)

    pal_idx = np.clip(np.rint(field * (len(WATER_TORNADO_PALETTE) - 1)).astype(np.int32), 0, len(WATER_TORNADO_PALETTE) - 1)
    col_rgb = WATER_TORNADO_PALETTE[pal_idx]

    sub_dst = canvas[iy0:iy1, bx0:bx1]
    sub_dst[inside, :3] = col_rgb[inside]
    sub_dst[inside, 3] = 255

    # Gouttelettes d'embruns satellitaires tournant autour de chaque tornade d'eau
    for k in range(10):
        ang_d = spin_dir * omega * 2.0 + k * (2.0 * math.pi / 10.0)
        ty_d = (0.12 + 0.78 * ((k * 0.37) % 1.0))
        yi = int(round(iy0 + ty_d * (col_h - 1) + 3.0 * math.sin(ang_d)))
        row_i = int(np.clip(yi - iy0, 0, col_h - 1))
        xi = int(round(float(x_mid[row_i]) + (1.16 + 0.16 * math.sin(k + omega)) * float(half_span[row_i]) * math.sin(ang_d)))
        if 2 <= yi < h - 2 and 2 <= xi < w - 2:
            canvas[yi, xi] = (236, 252, 255, 255)
            if xi + 1 < w - 2 and math.cos(ang_d) > 0.0:
                canvas[yi, xi + 1] = (116, 222, 252, 255)


def build_quad_water_tornado_layers(
    w: int,
    h: int,
    water_mask: np.ndarray,
    n_frames: int = 24,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit les **2 calques `24 poses @ 5 ticks`** des tornades d'eau encadrant le chemin Sud→Nord :
      - Calque Gauche (`left_2_frames`) : **2 tornades d'eau 3D** sur le côté Ouest du chemin Sud→Nord,
      - Calque Droit (`right_2_frames`) : **2 tornades d'eau 3D** sur le côté Est du chemin Sud→Nord."""
    rib_l1 = _generate_water_tornado_ribbons(seed=4901)
    rib_l2 = _generate_water_tornado_ribbons(seed=4902)
    rib_r1 = _generate_water_tornado_ribbons(seed=4903)
    rib_r2 = _generate_water_tornado_ribbons(seed=4904)

    left_frames: List[Image.Image] = []
    right_frames: List[Image.Image] = []

    for f in range(n_frames):
        omega = 2.0 * math.pi * f / float(n_frames)

        c_left = np.zeros((h, w, 4), dtype=np.uint8)
        # Tornade Gauche arrière-flanc (dans le grand bras d'eau Ouest)
        render_single_water_tornado_into(
            c_left,
            water_mask,
            cx=0.184 * w,
            y_top=0.455 * h,
            y_base=0.790 * h,
            r_mid=0.036 * w,
            omega=omega,
            ribbons=rib_l1,
            spin_dir=1.0,
        )
        # Tornade Gauche avant-chemin (juste à gauche du chemin Sud→Nord)
        render_single_water_tornado_into(
            c_left,
            water_mask,
            cx=0.330 * w,
            y_top=0.638 * h,
            y_base=0.942 * h,
            r_mid=0.039 * w,
            omega=(omega + 1.05) % (2.0 * math.pi),
            ribbons=rib_l2,
            spin_dir=1.0,
        )
        left_frames.append(Image.fromarray(sanitize_rgba_binary(c_left)))

        c_right = np.zeros((h, w, 4), dtype=np.uint8)
        # Tornade Droite arrière-flanc (dans le grand bras d'eau Est)
        render_single_water_tornado_into(
            c_right,
            water_mask,
            cx=0.816 * w,
            y_top=0.455 * h,
            y_base=0.790 * h,
            r_mid=0.036 * w,
            omega=omega,
            ribbons=rib_r1,
            spin_dir=-1.0,
        )
        # Tornade Droite avant-chemin (juste à droite du chemin Sud→Nord)
        render_single_water_tornado_into(
            c_right,
            water_mask,
            cx=0.670 * w,
            y_top=0.638 * h,
            y_base=0.942 * h,
            r_mid=0.039 * w,
            omega=(omega + 1.05) % (2.0 * math.pi),
            ribbons=rib_r2,
            spin_dir=-1.0,
        )
        right_frames.append(Image.fromarray(sanitize_rgba_binary(c_right)))

    return left_frames, right_frames


def build_shore_foam_frames(
    w: int,
    h: int,
    water_mask: np.ndarray,
    cascade_mask: np.ndarray,
    n_frames: int = 12,
) -> List[Image.Image]:
    """Liseré d'écume blanche animée battant UNIQUEMENT les vraies parois rocheuses (`water_mask`),
    jamais à travers l'eau libre ni devant les tornades !"""
    dist_rock = ndimage.distance_transform_edt(water_mask)
    open_sea = water_mask & (~cascade_mask)
    yy, xx = np.mgrid[:h, :w]

    frames: List[Image.Image] = []
    for f in range(n_frames):
        ph = 2.0 * math.pi * f / float(n_frames)
        wave = np.sin(0.20 * xx + 0.17 * yy + ph)
        foam_inner = open_sea & (dist_rock > 0.0) & (dist_rock <= (1.5 + 0.85 * wave))
        foam_outer = open_sea & (~foam_inner) & (dist_rock <= (2.8 + 0.85 * wave))

        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[foam_outer] = (112, 196, 240, 255)
        out[foam_inner] = (232, 250, 255, 255)
        frames.append(Image.fromarray(sanitize_rgba_binary(out)))
    return frames


def build_h02p02w_light_shafts_top(
    w: int,
    h: int,
    canopy_top_rgba: np.ndarray | None,
    n_frames: int = 8,
    shaft_alpha: int = 34,
) -> List[Image.Image]:
    """Assemble sur la couche `09 Top` les **5 faisceaux lumineux souterrains Chunsoft `H02P02W`**
    à faible opacité translucide + brume d'embruns des cascades."""
    w_rgba, w_pm, _ = render_gba_native("H02P02W", phase=None, bpa_frame=0)
    shaft_mask_base = resize_nearest_mask(w_pm >= 0, w, h)
    shaft_rgb_base = resize_nearest_rgba(w_rgba, w, h)[:, :, :3]

    yy, _ = np.mgrid[:h, :w]
    fade_y = np.clip(1.12 - yy.astype(np.float32) / float(h), 0.18, 1.0)

    rng = np.random.default_rng(24999)
    n_motes = 24
    mx0 = rng.integers(max(8, w // 14), max(16, w - w // 14), size=n_motes)
    my0 = rng.integers(max(8, h // 14), max(16, h - h // 10), size=n_motes)
    mph = rng.uniform(0.0, 2.0 * math.pi, size=n_motes)

    frames_top: List[Image.Image] = []
    for f in range(n_frames):
        theta = 2.0 * math.pi * f / float(n_frames)
        dx = int(round(max(2.0, w * 0.005) * math.cos(theta)))
        m_shift = np.roll(shaft_mask_base, shift=dx, axis=1)
        rgb_shift = np.roll(shaft_rgb_base, shift=dx, axis=1)
        if dx > 0:
            m_shift[:, :dx] = False
        elif dx < 0:
            m_shift[:, dx:] = False

        arr = np.zeros((h, w, 4), dtype=np.uint8)
        breath = 0.88 + 0.12 * math.cos(theta)
        alpha_map = np.clip(np.round(shaft_alpha * fade_y * breath), 14, 56).astype(np.uint8)

        s_rgb = _sanitize_rgb_no_magenta(
            np.clip(rgb_shift.astype(np.int16) + np.array([24, 76, 92], dtype=np.int16), 0, 255).astype(np.uint8),
            m_shift,
        )
        arr[m_shift, :3] = s_rgb[m_shift]
        arr[m_shift, 3] = alpha_map[m_shift]

        for i in range(n_motes):
            px = int(round(mx0[i] + max(2.0, w * 0.007) * math.sin(theta + mph[i])))
            py = int((my0[i] - int(round((f / float(n_frames)) * max(16, h // 11)))) % (h - 12)) + 6
            if 4 <= px < w - 4 and 4 <= py < h - 4:
                arr[py, px] = (220, 250, 255, 210)
                if px + 1 < w - 4 and math.cos(theta + mph[i]) > 0.25:
                    arr[py, px + 1] = (124, 220, 250, 175)

        if canopy_top_rgba is not None:
            can_op = canopy_top_rgba[:, :, 3] >= 128
            arr[can_op] = canopy_top_rgba[can_op]

        frames_top.append(Image.fromarray(arr, mode="RGBA"))
    return frames_top
