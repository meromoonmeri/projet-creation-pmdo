"""Constructeur PMDO 0.8.12.0 — FSE1 : Faille Spatiale — Canyon Dimensionnel (réf. D46P41A / D45P42A 1×)."""
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
    build_spatial_rift_layers,
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

MAP_ID = "FSE1"
MAP_TITLE = "Faille Spatiale — Canyon Dimensionnel (Palkia)"

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent
BRUT_PATH = HERE / "bruts" / "base_faille_spatiale_entree.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE.parent / "faille_spatiale_sanctuaire_v1" / "references" / "d45p42a_deep_spatial_rift_boss_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "faille_spatiale_entree_v1"
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
    solid_mask = ~mag_mask
    # Harmonise la roche du canyon sur la palette indigo-violette profonde de la Faille Spatiale (D45P42A)
    rgb_adj = rgb.astype(np.float32)
    rgb_adj[solid_mask, 0] = np.clip(rgb_adj[solid_mask, 0] * 0.62 + 8.0, 10, 220)
    rgb_adj[solid_mask, 1] = np.clip(rgb_adj[solid_mask, 1] * 0.64 + 10.0, 12, 215)
    rgb_adj[solid_mask, 2] = np.clip(rgb_adj[solid_mask, 2] * 0.68 + 14.0, 18, 235)
    rgb = np.rint(rgb_adj).astype(np.uint8)

    yy, xx = np.mgrid[0:h, 0:w]
    portal_mask = mag_mask & (np.abs(xx - w // 2) <= int(0.18 * w)) & (yy < int(0.32 * h))
    void_mask = mag_mask & (~portal_mask)

    cosmos_24, portal_24, shock_24, shard_24 = build_spatial_rift_layers(
        h=h,
        w=w,
        void_mask=void_mask,
        portal_mask=portal_mask,
        portal_center_xy=(w * 0.50, h * 0.12),
        n_frames=N_FRAMES,
    )

    rr, gg, bb = rgb[:, :, 0].astype(np.int32), rgb[:, :, 1].astype(np.int32), rgb[:, :, 2].astype(np.int32)
    lum = 0.299 * rr + 0.587 * gg + 0.114 * bb
    is_floor = solid_mask & (np.abs(xx - w // 2) <= int(0.185 * w)) & (lum >= 88.0)
    is_boulders_dark = solid_mask & (np.abs(xx - w // 2) <= int(0.22 * w)) & (~is_floor)
    is_left_cliff = solid_mask & (~is_floor) & (~is_boulders_dark) & (xx < w // 2)
    is_right_cliff = solid_mask & (~is_floor) & (~is_boulders_dark) & (xx >= w // 2)
    covered = is_floor | is_boulders_dark | is_left_cliff | is_right_cliff
    is_floor |= solid_mask & (~covered)

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[mask, :3] = rgb[mask]
        out[mask, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    thin_dark = (ndimage.uniform_filter(lum.astype(np.float32), size=5) - lum.astype(np.float32)) >= 14.0
    floor_cracks = solid_mask & thin_dark & (np.abs(xx - w // 2) <= int(0.095 * w)) & (yy >= int(0.30 * h)) & (yy < int(0.92 * h))
    l7_cracks: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph1 = (2.0 * np.pi * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        lit = floor_cracks & (np.sin(yy / 20.0 - ph1) > 0.35)
        fr[lit] = (212, 114, 250, 255)
        l7_cracks.append(Image.fromarray(fr, mode="RGBA"))

    canyon_rim = solid_mask & (~ndimage.binary_erosion(solid_mask, iterations=2))
    l8_rim: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph3 = (2.0 * np.pi * 3.0 * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        hit = canyon_rim & (np.cos(yy / 28.0 - ph3) > 0.25)
        fr[hit, :3] = np.clip(rgb[hit].astype(np.int32) + np.array([36, 18, 52]), 0, 255).astype(np.uint8)
        fr[hit, 3] = 255
        l8_rim.append(Image.fromarray(fr, mode="RGBA"))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            sub_f = is_floor[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            sub_m = mag_mask[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            if float(sub_f.mean()) >= 0.70 and float(sub_m.mean()) == 0.0:
                walk_grid[ty, tx] = True
    cx_t = gw // 2
    portal_y_t = max(2, int(round(0.24 * gh)))
    for ty in range(portal_y_t, gh):
        walk_grid[ty, max(0, cx_t - 2):min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False

    layers = [
        LayerEntry("00_cosmos_dimensionnel_distordu", "Cosmos Dimensionnel Distordu & Étoiles", "BG", _to_imgs(cosmos_24), frame_length=5),
        LayerEntry("01_portail_spatio_rift_nord", "Portail Spatio-Rift Blanc-Perle au Nord", "BG", _to_imgs(portal_24), frame_length=5),
        LayerEntry("02_ondes_choc_spatiales_palkia", "Ondes de Choc & Éclairs Spatio-Rift", "BG", _to_imgs(shock_24), frame_length=5),
        LayerEntry("03_sol_canyon_ardoise_sud_nord", "Sol Fissuré du Canyon Sud-Nord", "BG", [mk_static(is_floor)], frame_length=5),
        LayerEntry("04_paroi_rocheuse_ouest_statique", "Paroi Rocheuse Ouest & Rocs Flottants Statiques", "BG", [mk_static(is_left_cliff)], frame_length=5),
        LayerEntry("05_paroi_rocheuse_est_statique", "Paroi Rocheuse Est & Rocs Flottants Statiques", "BG", [mk_static(is_right_cliff)], frame_length=5),
        LayerEntry("06_rochers_apesanteur_statiques", "Rochers en Apesanteur 100 % Statiques", "BG", [mk_static(is_boulders_dark)], frame_length=5),
        LayerEntry("07_veines_energie_fractures_sol", "Veines Magenta dans les Fractures du Sol", "BG", l7_cracks, frame_length=5),
        LayerEntry("08_lueur_perle_parois_canyon", "Reflets Perle sur les Parois du Canyon", "BG", l8_rim, frame_length=5),
        LayerEntry("09_eclats_perle_apesanteur_top", "Éclats Perle en Lévitation Top", "Top", _to_imgs(shard_24), frame_length=5),
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
        max_fidelity_distance=34.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="faille_spatiale_fse1",
        asset_name_override="faille_spatiale_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
