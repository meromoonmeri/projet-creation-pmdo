#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MHE1 — Mer Houleuse — Entrée de la Fosse Abyssale (`POV PMD`, référence `h02p02_deep_sea_current_native.png`).

Architecture fidèle à `H02P02` (*Deep-Sea Current / Stormy Sea Trench — PMD Red*) + découpe 100 % `#FF00FF` :
- Toute la fosse océanique abyssale et l'intérieur du grand puits circulaire Nord sont peints en `#FF00FF`
  pur sur `bruts/base_mer_houleuse_entree.png` (zéro eau statique cuite sur le brut) ;
- `MHE1_00` (`BG`, `12` poses @ `10` ticks = `120` ticks) : Abysse océanique `H10P02.bpl` `1×` saphir-outremer ;
- `MHE1_01` (`BG`, `15` poses @ `8` ticks = `120` ticks) : Courants marins matériels GBA `H02P02W.bpl` `1×` & vortex Nord ;
- `MHE1_02` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Anneaux d'écume aspirés par le puits abyssal ;
- `MHE1_03` (`BG`, `1` pose) : Socle récifal englouti continu ;
- `MHE1_04` (`BG`, `1` pose) : Chaussée antique engloutie Sud-Nord & margelle circulaire Nord ;
- `MHE1_05` (`BG`, `1` pose) : Falaises abyssales étagées, coraux & stèles runiques (`100 %` statiques) ;
- `MHE1_06` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Caustiques sous-marines sur la chaussée engloutie ;
- `MHE1_07` (`BG`, `15` poses @ `8` ticks = `120` ticks) : Colonnes de bulles matérielles GBA `H02P03W1.bpa` `1×` ;
- `MHE1_08` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Lueur runique des 4 stèles englouties ;
- `MHE1_09` (`Top`, `24` poses @ `5` ticks = `120` ticks) : Plancton abyssal bioluminescent en couche `Top`.
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
    build_abyssal_water_and_current_layers,
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

