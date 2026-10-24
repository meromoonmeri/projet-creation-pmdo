#!/usr/bin/env python3
"""Moteur partagé multicalque PMDO 0.8.12.0 pour le duo **Fosse d'Argent (*Silver Trench*, Lugia)** :
  - `FAE1` (*Fosse d'Argent — Entrée Engloutie*) : `1×` natif GBA *PMD Red* `H01P03` (*Serene Sea*)
    + courants & éclats caustiques natifs *Metano Town* (`Metano_Town_River_Animation_1..4.tile`,
    `Metano_Town_River_Sparkles.tile`) + les 5 faisceaux sous-marins officiels `H02P02W`.
  - `FAS1` (*Fosse d'Argent — Sanctuaire Abyssal de Lugia*) : plateau-autel englouti `#FF00FF` quantifié
    `96` couleurs `MEDIANCUT` (`dither=NONE`) + grand vortex abyssal `H02P02` (*Deep-Sea Current*,
    sanctuaire officiel de Lugia au 99e sous-sol de la Fosse d'Argent) + eau animée 4 phases *Metano Town*
    + les 5 rayons sous-marins verticaux officiels `H02P02W`.
"""

from __future__ import annotations

import math
from functools import lru_cache
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

from source.moteur_cyclones_cylindriques_unova import (
    decode_pmdo_tile,
    extract_metano_water_and_flower_assets,
    sanitize_rgba_binary,
)
from source.moteur_forets_pmd_red import (
    _downsample_non_mixing,
    _q8_u8,
    _sanitize_rgb_no_magenta,
    extract_native_metano_river_profiles,
)
from source.moteur_gba_pmd_red_natif import (
    PURE_MAGENTA,
    load_gba_map_bundle,
    make_layer_rgba,
    render_gba_native,
    resize_nearest_mask,
    resize_nearest_rgba,
)

REPO_ROOT = Path(__file__).resolve().parent.parent
W_CANON = 768
H_CANON = 576
TILE_SIZE = 8


