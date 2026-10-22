#!/usr/bin/env python3
from __future__ import annotations

import argparse
import bz2
import gzip
import hashlib
import io
import json
import math
import re
import struct
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

from PIL import Image, ImageOps

EXPECTED_DATA_SHA256 = "2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227"
GRET_COMMIT = "2b122fa2183912299ea8ec887ec663f73a36ee9f"
TILE_INDEX_MASK = 0x0007FFFF
TILE_MIRROR = 0x10000000
TILE_FLIP = 0x20000000
TILE_ROTATE = 0x40000000
SEASONS = ("spring", "summer", "autumn", "winter")
SEASON_PREFIXES = {
    "spring": ("objsp",), "summer": ("objsm",),
    "autumn": ("objau",), "winter": ("objwn", "objwinter", "objsnow"),
}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_json(path: Path, value: Any, *, compact: bool = False) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, sort_keys=True, indent=None if compact else 2, separators=(",", ":") if compact else None) + "\n", encoding="utf-8")


def write_gzip_json(path: Path, value: Any) -> str:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()
    with path.open("wb") as raw, gzip.GzipFile(filename="", mode="wb", fileobj=raw, mtime=0, compresslevel=9) as stream:
        stream.write(payload)
    return hashlib.sha256(payload).hexdigest()


def u16(data: bytes, offset: int) -> int: return struct.unpack_from("<H", data, offset)[0]
def i16(data: bytes, offset: int) -> int: return struct.unpack_from("<h", data, offset)[0]
def u32(data: bytes, offset: int) -> int: return struct.unpack_from("<I", data, offset)[0]
def i32(data: bytes, offset: int) -> int: return struct.unpack_from("<i", data, offset)[0]
def f32(data: bytes, offset: int) -> float: return struct.unpack_from("<f", data, offset)[0]
def i64(data: bytes, offset: int) -> int: return struct.unpack_from("<q", data, offset)[0]


def cstring(data: bytes, offset: int) -> str:
    if not 0 < offset < len(data): return ""
    end = data.find(b"\0", offset)
    if end < 0: return ""
    return data[offset:end].decode("utf-8", errors="replace")


def chunk_table(data: bytes) -> dict[str, dict[str, int]]:
    if data[:4] != b"FORM": raise ValueError("not a GameMaker FORM archive")
    result = {}
    position = 8
    # Resource chunks end before detached TXTR blobs; chunk sizes remain authoritative.
    while position + 8 <= len(data):
        tag = data[position:position + 4]
        if not all(32 <= byte < 127 for byte in tag): break
        size = u32(data, position + 4)
        name = tag.decode("ascii", errors="replace")
        result[name] = {"header_offset": position, "offset": position + 8, "size": size}
        position += 8 + size
        if name == "TXTR": break
    return result


def index_offsets(data: bytes, chunk: dict[str, int]) -> list[int]:
    count = u32(data, chunk["offset"])
    return [u32(data, chunk["offset"] + 4 + index * 4) for index in range(count)]


def sign_extend(value: int, bits: int) -> int:
    sign = 1 << (bits - 1)
    return (value ^ sign) - sign


