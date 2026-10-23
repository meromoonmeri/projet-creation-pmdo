#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MBA1 — Cime du Mont Brasier — Sulfura (`1×` natif Chunsoft GBA `H19P01` + `H19P011.bpa` + `H19P01W` + `W04`).

Fidélité texture & pixel-art `100 %` native à `H19P01` (*Mt. Blaze Peak / Fire Island — Sulfura, PMD Red*) :
- Cratère concentrique incandescent `1×` exact (`slots 1, 2, 3, 6, 7, 8, 9` découpés en `#FF00FF` pur sur le brut) ;
- Fumerolles volcaniques animées par les `7` frames matérielles GBA `H19P011.bpa` (`slot 9`) ;
- Double panache de fumée volcanique animé par `H19P01W` (`H19P01W.bpl`, `17` frames matérielles GBA) ;
- Flammèches volcaniques authentiques GBA `W04` (`W041.bpa`).
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

MAP_ID = "MBA1"
MAP_TITLE = "Cime du Mont Brasier — Sulfura"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_mont_brasier_sommet.png"
REF_DIR = HERE / "references"
H19P01_REF = REF_DIR / "h19p01_moltres_crater_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_brasier_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    nat_rgba0, nat_pm0, _ = render_gba_native("H19P01", phase=None, bpa_frame=0)
    rgb0 = resize_nearest_rgba(nat_rgba0, w, h)[:, :, :3]

    # Slots matériels Chunsoft de `H19P01` :
    # - `pal_map ∈ {1, 2, 3, 6, 7, 8, 9}` : Cratère concentrique en fusion & bouches de fumerolles (`#FF00FF` dans le brut !)
    # - `pal_map ∈ {0, 4, 5}` : Pics et remparts extérieurs de basalte calciné (strictement statiques)
    crater_magma_mask = resize_nearest_mask(np.isin(nat_pm0, [1, 2, 3, 6, 7, 8, 9]), w, h)
    core_magma_mask = resize_nearest_mask(np.isin(nat_pm0, [3, 7, 8]), w, h) & crater_magma_mask
    vent_mask = resize_nearest_mask(nat_pm0 == 9, w, h) & crater_magma_mask
    ring_magma_mask = crater_magma_mask & (~core_magma_mask) & (~vent_mask)

    if w == W_CANON and h == H_CANON:
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        brut = rgb0.copy()
        brut[crater_magma_mask] = PURE_MAGENTA
        Image.fromarray(brut, mode="RGB").save(DECOR_MAGENTA_RAW)

    static_rim = ~crater_magma_mask
    yy, xx = np.mgrid[:h, :w]

    b_h19 = load_gba_map_bundle("H19P01")
    pal = np.unique(b_h19["base_pals"][:, 1:, :3].reshape(-1, 3), axis=0).astype(np.uint8)

    # Arène centrale du cratère accessible du Sud (`y = 71`) jusqu'au cœur incandescent de Sulfura (`y = 32..40, x = 44..52`)
    walkable_pixels = (
        ((yy >= int(0.34 * h)) & (yy <= int(0.78 * h)) & (xx >= int(0.24 * w)) & (xx <= int(0.76 * w)))
        | ((yy >= int(0.70 * h)) & (xx >= int(0.36 * w)) & (xx <= int(0.64 * w)))
    ) & (~vent_mask)

    north_crown = static_rim & (yy < int(0.38 * h))
    south_crags = static_rim & (~north_crown) & (yy >= int(0.68 * h))
    inner_rim = static_rim & (~north_crown) & (~south_crags) & (xx >= int(0.26 * w)) & (xx <= int(0.74 * w))
    outer_peaks = static_rim & (~north_crown) & (~south_crags) & (~inner_rim)

    # Couche 00 : Fond du cratère au repos `H19P01` (`0.00` écart à `pose0` !)
    im_00_bg = make_layer_rgba(rgb0, np.ones((h, w), dtype=bool))

    # Couches 01, 02, 03, 08 : `12` poses × `10` ticks = `120` ticks (`pose0` = repos exact, `pose12` = idx `6` = apogée thermique !)
    frames_01_rings: List[Image.Image] = []
    frames_02_core: List[Image.Image] = []
    frames_03_vents: List[Image.Image] = []
    frames_08_smoke: List[Image.Image] = []

    rad = np.hypot((xx.astype(np.float32) - w * 0.50) * 0.85, (yy.astype(np.float32) - h * 0.54) * 1.25)
    tau = 2.0 * np.pi

    for f in range(12):
        if f == 0:
            rk = rgb0.copy()
            frames_01_rings.append(make_layer_rgba(rk, ring_magma_mask))
            frames_02_core.append(make_layer_rgba(rk, core_magma_mask))
            frames_03_vents.append(make_layer_rgba(rk, vent_mask))
            frames_08_smoke.append(Image.fromarray(np.zeros((h, w, 4), dtype=np.uint8), mode="RGBA"))
            continue

        phase = f / 12.0
        nat_f, _, _ = render_gba_native("H19P01", phase=phase, bpa_frame=(f * 7) // 12)
        rk = resize_nearest_rgba(nat_f, w, h)[:, :, :3]

        # Onde thermique concentrique sur les anneaux orangés/pourpres du cratère (`slots 1, 2, 6`)
        ring_rgb = rk.copy()
        pulse = np.sin(tau * (rad / max(36.0, w * 0.09) - phase))
        boost = ring_magma_mask & (pulse > 0.15)
        deep = ring_magma_mask & (pulse < -0.25)
        ring_rgb[boost] = np.clip(
            ring_rgb[boost].astype(np.int32) + np.array([20, 26, 8], dtype=np.int32), 0, 248
        ).astype(np.uint8)
        ring_rgb[deep] = np.clip(
            ring_rgb[deep].astype(np.int32) - np.array([16, 18, 8], dtype=np.int32), 0, 248
        ).astype(np.uint8)

        frames_01_rings.append(make_layer_rgba(ring_rgb, ring_magma_mask))
        frames_02_core.append(make_layer_rgba(rk, core_magma_mask))
        frames_03_vents.append(make_layer_rgba(rk, vent_mask))

        # Panaches jumeaux de fumée volcanique `H19P01W` (strictement hors bordures blanches de découpe GBA !)
        smoke_nat, _, _ = render_gba_native("H19P01W", phase=phase, bpa_frame=0)
        smoke_rgba = resize_nearest_rgba(smoke_nat, w, h)
        s_arr = np.zeros((h, w, 4), dtype=np.uint8)
        s_int = smoke_rgba[:, :, 0].astype(np.int32)
        not_white_corner = rgb0.min(axis=2) < 228
        s_on = (smoke_rgba[:, :, 3] > 0) & (s_int >= 40) & (s_int <= 220) & not_white_corner
        s_arr[s_on, 0] = np.clip(144 + s_int[s_on] // 2, 0, 240).astype(np.uint8)
        s_arr[s_on, 1] = np.clip(84 + s_int[s_on] // 3, 0, 200).astype(np.uint8)
        s_arr[s_on, 2] = np.clip(56 + s_int[s_on] // 5, 0, 144).astype(np.uint8)
        s_arr[s_on, 3] = np.clip(s_int[s_on] + 24, 48, 116).astype(np.uint8)
        frames_08_smoke.append(Image.fromarray(s_arr, mode="RGBA"))

    im_04_inner = make_layer_rgba(rgb0, inner_rim)
    im_05_south = make_layer_rgba(rgb0, south_crags)
    im_06_peaks = make_layer_rgba(rgb0, outer_peaks)
    im_07_crown = make_layer_rgba(rgb0, north_crown)

    embers_top = build_gba_weather_overlay_frames(
        "W04",
        w=w,
        h=h,
        n_frames=15,
        scroll_dx_per_loop=-24,
        scroll_dy_per_loop=-64,
        tint_palette=[(248, 168, 56), (248, 232, 136)],
        subsample_keep_mod=6,
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
        LayerEntry("00_socle_cratere_h19p01", "Socle du Cratère Natif H19P01 1×", "BG", [im_00_bg], frame_length=5),
        LayerEntry("01_anneaux_magma_concentriques_h19p01", "Anneaux de Magma Concentriques H19P01", "BG", frames_01_rings, frame_length=10),
        LayerEntry("02_coeur_incandescent_sulfura_h19p01", "Cœur Incandescent GBA H19P01.bpl", "BG", frames_02_core, frame_length=10),
        LayerEntry("03_fumerolles_volcaniques_h19p01_bpa", "Fumerolles Animées GBA H19P011.bpa", "BG", frames_03_vents, frame_length=10),
        LayerEntry("04_rebord_interne_basalte_h19p01", "Rebord Interne du Cratère H19P01", "BG", [im_04_inner], frame_length=5),
        LayerEntry("05_escarpements_sud_h19p01", "Escarpements Volcaniques Sud H19P01", "BG", [im_05_south], frame_length=5),
        LayerEntry("06_pics_volcaniques_est_ouest_h19p01", "Pics Volcaniques Est & Ouest H19P01", "BG", [im_06_peaks], frame_length=5),
        LayerEntry("07_couronne_rocheuse_nord_h19p01", "Couronne Rocheuse Nord H19P01", "BG", [im_07_crown], frame_length=5),
        LayerEntry("08_panaches_fumee_h19p01w", "Panaches de Fumée Volcanique GBA H19P01W", "BG", frames_08_smoke, frame_length=10),
        LayerEntry("09_flammeches_sulfura_w04_top", "Flammèches Volcaniques Canoniques GBA W04 1×", "Top", embers_top, frame_length=8),
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
        canonical_ref_for_fidelity=H19P01_REF,
        max_fidelity_distance=4.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mont_brasier_mba1",
        asset_name_override="mont_brasier_sommet",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
