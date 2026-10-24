#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — MLS1 : Sommet du Mont Lointain — Sanctuaire de Ho-Oh (B72 + H05P02).

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles `8 px`) :
  - `00` (`BG`,  1p) : Voûte céleste azur courbée `H05P02` (*Rainbow Peak*) -> lueur d'horizon dorée `B72`
  - `01` (`BG`, 64p) : Mer de nuages sacrée dorée `B72` & bancs lointains ultra-lents (`45t`, `5.3 px/s`)
  - `02` (`BG`, 24p) : Grand Arc-en-Ciel céleste & ponts irisés pixel-art GBA `H05P02` de Ho-Oh
  - `03` (`BG`, 64p) : Vagues sculpturales de cumulus sacrés PMD générées (`36t`, `10.0 px/s`)
  - `04` (`BG`,  1p) : Aiguilles karstiques lointaines émergeant de la mer de nuages (`H05P02` / `B72`)
  - `05` (`BG`,  1p) : Grand Escalier sacré Sud & terrasses courbes de pierre sculptée
  - `06` (`BG`,  1p) : Vaste Plateau d'ivoire craquelé & Autel concentrique Nord de Ho-Oh (`B72`)
  - `07` (`BG`,  1p) : Grand Monolithe Nord & Piliers karstiques calcaires du sanctuaire
  - `08` (`BG`,  1p) : Fougères émeraude suspendues & couronnes moussues des cimes
  - `09` (`Top`,24p) : Cimes périphériques, écharpes de nuages à faible opacité & plumes arc-en-ciel `Top`