def decode_qoi(payload: bytes) -> Image.Image:
    if payload[:4] != b"fioq": raise ValueError("invalid GameMaker QOI")
    width, height, length = u16(payload, 4), u16(payload, 6), u32(payload, 8)
    encoded = payload[12:12 + length]
    pos = run = 0
    r = g = b = 0; a = 255
    index = [(0, 0, 0, 0)] * 64
    output = bytearray(width * height * 4)
    for pixel in range(width * height):
        if run:
            run -= 1
        elif pos < len(encoded):
            b1 = encoded[pos]; pos += 1
            if b1 & 0xC0 == 0x00:
                r, g, b, a = index[b1]
            elif b1 & 0xE0 == 0x40:
                run = b1 & 0x1F
            elif b1 & 0xE0 == 0x60:
                b2 = encoded[pos]; pos += 1; run = (((b1 & 0x1F) << 8) | b2) + 32
            elif b1 & 0xC0 == 0x80:
                r = (r + sign_extend((b1 >> 4) & 3, 2)) & 255
                g = (g + sign_extend((b1 >> 2) & 3, 2)) & 255
                b = (b + sign_extend(b1 & 3, 2)) & 255
            elif b1 & 0xE0 == 0xC0:
                b2 = encoded[pos]; pos += 1
                r = (r + sign_extend(b1 & 0x1F, 5)) & 255
                g = (g + sign_extend((b2 >> 4) & 0x0F, 4)) & 255
                b = (b + sign_extend(b2 & 0x0F, 4)) & 255
            elif b1 & 0xF0 == 0xE0:
                b2, b3 = encoded[pos], encoded[pos + 1]; pos += 2
                merged = (b1 << 16) | (b2 << 8) | b3
                r = (r + sign_extend((merged >> 15) & 0x1F, 5)) & 255
                g = (g + sign_extend((merged >> 10) & 0x1F, 5)) & 255
                b = (b + sign_extend((merged >> 5) & 0x1F, 5)) & 255
                a = (a + sign_extend(merged & 0x1F, 5)) & 255
            elif b1 & 0xF0 == 0xF0:
                if b1 & 8: r = encoded[pos]; pos += 1
                if b1 & 4: g = encoded[pos]; pos += 1
                if b1 & 2: b = encoded[pos]; pos += 1
                if b1 & 1: a = encoded[pos]; pos += 1
            index[(r ^ g ^ b ^ a) & 63] = (r, g, b, a)
        offset = pixel * 4
        output[offset:offset + 4] = bytes((r, g, b, a))
    return Image.frombytes("RGBA", (width, height), bytes(output))


def extract_textures(data: bytes, chunks: dict[str, dict[str, int]], output: Path) -> list[dict[str, Any]]:
    pointers = index_offsets(data, chunks["TXTR"])
    rows = []
    output.mkdir(parents=True, exist_ok=True)
    for index, pointer in enumerate(pointers):
        block_size = u32(data, pointer + 8)
        width, height = u32(data, pointer + 12), u32(data, pointer + 16)
        index_in_group, blob = u32(data, pointer + 20), u32(data, pointer + 24)
        if data[blob:blob + 4] != b"2zoq": raise ValueError(f"texture {index}: unsupported format")
        decoder = bz2.BZ2Decompressor()
        qoi = decoder.decompress(data[blob + 12:blob + block_size])
        image = decode_qoi(qoi)
        if image.size != (width, height): raise ValueError(f"texture {index}: dimension mismatch")
        path = output / f"texture-{index:03d}.png"
        image.save(path, format="PNG", optimize=False, compress_level=9)
        rows.append({
            "id": index, "entry_offset": pointer, "blob_offset": blob, "block_size": block_size,
            "width": width, "height": height, "index_in_group": index_in_group,
            "uncompressed_qoi_bytes": len(qoi), "png": str(path), "png_sha256": sha256_file(path),
        })
    return rows


def parse_tpag(data: bytes, chunk: dict[str, int]) -> tuple[list[dict[str, Any]], dict[int, int]]:
    rows = []; by_offset = {}
    for index, pointer in enumerate(index_offsets(data, chunk)):
        values = struct.unpack_from("<10Hh", data, pointer)
        row = {
            "id": index, "offset": pointer, "source_x": values[0], "source_y": values[1],
            "source_width": values[2], "source_height": values[3], "target_x": values[4],
            "target_y": values[5], "target_width": values[6], "target_height": values[7],
            "bounding_width": values[8], "bounding_height": values[9], "texture_page": values[10],
        }
        rows.append(row); by_offset[pointer] = index
    return rows, by_offset


def parse_sprites(data: bytes, chunk: dict[str, int], tpag_offsets: dict[int, int]) -> list[dict[str, Any]]:
    rows = []
    for index, pointer in enumerate(index_offsets(data, chunk)):
        marker = i32(data, pointer + 56)
        if marker != -1: raise ValueError(f"sprite {index}: unsupported non-special format")
        version, sprite_type = u32(data, pointer + 60), u32(data, pointer + 64)
        playback_speed, playback_type = f32(data, pointer + 68), u32(data, pointer + 72)
        if version < 3 or sprite_type != 0: raise ValueError(f"sprite {index}: unsupported special type")
        sequence_offset, nine_slice_offset = u32(data, pointer + 76), u32(data, pointer + 80)
        frame_count = u32(data, pointer + 84)
        frames = []
        for frame in range(frame_count):
            tpag_pointer = u32(data, pointer + 88 + frame * 4)
            frames.append(tpag_offsets.get(tpag_pointer, -1))
        rows.append({
            "id": index, "offset": pointer, "name": cstring(data, u32(data, pointer)),
            "width": u32(data, pointer + 4), "height": u32(data, pointer + 8),
            "margins": [i32(data, pointer + 12), i32(data, pointer + 16), i32(data, pointer + 24), i32(data, pointer + 20)],
            "transparent": bool(u32(data, pointer + 28)), "smooth": bool(u32(data, pointer + 32)),
            "preload": bool(u32(data, pointer + 36)), "bbox_mode": u32(data, pointer + 40),
            "separate_mask": u32(data, pointer + 44), "origin": [i32(data, pointer + 48), i32(data, pointer + 52)],
            "format_version": version, "sprite_type": sprite_type, "playback_speed": playback_speed,
            "playback_speed_type": playback_type, "sequence_offset": sequence_offset,
            "nine_slice_offset": nine_slice_offset, "frame_count": frame_count, "tpag_frames": frames,
        })
    return rows


