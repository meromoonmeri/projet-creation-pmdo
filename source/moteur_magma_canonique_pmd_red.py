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


# Palette 5-bit GBA 100 % canonique extraite directement de `H26P01.bpl`
# (croûte refroidie noir-grenat -> rouge visqueux -> orange H26P01 -> fissure dorée).
H26_VISCOUS_SHORE_PAL = np.array(
    [
        [31, 4, 0],      # 0 : croûte figée contre le basalte noir (bordure rocher)
        [55, 8, 0],      # 1 : coeur sombre de plaque de croûte refroidie
        [79, 15, 0],     # 2 : rebord de croûte refroidie
        [103, 23, 7],    # 3 : sillon visqueux grenat chaud
        [135, 31, 7],    # 4 : dos d'onde visqueuse rouge profond
        [167, 47, 7],    # 5 : magma rouge-orangé H26P01
        [199, 79, 0],    # 6 : crête visqueuse orange H26P01
        [215, 119, 0],   # 7 : liseré en fusion autour des plaques de croûte
        [231, 159, 0],   # 8 : fissure ardente au contact rocheux
        [247, 199, 23],  # 9 : point d'éclat de rupture contre la paroi
    ],
    dtype=np.uint8,
)


def _shore_surge_phase_field(h: int, w: int) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    tau = 2.0 * np.pi
    along = (
        1.35 * np.sin(tau * xx / 128.0 + 0.7 * np.cos(tau * yy / 144.0))
        + 1.05 * np.cos(tau * yy / 96.0 - 0.6 * np.sin(tau * xx / 160.0))
        + 0.55 * np.sin(tau * (xx + yy) / 64.0)
    )
    return xx, yy, along


