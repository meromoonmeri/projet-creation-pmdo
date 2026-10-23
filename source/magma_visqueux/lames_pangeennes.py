"""Lames Pangéennes (*Precipice Blades*) — v2 Ciselée Plan-par-Plan & Ébullition Cellulaire Worley (`MMA1`).

Génère sur un cycle fermé `PHASES = 24` poses × `5` ticks (`120` ticks = `2.0 s` à `60 FPS`) une couronne
amphithéâtrale de **monolithes tectoniques obliques taillés à facettes rectilignes vives** qui jaillissent
hors de la mer de magma assombrie autour de l'arène de Groudon :
1. **Géométrie rocheuse planaire ciselée (0 ondulation molle, 0 étirement)** :
   - Profil polygonal à segments rectilignes (`np.interp` ancré sur `z_rock` depuis la pointe acérée `0.75 px`),
     crans tectoniques angulaires asymétriques et ligne d'immersion courbe naturelle dans la lave ;
   - Vrai volume 3D pixel-art à **5 plans rocheux nets** : silhouette d'obsidienne noire (`1 px`), facette
     d'ombre extérieure gris-noir basalte, facette éclairée côté arène en basalte sculpté gris-brun chaud,
     arête vive centrale ciselée (`[104, 88, 76]`) et reflet rasant orangé près de la lave ;
   - Fine déchirure ardente *Primo-Groudon* (`z_rock`-ancrée) courant le long du monolithe sans manger le volume.
2. **Base d'éruption 100 % cellulaire organique Worley (0 rectangle plat, 0 parts de tarte, 0 cercle géométrique)** :
   - Bouche d'ébullition magmatique Worley (`12 px`, `f2 - f1`) au contour lobé organique + gerbes courbes
     paraboliques de lave liquide et d'éclats d'obsidienne projetés lors du jaillissement balistique.
"""

from __future__ import annotations

from typing import Dict, List, Tuple

import numpy as np
from PIL import Image


def _worley_f1_f2(
    wx: np.ndarray,
    wy: np.ndarray,
    cell_px: float = 11.0,
    period_cells: int = 8,
    seed: int = 13,
) -> Tuple[np.ndarray, np.ndarray]:
    """Champ cellulaire Worley périodique `F1, F2` en pixels (`f2 - f1` = fissures de croûte organiques)."""
    rng = np.random.default_rng(seed)
    jit = rng.uniform(0.14, 0.86, size=(period_cells, period_cells, 2)).astype(np.float32)
    gx = wx / cell_px
    gy = wy / cell_px
    ix = np.floor(gx).astype(np.int32)
    iy = np.floor(gy).astype(np.int32)
    fx = gx - ix
    fy = gy - iy
    f1 = np.full(wx.shape, 99.0, dtype=np.float32)
    f2 = np.full(wx.shape, 99.0, dtype=np.float32)
    for oy in (-1, 0, 1):
        for ox in (-1, 0, 1):
            cx_i = (ix + ox) % period_cells
            cy_i = (iy + oy) % period_cells
            dx = ox + jit[cy_i, cx_i, 0] - fx
            dy = oy + jit[cy_i, cx_i, 1] - fy
            d = np.hypot(dx, dy)
            m1 = d < f1
            f2 = np.where(m1, f1, np.minimum(f2, d))
            f1 = np.where(m1, d, f1)
    return f1, f2

# Palette pixel-art 16 tons (100 % `R >= G >= B` sur tous les tons chauds => 0 dérive violette !)
BLADE_PAL = np.array(
    [
        [10, 9, 11],     # 0  : silhouette obsidienne noire pure
        [20, 18, 20],    # 1  : facette d'ombre basalte profond
        [31, 28, 29],    # 2  : grain rocheux sur facette d'ombre
        [48, 42, 40],    # 3  : facette éclairée basalte intermédiaire
        [66, 56, 51],    # 4  : facette éclairée basalte haute
        [84, 71, 63],    # 5  : facette éclairée plan supérieur
        [106, 90, 78],   # 6  : arête vive centrale ciselée (spéculaire roche)
        [98, 44, 24],    # 7  : reflet rasant du magma sur le pied rocheux
        [136, 28, 16],   # 8  : croûte grenat / biseau thermique des fissures
        [178, 42, 16],   # 9  : magma cramoisi sombre (lèvre de faille)
        [218, 74, 18],   # 10 : fissure ardente rouge-orangé Primo-Groudon
        [247, 124, 28],  # 11 : magma orange vif d'éruption
        [255, 178, 36],  # 12 : or incandescent de percée tectonique
        [255, 223, 52],  # 13 : jaune d'ébullition haute énergie
        [255, 248, 92],  # 14 : cœur blanc-or de déchirure sismique
    ],
    dtype=np.uint8,
)

