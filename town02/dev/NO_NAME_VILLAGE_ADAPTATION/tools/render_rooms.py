#!/usr/bin/env python3
from __future__ import annotations

import argparse
import gzip
import json
import math
from pathlib import Path
from typing import Any

from PIL import Image

SEASONS = ("spring", "summer", "autumn", "winter")
# Exact assignments decompiled from gml_Object_objstage_Step_2.
SEASON_TILESETS = {
    "spring": {"grass1": 29, "grass0": 29, "ground": 29, "groundtex": 2, "water": 9, "cliff": 23, "cliff0": 23, "undergrass": 29},
    "summer": {"grass1": 8, "grass0": 8, "ground": 8, "groundtex": 2, "water": 9, "cliff": 20, "cliff0": 20, "undergrass": 8},
    "autumn": {"grass1": 21, "grass0": 21, "ground": 21, "groundtex": 4, "water": 9, "cliff": 24, "cliff0": 24, "undergrass": 21},
    "winter": {"grass1": 27, "grass0": 27, "ground": 27, "groundtex": 5, "water": 17, "cliff": 12, "cliff0": 12, "undergrass": 27},
}
SEASON_VISIBILITY = {
    "spring": {"groundplot": True, "vegetation": True, "endwater": False, "watereffect": True},
    "summer": {"groundplot": True, "vegetation": True, "endwater": False, "watereffect": True},
    "autumn": {"groundplot": True, "vegetation": False, "endwater": False, "watereffect": True},
    "winter": {"groundplot": False, "vegetation": False, "endwater": False, "watereffect": False},
}
SEASON_SPRITE_PREFIX = {"spring": "ssp", "summer": "ssm", "autumn": "sau", "winter": "swn"}
TREE_SPRITES = {
    "spring": {"objtree": "bgtree", "objtree0": "bgtree0"},
    "summer": {"objtree": "bgsmtree", "objtree0": "bgsmtree0"},
    # The runtime chooses the underscore variant with probability 0.2 in autumn.
    "autumn": {"objtree": "bgautree", "objtree0": "bgautree0"},
    "winter": {"objtree": "bgwntree", "objtree0": "bgwntree0"},
}
BOULDER_SPRITES = {
    "spring": {"objboulder0": "sboulder0", "objboulder1": "sboulder1"},
    "summer": {"objboulder0": "sboulder0", "objboulder1": "sboulder1"},
    "autumn": {"objboulder0": "sboulder0", "objboulder1": "sboulder1"},
    "winter": {"objboulder0": "swnrock3", "objboulder1": "swnrock2"},
}


def read_json(path: Path) -> Any: return json.loads(path.read_text(encoding="utf-8"))
def read_gzip(path: Path) -> Any:
    with gzip.open(path, "rt", encoding="utf-8") as stream: return json.load(stream)


