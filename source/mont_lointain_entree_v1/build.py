#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MLE1 — Mont Lointain — Entrée des Piliers Brumeux (`POV PMD`, palette canonique `b72`).

Continuité totale `POV PMD` avec `MLS1` (*Sommet de Ho-Oh*) :
- Ciel bleu-cyan `b72`, mer de nuages dorée dérivante (`01`), Arc-en-Ciel pastel de Ho-Oh (`02`),
  volutes de brume des piliers (`08`) et lueurs dorées sacrées (`09` `Top`) ;
- Piliers karstiques grès-ocre & sauge sans aucun noir, fougères suspendues émeraude (`07`) ;
- Escalier et sentier d'ivoire continus du bord Sud (`y = 71`) jusqu'à l'arche de grotte Nord (`donjon_seuil`).
"""

from __future__ import annotations

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

from moteur_mont_lointain_b72 import (  # type: ignore
    B72_PLATEAU_IVORY,
    B72_STONE_BASE,
    build_b72_sky_and_cloud_sea_layers,
    build_b72_unified_palette,
    build_hooh_mist_and_feathers_layers,
    load_clean_b72_magenta_raw,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
    quantize_rgb_to_palette,
)

MAP_ID = "MLE1"
MAP_TITLE = "Mont Lointain — Entrée"
RAW_DIR = HERE / "bruts"
DECOR_RAW = RAW_DIR / "decor_entree_magenta.png"
REF_DIR = HERE / "references"
B72_REF = REF_DIR / "b72_mt_faraway_hooh.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_lointain_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    im_raw = Image.open(DECOR_RAW).convert("RGB")
    raw_preview = np.asarray(im_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8)
    yy, xx = np.mgrid[:h, :w]

    # 1. Arche sculptée du col Nord (`donjon_seuil`, ombre olive-ambre chaude sans noir pur)
    mouth_box = (yy >= int(0.24 * h)) & (yy <= int(0.40 * h)) & (xx >= int(0.45 * w)) & (xx <= int(0.55 * w))
    portal_mask = mouth_box & (raw_preview.max(axis=2) <= 95)

    clean_rgb, fg_mask = load_clean_b72_magenta_raw(DECOR_RAW, w, h, exclude_portal=portal_mask)
    pal = build_b72_unified_palette(B72_REF)
    q_rgb = quantize_rgb_to_palette(clean_rgb, pal)

    if np.any(portal_mask):
        dist_p = ndimage.distance_transform_edt(portal_mask)
        q_rgb[portal_mask] = np.array([112, 104, 72], dtype=np.uint8)
        q_rgb[portal_mask & (dist_p > 3.0)] = np.array([86, 80, 56], dtype=np.uint8)
        q_rgb[portal_mask & (dist_p > 6.5)] = np.array([64, 60, 44], dtype=np.uint8)

    # 2. Séparation sémantique `b72` : nuages de brume blancs/ivoire vs roches karstiques vs sentier vs fougères
    r = q_rgb[:, :, 0].astype(np.int16)
    g = q_rgb[:, :, 1].astype(np.int16)
    b = q_rgb[:, :, 2].astype(np.int16)

    # Nappes de nuages entourant les piliers karstiques (très claires hors terrasse/sentier central)
    trail_corridor = (
        # Escalier et sentier sinueux Sud -> Terrasse (`y = 0.50h .. 1.00h`)
        ((yy >= int(0.50 * h)) & (xx >= int(0.42 * w)) & (xx <= int(0.56 * w)))
        # Terrasse sacrée devant l'arche (`y = 0.35h .. 0.56h`)
        | ((yy >= int(0.35 * h)) & (yy <= int(0.56 * h)) & (xx >= int(0.38 * w)) & (xx <= int(0.62 * w)))
        # Belvédère latéral Est (`y = 0.30h .. 0.45h`)
        | ((yy >= int(0.30 * h)) & (yy <= int(0.45 * h)) & (xx >= int(0.58 * w)) & (xx <= int(0.75 * w)))
    )
    mist_clouds = fg_mask & (~trail_corridor) & (r >= 225) & (g >= 220) & (b >= 155)
    # Teinter harmonieusement les nuages blancs en crème-ivoire `b72`
    q_rgb[mist_clouds & (r >= 245)] = np.array([255, 255, 215], dtype=np.uint8)
    q_rgb[mist_clouds & (r < 245)] = np.array([247, 239, 175], dtype=np.uint8)

    solid_mountain = fg_mask & (~mist_clouds)
    ferns = solid_mountain & (g >= r + 10) & (g >= b + 28)

    # Sentier et marches d'ivoire praticables du Sud (`y = h - 1`) jusqu'à l'arche Nord (`y ≈ 0.36h`)
    ivory_seed = solid_mountain & trail_corridor & (~portal_mask) & (~ferns) & (r >= 195) & (g >= 190)
    spine_pts = [
        (0.50, 0.995),
        (0.50, 0.84),
        (0.47, 0.72),
        (0.50, 0.60),
        (0.50, 0.46),
        (0.495, 0.375),
    ]
    spine = np.zeros((h, w), dtype=bool)
    hw_px = max(8, int(round(18 * w / 768.0)))
    for (fx0, fy0), (fx1, fy1) in zip(spine_pts[:-1], spine_pts[1:]):
        for s in np.linspace(0.0, 1.0, 40):
            cx = int(round(w * (fx0 + (fx1 - fx0) * s)))
            cy = int(round(h * (fy0 + (fy1 - fy0) * s)))
            spine[max(0, cy - hw_px) : min(h, cy + hw_px), max(0, cx - hw_px) : min(w, cx + hw_px)] = True

    walkable_trail = (ivory_seed | (spine & solid_mountain & (~portal_mask))) & (~ferns)
    # Piliers karstiques lointains isolés entiers (`ndimage.label`, aucune découpe verticale !)
    lbl_sm, n_sm = ndimage.label(solid_mountain)
    if n_sm > 1:
        sm_sizes = ndimage.sum(solid_mountain, lbl_sm, range(1, n_sm + 1))
        main_mountain = lbl_sm == (int(np.argmax(sm_sizes)) + 1)
        far_spires = solid_mountain & (~main_mountain)
    else:
        main_mountain = solid_mountain
        far_spires = np.zeros((h, w), dtype=bool)
    karst_cliffs = main_mountain & (~walkable_trail) & (~ferns)

    # Socle rocheux continu uniquement sous `main_mountain` (ne recouvre jamais `03` !)
    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[main_mountain, :3] = B72_STONE_BASE
    base_arr[walkable_trail, :3] = B72_PLATEAU_IVORY
    base_arr[main_mountain, 3] = 255
    im_04_base = Image.fromarray(base_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[m, :3] = q_rgb[m]
        arr[m, 3] = 255
        return Image.fromarray(arr, mode="RGBA")

    im_00_sky, frames_01_clouds, frames_02_rainbow = build_b72_sky_and_cloud_sea_layers(
        w, h, n_frames=N_FRAMES, horizon_frac=0.19
    )
    im_03_far = _mk_layer(far_spires)
    im_05_cliffs = _mk_layer(karst_cliffs)
    im_06_trail = _mk_layer(walkable_trail)
    im_07_ferns = _mk_layer(ferns)
    frames_08_mist, frames_09_feathers = build_hooh_mist_and_feathers_layers(q_rgb, mist_clouds, n_frames=N_FRAMES)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_trail[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.55

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_ciel_azur_et_mer_nuages_b72", "Ciel Azur b72 & Mer de Nuages", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_rubans_nuages_altitude_derive", "Rubans de Nuages Dorés en Dérive", "BG", frames_01_clouds, frame_length=5),
        LayerEntry("02_arc_en_ciel_sacre_hooh", "Arc-en-Ciel Sacré de Ho-Oh", "BG", frames_02_rainbow, frame_length=5),
        LayerEntry("03_pitons_karstiques_lointains", "Pitons Karstiques Lointains", "BG", [im_03_far], frame_length=5),
        LayerEntry("04_socle_rocheux_continu", "Socle Montagneux Continu", "BG", [im_04_base], frame_length=5),
        LayerEntry("05_piliers_karstiques_et_arche", "Piliers Karstiques & Arche Nord", "BG", [im_05_cliffs], frame_length=5),
        LayerEntry("06_sentier_et_marches_ivoire", "Escalier & Terrasse d'Ivoire Sud-Nord", "BG", [im_06_trail], frame_length=5),
        LayerEntry("07_fougeres_emeraude_parois", "Fougères Émeraude Suspendues", "BG", [im_07_ferns], frame_length=5),
        LayerEntry("08_brumes_piliers_respiration", "Volutes de Brume des Piliers", "BG", frames_08_mist, frame_length=5),
        LayerEntry("09_plumes_dorees_hooh_top", "Plumes & Lueurs Sacrées de Ho-Oh", "Top", frames_09_feathers, frame_length=5),
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
        canonical_ref_for_fidelity=B72_REF,
        max_fidelity_distance=48.0,
        namespace_override="mont_lointain_mle1",
        asset_name_override="mont_lointain_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
