#!/usr/bin/env python3
"""Moteur 3D de rotation cylindrique authentique sur soi-même (`24` poses × `5` ticks = `120` ticks)
extrait directement de la texture pixel-art canonique + canal alpha de `ref_entree_tornades_user.png` (`D13P01`).

Points clés :
1. Extraction stricte de la **vraie colonne cyclonique S-courbe** de `image-1.png` (en excluant
   totalement la voûte nuageuse blanche centrale `x > x_max_funnel(y)`, les nuages d'angle bas et
   en conservant **`alpha = 0` transparent** dans toutes les échancrures de ciel bleu cobalt `[0, 64, 224]`
   entre les mèches et crochets de vent Chunsoft !).
2. Construction d'une nappe cylindrique RGBA `360°` `[h, n_phi, 4]` sans couture combinant deux
   hémisphères de vraies bourrasques pixel-art Chunsoft décalées hélicoïdalement :
   - **aucune bordure rectangulaire verticale** ni voile blanc parasite à aucune des `24` poses (`pose 0`,
     `pose 6`, `pose 12`, `pose 18` ont toutes la même silhouette organique découpée en crochets de vent !) ;
   - projection cylindrique vraie `θ = arcsin(u)` autour de l'axe S-courbe de chaque tornade ;
   - croissants d'air en orbite `360°` passant derrière (`Layer 04`, `cos α < 0`) puis devant (`Layer 09`, `cos α >= 0`).
"""

from __future__ import annotations

from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
USER_TORNADO_REF = HERE / "tour_celeste_entree_v1" / "references" / "ref_entree_tornades_user.png"

# Palette pixel-art canonique exacte des tornades de `image-1.png` (`D13P01`)
TORNADO_PALETTE = np.array(
    [
        [6, 98, 218],     # 0 : ombre céruléenne profonde
        [0, 134, 212],    # 1 : creux cyclonique bleu-azur profond
        [16, 178, 244],   # 2 : sillon de vent cyan vif
        [76, 218, 250],   # 3 : courant turquoise
        [124, 236, 252],  # 4 : souffle turquoise clair
        [176, 246, 254],  # 5 : écume d'air glacé
        [214, 252, 255],  # 6 : nuée blanc-cyan
        [255, 255, 255],  # 7 : crête d'écume blanche pure
    ],
    dtype=np.uint8,
)


def _quantize_tornado_rgb(rgb_float: np.ndarray) -> np.ndarray:
    pal_f = TORNADO_PALETTE.astype(np.float32)
    flat = rgb_float.reshape(-1, 3)
    d2 = ((flat[:, None, :] - pal_f[None, :, :]) ** 2).sum(axis=2)
    idx = np.argmin(d2, axis=1)
    return TORNADO_PALETTE[idx].reshape(rgb_float.shape).astype(np.uint8)


