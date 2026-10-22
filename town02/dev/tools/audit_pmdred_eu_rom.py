#!/usr/bin/env python3
"""Audit and reproducibly extract PMD Red (Europe) Ground resources.

This tool is intentionally dependency-free.  It accepts only the exact European
ROM used as the content authority for New Era, validates its identity and the
embedded ``pksdir0`` Ground archive, decodes every BPL/BPC/BMA/BPA stream with
European runtime semantics, and recovers the executable's complete 262-entry
map resource table.  The European executable has 17 localized/background rows
that do not exist in the 245-entry US pret table; truncating at the US count
silently drops canonical EU dependencies.

The European BPC representation is compressed and is *not* the raw BPC layout
checked into pret/pmd-red.  ``--extract-dir`` writes normalized, uncompressed
BPC files so existing PMD Red tooling can consume them without silently using
US assets.  The report retains both physical-ROM and normalized hashes and all
source ranges.  ``--pret-map-bg`` optionally compares normalized EU semantics
with pret's US reference while separating harmless trailing zero padding from
content differences.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import struct
import sys
from collections import Counter
from pathlib import Path
from typing import Any, Sequence

TOOL_VERSION = "1.1.0"
REPORT_SCHEMA = "new-era.pmdred-eu-ground-audit.v2"

EXPECTED_ROM_SIZE = 33_554_432
EXPECTED_ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
EXPECTED_ROM_MD5 = "9837da1fdfe900c52f2109d9718d4e85"
ROM_ADDRESS_BASE = 0x08000000
GROUND_ARCHIVE_OFFSET = 0x01A20000
GROUND_ARCHIVE_ADDRESS = ROM_ADDRESS_BASE + GROUND_ARCHIVE_OFFSET
GROUND_ARCHIVE_COUNT = 724
GROUND_FILE_TABLE_RELATIVE_OFFSET = 24
MAP_FILES_TABLE_OFFSET = 0x00275CDC
MAP_FILES_TABLE_ADDRESS = ROM_ADDRESS_BASE + MAP_FILES_TABLE_OFFSET
# The EU table ends immediately before the resource-name string pool.  It has
# 262 rows; pret's US enum has only 245 and is not a valid regional bound.
MAP_FILES_TABLE_COUNT = 262
MAP_FILES_TABLE_FIELDS = ("bpl", "bpc", "bma", "bpa_0", "bpa_1", "bpa_2", "bpa_3")
EXPECTED_RESOURCE_COUNTS = {"bpl": 262, "bpc": 194, "bma": 201, "bpa": 67}

# These are separate runtime tables.  In particular, neither of their row
# counts is the map-files dependency-table count above.
GROUND_CONVERSION_TABLE_OFFSET = 0x002792B4
GROUND_CONVERSION_TABLE_ADDRESS = ROM_ADDRESS_BASE + GROUND_CONVERSION_TABLE_OFFSET
GROUND_CONVERSION_TABLE_COUNT = 246
GROUND_CONVERSION_TABLE_ROW_SIZE = 12
MAP_TO_DUNGEON_TABLE_OFFSET = 0x00274A04
MAP_TO_DUNGEON_TABLE_ADDRESS = ROM_ADDRESS_BASE + MAP_TO_DUNGEON_TABLE_OFFSET
MAP_TO_DUNGEON_TABLE_COUNT = 27
MAP_TO_DUNGEON_TABLE_ROW_SIZE = 12
DUNGEON_FLOOR_COUNT_TABLE_OFFSET = 0x002194B4
DUNGEON_FLOOR_COUNT_TABLE_ADDRESS = ROM_ADDRESS_BASE + DUNGEON_FLOOR_COUNT_TABLE_OFFSET
DUNGEON_FLOOR_COUNT_TABLE_COUNT = 64

# The EU executable functions recovered while deriving this parser.  These are
# evidence, not inputs to the decoder; the hash lock keeps the addresses exact.
EU_RUNTIME_EVIDENCE = {
    "ground_loader": "0x080A92AC",
    "dungeon_ground_loader": "0x080A971C",
    "bpc_tile_decoder": "0x080A9AA0",
    "bpc_chunk_decoder": "0x080A9BFC",
    "bma_layer_decoder": "0x080A9DDC",
    "map_files_table": f"0x{MAP_FILES_TABLE_ADDRESS:08X}",
    "ground_conversion_table": f"0x{GROUND_CONVERSION_TABLE_ADDRESS:08X}",
    "map_to_dungeon_table": f"0x{MAP_TO_DUNGEON_TABLE_ADDRESS:08X}",
    "dungeon_floor_count_table": f"0x{DUNGEON_FLOOR_COUNT_TABLE_ADDRESS:08X}",
    "archive_references": [
        "0x0802D1D2",
        "0x080A9568",
        "0x080A966C",
        "0x080A9714",
        "0x080A9A60",
    ],
}


class AuditError(RuntimeError):
    """A deterministic ROM/archive/decoder validation failure."""


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def align4(value: int) -> int:
    return (value + 3) & ~3


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AuditError(message)


def unpack_from(fmt: str, data: bytes, offset: int, context: str) -> tuple[Any, ...]:
    size = struct.calcsize(fmt)
    require(0 <= offset <= len(data) - size, f"{context}: truncated at 0x{offset:X}")
    return struct.unpack_from(fmt, data, offset)


def checked_byte(data: bytes, offset: int, context: str) -> int:
    require(0 <= offset < len(data), f"{context}: truncated at 0x{offset:X}")
    return data[offset]


def rom_offset(address: int, rom_size: int, context: str) -> int:
    offset = address - ROM_ADDRESS_BASE
    require(0 <= offset < rom_size, f"{context}: invalid ROM address 0x{address:08X}")
    return offset


def read_c_string(rom: bytes, address: int, context: str) -> str:
    offset = rom_offset(address, len(rom), context)
    end = rom.find(b"\0", offset, min(offset + 256, len(rom)))
    require(end >= 0, f"{context}: unterminated string at 0x{address:08X}")
    raw = rom[offset:end]
    try:
        value = raw.decode("ascii")
    except UnicodeDecodeError as exc:
        raise AuditError(f"{context}: non-ASCII string at 0x{address:08X}") from exc
    require(value != "", f"{context}: empty string at 0x{address:08X}")
    return value


def infer_bpa_names(archive_names: set[str], map_rows: Sequence[dict[str, Any]]) -> set[str]:
    """Recover referenced and orphaned BPA resources without suffix guessing alone."""
    referenced = {
        value
        for row in map_rows
        for key, value in row.items()
        if key.startswith("bpa_") and isinstance(value, str)
    }
    # BPA names are their owning palette/map stem plus a slot digit.  This
    # catches canonical orphan W03P011 while not misclassifying BPL names such
    # as S01 or W04 merely because they end in a digit.
    inferred_orphans = {
        name for name in archive_names if name[-1:].isdigit() and name[:-1] in archive_names
    }
    return referenced | inferred_orphans


def classify_resource(name: str, bpa_names: set[str]) -> str:
    if name in bpa_names:
        return "bpa"
    if name.endswith("c"):
        return "bpc"
    if name.endswith("m"):
        return "bma"
    return "bpl"


def decode_bpc_tiles(data: bytes, offset: int, target_size: int, context: str) -> tuple[bytes, int, dict[str, int]]:
    """Decode the EU bytewise BPC tile stream at runtime-equivalent granularity."""
    require(target_size >= 0 and target_size % 32 == 0, f"{context}: invalid tile target {target_size}")
    start = offset
    output = bytearray()
    repeat_current = 0
    repeat_previous = 0
    commands = 0

    while len(output) < target_size:
        command = checked_byte(data, offset, context)
        offset += 1
        commands += 1

        if command <= 0x7F:
            if command == 0x7F:
                (count,) = unpack_from("<H", data, offset, context)
                offset += 2
            elif command == 0x7E:
                count = checked_byte(data, offset, context)
                offset += 1
            else:
                count = command
            run = count + 1
            require(offset + run <= len(data), f"{context}: truncated literal run")
            output.extend(data[offset : offset + run])
            offset += run
        elif command <= 0xBF:
            if command == 0xBF:
                count = checked_byte(data, offset, context)
                offset += 1
            else:
                count = command - 0x80
            repeat_previous, repeat_current = repeat_current, checked_byte(data, offset, context)
            offset += 1
            output.extend(bytes((repeat_current,)) * (count + 1))
        elif command <= 0xDF:
            if command == 0xDF:
                count = checked_byte(data, offset, context)
                offset += 1
            else:
                count = command - 0xC0
            output.extend(bytes((repeat_current,)) * (count + 1))
        else:
            if command == 0xFF:
                count = checked_byte(data, offset, context)
                offset += 1
            else:
                count = command - 0xE0
            repeat_current, repeat_previous = repeat_previous, repeat_current
            output.extend(bytes((repeat_current,)) * (count + 1))

        require(commands <= max(1, target_size * 2), f"{context}: non-terminating tile stream")

    # EU CopyBpcTilesToVram rounds relative to the stream start, not globally.
    unaligned_end = offset
    if (offset - start) & 1:
        checked_byte(data, offset, context)
        offset += 1

    return bytes(output[:target_size]), offset, {
        "commands": commands,
        "produced": len(output),
        "target": target_size,
        "output_overshoot": len(output) - target_size,
        "compressed_bytes_before_halfword_alignment": unaligned_end - start,
        "halfword_alignment_bytes": offset - unaligned_end,
        "compressed_bytes_aligned": offset - start,
    }


def decode_byte_nrl(
    data: bytes,
    offset: int,
    target_size: int,
    context: str,
    *,
    keep_output: bool = True,
) -> tuple[bytes, int, dict[str, int]]:
    """Decode one BPC chunk byte-plane (zero/repeat/literal NRL)."""
    start = offset
    output = bytearray()
    commands = 0
    while len(output) < target_size:
        command = checked_byte(data, offset, context)
        offset += 1
        commands += 1
        # EU 0x080A9BFC uses three ranges.  The zero run has a full
        # seven-bit count (1..128); repeat and literal runs use six bits
        # (1..64).  Masking all commands with 0x3F is a subtle but destructive
        # error for zero commands 0x40..0x7F.
        run = command + 1 if command < 0x80 else (command & 0x3F) + 1
        if command < 0x80:
            output.extend(b"\0" * run)
        elif command < 0xC0:
            value = checked_byte(data, offset, context)
            offset += 1
            output.extend(bytes((value,)) * run)
        else:
            require(offset + run <= len(data), f"{context}: truncated NRL literal run")
            output.extend(data[offset : offset + run])
            offset += run
        require(commands <= max(1, target_size * 2), f"{context}: non-terminating NRL stream")
    result = bytes(output[:target_size]) if keep_output else b""
    return result, offset, {
        "commands": commands,
        "produced": len(output),
        "target": target_size,
        "output_overshoot": len(output) - target_size,
        "compressed_bytes": offset - start,
    }


def parse_bpc(data: bytes, context: str) -> tuple[bytes, int, dict[str, Any]]:
    header = unpack_from("<8H", data, 0, context)
    chunk_width, chunk_height, num_tiles = header[:3]
    bpa_slot_tiles = list(header[3:7])
    num_chunks = header[7]
    require((chunk_width, chunk_height) in ((2, 2), (3, 3)), f"{context}: invalid chunk dimensions {chunk_width}x{chunk_height}")
    require(1 <= num_tiles <= 1024, f"{context}: invalid tile count {num_tiles}")
    require(1 <= num_chunks <= 4096, f"{context}: invalid chunk count {num_chunks}")

    tile_target = (num_tiles - 1) * 32
    tiles, offset, tile_stats = decode_bpc_tiles(data, 16, tile_target, f"{context}/tiles")
    tile_stream_end = offset

    chunk_entries = (num_chunks - 1) * chunk_width * chunk_height
    high, offset, high_stats = decode_byte_nrl(data, offset, chunk_entries, f"{context}/chunks-high")
    high_stream_end = offset
    low, offset, low_stats = decode_byte_nrl(data, offset, chunk_entries, f"{context}/chunks-low")

    mappings = bytearray(chunk_entries * 2)
    max_tile_index = 0
    max_palette_index = 0
    for index, (lo, hi) in enumerate(zip(low, high)):
        value = lo | (hi << 8)
        struct.pack_into("<H", mappings, index * 2, value)
        max_tile_index = max(max_tile_index, value & 0x03FF)
        max_palette_index = max(max_palette_index, (value >> 12) & 0x0F)

    declared_tiles = num_tiles + sum(bpa_slot_tiles)
    # The 10-bit tilemap field may intentionally address VRAM padding outside
    # the embedded/BPA tile count (for example A01P01 uses 0x200/0x300 blank
    # sentinels).  The GBA loader fills part of that allocation separately, so
    # treating these values as malformed would reject canonical data.
    out_of_declared_tile_references = sum(
        1
        for index in range(chunk_entries)
        if (struct.unpack_from("<H", mappings, index * 2)[0] & 0x03FF) >= declared_tiles
    )
    normalized = data[:16] + tiles + bytes(mappings)
    require(len(normalized) == 16 + tile_target + chunk_entries * 2, f"{context}: normalized size mismatch")

    metadata: dict[str, Any] = {
        "header": {
            "chunk_width": chunk_width,
            "chunk_height": chunk_height,
            "num_tiles_including_null": num_tiles,
            "bpa_slot_tile_counts": bpa_slot_tiles,
            "num_chunks_including_null": num_chunks,
        },
        "tile_stream": {"start": 16, "end": tile_stream_end, **tile_stats},
        "chunk_high_stream": {"start": tile_stream_end, "end": high_stream_end, **high_stats},
        "chunk_low_stream": {"start": high_stream_end, "end": offset, **low_stats},
        "chunk_entry_count": chunk_entries,
        "max_referenced_tile_index": max_tile_index,
        "max_palette_index": max_palette_index,
        "declared_tile_count_with_bpa": declared_tiles,
        "out_of_declared_tile_reference_count": out_of_declared_tile_references,
        "normalized_size": len(normalized),
    }
    return normalized, offset, metadata


def decode_bma_layers(
    data: bytes, offset: int, width: int, height: int, layers: int, context: str
) -> tuple[list[list[int]], int, list[dict[str, Any]]]:
    decoded_layers: list[list[int]] = []
    layer_stats: list[dict[str, Any]] = []
    for layer_index in range(layers):
        memory: list[int] = []
        logical: list[int] = []
        layer_start = offset
        commands = 0
        row_output_overshoot = 0
        for row_index in range(height):
            row: list[int] = []
            produced = 0
            while produced < width:
                command = checked_byte(data, offset, f"{context}/layer-{layer_index}/row-{row_index}")
                offset += 1
                commands += 1
                run = (command & 0x3F) + 1
                pairs: list[tuple[int, int]] = []
                if command < 0x80:
                    pairs = [(0, 0)] * run
                elif command < 0xC0:
                    require(offset + 3 <= len(data), f"{context}: truncated repeated BMA pair")
                    value = int.from_bytes(data[offset : offset + 3], "little")
                    offset += 3
                    pairs = [(value & 0xFFF, (value >> 12) & 0xFFF)] * run
                else:
                    require(offset + run * 3 <= len(data), f"{context}: truncated literal BMA pairs")
                    for _ in range(run):
                        value = int.from_bytes(data[offset : offset + 3], "little")
                        offset += 3
                        pairs.append((value & 0xFFF, (value >> 12) & 0xFFF))

                for pair in pairs:
                    for value in pair:
                        if row_index:
                            require(len(row) < 64, f"{context}: BMA row exceeds runtime stride")
                            value ^= memory[(row_index - 1) * 64 + len(row)]
                        row.append(value)
                produced += run * 2

            require(len(row) <= 64, f"{context}: BMA row exceeds 64 chunks")
            row_output_overshoot += len(row) - width
            logical.extend(row[:width])
            memory.extend(row + [0] * (64 - len(row)))

        decoded_layers.append(logical)
        packed_logical = struct.pack(f"<{len(logical)}H", *logical)
        layer_stats.append({
            "layer": layer_index,
            "start": layer_start,
            "end": offset,
            "compressed_bytes": offset - layer_start,
            "commands": commands,
            "row_output_overshoot": row_output_overshoot,
            "min_chunk_id": min(logical, default=0),
            "max_chunk_id": max(logical, default=0),
            "unique_chunk_count": len(set(logical)),
            "decoded_chunk_ids_sha256": sha256(packed_logical),
        })
    return decoded_layers, offset, layer_stats


def decode_generic_nrl(
    data: bytes, offset: int, target_size: int, context: str
) -> tuple[bytes, int, dict[str, int]]:
    start = offset
    output = bytearray()
    commands = 0
    while len(output) < target_size:
        command = checked_byte(data, offset, context)
        offset += 1
        commands += 1
        run = command + 1 if command < 0x80 else (command & 0x3F) + 1
        if command < 0x80:
            output.extend(b"\0" * run)
        elif command < 0xC0:
            value = checked_byte(data, offset, context)
            offset += 1
            output.extend(bytes((value,)) * run)
        else:
            require(offset + run <= len(data), f"{context}: truncated generic NRL literal")
            output.extend(data[offset : offset + run])
            offset += run
    return bytes(output[:target_size]), offset, {
        "start": start,
        "end": offset,
        "compressed_bytes": offset - start,
        "commands": commands,
        "target": target_size,
        "produced": len(output),
        "output_overshoot": len(output) - target_size,
    }


def decode_collision_rle(
    data: bytes, offset: int, target_size: int, context: str
) -> tuple[bytes, int, dict[str, int]]:
    start = offset
    output = bytearray()
    commands = 0
    while len(output) < target_size:
        command = checked_byte(data, offset, context)
        offset += 1
        commands += 1
        output.extend(bytes((command >> 7,)) * ((command & 0x7F) + 1))
    return bytes(output[:target_size]), offset, {
        "start": start,
        "end": offset,
        "compressed_bytes": offset - start,
        "commands": commands,
        "target": target_size,
        "produced": len(output),
        "output_overshoot": len(output) - target_size,
    }


def parse_bma(data: bytes, context: str) -> tuple[bytes, int, dict[str, Any]]:
    require(len(data) >= 12, f"{context}: truncated BMA header")
    map_width_tiles, map_height_tiles, tiling_width, tiling_height, map_width_chunks, map_height_chunks = data[:6]
    num_layers, has_data_layer, collision_layers = unpack_from("<HHH", data, 6, context)
    require(1 <= map_width_tiles <= 255 and 1 <= map_height_tiles <= 255, f"{context}: invalid camera dimensions")
    require(1 <= map_width_chunks <= 64 and 1 <= map_height_chunks <= 64, f"{context}: invalid chunk dimensions")
    require(tiling_width in (2, 3) and tiling_height in (2, 3), f"{context}: invalid tiling {tiling_width}x{tiling_height}")
    require(num_layers in (1, 2), f"{context}: invalid layer count {num_layers}")
    require(has_data_layer in (0, 1), f"{context}: invalid data-layer flag {has_data_layer}")
    require(collision_layers in (0, 1, 2), f"{context}: invalid collision count {collision_layers}")

    layers, offset, layer_stats = decode_bma_layers(
        data, 12, map_width_chunks, map_height_chunks, num_layers, context
    )
    camera_cells = map_width_tiles * map_height_tiles
    data_stats = None
    if has_data_layer:
        decoded_data, offset, data_stats = decode_generic_nrl(
            data, offset, camera_cells, f"{context}/data-layer"
        )
        data_stats.update(
            {
                "decoded_sha256": sha256(decoded_data),
                "nonzero_cells": sum(bool(value) for value in decoded_data),
            }
        )
    collision_stats: list[dict[str, Any]] = []
    for layer_index in range(collision_layers):
        vertical_deltas, offset, stats = decode_collision_rle(
            data,
            offset,
            camera_cells,
            f"{context}/collision-{layer_index}",
        )
        decoded_collision = bytearray(camera_cells)
        for cell_index, delta in enumerate(vertical_deltas):
            above = (
                decoded_collision[cell_index - map_width_tiles]
                if cell_index >= map_width_tiles
                else 0
            )
            decoded_collision[cell_index] = delta ^ above
        solid_cells = sum(decoded_collision)
        stats.update(
            {
                "layer": layer_index,
                "decoded_sha256": sha256(bytes(decoded_collision)),
                "solid_cells": solid_cells,
                "walkable_cells": camera_cells - solid_cells,
            }
        )
        collision_stats.append(stats)

    all_chunk_ids = sorted({value for layer in layers for value in layer})
    metadata: dict[str, Any] = {
        "header": {
            "map_width_tiles": map_width_tiles,
            "map_height_tiles": map_height_tiles,
            "tiling_width": tiling_width,
            "tiling_height": tiling_height,
            "map_width_chunks": map_width_chunks,
            "map_height_chunks": map_height_chunks,
            "num_layers": num_layers,
            "has_data_layer": has_data_layer,
            "collision_layers": collision_layers,
        },
        "layer_streams": layer_stats,
        "data_layer_stream": data_stats,
        "collision_streams": collision_stats,
        "referenced_chunk_ids": all_chunk_ids,
        "referenced_nonzero_chunk_count": sum(value != 0 for value in all_chunk_ids),
        "max_referenced_chunk_id": max(all_chunk_ids, default=0),
    }
    return data[:offset], offset, metadata


def parse_bpl(data: bytes, context: str) -> tuple[bytes, int, dict[str, Any]]:
    num_palettes, has_animations = unpack_from("<hh", data, 0, context)
    require(0 <= num_palettes <= 16, f"{context}: invalid palette count {num_palettes}")
    require(has_animations in (0, 1), f"{context}: invalid animation flag {has_animations}")
    offset = 4 + num_palettes * 60
    require(offset <= len(data), f"{context}: truncated palettes")
    specifications: list[dict[str, int]] = []
    if has_animations:
        specs_offset = offset
        for index in range(num_palettes):
            duration, frames = unpack_from("<hh", data, specs_offset + index * 4, context)
            require(duration >= 0 and frames >= 0, f"{context}: invalid animation specification {index}")
            specifications.append({"palette": index, "duration_per_frame": duration, "num_frames": frames})
        offset += num_palettes * 4 + sum(spec["num_frames"] * 60 for spec in specifications)
        require(offset <= len(data), f"{context}: truncated animated palettes")
    return data[:offset], offset, {
        "header": {"num_palettes": num_palettes, "has_palette_animations": has_animations},
        "animation_specifications": specifications,
    }


def parse_bpa(data: bytes, context: str) -> tuple[bytes, int, dict[str, Any]]:
    num_tiles = checked_byte(data, 0, context)
    (num_frames,) = unpack_from("<h", data, 2, context)
    require(1 <= num_tiles <= 255, f"{context}: invalid BPA tile count {num_tiles}")
    require(1 <= num_frames <= 4096, f"{context}: invalid BPA frame count {num_frames}")
    offset = 4 + num_frames * 4 + num_tiles * num_frames * 32
    require(offset <= len(data), f"{context}: truncated BPA data")
    durations = [unpack_from("<i", data, 4 + index * 4, context)[0] for index in range(num_frames)]
    require(all(value >= 0 for value in durations), f"{context}: negative BPA frame duration")
    return data[:offset], offset, {
        "header": {"num_tiles": num_tiles, "num_frames": num_frames},
        "frame_durations": durations,
    }


def parse_resource(data: bytes, resource_type: str, context: str) -> tuple[bytes, int, dict[str, Any]]:
    if resource_type == "bpl":
        return parse_bpl(data, context)
    if resource_type == "bpc":
        return parse_bpc(data, context)
    if resource_type == "bma":
        return parse_bma(data, context)
    if resource_type == "bpa":
        return parse_bpa(data, context)
    raise AuditError(f"{context}: unsupported resource type {resource_type}")


def validate_rom(rom: bytes) -> dict[str, Any]:
    actual_sha256 = sha256(rom)
    actual_md5 = hashlib.md5(rom).hexdigest()  # nosec - identity metadata, not security
    require(len(rom) == EXPECTED_ROM_SIZE, f"ROM size is {len(rom):,}; expected {EXPECTED_ROM_SIZE:,}")
    require(actual_sha256 == EXPECTED_ROM_SHA256, f"ROM SHA-256 {actual_sha256} is not the authoritative EU ROM")
    require(actual_md5 == EXPECTED_ROM_MD5, f"ROM MD5 {actual_md5} does not match the authoritative EU ROM")
    return {"size": len(rom), "sha256": actual_sha256, "md5": actual_md5}


def parse_archive_rows(rom: bytes) -> list[dict[str, Any]]:
    base = GROUND_ARCHIVE_OFFSET
    require(rom[base : base + 8] == b"pksdir0\0", "Ground archive magic mismatch")
    (count,) = unpack_from("<I", rom, base + 8, "Ground archive")
    (table_address,) = unpack_from("<I", rom, base + 12, "Ground archive")
    require(count == GROUND_ARCHIVE_COUNT, f"Ground archive has {count} entries; expected {GROUND_ARCHIVE_COUNT}")
    require(table_address == GROUND_ARCHIVE_ADDRESS + GROUND_FILE_TABLE_RELATIVE_OFFSET, f"unexpected Ground table pointer 0x{table_address:08X}")
    require(rom[base + 16 : base + 24] == b"pksdir0\0", "embedded Ground table magic mismatch")

    rows: list[dict[str, Any]] = []
    table_offset = rom_offset(table_address, len(rom), "Ground table")
    for index in range(count):
        name_address, data_address = unpack_from("<II", rom, table_offset + index * 8, f"Ground entry {index}")
        name = read_c_string(rom, name_address, f"Ground entry {index} name")
        rows.append({
            "index": index,
            "name": name,
            "name_address": name_address,
            "name_offset": rom_offset(name_address, len(rom), f"Ground entry {index} name"),
            "data_address": data_address,
            "data_offset": rom_offset(data_address, len(rom), f"Ground entry {index} data"),
        })

    names = [row["name"] for row in rows]
    pointers = [row["data_address"] for row in rows]
    require(names == sorted(names), "Ground archive names are not lexicographically sorted")
    require(len(names) == len(set(names)), "Ground archive has duplicate names")
    require(len(pointers) == len(set(pointers)), "Ground archive has duplicate data pointers")
    return rows


def parse_map_files_table(rom: bytes) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for map_id in range(MAP_FILES_TABLE_COUNT):
        addresses = unpack_from("<7I", rom, MAP_FILES_TABLE_OFFSET + map_id * 28, f"map file row {map_id}")
        fields: dict[str, str | None] = {}
        pointer_fields: dict[str, str | None] = {}
        for field, address in zip(MAP_FILES_TABLE_FIELDS, addresses):
            fields[field] = read_c_string(rom, address, f"map file row {map_id}/{field}") if address else None
            pointer_fields[field] = f"0x{address:08X}" if address else None
        rows.append({"map_file_id": map_id, **fields, "name_pointers": pointer_fields})
    return rows


def parse_ground_conversion_table(
    rom: bytes, map_file_rows: Sequence[dict[str, Any]]
) -> list[dict[str, Any]]:
    """Decode the EU Ground-map table without applying US enum bounds."""
    require(
        len(map_file_rows) == MAP_FILES_TABLE_COUNT,
        "Ground conversion parsing requires the complete EU map-files table",
    )
    table_end = (
        GROUND_CONVERSION_TABLE_OFFSET
        + GROUND_CONVERSION_TABLE_COUNT * GROUND_CONVERSION_TABLE_ROW_SIZE
    )
    require(
        rom[table_end:table_end + len(b"__ground_amd")] == b"__ground_amd",
        "Ground conversion table does not end at the adjacent debug-string pool",
    )

    rows: list[dict[str, Any]] = []
    for map_id in range(GROUND_CONVERSION_TABLE_COUNT):
        offset = GROUND_CONVERSION_TABLE_OFFSET + map_id * GROUND_CONVERSION_TABLE_ROW_SIZE
        conversion_type, ground_place_id, map_file_id, weather_id, text_address = unpack_from(
            "<hhhhI", rom, offset, f"Ground conversion row {map_id}"
        )
        require(
            conversion_type in {1, 2, 3, 4, 5, 6, 9, 10, 11},
            f"Ground conversion row {map_id}: invalid type {conversion_type}",
        )
        require(
            0 <= map_file_id < len(map_file_rows),
            f"Ground conversion row {map_id}: map-file ID {map_file_id} is out of range",
        )
        debug_string = read_c_string(
            rom, text_address, f"Ground conversion row {map_id} debug string"
        )
        prefix = "__ground_amd_conversion_"
        require(
            debug_string.startswith(prefix)
            and len(debug_string) == len(prefix) + 5
            and debug_string[len(prefix):].isdigit(),
            f"Ground conversion row {map_id}: malformed debug string {debug_string!r}",
        )
        map_file = map_file_rows[map_file_id]
        rows.append({
            "map_id": map_id,
            "conversion_type": conversion_type,
            "ground_place_id": ground_place_id,
            "map_file_id": map_file_id,
            "stable_ground_id": str(map_file["bpl"]).lower(),
            "weather_id": weather_id,
            "debug_string_address": f"0x{text_address:08X}",
            "debug_string": debug_string,
            "canonical_debug_id": int(debug_string[len(prefix):]),
        })

    map_file_ids = [row["map_file_id"] for row in rows]
    require(
        len(map_file_ids) == len(set(map_file_ids)),
        "Ground conversion table unexpectedly reuses a map-file ID",
    )
    return rows


def parse_dungeon_floor_counts(rom: bytes) -> list[dict[str, int]]:
    start = DUNGEON_FLOOR_COUNT_TABLE_OFFSET
    end = start + DUNGEON_FLOOR_COUNT_TABLE_COUNT
    require(end <= len(rom), "dungeon floor-count table is truncated")
    counts = rom[start:end]
    require(all(0 < count <= 100 for count in counts), "invalid EU dungeon floor count")
    return [
        {"dungeon_id": dungeon_id, "floor_count": floor_count}
        for dungeon_id, floor_count in enumerate(counts)
    ]


def parse_map_to_dungeon_table(
    rom: bytes,
    conversion_rows: Sequence[dict[str, Any]],
    floor_count_rows: Sequence[dict[str, int]],
) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    """Decode all runtime dungeon-backed Grounds and the terminal sentinel."""
    floor_counts = [row["floor_count"] for row in floor_count_rows]
    rows: list[dict[str, Any]] = []
    for index in range(MAP_TO_DUNGEON_TABLE_COUNT):
        offset = MAP_TO_DUNGEON_TABLE_OFFSET + index * MAP_TO_DUNGEON_TABLE_ROW_SIZE
        map_id, dungeon_id, requested_floor, variant = unpack_from(
            "<h2xBB2xI", rom, offset, f"map-to-dungeon row {index}"
        )
        require(0 <= map_id < len(conversion_rows), f"map-to-dungeon row {index}: bad map ID")
        require(
            0 <= dungeon_id < len(floor_counts),
            f"map-to-dungeon row {index}: bad dungeon ID {dungeon_id}",
        )
        conversion = conversion_rows[map_id]
        require(
            conversion["conversion_type"] in (10, 11),
            f"map-to-dungeon row {index}: map {map_id} is not dungeon-backed",
        )
        floor_count = floor_counts[dungeon_id]
        rows.append({
            "index": index,
            "map_id": map_id,
            "stable_ground_id": conversion["stable_ground_id"],
            "map_file_id": conversion["map_file_id"],
            "conversion_type": conversion["conversion_type"],
            "dungeon_id": dungeon_id,
            "requested_floor_zero_based": requested_floor,
            "runtime_floor_zero_based": min(requested_floor, floor_count - 1),
            "dungeon_floor_count": floor_count,
            "variant": variant,
        })

    sentinel_offset = (
        MAP_TO_DUNGEON_TABLE_OFFSET
        + MAP_TO_DUNGEON_TABLE_COUNT * MAP_TO_DUNGEON_TABLE_ROW_SIZE
    )
    sentinel_id, sentinel_dungeon, sentinel_floor, sentinel_variant = unpack_from(
        "<h2xBB2xI", rom, sentinel_offset, "map-to-dungeon sentinel"
    )
    require(sentinel_id == -1, "map-to-dungeon table has no terminal -1 sentinel")
    sentinel = {
        "offset": sentinel_offset,
        "offset_hex": f"0x{sentinel_offset:08X}",
        "map_id": sentinel_id,
        "dungeon_id": sentinel_dungeon,
        "requested_floor_zero_based": sentinel_floor,
        "variant": sentinel_variant,
    }

    dungeon_maps = {
        row["map_id"] for row in conversion_rows if row["conversion_type"] in (10, 11)
    }
    require(
        {row["map_id"] for row in rows} == dungeon_maps,
        "map-to-dungeon rows do not exactly cover conversion types 10 and 11",
    )
    return rows, sentinel


def resource_extension(resource_type: str) -> str:
    return "." + resource_type


def compare_pret_reference(
    resources: list[dict[str, Any]],
    normalized_by_name: dict[str, bytes],
    map_bg_dir: Path,
) -> dict[str, Any]:
    """Compare EU semantic payloads to pret's US files without padding noise."""
    require(map_bg_dir.is_dir(), f"pret map_bg directory does not exist: {map_bg_dir}")
    entries: list[dict[str, Any]] = []
    outcomes: Counter[str] = Counter()
    outcomes_by_type: dict[str, Counter[str]] = {}
    eu_names = {record["name"] for record in resources}

    for record in resources:
        name = record["name"]
        resource_type = record["type"]
        eu = normalized_by_name[name]
        reference_path = map_bg_dir / (name + resource_extension(resource_type))
        entry: dict[str, Any] = {
            "name": name,
            "type": resource_type,
            "eu_size": len(eu),
            "eu_normalized_sha256": sha256(eu),
        }
        if not reference_path.is_file():
            outcome = "eu_only"
            entry.update({
                "outcome": outcome,
                "reference_size": None,
                "reference_sha256": None,
                "first_content_difference": None,
            })
        else:
            reference = reference_path.read_bytes()
            if eu == reference:
                outcome = "exact"
                first_difference = None
                reference_padding = 0
            elif eu == reference[: len(eu)] and all(value == 0 for value in reference[len(eu) :]):
                outcome = "reference_zero_padding_only"
                first_difference = None
                reference_padding = len(reference) - len(eu)
            else:
                outcome = "content_difference"
                first_difference = next(
                    (index for index, pair in enumerate(zip(eu, reference)) if pair[0] != pair[1]),
                    min(len(eu), len(reference)),
                )
                reference_padding = None
            entry.update({
                "outcome": outcome,
                "reference_size": len(reference),
                "reference_sha256": sha256(reference),
                "first_content_difference": first_difference,
                "reference_trailing_zero_padding_bytes": reference_padding,
            })
        outcomes[outcome] += 1
        outcomes_by_type.setdefault(resource_type, Counter())[outcome] += 1
        entries.append(entry)

    supported_files = sorted(
        path
        for path in map_bg_dir.iterdir()
        if path.is_file() and path.suffix.lstrip(".") in EXPECTED_RESOURCE_COUNTS
    )
    reference_only = sorted(path.stem for path in supported_files if path.stem not in eu_names)
    return {
        "performed": True,
        "reference": "pret/pmd-red data/map_bg (US)",
        "comparison_basis": "EU semantic payload; EU BPC normalized to raw layout",
        "padding_policy": "trailing reference zero bytes are reported separately, not as content differences",
        "eu_resource_count": len(resources),
        "reference_resource_count": len(supported_files),
        "shared_resource_count": len(resources) - outcomes["eu_only"],
        "outcomes": dict(sorted(outcomes.items())),
        "outcomes_by_type": {
            resource_type: dict(sorted(type_outcomes.items()))
            for resource_type, type_outcomes in sorted(outcomes_by_type.items())
        },
        "eu_only_resources": [entry["name"] for entry in entries if entry["outcome"] == "eu_only"],
        "reference_only_resources": reference_only,
        "content_difference_resources": [
            entry["name"] for entry in entries if entry["outcome"] == "content_difference"
        ],
        "entries": entries,
    }


