#!/usr/bin/env python3
"""Moteur partagé multicalque PMDO 0.8.12.0 pour le duo **Lugia (Tourb'Îles / Fosse d'Argent)** :
  - `FAE1` (*Entrée Engloutie*) : `1×` natif GBA *PMD Red* `H01P03` (*Serene Sea*) + courants 4 phases
    & éclats caustiques natifs *Metano Town* + les 5 faisceaux sous-marins officiels `H02P02W`.
  - `FAS1` (*Arène de Lugia — Caverne des Tourb'Îles façon Pokémon SoulSilver*) :
    * Arène ovale de pierre sombre humide **100 % simple et nue (`0` objet, `0` colonne, `0` décor)**
      reliée au bord Sud par un chemin droit Sud→Nord ;
    * **Eau Metano Town sombre** autour de l'arène et du chemin (`Metano_Town_River_Animation_1..4.tile`
      + `Metano_Town_River_Sparkles.tile`, `4 poses × 10 ticks` assombries selon la courbe nocturne Metano) ;
    * Paroi caverneuse semi-circulaire entourant l'arrière de l'arène avec **9 cascades authentiques
      de *Foggy Forest* (`P03P01A` — *Plateau Sylvestre / Forêt Brumeuse*, *PMD Explorers of Sky*,
      `3 poses BPA × 10 ticks` à l'échelle `1×` native avec vasques d'écume bouillonnantes)** ;
    * **2 tornades d'eau géantes hors-cadre sur CHAQUE côté du chemin Sud→Nord** (`2` à Gauche + `2` à Droite,
      `y = 0 .. h-1` sans extrémité haute ni basse visible, exactement comme *Sky Tower Entrance* `TCE1`).
"""

from __future__ import annotations

import json
import math
from functools import lru_cache
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

