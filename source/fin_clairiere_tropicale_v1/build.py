#!/usr/bin/env python3
"""Build FTL1, fin de la Clairière tropicale, pour PMDO 0.8.12.

Lot choisi depuis la file locale REPRISE_MAPS.md. La référence canonique d'ETC1 et
ses bruts ne sont pas présents dans ce checkout; sa documentation fournit seulement
les mesures de couleur reprises ici comme guide, sans prétendre à une fidélité pixel.
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
OUT = ROOT / "renders/fin_clairiere_tropicale_v1"
STAGE = ROOT / ".cache/fin_clairiere_tropicale_v1/fin_clairiere_tropicale"
ORA = ROOT / ".cache/fin_clairiere_tropicale_v1/FTL1_calques.ora"
PFX = "FTL1"
NAMESPACE = "fin_clairiere_tropicale"
ASSET = "ftl1_fin_clairiere_tropicale"
W, H = 768, 576
GRID = 8
GW, GH = W // GRID, H // GRID
RAW_SIZE = (1200, 896)
PALETTE_TARGET = np.array([182.6, 213.5, 96.7], dtype=np.float32)
PALETTE_SIZE = {"terrain": 80, "jungle": 72, "racines": 56, "fleurs": 40}

# Intérieur de la clairière; le couloir garde son raccord sud et mène au pied de l'arbre au nord.
# Coordonnées uniquement pour la forme du sol et non pour les plantes, fleurs ou arbres.
FLOOR_POLYGON = [
    (384, 110), (417, 118), (451, 132), (487, 151), (523, 175),
    (554, 203), (581, 235), (605, 270), (622, 307), (632, 346),
    (629, 383), (616, 418), (595, 450), (567, 476), (535, 497),
    (499, 514), (459, 529), (421, 541), (414, 552), (414, 575),
    (354, 575), (354, 552), (347, 541), (309, 529), (269, 514),
    (233, 497), (201, 476), (173, 450), (152, 418), (139, 383),
    (136, 346), (146, 307), (163, 270), (187, 235), (214, 203),
    (245, 175), (281, 151), (317, 132), (351, 118),
]


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


def keep_components(mask: np.ndarray, minimum: int) -> tuple[np.ndarray, list[int]]:
    labels, count = ndi.label(mask)
    if count == 0:
        return np.zeros_like(mask, dtype=bool), []
    sizes = ndi.sum(mask, labels, range(1, count + 1)).astype(int)
    keep = 1 + np.flatnonzero(sizes >= minimum)
    return np.isin(labels, keep), [int(size) for size in sizes if size >= minimum]


def normalize_image(path: Path) -> tuple[np.ndarray, dict]:
    """Pad two edge rows to 1200x900, then uniformly reduce 0.64 to 768x576."""
    with Image.open(path) as image:
        image = image.convert("RGB")
        if image.size != RAW_SIZE:
            raise ValueError(f"image attendue {RAW_SIZE}, reçue {image.size} pour {path}")
        source = image.size
        array = np.asarray(image, dtype=np.uint8)
        array = np.pad(array, ((2, 2), (0, 0), (0, 0)), mode="edge")
        image = Image.fromarray(array).resize((W, H), Image.Resampling.BOX)
        output = np.asarray(image, dtype=np.uint8)
    return output, {
        "source_px": list(source), "normalized_px": [1200, 900], "output_px": [W, H],
        "scale_xy": [0.64, 0.64], "method": "edge-pad 2 rows top/bottom; uniform BOX reduction; no stretch",
    }


def correct_grass(decor: np.ndarray) -> tuple[np.ndarray, dict]:
    """Gently shift clear grass toward ETC1's recorded PMD rip mean without recolouring soil or flowers."""
    a = decor.astype(np.float32)
    r, g, b = a.transpose(2, 0, 1)
    clear_grass = ((r > 150) & (g > 150) & (b < 135) & (g > r - 18) &
                   (g < r + 40) & (g - b > 50))
    if not np.any(clear_grass):
        raise AssertionError("Aucun pixel de la clairière classé comme herbe claire")
    source_mean = a[clear_grass].mean(axis=0)
    delta = (PALETTE_TARGET - source_mean) * 0.90
    a[clear_grass] = np.clip(a[clear_grass] + delta, 0, 255)
    corrected = np.rint(a).astype(np.uint8)
    corrected_mean = corrected[clear_grass].astype(np.float32).mean(axis=0)
    distance = float(np.linalg.norm(corrected_mean - PALETTE_TARGET))
    return corrected, {
        "reference_source": "ETC1 manifest measurements; raw canonical image absent from checkout",
        "target_rgb": [round(float(v), 1) for v in PALETTE_TARGET],
        "source_generated_rgb": [round(float(v), 1) for v in source_mean],
        "corrected_rgb": [round(float(v), 1) for v in corrected_mean],
        "distance_to_recorded_rip_mean": round(distance, 2),
        "threshold": 35,
        "pixels_adjusted": int(clear_grass.sum()),
        "adjustment_fraction": 0.90,
        "method": "offset per channel on clear grass only; plants, roots and dirt are not recoloured",
    }


