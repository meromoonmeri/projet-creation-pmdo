#!/usr/bin/env python3
"""Construit le pack complet des 10 versions de Falaise Nord Centrée Nue
(`01` à `10` — Jour & Nuit = 20 cartes `.rsground` PMDO 0.8.12 + calques PNG 1x séparés + GIFs) :
  - Bordures dentelées dorées-ocres & piliers rocheux rosés/dorés sculptés via la passe spriter
    `generate_image` (`/tmp/work_cliff10/gen_01..gen_10.png`)
  - Zéro halo magenta, découpe binaire nette `alpha in {0, 255}`
  - Intérieur des plateaux 100 % nu unifié en vraie texture native `Metano_Town_Base` (Grass Métano)
  - Ouverture Sud herbeuse praticable garantie sur 100 % des 10 cartes (`y = 880`)
  - Grille de collisions `obstacles` calculée au pixel/tuile `8×8` près (plateau marchable `0`, mer `2`, parois `1`)
  - Séparation multicalque exacte :
      BG00 Ciel Jour/Nuit · BG01 Astres Nuit · BG02..BG04 Nuages 3 plans RepeatX
      L00 Mer animée 8 phases · L01 Parois rocheuses Métano · L02 Plateau nu Grass Métano
      L03..L05 Calques vides prêts à éditer dans PMDO 0.8.12 (Sols, Objets Base, Canopée Top)
  - Colorimétrie Nuit apprise sur les paires officielles `Metano_Town_Base[_Night].tile` & `Metano_Town_Cliffs[_Night].tile`.
"""
from __future__ import annotations

import copy
import json
import shutil
import sys
import uuid
import zipfile
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image
from scipy.ndimage import (
    binary_dilation,
    binary_erosion,
    binary_fill_holes,
    distance_transform_edt,
    label,
)
from scipy.spatial import cKDTree

ROOT = Path("/home/user/projet-creation-pmdo")
NATIFS_V4 = ROOT / "source/cote_v4_abyss/natifs"
INSTALLER_SRC = ROOT / "source/pmdo_cote/INSTALLER.py"
WORK_GEN = ROOT / "source/cliff_nord_centre_v1/spriter_bruts"

OUT_DIR = ROOT / "livrables_cliff_nord_centre_pmdo"
WEB_DIR = OUT_DIR / "viewer_layers_1x"
PNG_DIR = OUT_DIR / "png_1x"
ANIM_DIR = OUT_DIR / "animations_1x"
STAGE_DIR = Path("/tmp/stage_10_cliffs_pmdo")

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
    decode_tile_straight,
    encode_layer_from_frames,
    load_template_ground,
    make_empty_layer,
    make_map_bg,
    make_obstacles_grid,
    render_scene_frame,
    save_png,
    write_dir_sheet,
    write_tile_index_idx,
)

ZONES: List[Tuple[str, str, str, Tuple[int, int] | None]] = [
    (
        "01_grand_cap_panoramique",
        "01 — Le Grand Cap Panoramique",
        "Promontoire central arrondi style cliffdaytest centré, piliers rosés/ocres étagés et large entrée Sud",
        None,
    ),
    (
        "02_eperon_nord_effile",
        "02 — L’Éperon Nord Effilé",
        "Pointe côtière élancée vers l’horizon marin Nord, flancs abrupts sculptés et chaussée herbeuse Sud",
        None,
    ),
    (
        "03_double_terrasse_centrale",
        "03 — La Double Terrasse Centrale",
        "Esplanade basse et belvédère Nord surélevé reliés par une rampe naturelle en Grass Métano",
        (92, 684),
    ),
    (
        "04_grande_esplanade_royale",
        "04 — La Grande Esplanade Royale",
        "Vaste plateau central festonné à bastions rocheux latéraux, idéal pour un village ou une guilde",
        (168, 726),
    ),
    (
        "05_cap_anse_jumelle",
        "05 — Le Cap aux Deux Ailes",
        "Double avancée Nord-Ouest / Nord-Est encadrant une douce anse marine panoramique",
        None,
    ),
    (
        "06_presquile_isthme_etroit",
        "06 — La Presqu’île à Isthme Étroit",
        "Large tête de cap arrondie reliée au continent Sud par un pont naturel d’herbe bordé de falaises",
        None,
    ),
    (
        "07_cap_asymetrique_ouest",
        "07 — Le Cap Vent d’Ouest",
        "Silhouette côtière asymétrique s’étirant vers le Nord-Ouest avec crique incurvée et contreforts",
        (132, 706),
    ),
    (
        "08_cap_asymetrique_est",
        "08 — Le Cap du Levant",
        "Corniche organique orientée Nord-Est à flanc Ouest escarpé et large ouverture herbeuse Sud",
        None,
    ),
    (
        "09_trois_paliers_sacres",
        "09 — Les Trois Paliers Ascendants",
        "Triple terrasse étagée Sud → Nord avec rampes centrales continues jusqu’au sommet marin",
        (78, 720),
    ),
    (
        "10_bastion_circulaire",
        "10 — Le Bastion Circulaire",
        "Médaillon panoramique quasi circulaire ceinturé d’une couronne de piliers rocheux Métano",
        None,
    ),
]