MAP_ID = "MHE1"
MAP_TITLE = "Mer Houleuse — Entrée de la Fosse Abyssale"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_mer_houleuse_entree.png"
REF_DIR = HERE / "references"
H02P02_REF = REF_DIR / "h02p02_deep_sea_current_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mer_houleuse_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_caustics_and_plankton_layers(
    w: int,
    h: int,
    q_rgb: np.ndarray,
    wet_rim_mask: np.ndarray,
    well_water_mask: np.ndarray,
    obelisk_mask: np.ndarray,
    n_frames: int = 24,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit :
    - `well_rings` (`24 × 5 = 120` ticks) : ondes concentriques convergentes dans le puits Nord,
    - `caustics` (`24 × 5 = 120` ticks) : reflets d'eau subtils sur la bordure humide des dalles (`q_rgb + [10,20,30]`),
    - `obelisk_glow` (`24 × 5 = 120` ticks) : pulsation douce sur les gravures des 4 stèles,
    - `plankton_top` (`Top`, `24 × 5 = 120` ticks) : plancton bioluminescent `1×` remontant des abysses."""
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    vx, vy, vr = 0.50 * w, 0.215 * h, 0.145 * w
    rad = np.sqrt(((xx - vx) / max(1.0, vr)) ** 2 + ((yy - vy) / max(1.0, vr * 0.72)) ** 2)

    well_rings: List[Image.Image] = []
    caustics: List[Image.Image] = []
    obelisk_glow: List[Image.Image] = []

    c_foam = np.array([176, 240, 255], dtype=np.uint8)
    wet_lit = np.clip(q_rgb.astype(np.int16) + np.array([10, 22, 32], dtype=np.int16), 0, 255).astype(np.uint8)
    c_obelisk = np.array([92, 216, 246], dtype=np.uint8)

    for t in range(n_frames):
        ph = 2.0 * np.pi * float(t) / float(n_frames)
        wave = np.sin(2.0 * np.pi * 2.0 * rad + ph)
        ring = well_water_mask & (rad <= 0.94) & (rad >= 0.14) & (wave >= 0.90)
        a_ring = np.zeros((h, w, 4), dtype=np.uint8)
        a_ring[ring, :3] = c_foam
        a_ring[ring, 3] = 255
        well_rings.append(Image.fromarray(a_ring, mode="RGBA"))

        shimmer = np.sin(2.0 * np.pi * (yy / max(24.0, h * 0.12)) + ph)
        c_m = wet_rim_mask & (shimmer >= 0.35)
        a_caus = np.zeros((h, w, 4), dtype=np.uint8)
        a_caus[c_m, :3] = wet_lit[c_m]
        a_caus[c_m, 3] = 255
        caustics.append(Image.fromarray(a_caus, mode="RGBA"))

        # 3) Pulsation runique des stèles
        ob_wave = np.sin(2.0 * np.pi * (yy / max(18.0, h * 0.12)) - ph)
        o_m = obelisk_mask & (ob_wave >= 0.35)
        a_ob = np.zeros((h, w, 4), dtype=np.uint8)
        a_ob[o_m, :3] = c_obelisk
        a_ob[o_m, 3] = 255
        obelisk_glow.append(Image.fromarray(a_ob, mode="RGBA"))

    # 4) Plancton bioluminescent `1×` en couche Top
    rng = np.random.default_rng(20261103)
    n_p = 46
    px0 = rng.integers(0, w, size=n_p)
    py0 = rng.integers(0, h, size=n_p)
    p_col_idx = rng.integers(0, 2, size=n_p)
    p_cols = [np.array([152, 238, 255], dtype=np.uint8), np.array([92, 198, 248], dtype=np.uint8)]
    plankton_top: List[Image.Image] = []
    for t in range(n_frames):
        frac = float(t) / float(n_frames)
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        dy = int(round(frac * h))
        for i in range(n_p):
            sway = int(round(3.0 * np.sin(2.0 * np.pi * frac + i)))
            cx = (int(px0[i]) + sway) % w
            cy = (int(py0[i]) - dy) % h
            col = p_cols[int(p_col_idx[i])]
            arr[cy, cx, :3] = col
            arr[cy, cx, 3] = 255
            if cx + 1 < w and (i % 2 == 0):
                arr[cy, cx + 1, :3] = col
                arr[cy, cx + 1, 3] = 255
        plankton_top.append(Image.fromarray(arr, mode="RGBA"))

    return well_rings, caustics, obelisk_glow, plankton_top


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_im = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    raw_rgb = np.asarray(raw_im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    yy, xx = np.mgrid[:h, :w]
    r = raw_rgb[:, :, 0].astype(np.int16)
    g = raw_rgb[:, :, 1].astype(np.int16)
    b = raw_rgb[:, :, 2].astype(np.int16)

    # 1. Toute l'eau de la fosse et du puits Nord est en `#FF00FF` pur sur le brut !
    water_mask = (r >= 220) & (g <= 35) & (b >= 220)
    terrain_mask = ~water_mask

    # 2. Palette canonique `H02P02` sans dérive magenta (`min(R, B) - G <= 20`)
    ref_pal = extract_canonical_palette([H02P02_REF], max_colors=64, min_pixels=8)
    terr_px = raw_rgb[terrain_mask]
    uniq, cnt = np.unique(terr_px, axis=0, return_counts=True)
    top_terr = uniq[np.argsort(-cnt)[:64]]
    pal = sanitize_palette_no_magenta(np.vstack([ref_pal, top_terr]), max_gap=20)
    q_rgb = quantize_rgb_to_palette(raw_rgb, pal)

    # 3. Partition sémantique :
    #    - `causeway_and_rim` : chaussée engloutie centrale + margelle circulaire Nord
    #    - `reefs_and_obelisks` : falaises étagées, coraux et 4 stèles runiques (100 % statiques)
    well_disk = (((xx - 0.50 * w) / (0.19 * w)) ** 2 + ((yy - 0.22 * h) / (0.19 * h)) ** 2) <= 1.0
    central_causeway = terrain_mask & (
        ((xx >= int(0.35 * w)) & (xx <= int(0.65 * w)) & (yy >= int(0.28 * h)))
        | well_disk
    )
    reefs_and_obelisks = terrain_mask & (~central_causeway)

    # Zone marchable continue du bas-centre (`y = h - 1`) jusqu'au rebord Sud du puits Nord (`y = 0.30h`)
    water_guard = ndimage.binary_dilation(water_mask, iterations=max(2, int(round(3 * w / 768.0))))
    walkable_causeway = central_causeway & (~water_guard) & (yy >= int(0.30 * h)) & (xx >= int(0.41 * w)) & (xx <= int(0.59 * w))

    # Détection des gravures claires sur les 4 stèles latérales
    obelisk_boxes = (
        terrain_mask
        & (((xx >= int(0.16 * w)) & (xx <= int(0.24 * w))) | ((xx >= int(0.76 * w)) & (xx <= int(0.84 * w))))
        & (yy >= int(0.10 * h))
        & (yy <= int(0.76 * h))
        & (q_rgb[:, :, 2] >= 175)
    )
    well_water = water_mask & well_disk

    # 4. Couches matérielles GBA `H10P02.bpl` + `H02P02W.bpl` + `H02P03W1.bpa`
    frames_00_water, frames_01_currents, frames_07_bubbles = build_abyssal_water_and_current_layers(
        w=w,
        h=h,
        water_mask=water_mask,
        mode="trench",
        vortex_center_xy=(0.50, 0.215, 0.145),
    )
    wet_rim = central_causeway & ndimage.binary_dilation(water_mask, iterations=max(2, int(round(5 * w / 768.0))))
    frames_02_rings, frames_06_caustics, frames_08_obelisks, frames_09_plankton = build_caustics_and_plankton_layers(
        w=w,
        h=h,
        q_rgb=q_rgb,
        wet_rim_mask=wet_rim,
        well_water_mask=well_water,
        obelisk_mask=obelisk_boxes,
        n_frames=N_FRAMES,
    )

    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[terrain_mask, :3] = np.array([18, 72, 132], dtype=np.uint8)
    base_arr[terrain_mask, 3] = 255
    im_03_base = Image.fromarray(base_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_rgb[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_04_causeway = _mk_layer(central_causeway)
    im_05_reefs = _mk_layer(reefs_and_obelisks)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_causeway[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.50

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_abysse_oceanique_h10p02", "Abysse Océanique GBA H10P02.bpl 1×", "BG", frames_00_water, frame_length=10),
        LayerEntry("01_courants_marins_gba_h02p02w", "Courants Marins GBA H02P02W.bpl 1× & Vortex", "BG", frames_01_currents, frame_length=8),
        LayerEntry("02_ondes_puits_abyssal_nord", "Anneaux d'Écume du Puits Abyssal", "BG", frames_02_rings, frame_length=5),
        LayerEntry("03_socle_recifal_englouti", "Socle Récifal Englouti Continu", "BG", [im_03_base], frame_length=5),
        LayerEntry("04_chaussee_engloutie_sud_nord", "Chaussée Engloutie Sud-Nord & Margelle", "BG", [im_04_causeway], frame_length=5),
        LayerEntry("05_falaises_coraux_steles_statiques", "Falaises Abyssales, Coraux & Stèles Statiques", "BG", [im_05_reefs], frame_length=5),
        LayerEntry("06_caustiques_chaussee_engloutie", "Caustiques Sous-Marines", "BG", frames_06_caustics, frame_length=5),
        LayerEntry("07_bulles_abyssales_gba_h02p03w", "Colonnes de Bulles GBA H02P03W1.bpa 1×", "BG", frames_07_bubbles, frame_length=8),
        LayerEntry("08_lueur_steles_runiques", "Lueur Runique des Stèles Englouties", "BG", frames_08_obelisks, frame_length=5),
        LayerEntry("09_plancton_bioluminescent_top", "Plancton Abyssal Bioluminescent Top", "Top", frames_09_plankton, frame_length=5),
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
        canonical_ref_for_fidelity=H02P02_REF,
        max_fidelity_distance=34.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mer_houleuse_mhe1",
        asset_name_override="mer_houleuse_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
