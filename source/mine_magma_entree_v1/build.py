#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (24 trames @ 5 ticks = 120 ticks) :
MME1 — Mine Magma — Entrée (`D12P01` Canonique Plein Cadre `2×` + `D12P01.bpl` & Parallaxe Volcanique).

Réunit sans aucune couture verticale ni aplats parasites :
1. Le dôme volcanique enflammé, l'arche sombre d'entrée nord, les colonnes prismatiques d'orgues
   basaltiques et le pavage polygonal fissuré de `references/d12p01_magma_cavern_entrance.png`
   à l'échelle entière nette `2×` plein cadre `768 × 576` (`zéro` couture latérale, `zéro` étirement).
2. Des contreforts rocheux d'orgues basaltiques & gouffres de magma en fusion aux coins inférieurs
   gauche et droit découpés sur fond `#FF00FF` pur (`flancs_colonnes_basalte_magenta.png` +
   `fond_mer_magma_continu.png` quantifiés sur la palette stricte `D12P01`), encadrant la large
   chaussée praticable **Sud (`y = 576`) -> Nord (seuil de l'arche `y = 224`)**.
3. Les vraies animations multicalques matérielles `D12P01.bpl` (`24` poses @ `5` ticks = `120` ticks)
   ciblant exclusivement les entrées chromatiques animées de la ROM (zéro aplat sur la roche) :
   - `MME1_01` : lueurs volcaniques lointaines dans la voûte caverneuse au-dessus de la crête,
   - `MME1_04` : langues de flammes vives sur toute la crête du dôme (`D12P01.bpl` pal 0 col 1..7),
   - `MME1_05` : magma en fusion respirant au pied des orgues basaltiques (`[255, 0..71, 0]`),
   - `MME1_06` : ondes de magma pulsantes dans les fissures du pavage polygonal Sud -> Nord,
   - `MME1_07` : courants ardents de magma dans les gouffres d'angle avant-plan,
   - `MME1_09` (`Top`, `Layer = 4`) : braises et flammèches ascendantes à travers la caverne.
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

MAP_ID = "MME1"
MAP_TITLE = "Mine Magma — Entrée"
RAW_DIR = HERE / "bruts"
REF_DIR = HERE / "references"
ARENE_RAW_DIR = REPO_ROOT / "source" / "mine_magma_arene_v1" / "bruts"
RENDERS_DIR = REPO_ROOT / "renders" / "mine_magma_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_volcanic_palette() -> np.ndarray:
    """Extrait la palette volcanique canonique stricte de `D12P01` (`74` couleurs GBA exactes)."""
    pal = extract_canonical_palette(
        [
            REF_DIR / "d12p01_magma_cavern_entrance.png",
            REF_DIR / "d12p02_magma_cavern_relay.png",
        ],
        max_colors=96,
        min_pixels=1,
    )
    return pal.astype(np.uint8)


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    volc_pal = build_volcanic_palette()
    sx = w / float(W_CANON)
    sy = h / float(H_CANON)

    # 1. Mise à l'échelle entière `2×` de `D12P01` (`408 × 336` -> `816 × 672` à `768 × 576`) :
    #    - Recadrage horizontal symétrique de `24 px` de chaque côté (`x = 24..792` -> `768 px` plein cadre, ZÉRO couture !)
    #    - Cadrage vertical `y = 20..596` (`576 px` : conserve 100 % de la voûte, de la crête de flammes,
    #      de l'arche sombre nord, des colonnes basaltiques, des rochers gris et de la route Sud -> Nord !)
    d12_orig = Image.open(REF_DIR / "d12p01_magma_cavern_entrance.png").convert("RGB")
    up_w = max(w, int(round(d12_orig.width * 2.0 * sx)))
    up_h = max(h, int(round(d12_orig.height * 2.0 * sy)))
    d12_up = np.asarray(d12_orig.resize((up_w, up_h), Image.Resampling.NEAREST), dtype=np.uint8)

    crop_x0 = (up_w - w) // 2
    crop_y0 = min(max(0, int(round(16 * sy))), up_h - h)
    d12_full = d12_up[crop_y0 : crop_y0 + h, crop_x0 : crop_x0 + w, :].copy()
    d12_q = quantize_rgb_to_palette(d12_full, volc_pal)

    # Détection exacte du vide supérieur `[55, 0, 0]` connecté au bord Nord (préserve l'arche sombre interne !)
    is_bg55 = (
        (np.abs(d12_full[:, :, 0].astype(np.int16) - 55) <= 4)
        & (d12_full[:, :, 1] <= 4)
        & (d12_full[:, :, 2] <= 4)
    )
    lbl_bg, _ = ndimage.label(is_bg55)
    vault_labels = set(lbl_bg[0, :].tolist()) - {0}
    vault_mask = np.isin(lbl_bg, list(vault_labels))
    cavern_body_mask = ~vault_mask

    # 2. `MME1_00` : voûte volcanique sombre `[55, 0, 0]` + gouffres de lave aux coins Sud-Ouest et Sud-Est
    vault_rgb = quantize_rgb_to_palette(np.array([[[55, 0, 0]]], dtype=np.uint8), volc_pal)[0, 0]
    sea_raw = Image.open(ARENE_RAW_DIR / "fond_mer_magma_continu.png").convert("RGB")
    sea_q = quantize_rgb_to_palette(
        np.asarray(sea_raw.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8),
        volc_pal,
    )

    bg_arr = np.empty((h, w, 3), dtype=np.uint8)
    bg_arr[:, :] = vault_rgb[None, None, :]

    xs_g = np.arange(w, dtype=np.float32)[None, :]
    yy_g = np.arange(h, dtype=np.float32)[:, None]

    # Encoches organiques de gouffres de magma aux coins inférieurs gauche et droit (`x < corner_w`, `y > corner_y`)
    # laissant toute la chaussée centrale **Sud -> Nord** largement ouverte (`x = 152..616` à `y = 576` = `58` tuiles !)
    left_chasm = ((xs_g / max(1.0, 0.21 * w)) ** 1.35 + ((h - yy_g) / max(1.0, 0.30 * h)) ** 1.35) < 1.0
    right_chasm = (((w - 1.0 - xs_g) / max(1.0, 0.21 * w)) ** 1.35 + ((h - yy_g) / max(1.0, 0.30 * h)) ** 1.35) < 1.0
    corner_chasms = left_chasm | right_chasm
    bg_arr[corner_chasms] = sea_q[corner_chasms]
    layer00_rgba = np.concatenate([bg_arr, np.full((h, w, 1), 255, dtype=np.uint8)], axis=2)

    # 3. `MME1_02` : corps caverneux canonique `D12P01` (`2×` net plein cadre), découpé proprement autour
    #    de la voûte nord et des deux gouffres de lave Sud-Ouest / Sud-Est
    arr_02 = np.zeros((h, w, 4), dtype=np.uint8)
    keep_d12 = cavern_body_mask & (~corner_chasms)
    arr_02[keep_d12, :3] = d12_q[keep_d12]
    arr_02[keep_d12, 3] = 255

    # 4. `MME1_03` + `MME1_08` : contreforts d'orgues basaltiques & amas rocheux découpés sur fond `#FF00FF` pur
    #    (`flancs_colonnes_basalte_magenta.png`, `erode_fringe=3`) ancrés aux deux coins Sud-Ouest et Sud-Est !
    flank_keyed = key_magenta(
        Image.open(RAW_DIR / "flancs_colonnes_basalte_magenta.png"),
        erode_fringe=3,
        min_component_area=60,
    )
    flank_q = quantize_rgba_to_palette(flank_keyed, volc_pal)
    cw_sp, ch_sp = max(24, int(round(168 * sx))), max(24, int(round(196 * sy)))
    col_l = flank_q.resize((cw_sp, ch_sp), Image.Resampling.NEAREST)
    col_r = col_l.transpose(Image.Transpose.FLIP_LEFT_RIGHT)

    im_03 = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    im_03.alpha_composite(col_l, (-int(round(28 * sx)), h - ch_sp + int(round(18 * sy))))
    im_03.alpha_composite(col_r, (w - cw_sp + int(round(28 * sx)), h - ch_sp + int(round(18 * sy))))
    arr_03 = np.asarray(im_03, dtype=np.uint8)

    # Petits rochers volcaniques gris découpés du pied des orgues pour ponctuer naturellement les rives des gouffres
    f_arr = np.asarray(flank_q, dtype=np.uint8)
    fh_s, fw_s = f_arr.shape[:2]
    b_sub = f_arr[int(fh_s * 0.73) : int(fh_s * 0.95), int(fw_s * 0.35) : int(fw_s * 0.65), :].copy()
    hot_px = (b_sub[:, :, 3] > 0) & ((b_sub[:, :, 0].astype(np.int16) - b_sub[:, :, 2].astype(np.int16)) > 85) & (b_sub[:, :, 0] > 165)
    b_sub[hot_px, 3] = 0
    im_08 = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    lbl_rk, n_rk = ndimage.label(b_sub[:, :, 3] > 0)
    if n_rk > 0:
        best_rk = lbl_rk == (int(np.argmax(ndimage.sum(b_sub[:, :, 3] > 0, lbl_rk, index=range(1, n_rk + 1)))) + 1)
        b_sub[~best_rk] = 0
        yrk, xrk = np.where(best_rk)
        rock_crop = Image.fromarray(b_sub[int(yrk.min()) : int(yrk.max()) + 1, int(xrk.min()) : int(xrk.max()) + 1], mode="RGBA")
        rk_a = rock_crop.resize((max(12, int(round(52 * sx))), max(10, int(round(34 * sy)))), Image.Resampling.NEAREST)
        rk_b = rk_a.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        im_08.alpha_composite(rk_a, (int(round(142 * sx)), int(round(472 * sy))))
        im_08.alpha_composite(rk_b, (w - int(round(194 * sx)), int(round(466 * sy))))
    arr_08 = np.asarray(im_08, dtype=np.uint8)

    # 5. Palette de cycle magma canonique extraite directement de `D12P01.bpl` (aucune teinte hors palette !)
    fire_ramp = quantize_rgb_to_palette(
        np.array(
            [
                [
                    [95, 0, 0],      # 0 : braise sombre
                    [143, 55, 0],    # 1 : ocre rouge profond
                    [183, 87, 0],    # 2 : ambre volcanique
                    [255, 23, 0],    # 3 : rouge magma pur
                    [255, 47, 0],    # 4 : vermillon ardent
                    [255, 71, 0],    # 5 : orange lave vive
                    [255, 119, 0],   # 6 : orange-or incandescent
                    [255, 207, 0],   # 7 : jaune-or fusion `D12P01.bpl`
                ]
            ],
            dtype=np.uint8,
        ),
        volc_pal,
    )[0]

    # `MME1_01` : respiration de brume ardente dans la voûte volcanique juste derrière la crête enflammée
    crest_halo_band = vault_mask & ndimage.binary_dilation(cavern_body_mask, iterations=max(2, int(round(8 * sy))))
    c_vault_warm = quantize_rgb_to_palette(np.array([[[79, 0, 0], [95, 0, 0]]], dtype=np.uint8), volc_pal)[0]
    frames_01: List[Image.Image] = []
    for t in range(N_FRAMES):
        breath_v = 0.5 + 0.5 * np.sin(2.0 * np.pi * (t / float(N_FRAMES)))
        arr1 = np.zeros((h, w, 4), dtype=np.uint8)
        if breath_v > 0.35:
            arr1[crest_halo_band, :3] = c_vault_warm[1 if breath_v > 0.72 else 0]
            arr1[crest_halo_band, 3] = 255
        frames_01.append(Image.fromarray(arr1, mode="RGBA"))

    # Séparation stricte des pixels de LAVE PURE de `D12P01` (`R == 255` et `B == 0`, ou flammèches de crête
    # touchant la voûte) — ZÉRO modification des colonnes rocheuses ocres (`R <= 231`), donc ZÉRO tache jaune !
    d_r = d12_full[:, :, 0].astype(np.int16)
    d_g = d12_full[:, :, 1].astype(np.int16)
    d_b = d12_full[:, :, 2].astype(np.int16)
    in_body = arr_02[:, :, 3] > 0

    near_vault = ndimage.binary_dilation(vault_mask, iterations=max(2, int(round(10 * sy))))
    # `MME1_04` : langues de flammes le long de la crête du dôme (`pal 0 col 1..7` de `D12P01.bpl`)
    flame_rim_px = in_body & near_vault & (d_r >= 245) & (d_b == 0)

    # `MME1_05` : poches de magma pur au pied des orgues basaltiques (`R == 255, B == 0`, `y < 0.54 * h`, hors crête)
    pillar_lava_px = in_body & (~near_vault) & (yy_g < 0.54 * h) & (d_r >= 248) & (d_b == 0)

    # `MME1_06` : veines de magma incandescentes dans les joints du pavage polygonal Sud -> Nord (`y >= 0.40 * h`)
    floor_vein_px = in_body & (yy_g >= 0.40 * h) & (d_r >= 215) & (d_b == 0)

    # Table de correspondance cyclique fidèle à `D12P01.bpl` (préserve le gradient interne `rouge -> orange -> or` !)
    lava_cycle_table = [
        np.array([255, 23, 0], dtype=np.uint8),
        np.array([255, 47, 0], dtype=np.uint8),
        np.array([255, 71, 0], dtype=np.uint8),
        np.array([255, 119, 0], dtype=np.uint8),
        np.array([255, 207, 0], dtype=np.uint8),
        np.array([255, 135, 0], dtype=np.uint8),
        np.array([255, 95, 0], dtype=np.uint8),
        np.array([255, 47, 0], dtype=np.uint8),
    ]
    q_cycle = quantize_rgb_to_palette(np.array([lava_cycle_table], dtype=np.uint8), volc_pal)[0]

    # Indice de phase intrinsèque de chaque pixel de lave `D12P01` d'après sa canalité verte `G` (`0 -> 207`),
    # exactement comme le cyclage matériel de palette `D12P01.bpl` sur GBA !
    g_phase_idx = np.zeros((h, w), dtype=np.int32)
    g_phase_idx[d_g >= 20] = 1
    g_phase_idx[d_g >= 44] = 2
    g_phase_idx[d_g >= 68] = 3
    g_phase_idx[d_g >= 108] = 4
    g_phase_idx[d_g >= 150] = 5

    frames_04: List[Image.Image] = []
    frames_05: List[Image.Image] = []
    frames_06: List[Image.Image] = []
    for t in range(N_FRAMES):
        # Crête de flammes rapide (`3` cycles par boucle `24` poses comme `dur = 9` dans `D12P01.bpl` !)
        arr4 = np.zeros((h, w, 4), dtype=np.uint8)
        idx4 = (g_phase_idx[flame_rim_px] + t) % 8
        arr4[flame_rim_px, :3] = q_cycle[idx4]
        arr4[flame_rim_px, 3] = 255
        frames_04.append(Image.fromarray(arr4, mode="RGBA"))

        # Magma au pied des orgues basaltiques (`1` cycle lent respirant sur `24` poses comme `nf = 23` dans `D12P01.bpl`)
        arr5 = np.zeros((h, w, 4), dtype=np.uint8)
        step_p = (t * 8) // N_FRAMES
        idx5 = (g_phase_idx[pillar_lava_px] + step_p) % 8
        arr5[pillar_lava_px, :3] = q_cycle[idx5]
        arr5[pillar_lava_px, 3] = 255
        frames_05.append(Image.fromarray(arr5, mode="RGBA"))

        # Veines incandescentes entre les dalles polygonales du chemin Sud -> Nord (`2` cycles par boucle)
        arr6 = np.zeros((h, w, 4), dtype=np.uint8)
        yy_full = np.broadcast_to(yy_g, (h, w))
        step_v = ((t * 16) // N_FRAMES + (yy_full[floor_vein_px].astype(np.int32) // max(1, int(round(48 * sy))))) % 8
        idx6 = (g_phase_idx[floor_vein_px] + step_v) % 8
        arr6[floor_vein_px, :3] = q_cycle[idx6]
        arr6[floor_vein_px, 3] = 255
        frames_06.append(Image.fromarray(arr6, mode="RGBA"))

    # `MME1_07` : cyclage organique des fleuves de magma dans les deux gouffres d'angle avant-plan
    chasm_open = corner_chasms & (arr_03[:, :, 3] == 0) & (arr_08[:, :, 3] == 0)
    chasm_lava = chasm_open & (sea_q[:, :, 0] >= 205) & (sea_q[:, :, 2] <= 24)
    chasm_g_idx = np.clip(sea_q[:, :, 1].astype(np.int32) // 28, 0, 7)
    frames_07: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr7 = np.zeros((h, w, 4), dtype=np.uint8)
        idx7 = (chasm_g_idx[chasm_lava] + (t // 3)) % 8
        arr7[chasm_lava, :3] = q_cycle[idx7]
        arr7[chasm_lava, 3] = 255
        frames_07.append(Image.fromarray(arr7, mode="RGBA"))

    # `MME1_09` (`Top`, `Layer = 4`) : braises et flammèches volcaniques ascendantes
    ember_seeds = [
        (0.06, 0.94, 0, True), (0.13, 0.86, 5, False), (0.19, 0.92, 11, True),
        (0.09, 0.44, 17, False), (0.24, 0.36, 20, False), (0.81, 0.92, 3, True),
        (0.88, 0.85, 9, False), (0.94, 0.95, 14, True), (0.76, 0.36, 19, False),
        (0.91, 0.42, 22, False), (0.36, 0.28, 7, False), (0.64, 0.27, 16, False),
    ]
    rise_span = max(24, int(round(108 * sy)))
    frames_09: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr9 = np.zeros((h, w, 4), dtype=np.uint8)
        for fx_e, fy_e, ph_e, big_e in ember_seeds:
            u_e = ((t + ph_e) % N_FRAMES) / float(N_FRAMES)
            ex = int(round(w * fx_e + np.sin(2.0 * np.pi * u_e) * 4.0 * sx))
            ey = int(round(h * fy_e - u_e * rise_span))
            if not (2 <= ex < w - 2 and 2 <= ey < h - 2):
                continue
            c_idx = 7 if u_e < 0.35 else (5 if u_e < 0.72 else 3)
            arr9[ey, ex, :3] = fire_ramp[c_idx]
            arr9[ey, ex, 3] = 255
            if big_e and u_e < 0.75:
                arr9[ey + 1, ex, :3] = fire_ramp[max(1, c_idx - 2)]
                arr9[ey + 1, ex, 3] = 255
        frames_09.append(Image.fromarray(arr9, mode="RGBA"))

    # 6. Grille de collision 100 % visuelle : chaussée polygonale **Sud (`y = h - 1`) -> Arche Nord (`y ~ 0.30 * h`)**
    walk_px = np.zeros((h, w), dtype=bool)
    for py in range(h):
        yf = py / float(h)
        if yf < 0.28:
            continue
        elif yf < 0.58:
            # S'évase exactement le long des parois rocheuses de `D12P01` depuis l'arche nord (`x = 0.465..0.535 * w`)
            t_open = (yf - 0.28) / 0.30
            half_c = int(round((0.036 + 0.38 * t_open) * w))
            walk_px[py, (w // 2) - half_c : (w // 2) + half_c] = arr_02[py, (w // 2) - half_c : (w // 2) + half_c, 3] > 0
        else:
            walk_px[py, :] = (arr_02[py, :, 3] > 0) & (arr_03[py, :, 3] == 0) & (arr_08[py, :, 3] == 0)
            # Garde une marge de sécurité de 2 tuiles au bord des gouffres de lave d'angle
            walk_px[py, :] &= ~ndimage.binary_dilation(corner_chasms[py, :], iterations=max(2, int(round(12 * sx))))

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
        LayerEntry("00_voute_et_gouffres_magma", "Voute Volcanique & Gouffres Magma", "BG", [Image.fromarray(layer00_rgba, "RGBA")]),
        LayerEntry("01_halo_ardent_voute", "Halo Ardent Voute Caverneuse", "BG", frames_01),
        LayerEntry("02_dome_arche_et_pavage_d12", "Dome Arche & Chaussée D12P01 2x", "BG", [Image.fromarray(arr_02, "RGBA")]),
        LayerEntry("03_contreforts_orgues_angles", "Contreforts Orgues Basaltiques Angles", "BG", [Image.fromarray(arr_03, "RGBA")]),
        LayerEntry("04_flammes_crete_volcan_bpl", "Flammes Crete Volcanique D12P01 BPL", "BG", frames_04),
        LayerEntry("05_lueur_pied_orgues_bpl", "Magma Incandescent Pied Orgues BPL", "BG", frames_05),
        LayerEntry("06_veines_magma_dalles_bpl", "Veines Magma Pulsantes Chaussee BPL", "BG", frames_06),
        LayerEntry("07_fleuves_magma_gouffres", "Fleuves Lave En Fusion Gouffres", "BG", frames_07),
        LayerEntry("08_rochers_volcaniques_rives", "Rochers Volcaniques Rives Gouffres", "BG", [Image.fromarray(arr_08, "RGBA")]),
        LayerEntry("09_braises_ascendantes_top", "Braises & Flammeches Ascendantes", "Top", frames_09),
    ]
    return layers, walk_grid, volc_pal


def main() -> None:
    layers, walk_grid, _ = build_layers_for_size(W_CANON, H_CANON)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=RENDERS_DIR,
        virtual_zip_path=VIRTUAL_ZIP,
        canonical_ref_for_fidelity=REF_DIR / "d12p01_magma_cavern_entrance.png",
        max_fidelity_distance=16.0,
        namespace_override="mine_magma_mme1",
        asset_name_override="mine_magma_entree",
    )
    print(json.dumps(meta, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
