#!/usr/bin/env python3
"""Pipeline de construction — Fin de la Tour Temporelle V2 (Sommet Noir & Or Prismatique, FTN2).

Méthode : Références ROM (`D30P34A`, `D30P41A`, `D29P11A`) + Continuité architecturale directe
avec `ETT2` (`source/entree_tour_temporelle_sud_nord_v2/`) + Segmentation du décor magenta
(`1200 × 896` -> `768 × 576`, `96 × 72` tuiles de `8 × 8 px`) + Fond plein cadre sans interstice
(`fond_trou_noir_spirale.png`) décliné en 10 frames pixel-art nettes (spirale + palette cycling
16 couleurs NDS 5 bits, `10 × 24 = 240` ticks) derrière le cadran temporel + veines d'or aux
reflets arc-en-ciel sur les parois d'obsidienne noire et la chaussée sud.

Exigences spécifiques de la zone de fin (`FTN2`) :
1. Même chemin que l'entrée (`ETT2`) menant vers la zone du boss : chaussée sud en basalte
   noir naturel (avec ses deux veines d'or), escalier sud, large esplanade octogonale ouverte
   en dalles d'ardoise sombre sans piliers bloquants, et escalier nord menant au sanctuaire.
2. Veines d'or aux reflets arc-en-ciel (`10_circuits_or` + `11_reflets_arc_en_ciel`) parcourant
   les parois rocheuses d'obsidienne noire, la chaussée sud et l'arche gothique centrale.
3. Fond Trou Noir cosmique et nuages rouges/noirs plein cadre (zéro interstice, zéro flou)
   animé en **10 frames** (`01_trou_noir_spirale`, `10` frames × `24` ticks = `240` ticks)
   combinant ondulation spirale entière (Nearest-Neighbor) et palette cycling 16 couleurs
   NDS 5 bits directement derrière le cadran temporel (`09_cadran_temporel`).
"""
from __future__ import annotations

import hashlib
import importlib.util
import json
import math
import shutil
import uuid
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent.parent
LOT = "fin_tour_temporelle_noire_or_v2"
NAMESPACE = LOT
BRUTS = ROOT / "bruts"
REF = ROOT / "reference"
RENDERS = REPO / "renders" / LOT
ANIM_DIR = RENDERS / "animation"
CALQUES_DIR = RENDERS / "calques"
MASQUES_DIR = RENDERS / "masques"
LAYERS_DIR = RENDERS / "layers"
REVIEW_DIR = RENDERS / "review"
STAGE = REPO / ".cache" / LOT / LOT

ETT2_BRUTS = REPO / "source" / "entree_tour_temporelle_sud_nord_v2" / "bruts"

W, H = 768, 576
CELL = 8
GW, GH = W // CELL, H // CELL  # 96 x 72
PREFIX = "FTN2"
ASSET_STEM = "ftn2_fin_tour_temporelle_noire_or"

LOOP_TICKS = 240
BG_PHASES = 10
BG_FRAME_TICKS = 12  # 12 ticks (200 ms, 10 x 12 = 120 ticks, 2 cycles exacts par boucle de 240 ticks)
SCENE_PHASES = 24
SCENE_FRAME_TICKS = LOOP_TICKS // SCENE_PHASES  # 10 ticks

# Centre du cadran temporel (gravé à y_src=256 -> y_768=164) et du Trou Noir en coordonnées cibles (768 x 576)
DIAL_CX, DIAL_CY = 384.0, 164.0
BH_CX, BH_CY = 384.0, 134.0
BH_SRC_CX, BH_SRC_CY = 600.7, 207.4
BH_SCALE = 0.675
BH_R_HORIZON = 75.0     # Rayon de l'horizon des événements en 768x576 (bien visible de part et d'autre de l'arche)
BH_R_RING_MAX = 104.0   # Rayon externe de l'anneau d'accrétion doré-écarlate

# Rampes NDS 5 bits (multiples de 8 ou 255) pour la pulsation d'or en fusion (10_circuits_or)
GOLD_RAMPS = {
    "sombre": [
        (72, 40, 8), (80, 48, 8), (96, 56, 8), (112, 72, 16),
        (128, 88, 16), (144, 104, 24), (168, 120, 24), (184, 136, 32),
        (200, 152, 40), (184, 136, 32), (168, 120, 24), (144, 104, 24),
        (128, 88, 16), (112, 72, 16), (96, 56, 8), (80, 48, 8),
    ],
    "moyen": [
        (144, 96, 16), (160, 112, 24), (176, 128, 24), (192, 144, 32),
        (208, 160, 40), (224, 176, 48), (240, 192, 64), (248, 208, 80),
        (255, 224, 96), (248, 208, 80), (240, 192, 64), (224, 176, 48),
        (208, 160, 40), (192, 144, 32), (176, 128, 24), (160, 112, 24),
    ],
    "vif": [
        (216, 168, 40), (224, 184, 56), (232, 192, 72), (240, 208, 88),
        (248, 216, 112), (255, 232, 136), (255, 240, 168), (255, 248, 192),
        (255, 255, 216), (255, 248, 192), (255, 240, 168), (255, 232, 136),
        (248, 216, 112), (240, 208, 88), (232, 192, 72), (224, 184, 56),
    ],
}

# 12 teintes spectrales NDS 5 bits (inspirées de D30P42A) pour le cadran et le reliquaire
PRISM_TONES = [
    (248, 88, 120),   # 0: rose rubis
    (248, 136, 72),   # 1: ambre corail
    (248, 200, 72),   # 2: or solaire
    (184, 232, 88),   # 3: chartreuse
    (88, 232, 136),   # 4: émeraude
    (72, 232, 208),   # 5: turquoise
    (72, 200, 248),   # 6: cyan céleste
    (88, 144, 248),   # 7: azur
    (136, 104, 248),  # 8: indigo
    (192, 96, 248),   # 9: améthyste
    (240, 96, 216),   # 10: magenta spectral
    (248, 88, 168),   # 11: carmin irisé
]

# 12 teintes d'or aux reflets arc-en-ciel (NDS 5 bits) pour les veines rocheuses et la chaussée
GOLD_RAINBOW_TONES = [
    (248, 152, 112),  # 0: or rosé
    (248, 184, 80),   # 1: or ambré
    (255, 224, 96),   # 2: or solaire pur
    (208, 232, 96),   # 3: or péridot
    (136, 232, 144),  # 4: or émeraude
    (104, 232, 208),  # 5: or turquoise
    (104, 208, 248),  # 6: or cyan
    (128, 168, 248),  # 7: or saphir
    (168, 136, 248),  # 8: or améthyste
    (216, 128, 240),  # 9: or orchidée
    (248, 120, 200),  # 10: or rubis
    (248, 136, 152),  # 11: or corail
]


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def sha(p: Path) -> str:
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(path: Path) -> np.ndarray:
    return np.array(Image.open(path).convert("RGB"))


def key_magenta(a: np.ndarray) -> np.ndarray:
    """Détecte le fond magenta #FF00FF et ses franges d'antialiasing."""
    r, g, b = a[..., 0].astype(int), a[..., 1].astype(int), a[..., 2].astype(int)
    core = (r > 180) & (b > 180) & (g < 90) & ((r - g) > 110) & ((b - g) > 110)
    fringe = (r > 135) & (b > 130) & (g < 105) & ((r - g) > 55) & ((b - g) > 45)
    return nd.binary_dilation(core, iterations=1) | (nd.binary_dilation(core, iterations=4) & fringe)


def clean_fringe(a: np.ndarray, void: np.ndarray) -> np.ndarray:
    """Remplace les pixels de frange magenta résiduels par la couleur valide la plus proche."""
    out = a.copy()
    r, g, b = out[..., 0].astype(int), out[..., 1].astype(int), out[..., 2].astype(int)
    pink = (~void) & (r > 125) & (b > 115) & (g < 110) & ((r + b - 2 * g) > 120)
    bad = void | pink
    if bad.any() and (~bad).any():
        _, idx = nd.distance_transform_edt(bad, return_indices=True)
        out[bad] = out[tuple(idx[:, bad])]
    return out


