#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Moteur partagé multicalque PMDO `0.8.12.0` pour le quatuor **Kanto Mythique · Mewtwo & Mew** :

Quatre layouts **100 % originaux et distincts** directement ancrés dans les maps GBA `1×` de
*Pokémon Donjon Mystère : Équipe de Secours Rouge* (`pret/pmd-red`) :

1. **`MWE1` (`grotte_ouest_entree_v1`)** — *Grotte Ouest · Crique Marine Secrète (`0 %` ciel, `D20P01` + `H13P02`)* :
   - Promontoire côtier asymétrique en S d'ardoise et d'orgues basaltiques émergeant d'une crique marine
     ouverte (`#FF00FF` Sud-Ouest & Sud-Est -> **Eau Métano Abyssale** `4 poses @ 10 ticks`), grimpant
     jusqu'à la faille caverneuse Nord encadrée de colonnes stalagmitiques jade-cyan `H13P02` (`0` pont,
     `0` rivière horizontale).

2. **`MWA1` (`grotte_ouest_sanctuaire_v1`)** — *Grotte Ouest 99É · Gouffre Stalagmitique de Mewtwo (`H13P02`)* :
   - Fidèle au layout exact de `H13P02` (*Cryptic Cave*) : étroite arête rocheuse naturelle Sud→Nord
     suspendue entre **deux abîmes latéraux sans fond (`#FF00FF`)**, débouchant sur un **promontoire
     hexagonal nu en pierre gris-jade (`0` objet sur le sol de combat)** adossé au Nord à un mur d'orgues
     stalagmitiques couronnées de cristal cyan (`0` anneau circulaire, `0` douve).

3. **`RUE1` (`ruines_enfouies_entree_v1`)** — *Ruines Enfouies · Parvis en Double Escalier (`H22P01`)* :
   - Fidèle au layout exact de `H22P01` (*Ancient Relic*) : chaussée monumentale centrale surélevée en
     dalles carrées fissurées `3×3`, encadrée à gauche et à droite par **deux bassins sacrés rectangulaires
     encaissés (`#FF00FF` -> Eau Métano Sacrée `4 poses @ 10 ticks`)**, surmontés d'un **double escalier
     convergeant en diagonale** vers la terrasse aux 5 stèles hiéroglyphiques, le médaillon solaire et
     la porte engloutie Nord (`0 %` ciel).

4. **`RUA1` (`ruines_enfouies_sanctuaire_v1`)** — *Île Finale · Archipel Céleste Flottant de Mew (`H29P04`)* :
   - Fidèle au layout exact de `H29P04` (*Final Island*) : vaste horizon marin et céleste ouvert (`#FF00FF`
     sans aucun mur annulaire : ciel céruléen & nuages d'horizon **100 % fixes** au Nord + **Mer Métano
     Céleste** scintillante `4 poses @ 10 ticks` en contrebas), grande île flottante herbeuse centrale à
     rampe Sud moussue et sceau circulaire nu (`0` objet sur le sol de combat), entourée de **11 îlots
     flottants indépendants** en lévitation douce et des **bulles rosées translucides de Mew** (`Top`).