def audit_rom(
    rom: bytes,
    source_name: str,
    extract_dir: Path | None = None,
    pret_map_bg: Path | None = None,
) -> dict[str, Any]:
    rom_identity = validate_rom(rom)
    archive_rows = parse_archive_rows(rom)
    map_rows = parse_map_files_table(rom)
    conversion_rows = parse_ground_conversion_table(rom, map_rows)
    floor_count_rows = parse_dungeon_floor_counts(rom)
    map_to_dungeon_rows, map_to_dungeon_sentinel = parse_map_to_dungeon_table(
        rom, conversion_rows, floor_count_rows
    )
    archive_names = {row["name"] for row in archive_rows}
    bpa_names = infer_bpa_names(archive_names, map_rows)

    sorted_offsets = sorted(row["data_offset"] for row in archive_rows)
    next_by_offset = {
        offset: sorted_offsets[index + 1] if index + 1 < len(sorted_offsets) else None
        for index, offset in enumerate(sorted_offsets)
    }

    resources: list[dict[str, Any]] = []
    parsed_by_name: dict[str, dict[str, Any]] = {}
    normalized_by_name: dict[str, bytes] = {}
    for row in archive_rows:
        name = row["name"]
        resource_type = classify_resource(name, bpa_names)
        start = row["data_offset"]
        next_offset = next_by_offset[start]
        decoded, read_extent, format_metadata = parse_resource(rom[start:], resource_type, name)
        read_end = start + read_extent
        require(read_end <= len(rom), f"{name}: decoder read beyond ROM")

        pointer_span = next_offset - start if next_offset is not None else None
        decoder_overread = max(0, read_end - next_offset) if next_offset is not None else 0
        pointer_slack = max(0, next_offset - read_end) if next_offset is not None else None
        aligned_read_extent = align4(read_extent)
        alignment_slack = (
            next_offset - (start + aligned_read_extent) if next_offset is not None else None
        )
        physical_end = next_offset if next_offset is not None else start + aligned_read_extent
        require(physical_end <= len(rom), f"{name}: physical range beyond ROM")
        physical = rom[start:physical_end]
        consumed = rom[start:read_end]
        slack_bytes = rom[read_end:next_offset] if next_offset is not None and read_end <= next_offset else b""

        record: dict[str, Any] = {
            **row,
            "data_address_hex": f"0x{row['data_address']:08X}",
            "data_offset_hex": f"0x{start:08X}",
            "type": resource_type,
            "next_data_offset": next_offset,
            "next_data_offset_hex": f"0x{next_offset:08X}" if next_offset is not None else None,
            "pointer_span": pointer_span,
            "decoder_read_extent": read_extent,
            "decoder_read_end": read_end,
            "decoder_read_end_hex": f"0x{read_end:08X}",
            "decoder_overread_past_next_pointer": decoder_overread,
            "pointer_slack_after_decoder": pointer_slack,
            "four_byte_aligned_read_extent": aligned_read_extent,
            "pointer_slack_after_four_byte_alignment": alignment_slack,
            "slack_is_all_zero": all(value == 0 for value in slack_bytes),
            "physical_pointer_span_sha256": sha256(physical),
            "decoder_consumed_sha256": sha256(consumed),
            "normalized_size": len(decoded),
            "normalized_sha256": sha256(decoded),
            "format": format_metadata,
        }
        resources.append(record)
        parsed_by_name[name] = record
        normalized_by_name[name] = decoded

    counts = Counter(record["type"] for record in resources)
    require(dict(counts) == EXPECTED_RESOURCE_COUNTS, f"resource counts {dict(counts)} do not match {EXPECTED_RESOURCE_COUNTS}")

    dependency_errors: list[str] = []
    dependency_warnings: list[str] = []
    referenced_names: set[str] = set()
    dependencies: list[dict[str, Any]] = []
    for source in map_rows:
        row = dict(source)
        names = [row[field] for field in MAP_FILES_TABLE_FIELDS if row[field] is not None]
        referenced_names.update(names)
        missing = [name for name in names if name not in archive_names]
        if missing:
            dependency_errors.append(f"map {row['map_file_id']}: missing archive resources {missing}")
            row["validation"] = {"missing_resources": missing}
            dependencies.append(row)
            continue

        bpl = parsed_by_name[row["bpl"]]
        bpc = parsed_by_name[row["bpc"]]
        bma = parsed_by_name[row["bma"]]
        if bpl["type"] != "bpl" or bpc["type"] != "bpc" or bma["type"] != "bma":
            dependency_errors.append(f"map {row['map_file_id']}: core resource type mismatch")

        num_chunks = bpc["format"]["header"]["num_chunks_including_null"]
        max_chunk = bma["format"]["max_referenced_chunk_id"]
        if max_chunk >= num_chunks:
            dependency_errors.append(
                f"map {row['map_file_id']}: BMA chunk {max_chunk} exceeds BPC count {num_chunks}"
            )

        bpa_validation: list[dict[str, Any]] = []
        slot_counts = bpc["format"]["header"]["bpa_slot_tile_counts"]
        for slot in range(4):
            bpa_name = row[f"bpa_{slot}"]
            declared_tiles = slot_counts[slot]
            actual_tiles = None
            if bpa_name is not None:
                bpa = parsed_by_name[bpa_name]
                actual_tiles = bpa["format"]["header"]["num_tiles"]
                if bpa["type"] != "bpa":
                    dependency_errors.append(f"map {row['map_file_id']}: {bpa_name} is not BPA")
                if actual_tiles != declared_tiles:
                    dependency_errors.append(
                        f"map {row['map_file_id']}: BPA slot {slot} declares {declared_tiles} tiles but {bpa_name} has {actual_tiles}"
                    )
            elif declared_tiles:
                dependency_warnings.append(
                    f"map {row['map_file_id']}: slot {slot} reserves {declared_tiles} BPA tiles without a file"
                )
            bpa_validation.append({
                "slot": slot,
                "resource": bpa_name,
                "bpc_declared_tiles": declared_tiles,
                "bpa_header_tiles": actual_tiles,
            })

        row["validation"] = {
            "bpc_num_chunks_including_null": num_chunks,
            "bma_max_referenced_chunk_id": max_chunk,
            "bma_referenced_chunk_ids": bma["format"]["referenced_chunk_ids"],
            "unused_bpc_chunk_count": max(0, num_chunks - 1 - bma["format"]["referenced_nonzero_chunk_count"]),
            "bpa_slots": bpa_validation,
        }
        dependencies.append(row)

    require(not dependency_errors, "dependency validation failed:\n" + "\n".join(dependency_errors))

    if extract_dir is not None:
        extract_dir.mkdir(parents=True, exist_ok=True)
        for record in resources:
            output_path = extract_dir / (record["name"] + resource_extension(record["type"]))
            output_path.write_bytes(normalized_by_name[record["name"]])

    overreads = [record for record in resources if record["decoder_overread_past_next_pointer"]]
    unreferenced = sorted(archive_names - referenced_names)
    pret_comparison = (
        compare_pret_reference(resources, normalized_by_name, pret_map_bg)
        if pret_map_bg is not None
        else {"performed": False}
    )
    report: dict[str, Any] = {
        "schema": REPORT_SCHEMA,
        "tool": {"name": "audit_pmdred_eu_rom.py", "version": TOOL_VERSION},
        "authority": {
            "source_filename": source_name,
            "game": "Pokemon Mystery Dungeon - Red Rescue Team (Europe) (En,Fr,De,Es,It)",
            "rom": rom_identity,
        },
        "runtime_evidence": EU_RUNTIME_EVIDENCE,
        "ground_archive": {
            "offset": GROUND_ARCHIVE_OFFSET,
            "offset_hex": f"0x{GROUND_ARCHIVE_OFFSET:08X}",
            "address_hex": f"0x{GROUND_ARCHIVE_ADDRESS:08X}",
            "magic": "pksdir0",
            "entry_count": len(resources),
            "resource_counts": dict(sorted(counts.items())),
            "names_lexicographically_sorted": True,
            "unique_names": True,
            "unique_data_pointers": True,
            "decoder_overread_record_count": len(overreads),
            "decoder_overread_resources": [
                {
                    "name": record["name"],
                    "bytes": record["decoder_overread_past_next_pointer"],
                    "next_resource_offset_hex": record["next_data_offset_hex"],
                }
                for record in overreads
            ],
            "referenced_resource_count": len(referenced_names),
            "unreferenced_resource_count": len(unreferenced),
            "unreferenced_resources": unreferenced,
            "resources": resources,
        },
        "map_files_table": {
            "offset": MAP_FILES_TABLE_OFFSET,
            "offset_hex": f"0x{MAP_FILES_TABLE_OFFSET:08X}",
            "address_hex": f"0x{MAP_FILES_TABLE_ADDRESS:08X}",
            "entry_count": len(dependencies),
            "dependency_warning_count": len(dependency_warnings),
            "dependency_warnings": dependency_warnings,
            "entries": dependencies,
        },
        "ground_conversion_table": {
            "offset": GROUND_CONVERSION_TABLE_OFFSET,
            "offset_hex": f"0x{GROUND_CONVERSION_TABLE_OFFSET:08X}",
            "address_hex": f"0x{GROUND_CONVERSION_TABLE_ADDRESS:08X}",
            "entry_count": len(conversion_rows),
            "conversion_type_counts": dict(sorted(Counter(
                row["conversion_type"] for row in conversion_rows
            ).items())),
            "referenced_map_file_count": len({
                row["map_file_id"] for row in conversion_rows
            }),
            "unreferenced_map_file_ids": sorted(
                set(range(MAP_FILES_TABLE_COUNT))
                - {row["map_file_id"] for row in conversion_rows}
            ),
            "boundary_evidence": "next bytes begin the adjacent __ground_amd debug-string pool",
            "entries": conversion_rows,
        },
        "map_to_dungeon_table": {
            "offset": MAP_TO_DUNGEON_TABLE_OFFSET,
            "offset_hex": f"0x{MAP_TO_DUNGEON_TABLE_OFFSET:08X}",
            "address_hex": f"0x{MAP_TO_DUNGEON_TABLE_ADDRESS:08X}",
            "entry_count": len(map_to_dungeon_rows),
            "sentinel": map_to_dungeon_sentinel,
            "entries": map_to_dungeon_rows,
        },
        "dungeon_floor_count_table": {
            "offset": DUNGEON_FLOOR_COUNT_TABLE_OFFSET,
            "offset_hex": f"0x{DUNGEON_FLOOR_COUNT_TABLE_OFFSET:08X}",
            "address_hex": f"0x{DUNGEON_FLOOR_COUNT_TABLE_ADDRESS:08X}",
            "entry_count": len(floor_count_rows),
            "entries": floor_count_rows,
        },
        "extraction": {
            "performed": extract_dir is not None,
            "representation": "semantic BPL/BMA/BPA; normalized uncompressed BPC",
            "resource_count": len(resources) if extract_dir is not None else 0,
        },
        "pret_comparison": pret_comparison,
        "validation": {
            "status": "pass",
            "malformed_stream_count": 0,
            "dependency_error_count": 0,
        },
    }
    return report


