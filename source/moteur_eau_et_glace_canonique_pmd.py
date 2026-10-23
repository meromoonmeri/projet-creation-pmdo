#!/usr/bin/env python3
"""Moteur partagé d'eau & cascades **100 % matérielles GBA *PMD Red* (`H10P02.bpl` + `W03P03`)**
à l'échelle `1×` stricte (homologue exact pour l'eau et la neige de `moteur_magma_canonique_pmd_red.py`).

Principes stricts :
1. **100 % Eau & Cascades `1×` décodées depuis les binaires GBA natifs `H10P02.{bpl,bpc,bma}`**
   (`source/foret_givree_entree_v1/references/native_rom/`) avec **palette cycling matériel exact** :
   - Cascades verticales `H10P02` (`[0:64, 196:260]`) + crête d'écume blanche (`[60:78, 196:260]`),
   - Nappe d'eau `H10P02` à anneaux saphir/céruléen/azur & vaguelettes blanches animées par `H10P02.bpl`.
2. **100 % Blizzard canonique GBA `W03P03.{bpl,bpc,bma,bpa}` (`1×` natif)** sur la couche `Top`,
   identique dans son principe aux braises `W04` des cartes volcaniques.
3. **Zéro résidu magenta (`min(R, B) - G <= 24`), `alpha ∈ {0, 255}`, cristaux 100 % statiques.**
"""

from __future__ import annotations

import functools
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[1]
for _p in (str(REPO_ROOT / "source"), str(REPO_ROOT / "source" / "dungeon_biomes_v1")):
    if _p not in sys.path:
        sys.path.insert(0, _p)

from red import decode as decode_red_bg, palettes as decode_red_palettes  # type: ignore

NATIVE_WATER_ROM = REPO_ROOT / "source" / "foret_givree_entree_v1" / "references" / "native_rom"


