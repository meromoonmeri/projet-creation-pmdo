#!/usr/bin/env python3
"""Virtual removal probe: what is UNDER the four rmvillage house structures?

Question answered here, and nothing more:

    If the NNV house structure is removed, does valid NNV ground already exist
    underneath, or does removal reveal black / empty / missing tiles?

This is a READ-ONLY probe. It never writes into `Data/`, never edits a tracked
Ground, never creates a tile, never reconstructs a house and never substitutes
PMU terrain. It renders control images from the already-generated NNV season
Ground so the answer can be seen as well as measured.

Method:
  * read the generated season Ground (`.rsground`, authored 1:1 from source);
  * read its companion `.tile` sheet with the project's native reader format;
  * classify every layer as GROUND / STRUCTURE / OTHER from the source layer
    semantics proved in the official Rooms inventory;
  * composite the same window twice: once with every visible layer, once with
    the structure-carrying layers suppressed;
  * measure real opaque coverage of the "structure removed" image, so an empty
    or black hole cannot hide behind a plausible-looking render.

Layer roles come from the source room, not from guesswork:
  `ground`, `groundtex`, `grass0`, `grass1` are the terrain bed;
  `HouseBelow` / `sHouseBelow` carry the house structures;
  everything else (trees, plants, cliff, vegetation, instances) is other NNV
  content that must stay untouched.
"""
from __future__ import annotations

import argparse
import io
import json
import struct
from pathlib import Path

from PIL import Image

REPO = Path(__file__).resolve().parents[2]
GENERATED = REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage"

# Source-proved anchors (reports/room-index.json, rmvillage id 7) combined with
# the sprite trim offsets from the official frames manifest. Origin is (0,0) for
# all four house sprites, so anchor == canvas top-left.
HOUSES = {
    "objplayerhouse": {"anchor": (-64, 2816), "trim": (352, 48), "size": (1200, 984), "sprite": "splayerhouse", "door": 106508},
    "objloggerhouse": {"anchor": (704, 1344), "trim": (108, 56), "size": (948, 840), "sprite": "sloggerhouse", "door": 106510},
    "objhunterhouse": {"anchor": (3712, 1472), "trim": (108, 180), "size": (948, 856), "sprite": "shunterhouse", "door": 106509},
    "objcarpenterhouse": {"anchor": (1216, -128), "trim": (108, 180), "size": (1192, 728), "sprite": "scarpenterhouse", "door": 106511},
}

GROUND_LAYERS = {"NNV ground", "NNV groundtex", "NNV grass0", "NNV grass1"}
STRUCTURE_LAYERS = {"NNV HouseBelow", "NNV sHouseBelow"}
CELL = 64  # convert_environment_room.py TARGET_CELL
GRID = 78


def read_tile_sheet(path: Path) -> tuple[int, dict[int, Image.Image]]:
    """Read the native PMDO .tile container written by PMU_ADAPTATION.write_tile."""
    raw = path.read_bytes()
    tile_size, count = struct.unpack_from("<II", raw, 0)
    keys: list[tuple[int, int]] = []
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        keys.append((key, offset))
    images: dict[int, Image.Image] = {}
    for key, offset in keys:
        (length,) = struct.unpack_from("<Q", raw, offset)
        payload = raw[offset + 8 : offset + 8 + length]
        images[key] = Image.open(io.BytesIO(payload)).convert("RGBA")
    return tile_size, images


