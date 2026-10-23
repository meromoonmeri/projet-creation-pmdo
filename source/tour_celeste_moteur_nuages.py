#!/usr/bin/env python3
"""Moteur commun d'assemblage multicalque et d'animation multi-trames des nuages
pour la trilogie de La Tour Céleste (PMD Équipe de Secours Rouge -> PMDO 0.8.12).

Principes garantis :
- 100 % textures pixel-art issues des planches générées depuis les rips canoniques
  (`D13P01`, `A04P02`, `D13P02`, `b71`) quantifiées sans tramage sur la palette GBA canonique.
- Mouvement multi-trames périodique exact (`LOOP_TICKS = 120`, `N_FRAMES = 24`,
  `FRAME_TICKS = 5` soit 2,00 s à 60 i/s) sans aucun saut au bouclage `23 -> 0`
  ni aucune couture spatiale (`384 = 48 * 8` et périodes multiples de `24 * pas`).
- Détourage strict sur fond magenta `#FF00FF` + purge des franges anti-aliasées.
- Sérialisation native RogueEssence 0.8.12 (`Data/Ground/*.rsground` + `Content/Tile/*.tile`
  + `Content/Tile/index.idx`) avec contrôle strict du nombre de tuiles `8x8` uniques.
"""

from __future__ import annotations

import importlib.util
import json
import os
import shutil
import struct
import sys
import uuid
import zipfile
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[1]
if str(REPO_ROOT / "source") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "source"))

def fidelity(img_path: Path, ref_path: Path) -> float:
    """Distance euclidienne RGB canonique entre le rendu assemblé et le rip de référence
    (méthode du dépôt `MANUEL_METHODE_PMDO.md` / `fin_vapeur_sommet_v1/build.py`)."""
    a = np.asarray(Image.open(img_path).convert("RGB"), dtype=np.float64)
    b = np.asarray(
        Image.open(ref_path).convert("RGB").resize((a.shape[1], a.shape[0]), Image.Resampling.NEAREST),
        dtype=np.float64,
    )
    return float(np.linalg.norm(a.mean(axis=(0, 1)) - b.mean(axis=(0, 1))))


def assert_fidelity_below(img_path: Path, ref_path: Path, max_distance: float = 35.0) -> float:
    dist = fidelity(img_path, ref_path)
    assert dist < max_distance, (
        f"Dérive colorimétrique canonique sur {img_path.name} vs {ref_path.name} : "
        f"distance={dist:.2f} >= seuil={max_distance:.2f}"
    )
    return dist


def _load_repo_module(mod_name: str, rel_path: str):
    spec = importlib.util.spec_from_file_location(mod_name, REPO_ROOT / rel_path)
    assert spec is not None and spec.loader is not None
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


GFX_MOD = _load_repo_module("pmdo_cote_gfx", "source/pmdo_cote/build.py")
TOOLS_MOD = _load_repo_module("pmdo_cote_tools", "source/pmdo_cote/INSTALLER.py")

W_CANON = 768
H_CANON = 576
TILE_SIZE = 8
N_FRAMES = 24
FRAME_TICKS = 5
LOOP_TICKS = N_FRAMES * FRAME_TICKS  # 120 ticks = 2.00 s exact @ 60 FPS


@dataclass
class LayerEntry:
    slug: str
    name: str
    layer_kind: str  # "BG" (0) or "Top" (4)
    frames: List[Image.Image]  # 1 frame (static) or N_FRAMES frames (animated)
    frame_length: int = FRAME_TICKS


# ---------------------------------------------------------------------------
# Extraction palette GBA canonique & quantification sans tramage
# ---------------------------------------------------------------------------


