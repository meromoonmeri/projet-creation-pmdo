#!/usr/bin/env python3
"""Assemble le brut `768 × 576` `#FF00FF`, le calque `Top` et la référence composite `ref_canon`
pour `MLS1` (*Sommet du Mont Lointain — Sanctuaire de Ho-Oh*, fusion `B72` + `H05P02`)."""
from __future__ import annotations

import math
import sys
from functools import lru_cache
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
for p in (str(REPO_ROOT), str(REPO_ROOT / "source")):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_cyclones_cylindriques_unova import H, N_POSES, W, sanitize_rgba_binary
from source.moteur_forets_pmd_red import (
    PURE_MAGENTA,
    _downsample_non_mixing,
    _keep_compact_blobs,
    _q8_u8,
    _sanitize_rgb_no_magenta,
)

GEN_DECOR_PATH = HERE / "bruts" / "decor_sommet_lointain_hooh_magenta.png"
GEN_CLOUDS_PATH = HERE / "bruts" / "mer_nuages_sacres_pmd_magenta.png"
OUT_BRUT_PATH = HERE / "bruts" / "base_mont_lointain_sommet.png"
OUT_CANOPY_PATH = HERE / "bruts" / "couronnes_piliers_top.png"
OUT_REF_CANON_PATH = HERE / "references" / "ref_canon_mont_lointain_sommet.png"