PRECIPICE_BLADE_SITES_768: List[Dict[str, float]] = [
    # 1. Paire Nord-Intérieure (encadre l'arrivée de Groudon devant le massif noir Nord)
    {"x": 226.0, "y": 336.0, "length": 94.0,  "half_w": 15.0, "tilt_deg": -16.5, "phase": 0.42, "seed": 11},
    {"x": 542.0, "y": 336.0, "length": 94.0,  "half_w": 15.0, "tilt_deg": +16.5, "phase": 0.46, "seed": 12},
    # 2. Paire Amphithéâtre Haute Extérieure (entre les colonnes géantes et l'arène)
    {"x": 148.0, "y": 368.0, "length": 104.0, "half_w": 16.5, "tilt_deg": -14.0, "phase": 0.68, "seed": 21},
    {"x": 620.0, "y": 368.0, "length": 104.0, "half_w": 16.5, "tilt_deg": +14.0, "phase": 0.72, "seed": 22},
    # 3. Paire Médiane Flancs `Ω` (inclinée puissamment de part et d'autre de l'anneau Oméga)
    {"x": 184.0, "y": 452.0, "length": 122.0, "half_w": 19.5, "tilt_deg": -20.5, "phase": 0.88, "seed": 31},
    {"x": 584.0, "y": 452.0, "length": 122.0, "half_w": 19.5, "tilt_deg": +20.5, "phase": 0.92, "seed": 32},
    # 4. Paire Héroïque Avant-Plan Sud-Ouest / Sud-Est (encadre l'arrivée par le pont Sud !)
    {"x": 252.0, "y": 540.0, "length": 138.0, "half_w": 22.0, "tilt_deg": -18.5, "phase": 0.58, "seed": 41},
    {"x": 516.0, "y": 540.0, "length": 138.0, "half_w": 22.0, "tilt_deg": +18.5, "phase": 0.62, "seed": 42},
]


def _paint_idx(canvas: np.ndarray, mask: np.ndarray, idx: np.ndarray | int) -> None:
    if not bool(mask.any()):
        return
    c_idx = np.clip(np.rint(idx).astype(np.int32), 0, len(BLADE_PAL) - 1)
    canvas[mask, :3] = BLADE_PAL[c_idx[mask] if np.ndim(c_idx) else c_idx]
    canvas[mask, 3] = 255


def _eruption_kinematics(u: float) -> Tuple[float, float, float]:
    """Cinématique balistique en `4` temps sur `u ∈ [0, 1)` :
    - `u ∈ [0.00, 0.10)` : ébullition sismique avant percée (`ext = 0.0 -> 0.14`)
    - `u ∈ [0.10, 0.28)` : JAILLISSEMENT BALISTIQUE EXPLOSIF (`ext = 0.14 -> 1.00`)
    - `u ∈ [0.28, 0.76)` : APOGÉE MAJESTUEUSE DRESSÉE (`48 %` du cycle à pleine hauteur !)
    - `u ∈ [0.76, 1.00)` : Subduction tectonique ardente dans la mer (`ext = 1.00 -> 0.0`)
    """
    if u < 0.10:
        k = u / 0.10
        ext = 0.14 * (k * k)
        glow = 0.85 + 0.15 * k
        splash = 0.58 + 0.42 * k
    elif u < 0.28:
        k = (u - 0.10) / 0.18
        ext = min(1.03, 0.14 + 0.89 * (1.0 - (1.0 - k) ** 3))
        if k > 0.82:
            ext = 1.03 - 0.03 * ((k - 0.82) / 0.18)
        glow = 1.0 - 0.22 * k
        splash = 1.0 - 0.34 * k
    elif u < 0.76:
        k = (u - 0.28) / 0.48
        ext = 1.0
        glow = 0.52 + 0.30 * (0.5 + 0.5 * np.sin(2.0 * np.pi * k * 2.0))
        splash = 0.28 + 0.12 * np.sin(2.0 * np.pi * k * 2.0 + 0.7)
    else:
        k = (u - 0.76) / 0.24
        ext = max(0.0, 1.0 - (k ** 1.85))
        glow = 0.58 + 0.34 * np.sin(np.pi * k)
        splash = 0.36 + 0.44 * np.sin(np.pi * k)
    return float(ext), float(glow), float(splash)


