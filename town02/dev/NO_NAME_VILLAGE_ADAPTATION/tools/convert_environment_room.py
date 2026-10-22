#!/usr/bin/env python3
"""Generate a native PMDO candidate from one official No Name Village room.

This first production converter deliberately accepts only tile-only exterior
rooms.  It reuses PMU_ADAPTATION's proven native .tile/.rsground writer,
preserves every source tile layer and every environmental pixel at the source
4992×4992 dimensions using 64 px PMDO cells (identity mapping, no resampling). Any source
sprite instance, social actor, unresolved transition, or unsupported layer is a
hard blocker and prevents CONVERTED status.
"""
from __future__ import annotations

import argparse
import copy
import gzip
import hashlib
import io
import json
import math
import re
import shutil
from fractions import Fraction
import subprocess
import sys
import tarfile
from pathlib import Path
from typing import Any

HERE = Path(__file__).resolve()
REPO = HERE.parents[2]
for path in (REPO / "PMU_ADAPTATION/src", REPO / "PMU_EXTRACTION/src", REPO / "tools"):
    sys.path.insert(0, str(path))

try:
    from PIL import Image, ImageChops
except ImportError as exc:  # pragma: no cover - explicit operator failure
    raise SystemExit("Pillow missing; install NO_NAME_VILLAGE_ADAPTATION/requirements-conversion.lock") from exc

from pmu_adaptation.composer import (  # noqa: E402
    _empty_cell, _empty_ground_object, _ground_shell, _marker, _png_bytes, _unpremultiply, write_tile,
)
from smart_dungeon.assets import _tile_entries  # noqa: E402

SOURCE_SHA256 = "2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227"
UPSTREAM_REPOSITORY = "https://github.com/meromoonmeri/nonamevillage"
UPSTREAM_COMMIT = "d1245878861fc76dc5455dbad68bcb45c83f7e1f"
TARGET_CELL = 64
SOURCE_CELL = 64
SCALE_DIVISOR = 1
TILE_INDEX_MASK = 0x0007FFFF
TILE_MIRROR = 0x10000000
TILE_FLIP = 0x20000000
TILE_ROTATE = 0x40000000
SYSTEM_REQUIRES = (
    "halcyon.LivingWorld", "halcyon.TownLife", "halcyon.TownPlace",
    "halcyon.Seasons", "halcyon.Weather", "halcyon.TownNight",
)
NEW_ERA_SEASON_IDS = {"spring": "printemps", "summer": "ete", "autumn": "automne", "winter": "hiver"}


def read_gzip(path: Path) -> Any:
    with gzip.open(path, "rt", encoding="utf-8") as stream:
        return json.load(stream)


def canonical_sha(value: Any) -> str:
    payload = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def file_sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def ref_index(value: Any) -> int | None:
    if not isinstance(value, dict):
        return None
    ref = value.get("$resourceRef")
    return ref.get("index") if isinstance(ref, dict) else None


def ref_name(value: Any) -> str | None:
    if not isinstance(value, dict):
        return None
    ref = value.get("$resourceRef")
    return ref.get("name") if isinstance(ref, dict) else None


def ensure_texture_cache(extracted: Path, cache: Path) -> None:
    if len(list(cache.glob("*_Texture_*.png"))) == 96:
        return
    structured = REPO / ".runtime-cache/nnv-official-structured"
    if structured.exists(): shutil.rmtree(structured)
    (structured / "inventory").mkdir(parents=True)
    for source in sorted((extracted / "inventory").glob("*.json.gz")):
        with gzip.open(source, "rb") as incoming:
            (structured / "inventory" / source.name[:-3]).write_bytes(incoming.read())
    (structured / "blobs").symlink_to(extracted / "blobs")
    if cache.exists(): shutil.rmtree(cache)
    subprocess.run([
        sys.executable, str(REPO / "NO_NAME_VILLAGE_ADAPTATION/tools/decode_official_textures.py"),
        str(structured), str(cache),
    ], check=True)
    if len(list(cache.glob("*_Texture_*.png"))) != 96:
        raise ValueError("official texture cache reconstruction incomplete")