def build_night_color_lut() -> Tuple[cKDTree, np.ndarray]:
    pairs_d, pairs_n = [], []
    for stem in ("Metano_Town_Base", "Metano_Town_Cliffs"):
        im_d = np.array(decode_tile_straight(NATIFS_V4 / f"{stem}.tile").convert("RGBA"))
        im_n = np.array(decode_tile_straight(NATIFS_V4 / f"{stem}_Night.tile").convert("RGBA"))
        m = (im_d[..., 3] == 255) & (im_n[..., 3] == 255)
        pairs_d.append(im_d[m][:, :3])
        pairs_n.append(im_n[m][:, :3])

    all_d = np.concatenate(pairs_d, axis=0)
    all_n = np.concatenate(pairs_n, axis=0)
    packed = (all_d[:, 0].astype(np.int32) << 16) | (all_d[:, 1].astype(np.int32) << 8) | all_d[:, 2].astype(np.int32)
    uniq_p, inv = np.unique(packed, return_inverse=True)
    n_u = len(uniq_p)
    src_rgb = np.stack([(uniq_p >> 16) & 255, (uniq_p >> 8) & 255, uniq_p & 255], axis=1).astype(np.float32)
    dst_rgb = np.zeros((n_u, 3), dtype=np.float64)
    counts = np.bincount(inv, minlength=n_u).astype(np.float64)[:, None]
    np.add.at(dst_rgb, inv, all_n.astype(np.float64))
    dst_u8 = np.clip(np.rint(dst_rgb / np.maximum(counts, 1.0)), 0, 255).astype(np.uint8)
    return cKDTree(src_rgb), dst_u8


def apply_native_night_lut(day_rgba: np.ndarray, tree: cKDTree, dst_u8: np.ndarray) -> np.ndarray:
    out = np.zeros_like(day_rgba)
    m = day_rgba[..., 3] > 0
    if not np.any(m):
        return out
    px = day_rgba[m][:, :3].astype(np.float32)
    _, idx = tree.query(px, k=1)
    matched_day = tree.data[idx]
    matched_night = dst_u8[idx].astype(np.float32)
    delta = (px - matched_day) * np.array([0.42, 0.44, 0.56], dtype=np.float32)
    out[m, :3] = np.clip(np.rint(matched_night + delta), 0, 255).astype(np.uint8)
    out[m, 3] = day_rgba[m, 3]
    return out


def save_png_compact(im: Image.Image, path: Path) -> None:
    """Sauvegarde PNG 100 % sans perte bit-à-bit : utilise PNG-8 indexé exact si <= 256 couleurs RGBA."""
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


