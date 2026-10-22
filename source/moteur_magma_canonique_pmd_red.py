#!/usr/bin/env python3
"""Moteur partagé de texture de magma canonique PMD Red (`H26P01` + `W04`)
et d'animation matérielle par **palette cycling GBA exact** (`H26P01.bpl`), couplé
à la découpe **magenta `#FF00FF`** des gouffres et des veines de magma dans la roche.

Principes stricts :
1. **100 % Texture Magma PMD Red Canonique à l'échelle `1×` native (`H26P01`)** :
   assemblage par couture à coût minimal sur la grille `8×8` à partir de tous les patchs
   natifs `48×48` de `H26P01` (rivières d'or, courants cramoisis et plaques de croûte sombre
   flottantes, zéro redimensionnement, zéro interpolation, zéro répétition visible).
2. **100 % Animation Palette Cycling Matérielle Canonique (`H26P01.bpl`)** :
   - `31` phases matérielles × `4` ticks (`124` ticks) sur les palettes `5, 6, 7, 8` de la lave ;
   - `8` phases matérielles × `3` ticks (`24` ticks) sur la palette `4` des colonnes / cascades
     de lave cylindriques canoniques `1×` (extraites propres avec leur bassin d'impact bouillonnant,
     sans aucun mini-volcan !) ;
   - `15` phases matérielles × `8` ticks (`120` ticks) sur la palette `0` d'incandescence des rives ;
   - `16` phases matérielles `.bpa` × `7` ticks (`112` ticks) sur les braises volcaniques `W04` (`Top`).
3. **Veines de Magma 100 % Magenta `#FF00FF`** :
   - Zéro résidu violet/prune (`B > G + 10`) toléré : tout pixel magenta ou anti-aliasé devient
     transparent (`alpha = 0`) et laisse transparaître le vrai magma canonique `H26P01` animé.
"""

from __future__ import annotations

import functools
import sys
from pathlib import Path
from typing import Dict, List, Sequence, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[1]
for p in (str(REPO_ROOT / "source"), str(REPO_ROOT / "source" / "dungeon_biomes_v1")):
    if p not in sys.path:
        sys.path.insert(0, p)

from red import decode as decode_red_bg, palettes as decode_red_palettes  # type: ignore

NATIVE_ROM_DIR = REPO_ROOT / "source" / "mine_magma_arene_v1" / "references" / "native_rom"
FALLBACK_ROM_DIR = Path("/tmp/pmd-red/data/map_bg")


def _rom_folder() -> Path:
    if (NATIVE_ROM_DIR / "H26P01.bpl").is_file():
        return NATIVE_ROM_DIR
    return FALLBACK_ROM_DIR


@functools.lru_cache(maxsize=8)
def load_h26p01_native() -> Tuple[np.ndarray, bytes]:
    folder = _rom_folder()
    _, _, indices, _ = decode_red_bg("H26P01", tick=0, folder=folder)
    bpl_bytes = (folder / "H26P01.bpl").read_bytes()
    return indices[0].copy(), bpl_bytes


def colorize_h26p01_indices(idx: np.ndarray, tick: int) -> np.ndarray:
    _, bpl_bytes = load_h26p01_native()
    pal, _ = decode_red_palettes(bpl_bytes, tick)
    bank = np.zeros((256, 4), dtype=np.uint8)
    bank[: pal.shape[0] * 16] = pal.reshape(-1, 4)
    return bank[idx]


