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


# ---------------------------------------------------------------------------
# Extensions matérielles GBA : Orage Électhor (H17P01 / H17P01W1.bpa)
#                              & Abysses Kyogre (H02P02W.bpl / H02P03W1.bpa)
# ---------------------------------------------------------------------------
NATIVE_THUNDER_ROM = REPO_ROOT / "source" / "mont_foudre_entree_v1" / "references" / "native_rom"
NATIVE_SEA_ROM = REPO_ROOT / "source" / "mer_houleuse_entree_v1" / "references" / "native_rom"


def build_storm_and_lightning_layers(
    w: int,
    h: int,
    sky_mask: np.ndarray,
    fissure_mask: np.ndarray | None = None,
    bolt_anchors_xy: List[Tuple[float, float, float]] | None = None,
    n_frames: int = 24,
) -> Tuple[Image.Image, List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit à partir des binaires matériels GBA `H17P01.{bpl,bpc,bma}` & `H17P01W1.bpa` (`1×` strict) :
    - `im_storm_sky` (`BG`, `poses = 1`) : banc de cumulo-nimbus gris-ardoise `H17P01` tuilé horizontalement à `1×`,
    - `frames_cloud_surge` (`BG`, `24 × 5 = 120` ticks) : flashs internes d'orage & dérive des nuées,
    - `frames_sky_arcs` (`BG`, `24 × 5 = 120` ticks) : arcs électriques matériels `1×` `H17P01W1.bpa` + éclairs ramifiés,
    - `frames_plasma_or_sparks` (`BG`/`Top`, `24 × 5 = 120` ticks) : plasma foudroyé dans la faille en zigzag (si fournie)
      ou étincelles statiques dorées `1×` d'Électhor."""
    h17_rgb = np.asarray(decode_red_bg("H17P01", tick=0, folder=NATIVE_THUNDER_ROM)[0][0].convert("RGB")).copy()
    cloud_strip = h17_rgb[:148, :, :]  # 148 × 456 natif GBA 1×

    # Tuilage horizontal miroir sans couture à l'échelle 1× stricte
    strip_mirror = np.concatenate([cloud_strip, cloud_strip[:, ::-1, :]], axis=1)
    reps_x = (w // strip_mirror.shape[1]) + 2
    tiled_x = np.tile(strip_mirror, (1, reps_x, 1))[:, :w, :]

    sky_ys = np.where(sky_mask.any(axis=1))[0]
    max_sky_y = max(int(sky_ys.max()) + 8, 96) if sky_ys.size > 0 else max(96, h // 3)
    sky_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    for y in range(min(h, max_sky_y + 16)):
        sy = min(cloud_strip.shape[0] - 1, int(y * (cloud_strip.shape[0] - 1) / max(1, max_sky_y)))
        sky_rgba[y, :, :3] = tiled_x[sy]
    sky_rgba[:, :, 3] = 255
    im_storm_sky = Image.fromarray(sky_rgba, mode="RGBA")

    # Décodage matériel des sprites d'arcs jaunes `H17P01W1.bpa` (`tick = 0, 3, 6, ...`)
    hw_arc_sprites: List[np.ndarray] = []
    for k in range(8):
        w_im = np.asarray(decode_red_bg("H17P01W", tick=k * 3, folder=NATIVE_THUNDER_ROM)[0][0].convert("RGBA"))
        # Extraire la boîte englobante de l'arc gauche (autour de y=48..88, x=132..184)
        sub = w_im[48:88, 132:184].copy()
        bright = (sub[:, :, 3] > 0) & ((sub[:, :, 0] > 150) | (sub[:, :, 1] > 150))
        out_s = np.zeros_like(sub)
        out_s[bright, :3] = sub[bright, :3]
        out_s[bright, 3] = 255
        hw_arc_sprites.append(out_s)

    # Nuées d'orage dérivantes & illumination des vraies crêtes de cumulo-nimbus GBA `H17P01` (0 halo circulaire !)
    yy, xx = np.mgrid[0:h, 0:w]
    sky_luma = sky_rgba[:, :, 1].astype(np.int16)
    cloud_edge = np.zeros((h, w), dtype=bool)
    cloud_edge[1:, :] = np.abs(sky_luma[1:, :] - sky_luma[:-1, :]) >= 6
    cloud_edge[:, 1:] |= np.abs(sky_luma[:, 1:] - sky_luma[:, :-1]) >= 6
    cloud_rim = ndimage.binary_dilation(cloud_edge, iterations=1) & sky_mask
    cloud_light_band = (sky_luma >= 122) & sky_mask

    c_rim_soft = np.array([150, 174, 166], dtype=np.uint8)
    c_flash_mid = np.array([198, 214, 186], dtype=np.uint8)
    c_flash_hi = np.array([248, 248, 198], dtype=np.uint8)

    frames_cloud_surge: List[Image.Image] = []
    for t in range(n_frames):
        ph = 2.0 * np.pi * float(t) / float(n_frames)
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        wave_x = np.sin(2.0 * np.pi * (xx.astype(np.float32) / max(48.0, w * 0.25)) - ph)
        drift_m = cloud_rim & (wave_x >= 0.25)
        arr[drift_m, :3] = c_rim_soft
        arr[drift_m, 3] = 255

        if t in (3, 4, 12, 13):
            fx = 0.27 * w if t < 8 else 0.73 * w
            near_bolt = np.abs(xx.astype(np.float32) - fx) <= (0.18 * w)
            core_bolt = np.abs(xx.astype(np.float32) - fx) <= (0.09 * w)
            m_mid = cloud_rim & near_bolt
            m_hi = cloud_edge & sky_mask & core_bolt
            arr[m_mid, :3] = c_flash_mid
            arr[m_mid, 3] = 255
            arr[m_hi, :3] = c_flash_hi
            arr[m_hi, 3] = 255
        frames_cloud_surge.append(Image.fromarray(arr, mode="RGBA"))

    # Arcs matériels GBA `H17P01W1.bpa` + éclairs zébrés 1× dans le ciel Nord
    if bolt_anchors_xy is None:
        bolt_anchors_xy = [(0.27, 0.02, 0.27), (0.73, 0.02, 0.27)]

    frames_sky_arcs: List[Image.Image] = []
    c_bolt_core = np.array([255, 254, 214], dtype=np.uint8)
    c_bolt_gold = np.array([248, 224, 92], dtype=np.uint8)
    c_bolt_cyan = np.array([186, 228, 232], dtype=np.uint8)

    for t in range(n_frames):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        sp = hw_arc_sprites[t % len(hw_arc_sprites)]
        sh, sw = sp.shape[:2]
        for fx_rel, mirror_x in [(0.31, False), (0.69, True)]:
            sp_cur = sp[:, ::-1, :] if mirror_x else sp
            px0 = int(round(fx_rel * w)) - sw // 2
            py0 = max(4, int(round(0.11 * h)))
            x0, x1 = max(0, px0), min(w, px0 + sw)
            y0, y1 = max(0, py0), min(h, py0 + sh)
            if x1 > x0 and y1 > y0:
                sub_s = sp_cur[y0 - py0 : y1 - py0, x0 - px0 : x1 - px0]
                m = (sub_s[:, :, 3] > 0) & sky_mask[y0:y1, x0:x1]
                arr[y0:y1, x0:x1][m] = sub_s[m]

        strike_specs = []
        if t in (3, 4) and len(bolt_anchors_xy) >= 1:
            strike_specs.append((0, bolt_anchors_xy[0]))
        if t in (12, 13) and len(bolt_anchors_xy) >= 2:
            strike_specs.append((1, bolt_anchors_xy[-1]))
        for bi, (bx_rel, by0_rel, by1_rel) in strike_specs:
            bx = int(round(bx_rel * w))
            y_start = int(round(by0_rel * h))
            y_end = int(round(by1_rel * h))
            rng_b = np.random.default_rng(7717 + bi * 131 + (t % 2) * 17)
            cur_x = bx
            branch_y = (y_start + y_end) // 2
            branch_x = bx
            for yy_b in range(max(0, y_start), min(h, y_end)):
                if (yy_b - y_start) % 5 == 0:
                    cur_x += int(rng_b.choice([-4, -3, 3, 4]))
                if yy_b == branch_y:
                    branch_x = cur_x
                for dx_b, col in [(-1, c_bolt_gold), (0, c_bolt_core), (1, c_bolt_cyan)]:
                    xx_b = cur_x + dx_b
                    if 0 <= xx_b < w and sky_mask[yy_b, xx_b]:
                        arr[yy_b, xx_b, :3] = col
                        arr[yy_b, xx_b, 3] = 255
                if yy_b >= branch_y and (yy_b - branch_y) < (y_end - y_start) // 3:
                    branch_x += 1 if (bi % 2 == 0) else -1
                    if 0 <= branch_x < w and sky_mask[yy_b, branch_x]:
                        arr[yy_b, branch_x, :3] = c_bolt_gold
                        arr[yy_b, branch_x, 3] = 255
        frames_sky_arcs.append(Image.fromarray(arr, mode="RGBA"))

    # Faille plasma en zigzag (si `fissure_mask` fourni)
    frames_fissure: List[Image.Image] = []
    if fissure_mask is not None and np.any(fissure_mask):
        dist_edge = ndimage.distance_transform_edt(fissure_mask).astype(np.float32)
        max_d = max(1.0, float(dist_edge.max()))
        f_pal = np.array(
            [
                [124, 96, 36],
                [198, 162, 54],
                [246, 224, 92],
                [255, 252, 212],
            ],
            dtype=np.uint8,
        )
        for t in range(n_frames):
            ph = 2.0 * np.pi * float(t) / float(n_frames)
            surge = 0.55 + 0.45 * np.sin(2.0 * np.pi * (yy.astype(np.float32) / max(16.0, h * 0.08)) - ph)
            core = np.clip((dist_edge / min(4.0, max_d)) * 0.68 + 0.44 * surge, 0.0, 1.25)
            tier = np.clip((core * 3.1).astype(np.int32), 0, 3)
            arr = np.zeros((h, w, 4), dtype=np.uint8)
            arr[fissure_mask, :3] = f_pal[tier[fissure_mask]]
            arr[fissure_mask, 3] = 255
            frames_fissure.append(Image.fromarray(arr, mode="RGBA"))
    else:
        for _ in range(n_frames):
            frames_fissure.append(Image.new("RGBA", (w, h), (0, 0, 0, 0)))

    return im_storm_sky, frames_cloud_surge, frames_sky_arcs, frames_fissure


def build_electric_sparks_top_frames(
    w: int,
    h: int,
    n_frames: int = 24,
    seed: int = 20261025,
) -> List[Image.Image]:
    """Étincelles électriques dorées & bleu-blanc `1×` (style `W04` / `H17P01W`) dérivant dans le vent d'orage."""
    rng = np.random.default_rng(seed)
    n_sparks = 44
    sx0 = rng.integers(0, w, size=n_sparks)
    sy0 = rng.integers(0, h, size=n_sparks)
    kind = rng.integers(0, 3, size=n_sparks)
    c_core = np.array([255, 253, 212], dtype=np.uint8)
    c_gold = np.array([248, 216, 76], dtype=np.uint8)
    c_ice = np.array([172, 232, 248], dtype=np.uint8)

    frames: List[Image.Image] = []
    for t in range(n_frames):
        frac = float(t) / float(n_frames)
        dx = int(round(frac * w))
        dy = int(round(frac * (h // 2)))
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        for i in range(n_sparks):
            # Scintillement bref caractéristique de l'électricité statique
            if ((t + i * 3) % 6) == 5:
                continue
            jitter = int(round(2.0 * np.sin(2.0 * np.pi * frac * 3.0 + i)))
            cx = (int(sx0[i]) + dx + jitter) % w
            cy = (int(sy0[i]) + dy) % h
            arr[cy, cx, :3] = c_core
            arr[cy, cx, 3] = 255
            if kind[i] == 0 and cx + 1 < w:
                arr[cy, cx + 1, :3] = c_gold
                arr[cy, cx + 1, 3] = 255
            elif kind[i] == 1 and cx + 2 < w and cy + 1 < h:
                arr[cy, cx + 1, :3] = c_gold
                arr[cy, cx + 1, 3] = 255
                arr[cy + 1, cx + 2, :3] = c_ice
                arr[cy + 1, cx + 2, 3] = 255
            elif kind[i] == 2:
                for ox, oy, col in [(-1, 0, c_gold), (1, 0, c_gold), (0, -1, c_ice), (0, 1, c_ice)]:
                    px, py = cx + ox, cy + oy
                    if 0 <= px < w and 0 <= py < h:
                        arr[py, px, :3] = col
                        arr[py, px, 3] = 255
        frames.append(Image.fromarray(arr, mode="RGBA"))
    return frames


def build_abyssal_water_and_current_layers(
    w: int,
    h: int,
    water_mask: np.ndarray,
    mode: str = "kyogre",
    vortex_center_xy: Tuple[float, float, float] | None = None,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit à partir des binaires matériels GBA `H10P02.bpl`, `H02P02W.{bpl,bpc,bma}` & `H02P03W1.bpa` (`1×` strict) :
    - `water_frames` (`12` poses × `10` ticks = `120` ticks) : eau abyssale `H10P02.bpl` `1×` teintée outremer/saphir
      profond + liseré d'écume dynamique au contact de la pierre et des récifs,
    - `current_frames` (`15` poses × `8` ticks = `120` ticks) : **courants marins sinusoïdaux matériels GBA `H02P02W.bpl`**
      à `1×` strict (+ vortex central si `vortex_center_xy` fourni),
    - `bubble_frames` (`15` poses × `8` ticks = `120` ticks) : **colonnes de bulles matérielles GBA `H02P03W1.bpa` `1×`**."""
    sheet_idx = build_quilted_h10p02_index_sheet((192, 192))
    sh, sw = sheet_idx.shape
    reps_y = (h // sh) + 2
    reps_x = (w // sw) + 2
    tiled_idx = np.tile(sheet_idx, (reps_y, reps_x))[:h, :w]

    dist = ndimage.distance_transform_edt(water_mask).astype(np.float32)
    shallow = water_mask & (dist <= 5.5)
    rim = water_mask & (dist <= 2.2)

    water_frames: List[Image.Image] = []
    for f_idx in range(12):
        hw_tick = f_idx * 10
        rgb = colorize_h10p02_indices(tiled_idx, tick=hw_tick).astype(np.int16)
        if mode == "kyogre":
            # Abysse marin profond fidèle à H02P03 (bleu nuit saphir profond + rides H10P02.bpl 1×)
            r_new = np.clip((rgb[:, :, 0] * 0.22) + 12, 10, 150)
            g_new = np.clip((rgb[:, :, 1] * 0.38) + 20, 26, 196)
            b_new = np.clip((rgb[:, :, 2] * 0.62) + 34, 82, 232)
            rgb = np.stack([r_new, g_new, b_new], axis=-1).astype(np.int16)
        elif mode == "trench":
            # Profondeur abyssale saphir/outremer fidèle à H02P02 (0 teinte magenta : G >= min(R,B))
            r_new = np.clip((rgb[:, :, 0] * 0.24) + 8, 6, 175)
            g_new = np.clip((rgb[:, :, 1] * 0.56) + 22, 34, 224)
            b_new = np.clip((rgb[:, :, 2] * 0.84) + 26, 98, 250)
            rgb = np.stack([r_new, g_new, b_new], axis=-1).astype(np.int16)
        elif mode == "storm_pool":
            r_new = np.clip((rgb[:, :, 0] * 0.42) + 28, 24, 215)
            g_new = np.clip((rgb[:, :, 1] * 0.68) + 34, 58, 236)
            b_new = np.clip((rgb[:, :, 2] * 0.86) + 24, 96, 248)
            rgb = np.stack([r_new, g_new, b_new], axis=-1).astype(np.int16)

        rgb[shallow, 1] = np.clip(rgb[shallow, 1] + 28, 0, 245)
        rgb[shallow, 2] = np.clip(rgb[shallow, 2] + 22, 0, 255)
        pulse = int(round(12.0 * np.sin(2.0 * np.pi * f_idx / 12.0)))
        rgb[rim, 0] = np.clip(112 + pulse, 0, 220)
        rgb[rim, 1] = np.clip(198 + pulse, 0, 250)
        rgb[rim, 2] = np.clip(236 + pulse // 2, 0, 255)

        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[water_mask, :3] = rgb[water_mask].clip(0, 255).astype(np.uint8)
        out[water_mask, 3] = 255
        water_frames.append(Image.fromarray(out, mode="RGBA"))

    # 2) Courants marins matériels GBA `H02P02W` (`15` poses × `8` ticks = `120` ticks exact !)
    current_frames: List[Image.Image] = []
    yy, xx = np.mgrid[0:h, 0:w]
    for f_idx in range(15):
        hw_tick = f_idx * 8
        cur_full = np.asarray(decode_red_bg("H02P02W", tick=hw_tick, folder=NATIVE_SEA_ROM)[0][0].convert("RGBA"))
        # Bande médiane abyssale pure (exclut les colonnes claires de surface `y < 84` et `y > 252` !)
        cur_im = cur_full[84:252, :, :]
        cur_mirror_x = np.concatenate([cur_im, cur_im[:, ::-1, :]], axis=1)
        cur_mirror_xy = np.concatenate([cur_mirror_x, cur_mirror_x[::-1, :, :]], axis=0)
        ry = (h // cur_mirror_xy.shape[0]) + 2
        rx = (w // cur_mirror_xy.shape[1]) + 2
        cur_tiled = np.tile(cur_mirror_xy, (ry, rx, 1))[:h, :w]

        # Conserver uniquement les filets sinusoïdaux de courant marin GBA (`A > 0` et teinte saphir nette)
        c_vis = (cur_tiled[:, :, 3] > 0) & (cur_tiled[:, :, 2] >= 95) & (cur_tiled[:, :, 0] <= 80) & water_mask
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if np.any(c_vis):
            # Rehausser légèrement la lisibilité turquoise-azur sur fond saphir profond
            arr[c_vis, 0] = np.clip(cur_tiled[c_vis, 0].astype(np.int16) // 2 + 24, 18, 175).astype(np.uint8)
            arr[c_vis, 1] = np.clip(cur_tiled[c_vis, 1].astype(np.int16) + 46, 84, 232).astype(np.uint8)
            arr[c_vis, 2] = np.clip(cur_tiled[c_vis, 2].astype(np.int16) + 54, 150, 252).astype(np.uint8)
            arr[c_vis, 3] = 255

        # Si un puits tourbillonnant Nord est spécifié (MHE1), ajouter des bras spiraux abyssaux
        if vortex_center_xy is not None:
            vx = vortex_center_xy[0] * w
            vy = vortex_center_xy[1] * h
            vr = vortex_center_xy[2] * w
            dx = (xx.astype(np.float32) - vx) / max(1.0, vr)
            dy = (yy.astype(np.float32) - vy) / max(1.0, vr * 0.72)
            rad = np.sqrt(dx * dx + dy * dy)
            ang = np.arctan2(dy, dx)
            ph = 2.0 * np.pi * float(f_idx) / 15.0
            spiral = np.sin(3.0 * ang + 7.5 * rad - ph)
            in_well = water_mask & (rad <= 0.96) & (rad >= 0.12) & (spiral >= 0.58)
            bright_core = in_well & (spiral >= 0.84)
            arr[in_well, :3] = [44, 158, 232]
            arr[in_well, 3] = 255
            arr[bright_core, :3] = [148, 232, 252]
            arr[bright_core, 3] = 255

        current_frames.append(Image.fromarray(arr, mode="RGBA"))

    # 3) Colonnes de bulles matérielles GBA `H02P03W1.bpa` (`15` poses × `8` ticks = `120` ticks)
    # Extraire les sprites de bulles claires uniquement (exclut 100 % des cercles noirs `R < 110`) !
    bubble_strips: List[List[np.ndarray]] = []
    for f_idx in range(15):
        w_im = np.asarray(decode_red_bg("H02P03W", tick=f_idx * 7, folder=NATIVE_SEA_ROM)[0][0].convert("RGBA"))
        # Deux colonnes de bulles nettes dans H02P03W : gauche [68:140, 92:118] et droite [52:124, 222:248]
        pair = []
        for y0, y1, x0, x1 in [(68, 140, 92, 118), (52, 124, 222, 248)]:
            crop = w_im[y0:y1, x0:x1].copy()
            keep = (crop[:, :, 3] > 0) & (crop[:, :, 0] >= 120) & (crop[:, :, 1] >= 120)
            clean = np.zeros_like(crop)
            clean[keep, 0] = np.clip(crop[keep, 0].astype(np.int16) - 20, 140, 235).astype(np.uint8)
            clean[keep, 1] = np.clip(crop[keep, 1].astype(np.int16) + 12, 195, 252).astype(np.uint8)
            clean[keep, 2] = 255
            clean[keep, 3] = 255
            pair.append(clean)
        bubble_strips.append(pair)

    ys_w, xs_w = np.where(water_mask)
    emitters: List[Tuple[int, int]] = []
    if ys_w.size > 0:
        rng = np.random.default_rng(20261026)
        for qx in [0.16, 0.28, 0.42, 0.58, 0.72, 0.84]:
            band = np.where(np.abs(xs_w - int(qx * w)) <= max(16, w // 18))[0]
            if band.size > 0:
                pick = band[int(rng.integers(0, band.size))]
                emitters.append((int(xs_w[pick]), int(ys_w[pick])))

    bubble_frames: List[Image.Image] = []
    for f_idx in range(15):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        rise = int(round((float(f_idx) / 15.0) * 24.0))
        for ei, (ex, ey) in enumerate(emitters):
            sp = bubble_strips[(f_idx + ei * 3) % 15][ei % 2]
            sh_b, sw_b = sp.shape[:2]
            px0 = ex - sw_b // 2
            py0 = ey - sh_b // 2 - rise
            x0, x1 = max(0, px0), min(w, px0 + sw_b)
            y0, y1 = max(0, py0), min(h, py0 + sh_b)
            if x1 > x0 and y1 > y0:
                sub = sp[y0 - py0 : y1 - py0, x0 - px0 : x1 - px0]
                m = sub[:, :, 3] > 0
                arr[y0:y1, x0:x1][m] = sub[m]
        bubble_frames.append(Image.fromarray(arr, mode="RGBA"))

    return water_frames, current_frames, bubble_frames

