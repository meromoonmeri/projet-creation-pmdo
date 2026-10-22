#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (24 trames @ 5 ticks = 120 ticks) :
MMA1 — Mine Magma — Arène de Groudon (`b70` Hardware `1:1` + Mer de Magma & Pont Sud-Nord).

Réunit à l'échelle pixel exacte :
1. L'île volcanique de l'arène de Groudon décodée à `0.0` erreur pixel depuis `dungeon_sbin.s`
   (`references/b70_groudon_boss_arena.png` + `references/b70_frame_00..07.png`, `552 × 576`),
   avec sa cascade nord de lave en fusion, ses `18` ruisseaux ardents le long des falaises d'orgues
   basaltiques dorées et ses `5` cratères de magma bouillonnants au sein du pavage polygonal.
2. Un pont volcanique praticable continu **Sud -> Nord** (`y = 576 -> 340 px`) bâti à partir des
   vraies dalles polygonales et bordures d'orgues canoniques de `b70`, reliant l'entrée Sud au cœur
   de l'arène de Groudon sans aucune couture ni étirement.
3. Un océan de magma visqueux en ébullition plein cadre `768 × 576` (`bruts/fond_mer_magma_continu.png`
   quantifié sur la palette volcanique canonique `b70`), ponctué sur les flancs Est et Ouest d'îlots
   d'orgues basaltiques et de colonnes de magma jaillissantes découpés sur fond `#FF00FF` pur
   (`bruts/ilot_colonne_magma_magenta.png`, zéro halo).
4. Les vraies animations multicalques matérielles GBA `b70canm` + caldeira (`24` poses @ `5` ticks) :
   - `MMA1_01` : fleuves primaires de magma en fusion à travers la caldeira,
   - `MMA1_02` : ressac de lave incandescente autour de l'île & du pont + remous secondaires,
   - `MMA1_06` : cascade nord de lave en fusion & `18` veines ardentes des falaises (`b70canm` `1:1`),
   - `MMA1_07` : geysers et panaches de magma jaillissant en séquences déphasées sur les îlots Est/Ouest,
   - `MMA1_08` : les `5` cratères de magma concentriques bouillonnants de l'arène (`b70canm` `1:1`)
     + respiration incandescente des joints du pont Sud-Nord,
   - `MMA1_09` (`Top`, `Layer = 4`) : braises et flammèches ardentes s'élevant de la caldeira.
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
    extract_canonical_palette,
    key_magenta,
    quantize_rgb_to_palette,
    quantize_rgba_to_palette,
)

MAP_ID = "MMA1"
MAP_TITLE = "Mine Magma — Arène de Groudon"
RAW_DIR = HERE / "bruts"
REF_DIR = HERE / "references"
RENDERS_DIR = REPO_ROOT / "renders" / "mine_magma_arene_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_caldera_palette() -> np.ndarray:
    """Extrait la palette volcanique canonique stricte de tous les états matériels `b70` (`b70_frame_00..07`)."""
    refs = sorted(REF_DIR.glob("b70_frame_*.png")) or [REF_DIR / "b70_groudon_boss_arena.png"]
    pal = extract_canonical_palette(refs, max_colors=96, min_pixels=1)
    extra = np.array(
        [
            [55, 0, 0],
            [79, 15, 0],
            [111, 31, 0],
            [151, 55, 0],
            [199, 87, 0],
            [255, 23, 0],
            [255, 71, 0],
            [255, 119, 0],
            [255, 159, 0],
            [255, 207, 0],
        ],
        dtype=np.uint8,
    )
    return np.unique(np.vstack([pal, extra]), axis=0).astype(np.uint8)