def summarize(report: dict[str, Any]) -> str:
    archive = report["ground_archive"]
    table = report["map_files_table"]
    conversions = report["ground_conversion_table"]
    dungeon_maps = report["map_to_dungeon_table"]
    floor_counts = report["dungeon_floor_count_table"]
    rom = report["authority"]["rom"]
    return "\n".join(
        (
            f"PASS: authoritative EU ROM {rom['sha256']}",
            f"Ground archive: {archive['entry_count']} resources {archive['resource_counts']}",
            f"Map dependency table: {table['entry_count']} entries, {table['dependency_warning_count']} warnings",
            f"Ground conversion table: {conversions['entry_count']} entries {conversions['conversion_type_counts']}",
            f"Dungeon-backed Grounds/floor counts: {dungeon_maps['entry_count']}/{floor_counts['entry_count']}",
            f"BPC decoder reads past the next archive pointer: {archive['decoder_overread_record_count']}",
            f"Referenced/unreferenced resources: {archive['referenced_resource_count']}/{archive['unreferenced_resource_count']}",
            *(
                (f"pret comparison outcomes: {report['pret_comparison']['outcomes']}",)
                if report["pret_comparison"]["performed"]
                else ()
            ),
        )
    )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("rom", type=Path, help="authoritative European PMD Red .gba file")
    parser.add_argument("--report", type=Path, help="write the complete JSON evidence report")
    parser.add_argument(
        "--extract-dir",
        type=Path,
        help="write all 724 canonical resources (BPC is normalized/uncompressed)",
    )
    parser.add_argument(
        "--pret-map-bg",
        type=Path,
        help="optionally compare against a pret/pmd-red data/map_bg directory",
    )
    parser.add_argument("--compact", action="store_true", help="write compact rather than indented JSON")
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        rom = args.rom.read_bytes()
        report = audit_rom(rom, args.rom.name, args.extract_dir, args.pret_map_bg)
        if args.report:
            args.report.parent.mkdir(parents=True, exist_ok=True)
            with args.report.open("w", encoding="utf-8", newline="\n") as stream:
                json.dump(
                    report,
                    stream,
                    ensure_ascii=False,
                    sort_keys=True,
                    indent=None if args.compact else 2,
                    separators=(",", ":") if args.compact else None,
                )
                stream.write("\n")
        print(summarize(report))
        if args.report:
            print(f"Report: {args.report}")
        if args.extract_dir:
            print(f"Extracted resources: {args.extract_dir}")
        return 0
    except (AuditError, OSError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
