#!/usr/bin/env python3
"""Convert normalized BIBLIOTHEQUE Map IR into a staged PMDO Ground candidate.

This converter is intentionally source-game agnostic: it reads only normalized
32 px RGBA tile frames and source semantics from Map IR.  It never writes to
New Era's runtime Data/ or Content/ destinations.  The candidate remains
unreleased until the separate PMDO runtime and adaptation gates pass.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import struct
from pathlib import Path
from typing import Any

from build_common_map_ir import validate_ir
from inventory_relict import DEFAULT_OUTPUT, sha256_file, write_json
from png_rgba import RGBAImage, load_png, png_bytes, save_png

DEFAULT_OUTPUT_ROOT = DEFAULT_OUTPUT / "conversion/pmdo_pilot"
PMDO_TICKS_PER_SECOND = 60
SOURCE_TILE_SIZE = 32
GROUND_COLLISION_SIZE = 8
GROUND_TEX_SIZE = SOURCE_TILE_SIZE // GROUND_COLLISION_SIZE


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def premultiply(image: RGBAImage) -> RGBAImage:
    result = RGBAImage(image.width, image.height, bytearray(image.pixels))
    for index in range(0, len(result.pixels), 4):
        alpha = result.pixels[index + 3]
        for channel in range(3):
            result.pixels[index + channel] = (
                result.pixels[index + channel] * alpha + 127
            ) // 255
    return result


def write_tile(path: Path, tile_size: int, entries: list[tuple[int, bytes]]) -> None:
    require(len({key for key, _ in entries}) == len(entries), "duplicate atlas key")
    payload_offsets: dict[bytes, int] = {}
    ordered_payloads: list[bytes] = []
    offset = 8 + len(entries) * 16
    for _, payload in entries:
        if payload not in payload_offsets:
            payload_offsets[payload] = offset
            ordered_payloads.append(payload)
            offset += 8 + len(payload)
    output = bytearray(struct.pack("<II", tile_size, len(entries)))
    for key, payload in entries:
        output.extend(struct.pack("<QQ", key, payload_offsets[payload]))
    for payload in ordered_payloads:
        output.extend(struct.pack("<Q", len(payload)))
        output.extend(payload)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(output)


def read_tile(path: Path) -> tuple[int, dict[tuple[int, int], bytes]]:
    raw = path.read_bytes()
    require(len(raw) >= 8, "tile atlas header is truncated")
    tile_size, count = struct.unpack_from("<II", raw, 0)
    require(len(raw) >= 8 + count * 16, "tile atlas index is truncated")
    result: dict[tuple[int, int], bytes] = {}
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        require(offset + 8 <= len(raw), "tile payload offset is outside file")
        length = struct.unpack_from("<Q", raw, offset)[0]
        require(offset + 8 + length <= len(raw), "tile payload is truncated")
        location = (key & 0xFFFFFFFF, key >> 32)
        require(location not in result, "duplicate tile location")
        result[location] = raw[offset + 8 : offset + 8 + length]
    return tile_size, result


def duration_to_pmdo_ticks(duration_ms: int) -> int:
    ticks = duration_ms * PMDO_TICKS_PER_SECOND
    require(ticks % 1000 == 0, f"duration {duration_ms} ms is not exact at 60 Hz")
    return ticks // 1000


def empty_cell() -> dict[str, Any]:
    return {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1}


def visual_cell(sheet: str, locations: list[tuple[int, int]], frame_length: int) -> dict[str, Any]:
    return {
        "AutoTileset": "",
        "Associates": [],
        "Layers": [{
            "Frames": [
                {"Sheet": sheet, "TexLoc": {"X": x, "Y": y}}
                for x, y in locations
            ],
            "FrameLength": frame_length,
        }],
        "NeighborCode": -1,
    }


def source_direction_to_pmdo(direction: int) -> int:
    # RogueElements.Dir8: Down=0, Left=2, Up=4, Right=6.
    return {2: 0, 4: 2, 6: 6, 8: 4}.get(direction, 0)


def marker_for_placement(index: int, placement: dict[str, Any], tile_size: int) -> dict[str, Any]:
    position = placement["position"]
    return {
        "EntName": f"source_placement_{index + 1:04d}",
        "Direction": source_direction_to_pmdo(placement["graphic"]["direction"]),
        "EntEnabled": True,
        "EntOrder": 0,
        "InteractOrder": 0,
        "triggerType": 0,
        "Collider": {
            "X": position["x"] * tile_size + tile_size // 4,
            "Y": position["y"] * tile_size + tile_size // 4,
            "Width": tile_size // 2,
            "Height": tile_size // 2,
        },
    }


def build_ground(
    ir: dict[str, Any], asset: str, sheet: str,
    frame_locations: dict[tuple[int, int], list[tuple[int, int]]],
) -> dict[str, Any]:
    geometry = ir["geometry"]
    width, height = geometry["width_tiles"], geometry["height_tiles"]
    source_tile_size = geometry["source_tile_size_px"]
    require(source_tile_size == SOURCE_TILE_SIZE, "PMDO pilot supports normalized 32 px IR tiles")

    catalog = {row["tile_id"]: row for row in ir["tile_layers"]["tile_catalog"]}
    layers = []
    for source_layer in ir["tile_layers"]["layers"]:
        grid = []
        for x in range(width):
            column = []
            for y in range(height):
                tile_id = source_layer["rows"][y][x]
                if tile_id == 0:
                    column.append(empty_cell())
                    continue
                tile = catalog[tile_id]
                durations = {frame["duration_ms"] for frame in tile["frames"]}
                require(len(durations) == 1, f"tile {tile_id}: variable frame durations need PMDO adaptation")
                column.append(visual_cell(
                    sheet,
                    frame_locations[(source_layer["index"], tile_id)],
                    duration_to_pmdo_ticks(durations.pop()),
                ))
            grid.append(column)
        layers.append({
            "Name": f"Couche source {source_layer['index']}",
            "Layer": 0,
            "Visible": True,
            "Tiles": grid,
        })

    masks = ir["collision"]["allowed_direction_masks"]
    partial_masks = sorted({mask for row in masks for mask in row if mask not in (0, 15)})
    require(not partial_masks, f"directional masks require a PMDO adapter: {partial_masks}")
    scale = source_tile_size // GROUND_COLLISION_SIZE
    obstacle_width, obstacle_height = width * scale, height * scale
    obstacles = []
    for x in range(obstacle_width):
        column = []
        for y in range(obstacle_height):
            blocked = masks[y // scale][x // scale] == 0
            column.append({
                "Bounds": {
                    "X": x * GROUND_COLLISION_SIZE,
                    "Y": y * GROUND_COLLISION_SIZE,
                    "Width": GROUND_COLLISION_SIZE,
                    "Height": GROUND_COLLISION_SIZE,
                },
                "Tags": 1 if blocked else 0,
            })
        obstacles.append(column)

    markers = [
        marker_for_placement(index, row, source_tile_size)
        for index, row in enumerate(ir["entities"]["placements"])
    ]
    game = ir["identity"]["game_id"].capitalize()
    return {
        "Version": "0.8.9.0",
        "Object": {
            "$type": "RogueEssence.Ground.GroundMap, RogueEssence",
            "TexSize": GROUND_TEX_SIZE,
            "Name": {
                "DefaultText": f"{ir['identity']['source_name']} — pilote {game}",
                "LocalTexts": {"fr": f"Plage — pilote {game}"}
                if ir["identity"]["zone_id"] == "relict_map_012" else {},
            },
            "Released": False,
            "Comment": (
                "Candidat BIBLIOTHEQUE généré de façon reproductible depuis une Map source "
                "qualifiée. Hors destinations runtime; ne pas promouvoir avant validation PMDO "
                "et adaptation New Era. Aucun casting, dialogue, script ou audio source inclus."
            ),
            "obstacles": obstacles,
            "rand": {"$type": "RogueElements.ReRandom, RogueElements", "s": [0, 0, 0, 0]},
            "Status": {},
            "Background": {
                "$type": "RogueEssence.Dungeon.MapBG, RogueEssence",
                "MapLoc": {"X": 0, "Y": 0},
                "BGAnim": {
                    "AnimIndex": "", "FrameTime": 1, "StartFrame": -1,
                    "EndFrame": -1, "AnimDir": -1, "Alpha": 255, "AnimFlip": 0,
                },
                "BGMovement": {"X": 0, "Y": 0},
                "Parallax": "0, 0", "RepeatX": False, "RepeatY": False,
            },
            "BlankBG": {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1},
            "Layers": layers,
            "AssetName": asset,
            "Music": "",
            "EdgeView": 1,
            "NoSwitching": False,
            "ViewCenter": None,
            "ViewOffset": {"X": 0, "Y": 0},
            "ActiveChar": None,
            "Decorations": [{"Name": "Décor", "Layer": 0, "Visible": True, "Anims": []}],
            "Entities": [{
                "Name": "Placements source expurgés",
                "Visible": True,
                "MapChars": [],
                "GroundObjects": [],
                "Spawners": [],
                "Markers": markers,
            }],
        },
    }


def render_ground_layers(
    ground: dict[str, Any],
    atlas_images: dict[tuple[int, int], RGBAImage],
    pmdo_tick: int = 0,
) -> list[RGBAImage]:
    obj = ground["Object"]
    pitch = obj["TexSize"] * 8
    width = len(obj["Layers"][0]["Tiles"])
    height = len(obj["Layers"][0]["Tiles"][0])
    result = []
    for layer in obj["Layers"]:
        image = RGBAImage.empty(width * pitch, height * pitch)
        for x, column in enumerate(layer["Tiles"]):
            for y, cell in enumerate(column):
                for tile_layer in cell["Layers"]:
                    frames = tile_layer["Frames"]
                    if not frames:
                        continue
                    frame_length = tile_layer["FrameLength"]
                    frame = frames[(pmdo_tick // frame_length) % len(frames)]
                    location = frame["TexLoc"]
                    image.alpha_over(atlas_images[(location["X"], location["Y"])], x * pitch, y * pitch)
        result.append(image)
    return result


def pixel_diff(actual: RGBAImage, expected: RGBAImage) -> dict[str, int]:
    require((actual.width, actual.height) == (expected.width, expected.height), "preview dimensions differ")
    different_pixels = 0
    max_channel_delta = 0
    for index in range(0, len(actual.pixels), 4):
        deltas = [abs(actual.pixels[index + c] - expected.pixels[index + c]) for c in range(4)]
        if any(deltas):
            different_pixels += 1
            max_channel_delta = max(max_channel_delta, *deltas)
    return {"different_pixels": different_pixels, "max_channel_delta": max_channel_delta}


def convert(ir_path: Path, game_root: Path, output: Path) -> dict[str, Any]:
    ir_path = ir_path.resolve()
    game_root = game_root.resolve()
    output = output.resolve()
    ir = load_json(ir_path)
    validate_ir(ir)
    require(ir["target_contract"]["runtime_destination_allowed"] is False, "IR allows runtime write")
    map_id = int(ir["identity"]["source_map_id"])
    asset = f"{ir['identity']['game_id']}_map_{map_id:03d}_pilot"
    sheet = asset + "_Base"

    catalog = {row["tile_id"]: row for row in ir["tile_layers"]["tile_catalog"]}
    payload_locations: dict[bytes, tuple[int, int]] = {}
    atlas_images: dict[tuple[int, int], RGBAImage] = {}
    frame_locations: dict[tuple[int, int], list[tuple[int, int]]] = {}
    atlas_entries: list[tuple[int, bytes]] = []
    for layer in ir["tile_layers"]["layers"]:
        used = sorted({value for row in layer["rows"] for value in row if value})
        for tile_id in used:
            locations = []
            for frame in catalog[tile_id]["frames"]:
                frame_path = game_root / frame["file"]
                require(sha256_file(frame_path) == frame["sha256"], f"IR frame hash changed: {frame_path}")
                image = load_png(frame_path)
                require((image.width, image.height) == (SOURCE_TILE_SIZE, SOURCE_TILE_SIZE), "IR frame is not 32x32")
                payload = png_bytes(premultiply(image))
                if payload not in payload_locations:
                    index = len(payload_locations)
                    location = (index % 64, index // 64)
                    payload_locations[payload] = location
                    atlas_images[location] = image
                    atlas_entries.append((location[0] | (location[1] << 32), payload))
                locations.append(payload_locations[payload])
            frame_locations[(layer["index"], tile_id)] = locations

    tile_path = output / f"Content/Tile/{sheet}.tile"
    write_tile(tile_path, SOURCE_TILE_SIZE, atlas_entries)
    ground = build_ground(ir, asset, sheet, frame_locations)
    ground_path = output / f"Data/Ground/{asset}.rsground"
    ground_path.parent.mkdir(parents=True, exist_ok=True)
    ground_path.write_text(
        "\ufeff" + json.dumps(ground, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )

    tile_size, parsed_payloads = read_tile(tile_path)
    require(tile_size == SOURCE_TILE_SIZE, "staged atlas tile size differs")
    expected_payloads = {
        (key & 0xFFFFFFFF, key >> 32): payload for key, payload in atlas_entries
    }
    require(parsed_payloads == expected_payloads, "staged atlas round-trip differs")
    require(load_json(ground_path) == ground, "staged Ground JSON round-trip differs")

    rendered_layers = render_ground_layers(ground, atlas_images)
    preview_dir = output / "previews"
    validation_layers = []
    composite = RGBAImage.empty(ir["geometry"]["width_px"], ir["geometry"]["height_px"], (0, 0, 0, 255))
    for index, image in enumerate(rendered_layers):
        output_preview = preview_dir / f"layer_{index:02d}.png"
        save_png(image, output_preview)
        expected_path = game_root / f"previews/maps/map_{map_id:03d}/layer_{index:02d}.png"
        expected = load_png(expected_path)
        diff = pixel_diff(image, expected)
        validation_layers.append({
            "index": index,
            "output": output_preview.relative_to(output).as_posix(),
            "output_sha256": sha256_file(output_preview),
            "expected": expected_path.relative_to(game_root).as_posix(),
            "expected_sha256": sha256_file(expected_path),
            **diff,
        })
        composite.alpha_over(image)
    composite_path = preview_dir / "composite_tick_000.png"
    save_png(composite, composite_path)
    expected_composite_path = game_root / f"previews/maps/map_{map_id:03d}/composite.png"
    composite_diff = pixel_diff(composite, load_png(expected_composite_path))

    tick_015_layers = render_ground_layers(ground, atlas_images, pmdo_tick=15)
    composite_tick_015 = RGBAImage.empty(
        ir["geometry"]["width_px"], ir["geometry"]["height_px"], (0, 0, 0, 255)
    )
    for image in tick_015_layers:
        composite_tick_015.alpha_over(image)
    composite_tick_015_path = preview_dir / "composite_tick_015.png"
    save_png(composite_tick_015, composite_tick_015_path)
    require(
        composite_tick_015.pixels != composite.pixels,
        "animated pilot did not change between PMDO ticks 0 and 15",
    )

    masks = ir["collision"]["allowed_direction_masks"]
    terrain_values = sorted({value for row in ir["collision"]["terrain_tags"] for value in row})
    animated_tiles = [row for row in catalog.values() if len(row["frames"]) > 1]
    report = {
        "schema_version": "1.0.0",
        "result": "PMDO_PILOT_STATIC_VALIDATION_PASS"
        if all(row["different_pixels"] == 0 for row in validation_layers)
        and composite_diff["different_pixels"] == 0 else "PMDO_PILOT_STATIC_VALIDATION_FAIL",
        "conversion_status": "PMDO_CONVERTED",
        "adaptation_status": "ADAPTATION_REQUIRED",
        "runtime_validation_status": "NOT_RUN",
        "runtime_destination_written": False,
        "identity": ir["identity"],
        "ir": {
            "file": ir_path.relative_to(game_root).as_posix(),
            "sha256": sha256_file(ir_path),
        },
        "outputs": {
            "ground": {
                "file": ground_path.relative_to(output).as_posix(),
                "sha256": sha256_file(ground_path),
                "size_bytes": ground_path.stat().st_size,
            },
            "tile": {
                "file": tile_path.relative_to(output).as_posix(),
                "sha256": sha256_file(tile_path),
                "size_bytes": tile_path.stat().st_size,
                "atlas_entry_count": len(atlas_entries),
                "deduplicated_payload_count": len(payload_locations),
                "tile_size_px": tile_size,
            },
            "composite_tick_000": {
                "file": composite_path.relative_to(output).as_posix(),
                "sha256": sha256_file(composite_path),
            },
            "composite_tick_015": {
                "file": composite_tick_015_path.relative_to(output).as_posix(),
                "sha256": sha256_file(composite_tick_015_path),
                "differs_from_tick_000": True,
            },
        },
        "technical_validation": {
            "ground_json_round_trip": "PASS",
            "tile_binary_round_trip": "PASS",
            "geometry_px": [ir["geometry"]["width_px"], ir["geometry"]["height_px"]],
            "graphic_grid": [ir["geometry"]["width_tiles"], ir["geometry"]["height_tiles"]],
            "collision_grid": [len(ground["Object"]["obstacles"]), len(ground["Object"]["obstacles"][0])],
            "source_layer_count": len(ir["tile_layers"]["layers"]),
            "ground_layer_count": len(ground["Object"]["Layers"]),
            "blocked_source_tiles": sum(mask == 0 for row in masks for mask in row),
            "free_source_tiles": sum(mask == 15 for row in masks for mask in row),
            "partial_directional_masks": sorted({mask for row in masks for mask in row if mask not in (0, 15)}),
            "entity_placement_count": len(ir["entities"]["placements"]),
            "marker_count": len(ground["Object"]["Entities"][0]["Markers"]),
            "animated_catalog_tile_count": len(animated_tiles),
            "animation_frame_count": sum(len(row["frames"]) for row in animated_tiles),
            "animation_durations_ms": sorted({frame["duration_ms"] for row in animated_tiles for frame in row["frames"]}),
            "animation_frame_lengths_pmdo": sorted({duration_to_pmdo_ticks(frame["duration_ms"]) for row in animated_tiles for frame in row["frames"]}),
        },
        "visual_validation": {
            "layers": validation_layers,
            "composite_tick_000": {
                "expected": expected_composite_path.relative_to(game_root).as_posix(),
                "expected_sha256": sha256_file(expected_composite_path),
                **composite_diff,
            },
        },
        "retained_sidecar_semantics": {
            "directional_collision": True,
            "terrain_tags": terrain_values,
            "entity_pages_and_routes": True,
            "visual_timeline": True,
            "environmental_vfx": True,
            "map_effects": True,
        },
        "adaptation_required": [
            "PMDO runtime load/render validation through the existing Agent A headless method.",
            "Map source terrain tags to approved New Era Ground behavior where narratively needed.",
            "Replace redacted source placements with approved New Era actors without moving them.",
            "Adapt source visual timelines/VFX to New Era scripts without restoring dialogue or casting.",
            "Select French EU name, music, entrances, exits and narrative routing at the contractual integration point.",
        ],
        "forbidden_content_check": {
            "casting_sprite_exported": False,
            "dialogue_exported": False,
            "script_body_exported": False,
            "audio_binary_exported": False,
        },
    }
    write_json(output / "reports/conversion_report.json", report)
    require(report["result"] == "PMDO_PILOT_STATIC_VALIDATION_PASS", "pilot visual validation failed")
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ir", type=Path, required=True)
    parser.add_argument("--game-root", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    map_id = int(load_json(args.ir)["identity"]["source_map_id"])
    output = args.output or DEFAULT_OUTPUT_ROOT / f"map_{map_id:03d}"
    report = convert(args.ir, args.game_root, output)
    print(json.dumps({
        "result": report["result"],
        "output": output.as_posix(),
        "ground_sha256": report["outputs"]["ground"]["sha256"],
        "tile_sha256": report["outputs"]["tile"]["sha256"],
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
