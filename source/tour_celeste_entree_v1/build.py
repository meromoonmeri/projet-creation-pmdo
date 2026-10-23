#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
TCE1 — Tour Céleste — Entrée des Tornades Géantes (`D13P01` + Tornades 3D rotatives sur elles-mêmes).

Spécifications :
- Fidélité directe à `D13P01` et à la référence utilisateur (`ref_entree_tornades_user.png`) ;
- **Chemin de nuage festonné continu Sud -> Nord** depuis le bord Sud (`y = 71`) à travers la grande
  esplanade centrale jusqu'à l'œil sombre du portail de la Tour Céleste au Nord (`donjon_seuil`) ;
- **Deux tornades géantes de chaque côté tournant réellement sur elles-mêmes (`360°`, `24` poses @ `5` ticks)** :
  * `04` Volutes cycloniques arrière (`BG`, `cos α < 0`, occultées par le cône),
  * `05` Corps cylindriques 3D rotatifs (`BG`, projection `arcsin(u)` + silhouette hélicoïdale tournante),
  * `08` Massifs de cumulus blancs d'avant-plan aux coins Sud-Ouest et Sud-Est devant le pied des tornades,
  * `09` Croissants d'air cycloniques fouettant devant les tornades (`Top`, `cos α >= 0`).
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

from moteur_tornade_3d_tour_celeste import build_twin_spinning_tornadoes  # type: ignore
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
    quantize_rgb_to_palette,
)