def build_shared_rock_palette() -> cKDTree:
    """Extrait une palette commune de 28 couleurs de roche/rebord sur `gen_01` pour maximiser la cohérence et la déduplication `.tile`."""
    ref = np.array(Image.open(WORK_GEN / "gen_01_grand_cap_panoramique.png").convert("RGB"))
    r, g, b = ref[..., 0].astype(int), ref[..., 1].astype(int), ref[..., 2].astype(int)
    rockish = ~(((b - g) > 80) & (r > 130)) & ~((g > r * 0.88) & ((g - b) > 45))
    sample = ref[rockish].reshape(-1, 1, 3)
    q = Image.fromarray(sample, "RGB").quantize(colors=28, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE).convert("RGB")
    cols = np.unique(np.asarray(q).reshape(-1, 3), axis=0).astype(np.float32)
    return cKDTree(cols)


SHARED_ROCK_TREE: cKDTree | None = None


def make_native_grass_field(seed: int, base_d: np.ndarray) -> np.ndarray:
    grass_patch = base_d[640:768, 0:128, :4].copy()
    field = np.zeros((H, W, 4), dtype=np.uint8)
    rolled = np.roll(np.roll(grass_patch, (seed * 16) % 128, axis=0), (seed * 24) % 128, axis=1)
    for y in range(0, H, 128):
        for x in range(0, W, 128):
            ph, pw = min(128, H - y), min(128, W - x)
            field[y : y + ph, x : x + pw] = rolled[:ph, :pw]

    tuft1 = base_d[776:792, 16:32].copy()
    tuft2 = base_d[792:808, 48:64].copy()
    rng = np.random.default_rng(1000 + seed * 37)
    for _ in range(34):
        tx = int(rng.integers(64, W - 80))
        ty = int(rng.integers(320, H - 24))
        t = tuft1 if rng.random() < 0.5 else tuft2
        m = t[..., 3] == 255
        field[ty : ty + 16, tx : tx + 16][m] = t[m]
    return field


