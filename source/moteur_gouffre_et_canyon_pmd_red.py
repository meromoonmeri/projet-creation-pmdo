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

    # Sur GCF1 (Colline des Anciens / Xatu), on décale le panorama de +80 px vers le bas pour ouvrir
    # 180 px de ciel étoilé + coucher de soleil + Soleil d'or D07P02 au-dessus de l'horizon des mesas !
    if mode == "hill_of_ancients":
        shift_y = 80
        shifted_rgb = np.tile(PURE_MAGENTA, (H, W, 1))
        shifted_solid = np.zeros((H, W), dtype=bool)
        shifted_rgb[shift_y:, :] = rgb_768[: H - shift_y, :]
        shifted_solid[shift_y:, :] = solid_768[: H - shift_y, :]
        rgb_768 = shifted_rgb
        solid_768 = shifted_solid

    # Absorption itérative (jusqu'à 7 px) de toute frange rose/prune/bordeaux collée aux zones #FF00FF
    yy7, xx7 = np.mgrid[0:H, 0:W]
    not_bridge = ~((mode == "great_canyon_entry") & (xx7 >= 270) & (xx7 <= 500) & (yy7 >= 340) & (yy7 <= 490))
    r7, g7, b7 = rgb_768[:, :, 0].astype(np.int16), rgb_768[:, :, 1].astype(np.int16), rgb_768[:, :, 2].astype(np.int16)
    for _ in range(7):
        adj_mag = ndimage.binary_dilation(~solid_768, iterations=1)
        rim = (
            solid_768
            & adj_mag
            & not_bridge
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
        top_mask = solid_768 & (yy7 < 118) & ((xx7 < 312) | (xx7 > 456)) & (r16 >= 135)
    else:
        top_mask = solid_768 & ((xx7 < 108) | (xx7 > W - 108)) & (yy7 >= 150) & (yy7 <= 340)

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
        sky_m = mag_768 & (yy7 < 140)
        wat_m = mag_768 & (~sky_m)
        sky0, hor0, _ = build_great_canyon_sky_and_top_layers(sky_m, rgb_768, single_pose_preview=True)
        for lay_im in (sky0[0], hor0[0]):
            la = np.asarray(lay_im, dtype=np.uint8)
            m = (la[:, :, 3] == 255) & sky_m
            ref_rgb[m] = la[m, :3]
        ref_rgb[wat_m] = np.array([131, 218, 230], dtype=np.uint8)
    else:
        sky_m = mag_768 & (yy7 < 250)
        aby_m = mag_768 & (~sky_m)
        sky0, sun0, cld0, _, _ = build_hill_of_ancients_layers(sky_m, aby_m, rgb_768, single_pose_preview=True)
        for lay_im in (sky0[0], sun0[0], cld0[0]):
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


def build_great_canyon_sky_and_top_layers(
    sky_mask: np.ndarray,
    base_rgb: np.ndarray,
    single_pose_preview: bool = False,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit `(sky_24, cumulus_24, top_sun_dust_24)` pour `GCE1` (*Great Canyon — Entrée D07P01*)."""
    bayer01 = np.tile(BAYER_4X4, (H // 4 + 1, W // 4 + 1))[:H, :W]
    ray_p = REPO_ROOT / "source" / "reshiram_montagne_entree_v1" / "bruts" / "rayons_lumiere_friend_area_pmd_red_magenta.png"
    ray_raw = np.asarray(Image.open(ray_p).convert("RGB"), dtype=np.uint8)
    rr, rg, rb = ray_raw[:, :, 0].astype(np.float32), ray_raw[:, :, 1].astype(np.float32), ray_raw[:, :, 2].astype(np.float32)
    rmag = (rr > 70.0) & (rb > 70.0) & (rr > rg * 1.35) & (rb > rg * 1.35)
    rfg = ~(rmag | (ndimage.binary_dilation(rmag, iterations=2) & (rr > rg * 1.05) & (rb > rg * 1.05)))
    ray_cov = np.asarray(Image.fromarray((rfg[365:815, 290:1035] * 255).astype(np.uint8)).resize((272, 180), Image.Resampling.BOX), dtype=np.float32) / 255.0

    rng = np.random.default_rng(70701)
    n_dust = 24
    dx0 = rng.integers(32, W - 32, size=n_dust)
    dy0 = rng.integers(40, H - 48, size=n_dust)
    dph = rng.uniform(0.0, 2.0 * math.pi, size=n_dust)

    sy_max = min(H, (int(np.where(sky_mask)[0].max()) + 2) if np.any(sky_mask) else 110)
    s_yy, s_xx = np.mgrid[0:sy_max, 0:W].astype(np.float32)
    t_y = np.clip(s_yy / max(float(sy_max), 1.0), 0.0, 1.0)

    n_iter = 1 if single_pose_preview else N_POSES
    sky_out: List[Image.Image] = []
    cum_out: List[Image.Image] = []
    top_out: List[Image.Image] = []

    for f in range(n_iter):
        theta = 2.0 * math.pi * f / float(N_POSES)
        # Ciel désertique H06P05 : bleu azur ardent en haut -> jaune-ambre chaud sur la crête des mesas
        shimmer = 10.0 * np.cos(theta - 0.009 * s_xx)
        r_s = 92.0 + 148.0 * (t_y**0.85) + shimmer * 0.9
        g_s = 168.0 + 64.0 * (t_y**0.90) + shimmer * 0.7
        b_s = 236.0 - 92.0 * (t_y**0.95) + shimmer * 0.3
        sub_m = sky_mask[:sy_max, :]
        s_rgb = _sanitize_rgb_no_magenta(_q8_u8(np.stack([r_s, g_s, b_s], axis=-1)), sub_m)

        sky = np.zeros((H, W, 4), dtype=np.uint8)
        sky[:sy_max, :][sub_m, :3] = s_rgb[sub_m]
        sky[:sy_max, :][sub_m, 3] = 255
        sky_out.append(Image.fromarray(sanitize_rgba_binary(sky)))

        # Cumulus dorés style H06P05 (Scorched Plains) dérivant doucement à l'horizon
        cum = np.zeros((H, W, 4), dtype=np.uint8)
        cx_shift = (s_xx + f * 32.0) % float(W)
        cloud_h = (
            sy_max * 0.56
            - 16.0 * np.exp(-(((cx_shift - 180.0) / 78.0) ** 2))
            - 18.0 * np.exp(-(((cx_shift - 580.0) / 84.0) ** 2))
            + 5.0 * np.sin(cx_shift * 0.09)
        )
        in_cld = sub_m & (s_yy >= cloud_h)
        in_rim = in_cld & (s_yy <= cloud_h + 6.0)
        cum[:sy_max, :][in_cld] = (248, 216, 144, 255)
        cum[:sy_max, :][in_rim] = (255, 240, 192, 255)
        cum_out.append(Image.fromarray(sanitize_rgba_binary(cum)))

        # Rayons solaires chauds sur les mesas + poussière d'ocre dans le vent chaud
        top_fx = np.zeros((H, W, 4), dtype=np.uint8)
        if not single_pose_preview:
            rh_f, rw_f = ray_cov.shape
            taper = np.clip(1.18 - np.arange(rh_f, dtype=np.float32)[:, None] / float(rh_f), 0.0, 1.0)
            breath = 0.92 + 0.16 * math.cos(theta)
            sweep = int(round(9.0 * math.cos(theta)))
            for base_rx0 in (16, 480):
                rx0 = max(0, min(W - rw_f, base_rx0 + sweep))
                inten = ray_cov * taper * breath
                on_mesa = ~sky_mask[:rh_f, rx0 : rx0 + rw_f]
                xg = np.arange(rx0, rx0 + rw_f)[None, :]
                on_mesa = on_mesa & ~((xg >= 316) & (xg <= 452))
                by_s = bayer01[:rh_f, rx0 : rx0 + rw_f]
                r_hi = on_mesa & (inten > 0.44)
                r_lo = on_mesa & (~r_hi) & (inten > 0.22) & ((inten * 2.2) > by_s)
                b_sub = base_rgb[:rh_f, rx0 : rx0 + rw_f].astype(np.int16)
                lit = b_sub.copy()
                lit[r_hi] = np.clip(b_sub[r_hi] + np.array([44, 34, 14], dtype=np.int16), 0, 255)
                lit[r_lo] = np.clip(b_sub[r_lo] + np.array([24, 18, 8], dtype=np.int16), 0, 255)
                hit = r_hi | r_lo
                lit_q = _sanitize_rgb_no_magenta(((lit // 8) * 8).clip(0, 255).astype(np.uint8), hit)
                sub_t = top_fx[:rh_f, rx0 : rx0 + rw_f]
                sub_t[hit, :3] = lit_q[hit]
                sub_t[hit, 3] = 255

            for i in range(n_dust):
                mx = int((dx0[i] + f * 32) % (W - 16)) + 8
                my = int(round(dy0[i] + 5.0 * math.sin(theta + dph[i])))
                if 4 <= mx < W - 4 and 4 <= my < H - 4 and math.sin(2.0 * theta + dph[i]) > -0.2:
                    top_fx[my, mx : mx + 2] = (255, 232, 168, 255)
        top_out.append(Image.fromarray(sanitize_rgba_binary(top_fx)))

    return sky_out, cum_out, top_out


def build_hill_of_ancients_layers(
    sky_mask: np.ndarray,
    abyss_mask: np.ndarray,
    base_rgb: np.ndarray,
    single_pose_preview: bool = False,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit `(starry_sunset_24, xatu_sun_24, canyon_clouds_24, solar_embers_24, solar_corona_top_24)`
    pour `GCF1` (*Colline des Anciens / Xatu*, `D07P02` + `A04P011.bpa` + `D07P02.bpl`)."""
    d07_frames = _load_d07p02_sunset_12frames()  # 12 x (236, 312, 3)
    fog_tile = _load_d05p01_fog_tile_768()
    bayer01 = np.tile(BAYER_4X4, (H // 4 + 1, W // 4 + 1))[:H, :W]

    sy_max = min(H, (int(np.where(sky_mask)[0].max()) + 2) if np.any(sky_mask) else 200)
    # Profil vertical exact du ciel D07P02 prélevé sur la colonne x=24 (hors étoiles/soleil) de la pose 0 :
    ref0 = d07_frames[0]  # (236, 312, 3)
    # On adapte les 230 premières lignes de D07P02 sur [0 .. 184] pour caler l'horizon pile sur les mesas (y~165..184)
    sky_h_target = min(sy_max, 192)
    grad_col = np.asarray(
        Image.fromarray(ref0[:228, 18:26, :]).resize((1, sky_h_target), Image.Resampling.BILINEAR),
        dtype=np.float32,
    )[:, 0, :]  # (sky_h_target, 3)

    # Constellations d'étoiles pixel-art sur la bande indigo supérieure (y = 6..82)
    rng_st = np.random.default_rng(210702)
    n_stars = 46
    st_x = rng_st.integers(18, W - 18, size=n_stars)
    st_y = rng_st.integers(6, 82, size=n_stars)
    st_ph = rng_st.uniform(0.0, 2.0 * math.pi, size=n_stars)
    st_cross = rng_st.integers(0, 3, size=n_stars) == 0

    rng_em = np.random.default_rng(770702)
    n_embers = 32
    em_x0 = rng_em.integers(16, W - 16, size=n_embers)
    em_y0 = rng_em.integers(260, H - 16, size=n_embers)
    em_ph = rng_em.uniform(0.0, 2.0 * math.pi, size=n_embers)

    dist_aby = ndimage.distance_transform_edt(abyss_mask)

    n_iter = 1 if single_pose_preview else N_POSES
    sky_out: List[Image.Image] = []
    sun_out: List[Image.Image] = []
    cld_out: List[Image.Image] = []
    emb_out: List[Image.Image] = []
    top_out: List[Image.Image] = []

    yy_s, xx_s = np.mgrid[0:sy_max, 0:W].astype(np.float32)

    for f in range(n_iter):
        theta = 2.0 * math.pi * f / float(N_POSES)
        bpa_idx = (f // 2) % 12  # 12 frames BPA A04P011 x 2 poses (10 ticks) = 24 poses exactes !

        # --- Calque 00 : Ciel Crépusculaire Étoilé Natif D07P02 (Indigo profond -> Ambre ardent) ---
        sky = np.zeros((H, W, 4), dtype=np.uint8)
        sub_m = sky_mask[:sy_max, :]
        grad_full = np.zeros((sy_max, W, 3), dtype=np.float32)
        grad_full[:sky_h_target, :, :] = grad_col[:, None, :]
        if sy_max > sky_h_target:
            grad_full[sky_h_target:, :, :] = grad_col[-1, None, None, :]
        # Respiration solaire chaude autour de x=384 près de l'horizon
        glow_x = np.exp(-(((xx_s - 384.0) / 210.0) ** 2)) * np.clip((yy_s - 72.0) / 100.0, 0.0, 1.0)
        pulse_s = 12.0 * math.cos(theta) + 18.0 * glow_x
        grad_full[:, :, 0] = np.clip(grad_full[:, :, 0] + pulse_s * 1.0, 0.0, 255.0)
        grad_full[:, :, 1] = np.clip(grad_full[:, :, 1] + pulse_s * 0.65, 0.0, 255.0)
        s_q = _sanitize_rgb_no_magenta(_q8_u8(grad_full), sub_m)
        sky[:sy_max, :][sub_m, :3] = s_q[sub_m]
        sky[:sy_max, :][sub_m, 3] = 255

        # Scintillement doux des étoiles de D07P02 dans le cosmos indigo supérieur
        for i in range(n_stars):
            sx, sy = int(st_x[i]), int(st_y[i])
            if sy < sy_max and sub_m[sy, sx]:
                tw = math.sin(theta * (2.0 if st_cross[i] else 1.0) + st_ph[i])
                if tw > -0.35:
                    sky[sy, sx] = (248, 248, 255, 255) if tw > 0.25 else (168, 176, 224, 255)
                    if st_cross[i] and tw > 0.45:
                        for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                            if 0 <= sy + dy < sy_max and 0 <= sx + dx < W and sub_m[sy + dy, sx + dx]:
                                sky[sy + dy, sx + dx] = (144, 160, 224, 255)
        sky_out.append(Image.fromarray(sanitize_rgba_binary(sky)))

        # --- Calque 01 : Soleil d'Or Scintillant authentique A04P011.bpa + D07P02.bpl à x=384 ---
        sun = np.zeros((H, W, 4), dtype=np.uint8)
        nat_f = d07_frames[bpa_idx]
        # Découpe la boîte exacte du Soleil natif (y=194..230, x=108..208 -> 100x36) et l'agrandit 2x NEAREST (200x72)
        sun_crop = nat_f[194:230, 108:208, :]
        sun_2x = np.asarray(
            Image.fromarray(sun_crop).resize((200, 72), Image.Resampling.NEAREST),
            dtype=np.uint8,
        )
        sr, sg, sb = sun_2x[:, :, 0].astype(np.int16), sun_2x[:, :, 1].astype(np.int16), sun_2x[:, :, 2].astype(np.int16)
        # Disque solaire doré (R>=245, G>=185, B<=115) :
        is_sun_disc = (sr >= 244) & (sg >= 182) & (sb <= 120)
        # Positionne le Soleil juste derrière la crête des mesas centrales (y = 114..186, x = 284..484)
        y0_sun, x0_sun = 114, 384 - 100
        y1_sun = min(sy_max, y0_sun + 72)
        h_s = y1_sun - y0_sun
        if h_s > 0:
            sub_sky_s = sub_m[y0_sun:y1_sun, x0_sun : x0_sun + 200]
            keep_sun = is_sun_disc[:h_s, :] & sub_sky_s
            # Halo ambré concentrique complet (sans aucune corde coupée en haut !) autour du Soleil
            halo_dist = np.sqrt(((xx_s - 384.0) / 1.32) ** 2 + ((yy_s - 166.0) * 1.28) ** 2)
            in_halo = sub_m & (halo_dist <= 108.0 + 6.0 * math.sin(theta)) & (yy_s >= 40.0)
            in_inner = sub_m & (halo_dist <= 76.0 + 4.0 * math.cos(theta)) & (yy_s >= 48.0)
            sun[:sy_max, :][in_halo] = (248, 144, 24, 255)
            sun[:sy_max, :][in_inner] = (255, 184, 48, 255)
            sun_sub = sun[y0_sun:y1_sun, x0_sun : x0_sun + 200]
            sun_rgb_clean = _sanitize_rgb_no_magenta(sun_2x[:h_s, :, :], keep_sun)
            sun_sub[keep_sun, :3] = sun_rgb_clean[keep_sun]
            sun_sub[keep_sun, 3] = 255
        sun_out.append(Image.fromarray(sanitize_rgba_binary(sun)))

        # --- Calque 02 : Mer de Nuages Ambrés dans les 2 Abysses du Canyon (y >= 250) ---
        cld = np.zeros((H, W, 4), dtype=np.uint8)
        if np.any(abyss_mask):
            d_n = np.clip(dist_aby / 38.0, 0.0, 1.0)
            f1 = np.roll(fog_tile, shift=(f * 32) % W, axis=1)
            f2 = np.roll(fog_tile[::-1, :], shift=-((f * 32) % W), axis=1)
            fm = np.clip(0.65 * np.vstack([f1, f1])[:H, :] + 0.50 * np.vstack([f2, f2])[:H, :], 0.0, 1.0)
            val = fm * (0.86 + 0.16 * math.cos(theta)) * (0.30 + 0.70 * d_n)
            deep_canyon = np.array([88.0, 40.0, 28.0])
            gold_cloud = np.array([248.0, 176.0, 88.0])
            c_f = deep_canyon[None, None, :] * (1.0 - val[:, :, None]) + gold_cloud[None, None, :] * val[:, :, None]
            c_q = _sanitize_rgb_no_magenta(_q8_u8(c_f), abyss_mask)
            c_q[abyss_mask & (dist_aby <= 4.0)] = (64, 28, 20)
            cld[abyss_mask, :3] = c_q[abyss_mask]
            cld[abyss_mask, 3] = 255
        cld_out.append(Image.fromarray(sanitize_rgba_binary(cld)))

        # --- Calque 03 : Paillettes Solaires Ascendantes dans les Abysses ---
        emb = np.zeros((H, W, 4), dtype=np.uint8)
        for i in range(n_embers):
            ex = int(round(em_x0[i] + 7.0 * math.sin(theta + em_ph[i])))
            ey = int((em_y0[i] - f * 2) % (H - 270)) + 260
            if 6 <= ex < W - 6 and 6 <= ey < H - 6 and abyss_mask[ey, ex] and dist_aby[ey, ex] >= 5.5:
                if math.sin(2.0 * theta + em_ph[i]) > -0.1:
                    emb[ey, ex : ex + 2] = (255, 232, 128, 255)
        emb_out.append(Image.fromarray(sanitize_rgba_binary(emb)))

        # --- Calque 09 Top : Couronne de Rayons Solaires de Xatu & Poussière d'Or ---
        top_fx = np.zeros((H, W, 4), dtype=np.uint8)
        if not single_pose_preview:
            yg, xg = np.mgrid[140:340, 0:W].astype(np.float32)
            dx_s = xg - 384.0
            dy_s = yg - 162.0
            ang = np.arctan2(dy_s, dx_s)
            rad = np.sqrt(dx_s**2 + dy_s**2)
            # Éventail de rayons dorés émanant du Soleil vers les mesas et le belvédère
            fan = np.maximum(0.0, np.cos(ang * 7.0 + 0.35 * math.sin(theta))) ** 4
            inten = fan * np.clip(1.0 - rad / 250.0, 0.0, 1.0) * (0.85 + 0.20 * math.cos(theta))
            on_rock = (~sky_mask[140:340, :]) & (~abyss_mask[140:340, :])
            by_r = bayer01[140:340, :]
            hit_r = on_rock & (inten > 0.24) & ((inten * 2.1) > by_r)
            b_sub = base_rgb[140:340, :].astype(np.int16)
            lit = b_sub.copy()
            lit[hit_r] = np.clip(b_sub[hit_r] + np.array([40, 28, 8], dtype=np.int16), 0, 255)
            lit_q = _sanitize_rgb_no_magenta(((lit // 8) * 8).clip(0, 255).astype(np.uint8), hit_r)
            sub_t = top_fx[140:340, :]
            sub_t[hit_r, :3] = lit_q[hit_r]
            sub_t[hit_r, 3] = 255

            for i in range(18):
                mx = int((em_x0[i] + f * 32) % (W - 16)) + 8
                my = 190 + (i * 19) % 340
                if math.sin(theta + em_ph[i]) > 0.15:
                    top_fx[my, mx] = (255, 240, 168, 255)
        top_out.append(Image.fromarray(sanitize_rgba_binary(top_fx)))

    return sky_out, sun_out, cld_out, emb_out, top_out
