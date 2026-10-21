#!/usr/bin/env python3
"""Construit les 10 versions de Falaise Nord Centrée Nue (`01` à `10`, Jour & Nuit = 20 `.rsground`)
avec **100 % DE TEXTURES CANONIQUES MÉTANO VÉRIFIÉES (`generated_terrain_rgb_pixels == 0`)** :
  - Silhouettes organiques des 10 promontoires centrés issues de `spriter_bruts/gen_01..gen_10.png`
  - Reconstruction 100 % native sur grille `8 px` exclusivement depuis les modules officiels Halcyon :
      * `01_Herbe_Metano_Native`     : `Metano_Town_Base.tile` `(0, 640, 128, 768)` + brins `(16, 776, 32, 792)` / `(48, 792, 64, 808)`
      * `02_Faces_Metano_Natives`    : `Metano_Town_Cliffs.tile` `(1064, 464, 1192, 528)` (assise grès doré Chunsoft torique `32×32` sans couture X/Y)
      * `03_Retours_Metano_Natifs`   : `Metano_Town_Cliffs.tile` `(456, 240, 480, 304)` Ouest & `(1456, 352, 1480, 416)` Est
      * `04_Couronnes_Metano_Natives`: `Metano_Town_Cliffs.tile` `(1064..1192, 448..464)` (tranches `8×16` verrouillées en phase)
      * `05_Pieds_Metano_Natifs`     : `Metano_Town_Cliffs.tile` `(1064..1192, 520..544)` (tranches `8×24` verrouillées en phase)
  - Filtre Nuit exact `Abyss V4` (`source/cote_v4_abyss/night.py`), prouvé bit-identique à 100 % sur
    `Metano_Town_Base_Night.tile`, `Metano_Town_Cliffs_Night.tile` et `Metano_Town_Fringe_Night.tile`
  - Enregistrement complet `placements.json` par zone + contrôle indépendant `verify_canonique.py`.
"""
from __future__ import annotations

import copy
import hashlib
import io
import json
import shutil
import sys
import uuid
import zipfile
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image
from scipy.ndimage import binary_fill_holes, distance_transform_edt, gaussian_filter1d, label

ROOT = Path("/home/user/projet-creation-pmdo")
ABYSS_DIR = ROOT / "source/cote_v4_abyss"
NATIFS_V4 = ABYSS_DIR / "natifs"
INSTALLER_SRC = ROOT / "source/pmdo_cote/INSTALLER.py"
WORK_GEN = ROOT / "source/cliff_nord_centre_v1/spriter_bruts"

OUT_DIR = ROOT / "livrables_cliff_nord_centre_pmdo"
WEB_DIR = OUT_DIR / "viewer_layers_1x"
PNG_DIR = OUT_DIR / "png_1x"
ANIM_DIR = OUT_DIR / "animations_1x"
PROV_DIR = OUT_DIR / "provenance_canonique"
STAGE_DIR = Path("/tmp/stage_10_cliffs_canon_pmdo")

sys.path.insert(0, str(ABYSS_DIR))
from sample import decode as decode_abyss
from night import night as abyss_night
import tile_night_reference as abyss_ref

sys.path.insert(0, str(ROOT / "source/cliff_nord_centre_v1"))
from build import (
    W,
    H,
    GW,
    GH,
    HORIZON_Y,
    CompactTileBank,
    build_ocean_8phases,
    build_sky_and_clouds,
    encode_layer_from_frames,
    load_template_ground,
    make_empty_layer,
    make_map_bg,
    make_obstacles_grid,
    render_scene_frame,
    write_dir_sheet,
    write_tile_index_idx,
)

PLANE_FILES = [
    "L01_herbe_native.png",
    "L02_faces_natives.png",
    "L03_retours_natifs.png",
    "L04_couronnes_natives.png",
    "L05_pieds_natifs.png",
]
PLANE_NAMES_PMDO = [
    "01_Herbe_Metano_Native",
    "02_Faces_Metano_Natives",
    "03_Retours_Metano_Natifs",
    "04_Couronnes_Metano_Natives",
    "05_Pieds_Metano_Natifs",
]

MODULES: Dict[str, Tuple[str, Tuple[int, int, int, int]]] = {
    "herbe":    ("Base",   (0,    640, 128,  768)),
    "brin1":    ("Base",   (16,   776, 32,   792)),
    "brin2":    ("Base",   (48,   792, 64,   808)),
    "face":     ("Cliffs", (1064, 464, 1192, 528)),
    "retour_w": ("Cliffs", (456,  240, 480,  304)),
    "retour_e": ("Cliffs", (1456, 352, 1480, 416)),
    **{f"cour_{k:02d}": ("Cliffs", (1064 + 8 * k, 448, 1064 + 8 * k + 8, 464)) for k in range(16)},
    **{f"pied_{k:02d}": ("Cliffs", (1064 + 8 * k, 520, 1064 + 8 * k + 8, 544)) for k in range(16)},
}

