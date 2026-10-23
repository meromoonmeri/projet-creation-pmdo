"""Colonnes de magma géantes — véritable élévation verticale continue (`24 × 5 = 120` ticks)
et bouche d'éruption volcanique organique bouillonnante (`Dark Crater Pit`, `PMDO 0.8.12`).

Principes physiques et visuels :
1. **Zéro étirement caoutchouc (`STRETCH = 1.0`, période propre `192 px`, montée pure `-8 px / pose`)** :
   - Sur `PHASES = 24` poses à `5` ticks (`12 FPS`), toute la matière cellulaire haute-contraste
     (`cœurs cramoisis idx 3..5`, `parois orange ardent idx 6..8`, `nervures & panaches d'or vif idx 10..12`,
     `écailles de scorie noire idx 0..2`) **monte physiquement de `-8.0 px` à chaque pose** (`192 px`
     sur `24` poses, `0` avertissement numérique, `0` coïncidence `pose 0 == pose 12`).
   - Cisaillement parabolique ascendant (`v_shear = y_mat - 0.72 * hw * xi²`) : le cœur central jaillit
     plus vite que les flancs, courbant chaque arche de magma **vers le haut (`∩`)**.
2. **Début de jaillissement organique en ébullition cellulaire (`perspective PMD 2.2:1`)** :
   - Cuvette de brassage cramoisie et plaques de croûte basaltique fracturées autour du pied (`idx 0..4`) ;
   - Bourrelet d'écume cellulaire bouillonnante (`Worley` fin `12 px` montant directement dans la gorge du jet,
     zéro triangle géométrique raide ni pavé angulaire découpé !) ;
   - Volutes et gerbes courbes d'éclaboussures de lave visqueuse jaillissant vers le haut et se brisant
     en gouttes rondes incandescentes tout autour du col, avec ondes concentriques fondues dans le lac.
"""

from __future__ import annotations

from importlib import util as _u
from pathlib import Path as _P

import numpy as np

_sp = _u.spec_from_file_location("magma_visqueux_mg", _P(__file__).with_name("magma.py"))
MG = _u.module_from_spec(_sp)
_sp.loader.exec_module(MG)  # type: ignore[union-attr]

PHASES = 24
TICKS = 5
LOOP_RISE_PX = 192        # Période verticale propre = 192 px => montée exacte -8.0 px / pose sur 24 poses !
COL_PERIOD = (192, 192)
N_PLUME_ARCS = 10
N_RISING_SPARKS = 18


def _paint(a: np.ndarray, m: np.ndarray, idx: np.ndarray | int | float) -> None:
    arr_idx = np.clip(np.rint(idx).astype(int), 0, 12)
    a[m, :3] = MG.PAL_NP[arr_idx[m] if np.ndim(arr_idx) else arr_idx]
    a[m, 3] = 255


def _periodic_profile_192(seed: int, harmonics: tuple[tuple[int, float], ...]) -> np.ndarray:
    """Profil 1D périodique sur `192 px` qui monte intégralement avec la colonne (`-8 px/pose`)."""
    rng = np.random.default_rng(seed)
    z = np.arange(LOOP_RISE_PX, dtype=np.float32)
    out = np.zeros_like(z)
    tau = 2.0 * np.pi
    for k, amp in harmonics:
        ph = float(rng.uniform(0.0, tau))
        out += amp * np.sin(tau * k * z / float(LOOP_RISE_PX) + ph)
    return out


def _sample_1d(prof: np.ndarray, coord: np.ndarray) -> np.ndarray:
    n = prof.shape[0]
    i0 = np.floor(coord).astype(np.int32)
    f = (coord - i0).astype(np.float32)
    return prof[i0 % n] * (1.0 - f) + prof[(i0 + 1) % n] * f


