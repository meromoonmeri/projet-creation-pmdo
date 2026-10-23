#!/usr/bin/env python3
"""Constructeur multicalque 10 couches (PMDO 0.8.12.0, `768 × 576`, `96 × 72` tuiles) :
MHA1 — Mer Houleuse — Sanctuaire Abyssal de Kyogre (`POV PMD`, réf. `h02p03_seafloor_cave_native.png`).

Fidélité maximale à `H02P03` (*Seafloor Cave — Kyogre Sanctuary — PMD Red*) + découpe 100 % `#FF00FF` :
- Tout le lagon abyssal entourant le Médaillon Circulaire de Kyogre et les chenaux latéraux sont peints en
  `#FF00FF` pur sur `bruts/base_mer_houleuse_sanctuaire.png` (zéro eau statique cuite sur le brut) ;
- **TOUS les cristaux cyan/aigue-marine/améthyste et parois rocheuses sont `100 %` STATIQUES (`poses = 1`)** ;
- Zéro cercle noir parasite ;
- `MHA1_00` (`BG`, `12` poses @ `10` ticks = `120` ticks) : Lagon abyssal `H10P02.bpl` `1×` saphir-outremer ;
- `MHA1_01` (`BG`, `15` poses @ `8` ticks = `120` ticks) : Courants marins matériels GBA `H02P02W.bpl` `1×` ;
- `MHA1_02` (`BG`, `1` pose) : Socle englouti du sanctuaire de Kyogre ;
- `MHA1_03` (`BG`, `1` pose) : Chaussée runique Sud-Nord & Autel-Médaillon circulaire de Kyogre ;
- `MHA1_04` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Pulsation ancestrale des runes de Primo-Kyogre ;
- `MHA1_05` (`BG`, `1` pose) : Couronne de cristaux abyssaux cyan & roches pourpres (`100 %` STATIQUES !) ;
- `MHA1_06` (`BG`, `1` pose) : Remparts rocheux d'avant-plan Sud-Ouest / Sud-Est (`100 %` statiques) ;
- `MHA1_07` (`BG`, `24` poses @ `5` ticks = `120` ticks) : Caustiques océaniques sur l'allée centrale ;
- `MHA1_08` (`BG`, `15` poses @ `8` ticks = `120` ticks) : Colonnes de bulles matérielles GBA `H02P03W1.bpa` `1×` ;
- `MHA1_09` (`Top`, `24` poses @ `5` ticks = `120` ticks) : Particules bioluminescentes abyssales en couche `Top`.
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

MAP_ID = "MHA1"
MAP_TITLE = "Mer Houleuse — Sanctuaire Abyssal de Kyogre"
RAW_DIR = HERE / "bruts"
DECOR_MAGENTA_RAW = RAW_DIR / "base_mer_houleuse_sanctuaire.png"
REF_DIR = HERE / "references"
H02P03_REF = REF_DIR / "h02p03_seafloor_cave_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "mer_houleuse_sanctuaire_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def build_kyogre_rune_pulse_and_top_layers(
    w: int,
    h: int,
    q_rgb: np.ndarray,
    rune_mask: np.ndarray,
    wet_rim_mask: np.ndarray,
    n_frames: int = 24,
) -> Tuple[List[Image.Image], List[Image.Image], List[Image.Image]]:
    """Construit :
    - `rune_frames` (`24 × 5 = 120` ticks) : onde lumineuse carmin-or parcourant les runes de Primo-Kyogre
      du Sud vers le Médaillon Nord,
    - `caustic_frames` (`24 × 5 = 120` ticks) : reflets d'eau subtils sur la bordure humide de l'autel (`q_rgb + [10,20,30]`),
    - `top_spores` (`Top`, `24 × 5 = 120` ticks) : fines particules bioluminescentes remontant au-dessus du lagon."""
    yy, xx = np.mgrid[:h, :w].astype(np.float32)
    rune_pal = np.array(
        [
            [188, 34, 52],
            [222, 56, 68],
            [248, 96, 78],
            [255, 158, 96],
        ],
        dtype=np.uint8,
    )
    wet_lit = np.clip(q_rgb.astype(np.int16) + np.array([10, 20, 32], dtype=np.int16), 0, 255).astype(np.uint8)

    rune_frames: List[Image.Image] = []
    caustic_frames: List[Image.Image] = []
    for t in range(n_frames):
        ph = 2.0 * np.pi * float(t) / float(n_frames)
        wave = 0.5 + 0.5 * np.sin(2.0 * np.pi * (yy / float(h)) + ph)
        tier = np.clip((wave * 3.99).astype(np.int32), 0, 3)
        arr_r = np.zeros((h, w, 4), dtype=np.uint8)
        arr_r[rune_mask, :3] = rune_pal[tier[rune_mask]]
        arr_r[rune_mask, 3] = 255
        rune_frames.append(Image.fromarray(arr_r, mode="RGBA"))

        shimmer = np.sin(2.0 * np.pi * (yy / max(24.0, h * 0.12)) + ph)
        cm = wet_rim_mask & (~rune_mask) & (shimmer >= 0.35)
        arr_c = np.zeros((h, w, 4), dtype=np.uint8)
        arr_c[cm, :3] = wet_lit[cm]
        arr_c[cm, 3] = 255
        caustic_frames.append(Image.fromarray(arr_c, mode="RGBA"))

    # Particules bioluminescentes confinées aux couloirs latéraux d'eau (`x < 0.36w` ou `x > 0.64w`, hors cristaux fixes)
    rng = np.random.default_rng(20261104)
    n_p = 36
    px0 = rng.integers(int(0.30 * w), int(0.70 * w), size=n_p)
    py0 = rng.integers(0, h, size=n_p)
    col_hi = np.array([156, 242, 255], dtype=np.uint8)
    top_spores: List[Image.Image] = []
    for t in range(n_frames):
        frac = float(t) / float(n_frames)
        dy = int(round(frac * h))
        arr = np.zeros((h, w, 4), dtype=np.uint8)
        for i in range(n_p):
            cx = (int(px0[i]) + int(round(2.0 * np.sin(2.0 * np.pi * frac + i)))) % w
            cy = (int(py0[i]) - dy) % h
            arr[cy, cx, :3] = col_hi
            arr[cy, cx, 3] = 255
        top_spores.append(Image.fromarray(arr, mode="RGBA"))

    return rune_frames, caustic_frames, top_spores


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray, np.ndarray]:
    raw_im = Image.open(DECOR_MAGENTA_RAW).convert("RGB")
    raw_rgb = np.asarray(raw_im.resize((w, h), Image.Resampling.NEAREST), dtype=np.uint8).copy()

    yy, xx = np.mgrid[:h, :w]
    r = raw_rgb[:, :, 0].astype(np.int16)
    g = raw_rgb[:, :, 1].astype(np.int16)
    b = raw_rgb[:, :, 2].astype(np.int16)

    # 1. Découpe stricte des bassins d'eau `#FF00FF` autour du Médaillon de Kyogre & dans les chenaux latéraux
    water_mask = (r >= 220) & (g <= 35) & (b >= 220)
    terrain_mask = ~water_mask

    # 2. Restituer la teinte améthyste/bordeaux authentique de `H02P03` sur la roche & le dallage
    #    (hors cristaux cyan `g >= 120` et hors eau `#FF00FF`), tout en garantissant 0 pixel `#FF00FF` !
    warm_rgb = raw_rgb.astype(np.int16).copy()
    amethyst_stone = terrain_mask & (g <= 110)
    warm_rgb[amethyst_stone, 0] = np.clip(warm_rgb[amethyst_stone, 0] + 36, 0, 224)
    warm_rgb[amethyst_stone, 1] = np.clip(warm_rgb[amethyst_stone, 1] - 6, 0, 255)
    warm_rgb[amethyst_stone, 2] = np.clip(warm_rgb[amethyst_stone, 2] + 6, 0, 242)
    warm_u8 = warm_rgb.clip(0, 255).astype(np.uint8)

    ref_pal = extract_canonical_palette([H02P03_REF], max_colors=64, min_pixels=8)
    terr_px = warm_u8[terrain_mask]
    uniq, cnt = np.unique(terr_px, axis=0, return_counts=True)
    top_terr = uniq[np.argsort(-cnt)[:64]]
    pal = sanitize_palette_no_magenta(np.vstack([ref_pal, top_terr]), max_gap=96)
    q_rgb = quantize_rgb_to_palette(warm_u8, pal)

    # 3. Partition sémantique stricte :
    #    - `causeway_and_medallion` : allée centrale Sud-Nord + autel circulaire bleu-roi de Kyogre
    #    - `crystals_arch_static` : TOUS les cristaux cyan/aigue-marine/améthyste & parois Nord/Est/Ouest (`poses = 1` !)
    #    - `fg_boulders_static` : rochers sombres d'avant-plan Sud-Ouest / Sud-Est (`poses = 1`)
    in_center_wedge = (
        terrain_mask
        & (yy >= int(0.22 * h))
        & (np.abs(xx - 0.50 * w) <= (0.095 + 0.155 * (yy.astype(np.float32) / float(h))) * w)
    )
    lbl_c, _ = ndimage.label(in_center_wedge)
    south_ids = set(lbl_c[h - 6 :, int(0.40 * w) : int(0.60 * w)].ravel().tolist()) - {0}
    causeway_and_medallion = np.isin(lbl_c, list(south_ids)) & terrain_mask

    fg_boulders_static = (
        terrain_mask
        & (~causeway_and_medallion)
        & (yy >= int(0.72 * h))
        & ((xx <= int(0.34 * w)) | (xx >= int(0.66 * w)))
    )
    crystals_arch_static = terrain_mask & (~causeway_and_medallion) & (~fg_boulders_static)

    # Runes gravées de Primo-Kyogre sur la chaussée & les rayons du Médaillon (`R - B >= 50` et `R >= 145`)
    rune_mask = causeway_and_medallion & ((r - b) >= 50) & (r >= 145)

    # Zone marchable continue du bas-centre (`y = h - 1`) jusqu'au centre du Médaillon de Kyogre (`y = 0.30h`)
    water_guard = ndimage.binary_dilation(water_mask, iterations=max(1, int(round(2 * w / 768.0))))
    walkable_sanctuary = causeway_and_medallion & (~water_guard)

    # 4. Couches matérielles GBA `H10P02.bpl` + `H02P02W.bpl` + `H02P03W1.bpa` (bulles strictement sur `water_mask` !)
    frames_00_water, frames_01_currents, raw_bubbles = build_abyssal_water_and_current_layers(
        w=w,
        h=h,
        water_mask=water_mask,
        mode="kyogre",
    )
    # Confiner les colonnes de bulles GBA strictement hors des cristaux statiques (`water_mask | causeway`)
    no_crystal_mask = water_mask | causeway_and_medallion
    frames_08_bubbles: List[Image.Image] = []
    for bf in raw_bubbles:
        ba = np.asarray(bf, dtype=np.uint8).copy()
        ba[~no_crystal_mask] = 0
        frames_08_bubbles.append(Image.fromarray(ba, mode="RGBA"))

    wet_rim = causeway_and_medallion & ndimage.binary_dilation(water_mask, iterations=max(2, int(round(5 * w / 768.0))))
    frames_04_runes, frames_07_caustics, frames_09_top = build_kyogre_rune_pulse_and_top_layers(
        w=w,
        h=h,
        q_rgb=q_rgb,
        rune_mask=rune_mask,
        wet_rim_mask=wet_rim,
        n_frames=N_FRAMES,
    )

    base_arr = np.zeros((h, w, 4), dtype=np.uint8)
    base_arr[terrain_mask, :3] = np.array([28, 22, 68], dtype=np.uint8)
    base_arr[terrain_mask, 3] = 255
    im_02_base = Image.fromarray(base_arr, mode="RGBA")

    def _mk_layer(m: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[m, :3] = q_rgb[m]
        out[m, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    im_03_causeway = _mk_layer(causeway_and_medallion)
    im_05_crystals_static = _mk_layer(crystals_arch_static)
    im_06_fg_rocks = _mk_layer(fg_boulders_static)

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            blk = walkable_sanctuary[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            walk_grid[ty, tx] = float(blk.mean()) >= 0.50

    lbl_wg, n_wg = ndimage.label(walk_grid)
    if n_wg >= 1:
        sizes = ndimage.sum(walk_grid, lbl_wg, range(1, n_wg + 1))
        walk_grid = lbl_wg == (int(np.argmax(sizes)) + 1)
    walk_grid[-1, :] |= walk_grid[-2, :]

    layers = [
        LayerEntry("00_lagon_abyssal_h10p02", "Lagon Abyssal GBA H10P02.bpl 1×", "BG", frames_00_water, frame_length=10),
        LayerEntry("01_courants_marins_gba_h02p02w", "Courants Marins GBA H02P02W.bpl 1×", "BG", frames_01_currents, frame_length=8),
        LayerEntry("02_socle_sanctuaire_englouti", "Socle Englouti du Sanctuaire", "BG", [im_02_base], frame_length=5),
        LayerEntry("03_chaussee_et_medaillon_kyogre", "Chaussée Runique Sud-Nord & Médaillon de Kyogre", "BG", [im_03_causeway], frame_length=5),
        LayerEntry("04_pulsation_runes_primo_kyogre", "Pulsation des Runes de Primo-Kyogre", "BG", frames_04_runes, frame_length=5),
        LayerEntry("05_couronne_cristaux_statiques", "Couronne de Cristaux Abyssaux 100 % Statiques", "BG", [im_05_crystals_static], frame_length=5),
        LayerEntry("06_remparts_rocheux_avant_plan", "Remparts Rocheux d'Avant-Plan Statiques", "BG", [im_06_fg_rocks], frame_length=5),
        LayerEntry("07_caustiques_autel_englouti", "Caustiques Océaniques sur l'Autel", "BG", frames_07_caustics, frame_length=5),
        LayerEntry("08_bulles_abyssales_gba_h02p03w", "Colonnes de Bulles GBA H02P03W1.bpa 1×", "BG", frames_08_bubbles, frame_length=8),
        LayerEntry("09_particules_abyssales_top", "Particules Bioluminescentes Top", "Top", frames_09_top, frame_length=5),
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
        canonical_ref_for_fidelity=H02P03_REF,
        max_fidelity_distance=30.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="mer_houleuse_mha1",
        asset_name_override="mer_houleuse_sanctuaire",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
