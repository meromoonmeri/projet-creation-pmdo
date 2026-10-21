#!/usr/bin/env python3
"""Génère 10 brouillons natifs 100 % Métano (Metano_Town_Base + Metano_Town_Cliffs,
fond #FF00FF pur, ZÉRO image parasite superposée) pour les 10 variantes de falaises
côtières centrées nues, avant la passe spriter `generate_image`."""
from __future__ import annotations

import math
import sys
from pathlib import Path
from typing import Callable, List, Tuple
import numpy as np
from PIL import Image
from scipy.ndimage import distance_transform_edt, binary_fill_holes

ROOT = Path("/home/user/projet-creation-pmdo")
NATIFS_ABYSS = ROOT / "source" / "cote_v4_abyss" / "natifs"
WORK = Path("/tmp/work_cliff10")
WORK.mkdir(parents=True, exist_ok=True)

sys.path.insert(0, str(ROOT / "source" / "cliff_nord_centre_v1"))
from build import decode_tile_straight

W, H = 1200, 880


def decode_tile_sheet(path: Path) -> np.ndarray:
    return np.array(decode_tile_straight(path).convert("RGBA"))


def load_native_materials():
    base_d = decode_tile_sheet(NATIFS_ABYSS / "Metano_Town_Base.tile")
    cliffs_d = decode_tile_sheet(NATIFS_ABYSS / "Metano_Town_Cliffs.tile")

    grass_patch = base_d[640:768, 0:128, :4].copy()
    grass_canvas = np.zeros((H, W, 4), dtype=np.uint8)
    for y in range(0, H, 128):
        for x in range(0, W, 128):
            ph, pw = min(128, H - y), min(128, W - x)
            grass_canvas[y : y + ph, x : x + pw] = grass_patch[:ph, :pw]

    tuft1 = base_d[776:792, 16:32].copy()
    tuft2 = base_d[792:808, 48:64].copy()
    rng = np.random.default_rng(42)
    for _ in range(95):
        tx = int(rng.integers(80, W - 96))
        ty = int(rng.integers(320, H - 24))
        t = tuft1 if rng.random() < 0.5 else tuft2
        m = t[..., 3] == 255
        grass_canvas[ty : ty + 16, tx : tx + 16][m] = t[m]

    # Vrais modules rocheux secs de Metano_Town_Cliffs (ZÉRO herbe, ZÉRO grotte, ZÉRO eau)
    flat_stone = cliffs_d[450:544, 908:976].copy()     # 94 x 68 assises dorées
    pillar_stone = cliffs_d[432:544, 696:744].copy()   # 112 x 48 pilier arrondi rosé
    for arr_s in (flat_stone, pillar_stone):
        greenish = (arr_s[..., 1].astype(int) - arr_s[..., 0].astype(int)) > 4
        arr_s[greenish] = flat_stone[18, 18]
        for r in range(arr_s.shape[0]):
            ox = np.flatnonzero(arr_s[r, :, 3] > 220)
            if len(ox) > 0:
                for c in range(arr_s.shape[1]):
                    if arr_s[r, c, 3] <= 220:
                        arr_s[r, c] = arr_s[r, ox[np.argmin(np.abs(ox - c))]]
        arr_s[..., 3] = 255

    # Frise alternant vrais piliers arrondis rosés et vraies parois stratifiées Métano
    stone_strip = np.concatenate(
        [
            pillar_stone[:94, :],
            flat_stone[:, :56],
            pillar_stone[:94, :],
            flat_stone,
            pillar_stone[:94, :],
        ],
        axis=1,
    )
    return grass_canvas, stone_strip


OUTLINE_DARK = np.array([104, 72, 40, 255], dtype=np.uint8)
LIP_SHADOW   = np.array([152, 108, 56, 255], dtype=np.uint8)
LIP_OCHRE    = np.array([196, 152, 80, 255], dtype=np.uint8)
LIP_GOLD     = np.array([220, 184, 104, 255], dtype=np.uint8)
GRASS_SHADE  = np.array([176, 200, 58, 255], dtype=np.uint8)