ZONES: List[Tuple[str, str, str, Tuple[int, int] | None]] = [
    (
        "01_grand_cap_panoramique",
        "01 — Le Grand Cap Panoramique",
        "Promontoire central arrondi style cliffdaytest centré — 100 % tuiles canoniques Métano",
        None,
    ),
    (
        "02_eperon_nord_effile",
        "02 — L’Éperon Nord Effilé",
        "Pointe côtière élancée vers l’horizon marin Nord — 100 % tuiles canoniques Métano",
        None,
    ),
    (
        "03_double_terrasse_centrale",
        "03 — La Double Terrasse Centrale",
        "Esplanade basse et belvédère Nord surélevé avec rampe centrale — 100 % tuiles canoniques Métano",
        (92, 684),
    ),
    (
        "04_grande_esplanade_royale",
        "04 — La Grande Esplanade Royale",
        "Vaste plateau central festonné à bastions rocheux latéraux — 100 % tuiles canoniques Métano",
        (168, 726),
    ),
    (
        "05_cap_anse_jumelle",
        "05 — Le Cap aux Deux Ailes",
        "Double avancée Nord-Ouest / Nord-Est encadrant une douce anse marine — 100 % tuiles canoniques Métano",
        None,
    ),
    (
        "06_presquile_isthme_etroit",
        "06 — La Presqu’île à Isthme Étroit",
        "Large tête de cap arrondie reliée au Sud par un isthme étroit — 100 % tuiles canoniques Métano",
        None,
    ),
    (
        "07_cap_asymetrique_ouest",
        "07 — Le Cap Vent d’Ouest",
        "Silhouette côtière asymétrique s’étirant vers le Nord-Ouest — 100 % tuiles canoniques Métano",
        (132, 706),
    ),
    (
        "08_cap_asymetrique_est",
        "08 — Le Cap du Levant",
        "Corniche organique orientée Nord-Est à flanc Ouest escarpé — 100 % tuiles canoniques Métano",
        None,
    ),
    (
        "09_trois_paliers_sacres",
        "09 — Les Trois Paliers Ascendants",
        "Triple terrasse étagée Sud → Nord avec rampes centrales continues — 100 % tuiles canoniques Métano",
        (78, 720),
    ),
    (
        "10_bastion_circulaire",
        "10 — Le Bastion Circulaire",
        "Médaillon panoramique quasi circulaire ceinturé de piliers rocheux — 100 % tuiles canoniques Métano",
        None,
    ),
]


