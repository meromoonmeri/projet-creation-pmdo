"""Constructeur PMDO 0.8.12.0 reconstruit 100 % de zéro — TCE1 : Tour Céleste — Entrée.

Architecture multicalque 10 calques (768×576, 96×72 tuiles, boucle maîtresse 120 ticks) :
  - Brut chromatique `bruts/base_tour_celeste_entree.png` avec ciel/couloirs de tornades en #FF00FF pur.
  - L00 : Ciel stratosphérique bleu cobalt canonique D13P01 (#0040E0)
  - L01 : Courants d'air stratosphériques d'arrière-plan (24 poses @ 5 ticks)
  - L02 : Voûte nuageuse d'orage haute & nuages lointains (statique, 1 pose — DERRIÈRE les tornades !)
  - L03 : Tornade Géante Gauche en rotation cylindrique 3D 360° sur son axe (24 poses @ 5 ticks)
  - L04 : Tornade Géante Droite en rotation cylindrique 3D 360° sur son axe (24 poses @ 5 ticks)
  - L05 : Chaussée de nuage continue Sud -> Nord & Portail Nord sombre (statique, 1 pose — DEVANT le pied interne)
  - L06 : Onde d'alizé canonique D13P01 sur les creux bleutés de l'esplanade (24 poses @ 5 ticks)
  - L07 : Cumulus blancs d'avant-plan gauche & droite (statique, 1 pose, Top — DEVANT le pied des tornades)
  - L08 : Croissants d'écume 3D en orbite devant les colonnes cycloniques (24 poses @ 5 ticks, Top)
  - L09 : Particules d'écume stratosphérique ascendantes (24 poses @ 5 ticks, Top)
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

from moteur_legendaires_zekrom_dialga_palkia import clean_brut_magenta_fringe
from moteur_tornade_3d_tour_celeste import build_twin_tornado_layers
from tour_celeste_moteur_nuages import (
    H_CANON,
    N_FRAMES,
    TILE_SIZE,
    W_CANON,
    LayerEntry,
    build_rsground_package,
)

MAP_ID = "TCE1"
MAP_TITLE = "Tour Céleste — Entrée des Tornades Géantes"

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parent.parent
BRUT_PATH = HERE / "bruts" / "base_tour_celeste_entree.png"
RAW_BRUT_PNG = BRUT_PATH
CANON_REF = HERE / "references" / "ref_entree_tornades_user.png"
RENDERS_DIR = REPO_ROOT / "renders" / "tour_celeste_entree_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _rgba_from_mask(rgb: np.ndarray, mask: np.ndarray) -> Image.Image:
    out = np.zeros((rgb.shape[0], rgb.shape[1], 4), dtype=np.uint8)
    out[mask, :3] = rgb[mask]
    out[mask, 3] = 255
    return Image.fromarray(out, "RGBA")


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    im_raw = Image.open(BRUT_PATH).convert("RGB")
    if im_raw.size != (w, h):
        im_raw = im_raw.resize((w, h), Image.Resampling.NEAREST)
    raw = np.asarray(im_raw, dtype=np.uint8).copy()

    mag_mask = (raw[:, :, 0] >= 245) & (raw[:, :, 1] <= 12) & (raw[:, :, 2] >= 245)
    rgb = clean_brut_magenta_fringe(raw, mag_mask)

    yy, xx = np.mgrid[0:h, 0:w]
    non_mag = ~mag_mask

    # Décomposition Z sans AUCUNE coupure droite visible :
    # - Les nuages d'avant-plan bas-gauche et bas-droite sont les composantes / parties basses
    #   situées en bas dans les coins (y >= 0.80 * h et hors du pont central Sud -> Nord) :
    #   leur bord supérieur est bordé à 100 % par le ciel #FF00FF naturel (zéro ligne droite !)
    is_fg_corner_cumulus = (
        non_mag
        & (yy >= int(round(0.805 * h)))
        & ((xx <= int(round(0.268 * w))) | (xx >= int(round(0.732 * w))))
    )

    # - La chaussée centrale de nuage Sud -> Nord + l'arche sombre du portail Nord :
    #   pour y >= 0.255 * h, toute la colonne centrale est naturellement bordée à gauche et à droite
    #   par le ciel #FF00FF (100 % bourrelets de nuages ronds, zéro ligne verticale !).
    #   Au Nord (0.08 * h <= y < 0.255 * h), l'arche sombre du portail reste dans la zone centrale
    #   [0.30 * w .. 0.70 * w] loin des deux tornades (qui occupent x < 0.27 * w et x > 0.73 * w !).
    # - La chaussée centrale de nuage Sud -> Nord :
    #   pour y >= 0.255 * h, toute la colonne centrale est naturellement bordée à gauche et à droite
    #   par le ciel #FF00FF (100 % bourrelets de nuages ronds, ZÉRO ligne droite ni raccord dans les nuages !).
    central_band = (yy >= int(round(0.255 * h))) & (xx > int(round(0.255 * w))) & (xx < int(round(0.745 * w)))
    is_central_causeway_and_portal = non_mag & central_band & (~is_fg_corner_cumulus)

    # - Tous les autres nuages (grande voûte d'orage haute + petits nuages d'altitude à mi-hauteur)
    #   sont placés sur L02 DERRIÈRE les deux tornades géantes L03 & L04, exactement comme sur
    #   `ref_entree_tornades_user.png` : la silhouette spiralée des tornades s'élève jusqu'en y = 0 !
    is_back_storm_vault = non_mag & (~is_fg_corner_cumulus) & (~is_central_causeway_and_portal)

    # L00 : Ciel stratosphérique cobalt pur D13P01 (#0040E0) sur tout le canevas (aucun trou alpha !)
    sky_base = np.zeros((h, w, 4), dtype=np.uint8)
    sky_base[:, :, 0] = 0
    sky_base[:, :, 1] = 64
    sky_base[:, :, 2] = 224
    sky_base[:, :, 3] = 255
    l0_sky = [Image.fromarray(sky_base, "RGBA")]

    # L01 : Courants d'air stratosphériques subtils dans le ciel bleu cobalt (24 poses @ 5 ticks)
    l1_streams: List[Image.Image] = []
    tw_s, th_s = max(64, w // 3), max(64, h // 3)
    sy_g, sx_g = np.mgrid[0:th_s, 0:tw_s].astype(np.float32)
    for f in range(N_FRAMES):
        ph = (2.0 * np.pi * f) / float(N_FRAMES)
        band = np.sin(2.0 * np.pi * (sx_g / tw_s + 2.0 * sy_g / th_s) - ph)
        ribbon = band > 0.72
        tile = np.zeros((th_s, tw_s, 4), dtype=np.uint8)
        tile[ribbon] = (14, 92, 240, 255)
        tiled = np.tile(tile, ((h + th_s - 1) // th_s, (w + tw_s - 1) // tw_s, 1))[:h, :w]
        l1_streams.append(Image.fromarray(tiled, "RGBA"))

    # L02 : Voûte nuageuse d'orage haute & nuages lointains (statique, 1 pose)
    l2_vault = [_rgba_from_mask(rgb, is_back_storm_vault)]

    # L03, L04, L08, L09 : Moteur 3D écrit de zéro des deux tornades géantes en rotation sur leur axe
    l3_left_tornado, l4_right_tornado, l8_front_whips, l9_sparks = build_twin_tornado_layers(
        w=w, h=h, n_frames=N_FRAMES
    )
    # Économie de tuiles sans modifier UN SEUL pixel visible : on vide uniquement l'intérieur strict
    # (érodé de 2 px) déjà recouvert à 100 % par les calques opaques L05 & L07 situés devant !
    fg_opaque_interior = ndimage.binary_erosion(
        is_central_causeway_and_portal | is_fg_corner_cumulus, iterations=2
    )
    if np.any(fg_opaque_interior):
        for seq in (l3_left_tornado, l4_right_tornado):
            for idx_f, im_f in enumerate(seq):
                arr_f = np.asarray(im_f, dtype=np.uint8).copy()
                arr_f[fg_opaque_interior] = 0
                seq[idx_f] = Image.fromarray(arr_f, "RGBA")

    # L05 : Chaussée centrale de nuage Sud -> Nord & Portail Nord sombre (statique, 1 pose)
    l5_causeway = [_rgba_from_mask(rgb, is_central_causeway_and_portal)]

    # L06 : Onde d'alizé canonique D13P01 strictement dans les vrais croissants d'ombre bleutés
    # des bourrelets de nuages (morphologie top-hat noir -> ZÉRO bande horizontale sur le blanc !)
    lum_cloud = 0.299 * rgb[:, :, 0] + 0.587 * rgb[:, :, 1] + 0.114 * rgb[:, :, 2]
    local_mean = ndimage.uniform_filter(lum_cloud, size=max(5, int(round(11 * h / 576.0))))
    cloud_shadow_crescents = (
        is_central_causeway_and_portal
        & (yy >= int(round(0.24 * h)))
        & ((local_mean - lum_cloud) >= 12.0)
        & (rgb[:, :, 2] >= 210)
    )
    l6_breeze: List[Image.Image] = []
    yy_f = yy.astype(np.float32)
    xx_f = xx.astype(np.float32)
    for f in range(N_FRAMES):
        ph = (2.0 * np.pi * f) / float(N_FRAMES)
        wave = np.sin((2.0 * np.pi * yy_f) / max(float(h) * 0.28, 16.0) + 0.015 * xx_f + ph)
        lit = cloud_shadow_crescents & (wave > 0.15)
        sh = np.zeros((h, w, 4), dtype=np.uint8)
        sh[lit] = (176, 232, 255, 255)
        l6_breeze.append(Image.fromarray(sh, "RGBA"))

    # L07 : Cumulus blancs d'avant-plan gauche & droite (statique, 1 pose, Top)
    l7_fg_cumulus = [_rgba_from_mask(rgb, is_fg_corner_cumulus)]

    # Grille de marche continue Sud (y = gh - 1) -> Portail Nord (y ≈ 0.19 * gh)
    gh, gw = h // TILE_SIZE, w // TILE_SIZE
    walk_grid = np.zeros((gh, gw), dtype=bool)
    cloud_walk_surface = is_central_causeway_and_portal | is_back_storm_vault
    for ty in range(gh):
        y0, y1 = ty * TILE_SIZE, (ty + 1) * TILE_SIZE
        yn_t = (ty + 0.5) / float(gh)
        if yn_t < 0.165:
            continue
        for tx in range(gw):
            x0, x1 = tx * TILE_SIZE, (tx + 1) * TILE_SIZE
            # Couloir central de nuage marchable entre x ∈ [0.34*w .. 0.66*w] (plus large en bas)
            max_half = 0.20 * w if yn_t > 0.80 else (0.155 * w if yn_t > 0.25 else 0.065 * w)
            cx_tile = (tx + 0.5) * TILE_SIZE
            if abs(cx_tile - 0.5 * w) <= max_half:
                if float(cloud_walk_surface[y0:y1, x0:x1].mean()) >= 0.85:
                    walk_grid[ty, tx] = True

    # Garantir une unique composante 4-connexe reliant le bord Sud (gh - 1) au seuil du portail Nord
    lbl, n_cc = ndimage.label(walk_grid)
    if n_cc > 1:
        south_labels = [c for c in set(lbl[gh - 1, :].tolist()) if c != 0]
        if south_labels:
            best = max(south_labels, key=lambda c: int((lbl == c).sum()))
            walk_grid = lbl == best

    layers = [
        LayerEntry("00_ciel_stratospherique_d13p01", "Ciel Stratosphérique Cobalt D13P01", "bg", l0_sky, frame_length=120),
        LayerEntry("01_courants_altitude_d13p01", "Courants d'Altitude Stratosphériques", "bg", l1_streams, frame_length=5),
        LayerEntry("02_voute_orageuse_haute_statique", "Voûte Nuageuse d'Orage Haute (Statique)", "bg", l2_vault, frame_length=120),
        LayerEntry("03_tornade_gauche_3d_rotation", "Tornade Géante Gauche — Rotation 3D 360°", "bg", l3_left_tornado, frame_length=5),
        LayerEntry("04_tornade_droite_3d_rotation", "Tornade Géante Droite — Rotation 3D 360°", "bg", l4_right_tornado, frame_length=5),
        LayerEntry("05_chaussee_nuage_sud_nord_et_portail", "Chaussée de Nuage Sud-Nord & Portail Nord", "bg", l5_causeway, frame_length=120),
        LayerEntry("06_onde_alize_chaussee_d13p01", "Onde d'Alizé Chaussée de Nuage D13P01", "bg", l6_breeze, frame_length=5),
        LayerEntry("07_cumulus_avant_plan_statiques_top", "Cumulus Blancs d'Avant-Plan (Statique)", "top", l7_fg_cumulus, frame_length=120),
        LayerEntry("08_croissants_ecume_3d_top", "Croissants d'Écume 3D en Orbite (Top)", "top", l8_front_whips, frame_length=5),
        LayerEntry("09_particules_ecume_celeste_top", "Particules d'Écume Stratosphérique (Top)", "top", l9_sparks, frame_length=5),
    ]
    return layers, walk_grid


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    h = max(64, int(round(H_CANON * scale / TILE_SIZE)) * TILE_SIZE)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    layers, walk_grid = build_layers_for_size(w, h)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=CANON_REF,
        max_fidelity_distance=24.0,
        max_unique_tiles_per_bank=32000,
        namespace_override="tour_celeste_tce1",
        asset_name_override="tour_celeste_entree",
    )
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