def unpremultiply(image: Image.Image) -> Image.Image:
    """The writer stores premultiplied alpha; undo it for honest inspection."""
    pixels = image.load()
    width, height = image.size
    out = Image.new("RGBA", (width, height))
    target = out.load()
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if a == 0:
                target[x, y] = (0, 0, 0, 0)
            else:
                target[x, y] = (min(255, r * 255 // a), min(255, g * 255 // a), min(255, b * 255 // a), a)
    return out


def tex_key(x: int, y: int) -> int:
    return (y << 32) | x


def composite(layers, sheets, x0, y0, width, height, skip: set[str]) -> Image.Image:
    canvas = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    for layer in layers:
        if not layer.get("Visible"):
            continue
        if layer["Name"] in skip:
            continue
        tiles = layer["Tiles"]
        columns = len(tiles)
        scale = GRID // columns
        cell = CELL * scale
        for cx in range(max(0, x0 // cell), min(columns, (x0 + width - 1) // cell + 1)):
            for cy in range(max(0, y0 // cell), min(len(tiles[0]), (y0 + height - 1) // cell + 1)):
                entry = tiles[cx][cy]
                stack = entry.get("Layers") or []
                if not stack:
                    continue
                frames = stack[0].get("Frames") or []
                if not frames:
                    continue
                frame = frames[0]
                sheet_name = frame["Sheet"]
                if sheet_name not in sheets:
                    continue
                tile_size, images = sheets[sheet_name]
                loc = frame["TexLoc"]
                block = images.get(tex_key(loc["X"], loc["Y"]))
                if block is None:
                    continue
                canvas.alpha_composite(block, (cx * cell - x0, cy * cell - y0))
    return canvas


def coverage(image: Image.Image) -> dict:
    alpha = image.getchannel("A")
    data = list(alpha.get_flattened_data()) if hasattr(alpha, "get_flattened_data") else list(alpha.getdata())
    total = len(data)
    opaque = sum(1 for value in data if value > 0)
    rgb = image.convert("RGB")
    pixels = list(rgb.get_flattened_data()) if hasattr(rgb, "get_flattened_data") else list(rgb.getdata())
    black = sum(1 for index, value in enumerate(data) if value > 0 and pixels[index] == (0, 0, 0))
    return {
        "pixels": total,
        "opaque_pixels": opaque,
        "transparent_pixels": total - opaque,
        "opaque_black_pixels": black,
        "coverage_percent": round(100.0 * opaque / total, 4) if total else 0.0,
        "black_percent": round(100.0 * black / total, 4) if total else 0.0,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--season", default="summer")
    parser.add_argument("--out", type=Path, default=REPO / "NO_NAME_VILLAGE_ADAPTATION/reports/house-removal-probe")
    parser.add_argument("--margin", type=int, default=128)
    arguments = parser.parse_args()

    ground_path = GENERATED / arguments.season / f"Data/Ground/nnv_rmvillage_{arguments.season}.rsground"
    document = json.loads(ground_path.read_text(encoding="utf-8-sig"))
    obj = document["Object"]
    layers = obj["Layers"]

    obstacles = obj["obstacles"]
    door_by_instance = {
        entity["EntName"]: entity["Collider"]
        for entity in obj["Entities"][0]["GroundObjects"]
    }

    sheets: dict[str, tuple[int, dict[int, Image.Image]]] = {}
    for tile_path in (GENERATED / arguments.season / "Content/Tile").glob("*.tile"):
        size, images = read_tile_sheet(tile_path)
        sheets[tile_path.stem] = (size, {key: unpremultiply(value) for key, value in images.items()})

    arguments.out.mkdir(parents=True, exist_ok=True)
    results = []
    for name, meta in HOUSES.items():
        ax, ay = meta["anchor"]
        tx, ty = meta["trim"]
        width, height = meta["size"]
        x0, y0 = ax + tx, ay + ty

        # Per-cell terrain presence over the exact structural footprint.
        cell_stats = {}
        for layer in layers:
            if layer["Name"] not in GROUND_LAYERS:
                continue
            tiles = layer["Tiles"]
            columns = len(tiles)
            scale = GRID // columns
            cell = CELL * scale
            total = filled = 0
            for cx in range(x0 // cell, (x0 + width - 1) // cell + 1):
                for cy in range(y0 // cell, (y0 + height - 1) // cell + 1):
                    if not (0 <= cx < columns and 0 <= cy < len(tiles[0])):
                        continue
                    total += 1
                    entry = tiles[cx][cy]
                    stack = entry.get("Layers") or []
                    if stack and (stack[0].get("Frames") or []):
                        filled += 1
            cell_stats[layer["Name"]] = {
                "cell_px": cell,
                "cells_examined": total,
                "cells_with_tile": filled,
                "percent": round(100.0 * filled / total, 2) if total else 0.0,
            }

        vx0 = max(0, x0 - arguments.margin)
        vy0 = max(0, y0 - arguments.margin)
        vw = width + arguments.margin * 2
        vh = height + arguments.margin * 2

        intact = composite(layers, sheets, vx0, vy0, vw, vh, skip=set())
        removed = composite(layers, sheets, vx0, vy0, vw, vh, skip=STRUCTURE_LAYERS)
        terrain_only = composite(
            layers, sheets, vx0, vy0, vw, vh,
            skip={layer["Name"] for layer in layers if layer["Name"] not in GROUND_LAYERS},
        )

        intact.save(arguments.out / f"{name}_1_intact.png")
        removed.save(arguments.out / f"{name}_2_structure_removed.png")
        terrain_only.save(arguments.out / f"{name}_3_terrain_only.png")

        # Coverage measured strictly over the structural footprint window.
        crop = (arguments.margin, arguments.margin, arguments.margin + width, arguments.margin + height)
        removed_stats = coverage(removed.crop(crop))
        terrain_stats = coverage(terrain_only.crop(crop))

        ground_percent = cell_stats.get("NNV ground", {}).get("percent", 0.0)
        if terrain_stats["coverage_percent"] >= 99.99 and terrain_stats["black_percent"] < 0.01:
            result = "GROUND_ALREADY_PRESENT"
        elif terrain_stats["coverage_percent"] > 0:
            result = "PARTIAL_GROUND"
        else:
            result = "NO_GROUND_BLACK"

        blocked = examined = 0
        for cx in range(x0 // 8, (x0 + width - 1) // 8 + 1):
            for cy in range(y0 // 8, (y0 + height - 1) // 8 + 1):
                if 0 <= cx < len(obstacles) and 0 <= cy < len(obstacles[0]):
                    examined += 1
                    if obstacles[cx][cy]["Tags"] != 0:
                        blocked += 1

        door_name = f"Exit_Door_{meta['door']}"
        door = door_by_instance.get(door_name)

        results.append({
            "structure_id": name,
            "sprite": meta["sprite"],
            "collision": {
                "grid": "624x624 cells of 8 px",
                "cells_under_structure": examined,
                "blocked_cells": blocked,
                "blocked_percent": round(100.0 * blocked / examined, 2) if examined else 0.0,
                "note": "collision is authored from the source solid mask; replacing the structure "
                        "requires re-deriving these cells from the replacement, never reusing them blindly",
            },
            "entry": {
                "door_entity": door_name,
                "door_collider": door,
                "independent_of_structure_sprite": True,
                "note": "the door is a separate GroundObject entity and survives structure removal; "
                        "it is the NNV entry anchor a replacement must line up with",
            },
            "position": {"anchor_source_px": [ax, ay], "structure_origin_px": [x0, y0]},
            "structure_perimeter": {
                "width_px": width, "height_px": height,
                "trim_offset_px": [tx, ty],
                "note": "sprite pixels only; surrounding terrain, trees, roads and empty space are NNV data",
            },
            "underlying_ground_present": ground_percent >= 100.0,
            "underlying_ground_tiles": cell_stats,
            "black_or_empty_tiles_after_removal": {
                "transparent_pixels": terrain_stats["transparent_pixels"],
                "opaque_black_pixels": terrain_stats["opaque_black_pixels"],
            },
            "terrain_coverage_percent": terrain_stats["coverage_percent"],
            "coverage_with_structure_removed_all_other_layers": removed_stats,
            "result": result,
        })
        print(
            f"{name:20} ground_cells={ground_percent:6.2f}%  terrain_px={terrain_stats['coverage_percent']:7.3f}%  "
            f"black={terrain_stats['black_percent']:.3f}%  -> {result}"
        )

    report = {
        "schema": "new-era.nnv-house-removal-probe.v1",
        "question": "is there valid NNV ground under each house structure, or does removal reveal black/empty tiles?",
        "season": arguments.season,
        "read_only": True,
        "mutations": "none; no tile created, no house reconstructed, no PMU terrain substituted",
        "ground_layers": sorted(GROUND_LAYERS),
        "structure_layers": sorted(STRUCTURE_LAYERS),
        "source_ground": str(ground_path.relative_to(REPO)),
        "houses": results,
    }
    (arguments.out / "house-removal-probe.json").write_text(
        json.dumps(report, indent=2, sort_keys=True, ensure_ascii=False) + "\n"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
