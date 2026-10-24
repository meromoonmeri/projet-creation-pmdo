#!/usr/bin/env python3
"""Moteur partagé multicalque PMDO 0.8.12.0 pour la suite de l'histoire *PMD Red Rescue Team* :
  - Duo **Gouffre Silencieux (*Silent Chasm*, `D05P01` / `D05P02` + `H13P02` *Cryptic Cave*)** : `SCE1` & `SCF1`
  - Duo **Grand Canyon (*Great Canyon*, `D07P01` + *Colline des Anciens / Xatu* `D07P02` / `A04P01`)** : `GCE1` & `GCF1`

Respecte strictement `METHODE_MAGENTA_ET_GENERATEUR.md` & `GUIDE_CREATION_DE_MAP.md` :
  1. Détourage `#FF00FF` sans mélange fond/décor (`BOX` pondéré par classe) vers `768 × 576` (`96 × 72` tuiles `8 px`),
     absorption itérative de toute frange rose/prune de bordure (`0 px` de fuite magenta, `min(R,B) - G <= 33`) ;
  2. Quantification `96` couleurs (`MEDIANCUT`, `dither=NONE`) + alpha strictement binaire `{0, 255}` ;
  3. Réutilisation directe des assets GBA natifs `1×` :
     - Brouillard parallaxe officiel `D05P01` Couche 0 (`d05p01_fog_parallax_native.png`) pour *Silent Chasm* ;
     - Ciel étoilé crépusculaire + Soleil d'or scintillant `12` frames `D07P02.bpl` + `A04P011.bpa`
       (`d07p02_sunset_12frames_native.png`) pour la *Colline des Anciens (Xatu)* ;
     - Reflets scintillants `Metano_Town_River_Sparkles.tile` (`4 × 10` ticks) pour l'oued du *Grand Canyon*.
"""

from __future__ import annotations

import math
from functools import lru_cache
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

from source.moteur_cyclones_cylindriques_unova import (
    H,
    N_POSES,
    W,
    extract_metano_water_and_flower_assets,
    sanitize_rgba_binary,
)
from source.moteur_forets_pmd_red import (
    BAYER_4X4,
    PURE_MAGENTA,
    _downsample_non_mixing,
    _keep_compact_blobs,
    _q8_u8,
    _sanitize_rgb_no_magenta,
    build_forest_water_and_sparkles_layers,
)

REPO_ROOT = Path(__file__).resolve().parent.parent


