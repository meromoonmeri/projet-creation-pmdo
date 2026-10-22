from __future__ import annotations

import copy
import gzip
import hashlib
import io
import json
import math
import random
import re
import shutil
import sqlite3
import struct
import zipfile
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

from PIL import Image

from pmu_extraction.constants import TILE_TYPES
from pmu_extraction.sql_dump import parse_insert_rows
from pmu_extraction.tilesets import TileArchive
from pmdo_ground.assets import _tile_entries
from pmdo_ground.ground_gen import (
    _aligned_layers, _classes, _empty_cell, _has_visual, _layer_role,
    _mask, _pick_source, _transition_signature, build_cell_grammar,
)
from pmdo_ground.ground_library import _visual_profile, visual_distance
from pmdo_ground.knowledge import analyze_references

DEFINITE_BLOCK = {1, 14, 31}
CONDITIONAL_BLOCK = {10, 24, 25}
SOURCE_LAYERS = (
    ("Ground", "ground", "ground_anim"),
    ("Mask", "mask", "mask_anim"),
    ("Mask2", "mask2", "mask2_anim"),
    ("Fringe", "fringe", "fringe_anim"),
    ("Fringe2", "fringe2", "fringe2_anim"),
)
ROLE_FOR_TARGET = {
    "Ground": ("base", "water", "structure", "shadow"),
    "Mask": ("lower_decoration",),
    "Mask2": ("middle_decoration",),
    "Fringe": ("upper_decoration",),
    "Fringe2": ("top_decoration",),
}
CARDINAL_DIRS = {"up": 4, "down": 0, "left": 2, "right": 6}
_KNOWLEDGE_CACHE: dict[str, Any] | None = None
_PROFILE_CACHE: dict[str, dict[str, Any]] = {}
_ROLE_CELL_CACHE: dict[tuple[int, int, int, str], dict[str, Any]] = {}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_json(path: Path, value: Any, pretty: bool = True) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(value, ensure_ascii=False, sort_keys=True, indent=2 if pretty else None, separators=None if pretty else (",", ":")) + "\n",
        encoding="utf-8", newline="\n",
    )


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_ir(path: Path) -> dict[str, Any]:
    with gzip.open(path, "rt", encoding="utf-8") as stream:
        return json.load(stream)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def _premultiply(image: Image.Image) -> Image.Image:
    image = image.convert("RGBA")
    pixels = bytearray(image.tobytes())
    for offset in range(0, len(pixels), 4):
        alpha = pixels[offset + 3]
        for channel in range(3):
            pixels[offset + channel] = (pixels[offset + channel] * alpha + 127) // 255
    return Image.frombytes("RGBA", image.size, bytes(pixels))