class Renderer:
    def __init__(self, extracted: Path):
        inventory = extracted / "inventories"
        self.sprites = read_json(inventory / "sprites.json")
        self.tpag = read_json(inventory / "texture-page-items.json")
        self.tilesets = read_json(inventory / "tilesets.json")
        self.objects = read_json(inventory / "objects.json")
        self.sprite_by_name = {row["name"].casefold(): row for row in self.sprites}
        self.sprite_id_by_name = {row["name"].casefold(): row["id"] for row in self.sprites}
        self.textures = {}
        self.sprite_cache = {}
        self.tileset_cache = {}
        self.extracted = extracted

    def texture(self, index: int) -> Image.Image:
        if index not in self.textures:
            image = Image.open(self.extracted / "textures" / f"texture-{index:03d}.png").convert("RGBA")
            image.load(); self.textures[index] = image
        return self.textures[index]

    def tpag_image(self, index: int) -> Image.Image:
        item = self.tpag[index]
        source = self.texture(item["texture_page"]).crop((
            item["source_x"], item["source_y"],
            item["source_x"] + item["source_width"], item["source_y"] + item["source_height"],
        ))
        if source.size != (item["target_width"], item["target_height"]):
            source = source.resize((item["target_width"], item["target_height"]), Image.Resampling.NEAREST)
        return source

    def sprite(self, sprite_id: int, frame: int = 0) -> Image.Image:
        sprite = self.sprites[sprite_id]
        count = max(1, sprite["frame_count"]); frame %= count
        key = (sprite_id, frame)
        if key in self.sprite_cache: return self.sprite_cache[key]
        canvas = Image.new("RGBA", (sprite["width"], sprite["height"]), (0, 0, 0, 0))
        tpag_id = sprite["tpag_frames"][frame] if frame < len(sprite["tpag_frames"]) else -1
        if tpag_id >= 0:
            item = self.tpag[tpag_id]; image = self.tpag_image(tpag_id)
            canvas.alpha_composite(image, (item["target_x"], item["target_y"]))
        self.sprite_cache[key] = canvas
        return canvas

    def tileset_tile(self, tileset_id: int, tile_index: int, frame: int = 0) -> Image.Image | None:
        tileset = self.tilesets[tileset_id]
        if tile_index <= 0 or tile_index >= tileset["tile_count"]: return None
        frame %= max(1, tileset["frames_per_tile"])
        mapped = tileset["tile_ids"][tile_index * tileset["frames_per_tile"] + frame]
        key = (tileset_id, mapped)
        if key in self.tileset_cache: return self.tileset_cache[key]
        item = self.tpag[tileset["texture_page_item"]]
        atlas = self.tpag_image(tileset["texture_page_item"])
        columns = tileset["columns"]
        width, height = tileset["tile_width"], tileset["tile_height"]
        x = tileset["border_x"] + (mapped % columns) * (width + 2 * tileset["border_x"])
        y = tileset["border_y"] + (mapped // columns) * (height + 2 * tileset["border_y"])
        tile = atlas.crop((x, y, x + width, y + height))
        self.tileset_cache[key] = tile
        return tile


def seasonal_object(object_row: dict[str, Any], season: str, by_name: dict[str, dict[str, Any]]) -> dict[str, Any] | None:
    family = object_row.get("season_family")
    name = object_row["name"].casefold()
    prefixes = {"spring": "objsp", "summer": "objsm", "autumn": "objau", "winter": "objwn"}
    if family:
        if family == season:
            return object_row
        if family == "spring" and name.startswith("objsp"):
            return by_name.get(prefixes[season] + name[len("objsp"):])
        return None
    # objtree/objtree0 are the same instances in every season; objstage changes
    # only sprite_index, handled by exact_object_sprite().
    return object_row


def exact_object_sprite(renderer: Renderer, object_row: dict[str, Any], season: str) -> int:
    """Apply the exact objstage sprite assignments used for trees/boulders."""
    name = object_row["name"].casefold()
    sprite_name = TREE_SPRITES[season].get(name) or BOULDER_SPRITES[season].get(name)
    if sprite_name:
        return renderer.sprite_id_by_name.get(sprite_name.casefold(), -1)
    return object_row.get("sprite_id", -1)


def exact_asset_sprite(renderer: Renderer, sprite_id: int, layer_name: str, season: str) -> int:
    """Apply objstage's `Below` layer prefix substitution exactly."""
    if layer_name.casefold() != "below" or not 0 <= sprite_id < len(renderer.sprites):
        return sprite_id
    current = renderer.sprites[sprite_id]["name"]
    if len(current) < 3:
        return sprite_id
    wanted = SEASON_SPRITE_PREFIX[season] + current[3:]
    result = renderer.sprite_id_by_name.get(wanted.casefold(), sprite_id)
    if season == "autumn" and result == 2566:
        result = renderer.sprite_id_by_name.get("srm542", result)
    elif season == "winter" and result == 2566:
        result = renderer.sprite_id_by_name.get("srm543", result)
    return result


def transform(image: Image.Image, scale: list[float], rotation: float) -> Image.Image:
    width, height = max(1, round(image.width * abs(scale[0]))), max(1, round(image.height * abs(scale[1])))
    result = image.resize((width, height), Image.Resampling.NEAREST)
    if scale[0] < 0: result = result.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    if scale[1] < 0: result = result.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
    if rotation: result = result.rotate(-rotation, resample=Image.Resampling.NEAREST, expand=True)
    return result


def draw_sprite(canvas: Image.Image, renderer: Renderer, sprite_id: int, x: int, y: int, scale: list[float], rotation: float, frame: int) -> None:
    if not 0 <= sprite_id < len(renderer.sprites): return
    sprite = renderer.sprites[sprite_id]
    image = transform(renderer.sprite(sprite_id, frame), scale, rotation)
    left = round(x - sprite["origin"][0] * scale[0])
    top = round(y - sprite["origin"][1] * scale[1])
    canvas.alpha_composite(image, (left, top))


def render_room(extracted: Path, room_entry: dict[str, Any], output: Path, season: str, tick: int = 0) -> dict[str, Any]:
    room = read_gzip(Path(room_entry["ir"]))
    renderer = Renderer(extracted)
    width, height = room["dimensions_px"]
    color = room["color"]
    background = (color & 255, (color >> 8) & 255, (color >> 16) & 255, 255)
    canvas = Image.new("RGBA", (width, height), background)
    instances = {row["instance_id"]: row for row in room["instances"]}
    objects_by_name = {row["name"].casefold(): row for row in renderer.objects}
    def effective_visible(layer: dict[str, Any]) -> bool:
        override = SEASON_VISIBILITY[season].get(layer["name"].casefold())
        return layer["visible"] if override is None else override

    layers = sorted((layer for layer in room["layers"] if effective_visible(layer)), key=lambda row: row["depth"], reverse=True)
    for layer in layers:
        layer_type = layer["type"]
        layer_name = layer["name"].casefold()
        if layer_type == 4 and layer.get("tileset_id", -1) >= 0:
            tileset_id = SEASON_TILESETS[season].get(layer_name, layer["tileset_id"])
            # Winter keeps ordinary water in Blue Forest rooms.
            if season == "winter" and layer_name == "water" and any(row["name"].casefold() == "blueforest" for row in room["layers"]):
                tileset_id = 9
            tileset = renderer.tilesets[tileset_id]
            grid_w, grid_h = layer["grid"]
            for gy in range(grid_h):
                for gx in range(grid_w):
                    raw = layer["tile_data"][gy * grid_w + gx]
                    tile_id = raw & 0x0007FFFF
                    image = renderer.tileset_tile(tileset_id, tile_id, tick)
                    if image is None: continue
                    if raw & 0x10000000: image = image.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
                    if raw & 0x20000000: image = image.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
                    if raw & 0x40000000: image = image.transpose(Image.Transpose.ROTATE_90)
                    canvas.alpha_composite(image, (round(layer["offset"][0]) + gx * tileset["tile_width"], round(layer["offset"][1]) + gy * tileset["tile_height"]))
        elif layer_type == 3:
            for placement in layer.get("sprite_placements", []):
                sprite_id = exact_asset_sprite(renderer, placement["sprite_id"], layer["name"], season)
                sprite = renderer.sprites[sprite_id] if 0 <= sprite_id < len(renderer.sprites) else None
                if not sprite: continue
                frame = round(placement["frame_index"] + tick * placement["animation_speed"]) % max(1, sprite["frame_count"])
                draw_sprite(canvas, renderer, sprite_id, placement["x"], placement["y"], placement["scale"], placement["rotation"], frame)
        elif layer_type == 2:
            for instance_id in layer.get("instance_ids", []):
                instance = instances.get(instance_id)
                if not instance: continue
                obj_id = instance["object_id"]
                if not 0 <= obj_id < len(renderer.objects): continue
                obj = seasonal_object(renderer.objects[obj_id], season, objects_by_name)
                if not obj or not obj["visible"]: continue
                sprite_id = exact_object_sprite(renderer, obj, season)
                if not 0 <= sprite_id < len(renderer.sprites): continue
                sprite = renderer.sprites[sprite_id]
                frame = round(instance["image_index"] + tick * instance["image_speed"]) % max(1, sprite["frame_count"])
                draw_sprite(canvas, renderer, sprite_id, instance["x"], instance["y"], instance["scale"], instance["rotation"], frame)
        elif layer_type == 1:
            bg = layer.get("background") or {}
            sprite_id = bg.get("sprite_id", -1)
            if bg.get("visible") and 0 <= sprite_id < len(renderer.sprites):
                draw_sprite(canvas, renderer, sprite_id, round(layer["offset"][0]), round(layer["offset"][1]), [1, 1], 0, round(bg.get("first_frame", 0)))
    output.parent.mkdir(parents=True, exist_ok=True)
    canvas.convert("RGB").save(output, format="PNG", optimize=False, compress_level=9)
    return {
        "room_id": room["id"], "room": room["name"], "season": season,
        "tick": tick, "output": str(output), "dimensions": [width, height],
        "season_vm_policy": "exact objstage tileset/visibility/static/object substitutions",
        "dynamic_particle_overlay": "not rasterized (objwinter logic preserved separately)",
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--extracted", type=Path, required=True)
    parser.add_argument("--room", required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--season", choices=SEASONS, default="spring")
    parser.add_argument("--tick", type=int, default=0)
    args = parser.parse_args()
    global_ir = read_json(args.extracted / "global-ir.json")
    room = next((row for row in global_ir["rooms"] if row["name"] == args.room or str(row["id"]) == args.room), None)
    if not room: raise ValueError(f"unknown room {args.room}")
    result = render_room(args.extracted, room, args.output, args.season, args.tick)
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__": raise SystemExit(main())
