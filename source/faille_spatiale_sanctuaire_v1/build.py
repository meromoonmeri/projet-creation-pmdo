"""Constructeur PMDO 0.8.12.0 — FSA1 : Faille Spatiale — Cœur Dimensionnel de Palkia (réf. D45P42A 1×)."""
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

MAP_ID = "FSA1"
MAP_TITLE = "Faille Spatiale — Cœur Dimensionnel de Palkia"

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent
BRUT_PATH = HERE / "bruts" / "base_faille_spatiale_sanctuaire.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "d45p42a_deep_spatial_rift_boss_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "faille_spatiale_sanctuaire_v1"
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

    yy, xx = np.mgrid[0:h, 0:w]
    labels, n_comp = ndimage.label(mag_mask)
    portal_mask = np.zeros_like(mag_mask)
    for lab in range(1, n_comp + 1):
        comp = labels == lab
        touches_side = bool(comp[:, 0].any() or comp[:, -1].any() or comp[-1, :].any())
        if not touches_side:
            portal_mask |= comp
    if not np.any(portal_mask):
        portal_mask = mag_mask & (np.abs(xx - w // 2) <= int(0.145 * w)) & (yy >= int(0.06 * h)) & (yy <= int(0.34 * h))
    void_mask = mag_mask & (~portal_mask)

    cosmos_24, portal_24, shock_24, shard_24 = build_spatial_rift_layers(
        h=h,
        w=w,
        void_mask=void_mask,
        portal_mask=portal_mask,
        portal_center_xy=(w * 0.50, h * 0.19),
        n_frames=N_FRAMES,
    )

    ell_arena = np.hypot((xx - w * 0.50) / max(1.0, 0.255 * w), (yy - h * 0.545) / max(1.0, 0.265 * h))
    is_south_stairs = solid_mask & (yy >= int(0.78 * h)) & (np.abs(xx - w // 2) <= int(0.145 * w))
    is_arena_floor = solid_mask & (ell_arena <= 0.92) & (~is_south_stairs)
    is_north_jaws = solid_mask & (~is_arena_floor) & (yy < int(0.40 * h))
    is_crater_walls = solid_mask & (~is_arena_floor) & (~is_south_stairs) & (~is_north_jaws)
    covered = is_south_stairs | is_arena_floor | is_north_jaws | is_crater_walls
    is_crater_walls |= solid_mask & (~covered)

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[mask, :3] = rgb[mask]
        out[mask, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    lum_f = (0.299 * rgb[:, :, 0] + 0.587 * rgb[:, :, 1] + 0.114 * rgb[:, :, 2]).astype(np.float32)
    thin_dark = (ndimage.uniform_filter(lum_f, size=5) - lum_f) >= 14.0
    arena_seams = is_arena_floor & thin_dark & (ell_arena <= 0.72)
    theta_a = np.arctan2(yy - h * 0.545, xx - w * 0.50)
    l7_seams: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph1 = (2.0 * np.pi * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        lit = arena_seams & (np.sin(4.0 * theta_a - ph1) > 0.30)
        fr[lit] = (218, 128, 252, 255)
        l7_seams.append(Image.fromarray(fr, mode="RGBA"))

    portal_rim_rock = ndimage.binary_dilation(portal_mask, iterations=4) & solid_mask
    outer_rim_rock = solid_mask & (~ndimage.binary_erosion(solid_mask, iterations=1))
    l8_glow: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph1 = (2.0 * np.pi * f) / N_FRAMES
        ph3 = (2.0 * np.pi * 3.0 * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        p_amp = int(round(36 + 26 * np.sin(ph1) + 12 * np.cos(ph3)))
        fr[portal_rim_rock, :3] = np.clip(
            rgb[portal_rim_rock].astype(np.int32) + np.array([p_amp, p_amp // 2, p_amp + 18]), 0, 255
        ).astype(np.uint8)
        fr[portal_rim_rock, 3] = 255
        hit = outer_rim_rock & (np.sin(3.0 * theta_a + ph3) > 0.4)
        fr[hit, :3] = np.clip(rgb[hit].astype(np.int32) + np.array([34, 16, 52]), 0, 255).astype(np.uint8)
        fr[hit, 3] = 255
        l8_glow.append(Image.fromarray(fr, mode="RGBA"))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            sub_a = is_arena_floor[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            sub_s = is_south_stairs[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            sub_m = mag_mask[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            if (float(sub_a.mean()) >= 0.65 or float(sub_s.mean()) >= 0.55) and float(sub_m.mean()) == 0.0:
                walk_grid[ty, tx] = True
    cx_t = gw // 2
    for ty in range(max(4, int(round(0.36 * gh))), gh):
        walk_grid[ty, max(0, cx_t - 2):min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False

    layers = [
        LayerEntry("00_cosmos_indigo_distordu_d45p42a", "Cosmos Indigo-Violet Distordu D45P42A", "BG", _to_imgs(cosmos_24), frame_length=5),
        LayerEntry("01_dechirure_blanche_spatio_rift_nord", "Déchirure Aveuglante Spatio-Rift au Nord", "BG", _to_imgs(portal_24), frame_length=5),
        LayerEntry("02_anneaux_choc_dimensionnels", "Anneaux de Choc Dimensionnels de Palkia", "BG", _to_imgs(shock_24), frame_length=5),
        LayerEntry("03_dalles_antiques_arene_palkia", "Dalles Antiques & Cercle Central de Palkia", "BG", [mk_static(is_arena_floor)], frame_length=5),
        LayerEntry("04_escalier_acces_sud_cratere", "Chaussée Sud-Nord d'Accès au Sanctuaire", "BG", [mk_static(is_south_stairs)], frame_length=5),
        LayerEntry("05_remparts_cratere_violets_statiques", "Remparts Rocheux Violets 100 % Statiques", "BG", [mk_static(is_crater_walls)], frame_length=5),
        LayerEntry("06_crocs_rocheux_faille_nord", "Crocs Rocheux de la Déchirure Nord Statiques", "BG", [mk_static(is_north_jaws)], frame_length=5),
        LayerEntry("07_pulsation_joints_runiques_palkia", "Pulsation Perle-Magenta des Joints Runiques", "BG", l7_seams, frame_length=5),
        LayerEntry("08_halo_perle_breche_dimensionnelle", "Halo Blanc-Perle de la Brèche Dimensionnelle", "BG", l8_glow, frame_length=5),
        LayerEntry("09_perles_spatiales_apesanteur_top", "Perles Spatiales en Apesanteur Top", "Top", _to_imgs(shard_24), frame_length=5),
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
        namespace_override="faille_spatiale_fsa1",
        asset_name_override="faille_spatiale_sanctuaire",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