def _unpremultiply(image: Image.Image) -> Image.Image:
    image = image.convert("RGBA")
    pixels = bytearray(image.tobytes())
    for offset in range(0, len(pixels), 4):
        alpha = pixels[offset + 3]
        if alpha:
            for channel in range(3):
                pixels[offset + channel] = min(255, (pixels[offset + channel] * 255 + alpha // 2) // alpha)
    return Image.frombytes("RGBA", image.size, bytes(pixels))


def _png_bytes(image: Image.Image, premultiply: bool = True) -> bytes:
    output = io.BytesIO()
    (_premultiply(image) if premultiply else image.convert("RGBA")).save(output, format="PNG", optimize=False, compress_level=9)
    return output.getvalue()


def write_tile(path: Path, tile_size: int, entries: list[tuple[int, bytes]]) -> None:
    require(len({key for key, _ in entries}) == len(entries), "duplicate PMDO atlas key")
    payload_offsets: dict[bytes, int] = {}
    payloads: list[bytes] = []
    offset = 8 + len(entries) * 16
    for _, payload in entries:
        if payload not in payload_offsets:
            payload_offsets[payload] = offset
            payloads.append(payload)
            offset += 8 + len(payload)
    result = bytearray(struct.pack("<II", tile_size, len(entries)))
    for key, payload in entries:
        result.extend(struct.pack("<QQ", key, payload_offsets[payload]))
    for payload in payloads:
        result.extend(struct.pack("<Q", len(payload)))
        result.extend(payload)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(result)


class NativeTileReader:
    def __init__(self, repo: Path):
        self.repo = repo
        self.sheets: dict[str, tuple[int, dict[int, bytes]]] = {}
        self.images: dict[tuple[str, int, int], Image.Image] = {}
        self.cell_images: dict[tuple[str, int], Image.Image] = {}

    def image(self, sheet: str, x: int, y: int) -> Image.Image:
        key = (sheet, x, y)
        if key in self.images:
            return self.images[key]
        if sheet not in self.sheets:
            path = self.repo / "Content/Tile" / f"{sheet}.tile"
            require(path.is_file(), f"missing native PMDO sheet {sheet}")
            size, entries = _tile_entries(path)
            self.sheets[sheet] = (size, dict(entries))
        size, entries = self.sheets[sheet]
        payload = entries.get((y << 32) | (x & 0xFFFFFFFF))
        require(payload is not None, f"missing native PMDO cell {sheet}:{x},{y}")
        with Image.open(io.BytesIO(payload)) as image:
            decoded = _unpremultiply(image)
            decoded.load()
        require(decoded.size == (size, size), f"native PMDO cell size mismatch {sheet}:{x},{y}")
        self.images[key] = decoded
        return decoded


def _cell_image(cell: dict[str, Any], tick: int, reader: NativeTileReader) -> Image.Image:
    cache_key = (str(id(cell)), tick)
    if cache_key in reader.cell_images:
        return reader.cell_images[cache_key]
    result = Image.new("RGBA", (8, 8), (0, 0, 0, 0))
    for tile_layer in cell.get("Layers", []):
        frames = [frame for frame in tile_layer.get("Frames", []) if frame.get("Sheet")]
        if not frames:
            continue
        frame_length = max(1, int(tile_layer.get("FrameLength", 1)))
        frame = frames[(tick // frame_length) % len(frames)]
        image = reader.image(frame["Sheet"], int(frame["TexLoc"]["X"]), int(frame["TexLoc"]["Y"]))
        result.alpha_composite(image)
    reader.cell_images[cache_key] = result
    return result


def _merge_cells(cells: list[dict[str, Any]]) -> dict[str, Any]:
    layers = []
    associates = []
    autotile = ""
    for cell in cells:
        if cell.get("AutoTileset") and not autotile:
            autotile = cell["AutoTileset"]
        associates.extend(copy.deepcopy(cell.get("Associates", [])))
        layers.extend(copy.deepcopy(cell.get("Layers", [])))
    return {"AutoTileset": autotile, "Associates": associates, "Layers": layers, "NeighborCode": -1}


def _target_reference_layers(obj: dict[str, Any]) -> dict[str, list[dict[str, Any]]]:
    aligned = _aligned_layers(obj)
    bases = [layer for layer in aligned if _layer_role(layer.get("Name", "")) in ("base", "structure")]
    lower = [layer for layer in aligned if _layer_role(layer.get("Name", "")) in ("water", "shadow")]
    decor = [layer for layer in aligned if _layer_role(layer.get("Name", "")) == "decoration"]
    result = {"Ground": bases, "Mask": lower, "Mask2": [], "Fringe": [], "Fringe2": []}
    buckets = ["Mask2", "Fringe", "Fringe2"] if lower else ["Mask", "Mask2", "Fringe", "Fringe2"]
    if decor:
        for index, layer in enumerate(decor):
            bucket = min(len(buckets) - 1, index * len(buckets) // len(decor))
            result[buckets[bucket]].append(layer)
    return result


def _role_cell(obj: dict[str, Any], x: int, y: int, target_name: str) -> dict[str, Any]:
    cache_key = (id(obj), x, y, target_name)
    if cache_key in _ROLE_CELL_CACHE:
        return _ROLE_CELL_CACHE[cache_key]
    candidates = []
    for layer in _target_reference_layers(obj)[target_name]:
        cell = layer["Tiles"][x][y]
        if not _has_visual(cell):
            continue
        sanitized = copy.deepcopy(cell)
        sanitized["Layers"] = [
            tile_layer for tile_layer in sanitized.get("Layers", [])
            if tile_layer.get("Frames") and all(frame.get("Sheet") for frame in tile_layer["Frames"])
        ]
        if sanitized["Layers"] or sanitized.get("AutoTileset"):
            candidates.append(sanitized)
    if not candidates and target_name == "Ground":
        # Some native grammars draw a wall/edge entirely on an object stratum.
        # Ground must nevertheless retain one native visible terrain cell or the
        # PMDO renderer exposes black holes. This fallback merges the complete
        # source coordinate, not a screenshot and not another layout.
        for layer in _aligned_layers(obj):
            cell = layer["Tiles"][x][y]
            if _has_visual(cell):
                candidates.append(cell)
    result = _merge_cells(candidates) if candidates else _empty_cell()
    _ROLE_CELL_CACHE[cache_key] = result
    return result

def _reference_maps(repo: Path, asset: str) -> tuple[dict[str, Any], dict[str, Any], dict[Any, Any], list[list[str]]]:
    path = repo / "Data/Ground" / f"{asset}.rsground"
    require(path.is_file(), f"missing reference Ground {asset}")
    obj = read_json(path)["Object"]
    require(obj.get("TexSize") == 1, f"reference {asset} is not native 8 px TexSize 1")
    classes, pools, _ = build_cell_grammar(obj, repo)
    return obj, pools, {}, classes


def _resolve_coordinates(classes: list[list[str]], pools: dict[Any, list[tuple[int, int]]], seed: int) -> list[list[tuple[int, int]]]:
    rng = random.Random(seed)
    width, height = len(classes), len(classes[0])
    result: list[list[tuple[int, int]]] = [[(0, 0) for _ in range(height)] for _ in range(width)]
    for x in range(width):
        for y in range(height):
            preferred = []
            if x:
                sx, sy = result[x - 1][y]
                preferred.append((sx + 1, sy))
            if y:
                sx, sy = result[x][y - 1]
                preferred.append((sx, sy + 1))
            source, _, _, _ = _pick_source(
                pools, classes[x][y], _mask(classes, x, y),
                _transition_signature(classes, x, y), rng, preferred,
            )
            result[x][y] = source
    return result


def _pmu_tile_is_water(archive: TileArchive, tile_number: int) -> bool:
    if tile_number <= 0:
        return False
    image = archive.image(tile_number).convert("RGBA")
    colors = [(r, g, b) for r, g, b, a in image.getdata() if a >= 128]
    if not colors:
        return False
    r = sum(row[0] for row in colors) / len(colors)
    g = sum(row[1] for row in colors) / len(colors)
    b = sum(row[2] for row in colors) / len(colors)
    return b >= 80 and b > r * 1.18 and b > g * 1.04


def _target_classes(map_data: dict[str, Any], style_tags: set[str], tiles_dir: Path) -> tuple[list[list[str]], dict[str, Any], set[tuple[int, int]]]:
    source_width, source_height = map_data["max_x"] + 1, map_data["max_y"] + 1
    width, height = source_width * 4, source_height * 4
    tile_by_coord = {(tile["x"], tile["y"]): tile for tile in map_data["tiles"]}
    water_source: set[tuple[int, int]] = set()
    water_audit = {"enabled": bool(style_tags & {"water", "snow"}), "source_water_tiles": 0}
    if "water" in style_tags:
        archives: dict[int, TileArchive] = {}
        try:
            for tile in map_data["tiles"]:
                if tile["ground"] <= 0:
                    continue
                number = tile["ground_tileset"]
                if number not in archives:
                    archive = TileArchive(tiles_dir / f"Tiles{number}.tile", number)
                    archive.__enter__()
                    archives[number] = archive
                if _pmu_tile_is_water(archives[number], tile["ground"]):
                    water_source.add((tile["x"], tile["y"]))
        finally:
            for archive in archives.values():
                archive.__exit__(None, None, None)
    water_audit["source_water_tiles"] = len(water_source)
    classes = [["open" for _ in range(height)] for _ in range(width)]
    blocked_cells: set[tuple[int, int]] = set()
    for sx in range(source_width):
        for sy in range(source_height):
            tile = tile_by_coord[(sx, sy)]
            value = "water" if (sx, sy) in water_source else "wall" if tile["type"] in DEFINITE_BLOCK else "open"
            for x in range(sx * 4, sx * 4 + 4):
                for y in range(sy * 4, sy * 4 + 4):
                    classes[x][y] = value
                    if tile["type"] in DEFINITE_BLOCK:
                        blocked_cells.add((x, y))
    return classes, water_audit, blocked_cells


def _building_motifs(obj: dict[str, Any]) -> list[dict[str, Any]]:
    decoration_layers = [layer for layer in _aligned_layers(obj) if _layer_role(layer.get("Name", "")) == "decoration"]
    points = {
        (x, y) for layer in decoration_layers
        for x, column in enumerate(layer["Tiles"]) for y, cell in enumerate(column)
        if _has_visual(cell)
    }
    components = []
    while points:
        start = points.pop(); component = {start}; queue = [start]
        while queue:
            x, y = queue.pop()
            for nx in range(x - 1, x + 2):
                for ny in range(y - 1, y + 2):
                    if (nx, ny) in points:
                        points.remove((nx, ny)); component.add((nx, ny)); queue.append((nx, ny))
        x0, x1 = min(x for x, _ in component), max(x for x, _ in component)
        y0, y1 = min(y for _, y in component), max(y for _, y in component)
        width, height = x1 - x0 + 1, y1 - y0 + 1
        density = len(component) / (width * height)
        if not (40 <= len(component) <= 220 and 6 <= width <= 20 and 6 <= height <= 20 and density >= .35):
            continue
        cells = {}
        for x, y in component:
            merged = _merge_cells([layer["Tiles"][x][y] for layer in decoration_layers if _has_visual(layer["Tiles"][x][y])])
            if _has_visual(merged):
                cells[(x - x0, y - y0)] = merged
        components.append({"width": width, "height": height, "cell_count": len(cells), "cells": cells, "source_origin": [x0, y0]})
    return sorted(components, key=lambda row: (row["width"] * row["height"], row["source_origin"]))


def _building_overlays(map_data: dict[str, Any], base_obj: dict[str, Any], seed: int, category: str) -> tuple[dict[tuple[int, int], dict[str, Any]], list[dict[str, Any]]]:
    if category != "settlement":
        return {}, []
    motifs = _building_motifs(base_obj)
    warps = [tile for tile in map_data["tiles"] if tile["type"] == 2 and tile["data1"] > 0]
    if not motifs or not warps:
        return {}, []
    width, height = (map_data["max_x"] + 1) * 4, (map_data["max_y"] + 1) * 4
    overlay: dict[tuple[int, int], dict[str, Any]] = {}
    placements = []
    occupied = set()
    for index, warp in enumerate(sorted(warps, key=lambda row: (row["x"], row["y"]))):
        motif = motifs[(seed + index * 7) % len(motifs)]
        door_x, door_y = warp["x"] * 4 + 2, warp["y"] * 4 + 2
        origin_x = max(0, min(width - motif["width"], door_x - motif["width"] // 2))
        origin_y = max(0, min(height - motif["height"], door_y - motif["height"] + 2))
        candidates = [(origin_x, origin_y)] + [
            (max(0, min(width - motif["width"], origin_x + dx)), max(0, min(height - motif["height"], origin_y + dy)))
            for dx, dy in ((-8, 0), (8, 0), (0, -8), (-12, -4), (12, -4))
        ]
        chosen = None
        for ox, oy in candidates:
            footprint = {(ox + x, oy + y) for x, y in motif["cells"]}
            if not footprint & occupied:
                chosen = (ox, oy, footprint); break
        if chosen is None:
            continue
        ox, oy, footprint = chosen
        occupied |= footprint
        for (x, y), cell in motif["cells"].items():
            overlay[(ox + x, oy + y)] = cell
        placements.append({
            "warp": [warp["x"], warp["y"]], "target": f"s{warp['data1']}",
            "origin_8px": [ox, oy], "size_8px": [motif["width"], motif["height"]],
            "cell_count": motif["cell_count"], "source_motif_origin": motif["source_origin"],
            "layout_source": "PMU_WARP_ANCHOR", "visual_source": "LOCAL_PMDO_BUILDING_MOTIF",
        })
    return overlay, placements


def _source_layer_used(map_data: dict[str, Any], source_field: str, px: int, py: int) -> bool:
    sx = min(map_data["max_x"], max(0, px // 32))
    sy = min(map_data["max_y"], max(0, py // 32))
    tile = map_data["tiles"][sx * (map_data["max_y"] + 1) + sy]
    return tile[source_field] != 0


def _source_animation_used(map_data: dict[str, Any], anim_field: str, px: int, py: int) -> bool:
    sx = min(map_data["max_x"], max(0, px // 32))
    sy = min(map_data["max_y"], max(0, py // 32))
    tile = map_data["tiles"][sx * (map_data["max_y"] + 1) + sy]
    return tile[anim_field] != 0


def _empty_ground_object(name: str, x: int, y: int, width: int, height: int, *, passable: bool, trigger: int = 0) -> dict[str, Any]:
    anim = {"$type": "RogueEssence.Content.ObjAnimData, RogueEssence", "AnimIndex": "", "FrameTime": 1, "StartFrame": -1, "EndFrame": -1, "AnimDir": -1, "Alpha": 255, "AnimFlip": 0}
    return {
        "EntName": name, "Direction": 0, "EntEnabled": True, "EntOrder": 0,
        "InteractOrder": 0, "triggerType": trigger, "ObjectAnim": copy.deepcopy(anim),
        "Passable": passable, "CurrentAnim": copy.deepcopy(anim), "AnimTime": {"Ticks": 0},
        "Cycles": 0, "DrawOffset": {"X": 0, "Y": 0},
        "Collider": {"X": x, "Y": y, "Width": width, "Height": height},
    }


def _marker(name: str, x: int, y: int, width: int = 16, height: int = 16, direction: int = 0) -> dict[str, Any]:
    return {
        "EntName": name, "Direction": direction, "EntEnabled": True, "EntOrder": 0,
        "InteractOrder": 0, "triggerType": 0,
        "Collider": {"X": x, "Y": y, "Width": width, "Height": height},
    }


def _load_pokedex(content_zip: Path) -> dict[int, str]:
    result = {}
    with zipfile.ZipFile(content_zip) as archive, archive.open("pmu_data.sql") as stream:
        for raw in stream:
            line = raw.decode("utf-8", errors="replace")
            if line.startswith("INSERT INTO `pokedex_pokemon` VALUES "):
                for row in parse_insert_rows(line):
                    result[int(row[0])] = str(row[1])
                break
    return result


def _species_slug(name: str, dex_num: int | None = None) -> str:
    if dex_num == 29:
        return "nidoran_f"
    if dex_num == 32:
        return "nidoran_m"
    value = name.casefold().replace("♀", "_f").replace("♂", "_m")
    value = re.sub(r"[^a-z0-9]+", "_", value).strip("_")
    aliases = {"nidoran_f": "nidoran_f", "nidoran_m": "nidoran_m", "mr_mime": "mr_mime", "farfetch_d": "farfetchd"}
    return aliases.get(value, value)


def _npc_entities(repo: Path, sql_db: Path, map_data: dict[str, Any], seed: int, pokedex: dict[int, str]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    prototype_ground = read_json(repo / "Data/Ground/altere_pond.rsground")["Object"]
    prototype = next(char for layer in prototype_ground["Entities"] for char in layer["MapChars"])
    con = sqlite3.connect(sql_db)
    con.row_factory = sqlite3.Row
    entities = []
    unresolved = []
    for preset in map_data.get("npcs", []):
        row = con.execute("SELECT * FROM npc_defs WHERE num=?", (preset["number"],)).fetchone()
        definition = dict(row) if row else None
        sprite = definition.get("sprite") if definition else None
        species_name = pokedex.get(sprite) if sprite is not None else None
        if not definition or not species_name:
            unresolved.append({"slot": preset["slot"], "number": preset["number"], "sprite": sprite, "reason": "species mapping UNKNOWN"})
            continue
        if not (0 <= preset["spawn_x"] <= map_data["max_x"] and 0 <= preset["spawn_y"] <= map_data["max_y"]):
            unresolved.append({
                "slot": preset["slot"], "number": preset["number"], "sprite": sprite,
                "reason": "source coordinates are -1/outside: PMU runtime-random spawn position requires native PMDO spawner adapter",
                "status": "RUNTIME_RANDOM_POSITION",
            })
            continue
        entity = copy.deepcopy(prototype)
        ent_name = f"PMU_NPC_{preset['slot']:03d}_{preset['number']:04d}"
        x, y = preset["spawn_x"] * 32 + 8, preset["spawn_y"] * 32 + 8
        direction = (0, 2, 4, 6)[random.Random(seed + preset["slot"]).randrange(4)]
        entity.update({
            "EntName": ent_name, "Direction": direction, "serializationDir": direction,
            "serializationLoc": {"X": x, "Y": y}, "Collider": {"X": x, "Y": y, "Width": 16, "Height": 16},
            "AIEnabled": definition.get("behavior") in (0, 1, 6, 7),
        })
        entity["Data"]["Nickname"] = definition.get("name", "")
        entity["Data"]["BaseForm"] = {
            "Species": _species_slug(species_name, sprite), "Form": int(definition.get("form") or 0),
            "Skin": "shiny" if definition.get("shiny") else "normal", "Gender": int(definition.get("sex") or 0),
        }
        entity["Data"]["Level"] = max(1, int(preset.get("min_level") or 1))
        entities.append(entity)
    con.close()
    return entities, unresolved


def _build_entities(repo: Path, sql_db: Path, map_data: dict[str, Any], seed: int, pokedex: dict[int, str]) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    markers = []
    objects = []
    connections = []
    conditional = []
    for tile in map_data["tiles"]:
        px, py = tile["x"] * 32, tile["y"] * 32
        if tile["type"] == 2 and tile["data1"] > 0:
            name = f"Warp_{tile['x']}_{tile['y']}_to_s{tile['data1']}"
            objects.append(_empty_ground_object(name, px, py, 32, 32, passable=True, trigger=2))
            connections.append({"entity": name, "target": f"s{tile['data1']}", "target_x": tile["data2"], "target_y": tile["data3"], "kind": "warp"})
        elif tile["type"] in CONDITIONAL_BLOCK:
            name = f"Conditional_{TILE_TYPES[tile['type']]}_{tile['x']}_{tile['y']}"
            objects.append(_empty_ground_object(name, px, py, 32, 32, passable=False))
            conditional.append({"entity": name, "type": tile["type"], "data1": tile["data1"], "data2": tile["data2"], "data3": tile["data3"], "status": "RUNTIME_ADAPTER_REQUIRED"})
        elif tile["type"] not in (0, 1, 4, 10, 24, 25):
            name = f"Trigger_{tile['type']}_{tile['x']}_{tile['y']}"
            markers.append(_marker(name, px + 8, py + 8))
    for direction, field in (("up", "up_map"), ("down", "down_map"), ("left", "left_map"), ("right", "right_map")):
        target = map_data.get(field) or 0
        if target <= 0:
            continue
        width, height = (map_data["max_x"] + 1) * 32, (map_data["max_y"] + 1) * 32
        if direction in ("up", "down"):
            x, y, w, h = 0, 0 if direction == "up" else height - 8, width, 8
        else:
            x, y, w, h = 0 if direction == "left" else width - 8, 0, 8, height
        name = f"Cardinal_{direction}_to_s{target}"
        objects.append(_empty_ground_object(name, x, y, w, h, passable=True, trigger=2))
        connections.append({"entity": name, "target": f"s{target}", "kind": "cardinal", "direction": direction})
    if not markers:
        markers.append(_marker("Main_Entrance_Marker", 8, 8))
    else:
        first = copy.deepcopy(markers[0]); first["EntName"] = "Main_Entrance_Marker"; markers.insert(0, first)
    npcs, unresolved_npcs = _npc_entities(repo, sql_db, map_data, seed, pokedex)
    layer = {"Name": "PMU adaptation entities", "Visible": True, "MapChars": npcs, "GroundObjects": objects, "Spawners": [], "Markers": markers}
    return [layer], {
        "marker_count": len(markers), "ground_object_count": len(objects), "npc_count": len(npcs),
        "unresolved_npcs": unresolved_npcs, "conditional_collisions": conditional,
        "connections": connections,
    }


def _ground_shell(asset: str, name: str, tex_size: int, layers: list[dict[str, Any]], obstacles: list[list[dict[str, Any]]], entities: list[dict[str, Any]], music: str) -> dict[str, Any]:
    return {
        "Version": "0.8.9.0",
        "Object": {
            "$type": "RogueEssence.Ground.GroundMap, RogueEssence", "TexSize": tex_size,
            "Name": {"DefaultText": name, "LocalTexts": {"fr": name}}, "Released": False,
            "Comment": "Candidat PMU→PMDO natif reconstruit depuis topologie et sémantique; aucune image de map source utilisée.",
            "obstacles": obstacles, "rand": {"$type": "RogueElements.ReRandom, RogueElements", "s": [0, 0, 0, 0]},
            "Status": {}, "Background": {"$type": "RogueEssence.Dungeon.MapBG, RogueEssence", "MapLoc": {"X": 0, "Y": 0}, "BGAnim": {"AnimIndex": "", "FrameTime": 1, "StartFrame": -1, "EndFrame": -1, "AnimDir": -1, "Alpha": 255, "AnimFlip": 0}, "BGMovement": {"X": 0, "Y": 0}, "Parallax": "0, 0", "RepeatX": False, "RepeatY": False},
            "BlankBG": _empty_cell(), "Layers": layers, "AssetName": asset, "Music": music or "",
            "EdgeView": 1, "NoSwitching": False, "ViewCenter": None, "ViewOffset": {"X": 0, "Y": 0}, "ActiveChar": None,
            "Decorations": [{"Name": "Décor", "Layer": 0, "Visible": True, "Anims": []}], "Entities": entities,
        },
    }


def _controller(asset: str, connections: list[dict[str, Any]], conditional: list[dict[str, Any]]) -> str:
    lines = ["-- Candidat PMU→PMDO; routes prouvées uniquement.", "require 'origin.common'", f"local M={{}}", "function M.Init(map)"]
    for row in conditional:
        lines.append(f"  -- {row['entity']}: PMU {TILE_TYPES[row['type']]} payload {row['data1']}/{row['data2']}/{row['data3']}; adapter requis")
    lines += ["end", "function M.Enter(map) end", "function M.Exit(map) end", "function M.Update(map) end"]
    for row in connections:
        target = "pmu_" + row["target"]
        marker = f"PMU_Entry_{row.get('target_x', 0)}_{row.get('target_y', 0)}"
        lines += [
            f"function M.{row['entity']}_Touch(obj, activator)",
            "  GAME:FadeOut(false, 20)", f"  GAME:EnterGroundMap('{target}', '{marker}')", "end",
        ]
    lines += ["function M.GameSave(map) end", "function M.GameLoad(map) end", "return M", ""]
    return "\n".join(lines)


def compose_one(
    repo: Path, source_root: Path, adaptation_root: Path, config: dict[str, Any], map_id: str,
) -> dict[str, Any]:
    selection = config["maps"][map_id]
    plan_path = adaptation_root / "plans" / f"{map_id}.json"
    plan = read_json(plan_path)
    source_entry = next(row for row in read_json(source_root / "global-manifest.json")["maps"] if row["map_id"] == map_id)
    ir_path = Path(source_entry["canonical_source"])
    map_data = read_ir(ir_path)
    output = adaptation_root / "representative" / map_id
    if output.exists():
        shutil.rmtree(output)
    if selection["resolution"] == "BLOCKED":
        report = {
            "schema": "new-era.pmu-pmdo-composition.v1", "map_id": map_id,
            "name": map_data["name"], "source_revision": map_data["revision"],
            "status": "BLOCKED", "reason": selection["rationale"],
            "plan": str(plan_path), "plan_sha256": sha256_file(plan_path),
            "dimensions": {
                "source_tiles": [map_data["max_x"] + 1, map_data["max_y"] + 1],
                "source_px": plan["immutable_source"]["dimensions_px"],
                "tex_size": plan["target_geometry"]["pmdo_tex_size"],
            },
            "source": {"ir": str(ir_path), "ir_json_sha256": source_entry["canonical_json_sha256"], "png_used_as_ground_texture": False},
            "outputs": {"ground": None, "tile": None, "controller": None, "pmdo_png": None, "runtime_report": None},
            "blockers": [selection["rationale"]],
            "runtime_status": "NOT_RUN", "visual_review_status": "NOT_RUN", "validation_status": "BLOCKED",
        }
        write_json(output / "manifest.json", report)
        return report
    require(source_entry["canonical_json_sha256"] == plan["immutable_source"]["canonical_ir_json_sha256"], f"{map_id}: plan/source IR hash differs")
    require(sha256_file(Path(plan["immutable_source"]["source_png"])) == plan["immutable_source"]["source_png_sha256"], f"{map_id}: immutable source PNG hash differs")
    base_asset = selection["base_reference"]
    decor_asset = selection["decoration_reference"] or base_asset
    base_path = repo / "Data/Ground" / f"{base_asset}.rsground"
    decor_path = repo / "Data/Ground" / f"{decor_asset}.rsground"
    base_obj, base_pools, _, _ = _reference_maps(repo, base_asset)
    decor_obj, decor_pools, _, _ = _reference_maps(repo, decor_asset)
    global _KNOWLEDGE_CACHE
    if _KNOWLEDGE_CACHE is None:
        _KNOWLEDGE_CACHE = analyze_references(repo, None, 0, 0)
    knowledge_by_id = {row["ground_id"]: row for row in _KNOWLEDGE_CACHE["grounds"]}
    if base_asset not in _PROFILE_CACHE:
        _PROFILE_CACHE[base_asset] = _visual_profile(repo, knowledge_by_id[base_asset])
    if decor_asset not in _PROFILE_CACHE:
        _PROFILE_CACHE[decor_asset] = _visual_profile(repo, knowledge_by_id[decor_asset])
    base_profile = _PROFILE_CACHE[base_asset]
    decor_profile = _PROFILE_CACHE[decor_asset]
    distance = visual_distance(base_profile, decor_profile)
    maximum = selection.get("maximum_visual_distance", 0.24)
    if base_asset != decor_asset and (not set(base_profile["tile_sizes"]) & set(decor_profile["tile_sizes"]) or distance > maximum):
        reason = f"reference compatibility failed: distance {distance:.4f} > {maximum:.4f} or tile sizes differ"
        report = {
            "schema": "new-era.pmu-pmdo-composition.v1", "map_id": map_id,
            "name": map_data["name"], "source_revision": map_data["revision"],
            "status": "BLOCKED", "reason": reason,
            "dimensions": {"source_tiles": [map_data["max_x"] + 1, map_data["max_y"] + 1], "source_px": plan["immutable_source"]["dimensions_px"], "tex_size": plan["target_geometry"]["pmdo_tex_size"]},
            "references": {"base": base_asset, "decoration": decor_asset, "visual_distance": round(distance, 4)},
            "source": {"ir": str(ir_path), "ir_json_sha256": source_entry["canonical_json_sha256"], "png_used_as_ground_texture": False},
            "outputs": {"ground": None, "tile": None, "controller": None, "pmdo_png": None, "runtime_report": None},
            "blockers": [reason], "runtime_status": "NOT_RUN", "visual_review_status": "NOT_RUN", "validation_status": "BLOCKED",
        }
        write_json(output / "manifest.json", report)
        return report
    classes, water_audit, blocked_cells = _target_classes(map_data, set(plan["classification"]["style_tags"]), repo / ".runtime-cache/pmu/PMU-Client/resources/GFX/Tiles")
    base_coords = _resolve_coordinates(classes, base_pools, plan["seed"])
    decor_coords = base_coords if decor_asset == base_asset else _resolve_coordinates(classes, decor_pools, plan["seed"] ^ 0x5A5A5A5A)
    building_overlay, building_placements = _building_overlays(
        map_data, base_obj, plan["seed"], plan["classification"]["category"]
    )
    tex_size = int(plan["target_geometry"]["pmdo_tex_size"])
    factor = tex_size
    collision_width, collision_height = len(classes), len(classes[0])
    visual_width, visual_height = collision_width // factor, collision_height // factor
    require([visual_width, visual_height] == plan["target_geometry"]["pmdo_visual_grid"], f"{map_id}: target visual dimensions differ from plan")
    reader = NativeTileReader(repo)
    sheet = f"pmu_{map_id}_Native"
    payload_locations: dict[bytes, tuple[int, int]] = {}
    entries: list[tuple[int, bytes]] = []
    target_layers = []
    animation_required = Counter()
    animation_distinct = Counter()
    missing_role_grammar = set()

    def add_payload(image: Image.Image) -> tuple[int, int]:
        payload = _png_bytes(image)
        if payload not in payload_locations:
            index = len(payload_locations)
            location = (index % 64, index // 64)
            payload_locations[payload] = location
            entries.append((location[0] | (location[1] << 32), payload))
        return payload_locations[payload]

    for target_name, source_field, anim_field in SOURCE_LAYERS:
        columns = []
        target_has_role = bool(_target_reference_layers(base_obj)[target_name])
        if decor_obj is not base_obj:
            target_has_role = target_has_role or bool(_target_reference_layers(decor_obj)[target_name])
        if not target_has_role and any(tile[source_field] for tile in map_data["tiles"]):
            missing_role_grammar.add(target_name)
        for vx in range(visual_width):
            column = []
            for vy in range(visual_height):
                px, py = vx * factor * 8, vy * factor * 8
                has_building_overlay = target_name == "Fringe" and any(
                    (vx * factor + ox, vy * factor + oy) in building_overlay
                    for ox in range(factor) for oy in range(factor)
                )
                if (not _source_layer_used(map_data, source_field, px, py) and not has_building_overlay) or not target_has_role:
                    column.append(_empty_cell())
                    continue
                frames = []
                required = _source_animation_used(map_data, anim_field, px, py)
                ticks = (0, 15) if required else (0,)
                for tick in ticks:
                    composite = Image.new("RGBA", (factor * 8, factor * 8), (0, 0, 0, 0))
                    for ox in range(factor):
                        for oy in range(factor):
                            cx, cy = vx * factor + ox, vy * factor + oy
                            use_decor = False
                            if selection["blend_policy"] == "snow_on_open_terrain" and classes[cx][cy] in ("open", "water"):
                                use_decor = True
                            elif selection["blend_policy"] == "source_fringe_regions" and target_name in ("Fringe", "Fringe2"):
                                use_decor = True
                            obj = decor_obj if use_decor else base_obj
                            coords = decor_coords if use_decor else base_coords
                            sx, sy = coords[cx][cy]
                            if target_name == "Fringe" and (cx, cy) in building_overlay:
                                cell = building_overlay[(cx, cy)]
                            else:
                                cell = _role_cell(obj, sx, sy, target_name)
                            image = _cell_image(cell, tick, reader)
                            if target_name == "Ground" and image.getbbox() is None:
                                all_cells = [layer["Tiles"][sx][sy] for layer in _aligned_layers(obj) if _has_visual(layer["Tiles"][sx][sy])]
                                image = _cell_image(_merge_cells(all_cells), tick, reader)
                            composite.alpha_composite(image, (ox * 8, oy * 8))
                    frames.append(add_payload(composite))
                if required:
                    animation_required[target_name] += 1
                    if len(set(frames)) > 1:
                        animation_distinct[target_name] += 1
                column.append({
                    "AutoTileset": "", "Associates": [],
                    "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": x, "Y": y}} for x, y in frames], "FrameLength": 15 if required else 60}],
                    "NeighborCode": -1,
                })
            columns.append(column)
        target_layers.append({"Name": f"PMU {target_name}", "Layer": 0, "Visible": True, "Tiles": columns})

    obstacles = [[{
        "Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8},
        "Tags": 1 if (x, y) in blocked_cells else 0,
    } for y in range(collision_height)] for x in range(collision_width)]
    content_zip = repo / ".runtime-cache/pmu/PMU-Server/Content_Data.zip"
    pokedex = _load_pokedex(content_zip)
    entities, entity_report = _build_entities(repo, source_root / "pmu-standard.sqlite3", map_data, plan["seed"], pokedex)
    asset = f"pmu_{map_id}"
    ground = _ground_shell(asset, map_data["name"], tex_size, target_layers, obstacles, entities, map_data.get("music", ""))
    output.mkdir(parents=True, exist_ok=True)
    tile_path = output / "Content/Tile" / f"{sheet}.tile"
    ground_path = output / "Data/Ground" / f"{asset}.rsground"
    script_path = output / "Data/Script/halcyon/ground" / asset / "init.lua"
    write_tile(tile_path, tex_size * 8, entries)
    ground_path.parent.mkdir(parents=True, exist_ok=True)
    ground_path.write_text("\ufeff" + json.dumps(ground, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")
    script_path.parent.mkdir(parents=True, exist_ok=True)
    script_path.write_text(_controller(asset, entity_report["connections"], entity_report["conditional_collisions"]), encoding="utf-8", newline="\n")

    expected_definite = sum(tile["type"] in DEFINITE_BLOCK for tile in map_data["tiles"]) * 16
    actual_definite = sum(cell["Tags"] != 0 for column in obstacles for cell in column)
    source_animation_counts = {name: sum(tile[anim] != 0 for tile in map_data["tiles"]) for name, _, anim in SOURCE_LAYERS}
    animation_failures = {
        name: {"source_animated_tiles": source_animation_counts[name], "target_animated_cells": animation_required[name], "visually_distinct_target_cells": animation_distinct[name]}
        for name in source_animation_counts if source_animation_counts[name] and animation_distinct[name] == 0
    }
    checks = {
        "ground_json_round_trip": read_json(ground_path) == ground,
        "tex_size_matches_plan": ground["Object"]["TexSize"] == tex_size,
        "visual_grid_matches_plan": all(len(layer["Tiles"]) == visual_width and all(len(column) == visual_height for column in layer["Tiles"]) for layer in target_layers),
        "collision_grid_matches_plan": [collision_width, collision_height] == plan["target_geometry"]["pmdo_collision_grid"],
        "definite_collision_exact": actual_definite == expected_definite,
        "five_semantic_layers_present": [layer["Name"] for layer in target_layers] == [f"PMU {name}" for name, _, _ in SOURCE_LAYERS],
        "tile_dependency_exists": tile_path.is_file() and bool(entries),
        "all_entities_in_bounds": all(
            0 <= entity["Collider"]["X"] < collision_width * 8 and 0 <= entity["Collider"]["Y"] < collision_height * 8
            for layer in entities for kind in ("MapChars", "GroundObjects", "Markers") for entity in layer[kind]
        ),
    }
    blockers = [
        blocker for blocker in plan.get("adaptation_blockers", [])
        if not (
            selection["resolution"] == "REFERENCE_RESOLVED"
            and ("style families" in blocker or "grammar reference" in blocker or "visual compatibility" in blocker)
        )
    ]
    if missing_role_grammar:
        blockers.append("native reference lacks target layer grammars: " + ", ".join(sorted(missing_role_grammar)))
    if animation_failures:
        blockers.append("source animation has no visually distinct native target frame for: " + ", ".join(sorted(animation_failures)))
    if entity_report["unresolved_npcs"]:
        reasons = {row["reason"] for row in entity_report["unresolved_npcs"]}
        blockers.append("NPC adaptation unresolved: " + "; ".join(sorted(reasons)))
    if entity_report["conditional_collisions"]:
        blockers.append("conditional collision objects are materialized conservatively but PMDO mobility/level runtime adapter remains required")
    if map_data.get("npcs"):
        blockers.append("NPC source events/dialogue require French EU adaptation before final validation")
    static_pass = all(checks.values())
    status = "GROUND_GENERATED" if static_pass else "BLOCKED"
    manifest = {
        "schema": "new-era.pmu-pmdo-composition.v1", "map_id": map_id,
        "source_revision": map_data["revision"], "name": map_data["name"],
        "status": status, "validation_status": "ADAPTATION_READY" if static_pass and not blockers else "BLOCKED",
        "runtime_status": "NOT_RUN", "visual_review_status": "NOT_RUN", "seed": plan["seed"],
        "source": {
            "ir": str(ir_path), "ir_json_sha256": source_entry["canonical_json_sha256"],
            "source_png": plan["immutable_source"]["source_png"], "source_png_sha256": plan["immutable_source"]["source_png_sha256"],
            "png_used_as_ground_texture": False,
        },
        "dimensions": {
            "source_tiles": [map_data["max_x"] + 1, map_data["max_y"] + 1],
            "source_px": plan["immutable_source"]["dimensions_px"],
            "target_visual_grid": [visual_width, visual_height], "target_collision_grid_8px": [collision_width, collision_height],
            "tex_size": tex_size,
        },
        "references": {
            "base": {"asset": base_asset, "path": str(base_path), "sha256": sha256_file(base_path)},
            "decoration": {"asset": decor_asset, "path": str(decor_path), "sha256": sha256_file(decor_path)},
            "visual_distance": round(distance, 4), "compatibility_limit": maximum,
            "layout_copied": False, "source_topology_drives_layout": True,
        },
        "composition": {
            "method": "source collision/topology expanded to native 8 px PMDO grid; cells resolved by class/mask/transition from map-local clean grammar; no PMU raster cells copied",
            "blend_policy": selection["blend_policy"], "water_analysis": water_audit,
            "building_motif_placements": building_placements,
            "building_policy": "complete local PMDO motifs anchored by canonical PMU warp coordinates; no PMDO reference layout copied",
            "layer_mapping": {
                name: {
                    "base_reference_layers": [layer.get("Name") for layer in _target_reference_layers(base_obj)[name]],
                    "decoration_reference_layers": [layer.get("Name") for layer in _target_reference_layers(decor_obj)[name]],
                }
                for name, _, _ in SOURCE_LAYERS
            },
            "missing_role_grammar": sorted(missing_role_grammar),
        },
        "collision": {
            "expected_definite_8px_cells": expected_definite, "actual_definite_8px_cells": actual_definite,
            "conditional": entity_report["conditional_collisions"], "status": "PASS" if checks["definite_collision_exact"] and not entity_report["conditional_collisions"] else "PARTIAL",
        },
        "animation": {
            "source_counts": source_animation_counts, "target_counts": dict(animation_required),
            "target_distinct_counts": dict(animation_distinct), "failures": animation_failures,
            "frame_length_pmdo_ticks": 15, "status": "PASS" if not animation_failures else "BLOCKED",
        },
        "npcs_objects": entity_report,
        "outputs": {
            "ground": str(ground_path), "ground_sha256": sha256_file(ground_path),
            "tile": str(tile_path), "tile_sha256": sha256_file(tile_path), "tile_payload_count": len(payload_locations),
            "controller": str(script_path), "controller_sha256": sha256_file(script_path),
            "pmdo_png": None, "runtime_report": None,
        },
        "static_checks": checks, "blockers": sorted(set(blockers)),
    }
    write_json(output / "manifest.json", manifest)
    return manifest


def summarize_representative(repo: Path, adaptation_root: Path, config: dict[str, Any]) -> dict[str, Any]:
    phase1_hash = sha256_file(repo / "PMU_EXTRACTION/reports/artifact-hashes.sha256")
    results = [read_json(adaptation_root / "representative" / map_id / "manifest.json") for map_id in config["maps"]]
    counts = Counter(row["status"] for row in results)
    report = {
        "schema": "new-era.pmu-pmdo-representative.v1", "status": "COMPOSED",
        "map_count": len(results), "status_counts": dict(counts),
        "runtime_tested_count": 0, "validated_count": 0,
        "phase1_integrity": "PASS", "phase1_hash_manifest_sha256": phase1_hash,
        "maps": results,
    }
    write_json(adaptation_root / "representative/report.json", report)
    return report


def compose_representative(repo: Path, source_root: Path, adaptation_root: Path, config_path: Path) -> dict[str, Any]:
    config = read_json(config_path)
    before_phase1 = sha256_file(repo / "PMU_EXTRACTION/reports/artifact-hashes.sha256")
    representative_root = adaptation_root / "representative"
    if representative_root.exists():
        for child in representative_root.iterdir():
            if child.is_dir() and child.name.startswith("s") and child.name not in config["maps"]:
                shutil.rmtree(child)
    for map_id in config["maps"]:
        compose_one(repo, source_root, adaptation_root, config, map_id)
    after_phase1 = sha256_file(repo / "PMU_EXTRACTION/reports/artifact-hashes.sha256")
    require(before_phase1 == after_phase1, "PMU_EXTRACTION changed during phase-2 composition")
    return summarize_representative(repo, adaptation_root, config)
