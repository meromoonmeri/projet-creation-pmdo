"""Construction complète — Lot Treehouses Monumentales de Guilde : Style Jardin Secret & Sky Peak (PMDO 8px + HD RGBA).

- 8 grandes structures multi-étages 100 % organiques SANS AUCUNE TOITURE PYRAMIDALE / POINTUE :
  uniquement dômes de feuilles courbes, cocons tressés sphériques, chambres-glands galbées, galeries cylindriques,
  escaliers hélicoïdaux en écorce, ponts suspendus fleuris, pergolas plates et belvédères circulaires.
- 4 structures dans l'esthétique canonique « Jardin Secret » (`GJS1`..`GJS4`) + 4 structures dans l'esthétique
  canonique « Sky Peak / Pic Céleste » (`GSP1`..`GSP4`).
- 100 % sans fond véritable (`alpha ∈ {0, 255}`, `0 px` de halo/frange bleue sur 100 % des PNG exportés).
- Banques natives `.tile` (`GJS1`..`GJS4`, `GSP1`..`GSP4`) + descripteurs Tiled `.tsj` + variantes Jour/Nuit +
  découpes de surface visible `Arriere_Under` / `Avant_Base` (partition exacte des pixels visibles sans reconstruction
  des pixels occultés) + `manifest.json` (`art_approved: false`, `runtime_tested: false`).
- Galerie autonome `apercu_guilde_jardin_secret_sky_peak.html` utilisant exclusivement de vraies balises `<img>` RGBA
  (`0` `<canvas>`, `0` damier peint) sur fond ardoise sombre uni `#161b26`.
"""
from __future__ import annotations

import base64
from collections import deque
import hashlib
import io
import json
import math
import struct
import zipfile
from pathlib import Path
from typing import Any

import numpy as np
from PIL import Image, ImageFilter

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
BRUTS = HERE / "bruts"
OUT_DIR = R / "livrables_guilde_jardin_secret_sky_peak_pmdo"
OUT_1X = OUT_DIR / "1x_PMDO_8px_sans_fond"
OUT_HD = OUT_DIR / "HD_sans_fond"
OUT_MOD = OUT_DIR / "Mod_PMDO_Tile_Pret_A_Importer"
OUT_MOD_TILE = OUT_MOD / "Content" / "Tile"
OUT_ZIP = OUT_DIR / "PACK_GUILDE_JARDIN_SECRET_SKY_PEAK_PMDO.zip"
OUT_HTML = R / "apercu_guilde_jardin_secret_sky_peak.html"

NN = Image.Resampling.NEAREST

# (slug, pfx, biome, title, desc, floors_count, raw_webp, target_pmdo_max_wh, split_ratio_y)
STRUCTURES_SPEC = [
    (
        "01_arbre_guilde_qg_jardin_secret",
        "GJS1",
        "Jardin Secret",
        "Grande Arbre-Guilde QG — Arche de Feuilles, Escalier Spirale & Cocons",
        "Arbre-QG monumental à racines moussues et rochers gréseux doux du Jardin Secret, portail d'entrée sous feuilles géantes recourbées, escalier hélicoïdal, balcon circulaire et deux chambres-cocons sphériques reliées par un pont suspendu fleuri.",
        4,
        "01_js_qg.webp",
        (352, 352),
        0.74,
    ),
    (
        "02_grand_arbre_pont_fleuri_jardin_secret",
        "GJS2",
        "Jardin Secret",
        "Grand Arbre Multi-Branches — Dômes Feuillus, Pont Fleuri & Belvédère",
        "Triple houppier fleuri du Jardin Secret (grappes corail, lilas et dorées), double escalier courbe menant à deux huttes rondes à dôme de feuilles souples, longue passerelle suspendue fleurie et plateforme ronde panoramique.",
        3,
        "02_js_pont.webp",
        (448, 224),
        0.72,
    ),
    (
        "03_sanctuaire_rosace_racines_jardin_secret",
        "GJS3",
        "Jardin Secret",
        "Arbre-Sanctuaire Botanique — Chambre-Gland à Rosace Dorée & Poulie",
        "Sanctuaire d'archives et d'herboristerie logé dans une chambre-gland galbée coiffée d'une coupole de feuilles rondes, grande rosace florale dorée, monte-charge à panier tressé, escalier courbe et arche racinaire de pierre.",
        3,
        "03_js_sanctuaire.webp",
        (384, 240),
        0.74,
    ),
    (
        "04_observatoire_spirale_cocon_jardin_secret",
        "GJS4",
        "Jardin Secret",
        "Arbre-Observatoire Hélicoïdal — 4 Paliers Fleuris, Cocon Suspendu & Vigie",
        "Arbre-tour vertical du Jardin Secret à escalier en colimaçon fleuri sur 4 niveaux, hublots ronds à croisillons, cocon-dortoir suspendu sous feuilles courbes et belvédère circulaire ouvert au sommet.",
        4,
        "04_js_observatoire.webp",
        (280, 352),
        0.76,
    ),
    (
        "05_citadelle_arbre_qg_sky_peak",
        "GSP1",
        "Sky Peak (Pic Céleste)",
        "Grande Citadelle-Arbre QG — Cocons Tressés & Gracidées du Pic Céleste",
        "Arbre-QG d'altitude aux rochers alpins gris-bleutés ciselés et feuillage menthe-émeraude constellé de Gracidées rose corail à 5 pétales, escalier hélicoïdal, balcon rond et cocons sphériques coiffés de feuilles courbes.",
        4,
        "05_sp_qg.webp",
        (352, 352),
        0.74,
    ),
    (
        "06_grand_arbre_pont_gracidees_sky_peak",
        "GSP2",
        "Sky Peak (Pic Céleste)",
        "Grand Arbre des Nuages — Dômes de Feuilles & Pont aux Rubans Célestes",
        "Large arbre-relais de haute montagne à triple couronne menthe-émeraude et Gracidées, escaliers jumeaux, deux pavillons sphériques à coupole végétale, pont suspendu orné de rubans blancs du ciel et terrasse d'observation.",
        3,
        "06_sp_pont.webp",
        (432, 248),
        0.72,
    ),
    (
        "07_arbre_relais_pergola_panoramique_sky_peak",
        "GSP3",
        "Sky Peak (Pic Céleste)",
        "Grand Arbre-Relais Panoramique — Galerie Ronde, Dômes & Pergola Fleurie",
        "Relais d'expédition du Pic Céleste combinant galerie cylindrique vitrée dans le tronc, deux dômes habitables en pierre claire et feuilles courbes, et une pergola plate en bois fleurie de Gracidées.",
        3,
        "07_sp_pergola.webp",
        (352, 352),
        0.74,
    ),
    (
        "08_observatoire_cimes_cocon_sky_peak",
        "GSP4",
        "Sky Peak (Pic Céleste)",
        "Arbre-Observatoire des Cimes — Escalier Spirale, Cocon & Rubans du Ciel",
        "Tour-observatoire céleste à escalier en colimaçon longeant l'écorce sur 4 paliers, cocon suspendu sous feuille courbe, rubans d'altitude flottant au vent et plateforme ronde ouverte sous les Gracidées.",
        4,
        "08_sp_observatoire.webp",
        (272, 352),
        0.76,
    ),
]