def clean_magenta_cutout_strict(raw_rgb: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    """Détoure le fond `#FF00FF` et absorbe toute frange anti-aliasée rose/violette en bordure de fosse."""
    r = raw_rgb[:, :, 0].astype(np.int32)
    g = raw_rgb[:, :, 1].astype(np.int32)
    b = raw_rgb[:, :, 2].astype(np.int32)

    pure_seed = (r >= 235) & (g <= 28) & (b >= 235)
    lbl, n_lbl = ndimage.label(pure_seed)
    bg_mask = np.zeros(raw_rgb.shape[:2], dtype=bool)
    for cid in range(1, n_lbl + 1):
        comp = lbl == cid
        if int(comp.sum()) >= 120:
            bg_mask |= comp

    # Absorption itérative des pixels de liseré demi-teinte rose/magenta adjacents au fond `#FF00FF`
    pinkish = ((np.minimum(r, b) - g) >= 14) | ((r >= 135) & (b >= 155) & ((r - g) >= 18))
    for _ in range(8):
        grown = ndimage.binary_dilation(bg_mask, iterations=1) & pinkish
        if np.array_equal(grown, bg_mask):
            break
        bg_mask = grown

    fg_mask = ~bg_mask
    # Supprime les poussières isolées (< 24 px) dans le gouffre
    lbl_fg, n_fg = ndimage.label(fg_mask)
    for cid in range(1, n_fg + 1):
        comp = lbl_fg == cid
        if int(comp.sum()) < 24:
            fg_mask[comp] = False
            bg_mask[comp] = True

    cleaned = raw_rgb.copy()
    cleaned[bg_mask] = PURE_MAGENTA
    cleaned = _sanitize_rgb_no_magenta(cleaned, fg_mask)
    return cleaned, fg_mask


def quantize_foreground_96_abyssal(fg_rgb: np.ndarray, fg_mask: np.ndarray) -> np.ndarray:
    """Quantifie le décor solide en `<= 96` couleurs `MEDIANCUT` (`dither=NONE`) + accents cyan bioluminescents."""
    out = fg_rgb.copy()
    if not np.any(fg_mask):
        return out

    # Remplace temporairement le fond par une ardoise neutre pour ne jamais polluer les boîtes MEDIANCUT avec #FF00FF
    work = fg_rgb.copy()
    work[~fg_mask] = np.array([40, 72, 112], dtype=np.uint8)
    pil_q = Image.fromarray(work, mode="RGB").quantize(
        colors=88,
        method=Image.Quantize.MEDIANCUT,
        dither=Image.Dither.NONE,
    ).convert("RGB")
    q_arr = np.asarray(pil_q, dtype=np.uint8).copy()

    # Préserve l'éclat vif des coraux/anémones bioluminescents (`H02P01` cyan/blanc-azur)
    r = fg_rgb[:, :, 0].astype(np.int32)
    g = fg_rgb[:, :, 1].astype(np.int32)
    b = fg_rgb[:, :, 2].astype(np.int32)
    glow_white = fg_mask & (g >= 224) & (b >= 236) & (r >= 184)
    glow_cyan = fg_mask & (~glow_white) & (g >= 188) & (b >= 220) & (r <= 96)
    glow_teal = fg_mask & (~glow_white) & (~glow_cyan) & (g >= 148) & (b >= 188) & (r <= 72)

    q_arr[glow_white] = np.array([224, 248, 255], dtype=np.uint8)
    q_arr[glow_cyan] = np.array([24, 216, 248], dtype=np.uint8)
    q_arr[glow_teal] = np.array([16, 168, 216], dtype=np.uint8)

    q_arr = _sanitize_rgb_no_magenta(q_arr, fg_mask)
    q_arr[~fg_mask] = PURE_MAGENTA
    return q_arr


@lru_cache(maxsize=4)
def build_metano_abyssal_water_4phases(w: int, h: int, tint_mode: str = "deep_trench") -> List[np.ndarray]:
    """Construit 4 phases `w × h × 3` d'eau sous-marine animée à partir des 4 planches natives
    `Metano_Town_River_Animation_1..4.tile` recalibrées dans la palette bleu-argent de la Fosse d'Argent."""
    eau_dir = REPO_ROOT / "source" / "eau_metano" / "natifs"
    # Découpe une tuile périodique pure d'eau animée depuis Metano_Town_River_Animation_1..4
    prof4 = extract_native_metano_river_profiles()  # (4, N_rows, 12, 3)
    n_rows = prof4.shape[1]

    # Étend horizontalement par symétrie douce sans couture (24 px de période X, n_rows de période Y)
    tile4 = np.concatenate([prof4, prof4[:, :, ::-1, :]], axis=2)  # (4, n_rows, 24, 3)
    rep_y = (h + n_rows - 1) // n_rows
    rep_x = (w + 23) // 24

    phases: List[np.ndarray] = []
    for k in range(4):
        tiled = np.tile(tile4[k], (rep_y, rep_x, 1))[:h, :w, :].astype(np.float32)
        lum = 0.22 * tiled[:, :, 0] + 0.50 * tiled[:, :, 1] + 0.28 * tiled[:, :, 2]
        norm = np.clip((lum - 95.0) / 115.0, 0.0, 1.0)
        if tint_mode == "serene_entrance":
            # Palette H01P03 : turquoise profond -> argent céruléen
            c_r = 12.0 + 38.0 * norm
            c_g = 86.0 + 78.0 * norm
            c_b = 136.0 + 68.0 * norm
        else:
            # Palette H02P02 : cobalt abyssal -> saphir argenté de Lugia
            c_r = 8.0 + 36.0 * norm
            c_g = 64.0 + 96.0 * norm
            c_b = 132.0 + 104.0 * norm
        rgb = _q8_u8(np.dstack([c_r, c_g, c_b]))
        rgb = _sanitize_rgb_no_magenta(rgb, np.ones((h, w), dtype=bool))
        phases.append(rgb)
    return phases


def build_metano_caustic_sparkles_frames(
    w: int,
    h: int,
    water_mask: np.ndarray,
    n_frames: int = 6,
    seed: int = 24901,
) -> List[Image.Image]:
    """Distribue les grappes natives `Metano_Town_River_Sparkles.tile` teintées cyan-argent dans `water_mask`."""
    assets = extract_metano_water_and_flower_assets()
    clusters: List[np.ndarray] = assets["sparkle_clusters"]  # type: ignore[assignment]
    eroded = ndimage.binary_erosion(water_mask, iterations=max(2, w // 192))
    ys, xs = np.where(eroded)

    rng = np.random.default_rng(seed)
    spots: List[Tuple[int, int, int, int]] = []
    if len(ys) > 0:
        n_pick = min(38, max(12, len(ys) // 900))
        chosen = rng.choice(len(ys), size=n_pick, replace=False)
        for idx in chosen:
            spots.append((int(xs[idx]), int(ys[idx]), int(rng.integers(0, len(clusters))), int(rng.integers(0, n_frames))))

    frames: List[Image.Image] = []
    for f in range(n_frames):
        canvas = np.zeros((h, w, 4), dtype=np.uint8)
        for sx, sy, c_idx, ph in spots:
            active_phase = (f + ph) % n_frames
            if active_phase >= 3:
                continue
            seq = clusters[c_idx % len(clusters)]
            spr = seq[active_phase % len(seq)] if isinstance(seq, list) else seq
            sh, sw = spr.shape[:2]
            y0, x0 = sy - sh // 2, sx - sw // 2
            if y0 < 2 or x0 < 2 or y0 + sh >= h - 2 or x0 + sw >= w - 2:
                continue
            sub_m = eroded[y0 : y0 + sh, x0 : x0 + sw] & (spr[:, :, 3] > 128)
            if not np.any(sub_m):
                continue
            sub_c = canvas[y0 : y0 + sh, x0 : x0 + sw]
            # Teinte argent-cyan abyssale sans magenta
            col = np.array([176, 240, 255, 255] if active_phase == 1 else [88, 200, 240, 255], dtype=np.uint8)
            sub_c[sub_m] = col
        frames.append(Image.fromarray(sanitize_rgba_binary(canvas)))
    return frames


def build_h02p02_vortex_frames(
    w: int,
    h: int,
    trench_mask: np.ndarray,
    n_frames: int = 8,
) -> Tuple[Image.Image, List[Image.Image]]:
    """Construit le fond bathyal statique (`00`) et le grand vortex du Courant Marin Profond (`01`, `H02P02` + eau Metano 4 phases)
    autour du sanctuaire englouti de Lugia (`<= 12 000` tuiles uniques)."""
    nat_vortex, nat_pm, _ = render_gba_native("H02P02", phase=None, bpa_frame=0)
    vortex_scaled = resize_nearest_rgba(nat_vortex, w, h)[:, :, :3].astype(np.float32)
    pm_scaled = resize_nearest_mask(nat_pm == 0, w, h)

    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    # Calque 00 : fond bathyal cobalt profond continu (statique `poses = 1`)
    depth_t = np.clip(yy / max(1.0, float(h - 1)), 0.0, 1.0)
    bg_r = 4.0 + 8.0 * depth_t
    bg_g = 44.0 + 38.0 * depth_t
    bg_b = 104.0 + 52.0 * depth_t
    bg_rgb = _sanitize_rgb_no_magenta(_q8_u8(np.dstack([bg_r, bg_g, bg_b])), trench_mask)
    im_00_abyss = make_layer_rgba(bg_rgb, trench_mask)

    # Calque 01 : ondes concentriques du Courant Marin Profond `H02P02` + eau 4 phases Metano Town
    metano_4 = build_metano_abyssal_water_4phases(w, h, tint_mode="deep_trench")
    cx, cy = w * 0.50, h * 0.44
    rx = np.maximum(1.0, (xx - cx) / (w * 0.46))
    ry = np.maximum(1e-4, (yy - cy) / (h * 0.42))
    ell_r = np.sqrt(((xx - cx) / (w * 0.46)) ** 2 + ((yy - cy) / (h * 0.42)) ** 2)
    ang = np.arctan2(yy - cy, xx - cx)

    frames_01: List[Image.Image] = []
    for f in range(n_frames):
        theta = 2.0 * math.pi * f / float(n_frames)
        met = metano_4[f % 4].astype(np.float32)
        # Double spirale hydro-argentée inspirée directement de `H02P02` (*Deep-Sea Current*)
        swirl = np.sin(8.0 * ell_r - theta + 2.0 * np.sin(ang))
        crest = swirl > 0.36
        mid_wave = (~crest) & (swirl > -0.18)

        mix = 0.58 * vortex_scaled + 0.42 * met
        # Assombrit légèrement la haute fosse Nord (`slot 0` de H02P02) pour la profondeur bathyale
        mix[pm_scaled] = 0.65 * mix[pm_scaled] + 0.35 * bg_rgb[pm_scaled].astype(np.float32)

        out = mix.copy()
        out[mid_wave] = np.clip(mix[mid_wave] + np.array([6.0, 22.0, 32.0], dtype=np.float32), 0.0, 255.0)
        out[crest] = np.clip(mix[crest] + np.array([22.0, 52.0, 68.0], dtype=np.float32), 0.0, 255.0)

        q_out = _sanitize_rgb_no_magenta(_q8_u8(out), trench_mask)
        # Seules les bandes du courant (`mid_wave | crest`) sont opaques sur `01`, laissant voir `00` dans les creux !
        vis = trench_mask & (mid_wave | crest)
        frames_01.append(make_layer_rgba(q_out, vis))

    return im_00_abyss, frames_01


def build_h02p02w_light_shafts_top(
    w: int,
    h: int,
    canopy_top_rgba: np.ndarray | None,
    n_frames: int = 8,
    shaft_alpha: int = 46,
) -> List[Image.Image]:
    """Assemble sur la couche `09 Top` les **5 faisceaux lumineux sous-marins officiels Chunsoft `H02P02W`**
    (`MAP_FRIEND_AREA_DEEP_SEA_CURRENT` weather layer) à faible opacité translucide + sommets `Top` + plancton argenté."""
    w_rgba, w_pm, _ = render_gba_native("H02P02W", phase=None, bpa_frame=0)
    shaft_mask_base = resize_nearest_mask(w_pm >= 0, w, h)
    shaft_rgb_base = resize_nearest_rgba(w_rgba, w, h)[:, :, :3]

    yy, xx = np.mgrid[:h, :w]
    # Atténuation verticale douce vers le bas de la fosse
    fade_y = np.clip(1.18 - yy.astype(np.float32) / float(h), 0.25, 1.0)

    rng = np.random.default_rng(24999)
    n_motes = 20
    mx0 = rng.integers(max(8, w // 16), max(16, w - w // 16), size=n_motes)
    my0 = rng.integers(max(8, h // 16), max(16, h - h // 12), size=n_motes)
    mph = rng.uniform(0.0, 2.0 * math.pi, size=n_motes)

    frames_top: List[Image.Image] = []
    for f in range(n_frames):
        theta = 2.0 * math.pi * f / float(n_frames)
        dx = int(round(max(2.0, w * 0.006) * math.cos(theta)))
        m_shift = np.roll(shaft_mask_base, shift=dx, axis=1)
        rgb_shift = np.roll(shaft_rgb_base, shift=dx, axis=1)
        if dx > 0:
            m_shift[:, :dx] = False
        elif dx < 0:
            m_shift[:, dx:] = False

        arr = np.zeros((h, w, 4), dtype=np.uint8)
        breath = 0.88 + 0.12 * math.cos(theta)
        alpha_map = np.clip(np.round(shaft_alpha * fade_y * breath), 18, 72).astype(np.uint8)

        # Cœur lumineux argent-azur issu de H02P02W (zéro magenta)
        s_rgb = _sanitize_rgb_no_magenta(
            np.clip(rgb_shift.astype(np.int16) + np.array([28, 84, 96], dtype=np.int16), 0, 255).astype(np.uint8),
            m_shift,
        )
        arr[m_shift, :3] = s_rgb[m_shift]
        arr[m_shift, 3] = alpha_map[m_shift]

        # Plancton & fines bulles d'argent d'Aéroblast dérivant lentement vers la surface
        for i in range(n_motes):
            px = int(round(mx0[i] + max(2.0, w * 0.008) * math.sin(theta + mph[i])))
            py = int((my0[i] - int(round((f / float(n_frames)) * max(16, h // 12)))) % (h - 12)) + 6
            if 4 <= px < w - 4 and 4 <= py < h - 4:
                arr[py, px] = (208, 248, 255, 220)
                if px + 1 < w - 4 and math.cos(theta + mph[i]) > 0.25:
                    arr[py, px + 1] = (112, 216, 248, 190)

        # Couronnes de colonnes en surplomb (alpha 255 net) par-dessus les rayons si fournies
        if canopy_top_rgba is not None:
            can_op = canopy_top_rgba[:, :, 3] >= 128
            arr[can_op] = canopy_top_rgba[can_op]

        frames_top.append(Image.fromarray(arr, mode="RGBA"))
    return frames_top