def parse_tilesets(data: bytes, chunk: dict[str, int], tpag_offsets: dict[int, int]) -> list[dict[str, Any]]:
    rows = []
    for index, pointer in enumerate(index_offsets(data, chunk)):
        tile_count, items = u32(data, pointer + 48), u32(data, pointer + 44)
        values = [u32(data, pointer + 64 + i * 4) for i in range(tile_count * items)]
        rows.append({
            "id": index, "offset": pointer, "name": cstring(data, u32(data, pointer)),
            "texture_page_item": tpag_offsets.get(u32(data, pointer + 16), -1),
            "format_version": u32(data, pointer + 20), "tile_width": u32(data, pointer + 24),
            "tile_height": u32(data, pointer + 28), "border_x": u32(data, pointer + 32),
            "border_y": u32(data, pointer + 36), "columns": u32(data, pointer + 40),
            "frames_per_tile": items, "tile_count": tile_count,
            "exported_sprite_id": i32(data, pointer + 52), "frame_length_microseconds": i64(data, pointer + 56),
            "tile_ids": values,
        })
    return rows


def ptr_list(data: bytes, pointer: int, maximum: int = 200000) -> list[int]:
    if not 0 < pointer < len(data): return []
    count = u32(data, pointer)
    if count > maximum: return []
    return [u32(data, pointer + 4 + i * 4) for i in range(count)]


def parse_room_layers(data: bytes, room_pointer: int, sprite_names: list[str], object_names: list[str]) -> list[dict[str, Any]]:
    layers_pointer = u32(data, room_pointer + 88)
    result = []
    for layer_pointer in ptr_list(data, layers_pointer, 1000):
        layer_type = u32(data, layer_pointer + 8)
        row: dict[str, Any] = {
            "name": cstring(data, u32(data, layer_pointer)), "id": u32(data, layer_pointer + 4),
            "type": layer_type, "depth": i32(data, layer_pointer + 12),
            "offset": [f32(data, layer_pointer + 16), f32(data, layer_pointer + 20)],
            "speed": [f32(data, layer_pointer + 24), f32(data, layer_pointer + 28)],
            "visible": bool(u32(data, layer_pointer + 32)),
            "effect_enabled": bool(u32(data, layer_pointer + 36)),
            "effect_type": cstring(data, u32(data, layer_pointer + 40)),
        }
        payload = layer_pointer + 48
        if layer_type == 4:
            tileset, width, height = i32(data, payload), u32(data, payload + 4), u32(data, payload + 8)
            count = width * height
            row.update({"tileset_id": tileset, "grid": [width, height], "tile_data": [u32(data, payload + 12 + i * 4) for i in range(count)]})
        elif layer_type == 3:
            legacy, sprites, sequences = u32(data, payload), u32(data, payload + 4), u32(data, payload + 8)
            placements = []
            for item in ptr_list(data, sprites):
                sprite_id = i32(data, item + 4)
                placements.append({
                    "name": cstring(data, u32(data, item)), "sprite_id": sprite_id,
                    "sprite_name": sprite_names[sprite_id] if 0 <= sprite_id < len(sprite_names) else "UNKNOWN",
                    "x": i32(data, item + 8), "y": i32(data, item + 12),
                    "scale": [f32(data, item + 16), f32(data, item + 20)], "color": u32(data, item + 24),
                    "animation_speed": f32(data, item + 28), "animation_speed_type": u32(data, item + 32),
                    "frame_index": f32(data, item + 36), "rotation": f32(data, item + 40),
                })
            row.update({"legacy_tile_count": len(ptr_list(data, legacy)), "sprite_placements": placements, "sequence_count": len(ptr_list(data, sequences))})
        elif layer_type == 2:
            row["instance_ids"] = [u32(data, payload + 4 + i * 4) for i in range(u32(data, payload))]
        elif layer_type == 1:
            row["background"] = {
                "visible": bool(u32(data, payload)), "foreground": bool(u32(data, payload + 4)),
                "sprite_id": i32(data, payload + 8), "tiled_x": bool(u32(data, payload + 12)),
                "tiled_y": bool(u32(data, payload + 16)), "stretch": bool(u32(data, payload + 20)),
                "color": u32(data, payload + 24), "first_frame": f32(data, payload + 28),
                "animation_speed": f32(data, payload + 32), "animation_speed_type": u32(data, payload + 36),
            }
        result.append(row)
    return result


