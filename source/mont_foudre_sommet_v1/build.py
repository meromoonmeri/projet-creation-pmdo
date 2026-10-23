#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MFA1 — Mont Foudre — Cime d'Électhor (`POV PMD`, référence canonique `h17p01_thunder_meadow_native.png`).

Fidélité maximale à `H17P01` (*Thunder Meadow / Zapdos Peak — PMD Red*) + découpe 100 % `#FF00FF` :
- Tout le ciel d'orage au Nord, les gouffres entre les îlots rocheux suspendus et la faille en zigzag d'Électhor
  sont détourés en `#FF00FF` pur sur `bruts/base_mont_foudre_sommet.png` ;
- Les 4 rochers magnétiques, les îlots suspendus et l'arbre foudroyé demeurent **100 % statiques (`poses = 1`)** ;
- `MFA1_00` (`BG`, `1` pose) : Voûte de cumulo-nimbus d'orage `H17P01` `1×` ;
- `MFA1_01` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Nuées d'orage dérivantes & flashs zénithaux ;
- `MFA1_02` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Arcs électriques matériels GBA `H17P01W1.bpa` `1×` ;
- `MFA1_03` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Faille plasma en zigzag d'Électhor au Nord ;
- `MFA1_04` (`BG`, `1` pose) : Socle continu du plateau foudroyé ;
- `MFA1_05` (`BG`, `1` pose) : Îlots rocheux suspendus & 4 rochers magnétiques (`100 %` statiques) ;
- `MFA1_06` (`BG`, `1` pose) : Esplanade dorée d'Électhor & chemin Sud-Nord ;
- `MFA1_07` (`BG`, `1` pose) : Arbre ancestral foudroyé (`100 %` statique) ;
- `MFA1_08` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Onde électromagnétique autour des rochers magnétiques ;
- `MFA1_09` (`Top`, `24` poses @ `5` ticks = `120` ticks) : Étincelles dorées & décharges d'Électhor en couche `Top`.
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