def render_viscous_shoreline_border(
    open_magma_mask: np.ndarray,
    n_frames: int = 15,
    band_px: float = 22.0,
) -> List[Image.Image]:
    """Génère `n_frames` phases bouclées sans couture (`FrameLength = 8` ticks, cycle `120` ticks)
    d'animation visqueuse de rive et de croûte de bordure rocher sur `0 < d <= band_px`,
    SANS AUCUN DAMIER (`0` Bayer dither) ni anneau jaune artificiel :
    1. Collerette continue de croûte refroidie au contact immédiat du basalte (`bordure rocher`,
       `d <= rim_w`, `1.8..5.0 px`) qui s'épaissit en refroidissant puis s'amincit et se fendille
       de fissures orangées sous la poussée du magma ;
    2. Plaques organiques de croûte refroidie (cellules Worley anisotropes `2:1` de `magma.py`)
       flottant et se déformant visqueusement près des parois (`d <= 15 px`), laissant voir entre
       elles le vrai magma `1×` `H26P01.bpl` en ébullition continue (`alpha = 0` dans les chenaux !) ;
    3. Bourrelets / langues d'ondes visqueuses concentriques au rivage qui roulent lentement vers
       la paroi rocheuse (`d : 20 -> 0`) dans les teintes canoniques exactes de `H26P01.bpl`."""
    h, w = open_magma_mask.shape
    dist = ndimage.distance_transform_edt(open_magma_mask).astype(np.float32)
    active_band = open_magma_mask & (dist <= band_px)
    ys, xs = np.where(active_band)
    if len(ys) == 0:
        return [Image.fromarray(np.zeros((h, w, 4), dtype=np.uint8), mode="RGBA") for _ in range(n_frames)]

    xx_full, yy_full, along_full = _shore_surge_phase_field(h, w)
    xv = xx_full[ys, xs]
    yv = yy_full[ys, xs]
    dv = dist[ys, xs]
    av = along_full[ys, xs]

    # Grille cellulaire périodique 2:1 (inspirée de `source/magma_visqueux/magma.py`)
    cell_x, cell_y = 26.0, 13.0
    nx, ny = int(np.ceil(w / cell_x)) + 4, int(np.ceil(h / cell_y)) + 4
    rng = np.random.default_rng(26010)
    jx = rng.uniform(0.18, 0.82, size=(ny, nx)).astype(np.float32)
    jy = rng.uniform(0.18, 0.82, size=(ny, nx)).astype(np.float32)
    tau = 2.0 * np.pi

    frames: List[Image.Image] = []
    for f in range(n_frames):
        s = float(f) / float(n_frames)
        ph = tau * s

        # Houle visqueuse lente convergeant vers la paroi rocheuse (`+ 2 * s` => crêtes allant vers `d = 0`)
        wave_main = np.sin(tau * (dv / 10.5 + 2.0 * s) + av)
        wave_sub = np.sin(tau * (dv / 6.5 + 1.0 * s) - 0.75 * av + 0.9)
        surge = 0.70 * wave_main + 0.30 * wave_sub

        # Déformation visqueuse périodique des radeaux de croûte côtiers
        wu = 3.4 * np.sin(tau * yv / 96.0 + ph) + 2.2 * surge
        wv = 2.0 * np.cos(tau * xv / 112.0 - ph) + 1.4 * np.sin(tau * dv / 15.0 + ph)
        gx = (xv + wu) / cell_x + 2.0
        gy = (yv + wv) / cell_y + 2.0
        ix0 = np.floor(gx).astype(np.int32)
        iy0 = np.floor(gy).astype(np.int32)

        d1 = np.full(xv.shape, 99.0, dtype=np.float32)
        d2 = np.full(xv.shape, 99.0, dtype=np.float32)
        for dy in (-1, 0, 1):
            cy = (iy0 + dy) % ny
            for dx in (-1, 0, 1):
                cx = (ix0 + dx) % nx
                px = (ix0 + dx).astype(np.float32) + jx[cy, cx]
                py = (iy0 + dy).astype(np.float32) + jy[cy, cx]
                dd = np.hypot(gx - px, gy - py)
                swap = dd < d1
                d2 = np.where(swap, d1, np.minimum(d2, dd))
                d1 = np.where(swap, dd, d1)

        # `core` est élevé au coeur d'une plaque cellulaire, `0` dans le chenal en fusion entre deux plaques
        core = d2 - d1

        # 1. Collerette continue de `bordure rocher` (`1.8..5.0 px` contre chaque falaise / pilier de basalte)
        rim_w = 3.25 - 1.25 * surge + 1.15 * np.clip(core, 0.0, 0.7)
        on_rock_lip = dv <= rim_w

        # 2. Radeaux organiques de croûte refroidie flottant près des parois (`d <= 15.5 px`, contours nets sans damier !)
        plate_thresh = 0.14 + 0.032 * dv + 0.07 * surge
        on_crust_raft = (dv <= 15.5) & (core > plate_thresh)
        raft_hot_rim = (dv <= 16.2) & (~on_crust_raft) & (core > plate_thresh - 0.075)

        # 3. Bourrelets / rides visqueuses concentriques roulant de la mer H26P01 vers la rive (`d = 3..21 px`)
        ridge_env = np.clip((band_px - dv) / 7.5, 0.0, 1.0)
        on_viscous_ridge = (dv > rim_w) & (~on_crust_raft) & ((wave_main * ridge_env) > 0.34)
        ridge_crest = on_viscous_ridge & ((wave_main * ridge_env) > 0.68)
        on_viscous_trough = (dv > rim_w) & (dv <= 16.5) & (~on_crust_raft) & (~raft_hot_rim) & (wave_main < -0.52)

        opaque = on_rock_lip | on_crust_raft | raft_hot_rim | on_viscous_ridge | on_viscous_trough
        pal_idx = np.full(xv.shape, 5, dtype=np.int32)

        # Creux visqueux sombres entre deux ondes côtières
        pal_idx = np.where(on_viscous_trough, 4, pal_idx)
        # Rides visqueuses concentriques orange H26P01
        pal_idx = np.where(on_viscous_ridge, 5, pal_idx)
        pal_idx = np.where(ridge_crest, np.where(dv <= 9.0, 7, 6), pal_idx)
        # Liseré en fusion léchant le bord des radeaux de croûte
        pal_idx = np.where(raft_hot_rim, np.where(surge > 0.25, 7, 6), pal_idx)
        # Radeaux de croûte volcanique refroidie (coeur sombre -> bord grenat)
        pal_idx = np.where(on_crust_raft, np.where(core > plate_thresh + 0.14, 1, 2), pal_idx)
        # Bordure rocher immédiate : croûte noir-grenat qui craque d'éclats orangés sous la poussée du magma !
        lip_crack = on_rock_lip & (core < 0.085) & (surge > 0.12)
        lip_warm = on_rock_lip & (~lip_crack) & (dv > rim_w - 1.1)
        lip_solid = on_rock_lip & (~lip_crack) & (~lip_warm)
        pal_idx = np.where(lip_solid, np.where(dv <= 1.6, 0, 1), pal_idx)
        pal_idx = np.where(lip_warm, np.where(surge > 0.35, 6, 3), pal_idx)
        pal_idx = np.where(lip_crack, np.where(surge > 0.52, 9, 8), pal_idx)

        arr = np.zeros((h, w, 4), dtype=np.uint8)
        vis_ys = ys[opaque]
        vis_xs = xs[opaque]
        arr[vis_ys, vis_xs, :3] = H26_VISCOUS_SHORE_PAL[pal_idx[opaque]]
        arr[vis_ys, vis_xs, 3] = 255
        frames.append(Image.fromarray(arr, mode="RGBA"))

    return frames


