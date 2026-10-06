#!/usr/bin/env python3
"""Build FCV3, fin du Couloir violet, pour PMDO 0.8.12.

Le rip d'entrée S05P03A guide la matière et la palette; faute de capture de la salle
finale dans ce checkout, la composition de fin est générée puis séparée en calques.
Les pixels générés ne sont pas présentés comme des tuiles natives certifiées.
"""
from __future__ import annotations

import hashlib
import importlib.util
import io
import json
import shutil
import uuid
import zipfile
from pathlib import Path
from xml.etree import ElementTree as ET

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as ndi

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
RAW = HERE / "bruts"
REFERENCE = HERE / "reference/S05P03A.png"
LAYOUT_REFERENCE = HERE / "reference/FCV2_decor.png"
OUT = ROOT / "renders/fin_couloir_violet_v3"
STAGE = ROOT / ".cache/fin_couloir_violet_v3/fin_couloir_violet_v3"
ORA = ROOT / ".cache/fin_couloir_violet_v3/FCV3_calques.ora"
PFX = "FCV3"
NAMESPACE = "fin_couloir_violet_v3"
ASSET = "fcv3_fin_couloir_violet"
W, H = 768, 576
GRID = 8
GW, GH = W // GRID, H // GRID
RAW_SIZE = (1200, 896)
PALETTE_SIZE = 96

# Contour intérieur du sol à l'échelle PMDO 768x576; l'arrivée sud rejoint l'arène.
# Le retrait au nord laisse le pied de l'autel hors de la zone de marche.
FLOOR_POLYGON = [
    (138, 102), (168, 95), (210, 92), (250, 92), (290, 95), (328, 100),
    (350, 108), (356, 120), (356, 138), (356, 154), (412, 154), (412, 138), (412, 120), (420, 108),
    (448, 100), (486, 95), (528, 92), (565, 92), (605, 96), (638, 108),
    (662, 126), (682, 151), (697, 182), (703, 215), (704, 250), (698, 282),
    (686, 314), (670, 341), (650, 367), (626, 389), (598, 407), (565, 422),
    (530, 437), (493, 450), (455, 463), (423, 478), (414, 500), (414, 575),
    (354, 575), (354, 500), (345, 478), (338, 463), (315, 450), (278, 437),
    (241, 422), (204, 407), (171, 389), (145, 367), (122, 341), (100, 314),
    (84, 282), (70, 250), (65, 215), (72, 182), (88, 151), (108, 126),
    (132, 108),
]

# Obstacles solides relevés sur la composition : l'autel et les massifs de blocs
# au pourtour. Les petits gravillons restent des détails visuels praticables.
OBSTACLE_POLYGONS = {
    "autel_nord": [(351, 92), (417, 92), (419, 142), (351, 142)],
    "arche_pilier_ouest": [(315, 83), (342, 79), (356, 98), (352, 153),
                           (340, 163), (322, 146), (310, 112)],
    "arche_pilier_est": [(426, 79), (453, 83), (458, 112), (446, 146),
                         (428, 163), (416, 153), (412, 98)],
    "blocs_nord_ouest": [(93, 112), (125, 96), (158, 104), (181, 130),
                         (165, 158), (135, 174), (108, 159), (91, 137)],
    "blocs_nord_est": [(588, 103), (622, 96), (652, 111), (676, 140),
                       (657, 169), (628, 180), (603, 159), (586, 137)],
    "blocs_ouest": [(62, 211), (91, 202), (113, 225), (123, 258),
                    (111, 289), (82, 300), (65, 276)],
    "blocs_est": [(656, 205), (687, 213), (707, 239), (706, 272),
                  (686, 300), (659, 292), (646, 260)],
    "eboulis_sud_ouest": [(276, 414), (309, 407), (337, 425), (354, 452),
                          (343, 475), (316, 459), (291, 439)],
    "eboulis_sud_est": [(425, 421), (454, 405), (484, 414), (506, 438),
                        (499, 462), (472, 457), (443, 475), (421, 452)],
}

