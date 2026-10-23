#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MBA1 — Mont Brasier — Cime de Sulfura (`POV PMD`, référence canonique `h19p01_moltres_crater_native.png`).

Fidélité maximale à `H19P01` (*Volcanic Crater — Sulfura / Moltres*) + découpe 100 % `#FF00FF` :
- Sur `bruts/base_mont_brasier_sommet.png`, le ciel cratérique Nord, toute la caldeira circulaire de magma,
  les failles incandescentes des pitons externes et la rosace volcanique de l'îlot central sont en `#FF00FF` pur ;
- `MBA1_00` (`BG`, `1` pose) : Ciel ivoire-ambre brumeux authentique de `H19P01` ;
- `MBA1_01` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Panaches de fumée volcanique `H19P01` s'élevant au Nord ;
- `MBA1_02` (`BG`, `12` poses @ `10` ticks = `120` ticks) : Mer caldeira de magma canonique `Dark Crater Pit` (`d41p41a` `1×`) ;
- `MBA1_03` (`BG`, `1` pose) : Socle continu de basalte brun-pourpre `H19P01` ;
- `MBA1_04` (`BG`, `12` poses @ `10` ticks = `120` ticks) : Veines & rosace `#FF00FF` dans l'îlot de Sulfura et les pitons ;
- `MBA1_05` (`BG`, `15` poses @ `8` ticks = `120` ticks) : **Animation visqueuse de rive & croûte de bordure rocher** ;
- `MBA1_06` (`BG`, `1` pose) : Îlot central de Sulfura & pont basaltique Sud-Nord praticable ;
- `MBA1_07` (`BG`, `1` pose) : Couronne crénelée Nord & pitons volcaniques périphériques `H19P01` ;
- `MBA1_08` (`BG`, `15` poses @ `8` ticks = `120` ticks) : Incandescence thermique de bordure rocher & fissures ;
- `MBA1_09` (`Top`, `16` poses @ `7` ticks = `112` ticks) : Braises ardentes montantes `W04` `1×`.
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

