#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
TCM1 — Tour Céleste — Relais Céleste / Mi-Parcours (`D13P02` + Colonnes de Tornades 3D latérales).

Complète la trilogie canonique de la **Tour Céleste** (`TCE1` Entrée -> `TCM1` Relais -> `STC1` Sommet de Rayquaza) :
- Pont de nuage festonné et plateforme octogonale centrale `D13P02` traversant toute la carte du Sud (`y = 71`)
  jusqu'au Nord (`y = 0`) au-dessus du gouffre bleu cobalt royal ;
- Deux colonnes de tornades 3D tournant sur elles-mêmes dans les gouffres latéraux Ouest et Est (`01`, `02`, `09`)
  encadrées par les remparts de nuages stratosphériques (`04`) ;
- Sillages de courant-jet ascendants (`09` `Top`) et ondulation nacrée `D13P02` (`07`).
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

MAP_ID = "TCM1"
MAP_TITLE = "Tour Céleste — Relais Céleste"
RAW_DIR = HERE / "bruts"
RELAIS_RAW = RAW_DIR / "relais_d13p02_widescreen.png"
REF_DIR = HERE / "references"
D13P02_REF = REF_DIR / "d13p02_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_celeste_relais_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    ref_arr = np.asarray(Image.open(D13P02_REF).convert("RGB"), dtype=np.uint8)
    u_ref, _ = np.unique(ref_arr.reshape(-1, 3), axis=0, return_counts=True)
    anchors = np.array(
        [
            [24, 72, 232],
            [40, 79, 255],
            [55, 119, 255],
            [87, 135, 255],
            [159, 199, 247],
            [191, 223, 255],
            [223, 247, 255],
            [255, 255, 255],
        ],
        dtype=np.uint8,
    )
    pal = np.unique(np.vstack([u_ref, anchors]), axis=0).astype(np.uint8)

    im = Image.open(RELAIS_RAW).convert("RGB")
    raw_rgb = np.asarray(im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()
    q_rgb = quantize_rgb_to_palette(raw_rgb, pal)

    yy, xx = np.mgrid[:h, :w]
    r = q_rgb[:, :, 0].astype(np.int16)
    g = q_rgb[:, :, 1].astype(np.int16)
    b = q_rgb[:, :, 2].astype(np.int16)

    # 1. Gouffre bleu cobalt royal canonique unifié `D13P02` (`00`)
    sky = np.empty((h, w, 4), dtype=np.uint8)
    sky[:, :, 3] = 255
    sky[:, :, :3] = np.array([47, 79, 247], dtype=np.uint8)
    im_00_sky = Image.fromarray(sky, mode="RGBA")

    # 2. Colonnes de tornades 3D tournant sur elles-mêmes dans les gouffres latéraux Ouest & Est (`01`, `02`, `09`)
    frames_01_back, frames_02_tornado, frames_09_front = build_twin_spinning_tornadoes(
        w, h, n_frames=N_FRAMES, mode="relay"
    )

    # 3. Séparation nuages solides vs gouffres de ciel bleu cobalt (`r < 95 & g < 145 & b >= 225`)
    is_deep_sky = (r < 95) & (g < 145) & (b >= 225)
    cloud_matter = ~is_deep_sky

    # Pont Sud-Nord (`x ≈ 0.42..0.58`) + plateforme octogonale centrale (`y ≈ 0.30..0.70, x ≈ 0.34..0.66`)
    bridge_zone = (
        (np.abs(xx - 0.50 * w) <= 0.078 * w)
        | ((yy >= int(0.32 * h)) & (yy <= int(0.68 * h)) & (np.abs(xx - 0.50 * w) <= 0.155 * w))
    )
    walkable_bridge = cloud_matter & bridge_zone
    rim_highlights = walkable_bridge & (r >= 245) & (g >= 250)
    bridge_body = walkable_bridge & (~rim_highlights)
    cloud_walls = cloud_matter & (~walkable_bridge)

    # Socle continu sous toute la masse nuageuse (`03`)
    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[cloud_matter, :3] = np.array([223, 247, 255], dtype=np.uint8)
    base_arr[cloud_matter, 3] = 255
    im_03_base = Image.fromarray(base_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[m, :3] = q_rgb[m]
        arr[m, 3] = 255
        return Image.fromarray(arr, mode="RGBA")

    im_04_walls = _mk_layer(cloud_walls)
    im_05_bridge = _mk_layer(bridge_body)
    im_06_rim = _mk_layer(rim_highlights)

    # `07` : Respiration nacrée sur les crêtes des remparts nuageux
    wall_crests = cloud_walls & (r >= 231) & (r < 252) & (b >= 247)
    frames_07_breath: List[Image.Image] = []
    for t in range(N_FRAMES):
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        sv = np.sin(2.0 * np.pi * (t / float(N_FRAMES)))
        fr[wall_crests, :3] = np.array([255, 255, 255] if sv > 0.25 else [223, 247, 255], dtype=np.uint8)
        fr[wall_crests, 3] = 255
        frames_07_breath.append(Image.fromarray(fr, mode="RGBA"))

    # `08` : Volutes courbes d'altitude glissant en douceur dans le gouffre central (sans bande droite !)
    central_chasm = is_deep_sky & (np.abs(xx - 0.50 * w) <= 0.22 * w)
    wisp_seeds = [(0.40, 0.35, 0), (0.60, 0.36, 12), (0.41, 0.65, 6), (0.59, 0.64, 18)]
    frames_08_mist: List[Image.Image] = []
    for t in range(N_FRAMES):
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        for sx, sy, ph in wisp_seeds:
            u = ((t + ph) % N_FRAMES) / float(N_FRAMES)
            cx = w * (sx + 0.015 * np.sin(2.0 * np.pi * u))
            cy = h * (sy - 0.06 * np.sin(np.pi * u))
            rx_w = max(8.0, 22.0 * w / 768.0)
            ry_w = max(3.0, 5.5 * h / 576.0)
            arc_m = (
                central_chasm
                & ((((xx - cx) / rx_w) ** 2 + ((yy - cy - 0.12 * ((xx - cx) ** 2) / rx_w) / ry_w) ** 2) <= 1.0)
            )
            fr[arc_m, :3] = np.array([159, 199, 255], dtype=np.uint8)
            fr[arc_m, 3] = 255
        frames_08_mist.append(Image.fromarray(fr, mode="RGBA"))

    # Ajouter également des sillages de courant-jet ascendants au-dessus des bords sur `09 Top`
    jet_tracks = [(0.34, 0.85, 0), (0.66, 0.80, 12), (0.36, 0.45, 6), (0.64, 0.48, 18)]
    frames_09_combined: List[Image.Image] = []
    for t in range(N_FRAMES):
        arr = np.asarray(frames_09_front[t], dtype=np.uint8).copy()
        for fx, fy, ph in jet_tracks:
            u = ((t + ph) % N_FRAMES) / float(N_FRAMES)
            if 0.10 <= u <= 0.90:
                cx = int(round(w * fx))
                cy = int(round(h * (fy - 0.28 * u)))
                L = max(6, int(round(18 * h / 576.0 * np.sin(np.pi * u))))
                for d in range(L):
                    if 0 <= cy + d < h and 0 <= cx < w:
                        arr[cy + d, cx] = np.array([255, 255, 255, 255], dtype=np.uint8)
        frames_09_combined.append(Image.fromarray(arr, mode="RGBA"))

    # Grille de collision `96 × 72` traversante Sud (`y = 71`) -> Plateforme octogonale -> Nord (`y = 0`) !
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_bridge[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.65

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]
    walk_grid[0, :] |= walk_grid[1, :]

    layers = [
        LayerEntry("00_gouffre_stratospherique_d13p02", "Gouffre Bleu Cobalt D13P02", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_vortex_arriere_gouffres", "Volutes Arrière Tornades Latérales", "BG", frames_01_back, frame_length=5),
        LayerEntry("02_colonnes_tornades_gouffres_3d", "Colonnes Cycloniques Rotatives 3D", "BG", frames_02_tornado, frame_length=5),
        LayerEntry("03_socle_nuage_relais_continu", "Socle Nuageux Continu", "BG", [im_03_base], frame_length=5),
        LayerEntry("04_remparts_nuageux_lateraux_d13p02", "Remparts de Nuages D13P02", "BG", [im_04_walls], frame_length=5),
        LayerEntry("05_pont_et_plateforme_octogonale", "Pont Céleste Sud-Nord & Octogone", "BG", [im_05_bridge], frame_length=5),
        LayerEntry("06_reliefs_festons_plateforme", "Crêtes & Festons du Pont Céleste", "BG", [im_06_rim], frame_length=5),
        LayerEntry("07_respiration_bpl_nuages_relais", "Ondulation Nacrée des Nuages", "BG", frames_07_breath, frame_length=5),
        LayerEntry("08_brumes_derive_haute_altitude", "Filets de Brume du Gouffre Central", "BG", frames_08_mist, frame_length=5),
        LayerEntry("09_courants_jet_et_volutes_top", "Rubans Cycloniques & Courants-Jet", "Top", frames_09_combined, frame_length=5),
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
        canonical_ref_for_fidelity=D13P02_REF,
        max_fidelity_distance=35.0,
        max_unique_tiles_per_bank=36000,
        namespace_override="tour_celeste_tcm1",
        asset_name_override="tour_celeste_relais",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