"""
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

SOURCE_DIR = Path(__file__).resolve().parent.parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.mont_lointain_sommet_v1.make_brut import (
    OUT_BRUT_PATH,
    OUT_CANOPY_PATH,
    OUT_REF_CANON_PATH,
    assemble_mont_lointain_sommet_1x,
    build_sommet_hooh_atmosphere_layers,
)
from source.moteur_cyclones_cylindriques_unova import H as H_NAT, W as W_NAT, sanitize_rgba_binary
from tour_celeste_moteur_nuages import H_CANON, TILE_SIZE, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "MLS1"
MAP_TITLE = "Mont Lointain — Sommet de Ho-Oh (Mt. Faraway Peak)"

HERE = Path(__file__).resolve().parent
BRUT_PATH = OUT_BRUT_PATH
CANOPY_PATH = OUT_CANOPY_PATH
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = OUT_REF_CANON_PATH
RENDERS_DIR = REPO_ROOT / "renders" / "mont_lointain_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    if not BRUT_PATH.is_file() or not CANOPY_PATH.is_file() or not CANON_REF.is_file():
        assemble_mont_lointain_sommet_1x()

    rgb_nat = np.asarray(Image.open(BRUT_PATH).convert("RGB"), dtype=np.uint8)
    canopy_nat = np.asarray(Image.open(CANOPY_PATH).convert("RGBA"), dtype=np.uint8)

    yy_n, xx_n = np.mgrid[0:H_NAT, 0:W_NAT]
    mag_nat = (rgb_nat[:, :, 0] >= 245) & (rgb_nat[:, :, 1] <= 12) & (rgb_nat[:, :, 2] >= 245)
    solid_nat = ~mag_nat

    r_c = rgb_nat[:, :, 0].astype(np.int16)
    g_c = rgb_nat[:, :, 1].astype(np.int16)
    b_c = rgb_nat[:, :, 2].astype(np.int16)

    sky_1, cld_far_64, rainbows_24, cld_near_64, top_24 = build_sommet_hooh_atmosphere_layers(
        mag_mask=mag_nat,
        canopy_nat=canopy_nat,
    )

    # Partition disjointe en 5 calques statiques riches (04, 05, 06, 07, 08) :
    # Calque 08 : Fougères émeraude suspendues & mousses vertes des piliers karstiques
    is_ferns = solid_nat & (g_c >= 88) & (g_c > r_c + 12) & (g_c > b_c + 14)

    # Calque 04 : Aiguilles karstiques lointaines émergeant de la mer de nuages (bords latéraux & horizon Nord)
    distant_zone = (
        ((xx_n < 118) | (xx_n > W_NAT - 118))
        | ((yy_n < 196) & (np.abs(xx_n - 384) > 152))
    )
    is_distant_spires = solid_nat & (~is_ferns) & distant_zone

    # Calque 05 : Grand Escalier sacré Sud & terrasses courbes sculptées (y >= 378 dans l'axe Sud)
    stairs_zone = (yy_n >= 378) & (xx_n >= 168) & (xx_n <= W_NAT - 168)
    is_grand_stairs = solid_nat & (~is_ferns) & (~is_distant_spires) & stairs_zone

    # Calque 06 : Vaste Plateau d'ivoire craquelé & Autel concentrique Nord de Ho-Oh
    is_ivory_stone = (r_c >= 176) & (g_c >= 168) & (b_c >= 116)
    arena_box = (yy_n >= 186) & (yy_n < 382) & (xx_n >= 148) & (xx_n <= W_NAT - 148)
    is_hooh_arena = solid_nat & (~is_ferns) & (~is_distant_spires) & (~is_grand_stairs) & arena_box & is_ivory_stone

    # Calque 07 : Grand Monolithe sacré Nord & Piliers karstiques d'enceinte
    is_karst_pillars = (
        solid_nat
        & (~is_ferns)
        & (~is_distant_spires)
        & (~is_grand_stairs)
        & (~is_hooh_arena)
    )

    def mk_static_scaled(mask_bool: np.ndarray) -> Image.Image:
        rgba = np.zeros((H_NAT, W_NAT, 4), dtype=np.uint8)
        rgba[mask_bool, :3] = rgb_nat[mask_bool]
        rgba[mask_bool, 3] = 255
        im = Image.fromarray(sanitize_rgba_binary(rgba))
        return im if (w, h) == (W_NAT, H_NAT) else im.resize((w, h), Image.Resampling.NEAREST)

    # Grille de collision : montée continue depuis l'escalier Sud (y=71) jusqu'à l'autel Nord de Ho-Oh
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    cliff_margin = ndimage.binary_dilation(mag_nat, iterations=5)
    walk_stairs = is_grand_stairs & (np.abs(xx_n - 384) <= 92) & (r_c >= 158)
    walk_arena = is_hooh_arena & (~cliff_margin)
    walk_nat = walk_stairs | walk_arena
    walk_img = Image.fromarray((walk_nat.astype(np.uint8) * 255)).resize((gw, gh), Image.Resampling.NEAREST)
    walk_grid = np.asarray(walk_img) >= 128

    cx_t = gw // 2
    altar_top_t = max(25, int(round(0.36 * gh)))
    for ty in range(altar_top_t, gh):
        walk_grid[ty, max(0, cx_t - 4) : min(gw, cx_t + 4)] = True
    walk_grid[:24, :] = False
    walk_grid[:, :4] = False
    walk_grid[:, -4:] = False

    layers = [
        LayerEntry("00_ciel_azur_celeste_h05p02", "Voûte Céleste Azur Courbée H05P02", "BG", _resize_frames(sky_1, w, h), frame_length=5),
        LayerEntry("01_mer_nuages_lointaine_doree", "Mer de Nuages Sacrée Dorée B72 Statique", "BG", _resize_frames(cld_far_64, w, h), frame_length=5),
        LayerEntry("02_vagues_cumulus_sacres_pmd", "Vagues de Cumulus Sacrés PMD Statiques", "BG", _resize_frames(cld_near_64, w, h), frame_length=5),
        LayerEntry("03_arcs_en_ciel_sacres_h05p02", "Arcs-en-Ciel Pixel-Art GBA H05P02 de Ho-Oh", "BG", _resize_frames(rainbows_24, w, h), frame_length=5),
        LayerEntry("04_aiguilles_karst_horizon_h05", "Aiguilles Karstiques d'Horizon H05P02", "BG", [mk_static_scaled(is_distant_spires)], frame_length=5),
        LayerEntry("05_grand_escalier_et_terrasses_sud", "Grand Escalier Sacré Sud & Terrasses B72", "BG", [mk_static_scaled(is_grand_stairs)], frame_length=5),
        LayerEntry("06_plateau_ivoire_et_autel_hooh", "Plateau d'Ivoire Sacré & Autel Nord de Ho-Oh", "BG", [mk_static_scaled(is_hooh_arena)], frame_length=5),
        LayerEntry("07_piliers_karstiques_et_monolithe", "Monolithe Nord & Piliers Karstiques B72", "BG", [mk_static_scaled(is_karst_pillars)], frame_length=5),
        LayerEntry("08_fougeres_emeraude_suspendues", "Fougères Émeraude Suspendues & Mousses", "BG", [mk_static_scaled(is_ferns)], frame_length=5),
        LayerEntry("09_voiles_nuages_et_plumes_hooh_top", "Cimes, Brume Dorée Légère & Plumes Arc-en-Ciel Top", "Top", _resize_frames(top_24, w, h), frame_length=6),
    ]
    return layers, walk_grid


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    h = max(64, int(round(H_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    VIRTUAL_ZIP.parent.mkdir(parents=True, exist_ok=True)
    layers, walk_grid = build_layers_for_size(w, h)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=CANON_REF,
        max_fidelity_distance=30.0,
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
