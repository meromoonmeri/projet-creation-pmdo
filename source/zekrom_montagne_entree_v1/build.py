#!/usr/bin/env python3
"""Constructeur PMDO 0.8.12.0 — ZKE1 : Plaine & Montagne d'Orage — Entrée de la Grotte de Zekrom.

Architecture multicalque 10 calques (`768 × 576`, `96 × 72` tuiles, boucle maîtresse `120` ticks) :
  - Partie Sud/médiane : Prairie forestière `1×` Chunsoft (`P14P01A` *Luminous Spring / Tiny Meadow*),
    sentier sablonneux `D06P01` `1×`, pont de pierre & rivière cristalline peinte en `#FF00FF` animée
    par l'eau matérielle canonique GBA `H10P02.bpl` `1×` (`12` poses @ `10` ticks).
  - Partie Nord : Montagne de basalte noir sculptée percée d'une grande grotte obscure au bout des marches,
    surmontée d'un ciel `#FF00FF` où gronde déjà le vortex de nuages noirs & éclairs bleus `Charge Foudre`
    + sprites matériels GBA `H17P01W1.bpa` `1×` de Zekrom (`24` poses @ `5` ticks).
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
if str(SOURCE_DIR) not in sys.path:
    sys.path.insert(0, str(SOURCE_DIR))

from moteur_eau_et_glace_canonique_pmd import build_canonical_pmd_water_frames  # type: ignore
from moteur_legendaires_zekrom_dialga_palkia import (  # type: ignore
    build_zekrom_black_tornado_layers,
    clean_brut_magenta_fringe,
)
from tour_celeste_moteur_nuages import (  # type: ignore
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "ZKE1"
MAP_TITLE = "Montagne d'Orage Noir — Entrée & Grotte de Zekrom"

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent
BRUT_PATH = HERE / "bruts" / "base_zekrom_montagne_entree.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_canon_zekrom_p14p01a_v38p07a.png"
ROM_DIR = SOURCE_DIR / "assets_gba_pmd_red"
RENDERS_DIR = REPO_ROOT / "renders" / "zekrom_montagne_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _to_imgs(arrs: List[np.ndarray]) -> List[Image.Image]:
    return [Image.fromarray(a, mode="RGBA") for a in arrs]


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    im_raw = Image.open(BRUT_PATH).convert("RGB")
    if im_raw.size != (w, h):
        im_raw = im_raw.resize((w, h), Image.Resampling.NEAREST)
    rgb_raw = np.asarray(im_raw, dtype=np.uint8).copy()

    r = rgb_raw[:, :, 0].astype(np.int32)
    g = rgb_raw[:, :, 1].astype(np.int32)
    b = rgb_raw[:, :, 2].astype(np.int32)
    mag_mask = (r >= 215) & (g <= 50) & (b >= 215)
    rgb = clean_brut_magenta_fringe(rgb_raw, mag_mask)
    # Purge tout résidu violacé sombre dans les 2 bouches souterraines de la rivière
    purple_tunnel = (~mag_mask) & ((rgb[:, :, 0].astype(np.int32) - rgb[:, :, 1].astype(np.int32)) >= 28) & (
        (rgb[:, :, 2].astype(np.int32) - rgb[:, :, 1].astype(np.int32)) >= 28
    )
    rgb[purple_tunnel] = (14, 22, 44)

    yy, xx = np.mgrid[0:h, 0:w]
    sky_mask = mag_mask & (yy < int(0.42 * h))
    water_mask = mag_mask & (~sky_mask)
    solid_mask = ~mag_mask

    # 1. Ciel d'orage noir en entonnoir + éclairs bleus Charge Foudre Zekrom derrière la montagne (`24f @ 5t`)
    abyss_24, cloud_24, bolt_24, _ = build_zekrom_black_tornado_layers(
        h=h,
        w=w,
        vortex_mask=sky_mask,
        rom_dir=ROM_DIR,
        center_xy=(w * 0.50, h * 0.25),
        rx_scale=0.82 * (768.0 / w),
        ry_scale=1.65 * (576.0 / h),
        n_frames=N_FRAMES,
    )

    # 2. Rivière cristalline en eau matérielle GBA `H10P02.bpl` `1×` (`12f @ 10t`) + reflets de berge
    water_raw_imgs = build_canonical_pmd_water_frames(w=w, h=h, water_mask=water_mask, n_frames=12)
    bank_rim = water_mask & (~ndimage.binary_erosion(water_mask, iterations=max(1, int(round(2 * w / 768.0)))))
    water_12: List[Image.Image] = []
    for f_i, wim in enumerate(water_raw_imgs):
        frame = np.asarray(wim, dtype=np.uint8).copy()
        shimmer = bank_rim & (((xx // 3 + yy // 3 + f_i * 2) % 7) < 2)
        frame[shimmer] = (206, 246, 255, 255)
        water_12.append(Image.fromarray(frame, mode="RGBA"))

    # 3. Partition sémantique des 4 calques statiques (`poses = 1`, `1×` fidélité stricte)
    rr, gg, bb = rgb[:, :, 0].astype(np.int32), rgb[:, :, 1].astype(np.int32), rgb[:, :, 2].astype(np.int32)
    is_path_or_bridge = solid_mask & (
        ((rr >= 115) & (gg >= 100) & (rr >= gg - 12) & (np.abs(xx - w // 2) <= int(0.10 * w)) & (yy >= int(0.54 * h)))
        | ((np.abs(xx - w // 2) <= int(0.085 * w)) & (yy >= int(0.28 * h)) & (yy < int(0.58 * h)))
    )
    is_trees_foliage = solid_mask & (~is_path_or_bridge) & (
        ((xx < int(0.32 * w)) | (xx > int(0.68 * w)))
        & (yy >= int(0.44 * h))
        & ((gg > rr + 24) & ((bb >= 68) | (gg < 108)))
    )
    is_mountain_and_cave = solid_mask & (~is_path_or_bridge) & (~is_trees_foliage) & (
        (yy < int(0.585 * h)) & ((gg - bb) < 26)
    )
    is_meadow_base = solid_mask & (~is_path_or_bridge) & (~is_mountain_and_cave) & (~is_trees_foliage)
    is_meadow_base |= solid_mask & (~(is_meadow_base | is_path_or_bridge | is_mountain_and_cave | is_trees_foliage))

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[mask, :3] = rgb[mask]
        out[mask, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    # 4. Calque 08 : Reflets électriques bleus Charge Foudre sur la crête de la montagne lors des éclairs
    mtn_crest = is_mountain_and_cave & ndimage.binary_dilation(sky_mask, iterations=max(1, int(round(2 * w / 768.0))))
    l8_glow: List[Image.Image] = []
    for f in range(N_FRAMES):
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        if f % 8 in (0, 1, 2):
            amp = 1.0 if (f % 8 == 1) else 0.55
            delta = np.rint(np.array([34.0, 86.0, 156.0]) * amp).astype(np.int32)
            fr[mtn_crest, :3] = np.clip(rgb[mtn_crest].astype(np.int32) + delta, 0, 255).astype(np.uint8)
            fr[mtn_crest, 3] = 255
        l8_glow.append(Image.fromarray(fr, mode="RGBA"))

    # 5. Calque 09 `Top` : Lucioles dorées dans la clairière `P14P01A` + étincelles bleues Zekrom dans l'orage
    rng = np.random.default_rng(64401)
    fireflies = [
        (
            float(rng.uniform(44, max(46, w - 44))),
            float(rng.uniform(int(0.56 * h), max(int(0.58 * h), h - 18))),
            int(rng.choice([1, 3])),
        )
        for _ in range(36)
    ]
    sparks = [
        (
            float(rng.uniform(30, max(32, w - 30))),
            float(rng.uniform(8, max(10, int(0.28 * h)))),
            int(rng.choice([1, 3])),
        )
        for _ in range(48)
    ]
    l9_top: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph1 = (2.0 * np.pi * f) / N_FRAMES
        ph3 = (2.0 * np.pi * 3.0 * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        for fx0, fy0, hm in fireflies:
            ang = ph1 if hm == 1 else ph3
            px = int(round(fx0 + 7.0 * np.sin(ang + fy0 * 0.05)))
            py = int(round(fy0 + 4.0 * np.cos(ang + fx0 * 0.04)))
            if 1 <= px < w - 1 and 1 <= py < h - 1 and ((f + int(fx0)) % 6 < 4):
                fr[py, px] = (248, 252, 168, 255)
        for sx0, sy0, hm in sparks:
            ang = ph1 if hm == 1 else ph3
            px = int(round(sx0 + 14.0 * np.cos(ang + sy0 * 0.03))) % w
            py = int(round(sy0 + 5.0 * np.sin(ang + sx0 * 0.03)))
            if 0 <= py < h and sky_mask[py, px]:
                fr[py, px] = (126, 214, 255, 255)
        l9_top.append(Image.fromarray(fr, mode="RGBA"))

    # Grille de collision continue du Sud (`y = gh - 1`) jusqu'à l'embouchure de la grotte au Nord
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            sub_p = is_path_or_bridge[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            sub_m = is_meadow_base[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            sub_w = mag_mask[ty * TILE_SIZE : (ty + 1) * TILE_SIZE, tx * TILE_SIZE : (tx + 1) * TILE_SIZE]
            if (float(sub_p.mean()) >= 0.45 or float(sub_m.mean()) >= 0.72) and float(sub_w.mean()) == 0.0:
                walk_grid[ty, tx] = True
    cx_t = gw // 2
    cave_top_t = max(2, int(round(0.29 * gh)))
    for ty in range(cave_top_t, gh):
        walk_grid[ty, max(0, cx_t - 2) : min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_abysse_orage_montagne_zekrom", "Abysse d'Orage Noir au-dessus de la Montagne", "BG", _to_imgs(abyss_24), frame_length=5),
        LayerEntry("01_vortex_nuages_noirs_zekrom", "Vortex de Nuages Noirs Électriques en Formation", "BG", _to_imgs(cloud_24), frame_length=5),
        LayerEntry("02_eclairs_bleus_charge_foudre_h17p01w", "Éclairs Bleus Charge Foudre & GBA H17P01W1.bpa 1×", "BG", _to_imgs(bolt_24), frame_length=5),
        LayerEntry("03_riviere_cristalline_h10p02", "Rivière Cristalline GBA H10P02.bpl 1×", "BG", water_12, frame_length=10),
        LayerEntry("04_prairie_clairiere_p14p01a_1x", "Clairière Verdoyante P14P01A 1×", "BG", [mk_static(is_meadow_base)], frame_length=5),
        LayerEntry("05_sentier_pont_pierre_et_marches", "Sentier Sablonneux D06P01 1×, Pont & Marches", "BG", [mk_static(is_path_or_bridge)], frame_length=5),
        LayerEntry("06_montagne_basalte_et_grotte_nord", "Montagne Basaltique & Grotte Noire de Zekrom", "BG", [mk_static(is_mountain_and_cave)], frame_length=5),
        LayerEntry("07_foret_pins_p14p01a_1x_statique", "Forêt de Pins PMD Sky P14P01A 1× Statique", "BG", [mk_static(is_trees_foliage)], frame_length=5),
        LayerEntry("08_reflets_charge_foudre_cretes", "Reflets Bleus Charge Foudre sur les Crêtes", "BG", l8_glow, frame_length=5),
        LayerEntry("09_lucioles_et_etincelles_zekrom_top", "Lucioles de Clairière & Étincelles Bleues Top", "Top", l9_top, frame_length=5),
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
        namespace_override="zekrom_montagne_zke1",
        asset_name_override="zekrom_montagne_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
