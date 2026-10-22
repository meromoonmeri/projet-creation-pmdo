#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (24 trames @ 5 ticks = 120 ticks) :
RTC1 — Relais Céleste de la Tour (PMD Équipe de Secours Rouge `D13P02` + `D13P01.bpl`).

Cinématique physique harmonieuse à l'échelle 1:1 non écrasée de `D13P02.png` :
1. `01_brumes_gouffre_profondes` (24 poses) : brumes bleutées remontant doucement au fond du
   gouffre bleu roi (`dy = -8 px/trame`, léger appel `dx = ±8 px/trame`) dans l'écrin en C autour du relais.
2. `02_courants_cumulus_intermediaires` (24 poses) : ourlets cumulus secondaires défilant vers
   le haut à vitesse lente (`dy = -4 px/trame`, période `96 px`) juste au bord du gouffre bleu roi.
3. `03_murailles_cumulus_etoilees` (24 poses) : les immenses murailles cumulus blanches festonnées
   piquées d'étoiles diamant bleues extraites SANS AUCUN ÉCRASEMENT à l'échelle exacte 1:1 de `D13P02`,
   découpées selon l'écrin bleu roi canonique autour du relais central et montant continûment vers le haut
   (`dy = -8 px/trame`, période verticale `PH = 192 = 24 * 8 px` 100 % sans couture !).
4. `07_scintillement_etoiles_cumulus` (24 poses) : scintillement déphasé des étoiles diamant bleues
   accompagnant exactement la montée verticale `dy = -8 px/trame` des murailles cumulus.
5. `08_reflets_bpl_relais` (24 poses) : souffle lumineux `D13P01.bpl` sur les ourlets du pont et du relais.
6. `09_panaches_ascendants_pont` (`Top` `Layer = 4`, 24 poses) : volutes en S ascendantes remontant
   dans le gouffre bleu roi de part et d'autre du relais central.
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

from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
    composite_sprite_periodic_path,
    extract_canonical_palette,
    extract_whole_cloud_sprites,
    key_magenta,
    load_bpl_cyan_ramp,
    make_fullscale_periodic_strip,
    quantize_rgb_to_palette,
    quantize_rgba_to_palette,
    render_symmetric_stream_frames,
)