def build_h26p01_rim_glow_frames(
    rock_rgba: np.ndarray,
    hot_contact_mask: np.ndarray,
) -> List[Image.Image]:
    """Utilise les `15` phases matérielles exactes (`FrameLength = 8` ticks, cycle `120` ticks)
    de la palette `0` de `H26P01.bpl` couplées en phase avec l'onde visqueuse de rive (`surge`)
    pour illuminer dynamiquement les rebords rocheux (`bordure rocher` sur `2 px` d'épaisseur)
    au moment précis où le magma visqueux vient lécher chaque paroi !"""
    _, bpl_bytes = load_h26p01_native()
    h, w, _ = rock_rgba.shape
    opaque_rock = rock_rgba[:, :, 3] > 0
    rim1 = ndimage.binary_dilation(hot_contact_mask, iterations=1) & opaque_rock
    rim2 = ndimage.binary_dilation(hot_contact_mask, iterations=2) & opaque_rock & (~rim1)

    _, _, along = _shore_surge_phase_field(h, w)
    # 4 secteurs de phase quantifiés par tuile `8×8` pour propager l'onde thermique autour du rivage
    # tout en préservant une compacité maximale de la banque `.tile` !
    along_tile = np.repeat(np.repeat(along[::8, ::8], 8, axis=0), 8, axis=1)[:h, :w]
    phase_q = (np.rint(along_tile / (0.5 * np.pi)) * (0.5 * np.pi)).astype(np.float32)

    tau = 2.0 * np.pi
    r1_ys, r1_xs = np.where(rim1)
    r2_ys, r2_xs = np.where(rim2)
    base1 = rock_rgba[r1_ys, r1_xs, :3].astype(np.float32)
    base2 = rock_rgba[r2_ys, r2_xs, :3].astype(np.float32)
    a1 = phase_q[r1_ys, r1_xs]
    a2 = phase_q[r2_ys, r2_xs]

    frames: List[Image.Image] = []
    for f in range(15):
        s = float(f) / 15.0
        pal, _ = decode_red_palettes(bpl_bytes, tick=f * 8)
        c_hot = pal[0, 13, :3].astype(np.float32)
        c_mid = pal[0, 11, :3].astype(np.float32)

        w1 = np.clip(0.42 + 0.25 * np.sin(tau * 2.0 * s + a1), 0.16, 0.68)[:, None]
        w2 = np.clip(0.24 + 0.16 * np.sin(tau * 2.0 * s + a2), 0.08, 0.42)[:, None]

        # Quantification matérielle GBA 5-bit BGR555 exacte (`& 0xF8`) : 100 % fidèle au GPU GBA
        # et compacte la banque `.tile` de ~72 % en fusionnant les quasi-doublons à 1 LSB !
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[r1_ys, r1_xs, :3] = (np.clip((1.0 - w1) * base1 + w1 * c_hot, 0, 255).astype(np.uint8) & 0xF8)
        arr[r1_ys, r1_xs, 3] = 255
        arr[r2_ys, r2_xs, :3] = (np.clip((1.0 - w2) * base2 + w2 * c_mid, 0, 255).astype(np.uint8) & 0xF8)
        arr[r2_ys, r2_xs, 3] = 255
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


