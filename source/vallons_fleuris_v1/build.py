#!/usr/bin/env python3
"""Recomposition locale FVF1 + EVF1 depuis les deux décors restaurés.

Usage : .venv/bin/python source/vallons_fleuris_v1/build.py

Les compositions restaurées sont normalisées uniformément en 768×576 ; le magenta devient
le masque fixe de l'eau. Les images générées pleine carte sont segmentées à ce masque exact :
seuls leurs pixels dans l'eau sont utilisés et le décor original reste intact hors masque.
La matière générée est animée par un déplacement doux en quatre phases ; ce n'est pas l'animation
native ni un calque de pixels canoniques. La carte River complète native est reconstruite à part.

Limite de provenance : les quatre frames Sky Peak officielles attendues par
source/sky_peak_v1/build_canonique.py (gif_0.png…gif_3.png, source `2cwdrrs469f61.gif`)
ne sont pas dans ce checkout. Les animations référencées par
sky_peak_4th_pass_secondary.json ont été vérifiées : ce sont de l'eau, pas des fleurs.
Aucun motif/pose synthétique ne remplace les fleurs officielles manquantes ; le décor floral
généré original reste intact et statique jusqu'à récupération de la vraie source.
"""
from __future__ import annotations

import hashlib
import io
import itertools
import json
import math
import struct
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
W, H = 768, 576
SRC_W, SRC_H = 1200, 896
SCALE = H / SRC_H
SCALED_W = round(SRC_W * SCALE)
CROP_X = (SCALED_W - W) // 2
TILE = 8
PHASES = 4
FRAME_TICKS = 10
LOOP_TICKS = 240

MAPS = {
    "FVF1": {
        "source_dir": "fin_vallon_fleuri_sanctuaire_v1",
        "slug": "fin_vallon_fleuri_sanctuaire_v1",
        "title": "Fin Vallon Fleuri — Sanctuaire de la Clairière Fleurie",
        "decor_file": "decor_magenta.png",
        "soil_file": "sol_complet.png",
        "water_fill_file": "generations/FVF1_water_fill_generated.png",
        "decor_attribution": "ancien decor_magenta (3).png, blob restauré sans retouche",
        "soil_attribution": "ancien sol_complet.png, blob restauré sans retouche",
        "markers": [
            {"name": "entrée", "key": "entrance", "xy": [376, 528], "color": "#ffe628"},
            {"name": "boss", "key": "boss", "xy": [376, 300], "color": "#ff50c8"},
            {"name": "objectif · autel", "key": "objectif", "xy": [376, 96], "color": "#3cdcff"},
        ],
        "source_ref": "D73P11A annoncée dans le gabarit mais absente du checkout",
        "foam_suppression": True,
    },
    "EVF1": {
        "source_dir": "entree_vallon_fleuri_sud_nord_v1",
        "slug": "entree_vallon_fleuri_sud_nord_v1",
        "title": "Entrée Vallon Fleuri — Sud vers Nord",
        "decor_file": "decor_magenta.png",
        "soil_file": "sol_complet.png",
        "water_fill_file": "generations/EVF1_water_fill_generated.png",
        "decor_attribution": "ancien decor_magenta.png, blob restauré sans retouche",
        "soil_attribution": "ancien sol_complet (1).png, blob restauré sans retouche",
        "markers": [
            {"name": "entrée", "key": "entrance", "xy": [376, 528], "color": "#ffe628"},
            {"name": "sortie · grotte", "key": "sortie", "xy": [376, 96], "color": "#3cdcff"},
        ],
        "source_ref": "aucune référence ROM restaurée avec les bruts",
        "foam_suppression": False,
    },
}

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rgba_image(image: Image.Image) -> np.ndarray:
    return np.asarray(image.convert("RGBA"), dtype=np.uint8)


def normalize_rgb(image: Image.Image) -> Image.Image:
    """Echelle uniforme identique en X/Y, puis crop centré 771→768 px."""
    image = image.convert("RGB")
    if image.size != (SRC_W, SRC_H):
        raise AssertionError(f"Taille brute inattendue : {image.size}, attendu {(SRC_W, SRC_H)}")
    scaled = image.resize((SCALED_W, H), Image.Resampling.LANCZOS)
    return scaled.crop((CROP_X, 0, CROP_X + W, H))


def normalize_mask(mask: np.ndarray) -> np.ndarray:
    im = Image.fromarray(mask.astype(np.uint8) * 255, "L")
    scaled = im.resize((SCALED_W, H), Image.Resampling.NEAREST)
    return np.asarray(scaled.crop((CROP_X, 0, CROP_X + W, H))) >= 128


def magenta_water_mask(rgb: np.ndarray, *, suppress_foam: bool) -> tuple[np.ndarray, dict]:
    """Récupère le magenta et sa frange anti-aliasée ; n'ajoute aucune écume."""
    a = rgb.astype(np.int16)
    r, g, b = a.transpose(2, 0, 1)
    exact = (r > 150) & (b > 130) & (g < 100) & (r > g * 1.5) & (b > g * 1.3)
    dist = nd.distance_transform_edt(~exact)
    # Un pixel de bord teinté magenta appartient encore au masque d'eau, pas à la berge.
    fringe = ((dist <= 1.5) & (r > 150) & (b > 125) & (g < 220) & (r > g))
    mask = exact | fringe
    foam_cleared = np.zeros_like(mask)
    if suppress_foam:
        # FVF1 has a pale generator fringe immediately on the stream edge. Extend the water
        # mask only over bright, nearly neutral pixels within 3.5 source pixels; rocks and
        # the wider shoreline are not repainted. No foam animation is created.
        lum = a @ np.array([0.299, 0.587, 0.114], dtype=np.float32)
        sat = a.max(2) - a.min(2)
        foam_cleared = (dist <= 3.5) & (lum > 190) & (sat < 55) & ~exact
        mask |= foam_cleared
    return mask, {
        "magenta_pixels_raw": int(exact.sum()),
        "anti_aliased_edge_pixels_raw": int((fringe & ~exact).sum()),
        "pale_edge_pixels_absorbed_raw": int(foam_cleared.sum()),
        "water_mask_pixels_raw": int(mask.sum()),
        "white_foam_layer_created": False,
    }


