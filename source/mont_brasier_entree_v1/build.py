#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MBE1 — Mont Brasier — Entrée (`POV PMD`, référence canonique `d09p01_mt_blaze_native.png`).

Fidélité maximale à `D09P01` (*Mt. Blaze Entrance — PMD Red*) + découpe stricte `#FF00FF` :
- Seuls les pixels `#FF00FF` vrais (`R >= 220 & G <= 35 & B >= 220`) sont traités comme lave (0 confusion
  avec les ombres gris-violet des piliers basaltiques de `D09P01` !) ;
- Les 2 grandes cascades latérales s'écoulent strictement à l'intérieur des 2 chenaux `#FF00FF` ;
- Le dallage craquelé et les colonnes hexagonales sont étalonnés directement sur la palette GBA de `D09P01`.
"""

from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
if str(REPO_ROOT / "source") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "source"))

from moteur_eau_et_glace_canonique_pmd import sanitize_palette_no_magenta  # type: ignore
from moteur_magma_canonique_pmd_red import (  # type: ignore
    DARK_CRATER_VISCOUS_PAL,
    build_canonical_w04_embers_frames,
    build_dark_crater_pit_magma_frames,
    build_dark_crater_rim_glow_frames,
    render_dark_crater_viscous_shoreline,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
    extract_canonical_palette,
    quantize_rgb_to_palette,
)

MAP_ID = "MBE1"
MAP_TITLE = "Mont Brasier — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_mont_brasier_entree.png"
REF_DIR = HERE / "references"
D09P01_REF = REF_DIR / "d09p01_mt_blaze_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_brasier_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _build_twin_lava_cascades(w: int, h: int, shaft_mask: np.ndarray, n_phases: int = 24) -> List[Image.Image]:
    """Écoulement vertical canonique `Dark Crater` strictement confiné dans `shaft_mask` (`left + right`)."""
    sp_mg = importlib.util.spec_from_file_location("mbe_mg", REPO_ROOT / "source" / "magma_visqueux" / "magma.py")
    mg = importlib.util.module_from_spec(sp_mg)  # type: ignore[arg-type]
    sp_mg.loader.exec_module(mg)  # type: ignore[union-attr]

    _, xx = np.mgrid[:h, :w]
    left_shaft = shaft_mask & (xx < w // 2)
    right_shaft = shaft_mask & (xx >= w // 2)

    left_frames, _ = mg.cascade_phases(left_shaft, seed=17, falls=2, phases=n_phases, foot_rows=8)
    right_frames, _ = mg.cascade_phases(right_shaft, seed=29, falls=2, phases=n_phases, foot_rows=8)

    out: List[Image.Image] = []
    for t in range(n_phases):
        canvas = np.zeros((h, w, 4), dtype=np.uint8)
        lf = left_frames[t]
        rf = right_frames[t]
        ml = (lf[:, :, 3] > 0) & shaft_mask
        mr = (rf[:, :, 3] > 0) & shaft_mask
        canvas[ml] = lf[ml]
        canvas[mr] = rf[mr]
        out.append(Image.fromarray(canvas, mode="RGBA"))
    return out


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_im = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    decor_rgb = np.asarray(raw_im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    yy, xx = np.mgrid[:h, :w]
    r_raw = decor_rgb[:, :, 0].astype(np.int16)
    g_raw = decor_rgb[:, :, 1].astype(np.int16)
    b_raw = decor_rgb[:, :, 2].astype(np.int16)

    # 1. Détection stricte du pur `#FF00FF` (aucune confusion avec le basalte gris-violet sombre !)
    all_magenta = (r_raw >= 220) & (g_raw <= 35) & (b_raw >= 220)
    lbl_m, n_m = ndimage.label(all_magenta)
    min_chasm = max(400, int(round(2500 * (w * h) / float(W_CANON * H_CANON))))
    open_ids = [cid for cid in range(1, n_m + 1) if int((lbl_m == cid).sum()) >= min_chasm]
    open_lava = np.isin(lbl_m, open_ids)
    lava_veins = all_magenta & (~open_lava)
    rock_mask = ~all_magenta

    # 2. Chaussée craquelée terracotta praticable du Sud (`y = h - 1`) au gouffre Nord (`y ≈ 0.56h`)
    cave_box = (yy >= int(0.28 * h)) & (yy <= int(0.58 * h)) & (xx >= int(0.39 * w)) & (xx <= int(0.61 * w))
    cave_mouth = rock_mask & cave_box & (decor_rgb.max(axis=2) <= 45)

    terracotta_cand = (
        rock_mask
        & (~cave_mouth)
        & ((r_raw - b_raw) >= 34)
        & (r_raw >= 108)
        & (yy >= int(0.52 * h))
        & (~ndimage.binary_dilation(all_magenta, iterations=max(1, int(round(3 * w / 768.0)))))
    )
    terracotta_smooth = ndimage.binary_closing(terracotta_cand, iterations=max(2, int(round(4 * w / 768.0)))) & rock_mask
    lbl_t, _ = ndimage.label(terracotta_smooth)
    south_ids = set(lbl_t[h - 6 :, int(0.35 * w) : int(0.65 * w)].ravel().tolist()) - {0}
    walkable_floor = np.isin(lbl_t, list(south_ids)) & rock_mask & (~cave_mouth)
    walkable_floor = ndimage.binary_fill_holes(walkable_floor) & rock_mask & (~cave_mouth)

    # 3. Étalonnage colorimétrique exact sur `D09P01` :
    #    - Colonnes basaltiques gris-ardoise bleutées sombres (`D09P01` : `[104, 96, 128]`),
    #    - Terracotta rouge-ocre chaud de `D09P01` (`#BC5C46`) sur `walkable_floor` & rochers ocres !
    graded = decor_rgb.astype(np.float32).copy()
    cool_basalt = rock_mask & (~cave_mouth) & ((r_raw - b_raw) < 28)
    graded[cool_basalt, 0] = np.clip(graded[cool_basalt, 0] * 0.68, 0, 255)
    graded[cool_basalt, 1] = np.clip(graded[cool_basalt, 1] * 0.74, 0, 255)
    graded[cool_basalt, 2] = np.clip(graded[cool_basalt, 2] * 0.96 + 18.0, 0, 255)

    warm_stone = rock_mask & ((r_raw - b_raw) >= 28)
    graded[warm_stone, 0] = np.clip(graded[warm_stone, 0] * 0.90, 0, 255)
    graded[warm_stone, 1] = np.clip(graded[warm_stone, 1] * 0.74, 0, 255)
    graded[warm_stone, 2] = np.clip(graded[warm_stone, 2] * 0.86 + 10.0, 0, 255)

    ref_pal = extract_canonical_palette([D09P01_REF], max_colors=72, min_pixels=4)
    dark_anchors = np.array([[8, 6, 10], [18, 14, 20]], dtype=np.uint8)
    pal = sanitize_palette_no_magenta(np.vstack([DARK_CRATER_VISCOUS_PAL, ref_pal, dark_anchors]), max_gap=24)
    q_decor = quantize_rgb_to_palette(graded.astype(np.uint8), pal)
    q_decor[cave_mouth] = np.array([8, 6, 10], dtype=np.uint8)

    # Séparation des deux fûts verticaux de cascades (`y <= 0.67h`) et des deux bassins inférieurs
    waterfall_shafts = open_lava & (yy <= int(0.68 * h))
    pool_zone = open_lava & (yy >= int(0.58 * h))

    fg_basalt = rock_mask & (~walkable_floor) & (~cave_mouth) & (
        (yy >= int(0.58 * h)) | (xx < int(0.11 * w)) | (xx > int(0.89 * w))
    )
    north_basalt = (rock_mask & (~walkable_floor) & (~fg_basalt)) | cave_mouth

    # Couches 00..09
    frames_00_pools = build_dark_crater_pit_magma_frames(w=w, h=h, mask=open_lava, phase_offset=0)

    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[rock_mask, :3] = np.array([72, 46, 48], dtype=np.uint8)
    base_arr[rock_mask, 3] = 255
    im_01_base = Image.fromarray(base_arr, mode="RGBA")

    veins_dil = ndimage.binary_dilation(lava_veins, iterations=1) & all_magenta
    frames_02_veins = build_dark_crater_pit_magma_frames(
        w=w, h=h, mask=veins_dil, phase_offset=6, roll_xy=(32, 24)
    )
    frames_03_cascades = _build_twin_lava_cascades(w=w, h=h, shaft_mask=waterfall_shafts, n_phases=N_FRAMES)

    band_px = max(5.0, 9.5 * (w / float(W_CANON)))
    frames_04_shore = render_dark_crater_viscous_shoreline(pool_zone, n_frames=15, band_px=band_px)

    def _mk_layer(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_decor[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_05_floor = _mk_layer(walkable_floor)
    im_06_north = _mk_layer(north_basalt)
    im_07_fg = _mk_layer(fg_basalt)

    rock_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    rock_rgba[rock_mask, :3] = q_decor[rock_mask]
    rock_rgba[rock_mask, 3] = 255
    frames_08_glow = build_dark_crater_rim_glow_frames(rock_rgba, all_magenta)
    frames_09_embers = build_canonical_w04_embers_frames(w=w, h=h)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_floor[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.55

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_bassins_magma_d41p41a", "Bassins de Magma Canonique d41p41a 1×", "BG", frames_00_pools, frame_length=10),
        LayerEntry("01_socle_volcanique_continu", "Socle Volcanique Continu D09P01", "BG", [im_01_base], frame_length=5),
        LayerEntry("02_veines_fissures_magenta", "Poches & Veines de Magma #FF00FF", "BG", frames_02_veins, frame_length=10),
        LayerEntry("03_cascades_lave_canoniques", "Double Cascade Verticale de Lave D09P01", "BG", frames_03_cascades, frame_length=5),
        LayerEntry("04_rive_visqueuse_bordure_rocher", "Rive Visqueuse & Croûte de Bordure Rocher", "BG", frames_04_shore, frame_length=8),
        LayerEntry("05_dalles_terracotta_chemin", "Chaussée Terracotta Praticable Sud-Nord", "BG", [im_05_floor], frame_length=5),
        LayerEntry("06_colonnes_basalte_nord_seuil", "Colonnes Basaltiques D09P01 & Seuil Nord", "BG", [im_06_north], frame_length=5),
        LayerEntry("07_colonnes_basalte_avant", "Colonnes Basaltiques & Rochers d'Avant-Plan", "BG", [im_07_fg], frame_length=5),
        LayerEntry("08_incandescence_thermique_roche", "Incandescence Thermique de Bordure Rocher", "BG", frames_08_glow, frame_length=8),
        LayerEntry("09_braises_w04_canoniques_top", "Braises Volcaniques Montantes W04 1×", "Top", frames_09_embers, frame_length=7),
    ]
    return layers, walk_grid, pal


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    h = max(64, int(round(H_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    layers, walk_grid, _ = build_layers_for_size(w, h)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=D09P01_REF,
        max_fidelity_distance=34.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mont_brasier_mbe1",
        asset_name_override="mont_brasier_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