# Échantillons sans rochers ni sigil : un couloir du rip et un replat nord-ouest.
REFERENCE_FLOOR_SAMPLE = (120, 280, 190, 620)  # left, top, right, bottom
GENERATED_FLOOR_SAMPLE = (230, 190, 330, 270)  # left, top, right, bottom
SIGIL_CENTER = (384, 304)
SIGIL_RADIUS = (143, 128)
FIDELITY_THRESHOLD = 35.0


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Impossible de charger {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def read_rgb(path: Path) -> np.ndarray:
    with Image.open(path) as image:
        return np.asarray(image.convert("RGB"), dtype=np.uint8)


def polygon_mask(points, size=(W, H)) -> np.ndarray:
    image = Image.new("L", size, 0)
    ImageDraw.Draw(image).polygon(points, fill=255)
    return np.asarray(image, dtype=np.uint8) > 0


def normalize_image(path: Path) -> tuple[np.ndarray, dict]:
    """Pad 2 px en haut/bas puis réduire uniformément 0,64 (BOX), sans étirement."""
    with Image.open(path) as image:
        image = image.convert("RGB")
        if image.size != RAW_SIZE:
            raise ValueError(f"image attendue {RAW_SIZE}, reçue {image.size} pour {path}")
        source_size = image.size
        array = np.asarray(image, dtype=np.uint8)
        array = np.pad(array, ((2, 2), (0, 0), (0, 0)), mode="edge")
        output = Image.fromarray(array).resize((W, H), Image.Resampling.BOX)
        output_array = np.asarray(output, dtype=np.uint8)
    return output_array, {
        "source_px": list(source_size), "normalized_px": [1200, 900],
        "output_px": [W, H], "scale_xy": [0.64, 0.64],
        "method": "pad par répétition des bords de 2 px haut/bas, puis réduction BOX uniforme; aucun étirement",
    }


def rgba(rgb: np.ndarray, mask: np.ndarray) -> np.ndarray:
    out = np.zeros((H, W, 4), dtype=np.uint8)
    out[..., :3] = rgb
    out[..., 3] = np.where(mask, 255, 0).astype(np.uint8)
    out[~mask] = 0
    return out


def quantize_layers(layers: dict[str, np.ndarray], colors: int = PALETTE_SIZE):
    """Palette commune sans tramage; les pixels transparents restent transparents."""
    samples = [array[array[..., 3] > 0, :3] for array in layers.values()
               if np.any(array[..., 3] > 0)]
    if not samples:
        raise ValueError("Aucun pixel opaque à quantifier")
    all_rgb = np.concatenate(samples, axis=0)
    image_1d = Image.fromarray(all_rgb.reshape(-1, 1, 3).astype(np.uint8))
    palette_image = image_1d.quantize(colors=colors, method=Image.Quantize.MEDIANCUT,
                                      dither=Image.Dither.NONE)
    palette = np.asarray(palette_image.getpalette()[:colors * 3], dtype=np.uint8).reshape(-1, 3)
    output = {}
    for name, source in layers.items():
        result = source.copy()
        visible = result[..., 3] > 0
        if np.any(visible):
            indices = np.asarray(Image.fromarray(result[..., :3]).quantize(
                palette=palette_image, dither=Image.Dither.NONE), dtype=np.uint8)
            result[..., :3][visible] = palette[indices[visible]]
        result[result[..., 3] == 0] = 0
        output[name] = result
    return output, palette


def make_masks(decor: np.ndarray) -> tuple[dict[str, np.ndarray], dict]:
    """Partition des matières, extraction du sigil lumineux et géométrie de marche."""
    if decor.shape != (H, W, 3):
        raise ValueError(f"décor attendu {(H, W, 3)}, reçu {decor.shape}")
    floor_outline = polygon_mask(FLOOR_POLYGON)
    obstacle_parts = {name: polygon_mask(points) for name, points in OBSTACLE_POLYGONS.items()}
    obstacle_union = np.logical_or.reduce(list(obstacle_parts.values())) & floor_outline
    walkable = floor_outline & ~obstacle_union

    red, green, blue = (decor[..., channel].astype(np.float32) for channel in range(3))
    luminance = decor.astype(np.float32) @ np.array([0.299, 0.587, 0.114], dtype=np.float32)
    yy, xx = np.ogrid[:H, :W]
    cx, cy = SIGIL_CENTER
    rx, ry = SIGIL_RADIUS
    sigil_zone = ((xx - cx) / rx) ** 2 + ((yy - cy) / ry) ** 2 <= 1.0
    # Isole la gravure lilas sans prendre le sol ou les ombres de même zone.
    violet_glow = ((red >= 96) & (green >= 66) & (blue >= 98)
                   & (red - green >= 13) & (blue - green >= 16)
                   & (blue >= red * 0.92) & (luminance >= 108))
    gravure = walkable & sigil_zone & violet_glow

    local_mean = ndi.uniform_filter(luminance, size=5, mode="nearest")
    local_second = ndi.uniform_filter(luminance * luminance, size=5, mode="nearest")
    local_sd = np.sqrt(np.maximum(local_second - local_mean * local_mean, 0.0))
    floor_luminance = luminance[walkable & ~gravure]
    if not floor_luminance.size:
        raise AssertionError("Aucun pixel de sol praticable")
    shadow_cutoff = float(np.quantile(floor_luminance, 0.25))
    shadows = walkable & ~gravure & (luminance < shadow_cutoff) & (local_sd > 2.0)
    sol = walkable & ~shadows & ~gravure
    parois = ~walkable

    glow_strength = ndi.gaussian_filter(gravure.astype(np.float32), sigma=3.6, mode="nearest")
    glow_alpha = np.clip(glow_strength * 78.0, 0, 48).astype(np.uint8)
    glow_alpha[gravure] = 0
    glow_alpha[~walkable] = 0
    glow_alpha[glow_alpha < 3] = 0
    lueur = glow_alpha > 0

    visual_masks = {"sol": sol, "ombres": shadows, "gravure": gravure, "parois": parois}
    coverage = np.stack(list(visual_masks.values())).sum(axis=0)
    if not np.all(coverage == 1):
        raise AssertionError("Les calques de matière ne partitionnent pas chaque pixel exactement une fois")

    masks = {**visual_masks, "lueur": lueur, "praticable": walkable, "obstacles_visuels": ~walkable}
    component_masks = {name: int(mask.sum()) for name, mask in obstacle_parts.items()}
    return masks, {
        "floor_outline": "polygone du sol intérieur relevé sur le rendu 768x576; aucun pixel source n'est repeint",
        "collision_geometry": {
            "method": "contour intérieur du sol + empreintes polygonales des massifs, piliers d'arche et autel; gravillons mineurs praticables",
            "manual_coordinates": True,
            "major_obstacles": list(OBSTACLE_POLYGONS),
            "floor_outline_pixels": int(floor_outline.sum()),
            "major_obstacle_pixels_inside_floor": int(obstacle_union.sum()),
            "walkable_pixels": int(walkable.sum()),
            "blocked_pixels": int((~walkable).sum()),
        },
        "sigil": {
            "method": "pixels lilas lumineux isolés par teinte/luminance dans une ellipse manuelle centrée sur les trois anneaux gravés",
            "center_px": list(SIGIL_CENTER), "radius_px": list(SIGIL_RADIUS),
            "pixels": int(gravure.sum()), "glow_pixels": int(lueur.sum()),
        },
        "shadows": {
            "method": "sol praticable hors gravure sous le 25e percentile de luminance et écart-type local 5x5 > 2; détail décoratif praticable",
            "luminance_cutoff": round(shadow_cutoff, 2),
            "pixels": int(shadows.sum()),
        },
        "visual_partition": {name: int(mask.sum()) for name, mask in visual_masks.items()},
        "additive_glow_pixels": int(lueur.sum()),
        "obstacle_polygon_pixel_counts_unclipped": component_masks,
    }


def make_glow_layer(gravure: np.ndarray, glow_mask: np.ndarray) -> np.ndarray:
    """Halo lilas translucide extrait de la gravure, sans recolorer le dessin source."""
    strength = ndi.gaussian_filter(gravure.astype(np.float32), sigma=3.6, mode="nearest")
    alpha = np.clip(strength * 78.0, 0, 48).astype(np.uint8)
    alpha[gravure] = 0
    alpha[~glow_mask] = 0
    alpha[alpha < 3] = 0
    output = np.zeros((H, W, 4), dtype=np.uint8)
    output[..., 0] = 190
    output[..., 1] = 125
    output[..., 2] = 243
    output[..., 3] = alpha
    output[alpha == 0] = 0
    return output


def cell_grid(nonwalk: np.ndarray) -> np.ndarray:
    if nonwalk.shape != (H, W):
        raise ValueError(f"masque attendu {(H, W)}, reçu {nonwalk.shape}")
    fraction = nonwalk.reshape(GH, GRID, GW, GRID).mean(axis=(1, 3))
    return fraction >= 0.25


def footprint_free(blocked: np.ndarray, y: int, x: int) -> bool:
    return (0 <= y <= GH - 2 and 0 <= x <= GW - 2 and not blocked[y:y + 2, x:x + 2].any())


def reachable_2x2(blocked: np.ndarray, start: tuple[int, int], goal: tuple[int, int]):
    """BFS sur la grille 8 px avec empreinte de personnage de 16 × 16 px."""
    if not footprint_free(blocked, *start) or not footprint_free(blocked, *goal):
        return False, 0, []
    seen = np.zeros((GH, GW), dtype=bool)
    previous, queue = {}, [start]
    seen[start] = True
    for y, x in queue:
        if (y, x) == goal:
            path = [(y, x)]
            while path[-1] != start:
                path.append(previous[path[-1]])
            return True, int(seen.sum()), list(reversed(path))
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = y + dy, x + dx
            if (0 <= ny < GH and 0 <= nx < GW and not seen[ny, nx]
                    and footprint_free(blocked, ny, nx)):
                seen[ny, nx] = True
                previous[(ny, nx)] = (y, x)
                queue.append((ny, nx))
    return False, int(seen.sum()), []


def choose_markers(blocked: np.ndarray, walkable: np.ndarray) -> dict:
    starts = [(y, x) for y in range(GH - 8, GH - 2)
              for x in range(GW // 2 - 7, GW // 2 + 7) if footprint_free(blocked, y, x)]
    if not starts:
        raise AssertionError("Arrivée sud introuvable")
    start = min(starts, key=lambda p: (abs(p[0] - (GH - 4)) + abs(p[1] - (GW // 2 - 1)), p))

    objectives = [(y, x) for y in range(16, GH // 3 + 1)
                  for x in range(GW // 2 - 6, GW // 2 + 7) if footprint_free(blocked, y, x)]
    if not objectives:
        raise AssertionError("Objectif nord introuvable près de l'autel")
    target_objective = (21, GW // 2 - 1)
    objective = min(objectives, key=lambda p: ((p[0] - target_objective[0]) ** 2 +
                                                (p[1] - target_objective[1]) ** 2, p))

    bosses = [(y, x) for y in range(GH // 4, 3 * GH // 4)
              for x in range(GW // 2 - 18, GW // 2 + 18) if footprint_free(blocked, y, x)]
    if not bosses:
        raise AssertionError("Case d'arène centrale introuvable")
    target_boss = (SIGIL_CENTER[1] / GRID - 0.5, SIGIL_CENTER[0] / GRID - 0.5)
    boss = min(bosses, key=lambda p: ((p[0] + 0.5 - target_boss[0]) ** 2 +
                                      (p[1] + 0.5 - target_boss[1]) ** 2, p))

    reach_boss, explored_boss, path_boss = reachable_2x2(blocked, start, boss)
    reach_objective, explored_objective, path_objective = reachable_2x2(blocked, start, objective)
    if not reach_boss or not reach_objective:
        raise AssertionError("Pas de chemin 16x16 sud → arène et objectif nord")
    return {
        "entry_cell_yx": list(start), "boss_cell_yx": list(boss), "objective_cell_yx": list(objective),
        "entry_px": [start[1] * GRID, start[0] * GRID],
        "boss_px": [boss[1] * GRID, boss[0] * GRID],
        "objective_px": [objective[1] * GRID, objective[0] * GRID],
        "path_to_boss_16x16": True, "path_to_objective_16x16": True,
        "path_boss_cells": len(path_boss), "path_objective_cells": len(path_objective),
        "cells_explored_to_boss": explored_boss, "cells_explored_to_objective": explored_objective,
        "blocked_cells": int(blocked.sum()), "walkable_cells": int((~blocked).sum()),
        "rule": "case bloquée si au moins 25 % de ses pixels sont hors du masque praticable; empreinte joueur 16x16 px",
        "boss_rule": "case 2x2 libre la plus proche du centre de l'anneau gravé (autour de 384,304 px)",
        "objective_rule": "case 2x2 libre la plus proche du point cible (x milieu, y=21), juste au sud de l'autel nord",
        "exit_and_warp": "aucun",
    }


def reference_fidelity(decor: np.ndarray, floor: np.ndarray) -> dict:
    ref = read_rgb(REFERENCE)
    rx0, ry0, rx1, ry1 = REFERENCE_FLOOR_SAMPLE
    gx0, gy0, gx1, gy1 = GENERATED_FLOOR_SAMPLE
    ref_pixels = ref[ry0:ry1, rx0:rx1].astype(np.float32)
    generated_pixels = decor[gy0:gy1, gx0:gx1].astype(np.float32)
    base_pixels = floor[gy0:gy1, gx0:gx1].astype(np.float32)
    ref_mean = ref_pixels.mean(axis=(0, 1))
    generated_mean = generated_pixels.mean(axis=(0, 1))
    base_mean = base_pixels.mean(axis=(0, 1))
    decor_distance = float(np.linalg.norm(generated_mean - ref_mean))
    base_distance = float(np.linalg.norm(base_mean - ref_mean))
    return {
        "method": "mean RGB Euclidean distance; source sample is the unobstructed corridor x=120:190,y=280:620; generated sample is the clear north-west floor x=230:330,y=190:270, outside the engraved sigil",
        "reference_map": "S05P03A",
        "reference_sample_ltrb": [rx0, ry0, rx1, ry1],
        "generated_sample_ltrb": [gx0, gy0, gx1, gy1],
        "reference_floor_rgb": [round(float(v), 2) for v in ref_mean],
        "generated_floor_rgb": [round(float(v), 2) for v in generated_mean],
        "generated_floor_distance": round(decor_distance, 2),
        "full_floor_base_rgb": [round(float(v), 2) for v in base_mean],
        "full_floor_base_distance": round(base_distance, 2),
        "threshold": FIDELITY_THRESHOLD,
        "generated_floor_pass": decor_distance < FIDELITY_THRESHOLD,
        "full_floor_base_pass": base_distance < FIDELITY_THRESHOLD,
        "note": "Mesure de cohérence de matière/couleur, pas une preuve de copie pixel à pixel.",
    }


def composite(stack: list[np.ndarray]) -> Image.Image:
    result = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    for layer in stack:
        result.alpha_composite(Image.fromarray(layer, "RGBA"))
    return result


def save_png(path: Path, array: np.ndarray) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(array).save(path, optimize=True)


def write_ora(path: Path, named_layers: list[tuple[str, np.ndarray]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    root = ET.Element("image", w=str(W), h=str(H), name="FCV3 — Fin Couloir violet")
    xml_stack = ET.SubElement(root, "stack")
    merged = composite([array for _, array in named_layers])
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        archive.writestr("mimetype", "image/openraster", compress_type=zipfile.ZIP_STORED)
        for index, (name, array) in reversed(list(enumerate(named_layers))):
            filename = f"data/layer{index:02d}.png"
            ET.SubElement(xml_stack, "layer", name=name, src=filename, x="0", y="0", opacity="1.0",
                          visibility="visible", **{"composite-op": "svg:src-over"})
            stream = io.BytesIO()
            Image.fromarray(array, "RGBA").save(stream, format="PNG", compress_level=9)
            archive.writestr(filename, stream.getvalue())
        stream = io.BytesIO()
        merged.save(stream, format="PNG", compress_level=9)
        archive.writestr("mergedimage.png", stream.getvalue())
        thumbnail = merged.copy()
        thumbnail.thumbnail((256, 256), Image.Resampling.LANCZOS)
        stream = io.BytesIO()
        thumbnail.save(stream, format="PNG")
        archive.writestr("Thumbnails/thumbnail.png", stream.getvalue())
        archive.writestr("stack.xml", ET.tostring(root, encoding="utf-8", xml_declaration=True))


def ground_project(stack: list[tuple[str, np.ndarray]], blocked: np.ndarray, access: dict) -> dict[str, int]:
    gfx = load_module("pmdo_codec_fcv3", ROOT / "source/pmdo_cote/build.py")
    index_tools = load_module("pmdo_index_tools_fcv3", ROOT / "source/pmdo_cote/INSTALLER.py")
    template_path = ROOT / "cliffdaytest.rsground"
    if not template_path.is_file():
        raise FileNotFoundError(f"Template Ground PMDO attendu : {template_path}")
    template = json.loads(template_path.read_text(encoding="utf-8-sig"))
    if STAGE.exists():
        shutil.rmtree(STAGE)
    (STAGE / "Content/Tile").mkdir(parents=True)
    (STAGE / f"Data/Script/{NAMESPACE}/ground/{ASSET}").mkdir(parents=True)
    (STAGE / "Data/Ground").mkdir(parents=True)

    ground_layers, banks = [], []
    for index, (title, image) in enumerate(stack):
        bank = gfx.TileBank(f"{PFX}_{index:02d}_{title.split()[0].upper()}")
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)

        def cells(x, y, bank=bank, image=image):
            tile_image = Image.fromarray(image[y * GRID:(y + 1) * GRID, x * GRID:(x + 1) * GRID], "RGBA")
            tile = bank.add(tile_image, x, y)
            return [tile] if tile else []

        ground_layers.append(gfx.layer(f"{index:02d} {title}", GW, GH, cells))
        banks.append(bank)
    ground_layers.append(gfx.layer(f"{len(ground_layers):02d} Top (vide)", GW, GH, draw=4))
    for bank in banks:
        bank.write(STAGE / f"Content/Tile/{bank.name}.tile")

    obj = template["Object"]
    obj.update({
        "TexSize": 1,
        "Name": {"DefaultText": "Fin Couloir violet — sanctuaire du sigil", "LocalTexts": {}},
        "AssetName": ASSET, "Released": False,
        "Comment": ("PMDO 0.8.12. Passe FCV3 : sanctuaire rocheux violet, sigil gravé au centre, "
                    "entrée sud et autel sous arche au nord. Composition générée; le rip S05P03A guide la matière. "
                    "Pas de tileset natif certifié; marqueurs d'édition, sans warp ni sortie."),
        "Music": "", "EdgeView": 1, "ViewCenter": None,
        "ViewOffset": {"X": 0, "Y": 0}, "ActiveChar": None, "Status": {},
        "Background": {"$type": "RogueEssence.Dungeon.LayeredBG, RogueEssence", "Layers": []},
        "Layers": ground_layers,
        "Decorations": [{"Name": "Vos decorations", "Layer": 2, "Visible": True, "Anims": []}],
    })
    obj["obstacles"] = [[
        {"Bounds": {"X": x * GRID, "Y": y * GRID, "Width": GRID, "Height": GRID},
         "Tags": int(blocked[y, x])}
        for y in range(GH)] for x in range(GW)]
    marker = lambda name, point: {
        "EntName": name, "Direction": 4, "EntEnabled": True, "triggerType": 0,
        "Collider": {"X": point[0], "Y": point[1], "Width": 16, "Height": 16},
    }
    obj["Entities"] = [{
        "Name": "Arrivée, arène et objectif (repères d'édition)", "Visible": True,
        "MapChars": [], "GroundObjects": [], "Spawners": [],
        "Markers": [marker("entrance", access["entry_px"]), marker("boss", access["boss_px"]),
                    marker("objectif", access["objective_px"])],
    }]
    template["Version"] = "0.8.12.0"
    gfx.save(STAGE / f"Data/Ground/{ASSET}.rsground",
             json.dumps(template, ensure_ascii=False, separators=(",", ":")).encode("utf-8"))
    gfx.save(STAGE / f"Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua",
             (f"-- {ASSET}: repères d'édition seulement, aucun warp ni destination.\n"
              f"local {ASSET} = {{}}\nreturn {ASSET}\n").encode("utf-8"))

    nodes = {}
    for tile_path in sorted((STAGE / "Content/Tile").glob("*.tile")):
        with tile_path.open("rb") as stream:
            nodes[tile_path.stem] = index_tools.read_node(stream)
    (STAGE / "Content/Tile/index.idx").write_bytes(index_tools.encode_index(nodes))

    mod_uuid = uuid.uuid5(uuid.NAMESPACE_URL,
                          "https://github.com/meromoonmeri/projet-creation-pmdo/" + NAMESPACE)
    (STAGE / "Mod.xml").write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Couloir violet FCV3 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Sanctuaire violet de fin de donjon, sigil gravé, entrée sud et autel nord. Projet de carte, sans warp.</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{mod_uuid}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''', encoding="utf-8")

    installer_source = (ROOT / "source/pmdo_cote/INSTALLER.py").read_text(encoding="utf-8")
    needle = "            relative = src.relative_to(source)\n"
    if needle not in installer_source:
        raise RuntimeError("Le point d'extension de l'installeur a changé; relire la méthode locale avant patch")
    installer_source = installer_source.replace(
        needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n", 1)
    (STAGE / "INSTALLER.py").write_text(installer_source, encoding="utf-8")
    shutil.copyfile(HERE / "README_PACK.md", STAGE / "README.md")
    return {bank.name: len(bank.data) for bank in banks}


def build() -> dict:
    decor_path = RAW / "decor.png"
    floor_path = RAW / "sol_complet.png"
    for required in (decor_path, floor_path, REFERENCE, LAYOUT_REFERENCE):
        if not required.is_file():
            raise FileNotFoundError(f"Fichier d'entrée requis absent : {required}")

    decor, decor_normalization = normalize_image(decor_path)
    full_floor, floor_normalization = normalize_image(floor_path)
    fidelity = reference_fidelity(decor, full_floor)
    if not fidelity["generated_floor_pass"]:
        raise ValueError(f"Sol généré trop éloigné du rip S05P03A : {fidelity['generated_floor_distance']}"
                         f" RGB > seuil {FIDELITY_THRESHOLD}")
    masks, segmentation = make_masks(decor)
    walkable = masks["praticable"]
    blocked = cell_grid(~walkable)
    access = choose_markers(blocked, walkable)

    raw_layers = {
        "00_sol_complet": rgba(full_floor, np.ones((H, W), dtype=bool)),
        "01_sol": rgba(decor, masks["sol"]),
        "02_ombres": rgba(decor, masks["ombres"]),
        "03_gravure_lumineuse": rgba(decor, masks["gravure"]),
        "04_lueur_sigil": make_glow_layer(masks["gravure"], masks["lueur"]),
        "05_parois": rgba(decor, masks["parois"]),
    }
    layers, palette = quantize_layers(raw_layers, PALETTE_SIZE)
    top = np.zeros((H, W, 4), dtype=np.uint8)

    OUT.mkdir(parents=True, exist_ok=True)
    for folder in ("calques", "masques", "review"):
        shutil.rmtree(OUT / folder, ignore_errors=True)
        (OUT / folder).mkdir(parents=True, exist_ok=True)
    for name, image in layers.items():
        save_png(OUT / "calques" / f"{PFX}_{name}.png", image)
    save_png(OUT / "calques" / f"{PFX}_06_top.png", top)
    for name, mask in masks.items():
        save_png(OUT / "masques" / f"{PFX}_masque_{name}.png", mask.astype(np.uint8) * 255)
    save_png(OUT / "masques" / f"{PFX}_masque_bloque_8px.png", blocked.astype(np.uint8) * 255)

    ordered = [layers[name] for name in raw_layers] + [top]
    scene = composite(ordered)
    scene_array = np.asarray(scene, dtype=np.uint8)
    if not np.all(scene_array[..., 3] == 255):
        raise AssertionError("La composition comporte des pixels transparents")
    save_png(OUT / "review" / f"{PFX}_scene_t000.png", scene_array)
    save_png(OUT / "review" / f"{PFX}_scene_x2.png",
             np.asarray(scene.resize((W * 2, H * 2), Image.Resampling.NEAREST), dtype=np.uint8))

    collision_view = scene.copy()
    overlay = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    for y, x in zip(*np.nonzero(blocked)):
        draw.rectangle((x * GRID, y * GRID, x * GRID + GRID - 1, y * GRID + GRID - 1),
                       fill=(225, 40, 45, 92))
    for point, color in ((access["entry_px"], (255, 235, 45, 255)),
                         (access["boss_px"], (255, 65, 220, 255)),
                         (access["objective_px"], (65, 220, 255, 255))):
        draw.rectangle((point[0], point[1], point[0] + 15, point[1] + 15), outline=color, width=2)
    collision_view.alpha_composite(overlay)
    save_png(OUT / "review" / f"{PFX}_collisions_marqueurs.png", np.asarray(collision_view))

    ora_layers = [(name.replace("_", " "), image) for name, image in layers.items()]
    ora_layers.append(("06 Top vide", top))
    write_ora(ORA, ora_layers)
    tile_counts = ground_project(list(zip(layers.keys(), layers.values())), blocked, access)

    generation = json.loads((HERE / "generation.json").read_text(encoding="utf-8"))
    inputs = []
    for path in (decor_path, floor_path, REFERENCE, LAYOUT_REFERENCE):
        with Image.open(path) as image:
            size = list(image.size)
        inputs.append({
            "file": path.relative_to(ROOT).as_posix(), "sha256": sha256(path), "size_px": size,
            "role": "composition FCV3 générée avec références matière et layout" if path == decor_path else
                    "fond de sol complet repris sans retouche du socle FCV2" if path == floor_path else
                    "rendu PMD-Sky de la carte d'entrée S05P03A, référence matière" if path == REFERENCE else
                    "composition FCV2 conservée comme repère de continuité spatiale",
        })

    manifest = {
        "lot": "fin_couloir_violet_v3",
        "title": "Fin Couloir violet — sanctuaire du sigil gravé",
        "prefix": PFX, "namespace": NAMESPACE, "asset": ASSET,
        "type": "fin de donjon / arène naturelle",
        "format": "4:3 vaste", "size_px": [W, H], "grid_px": GRID, "grid_cells": [GW, GH],
        "user_request": "faire une carte magnifique pour la fin du Couloir violet en préservant la version FCV2",
        "agent_choices": {
            "reference": "rip rendu de l'entrée S05P03A, car aucune capture de la salle finale n'a été trouvée dans ce checkout ou sur la branche sœur consultée",
            "layout": "entrée sud, grande arène centrale avec sigil gravé lumineux, arche et autel au nord; composition nouvelle basée sur FCV2 sans le modifier",
            "prefix": PFX,
            "prefix_status": "FCV1 était déjà réservé; FCV3, d'abord contrôlé dans main et la tête sœur, a ensuite été re-vérifié dans main et les deux têtes arena distantes disponibles avant empaquetage; aucune collision trouvée",
            "biome": "prolongement rocheux violet guidé par S05P03A; intitulé de travail, pas une désignation canonique de l'utilisateur",
        },
        "generation": generation,
        "inputs": inputs,
        "normalization": {
            "decor": decor_normalization, "sol_complet": floor_normalization,
            "shared_palette_limit": PALETTE_SIZE, "shared_palette_colors_used": int(len(np.unique(palette, axis=0))),
            "dither": False, "reference_fidelity": fidelity,
        },
        "segmentation": segmentation,
        "layers": [
            {"name": name, "file": f"calques/{PFX}_{name}.png", "phases": 1,
             "frame_length_ticks": 60, "order": index,
             "alpha_mode": "graduée 3–48/255, halo prémultiplié par le codec Ground" if name == "04_lueur_sigil" else "binaire 0/255"}
            for index, name in enumerate(layers)
        ] + [{"name": "06_top", "file": f"calques/{PFX}_06_top.png", "phases": 1,
              "frame_length_ticks": 60, "order": 6, "ground_layer": 6,
              "alpha_mode": "transparent 0"}],
        "access": access,
        "pmdo": {"target": "0.8.12.0", "version": "0.8.12.0", "tile_banks": tile_counts,
                 "runtime_tested": False, "markers": ["entrance", "boss", "objectif"],
                 "warp": "aucun", "exit": "aucune"},
        "art_approved": False, "runtime_tested": False,
        "notes": [
            "Le choix de S05P03A comme référence matière, la continuité spatiale avec FCV2, le sigil central, l'arche, le biome de travail et le préfixe FCV3 sont des choix d'agent, non des décisions canoniques de l'utilisateur.",
            "Aucune capture de vraie salle finale n'a été trouvée dans le checkout ni sur la branche sœur distante consultée; la référence utilisée est le rip rendu de l'entrée S05P03A.",
            "La composition de FCV3 est une nouvelle passe générée en s'appuyant sur S05P03A pour la matière et FCV2 pour la continuité; le contrôle RGB porte sur un échantillon de sol hors sigil, pas une preuve de copie pixel à pixel ni de tuiles natives certifiées.",
            "Le sol reste une roche naturelle continue; les points lilas périphériques sont des accents de lichen lumineux, pas des objets de gameplay. Aucun personnage, warp ou sortie n'est ajouté.",
            "Les polygones d'obstacles sont des repères d'édition de collision; gravillons et textures ne garantissent pas le passage dans PMDO en jeu.",
            "Les tests vérifient les artefacts locaux et l'accessibilité géométrique 16x16; le runtime PMDO n'a pas été lancé.",
        ],
    }
    (OUT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    shutil.copyfile(HERE / "README_PACK.md", OUT / "README.md")
    shutil.copyfile(OUT / "manifest.json", STAGE / "manifest.json")
    shutil.copyfile(HERE / "README_PACK.md", STAGE / "README.md")

    summary = {
        "scene": str((OUT / "review" / f"{PFX}_scene_t000.png").relative_to(ROOT)),
        "layers": len(layers) + 1, "size_px": [W, H], "grid_cells": [GW, GH],
        "entry_px": access["entry_px"], "boss_px": access["boss_px"],
        "objective_px": access["objective_px"], "path_16x16": True,
        "reference_floor_rgb": fidelity["reference_floor_rgb"],
        "generated_floor_rgb": fidelity["generated_floor_rgb"],
        "reference_rgb_distance": fidelity["generated_floor_distance"],
        "tiles": sum(tile_counts.values()), "stage": str(STAGE.relative_to(ROOT)),
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return manifest


if __name__ == "__main__":
    build()
