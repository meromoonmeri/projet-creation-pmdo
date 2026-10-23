"""Moteurs pixel-art multicalques canoniques PMD (768×576, boucle maîtresse 120 ticks) pour :
  1. Zekrom — Tiny Meadow / Plaine Tonnerre -> Montagne à Grotte (MFE1) &
     Sommet au cœur de la Tornade de Nuages Noirs Électriques (MFA1, rotation cyclonique 360°).
  2. Dialga Primal — Tour du Temps : Flèche Brisée (TTE1, réf. D30P32A) &
     Pinacle des Rouages du Temps (TTA1, réf. D30P41A).
  3. Palkia — Faille Spatiale : Canyon Dimensionnel (FSE1, réf. D46P41A) &
     Cœur du Spatio-Rift (FSA1, réf. D45P42A).

Invariants garantis :
  - 0 gradient flou : tramage ordonné Bayer 2×2 sur palettes GBA/NDS quantifiées nettes.
  - alpha strictement binaire {0, 255}.
  - Harmoniques temporelles impaires (w ∈ {1, 3}) sur 24 frames (5 ticks = 120 ticks)
    garantissant à la fois une boucle 100 % sans couture (23 -> 0) ET pose 0 != pose 12.
"""
from __future__ import annotations

from pathlib import Path
from typing import List, Tuple

import numpy as np
from scipy import ndimage

from moteur_eau_et_glace_canonique_pmd import decode_red_bg


def load_h17_lightning_sprites(rom_dir: Path) -> List[np.ndarray]:
    """Extrait à l'échelle 1× stricte les 8 poses d'arcs électriques GBA H17P01W1.bpa."""
    hw_arc_sprites: List[np.ndarray] = []
    for k in range(8):
        w_im = np.asarray(decode_red_bg("H17P01W", tick=k * 3, folder=rom_dir)[0][0].convert("RGBA"))
        sub = w_im[48:88, 132:184].copy()
        bright = (sub[:, :, 3] > 0) & ((sub[:, :, 0] > 150) | (sub[:, :, 1] > 150))
        out_s = np.zeros_like(sub)
        out_s[bright, :3] = sub[bright, :3]
        out_s[bright, 3] = 255
        hw_arc_sprites.append(out_s)
    return hw_arc_sprites


BAYER2 = np.array([[0.0, 0.5], [0.75, 0.25]], dtype=np.float32)