def dilate_mask(mask: np.ndarray, radius: int) -> np.ndarray:
    if radius <= 0:
        return mask.copy()
    im = Image.fromarray((mask.astype(np.uint8) * 255), mode="L")
    return np.array(im.filter(ImageFilter.MaxFilter(2 * radius + 1))) > 127


def connected_components_8(mask: np.ndarray) -> tuple[np.ndarray, list[int]]:
    """Étiquetage 8-connexe pur NumPy/Python rapide (sans dépendance scipy/cv2)."""
    H, W = mask.shape
    labels = np.zeros((H, W), dtype=np.int32)
    sizes = [0]
    cid = 0
    ys, xs = np.where(mask)
    for sy, sx in zip(ys.tolist(), xs.tolist()):
        if labels[sy, sx] != 0:
            continue
        cid += 1
        q = deque([(sy, sx)])
        labels[sy, sx] = cid
        cnt = 0
        while q:
            y, x = q.popleft()
            cnt += 1
            y0 = max(0, y - 1)
            y1 = min(H - 1, y + 1)
            x0 = max(0, x - 1)
            x1 = min(W - 1, x + 1)
            for ny in range(y0, y1 + 1):
                for nx in range(x0, x1 + 1):
                    if mask[ny, nx] and labels[ny, nx] == 0:
                        labels[ny, nx] = cid
                        q.append((ny, nx))
        sizes.append(cnt)
    return labels, sizes


def extract_clean_hd_rgba(raw_rgb: np.ndarray) -> Image.Image:
    """Extrait le sprite complet sur fond #0000FF avec alpha binaire {0, 255}, 0 frange bleue et palette 255 couleurs."""
    r = raw_rgb[:, :, 0].astype(np.int16)
    g = raw_rgb[:, :, 1].astype(np.int16)
    b = raw_rgb[:, :, 2].astype(np.int16)

    is_blue_bg = (b > 165) & (r < 75) & (g < 85) & ((b - np.maximum(r, g)) > 95)
    fg = ~is_blue_bg

    # Suppression d'une éventuelle micro-frange bleue sur le contour immédiat (2 passes)
    for _ in range(2):
        adj_bg = fg & dilate_mask(~fg, 1)
        fringe = adj_bg & ((b - np.maximum(r, g)) > 26) & (b > 80)
        if not np.any(fringe):
            break
        fg[fringe] = False

    # Suppression des micro-poussières isolées (< 32 px en HD) tout en conservant fleurs/rochers périphériques
    labels, sizes = connected_components_8(fg)
    keep_lut = np.array([s >= 32 for s in sizes], dtype=bool)
    keep_lut[0] = False
    fg = keep_lut[labels]

    # Recadrage serré exact autour de l'ensemble du monument
    ys, xs = np.where(fg)
    x0, y0, x1, y1 = int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1
    crop_rgb = raw_rgb[y0:y1, x0:x1].copy()
    mask = fg[y0:y1, x0:x1].copy()

    # Dé-contamination chromatique intégrale : aucun pixel opaque ne garde une dominante bleue de fond (B - max(R,G) > 16)
    cr = crop_rgb[:, :, 0].astype(np.int16)
    cg = crop_rgb[:, :, 1].astype(np.int16)
    cb = crop_rgb[:, :, 2].astype(np.int16)
    spill = mask & ((cb - np.maximum(cr, cg)) > 16) & (cb > 68)
    valid = mask & (~spill)
    offsets = [(0, -1), (0, 1), (-1, 0), (1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)]
    H, W = mask.shape
    for _ in range(8):
        need = mask & (~valid)
        if not np.any(need):
            break
        pad_rgb = np.pad(crop_rgb, ((1, 1), (1, 1), (0, 0)), mode="edge")
        pad_val = np.pad(valid, ((1, 1), (1, 1)), mode="constant", constant_values=False)
        for dy, dx in offsets:
            cand = pad_val[1 + dy : H + 1 + dy, 1 + dx : W + 1 + dx]
            take = need & cand
            if np.any(take):
                crop_rgb[take] = pad_rgb[1 + dy : H + 1 + dy, 1 + dx : W + 1 + dx][take]
                valid[take] = True
                need = mask & (~valid)
    # Sécurité finale : si un pixel restait au-delà de 8 anneaux, rabattre son canal B
    rem = mask & (~valid)
    if np.any(rem):
        crop_rgb[rem, 2] = np.minimum(crop_rgb[rem, 2], np.maximum(crop_rgb[rem, 0], crop_rgb[rem, 1]) + 12)

    # Quantification sans tramage 48 couleurs franches style NDS Chunsoft (netteté pixel-art + compacité optimale)
    q_rgb = np.array(
        Image.fromarray(crop_rgb, mode="RGB")
        .quantize(colors=48, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE)
        .convert("RGB")
    )
    qr, qg, qb = q_rgb[:, :, 0].astype(np.int16), q_rgb[:, :, 1].astype(np.int16), q_rgb[:, :, 2].astype(np.int16)
    sp2 = mask & ((qb - np.maximum(qr, qg)) > 16) & (qb > 68)
    if np.any(sp2):
        q_rgb[sp2, 2] = np.minimum(qb[sp2], np.maximum(qr[sp2], qg[sp2]) + 12).astype(np.uint8)

    out = np.zeros((H, W, 4), dtype=np.uint8)
    out[mask, :3] = q_rgb[mask]
    out[mask, 3] = 255
    return Image.fromarray(out, mode="RGBA")


def assert_clean_rgba(im: Image.Image, label_name: str) -> None:
    arr = np.array(im)
    alpha = arr[:, :, 3]
    unique_a = set(np.unique(alpha).tolist())
    if not unique_a.issubset({0, 255}):
        raise AssertionError(f"{label_name}: alpha non binaire détecté: {sorted(unique_a)[:10]}")
    opaque = alpha == 255
    if not np.any(opaque):
        raise AssertionError(f"{label_name}: image entièrement vide!")
    r = arr[:, :, 0].astype(np.int16)
    g = arr[:, :, 1].astype(np.int16)
    b = arr[:, :, 2].astype(np.int16)
    # Zéro frange bleue #0000FF résiduelle
    bad_blue = opaque & ((b - np.maximum(r, g)) > 20) & (b > 95) & (r < 80)
    if np.any(bad_blue):
        raise AssertionError(f"{label_name}: {int(bad_blue.sum())} pixels de frange bleue détectés!")