def extract_islet_and_geyser_parts(
    raw_path: Path,
    palette: np.ndarray,
    target_w: int,
    target_h: int,
) -> Tuple[Image.Image, Image.Image]:
    """Sépare proprement depuis `bruts/ilot_colonne_magma_magenta.png` (`#FF00FF` strict, `erode_fringe=3`) :
    - `islet_static` : le socle hexagonal d'orgues basaltiques et sa collerette de lave rouge-orange ;
    - `plume_full`   : le panache vertical de magma jaune-or jaillissant et ses gouttelettes incandescentes,
                       afin de l'animer en vraie éruption multi-étapes sur `MMA1_07` !"""
    keyed = key_magenta(Image.open(raw_path), erode_fringe=3, min_component_area=18)
    arr = np.asarray(keyed, dtype=np.uint8)
    ys, xs = np.where(arr[:, :, 3] > 0)
    crop = arr[int(ys.min()) : int(ys.max()) + 1, int(xs.min()) : int(xs.max()) + 1]
    scaled = quantize_rgba_to_palette(
        Image.fromarray(crop, mode="RGBA").resize((max(24, target_w), max(24, target_h)), Image.Resampling.NEAREST),
        palette,
    )
    s_arr = np.asarray(scaled, dtype=np.uint8)
    sh, sw = s_arr.shape[:2]
    yy_s = np.arange(sh, dtype=np.float32)[:, None]

    # Le panache éruptif et l'intégralité de son contour rouge/gouttelettes au-dessus de la cheminée (`y < 0.54 * sh` dans le couloir central, ou gouttes isolées hautes `y < 0.42 * sh`) bougent ensemble sans aucun contour fantôme !
    opaque = s_arr[:, :, 3] > 0
    xs_s = np.arange(sw, dtype=np.float32)[None, :]
    in_vent_shaft = (xs_s >= 0.34 * sw) & (xs_s <= 0.66 * sw) & (yy_s < 0.55 * sh)
    high_splash = yy_s < 0.36 * sh
    plume_seed = opaque & (
        ((yy_s < 0.60 * sh) & (s_arr[:, :, 0] >= 225) & (s_arr[:, :, 1] >= 80))
        | high_splash
    )
    is_plume = opaque & (
        ndimage.binary_dilation(plume_seed, iterations=max(2, sw // 28)) & ((yy_s < 0.46 * sh) | in_vent_shaft)
    )

    plume_arr = np.zeros_like(s_arr)
    plume_arr[is_plume] = s_arr[is_plume]

    islet_arr = s_arr.copy()
    islet_arr[is_plume] = 0

    return Image.fromarray(islet_arr, mode="RGBA"), Image.fromarray(plume_arr, mode="RGBA")


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    caldera_pal = build_caldera_palette()
    sx = w / float(W_CANON)
    sy = h / float(H_CANON)

    # 1. Chargement des `8` trames matérielles exactes `b70_frame_00..07.png` (`552 × 576` à l'échelle `1:1`)
    b70_frames_rgb: List[np.ndarray] = []
    for step in range(8):
        fp = REF_DIR / f"b70_frame_{step:02d}.png"
        im = Image.open(fp if fp.is_file() else (REF_DIR / "b70_groudon_boss_arena.png")).convert("RGB")
        bw = max(64, int(round(im.width * sx)))
        bh = max(64, int(round(im.height * sy)))
        arr = np.asarray(im.resize((bw, bh), Image.Resampling.NEAREST) if (bw, bh) != im.size else im, dtype=np.uint8)
        b70_frames_rgb.append(quantize_rgb_to_palette(arr, caldera_pal))

    b70_f0 = b70_frames_rgb[0]
    bh, bw, _ = b70_f0.shape
    x_off = (w - bw) // 2  # 108 px à w = 768
    y_shift_up = int(round(32 * sy))  # Laisse une majestueuse passe Sud `y = 384 -> 576` pour le pont de basalte

    # Masque exact de l'île volcanique `b70` (exclut uniquement le vide extérieur uni `[55, 0, 0]`)
    void_cand = (b70_f0[:, :, 0] <= 64) & (b70_f0[:, :, 1] <= 8) & (b70_f0[:, :, 2] <= 8)
    lbl_v, _ = ndimage.label(void_cand)
    edge_labels = (
        set(lbl_v[0, :].tolist())
        | set(lbl_v[-1, :].tolist())
        | set(lbl_v[:, 0].tolist())
        | set(lbl_v[:, -1].tolist())
    ) - {0}
    b70_island_mask = ~np.isin(lbl_v, list(edge_labels))

    # Positionne l'île `1:1` de `b70` sur le canevas `w × h`
    island_frames_full: List[np.ndarray] = []
    island_mask_canvas = np.zeros((h, w), dtype=bool)
    src_y0 = y_shift_up
    dst_h = min(h, bh - src_y0)
    island_mask_canvas[:dst_h, x_off : x_off + bw] = b70_island_mask[src_y0 : src_y0 + dst_h, :]

    for step in range(8):
        canvas_s = np.zeros((h, w, 4), dtype=np.uint8)
        sub_m = b70_island_mask[src_y0 : src_y0 + dst_h, :]
        sub_rgb = b70_frames_rgb[step][src_y0 : src_y0 + dst_h, :]
        canvas_s[:dst_h, x_off : x_off + bw, :3][sub_m] = sub_rgb[sub_m]
        canvas_s[:dst_h, x_off : x_off + bw, 3][sub_m] = 255
        island_frames_full.append(canvas_s)

    # 2. Pont volcanique praticable **Sud -> Nord** (`y = bridge_y0 .. h`) assemblé sans couture
    #    à partir des dalles polygonales centrales et des bordures d'orgues dorées canoniques de `b70` !
    #    Dans `b70_f0` (`552 × 576`), le cœur sans cratère du pavage polygonal est en `y = 208..296, x = 204..348`
    #    et les bordures latérales d'orgues + ourlet de lave sont en `y = 192..288, x = 104..148` et `x = 404..448`.
    slab_patch = b70_f0[
        int(round(192 * sy)) : int(round(288 * sy)),
        int(round(204 * sx)) : int(round(348 * sx)),
        :,
    ]
    curb_west = b70_f0[
        int(round(192 * sy)) : int(round(288 * sy)),
        int(round(104 * sx)) : int(round(148 * sx)),
        :,
    ]
    curb_east = curb_west[:, ::-1, :]
    sh_sp, sw_sp = slab_patch.shape[:2]
    ch_cb, cw_cb = curb_west.shape[:2]

    bridge_y0 = int(round(320 * sy))  # Ouvre franchement la brèche Sud jusqu'à l'intérieur du pavage polygonal `b70` (`y <= 328`) !
    bridge_half_w = max(16, int(round(56 * sx)))  # `112 px` = `14` tuiles praticables de large !
    bx0 = (w // 2) - bridge_half_w
    bx1 = (w // 2) + bridge_half_w
    b_span = bx1 - bx0

    bridge_floor_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    bridge_curbs_rgba = np.zeros((h, w, 4), dtype=np.uint8)
    for py in range(bridge_y0, h):
        dy_b = py - bridge_y0
        row_s = slab_patch[dy_b % sh_sp]
        s_off = max(0, (sw_sp - b_span) // 2)
        seg = row_s[s_off : s_off + b_span]
        if len(seg) < b_span:
            seg = np.pad(seg, ((0, b_span - len(seg)), (0, 0)), mode="wrap")
        bridge_floor_rgba[py, bx0:bx1, :3] = seg
        bridge_floor_rgba[py, bx0:bx1, 3] = 255

        # Bordures d'orgues basaltiques dorées symétriques sur les flancs Ouest et Est du pont (`y >= 364`)
        if py >= int(round(364 * sy)):
            cy_b = dy_b % ch_cb
            w_row = curb_west[cy_b]
            m_w = ~((w_row[:, 0] <= 64) & (w_row[:, 1] <= 8) & (w_row[:, 2] <= 8))
            xw0 = max(0, bx0 - cw_cb + int(round(6 * sx)))
            sub_bw = bridge_curbs_rgba[py, xw0 : xw0 + cw_cb]
            sub_bw[m_w, :3] = w_row[m_w]
            sub_bw[m_w, 3] = 255

            e_row = curb_east[cy_b]
            m_e = ~((e_row[:, 0] <= 64) & (e_row[:, 1] <= 8) & (e_row[:, 2] <= 8))
            xe0 = min(w - cw_cb, bx1 - int(round(6 * sx)))
            sub_be = bridge_curbs_rgba[py, xe0 : xe0 + cw_cb]
            sub_be[m_e, :3] = e_row[m_e]
            sub_be[m_e, 3] = 255

    # Assemble l'île `b70` (`MMA1_04`) et le tablier + garde-corps du pont Sud -> Nord (`MMA1_05`)
    arr_04 = island_frames_full[0].copy()
    im_05 = Image.fromarray(bridge_curbs_rgba, mode="RGBA")
    im_05.alpha_composite(Image.fromarray(bridge_floor_rgba, mode="RGBA"))
    arr_05 = np.asarray(im_05, dtype=np.uint8)

    solid_land_mask = (arr_04[:, :, 3] > 0) | (arr_05[:, :, 3] > 0)

    # 3. Mer de magma visqueux plein cadre `768 × 576` (`MMA1_00`) + îlots d'orgues basaltiques (`MMA1_03`)
    sea_raw = Image.open(RAW_DIR / "fond_mer_magma_continu.png").convert("RGB")
    sea_q = quantize_rgb_to_palette(
        np.asarray(sea_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8),
        caldera_pal,
    )
    # Assombrit légèrement les plaques de basalte refroidi de la caldeira afin de respecter l'équilibre
    # lumineux dramatique de `b70` tout en faisant ressortir l'incandescence des fleuves de magma !
    crust_dark = (sea_q[:, :, 0] < 175) & (sea_q[:, :, 1] < 95)
    sea_q_toned = sea_q.copy()
    sea_q_toned[crust_dark] = np.clip(sea_q_toned[crust_dark].astype(np.float32) * 0.68, 0, 255).astype(np.uint8)
    sea_q = quantize_rgb_to_palette(sea_q_toned, caldera_pal)
    layer00_rgba = np.concatenate([sea_q, np.full((h, w, 1), 255, dtype=np.uint8)], axis=2)

    islet_lg, plume_lg = extract_islet_and_geyser_parts(
        RAW_DIR / "ilot_colonne_magma_magenta.png",
        caldera_pal,
        int(round(168 * sx)),
        int(round(176 * sy)),
    )
    islet_sm, plume_sm = extract_islet_and_geyser_parts(
        RAW_DIR / "ilot_colonne_magma_magenta.png",
        caldera_pal,
        int(round(124 * sx)),
        int(round(132 * sy)),
    )
    islet_lg_r = islet_lg.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    plume_lg_r = plume_lg.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    islet_sm_r = islet_sm.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    plume_sm_r = plume_sm.transpose(Image.Transpose.FLIP_LEFT_RIGHT)

    geyser_sites = [
        (islet_lg, plume_lg, int(round(14 * sx)), int(round(62 * sy)), 0),
        (islet_lg_r, plume_lg_r, w - islet_lg_r.width - int(round(14 * sx)), int(round(74 * sy)), 12),
        (islet_sm_r, plume_sm_r, int(round(26 * sx)), int(round(372 * sy)), 6),
        (islet_sm, plume_sm, w - islet_sm.width - int(round(26 * sx)), int(round(384 * sy)), 18),
    ]
    im_03 = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    for sp_islet, _, gx, gy, _ in geyser_sites:
        im_03.alpha_composite(sp_islet, (gx, gy))
    arr_03 = np.asarray(im_03, dtype=np.uint8).copy()
    arr_03[solid_land_mask] = 0

    # 4. Animations multicalques `24` poses :
    #    Cyclage chromatique fidèle à `b70canm` suivant exactement les courbes naturelles des fleuves
    #    de `fond_mer_magma_continu.png` (ZÉRO bande diagonale plate, ZÉRO blanc-crème !)
    lava_ramp = quantize_rgb_to_palette(
        np.array(
            [
                [
                    [255, 23, 0],
                    [255, 47, 0],
                    [255, 71, 0],
                    [255, 95, 0],
                    [255, 119, 0],
                    [255, 159, 0],
                    [255, 207, 0],
                    [255, 119, 0],
                ]
            ],
            dtype=np.uint8,
        ),
        caldera_pal,
    )[0]

    xs_g = np.arange(w, dtype=np.float32)[None, :]
    yy_g = np.arange(h, dtype=np.float32)[:, None]
    sea_open = (~solid_land_mask) & (arr_03[:, :, 3] == 0)
    sea_rivers = sea_open & (sea_q[:, :, 0] >= 215) & (sea_q[:, :, 2] <= 24)
    river_g_phase = np.clip(sea_q[:, :, 1].astype(np.int32) // 28, 0, 7)
    coast_ring = sea_open & ndimage.binary_dilation(solid_land_mask | (arr_03[:, :, 3] > 0), iterations=max(2, int(round(3 * sx))))

    frames_01: List[Image.Image] = []
    frames_02: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr1 = np.zeros((h, w, 4), dtype=np.uint8)
        idx_r = (river_g_phase[sea_rivers] + (t // 3)) % 8
        arr1[sea_rivers, :3] = lava_ramp[idx_r]
        arr1[sea_rivers, 3] = 255
        frames_01.append(Image.fromarray(arr1, mode="RGBA"))

        w2 = np.sin(2.0 * np.pi * (t / float(N_FRAMES)) + 0.09 * xs_g + 0.08 * yy_g)
        arr2 = np.zeros((h, w, 4), dtype=np.uint8)
        c_hot = coast_ring & (w2 > 0.15)
        c_crest = coast_ring & (w2 > 0.72)
        arr2[c_hot, :3] = lava_ramp[1]
        arr2[c_hot, 3] = 255
        arr2[c_crest, :3] = lava_ramp[4]
        arr2[c_crest, 3] = 255
        frames_02.append(Image.fromarray(arr2, mode="RGBA"))

    #    - `MMA1_06` & `MMA1_08` : séparation spatiale des `8` étapes matérielles GBA exactes `b70canm` (`24 = 3 * 8`) :
    #      * `MMA1_06` : cascade nord de lave en fusion + les `18` ruisseaux ardents des falaises `b70` !
    #      * `MMA1_08` : les `5` cratères concentriques de lave bouillonnants à l'intérieur du plateau `b70`
    #                    + respiration incandescente des joints du pont Sud-Nord !
    any_b70_anim = np.zeros((h, w), dtype=bool)
    for step in range(1, 8):
        any_b70_anim |= np.any(island_frames_full[step][:, :, :3] != island_frames_full[0][:, :, :3], axis=2)

    # Zone interne de l'arène `b70` (`x = x_off+128 .. x_off+424, y = 136..404` à l'échelle `1:1`)
    inner_arena_box = np.zeros((h, w), dtype=bool)
    inner_arena_box[
        int(round(124 * sy)) : int(round(372 * sy)),
        x_off + int(round(124 * sx)) : x_off + int(round(428 * sx)),
    ] = True
    craters_anim_mask = any_b70_anim & inner_arena_box
    cliffs_waterfall_anim_mask = any_b70_anim & (~inner_arena_box)

    # Joints incandescents du pont Sud -> Nord
    bridge_seams = (
        (arr_05[:, :, 3] > 0)
        & (arr_05[:, :, 0] >= 195)
        & ((arr_05[:, :, 0].astype(np.int16) - arr_05[:, :, 2].astype(np.int16)) >= 135)
    )

    frames_06: List[Image.Image] = []
    frames_08: List[Image.Image] = []
    for t in range(N_FRAMES):
        step_w = (t // 3) % 8
        arr6 = np.zeros((h, w, 4), dtype=np.uint8)
        src_w = island_frames_full[step_w]
        arr6[cliffs_waterfall_anim_mask] = src_w[cliffs_waterfall_anim_mask]
        frames_06.append(Image.fromarray(arr6, mode="RGBA"))

        # Déphasage léger sur les cratères + joints du pont pour un vrai relief multicalque organique
        step_c = ((t + 4) // 3) % 8
        arr8 = np.zeros((h, w, 4), dtype=np.uint8)
        src_c = island_frames_full[step_c]
        arr8[craters_anim_mask] = src_c[craters_anim_mask]

        seam_wave = np.sin(2.0 * np.pi * (t / float(N_FRAMES)) - yy_g / max(8.0, 36.0 * sy))
        s_hi = bridge_seams & (seam_wave > 0.30)
        arr8[s_hi, :3] = lava_ramp[6]
        arr8[s_hi, 3] = 255
        frames_08.append(Image.fromarray(arr8, mode="RGBA"))

    #    - `MMA1_07` : panaches éruptifs jaillissant des 4 îlots basaltiques de la caldeira (phases décalées `0, 6, 12, 18`)
    frames_07: List[Image.Image] = []
    for t in range(N_FRAMES):
        im7 = Image.new("RGBA", (w, h), (0, 0, 0, 0))
        for sp_islet, sp_plume, gx, gy, ph_g in geyser_sites:
            u_g = ((t + ph_g) % N_FRAMES) / float(N_FRAMES)
            # Montée progressive du jet de magma (45 % -> 100 % -> retombée 55 %) ancré à la bouche éruptive
            scale_h = 0.42 + 0.58 * np.sin(np.pi * u_g) ** 0.85
            pw_cur = sp_plume.width
            ph_cur = max(12, int(round(sp_plume.height * scale_h)))
            plume_scaled = sp_plume.resize((pw_cur, ph_cur), Image.Resampling.NEAREST)
            # Ancrage au pied du panache (`y_vent ~ gy + 0.56 * sp_plume.height`)
            y_vent = gy + int(round(0.56 * sp_plume.height))
            py_draw = y_vent - int(round(0.56 * ph_cur))
            im7.alpha_composite(plume_scaled, (gx, py_draw))
        arr7 = np.asarray(im7, dtype=np.uint8).copy()
        arr7[solid_land_mask] = 0
        frames_07.append(Image.fromarray(arr7, mode="RGBA"))

    #    - `MMA1_09` (`Top`, `Layer = 4`) : braises et étincelles volcaniques ascendantes au-dessus de la caldeira
    ember_points = [
        (0.08, 0.90, 0, True), (0.16, 0.72, 4, False), (0.24, 0.86, 9, True),
        (0.34, 0.94, 14, False), (0.66, 0.92, 2, False), (0.76, 0.84, 7, True),
        (0.85, 0.70, 12, False), (0.92, 0.88, 17, True), (0.19, 0.30, 11, False),
        (0.81, 0.28, 21, False), (0.46, 0.14, 5, True), (0.54, 0.16, 15, False),
    ]
    rise_px = max(24, int(round(116 * sy)))
    frames_09: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr9 = np.zeros((h, w, 4), dtype=np.uint8)
        for fx_e, fy_e, ph_e, big_e in ember_points:
            u_e = ((t + ph_e) % N_FRAMES) / float(N_FRAMES)
            ex = int(round(w * fx_e + np.sin(2.0 * np.pi * u_e) * 5.0 * sx))
            ey = int(round(h * fy_e - u_e * rise_px))
            if not (2 <= ex < w - 2 and 2 <= ey < h - 2):
                continue
            c_i = 7 if u_e < 0.35 else (5 if u_e < 0.72 else 3)
            arr9[ey, ex, :3] = lava_ramp[c_i]
            arr9[ey, ex, 3] = 255
            if big_e and u_e < 0.72:
                arr9[ey + 1, ex, :3] = lava_ramp[max(1, c_i - 2)]
                arr9[ey + 1, ex, 3] = 255
        frames_09.append(Image.fromarray(arr9, mode="RGBA"))

    # 5. Grille de collision 100 % visuelle : pont volcanique Sud (`y = h - 1`) -> plateau polygonal `b70`
    #    (en contournant proprement les `5` cratères de lave bouillonnants de l'arène !)
    walk_px = np.zeros((h, w), dtype=bool)
    # Plateau polygonal central de `b70` (`x = x_off + 140 .. x_off + 412, y = 128 .. 356`)
    ay0, ay1 = int(round(128 * sy)), int(round(356 * sy))
    ax0, ax1 = x_off + int(round(140 * sx)), x_off + int(round(412 * sx))
    walk_px[ay0:ay1, ax0:ax1] = True
    # Tablier central du pont Sud -> Nord (`bx0 + 8 .. bx1 - 8, y = bridge_y0 .. h`)
    margin_b = max(4, int(round(8 * sx)))
    walk_px[bridge_y0:h, bx0 + margin_b : bx1 - margin_b] = True
    # Bloque les `5` cratères de lave en ébullition à l'intérieur du plateau `b70` !
    crater_lava = ndimage.binary_dilation(craters_anim_mask, iterations=max(1, int(round(2 * sx))))
    walk_px[crater_lava] = False

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walk_px[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.65

    labeled_w, n_w = ndimage.label(walk_grid)
    if n_w > 1:
        south_labels = set(labeled_w[-1, :].tolist()) - {0}
        if south_labels:
            walk_grid = np.isin(labeled_w, list(south_labels))

    layers = [
        LayerEntry("00_ocean_caldeira_magma", "Ocean Caldeira Magma Visqueux", "BG", [Image.fromarray(layer00_rgba, "RGBA")]),
        LayerEntry("01_fleuves_magma_caldeira", "Fleuves Magma En Fusion Caldeira", "BG", frames_01),
        LayerEntry("02_ressac_incandescent_cotes", "Ressac Lave Cotes & Pont", "BG", frames_02),
        LayerEntry("03_ilots_orgues_basaltiques", "Ilots Orgues Basaltiques Flancs", "BG", [Image.fromarray(arr_03, "RGBA")]),
        LayerEntry("04_ile_arene_groudon_b70", "Ile Arene Groudon Canonique b70", "BG", [Image.fromarray(arr_04, "RGBA")]),
        LayerEntry("05_pont_basalte_sud_nord", "Pont Basalte Polygonal Sud-Nord", "BG", [Image.fromarray(arr_05, "RGBA")]),
        LayerEntry("06_cascade_et_veines_lave_b70", "Cascade Nord & Veines Falaises b70", "BG", frames_06),
        LayerEntry("07_colonnes_magma_eruptives", "Geysers & Colonnes Magma Eruptives", "BG", frames_07),
        LayerEntry("08_crateres_bouillonnants_b70", "Crateres Lave Bouillonnants Arene", "BG", frames_08),
        LayerEntry("09_braises_caldeira_top", "Braises & Etincelles Caldeira", "Top", frames_09),
    ]
    return layers, walk_grid, caldera_pal


def main() -> None:
    layers, walk_grid, _ = build_layers_for_size(W_CANON, H_CANON)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=RENDERS_DIR,
        virtual_zip_path=VIRTUAL_ZIP,
        canonical_ref_for_fidelity=REF_DIR / "b70_island_canon_crop.png",
        max_fidelity_distance=22.0,
        namespace_override="mine_magma_mma1",
        asset_name_override="mine_magma_arene",
    )
    print(json.dumps(meta, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