from source.moteur_cyclones_cylindriques_unova import (
    decode_pmdo_tile,
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

# Palette exacte de l'eau Metano Town sombre (courbe nocturne caverne sur les tons officiels de Metano_Town_River)
DARK_METANO_PAL: Dict[str, Tuple[int, int, int]] = {
    "surface": (22, 56, 134),     # M_SURFACE (131, 218, 230) assombri en bleu-saphir Metano sombre
    "bande": (10, 26, 78),        # bande sombre de rive Metano (87, 135, 191)
    "inter": (15, 42, 106),       # onde intermédiaire Metano (95, 183, 207)
    "accent": (32, 78, 164),      # accent d'onde Metano (111, 207, 231) bien lisible
    "clair": (84, 148, 214),      # liseré clair de rive Metano (148, 230, 238)
    "spark_mid": (48, 106, 190),  # reflet intermédiaire Metano_Town_River_Sparkles (156, 234, 246)
    "spark_hi": (176, 226, 252),  # éclat diamant Metano_Town_River_Sparkles (246, 250, 255)
}

# Palette Chunsoft 9 tons dédiée aux tornades d'eau géantes façon Sky Tower Entrance (saphir -> azur -> écume)
WATER_TORNADO_PALETTE = np.array(
    [
        [8, 42, 118],      # 0 : ombre cyclonique bleu-nuit profond
        [12, 78, 172],     # 1 : creux aquatique saphir profond
        [18, 126, 218],    # 2 : sillon d'eau céruléen vif
        [40, 168, 242],    # 3 : courant azur-turquoise
        [78, 202, 250],    # 4 : spire d'eau turquoise lumineuse
        [132, 228, 254],   # 5 : nappe d'embrun cyan clair
        [184, 244, 255],   # 6 : écume d'eau blanc-bleuté
        [226, 252, 255],   # 7 : crête d'écume nacrée
        [255, 255, 255],   # 8 : crête blanche pure Chunsoft
    ],
    dtype=np.uint8,
)


def clean_magenta_cutout_strict(raw_rgb: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    """Détoure le fond `#FF00FF` et absorbe toute frange rose/violette en bordure d'eau ou de falaise."""
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
    """Conservé pour `FAE1` (`tint_mode='serene_entrance'`) : eau sous-marine 4 phases."""
    from source.moteur_eau_et_glace_canonique_pmd import build_quilted_h10p02_index_sheet

    sheet_idx = build_quilted_h10p02_index_sheet((192, 192))
    tiled_idx = np.tile(sheet_idx, (h // 192 + 2, w // 192 + 2))[:h, :w]

    prof4 = extract_native_metano_river_profiles()
    row_mod4 = prof4.astype(np.float32).mean(axis=2)
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
    """Distribue les grappes natives `Metano_Town_River_Sparkles.tile` teintées cyan-argent dans `water_mask` (`FAE1`)."""
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


# ============================================================================
# 1. EAU METANO TOWN SOMBRE AUTHENTIQUE (`Metano_Town_River_Animation_1..4` + `Sparkles`)
# ============================================================================

@lru_cache(maxsize=1)
def _load_dark_metano_sparkle_and_wave_families() -> Dict[str, List[np.ndarray]]:
    """Extrait à l'échelle `1×` native les 3 familles officielles `4 × 10 ticks` de
    `Metano_Town_River_Sparkles.tile` (`A_16x24`, `B_24x16`, `C_16x32`) ainsi que les
    2 rubans d'onde pleine eau `8×32` de `Metano_Town_River_Animation_1..4.tile`,
    re-teintés exactement dans la palette **Metano Town sombre** (`DARK_METANO_PAL`)."""
    eau_dir = REPO_ROOT / "source" / "eau_metano" / "natifs"
    sp_sheet = np.asarray(decode_pmdo_tile(eau_dir / "Metano_Town_River_Sparkles.tile"), dtype=np.uint8)
    m_surf = np.array([131, 218, 230], dtype=np.int32)

    def _extract_sparkle_cluster(cols: List[int], rows: List[int], step: int) -> List[np.ndarray]:
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
            mid = keep & (~hi)
            out[mid] = (*DARK_METANO_PAL["spark_mid"], 255)
            out[hi] = (*DARK_METANO_PAL["spark_hi"], 255)
            seq.append(out)
        return seq

    families: Dict[str, List[np.ndarray]] = {
        "A_16x24": _extract_sparkle_cluster([0, 1], [0, 1, 2], 3),
        "B_24x16": _extract_sparkle_cluster([2, 3, 4], [0, 1], 2),
        "C_16x32": _extract_sparkle_cluster([0, 1], [12, 13, 14, 15], 4),
    }

    # Rubans d'onde pleine eau natifs 8x32 issus de Metano_Town_River_Animation_1..4.tile
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
            darker = keep & (~brighter)
            out[darker] = (*DARK_METANO_PAL["inter"], 255)
            out[brighter] = (*DARK_METANO_PAL["accent"], 255)
            seq_r.append(out)
        families[tag] = seq_r

    return families


def build_dark_metano_town_water_layers(
    w: int,
    h: int,
    water_mask: np.ndarray,
    seed: int = 24915,
) -> Tuple[Image.Image, List[Image.Image], List[Image.Image]]:
    """Construit l'**eau Metano Town sombre** authentique autour de l'arène et du chemin Sud→Nord :
      1. `im_base` (`1` pose statique) : nappe d'eau profonde Metano sombre (`DARK_METANO_PAL['surface']`),
      2. `wave_4_frames` (`4 poses @ 10 ticks`) : franges d'ondes concentriques Metano Town
         (`bande` / `inter` / `accent` / `clair`) battant la falaise, l'arène ovale et le chemin Sud→Nord,
      3. `sparkle_4_frames` (`4 poses @ 10 ticks`) : grappes `1×` natives `Metano_Town_River_Sparkles.tile`
         (`A_16x24`, `B_24x16`, `C_16x32`) + rubans d'onde `Metano_Town_River_Animation_1..4.tile` assombris.
    """
    # 1) Nappe de base Metano sombre (couvre 100 % du canevas sous les calques pour éviter tout trou alpha)
    base_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    base_rgba[:, :, :3] = DARK_METANO_PAL["surface"]
    base_rgba[:, :, 3] = 255
    im_base = Image.fromarray(base_rgba, mode="RGBA")

    # 2) Ondes de rive 4 phases façon Metano_Town_River_Animation_1..4 (FrameLength = 10 ticks)
    dist = ndimage.distance_transform_edt(water_mask)
    yy, xx = np.mgrid[:h, :w]
    jag = ndimage.gaussian_filter(np.random.default_rng(9).random((h, w)), 1.0)
    ptp = float(np.ptp(jag))
    jag = (jag - float(jag.min())) / (ptp if ptp > 1e-6 else 1.0)

    wave_4_frames: List[Image.Image] = []
    scale_band = max(0.65, min(1.15, w / float(W_CANON)))
    for t in range(4):
        ph = 2.0 * math.pi * t / 4.0
        n_wave = 0.60 * np.sin(yy * 0.21 + xx * 0.08 - ph) + 0.40 * np.sin(yy * 0.09 - xx * 0.18 + 1.3 - ph)
        t_inner = (6.8 + 1.55 * n_wave) * scale_band
        jr = np.roll(jag, shift=t * 2, axis=0)
        fringe = t_inner + (1.8 + 4.4 * jr) * scale_band

        a = np.zeros((h, w, 4), dtype=np.uint8)
        m_fringe = water_mask & (dist > 0.0) & (dist <= fringe)
        a[m_fringe] = (*DARK_METANO_PAL["inter"], 255)
        m_accent = m_fringe & (jr > 0.52)
        a[m_accent] = (*DARK_METANO_PAL["accent"], 255)
        m_t = water_mask & (dist > 0.0) & (dist <= t_inner)
        a[m_t] = (*DARK_METANO_PAL["inter"], 255)
        m_bande = water_mask & (dist > 0.0) & (dist <= np.maximum(1.8, t_inner - 2.2 * scale_band))
        a[m_bande] = (*DARK_METANO_PAL["bande"], 255)
        m_clair = water_mask & (dist > 0.0) & (dist <= 1.55) & (np.sin(xx * 0.28 + yy * 0.44 - ph) > -0.35)
        a[m_clair] = (*DARK_METANO_PAL["clair"], 255)
        wave_4_frames.append(Image.fromarray(sanitize_rgba_binary(a)))

    # 3) Scintillements & rubans d'onde natifs Metano_Town_River_Sparkles.tile (4 poses @ 10 ticks)
    fams = _load_dark_metano_sparkle_and_wave_families()
    fam_keys = ["A_16x24", "B_24x16", "C_16x32", "R1_8x32", "R2_8x32"]
    deep_free = ndimage.binary_erosion(water_mask, iterations=max(2, int(round(6 * scale_band))))
    taken = np.zeros((h, w), dtype=bool)
    rng = np.random.default_rng(seed)

    cands = [(y, x) for y in range(8, max(16, h - 32), 8) for x in range(8, max(16, w - 32), 8)]
    rng.shuffle(cands)
    target_count = max(14, int(round(58 * (w * h) / float(W_CANON * H_CANON))))
    placements: List[Tuple[int, int, str, int]] = []
    for cy, cx in cands:
        fk = fam_keys[len(placements) % len(fam_keys)]
        sh, sw = fams[fk][0].shape[:2]
        if cy + sh >= h - 4 or cx + sw >= w - 4:
            continue
        if not np.all(deep_free[cy : cy + sh, cx : cx + sw]):
            continue
        pad_y0, pad_y1 = max(0, cy - 12), min(h, cy + sh + 12)
        pad_x0, pad_x1 = max(0, cx - 12), min(w, cx + sw + 12)
        if np.any(taken[pad_y0:pad_y1, pad_x0:pad_x1]):
            continue
        taken[cy : cy + sh, cx : cx + sw] = True
        placements.append((cy, cx, fk, int(rng.integers(0, 4))))
        if len(placements) >= target_count:
            break

    sparkle_4_frames: List[Image.Image] = []
    for k in range(4):
        canvas = np.zeros((h, w, 4), dtype=np.uint8)
        for cy, cx, fk, ph0 in placements:
            spr = fams[fk][(k + ph0) % 4]
            sh, sw = spr.shape[:2]
            hit = spr[:, :, 3] == 255
            if np.any(hit):
                sub = canvas[cy : cy + sh, cx : cx + sw]
                sub[hit] = spr[hit]
        sparkle_4_frames.append(Image.fromarray(sanitize_rgba_binary(canvas)))

    return im_base, wave_4_frames, sparkle_4_frames


# ============================================================================
# 2. ARCHITECTURE CAVERNE SOULSILVER & 9 CASCADES DE FOGGY FOREST (`P03P01A`)
# ============================================================================

def segment_soulsilver_cavern_clean(
    fg_rgb: np.ndarray,
    fg_mask: np.ndarray,
) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Sépare proprement :
      - `cliff_mask` : la grande paroi caverneuse semi-circulaire arrière (cicatrisée en pierre continue
        pour recevoir sans bavure les **9 cascades verticales authentiques de *Foggy Forest* `P03P01A`**),
      - `island_arena_mask` : l'arène ovale centrale **100 % simple et nue (`0` objet)** légèrement affinée
        pour dégager généreusement l'eau Metano sombre et les tornades géantes,
      - `south_path_mask` : le chemin droit Sud→Nord + marches de pierre d'accès à l'arène.
    """
    h, w = fg_mask.shape
    yy, xx = np.mgrid[:h, :w]

    lbl, n_cc = ndimage.label(fg_mask)
    cliff_raw = np.zeros((h, w), dtype=bool)
    island_all = np.zeros((h, w), dtype=bool)
    for cid in range(1, n_cc + 1):
        comp = lbl == cid
        if np.any(comp[0, :]):
            cliff_raw |= comp
        elif np.any(comp[-1, :]):
            island_all |= comp
        else:
            ys_c, _ = np.where(comp)
            if len(ys_c) > 0 and ys_c.mean() < 0.55 * h:
                cliff_raw |= comp
            else:
                island_all |= comp

    # Cicatrise les anciennes encoches de chutes du brut dans `cliff_raw` en paroi rocheuse continue :
    max_gap_half = max(8, int(round(0.046 * w)))
    horiz_kern = np.ones((1, 2 * max_gap_half + 1), dtype=bool)
    kern_l = horiz_kern.copy()
    kern_l[0, :max_gap_half] = False
    kern_r = horiz_kern.copy()
    kern_r[0, max_gap_half + 1 :] = False
    dist_island = ndimage.distance_transform_edt(~island_all)
    chute_gaps = (
        (~cliff_raw)
        & (~island_all)
        & ndimage.binary_dilation(cliff_raw, structure=kern_l)
        & ndimage.binary_dilation(cliff_raw, structure=kern_r)
        & (yy <= int(round(0.60 * h)))
        & (dist_island >= max(8.0, 0.025 * h))
    )
    cliff_mask = cliff_raw | chute_gaps

    out_rgb = fg_rgb.copy()
    # Remplit les pixels cicatrisés avec la texture rocheuse réelle de la falaise voisine sur la même ligne
    if np.any(chute_gaps):
        _, nearest_idx = ndimage.distance_transform_edt(~cliff_raw, return_indices=True)
        out_rgb[chute_gaps] = fg_rgb[nearest_idx[0][chute_gaps], nearest_idx[1][chute_gaps]]

    # Sépare le chemin droit Sud→Nord de l'arène ovale simple
    south_path_mask = (
        island_all
        & (yy >= int(round(0.640 * h)))
        & (xx >= int(round(0.435 * w)))
        & (xx <= int(round(0.565 * w)))
    )
    arena_raw = island_all & (~south_path_mask)

    # Affine légèrement l'envergure horizontale de l'arène ovale (`scale_x = 0.84`) pour ouvrir un large
    # chenal d'eau Metano sombre entre l'arène et les tornades géantes façon Sky Tower Entrance !
    cx_mid = 0.5 * (w - 1)
    src_x = np.clip(np.rint(cx_mid + (xx.astype(np.float32) - cx_mid) / 0.84).astype(np.int32), 0, w - 1)
    island_arena_mask = arena_raw[yy, src_x] & (~cliff_mask)
    arena_sampled_rgb = fg_rgb[yy, src_x]

    # Ré-assemble proprement les couleurs sans frange magenta
    final_rgb = np.empty_like(out_rgb)
    final_rgb[:, :] = PURE_MAGENTA
    final_rgb[cliff_mask] = out_rgb[cliff_mask]
    final_rgb[island_arena_mask] = arena_sampled_rgb[island_arena_mask]
    final_rgb[south_path_mask] = out_rgb[south_path_mask]

    # Uniformise finement la dalle supérieure plate de l'arène simple (`0` objet, `0` motif parasite)
    lum_fg = (
        0.25 * final_rgb[:, :, 0].astype(np.float32)
        + 0.50 * final_rgb[:, :, 1].astype(np.float32)
        + 0.25 * final_rgb[:, :, 2].astype(np.float32)
    )
    flat_slab = ndimage.binary_erosion(island_arena_mask & (lum_fg >= 62.0), iterations=max(2, w // 256))
    if np.any(flat_slab):
        med_slab = np.median(final_rgb[flat_slab], axis=0).astype(np.uint8)
        final_rgb[flat_slab] = med_slab

    fg_union = cliff_mask | island_arena_mask | south_path_mask
    final_rgb = _sanitize_rgb_no_magenta(final_rgb, fg_union)
    return final_rgb, cliff_mask, island_arena_mask, south_path_mask


@lru_cache(maxsize=1)
def _load_foggy_forest_p03p01a_atlas() -> Tuple[np.ndarray, dict]:
    """Charge l'atlas lossless suivi dans Git des cascades natives `P03P01A` (*Foggy Forest*, *PMD Sky*)."""
    ref_dir = REPO_ROOT / "source" / "fosse_argent_sanctuaire_v1" / "references"
    atlas = np.asarray(Image.open(ref_dir / "foggy_forest_p03p01a_waterfalls.png").convert("RGBA"), dtype=np.uint8)
    meta = json.loads((ref_dir / "foggy_forest_p03p01a_waterfalls.json").read_text(encoding="utf-8"))
    return atlas, meta


def build_foggy_forest_waterfalls_frames(
    w: int,
    h: int,
    cliff_mask: np.ndarray,
    arena_mask: np.ndarray,
    fg_rgb_mut: np.ndarray,
) -> List[Image.Image]:
    """Dispose **9 cascades animées authentiques de *Foggy Forest* (`P03P01A` — *Forêt Brumeuse*, *PMD Sky*)**
    (`3 poses BPA × 10 ticks = 30 ticks`, `4` cycles exacts par `120` ticks) tout autour de l'amphithéâtre
    rocheux derrière l'arène simple de Lugia, avec leurs vasques d'écume blanche et rides concentriques :
      - Cascade centrale Nord héroïque (`x = 0.500w`) : `wide_64` (`64 px` native),
      - Paires intermédiaires (`0.398w / 0.602w` et `0.268w / 0.732w`) : `medium_48` (`48 px` native),
      - Paires fines signature *Foggy Forest* (`0.330w / 0.670w` et ailes `0.165w / 0.835w`) : `narrow_16` (`16 px`).
    Creuse également une bouche de caverne sombre en arche dans `fg_rgb_mut` en haut de chaque chute !"""
    atlas, meta = _load_foggy_forest_p03p01a_atlas()
    sx_scale = w / float(W_CANON)
    sy_scale = h / float(H_CANON)

    # Spécification symétrique (x_frac, variant_name, phase_offset) des 9 cascades Foggy Forest
    specs = [
        (0.135, "medium_48", 2),
        (0.280, "medium_48", 1),
        (0.342, "narrow_16", 0),
        (0.404, "medium_48", 2),
        (0.500, "wide_64", 0),
        (0.596, "medium_48", 2),
        (0.658, "narrow_16", 0),
        (0.720, "medium_48", 1),
        (0.865, "medium_48", 2),
    ]

    yy_grid, xx_grid = np.mgrid[:h, :w]
    cliff_lum = (
        0.25 * fg_rgb_mut[:, :, 0].astype(np.float32)
        + 0.50 * fg_rgb_mut[:, :, 1].astype(np.float32)
        + 0.25 * fg_rgb_mut[:, :, 2].astype(np.float32)
    )
    lit_cliff_mask = cliff_mask & (cliff_lum >= 40.0)

    # Calcule les ancrages verticaux exacts sur la crête rocheuse courbe de `lit_cliff_mask`
    placements = []
    for x_frac, vname, ph_off in specs:
        xc = int(round(x_frac * w))
        col_band_x0 = max(0, xc - max(2, int(round(6 * sx_scale))))
        col_band_x1 = min(w, xc + max(3, int(round(6 * sx_scale)) + 1))
        cliff_ys = np.where(cliff_mask[:, col_band_x0:col_band_x1].any(axis=1))[0]
        lit_ys = np.where(lit_cliff_mask[:, col_band_x0:col_band_x1].any(axis=1))[0]
        if len(cliff_ys) < 8:
            continue
        # Pied de la falaise juste au-dessus du bras d'eau Metano sombre
        y_water = int(cliff_ys.max()) + max(2, int(round(4 * sy_scale)))
        # Suit fidèlement l'arche semi-circulaire 3D de la paroi éclairée !
        crest_y = int(lit_ys.min()) if len(lit_ys) >= 4 else int(cliff_ys.min())
        y_top = max(max(6, int(round(14 * sy_scale))), crest_y + max(3, int(round(6 * sy_scale))))
        if y_water <= y_top + max(14, int(round(32 * sy_scale))):
            continue

        vd = meta["variants"][vname]
        sw_nat = int(vd["shaft_width"])
        sw_scaled = max(4, int(round(sw_nat * sx_scale)))
        rx_mouth = max(3.0, 0.58 * sw_scaled)
        ry_mouth = max(3.0, 9.0 * sy_scale)
        mouth = (
            cliff_mask
            & (yy_grid >= max(0, int(round(y_top - ry_mouth))))
            & (yy_grid <= y_top + max(3, int(round(5 * sy_scale))))
            & ((((xx_grid - float(xc)) / rx_mouth) ** 2 + ((yy_grid - float(y_top)) / ry_mouth) ** 2) <= 1.0)
        )
        fg_rgb_mut[mouth] = np.array([8, 18, 38], dtype=np.uint8)
        placements.append((xc, y_top, y_water, vname, ph_off))

    # Rend les 3 poses BPA à la résolution canonique 768x576 (1x pixel-perfect !) puis redimensionne si w != 768
    frames_out: List[Image.Image] = []
    for k in range(3):
        canvas_canon = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        for xc_s, y_top_s, y_wat_s, vname, ph_off in placements:
            xc_c = int(round(xc_s / sx_scale))
            yt_c = int(round(y_top_s / sy_scale))
            yw_c = int(round(y_wat_s / sy_scale))

            vd = meta["variants"][vname]
            fk = (k + ph_off) % 3
            sx, sy, sw, sh = vd["shaft_boxes_xywh"][fk]
            px, py, pw, ph = vd["plunge_boxes_xywh"][fk]
            s_im = atlas[sy : sy + sh, sx : sx + sw]
            p_im = atlas[py : py + ph, px : px + pw]

            yp0 = yw_c - int(vd["waterline_offset_in_plunge"])
            y_shaft_end = min(H_CANON, yp0 + 16)
            yt_clamped = max(0, yt_c)
            if y_shaft_end > yt_clamped:
                ys_col = np.arange(yt_clamped, y_shaft_end)
                mod_rows = (ys_col - yp0 + int(vd["plunge_y0_mod96"])) % 96
                shaft_strip = s_im[mod_rows].copy()
                # Arrondi 3D en voûte sur les 5 premières lignes de sortie de bouche caverneuse
                u_x = (np.arange(sw, dtype=np.float32) - 0.5 * (sw - 1)) / max(1.0, 0.5 * sw)
                arch_drop = 5.0 * (1.0 - np.sqrt(np.maximum(0.0, 1.0 - np.clip(u_x, -1.0, 1.0) ** 2)))
                rel_rows = np.arange(y_shaft_end - yt_clamped, dtype=np.float32)[:, None]
                shaft_strip[rel_rows < arch_drop[None, :], 3] = 0

                xs0 = xc_c - sw // 2
                cx0 = max(0, xs0)
                cx1 = min(W_CANON, xs0 + sw)
                if cx1 > cx0:
                    sub_s = shaft_strip[:, cx0 - xs0 : cx1 - xs0]
                    ms = sub_s[:, :, 3] == 255
                    dst_s = canvas_canon[yt_clamped:y_shaft_end, cx0:cx1]
                    dst_s[ms] = sub_s[ms]

            xp0 = xc_c - pw // 2
            py0_c = max(0, yp0)
            py1_c = min(H_CANON, yp0 + ph)
            px0_c = max(0, xp0)
            px1_c = min(W_CANON, xp0 + pw)
            if py1_c > py0_c and px1_c > px0_c:
                sub_p = p_im[py0_c - yp0 : py1_c - yp0, px0_c - xp0 : px1_c - xp0]
                mp = sub_p[:, :, 3] == 255
                dst_p = canvas_canon[py0_c:py1_c, px0_c:px1_c]
                dst_p[mp] = sub_p[mp]

        if (w, h) != (W_CANON, H_CANON):
            canvas_scaled = resize_nearest_rgba(canvas_canon, w, h)
        else:
            canvas_scaled = canvas_canon
        # Ne déborde jamais sur la dalle de l'arène centrale
        canvas_scaled[arena_mask] = 0
        frames_out.append(Image.fromarray(sanitize_rgba_binary(canvas_scaled)))

    return frames_out


# ============================================================================
# 3. QUATRE TORNADES D'EAU GÉANTES HORS-CADRE FAÇON SKY TOWER ENTRANCE (`TCE1`)
# ============================================================================

def _wrap_pi(delta: np.ndarray) -> np.ndarray:
    return (delta + np.pi) % (2.0 * np.pi) - np.pi


def _generate_3fold_gust_catalog(seed: int) -> np.ndarray:
    """Catalogue déterministe de `78` bourrasques d'eau Chunsoft en croissant avec **symétrie hélicoïdale
    d'ordre 3 exacte (`120° = 2*pi/3`)** :
      - Permet une rotation à la vitesse exacte de `TCE1` (`15°` toutes les `5` ticks = `12 FPS`)
        en **`8 poses @ 5 ticks = 40 ticks`** (`3` cycles exacts par `120` ticks, raccord `pose 7 -> 0`
        mathématiquement identique au bit près !),
      - Réduit par `3×` la taille des banques `.tile` (`~15 000` tuiles `< 24 000` !).
    """
    rng = np.random.default_rng(seed)
    gusts = []
    n_tiers = 26
    sector_step = (2.0 * np.pi) / 3.0
    for tier in range(n_tiers):
        yn_base = -0.14 + 1.28 * (tier / float(n_tiers - 1))
        phi_seed = ((tier * 1.6180339) * sector_step + rng.uniform(-0.18, 0.18)) % sector_step
        yn_j = yn_base + rng.uniform(-0.018, 0.018)
        half_arc = rng.uniform(0.56, 1.04)
        thick_n = rng.uniform(0.026, 0.054)
        tilt = rng.uniform(-0.036, 0.020)
        tone_b = rng.uniform(0.30, 0.62)
        limb_jut = rng.uniform(0.06, 0.16)
        for sec in range(3):
            phi_c = (phi_seed + sec * sector_step) % (2.0 * np.pi)
            gusts.append([phi_c, yn_j, half_arc, thick_n, tilt, tone_b, limb_jut])
    return np.array(gusts, dtype=np.float32)


def _outer_cyclone_axis_and_radius(h: int, w: int) -> Tuple[np.ndarray, np.ndarray]:
    """Tornade d'eau géante EXTÉRIEURE (`y = 0 .. h-1`, hors-cadre haut & bas comme `TCE1`)."""
    yn = np.linspace(0.0, 1.0, h, dtype=np.float32)
    xc = w * (
        0.028
        - 0.008 * np.sin(np.pi * np.clip(yn / 0.45, 0.0, 1.0))
        + 0.048 * np.power(np.clip((yn - 0.30) / 0.70, 0.0, 1.0), 1.38)
    )
    r0 = w * (
        0.076
        - 0.008 * np.sin(np.pi * np.clip(yn / 0.52, 0.0, 1.0))
        + 0.018 * np.power(np.clip((yn - 0.36) / 0.64, 0.0, 1.0), 1.28)
    )
    return xc.astype(np.float32), r0.astype(np.float32)


def _inner_cyclone_axis_and_radius(h: int, w: int) -> Tuple[np.ndarray, np.ndarray]:
    """Seconde tornade d'eau géante INTÉRIEURE (`y = 0 .. h-1`, hors-cadre haut & bas comme `TCE1`) :
    séparée de la tornade externe par un chenal d'eau Metano sombre & cascades d'ailes, et plongeant
    en courbe S puissante jusqu'au bord Sud (`x ~ 0.306w`) juste au bord du chemin Sud→Nord !"""
    yn = np.linspace(0.0, 1.0, h, dtype=np.float32)
    xc = w * (
        0.184
        - 0.006 * np.sin(np.pi * np.clip(yn / 0.48, 0.0, 1.0))
        + 0.126 * np.power(np.clip((yn - 0.42) / 0.58, 0.0, 1.0), 1.44)
    )
    r0 = w * (
        0.054
        - 0.006 * np.sin(np.pi * np.clip(yn / 0.50, 0.0, 1.0))
        + 0.018 * np.power(np.clip((yn - 0.42) / 0.58, 0.0, 1.0), 1.30)
    )
    return xc.astype(np.float32), r0.astype(np.float32)


def _render_offscreen_water_cyclone_pose(
    w: int,
    h: int,
    xc: np.ndarray,
    r0: np.ndarray,
    omega: float,
    gusts: np.ndarray,
    mirror_right: bool,
    hooks_base: List[Tuple[float, float, float]],
) -> Tuple[np.ndarray, np.ndarray]:
    """Rend une colonne cyclonique d'eau géante `100 %` hors-cadre (`y = 0` jusqu'à `y = h - 1` inclus,
    zéro extrémité visible en haut ni en bas !) + ses crochets d'écume 3D Chunsoft en C."""
    yy_1d = np.arange(h, dtype=np.float32)
    yn_1d = yy_1d / max(float(h - 1), 1.0)

    jut_left = np.zeros(h, dtype=np.float32)
    jut_right = np.zeros(h, dtype=np.float32)
    phi_g = (gusts[:, 0] + omega) % (2.0 * np.pi)

    for g_idx in range(len(gusts)):
        ph_c = float(phi_g[g_idx])
        yn_c = float(gusts[g_idx, 1])
        h_arc = float(gusts[g_idx, 2])
        th_n = float(gusts[g_idx, 3])
        jut_a = float(gusts[g_idx, 6])
        for limb_phi, target_jut, mul_side in ((-0.5 * np.pi, jut_left, 0.85), (0.5 * np.pi, jut_right, 1.22)):
            dphi = abs(float(_wrap_pi(np.array(limb_phi - ph_c))))
            if dphi < h_arc:
                ang_w = np.cos(0.5 * np.pi * (dphi / h_arc)) ** 1.3
                yn_limb = yn_c + (r0 / max(float(h), 1.0)) * 0.66 * float(np.cos(limb_phi - 0.34))
                dy = (yn_1d - yn_limb) / th_n
                prof = np.exp(-0.5 * dy * dy) * (1.0 - 0.32 * np.clip(dy, -1.0, 1.0))
                np.maximum(target_jut, mul_side * jut_a * ang_w * prof, out=target_jut)

    x_left_edge = xc - r0 * (0.94 + jut_left)
    x_right_edge = xc + r0 * (0.95 + jut_right)
    half_span = np.maximum(8.0, 0.5 * (x_right_edge - x_left_edge))
    x_mid = 0.5 * (x_left_edge + x_right_edge)

    max_col = min(w, int(np.ceil(float(x_right_edge.max()))) + 4)
    xx_sub = np.arange(max_col, dtype=np.float32)[None, :]
    yn_sub = yn_1d[:, None]
    r0_norm_h = (r0 / max(float(h), 1.0))[:, None]

    u = (xx_sub - x_mid[:, None]) / half_span[:, None]
    # IMPORTANT : s'étend sur TOUTES les lignes y = 0 .. h-1 sans aucune coupure haute ni basse !
    inside = np.abs(u) <= 1.0
    u_clip = np.clip(u, -1.0, 1.0)
    phi_px = np.arcsin(u_clip)

    belly_drop = 0.66 * r0_norm_h * np.cos(phi_px - 0.34)
    yn_surface = yn_sub - belly_drop

    # Ombrage 3D cylindrique franc : bord externe bleu-nuit profond (sépare nettement les 2 tornades jumelles !)
    # et crêtes intérieures azur/écume vive tournées vers le chemin Sud→Nord !
    field = (
        0.30
        + 0.20 * u_clip
        - 0.06 * yn_sub
        + 0.06 * np.cos(phi_px - 0.45)
    ).astype(np.float32)

    for g_idx in range(len(gusts)):
        ph_c = float(phi_g[g_idx])
        yn_c = float(gusts[g_idx, 1])
        h_arc = float(gusts[g_idx, 2])
        th_n = float(gusts[g_idx, 3])
        tilt = float(gusts[g_idx, 4])
        tone_b = float(gusts[g_idx, 5])

        if abs(float(_wrap_pi(np.array(-ph_c)))) > (0.5 * np.pi + h_arc):
            continue
        dphi = _wrap_pi(phi_px - ph_c)
        in_arc = np.abs(dphi) < h_arc
        if not np.any(in_arc & inside):
            continue

        cos_w = np.maximum(0.0, np.cos(0.5 * np.pi * np.clip(np.abs(dphi) / h_arc, 0.0, 1.0)))
        w_phi = np.where(in_arc, np.power(cos_w, 1.15), 0.0)
        s_vert = (yn_surface - (yn_c + tilt * dphi)) / th_n
        in_band = in_arc & (s_vert > -1.35) & (s_vert < 1.65)
        if not np.any(in_band):
            continue

        crest = tone_b * np.exp(-2.1 * ((s_vert + 0.26) ** 2))
        shadow_under = -0.44 * np.exp(-2.8 * ((s_vert - 0.86) ** 2))
        field = np.clip(field + w_phi * (crest + shadow_under), 0.0, 1.0)

    # Ombre d'occlusion saphir-nuit sur le flanc gauche externe (`u_clip < -0.78`) pour détacher les 2 colonnes
    outer_rim_shade = np.clip((-0.74 - u_clip) / 0.26, 0.0, 1.0) * 0.26
    inner_rim_foam = np.clip((u_clip - 0.68) / 0.32, 0.0, 1.0) * 0.22
    field = np.clip(field - outer_rim_shade + inner_rim_foam * (field > 0.40), 0.0, 1.0)

    pal_idx = np.clip(
        np.rint(field * (len(WATER_TORNADO_PALETTE) - 1)).astype(np.int32),
        0,
        len(WATER_TORNADO_PALETTE) - 1,
    )
    sub_rgb = WATER_TORNADO_PALETTE[pal_idx]

    body = np.zeros((h, w, 4), dtype=np.uint8)
    sub_rgba = np.zeros((h, max_col, 4), dtype=np.uint8)
    sub_rgba[inside, :3] = sub_rgb[inside]
    sub_rgba[inside, 3] = 255
    if mirror_right:
        body[:, w - max_col :, :] = sub_rgba[:, ::-1, :]
    else:
        body[:, :max_col, :] = sub_rgba

    # Crochets d'écume en C Chunsoft (avec symétrie d'ordre 3 exacte `2*pi/3` pour raccord parfait sur 8 poses !)
    front_whips = np.zeros((h, w, 4), dtype=np.uint8)
    sy = h / float(H_CANON)
    n_pts = 48
    t_arc = np.linspace(0.0, 1.0, n_pts, dtype=np.float32)
    sector_step = (2.0 * np.pi) / 3.0

    for yn_mid, phi_seed, rise_px in hooks_base:
        for sec in range(3):
            phi0 = (phi_seed + sec * sector_step) % (2.0 * np.pi)
            vis_phase = _wrap_pi(np.array((phi0 + omega) - 1.15))
            vis = float(np.cos(np.clip(abs(float(vis_phase)) / 0.95, 0.0, 1.0) * 0.5 * np.pi))
            if vis <= 0.10:
                continue
            hook_kick = rise_px * sy * np.power(t_arc, 1.85)
            y_base = yn_mid * (h - 1)
            y_idx0 = int(np.clip(round(y_base), 0, h - 1))
            rc_mid = float(r0[y_idx0]) * (0.90 + 0.28 * vis * t_arc)

            py_f = y_base + 0.18 * rc_mid * (1.0 - t_arc) - hook_kick
            y_idx = np.clip(np.rint(py_f).astype(np.int32), 0, h - 1)
            px_f = x_right_edge[y_idx] - 2.0 * sy + r0[y_idx] * (0.28 * vis * np.sin(0.85 * np.pi * t_arc))
            if mirror_right:
                px_f = (w - 1.0) - px_f

            env = np.maximum(0.0, (1.0 - t_arc) ** 0.65 * np.minimum(1.0, t_arc * 5.0)) * vis
            half_w = (5.8 * sy) * env
            for i in range(n_pts):
                hw = float(half_w[i])
                if hw < 0.65:
                    continue
                cx_i = int(round(float(px_f[i])))
                cy_i = int(round(float(py_f[i])))
                if cy_i < 2 or cy_i >= h - 2:
                    continue
                ri = max(1, int(np.ceil(hw)))
                for dy in range(-ri, ri + 1):
                    for dx in range(-ri, ri + 1):
                        d2 = dx * dx + dy * dy
                        if d2 > (hw + 0.25) ** 2:
                            continue
                        yy_p, xx_p = cy_i + dy, cx_i + dx
                        if 0 <= yy_p < h and 0 <= xx_p < w:
                            if d2 <= (0.46 * hw) ** 2:
                                col = (255, 255, 255, 255)
                            elif d2 <= (0.78 * hw) ** 2:
                                col = (184, 244, 255, 255)
                            else:
                                col = (40, 168, 242, 255)
                            if front_whips[yy_p, xx_p, 3] == 0 or col[0] > front_whips[yy_p, xx_p, 0]:
                                front_whips[yy_p, xx_p] = col

    return body, front_whips


def build_colossal_sky_tower_water_tornado_layers(
    w: int,
    h: int,
    arena_mask: np.ndarray,
    n_frames: int = 8,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit les **4 tornades d'eau géantes hors-cadre façon *Sky Tower Entrance* (`TCE1`)** :
      - `outer_pair_frames` (`8 poses @ 5 ticks`) : Tornade Géante Gauche Externe + Droite Externe (`y = 0 .. h-1`),
      - `inner_pair_frames` (`8 poses @ 5 ticks`) : Tornade Géante Gauche Interne + Droite Interne (`y = 0 .. h-1`,
        encadrant de chaque côté le chemin Sud→Nord jusqu'au-delà de `y = 0` et `y = h-1` !),
      - `top_whips_and_spray_frames` (`8 poses @ 5 ticks`, calque `Top`) : crochets d'écume 3D en C + embruns.
    """
    xc_out, r0_out = _outer_cyclone_axis_and_radius(h, w)
    xc_in, r0_in = _inner_cyclone_axis_and_radius(h, w)

    gusts_l_out = _generate_3fold_gust_catalog(seed=5101)
    gusts_r_out = _generate_3fold_gust_catalog(seed=5102)
    gusts_l_in = _generate_3fold_gust_catalog(seed=5103)
    gusts_r_in = _generate_3fold_gust_catalog(seed=5104)

    hooks_outer = [(0.22, 0.45, 44.0), (0.50, 1.35, 60.0), (0.78, 0.85, 46.0)]
    hooks_inner = [(0.30, 1.05, 38.0), (0.62, 0.25, 52.0), (0.86, 1.65, 42.0)]

    rng = np.random.default_rng(5199)
    motes = [
        (
            float(rng.choice([rng.uniform(0.02 * w, 0.31 * w), rng.uniform(0.69 * w, 0.98 * w)])),
            float(rng.uniform(0.0, float(h))),
            int(rng.choice([1, 2])),
            bool(rng.integers(0, 2)),
        )
        for _ in range(44)
    ]

    outer_frames: List[Image.Image] = []
    inner_frames: List[Image.Image] = []
    top_frames: List[Image.Image] = []

    sector_period = (2.0 * np.pi) / 3.0
    for f in range(n_frames):
        omega = sector_period * (f / float(n_frames))
        omega_in = (omega + 0.52) % sector_period

        b_lo, w_lo = _render_offscreen_water_cyclone_pose(w, h, xc_out, r0_out, omega, gusts_l_out, False, hooks_outer)
        b_ro, w_ro = _render_offscreen_water_cyclone_pose(w, h, xc_out, r0_out, omega, gusts_r_out, True, hooks_outer)

        b_li, w_li = _render_offscreen_water_cyclone_pose(w, h, xc_in, r0_in, omega_in, gusts_l_in, False, hooks_inner)
        b_ri, w_ri = _render_offscreen_water_cyclone_pose(w, h, xc_in, r0_in, omega_in, gusts_r_in, True, hooks_inner)

        c_outer = b_lo.copy()
        m_ro = b_ro[:, :, 3] > 0
        c_outer[m_ro] = b_ro[m_ro]

        c_inner = b_li.copy()
        m_ri = b_ri[:, :, 3] > 0
        c_inner[m_ri] = b_ri[m_ri]

        c_top = np.zeros((h, w, 4), dtype=np.uint8)
        for wh in (w_lo, w_ro, w_li, w_ri):
            mw = wh[:, :, 3] > 0
            c_top[mw] = wh[mw]

        # Embruns d'eau souterraine ascendants le long des 4 cyclones géants (0 particule sur l'arène nue !)
        ang = (2.0 * np.pi * f) / float(n_frames)
        for mx, my, speed_k, is_bright in motes:
            py = int(round(my - (speed_k * (h // 3) * f) / float(n_frames))) % h
            px = int(round(mx + (5.0 * w / float(W_CANON)) * np.sin(ang + my * 0.04))) % w
            if arena_mask[py, px]:
                continue
            col = (255, 255, 255, 255) if is_bright else (132, 228, 254, 255)
            c_top[py, px] = col
            if is_bright and px + 1 < w and not arena_mask[py, px + 1]:
                c_top[py, px + 1] = (184, 244, 255, 255)

        c_top[arena_mask] = 0
        outer_frames.append(Image.fromarray(sanitize_rgba_binary(c_outer)))
        inner_frames.append(Image.fromarray(sanitize_rgba_binary(c_inner)))
        top_frames.append(Image.fromarray(sanitize_rgba_binary(c_top)))

    return outer_frames, inner_frames, top_frames


def build_h02p02w_light_shafts_top(
    w: int,
    h: int,
    canopy_top_rgba: np.ndarray | None,
    n_frames: int = 8,
    shaft_alpha: int = 34,
) -> List[Image.Image]:
    """Assemble sur la couche `09 Top` de `FAE1` les **5 faisceaux lumineux Chunsoft `H02P02W`**."""
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