def extract_canonical_palette(
    ref_paths: Sequence[Path],
    max_colors: int = 48,
    min_pixels: int = 8,
) -> np.ndarray:
    """Extrait les couleurs RGB exactes les plus représentatives des rips canoniques
    sans jamais fusionner les petits détails contrastés (noir du portail, bleu nuit, étoiles)."""
    counts: Dict[Tuple[int, int, int], int] = {}
    for p in ref_paths:
        arr = np.asarray(Image.open(p).convert("RGB"), dtype=np.uint8)
        flat = arr.reshape(-1, 3)
        uniq, cnt = np.unique(flat, axis=0, return_counts=True)
        for c, n in zip(uniq.tolist(), cnt.tolist()):
            key_c = (int(c[0]), int(c[1]), int(c[2]))
            counts[key_c] = counts.get(key_c, 0) + int(n)

    filtered = [c for c, n in sorted(counts.items(), key=lambda kv: -kv[1]) if n >= min_pixels]
    if len(filtered) <= max_colors:
        return np.array(filtered, dtype=np.uint8)

    # Garde les couleurs dominantes + couverture farthest-point pour préserver les accents sombres/clairs
    selected: List[Tuple[int, int, int]] = list(filtered[: min(24, max_colors)])
    remaining = [c for c in filtered if c not in selected]
    while len(selected) < max_colors and remaining:
        sel_arr = np.array(selected, dtype=np.float32)
        rem_arr = np.array(remaining, dtype=np.float32)
        d2 = ((rem_arr[:, None, :] - sel_arr[None, :, :]) ** 2).sum(axis=2).min(axis=1)
        idx = int(np.argmax(d2))
        selected.append(remaining.pop(idx))
    return np.array(selected, dtype=np.uint8)


def quantize_rgb_to_palette(rgb: np.ndarray, palette: np.ndarray) -> np.ndarray:
    """Quantifie une image RGB `(H, W, 3)` au plus proche voisin exact dans `palette` (zéro tramage)."""
    h, w, _ = rgb.shape
    flat = rgb.reshape(-1, 3).astype(np.int32)
    pal = palette.astype(np.int32)
    out = np.empty_like(flat, dtype=np.uint8)
    step = 65536
    for i in range(0, flat.shape[0], step):
        sub = flat[i : i + step]
        d2 = ((sub[:, None, :] - pal[None, :, :]) ** 2).sum(axis=2)
        out[i : i + step] = palette[np.argmin(d2, axis=1)]
    return out.reshape(h, w, 3)


def quantize_rgba_to_palette(img: Image.Image, palette: np.ndarray) -> Image.Image:
    rgba = np.asarray(img.convert("RGBA"), dtype=np.uint8).copy()
    mask = rgba[:, :, 3] >= 128
    out = np.zeros_like(rgba)
    if np.any(mask):
        q = quantize_rgb_to_palette(rgba[:, :, :3], palette)
        out[mask, :3] = q[mask]
        out[mask, 3] = 255
    return Image.fromarray(out, mode="RGBA")


# ---------------------------------------------------------------------------
# Détourage magenta #FF00FF & extraction des poses nuageuses entières
# ---------------------------------------------------------------------------


def key_magenta(
    img: Image.Image,
    size: Optional[Tuple[int, int]] = None,
    erode_fringe: int = 1,
    min_component_area: int = 64,
) -> Image.Image:
    """Détoure proprement un asset sur fond `#FF00FF` et purge tout halo rose anti-aliasé."""
    src = img.convert("RGB")
    if size is not None and src.size != size:
        src = src.resize(size, Image.Resampling.NEAREST)
    arr = np.asarray(src, dtype=np.int16)
    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]

    # Détection stricte du fond magenta et des pixels contaminés par le magenta
    is_mag = (r >= 175) & (b >= 175) & (g <= 125) & ((r - g) >= 85) & ((b - g) >= 85)
    fg = ~is_mag

    if erode_fringe > 0:
        # Supprime uniquement les pixels de bordure rose-violacé (r > b_voisin et g très bas par rapport au bleu/blanc)
        border = fg & ndimage.binary_dilation(is_mag, iterations=erode_fringe)
        pinkish = border & ((r - g) >= 42) & ((b - g) >= 42)
        fg = fg & (~pinkish)

    labeled, n_comp = ndimage.label(fg)
    if n_comp > 0 and min_component_area > 1:
        sizes = ndimage.sum(fg, labeled, index=range(1, n_comp + 1))
        keep = np.zeros(n_comp + 1, dtype=bool)
        for idx_c, sz in enumerate(sizes, start=1):
            if sz >= min_component_area:
                keep[idx_c] = True
        fg = keep[labeled]

    out = np.zeros((arr.shape[0], arr.shape[1], 4), dtype=np.uint8)
    out[fg, :3] = arr[fg].astype(np.uint8)
    out[fg, 3] = 255
    return Image.fromarray(out, mode="RGBA")


