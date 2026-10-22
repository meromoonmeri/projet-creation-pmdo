#!/usr/bin/env python3
"""Reconstruct every RPG::Animation referenced by Relict map timelines."""

from __future__ import annotations

import argparse
import json
import math
import shutil
import struct
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

from inventory_relict import (
    DEFAULT_OUTPUT,
    DEFAULT_SOURCE,
    sha256_bytes,
    sha256_file,
    write_json,
)
from png_rgba import RGBAImage, load_png, save_png
from ruby_marshal import RubyObject, RubyUserData, decode_table, decode_text, ivar, load

ANIMATION_SCRIPT = Path("Data/Scripts/005_Sprites/008_Sprite_AnimationSprite.rb")
USED_ENVIRONMENTAL_ANIMATION_IDS = {3, 4, 8, 9, 10, 11, 12, 17, 18, 19}
CANVAS_WIDTH = 640
CANVAS_HEIGHT = 480
ANCHOR_X = 320
ANCHOR_Y = 240
CELL_SIZE = 192


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def signed16(value: int) -> int:
    return value - 65536 if value >= 32768 else value


def resize_nearest(image: RGBAImage, width: int, height: int) -> RGBAImage:
    result = RGBAImage.empty(width, height)
    for y in range(height):
        source_y = min(image.height - 1, y * image.height // height)
        for x in range(width):
            source_x = min(image.width - 1, x * image.width // width)
            source = (source_y * image.width + source_x) * 4
            target = (y * width + x) * 4
            result.pixels[target : target + 4] = image.pixels[source : source + 4]
    return result


def apply_opacity(image: RGBAImage, opacity: int) -> RGBAImage:
    result = RGBAImage(image.width, image.height, bytearray(image.pixels))
    for index in range(3, len(result.pixels), 4):
        result.pixels[index] = (result.pixels[index] * opacity + 127) // 255
    return result


def composite_blend(destination: RGBAImage, source: RGBAImage, x: int, y: int, blend_type: int) -> None:
    if blend_type == 0:
        destination.alpha_over(source, x, y)
        return
    for sy in range(source.height):
        dy = y + sy
        if dy < 0 or dy >= destination.height:
            continue
        for sx in range(source.width):
            dx = x + sx
            if dx < 0 or dx >= destination.width:
                continue
            si = (sy * source.width + sx) * 4
            alpha = source.pixels[si + 3]
            if alpha == 0:
                continue
            di = (dy * destination.width + dx) * 4
            for channel in range(3):
                contribution = (source.pixels[si + channel] * alpha + 127) // 255
                if blend_type == 1:
                    destination.pixels[di + channel] = min(
                        255, destination.pixels[di + channel] + contribution
                    )
                else:
                    destination.pixels[di + channel] = max(
                        0, destination.pixels[di + channel] - contribution
                    )
            destination.pixels[di + 3] = max(destination.pixels[di + 3], alpha)


def cell_rows(frame: RubyObject) -> list[dict[str, int]]:
    table = decode_table(ivar(frame, "cell_data"))
    rows = []
    for cell_index in range(table.x_size):
        values = [table.values[property_index * table.x_size + cell_index] for property_index in range(8)]
        pattern = signed16(values[0])
        if pattern < 0:
            continue
        rows.append({
            "cell_index": cell_index,
            "pattern": pattern,
            "x": signed16(values[1]),
            "y": signed16(values[2]),
            "zoom_percent": values[3],
            "angle_degrees": signed16(values[4]),
            "mirror": values[5],
            "opacity": values[6],
            "blend_type": values[7],
        })
    return rows


def render_frame(sheet: RGBAImage, cells: list[dict[str, int]]) -> RGBAImage:
    canvas = RGBAImage.empty(CANVAS_WIDTH, CANVAS_HEIGHT)
    for cell in cells:
        pattern = cell["pattern"]
        source_x = (pattern % 5) * CELL_SIZE
        source_y = (pattern // 5) * CELL_SIZE
        if source_x + CELL_SIZE > sheet.width or source_y + CELL_SIZE > sheet.height:
            raise ValueError(f"animation cell {pattern} outside source sheet")
        image = sheet.crop(source_x, source_y, CELL_SIZE, CELL_SIZE)
        zoom = cell["zoom_percent"]
        width = max(1, CELL_SIZE * zoom // 100)
        height = max(1, CELL_SIZE * zoom // 100)
        if cell["angle_degrees"] != 0 or cell["mirror"] != 0:
            raise ValueError("used Relict map animation requires unsupported rotation/mirror")
        if width != CELL_SIZE or height != CELL_SIZE:
            image = resize_nearest(image, width, height)
        image = apply_opacity(image, cell["opacity"])
        x = ANCHOR_X + cell["x"] - width // 2
        y = ANCHOR_Y + cell["y"] - height // 2
        composite_blend(canvas, image, x, y, cell["blend_type"])
    return canvas


def color_userdata(value: Any) -> list[float] | None:
    if not isinstance(value, RubyUserData) or value.class_name != "Color" or len(value.data) != 32:
        return None
    return list(struct.unpack("<4d", value.data))


def source_provenance(path: Path, source: Path, source_format: str, method: str) -> dict[str, Any]:
    return {
        "repository": "https://github.com/meromoonmeri/BIBLIOTHEQUE",
        "commit": "6963878956ec4c53833c03f26aa6a9aafd17800f",
        "source_path": path.relative_to(source.parents[2]).as_posix(),
        "sha256": sha256_file(path),
        "size_bytes": path.stat().st_size,
        "source_format": source_format,
        "extraction_method": method,
        "license_status": "UNKNOWN",
    }


def used_animation_contexts(inventory_root: Path) -> dict[int, list[dict[str, Any]]]:
    contexts: dict[int, list[dict[str, Any]]] = defaultdict(list)
    for timeline_path in sorted((inventory_root / "vfx/timelines").rglob("*.json")):
        payload = load_json(timeline_path)
        sequences = payload.get("sequences", payload.get("events", []))
        for sequence in sequences:
            for command in sequence.get("timeline", []):
                if command["category"] == "animation_on_entity":
                    parameters = command["parameters"]
                    if len(parameters) > 1 and isinstance(parameters[1], int):
                        contexts[parameters[1]].append({
                            "timeline": timeline_path.relative_to(inventory_root).as_posix(),
                            "source_event_id": sequence.get("source_event_id"),
                            "page_index": sequence.get("page_index"),
                            "source_index": command["source_index"],
                            "target_event_id": parameters[0],
                        })
                elif command["category"] == "script_visual_block":
                    for call in command["parameters"]["calls"]:
                        arguments = call.get("arguments", [])
                        if call["call"] == "user_animation" and arguments and isinstance(arguments[0], int):
                            contexts[arguments[0]].append({
                                "timeline": timeline_path.relative_to(inventory_root).as_posix(),
                                "source_event_id": sequence.get("source_event_id"),
                                "page_index": sequence.get("page_index"),
                                "source_index": command["source_index"],
                                "position_arguments": arguments[1:],
                            })
    return contexts


def build(source: Path, inventory_root: Path) -> dict[str, Any]:
    source = source.resolve()
    inventory_root = inventory_root.resolve()
    output = inventory_root / "animations/map_effects"
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)
    definitions_path = source / "Data/Animations.rxdata"
    definitions = load(definitions_path)
    contexts = used_animation_contexts(inventory_root)
    if set(contexts) != USED_ENVIRONMENTAL_ANIMATION_IDS:
        raise ValueError(f"used map animation IDs changed: {sorted(contexts)}")
    timing_path = source / ANIMATION_SCRIPT
    timing_text = timing_path.read_text(encoding="utf-8")
    if "fr = 20" not in timing_text or "@_animation_time_per_frame = 1.0 / fr" not in timing_text:
        raise ValueError("animation timing authority changed")
    rows = []
    total_frames = 0
    for animation_id in sorted(contexts):
        animation = definitions[animation_id]
        if not isinstance(animation, RubyObject):
            raise ValueError(f"missing animation definition {animation_id}")
        source_name = decode_text(ivar(animation, "animation_name", ""))
        matches = sorted(
            path for path in (source / "Graphics/Animations").glob("*")
            if path.is_file() and path.stem.casefold() == source_name.casefold()
        )
        if len(matches) != 1:
            raise ValueError(f"animation sheet resolution failed for ID {animation_id}")
        sheet_path = matches[0]
        sheet = load_png(sheet_path)
        definition_name = decode_text(ivar(animation, "name", ""))
        fr_match = __import__("re").search(r"\[\s*(\d+)\s*\]\s*$", definition_name)
        frames_per_second = int(fr_match.group(1)) if fr_match else 20
        duration_ms = 1000 // frames_per_second
        animation_key = f"relict_map_animation_{animation_id:03d}_{sha256_file(sheet_path)[:12]}"
        destination = output / animation_key
        frame_rows = []
        cells_by_frame = []
        rendered_frames = []
        for frame_index, frame in enumerate(ivar(animation, "frames", []) or []):
            cells = cell_rows(frame)
            image = render_frame(sheet, cells)
            frame_path = destination / "layers/layer_00" / f"frame_{frame_index:03d}.png"
            save_png(image, frame_path)
            frame_rows.append({
                "index": frame_index,
                "file": frame_path.relative_to(destination).as_posix(),
                "duration_ms": duration_ms,
                "sha256": sha256_file(frame_path),
            })
            cells_by_frame.append({"index": frame_index, "cells": cells})
            rendered_frames.append(image)
        total_frames += len(frame_rows)
        columns = min(8, len(rendered_frames))
        rows_count = math.ceil(len(rendered_frames) / columns)
        thumb_width, thumb_height = 160, 120
        contact = RGBAImage.empty(columns * thumb_width, rows_count * thumb_height)
        for frame_index, image in enumerate(rendered_frames):
            thumbnail = resize_nearest(image, thumb_width, thumb_height)
            contact.alpha_over(
                thumbnail,
                (frame_index % columns) * thumb_width,
                (frame_index // columns) * thumb_height,
            )
        contact_path = destination / "contact_sheet.png"
        save_png(contact, contact_path)
        source_timings = []
        for timing in ivar(animation, "timings", []) or []:
            audio = ivar(timing, "se")
            audio_name = decode_text(ivar(audio, "name", ""))
            source_timings.append({
                "frame": int(ivar(timing, "frame", 0)),
                "condition": int(ivar(timing, "condition", 0)),
                "flash_scope": int(ivar(timing, "flash_scope", 0)),
                "flash_duration_frames": int(ivar(timing, "flash_duration", 0)),
                "flash_color": color_userdata(ivar(timing, "flash_color")),
                "audio_present": bool(audio_name),
                "audio_identity_sha256": sha256_bytes(audio_name.encode()) if audio_name else None,
                "audio_exported": False,
            })
        metadata = {
            "schema_version": "1.0.0",
            "animation_id": animation_key,
            "source_animation_id": animation_id,
            "game_id": "relict",
            "status": "SOURCE_DOCUMENTED",
            "frame_count": len(frame_rows),
            "loop": False,
            "loop_start": None,
            "timing_authority": "SOURCE_EXACT",
            "timing_provenance": {
                "source_path": ANIMATION_SCRIPT.as_posix(),
                "sha256": sha256_file(timing_path),
                "method": "STATIC_SCRIPT_CONSTANT",
                "constant": frames_per_second,
                "units": "frames per second",
                "static_audit_only": True,
            },
            "source_frame_layout": "RMXP_ANIMATION_5_COLUMNS_192PX_CELLS",
            "position": int(ivar(animation, "position", 0)),
            "layers": [{
                "layer_id": "layer_00",
                "order": 0,
                "blend_mode": "PER_CELL_SOURCE_BLEND",
                "frames": frame_rows,
            }],
            "cells_by_frame": cells_by_frame,
            "source_timings": source_timings,
            "contexts": contexts[animation_id],
            "dependencies": [],
            "pmdo_dtef_candidate": False,
            "render_note": "640x480 neutral anchor at 320,240; exact cell transforms retained in metadata",
            "definition_provenance": source_provenance(
                definitions_path, source, "RPG Maker XP Ruby Marshal RPG::Animation",
                "bounded Ruby Marshal parser; only used animation IDs",
            ),
            "provenance": source_provenance(
                sheet_path, source, "PNG animation sheet",
                "192px cells composed with exact source offsets, zoom, opacity and blend",
            ),
            "contact_sheet": {
                "file": contact_path.relative_to(destination).as_posix(),
                "sha256": sha256_file(contact_path),
                "width_px": contact.width,
                "height_px": contact.height,
            },
        }
        metadata_path = destination / "metadata.json"
        write_json(metadata_path, metadata)
        rows.append({
            "source_animation_id": animation_id,
            "animation_id": animation_key,
            "metadata": metadata_path.relative_to(inventory_root).as_posix(),
            "metadata_sha256": sha256_file(metadata_path),
            "frame_count": len(frame_rows),
            "usage_count": len(contexts[animation_id]),
        })
    manifest = {
        "schema_version": "1.0.0",
        "result": "MAP_ANIMATION_EXTRACTION_PASS",
        "used_animation_count": len(rows),
        "total_frame_count": total_frames,
        "timing_exact_count": len(rows),
        "unsupported_transform_count": 0,
        "audio_pixels_or_binaries_exported": False,
        "animations": rows,
    }
    write_json(output / "manifest.json", manifest)
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--inventory-root", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    result = build(args.source, args.inventory_root)
    print(json.dumps({key: value for key, value in result.items() if key != "animations"}, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