MAP_ID = "TCE1"
MAP_TITLE = "Tour Céleste — Entrée"
RAW_DIR = HERE / "bruts"
ESPLANADE_RAW = RAW_DIR / "esplanade_sans_tornades_chemin_sud_nord.png"
REF_DIR = HERE / "references"
USER_REF = REF_DIR / "ref_entree_tornades_user.png"
D13P01_REF = REF_DIR / "d13p01_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_celeste_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _build_d13p01_palette() -> np.ndarray:
    ref_arr = np.asarray(Image.open(D13P01_REF).convert("RGB"), dtype=np.uint8)
    u_ref, _ = np.unique(ref_arr.reshape(-1, 3), axis=0, return_counts=True)
    anchors = np.array(
        [
            [0, 64, 224],
            [12, 82, 240],
            [24, 112, 250],
            [56, 152, 255],
            [104, 192, 255],
            [143, 199, 255],
            [167, 215, 255],
            [196, 238, 255],
            [215, 255, 255],
            [236, 255, 255],
            [255, 255, 255],
            [4, 10, 48],
            [12, 26, 92],
            [28, 56, 148],
        ],
        dtype=np.uint8,
    )
    return np.unique(np.vstack([u_ref, anchors]), axis=0).astype(np.uint8)


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    im = Image.open(ESPLANADE_RAW).convert("RGB")
    raw_rgb = np.asarray(im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()
    pal = _build_d13p01_palette()
    q_rgb = quantize_rgb_to_palette(raw_rgb, pal)

    yy, xx = np.mgrid[:h, :w]
    r = q_rgb[:, :, 0].astype(np.int16)
    g = q_rgb[:, :, 1].astype(np.int16)
    b = q_rgb[:, :, 2].astype(np.int16)

    # 1. Ciel cobalt royal continu (`00`, teinte canonique unifiée `D13P01` sans bande horizontale)
    sky_bg = np.empty((h, w, 4), dtype=np.uint8)
    sky_bg[:, :, 3] = 255
    sky_bg[:, :, :3] = np.array([0, 64, 224], dtype=np.uint8)
    im_00_sky = Image.fromarray(sky_bg, mode="RGBA")

    # 2. Séparation sémantique de la scène `D13P01` :
    # - `portal_eye` : bouche d'orage sombre Nord (`donjon_seuil`, `y ≈ 0.08..0.25h, x ≈ 0.42..0.58w`)
    portal_box = (yy >= int(0.08 * h)) & (yy <= int(0.26 * h)) & (xx >= int(0.42 * w)) & (xx <= int(0.58 * w))
    portal_eye = portal_box & (b < 165) & (r < 60)

    # - `fg_corner_clouds` : massifs de cumulus blancs tout en bas (`y >= 0.815h`, sous l'espace de ciel vide à y≈468 !)
    is_cloud_matter = (g >= 145) & (b >= 225) & (~((r < 35) & (g < 105)))
    fg_corner_clouds = (
        is_cloud_matter
        & (yy >= int(0.815 * h))
        & (np.abs(xx - 0.50 * w) >= 0.165 * w)
    )

    # - `esplanade_and_bridge` : grande esplanade centrale + pont Sud-Nord continu jusqu'à `y = h - 1` !
    center_corridor = (
        ((yy >= int(0.21 * h)) & (yy <= int(0.84 * h)) & (np.abs(xx - 0.50 * w) <= 0.215 * w))
        | ((yy >= int(0.76 * h)) & (np.abs(xx - 0.50 * w) <= 0.30 * w))
    )
    esplanade_matter = is_cloud_matter & center_corridor & (~portal_eye) & (~fg_corner_clouds)

    # Panaches d'orage supérieurs rayonnant autour du portail (`01`, respiration douce BPL `D13P01`)
    storm_plumes = is_cloud_matter & (~esplanade_matter) & (~fg_corner_clouds) & (~portal_eye) & (yy < int(0.58 * h))

    # Socle continu sous toute l'esplanade (`02`)
    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[esplanade_matter, :3] = np.array([215, 255, 255], dtype=np.uint8)
    base_arr[esplanade_matter, 3] = 255
    im_02_base = Image.fromarray(base_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[m, :3] = q_rgb[m]
        arr[m, 3] = 255
        return Image.fromarray(arr, mode="RGBA")

    # `01` : Respiration BPL subtile sur les panaches d'orage supérieurs
    frames_01_plumes: List[Image.Image] = []
    plume_shades = [
        np.array([239, 255, 255], dtype=np.uint8),
        np.array([215, 247, 255], dtype=np.uint8),
        np.array([183, 231, 255], dtype=np.uint8),
    ]
    plume_halo = storm_plumes & (r >= 175) & (r < 248)
    for t in range(N_FRAMES):
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        fr[storm_plumes, :3] = q_rgb[storm_plumes]
        fr[storm_plumes, 3] = 255
        idx_s = int((1.0 + np.sin(2.0 * np.pi * (t / float(N_FRAMES)))) * 1.49)
        fr[plume_halo, :3] = plume_shades[idx_s]
        frames_01_plumes.append(Image.fromarray(fr, mode="RGBA"))

    im_03_esplanade = _mk_layer(esplanade_matter)

    # `04`, `05`, `09` : TORNADES GÉANTES GAUCHE & DROITE EN VRAIE ROTATION 3D SUR ELLES-MÊMES !
    frames_04_back, frames_05_tornadoes, frames_09_front = build_twin_spinning_tornadoes(
        w, h, n_frames=N_FRAMES, mode="entrance"
    )

    # `06` : Portail sombre de l'œil du cyclone au Nord + arche nuageuse immédiate
    portal_ring = ndimage.binary_dilation(portal_eye, iterations=max(2, int(round(4 * w / 768.0)))) & (
        portal_eye | is_cloud_matter
    )
    im_06_portal = _mk_layer(portal_ring)

    # `07` : Onde lumineuse cyan-blanc `D13P01.bpl` remontant le long du chemin Sud -> Nord vers le portail
    crest_pixels = esplanade_matter & (r >= 248) & (g >= 252) & (b >= 252)
    band_h = max(8.0, 28.0 * (h / 576.0))
    frames_07_wave: List[Image.Image] = []
    for t in range(N_FRAMES):
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        ph = ((yy // int(band_h)) + (t // 3)) % 4
        fr[crest_pixels, :3] = np.array([255, 255, 255], dtype=np.uint8)
        fr[crest_pixels & (ph == 2), :3] = np.array([191, 239, 255], dtype=np.uint8)
        fr[crest_pixels, 3] = 255
        frames_07_wave.append(Image.fromarray(fr, mode="RGBA"))

    # `08` : Cumulus blancs d'avant-plan aux coins Sud-Ouest et Sud-Est (statiques comme demandé sur STC1)
    im_08_fg_clouds = _mk_layer(fg_corner_clouds)

    # Grille de collision `96 × 72` : chemin de nuage continu du bord Sud (`y = 71`) jusqu'au portail Nord (`y ≈ 15`) !
    walk_px = esplanade_matter & (r >= 195) & (np.abs(xx - 0.50 * w) <= 0.19 * w)
    walk_px = ndimage.binary_fill_holes(walk_px)
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walk_px[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.65

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_ciel_cobalt_tempete_d13p01", "Ciel Cobalt Royal D13P01", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_panaches_orageux_rayonnants", "Panaches d'Orage Rayonnants", "BG", frames_01_plumes, frame_length=5),
        LayerEntry("02_socle_nuageux_continu", "Socle Nuageux Continu", "BG", [im_02_base], frame_length=5),
        LayerEntry("03_esplanade_et_chemin_sud_nord", "Esplanade & Chemin Nuage Sud-Nord", "BG", [im_03_esplanade], frame_length=5),
        LayerEntry("04_volutes_arriere_tornades", "Volutes Arrière des Tornades (360°)", "BG", frames_04_back, frame_length=5),
        LayerEntry("05_corps_rotatif_tornades_3d", "Tornades Géantes en Rotation 3D", "BG", frames_05_tornadoes, frame_length=5),
        LayerEntry("06_portail_oeil_cyclone_nord", "Portail Œil du Cyclone Nord", "BG", [im_06_portal], frame_length=5),
        LayerEntry("07_onde_lumineuse_esplanade_bpl", "Onde Lumineuse Nuages D13P01", "BG", frames_07_wave, frame_length=5),
        LayerEntry("08_cumulus_avant_plan_angles", "Cumulus Blancs d'Avant-Plan", "BG", [im_08_fg_clouds], frame_length=5),
        LayerEntry("09_rubans_cycloniques_avant_top", "Croissants Cycloniques Avant (360°)", "Top", frames_09_front, frame_length=5),
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
        canonical_ref_for_fidelity=USER_REF,
        max_fidelity_distance=34.0,
        max_unique_tiles_per_bank=65000,
        namespace_override="tour_celeste_tce1",
        asset_name_override="tour_celeste_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