def correct_floor_base(floor: np.ndarray) -> tuple[np.ndarray, dict]:
    a = floor.astype(np.float32)
    r, g, b = a.transpose(2, 0, 1)
    grass = ((r > 125) & (g > 145) & (b < 145) & (g - b > 45) & (np.abs(r - g) < 80))
    if not np.any(grass):
        raise AssertionError("Sol complet sans pixels d'herbe détectables")
    source_mean = a[grass].mean(axis=0)
    delta = (PALETTE_TARGET - source_mean) * 0.85
    a[grass] = np.clip(a[grass] + delta, 0, 255)
    corrected = np.rint(a).astype(np.uint8)
    result_mean = corrected[grass].astype(np.float32).mean(axis=0)
    return corrected, {
        "source_grass_rgb": [round(float(v), 1) for v in source_mean],
        "corrected_grass_rgb": [round(float(v), 1) for v in result_mean],
        "pixels_adjusted": int(grass.sum()),
        "method": "same recorded rip target, gentle shift on grass-only pixels",
    }


def rgba(rgb: np.ndarray, mask: np.ndarray) -> np.ndarray:
    out = np.zeros((H, W, 4), dtype=np.uint8)
    out[..., :3] = rgb
    out[..., 3] = np.where(mask, 255, 0).astype(np.uint8)
    out[~mask] = 0
    return out


def quantize_group(layers: dict[str, np.ndarray], colors: int):
    samples = [layer[layer[..., 3] == 255, :3] for layer in layers.values()
               if np.any(layer[..., 3] == 255)]
    all_rgb = np.concatenate(samples, axis=0)
    image_1d = Image.fromarray(all_rgb.reshape(-1, 1, 3).astype(np.uint8))
    palette_image = image_1d.quantize(colors=colors, method=Image.Quantize.MEDIANCUT,
                                      dither=Image.Dither.NONE)
    palette = np.asarray(palette_image.getpalette()[:colors * 3], dtype=np.uint8).reshape(-1, 3)
    output = {}
    for name, source in layers.items():
        result = source.copy()
        opaque = result[..., 3] == 255
        if np.any(opaque):
            indices = np.asarray(Image.fromarray(result[..., :3]).quantize(
                palette=palette_image, dither=Image.Dither.NONE), dtype=np.uint8)
            result[..., :3][opaque] = palette[indices[opaque]]
        result[result[..., 3] == 0] = 0
        output[name] = result
    return output, palette