def process_spriter_zone(
    raw_path: Path,
    seed: int,
    south_open_spec: Tuple[int, int] | None,
    base_d: np.ndarray,
) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Retourne `(rock_day, grass_day, walkable_mask)`."""
    gen_im = Image.open(raw_path).convert("RGBA").resize((W, H - 320), Image.Resampling.NEAREST)
    sub = np.array(gen_im, dtype=np.uint8)

    r = sub[..., 0].astype(np.int16)
    g = sub[..., 1].astype(np.int16)
    b = sub[..., 2].astype(np.int16)

    is_magenta = ((b - g) > 80) & (r > 130) & (b > 115)
    fg = ~is_magenta
    lbl, n_lbl = label(fg)
    if n_lbl > 1:
        counts = np.bincount(lbl.ravel())
        counts[0] = 0
        fg = lbl == int(counts.argmax())
    fg = binary_fill_holes(fg)

    pure_fg = fg & ((b - g) <= 22)
    if np.any(pure_fg) and np.any(fg & ~pure_fg):
        _, nearest_idx = distance_transform_edt(~pure_fg, return_indices=True)
        spill = fg & ~pure_fg
        sub[spill, :3] = sub[nearest_idx[0][spill], nearest_idx[1][spill], :3]

    sub[~fg] = 0
    sub[fg, 3] = 255

    full = np.zeros((H, W, 4), dtype=np.uint8)
    full[320:H, :, :] = sub
    fg_full = full[..., 3] == 255

    # Contact franc avec le bord inférieur y = H-1
    bottom_occ = np.flatnonzero(fg_full[H - 10 : H, :].any(axis=0))
    for x in bottom_occ:
        ys_col = np.flatnonzero(fg_full[H - 12 : H, x])
        if len(ys_col) > 0 and ys_col[-1] < 11:
            last_y = (H - 12) + int(ys_col[-1])
            full[last_y + 1 : H, x] = full[last_y, x]
    fg_full = full[..., 3] == 255

    rf = full[..., 0].astype(np.float32)
    gf = full[..., 1].astype(np.float32)
    bf = full[..., 2].astype(np.float32)

    raw_grass = fg_full & (gf > rf * 0.84) & ((gf - bf) > 42.0) & (gf > 105.0)
    # Ne bouche QUE les petites touffes/taches internes (< 900 px²), JAMAIS les murs de paliers intérieurs (zones 03 & 09) !
    inv_grass = ~raw_grass
    lbl_h, n_h = label(inv_grass)
    grass_closed = raw_grass.copy()
    if n_h > 0:
        h_areas = np.bincount(lbl_h.ravel())
        small_holes = np.isin(lbl_h, np.where((h_areas > 0) & (h_areas < 900))[0])
        grass_closed |= small_holes
    grass_closed &= fg_full

    native_grass = make_native_grass_field(seed, base_d)
    yy, xx = np.mgrid[:H, :W]

    if south_open_spec is not None:
        half_open, y_top_reach = south_open_spec
        wob_l = 4.5 * np.sin(yy * 0.09 + seed) + 2.5 * np.cos(yy * 0.21)
        wob_r = 4.5 * np.sin(yy * 0.085 + seed + 1.7) + 2.5 * np.cos(yy * 0.19 + 0.8)
        xl_curve = (W / 2.0 - half_open) + wob_l
        xr_curve = (W / 2.0 + half_open) + wob_r

        corridor = (yy >= y_top_reach) & (xx >= xl_curve) & (xx <= xr_curve)
        side_dist = np.minimum(xx - xl_curve, xr_curve - xx)
        in_wall_zone = corridor & (~grass_closed)

        OUTLINE_DARK = np.array([104, 72, 40, 255], dtype=np.uint8)
        LIP_SHADOW   = np.array([148, 104, 54, 255], dtype=np.uint8)
        LIP_OCHRE    = np.array([196, 150, 78, 255], dtype=np.uint8)
        LIP_GOLD     = np.array([220, 184, 102, 255], dtype=np.uint8)
        GRASS_SHADE  = np.array([176, 200, 58, 255], dtype=np.uint8)

        full[in_wall_zone] = native_grass[in_wall_zone]
        sd = side_dist + 1.1 * np.sin(yy * 0.37 + xx * 0.23 + seed)
        full[in_wall_zone & (sd < 9.0)] = GRASS_SHADE
        full[in_wall_zone & (sd < 6.8)] = LIP_GOLD
        full[in_wall_zone & (sd < 4.6)] = LIP_OCHRE
        full[in_wall_zone & (sd < 2.5)] = LIP_SHADOW
        full[in_wall_zone & (sd < 1.3)] = OUTLINE_DARK

        grass_closed = grass_closed | (corridor & (sd >= 6.8))
        fg_full = full[..., 3] == 255

    padded_grass = np.vstack([grass_closed, np.tile(grass_closed[-1:], (18, 1))])
    dist_inside_grass = distance_transform_edt(padded_grass)[:H]

    blend_w = np.clip((dist_inside_grass - 3.0) / 8.0, 0.0, 1.0)[..., None]
    blended_rgb = np.rint(
        full[..., :3].astype(np.float32) * (1.0 - blend_w)
        + native_grass[..., :3].astype(np.float32) * blend_w
    ).astype(np.uint8)

    replace_mask = grass_closed & (dist_inside_grass > 3.0)
    full[replace_mask, :3] = blended_rgb[replace_mask]

    grass_pal = np.array(
        [[184, 208, 64], [200, 216, 80], [216, 224, 104], [176, 200, 58], [162, 188, 52]],
        dtype=np.float32,
    )
    trans_zone = grass_closed & (dist_inside_grass > 3.0) & (dist_inside_grass < 11.5)
    if np.any(trans_zone):
        gtree = cKDTree(grass_pal)
        _, gidx = gtree.query(full[trans_zone, :3].astype(np.float32), k=1)
        full[trans_zone, :3] = grass_pal[gidx].astype(np.uint8)

    global SHARED_ROCK_TREE
    if SHARED_ROCK_TREE is None:
        SHARED_ROCK_TREE = build_shared_rock_palette()
    non_pure_grass = fg_full & (~(grass_closed & (dist_inside_grass >= 11.5)))
    if np.any(non_pure_grass):
        _, r_idx = SHARED_ROCK_TREE.query(full[non_pure_grass, :3].astype(np.float32), k=1)
        full[non_pure_grass, :3] = SHARED_ROCK_TREE.data[r_idx].astype(np.uint8)

    plateau_with_lip = binary_dilation(grass_closed, iterations=10) & fg_full
    rock_mask = fg_full & (~plateau_with_lip)
    rock_under_tuck = binary_dilation(rock_mask, iterations=4) & fg_full

    grass_layer = np.zeros((H, W, 4), dtype=np.uint8)
    grass_layer[plateau_with_lip] = full[plateau_with_lip]

    rock_layer = np.zeros((H, W, 4), dtype=np.uint8)
    rock_layer[rock_under_tuck] = full[rock_under_tuck]

    recomp = Image.alpha_composite(Image.fromarray(rock_layer), Image.fromarray(grass_layer))
    assert np.array_equal(np.array(recomp), full), "Recomposition L01 + L02 non identique !"
    return rock_layer, grass_layer, grass_closed


def main() -> None:
    print("1/5 Apprentissage de la correspondance exacte Jour -> Nuit Halcyon Métano...", flush=True)
    base_d = np.array(decode_tile_straight(NATIFS_V4 / "Metano_Town_Base.tile").convert("RGBA"))
    night_tree, night_dst = build_night_color_lut()
    tpl_doc = load_template_ground()

    for d in (OUT_DIR, STAGE_DIR):
        if d.exists():
            shutil.rmtree(d)
    WEB_DIR.mkdir(parents=True, exist_ok=True)
    PNG_DIR.mkdir(parents=True, exist_ok=True)
    ANIM_DIR.mkdir(parents=True, exist_ok=True)

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
    save_png(skies["jour"], WEB_DIR / "jour_BG00_ciel.png")
    save_png(skies["nuit"], WEB_DIR / "nuit_BG00_ciel.png")
    save_png(astres_nuit, WEB_DIR / "nuit_BG01_astres.png")

    for mode in ("jour", "nuit"):
        for tkey in ("horizon", "milieu", "haut"):
            dname = f"CLIFF_CENTRE_{mode.upper()}_NUAGES_{tkey.upper()}"
            write_dir_sheet(bg_dir / f"{dname}.dir", clouds[mode][tkey])
            save_png(clouds[mode][tkey], WEB_DIR / f"{mode}_nuages_{tkey}_1440.png")
        for k in range(8):
            save_png(ocean[mode][k], WEB_DIR / f"{mode}_L00_mer_{k:02d}.png")

    banks = {
        "jour": CompactTileBank("CliffCentre10_Jour"),
        "nuit": CompactTileBank("CliffCentre10_Nuit"),
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

    print("3/5 Finalisation spriter + séparation multicalque des 10 falaises centrées nues (20 cartes .rsground)...", flush=True)
    manifest_zones = []

    for idx, (slug, title_fr, subtitle_fr, south_spec) in enumerate(ZONES, start=1):
        raw_p = WORK_GEN / f"gen_{slug}.png"
        rock_d, grass_d, walk_mask = process_spriter_zone(raw_p, seed=idx, south_open_spec=south_spec, base_d=base_d)
        rock_n = apply_native_night_lut(rock_d, night_tree, night_dst)
        grass_n = apply_native_night_lut(grass_d, night_tree, night_dst)

        rk_ims = {"jour": Image.fromarray(rock_d, "RGBA"), "nuit": Image.fromarray(rock_n, "RGBA")}
        gr_ims = {"jour": Image.fromarray(grass_d, "RGBA"), "nuit": Image.fromarray(grass_n, "RGBA")}
        obs_grid = make_obstacles_grid(walk_mask)

        for mode in ("jour", "nuit"):
            save_png_compact(rk_ims[mode], WEB_DIR / f"{slug}_{mode}_L01_roche.png")
            save_png_compact(gr_ims[mode], WEB_DIR / f"{slug}_{mode}_L02_plateau_grass_metano.png")

            ast = astres_nuit if mode == "nuit" else None
            comp = render_scene_frame(
                skies[mode], ast, clouds[mode], ocean[mode],
                [rk_ims[mode], gr_ims[mode]], None, None, frame_idx=0, total_frames=16,
            )
            save_png_compact(comp, PNG_DIR / f"cliff_centre_{slug}_{mode}.png")

            asset_name = f"cliff_centre_{slug}_{mode}"
            layers_list = [
                copy.deepcopy(shared_sea_layers[mode]),
                encode_layer_from_frames("01_Falaise_Parois_Metano", 0, [rk_ims[mode]], banks[mode]),
                encode_layer_from_frames("02_Plateau_Nu_Grass_Metano", 0, [gr_ims[mode]], banks[mode]),
                make_empty_layer("03_Vos_Chemins_Sols", 0),
                make_empty_layer("04_Vos_Structures_Base", 0),
                make_empty_layer("05_Votre_Canopee_Avant_Plan", 4),
            ]
            doc = copy.deepcopy(tpl_doc)
            doc["Version"] = "0.8.12.0"
            obj = doc["Object"]
            obj["AssetName"] = asset_name
            obj["Name"]["DefaultText"] = f"{title_fr} ({mode.capitalize()})"
            obj["Comment"] = (
                f"PMDO 0.8.12 — {title_fr} ({mode}) : plateau nu Grass Métano, bordures et raccords "
                f"corrigés au spriter + mer 8 phases + ciel & 3 nuages animés."
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
                    f"-- {asset_name} : animations ciel/mer 100 % natives PMDO 0.8.12\n"
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
            "rsground_jour": f"Data/Ground/cliff_centre_{slug}_jour.rsground",
            "rsground_nuit": f"Data/Ground/cliff_centre_{slug}_nuit.rsground",
            "png_jour": f"png_1x/cliff_centre_{slug}_jour.png",
            "png_nuit": f"png_1x/cliff_centre_{slug}_nuit.png",
            "layers_jour": [
                f"viewer_layers_1x/{slug}_jour_L01_roche.png",
                f"viewer_layers_1x/{slug}_jour_L02_plateau_grass_metano.png",
            ],
            "layers_nuit": [
                f"viewer_layers_1x/{slug}_nuit_L01_roche.png",
                f"viewer_layers_1x/{slug}_nuit_L02_plateau_grass_metano.png",
            ],
        })
        print(f"  [{idx:02d}/10] OK {slug}", flush=True)

    print("4/5 Écriture des banques `.tile` dédupliquées, `index.idx`, `Mod.xml` & `INSTALLER.py`...", flush=True)
    tile_stats, tile_paths = [], []
    for mode in ("jour", "nuit"):
        tp = tile_dir / f"{banks[mode].sheet_name}.tile"
        tile_stats.append(banks[mode].write(tp))
        tile_paths.append(tp)
    write_tile_index_idx(tile_dir / "index.idx", tile_paths)

    ident = uuid.uuid5(uuid.NAMESPACE_URL, "https://github.com/meromoonmeri/projet-creation-pmdo/cliff_nord_centre_10_nues")
    (mod_root / "Mod.xml").write_text(
        f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>10 Falaises Nord Centrees Nues - Grass Metano Jour et Nuit (0.8.12)</Name>
  <Author>meromoonmeri</Author>
  <Description>10 versions de falaises cotieres centrees a plateau nu Grass Metano (20 cartes .rsground Jour et Nuit), multicalques, mer animee 8 phases et ciel/nuages en parallaxe.</Description>
  <Namespace>cliff_nord_centre_pmdo</Namespace>
  <UUID>{ident}</UUID>
  <Version>2.0.0.0</Version>
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
        rk0 = Image.open(WEB_DIR / f"01_grand_cap_panoramique_{mode}_L01_roche.png").convert("RGBA")
        gr0 = Image.open(WEB_DIR / f"01_grand_cap_panoramique_{mode}_L02_plateau_grass_metano.png").convert("RGBA")
        gframes = []
        for fi in range(8):
            fr = render_scene_frame(skies[mode], ast, clouds[mode], ocean[mode], [rk0, gr0], None, None, fi, total_frames=8)
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
        "title": "Pack 10 Falaises Nord Centrées Nues — Grass Métano Multicalque Jour & Nuit (PMDO 0.8.12)",
        "pmdo_version": "0.8.12.0",
        "zones_count": 10,
        "maps_rsground_count": 20,
        "dimensions_px": [W, H],
        "grid_tiles_8px": [GW, GH],
        "bare_plateau": True,
        "sea_phases": 8,
        "cloud_planes": 3,
        "terrain_pipeline": "10 passes spriter generate_image sur base native Metano + intérieur unifié Metano_Town_Base + découpe multicalque L01 roche / L02 plateau Grass Métano + table nocturne Halcyon exacte",
        "art_approved": False,
        "runtime_tested": False,
        "credits": [
            "Spike Chunsoft (Pokémon Mystery Dungeon: Explorers of Time / Darkness / Sky)",
            "Palikadude & contributeurs (PMDO Halcyon — Metano Town)",
        ],
        "tile_banks": tile_stats,
        "zones": manifest_zones,
    }
    (OUT_DIR / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")

    (OUT_DIR / "README.md").write_text(
        """# Pack 10 Falaises Nord Centrées Nues — Grass Métano · Multicalque · Mer 8 Phases · Jour & Nuit (PMDO 0.8.12)

