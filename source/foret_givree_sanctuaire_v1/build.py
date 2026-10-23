#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
FGA1 — Sanctuaire de la Forêt Givrée — Artikodin (`1×` natif Chunsoft GBA `H24P01` + Neige `W03P03`).

Fidélité texture & pixel-art `100 %` native à `H24P01` (*Frosty Grotto / Frigid Cavern — PMD Red*) :
- Décodage matériel direct `H24P01.{bpl,bpc,bma}` (`0` trône factice ajouté, `0` bassins bleus factices, `0` lissage) ;
- Séparation exacte sur les slots de palette matériels Chunsoft (`pal_map == 1` : grand Médaillon Flocon de Cristal
  à 6 branches ; `pal_map == 4` : crevasses et parois glaciaires bleutées `#FF00FF`) ;
- Neige tombante matérielle authentique GBA `W03P03` (`W03P031.bpa`).
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
    build_gba_weather_overlay_frames,
    load_gba_map_bundle,
    make_layer_rgba,
    render_gba_native,
    resize_nearest_mask,
    resize_nearest_rgba,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "FGA1"
MAP_TITLE = "Sanctuaire de la Forêt Givrée — Artikodin"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_foret_givree_sanctuaire.png"
REF_DIR = HERE / "references"
H24P01_REF = REF_DIR / "h24p01_articuno_sanctuary_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "foret_givree_sanctuaire_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    nat_rgba, nat_pm, _ = render_gba_native("H24P01", phase=None, bpa_frame=0)

    # Slots matériels Chunsoft exacts de H24P01 :
    # - `pal_map == 1` : Grand Médaillon Flocon de Cristal central à 6 branches d'Artikodin
    # - `pal_map == 4` : Parois, stalactites & crevasses de glace bleue translucide
    nat_medallion = nat_pm == 1
    nat_glacial_ice = nat_pm == 4

    full_rgba = resize_nearest_rgba(nat_rgba, w, h)
    rgb = full_rgba[:, :, :3]
    medallion_mask = resize_nearest_mask(nat_medallion, w, h)
    glacial_mask = resize_nearest_mask(nat_glacial_ice, w, h) & (~medallion_mask)

    if w == W_CANON and h == H_CANON:
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        brut = rgb.copy()
        brut[medallion_mask | glacial_mask] = PURE_MAGENTA
        Image.fromarray(brut, mode="RGB").save(DECOR_MAGENTA_RAW)

    static_mask = ~(medallion_mask | glacial_mask)
    yy, xx = np.mgrid[:h, :w]

    b_h24 = load_gba_map_bundle("H24P01")
    pal = np.unique(b_h24["base_pals"][:, 1:, :3].reshape(-1, 3), axis=0).astype(np.uint8)

    # Partition sémantique `1×` Chunsoft de `H24P01` :
    # - Arène centrale enneigée & empreintes de pas (`y >= 0.30h`, couloir central + esplanade Sud)
    # - Corniche Nord sculptée, stalactites & Totems de Neige d'Artikodin (`07_totems_et_corniche_glace_h24p01`, 1 pose statique !)
    arena_corridor = (
        ((yy >= int(0.30 * h)) & (yy <= int(0.76 * h)) & (xx >= int(0.18 * w)) & (xx <= int(0.82 * w)))
        | ((yy >= int(0.70 * h)) & (xx >= int(0.32 * w)) & (xx <= int(0.68 * w)))
    )
    walkable_pixels = arena_corridor & (~glacial_mask)
    arena_snow = static_mask & arena_corridor
    north_totems_and_ledge = static_mask & (~arena_snow) & (yy < int(0.46 * h))
    south_crags = static_mask & (~arena_snow) & (~north_totems_and_ledge) & (yy >= int(0.68 * h))
    side_ice_walls = static_mask & (~arena_snow) & (~north_totems_and_ledge) & (~south_crags)

    # Couche 00 : Socle glaciaire exact `H24P01`
    im_00_bg = make_layer_rgba(rgb, np.ones((h, w), dtype=bool))

    # Couche 01 : Parois & crevasses de glace bleue `pal_map == 4` (`12 × 10 = 120` ticks, grain `1×` `H24P01` intact !)
    tau = 2.0 * np.pi
    frames_01_ice: List[Image.Image] = []
    for f in range(12):
        im_f = make_layer_rgba(rgb, glacial_mask)
        a = np.asarray(im_f, dtype=np.uint8).copy()
        if f > 0:
            pulse = 0.5 - 0.5 * np.cos(tau * f / 12.0)
            sh = np.sin(tau * ((xx.astype(np.float32) * 0.5 + yy.astype(np.float32) * 0.7) / max(96.0, w * 0.28) - f / 12.0))
            delta = np.round((10.0 + 12.0 * np.maximum(0.0, sh)) * pulse).astype(np.int32)[:, :, None]
            mod = np.clip(rgb.astype(np.int32) + delta, 0, 250).astype(np.uint8)
            a[glacial_mask, :3] = mod[glacial_mask]
        frames_01_ice.append(Image.fromarray(a, mode="RGBA"))

    # Couche 02 : Grand Médaillon Flocon de Cristal à 6 branches `pal_map == 1` (`12 × 10 = 120` ticks, contours 100 % nets !)
    rad = np.hypot(xx.astype(np.float32) - w * 0.50, (yy.astype(np.float32) - h * 0.49) * 1.35)
    frames_02_medallion: List[Image.Image] = []
    for f in range(12):
        im_f = make_layer_rgba(rgb, medallion_mask)
        a = np.asarray(im_f, dtype=np.uint8).copy()
        if f > 0:
            pulse = np.sin(tau * (rad / max(48.0, w * 0.14) - f / 12.0))
            delta_m = np.round(18.0 * np.maximum(0.0, pulse)).astype(np.int32)[:, :, None]
            mod_m = np.clip(rgb.astype(np.int32) + delta_m, 0, 252).astype(np.uint8)
            a[medallion_mask, :3] = mod_m[medallion_mask]
        frames_02_medallion.append(Image.fromarray(a, mode="RGBA"))

    # Couche 03 : Scintillements prismatiques sur le Médaillon & les stalactites (`15 × 8 = 120` ticks)
    prism_zone = ndimage.binary_dilation(medallion_mask | glacial_mask, iterations=1) & (medallion_mask | glacial_mask)
    frames_03_prism: List[Image.Image] = []
    for f in range(15):
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        if f > 0:
            sp = prism_zone & ((((xx // 4) * 17 + (yy // 4) * 11 + f * 5) % 13) == 0)
            arr[sp, :3] = np.array([248, 252, 255], dtype=np.uint8)
            arr[sp, 3] = 255
        frames_03_prism.append(Image.fromarray(arr, mode="RGBA"))

    im_04_arena = make_layer_rgba(rgb, arena_snow)
    im_05_south = make_layer_rgba(rgb, south_crags)
    im_06_sides = make_layer_rgba(rgb, side_ice_walls)
    im_07_totems = make_layer_rgba(rgb, north_totems_and_ledge)

    # Couches 08 & 09 : Chute de neige canonique GBA `W03P03` (`W03P031.bpa`)
    snow_bg = build_gba_weather_overlay_frames(
        "W03P03",
        w=w,
        h=h,
        n_frames=12,
        scroll_dx_per_loop=-24,
        scroll_dy_per_loop=48,
        tint_palette=[(216, 232, 248), (240, 248, 255)],
        subsample_keep_mod=6,
    )
    snow_top = build_gba_weather_overlay_frames(
        "W03P03",
        w=w,
        h=h,
        n_frames=15,
        scroll_dx_per_loop=-32,
        scroll_dy_per_loop=72,
        tint_palette=[(236, 244, 255), (248, 252, 255)],
        subsample_keep_mod=7,
    )

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_pixels[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.55

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_fond_glaciaire_h24p01", "Socle Glaciaire Natif H24P01 1×", "BG", [im_00_bg], frame_length=5),
        LayerEntry("01_crevasses_glace_bleue_h24p01", "Crevasses & Parois de Glace H24P01", "BG", frames_01_ice, frame_length=10),
        LayerEntry("02_medaillon_flocon_cristal_h24p01", "Médaillon Flocon de Cristal H24P01", "BG", frames_02_medallion, frame_length=10),
        LayerEntry("03_scintillements_glace_h24p01", "Éclats Prismatiques de Givre H24P01", "BG", frames_03_prism, frame_length=8),
        LayerEntry("04_arene_neige_empreintes_h24p01", "Arène Enneigée & Empreintes H24P01", "BG", [im_04_arena], frame_length=5),
        LayerEntry("05_rochers_glaces_sud_h24p01", "Rochers & Congères Sud H24P01", "BG", [im_05_south], frame_length=5),
        LayerEntry("06_parois_laterales_glace_h24p01", "Parois Latérales de Glace H24P01", "BG", [im_06_sides], frame_length=5),
        LayerEntry("07_totems_et_corniche_glace_h24p01", "Corniche Nord, Stalactites & Totems H24P01", "BG", [im_07_totems], frame_length=5),
        LayerEntry("08_poudreuse_sanctuaire_w03p03", "Poudreuse Cristalline GBA W03P03 1×", "BG", snow_bg, frame_length=10),
        LayerEntry("09_neige_sanctuaire_w03p03_top", "Neige Tombante Canonique GBA W03P03 1×", "Top", snow_top, frame_length=8),
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
        canonical_ref_for_fidelity=H24P01_REF,
        max_fidelity_distance=5.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="foret_givree_fga1",
        asset_name_override="foret_givree_sanctuaire",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