# ==============================================================================
# MOTEUR CANONIQUE PMD SKY — DARK CRATER PIT (`d41p41a`, 12 POSES × 10 TICKS)
# + ANIMATION VISQUEUSE DE RIVE & CROÛTE DE BORDURE ROCHER (`Dark Crater` 13 TONS)
# ==============================================================================

DARK_CRATER_PIT_DIR = REPO_ROOT / "source" / "mine_magma_arene_v1" / "references" / "dark_crater_pit"

# Rampe canonique exacte 13 tons de `source/magma_visqueux/magma.py` relevée sur `Dark_Crater_Pit_TDS.png` (`d41p41a`) :
DARK_CRATER_VISCOUS_PAL = np.array(
    [
        [70, 20, 26],    # 0 : croûte figée noire-grenat au contact rocheux (bordure rocher)
        [120, 26, 22],   # 1 : plaque de croûte sombre épaisse
        [184, 32, 26],   # 2 : rebord de croûte braise
        [247, 39, 31],   # 3 : rouge profond cellulaire Dark Crater Pit
        [247, 63, 31],   # 4 : rouge-orangé cellulaire
        [247, 95, 31],   # 5 : orange ardent
        [247, 119, 31],  # 6 : orange soutenu
        [247, 135, 31],  # 7 : orange clair
        [247, 151, 39],  # 8 : ambre doré
        [255, 167, 39],  # 9 : or chaud
        [255, 199, 47],  # 10 : or lumineux Dark Crater Pit
        [255, 223, 55],  # 11 : jaune d'ébullition côtière
        [255, 255, 47],  # 12 : jaune vif de halo rocheux & fissure Dark Crater Pit
    ],
    dtype=np.uint8,
)


@functools.lru_cache(maxsize=2)
def load_dark_crater_pit_96x96() -> np.ndarray:
    """Charge les `12` frames matérielles natives `1×` (`96 × 96`, `FrameLength = 10` ticks,
    cycle exact `120` ticks = `2.0 s` à `60 FPS`) extraites bit-à-bit de `d41p41a` (*Dark Crater Pit*)."""
    arrs = []
    for f in range(12):
        p = DARK_CRATER_PIT_DIR / f"dark_crater_pit_lava_96x96_f{f:02d}.png"
        arrs.append(np.asarray(Image.open(p).convert("RGB"), dtype=np.uint8).copy())
    return np.stack(arrs, axis=0)


def build_dark_crater_pit_magma_frames(
    w: int = 768,
    h: int = 576,
    mask: np.ndarray | None = None,
    phase_offset: int = 0,
    roll_xy: Tuple[int, int] = (0, 0),
) -> List[Image.Image]:
    """Assemble sans aucune couture ni interpolation (`1×` natif exact) les `12` phases matérielles
    (`FrameLength = 10` ticks, cycle `120` ticks) de la lave de `Dark Crater Pit` (`d41p41a`)."""
    canon_96 = load_dark_crater_pit_96x96()
    rx, ry = roll_xy
    reps_y = h // 96 + 2
    reps_x = w // 96 + 2
    frames: List[Image.Image] = []
    for f in range(12):
        tile_rgb = canon_96[(f + phase_offset) % 12]
        if rx or ry:
            tile_rgb = np.roll(tile_rgb, shift=(ry, rx), axis=(0, 1))
        full_rgb = np.tile(tile_rgb, (reps_y, reps_x, 1))[:h, :w, :]
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if mask is None:
            arr[:, :, :3] = full_rgb
            arr[:, :, 3] = 255
        else:
            arr[mask, :3] = full_rgb[mask]
            arr[mask, 3] = 255
        frames.append(Image.fromarray(arr, mode="RGBA"))
    return frames