def render_tiers_to_magenta(
    tiers: List[Tuple[np.ndarray, int]],
    grass_canvas: np.ndarray,
    stone_strip: np.ndarray,
    seed: int = 1,
) -> Image.Image:
    """`tiers`: liste du palier le PLUS BAS au palier le PLUS HAUT : `(plateau_bool_mask, wall_max_h)`."""
    SH, SW = stone_strip.shape[:2]
    yy, xx = np.mgrid[:H, :W]
    out = np.full((H, W, 4), [255, 0, 255, 255], dtype=np.uint8)

    noise = (
        1.8 * np.sin(xx * 0.21 + yy * 0.13 + seed)
        + 1.3 * np.sin(xx * 0.47 - yy * 0.29 + seed * 1.7)
        + 0.9 * np.sin(xx * 0.09 + yy * 0.07)
    )

    for plat_raw, wall_max_h in tiers:
        plat = binary_fill_holes(plat_raw)

        # 1. Paroi rocheuse étagée en vrais crans de piliers Métano sous le bord inférieur de `plat`
        rock = np.zeros((H, W, 4), dtype=np.uint8)
        xs_occ = np.flatnonzero(plat.any(axis=0))
        if len(xs_occ) > 0:
            x_min, x_max = int(xs_occ[0]), int(xs_occ[-1])
            for x in range(x_min, x_max + 1):
                ys = np.flatnonzero(plat[:, x])
                if len(ys) == 0:
                    continue
                yt, yb = int(ys[0]), int(ys[-1])
                if yb < H and wall_max_h > 0:
                    edge_dist = min(x - x_min, x_max - x)
                    t_nose = np.clip(edge_dist / 78.0, 0.0, 1.0)
                    # Légers décrochements de piliers tous les ~52 px comme Metano_Town_Cliffs !
                    pillar_step = 10.0 * math.sin(x * (2.0 * math.pi / 104.0) + seed)
                    wh = int(round(18 + (wall_max_h - 18 + pillar_step) * (t_nose ** 0.65)))
                    y0 = max(yt + 4, yb - 6)
                    y1 = min(H, yb + wh)
                    if y1 > y0:
                        ys_sl = np.arange(y0, y1)
                        rel_top = ys_sl - y0
                        rel_bot = y1 - ys_sl
                        sy = 18 + ((ys_sl + seed * 8) % 48)
                        sy = np.where(rel_top < 14, rel_top, sy)
                        sy = np.where(rel_bot <= 16, SH - rel_bot, sy)
                        rock[y0:y1, x] = stone_strip[np.clip(sy, 0, SH - 1), (x + seed * 24) % SW]

        # 2. Surface Grass Métano + liseré doré-ocre dentelé (ouvert au Sud si le palier touche y=H-1)
        padded = np.vstack([plat, np.tile(plat[-1:], (24, 1))])
        dist_in = distance_transform_edt(padded)[:H] + noise

        surf = np.zeros((H, W, 4), dtype=np.uint8)
        gx_off = (seed * 32) % 64
        gy_off = (seed * 24) % 64
        rolled_grass = np.roll(np.roll(grass_canvas, gy_off, axis=0), gx_off, axis=1)
        surf[plat] = rolled_grass[plat]
        surf[plat & (dist_in < 9.5)] = GRASS_SHADE
        surf[plat & (dist_in < 7.2)] = LIP_GOLD
        surf[plat & (dist_in < 5.0)] = LIP_OCHRE
        surf[plat & (dist_in < 2.8)] = LIP_SHADOW
        surf[plat & (dist_in < 1.5)] = OUTLINE_DARK

        mr = rock[..., 3] == 255
        out[mr] = rock[mr]
        ms = surf[..., 3] == 255
        out[ms] = surf[ms]

    # Recadre uniquement la bande terrain y = 320..880 (1200 x 560 px) pour que le générateur
    # travaille à l'échelle 1:1 exacte sur 100 % du cadre sans jamais zoomer dans le ciel !
    out[:328, :] = [255, 0, 255, 255]
    return Image.fromarray(out[320:880, :, :])


def make_cape_mask(
    cx: float,
    half_w_max: float,
    y_crest: float,
    y_belly: float,
    south_half_w: float,
    south_cx: float | None = None,
    wob_amp: float = 10.0,
    phase: float = 0.0,
    cove_depth: float = 0.0,
    skew: float = 0.0,
    y_limit_bottom: int = H,
) -> np.ndarray:
    """Construit un masque de promontoire côtier organique 100 % monotone par colonne."""
    if south_cx is None:
        south_cx = cx
    m = np.zeros((H, W), dtype=bool)
    x0 = max(48, int(round(cx - half_w_max - 24)))
    x1 = min(W - 48, int(round(cx + half_w_max + 24)))
    for x in range(x0, x1):
        u = (x - cx) / half_w_max
        if abs(u) > 1.0:
            continue
        # Asymétrie douce optionnelle
        u_eff = u + skew * (1.0 - u * u)
        yt = (
            y_crest
            + (y_belly - y_crest) * (min(1.0, abs(u_eff)) ** 2.05)
            + cove_depth * math.exp(-((u * 3.2) ** 2))
            + wob_amp * math.sin(x * 0.029 + phase)
            + 0.45 * wob_amp * math.sin(x * 0.077 - phase * 1.4)
        )
        # Bord inférieur : couloir Sud centré sur south_cx + flancs remontant vers y_belly
        dx_s = x - south_cx
        if abs(dx_s) <= south_half_w:
            yb = float(y_limit_bottom)
        else:
            side_span = max(40.0, (cx + half_w_max - (south_cx + south_half_w)) if dx_s > 0 else ((south_cx - south_half_w) - (cx - half_w_max)))
            s = min(1.0, (abs(dx_s) - south_half_w) / side_span)
            yb = (
                y_limit_bottom
                - (y_limit_bottom - (y_belly + 22.0)) * (s ** 0.80)
                + 8.0 * math.sin(x * 0.036 + phase + 1.2)
            )
        yti = max(332, int(round(yt)))
        ybi = min(y_limit_bottom, int(round(yb)))
        if ybi > yti + 8:
            m[yti:ybi, x] = True
    return m


