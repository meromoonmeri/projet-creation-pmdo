#!/usr/bin/env python3
"""Prépare un brouillon natif Métano ultra-propre sur fond magenta (#FF00FF)
et une planche de vocabulaire 100 % pur terrain/roche (ZÉRO arbre, ZÉRO bannière,
ZÉRO grotte) pour que la passe spriter `generate_image` sculpte et soude
uniquement les bordures et raccords du plateau nu Grass Métano."""
from __future__ import annotations

import math
import sys
from pathlib import Path
import numpy as np
from PIL import Image
from scipy.ndimage import distance_transform_edt

ROOT = Path(__file__).resolve().parents[2]
NATIFS_ABYSS = ROOT / "source" / "cote_v4_abyss" / "natifs"
WORK = ROOT / "source" / "cliff_nord_centre_v1" / "work"
WORK.mkdir(parents=True, exist_ok=True)

sys.path.insert(0, str(ROOT / "source" / "cliff_nord_centre_v1"))
from build import decode_tile_straight

W, H = 1200, 880


def decode_tile_sheet(path: Path) -> np.ndarray:
    return np.array(decode_tile_straight(path).convert("RGBA"))


def build_draft_and_ref() -> None:
    base_d = decode_tile_sheet(NATIFS_ABYSS / "Metano_Town_Base.tile")
    cliffs_d = decode_tile_sheet(NATIFS_ABYSS / "Metano_Town_Cliffs.tile")

    # 1. Herbe pure Metano_Town_Base sans couture + brins d'herbe subtils natifs
    grass_patch = base_d[640:768, 0:128, :4].copy()
    grass_canvas = np.zeros((H, W, 4), dtype=np.uint8)
    for y in range(0, H, 128):
        for x in range(0, W, 128):
            ph, pw = min(128, H - y), min(128, W - x)
            grass_canvas[y : y + ph, x : x + pw] = grass_patch[:ph, :pw]

    tuft1 = base_d[776:792, 16:32].copy()
    tuft2 = base_d[792:808, 48:64].copy()
    rng = np.random.default_rng(20261021)
    for _ in range(85):
        tx = int(rng.integers(150, W - 166))
        ty = int(rng.integers(360, H - 24))
        t = tuft1 if rng.random() < 0.5 else tuft2
        m = t[..., 3] == 255
        grass_canvas[ty : ty + 16, tx : tx + 16][m] = t[m]

    # 2. Silhouette 3D monotone par colonne X (ZÉRO encoche rentrante = ZÉRO fente magenta sous le rebord !)
    # Le promontoire est centré sur X = 600 :
    # - Ouest : mer libre x = 0..136
    # - Nord  : mer libre horizon y = 296..352, crête panoramique courbée comme cliffdaytest
    # - Est   : mer libre x = 1064..1200
    # - Sud   : large plateau Grass Métano continu jusqu'à y = 880 sur x = 352..848 (496 px),
    #           encadré à gauche (x = 136..352) et à droite (x = 848..1064) par les hautes parois
    #           rocheuses stratifiées Métano qui plongent dans la mer et sortent proprement en y = 880 !
    yy, xx = np.mgrid[:H, :W]
    plateau = np.zeros((H, W), dtype=bool)

    for x in range(136, W - 136):
        u = (x - W / 2.0) / 464.0  # -1 .. +1
        # Bord supérieur Nord courbé avec légères ondulations côtières naturelles
        y_top = (
            352.0
            + 156.0 * (abs(u) ** 2.15)
            + 4.5 * math.sin(x * 0.037 + 0.6)
            + 2.5 * math.sin(x * 0.089 - 1.1)
        )
        # Bord inférieur :
        # - Dans le couloir central Sud |x - 600| <= 248 (x = 352..848), le plateau descend jusqu'en bas (y = 880) !
        # - Sur l'aile Ouest (x = 136..352) et l'aile Est (x = 848..1064), le rebord remonte en courbe douce
        #   de y = 880 vers le nez Ouest / Est (y ≈ 512), laissant pendre en dessous toute la haute paroi rocheuse Métano !
        ax = abs(x - W / 2.0)
        if ax <= 248.0:
            y_bot = float(H)
        else:
            s = (ax - 248.0) / (464.0 - 248.0)  # 0 (à x=352/848) -> 1 (au nez x=136/1064)
            y_bot = (
                H
                - (H - 512.0) * (s ** 0.86)
                + 4.0 * math.sin(x * 0.043 + 1.4)
                + 2.0 * math.sin(x * 0.105)
            )
        yt = max(0, int(round(y_top)))
        yb = min(H, int(round(y_bot)))
        if yb > yt + 6:
            plateau[yt:yb, x] = True

    # 3. Parois rocheuses 100 % roche sèche stratifiée + piliers arrondis rosés de Metano_Town_Cliffs
    # Bande 100 % pierre (SANS aucun pixel vert d'herbe !) : y = 450..544 de Metano_Town_Cliffs
    pure_stone_flat = cliffs_d[450:544, 908:976].copy()    # 94 px haut x 68 px large : assises horizontales ocres/brunes
    pure_stone_pillar = cliffs_d[432:544, 696:744].copy()  # 112 px haut x 48 px large : pilier arrondi rosé/ocre Métano

    for arr_s in (pure_stone_flat, pure_stone_pillar):
        # Remplace tout éventuel pixel verdâtre résiduel en haut de pilier par de la pierre ocre
        greenish = (arr_s[..., 1].astype(int) - arr_s[..., 0].astype(int)) > 4
        arr_s[greenish] = pure_stone_flat[16, 16]
        for r in range(arr_s.shape[0]):
            ox = np.flatnonzero(arr_s[r, :, 3] > 220)
            if len(ox) > 0:
                for c in range(arr_s.shape[1]):
                    if arr_s[r, c, 3] <= 220:
                        arr_s[r, c] = arr_s[r, ox[np.argmin(np.abs(ox - c))]]
        arr_s[..., 3] = 255

    # Construire une frise rocheuse large alternant assises plates et piliers arrondis rosés typiques Métano
    stone_strip = np.concatenate(
        [
            pure_stone_pillar[:94, :],
            pure_stone_flat,
            pure_stone_pillar[:94, :],
            pure_stone_flat,
        ],
        axis=1,
    )  # 94 x 232, 100 % pierre sèche sans herbe !
    SH, SW = stone_strip.shape[:2]

    rock_layer = np.zeros((H, W, 4), dtype=np.uint8)
    for x in range(136, W - 136):
        ys = np.flatnonzero(plateau[:, x])
        if len(ys) == 0:
            continue
        yb = int(ys[-1])
        if yb < H:
            # Piliers arrondis étagés comme Metano_Town_Cliffs, mais SANS assises cisaillées :
            # les strates de pierre restent 100 % horizontales (indexées par y) !
            step_wave = 10.0 * math.sin(x * 0.085) + 5.0 * math.cos(x * 0.17)
            ax = abs(x - W / 2.0)
            t_nose = np.clip((464.0 - ax) / 85.0, 0.0, 1.0)
            wall_h = int(round(28 + (164 + step_wave) * (t_nose ** 0.68)))
            y_start = max(int(ys[0]) + 4, yb - 6)
            y_end = min(H, yb + wall_h)
            if y_end > y_start:
                ys_slice = np.arange(y_start, y_end)
                # Couronne d'ombre en haut sous le rebord + pied foncé en bas + assises horizontales au milieu !
                rel_top = ys_slice - y_start
                rel_bot = y_end - ys_slice
                src_y = 18 + (ys_slice % 48)
                src_y = np.where(rel_top < 14, rel_top, src_y)
                src_y = np.where(rel_bot <= 16, SH - rel_bot, src_y)
                rock_layer[y_start:y_end, x] = stone_strip[np.clip(src_y, 0, SH - 1), x % SW]

    # Aussi sur les bords verticaux gauche/droit près du nez (x ≈ 136..150 et 1050..1064)
    # pour que la tranche latérale du nez ait bien son arrondi rocheux

    # 4. Liseré de falaise doré-ocre dentelé authentique Métano tout autour (Ouest + Nord + Est, ouvert au Sud !)
    OUTLINE_DARK = np.array([104, 72, 40, 255], dtype=np.uint8)
    LIP_SHADOW   = np.array([152, 108, 56, 255], dtype=np.uint8)
    LIP_OCHRE    = np.array([196, 152, 80, 255], dtype=np.uint8)
    LIP_GOLD     = np.array([220, 184, 104, 255], dtype=np.uint8)
    GRASS_SHADE  = np.array([176, 200, 58, 255], dtype=np.uint8)

    # Étendre virtuellement l'isthme Sud sous y=H pour que le bord Sud (x=352..848, y=880) reste 100 % ouvert en herbe !
    padded_plat = np.vstack([plateau, np.tile(plateau[-1:], (24, 1))])
    dist_in = distance_transform_edt(padded_plat)[:H]
    noise = (
        1.7 * np.sin(xx * 0.23 + yy * 0.14)
        + 1.2 * np.sin(xx * 0.51 - yy * 0.31)
        + 0.8 * np.sin(xx * 0.11 + yy * 0.08)
    )
    d_eff = dist_in + noise

    surf = np.zeros((H, W, 4), dtype=np.uint8)
    surf[plateau] = grass_canvas[plateau]
    surf[plateau & (d_eff < 9.5)] = GRASS_SHADE
    surf[plateau & (d_eff < 7.2)] = LIP_GOLD
    surf[plateau & (d_eff < 5.0)] = LIP_OCHRE
    surf[plateau & (d_eff < 2.8)] = LIP_SHADOW
    surf[plateau & (d_eff < 1.5)] = OUTLINE_DARK

    draft = np.full((H, W, 4), [255, 0, 255, 255], dtype=np.uint8)
    mr = rock_layer[..., 3] == 255
    draft[mr] = rock_layer[mr]
    ms = surf[..., 3] == 255
    draft[ms] = surf[ms]
    Image.fromarray(draft).save(WORK / "draft_base_magenta.png")

    # 5. Planche de référence 100 % PURE TERRAIN & ROCHE MÉTANO (ZÉRO arbre, ZÉRO bannière, ZÉRO grotte !)
    ref_board = np.full((880, 1200, 4), [255, 0, 255, 255], dtype=np.uint8)
    # Haut gauche : herbe pure Metano_Town_Base + rebords terreux natifs
    ref_board[32:288, 32:544] = np.tile(grass_patch, (2, 4, 1))
    # Haut droite : zoom x2 des vraies tuiles de rebord herbeux/terreux Metano_Town_Base[832:960, 48:176]
    rim_native = base_d[832:960, 48:176].copy()
    rim_native[rim_native[..., 3] < 200] = [255, 0, 255, 255]
    ref_board[32:288, 592:848] = np.repeat(np.repeat(rim_native, 2, axis=0), 2, axis=1)

    # Bas gauche : parois rocheuses sèches sans entrée de grotte Metano_Town_Cliffs[208:544, 456:800]
    cl_clean = cliffs_d[208:544, 456:800].copy()  # 336 x 344 — ZÉRO porte de grotte !
    mc = cl_clean[..., 3] > 200
    ref_board[340 : 340 + cl_clean.shape[0], 32 : 32 + cl_clean.shape[1]][mc] = cl_clean[mc]

    # Bas milieu : retour Est Metano_Town_Cliffs[304:544, 1296:1512]
    cl_east = cliffs_d[304:544, 1296:1512].copy()
    me = cl_east[..., 3] > 200
    ref_board[400 : 400 + cl_east.shape[0], 416 : 416 + cl_east.shape[1]][me] = cl_east[me]

    # Bas droite : zoom x2 net d'un pilier arrondi rosé + assises horizontales + rebord d'herbe Métano
    zoom_rock = np.repeat(np.repeat(cliffs_d[416:544, 688:840], 2, axis=0), 2, axis=1)  # 256 x 304 — 0 grotte !
    mz = zoom_rock[..., 3] > 200
    ref_board[380 : 380 + 256, 680 : 680 + 304][mz] = zoom_rock[mz]

    Image.fromarray(ref_board).save(WORK / "ref_vocabulaire_metano.png")
    print("OK CLEAN:", WORK / "draft_base_magenta.png", WORK / "ref_vocabulaire_metano.png")


if __name__ == "__main__":
    build_draft_and_ref()