def _render_single_shard(
    canvas: np.ndarray,
    xx: np.ndarray,
    yy: np.ndarray,
    bx: float,
    by: float,
    angle_rad: float,
    length: float,
    half_w: float,
    ext: float,
    glow: float,
    lit_sign: float,
    seed: int,
) -> None:
    """Dessine un monolithe cristallin à **plans droits ciselés** (`np.interp`, 0 vague molle)."""
    cur_len = length * ext
    if cur_len < 4.5:
        return

    sin_a, cos_a = float(np.sin(angle_rad)), float(np.cos(angle_rad))
    dx = xx - bx
    dy = yy - by
    s_up = dx * sin_a - dy * cos_a
    s_perp = dx * cos_a + dy * sin_a

    # `z_rock = cur_len - s_up` est figé au bloc rocheux solide depuis sa pointe (`z_rock = 0`) !
    z_rock = cur_len - s_up
    if not bool(((s_up >= -4.0) & (z_rock >= 0.0) & (z_rock <= length)).any()):
        return

    t = np.clip(z_rock / max(length, 1.0), 0.0, 1.0)
    rng = np.random.default_rng(seed * 733 + 19)
    s1 = float(rng.uniform(0.30, 0.42))
    s2 = float(rng.uniform(0.58, 0.70))

    # Profils polygonaux RECTILIGNES à cran tectonique franc (pointe aiguë `0.045 * half_w` !)
    tk_L = np.array([0.0, s1 - 0.02, s1 + 0.015, 0.78, 1.0], dtype=np.float32)
    vk_L = np.array([0.045, 0.48, 0.36, 0.88, 1.02], dtype=np.float32) * half_w
    tk_R = np.array([0.0, 0.24, s2 - 0.02, s2 + 0.015, 1.0], dtype=np.float32)
    vk_R = np.array([0.045, 0.32, 0.72, 0.56, 0.96], dtype=np.float32) * half_w

    w_left = np.maximum(0.85, np.interp(t, tk_L, vk_L))
    w_right = np.maximum(0.85, np.interp(t, tk_R, vk_R))

    # Arête centrale brisée en 3 segments rectilignes nets (sépare les 2 plans 3D du monolithe !)
    tk_M = np.array([0.0, 0.34, 0.66, 1.0], dtype=np.float32)
    vk_M = np.array([0.0, 0.14 * lit_sign, -0.08 * lit_sign, 0.10 * lit_sign], dtype=np.float32) * half_w
    ridge_x = np.interp(t, tk_M, vk_M)

    u_lat = np.where(s_perp < 0.0, -s_perp / w_left, s_perp / w_right)
    # Immersion elliptique naturelle du pied dans la mer de lave
    foot_arc = 3.4 * np.sqrt(np.clip(1.0 - u_lat * u_lat, 0.0, 1.0))
    inside = (u_lat <= 1.0) & (z_rock >= 0.0) & (s_up >= -foot_arc)
    if not bool(inside.any()):
        return

    on_lit_face = (s_perp - ridge_x) * lit_sign >= 0.0
    near_ridge = np.abs(s_perp - ridge_x) <= np.maximum(0.95, 0.068 * half_w)

    # Facettes planaires de basalte avec plans de clivage obliques francs
    cleavage = ((z_rock * 0.14 + s_perp * 0.11 * lit_sign + seed * 0.37) % 1.0)
    plan_step = (t < s1) ^ (cleavage > 0.62)
    heat_low = np.exp(-np.maximum(s_up + foot_arc * 0.5, 0.0) / 15.0)

    lit_idx = np.where(t < 0.32, 5, np.where(plan_step, 4, 3))
    shd_idx = np.where(plan_step, 2, 1)
    rock_idx = np.where(on_lit_face, lit_idx, shd_idx)
    rock_idx = np.where(on_lit_face & (heat_low > 0.52), 7, rock_idx)
    rock_idx = np.where(near_ridge & (t > 0.04), np.where(heat_low > 0.62, 7, 6), rock_idx)

    # Silhouette noire franche `1.15 px`
    edge_dist = (1.0 - u_lat) * np.where(s_perp < 0.0, w_left, w_right)
    rock_idx = np.where(edge_dist <= 1.15, 0, rock_idx)

    # Fine fissure ardente Primo-Groudon sur la facette interne (laisse 80 % de la roche ciselée lisible !)
    tk_V = np.array([0.0, 0.28, 0.52, 0.76, 1.0], dtype=np.float32)
    vk_V = (
        ridge_x
        + lit_sign
        * half_w
        * np.interp(t, tk_V, np.array([0.05, 0.24, 0.13, 0.32, 0.22], dtype=np.float32))
    )
    d_main = np.abs(s_perp - vk_V)
    # Une seule branche angulaire secondaire nette
    z_br = z_rock - 0.46 * length
    d_br = np.where(
        (z_br >= 0.0) & (z_br <= 0.24 * length),
        np.abs(s_perp - (vk_V + lit_sign * 0.26 * z_br)),
        99.0,
    )
    d_crack = np.minimum(d_main, d_br)
    crack_reach = (t >= 0.16) & (edge_dist > 1.8)
    vein_w = (0.58 + 0.62 * glow) * (0.45 + 0.55 * t)

    in_bevel = inside & crack_reach & (d_crack <= vein_w + 0.95)
    in_vein = inside & crack_reach & (d_crack <= vein_w)
    in_hot = inside & crack_reach & (d_crack <= 0.42 * vein_w) & (glow > 0.64)

    rock_idx = np.where(in_bevel, 8, rock_idx)
    rock_idx = np.where(in_vein, np.where(glow > 0.78, 12, np.where(glow > 0.52, 11, 10)), rock_idx)
    rock_idx = np.where(in_hot, 14 if glow > 0.88 else 13, rock_idx)

    _paint_idx(canvas, inside, rock_idx)