def quantize_groups(layers: dict[str, np.ndarray]):
    group_names = {
        "terrain": ["00_sol_complet", "01_sol", "02_ombres"],
        "jungle": ["03_jungle"],
        "racines": ["05_parois"],
        "fleurs": ["04_fleurs"],
    }
    output, records = {}, {}
    for group, names in group_names.items():
        subset = {name: layers[name] for name in names}
        q, palette = quantize_group(subset, PALETTE_SIZE[group])
        output.update(q)
        records[group] = {
            "layers": names, "limit": PALETTE_SIZE[group], "colors_used": int(len(np.unique(palette, axis=0))),
            "colors": [[int(c) for c in row] for row in palette],
        }
    return output, records


def make_masks(decor: np.ndarray) -> tuple[dict[str, np.ndarray], dict]:
    if decor.shape != (H, W, 3):
        raise ValueError(f"décor attendu {(H, W, 3)}, reçu {decor.shape}")
    floor = polygon_mask(FLOOR_POLYGON)
    r, g, b = decor.astype(np.int16).transpose(2, 0, 1)
    lum = decor.astype(np.float32) @ np.array([0.299, 0.587, 0.114], dtype=np.float32)

    # Dark leafy greens come from an RGB rule and connected components; no plant positions are hand-entered.
    green_core = (g > r + 5) & (g > b + 18) & (g > 35) & (lum < 175)
    jungle, jungle_sizes = keep_components(green_core, minimum=10)

    # Saturated flower pixels, excluding the interior walkable floor; keep only connected clusters.
    saturation = decor.max(axis=2).astype(np.int16) - decor.min(axis=2).astype(np.int16)
    red = (r > 145) & (g < 105) & (b < 105) & (r > g + 45)
    pink = (r > 150) & (b > 110) & (g < 150) & (r > g + 20) & (b > g + 15)
    yellow = (r > 205) & (g > 145) & (b < 115) & (g > r - 65)
    flower_core = (red | pink | yellow) & (saturation > 65) & ~floor
    flowers, flower_sizes = keep_components(flower_core, minimum=7)
    # Petals win over adjacent leaves on shared anti-aliased edges.
    jungle &= ~flowers

    local_mean = ndi.uniform_filter(lum, size=5, mode="nearest")
    local_second = ndi.uniform_filter(lum * lum, size=5, mode="nearest")
    local_sd = np.sqrt(np.maximum(local_second - local_mean * local_mean, 0.0))
    shadows = floor & ~jungle & ~flowers & (lum < 143.0) & (local_sd > 3.2)
    grass = floor & ~jungle & ~flowers & ~shadows
    parois = ~floor & ~jungle & ~flowers
    masks = {"sol": grass, "ombres": shadows, "jungle": jungle, "fleurs": flowers, "parois": parois}
    coverage = np.stack(list(masks.values())).sum(axis=0)
    if not np.all(coverage == 1):
        raise AssertionError("Les masques FTL1 ne forment pas une partition exclusive")
    if np.any(jungle & ~((g > r + 5) & (g > b + 18) & (g > 35) & (lum < 175))):
        raise AssertionError("La végétation inclut des pixels hors du masque vert")

    components, count = ndi.label(green_core)
    sizes = ndi.sum(green_core, components, range(1, count + 1)).astype(int) if count else []
    flower_labels, flower_count = ndi.label(flower_core)
    candidate_flower_sizes = ndi.sum(flower_core, flower_labels, range(1, flower_count + 1)).astype(int) if flower_count else []
    return masks, {
        "floor_outline": "polygone intérieur relevé sur la composition 768x576; décor original conservé",
        "vegetation_detection": {
            "method": "RGB: g > r + 5, g > b + 18, g > 35, luminance < 175; composantes connexes >= 10 px",
            "manual_plant_coordinates": False,
            "candidate_components": int(count), "kept_components": len(jungle_sizes),
            "kept_component_sizes_px": jungle_sizes, "vegetation_pixels_8px": int(jungle.sum()),
        },
        "flower_detection": {
            "method": "pixels saturés rouge/rose/jaune détectés par canaux RGB, hors sol, composantes connexes >= 7 px",
            "manual_flower_coordinates": False,
            "candidate_components": int(flower_count), "kept_components": len(flower_sizes),
            "kept_component_sizes_px": flower_sizes, "candidate_sizes_px": [int(v) for v in candidate_flower_sizes],
            "flower_pixels_8px": int(flowers.sum()),
        },
        "shadows": {"method": "pixels sombres du sol (luminance < 143; écart-type local 5x5 > 3.2)",
                    "pixels_8px": int(shadows.sum())},
        "floor_pixels_8px": int(floor.sum()), "walkable_pixels_8px": int(floor.sum()),
        "wall_pixels_8px": int(parois.sum()),
    }