def render_dark_crater_viscous_shoreline(
    open_magma_mask: np.ndarray,
    n_frames: int = 15,
    band_px: float = 22.0,
) -> List[Image.Image]:
    """Animation visqueuse de rive & croûte de bordure rocher calibrée à `100 %` sur la rampe
    exacte 13 tons de `Dark Crater Pit` (`d41p41a`, `0` damier, `alpha ∈ {0, 255}`) :
    - Au contact direct de la roche noire (`bordure rocher`, `d <= rim_w`) : alternance vivante
      entre le **halo d'ébullition jaune d'or canonique de `Dark Crater Pit`** (`idx 11..12` quand
      la houle visqueuse pousse contre la paroi) et la **croûte figée noir-grenat** (`idx 0..2`
      quand la vague reflue et refroidit au contact du basalte froid) ;
    - En zone côtière (`2 < d <= 20 px`) : plaques cellulaires organiques de croûte refroidie
      (`Worley 2:1` de `magma.py`) et rides visqueuses concentriques roulant lentement vers la rive
      par-dessus la vraie lave `1×` `d41p41a` visible dans les chenaux ouverts (`alpha = 0`)."""
    h, w = open_magma_mask.shape
    dist = ndimage.distance_transform_edt(open_magma_mask).astype(np.float32)
    active_band = open_magma_mask & (dist <= band_px)
    ys, xs = np.where(active_band)
    if len(ys) == 0:
        return [Image.fromarray(np.zeros((h, w, 4), dtype=np.uint8), mode="RGBA") for _ in range(n_frames)]

    xx_full, yy_full, along_full = _shore_surge_phase_field(h, w)
    xv = xx_full[ys, xs]
    yv = yy_full[ys, xs]
    dv = dist[ys, xs]
    av = along_full[ys, xs]

    cell_x, cell_y = 26.0, 13.0
    nx, ny = int(np.ceil(w / cell_x)) + 4, int(np.ceil(h / cell_y)) + 4
    rng = np.random.default_rng(41410)
    jx = rng.uniform(0.18, 0.82, size=(ny, nx)).astype(np.float32)
    jy = rng.uniform(0.18, 0.82, size=(ny, nx)).astype(np.float32)
    tau = 2.0 * np.pi

    frames: List[Image.Image] = []
    for f in range(n_frames):
        s = float(f) / float(n_frames)
        ph = tau * s

        wave_main = np.sin(tau * (dv / 10.5 + 2.0 * s) + av)
        wave_sub = np.sin(tau * (dv / 6.5 + 1.0 * s) - 0.75 * av + 0.9)
        surge = 0.70 * wave_main + 0.30 * wave_sub

        wu = 3.4 * np.sin(tau * yv / 96.0 + ph) + 2.2 * surge
        wv = 2.0 * np.cos(tau * xv / 112.0 - ph) + 1.4 * np.sin(tau * dv / 15.0 + ph)
        gx = (xv + wu) / cell_x + 2.0
        gy = (yv + wv) / cell_y + 2.0
        ix0 = np.floor(gx).astype(np.int32)
        iy0 = np.floor(gy).astype(np.int32)

        d1 = np.full(xv.shape, 99.0, dtype=np.float32)
        d2 = np.full(xv.shape, 99.0, dtype=np.float32)
        for dy in (-1, 0, 1):
            cy = (iy0 + dy) % ny
            for dx in (-1, 0, 1):
                cx = (ix0 + dx) % nx
                px = (ix0 + dx).astype(np.float32) + jx[cy, cx]
                py = (iy0 + dy).astype(np.float32) + jy[cy, cx]
                dd = np.hypot(gx - px, gy - py)
                swap = dd < d1
                d2 = np.where(swap, d1, np.minimum(d2, dd))
                d1 = np.where(swap, dd, d1)

        core = d2 - d1

        # 1. Bordure rocher (`0 < d <= lip_w`, `2.2..4.6 px`) fidèle à `Dark Crater Pit` (`d41p41a`) :
        #    - Halo d'ébullition jaune-or vif (`idx 10..12`) directement collé à la paroi noire,
        #    - Lobes visqueux de croûte refroidie noir-grenat (`idx 0..2`) ancrés UNIQUEMENT contre
        #      la paroi rocheuse (`d <= crust_w`, jamais un ruban rayé détaché au large !).
        lip_w = 2.95 + 1.25 * np.clip(surge, -0.5, 1.0) + 0.85 * np.clip(core, 0.0, 0.65)
        crust_w = (2.75 - 1.35 * surge) * np.clip(1.25 * core, 0.0, 1.35)
        on_lip_crust = (dv <= crust_w) & (surge < 0.22) & (core > 0.24)
        on_lip_gold = (dv <= lip_w) & (~on_lip_crust)

        # 2. Petits radeaux organiques isolés de croûte sombre flottant près des anses (`d <= 12 px`)
        raft_seed = (dv > lip_w) & (dv <= 11.5) & (core > (0.44 + 0.020 * dv + 0.06 * surge))
        raft_amber_rim = (
            (dv > lip_w)
            & (dv <= 12.2)
            & (~raft_seed)
            & (core > (0.38 + 0.020 * dv + 0.06 * surge))
        )

        # 3. Ondes visqueuses ambrées douces roulant vers la paroi (`idx 8..10`, sans cerne jaune détaché)
        ridge_env = np.clip((15.5 - dv) / 8.5, 0.0, 1.0)
        on_viscous_swell = (dv > lip_w) & (~raft_seed) & (~raft_amber_rim) & ((wave_main * ridge_env) > 0.48)
        swell_peak = on_viscous_swell & ((wave_main * ridge_env) > 0.76)

        opaque = on_lip_crust | on_lip_gold | raft_seed | raft_amber_rim | on_viscous_swell
        pal_idx = np.full(xv.shape, 8, dtype=np.int32)

        pal_idx = np.where(on_viscous_swell, 9, pal_idx)
        pal_idx = np.where(swell_peak, 10, pal_idx)
        pal_idx = np.where(raft_amber_rim, 9, pal_idx)
        pal_idx = np.where(raft_seed, np.where(core > 0.56, 0, 1), pal_idx)
        pal_idx = np.where(
            on_lip_gold,
            np.where(dv <= 1.75, 12, np.where(dv <= 2.9, 11, np.where(surge > 0.25, 10, 9))),
            pal_idx,
        )
        pal_idx = np.where(on_lip_crust, np.where(dv <= 1.5, 0, np.where(dv <= 2.6, 1, 2)), pal_idx)

        arr = np.zeros((h, w, 4), dtype=np.uint8)
        vis_ys = ys[opaque]
        vis_xs = xs[opaque]
        arr[vis_ys, vis_xs, :3] = DARK_CRATER_VISCOUS_PAL[pal_idx[opaque]]
        arr[vis_ys, vis_xs, 3] = 255
        frames.append(Image.fromarray(arr, mode="RGBA"))

    return frames