def render_precipice_blade_site(
    canvas: np.ndarray,
    site: Dict[str, float],
    phase_idx: int,
    n_phases: int,
    open_sea_mask: np.ndarray,
) -> None:
    """Dessine un site complet *Lame Pangéenne* : bouche cellulaire Worley + 3 lames + gerbes courbes."""
    h, w = open_sea_mask.shape
    cx = float(site["x"])
    cy = float(site["y"])
    length = float(site["length"])
    half_w = float(site["half_w"])
    tilt_deg = float(site["tilt_deg"])
    phase0 = float(site["phase"])
    seed = int(site["seed"])
    lit_sign = 1.0 if cx < (w * 0.5) else -1.0

    u = ((phase_idx / float(n_phases)) - phase0) % 1.0
    ext, glow, splash = _eruption_kinematics(u)

    pad_x = int(length * 0.58 + half_w * 3.0 + 26)
    pad_up = int(length * 1.10 + 22)
    pad_dn = int(half_w * 1.5 + 20)
    x0, x1 = max(0, int(cx) - pad_x), min(w, int(cx) + pad_x + 1)
    y0, y1 = max(0, int(cy) - pad_up), min(h, int(cy) + pad_dn + 1)
    if x1 <= x0 or y1 <= y0:
        return

    sub_canvas = canvas[y0:y1, x0:x1]
    vis_sea = open_sea_mask[y0:y1, x0:x1]
    yy, xx = np.mgrid[y0:y1, x0:x1].astype(np.float32)

    # ------------------------------------------------------------------
    # 1. BOUCHE D'ÉBULLITION MAGMATIQUE CELLULAIRE WORLEY (`0` rectangle, `0` parts de tarte !)
    # ------------------------------------------------------------------
    rx = half_w * (1.42 + 0.42 * splash) + 5.0
    ry = half_w * (0.56 + 0.16 * splash) + 3.0
    ex = (xx - cx) / rx
    ey = (yy - cy) / ry
    r_ell = np.hypot(ex, ey)

    # Déformation radiale organique irrégulière (jamais d'étoile géométrique régulière !)
    ang = np.arctan2(ey, ex)
    tau = 2.0 * np.pi
    lobe = (
        0.13 * np.sin(3.0 * ang + seed * 1.7 + tau * u)
        + 0.09 * np.cos(5.0 * ang - seed * 2.3 - tau * u)
        + 0.06 * np.sin(7.0 * ang + seed * 0.9)
    )
    r_org = r_ell / (1.0 + lobe)

    # Texture cellulaire Worley `12 px` s'écartant radialement depuis le pied de la faille
    rad_out = (2.0 * u) % 1.0
    wx = xx - (xx - cx) * 0.22 * rad_out
    wy = yy - (yy - cy) * 0.22 * rad_out
    f1, f2 = _worley_f1_f2(wx, wy, cell_px=11.0, period_cells=8, seed=seed * 53 + 7)
    edge_cell = np.clip((f2 - f1) / 0.50, 0.0, 1.0)

    in_boil = vis_sea & (
        (r_org <= 0.68)
        | ((r_org <= 1.08) & (edge_cell < (1.28 - 0.92 * r_org)))
    )
    core_heat = np.clip(1.20 - 0.96 * r_org, 0.0, 1.0) * (0.60 + 0.40 * splash)
    boil_val = 0.56 * core_heat + 0.44 * (1.0 - edge_cell)

    boil_idx = np.select(
        [
            boil_val >= 0.84,
            boil_val >= 0.68,
            boil_val >= 0.50,
            boil_val >= 0.34,
        ],
        [14, 13, 11, 10],
        default=9,
    )
    # Petits îlots de croûte sombre retournée en périphérie de la bouche d'éruption
    crust_rim = in_boil & (r_org >= 0.72) & (edge_cell > 0.56)
    boil_idx = np.where(crust_rim, 8, boil_idx)
    _paint_idx(sub_canvas, in_boil, boil_idx)

    # ------------------------------------------------------------------
    # 2. GROUPE TECTONIQUE À 3 LAMES CISELÉES ASYMÉTRIQUES (`Lame Pangéenne`)
    # ------------------------------------------------------------------
    ang_main = np.deg2rad(tilt_deg)
    side_dir = -1.0 if tilt_deg < 0.0 else 1.0

    # (a) Éperon secondaire extérieur plus incliné (`58 %`)
    ext_spur = max(0.0, min(1.0, ext * 1.06 - 0.08))
    _render_single_shard(
        sub_canvas,
        xx,
        yy,
        bx=cx + side_dir * half_w * 0.76,
        by=cy - half_w * 0.08,
        angle_rad=ang_main + np.deg2rad(side_dir * 10.5),
        length=length * 0.58,
        half_w=half_w * 0.55,
        ext=ext_spur,
        glow=glow,
        lit_sign=lit_sign,
        seed=seed * 3 + 1,
    )

    # (b) GRAND MONOLITHE CENTRAL ACÉRÉ
    _render_single_shard(
        sub_canvas,
        xx,
        yy,
        bx=cx,
        by=cy,
        angle_rad=ang_main,
        length=length,
        half_w=half_w,
        ext=ext,
        glow=glow,
        lit_sign=lit_sign,
        seed=seed * 3 + 2,
    )

    # (c) Croc tectonique avant côté arène (`40 %`)
    ext_fang = max(0.0, min(1.0, ext * 1.12 - 0.04))
    _render_single_shard(
        sub_canvas,
        xx,
        yy,
        bx=cx - side_dir * half_w * 0.70,
        by=cy + half_w * 0.20,
        angle_rad=ang_main - np.deg2rad(side_dir * 8.0),
        length=length * 0.40,
        half_w=half_w * 0.46,
        ext=ext_fang,
        glow=glow,
        lit_sign=lit_sign,
        seed=seed * 3 + 3,
    )

    # ------------------------------------------------------------------
    # 3. COLLERETTE D'ÉCUME WORLEY DENTELÉE DEVANT LE PIED + GERBES COURBES PARABOLIQUES
    # ------------------------------------------------------------------
    foam_y_lip = cy - 0.5 + 2.6 * np.sin((xx - cx) * 0.31 + seed) + 1.5 * np.cos((xx - cx) * 0.57 - seed)
    front_ring = (
        vis_sea
        & (yy >= foam_y_lip)
        & (r_org <= 0.60 + 0.14 * splash)
        & (edge_cell < 0.56)
    )
    _paint_idx(sub_canvas, front_ring, np.where(edge_cell < 0.24, 13, 11))

    rng = np.random.default_rng(seed * 409 + 17)
    for j in range(8):
        s_side = -1.0 if (j % 2 == 0) else 1.0
        phase_j = float(rng.random())
        t_j = (2.0 * u - phase_j) % 1.0
        if t_j > 0.72:
            continue
        p = t_j / 0.72
        arc_h = (0.18 + 0.20 * float(rng.random())) * length * (0.40 + 0.75 * splash)
        arc_w = s_side * (0.60 + 0.80 * float(rng.random())) * half_w
        is_shard = (j % 3 == 0)
        # Chapelet de 4 gouttelettes courbes le long de l'arc balistique !
        for step_k, p_off in enumerate((0.0, 0.055, 0.11)):
            pk = max(0.0, p - p_off)
            px = cx + s_side * half_w * 0.52 + arc_w * pk
            py = cy + 1.0 - arc_h * (1.95 * pk - 1.22 * pk * pk)
            rad = max(0.95, (1.75 - 0.35 * step_k) * (1.0 - 0.35 * pk))
            d2 = ((xx - px) / rad) ** 2 + ((yy - py) / (rad * 1.25)) ** 2
            m = (d2 <= 1.0) & (vis_sea | (yy <= cy))
            if is_shard:
                _paint_idx(sub_canvas, m, 2 if step_k == 0 else 9)
            else:
                _paint_idx(sub_canvas, m, 13 if step_k == 0 else (11 if step_k == 1 else 9))


