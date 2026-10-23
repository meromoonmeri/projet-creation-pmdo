"""Moteur 3D par plumes de vent Chunsoft sur cylindre hélicoïdal 360° (écrit 100 % de zéro)
pour la Tour Céleste — Entrée (`TCE1`, référence `ref_entree_tornades_user.png` / `D13P01`).

Principe clé éliminant à la fois 100 % des glitches de découpe ET tout aspect « rayures régulières » :
  1. Chaque tornade (Gauche et Droite) est un vrai entonnoir 3D courbe en S d'axe `x_c(y)` et rayon `R_0(y)`.
  2. Au lieu d'un dépliage photo (qui crée des coupures verticales à mi-tour) ou de simples sinusoïdes
     uniformes, la surface 360° complète du cylindre `[0, 2*pi)` est tapissée de **68 bourrasques de vent
     Chunsoft individuelles effilées en croissant** (écailles de vent d'échelles variées : larges poches
     céruléennes, nappes turquoise, crêtes d'écume blanche et grands crochets en C relevés vers le haut).
  3. Vue sous l'angle 3/4 canonique PMD, toute bourrasque située à la longitude `phi` plonge vers le bas
     sur le ventre avant puis remonte vivement en crochet vers le bord intérieur :
         y_proj(y, phi) = y + R_0(y) * (0.66 * cos(phi - 0.34))
     reproduisant fidèlement la courbure en berceau concave et les crochets montants de `D13P01` !
  4. À chaque pose `t = 0 .. 23`, tout le manchon 360° tourne d'un bloc sur son axe (`Omega = 2*pi * t / 24`) :
       - **zéro couture** sur 360° (toutes les distances angulaires sont calculées modulo `2*pi`),
       - **boucle 24 poses 100 % exacte** au pixel près entre `pose 23` et `pose 0`,
       - **anti-phase franche** entre `pose 0` et `pose 12` (`Omega = pi`, autres bourrasques visibles),
       - **silhouette vivante** : chaque bourrasque franchissant le bord gauche (`-pi/2`) ou droit (`+pi/2`)
         forme naturellement sa propre dent d'écume et ses crochets en C caractéristiques !
"""
from __future__ import annotations

from typing import List, Tuple

import numpy as np
from PIL import Image

# Palette pixel-art canonique exacte extraite des tornades de `ref_entree_tornades_user.png` (D13P01)
D13_TORNADO_PALETTE = np.array(
    [
        [6, 98, 218],      # 0 : ombre céruléenne profonde
        [0, 134, 212],     # 1 : creux cyclonique bleu-azur profond
        [16, 178, 244],    # 2 : sillon de vent cyan vif
        [52, 204, 248],    # 3 : courant azur-turquoise
        [88, 222, 252],    # 4 : souffle turquoise lumineux
        [136, 238, 254],   # 5 : nappe glacée cyan clair
        [184, 248, 255],   # 6 : écume d'air blanc-bleuté
        [224, 253, 255],   # 7 : crête d'écume nacrée
        [255, 255, 255],   # 8 : crête blanche pure Chunsoft
    ],
    dtype=np.uint8,
)


def _left_funnel_axis_and_radius(h: int, w: int) -> Tuple[np.ndarray, np.ndarray]:
    """Profil S-courbe canonique (x_c(y), R_0(y)) de la colonne cyclonique gauche sur w × h."""
    yn = np.linspace(0.0, 1.0, h, dtype=np.float32)
    xc = w * (
        0.112
        - 0.015 * np.sin(np.pi * np.clip(yn / 0.42, 0.0, 1.0))
        + 0.088 * np.power(np.clip((yn - 0.30) / 0.70, 0.0, 1.0), 1.40)
    )
    r0 = w * (
        0.124
        - 0.016 * np.sin(np.pi * np.clip(yn / 0.50, 0.0, 1.0))
        + 0.032 * np.power(np.clip((yn - 0.36) / 0.64, 0.0, 1.0), 1.30)
    )
    return xc.astype(np.float32), r0.astype(np.float32)


