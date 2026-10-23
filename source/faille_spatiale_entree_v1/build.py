#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — FSE1 : Faille Spatiale — Entrée du Canyon Dimensionnel (Zarbis & Cosmos).

Séquence temporelle complète en 24 poses (`120` ticks sans couture, `768 × 576`, `96 × 72` tuiles, `10` calques) :
  - **Acte I (`Poses 0..2`)** : Le canyon possède un **fond rocheux complet** (parois rocheuses profondes dans les
    gorges Est/Ouest + muraille rocheuse Nord scellée par couture DP `D46P41A / D45P42A`), entaillé par les premières
    fissures brisées blanc-perle *Spatio-Rift* de la réalité ;
  - **Acte II (`Poses 3..11`)** : Les fissures cristallines déchirent la roche en brèches étoilées d'où gronde une
    **distorsion spatiale tourbillonnante** libérant une **nuée massive de `132` Zarbis officiels PMDO (`#0201`,
    toutes les `28` formes `A–Z`, `!` et `?`, orientés selon leur vecteur d'envol en `BG` et `Top`)** ;
  - **Acte III (`Poses 12..19`)** : Les parois rocheuses fissurées du fond du canyon éclatent complètement pour laisser
    place au **Portail *Spatio-Rift* blanc-perle au Nord** et au **Cosmos dimensionnel distordu étoilé** tout autour du
    canyon tandis que la nuée massive de Zarbis tourbillonne dans l'espace ouvert ;
  - **Acte IV (`Poses 20..23`)** : Onde de rappel gravitationnel *Spatio-Rift* refermant les failles sans couture vers `Pose 0`.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

SOURCE_DIR = Path(__file__).resolve().parent.parent
if str(SOURCE_DIR) not in sys.path:
    sys.path.insert(0, str(SOURCE_DIR))

from moteur_legendaires_zekrom_dialga_palkia import (  # type: ignore
    build_spatial_rift_layers,
    clean_brut_magenta_fringe,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "FSE1"
MAP_TITLE = "Faille Spatiale — Canyon, Zarbis & Cosmos Étoilé"

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent
BRUT_PATH = HERE / "bruts" / "base_faille_spatiale_entree.png"
RAW_BRUT_PNG = BRUT_PATH
SEALED_CANYON_PNG = HERE / "bruts" / "paroi_rocheuse_canyon_avant_faille.png"
FSA1_BRUT_PATH = SOURCE_DIR / "faille_spatiale_sanctuaire_v1" / "bruts" / "base_faille_spatiale_sanctuaire.png"
UNOWN_ATLAS_PNG = SOURCE_DIR / "assets_gba_pmd_red" / "unown_28forms_idle_pmdo_chunsoft.png"
CANON_REF = SOURCE_DIR / "faille_spatiale_sanctuaire_v1" / "references" / "d45p42a_deep_spatial_rift_boss_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "faille_spatiale_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"

UNOWN_CELL_W = 32
UNOWN_CELL_H = 40


def _to_imgs(arrs: List[np.ndarray]) -> List[Image.Image]:
    return [Image.fromarray(a, mode="RGBA") for a in arrs]


def _draw_crisp_polyline(mask: np.ndarray, pts: List[Tuple[float, float]], progress: float) -> None:
    """Trace une ligne brisée cristalline 1 px jusqu'à `progress in [0, 1]` (ZÉRO trait à la règle rigide)."""
    if len(pts) < 2 or progress <= 0.0:
        return
    h, w = mask.shape
    seg_lens = [
        float(np.hypot(pts[i + 1][0] - pts[i][0], pts[i + 1][1] - pts[i][1]))
        for i in range(len(pts) - 1)
    ]
    total = sum(seg_lens)
    if total <= 0.5:
        return
    budget = total * float(np.clip(progress, 0.0, 1.0))
    for i, sl in enumerate(seg_lens):
        if budget <= 0.0:
            break
        u = min(1.0, budget / max(1e-3, sl))
        x0, y0 = pts[i]
        x1 = x0 + (pts[i + 1][0] - x0) * u
        y1 = y0 + (pts[i + 1][1] - y0) * u
        steps = max(int(round(max(abs(x1 - x0), abs(y1 - y0)))), 1)
        xs = np.rint(np.linspace(x0, x1, steps + 1)).astype(np.int32)
        ys = np.rint(np.linspace(y0, y1, steps + 1)).astype(np.int32)
        ok = (xs >= 0) & (xs < w) & (ys >= 0) & (ys < h)
        mask[ys[ok], xs[ok]] = True
        budget -= sl


def _dp_min_error_seam_vertical(patch_l: np.ndarray, patch_r: np.ndarray) -> np.ndarray:
    """Couture verticale de coût minimal Efros-Freeman (0 flou, 100 % vrais pixels Chunsoft)."""
    hp, wov, _ = patch_l.shape
    diff = np.sum((patch_l.astype(np.float32) - patch_r.astype(np.float32)) ** 2, axis=2)
    cost = diff.copy()
    back = np.zeros((hp, wov), dtype=np.int32)
    for y in range(1, hp):
        prev = cost[y - 1]
        for x in range(wov):
            x0 = max(0, x - 1)
            x1 = min(wov, x + 2)
            idx = x0 + int(np.argmin(prev[x0:x1]))
            cost[y, x] += prev[idx]
            back[y, x] = idx
    seam = np.zeros(hp, dtype=np.int32)
    seam[-1] = int(np.argmin(cost[-1]))
    for y in range(hp - 2, -1, -1):
        seam[y] = back[y + 1, seam[y + 1]]
    out = patch_r.copy()
    xx = np.arange(wov)[None, :]
    use_l = xx <= seam[:, None]
    out[use_l] = patch_l[use_l]
    return out


def _dp_min_error_seam_horizontal(patch_top: np.ndarray, patch_bot: np.ndarray) -> np.ndarray:
    """Couture horizontale de coût minimal Efros-Freeman (0 flou, 100 % vrais pixels Chunsoft)."""
    hov, wp, _ = patch_top.shape
    diff = np.sum((patch_top.astype(np.float32) - patch_bot.astype(np.float32)) ** 2, axis=2)
    cost = diff.copy()
    back = np.zeros((hov, wp), dtype=np.int32)
    for x in range(1, wp):
        prev = cost[:, x - 1]
        for y in range(hov):
            y0 = max(0, y - 1)
            y1 = min(hov, y + 2)
            idx = y0 + int(np.argmin(prev[y0:y1]))
            cost[y, x] += prev[idx]
            back[y, x] = idx
    seam = np.zeros(wp, dtype=np.int32)
    seam[-1] = int(np.argmin(cost[:, -1]))
    for x in range(wp - 2, -1, -1):
        seam[x] = back[seam[x + 1], x + 1]
    out = patch_bot.copy()
    yy = np.arange(hov)[:, None]
    use_t = yy <= seam[None, :]
    out[use_t] = patch_top[use_t]
    return out


def _reconstruct_rocky_canyon_background(
    rgb_canyon: np.ndarray,
    solid_mask: np.ndarray,
    portal_mask: np.ndarray,
    void_mask: np.ndarray,
) -> np.ndarray:
    """Construit le background rocheux complet du canyon (`768 × 576`, 0 flou, pied rocheux organique au Nord)."""
    h, w, _ = rgb_canyon.shape
    sx = w / float(W_CANON)
    sy = h / float(H_CANON)

    im_fsa = Image.open(FSA1_BRUT_PATH).convert("RGB")
    if im_fsa.size != (w, h):
        im_fsa = im_fsa.resize((w, h), Image.Resampling.NEAREST)
    raw_fsa = np.asarray(im_fsa, dtype=np.uint8)
    mag_fsa = (raw_fsa[:, :, 0] >= 215) & (raw_fsa[:, :, 1] <= 50) & (raw_fsa[:, :, 2] >= 215)
    clean_fsa = clean_brut_magenta_fringe(raw_fsa, mag_fsa)

    ly0, ly1 = int(round(220 * sy)), int(round(390 * sy))
    p_l = clean_fsa[ly0:ly1, int(round(130 * sx)) : int(round(260 * sx))].copy()
    p_r = clean_fsa[ly0:ly1, int(round(508 * sx)) : int(round(638 * sx))].copy()
    hp = min(p_l.shape[0], p_r.shape[0])
    p_l, p_r = p_l[:hp], p_r[:hp]
    ov = max(8, int(round(34 * sx)))
    qw = p_l.shape[1] + p_r.shape[1] - ov
    north_quilt = np.zeros((hp, qw, 3), dtype=np.uint8)
    north_quilt[:, : p_l.shape[1] - ov] = p_l[:, : p_l.shape[1] - ov]
    north_quilt[:, p_l.shape[1] - ov : p_l.shape[1]] = _dp_min_error_seam_vertical(
        p_l[:, p_l.shape[1] - ov :], p_r[:, :ov]
    )
    north_quilt[:, p_l.shape[1] :] = p_r[:, ov:]
    nq_f = north_quilt.astype(np.float32)
    nq_f[:, :, 0] = np.clip(nq_f[:, :, 0] * 0.88 + 4.0, 10, 210)
    nq_f[:, :, 1] = np.clip(nq_f[:, :, 1] * 0.90 + 5.0, 12, 210)
    nq_f[:, :, 2] = np.clip(nq_f[:, :, 2] * 0.94 + 8.0, 18, 232)
    north_quilt = np.rint(nq_f).astype(np.uint8)

    hov = max(8, int(round(28 * sy)))
    step_h = max(16, hp - hov)
    tall_h = h + hp
    tall_quilt = np.zeros((tall_h, qw, 3), dtype=np.uint8)
    tall_quilt[:hp] = north_quilt
    cur_y = hp
    flip_idx = 0
    while cur_y < tall_h:
        tile_blk = north_quilt[:, ::-1].copy() if (flip_idx % 2 == 1) else north_quilt.copy()
        rem = min(step_h, tall_h - cur_y)
        seam_band = _dp_min_error_seam_horizontal(
            tall_quilt[cur_y - hov : cur_y], tile_blk[:hov]
        )
        tall_quilt[cur_y - hov : cur_y] = seam_band
        tall_quilt[cur_y : cur_y + rem] = tile_blk[hov : hov + rem]
        cur_y += rem
        flip_idx += 1

    cliff_strip_l = rgb_canyon[:, int(round(132 * sx)) : int(round(252 * sx))].copy()
    cliff_strip_r = rgb_canyon[:, int(round(516 * sx)) : int(round(636 * sx))].copy()

    gorge_canvas = np.zeros((h, w, 3), dtype=np.uint8)
    w_q = tall_quilt.shape[1]
    for x0 in range(0, w, w_q):
        rem_w = min(w_q, w - x0)
        y_off = (37 * (x0 // max(1, w_q))) % max(1, hp // 2)
        gorge_canvas[:, x0 : x0 + rem_w] = tall_quilt[y_off : y_off + h, :rem_w]

    sw_l = min(cliff_strip_l.shape[1], int(round(118 * sx)))
    sw_r = min(cliff_strip_r.shape[1], int(round(118 * sx)))
    shift_y = int(round(44 * sy))
    gorge_canvas[:, :sw_l] = np.where(
        (np.roll(cliff_strip_l[:, :sw_l], shift_y, axis=0).sum(axis=2, keepdims=True) > 60),
        (
            0.55 * np.roll(cliff_strip_l[:, :sw_l], shift_y, axis=0).astype(np.float32)
            + 0.45 * gorge_canvas[:, :sw_l].astype(np.float32)
        ).astype(np.uint8),
        gorge_canvas[:, :sw_l],
    )
    gorge_canvas[:, w - sw_r :] = np.where(
        (np.roll(cliff_strip_r[:, -sw_r:], -shift_y, axis=0).sum(axis=2, keepdims=True) > 60),
        (
            0.55 * np.roll(cliff_strip_r[:, -sw_r:], -shift_y, axis=0).astype(np.float32)
            + 0.45 * gorge_canvas[:, w - sw_r :].astype(np.float32)
        ).astype(np.uint8),
        gorge_canvas[:, w - sw_r :],
    )

    dist_cliff = ndimage.distance_transform_edt(~solid_mask).astype(np.float32)
    depth_shade = np.where(
        dist_cliff <= 5.0 * sx,
        0.46,
        np.where(dist_cliff <= 12.0 * sx, 0.59, 0.72),
    )[:, :, None]
    gorge_shaded = np.clip(
        gorge_canvas.astype(np.float32) * depth_shade + np.array([3.0, 4.0, 9.0]), 8, 225
    ).astype(np.uint8)

    out = rgb_canyon.copy()
    out[void_mask] = gorge_shaded[void_mask]

    r_c = out[:, :, 0].astype(np.int32)
    g_c = out[:, :, 1].astype(np.int32)
    b_c = out[:, :, 2].astype(np.int32)
    purple_halo = solid_mask & ndimage.binary_dilation(portal_mask, iterations=max(3, int(round(10 * sx)))) & (
        ((r_c - g_c) >= 16) | (b_c >= 122)
    )
    north_canvas = out.copy()
    nx0 = max(0, (w - qw) // 2)
    ny_end = min(h, hp)
    nx_end = min(w, nx0 + qw)
    north_canvas[:ny_end, nx0:nx_end] = north_quilt[:ny_end, : nx_end - nx0]
    if int(round(0.36 * h)) > ny_end:
        y2_end = int(round(0.36 * h))
        north_canvas[ny_end:y2_end, nx0:nx_end] = north_quilt[: y2_end - ny_end, : nx_end - nx0]

    # Silhouette organique d'éboulis au pied de la muraille Nord + ombre de contact sur le sol du canyon
    yy, xx = np.mgrid[0:h, 0:w]
    dist_p = ndimage.distance_transform_edt(~portal_mask).astype(np.float32)
    ang_p = np.arctan2(yy - h * 0.14, xx - w * 0.50)
    rock_tex = (
        north_canvas[:, :, 0].astype(np.float32) * 0.30
        + north_canvas[:, :, 1].astype(np.float32) * 0.59
        + north_canvas[:, :, 2].astype(np.float32) * 0.11
    )
    jagged_p = (9.0 + 4.5 * np.sin(6.0 * ang_p + 0.5) + 3.0 * np.cos(13.0 * ang_p) + 0.05 * rock_tex) * sx
    seal_north = (portal_mask | purple_halo | (dist_p <= jagged_p)) & (yy < int(round(0.35 * h))) & (~void_mask)
    out[seal_north] = north_canvas[seal_north]

    # Ombre d'assise rocheuse nette sous les blocs Nord posés sur le sol du canyon
    foot_shadow = (
        ndimage.binary_dilation(seal_north, iterations=max(2, int(round(4 * sx))))
        & (~seal_north)
        & (yy >= int(round(0.26 * h)))
    )
    out[foot_shadow] = np.clip(out[foot_shadow].astype(np.int32) * 56 // 100, 14, 255).astype(np.uint8)
    return out


def _load_unown_atlas(scale_xy: float) -> List[List[List[np.ndarray]]]:
    """Charge les `28` formes officielles Chunsoft PMDO de Zarbi (`A–Z`, `!`, `?` × `8` directions × `4` poses)."""
    im = Image.open(UNOWN_ATLAS_PNG).convert("RGBA")
    arr = np.asarray(im, dtype=np.uint8)
    forms_out: List[List[List[np.ndarray]]] = []
    for f_idx in range(28):
        ox = (f_idx % 7) * (4 * UNOWN_CELL_W)
        oy = (f_idx // 7) * (8 * UNOWN_CELL_H)
        dirs_list: List[List[np.ndarray]] = []
        for r_dir in range(8):
            fr_list: List[np.ndarray] = []
            for c_fr in range(4):
                cell = arr[
                    oy + r_dir * UNOWN_CELL_H : oy + (r_dir + 1) * UNOWN_CELL_H,
                    ox + c_fr * UNOWN_CELL_W : ox + (c_fr + 1) * UNOWN_CELL_W,
                ]
                if abs(scale_xy - 1.0) > 1e-3:
                    nw = max(6, int(round(UNOWN_CELL_W * scale_xy)))
                    nh = max(8, int(round(UNOWN_CELL_H * scale_xy)))
                    sub_im = Image.fromarray(cell, mode="RGBA").resize((nw, nh), Image.Resampling.NEAREST)
                    cell = np.asarray(sub_im, dtype=np.uint8).copy()
                    cell[:, :, 3] = np.where(cell[:, :, 3] >= 128, 255, 0)
                fr_list.append(cell)
            dirs_list.append(fr_list)
        forms_out.append(dirs_list)
    return forms_out


def _vec_to_pmdo_dir(dx: float, dy: float) -> int:
    """Convertit `(dx, dy)` vers l'une des 8 directions natives PMDO (`0=Down .. 7=DownLeft`)."""
    ang = float(np.arctan2(dy, dx))
    rel = (0.5 * np.pi - ang) % (2.0 * np.pi)
    return int(np.rint(rel / (0.25 * np.pi))) % 8


def _blit_sprite(canvas: np.ndarray, spr: np.ndarray, cx: int, cy: int, aura: bool = False) -> None:
    """Colle un sprite RGBA net (`alpha in {0, 255}`) centré en `(cx, cy)` avec halo dimensionnel optionnel."""
    h, w, _ = canvas.shape
    sh, sw, _ = spr.shape
    x0 = cx - sw // 2
    y0 = cy - sh // 2
    x1 = x0 + sw
    y1 = y0 + sh
    if x1 <= 0 or y1 <= 0 or x0 >= w or y0 >= h:
        return
    sx0 = max(0, -x0)
    sy0 = max(0, -y0)
    sx1 = sw - max(0, x1 - w)
    sy1 = sh - max(0, y1 - h)
    dx0 = max(0, x0)
    dy0 = max(0, y0)
    dx1 = dx0 + (sx1 - sx0)
    dy1 = dy0 + (sy1 - sy0)
    sub = spr[sy0:sy1, sx0:sx1]
    m = sub[:, :, 3] == 255
    if not np.any(m):
        return
    if aura:
        dil = ndimage.binary_dilation(m, iterations=1) & (~m)
        dst_view = canvas[dy0:dy1, dx0:dx1]
        aura_ok = dil & (dst_view[:, :, 3] == 0)
        dst_view[aura_ok] = (218, 108, 252, 255)
    canvas[dy0:dy1, dx0:dx1][m] = sub[m]


def _phase_curves(f: int, n_frames: int = N_FRAMES) -> Tuple[float, float, float]:
    """Courbes temporelles synchronisées sur les `24` poses."""
    if f == 0:
        return 0.0, 0.0, 0.0
    if f <= 19:
        crack_t = float(np.clip(f / 6.0, 0.0, 1.0))
        unown_t = float(np.clip((f - 1.5) / 14.5, 0.0, 1.0))
        cosmos_t = float(np.clip((f - 8.0) / 6.0, 0.0, 1.0))
    else:
        rem = (n_frames - f) / 4.2
        crack_t = float(np.clip(rem, 0.08, 1.0))
        unown_t = float(np.clip((rem - 0.06) / 0.94, 0.0, 1.0))
        cosmos_t = float(np.clip((rem - 0.22) / 0.78, 0.0, 1.0))
    return crack_t, unown_t, cosmos_t


def _build_canyon_temporal_layers(
    rock_bg_rgb: np.ndarray,
    rgb_canyon: np.ndarray,
    solid_mask: np.ndarray,
    portal_mask: np.ndarray,
    void_mask: np.ndarray,
    is_floor: np.ndarray,
    n_frames: int = N_FRAMES,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit les 5 calques dynamiques de la métamorphose temporelle du Canyon Dimensionnel (`24` poses)."""
    h, w, _ = rock_bg_rgb.shape
    sx = w / float(W_CANON)
    sy = h / float(H_CANON)
    scale_u = 0.5 * (sx + sy)
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)

    rupture_zone = void_mask | portal_mask

    epicenters = [
        (0.500 * w, 0.140 * h, 1.00),  # E0 : Muraille Nord -> futur Portail Spatio-Rift
        (0.072 * w, 0.255 * h, 0.94),  # E1 : Gorge Rocheuse Nord-Ouest
        (0.076 * w, 0.720 * h, 0.94),  # E2 : Gorge Rocheuse Sud-Ouest
        (0.928 * w, 0.265 * h, 0.94),  # E3 : Gorge Rocheuse Nord-Est
        (0.924 * w, 0.730 * h, 0.94),  # E4 : Gorge Rocheuse Sud-Est
    ]

    # Déchirure étoilée déchiquetée façon impact de verre / *Spatio-Rift* (ZÉRO heptagone régulier mou !)
    rng = np.random.default_rng(201484)
    min_epi_d = np.full((h, w), 1e9, dtype=np.float32)
    nearest_epi = np.zeros((h, w), dtype=np.int32)
    for e_idx, (ex, ey, ew) in enumerate(epicenters):
        dx = (xx - ex) / max(0.5, ew)
        dy = (yy - ey) * 0.82 / max(0.5, ew)
        ang_e = np.arctan2(dy, dx)
        raw_r = np.hypot(dx, dy)
        # Doigts d'éclatement pointus comme du cristal fracassé !
        star_gain = (
            1.0
            + 0.34 * np.abs(np.cos(4.5 * ang_e + 0.9 * e_idx))
            + 0.20 * np.cos(9.0 * ang_e - 1.4 * e_idx)
        )
        eff_d = raw_r / np.maximum(0.45, star_gain)
        better = eff_d < min_epi_d
        min_epi_d = np.where(better, eff_d, min_epi_d)
        nearest_epi = np.where(better, e_idx, nearest_epi)

    # Tessons polygonaux euclidiens autour de chaque épicentre (arêtes 100 % droites)
    shard_centers = []
    for e_idx, (ex, ey, _) in enumerate(epicenters):
        for k in range(10):
            th = (2.0 * np.pi * k) / 10.0 + float(rng.uniform(-0.20, 0.20))
            rr = float(rng.uniform(20.0, 82.0)) * sx
            shard_centers.append((ex + rr * np.cos(th), ey + rr * 1.15 * np.sin(th), e_idx))

    best_sd = np.full((h, w), 1e9, dtype=np.float32)
    second_sd = np.full((h, w), 1e9, dtype=np.float32)
    for scx, scy, _ in shard_centers:
        d = np.hypot(xx - scx, yy - scy)
        better = d < best_sd
        second_sd = np.where(better, best_sd, np.minimum(second_sd, d))
        best_sd = np.where(better, d, best_sd)
    voronoi_crack = (second_sd - best_sd) * 0.5

    # Fissures brisées organiques en 4 segments courts à cassures vives + fourches (façon foudre/verre Chunsoft !)
    all_polylines = []
    ray_templates = [-2.72, -2.14, -1.58, -0.96, -0.34, 0.32, 0.98, 1.66, 2.34]
    for e_idx, (ex, ey, _) in enumerate(epicenters):
        max_len = (98.0 if e_idx == 0 else 118.0) * sx
        for r_i, ba in enumerate(ray_templates):
            a_cur = ba + 0.17 * e_idx
            pts = [(ex, ey)]
            cx_p, cy_p = ex, ey
            for seg_k in range(4):
                seg_l = float(rng.uniform(0.20, 0.31)) * max_len
                kink = (0.34 if (seg_k + r_i) % 2 == 0 else -0.34) * float(rng.uniform(0.65, 1.25))
                a_cur = a_cur + (0.0 if seg_k == 0 else kink)
                cx_p = cx_p + seg_l * np.cos(a_cur)
                cy_p = cy_p + seg_l * 1.06 * np.sin(a_cur)
                pts.append((cx_p, cy_p))
            # Fourche secondaire partant du 2e nœud
            fx0, fy0 = pts[2]
            fa = a_cur + (0.58 if r_i % 2 == 0 else -0.58)
            fl = float(rng.uniform(0.18, 0.30)) * max_len
            fork_pts = [(fx0, fy0), (fx0 + fl * np.cos(fa), fy0 + fl * 1.05 * np.sin(fa))]
            all_polylines.append((e_idx, r_i, pts, fork_pts))

    lum_c = (
        0.299 * rgb_canyon[:, :, 0].astype(np.float32)
        + 0.587 * rgb_canyon[:, :, 1].astype(np.float32)
        + 0.114 * rgb_canyon[:, :, 2].astype(np.float32)
    )
    thin_dark = (ndimage.uniform_filter(lum_c, size=max(3, int(round(5 * sx)))) - lum_c) >= 14.0
    floor_cracks = (
        solid_mask
        & thin_dark
        & (np.abs(xx - w * 0.50) <= 0.115 * w)
        & (yy >= 0.26 * h)
        & (yy < 0.94 * h)
    )
    canyon_rim = solid_mask & (~ndimage.binary_erosion(solid_mask, iterations=max(1, int(round(2 * sx)))))

    # Nuée MASSIVE de `132` Zarbis officiels Chunsoft PMDO (`72 BG` + `60 Top` — près de 5 alphabets complets A–Z, !, ? !)
    unown_atlas = _load_unown_atlas(scale_u)
    bg_zarbis = []
    top_zarbis = []
    counts_per_epi = [36, 24, 24, 24, 24]
    u_counter = 0
    for e_idx, n_u in enumerate(counts_per_epi):
        ex, ey, _ = epicenters[e_idx]
        for k in range(n_u):
            form_id = u_counter % 28
            is_top = (u_counter % 11) >= 6  # ~72 en BG + ~60 en Top = 132 Zarbis PMDO !
            t_birth = 0.02 + 0.38 * ((k * 7 + e_idx * 3) % n_u) / max(1, n_u)
            if e_idx == 0:
                ang_out = -0.5 * np.pi + np.pi * (0.12 + 1.76 * ((k + 0.5) / n_u))
                dist_max = float(rng.uniform(68.0, 238.0)) * sx
                if (not is_top) and abs(np.cos(ang_out)) < 0.38 and np.sin(ang_out) > 0.36:
                    ang_out = 0.40 if (k % 2 == 0) else (np.pi - 0.40)
            elif e_idx in (1, 2):
                ang_out = float(rng.uniform(-1.42, 1.42)) if is_top else float(rng.uniform(-1.65, 1.65))
                dist_max = float(rng.uniform(36.0, 178.0 if is_top else 98.0)) * sx
            else:
                ang_out = np.pi + (
                    float(rng.uniform(-1.42, 1.42)) if is_top else float(rng.uniform(-1.65, 1.65))
                )
                dist_max = float(rng.uniform(36.0, 178.0 if is_top else 98.0)) * sx

            swirl_amp = float(rng.uniform(10.0, 28.0)) * sx * (1.0 if k % 2 == 0 else -1.0)
            phase_anim = int(u_counter % 4)
            rec = (form_id, ex, ey, ang_out, dist_max, swirl_amp, t_birth, phase_anim, e_idx)
            if is_top:
                top_zarbis.append(rec)
            else:
                bg_zarbis.append(rec)
            u_counter += 1

    dist_pal = np.array(
        [
            [52, 14, 78, 255],
            [98, 26, 134, 255],
            [156, 48, 196, 255],
            [214, 102, 244, 255],
            [250, 214, 255, 255],
        ],
        dtype=np.uint8,
    )

    l2_distortion: List[Image.Image] = []
    l5_rock_shatter: List[Image.Image] = []
    l6_glass_cracks: List[Image.Image] = []
    l7_zarbis_bg: List[Image.Image] = []
    l8_zarbis_top: List[Image.Image] = []

    for f in range(n_frames):
        crack_t, unown_t, cosmos_t = _phase_curves(f, n_frames)
        ph1 = (2.0 * np.pi * f) / n_frames
        ph2 = (2.0 * np.pi * 2.0 * f) / n_frames

        open_radius = (56.0 * crack_t + 305.0 * cosmos_t) * sx
        rock_still_solid = rupture_zone & (min_epi_d >= open_radius)

        # --- Calque 02 : Distorsion tourbillonnante de la Dimension des Zarbis ---
        f2 = np.zeros((h, w, 4), dtype=np.uint8)
        if crack_t > 0.05 and cosmos_t < 0.88:
            open_hole = rupture_zone & (~rock_still_solid)
            if cosmos_t > 0.15:
                shrink_band = min_epi_d >= (open_radius * cosmos_t * 0.92)
                open_hole = open_hole & shrink_band
            if np.any(open_hole):
                ex_map = np.zeros_like(xx)
                ey_map = np.zeros_like(yy)
                for e_idx, (ex, ey, _) in enumerate(epicenters):
                    m_e = nearest_epi == e_idx
                    ex_map[m_e] = ex
                    ey_map[m_e] = ey
                ang_d = np.arctan2(yy - ey_map, xx - ex_map)
                rad_d = np.hypot(xx - ex_map, yy - ey_map) / max(1.0, sx)
                wave = np.sin(rad_d * 0.16 - ph2 + 3.0 * ang_d) + 0.55 * np.cos(rad_d * 0.09 + ph1 - 2.0 * ang_d)
                q_idx = np.clip(np.floor((wave + 1.55) / 3.10 * 5.0).astype(np.int32), 0, 4)
                f2[open_hole] = dist_pal[q_idx[open_hole]]
        l2_distortion.append(Image.fromarray(f2, mode="RGBA"))

        # --- Calque 05 : Background rocheux du canyon qui se fissure en tessons puis éclate complètement ---
        f5 = np.zeros((h, w, 4), dtype=np.uint8)
        if np.any(rock_still_solid):
            near_front = (
                rock_still_solid
                & (min_epi_d < open_radius + 46.0 * sx * crack_t)
                & (voronoi_crack <= max(0.95, 1.55 * sx * crack_t))
                & (f > 0)
            )
            solid_keep = rock_still_solid & (~near_front)
            f5[solid_keep, :3] = rock_bg_rgb[solid_keep]
            f5[solid_keep, 3] = 255

            if f > 0:
                lip = solid_keep & (~ndimage.binary_erosion(solid_keep, iterations=1)) & rupture_zone
                f5[lip] = (246, 198, 255, 255) if cosmos_t > 0.35 else (206, 98, 246, 255)
        l5_rock_shatter.append(Image.fromarray(f5, mode="RGBA"))

        # --- Calque 06 : Fissures cristallines brisées 1 px + résonance magenta des fractures du sol ---
        f6 = np.zeros((h, w, 4), dtype=np.uint8)
        lit_floor = floor_cracks & (np.sin(yy / max(4.0, 20.0 * sy) - ph1) > (0.38 - 0.35 * crack_t))
        f6[lit_floor] = (218, 122, 252, 255)

        if cosmos_t > 0.15:
            rim_hit = canyon_rim & (np.cos(yy / max(6.0, 28.0 * sy) - ph2) > 0.15)
            f6[rim_hit, :3] = np.clip(
                rgb_canyon[rim_hit].astype(np.int32) + np.array([42, 22, 60]), 0, 255
            ).astype(np.uint8)
            f6[rim_hit, 3] = 255

        crack_lines = np.zeros((h, w), dtype=bool)
        # Quand le cosmos est grand ouvert (`cosmos_t -> 1`), les fissures sur les falaises se stabilisent
        # finement sur les rebords rocheux au lieu de barrer les plateaux de longs traits rigides !
        cliff_reach_cap = 1.0 - 0.38 * cosmos_t
        for e_idx, r_i, main_pts, fork_pts in all_polylines:
            if f == 0:
                if r_i not in (1, 4, 7):
                    continue
                _draw_crisp_polyline(crack_lines, main_pts, 0.24)
            else:
                reach = float(np.clip((crack_t * 1.15 - 0.05 * (r_i % 3)) * cliff_reach_cap, 0.0, 1.0))
                _draw_crisp_polyline(crack_lines, main_pts, reach)
                if reach > 0.52:
                    _draw_crisp_polyline(crack_lines, fork_pts, (reach - 0.52) / 0.48)

        on_rock_surface = (f5[:, :, 3] == 255) | (solid_mask & (~is_floor))
        crack_lines &= on_rock_surface
        halo_c = ndimage.binary_dilation(crack_lines, iterations=1) & on_rock_surface & (~crack_lines)
        f6[halo_c] = (176, 70, 234, 255)
        f6[crack_lines] = (255, 248, 255, 255)
        l6_glass_cracks.append(Image.fromarray(f6, mode="RGBA"))

        # --- Calques 07 (`BG`) & 08 (`Top`) : Nuée massive des `132` Zarbis officiels PMDO (`A–Z, !, ?`) ---
        f7 = np.zeros((h, w, 4), dtype=np.uint8)
        f8 = np.zeros((h, w, 4), dtype=np.uint8)
        for target_canvas, swarm_list in ((f7, bg_zarbis), (f8, top_zarbis)):
            if unown_t <= 0.02:
                continue
            for form_id, ex, ey, ang_out, dist_max, swirl_amp, t_birth, phase_anim, _ in swarm_list:
                if unown_t < t_birth:
                    continue
                prog = float(np.clip((unown_t - t_birth) / max(0.20, 1.0 - t_birth), 0.0, 1.0))
                ease = 1.0 - (1.0 - prog) ** 2
                perp_a = ang_out + 0.5 * np.pi
                swirl_off = swirl_amp * np.sin(prog * 4.2 + ph1)
                ux = ex + np.cos(ang_out) * (dist_max * ease) + np.cos(perp_a) * swirl_off
                uy = ey + np.sin(ang_out) * (dist_max * ease) * 0.92 + np.sin(perp_a) * swirl_off
                vx = np.cos(ang_out) * dist_max + np.cos(perp_a) * swirl_amp * 0.6
                vy = np.sin(ang_out) * dist_max * 0.92 + np.sin(perp_a) * swirl_amp * 0.6
                dir_idx = _vec_to_pmdo_dir(float(vx), float(vy))
                anim_fr = (f + phase_anim) % 4
                spr = unown_atlas[form_id][dir_idx][anim_fr]
                _blit_sprite(
                    target_canvas,
                    spr,
                    int(round(ux)),
                    int(round(uy)),
                    aura=(prog < 0.24),
                )

        l7_zarbis_bg.append(Image.fromarray(f7, mode="RGBA"))
        l8_zarbis_top.append(Image.fromarray(f8, mode="RGBA"))

    return l2_distortion, l5_rock_shatter, l6_glass_cracks, l7_zarbis_bg, l8_zarbis_top


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    im_raw = Image.open(BRUT_PATH).convert("RGB")
    if im_raw.size != (w, h):
        im_raw = im_raw.resize((w, h), Image.Resampling.NEAREST)
    rgb_raw = np.asarray(im_raw, dtype=np.uint8).copy()

    r = rgb_raw[:, :, 0].astype(np.int32)
    g = rgb_raw[:, :, 1].astype(np.int32)
    b = rgb_raw[:, :, 2].astype(np.int32)
    mag_mask = (r >= 215) & (g <= 50) & (b >= 215)
    rgb = clean_brut_magenta_fringe(rgb_raw, mag_mask)
    solid_mask = ~mag_mask

    rgb_adj = rgb.astype(np.float32)
    rgb_adj[solid_mask, 0] = np.clip(rgb_adj[solid_mask, 0] * 0.62 + 8.0, 10, 220)
    rgb_adj[solid_mask, 1] = np.clip(rgb_adj[solid_mask, 1] * 0.64 + 10.0, 12, 215)
    rgb_adj[solid_mask, 2] = np.clip(rgb_adj[solid_mask, 2] * 0.68 + 14.0, 18, 235)
    rgb = np.rint(rgb_adj).astype(np.uint8)

    yy, xx = np.mgrid[0:h, 0:w]
    portal_mask = mag_mask & (np.abs(xx - w // 2) <= int(0.18 * w)) & (yy < int(0.32 * h))
    void_mask = mag_mask & (~portal_mask)

    rock_bg_rgb = _reconstruct_rocky_canyon_background(rgb, solid_mask, portal_mask, void_mask)
    if w == W_CANON and h == H_CANON:
        BRUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        Image.fromarray(rock_bg_rgb, mode="RGB").save(SEALED_CANYON_PNG)

    cosmos_24, portal_24, _, shard_24 = build_spatial_rift_layers(
        h=h,
        w=w,
        void_mask=void_mask,
        portal_mask=portal_mask,
        portal_center_xy=(w * 0.50, h * 0.12),
        n_frames=N_FRAMES,
    )

    rr, gg, bb = rgb[:, :, 0].astype(np.int32), rgb[:, :, 1].astype(np.int32), rgb[:, :, 2].astype(np.int32)
    lum = 0.299 * rr + 0.587 * gg + 0.114 * bb
    is_floor = solid_mask & (np.abs(xx - w // 2) <= int(0.185 * w)) & (lum >= 88.0)
    is_boulders_dark = solid_mask & (np.abs(xx - w // 2) <= int(0.22 * w)) & (~is_floor)
    is_cliffs_and_boulders = solid_mask & (~is_floor)
    is_floor |= solid_mask & (~(is_floor | is_cliffs_and_boulders))

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[mask, :3] = rgb[mask]
        out[mask, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    l2_dist, l5_rock_shatter, l6_cracks, l7_zarbis_bg, l8_zarbis_top = _build_canyon_temporal_layers(
        rock_bg_rgb=rock_bg_rgb,
        rgb_canyon=rgb,
        solid_mask=solid_mask,
        portal_mask=portal_mask,
        void_mask=void_mask,
        is_floor=is_floor,
        n_frames=N_FRAMES,
    )

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            sub_f = is_floor[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            sub_m = mag_mask[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            if float(sub_f.mean()) >= 0.70 and float(sub_m.mean()) == 0.0:
                walk_grid[ty, tx] = True
    cx_t = gw // 2
    portal_y_t = max(2, int(round(0.24 * gh)))
    for ty in range(portal_y_t, gh):
        walk_grid[ty, max(0, cx_t - 2) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False

    layers = [
        LayerEntry("00_cosmos_dimensionnel_distordu_etoile", "Cosmos Dimensionnel Distordu & Étoiles", "BG", _to_imgs(cosmos_24), frame_length=5),
        LayerEntry("01_portail_spatio_rift_nord", "Portail Spatio-Rift Blanc-Perle au Nord", "BG", _to_imgs(portal_24), frame_length=5),
        LayerEntry("02_distorsion_dimension_zarbis", "Distorsion de la Réalité (Dimension des Zarbis)", "BG", l2_dist, frame_length=5),
        LayerEntry("03_sol_canyon_ardoise_sud_nord", "Sol Fissuré du Canyon Sud-Nord", "BG", [mk_static(is_floor)], frame_length=5),
        LayerEntry("04_parois_canyon_et_rocs_statiques", "Parois Rocheuses Est/Ouest & Rocs Statiques", "BG", [mk_static(is_cliffs_and_boulders & (~is_boulders_dark))], frame_length=5),
        LayerEntry("05_rochers_apesanteur_statiques", "Rochers Noirs en Apesanteur Statiques", "BG", [mk_static(is_boulders_dark)], frame_length=5),
        LayerEntry("06_fond_rocheux_canyon_fissure_rupture", "Fond Rocheux du Canyon & Rupture Spatio-Rift", "BG", l5_rock_shatter, frame_length=5),
        LayerEntry("07_lezardes_verre_spatio_rift_canyon", "Fissures de Réalité & Veines Énergétiques", "BG", l6_cracks, frame_length=5),
        LayerEntry("08_nuee_zarbis_pmdo_sortie_failles_bg", "Nuée de Zarbis PMDO (A–Z, !, ?) Sortant des Failles", "BG", l7_zarbis_bg, frame_length=5),
        LayerEntry("09_nuee_zarbis_pmdo_et_eclats_top", "Nuée Aérienne de Zarbis PMDO & Éclats Top", "Top", [
            Image.fromarray(
                np.where(
                    np.asarray(l8_zarbis_top[i], dtype=np.uint8)[:, :, 3:4] == 255,
                    np.asarray(l8_zarbis_top[i], dtype=np.uint8),
                    shard_24[i],
                ),
                mode="RGBA",
            )
            for i in range(N_FRAMES)
        ], frame_length=5),
    ]
    return layers, walk_grid


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    h = max(64, int(round(H_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    VIRTUAL_ZIP.parent.mkdir(parents=True, exist_ok=True)
    layers, walk_grid = build_layers_for_size(w, h)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=CANON_REF,
        max_fidelity_distance=34.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="faille_spatiale_fse1",
        asset_name_override="faille_spatiale_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