def build_dark_crater_rim_glow_frames(
    rock_rgba: np.ndarray,
    hot_contact_mask: np.ndarray,
) -> List[Image.Image]:
    """Lueur thermique synchronisée (`15 × 8` ticks = `120` ticks) sur le rebord immédiat (`2 px`)
    des parois et pitons de roche noire au contact du magma `Dark Crater Pit`."""
    h, w, _ = rock_rgba.shape
    opaque_rock = rock_rgba[:, :, 3] > 0
    rim1 = ndimage.binary_dilation(hot_contact_mask, iterations=1) & opaque_rock
    rim2 = ndimage.binary_dilation(hot_contact_mask, iterations=2) & opaque_rock & (~rim1)

    _, _, along = _shore_surge_phase_field(h, w)
    along_tile = np.repeat(np.repeat(along[::8, ::8], 8, axis=0), 8, axis=1)[:h, :w]
    phase_q = (np.rint(along_tile / (0.5 * np.pi)) * (0.5 * np.pi)).astype(np.float32)

    tau = 2.0 * np.pi
    r1_ys, r1_xs = np.where(rim1)
    r2_ys, r2_xs = np.where(rim2)
    base1 = rock_rgba[r1_ys, r1_xs, :3].astype(np.float32)
    base2 = rock_rgba[r2_ys, r2_xs, :3].astype(np.float32)
    a1 = phase_q[r1_ys, r1_xs]
    a2 = phase_q[r2_ys, r2_xs]

    c_gold = np.array([255.0, 207.0, 47.0], dtype=np.float32)
    c_ember = np.array([239.0, 87.0, 31.0], dtype=np.float32)

    frames: List[Image.Image] = []
    for f in range(15):
        s = float(f) / 15.0
        w1 = np.clip(0.38 + 0.26 * np.sin(tau * 2.0 * s + a1), 0.12, 0.65)[:, None]
        w2 = np.clip(0.20 + 0.14 * np.sin(tau * 2.0 * s + a2), 0.06, 0.36)[:, None]

        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[r1_ys, r1_xs, :3] = (np.clip((1.0 - w1) * base1 + w1 * c_gold, 0, 255).astype(np.uint8) & 0xF8)
        arr[r1_ys, r1_xs, 3] = 255
        arr[r2_ys, r2_xs, :3] = (np.clip((1.0 - w2) * base2 + w2 * c_ember, 0, 255).astype(np.uint8) & 0xF8)
        arr[r2_ys, r2_xs, 3] = 255
        frames.append(Image.fromarray(arr, mode="RGBA"))
    return frames