def extract_whole_cloud_sprites(
    sheet_path: Path,
    palette: np.ndarray,
    scale_div: int = 2,
    min_area: int = 40,
) -> List[Image.Image]:
    """Extrait tous les sprites entiers non coupés d'une planche `#FF00FF`, triés du plus grand au plus petit."""
    raw = Image.open(sheet_path).convert("RGB")
    target_size = (max(64, raw.width // scale_div), max(64, raw.height // scale_div))
    keyed = key_magenta(raw, size=None, erode_fringe=2, min_component_area=min_area * scale_div * scale_div)
    keyed_small = keyed.resize(target_size, Image.Resampling.NEAREST)
    keyed_q = quantize_rgba_to_palette(keyed_small, palette)
    arr = np.asarray(keyed_q, dtype=np.uint8)
    alpha = arr[:, :, 3] > 0
    labeled, n_comp = ndimage.label(alpha)
    sprites: List[Tuple[int, Image.Image]] = []
    h, w = alpha.shape
    for idx_c in range(1, n_comp + 1):
        ys, xs = np.where(labeled == idx_c)
        if ys.size < min_area:
            continue
        x0, x1 = int(xs.min()), int(xs.max()) + 1
        y0, y1 = int(ys.min()), int(ys.max()) + 1
        # Ignore les éléments coupés sur le bord de planche
        if x0 <= 1 or y0 <= 1 or x1 >= w - 1 or y1 >= h - 1:
            continue
        sub = np.zeros((y1 - y0, x1 - x0, 4), dtype=np.uint8)
        m = labeled[y0:y1, x0:x1] == idx_c
        sub[m] = arr[y0:y1, x0:x1][m]
        sprites.append((int(ys.size), Image.fromarray(sub, mode="RGBA")))
    sprites.sort(key=lambda item: -item[0])
    return [sp for _, sp in sprites]


# ---------------------------------------------------------------------------
# Tuilage périodique pixel-art sans aucune couture & champs de vitesse
# ---------------------------------------------------------------------------


def make_seamless_periodic_tile(
    src_img: Image.Image,
    period_w: int,
    period_h: int,
    palette: np.ndarray,
    transparent_luma_below: Optional[float] = None,
    transparent_blue_ratio: Optional[float] = None,
) -> np.ndarray:
    """Transforme une planche pixel-art en motif périodique `(period_h, period_w, 4)`
    strictement continu sur ses 4 bords PUIS quantifié sans tramage sur `palette`.
    Zéro flou dans le résultat final, zéro couture spatiale, 100 % pixel-art net."""
    base = np.asarray(
        src_img.convert("RGB").resize((period_w, period_h), Image.Resampling.BILINEAR),
        dtype=np.float32,
    )
    shift_x = np.roll(base, period_w // 2, axis=1)
    wx = (0.5 - 0.5 * np.cos(2.0 * np.pi * np.arange(period_w, dtype=np.float32) / period_w))[None, :, None]
    seamless_x = base * wx + shift_x * (1.0 - wx)

    shift_y = np.roll(seamless_x, period_h // 2, axis=0)
    wy = (0.5 - 0.5 * np.cos(2.0 * np.pi * np.arange(period_h, dtype=np.float32) / period_h))[:, None, None]
    seamless_xy = np.clip(np.rint(seamless_x * wy + shift_y * (1.0 - wy)), 0, 255).astype(np.uint8)

    q_rgb = quantize_rgb_to_palette(seamless_xy, palette)
    rgba = np.zeros((period_h, period_w, 4), dtype=np.uint8)
    rgba[:, :, :3] = q_rgb
    rgba[:, :, 3] = 255

    if transparent_luma_below is not None or transparent_blue_ratio is not None:
        r = q_rgb[:, :, 0].astype(np.float32)
        g = q_rgb[:, :, 1].astype(np.float32)
        b = q_rgb[:, :, 2].astype(np.float32)
        luma = 0.299 * r + 0.587 * g + 0.114 * b
        drop = np.zeros((period_h, period_w), dtype=bool)
        if transparent_luma_below is not None:
            drop |= luma < transparent_luma_below
        if transparent_blue_ratio is not None:
            drop |= (b - r) > transparent_blue_ratio
        # Nettoyage morphologique périodique pour éviter tout pixel isolé
        padded = np.pad(drop, 2, mode="wrap")
        cleaned = ndimage.binary_opening(ndimage.binary_closing(padded, iterations=1), iterations=1)[2:-2, 2:-2]
        rgba[cleaned, 3] = 0
        rgba[cleaned, :3] = 0

def make_fullscale_periodic_strip(
    src_img: Image.Image,
    canvas_w: int,
    canvas_h: int,
    crop_box: Tuple[int, int, int, int],
    period_w: int,
    period_h: int,
    palette: np.ndarray,
    keep_mask_fn=None,
    min_blob_area: int = 96,
) -> np.ndarray:
    """Extrait une fenêtre à l'échelle 1:1 pixel-art (`NEAREST` vers `(canvas_w, canvas_h)` sans
    miniaturisation en confettis !), assure sa continuité périodique `(period_h, period_w)` sur ses
    4 bords, quantifie sans tramage sur `palette`, et supprime tout petit grain isolé."""
    full_up = np.asarray(
        src_img.convert("RGB").resize((canvas_w, canvas_h), Image.Resampling.NEAREST),
        dtype=np.float32,
    )
    x0, y0, x1, y1 = crop_box
    crop = full_up[y0:y1, x0:x1]
    if crop.shape[1] != period_w or crop.shape[0] != period_h:
        crop = np.asarray(
            Image.fromarray(crop.astype(np.uint8), mode="RGB").resize((period_w, period_h), Image.Resampling.NEAREST),
            dtype=np.float32,
        )

    # Fondu cosinus uniquement sur une bande étroite de raccord aux bords (préserve 100 % les gros amas nets au cœur !)
    margin_x = max(8, period_w // 6)
    wx_1d = np.ones(period_w, dtype=np.float32)
    ramp_x = 0.5 - 0.5 * np.cos(np.pi * np.arange(margin_x, dtype=np.float32) / float(margin_x))
    wx_1d[:margin_x] = ramp_x
    wx_1d[-margin_x:] = ramp_x[::-1]
    sx = crop * wx_1d[None, :, None] + np.roll(crop, period_w // 2, axis=1) * (1.0 - wx_1d[None, :, None])

    margin_y = max(8, period_h // 6)
    wy_1d = np.ones(period_h, dtype=np.float32)
    ramp_y = 0.5 - 0.5 * np.cos(np.pi * np.arange(margin_y, dtype=np.float32) / float(margin_y))
    wy_1d[:margin_y] = ramp_y
    wy_1d[-margin_y:] = ramp_y[::-1]
    sxy = np.clip(
        np.rint(sx * wy_1d[:, None, None] + np.roll(sx, period_h // 2, axis=0) * (1.0 - wy_1d[:, None, None])),
        0,
        255,
    ).astype(np.uint8)

    q_rgb = quantize_rgb_to_palette(sxy, palette)
    rgba = np.zeros((period_h, period_w, 4), dtype=np.uint8)
    rgba[:, :, :3] = q_rgb
    rgba[:, :, 3] = 255

    if keep_mask_fn is not None:
        keep = keep_mask_fn(q_rgb)
        pad = 8
        wrapped = np.pad(keep, pad, mode="wrap")
        wrapped = ndimage.binary_closing(wrapped, iterations=1)
        wrapped = ndimage.binary_opening(wrapped, iterations=1)
        keep_clean = wrapped[pad:-pad, pad:-pad]
        if min_blob_area > 1:
            lbl, n_lbl = ndimage.label(keep_clean)
            if n_lbl > 0:
                sizes = ndimage.sum(keep_clean, lbl, index=range(1, n_lbl + 1))
                valid = np.zeros(n_lbl + 1, dtype=bool)
                for idx_b, sz in enumerate(sizes, start=1):
                    if sz >= min_blob_area:
                        valid[idx_b] = True
                keep_clean = valid[lbl]
        rgba[~keep_clean] = 0

    return rgba


def render_symmetric_stream_frames(
    tile_rgba: np.ndarray,
    width: int,
    height: int,
    step_inward_x: int,
    step_upward_y: int,
    n_frames: int = N_FRAMES,
    mask_keep: Optional[np.ndarray] = None,
) -> List[Image.Image]:
    """Génère `n_frames` trames `RGBA` `(width, height)` parfaitement symétriques autour de `x = width // 2` :
    - Gauche (`x < mid`) : vitesse physique `(dx = +step_inward_x, dy = -step_upward_y)`
    - Droite (`x >= mid`) : vitesse physique `(dx = -step_inward_x, dy = -step_upward_y)`
    Continuité mathématique exacte à `x = mid - 1 | mid` à CHAQUE trame `t = 0..n_frames-1` !
    """
    ph, pw, _ = tile_rgba.shape
    assert (n_frames * abs(step_inward_x)) % pw == 0, (
        f"Non périodique en X : {n_frames} * {step_inward_x} vs pw={pw}"
    )
    assert (n_frames * abs(step_upward_y)) % ph == 0, (
        f"Non périodique en Y : {n_frames} * {step_upward_y} vs ph={ph}"
    )
    mid = width // 2
    xs_left = mid - 1 - np.arange(mid, dtype=np.int32)
    xs_right = np.arange(width - mid, dtype=np.int32)
    xs_sym = np.concatenate([xs_left, xs_right], axis=0)  # shape (width,)
    ys = np.arange(height, dtype=np.int32)

    frames: List[Image.Image] = []
    for t in range(n_frames):
        ux = (xs_sym + step_inward_x * t) % pw
        vy = (ys + step_upward_y * t) % ph
        frame = tile_rgba[vy[:, None], ux[None, :]].copy()
        if mask_keep is not None:
            frame[~mask_keep] = 0
        frames.append(Image.fromarray(frame, mode="RGBA"))
    return frames


def composite_sprite_periodic_path(
    frames_arr: List[np.ndarray],
    sprite: Image.Image,
    x0: float,
    y0: float,
    x1: float,
    y1: float,
    phase: int = 0,
    arc_px: float = 0.0,
    fade_ends: bool = True,
) -> None:
    """Fait voyager un sprite de nuage entier le long d'une trajectoire courbe fluide
    entre `(x0, y0)` et `(x1, y1)` sur `N_FRAMES` avec apparition/disparition en crénelage net
    d'échelle pixel-art (aucune semi-transparence floue !)."""
    n = len(frames_arr)
    h_canvas, w_canvas, _ = frames_arr[0].shape
    sp_w, sp_h = sprite.size

    # Prépare 3 tailles pixel-art nettes (petit bourgeon -> plein cumulus -> effilé) pour l'entrée/sortie douce sans alpha flou !
    s_small = sprite.resize((max(6, sp_w // 2), max(6, sp_h // 2)), Image.Resampling.NEAREST)
    s_med = sprite.resize((max(8, (sp_w * 3) // 4), max(8, (sp_h * 3) // 4)), Image.Resampling.NEAREST)

    for k in range(n):
        t_idx = (k + phase) % n
        u = t_idx / float(n)
        if fade_ends:
            if u < 0.08 or u > 0.92:
                continue
            elif u < 0.18 or u > 0.82:
                cur = s_small
            elif u < 0.28 or u > 0.72:
                cur = s_med
            else:
                cur = sprite
        else:
            cur = sprite

        cx = int(round(x0 + (x1 - x0) * u + arc_px * np.sin(np.pi * u)))
        cy = int(round(y0 + (y1 - y0) * u))
        cw, ch = cur.size
        px = cx - cw // 2
        py = cy - ch // 2

        sub = np.asarray(cur, dtype=np.uint8)
        x_start = max(0, px)
        y_start = max(0, py)
        x_end = min(w_canvas, px + cw)
        y_end = min(h_canvas, py + ch)
        if x_end <= x_start or y_end <= y_start:
            continue
        sx0 = x_start - px
        sy0 = y_start - py
        patch = sub[sy0 : sy0 + (y_end - y_start), sx0 : sx0 + (x_end - x_start)]
        m = patch[:, :, 3] > 0
        dst = frames_arr[k][y_start:y_end, x_start:x_end]
        dst[m] = patch[m]


def load_bpl_cyan_ramp(bpl_json_path: Path, palette: np.ndarray) -> List[Tuple[int, int, int]]:
    """Charge la table matérielle GBA `D13P01.bpl` (`palette_9_cloud_plumes`, 8 phases exactes
    étalées sur les `24` trames `24 = 3 * 8` sans aucun saut) et rabat chaque nuance sur `palette`."""
    data = json.loads(bpl_json_path.read_text(encoding="utf-8"))
    frames8 = data["palette_9_cloud_plumes"]["frames"]
    # L'entrée 1 de la palette 9 porte l'onde lumineuse cyan-blanc du sommet de nuage GBA
    slot_cycle = [fr[1][:3] for fr in frames8]
    ramp24: List[Tuple[int, int, int]] = []
    for t in range(N_FRAMES):
        idx = (t * len(slot_cycle)) // N_FRAMES
        rgb = np.array([[slot_cycle[idx]]], dtype=np.uint8)
        q = quantize_rgb_to_palette(rgb, palette)[0, 0]
        ramp24.append((int(q[0]), int(q[1]), int(q[2])))
    return ramp24


# ---------------------------------------------------------------------------
# Export complet RogueEssence 0.8.12 (.rsground + .tile + index.idx + rendus + ZIP)
# ---------------------------------------------------------------------------


def compose_frame(layers: Sequence[LayerEntry], frame_idx: int) -> Image.Image:
    w, h = layers[0].frames[0].size
    canvas = Image.new("RGBA", (w, h), (0, 0, 0, 255))
    for layer in layers:
        n_lf = len(layer.frames)
        if n_lf <= 1:
            fr = layer.frames[0]
        elif n_lf == N_FRAMES:
            fr = layer.frames[frame_idx % n_lf]
        else:
            tick = frame_idx * FRAME_TICKS
            fr = layer.frames[(tick // max(1, int(layer.frame_length))) % n_lf]
        canvas.alpha_composite(fr)
    return canvas


def build_rsground_package(
    map_id: str,
    map_title: str,
    layers: Sequence[LayerEntry],
    walk_grid: np.ndarray,
    renders_dir: Path,
    virtual_zip_path: Path,
    canonical_ref_for_fidelity: Optional[Path] = None,
    max_fidelity_distance: float = 32.0,
    max_unique_tiles_per_bank: int = 12000,
    namespace_override: Optional[str] = None,
    asset_name_override: Optional[str] = None,
) -> Dict[str, object]:
    """Assemble, vérifie, exporte tous les rendus + le paquet `.rsground` + `.tile` + `index.idx`
    et archive le `.zip` virtuel servi sur `/renders/.../<MAP_ID>_PMDO_0.8.12.zip`."""
    renders_dir.mkdir(parents=True, exist_ok=True)
    layers_out_dir = renders_dir / "layers"
    frames_out_dir = renders_dir / "frames"
    layers_out_dir.mkdir(parents=True, exist_ok=True)
    frames_out_dir.mkdir(parents=True, exist_ok=True)

    w_px, h_px = layers[0].frames[0].size
    assert w_px % TILE_SIZE == 0 and h_px % TILE_SIZE == 0
    gw, gh = w_px // TILE_SIZE, h_px // TILE_SIZE
    assert walk_grid.shape == (gh, gw), f"Grille collision {walk_grid.shape} != {(gh, gw)}"

    # Export des 24 trames composites + pose 0 de chaque couche
    comp_frames: List[Image.Image] = []
    for t in range(N_FRAMES):
        cf = compose_frame(layers, t)
        comp_frames.append(cf)
        cf.save(frames_out_dir / f"frame_{t:02d}.png")

    comp_frames[0].save(renders_dir / "composite_pose0.png")
    comp_frames[N_FRAMES // 2].save(renders_dir / "composite_pose12.png")
    comp_frames[0].save(
        renders_dir / "animation_24frames.webp",
        save_all=True,
        append_images=comp_frames[1:],
        duration=int(round(1000 * FRAME_TICKS / 60.0)),
        loop=0,
        lossless=True,
        quality=100,
    )

    for layer in layers:
        layer.frames[0].save(layers_out_dir / f"{layer.slug}.png")

    fid_score: Optional[float] = None
    if canonical_ref_for_fidelity is not None:
        fid_score = float(fidelity(renders_dir / "composite_pose0.png", canonical_ref_for_fidelity))
        assert_fidelity_below(
            renders_dir / "composite_pose0.png",
            canonical_ref_for_fidelity,
            max_distance=max_fidelity_distance,
        )

    # Construction binaire conforme à 100 % au schéma natif RogueEssence 0.8.12.0 (`FVS1` / `pmdo_cote`)
    pkg_dir = renders_dir / "package"
    if pkg_dir.exists():
        shutil.rmtree(pkg_dir)
    ground_dir = pkg_dir / "Data" / "Ground"
    tile_dir = pkg_dir / "Content" / "Tile"
    ground_dir.mkdir(parents=True, exist_ok=True)
    tile_dir.mkdir(parents=True, exist_ok=True)

    tpl = json.loads((REPO_ROOT / "cliffdaytest.rsground").read_text(encoding="utf-8"))
    obj = tpl["Object"]

    namespace = namespace_override or f"tour_celeste_{map_id.lower()}"
    asset_name = asset_name_override or f"{map_id.lower()}_tour_celeste"
    pmdo_layers: List[Dict[str, object]] = []
    banks: List[object] = []
    tile_counts: Dict[str, int] = {}

    for idx_l, layer_entry in enumerate(layers):
        sheet_id = f"{map_id}_{idx_l:02d}_{layer_entry.slug.upper()}"
        bank = GFX_MOD.TileBank(sheet_id)
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)
        pose_arrays = [np.asarray(f.convert("RGBA"), dtype=np.uint8) for f in layer_entry.frames]

        def cell_fn(x: int, y: int, p_arrays=pose_arrays, b=bank):
            fs = []
            for a in p_arrays:
                sub = a[y * TILE_SIZE : (y + 1) * TILE_SIZE, x * TILE_SIZE : (x + 1) * TILE_SIZE]
                f_ref = b.add(Image.fromarray(sub, mode="RGBA"), x, y)
                fs.append(f_ref if f_ref else {"Sheet": b.name, "TexLoc": {"X": 0, "Y": 0}})
            if all(f["TexLoc"] == {"X": 0, "Y": 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs

        draw_layer = 4 if layer_entry.layer_kind == "Top" else 0
        label = (
            f"{idx_l:02d} {layer_entry.name}"
            + (f" ({len(layer_entry.frames)} phases)" if len(layer_entry.frames) > 1 else "")
        )
        pmdo_layers.append(GFX_MOD.layer(label, gw, gh, cell_fn, int(layer_entry.frame_length), draw=draw_layer))
        banks.append(bank)

        unique_n = len(bank.data)
        assert unique_n <= max_unique_tiles_per_bank, (
            f"Dépassement de budget `.tile` sur {sheet_id}: {unique_n} > {max_unique_tiles_per_bank}"
        )
        tile_counts[sheet_id] = unique_n

    pmdo_layers.append(GFX_MOD.layer(f"{len(pmdo_layers):02d} Vos elements avant-plan (Top)", gw, gh, draw=4))

    for bank in banks:
        bank.write(tile_dir / f"{bank.name}.tile")

    nodes = {}
    for p_tile in sorted(tile_dir.glob("*.tile")):
        with p_tile.open("rb") as fh:
            nodes[p_tile.stem] = TOOLS_MOD.read_node(fh)
    (tile_dir / "index.idx").write_bytes(TOOLS_MOD.encode_index(nodes))

    blocked = ~walk_grid
    south_free = [c for c in range(gw - 1) if not blocked[gh - 2 :, c : c + 2].any()]
    cx_ent = south_free[len(south_free) // 2] if south_free else gw // 2
    wy_all, wx_all = np.where(walk_grid)
    cx_center = int(wx_all.mean()) * TILE_SIZE if wy_all.size else (w_px // 2 - 8)
    cy_center = int(wy_all.mean()) * TILE_SIZE if wy_all.size else (h_px // 2 - 8)

    def _mk(ent_name: str, px_xy: List[int], direction: int = 0) -> Dict[str, object]:
        return {
            "EntName": ent_name,
            "Direction": direction,
            "EntEnabled": True,
            "triggerType": 0,
            "Collider": {"X": int(px_xy[0]), "Y": int(px_xy[1]), "Width": 16, "Height": 16},
        }

    obj.update(
        Name={"DefaultText": map_title, "LocalTexts": {"fr": map_title}},
        AssetName=asset_name,
        Released=False,
        TexSize=1,
        Music="",
        EdgeView=1,
        ViewCenter=None,
        ViewOffset={"X": 0, "Y": 0},
        ActiveChar=None,
        Status={},
        Layers=pmdo_layers,
        Background={"$type": "RogueEssence.Dungeon.LayeredBG, RogueEssence", "Layers": []},
        Comment=f"PMDO 0.8.12 - {map_title} ({map_id}) - nuages multi-trames 24 poses (boucle 120 ticks).",
    )
    obj["obstacles"] = [
        [{"Bounds": {"X": x * TILE_SIZE, "Y": y * TILE_SIZE, "Width": TILE_SIZE, "Height": TILE_SIZE}, "Tags": int(blocked[y, x])} for y in range(gh)]
        for x in range(gw)
    ]
    obj["Entities"] = [
        {
            "Name": "Entrees et acteurs",
            "Visible": True,
            "MapChars": [],
            "GroundObjects": [],
            "Spawners": [],
            "Markers": [_mk("entrance", [cx_ent * TILE_SIZE, h_px - 16], 0), _mk("center", [cx_center, cy_center], 0)],
        }
    ]
    obj["Decorations"] = [{"Name": "Vos decorations", "Layer": 2, "Visible": True, "Anims": []}]
    tpl["Version"] = "0.8.12.0"

    GFX_MOD.save(
        ground_dir / f"{asset_name}.rsground",
        json.dumps(tpl, ensure_ascii=False, separators=(",", ":")).encode("utf-8"),
    )
    GFX_MOD.save(
        pkg_dir / "Data" / "Script" / namespace / "ground" / asset_name / "init.lua",
        f"local {asset_name} = {{}}\nreturn {asset_name}\n".encode("utf-8"),
    )

    ident = uuid.uuid5(uuid.NAMESPACE_URL, f"pmdo-0812-tour-celeste-{namespace}")
    (pkg_dir / "Mod.xml").write_text(
        f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>{map_title} (4:3) - PMDO 0.8.12</Name>
  <Author></Author>
  <Description>{map_title} — carte multicalque 10 couches avec nuages animes multi-trames (24 poses, boucle 120 ticks).</Description>
  <Namespace>{namespace}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
""",
        encoding="utf-8",
    )

    installer_src = (REPO_ROOT / "source/pmdo_cote/INSTALLER.py").read_text(encoding="utf-8")
    needle = "            relative = src.relative_to(source)\n"
    if needle in installer_src:
        installer_src = installer_src.replace(
            needle,
            needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n",
        )
    (pkg_dir / "INSTALLER.py").write_text(installer_src, encoding="utf-8")

    # Archive `.zip` déterministe prête à déposer dans un mod RogueEssence 0.8.12
    virtual_zip_path.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(virtual_zip_path, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for file_p in sorted(pkg_dir.rglob("*")):
            if file_p.is_file():
                rel = file_p.relative_to(pkg_dir).as_posix()
                zi = zipfile.ZipInfo(rel, date_time=(2026, 10, 22, 12, 0, 0))
                zi.compress_type = zipfile.ZIP_DEFLATED
                zf.writestr(zi, file_p.read_bytes())

    # Relocalisation transparente des binaires `.tile` vers `.cache/tiles/<slug>/` (hors snapshot Git/disque)
    if renders_dir.resolve().parent == (REPO_ROOT / "renders").resolve():
        cache_tile_dir = REPO_ROOT / ".cache" / "tiles" / renders_dir.name
        cache_tile_dir.mkdir(parents=True, exist_ok=True)
        for tfile in sorted((pkg_dir / "Content" / "Tile").glob("*.tile")):
            if not tfile.is_symlink():
                dst_cache = cache_tile_dir / tfile.name
                shutil.move(str(tfile), str(dst_cache))
                os.symlink(os.path.relpath(dst_cache, tfile.parent), tfile)
        for fpng in sorted((renders_dir / "frames").glob("frame_*.png")):
            if fpng.name not in ("frame_00.png", "frame_06.png", "frame_12.png", "frame_18.png"):
                fpng.unlink(missing_ok=True)

    meta = {
        "map_id": map_id,
        "title": map_title,
        "size_px": [w_px, h_px],
        "grid_tiles": [gw, gh],
        "n_frames": N_FRAMES,
        "frame_ticks": FRAME_TICKS,
        "loop_ticks": LOOP_TICKS,
        "fidelity_distance": round(fid_score, 3) if fid_score is not None else None,
        "walkable_tiles": int(walk_grid.sum()),
        "total_tiles": int(gw * gh),
        "unique_tiles_per_sheet": tile_counts,
        "total_unique_tiles": int(sum(tile_counts.values())),
        "zip_bytes": int(virtual_zip_path.stat().st_size),
        "layers": [
            {
                "slug": l.slug,
                "name": l.name,
                "kind": l.layer_kind,
                "poses": len(l.frames),
                "frame_length": l.frame_length,
            }
            for l in layers
        ],
    }
    (renders_dir / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta
