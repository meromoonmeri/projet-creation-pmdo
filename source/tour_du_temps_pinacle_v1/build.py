"""Constructeur PMDO 0.8.12.0 — TTA1 : Tour du Temps — Pinacle de Dialga Primal (réf. D30P41A 1×)."""
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

MAP_ID = "TTA1"
MAP_TITLE = "Tour du Temps — Pinacle de Dialga Primal"

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent
BRUT_PATH = HERE / "bruts" / "base_tour_du_temps_pinacle.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "d30p41a_temporal_pinnacle_primal_native.png"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_du_temps_pinacle_v1"
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
        h=h, w=w, sky_mask=sky_mask, primal_crimson=True, n_frames=N_FRAMES
    )

    yy, xx = np.mgrid[0:h, 0:w]
    rr, gg, bb = rgb[:, :, 0].astype(np.int32), rgb[:, :, 1].astype(np.int32), rgb[:, :, 2].astype(np.int32)

    labels, n_comp = ndimage.label(solid_mask)
    if n_comp > 0:
        sizes = np.bincount(labels.ravel())
        sizes[0] = 0
        main_lab = int(np.argmax(sizes))
        is_floating_stones = solid_mask & (labels != main_lab)
        main_temple = solid_mask & (labels == main_lab)
    else:
        is_floating_stones = np.zeros_like(solid_mask)
        main_temple = solid_mask.copy()

    is_altar = main_temple & (yy < int(0.34 * h)) & (np.abs(xx - w // 2) <= int(0.145 * w))
    is_colonnade_south = main_temple & (yy >= int(0.84 * h))
    is_esplanade = main_temple & (~is_altar) & (~is_colonnade_south) & (np.abs(xx - w // 2) <= int(0.135 * w))
    is_pillars_walls = main_temple & (~is_altar) & (~is_colonnade_south) & (~is_esplanade)
    covered = is_floating_stones | is_colonnade_south | is_esplanade | is_pillars_walls | is_altar
    is_esplanade |= solid_mask & (~covered)

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[mask, :3] = rgb[mask]
        out[mask, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    altar_red = is_altar & (rr > gg + 45)
    altar_blue = is_altar & (bb > rr + 18)
    l6_gears: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph1 = (2.0 * np.pi * f) / N_FRAMES
        ph3 = (2.0 * np.pi * 3.0 * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        p_red = int(round(36 + 34 * np.sin(ph1)))
        fr[altar_red, 0] = np.clip(rgb[altar_red, 0].astype(np.int32) + p_red, 0, 255).astype(np.uint8)
        fr[altar_red, 1] = np.clip(rgb[altar_red, 1].astype(np.int32) + p_red // 3, 0, 255).astype(np.uint8)
        fr[altar_red, 2] = np.clip(rgb[altar_red, 2].astype(np.int32) + p_red // 2, 0, 255).astype(np.uint8)
        fr[altar_red, 3] = 255
        p_bl = int(round(24 + 22 * np.cos(ph3)))
        fr[altar_blue, 0] = np.clip(rgb[altar_blue, 0].astype(np.int32) + p_bl // 3, 0, 255).astype(np.uint8)
        fr[altar_blue, 1] = np.clip(rgb[altar_blue, 1].astype(np.int32) + p_bl, 0, 255).astype(np.uint8)
        fr[altar_blue, 2] = np.clip(rgb[altar_blue, 2].astype(np.int32) + p_bl, 0, 255).astype(np.uint8)
        fr[altar_blue, 3] = 255
        l6_gears.append(Image.fromarray(fr, mode="RGBA"))

    # Garde l'esplanade de marbre antique 100 % pure : lueur sur la frise de l'autel Nord uniquement
    altar_steps = main_temple & (yy >= int(0.24 * h)) & (yy < int(0.35 * h)) & (np.abs(xx - w // 2) <= int(0.11 * w)) & (rr + gg + bb < 320)
    l7_aura: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph1 = (2.0 * np.pi * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        arc = altar_steps & (np.sin(xx / 18.0 - ph1) > 0.35)
        fr[arc, :3] = np.clip(rgb[arc].astype(np.int32) + np.array([46, 12, 22]), 0, 255).astype(np.uint8)
        fr[arc, 3] = 255
        l7_aura.append(Image.fromarray(fr, mode="RGBA"))

    rim_mask = solid_mask & (~ndimage.binary_erosion(solid_mask, iterations=1))
    l8_rim: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph3 = (2.0 * np.pi * 3.0 * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        lit = rim_mask & (np.cos(yy / 30.0 - ph3) > 0.32)
        fr[lit, :3] = np.clip(rgb[lit].astype(np.int32) + np.array([38, 10, 12]), 0, 255).astype(np.uint8)
        fr[lit, 3] = 255
        l8_rim.append(Image.fromarray(fr, mode="RGBA"))

    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            sub_e = is_esplanade[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            sub_s = main_temple[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            if float(sub_e.mean()) >= 0.65 or (float(sub_s.mean()) >= 0.95 and int(0.34 * w) <= tx * TILE_SIZE <= int(0.64 * w)):
                walk_grid[ty, tx] = True
    cx_t = gw // 2
    for ty in range(max(3, int(round(0.28 * gh))), gh):
        walk_grid[ty, max(0, cx_t - 2):min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False

    layers = [
        LayerEntry("00_ciel_ecarlate_paralyse_d30p41a", "Ciel Écarlate du Temps Paralysé D30P41A", "BG", _to_imgs(sky_24), frame_length=5),
        LayerEntry("01_dechirures_hurle_temps_dialga", "Déchirures Hurle-Temps de Dialga Primal", "BG", _to_imgs(rift_24), frame_length=5),
        LayerEntry("02_colonnade_et_rocs_suspendus", "Colonnade Inférieure & Rocs Figés 100 % Statiques", "BG", [mk_static(is_floating_stones | is_colonnade_south)], frame_length=5),
        LayerEntry("03_esplanade_marbre_sud_nord", "Esplanade de Marbre Rose Sud-Nord", "BG", [mk_static(is_esplanade)], frame_length=5),
        LayerEntry("04_piliers_et_contreforts_pinacle", "Piliers Grecs & Contreforts Statiques", "BG", [mk_static(is_pillars_walls)], frame_length=5),
        LayerEntry("05_trone_des_cinq_rouages_nord", "Autel des Cinq Rouages du Temps", "BG", [mk_static(is_altar)], frame_length=5),
        LayerEntry("06_pulsation_primal_cinq_rouages", "Pulsation Écarlate & Cyan des Cinq Rouages", "BG", l6_gears, frame_length=5),
        LayerEntry("07_anneau_temporel_esplanade", "Onde Temporelle sur l'Esplanade", "BG", l7_aura, frame_length=5),
        LayerEntry("08_lueur_ecarlate_corniches", "Lueur Écarlate sur les Corniches & Rocs", "BG", l8_rim, frame_length=5),
        LayerEntry("09_braises_chronologiques_top", "Braises Chronologiques Suspendues Top", "Top", _to_imgs(dust_24), frame_length=5),
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
        namespace_override="tour_du_temps_tta1",
        asset_name_override="tour_du_temps_pinacle",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