def build_precipice_blades_frames(
    w: int,
    h: int,
    open_sea_mask: np.ndarray,
    walk_floor_mask: np.ndarray | None = None,
    n_phases: int = 24,
) -> List[Image.Image]:
    """Construit les `24` poses RGBA (`PIL.Image.Image`, `768 × 576` ou mise à l'échelle exacte)
    des `8` sites *Lame Pangéenne* disposés en couronne esthétique autour de l'arène de Groudon."""
    sx = w / 768.0
    sy = h / 576.0
    sc = min(sx, sy)

    sites = [
        {
            "x": s["x"] * sx,
            "y": s["y"] * sy,
            "length": s["length"] * sc,
            "half_w": s["half_w"] * sc,
            "tilt_deg": s["tilt_deg"],
            "phase": s["phase"],
            "seed": s["seed"],
        }
        for s in PRECIPICE_BLADE_SITES_768
    ]

    sites_sorted = sorted(sites, key=lambda d: float(d["y"]))
    frames: List[Image.Image] = []
    for t in range(n_phases):
        canvas = np.zeros((h, w, 4), dtype=np.uint8)
        for s_cfg in sites_sorted:
            render_precipice_blade_site(canvas, s_cfg, phase_idx=t, n_phases=n_phases, open_sea_mask=open_sea_mask)
        if walk_floor_mask is not None:
            canvas[walk_floor_mask] = 0
        frames.append(Image.fromarray(canvas, mode="RGBA"))
    return frames
