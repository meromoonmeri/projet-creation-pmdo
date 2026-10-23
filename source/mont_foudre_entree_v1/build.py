"""Constructeur PMDO 0.8.12.0 — MFE1 : Tiny Meadow — Entrée de la Montagne & Grotte de Zekrom.

Architecture multicalque 10 calques (768×576, 96×72 tuiles, boucle maîtresse 120 ticks) :
  - Partie basse/médiane : Tiny Meadow / Plaine Tonnerre verdoyante (herbe PMD, fleurs, arbres,
    pont de pierre, ruisseaux cristallins peints en #FF00FF -> eau canonique GBA H10P02.bpl 1×).
  - Partie haute : Montagne sombre abrupte avec grande grotte sculptée au bout du chemin Sud -> Nord,
    surmontée d'un ciel #FF00FF où s'amoncelle la tornade de nuages noirs électriques de Zekrom.
"""
from __future__ import annotations

import json
from pathlib import Path
import sys
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

SOURCE_DIR = Path(__file__).resolve().parent.parent
if str(SOURCE_DIR) not in sys.path:
    sys.path.insert(0, str(SOURCE_DIR))

from moteur_eau_et_glace_canonique_pmd import build_canonical_pmd_water_frames
from moteur_legendaires_zekrom_dialga_palkia import (
    build_zekrom_black_tornado_layers,
    clean_brut_magenta_fringe,
)
from tour_celeste_moteur_nuages import (
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "MFE1"
MAP_TITLE = "Tiny Meadow — Entrée Montagne & Grotte (Zekrom)"

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent
BRUT_PATH = HERE / "bruts" / "base_mont_foudre_entree.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "p14p01a_luminous_meadow_spring_native.png"
ROM_DIR = HERE / "references" / "native_rom"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_foudre_entree_v1"
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

    yy, xx = np.mgrid[0:h, 0:w]
    sky_mask = mag_mask & (yy < int(0.42 * h))
    water_mask = mag_mask & (~sky_mask)
    solid_mask = ~mag_mask

    # 1. Ciel d'orage noir en entonnoir + éclairs bleus Zekrom derrière la montagne (24 poses @ 5 ticks)
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

    # 2. Ruisseaux cristallins de Tiny Meadow en eau canonique GBA H10P02.bpl 1× (12 poses @ 10 ticks)
    water_raw_imgs = build_canonical_pmd_water_frames(w=w, h=h, water_mask=water_mask, n_frames=12)
    bank_rim = water_mask & (~ndimage.binary_erosion(water_mask, iterations=max(1, int(round(2 * w / 768.0)))))
    water_12: List[Image.Image] = []
    for f_i, wim in enumerate(water_raw_imgs):
        frame = np.asarray(wim, dtype=np.uint8).copy()
        shimmer = bank_rim & (((xx // 3 + yy // 3 + f_i * 2) % 7) < 2)
        frame[shimmer] = (206, 246, 255, 255)
        water_12.append(Image.fromarray(frame, mode="RGBA"))

    # 3. Partition sémantique des calques statiques (poses = 1)
    rr, gg, bb = rgb[:, :, 0].astype(np.int32), rgb[:, :, 1].astype(np.int32), rgb[:, :, 2].astype(np.int32)
    is_path_or_bridge = solid_mask & (
        ((rr >= 135) & (gg >= 115) & (bb <= 155) & (rr >= gg - 10) & (np.abs(xx - w // 2) <= int(0.16 * w)))
        | ((np.abs(xx - w // 2) <= int(0.085 * w)) & (yy >= int(0.28 * h)))
    )
    is_mountain_and_cave = solid_mask & (~is_path_or_bridge) & (
        (yy < int(0.555 * h)) & (gg <= rr + 18) & (bb >= gg - 14)
    )
    is_trees_foliage = solid_mask & (~is_path_or_bridge) & (~is_mountain_and_cave) & (
        ((xx < int(0.16 * w)) | (xx > int(0.84 * w)) | (yy < int(0.57 * h)))
        & (gg > rr + 16)
    )
    is_meadow_base = solid_mask & (~is_path_or_bridge) & (~is_mountain_and_cave) & (~is_trees_foliage)
    is_meadow_base |= solid_mask & (~(is_meadow_base | is_path_or_bridge | is_mountain_and_cave | is_trees_foliage))

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[mask, :3] = rgb[mask]
        out[mask, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    # 4. Calque L8 : Reflet d'orage bleu Zekrom strictement sur la ligne de crête touchant le ciel #FF00FF !
    mtn_crest = is_mountain_and_cave & ndimage.binary_dilation(sky_mask, iterations=2)
    l8_glow: List[Image.Image] = []
    for f in range(N_FRAMES):
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        if f % 8 in (0, 1, 2):
            fr[mtn_crest, :3] = np.clip(rgb[mtn_crest].astype(np.int32) + np.array([34, 82, 148]), 0, 255).astype(np.uint8)
            fr[mtn_crest, 3] = 255
        l8_glow.append(Image.fromarray(fr, mode="RGBA"))

    # 5. Calque L9 Top : Lucioles dorées sur Tiny Meadow + étincelles électriques bleues Zekrom en altitude
    rng = np.random.default_rng(64401)
    fireflies = [(float(rng.uniform(40, max(42, w - 40))), float(rng.uniform(int(0.56 * h), max(int(0.58 * h), h - 18))), int(rng.choice([1, 3]))) for _ in range(38)]
    sparks = [(float(rng.uniform(30, max(32, w - 30))), float(rng.uniform(8, max(10, int(0.28 * h)))), int(rng.choice([1, 3]))) for _ in range(44)]
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

    # Grille de collision Sud -> Nord continue (depuis y=h-1 sur le sentier, pont, escaliers jusqu'à la grotte !)
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            sub_p = is_path_or_bridge[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            sub_m = is_meadow_base[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            sub_w = mag_mask[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            if (float(sub_p.mean()) >= 0.45 or float(sub_m.mean()) >= 0.72) and float(sub_w.mean()) == 0.0:
                walk_grid[ty, tx] = True
    cx_t = gw // 2
    cave_top_t = max(2, int(round(0.29 * gh)))
    for ty in range(cave_top_t, gh):
        walk_grid[ty, max(0, cx_t - 2):min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_abysse_orage_montagne_zekrom", "Abysse d'Orage Noir au-dessus de la Montagne", "BG", _to_imgs(abyss_24), frame_length=5),
        LayerEntry("01_tornade_nuages_noirs_lointaine", "Vortex de Nuages Noirs de Zekrom en Formation", "BG", _to_imgs(cloud_24), frame_length=5),
        LayerEntry("02_eclairs_bleus_zekrom_h17p01w", "Éclairs Bleus Zekrom & Sprites GBA H17P01W1.bpa 1×", "BG", _to_imgs(bolt_24), frame_length=5),
        LayerEntry("03_ruisseaux_tiny_meadow_h10p02", "Ruisseaux Cristallins GBA H10P02.bpl 1×", "BG", water_12, frame_length=10),
        LayerEntry("04_prairie_fleurie_tiny_meadow", "Prairie Verdoyante Tiny Meadow", "BG", [mk_static(is_meadow_base)], frame_length=5),
        LayerEntry("05_sentier_pont_et_marches_grotte", "Sentier Sud-Nord, Pont de Pierre & Escaliers", "BG", [mk_static(is_path_or_bridge)], frame_length=5),
        LayerEntry("06_montagne_sombre_et_grotte_nord", "Montagne Rocheuse & Embouchure de la Grotte", "BG", [mk_static(is_mountain_and_cave)], frame_length=5),
        LayerEntry("07_arbres_et_bosquets_statiques", "Arbres & Bosquets Statiques", "BG", [mk_static(is_trees_foliage)], frame_length=5),
        LayerEntry("08_lueur_grotte_et_cretes_orage", "Lueur de la Grotte & Reflets Bleus sur les Crêtes", "BG", l8_glow, frame_length=5),
        LayerEntry("09_lucioles_et_etincelles_zekrom_top", "Lucioles de Prairie & Étincelles Bleues Top", "Top", l9_top, frame_length=5),
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
        namespace_override="mont_foudre_mfe1",
        asset_name_override="mont_foudre_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