def _generate_cylindrical_gust_catalog(seed: int = 1301) -> np.ndarray:
    """Génère un catalogue déterministe de 96 bourrasques Chunsoft réparties sans couture sur [0, 2*pi)
    et sur toute la hauteur [-0.14 .. 1.14] :
      colonnes : [phi_center, yn_center, half_arc, thick_norm, tilt, tone_boost, limb_jut]
    """
    rng = np.random.default_rng(seed)
    gusts = []
    # 24 étages verticaux x 4 secteurs azimutaux décalés par le nombre d'or = 96 mèches variées !
    n_tiers = 24
    for tier in range(n_tiers):
        yn_base = -0.10 + 1.22 * (tier / float(n_tiers - 1))
        az_offset = (tier * 1.6180339) * 2.0 * np.pi
        for sector in range(4):
            phi_c = (az_offset + sector * (0.5 * np.pi) + rng.uniform(-0.24, 0.24)) % (2.0 * np.pi)
            yn_c = yn_base + rng.uniform(-0.020, 0.020)
            half_arc = rng.uniform(0.62, 1.24)
            thick_n = rng.uniform(0.026, 0.056)
            tilt = rng.uniform(-0.032, 0.022)
            # Contraste Chunsoft franc : vraies crêtes blanches nacrées + sillons bleu céruléen profonds !
            tone_b = rng.uniform(0.28, 0.60)
            limb_jut = rng.uniform(0.06, 0.18)
            gusts.append([phi_c, yn_c, half_arc, thick_n, tilt, tone_b, limb_jut])
    return np.array(gusts, dtype=np.float32)


def _wrap_pi(delta: np.ndarray) -> np.ndarray:
    """Ramène tout écart angulaire dans [-pi, +pi] sans aucune discontinuité à 0 / 2*pi."""
    return (delta + np.pi) % (2.0 * np.pi) - np.pi


def _draw_3d_hooked_crescents(
    front_canvas: np.ndarray,
    back_canvas: np.ndarray,
    xc: np.ndarray,
    r0: np.ndarray,
    omega: float,
    mirror_right: bool,
    hooks: List[Tuple[float, float, float, float, float]],
) -> None:
    """Dessine uniquement de vraies mèches latérales courtes en virgule / crochet d'écume Chunsoft
    sur le flanc intérieur de la tornade (strictement à mi-hauteur 0.14*h .. 0.74*h, JAMAIS de longs
    fils blancs en travers de toute la colonne ni sur les nuages blancs du bas !).
    """
    h, w, _ = front_canvas.shape
    sy = h / 576.0
    n_pts = 56
    # Arc court concentré sur le rebord intérieur (fouet d'écume se détachant de la colonne vers le haut)
    t_arc = np.linspace(0.0, 1.0, n_pts, dtype=np.float32)

    for yn_mid, phi0, _, r_mul, rise_px in hooks:
        # Phase orbitale sur le flanc intérieur [0.35 .. 2.35 rad] : n'apparaît que quand la mèche passe sur le bord !
        vis_phase = _wrap_pi(np.array((phi0 + omega) - 1.15))
        vis = float(np.cos(np.clip(abs(float(vis_phase)) / 1.05, 0.0, 1.0) * 0.5 * np.pi))
        if vis <= 0.08:
            continue

        alpha = (0.55 + 0.92 * t_arc) + 0.35 * float(vis_phase)
        hook_kick = rise_px * sy * np.power(t_arc, 1.85)
        y_base = yn_mid * (h - 1)
        y_idx0 = int(np.clip(round(y_base), 0, h - 1))
        rc_mid = float(r0[y_idx0]) * (0.92 + 0.30 * vis * t_arc)

        py_f = y_base + 0.30 * rc_mid * (1.0 - t_arc) - hook_kick
        y_idx = np.clip(np.rint(py_f).astype(np.int32), 0, h - 1)
        px_f = xc[y_idx] + r0[y_idx] * (0.86 + 0.34 * vis * np.sin(0.5 * np.pi * t_arc))
        if mirror_right:
            px_f = (w - 1.0) - px_f

        # Mèche épaisse à sa racine dans la tornade, effilée en pointe fine en haut du crochet C !
        env = np.maximum(0.0, (1.0 - t_arc) ** 0.62 * np.minimum(1.0, t_arc * 5.0)) * vis
        half_w = (7.2 * sy) * env

        for i in range(n_pts):
            hw = float(half_w[i])
            if hw < 0.65:
                continue
            cx_i = int(round(float(px_f[i])))
            cy_i = int(round(float(py_f[i])))
            if cy_i < int(0.08 * h) or cy_i > int(0.75 * h):
                continue
            ri = max(1, int(np.ceil(hw)))
            for dy in range(-ri, ri + 1):
                for dx in range(-ri, ri + 1):
                    d2 = dx * dx + dy * dy
                    if d2 > (hw + 0.25) ** 2:
                        continue
                    yy_p, xx_p = cy_i + dy, cx_i + dx
                    if 0 <= yy_p < h and 0 <= xx_p < w:
                        if d2 <= (0.48 * hw) ** 2 or dx <= int(round(-0.2 * hw)):
                            col = (255, 255, 255, 255)
                        elif d2 <= (0.80 * hw) ** 2:
                            col = (184, 248, 255, 255)
                        else:
                            col = (52, 204, 248, 255)
                        if front_canvas[yy_p, xx_p, 3] == 0 or col[0] > front_canvas[yy_p, xx_p, 0]:
                            front_canvas[yy_p, xx_p] = col


