#!/usr/bin/env python3
"""Constructeur PMDO `0.8.12.0` — `FAS1` (*Caverne des Tourb'Îles — Arène de Lugia façon Pokémon SoulSilver*).

Architecture `768 × 576` (`96 × 72` tuiles `8×8`), `10` calques (`9 BG` + `1 Top`), `0 px` de ciel :
  - **Arène centrale 100 % simple et nue (`0` objet, `0` colonne, `0` cristal, `0` décor)** en pierre
    humide sombre façon *Pokémon SoulSilver* (*Tourb'Îles / Whirl Islands*), reliée au Sud par un
    chemin droit Sud→Nord à marches de pierre ;
  - **Paroi caverneuse semi-circulaire entourant l'arrière de l'arène avec 9 grandes cascades animées**
    (`H10P02` `1×` hardware waterfall scroll + crêtes d'écume bouillonnantes) ;
  - **2 tornades d'eau 3D rotatives (`360°`, `24 poses @ 5 ticks`) sur CHAQUE côté du chemin Sud→Nord**
    (`2` sur le flanc Gauche + `2` sur le flanc Droit) surgissant de vortex d'écume dans l'eau sombre
    animée 4 phases *Metano Town* (`Metano_Town_River_Animation_1..4.tile` + `Sparkles`).
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
from source.moteur_forets_pmd_red import _downsample_non_mixing, _q8_u8, _sanitize_rgb_no_magenta
from source.moteur_fosse_argent_lugia import (
    H_CANON,
    TILE_SIZE,
    W_CANON,
    build_9_cavern_waterfalls_frames,
    build_h02p02w_light_shafts_top,
    build_metano_abyssal_water_4phases,
    build_metano_caustic_sparkles_frames,
    build_quad_water_tornado_layers,
    build_shore_foam_frames,
    clean_magenta_cutout_strict,
    quantize_foreground_96_abyssal,
    segment_soulsilver_cavern_and_9_chutes,
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
MAP_TITLE = "Tourb'Îles — Arène de Lugia (SoulSilver)"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    REF_DIR.mkdir(parents=True, exist_ok=True)
    if not H02P02_REF.is_file():
        h02_rgba, _, _ = render_gba_native("H02P02", phase=None, bpa_frame=0)
        Image.fromarray(h02_rgba[:, :, :3], mode="RGB").save(H02P02_REF)

    raw_src = np.asarray(Image.open(DECOR_MAGENTA_RAW).convert("RGB"), dtype=np.uint8)
    clean_src, fg_src = clean_magenta_cutout_strict(raw_src)
    fg_rgb_ds, fg_mask_ds = _downsample_non_mixing(clean_src, fg_src, out_w=w, out_h=h)
    fg_rgb_q = quantize_foreground_96_abyssal(fg_rgb_ds, fg_mask_ds)

    fg_rgb, cliff_mask, arena_mask, south_path_mask, cascade_mask = segment_soulsilver_cavern_and_9_chutes(
        fg_rgb_q, fg_mask_ds
    )
    fg_all = cliff_mask | arena_mask | south_path_mask
    water_mask = ~fg_all
    open_sea_mask = water_mask & (~cascade_mask)

    yy, xx = np.mgrid[:h, :w]

    # Calque 00 : Eau souterraine profonde bleu-nuit des Tourb'Îles (`poses = 1`)
    depth_t = np.clip(yy.astype(np.float32) / max(1.0, float(h - 1)), 0.0, 1.0)
    bg_r = 4.0 + 8.0 * depth_t
    bg_g = 36.0 + 34.0 * depth_t
    bg_b = 88.0 + 52.0 * depth_t
    bg_rgb = _sanitize_rgb_no_magenta(_q8_u8(np.dstack([bg_r, bg_g, bg_b])), water_mask)
    im_00_deep_water = make_layer_rgba(bg_rgb, water_mask)

    # Calque 01 : Houle souterraine animée 4 phases `Metano_Town_River_Animation_1..4.tile` + Sparkles (`4 poses @ 30t = 120t`)
    metano_4 = build_metano_abyssal_water_4phases(w, h, tint_mode="soulsilver_cavern")
    sparkles_4 = build_metano_caustic_sparkles_frames(w, h, open_sea_mask, n_frames=4, seed=24911)
    frames_01_metano_sea: List[Image.Image] = []
    for k in range(4):
        base_rgba = np.asarray(make_layer_rgba(metano_4[k], open_sea_mask), dtype=np.uint8).copy()
        sp_rgba = np.asarray(sparkles_4[k], dtype=np.uint8)
        sp_hit = sp_rgba[:, :, 3] == 255
        base_rgba[sp_hit] = sp_rgba[sp_hit]
        frames_01_metano_sea.append(Image.fromarray(sanitize_rgba_binary(base_rgba)))

    # Calque 02 : Les 9 grandes cascades animées de l'amphithéâtre arrière (`8 poses @ 15t = 120t`)
    frames_02_waterfalls = build_9_cavern_waterfalls_frames(w, h, open_sea_mask, cascade_mask, n_frames=8)

    # Calques 03, 04, 05 : Architecture rocheuse SoulSilver 100 % statique et épurée (`0` objet sur l'arène !)
    im_03_back_cliff = make_layer_rgba(fg_rgb, cliff_mask)
    im_04_south_path = make_layer_rgba(fg_rgb, south_path_mask)
    im_05_simple_arena = make_layer_rgba(fg_rgb, arena_mask)

    # Calques 06 & 07 : Deux tornades d'eau 3D rotatives (`360°`, `24 poses @ 5t = 120t`) sur CHAQUE côté du chemin Sud→Nord
    frames_06_tornadoes_left, frames_07_tornadoes_right = build_quad_water_tornado_layers(
        w, h, open_sea_mask, n_frames=24
    )

    # Calque 08 : Écume de rive battant le pied rocheux de l'arène, du chemin Sud→Nord et de la falaise (`12 poses @ 10t = 120t`)
    frames_08_shore_foam = build_shore_foam_frames(w, h, water_mask, cascade_mask, n_frames=12)

    # Calque 09 Top : Embruns fins & gouttelettes d'eau souterraine autour des cascades et des 4 tornades (`8 poses @ 15t = 120t`)
    rng_sp = np.random.default_rng(24977)
    n_spray = 44
    spx0 = rng_sp.integers(max(8, w // 16), max(16, w - w // 16), size=n_spray)
    spy0 = rng_sp.integers(max(12, h // 12), max(24, h - h // 14), size=n_spray)
    sp_ph = rng_sp.uniform(0.0, 2.0 * math.pi, size=n_spray)
    frames_09_top: List[Image.Image] = []
    for f in range(8):
        theta = 2.0 * math.pi * f / 8.0
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        for i in range(n_spray):
            px = int(round(spx0[i] + max(2.0, w * 0.008) * math.sin(theta + sp_ph[i])))
            py = int((spy0[i] - int(round((f / 8.0) * max(16, h // 10)))) % (h - 16)) + 8
            # Garde le centre de l'arène simple 100 % pur et dégagé !
            if arena_mask[py, px]:
                continue
            if 4 <= px < w - 4 and 4 <= py < h - 4 and water_mask[py, px]:
                arr[py, px] = (224, 250, 255, 210)
                if px + 1 < w - 4 and math.cos(theta + sp_ph[i]) > 0.20:
                    arr[py, px + 1] = (116, 216, 248, 175)
        frames_09_top.append(Image.fromarray(arr, mode="RGBA"))

    # Met à jour la référence canonique `768 × 576` de la pose 0 (avec écume de rive SOUS les tornades d'eau 3D !)
    if w == W_CANON and h == H_CANON:
        comp0 = Image.new("RGBA", (w, h), (0, 0, 0, 255))
        for im_l in (
            im_00_deep_water,
            frames_01_metano_sea[0],
            frames_02_waterfalls[0],
            frames_08_shore_foam[0],
            im_03_back_cliff,
            im_04_south_path,
            im_05_simple_arena,
            frames_06_tornadoes_left[0],
            frames_07_tornadoes_right[0],
            frames_09_top[0],
        ):
            comp0 = Image.alpha_composite(comp0, im_l)
        comp0.convert("RGB").save(CANONICAL_REF)

    # Grille de marche : Chemin Sud→Nord continu + TOUTE la dalle plate de l'arène ovale simple (sans aucun obstacle interne !)
    lum = (
        0.25 * fg_rgb[:, :, 0].astype(np.float32)
        + 0.50 * fg_rgb[:, :, 1].astype(np.float32)
        + 0.25 * fg_rgb[:, :, 2].astype(np.float32)
    )
    # Exclut uniquement la paroi verticale sombre qui plonge dans l'eau sous le rebord Sud de l'arène (`lum < 56`)
    arena_top_flat = ndimage.binary_erosion(arena_mask & (lum >= 56.0), iterations=max(1, w // 384))
    path_walk_px = south_path_mask & (xx >= int(round(0.458 * w))) & (xx <= int(round(0.542 * w)))
    stair_bridge_px = (arena_mask | south_path_mask) & (xx >= int(round(0.458 * w))) & (xx <= int(round(0.542 * w))) & (yy >= int(round(0.55 * h)))

    walkable_px = arena_top_flat | path_walk_px | stair_bridge_px

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_px[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.45

    # Garantit l'ouverture complète sans aucun trou intérieur sur le plateau de l'arène simple et le chemin Sud→Nord
    walk_grid = ndimage.binary_fill_holes(walk_grid)
    walk_grid[int(0.62 * gh) : gh, int(0.465 * gw) : int(0.535 * gw)] = True

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    pal = np.unique(fg_rgb[fg_all].reshape(-1, 3), axis=0).astype(np.uint8)

    layers = [
        LayerEntry("00_eau_souterraine_profonde_tourbiles", "Eau Souterraine Bleu-Nuit des Tourb'Îles", "BG", [im_00_deep_water], frame_length=5),
        LayerEntry("01_houle_caverne_metano_4phases", "Houle Souterraine 4 Phases & Reflets Metano", "BG", frames_01_metano_sea, frame_length=30),
        LayerEntry("02_neuf_cascades_amphitheatre_nord", "9 Grandes Cascades de l'Amphithéâtre H10P02", "BG", frames_02_waterfalls, frame_length=15),
        LayerEntry("03_ecume_berges_caverne_tourbiles", "Écume de Rive Animée Autour de l'Arène", "BG", frames_08_shore_foam, frame_length=10),
        LayerEntry("04_paroi_rocheuse_amphitheatre_caverne", "Falaise Caverneuse Semi-Circulaire SoulSilver", "BG", [im_03_back_cliff], frame_length=5),
        LayerEntry("05_chemin_pierre_sud_vers_nord", "Chemin & Marches de Pierre Sud → Nord", "BG", [im_04_south_path], frame_length=5),
        LayerEntry("06_arene_simple_nue_lugia", "Arène Ovale Simple & Nue de Lugia (0 Objet)", "BG", [im_05_simple_arena], frame_length=5),
        LayerEntry("07_deux_tornades_eau_gauche_3d", "2 Tornades d'Eau 3D Côté Gauche (360°)", "BG", frames_06_tornadoes_left, frame_length=5),
        LayerEntry("08_deux_tornades_eau_droite_3d", "2 Tornades d'Eau 3D Côté Droit (360°)", "BG", frames_07_tornadoes_right, frame_length=5),
        LayerEntry("09_embruns_cascades_et_tornades_top", "Embruns Fins des Cascades & Tornades Top", "Top", frames_09_top, frame_length=15),
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
