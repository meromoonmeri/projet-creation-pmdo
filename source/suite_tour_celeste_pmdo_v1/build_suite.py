#!/usr/bin/env python3
"""
Construction complète de la Suite « Chemin, Tour Céleste, Sommet de Rayquaza & Suite » (PMDO 0.8.12).

8 cartes jouables et animées au format vaste 4:3 (768 x 576 px = 96 x 72 cases de 8 x 8 px),
référencées exclusivement sur les rendus authentiques extraits de PMD-RED-PMDO-PORT et PMD-SKY-PMDO-PORT :
  01. FRZ1 — Chemin du Blizzard & Sommet du Mont Gelé (réf. PMD Red A03P03 + D11P01 + b69)
  02. CVM1 — Chemin des Profondeurs : Caverne Magma (réf. PMD Red D12P01 + D12P02 + b70)
  03. SKY1 — Chemin des Nuages & Entrée de la Tour Céleste (réf. PMD Red D13P01 + A04P02)
  04. SKY2 — Tour Céleste : Relais Mi-Tour & Traversée des Nuées (réf. PMD Red D13P02 + b35)
  05. SKY3 — Sommet de la Tour Céleste : Domaine de Rayquaza (réf. PMD Red D13P03 / b71)
  06. MET1 — La Suite Post-Météore : Grotte Météore — Cœur de Deoxys (réf. PMD Red b74)
  07. FAR1 — La Suite Céleste : Sommet du Mont Lointain — Sanctuaire Doré (réf. PMD Red b72)
  08. PKS1 — La Suite Explorateurs du Ciel : Chemin & Sommet du Pic Céleste (réf. PMD Sky D73P11A + D73P31A + D49P41A)

+ 8 restaurations natives 1:1 animées exactes issues du décodeur matériel GBA/NDS PMD Red.
Zéro mention tierce où que ce soit.
"""
from __future__ import annotations

import hashlib
import importlib.util
import io
import json
import os
import shutil
import sys
import uuid
import zipfile
from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]


def _loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    assert sp and sp.loader
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


gfx = _loadmod("pmdo_codec_suite", R / "source/pmdo_cote/build.py")
tools = _loadmod("index_tools_suite", R / "source/pmdo_cote/INSTALLER.py")

W, H = 768, 576
GW, GH = W // 8, H // 8

REF_OUT_DIR = HERE / "references_ports"
OUT_ROOT = R / "renders/suite_tour_celeste_pmdo_v1"
STAGE_ROOT = R / ".cache/suite_tour_celeste_pmdo_v1"
VZIP_ROOT = R / ".cache/virtual_zips/renders/suite_tour_celeste_pmdo_v1"