ZONES_SPEC = [
    ("01_grand_cap_panoramique", "Le Grand Cap Panoramique"),
    ("02_eperon_nord_effile", "L’Éperon Nord Effilé"),
    ("03_double_terrasse_centrale", "La Double Terrasse Centrale"),
    ("04_grande_esplanade_royale", "La Grande Esplanade Royale"),
    ("05_cap_anse_jumelle", "Le Cap aux Deux Ailes"),
    ("06_presquile_isthme_etroit", "La Presqu’île à Isthme Étroit"),
    ("07_cap_asymetrique_ouest", "Le Cap Vent d’Ouest"),
    ("08_cap_asymetrique_est", "Le Cap du Levant"),
    ("09_trois_paliers_sacres", "Les Trois Paliers Ascendants"),
    ("10_bastion_circulaire", "Le Bastion Circulaire"),
]


def main() -> None:
    grass_canvas, stone_strip = load_native_materials()

    builders: List[Tuple[str, List[Tuple[np.ndarray, int]]]] = [
        # 01 : Grand Cap Panoramique arrondi classique style cliffdaytest centré
        (
            "01_grand_cap_panoramique",
            [(make_cape_mask(600, 456, 352, 516, 244, wob_amp=8.0, phase=0.5), 172)],
        ),
        # 02 : Éperon Nord Effilé s'avançant loin vers le large, flancs élancés
        (
            "02_eperon_nord_effile",
            [(make_cape_mask(600, 336, 338, 560, 176, wob_amp=9.5, phase=1.8), 184)],
        ),
        # 03 : Double Terrasse Centrale (esplanade Sud + belvédère Nord surélevé avec paroi Métano intérieure)
        (
            "03_double_terrasse_centrale",
            [
                (make_cape_mask(600, 468, 456, 590, 276, wob_amp=7.5, phase=2.4), 166),
                (make_cape_mask(600, 320, 344, 458, 320, wob_amp=6.5, phase=0.9, y_limit_bottom=592), 92),
            ],
        ),
        # 04 : Grande Esplanade Royale large à bastions latéraux festonnés
        (
            "04_grande_esplanade_royale",
            [(make_cape_mask(600, 504, 368, 492, 316, wob_amp=11.0, phase=3.1), 176)],
        ),
        # 05 : Cap aux Deux Ailes avec douce crique Nord centrale
        (
            "05_cap_anse_jumelle",
            [(make_cape_mask(600, 468, 346, 512, 232, wob_amp=8.0, phase=4.0, cove_depth=54.0), 172)],
        ),
        # 06 : Presqu'île circulaire reliée au Sud par un isthme étroit bordé de hautes falaises
        (
            "06_presquile_isthme_etroit",
            [(make_cape_mask(600, 412, 346, 508, 108, wob_amp=7.0, phase=5.2), 192)],
        ),
        # 07 : Cap Asymétrique Vent d'Ouest (esprit organique cliffdaytest centré-ouest)
        (
            "07_cap_asymetrique_ouest",
            [(make_cape_mask(574, 452, 346, 526, 236, south_cx=618, wob_amp=11.5, phase=1.1, skew=-0.24), 178)],
        ),
        # 08 : Cap Asymétrique du Levant (corniche étirée vers le Nord-Est, flanc Ouest abrupt)
        (
            "08_cap_asymetrique_est",
            [(make_cape_mask(626, 452, 346, 526, 236, south_cx=582, wob_amp=11.5, phase=2.7, skew=0.24), 178)],
        ),
        # 09 : Trois Paliers Ascendants (amphithéâtre sacré Sud -> Milieu -> Belvédère Nord)
        (
            "09_trois_paliers_sacres",
            [
                (make_cape_mask(600, 484, 520, 636, 296, wob_amp=7.0, phase=0.4), 156),
                (make_cape_mask(600, 368, 418, 520, 368, wob_amp=6.5, phase=1.9, y_limit_bottom=644), 76),
                (make_cape_mask(600, 236, 338, 416, 236, wob_amp=5.5, phase=3.3, y_limit_bottom=502), 72),
            ],
        ),
        # 10 : Bastion Circulaire Monumental (médaillon panoramique entouré d'une couronne de piliers)
        (
            "10_bastion_circulaire",
            [(make_cape_mask(600, 376, 350, 500, 152, wob_amp=6.0, phase=6.0), 198)],
        ),
    ]

    for idx, (slug, tiers) in enumerate(builders, start=1):
        im = render_tiers_to_magenta(tiers, grass_canvas, stone_strip, seed=idx)
        out_p = WORK / f"draft_{slug}.png"
        im.save(out_p)
        print(f"Built {out_p} ({im.size})")


if __name__ == "__main__":
    main()