@functools.lru_cache(maxsize=8)
def build_quilted_h26p01_index_sheet(
    w: int = 768,
    h: int = 576,
    pure_molten_only: bool = False,
) -> np.ndarray:
    """Assemble sans couture ni redimensionnement (`1×` natif strict) une nappe `h × w`
    d'indices `H26P01`.
    - `pure_molten_only=False` : mer caldeira complète (rivières d'or, courants cramoisis
      et îlots de croûte basaltique sombre `H26P01`).
    - `pure_molten_only=True`  : 100 % fleuves incandescents animés (`palettes 5, 6, 7, 8` >= 85 %),
      idéal sous les **veines rocheuses `#FF00FF`** pour qu'aucune veine ne tombe sur de la croûte éteinte !"""
    src_idx, _ = load_h26p01_native()
    src_rgb = colorize_h26p01_indices(src_idx, tick=0)[:, :, :3].astype(np.float32)

    valid_pals = np.isin(src_idx // 16, [0, 1, 2, 3, 5, 6, 7, 8, 9])
    anim_pals = np.isin(src_idx // 16, [5, 6, 7, 8])
    island_box = np.zeros_like(valid_pals)
    island_box[88:, 152:328] = True
    pure = valid_pals & (~island_box)

    P = 32 if pure_molten_only else 48
    STEP = 24 if pure_molten_only else 32
    OV = P - STEP
    rgb_mid = colorize_h26p01_indices(src_idx, tick=60)[:, :, :3].astype(np.float32)
    motion_map = np.abs(src_rgb - rgb_mid).max(axis=2)

    scored_choices: List[Tuple[float, int, int]] = []
    for sy in range(0, src_idx.shape[0] - P + 1, 8):
        for sx in range(0, src_idx.shape[1] - P + 1, 8):
            if pure[sy : sy + P, sx : sx + P].all():
                score = float(motion_map[sy : sy + P, sx : sx + P].mean()) + 0.35 * float(src_rgb[sy : sy + P, sx : sx + P, 0].mean())
                scored_choices.append((score, sx, sy))
    assert scored_choices, "Aucun patch valide dans H26P01"
    if pure_molten_only:
        scored_choices.sort(key=lambda t: t[0], reverse=True)
        choices: List[Tuple[int, int]] = [(sx, sy) for _, sx, sy in scored_choices[:28]]
    else:
        choices = [(sx, sy) for _, sx, sy in scored_choices]

    pad_w = max(w + P, 128)
    pad_h = max(h + P, 128)
    yy, xx = np.indices((P, P))
    coords = np.zeros((pad_h, pad_w), dtype=np.int32)
    rgb_buf = np.zeros((pad_h, pad_w, 3), dtype=np.float32)
    usage: Dict[Tuple[int, int], int] = {c: 0 for c in choices}
    rng = np.random.default_rng(20261022)

    def _min_seam(err: np.ndarray) -> np.ndarray:
        cost = err.copy()
        eh, ew = err.shape
        for ry in range(1, eh):
            cost[ry] += np.minimum.reduce(
                [np.r_[np.inf, cost[ry - 1, :-1]], cost[ry - 1], np.r_[cost[ry - 1, 1:], np.inf]]
            )
        path = np.empty(eh, dtype=int)
        path[-1] = int(cost[-1].argmin())
        for ry in range(eh - 2, -1, -1):
            lo = max(0, path[ry + 1] - 1)
            hi = min(ew, path[ry + 1] + 2)
            path[ry] = lo + int(cost[ry, lo:hi].argmin())
        return path

    last_row_choices: Dict[int, Tuple[int, int]] = {}
    prev_choice: Tuple[int, int] = (-999, -999)

    for y in range(0, pad_h - P + 1, STEP):
        for x in range(0, pad_w - P + 1, STEP):
            candidates = []
            above_c = last_row_choices.get(x, (-999, -999))
            for sx, sy in choices:
                tile = src_rgb[sy : sy + P, sx : sx + P]
                diff = ((rgb_buf[y : y + P, x : x + P] - tile) ** 2).sum(axis=2)
                c_val = (float(diff[:, :OV].mean()) if x else 0.0) + (float(diff[:OV, :].mean()) if y else 0.0)
                # Pénalité anti-répétition : interdit de rejouer le même patch côte-à-côte et favorise la diversité
                rep_pen = 650.0 * usage[(sx, sy)]
                if abs(sx - prev_choice[0]) <= 16 and abs(sy - prev_choice[1]) <= 16:
                    rep_pen += 25000.0
                if abs(sx - above_c[0]) <= 16 and abs(sy - above_c[1]) <= 16:
                    rep_pen += 25000.0
                candidates.append((c_val + rep_pen + float(rng.random()) * 120.0, sx, sy, tile, diff))

            _, sx, sy, tile, diff = min(candidates, key=lambda item: item[0])
            usage[(sx, sy)] += 1
            prev_choice = (sx, sy)
            last_row_choices[x] = (sx, sy)

            take = np.ones((P, P), dtype=bool)
            if x:
                sx_cut = (np.rint(_min_seam(diff[:, :OV]) / 8.0).astype(int) * 8).clip(0, OV)
                take[:, :OV] &= np.arange(OV)[None, :] >= sx_cut[:, None]
            if y:
                sy_cut = (np.rint(_min_seam(diff[:OV, :].T) / 8.0).astype(int) * 8).clip(0, OV)
                take[:OV, :] &= np.arange(OV)[:, None] >= sy_cut[None, :]
            block = (yy + sy) * src_idx.shape[1] + (xx + sx)
            coords[y : y + P, x : x + P][take] = block[take]
            rgb_buf[y : y + P, x : x + P][take] = tile[take]

    out_idx = src_idx.reshape(-1)[coords[:h, :w]].copy()
    assert int(((out_idx // 16) == 4).sum()) == 0
    return out_idx


def build_canonical_h26p01_magma_frames(
    w: int = 768,
    h: int = 576,
    mask: np.ndarray | None = None,
    phase_offset: int = 0,
    index_roll: Tuple[int, int] = (0, 0),
    pure_molten_only: bool = False,
) -> List[Image.Image]:
    """Génère les `31` phases matérielles exactes (`FrameLength = 4` ticks, cycle `124` ticks)
    du palette cycling canonique `H26P01.bpl` à l'échelle `1×` native."""
    idx = build_quilted_h26p01_index_sheet(w, h, pure_molten_only=pure_molten_only)
    if index_roll != (0, 0):
        idx = np.roll(idx, shift=(index_roll[1], index_roll[0]), axis=(0, 1))
    frames: List[Image.Image] = []
    for f in range(31):
        tick = ((f + phase_offset) % 31) * 4
        rgba = colorize_h26p01_indices(idx, tick=tick).copy()
        if mask is not None:
            rgba[~mask] = 0
        else:
            rgba[:, :, 3] = 255
        frames.append(Image.fromarray(rgba, mode="RGBA"))
    return frames


def extract_canonical_h26p01_pillar_module(variant: str = "large") -> List[np.ndarray]:
    """Extrait à l'échelle `1×` native l'une des colonnes cylindriques de lave de `H26P01`
    (`palette 4`, cycle matériel `8` frames × `3` ticks = `24` ticks) avec son fût complet
    et son bassin circulaire d'éclaboussures en fusion."""
    boxes = {
        "large": (56, 0, 104, 168),
        "medium": (16, 0, 48, 112),
        "small": (184, 0, 216, 56),
    }
    x0, y0, x1, y1 = boxes[variant]
    src_idx, _ = load_h26p01_native()
    sub = src_idx[y0:y1, x0:x1]
    # Exclut les indices de fond plat hors fût / anneau rond (`75`, et hors ellipse basse sur `medium`)
    is_p4 = ((sub // 16) == 4) & (sub != 75)
    if variant != "large":
        mh_sub, mw_sub = sub.shape
        yy_f, xx_f = np.mgrid[:mh_sub, :mw_sub]
        foot_band = yy_f >= (mh_sub - 20)
        ell = (((xx_f - (mw_sub - 1) / 2.0) / (mw_sub * 0.44)) ** 2 + ((yy_f - (mh_sub - 11.0)) / 9.5) ** 2) <= 1.0
        shaft_narrow = np.abs(xx_f - (mw_sub - 1) / 2.0) <= (mw_sub * 0.24)
        is_p4 = is_p4 & ((~foot_band) | ell | shaft_narrow)
    rim_1px = ndimage.binary_dilation(is_p4, iterations=1) & (~is_p4)

    out_frames: List[np.ndarray] = []
    for f in range(8):
        rgba = colorize_h26p01_indices(sub, tick=f * 3).copy()
        out = np.zeros_like(rgba)
        out[is_p4] = rgba[is_p4]
        out[rim_1px] = np.array([128, 28, 8, 255], dtype=np.uint8)
        out_frames.append(out)
    return out_frames


def render_extended_canonical_pillars(
    w: int,
    h: int,
    specs: Sequence[Dict[str, object]],
    open_magma_mask: np.ndarray | None = None,
) -> List[Image.Image]:
    """Place des colonnes cylindriques canoniques `H26P01` (`palette 4`, `8` frames × `3` ticks)
    allant de `top_y` (défaut `0`) jusqu'à leur bouche `(cx, base_y)` en répétant strictement
    la période verticale native de `16 px` du fût `H26P01` sans redimensionnement."""
    frames_out: List[np.ndarray] = [np.zeros((h, w, 4), dtype=np.uint8) for _ in range(8)]
    for spec in specs:
        variant = str(spec.get("variant", "large"))
        cx = int(spec["cx"])
        top_y = max(0, int(spec.get("top_y", 0)))
        base_y = int(spec["base_y"])
        phase = int(spec.get("phase", 0))
        mirror = bool(spec.get("mirror", False))

        mod_frames = extract_canonical_h26p01_pillar_module(variant)
        mh, mw = mod_frames[0].shape[:2]
        span_h = max(24, base_y - top_y)
        if w < 512:
            scale = min(w / 768.0, h / 576.0)
            nw = max(12, int(round(mw * scale)))
            for f in range(8):
                src_f = mod_frames[(f + phase) % 8]
                if mirror:
                    src_f = src_f[:, ::-1, :]
                arr_s = np.asarray(
                    Image.fromarray(src_f, mode="RGBA").resize((nw, span_h), Image.Resampling.NEAREST),
                    dtype=np.uint8,
                )
                x0 = cx - nw // 2
                dx0 = max(0, x0)
                dx1 = min(w, x0 + nw)
                if dx1 > dx0:
                    sub = arr_s[:, dx0 - x0 : dx1 - x0]
                    m = sub[:, :, 3] > 0
                    frames_out[f][top_y : top_y + span_h, dx0:dx1][m] = sub[m]
            continue

        foot_h = min(40, mh - 16, span_h)
        for f in range(8):
            src_f = mod_frames[(f + phase) % 8]
            if mirror:
                src_f = src_f[:, ::-1, :]
            col_full = np.zeros((span_h, mw, 4), dtype=np.uint8)
            shaft_len = span_h - foot_h
            shaft_band = src_f[8:24, :, :]
            if shaft_len > 0:
                reps = shaft_len // 16 + 2
                col_full[:shaft_len, :, :] = np.tile(shaft_band, (reps, 1, 1))[:shaft_len, :, :]
            col_full[shaft_len:, :, :] = src_f[mh - foot_h :, :, :]

            x0 = cx - mw // 2
            dx0 = max(0, x0)
            dx1 = min(w, x0 + mw)
            if dx1 <= dx0:
                continue
            sub = col_full[:, dx0 - x0 : dx1 - x0]
            m = sub[:, :, 3] > 0
            if open_magma_mask is not None:
                m = m & open_magma_mask[top_y : top_y + span_h, dx0:dx1]
            frames_out[f][top_y : top_y + span_h, dx0:dx1][m] = sub[m]

    return [Image.fromarray(arr, mode="RGBA") for arr in frames_out]


def build_h26p01_rim_glow_frames(
    rock_rgba: np.ndarray,
    hot_contact_mask: np.ndarray,
) -> List[Image.Image]:
    """Utilise les `15` phases matérielles exactes (`FrameLength = 8` ticks, cycle `120` ticks)
    de la palette `0` de `H26P01.bpl` sur les bords rocheux immédiats des veines et gouffres."""
    _, bpl_bytes = load_h26p01_native()
    h, w, _ = rock_rgba.shape
    opaque_rock = rock_rgba[:, :, 3] > 0
    rim1 = ndimage.binary_dilation(hot_contact_mask, iterations=1) & opaque_rock
    rim2 = ndimage.binary_dilation(hot_contact_mask, iterations=2) & opaque_rock & (~rim1)

    frames: List[Image.Image] = []
    for f in range(15):
        pal, _ = decode_red_palettes(bpl_bytes, tick=f * 8)
        c_hot = pal[0, 13, :3]
        c_mid = pal[0, 11, :3]
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[rim1, :3] = np.clip(0.55 * rock_rgba[rim1, :3].astype(np.float32) + 0.45 * c_hot.astype(np.float32), 0, 255).astype(np.uint8)
        arr[rim1, 3] = 255
        arr[rim2, :3] = np.clip(0.75 * rock_rgba[rim2, :3].astype(np.float32) + 0.25 * c_mid.astype(np.float32), 0, 255).astype(np.uint8)
        arr[rim2, 3] = 255
        frames.append(Image.fromarray(arr, mode="RGBA"))
    return frames


def build_canonical_w04_embers_frames(w: int = 768, h: int = 576) -> List[Image.Image]:
    """Extrait à l'échelle `1×` native les `16` phases matérielles `.bpa` (`FrameLength = 7` ticks,
    cycle `112` ticks) des braises / flammèches volcaniques `W04` de PMD Red."""
    folder = _rom_folder()
    frames: List[Image.Image] = []
    for f in range(16):
        imgs, _, _, _ = decode_red_bg("W04", tick=f * 7, folder=folder)
        arr = np.asarray(imgs[0].crop((0, 0, min(w, imgs[0].width), min(h, imgs[0].height))), dtype=np.uint8).copy()
        if arr.shape[1] < w or arr.shape[0] < h:
            tiled = np.tile(arr, (h // arr.shape[0] + 1, w // arr.shape[1] + 1, 1))[:h, :w].copy()
        else:
            tiled = arr[:h, :w].copy()
        bright = (tiled[:, :, 0] >= 90) | (tiled[:, :, 1] >= 60)
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[bright, :3] = tiled[bright, :3]
        out[bright, 3] = 255
        frames.append(Image.fromarray(out, mode="RGBA"))
    return frames


def split_magenta_chasms_and_veins(
    decor_rgb: np.ndarray,
    min_open_chasm_area: int = 3500,
) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Détecte tous les pixels magenta `#FF00FF` ainsi que tout pixel anti-aliasé prune/violet
    (`R - G >= 16 & B - G >= 10`) et sépare morphologiquement :
    - `open_chasm` : les vastes nappes / gouffres ouverts de lave (largeur locale `>= 20 px`),
    - `rock_veins` : toutes les veines, fissures et réseaux de craquelures de la roche (`< 20 px`),
      même lorsqu'elles se rejoignent en réseau ou débouchent dans un gouffre !"""
    r = decor_rgb[:, :, 0].astype(np.int16)
    g = decor_rgb[:, :, 1].astype(np.int16)
    b = decor_rgb[:, :, 2].astype(np.int16)
    all_magenta = ((r >= 240) & (g <= 15) & (b >= 240)) | ((r - g >= 16) & (b - g >= 10))

    h, w, _ = decor_rgb.shape
    half_w = max(2, int(round(10.0 * w / 768.0)))
    wide_cores = ndimage.binary_opening(all_magenta, iterations=half_w)
    open_chasm = ndimage.binary_dilation(wide_cores, iterations=half_w + 1) & all_magenta
    rock_veins = all_magenta & (~open_chasm)
    return all_magenta, open_chasm, rock_veins
