#!/usr/bin/env python3
"""Assembleur 1x Chunsoft / Halcyon sans perte pour les bruts 768x576 des duos Zekrom & Reshiram :

1. `assemble_entree_montagne_clairiere_metano(mode, map_dir, asset_name)` :
   - Montagne naturelle au Nord (`D07P11A` `ref_04.png` + `D06P01` Mt. Thunder 1x) avec grotte centrale,
     marches rocheuses et deux alcôves de cascades Metano Town (64 px de large).
   - Clairière lumineuse style Tiny Woods / Sky Peak Prairie (`Metano_Town_Base.tile` + `skypeak_decoupe_x2[::2,::2]`)
     bordée à l'Ouest et à l'Est par les vrais arbres feuillus ronds 1x (`Metano_Town_Objects.tile` / Apple Woods),
     buissons et rochers moussus (troncs au sol + couronnes exportées dans `bruts/canopee_arbres_top.png`).
   - Rivière sinueuse style Metano Town (`#FF00FF` dans le brut, berges de terre & herbe Metano Town)
     franchie au centre Sud->Nord par le vrai pont en rondins de bois de Metano Town.

2. `assemble_sommet_mont_thunder_cyclone(mode, map_dir, asset_name)` :
   - Plateau rocheux naturel 1x *Mt. Thunder Summit* (`source/references_54d3731/thunder.png` + `D06P01` 1x)
     centré dans la fenêtre 768x576 au cœur de l'œil du cyclone cylindrique 360° (`> 68 %` `#FF00FF`),
     prolongé au Sud par une étroite arête rocheuse et un escalier taillé jusqu'à `y = 575`.
"""
from __future__ import annotations

import math
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

from source.moteur_cyclones_cylindriques_unova import (
    BAYER_4X4,
    H,
    REPO_ROOT,
    W,
    decode_pmdo_tile,
    sanitize_rgba_binary,
)

MAGENTA = np.array([255, 0, 255], dtype=np.uint8)


def _remap_rock_palette_1x(rgb: np.ndarray, mode: str) -> np.ndarray:
    """Re-harmonise fidèlement la luminance 1x d'une paroi rocheuse Chunsoft sans aucun flou."""
    r = rgb[:, :, 0].astype(np.float32)
    g = rgb[:, :, 1].astype(np.float32)
    b = rgb[:, :, 2].astype(np.float32)
    lum = 0.299 * r + 0.587 * g + 0.114 * b  # [0..255]

    if mode == "zekrom_electric":
        # Granit d'orage gris-ardoisé / basalte bleuté (inspiré D11P11A / V38P07A)
        knots_l = np.array([0.0, 42.0, 78.0, 118.0, 158.0, 198.0, 238.0, 255.0], dtype=np.float32)
        ramp = np.array(
            [
                [10, 14, 22],
                [24, 32, 46],
                [46, 58, 76],
                [74, 90, 112],
                [106, 124, 146],
                [142, 160, 180],
                [182, 198, 214],
                [214, 226, 238],
            ],
            dtype=np.float32,
        )
    elif mode == "reshiram_white_flame":
        # Grès solaire ivoire-doré / ocre chaud sacré (inspiré D07P11A / D06P01 / D09P01)
        knots_l = np.array([0.0, 42.0, 78.0, 118.0, 158.0, 198.0, 238.0, 255.0], dtype=np.float32)
        ramp = np.array(
            [
                [28, 18, 14],
                [64, 42, 28],
                [108, 74, 46],
                [154, 112, 68],
                [196, 154, 98],
                [228, 194, 138],
                [246, 226, 182],
                [254, 244, 216],
            ],
            dtype=np.float32,
        )
    else:
        raise ValueError(mode)

    out = np.zeros_like(rgb, dtype=np.uint8)
    for c in range(3):
        out[:, :, c] = np.clip(np.rint(np.interp(lum, knots_l, ramp[:, c])), 0, 255).astype(np.uint8)
    return out


def _remap_summit_plateau_1x(rgb: np.ndarray, is_floor: np.ndarray, mode: str) -> np.ndarray:
    """Harmonise à l'échelle 1x le plateau et les falaises de Mt. Thunder Summit (`thunder.png`)."""
    r = rgb[:, :, 0].astype(np.float32)
    g = rgb[:, :, 1].astype(np.float32)
    b = rgb[:, :, 2].astype(np.float32)
    lum = 0.299 * r + 0.587 * g + 0.114 * b

    out = np.zeros_like(rgb, dtype=np.uint8)
    cliff_rgb = _remap_rock_palette_1x(rgb, mode)
    out[:] = cliff_rgb

    if mode == "zekrom_electric":
        # Sol du plateau Mt. Thunder Summit : grès pâle minéral contrastant avec les falaises d'orage
        knots_f = np.array([0.0, 90.0, 145.0, 185.0, 215.0, 236.0, 255.0], dtype=np.float32)
        ramp_f = np.array(
            [
                [34, 44, 62],
                [76, 92, 114],
                [124, 140, 158],
                [166, 178, 184],
                [198, 204, 192],
                [218, 220, 196],
                [236, 238, 216],
            ],
            dtype=np.float32,
        )
    else:
        # Sol du plateau Reshiram : pierre solaire ivoire-albâtre chaude style Mt. Thunder / Mt. Blaze
        knots_f = np.array([0.0, 90.0, 145.0, 185.0, 215.0, 236.0, 255.0], dtype=np.float32)
        ramp_f = np.array(
            [
                [68, 44, 28],
                [122, 86, 54],
                [172, 134, 88],
                [210, 178, 126],
                [234, 210, 162],
                [246, 230, 190],
                [254, 246, 220],
            ],
            dtype=np.float32,
        )

    floor_mapped = np.zeros_like(rgb, dtype=np.uint8)
    for c in range(3):
        floor_mapped[:, :, c] = np.clip(np.rint(np.interp(lum, knots_f, ramp_f[:, c])), 0, 255).astype(
            np.uint8
        )
    out[is_floor] = floor_mapped[is_floor]
    return out