def _extract_reference_tornado_sheet(
    ref_h: int = 576, n_phi: int = 512
) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Extrait la nappe cylindrique RGBA `[ref_h, n_phi, 4]` (`RGB` + `alpha` des mèches de vent !)
    et le profil S-courbe exact `(xc_norm(y), r_norm(y))` de la tornade gauche de `image-1.png`.
    """
    ref_im = Image.open(USER_TORNADO_REF).convert("RGB").resize((768, ref_h), Image.Resampling.BILINEAR)
    arr = np.asarray(ref_im, dtype=np.float32)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]

    yy = np.arange(ref_h, dtype=np.float32)
    yn = yy / float(max(1, ref_h - 1))

    # Profil S-courbe analytique exact de la VRAIE colonne de tornade gauche dans `image-1.png`
    # (exclut à 100 % la voûte nuageuse blanche centrale `x > 175` en haut et l'esplanade centrale !) :
    #   y=0.00 : x ∈ [  2 .. 176]
    #   y=0.25 : x ∈ [  4 .. 166]
    #   y=0.52 : x ∈ [ 14 .. 224]
    #   y=0.76 : x ∈ [ 12 .. 258]
    #   y=0.92 : x ∈ [ 36 .. 248]
    x_min_s = 768.0 * (
        0.004
        + 0.014 * np.power(np.clip(yn / 0.65, 0.0, 1.0), 1.4)
        + 0.036 * np.power(np.clip((yn - 0.72) / 0.28, 0.0, 1.0), 1.8)
    )
    x_max_s = 768.0 * (
        0.228
        - 0.018 * np.sin(np.pi * np.clip(yn / 0.36, 0.0, 1.0))
        + 0.098 * np.power(np.clip((yn - 0.24) / 0.56, 0.0, 1.0), 1.25)
        - 0.020 * np.power(np.clip((yn - 0.80) / 0.20, 0.0, 1.0), 1.5)
    )

    xc_px = 0.5 * (x_min_s + x_max_s)
    rad_px = np.maximum(24.0, 0.5 * (x_max_s - x_min_s))

    # Masque alpha authentique dans `image-1.png` :
    # - un vrai pixel de tornade est soit turquoise/cyan/céruléen (`b - r >= 26` hors ciel cobalt `[0,64,224]`),
    #   soit une fine crête d'écume blanche adjacente (`<= 6 px`) à une veine turquoise de tornade !
    # -> Exclut automatiquement et sans AUCUNE ligne droite les gros massifs blancs d'orage et de cumulus !
    from scipy import ndimage as _ndi

    is_deep_sky = (r < 30.0) & (g < 96.0) & (b > 188.0)
    is_turquoise_core = (~is_deep_sky) & ((b - r) >= 28.0) & (b >= 175.0)
    near_turquoise = _ndi.binary_dilation(is_turquoise_core, iterations=max(4, int(round(6 * ref_h / 576.0))))
    alpha_mask = (~is_deep_sky) & near_turquoise
    alpha_f = alpha_mask.astype(np.float32) * 255.0

    # Dépliage cylindrique inverse de la face avant réelle `ψ ∈ [-π/2, +π/2]`
    n_half = n_phi // 2
    psi = np.linspace(-0.5 * np.pi, 0.5 * np.pi, n_half, endpoint=False, dtype=np.float32)[None, :]
    sample_x = np.clip(xc_px[:, None] + rad_px[:, None] * np.sin(psi), 0.0, 270.0)
    x0 = np.floor(sample_x).astype(np.int32)
    x1 = np.minimum(x0 + 1, 270)
    fx = (sample_x - x0)[:, :, None]
    row_idx = np.arange(ref_h, dtype=np.int32)[:, None]

    front_rgb = (1.0 - fx) * arr[row_idx, x0] + fx * arr[row_idx, x1]
    front_a = (1.0 - fx[:, :, 0]) * alpha_f[row_idx, x0] + fx[:, :, 0] * alpha_f[row_idx, x1]

    # Hémisphère arrière construit à partir des MÊMES bourrasques Chunsoft décalées hélicoïdalement
    # (avec `mode='nearest'` en haut/bas pour ne jamais enrouler le bas de la tornade tout en haut !)
    shift_rows = max(14, int(round(0.12 * ref_h)))
    src_rows = np.clip(np.arange(ref_h, dtype=np.int32) + shift_rows, 0, ref_h - 1)
    back_rgb = front_rgb[src_rows, ::-1, :].copy()
    back_a = front_a[src_rows, ::-1].copy()

    full_rgb = np.concatenate([front_rgb, back_rgb], axis=1)
    full_a = np.concatenate([front_a, back_a], axis=1)

    # Raccord doux sans couture aux deux jonctions `seam ∈ {0, n_half}`
    blend_w = 18
    for seam in (0, n_half):
        for k in range(-blend_w, blend_w + 1):
            idx = (seam + k) % n_phi
            idx_l = (seam - blend_w - 1) % n_phi
            idx_r = (seam + blend_w + 1) % n_phi
            tb = (k + blend_w) / float(2 * blend_w + 1)
            sm = tb * tb * (3.0 - 2.0 * tb)
            w_edge = 1.0 - abs(k) / float(blend_w + 1)
            full_rgb[:, idx, :] = (1.0 - 0.65 * w_edge) * full_rgb[:, idx, :] + (0.65 * w_edge) * (
                (1.0 - sm) * full_rgb[:, idx_l, :] + sm * full_rgb[:, idx_r, :]
            )
            full_a[:, idx] = (1.0 - 0.65 * w_edge) * full_a[:, idx] + (0.65 * w_edge) * (
                (1.0 - sm) * full_a[:, idx_l] + sm * full_a[:, idx_r]
            )

    xc_norm = xc_px / 768.0
    r_norm = rad_px / 768.0
    return full_rgb, full_a, xc_norm, r_norm


def _draw_crescent_arc(
    canvas: np.ndarray,
    cx: float,
    cy: float,
    rx: float,
    ry: float,
    ang0: float,
    ang1: float,
    thickness: float,
    col_inner: np.ndarray,
    col_outer: np.ndarray,
) -> None:
    """Trace un croissant de bourrasque effilé aux deux pointes en pixel-art net (`alpha ∈ {0, 255}`)."""
    h, w, _ = canvas.shape
    steps = max(24, int(round(max(rx, ry) * 2.0)))
    angs = np.linspace(ang0, ang1, steps)
    for idx, a in enumerate(angs):
        u_taper = np.sin(np.pi * (idx / float(max(1, steps - 1))))
        th = max(0.75, thickness * u_taper)
        px = cx + rx * np.cos(a)
        py = cy + ry * np.sin(a)
        r_int = int(np.ceil(th))
        ipx, ipy = int(round(px)), int(round(py))
        if ipx + r_int < 0 or ipx - r_int >= w or ipy + r_int < 0 or ipy - r_int >= h:
            continue
        for oy in range(-r_int, r_int + 1):
            for ox in range(-r_int, r_int + 1):
                if ox * ox + oy * oy <= th * th:
                    yy0, xx0 = ipy + oy, ipx + ox
                    if 0 <= yy0 < h and 0 <= xx0 < w:
                        col = col_inner if (ox * ox + oy * oy <= (0.45 * th) ** 2 or u_taper > 0.72) else col_outer
                        canvas[yy0, xx0, :3] = col
                        canvas[yy0, xx0, 3] = 255


def build_twin_spinning_tornadoes(
    w: int,
    h: int,
    n_frames: int = 24,
    mode: str = "entrance",
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Génère les 3 séquences `24` poses (`back`, `body`, `front`) des deux tornades tournant sur elles-mêmes."""
    n_phi = 512
    sheet_rgb, sheet_a, xc_ref_norm, r_ref_norm = _extract_reference_tornado_sheet(ref_h=h, n_phi=n_phi)

    yy = np.arange(h, dtype=np.float32)[:, None]
    xx = np.arange(w, dtype=np.float32)[None, :]
    yn = yy / float(max(1, h - 1))

    if mode == "entrance":
        xc_left = (xc_ref_norm * float(w))[:, None]
        rad_base = (r_ref_norm * float(w))[:, None]
        y_bot_fade = 0.94
        wobble_amp = max(1.5, 4.0 * (w / 768.0))
        n_blades = 8
    else:
        xc_left = w * (0.102 + 0.015 * np.sin(2.0 * np.pi * yn))
        rad_base = w * (0.052 + 0.011 * np.cos(np.pi * yn) + 0.012 * np.exp(-(((yn - 0.50) / 0.24) ** 2)))
        y_bot_fade = 1.01
        wobble_amp = max(1.2, 2.8 * (w / 768.0))
        n_blades = 6

    xc_right = (w - 1.0) - xc_left
    k_wave = 2.0 * np.pi * yn * 3.5

    frames_back: List[Image.Image] = []
    frames_body: List[Image.Image] = []
    frames_front: List[Image.Image] = []

    for t in range(n_frames):
        rot_angle = 2.0 * np.pi * (t / float(n_frames))

        body = np.zeros((h, w, 4), dtype=np.uint8)
        back = np.zeros((h, w, 4), dtype=np.uint8)
        front = np.zeros((h, w, 4), dtype=np.uint8)

        for is_right, (xc_col, spin) in enumerate(((xc_left, 1.0), (xc_right, -1.0))):
            bulge_l = wobble_amp * np.sin(k_wave - rot_angle)
            bulge_r = wobble_amp * np.sin(k_wave - rot_angle + np.pi)
            x_edge_l = xc_col - rad_base - bulge_l
            x_edge_r = xc_col + rad_base + bulge_r
            x_mid = 0.5 * (x_edge_l + x_edge_r)
            r_half = np.maximum(4.0, 0.5 * (x_edge_r - x_edge_l))

            u = (xx - x_mid) / r_half
            inside_geom = (np.abs(u) <= 1.0) & (yn <= y_bot_fade)
            if not np.any(inside_geom):
                continue

            u_clip = np.clip(u, -1.0, 1.0)
            u_oriented = -u_clip if is_right else u_clip
            theta = np.arcsin(u_oriented)

            phi = np.mod(theta + 0.5 * np.pi - rot_angle, 2.0 * np.pi)
            phi_f = (phi / (2.0 * np.pi)) * float(n_phi)
            p0 = np.floor(phi_f).astype(np.int32) % n_phi
            p1 = (p0 + 1) % n_phi
            fp = (phi_f - np.floor(phi_f))[:, :, None]

            row_i = yy.astype(np.int32)
            sampled_rgb = (1.0 - fp) * sheet_rgb[row_i, p0] + fp * sheet_rgb[row_i, p1]
            sampled_a = (1.0 - fp[:, :, 0]) * sheet_a[row_i, p0] + fp[:, :, 0] * sheet_a[row_i, p1]

            # Effilage dentelé en mèches de vent aux bords extrêmes du cylindre (`|u| > 0.82`) : zéro bord coupé !
            hook_feather = 0.5 + 0.5 * np.sin(9.0 * k_wave + 5.0 * theta - 2.0 * rot_angle)
            edge_fade = 1.0 - 0.72 * np.clip((np.abs(u_clip) - 0.80) / 0.20, 0.0, 1.0) * hook_feather
            vis = inside_geom & ((sampled_a * edge_fade) >= 126.0)

            rim_shade = 8.0 * (spin * u_clip) - 12.0 * (u_clip ** 4)
            shaded = np.clip(sampled_rgb + rim_shade[:, :, None], 0.0, 255.0)
            q_body = _quantize_tornado_rgb(shaded)

            body[vis, :3] = q_body[vis]
            body[vis, 3] = 255

            # Croissants d'air cycloniques orbitant à `360°` autour de la tornade !
            for b_idx in range(n_blades):
                v_frac = ((b_idx + (t / float(n_frames))) / float(n_blades))
                by = float(h * (0.08 + 0.76 * (1.0 - v_frac)))
                yi = int(np.clip(round(by), 0, h - 1))
                cx0 = float(xc_col[yi, 0])
                rr0 = float(rad_base[yi, 0])

                alpha = (b_idx * 2.39996) + spin * rot_angle
                sin_a = float(np.sin(alpha))
                cos_a = float(np.cos(alpha))

                blade_cx = cx0 + 0.22 * rr0 * sin_a
                blade_rx = 1.12 * rr0
                blade_ry = max(5.0, 0.25 * rr0)
                thick = max(1.3, 2.8 * (w / 768.0) * (0.65 + 0.35 * abs(cos_a)))

                if cos_a >= 0.0:
                    span = 0.34 * np.pi
                    c0 = 0.5 * np.pi - span * (0.35 + 0.65 * (0.5 + 0.5 * sin_a))
                    c1 = 0.5 * np.pi + span * (0.35 + 0.65 * (0.5 - 0.5 * sin_a))
                    _draw_crescent_arc(
                        front,
                        blade_cx,
                        by,
                        blade_rx,
                        blade_ry,
                        c0,
                        c1,
                        thick,
                        TORNADO_PALETTE[7],
                        TORNADO_PALETTE[5],
                    )
                else:
                    _draw_crescent_arc(
                        back,
                        blade_cx,
                        by - 0.10 * rr0,
                        1.16 * rr0,
                        blade_ry,
                        -0.86 * np.pi,
                        -0.14 * np.pi,
                        thick * 0.85,
                        TORNADO_PALETTE[4],
                        TORNADO_PALETTE[2],
                    )

        frames_back.append(Image.fromarray(back, mode="RGBA"))
        frames_body.append(Image.fromarray(body, mode="RGBA"))
        frames_front.append(Image.fromarray(front, mode="RGBA"))

    return frames_back, frames_body, frames_front