def _quantize_canyon_chasm_96c(rgb: np.ndarray, solid_mask: np.ndarray, mode: str) -> np.ndarray:
    """Quantifie le décor solide sur `<= 96` couleurs (`88` `MEDIANCUT` + accents minéraux/désertiques préservés)."""
    work = rgb.copy()
    r0 = work[:, :, 0].astype(np.int16)
    g0 = work[:, :, 1].astype(np.int16)
    b0 = work[:, :, 2].astype(np.int16)

    near_mag = ndimage.binary_dilation(~solid_mask, iterations=8)
    interior = solid_mask & (~near_mag)

    med_col = np.median(work[solid_mask], axis=0).astype(np.uint8)
    work[~solid_mask] = med_col
    q_im = Image.fromarray(work, mode="RGB").quantize(colors=88, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    out = np.asarray(q_im.convert("RGB"), dtype=np.uint8).copy()

    if mode == "great_canyon_entry":
        # Préserver le vert vif du cactus & touffes désertiques face à 99% d'ocre rouge
        cactus_hi = _keep_compact_blobs(interior & (g0 >= 120) & (g0 > r0 + 18) & (g0 > b0 + 35), max_area=900)
        cactus_lo = _keep_compact_blobs(interior & (~cactus_hi) & (g0 >= 80) & (g0 > r0 + 8) & (g0 > b0 + 22), max_area=900)
        out[cactus_hi] = (108, 164, 76)
        out[cactus_lo] = (72, 116, 52)
    elif mode == "silent_chasm_end":
        # Préserver les chapeaux turquoise-ardoise H13P02 des colonnes basaltiques
        teal_cap = interior & (b0 >= 155) & (g0 >= 165) & (g0 >= r0 + 12)
        out[teal_cap] = (156, 196, 192)

    out = _sanitize_rgb_no_magenta(out, solid_mask)
    out[~solid_mask] = PURE_MAGENTA
    return out


def assemble_gouffre_canyon_1x(
    gen_path: Path,
    out_brut_path: Path,
    out_canopy_path: Path,
    out_ref_canon_path: Path,
    mode: str,
) -> Dict[str, str]:
    """Convertit le brut `generate_image` (`#FF00FF`) en brut `768 × 576` propre + calque `Top` + `ref_canon`."""
    raw = np.asarray(Image.open(gen_path).convert("RGB"), dtype=np.uint8)
    gh, gw = raw.shape[:2]
    yy_hi, xx_hi = np.mgrid[0:gh, 0:gw]
    rf, gf, bf = raw[:, :, 0].astype(np.float32), raw[:, :, 1].astype(np.float32), raw[:, :, 2].astype(np.float32)

    core = (rf >= 220.0) & (gf <= 50.0) & (bf >= 220.0)

    # Cas particuliers D05P01 / SCF1 où un triangle de ciel pâle ou vide noir jouxte le #FF00FF :
    if mode == "silent_chasm_entry":
        pale_sky_hi = (yy_hi < int(gh * 0.25)) & (bf >= 215.0) & (gf >= 205.0) & (rf >= 175.0)
        core = core | pale_sky_hi
    elif mode == "silent_chasm_end":
        pale_rift_hi = (yy_hi < int(gh * 0.18)) & (bf >= 205.0) & (gf >= 195.0) & (rf >= 165.0)
        # Poches d'abîme noir pur entre les colonnes latérales et la plateforme centrale
        not_center_plat = ~(
            (xx_hi >= int(gw * 0.27))
            & (xx_hi <= int(gw * 0.73))
            & (yy_hi >= int(gh * 0.28))
            & (yy_hi <= int(gh * 0.99))
        )
        black_abyss_hi = not_center_plat & (yy_hi >= int(gh * 0.08)) & (rf <= 27.0) & (gf <= 30.0) & (bf <= 38.0)
        lbl_b, _ = ndimage.label(black_abyss_hi)
        b_sizes = np.bincount(lbl_b.ravel())
        keep_b = b_sizes >= 800
        keep_b[0] = False
        core = core | pale_rift_hi | keep_b[lbl_b]

    lbl_c, _ = ndimage.label(core)
    sizes = np.bincount(lbl_c.ravel())
    keep_c = sizes >= 220
    keep_c[0] = False
    valid_core = keep_c[lbl_c]

    near_mag = ndimage.binary_dilation(valid_core, iterations=14)
    fringe = near_mag & (rf > 1.28 * gf + 8.0) & (bf > 1.15 * gf + 8.0)
    mag_hi = valid_core | fringe
    fg_hi = ~mag_hi

    if mode == "great_canyon_entry":
        # Détourage intégral sans rogner le bas (hoodoos & cactus intacts) : on loge tout le relief [y_top..gh]
        # dans y = 120..576 pour dégager un grand ciel panoramique (y = 0..198 au col central du canyon) !
        fg_rows = np.where(fg_hi.any(axis=1))[0]
        y_src0 = int(fg_rows[0]) if fg_rows.size else 0
        dst_y0 = 120
        sub_rgb, sub_solid = _downsample_non_mixing(raw[y_src0:, :], fg_hi[y_src0:, :], W, H - dst_y0)
        rgb_768 = np.tile(PURE_MAGENTA, (H, W, 1))
        solid_768 = np.zeros((H, W), dtype=bool)
        rgb_768[dst_y0:, :] = sub_rgb
        solid_768[dst_y0:, :] = sub_solid
    elif mode == "hill_of_ancients":
        # Détourage intégral sans rogner les falaises basses : tout le panorama de mesas + promontoire de Xatu
        # se loge dans y = 184..576, ouvrant ~208 px de ciel étoilé + couchant + Soleil canonique D07P02 !
        fg_rows = np.where(fg_hi.any(axis=1))[0]
        y_src0 = int(fg_rows[0]) if fg_rows.size else 0
        dst_y0 = 184
        sub_rgb, sub_solid = _downsample_non_mixing(raw[y_src0:, :], fg_hi[y_src0:, :], W, H - dst_y0)
        rgb_768 = np.tile(PURE_MAGENTA, (H, W, 1))
        solid_768 = np.zeros((H, W), dtype=bool)
        rgb_768[dst_y0:, :] = sub_rgb
        solid_768[dst_y0:, :] = sub_solid
    else:
        rgb_768, solid_768 = _downsample_non_mixing(raw, fg_hi, W, H)

    # Sur SCE1 (D05P01), le massif central de roche d'ardoise monte jusqu'en haut de l'écran (y=0) sans coupe plate :
    if mode == "silent_chasm_entry":
        # Trouve la première ligne où le massif central est pleinement présent (~y=58)
        y_cap = 58
        while y_cap < 110 and int(solid_768[y_cap, 240:528].sum()) < 240:
            y_cap += 1
        if y_cap > 0:
            for y_dst in range(y_cap):
                # Prolonge verticalement les veines d'ardoise de y_cap..y_cap+58 avec un léger pincement naturel
                src_y = min(H - 1, y_cap + (y_cap - y_dst))
                taper_px = int(round((y_cap - y_dst) * 0.22))
                row_s = solid_768[y_cap, :].copy()
                # Ne prolonge que le massif central (x=185..583) et les 2 aiguilles latérales (x=45..110, 658..723)
                keep_cols = np.zeros(W, dtype=bool)
                keep_cols[185 + taper_px : 583 - taper_px] = True
                row_use = row_s & keep_cols & solid_768[src_y, :]
                rgb_768[y_dst, row_use] = rgb_768[src_y, row_use]
                solid_768[y_dst, row_use] = True

    # Absorption itérative (jusqu'à 7 px) de toute frange rose/prune/bordeaux collée aux zones #FF00FF
    yy7, xx7 = np.mgrid[0:H, 0:W]
    r7, g7, b7 = rgb_768[:, :, 0].astype(np.int16), rgb_768[:, :, 1].astype(np.int16), rgb_768[:, :, 2].astype(np.int16)
    for _ in range(7):
        adj_mag = ndimage.binary_dilation(~solid_768, iterations=1)
        rim = (
            solid_768
            & adj_mag
            & (
                ((r7 > g7 + 22) & (b7 > g7 + 14))
                | ((r7 >= 185) & (r7 > g7 + 35) & (b7 >= 120))
            )
        )
        if not np.any(rim):
            break
        solid_768 = solid_768 & (~rim)

    rgb_768 = _quantize_canyon_chasm_96c(rgb_768, solid_768, mode=mode)
    mag_768 = ~solid_768

    out_brut_path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(rgb_768, mode="RGB").save(out_brut_path)

    # Extraction du calque supérieur `Top` (crêtes latérales / pointes de stalagmites, hors chemin central !)
    r16, g16, b16 = rgb_768[:, :, 0].astype(np.int16), rgb_768[:, :, 1].astype(np.int16), rgb_768[:, :, 2].astype(np.int16)
    if mode == "silent_chasm_entry":
        top_mask = solid_768 & ((xx7 < 140) | (xx7 > W - 140)) & (yy7 < 260) & (g16 >= r16)
    elif mode == "silent_chasm_end":
        top_mask = solid_768 & ((xx7 < 132) | (xx7 > W - 132)) & ((yy7 < 180) | (yy7 > 380))
    elif mode == "great_canyon_entry":
        top_mask = solid_768 & (
            ((yy7 >= 120) & (yy7 < 196) & ((xx7 < 252) | (xx7 > W - 252)) & (r16 >= 145))
            | ((yy7 >= 492) & ((xx7 < 96) | (xx7 > W - 96)) & (r16 < 185))
        )
    else:
        top_mask = solid_768 & ((xx7 < 104) | (xx7 > W - 104)) & (yy7 >= 256) & (yy7 <= 468)

    canopy_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    canopy_rgba[top_mask, :3] = rgb_768[top_mask]
    canopy_rgba[top_mask, 3] = 255
    out_canopy_path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(canopy_rgba, mode="RGBA").save(out_canopy_path)

    # Construction de `ref_canon` (composite fidèle sans magenta)
    ref_rgb = rgb_768.copy()
    if mode == "silent_chasm_entry":
        sky_m = mag_768 & (yy7 < 165)
        aby_m = mag_768 & (~sky_m)
        sky0, hor0, aby0, _, _ = build_silent_chasm_layers("silent_chasm_entry", sky_m, aby_m, rgb_768, single_pose_preview=True)
        for lay_im in (sky0[0], hor0[0], aby0[0]):
            la = np.asarray(lay_im, dtype=np.uint8)
            m = (la[:, :, 3] == 255) & mag_768
            ref_rgb[m] = la[m, :3]
    elif mode == "silent_chasm_end":
        sky_m = mag_768 & (yy7 < 110) & (xx7 >= 220) & (xx7 <= 548)
        aby_m = mag_768 & (~sky_m)
        sky0, hor0, aby0, _, _ = build_silent_chasm_layers("silent_chasm_end", sky_m, aby_m, rgb_768, single_pose_preview=True)
        for lay_im in (sky0[0], hor0[0], aby0[0]):
            la = np.asarray(lay_im, dtype=np.uint8)
            m = (la[:, :, 3] == 255) & mag_768
            ref_rgb[m] = la[m, :3]
    elif mode == "great_canyon_entry":
        sky0, far0, sun0, near0, _ = build_great_canyon_sky_and_top_layers(mag_768, rgb_768, single_pose_preview=True)
        for lay_im in (sky0[0], far0[0], sun0[0], near0[0]):
            la = np.asarray(lay_im, dtype=np.uint8)
            m = (la[:, :, 3] == 255) & mag_768
            ref_rgb[m] = la[m, :3]
    else:
        sky0, far0, sun0, near0, _ = build_hill_of_ancients_layers(mag_768, np.zeros_like(mag_768), rgb_768, single_pose_preview=True)
        for lay_im in (sky0[0], far0[0], sun0[0], near0[0]):
            la = np.asarray(lay_im, dtype=np.uint8)
            m = (la[:, :, 3] == 255) & mag_768
            ref_rgb[m] = la[m, :3]

    out_ref_canon_path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(ref_rgb, mode="RGB").save(out_ref_canon_path)

    return {
        "brut": str(out_brut_path),
        "canopy": str(out_canopy_path),
        "ref_canon": str(out_ref_canon_path),
    }


@lru_cache(maxsize=2)
def _load_d05p01_fog_tile_768() -> np.ndarray:
    """Charge la nappe de brouillard GBA native `D05P01` Couche 0 et la boucle horizontalement sur `768 × 320`."""
    fog_p = REPO_ROOT / "source" / "silent_chasm_entree_v1" / "references" / "d05p01_fog_parallax_native.png"
    raw = Image.open(fog_p).convert("RGB")
    # Redimensionne en NEAREST à 768x320 puis assure la couture horizontale douce sur 32 px
    arr = np.asarray(raw.resize((W, 320), Image.Resampling.NEAREST), dtype=np.float32)
    lum = arr.mean(axis=2) / 255.0
    seam = 28
    for dx in range(seam):
        t = (dx + 0.5) / float(seam)
        avg = 0.5 * (lum[:, dx] + lum[:, W - 1 - dx])
        lum[:, dx] = avg * (1.0 - t) + lum[:, dx] * t
        lum[:, W - 1 - dx] = avg * (1.0 - t) + lum[:, W - 1 - dx] * t
    v_env = np.sin(np.pi * (np.arange(320, dtype=np.float32) + 0.5) / 320.0)[:, None]
    return np.clip(lum * 1.45 * v_env, 0.0, 1.0)


@lru_cache(maxsize=2)
def _load_d07p02_sunset_12frames() -> List[np.ndarray]:
    """Charge les 12 poses natives `312 × 236` de `D07P02` (`A04P011.bpa` + `D07P02.bpl`)."""
    p = REPO_ROOT / "source" / "great_canyon_fin_v1" / "references" / "d07p02_sunset_12frames_native.png"
    strip = np.asarray(Image.open(p).convert("RGB"), dtype=np.uint8)
    sw = strip.shape[1] // 12
    return [strip[:, i * sw : (i + 1) * sw, :].copy() for i in range(12)]


def build_silent_chasm_layers(
    mode: str,
    sky_mask: np.ndarray,
    abyss_mask: np.ndarray,
    base_rgb: np.ndarray,
    single_pose_preview: bool = False,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit `(sky_24, sky_fx_24, abyss_fog_24, abyss_sparks_24, top_fog_24)` pour `SCE1` et `SCF1`."""
    fog_tile = _load_d05p01_fog_tile_768()  # (320, 768) float32 in [0..1]
    yy, xx = np.mgrid[0:H, 0:W]
    bayer01 = np.tile(BAYER_4X4, (H // 4 + 1, W // 4 + 1))[:H, :W]

    rng = np.random.default_rng(50501 if mode == "silent_chasm_entry" else 50502)
    n_sparks = 34
    sp_x0 = rng.integers(24, W - 24, size=n_sparks)
    sp_y0 = rng.integers(140, H - 24, size=n_sparks)
    sp_ph = rng.uniform(0.0, 2.0 * math.pi, size=n_sparks)
    sp_kind = rng.integers(0, 2, size=n_sparks)

    n_iter = 1 if single_pose_preview else N_POSES
    sky_out: List[Image.Image] = []
    hor_out: List[Image.Image] = []
    aby_out: List[Image.Image] = []
    spk_out: List[Image.Image] = []
    top_out: List[Image.Image] = []

    dist_abyss = ndimage.distance_transform_edt(abyss_mask)

    for f in range(n_iter):
        theta = 2.0 * math.pi * f / float(N_POSES)

        # --- Calque 00 & 01 : Ciel d'altitude brumeux (SCE1) ou Faille d'orage d'Électhor (SCF1) ---
        sky = np.zeros((H, W, 4), dtype=np.uint8)
        hor = np.zeros((H, W, 4), dtype=np.uint8)
        if np.any(sky_mask):
            sy_max = int(np.where(sky_mask)[0].max()) + 1
            s_yy, s_xx = np.mgrid[0:sy_max, 0:W].astype(np.float32)
            t_y = np.clip(s_yy / max(float(sy_max), 1.0), 0.0, 1.0)
            if mode == "silent_chasm_entry":
                # Ciel gris-azur pâle authentique D05P01 animé d'une lente respiration
                breath = 10.0 * np.cos(theta - 0.008 * s_xx)
                r_s = 164.0 + 42.0 * t_y + breath * 0.7
                g_s = 196.0 + 38.0 * t_y + breath * 0.9
                b_s = 216.0 + 28.0 * t_y + breath * 1.0
                s_rgb = _sanitize_rgb_no_magenta(
                    _q8_u8(np.stack([r_s, g_s, b_s], axis=-1)),
                    sky_mask[:sy_max, :],
                )
                sky[:sy_max, :][sky_mask[:sy_max, :], :3] = s_rgb[sky_mask[:sy_max, :]]
                sky[:sy_max, :][sky_mask[:sy_max, :], 3] = 255

                # Rubans de nuages ardoise dérivant sur le ciel (32 px/pose -> boucle exacte 768 px)
                f_sky = np.roll(fog_tile[:sy_max, :], shift=(f * 32) % W, axis=1)
                hit_h = sky_mask[:sy_max, :] & (f_sky > 0.24)
                c_rgb = _sanitize_rgb_no_magenta(
                    _q8_u8(s_rgb.astype(np.float32) * 0.65 + np.array([112.0, 136.0, 156.0]) * 0.35),
                    hit_h,
                )
                hor[:sy_max, :][hit_h, :3] = c_rgb[hit_h]
                hor[:sy_max, :][hit_h, 3] = 255
            else:
                # Faille d'orage sombre au zénith + éclairs dorés annonçant la descente d'Électhor (Zapdos) !
                flash = max(0.0, math.cos(2.0 * theta - 0.6)) ** 6
                r_s = 40.0 + 36.0 * t_y + 150.0 * flash
                g_s = 56.0 + 44.0 * t_y + 145.0 * flash
                b_s = 84.0 + 52.0 * t_y + 90.0 * flash
                s_rgb = _sanitize_rgb_no_magenta(
                    _q8_u8(np.stack([r_s, g_s, b_s], axis=-1)),
                    sky_mask[:sy_max, :],
                )
                sky[:sy_max, :][sky_mask[:sy_max, :], :3] = s_rgb[sky_mask[:sy_max, :]]
                sky[:sy_max, :][sky_mask[:sy_max, :], 3] = 255

                # Zébrures d'éclairs dorés dans la faille haute aux poses de décharge
                bolt_x = int(round(384.0 + 36.0 * math.sin(theta * 2.0)))
                bolt_line = np.abs((s_xx - bolt_x) - 9.0 * np.sin(s_yy * 0.16 + theta * 3.0))
                hit_bolt = sky_mask[:sy_max, :] & (flash > 0.18) & (bolt_line <= 2.6)
                hor[:sy_max, :][hit_bolt] = (255, 244, 152, 255)
                halo_bolt = sky_mask[:sy_max, :] & (~hit_bolt) & (flash > 0.12) & (bolt_line <= 6.5)
                hor[:sy_max, :][halo_bolt] = (196, 212, 248, 255)

        sky_out.append(Image.fromarray(sanitize_rgba_binary(sky)))
        hor_out.append(Image.fromarray(sanitize_rgba_binary(hor)))

        # --- Calque 02 : Abîme sans fond & Nappes de Brouillard parallaxe GBA D05P01 (2 vitesses !) ---
        aby = np.zeros((H, W, 4), dtype=np.uint8)
        if np.any(abyss_mask):
            # Fond d'abîme gradué selon la distance à la paroi rocheuse
            d_norm = np.clip(dist_abyss / 42.0, 0.0, 1.0)
            fog1 = np.roll(fog_tile, shift=(f * 32) % W, axis=1)
            fog2 = np.roll(fog_tile[::-1, :], shift=-((f * 32) % W), axis=1)
            # Pavage vertical couvrant 576 px
            fog_full1 = np.vstack([fog1, fog1])[:H, :]
            fog_full2 = np.vstack([fog2, fog2])[:H, :]
            fog_mix = np.clip(0.65 * fog_full1 + 0.50 * fog_full2, 0.0, 1.0)
            pulse_f = 0.88 + 0.16 * math.cos(theta)
            val = fog_mix * pulse_f * (0.35 + 0.65 * d_norm)

            if mode == "silent_chasm_entry":
                base_ab = np.array([22.0, 30.0, 38.0])
                mist_col = np.array([128.0, 148.0, 168.0])
            else:
                base_ab = np.array([14.0, 20.0, 30.0])
                mist_col = np.array([104.0, 140.0, 164.0])

            ab_f = base_ab[None, None, :] * (1.0 - val[:, :, None]) + mist_col[None, None, :] * val[:, :, None]
            # Biseau sombre immédiat sous la corniche (0..5 px) pour ancrer la falaise
            rim_dark = abyss_mask & (dist_abyss <= 4.5)
            ab_q = _sanitize_rgb_no_magenta(_q8_u8(ab_f), abyss_mask)
            ab_q[rim_dark] = (16, 22, 28)
            aby[abyss_mask, :3] = ab_q[abyss_mask]
            aby[abyss_mask, 3] = 255
        aby_out.append(Image.fromarray(sanitize_rgba_binary(aby)))

        # --- Calque 03 : Courants ascendants (SCE1) ou Cristaux H13P02 & Étincelles d'Électhor (SCF1) ---
        spk = np.zeros((H, W, 4), dtype=np.uint8)
        for i in range(n_sparks):
            sx = int(round(sp_x0[i] + 8.0 * math.sin(theta + sp_ph[i])))
            # Mouvement ascendant cyclique sur période 48 px (2 px/pose * 24 = 48)
            sy = int((sp_y0[i] - f * 2) % (H - 150)) + 130
            if 6 <= sx < W - 6 and 6 <= sy < H - 6 and abyss_mask[sy, sx] and dist_abyss[sy, sx] >= 6.0:
                tw = math.sin(2.0 * theta + sp_ph[i])
                if mode == "silent_chasm_entry":
                    if tw > -0.1:
                        spk[sy : sy + 3, sx] = (176, 208, 224, 255)
                        if tw > 0.45:
                            spk[sy - 1, sx] = (224, 240, 248, 255)
                else:
                    if sp_kind[i] == 0 and tw > -0.15:
                        # Étoile cristalline cyan-émeraude authentique de H13P02 (Cryptic Cave) !
                        spk[sy, sx] = (232, 255, 248, 255)
                        if tw > 0.30:
                            for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                                spk[sy + dy, sx + dx] = (104, 224, 208, 255)
                    elif sp_kind[i] == 1 and tw > 0.15:
                        # Flammèche électrique dorée d'Électhor
                        spk[sy, sx : sx + 2] = (255, 240, 136, 255)
        spk_out.append(Image.fromarray(sanitize_rgba_binary(spk)))

        # --- Calque 09 Top : Voiles de brume GBA D05P01 sur les parois rocheuses + particules ---
        top_fx = np.zeros((H, W, 4), dtype=np.uint8)
        if not single_pose_preview:
            y0_t, y1_t = (96, 416) if mode == "silent_chasm_entry" else (120, 440)
            fog_top = np.roll(fog_tile, shift=-((f * 32) % W), axis=1)
            on_rock = (~sky_mask[y0_t:y1_t, :]) & (~abyss_mask[y0_t:y1_t, :])
            xg_t = np.arange(W)[None, :]
            yg_t = np.arange(y0_t, y1_t)[:, None]
            # Garde l'ouverture noire de la grotte Nord parfaitement lisible sur SCE1
            if mode == "silent_chasm_entry":
                in_maw = (xg_t >= 328) & (xg_t <= 440) & (yg_t <= 190)
                on_rock = on_rock & (~in_maw)
            inten_t = fog_top * (0.62 + 0.14 * math.cos(theta))
            by_t = bayer01[y0_t:y1_t, :]
            m_hi = on_rock & (inten_t > 0.56) & ((inten_t * 1.6) > by_t)
            m_lo = on_rock & (~m_hi) & (inten_t > 0.36) & ((inten_t * 1.15) > by_t)
            base_sub = base_rgb[y0_t:y1_t, :].astype(np.int16)
            lit = base_sub.copy()
            lit[m_hi] = np.clip(base_sub[m_hi] + np.array([34, 40, 48], dtype=np.int16), 0, 255)
            lit[m_lo] = np.clip(base_sub[m_lo] + np.array([18, 22, 28], dtype=np.int16), 0, 255)
            hit = m_hi | m_lo
            lit_q = _sanitize_rgb_no_magenta(((lit // 8) * 8).clip(0, 255).astype(np.uint8), hit)
            sub_top = top_fx[y0_t:y1_t, :]
            sub_top[hit, :3] = lit_q[hit]
            sub_top[hit, 3] = 255

        top_out.append(Image.fromarray(sanitize_rgba_binary(top_fx)))

    return sky_out, hor_out, aby_out, spk_out, top_out


@lru_cache(maxsize=8)
def _extract_pmd_cloud_families(
    palette_mode: str = "day_canyon",
    target_w: int = 480,
    target_h: int = 268,
) -> Dict[str, List[np.ndarray]]:
    """Extrait les 9 nuages pixel-art PMD générés sur `#FF00FF` (`nuages_pmd_canyon_magenta.png`)
    et les classe en 4 familles (`majors`, `mediums`, `strato`, `wisps`) quantifiées GBA 4 tons."""
    cld_p = REPO_ROOT / "source" / "great_canyon_entree_v1" / "bruts" / "nuages_pmd_canyon_magenta.png"
    raw = np.asarray(Image.open(cld_p).convert("RGB"), dtype=np.uint8)
    rf, gf, bf = raw[:, :, 0].astype(np.float32), raw[:, :, 1].astype(np.float32), raw[:, :, 2].astype(np.float32)

    mag_core = (rf >= 200.0) & (gf <= 95.0) & (bf >= 190.0) & ((rf + bf - 2.0 * gf) >= 180.0)
    near_mag = ndimage.binary_dilation(mag_core, iterations=4)
    fringe = near_mag & (rf > gf + 22.0) & (bf > gf + 18.0)
    fg_hi = ~(mag_core | fringe)

    rgb_lo, solid_lo = _downsample_non_mixing(raw, fg_hi, target_w, target_h)
    r_l, g_l, b_l = rgb_lo[:, :, 0].astype(np.int16), rgb_lo[:, :, 1].astype(np.int16), rgb_lo[:, :, 2].astype(np.int16)
    solid_lo = solid_lo & ~((r_l > g_l + 18) & (b_l > g_l + 14))
    solid_lo = ndimage.binary_opening(solid_lo, structure=np.ones((2, 2), dtype=bool))

    if palette_mode == "sunset_canyon":
        pal = np.array(
            [
                [160, 88, 64],    # base ombre terre cuite crépusculaire
                [208, 128, 64],   # mi-ton ambre brûlé
                [240, 176, 88],   # corps doré couchant
                [255, 224, 136],  # crête illuminée d'or
            ],
            dtype=np.uint8,
        )
    else:
        pal = np.array(
            [
                [200, 152, 96],   # base plate ombrée ocre doux
                [232, 192, 136],  # mi-ton chaud sable doré
                [248, 224, 176],  # corps crème solaire
                [255, 248, 224],  # couronne ivoire lumineuse
            ],
            dtype=np.uint8,
        )

    lbl, n_comp = ndimage.label(solid_lo)
    comps: List[Tuple[int, np.ndarray]] = []
    for cid in range(1, n_comp + 1):
        ys, xs = np.where(lbl == cid)
        if ys.size < 16:
            continue
        y0, y1 = int(ys.min()), int(ys.max()) + 1
        x0, x1 = int(xs.min()), int(xs.max()) + 1
        sub_m = lbl[y0:y1, x0:x1] == cid
        sub_rgb = rgb_lo[y0:y1, x0:x1].astype(np.float32)
        lum = 0.299 * sub_rgb[:, :, 0] + 0.587 * sub_rgb[:, :, 1] + 0.114 * sub_rgb[:, :, 2]
        vals = lum[sub_m]
        q25, q55, q80 = np.percentile(vals, [25.0, 55.0, 80.0])
        idx = np.zeros(sub_m.shape, dtype=np.int32)
        idx[lum >= q25] = 1
        idx[lum >= q55] = 2
        idx[lum >= q80] = 3

        sp = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
        q_rgb = _sanitize_rgb_no_magenta(pal[idx], sub_m)
        sp[sub_m, :3] = q_rgb[sub_m]
        sp[sub_m, 3] = 255
        comps.append((int(ys.size), sp))

    comps.sort(key=lambda t: -t[0])
    sprites = [sp for _, sp in comps]
    while len(sprites) < 9:
        sprites.append(sprites[-1])
    return {
        "majors": sprites[:2],
        "mediums": sprites[2:5],
        "strato": sprites[5:7],
        "wisps": sprites[7:9],
    }


def _render_wrapping_cloud_band(
    placements: List[Tuple[np.ndarray, int, int]],
    period_w: int,
    shift_per_pose: int,
    sky_mask: np.ndarray,
    single_pose_preview: bool = False,
) -> List[Image.Image]:
    """Rend une bande de familles de nuages PMD bouclant périodiquement sans couture sur `24` poses."""
    band_h = H
    proto = np.zeros((band_h, period_w, 4), dtype=np.uint8)
    for sp, x0, y0 in placements:
        sh, sw = sp.shape[:2]
        for dy in range(sh):
            yy = y0 + dy
            if yy < 0 or yy >= band_h:
                continue
            op = sp[dy, :, 3] == 255
            if not np.any(op):
                continue
            xs_src = np.where(op)[0]
            xs_dst = (x0 + xs_src) % period_w
            proto[yy, xs_dst, :3] = sp[dy, xs_src, :3]
            proto[yy, xs_dst, 3] = 255

    if period_w < W:
        reps = (W + period_w - 1) // period_w
        full_proto = np.tile(proto, (1, reps, 1))[:, :W, :]
    else:
        full_proto = proto[:, :W, :]

    n_iter = 1 if single_pose_preview else N_POSES
    frames: List[Image.Image] = []
    for f in range(n_iter):
        rolled = np.roll(full_proto, shift=(f * shift_per_pose) % W, axis=1).copy()
        rolled[~sky_mask, :] = 0
        frames.append(Image.fromarray(sanitize_rgba_binary(rolled)))
    return frames


@lru_cache(maxsize=2)
def _extract_canonical_d07p02_sun_and_stars() -> Tuple[List[np.ndarray], np.ndarray, np.ndarray, List[np.ndarray]]:
    """Extrait à l'identique depuis `d07p02_sunset_12frames_native.png` (`D07P02.bpl` + `A04P011.bpa`) :
      1. `sun_12_2x` : les 12 poses canoniques du Soleil GBA (`200 × 66` en `2× NEAREST`, `0` halo artificiel) ;
      2. `sky_row_med` : le profil vertical exact de couleur du ciel `D07P02` (`226 × 3`) ;
      3. `static_stars_mask_rgb` : les étoiles fixes natives (`136 × 312 × 4`) ;
      4. `anim_stars_12` : les 12 poses natives d'étoiles scintillantes + étoile filante (`136 × 312 × 4`)."""
    d07_frames = _load_d07p02_sunset_12frames()  # 12 x (236, 312, 3)
    ref0 = d07_frames[0]

    # 1. Soleil animé canonique (toutes ses barres de réfraction thermique R==255, G>=155, B<=120)
    sun_12_2x: List[np.ndarray] = []
    for nat_f in d07_frames:
        crop = nat_f[196:229, 108:208, :]  # (33, 100, 3)
        c2x = np.asarray(Image.fromarray(crop).resize((200, 66), Image.Resampling.NEAREST), dtype=np.uint8)
        sr, sg, sb = c2x[:, :, 0].astype(np.int16), c2x[:, :, 1].astype(np.int16), c2x[:, :, 2].astype(np.int16)
        m_sun = (sr == 255) & (sg >= 155) & (sb <= 120)
        rgba = np.zeros((66, 200, 4), dtype=np.uint8)
        clean_rgb = _sanitize_rgb_no_magenta(c2x, m_sun)
        rgba[m_sun, :3] = clean_rgb[m_sun]
        rgba[m_sun, 3] = 255
        sun_12_2x.append(rgba)

    # 2. Couleur médiane exacte par ligne du ciel D07P02 (y = 0..226)
    sky_row_med = np.median(ref0[:226, :, :], axis=1).astype(np.uint8)  # (226, 3)

    # 3. Séparation étoiles fixes vs étoiles scintillantes & étoile filante sur le cosmos indigo (y = 0..136)
    star_h = 136
    med_top = sky_row_med[:star_h, None, :].astype(np.int16)
    stack_top = np.stack([f[:star_h, :, :] for f in d07_frames], axis=0).astype(np.int16)  # (12, 136, 312, 3)
    varies_across_time = (np.abs(stack_top - stack_top[0:1]).max(axis=(0, 3))) > 0
    diff_from_sky0 = np.abs(stack_top[0] - med_top).max(axis=2) > 4

    static_m = diff_from_sky0 & (~varies_across_time)
    static_stars = np.zeros((star_h, 312, 4), dtype=np.uint8)
    st_rgb = _sanitize_rgb_no_magenta(ref0[:star_h, :, :], static_m)
    static_stars[static_m, :3] = st_rgb[static_m]
    static_stars[static_m, 3] = 255

    anim_stars_12: List[np.ndarray] = []
    for k in range(12):
        fk_top = d07_frames[k][:star_h, :, :]
        m_k = varies_across_time & (np.abs(fk_top.astype(np.int16) - med_top).max(axis=2) > 4)
        a_rgba = np.zeros((star_h, 312, 4), dtype=np.uint8)
        ak_rgb = _sanitize_rgb_no_magenta(fk_top, m_k)
        a_rgba[m_k, :3] = ak_rgb[m_k]
        a_rgba[m_k, 3] = 255
        anim_stars_12.append(a_rgba)

    return sun_12_2x, sky_row_med, static_stars, anim_stars_12


def _blit_native_star_band_768(
    dst_rgba: np.ndarray,
    star_band_312: np.ndarray,
    sky_mask: np.ndarray,
    max_y_dst: int,
) -> None:
    """Projette une bande céleste native `136 × 312` en pixels nets `2×2` sur toute la largeur `768 px`."""
    ys, xs = np.where(star_band_312[:, :, 3] == 255)
    if not ys.size:
        return
    # Centre 2x (624 px sur x = 72..696) + rappel latéral doux sur les ailes x = 0..72 et x = 696..768
    for y_n, x_n in zip(ys.tolist(), xs.tolist()):
        col = star_band_312[y_n, x_n, :3]
        yd = int(round(y_n * 0.775))
        if yd < 2 or yd + 2 > max_y_dst:
            continue
        xd_main = 72 + x_n * 2
        candidates = [xd_main]
        if x_n < 34:
            candidates.append(696 + x_n * 2)
        elif x_n >= 278:
            candidates.append((x_n - 278) * 2)
        for xd in candidates:
            if 0 <= xd and xd + 2 <= W:
                sub_s = sky_mask[yd : yd + 2, xd : xd + 2]
                if np.all(sub_s):
                    dst_rgba[yd : yd + 2, xd : xd + 2, :3] = col
                    dst_rgba[yd : yd + 2, xd : xd + 2, 3] = 255


def build_great_canyon_sky_and_top_layers(
    sky_mask: np.ndarray,
    base_rgb: np.ndarray,
    single_pose_preview: bool = False,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit `(sky_static_1, clouds_far_24, canonical_sun_24, clouds_near_24, canyon_breeze_top_24)`
    pour `GCE1` (*Grand Canyon — Entrée D07P01*) :
      - Ciel chaud du Grand Canyon s'embrasant vers `(255, 143, 23)` dans le col central ;
      - Familles de nuages style PMD générées (`nuages_pmd_canyon_magenta.png`) sur 2 plans de parallaxe ;
      - Soleil animé canonique de la map de référence (`D07P02.bpl` + `A04P011.bpa`, `2× NEAREST`)."""
    sun_12_2x, _, _, _ = _extract_canonical_d07p02_sun_and_stars()
    fams_near = _extract_pmd_cloud_families("day_canyon", target_w=464, target_h=260)
    fams_far = _extract_pmd_cloud_families("day_canyon", target_w=340, target_h=190)

    sy_max = min(H, (int(np.where(sky_mask)[0].max()) + 2) if np.any(sky_mask) else 204)
    s_yy = np.arange(sy_max, dtype=np.float32)[:, None]
    # Dégradé GBA chaud en paliers nets : azur doré au zénith -> abricot -> orange solaire canonique (255, 143, 23) au col
    t_top = np.clip(s_yy / 146.0, 0.0, 1.0)
    r_col = np.where(s_yy < 146.0, 104.0 + 151.0 * (t_top**0.82), 255.0)
    g_col = np.where(s_yy < 146.0, 176.0 - 33.0 * (t_top**1.15), 143.0)
    b_col = np.where(s_yy < 146.0, 232.0 - 209.0 * (t_top**0.92), 23.0)
    grad_row = np.broadcast_to(np.stack([r_col, g_col, b_col], axis=-1), (sy_max, W, 3)).copy()
    sub_m = sky_mask[:sy_max, :]
    s_q = _sanitize_rgb_no_magenta(_q8_u8(grad_row), sub_m)
    # Force la teinte exacte (255, 143, 23) de D07P02 autour du Soleil canonique (y >= 140)
    hor_band = sub_m & (np.arange(sy_max)[:, None] >= 140)
    s_q[hor_band] = (255, 143, 23)

    sky_arr = np.zeros((H, W, 4), dtype=np.uint8)
    sky_arr[:sy_max, :][sub_m, :3] = s_q[sub_m]
    sky_arr[:sy_max, :][sub_m, 3] = 255
    sky_static_1 = [Image.fromarray(sanitize_rgba_binary(sky_arr))]

    # Plan lointain (16 px/pose, période 384 px) : familles stratocumulus & flocons dérivant derrière le Soleil
    far_placements = [
        (fams_far["strato"][0], 24, 92),
        (fams_far["wisps"][0], 142, 118),
        (fams_far["strato"][1], 216, 102),
        (fams_far["wisps"][1], 324, 82),
    ]
    clouds_far_24 = _render_wrapping_cloud_band(
        far_placements, period_w=384, shift_per_pose=16, sky_mask=sky_mask, single_pose_preview=single_pose_preview
    )

    # Plan principal (32 px/pose, période 768 px) : grandes familles de cumulus PMD à base plate dans le haut du ciel
    near_placements = [
        (fams_near["majors"][0], 28, 12),
        (fams_near["mediums"][0], 238, 48),
        (fams_near["mediums"][2], 348, 8),
        (fams_near["majors"][1], 492, 10),
        (fams_near["mediums"][1], 668, 54),
    ]
    clouds_near_24 = _render_wrapping_cloud_band(
        near_placements, period_w=768, shift_per_pose=32, sky_mask=sky_mask, single_pose_preview=single_pose_preview
    )

    # Soleil animé canonique de D07P02 niché dans l'échancrure centrale du Grand Canyon (x=284..484, y=140..206)
    n_iter = 1 if single_pose_preview else N_POSES
    sun_out: List[Image.Image] = []
    breeze_out: List[Image.Image] = []
    rng = np.random.default_rng(70701)
    n_dust = 28
    dx0 = rng.integers(32, W - 32, size=n_dust)
    dy0 = rng.integers(220, H - 36, size=n_dust)
    dph = rng.uniform(0.0, 2.0 * math.pi, size=n_dust)

    y0_sun, x0_sun = 140, 384 - 100
    for f in range(n_iter):
        theta = 2.0 * math.pi * f / float(N_POSES)
        bpa_idx = (f // 2) % 12
        sun_frame = np.zeros((H, W, 4), dtype=np.uint8)
        sp_sun = sun_12_2x[bpa_idx]
        y1_sun = min(H, y0_sun + sp_sun.shape[0])
        hs = y1_sun - y0_sun
        keep_s = (sp_sun[:hs, :, 3] == 255) & sky_mask[y0_sun:y1_sun, x0_sun : x0_sun + 200]
        sub_dst = sun_frame[y0_sun:y1_sun, x0_sun : x0_sun + 200]
        sub_dst[keep_s, :3] = sp_sun[:hs, :, :3][keep_s]
        sub_dst[keep_s, 3] = 255
        sun_out.append(Image.fromarray(sanitize_rgba_binary(sun_frame)))

        # Brise chaude de grains de sable doré dans le canyon (zéro rayon/halo artificiel)
        top_fx = np.zeros((H, W, 4), dtype=np.uint8)
        if not single_pose_preview:
            for i in range(n_dust):
                mx = int((dx0[i] + f * 32) % (W - 16)) + 8
                my = int(round(dy0[i] + 4.0 * math.sin(theta + dph[i])))
                if 4 <= mx < W - 4 and 205 <= my < H - 4 and (not sky_mask[my, mx]):
                    if math.sin(2.0 * theta + dph[i]) > -0.15:
                        top_fx[my, mx : mx + 2] = (248, 216, 152, 255)
        breeze_out.append(Image.fromarray(sanitize_rgba_binary(top_fx)))

    return sky_static_1, clouds_far_24, sun_out, clouds_near_24, breeze_out


def build_hill_of_ancients_layers(
    sky_mask: np.ndarray,
    abyss_mask: np.ndarray,
    base_rgb: np.ndarray,
    single_pose_preview: bool = False,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit `(starry_sunset_static_1, clouds_sunset_far_24, canonical_sun_and_stars_24, clouds_sunset_near_24, breeze_top_24)`
    pour `GCF1` (*Colline des Anciens / Xatu*, `D07P02` + `A04P011.bpa` + `D07P02.bpl`) :
      - Ciel crépusculaire étoilé natif `D07P02` (indigo profond -> ambre ardent `(255, 143, 23)`) + étoiles fixes natives ;
      - Soleil animé canonique `100 %` fidèle `D07P02` (`2× NEAREST`, sans aucun ovale ni rayon procédural)
        + étoiles scintillantes natives + étoile filante native (`A04P011.bpa`) ;
      - Familles de nuages style PMD générées aux teintes du couchant dérivant sur 2 plans de parallaxe."""
    del abyss_mask, base_rgb
    sun_12_2x, sky_row_med, static_stars_312, anim_stars_12 = _extract_canonical_d07p02_sun_and_stars()
    fams_near = _extract_pmd_cloud_families("sunset_canyon", target_w=328, target_h=184)
    fams_far = _extract_pmd_cloud_families("sunset_canyon", target_w=272, target_h=152)

    sy_max = min(H, (int(np.where(sky_mask)[0].max()) + 2) if np.any(sky_mask) else 212)
    # Projection verticale 100 % sans couture du profil D07P02 :
    # - lignes natives 0..196 (cosmos indigo + les 8 paliers GBA violet/pourpre/orange brûlé -> (255,143,23))
    #   projetées sur y = 0..152, puis horizon ardent (255,143,23) sur y = 152..sy_max autour du Soleil canonique !
    grad_top_h = min(sy_max, 152)
    grad_col = np.asarray(
        Image.fromarray(sky_row_med[:196, None, :]).resize((1, grad_top_h), Image.Resampling.NEAREST),
        dtype=np.uint8,
    )[:, 0, :]  # (grad_top_h, 3)

    grad_full = np.zeros((sy_max, W, 3), dtype=np.uint8)
    grad_full[:grad_top_h, :, :] = grad_col[:, None, :]
    if sy_max > grad_top_h:
        grad_full[grad_top_h:, :, :] = (255, 143, 23)

    sub_m = sky_mask[:sy_max, :]
    sky_clean = _sanitize_rgb_no_magenta(grad_full, sub_m)
    sky_arr = np.zeros((H, W, 4), dtype=np.uint8)
    sky_arr[:sy_max, :][sub_m, :3] = sky_clean[sub_m]
    sky_arr[:sy_max, :][sub_m, 3] = 255
    # Ajoute toutes les étoiles fixes natives D07P02 sur le cosmos indigo supérieur (y = 2..106)
    _blit_native_star_band_768(sky_arr, static_stars_312, sky_mask, max_y_dst=106)
    starry_sunset_static_1 = [Image.fromarray(sanitize_rgba_binary(sky_arr))]

    # Plan lointain de nuages PMD du couchant (16 px/pose, période 384 px, derrière le Soleil canonique)
    far_placements = [
        (fams_far["strato"][0], 18, 138),
        (fams_far["wisps"][0], 128, 156),
        (fams_far["strato"][1], 212, 142),
        (fams_far["wisps"][1], 320, 130),
    ]
    clouds_sunset_far_24 = _render_wrapping_cloud_band(
        far_placements, period_w=384, shift_per_pose=16, sky_mask=sky_mask, single_pose_preview=single_pose_preview
    )

    # Plan médian de familles de cumulus PMD du couchant (32 px/pose, période 768 px, y = 104..150
    # pile dans la bande crépusculaire pourpre-ambre, sous l'étoile filante et au-dessus du Soleil canonique !)
    near_placements = [
        (fams_near["mediums"][0], 26, 108),
        (fams_near["strato"][0], 184, 124),
        (fams_near["mediums"][2], 472, 104),
        (fams_near["mediums"][1], 628, 112),
    ]
    clouds_sunset_near_24 = _render_wrapping_cloud_band(
        near_placements, period_w=768, shift_per_pose=32, sky_mask=sky_mask, single_pose_preview=single_pose_preview
    )

    # Calque canonique : Soleil animé D07P02 (x=284..484, y=150..216) + étoiles scintillantes & étoile filante A04P011.bpa
    n_iter = 1 if single_pose_preview else N_POSES
    sun_stars_24: List[Image.Image] = []
    breeze_24: List[Image.Image] = []
    rng_em = np.random.default_rng(770702)
    n_motes = 26
    em_x0 = rng_em.integers(24, W - 24, size=n_motes)
    em_y0 = rng_em.integers(228, H - 28, size=n_motes)
    em_ph = rng_em.uniform(0.0, 2.0 * math.pi, size=n_motes)

    y0_sun, x0_sun = 150, 384 - 100
    for f in range(n_iter):
        theta = 2.0 * math.pi * f / float(N_POSES)
        bpa_idx = (f // 2) % 12

        cel = np.zeros((H, W, 4), dtype=np.uint8)
        # 1) Étoiles scintillantes natives + étoile filante diagonale (frames 3..8) dans le cosmos indigo
        _blit_native_star_band_768(cel, anim_stars_12[bpa_idx], sky_mask, max_y_dst=106)

        # 2) Soleil animé canonique de D07P02 posé sur l'horizon central des mesas (sans aucun halo ovale !)
        sp_sun = sun_12_2x[bpa_idx]
        y1_sun = min(H, y0_sun + sp_sun.shape[0])
        hs = y1_sun - y0_sun
        keep_s = (sp_sun[:hs, :, 3] == 255) & sky_mask[y0_sun:y1_sun, x0_sun : x0_sun + 200]
        sub_dst = cel[y0_sun:y1_sun, x0_sun : x0_sun + 200]
        sub_dst[keep_s, :3] = sp_sun[:hs, :, :3][keep_s]
        sub_dst[keep_s, 3] = 255
        sun_stars_24.append(Image.fromarray(sanitize_rgba_binary(cel)))

        # 3) Fines poussières d'or thermiques s'élevant le long du promontoire (sans rayons en éventail !)
        top_fx = np.zeros((H, W, 4), dtype=np.uint8)
        if not single_pose_preview:
            for i in range(n_motes):
                mx = int((em_x0[i] + f * 32) % (W - 16)) + 8
                my = int(round(em_y0[i] + 4.0 * math.sin(theta + em_ph[i])))
                if 4 <= mx < W - 4 and 220 <= my < H - 4 and (not sky_mask[my, mx]):
                    if math.sin(2.0 * theta + em_ph[i]) > 0.05:
                        top_fx[my, mx] = (255, 232, 152, 255)
        breeze_24.append(Image.fromarray(sanitize_rgba_binary(top_fx)))

    return starry_sunset_static_1, clouds_sunset_far_24, sun_stars_24, clouds_sunset_near_24, breeze_24