def detect_window_cavities_for_night(im: Image.Image) -> np.ndarray:
    """Détecte les vitres rondes à croisillons et ouvertures intérieures des cocons/portes pour l'éclairage nocturne."""
    arr = np.array(im)
    H, W, _ = arr.shape
    opaque = arr[:, :, 3] == 255
    r = arr[:, :, 0].astype(np.int16)
    g = arr[:, :, 1].astype(np.int16)
    b = arr[:, :, 2].astype(np.int16)

    # Poche sombre intérieure entourée de boiserie/mur clair (pas une ombre de feuillage!)
    lum = (r + g + b) // 3
    dark_pocket = opaque & (lum < 46) & ((g - r) < 12)
    labels, sizes = connected_components_8(dark_pocket)

    # Boiserie / paroi claire adjacente (bois chaud, mur crème de hutte, pierre d'arche)
    warm_wall = opaque & (r > 92) & (g > 68) & ((r >= b - 10))
    adj_wall = dilate_mask(warm_wall, 2)

    glow_cavities = np.zeros((H, W), dtype=bool)
    for cid in range(1, len(sizes)):
        area = sizes[cid]
        if area < 45 or area > 9500:
            continue
        comp = labels == cid
        ys, xs = np.where(comp)
        cy = float(ys.mean()) / H
        bw = int(xs.max() - xs.min() + 1)
        bh = int(ys.max() - ys.min() + 1)
        aspect = max(bw, bh) / max(1, min(bw, bh))
        # Fenêtre ronde, porte de cocon ou arche d'entrée : forme compacte (pas un trait d'outline allongé!)
        if cy < 0.20 or cy > 0.96 or aspect > 2.6:
            continue
        fill_ratio = area / max(1.0, float(bw * bh))
        if fill_ratio < 0.34:
            continue
        border = dilate_mask(comp, 1) & (~comp)
        if not np.any(border):
            continue
        wall_frac = float(np.sum(border & adj_wall)) / float(np.sum(border))
        if wall_frac >= 0.55:
            glow_cavities |= comp
    return glow_cavities


def make_night_glowing(im: Image.Image, biome: str) -> Image.Image:
    """Crée la variante Nuit PMD : clair de lune sylvestre/alpin + rosaces, hublots et cocons illuminés d'or chaud."""
    arr = np.array(im).copy()
    opaque = arr[:, :, 3] == 255
    r = arr[:, :, 0].astype(np.float32)
    g = arr[:, :, 1].astype(np.float32)
    b = arr[:, :, 2].astype(np.float32)

    # 1. Sources déjà lumineuses (uniquement vitrail doré chaud type rosace : R>232, G>192, B<155 — jamais fleurs ni feuilles!)
    existing_lamp = opaque & (r > 232) & (g > 192) & (b < 155) & ((r - b) > 85) & ((r - g) >= -6)
    cavities = detect_window_cavities_for_night(im)
    all_lamps = existing_lamp | cavities

    halo_inner = dilate_mask(all_lamps, 3) & opaque & (~all_lamps)
    halo_outer = dilate_mask(all_lamps, 7) & opaque & (~all_lamps) & (~halo_inner)

    # 2. Clair de lune PMD adapté au biome (bleu-argenté céleste pour Sky Peak, bleu-nuit émeraude doux pour Jardin Secret)
    if "Sky Peak" in biome:
        nr = np.clip(r * 0.44 + 8.0, 0, 255)
        ng = np.clip(g * 0.62 + 18.0, 0, 255)
        nb = np.clip(b * 0.80 + 28.0, 0, 255)
    else:
        nr = np.clip(r * 0.42 + 6.0, 0, 255)
        ng = np.clip(g * 0.58 + 15.0, 0, 255)
        nb = np.clip(b * 0.75 + 24.0, 0, 255)

    # Légère luminescence féerique des pétales roses/corail/blancs la nuit
    blossom = opaque & (((r > 195) & (r - g > 35)) | ((r > 215) & (g > 215) & (b > 195)))
    nr[blossom] = np.clip(r[blossom] * 0.76 + 22.0, 0, 255)
    ng[blossom] = np.clip(g[blossom] * 0.72 + 18.0, 0, 255)
    nb[blossom] = np.clip(b[blossom] * 0.84 + 24.0, 0, 255)

    # 3. Halo chaud ambré sur les rebords en bois des hublots, portes et rosaces
    nr[halo_outer] = np.clip(nr[halo_outer] * 0.65 + r[halo_outer] * 0.42 + 26.0, 0, 255)
    ng[halo_outer] = np.clip(ng[halo_outer] * 0.68 + g[halo_outer] * 0.34 + 14.0, 0, 255)
    nb[halo_outer] = np.clip(nb[halo_outer] * 0.72 + 6.0, 0, 255)

    nr[halo_inner] = np.clip(r[halo_inner] * 0.85 + 52.0, 0, 255)
    ng[halo_inner] = np.clip(g[halo_inner] * 0.70 + 28.0, 0, 255)
    nb[halo_inner] = np.clip(b[halo_inner] * 0.45 + 10.0, 0, 255)

    # 4. Allumage chaleureux doré-miel des cavités de fenêtres/cocons (dégradé doux du cœur vers le bord)
    if np.any(cavities):
        inner_core = ~dilate_mask(~cavities, 2)
        nr[cavities] = 246.0
        ng[cavities] = 178.0
        nb[cavities] = 74.0
        nr[inner_core] = 255.0
        ng[inner_core] = 224.0
        nb[inner_core] = 126.0

    # Rosaces déjà dorées conservées à pleine brillance chaude
    nr[existing_lamp] = np.clip(r[existing_lamp] * 1.05 + 14.0, 0, 255)
    ng[existing_lamp] = np.clip(g[existing_lamp] * 1.00 + 8.0, 0, 255)
    nb[existing_lamp] = np.clip(b[existing_lamp] * 0.82 + 6.0, 0, 255)

    rgb_night = np.stack([nr, ng, nb], axis=-1).astype(np.uint8)
    q_night = np.array(
        Image.fromarray(rgb_night, mode="RGB")
        .quantize(colors=48, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE)
        .convert("RGB")
    )
    # Sécurité anti-frange bleue sur les pixels sombres refroidis
    qr, qg, qb = q_night[:, :, 0].astype(np.int16), q_night[:, :, 1].astype(np.int16), q_night[:, :, 2].astype(np.int16)
    excess_b = opaque & ((qb - np.maximum(qr, qg)) > 20) & (qb > 95) & (qr < 80)
    if np.any(excess_b):
        q_night[excess_b, 2] = np.minimum(qb[excess_b], np.maximum(qr[excess_b], qg[excess_b]) + 18).astype(np.uint8)

    out = np.zeros_like(arr)
    out[opaque, :3] = q_night[opaque]
    out[opaque, 3] = 255
    return Image.fromarray(out, mode="RGBA")