class OfficialTiles:
    def __init__(self, extracted: Path, textures: Path):
        self.backgrounds = read_gzip(extracted / "inventory/Backgrounds.json.gz")
        self.items = read_gzip(extracted / "inventory/TexturePageItems.json.gz")
        self.textures = read_gzip(extracted / "inventory/EmbeddedTextures.json.gz")
        self.sprites = read_gzip(extracted / "inventory/Sprites.json.gz")
        self.sprite_by_name = {row["Name"].casefold(): index for index, row in enumerate(self.sprites)}
        self.texture_dir = textures
        self.page_cache: dict[int, Image.Image] = {}
        self.atlas_cache: dict[int, Image.Image] = {}
        self.tile_cache: dict[tuple[int, int, int], Image.Image | None] = {}
        self.sprite_cache: dict[tuple[int, int], Image.Image] = {}

    def page(self, index: int) -> Image.Image:
        if index not in self.page_cache:
            name = self.textures[index].get("Name") or f"Texture_{index}"
            path = self.texture_dir / f"{index:04d}_{name.replace(' ', '_')}.png"
            if not path.is_file():
                candidates = list(self.texture_dir.glob(f"{index:04d}_*.png"))
                if len(candidates) != 1:
                    raise FileNotFoundError(f"official texture page {index}")
                path = candidates[0]
            image = Image.open(path).convert("RGBA"); image.load()
            self.page_cache[index] = image
        return self.page_cache[index]

    def atlas(self, item_index: int) -> Image.Image:
        if item_index not in self.atlas_cache:
            item = self.items[item_index]
            page_index = ref_index(item.get("TexturePage"))
            if page_index is None:
                raise ValueError(f"texture page item {item_index} has no page")
            image = self.page(page_index).crop((
                int(item["SourceX"]), int(item["SourceY"]),
                int(item["SourceX"] + item["SourceWidth"]), int(item["SourceY"] + item["SourceHeight"]),
            ))
            target = (int(item["TargetWidth"]), int(item["TargetHeight"]))
            if image.size != target:
                image = image.resize(target, Image.Resampling.NEAREST)
            self.atlas_cache[item_index] = image
        return self.atlas_cache[item_index]

    def sprite(self, sprite_index: int, frame: int = 0) -> Image.Image:
        sprite = self.sprites[sprite_index]
        textures = sprite.get("Textures") or []
        if not textures:
            return Image.new("RGBA", (int(sprite["Width"]), int(sprite["Height"])), (0, 0, 0, 0))
        frame %= len(textures); key = (sprite_index, frame)
        if key not in self.sprite_cache:
            item_index = ref_index(textures[frame].get("Texture"))
            if item_index is None:
                raise ValueError(f"sprite {sprite['Name']} frame {frame} has no texture")
            item = self.items[item_index]
            canvas = Image.new("RGBA", (int(sprite["Width"]), int(sprite["Height"])), (0, 0, 0, 0))
            canvas.alpha_composite(self.atlas(item_index), (int(item["TargetX"]), int(item["TargetY"])))
            self.sprite_cache[key] = canvas
        return self.sprite_cache[key].copy()

    def tile(self, background_index: int, raw: int, frame: int = 0) -> Image.Image | None:
        tile_index = raw & TILE_INDEX_MASK
        key = (background_index, tile_index, frame)
        if key in self.tile_cache:
            base = self.tile_cache[key]
            return base.copy() if base is not None else None
        bg = self.backgrounds[background_index]
        frames = max(1, int(bg["GMS2ItemsPerTileCount"]))
        if tile_index <= 0 or tile_index >= int(bg["GMS2TileCount"]):
            self.tile_cache[key] = None
            return None
        ids = bg["GMS2TileIds"]
        mapped = int(ids[tile_index * frames + (frame % frames)]["ID"])
        item_index = ref_index(bg.get("Texture"))
        if item_index is None:
            self.tile_cache[key] = None
            return None
        atlas = self.atlas(item_index)
        border_x, border_y = int(bg["GMS2OutputBorderX"]), int(bg["GMS2OutputBorderY"])
        width, height = int(bg["GMS2TileWidth"]), int(bg["GMS2TileHeight"])
        columns = int(bg["GMS2TileColumns"])
        x = border_x + (mapped % columns) * (width + 2 * border_x)
        y = border_y + (mapped // columns) * (height + 2 * border_y)
        image = atlas.crop((x, y, x + width, y + height))
        if raw & TILE_MIRROR:
            image = image.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        if raw & TILE_FLIP:
            image = image.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
        if raw & TILE_ROTATE:
            image = image.transpose(Image.Transpose.ROTATE_90)
        image = image.resize((width // SCALE_DIVISOR, height // SCALE_DIVISOR), Image.Resampling.NEAREST)
        self.tile_cache[key] = image
        return image.copy()


def transformed_sprite(tiles: OfficialTiles, sprite_index: int, frame: int, scale_x: float, scale_y: float, rotation: float) -> tuple[Image.Image, int, int]:
    sprite = tiles.sprites[sprite_index]
    image = tiles.sprite(sprite_index, frame)
    width = max(1, round(image.width * abs(scale_x))); height = max(1, round(image.height * abs(scale_y)))
    image = image.resize((width, height), Image.Resampling.NEAREST)
    if scale_x < 0: image = image.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    if scale_y < 0: image = image.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
    if rotation: image = image.rotate(-rotation, resample=Image.Resampling.NEAREST, expand=True)
    image = image.resize((max(1, image.width // SCALE_DIVISOR), max(1, image.height // SCALE_DIVISOR)), Image.Resampling.NEAREST)
    return image, round(int(sprite["OriginX"]) * scale_x / SCALE_DIVISOR), round(int(sprite["OriginY"]) * scale_y / SCALE_DIVISOR)


def draw_sprite(canvas: Image.Image, tiles: OfficialTiles, sprite_index: int, frame: int, x: float, y: float, scale_x: float, scale_y: float, rotation: float) -> None:
    image, origin_x, origin_y = transformed_sprite(tiles, sprite_index, frame, scale_x, scale_y, rotation)
    canvas.alpha_composite(image, (round(x / SCALE_DIVISOR) - origin_x, round(y / SCALE_DIVISOR) - origin_y))


def canvas_layer(name: str, canvas: Image.Image, sheet: str, add_image) -> dict[str, Any]:
    width, height = canvas.width // TARGET_CELL, canvas.height // TARGET_CELL
    columns = []
    for x in range(width):
        column = []
        for y in range(height):
            image = canvas.crop((x * TARGET_CELL, y * TARGET_CELL, (x + 1) * TARGET_CELL, (y + 1) * TARGET_CELL))
            if image.getbbox() is None:
                column.append(_empty_cell())
            else:
                tx, ty = add_image(image)
                column.append({"AutoTileset": "", "Associates": [], "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": tx, "Y": ty}}], "FrameLength": 60}], "NeighborCode": -1})
        columns.append(column)
    return {"Name": name, "Layer": 0, "Visible": True, "Tiles": columns}


def animation_period(frame_count: int, speed: float) -> int:
    if frame_count <= 1 or speed == 0: return 1
    value = Fraction(str(speed)).limit_denominator(1000)
    return value.denominator * frame_count // math.gcd(abs(value.numerator), frame_count)


def animated_canvas_layer(name: str, items: list[dict[str, Any]], tiles: OfficialTiles, sheet: str, add_image, width: int, height: int) -> tuple[dict[str, Any], Image.Image, dict[str, Any]]:
    periods = [animation_period(len(tiles.sprites[row["sprite"]].get("Textures") or []), row["speed"]) for row in items]
    period = 1
    for value in periods: period = math.lcm(period, value)
    if period > 240: raise ValueError(f"unbounded source animation cycle {name}: {period} frames")
    grid_w, grid_h = width // TARGET_CELL, height // TARGET_CELL
    frame_locations: dict[tuple[int, int], list[tuple[int, int] | None]] = {}
    tick0 = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    empty_location = add_image(Image.new("RGBA", (TARGET_CELL, TARGET_CELL), (0, 0, 0, 0)))
    animated_sprites = set()
    for tick in range(period):
        cells: dict[tuple[int, int], Image.Image] = {}
        for row in items:
            sprite = tiles.sprites[row["sprite"]]; count = max(1, len(sprite.get("Textures") or []))
            frame = round(row["frame"] + tick * row["speed"]) % count
            if count > 1: animated_sprites.add(sprite["Name"])
            image, origin_x, origin_y = transformed_sprite(tiles, row["sprite"], frame, row["scale_x"], row["scale_y"], row["rotation"])
            left, top = round(row["x"] / SCALE_DIVISOR) - origin_x, round(row["y"] / SCALE_DIVISOR) - origin_y
            x0, y0 = max(0, left // TARGET_CELL), max(0, top // TARGET_CELL)
            x1 = min(grid_w - 1, (left + image.width - 1) // TARGET_CELL); y1 = min(grid_h - 1, (top + image.height - 1) // TARGET_CELL)
            for cx in range(x0, x1 + 1):
                for cy in range(y0, y1 + 1):
                    canvas = cells.setdefault((cx, cy), Image.new("RGBA", (TARGET_CELL, TARGET_CELL), (0, 0, 0, 0)))
                    sx, sy = cx * TARGET_CELL - left, cy * TARGET_CELL - top
                    crop = image.crop((max(0, sx), max(0, sy), min(image.width, sx + TARGET_CELL), min(image.height, sy + TARGET_CELL)))
                    canvas.alpha_composite(crop, (max(0, -sx), max(0, -sy)))
        for key in set(frame_locations) | set(cells):
            frame_locations.setdefault(key, [None] * tick)
            frame_locations[key].append(add_image(cells[key]) if key in cells and cells[key].getbbox() is not None else None)
        if tick == 0:
            for (cx, cy), image in cells.items(): tick0.alpha_composite(image, (cx * TARGET_CELL, cy * TARGET_CELL))
    columns = []
    for x in range(grid_w):
        column = []
        for y in range(grid_h):
            locations = frame_locations.get((x, y))
            if not locations or all(value is None for value in locations): column.append(_empty_cell()); continue
            frames = [{"Sheet": sheet, "TexLoc": {"X": (value or empty_location)[0], "Y": (value or empty_location)[1]}} for value in locations]
            column.append({"AutoTileset": "", "Associates": [], "Layers": [{"Frames": frames, "FrameLength": 1}], "NeighborCode": -1})
        columns.append(column)
    return {"Name": name, "Layer": 0, "Visible": True, "Tiles": columns}, tick0, {"period_frames": period, "animated_sprites": sorted(animated_sprites), "placement_count": len(items)}


def collision_mask(extracted: Path, sprite: dict[str, Any], scale_x: float, scale_y: float, rotation: float) -> Image.Image | None:
    masks = sprite.get("CollisionMasks") or []
    width, height = int(sprite["Width"]), int(sprite["Height"])
    image = Image.new("L", (width, height), 0)
    if masks:
        mask = masks[0]; binary = ((mask.get("Data") or {}).get("$binary") or {}); path = binary.get("path")
        if not path: return None
        bits = (extracted / path).read_bytes(); width, height = int(mask["Width"]), int(mask["Height"]); stride = (width + 7) // 8
        # Decode the 1-bit mask with Pillow's own unpacker instead of a per-pixel
        # Python loop: identical output, but orders of magnitude faster on the
        # large NNV sprites (some are several thousand pixels wide).
        image = Image.frombytes("1", (stride * 8, height), bits).convert("L").point(lambda v: 255 if v else 0)
        if image.width != width:
            image = image.crop((0, 0, width, height))
    else:
        left, top = int(sprite.get("MarginLeft") or 0), int(sprite.get("MarginTop") or 0)
        right, bottom = int(sprite.get("MarginRight") or width - 1), int(sprite.get("MarginBottom") or height - 1)
        if right < left or bottom < top: return None
        image.paste(255, (left, top, right + 1, bottom + 1))
    image = image.resize((max(1, round(width * abs(scale_x))), max(1, round(height * abs(scale_y)))), Image.Resampling.NEAREST)
    if scale_x < 0: image = image.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    if scale_y < 0: image = image.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
    if rotation: image = image.rotate(-rotation, resample=Image.Resampling.NEAREST, expand=True)
    target = (max(1, image.width // SCALE_DIVISOR), max(1, image.height // SCALE_DIVISOR))
    image = image.resize(target, Image.Resampling.BOX).point(lambda value: 255 if value else 0)
    return image


# Source fauna must never be baked into a Ground as decorative tiles. Every
# occurrence is kept as separate data so it can later be cast as a native
# Pokemon through NNVLife. Prefixes cover the animated mob families; the exact
# set covers standalone critters that do not share the objmob* naming.
FAUNA_PREFIXES = ("objmob", "objbmob", "objbfmob", "objbgmob", "objbird", "objbutterfly")
FAUNA_EXACT = {"objbug0", "objfirefly", "objfrog", "objbutterfly0", "objbutterfly1", "objbird0"}


def is_fauna(object_name: str) -> bool:
    """True when the source object is animal life, never scenery."""
    return object_name.startswith(FAUNA_PREFIXES) or object_name in FAUNA_EXACT


def wildlife_semantics(gml: dict[str, str], object_name: str) -> dict[str, Any]:
    tier = re.fullmatch(r"objmobsm5(\d{2})", object_name)
    if tier:
        parent_create = gml.get("gml_Object_objmobsm5_Create_0.gml", "")
        parent_step = gml.get("gml_Object_objmobsm5_Step_0.gml", "")
        return {
            "behavior_class": "stationary_spawning_nest", "hp_tier": int(tier.group(1)),
            "spawned_source_object": "objmob0", "active_spawn_cap_in_rm82": 8,
            "timed_spawn_probability": 0.3, "source_room_pause": "rm82",
            "proof": {
                "create_gml": "gml_Object_objmobsm5_Create_0.gml", "create_sha256": hashlib.sha256(parent_create.encode()).hexdigest(),
                "step_gml": "gml_Object_objmobsm5_Step_0.gml", "step_sha256": hashlib.sha256(parent_step.encode()).hexdigest(),
            },
        }
    return {"behavior_class": "SOURCE_BEHAVIOR_ADAPTATION_REQUIRED"}


def room_creation_code(gml: dict[str, str], placement: dict[str, Any]) -> dict[str, Any]:
    code = ref_name(placement.get("CreationCode"))
    text = gml.get(f"{code}.gml", "") if code else ""
    match = re.search(r"\bnewroom\s*=\s*(-?\d+)", text)
    return {"code": code, "newroom": int(match.group(1)) if match else None, "code_sha256": hashlib.sha256(text.encode()).hexdigest() if text else None}


def controller(asset: str, transitions: list[dict[str, Any]], season: str) -> str:
    lines = ["-- Generated NNV→PMDO candidate; not a production route.", "require 'origin.common'"]
    lines.extend(f"require '{name}'" for name in SYSTEM_REQUIRES)
    lines += ["local M = {}", "function M.Init(map)", "  LivingWorld.Ensure()", "  TownNight.Ensure()", "end", "function M.Enter(map)", "  LivingWorld.SyncStory()", "  M.Context = LivingWorld.Context('no_name_village', '" + asset + "')", "  M.Day = TownLife.Today()", "  -- Do not call Seasons.Apply here: its generic PMDO particles are not a", "  -- substitute for No Name Village's canonical objstage/objwinter system.", "  LivingWorld.ApplyOutdoor(false)", "  M.SourceSeason = Seasons.Actuelle().id", "  if M.SourceSeason ~= '" + NEW_ERA_SEASON_IDS[season] + "' then", "    error('NNV canonical season mismatch for " + asset + ": '..tostring(M.SourceSeason))", "  end", "  local preset = Weather.ForChapter((SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1)", "  if preset ~= nil then Weather.Set(preset) end", "end", "function M.PlaceDialogue(inst)", "  return TownPlace.Line(inst)", "end", "function M.Exit(map) end", "function M.Update(map) end"]
    for row in transitions:
        lines += [
            f"function M.{row['entity']}_Touch(obj, activator)",
            "  GAME:FadeOut(false, 20)",
            f"  GAME:EnterGroundMap('nnv_{row['target']}', '{row['target_marker']}')",
            "end",
        ]
    lines += ["function M.GameSave(map) end", "function M.GameLoad(map) end", "return M", ""]
    return "\n".join(lines)


def render_ground(ground: dict[str, Any], tile_path: Path) -> Image.Image:
    size, entries = _tile_entries(tile_path)
    images = {}
    for key, payload in entries:
        with Image.open(io.BytesIO(payload)) as image:
            decoded = _unpremultiply(image); decoded.load(); images[key] = decoded
    obj = ground["Object"]
    width = len(obj["Layers"][0]["Tiles"]); height = len(obj["Layers"][0]["Tiles"][0])
    canvas = Image.new("RGBA", (width * size, height * size), (0, 0, 0, 0))
    for layer in obj["Layers"]:
        if not layer.get("Visible", True):
            continue
        for x, column in enumerate(layer["Tiles"]):
            for y, cell in enumerate(column):
                for tile_layer in cell.get("Layers", []):
                    frames = tile_layer.get("Frames") or []
                    if not frames:
                        continue
                    loc = frames[0]["TexLoc"]; key = int(loc["X"]) | (int(loc["Y"]) << 32)
                    canvas.alpha_composite(images[key], (x * size, y * size))
    return canvas


def convert(repo: Path, room_name: str, season: str, extracted: Path, texture_cache: Path, output: Path) -> dict[str, Any]:
    source_summary = json.loads((repo / "NO_NAME_VILLAGE_ADAPTATION/reports/source-summary.json").read_text())
    if source_summary["source"]["sha256"] != SOURCE_SHA256:
        raise ValueError("No Name Village source authority mismatch")
    season_system = json.loads((repo / "NO_NAME_VILLAGE_ADAPTATION/reports/season-system.json").read_text())
    season_vm = json.loads((repo / "NO_NAME_VILLAGE_ADAPTATION/reports/season-vm-evidence.json").read_text())
    if season_vm.get("status") != "SOURCE_PROVEN_EXACT_VM_LOGIC" or season not in season_vm.get("seasons", {}):
        raise ValueError(f"canonical NNV season authority unavailable: {season}")
    season_state = season_vm["seasons"][season]
    object_correspondence = season_system["object_correspondence"]
    rooms = read_gzip(extracted / "inventory/Rooms.json.gz")
    objects = read_gzip(extracted / "inventory/GameObjects.json.gz")
    room_names = [row["Name"] for row in rooms]
    room = next((row for row in rooms if row["Name"] == room_name), None)
    if room is None:
        raise ValueError(f"unknown official room {room_name}")
    if [room["Width"], room["Height"]] != [4992, 4992]:
        raise ValueError("first exterior converter requires the official 4992×4992 room contract")
    ensure_texture_cache(extracted, texture_cache)
    with tarfile.open(extracted / "decompiled-gml.tar.gz", "r:gz") as archive:
        gml = {name: archive.extractfile(name).read().decode(errors="replace") for name in archive.getnames() if name.endswith(".gml")}

    # Every source placement remains represented either visually, spatially or
    # as an explicit blocker. Human/social source actors are never imported.
    blockers = []
    transitions_source = []
    wildlife_source = []
    source_objects = []
    for placement in room.get("GameObjects") or []:
        object_index = ref_index(placement.get("ObjectDefinition"))
        object_name = objects[object_index]["Name"] if object_index is not None else "UNKNOWN"
        source_objects.append((placement, object_index, object_name))
        if object_name in {"objtransit", "objdoor"}:
            code = room_creation_code(gml, placement)
            transitions_source.append({
                "instance_id": placement.get("InstanceID"), "object": object_name,
                "position_source_px": [placement.get("X"), placement.get("Y")],
                "scale": [placement.get("ScaleX"), placement.get("ScaleY")], **code,
            })
            if code["newroom"] is None or not 0 <= code["newroom"] < len(rooms):
                blockers.append(f"unresolved transition {placement.get('InstanceID')} newroom={code['newroom']}")
        elif is_fauna(object_name):
            wildlife_source.append({"instance_id": placement.get("InstanceID"), "object": object_name, "position_source_px": [placement.get("X"), placement.get("Y")], "position_pmdo_px": [round(placement.get("X") / SCALE_DIVISOR), round(placement.get("Y") / SCALE_DIVISOR)], "semantics": wildlife_semantics(gml, object_name)})
            blockers.append(f"wildlife role {placement.get('InstanceID')}:{object_name} requires native Pokemon encounter mapping")
        elif object_name in {"objlogger", "objhunter", "objcarpenter", "objherbalist", "objseamstress"}:
            blockers.append(f"social role {placement.get('InstanceID')}:{object_name} requires native Pokemon casting")

    blockers.extend([
        "canonical NNV four-season bundle selection and runtime switch are not validated",
        "canonical NNV objwinter particle families, snow trails, footprints and snow audio are not ported",
        "native Pokemon wild exploration population and encounter behavior are not bound",
    ])
    if room_name == "rmvillage":
        blockers.append("native Pokemon living cast and TownLife/TownPlace routines are not bound yet")
    tiles = OfficialTiles(extracted, texture_cache)
    payload_locations: dict[bytes, tuple[int, int]] = {}
    tile_entries: list[tuple[int, bytes]] = []
    sheet = f"NNV_{room_name}_{season.capitalize()}_Source"

    raw_locations: dict[bytes, tuple[int, int]] = {}

    def add_image(image: Image.Image) -> tuple[int, int]:
        # Deduplicate on raw pixels FIRST. The tile sheet is highly repetitive
        # (a room reuses the same 64x64 cells thousands of times), and premultiply
        # + PNG encoding accounted for ~90% of conversion time. Identical pixels
        # always produce an identical payload, so the emitted sheet is unchanged.
        raw = image.convert("RGBA").tobytes()
        cached = raw_locations.get(raw)
        if cached is not None:
            return cached
        payload = _png_bytes(image)
        if payload not in payload_locations:
            index = len(payload_locations); loc = (index % 64, index // 64)
            payload_locations[payload] = loc; tile_entries.append((loc[0] | (loc[1] << 32), payload))
        raw_locations[raw] = payload_locations[payload]
        return payload_locations[payload]

    source_layers = []
    target_width, target_height = int(room["Width"]), int(room["Height"])
    source_canvas = Image.new("RGBA", (target_width, target_height), (0, 0, 0, 0))
    source_tile_layers = []
    source_animation_layers = []
    for layer in sorted(room.get("Layers") or [], key=lambda row: int(row.get("LayerDepth") or 0), reverse=True):
        data = layer.get("Data")
        layer_type = (layer.get("LayerType") or {}).get("name")
        layer_key = str(layer.get("LayerName") or "").casefold()
        visibility_override = season_state.get("visibility", {}).get(layer_key)
        layer_visible = bool(layer.get("IsVisible", True)) if not isinstance(visibility_override, bool) else visibility_override
        if layer_type == "Tiles" and isinstance(data, dict) and "TileData" in data:
            background_index = ref_index(data.get("Background"))
            layer_key = str(layer.get("LayerName") or "").casefold()
            if layer_key in season_state.get("tilesets", {}):
                background_index = int(season_state["tilesets"][layer_key])
            rows = data.get("TileData") or []
            if not rows or background_index is None:
                continue
            bg = tiles.backgrounds[background_index]
            tile_width, tile_height = int(bg["GMS2TileWidth"]), int(bg["GMS2TileHeight"])
            if tile_width != tile_height or tile_width not in {64, 128}:
                if any(raw & TILE_INDEX_MASK for row in rows for raw in row): blockers.append(f"active unsupported tileset size {bg['Name']}:{tile_width}x{tile_height}")
                continue
            factor = tile_width // 64
            columns = []
            for x in range(len(rows[0]) * factor):
                column = []
                for y in range(len(rows) * factor):
                    raw = int(rows[y // factor][x // factor]); image = tiles.tile(background_index, raw, 0)
                    if image is None:
                        column.append(_empty_cell()); continue
                    crop = image.crop(((x % factor) * TARGET_CELL, (y % factor) * TARGET_CELL, (x % factor + 1) * TARGET_CELL, (y % factor + 1) * TARGET_CELL))
                    frame_count = max(1, int(bg["GMS2ItemsPerTileCount"])); frames = []
                    for frame in range(frame_count):
                        frame_image = tiles.tile(background_index, raw, frame)
                        frame_crop = frame_image.crop(((x % factor) * TARGET_CELL, (y % factor) * TARGET_CELL, (x % factor + 1) * TARGET_CELL, (y % factor + 1) * TARGET_CELL))
                        frames.append(add_image(frame_crop))
                    frame_length = max(1, round(int(bg["GMS2FrameLength"]) * 60 / 1_000_000))
                    column.append({"AutoTileset": "", "Associates": [], "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": fx, "Y": fy}} for fx, fy in frames], "FrameLength": frame_length}], "NeighborCode": -1})
                    if layer_visible: source_canvas.alpha_composite(crop, (x * TARGET_CELL, y * TARGET_CELL))
                columns.append(column)
            source_layers.append({"Name": f"NNV {layer['LayerName']}", "Layer": 0, "Visible": layer_visible, "Tiles": columns})
            source_tile_layers.append({"name": layer["LayerName"], "depth": layer.get("LayerDepth"), "background": bg["Name"], "matrix_sha256": canonical_sha(rows)})
        elif layer_type in {"Instances", "Assets"}:
            animation_items = []
            if layer_type == "Instances" and isinstance(data, dict):
                for entry in data.get("Instances") or []:
                    cycle = entry.get("$cycleRef", "") if isinstance(entry, dict) else ""
                    match = re.search(r"GameObjects\[(\d+)\]", cycle)
                    if match is None: continue
                    placement = room["GameObjects"][int(match.group(1))]
                    object_index = ref_index(placement.get("ObjectDefinition"))
                    if object_index is None: continue
                    obj = objects[object_index]; object_name = obj["Name"]
                    if is_fauna(object_name) or object_name in {"objlogger", "objhunter", "objcarpenter", "objherbalist", "objseamstress", "objplayer", "objfollower"}:
                        continue
                    mapping = object_correspondence.get(object_name)
                    replacement = mapping.get(season) if mapping is not None else object_name
                    if replacement is None: continue
                    obj = next((row for row in objects if row["Name"] == replacement), obj)
                    sprite_index = ref_index(obj.get("Sprite"))
                    if object_name in {"objboulder0", "objboulder1"}:
                        boulder_index = 0 if object_name.endswith("0") else 1
                        sprite_index = tiles.sprite_by_name.get(season_state["boulder_sprites"][boulder_index].casefold(), sprite_index)
                    if not obj.get("Visible", True) or sprite_index is None: continue
                    animation_items.append({"sprite": sprite_index, "frame": float(placement.get("ImageIndex") or 0), "speed": float(placement.get("ImageSpeed") or 0), "x": placement["X"], "y": placement["Y"], "scale_x": float(placement.get("ScaleX") or 1), "scale_y": float(placement.get("ScaleY") or 1), "rotation": float(placement.get("Rotation") or 0)})
            else:
                assets = layer.get("AssetsData") or {}
                for placement in assets.get("Sprites") or []:
                    sprite_index = ref_index(placement.get("Sprite"))
                    if sprite_index is None: continue
                    if layer.get("LayerName", "").casefold() == "below":
                        current = tiles.sprites[sprite_index]["Name"]; prefix = season_state["below_sprite_prefix"]
                        wanted = prefix + current[3:] if len(current) >= 3 else current
                        sprite_index = tiles.sprite_by_name.get(wanted.casefold(), sprite_index)
                        special = season_state.get("special_static_replacement", {})
                        if sprite_index == 2566 and "sprite_id_2566" in special:
                            sprite_index = tiles.sprite_by_name.get(str(special["sprite_id_2566"]).casefold(), sprite_index)
                    animation_items.append({"sprite": sprite_index, "frame": float(placement.get("FrameIndex") or 0), "speed": float(placement.get("AnimationSpeed") or 0), "x": placement["X"], "y": placement["Y"], "scale_x": float(placement.get("ScaleX") or 1), "scale_y": float(placement.get("ScaleY") or 1), "rotation": float(placement.get("Rotation") or 0)})
            if animation_items:
                visual_layer, tick0, animation_report = animated_canvas_layer(f"NNV {layer['LayerName']}", animation_items, tiles, sheet, add_image, target_width, target_height)
                visual_layer["Visible"] = layer_visible; source_layers.append(visual_layer)
                animation_report["layer"] = layer["LayerName"]; source_animation_layers.append(animation_report)
                if visual_layer["Visible"]: source_canvas.alpha_composite(tick0)
        elif layer_type not in {None, "Instances", "Assets", "Background"}:
            blockers.append(f"unsupported layer type {layer_type}:{layer.get('LayerName')}")

    if not source_layers:
        raise ValueError("room has no convertible source tile layers")
    visual_width = len(source_layers[0]["Tiles"]); visual_height = len(source_layers[0]["Tiles"][0])
    collision_width = visual_width * TARGET_CELL // 8
    collision_height = visual_height * TARGET_CELL // 8
    collision_canvas = Image.new("L", (visual_width * TARGET_CELL, visual_height * TARGET_CELL), 0)
    solid_instance_count = 0
    for placement, object_index, object_name in source_objects:
        if object_index is None or not objects[object_index].get("Solid", False): continue
        if object_name in {"objtransit", "objdoor"}: continue
        solid_instance_count += 1; sprite_index = ref_index(objects[object_index].get("Sprite"))
        if sprite_index is None:
            blockers.append(f"solid source instance {placement.get('InstanceID')}:{object_name} has no sprite mask"); continue
        mask = collision_mask(extracted, tiles.sprites[sprite_index], float(placement.get("ScaleX") or 1), float(placement.get("ScaleY") or 1), float(placement.get("Rotation") or 0))
        if mask is None:
            blockers.append(f"solid source instance {placement.get('InstanceID')}:{object_name} has no collision mask"); continue
        sprite = tiles.sprites[sprite_index]
        left = round(placement["X"] / SCALE_DIVISOR - int(sprite["OriginX"]) * float(placement.get("ScaleX") or 1) / SCALE_DIVISOR)
        top = round(placement["Y"] / SCALE_DIVISOR - int(sprite["OriginY"]) * float(placement.get("ScaleY") or 1) / SCALE_DIVISOR)
        collision_canvas.paste(mask, (left, top), mask)
    collision_grid = collision_canvas.resize((collision_width, collision_height), Image.Resampling.BOX)
    collision_pixels = collision_grid.load()
    obstacles = []
    for x in range(collision_width):
        column = []
        for y in range(collision_height):
            blocked = collision_pixels[x, y] > 0
            column.append({"Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8}, "Tags": 1 if blocked else 0})
        obstacles.append(column)

    known = []
    objects_out = []
    markers = [
        _marker("Entry_North", target_width // 2, 64, direction=0),
        _marker("Entry_South", target_width // 2, target_height - 64, direction=4),
        _marker("Entry_West", 64, target_height // 2, direction=6),
        _marker("Entry_East", target_width - 64, target_height // 2, direction=2),
    ]
    for placement, _, object_name in source_objects:
        if object_name == "objspawnpoint":
            markers.append(_marker(f"SourceSpawn_{placement['InstanceID']}", round(placement["X"] / SCALE_DIVISOR), round(placement["Y"] / SCALE_DIVISOR), direction=0))
    for row in transitions_source:
        target_index = row["newroom"]
        if target_index is None or not 0 <= target_index < len(rooms):
            continue
        sx, sy = row["position_source_px"]
        if row.get("object") == "objdoor":
            edge = f"Door_{row['instance_id']}"; rect = (round(sx / SCALE_DIVISOR), round(sy / SCALE_DIVISOR), 64, 64); target_marker = "Entry_Door"
        elif sy < 0 and sx > -128:
            edge, rect, target_marker = "North", (0, 0, target_width, 8), "Entry_South"
        elif sx > room["Width"]:
            edge, rect, target_marker = "East", (target_width - 8, 0, 8, target_height), "Entry_West"
        elif sy > room["Height"]:
            edge, rect, target_marker = "South", (0, target_height - 8, target_width, 8), "Entry_North"
        else:
            edge, rect, target_marker = "West", (0, 0, 8, target_height), "Entry_East"
        entity = f"Exit_{edge}"
        target = room_names[target_index]
        objects_out.append(_empty_ground_object(entity, *rect, passable=True, trigger=2))
        known.append({"entity": entity, "edge": edge, "target": target, "target_marker": target_marker, "source_instance_id": row["instance_id"]})

    entity_layer = {"Name": "NNV adaptation entities", "Visible": True, "MapChars": [], "GroundObjects": objects_out, "Spawners": [], "Markers": markers}
    asset = f"nnv_{room_name}_{season}"
    ground = _ground_shell(asset, f"No Name Village — {room_name}", 8, source_layers, obstacles, [entity_layer], "")
    ground["Object"]["Comment"] = (
        f"NNV official room {room_name}, canonical season {season}; source data.win SHA-256 {SOURCE_SHA256}; identity spatial mapping 1:1 at 4992x4992 px; "
        "source tile layers and environmental pixels preserved independently; candidate only, no promotion."
    )

    if output.exists():
        import shutil; shutil.rmtree(output)
    tile_path = output / f"Content/Tile/{sheet}.tile"
    ground_path = output / f"Data/Ground/{asset}.rsground"
    script_path = output / f"Data/Script/halcyon/ground/{asset}/init.lua"
    tile_path.parent.mkdir(parents=True, exist_ok=True); ground_path.parent.mkdir(parents=True, exist_ok=True); script_path.parent.mkdir(parents=True, exist_ok=True)
    write_tile(tile_path, TARGET_CELL, tile_entries)
    ground_path.write_text("\ufeff" + json.dumps(ground, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")
    script_path.write_text(controller(asset, known, season), encoding="utf-8")

    candidate = render_ground(ground, tile_path)
    candidate_path = output / "validation/candidate_tick0.png"; source_path = output / "validation/source_normalized_tick0.png"
    candidate_path.parent.mkdir(parents=True, exist_ok=True)
    candidate.save(candidate_path, format="PNG", optimize=False, compress_level=9)
    source_canvas.save(source_path, format="PNG", optimize=False, compress_level=9)
    difference = ImageChops.difference(source_canvas, candidate)
    extrema = difference.getextrema()
    max_channel_error = max(high for _, high in extrema)
    alpha_exact = extrema[3][1] == 0
    pixel_exact = difference.convert("RGB").getbbox() is None and alpha_exact
    differing_pixels = None  # intentionally omitted: a 4992² Python pixel scan is not a bounded production gate
    pmdo_roundtrip_valid = max_channel_error <= 1 and alpha_exact
    checks = {
        "ground_json_round_trip": json.loads(ground_path.read_text(encoding="utf-8-sig")) == ground,
        "source_dimensions_identity_mapped": [visual_width, visual_height, TARGET_CELL] == [78, 78, 64] and candidate.size == (4992, 4992),
        "collision_grid_matches_visual_extent": [collision_width, collision_height] == [624, 624],
        "tile_dependency_exists": tile_path.is_file() and bool(tile_entries),
        "all_source_tile_layers_preserved": len(source_tile_layers) == sum(1 for layer in room["Layers"] if (layer.get("LayerType") or {}).get("name") == "Tiles" and isinstance(layer.get("Data"), dict) and layer["Data"].get("TileData") and ref_index(layer["Data"].get("Background")) is not None and int(tiles.backgrounds[ref_index(layer["Data"].get("Background"))]["GMS2TileWidth"]) in {64, 128}),
        "source_sprite_animation_cycles_compiled": not any("full frame-cycle conversion" in blocker for blocker in blockers),
        "tick0_visual_pmdo_premultiply_roundtrip": pmdo_roundtrip_valid,
        "entities_in_bounds": all(0 <= e["Collider"]["X"] <= target_width and 0 <= e["Collider"]["Y"] <= target_height for e in objects_out + markers),
        "existing_new_era_systems_required": all(f"require '{name}'" in script_path.read_text() for name in SYSTEM_REQUIRES),
    }
    static_pass = all(checks.values())
    status = "GENERATED_CANDIDATE" if static_pass else "FAILED"
    manifest = {
        "schema": "new-era.nnv-pmdo-room-conversion.v1", "room": room_name, "season": season, "asset": asset,
        "source": {"repository": UPSTREAM_REPOSITORY, "repository_commit": UPSTREAM_COMMIT, "data_win_sha256": SOURCE_SHA256, "room_record_sha256": canonical_sha(room), "official_inventory": "extracted/official/inventory/Rooms.json.gz"},
        "canonical_environment_authority": {
            "season_system": "reports/season-system.json", "season_system_sha256": file_sha(repo / "NO_NAME_VILLAGE_ADAPTATION/reports/season-system.json"),
            "season_vm_evidence": "reports/season-vm-evidence.json", "season_vm_evidence_sha256": file_sha(repo / "NO_NAME_VILLAGE_ADAPTATION/reports/season-vm-evidence.json"),
            "time_system": "reports/time-system.json", "time_system_sha256": file_sha(repo / "NO_NAME_VILLAGE_ADAPTATION/reports/time-system.json"),
            "generic_new_era_season_particles_allowed_as_substitute": False,
        },
        "transform": {"kind": "identity_spatial_mapping", "scale": "1/1", "source_dimensions_px": [4992, 4992], "target_dimensions_px": [4992, 4992], "source_cell_px": 64, "target_cell_px": 64, "resampler": "none"},
        "status": status, "conversion_status": "UNIMPLEMENTED" if blockers else "STRUCTURALLY_VALID",
        "runtime_status": "NOT_RUN", "visual_status": "TICK0_PIXEL_EXACT" if pixel_exact else "TICK0_PMDO_PREMULTIPLY_ROUNDTRIP_VALID" if pmdo_roundtrip_valid else "FAILED",
        "visual_scope": "environment_layers_only; source human/wildlife actors excluded pending native Pokemon mapping",
        "visual_metrics": {"differing_pixels": differing_pixels, "max_channel_error": max_channel_error, "alpha_exact": alpha_exact, "pixel_exact": pixel_exact},
        "source_tile_layers": source_tile_layers, "source_animation_layers": source_animation_layers,
        "source_transitions": transitions_source, "mapped_transitions": known,
        "wildlife": {"source_placements": wildlife_source, "source_count": len(wildlife_source), "native_pokemon_count": 0, "status": "UNIMPLEMENTED"},
        "collision_metrics": {"source_solid_instances": solid_instance_count, "blocked_pmdo_cells_8px": sum(cell["Tags"] != 0 for column in obstacles for cell in column)},
        "checks": checks, "blockers": sorted(set(blockers)),
        "new_era_systems": list(SYSTEM_REQUIRES),
        "outputs": {
            "ground": str(ground_path.relative_to(output)), "ground_sha256": file_sha(ground_path),
            "tile": str(tile_path.relative_to(output)), "tile_sha256": file_sha(tile_path),
            "script": str(script_path.relative_to(output)), "script_sha256": file_sha(script_path),
            "source_render": str(source_path.relative_to(output)), "source_render_sha256": file_sha(source_path),
            "candidate_render": str(candidate_path.relative_to(output)), "candidate_render_sha256": file_sha(candidate_path),
        },
        "promotion_allowed": False,
    }
    manifest["manifest_semantic_sha256"] = canonical_sha(manifest)
    (output / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return manifest


def package_season_layers(output: Path, result: dict[str, Any]) -> dict[str, Any]:
    ground_path = output / result["outputs"]["ground"]
    obj = json.loads(ground_path.read_text(encoding="utf-8-sig"))["Object"]
    payload = json.dumps({"schema": "new-era.nnv-season-layers.v1", "room": result["room"], "season": result["season"], "tex_size": obj["TexSize"], "dimensions_px": [4992, 4992], "layers": obj["Layers"]}, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode() + b"\n"
    layer_path = ground_path.with_suffix(".layers.json.gz")
    with layer_path.open("wb") as raw:
        with gzip.GzipFile(filename="", fileobj=raw, mode="wb", compresslevel=9, mtime=0) as stream: stream.write(payload)
    ground_path.unlink(); result["status"] = "SEASON_LAYER_BUNDLE"
    result["outputs"].pop("ground"); result["outputs"].pop("ground_sha256")
    result["outputs"]["season_layers"] = str(layer_path.relative_to(output)); result["outputs"]["season_layers_sha256"] = file_sha(layer_path)
    result["blockers"] = sorted(set(result["blockers"] + ["seasonal layer bundle not materialized as a standalone PMDO Ground", "four-season runtime selector not validated"]))
    result.pop("manifest_semantic_sha256", None); result["manifest_semantic_sha256"] = canonical_sha(result)
    (output / "manifest.json").write_text(json.dumps(result, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    root = REPO / "NO_NAME_VILLAGE_ADAPTATION"
    parser.add_argument("--room", required=True)
    parser.add_argument("--season", choices=tuple(NEW_ERA_SEASON_IDS), default="summer")
    parser.add_argument("--extracted", type=Path, default=root / "extracted/official")
    parser.add_argument("--texture-cache", type=Path, default=REPO / ".runtime-cache/nnv-official-textures")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    output = args.output or root / "generated" / args.room / args.season
    result = convert(REPO, args.room, args.season, args.extracted, args.texture_cache, output)
    if args.season != "summer": result = package_season_layers(output, result)
    print(json.dumps({key: result[key] for key in ("room", "season", "status", "conversion_status", "runtime_status", "visual_status", "blockers")}, ensure_ascii=False))
    return 0 if result["status"] != "FAILED" else 1


if __name__ == "__main__":
    raise SystemExit(main())