from moteur_eau_et_glace_canonique_pmd import (  # type: ignore
    build_electric_sparks_top_frames,
    build_storm_and_lightning_layers,
    sanitize_palette_no_magenta,
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

MAP_ID = "MFA1"
MAP_TITLE = "Mont Foudre — Cime d'Électhor"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_mont_foudre_sommet.png"
REF_DIR = HERE / "references"
H17P01_REF = REF_DIR / "h17p01_thunder_meadow_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_foudre_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_magnetic_ring_frames(
    w: int,
    h: int,
    boulder_mask: np.ndarray,
    walkable_mask: np.ndarray,
    n_frames: int = 24,
) -> List[Image.Image]:
    """Onde électromagnétique subtile courant sur l'herbe dorée au pied des 4 rochers magnétiques."""
    dist = ndimage.distance_transform_edt(~boulder_mask).astype(np.float32)
    scale = max(1.0, w / 768.0)
    c_glow = np.array([252, 248, 172], dtype=np.uint8)
    frames: List[Image.Image] = []
    for t in range(n_frames):
        rad = (1.5 + 7.5 * (float(t) / float(n_frames))) * scale
        ring = walkable_mask & (np.abs(dist - rad) <= 0.9 * scale)
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        arr[ring, :3] = c_glow
        arr[ring, 3] = 255
        frames.append(Image.fromarray(arr, mode="RGBA"))
    return frames


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_im = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    raw_rgb = np.asarray(raw_im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    yy, xx = np.mgrid[:h, :w]
    r = raw_rgb[:, :, 0].astype(np.int16)
    g = raw_rgb[:, :, 1].astype(np.int16)
    b = raw_rgb[:, :, 2].astype(np.int16)

    # 1. Découpe stricte par composante connexe de la faille en zigzag vs voûte céleste Nord
    #    (zéro triangle rectangulaire parasite derrière la crête Nord !)
    all_magenta = (r >= 220) & (g <= 35) & (b >= 220)
    below_lip = all_magenta & (yy >= int(0.320 * h))
    lbl_m, n_m = ndimage.label(below_lip)
    fissure_mask = np.zeros((h, w), dtype=bool)
    for cid in range(1, n_m + 1):
        comp = lbl_m == cid
        ys_c, xs_c = np.where(comp)
        if xs_c.min() >= int(0.40 * w) and xs_c.max() <= int(0.60 * w) and ys_c.max() >= int(0.36 * h):
            fissure_mask |= comp
    sky_mask = all_magenta & (~fissure_mask)
    terrain_mask = ~all_magenta

    # 2. Palette canonique `H17P01` sans aucune dérive magenta
    ref_pal = extract_canonical_palette([H17P01_REF], max_colors=64, min_pixels=8)
    terr_px = raw_rgb[terrain_mask]
    uniq, cnt = np.unique(terr_px, axis=0, return_counts=True)
    top_terr = uniq[np.argsort(-cnt)[:64]]
    pal = sanitize_palette_no_magenta(np.vstack([ref_pal, top_terr]), max_gap=22)
    q_rgb = quantize_rgb_to_palette(raw_rgb, pal)

    # 3. Partition sémantique :
    #    - `dead_tree_mask` : arbre ancestral foudroyé au centre-Sud (`poses = 1`, non marchable)
    #    - `boulder_mask` : les 4 rochers magnétiques gris-bleuté (`poses = 1`, non marchables)
    #    - `walkable_plateau` : herbe dorée centrale continue du Sud jusqu'au bord de la faille Nord
    #    - `floating_cliffs` : îlots rocheux suspendus & falaises périphériques (`poses = 1`)
    tree_box = (yy >= int(0.55 * h)) & (yy <= int(0.81 * h)) & (xx >= int(0.42 * w)) & (xx <= int(0.58 * w))
    dead_tree_mask = terrain_mask & tree_box & (q_rgb[:, :, 0] < 185) & (q_rgb[:, :, 1] < 165)

    boulder_mask = (
        terrain_mask
        & (q_rgb[:, :, 2] >= 125)
        & ((q_rgb[:, :, 2].astype(np.int16) - q_rgb[:, :, 0].astype(np.int16)) >= 12)
    )

    fissure_guard = ndimage.binary_dilation(fissure_mask, iterations=max(1, int(round(2 * w / 768.0))))
    golden_grass = (
        terrain_mask
        & (~dead_tree_mask)
        & (~boulder_mask)
        & (~fissure_guard)
        & (q_rgb[:, :, 0] >= 175)
        & (q_rgb[:, :, 1] >= 165)
        & (q_rgb[:, :, 2] <= 155)
    )
    lbl_g, _ = ndimage.label(ndimage.binary_closing(golden_grass, iterations=max(1, int(round(2 * w / 768.0)))))
    south_ids = set(lbl_g[h - 6 :, int(0.40 * w) : int(0.60 * w)].ravel().tolist()) - {0}
    walkable_plateau = np.isin(lbl_g, list(south_ids)) & terrain_mask & (~dead_tree_mask) & (~boulder_mask) & (~fissure_guard)

    floating_cliffs_and_boulders = terrain_mask & (~walkable_plateau) & (~dead_tree_mask)

    # 4. Couches 00..09
    im_00_sky, frames_01_clouds, frames_02_bolts, frames_03_fissure = build_storm_and_lightning_layers(
        w=w,
        h=h,
        sky_mask=sky_mask,
        fissure_mask=fissure_mask,
        bolt_anchors_xy=[(0.26, 0.04, 0.28), (0.50, 0.03, 0.25), (0.74, 0.04, 0.28)],
        n_frames=N_FRAMES,
    )

    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[terrain_mask, :3] = np.array([216, 206, 98], dtype=np.uint8)
    base_arr[terrain_mask, 3] = 255
    im_04_base = Image.fromarray(base_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_rgb[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_05_cliffs_boulders = _mk_layer(floating_cliffs_and_boulders)
    im_06_plateau = _mk_layer(walkable_plateau)
    im_07_tree = _mk_layer(dead_tree_mask)
    frames_08_mag_wave = build_magnetic_ring_frames(
        w=w, h=h, boulder_mask=boulder_mask, walkable_mask=walkable_plateau, n_frames=N_FRAMES
    )
    frames_09_sparks = build_electric_sparks_top_frames(w=w, h=h, n_frames=N_FRAMES, seed=20261102)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_plateau[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.50

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_voute_orage_h17p01", "Voûte de Cumulo-Nimbus H17P01 1×", "BG", [im_00_sky], frame_length=5),
        LayerEntry("01_nuees_orageuses_zenithales", "Nuées d'Orage & Flashs Zénithaux", "BG", frames_01_clouds, frame_length=5),
        LayerEntry("02_arcs_foudre_gba_h17p01w", "Arcs Électriques GBA H17P01W1.bpa 1×", "BG", frames_02_bolts, frame_length=5),
        LayerEntry("03_faille_plasma_zigzag_electhor", "Faille Plasma Foudroyée d'Électhor", "BG", frames_03_fissure, frame_length=5),
        LayerEntry("04_socle_plateau_foudre", "Socle du Plateau Foudroyé", "BG", [im_04_base], frame_length=5),
        LayerEntry("05_ilots_et_rochers_magnetiques", "Îlots Suspendus & Rochers Magnétiques Statiques", "BG", [im_05_cliffs_boulders], frame_length=5),
        LayerEntry("06_esplanade_doree_sud_nord", "Esplanade Dorée d'Électhor & Chemin Sud-Nord", "BG", [im_06_plateau], frame_length=5),
        LayerEntry("07_arbre_ancestral_foudroye", "Arbre Ancestral Foudroyé Statique", "BG", [im_07_tree], frame_length=5),
        LayerEntry("08_onde_electromagnetique_rochers", "Onde Électromagnétique des Rochers", "BG", frames_08_mag_wave, frame_length=5),
        LayerEntry("09_etincelles_electhor_top", "Étincelles & Décharges d'Électhor Top", "Top", frames_09_sparks, frame_length=5),
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
        canonical_ref_for_fidelity=H17P01_REF,
        max_fidelity_distance=24.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mont_foudre_mfa1",
        asset_name_override="mont_foudre_sommet",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