def downsample_pmdo_grid(hd_im: Image.Image, max_wh: tuple[int, int]) -> Image.Image:
    """Réduit sans flou à l'échelle pixel-art PMDO 8×8, quantifie en 128 couleurs franches et cadre multiple de 8 px."""
    scale = min(max_wh[0] / hd_im.width, max_wh[1] / hd_im.height)
    sw = max(8, round(hd_im.width * scale))
    sh = max(8, round(hd_im.height * scale))
    resized = hd_im.resize((sw, sh), NN)

    arr = np.array(resized)
    opaque = arr[:, :, 3] >= 128
    q_rgb = np.array(
        Image.fromarray(arr[:, :, :3], mode="RGB")
        .quantize(colors=48, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE)
        .convert("RGB")
    )

    labels, sizes = connected_components_8(opaque)
    keep_lut = np.array([s >= 3 for s in sizes], dtype=bool)
    keep_lut[0] = False
    opaque = keep_lut[labels]

    qr, qg, qb = q_rgb[:, :, 0].astype(np.int16), q_rgb[:, :, 1].astype(np.int16), q_rgb[:, :, 2].astype(np.int16)
    excess_b = opaque & ((qb - np.maximum(qr, qg)) > 20) & (qb > 95) & (qr < 80)
    if np.any(excess_b):
        q_rgb[excess_b, 2] = np.minimum(qb[excess_b], np.maximum(qr[excess_b], qg[excess_b]) + 16).astype(np.uint8)

    cw = int(math.ceil((sw + 8) / 8.0)) * 8
    ch = int(math.ceil((sh + 16) / 8.0)) * 8
    canvas = np.zeros((ch, cw, 4), dtype=np.uint8)
    ox = (cw - sw) // 2
    oy = ch - 8 - sh
    sub = np.zeros((sh, sw, 4), dtype=np.uint8)
    sub[opaque, :3] = q_rgb[opaque]
    sub[opaque, 3] = 255
    canvas[oy : oy + sh, ox : ox + sw] = sub
    return Image.fromarray(canvas, mode="RGBA")