def decode_native_tilebank(path: Path, expected_size: int | None = None) -> dict[tuple[int, int], Image.Image]:
    """Decode les cellules .tile PMDO en conservant leur résolution native."""
    raw = path.read_bytes()
    cell_size, count = struct.unpack_from("<ii", raw, 0)
    if expected_size is not None and cell_size != expected_size:
        raise AssertionError(f"Taille de cellule .tile inattendue pour {path}: {cell_size}, attendu {expected_size}")
    records = [struct.unpack_from("<iiq", raw, 8 + 16 * i) for i in range(count)]
    tiles: dict[tuple[int, int], Image.Image] = {}
    for x, y, offset in records:
        length = struct.unpack_from("<q", raw, offset)[0]
        blob = raw[offset + 8:offset + 8 + length]
        tile = Image.open(io.BytesIO(blob)).convert("RGBA")
        if tile.size != (cell_size, cell_size):
            raise AssertionError(f"Cellule native {cell_size}×{cell_size} attendue, obtenue {tile.size} dans {path}")
        a = np.asarray(tile, dtype=np.uint16).copy()
        alpha = a[:, :, 3]
        partial = (alpha > 0) & (alpha < 255)
        if np.any(partial):
            # Les PNG du .tile stockent le RGB prémultiplié ; l'export PNG de référence
            # rétablit le RGB droit sur les seuls pixels semi-transparents.
            for c in range(3):
                channel = a[:, :, c]
                channel[partial] = np.minimum(255, (channel[partial] * 255 + alpha[partial] // 2) // alpha[partial])
        tiles[(int(x), int(y))] = Image.fromarray(a.astype(np.uint8), "RGBA")
    return tiles


def sparkle_animations() -> list[dict]:
    """Retourne les séquences 4×10 ticks exactement référencées dans la carte Métano."""
    source = ROOT / "source/eau_metano/natifs/Metano_Town_River_Sparkles.tile"
    tiles = decode_native_tilebank(source, expected_size=TILE)
    data = json.loads((ROOT / "source/eau_metano/animations_carte.json").read_text())
    result = []
    for index, record in enumerate(data["animations"]):
        anim = record.get("animation", {})
        frames = anim.get("Frames", [])
        if anim.get("FrameLength") != 10 or len(frames) != 4:
            continue
        if not all(frame.get("Sheet") == "Metano_Town_River_Sparkles" for frame in frames):
            continue
        xy = [(int(f["TexLoc"]["X"]), int(f["TexLoc"]["Y"])) for f in frames]
        if any(pos not in tiles for pos in xy):
            raise AssertionError(f"Cellule scintillement manquante dans {source}: {xy}")
        ims = [tiles[pos] for pos in xy]
        if not any(np.asarray(im)[:, :, 3].any() for im in ims):
            continue
        result.append({
            "source_index": index,
            "source_texlocs": [list(p) for p in xy],
            "map_cell_example": record.get("example_map_cell"),
            "source_count": record.get("count", 1),
            "frame_length_ticks": 10,
            "frames": ims,
        })
    if len(result) < 4:
        raise AssertionError(f"Trop peu de séquences natives Métano décodées : {len(result)}")
    return result


def native_metano_river_tiles() -> dict:
    """Reconstruit les quatre calques River complets aux positions de la carte PMDO.

    Pour les 3200 entrées River, ``example_map_cell`` est vérifié contre ``TexLoc``.
    Chaque cellule 8×8 native est placée une seule fois à cette coordonnée dans le calque
    source 142×189 ; aucun patch de surface ni assortiment de cellules de rive n'est créé.
    """
    sheet_names = [f"Metano_Town_River_Animation_{i}" for i in range(1, 5)]
    banks = [decode_native_tilebank(ROOT / f"source/eau_metano/natifs/{name}.tile", expected_size=TILE)
             for name in sheet_names]
    if not all(banks):
        raise AssertionError("Planche native Metano Town River vide")
    source_map = json.loads((ROOT / "source/eau_metano/animations_carte.json").read_text())
    river_records = [record for record in source_map["animations"] if record.get("layer") == "River"]
    if len(river_records) != 3200:
        raise AssertionError(f"La preuve Metano attend 3200 cellules River, obtenu {len(river_records)}")

    river_tiles: dict[tuple[int, int], list[Image.Image]] = {}
    for record in river_records:
        anim = record["animation"]
        frames = anim["Frames"]
        if anim.get("FrameLength") != FRAME_TICKS or len(frames) != PHASES:
            raise AssertionError("Cadence/nombre de phases River Métano différent de la source")
        if [frame["Sheet"] for frame in frames] != sheet_names:
            raise AssertionError("Ordre des quatre planches River Métano différent de la source")
        map_xy = tuple(map(int, record["example_map_cell"]))
        texlocs = [tuple(int(frame["TexLoc"][axis]) for axis in ("X", "Y")) for frame in frames]
        if any(xy != map_xy for xy in texlocs):
            raise AssertionError(f"La coordonnée de carte River {map_xy} ne correspond pas aux TexLoc {texlocs}")
        if map_xy in river_tiles:
            raise AssertionError(f"Cellule River répétée dans la carte source : {map_xy}")
        tiles = []
        for phase, bank in enumerate(banks):
            tile = bank.get(map_xy)
            if tile is None:
                raise AssertionError(f"Cellule River native manquante à {map_xy}, phase {phase + 1}")
            tiles.append(tile)
        river_tiles[map_xy] = tiles
    if len(river_tiles) != len(river_records):
        raise AssertionError("Coordonnées River dupliquées ou manquantes dans la carte source")

    xs = [xy[0] for xy in river_tiles]
    ys = [xy[1] for xy in river_tiles]
    map_width_cells, map_height_cells = max(xs) + 1, max(ys) + 1
    source_map_frames = [Image.new("RGBA", (map_width_cells * TILE, map_height_cells * TILE), (0, 0, 0, 0))
                         for _ in range(PHASES)]
    for (x, y), tiles in sorted(river_tiles.items(), key=lambda item: (item[0][1], item[0][0])):
        for phase, tile in enumerate(tiles):
            source_map_frames[phase].paste(tile, (x * TILE, y * TILE))

    opaque_water_cells = []
    animated_opaque_water = []
    opaque_sequence_keys = set()
    opaque_non_surface_cells = 0
    shoreline_sequence_keys = set()
    animated_shoreline_sequence_keys = set()
    shoreline_alpha_keys = set()
    shoreline_cells = 0
    animated_shoreline_cells = 0

    for (x, y), tiles in sorted(river_tiles.items(), key=lambda item: (item[0][1], item[0][0])):
        arrays = [np.asarray(tile, dtype=np.uint8) for tile in tiles]
        alpha_masks = [array[:, :, 3] > 0 for array in arrays]
        coverages = [int(mask.sum()) for mask in alpha_masks]
        if all(coverage == TILE * TILE for coverage in coverages):
            if not all(np.all((array[:, :, 2] > array[:, :, 0] * 1.35)
                              & (array[:, :, 1] > array[:, :, 0] * 1.2)
                              & (array[:, :, 1] > 90)) for array in arrays):
                opaque_non_surface_cells += 1
                continue
            opaque_water_cells.append((x, y))
            changed = [int(np.any(arrays[0] != array, axis=2).sum()) for array in arrays[1:]]
            if any(changed):
                opaque_sequence_keys.add(b"".join(array.tobytes() for array in arrays))
                animated_opaque_water.append({
                    "source_texloc_xy_cells": [x, y],
                    "changed_pixels_per_phase_vs_1": changed,
                })
            continue

        if any(0 < coverage < TILE * TILE for coverage in coverages):
            shoreline_cells += 1
            changed_pixels = sum(int(np.any(arrays[0] != array, axis=2).sum()) for array in arrays[1:])
            sequence_key = b"".join(array.tobytes() for array in arrays)
            alpha_key = b"".join(mask.astype(np.uint8).tobytes() for mask in alpha_masks)
            shoreline_sequence_keys.add(sequence_key)
            shoreline_alpha_keys.add(alpha_key)
            if changed_pixels:
                animated_shoreline_cells += 1
                animated_shoreline_sequence_keys.add(sequence_key)
            continue
        raise AssertionError(f"Cellule River entièrement transparente inattendue : {(x, y)}")

    if len(opaque_water_cells) < 2000 or len(animated_opaque_water) < 300:
        raise AssertionError(
            f"Trop peu de tuiles d'eau River opaques/animées : "
            f"{len(opaque_water_cells)}/{len(animated_opaque_water)}")
    if shoreline_cells < 700:
        raise AssertionError(f"Modules alpha-partiels River manquants : {shoreline_cells}")

    source_alpha_union = np.logical_or.reduce([
        np.asarray(frame.getchannel("A")) > 0 for frame in source_map_frames
    ])
    component_labels, component_count = nd.label(source_alpha_union, structure=np.ones((3, 3), dtype=bool))
    source_components = []
    for label in range(1, component_count + 1):
        ys_component, xs_component = np.nonzero(component_labels == label)
        pixel_count = int(len(xs_component))
        if pixel_count < 1024:
            continue
        x0, x1 = int(xs_component.min()), int(xs_component.max()) + 1
        y0, y1 = int(ys_component.min()), int(ys_component.max()) + 1
        component_cells = sum(
            1 for x, y in river_tiles
            if np.any(component_labels[y * TILE:(y + 1) * TILE, x * TILE:(x + 1) * TILE] == label)
        )
        source_components.append({
            "label": int(label),
            "source_component_id": "",
            "source_bbox_xyxy_px": [x0, y0, x1, y1],
            "source_bbox_xyxy_cells": [x0 // TILE, y0 // TILE,
                                       (x1 + TILE - 1) // TILE, (y1 + TILE - 1) // TILE],
            "source_native_pixel_count": pixel_count,
            "source_map_cell_count": int(component_cells),
        })
    source_components.sort(key=lambda component: (
        component["source_bbox_xyxy_px"][1], component["source_bbox_xyxy_px"][0],
        component["source_bbox_xyxy_px"][3], component["source_bbox_xyxy_px"][2]))
    for index, component in enumerate(source_components, 1):
        component["source_component_id"] = f"Metano-River-{index:02d}"
    if len(source_components) < 3:
        raise AssertionError(f"Pas assez de composantes River natives dans la carte source : {len(source_components)}")

    return {
        "canonical_map_frames": source_map_frames,
        "source_component_labels": component_labels,
        "source_components": source_components,
        "source_sheets": sheet_names,
        "source_map": "source/eau_metano/animations_carte.json",
        "source_repository": source_map["repository"],
        "source_commit": source_map["commit"],
        "source_map_git_blob": source_map.get("map_git_blob"),
        "source_map_sha256": source_map.get("map_sha256"),
        "source_active_river_cells": len(river_records),
        "source_map_size_cells": [map_width_cells, map_height_cells],
        "source_map_size_px": [map_width_cells * TILE, map_height_cells * TILE],
        "source_map_bounds_xyxy_cells": [min(xs), min(ys), max(xs), max(ys)],
        "source_map_cell_coordinates_match_texloc": True,
        "source_map_layout_reconstructed_exactly": True,
        "source_opaque_water_cells": len(opaque_water_cells),
        "source_animated_opaque_water_cells": len(animated_opaque_water),
        "source_unique_animated_opaque_sequences": len(opaque_sequence_keys),
        "source_opaque_non_surface_cells_excluded": opaque_non_surface_cells,
        "source_shoreline_cells": shoreline_cells,
        "source_animated_shoreline_cells": animated_shoreline_cells,
        "source_unique_shoreline_sequences": len(shoreline_sequence_keys),
        "source_unique_animated_shoreline_sequences": len(animated_shoreline_sequence_keys),
        "source_unique_shoreline_alpha_patterns": len(shoreline_alpha_keys),
        "source_component_count": len(source_components),
        "source_frame_length_ticks": FRAME_TICKS,
        "phase_order": [1, 2, 3, 4],
        "canonical_map_placement_in_generated_maps": False,
        "composition_method": (
            "calques sources complets reconstitués aux coordonnées example_map_cell == TexLoc; "
            "ils servent de référence native séparée. Les sorties FVF1/EVF1 proviennent d'images "
            "générées pleine carte et sont segmentées par le masque magenta original."),
    }


def official_sky_peak_flower_status() -> dict:
    """Ne fabrique aucun substitut ; signale explicitement les frames source absentes."""
    expected = [ROOT / "source/sky_peak_v1" / f"gif_{i}.png" for i in range(4)]
    named_gif = ROOT / "2cwdrrs469f61.gif"
    available = [p.relative_to(ROOT).as_posix() for p in expected if p.is_file()]
    if named_gif.is_file():
        available.append(named_gif.relative_to(ROOT).as_posix())
    return {
        "status": "official_frames_missing" if not available else "official_source_present_requires_review",
        "animation_applied": False,
        "synthetic_fallback": False,
        "original_generated_flower_art_preserved_static": True,
        "documented_official_gif": "2cwdrrs469f61.gif (504×504, 4 frames × 200 ms; source noted in renders/sky_peak_canonique_v1/README.md)",
        "expected_extracted_frames": [p.relative_to(ROOT).as_posix() for p in expected],
        "available_official_frames": available,
        "missing_official_frames": not available,
        "request": "Fournir 2cwdrrs469f61.gif ou ses quatre frames officielles Sky Peak pour débloquer l'animation.",
        "native_frame_claim": False,
    }


def generated_water_frames(
    water: np.ndarray, generated_full_map: Image.Image, code: str,
) -> tuple[list[Image.Image], dict, list[int], list[int]]:
    """Découpe l'eau générée dans le masque magenta et anime sa matière sans toucher au bord.

    La proposition générée est un rendu complet. Seuls ses pixels dans le masque tiré du brut
    magenta sont utilisés ; hors de ce masque, le décor d'origine reste la seule source.
    La boucle est un léger déplacement nearest-neighbor de la texture générée. Elle emprunte
    la cadence Métano (4 × 10 ticks), mais n'est ni l'animation native ni une tuile canonique.
    """
    if code not in {"FVF1", "EVF1"}:
        raise AssertionError(f"Code de biome inconnu pour l'animation d'eau : {code}")
    if generated_full_map.size != (SRC_W, SRC_H):
        raise AssertionError(
            f"Génération d'eau {code} hors format {(SRC_W, SRC_H)} : {generated_full_map.size}")
    if water.shape != (H, W) or not water.any():
        raise AssertionError(f"Masque d'eau invalide pour {code}: {water.shape}")

    generated_rgb = np.asarray(normalize_rgb(generated_full_map).convert("RGB"), dtype=np.uint8)
    # Pour déplacer la texture de quelques pixels, prolonge uniquement la matière d'eau par
    # son plus proche échantillon généré. Cela évite de faire entrer terre/pierres dans le masque.
    _, nearest = nd.distance_transform_edt(~water, return_indices=True)
    texture_rgb = generated_rgb.copy()
    texture_rgb[~water] = generated_rgb[nearest[0][~water], nearest[1][~water]]
    pad = 3
    padded = np.pad(texture_rgb, ((pad, pad), (pad, pad), (0, 0)), mode="reflect")
    yy, xx = np.indices((H, W), dtype=np.float32)

    if code == "EVF1":
        # Le chenal est majoritairement horizontal : petites ondulations transversales.
        flow = 2.0 * math.pi * yy / 32.0
        cross = 2.0 * math.pi * xx / 48.0
        amplitude_x, amplitude_y = 1.35, 0.55
    else:
        # Le cours d'eau encercle la clairière : déplacement doux à deux axes.
        flow = 2.0 * math.pi * (xx + 0.78 * yy) / 38.0
        cross = 2.0 * math.pi * (xx - 0.62 * yy) / 54.0
        amplitude_x, amplitude_y = 1.10, 0.75

    frames = []
    for phase in range(PHASES):
        angle = phase * math.pi / 2.0
        dx = np.rint(amplitude_x * (np.sin(flow + angle) - np.sin(flow))).astype(np.int16)
        dy = np.rint(amplitude_y * (np.sin(cross + angle) - np.sin(cross))).astype(np.int16)
        sampled = padded[pad + yy.astype(np.int16) + dy,
                         pad + xx.astype(np.int16) + dx]
        rgba = np.zeros((H, W, 4), dtype=np.uint8)
        rgba[water, :3] = sampled[water]
        rgba[water, 3] = 255
        frames.append(Image.fromarray(rgba, "RGBA"))

    phase_differences = [
        int((np.any(np.asarray(frames[0]) != np.asarray(frame), axis=2) & water).sum())
        for frame in frames[1:]
    ]
    shoreline_band = water & (nd.distance_transform_edt(water) <= TILE)
    shoreline_phase_differences = [
        int((np.any(np.asarray(frames[0]) != np.asarray(frame), axis=2) & shoreline_band).sum())
        for frame in frames[1:]
    ]
    if min(phase_differences) < int(water.sum() * 0.01):
        raise AssertionError(f"Animation générée insuffisamment visible pour {code}: {phase_differences}")
    if min(shoreline_phase_differences) < 100:
        raise AssertionError(
            f"Animation générée trop faible dans la bordure d'eau de {code}: {shoreline_phase_differences}")
    animation = {
        "method": "déplacement nearest-neighbor d'une texture générée par champ sinusoïdal déterministe",
        "phase_count": PHASES,
        "frame_length_ticks": FRAME_TICKS,
        "maximum_displacement_px": 3,
        "mask_fixed_for_all_phases": True,
        "uses_native_metano_water_pixels": False,
        "canonical_animation_claim": False,
    }
    return frames, animation, phase_differences, shoreline_phase_differences

def sparkle_positions(water: np.ndarray, assets: list[dict], seed: int, max_count: int = 18) -> list[dict]:
    """Place the unchanged 8×8 native sparkle modules wholly inside the water mask."""
    water_labels, n = nd.label(water, structure=np.ones((3, 3), dtype=bool))
    sizes = np.bincount(water_labels.ravel())
    components = [i for i in range(1, n + 1) if sizes[i] >= 64]
    if not components:
        return []
    candidates_by_component: dict[int, list[tuple[int, int]]] = {i: [] for i in components}
    union_masks = []
    for asset in assets:
        union = np.zeros((TILE, TILE), dtype=bool)
        for im in asset["frames"]:
            union |= np.asarray(im.getchannel("A")) > 0
        union_masks.append(union)
    # A tile's phase footprints can differ. Use their union for edge safety.
    union = np.logical_or.reduce(union_masks)
    uy, ux = np.nonzero(union)
    for y in range(0, H - TILE + 1, TILE):
        for x in range(0, W - TILE + 1, TILE):
            if not water[y:y + TILE, x:x + TILE].all():
                continue
            if not water[y + uy, x + ux].all():
                continue
            component = int(water_labels[y + TILE // 2, x + TILE // 2])
            if component in candidates_by_component:
                candidates_by_component[component].append((x, y))
    rng = np.random.default_rng(seed)
    placements: list[dict] = []
    # Spread the modules between separate river/lake components; never mirror or rotate.
    for component in components:
        candidates = candidates_by_component[component]
        if not candidates:
            continue
        rng.shuffle(candidates)
        quota = max(1, min(9, int(round(max_count * sizes[component] / max(1, sum(sizes[i] for i in components))))))
        component_placements = []
        for x, y in candidates:
            if any((x - q["x"]) ** 2 + (y - q["y"]) ** 2 < 24 * 24 for q in placements + component_placements):
                continue
            asset_index = (len(placements) + len(component_placements)) % len(assets)
            component_placements.append({"x": x, "y": y, "asset_index": asset_index,
                                         "source_index": assets[asset_index]["source_index"],
                                         "source_texlocs": assets[asset_index]["source_texlocs"],
                                         "component": component})
            if len(component_placements) >= quota:
                break
        placements.extend(component_placements)
        if len(placements) >= max_count:
            break
    # If a narrow but valid river has one component, allow a few extra positions.
    if len(placements) < min(6, max_count):
        candidates = [xy for group in candidates_by_component.values() for xy in group]
        rng.shuffle(candidates)
        for x, y in candidates:
            if any((x - q["x"]) ** 2 + (y - q["y"]) ** 2 < 24 * 24 for q in placements):
                continue
            asset_index = len(placements) % len(assets)
            placements.append({"x": x, "y": y, "asset_index": asset_index,
                               "source_index": assets[asset_index]["source_index"],
                               "source_texlocs": assets[asset_index]["source_texlocs"],
                               "component": int(water_labels[y + TILE // 2, x + TILE // 2])})
            if len(placements) >= min(6, max_count):
                break
    return placements[:max_count]


def sparkle_frames(placements: list[dict], assets: list[dict]) -> list[Image.Image]:
    frames = [Image.new("RGBA", (W, H), (0, 0, 0, 0)) for _ in range(PHASES)]
    arrays = [np.asarray(frame).copy() for frame in frames]
    for p in placements:
        asset = assets[p["asset_index"]]
        x, y = p["x"], p["y"]
        for phase, tile in enumerate(asset["frames"]):
            a = np.asarray(tile, dtype=np.uint8)
            dst = arrays[phase][y:y + TILE, x:x + TILE]
            mask = a[:, :, 3] > 0
            dst[mask] = a[mask]
    return [Image.fromarray(a, "RGBA") for a in arrays]


def blocked_grid(decor_rgb: Image.Image, water: np.ndarray) -> list[list[int]]:
    """Obstacle hint for visual inspection only; not a PMDO collision validation."""
    a = np.asarray(decor_rgb, dtype=np.int16)
    r, g, b = a.transpose(2, 0, 1)
    lum = a @ np.array([0.299, 0.587, 0.114], dtype=np.float32)
    sat = a.max(2) - a.min(2)
    dark_veg = (g > r * 1.15) & (g > b * 1.08) & (lum < 150)
    stone = (sat < 28) & (lum < 205) & (lum > 50)
    blocked = water | dark_veg | stone
    cells = blocked.reshape(H // TILE, TILE, W // TILE, TILE).transpose(0, 2, 1, 3).mean((2, 3)) > 0.28
    ys, xs = np.nonzero(cells)
    return [[int(x), int(y)] for y, x in zip(ys, xs)]


def tile_count(im: Image.Image) -> int:
    a = np.asarray(im.convert("RGBA"))[:, :, 3] > 0
    return int(a.reshape(H // TILE, TILE, W // TILE, TILE).any(axis=(1, 3)).sum())


def compose(layers: list[tuple[str, Image.Image]]) -> Image.Image:
    out = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    for _, layer in layers:
        out.alpha_composite(layer)
    return out


def write_ora(path: Path, layers: list[tuple[str, Image.Image]], merged: Image.Image) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    root = ET.Element("image", w=str(W), h=str(H), name=path.stem)
    stack = ET.SubElement(root, "stack")
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("mimetype", "image/openraster", compress_type=zipfile.ZIP_STORED)
        for index, (name, image) in reversed(list(enumerate(layers))):
            buf = io.BytesIO()
            image.save(buf, format="PNG", optimize=True)
            member = f"data/layer_{index:02d}.png"
            z.writestr(member, buf.getvalue())
            ET.SubElement(stack, "layer", name=name, src=member, x="0", y="0", opacity="1.0",
                          visibility="visible", **{"composite-op": "svg:src-over"})
        buf = io.BytesIO()
        merged.save(buf, format="PNG", optimize=True)
        z.writestr("mergedimage.png", buf.getvalue())
        z.writestr("stack.xml", ET.tostring(root, encoding="utf-8"))


def scene_frame(static: list[tuple[str, Image.Image]], water: list[Image.Image], sparkles: list[Image.Image], tick: int) -> Image.Image:
    """Compose une phase River native et ses scintillements, sans animer les fleurs générées."""
    water_phase = (tick // FRAME_TICKS) % PHASES
    sparkle_phase = (tick // FRAME_TICKS) % PHASES
    return compose(static + [("eau Métano", water[water_phase]), ("scintillements", sparkles[sparkle_phase])])


def save_html(maps_spec: dict) -> None:
    payload = json.dumps(maps_spec, ensure_ascii=False, separators=(",", ":"))
    html = r'''<!doctype html>
<html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Vallons Fleuris · FVF1 + EVF1 · cartes composées</title>
<style>
:root{color-scheme:dark;--bg:#101812;--panel:#19251c;--line:#3d5741;--text:#edf3e8;--muted:#aac0a8;--accent:#c7e878;--gold:#e8d28b}
*{box-sizing:border-box}body{margin:0;background:radial-gradient(ellipse at 55% -15%,#2a3b27,var(--bg) 65%);color:var(--text);font:15px/1.55 system-ui,sans-serif}
main{max-width:1440px;width:calc(100% - 32px);margin:24px auto 60px}h1{font-size:clamp(1.8rem,4vw,2.8rem);line-height:1.1;margin:.25rem 0 .6rem}h2{font-size:1.25rem;margin:26px 0 12px;border-bottom:1px solid var(--line);padding-bottom:7px}h3{font-size:1rem;margin:0 0 8px}.eyebrow{color:var(--accent);font-size:.75rem;font-weight:750;letter-spacing:.13em;text-transform:uppercase}.intro{max-width:1000px;color:var(--muted)}
.notice{border:1px solid #76633b;border-left:4px solid var(--gold);background:#29261b;color:#eee4c6;padding:12px 16px;border-radius:9px;margin:16px 0}.toolbar{display:flex;gap:9px;align-items:center;flex-wrap:wrap;padding:12px;background:#182319;border:1px solid var(--line);border-radius:10px;margin:16px 0}.toolbar label{display:inline-flex;align-items:center;gap:5px;background:#233226;padding:6px 9px;border-radius:6px;cursor:pointer}button,select,input[type=range]{accent-color:#c6e777}button,select{font:inherit;color:var(--text);background:#314836;border:1px solid #617e5b;padding:7px 10px;border-radius:6px}button{cursor:pointer}button:hover{background:#3d5d43}.scene-layout{display:grid;grid-template-columns:minmax(0,1fr) 300px;gap:14px;align-items:start}.stage{overflow:auto;background:#0b100c;border:1px solid var(--line);padding:12px;border-radius:9px;text-align:center;min-height:260px}canvas{display:block;image-rendering:pixelated;image-rendering:crisp-edges;margin:0 auto;border:1px solid #4b624c;background:repeating-conic-gradient(#162018 0 25%,#1c281e 0 50%) 50%/16px 16px}
.side{display:grid;gap:12px}.panel{background:var(--panel);border:1px solid var(--line);border-radius:9px;padding:13px}.layer-list label{display:flex;align-items:center;gap:7px;margin:7px 0;color:#dae8d3;font-size:.9rem}.small{font-size:.83rem;color:var(--muted)}.status{color:var(--gold);font-variant-numeric:tabular-nums}.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,270px),1fr));gap:12px}.card{background:var(--panel);border:1px solid var(--line);border-radius:9px;padding:12px;min-width:0}.card img{width:100%;height:auto;display:block;image-rendering:pixelated;border:1px solid #4b624c;background:#101610}.links{display:flex;gap:12px;flex-wrap:wrap;margin:8px 0}.links a,a{color:#e6d58e}.meta{font-size:.78rem;color:#91a591;overflow-wrap:anywhere}.label{display:inline-block;padding:2px 7px;border:1px solid #5a7048;border-radius:999px;color:#d3eba0;font-size:.75rem}.check{font-size:.82rem;color:#d8e7cf}.water-swatch{display:inline-block;width:14px;height:14px;border-radius:3px;border:1px solid #abc;background:linear-gradient(135deg,#8cdae6,#4d93c0);vertical-align:middle}
@media(max-width:850px){.scene-layout{grid-template-columns:1fr}.stage{min-height:220px}}@media(max-width:600px){main{width:calc(100% - 18px);margin-top:15px}.toolbar{gap:6px}.toolbar label{font-size:.85rem}.panel{padding:10px}}
</style></head><body><main>
<div class="eyebrow">Restitution des compositions Vallon Fleuri</div><h1>FVF1 · Sanctuaire &nbsp; / &nbsp; EVF1 · Entrée</h1>
<p class="intro">Les deux compositions restaurées sont reconstruites depuis leurs bruts et leur sol séparé, en 768 × 576 px (96 × 72 cases de 8 px). La génération complète de chaque carte est segmentée avec le masque magenta original : l’eau suit exactement ces formes, et les pixels générés hors masque ne sont jamais repris. Quatre phases de matière générée sont animées par déplacement subtil ; les scintillements restent natifs. Les fleurs peintes du décor restent statiques.</p>
<div class="notice"><b>Eau :</b> le magenta original est le masque exact. Une génération complète de chaque scène fournit la texture, puis le build ne prélève ses pixels qu’à l’intérieur de ce masque ; hors masque, le décor restauré reste inchangé. L’eau générée est animée par quatre déplacements subtils de texture à 10 ticks ; c’est une animation procédurale façon Métano, pas l’animation native de la carte. La référence Metano Town River de la carte Palika/Halcyon est reconstruite en quatre calques complets séparés aux coordonnées originales 142×189 (<code>example_map_cell = TexLoc</code>) et téléchargeables comme références, mais ne sont pas collés ni présentés comme pixels de FVF1/EVF1. Les scintillements restent natifs et séparés. <b>Fleurs :</b> frames officielles Sky Peak absentes ; les fleurs originales restent statiques. <code>art_approved=false</code>, <code>runtime_tested=false</code>.</div>
<div class="toolbar"><label>Carte <select id="map"></select></label><button id="play">Pause</button><label>Tick <input id="scrub" type="range" min="0" max="239" value="0"><span id="tick" class="status">0</span></label><label>Zoom <select id="zoom"><option value="1">1×</option><option value="2">2×</option></select></label><label><input type="checkbox" id="grid"> Grille 8 px</label><label><input type="checkbox" id="collision"> Collisions indicatives + marqueurs</label></div>
<div class="scene-layout"><section class="stage"><canvas id="view" width="768" height="576" aria-label="Composition complète et animée du Vallon Fleuri"></canvas><div class="small" id="clock"></div></section><aside class="side"><div class="panel"><h3>Calques · bas → haut</h3><div class="layer-list" id="layers"></div></div><div class="panel"><h3>Contrôles et provenance</h3><div class="small" id="details"></div><div class="links" id="downloads"></div></div></aside></div>
<h2>Compositions complètes, sources et exports</h2><div class="cards" id="mapcards"></div>
<script>
const MAPS=__MAPS__;
const $=s=>document.querySelector(s);const canvas=$('#view'),ctx=canvas.getContext('2d');
const state={id:'FVF1',tick:0,playing:true,zoom:1,grid:false,collisions:false,visible:{},images:{}};
const selector=$('#map'),layerHost=$('#layers'),cards=$('#mapcards');
function img(src){return new Promise((resolve,reject)=>{const i=new Image();i.onload=()=>resolve(i);i.onerror=()=>reject(new Error('Image manquante: '+src));i.src=src})}
function markerColor(m){return m.color||'#fff'}
async function preload(){for(const [id,m] of Object.entries(MAPS)){state.images[id]={};for(const l of m.layers){state.images[id][l.id]=await Promise.all(l.srcs.map(img))}}}
function renderLayerToggles(){layerHost.replaceChildren();const m=MAPS[state.id];for(const l of m.layers){state.visible[l.id]=true;const label=document.createElement('label'),check=document.createElement('input');check.type='checkbox';check.checked=true;check.onchange=()=>{state.visible[l.id]=check.checked;draw()};label.append(check,document.createTextNode(l.label));layerHost.append(label)}}
function renderCards(){cards.replaceChildren();for(const [id,m] of Object.entries(MAPS)){const card=document.createElement('article');card.className='card';card.innerHTML=`<h3><span class="label">${id}</span> ${m.title}</h3><img src="${m.review}" alt="Composition complète ${id}"><div class="links"><a href="${m.viewer_link}">Ouvrir cette carte dans le viewer</a><a href="${m.ora}">Télécharger l’ORA multicalque</a><a href="${m.manifest}">Manifeste</a></div><div class="small">Brut restauré : <a href="${m.raw_decor}">décor</a> · <a href="${m.raw_soil}">sol complet</a></div>`;cards.append(card)}}
function selectMap(id){state.id=id;state.tick=0;$('#scrub').value='0';selector.value=id;renderLayerToggles();const m=MAPS[id];const flowerState=m.flower_status.missing_official_frames?'Bloquée : frames officielles Sky Peak absentes.':'Source officielle présente, animation en attente de validation.';$('#details').innerHTML=`<b>${m.title}</b><br>${m.note}<br><br><span class="water-swatch"></span> Eau ${m.water.source} · 4 phases / 10 ticks · masque magenta exact<br>Texture complète : <a href="${m.water.generated_fill_source}">génération sauvegardée</a> · carte River canonique séparée ${m.water.source_map_size_cells[0]}×${m.water.source_map_size_cells[1]} · 3200 coordonnées = TexLoc<br>Pixels modifiés en eau P1→P2/P3/P4 : ${m.water.changed_pixels_vs_phase_1.join(', ')}<br>Pixels animés dans la bordure : ${m.water.shoreline_changed_pixels_vs_phase_1.join(', ')}<br>Calques sources complets : ${m.water.source_map_frame_paths.map((src,i)=>'<a href="'+src+'">P'+(i+1)+'</a>').join(' · ')}<br>Fleurs : ${flowerState} Les fleurs peintes d’origine restent statiques ; aucun sprite synthétique.<br><span class="small">${m.flower_status.request}</span><br>Scintillements : ${m.sparkle_count} placements natifs · 4 phases / 10 ticks<br>Calques : ${m.layers.length} · taille ${m.size_px[0]}×${m.size_px[1]} · ${m.grid[0]}×${m.grid[1]} cellules<br><br><b>Référence :</b> ${m.source_ref}<br><span class="small">Les collisions superposées sont des indices visuels, pas un bake ni un test runtime.</span>`;$('#downloads').innerHTML=`<a href="${m.ora}">ORA multicalque</a><a href="${m.manifest}">Manifest JSON</a>`;draw()}
function draw(){const m=MAPS[state.id];ctx.clearRect(0,0,768,576);for(const l of m.layers){if(!state.visible[l.id])continue;const a=state.images[state.id][l.id];const idx=Math.floor(state.tick/l.ticks)%a.length;ctx.drawImage(a[idx],0,0)}if(state.collisions){ctx.fillStyle='rgba(220,40,40,.34)';for(const [x,y] of m.blocked)ctx.fillRect(x*8,y*8,8,8);for(const marker of m.markers){ctx.strokeStyle=markerColor(marker);ctx.lineWidth=2;ctx.strokeRect(marker.xy[0]+1,marker.xy[1]+1,14,14);ctx.fillStyle=markerColor(marker);ctx.font='12px system-ui';ctx.fillText(marker.name,marker.xy[0]+17,marker.xy[1]+12)}}if(state.grid){ctx.strokeStyle='rgba(255,255,255,.18)';ctx.lineWidth=1;for(let x=0;x<=768;x+=8){ctx.beginPath();ctx.moveTo(x+.5,0);ctx.lineTo(x+.5,576);ctx.stroke()}for(let y=0;y<=576;y+=8){ctx.beginPath();ctx.moveTo(0,y+.5);ctx.lineTo(768,y+.5);ctx.stroke()}}$('#tick').textContent=state.tick;$('#clock').textContent=`${m.title} · tick ${state.tick}/${m.loop_ticks} · eau ${m.water.source} phase ${Math.floor(state.tick/10)%4+1}/4 · fleurs statiques (${m.flower_status.missing_official_frames?'frames officielles manquantes':'source à vérifier'}) · scintillements Métano phase ${Math.floor(state.tick/10)%4+1}/4`}
selector.onchange=e=>selectMap(e.target.value);$('#play').onclick=e=>{state.playing=!state.playing;e.target.textContent=state.playing?'Pause':'Lecture'};$('#scrub').oninput=e=>{state.tick=+e.target.value;draw()};$('#zoom').onchange=e=>{state.zoom=+e.target.value;canvas.style.width=(768*state.zoom)+'px';canvas.style.height=(576*state.zoom)+'px'};$('#grid').onchange=e=>{state.grid=e.target.checked;draw()};$('#collision').onchange=e=>{state.collisions=e.target.checked;draw()};
for(const [id,m] of Object.entries(MAPS))selector.add(new Option(id+' — '+m.title,id));
renderCards();preload().then(()=>{selectMap(new URLSearchParams(location.search).get('map')||'FVF1');setInterval(()=>{if(state.playing){state.tick=(state.tick+1)%MAPS[state.id].loop_ticks;$('#scrub').value=state.tick;draw()}},1000/60);document.body.dataset.ready='true'}).catch(e=>{document.body.dataset.error=e.message;$('#clock').textContent=e.message});
</script></main></body></html>'''
    (ROOT / "apercu_vallons_fleuris_v1.html").write_text(html.replace("__MAPS__", payload), encoding="utf-8")


def build_map(code: str, cfg: dict, river_assets: dict, sparkle_assets: list[dict]) -> dict:
    source_dir = ROOT / "source" / cfg["source_dir"]
    raw_dir = source_dir / "bruts"
    decor_path = raw_dir / cfg["decor_file"]
    soil_path = raw_dir / cfg["soil_file"]
    out = ROOT / "renders" / cfg["slug"]
    for folder in ("layers", "animation/eau_generee_facon_metano", "animation/scintillements", "masks", "review"):
        (out / folder).mkdir(parents=True, exist_ok=True)

    # Remove only outputs from the rejected synthetic-flower/solid-water implementation.
    for rel in ("layers/Fleur_SkyPeak_reference_7x7.png",
                "layers/01_decor_hors_eau_et_fleurs_selectionnees.png",
                "layers/02_eau_metano_131_218_230.png",
                "masks/masque_fleurs_animees.png",
                f"animation/scintillements/{code}_scintillements_phase_0.png",
                f"review/{code}_zoom_riviere_fleurs.png"):
        stale = out / rel
        if stale.exists():
            stale.unlink()
    old_flower_dir = out / "animation/fleurs"
    if old_flower_dir.is_dir():
        for stale in old_flower_dir.glob(f"{code}_fleurs_phase_*.png"):
            stale.unlink()
        try:
            old_flower_dir.rmdir()
        except OSError:
            pass

    raw_decor = Image.open(decor_path).convert("RGB")
    raw_soil = Image.open(soil_path).convert("RGB")
    if raw_decor.size != (SRC_W, SRC_H) or raw_soil.size != (SRC_W, SRC_H):
        raise AssertionError(f"Bruts {code} hors format 1200×896")
    decor = normalize_rgb(raw_decor)
    soil = normalize_rgb(raw_soil)
    raw_a = np.asarray(raw_decor, dtype=np.uint8)
    water_raw, water_diagnostics = magenta_water_mask(raw_a, suppress_foam=cfg["foam_suppression"])
    water = normalize_mask(water_raw)
    # The resize can reveal a one-pixel rose fringe that was below threshold in the source
    # raster. Catch only pink/magenta-colored pixels within 3 output pixels of the mask.
    scaled_decor = np.asarray(decor, dtype=np.int16)
    rr, gg, bb = scaled_decor.transpose(2, 0, 1)
    edge_distance = nd.distance_transform_edt(~water)
    rose_fringe = ((edge_distance <= 3.0) & (rr > 120) & (bb > 90)
                   & (rr > gg + 3) & (bb > gg + 3))
    rose_fringe_count = int((rose_fringe & ~water).sum())
    water |= rose_fringe
    water_diagnostics["rose_magenta_fringe_pixels_normalized_absorbed"] = rose_fringe_count
    water_diagnostics["water_mask_pixels_normalized"] = int(water.sum())
    water_diagnostics["edge_rule"] = "magenta or pink-tinted pixels within 3 px; no uniform dilation"
    if water.sum() < 1000:
        raise AssertionError(f"Masque magenta trop petit pour {code}: {water.sum()}")

    # Keep every original generated flower/decoration pixel outside the removed magenta.
    decor_arr = rgba_image(decor).copy()
    decor_arr[water] = 0
    decor_layer = Image.fromarray(decor_arr, "RGBA")
    soil_layer = soil.convert("RGBA")

    water_fill_path = HERE / cfg["water_fill_file"]
    water_fill = Image.open(water_fill_path).convert("RGB")
    water_frames, water_animation, water_phase_differences, shoreline_phase_differences = (
        generated_water_frames(water, water_fill, code))
    water_grid = water.reshape(H // TILE, TILE, W // TILE, TILE).any(axis=(1, 3))
    water_grid_cells = int(water_grid.sum())
    sparkle_spots = sparkle_positions(water, sparkle_assets,
                                      seed=20261014 + (0 if code == "FVF1" else 1))
    if len(sparkle_spots) < 2:
        raise AssertionError(f"Pas assez de scintillements natifs positionnables dans {code}: {len(sparkle_spots)}")
    sparkles_anim = sparkle_frames(sparkle_spots, sparkle_assets)

    soil_layer.save(out / "layers/00_sol_complet.png", optimize=True)
    decor_layer.save(out / "layers/01_decor_hors_eau_fleurs_statiques.png", optimize=True)
    water_frame_paths = []
    sparkle_frame_paths = []
    for phase in range(PHASES):
        water_rel = f"renders/{cfg['slug']}/animation/eau_generee_facon_metano/{code}_eau_facon_metano_phase_{phase + 1}.png"
        sparkle_rel = f"renders/{cfg['slug']}/animation/scintillements/{code}_scintillements_phase_{phase + 1}.png"
        water_frames[phase].save(ROOT / water_rel, optimize=True)
        sparkles_anim[phase].save(ROOT / sparkle_rel, optimize=True)
        water_frame_paths.append(water_rel)
        sparkle_frame_paths.append(sparkle_rel)
    water_frames[0].save(out / "layers/02_eau_facon_metano_phase_1.png", optimize=True)

    static = [
        ("00 Sol complet · brut généré restauré", soil_layer),
        ("01 Décor généré · magenta retiré, fleurs statiques", decor_layer),
    ]
    composed = scene_frame(static, water_frames, sparkles_anim, 0)
    composed.save(out / f"review/{code}_scene_t000.png", optimize=True)
    scene_frames = [scene_frame(static, water_frames, sparkles_anim, tick)
                    for tick in range(0, LOOP_TICKS, FRAME_TICKS)]
    scene_frames[0].save(out / f"review/{code}_scene_animee.webp", save_all=True,
                         append_images=scene_frames[1:], duration=167, loop=0, lossless=True, method=6)

    # Show a close crop containing the largest amount of generated animated water.
    crop_w, crop_h = 144, 96
    best_window = None
    for y0 in range(0, H - crop_h + 1, TILE):
        for x0 in range(0, W - crop_w + 1, TILE):
            amount = int(water[y0:y0 + crop_h, x0:x0 + crop_w].sum())
            if best_window is None or amount > best_window[0]:
                best_window = (amount, x0, y0)
    if best_window:
        _, x0, y0 = best_window
        zoom = composed.crop((x0, y0, x0 + crop_w, y0 + crop_h))
        zoom.resize((crop_w * 3, crop_h * 3), Image.Resampling.NEAREST).save(
            out / f"review/{code}_zoom_eau_generee.png", optimize=True)

    Image.fromarray(water.astype(np.uint8) * 255, "L").save(out / "masks/masque_eau.png", optimize=True)
    blocked = blocked_grid(decor, water)
    marker_data = cfg["markers"]
    layers_for_ora = static + [
        ("02 Eau générée façon Métano · masque magenta exact · phase 1/4", water_frames[0]),
        ("03 Scintillements natifs Metano River · phase 1/4", sparkles_anim[0]),
    ]
    ora_path = out / f"{code}_{cfg['slug']}_calques.ora"
    write_ora(ora_path, layers_for_ora, composed)

    spec_layers = [
        {"id": "soil", "label": "00 · sol complet généré restauré",
         "srcs": [f"renders/{cfg['slug']}/layers/00_sol_complet.png"],
         "ticks": LOOP_TICKS, "tiles": tile_count(soil_layer)},
        {"id": "decor", "label": "01 · décor généré restauré · fleurs d'origine statiques",
         "srcs": [f"renders/{cfg['slug']}/layers/01_decor_hors_eau_fleurs_statiques.png"],
         "ticks": LOOP_TICKS, "tiles": tile_count(decor_layer)},
        {"id": "water", "label": "02 · Eau générée façon Métano, dans le masque magenta, 4 phases",
         "srcs": water_frame_paths, "ticks": FRAME_TICKS,
         "tiles": sum(tile_count(frame) for frame in water_frames) // PHASES},
        {"id": "sparkles", "label": "03 · scintillements Métano natifs · 4 phases, 10 ticks/phase",
         "srcs": sparkle_frame_paths, "ticks": FRAME_TICKS,
         "tiles": sum(tile_count(frame) for frame in sparkles_anim) // PHASES},
    ]
    source_records = []
    for role, path, attribution in (("decor", decor_path, cfg["decor_attribution"]),
                                    ("soil", soil_path, cfg["soil_attribution"])):
        source_records.append({
            "role": role, "file": path.relative_to(ROOT).as_posix(), "sha256": sha256(path),
            "size_px": list(Image.open(path).size), "attribution": attribution,
        })
    source_records.append({
        "role": "generated_water_fill",
        "file": water_fill_path.relative_to(ROOT).as_posix(),
        "sha256": sha256(water_fill_path),
        "size_px": list(water_fill.size),
        "attribution": "image générée à partir du décor magenta complet; seuls les pixels du masque d'eau sont utilisés",
    })

    flower_status = official_sky_peak_flower_status()
    water_manifest = {
        key: value for key, value in river_assets.items()
        if key not in {"canonical_map_frames", "source_component_labels"}
    }
    water_manifest.update({
        "frame_count": PHASES,
        "frame_length_ticks": FRAME_TICKS,
        "output_frame_paths": water_frame_paths,
        "output_water_cells": water_grid_cells,
        "generated_fill_source": water_fill_path.relative_to(ROOT).as_posix(),
        "generated_fill_sha256": sha256(water_fill_path),
        "generated_fill_size_px": list(water_fill.size),
        "output_phase_changed_pixels_vs_1": water_phase_differences,
        "output_shoreline_phase_changed_pixels_vs_1": shoreline_phase_differences,
        "output_animation": water_animation,
        "canonical_source_map_frames_saved": river_assets["source_map_frame_paths"],
        "canonical_source_map_reconstructed_exactly": True,
        "output_rgb_values_are_generated_map_samples": True,
        "output_rgb_values_are_native_map_samples": False,
        "output_map_coordinates_canonical": False,
        "surface_patch_repeated_at_native_scale": False,
        "individual_shoreline_tile_matching_used": False,
        "mask_clip_applied": True,
        "output_scope": "texture générée complète découpée par le masque magenta original; décor hors masque inchangé",
    })
    sparkle_manifest = {
        "source": "source/eau_metano/natifs/Metano_Town_River_Sparkles.tile",
        "animation_reference": "source/eau_metano/animations_carte.json",
        "count": len(sparkle_spots), "phase_order": [1, 2, 3, 4],
        "frame_length_ticks": FRAME_TICKS, "native_pixels_unchanged": True,
        "transformations": [], "placements": sparkle_spots,
    }
    spec = {
        "code": code,
        "title": cfg["title"],
        "size_px": [W, H],
        "grid": [W // TILE, H // TILE],
        "loop_ticks": LOOP_TICKS,
        "layers": spec_layers,
        "blocked": blocked,
        "markers": marker_data,
        "water": {
            "source": "texture générée façon Métano, ajustée au masque magenta",
            "source_map": river_assets["source_map"],
            "source_repository": river_assets["source_repository"],
            "source_commit": river_assets["source_commit"],
            "source_map_size_cells": river_assets["source_map_size_cells"],
            "source_map_frame_paths": river_assets["source_map_frame_paths"],
            "source_active_river_cells": river_assets["source_active_river_cells"],
            "source_map_cell_coordinates_match_texloc": True,
            "source_map_layout_reconstructed_exactly": True,
            "canonical_map_placement_in_generated_maps": False,
            "generated_fill_source": water_fill_path.relative_to(ROOT).as_posix(),
            "generated_fill_sha256": sha256(water_fill_path),
            "generated_pixels_are_native": False,
            "canonical_animation_used_for_output_water": False,
            "frame_count": PHASES,
            "frame_length_ticks": FRAME_TICKS,
            "water_animation": water_animation,
            "map_water_cells": water_grid_cells,
            "changed_pixels_vs_phase_1": water_phase_differences,
            "shoreline_changed_pixels_vs_phase_1": shoreline_phase_differences,
        },
        "flower_status": flower_status,
        "flower_animation_count": 0,
        "sparkle_count": len(sparkle_spots),
        "source_ref": cfg["source_ref"],
        "raw_decor": f"source/{cfg['source_dir']}/bruts/{cfg['decor_file']}",
        "raw_soil": f"source/{cfg['source_dir']}/bruts/{cfg['soil_file']}",
        "review": f"renders/{cfg['slug']}/review/{code}_scene_animee.webp",
        "ora": f"renders/{cfg['slug']}/{code}_{cfg['slug']}_calques.ora",
        "manifest": f"renders/{cfg['slug']}/manifest.json",
        "viewer_link": f"apercu_vallons_fleuris_v1.html?map={code}",
        "note": ("Décor généré restauré et fleurs d'origine conservées statiques. "
                 "L'eau vient d'une génération pleine carte, découpée au masque magenta exact; "
                 "sa boucle est une animation procédurale de texture, pas l'animation native Metano. "
                 "Les quatre cartes natives Métano sont reconstruites séparément comme références, "
                 "et les scintillements sont des modules natifs. Frames officielles Sky Peak absentes."),
    }

    for frame in water_frames:
        water_alpha = np.asarray(frame.getchannel("A")) > 0
        if not np.array_equal(water_alpha, water):
            raise AssertionError(f"Le calque d'eau {code} doit couvrir exactement le masque magenta")
    for frame in sparkles_anim:
        alpha = np.asarray(frame.getchannel("A")) > 0
        if np.any(alpha & ~water):
            raise AssertionError(f"Scintillement en dehors de l'eau pour {code}")

    manifest = {
        "lot": cfg["slug"], "code": code, "title": cfg["title"],
        "canvas_px": [W, H], "grid_8px": [W // TILE, H // TILE],
        "method": ("Les compositions restaurées sont normalisées uniformément; le masque magenta "
                   "du brut délimite l'eau. Chaque image générée complète est segmentée : seuls ses "
                   "pixels dans ce masque alimentent le calque d'eau, tandis que le décor restauré "
                   "est conservé hors masque. La matière est animée par déplacement nearest-neighbor "
                   "déterministe sur quatre phases de 10 ticks. Les quatre calques source Metano Town "
                   "River sont reconstruits à leurs 3200 coordonnées example_map_cell == TexLoc et "
                   "fournis comme références séparées; leurs pixels et animation ne sont pas revendiqués "
                   "dans les calques d'eau générés."),
        "normalization": {"source_px": [SRC_W, SRC_H], "uniform_scale": SCALE,
                          "scaled_px": [SCALED_W, H],
                          "crop_x_left_right": [CROP_X, SCALED_W - W - CROP_X],
                          "method": "uniform LANCZOS RGB + masque NEAREST; aucun étirement"},
        "inputs": source_records,
        "water": water_manifest | {"mask_diagnostics": water_diagnostics, "foam_layer": False},
        "flowers": flower_status | {
            "animated_count": 0,
            "scope": "Les fleurs déjà peintes dans le décor généré restent intactes et statiques; aucun sprite de remplacement n'est créé.",
        },
        "sparkles": sparkle_manifest,
        "layer_order_bottom_to_top": [name for name, _ in layers_for_ora],
        "collisions": {"blocked_cells": len(blocked),
                       "method": "indicative visual threshold; not a Ground build or runtime-tested collision map"},
        "markers": marker_data,
        "ora": f"{code}_{cfg['slug']}_calques.ora",
        "review": {"still": f"review/{code}_scene_t000.png",
                   "webp": f"review/{code}_scene_animee.webp",
                   "webp_frames": len(scene_frames), "webp_duration_ms_each": 167,
                   "loop_ticks": LOOP_TICKS, "zoom": f"review/{code}_zoom_eau_generee.png"},
        "art_approved": False, "runtime_tested": False,
        "canonical_flower_frames_verified": False,
    }
    (out / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    (out / "viewer_spec.json").write_text(json.dumps(spec, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return spec

def build() -> None:
    river_assets = native_metano_river_tiles()
    native_map_dir = ROOT / "renders/metano_town_native_river"
    native_map_dir.mkdir(parents=True, exist_ok=True)
    source_map_frame_paths = []
    source_map_frame_sha256 = []
    for phase, frame in enumerate(river_assets["canonical_map_frames"], 1):
        relative = f"renders/metano_town_native_river/Metano_Town_River_native_map_phase_{phase}.png"
        destination = ROOT / relative
        frame.save(destination, optimize=True)
        source_map_frame_paths.append(relative)
        source_map_frame_sha256.append(sha256(destination))
    river_assets["source_map_frame_paths"] = source_map_frame_paths
    river_assets["source_map_frame_sha256"] = source_map_frame_sha256
    sparkle_assets = sparkle_animations()
    specs = {code: build_map(code, cfg, river_assets, sparkle_assets) for code, cfg in MAPS.items()}
    html_map = {}
    for code, spec in specs.items():
        html_map[code] = {
            "title": spec["title"], "size_px": spec["size_px"], "grid": spec["grid"],
            "loop_ticks": spec["loop_ticks"], "layers": spec["layers"],
            "blocked": spec["blocked"], "markers": spec["markers"],
            "water": spec["water"], "flower_status": spec["flower_status"],
            "sparkle_count": spec["sparkle_count"], "source_ref": spec["source_ref"],
            "review": spec["review"], "ora": spec["ora"], "manifest": spec["manifest"],
            "viewer_link": spec["viewer_link"], "raw_decor": spec["raw_decor"],
            "raw_soil": spec["raw_soil"], "note": spec["note"],
        }
    save_html(html_map)
    print(json.dumps({code: {
        "water_source": spec["water"]["source"],
        "water_cells": spec["water"]["map_water_cells"],
        "water_changed_pixels": spec["water"]["changed_pixels_vs_phase_1"],
        "flowers": spec["flower_status"]["status"],
        "sparkles": spec["sparkle_count"],
        "ora": spec["ora"], "webp": spec["review"],
    } for code, spec in specs.items()}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    build()