"""
from __future__ import annotations

import math
from functools import lru_cache
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

from source.assembleur_bruts_unova_1x import quantize_non_magenta_mediancut
from source.moteur_cyclones_cylindriques_unova import (
    BAYER_4X4,
    N_POSES,
    decode_pmdo_tile,
    palette_lookup_dithered,
    sanitize_rgba_binary,
)
from source.moteur_forets_pmd_red import (
    _sanitize_rgb_no_magenta,
    extract_metano_water_and_flower_assets,
)
from source.moteur_gba_pmd_red_natif import PURE_MAGENTA
from source.moteur_grotte_cyclopeenne_kyurem import _clean_and_downsample_magenta_sheet

REPO_ROOT = Path(__file__).resolve().parent.parent
W_CANON = 768
H_CANON = 576
TILE_SIZE = 8

# Palettes officielles dérivées des planches natives Metano_Town_River_Animation_1..4 + Sparkles
ABYSSAL_METANO_PAL: Dict[str, Tuple[int, int, int]] = {
    "surface": (24, 58, 96),       # Mer souterraine assombrie indigo-ardoise (Grotte Ouest)
    "bande": (14, 34, 64),         # Fosse sombre contre l'escarpement basaltique
    "inter": (32, 78, 122),        # Onde côtière Metano intermédiaire
    "accent": (58, 134, 176),      # Crête jade-cyan sous l'éclat des stalagmites H13P02
    "clair": (152, 224, 232),      # Écume fine bleu-jade de ressac côtier
    "spark_mid": (88, 186, 212),   # Scintillement intermédiaire Metano_Town_River_Sparkles
    "spark_hi": (218, 252, 246),   # Éclat cristallin H13P02 sur l'eau
}

SACRED_RELIC_METANO_PAL: Dict[str, Tuple[int, int, int]] = {
    "surface": (32, 108, 134),     # Eau sacrée saphir-émeraude des bassins de H22P01
    "bande": (18, 66, 92),         # Ombre des margelles de calcaire sculpté
    "inter": (44, 132, 156),       # Onde calme des bassins antiques
    "accent": (82, 178, 192),      # Reflet turquoise des lianes et stèles
    "clair": (188, 238, 228),      # Liseré clair contre la pierre ancienne
    "spark_mid": (124, 214, 218),  # Scintillement sacré Metano_Town_River_Sparkles
    "spark_hi": (244, 252, 226),   # Éclat doré-ivoire à la surface des bassins
}

CELESTIAL_SEA_METANO_PAL: Dict[str, Tuple[int, int, int]] = {
    "surface": (38, 136, 212),     # Océan ensoleillé de l'Île Finale H29P04 (base Metano Town)
    "bande": (26, 102, 178),       # Haut-fond marin sous l'ombre des îles flottantes
    "inter": (56, 158, 228),       # Onde marine lumineuse Metano
    "accent": (92, 188, 244),      # Reflet azur d'altitude
    "clair": (196, 238, 255),      # Frange claire marine
    "spark_mid": (146, 218, 252),  # Scintillement marin Metano_Town_River_Sparkles
    "spark_hi": (246, 254, 255),   # Éclat solaire sur la mer H29P04
}


# ============================================================================
# 1. MOTEUR D'EAU MÉTANO RE-PALETTISÉE (`4 poses @ 10 ticks`, 100 % natif Metano)
# ============================================================================

@lru_cache(maxsize=8)
def _load_repaletted_metano_families(pal_key: str) -> Dict[str, List[np.ndarray]]:
    pal_map = {
        "abyssal": ABYSSAL_METANO_PAL,
        "sacred": SACRED_RELIC_METANO_PAL,
        "celestial": CELESTIAL_SEA_METANO_PAL,
    }
    pal = pal_map[pal_key]
    eau_dir = REPO_ROOT / "source" / "eau_metano" / "natifs"
    sp_sheet = np.asarray(decode_pmdo_tile(eau_dir / "Metano_Town_River_Sparkles.tile"), dtype=np.uint8)
    m_surf = np.array([131, 218, 230], dtype=np.int32)

    def _extract_cluster(cols: List[int], rows: List[int], step: int) -> List[np.ndarray]:
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
            out[mid] = (*pal["spark_mid"], 255)
            out[hi] = (*pal["spark_hi"], 255)
            seq.append(out)
        return seq

    families: Dict[str, List[np.ndarray]] = {
        "A_16x24": _extract_cluster([0, 1], [0, 1, 2], 3),
        "B_24x16": _extract_cluster([2, 3, 4], [0, 1], 2),
        "C_16x32": _extract_cluster([0, 1], [12, 13, 14, 15], 4),
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
            darker = keep & (~brighter)
            out[darker] = (*pal["inter"], 255)
            out[brighter] = (*pal["accent"], 255)
            seq_r.append(out)
        families[tag] = seq_r

    return families


def build_themed_metano_water_layers(
    w: int,
    h: int,
    water_mask: np.ndarray,
    pal_key: str,
    occluder_mask: Optional[np.ndarray] = None,
    shore_foam: bool = True,
    seed: int = 27101,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit `(water_4_frames, sparkle_4_frames)` (`4 poses @ 10 ticks`) à partir des planches
    natives `Metano_Town_River_Animation_1..4.tile` et `Metano_Town_River_Sparkles.tile`."""
    pal_map = {
        "abyssal": ABYSSAL_METANO_PAL,
        "sacred": SACRED_RELIC_METANO_PAL,
        "celestial": CELESTIAL_SEA_METANO_PAL,
    }
    pal = pal_map[pal_key]
    visible_water = water_mask.copy()
    if occluder_mask is not None:
        visible_water = visible_water & (~occluder_mask)

    dist = ndimage.distance_transform_edt(water_mask)
    yy, xx = np.mgrid[:h, :w]
    jag = ndimage.gaussian_filter(np.random.default_rng(seed % 997).random((h, w)), 1.0)
    ptp = float(np.ptp(jag))
    jag = (jag - float(jag.min())) / (ptp if ptp > 1e-6 else 1.0)

    scale_band = max(0.65, min(1.15, w / float(W_CANON)))
    water_4_frames: List[Image.Image] = []
    for t in range(4):
        ph = 2.0 * math.pi * t / 4.0
        n_wave = 0.60 * np.sin(yy * 0.19 + xx * 0.08 - ph) + 0.40 * np.sin(yy * 0.07 - xx * 0.15 + 0.9 - ph)
        t_inner = (6.2 + 1.45 * n_wave) * scale_band
        jr = np.roll(jag, shift=t * 2, axis=0)
        fringe = t_inner + (1.8 + 4.0 * jr) * scale_band

        a = np.zeros((h, w, 4), dtype=np.uint8)
        a[visible_water] = (*pal["surface"], 255)

        if shore_foam:
            m_fringe = visible_water & (dist > 0.0) & (dist <= fringe)
            a[m_fringe] = (*pal["inter"], 255)
            m_accent = m_fringe & (jr > 0.52)
            a[m_accent] = (*pal["accent"], 255)
            m_t = visible_water & (dist > 0.0) & (dist <= t_inner)
            a[m_t] = (*pal["inter"], 255)
            m_bande = visible_water & (dist > 0.0) & (dist <= np.maximum(1.8, t_inner - 2.2 * scale_band))
            a[m_bande] = (*pal["bande"], 255)
            m_clair = visible_water & (dist > 0.0) & (dist <= 1.7) & (np.sin(xx * 0.24 + yy * 0.36 - ph) > -0.40)
            a[m_clair] = (*pal["clair"], 255)
        else:
            # Mer ouverte sous des îles flottantes (H29P04) : houle douce à 4 poses sans écume collée aux falaises aériennes
            shoal = (
                np.sin(xx * 0.022 + yy * 0.031 - 0.35 * math.sin(ph)) * 0.55
                + np.cos(xx * 0.017 - yy * 0.026 + 0.7 + 0.35 * math.cos(ph)) * 0.45
            )
            a[visible_water & (shoal > 0.42)] = (*pal["inter"], 255)
            a[visible_water & (shoal < -0.46)] = (*pal["bande"], 255)
            # Fine ligne d'horizon marine H29P04 (8 px + 10 px, jamais une bande épaisse)
            a[visible_water & (yy >= 152) & (yy < 162)] = (*pal["inter"], 255)
            a[visible_water & (yy < 152)] = (*pal["accent"], 255)

        water_4_frames.append(Image.fromarray(sanitize_rgba_binary(a)))

    fams = _load_repaletted_metano_families(pal_key)
    rng = np.random.default_rng(seed)
    erode_px = max(3, int(round(5 * scale_band)))
    safe_open = ndimage.binary_erosion(visible_water, iterations=erode_px)
    occupied = np.zeros((h, w), dtype=bool)
    placements: List[Tuple[str, int, int, int]] = []

    ys_open, xs_open = np.where(safe_open)
    if len(ys_open) > 0:
        order = rng.permutation(len(ys_open))
        fam_keys = ["A_16x24", "B_24x16", "C_16x32", "R1_8x32", "R2_8x32"]
        target_count = min(64, max(14, int(visible_water.sum()) // 1100))
        for idx in order:
            if len(placements) >= target_count:
                break
            cy, cx = int(ys_open[idx]), int(xs_open[idx])
            fk = fam_keys[len(placements) % len(fam_keys)]
            sh, sw = fams[fk][0].shape[:2]
            x0 = (cx // 8) * 8
            y0 = (cy // 8) * 8
            if x0 < 8 or y0 < 8 or x0 + sw >= w - 8 or y0 + sh >= h - 8:
                continue
            if not safe_open[y0 : y0 + sh, x0 : x0 + sw].all():
                continue
            pad_y0, pad_y1 = max(0, y0 - 12), min(h, y0 + sh + 12)
            pad_x0, pad_x1 = max(0, x0 - 12), min(w, x0 + sw + 12)
            if occupied[pad_y0:pad_y1, pad_x0:pad_x1].any():
                continue
            occupied[y0 : y0 + sh, x0 : x0 + sw] = True
            placements.append((fk, x0, y0, int(rng.integers(0, 4))))

    sparkle_4_frames: List[Image.Image] = []
    for t in range(4):
        sp_canvas = np.zeros((h, w, 4), dtype=np.uint8)
        for fk, x0, y0, ph0 in placements:
            patch = fams[fk][(t + ph0) % 4]
            sh, sw = patch.shape[:2]
            nz = (patch[:, :, 3] == 255) & visible_water[y0 : y0 + sh, x0 : x0 + sw]
            if np.any(nz):
                sub = sp_canvas[y0 : y0 + sh, x0 : x0 + sw]
                sub[nz] = patch[nz]
        sparkle_4_frames.append(Image.fromarray(sanitize_rgba_binary(sp_canvas)))

    return water_4_frames, sparkle_4_frames


# ============================================================================
# 2. ASSEMBLAGE DES 4 BRUTS QUANTIFIÉS `<= 92` COULEURS (`METHODE_MAGENTA`)
# ============================================================================

def _draw_4pt_star(canvas: np.ndarray, cx: int, cy: int, arm: int, core_rgba: Tuple[int, int, int, int], halo_rgba: Tuple[int, int, int, int]) -> None:
    """Dessine une étoile psychique à 4 branches fidèle au sprite natif de `H13P02` (*Cryptic Cave*)."""
    h, w = canvas.shape[:2]
    if not (arm + 2 <= cx < w - arm - 2 and arm + 2 <= cy < h - arm - 2):
        return
    for d in range(1, arm + 1):
        col = core_rgba if d == 1 else halo_rgba
        canvas[cy - d, cx] = col
        canvas[cy + d, cx] = col
        canvas[cy, cx - d] = col
        canvas[cy, cx + d] = col
    if arm >= 2:
        for dy_d, dx_d in ((-1, -1), (-1, 1), (1, -1), (1, 1)):
            canvas[cy + dy_d, cx + dx_d] = halo_rgba
    canvas[cy, cx] = core_rgba


def assemble_mwe1_brut(map_dir: Path) -> Dict[str, Path]:
    """Assemble le brut quantifié `768 × 576` (`0 %` ciel) de `MWE1` (Grotte Ouest — Crique Marine)."""
    raw_sheet = map_dir / "bruts" / "decor_grotte_ouest_entree_magenta.png"
    out_brut = map_dir / "bruts" / "base_grotte_ouest_entree.png"
    out_ref_canon = map_dir / "references" / "ref_canon_grotte_ouest_entree.png"

    rgb_768, solid_768 = _clean_and_downsample_magenta_sheet(raw_sheet, W_CANON, H_CANON)
    yy, _ = np.mgrid[0:H_CANON, 0:W_CANON]

    # Garantie stricte 0 % ciel en haut de la falaise maritime (y < 250)
    top_hole = (~solid_768) & (yy < 250)
    if np.any(top_hole):
        _, n_idx = ndimage.distance_transform_edt(~solid_768, return_indices=True)
        hy, hx = np.where(top_hole)
        rgb_768[hy, hx] = rgb_768[n_idx[0, hy, hx], n_idx[1, hy, hx]]
        solid_768[top_hole] = True

    quantized = quantize_non_magenta_mediancut(rgb_768, ~solid_768, n_colors=92)
    mag_final = (quantized[:, :, 0] == 255) & (quantized[:, :, 1] == 0) & (quantized[:, :, 2] == 255)
    solid_final = ~mag_final
    quantized[solid_final] = _sanitize_rgb_no_magenta(quantized, solid_final)[solid_final]
    quantized[mag_final] = PURE_MAGENTA

    ref_preview = quantized.copy()
    ref_preview[mag_final] = ABYSSAL_METANO_PAL["surface"]

    out_brut.parent.mkdir(parents=True, exist_ok=True)
    out_ref_canon.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(quantized, mode="RGB").save(out_brut)
    Image.fromarray(ref_preview, mode="RGB").save(out_ref_canon)
    return {"brut": out_brut, "ref_canon": out_ref_canon}


def assemble_mwa1_brut(map_dir: Path) -> Dict[str, Path]:
    """Assemble le brut quantifié `768 × 576` (`0 %` ciel) de `MWA1` (Gouffre Stalagmitique H13P02)."""
    raw_sheet = map_dir / "bruts" / "decor_grotte_ouest_sanctuaire_magenta.png"
    out_brut = map_dir / "bruts" / "base_grotte_ouest_sanctuaire.png"
    out_ref_canon = map_dir / "references" / "ref_canon_grotte_ouest_sanctuaire.png"

    rgb_768, solid_768 = _clean_and_downsample_magenta_sheet(raw_sheet, W_CANON, H_CANON)
    lbl_s, n_s = ndimage.label(solid_768)
    if n_s > 1:
        sizes_s = np.bincount(lbl_s.ravel())
        keep_s = sizes_s >= 48
        keep_s[0] = False
        solid_768 = keep_s[lbl_s]

    quantized = quantize_non_magenta_mediancut(rgb_768, ~solid_768, n_colors=92)
    mag_final = (quantized[:, :, 0] == 255) & (quantized[:, :, 1] == 0) & (quantized[:, :, 2] == 255)
    solid_final = ~mag_final
    quantized[solid_final] = _sanitize_rgb_no_magenta(quantized, solid_final)[solid_final]
    quantized[mag_final] = PURE_MAGENTA

    ref_preview = quantized.copy()
    ref_preview[mag_final] = (24, 28, 34)  # Fond noir-ardoise exact de H13P02 Cryptic Cave

    out_brut.parent.mkdir(parents=True, exist_ok=True)
    out_ref_canon.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(quantized, mode="RGB").save(out_brut)
    Image.fromarray(ref_preview, mode="RGB").save(out_ref_canon)
    return {"brut": out_brut, "ref_canon": out_ref_canon}


def assemble_rue1_brut(map_dir: Path) -> Dict[str, Path]:
    """Assemble le brut quantifié `768 × 576` (`0 %` ciel) de `RUE1` (Ziggourat H22P01 à 2 bassins)."""
    raw_sheet = map_dir / "bruts" / "decor_ruines_enfouies_entree_magenta.png"
    out_brut = map_dir / "bruts" / "base_ruines_enfouies_entree.png"
    out_vines_top = map_dir / "bruts" / "lianes_suspendues_top.png"
    out_ref_canon = map_dir / "references" / "ref_canon_ruines_enfouies_entree.png"

    rgb_768, solid_768 = _clean_and_downsample_magenta_sheet(raw_sheet, W_CANON, H_CANON)
    yy, xx = np.mgrid[0:H_CANON, 0:W_CANON]

    # Les 2 bassins #FF00FF doivent rester strictement dans leurs margelles (y >= 380)
    stray_hole = (~solid_768) & (yy < 380)
    if np.any(stray_hole):
        _, n_idx = ndimage.distance_transform_edt(~solid_768, return_indices=True)
        hy, hx = np.where(stray_hole)
        rgb_768[hy, hx] = rgb_768[n_idx[0, hy, hx], n_idx[1, hy, hx]]
        solid_768[stray_hole] = True

    quantized = quantize_non_magenta_mediancut(rgb_768, ~solid_768, n_colors=92)
    mag_final = (quantized[:, :, 0] == 255) & (quantized[:, :, 1] == 0) & (quantized[:, :, 2] == 255)
    solid_final = ~mag_final
    quantized[solid_final] = _sanitize_rgb_no_magenta(quantized, solid_final)[solid_final]
    quantized[mag_final] = PURE_MAGENTA

    # Extrait les frondes hautes des lianes tropicales suspendues (y < 230) pour le calque Top
    r_q = quantized[:, :, 0].astype(np.int16)
    g_q = quantized[:, :, 1].astype(np.int16)
    b_q = quantized[:, :, 2].astype(np.int16)
    is_vine = solid_final & (g_q >= r_q + 26) & (g_q >= b_q + 28) & (g_q >= 72)
    hanging_vines = ndimage.binary_opening(is_vine & (yy < 216) & (np.abs(xx - 384) > 36), iterations=1)
    vines_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
    vines_rgba[hanging_vines, :3] = quantized[hanging_vines]
    vines_rgba[hanging_vines, 3] = 255

    ref_preview = quantized.copy()
    ref_preview[mag_final] = SACRED_RELIC_METANO_PAL["surface"]

    out_brut.parent.mkdir(parents=True, exist_ok=True)
    out_ref_canon.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(quantized, mode="RGB").save(out_brut)
    Image.fromarray(vines_rgba, mode="RGBA").save(out_vines_top)
    Image.fromarray(ref_preview, mode="RGB").save(out_ref_canon)
    return {"brut": out_brut, "vines_top": out_vines_top, "ref_canon": out_ref_canon}


def assemble_rua1_brut(map_dir: Path) -> Dict[str, Path]:
    """Assemble le brut quantifié `768 × 576` de `RUA1` (Archipel Céleste H29P04 de Mew)."""
    raw_sheet = map_dir / "bruts" / "decor_ruines_enfouies_sanctuaire_magenta.png"
    out_brut = map_dir / "bruts" / "base_ruines_enfouies_sanctuaire.png"
    out_ref_canon = map_dir / "references" / "ref_canon_ruines_enfouies_sanctuaire.png"

    rgb_768, solid_768 = _clean_and_downsample_magenta_sheet(raw_sheet, W_CANON, H_CANON)
    lbl_s, n_s = ndimage.label(solid_768)
    if n_s > 1:
        sizes_s = np.bincount(lbl_s.ravel())
        keep_s = sizes_s >= 120
        keep_s[0] = False
        solid_768 = keep_s[lbl_s]

    quantized = quantize_non_magenta_mediancut(rgb_768, ~solid_768, n_colors=92)
    mag_final = (quantized[:, :, 0] == 255) & (quantized[:, :, 1] == 0) & (quantized[:, :, 2] == 255)
    solid_final = ~mag_final
    quantized[solid_final] = _sanitize_rgb_no_magenta(quantized, solid_final)[solid_final]
    quantized[mag_final] = PURE_MAGENTA

    # Aperçu canonique combinant ciel H29P04 (y < 144) et mer Metano céleste (y >= 144)
    sky_horizon = np.asarray(build_final_island_static_sky_horizon(W_CANON, H_CANON), dtype=np.uint8)[:, :, :3]
    ref_preview = quantized.copy()
    yy, _ = np.mgrid[0:H_CANON, 0:W_CANON]
    sky_band = mag_final & (yy < 144)
    sea_band = mag_final & (yy >= 144)
    ref_preview[sky_band] = sky_horizon[sky_band]
    ref_preview[sea_band] = CELESTIAL_SEA_METANO_PAL["surface"]

    out_brut.parent.mkdir(parents=True, exist_ok=True)
    out_ref_canon.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(quantized, mode="RGB").save(out_brut)
    Image.fromarray(ref_preview, mode="RGB").save(out_ref_canon)
    return {"brut": out_brut, "ref_canon": out_ref_canon}


# ============================================================================
# 3. ANIMATIONS DÉDIÉES : MWE1, MWA1, RUE1, RUA1
# ============================================================================

def build_mwe1_psychic_crystals_and_mist_top(
    rgb_nat: np.ndarray,
    solid_nat: np.ndarray,
    water_mask: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit `(08_cristaux_psy_et_ondes, 09_etoiles_h13p02_et_embruns_top)` (`24 poses @ 5t`) pour `MWE1`."""
    yy, xx = np.mgrid[0:H_CANON, 0:W_CANON]
    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Facettes supérieures bleu-jade des colonnes stalagmitiques H13P02
    jade_caps = solid_nat & (g_c >= 176) & (b_c >= 158) & ((g_c - r_c) >= 16)
    # Surplomb rocheux supérieur encadrant la bouche de la Grotte Ouest (Top)
    cave_arch_overhang = solid_nat & (yy < 126) & (xx >= 224) & (xx <= 356) & (r_c >= 34)

    # Étoiles psychiques à 4 branches fidèles à H13P02 autour de la faille et des orgues côtières
    star_sites = [
        (206, 98, 0, 3),
        (366, 128, 1, 2),
        (524, 152, 2, 2),
        (694, 214, 3, 2),
        (76, 256, 1, 2),
        (518, 318, 0, 2),
        (264, 468, 2, 2),
        (438, 496, 3, 2),
    ]

    # Embruns côtiers légers au pied des falaises battues par la mer (dans water_mask près du rivage)
    shore_band = water_mask & (~ndimage.binary_erosion(water_mask, iterations=10))

    lay8: List[Image.Image] = []
    top9: List[Image.Image] = []

    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)
        pulse = 0.5 + 0.5 * math.sin(theta)

        arr8 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        glow_rgb = rgb_nat.astype(np.float32)
        glow_rgb[jade_caps, 0] = np.clip(glow_rgb[jade_caps, 0] + 18.0 * pulse, 0.0, 224.0)
        glow_rgb[jade_caps, 1] = np.clip(glow_rgb[jade_caps, 1] + 34.0 * pulse, 0.0, 255.0)
        glow_rgb[jade_caps, 2] = np.clip(glow_rgb[jade_caps, 2] + 30.0 * pulse, 0.0, 248.0)
        glow_u8 = _sanitize_rgb_no_magenta((np.round(glow_rgb / 4.0) * 4.0).clip(0, 255).astype(np.uint8), jade_caps)
        arr8[jade_caps, :3] = glow_u8[jade_caps]
        arr8[jade_caps, 3] = 255

        # Ondes télékinétiques concentriques discrètes à la surface de la crique
        ripple_wave = np.sin(0.08 * xx + 0.11 * yy - 2.0 * theta)
        spray = shore_band & (ripple_wave > 0.88) & (((xx + yy + f) % 5) == 0)
        arr8[spray] = (138, 222, 228, 255)
        lay8.append(Image.fromarray(sanitize_rgba_binary(arr8), mode="RGBA"))

        arr9 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        arr9[cave_arch_overhang, :3] = rgb_nat[cave_arch_overhang]
        arr9[cave_arch_overhang, 3] = 255

        for sx, sy, ph_s, arm_max in star_sites:
            dy_float = int(round(2.0 * math.sin(theta + ph_s * 1.4)))
            tw = math.sin(2.0 * theta + ph_s * 1.7)
            arm = arm_max if tw > 0.15 else max(1, arm_max - 1)
            if tw > -0.55:
                _draw_4pt_star(
                    arr9,
                    sx,
                    sy + dy_float,
                    arm,
                    (238, 255, 250, 255),
                    (104, 224, 214, 255),
                )
        top9.append(Image.fromarray(sanitize_rgba_binary(arr9), mode="RGBA"))

    return lay8, top9


def build_mwa1_cryptic_chasm_layers(
    rgb_nat: np.ndarray,
    solid_nat: np.ndarray,
    chasm_mask: np.ndarray,
    walk_safe_mask: np.ndarray,
) -> Dict[str, List[Image.Image]]:
    """Construit l'abîme psychique de `H13P02` (*Cryptic Cave*) autour de l'éperon rocheux de Mewtwo :
      - `00_gouffre_cryptic_cave` (`BG`, 24p) : abîme noir-ardoise `#181c22` de `H13P02` + brumes psy profondes,
      - `01_courants_telekinetiques` (`BG`, 24p) : courants ascendants jade/indigo dans les deux gouffres latéraux,
      - `02_ondes_abime_profond` (`BG`, 4p) : pulsation grave de résonance au fond des failles (`4 × 10t`),
      - `03_eclats_cristallins_abime` (`BG`, 4p) : reflets lointains au fond du gouffre (`4 × 10t`),
      - `08_levitation_roches_et_facettes` (`BG`, 24p) : fragments rocheux en lévitation + facettes jade-cyan H13P02,
      - `09_etoiles_psychiques_h13p02_top` (`Top`, 24p) : étoiles à 4 branches `H13P02` & voile télékinétique avant.
    """
    yy, xx = np.mgrid[0:H_CANON, 0:W_CANON]
    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Inclut aussi les poches sombres de fond de caverne (< 30) entre les stalactites hautes G/D
    deep_dark_pockets = solid_nat & (r_c <= 28) & (g_c <= 30) & (b_c <= 36) & (np.abs(xx - 384) >= 136)
    void_zone = chasm_mask | deep_dark_pockets

    # Facettes de cristal bleu-jade sur l'orgue de stalagmites (hors plateau de combat !)
    arena_guard = ndimage.binary_dilation(walk_safe_mask, iterations=4)
    jade_crowns = solid_nat & (~arena_guard) & (g_c >= 182) & (b_c >= 165) & ((g_c - r_c) >= 18)

    gw, gh = W_CANON // 2, H_CANON // 2
    gy, gx = np.mgrid[0:gh, 0:gw].astype(np.float32)
    bayer_g = BAYER_4X4[np.arange(gh)[:, None] % 4, np.arange(gw)[None, :] % 4]
    void_g = void_zone[::2, ::2]
    void_atten_g = np.clip(ndimage.distance_transform_edt(void_g) / 16.0, 0.0, 1.0).astype(np.float32)

    pal_chasm = [
        (20, 24, 30),   # Noir-ardoise exact H13P02
        (24, 30, 40),
        (30, 42, 58),
        (38, 62, 82),
        (52, 92, 112),
    ]
    pal_stream = [
        (28, 44, 64),
        (42, 78, 102),
        (66, 126, 148),
        (106, 184, 192),
        (174, 236, 226),
    ]

    # 4 poses @ 10 ticks : lueur profonde d'écho psychique dans le gouffre
    echo_4: List[Image.Image] = []
    glint_4: List[Image.Image] = []
    rng_g = np.random.default_rng(150)
    deep_pts = [
        (int(x), int(y), int(p))
        for x, y, p in zip(
            rng_g.integers(96, W_CANON - 96, size=80),
            rng_g.integers(190, H_CANON - 24, size=80),
            rng_g.integers(0, 4, size=80),
        )
        if chasm_mask[y, x] and abs(x - 384) > 88
    ][:28]

    inner_chasm = ndimage.binary_erosion(chasm_mask, iterations=22)
    for t4 in range(4):
        ph4 = 2.0 * math.pi * t4 / 4.0
        a_echo = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        w4 = np.sin(yy * 0.035 + np.abs(xx - 384) * 0.025 - ph4)
        band_m = inner_chasm & (w4 > 0.62) & (((xx // 2 + yy // 2) % 2) == 0)
        a_echo[band_m] = (30, 52, 68, 255)
        echo_4.append(Image.fromarray(sanitize_rgba_binary(a_echo), mode="RGBA"))

        a_gl = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        for gx0, gy0, gp0 in deep_pts:
            st = (t4 + gp0) % 4
            if st in (0, 2):
                a_gl[gy0, gx0] = (142, 224, 216, 255)
                if st == 0:
                    for dy_i, dx_i in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        if chasm_mask[gy0 + dy_i, gx0 + dx_i]:
                            a_gl[gy0 + dy_i, gx0 + dx_i] = (58, 128, 142, 255)
        glint_4.append(Image.fromarray(sanitize_rgba_binary(a_gl), mode="RGBA"))

    # Fragments rocheux en lévitation dans les deux abîmes latéraux
    pebbles = [
        (178, 312, 0, 5),
        (228, 396, 1, 4),
        (268, 256, 2, 4),
        (590, 308, 2, 5),
        (536, 392, 3, 4),
        (498, 258, 1, 4),
        (206, 474, 3, 5),
        (562, 472, 0, 5),
    ]
    # Étoiles à 4 branches exactes de H13P02 Cryptic Cave
    cryptic_stars = [
        (182, 118, 0, 4),
        (586, 112, 2, 4),
        (214, 228, 1, 3),
        (554, 236, 3, 3),
        (194, 344, 2, 3),
        (572, 352, 0, 3),
        (294, 428, 1, 2),
        (476, 422, 3, 2),
        (152, 286, 0, 2),
        (618, 290, 2, 2),
    ]

    l0_list: List[Image.Image] = []
    l1_list: List[Image.Image] = []
    l8_list: List[Image.Image] = []
    l9_list: List[Image.Image] = []

    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)
        pulse = 0.5 + 0.5 * math.sin(theta)

        # 00 : Gouffre noir-ardoise H13P02 + nappe abyssale ascendante atténuée aux parois (0 couture !)
        wave0 = void_atten_g * (
            0.35
            + 0.30 * np.sin(gy * 0.045 + theta + 0.025 * np.abs(gx - 192.0))
            + 0.20 * np.cos(gx * 0.040 - 2.0 * theta)
        )
        rgb0_g = np.empty((gh, gw, 3), dtype=np.uint8)
        rgb0_g[:] = (20, 24, 30)
        chasm_rgb_g = palette_lookup_dithered(np.clip(wave0, 0.0, 1.0), pal_chasm, bayer_g, dither_strength=0.45)
        rgb0_g[void_g] = chasm_rgb_g[void_g]

        l0_rgba = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        l0_rgba[:, :, :3] = np.repeat(np.repeat(rgb0_g, 2, axis=0), 2, axis=1)
        l0_rgba[:, :, 3] = 255
        l0_list.append(Image.fromarray(sanitize_rgba_binary(l0_rgba), mode="RGBA"))

        # 01 : Courants télékinétiques jade-cyan ascendants dans les 2 failles latérales (#FF00FF)
        stream_val = void_atten_g * (
            np.sin(gx * 0.075 + gy * 0.055 + 2.0 * theta) + 0.45 * np.cos(gx * 0.045 - gy * 0.085 - theta)
        )
        stream_mask_g = void_g & ((stream_val + bayer_g * 0.22) > 0.96)
        s_rgb_g = palette_lookup_dithered(
            np.clip((stream_val - 0.75) * 1.4, 0.0, 1.0), pal_stream, bayer_g, dither_strength=0.45
        )
        l1_g = np.zeros((gh, gw, 4), dtype=np.uint8)
        l1_g[stream_mask_g, :3] = s_rgb_g[stream_mask_g]
        l1_g[stream_mask_g, 3] = 255
        l1_rgba = np.repeat(np.repeat(l1_g, 2, axis=0), 2, axis=1)
        l1_rgba[~chasm_mask] = 0
        l1_list.append(Image.fromarray(sanitize_rgba_binary(l1_rgba), mode="RGBA"))

        # 08 : Fragments de roche en lévitation + pulsation des couronnes de cristal jade H13P02
        arr8 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        glow_rgb = rgb_nat.astype(np.float32)
        glow_rgb[jade_crowns, 0] = np.clip(glow_rgb[jade_crowns, 0] + 16.0 * pulse, 0.0, 228.0)
        glow_rgb[jade_crowns, 1] = np.clip(glow_rgb[jade_crowns, 1] + 32.0 * pulse, 0.0, 255.0)
        glow_rgb[jade_crowns, 2] = np.clip(glow_rgb[jade_crowns, 2] + 28.0 * pulse, 0.0, 248.0)
        glow_u8 = _sanitize_rgb_no_magenta((np.round(glow_rgb / 4.0) * 4.0).clip(0, 255).astype(np.uint8), jade_crowns)
        arr8[jade_crowns, :3] = glow_u8[jade_crowns]
        arr8[jade_crowns, 3] = 255

        for px0, py0, ph_p, rad in pebbles:
            py_cur = py0 + int(round(6.0 * math.sin(theta + ph_p * 1.5)))
            px_cur = px0 + int(round(2.0 * math.cos(theta + ph_p * 1.1)))
            for dy_r in range(-rad, rad + 1):
                for dx_r in range(-rad + 1, rad):
                    if abs(dx_r) + abs(dy_r) <= rad + 1:
                        yy_p, xx_p = py_cur + dy_r, px_cur + dx_r
                        if 4 <= yy_p < H_CANON - 4 and 4 <= xx_p < W_CANON - 4 and chasm_mask[yy_p, xx_p]:
                            if dy_r <= -rad + 1:
                                arr8[yy_p, xx_p] = (158, 222, 206, 255)  # Sommet jade H13P02
                            elif dx_r < 0:
                                arr8[yy_p, xx_p] = (102, 114, 108, 255)
                            else:
                                arr8[yy_p, xx_p] = (54, 62, 68, 255)
        l8_list.append(Image.fromarray(sanitize_rgba_binary(arr8), mode="RGBA"))

        # 09 Top : Étoiles psychiques à 4 branches H13P02 flottant au-dessus du gouffre (hors arène !)
        arr9 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        for sx, sy, ph_s, arm_max in cryptic_stars:
            dy_f = int(round(3.0 * math.sin(theta + ph_s * 1.5)))
            tw = math.sin(2.0 * theta + ph_s * 1.6)
            if tw > -0.50:
                arm = arm_max if tw > 0.20 else max(1, arm_max - 1)
                _draw_4pt_star(
                    arr9,
                    sx,
                    sy + dy_f,
                    arm,
                    (242, 255, 250, 255),
                    (112, 228, 212, 255),
                )
        arr9[arena_guard] = 0
        l9_list.append(Image.fromarray(sanitize_rgba_binary(arr9), mode="RGBA"))

    return {
        "00_gouffre_cryptic_cave": l0_list,
        "01_courants_telekinetiques": l1_list,
        "02_ondes_abime_profond": echo_4,
        "03_eclats_cristallins_abime": glint_4,
        "08_levitation_roches_et_facettes": l8_list,
        "09_etoiles_psychiques_h13p02_top": l9_list,
    }


def _tint_metano_flowers_to_relic(frames_4: List[np.ndarray]) -> List[np.ndarray]:
    """Adapte les fleurs natives de `Metano_Town_Animation_Tileset.tile` à la palette dorée/émeraude
    des Ruines Enfouies (`H22P01`) et de l'Île Finale (`H29P04`)."""
    out: List[np.ndarray] = []
    for sp in frames_4:
        arr = sp.copy()
        op = arr[:, :, 3] == 255
        arr[op, :3] = _sanitize_rgb_no_magenta(arr[:, :, :3], op)[op]
        out.append(sanitize_rgba_binary(arr))
    return out


def _draw_mew_bubble(canvas: np.ndarray, cx: int, cy: int, radius: int) -> None:
    """Dessine une bulle psychique nacrée rose-ivoire de Mew (contour fin + reflet blanc, centre clair/creux)."""
    h, w = canvas.shape[:2]
    if not (radius + 2 <= cx < w - radius - 2 and radius + 2 <= cy < h - radius - 2):
        return
    for dy_b in range(-radius, radius + 1):
        for dx_b in range(-radius, radius + 1):
            d2 = dx_b * dx_b + dy_b * dy_b
            r_in2 = max(1, (radius - 1) * (radius - 1))
            r_out2 = radius * radius + radius
            if r_in2 <= d2 <= r_out2:
                # Sans aucun magenta (G maintenu élevé : rose pêche nacré & or pâle)
                if dy_b < 0 and dx_b < 0:
                    canvas[cy + dy_b, cx + dx_b] = (255, 246, 238, 255)
                else:
                    canvas[cy + dy_b, cx + dx_b] = (246, 188, 198, 255)
    if radius >= 3:
        canvas[cy - radius + 1, cx - max(1, radius // 2)] = (255, 255, 252, 255)


def build_rue1_glyphs_flowers_and_canopy_top(
    rgb_nat: np.ndarray,
    solid_nat: np.ndarray,
    vines_top_nat: np.ndarray,
    plaza_walk_mask: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit `(08_glyphes_ancestraux_et_fleurs, 09_lianes_et_pollen_mew_top)` (`24 poses @ 5t`) pour `RUE1`."""
    yy, xx = np.mgrid[0:H_CANON, 0:W_CANON]
    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    # Les 5 stèles hiéroglyphiques centrales (y=260..324, x=284..484) + le médaillon solaire Nord (y=8..92, x=336..432)
    in_steles = solid_nat & (yy >= 262) & (yy <= 322) & (xx >= 288) & (xx <= 480)
    in_sun_disc = solid_nat & (yy >= 8) & (yy <= 90) & (np.hypot(xx - 384, yy - 48) <= 42)
    glyph_grooves = (in_steles | in_sun_disc) & (r_c >= 88) & (r_c <= 148) & (g_c >= 96) & (g_c <= 158)

    # Fleurs sacrées natives Metano_Town_Animation_Tileset.tile sur les terrasses moussues latérales
    assets = extract_metano_water_and_flower_assets()
    fl_wht_4 = _tint_metano_flowers_to_relic(assets["metano_flowers_white_4"])  # type: ignore[arg-type]
    fl_col_4 = _tint_metano_flowers_to_relic(assets["metano_flowers_color_4"])  # type: ignore[arg-type]

    flower_sites = [
        (156, 218, "white", 0),
        (596, 218, "white", 2),
        (216, 224, "color", 1),
        (536, 224, "color", 3),
        (256, 362, "white", 2),
        (496, 362, "white", 0),
    ]

    # Particules dorées de pollen antique & petites bulles nacrées de Mew dérivant sous les lianes
    motes = [
        (184, 156, 0, "bubble"),
        (584, 152, 2, "bubble"),
        (308, 128, 1, "gold"),
        (460, 128, 3, "gold"),
        (146, 442, 1, "bubble"),
        (622, 442, 3, "bubble"),
        (232, 286, 0, "gold"),
        (536, 286, 2, "gold"),
    ]

    v_op = vines_top_nat[:, :, 3] >= 128
    lay8: List[Image.Image] = []
    top9: List[Image.Image] = []

    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)
        fl_phase = (f // 2) % 4
        pulse = 0.5 + 0.5 * math.sin(theta)

        arr8 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        glow = rgb_nat.astype(np.float32)
        # Illumination dorée-ambrée douce des hiéroglyphes de H22P01
        glow[glyph_grooves, 0] = np.clip(glow[glyph_grooves, 0] + 54.0 * pulse, 0.0, 248.0)
        glow[glyph_grooves, 1] = np.clip(glow[glyph_grooves, 1] + 48.0 * pulse, 0.0, 238.0)
        glow[glyph_grooves, 2] = np.clip(glow[glyph_grooves, 2] + 14.0 * pulse, 0.0, 184.0)
        glow_u8 = _sanitize_rgb_no_magenta((np.round(glow / 4.0) * 4.0).clip(0, 255).astype(np.uint8), glyph_grooves)
        arr8[glyph_grooves, :3] = glow_u8[glyph_grooves]
        arr8[glyph_grooves, 3] = 255

        for sx, sy, kind, ph0 in flower_sites:
            patch = (fl_wht_4 if kind == "white" else fl_col_4)[(fl_phase + ph0) % 4]
            ph_h, ph_w = patch.shape[:2]
            if not plaza_walk_mask[sy : sy + ph_h, sx : sx + ph_w].any():
                nz = patch[:, :, 3] == 255
                sub = arr8[sy : sy + ph_h, sx : sx + ph_w]
                sub[nz] = patch[nz]
            else:
                nz = patch[:, :, 3] == 255
                sub = arr8[sy : sy + ph_h, sx : sx + ph_w]
                sub[nz] = patch[nz]

        lay8.append(Image.fromarray(sanitize_rgba_binary(arr8), mode="RGBA"))

        arr9 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        arr9[v_op] = vines_top_nat[v_op]

        for mx0, my0, ph_m, kind_m in motes:
            ang_m = theta + ph_m * (math.pi * 0.5)
            mx = int(round(mx0 + 5.0 * math.sin(ang_m)))
            my = int(round(my0 - 6.0 * ((f + ph_m * 6) % N_POSES) / float(N_POSES) + 3.0))
            if kind_m == "bubble":
                _draw_mew_bubble(arr9, mx, my, radius=3)
            else:
                if 4 <= mx < W_CANON - 4 and 4 <= my < H_CANON - 4:
                    arr9[my, mx] = (255, 244, 178, 255)
                    if math.sin(2.0 * theta + ph_m) > 0.15:
                        for dy_g, dx_g in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                            arr9[my + dy_g, mx + dx_g] = (232, 198, 108, 255)

        top9.append(Image.fromarray(sanitize_rgba_binary(arr9), mode="RGBA"))

    return lay8, top9


def build_final_island_static_sky_horizon(w: int = W_CANON, h: int = H_CANON) -> Image.Image:
    """Construit le fond céleste **100 % statique (`1 pose`)** fidèle à `H29P04` (*Final Island*) :
    ciel bleu céruléen dégradé par paliers GBA (`y = 0..144`), banc de cumulus blancs immobiles
    à l'horizon (`y = 92..144`), et assise marine de sécurité en dessous (`y >= 144`)."""
    yy, xx = np.mgrid[0:h, 0:w]
    arr = np.zeros((h, w, 4), dtype=np.uint8)
    arr[:, :, 3] = 255

    # Paliers de ciel exacts inspirés de H29P04 Final Island
    arr[yy < 36, :3] = (0, 124, 240)
    arr[(yy >= 36) & (yy < 76), :3] = (12, 148, 248)
    arr[(yy >= 76) & (yy < 116), :3] = (36, 172, 252)
    arr[(yy >= 116) & (yy < 144), :3] = (72, 196, 255)

    # Banc de cumulus blancs d'horizon 100 % statiques (comme dans H29P04, zéro mouvement des nuages !)
    cloud_crest = (
        118.0
        - 14.0 * np.exp(-((xx - 64.0) / 54.0) ** 2)
        - 10.0 * np.exp(-((xx - 152.0) / 42.0) ** 2)
        - 16.0 * np.exp(-((xx - 696.0) / 56.0) ** 2)
        - 11.0 * np.exp(-((xx - 608.0) / 44.0) ** 2)
        - 6.0 * np.cos(xx * 0.055)
    )
    in_cloud = (yy >= cloud_crest) & (yy < 144)
    in_cloud_shadow = (yy >= np.maximum(cloud_crest + 12.0, 132.0)) & (yy < 144)
    arr[in_cloud, :3] = (246, 252, 255)
    arr[in_cloud_shadow, :3] = (198, 228, 252)

    # Ligne d'horizon marine claire + assise marine de sécurité (recouverte par 02_mer_metano_celeste)
    arr[(yy >= 144) & (yy < 154), :3] = (116, 208, 252)
    arr[yy >= 154, :3] = CELESTIAL_SEA_METANO_PAL["surface"]
    return Image.fromarray(sanitize_rgba_binary(arr), mode="RGBA")


def build_rua1_floating_islets_flowers_and_mew_bubbles(
    rgb_nat: np.ndarray,
    islets_comp_labels: np.ndarray,
    num_islets: int,
    meadow_ring_mask: np.ndarray,
    seal_ring_mask: np.ndarray,
    arena_center_clear: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit pour `RUA1` (*Final Island* de Mew) :
      - `01_ilots_flottants_h29p04` (`BG`, 24p) : les îlots herbeux périphériques de `H29P04` en lévitation douce,
      - `08_fleurs_metano_et_sceau` (`BG`, 24p) : fleurs natives Metano sur la couronne d'herbe + halo nacré du sceau,
      - `09_bulles_mew_et_lumiere_top` (`Top`, 24p) : bulles psychiques rose-perle de Mew & éclats solaires Top.
    """
    assets = extract_metano_water_and_flower_assets()
    fl_wht_4 = _tint_metano_flowers_to_relic(assets["metano_flowers_white_4"])  # type: ignore[arg-type]
    fl_col_4 = _tint_metano_flowers_to_relic(assets["metano_flowers_color_4"])  # type: ignore[arg-type]

    fh, fw = fl_wht_4[0].shape[:2]
    dist_meadow = ndimage.distance_transform_edt(meadow_ring_mask)
    taken = np.zeros((H_CANON, W_CANON), dtype=bool)
    flower_sites: List[Tuple[int, int, str, int]] = []
    rng = np.random.default_rng(151)
    cands = [(sy, sx) for sy in range(72, 356, 12) for sx in range(192, 576, 12)]
    rng.shuffle(cands)
    for sy, sx in cands:
        # Laisse le sceau central et l'axe Sud->Nord totalement dégagés
        if math.hypot((sx + fw // 2) - 384, (sy + fh // 2) - 208) < 106:
            continue
        if abs((sx + fw // 2) - 384) < 38 and sy > 260:
            continue
        if dist_meadow[sy : sy + fh, sx : sx + fw].min() >= 6.0 and not taken[
            max(0, sy - 22) : sy + fh + 22, max(0, sx - 22) : sx + fw + 22
        ].any():
            taken[sy : sy + fh, sx : sx + fw] = True
            kind = "white" if (len(flower_sites) % 2 == 0) else "color"
            flower_sites.append((sx, sy, kind, len(flower_sites) % 4))
            if len(flower_sites) >= 8:
                break

    # Pré-découpe chaque îlot périphérique (cid >= 2) pour une lévitation entière nette sans flou
    islet_patches: List[Tuple[int, int, np.ndarray, int]] = []
    for cid in range(2, num_islets + 1):
        comp = islets_comp_labels == cid
        if int(comp.sum()) < 80:
            continue
        ys, xs = np.where(comp)
        y0, y1 = int(ys.min()), int(ys.max()) + 1
        x0, x1 = int(xs.min()), int(xs.max()) + 1
        patch = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
        sub_m = comp[y0:y1, x0:x1]
        patch[sub_m, :3] = rgb_nat[y0:y1, x0:x1][sub_m]
        patch[sub_m, 3] = 255
        islet_patches.append((x0, y0, patch, cid))

    bubble_anchors = [
        (118, 224, 0, 4),
        (652, 238, 1, 4),
        (178, 356, 2, 3),
        (592, 352, 3, 3),
        (86, 398, 1, 3),
        (684, 396, 2, 3),
        (248, 92, 0, 3),
        (522, 92, 2, 3),
        (304, 488, 3, 3),
        (464, 488, 1, 3),
    ]

    islets_24: List[Image.Image] = []
    lay8_24: List[Image.Image] = []
    top9_24: List[Image.Image] = []

    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)
        fl_phase = (f // 2) % 4
        pulse = 0.5 + 0.5 * math.sin(theta)

        # 01 : Lévitation harmonique douce (±3 px) des îlots flottants périphériques de H29P04
        arr_isl = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        for x0, y0, patch, cid in islet_patches:
            dy = int(round(3.0 * math.sin(theta + cid * 0.85)))
            ph_h, ph_w = patch.shape[:2]
            ny0 = y0 + dy
            sy_src0 = max(0, -ny0)
            sy_dst0 = max(0, ny0)
            copy_h = min(ph_h - sy_src0, H_CANON - sy_dst0)
            if copy_h > 0:
                src_slice = patch[sy_src0 : sy_src0 + copy_h]
                nz = src_slice[:, :, 3] == 255
                dst_slice = arr_isl[sy_dst0 : sy_dst0 + copy_h, x0 : x0 + ph_w]
                dst_slice[nz] = src_slice[nz]
        islets_24.append(Image.fromarray(sanitize_rgba_binary(arr_isl), mode="RGBA"))

        # 08 : Anneau nacré du sceau ancestral + fleurs natives Metano sur la prairie flottante
        arr8 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        glow = rgb_nat.astype(np.float32)
        glow[seal_ring_mask, 0] = np.clip(glow[seal_ring_mask, 0] + 34.0 * pulse, 0.0, 252.0)
        glow[seal_ring_mask, 1] = np.clip(glow[seal_ring_mask, 1] + 28.0 * pulse, 0.0, 248.0)
        glow[seal_ring_mask, 2] = np.clip(glow[seal_ring_mask, 2] + 26.0 * pulse, 0.0, 252.0)
        glow_u8 = _sanitize_rgb_no_magenta((np.round(glow / 4.0) * 4.0).clip(0, 255).astype(np.uint8), seal_ring_mask)
        arr8[seal_ring_mask, :3] = glow_u8[seal_ring_mask]
        arr8[seal_ring_mask, 3] = 255

        for sx, sy, kind, ph0 in flower_sites:
            patch_fl = (fl_wht_4 if kind == "white" else fl_col_4)[(fl_phase + ph0) % 4]
            ph_h, ph_w = patch_fl.shape[:2]
            nz = patch_fl[:, :, 3] == 255
            sub = arr8[sy : sy + ph_h, sx : sx + ph_w]
            sub[nz] = patch_fl[nz]
        lay8_24.append(Image.fromarray(sanitize_rgba_binary(arr8), mode="RGBA"))

        # 09 Top : Bulles psychiques rose-perle de Mew & éclats solaires hors sceau central
        arr9 = np.zeros((H_CANON, W_CANON, 4), dtype=np.uint8)
        for bx0, by0, ph_b, rad_b in bubble_anchors:
            prog = ((f + ph_b * 6) % N_POSES) / float(N_POSES)
            bx = int(round(bx0 + 6.0 * math.sin(2.0 * math.pi * prog + ph_b)))
            by = int(round(by0 - 18.0 * math.sin(math.pi * prog)))
            _draw_mew_bubble(arr9, bx, by, radius=rad_b)
        arr9[arena_center_clear] = 0
        top9_24.append(Image.fromarray(sanitize_rgba_binary(arr9), mode="RGBA"))

    return islets_24, lay8_24, top9_24