def _quantize_sommet_96c(rgb: np.ndarray, solid_mask: np.ndarray) -> np.ndarray:
    """Quantifie le sanctuaire karstique sur `<= 96` couleurs GBA (`MEDIANCUT`, `dither=NONE`)
    en préservant l'ivoire sacré `B72` et le vert émeraude des fougères suspendues."""
    work = rgb.copy()
    r0 = work[:, :, 0].astype(np.int16)
    g0 = work[:, :, 1].astype(np.int16)
    b0 = work[:, :, 2].astype(np.int16)

    near_mag = ndimage.binary_dilation(~solid_mask, iterations=5)
    interior = solid_mask & (~near_mag)

    med_col = np.median(work[solid_mask], axis=0).astype(np.uint8)
    work[~solid_mask] = med_col
    q_im = Image.fromarray(work, mode="RGB").quantize(colors=88, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    out = np.asarray(q_im.convert("RGB"), dtype=np.uint8).copy()

    fern_hi = _keep_compact_blobs(interior & (g0 >= 135) & (g0 > r0 + 20) & (g0 > b0 + 25), max_area=4500)
    fern_lo = _keep_compact_blobs(interior & (~fern_hi) & (g0 >= 90) & (g0 > r0 + 14) & (g0 > b0 + 16), max_area=4500)
    out[fern_hi] = (104, 168, 96)
    out[fern_lo] = (68, 124, 72)

    out = _sanitize_rgb_no_magenta(out, solid_mask)
    out[~solid_mask] = PURE_MAGENTA
    return out


@lru_cache(maxsize=4)
def extract_sacred_cloud_sprites(target_w: int = 512, target_h: int = 286) -> Dict[str, List[np.ndarray]]:
    """Extrait les bancs de nuages dorés-ivoire style PMD générés sur `#FF00FF` (`mer_nuages_sacres_pmd_magenta.png`)."""
    raw = np.asarray(Image.open(GEN_CLOUDS_PATH).convert("RGB"), dtype=np.uint8)
    rf, gf, bf = raw[:, :, 0].astype(np.float32), raw[:, :, 1].astype(np.float32), raw[:, :, 2].astype(np.float32)

    mag_core = (rf >= 200.0) & (gf <= 95.0) & (bf >= 190.0) & ((rf + bf - 2.0 * gf) >= 180.0)
    fringe = ndimage.binary_dilation(mag_core, iterations=4) & (rf > gf + 22.0) & (bf > gf + 18.0)
    fg_hi = ~(mag_core | fringe)

    rgb_lo, solid_lo = _downsample_non_mixing(raw, fg_hi, target_w, target_h)
    rl, gl, bl = rgb_lo[:, :, 0].astype(np.int16), rgb_lo[:, :, 1].astype(np.int16), rgb_lo[:, :, 2].astype(np.int16)
    solid_lo = solid_lo & ~((rl > gl + 16) & (bl > gl + 14))
    solid_lo = ndimage.binary_opening(solid_lo, structure=np.ones((2, 2), dtype=bool))

    pal = np.array(
        [
            [208, 184, 136],  # base ombrée ocre-ambre douce B72
            [232, 216, 160],  # mi-ton doré sacré
            [248, 240, 192],  # corps crème solaire
            [255, 252, 228],  # crête ivoire éclatante
        ],
        dtype=np.uint8,
    )

    lbl, n_c = ndimage.label(solid_lo)
    comps: List[Tuple[int, np.ndarray]] = []
    for cid in range(1, n_c + 1):
        ys, xs = np.where(lbl == cid)
        if ys.size < 20:
            continue
        y0, y1 = int(ys.min()), int(ys.max()) + 1
        x0, x1 = int(xs.min()), int(xs.max()) + 1
        sub_m = lbl[y0:y1, x0:x1] == cid
        sub_rgb = rgb_lo[y0:y1, x0:x1].astype(np.float32)
        lum = 0.299 * sub_rgb[:, :, 0] + 0.587 * sub_rgb[:, :, 1] + 0.114 * sub_rgb[:, :, 2]
        q25, q55, q80 = np.percentile(lum[sub_m], [25.0, 55.0, 80.0])
        idx = np.zeros(sub_m.shape, dtype=np.int32)
        idx[lum >= q25] = 1
        idx[lum >= q55] = 2
        idx[lum >= q80] = 3
        sp = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
        sp[sub_m, :3] = _sanitize_rgb_no_magenta(pal[idx], sub_m)[sub_m]
        sp[sub_m, 3] = 255
        comps.append((int(ys.size), sp))

    comps.sort(key=lambda t: -t[0])
    sprites = [sp for _, sp in comps]
    while len(sprites) < 7:
        sprites.append(sprites[-1])
    return {
        "majors": sprites[:2],
        "mediums": sprites[2:5],
        "wisps": sprites[5:7],
    }


def _blit_periodic_cloud_band(
    proto: np.ndarray,
    placements: List[Tuple[np.ndarray, int, int]],
    period_w: int,
) -> None:
    for sp, x0, y0 in placements:
        sh, sw = sp.shape[:2]
        for dy in range(sh):
            yy = y0 + dy
            if 0 <= yy < H:
                op = sp[dy, :, 3] == 255
                if np.any(op):
                    xs_s = np.where(op)[0]
                    xs_d = (x0 + xs_s) % period_w
                    proto[yy, xs_d, :3] = sp[dy, xs_s, :3]
                    proto[yy, xs_d, 3] = 255


def build_sommet_hooh_atmosphere_layers(
    mag_mask: np.ndarray,
    canopy_nat: np.ndarray,
    single_pose_preview: bool = False,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit `(sky_1, cloud_sea_far_64, rainbows_h05p02_24, cloud_billows_near_64, mist_and_feathers_top_24)`
    pour `MLS1` (*Sommet du Mont Lointain — Sanctuaire de Ho-Oh* `B72` + `H05P02`)."""
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)

    # 1. Calque 00 (statique, poses=1) : Voûte céleste courbée H05P02 (Rainbow Peak) -> horizon doré B72
    curve = 30.0 * (((xx - 384.0) / 384.0) ** 2)
    y_eff = yy + curve
    t_sky = np.clip(y_eff / 192.0, 0.0, 1.0)
    r_s = np.where(y_eff < 192.0, 80.0 + 168.0 * (t_sky**1.15), 248.0)
    g_s = np.where(y_eff < 192.0, 148.0 + 92.0 * (t_sky**0.95), 240.0)
    b_s = np.where(y_eff < 192.0, 224.0 - 28.0 * (t_sky**1.35), 196.0)
    sky_rgb = _sanitize_rgb_no_magenta(_q8_u8(np.stack([r_s, g_s, b_s], axis=-1)), mag_mask)
    sky_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    sky_rgba[mag_mask, :3] = sky_rgb[mag_mask]
    sky_rgba[mag_mask, 3] = 255
    sky_1 = [Image.fromarray(sanitize_rgba_binary(sky_rgba))]

    # 2. Calque 01 (64 poses @ 45 ticks = 2880t, 34560/2880=12 exact, 4 px/pose -> 5.3 px/s ultra-lent) :
    #    Mer de nuages sacrée B72 couvrant tout l'abîme bas (y_eff >= 184) + bancs de nuages lointains PMD
    fams_far = extract_sacred_cloud_sprites(target_w=360, target_h=200)
    fams_near = extract_sacred_cloud_sprites(target_w=496, target_h=276)

    # Base stratifiée de la mer de nuages dans le gouffre (y_eff >= 186)
    sea_base = np.zeros((H, 256, 4), dtype=np.uint8)
    yy_p, xx_p = np.mgrid[0:H, 0:256].astype(np.float32)
    wave1 = 7.0 * np.sin(2.0 * math.pi * xx_p / 128.0) + 4.0 * np.cos(2.0 * math.pi * xx_p / 64.0)
    sea_top_y = 186.0 + wave1
    in_sea = yy_p >= sea_top_y
    depth_s = yy_p - sea_top_y
    sea_pal = np.array(
        [
            [255, 252, 228],  # crête d'écume solaire
            [248, 240, 192],  # nappe crème B72
            [236, 220, 168],  # creux doré chaud
            [220, 200, 148],  # ombre douce profonde
        ],
        dtype=np.uint8,
    )
    s_idx = np.zeros(yy_p.shape, dtype=np.int32)
    s_idx[depth_s >= 10.0] = 1
    s_idx[depth_s >= 56.0] = 2
    s_idx[depth_s >= 145.0] = 3
    sea_base[in_sea, :3] = sea_pal[s_idx][in_sea]
    sea_base[in_sea, 3] = 255

    far_placements = [
        (fams_far["mediums"][0], 14, 136),
        (fams_far["wisps"][0], 98, 92),
        (fams_far["mediums"][1], 144, 146),
        (fams_far["wisps"][1], 204, 108),
    ]
    _blit_periodic_cloud_band(sea_base, far_placements, period_w=256)
    full_far = np.tile(sea_base, (1, 3, 1))[:, :W, :]

    n_far = 1 if single_pose_preview else 64
    cloud_sea_far_64: List[Image.Image] = []
    for f in range(n_far):
        rolled = np.roll(full_far, shift=(f * 4) % W, axis=1).copy()
        rolled[~mag_mask, :] = 0
        cloud_sea_far_64.append(Image.fromarray(sanitize_rgba_binary(rolled)))

    # 3. Calque 02 (24 poses @ 5 ticks) : Arcs-en-ciel sacrés pixel-art GBA H05P02 (Rainbow Peak) !
    #    - Grand arc céleste couronnant le sanctuaire Nord (cx=384, cy=252, R=226)
    #    - Deux ponts d'arc-en-ciel latéraux émergeant de la mer de nuages (B72 / H05P02)
    rb_bands = np.array(
        [
            [248, 136, 136],  # rouge corail pastel GBA
            [248, 192, 120],  # ambre orangé
            [248, 240, 144],  # or solaire
            [152, 232, 160],  # vert jade tendre
            [136, 208, 240],  # azur céleste
            [184, 168, 232],  # lavande irisée (sans magenta : G=168 !)
        ],
        dtype=np.uint8,
    )
    arcs_spec = [
        (384.0, 258.0, 224.0, 3.2, 238),  # Grand arc céleste au-dessus du monolithe Nord (pieds nichés derrière les pics)
        (92.0, 428.0, 132.0, 2.5, 398),   # Arche arc-en-ciel Ouest émergeant de la mer de nuages (fidèle B72)
        (676.0, 428.0, 132.0, 2.5, 398),  # Arche arc-en-ciel Est émergeant de la mer de nuages (fidèle B72)
    ]
    n_rb = 1 if single_pose_preview else N_POSES
    rainbows_24: List[Image.Image] = []
    for f in range(n_rb):
        theta = 2.0 * math.pi * f / float(N_POSES)
        rb_canvas = np.zeros((H, W, 4), dtype=np.uint8)
        shimmer = int(round(4.0 * math.sin(theta)))
        for acx, acy, r_in, bw, ymax_vis in arcs_spec:
            dist_r = np.sqrt((xx - acx) ** 2 + (yy - acy) ** 2)
            # Quantification pixel-art GBA sur pas de 2 px
            band_f = (dist_r - r_in) / bw
            in_arc = mag_mask & (yy <= ymax_vis) & (yy < acy - 8.0) & (band_f >= 0.0) & (band_f < 6.0)
            if not np.any(in_arc):
                continue
            b_idx = np.clip(band_f.astype(np.int32), 0, 5)
            cols = np.clip(rb_bands[b_idx].astype(np.int16) + shimmer, 0, 255).astype(np.uint8)
            cols = _sanitize_rgb_no_magenta(cols, in_arc)
            # Adoucit l'extrémité basse de l'arc par tramage pixel-art GBA net (alpha binaire)
            fade_t = np.clip((ymax_vis - yy) / 28.0, 0.0, 1.0)
            checker = (((xx.astype(np.int32) // 2) + (yy.astype(np.int32) // 2)) % 2) == 0
            keep_arc = in_arc & ((fade_t >= 0.55) | ((fade_t >= 0.20) & checker))
            rb_canvas[keep_arc, :3] = cols[keep_arc]
            rb_canvas[keep_arc, 3] = 255
        rainbows_24.append(Image.fromarray(sanitize_rgba_binary(rb_canvas)))

    # 4. Calque 03 (64 poses @ 36 ticks = 2304t, 34560/2304=15 exact, 6 px/pose -> 10.0 px/s lent) :
    #    Grandes vagues sculpturales de cumulus PMD dorés au premier plan de la mer de nuages
    proto_near = np.zeros((H, 384, 4), dtype=np.uint8)
    near_placements = [
        (fams_near["majors"][0], 8, 224),
        (fams_near["mediums"][0], 206, 268),
        (fams_near["majors"][1], 36, 368),
        (fams_near["mediums"][1], 218, 412),
        (fams_near["mediums"][2], 118, 488),
        (fams_near["wisps"][0], 22, 42),
        (fams_near["wisps"][1], 246, 32),
    ]
    _blit_periodic_cloud_band(proto_near, near_placements, period_w=384)
    full_near = np.tile(proto_near, (1, 2, 1))[:, :W, :]

    n_near = 1 if single_pose_preview else 64
    cloud_billows_near_64: List[Image.Image] = []
    for f in range(n_near):
        rolled = np.roll(full_near, shift=-((f * 6) % W), axis=1).copy()
        rolled[~mag_mask, :] = 0
        cloud_billows_near_64.append(Image.fromarray(sanitize_rgba_binary(rolled)))

    # 5. Calque 09 Top (24 poses @ 6 ticks) :
    #    Couronnes des piliers périphériques + colliers d'écume nuageuse au pied des aiguilles flottantes
    #    + fines écharpes de brume dorée faible opacité + plumes irisées de Ho-Oh
    can_op = canopy_nat[:, :, 3] >= 128
    wisp_spr = fams_far["wisps"][0].copy()
    wisp_low = wisp_spr.copy()
    wisp_low[:, :, 3] = np.where(wisp_spr[:, :, 3] > 0, 44, 0).astype(np.uint8)

    # Colliers de nuages dorés enveloppant la base des aiguilles flottantes latérales (comme dans B72 !)
    collar_spr = fams_far["mediums"][0].copy()
    base_collars = np.zeros((H, W, 4), dtype=np.uint8)
    for cx0, cy0 in (
        (-8, 368),
        (704, 368),
        (98, 166),
        (564, 184),
        (52, 540),
        (618, 540),
        (142, 508),
        (542, 508),
    ):
        sh, sw = collar_spr.shape[:2]
        for dy in range(sh):
            yy_i = cy0 + dy
            if 0 <= yy_i < H:
                for dx in range(sw):
                    xx_i = cx0 + dx
                    if 0 <= xx_i < W and collar_spr[dy, dx, 3] == 255:
                        base_collars[yy_i, xx_i] = collar_spr[dy, dx]

    proto_top_mist = np.zeros((H, 384, 4), dtype=np.uint8)
    for wx0, wy0 in ((24, 198), (218, 336), (96, 468)):
        sh, sw = wisp_low.shape[:2]
        for dy in range(sh):
            yy_i = wy0 + dy
            if 0 <= yy_i < H:
                for dx in range(sw):
                    if wisp_low[dy, dx, 3] > 0:
                        proto_top_mist[yy_i, (wx0 + dx) % 384] = wisp_low[dy, dx]
    full_top_mist = np.tile(proto_top_mist, (1, 2, 1))[:, :W, :]

    rng = np.random.default_rng(720502)
    n_motes = 24
    mx0 = rng.integers(96, W - 96, size=n_motes)
    my0 = rng.integers(88, H - 48, size=n_motes)
    mph = rng.uniform(0.0, 2.0 * math.pi, size=n_motes)
    feather_cols = [
        (255, 244, 168, 196),
        (176, 240, 184, 188),
        (168, 224, 248, 188),
        (248, 192, 152, 196),
    ]

    col_op = base_collars[:, :, 3] == 255
    n_top = 1 if single_pose_preview else N_POSES
    top_24: List[Image.Image] = []
    for f in range(n_top):
        theta = 2.0 * math.pi * f / float(N_POSES)
        arr = np.roll(full_top_mist, shift=(f * 16) % 384, axis=1).copy()
        # Légère respiration horizontale (+/- 2 px) des colliers de nuages au pied des piliers
        dx_col = int(round(2.0 * math.sin(theta)))
        col_shifted = np.roll(base_collars, shift=dx_col, axis=1) if dx_col != 0 else base_collars
        if dx_col > 0:
            col_shifted[:, :dx_col] = 0
        elif dx_col < 0:
            col_shifted[:, dx_col:] = 0
        c_hit = col_shifted[:, :, 3] == 255
        arr[c_hit] = col_shifted[c_hit]
        if not single_pose_preview:
            for i in range(n_motes):
                px = int(round(mx0[i] + 6.0 * math.sin(theta + mph[i])))
                py = int(round(my0[i] + 4.0 * math.cos(theta + mph[i])))
                if 6 <= px < W - 6 and 6 <= py < H - 6 and math.sin(2.0 * theta + mph[i]) > 0.15:
                    col = feather_cols[i % len(feather_cols)]
                    arr[py, px : px + 2] = col
                    if math.sin(2.0 * theta + mph[i]) > 0.65:
                        arr[py - 1, px] = (255, 252, 232, 220)
        arr[can_op & (~col_op)] = canopy_nat[can_op & (~col_op)]
        top_24.append(Image.fromarray(arr, mode="RGBA"))

    return sky_1, cloud_sea_far_64, rainbows_24, cloud_billows_near_64, top_24


def assemble_mont_lointain_sommet_1x() -> Dict[str, str]:
    raw = np.asarray(Image.open(GEN_DECOR_PATH).convert("RGB"), dtype=np.uint8)
    rf, gf, bf = raw[:, :, 0].astype(np.float32), raw[:, :, 1].astype(np.float32), raw[:, :, 2].astype(np.float32)

    core = (rf >= 210.0) & (gf <= 65.0) & (bf >= 205.0) & ((rf + bf - 2.0 * gf) >= 180.0)
    lbl_c, _ = ndimage.label(core)
    c_sizes = np.bincount(lbl_c.ravel())
    keep_c = c_sizes >= 180
    keep_c[0] = False
    valid_core = keep_c[lbl_c]

    near_mag = ndimage.binary_dilation(valid_core, iterations=12)
    fringe = near_mag & (rf > 1.24 * gf + 8.0) & (bf > 1.14 * gf + 8.0)
    fg_hi = ~(valid_core | fringe)

    # Placement du sanctuaire sur y = 52..576 (524 px de haut) pour ouvrir 52 px de ciel azur H05P02
    # et le grand arc-en-ciel sacré de Ho-Oh au-dessus du monolithe Nord !
    dst_y0 = 52
    sub_rgb, sub_solid = _downsample_non_mixing(raw, fg_hi, W, H - dst_y0)

    rgb_768 = np.tile(PURE_MAGENTA, (H, W, 1))
    solid_768 = np.zeros((H, W), dtype=bool)
    rgb_768[dst_y0:, :] = sub_rgb
    solid_768[dst_y0:, :] = sub_solid

    # Couronne organique arrondie sur les 8 px du sommet du monolithe Nord (zéro coupe plate à y=52)
    for dy_c in range(8):
        y_r = dst_y0 + dy_c
        xs_r = np.where(solid_768[y_r, 320:448])[0] + 320
        if xs_r.size > 16:
            cx_m = 0.5 * float(xs_r[0] + xs_r[-1])
            half_w = 0.5 * float(xs_r[-1] - xs_r[0])
            allow_hw = half_w * math.sqrt((dy_c + 1.0) / 8.5)
            trim_cols = (np.arange(W) >= 320) & (np.arange(W) < 448) & (np.abs(np.arange(W) - cx_m) > allow_hw)
            solid_768[y_r, trim_cols] = False

    # Absorption itérative des éventuelles franges roses/prunes en bordure de #FF00FF
    r7, g7, b7 = rgb_768[:, :, 0].astype(np.int16), rgb_768[:, :, 1].astype(np.int16), rgb_768[:, :, 2].astype(np.int16)
    for _ in range(7):
        adj_mag = ndimage.binary_dilation(~solid_768, iterations=1)
        rim = solid_768 & adj_mag & (r7 > g7 + 18) & (b7 > g7 + 12)
        if not np.any(rim):
            break
        solid_768 = solid_768 & (~rim)

    rgb_768 = _quantize_sommet_96c(rgb_768, solid_768)
    mag_768 = ~solid_768

    OUT_BRUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(rgb_768, mode="RGB").save(OUT_BRUT_PATH)

    # Calque Top : cimes des piliers karstiques périphériques (strictement hors plateau central et escalier Sud !)
    yy7, xx7 = np.mgrid[0:H, 0:W]
    outer_pillars_top = (
        solid_768
        & ((xx7 < 164) | (xx7 > W - 164))
        & (yy7 >= 92)
        & (yy7 <= 440)
    )
    below_mag = ndimage.binary_dilation(
        ~solid_768,
        structure=np.array([[0, 0, 0], [0, 1, 0], [0, 1, 0]], dtype=bool),
        iterations=18,
    )
    canopy_mask = outer_pillars_top & below_mag
    canopy_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    canopy_rgba[canopy_mask, :3] = rgb_768[canopy_mask]
    canopy_rgba[canopy_mask, 3] = 255
    OUT_CANOPY_PATH.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(canopy_rgba, mode="RGBA").save(OUT_CANOPY_PATH)

    # Construction de `ref_canon` sans magenta (pose 0 composite, incluant les colliers de nuages Top)
    ref_rgb = rgb_768.copy()
    sky0, far0, rb0, near0, top0 = build_sommet_hooh_atmosphere_layers(mag_768, canopy_rgba, single_pose_preview=True)
    for lay_im in (sky0[0], far0[0], near0[0], rb0[0]):
        la = np.asarray(lay_im, dtype=np.uint8)
        m = (la[:, :, 3] == 255) & mag_768
        ref_rgb[m] = la[m, :3]
    top_a = np.asarray(top0[0], dtype=np.uint8)
    top_op = top_a[:, :, 3] == 255
    ref_rgb[top_op] = top_a[top_op, :3]

    OUT_REF_CANON_PATH.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(ref_rgb, mode="RGB").save(OUT_REF_CANON_PATH)

    return {
        "brut": str(OUT_BRUT_PATH),
        "canopy": str(OUT_CANOPY_PATH),
        "ref_canon": str(OUT_REF_CANON_PATH),
    }


if __name__ == "__main__":
    res = assemble_mont_lointain_sommet_1x()
    print("OK ->", res)
