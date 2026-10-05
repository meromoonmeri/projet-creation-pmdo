#!/usr/bin/env python3
"""Build FCC1, zone de fin de la caverne cuivrée, pour PMDO 0.8.12.

La composition retenue par l'utilisateur reste une image-guide : normalisation 4:3,
calques RGBA, masque de marche, ORA et Ground PMDO éditable. Aucun cristal, dallage,
warp ni sortie n'est ajouté par ce builder. Lancer depuis la racine avec .venv/bin/python.
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
OUT = ROOT / "renders/fin_canyon_cuivre_v1"
STAGE = ROOT / ".cache/fin_canyon_cuivre_v1/fin_canyon_cuivre"
ORA = ROOT / ".cache/fin_canyon_cuivre_v1/FCC1_calques.ora"
PFX = "FCC1"
NAMESPACE = "fin_canyon_cuivre"
ASSET = "fcc1_fin_canyon_cuivre"
W, H = 768, 576
GRID = 8
GW, GH = W // GRID, H // GRID
RAW_DECOR_SIZE = (1184, 864)
RAW_FLOOR_SIZE = (1200, 896)
PALETTE_SIZE = 96

# Silhouette intérieure du sol libre, relevée sur la composition validée puis réduite.
# Le léger retrait garde les petits galets et le pied des parois hors de la grille marchable.
FLOOR_POLYGON = [
    (384, 106), (416, 113), (448, 130), (479, 151), (507, 176),
    (531, 202), (550, 231), (566, 263), (578, 297), (583, 333),
    (579, 367), (570, 398), (555, 427), (537, 451), (515, 472),
    (490, 490), (463, 505), (438, 519), (425, 538), (427, 575),
    (341, 575), (343, 538), (330, 519), (305, 505), (278, 490),
    (253, 472), (231, 451), (213, 427), (198, 398), (189, 367),
    (185, 333), (190, 297), (202, 263), (218, 231), (237, 202),
    (261, 176), (289, 151), (320, 130), (352, 113),
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
    return np.isin(labels, keep), [int(s) for s in sizes if s >= minimum]


def normalize_decor(path: Path) -> tuple[np.ndarray, dict]:
    """Centre-crop 16 px from each side, then reduce uniformly by 2/3 (BOX)."""
    with Image.open(path) as image:
        image = image.convert("RGB")
        if image.size != RAW_DECOR_SIZE:
            raise ValueError(f"decor attendu {RAW_DECOR_SIZE}, reçu {image.size}")
        image = image.crop((16, 0, 1168, 864))
        image = image.resize((W, H), Image.Resampling.BOX)
        array = np.asarray(image, dtype=np.uint8)
    return array, {
        "source_px": list(RAW_DECOR_SIZE),
        "crop_px_ltrb": [16, 0, 16, 0],
        "cropped_px": [1152, 864],
        "output_px": [W, H],
        "scale_xy": [2 / 3, 2 / 3],
        "method": "crop central 4:3, then uniform BOX reduction; no stretching",
    }


def normalize_floor(path: Path) -> tuple[np.ndarray, dict]:
    """Reuse the matched copper floor from EOC1; edge-pad 2 rows before 0.64 reduction."""
    with Image.open(path) as image:
        image = image.convert("RGB")
        source_size = image.size
        if source_size == RAW_FLOOR_SIZE:
            array = np.asarray(image, dtype=np.uint8)
            array = np.pad(array, ((2, 2), (0, 0), (0, 0)), mode="edge")
            image = Image.fromarray(array)
        elif source_size != (1200, 900):
            raise ValueError(f"sol complet réutilisé attendu 1200x896 ou 1200x900, reçu {source_size}")
        image = image.resize((W, H), Image.Resampling.BOX)
        floor = np.asarray(image, dtype=np.uint8)
    return floor, {
        "source_px": list(source_size), "normalized_px": [1200, 900],
        "scale_xy": [0.64, 0.64],
        "method": "edge-pad 2 px top/bottom then uniform BOX reduction",
        "provenance": "copie sans retouche du sol complet de l'entrée EOC1, même palette de caverne cuivrée",
    }


def rgba(rgb: np.ndarray, mask: np.ndarray) -> np.ndarray:
    out = np.zeros((H, W, 4), dtype=np.uint8)
    out[..., :3] = rgb
    out[..., 3] = np.where(mask, 255, 0).astype(np.uint8)
    out[~mask] = 0
    return out


def quantize_layers(layers: dict[str, np.ndarray], colors: int = PALETTE_SIZE):
    """A shared, non-dithered palette; fully transparent pixels remain transparent."""
    samples = [arr[arr[..., 3] == 255, :3] for arr in layers.values()
               if np.any(arr[..., 3] == 255)]
    if not samples:
        raise ValueError("Aucun pixel opaque à quantifier")
    all_rgb = np.concatenate(samples, axis=0)
    image_1d = Image.fromarray(all_rgb.reshape(-1, 1, 3).astype(np.uint8))
    palette_image = image_1d.quantize(colors=colors, method=Image.Quantize.MEDIANCUT,
                                      dither=Image.Dither.NONE)
    palette = np.asarray(palette_image.getpalette()[:colors * 3], dtype=np.uint8).reshape(-1, 3)
    out = {}
    for name, source in layers.items():
        result = source.copy()
        opaque = result[..., 3] == 255
        if np.any(opaque):
            indices = np.asarray(Image.fromarray(result[..., :3]).quantize(
                palette=palette_image, dither=Image.Dither.NONE), dtype=np.uint8)
            result[..., :3][opaque] = palette[indices[opaque]]
        result[result[..., 3] == 0] = 0
        out[name] = result
    return out, palette


def make_masks(decor: np.ndarray) -> tuple[dict[str, np.ndarray], dict]:
    """Separate the naturally coloured floor, cave walls, shadows and green plant.

    The floor outline follows the visible interior silhouette. Plant coordinates are not
    listed: green pixels are found from RGB relationships, then filtered by connected area.
    """
    if decor.shape != (H, W, 3):
        raise ValueError(f"décor attendu {(H, W, 3)}, reçu {decor.shape}")
    floor = polygon_mask(FLOOR_POLYGON)
    r, g, b = decor.astype(np.int16).transpose(2, 0, 1)
    green_core = (g > r + 5) & (g > b + 5) & (g > 42)
    vegetation, vegetation_sizes = keep_components(green_core, minimum=5)

    luminance = decor.astype(np.float32) @ np.array([0.299, 0.587, 0.114], dtype=np.float32)
    local_mean = ndi.uniform_filter(luminance, size=5, mode="nearest")
    local_second = ndi.uniform_filter(luminance * luminance, size=5, mode="nearest")
    local_sd = np.sqrt(np.maximum(local_second - local_mean * local_mean, 0.0))
    shadows = floor & ~vegetation & (luminance < 154.0) & (local_sd > 3.0)

    # The four masks form a complete, exclusive partition; the image itself is never repainted.
    sol = floor & ~vegetation & ~shadows
    parois = ~floor & ~vegetation
    masks = {"sol": sol, "ombres": shadows, "parois": parois, "vegetation": vegetation}
    coverage = np.stack(list(masks.values())).sum(axis=0)
    if not np.all(coverage == 1):
        raise AssertionError("Les masques statiques ne partitionnent pas chaque pixel une seule fois")
    if np.any(vegetation & ~((g > r + 5) & (g > b + 5) & (g > 42))):
        raise AssertionError("La végétation contient un pixel qui ne provient pas du masque RGB vert")

    labels, component_count = ndi.label(green_core)
    detected_sizes = ndi.sum(green_core, labels, range(1, component_count + 1)).astype(int) if component_count else []
    kept_component_count = len(vegetation_sizes)
    return masks, {
        "floor_outline": "polygone intérieur relevé sur l'arène à l'échelle 768x576; aucun pixel source n'est repeint",
        "vegetation_detection": {
            "method": "masque RGB g > r + 5, g > b + 5, g > 42; composantes connexes >= 5 px",
            "manual_plant_coordinates": False,
            "green_candidate_pixels": int(green_core.sum()),
            "candidate_components": int(component_count),
            "kept_components": kept_component_count,
            "kept_component_sizes_px": vegetation_sizes,
            "vegetation_pixels_8px": int(vegetation.sum()),
        },
        "shadows": {
            "method": "pixels du sol source avec luminance < 154 et écart-type local 5x5 > 3; purement décoratif",
            "pixels_8px": int(shadows.sum()),
        },
        "floor_pixels_8px": int(floor.sum()),
        "walkable_pixels_8px": int((floor & ~vegetation).sum()),
        "wall_pixels_8px": int(parois.sum()),
        "input_green_component_sizes_px": [int(v) for v in detected_sizes],
    }


def cell_grid(nonwalk: np.ndarray) -> np.ndarray:
    if nonwalk.shape != (H, W):
        raise ValueError(f"masque attendu {(H, W)}, reçu {nonwalk.shape}")
    fraction = nonwalk.reshape(GH, GRID, GW, GRID).mean(axis=(1, 3))
    return fraction >= 0.25


def footprint_free(blocked: np.ndarray, y: int, x: int) -> bool:
    return (0 <= y <= GH - 2 and 0 <= x <= GW - 2 and not blocked[y:y + 2, x:x + 2].any())


def reachable_2x2(blocked: np.ndarray, start: tuple[int, int], goal: tuple[int, int]):
    """BFS for a 16x16 px footprint on the 8 px obstacle grid."""
    if not footprint_free(blocked, *start) or not footprint_free(blocked, *goal):
        return False, 0, []
    seen = np.zeros((GH, GW), dtype=bool)
    previous = {}
    queue = [start]
    seen[start] = True
    for cell in queue:
        if cell == goal:
            path = [cell]
            while path[-1] != start:
                path.append(previous[path[-1]])
            path.reverse()
            return True, int(seen.sum()), path
        y, x = cell
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nxt = (y + dy, x + dx)
            ny, nx = nxt
            if 0 <= ny < GH and 0 <= nx < GW and not seen[nxt] and footprint_free(blocked, ny, nx):
                seen[nxt] = True
                previous[nxt] = cell
                queue.append(nxt)
    return False, int(seen.sum()), []


def choose_markers(blocked: np.ndarray, walkable: np.ndarray) -> dict:
    starts = [(y, x) for y in range(GH - 8, GH - 2) for x in range(GW // 2 - 7, GW // 2 + 7)
              if footprint_free(blocked, y, x)]
    if not starts:
        raise AssertionError("Arrivée sud introuvable")
    start = min(starts, key=lambda p: (abs(p[0] - (GH - 4)) + abs(p[1] - (GW // 2 - 1)), p))

    objectives = [(y, x) for y in range(8, GH // 3 + 1)
                  for x in range(GW // 2 - 9, GW // 2 + 9) if footprint_free(blocked, y, x)]
    if not objectives:
        raise AssertionError("Objectif nord introuvable dans la bande centrale")
    objective = min(objectives, key=lambda p: (p[0], abs(p[1] - (GW // 2 - 1)), p[1]))

    yy, xx = np.nonzero(walkable)
    center = (float(yy.mean()) / GRID, float(xx.mean()) / GRID)
    bosses = [(y, x) for y in range(GH // 4, 3 * GH // 4)
              for x in range(GW // 2 - 18, GW // 2 + 18) if footprint_free(blocked, y, x)]
    if not bosses:
        raise AssertionError("Case boss centrale introuvable")
    boss = min(bosses, key=lambda p: ((p[0] + 0.5 - center[0]) ** 2 + (p[1] + 0.5 - center[1]) ** 2, p))

    reach_boss, explored_boss, path_boss = reachable_2x2(blocked, start, boss)
    reach_objective, explored_objective, path_objective = reachable_2x2(blocked, start, objective)
    if not reach_boss or not reach_objective:
        raise AssertionError("Pas de chemin 16x16 sud → boss et objectif nord")
    return {
        "entry_cell_yx": list(start), "boss_cell_yx": list(boss), "objective_cell_yx": list(objective),
        "entry_px": [start[1] * GRID, start[0] * GRID],
        "boss_px": [boss[1] * GRID, boss[0] * GRID],
        "objective_px": [objective[1] * GRID, objective[0] * GRID],
        "path_to_boss_16x16": True, "path_to_objective_16x16": True,
        "path_boss_cells": len(path_boss), "path_objective_cells": len(path_objective),
        "cells_explored_to_boss": explored_boss, "cells_explored_to_objective": explored_objective,
        "blocked_cells": int(blocked.sum()), "walkable_cells": int((~blocked).sum()),
        "rule": "case bloquée si au moins 25 % de ses pixels sont hors sol; collisionneur joueur 16x16 px",
        "boss_rule": "case 2x2 libre la plus proche du centroïde du sol dans la zone centrale",
        "objective_rule": "case 2x2 libre la plus au nord dans une bande centrale de 144 px",
        "exit_and_warp": "aucun",
    }


def quantized_rgba(rgb: np.ndarray, mask: np.ndarray) -> np.ndarray:
    return rgba(rgb, mask)


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
    root = ET.Element("image", w=str(W), h=str(H), name="FCC1 — Fin de la caverne cuivrée")
    stack = ET.SubElement(root, "stack")
    merged = composite([arr for _, arr in named_layers])
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        archive.writestr("mimetype", "image/openraster", compress_type=zipfile.ZIP_STORED)
        for index, (name, array) in reversed(list(enumerate(named_layers))):
            filename = f"data/layer{index:02d}.png"
            ET.SubElement(stack, "layer", name=name, src=filename, x="0", y="0", opacity="1.0",
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
    gfx = load_module("pmdo_codec_fcc1", ROOT / "source/pmdo_cote/build.py")
    index_tools = load_module("pmdo_index_tools_fcc1", ROOT / "source/pmdo_cote/INSTALLER.py")
    template_path = ROOT / "cliffdaytest.rsground"
    if not template_path.exists():
        raise FileNotFoundError(f"Template Ground PMDO attendu: {template_path}")
    template = json.loads(template_path.read_text(encoding="utf-8-sig"))
    if STAGE.exists():
        shutil.rmtree(STAGE)
    (STAGE / "Content/Tile").mkdir(parents=True)
    (STAGE / f"Data/Script/{NAMESPACE}/ground/{ASSET}").mkdir(parents=True)
    (STAGE / "Data/Ground").mkdir(parents=True)

    layers, banks = [], []
    for index, (title, image) in enumerate(stack):
        bank = gfx.TileBank(f"{PFX}_{index:02d}_{title.split()[0].upper()}")
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)

        def cells(x, y, bank=bank, image=image):
            tile_image = Image.fromarray(image[y * GRID:(y + 1) * GRID, x * GRID:(x + 1) * GRID], "RGBA")
            tile = bank.add(tile_image, x, y)
            return [tile] if tile else []

        layers.append(gfx.layer(f"{index:02d} {title}", GW, GH, cells))
        banks.append(bank)
    layers.append(gfx.layer(f"{len(layers):02d} Top (vide)", GW, GH, draw=4))
    for bank in banks:
        bank.write(STAGE / f"Content/Tile/{bank.name}.tile")

    obj = template["Object"]
    obj.update({
        "TexSize": 1,
        "Name": {"DefaultText": "Fin Canyon Cuivré — arène de la caverne", "LocalTexts": {}},
        "AssetName": ASSET,
        "Released": False,
        "Comment": ("PMDO 0.8.12. Carte de travail 4:3, composition générée choisie après correction : "
                    "sol naturel, sans cristal ni dalles. Arrivée sud, arène centrale, objectif au nord. "
                    "Marqueurs d'édition seulement, sans sortie ni warp; validation PMDO en jeu à faire."),
        "Music": "",
        "EdgeView": 1,
        "ViewCenter": None,
        "ViewOffset": {"X": 0, "Y": 0},
        "ActiveChar": None,
        "Status": {},
        "Background": {"$type": "RogueEssence.Dungeon.LayeredBG, RogueEssence", "Layers": []},
        "Layers": layers,
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
        "Markers": [marker("entrance", access["entry_px"]),
                    marker("boss", access["boss_px"]),
                    marker("objectif", access["objective_px"])],
    }]
    template["Version"] = "0.8.12.0"
    ground_path = STAGE / f"Data/Ground/{ASSET}.rsground"
    gfx.save(ground_path, json.dumps(template, ensure_ascii=False, separators=(",", ":")).encode("utf-8"))
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
  <Name>Fin Canyon Cuivre FCC1 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Zone de fin de caverne en arène cuivrée, arrivée au sud et objectif au nord. Projet de carte, sans warp.</Description>
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
        needle,
        needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n"
                "                continue\n",
        1,
    )
    (STAGE / "INSTALLER.py").write_text(installer_source, encoding="utf-8")
    shutil.copyfile(HERE / "README_PACK.md", STAGE / "README.md")
    return {bank.name: len(bank.data) for bank in banks}


def build() -> dict:
    decor_path = RAW / "decor.png"
    floor_path = RAW / "sol_complet_reutilise.png"
    if not decor_path.is_file() or not floor_path.is_file():
        raise FileNotFoundError("Bruts requis: decor.png et sol_complet_reutilise.png")

    decor, decor_normalization = normalize_decor(decor_path)
    full_floor, floor_normalization = normalize_floor(floor_path)
    masks, segmentation = make_masks(decor)
    walkable = polygon_mask(FLOOR_POLYGON) & ~masks["vegetation"]
    blocked = cell_grid(~walkable)
    access = choose_markers(blocked, walkable)

    raw_layers = {
        "00_sol_complet": rgba(full_floor, np.ones((H, W), dtype=bool)),
        "01_sol": rgba(decor, masks["sol"]),
        "02_ombres": rgba(decor, masks["ombres"]),
        "03_parois": rgba(decor, masks["parois"]),
        "04_vegetation": rgba(decor, masks["vegetation"]),
    }
    layers, palette = quantize_layers(raw_layers, PALETTE_SIZE)
    top = np.zeros((H, W, 4), dtype=np.uint8)

    # Only clean the known generated subfolders, never delete unrelated output files.
    OUT.mkdir(parents=True, exist_ok=True)
    for folder in ("calques", "masques", "review"):
        shutil.rmtree(OUT / folder, ignore_errors=True)
    for folder in ("calques", "masques", "review"):
        (OUT / folder).mkdir(parents=True, exist_ok=True)

    for name, image in layers.items():
        save_png(OUT / "calques" / f"{PFX}_{name}.png", image)
    save_png(OUT / "calques" / f"{PFX}_05_top.png", top)
    for name, mask in masks.items():
        save_png(OUT / "masques" / f"{PFX}_masque_{name}.png", mask.astype(np.uint8) * 255)
    save_png(OUT / "masques" / f"{PFX}_masque_praticable.png", walkable.astype(np.uint8) * 255)
    save_png(OUT / "masques" / f"{PFX}_masque_bloque_8px.png", blocked.astype(np.uint8) * 255)

    ordered = [layers[name] for name in raw_layers] + [top]
    scene = composite(ordered)
    scene_array = np.asarray(scene, dtype=np.uint8)
    if not np.all(scene_array[..., 3] == 255):
        raise AssertionError("La scène n'est pas opaque : trou entre les calques")
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
    ora_layers.append(("05 Top vide", top))
    write_ora(ORA, ora_layers)
    tile_counts = ground_project(list(zip(layers.keys(), layers.values())), blocked, access)

    generation = json.loads((HERE / "generation.json").read_text(encoding="utf-8"))
    manifest = {
        "lot": "fin_canyon_cuivre_v1",
        "title": "Fin Canyon Cuivré — arène au fond de la caverne",
        "prefix": PFX,
        "namespace": NAMESPACE,
        "asset": ASSET,
        "format": "4:3 vaste",
        "size_px": [W, H],
        "grid_px": GRID,
        "grid_cells": [GW, GH],
        "user_constraints": {
            "arena_without_crystal": True,
            "natural_floor_without_tiles_or_slabs": True,
            "keep_copper_cave_theme": True,
            "source": "correction explicite de l'utilisateur; composition sans cristal ni dalles choisie par l'utilisateur",
        },
        "generation": generation,
        "inputs": [
            {"file": "source/fin_canyon_cuivre_v1/bruts/decor.png",
             "sha256": sha256(decor_path), "size_px": list(Image.open(decor_path).size)},
            {"file": "source/fin_canyon_cuivre_v1/bruts/sol_complet_reutilise.png",
             "sha256": sha256(floor_path), "size_px": list(Image.open(floor_path).size),
             "original_source": "source/entree_canyon_cuivre_sud_nord_v1/bruts/sol_complet.png"},
        ],
        "normalization": {"decor": decor_normalization, "sol_complet": floor_normalization,
                          "shared_palette_colors": int(len(palette)), "dither": False},
        "segmentation": segmentation,
        "layers": [
            {"name": name, "file": f"calques/{PFX}_{name}.png", "phases": 1,
             "frame_length_ticks": 60, "order": i}
            for i, name in enumerate(layers)
        ] + [{"name": "05_top", "file": f"calques/{PFX}_05_top.png", "phases": 1,
              "frame_length_ticks": 60, "order": 5, "ground_layer": 4}],
        "access": access,
        "pmdo": {"target": "0.8.12.0", "version": "0.8.12.0", "tile_banks": tile_counts,
                 "runtime_tested": False, "markers": ["entrance", "boss", "objectif"],
                 "warp": "aucun", "exit": "aucune"},
        "art_approved": False,
        "runtime_tested": False,
        "notes": [
            "Le biome/cadrage Canyon Cuivré est un choix de travail, pas un nom canonique demandé par l'utilisateur.",
            "La composition sélectionnée est une image-guide générée, convertie en calques et non en tuiles canoniques certifiées.",
            "Le calque sol_complet est réutilisé sans retouche depuis l'entrée EOC1; il sert de base sous la partition opaque.",
            "Aucun objet cristal, dallage, sortie ou warp n'est créé.",
            "Les repères boss et objectif n'ajoutent aucun personnage ni événement.",
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
        "vegetation_components": segmentation["vegetation_detection"]["kept_components"],
        "plant_pixels": segmentation["vegetation_detection"]["vegetation_pixels_8px"],
        "tiles": sum(tile_counts.values()), "stage": str(STAGE.relative_to(ROOT)),
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return manifest


if __name__ == "__main__":
    build()