def build_dark_crater_cascade_and_giant_columns(
    w: int,
    h: int,
    open_sea_mask: np.ndarray,
    north_breach_mask: np.ndarray,
    col_specs: Sequence[Dict[str, object]],
    n_phases: int = 24,
) -> List[Image.Image]:
    """Combine sur un cycle harmonique fermé `24 × 5 = 120` ticks (`2.0 s` à `60 FPS`) :
    1. La grande cascade visqueuse Nord (`source/magma_visqueux/magma.py:cascade_phases`) coulant
       entre les crocs de roche noire de la couronne Nord (`north_breach_mask`),
    2. Les 4 colonnes géantes de magma `Dark Crater Pit` (`source/magma_visqueux/colonnes_geantes.py`)
       jaillissant de bouches bouillonnantes dans la mer ouverte et sortant par le bord haut `y = 0` !"""
    import importlib.util

    sp_mg = importlib.util.spec_from_file_location("dc_mg", REPO_ROOT / "source" / "magma_visqueux" / "magma.py")
    mg = importlib.util.module_from_spec(sp_mg)  # type: ignore[arg-type]
    sp_mg.loader.exec_module(mg)  # type: ignore[union-attr]

    sp_cg = importlib.util.spec_from_file_location("dc_cg", REPO_ROOT / "source" / "magma_visqueux" / "colonnes_geantes.py")
    cg = importlib.util.module_from_spec(sp_cg)  # type: ignore[arg-type]
    sp_cg.loader.exec_module(cg)  # type: ignore[union-attr]
    cg.PHASES = n_phases

    casc_frames = None
    if int(north_breach_mask.sum()) >= 32:
        casc_frames, _ = mg.cascade_phases(north_breach_mask, seed=11, falls=1, phases=n_phases, foot_rows=6)

    col_frames = cg.column_frames(h, w, list(col_specs), open_sea_mask)
    out: List[Image.Image] = []
    for t in range(n_phases):
        canvas = np.zeros((h, w, 4), dtype=np.uint8)
        if casc_frames is not None:
            cf = casc_frames[t]
            mc = cf[:, :, 3] > 0
            canvas[mc] = cf[mc]
        colf = col_frames[t]
        mcol = colf[:, :, 3] > 0
        canvas[mcol] = colf[mcol]
        out.append(Image.fromarray(canvas, mode="RGBA"))
    return out