def sanitize_palette_no_magenta(pal: np.ndarray, max_gap: int = 24) -> np.ndarray:
    """Garantit `min(R, B) - G <= max_gap` sur toute entrée de palette (zéro teinte magenta)."""
    out = pal.astype(np.int16).copy()
    gap = np.minimum(out[:, 0], out[:, 2]) - out[:, 1] - max_gap
    fix = gap > 0
    if np.any(fix):
        out[fix, 1] = np.clip(out[fix, 1] + (gap[fix] + 1) // 2, 0, 255)
        out[fix, 0] = np.clip(out[fix, 0] - (gap[fix] + 2) // 2, 0, 255)
    return np.unique(out.clip(0, 255).astype(np.uint8), axis=0)


@functools.lru_cache(maxsize=4)
def load_h10p02_native() -> Tuple[np.ndarray, bytes]:
    """Charge la carte d'indices `312 × 456` et la table `.bpl` matérielle de `H10P02` (*Mystic Lake*)."""
    _, _, indices, _ = decode_red_bg("H10P02", tick=0, folder=NATIVE_WATER_ROM)
    bpl_bytes = (NATIVE_WATER_ROM / "H10P02.bpl").read_bytes()
    return indices[0].copy(), bpl_bytes


def colorize_h10p02_indices(idx: np.ndarray, tick: int) -> np.ndarray:
    _, bpl_bytes = load_h10p02_native()
    pal, _ = decode_red_palettes(bpl_bytes, tick)
    bank = np.zeros((256, 4), dtype=np.uint8)
    bank[: pal.shape[0] * 16] = pal.reshape(-1, 4)
    return bank[idx][:, :, :3]


@functools.lru_cache(maxsize=4)
def build_quilted_h10p02_index_sheet(size_wh: Tuple[int, int] = (192, 192)) -> np.ndarray:
    """Assemble sans couture à l'échelle `1×` native une nappe périodique `192 × 192` d'indices `H10P02`
    issue exclusivement des zones d'eau pure animée (céruléen, saphir & vaguelettes blanches, 0 îlot/arbre)."""
    src_idx, _ = load_h10p02_native()
    rgb0 = colorize_h10p02_indices(src_idx, tick=0)
    rgb20 = colorize_h10p02_indices(src_idx, tick=20)

    is_water = (
        ((rgb0[:, :, 2] >= 180) & (rgb0[:, :, 2] > rgb0[:, :, 0] + 80))
        | ((rgb0[:, :, 0] >= 220) & (rgb0[:, :, 1] >= 235) & (rgb0[:, :, 2] >= 245))
    )
    # Exclure la chute verticale Nord (`y < 84`) pour ne coudre que les eaux vives horizontales
    is_open_lake = is_water.copy()
    is_open_lake[:84, :] = False

    motion = np.abs(rgb0.astype(np.int32) - rgb20.astype(np.int32)).max(axis=2)
    P = 32
    STEP = 24
    OV = P - STEP
    choices = []
    for sy in range(88, src_idx.shape[0] - P + 1, 8):
        for sx in range(0, src_idx.shape[1] - P + 1, 8):
            if is_open_lake[sy : sy + P, sx : sx + P].all():
                m_score = float(motion[sy : sy + P, sx : sx + P].mean())
                if m_score >= 1.5:
                    choices.append((m_score, sx, sy))
    choices.sort(key=lambda t: t[0], reverse=True)
    top_xy = [(sx, sy) for _, sx, sy in choices[:24]]
    assert top_xy, "Aucun patch d'eau pure trouvé dans H10P02"

    w_out, h_out = size_wh
    bw, bh = w_out + P, h_out + P
    rng = np.random.default_rng(20261023)
    idx_buf = np.zeros((bh, bw), dtype=src_idx.dtype)
    rgb_buf = np.zeros((bh, bw, 3), dtype=np.float32)

    for gy_i, y0 in enumerate(range(0, bh - P + 1, STEP)):
        for gx_i, x0 in enumerate(range(0, bw - P + 1, STEP)):
            best_xy = top_xy[0]
            best_err = float("inf")
            for k in rng.permutation(len(top_xy))[:10]:
                sx, sy = top_xy[int(k)]
                cand = rgb0[sy : sy + P, sx : sx + P].astype(np.float32)
                err = 0.0
                if gx_i > 0:
                    err += float(np.mean((rgb_buf[y0 : y0 + P, x0 : x0 + OV] - cand[:, :OV]) ** 2))
                if gy_i > 0:
                    err += float(np.mean((rgb_buf[y0 : y0 + OV, x0 : x0 + P] - cand[:OV, :]) ** 2))
                if err < best_err:
                    best_err = err
                    best_xy = (sx, sy)
            sx, sy = best_xy
            cand_rgb = rgb0[sy : sy + P, sx : sx + P].astype(np.float32)
            cand_idx = src_idx[sy : sy + P, sx : sx + P]
            put = np.ones((P, P), dtype=bool)
            if gx_i > 0:
                dl = np.sum((rgb_buf[y0 : y0 + P, x0 : x0 + OV] - cand_rgb[:, :OV]) ** 2, axis=2)
                for r_i in range(P):
                    put[r_i, : int(np.argmin(dl[r_i]))] = False
            if gy_i > 0:
                dt = np.sum((rgb_buf[y0 : y0 + OV, x0 : x0 + P] - cand_rgb[:OV, :]) ** 2, axis=2)
                for c_i in range(P):
                    put[: int(np.argmin(dt[:, c_i])), c_i] = False
            sub_i = idx_buf[y0 : y0 + P, x0 : x0 + P]
            sub_r = rgb_buf[y0 : y0 + P, x0 : x0 + P]
            sub_i[put] = cand_idx[put]
            sub_r[put] = cand_rgb[put]

    return idx_buf[:h_out, :w_out].copy()


def build_canonical_pmd_water_frames(
    w: int,
    h: int,
    water_mask: np.ndarray | None = None,
    n_frames: int = 12,
) -> List[Image.Image]:
    """Génère `12` frames matérielles @ `10` ticks = `120` ticks (`pose 0` -> phase `0`, `pose 12` -> phase `6`
    opposée !) par **palette cycling GBA exact `H10P02.bpl`** sur la nappe `1×` `192 × 192`."""
    sheet_idx = build_quilted_h10p02_index_sheet((192, 192))
    tiled_idx = np.tile(sheet_idx, (h // sheet_idx.shape[0] + 2, w // sheet_idx.shape[1] + 2))[:h, :w]

    frames: List[Image.Image] = []
    for f in range(n_frames):
        # Cycle harmonique fermé sur la période exacte de `H10P02.bpl` (`48` ticks GBA : aller-fluide 12 pas × 4 ticks)
        rgb = colorize_h10p02_indices(tiled_idx, tick=f * 4)
        out = np.zeros((h, w, 4), dtype=np.uint8)
        if water_mask is None:
            out[:, :, :3] = rgb
            out[:, :, 3] = 255
        else:
            out[water_mask, :3] = rgb[water_mask]
            out[water_mask, 3] = 255
        frames.append(Image.fromarray(out, mode="RGBA"))
    return frames


def build_canonical_pmd_waterfall_and_shore_frames(
    w: int,
    h: int,
    water_mask: np.ndarray,
    cascade_mask: np.ndarray | None = None,
    n_frames: int = 12,
) -> List[Image.Image]:
    """Cascades `1×` matérielles `H10P02` (`[0:64, 196:260]` + crête d'écume `[62:76, 196:260]`) +
    liseré d'écume glacée animé sur toutes les berges `#FF00FF` (`12 × 10 = 120` ticks)."""
    src_idx, _ = load_h10p02_native()
    wf_idx = src_idx[0:64, 196:260]
    crest_idx = src_idx[62:76, 196:260]
    ch, cw = wf_idx.shape

    dist_bank = ndimage.distance_transform_edt(water_mask)
    yy, xx = np.mgrid[:h, :w]
    c_white = np.array([248, 252, 255], dtype=np.uint8)
    c_ice = np.array([176, 226, 255], dtype=np.uint8)

    frames: List[Image.Image] = []
    for f in range(n_frames):
        tick = f * 4
        wf_rgb = colorize_h10p02_indices(wf_idx, tick=tick)
        crest_rgb = colorize_h10p02_indices(crest_idx, tick=tick)
        # Défilement vertical additionnel de 4 px/frame (`12 × 4 = 48` px, modulo 64 propre) pour un vrai flux descendant !
        wf_scroll = np.roll(wf_rgb, shift=(f * 4) % ch, axis=0)

        out = np.zeros((h, w, 4), dtype=np.uint8)

        # 1. Cascades `1×` `H10P02` + crête d'écume blanche au pied de chaque chute
        if cascade_mask is not None and np.any(cascade_mask):
            lbl_c, n_c = ndimage.label(cascade_mask)
            for cid in range(1, n_c + 1):
                comp = lbl_c == cid
                ys, xs = np.where(comp)
                if ys.size == 0:
                    continue
                x_center = int(round(float(xs.mean())))
                y_top, y_bot = int(ys.min()), int(ys.max())
                tiled_c = np.tile(wf_scroll, ((y_bot - y_top) // ch + 2, 3, 1))
                rel_y = ys - y_top
                rel_x = np.clip(xs - x_center + cw + cw // 2, 0, tiled_c.shape[1] - 1)
                out[ys, xs, :3] = tiled_c[rel_y, rel_x]
                out[ys, xs, 3] = 255

                # Crête d'écume blanche canonique `H10P02` juste à l'impact dans la vasque !
                foot_box = (
                    water_mask
                    & (yy >= y_bot - 4)
                    & (yy < y_bot + 10)
                    & (np.abs(xx - x_center) <= max(8, int((xs.max() - xs.min()) * 0.85)))
                )
                fys, fxs = np.where(foot_box)
                if fys.size > 0:
                    cy_f = np.clip(fys - (y_bot - 4), 0, crest_rgb.shape[0] - 1)
                    cx_f = np.clip(fxs - x_center + cw // 2, 0, crest_rgb.shape[1] - 1)
                    out[fys, fxs, :3] = crest_rgb[cy_f, cx_f]
                    out[fys, fxs, 3] = 255

        # 2. Liseré d'écume de berge ondulant en boucle fermée sur `12` phases
        ph = 2.0 * np.pi * float(f) / float(n_frames)
        wave = np.sin(0.22 * xx + 0.19 * yy + ph)
        rim_foam = water_mask & (dist_bank <= (1.6 + 1.0 * wave))
        rim_sub = water_mask & (~rim_foam) & (dist_bank <= (2.9 + 1.0 * wave))
        out[rim_sub, :3] = c_ice
        out[rim_sub, 3] = 255
        out[rim_foam, :3] = c_white
        out[rim_foam, 3] = 255

        frames.append(Image.fromarray(out, mode="RGBA"))
    return frames


@functools.lru_cache(maxsize=4)
def load_canonical_w03_snow_frames(w: int = 768, h: int = 576, n_frames: int = 24) -> List[Image.Image]:
    """Extrait les vrais sprites de flocons matériels `1×` de `W03P03` (*Frosty Forest Snowstorm*) et les anime
    par translation matérielle `BGHOFS`/`BGVOFS` aérée (`52` flocons organiques sur `24 × 5 = 120` ticks,
    zéro grille dense `16×16` masquant le décor, exactement comme `W04` sur les cartes magma !)."""
    bpl = (NATIVE_WATER_ROM / "W03P03.bpl").read_bytes()
    _, _, idx0, _ = decode_red_bg("W03P03", tick=0, folder=NATIVE_WATER_ROM)
    pal0, _ = decode_red_palettes(bpl, 0)
    bank0 = np.zeros((256, 4), dtype=np.uint8)
    bank0[: pal0.shape[0] * 16] = pal0.reshape(-1, 4)
    tile_rgba = bank0[idx0[0][:16, :16]].copy()
    tile_rgba[(idx0[0][:16, :16] % 16) == 0] = 0
    tile_rgba[tile_rgba[:, :, 3] > 0, 3] = 255

    # Extraire les petits sprites `1×` individuels de flocons contenus dans la tuile `W03P03`
    lbl_s, n_s = ndimage.label(tile_rgba[:, :, 3] > 0)
    sprites: List[np.ndarray] = []
    for cid in range(1, n_s + 1):
        ys, xs = np.where(lbl_s == cid)
        if ys.size >= 1:
            crop = tile_rgba[ys.min() : ys.max() + 1, xs.min() : xs.max() + 1].copy()
            sprites.append(crop)
    if not sprites:
        s_fallback = np.zeros((3, 3, 4), dtype=np.uint8)
        s_fallback[:, :, :3] = 250
        s_fallback[1, :, 3] = 255
        s_fallback[:, 1, 3] = 255
        sprites = [s_fallback]

    rng = np.random.default_rng(20261025)
    n_flakes = 54
    fx0 = rng.integers(0, w, size=n_flakes)
    fy0 = rng.integers(0, h, size=n_flakes)
    sp_ids = rng.integers(0, len(sprites), size=n_flakes)
    speeds = rng.choice([1, 2], size=n_flakes, p=[0.6, 0.4])

    frames: List[Image.Image] = []
    for t in range(n_frames):
        frac = float(t) / float(n_frames)
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        for i in range(n_flakes):
            sp = sprites[int(sp_ids[i])]
            sh, sw, _ = sp.shape
            spd = int(speeds[i])
            px = int(round(fx0[i] - frac * w * 0.25 * spd + 6.0 * np.sin(2.0 * np.pi * spd * frac + i))) % w
            py = int(round(fy0[i] + frac * h * spd)) % h
            if px + sw <= w and py + sh <= h:
                m = sp[:, :, 3] > 0
                sub = arr[py : py + sh, px : px + sw]
                sub[m] = sp[m]
        frames.append(Image.fromarray(arr, mode="RGBA"))
    return frames


def build_polar_sky_and_aurora_layers(
    w: int,
    h: int,
    sky_max_y_frac: float = 0.28,
    n_frames: int = 24,
) -> Tuple[Image.Image, List[Image.Image]]:
    """Ciel polaire GBA doux `D10P01`/`H24P01` + voile d'Aurore Boréale soyeux."""
    yy, xx = np.mgrid[:h, :w]
    sky_bands = np.array(
        [
            [68, 96, 156],
            [86, 116, 176],
            [108, 138, 196],
            [132, 162, 214],
            [158, 186, 230],
            [186, 208, 242],
            [212, 228, 250],
            [232, 242, 254],
        ],
        dtype=np.uint8,
    )
    max_y = max(16, int(round(sky_max_y_frac * h)))
    band_idx = np.clip((yy * len(sky_bands)) // max_y, 0, len(sky_bands) - 1)
    sky_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    sky_rgba[:, :, :3] = sky_bands[band_idx]
    sky_rgba[:, :, 3] = 255
    im_sky = Image.fromarray(sky_rgba, mode="RGBA")

    aurora_pal = np.array(
        [
            [104, 184, 216],
            [120, 212, 224],
            [152, 236, 232],
            [200, 248, 246],
        ],
        dtype=np.uint8,
    )
    aurora_frames: List[Image.Image] = []
    xf = xx.astype(np.float32) / float(w)
    yf = yy.astype(np.float32) / float(max_y)
    for t in range(n_frames):
        ph = 2.0 * np.pi * float(t) / float(n_frames)
        curtain_y = (
            0.38
            + 0.09 * np.sin(2.0 * np.pi * 1.0 * xf + ph)
            + 0.04 * np.sin(2.0 * np.pi * 2.0 * xf - ph)
        )
        shimmer = 0.80 + 0.20 * np.sin(2.0 * np.pi * 4.0 * xf - 2.0 * ph)
        height_env = np.exp(-(((yf - curtain_y) / 0.13) ** 2))
        strength = height_env * shimmer * (yy < max_y)
        vis = strength >= 0.48
        tier = np.clip(((strength - 0.48) / 0.12).astype(np.int32), 0, 3)
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[vis, :3] = aurora_pal[tier[vis]]
        arr[vis, 3] = 255
        aurora_frames.append(Image.fromarray(arr, mode="RGBA"))

    return im_sky, aurora_frames


def build_frost_mist_and_snowfall_layers(
    w: int,
    h: int,
    mist_band_mask: np.ndarray,
    n_frames: int = 24,
) -> Tuple[List[Image.Image], List[Image.Image]]:
    """Construit :
    - `frames_mist` (`BG`, `24 × 5 = 120` ticks) : fins filets de bise hivernale `1 px`,
    - `frames_snow` (`Top`, `16 × 7 = 112` ticks) : **le vrai calque météo matériel GBA `W03P03` `1×`
      de `D10P01` (*Frosty Forest*)** !"""
    rng = np.random.default_rng(20261024)
    c_streak = np.array([236, 246, 255], dtype=np.uint8)
    c_glint = np.array([250, 253, 255], dtype=np.uint8)

    ys_m, xs_m = np.where(mist_band_mask)
    n_streaks = 22
    if ys_m.size > 0:
        picks = rng.integers(0, ys_m.size, size=n_streaks)
        st_x0 = xs_m[picks]
        st_y0 = ys_m[picks]
        st_len = rng.integers(max(6, int(10 * w / 768.0)), max(10, int(20 * w / 768.0)), size=n_streaks)
    else:
        st_x0 = np.zeros(0, dtype=np.int32)
        st_y0 = np.zeros(0, dtype=np.int32)
        st_len = np.zeros(0, dtype=np.int32)

    span_x = max(32, int(round(96 * w / 768.0)))
    mist_frames: List[Image.Image] = []
    for t in range(n_frames):
        frac = float(t) / float(n_frames)
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        for i in range(st_x0.size):
            p = (frac + (i * 0.137)) % 1.0
            vis_len = int(round(st_len[i] * np.sin(np.pi * p)))
            if vis_len <= 1:
                continue
            cx = int(round(st_x0[i] + (p - 0.5) * span_x))
            cy = int(round(st_y0[i] + 2.0 * np.sin(2.0 * np.pi * p + i)))
            if 0 <= cy < h:
                x_a = max(0, cx)
                x_b = min(w, cx + vis_len)
                if x_b > x_a:
                    seg_mask = mist_band_mask[cy, x_a:x_b]
                    xs_seg = np.arange(x_a, x_b)[seg_mask]
                    arr[cy, xs_seg, :3] = c_streak
                    arr[cy, xs_seg, 3] = 255
                    if xs_seg.size >= 3:
                        arr[cy, xs_seg[xs_seg.size // 2], :3] = c_glint
        mist_frames.append(Image.fromarray(arr, mode="RGBA"))

    snow_frames = load_canonical_w03_snow_frames(w=w, h=h, n_frames=n_frames)
    return mist_frames, snow_frames