def cell_grid(nonwalk: np.ndarray) -> np.ndarray:
    if nonwalk.shape != (H, W):
        raise ValueError(f"masque attendu {(H, W)}, reçu {nonwalk.shape}")
    return nonwalk.reshape(GH, GRID, GW, GRID).mean(axis=(1, 3)) >= 0.25


def footprint_free(blocked: np.ndarray, y: int, x: int) -> bool:
    return (0 <= y <= GH - 2 and 0 <= x <= GW - 2 and not blocked[y:y + 2, x:x + 2].any())


def reachable_2x2(blocked: np.ndarray, start: tuple[int, int], goal: tuple[int, int]):
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
    start_candidates = [(y, x) for y in range(GH - 8, GH - 2)
                        for x in range(GW // 2 - 7, GW // 2 + 7) if footprint_free(blocked, y, x)]
    if not start_candidates:
        raise AssertionError("Arrivée sud introuvable")
    start = min(start_candidates, key=lambda p: (abs(p[0] - (GH - 4)) + abs(p[1] - (GW // 2 - 1)), p))

    objective_candidates = [(y, x) for y in range(8, GH // 3 + 1)
                            for x in range(GW // 2 - 9, GW // 2 + 9) if footprint_free(blocked, y, x)]
    if not objective_candidates:
        raise AssertionError("Objectif nord introuvable")
    objective = min(objective_candidates, key=lambda p: (p[0], abs(p[1] - (GW // 2 - 1)), p[1]))

    yy, xx = np.nonzero(walkable)
    center = (float(yy.mean()) / GRID, float(xx.mean()) / GRID)
    boss_candidates = [(y, x) for y in range(GH // 4, 3 * GH // 4)
                       for x in range(GW // 2 - 18, GW // 2 + 18) if footprint_free(blocked, y, x)]
    if not boss_candidates:
        raise AssertionError("Arène centrale introuvable")
    boss = min(boss_candidates, key=lambda p: ((p[0] + .5 - center[0]) ** 2 +
                                                (p[1] + .5 - center[1]) ** 2, p))
    reach_boss, exp_boss, path_boss = reachable_2x2(blocked, start, boss)
    reach_obj, exp_obj, path_obj = reachable_2x2(blocked, start, objective)
    if not reach_boss or not reach_obj:
        raise AssertionError("Pas de chemin 16x16 de l'entrée aux deux repères")
    return {
        "entry_cell_yx": list(start), "boss_cell_yx": list(boss), "objective_cell_yx": list(objective),
        "entry_px": [start[1] * GRID, start[0] * GRID],
        "boss_px": [boss[1] * GRID, boss[0] * GRID],
        "objective_px": [objective[1] * GRID, objective[0] * GRID],
        "path_to_boss_16x16": True, "path_to_objective_16x16": True,
        "path_boss_cells": len(path_boss), "path_objective_cells": len(path_obj),
        "cells_explored_to_boss": exp_boss, "cells_explored_to_objective": exp_obj,
        "blocked_cells": int(blocked.sum()), "walkable_cells": int((~blocked).sum()),
        "rule": "case bloquée si au moins 25% des pixels hors du masque de clairière; footprint 16x16 px",
        "boss_rule": "case 2x2 libre proche du centroïde de la clairière",
        "objective_rule": "case 2x2 libre la plus au nord dans une bande centrale de 144 px",
        "exit_and_warp": "aucun",
    }


def composite(layers: list[np.ndarray]) -> Image.Image:
    result = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    for layer in layers:
        result.alpha_composite(Image.fromarray(layer, "RGBA"))
    return result


def save_png(path: Path, image: np.ndarray) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(image).save(path, optimize=True)


def write_ora(path: Path, layers: list[tuple[str, np.ndarray]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    root = ET.Element("image", w=str(W), h=str(H), name="FTL1 — Fin Clairière tropicale")
    xml_stack = ET.SubElement(root, "stack")
    merged = composite([array for _, array in layers])
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        archive.writestr("mimetype", "image/openraster", compress_type=zipfile.ZIP_STORED)
        for index, (name, array) in reversed(list(enumerate(layers))):
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
    gfx = load_module("pmdo_codec_ftl1", ROOT / "source/pmdo_cote/build.py")
    index_tools = load_module("pmdo_index_tools_ftl1", ROOT / "source/pmdo_cote/INSTALLER.py")
    template_path = ROOT / "cliffdaytest.rsground"
    if not template_path.is_file():
        raise FileNotFoundError(f"Template Ground PMDO attendu: {template_path}")
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
        "Name": {"DefaultText": "Fin Clairière tropicale — arène", "LocalTexts": {}},
        "AssetName": ASSET, "Released": False,
        "Comment": ("PMDO 0.8.12. Carte de travail 4:3 dans une clairière de jungle : arrivée sud, arène centrale, "
                    "alcôve sous l'arbre au nord. Sol naturel sans dalles ni cristaux. Image générée et référencée aux "
                    "notes ETC1, pas une texture native certifiée; aucun warp ni sortie."),
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
  <Name>Fin Clairiere Tropicale FTL1 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Clairière finale d'une jungle tropicale, arrivée au sud et objectif au nord. Projet de carte, sans warp.</Description>
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
    decor_raw, decor_norm = normalize_image(decor_path)
    floor_raw, floor_norm = normalize_image(floor_path)
    floor_mask = polygon_mask(FLOOR_POLYGON)
    decor, grass_fidelity = correct_grass(decor_raw)
    full_floor, base_correction = correct_floor_base(floor_raw)
    masks, segmentation = make_masks(decor)
    walkable = floor_mask.copy()
    blocked = cell_grid(~walkable)
    access = choose_markers(blocked, walkable)

    raw_layers = {
        "00_sol_complet": rgba(full_floor, np.ones((H, W), dtype=bool)),
        "01_sol": rgba(decor, masks["sol"]),
        "02_ombres": rgba(decor, masks["ombres"]),
        "03_jungle": rgba(decor, masks["jungle"]),
        "04_fleurs": rgba(decor, masks["fleurs"]),
        "05_parois": rgba(decor, masks["parois"]),
    }
    layers, palette_groups = quantize_groups(raw_layers)
    top = np.zeros((H, W, 4), dtype=np.uint8)

    OUT.mkdir(parents=True, exist_ok=True)
    for folder in ("calques", "masques", "review"):
        shutil.rmtree(OUT / folder, ignore_errors=True)
    for folder in ("calques", "masques", "review"):
        (OUT / folder).mkdir(parents=True, exist_ok=True)
    for name, image in layers.items():
        save_png(OUT / "calques" / f"{PFX}_{name}.png", image)
    save_png(OUT / "calques" / f"{PFX}_06_top.png", top)
    for name, mask in masks.items():
        save_png(OUT / "masques" / f"{PFX}_masque_{name}.png", mask.astype(np.uint8) * 255)
    save_png(OUT / "masques" / f"{PFX}_masque_praticable.png", walkable.astype(np.uint8) * 255)
    save_png(OUT / "masques" / f"{PFX}_masque_bloque_8px.png", blocked.astype(np.uint8) * 255)

    scene = composite([*layers.values(), top])
    scene_array = np.asarray(scene, dtype=np.uint8)
    if not np.all(scene_array[..., 3] == 255):
        raise AssertionError("La composition a des pixels transparents")
    save_png(OUT / "review" / f"{PFX}_scene_t000.png", scene_array)
    save_png(OUT / "review" / f"{PFX}_scene_x2.png",
             np.asarray(scene.resize((W * 2, H * 2), Image.Resampling.NEAREST), dtype=np.uint8))
    collision_view = scene.copy()
    overlay = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    for y, x in zip(*np.nonzero(blocked)):
        draw.rectangle((x * GRID, y * GRID, x * GRID + 7, y * GRID + 7), fill=(225, 40, 45, 92))
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
    manifest = {
        "lot": "fin_clairiere_tropicale_v1", "title": "Fin Clairière tropicale — arène naturelle",
        "prefix": PFX, "namespace": NAMESPACE, "asset": ASSET,
        "type": "fin de donjon", "format": "4:3 vaste", "size_px": [W, H],
        "grid_px": GRID, "grid_cells": [GW, GH],
        "user_request": "passer à la map suivante de la série",
        "agent_choices": {"map": "Fin Clairière tropicale (file locale après FST1)",
                           "prefix": PFX, "arena_layout": "arrivée sud, boss au centre, objectif à l'arbre au nord"},
        "generation": generation,
        "inputs": [
            {"file": "source/fin_clairiere_tropicale_v1/bruts/decor.png",
             "sha256": sha256(decor_path), "size_px": list(Image.open(decor_path).size)},
            {"file": "source/fin_clairiere_tropicale_v1/bruts/sol_complet.png",
             "sha256": sha256(floor_path), "size_px": list(Image.open(floor_path).size)},
        ],
        "normalization": {"decor": decor_norm, "sol_complet": floor_norm,
                          "grass_fidelity_estimate": grass_fidelity,
                          "sol_complet_color_correction": base_correction,
                          "palette_groups": palette_groups, "dither": False},
        "segmentation": segmentation,
        "layers": [
            {"name": name, "file": f"calques/{PFX}_{name}.png", "phases": 1,
             "frame_length_ticks": 60, "order": index}
            for index, name in enumerate(layers)
        ] + [{"name": "06_top", "file": f"calques/{PFX}_06_top.png", "phases": 1,
              "frame_length_ticks": 60, "order": 6, "ground_layer": 4}],
        "access": access,
        "pmdo": {"target": "0.8.12.0", "version": "0.8.12.0", "tile_banks": tile_counts,
                 "runtime_tested": False, "markers": ["entrance", "boss", "objectif"],
                 "warp": "aucun", "exit": "aucune"},
        "art_approved": False, "runtime_tested": False,
        "notes": [
            "Le choix de la Clairière tropicale suit REPRISE_MAPS.md; l'utilisateur a demandé la map suivante sans imposer ce biome.",
            "Le fichier canonique cité par ETC1 et ses bruts ne sont pas disponibles; seul son README, son builder et son manifeste ont servi de guide.",
            "Le centre d'arène est laissé vide et le sol est naturel, sans cristaux, dalles, tuiles ni carrelage.",
            "La végétation et les fleurs sont détectées par couleur et composantes connexes, sans coordonnées de plante saisies à la main.",
            "Les marqueurs d'édition ne créent ni personnages, ni objets, ni événement, ni sortie, ni warp.",
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
        "jungle_components": segmentation["vegetation_detection"]["kept_components"],
        "flower_components": segmentation["flower_detection"]["kept_components"],
        "grass_distance": grass_fidelity["distance_to_recorded_rip_mean"],
        "tiles": sum(tile_counts.values()), "stage": str(STAGE.relative_to(ROOT)),
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return manifest


if __name__ == "__main__":
    build()