def _col_cell_level_192(u: np.ndarray, v: np.ndarray, seed: int) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Texture cellulaire Worley périodique `192 × 192` à fort contraste `Dark Crater Pit` (`idx 3..12`)."""
    nu = MG.tex_noise(seed + 71, 3.2, COL_PERIOD)
    nv = MG.tex_noise(seed + 83, 3.2, COL_PERIOD)
    us = u * 0.72 + 2.6 * MG.sample(nu, u * 0.72, v)
    vs = v + 2.6 * MG.sample(nv, u * 0.72, v)
    f1, f2, h = MG.worley(us, vs, P=COL_PERIOD, cell=24, seed=seed + 40)
    q = 2.0 * f1 / (f1 + f2 + 1e-9)
    core = 0.34 + 0.20 * h
    lvl = np.where(
        q < core,
        3.1 + 1.9 * q / core,
        np.where(
            q < 0.80,
            5.0 + 4.4 * (q - core) / (0.80 - core),
            np.where(q < 0.93, 9.8, 11.8),
        ),
    )
    return np.clip(lvl, 3.0, 12.0), q, h


def _mouth_foam_cells(u: np.ndarray, v: np.ndarray, seed: int) -> tuple[np.ndarray, np.ndarray]:
    """Cellules fines d'écume bouillonnante (`cell = 12 px`, période `96 px`) au pied d'éruption."""
    f1, f2, h = MG.worley(u, v, P=(96, 96), cell=12, seed=seed + 130)
    q = 2.0 * f1 / (f1 + f2 + 1e-9)
    return q, h


def window(c: dict, H: int, W: int) -> tuple[int, int, int]:
    """Fenêtre `(wx0, wx1, wy1)` englobant le fût, sa bouche bouillonnante, ses gerbes et ses ondes."""
    hw = int(c["demi"])
    pad_x = int(round(3.15 * hw)) + 26
    pad_y = int(round(1.50 * hw)) + 22
    return max(0, int(c["x"]) - pad_x), min(W, int(c["x"]) + pad_x + 1), min(H, int(c["y"]) + pad_y)


def column_phase(t: int, H: int, W: int, c: dict, visible: np.ndarray) -> tuple[np.ndarray, int]:
    """Calcule la pose `t` (`0..PHASES-1`) d'une colonne géante en ascension verticale pure."""
    wx0, wx1, wy1 = window(c, H, W)
    a = np.zeros((wy1, wx1 - wx0, 4), dtype=np.uint8)
    vis = visible[:wy1, wx0:wx1]

    x0 = float(c["x"])
    yb = float(c["y"])
    hw = float(c["demi"])
    seed = int(c["graine"])
    n_ph = max(8, int(PHASES))
    s = ((t - int(c["decalage"])) % n_ph) / float(n_ph)
    tau = 2.0 * np.pi

    yy, xx = np.mgrid[:wy1, wx0:wx1].astype(np.float32)

    # Coordonnée matérielle ascendante pure : `y_mat = yy + 192 * s` => montée `-8.0 px / pose` !
    rise_shift = LOOP_RISE_PX * s
    y_mat = yy + rise_shift

    sway_prof = _periodic_profile_192(seed * 37 + 5, ((1, 2.2), (2, 1.3), (3, 0.7)))
    edge_left = _periodic_profile_192(seed * 37 + 13, ((2, 0.085), (3, 0.075), (5, 0.055), (8, 0.035)))
    edge_right = _periodic_profile_192(seed * 37 + 29, ((2, 0.085), (3, 0.075), (5, 0.055), (8, 0.035)))
    plume_prof = _periodic_profile_192(seed * 37 + 43, ((3, 0.30), (5, 0.20), (7, 0.12)))

    # 3 grandes poussées éruptives asymétriques par période de 192 px (zéro puissance de négatif !)
    surge_u = ((y_mat + 29.0 * seed) % 64.0) / 64.0
    rise_ramp = np.clip(np.sin(0.5 * np.pi * np.minimum(surge_u, 0.16) / 0.16), 0.0, 1.0) ** 1.3
    decay_ramp = np.exp(-np.maximum(surge_u - 0.16, 0.0) / 0.34)
    surge_env = np.where(surge_u < 0.16, rise_ramp, decay_ramp)

    axis = x0 + (hw / 16.0) * _sample_1d(sway_prof, y_mat)

    # Gorge d'arrachement évasée en trompette organique à la sortie du lac
    y_throat_bottom = yb + 0.42 * hw
    h_above_throat = np.maximum(y_throat_bottom - yy, 0.0)
    throat_flare = 0.66 * hw * np.exp(-h_above_throat / max(9.5, 0.78 * hw))

    dx = xx - axis
    side_rip = np.where(dx < 0.0, _sample_1d(edge_left, y_mat), _sample_1d(edge_right, y_mat + 27.0))
    half = hw * (0.90 + 0.16 * surge_env + side_rip) + throat_flare
    half = np.maximum(half, 3.0)
    xi = dx / half

    bottom_curve = yb + 0.40 * hw * np.sqrt(np.clip(1.0 - xi * xi, 0.0, 1.0))
    in_shaft = (yy <= bottom_curve) & (np.abs(xi) <= 1.0) & (vis | (yy <= yb - 0.15 * hw))

    # Cisaillement parabolique ascendant : le cœur monte en pointe convexe vers le HAUT `∩` !
    v_shear = y_mat - 0.72 * hw * (xi * xi)
    u_tex = dx + 53.0 * seed

    # ------------------------------------------------------------------
    # 1. CUVETTE D'ÉBULLITION CELLULAIRE & ONDES SUR LE LAC (`début du jaillissement`)
    # ------------------------------------------------------------------
    rx_m = 2.05 * hw + 11.0
    ry_m = 0.85 * hw + 5.5
    ex = (xx - x0) / rx_m
    ey = (yy - yb) / ry_m
    r_ell = np.hypot(ex, ey)
    ang = np.arctan2(ey, ex)

    grain_192 = MG.tex_noise(seed + 97, 0.9, COL_PERIOD)
    sea_grain = MG.sample(grain_192, xx + 14.0 * np.cos(tau * s), yy + 14.0 * np.sin(tau * s))

    # Cuvette cramoisie organique autour du point d'arrachement (`r_ell <= 1.18 + ondulation Worley`)
    q_foam, h_foam = _mouth_foam_cells((xx - x0) * 0.75 + 31.0 * seed, yy + 96.0 * s, seed)
    trough_outer = 1.16 + 0.14 * sea_grain + 0.09 * (q_foam - 0.5)
    in_trough = vis & (r_ell <= trough_outer)
    trough_lvl = np.clip(2.6 + 3.2 * q_foam + 1.2 * sea_grain, 1.0, 7.0)
    _paint(a, in_trough, trough_lvl)

    # Plaques organiques de scorie noire retournées sur la lèvre extérieure (`idx 0..2`)
    scoria_m = vis & (r_ell >= 0.80) & (r_ell <= 1.18) & (h_foam < 0.34) & (q_foam < 0.72)
    _paint(a, scoria_m, np.where(q_foam < 0.36, 0.0, np.where(q_foam < 0.56, 1.0, 2.0)))

    # Ondes concentriques organiques s'éloignant dans les cellules du lac (`r_ell = 1.05 -> 2.05`)
    for k in range(2):
        f_w = (s * 2.0 + k * 0.5) % 1.0
        r_target = 1.04 + 1.02 * f_w + 0.07 * sea_grain
        w_thick = 0.068 * (1.0 - 0.45 * f_w)
        crest_ok = (sea_grain + 0.65 * np.sin(5.0 * ang - tau * s + 2.3 * k + seed)) > -0.05
        ring = vis & (np.abs(r_ell - r_target) <= w_thick) & crest_ok
        _paint(a, ring, 11.2 - 3.6 * f_w)

    # ------------------------------------------------------------------
    # 2. FÛT CELLULAIRE HAUT-CONTRASTE `DARK CRATER PIT` EN ASCENSION PURE
    # ------------------------------------------------------------------
    lvl_cell, q, h_id = _col_cell_level_192(u_tex * 1.08, v_shear, seed)
    prof = np.clip(1.0 - np.abs(xi) ** 2.1, 0.0, 1.0)
    dome_48 = 0.5 + 0.5 * np.cos(tau * v_shear / 48.0)

    lvl = (
        0.74 * lvl_cell
        + 2.35 * (prof ** 1.15)
        + 1.65 * surge_env * (0.35 + 0.65 * prof)
        + 1.15 * (dome_48 ** 1.6) * prof
        - 1.35 * (1.0 - prof)
    )

    plume_w = np.clip(0.24 * surge_env + 0.22 * _sample_1d(plume_prof, v_shear) + 0.08, 0.0, 0.40)
    in_plume = (np.abs(xi) <= plume_w) & ((surge_env > 0.42) | (dome_48 > 0.68))
    lvl = np.where(in_plume, np.maximum(lvl, 10.5 + 1.5 * surge_env), lvl)
    in_white_gold = in_plume & (np.abs(xi) <= 0.45 * plume_w) & (surge_env > 0.62)
    lvl = np.where(in_white_gold, 12.0, lvl)

    edge_px = (1.0 - np.abs(xi)) * half
    adv_grain = MG.sample(grain_192, u_tex * 1.2, v_shear)
    lvl = np.where(edge_px < 4.5, np.minimum(lvl, 5.6 + 1.8 * surge_env), lvl)
    lvl = np.where(edge_px < 2.5, np.where(adv_grain > 0.20, 4.0, 3.0), lvl)

    crust_plate = (
        ((h_id < 0.22) & (q < 0.68) & (np.abs(xi) > 0.34) & (surge_env < 0.68))
        | ((edge_px < 2.2) & (adv_grain > 0.48))
    )
    lvl = np.where(crust_plate, np.where(q < 0.30, 0.0, np.where(adv_grain > 0.65, 1.0, 2.0)), lvl)

    _paint(a, in_shaft, lvl)

    # ------------------------------------------------------------------
    # 3. COLLIER D'ÉCUME BOUILLONNANTE & VOLUTES COURBES DE JAILLISSEMENT !
    # ------------------------------------------------------------------
    # (A) Dôme d'écume cellulaire bouillonnante à la base exacte du fût (`comme H26P01`, zéro pavé plat !) :
    #     De vraies bulles Worley montantes (`yy + 96 * s`) soudent la surface du lac à la base de la colonne !
    collar_top_y = (
        yb
        - (0.48 + 0.24 * q_foam + 0.14 * np.sin(tau * 2.0 * s + 3.0 * ang)) * hw * np.exp(-((ex * 1.15) ** 2))
        + 0.16 * hw
    )
    collar_bot_y = yb + 0.44 * hw * np.sqrt(np.clip(1.0 - (ex / 0.94) ** 2, 0.0, 1.0)) + 2.0 * sea_grain
    in_collar = (
        (np.abs(ex) <= 0.94)
        & (yy >= collar_top_y)
        & (yy <= collar_bot_y)
        & (vis | (yy <= yb + 1.0))
    )
    # Bulles d'écume ardente : parois cellulaires jaune-or vif (`idx 11..12`), cœurs orange-rouge (`idx 5..9`)
    collar_lvl = np.where(
        q_foam > 0.74,
        12.0,
        np.where(q_foam > 0.52, 9.8 + 1.8 * (q_foam - 0.52) / 0.22, 4.8 + 4.2 * q_foam / 0.52),
    )
    # Bordure extérieure braise d'1.5 px au contact de la cuvette sombre pour une lisibilité pixel-art nette
    collar_edge = in_collar & ((yy >= collar_bot_y - 1.6) | (np.abs(ex) >= 0.86))
    collar_lvl = np.where(collar_edge & (q_foam < 0.65), 3.0, collar_lvl)
    _paint(a, in_collar, collar_lvl)

    # (B) Volutes courbes & gouttes lobées de magma projetées VERS LE HAUT tout autour du bourrelet !
    rng_j = np.random.default_rng(seed * 977 + 53)
    for j in range(N_PLUME_ARCS):
        side = -1.0 if (j % 2 == 0) else 1.0
        slot = j // 2
        ph_j = (j * 0.29 + 0.17 * seed) % 1.0
        tau_j = (2.0 * s - ph_j) % 1.0
        if tau_j > 0.92:
            continue

        u_life = tau_j / 0.92
        # Chapelet de 4 lobes ronds joints le long d'un arc parabolique montant et s'incurvant vers l'extérieur !
        bx = x0 + side * (0.42 + 0.13 * slot) * hw
        by = yb + (0.26 - 0.05 * slot) * hw
        rise_h = (0.72 + 0.45 * float(rng_j.random())) * hw
        arch_out = side * (0.34 + 0.30 * float(rng_j.random())) * hw

        # La gerbe monte rapidement (`u_front : 0 -> 1`) puis sa queue basse se détache pendant que la tête monte !
        s_head = float(np.sin(0.5 * np.pi * min(1.0, u_life * 1.22)))
        s_tail = max(0.0, (u_life - 0.30) / 0.70) * 0.72
        if s_head - s_tail <= 0.06:
            continue

        for b_i in range(5):
            su = s_tail + (s_head - s_tail) * (b_i / 4.0)
            px = bx + arch_out * (su ** 1.65)
            py = by - rise_h * (1.22 * su - 0.28 * (su ** 2))
            rad = (0.14 * hw + 1.45) * (1.0 - 0.52 * su) * float(np.sin(np.pi * min(1.0, 0.22 + 0.78 * (1.0 - u_life * 0.45))))
            if rad < 0.85:
                continue
            d2_b = ((xx - px) / rad) ** 2 + ((yy - py) / (rad * 1.25)) ** 2
            m_b = (d2_b <= 1.0) & (vis | (yy <= yb + 1.5))
            cool_head = (u_life > 0.72) and (b_i == 4)
            _paint(a, m_b, 2 if cool_head else 4)
            _paint(a, m_b & (d2_b <= 0.56), 7 if cool_head else 9)
            _paint(a, m_b & (d2_b <= 0.22), 10 if cool_head else 12)

    # ------------------------------------------------------------------
    # 4. GOUTTES & BRANDONS DE MAGMA PROJETÉS VERS LE HAUT LE LONG DU FÛT
    # ------------------------------------------------------------------
    rng_s = np.random.default_rng(seed * 313 + 19)
    for j in range(N_RISING_SPARKS):
        side = -1.0 if (j % 2 == 0) else 1.0
        t0 = float(rng_s.random())
        u_life = (2.0 * s - t0) % 1.0
        y_start = yb - float(rng_s.uniform(0.0, 0.62)) * max(yb, 40.0)
        climb_px = float(rng_s.uniform(60.0, 128.0))
        drift_out = float(rng_s.uniform(6.0, 19.0))

        py = y_start - climb_px * (1.30 * u_life - 0.32 * (u_life ** 2))
        if py < 1.0 or py >= wy1 - 2 or u_life > 0.88:
            continue
        axis_py = x0 + (hw / 16.0) * float(_sample_1d(sway_prof, np.array([py + rise_shift], dtype=np.float32))[0])
        px = axis_py + side * (hw * 0.95 + drift_out * (u_life ** 0.75))

        d_sp = ((xx - px) / 1.8) ** 2 + ((yy - py) / 2.9) ** 2
        big = 1.35 if (j % 3 == 0) else 0.95
        cool = u_life > 0.70
        _paint(a, d_sp <= 1.6 * big, 1 if cool else 4)
        _paint(a, d_sp <= 0.72 * big, 8 if cool else 12)

    return a, wx0


def column_frames(H: int, W: int, cols: list[dict], visible: np.ndarray) -> list[np.ndarray]:
    """Génère les `PHASES` calques RGBA plein cadre (les colonnes plus au Sud recouvrent celles du fond)."""
    out: list[np.ndarray] = []
    order = sorted(cols, key=lambda c: c["y"])
    n_ph = int(PHASES)
    for t in range(n_ph):
        e = np.zeros((H, W, 4), dtype=np.uint8)
        for c in order:
            f, wx0 = column_phase(t, H, W, c, visible)
            sub = e[: f.shape[0], wx0 : wx0 + f.shape[1]]
            m = f[:, :, 3] > 0
            sub[m] = f[m]
        out.append(e)
    return out
