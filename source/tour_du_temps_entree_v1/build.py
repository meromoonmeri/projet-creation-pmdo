"""Constructeur PMDO 0.8.12.0 — TTE1 : Tour du Temps — Entrée & Flèche Brisée (réf. D30P32A 1×)."""
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

from moteur_legendaires_zekrom_dialga_palkia import (
    build_temporal_sky_and_rifts,
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

MAP_ID = "TTE1"
MAP_TITLE = "Tour du Temps — Entrée & Flèche Brisée"

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent
BRUT_PATH = HERE / "bruts" / "base_tour_du_temps_entree.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "d30p32a_temporal_spire_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_du_temps_entree_v1"
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
    sky_mask = (r >= 215) & (g <= 50) & (b >= 215)
    rgb = clean_brut_magenta_fringe(rgb_raw, sky_mask)
    solid_mask = ~sky_mask

    sky_24, rift_24, dust_24 = build_temporal_sky_and_rifts(
        h=h, w=w, sky_mask=sky_mask, primal_crimson=False, n_frames=N_FRAMES
    )

    yy, xx = np.mgrid[0:h, 0:w]
    rr, gg, bb = rgb[:, :, 0].astype(np.int32), rgb[:, :, 1].astype(np.int32), rgb[:, :, 2].astype(np.int32)

    is_shrine = solid_mask & (yy < int(0.31 * h)) & (np.abs(xx - w // 2) <= int(0.14 * w))
    is_colonnade_south = solid_mask & (yy >= int(0.84 * h))
    is_side_brackets = solid_mask & (~is_shrine) & (~is_colonnade_south) & (
        (xx < int(0.30 * w)) | (xx > int(0.70 * w))
    )
    is_central_walk = solid_mask & (~is_shrine) & (~is_colonnade_south) & (~is_side_brackets) & (
        np.abs(xx - w // 2) <= int(0.115 * w)
    )
    is_pillars_debris = solid_mask & (~is_shrine) & (~is_colonnade_south) & (~is_side_brackets) & (~is_central_walk)
    covered = is_colonnade_south | is_side_brackets | is_central_walk | is_pillars_debris | is_shrine
    is_central_walk |= solid_mask & (~covered)

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[mask, :3] = rgb[mask]
        out[mask, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    gear_green = is_shrine & (gg > rr + 24)
    l6_gear: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph1 = (2.0 * np.pi * f) / N_FRAMES
        ph3 = (2.0 * np.pi * 3.0 * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        boost = int(round(32 + 28 * np.sin(ph1) + 12 * np.cos(ph3)))
        fr[gear_green, 0] = np.clip(rgb[gear_green, 0].astype(np.int32) + boost // 2, 0, 255).astype(np.uint8)
        fr[gear_green, 1] = np.clip(rgb[gear_green, 1].astype(np.int32) + boost, 0, 255).astype(np.uint8)
        fr[gear_green, 2] = np.clip(rgb[gear_green, 2].astype(np.int32) + boost, 0, 255).astype(np.uint8)
        fr[gear_green, 3] = 255
        l6_gear.append(Image.fromarray(fr, mode="RGBA"))

    lum_f = (0.299 * rr + 0.587 * gg + 0.114 * bb).astype(np.float32)
    thin_dark = (ndimage.uniform_filter(lum_f, size=5) - lum_f) >= 22.0
    floor_cracks = solid_mask & thin_dark & (np.abs(xx - w // 2) <= int(0.15 * w)) & (yy >= int(0.32 * h)) & (yy < int(0.84 * h))
    l7_cracks: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph1 = (2.0 * np.pi * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        lit = floor_cracks & (np.sin(yy / 22.0 - ph1) > 0.52)
        fr[lit] = (92, 224, 186, 255)
        l7_cracks.append(Image.fromarray(fr, mode="RGBA"))

    temple_rim = solid_mask & (~ndimage.binary_erosion(solid_mask, iterations=1))
    l8_rim: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph3 = (2.0 * np.pi * 3.0 * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        active = temple_rim & (np.sin(yy / 36.0 + ph3) > 0.35)
        fr[active, :3] = np.clip(rgb[active].astype(np.int32) + np.array([28, 26, 12]), 0, 255).astype(np.uint8)
        fr[active, 3] = 255
        l8_rim.append(Image.fromarray(fr, mode="RGBA"))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            sub_s = solid_mask[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            sub_c = floor_cracks[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            if float(sub_s.mean()) >= 0.90 and float(sub_c.mean()) <= 0.35 and int(0.30 * w) <= tx * TILE_SIZE <= int(0.68 * w):
                walk_grid[ty, tx] = True
    cx_t = gw // 2
    for ty in range(max(3, int(round(0.26 * gh))), gh):
        walk_grid[ty, max(0, cx_t - 2):min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False

    layers = [
        LayerEntry("00_ciel_ocre_temps_paralyse_d30p32a", "Ciel Ocre du Temps Paralysé D30P32A", "BG", _to_imgs(sky_24), frame_length=5),
        LayerEntry("01_breches_emeraude_rouages_temps", "Brèches Émeraude des Rouages du Temps", "BG", _to_imgs(rift_24), frame_length=5),
        LayerEntry("02_colonnade_et_contreforts_temple", "Colonnade Grecque & Contreforts Statiques", "BG", [mk_static(is_colonnade_south | is_side_brackets)], frame_length=5),
        LayerEntry("03_dallage_antique_sud_nord", "Chaussée Antique Fissurée Sud-Nord", "BG", [mk_static(is_central_walk)], frame_length=5),
        LayerEntry("04_piliers_grecs_brises_statiques", "Piliers Cannelés Brisés 100 % Statiques", "BG", [mk_static(is_pillars_debris)], frame_length=5),
        LayerEntry("05_arche_ogivale_rouage_nord", "Arche Ogivale Nord du Rouage du Temps", "BG", [mk_static(is_shrine)], frame_length=5),
        LayerEntry("06_pulsation_rouage_du_temps", "Pulsation Émeraude du Rouage du Temps", "BG", l6_gear, frame_length=5),
        LayerEntry("07_lueur_failles_chronologiques", "Lueur Chronologique dans les Failles du Sol", "BG", l7_cracks, frame_length=5),
        LayerEntry("08_reflets_ambres_corniches", "Reflets Ambrés sur les Corniches du Temple", "BG", l8_rim, frame_length=5),
        LayerEntry("09_poussieres_temps_fige_top", "Poussières de Temps Figé Top", "Top", _to_imgs(dust_24), frame_length=5),
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
        namespace_override="tour_du_temps_tte1",
        asset_name_override="tour_du_temps_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
