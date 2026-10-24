#!/usr/bin/env python3
"""Constructeur PMDO `0.8.12.0` — `FAS1` (*Fosse d'Argent — Sanctuaire Abyssal de Lugia / Silver Trench 99F*).

Architecture `768 × 576` (`96 × 72` tuiles `8×8`), `10` calques (`9 BG` + `1 Top`), `0 px` de ciel :
  - Sanctuaire englouti `#FF00FF` (`bruts/decor_sanctuaire_lugia_fosse_argent_magenta.png`) nettoyé sans
    aucun halo rose/violet et quantifié en `96` couleurs `MEDIANCUT` (`dither=NONE`, alpha binaire `{0, 255}`) ;
  - Fosse abyssale animée combinant le **Courant Marin Profond officiel de Lugia (`H02P02` *Deep-Sea Current*)**
    et les **4 phases d'eau animée *Metano Town* (`Metano_Town_River_Animation_1..4.tile`)** + éclats
    `Metano_Town_River_Sparkles.tile` ;
  - Calque `09 Top` portant les **5 faisceaux lumineux sous-marins verticaux officiels Chunsoft `H02P02W`**
    illuminant l'Autel d'Argent de Lugia + sommets des colonnes antiques en surplomb + particules d'Aéroblast.
"""

from __future__ import annotations

import json
import math
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

REPO_ROOT = Path(__file__).resolve().parents[2]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from source.moteur_cyclones_cylindriques_unova import sanitize_rgba_binary
from source.moteur_forets_pmd_red import _downsample_non_mixing
from source.moteur_fosse_argent_lugia import (
    H_CANON,
    TILE_SIZE,
    W_CANON,
    build_h02p02_vortex_frames,
    build_h02p02w_light_shafts_top,
    build_metano_caustic_sparkles_frames,
    clean_magenta_cutout_strict,
    quantize_foreground_96_abyssal,
)
from source.moteur_gba_pmd_red_natif import make_layer_rgba, render_gba_native
from source.tour_celeste_moteur_nuages import LayerEntry, build_rsground_package

HERE = Path(__file__).resolve().parent
RAW_DIR = HERE / "bruts"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "fosse_argent_sanctuaire_v1"

DECOR_MAGENTA_RAW = RAW_DIR / "decor_sanctuaire_lugia_fosse_argent_magenta.png"
CANONICAL_REF = REF_DIR / "FAS1_canonical_lugia_sanctuary.png"
H02P02_REF = REF_DIR / "H02P02_deep_sea_current_pmd_red.png"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / "FAS1_PMDO_0.8.12.zip"