MAP_ID = "RTC1"
MAP_TITLE = "Relais Céleste de la Tour"
RAW_DIR = REPO_ROOT / ".cache" / "tour_celeste_relais_v1" / "raw"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_celeste_relais_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_unsquashed_d13p02_cumulus_walls(
    ref_d13p02_img: Image.Image,
    central_island_alpha: np.ndarray,
    w: int,
    h: int,
    palette: np.ndarray,
) -> Tuple[List[Image.Image], List[Image.Image], np.ndarray]:
    """Extrait SANS AUCUN ÉCRASEMENT VERTICAL une tranche `1:1` des murailles cumulus blanches
    étoilées de `D13P02.png` (`wall_w x ph` avec `ph = (h // 3 // 24) * 24` = 192 px à `w=768, h=576`),
    la rend périodique verticalement avec joint doux, et découpe exactement l'écrin bleu roi en C
    de `D13P02` autour du relais central !"""
    ref_up = np.asarray(
        ref_d13p02_img.convert("RGB").resize((w, h), Image.Resampling.NEAREST),
        dtype=np.float32,
    )
    ph = max(96, (h // 3 // 24) * 24)  # 192 px pour h=576 -> step_y = 8 px/trame exact !
    step_y = ph // N_FRAMES

    # Tranche supérieure `[0:ph, 0:mid]` de `D13P02` où les cumulus s'étendent jusqu'au bord du pont nord !
    mid = w // 2
    crop_left = ref_up[0:ph, 0:mid].copy()  # 100 % proportions 1:1 non écrasées !

    # Continuité périodique verticale sur une fine bande de 10 px aux extrémités SEULEMENT :
    # préserve à 100 % les étoiles diamant bleues nettes de `D13P02.png` sur tout le reste de la hauteur !
    periodic_left = crop_left.copy()
    seam_h = max(8, ph // 16)
    for k_y in range(seam_h):
        alpha_b = (k_y + 0.5) / float(2 * seam_h)  # 0.0 -> 0.5 au bord exact `y = 0 | ph - 1`
        top_row = crop_left[k_y]
        bot_row = crop_left[ph - 1 - k_y]
        periodic_left[k_y] = (1.0 - alpha_b) * top_row + alpha_b * bot_row
        periodic_left[ph - 1 - k_y] = (1.0 - alpha_b) * bot_row + alpha_b * top_row
    periodic_left = np.clip(np.rint(periodic_left), 0, 255).astype(np.uint8)
    q_left = quantize_rgb_to_palette(periodic_left, palette)

    # Écrin bleu roi en C canonique autour du relais central dans `D13P02.png`, aligné sur la grille `8x8`
    # afin que la frontière avec le gouffre ne multiplie JAMAIS les tuiles `.tile` !
    ref_q_full = quantize_rgb_to_palette(ref_up.astype(np.uint8), palette)
    chasm_raw = (ref_q_full[:, :, 2].astype(np.int32) - ref_q_full[:, :, 0].astype(np.int32)) > 110
    # Garde uniquement les deux grandes anses en C autour du relais central (`aire >= 600 px`) !
    lbl_ch, n_ch = ndimage.label(chasm_raw)
    chasm_clean = np.zeros_like(chasm_raw)
    for idx_ch in range(1, n_ch + 1):
        m_ch = lbl_ch == idx_ch
        if int(m_ch.sum()) >= max(180, (w * h) // 700):
            chasm_clean |= m_ch
    chasm_clean = chasm_clean | chasm_clean[:, ::-1]
    # Dilate franchement pour révéler l'écrin en C bleu roi `#1850F8` de `D13P02` et aligne sur blocs `8x8`
    chasm_dil = ndimage.binary_dilation(chasm_clean, iterations=max(4, w // 48))
    gh_c, gw_c = h // TILE_SIZE, w // TILE_SIZE
    chasm_grid = chasm_dil.reshape(gh_c, TILE_SIZE, gw_c, TILE_SIZE).mean(axis=(1, 3)) >= 0.35
    chasm_mask_canon = np.repeat(np.repeat(chasm_grid, TILE_SIZE, axis=0), TILE_SIZE, axis=1)
    outer_wall_zone = (~chasm_mask_canon) & (~central_island_alpha)

    # Repérage des étoiles bleues piquées dans la tranche cumulus `q_left`
    star_in_strip = (q_left[:, :, 2].astype(np.int32) - q_left[:, :, 0].astype(np.int32)) > 85
    lbl_st, n_st = ndimage.label(star_in_strip)
    bright_white = palette[np.argmax(palette.astype(np.int32).sum(axis=1))]
    sky_cyan = quantize_rgb_to_palette(np.array([[[152, 212, 255]]], dtype=np.uint8), palette)[0, 0]

    strip_rgba = np.zeros((ph, mid, 4), dtype=np.uint8)
    strip_rgba[:, :, :3] = q_left
    strip_rgba[:, :, 3] = 255

    wall_frames: List[Image.Image] = []
    star_frames: List[Image.Image] = []
    ys = np.arange(h, dtype=np.int32)

    for t in range(N_FRAMES):
        vy = (ys + step_y * t) % ph  # `dy = -step_y` vers le HAUT !
        left_cur = strip_rgba[vy, :]
        right_cur = left_cur[:, ::-1, :]

        full_wall = np.concatenate([left_cur, right_cur], axis=1)
        full_wall[~outer_wall_zone] = 0
        wall_frames.append(Image.fromarray(full_wall, mode="RGBA"))

        star_strip = np.zeros((ph, mid, 4), dtype=np.uint8)
        for st_id in range(1, n_st + 1):
            phase_val = np.sin(2.0 * np.pi * (t / float(N_FRAMES)) + st_id * 1.61)
            if phase_val > 0.76:
                m_s = lbl_st == st_id
                star_strip[m_s, :3] = bright_white
                star_strip[m_s, 3] = 255
            elif phase_val > 0.42:
                m_s = lbl_st == st_id
                star_strip[m_s, :3] = sky_cyan
                star_strip[m_s, 3] = 255

        full_star = np.concatenate([star_strip[vy, :], star_strip[vy, :][:, ::-1, :]], axis=1)
        full_star[~outer_wall_zone] = 0
        star_frames.append(Image.fromarray(full_star, mode="RGBA"))

    return wall_frames, star_frames, chasm_mask_canon


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    ref_d13p02 = REF_DIR / "D13P02.png"
    bpl_path = REF_DIR / "rom_d13p01_bpl.json"

    palette = extract_canonical_palette([ref_d13p02], max_colors=40, min_pixels=4)
    ref_d13p02_img = Image.open(ref_d13p02)

    # 1. Pont Sud->Nord et île centrale `ile_ponts_magenta.png` détourés proprement sur `#FF00FF` !
    ile_raw = Image.open(RAW_DIR / "ile_ponts_magenta.png")
    ile_keyed = key_magenta(ile_raw, size=(w, h), erode_fringe=2, min_component_area=120)
    ile_q = quantize_rgba_to_palette(ile_keyed, palette)
    ile_arr = np.asarray(ile_q, dtype=np.uint8).copy()

    # Retire les anses bleues internes éventuelles de `ile_arr` pour que le vrai gouffre bleu roi animé
    # apparaisse et respire dans les 4 anses autour du relais central !
    is_inner_blue = (ile_arr[:, :, 3] > 0) & (
        (ile_arr[:, :, 2].astype(np.int32) - ile_arr[:, :, 0].astype(np.int32)) > 115
    )
    ile_arr[is_inner_blue] = 0
    central_alpha = ile_arr[:, :, 3] > 0
    lbl_c, n_c = ndimage.label(central_alpha)
    if n_c > 1:
        cnt_c = ndimage.sum(central_alpha, lbl_c, index=range(1, n_c + 1))
        central_alpha = lbl_c == (int(np.argmax(cnt_c)) + 1)
        ile_arr[~central_alpha] = 0

    luma_ile = (
        0.299 * ile_arr[:, :, 0].astype(np.float32)
        + 0.587 * ile_arr[:, :, 1].astype(np.float32)
        + 0.114 * ile_arr[:, :, 2].astype(np.float32)
    )
    erode_px = max(4, int(round(min(w, h) * 0.020)))
    walk_px_mask = ndimage.binary_erosion(central_alpha, iterations=erode_px)

    rim_mask = central_alpha & (~walk_px_mask)
    shadow_rim_mask = rim_mask & (luma_ile < 236.0)
    bright_rim_mask = rim_mask & (~shadow_rim_mask)

    layer04_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer04_arr[shadow_rim_mask] = ile_arr[shadow_rim_mask]

    layer05_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer05_arr[walk_px_mask] = ile_arr[walk_px_mask]

    layer06_arr = np.zeros((h, w, 4), dtype=np.uint8)
    layer06_arr[bright_rim_mask] = ile_arr[bright_rim_mask]

    # 2. Fond bleu roi profond `#1850F8` + 3 plans nuageux ascendants !
    chasm_rgb = quantize_rgb_to_palette(np.array([[[24, 80, 248]]], dtype=np.uint8), palette)[0, 0]
    layer00_img = Image.new("RGBA", (w, h), (int(chasm_rgb[0]), int(chasm_rgb[1]), int(chasm_rgb[2]), 255))

    frames_03, frames_07, chasm_mask_canon = build_unsquashed_d13p02_cumulus_walls(
        ref_d13p02_img, central_alpha, w, h, palette
    )

    ph_mist = max(96, (h // 3 // 24) * 24)  # 192 px -> step 8 px/trame
    step_mist = ph_mist // N_FRAMES
    wall_raw_img = Image.open(RAW_DIR / "nuages_muraille_ascendante.png")

    # Couche 01 : fines brumes bleutées montant au fond du gouffre bleu roi (`dy = -8 px/f`)
    tile_mist = make_fullscale_periodic_strip(
        wall_raw_img,
        canvas_w=w,
        canvas_h=h,
        crop_box=(int(w * 0.30), 0, int(w * 0.30) + ph_mist, ph_mist),
        period_w=ph_mist,
        period_h=ph_mist,
        palette=palette,
        keep_mask_fn=lambda rgb: (rgb[:, :, 0] > 215) & (rgb[:, :, 2] > 240),
        min_blob_area=120,
    )
    mist_rgb = quantize_rgb_to_palette(np.array([[[72, 128, 250]]], dtype=np.uint8), palette)[0, 0]
    m_op = tile_mist[:, :, 3] > 0
    tile_mist[m_op, :3] = mist_rgb
    frames_01 = render_symmetric_stream_frames(tile_mist, w, h, step_inward_x=0, step_upward_y=step_mist)

    # Couche 02 : banc cumulus secondaire décalé en profondeur (`dy = -8 px/f` sur `192 px`) visible
    # juste à l'orée extérieure du gouffre bleu roi (aligné `8x8` -> < 600 tuiles uniques !)
    gh_c, gw_c = h // TILE_SIZE, w // TILE_SIZE
    chasm_g = chasm_mask_canon.reshape(gh_c, TILE_SIZE, gw_c, TILE_SIZE).any(axis=(1, 3))
    rim_g = chasm_g & ndimage.binary_dilation(~chasm_g, iterations=1)
    moat_rim_zone = np.repeat(np.repeat(rim_g, TILE_SIZE, axis=0), TILE_SIZE, axis=1)
    tile_sub = make_fullscale_periodic_strip(
        ref_d13p02_img,
        canvas_w=w,
        canvas_h=h,
        crop_box=(0, ph_mist // 2, ph_mist, ph_mist + ph_mist // 2),
        period_w=ph_mist,
        period_h=ph_mist,
        palette=palette,
        keep_mask_fn=lambda rgb: rgb[:, :, 0] > 224,
        min_blob_area=96,
    )
    frames_02 = render_symmetric_stream_frames(
        tile_sub, w, h, step_inward_x=0, step_upward_y=step_mist, mask_keep=moat_rim_zone
    )

    # Couche 08 : respiration `D13P01.bpl` sur les crêtes cyan du pont et du relais central
    bpl_ramp = load_bpl_cyan_ramp(bpl_path, palette)
    frames_08: List[Image.Image] = []
    for t in range(N_FRAMES):
        c_rgb = bpl_ramp[t]
        arr_08 = np.zeros((h, w, 4), dtype=np.uint8)
        arr_08[shadow_rim_mask, :3] = c_rgb
        arr_08[shadow_rim_mask, 3] = 255
        frames_08.append(Image.fromarray(arr_08, mode="RGBA"))

    # Couche 09 (`Top` `Layer = 4`) : fines volutes en S ascendantes montant dans l'écrin bleu roi en C !
    sprites = extract_whole_cloud_sprites(
        RAW_DIR / "poses_nuages_magenta.png",
        palette=palette,
        scale_div=max(2, int(round(1400 / max(w, 1)))),
        min_area=16,
    )
    top_arrays = [np.zeros((h, w, 4), dtype=np.uint8) for _ in range(N_FRAMES)]
    if sprites:
        small_wisps = [s for s in sprites if s.height >= s.width and s.width <= max(20, w // 18)]
        sp_wisp_l = small_wisps[0] if small_wisps else sprites[-1]
        sp_wisp_r = sp_wisp_l.transpose(Image.Transpose.FLIP_LEFT_RIGHT)

        moat_paths = [
            # Volutes ascendantes strictement logées dans le gouffre bleu roi à gauche et à droite du relais !
            (sp_wisp_l, w * 0.34, h * 0.68, w * 0.34, h * 0.32, 0, -w * 0.012),
            (sp_wisp_r, w * 0.66, h * 0.68, w * 0.66, h * 0.32, 0, +w * 0.012),
            (sp_wisp_l, w * 0.31, h * 0.64, w * 0.31, h * 0.35, 12, +w * 0.008),
            (sp_wisp_r, w * 0.69, h * 0.64, w * 0.69, h * 0.35, 12, -w * 0.008),
        ]
        for sp, x0, y0, x1, y1, ph_s, arc_s in moat_paths:
            composite_sprite_periodic_path(top_arrays, sp, x0, y0, x1, y1, phase=ph_s, arc_px=arc_s)
        inner_safe = ndimage.binary_erosion(walk_px_mask, iterations=3)
        for a in top_arrays:
            a[inner_safe] = 0

    frames_09 = [Image.fromarray(a, mode="RGBA") for a in top_arrays]

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            block = walk_px_mask[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(block.mean()) >= 0.70

    labeled_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        counts_w = ndimage.sum(walk_grid, labeled_w, index=range(1, n_w + 1))
        walk_grid = labeled_w == (int(np.argmax(counts_w)) + 1)

    layers = [
        LayerEntry("00_gouffre_bleu_celeste", "Gouffre Bleu Celeste", "BG", [layer00_img]),
        LayerEntry("01_brumes_gouffre_profondes", "Brumes Gouffre Profondes", "BG", frames_01),
        LayerEntry("02_courants_cumulus_intermediaires", "Courants Cumulus Intermediaires", "BG", frames_02),
        LayerEntry("03_murailles_cumulus_etoilees", "Murailles Cumulus Etoilees", "BG", frames_03),
        LayerEntry("04_ombres_ponts_et_ile", "Ombres Ponts Et Ile", "BG", [Image.fromarray(layer04_arr, "RGBA")]),
        LayerEntry("05_sol_pont_et_ile_relais", "Sol Pont Et Ile Relais", "BG", [Image.fromarray(layer05_arr, "RGBA")]),
        LayerEntry("06_ourlet_festonne_blanc", "Ourlet Festonne Blanc", "BG", [Image.fromarray(layer06_arr, "RGBA")]),
        LayerEntry("07_scintillement_etoiles_cumulus", "Scintillement Etoiles Cumulus", "BG", frames_07),
        LayerEntry("08_reflets_bpl_relais", "Reflets BPL Relais", "BG", frames_08),
        LayerEntry("09_panaches_ascendants_pont", "Panaches Ascendants Pont", "Top", frames_09),
    ]
    return layers, walk_grid, palette


def main() -> None:
    layers, walk_grid, _ = build_layers_for_size(W_CANON, H_CANON)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=RENDERS_DIR,
        virtual_zip_path=VIRTUAL_ZIP,
        canonical_ref_for_fidelity=REF_DIR / "D13P02.png",
        max_fidelity_distance=30.0,
    )
    print(json.dumps(meta, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