def build_primal_groudon_floor_rune_frames(
    floor_mask: np.ndarray,
    center_xy: Tuple[float, float],
    radii_xy: Tuple[float, float],
    floor_rgb: np.ndarray | None = None,
) -> List[Image.Image]:
    """Grave en creux biseauté dans la pierre volcanique noire du plateau central l'anneau et le
    symbole `Ω` de Primo-Groudon pulsant (`12 × 10 = 120` ticks) dans la rampe `Dark Crater Pit`."""
    h, w = floor_mask.shape
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    cx, cy = center_xy
    rx, ry = max(8.0, radii_xy[0]), max(6.0, radii_xy[1])
    nx = (xx - cx) / rx
    ny = (yy - cy) / ry
    r = np.hypot(nx, ny)
    ang = np.arctan2(ny, nx)

    south_gap = (ang > 0.30 * np.pi) & (ang < 0.70 * np.pi)
    outer_ring = np.abs(r - 0.92) <= 0.036
    omega_loop = (np.abs(r - 0.56) <= 0.056) & (~south_gap)
    foot_y = (np.abs(ny - 0.50) <= 0.050) & (np.abs(nx) >= 0.24) & (np.abs(nx) <= 0.62)
    inner_eye = np.abs(r - 0.22) <= 0.042
    cross_spokes = (np.abs(ny) <= 0.034) & (np.abs(nx) >= 0.56) & (np.abs(nx) <= 0.92)

    glyph = (outer_ring | omega_loop | foot_y | inner_eye | cross_spokes) & floor_mask
    core_glyph = (
        (np.abs(r - 0.92) <= 0.017)
        | ((np.abs(r - 0.56) <= 0.025) & (~south_gap))
        | ((np.abs(ny - 0.50) <= 0.022) & (np.abs(nx) >= 0.26) & (np.abs(nx) <= 0.60))
        | (np.abs(r - 0.22) <= 0.019)
    ) & glyph
    bevel = ndimage.binary_dilation(glyph, iterations=1) & (~glyph) & floor_mask

    stone_mod = np.zeros((h, w), dtype=np.int32)
    if floor_rgb is not None:
        slum = floor_rgb[:, :, 0].astype(np.float32)
        stone_mod = np.where(slum > 46.0, 1, np.where(slum < 34.0, -1, 0))

    pulse_seq = [3, 4, 5, 7, 8, 9, 10, 9, 8, 6, 5, 4]
    frames: List[Image.Image] = []
    for t in range(12):
        p = pulse_seq[t]
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        # Biseau sombre de pierre taillée autour du sillon : intègre le glyphe dans le basalte !
        if floor_rgb is not None:
            warm = DARK_CRATER_VISCOUS_PAL[min(12, max(0, p - 4))].astype(np.float32)
            bev_rgb = (0.62 * floor_rgb[bevel].astype(np.float32) + 0.22 * warm).clip(0, 255).astype(np.uint8) & 0xF8
            arr[bevel, :3] = bev_rgb
        else:
            arr[bevel, :3] = np.array([24, 16, 16], dtype=np.uint8)
        arr[bevel, 3] = 255

        edge_idx = np.clip(p - 3 + stone_mod, 0, 11)
        core_idx = np.clip(p + 1 + stone_mod, 2, 12)
        arr[glyph, :3] = DARK_CRATER_VISCOUS_PAL[edge_idx[glyph]]
        arr[glyph, 3] = 255
        arr[core_glyph, :3] = DARK_CRATER_VISCOUS_PAL[core_idx[core_glyph]]
        arr[core_glyph, 3] = 255
        frames.append(Image.fromarray(arr, mode="RGBA"))
    return frames