## Les 10 Versions Incluses (`20` cartes `.rsground` = `10 Jour` + `10 Nuit`, `1200 × 880 px` = `150 × 110` tuiles)
1. **01 — Le Grand Cap Panoramique** (`cliff_centre_01_grand_cap_panoramique_jour` / `_nuit`)
2. **02 — L’Éperon Nord Effilé** (`cliff_centre_02_eperon_nord_effile_jour` / `_nuit`)
3. **03 — La Double Terrasse Centrale** (`cliff_centre_03_double_terrasse_centrale_jour` / `_nuit`)
4. **04 — La Grande Esplanade Royale** (`cliff_centre_04_grande_esplanade_royale_jour` / `_nuit`)
5. **05 — Le Cap aux Deux Ailes** (`cliff_centre_05_cap_anse_jumelle_jour` / `_nuit`)
6. **06 — La Presqu’île à Isthme Étroit** (`cliff_centre_06_presquile_isthme_etroit_jour` / `_nuit`)
7. **07 — Le Cap Vent d’Ouest** (`cliff_centre_07_cap_asymetrique_ouest_jour` / `_nuit`)
8. **08 — Le Cap du Levant** (`cliff_centre_08_cap_asymetrique_est_jour` / `_nuit`)
9. **09 — Les Trois Paliers Ascendants** (`cliff_centre_09_trois_paliers_sacres_jour` / `_nuit`)
10. **10 — Le Bastion Circulaire** (`cliff_centre_10_bastion_circulaire_jour` / `_nuit`)

