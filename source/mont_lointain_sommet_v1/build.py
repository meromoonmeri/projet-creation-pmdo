#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MLS1 — Sommet du Mont Lointain — Ho-Oh (`1:1` natif Chunsoft GBA `B72` + Arcs-en-Ciel `H05P02`).

Fidélité texture & pixel-art `100 %` native `1:1` (`576 px = 576 px` sans rééchantillonnage !) :
- Plateau sacré d'ivoire craquelé, grand escalier Sud et 12 piliers karstiques moussus extraits à `1:1` exact
  depuis `b72_mt_faraway_hooh.png` (`528 × 576` centrés dans `768 × 576`, ailes nuageuses prolongées ligne à ligne) ;
- Arcs-en-ciel latéraux extraits pixel par pixel depuis `H05P02` (`slots 5, 7, 9`, zéro courbe vectorielle !) ;
- Découpe `#FF00FF` pure sur `bruts/decor_sommet_hooh_ref_widescreen.png` pour tout le ciel, la mer de nuages
  et les arcs-en-ciel ; zéro contour noir (`max(R, G, B) >= 100` partout).
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

from moteur_gba_pmd_red_natif import (  # type: ignore
    PURE_MAGENTA,
    make_layer_rgba,
    render_gba_native,
    resize_nearest_rgba,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "MLS1"
MAP_TITLE = "Sommet du Mont Lointain — Arc-en-Ciel"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "decor_sommet_hooh_ref_widescreen.png"
REF_DIR = HERE / "references"
B72_REF = REF_DIR / "b72_mt_faraway_hooh.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_lointain_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _compose_1x_widescreen_b72_and_h05p02() -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Assemble à `1:1` pixel-pour-pixel (`768 × 576`) `b72_mt_faraway_hooh.png` (`528 × 576` utiles)
    et les arcs-en-ciel pixel-art natifs de `H05P02` (`slots 5, 7, 9`)."""
    b72 = np.asarray(Image.open(B72_REF).convert("RGB"), dtype=np.uint8)
    core = b72[:, :528, :]  # Exclut la marge droite cyan `x = 528..576` du buffer GBA 72×72

    canvas = np.zeros((H_CANON, W_CANON, 3), dtype=np.uint8)
    x0 = (W_CANON - 528) // 2  # `x0 = 120`, aligné au multiple exact de 8 px (`15` tuiles) !
    canvas[:, x0 : x0 + 528, :] = core

    # Extension `1:1` sans couture des bandes horizontales de ciel azur & de mer de nuages dorés `b72`
    left_strip = core[:, :24, :]
    right_strip = core[:, -24:, :]
    for k in range(5):
        canvas[:, k * 24 : (k + 1) * 24, :] = left_strip if (k % 2 == 0) else left_strip[:, ::-1, :]
        rx = x0 + 528 + k * 24
        canvas[:, rx : rx + 24, :] = right_strip if (k % 2 == 0) else right_strip[:, ::-1, :]

    # Répétition `1:1` de deux aiguilles karstiques lointaines `b72` sur les ailes nuageuses gauche & droite
    left_spire_patch = core[70:132, 168:206, :]
    right_spire_patch = core[74:128, 320:352, :]
    canvas[78:140, 56:94, :] = left_spire_patch
    canvas[82:136, 678:710, :] = right_spire_patch

    # Détection exacte du ciel azur & de la mer de nuages dorés de `b72`
    r = canvas[:, :, 0].astype(np.int16)
    g = canvas[:, :, 1].astype(np.int16)
    b = canvas[:, :, 2].astype(np.int16)
    yy, xx = np.mgrid[:H_CANON, :W_CANON]

    sky_mask = (b - r >= 60) & (g >= 200)
    # Plateau central d'ivoire sacré de Ho-Oh vs mer de nuages extérieure
    in_arena_box = (
        (yy >= 134)
        & (yy <= 436)
        & (xx >= x0 + 48)
        & (xx <= x0 + 480)
    )
    pale_cream = (~sky_mask) & (r >= 242) & (g >= 240) & (b >= 184)
    lbl_cream, _ = ndimage.label(pale_cream)
    edge_ids = (
        set(lbl_cream[:, 0].tolist())
        | set(lbl_cream[:, -1].tolist())
        | set(lbl_cream[-1, :].tolist())
    ) - {0}
    cloud_mask = np.isin(lbl_cream, list(edge_ids))

    # Greffe `1:1` complète des deux grands arcs-en-ciel latéraux de `H05P02` (`slots 5..9` intégraux !)
    nat_h05, pm_h05, _ = render_gba_native("H05P02", phase=None, bpa_frame=0)
    rb_native = np.isin(pm_h05, [5, 6, 7, 8, 9])
    rb_left_src = nat_h05[88:272, 48:188, :3]
    rb_left_m = rb_native[88:272, 48:188]
    rb_right_src = nat_h05[88:272, 268:408, :3]
    rb_right_m = rb_native[88:272, 268:408]

    rainbow_mask = np.zeros((H_CANON, W_CANON), dtype=bool)
    ly0, lx0 = 152, 8
    ry0, rx0 = 152, W_CANON - 8 - rb_right_src.shape[1]
    l_valid = rb_left_m & cloud_mask[ly0 : ly0 + rb_left_m.shape[0], lx0 : lx0 + rb_left_m.shape[1]]
    r_valid = rb_right_m & cloud_mask[ry0 : ry0 + rb_right_m.shape[0], rx0 : rx0 + rb_right_m.shape[1]]

    sub_l = canvas[ly0 : ly0 + rb_left_m.shape[0], lx0 : lx0 + rb_left_m.shape[1]]
    sub_l[l_valid] = np.maximum(rb_left_src[l_valid], 104)
    sub_r = canvas[ry0 : ry0 + rb_right_m.shape[0], rx0 : rx0 + rb_right_m.shape[1]]
    sub_r[r_valid] = np.maximum(rb_right_src[r_valid], 104)
    rainbow_mask[ly0 : ly0 + rb_left_m.shape[0], lx0 : lx0 + rb_left_m.shape[1]] |= l_valid
    rainbow_mask[ry0 : ry0 + rb_right_m.shape[0], rx0 : rx0 + rb_right_m.shape[1]] |= r_valid

    # Garantie pastel stricte `max(R, G, B) >= 100` sur l'intégralité du sommet sacré de Ho-Oh
    maxc = canvas.max(axis=2)
    dark = maxc < 100
    if np.any(dark):
        lift = (100 - maxc[dark])[:, None]
        canvas[dark] = np.clip(canvas[dark].astype(np.int32) + lift, 0, 255).astype(np.uint8)

    return canvas, sky_mask, cloud_mask & (~rainbow_mask), rainbow_mask


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    canvas_canon, sky_c, cloud_c, rainbow_c = _compose_1x_widescreen_b72_and_h05p02()

    if w == W_CANON and h == H_CANON:
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        brut = canvas_canon.copy()
        brut[sky_c | cloud_c | rainbow_c] = PURE_MAGENTA
        Image.fromarray(brut, mode="RGB").save(DECOR_MAGENTA_RAW)
        rgb = canvas_canon
        sky_mask, cloud_mask, rainbow_mask = sky_c, cloud_c, rainbow_c
    else:
        rgba_c = np.dstack([canvas_canon, np.full((H_CANON, W_CANON), 255, dtype=np.uint8)])
        rgb = resize_nearest_rgba(rgba_c, w, h)[:, :, :3]
        sky_mask = np.asarray(
            Image.fromarray((sky_c * 255).astype(np.uint8)).resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8
        ) > 127
        cloud_mask = (
            np.asarray(
                Image.fromarray((cloud_c * 255).astype(np.uint8)).resize((w, h), Image.Resampling.NEAREST),
                dtype=np.uint8,
            )
            > 127
        ) & (~sky_mask)
        rainbow_mask = (
            np.asarray(
                Image.fromarray((rainbow_c * 255).astype(np.uint8)).resize((w, h), Image.Resampling.NEAREST),
                dtype=np.uint8,
            )
            > 127
        ) & (~sky_mask)

    static_massif = ~(sky_mask | cloud_mask | rainbow_mask)
    yy, xx = np.mgrid[:h, :w]
    pal = np.unique(rgb.reshape(-1, 3), axis=0).astype(np.uint8)

    # Plateau central d'ivoire sacré de Ho-Oh + Grand Escalier Sud -> marche Sud (`y = 71`) reliée continûment !
    ivory_floor = (
        static_massif
        & (rgb[:, :, 0] >= 220)
        & (rgb[:, :, 1] >= 216)
        & (yy >= int(0.24 * h))
        & (yy <= int(0.76 * h))
        & (xx >= int(0.26 * w))
        & (xx <= int(0.74 * w))
    )
    south_stair_corridor = (yy >= int(0.66 * h)) & (xx >= int(0.41 * w)) & (xx <= int(0.59 * w))
    walkable_pixels = ivory_floor | south_stair_corridor

    distant_spires = static_massif & (yy < int(0.25 * h))
    ferns = static_massif & ((rgb[:, :, 1].astype(int) - rgb[:, :, 0].astype(int)) >= 14)
    stairs_south = static_massif & (~ivory_floor) & (~ferns) & (yy >= int(0.66 * h)) & (xx >= int(0.38 * w)) & (xx <= int(0.62 * w))
    arena_plateau = ivory_floor
    outer_pillars = static_massif & (~distant_spires) & (~ferns) & (~stairs_south) & (~arena_plateau)

    # Fond continu de ciel azur & mer de nuages dorés `b72`
    bg_cloud_sky = rgb.copy()
    for y_row in range(h):
        c_row = cloud_mask[y_row] | sky_mask[y_row]
        if np.any(c_row):
            col_row = np.median(rgb[y_row, c_row], axis=0).astype(np.uint8)
            bg_cloud_sky[y_row, static_massif[y_row] | rainbow_mask[y_row]] = col_row

    im_00_sky = make_layer_rgba(bg_cloud_sky, np.ones((h, w), dtype=bool))

    # Couche 01 : Mer de nuages dorés `b72` animée (`12 × 10 = 120` ticks, `pose0` = 0 décalage !)
    frames_01_clouds: List[Image.Image] = []
    for f in range(12):
        sh = 0 if f == 0 else int(round(np.sin(2.0 * np.pi * f / 12.0) * max(6.0, w * 0.03)))
        rolled = np.roll(rgb, shift=sh, axis=1)
        # Empêche tout glissement de roche dans le masque nuages lors du roll horizontal
        bad = rolled.min(axis=2) < 175
        rolled = rolled.copy()
        rolled[bad] = bg_cloud_sky[bad]
        frames_01_clouds.append(make_layer_rgba(rolled, cloud_mask | rainbow_mask))

    # Couche 02 : Arcs-en-ciel pixel-art `1:1` `H05P02` (`12 × 10 = 120` ticks)
    frames_02_rainbows: List[Image.Image] = []
    for f in range(12):
        rb = rgb.copy()
        if f > 0:
            wave = np.sin(2.0 * np.pi * (yy.astype(np.float32) / max(28.0, h * 0.12) - f / 12.0))
            glow = rainbow_mask & (wave > 0.10)
            rb[glow] = np.clip(rb[glow].astype(np.int32) + 14, 104, 252).astype(np.uint8)
        frames_02_rainbows.append(make_layer_rgba(rb, rainbow_mask))

    im_03_spires = make_layer_rgba(rgb, distant_spires)
    im_04_stairs = make_layer_rgba(rgb, stairs_south)
    im_05_arena = make_layer_rgba(rgb, arena_plateau)
    im_06_pillars = make_layer_rgba(rgb, outer_pillars)
    im_07_ferns = make_layer_rgba(rgb, ferns)

    # Couches 08 & 09 : Volutes nuageuses naturelles `b72` & poussière d'arc-en-ciel sacrée de Ho-Oh (`0` strie !)
    b72_crests = cloud_mask & (rgb[:, :, 2] >= 220)
    frames_08_mist: List[Image.Image] = []
    for f in range(12):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if f > 0:
            sh = int(round(np.sin(2.0 * np.pi * f / 12.0) * max(10.0, w * 0.045)))
            band = np.roll(b72_crests, shift=sh, axis=1) & cloud_mask
            arr[band] = np.array([254, 252, 224, 255], dtype=np.uint8)
        frames_08_mist.append(Image.fromarray(arr, mode="RGBA"))

    spark_cols = [(252, 236, 172), (228, 248, 196), (212, 244, 248), (248, 224, 224)]
    frames_09_sparks: List[Image.Image] = []
    for f in range(15):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if f > 0:
            sp = (arena_plateau | rainbow_mask) & ((((xx // 4) * 17 + (yy // 4) * 11 + f * 5) % 89) == 0)
            c = spark_cols[f % len(spark_cols)]
            arr[sp] = np.array([c[0], c[1], c[2], 255], dtype=np.uint8)
        frames_09_sparks.append(Image.fromarray(arr, mode="RGBA"))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_pixels[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.50

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_ciel_azur_b72", "Ciel Azur Canonique B72 1:1", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_mer_nuages_doree_b72", "Mer de Nuages Dorés Canonique B72 1:1", "BG", frames_01_clouds, frame_length=10),
        LayerEntry("02_arcs_en_ciel_h05p02", "Arcs-en-Ciel Pixel-Art GBA H05P02 1:1", "BG", frames_02_rainbows, frame_length=10),
        LayerEntry("03_aiguilles_karst_horizon_b72", "Aiguilles Karstiques d'Horizon B72 1:1", "BG", [im_03_spires], frame_length=5),
        LayerEntry("04_escalier_sacre_sud_b72", "Grand Escalier Sacré Sud B72 1:1", "BG", [im_04_stairs], frame_length=5),
        LayerEntry("05_plateau_ivoire_hooh_b72", "Plateau d'Ivoire Sacré de Ho-Oh B72 1:1", "BG", [im_05_arena], frame_length=5),
        LayerEntry("06_piliers_karstiques_b72", "Douze Piliers Karstiques Moussus B72 1:1", "BG", [im_06_pillars], frame_length=5),
        LayerEntry("07_fougeres_suspendues_b72", "Fougères Émeraude Suspendues B72 1:1", "BG", [im_07_ferns], frame_length=5),
        LayerEntry("08_echarpes_nuageuses_dorees", "Écharpes Nuageuses Dorées du Sommet", "BG", frames_08_mist, frame_length=10),
        LayerEntry("09_plumes_arc_en_ciel_hooh_top", "Éclats de Plume Arc-en-Ciel Ho-Oh", "Top", frames_09_sparks, frame_length=8),
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
        max_fidelity_distance=10.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mont_lointain_mls1",
        asset_name_override="mont_lointain_sommet",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