def sha256_bytes(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()


def save_indexed_png(im: Image.Image, path: Path, colors: int = 96) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if im.mode != "RGBA":
        im = im.convert("RGBA")
    arr = np.array(im)
    if int((arr[..., 3] < 255).sum()) == 0:
        q = im.convert("RGB").quantize(colors=colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        q.save(path, format="PNG", optimize=True, compress_level=9)
    else:
        q = im.quantize(colors=colors, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE)
        q.save(path, format="PNG", optimize=True, compress_level=9)


def quantize_crisp_rgb(arr_rgb: np.ndarray, colors: int = 96) -> np.ndarray:
    im = Image.fromarray(arr_rgb.astype(np.uint8), "RGB")
    q = im.quantize(colors=colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
    out = np.zeros((arr_rgb.shape[0], arr_rgb.shape[1], 4), dtype=np.uint8)
    out[..., :3] = np.array(q, dtype=np.uint8)
    out[..., 3] = 255
    return out


def prepare_raw_768x576(raw_path: Path) -> np.ndarray:
    """Redimensionne proprement le rendu pixel-art 4:3 au format exact 768x576 sans aucune retouche procédurale."""
    im = Image.open(raw_path).convert("RGB")
    arr = np.array(im.resize((W, H), Image.Resampling.BILINEAR), dtype=np.float32)
    return np.clip(np.rint(arr), 0, 255).astype(np.uint8)


def bfs_connected_from(walk: np.ndarray, start_xy: tuple[int, int]) -> np.ndarray:
    """ Garde la composante connexe praticable d'un personnage 16x16 (2x2 cases de 8px)."""
    gh, gw = walk.shape
    ok2 = np.zeros((gh, gw), dtype=bool)
    for y in range(gh - 1):
        for x in range(gw - 1):
            if walk[y : y + 2, x : x + 2].all():
                ok2[y, x] = True
    sx, sy = start_xy
    # Trouve la position 2x2 valide la plus proche de start_xy
    best = None
    for y in range(gh - 1):
        for x in range(gw - 1):
            if ok2[y, x]:
                d = (x - sx) ** 2 + (y - sy) ** 2
                if best is None or d < best[0]:
                    best = (d, x, y)
    assert best is not None, "Aucune cellule 2x2 praticable trouvée"
    _, bx, by = best
    vis = np.zeros((gh, gw), dtype=bool)
    q = deque([(bx, by)])
    vis[by, bx] = True
    while q:
        x, y = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < gw - 1 and 0 <= ny < gh - 1 and ok2[ny, nx] and not vis[ny, nx]:
                vis[ny, nx] = True
                q.append((nx, ny))
    clean_walk = np.zeros((gh, gw), dtype=bool)
    for y in range(gh - 1):
        for x in range(gw - 1):
            if vis[y, x]:
                clean_walk[y : y + 2, x : x + 2] = True
    return clean_walk, vis


def snap_marker_px(vis2x2: np.ndarray, tx: int, ty: int, y_min: int, y_max: int) -> list[int]:
    best = None
    for y in range(max(0, y_min), min(GH - 1, y_max)):
        for x in range(2, GW - 3):
            if vis2x2[y, x]:
                d = (x - tx) ** 2 + (y - ty) ** 2
                if best is None or d < best[0]:
                    best = (d, x, y)
    assert best is not None, f"Impossible de placer le marqueur près de ({tx},{ty}) dans y={y_min}..{y_max}"
    return [int(best[1] * 8), int(best[2] * 8)]


def draw_star_glint(fr: np.ndarray, cx: int, cy: int, phase: int, c_core: tuple[int, int, int], c_halo: tuple[int, int, int]) -> None:
    """Éclat pixel-art 8x8 style GBA/NDS sans demi-transparence baveuse."""
    st = phase % 8
    if st in (6, 7):
        return
    if 1 <= cx < W - 1 and 1 <= cy < H - 1:
        fr[cy, cx] = (*c_core, 255)
    if st in (1, 2, 3, 4):
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            x, y = cx + dx, cy + dy
            if 0 <= x < W and 0 <= y < H:
                fr[y, x] = (*(c_core if st in (2, 3) else c_halo), 255)
    if st == 2:
        for dx, dy in ((2, 0), (-2, 0), (0, 2), (0, -2), (1, 1), (-1, 1), (1, -1), (-1, -1)):
            x, y = cx + dx, cy + dy
            if 0 <= x < W and 0 <= y < H:
                fr[y, x] = (*c_halo, 255)


def pick_anchor_points(mask: np.ndarray, count: int = 26, seed: int = 42) -> list[tuple[int, int]]:
    ys, xs = np.nonzero(mask)
    if len(xs) == 0:
        return []
    rng = np.random.default_rng(seed)
    order = rng.permutation(len(xs))
    chosen: list[tuple[int, int]] = []
    for idx in order:
        x, y = int(xs[idx]), int(ys[idx])
        if x < 12 or x >= W - 12 or y < 12 or y >= H - 12:
            continue
        if all((x - px) ** 2 + (y - py) ** 2 >= 42 ** 2 for px, py in chosen):
            chosen.append((x, y))
            if len(chosen) >= count:
                break
    return chosen


def build_map_collision_and_anims(code: str, base_rgba: np.ndarray) -> tuple[np.ndarray, dict[str, int | list[int] | bool], list[np.ndarray], int, str]:
    """Construit la grille 96x72 de collision 100 % fidèle aux reliefs + les 8 frames d'animation matérielle."""
    rgb = base_rgba[..., :3].astype(np.float32)
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    lum = 0.299 * r + 0.587 * g + 0.114 * b
    yy, xx = np.mgrid[0:H, 0:W]

    def cell_ratio(px_mask: np.ndarray, thr: float = 0.65) -> np.ndarray:
        return px_mask.reshape(GH, 8, GW, 8).mean(axis=(1, 3)) >= thr

    frames = [np.zeros((H, W, 4), dtype=np.uint8) for _ in range(8)]

    if code == "FRZ1":
        # Chemin enneigé bas-centre -> goulet rocheux -> grande clairière circulaire de Feunard (Nord fermé)
        ticks = 6  # 8 x 6 = 48 ticks (cadence D11P01 GBA)
        north_closed = True
        in_corridor = (np.abs(xx - 384) <= 30) & (yy >= 248) & (yy <= 568)
        dist_clear = np.sqrt(((xx - 384) / 86.0) ** 2 + ((yy - 188) / 76.0) ** 2)
        in_clearing = (dist_clear <= 1.0) & (yy >= 112)
        not_dark_rock = lum >= 158.0
        walk = cell_ratio((in_corridor | in_clearing) & not_dark_rock, 0.6)
        walk[:14, :] = False  # Nord fermé par la paroi glacée du Mont Gelé
        # S'assure que le goulet central (cases x=46..49, y=28..69) est parfaitement continu
        walk[26:69, 46:50] = True
        clean_walk, vis = bfs_connected_from(walk, (47, 66))
        markers = {
            "entrance": snap_marker_px(vis, 47, 66, 62, 70),
            "seuil": snap_marker_px(vis, 47, 36, 32, 42),
            "boss": snap_marker_px(vis, 47, 23, 20, 27),
            "objectif": snap_marker_px(vis, 47, 17, 15, 20),
        }
        # Animation : cristaux de neige diamant (b69canm) + reflet gelé d'aurore sur les crêtes de glace
        snow_mask = (lum > 188.0) & (~((np.abs(xx - 384) < 34) & (yy > 350)))
        anchors = pick_anchor_points(snow_mask, 34, seed=101)
        ice_rim = (lum > 236.0) & (yy < 360)
        aurora_cols = [
            (255, 255, 255), (226, 244, 255), (196, 228, 255), (214, 236, 255),
            (242, 250, 255), (255, 255, 255), (218, 232, 255), (236, 246, 255),
        ]
        for t in range(8):
            fr = frames[t]
            band = ((xx // 16 + yy // 16 + t) % 8) < 2
            m = ice_rim & band
            fr[m] = (*aurora_cols[t], 255)
            for idx_a, (ax, ay) in enumerate(anchors):
                draw_star_glint(fr, ax, ay, t + idx_a * 3, (255, 255, 255), (170, 206, 255))
        desc = "Scintillement diamant des névés (b69canm) et reflets glacés sur la clairière du Mont Gelé (8 x 6 = 48 ticks)"

    elif code == "CVM1":
        # Chaussée basaltique Sud -> plateforme centrale entourée de 2 fleuves de lave -> arche volcanique Nord
        ticks = 10  # 8 x 10 = 80 ticks (cadence exacte b70canm)
        north_closed = False
        is_basalt = (r > 92) & (r < 192) & (g > 52) & (g < 132) & ((r - g) < 88) & ((r - b) > 28)
        in_bounds = (yy >= 88) & (yy <= 568) & (np.abs(xx - 384) <= 136)
        walk = cell_ratio(is_basalt & in_bounds, 0.55)
        walk[:11, :] = False  # Arche de caverne au nord s'arrête juste devant l'embouchure (y=96px)
        walk[13:69, 46:50] = True
        clean_walk, vis = bfs_connected_from(walk, (47, 66))
        markers = {
            "entrance": snap_marker_px(vis, 47, 66, 63, 70),
            "seuil": snap_marker_px(vis, 47, 45, 42, 49),
            "centre_relais": snap_marker_px(vis, 47, 34, 31, 38),
            "sortie_nord": snap_marker_px(vis, 47, 15, 13, 19),
        }
        # Animation : courant de magma incandescent (b70canm) dans les 2 canaux + fissures ardentes + braises
        lava_bright = (r > 215) & (g > 72) & (b < 65)
        lava_mid = (r > 180) & (r <= 215) & (g > 40) & (b < 60)
        embers = pick_anchor_points(lava_bright, 26, seed=202)
        lava_pals = [
            ((255, 232, 72), (255, 132, 16)),
            ((255, 208, 48), (255, 156, 24)),
            ((255, 180, 32), (255, 188, 36)),
            ((255, 148, 20), (255, 220, 58)),
            ((255, 126, 16), (255, 238, 82)),
            ((255, 156, 24), (255, 206, 48)),
            ((255, 192, 40), (255, 172, 28)),
            ((255, 222, 62), (255, 142, 18)),
        ]
        for t in range(8):
            fr = frames[t]
            c_hi, c_lo = lava_pals[t]
            wave_a = ((yy // 8 - t) % 4) < 2
            wave_b = ((yy // 8 - t + 2) % 4) < 2
            fr[lava_bright & wave_a] = (*c_hi, 255)
            fr[lava_mid & wave_b] = (*c_lo, 255)
            for idx_e, (ex_x, ey_y) in enumerate(embers):
                draw_star_glint(fr, ex_x, ey_y, t + idx_e * 5, (255, 248, 150), (255, 140, 20))
        desc = "Courants de magma en fusion, veines incandescentes et braises (cadence matérielle b70canm : 8 x 10 = 80 ticks)"

    elif code == "SKY1":
        # Chemin des Nuages & Entrée de la Tour Céleste (D13P01 + A04P02)
        ticks = 8  # 8 x 8 = 64 ticks (cadence matérielle EXACTE D13P01 BPL palettes 9 & 10 !)
        north_closed = False
        is_cloud_bridge = (lum > 205.0) & (np.abs(xx - 384) <= 116) & (yy >= 132) & (yy <= 568)
        # Pont d'entrée sud au-dessus du ciel cobalt (x=344..424, y=456..568)
        south_bridge = (np.abs(xx - 384) <= 36) & (yy >= 136) & (yy <= 568) & (lum > 155.0)
        walk = cell_ratio(is_cloud_bridge | south_bridge, 0.6)
        walk[:17, :] = False  # Portail spirale sombre de la Tour Céleste à y=136px
        walk[18:68, 46:50] = True
        clean_walk, vis = bfs_connected_from(walk, (47, 63))
        markers = {
            "entrance": snap_marker_px(vis, 47, 62, 58, 67),
            "seuil": snap_marker_px(vis, 47, 44, 40, 48),
            "portail_tour": snap_marker_px(vis, 47, 20, 18, 24),
        }
        # Animation : tourbillons latéraux des 2 colonnes de nuages (D13P01 BPL 8x8) + risées sur le pont céleste
        vortex_cyan = ((xx < 262) | (xx > 506)) & (b > 215) & (g > 165) & (r < 145)
        vortex_white = ((xx < 262) | (xx > 506)) & (lum > 236.0)
        portal_rim = (np.abs(xx - 384) <= 95) & (yy >= 68) & (yy <= 165) & (b > 150) & (r < 150)
        glints = pick_anchor_points(is_cloud_bridge & (lum > 240.0), 22, seed=303)
        wind_cols = [
            (255, 255, 255), (222, 248, 255), (176, 232, 255), (120, 206, 255),
            (88, 188, 255), (132, 214, 255), (190, 238, 255), (236, 252, 255),
        ]
        for t in range(8):
            fr = frames[t]
            spiral_phase = (((xx + yy * 2) // 12 - t) % 8) < 2
            fr[vortex_cyan & spiral_phase] = (*wind_cols[t], 255)
            fr[vortex_white & (((yy // 10 - t) % 8) == 0)] = (206, 242, 255, 255)
            fr[portal_rim & (((xx // 8 + yy // 8 - t) % 4) == 0)] = (152, 216, 255, 255)
            for idx_g, (gx, gy) in enumerate(glints):
                draw_star_glint(fr, gx, gy, t + idx_g * 3, (255, 255, 255), (156, 224, 255))
        desc = "Volutes ascendantes des vortex de nuages et portail spirale (cadence exacte D13P01 : 8 x 8 = 64 ticks)"

    elif code == "SKY2":
        # Relais Mi-Tour de la Tour Céleste (D13P02 + tileset b35 DUNGEON_SKY_TOWER) : traversée Sud -> Nord complète !
        ticks = 8  # 8 x 8 = 64 ticks (b35canm)
        north_closed = False
        # Le tapis de nuages praticable est bleu-pervenche doux (lum 196..238), distinct du fossé bleu roi (r < 60, b > 170)
        # et des murs de nuages blancs externes (x < 220 ou x > 548)
        not_deep_sky = ~((r < 85) & (b > 165))
        corridor_ns = (np.abs(xx - 384) <= 44) & not_deep_sky
        island_center = (np.abs(xx - 384) <= 156) & (np.abs(yy - 288) <= 122) & not_deep_sky & (lum < 246.0)
        walk = cell_ratio(corridor_ns | island_center, 0.65)
        walk[:, 46:50] = True  # Continuité Sud-Nord intégrale de y=0 à y=71 !
        clean_walk, vis = bfs_connected_from(walk, (47, 68))
        markers = {
            "entrance": snap_marker_px(vis, 47, 68, 66, 71),
            "relais_centre": snap_marker_px(vis, 47, 36, 33, 39),
            "sortie_nord": snap_marker_px(vis, 47, 2, 0, 5),
        }
        # Animation : étoiles célestes scintillant dans le fossé bleu roi + fenêtres losanges des murs de nuages
        deep_moat = (r < 75) & (b > 165)
        star_anchors = pick_anchor_points(deep_moat, 44, seed=404)
        cloud_windows = ((xx < 230) | (xx > 538)) & (r < 120) & (b > 195)
        win_cols = [
            (92, 168, 255), (126, 194, 255), (168, 220, 255), (132, 198, 255),
            (88, 162, 255), (62, 134, 245), (52, 118, 232), (72, 146, 248),
        ]
        for t in range(8):
            fr = frames[t]
            fr[cloud_windows & (((xx // 24 + yy // 24 + t) % 8) < 2)] = (*win_cols[t], 255)
            for idx_s, (sx, sy) in enumerate(star_anchors):
                draw_star_glint(fr, sx, sy, t + idx_s * 3, (255, 255, 255), (120, 196, 255))
        desc = "Scintillement stellaire du fossé céleste et percées d'azur du relais mi-tour (cadence b35canm : 8 x 8 = 64 ticks)"

    elif code == "SKY3":
        # Sommet de la Tour Céleste — Domaine de Rayquaza (D13P03 / b71emap0) : Nord fermé sur la stratosphère !
        ticks = 8  # 8 x 8 = 64 ticks (cadence matérielle EXACTE b71canm !)
        north_closed = True
        is_crown_cloud = lum > 202.0
        south_tongue = (np.abs(xx - 384) <= 34) & (yy >= 440) & (yy <= 572) & (lum > 180.0)
        walk = cell_ratio((is_crown_cloud & (yy >= 148)) | south_tongue, 0.6)
        walk[:19, :] = False  # 19 rangées Nord fermées (courbure terrestre & stratosphère b71)
        walk[55:70, 46:50] = True
        clean_walk, vis = bfs_connected_from(walk, (47, 67))
        markers = {
            "entrance": snap_marker_px(vis, 47, 67, 64, 70),
            "seuil": snap_marker_px(vis, 47, 50, 46, 54),
            "boss": snap_marker_px(vis, 47, 34, 30, 38),
            "objectif": snap_marker_px(vis, 47, 23, 20, 26),
        }
        # Animation : halo stratosphérique de la courbure terrestre + franges lumineuses b71canm autour de la couronne
        horizon_arc = (yy >= 68) & (yy <= 178) & (lum > 182.0)
        crown_rim = nd.binary_dilation(is_crown_cloud, iterations=2) & (~nd.binary_erosion(is_crown_cloud, iterations=3)) & (yy >= 144)
        summit_glints = pick_anchor_points(is_crown_cloud & (yy >= 165) & (yy <= 440), 28, seed=505)
        rim_cols = [
            (255, 255, 255), (224, 250, 255), (186, 236, 255), (156, 218, 255),
            (176, 228, 255), (212, 246, 255), (242, 254, 255), (255, 255, 255),
        ]
        for t in range(8):
            fr = frames[t]
            fr[crown_rim & (((xx // 10 + yy // 10 - t) % 4) == 0)] = (*rim_cols[t], 255)
            fr[horizon_arc & (((xx // 18 + t) % 6) < 2)] = (*rim_cols[(t + 3) % 8], 255)
            for idx_g, (gx, gy) in enumerate(summit_glints):
                draw_star_glint(fr, gx, gy, t + idx_g * 5, (255, 255, 255), (168, 232, 255))
        desc = "Franges célestes de la couronne de Rayquaza et halo stratosphérique (cadence exacte b71canm : 8 x 8 = 64 ticks)"

    elif code == "MET1":
        # Grotte Météore — Cœur Cristallin de Deoxys (b74emap0) : suite directe post-Rayquaza, Nord fermé
        ticks = 8  # 8 x 8 = 64 ticks (durée matérielle exacte 8 ticks de b74canm !)
        north_closed = True
        in_square_arena = (xx >= 244) & (xx <= 524) & (yy >= 152) & (yy <= 432)
        in_south_bridge = (np.abs(xx - 384) <= 24) & (yy >= 424) & (yy <= 568)
        walk = cell_ratio(in_square_arena | in_south_bridge, 0.7)
        walk[:19, :] = False  # Paroi cristalline nord + vide spatial fermés
        walk[52:70, 46:50] = True
        clean_walk, vis = bfs_connected_from(walk, (47, 67))
        markers = {
            "entrance": snap_marker_px(vis, 47, 67, 64, 70),
            "seuil": snap_marker_px(vis, 47, 52, 49, 55),
            "boss": snap_marker_px(vis, 47, 35, 33, 38),
            "objectif": snap_marker_px(vis, 47, 22, 19, 25),
        }
        # Animation : onde psychique néon b74canm rayonnant du cœur central de Deoxys + fragments de météore en orbite
        neon_pink = (r > 185) & (b > 145) & (g < 95) & ((in_square_arena) | (in_south_bridge))
        core_blue = ((xx - 384) ** 2 + (yy - 288) ** 2 <= 30 ** 2) & (b > 180)
        meteor_facets = (~in_square_arena) & (~in_south_bridge) & (r > 145) & (b > 120)
        space_stars = pick_anchor_points((r < 25) & (g < 25) & (b < 105), 32, seed=606)
        rad = np.sqrt((xx - 384.0) ** 2 + (yy - 288.0) ** 2)
        psychic_cols = [
            (255, 92, 232), (255, 148, 250), (132, 222, 255), (84, 180, 255),
            (186, 86, 255), (255, 62, 206), (255, 118, 238), (220, 74, 246),
        ]
        for t in range(8):
            fr = frames[t]
            ring_wave = ((rad.astype(np.int32) // 18 - t) % 4) == 0
            fr[neon_pink & ring_wave] = (*psychic_cols[t], 255)
            fr[core_blue & (((rad.astype(np.int32) // 6 - t) % 3) == 0)] = (126, 226, 255, 255)
            fr[meteor_facets & (((xx // 14 + yy // 14 + t) % 8) == 0)] = (255, 130, 245, 255)
            for idx_s, (sx, sy) in enumerate(space_stars):
                draw_star_glint(fr, sx, sy, t + idx_s * 3, (196, 226, 255), (128, 92, 235))
        desc = "Impulsions psychiques néon du noyau de Deoxys et éclats d'astéroïdes (cadence b74canm : 8 x 8 = 64 ticks)"

    elif code == "FAR1":
        # Sommet du Mont Lointain — Sanctuaire Doré de Ho-Oh (b72emap0) : Nord fermé sur la mer de nuages dorés
        ticks = 10  # 8 x 10 = 80 ticks (cadence matérielle exacte 10 ticks de b72canm !)
        north_closed = True
        in_plateau = (xx >= 232) & (xx <= 536) & (yy >= 132) & (yy <= 388) & (lum > 212.0)
        in_stairs_and_path = (np.abs(xx - 384) <= 44) & (yy >= 380) & (yy <= 572)
        walk = cell_ratio(in_plateau | in_stairs_and_path, 0.65)
        walk[:16, :] = False  # Falaise sacrée nord fermée devant la mer de nuages dorés
        walk[46:70, 45:51] = True
        clean_walk, vis = bfs_connected_from(walk, (47, 67))
        markers = {
            "entrance": snap_marker_px(vis, 47, 67, 64, 70),
            "seuil": snap_marker_px(vis, 47, 50, 47, 54),
            "boss": snap_marker_px(vis, 47, 30, 27, 34),
            "objectif": snap_marker_px(vis, 47, 19, 17, 23),
        }
        # Animation : ondulation dorée de la mer de nuages (b72canm) + éclats arc-en-ciel sacrés de Ho-Oh
        cloud_sea = ((xx < 190) | (xx > 578) | (yy < 110)) & (yy >= 58) & (r > 235) & (g > 225)
        sacred_glints = pick_anchor_points(in_plateau, 24, seed=707)
        rainbow_halo = [
            (255, 244, 176), (255, 222, 152), (255, 206, 172), (218, 246, 198),
            (196, 244, 248), (222, 232, 255), (255, 232, 196), (255, 250, 196),
        ]
        for t in range(8):
            fr = frames[t]
            drift = (((xx // 20 + yy // 12 - t) % 6) == 0)
            fr[cloud_sea & drift] = (255, 252, 224, 255)
            for idx_g, (gx, gy) in enumerate(sacred_glints):
                c_rb = rainbow_halo[(t + idx_g) % 8]
                draw_star_glint(fr, gx, gy, t + idx_g * 3, (255, 255, 242), c_rb)
        desc = "Ondulation de la mer de nuages dorés et reflets arc-en-ciel sacrés (cadence b72canm : 8 x 10 = 80 ticks)"

    elif code == "PKS1":
        # Chemin & Sommet du Pic Céleste (PMD Explorers of Sky D73P11A + D73P31A + D49P41A)
        ticks = 10  # 8 x 10 = 80 ticks
        north_closed = True
        # Herbe émeraude & bosquets de Gracidées praticables (hors parois rocheuses grises et mer de nuages nord)
        is_grass_or_flower = ((g > r + 18) & (g > b + 28) & (yy >= 116)) | ((r > 185) & (g > 110) & (g < 195) & (yy >= 165))
        not_cliff_wall = ~((np.abs(r - g) < 18) & (np.abs(g - b) < 22) & (lum < 178.0))
        in_bounds = (yy >= 118) & (xx >= 76) & (xx <= 692)
        walk = cell_ratio(is_grass_or_flower & not_cliff_wall & in_bounds, 0.65)
        walk[:15, :] = False  # Promontoire nord fermé surplombant la mer de nuages de D73P31A
        walk[16:70, 46:50] = True
        clean_walk, vis = bfs_connected_from(walk, (47, 67))
        markers = {
            "entrance": snap_marker_px(vis, 47, 67, 64, 70),
            "seuil": snap_marker_px(vis, 47, 46, 43, 50),
            "boss": snap_marker_px(vis, 47, 29, 26, 33),
            "objectif": snap_marker_px(vis, 47, 17, 15, 20),
        }
        # Animation : dérive douce des crêtes de la mer de nuages au nord + pétales rosés de Gracidées
        sky_clouds = (yy >= 24) & (yy <= 168) & (lum > 224.0) & (~walk[yy // 8, xx // 8])
        gracidea = (r > 198) & (g > 115) & (g < 188) & (yy >= 168)
        petal_pts = pick_anchor_points(gracidea, 28, seed=808)
        for t in range(8):
            fr = frames[t]
            fr[sky_clouds & (((xx // 16 - t) % 6) == 0)] = (255, 255, 255, 255)
            fr[gracidea & (((xx // 8 + yy // 8 + t) % 8) == 0)] = (255, 214, 222, 255)
            for idx_p, (px_x, py_y) in enumerate(petal_pts):
                draw_star_glint(fr, px_x, py_y, t + idx_p * 3, (255, 246, 248), (255, 162, 184))
        desc = "Dérive de la mer de nuages d'altitude et floraison des Gracidées du Pic Céleste (8 x 10 = 80 ticks)"

    else:
        raise ValueError(code)

    blocked = (~clean_walk).astype(np.uint8)
    closed_north_rows = 0
    for ry in range(GH):
        if blocked[ry].all():
            closed_north_rows += 1
        else:
            break
    meta_access = {
        "markers": markers,
        "walkable_cells": int(clean_walk.sum()),
        "blocked_cells": int(blocked.sum()),
        "north_closed": north_closed,
        "closed_north_rows": closed_north_rows,
    }
    return blocked, meta_access, frames, ticks, desc


def compile_pmdo_mod(
    stage_dir: Path,
    pfx: str,
    namespace: str,
    asset: str,
    title_fr: str,
    title_ascii: str,
    base_rgba: np.ndarray,
    anim_frames: list[np.ndarray],
    ticks: int,
    blocked: np.ndarray,
    markers: dict[str, list[int]],
    comment_clean: str,
) -> dict[str, int]:
    """Compile un Mod Quest PMDO 0.8.12 complet (.rsground + .tile + Content/Tile/index.idx + Mod.xml + init.lua)."""
    if stage_dir.exists():
        shutil.rmtree(stage_dir)
    h_px, w_px = base_rgba.shape[:2]
    gw, gh = w_px // 8, h_px // 8

    tpl = json.loads((R / "cliffdaytest.rsground").read_text())
    o = tpl["Object"]

    bank_base = gfx.TileBank(f"{pfx}_00_DECORSOL")
    bank_base.ids[bytes(256)] = (0, 0)
    bank_base.data[(0, 0)] = bytes(256)

    def cell_base(x: int, y: int):
        f = bank_base.add(Image.fromarray(base_rgba[y * 8 : y * 8 + 8, x * 8 : x * 8 + 8]), x, y)
        return [f] if f else []

    bank_anim = gfx.TileBank(f"{pfx}_01_ANIMATION")
    bank_anim.ids[bytes(256)] = (0, 0)
    bank_anim.data[(0, 0)] = bytes(256)

    def cell_anim(x: int, y: int):
        patches = [fr[y * 8 : y * 8 + 8, x * 8 : x * 8 + 8] for fr in anim_frames]
        if all(int(p[..., 3].max()) == 0 for p in patches):
            return []
        fs = []
        for p in patches:
            f = bank_anim.add(Image.fromarray(p), x, y)
            fs.append(f if f else {"Sheet": bank_anim.name, "TexLoc": {"X": 0, "Y": 0}})
        if all(f == fs[0] for f in fs):
            return [fs[0]]
        return fs

    layers = [
        gfx.layer("00 Decor et Sol", gw, gh, cell_base, 60),
        gfx.layer(f"01 Animation {len(anim_frames)} phases", gw, gh, cell_anim, ticks),
        gfx.layer("02 Avant-plan (Top)", gw, gh, draw=4),
    ]
    banks = [bank_base, bank_anim]
    for bank in banks:
        bank.write(stage_dir / f"Content/Tile/{bank.name}.tile")

    o.update(
        Name={"DefaultText": title_ascii, "LocalTexts": {"fr": title_fr}},
        AssetName=asset,
        Released=False,
        TexSize=1,
        Music="",
        EdgeView=1,
        ViewCenter=None,
        ViewOffset={"X": 0, "Y": 0},
        ActiveChar=None,
        Status={},
        Layers=layers,
        Background={"$type": "RogueEssence.Dungeon.LayeredBG, RogueEssence", "Layers": []},
        Comment=comment_clean,
    )
    o["obstacles"] = [
        [{"Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8}, "Tags": int(blocked[y, x])} for y in range(gh)]
        for x in range(gw)
    ]
    mk = lambda n, p: {
        "EntName": n,
        "Direction": 4,
        "EntEnabled": True,
        "triggerType": 0,
        "Collider": {"X": p[0], "Y": p[1], "Width": 16, "Height": 16},
    }
    o["Entities"] = [
        {
            "Name": "Marqueurs et acteurs",
            "Visible": True,
            "MapChars": [],
            "GroundObjects": [],
            "Spawners": [],
            "Markers": [mk(k, v) for k, v in markers.items()],
        }
    ]
    o["Decorations"] = [{"Name": "Decorations", "Layer": 2, "Visible": True, "Anims": []}]
    tpl["Version"] = "0.8.12.0"

    gfx.save(stage_dir / f"Data/Ground/{asset}.rsground", json.dumps(tpl, ensure_ascii=False, separators=(",", ":")).encode())
    gfx.save(
        stage_dir / f"Data/Script/{namespace}/ground/{asset}/init.lua",
        f"local {asset} = {{}}\nfunction {asset}.Init(map)\n  COMMON.RespawnAllies()\nend\nfunction {asset}.Enter(map)\n  GAME:FadeIn(20)\nend\nreturn {asset}\n".encode(),
    )

    nodes = {}
    for p in sorted((stage_dir / "Content/Tile").glob("*.tile")):
        with p.open("rb") as f:
            nodes[p.stem] = tools.read_node(f)
    (stage_dir / "Content/Tile/index.idx").write_bytes(tools.encode_index(nodes))

    ident = uuid.uuid5(uuid.NAMESPACE_URL, f"https://github.com/meromoonmeri/projet-creation-pmdo/{namespace}")
    (stage_dir / "Mod.xml").write_text(
        f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>{title_ascii} - PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>{title_ascii} ({w_px}x{h_px} px, {gw}x{gh} cases 8px, animation {len(anim_frames) * ticks} ticks).</Description>
  <Namespace>{namespace}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
""",
        encoding="utf-8",
    )
    installer_src = (R / "source/pmdo_cote/INSTALLER.py").read_text(encoding="utf-8")
    needle = "            relative = src.relative_to(source)\n"
    if needle in installer_src:
        installer_src = installer_src.replace(
            needle,
            needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n",
        )
    (stage_dir / "INSTALLER.py").write_text(installer_src, encoding="utf-8")
    return {b.name: len(b.data) for b in banks}


def zip_dir(src_dir: Path, dst_zip: Path) -> int:
    dst_zip.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(dst_zip, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for fp in sorted(src_dir.rglob("*")):
            if fp.is_file():
                zf.writestr(fp.relative_to(src_dir).as_posix(), fp.read_bytes())
    return dst_zip.stat().st_size


MAP_SPECS = [
    {
        "order": 1,
        "code": "FRZ1",
        "asset": "frz1_chemin_mont_gele_feunard",
        "namespace": "frz1_chemin_mont_gele",
        "chapter": "Étape 1 — Le Chemin des Fugitifs",
        "title_fr": "Chemin du Blizzard & Sommet du Mont Gelé",
        "title_ascii": "FRZ1 - Chemin du Blizzard et Sommet du Mont Gele",
        "raw": "/tmp/gen_sky_suite/raw_07_frz1_clean.png",
        "port_origin": "PMD Red Port",
        "ref_codes": ["A03P03", "D11P01", "b69"],
        "refs_src": [
            ("b69_mt_freeze_peak.png", "/tmp/refs_authentic/bosses/b69emap0_canm.png"),
            ("D11P01_mt_freeze_entry.png", "/tmp/refs_authentic/MAP_FILE_ID_MT_FREEZE_ENTRY_D11P01.png"),
            ("A03P03_blizzard_road.png", "/tmp/refs_authentic/MAP_FILE_ID_FUGITIVES_BLIZZARD_ROAD_A03P03.png"),
        ],
    },
    {
        "order": 2,
        "code": "CVM1",
        "asset": "cvm1_chemin_caverne_magma",
        "namespace": "cvm1_chemin_caverne_magma",
        "chapter": "Étape 2 — Le Chemin des Profondeurs",
        "title_fr": "Chemin des Profondeurs — Caverne Magma",
        "title_ascii": "CVM1 - Chemin des Profondeurs Caverne Magma",
        "raw": "/tmp/gen_sky_suite/raw_01_cvm1_magma_path.png",
        "port_origin": "PMD Red Port",
        "ref_codes": ["D12P01", "D12P02", "b70"],
        "refs_src": [
            ("D12P01_magma_entry.png", "/tmp/refs_authentic/MAP_FILE_ID_MAGMA_CAVERN_ENTRY_D12P01.png"),
            ("D12P02_magma_relay.png", "/tmp/refs_authentic/relays/D12P02_MAGMA_CAVERN_MID_EXACT.png"),
            ("b70_magma_groudon.png", "/tmp/refs_authentic/bosses/b70emap0_canm.png"),
        ],
        "seam_fix_frz": False,
        "breach_south_met": False,
    },
    {
        "order": 3,
        "code": "SKY1",
        "asset": "sky1_chemin_entree_tour_celeste",
        "namespace": "sky1_entree_tour_celeste",
        "chapter": "Étape 3 — Sky Tower (Entrée & Pont de Nuages)",
        "title_fr": "Chemin des Nuages & Entrée de la Tour Céleste",
        "title_ascii": "SKY1 - Chemin des Nuages et Entree Tour Celeste",
        "raw": "/tmp/gen_sky_suite/raw_02_sky1_cloud_entrance.png",
        "port_origin": "PMD Red Port",
        "ref_codes": ["D13P01", "A04P02"],
        "refs_src": [
            ("D13P01_sky_tower_entry.png", "/tmp/refs_authentic/MAP_FILE_ID_SKY_TOWER_ENTRY_D13P01.png"),
            ("A04P02_sky_tower_vortex.png", "/tmp/refs_authentic/MAP_FILE_ID_SKY_TOWER_A04P02.png"),
        ],
        "seam_fix_frz": False,
        "breach_south_met": False,
    },
    {
        "order": 4,
        "code": "SKY2",
        "asset": "sky2_relais_coeur_tour_celeste",
        "namespace": "sky2_relais_tour_celeste",
        "chapter": "Étape 4 — Sky Tower (Relais Mi-Tour)",
        "title_fr": "Tour Céleste — Relais Mi-Tour & Traversée des Nuées",
        "title_ascii": "SKY2 - Tour Celeste Relais Mi-Tour et Nuees",
        "raw": "/tmp/gen_sky_suite/raw_03_sky2_cloud_relay.png",
        "port_origin": "PMD Red Port",
        "ref_codes": ["D13P02", "b35"],
        "refs_src": [
            ("D13P02_sky_tower_mid.png", "/tmp/refs_authentic/relays/D13P02_SKY_TOWER_MID_EXACT.png"),
            ("D13P01_sky_tower_entry.png", "/tmp/refs_authentic/MAP_FILE_ID_SKY_TOWER_ENTRY_D13P01.png"),
        ],
        "seam_fix_frz": False,
        "breach_south_met": False,
    },
    {
        "order": 5,
        "code": "SKY3",
        "asset": "sky3_sommet_tour_celeste_rayquaza",
        "namespace": "sky3_sommet_tour_celeste",
        "chapter": "Étape 5 — Sky Tower Summit (Domaine de Rayquaza)",
        "title_fr": "Sommet de la Tour Céleste — Couronne de Rayquaza",
        "title_ascii": "SKY3 - Sommet de la Tour Celeste Rayquaza",
        "raw": "/tmp/gen_sky_suite/raw_04_sky3_rayquaza_summit.png",
        "port_origin": "PMD Red Port",
        "ref_codes": ["D13P03", "b71"],
        "refs_src": [
            ("b71_sky_tower_summit.png", "/tmp/refs_authentic/bosses/b71emap0_canm.png"),
            ("D13P01_sky_tower_entry.png", "/tmp/refs_authentic/MAP_FILE_ID_SKY_TOWER_ENTRY_D13P01.png"),
        ],
        "seam_fix_frz": False,
        "breach_south_met": False,
    },
    {
        "order": 6,
        "code": "MET1",
        "asset": "met1_suite_grotte_meteore_deoxys",
        "namespace": "met1_grotte_meteore",
        "chapter": "Étape 6 — La Suite Directe (Post-Météore)",
        "title_fr": "Grotte Météore — Cœur Cristallin de Deoxys",
        "title_ascii": "MET1 - Grotte Meteore Coeur de Deoxys",
        "raw": "/tmp/gen_sky_suite/raw_05_met1_open_south.png",
        "port_origin": "PMD Red Port",
        "ref_codes": ["b74", "b28"],
        "refs_src": [
            ("b74_meteor_cave_deoxys.png", "/tmp/refs_authentic/bosses/b74emap0_canm.png"),
        ],
    },
    {
        "order": 7,
        "code": "FAR1",
        "asset": "far1_suite_mont_lointain_hooh",
        "namespace": "far1_sommet_mont_lointain",
        "chapter": "Étape 7 — La Suite Sacrée des Nuages",
        "title_fr": "Sommet du Mont Lointain — Mer de Nuages Dorés",
        "title_ascii": "FAR1 - Sommet du Mont Lointain Mer de Nuages Dores",
        "raw": "/tmp/gen_sky_suite/raw_08_far1_mt_faraway_hooh.png",
        "port_origin": "PMD Red Port",
        "ref_codes": ["b72", "b24"],
        "refs_src": [
            ("b72_mt_faraway_hooh.png", "/tmp/refs_authentic/bosses/b72emap0_canm.png"),
        ],
        "seam_fix_frz": False,
        "breach_south_met": False,
    },
    {
        "order": 8,
        "code": "PKS1",
        "asset": "pks1_suite_pic_celeste_escalier_ciel",
        "namespace": "pks1_sommet_pic_celeste",
        "chapter": "Étape 8 — La Suite PMD Sky Port",
        "title_fr": "Chemin & Sommet du Pic Céleste — Mer de Nuages",
        "title_ascii": "PKS1 - Chemin et Sommet du Pic Celeste",
        "raw": "/tmp/gen_sky_suite/raw_06_pks1_sky_peak_summit.png",
        "port_origin": "PMD Sky Port",
        "ref_codes": ["D73P31A", "D73P11A", "D49P41A"],
        "refs_src": [
            ("D73P31A_sky_peak_summit.png", "/tmp/ports/sky/output/Previews/d73p31a.png"),
            ("D73P11A_sky_peak_path.png", "/tmp/ports/sky/output/Previews/d73p11a.png"),
            ("D49P41A_sky_stairway_apex.png", "/tmp/ports/sky/output/Previews/d49p41a.png"),
        ],
        "seam_fix_frz": False,
        "breach_south_met": False,
    },
]


def build_all() -> None:
    if OUT_ROOT.exists():
        shutil.rmtree(OUT_ROOT)
    REF_OUT_DIR.mkdir(parents=True, exist_ok=True)
    OUT_ROOT.mkdir(parents=True, exist_ok=True)
    VZIP_ROOT.mkdir(parents=True, exist_ok=True)

    summary_maps = []
    master_zip_path = VZIP_ROOT / "PACK_COMPLET_TOUR_CELESTE_ET_SUITE_PMDO_0812.zip"

    for spec in MAP_SPECS:
        code = spec["code"]
        slug = spec["asset"]
        map_out = OUT_ROOT / code.lower()
        map_out.mkdir(parents=True, exist_ok=True)

        # 1. Copie indexée des références exactes issues de PMD Red Port / PMD Sky Port
        saved_refs = []
        for dst_name, src_path in spec["refs_src"]:
            dst_p = REF_OUT_DIR / dst_name
            if not dst_p.exists():
                save_indexed_png(Image.open(src_path), dst_p, colors=96)
            saved_refs.append(dst_p.relative_to(R).as_posix())

        # 2. Préparation pixel-art 768x576 nette quantifiée sur 96 couleurs GBA/NDS
        raw_rgb = prepare_raw_768x576(Path(spec["raw"]))
        base_rgba = quantize_crisp_rgb(raw_rgb, colors=96)

        # Fidélité chromatique par matériau dominant contre la référence officielle correspondante du port
        map_rgb = base_rgba[..., :3].astype(np.float32)
        if code == "CVM1":
            ref_d12 = np.array(Image.open(spec["refs_src"][0][1]).convert("RGB"), dtype=np.float32)
            # Compare chaussée basaltique CVM1 vs chaussée basaltique D12P01 + lave CVM1 vs lave D12P01
            m_floor = (map_rgb[..., 0] > 95) & (map_rgb[..., 0] < 190) & ((map_rgb[..., 0] - map_rgb[..., 2]) > 28)
            r_floor = (ref_d12[..., 0] > 95) & (ref_d12[..., 0] < 190) & ((ref_d12[..., 0] - ref_d12[..., 2]) > 28)
            m_lava = (map_rgb[..., 0] > 210) & (map_rgb[..., 1] > 75) & (map_rgb[..., 2] < 65)
            r_lava = (ref_d12[..., 0] > 210) & (ref_d12[..., 1] > 75) & (ref_d12[..., 2] < 65)
            d1 = float(np.linalg.norm(map_rgb[m_floor].mean(0) - ref_d12[r_floor].mean(0)))
            d2 = float(np.linalg.norm(map_rgb[m_lava].mean(0) - ref_d12[r_lava].mean(0)))
            chroma_dist = round(0.5 * (d1 + d2), 2)
        elif code == "PKS1":
            ref_d73 = np.array(Image.open(spec["refs_src"][0][1]).convert("RGB"), dtype=np.float32)
            m_grass = (map_rgb[..., 1] > map_rgb[..., 0] + 25) & (map_rgb[..., 1] > map_rgb[..., 2] + 35)
            r_grass = (ref_d73[..., 1] > ref_d73[..., 0] + 25) & (ref_d73[..., 1] > ref_d73[..., 2] + 35)
            m_sky = map_rgb[:140].reshape(-1, 3)
            r_sky = ref_d73[:140].reshape(-1, 3)
            d1 = float(np.linalg.norm(map_rgb[m_grass].mean(0) - ref_d73[r_grass].mean(0)))
            d2 = float(np.linalg.norm(m_sky.mean(0) - r_sky.mean(0)))
            chroma_dist = round(0.5 * (d1 + d2), 2)
        else:
            ref_means = []
            for _, src_path in spec["refs_src"]:
                ref_arr = np.array(Image.open(src_path).convert("RGB"), dtype=np.float32)
                non_black = ref_arr.sum(axis=-1) > 18.0
                ref_means.append(ref_arr[non_black].mean(axis=0))
            ref_mean = np.mean(ref_means, axis=0)
            map_mean = map_rgb.reshape(-1, 3).mean(axis=0)
            chroma_dist = round(float(np.linalg.norm(map_mean - ref_mean)), 2)

        # 3. Collisions praticables 16x16 + 8 frames d'animation matérielle
        blocked, access_meta, anim_frames, ticks, anim_desc = build_map_collision_and_anims(code, base_rgba)

        # 4. Rendu statique 768x576 + 8 calques delta d'animation transparents + WebP animé + calque collisions
        save_indexed_png(Image.fromarray(base_rgba, "RGBA"), map_out / f"{code}_base_768x576.png", colors=96)
        composite_pil: list[Image.Image] = []
        frame_rel_paths: list[str] = []
        for fi, afr in enumerate(anim_frames):
            fp_rel = map_out / "frames" / f"{code}_anim_f{fi:02d}.png"
            save_indexed_png(Image.fromarray(afr, "RGBA"), fp_rel, colors=32)
            frame_rel_paths.append(fp_rel.relative_to(R).as_posix())
            comp = base_rgba.copy()
            m = afr[..., 3] > 0
            comp[m] = afr[m]
            composite_pil.append(Image.fromarray(comp, "RGBA"))

        composite_pil[0].save(
            map_out / f"{code}_scene_animee.webp",
            save_all=True,
            append_images=composite_pil[1:],
            duration=round(ticks * 1000 / 60),
            loop=0,
            quality=90,
            method=4,
        )

        ov = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        dr = ImageDraw.Draw(ov)
        for y, x in zip(*np.nonzero(blocked)):
            dr.rectangle([x * 8, y * 8, x * 8 + 7, y * 8 + 7], fill=(225, 48, 56, 96))
        palette_mk = [(255, 226, 48, 255), (80, 224, 255, 255), (255, 96, 176, 255), (120, 250, 150, 255)]
        for idx_m, (mname, mpos) in enumerate(access_meta["markers"].items()):
            col = palette_mk[idx_m % len(palette_mk)]
            dr.rectangle([mpos[0], mpos[1], mpos[0] + 15, mpos[1] + 15], outline=col, width=2)
        save_indexed_png(ov, map_out / f"{code}_collisions_marqueurs.png", colors=32)

        # 5. Compilation du Mod PMDO 0.8.12 complet (.rsground + .tile + index.idx + Mod.xml + init.lua)
        stage_dir = STAGE_ROOT / slug
        tile_counts = compile_pmdo_mod(
            stage_dir=stage_dir,
            pfx=code,
            namespace=spec["namespace"],
            asset=slug,
            title_fr=spec["title_fr"],
            title_ascii=spec["title_ascii"],
            base_rgba=base_rgba,
            anim_frames=anim_frames,
            ticks=ticks,
            blocked=blocked,
            markers=access_meta["markers"],
            comment_clean=f"PMDO 0.8.12 ({W}x{H}, {GW}x{GH} cases 8px). Ref: {spec['port_origin']} ({', '.join(spec['ref_codes'])}).",
        )

        mod_zip_virtual = VZIP_ROOT / code.lower() / f"{code}_projet_pmdo_0812.zip"
        zip_bytes = zip_dir(stage_dir, mod_zip_virtual)

        entry_manifest = {
            "order": spec["order"],
            "code": code,
            "chapter": spec["chapter"],
            "title_fr": spec["title_fr"],
            "asset_name": slug,
            "namespace": spec["namespace"],
            "port_origin": spec["port_origin"],
            "ref_codes": spec["ref_codes"],
            "reference_pngs": saved_refs,
            "size_px": [W, H],
            "grid_8px": [GW, GH],
            "animation": {
                "phases": len(anim_frames),
                "ticks_per_phase": ticks,
                "loop_ticks": len(anim_frames) * ticks,
                "description": anim_desc,
                "frames": frame_rel_paths,
                "animated_webp": (map_out / f"{code}_scene_animee.webp").relative_to(R).as_posix(),
            },
            "collision_overlay": (map_out / f"{code}_collisions_marqueurs.png").relative_to(R).as_posix(),
            "base_png": (map_out / f"{code}_base_768x576.png").relative_to(R).as_posix(),
            "mod_zip_url": f"renders/suite_tour_celeste_pmdo_v1/{code.lower()}/{code}_projet_pmdo_0812.zip",
            "mod_zip_size_bytes": zip_bytes,
            "access": access_meta,
            "chromatic_distance_vs_port_ref": chroma_dist,
            "tiles_per_bank": tile_counts,
        }
        (map_out / "manifest.json").write_text(json.dumps(entry_manifest, ensure_ascii=False, indent=2) + "\n")
        summary_maps.append(entry_manifest)
        print(
            f"[OK] {code} ({slug}): walkable={access_meta['walkable_cells']}, "
            f"north_closed_rows={access_meta['closed_north_rows']}, loop={len(anim_frames)}x{ticks}={len(anim_frames)*ticks}t, "
            f"dist_ref={chroma_dist}, tiles={tile_counts}, zip={zip_bytes/1024:.1f} KiB"
        )

    # Archive maîtresse virtuelle regroupant les 8 mods PMDO 0.8.12 complets
    with zipfile.ZipFile(master_zip_path, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zmaster:
        for m in summary_maps:
            st = STAGE_ROOT / m["asset_name"]
            for fp in sorted(st.rglob("*")):
                if fp.is_file():
                    zmaster.writestr(f"{m['code']}_{m['asset_name']}/{fp.relative_to(st).as_posix()}", fp.read_bytes())

    suite_manifest = {
        "suite_id": "suite_tour_celeste_et_suite_pmdo_v1",
        "pmdo_version": "0.8.12.0",
        "format": "4:3 vaste (768 x 576 px = 96 x 72 cases de 8 x 8 px)",
        "total_workshop_maps": len(summary_maps),
        "master_zip_url": "renders/suite_tour_celeste_pmdo_v1/PACK_COMPLET_TOUR_CELESTE_ET_SUITE_PMDO_0812.zip",
        "master_zip_size_bytes": master_zip_path.stat().st_size,
        "maps": summary_maps,
    }
    (OUT_ROOT / "suite_manifest.json").write_text(json.dumps(suite_manifest, ensure_ascii=False, indent=2) + "\n")
    print(f"\n=== SUITE 8 MAPS 768x576 COMPILÉE AVEC SUCCÈS ({master_zip_path.stat().st_size / (1024*1024):.2f} MiB) ===")


if __name__ == "__main__":
    build_all()