## Architecture Multicalque
- `BG 00` : Ciel velouté sans bande (`Jour` / `Nuit`)
- `BG 01` : Lune croissante & étoiles (`Nuit`)
- `BG 02..04` : 3 plans de nuages animés en parallaxe continue (`RepeatX = true`)
- `L00` : Mer Chunsoft animée en 8 phases (`FrameLength = 10`)
- `L01` : Parois & piliers rocheux de falaise Métano (calque roche transparent séparé)
- `L02` : Plateau nu `Grass Métano` + liseré de falaise dentelé ocre-doré (calque herbe transparent séparé)
- `L03..05` : 3 calques vides prêts à éditer dans PMDO (`03_Vos_Chemins_Sols`, `04_Vos_Structures_Base`, `05_Votre_Canopee_Avant_Plan` `Draw.Top`)

## Crédits & Statut
- Références graphiques : **Spike Chunsoft** (*Pokémon Mystery Dungeon: Explorers*) & **Palikadude** (*PMDO Halcyon — Metano Town*).
- Statut : bordures et raccords sculptés au générateur spriter + intérieur `Metano_Town_Base`, `art_approved: false`, `runtime_tested: false`.
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

    print(
        f"SUCCÈS : {zip_path} ({zip_path.stat().st_size / 1048576:.2f} MiB) | stats={tile_stats}",
        flush=True,
    )


if __name__ == "__main__":
    main()
