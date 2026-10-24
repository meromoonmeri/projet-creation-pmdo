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
    decode_pmdo_tile,
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
        # Pétales corail-rose & boutons d'or de Tiny Woods (hors sentier sablonneux central x=328..440 et hors berges !)
        xx = np.arange(rgb.shape[1])[None, :]
        off_path = interior_solid & (np.abs(xx - 384) > 56)
        pink_fl = _keep_compact_blobs(off_path & (r0 >= 210) & (r0 > g0 + 42) & (b0 >= 135), max_area=220)
        gold_fl = _keep_compact_blobs(off_path & (r0 >= 228) & (g0 >= 198) & (b0 <= 118), max_area=220)
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
    not_bridge = ~((xx7 >= 324) & (xx7 <= 444) & (yy7 >= 268) & (yy7 <= 476))
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

    # Sur Tiny Woods : ZÉRO ciel visible (100 % couvert par le mur d'arbres au Nord)
    if mode == "tiny_woods_sunlit":
        top_hole = (~solid_768) & (yy7 < 240)
        if np.any(top_hole):
            _, n_idx = ndimage.distance_transform_edt(~solid_768, return_indices=True)
            hy, hx = np.where(top_hole)
            rgb_768[hy, hx] = rgb_768[n_idx[0, hy, hx], n_idx[1, hy, hx]]
            solid_768[top_hole] = True
    else:
        # Sur SWF1 : purge tout ruban cyan plat de brume spectrale pré-peint dans les coins Nord (y < 128)
        if out_brut_path.name == "base_sinister_woods_fin.png":
            r_f = rgb_768[:128, :, 0].astype(np.int16)
            g_f = rgb_768[:128, :, 1].astype(np.int16)
            b_f = rgb_768[:128, :, 2].astype(np.int16)
            wing_x = (xx7[:128, :] < 276) | (xx7[:128, :] > W - 276)
            # Cible uniquement le ruban plat de brume spectrale (sans texture d'arbre : couleur quasi uniforme)
            med_g = ndimage.median_filter(g_f, size=5)
            flat_cyan_mist = (
                solid_768[:128, :]
                & wing_x
                & (g_f >= 124)
                & (b_f >= 138)
                & (r_f <= 64)
                & (np.abs(g_f - med_g) <= 6)
            )
            lbl_cm, n_cm = ndimage.label(flat_cyan_mist)
            for cid in range(1, n_cm + 1):
                m_c = lbl_cm == cid
                if int(m_c.sum()) >= 180:
                    m_dil = ndimage.binary_dilation(m_c, iterations=1) & solid_768[:128, :] & wing_x
                    rgb_768[:128, :][m_dil] = np.array([18, 66, 90], dtype=np.uint8)

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
        is_foliage = solid_768 & (g16 >= 88) & (g16 > r16 + 32) & (r16 <= 118) & (b16 <= 118)
    else:
        is_foliage = solid_768 & (b16 >= 95) & (g16 >= 70) & (r16 <= 65)

    perim_zone = (yy < 115) | (xx < 155) | (xx > W - 155) | ((yy > 435) & (np.abs(xx - W // 2) > 95))
    not_central_portal = ~((xx >= 286) & (xx <= 482) & (yy >= 72) & (yy <= 228))
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

    # Référence composite `ref_canon` :
    # - Tiny Woods : Eau claire Metano Town `[131, 218, 230]`
    # - Sinister Woods : Eau trouble couleur "eau usée" `[82, 92, 54]`
    ref_rgb = rgb_768.copy()
    sky_m = mag_768 & (yy < 96)
    wat_m = mag_768 & (~sky_m)
    if np.any(sky_m) and mode != "tiny_woods_sunlit":
        assets = _load_forest_sky_and_fx_assets(mode)
        sky_strip: np.ndarray = assets["sky_strip"]  # type: ignore[assignment]
        sh = min(H, sky_strip.shape[0])
        sky_top = sky_m.copy()
        sky_top[sh:, :] = False
        ref_rgb[sky_top] = sky_strip[:sh, :][sky_top[:sh, :]]
    if mode == "tiny_woods_sunlit":
        ref_rgb[wat_m] = np.array([131, 218, 230], dtype=np.uint8)
    else:
        ref_rgb[wat_m] = np.array([82, 92, 54], dtype=np.uint8)
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


@lru_cache(maxsize=1)
def extract_native_metano_river_profiles() -> np.ndarray:
    """Extrait directement à l'échelle `1×` native les 4 phases (`Metano_Town_River_Animation_1..4.tile`)
    du profil de berge de Metano Town (`(4, N, 12, 3)`), sans rondins ni écume blanche de rive."""
    eau_dir = REPO_ROOT / "source" / "eau_metano" / "natifs"
    sub_list = [
        np.asarray(decode_pmdo_tile(eau_dir / f"Metano_Town_River_Animation_{i}.tile"))[200:450, 832:1136]
        for i in range(1, 5)
    ]
    op0 = sub_list[0][:, :, 3] > 0
    good_rows: List[Tuple[int, int]] = []
    for y in range(sub_list[0].shape[0]):
        xs = np.flatnonzero(op0[y])
        if len(xs) < 30:
            continue
        x0 = int(xs[0])
        if x0 + 14 >= sub_list[0].shape[1] or not np.all(op0[y, x0 : x0 + 14]):
            continue
        seg0 = sub_list[0][y, x0 : x0 + 12, :3]
        if np.all((seg0[:, 2].astype(np.int32) > seg0[:, 0].astype(np.int32) + 20) & (seg0[:, 0] < 235)):
            good_rows.append((y, x0))

    n_rows = len(good_rows)
    prof4 = np.zeros((4, n_rows, 12, 3), dtype=np.uint8)
    for k in range(4):
        for idx, (y, x0) in enumerate(good_rows):
            x_lo = max(0, x0 - 3)
            row_op = sub_list[k][y, x_lo : x0 + 16, 3] > 0
            off = int(np.flatnonzero(row_op)[0]) + x_lo
            seg = sub_list[k][y, off : off + 12, :3].copy()
            foam_px = (seg[:, 0] >= 235) & (seg[:, 1] >= 245) & (seg[:, 2] >= 245)
            seg[foam_px] = (148, 230, 238)
            prof4[k, idx] = seg

    # Couture cyclique douce sur 16 lignes recalée sur la palette aquatique exacte de Metano Town
    aq_pal = np.unique(prof4.reshape(-1, 3), axis=0).astype(np.float32)
    seam = 16
    for k in range(4):
        p_f = prof4[k].astype(np.float32)
        for s in range(seam):
            w_s = (s + 0.5) / float(seam) * 0.5
            b_top = p_f[s] * (0.5 + w_s) + p_f[n_rows - 1 - s] * (0.5 - w_s)
            b_bot = p_f[n_rows - 1 - s] * (0.5 + w_s) + p_f[s] * (0.5 - w_s)
            d_top = ((b_top[:, None, :] - aq_pal[None, :, :]) ** 2).sum(axis=2).argmin(axis=1)
            d_bot = ((b_bot[:, None, :] - aq_pal[None, :, :]) ** 2).sum(axis=2).argmin(axis=1)
            prof4[k, s] = aq_pal[d_top].astype(np.uint8)
            prof4[k, n_rows - 1 - s] = aq_pal[d_bot].astype(np.uint8)
    return prof4


def _remap_metano_to_wastewater_rgb(rgb: np.ndarray) -> np.ndarray:
    """Re-palette fidèlement les ondulations natives Metano Town vers une teinte trouble 'eau usée'
    (vase olive-brunâtre stagnante, zéro bleu-cyan vif)."""
    lum = (
        0.299 * rgb[..., 0].astype(np.float32)
        + 0.587 * rgb[..., 1].astype(np.float32)
        + 0.114 * rgb[..., 2].astype(np.float32)
    )
    # Metano Town natif a des luminances entre ~95 (rive sombre) et ~225 (crête claire)
    t = np.clip((lum - 95.0) / 125.0, 0.0, 1.0)
    pal_ww = np.array(
        [
            [44, 50, 30],   # berge vaseuse sombre
            [62, 70, 40],   # palier intermédiaire boueux
            [82, 92, 54],   # eau usée olive-kaki trouble (surface principale)
            [102, 114, 66], # ride d'eau trouble claire
        ],
        dtype=np.uint8,
    )
    idx = np.zeros(t.shape, dtype=np.int32)
    idx[t >= 0.28] = 1
    idx[t >= 0.56] = 2
    idx[t >= 0.82] = 3
    return pal_ww[idx]


def build_forest_water_and_sparkles_layers(
    mode: str,
    water_mask: np.ndarray,
    bridge_mask: np.ndarray | None = None,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit `(water_24, sparkles_24)` avec l'animation native Metano Town (`4 × 10` ticks) :
    - `tiny_woods_sunlit` (et défaut) : Eau claire native Metano Town `(131, 218, 230)` + `Sparkles.tile` natifs ;
    - `sinister_woods_wastewater` : Même géométrie animée Metano Town teintée en 'eau usée' trouble `(82, 92, 54)`."""
    is_wastewater = mode == "sinister_woods_wastewater"
    assets = extract_metano_water_and_flower_assets()
    sp_clusters: List[List[np.ndarray]] = assets["sparkle_clusters"]  # type: ignore[assignment]
    prof4_raw = extract_native_metano_river_profiles()
    prof4 = _remap_metano_to_wastewater_rgb(prof4_raw) if is_wastewater else prof4_raw
    n_prof = prof4.shape[1]

    yy, xx = np.mgrid[0:H, 0:W].astype(np.int32)
    visible_water = water_mask.copy()
    visible_water_open = (water_mask & (~bridge_mask)) if bridge_mask is not None else water_mask
    dist_bank = ndimage.distance_transform_edt(visible_water_open)

    if is_wastewater:
        pal_surface = (82, 92, 54, 255)
        pal_under_bridge = (50, 56, 34, 255)
        max_sparkles = 14
    else:
        pal_surface = (131, 218, 230, 255)
        pal_under_bridge = (87, 135, 191, 255)
        max_sparkles = 28

    shore_mask = visible_water_open & (dist_bank >= 0.5) & (dist_bank <= 12.0)
    arc_idx = (xx + 2 * yy) % n_prof
    dist_idx = np.clip(np.round(dist_bank).astype(np.int32) - 1, 0, 11)

    taken_sp = np.zeros((H, W), dtype=bool)
    sparkle_sites: List[Tuple[int, int, int, int]] = []
    rng_sp = np.random.default_rng(77)
    cands_sp = [(sy, sx) for sy in range(140, H - 24, 8) for sx in range(8, W - 28, 8)]
    rng_sp.shuffle(cands_sp)
    for sy, sx in cands_sp:
        fam_idx = len(sparkle_sites) % len(sp_clusters)
        sh_h, sh_w = sp_clusters[fam_idx][0].shape[:2]
        if sy + sh_h > H - 4 or sx + sh_w > W - 4:
            continue
        if (
            visible_water_open[sy : sy + sh_h, sx : sx + sh_w].all()
            and float(dist_bank[sy : sy + sh_h, sx : sx + sh_w].min()) >= 6.0
            and not taken_sp[max(0, sy - 6) : sy + sh_h + 6, max(0, sx - 8) : sx + sh_w + 8].any()
        ):
            taken_sp[sy : sy + sh_h, sx : sx + sh_w] = True
            sparkle_sites.append((sx, sy, fam_idx, len(sparkle_sites) % 4))
            if len(sparkle_sites) >= max_sparkles:
                break

    water_frames: List[Image.Image] = []
    sparkle_frames: List[Image.Image] = []

    for pose in range(N_POSES):
        r_phase = (pose // 2) % 4

        riv = np.zeros((H, W, 4), dtype=np.uint8)
        riv[visible_water] = pal_surface
        riv[shore_mask, :3] = prof4[r_phase, arc_idx[shore_mask], dist_idx[shore_mask]]
        riv[shore_mask, 3] = 255
        riv[visible_water & (~visible_water_open)] = pal_under_bridge
        water_frames.append(Image.fromarray(sanitize_rgba_binary(riv)))

        sp = np.zeros((H, W, 4), dtype=np.uint8)
        for sx, sy, fam_idx, ph0 in sparkle_sites:
            patch = sp_clusters[fam_idx][(r_phase + ph0) % 4]
            sh_h, sh_w = patch.shape[:2]
            nz = patch[:, :, 3] == 255
            sub_sp = sp[sy : sy + sh_h, sx : sx + sh_w]
            sub_w = visible_water_open[sy : sy + sh_h, sx : sx + sh_w]
            keep = nz & sub_w
            if is_wastewater:
                sub_sp[keep] = (122, 134, 76, 255)
            else:
                sub_sp[keep] = patch[keep]
        sparkle_frames.append(Image.fromarray(sanitize_rgba_binary(sp)))

    return water_frames, sparkle_frames


@lru_cache(maxsize=2)
def _extract_sinister_toxic_mist_and_wisps() -> Tuple[List[np.ndarray], List[np.ndarray]]:
    """Extrait depuis `brume_toxique_et_feux_follets_magenta.png` (`#FF00FF`) :
      1. `mist_sprites` : les 4 nappes effilées de brume toxique marécageuse (vert-olive vénéneux, faible opacité) ;
      2. `wisp_frames_4` : les 4 poses séquentielles de flamme de feu follet (`feux follets`, faible opacité)."""
    sheet_p = REPO_ROOT / "source" / "sinister_woods_entree_v1" / "bruts" / "brume_toxique_et_feux_follets_magenta.png"
    raw = np.asarray(Image.open(sheet_p).convert("RGB"), dtype=np.uint8)
    rf, gf, bf = raw[:, :, 0].astype(np.float32), raw[:, :, 1].astype(np.float32), raw[:, :, 2].astype(np.float32)

    mag_core = (rf >= 195.0) & (gf <= 95.0) & (bf >= 185.0) & ((rf + bf - 2.0 * gf) >= 170.0)
    fringe = ndimage.binary_dilation(mag_core, iterations=4) & (rf > gf + 16.0) & (bf > gf + 16.0)
    fg_hi = ~(mag_core | fringe)

    # Réduction sans mélange vers 512 x 286 pour des pixels GBA nets
    rgb_lo, solid_lo = _downsample_non_mixing(raw, fg_hi, 512, 286)
    rl, gl, bl = rgb_lo[:, :, 0].astype(np.int16), rgb_lo[:, :, 1].astype(np.int16), rgb_lo[:, :, 2].astype(np.int16)
    solid_lo = solid_lo & ~((rl > gl + 12) & (bl > gl + 12))
    solid_lo = ndimage.binary_opening(solid_lo, structure=np.ones((2, 2), dtype=bool))

    # 1) Nappes de brume toxique dans la partie haute (y < 205) -> alpha translucide faible opacité (40..72 / 255)
    mist_zone = solid_lo.copy()
    mist_zone[205:, :] = False
    lbl_m, n_m = ndimage.label(mist_zone)
    pal_mist = np.array(
        [
            [84, 104, 44],   # bord de miasme olive sombre
            [116, 144, 52],  # coeur de vapeur toxique kaki-chartreuse
            [148, 176, 60],  # volute acide pâle
        ],
        dtype=np.uint8,
    )
    alpha_mist = np.array([38, 56, 72], dtype=np.uint8)
    mist_list: List[Tuple[int, np.ndarray]] = []
    for cid in range(1, n_m + 1):
        ys, xs = np.where(lbl_m == cid)
        if ys.size < 40:
            continue
        y0, y1 = int(ys.min()), int(ys.max()) + 1
        x0, x1 = int(xs.min()), int(xs.max()) + 1
        sub_m = lbl_m[y0:y1, x0:x1] == cid
        sub_c = rgb_lo[y0:y1, x0:x1].astype(np.float32)
        lum = 0.299 * sub_c[:, :, 0] + 0.587 * sub_c[:, :, 1] + 0.114 * sub_c[:, :, 2]
        q35, q72 = np.percentile(lum[sub_m], [35.0, 72.0])
        t_idx = np.zeros(sub_m.shape, dtype=np.int32)
        t_idx[lum >= q35] = 1
        t_idx[lum >= q72] = 2
        # Adoucit encore le contour extérieur à alpha = 30
        edge_m = sub_m & (~ndimage.binary_erosion(sub_m, iterations=1))
        sp = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
        sp[sub_m, :3] = _sanitize_rgb_no_magenta(pal_mist[t_idx], sub_m)[sub_m]
        sp[sub_m, 3] = alpha_mist[t_idx][sub_m]
        sp[edge_m, 3] = 28
        mist_list.append((int(ys.size), sp))
    mist_list.sort(key=lambda t: -t[0])
    mist_sprites = [sp for _, sp in mist_list]
    while len(mist_sprites) < 4:
        mist_sprites.append(mist_sprites[-1])

    # 2) Les 4 poses de feux follets dans la bande basse (y >= 205), triées de gauche à droite -> faible opacité (56..104 / 255)
    wisp_zone = solid_lo.copy()
    wisp_zone[:205, :] = False
    lbl_w, n_w = ndimage.label(wisp_zone)
    pal_wisp = np.array(
        [
            [116, 184, 88],  # aura externe jade-chartreuse translucide
            [168, 228, 112], # flamme spectrale pâle
            [216, 248, 156], # coeur pâle du feu follet
        ],
        dtype=np.uint8,
    )
    alpha_wisp = np.array([48, 76, 104], dtype=np.uint8)
    wisp_raw: List[Tuple[int, np.ndarray]] = []
    for cid in range(1, n_w + 1):
        ys, xs = np.where(lbl_w == cid)
        if ys.size < 16:
            continue
        y0, y1 = int(ys.min()), int(ys.max()) + 1
        x0, x1 = int(xs.min()), int(xs.max()) + 1
        sub_m = lbl_w[y0:y1, x0:x1] == cid
        sub_c = rgb_lo[y0:y1, x0:x1].astype(np.float32)
        lum = 0.299 * sub_c[:, :, 0] + 0.587 * sub_c[:, :, 1] + 0.114 * sub_c[:, :, 2]
        q40, q78 = np.percentile(lum[sub_m], [40.0, 78.0])
        t_idx = np.zeros(sub_m.shape, dtype=np.int32)
        t_idx[lum >= q40] = 1
        t_idx[lum >= q78] = 2
        sp = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
        sp[sub_m, :3] = _sanitize_rgb_no_magenta(pal_wisp[t_idx], sub_m)[sub_m]
        sp[sub_m, 3] = alpha_wisp[t_idx][sub_m]
        wisp_raw.append((x0, sp))
    wisp_raw.sort(key=lambda t: t[0])
    # Normalise la boîte englobante (centrée en bas) des 4 poses du feu follet
    max_h = max(sp.shape[0] for _, sp in wisp_raw) + 2
    max_w = max(sp.shape[1] for _, sp in wisp_raw) + 2
    wisp_frames_4: List[np.ndarray] = []
    for _, sp in wisp_raw[:4]:
        canvas_w = np.zeros((max_h, max_w, 4), dtype=np.uint8)
        sh, sw = sp.shape[:2]
        oy = max_h - sh
        ox = (max_w - sw) // 2
        canvas_w[oy : oy + sh, ox : ox + sw] = sp
        wisp_frames_4.append(canvas_w)
    while len(wisp_frames_4) < 4:
        wisp_frames_4.append(wisp_frames_4[-1])

    return mist_sprites, wisp_frames_4


def _blit_alpha_over(dst: np.ndarray, src: np.ndarray, x0: int, y0: int, wrap_x: bool = True) -> None:
    """Compose un sprite RGBA translucide à faible opacité dans `dst` (`H × W × 4`) sans fuite magenta."""
    sh, sw = src.shape[:2]
    for dy in range(sh):
        yy = y0 + dy
        if yy < 0 or yy >= H:
            continue
        op = src[dy, :, 3] > 0
        if not np.any(op):
            continue
        xs_s = np.where(op)[0]
        for sx_i in xs_s.tolist():
            xx = (x0 + sx_i) % W if wrap_x else (x0 + sx_i)
            if xx < 0 or xx >= W:
                continue
            sa = int(src[dy, sx_i, 3])
            da = int(dst[yy, xx, 3])
            if da == 0:
                dst[yy, xx] = src[dy, sx_i]
            else:
                out_a = sa + da * (255 - sa) // 255
                if out_a > 0:
                    for c in range(3):
                        sc = int(src[dy, sx_i, c])
                        dc = int(dst[yy, xx, c])
                        dst[yy, xx, c] = (sc * sa + dc * da * (255 - sa) // 255) // out_a
                    dst[yy, xx, 3] = min(255, out_a)


def build_sinister_toxic_mist_and_wisps_layers(
    sky_mask: np.ndarray,
    canopy_nat: np.ndarray,
    is_arena_fin: bool = False,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit `(sky_static_1, toxic_water_mist_48, canopy_toxic_wisps_top_24)` pour *Sinister Woods* (`SWE1` & `SWF1`) :
      - ZÉRO brume spectrale cyan `H07P01` ;
      - Ciel nocturne sombre statique (`poses = 1`) ;
      - Nappes de brume toxique générées à faible opacité (`alpha ~ 15%..28%`, dérive lente `48` poses @ `18` ticks) ;
      - Feux follets marécageux générés à faible opacité (`alpha ~ 20%..40%`, 4 poses de flamme) + volutes toxiques Top."""
    assets = _load_forest_sky_and_fx_assets("sinister_woods_mist")
    sky_strip: np.ndarray = assets["sky_strip"]  # type: ignore[assignment]
    mist_sprites, wisp_frames_4 = _extract_sinister_toxic_mist_and_wisps()

    y_max_sky = min(H, max(96, int(np.where(sky_mask)[0].max()) + 4) if np.any(sky_mask) else 96)
    y_max_sky = min(y_max_sky, sky_strip.shape[0])
    sky_arr = np.zeros((H, W, 4), dtype=np.uint8)
    sub_m = sky_mask[:y_max_sky, :]
    dark_sky = np.clip(sky_strip[:y_max_sky, :].astype(np.int16) - np.array([6, 12, 10], dtype=np.int16), 0, 255).astype(np.uint8)
    dark_sky = _sanitize_rgb_no_magenta(dark_sky, sub_m)
    sky_arr[:y_max_sky, :][sub_m, :3] = dark_sky[sub_m]
    sky_arr[:y_max_sky, :][sub_m, 3] = 255
    sky_static_1 = [Image.fromarray(sanitize_rgba_binary(sky_arr))]

    # Calque 01 (BG, 48 poses @ 18 ticks -> lente dérive 8 px/pose sur période 384 px) :
    # Nappes de brume toxique à faible opacité flottant au-dessus de l'eau usée (ruisseau SWE1 / mares SWF1)
    proto_bg = np.zeros((H, 384, 4), dtype=np.uint8)
    y_water_mist = 418 if is_arena_fin else 296
    bg_sites = [
        (mist_sprites[0], 12, y_water_mist),
        (mist_sprites[2], 196, y_water_mist + 18),
        (mist_sprites[3], 88, 22),
    ]
    for sp, x0, y0 in bg_sites:
        sh, sw = sp.shape[:2]
        for dy in range(sh):
            yy = y0 + dy
            if 0 <= yy < H:
                for dx in range(sw):
                    if sp[dy, dx, 3] > 0:
                        proto_bg[yy, (x0 + dx) % 384] = sp[dy, dx]
    full_bg_proto = np.tile(proto_bg, (1, 2, 1))[:, :W, :]
    toxic_bg_48: List[Image.Image] = []
    for f in range(48):
        rolled = np.roll(full_bg_proto, shift=(f * 8) % W, axis=1).copy()
        toxic_bg_48.append(Image.fromarray(rolled, mode="RGBA"))

    # Calque 09 (Top, 24 poses @ 5 ticks) : Canopée sombre + brume toxique légère + feux follets à faible opacité
    can_op = canopy_nat[:, :, 3] >= 128
    # Bande de miasme léger Top (période 384 px, 16 px/pose ? Non : plus lent, 8 px/pose sur période 192 px -> 24 * 8 = 192 px !)
    proto_top_mist = np.zeros((H, 384, 4), dtype=np.uint8)
    top_mist_sites = (
        [(mist_sprites[1], 18, 212), (mist_sprites[3], 208, 356)]
        if is_arena_fin
        else [(mist_sprites[1], 24, 198), (mist_sprites[3], 214, 392)]
    )
    for sp, x0, y0 in top_mist_sites:
        sh, sw = sp.shape[:2]
        for dy in range(sh):
            yy = y0 + dy
            if 0 <= yy < H:
                for dx in range(sw):
                    if sp[dy, dx, 3] > 0:
                        px = sp[dy, dx].copy()
                        px[3] = max(22, int(px[3]) * 3 // 4)  # encore plus subtil en Top (~14%..21%)
                        proto_top_mist[yy, (x0 + dx) % 384] = px
    full_top_mist = np.tile(proto_top_mist, (1, 2, 1))[:, :W, :]

    wisp_anchors = (
        [(148, 430, 0), (602, 438, 1), (222, 248, 2), (532, 242, 3), (308, 474, 1)]
        if is_arena_fin
        else [(136, 314, 0), (598, 318, 2), (264, 214, 1), (496, 210, 3), (548, 428, 0)]
    )

    top_24: List[Image.Image] = []
    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)
        arr = np.roll(full_top_mist, shift=-((f * 16) % 384), axis=1).copy()
        for wx0, wy0, ph_i in wisp_anchors:
            w_step = ((f // 3) + ph_i) % 4
            w_spr = wisp_frames_4[w_step].copy()
            # Pulsation douce d'opacité (toujours faible opacité : ~20%..42%)
            breath = 0.82 + 0.18 * math.sin(theta + ph_i * 1.5)
            w_spr[:, :, 3] = np.clip(w_spr[:, :, 3].astype(np.float32) * breath, 0.0, 108.0).astype(np.uint8)
            wx = int(round(wx0 + 5.0 * math.sin(theta + ph_i * 1.3)))
            wy = int(round(wy0 + 4.0 * math.cos(theta + ph_i * 1.3)))
            _blit_alpha_over(arr, w_spr, wx, wy, wrap_x=False)
        # La canopée opaque des arbres couvre proprement par-dessus au besoin
        arr[can_op] = canopy_nat[can_op]
        top_24.append(Image.fromarray(arr, mode="RGBA"))

    return sky_static_1, toxic_bg_48, top_24


def build_tiny_woods_metano_flowers_and_canopy_layers(
    pure_grass_mask: np.ndarray,
    flora_mask: np.ndarray,
    rgb_nat: np.ndarray,
    solid_nat: np.ndarray,
    canopy_nat: np.ndarray,
    seed: int = 101,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit `(metano_flowers_24, canopy_top_24)` pour *Tiny Woods* (`TWE1` & `TWF1`) :
    - Fleurs animées 100 % natives `Metano_Town_Animation_Tileset.tile` posées strictement sur l'herbe franche
      (jamais sur les bûches/souches qui restent 100 % statiques !),
    - Canopée supérieure `Top` + quelques feuilles vertes uniquement sur le mur d'arbres Nord (`y <= 185`)."""
    del flora_mask, rgb_nat, solid_nat
    assets = extract_metano_water_and_flower_assets()
    fl_col_4: List[np.ndarray] = assets["metano_flowers_color_4"]  # type: ignore[assignment]
    fl_wht_4: List[np.ndarray] = assets["metano_flowers_white_4"]  # type: ignore[assignment]

    dist_grass = ndimage.distance_transform_edt(pure_grass_mask)
    taken = np.zeros((H, W), dtype=bool)
    sites: List[Tuple[int, int, str, int]] = []
    rng = np.random.default_rng(seed)
    cands = [(sy, sx) for sy in range(216, H - 36, 12) for sx in range(32, W - 48, 12)]
    rng.shuffle(cands)
    for sy, sx in cands:
        if 322 <= sx <= 438:
            continue
        kind = "color" if (len(sites) % 3 != 2) else "white"
        spr0 = fl_col_4[0] if kind == "color" else fl_wht_4[0]
        fh, fw = spr0.shape[:2]
        if sy + fh > H - 8 or sx + fw > W - 8:
            continue
        if (
            float(dist_grass[sy : sy + fh, sx : sx + fw].min()) >= 9.0
            and not taken[max(0, sy - 18) : min(H, sy + fh + 18), max(0, sx - 22) : min(W, sx + fw + 22)].any()
        ):
            taken[sy : sy + fh, sx : sx + fw] = True
            sites.append((sx, sy, kind, len(sites) % 4))
            if len(sites) >= 14:
                break

    # Feuilles vertes uniquement sur le mur d'arbres Nord (y = 24..175), jamais près des bûches/souches !
    n_leaves = 8
    lx0 = rng.integers(48, W - 48, size=n_leaves)
    ly0 = rng.integers(24, 175, size=n_leaves)
    lph = rng.uniform(0.0, 2.0 * math.pi, size=n_leaves)

    can_op = canopy_nat[:, :, 3] >= 128
    flowers_24: List[Image.Image] = []
    top_24: List[Image.Image] = []

    for pose in range(N_POSES):
        theta = 2.0 * math.pi * pose / float(N_POSES)
        flw = np.zeros((H, W, 4), dtype=np.uint8)
        for fx, fy, kind, ph_off in sites:
            f_step = ((pose + ph_off * 6) // 6) % 4
            spr = fl_col_4[f_step] if kind == "color" else fl_wht_4[f_step]
            fh, fw = spr.shape[:2]
            m = spr[:, :, 3] > 0
            flw[fy : fy + fh, fx : fx + fw][m] = spr[m]
        flowers_24.append(Image.fromarray(sanitize_rgba_binary(flw)))

        top_arr = np.zeros((H, W, 4), dtype=np.uint8)
        top_arr[can_op] = canopy_nat[can_op]
        for i in range(n_leaves):
            lx = int(round(lx0[i] + 8.0 * math.sin(theta + lph[i])))
            ly = int(round(ly0[i] + 4.0 * math.cos(theta + lph[i])))
            if 6 <= lx < W - 6 and 6 <= ly < 185 and math.sin(2.0 * theta + lph[i]) > -0.2:
                top_arr[ly, lx : lx + 2] = (104, 192, 64, 255)
                top_arr[ly + 1, lx - 1 : lx + 1] = (56, 136, 48, 255)
        top_24.append(Image.fromarray(sanitize_rgba_binary(top_arr)))

    return flowers_24, top_24


def build_forest_flora_layer_24(
    mode: str,
    flora_mask: np.ndarray,
    rgb_nat: np.ndarray,
    solid_nat: np.ndarray,
) -> List[Image.Image]:
    """Anime en 24 poses les fleurs sauvages ou la lueur bioluminescente des champignons (*Sinister Woods*, 0 décalage X)."""
    base_patch = np.zeros((H, W, 4), dtype=np.uint8)
    base_patch[flora_mask, :3] = rgb_nat[flora_mask]
    base_patch[flora_mask, 3] = 255

    frames: List[Image.Image] = []
    for f in range(N_POSES):
        theta = 2.0 * math.pi * f / float(N_POSES)
        dx = 0 if mode == "sinister_woods_mist" else int(round(math.sin(theta)))
        shifted = base_patch.copy() if dx == 0 else np.roll(base_patch, shift=dx, axis=1)
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