def _paste_rgba(dst_rgb: np.ndarray, dst_mask: np.ndarray | None, spr_rgba: np.ndarray, x0: int, y0: int) -> None:
    """Colle un sprite RGBA binaire dans `dst_rgb` (et marque `dst_mask` si fourni)."""
    sh, sw = spr_rgba.shape[:2]
    x_lo, y_lo = max(0, x0), max(0, y0)
    x_hi, y_hi = min(W, x0 + sw), min(H, y0 + sh)
    if x_lo >= x_hi or y_lo >= y_hi:
        return
    sub = spr_rgba[y_lo - y0 : y_hi - y0, x_lo - x0 : x_hi - x0]
    m = sub[:, :, 3] >= 128
    dst_sub = dst_rgb[y_lo:y_hi, x_lo:x_hi]
    dst_sub[m] = sub[m, :3]
    if dst_mask is not None:
        dst_mask[y_lo:y_hi, x_lo:x_hi][m] = True


# ============================================================================
# 1. ASSEMBLEUR ENTRÉE : MONTAGNE + CLAIRIÈRE TINY WOODS / SKY PEAK + RIVIÈRE METANO
# ============================================================================


def assemble_entree_montagne_clairiere_metano(
    mode: str,
    map_dir: Path,
    asset_name: str,
) -> dict[str, Path]:
    """Construit `bruts/base_<asset_name>.png`, `bruts/canopee_arbres_top.png`
    et `references/ref_canon_<asset_name>.png` en 1x natif Chunsoft / Halcyon."""
    bruts_dir = map_dir / "bruts"
    refs_dir = map_dir / "references"
    bruts_dir.mkdir(parents=True, exist_ok=True)
    refs_dir.mkdir(parents=True, exist_ok=True)

    # --- Chargement des planches natives 1x ---
    metano_base = np.array(
        decode_pmdo_tile(REPO_ROOT / "source" / "falaises_metano" / "natifs" / "Metano_Town_Base.tile")
    )
    metano_obj = np.array(
        decode_pmdo_tile(REPO_ROOT / "source" / "amp_plains_fleurie_v1" / "references" / "Metano_Town_Objects.tile")
    )
    skypeak_1x = np.array(
        Image.open(REPO_ROOT / "source" / "zone_zero_v2" / "reference" / "skypeak_decoupe_x2.png").convert("RGB")
    )[::2, ::2]
    r04 = np.array(
        Image.open(REPO_ROOT / "source" / "zones_pmd_20_v1" / "references" / "ref_04.png").convert("RGB")
    )
    d06 = np.array(
        Image.open(
            REPO_ROOT / "source" / "mont_foudre_entree_v1" / "references" / "d06p01_mt_thunder_native.png"
        ).convert("RGB")
    )

    canvas = np.zeros((H, W, 3), dtype=np.uint8)

    # 1. Sol de prairie 1x Metano Town + touffes d'herbe Sky Peak Prairie sur y = 224..576
    grass_tile = metano_base[104:200, 104:200, :3]  # 96x96 herbe pure 1x Metano
    th_g, tw_g = grass_tile.shape[:2]
    for y in range(216, H, th_g):
        for x in range(0, W, tw_g):
            uh, uw = min(th_g, H - y), min(tw_g, W - x)
            canvas[y : y + uh, x : x + uw] = grass_tile[:uh, :uw]

    # Enrichir la clairière avec de vraies touffes d'herbe 1x de Sky Peak Prairie (x=26..44, y=6..24 en 1x)
    sk_tuft = skypeak_1x[6:22, 26:44].copy()
    # Harmoniser le fond de la touffe sur le vert lumineux de Metano/Sky Peak
    tuft_dark = sk_tuft[:, :, 1].astype(np.int16) < 215
    rng = np.random.default_rng(101 if mode == "zekrom_electric" else 202)
    for ty in range(272, 556, 36):
        for tx in range(72, 696, 48):
            jx = int(tx + rng.integers(-10, 11))
            jy = int(ty + rng.integers(-8, 9))
            if abs(jx - 384) < 52:
                continue  # Laisser le sentier central libre
            if 0 <= jx < W - 18 and 264 <= jy < H - 16:
                dst = canvas[jy : jy + 16, jx : jx + 18]
                # Décaler légèrement la teinte de la touffe vers le vert Metano pour fusion 1x parfaite
                blended = np.clip(
                    sk_tuft.astype(np.int16) + np.array([28, -14, -8], dtype=np.int16), 0, 255
                ).astype(np.uint8)
                dst[tuft_dark] = blended[tuft_dark]

    # 2. Sentier de terre battue 1x Metano Town du Sud (x=384, y=575) vers la grotte Nord (y=248)
    sand_tile = metano_base[760:792, 208:240, :3]  # 32x32 sable de chemin 1x Metano
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    bayer = BAYER_4X4[np.arange(H)[:, None] % 4, np.arange(W)[None, :] % 4]

    # Légère ondulation naturelle du chemin en clairière, centré à x=384 sur le pont et l'entrée !
    path_cx = 384.0 + 10.0 * np.sin((yy - 388.0) * math.pi / 188.0) * np.clip((yy - 416.0) / 80.0, 0.0, 1.0)
    path_half_w = 27.0 + 3.0 * np.cos(0.07 * yy)
    dist_path = np.abs(xx - path_cx) - path_half_w
    in_path = (yy >= 236) & (dist_path <= 0.0)
    in_path_fringe = (yy >= 236) & (dist_path > 0.0) & (dist_path <= 5.0) & ((bayer + 0.5 - dist_path / 5.5) > 0.0)

    tiled_sand = np.tile(sand_tile, (H // 32 + 1, W // 32 + 1, 1))[:H, :W]
    canvas[in_path] = tiled_sand[in_path]
    # Lisière herbe-sable dentelée style Metano Town
    fringe_col = np.array([216, 198, 114], dtype=np.uint8)
    canvas[in_path_fringe] = fringe_col

    # Petits cailloux décoratifs de sentier (sans gêner la marche)
    for py_p in (296, 332, 452, 498, 542):
        px_p = int(384 + (12 if (py_p // 30) % 2 == 0 else -14))
        canvas[py_p : py_p + 3, px_p : px_p + 4] = (188, 158, 96)
        canvas[py_p, px_p + 1 : px_p + 3] = (232, 208, 148)

    # 3. Paroi montagneuse naturelle 1x au Nord (y = crest..264) avec UNE SEULE grotte centrale à x=384 !
    # Construite 100 % à partir des terrasses rocheuses 1x homogènes de `ref_04.png` (D07P11A)
    # pour éviter toute couture horizontale ou seconde grotte parasite !
    mtn_raw = np.zeros((280, W, 3), dtype=np.uint8)
    mtn_valid = np.zeros((280, W), dtype=bool)

    # Extraire une bande verticale de pure roche étagée sans ciel ni grotte depuis ref_04 (x=412..550, y=8..168)
    pure_cliff_strip = r04[8:168, 412:548]  # 160 x 136 px de pure paroi rocheuse Chunsoft 1x !
    strip_h, strip_w = pure_cliff_strip.shape[:2]

    for x_dst in range(W):
        d_center = abs(x_dst - 384.0)
        y_crest = int(
            round(
                56.0
                + 48.0 * (1.0 - math.exp(-(d_center / 195.0) ** 2))
                + 7.0 * math.sin(0.042 * x_dst)
                + 4.0 * math.cos(0.105 * x_dst)
            )
        )
        y_crest = max(48, min(124, y_crest))

        # Remplir de `y_crest` à `y=260` avec la paroi rocheuse 1x homogène `pure_cliff_strip`
        sx_strip = (x_dst + 37) % strip_w
        if x_dst < 300:
            sx_strip = (strip_w - 1) - (x_dst % strip_w)
        for y_dst in range(y_crest, 260):
            sy_strip = (y_dst - y_crest) % strip_h
            mtn_raw[y_dst, x_dst] = pure_cliff_strip[sy_strip, sx_strip]
            mtn_valid[y_dst, x_dst] = True

    # Greffer au centre (x_dst = 256..532, y_dst = 84..256) la vraie grotte centrale + escaliers de ref_04
    # avec fondu dentelé pixel-art sur les bords latéraux et supérieurs (zéro couture droite !)
    for x_dst in range(248, 536):
        x_src = x_dst - 19  # Centre la grotte x_src=365 exactement sur x_dst=384 !
        if not (0 <= x_src < r04.shape[1]):
            continue
        col_rgb = r04[0:172, x_src]
        cr = col_rgb[:, 0].astype(np.int16)
        cb = col_rgb[:, 2].astype(np.int16)
        is_rock = (cr > cb + 8) | ((cr < 60) & (cb < 55))

        # Fondu crénelé organique sur les bords gauche (248..284), droit (500..536) et haut (84..108)
        edge_d = min(x_dst - 248, 535 - x_dst)
        for sy in range(172):
            y_dst = 84 + sy
            if not is_rock[sy] or not mtn_valid[y_dst, x_dst]:
                continue
            top_d = sy
            jagger = int(6 * math.sin(0.23 * y_dst + 0.17 * x_dst))
            if (edge_d + jagger >= 14) and (top_d + jagger >= 12):
                mtn_raw[y_dst, x_dst] = col_rgb[sy]

    # Harmoniser la palette 1x de la montagne selon Zekrom (granit d'orage) ou Reshiram (grès solaire ivoire)
    mtn_colored = _remap_rock_palette_1x(mtn_raw, mode)

    # Préserver le noir profond de l'embouchure de grotte centrale (x = 366..402, y = 98..194)
    cave_mask = (
        (mtn_raw[:, :, 0] <= 52)
        & (mtn_raw[:, :, 1] <= 44)
        & (mtn_raw[:, :, 2] <= 36)
        & (np.abs(np.arange(W)[None, :] - 384) <= 24)
        & (np.arange(280)[:, None] >= 94)
        & (np.arange(280)[:, None] <= 198)
    )
    if mode == "zekrom_electric":
        mtn_colored[cave_mask] = (8, 12, 22)
    else:
        mtn_colored[cave_mask] = (20, 12, 10)

    # Souligner d'un trait sombre 1 px la ligne de crête contre le ciel #FF00FF (finition Chunsoft nette)
    crest_outline = mtn_valid & (~ndimage.binary_erosion(mtn_valid, iterations=1))
    crest_top_only = crest_outline & (np.arange(280)[:, None] < 160)
    mtn_colored[crest_top_only] = (16, 20, 30) if mode == "zekrom_electric" else (48, 30, 20)

    # Pied irrégulier de la montagne sur la clairière (y = 244..262, sauf devant les marches x=350..418)
    for x_dst in range(W):
        if 348 <= x_dst <= 420:
            y_foot = 246  # Marches rocheuses qui rejoignent directement le sentier !
        else:
            y_foot = int(round(252 + 5.0 * math.sin(0.06 * x_dst) + 3.0 * math.cos(0.15 * x_dst)))
        mtn_valid[y_foot:, x_dst] = False

    # Coller la montagne et le ciel #FF00FF sur le canevas
    sky_mask = np.zeros((H, W), dtype=bool)
    for y_dst in range(264):
        rock_row = mtn_valid[y_dst]
        canvas[y_dst, rock_row] = mtn_colored[y_dst, rock_row]
        # Tout pixel au Nord de la paroi rocheuse est du ciel #FF00FF !
        if y_dst < 160:
            sky_row = ~rock_row
            canvas[y_dst, sky_row] = MAGENTA
            sky_mask[y_dst, sky_row] = True

    # 4. Rivière sinueuse style Metano Town (`#FF00FF` dans le brut) + Berges terre/herbe Metano Town !
    # Deux bras alimentés par les cascades de montagne (x=128..192 et x=576..640, y=184..280) se rejoignent
    # en une rivière traversant toute la clairière d'Ouest en Est autour de y = 382 (sous le pont !)
    cascade_origins = [(128, 184), (576, 184)]  # Largeur exacte 64 px chacune !

    # Rivière principale Ouest -> Est traversant de x=0 à x=768 (centrée à y=382 en x=384)
    main_river_y = (
        404.0
        - 22.0 * np.cos((xx - 384.0) * math.pi / 260.0)
        + 6.0 * np.sin(0.022 * xx)
    )
    in_main_river = np.abs(yy - main_river_y) <= 23.0

    # Affluent Ouest : s'évase exactement à 32 px de demi-largeur en y=276 pour épouser la cascade 64 px sans décroché !
    t_w = np.clip((yy - 276.0) / 132.0, 0.0, 1.0)
    trib_w_x = 160.0 + 16.0 * np.sin(t_w * math.pi)
    trib_w_hw = 32.0 * (1.0 - t_w) + 24.0 * t_w
    in_trib_w = (yy >= 274) & (yy <= 416) & (np.abs(xx - trib_w_x) <= trib_w_hw)

    # Affluent Est : s'évase exactement à 32 px de demi-largeur en y=276
    trib_e_x = 608.0 - 16.0 * np.sin(t_w * math.pi)
    in_trib_e = (yy >= 274) & (yy <= 416) & (np.abs(xx - trib_e_x) <= trib_w_hw)

    # Alcôves des 2 cascades dans la roche (64 x 96 px aux origines (128, 184) et (576, 184))
    # Ombrage rocheux irrégulier directement taillé dans le grain 1x de la paroi (zéro cadre rectangulaire !)
    in_casc_alcoves = np.zeros((H, W), dtype=bool)
    for cx0, cy0 in cascade_origins:
        for ry in range(cy0 - 6, cy0 + 70):
            j_l = 2 + int(round(1.8 * math.sin(0.27 * ry)))
            j_r = 2 + int(round(1.8 * math.cos(0.25 * ry)))
            if ry < cy0:
                for rx in range(cx0 - j_l, cx0 + 64 + j_r):
                    arch = int(round(3.0 * math.sin(max(0.0, min(1.0, (rx - cx0) / 64.0)) * math.pi)))
                    if ry >= cy0 - 2 - arch:
                        canvas[ry, rx] = (canvas[ry, rx].astype(np.float32) * 0.52).astype(np.uint8)
            else:
                for rx in range(cx0 - j_l, cx0):
                    canvas[ry, rx] = (canvas[ry, rx].astype(np.float32) * 0.55).astype(np.uint8)
                for rx in range(cx0 + 64, cx0 + 64 + j_r):
                    canvas[ry, rx] = (canvas[ry, rx].astype(np.float32) * 0.55).astype(np.uint8)
        in_casc_alcoves[cy0 : cy0 + 96, cx0 : cx0 + 64] = True

    water_mask = in_main_river | in_trib_w | in_trib_e | in_casc_alcoves

    # Dessiner les vraies berges de terre brune & liseré d'herbe style Metano Town autour de l'eau (y >= 256)
    bank_outer = ndimage.binary_dilation(water_mask, iterations=4) & (~water_mask) & (yy >= 256)
    bank_inner = ndimage.binary_dilation(water_mask, iterations=2) & (~water_mask) & (yy >= 256)
    north_expose = ndimage.shift(water_mask, (-3, 0), order=0, cval=False) & (~water_mask) & (yy >= 256)
    canvas[bank_outer] = (148, 182, 64)
    canvas[bank_inner] = (132, 92, 54)
    canvas[north_expose] = (164, 114, 66)

    # Remplir le lit de la rivière en #FF00FF pur !
    canvas[water_mask] = MAGENTA

    # 5. Pont en rondins de bois authentique 1x de Metano Town au centre (x = 352..416, y = 348..414) !
    # On découpe y=1046..1112 (66 px de rondins purs, sans les pixels de sable parasites de y=1032..1045 !)
    bridge_raw = metano_obj[1046:1112, 632:680].copy()  # 48 x 66 px (planches horizontales pures !)
    bridge_64 = np.zeros((66, 64, 4), dtype=np.uint8)
    bridge_64[:, 0:24] = bridge_raw[:, 0:24]
    bridge_64[:, 24:40] = bridge_raw[:, 16:32]
    bridge_64[:, 40:64] = bridge_raw[:, 24:48]
    bridge_64 = sanitize_rgba_binary(bridge_64)

    bridge_mask = np.zeros((H, W), dtype=bool)
    _paste_rgba(canvas, bridge_mask, bridge_64, 352, 349)

    # 6. Arbres feuillus ronds 1x style Tiny Woods / Metano + buissons + rochers moussus !
    def _clean_largest_component(rgba_crop: np.ndarray) -> np.ndarray:
        c = sanitize_rgba_binary(rgba_crop)
        lbl, num = ndimage.label(c[:, :, 3] > 0)
        if num > 1:
            cnt = np.bincount(lbl.ravel())
            cnt[0] = 0
            keep = lbl == cnt.argmax()
            c[~keep] = 0
        return c

    tree_a = _clean_largest_component(metano_obj[714:784, 113:191].copy())  # 78 x 70 arbre rond 1x pur
    tree_b = _clean_largest_component(metano_obj[700:768, 273:351].copy())  # 78 x 68 variante 1x pure
    bush_spr = _clean_largest_component(metano_obj[1072:1104, 360:392].copy())  # 32 x 32 buisson rond 1x
    rock_spr = _clean_largest_component(metano_obj[1240:1271, 368:400].copy())  # 32 x 31 rocher chaud 1x

    # Planter la lisière forestière Tiny Woods à l'Ouest et à l'Est de la clairière (sans toucher l'eau !)
    forbidden_trees = (
        ndimage.binary_dilation(water_mask, iterations=6)
        | ndimage.binary_dilation(in_path | bridge_mask, iterations=10)
        | (yy < 248)
    )

    tree_sites = [
        # Bosquet Nord-Ouest & Nord-Est (entre la montagne et la rivière)
        (8, 224, 0),
        (52, 258, 1),
        (638, 224, 1),
        (684, 258, 0),
        # Forêt Tiny Woods Sud-Ouest (encadrant la clairière Sud)
        (-12, 412, 0),
        (56, 428, 1),
        (4, 476, 1),
        (78, 492, 0),
        (146, 514, 1),
        (-6, 524, 0),
        # Forêt Tiny Woods Sud-Est (encadrant la clairière Sud)
        (696, 412, 1),
        (630, 428, 0),
        (682, 476, 0),
        (608, 492, 1),
        (542, 514, 0),
        (692, 524, 1),
    ]

    canopy_top_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    for tx, ty, tvar in tree_sites:
        spr = tree_a if tvar == 0 else tree_b
        sh, sw = spr.shape[:2]
        # Vérifier que le pied/tronc (bas 24 px) ne tombe pas dans la rivière
        foot_y0, foot_y1 = max(0, ty + sh - 22), min(H, ty + sh)
        foot_x0, foot_x1 = max(0, tx + 18), min(W, tx + sw - 18)
        if foot_y0 < foot_y1 and foot_x0 < foot_x1:
            if np.any(water_mask[foot_y0:foot_y1, foot_x0:foot_x1]):
                continue
        _paste_rgba(canvas, None, spr, tx, ty)
        # Sauvegarder la couronne supérieure feuillue (haut 46 px de l'arbre) pour le calque `Top` !
        crown = spr.copy()
        crown[46:, :, :] = 0
        x_lo, y_lo = max(0, tx), max(0, ty)
        x_hi, y_hi = min(W, tx + sw), min(H, ty + sh)
        if x_lo < x_hi and y_lo < y_hi:
            sub_c = crown[y_lo - ty : y_hi - ty, x_lo - tx : x_hi - tx]
            mc = sub_c[:, :, 3] >= 128
            canopy_top_rgba[y_lo:y_hi, x_lo:x_hi][mc] = sub_c[mc]

    # Buissons ronds & petits rochers moussus de clairière Tiny Woods / Sky Peak
    decor_props = [
        (228, 286, "bush"),
        (506, 288, "bush"),
        (258, 314, "rock"),
        (478, 312, "rock"),
        (172, 444, "bush"),
        (564, 446, "bush"),
        (224, 522, "rock"),
        (512, 520, "rock"),
        (286, 468, "bush"),
        (450, 470, "bush"),
    ]
    for px0, py0, kind in decor_props:
        spr = bush_spr if kind == "bush" else rock_spr
        sh, sw = spr.shape[:2]
        if not np.any(forbidden_trees[py0 : py0 + sh, px0 : px0 + sw]):
            _paste_rgba(canvas, None, spr, px0, py0)

    # S'assurer qu'aucun arbre/objet n'a mordu sur le lit #FF00FF de la rivière (hors pont !) ou du ciel
    canvas[water_mask & (~bridge_mask)] = MAGENTA
    canvas[sky_mask] = MAGENTA

    # Purger tout pixel non-#FF00FF qui serait trop proche du magenta (sécurité 100 % binaire)
    non_mag = ~((canvas[:, :, 0] == 255) & (canvas[:, :, 1] == 0) & (canvas[:, :, 2] == 255))
    rgba_check = np.zeros((H, W, 4), dtype=np.uint8)
    rgba_check[:, :, :3] = canvas
    rgba_check[:, :, 3] = 255
    sanitized = sanitize_rgba_binary(rgba_check)[:, :, :3]
    canvas[non_mag] = sanitized[non_mag]

    brut_path = bruts_dir / f"base_{asset_name}.png"
    canopy_path = bruts_dir / "canopee_arbres_top.png"
    Image.fromarray(canvas, mode="RGB").save(brut_path)
    Image.fromarray(sanitize_rgba_binary(canopy_top_rgba), mode="RGBA").save(canopy_path)

    # Construire la planche de référence canonique 1x (Montagne recolorée 1x + Prairie Sky Peak / Metano)
    ref_canon = np.zeros((256, 512, 3), dtype=np.uint8)
    ref_canon[:, :256] = mtn_colored[84:256, 128:384][:256, :256] if 256 - 84 >= 256 else np.resize(
        mtn_colored[96:248, 160:416], (256, 256, 3)
    )
    # Moitié gauche : paroi montagneuse 1x ; moitié droite : herbe + chemin + pont + arbres Metano/Sky Peak 1x
    ref_canon[:160, :256] = mtn_colored[90:250, 200:456]
    ref_canon[160:, :256] = mtn_colored[120:216, 256:512]
    ref_canon[:, 256:] = canvas[300:556, 256:512]
    # Remplacer le #FF00FF de la rivière dans la référence canonique par le turquoise Metano natif !
    ref_mag = (ref_canon[:, :, 0] == 255) & (ref_canon[:, :, 1] == 0) & (ref_canon[:, :, 2] == 255)
    ref_canon[ref_mag] = (124, 218, 232)
    ref_path = refs_dir / f"ref_canon_{asset_name}.png"
    Image.fromarray(ref_canon, mode="RGB").save(ref_path)

    return {"brut": brut_path, "canopy": canopy_path, "ref_canon": ref_path}


# ============================================================================
# 2. ASSEMBLEUR SOMMET : MT. THUNDER SUMMIT AU CŒUR DU CYCLONE CYLINDRIQUE 360°
# ============================================================================


def assemble_sommet_mont_thunder_cyclone(
    mode: str,
    map_dir: Path,
    asset_name: str,
) -> dict[str, Path]:
    """Construit `bruts/base_<asset_name>.png` et `references/ref_canon_<asset_name>.png`
    en centrant le vrai sommet 1x *Mt. Thunder Summit* (`thunder.png` + `D06P01`) dans `#FF00FF`."""
    bruts_dir = map_dir / "bruts"
    refs_dir = map_dir / "references"
    bruts_dir.mkdir(parents=True, exist_ok=True)
    refs_dir.mkdir(parents=True, exist_ok=True)

    th = np.array(
        Image.open(REPO_ROOT / "source" / "references_54d3731" / "thunder.png").convert("RGB")
    )  # (355, 432, 3) 1x natif GBA Mt. Thunder Peak !
    d06 = np.array(
        Image.open(
            REPO_ROOT / "source" / "mont_foudre_entree_v1" / "references" / "d06p01_mt_thunder_native.png"
        ).convert("RGB")
    )

    # 1. Séparation mathématique exacte entre le rocher/plateau de Mt. Thunder Summit et les nuages gris GBA :
    # Dans `thunder.png`, tous les nuages ont R == B (gris neutres), alors que tout le rocher/sable a R > B + 12 !
    tr, tg, tb = th[:, :, 0].astype(np.int16), th[:, :, 1].astype(np.int16), th[:, :, 2].astype(np.int16)
    raw_rock = ((tr - tb) > 12) | ((tg - tb) > 12)
    # Ne garder que la composante connexe principale (l'île-sommet de Mt. Thunder Peak)
    lab, _ = ndimage.label(raw_rock)
    counts = np.bincount(lab.ravel())
    counts[0] = 0
    island_src_mask = ndimage.binary_fill_holes(lab == counts.argmax())

    # Pour Reshiram, légère variation naturelle (miroir horizontal doux des pitons périphériques)
    # afin que les deux sommets soient de vrais jumeaux naturels et non un copié-collé identique !
    th_work = th[:, ::-1, :].copy() if mode == "reshiram_white_flame" else th.copy()
    mask_work = island_src_mask[:, ::-1].copy() if mode == "reshiram_white_flame" else island_src_mask.copy()

    # Identifier dans `th_work` le plateau supérieur plat sablo-rocheux vs les falaises escarpées latérales
    wr = th_work[:, :, 0].astype(np.int16)
    wg = th_work[:, :, 1].astype(np.int16)
    wb = th_work[:, :, 2].astype(np.int16)
    is_floor_src = mask_work & (wr >= 200) & (wg >= 188) & ((wr - wb) >= 36)
    is_floor_src = ndimage.binary_closing(is_floor_src, iterations=2) & mask_work

    # Appliquer la palette 1x Chunsoft fidèle (Zekrom : Mt. Thunder d'orage ; Reshiram : Mt. Thunder/Blaze solaire)
    th_colored = _remap_summit_plateau_1x(th_work, is_floor_src, mode)
    d06_cliff_colored = _remap_rock_palette_1x(d06, mode)

    # 2. Placement centré dans 768 x 576 au cœur de l'œil du cyclone cylindrique !
    # `thunder.png` fait 432 x 355 ; placé en (x0=168, y0=108), le sommet couvre x ≈ 226..542, y ≈ 168..420 !
    canvas = np.broadcast_to(MAGENTA, (H, W, 3)).copy()
    solid_mask = np.zeros((H, W), dtype=bool)
    floor_mask = np.zeros((H, W), dtype=bool)

    x0, y0 = 168, 108
    sh, sw = th_colored.shape[:2]

    # Tailler une bordure inférieure rocheuse arrondie/escarpée naturelle au lieu de la découpe de nuage blanc
    # du bas de `thunder.png`, puis prolonger par une vraie jupe de falaise verticale 1x Mt. Thunder (D06P01) !
    for sy in range(sh):
        dy_dst = y0 + sy
        if dy_dst >= H:
            break
        for sx in range(sw):
            if not mask_work[sy, sx]:
                continue
            dx_dst = x0 + sx
            # Courbe de rebord Sud du plateau autour de (cx=384, cy=278)
            rel_x = (dx_dst - 384.0) / 156.0
            max_plat_y = int(round(376.0 - 46.0 * (rel_x * rel_x) + 5.0 * math.sin(0.09 * dx_dst)))
            if dy_dst <= max_plat_y:
                canvas[dy_dst, dx_dst] = th_colored[sy, sx]
                solid_mask[dy_dst, dx_dst] = True
                if is_floor_src[sy, sx] and dy_dst <= max_plat_y - 6:
                    floor_mask[dy_dst, dx_dst] = True

    # 3. Sculpter la jupe de falaise rocheuse verticale 1x (D06P01 hors grotte x=12..152) sous le plateau !
    # Combler d'abord tout micro-trou interne éventuel du masque du plateau
    solid_mask = ndimage.binary_fill_holes(solid_mask)
    for y_fill in range(H):
        for x_fill in range(W):
            if solid_mask[y_fill, x_fill] and (
                canvas[y_fill, x_fill, 0] == 255
                and canvas[y_fill, x_fill, 1] == 0
                and canvas[y_fill, x_fill, 2] == 255
            ):
                canvas[y_fill, x_fill] = d06_cliff_colored[40 + (y_fill % 64), 24 + (x_fill % 112)]

    plat_cols = np.where(solid_mask.any(axis=0))[0]
    for x_col in plat_cols:
        ys_col = np.where(solid_mask[:, x_col])[0]
        y_bot = int(ys_col.max())
        rel_x = abs(x_col - 384.0) / 160.0
        skirt_h = int(round(62.0 * (1.0 - 0.32 * rel_x * rel_x) + 7.0 * math.cos(0.11 * x_col)))
        skirt_h = max(30, skirt_h)
        # Utiliser exclusivement les colonnes x=12..152 de D06P01 (pure paroi rocheuse, jamais la grotte x=204 !)
        d06_x = 12 + ((x_col * 3) % 140)
        for k_y in range(1, skirt_h + 1):
            yy_k = y_bot + k_y
            if yy_k >= H:
                break
            d06_y = 18 + (k_y % 96)
            pix = d06_cliff_colored[d06_y, d06_x].copy()
            if k_y > skirt_h - 6:
                pix = (pix.astype(np.int16) * 55 // 100).astype(np.uint8)
            canvas[yy_k, x_col] = pix
            solid_mask[yy_k, x_col] = True

    # 4. Éperon rocheux Sud + Escalier naturel taillé dans la montagne de y = 364 jusqu'au bord Sud y = 575 !
    sample_floor = canvas[280, 384].copy()
    for yy_b in range(364, H):
        # Éperon rocheux robuste s'évasant naturellement à la jonction Nord (y=364..420) et au pied Sud
        flare_north = 18.0 * math.exp(-max(0.0, yy_b - 364.0) / 26.0)
        flare_south = 12.0 * max(0.0, (yy_b - 485.0) / 90.0)
        jagged = 4.0 * math.sin(0.09 * yy_b) + 2.5 * math.cos(0.21 * yy_b)
        half_ridge = int(round(48.0 + flare_north + flare_south + jagged))
        x_lo, x_hi = 384 - half_ridge, 384 + half_ridge
        stair_lo, stair_hi = 356, 412  # Largeur constante 56 px (7 tuiles) de l'escalier central !
        for xx_b in range(x_lo, x_hi):
            dist_edge = min(xx_b - x_lo, x_hi - 1 - xx_b)
            if xx_b < stair_lo or xx_b >= stair_hi:
                # Escarpements rocheux latéraux sculptés (grain 1x D06P01 hors grotte)
                d06_x = 16 + ((xx_b * 3 + (yy_b // 24) * 7) % 136)
                d06_y = 20 + (yy_b % 92)
                pix = d06_cliff_colored[d06_y, d06_x].copy()
                if dist_edge < 3:
                    pix = (pix.astype(np.int16) * 52 // 100).astype(np.uint8)
                canvas[yy_b, xx_b] = pix
            else:
                step_mod = (yy_b - 376) % 12
                if 396 <= yy_b <= 566 and step_mod in (0, 1):
                    pix = np.clip(sample_floor.astype(np.int16) + 16, 0, 255).astype(np.uint8)
                elif 396 <= yy_b <= 566 and step_mod in (10, 11):
                    pix = np.clip(sample_floor.astype(np.int16) - 46, 0, 255).astype(np.uint8)
                else:
                    src_y = 180 + (yy_b % 48)
                    src_x = 196 + ((xx_b - 356) % 48)
                    pix = th_colored[src_y, src_x].copy()
                canvas[yy_b, xx_b] = pix
            solid_mask[yy_b, xx_b] = True

    # Fermer toute micro-encoche de 1..2 px entre le bord du plateau et la jupe verticale
    closed_mask = ndimage.binary_fill_holes(ndimage.binary_closing(solid_mask, iterations=2))
    added_px = closed_mask & (~solid_mask)
    if np.any(added_px):
        ys_a, xs_a = np.where(added_px)
        for ya, xa in zip(ys_a, xs_a):
            canvas[ya, xa] = d06_cliff_colored[24 + (ya % 80), 20 + (xa % 120)]
        solid_mask = closed_mask

    # Contour extérieur franc 1 px Chunsoft tout autour du sommet contre le #FF00FF
    outer_rim = solid_mask & (~ndimage.binary_erosion(solid_mask, iterations=1))
    rim_dark = np.array([14, 20, 32], dtype=np.uint8) if mode == "zekrom_electric" else np.array([44, 26, 18], dtype=np.uint8)
    # Ne pas barrer le bord tout en bas y=575 pour garder l'entrée Sud ouverte
    outer_rim[-2:, :] = False
    canvas[outer_rim] = rim_dark

    # Sécurité anti-fuite magenta sur tous les pixels solides
    rgba_chk = np.zeros((H, W, 4), dtype=np.uint8)
    rgba_chk[:, :, :3] = canvas
    rgba_chk[:, :, 3] = 255
    sanitized = sanitize_rgba_binary(rgba_chk)[:, :, :3]
    canvas[solid_mask] = sanitized[solid_mask]
    canvas[~solid_mask] = MAGENTA

    brut_path = bruts_dir / f"base_{asset_name}.png"
    Image.fromarray(canvas, mode="RGB").save(brut_path)

    # Planche de référence canonique 1x fidèle aux proportions spatiales 75 % cyclone / 25 % sommet :
    # - Zekrom : collage natif 1x V38P07A (nuées d'orage + lueur électrique cyan) + Mt. Thunder Summit
    # - Reshiram : collage natif 1x H19P01 (cratère ardent GBA) + Mt. Thunder Summit solaire
    ref_canon = np.zeros((256, 256, 3), dtype=np.uint8)
    if mode == "zekrom_electric":
        # Partie active supérieure (hors bande noire basse y>=165) de V38P07A (orage + lueur cyan + pics)
        v38_full = np.array(
            Image.open(
                REPO_ROOT
                / "source"
                / "zekrom_sommet_tornade_v1"
                / "references"
                / "v38p07a_storm_peak_electric_glow_native.png"
            ).convert("RGB")
        )
        v38_active = Image.fromarray(v38_full[:166, :]).resize((256, 208), Image.Resampling.NEAREST)
        ref_canon[:208, :] = np.array(v38_active)
    else:
        # Cœur incandescent actif du cratère natif H19P01 (Sulfura) + plateau solaire Mt. Thunder Summit
        h19_full = np.array(
            Image.open(
                REPO_ROOT / "source" / "mont_brasier_sommet_v1" / "references" / "h19p01_moltres_crater_native.png"
            ).convert("RGB")
        )
        h19_core = Image.fromarray(h19_full[96:224, 148:308]).resize((256, 144), Image.Resampling.NEAREST)
        ref_canon[:144, :] = np.array(h19_core)
        ref_crop_rs = th_colored[120:232, 88:344].copy()
        ref_mask_rs = mask_work[120:232, 88:344]
        ref_canon[144:, :] = d06_cliff_colored[16:128, 32:288]
        ref_canon[144:, :][ref_mask_rs] = ref_crop_rs[ref_mask_rs]
    if mode == "zekrom_electric":
        ref_crop = th_colored[148:196, 88:344].copy()
        ref_crop_mask = mask_work[148:196, 88:344]
        ref_canon[208:, :] = d06_cliff_colored[32:80, 32:288]
        ref_canon[208:, :][ref_crop_mask] = ref_crop[ref_crop_mask]
    ref_path = refs_dir / f"ref_canon_{asset_name}.png"
    Image.fromarray(ref_canon, mode="RGB").save(ref_path)

    return {"brut": brut_path, "ref_canon": ref_path}