MAP_ID = "FAS1"
MAP_TITLE = "Fosse d'Argent — Sanctuaire Abyssal de Lugia (Silver Trench 99F)"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    REF_DIR.mkdir(parents=True, exist_ok=True)
    if not H02P02_REF.is_file():
        h02_rgba, _, _ = render_gba_native("H02P02", phase=None, bpa_frame=0)
        Image.fromarray(h02_rgba[:, :, :3], mode="RGB").save(H02P02_REF)

    raw_src = np.asarray(Image.open(DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)
    clean_src, fg_src = clean_magenta_cutout_strict(raw_src)
    fg_rgb_raw, fg_mask = _downsample_non_mixing(clean_src, fg_src, out_w=w, out_h=h)
    fg_rgb = quantize_foreground_96_abyssal(fg_rgb_raw, fg_mask)
    trench_mask = ~fg_mask

    yy, xx = np.mgrid[:h, :w]

    # Calques 00 & 01 : Abîme bathyal + Grand Vortex du Courant Marin Profond `H02P02` + Eau 4 phases Metano (`8 poses @ 15t = 120t`)
    im_00_abyss, frames_01_vortex = build_h02p02_vortex_frames(w, h, trench_mask, n_frames=8)

    # Calque 02 : Éclats caustiques & écume sous-marine `Metano_Town_River_Sparkles.tile` (`6 poses @ 20t = 120t`)
    frames_02_sparkles = build_metano_caustic_sparkles_frames(w, h, trench_mask, n_frames=6, seed=24902)

    # Segmentation architecturale nette du sanctuaire englouti (`fg_mask`, 100 % statique sur `03..07`) :
    r = fg_rgb[:, :, 0].astype(np.int32)
    g = fg_rgb[:, :, 1].astype(np.int32)
    b = fg_rgb[:, :, 2].astype(np.int32)
    lum = 0.25 * r + 0.50 * g + 0.25 * b

    # Coraux / anémones bioluminescents cyan & blanc-azur (`H02P01` style)
    bio_glow = fg_mask & (((g >= 188) & (b >= 220) & (r <= 110)) | ((g >= 224) & (b >= 238) & (r >= 180)))

    # Grand escalier Sud (`x ∈ [0.39w, 0.61w]`, `y >= 0.64h`)
    south_stairway = fg_mask & (~bio_glow) & (xx >= int(0.39 * w)) & (xx <= int(0.61 * w)) & (yy >= int(0.64 * h))

    # Falaises basaltiques englouties soutenant l'île (`lum < 78` hors zone haute des aiguilles)
    lower_cliffs = fg_mask & (~bio_glow) & (~south_stairway) & (yy >= int(0.50 * h)) & (lum < 86.0)

    # Autel Nord surélevé de Lugia aux anneaux concentriques d'argent (`x ∈ [0.35w, 0.65w]`, `y <= 0.36h`)
    lugia_altar = fg_mask & (~bio_glow) & (xx >= int(0.35 * w)) & (xx <= int(0.65 * w)) & (yy <= int(0.36 * h))

    # Colonnes antiques cannelées & aiguilles rocheuses périphériques (`x < 0.35w` ou `x > 0.65w` dans la moitié Nord/latérale,
    # ou roches sombres verticales `lum < 86` sur le pourtour)
    lateral_ring = (
        (xx < int(0.34 * w))
        | (xx > int(0.66 * w))
        | (lum < 84.0)
    )
    columns_and_spires = fg_mask & (~bio_glow) & (~south_stairway) & (~lower_cliffs) & (~lugia_altar) & lateral_ring

    # Grande arène circulaire centrale & dallage sacré de la Fosse d'Argent (tout le reste de `fg_mask` hors `bio_glow`)
    central_arena = fg_mask & (~bio_glow) & (~south_stairway) & (~lower_cliffs) & (~lugia_altar) & (~columns_and_spires)

    im_03_cliffs = make_layer_rgba(fg_rgb, lower_cliffs)
    im_04_stairs = make_layer_rgba(fg_rgb, south_stairway)
    im_05_arena = make_layer_rgba(fg_rgb, central_arena)
    im_06_altar = make_layer_rgba(fg_rgb, lugia_altar)
    im_07_columns = make_layer_rgba(fg_rgb, columns_and_spires | bio_glow)

    # Calque 08 : Bioluminescence pulsante des anémones/coraux cyan + fines bulles d'argent (`8 poses @ 15t = 120t`)
    rng_b = np.random.default_rng(24988)
    n_bub = 26
    bx0 = rng_b.integers(max(8, w // 12), max(16, w - w // 12), size=n_bub)
    by0 = rng_b.integers(max(12, h // 10), max(24, h - h // 12), size=n_bub)
    bph = rng_b.uniform(0.0, 2.0 * math.pi, size=n_bub)

    frames_08_biolum: List[Image.Image] = []
    for f in range(8):
        theta = 2.0 * math.pi * f / 8.0
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if f in (2, 3, 4, 5):
            pulse_px = bio_glow & (((xx + yy + f) % 2) == 0)
            arr[pulse_px, :3] = np.clip(fg_rgb[pulse_px].astype(np.int16) + np.array([20, 28, 16], dtype=np.int16), 0, 255).astype(np.uint8)
            arr[pulse_px, 3] = 255
        for i in range(n_bub):
            px = int(round(bx0[i] + 2.0 * math.sin(theta + bph[i])))
            py = int((by0[i] - int(round((f / 8.0) * max(16, h // 10)))) % (h - 16)) + 8
            if 4 <= px < w - 4 and 4 <= py < h - 4:
                arr[py, px] = (216, 250, 255, 255)
                if py + 1 < h - 4:
                    arr[py + 1, px] = (104, 208, 248, 255)
        frames_08_biolum.append(Image.fromarray(sanitize_rgba_binary(arr)))

    # Calque 09 Top : Les 5 faisceaux sous-marins verticaux officiels Chunsoft `H02P02W` (`8 poses @ 15t = 120t`)
    # + chapiteaux hauts des deux grandes colonnes encadrant l'autel Nord (`y <= 0.12h`)
    capitals_mask = fg_mask & (yy <= int(0.11 * h)) & ((xx < int(0.43 * w)) | (xx > int(0.57 * w)))
    canopy_rgba = np.asarray(make_layer_rgba(fg_rgb, capitals_mask), dtype=np.uint8)
    frames_09_top = build_h02p02w_light_shafts_top(w, h, canopy_rgba, n_frames=8, shaft_alpha=46)

    # Référence canonique de fidélité à la pose 0 (`768 × 576`)
    if w == W_CANON and h == H_CANON and not CANONICAL_REF.is_file():
        comp0 = Image.new("RGBA", (w, h), (0, 0, 0, 255))
        for im_l in (
            im_00_abyss,
            frames_01_vortex[0],
            frames_02_sparkles[0],
            im_03_cliffs,
            im_04_stairs,
            im_05_arena,
            im_06_altar,
            im_07_columns,
            frames_08_biolum[0],
            frames_09_top[0],
        ):
            comp0 = Image.alpha_composite(comp0, im_l)
        comp0.convert("RGB").save(CANONICAL_REF)

    # Grille de marche : Grand escalier Sud (`y = gh - 1` -> `0.64h`) + Arène circulaire centrale + Marches & Autel de Lugia
    ell_arena = (((xx - w * 0.50) / (w * 0.26)) ** 2 + ((yy - h * 0.51) / (h * 0.20)) ** 2) <= 1.0
    ell_altar = (((xx - w * 0.50) / (w * 0.11)) ** 2 + ((yy - h * 0.24) / (h * 0.095)) ** 2) <= 1.0
    stair_south_walk = (xx >= int(0.43 * w)) & (xx <= int(0.57 * w)) & (yy >= int(0.58 * h))
    stair_north_walk = (xx >= int(0.45 * w)) & (xx <= int(0.55 * w)) & (yy >= int(0.24 * h)) & (yy <= int(0.42 * h))

    walkable_px = fg_mask & (~bio_glow) & (lum >= 82.0) & (ell_arena | ell_altar | stair_south_walk | stair_north_walk)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_px[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.45

    # Garantit la continuité de l'escalier Sud jusqu'au bord inférieur `y = gh - 1`
    walk_grid[int(0.65 * gh) : gh, int(0.45 * gw) : int(0.55 * gw)] = True

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    pal = np.unique(fg_rgb[fg_mask].reshape(-1, 3), axis=0).astype(np.uint8)

    layers = [
        LayerEntry("00_abime_bathyal_fosse_argent", "Abîme Bathyal Cobalt H02P02", "BG", [im_00_abyss], frame_length=5),
        LayerEntry("01_vortex_courant_marin_h02p02", "Grand Vortex H02P02 & Courants Metano", "BG", frames_01_vortex, frame_length=15),
        LayerEntry("02_caustiques_abyssales_metano", "Caustiques Sous-Marines Metano Sparkles", "BG", frames_02_sparkles, frame_length=20),
        LayerEntry("03_falaises_basaltiques_englouties", "Parois Basaltiques de la Fosse d'Argent", "BG", [im_03_cliffs], frame_length=5),
        LayerEntry("04_grand_escalier_argent_sud", "Grand Escalier Sous-Marin Sud", "BG", [im_04_stairs], frame_length=5),
        LayerEntry("05_arene_circulaire_fosse_argent", "Arène Sacrée de Pierre d'Argent", "BG", [im_05_arena], frame_length=5),
        LayerEntry("06_autel_concentrique_lugia_nord", "Autel Nord aux Anneaux d'Argent de Lugia", "BG", [im_06_altar], frame_length=5),
        LayerEntry("07_colonnes_antiques_et_anemones", "Colonnes Cannelées, Aiguilles & Anémones", "BG", [im_07_columns], frame_length=5),
        LayerEntry("08_bioluminescence_et_bulles_argent", "Bioluminescence Corallienne & Bulles d'Argent", "BG", frames_08_biolum, frame_length=15),
        LayerEntry("09_rayons_divins_h02p02w_aeroblast_top", "5 Rayons Sous-Marins H02P02W & Souffle Marin Top", "Top", frames_09_top, frame_length=15),
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
        canonical_ref_for_fidelity=CANONICAL_REF if CANONICAL_REF.is_file() else H02P02_REF,
        max_fidelity_distance=6.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="fosse_argent_fas1",
        asset_name_override="fosse_argent_sanctuaire_lugia",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