def render_single_tornado_pose(
    w: int,
    h: int,
    pose_idx: int,
    gusts: np.ndarray,
    n_frames: int = 24,
    mirror_right: bool = False,
) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Rend une pose RGBA 3D complète (h, w, 4) sans couture ni découpe."""
    xc, r0 = _left_funnel_axis_and_radius(h, w)
    omega = (2.0 * np.pi * pose_idx) / float(n_frames)

    yy_1d = np.arange(h, dtype=np.float32)
    yn_1d = yy_1d / max(float(h - 1), 1.0)

    # 1) Silhouette organique vivante sur les flancs gauche (phi = -pi/2) et droit (phi = +pi/2)
    #    calculée directement à partir des bourrasques franchissant chaque horizon !
    jut_left = np.zeros(h, dtype=np.float32)
    jut_right = np.zeros(h, dtype=np.float32)
    phi_g = (gusts[:, 0] + omega) % (2.0 * np.pi)

    for g_idx in range(len(gusts)):
        ph_c = float(phi_g[g_idx])
        yn_c = float(gusts[g_idx, 1])
        h_arc = float(gusts[g_idx, 2])
        th_n = float(gusts[g_idx, 3])
        jut_a = float(gusts[g_idx, 6])

        for limb_phi, target_jut, mul_side in ((-0.5 * np.pi, jut_left, 0.85), (0.5 * np.pi, jut_right, 1.25)):
            dphi = abs(float(_wrap_pi(np.array(limb_phi - ph_c))))
            if dphi < h_arc:
                ang_w = np.cos(0.5 * np.pi * (dphi / h_arc)) ** 1.3
                yn_limb = yn_c + (r0 / max(float(h), 1.0)) * 0.66 * float(np.cos(limb_phi - 0.34))
                dy = (yn_1d - yn_limb) / th_n
                prof = np.exp(-0.5 * dy * dy) * (1.0 - 0.35 * np.clip(dy, -1.0, 1.0))
                contrib = mul_side * jut_a * ang_w * prof
                np.maximum(target_jut, contrib, out=target_jut)

    x_left_edge = xc - r0 * (0.94 + jut_left)
    x_right_edge = xc + r0 * (0.95 + jut_right)
    half_span = np.maximum(12.0, 0.5 * (x_right_edge - x_left_edge))
    x_mid = 0.5 * (x_left_edge + x_right_edge)

    max_col = min(w, int(np.ceil(float(x_right_edge.max()))) + 4)
    xx_sub = np.arange(max_col, dtype=np.float32)[None, :]
    yn_sub = yn_1d[:, None]
    r0_norm_h = (r0 / max(float(h), 1.0))[:, None]

    u = (xx_sub - x_mid[:, None]) / half_span[:, None]
    inside = (np.abs(u) <= 1.0) & (yy_1d[:, None] <= float(h - 8))
    u_clip = np.clip(u, -1.0, 1.0)
    phi_px = np.arcsin(u_clip)  # [-pi/2, +pi/2]

    # Décalage perspectif 3D Chunsoft : le ventre plonge vers le bas autour de phi = +0.34 rad
    # et fouette vivement vers le haut en approchant du bord intérieur phi -> +pi/2 !
    belly_drop = 0.66 * r0_norm_h * np.cos(phi_px - 0.34)
    yn_surface = yn_sub - belly_drop

    # Accumulation vectorisée des 76 bourrasques Chunsoft en écailles superposées (shingle painter's order)
    # Niveau de base = turquoise-azur riche modulé par l'éclairage 3D cylindrique de D13P01
    field = (
        0.34
        + 0.16 * u_clip
        - 0.10 * yn_sub
        + 0.05 * np.cos(phi_px - 0.45)
    ).astype(np.float32)

    for g_idx in range(len(gusts)):
        ph_c = float(phi_g[g_idx])
        yn_c = float(gusts[g_idx, 1])
        h_arc = float(gusts[g_idx, 2])
        th_n = float(gusts[g_idx, 3])
        tilt = float(gusts[g_idx, 4])
        tone_b = float(gusts[g_idx, 5])

        # Seulement les bourrasques visibles sur la face avant [-pi/2 .. +pi/2] ont un poids non nul !
        if abs(float(_wrap_pi(np.array(0.0 - ph_c)))) > (0.5 * np.pi + h_arc):
            continue

        dphi = _wrap_pi(phi_px - ph_c)
        in_arc = np.abs(dphi) < h_arc
        if not np.any(in_arc & inside):
            continue

        # Enveloppe effilée aux deux bouts du croissant
        cos_w = np.maximum(0.0, np.cos(0.5 * np.pi * np.clip(np.abs(dphi) / h_arc, 0.0, 1.0)))
        w_phi = np.where(in_arc, np.power(cos_w, 1.15), 0.0)
        # Profil vertical asymétrique : ombre céruléenne nette JUSTE SOUS la mèche, crête blanche AU BORD SUPÉRIEUR !
        s_vert = (yn_surface - (yn_c + tilt * dphi)) / th_n
        in_band = in_arc & (s_vert > -1.35) & (s_vert < 1.65)
        if not np.any(in_band):
            continue

        # s_vert < 0 = haut de la mèche (crête lumineuse blanche/cyan franche !)
        # 0.55 < s_vert < 1.45 = sillon d'ombre céruléenne profonde sous la mèche !
        crest = tone_b * np.exp(-2.1 * ((s_vert + 0.26) ** 2))
        shadow_under = -0.42 * np.exp(-2.8 * ((s_vert - 0.86) ** 2))
        stroke_delta = w_phi * (crest + shadow_under)
        field = np.clip(field + stroke_delta, 0.0, 1.0)

    # Écume blanche vive sur les crochets du rebord intérieur (comme dans `ref_entree_tornades_user.png`)
    rim_boost = np.clip((u_clip - 0.68) / 0.32, 0.0, 1.0) * 0.22
    field = np.clip(field + rim_boost * (field > 0.42), 0.0, 1.0)

    pal_idx = np.clip(
        np.rint(field * (len(D13_TORNADO_PALETTE) - 1)).astype(np.int32),
        0,
        len(D13_TORNADO_PALETTE) - 1,
    )
    sub_rgb = D13_TORNADO_PALETTE[pal_idx]

    body = np.zeros((h, w, 4), dtype=np.uint8)
    sub_rgba = np.zeros((h, max_col, 4), dtype=np.uint8)
    sub_rgba[inside, :3] = sub_rgb[inside]
    sub_rgba[inside, 3] = 255

    if mirror_right:
        body[:, w - max_col :, :] = sub_rgba[:, ::-1, :]
    else:
        body[:, :max_col, :] = sub_rgba

    # Crochets en C Chunsoft (notamment le grand double crochet central à mi-hauteur de `ref_entree_tornades_user.png` !)
    hooks_spec = [
        (0.14, 0.55, 1.05, 1.10, 42.0),
        (0.28, 2.65, 1.12, 1.14, 48.0),
        (0.45, 0.85, 1.22, 1.24, 68.0),   # Grand crochet d'écume iconique à mi-hauteur !
        (0.48, 3.95, 1.20, 1.22, 64.0),   # Second grand crochet opposé (visible à mi-tour !)
        (0.63, 2.15, 1.14, 1.16, 52.0),
        (0.77, 5.20, 1.10, 1.12, 44.0),
    ]
    back_whips = np.zeros((h, w, 4), dtype=np.uint8)
    front_whips = np.zeros((h, w, 4), dtype=np.uint8)
    _draw_3d_hooked_crescents(
        front_canvas=front_whips,
        back_canvas=back_whips,
        xc=xc,
        r0=r0,
        omega=omega,
        mirror_right=mirror_right,
        hooks=hooks_spec,
    )
    return body, back_whips, front_whips


def build_twin_tornado_layers(
    w: int, h: int, n_frames: int = 24
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Génère les 4 calques 24 poses RGBA des deux tornades géantes de la Tour Céleste — Entrée."""
    gusts_left = _generate_cylindrical_gust_catalog(seed=1301)
    gusts_right = _generate_cylindrical_gust_catalog(seed=1302)

    left_frames: List[Image.Image] = []
    right_frames: List[Image.Image] = []
    front_frames: List[Image.Image] = []
    spark_frames: List[Image.Image] = []

    rng = np.random.default_rng(38401)
    motes = [
        (
            float(rng.choice([rng.uniform(0.03 * w, 0.30 * w), rng.uniform(0.70 * w, 0.97 * w)])),
            float(rng.uniform(0.0, h)),
            int(rng.choice([1, 2])),
            bool(rng.integers(0, 2)),
        )
        for _ in range(48)
    ]

    for f in range(n_frames):
        body_l, back_l, front_l = render_single_tornado_pose(
            w=w, h=h, pose_idx=f, gusts=gusts_left, n_frames=n_frames, mirror_right=False
        )
        body_r, back_r, front_r = render_single_tornado_pose(
            w=w, h=h, pose_idx=f, gusts=gusts_right, n_frames=n_frames, mirror_right=True
        )

        l_comp = back_l.copy()
        m_bl = body_l[:, :, 3] > 0
        l_comp[m_bl] = body_l[m_bl]

        r_comp = back_r.copy()
        m_br = body_r[:, :, 3] > 0
        r_comp[m_br] = body_r[m_br]

        f_whips = front_l.copy()
        m_fr = front_r[:, :, 3] > 0
        f_whips[m_fr] = front_r[m_fr]

        sparks = np.zeros((h, w, 4), dtype=np.uint8)
        ang = (2.0 * np.pi * f) / float(n_frames)
        for mx, my, speed_k, is_bright in motes:
            py = int(round(my - (speed_k * h * f) / float(n_frames))) % h
            px = int(round(mx + (6.0 * w / 768.0) * np.sin(ang + my * 0.04))) % w
            col = (255, 255, 255, 255) if is_bright else (164, 245, 255, 255)
            sparks[py, px] = col
            if is_bright and px + 1 < w:
                sparks[py, px + 1] = (204, 252, 255, 255)

        left_frames.append(Image.fromarray(l_comp, "RGBA"))
        right_frames.append(Image.fromarray(r_comp, "RGBA"))
        front_frames.append(Image.fromarray(f_whips, "RGBA"))
        spark_frames.append(Image.fromarray(sparks, "RGBA"))

    return left_frames, right_frames, front_frames, spark_frames