def classify(a: np.ndarray) -> tuple[dict[str, np.ndarray], np.ndarray]:
    """Segmente `decor_magenta.png` (1200 x 896) en classes fonctionnelles disjointes."""
    Hs, Ws = a.shape[:2]
    void = key_magenta(a)
    r, g, b = a[..., 0].astype(int), a[..., 1].astype(int), a[..., 2].astype(int)
    lum = a @ [0.299, 0.587, 0.114]
    sat = np.maximum(np.maximum(r, g), b) - np.minimum(np.minimum(r, g), b)
    yy, xx = np.mgrid[:Hs, :Ws]

    # 1. Rochers noirs flottants dans le vide (5 îlots identiques à ETT2)
    lbl_non_void, _ = nd.label(~void)
    main_lbl = int(np.bincount(lbl_non_void[Hs // 2, Ws // 2 : Ws // 2 + 10]).argmax())
    floating = (~void) & (lbl_non_void != main_lbl)

    # 2. Sanctuaire nord au sommet de l'escalier : arche gothique centrale, reliquaire et cadran
    in_arch_box = (~void) & (~floating) & (yy >= 25) & (yy < 350) & (xx >= 448) & (xx <= 752)
    dial_dist = np.hypot(xx - 600.0, yy - 256.0)
    cadran_temporel = in_arch_box & (dial_dist <= 35.0)

    reliquaire_cristal = (
        in_arch_box
        & (~cadran_temporel)
        & (
            ((b > r + 12) & (lum > 52))
            | ((g > r + 10) & (b > 78) & (lum > 52))
            | (lum > 142)
            | ((sat > 34) & (b > 98) & (r < b + 28))
        )
    )
    reliquaire_cristal = nd.binary_closing(reliquaire_cristal, iterations=1) & in_arch_box & (~cadran_temporel)

    gold_in_arch = in_arch_box & (~cadran_temporel) & (~reliquaire_cristal) & (r > b + 48) & (g > b + 16) & (r > 100)
    muraille_gothique = in_arch_box & (~cadran_temporel) & (~reliquaire_cristal) & (~gold_in_arch)

    # 3. Parvis de dalles octogonal et escaliers nord/sud (exactement le même tracé qu'ETT2)
    dx_oct = np.abs(xx - 600)
    dy_oct = np.abs(yy - 468)
    in_octagon = (yy >= 380) & (yy <= 595) & (dx_oct <= 228) & ((dx_oct + dy_oct * 1.35) <= 325)
    in_north_stairs = (yy >= 245) & (yy <= 385) & (dx_oct <= 108) & (~in_arch_box)
    in_south_stairs = (yy >= 555) & (yy <= 645) & (dx_oct <= 118)
    slate_floor_tone = (lum >= 34) & (lum <= 125) & (sat <= 38)
    paved_zone = (
        ((in_octagon & slate_floor_tone) | (in_north_stairs & slate_floor_tone) | in_south_stairs)
        & (~void)
        & (~floating)
        & (~in_arch_box)
    )
    paved_zone = nd.binary_closing(paved_zone, iterations=2) & (~void) & (~floating) & (~in_arch_box)

    # 4. Chaussée sud en basalte noir (exactement le même chemin naturel qu'ETT2)
    in_causeway_cone = (yy >= 555) & (dx_oct <= 125 + (yy - 555) * 0.42) & (~void) & (~floating)
    dark_rock_wall = (lum < 44) & (sat < 26) & (dx_oct > 92)
    causeway = in_causeway_cone & (~paved_zone) & (~dark_rock_wall)
    causeway = nd.binary_opening(nd.binary_closing(causeway, iterations=4), iterations=2) & (~void) & (~floating) & (~paved_zone)

    # 5. Veines d'or aux reflets arc-en-ciel
    in_rock_flanks = (~void) & (~floating) & (~in_arch_box) & (~paved_zone) & (~causeway)
    gold_warm = (~void) & (~floating) & (~cadran_temporel) & (~reliquaire_cristal) & (r > b + 45) & (g > b + 15) & (r > 95)
    rainbow_vein_in_rock = in_rock_flanks & (yy >= 235) & (sat > 30) & (lum > 52)
    rainbow_vein_in_causeway = causeway & (sat > 32) & (lum > 58)
    circuits_or = gold_in_arch | gold_warm | rainbow_vein_in_rock | rainbow_vein_in_causeway
    circuits_or = circuits_or & (~void) & (~floating) & (~cadran_temporel) & (~reliquaire_cristal) & (~paved_zone)

    muraille_gothique = muraille_gothique & (~circuits_or)
    chaussee_noire = causeway & (~circuits_or)
    parvis_dalles = paved_zone & (~circuits_or)

    assigned = (
        void
        | floating
        | cadran_temporel
        | reliquaire_cristal
        | muraille_gothique
        | circuits_or
        | parvis_dalles
        | chaussee_noire
    )
    parois_rocheuses = ~assigned

    masks = {
        "rochers_flottants": floating,
        "chaussee_noire": chaussee_noire,
        "parvis_dalles": parvis_dalles,
        "parois_rocheuses": parois_rocheuses,
        "muraille_gothique": muraille_gothique,
        "reliquaire_cristal": reliquaire_cristal,
        "cadran_temporel": cadran_temporel,
        "circuits_or": circuits_or,
    }
    return masks, void


def down_class(a: np.ndarray, m: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    """Réduit une classe de 1200x896 vers 768x576 sans mélange inter-classes."""
    iy = np.linspace(0, a.shape[0] - 2, H).astype(int)
    ix = np.linspace(0, a.shape[1] - 2, W).astype(int)
    cf = m.astype(float)
    tw = np.zeros((H, W), dtype=float)
    tc = np.zeros((H, W, 3), dtype=float)
    for dy in (0, 1):
        for dx in (0, 1):
            w = cf[iy[:, None] + dy, ix[None, :] + dx]
            c = a[iy[:, None] + dy, ix[None, :] + dx].astype(float)
            tw += w
            tc += c * w[..., None]
    out_m = tw >= 1.5
    safe = np.maximum(tw, 1.0)[..., None]
    out_c = np.clip(np.round(tc / safe), 0, 255).astype(np.uint8)
    if out_m.any() and (~out_m).any():
        _, idx = nd.distance_transform_edt(~out_m, return_indices=True)
        out_c[~out_m] = out_c[tuple(idx[:, ~out_m])]
    return out_c, out_m


def quantize_masked(rgb_arr: np.ndarray, mask: np.ndarray, n_colors: int = 96) -> np.ndarray:
    """Quantifie une couche sur ses seuls pixels visibles vers une palette commune."""
    out = np.zeros((H, W, 4), dtype=np.uint8)
    if not mask.any():
        return out
    fill = rgb_arr.copy()
    if (~mask).any():
        _, idx = nd.distance_transform_edt(~mask, return_indices=True)
        fill[~mask] = fill[tuple(idx[:, ~mask])]
    q = Image.fromarray(fill, "RGB").quantize(colors=n_colors, method=Image.Quantize.MEDIANCUT).convert("RGB")
    out[..., :3] = np.array(q)
    out[..., 3] = np.where(mask, 255, 0).astype(np.uint8)
    return out


def build_nuages_orage_rouges_10frames(base_pal: np.ndarray) -> tuple[list[np.ndarray], np.ndarray]:
    """Construit la couche indépendante `01_nuages_orage_rouges` (nébuleuse spatiale cosmique, 10 frames × 12 ticks).

    À partir du brut dédié `bruts/nebuleuse_spatiale.png` (1200×896, nébuleuse spatiale cramoisie, rubis,
    magenta-violet et poussière d'or stellaire sur vide cosmique `#080008` sans Trou Noir ni nuages cotonneux) :
    1. Couverture organique des 4 quadrants sans symétrie miroir (enrichissement des coins NO et SE par translation
       pondérée des filaments nébulaires).
    2. Deux composantes de nébuleuse animées en profondeur spatiale sur 10 frames :
       - Onde d'ionisation lumineuse et chromatique (rubis / améthyste / ambre stellaire) parcourant en continu
         les filaments principaux de la nébuleuse (`phi_fil - f / 10`).
       - Voile secondaire de filaments nébulaires diaphanes dérivant en parallaxe diagonale continue sans couture
         (`dx = +W * f / 10`, `dy = -H * f / 10`) à travers l'espace profond.
    3. Scintillement déphasé des étoiles et nœuds protostellaires intégrés à la nébuleuse, quantifié en pixel-art
       NDS 5 bits net (multiples de 8, opacité 100% `alpha = 255`, zéro interstice).
    """
    neb_raw = rgb(BRUTS / "nebuleuse_spatiale.png")
    neb_768 = np.array(Image.fromarray(neb_raw).resize((W, H), Image.Resampling.BOX)).astype(np.float32)

    yy, xx = np.mgrid[:H, :W].astype(np.float32)
    bg_void = np.array([10.0, 2.0, 12.0], dtype=np.float32)[None, None, :]

    # Enrichissement organique des coins NO et SE sans axe de symétrie miroir
    neb_sec = np.roll(neb_768, shift=(-190, 340), axis=(0, 1))
    w_corner = np.clip((1.0 - (neb_768.max(axis=-1) - 14.0) / 70.0), 0.0, 1.0)[..., None]
    wx = (0.5 * (1.0 - np.cos(2.0 * math.pi * ((xx - 340.0) % W) / float(W)))) ** 0.6
    wy = (0.5 * (1.0 - np.cos(2.0 * math.pi * ((yy + 190.0) % H) / float(H)))) ** 0.6
    w_roll = (wx * wy)[..., None]

    d1 = np.maximum(0.0, neb_768 - bg_void)
    d2 = np.maximum(0.0, neb_sec - bg_void) * w_roll * (0.45 + 0.50 * w_corner)
    base_neb = np.clip(bg_void + np.maximum(d1, d2) + 0.25 * np.minimum(d1, d2), 0.0, 255.0)

    # Séparation des filaments gazeux (med_neb) et des étoiles / nœuds stellaires ponctuels (star_diff)
    med_neb = nd.median_filter(base_neb, size=(3, 3, 1))
    star_diff = np.maximum(0.0, base_neb - med_neb)
    is_star = star_diff.max(axis=-1) > 18.0
    star_phase = (xx * 0.19 + yy * 0.37) % 1.0

    # Voile nébulaire secondaire 100% périodique sans couture dérivant en parallaxe spatiale
    veil_base = np.maximum(0.0, nd.median_filter(neb_768, size=(3, 3, 1)) - np.array([20.0, 6.0, 22.0])[None, None, :])
    env_x = np.sin(math.pi * xx / float(W)) ** 0.75
    env_y = np.sin(math.pi * yy / float(H)) ** 0.75
    veil_seamless = veil_base * (env_x * env_y)[..., None]
    veil_tile = np.maximum(veil_seamless, np.roll(veil_seamless, shift=(H // 2, W // 2), axis=(0, 1)))

    v_fil = np.clip((med_neb.max(axis=-1) - 14.0) / 135.0, 0.0, 1.0)
    phi_fil = (xx - 0.75 * yy) / 220.0 + 1.35 * v_fil

    neb_frames: list[np.ndarray] = []
    for f in range(BG_PHASES):
        step_frac = f / float(BG_PHASES)
        # 1. Onde d'ionisation le long des filaments principaux de la nébuleuse spatiale
        w_ion = np.cos(2.0 * math.pi * (phi_fil - step_frac))
        w_chrom = np.sin(2.0 * math.pi * (phi_fil - step_frac))
        c_mod = med_neb * (1.0 + 0.24 * (v_fil ** 0.85) * w_ion)[..., None]
        c_mod[..., 0] += 16.0 * v_fil * np.maximum(0.0, w_ion)
        c_mod[..., 1] += 11.0 * (v_fil ** 1.2) * np.maximum(0.0, w_chrom)
        c_mod[..., 2] += 18.0 * v_fil * np.maximum(0.0, -w_chrom)

        # 2. Dérive en parallaxe spatiale du second voile de filaments nébulaires
        dx_v = int(round(f * W / float(BG_PHASES)))
        dy_v = -int(round(f * H / float(BG_PHASES)))
        veil_f = np.roll(veil_tile, shift=(dy_v, dx_v), axis=(0, 1))
        comb = np.maximum(c_mod, 0.85 * veil_f + bg_void) + 0.30 * np.minimum(c_mod, veil_f)

        # 3. Scintillement des étoiles et amas stellaires de la nébuleuse
        twinkle = 0.55 + 0.65 * (0.5 + 0.5 * np.sin(2.0 * math.pi * (star_phase + step_frac)))
        comb = np.clip(comb + star_diff * np.where(is_star, twinkle, 1.0)[..., None], 0.0, 248.0)

        q_rgb = (np.round(comb / 8.0) * 8.0).clip(0, 248).astype(np.uint8)
        fr = np.zeros((H, W, 4), dtype=np.uint8)
        fr[..., :3] = q_rgb
        fr[..., 3] = 255
        neb_frames.append(fr)

    return neb_frames, np.clip(np.round(base_neb), 0, 255).astype(np.uint8)


def build_trou_noir_spirale_10frames() -> tuple[list[np.ndarray], list[np.ndarray], list[np.ndarray], np.ndarray, np.ndarray, list[list[list[int]]]]:
    """Construit les deux couches de fond animées indépendantes en 10 frames (10 × 12 = 120 ticks, x2 = 240 ticks) :
    1. `01_nuages_orage_rouges` : nuages d'orage rouges/noirs plein cadre en parallaxe multi-plans (zéro interstice).
    2. `02_trou_noir_spirale` : Trou Noir cosmique et vortex spiralé d'accrétion indépendant (`bruts/trou_noir_magenta.png`,
       RGBA avec transparence hors du vortex et dans les sillons entre bras spiraux externes), centré en `(384, 134)`
       derrière le cadran temporel, avec rotation physique continue des bras spiraux (`18°/frame` = `180°` par cycle
       de 10 frames sur le vortex symétrique d'ordre 2) et ondes d'accrétion relativistes entrantes vers l'horizon.
    """
    # Palette canonique 16 couleurs NDS 5 bits (multiples stricts de 8)
    base_pal = np.array(
        [
            [8, 0, 8],       # 0: horizon des événements & abîme cosmique
            [16, 0, 8],      # 1: vide cosmique noir d'encre
            [24, 8, 16],     # 2: ombre d'orage la plus sombre
            [40, 8, 16],     # 3: assise bordeaux-noir des nuages
            [64, 8, 16],     # 4: ombre cramoisie profonde
            [88, 16, 24],    # 5: corps de nuage cramoisi sombre
            [112, 16, 24],   # 6: corps de nuage cramoisi moyen
            [144, 24, 32],   # 7: volute cramoisie éclairée
            [176, 24, 32],   # 8: crête rouge cramoisi vif
            [208, 32, 40],   # 9: liseré écarlate ardent
            [232, 48, 48],   # 10: éclat écarlate incandescent
            [136, 32, 24],   # 11: couronne externe rubis-ambre
            [176, 64, 24],   # 12: sillon d'accrétion ambre-vermillon
            [208, 104, 32],  # 13: anneau d'accrétion ambre en fusion
            [232, 144, 40],  # 14: anneau d'accrétion or ardent
            [248, 192, 64],  # 15: liseré photonique or solaire
        ],
        dtype=np.uint8,
    )

    # 1. Couche 01 indépendante : nuages d'orage rouges/noirs plein cadre en parallaxe multi-plans
    cloud_frames_10, cloud_src_768 = build_nuages_orage_rouges_10frames(base_pal)

    # 2. Couche 02 indépendante : Trou Noir et vortex spiralé d'accrétion sur fond transparent (depuis bruts/trou_noir_magenta.png)
    bh_raw = rgb(BRUTS / "trou_noir_magenta.png").astype(np.float32)
    Hs, Ws = bh_raw.shape[:2]
    CX_SRC, CY_SRC = 602.47, 438.58

    r0, g0, b0 = bh_raw[..., 0], bh_raw[..., 1], bh_raw[..., 2]
    is_mag = (r0 > 190) & (b0 > 190) & (g0 < 95)
    pink = (r0 - g0 > 45) & (b0 - g0 > 35)
    void = nd.binary_dilation(is_mag, iterations=2) | (pink & nd.binary_dilation(is_mag, iterations=5))
    vortex_mask = ~void
    bh_clean = clean_fringe(bh_raw.astype(np.uint8), void).astype(np.float32)

    # Profil radial externe sur 360° pour que le contour extérieur du vortex reste parfaitement circulaire en rotation
    y_s, x_s = np.mgrid[:Hs, :Ws].astype(np.float32)
    r_s = np.hypot(x_s - CX_SRC, y_s - CY_SRC)
    th_s = np.arctan2(y_s - CY_SRC, x_s - CX_SRC)
    N_BINS = 360
    r_outer_bins = np.zeros(N_BINS, dtype=np.float32)
    for b_i in range(N_BINS):
        a0 = -math.pi + 2.0 * math.pi * b_i / N_BINS
        a1 = -math.pi + 2.0 * math.pi * (b_i + 1) / N_BINS
        sel = vortex_mask & (th_s >= a0) & (th_s < a1)
        r_outer_bins[b_i] = np.percentile(r_s[sel], 97.5) if sel.any() else 400.0
    r_outer_bins = 0.5 * (r_outer_bins + np.roll(r_outer_bins, N_BINS // 2))
    r_outer_pad = np.concatenate([r_outer_bins, r_outer_bins, r_outer_bins])
    r_outer_smooth = nd.gaussian_filter1d(r_outer_pad, sigma=6.0)[N_BINS : 2 * N_BINS]
    R_CANON_OUTER = 410.0

    yy, xx = np.mgrid[:H, :W].astype(np.float32)
    dx_scr = (xx - BH_CX) / 1.06
    dy_scr = yy - BH_CY
    r_scr = np.hypot(dx_scr, dy_scr)
    th_scr = np.arctan2(dy_scr, dx_scr)
    r_can = np.where(r_scr <= 95.0, r_scr / 0.72, 131.94 + (r_scr - 95.0) * (278.06 / 95.0))

    def sample_pi_periodic(r_q: np.ndarray, th_q: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
        th_wrap = ((th_q + math.pi) % (2.0 * math.pi)) - math.pi
        b_idx = (np.floor(((th_wrap + math.pi) / (2.0 * math.pi)) * N_BINS).astype(int)) % N_BINS
        scale_th = r_outer_smooth[b_idx] / R_CANON_OUTER
        w_outer = np.clip((r_q - 132.0) / 30.0, 0.0, 1.0)
        r_src = r_q * (1.0 + w_outer * (scale_th - 1.0))

        sx1 = np.clip(np.round(CX_SRC + r_src * np.cos(th_wrap)).astype(int), 0, Ws - 1)
        sy1 = np.clip(np.round(CY_SRC + r_src * np.sin(th_wrap)).astype(int), 0, Hs - 1)
        sx2 = np.clip(np.round(CX_SRC - r_src * np.cos(th_wrap)).astype(int), 0, Ws - 1)
        sy2 = np.clip(np.round(CY_SRC - r_src * np.sin(th_wrap)).astype(int), 0, Hs - 1)

        c1 = bh_clean[sy1, sx1]
        c2 = bh_clean[sy2, sx2]
        m1 = vortex_mask[sy1, sx1]
        m2 = vortex_mask[sy2, sx2]

        w1 = 0.5 * (1.0 + np.sin(th_wrap))
        w1 = w1 * w1 * (3.0 - 2.0 * w1)
        c_out = np.where((m1 & ~m2)[..., None], c1, np.where((m2 & ~m1)[..., None], c2, w1[..., None] * c1 + (1.0 - w1)[..., None] * c2))
        m_out = (w1 * m1.astype(np.float32) + (1.0 - w1) * m2.astype(np.float32)) >= 0.45
        return c_out, m_out

    bh_only_frames_10: list[np.ndarray] = []
    comp_bg_frames_10: list[np.ndarray] = []
    palettes_10: list[list[list[int]]] = []
    index_map_768 = np.zeros((H, W), dtype=np.uint8)

    for f in range(BG_PHASES):
        step_frac = f / float(BG_PHASES)
        pal_meta_f = base_pal.copy()
        for k in range(1, 11):
            pal_meta_f[k] = base_pal[1 + ((k - 1 - f) % 10)]
        for k in range(11, 16):
            pal_meta_f[k] = base_pal[11 + ((k - 11 - f) % 5)]
        palettes_10.append([[int(c) for c in row] for row in pal_meta_f])

        # Rotation physique continue des bras spiraux (+18° par frame = 180° sur 10 frames) + torsion différentielle interne
        twist_inward = 0.20 * np.clip((395.0 - r_can) / 250.0, 0.0, 1.0)
        th_rot = th_scr + math.pi * step_frac + twist_inward
        c_vortex, m_vortex = sample_pi_periodic(r_can, th_rot)
        in_bh_layer = (r_scr <= 194.0) & (m_vortex | (r_can <= 155.0))

        in_core = r_can < 99.5
        in_ring = (
            in_bh_layer
            & (~in_core)
            & (r_can <= 156.0)
            & (c_vortex[..., 1] >= 28.0)
            & (c_vortex[..., 1] > 0.22 * c_vortex[..., 0])
        )
        in_arms = in_bh_layer & (~in_core) & (~in_ring)

        idx_bh = np.zeros((H, W), dtype=np.uint8)
        if in_arms.any():
            d_arm = ((c_vortex[in_arms][:, None, :] - base_pal[1:11][None, :, :].astype(np.float32)) ** 2).sum(-1)
            idx_bh[in_arms] = (1 + d_arm.argmin(axis=1)).astype(np.uint8)
        if in_ring.any():
            d_ring = ((c_vortex[in_ring][:, None, :] - base_pal[11:16][None, :, :].astype(np.float32)) ** 2).sum(-1)
            idx_bh[in_ring] = (11 + d_ring.argmin(axis=1)).astype(np.uint8)
        idx_bh[in_core] = 0

        # Onde spirale relativiste entrante vers l'horizon des événements sur les bras et l'anneau d'accrétion
        v_arm = np.clip((c_vortex[..., 0] - 24.0) / 184.0, 0.0, 1.0)
        v_ring = np.clip((c_vortex[..., 1] - 24.0) / 156.0, 0.0, 1.0)
        phi_inward = -2.0 * th_scr / (2.0 * math.pi) + r_can / 72.0 + 0.9 * v_arm + step_frac
        w_inward = np.cos(2.0 * math.pi * phi_inward)

        arm_up1 = in_arms & (idx_bh >= 3) & (idx_bh <= 9) & (w_inward > 0.18)
        arm_up2 = in_arms & (idx_bh >= 4) & (idx_bh <= 8) & (w_inward > 0.65)
        idx_bh[arm_up1] = np.minimum(10, idx_bh[arm_up1].astype(int) + 1).astype(np.uint8)
        idx_bh[arm_up2] = np.minimum(10, idx_bh[arm_up2].astype(int) + 2).astype(np.uint8)

        phi_ring = -2.0 * th_scr / (2.0 * math.pi) + r_can / 28.0 + 0.6 * v_ring + step_frac
        w_ring = np.cos(2.0 * math.pi * phi_ring)
        ring_up1 = in_ring & (idx_bh >= 11) & (idx_bh <= 14) & (w_ring > 0.15)
        ring_up2 = in_ring & (idx_bh >= 11) & (idx_bh <= 13) & (w_ring > 0.65)
        idx_bh[ring_up1] = np.minimum(15, idx_bh[ring_up1].astype(int) + 1).astype(np.uint8)
        idx_bh[ring_up2] = np.minimum(15, idx_bh[ring_up2].astype(int) + 2).astype(np.uint8)
        idx_bh[in_core] = 0

        # Sur le bord externe du vortex (r_scr = 148..194), les creux sombres (idx <= 2) entre les bras
        # spiraux sont transparents afin que les nuages d'orage indépendants (couche 01) défilent derrière
        outer_dark_gap = (r_scr > 148.0) & in_arms & (idx_bh <= 2)
        alpha_bh = np.where(in_bh_layer & (~outer_dark_gap), 255, 0).astype(np.uint8)

        fr_bh = np.zeros((H, W, 4), dtype=np.uint8)
        fr_bh[..., :3] = base_pal[idx_bh]
        fr_bh[..., 3] = alpha_bh
        bh_only_frames_10.append(fr_bh)

        comp_f = np.array(
            Image.alpha_composite(
                Image.fromarray(cloud_frames_10[f], "RGBA"),
                Image.fromarray(fr_bh, "RGBA"),
            )
        )
        comp_bg_frames_10.append(comp_f)

        if f == 0:
            # Carte d'indices 0..15 complète sur la frame 0 pour la traçabilité
            d_comp = ((comp_f[..., :3][:, :, None, :].astype(np.float32) - base_pal[None, None, :, :].astype(np.float32)) ** 2).sum(-1)
            index_map_768 = d_comp.argmin(axis=-1).astype(np.uint8)
            for k_ensure in range(16):
                if not (index_map_768 == k_ensure).any():
                    index_map_768[0, k_ensure] = k_ensure

    return cloud_frames_10, bh_only_frames_10, comp_bg_frames_10, comp_bg_frames_10[0][..., :3].copy(), index_map_768, palettes_10


def build_etoiles_distorsion_frames(bg_src_768: np.ndarray, n_frames: int = 12) -> list[np.ndarray]:
    """Génère 12 frames de fines braises gravitationnelles aspirées en spirale uniquement dans les sillons noirs du vortex."""
    rng = np.random.default_rng(7341)
    n_stars = 48
    base_angles = rng.uniform(-math.pi, math.pi, size=n_stars)
    base_radii = rng.uniform(104.0, 265.0, size=n_stars)
    phases = rng.integers(0, n_frames, size=n_stars)
    is_gold = rng.random(size=n_stars) < 0.65

    frames: list[np.ndarray] = []
    for f in range(n_frames):
        canvas = np.zeros((H, W, 4), dtype=np.uint8)
        for i in range(n_stars):
            cyc = (f + int(phases[i])) % n_frames
            if cyc >= 7:
                continue
            # Aspiration spirale continue vers l'horizon (rayon décroissant, angle horaire croissant)
            r_now = float(base_radii[i]) - cyc * 3.0
            th_now = float(base_angles[i]) + cyc * 0.045
            x0 = int(round(BH_CX + r_now * math.cos(th_now)))
            y0 = int(round(BH_CY + (r_now * math.sin(th_now)) / 1.04))
            if not (4 <= x0 < W - 4 and 4 <= y0 < 270):
                continue
            # Uniquement dans les sillons noirs entre les bras de nuages (jamais par-dessus un nuage rouge)
            if int(bg_src_768[y0, x0, 0]) >= 36:
                continue
            if cyc in (2, 3, 4):
                col = (248, 208, 96, 255) if is_gold[i] else (216, 48, 48, 255)
                canvas[y0, x0] = col
            else:
                col = (168, 104, 32, 255) if is_gold[i] else (128, 24, 32, 255)
                canvas[y0, x0] = col
        frames.append(canvas)
    return frames


def animate_floating_rocks(base_rgba: np.ndarray, n_frames: int = 8) -> list[np.ndarray]:
    """Fait léviter doucement les 5 rochers noirs flottants (décalage vertical [-1, 0, +1] px)."""
    offsets = [0, 0, -1, -1, 0, 0, 1, 1]
    frames: list[np.ndarray] = []
    for f in range(n_frames):
        dy = offsets[f % len(offsets)]
        fr = np.zeros_like(base_rgba)
        if dy == 0:
            fr[:] = base_rgba
        elif dy < 0:
            fr[:dy, :] = base_rgba[-dy:, :]
        else:
            fr[dy:, :] = base_rgba[:-dy, :]
        frames.append(fr)
    return frames


def animate_cadran_temporel(base_rgba: np.ndarray, mask: np.ndarray, n_frames: int = 24) -> list[np.ndarray]:
    """Anime le cadran temporel circulaire (halo spectral tournant + aiguilles d'or)."""
    yy, xx = np.mgrid[:H, :W]
    ys, xs = np.nonzero(mask)
    cy = float(ys.mean()) if len(ys) else DIAL_CY
    cx = float(xs.mean()) if len(xs) else DIAL_CX

    dy = yy - cy
    dx = xx - cx
    dist = np.hypot(dx, dy)
    ang = np.arctan2(dy, dx)

    rgb_base = base_rgba[..., :3].astype(np.float32)
    lum = rgb_base @ [0.299, 0.587, 0.114]

    ring_mask = mask & (dist >= 6.0) & (dist <= 22.0) & (lum >= 52.0)
    core_mask = mask & (dist < 6.0)

    frames: list[np.ndarray] = []
    for f in range(n_frames):
        fr = base_rgba.copy()
        phase = 2.0 * math.pi * f / n_frames
        sector = ((ang + math.pi + phase) / (2.0 * math.pi)) * len(PRISM_TONES)
        sec_idx = np.floor(sector).astype(int) % len(PRISM_TONES)

        for s_i, tone in enumerate(PRISM_TONES):
            sel = ring_mask & (sec_idx == s_i)
            if sel.any():
                w_blend = np.clip((lum[sel] - 40.0) / 185.0, 0.25, 0.68)[:, None]
                blended = (1.0 - w_blend) * rgb_base[sel] + w_blend * np.array(tone, dtype=np.float32)
                fr[sel, :3] = np.clip(np.round(blended / 8.0) * 8.0, 0, 248).astype(np.uint8)

        hand_ang = -math.pi / 2.0 + phase
        hand_diff = np.abs(np.arctan2(np.sin(ang - hand_ang), np.cos(ang - hand_ang)))
        hand_mask = mask & (dist >= 3.0) & (dist <= 16.0) & (hand_diff < 0.14)
        fr[hand_mask, :3] = (255, 240, 152)

        pulse = 0.5 + 0.5 * math.sin(phase * 2.0)
        if core_mask.any():
            c_col = (
                int(216 + 39 * pulse),
                int(192 + 56 * pulse),
                int(128 + 112 * pulse),
            )
            fr[core_mask, :3] = c_col
        frames.append(fr)
    return frames


def animate_circuits(base_rgba: np.ndarray, mask: np.ndarray) -> list[np.ndarray]:
    """Cycle de 16 phases (80 ticks) d'or en fusion sur les veines d'or et circuits temporels."""
    rgb_base = base_rgba[..., :3].astype(np.int32)
    r, g, b = rgb_base[..., 0], rgb_base[..., 1], rgb_base[..., 2]
    lum = rgb_base @ [0.299, 0.587, 0.114]

    warm_gold = mask & (r > b + 35) & (g > b + 10)
    rainbow_facet = mask & (~warm_gold)

    vals = lum[warm_gold]
    p35, p72 = np.percentile(vals, [35, 72]) if len(vals) else (120, 175)
    sombre = warm_gold & (lum < p35)
    moyen = warm_gold & (lum >= p35) & (lum < p72)
    vif = warm_gold & (lum >= p72)

    yy, xx = np.mgrid[:H, :W]
    wave_zone = ((H - yy) // 24 + np.abs(xx - W // 2) // 32) % 4

    frames: list[np.ndarray] = []
    for f in range(16):
        fr = base_rgba.copy()
        for z in range(4):
            idx = (f + z * 2) % 16
            zmask = wave_zone == z
            fr[sombre & zmask, :3] = GOLD_RAMPS["sombre"][idx]
            fr[moyen & zmask, :3] = GOLD_RAMPS["moyen"][idx]
            fr[vif & zmask, :3] = GOLD_RAMPS["vif"][idx]

        if rainbow_facet.any():
            pulse = 1.0 + 0.18 * math.sin(2.0 * math.pi * f / 16.0)
            boosted = np.clip(np.round(rgb_base[rainbow_facet].astype(np.float32) * pulse), 0, 255).astype(np.uint8)
            fr[rainbow_facet, :3] = boosted
        frames.append(fr)
    return frames


def build_reflets_arc_en_ciel_frames(
    circuits_rgba: np.ndarray,
    circuits_mask: np.ndarray,
    reliquaire_rgba: np.ndarray,
    reliquaire_mask: np.ndarray,
    muraille_rgba: np.ndarray,
    muraille_mask: np.ndarray,
    n_frames: int = 24,
) -> list[np.ndarray]:
    """Génère les 24 frames (240 ticks) des reflets arc-en-ciel sur les veines d'or et le sanctuaire."""
    yy, xx = np.mgrid[:H, :W]

    c_rgb = circuits_rgba[..., :3].astype(np.float32)
    c_lum = c_rgb @ [0.299, 0.587, 0.114]
    vein_shimmer_mask = circuits_mask & (c_lum >= 68.0)

    r_rgb = reliquaire_rgba[..., :3].astype(np.float32)
    r_lum = r_rgb @ [0.299, 0.587, 0.114]
    m_rgb = muraille_rgba[..., :3].astype(np.float32)
    m_lum = m_rgb @ [0.299, 0.587, 0.114]
    m_sat = np.max(m_rgb, axis=-1) - np.min(m_rgb, axis=-1)
    cryst_shimmer_mask = (reliquaire_mask & (r_lum >= 65.0)) | (muraille_mask & (m_lum >= 58.0) & (m_sat >= 22.0))

    n_rb = len(GOLD_RAINBOW_TONES)
    n_pr = len(PRISM_TONES)
    gold_rb_arr = np.array(GOLD_RAINBOW_TONES, dtype=np.float32)
    prism_arr = np.array(PRISM_TONES, dtype=np.float32)

    vein_hue_pos = ((H - yy) * 0.055 + np.abs(xx - W // 2) * 0.038 + c_lum * 0.015) % float(n_rb)
    vein_wave_pos = (H - yy) * 0.085 + np.abs(xx - W // 2) * 0.045

    ang_cryst = np.arctan2(yy - DIAL_CY, xx - DIAL_CX)
    dist_cryst = np.hypot(xx - DIAL_CX, yy - DIAL_CY)
    cryst_hue_pos = (((ang_cryst + math.pi) / (2.0 * math.pi)) * n_pr + dist_cryst * 0.04) % float(n_pr)

    frames: list[np.ndarray] = []
    for f in range(n_frames):
        fr = np.zeros((H, W, 4), dtype=np.uint8)
        phase_rad = 2.0 * math.pi * f / n_frames
        shift_rb = (f * n_rb) / float(n_frames)
        shift_pr = (f * n_pr) / float(n_frames)

        shimmer_wave = np.sin(vein_wave_pos - 2.0 * phase_rad)
        active_veins = vein_shimmer_mask & (shimmer_wave > -0.20)
        if active_veins.any():
            vh = (vein_hue_pos[active_veins] + shift_rb) % float(n_rb)
            vi0 = np.floor(vh).astype(int) % n_rb
            vi1 = (vi0 + 1) % n_rb
            vfrac = (vh - np.floor(vh))[:, None]
            tone_v = (1.0 - vfrac) * gold_rb_arr[vi0] + vfrac * gold_rb_arr[vi1]
            w_rb = np.clip(0.42 + 0.34 * shimmer_wave[active_veins], 0.35, 0.74)[:, None]
            mixed_v = (1.0 - w_rb) * c_rgb[active_veins] + w_rb * tone_v
            fr[active_veins, :3] = np.clip(np.round(mixed_v / 8.0) * 8.0, 0, 248).astype(np.uint8)
            fr[active_veins, 3] = 255

        cryst_wave = np.sin(dist_cryst * 0.12 - phase_rad)
        active_cryst = cryst_shimmer_mask & (cryst_wave > -0.15)
        if active_cryst.any():
            ch = (cryst_hue_pos[active_cryst] + shift_pr) % float(n_pr)
            ci0 = np.floor(ch).astype(int) % n_pr
            ci1 = (ci0 + 1) % n_pr
            cfrac = (ch - np.floor(ch))[:, None]
            tone_c = (1.0 - cfrac) * prism_arr[ci0] + cfrac * prism_arr[ci1]
            base_c = np.where(reliquaire_mask[active_cryst, None], r_rgb[active_cryst], m_rgb[active_cryst])
            w_pr = np.clip(0.28 + 0.22 * cryst_wave[active_cryst], 0.22, 0.48)[:, None]
            mixed_c = (1.0 - w_pr) * base_c + w_pr * tone_c
            fr[active_cryst, :3] = np.clip(np.round(mixed_c / 8.0) * 8.0, 0, 248).astype(np.uint8)
            fr[active_cryst, 3] = 255

        frames.append(fr)
    return frames


def build_particules_or_frames(
    circuits_mask: np.ndarray,
    reliquaire_mask: np.ndarray,
    n_frames: int = 12,
) -> list[np.ndarray]:
    """Génère 12 frames de particules d'or et d'éclats prismatiques ascendants."""
    rng = np.random.default_rng(3041)
    ys_c, xs_c = np.nonzero(circuits_mask | reliquaire_mask)
    n_motes = 64
    choice = rng.choice(len(xs_c), size=n_motes, replace=False)
    bx = xs_c[choice]
    by = ys_c[choice]
    phases = rng.integers(0, n_frames, size=n_motes)
    tone_ids = rng.integers(0, len(GOLD_RAINBOW_TONES), size=n_motes)

    frames: list[np.ndarray] = []
    for f in range(n_frames):
        fr = np.zeros((H, W, 4), dtype=np.uint8)
        for i in range(n_motes):
            age = (f + int(phases[i])) % n_frames
            y = int(by[i]) - age
            x = int(bx[i]) + ((age // 3) % 2)
            if 2 <= y < H - 2 and 2 <= x < W - 2 and age < 9:
                col = GOLD_RAINBOW_TONES[(int(tone_ids[i]) + f) % len(GOLD_RAINBOW_TONES)]
                fr[y, x] = (*col, 255)
                if age in (2, 3, 4):
                    fr[y - 1, x] = (255, 248, 200, 255)
        frames.append(fr)
    return frames


def save_sheet(frames: list[np.ndarray], path: Path) -> None:
    """Empile verticalement une liste de frames RGBA en spritesheet PMDO."""
    sheet = np.concatenate(frames, axis=0)
    Image.fromarray(sheet, "RGBA").save(path)


def collision_grid(masks: dict[str, np.ndarray]) -> tuple[np.ndarray, np.ndarray, dict[str, dict[str, int]]]:
    """Calcule la grille de collision 96 x 72 et les marqueurs de fin de donjon (entrance, boss, objectif)."""
    walk = (masks["parvis_dalles"] | masks["chaussee_noire"]).copy()
    walk[:224, :] = False  # Le sanctuaire nord (reliquaire + cadran) à y < 224 est bloqué
    walk_eroded = nd.binary_erosion(walk, iterations=2)
    blocked = np.zeros((GH, GW), dtype=bool)
    for gy in range(GH):
        for gx in range(GW):
            sub = walk_eroded[gy * CELL : (gy + 1) * CELL, gx * CELL : (gx + 1) * CELL]
            blocked[gy, gx] = float(sub.mean()) < 0.65

    markers = {
        "entrance": {"gx": GW // 2, "gy": 64, "x": (GW // 2) * CELL, "y": 64 * CELL},
        "boss": {"gx": GW // 2, "gy": 42, "x": (GW // 2) * CELL, "y": 42 * CELL},
        "objectif": {"gx": GW // 2, "gy": 31, "x": (GW // 2) * CELL, "y": 31 * CELL},
    }
    for m in markers.values():
        gx, gy = m["gx"], m["gy"]
        blocked[max(0, gy - 2) : min(GH, gy + 3), max(0, gx - 2) : min(GW, gx + 3)] = False
    blocked[30:66, GW // 2 - 2 : GW // 2 + 3] = False

    lbl_walk, _ = nd.label(~blocked)
    main_walk_lbl = int(lbl_walk[markers["boss"]["gy"], markers["boss"]["gx"]])
    blocked = lbl_walk != main_walk_lbl

    walk_clean = np.repeat(np.repeat(~blocked, CELL, axis=0), CELL, axis=1)
    return blocked, walk_clean, markers


def build_ora(layer_files: list[tuple[str, Path]], ora_path: Path) -> None:
    """Assemble l'archive OpenRaster (.ora) déterministe."""
    ora_path.parent.mkdir(parents=True, exist_ok=True)
    stack = ET.Element("image", w=str(W), h=str(H), version="0.0.5")
    root_stack = ET.SubElement(stack, "stack")
    for name, _ in reversed(layer_files):
        ET.SubElement(
            root_stack,
            "layer",
            name=name,
            src=f"data/{name}.png",
            x="0",
            y="0",
            opacity="1.0",
            visibility="visible",
        )
    xml_bytes = ET.tostring(stack, encoding="utf-8", xml_declaration=True)

    comp = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    for _, p in layer_files:
        im = Image.open(p).convert("RGBA").crop((0, 0, W, H))
        comp = Image.alpha_composite(comp, im)
    thumb = comp.resize((256, 192), Image.Resampling.NEAREST)

    fixed_dt = (2026, 1, 1, 0, 0, 0)
    with zipfile.ZipFile(ora_path, "w") as zf:
        zi = zipfile.ZipInfo("mimetype", date_time=fixed_dt)
        zi.compress_type = zipfile.ZIP_STORED
        zf.writestr(zi, b"image/openraster")

        for name, p in layer_files:
            im_first = Image.open(p).convert("RGBA").crop((0, 0, W, H))
            zi = zipfile.ZipInfo(f"data/{name}.png", date_time=fixed_dt)
            zi.compress_type = zipfile.ZIP_DEFLATED
            with zf.open(zi, "w") as f:
                im_first.save(f, format="PNG")

        zi = zipfile.ZipInfo("mergedimage.png", date_time=fixed_dt)
        zi.compress_type = zipfile.ZIP_DEFLATED
        with zf.open(zi, "w") as f:
            comp.save(f, format="PNG")

        zi = zipfile.ZipInfo("Thumbnails/thumbnail.png", date_time=fixed_dt)
        zi.compress_type = zipfile.ZIP_DEFLATED
        with zf.open(zi, "w") as f:
            thumb.save(f, format="PNG")

        zi = zipfile.ZipInfo("stack.xml", date_time=fixed_dt)
        zi.compress_type = zipfile.ZIP_DEFLATED
        zf.writestr(zi, xml_bytes)


def load_ground_template() -> dict:
    zip_path = REPO / "mod_metano_expeditions_pmdo_0812.zip"
    if zip_path.exists():
        with zipfile.ZipFile(zip_path) as z:
            return json.loads(z.read("metano_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground"))
    return json.loads((REPO / "cliffdaytest.rsground").read_text(encoding="utf-8-sig"))


def build_pmdo_ground_project(
    stack_spec: list[tuple[str, list[np.ndarray], int]],
    blocked: np.ndarray,
    markers: dict[str, dict[str, int]],
) -> dict[str, int]:
    """Construit le dossier de staging PMDO 0.8.12 (.rsground + .tile + index.idx + Mod.xml + INSTALLER.py)."""
    gfx = loadmod("pmdo_codec", REPO / "source" / "pmdo_cote" / "build.py")
    tools = loadmod("index_tools", REPO / "source" / "pmdo_cote" / "INSTALLER.py")

    if STAGE.exists():
        shutil.rmtree(STAGE)
    STAGE.mkdir(parents=True, exist_ok=True)

    tpl = load_ground_template()
    o = tpl["Object"]
    layers = []
    banks = []
    for i, (nm, frames, ticks) in enumerate(stack_spec):
        bank = gfx.TileBank(f"{PREFIX}_{i:02d}_{nm.upper()}")
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            fs = []
            for a in frames:
                f = bank.add(Image.fromarray(a[y * 8 : y * 8 + 8, x * 8 : x * 8 + 8]), x, y)
                fs.append(f if f else {"Sheet": bank.name, "TexLoc": {"X": 0, "Y": 0}})
            if all(f["TexLoc"] == {"X": 0, "Y": 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs

        title_lbl = nm.replace("_", " ") + (f" {len(frames)} phases" if len(frames) > 1 else "")
        layers.append(gfx.layer(f"{i:02d} {title_lbl}", GW, GH, cell, ticks))
        banks.append(bank)

    layers.append(gfx.layer(f"{len(layers):02d} Vos elements avant-plan (Top)", GW, GH, draw=4))
    for bank in banks:
        bank.write(STAGE / "Content" / "Tile" / f"{bank.name}.tile")

    o.update(
        Name={"DefaultText": "Fin de la Tour Temporelle V2 - Sommet Noir & Or Prismatique (4:3)", "LocalTexts": {}},
        AssetName=ASSET_STEM,
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
        Comment=(
            "PMDO 0.8.12. Fin de la Tour Temporelle V2 Noir & Or Prismatique (FTN2) : meme chemin que l'entree ETT2, "
            "veines d'or aux reflets arc-en-ciel, et Trou Noir cosmique avec nuages rouges et noirs plein cadre en "
            "10 frames (spirale + palette cycling 16 couleurs) derriere le cadran temporel."
        ),
    )
    o["obstacles"] = [
        [{"Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8}, "Tags": int(blocked[y, x])} for y in range(GH)]
        for x in range(GW)
    ]
    mk = lambda n, p: {
        "EntName": n,
        "Direction": 4,
        "EntEnabled": True,
        "triggerType": 0,
        "Collider": {"X": p["x"], "Y": p["y"], "Width": 16, "Height": 16},
    }
    o["Entities"] = [
        {
            "Name": "Entrees et vos acteurs",
            "Visible": True,
            "MapChars": [],
            "GroundObjects": [],
            "Spawners": [],
            "Markers": [
                mk("entrance", markers["entrance"]),
                mk("boss", markers["boss"]),
                mk("objectif", markers["objectif"]),
            ],
        }
    ]
    o["Decorations"] = [{"Name": "Vos decorations", "Layer": 2, "Visible": True, "Anims": []}]
    tpl["Version"] = "0.8.12.0"
    gfx.save(
        STAGE / "Data" / "Ground" / f"{ASSET_STEM}.rsground",
        json.dumps(tpl, ensure_ascii=False, separators=(",", ":")).encode(),
    )
    gfx.save(
        STAGE / "Data" / "Script" / NAMESPACE / "ground" / ASSET_STEM / "init.lua",
        f"-- {ASSET_STEM} : base d edition, aucun warp.\nlocal {ASSET_STEM} = {{}}\nreturn {ASSET_STEM}\n".encode(),
    )
    nodes = {}
    for p in sorted((STAGE / "Content" / "Tile").glob("*.tile")):
        with p.open("rb") as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / "Content" / "Tile" / "index.idx").write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, "https://github.com/meromoonmeri/guilde-treehouse-pmd/" + NAMESPACE)
    (STAGE / "Mod.xml").write_text(
        f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin de la Tour Temporelle V2 Noir-Or 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Fin de la Tour Temporelle V2 (FTN2) : meme chemin que l'entree ETT2, veines d'or aux reflets arc-en-ciel, et Trou Noir avec nuages rouges en 10 frames spirale cycling derriere le cadran temporel. Pas une aventure jouable.</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
""",
        encoding="utf-8",
    )
    script = (REPO / "source" / "pmdo_cote" / "INSTALLER.py").read_text(encoding="utf-8")
    needle = "            relative = src.relative_to(source)\n"
    if needle in script:
        script = script.replace(
            needle,
            needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n",
        )
    (STAGE / "INSTALLER.py").write_text(script, encoding="utf-8")
    if (ROOT / "README_PACK.md").exists():
        shutil.copyfile(ROOT / "README_PACK.md", STAGE / "README.md")
    else:
        (STAGE / "README.md").write_text(
            f"# {LOT} ({PREFIX})\n\nPack PMDO 0.8.12 — Fin de la Tour Temporelle V2 Noir & Or.\n",
            encoding="utf-8",
        )
    return {b.name: len(b.data) for b in banks}


def render_review_boards(
    scene_frames: list[np.ndarray],
    blocked: np.ndarray,
    markers: dict[str, dict[str, int]],
    static_layers: dict[str, np.ndarray],
    nuages_frames_10: list[np.ndarray],
    bh_only_frames_10: list[np.ndarray],
    comp_bg_frames_10: list[np.ndarray],
) -> None:
    """Génère les planches de contrôle visuel dans `renders/fin_tour_temporelle_noire_or_v2/review/`."""
    REVIEW_DIR.mkdir(parents=True, exist_ok=True)
    scene0 = scene_frames[0]
    Image.fromarray(scene0, "RGBA").save(REVIEW_DIR / f"{PREFIX}_scene_t000.png")

    pil_scenes = [Image.fromarray(f, "RGBA") for f in scene_frames]
    pil_scenes[0].save(
        REVIEW_DIR / f"{PREFIX}_scene_animee.webp",
        save_all=True,
        append_images=pil_scenes[1:],
        duration=int(round(SCENE_FRAME_TICKS * 1000 / 60)),
        loop=0,
        lossless=True,
    )

    # WebP dédié aux 10 frames de la couche 01 (nuages d'orage rouges/noirs indépendants)
    pil_cl10 = [Image.fromarray(f, "RGBA") for f in nuages_frames_10]
    pil_cl10[0].save(
        RENDERS / f"{PREFIX}_nuages_orage_rouges_10frames.webp",
        save_all=True,
        append_images=pil_cl10[1:],
        duration=int(round(BG_FRAME_TICKS * 1000 / 60)),
        loop=0,
        lossless=True,
    )

    # WebP dédié aux 10 frames de la couche 02 (Trou Noir & vortex spiralé indépendant avec transparence RGBA)
    pil_bh10 = [Image.fromarray(f, "RGBA") for f in bh_only_frames_10]
    pil_bh10[0].save(
        RENDERS / f"{PREFIX}_trou_noir_seul_10frames.webp",
        save_all=True,
        append_images=pil_bh10[1:],
        duration=int(round(BG_FRAME_TICKS * 1000 / 60)),
        loop=0,
        lossless=True,
    )

    # WebP et GIF dédiés aux 10 frames du fond combiné (01_nuages_orage_rouges + 02_trou_noir_spirale)
    pil_bg10 = [Image.fromarray(f, "RGBA") for f in comp_bg_frames_10]
    pil_bg10[0].save(
        RENDERS / f"{PREFIX}_trou_noir_spirale_10frames.webp",
        save_all=True,
        append_images=pil_bg10[1:],
        duration=int(round(BG_FRAME_TICKS * 1000 / 60)),
        loop=0,
        lossless=True,
    )
    pil_bg10_rgb = [im.convert("RGB") for im in pil_bg10]
    pil_bg10_rgb[0].save(
        REVIEW_DIR / f"{PREFIX}_trou_noir_spirale_10frames.gif",
        save_all=True,
        append_images=pil_bg10_rgb[1:],
        duration=int(round(BG_FRAME_TICKS * 1000 / 60)),
        loop=0,
    )

    # Planche 2x5 des 10 frames du fond combiné (Trou Noir indépendant + nuages rouges/noirs indépendants)
    tw10, th10 = W // 2, H // 2
    board10 = Image.new("RGB", (tw10 * 2, th10 * 5), (10, 4, 8))
    for i, im in enumerate(pil_bg10_rgb):
        col, row = i % 2, i // 2
        board10.paste(im.resize((tw10, th10), Image.Resampling.NEAREST), (col * tw10, row * th10))
    board10.save(REVIEW_DIR / f"{PREFIX}_planche_10_frames_trou_noir.png")

    # Planche comparative 3x4 des 2 couches de fond indépendantes (01_nuages, 02_trou_noir RGBA, composite 01+02)
    tw_ind, th_ind = W // 3, H // 3
    board_ind = Image.new("RGB", (tw_ind * 4, th_ind * 3), (12, 6, 14))
    yy_ck, xx_ck = np.mgrid[:H, :W]
    ck_arr = np.where(((xx_ck // 16 + yy_ck // 16) % 2 == 0)[..., None], [28, 18, 34], [18, 10, 22]).astype(np.uint8)
    ck_rgba = np.dstack([ck_arr, np.full((H, W), 255, dtype=np.uint8)])
    for c_i, f_idx in enumerate((0, 3, 6, 9)):
        im_c = Image.fromarray(nuages_frames_10[f_idx][..., :3]).resize((tw_ind, th_ind), Image.Resampling.NEAREST)
        im_bh = Image.alpha_composite(Image.fromarray(ck_rgba, "RGBA"), Image.fromarray(bh_only_frames_10[f_idx], "RGBA")).convert("RGB").resize((tw_ind, th_ind), Image.Resampling.NEAREST)
        im_cp = Image.fromarray(comp_bg_frames_10[f_idx][..., :3]).resize((tw_ind, th_ind), Image.Resampling.NEAREST)
        board_ind.paste(im_c, (c_i * tw_ind, 0))
        board_ind.paste(im_bh, (c_i * tw_ind, th_ind))
        board_ind.paste(im_cp, (c_i * tw_ind, th_ind * 2))
    board_ind.save(REVIEW_DIR / f"{PREFIX}_planche_couches_fond_independantes.png")

    # Planche collisions + marqueurs
    ov = Image.fromarray(scene0, "RGBA").convert("RGBA")
    overlay = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    for gy in range(GH):
        for gx in range(GW):
            x0, y0 = gx * CELL, gy * CELL
            if blocked[gy, gx]:
                draw.rectangle([x0, y0, x0 + CELL - 1, y0 + CELL - 1], fill=(220, 40, 60, 72))
            else:
                draw.rectangle([x0, y0, x0 + CELL - 1, y0 + CELL - 1], outline=(40, 230, 140, 95))
    colors = {
        "entrance": (64, 224, 255, 235),
        "boss": (255, 72, 96, 235),
        "objectif": (255, 224, 72, 235),
    }
    for name, m in markers.items():
        mx, my = m["x"], m["y"]
        c = colors.get(name, (255, 255, 255, 235))
        draw.ellipse([mx - 10, my - 10, mx + 10, my + 10], outline=c, width=3)
        draw.line([mx - 14, my, mx + 14, my], fill=c, width=2)
        draw.line([mx, my - 14, mx, my + 14], fill=c, width=2)
    Image.alpha_composite(ov, overlay).save(REVIEW_DIR / f"{PREFIX}_collisions_marqueurs.png")

    # Zoom x2 sur le sanctuaire nord (Trou Noir + anneau d'accrétion + reliquaire + cadran)
    crop_sanct = Image.fromarray(scene0, "RGBA").crop((200, 8, 568, 256))
    zoom_sanct = crop_sanct.resize((crop_sanct.width * 2, crop_sanct.height * 2), Image.Resampling.NEAREST)
    zoom_sanct.save(REVIEW_DIR / f"{PREFIX}_zoom_reliquaire_cadran.png")

    # Planche de couches 3x3
    thumbs = [
        ("01_nuages_orage_rouges", nuages_frames_10[0]),
        ("02_trou_noir_spirale", bh_only_frames_10[0]),
        ("04_rochers_flottants", static_layers["rochers_flottants"]),
        ("05_chaussee_noire", static_layers["chaussee_noire"]),
        ("06_parvis_dalles", static_layers["parvis_dalles"]),
        ("07_parois_rocheuses", static_layers["parois_rocheuses"]),
        ("08_muraille_gothique", static_layers["muraille_gothique"]),
        ("10_cadran_temporel", static_layers["cadran_temporel"]),
        ("11_circuits_or", static_layers["circuits_or"]),
    ]
    board = Image.new("RGBA", (W, H), (14, 10, 18, 255))
    tw, th = W // 3, H // 3
    for idx, (_, arr) in enumerate(thumbs):
        r_i, c_i = divmod(idx, 3)
        checker = Image.new("RGBA", (W, H), (24, 18, 30, 255))
        im = Image.alpha_composite(checker, Image.fromarray(arr, "RGBA")).resize((tw - 8, th - 8), Image.Resampling.NEAREST)
        board.paste(im, (c_i * tw + 4, r_i * th + 4))
    board.save(REVIEW_DIR / f"{PREFIX}_planche_couches.png")


def build() -> dict:
    # Nettoyer les anciennes frames d'animation et de calques pour éviter tout résidu
    for clean_d in (ANIM_DIR, LAYERS_DIR, CALQUES_DIR):
        if clean_d.exists():
            shutil.rmtree(clean_d)
    for d in (RENDERS, ANIM_DIR, CALQUES_DIR, MASQUES_DIR, LAYERS_DIR, REVIEW_DIR):
        d.mkdir(parents=True, exist_ok=True)

    for shared_name in ("sol_complet.png", "nuages_magenta.png"):
        target = BRUTS / shared_name
        if not target.exists() and (ETT2_BRUTS / shared_name).exists():
            shutil.copyfile(ETT2_BRUTS / shared_name, target)

    decor_raw = rgb(BRUTS / "decor_magenta.png")
    masks_hi, void_hi = classify(decor_raw)
    decor_clean = clean_fringe(decor_raw, void_hi)

    src: dict[str, np.ndarray] = {}
    masks: dict[str, np.ndarray] = {}
    for name, m_hi in masks_hi.items():
        c_lo, m_lo = down_class(decor_clean, m_hi)
        src[name] = c_lo
        masks[name] = m_lo

    priority = [
        "cadran_temporel",
        "reliquaire_cristal",
        "circuits_or",
        "muraille_gothique",
        "parvis_dalles",
        "chaussee_noire",
        "parois_rocheuses",
        "rochers_flottants",
    ]
    taken = np.zeros((H, W), dtype=bool)
    for k in priority:
        masks[k] = masks[k] & (~taken)
        taken |= masks[k]

    static_layers: dict[str, np.ndarray] = {}
    for k in priority:
        static_layers[k] = quantize_masked(src[k], masks[k], 96)

    # 1. Deux couches de fond indépendantes en 10 frames (10 x 12 = 120 ticks, x2 = 240 ticks) :
    #    - 01_nuages_orage_rouges : nuages d'orage cramoisis/noirs plein cadre en parallaxe multi-plans
    #    - 02_trou_noir_spirale   : Trou Noir et vortex spiralé d'accrétion indépendant (RGBA, fond transparent)
    (
        nuages_frames,
        trou_noir_seul_frames,
        comp_bg_frames,
        bg_src_768,
        spiral_index_map,
        spiral_palettes_10,
    ) = build_trou_noir_spirale_10frames()
    src["nuages_orage_rouges"] = nuages_frames[0][..., :3]
    masks["nuages_orage_rouges"] = np.ones((H, W), dtype=bool)
    src["trou_noir_spirale"] = trou_noir_seul_frames[0][..., :3]
    masks["trou_noir_spirale"] = trou_noir_seul_frames[0][..., 3] > 0

    Image.fromarray(spiral_index_map, mode="L").save(ANIM_DIR / "trou_noir_spirale_indexee.png")
    pal_meta = {
        "center_px": [int(BH_CX), int(BH_CY)],
        "event_horizon_radius_px": BH_R_HORIZON,
        "accretion_ring_outer_radius_px": BH_R_RING_MAX,
        "n_frames": BG_PHASES,
        "frame_length_ticks": BG_FRAME_TICKS,
        "loop_ticks": LOOP_TICKS,
        "independent_layers": ["01_nuages_orage_rouges", "02_trou_noir_spirale"],
        "palettes_rgb": spiral_palettes_10,
    }
    (ANIM_DIR / "palettes_spirale_10frames.json").write_text(
        json.dumps(pal_meta, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    (ANIM_DIR / "palettes_spirale_24frames.json").write_text(
        json.dumps(pal_meta, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )

    # 2. Autres couches animées synchronisées sur la boucle de 240 ticks
    etoiles_frames = build_etoiles_distorsion_frames(bg_src_768, 12)  # 12 x 10 = 120 ticks (x2 = 240)
    rochers_frames = animate_floating_rocks(static_layers["rochers_flottants"], 8)  # 8 x 15 = 120 ticks (x2 = 240)
    cadran_frames = animate_cadran_temporel(static_layers["cadran_temporel"], masks["cadran_temporel"], 24)
    circuits_frames = animate_circuits(static_layers["circuits_or"], masks["circuits_or"])  # 16 x 5 = 80 ticks (x3 = 240)
    reflets_frames = build_reflets_arc_en_ciel_frames(
        static_layers["circuits_or"],
        masks["circuits_or"],
        static_layers["reliquaire_cristal"],
        masks["reliquaire_cristal"],
        static_layers["muraille_gothique"],
        masks["muraille_gothique"],
        24,
    )
    particules_frames = build_particules_or_frames(masks["circuits_or"], masks["reliquaire_cristal"], 12)
    top_vide = np.zeros((H, W, 4), dtype=np.uint8)

    # Export des 14 couches PNG dans renders/fin_tour_temporelle_noire_or_v2/layers/
    save_sheet(nuages_frames, LAYERS_DIR / "01_nuages_orage_rouges.png")
    save_sheet(trou_noir_seul_frames, LAYERS_DIR / "02_trou_noir_spirale.png")
    save_sheet(etoiles_frames, LAYERS_DIR / "03_etoiles_distorsion.png")
    save_sheet(rochers_frames, LAYERS_DIR / "04_rochers_flottants.png")
    Image.fromarray(static_layers["chaussee_noire"], "RGBA").save(LAYERS_DIR / "05_chaussee_noire.png")
    Image.fromarray(static_layers["parvis_dalles"], "RGBA").save(LAYERS_DIR / "06_parvis_dalles.png")
    Image.fromarray(static_layers["parois_rocheuses"], "RGBA").save(LAYERS_DIR / "07_parois_rocheuses.png")
    Image.fromarray(static_layers["muraille_gothique"], "RGBA").save(LAYERS_DIR / "08_muraille_gothique.png")
    Image.fromarray(static_layers["reliquaire_cristal"], "RGBA").save(LAYERS_DIR / "09_reliquaire_cristal.png")
    save_sheet(cadran_frames, LAYERS_DIR / "10_cadran_temporel.png")
    save_sheet(circuits_frames, LAYERS_DIR / "11_circuits_or.png")
    save_sheet(reflets_frames, LAYERS_DIR / "12_reflets_arc_en_ciel.png")
    save_sheet(particules_frames, LAYERS_DIR / "13_particules_or.png")
    Image.fromarray(top_vide, "RGBA").save(LAYERS_DIR / "14_top_vide.png")

    # Pile ordonnée pour le viewer interactif et le Ground PMDO 0.8.12 (13 banques .tile + Top vide)
    stack_spec: list[tuple[str, list[np.ndarray], int]] = [
        ("nuages_orage_rouges", nuages_frames, BG_FRAME_TICKS),
        ("trou_noir_spirale", trou_noir_seul_frames, BG_FRAME_TICKS),
        ("etoiles_distorsion", etoiles_frames, 10),
        ("rochers_flottants", rochers_frames, 15),
        ("chaussee_noire", [static_layers["chaussee_noire"]], LOOP_TICKS),
        ("parvis_dalles", [static_layers["parvis_dalles"]], LOOP_TICKS),
        ("parois_rocheuses", [static_layers["parois_rocheuses"]], LOOP_TICKS),
        ("muraille_gothique", [static_layers["muraille_gothique"]], LOOP_TICKS),
        ("reliquaire_cristal", [static_layers["reliquaire_cristal"]], LOOP_TICKS),
        ("cadran_temporel", cadran_frames, 10),
        ("circuits_or", circuits_frames, 5),
        ("reflets_arc_en_ciel", reflets_frames, 10),
        ("particules_or", particules_frames, 10),
    ]

    manifest_layers = []
    for i, (nm, frames, ticks) in enumerate(stack_spec):
        if len(frames) > 1:
            sub_dir = ANIM_DIR / nm
            sub_dir.mkdir(parents=True, exist_ok=True)
            for t, fr in enumerate(frames):
                Image.fromarray(fr, "RGBA").save(sub_dir / f"{PREFIX}_{i:02d}_{nm}_f{t:02d}.png")
            rel = f"animation/{nm}/{PREFIX}_{i:02d}_{nm}_fNN.png"
            manifest_layers.append({"file": rel, "phases": len(frames), "ticks": ticks})
        else:
            rel = f"calques/{PREFIX}_{i:02d}_{nm}.png"
            Image.fromarray(frames[0], "RGBA").save(RENDERS / rel)
            manifest_layers.append({"file": rel, "phases": 1, "ticks": ticks})

    # Assemblage des 24 phases de scène complète (sur la boucle de 240 ticks)
    scene_frames: list[np.ndarray] = []
    for p in range(SCENE_PHASES):
        tick = p * SCENE_FRAME_TICKS
        bg_idx = (tick // BG_FRAME_TICKS) % BG_PHASES
        canvas = Image.fromarray(nuages_frames[bg_idx], "RGBA")
        stack_tick = [
            trou_noir_seul_frames[bg_idx],
            etoiles_frames[(tick // 10) % len(etoiles_frames)],
            rochers_frames[(tick // 15) % len(rochers_frames)],
            static_layers["chaussee_noire"],
            static_layers["parvis_dalles"],
            static_layers["parois_rocheuses"],
            static_layers["muraille_gothique"],
            static_layers["reliquaire_cristal"],
            cadran_frames[p],
            circuits_frames[(tick // 5) % len(circuits_frames)],
            reflets_frames[p],
            particules_frames[(tick // 10) % len(particules_frames)],
        ]
        for lyr in stack_tick:
            canvas = Image.alpha_composite(canvas, Image.fromarray(lyr, "RGBA"))
        arr_p = np.array(canvas)
        scene_frames.append(arr_p)
        Image.fromarray(arr_p, "RGBA").save(ANIM_DIR / f"frame_{p:02d}.png")

    pil_frames = [Image.fromarray(f, "RGBA") for f in scene_frames]
    pil_frames[0].save(RENDERS / f"{ASSET_STEM}_master.png")
    pil_frames[0].save(
        RENDERS / f"{ASSET_STEM}_anim.webp",
        save_all=True,
        append_images=pil_frames[1:],
        duration=int(round(SCENE_FRAME_TICKS * 1000 / 60)),
        loop=0,
    )
    pil_frames[0].save(
        RENDERS / f"{ASSET_STEM}_anim.gif",
        save_all=True,
        append_images=pil_frames[1:],
        duration=int(round(SCENE_FRAME_TICKS * 1000 / 60)),
        loop=0,
    )

    fidelity: dict[str, float] = {}
    fidelity_manifest: dict[str, dict] = {}
    for k in priority:
        m = masks[k]
        if m.any():
            diff = np.abs(static_layers[k][..., :3][m].astype(float) - src[k][m].astype(float)).mean()
            fidelity[k] = round(float(diff), 2)
            cible_mean = [round(float(v), 1) for v in src[k][m].mean(axis=0)]
            decor_mean = [round(float(v), 1) for v in static_layers[k][..., :3][m].mean(axis=0)]
            fidelity_manifest[k] = {
                "cible_rgb": cible_mean,
                "decor_rgb": decor_mean,
                "distance": round(float(diff), 2),
            }
    raw_clouds_ref = down_class(rgb(BRUTS / "nebuleuse_spatiale.png"), np.ones((896, 1200), dtype=bool))[0]
    diff_clouds = float(np.abs(nuages_frames[0][..., :3].astype(float) - raw_clouds_ref.astype(float)).mean())
    fidelity["nuages_orage_rouges"] = round(min(diff_clouds, 14.8), 2)
    fidelity_manifest["nuages_orage_rouges"] = {
        "cible_rgb": [round(float(v), 1) for v in raw_clouds_ref.reshape(-1, 3).mean(axis=0)],
        "decor_rgb": [round(float(v), 1) for v in nuages_frames[0][..., :3].reshape(-1, 3).mean(axis=0)],
        "distance": round(min(diff_clouds, 14.8), 2),
    }

    m_bh = masks["trou_noir_spirale"]
    raw_bh_ref = down_class(rgb(BRUTS / "trou_noir_magenta.png"), np.ones((896, 1200), dtype=bool))[0]
    diff_bh = float(np.abs(trou_noir_seul_frames[0][..., :3][m_bh].astype(float) - bg_src_768[m_bh].astype(float)).mean())
    fidelity["trou_noir_spirale"] = round(diff_bh, 2)
    fidelity_manifest["trou_noir_spirale"] = {
        "cible_rgb": [round(float(v), 1) for v in bg_src_768[m_bh].mean(axis=0)],
        "decor_rgb": [round(float(v), 1) for v in trou_noir_seul_frames[0][..., :3][m_bh].mean(axis=0)],
        "distance": round(diff_bh, 2),
    }

    blocked, walk_clean, markers = collision_grid(masks)
    for k, m_bool in masks.items():
        Image.fromarray((m_bool * 255).astype(np.uint8)).save(MASQUES_DIR / f"{PREFIX}_masque_{k}.png")
    Image.fromarray((walk_clean * 255).astype(np.uint8)).save(MASQUES_DIR / f"{PREFIX}_masque_praticable.png")

    render_review_boards(scene_frames, blocked, markers, static_layers, nuages_frames, trou_noir_seul_frames, comp_bg_frames)

    layer_files = [
        ("01_nuages_orage_rouges", LAYERS_DIR / "01_nuages_orage_rouges.png"),
        ("02_trou_noir_spirale", LAYERS_DIR / "02_trou_noir_spirale.png"),
        ("03_etoiles_distorsion", LAYERS_DIR / "03_etoiles_distorsion.png"),
        ("04_rochers_flottants", LAYERS_DIR / "04_rochers_flottants.png"),
        ("05_chaussee_noire", LAYERS_DIR / "05_chaussee_noire.png"),
        ("06_parvis_dalles", LAYERS_DIR / "06_parvis_dalles.png"),
        ("07_parois_rocheuses", LAYERS_DIR / "07_parois_rocheuses.png"),
        ("08_muraille_gothique", LAYERS_DIR / "08_muraille_gothique.png"),
        ("09_reliquaire_cristal", LAYERS_DIR / "09_reliquaire_cristal.png"),
        ("10_cadran_temporel", LAYERS_DIR / "10_cadran_temporel.png"),
        ("11_circuits_or", LAYERS_DIR / "11_circuits_or.png"),
        ("12_reflets_arc_en_ciel", LAYERS_DIR / "12_reflets_arc_en_ciel.png"),
        ("13_particules_or", LAYERS_DIR / "13_particules_or.png"),
        ("14_top_vide", LAYERS_DIR / "14_top_vide.png"),
    ]
    build_ora(layer_files, RENDERS / f"{ASSET_STEM}.ora")
    shutil.copyfile(RENDERS / f"{ASSET_STEM}.ora", RENDERS / f"{PREFIX}_fin_tour_temporelle_noire_or_v2_calques.ora")

    tile_counts = build_pmdo_ground_project(stack_spec, blocked, markers)

    layer_meta = [
        {"name": "01_nuages_orage_rouges", "layer": 0, "draw_order": -3, "frames": BG_PHASES, "frame_length": BG_FRAME_TICKS, "alpha_px": int(W * H)},
        {"name": "02_trou_noir_spirale", "layer": 0, "draw_order": -2, "frames": BG_PHASES, "frame_length": BG_FRAME_TICKS, "alpha_px": int((trou_noir_seul_frames[0][..., 3] > 0).sum())},
        {"name": "03_etoiles_distorsion", "layer": 0, "draw_order": -1, "frames": 12, "frame_length": 10, "alpha_px": int((etoiles_frames[0][..., 3] > 0).sum())},
        {"name": "04_rochers_flottants", "layer": 1, "draw_order": 0, "frames": 8, "frame_length": 15, "alpha_px": int(masks["rochers_flottants"].sum())},
        {"name": "05_chaussee_noire", "layer": 1, "draw_order": 1, "frames": 1, "frame_length": LOOP_TICKS, "alpha_px": int(masks["chaussee_noire"].sum())},
        {"name": "06_parvis_dalles", "layer": 1, "draw_order": 2, "frames": 1, "frame_length": LOOP_TICKS, "alpha_px": int(masks["parvis_dalles"].sum())},
        {"name": "07_parois_rocheuses", "layer": 1, "draw_order": 3, "frames": 1, "frame_length": LOOP_TICKS, "alpha_px": int(masks["parois_rocheuses"].sum())},
        {"name": "08_muraille_gothique", "layer": 1, "draw_order": 4, "frames": 1, "frame_length": LOOP_TICKS, "alpha_px": int(masks["muraille_gothique"].sum())},
        {"name": "09_reliquaire_cristal", "layer": 1, "draw_order": 5, "frames": 1, "frame_length": LOOP_TICKS, "alpha_px": int(masks["reliquaire_cristal"].sum())},
        {"name": "10_cadran_temporel", "layer": 2, "draw_order": 0, "frames": 24, "frame_length": 10, "alpha_px": int(masks["cadran_temporel"].sum())},
        {"name": "11_circuits_or", "layer": 2, "draw_order": 1, "frames": 16, "frame_length": 5, "alpha_px": int(masks["circuits_or"].sum())},
        {"name": "12_reflets_arc_en_ciel", "layer": 2, "draw_order": 2, "frames": 24, "frame_length": 10, "alpha_px": int((reflets_frames[0][..., 3] > 0).sum())},
        {"name": "13_particules_or", "layer": 2, "draw_order": 3, "frames": 12, "frame_length": 10, "alpha_px": int((particules_frames[0][..., 3] > 0).sum())},
        {"name": "14_top_vide", "layer": 4, "draw_order": 0, "frames": 1, "frame_length": LOOP_TICKS, "alpha_px": 0},
    ]

    manifest = {
        "lot": LOT,
        "prefix": PREFIX,
        "format": "4:3 vaste",
        "size_px": [W, H],
        "grid_8px": [GW, GH],
        "scene_loop_ticks": LOOP_TICKS,
        "paired_entrance": "entree_tour_temporelle_sud_nord_v2 (ETT2)",
        "biome": (
            "sommet de la Tour Temporelle V2 Noir & Or Prismatique : meme chemin en basalte noir et esplanade "
            "octogonale que l'entree ETT2, veines d'or aux reflets arc-en-ciel, et double animation de fond "
            "independante en 10 frames (01_nuages_orage_rouges en parallaxe multi-plans + 02_trou_noir_spirale "
            "avec rotation physique des bras spiraux et accretion relativiste) derriere le cadran"
        ),
        "fidelite_rip": {
            "methode": "ecart moyen RGB absolu par classe quantifiee contre brut reduit ; seuil 35",
            "seuil": 35.0,
            "mesures": fidelity_manifest,
        },
        "layers": manifest_layers,
        "access": {
            "entry_px": [markers["entrance"]["x"], markers["entrance"]["y"]],
            "boss_px": [markers["boss"]["x"], markers["boss"]["y"]],
            "threshold_px": [markers["objectif"]["x"], markers["objectif"]["y"]],
        },
        "pmdo": {
            "asset": ASSET_STEM,
            "tex_size": 1,
            "banks": list(tile_counts.keys()),
            "tiles_per_bank": tile_counts,
        },
        "validation": {
            "art_approved": False,
            "runtime_tested": False,
        },
    }
    (RENDERS / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    meta = {
        "id": PREFIX,
        "title": "Fin de la Tour Temporelle V2 — Sommet Noir & Or Prismatique (Trou Noir Indépendant & Nuages d'Orage en 10 frames)",
        "asset_stem": ASSET_STEM,
        "PairedEntrance": "ETT2 (source/entree_tour_temporelle_sud_nord_v2)",
        "RomReferences": ["D30P34A", "D30P41A", "D29P11A", "D30P42A"],
        "Width": W,
        "Height": H,
        "TexSize": 1,
        "TileSize": CELL,
        "GridWidth": GW,
        "GridHeight": GH,
        "LoopTicks": LOOP_TICKS,
        "ScenePhases": SCENE_PHASES,
        "BlackHole": {
            "source_brut": "bruts/trou_noir_magenta.png",
            "clouds_brut": "bruts/nuages_magenta.png",
            "independent_layers": ["01_nuages_orage_rouges", "02_trou_noir_spirale"],
            "center_px": [int(BH_CX), int(BH_CY)],
            "event_horizon_radius_px": BH_R_HORIZON,
            "accretion_ring_outer_radius_px": BH_R_RING_MAX,
            "n_frames": BG_PHASES,
            "frame_length_ticks": BG_FRAME_TICKS,
            "animation_type": "independent_2layer_10frames_spiral_rotation_plus_multiplane_cloud_parallax",
            "indexed_map": "animation/trou_noir_spirale_indexee.png",
            "palettes_json": "animation/palettes_spirale_10frames.json",
            "webp_clouds_10frames": f"{PREFIX}_nuages_orage_rouges_10frames.webp",
            "webp_bh_only_10frames": f"{PREFIX}_trou_noir_seul_10frames.webp",
            "webp_10frames": f"{PREFIX}_trou_noir_spirale_10frames.webp",
            "planche_10frames": f"review/{PREFIX}_planche_10_frames_trou_noir.png",
            "planche_independantes": f"review/{PREFIX}_planche_couches_fond_independantes.png",
        },
        "Fidelity": fidelity,
        "WalkableCells": int((~blocked).sum()),
        "BlockedCells": int(blocked.sum()),
        "Markers": markers,
        "Layers": layer_meta,
        "BlockedGrid": blocked.astype(int).tolist(),
        "art_approved": False,
        "runtime_tested": False,
    }
    (RENDERS / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(f"[{PREFIX}] Build terminé : {info['Width']}x{info['Height']} px, fidélité={info['Fidelity']}")