def save_png_lossless(im: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    rgba = im.convert("RGBA")
    arr = np.asarray(rgba)
    uniq, inv = np.unique(arr.reshape(-1, 4), axis=0, return_inverse=True)
    if len(uniq) <= 256:
        pal = np.zeros((256, 3), dtype=np.uint8)
        pal[: len(uniq)] = uniq[:, :3]
        p_im = Image.fromarray(inv.reshape(arr.shape[:2]).astype(np.uint8), mode="P")
        p_im.putpalette(pal.ravel().tolist())
        p_im.save(path, format="PNG", transparency=uniq[:, 3].astype(np.uint8).tobytes(), optimize=True, compress_level=9)
        assert np.array_equal(np.asarray(Image.open(path).convert("RGBA")), arr)
    else:
        rgba.save(path, format="PNG", optimize=True, compress_level=9)


def runs(row: np.ndarray, gap: int = 0) -> List[Tuple[int, int]]:
    ids = np.flatnonzero(row)
    if not len(ids):
        return []
    return [(int(g[0]), int(g[-1]) + 1) for g in np.split(ids, np.flatnonzero(np.diff(ids) > gap + 1) + 1)]


def build_canonical_zone(
    raw_path: Path,
    seed: int,
    south_spec: Tuple[int, int] | None,
    sheets: Dict[str, np.ndarray],
) -> Tuple[List[np.ndarray], np.ndarray, np.ndarray, List[dict]]:
    """Extrait les masques alpha `land` et `grass` de la silhouette spriter, puis reconstruit
    100 % des pixels exclusivement par tampons alignés `8 px` sur `Metano_Town_{Base,Cliffs}.tile`
    (`generated_terrain_rgb_pixels == 0`)."""
    sub = np.array(Image.open(raw_path).convert("RGBA"), dtype=np.uint8)
    assert sub.shape[:2] == (H - 320, W)

    r, g, b = sub[..., 0].astype(np.int16), sub[..., 1].astype(np.int16), sub[..., 2].astype(np.int16)
    fg = ~(((b - g) > 80) & (r > 130) & (b > 115))
    lbl, n_l = label(fg)
    if n_l > 1:
        cnt = np.bincount(lbl.ravel())
        cnt[0] = 0
        fg = lbl == int(cnt.argmax())
    fg = binary_fill_holes(fg)

    full_rgb = np.zeros((H, W, 3), dtype=np.uint8)
    full_rgb[320:H] = sub[..., :3]
    land = np.zeros((H, W), dtype=bool)
    land[320:H] = fg

    for x in np.flatnonzero(land[H - 10 : H].any(axis=0)):
        ys_c = np.flatnonzero(land[H - 12 : H, x])
        if len(ys_c) > 0 and ys_c[-1] < 11:
            ly = (H - 12) + int(ys_c[-1])
            land[ly + 1 : H, x] = True
            full_rgb[ly + 1 : H, x] = full_rgb[ly, x]

    rf, gf, bf = full_rgb[..., 0].astype(np.float32), full_rgb[..., 1].astype(np.float32), full_rgb[..., 2].astype(np.float32)
    raw_grass = land & (gf > rf * 0.84) & ((gf - bf) > 42.0) & (gf > 105.0)

    # 1) Élimine toute petite tache de mousse isolée (< 5000 px²) dans les flancs rocheux !
    lbl_g, n_g = label(raw_grass)
    clean_grass = np.zeros_like(raw_grass)
    if n_g > 0:
        ga = np.bincount(lbl_g.ravel())
        keep_g = np.where(ga >= 5000)[0]
        keep_g = keep_g[keep_g > 0]
        clean_grass = np.isin(lbl_g, keep_g)

    # 2) Bouche uniquement les micro-touffes internes (< 900 px²), jamais les parois rocheuses de paliers !
    lbl_h, n_h = label(~clean_grass)
    grass = clean_grass.copy()
    if n_h > 0:
        ha = np.bincount(lbl_h.ravel())
        grass |= np.isin(lbl_h, np.where((ha > 0) & (ha < 900))[0])
    grass &= land

    if south_spec is not None:
        yy, xx = np.mgrid[:H, :W]
        ho, yt_r = south_spec
        xl = (W / 2.0 - ho) + 4.5 * np.sin(yy * 0.09 + seed) + 2.5 * np.cos(yy * 0.21)
        xr = (W / 2.0 + ho) + 4.5 * np.sin(yy * 0.085 + seed + 1.7) + 2.5 * np.cos(yy * 0.19 + 0.8)
        corr = (yy >= yt_r) & (xx >= xl) & (xx <= xr)
        sd = np.minimum(xx - xl, xr - xx)
        grass = grass | (corr & (sd >= 8.0))
        land = land | corr

    # Liseré rocheux périphérique d'au moins 10 px sur tout le pourtour marin (Nord, Ouest, Est) !
    padded_land = np.vstack([land, np.tile(land[-1:], (16, 1))])
    dist_land_edge = distance_transform_edt(padded_land)[:H]
    grass = grass & (dist_land_edge >= 10.0)
    rock = land & (~grass)

    # Chaînes horizontales de colonnes 8 px et lissage Gaussien des crêtes `top` (zéro créneau +-8 px !)
    col_runs: List[List[Tuple[int, int]]] = []
    for x in range(0, W, 8):
        col_r = rock[:, x : x + 8].mean(axis=1) > 0.35
        col_runs.append([(top, bottom) for top, bottom in runs(col_r, gap=6) if bottom - top >= 5])

    visited = set()
    smoothed_tops: Dict[Tuple[int, int], int] = {}
    for ci in range(len(col_runs)):
        for ri in range(len(col_runs[ci])):
            if (ci, ri) in visited:
                continue
            chain = [(ci, ri)]
            visited.add((ci, ri))
            cur_c, cur_top = ci, col_runs[ci][ri][0]
            while cur_c + 1 < len(col_runs):
                best = None
                for rj, (t2, _b2) in enumerate(col_runs[cur_c + 1]):
                    if (cur_c + 1, rj) not in visited and abs(t2 - cur_top) <= 24:
                        if best is None or abs(t2 - cur_top) < abs(best[1] - cur_top):
                            best = (rj, t2)
                if best is None:
                    break
                visited.add((cur_c + 1, best[0]))
                chain.append((cur_c + 1, best[0]))
                cur_c, cur_top = cur_c + 1, best[1]
            raw_t = np.array([col_runs[c][r][0] for c, r in chain], dtype=np.float32)
            sm_t = gaussian_filter1d(raw_t, sigma=2.2, mode="nearest") if len(raw_t) >= 4 else raw_t
            for (c, r), val in zip(chain, sm_t):
                smoothed_tops[(c, r)] = int(round((val - 6.0) / 8.0)) * 8

    grass_render = grass.copy()
    rock_render = rock.copy()
    for ci, x in enumerate(range(0, W, 8)):
        for ri, (top, bottom) in enumerate(col_runs[ci]):
            cy = smoothed_tops[(ci, ri)]
            y_cut = max(0, min(H, cy + 8))
            if top > y_cut:
                rock_render[y_cut:top, x : x + 8] |= land[y_cut:top, x : x + 8]
                grass_render[y_cut:top, x : x + 8] = False
            elif y_cut > top:
                grass_render[top : min(bottom, y_cut), x : x + 8] |= land[top : min(bottom, y_cut), x : x + 8]
                rock_render[top : min(bottom, y_cut), x : x + 8] = False

    # Aucun pixel vert en contact direct avec l'océan : couronne rocheuse continue sur tout le rivage !
    grass_render &= dist_land_edge >= 8.0
    rock_render = land & (~grass_render)

    mask_map = {"grass": grass_render, "rock": rock_render, "land": land}
    arrays = [np.zeros((H, W, 4), dtype=np.uint8) for _ in range(5)]
    placements: List[dict] = []

    def stamp(layer: int, module: str, x: int, y: int, mask_name: str) -> None:
        assert x % 8 == 0 and y % 8 == 0
        bank, (sx, sy, ex, ey) = MODULES[module]
        mw, mh = ex - sx, ey - sy
        l, t, r_, b_ = max(0, x), max(0, y), min(W, x + mw), min(H, y + mh)
        if r_ <= l or b_ <= t:
            return
        src = sheets[bank][sy + t - y : sy + b_ - y, sx + l - x : sx + r_ - x]
        sel = mask_map[mask_name][t:b_, l:r_] & (src[..., 3] == 255)
        if module.startswith("cour_") or module.startswith("retour_"):
            c = src.astype(np.int16)
            sel &= ~((c[..., 1] > c[..., 0] - 8) & (c[..., 1] - c[..., 2] > 58))
        if not sel.any():
            return
        arrays[layer][t:b_, l:r_][sel] = src[sel]
        placements.append({"layer": layer, "module": module, "dest": [x, y], "mask": mask_name})

    # Plan 0 : Herbe canonique `Metano_Town_Base` + brins natifs sur grille 8 px
    for y in range(0, H, 128):
        for x in range(0, W, 128):
            stamp(0, "herbe", x, y, "grass")
    rng = np.random.default_rng(700 + seed)
    for _ in range(44):
        tx = int(rng.integers(10, W // 8 - 12)) * 8
        ty = int(rng.integers(42, H // 8 - 4)) * 8
        stamp(0, "brin1" if rng.random() < 0.5 else "brin2", tx, ty, "grass")

    # Plan 1 : Assises grès doré Chunsoft canoniques `Metano_Town_Cliffs` (128x64 torique 32x32 sans aucun raccord !)
    for y in range(0, H, 64):
        for x in range(0, W, 128):
            stamp(1, "face", x, y, "rock")

    # Plan 2 : Biseaux rocheux extérieurs Ouest et Est `Metano_Town_Cliffs` uniquement en bord marin
    for y in range(320, H, 64):
        band = land[y : min(H, y + 64)]
        for left, right in runs(band.mean(axis=0) > 0.35, gap=12):
            if right - left < 48:
                continue
            stamp(2, "retour_w", (left // 8) * 8, y, "rock")
            stamp(2, "retour_e", ((right - 16) // 8) * 8, y, "rock")

    # Plan 3 & Plan 4 : Couronnes dorées verrouillées en phase 8 px + ponts continus sur rampes diagonales + Pieds
    for ci, x in enumerate(range(0, W, 8)):
        k = ci % 16
        for ri, (top, bottom) in enumerate(col_runs[ci]):
            cy = smoothed_tops[(ci, ri)]
            stamp(3, f"cour_{k:02d}", x, cy, "land")
            for nci in (ci - 1, ci + 1):
                if 0 <= nci < len(col_runs):
                    near = [smoothed_tops[(nci, nri)] for nri in range(len(col_runs[nci])) if abs(smoothed_tops[(nci, nri)] - cy) <= 96]
                    if near:
                        ncy = min(near, key=lambda v: abs(v - cy))
                        if ncy > cy + 8:
                            for by in range(cy + 8, min(bottom, ncy + 8), 8):
                                stamp(3, f"cour_{k:02d}", x, by, "land")
                    else:
                        nx = nci * 8
                        g_ys = np.flatnonzero(grass_render[max(0, cy) : min(H, bottom), nx : nx + 8].any(axis=1))
                        if len(g_ys) > 8:
                            for by in range(cy + 8, min(bottom - 8, cy + int(g_ys[-1])), 8):
                                stamp(3, f"cour_{k:02d}", x, by, "rock")
            if bottom - top >= 26 and bottom < H:
                py = ((bottom + 4) // 8) * 8 - 24
                stamp(4, f"pied_{k:02d}", x, py, "rock")

    return arrays, land, grass_render, placements


def main() -> None:
    print("1/5 Décodage et audit SHA/Nuit exact des 3 planches canoniques Halcyon Métano...", flush=True)
    sheets = {name: decode_abyss(NATIFS_V4 / f"Metano_Town_{name}.tile") for name in ("Base", "Cliffs", "Fringe")}
    colors = np.unique(np.concatenate([v.reshape(-1, 4) for v in sheets.values()]), axis=0)
    swatch = Image.fromarray(colors.reshape(1, -1, 4))
    buf = io.BytesIO()
    swatch.save(buf, format="PNG")
    assert abyss_night(swatch).tobytes() == Image.open(io.BytesIO(abyss_ref.to_night(buf.getvalue()))).convert("RGBA").tobytes()
    for name, day in sheets.items():
        actual_n = decode_abyss(NATIFS_V4 / f"Metano_Town_{name}_Night.tile")
        assert np.array_equal(np.array(abyss_night(Image.fromarray(day))), actual_n), name

    canonical_rgb_set = set(map(tuple, colors[colors[:, 3] == 255][:, :3]))
    tpl_doc = load_template_ground()

    for d in (OUT_DIR, STAGE_DIR):
        if d.exists():
            shutil.rmtree(d)
    for d in (WEB_DIR, PNG_DIR, ANIM_DIR, PROV_DIR):
        d.mkdir(parents=True, exist_ok=True)

    mod_root = STAGE_DIR / "MOD_CLIFF_NORD_CENTRE_PMDO"
    bg_dir = mod_root / "Content/BG"
    tile_dir = mod_root / "Content/Tile"
    ground_dir = mod_root / "Data/Ground"
    for d in (bg_dir, tile_dir, ground_dir):
        d.mkdir(parents=True, exist_ok=True)

    print("2/5 Construction Ciel Jour/Nuit + Astres + 3 plans de Nuages RepeatX + Mer 8 phases...", flush=True)
    skies, astres_nuit, clouds = build_sky_and_clouds()
    ocean = build_ocean_8phases()

    write_dir_sheet(bg_dir / "CLIFF_CENTRE_JOUR_CIEL.dir", skies["jour"])
    write_dir_sheet(bg_dir / "CLIFF_CENTRE_NUIT_CIEL.dir", skies["nuit"])
    write_dir_sheet(bg_dir / "CLIFF_CENTRE_NUIT_ASTRES.dir", astres_nuit)
    save_png_lossless(skies["jour"], WEB_DIR / "jour_BG00_ciel.png")
    save_png_lossless(skies["nuit"], WEB_DIR / "nuit_BG00_ciel.png")
    save_png_lossless(astres_nuit, WEB_DIR / "nuit_BG01_astres.png")

    for mode in ("jour", "nuit"):
        for tkey in ("horizon", "milieu", "haut"):
            dname = f"CLIFF_CENTRE_{mode.upper()}_NUAGES_{tkey.upper()}"
            write_dir_sheet(bg_dir / f"{dname}.dir", clouds[mode][tkey])
            save_png_lossless(clouds[mode][tkey], WEB_DIR / f"{mode}_nuages_{tkey}_1440.png")
        for k in range(8):
            save_png_lossless(ocean[mode][k], WEB_DIR / f"{mode}_L00_mer_{k:02d}.png")

    banks = {
        "jour": CompactTileBank("CliffCentre10_Canon_Jour"),
        "nuit": CompactTileBank("CliffCentre10_Canon_Nuit"),
    }
    shared_sea_layers = {
        mode: encode_layer_from_frames("00_Mer_Animee_8Phases", 0, ocean[mode], banks[mode], frame_length=10)
        for mode in ("jour", "nuit")
    }
    bg_layers_by_mode = {}
    for mode in ("jour", "nuit"):
        bgs = [make_map_bg(f"CLIFF_CENTRE_{mode.upper()}_CIEL", y_offset=0, move_x=0, repeat_x=False)]
        if mode == "nuit":
            bgs.append(make_map_bg("CLIFF_CENTRE_NUIT_ASTRES", y_offset=0, move_x=0, repeat_x=False))
        for tkey, yoff, spd in [("horizon", HORIZON_Y - 64, -3), ("milieu", 118, -5), ("haut", 18, -8)]:
            bgs.append(make_map_bg(f"CLIFF_CENTRE_{mode.upper()}_NUAGES_{tkey.upper()}", y_offset=yoff, move_x=spd, repeat_x=True))
        bg_layers_by_mode[mode] = bgs

    print("3/5 Reconstruction 100 % CANONIQUE MÉTANO (5 calques natifs x 10 zones x Jour/Nuit = 20 .rsground)...", flush=True)
    manifest_zones = []

    for idx, (slug, title_fr, subtitle_fr, south_spec) in enumerate(ZONES, start=1):
        arrays_d, land, grass, placements = build_canonical_zone(
            WORK_GEN / f"gen_{slug}.png", seed=idx, south_spec=south_spec, sheets=sheets
        )
        # Vérification stricte : 0 pixel hors palette canonique Halcyon Métano !
        for li, arr in enumerate(arrays_d):
            op = arr[..., 3] > 0
            if np.any(op):
                used_cols = set(map(tuple, np.unique(arr[op][:, :3], axis=0)))
                outside = used_cols - canonical_rgb_set
                assert len(outside) == 0, f"Pixels non canoniques détectés dans {slug} plan {li}: {outside}"

        ims_by_mode = {
            "jour": [Image.fromarray(a, "RGBA") for a in arrays_d],
            "nuit": [abyss_night(Image.fromarray(a, "RGBA")) for a in arrays_d],
        }

        merged_d = Image.new("RGBA", (W, H))
        for im in ims_by_mode["jour"]:
            merged_d = Image.alpha_composite(merged_d, im)
        assert np.array_equal(np.asarray(merged_d)[..., 3] > 0, land), f"Masque alpha incomplet sur {slug}"

        # Sauvegarde des masques & placements pour reconstruction indépendante (`verify_canonique.py`)
        save_png_lossless(Image.fromarray((land.astype(np.uint8) * 255)), PROV_DIR / f"{slug}_mask_land.png")
        save_png_lossless(Image.fromarray((grass.astype(np.uint8) * 255)), PROV_DIR / f"{slug}_mask_grass.png")
        (PROV_DIR / f"{slug}_placements.json").write_text(json.dumps(placements, separators=(",", ":")), encoding="utf-8")

        obs_grid = make_obstacles_grid(grass)

        for mode in ("jour", "nuit"):
            plane_ims = ims_by_mode[mode]
            for pf, im in zip(PLANE_FILES, plane_ims):
                save_png_lossless(im, WEB_DIR / f"{slug}_{mode}_{pf}")

            ast = astres_nuit if mode == "nuit" else None
            comp = render_scene_frame(skies[mode], ast, clouds[mode], ocean[mode], plane_ims, None, None, frame_idx=0, total_frames=16)
            save_png_lossless(comp, PNG_DIR / f"cliff_centre_{slug}_{mode}.png")

            asset_name = f"cliff_centre_{slug}_{mode}"
            layers_list = [copy.deepcopy(shared_sea_layers[mode])]
            for pname, im in zip(PLANE_NAMES_PMDO, plane_ims):
                layers_list.append(encode_layer_from_frames(pname, 0, [im], banks[mode]))
            layers_list.extend([
                make_empty_layer("06_Vos_Chemins_et_Sols", 0),
                make_empty_layer("07_Vos_Structures_Base", 0),
                make_empty_layer("08_Votre_Canopee_Avant_Plan", 4),
            ])

            doc = copy.deepcopy(tpl_doc)
            doc["Version"] = "0.8.12.0"
            obj = doc["Object"]
            obj["AssetName"] = asset_name
            obj["Name"]["DefaultText"] = f"{title_fr} ({mode.capitalize()})"
            obj["Comment"] = (
                f"PMDO 0.8.12 — {title_fr} ({mode}) : 100 % modules canoniques Halcyon Metano_Town_Base/Cliffs "
                f"(generated_rgb_pixels=0) + filtre Nuit Abyss exact + Mer 8 phases + 3 nuages RepeatX."
            )
            obj["Background"] = {
                "$type": "RogueEssence.Dungeon.LayeredBG, RogueEssence",
                "Layers": copy.deepcopy(bg_layers_by_mode[mode]),
            }
            obj["Layers"] = layers_list
            obj["obstacles"] = obs_grid
            obj["Decorations"] = []
            if obj.get("Entities") and obj["Entities"][0].get("Markers"):
                obj["Entities"][0]["Markers"] = [obj["Entities"][0]["Markers"][0]]
                obj["Entities"][0]["Markers"][0]["Name"] = "Entrance_Sud"
                obj["Entities"][0]["Markers"][0]["Loc"] = {"X": 592, "Y": 816}
                obj["Entities"][0]["Markers"][0]["Dir"] = 4

            out_rsg = ground_dir / f"{asset_name}.rsground"
            out_rsg.write_bytes(json.dumps(doc, ensure_ascii=False, separators=(",", ":")).encode("utf-8"))

            for ns_dir in (
                mod_root / f"Data/Script/ground/{asset_name}",
                mod_root / f"Data/Script/cliff_nord_centre_pmdo/ground/{asset_name}",
            ):
                ns_dir.mkdir(parents=True, exist_ok=True)
                (ns_dir / "init.lua").write_text(
                    f"-- {asset_name} : 100 % modules canoniques Métano + animations natives PMDO 0.8.12\n"
                    f"local {asset_name} = {{}}\nfunction {asset_name}.Init(map)\n  COMMON.RespawnAllies()\nend\n"
                    f"return {asset_name}\n",
                    encoding="utf-8",
                )

        manifest_zones.append({
            "num": idx,
            "id": slug,
            "title": title_fr,
            "subtitle": subtitle_fr,
            "size_px": [W, H],
            "grid_tiles": [GW, GH],
            "generated_terrain_rgb_pixels": 0,
            "native_module_placements": len(placements),
            "terrain_sha256": hashlib.sha256(merged_d.tobytes()).hexdigest(),
            "rsground_jour": f"Data/Ground/cliff_centre_{slug}_jour.rsground",
            "rsground_nuit": f"Data/Ground/cliff_centre_{slug}_nuit.rsground",
            "png_jour": f"png_1x/cliff_centre_{slug}_jour.png",
            "png_nuit": f"png_1x/cliff_centre_{slug}_nuit.png",
            "layers_jour": [f"viewer_layers_1x/{slug}_jour_{pf}" for pf in PLANE_FILES],
            "layers_nuit": [f"viewer_layers_1x/{slug}_nuit_{pf}" for pf in PLANE_FILES],
        })
        print(f"  [{idx:02d}/10] PASS CANONIQUE {slug} ({len(placements)} modules natifs, 0 px généré)", flush=True)

    print("4/5 Écriture des banques `.tile` canoniques ultra-compactes, `index.idx`, `Mod.xml` & `INSTALLER.py`...", flush=True)
    tile_stats, tile_paths = [], []
    for mode in ("jour", "nuit"):
        tp = tile_dir / f"{banks[mode].sheet_name}.tile"
        tile_stats.append(banks[mode].write(tp))
        tile_paths.append(tp)
    write_tile_index_idx(tile_dir / "index.idx", tile_paths)

    ident = uuid.uuid5(uuid.NAMESPACE_URL, "https://github.com/meromoonmeri/projet-creation-pmdo/cliff_nord_centre_10_canoniques")
    (mod_root / "Mod.xml").write_text(
        f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>10 Falaises Nord Centrees Nues - Textures Canoniques Metano (0.8.12)</Name>
  <Author>meromoonmeri</Author>
  <Description>10 falaises cotieres centrees a plateau nu 100% textures canoniques Metano_Town_Base et Metano_Town_Cliffs (generated_rgb_pixels=0, 5 plans natifs, Jour et Nuit Abyss exact, mer 8 phases, 3 nuages en parallaxe).</Description>
  <Namespace>cliff_nord_centre_pmdo</Namespace>
  <UUID>{ident}</UUID>
  <Version>3.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
""",
        encoding="utf-8",
    )

    inst_txt = INSTALLER_SRC.read_text(encoding="utf-8")
    needle = "            relative = src.relative_to(source)\n"
    if needle in inst_txt:
        inst_txt = inst_txt.replace(
            needle,
            needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n",
        )
    (mod_root / "INSTALLER.py").write_text(inst_txt, encoding="utf-8")

    # GIFs animés 1x (version 01 Jour & Nuit)
    for mode in ("jour", "nuit"):
        ast = astres_nuit if mode == "nuit" else None
        p_ims = [Image.open(WEB_DIR / f"01_grand_cap_panoramique_{mode}_{pf}").convert("RGBA") for pf in PLANE_FILES]
        gframes = []
        for fi in range(8):
            fr = render_scene_frame(skies[mode], ast, clouds[mode], ocean[mode], p_ims, None, None, fi, total_frames=8)
            gframes.append(fr.convert("RGB").quantize(colors=256, method=Image.Quantize.MEDIANCUT))
        gframes[0].save(
            ANIM_DIR / f"cliff_nord_centre_{mode}_anime.gif",
            save_all=True,
            append_images=gframes[1:],
            duration=166,
            loop=0,
            optimize=True,
        )

    manifest = {
        "title": "Pack 10 Falaises Nord Centrées Nues — 100 % Textures Canoniques Métano Jour & Nuit (PMDO 0.8.12)",
        "pmdo_version": "0.8.12.0",
        "zones_count": 10,
        "maps_rsground_count": 20,
        "dimensions_px": [W, H],
        "grid_tiles_8px": [GW, GH],
        "generated_terrain_rgb_pixels": 0,
        "canonical_metano_modules": MODULES,
        "night_filter": "Exact Abyss V4 tools/tile_night.py (blob 438383f4), bit-identical to Metano_Town_{Base,Cliffs,Fringe}_Night.tile",
        "entire_base_cliffs_fringe_night_sheets_equal": True,
        "sea_phases": 8,
        "cloud_planes": 3,
        "terrain_planes": PLANE_FILES,
        "art_approved": False,
        "runtime_tested": False,
        "credits": [
            "Palikadude & contributeurs (PMDO Halcyon — Metano_Town_Base.tile, Metano_Town_Cliffs.tile)",
            "Abyss to Ascension (filtre nocturne exact Metano_Town_*_Night.tile)",
            "Spike Chunsoft (Pokémon Mystery Dungeon: Explorers of Time / Darkness / Sky)",
        ],
        "tile_banks": tile_stats,
        "zones": manifest_zones,
    }
    (OUT_DIR / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")

    (OUT_DIR / "README.md").write_text(
        """# Pack 10 Falaises Nord Centrées Nues — 100 % Textures Canoniques Métano · Multicalque · Mer 8 Phases · Jour & Nuit (PMDO 0.8.12)

## Garantie Matière 100 % Canonique (`generated_terrain_rgb_pixels == 0`)
- **0 pixel RGB généré** dans les 10 terrains : chaque calque de chaque carte est reconstruit **exclusivement par tampons alignés sur la grille `8 px`** depuis les planches natives officielles **Halcyon** (`Metano_Town_Base.tile` et `Metano_Town_Cliffs.tile`), découpés selon les 10 silhouettes organiques centrées.
- **5 calques de terrain canoniques séparés par carte** :
  1. `01_Herbe_Metano_Native` (`Metano_Town_Base` `(0,640,128,768)` + brins `(16,776,32,792)` / `(48,792,64,808)`)
  2. `02_Faces_Metano_Natives` (`Metano_Town_Cliffs` `(1064,464,1192,528)` — grès doré Chunsoft torique `32×32` sans raccord X/Y)
  3. `03_Retours_Metano_Natifs` (`Metano_Town_Cliffs` `(456,240,480,304)` Ouest & `(1456,352,1480,416)` Est)
  4. `04_Couronnes_Metano_Natives` (`Metano_Town_Cliffs` `(1064..1192,448..464)` — tranches `8×16` verrouillées en phase)
  5. `05_Pieds_Metano_Natifs` (`Metano_Town_Cliffs` `(1064..1192,520..544)` — tranches `8×24` verrouillées en phase)
- **Nuit exacte `Abyss V4`** (`source/cote_v4_abyss/night.py`), vérifiée bit-à-bit identique à 100 % sur `Metano_Town_Base_Night.tile`, `Metano_Town_Cliffs_Night.tile` et `Metano_Town_Fringe_Night.tile`.
- **Audit indépendant** : exécuter `python3 source/cliff_nord_centre_v1/verify_canonique.py` pour reconstruire les 100 calques depuis `provenance_canonique/*_placements.json` et vérifier l’égalité au bit près.

## Crédits & Statut
- **Palikadude** & contributeurs (*PMDO Halcyon*), **Abyss to Ascension**, **Spike Chunsoft**.
- Statut : `art_approved: false`, `runtime_tested: false`.
""",
        encoding="utf-8",
    )

    print("5/5 Création de l'archive `PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip`...", flush=True)
    zip_path = OUT_DIR / "PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip"
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for p in sorted(STAGE_DIR.rglob("*")):
            if p.is_file():
                zf.write(p, p.relative_to(STAGE_DIR).as_posix())
        zf.write(OUT_DIR / "README.md", "README.md")
        zf.write(OUT_DIR / "manifest.json", "manifest.json")
        for p in sorted(PROV_DIR.glob("*")):
            zf.write(p, f"provenance_canonique/{p.name}")

    print(
        f"SUCCÈS CANONIQUE : {zip_path} ({zip_path.stat().st_size / 1048576:.2f} MiB) | stats={tile_stats}",
        flush=True,
    )


if __name__ == "__main__":
    main()
