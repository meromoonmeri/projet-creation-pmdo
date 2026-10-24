#!/usr/bin/env python3
"""Moteur partagé multicalque PMDO 0.8.12.0 pour les forêts canoniques de *PMD Red Rescue Team* :
  - Duo **Tiny Woods (*Petit Bois*, `D01P01` / `D01P02` + `H07P06` *Healing Forest*)** : `TWE1` & `TWF1`
  - Duo **Sinister Woods (*Bois Sinistre*, `D04P01` / `D04P02` + `H07P08` *Secretive* & `H07P01` *Mist-Rise*)** : `SWE1` & `SWF1`

Implémente strictement `METHODE_MAGENTA_ET_GENERATEUR.md` & `GUIDE_CREATION_DE_MAP.md` :
  1. Détourage `#FF00FF` par graine pure (`area >= 300 px`) + absorption complète de l'ombre magenta de berge (`12 px`),
     sans toucher aux champignons violets/rouges ni aux fleurs ;
  2. Réduction par moyenne pondérée par classe (`BOX` sans mélange fond/décor) vers `768 × 576` (`96 × 72` tuiles `8 px`) ;
  3. Quantification `96` couleurs (`88` `MEDIANCUT` `dither=NONE` + `8` teintes d'accent Chunsoft exactes pour les
     champignons écarlates/indigo de `D04P01`/`H07P05` et fleurs corail/or de `D01P01`) ;
  4. Ciels et effets atmosphériques générés style **Friend Area PMD Red** (`H05P02`/`H07P06` rayons solaires dorés
     pour *Tiny Woods* ; `H07P08`/`H07P01` ciel crépusculaire & rubans de brume spectrale à fondu vertical doux pour *Sinister Woods*) ;
  5. Eau courante / bassins de source animés `4 × 10` ticks + reflets natifs `Metano_Town_River_Sparkles.tile`
     distribués sur toute la carte (`0 px` d'écume parasite sur les berges, alpha strictement binaire `{0, 255}`).
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

REPO_ROOT = Path(__file__).resolve().parent.parent
PURE_MAGENTA = np.array([255, 0, 255], dtype=np.uint8)

BAYER_4X4 = (
    np.array(
        [
            [0, 8, 2, 10],
            [12, 4, 14, 6],
            [3, 11, 1, 9],
            [15, 7, 13, 5],
        ],
        dtype=np.float32,
    )
    / 16.0
)


def _q8_u8(arr_f32: np.ndarray) -> np.ndarray:
    """Quantifie par pas de 8 avec saturation stricte `[0, 255]` (aucun débordement `256 -> 0` en `uint8`)."""
    return np.clip(np.round(arr_f32 / 8.0) * 8.0, 0.0, 255.0).astype(np.uint8)


def _sanitize_rgb_no_magenta(rgb: np.ndarray, mask: np.ndarray) -> np.ndarray:
    """Garantit `min(R, B) - G <= 33` sur tous les pixels solides (zéro faux positif `#FF00FF`)."""
    out = rgb.copy()
    r = out[:, :, 0].astype(np.int32)
    g = out[:, :, 1].astype(np.int32)
    b = out[:, :, 2].astype(np.int32)
    gap = np.minimum(r, b) - g
    bad = mask & (gap >= 34)
    if np.any(bad):
        # Si B > R (violet froid), on baisse R pour garder un vrai bleu-indigo ; sinon on baisse B
        violet_like = bad & (b > r + 10)
        warm_like = bad & (~violet_like)
        if np.any(violet_like):
            out[:, :, 0][violet_like] = np.clip(g[violet_like] + 26, 0, 255).astype(np.uint8)
        if np.any(warm_like):
            excess = gap[warm_like] - 32
            out[:, :, 2][warm_like] = np.clip(b[warm_like] - excess, 0, 255).astype(np.uint8)
    return out


def _downsample_non_mixing(arr_rgb: np.ndarray, fg_mask: np.ndarray, out_w: int = W, out_h: int = H) -> Tuple[np.ndarray, np.ndarray]:
    """Réduction uniforme `BOX` sans mélange entre le décor solide (`fg_mask`) et le fond `#FF00FF`."""
    w_img = Image.fromarray((fg_mask.astype(np.float32) * 255.0).astype(np.uint8), mode="L")
    w_low = np.asarray(w_img.resize((out_w, out_h), Image.Resampling.BOX), dtype=np.float32) / 255.0
    fg_low = w_low >= 0.52

    out_rgb = np.zeros((out_h, out_w, 3), dtype=np.uint8)
    denom = np.maximum(w_low, 1e-4)
    for c in range(3):
        num_img = Image.fromarray((arr_rgb[:, :, c].astype(np.float32) * fg_mask).astype(np.uint8), mode="L")
        num_low = np.asarray(num_img.resize((out_w, out_h), Image.Resampling.BOX), dtype=np.float32)
        ch = np.clip(np.round(num_low / denom), 0, 255).astype(np.uint8)
        out_rgb[:, :, c] = ch

    out_rgb[~fg_low] = PURE_MAGENTA
    return out_rgb, fg_low


def _keep_compact_blobs(mask: np.ndarray, max_area: int = 380) -> np.ndarray:
    """Ne conserve que les petites taches compactes (fleurs / chapeaux de champignons), jamais une bande de berge."""
    if not np.any(mask):
        return mask
    lbl, _ = ndimage.label(mask)
    sizes = np.bincount(lbl.ravel())
    keep = (sizes >= 2) & (sizes <= max_area)
    keep[0] = False
    return keep[lbl]


def _quantize_solid_96c(rgb: np.ndarray, solid_mask: np.ndarray, mode: str) -> np.ndarray:
    """Quantifie le décor solide sur `<= 96` couleurs (`88` `MEDIANCUT` + accents floraux/champignons Chunsoft préservés)."""
    work = rgb.copy()
    r0 = work[:, :, 0].astype(np.int16)
    g0 = work[:, :, 1].astype(np.int16)
    b0 = work[:, :, 2].astype(np.int16)

    yy = np.arange(rgb.shape[0])[:, None]
    wat_m = (~solid_mask) & (yy >= 160)
    near_water = ndimage.binary_dilation(wat_m, iterations=10)
    interior_solid = solid_mask & (~near_water)

    med_col = np.median(work[solid_mask], axis=0).astype(np.uint8)
    work[~solid_mask] = med_col
    q_im = Image.fromarray(work, mode="RGB").quantize(colors=88, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    out = np.asarray(q_im.convert("RGB"), dtype=np.uint8).copy()

    # Préserver uniquement les petites taches compactes de fleurs/champignons hors berges d'eau :
    if mode == "sinister_woods_mist":
        # 1) Chapeaux de champignons écarlates D04P01 (2 tons : lumière & ombre)
        red_all = _keep_compact_blobs(interior_solid & (r0 >= 125) & (r0 > g0 + 42) & (r0 > b0 + 30), max_area=420)
        red_cap_hi = red_all & (r0 >= 182)
        red_cap_lo = red_all & (~red_cap_hi)
        out[red_cap_hi] = (220, 56, 48)
        out[red_cap_lo] = (164, 36, 36)
        # 2) Chapeaux de champignons indigo-violet H07P05 ([98, 60, 150] -> royal indigo [116,92,216]/[88,68,172])
        vio_all = _keep_compact_blobs(
            interior_solid & (~red_all) & (b0 >= 118) & (r0 >= 78) & (b0 > g0 + 36) & (r0 > g0 + 16),
            max_area=420,
        )
        vio_cap_hi = vio_all & (b0 >= 145)
        vio_cap_lo = vio_all & (~vio_cap_hi)
        out[vio_cap_hi] = (116, 92, 216)
        out[vio_cap_lo] = (88, 68, 172)
        # 3) Points bioluminescents ambrés H07P01 sur la souche creuse
        glow_hi = _keep_compact_blobs(interior_solid & (r0 >= 230) & (g0 >= 180) & (b0 >= 115) & (r0 > b0 + 35), max_area=180)
        out[glow_hi] = (252, 216, 136)
    else:
        # Pétales corail-rose & boutons d'or de Tiny Woods / Sky Peak (uniquement petits bouquets <= 260 px, hors berges !)
        pink_fl = _keep_compact_blobs(interior_solid & (r0 >= 205) & (r0 > g0 + 35) & (b0 >= 125), max_area=260)
        gold_fl = _keep_compact_blobs(interior_solid & (r0 >= 225) & (g0 >= 195) & (b0 <= 125), max_area=260)
        out[pink_fl] = (240, 148, 172)
        out[gold_fl] = (248, 216, 88)

    out = _sanitize_rgb_no_magenta(out, solid_mask)
    out[~solid_mask] = PURE_MAGENTA
    return out


def assemble_foret_pmd_red_1x(
    gen_path: Path,
    out_brut_path: Path,
    out_canopy_path: Path,
    out_ref_canon_path: Path,
    mode: str,
) -> Dict[str, str]:
    """Transforme le brut haute résolution `generate_image` (`#FF00FF`) en brut `768 × 576` propre + canopée `Top` + `ref_canon`."""
    raw = np.asarray(Image.open(gen_path).convert("RGB"), dtype=np.uint8)
    rf, gf, bf = raw[:, :, 0].astype(np.float32), raw[:, :, 1].astype(np.float32), raw[:, :, 2].astype(np.float32)

    # Graine #FF00FF stricte (aire >= 300 px) + absorption complète de l'ombre prune/bordeaux de berge (jusqu'à 14 px)
    core = (rf >= 220.0) & (gf <= 50.0) & (bf >= 220.0)
    lbl_c, _ = ndimage.label(core)
    sizes = np.bincount(lbl_c.ravel())
    keep_c = sizes >= 300
    keep_c[0] = False
    valid_core = keep_c[lbl_c]
    near_mag = ndimage.binary_dilation(valid_core, iterations=14)
    # Absorbe à la fois la frange AA rose et la bande d'ombre prune foncée (R > G*1.32 et B > G*1.18) collée à l'eau
    fringe = near_mag & (rf > 1.28 * gf + 8.0) & (bf > 1.15 * gf + 8.0)
    mag_hi = valid_core | fringe
    fg_hi = ~mag_hi

    rgb_768, solid_768 = _downsample_non_mixing(raw, fg_hi, W, H)
    # Nettoyage complet (jusqu'à 7 px itératifs) de toute bande rose/prune/bordeaux collée à l'eau (hors pont de bois)
    yy7, xx7 = np.mgrid[0:H, 0:W]
    not_bridge = ~((xx7 >= 324) & (xx7 <= 444) & (yy7 >= 268) & (yy7 <= 390))
    r7, g7, b7 = rgb_768[:, :, 0].astype(np.int16), rgb_768[:, :, 1].astype(np.int16), rgb_768[:, :, 2].astype(np.int16)
    for _ in range(7):
        wat7 = (~solid_768) & (yy7 >= 180)
        adj_wat = ndimage.binary_dilation(wat7, iterations=1)
        pink_or_plum_rim = (
            solid_768
            & adj_wat
            & not_bridge
            & (
                ((r7 > g7 + 22) & (b7 > g7 + 12))
                | ((r7 >= 185) & (r7 > g7 + 35) & (b7 >= 115))
                | ((r7 >= 110) & (r7 > g7 + 45) & (b7 >= 55) & (g7 < 95))
            )
        )
        if not np.any(pink_or_plum_rim):
            break
        solid_768 = solid_768 & (~pink_or_plum_rim)

    rgb_768 = _quantize_solid_96c(rgb_768, solid_768, mode=mode)
    mag_768 = ~solid_768

    out_brut_path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(rgb_768, mode="RGB").save(out_brut_path)

    # Extraction de la canopée supérieure des arbres (`Layer 09 Top`)
    yy, xx = np.mgrid[0:H, 0:W]
    r16 = rgb_768[:, :, 0].astype(np.int16)
    g16 = rgb_768[:, :, 1].astype(np.int16)
    b16 = rgb_768[:, :, 2].astype(np.int16)

    if mode == "tiny_woods_sunlit":
        is_foliage = solid_768 & (g16 >= 95) & (g16 > r16 + 38) & (r16 <= 115) & (b16 <= 115)
    else:
        is_foliage = solid_768 & (b16 >= 95) & (g16 >= 70) & (r16 <= 65)

    perim_zone = (yy < 115) | (xx < 155) | (xx > W - 155) | ((yy > 435) & (np.abs(xx - W // 2) > 95))
    not_central_portal = ~((xx >= 296) & (xx <= 472) & (yy >= 52) & (yy <= 215))
    canopy_mask = is_foliage & perim_zone & not_central_portal
    below_non_foliage = ndimage.binary_dilation(
        ~is_foliage,
        structure=np.array([[0, 1, 0], [0, 1, 0], [0, 0, 0]], dtype=bool),
        iterations=10,
    )
    canopy_top_mask = canopy_mask & (~below_non_foliage | (yy < 72))

    canopy_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    canopy_rgba[canopy_top_mask, :3] = rgb_768[canopy_top_mask]
    canopy_rgba[canopy_top_mask, 3] = 255
    out_canopy_path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(canopy_rgba, mode="RGBA").save(out_canopy_path)

    # Référence composite `ref_canon`
    ref_rgb = rgb_768.copy()
    sky_m = mag_768 & (yy < 96)
    wat_m = mag_768 & (~sky_m)
    assets = _load_forest_sky_and_fx_assets(mode)
    sky_strip: np.ndarray = assets["sky_strip"]  # type: ignore[assignment]
    sh = min(H, sky_strip.shape[0])
    sky_top = sky_m.copy()
    sky_top[sh:, :] = False
    ref_rgb[sky_top] = sky_strip[:sh, :][sky_top[:sh, :]]
    if mode == "tiny_woods_sunlit":
        ref_rgb[wat_m] = np.array([124, 212, 228], dtype=np.uint8)
    else:
        ref_rgb[wat_m] = np.array([42, 146, 166], dtype=np.uint8)
    out_ref_canon_path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(ref_rgb, mode="RGB").save(out_ref_canon_path)

    return {
        "brut": str(out_brut_path),
        "canopy": str(out_canopy_path),
        "ref_canon": str(out_ref_canon_path),
    }


@lru_cache(maxsize=4)
def _load_forest_sky_and_fx_assets(mode: str) -> Dict[str, object]:
    """Charge les ciels et effets Friend Area PMD Red générés pour *Tiny Woods* et *Sinister Woods*."""
    if mode == "tiny_woods_sunlit":
        sky_p = REPO_ROOT / "source" / "reshiram_montagne_entree_v1" / "bruts" / "ciel_celeste_pmd_red_genere.png"
        ray_p = REPO_ROOT / "source" / "reshiram_montagne_entree_v1" / "bruts" / "rayons_lumiere_friend_area_pmd_red_magenta.png"
        sky_raw = Image.open(sky_p).convert("RGB")
        sw, sh = sky_raw.size
        band = sky_raw.crop((0, int(sh * 0.16), sw, int(sh * 0.50))).resize((W, 96), Image.Resampling.NEAREST)
        sky_q = band.quantize(colors=24, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
        sky_arr = _sanitize_rgb_no_magenta(np.asarray(sky_q, dtype=np.uint8), np.ones((96, W), dtype=bool))

        ray_raw = np.asarray(Image.open(ray_p).convert("RGB"), dtype=np.uint8)
        rr, rg, rb = ray_raw[:, :, 0].astype(np.float32), ray_raw[:, :, 1].astype(np.float32), ray_raw[:, :, 2].astype(np.float32)
        rmag = (rr > 70.0) & (rb > 70.0) & (rr > rg * 1.35) & (rb > rg * 1.35)
        rfg = ~(rmag | (ndimage.binary_dilation(rmag, iterations=2) & (rr > rg * 1.05) & (rb > rg * 1.05)))
        rsub = rfg[365:815, 290:1035]
        cov = np.asarray(Image.fromarray((rsub * 255).astype(np.uint8)).resize((272, 180), Image.Resampling.BOX), dtype=np.float32) / 255.0
        return {"sky_strip": sky_arr, "ray_cov": cov}

    sky_p = REPO_ROOT / "source" / "sinister_woods_entree_v1" / "bruts" / "ciel_crepuscule_sinister_woods_genere.png"
    mist_p = REPO_ROOT / "source" / "sinister_woods_entree_v1" / "bruts" / "brume_spectrale_friend_area_magenta.png"
    sky_raw = Image.open(sky_p).convert("RGB")
    sw, sh = sky_raw.size
    band = sky_raw.crop((0, int(sh * 0.22), sw, int(sh * 0.78))).resize((W, 96), Image.Resampling.NEAREST)
    sky_q = band.quantize(colors=20, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
    sky_arr = np.asarray(sky_q, dtype=np.uint8)
    pal_20 = np.unique(sky_arr.reshape(-1, 3), axis=0).astype(np.int32)
    half = sky_arr[:, :384].astype(np.float32)
    seam_w = 40
    for dx in range(seam_w):
        a = (dx + 0.5) / float(seam_w) * 0.5
        blended = half[:, dx] * (0.5 + a) + half[:, 383 - dx] * (0.5 - a)
        d2 = ((pal_20[None, :, :] - blended[:, None, :]) ** 2).sum(axis=2)
        half[:, dx] = pal_20[np.argmin(d2, axis=1)]
        blended_r = half[:, 383 - dx] * (0.5 + a) + half[:, dx] * (0.5 - a)
        d2r = ((pal_20[None, :, :] - blended_r[:, None, :]) ** 2).sum(axis=2)
        half[:, 383 - dx] = pal_20[np.argmin(d2r, axis=1)]
    half_u8 = _sanitize_rgb_no_magenta(half.astype(np.uint8), np.ones((96, 384), dtype=bool))
    sky_tile = np.concatenate([half_u8, half_u8], axis=1)

    mist_raw = np.asarray(Image.open(mist_p).convert("RGB"), dtype=np.uint8)
    mr, mg, mb = mist_raw[:, :, 0].astype(np.float32), mist_raw[:, :, 1].astype(np.float32), mist_raw[:, :, 2].astype(np.float32)
    mmag = (mr > 80.0) & (mb > 80.0) & (mr > mg * 1.30) & (mb > mg * 1.30)
    mfg = ~(mmag | (ndimage.binary_dilation(mmag, iterations=2) & (mr > mg * 1.05) & (mb > mg * 1.05)))
    msub = mfg[295:535, 40:1200]
    mcov_half = np.asarray(Image.fromarray((msub * 255).astype(np.uint8)).resize((384, 96), Image.Resampling.BOX), dtype=np.float32) / 255.0
    for dx in range(28):
        t = (dx + 0.5) / 28.0
        avg = 0.5 * (mcov_half[:, dx] + mcov_half[:, 383 - dx])
        mcov_half[:, dx] = avg * (1.0 - t) + mcov_half[:, dx] * t
        mcov_half[:, 383 - dx] = avg * (1.0 - t) + mcov_half[:, 383 - dx] * t
    # Enveloppe en cloche verticale sin(pi*y/H) -> ZÉRO coupure horizontale sur la canopée !
    v_env = np.sin(np.pi * (np.arange(96, dtype=np.float32) + 0.5) / 96.0)[:, None]
    mcov_full = np.concatenate([mcov_half, mcov_half], axis=1) * v_env
    return {"sky_strip": sky_tile, "mist_cov": mcov_full}


def build_forest_sky_and_atmosphere_layers(
    mode: str,
    sky_mask: np.ndarray,
    base_rgb: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit `(sky_24, horizon_fx_24, top_atmosphere_24)` sans aucun overflow `uint8`."""
    assets = _load_forest_sky_and_fx_assets(mode)
    sky_strip: np.ndarray = assets["sky_strip"]  # type: ignore[assignment]
    y_max_sky = min(H, max(96, int(np.where(sky_mask)[0].max()) + 4) if np.any(sky_mask) else 96)
    y_max_sky = min(y_max_sky, sky_strip.shape[0])

    active_sky = np.zeros((H, W), dtype=bool)
    active_sky[:y_max_sky, :] = sky_mask[:y_max_sky, :]
    sub_mask = active_sky[:y_max_sky, :]
    sub_yy, sub_xx = np.mgrid[0:y_max_sky, 0:W]
    bayer01 = np.tile(BAYER_4X4, (H // 4 + 1, W // 4 + 1))[:H, :W]

    rng = np.random.default_rng(10101 if mode == "tiny_woods_sunlit" else 40404)
    n_motes = 22
    mote_x0 = rng.integers(32, W - 32, size=n_motes)
    mote_y0 = rng.integers(24, H - 64, size=n_motes)
    mote_ph = rng.uniform(0.0, 2.0 * math.pi, size=n_motes)
    mote_kind = rng.integers(0, 2, size=n_motes)

    sky_frames: List[Image.Image] = []
    horizon_frames: List[Image.Image] = []
    top_frames: List[Image.Image] = []

    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)

        if mode == "tiny_woods_sunlit":
            breeze_dx = int(round(8.0 * math.cos(theta)))
            xs_c = np.clip(np.arange(W, dtype=np.int32) - breeze_dx, 0, W - 1)
            cel = sky_strip[:y_max_sky, xs_c].astype(np.float32)
            wave = 15.0 * np.cos(theta - 0.009 * sub_xx) + 4.0 * np.sin(2.0 * theta + 0.04 * sub_yy)
            cel[:, :, 0] = np.clip(cel[:, :, 0] + wave * 1.15, 0.0, 255.0)
            cel[:, :, 1] = np.clip(cel[:, :, 1] + wave * 0.95, 0.0, 255.0)
            cel[:, :, 2] = np.clip(cel[:, :, 2] + wave * 0.55, 0.0, 255.0)
            cel_q = _sanitize_rgb_no_magenta(_q8_u8(cel), sub_mask)

            sky = np.zeros((H, W, 4), dtype=np.uint8)
            sky[:y_max_sky, :][sub_mask, :3] = cel_q[sub_mask]
            sky[:y_max_sky, :][sub_mask, 3] = 255
            sky_frames.append(Image.fromarray(sanitize_rgba_binary(sky)))

            ray_cov: np.ndarray = assets["ray_cov"]  # type: ignore[assignment]
            rh_f, rw_f = ray_cov.shape
            taper_y = np.clip(1.20 - np.arange(rh_f, dtype=np.float32)[:, None] / float(rh_f), 0.0, 1.0)
            breath = 0.96 + 0.14 * math.cos(theta)
            sweep_dx = int(round(10.0 * math.cos(theta)))

            plume = np.zeros((H, W, 4), dtype=np.uint8)
            top_fx = np.zeros((H, W, 4), dtype=np.uint8)

            for base_rx0 in (12, 484):
                rx0 = max(0, min(W - rw_f, base_rx0 + sweep_dx))
                inten = ray_cov * taper_y * breath
                by_sub = bayer01[:rh_f, rx0 : rx0 + rw_f]
                in_sky_sub = active_sky[:rh_f, rx0 : rx0 + rw_f]

                sky_h = min(y_max_sky, rh_f)
                in_s = in_sky_sub[:sky_h]
                int_s = inten[:sky_h]
                hit_s = in_s & (int_s > 0.18)
                base_s = cel_q[:sky_h, rx0 : rx0 + rw_f].astype(np.float32)
                lit_s = np.clip(base_s * 0.50 + np.array([255.0, 248.0, 212.0]) * 0.50, 0.0, 255.0)
                lit_sq = _sanitize_rgb_no_magenta(_q8_u8(lit_s), hit_s)
                sub_p = plume[:sky_h, rx0 : rx0 + rw_f]
                sub_p[hit_s, :3] = lit_sq[hit_s]
                sub_p[hit_s, 3] = 255

                on_canopy = ~in_sky_sub
                sub_x_global = np.arange(rx0, rx0 + rw_f)[None, :]
                sub_y_global = np.arange(rh_f)[:, None]
                in_tunnel = (sub_x_global >= 332) & (sub_x_global <= 436) & (sub_y_global >= 72) & (sub_y_global <= 178)
                on_canopy = on_canopy & (~in_tunnel)

                r_core = on_canopy & (inten > 0.44)
                r_mid = on_canopy & (~r_core) & (inten > 0.24)
                r_tip = on_canopy & (~r_core) & (~r_mid) & (inten > 0.14) & ((inten * 2.6) > by_sub)
                base_sub = base_rgb[:rh_f, rx0 : rx0 + rw_f].astype(np.int16)
                lit_c = base_sub.copy()
                lit_c[r_core] = np.clip(base_sub[r_core] + np.array([48, 42, 18], dtype=np.int16), 0, 255)
                lit_c[r_mid] = np.clip(base_sub[r_mid] + np.array([28, 24, 10], dtype=np.int16), 0, 255)
                lit_c[r_tip] = np.clip(base_sub[r_tip] + np.array([16, 14, 6], dtype=np.int16), 0, 255)
                hit_c = r_core | r_mid | r_tip
                lit_cq = _sanitize_rgb_no_magenta(((lit_c // 8) * 8).clip(0, 255).astype(np.uint8), hit_c)
                sub_t = top_fx[:rh_f, rx0 : rx0 + rw_f]
                sub_t[hit_c, :3] = lit_cq[hit_c]
                sub_t[hit_c, 3] = 255

            for i in range(n_motes):
                mx = int(round(mote_x0[i] + 10.0 * math.sin(theta + mote_ph[i])))
                my = int(round(mote_y0[i] + 6.0 * math.cos(theta + mote_ph[i])))
                if 4 <= mx < W - 4 and 4 <= my < H - 4:
                    pulse = math.sin(2.0 * theta + mote_ph[i])
                    if pulse > -0.25:
                        if mote_kind[i] == 0:
                            top_fx[my, mx] = (255, 250, 184, 255)
                            if pulse > 0.35:
                                for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                                    top_fx[my + dy, mx + dx] = (240, 224, 128, 255)
                        else:
                            top_fx[my, mx : mx + 2] = (152, 240, 104, 255)
                            top_fx[my + 1, mx - 1 : mx + 1] = (72, 192, 80, 255)

            horizon_frames.append(Image.fromarray(sanitize_rgba_binary(plume)))
            top_frames.append(Image.fromarray(sanitize_rgba_binary(top_fx)))

        else:
            shift_x = (f * 16) % 384
            twi = np.roll(sky_strip[:y_max_sky, :], -shift_x, axis=1).astype(np.float32)
            spec_wave = 16.0 * np.cos(theta - 0.010 * sub_xx)
            twi[:, :, 0] = np.clip(twi[:, :, 0] + spec_wave * 0.45, 0.0, 255.0)
            twi[:, :, 1] = np.clip(twi[:, :, 1] + spec_wave * 0.95, 0.0, 255.0)
            twi[:, :, 2] = np.clip(twi[:, :, 2] + spec_wave * 1.15, 0.0, 255.0)
            twi_q = _sanitize_rgb_no_magenta(_q8_u8(twi), sub_mask)

            sky = np.zeros((H, W, 4), dtype=np.uint8)
            sky[:y_max_sky, :][sub_mask, :3] = twi_q[sub_mask]
            sky[:y_max_sky, :][sub_mask, 3] = 255
            sky_frames.append(Image.fromarray(sanitize_rgba_binary(sky)))

            mist_cov: np.ndarray = assets["mist_cov"]  # type: ignore[assignment]
            mh_f = mist_cov.shape[0]
            mist_roll_sky = np.roll(mist_cov, shift=(f * 16) % 384, axis=1)

            plume = np.zeros((H, W, 4), dtype=np.uint8)
            sky_h = min(y_max_sky, mh_f)
            in_s = active_sky[:sky_h, :]
            mc_s = mist_roll_sky[:sky_h, :]
            hit_ms = in_s & (mc_s > 0.20)
            base_s = twi_q[:sky_h, :].astype(np.float32)
            lit_ms = np.clip(base_s * 0.45 + np.array([152.0, 236.0, 240.0]) * 0.55, 0.0, 255.0)
            lit_msq = _sanitize_rgb_no_magenta(_q8_u8(lit_ms), hit_ms)
            plume[:sky_h, :][hit_ms, :3] = lit_msq[hit_ms]
            plume[:sky_h, :][hit_ms, 3] = 255
            horizon_frames.append(Image.fromarray(sanitize_rgba_binary(plume)))

            top_fx = np.zeros((H, W, 4), dtype=np.uint8)
            y0_m = 12
            y1_m = y0_m + mh_f
            mist_roll_top = np.roll(mist_cov, shift=-((f * 16) % 384), axis=1)
            breath_m = 0.90 + 0.16 * math.cos(theta)
            inten_m = mist_roll_top * breath_m
            on_trees = ~active_sky[y0_m:y1_m, :]
            xg_m = np.arange(W)[None, :]
            yg_m = np.arange(y0_m, y1_m)[:, None]
            in_portal = (xg_m >= 316) & (xg_m <= 452) & (yg_m >= 48)
            on_trees = on_trees & (~in_portal)

            by_m = bayer01[y0_m:y1_m, :]
            m_core = on_trees & (inten_m > 0.48)
            m_mid = on_trees & (~m_core) & (inten_m > 0.26) & ((inten_m * 2.2) > by_m)
            base_t = base_rgb[y0_m:y1_m, :].astype(np.int16)
            lit_t = base_t.copy()
            lit_t[m_core] = np.clip(base_t[m_core] + np.array([22, 48, 52], dtype=np.int16), 0, 255)
            lit_t[m_mid] = np.clip(base_t[m_mid] + np.array([12, 26, 30], dtype=np.int16), 0, 255)
            hit_t = m_core | m_mid
            lit_tq = _sanitize_rgb_no_magenta(((lit_t // 8) * 8).clip(0, 255).astype(np.uint8), hit_t)
            sub_top = top_fx[y0_m:y1_m, :]
            sub_top[hit_t, :3] = lit_tq[hit_t]
            sub_top[hit_t, 3] = 255

            for i in range(n_motes):
                mx = int(round(mote_x0[i] + 9.0 * math.cos(theta + mote_ph[i])))
                my = int(round(mote_y0[i] + 5.0 * math.sin(theta + mote_ph[i])))
                if 4 <= mx < W - 4 and 4 <= my < H - 4:
                    pulse = math.sin(2.0 * theta + mote_ph[i])
                    if pulse > -0.15:
                        if mote_kind[i] == 0:
                            top_fx[my, mx] = (192, 255, 248, 255)
                            if pulse > 0.40:
                                for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                                    top_fx[my + dy, mx + dx] = (64, 200, 208, 255)
                        else:
                            top_fx[my, mx] = (255, 232, 152, 255)
                            if pulse > 0.45:
                                top_fx[my, mx + 1] = (232, 168, 88, 255)

            top_frames.append(Image.fromarray(sanitize_rgba_binary(top_fx)))

    return sky_frames, horizon_frames, top_frames


def build_forest_water_and_sparkles_layers(
    mode: str,
    water_mask: np.ndarray,
    bridge_mask: np.ndarray | None = None,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit `(water_24, sparkles_24)` @ `4 × 10` ticks avec ondulations de courant et grappes
    natives `Metano_Town_River_Sparkles` placées sur toute la hauteur (`y = 160..568`, `0 px` d'écume)."""
    assets = extract_metano_water_and_flower_assets()
    sp_clusters: List[List[np.ndarray]] = assets["sparkle_clusters"]  # type: ignore[assignment]

    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    visible_water = water_mask.copy()
    visible_water_open = (water_mask & (~bridge_mask)) if bridge_mask is not None else water_mask
    dist_bank = ndimage.distance_transform_edt(visible_water_open)

    jag_raw = ndimage.gaussian_filter(np.random.default_rng(17).random((H, W)), 1.2)
    jag = (jag_raw - jag_raw.min()) / max(float(np.ptp(jag_raw)), 1e-6)

    if mode == "tiny_woods_sunlit":
        # Palette turquoise limpide exacte de Metano Town / Waterfall Lake (sans trait blanc d'écume)
        pal_surface = (131, 218, 230, 255)
        pal_accent = (111, 207, 231, 255)
        pal_inter = (95, 183, 207, 255)
        pal_bande = (87, 135, 191, 255)
    else:
        # Palette sarcelle-jade mystique de Sinister Woods / Mist-Rise & Healing Forest (H07P01/H07P06)
        pal_surface = (44, 152, 170, 255)
        pal_accent = (64, 178, 192, 255)
        pal_inter = (30, 118, 142, 255)
        pal_bande = (20, 84, 114, 255)

    # Placement déterministe sans chevauchement des grappes natives `Metano_Town_River_Sparkles` sur TOUTE l'eau ouverte !
    taken_sp = np.zeros((H, W), dtype=bool)
    sparkle_sites: List[Tuple[int, int, int, int]] = []
    rng_sp = np.random.default_rng(77)
    cands_sp = [(sy, sx) for sy in range(160, H - 32, 8) for sx in range(16, W - 32, 8)]
    rng_sp.shuffle(cands_sp)
    for sy, sx in cands_sp:
        fam_idx = len(sparkle_sites) % len(sp_clusters)
        sh_h, sh_w = sp_clusters[fam_idx][0].shape[:2]
        if sy + sh_h > H - 8 or sx + sh_w > W - 8:
            continue
        if (
            visible_water_open[sy : sy + sh_h, sx : sx + sh_w].all()
            and float(dist_bank[sy : sy + sh_h, sx : sx + sh_w].min()) >= 6.0
            and not taken_sp[max(0, sy - 6) : sy + sh_h + 6, max(0, sx - 8) : sx + sh_w + 8].any()
        ):
            taken_sp[sy : sy + sh_h, sx : sx + sh_w] = True
            sparkle_sites.append((sx, sy, fam_idx, len(sparkle_sites) % 4))
            if len(sparkle_sites) >= 26:
                break

    water_frames: List[Image.Image] = []
    sparkle_frames: List[Image.Image] = []

    for pose in range(N_POSES):
        # 4 phases × 10 ticks (= 2 poses de 5 ticks par phase -> pose 0 = phase 0 != pose 12 = phase 2 !)
        r_phase = (pose // 2) % 4
        ph = 2.0 * math.pi * r_phase / 4.0

        # Ondes de courant à travers TOUT le lit du ruisseau / bassin (pour une animation riche même au centre !)
        n_wave = 0.6 * np.sin(yy * 0.21 + xx * 0.07 - ph) + 0.4 * np.sin(yy * 0.08 - xx * 0.16 + 1.1 - ph)
        curr_band = np.sin(xx * 0.065 + yy * 0.14 - ph) + 0.55 * np.cos(xx * 0.11 - yy * 0.09 + ph)
        t_bevel = 4.5 + 1.1 * n_wave
        jr = np.roll(jag, r_phase * 3, axis=0)
        fringe = t_bevel + 1.2 + 3.0 * jr

        riv = np.zeros((H, W, 4), dtype=np.uint8)
        riv[visible_water] = pal_surface
        # Veines de courant animées au coeur du ruisseau / des bassins (amplitude RGB >= 20 entre phase 0 et phase 2 !)
        riv[visible_water_open & (dist_bank > fringe) & (curr_band > 0.58)] = pal_accent
        riv[visible_water_open & (dist_bank > fringe) & (curr_band < -0.68)] = pal_inter
        riv[visible_water & (dist_bank <= fringe)] = pal_inter
        riv[visible_water & (dist_bank <= fringe) & (jr > 0.60)] = pal_accent
        riv[visible_water & (dist_bank <= t_bevel)] = pal_inter
        riv[visible_water & (dist_bank <= t_bevel - 1.0)] = pal_bande
        riv[visible_water & (~visible_water_open)] = pal_bande
        water_frames.append(Image.fromarray(sanitize_rgba_binary(riv)))

        sp = np.zeros((H, W, 4), dtype=np.uint8)
        for sx, sy, fam_idx, ph0 in sparkle_sites:
            patch = sp_clusters[fam_idx][(r_phase + ph0) % 4].copy()
            sh_h, sh_w = patch.shape[:2]
            nz = patch[:, :, 3] == 255
            if mode != "tiny_woods_sunlit" and np.any(nz):
                patch[nz, 0] = np.clip(patch[nz, 0].astype(np.int16) - 65, 110, 225).astype(np.uint8)
                patch[nz, 1] = np.clip(patch[nz, 1].astype(np.int16) + 8, 215, 255).astype(np.uint8)
                patch[nz, 2] = np.clip(patch[nz, 2].astype(np.int16) + 8, 225, 255).astype(np.uint8)
            sub_sp = sp[sy : sy + sh_h, sx : sx + sh_w]
            sub_w = visible_water_open[sy : sy + sh_h, sx : sx + sh_w]
            keep = nz & sub_w
            sub_sp[keep] = patch[keep]
        sparkle_frames.append(Image.fromarray(sanitize_rgba_binary(sp)))

    return water_frames, sparkle_frames


def build_forest_flora_layer_24(
    mode: str,
    flora_mask: np.ndarray,
    rgb_nat: np.ndarray,
    solid_nat: np.ndarray,
) -> List[Image.Image]:
    """Anime en 24 poses les fleurs sauvages (*Tiny Woods*) ou les champignons rouges/violets & spores (*Sinister Woods*)."""
    base_patch = np.zeros((H, W, 4), dtype=np.uint8)
    base_patch[flora_mask, :3] = rgb_nat[flora_mask]
    base_patch[flora_mask, 3] = 255

    frames: List[Image.Image] = []
    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)
        dx = int(round(math.sin(theta)))
        shifted = np.roll(base_patch, shift=dx, axis=1)
        if dx > 0:
            shifted[:, :dx] = 0
        elif dx < 0:
            shifted[:, dx:] = 0
        valid = (shifted[:, :, 3] > 0) & solid_nat
        out = np.zeros((H, W, 4), dtype=np.uint8)
        if mode == "sinister_woods_mist":
            boost = int(round(8.0 * math.cos(theta)))
            cols = np.clip(shifted[valid, :3].astype(np.int16) + boost, 0, 255).astype(np.uint8)
            out[valid, :3] = cols
        else:
            out[valid, :3] = shifted[valid, :3]
        out[valid, 3] = 255
        out[:, :, :3] = _sanitize_rgb_no_magenta(out[:, :, :3], valid)
        frames.append(Image.fromarray(sanitize_rgba_binary(out)))
    return frames


def inpaint_grass_under_flora(rgb_nat: np.ndarray, meadow_mask: np.ndarray, flora_mask: np.ndarray) -> np.ndarray:
    """Remplit les pixels sous les fleurs/champignons mobiles avec la couleur d'herbe voisine exacte (zéro trou noir)."""
    out = rgb_nat.copy()
    pure_grass = meadow_mask & (~flora_mask)
    if np.any(pure_grass) and np.any(flora_mask):
        _, nearest_idx = ndimage.distance_transform_edt(~pure_grass, return_indices=True)
        fy, fx = np.where(flora_mask)
        gy = nearest_idx[0, fy, fx]
        gx = nearest_idx[1, fy, fx]
        out[fy, fx] = rgb_nat[gy, gx]
    return out