def seasonal_family(name: str) -> str | None:
    lower = name.casefold()
    for season, prefixes in SEASON_PREFIXES.items():
        if lower.startswith(prefixes): return season
    return None


def build_ir(data_path: Path, output: Path, gret_root: Path) -> dict[str, Any]:
    if sha256_file(data_path) != EXPECTED_DATA_SHA256: raise ValueError("data.win SHA-256 mismatch")
    sys.path.insert(0, str(gret_root))
    # GRET's top-level `code` package collides with Python stdlib without this marker.
    (gret_root / "code/__init__.py").touch(exist_ok=True)
    from binary.all_chunks import load_game
    data = data_path.read_bytes(); chunks = chunk_table(data)
    game = load_game(data_path, show_progress=False)
    tpag, tpag_by_offset = parse_tpag(data, chunks["TPAG"])
    textures = extract_textures(data, chunks, output / "textures")
    sprites = parse_sprites(data, chunks["SPRT"], tpag_by_offset)
    tilesets = parse_tilesets(data, chunks["BGND"], tpag_by_offset)
    sprite_names = [row["name"] for row in sprites]
    object_rows = []
    object_names = [""] * len(game.objects)
    for object_id, obj in sorted(game.objects.items()):
        object_names[object_id] = obj.name
        object_rows.append({
            "id": object_id, "name": obj.name, "sprite_id": obj.sprite_index,
            "sprite_name": sprite_names[obj.sprite_index] if 0 <= obj.sprite_index < len(sprite_names) else None,
            "mask_id": obj.mask_index, "parent_id": obj.parent_index, "solid": obj.solid,
            "persistent": obj.persistent, "visible": obj.visible, "depth": obj.depth,
            "season_family": seasonal_family(obj.name),
            "events": [{"type": event.event_type, "subtype": event.subtype, "code_id": event.code_id, "code_name": game.code_entries[event.code_id].name if event.code_id in game.code_entries else None} for event in obj.events],
        })
    room_chunk_offsets = index_offsets(data, chunks["ROOM"])
    room_entries = []
    room_dir = output / "rooms"
    for room_id, room in sorted(game.rooms.items()):
        pointer = room_chunk_offsets[room_id]
        layers = parse_room_layers(data, pointer, sprite_names, object_names)
        instances = []
        for instance in room.instances:
            object_name = object_names[instance.object_id] if 0 <= instance.object_id < len(object_names) else "UNKNOWN"
            instances.append({
                "instance_id": instance.instance_id, "object_id": instance.object_id, "object_name": object_name,
                "season_family": seasonal_family(object_name), "x": instance.x, "y": instance.y,
                "scale": [instance.scale_x, instance.scale_y], "rotation": instance.rotation,
                "color": instance.colour, "image_index": instance.image_index, "image_speed": instance.image_speed,
                "layer_depth": instance.layer_depth, "creation_code_id": instance.creation_code_id,
            })
        room_ir = {
            "schema": "no-name-village.room-ir.v1", "id": room_id, "name": room.name,
            "caption": room.caption, "dimensions_px": [room.width, room.height], "speed": room.speed,
            "persistent": room.persistent, "color": room.colour, "creation_code_id": room.creation_code_id,
            "layers": layers, "instances": instances,
            "views": [vars(view) for view in room.views], "backgrounds": [vars(bg) for bg in room.backgrounds],
            "season_instance_counts": dict(Counter(row["season_family"] or "nonseasonal" for row in instances)),
        }
        path = room_dir / f"{room_id:03d}-{room.name}.json.gz"
        digest = write_gzip_json(path, room_ir)
        room_entries.append({
            "id": room_id, "name": room.name, "dimensions_px": [room.width, room.height],
            "layer_count": len(layers), "layer_types": dict(Counter(str(layer["type"]) for layer in layers)),
            "instance_count": len(instances), "season_instance_counts": room_ir["season_instance_counts"],
            "ir": str(path), "ir_json_sha256": digest,
        })
    code_rows = []
    for code_id, code in sorted(game.code_entries.items()):
        code_rows.append({
            "id": code_id, "name": code.name, "offset": code.offset, "length": code.length,
            "instruction_count": len(code.instructions),
            "string_refs": [game.strings[index] for index in code.string_refs if 0 <= index < len(game.strings)],
            "calls": code.calls, "variable_refs": code.variable_refs,
        })
    sounds = [{"id": sound.id, "name": sound.name, "file": sound.file, "type": sound.type, "volume": sound.volume, "pitch": sound.pitch, "preload": sound.preload, "audio_group": sound.audio_group, "data_offset": sound.data_offset, "data_size": sound.data_size} for sound in game.sounds.values()]
    season_resources = {
        "objects": [row for row in object_rows if row["season_family"] or re.search(r"season|snow", row["name"], re.I)],
        "sprites": [row for row in sprites if re.search(r"spring|summer|autumn|winter|snow|bgsmtree|bgautree|bgwntree", row["name"], re.I)],
        "code": [row for row in code_rows if re.search(r"season|spring|summer|autumn|winter|snow", row["name"], re.I)],
        "strings": [value for value in game.strings.strings if re.search(r"season|spring|summer|autumn|winter|snow", value, re.I)],
    }
    inventories = output / "inventories"
    for name, value in (("sprites", sprites), ("texture-page-items", tpag), ("tilesets", tilesets), ("objects", object_rows), ("sounds", sounds), ("code", code_rows), ("seasons", season_resources)):
        write_json(inventories / f"{name}.json", value, compact=True)
    report = {
        "schema": "no-name-village.global-ir.v1", "status": "SOURCE_EXTRACTED",
        "source": {"data_win": str(data_path), "sha256": EXPECTED_DATA_SHA256, "bytes": data_path.stat().st_size},
        "authority": {"gret_repository": "vaiserYT/GRET", "gret_commit": GRET_COMMIT, "undertale_mod_tool_reference_commit": "master checkout recorded in source audit"},
        "runtime_family": "GameMaker 2022.9+ VM data.win", "chunks": chunks,
        "counts": {"rooms": len(room_entries), "objects": len(object_rows), "sprites": len(sprites), "sounds": len(sounds), "code": len(code_rows), "strings": len(game.strings), "texture_pages": len(textures), "texture_page_items": len(tpag), "tilesets": len(tilesets)},
        "rooms": room_entries,
        "season_system": {
            "status": "SOURCE_PROVEN_PARTIAL_LOGIC", "states": list(SEASONS),
            "selection_variable": "season", "selection_scripts": ["scrseasonmap", "scrrmsummercount", "scrrmautumncount", "scrrmwintercount"],
            "seasonal_object_prefixes": SEASON_PREFIXES,
            "season_resource_counts": {key: len(value) for key, value in season_resources.items()},
            "note": "All season-specific room instances are preserved in IR. Exact VM branch semantics require a compatible bytecode decompiler before PMDO promotion.",
        },
        "day_night": {"status": "UNVERIFIED", "resource_name_matches": [value for value in game.strings.strings if re.search(r"day|night|dawn|dusk|morning|evening", value, re.I)][:500]},
        "outputs": {"root": str(output), "rooms": str(room_dir), "textures": str(output / "textures"), "inventories": str(inventories)},
    }
    write_json(output / "global-ir.json", report)
    return report


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("data_win", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--gret-root", type=Path, required=True)
    args = parser.parse_args()
    report = build_ir(args.data_win.resolve(), args.output.resolve(), args.gret_root.resolve())
    print(json.dumps({"status": report["status"], **report["counts"], "season": report["season_system"]["status"]}, sort_keys=True))
    return 0


if __name__ == "__main__": raise SystemExit(main())