def split_visible_surface_layers(im_1x: Image.Image, split_ratio_y: float) -> tuple[Image.Image, Image.Image, int]:
    """Découpe les pixels visibles en `Avant_Base` (bas, sous le joueur/devant sol) et `Arriere_Under` (haut/canopée).

    Partition stricte sur frontière multiple de 8 px : `avant | arriere == complet` et `avant & arriere == 0`.
    Note : séparation de surface visible uniquement (ne reconstruit pas les pixels occultés derrière les éléments).
    """
    arr = np.array(im_1x)
    h, _, _ = arr.shape
    ys, _ = np.where(arr[:, :, 3] > 0)
    top_y, bot_y = int(ys.min()), int(ys.max()) + 1
    raw_cut = top_y + int((bot_y - top_y) * split_ratio_y)
    cut_y = max(8, min(h - 8, (raw_cut // 8) * 8))

    avant_base = np.zeros_like(arr)
    arriere_under = np.zeros_like(arr)
    avant_base[cut_y:, :, :] = arr[cut_y:, :, :]
    arriere_under[:cut_y, :, :] = arr[:cut_y, :, :]
    return Image.fromarray(arriere_under, mode="RGBA"), Image.fromarray(avant_base, mode="RGBA"), cut_y


def save_compact_rgba_png(im: Image.Image, path: Path) -> None:
    """Sauvegarde PNG indexé 8 bits avec transparence binaire exacte tRNS[0]=0 (100 % sans perte pixel par pixel)."""
    path.parent.mkdir(parents=True, exist_ok=True)
    arr = np.array(im.convert("RGBA"))
    H, W, _ = arr.shape
    opaque = arr[:, :, 3] == 255
    packed = (
        (arr[:, :, 0].astype(np.uint32) << 16)
        | (arr[:, :, 1].astype(np.uint32) << 8)
        | arr[:, :, 2].astype(np.uint32)
    )
    uniq_cols, inv = np.unique(packed[opaque], return_inverse=True)
    if len(uniq_cols) <= 255:
        pal = np.zeros((256, 3), dtype=np.uint8)
        for idx_c, cval in enumerate(uniq_cols.tolist(), start=1):
            pal[idx_c, 0] = (cval >> 16) & 0xFF
            pal[idx_c, 1] = (cval >> 8) & 0xFF
            pal[idx_c, 2] = cval & 0xFF
        idx_img = np.zeros((H, W), dtype=np.uint8)
        idx_img[opaque] = (inv + 1).astype(np.uint8)
        p_im = Image.fromarray(idx_img, mode="P")
        p_im.putpalette(pal.ravel().tolist())
        p_im.save(path, format="PNG", transparency=0, optimize=True, compress_level=9)
    else:
        im.save(path, format="PNG", optimize=True, compress_level=9)


def _encode_tiny_8x8_png(tile_rgba: np.ndarray) -> bytes:
    """Encode une tuile 8×8 RGBA en PNG indexé 4-bit/8-bit sans perte (identique bit à bit au décodage RGBA)."""
    import zlib

    opaque = tile_rgba[:, :, 3] == 255
    if not np.any(opaque):
        bit_depth = 1
        pal_bytes = b"\x00\x00\x00"
        trns_bytes = b"\x00"
        raw_rows = b"\x00\x00" * 8
    else:
        packed = (
            (tile_rgba[:, :, 0].astype(np.uint32) << 16)
            | (tile_rgba[:, :, 1].astype(np.uint32) << 8)
            | tile_rgba[:, :, 2].astype(np.uint32)
        )
        uniq, inv = np.unique(packed[opaque], return_inverse=True)
        has_trans = not bool(np.all(opaque))
        entries: list[bytes] = []
        if has_trans:
            entries.append(b"\x00\x00\x00")
            idx_grid = np.zeros((8, 8), dtype=np.uint8)
            idx_grid[opaque] = (inv + 1).astype(np.uint8)
            trns_bytes = b"\x00"
        else:
            idx_grid = inv.reshape(8, 8).astype(np.uint8)
            trns_bytes = b""
        for cval in uniq.tolist():
            entries.append(bytes([(cval >> 16) & 0xFF, (cval >> 8) & 0xFF, cval & 0xFF]))
        pal_bytes = b"".join(entries)
        if len(entries) <= 16:
            bit_depth = 4
            nibbles = (idx_grid[:, 0::2] << 4) | idx_grid[:, 1::2]
            raw_rows = b"".join(b"\x00" + nibbles[y].tobytes() for y in range(8))
        else:
            bit_depth = 8
            raw_rows = b"".join(b"\x00" + idx_grid[y].tobytes() for y in range(8))

    def chunk(tag: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", 8, 8, bit_depth, 3, 0, 0, 0)
    out = [b"\x89PNG\r\n\x1a\n", chunk(b"IHDR", ihdr), chunk(b"PLTE", pal_bytes)]
    if trns_bytes:
        out.append(chunk(b"tRNS", trns_bytes))
    out.append(chunk(b"IDAT", zlib.compress(raw_rows, level=9)))
    out.append(chunk(b"IEND", b""))
    return b"".join(out)


def write_pmdo_tile(im: Image.Image, path: Path) -> int:
    """Encode une banque binaire `.tile` PMDO 8×8 dédupliquée."""
    assert im.width % 8 == 0 and im.height % 8 == 0
    arr = np.array(im.convert("RGBA"))
    cells = [
        (x, y, arr[y * 8 : y * 8 + 8, x * 8 : x * 8 + 8])
        for y in range(im.height // 8)
        for x in range(im.width // 8)
    ]
    header = struct.pack("<II", 8, len(cells))
    entries = []
    payload = bytearray()
    offsets: dict[bytes, int] = {}
    for x, y, tile_arr in cells:
        sig = tile_arr.tobytes()
        if sig not in offsets:
            offsets[sig] = 8 + 16 * len(cells) + len(payload)
            raw = _encode_tiny_8x8_png(tile_arr)
            payload.extend(struct.pack("<q", len(raw)) + raw)
        entries.append(struct.pack("<IIQ", x, y, offsets[sig]))
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(header + b"".join(entries) + payload)
    return len(offsets)


def write_tsj(png_name: str, w: int, h: int, name: str, path: Path) -> None:
    doc = {
        "type": "tileset",
        "version": "1.10",
        "tiledversion": "1.10.2",
        "name": name,
        "tilewidth": 8,
        "tileheight": 8,
        "tilecount": (w // 8) * (h // 8),
        "columns": w // 8,
        "margin": 0,
        "spacing": 0,
        "image": png_name,
        "imagewidth": w,
        "imageheight": h,
    }
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(doc, indent=2) + "\n", encoding="utf-8")


def compose_overview_sheet(sprites: list[Image.Image], cols: int = 4, pad: int = 16) -> Image.Image:
    rows = math.ceil(len(sprites) / cols)
    cell_w = max(im.width for im in sprites)
    cell_h = max(im.height for im in sprites)
    W = int(math.ceil((cols * cell_w + (cols + 1) * pad) / 8.0)) * 8
    H = int(math.ceil((rows * cell_h + (rows + 1) * pad) / 8.0)) * 8
    sheet = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    for idx, im in enumerate(sprites):
        r, c = divmod(idx, cols)
        ox = pad + c * (cell_w + pad) + (cell_w - im.width) // 2
        oy = pad + r * (cell_h + pad) + (cell_h - im.height)
        sheet.paste(im, (ox, oy), im)
    return sheet


def b64_png(path: Path) -> str:
    return "data:image/png;base64," + base64.b64encode(path.read_bytes()).decode("ascii")


def build_readme(items: list[dict[str, Any]]) -> str:
    lines = [
        "# Treehouses Monumentales de Guilde — Styles Jardin Secret & Sky Peak (PMDO 0.8.12 / Halcyon 8×8)",
        "",
        "## Direction artistique & contraintes respectées",
        "- **Zéro toiture pyramidale / pointue / triangulaire** : 100 % architectures organiques rondes (coupoles de feuilles courbes, cocons tressés sphériques, chambres-glands galbées, galeries cylindriques, pergolas plates et belvédères circulaires).",
        "- **4 structures Style Jardin Secret (`GJS1`–`GJS4`)** : feuillage vert pomme/chartreuse lumineux, grappes florales corail/lilas/or, racines moussues et rochers gréseux chauds.",
        "- **4 structures Style Sky Peak / Pic Céleste (`GSP1`–`GSP4`)** : feuillage menthe-émeraude d'altitude, bouquets de Gracidées rose corail à 5 pétales, rubans blancs du ciel et rochers alpins gris-bleutés ciselés.",
        "- **Transparence native stricte** : PNG `RGBA` 100 % sans fond (`alpha ∈ {0, 255}`, `0 px` de halo chromatique).",
        "- **Découpe de calques (`Arriere_Under` / `Avant_Base`)** : séparation de surface visible sur frontière multiple de `8 px` (`Avant_Base ∪ Arriere_Under == Complet`, `∩ == ∅`). Cette découpe ne reconstruit pas les pixels occultés derrière les éléments de premier plan.",
        "- **Statut d'intégration moteur** : `art_approved: false`, `runtime_tested: false` (prêt à importer dans `Content/Tile/` PMDO 0.8.12 / Tiled).",
        "",
        "## Catalogue des 8 structures monumentales",
        "",
        "| Code `.tile` | Biome | Structure | Étages | Dimensions 1× PMDO (`8×8`) | Dimensions HD |",
        "|---|---|---|---:|---:|---:|",
    ]
    for it in items:
        cw, ch = it["canvas_1x_px"]
        hw, hh = it["size_hd_px"]
        lines.append(
            f"| `{it['pfx']}` | {it['biome']} | {it['title']} | {it['floors']} | `{cw}×{ch} px` (`{cw//8}×{ch//8}` tuiles) | `{hw}×{hh} px` |"
        )
    lines.append("")
    return "\n".join(lines)


def build_html_gallery(
    items: list[dict[str, Any]],
    sheet_jour_uri: str,
    sheet_nuit_uri: str,
    sheet_jour_rel: str,
    sheet_nuit_rel: str,
    zip_rel: str,
) -> str:
    cards_html: list[str] = []
    js_entries: list[dict[str, Any]] = []

    for it in items:
        sid = it["slug"]
        cw, ch = it["canvas_1x_px"]
        hw, hh = it["size_hd_px"]
        is_sp = "Sky Peak" in it["biome"]
        biome_cls = "badge-sp" if is_sp else "badge-js"
        uris = it["data_uris"]
        dl = it["downloads_rel"]
        js_entries.append(
            {
                "slug": sid,
                "w1x": cw,
                "h1x": ch,
                "uris": uris,
                "dl": dl,
            }
        )
        disp_w = min(620, round(cw * 1.65))
        disp_h = round(ch * (disp_w / cw))
        cards_html.append(
            f"""
        <article class="card" id="card-{sid}" data-biome="{'skypeak' if is_sp else 'jardin'}">
          <div class="card-head">
            <div class="badges">
              <span class="badge-pfx">{it["pfx"]}</span>
              <span class="badge-biome {biome_cls}">{it["biome"]}</span>
              <span class="badge-floors">{it["floors"]} niveaux</span>
            </div>
            <div class="dims">
              1× PMDO : <strong>{cw} × {ch} px</strong> ({cw // 8} × {ch // 8} tuiles 8px)<br>
              HD RGBA : <strong>{hw} × {hh} px</strong>
            </div>
          </div>
          <h2>{it["title"]}</h2>
          <p class="desc">{it["desc"]}</p>
          <div class="stage" id="stage-{sid}">
            <img id="img-{sid}" class="sprite-img" src="{uris['1x_jour']}"
                 alt="{it['title']}" width="{disp_w}" height="{disp_h}">
          </div>
          <div class="mode-row">
            <button type="button" class="mbtn active" data-card="{sid}" data-mode="1x_jour">Jour (1×)</button>
            <button type="button" class="mbtn" data-card="{sid}" data-mode="1x_nuit">Nuit illuminée (1×)</button>
            <button type="button" class="mbtn" data-card="{sid}" data-mode="1x_avant">Base (Avant_Base)</button>
            <button type="button" class="mbtn" data-card="{sid}" data-mode="1x_arriere">Canopée (Arriere_Under)</button>
          </div>
          <div class="dl-row">
            <a class="dl-primary" href="{dl['hd_jour']}?dl=1" download>HD Jour ({hw}×{hh})</a>
            <a href="{dl['hd_nuit']}?dl=1" download>HD Nuit ({hw}×{hh})</a>
            <a href="{dl['1x_jour']}?dl=1" download>1× Jour ({cw}×{ch})</a>
            <a href="{dl['1x_nuit']}?dl=1" download>1× Nuit</a>
            <a href="{dl['1x_avant']}?dl=1" download>1× Avant_Base</a>
            <a href="{dl['1x_arriere']}?dl=1" download>1× Arriere_Under</a>
            <a href="{dl['tile_jour']}?dl=1" download>{it["pfx"]}_Jour.tile</a>
            <a href="{dl['tile_nuit']}?dl=1" download>{it["pfx"]}_Nuit.tile</a>
          </div>
        </article>"""
        )

    payload_json = json.dumps(js_entries, ensure_ascii=False)
    return f"""<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Treehouses de Guilde — Styles Jardin Secret &amp; Sky Peak (100 % Organiques Sans Toit Pyramidal · PMDO RGBA)</title>
<style>
  :root {{
    color-scheme: dark;
    --bg: #111622;
    --panel: #192131;
    --stage-day: #161b26;
    --stage-night: #0d1220;
    --line: #2d3b54;
    --mint: #6ef0a3;
    --lime: #b2ef63;
    --pink: #ff8ba7;
    --gold: #f5ca69;
    --text: #eef3fb;
    --muted: #a9b7cf;
  }}
  * {{ box-sizing: border-box; }}
  body {{
    margin: 0;
    background: var(--bg);
    color: var(--text);
    font: 15px/1.55 system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  }}
  main {{ max-width: 1460px; margin: 0 auto; padding: 26px 20px 68px; }}
  header, .sheet-box {{
    background: var(--panel);
    border: 1px solid var(--line);
    border-radius: 14px;
    padding: 22px 26px;
    margin-bottom: 22px;
  }}
  .eyebrow {{ color: var(--mint); font-weight: 800; letter-spacing: 1.8px; font-size: 12px; text-transform: uppercase; }}
  h1 {{ margin: 8px 0 10px; font-size: 29px; line-height: 1.2; color: #ffffff; }}
  header p {{ margin: 6px 0; color: var(--muted); max-width: 1040px; }}
  .hero-actions {{ display: flex; flex-wrap: wrap; gap: 10px; margin-top: 16px; }}
  .btn-pack {{
    display: inline-block;
    background: var(--gold);
    color: #181206;
    font-weight: 800;
    padding: 10px 18px;
    border-radius: 9px;
    text-decoration: none;
  }}
  .btn-sec {{
    display: inline-block;
    background: #232f45;
    color: var(--text);
    border: 1px solid var(--line);
    font-weight: 700;
    padding: 10px 15px;
    border-radius: 9px;
    text-decoration: none;
  }}
  .toolbar {{
    position: sticky;
    top: 8px;
    z-index: 20;
    display: flex;
    flex-wrap: wrap;
    gap: 10px 18px;
    align-items: center;
    background: #1d273b;
    border: 1px solid #3c5073;
    border-radius: 12px;
    padding: 11px 16px;
    margin-bottom: 22px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.45);
  }}
  .group {{ display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }}
  .group span {{ font-size: 12px; font-weight: 800; color: var(--gold); text-transform: uppercase; margin-right: 4px; }}
  button {{
    font: inherit;
    font-size: 13px;
    font-weight: 600;
    padding: 6px 12px;
    border-radius: 7px;
    border: 1px solid #3c5073;
    background: #25324a;
    color: var(--text);
    cursor: pointer;
  }}
  button.active {{
    background: var(--mint);
    color: #0b1c14;
    border-color: var(--mint);
    font-weight: 800;
  }}
  .sheet-grid {{
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(460px, 1fr));
    gap: 18px;
    margin-top: 12px;
  }}
  .sheet-card {{
    background: var(--stage-day);
    border: 1px solid var(--line);
    border-radius: 10px;
    padding: 14px;
    text-align: center;
  }}
  .sheet-card.night {{ background: var(--stage-night); }}
  .sheet-card img {{
    max-width: 100%;
    height: auto;
    image-rendering: pixelated;
    image-rendering: crisp-edges;
  }}
  .grid {{
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(580px, 1fr));
    gap: 20px;
  }}
  .card {{
    background: var(--panel);
    border: 1px solid var(--line);
    border-radius: 14px;
    padding: 18px 20px;
    display: flex;
    flex-direction: column;
    gap: 11px;
  }}
  .card-head {{ display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; }}
  .badges {{ display: flex; flex-wrap: wrap; gap: 6px; align-items: center; }}
  .badge-pfx {{
    background: #2b3b57;
    color: var(--gold);
    border: 1px solid var(--gold);
    border-radius: 6px;
    padding: 2px 8px;
    font: 700 12px/1.4 ui-monospace, SFMono-Regular, Menlo, monospace;
  }}
  .badge-biome {{
    border-radius: 6px;
    padding: 2px 9px;
    font-size: 12px;
    font-weight: 800;
  }}
  .badge-js {{ background: #263d21; color: var(--lime); border: 1px solid #6cb349; }}
  .badge-sp {{ background: #1e3b40; color: var(--mint); border: 1px solid var(--pink); }}
  .badge-floors {{
    background: #253047;
    color: var(--muted);
    border-radius: 6px;
    padding: 2px 8px;
    font-size: 12px;
  }}
  .dims {{ font-size: 12px; color: var(--muted); text-align: right; }}
  .card h2 {{ margin: 0; font-size: 18px; color: #ffffff; }}
  .desc {{ margin: 0; font-size: 13.5px; color: var(--muted); }}
  .stage {{
    background: var(--stage-day);
    border: 1px solid var(--line);
    border-radius: 10px;
    min-height: 300px;
    padding: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow-x: auto;
  }}
  .stage.night {{ background: var(--stage-night); }}
  .sprite-img {{
    max-width: 100%;
    height: auto;
    image-rendering: pixelated;
    image-rendering: crisp-edges;
  }}
  .mode-row, .dl-row {{ display: flex; flex-wrap: wrap; gap: 7px; }}
  .dl-row a {{
    font-size: 12.5px;
    color: var(--text);
    background: #243048;
    border: 1px solid var(--line);
    padding: 5px 10px;
    border-radius: 7px;
    text-decoration: none;
  }}
  .dl-row a.dl-primary {{
    background: var(--gold);
    color: #181206;
    border-color: var(--gold);
    font-weight: 800;
  }}
</style>
</head>
<body>
<main>
  <header>
    <div class="eyebrow">Collection PMDO 0.8.12 / Halcyon 8×8 · Zéro Toiture Pyramidale · 100 % RGBA Sans Fond</div>
    <h1>Treehouses Monumentales de Guilde — Styles « Jardin Secret » &amp; « Sky Peak »</h1>
    <p>
      8 grandes architectures d'arbres-guildes multi-niveaux conçues <strong>sans aucune toiture pyramidale, conique ou pointue</strong> :
      coupoles de feuilles courbes, cocons tressés sphériques, chambres-glands à rosace florale dorée, galeries cylindriques vitrées,
      escaliers hélicoïdaux en écorce, ponts suspendus fleuris et belvédères circulaires.
    </p>
    <p>
      <strong>4 structures Jardin Secret (`GJS1`–`GJS4`)</strong> (feuillage vert tendre &amp; fleurs corail/lilas/or sur grès chaud) et
      <strong>4 structures Sky Peak / Pic Céleste (`GSP1`–`GSP4`)</strong> (feuillage menthe-émeraude, bouquets de Gracidées à 5 pétales, rubans du ciel &amp; rochers alpins gris-bleutés).
      Transparence binaire stricte <code>alpha ∈ {{0, 255}}</code>, <code>0 px</code> de halo chromatique. Découpes <code>Avant_Base</code> / <code>Arriere_Under</code> de surface visible uniquement.
    </p>
    <div class="hero-actions">
      <a class="btn-pack" href="{zip_rel}?dl=1" download>Télécharger le Pack Complet ZIP (1× + HD + .tile + .tsj)</a>
      <a class="btn-sec" href="{sheet_jour_rel}?dl=1" download>Planche Complète 1× Jour (PNG RGBA)</a>
      <a class="btn-sec" href="{sheet_nuit_rel}?dl=1" download>Planche Complète 1× Nuit (PNG RGBA)</a>
    </div>
  </header>

  <section class="toolbar" aria-label="Filtres et modes d'affichage">
    <div class="group">
      <span>Biome :</span>
      <button type="button" class="fbtn active" data-filter="all">Tous (8)</button>
      <button type="button" class="fbtn" data-filter="jardin">Jardin Secret (4)</button>
      <button type="button" class="fbtn" data-filter="skypeak">Sky Peak / Pic Céleste (4)</button>
    </div>
    <div class="group">
      <span>Mode global :</span>
      <button type="button" class="gbtn active" data-gmode="1x_jour">Jour (1×)</button>
      <button type="button" class="gbtn" data-gmode="1x_nuit">Nuit illuminée (1×)</button>
      <button type="button" class="gbtn" data-gmode="1x_avant">Base (Avant_Base)</button>
      <button type="button" class="gbtn" data-gmode="1x_arriere">Canopée (Arriere_Under)</button>
    </div>
    <div class="group">
      <span>Fond uni :</span>
      <button type="button" class="bgbtn active" data-bg="#161b26">Ardoise sombre</button>
      <button type="button" class="bgbtn" data-bg="#223026">Sous-bois sombre</button>
      <button type="button" class="bgbtn" data-bg="#1d2b3a">Brume céleste</button>
    </div>
  </section>

  <section class="sheet-box">
    <h2 style="margin:0 0 6px;font-size:19px">Planches Récapitulatives 1× PMDO (8 Structures Sans Fond RGBA)</h2>
    <div class="sheet-grid">
      <div class="sheet-card">
        <div style="margin-bottom:8px;font-weight:700;color:var(--lime)">Planche Complète Jour — Jardin Secret (haut) &amp; Sky Peak (bas)</div>
        <img src="{sheet_jour_uri}" alt="Planche complète Jour des 8 Treehouses Jardin Secret et Sky Peak">
      </div>
      <div class="sheet-card night">
        <div style="margin-bottom:8px;font-weight:700;color:var(--mint)">Planche Complète Nuit Illuminée — Hublots, Rosaces &amp; Clair de Lune</div>
        <img src="{sheet_nuit_uri}" alt="Planche complète Nuit des 8 Treehouses Jardin Secret et Sky Peak">
      </div>
    </div>
  </section>

  <section class="grid">
    {''.join(cards_html)}
  </section>
</main>

<script>
const ITEMS = {payload_json};
const BY_SLUG = Object.fromEntries(ITEMS.map(x => [x.slug, x]));
let customBg = "#161b26";

function setCardMode(slug, mode) {{
  const it = BY_SLUG[slug];
  if (!it) return;
  const img = document.getElementById("img-" + slug);
  const stg = document.getElementById("stage-" + slug);
  img.src = it.uris[mode];
  stg.style.background = (mode === "1x_nuit") ? "#0d1220" : customBg;
  document.querySelectorAll(`.mbtn[data-card="${{slug}}"]`).forEach(b => {{
    b.classList.toggle("active", b.dataset.mode === mode);
  }});
}}

document.querySelectorAll(".mbtn").forEach(btn => {{
  btn.addEventListener("click", () => setCardMode(btn.dataset.card, btn.dataset.mode));
}});

document.querySelectorAll(".gbtn").forEach(btn => {{
  btn.addEventListener("click", () => {{
    document.querySelectorAll(".gbtn").forEach(b => b.classList.toggle("active", b === btn));
    ITEMS.forEach(it => setCardMode(it.slug, btn.dataset.gmode));
  }});
}});

document.querySelectorAll(".fbtn").forEach(btn => {{
  btn.addEventListener("click", () => {{
    document.querySelectorAll(".fbtn").forEach(b => b.classList.toggle("active", b === btn));
    const f = btn.dataset.filter;
    document.querySelectorAll(".card").forEach(c => {{
      c.style.display = (f === "all" || c.dataset.biome === f) ? "" : "none";
    }});
  }});
}});

document.querySelectorAll(".bgbtn").forEach(btn => {{
  btn.addEventListener("click", () => {{
    document.querySelectorAll(".bgbtn").forEach(b => b.classList.toggle("active", b === btn));
    customBg = btn.dataset.bg;
    ITEMS.forEach(it => {{
      const activeMode = document.querySelector(`.mbtn.active[data-card="${{it.slug}}"]`)?.dataset.mode || "1x_jour";
      if (activeMode !== "1x_nuit") {{
        document.getElementById("stage-" + it.slug).style.background = customBg;
      }}
    }});
  }});
}});
</script>
</body>
</html>
"""


def main() -> None:
    import shutil
    shutil.rmtree(OUT_DIR, ignore_errors=True)
    OUT_1X.mkdir(parents=True, exist_ok=True)
    OUT_HD.mkdir(parents=True, exist_ok=True)
    OUT_MOD_TILE.mkdir(parents=True, exist_ok=True)

    items_meta: list[dict[str, Any]] = []
    sheets_1x_jour: list[Image.Image] = []
    sheets_1x_nuit: list[Image.Image] = []

    for slug, pfx, biome, title, desc, floors, raw_name, max_wh, split_y in STRUCTURES_SPEC:
        raw_path = BRUTS / raw_name
        raw_rgb = np.array(Image.open(raw_path).convert("RGB"))

        hd_jour = extract_clean_hd_rgba(raw_rgb)
        assert_clean_rgba(hd_jour, f"{slug}_HD_Jour")

        hd_nuit = make_night_glowing(hd_jour, biome=biome)
        assert_clean_rgba(hd_nuit, f"{slug}_HD_Nuit")

        im_1x_jour = downsample_pmdo_grid(hd_jour, max_wh=max_wh)
        assert_clean_rgba(im_1x_jour, f"{slug}_1x_Jour")

        im_1x_nuit = downsample_pmdo_grid(hd_nuit, max_wh=max_wh)
        assert_clean_rgba(im_1x_nuit, f"{slug}_1x_Nuit")

        arriere_under, avant_base, cut_y = split_visible_surface_layers(im_1x_jour, split_ratio_y=split_y)
        assert_clean_rgba(arriere_under, f"{slug}_1x_Arriere_Under")
        assert_clean_rgba(avant_base, f"{slug}_1x_Avant_Base")

        sheets_1x_jour.append(im_1x_jour)
        sheets_1x_nuit.append(im_1x_nuit)

        p_hd_jour = OUT_HD / f"{slug}_HD_jour.png"
        p_hd_nuit = OUT_HD / f"{slug}_HD_nuit.png"
        p_1x_jour = OUT_1X / f"{slug}_1x_jour.png"
        p_1x_nuit = OUT_1X / f"{slug}_1x_nuit.png"
        p_1x_avant = OUT_1X / f"{slug}_1x_Avant_Base.png"
        p_1x_arriere = OUT_1X / f"{slug}_1x_Arriere_Under.png"

        save_compact_rgba_png(hd_jour, p_hd_jour)
        save_compact_rgba_png(hd_nuit, p_hd_nuit)
        save_compact_rgba_png(im_1x_jour, p_1x_jour)
        save_compact_rgba_png(im_1x_nuit, p_1x_nuit)
        save_compact_rgba_png(avant_base, p_1x_avant)
        save_compact_rgba_png(arriere_under, p_1x_arriere)

        p_tile_jour = OUT_MOD_TILE / f"{pfx}_Jour.tile"
        p_tile_nuit = OUT_MOD_TILE / f"{pfx}_Nuit.tile"

        unique_j = write_pmdo_tile(im_1x_jour, p_tile_jour)
        unique_n = write_pmdo_tile(im_1x_nuit, p_tile_nuit)

        # PNG compagnons & descripteurs Tiled .tsj dans Mod_PMDO_Tile_Pret_A_Importer/Content/Tile/
        save_compact_rgba_png(im_1x_jour, OUT_MOD_TILE / f"{pfx}_Jour.png")
        save_compact_rgba_png(im_1x_nuit, OUT_MOD_TILE / f"{pfx}_Nuit.png")
        write_tsj(f"{pfx}_Jour.png", im_1x_jour.width, im_1x_jour.height, f"{pfx}_Jour", OUT_MOD_TILE / f"{pfx}_Jour.tsj")
        write_tsj(f"{pfx}_Nuit.png", im_1x_nuit.width, im_1x_nuit.height, f"{pfx}_Nuit", OUT_MOD_TILE / f"{pfx}_Nuit.tsj")

        items_meta.append(
            {
                "slug": slug,
                "pfx": pfx,
                "biome": biome,
                "title": title,
                "desc": desc,
                "floors": floors,
                "size_hd_px": [hd_jour.width, hd_jour.height],
                "canvas_1x_px": [im_1x_jour.width, im_1x_jour.height],
                "grid_tiles_8px": [im_1x_jour.width // 8, im_1x_jour.height // 8],
                "visible_surface_split_y_px": cut_y,
                "unique_8x8_tiles_jour": unique_j,
                "unique_8x8_tiles_nuit": unique_n,
                "art_approved": False,
                "runtime_tested": False,
                "occluded_pixels_reconstructed": False,
                "data_uris": {
                    "1x_jour": b64_png(p_1x_jour),
                    "1x_nuit": b64_png(p_1x_nuit),
                    "1x_avant": b64_png(p_1x_avant),
                    "1x_arriere": b64_png(p_1x_arriere),
                },
                "downloads_rel": {
                    "hd_jour": p_hd_jour.relative_to(R).as_posix(),
                    "hd_nuit": p_hd_nuit.relative_to(R).as_posix(),
                    "1x_jour": p_1x_jour.relative_to(R).as_posix(),
                    "1x_nuit": p_1x_nuit.relative_to(R).as_posix(),
                    "1x_avant": p_1x_avant.relative_to(R).as_posix(),
                    "1x_arriere": p_1x_arriere.relative_to(R).as_posix(),
                    "tile_jour": p_tile_jour.relative_to(R).as_posix(),
                    "tile_nuit": p_tile_nuit.relative_to(R).as_posix(),
                },
            }
        )
        print(
            f"[OK] {pfx} {slug}: HD={hd_jour.width}x{hd_jour.height} -> 1x={im_1x_jour.width}x{im_1x_jour.height} "
            f"({unique_j} tuiles 8x8 uniques)"
        )

    sheet_jour = compose_overview_sheet(sheets_1x_jour, cols=4, pad=16)
    sheet_nuit = compose_overview_sheet(sheets_1x_nuit, cols=4, pad=16)
    p_sheet_jour = OUT_1X / "00_Planche_Complete_Jour_JardinSecret_SkyPeak.png"
    p_sheet_nuit = OUT_1X / "00_Planche_Complete_Nuit_JardinSecret_SkyPeak.png"
    save_compact_rgba_png(sheet_jour, p_sheet_jour)
    save_compact_rgba_png(sheet_nuit, p_sheet_nuit)

    readme_text = build_readme(items_meta)
    (OUT_DIR / "README.md").write_text(readme_text, encoding="utf-8")

    manifest_entries = []
    for it in items_meta:
        clean_it = {k: v for k, v in it.items() if k != "data_uris"}
        manifest_entries.append(clean_it)

    manifest = {
        "pack_id": "guilde_treehouses_jardin_secret_sky_peak_pmdo_v1",
        "engine_target": "PMDO 0.8.12 / Halcyon 8x8",
        "pyramidal_roofs_count": 0,
        "art_approved": False,
        "runtime_tested": False,
        "layer_split_note": "Avant_Base and Arriere_Under partition visible pixels on an 8px boundary without reconstructing occluded background pixels.",
        "tile_prefixes": [it["pfx"] for it in items_meta],
        "structures": manifest_entries,
    }
    (OUT_DIR / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    (OUT_MOD / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    # Création de l'archive ZIP complète (excluant le ZIP lui-même)
    if OUT_ZIP.exists():
        OUT_ZIP.unlink()
    files_to_zip = sorted(
        p for p in OUT_DIR.rglob("*") if p.is_file() and p.resolve() != OUT_ZIP.resolve()
    )
    with zipfile.ZipFile(OUT_ZIP, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for p in files_to_zip:
            zf.write(p, arcname=p.relative_to(OUT_DIR).as_posix())

    sha256_zip = hashlib.sha256(OUT_ZIP.read_bytes()).hexdigest()
    html_text = build_html_gallery(
        items=items_meta,
        sheet_jour_uri=b64_png(p_sheet_jour),
        sheet_nuit_uri=b64_png(p_sheet_nuit),
        sheet_jour_rel=p_sheet_jour.relative_to(R).as_posix(),
        sheet_nuit_rel=p_sheet_nuit.relative_to(R).as_posix(),
        zip_rel=OUT_ZIP.relative_to(R).as_posix(),
    )
    OUT_HTML.write_text(html_text, encoding="utf-8")
    print(f"[DONE] ZIP={OUT_ZIP.stat().st_size / (1024*1024):.2f} MiB (sha256={sha256_zip[:16]}...) HTML={OUT_HTML.stat().st_size / 1024:.0f} KiB")


if __name__ == "__main__":
    main()
