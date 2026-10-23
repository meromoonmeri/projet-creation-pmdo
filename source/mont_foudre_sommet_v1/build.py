"""Constructeur PMDO 0.8.12.0 — MFA1 : Sommet de la Montagne — Tornade Noire Électrique de Zekrom.

Architecture multicalque 10 calques (768×576, 96×72 tuiles, boucle maîtresse 120 ticks) :
  - Pic rocheux central en basalte/obsidienne sculpté avec escalier Sud sortant de la grotte,
    pont d'arête rocheuse Sud -> Nord et arène circulaire runique au sommet pour l'arrivée de Zekrom.
  - Tout le pourtour 360° peint en #FF00FF sur le brut est remplacé par une tornade cyclonique 3D
    géante de nuages noirs électriques en rotation continue autour du sommet + éclairs bleus Zekrom
    (Charge Foudre + sprites GBA H17P01W1.bpa bleutés) + couronne en surplomb Top.
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

MAP_ID = "MFA1"
MAP_TITLE = "Sommet de la Montagne — Tornade Noire Électrique de Zekrom"

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent
BRUT_PATH = HERE / "bruts" / "base_mont_foudre_sommet.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "v38p07a_storm_peak_electric_glow_native.png"
ROM_DIR = HERE.parent / "mont_foudre_entree_v1" / "references" / "native_rom"
RENDERS_DIR = REPO_ROOT / "renders" / "mont_foudre_sommet_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _to_imgs(arrs: List[np.ndarray]) -> List[Image.Image]:
    return [Image.fromarray(a, mode="RGBA") for a in arrs]


def sculpt_obsidian_summit_palette(rgb_in: np.ndarray, rock_mask: np.ndarray) -> np.ndarray:
    """Rehausse le pic de basalte noir en ardoise/obsidienne PMD ciselée (zéro aplat noir bouché #000000),
    tout en conservant des contours pixel-art sombres nets.
    """
    out = rgb_in.copy()
    lum = (
        0.299 * out[:, :, 0].astype(np.float32)
        + 0.587 * out[:, :, 1].astype(np.float32)
        + 0.114 * out[:, :, 2].astype(np.float32)
    )
    lifted = 24.0 + np.power(np.clip(lum / 88.0, 0.0, 1.35), 0.76) * 116.0
    q = (np.rint(lifted / 8.0) * 8.0).astype(np.int32)
    r_ch = np.clip((q * 88) // 100, 14, 174).astype(np.uint8)
    g_ch = np.clip((q * 100) // 100 + 4, 18, 194).astype(np.uint8)
    b_ch = np.clip((q * 126) // 100 + 14, 28, 228).astype(np.uint8)
    seams = rock_mask & (lum < 14.0)
    out[rock_mask, 0] = r_ch[rock_mask]
    out[rock_mask, 1] = g_ch[rock_mask]
    out[rock_mask, 2] = b_ch[rock_mask]
    out[seams] = (14, 20, 34)
    return out


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    im_raw = Image.open(BRUT_PATH).convert("RGB")
    if im_raw.size != (w, h):
        im_raw = im_raw.resize((w, h), Image.Resampling.NEAREST)
    rgb_raw = np.asarray(im_raw, dtype=np.uint8).copy()

    r = rgb_raw[:, :, 0].astype(np.int32)
    g = rgb_raw[:, :, 1].astype(np.int32)
    b = rgb_raw[:, :, 2].astype(np.int32)
    vortex_mask = (r >= 215) & (g <= 50) & (b >= 215)
    rgb_clean = clean_brut_magenta_fringe(rgb_raw, vortex_mask)
    rock_mask = ~vortex_mask
    rgb = sculpt_obsidian_summit_palette(rgb_clean, rock_mask)

    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    cx, cy = w * 0.50, h * 0.445
    scale_x = 768.0 / w
    scale_y = 576.0 / h

    # 1. Tornade cyclonique 360° de nuages noirs électriques + éclairs bleus Zekrom + couronne Top !
    abyss_24, cloud_24, bolt_24, canopy_24 = build_zekrom_black_tornado_layers(
        h=h,
        w=w,
        vortex_mask=vortex_mask,
        rom_dir=ROM_DIR,
        center_xy=(cx, cy),
        rx_scale=1.0 * scale_x,
        ry_scale=1.22 * scale_y,
        n_frames=N_FRAMES,
    )

    # 2. Partition sémantique statique du sommet (pitons 100 % statiques !)
    ell_arena = np.hypot((xx - cx) / max(1.0, 0.205 * w), (yy - cy) / max(1.0, 0.215 * h))
    is_bridge_stairs = rock_mask & (yy >= 0.62 * h) & (np.abs(xx - cx) <= 0.115 * w)
    is_arena_floor = rock_mask & (ell_arena <= 0.94)
    is_spires_rim = rock_mask & (~is_arena_floor) & (~is_bridge_stairs) & (yy < 0.72 * h)
    is_cliff_base = rock_mask & (~is_arena_floor) & (~is_bridge_stairs) & (~is_spires_rim)
    is_cliff_base |= rock_mask & (~(is_cliff_base | is_spires_rim | is_arena_floor | is_bridge_stairs))

    def mk_static(mask: np.ndarray) -> Image.Image:
        out = np.zeros((h, w, 4), dtype=np.uint8)
        out[mask, :3] = rgb[mask]
        out[mask, 3] = 255
        return Image.fromarray(out, mode="RGBA")

    # 3. Calque L7 : Veines fines Charge Foudre strictement dans les joints fins de l'arène centrale
    raw_lum = (
        0.299 * rgb_clean[:, :, 0].astype(np.float32)
        + 0.587 * rgb_clean[:, :, 1].astype(np.float32)
        + 0.114 * rgb_clean[:, :, 2].astype(np.float32)
    )
    local_mean = ndimage.uniform_filter(raw_lum, size=7)
    thin_seams = (local_mean - raw_lum) >= 5.5
    arena_seams = is_arena_floor & thin_seams & (ell_arena >= 0.18) & (ell_arena <= 0.78)
    cliff_inner_rim = rock_mask & (~ndimage.binary_erosion(rock_mask, iterations=2))
    theta_px = np.arctan2(yy - cy, xx - cx)
    l7_runes: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph1 = (2.0 * np.pi * f) / N_FRAMES
        ph3 = (2.0 * np.pi * 3.0 * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        wave = np.sin(4.0 * theta_px - ph1) + 0.5 * np.cos(8.0 * ell_arena - ph3)
        active = arena_seams & (wave > 0.35)
        core = arena_seams & (wave > 0.92)
        fr[active] = (36, 128, 246, 255)
        fr[core] = (156, 232, 255, 255)
        rim_hit = cliff_inner_rim & (np.sin(5.0 * theta_px - ph1) > 0.42)
        fr[rim_hit, :3] = np.clip(rgb[rim_hit].astype(np.int32) + np.array([22, 68, 138]), 0, 255).astype(np.uint8)
        fr[rim_hit, 3] = 255
        l7_runes.append(Image.fromarray(fr, mode="RGBA"))

    # 4. Calque L9 Top : Étincelles cycloniques haute vitesse & filaments Charge Foudre autour du sommet
    rng = np.random.default_rng(64499)
    sparks = [
        (
            float(rng.uniform(0.0, 2.0 * np.pi)),
            float(rng.uniform(168.0, 355.0)) / scale_x,
            int(rng.choice([1, 3])),
            bool(rng.integers(0, 2)),
        )
        for _ in range(96)
    ]
    l9_sparks: List[Image.Image] = []
    for f in range(N_FRAMES):
        ph1 = (2.0 * np.pi * f) / N_FRAMES
        ph3 = (2.0 * np.pi * 3.0 * f) / N_FRAMES
        fr = np.zeros((h, w, 4), dtype=np.uint8)
        for a0, rad0, hm, bright in sparks:
            ang = a0 + (ph1 if hm == 1 else ph3)
            px = int(round(cx + rad0 * np.cos(ang)))
            py = int(round(cy + (rad0 / 1.22) * np.sin(ang)))
            if 1 <= px < w - 1 and 1 <= py < h - 1:
                fr[py, px] = (232, 250, 255, 255) if bright else (68, 174, 255, 255)
                px2 = int(round(cx + rad0 * np.cos(ang - 0.045)))
                py2 = int(round(cy + (rad0 / 1.22) * np.sin(ang - 0.045)))
                if 0 <= px2 < w and 0 <= py2 < h:
                    fr[py2, px2] = (28, 104, 236, 255)
        l9_sparks.append(Image.fromarray(fr, mode="RGBA"))

    # Grille de collision Sud -> Nord continue : escalier Sud -> pont d'arête -> arène circulaire Zekrom
    gw, gh = w // TILE_SIZE, h // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    for ty in range(gh):
        for tx in range(gw):
            sub_a = is_arena_floor[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            sub_b = is_bridge_stairs[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            sub_v = vortex_mask[ty * TILE_SIZE:(ty + 1) * TILE_SIZE, tx * TILE_SIZE:(tx + 1) * TILE_SIZE]
            if (float(sub_a.mean()) >= 0.65 or float(sub_b.mean()) >= 0.55) and float(sub_v.mean()) == 0.0:
                walk_grid[ty, tx] = True
    cx_t = gw // 2
    arena_center_t = max(3, int(round(0.30 * gh)))
    for ty in range(arena_center_t, gh):
        walk_grid[ty, max(0, cx_t - 2):min(gw, cx_t + 3)] = True
    walk_grid[:2, :] = False
    walk_grid[:, :2] = False
    walk_grid[:, -2:] = False

    layers = [
        LayerEntry("00_abysse_oeil_tornade_noire", "Abysse Cyclonique de l'Œil de l'Orage", "BG", _to_imgs(abyss_24), frame_length=5),
        LayerEntry("01_tornade_nuages_noirs_zekrom_360", "Tornade 360° de Nuages Noirs Électriques de Zekrom", "BG", _to_imgs(cloud_24), frame_length=5),
        LayerEntry("02_eclairs_bleus_tornade_h17p01w", "Arcs Charge Foudre Bleus & GBA H17P01W1.bpa 1×", "BG", _to_imgs(bolt_24), frame_length=5),
        LayerEntry("03_socle_falaise_basalte_sommet", "Socle Rocheux d'Obsidienne du Sommet", "BG", [mk_static(is_cliff_base)], frame_length=5),
        LayerEntry("04_pitons_magnetite_statiques", "Pitons de Magnétite Noire 100 % Statiques", "BG", [mk_static(is_spires_rim)], frame_length=5),
        LayerEntry("05_arene_circulaire_zekrom", "Esplanade Circulaire Runique de Zekrom", "BG", [mk_static(is_arena_floor)], frame_length=5),
        LayerEntry("06_pont_et_escalier_grotte_sud", "Pont d'Arête Sud-Nord & Sortie de Grotte", "BG", [mk_static(is_bridge_stairs)], frame_length=5),
        LayerEntry("07_veines_runiques_charge_foudre", "Pulsation Électrique Bleue des Runes du Sommet", "BG", l7_runes, frame_length=5),
        LayerEntry("08_couronne_cyclone_noir_top", "Couronne Supérieure de la Tornade Noire Top", "Top", _to_imgs(canopy_24), frame_length=5),
        LayerEntry("09_etincelles_cycloniques_zekrom_top", "Étincelles Cycloniques Charge Foudre Top", "Top", l9_sparks, frame_length=5),
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