def bayer_field(h: int, w: int) -> np.ndarray:
    return np.tile(BAYER2, ((h + 1) // 2, (w + 1) // 2))[:h, :w]


def clean_brut_magenta_fringe(rgb_in: np.ndarray, mag_mask: np.ndarray) -> np.ndarray:
    """Purge toute frange demi-teinte rose/violette/magenta en bordure du masque #FF00FF
    en propageant le plus proche pixel pierre/herbe non-magenta valide.
    """
    rgb = rgb_in.copy()
    r = rgb[:, :, 0].astype(np.int32)
    g = rgb[:, :, 1].astype(np.int32)
    b = rgb[:, :, 2].astype(np.int32)
    near_mag = ndimage.binary_dilation(mag_mask, iterations=5) & (~mag_mask)
    pink_global = (~mag_mask) & ((r - g >= 52) & (b - g >= 52) & (r >= 95) & (b >= 95))
    pink_border = near_mag & ((r - g >= 18) & (b - g >= 18))
    pink_fringe = pink_global | pink_border
    if np.any(pink_fringe):
        valid = (~mag_mask) & (~pink_fringe)
        _, idx = ndimage.distance_transform_edt(~valid, return_indices=True)
        rgb[pink_fringe] = rgb[idx[0][pink_fringe], idx[1][pink_fringe]]
    return rgb


def palette_lookup_dithered(t_norm: np.ndarray, palette_rgb: np.ndarray, dither_amp: float = 0.72) -> np.ndarray:
    """Projette un champ scalaire [0, 1] sur une palette pixel-art discrète avec Bayer 2×2."""
    h, w = t_norm.shape
    n = len(palette_rgb)
    bf = bayer_field(h, w) - 0.375
    scaled = np.clip(t_norm, 0.0, 0.9999) * (n - 1) + bf * dither_amp
    idx = np.clip(np.rint(scaled).astype(np.int32), 0, n - 1)
    return palette_rgb[idx]


def draw_bolt_segment_rgba(
    canvas: np.ndarray,
    pts: List[Tuple[int, int]],
    core_rgba: Tuple[int, int, int, int] = (255, 255, 255, 255),
    mid_rgba: Tuple[int, int, int, int] = (88, 198, 255, 255),
    halo_rgba: Tuple[int, int, int, int] = (24, 96, 248, 255),
    thickness: int = 1,
) -> np.ndarray:
    """Trace un éclair pixel-art net à 3 niveaux (halo / cœur cyan / âme blanche) sans anti-aliasing mou."""
    h, w = canvas.shape[:2]
    bolt_mask = np.zeros((h, w), dtype=bool)
    for (x0, y0), (x1, y1) in zip(pts[:-1], pts[1:]):
        steps = max(abs(x1 - x0), abs(y1 - y0), 1)
        xs = np.rint(np.linspace(x0, x1, steps + 1)).astype(np.int32)
        ys = np.rint(np.linspace(y0, y1, steps + 1)).astype(np.int32)
        ok = (xs >= 0) & (xs < w) & (ys >= 0) & (ys < h)
        bolt_mask[ys[ok], xs[ok]] = True
    if not np.any(bolt_mask):
        return bolt_mask
    core_m = ndimage.binary_dilation(bolt_mask, iterations=thickness) if thickness > 0 else bolt_mask
    mid_m = ndimage.binary_dilation(core_m, iterations=1)
    halo_m = ndimage.binary_dilation(mid_m, iterations=1)
    canvas[halo_m] = halo_rgba
    canvas[mid_m] = mid_rgba
    canvas[core_m] = core_rgba
    return halo_m


def repalette_sprite_to_zekrom_blue(sp_rgba: np.ndarray) -> np.ndarray:
    """Convertit un sprite d'arc électrique GBA H17P01W1.bpa (jaune/blanc) en bleu Charge Foudre Zekrom."""
    out = sp_rgba.copy()
    vis = out[:, :, 3] == 255
    if not np.any(vis):
        return out
    lum = (
        0.30 * out[:, :, 0].astype(np.float32)
        + 0.55 * out[:, :, 1].astype(np.float32)
        + 0.15 * out[:, :, 2].astype(np.float32)
    )
    out[vis & (lum < 130)] = (24, 96, 244, 255)
    out[vis & (lum >= 130) & (lum < 195)] = (66, 176, 255, 255)
    out[vis & (lum >= 195) & (lum < 236)] = (158, 232, 255, 255)
    out[vis & (lum >= 236)] = (255, 255, 255, 255)
    return out


# ==============================================================================
# 1. ZEKROM — TORNADE CYCLONIQUE 3D DE NUAGES NOIRS ÉLECTRIQUES (MFA1 & MFE1)
# ==============================================================================

ZEKROM_ABYSS_PAL = np.array([
    [5, 8, 16],
    [9, 15, 29],
    [15, 25, 46],
    [23, 38, 68],
    [33, 55, 96],
    [46, 78, 132],
], dtype=np.uint8)

ZEKROM_CLOUD_PAL = np.array([
    [4, 7, 15],       # 0 : contour noir d'encre GBA
    [9, 14, 26],      # 1 : cœur d'ombre cumulonimbus noir profond
    [17, 26, 46],     # 2 : masse nuageuse noire d'orage
    [29, 43, 72],     # 3 : bourgeon d'orage ardoise-cobalt
    [45, 67, 108],    # 4 : flanc spiralé éclairé
    [68, 106, 168],   # 5 : liseré pré-ionisé bleu acier
    [96, 168, 244],   # 6 : frange électrique bleu Charge Foudre Zekrom
    [186, 236, 255],  # 7 : crête illuminée blanc-cyan Zekrom
], dtype=np.uint8)


def build_zekrom_black_tornado_layers(
    h: int,
    w: int,
    vortex_mask: np.ndarray,
    rom_dir: Path,
    center_xy: Tuple[float, float] = (384.0, 248.0),
    rx_scale: float = 1.0,
    ry_scale: float = 1.28,
    n_frames: int = 24,
) -> Tuple[List[np.ndarray], List[np.ndarray], List[np.ndarray], List[np.ndarray]]:
    """Construit 4 calques animés 24 poses (5 ticks = 120 ticks) d'une véritable
    tornade cyclonique 360° de nuages noirs électriques autour du sommet de Zekrom :
      - L0 : Abysse tourbillonnaire profond (opaque sur vortex_mask)
      - L1 : Muraille cyclonique 3D de cumulonimbus noirs en rotation continue 360°
      - L2 : Arcs électriques bleus Zekrom (Charge Foudre + sprites GBA H17P01W1.bpa bleutés)
             illuminant les rebords festonnés des nuages noirs
      - L8 (Top) : Anneau cyclonique supérieur en surplomb sur le pourtour externe de l'écran
    """
    cx, cy = center_xy
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    dx = (xx - cx) * rx_scale
    dy = (yy - cy) * ry_scale
    rr = np.hypot(dx, dy) + 1.0
    theta = np.arctan2(dy, dx)  # [-pi, pi]
    log_r = np.log(rr / 90.0)

    sprites_raw = load_h17_lightning_sprites(rom_dir)
    sprites_blue = [repalette_sprite_to_zekrom_blue(s) for s in sprites_raw]

    # Masque périphérique "Top" : couronne externe de l'entonnoir en surplomb (ne couvre jamais l'arène !)
    outer_rim_mask = vortex_mask & (rr >= 286.0)

    abyss_frames: List[np.ndarray] = []
    cloud_frames: List[np.ndarray] = []
    bolt_frames: List[np.ndarray] = []
    canopy_frames: List[np.ndarray] = []

    rng_bolts = np.random.default_rng(20260644)  # #644 Zekrom !
    # Pré-génère 12 éclairs radiaux/tangentiels qui tournent avec l'orage
    bolt_defs = []
    for k in range(12):
        base_ang = (2.0 * np.pi * k) / 12.0 + 0.21
        r_start = float(rng_bolts.uniform(198.0, 248.0))
        r_end = float(rng_bolts.uniform(315.0, 415.0))
        zig = rng_bolts.uniform(-0.11, 0.11, size=6).astype(np.float32)
        zig[0] = 0.0
        bolt_defs.append((base_ang, r_start, r_end, zig))

    for f in range(n_frames):
        ph1 = (2.0 * np.pi * 1.0 * f) / n_frames  # harmonique impaire w=1 -> pose 0 != pose 12 !
        ph3 = (2.0 * np.pi * 3.0 * f) / n_frames  # harmonique impaire w=3 -> pose 0 != pose 12 !

        # 1) Abysse cyclonique profond (L0 — paliers nets sans bruit haute fréquence : < 9 000 tuiles !)
        swirl_bg = (
            0.48
            + 0.28 * np.sin(3.0 * theta + 5.2 * log_r - ph1)
            + 0.16 * np.cos(5.0 * theta + 8.5 * log_r - ph3)
            + 0.14 * np.clip((rr - 150.0) / 260.0, 0.0, 1.0)
        )
        bg_rgb = palette_lookup_dithered(np.clip(swirl_bg, 0.0, 1.0), ZEKROM_ABYSS_PAL, dither_amp=0.0)
        f_abyss = np.zeros((h, w, 4), dtype=np.uint8)
        f_abyss[vortex_mask, :3] = bg_rgb[vortex_mask]
        f_abyss[vortex_mask, 3] = 255
        abyss_frames.append(f_abyss)

        # 2) Muraille cyclonique 3D serrée de cumulonimbus noirs en rotation 360° :
        #    - L1 : Muraille interne & médiane de l'œil du cyclone (rr < 300)
        #    - L8 (Top) : Muraille externe de l'entonnoir en surplomb (rr >= 286)
        #    Paliers pixel-art purs sans grain Bayer (dither_amp = 0.0) => contours rasoirs GBA ET < 18 000 tuiles !
        arm_main = np.sin(6.0 * theta + 14.5 * log_r - ph1)
        lobe_mid = 0.54 * np.sin(12.0 * theta + 20.0 * log_r - ph3)
        ring_wave = 0.56 * np.sin(17.0 * log_r + 3.0 * theta - ph1)
        density = arm_main + lobe_mid + ring_wave

        inner_zone = vortex_mask & (rr < 306.0)
        cloud_present = inner_zone & (density > -0.24)
        eye_prox = np.clip(1.0 - (rr - 155.0) / 225.0, 0.0, 1.0)
        crest = np.clip((density + 0.24) / 1.65, 0.0, 1.0)
        rim_inner = np.clip(1.0 - np.abs(density + 0.06) * 3.4, 0.0, 1.0) * (0.42 + 0.58 * eye_prox)
        pulse_zekrom = 0.5 + 0.5 * np.sin(ph3)
        shade_t = (
            0.08
            + 0.52 * crest
            + 0.42 * rim_inner * (0.68 + 0.32 * pulse_zekrom)
        )
        c_rgb = palette_lookup_dithered(np.clip(shade_t, 0.0, 0.94), ZEKROM_CLOUD_PAL, dither_amp=0.0)

        # Contour noir net GBA de 1 px autour de chaque banc nuageux spiralé
        eroded = ndimage.binary_erosion(cloud_present, iterations=1)
        outline = cloud_present & (~eroded)
        c_rgb[outline] = ZEKROM_CLOUD_PAL[0]

        f_cloud = np.zeros((h, w, 4), dtype=np.uint8)
        f_cloud[cloud_present, :3] = c_rgb[cloud_present]
        f_cloud[cloud_present, 3] = 255

        # 3) Arcs électriques bleus de Zekrom (L2) + flashs sur les rebords des nuages noirs !
        f_bolt = np.zeros((h, w, 4), dtype=np.uint8)
        lit_zone = np.zeros((h, w), dtype=bool)

        for k, (base_ang, r_s, r_e, zig) in enumerate(bolt_defs):
            # Chaque éclair s'allume 9 poses sur 24 pour que 4-5 éclairs bleus Zekrom zèbrent toujours la tornade !
            phase_k = (f - (k * 5)) % n_frames
            if phase_k < 9:
                ang_now = base_ang + ph1 * 0.65
                pts: List[Tuple[int, int]] = []
                for s_i in range(6):
                    u = s_i / 5.0
                    rk = r_s + (r_e - r_s) * u
                    ak = ang_now - 0.52 * u + float(zig[s_i]) * (1.0 if phase_k % 2 == 0 else -0.8)
                    px = int(round(cx + (rk * np.cos(ak)) / rx_scale))
                    py = int(round(cy + (rk * np.sin(ak)) / ry_scale))
                    pts.append((px, py))
                thick = 1 if phase_k in (0, 1) else 0
                bm = draw_bolt_segment_rgba(f_bolt, pts, thickness=thick)
                lit_zone |= ndimage.binary_dilation(bm, iterations=8)
                # Branche secondaire fourchue
                if phase_k in (0, 1, 2):
                    bx0, by0 = pts[2]
                    rk2 = r_s + (r_e - r_s) * 0.72
                    ak2 = ang_now - 0.22 + 0.19
                    bx1 = int(round(cx + (rk2 * np.cos(ak2)) / rx_scale))
                    by1 = int(round(cy + (rk2 * np.sin(ak2)) / ry_scale))
                    bm2 = draw_bolt_segment_rgba(
                        f_bolt,
                        [(bx0, by0), ((bx0 + bx1) // 2 + 5, (by0 + by1) // 2 - 4), (bx1, by1)],
                        thickness=0,
                    )
                    lit_zone |= ndimage.binary_dilation(bm2, iterations=5)

        # Sprites matériels GBA H17P01W1.bpa (1×) recolorisés bleu Zekrom en orbite dans l'entonnoir !
        if sprites_blue:
            for s_slot in range(8):
                sp = sprites_blue[(f + s_slot * 2) % len(sprites_blue)]
                sh, sw = sp.shape[:2]
                ang_s = (2.0 * np.pi * s_slot) / 8.0 + ph1
                rad_s = 225.0 + 46.0 * np.sin(ph3 + s_slot)
                sx = int(round(cx + (rad_s * np.cos(ang_s)) / rx_scale)) - sw // 2
                sy = int(round(cy + (rad_s * np.sin(ang_s)) / ry_scale)) - sh // 2
                x0, y0 = max(0, sx), max(0, sy)
                x1, y1 = min(w, sx + sw), min(h, sy + sh)
                if x1 > x0 and y1 > y0:
                    sub = sp[y0 - sy:y1 - sy, x0 - sx:x1 - sx]
                    m_sp = (sub[:, :, 3] == 255) & vortex_mask[y0:y1, x0:x1]
                    f_bolt[y0:y1, x0:x1][m_sp] = sub[m_sp]
                    lit_zone[y0:y1, x0:x1] |= ndimage.binary_dilation(m_sp, iterations=4)

        # Illumine uniquement le liseré festonné des nuages noirs proches d'un éclair (0 rectangle !)
        cloud_inner_rim = cloud_present & (~ndimage.binary_erosion(cloud_present, iterations=3))
        flash_rim = cloud_inner_rim & lit_zone & vortex_mask
        f_cloud[flash_rim, :3] = ZEKROM_CLOUD_PAL[7]
        f_cloud[flash_rim, 3] = 255
        # Verrouille le masque strictement à vortex_mask
        outside = ~vortex_mask
        f_bolt[outside] = 0
        cloud_frames.append(f_cloud)
        bolt_frames.append(f_bolt)

        # 4) Muraille externe en surplomb Top (L8 — prolonge les bras spiraux jusqu'aux coins de l'écran !)
        m_can = outer_rim_mask & (density > -0.20)
        f_can = np.zeros((h, w, 4), dtype=np.uint8)
        if np.any(m_can):
            can_rgb = palette_lookup_dithered(
                np.clip(shade_t * 0.78, 0.0, 0.78),
                ZEKROM_CLOUD_PAL,
                dither_amp=0.0,
            )
            can_edge = m_can & (~ndimage.binary_erosion(m_can, iterations=1))
            can_rgb[can_edge] = ZEKROM_CLOUD_PAL[0]
            can_lit = can_edge & lit_zone
            can_rgb[can_lit] = ZEKROM_CLOUD_PAL[6]
            f_can[m_can, :3] = can_rgb[m_can]
            f_can[m_can, 3] = 255
        canopy_frames.append(f_can)

    return abyss_frames, cloud_frames, bolt_frames, canopy_frames


# ==============================================================================
# 2. TOUR DU TEMPS — NUAGES TEMPORELS & BRÈCHES HURLE-TEMPS (TTE1 & TTA1)
# ==============================================================================

# Palette ambre/ocre exacte extraite de D30P32A / D30P42A (Tour du Temps — Flèche Brisée)
TEMPORAL_AMBER_PAL = np.array([
    [138, 128, 66],
    [158, 147, 78],
    [179, 168, 92],
    [200, 189, 108],
    [219, 209, 126],
    [234, 225, 148],
    [244, 238, 174],
], dtype=np.uint8)

# Palette écarlate/pourpre exacte extraite de D30P41A (Pinacle de Dialga Primal)
TEMPORAL_CRIMSON_PAL = np.array([
    [142, 56, 52],
    [166, 68, 63],
    [190, 81, 75],
    [208, 96, 89],
    [224, 114, 106],
    [237, 134, 124],
    [247, 158, 146],
], dtype=np.uint8)


def build_temporal_sky_and_rifts(
    h: int,
    w: int,
    sky_mask: np.ndarray,
    primal_crimson: bool,
    n_frames: int = 24,
) -> Tuple[List[np.ndarray], List[np.ndarray], List[np.ndarray]]:
    """Construit 3 calques animés 24 poses (5 ticks = 120 ticks) pour la Tour du Temps :
      - L0 : Ciel de temps paralysé et bancs de nuages stratifiés canoniques D30P32A / D30P41A
      - L1 : Brèches dimensionnelles Hurle-Temps (Roar of Time) cyan/émeraude ou écarlate/cyan
      - L9 (Top) : Poussières et éclats chronologiques suspendus dérivant lentement
    """
    pal = TEMPORAL_CRIMSON_PAL if primal_crimson else TEMPORAL_AMBER_PAL
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)

    sky_frames: List[np.ndarray] = []
    rift_frames: List[np.ndarray] = []
    dust_frames: List[np.ndarray] = []

    rng = np.random.default_rng(48301 if primal_crimson else 48300)  # #483 Dialga !
    motes = [
        (
            float(rng.uniform(0, w)),
            float(rng.uniform(0, h)),
            int(rng.choice([1, 3])),
            int(rng.choice([0, 1])),
        )
        for _ in range(95)
    ]

    rift_anchors = [
        (118, 112), (650, 108), (96, 318), (674, 332), (146, 486), (626, 476),
    ]

    for f in range(n_frames):
        ph1 = (2.0 * np.pi * 1.0 * f) / n_frames
        ph3 = (2.0 * np.pi * 3.0 * f) / n_frames
        shift_x1 = (w * f) / float(n_frames)

        # Bancs nuageux horizontaux festonnés fidèles aux nuages de D30P32A / D30P41A !
        band_y = np.sin(yy / 43.0)
        scallop = (
            0.34 * np.sin((2.0 * np.pi * (xx + shift_x1)) / 256.0)
            + 0.20 * np.cos((2.0 * np.pi * (xx - shift_x1)) / 128.0 + yy / 34.0)
            + 0.14 * np.sin(ph3 + yy / 26.0)
        )
        cloud_val = band_y + scallop
        # Zone de base unie exactement au ton médian D30P32A / D30P41A + nuages clairs sculptés
        base_tone = np.full((h, w), 0.34, dtype=np.float32)
        in_cloud = cloud_val > 0.28
        crest_t = np.clip((cloud_val - 0.28) / 0.95, 0.0, 1.0)
        # Ombre douce sous la base de chaque banc nuageux comme sur D30P41A.png !
        under_shadow = (cloud_val > 0.14) & (cloud_val <= 0.28)
        tone = base_tone.copy()
        tone[under_shadow] = 0.14
        tone[in_cloud] = 0.48 + 0.50 * crest_t[in_cloud]

        rgb = palette_lookup_dithered(tone, pal, dither_amp=0.42)
        f_sky = np.zeros((h, w, 4), dtype=np.uint8)
        f_sky[sky_mask, :3] = rgb[sky_mask]
        f_sky[sky_mask, 3] = 255
        sky_frames.append(f_sky)

        # Brèches temporelles Hurle-Temps (cyan diamant Dialga / émeraude Rouage du Temps)
        f_rift = np.zeros((h, w, 4), dtype=np.uint8)
        for idx_r, (rx0, ry0) in enumerate(rift_anchors):
            sub_t = (f + idx_r * 4) % n_frames
            if sub_t < 8:
                grow = 1.0 - abs(sub_t - 3.5) / 4.5
                half_len = max(8, int(round(36 * grow)))
                pts = [
                    (rx0 - half_len, ry0 - 6),
                    (rx0 - half_len // 3, ry0 + 4),
                    (rx0 + half_len // 3, ry0 - 3),
                    (rx0 + half_len, ry0 + 5),
                ]
                if primal_crimson:
                    draw_bolt_segment_rgba(
                        f_rift,
                        pts,
                        core_rgba=(255, 250, 255, 255),
                        mid_rgba=(120, 232, 255, 255),
                        halo_rgba=(228, 58, 84, 255),
                        thickness=0,
                    )
                else:
                    draw_bolt_segment_rgba(
                        f_rift,
                        pts,
                        core_rgba=(255, 255, 240, 255),
                        mid_rgba=(84, 242, 198, 255),
                        halo_rgba=(28, 152, 132, 255),
                        thickness=0,
                    )
        f_rift[~sky_mask] = 0
        rift_frames.append(f_rift)

        # Poussières de temps figé (Top)
        f_dust = np.zeros((h, w, 4), dtype=np.uint8)
        for mx, my, harm, big in motes:
            ang = ph1 if harm == 1 else ph3
            px = int(round(mx + 7.0 * np.sin(ang + mx * 0.03))) % w
            py = int(round(my + 5.0 * np.cos(ang + my * 0.04))) % h
            if sky_mask[py, px]:
                col = (146, 244, 255, 255) if primal_crimson else (196, 255, 218, 255)
                f_dust[py, px] = col
                if big and px + 1 < w and py + 1 < h:
                    f_dust[py, px + 1] = (255, 255, 255, 255)
        dust_frames.append(f_dust)

    return sky_frames, rift_frames, dust_frames


# ==============================================================================
# 3. FAILLE SPATIALE — COSMOS DISTORDU & PORTAIL SPATIO-RIFT DE PALKIA (FSE1 & FSA1)
# ==============================================================================

SPATIAL_COSMOS_PAL = np.array([
    [16, 11, 34],
    [26, 17, 54],
    [40, 25, 78],
    [60, 35, 108],
    [88, 48, 144],
    [126, 66, 184],
    [174, 96, 222],
    [226, 148, 250],
], dtype=np.uint8)

SPATIAL_PORTAL_PAL = np.array([
    [52, 26, 98],
    [92, 44, 154],
    [146, 72, 208],
    [204, 116, 244],
    [242, 178, 255],
    [255, 228, 255],
    [255, 255, 255],
], dtype=np.uint8)


def build_spatial_rift_layers(
    h: int,
    w: int,
    void_mask: np.ndarray,
    portal_mask: np.ndarray,
    portal_center_xy: Tuple[float, float],
    n_frames: int = 24,
) -> Tuple[List[np.ndarray], List[np.ndarray], List[np.ndarray], List[np.ndarray]]:
    """Construit 4 calques animés 24 poses (5 ticks = 120 ticks) pour la Faille Spatiale (Palkia) :
      - L0 : Cosmos dimensionnel distordu (ondes spatiales violettes/magenta + étoiles PMD 4 branches)
      - L1 : Déchirure aveuglante blanche-perle & magenta du portail Spatio-Rift au Nord (D45P42A)
      - L2 : Éclairs et anneaux d'onde Spatio-Rift roses/blancs traversant le vide
      - L9 (Top) : Éclats perle-magenta en lévitation gravitationnelle
    """
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    pcx, pcy = portal_center_xy
    pdx = (xx - pcx) * 0.82
    pdy = (yy - pcy) * 1.18
    prr = np.hypot(pdx, pdy) + 1.0
    ptheta = np.arctan2(pdy, pdx)

    # Cosmos nébuleux organique 256×192 px (zéro pois périodique, vraies nappes galactiques violettes !)
    rng = np.random.default_rng(48400)  # #484 Palkia !
    tw_p, th_p = 256, 192
    tile_stars = [
        (int(rng.integers(3, tw_p - 3)), int(rng.integers(3, th_p - 3)), int(rng.integers(0, 12)))
        for _ in range(44)
    ]
    shards = [
        (float(rng.uniform(0, w)), float(rng.uniform(0, h)), int(rng.choice([1, 3])))
        for _ in range(85)
    ]

    cosmos_frames: List[np.ndarray] = []
    portal_frames: List[np.ndarray] = []
    shock_frames: List[np.ndarray] = []
    shard_frames: List[np.ndarray] = []

    all_mag = void_mask | portal_mask
    ty_g, tx_g = np.mgrid[0:th_p, 0:tw_p].astype(np.float32)

    for f in range(n_frames):
        ph1 = (2.0 * np.pi * 1.0 * f) / n_frames
        ph3 = (2.0 * np.pi * 3.0 * f) / n_frames

        # Rubans nébuleux diagonaux continus (aucun quadrillage de ronds !)
        s_diag = tx_g / tw_p + ty_g / th_p + 0.09 * np.sin(2.0 * np.pi * (tx_g / tw_p - ty_g / th_p) + ph1)
        warp_tile = (
            0.22
            + 0.24 * np.sin(2.0 * np.pi * s_diag - ph1)
            + 0.14 * np.sin(4.0 * np.pi * s_diag + 2.0 * np.pi * (tx_g / tw_p) - ph3)
        )
        tile_rgb = palette_lookup_dithered(np.clip(warp_tile, 0.0, 0.62), SPATIAL_COSMOS_PAL, dither_amp=0.0)
        for sx, sy, s_off in tile_stars:
            twk = (f + s_off) % 12
            if twk < 6:
                tile_rgb[sy, sx] = (255, 245, 255)
                if twk in (1, 2):
                    for ox, oy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        tile_rgb[sy + oy, sx + ox] = (212, 162, 255)
            else:
                tile_rgb[sy, sx] = (150, 108, 224)
        cos_rgb = np.tile(tile_rgb, ((h + th_p - 1) // th_p, (w + tw_p - 1) // tw_p, 1))[:h, :w]
        f_cos = np.zeros((h, w, 4), dtype=np.uint8)
        f_cos[all_mag, :3] = cos_rgb[all_mag]
        f_cos[all_mag, 3] = 255
        cosmos_frames.append(f_cos)

        # 2) Déchirure blanche-magenta du portail Spatio-Rift au Nord (L1, D45P42A !)
        f_port = np.zeros((h, w, 4), dtype=np.uint8)
        if np.any(portal_mask):
            dist_in = ndimage.distance_transform_edt(portal_mask).astype(np.float32)
            max_d = max(float(dist_in.max()), 1.0)
            core_t = np.clip(dist_in / (max_d * 0.62), 0.0, 1.0)
            ripple = 0.16 * np.sin(5.0 * ptheta + prr / 9.0 - ph3) + 0.10 * np.sin(ph1)
            p_rgb = palette_lookup_dithered(
                np.clip(core_t + ripple, 0.0, 1.0),
                SPATIAL_PORTAL_PAL,
                dither_amp=0.0,
            )
            f_port[portal_mask, :3] = p_rgb[portal_mask]
            f_port[portal_mask, 3] = 255
        portal_frames.append(f_port)

        # 3) Éclairs dimensionnels Spatio-Rift roses/perle (L2 — zéro anneau géométrique artificiel !)
        f_shk = np.zeros((h, w, 4), dtype=np.uint8)
        for k in range(6):
            if (f + k * 4) % 12 < 5:
                ang_k = (2.0 * np.pi * k) / 6.0 + ph1 * 0.5
                cx_k = int(round(w * 0.5 + 250.0 * np.cos(ang_k)))
                cy_k = int(round(h * 0.5 + 185.0 * np.sin(ang_k)))
                pts = [
                    (cx_k - 22, cy_k - 10),
                    (cx_k - 5, cy_k + 4),
                    (cx_k + 9, cy_k - 5),
                    (cx_k + 24, cy_k + 9),
                ]
                draw_bolt_segment_rgba(
                    f_shk,
                    pts,
                    core_rgba=(255, 255, 255, 255),
                    mid_rgba=(248, 152, 255, 255),
                    halo_rgba=(150, 56, 224, 255),
                    thickness=0,
                )
        f_shk[~all_mag] = 0
        shock_frames.append(f_shk)

        # 4) Éclats perle-magenta en apesanteur (L9 Top)
        f_shd = np.zeros((h, w, 4), dtype=np.uint8)
        for mx, my, harm in shards:
            ang = ph1 if harm == 1 else ph3
            px = int(round(mx + 6.0 * np.cos(ang + my * 0.03))) % w
            py = int(round(my - 9.0 * np.sin(ang + mx * 0.02))) % h
            if all_mag[py, px]:
                f_shd[py, px] = (255, 196, 255, 255)
        shard_frames.append(f_shd)

    return cosmos_frames, portal_frames, shock_frames, shard_frames