MAP_ID = "MBA1"
MAP_TITLE = "Mont Brasier — Cime de Sulfura"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_mont_brasier_sommet.png"
REF_DIR = HERE / "references"
H19P01_REF = REF_DIR / "h19p01_moltres_crater_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_brasier_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_h19p01_sky_and_fumaroles(w: int, h: int, n_frames: int = 24) -> Tuple[Image.Image, List[Image.Image]]:
    """Construit le ciel ivoire-chaud canonique de `H19P01` (`y < 0.28h`) + les 6 panaches de fumée
    volcanique montant des cheminées Nord en boucle périodique `24 × 5 = 120` ticks."""
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    sky_max_y = max(16, int(round(0.28 * h)))
    sky_bands = np.array(
        [
            [255, 249, 240],
            [253, 243, 229],
            [249, 234, 215],
            [243, 221, 198],
            [232, 204, 180],
        ],
        dtype=np.uint8,
    )
    b_idx = np.clip((yy.astype(np.int32) * len(sky_bands)) // sky_max_y, 0, len(sky_bands) - 1)
    sky_arr = np.zeros((h, w, 4), dtype=np.uint8)
    sky_arr[:, :, :3] = sky_bands[b_idx]
    sky_arr[:, :, 3] = 255
    im_sky = Image.fromarray(sky_arr, mode="RGBA")

    smoke_pal = np.array(
        [
            [222, 204, 190],
            [202, 180, 166],
            [182, 156, 144],
        ],
        dtype=np.uint8,
    )
    vent_xs = [0.16 * w, 0.25 * w, 0.37 * w, 0.63 * w, 0.75 * w, 0.84 * w]
    frames: List[Image.Image] = []
    yf_norm = np.clip(1.0 - yy / float(sky_max_y), 0.0, 1.0)
    for t in range(n_frames):
        frac = float(t) / float(n_frames)
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        for i, vx in enumerate(vent_xs):
            sgn = 1.0 if i >= 3 else -1.0
            # Ruban de fumée volcanique sinueux façon H19P01 s'évasant vers le haut en boucle périodique
            spine_x = (
                vx
                + sgn * (16.0 * (w / 768.0)) * yf_norm
                + (7.5 * (w / 768.0)) * np.sin(2.0 * np.pi * (2.0 * yf_norm - frac) + i * 1.1)
            )
            half_w = (4.5 + 11.5 * yf_norm) * (w / 768.0) * (
                0.78 + 0.28 * np.sin(2.0 * np.pi * (3.0 * yf_norm - frac) + i)
            )
            dx = np.abs(xx - spine_x)
            in_plume = (yy < sky_max_y) & (dx <= half_w)
            in_core = (yy < sky_max_y) & (dx <= 0.48 * half_w)
            arr[in_plume, :3] = smoke_pal[0]
            arr[in_plume, 3] = 255
            arr[in_core, :3] = smoke_pal[1]
            inner_dark = in_core & (yf_norm < 0.45)
            arr[inner_dark, :3] = smoke_pal[2]
        frames.append(Image.fromarray(arr, mode="RGBA"))
    return im_sky, frames


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_im = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    decor_rgb = np.asarray(raw_im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    yy, xx = np.mgrid[:h, :w]
    r = decor_rgb[:, :, 0].astype(np.int16)
    g = decor_rgb[:, :, 1].astype(np.int16)
    b = decor_rgb[:, :, 2].astype(np.int16)

    # 1. Séparation exacte des composantes `#FF00FF` :
    #    - `sky_magenta`     : composantes `#FF00FF` touchant le bord supérieur `y == 0`
    #    - `caldera_chasm`   : grande mer annulaire de magma autour de l'îlot central
    #    - `rock_veins`      : failles `#FF00FF` des pitons externes + rosace `#FF00FF` de l'îlot central
    all_magenta = (np.minimum(r, b) - g) >= 26
    lbl_m, n_m = ndimage.label(all_magenta)
    sky_ids = set(lbl_m[0, :].tolist()) - {0}
    sky_magenta = np.isin(lbl_m, list(sky_ids)) & (yy < int(0.30 * h))

    lava_magenta = all_magenta & (~sky_magenta)
    lbl_l, n_l = ndimage.label(lava_magenta)
    min_caldera_area = max(800, int(round(8000 * (w * h) / float(W_CANON * H_CANON))))
    caldera_ids = [
        cid for cid in range(1, n_l + 1)
        if int((lbl_l == cid).sum()) >= min_caldera_area
    ]
    caldera_chasm = np.isin(lbl_l, caldera_ids)
    rock_veins = lava_magenta & (~caldera_chasm)
    rock_mask = ~all_magenta

    # 2. Palette unifiée fidèle à `H19P01` + `Dark Crater Pit` sans aucune dérive magenta
    ref_pal = extract_canonical_palette([H19P01_REF], max_colors=64, min_pixels=8)
    rock_px = decor_rgb[rock_mask]
    uniq, cnt = np.unique(rock_px, axis=0, return_counts=True)
    top_rock = uniq[np.argsort(-cnt)[:64]]
    pal = sanitize_palette_no_magenta(np.vstack([DARK_CRATER_VISCOUS_PAL, ref_pal, top_rock]), max_gap=22)
    q_decor = quantize_rgb_to_palette(decor_rgb, pal)

    # 3. Plateau central de Sulfura + pont basaltique Sud (`y = h - 1` -> `y ≈ 0.30h`) :
    #    - Visuellement (`island_rock_visual`), les fines fissures `#FF00FF` de la rosace restent ouvertes (`alpha = 0`)
    #      pour laisser pulser le vrai magma `d41p41a` à travers le plateau !
    #    - Physiquement (`walkable_solid`), on referme les fines fissures (`<= 6 px`) pour que tout l'îlot + le pont
    #      soit 100 % praticable sans accroc sur `WallGrid` !
    island_zone = (
        (((xx - 0.50 * w) / (0.23 * w)) ** 2 + ((yy - 0.505 * h) / (0.24 * h)) ** 2 <= 1.0)
        | ((yy >= int(0.62 * h)) & (xx >= int(0.39 * w)) & (xx <= int(0.61 * w)))
    ) & (~caldera_chasm) & (~sky_magenta)

    closed_island = ndimage.binary_closing(rock_mask & island_zone, iterations=max(2, int(round(5 * w / 768.0))))
    closed_island &= (~caldera_chasm) & (~sky_magenta)
    lbl_iw, _ = ndimage.label(closed_island)
    south_ids = set(lbl_iw[h - 6 :, int(0.41 * w) : int(0.59 * w)].ravel().tolist()) - {0}
    walkable_solid = np.isin(lbl_iw, list(south_ids))
    walkable_solid = ndimage.binary_fill_holes(walkable_solid) & (~caldera_chasm)

    island_rock_visual = rock_mask & walkable_solid
    outer_crown_rock = rock_mask & (~island_rock_visual)

    # 4. Couches 00..09
    im_00_sky, frames_01_smoke = build_h19p01_sky_and_fumaroles(w=w, h=h, n_frames=N_FRAMES)
    frames_02_caldera = build_dark_crater_pit_magma_frames(w=w, h=h, mask=caldera_chasm, phase_offset=0)

    # Socle rocheux uniquement sous `outer_crown_rock` et sous les parties non fissurées de `island_rock_visual`
    # afin que les fissures `#FF00FF` de la rosace laissent transparaître `frames_04_veins` !
    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[rock_mask, :3] = np.array([56, 22, 16], dtype=np.uint8)
    base_arr[rock_mask, 3] = 255
    im_03_base = Image.fromarray(base_arr, mode="RGBA")

    veins_mask = ndimage.binary_dilation(rock_veins, iterations=1) & lava_magenta
    frames_04_veins = build_dark_crater_pit_magma_frames(
        w=w, h=h, mask=veins_mask, phase_offset=5, roll_xy=(40, 24)
    )

    band_px = max(6.0, 11.0 * (w / float(W_CANON)))
    frames_05_shore = render_dark_crater_viscous_shoreline(caldera_chasm, n_frames=15, band_px=band_px)

    def _mk_layer(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_decor[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_06_island = _mk_layer(island_rock_visual)
    im_07_crown = _mk_layer(outer_crown_rock)

    rock_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    rock_rgba[rock_mask, :3] = q_decor[rock_mask]
    rock_rgba[rock_mask, 3] = 255
    frames_08_glow = build_dark_crater_rim_glow_frames(rock_rgba, lava_magenta)
    frames_09_embers = build_canonical_w04_embers_frames(w=w, h=h)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_solid[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.55

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_ciel_brasier_h19p01", "Ciel Volcanique d'Ivoire H19P01", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_panaches_fumee_volcanique", "Panaches de Fumée Cratérique H19P01", "BG", frames_01_smoke, frame_length=5),
        LayerEntry("02_caldeira_magma_d41p41a", "Caldeira de Magma Canonique d41p41a 1×", "BG", frames_02_caldera, frame_length=10),
        LayerEntry("03_socle_basalte_continu", "Socle Volcanique Continu H19P01", "BG", [im_03_base], frame_length=5),
        LayerEntry("04_veines_lave_et_rosace_sulfura", "Veines & Rosace de Lave #FF00FF", "BG", frames_04_veins, frame_length=10),
        LayerEntry("05_rive_visqueuse_caldeira", "Rive Visqueuse & Croûte de Caldeira", "BG", frames_05_shore, frame_length=8),
        LayerEntry("06_plateau_sulfura_et_pont_sud", "Îlot de Sulfura & Chaussée Basaltique Sud", "BG", [im_06_island], frame_length=5),
        LayerEntry("07_couronne_pics_basalte", "Couronne de Pitons Volcaniques H19P01", "BG", [im_07_crown], frame_length=5),
        LayerEntry("08_incandescence_thermique_cratere", "Incandescence Thermique du Cratère", "BG", frames_08_glow, frame_length=8),
        LayerEntry("09_braises_sulfura_w04_top", "Braises Ardentes de Sulfura W04 1×", "Top", frames_09_embers, frame_length=7),
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
        max_fidelity_distance=34.0,
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
