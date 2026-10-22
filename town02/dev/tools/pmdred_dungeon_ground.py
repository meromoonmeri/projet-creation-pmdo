#!/usr/bin/env python3
"""EU-ROM-backed reconstruction primitives for dungeon-rendered Ground maps.

This module adapts the existing regional Ground audit instead of replacing it.
It implements the separate runtime path used by ``GroundMap_SelectDungeon``:
strict AT4PX decoding, SIRO absolute-pointer resolution, mapparam selection,
deterministic CEX variant-zero composition, direct EMAP composition, palette
cycles, and GBA-quantized reference rendering.
"""

from __future__ import annotations

import hashlib
import heapq
import math
import struct
from collections.abc import Iterable, Sequence
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from PIL import Image

GBA_ROM_BASE = 0x08000000
DUNGEON_ARCHIVE_OFFSET = 0x0063F000
DUNGEON_ARCHIVE_MAGIC = b"pksdir0\0"
DUNGEON_ARCHIVE_COUNT = 803
GRAPHICS_REMAP_OFFSET = 0x0021ABCC
GRAPHICS_REMAP_COUNT = 80
WATER_TYPE_OFFSET = 0x00272D28
WATER_TYPE_COUNT = 76
DUNGEON_NAME_OFFSET = 0x000EDE84
DUNGEON_NAME_COUNT = 98
MATERIAL_STRIDE = 64
SPECIAL_MAP_SIZE = 24
GROUND_TILE_COUNT = 512
GROUND_CHUNK_COUNT = 250
GROUND_PALETTE_COUNT = 12
GBA_MASTER_CLOCK_HZ = 16_777_216
GBA_CYCLES_PER_FRAME = 280_896
GBA_FRAME_RATE_HZ = GBA_MASTER_CLOCK_HZ / GBA_CYCLES_PER_FRAME
CEL_DECOMPRESSED_SIZE = GROUND_CHUNK_COUNT * 9 * 2
CEX_DECOMPRESSED_SIZE = 0x930
EMAP_DECOMPRESSED_SIZE = SPECIAL_MAP_SIZE * SPECIAL_MAP_SIZE
EXPECTED_EU_ROM_SHA256 = (
    "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
)


class ReconstructionError(ValueError):
    """Raised when authoritative bytes violate a required runtime invariant."""


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ReconstructionError(message)


@dataclass(frozen=True)
class PhysicalSpan:
    """A concrete byte range in the ROM, with both file and GBA addresses."""

    offset: int
    size: int
    purpose: str

    @property
    def end(self) -> int:
        return self.offset + self.size

    @property
    def address(self) -> int:
        return self.offset + GBA_ROM_BASE

    def as_dict(self) -> dict[str, Any]:
        return {
            "purpose": self.purpose,
            "offset": self.offset,
            "offset_hex": f"0x{self.offset:08X}",
            "address_hex": f"0x{self.address:08X}",
            "size": self.size,
            "end_offset": self.end,
            "end_offset_hex": f"0x{self.end:08X}",
        }


class RomView:
    """Bounds-checked ROM reads and absolute GBA pointer resolution."""

    def __init__(self, data: bytes):
        self.data = data

    def span(self, offset: int, size: int, purpose: str) -> PhysicalSpan:
        require(offset >= 0, f"{purpose}: negative ROM offset")
        require(size >= 0, f"{purpose}: negative span size")
        require(offset + size <= len(self.data), f"{purpose}: span exceeds ROM")
        return PhysicalSpan(offset, size, purpose)

    def resolve(
        self,
        address: int,
        size: int,
        purpose: str,
        *,
        alignment: int | None = None,
    ) -> PhysicalSpan:
        require(
            GBA_ROM_BASE <= address < GBA_ROM_BASE + len(self.data),
            f"{purpose}: invalid absolute ROM pointer 0x{address:08X}",
        )
        if alignment is not None:
            require(
                address % alignment == 0,
                f"{purpose}: unaligned pointer 0x{address:08X}",
            )
        return self.span(address - GBA_ROM_BASE, size, purpose)

    def bytes(self, span: PhysicalSpan) -> bytes:
        return self.data[span.offset : span.end]

    def u32(self, offset: int, purpose: str) -> int:
        self.span(offset, 4, purpose)
        return struct.unpack_from("<I", self.data, offset)[0]

    def c_string(
        self, address: int, purpose: str, *, max_size: int = 256
    ) -> tuple[str, PhysicalSpan]:
        start = self.resolve(address, 1, purpose).offset
        end_limit = min(len(self.data), start + max_size)
        end = self.data.find(b"\0", start, end_limit)
        require(end >= 0, f"{purpose}: unterminated string")
        raw = self.data[start:end]
        try:
            text = raw.decode("ascii")
        except UnicodeDecodeError as exc:
            raise ReconstructionError(f"{purpose}: non-ASCII archive name") from exc
        return text, self.span(start, end + 1 - start, purpose)


@dataclass(frozen=True)
class ArchiveEntry:
    index: int
    name: str
    name_address: int
    data_address: int
    name_span: PhysicalSpan
    container_span: PhysicalSpan

    @property
    def data_offset(self) -> int:
        return self.data_address - GBA_ROM_BASE


class DungeonArchive:
    """Parser for the EU ROM's pksdir0 dungeon archive.

    SIRO resources consist of a short archive entry container and an absolute
    pointer graph.  Therefore entry-container spans and pointed logical spans
    are intentionally represented separately; a pointed root is never assumed
    to end at the next archive entry.
    """

    def __init__(self, rom: bytes):
        self.rom = RomView(rom)
        header = self.rom.span(DUNGEON_ARCHIVE_OFFSET, 24, "dungeon archive header")
        require(
            rom[DUNGEON_ARCHIVE_OFFSET : DUNGEON_ARCHIVE_OFFSET + 8]
            == DUNGEON_ARCHIVE_MAGIC,
            "dungeon archive: bad pksdir0 magic",
        )
        count = self.rom.u32(DUNGEON_ARCHIVE_OFFSET + 8, "dungeon archive count")
        require(
            count == DUNGEON_ARCHIVE_COUNT,
            f"dungeon archive: expected 803 entries, got {count}",
        )
        table_address = self.rom.u32(
            DUNGEON_ARCHIVE_OFFSET + 12, "dungeon archive table pointer"
        )
        table = self.rom.resolve(
            table_address, count * 8, "dungeon archive table", alignment=4
        )
        self.header_span = header
        self.table_span = table

        raw_rows: list[tuple[int, str, int, int, PhysicalSpan]] = []
        for index in range(count):
            name_address, data_address = struct.unpack_from(
                "<II", rom, table.offset + index * 8
            )
            name, name_span = self.rom.c_string(
                name_address, f"archive entry {index} name"
            )
            # pksdir0 payloads are byte-packed; direct AT4PX/raw entries are not
            # guaranteed to begin on a word boundary. Pointed SIRO roots are
            # validated separately with their runtime-required alignment.
            self.rom.resolve(data_address, 1, f"archive entry {name} data")
            raw_rows.append((index, name, name_address, data_address, name_span))

        require(
            len({row[1] for row in raw_rows}) == count,
            "dungeon archive: duplicate names",
        )
        data_offsets = sorted({row[3] - GBA_ROM_BASE for row in raw_rows})
        require(len(data_offsets) == count, "dungeon archive: duplicate data pointers")
        next_offset = {
            offset: data_offsets[pos + 1] if pos + 1 < len(data_offsets) else len(rom)
            for pos, offset in enumerate(data_offsets)
        }
        entries: list[ArchiveEntry] = []
        for index, name, name_address, data_address, name_span in raw_rows:
            offset = data_address - GBA_ROM_BASE
            entries.append(
                ArchiveEntry(
                    index=index,
                    name=name,
                    name_address=name_address,
                    data_address=data_address,
                    name_span=name_span,
                    container_span=self.rom.span(
                        offset,
                        next_offset[offset] - offset,
                        f"archive entry {name} container",
                    ),
                )
            )
        self.entries = entries
        self.by_name = {entry.name: entry for entry in entries}

    def entry(self, name: str) -> ArchiveEntry:
        try:
            return self.by_name[name]
        except KeyError as exc:
            raise ReconstructionError(
                f"dungeon archive: missing resource {name}"
            ) from exc

    def entry_prefix(self, entry: ArchiveEntry, size: int) -> bytes:
        require(
            size <= entry.container_span.size,
            f"{entry.name}: prefix exceeds archive container",
        )
        span = self.rom.span(entry.data_offset, size, f"{entry.name} entry prefix")
        return self.rom.bytes(span)

    def siro_root(self, entry: ArchiveEntry, *, minimum_size: int = 1) -> PhysicalSpan:
        require(
            entry.container_span.size >= 16,
            f"{entry.name}: truncated SIRO wrapper container",
        )
        wrapper = self.rom.span(entry.data_offset, 16, f"{entry.name} SIRO wrapper")
        require(
            self.rom.bytes(wrapper)[:4] == b"SIRO",
            f"{entry.name}: missing SIRO wrapper",
        )
        root_address = self.rom.u32(
            entry.data_offset + 4, f"{entry.name} SIRO root pointer"
        )
        require(
            self.rom.u32(entry.data_offset + 8, f"{entry.name} SIRO reserved word 0")
            == 0
            and self.rom.u32(
                entry.data_offset + 12, f"{entry.name} SIRO reserved word 1"
            )
            == 0,
            f"{entry.name}: nonzero SIRO reserved words",
        )
        return self.rom.resolve(
            root_address, minimum_size, f"{entry.name} SIRO root", alignment=4
        )

    def stream_span(self, entry: ArchiveEntry) -> PhysicalSpan:
        """Resolve a direct or SIRO-rooted AT4PX stream and its exact length."""
        prefix = self.entry_prefix(entry, 5)
        if prefix == b"AT4PX":
            start = entry.data_offset
        elif prefix[:4] == b"SIRO":
            start = self.siro_root(entry, minimum_size=18).offset
        else:
            raise ReconstructionError(f"{entry.name}: resource is not an AT4PX stream")
        require(
            self.rom.data[start : start + 5] == b"AT4PX",
            f"{entry.name}: invalid AT4PX magic",
        )
        total = struct.unpack_from("<H", self.rom.data, start + 5)[0]
        require(total >= 18, f"{entry.name}: invalid AT4PX container length {total}")
        if start == entry.data_offset:
            require(
                total <= entry.container_span.size,
                f"{entry.name}: AT4PX stream exceeds archive container",
            )
        return self.rom.span(start, total, f"{entry.name} AT4PX stream")

    def decompress(
        self, name: str, *, expected_size: int | None = None
    ) -> tuple[bytes, dict[str, Any]]:
        entry = self.entry(name)
        span = self.stream_span(entry)
        output, stats = decompress_at4px(
            self.rom.bytes(span), expected_size=expected_size, context=name
        )
        evidence = {
            "archive_entry_index": entry.index,
            "archive_data_address_hex": f"0x{entry.data_address:08X}",
            "archive_container_span": entry.container_span.as_dict(),
            "stream_span": span.as_dict(),
            "stream_sha256": sha256(self.rom.bytes(span)),
            "decompressed_size": len(output),
            "decompressed_sha256": sha256(output),
            "decoder": stats,
        }
        return output, evidence

    def raw(self, name: str, size: int) -> tuple[bytes, dict[str, Any]]:
        entry = self.entry(name)
        require(
            self.entry_prefix(entry, 4) != b"SIRO",
            f"{name}: expected direct raw resource",
        )
        require(
            size <= entry.container_span.size,
            f"{name}: raw payload exceeds archive container",
        )
        span = self.rom.span(entry.data_offset, size, f"{name} raw payload")
        data = self.rom.bytes(span)
        return data, {
            "archive_entry_index": entry.index,
            "archive_data_address_hex": f"0x{entry.data_address:08X}",
            "archive_container_span": entry.container_span.as_dict(),
            "payload_span": span.as_dict(),
            "payload_sha256": sha256(data),
        }

    def at4px_streams(self) -> list[tuple[ArchiveEntry, PhysicalSpan]]:
        streams: list[tuple[ArchiveEntry, PhysicalSpan]] = []
        for entry in self.entries:
            prefix = self.entry_prefix(entry, 5)
            if prefix == b"AT4PX":
                streams.append((entry, self.stream_span(entry)))
            elif prefix[:4] == b"SIRO":
                root = self.siro_root(entry)
                if self.rom.data[root.offset : root.offset + 5] == b"AT4PX":
                    streams.append((entry, self.stream_span(entry)))
        return streams


def decompress_at4px(
    data: bytes,
    *,
    expected_size: int | None = None,
    context: str = "AT4PX",
) -> tuple[bytes, dict[str, Any]]:
    """Strict, byte-for-byte implementation of pret's ``DecompressAT`` AT4PX path."""

    require(len(data) >= 18, f"{context}: truncated AT4PX header")
    require(data[:5] == b"AT4PX", f"{context}: bad AT4PX magic")
    container_length = struct.unpack_from("<H", data, 5)[0]
    require(
        container_length >= 18,
        f"{context}: invalid container length {container_length}",
    )
    require(container_length <= len(data), f"{context}: truncated AT4PX container")
    declared_size = struct.unpack_from("<H", data, 16)[0]
    if expected_size is not None:
        require(
            declared_size == expected_size,
            f"{context}: declared output {declared_size}, expected {expected_size}",
        )

    # Keep the nine sequential comparisons used by the C implementation.  In
    # particular, do not replace this with list.index-based remapping.
    flags = [value + 3 for value in data[7:16]]
    output = bytearray()
    offset = 18
    control = 0
    control_bit = 8
    controls = literals = backrefs = special_tokens = 0

    def need(count: int, purpose: str) -> None:
        require(offset + count <= container_length, f"{context}: truncated {purpose}")

    def append(value: int) -> None:
        output.append(value & 0xFF)
        require(
            len(output) <= declared_size,
            f"{context}: command output exceeds declared size {declared_size}",
        )

    while offset < container_length:
        if control_bit == 8:
            need(1, "control byte")
            control = data[offset]
            offset += 1
            control_bit = 0
            controls += 1
        if control & 0x80:
            need(1, "literal")
            append(data[offset])
            offset += 1
            literals += 1
        else:
            need(1, "command")
            token = data[offset]
            command = (token >> 4) + 3
            for index, flag in enumerate(flags):
                if command == flag:
                    command = 0x1F - index
            if 0x17 <= command <= 0x1F:
                offset += 1
                c = token & 0x0F
                patterns = {
                    0x1F: (c, c, c, c),
                    0x1E: (c, c + 1, c + 1, c + 1),
                    0x1D: (c, c - 1, c, c),
                    0x1C: (c, c, c - 1, c),
                    0x1B: (c, c, c, c - 1),
                    0x1A: (c, c - 1, c - 1, c - 1),
                    0x19: (c, c + 1, c, c),
                    0x18: (c, c, c + 1, c),
                    0x17: (c, c, c, c + 1),
                }
                n0, n1, n2, n3 = (value & 0x0F for value in patterns[command])
                append((n0 << 4) | n1)
                append((n2 << 4) | n3)
                special_tokens += 1
            else:
                need(2, "back-reference")
                displacement = ((token & 0x0F) << 8) | data[offset + 1]
                offset += 2
                source = len(output) + displacement - 0x1000
                require(source >= 0, f"{context}: back-reference precedes output")
                for _ in range(command):
                    require(
                        source < len(output),
                        f"{context}: invalid back-reference source",
                    )
                    append(output[source])
                    source += 1
                backrefs += 1
        control_bit += 1
        control = (control << 1) & 0xFF

    require(
        offset == container_length, f"{context}: decoder did not consume full container"
    )
    require(
        len(output) == declared_size,
        f"{context}: produced {len(output)} bytes, declared {declared_size}",
    )
    return bytes(output), {
        "format": "AT4PX",
        "container_length": container_length,
        "declared_output_size": declared_size,
        "special_command_lengths": flags,
        "control_bytes": controls,
        "literal_tokens": literals,
        "back_reference_tokens": backrefs,
        "special_pattern_tokens": special_tokens,
    }


def differential_validate_at4px(archive: DungeonArchive) -> dict[str, Any]:
    """Compare every archive AT4PX stream with SkyTemple's implementation."""

    try:
        from skytemple_files.compression_container.at4px.handler import At4pxHandler
    except ImportError as exc:  # pragma: no cover - exercised only without optional validation dependency
        raise ReconstructionError(
            "skytemple-files is required for AT4PX differential validation"
        ) from exc

    entries: list[dict[str, Any]] = []
    streams = archive.at4px_streams()
    for entry, span in streams:
        source = archive.rom.bytes(span)
        ours, stats = decompress_at4px(source, context=entry.name)
        reference = bytes(At4pxHandler.deserialize(source).decompress())
        require(ours == reference, f"{entry.name}: SkyTemple differential mismatch")
        entries.append(
            {
                "resource": entry.name,
                "stream_span": span.as_dict(),
                "compressed_sha256": sha256(source),
                "decompressed_size": len(ours),
                "decompressed_sha256": sha256(ours),
                "decoder": stats,
                "match": True,
            }
        )
    require(len(entries) == 204, f"expected 204 AT4PX streams, found {len(entries)}")
    return {
        "implementation": "pret-equivalent tools/pmdred_dungeon_ground.py::decompress_at4px",
        "reference": "skytemple-files At4pxHandler.deserialize(data).decompress()",
        "stream_count": len(entries),
        "all_match": True,
        "entries": entries,
    }


@dataclass(frozen=True)
class AnimationRecord:
    index: int
    count: int
    duration: int
    colors: tuple[tuple[int, int, int, int], ...]
    record_span: PhysicalSpan

    @property
    def active(self) -> bool:
        return self.count != 0

    @property
    def cycle_ticks(self) -> int:
        return self.count * self.duration if self.active else 0

    def as_dict(self, raw_palette_color: tuple[int, int, int, int]) -> dict[str, Any]:
        return {
            "index": self.index,
            "palette_index": 160 + self.index,
            "active": self.active,
            "color_count": self.count,
            "duration_ticks": self.duration,
            "initial_raw_color": list(raw_palette_color),
            "initial_raw_hold_ticks": self.duration if self.active else None,
            "first_published_color_index": 0 if self.active else None,
            "first_publish_tick": self.duration if self.active else None,
            "steady_cycle_ticks": self.cycle_ticks or None,
            "colors": [list(color) for color in self.colors],
            "record_span": self.record_span.as_dict(),
        }


def parse_canm(
    archive: DungeonArchive, name: str
) -> tuple[list[AnimationRecord], dict[str, Any]]:
    entry = archive.entry(name)
    root = archive.siro_root(entry, minimum_size=32 * 4)
    root = archive.rom.span(root.offset, 32 * 4, f"{name} animation pointer root")
    records: list[AnimationRecord] = []
    child_spans: list[dict[str, Any]] = []
    for index in range(32):
        address = struct.unpack_from("<I", archive.rom.data, root.offset + index * 4)[0]
        head = archive.rom.resolve(
            address, 4, f"{name} animation record {index}", alignment=4
        )
        count, duration = struct.unpack_from("<hh", archive.rom.data, head.offset)
        require(
            0 <= count <= 256, f"{name} animation {index}: invalid color count {count}"
        )
        if count:
            require(
                duration > 0, f"{name} animation {index}: invalid duration {duration}"
            )
        else:
            require(
                duration >= 0,
                f"{name} animation {index}: invalid inactive duration {duration}",
            )
        span = archive.rom.resolve(
            address, 4 + count * 4, f"{name} animation record {index}", alignment=4
        )
        colors = tuple(
            tuple(
                archive.rom.data[
                    span.offset + 4 + color * 4 : span.offset + 8 + color * 4
                ]
            )
            for color in range(count)
        )
        records.append(AnimationRecord(index, count, duration, colors, span))
        child_spans.append(span.as_dict())
    active = sum(record.active for record in records)
    require(
        active in (16, 32), f"{name}: expected 16 or 32 active records, got {active}"
    )
    return records, {
        "archive_entry_index": entry.index,
        "archive_data_address_hex": f"0x{entry.data_address:08X}",
        "archive_container_span": entry.container_span.as_dict(),
        "root_span": root.as_dict(),
        "root_sha256": sha256(archive.rom.bytes(root)),
        "record_spans": child_spans,
        "record_count": 32,
        "active_record_count": active,
    }


def decode_pmd_text_escapes(encoded: str) -> str:
    """Expand the game's ``~HH`` byte escapes used inside localized strings."""

    output: list[str] = []
    index = 0
    while index < len(encoded):
        if index + 2 < len(encoded) and encoded[index] == "~":
            code = encoded[index + 1 : index + 3]
            try:
                output.append(chr(int(code, 16)))
            except ValueError:
                output.append(encoded[index])
                index += 1
                continue
            index += 3
        else:
            output.append(encoded[index])
            index += 1
    return "".join(output)


def parse_french_dungeon_names(rom: bytes) -> list[dict[str, Any]]:
    """Parse both French display strings for all 98 dungeon-name records."""

    offset = DUNGEON_NAME_OFFSET
    records: list[dict[str, Any]] = []
    for record_index in range(DUNGEON_NAME_COUNT):
        values: list[dict[str, Any]] = []
        for variant in range(2):
            require(offset + 2 <= len(rom), "French dungeon names: truncated prefix")
            prefix = struct.unpack_from("<H", rom, offset)[0]
            start = offset
            offset += 2
            end = rom.find(b"\0", offset)
            require(end >= 0, "French dungeon names: unterminated string")
            raw = rom[offset:end]
            encoded_text = raw.decode("latin-1")
            text = decode_pmd_text_escapes(encoded_text)
            offset = end + 1
            if offset & 1:
                offset += 1
            values.append(
                {
                    "variant": variant,
                    "prefix": prefix,
                    "encoded_text": encoded_text,
                    "text": text,
                    "text_bytes_hex": raw.hex(),
                    "span": PhysicalSpan(
                        start,
                        offset - start,
                        f"French dungeon name {record_index}/{variant}",
                    ).as_dict(),
                }
            )
        records.append(
            {
                "dungeon_id": record_index,
                "primary": values[0]["text"],
                "secondary": values[1]["text"],
                "strings": values,
            }
        )
    return records


def parse_mapparam(
    archive: DungeonArchive,
    floor_counts: Sequence[dict[str, Any]],
) -> dict[str, Any]:
    entry = archive.entry("mapparam")
    root = archive.siro_root(entry, minimum_size=20)
    root = archive.rom.span(root.offset, 20, "mapparam logical root")
    addresses = struct.unpack_from("<5I", archive.rom.data, root.offset)
    labels = ("selectors", "floor_properties", "items", "monsters", "traps")
    pointers = {label: address for label, address in zip(labels, addresses)}
    selector_table = archive.rom.resolve(
        pointers["selectors"], 64 * 4, "mapparam selector pointers", alignment=4
    )

    selector_rows: list[dict[str, Any]] = []
    property_indices: set[int] = set()
    for dungeon_id in range(64):
        floor_row = floor_counts[dungeon_id]
        count = floor_row.get("selector_row_count", floor_row.get("floor_count"))
        require(
            isinstance(count, int), f"dungeon {dungeon_id}: missing selector row count"
        )
        pointer = struct.unpack_from(
            "<I", archive.rom.data, selector_table.offset + dungeon_id * 4
        )[0]
        rows_span = archive.rom.resolve(
            pointer, count * 16, f"mapparam dungeon {dungeon_id} selectors", alignment=4
        )
        rows: list[dict[str, Any]] = []
        for row_index in range(count):
            values = struct.unpack_from(
                "<8h", archive.rom.data, rows_span.offset + row_index * 16
            )
            require(
                values[0] >= 0,
                f"mapparam dungeon {dungeon_id} row {row_index}: negative property",
            )
            property_indices.add(values[0])
            rows.append(
                {
                    "row_index": row_index,
                    "fields": list(values),
                    "property_index": values[0],
                }
            )
        selector_rows.append(
            {
                "dungeon_id": dungeon_id,
                "selector_row_count": count,
                "playable_floor_count": count - 1,
                "rows_span": rows_span.as_dict(),
                "rows": rows,
            }
        )

    max_property = max(property_indices)
    properties_span = archive.rom.resolve(
        pointers["floor_properties"],
        (max_property + 1) * 28,
        "mapparam referenced floor properties",
        alignment=4,
    )
    properties: list[dict[str, Any]] = []
    for index in range(max_property + 1):
        raw = archive.rom.data[
            properties_span.offset + index * 28 : properties_span.offset
            + (index + 1) * 28
        ]
        properties.append(
            {
                "index": index,
                "tileset": raw[2],
                "raw_hex": raw.hex(),
                "referenced": index in property_indices,
            }
        )

    return {
        "archive_entry_index": entry.index,
        "archive_data_address_hex": f"0x{entry.data_address:08X}",
        "archive_container_span": entry.container_span.as_dict(),
        "root_span": root.as_dict(),
        "pointers": {label: f"0x{address:08X}" for label, address in pointers.items()},
        "selector_pointer_table_span": selector_table.as_dict(),
        "selectors": selector_rows,
        "referenced_properties_span": properties_span.as_dict(),
        "properties": properties,
    }


@dataclass(frozen=True)
class BmaAuxiliaryLayers:
    """Canonical camera-cell data following a BMA's graphical layers.

    ``unknown_data`` deliberately retains SkyTemple's neutral terminology.  It
    is not collision: reverse engineering associates nonzero cells with NPC
    interaction/counter behavior, so callers must preserve it as evidence and
    must not silently turn it into PMDO obstacles.
    """

    width: int
    height: int
    unknown_data: bytes | None
    collisions: tuple[bytes, ...]
    encoded_end: int
    metadata: dict[str, Any]


def decode_bma_auxiliary_layers(data: bytes, context: str) -> BmaAuxiliaryLayers:
    """Decode BMA unknown-data and every collision layer exactly.

    This follows the same normalized EU parser used for graphical extraction,
    then performs the documented vertical XOR reconstruction for each
    collision stream.  It supports zero, one, or two collision layers even
    though the 201 authoritative EU Ground BMAs currently use at most one.
    """

    # Import lazily so this library remains an adapter over the authoritative
    # regional parser rather than a duplicate implementation.
    import audit_pmdred_eu_rom as ground_audit

    require(len(data) >= 12, f"{context}: truncated BMA")
    width, height, _, _, width_chunks, height_chunks = data[:6]
    layers, has_data, collision_layers = struct.unpack_from("<HHH", data, 6)
    require(layers in (1, 2), f"{context}: invalid BMA layer count {layers}")
    require(has_data in (0, 1), f"{context}: invalid BMA data flag {has_data}")
    require(
        collision_layers in (0, 1, 2),
        f"{context}: invalid BMA collision count {collision_layers}",
    )
    try:
        _, offset, layer_stats = ground_audit.decode_bma_layers(
            data, 12, width_chunks, height_chunks, layers, context
        )
    except ground_audit.AuditError as exc:
        raise ReconstructionError(str(exc)) from exc
    camera_cells = width * height

    unknown_data: bytes | None = None
    data_stats: dict[str, Any] | None = None
    if has_data:
        try:
            unknown_data, offset, data_stats = ground_audit.decode_generic_nrl(
                data, offset, camera_cells, f"{context}/unknown-data"
            )
        except ground_audit.AuditError as exc:
            raise ReconstructionError(str(exc)) from exc
        data_stats = {
            **data_stats,
            "decoded_sha256": sha256(unknown_data),
            "nonzero_cells": sum(value != 0 for value in unknown_data),
            "distinct_values": sorted(set(unknown_data)),
        }

    collisions: list[bytes] = []
    collision_stats: list[dict[str, Any]] = []
    for layer_index in range(collision_layers):
        try:
            deltas, offset, stats = ground_audit.decode_collision_rle(
                data, offset, camera_cells, f"{context}/collision-{layer_index}"
            )
        except ground_audit.AuditError as exc:
            raise ReconstructionError(str(exc)) from exc
        decoded = bytearray(camera_cells)
        for index, delta in enumerate(deltas):
            above = decoded[index - width] if index >= width else 0
            decoded[index] = delta ^ above
        decoded_bytes = bytes(decoded)
        collisions.append(decoded_bytes)
        collision_stats.append(
            {
                **stats,
                "layer": layer_index,
                "decoded_sha256": sha256(decoded_bytes),
                "solid_cells": sum(decoded_bytes),
                "walkable_cells": camera_cells - sum(decoded_bytes),
            }
        )

    return BmaAuxiliaryLayers(
        width=width,
        height=height,
        unknown_data=unknown_data,
        collisions=tuple(collisions),
        encoded_end=offset,
        metadata={
            "camera_width": width,
            "camera_height": height,
            "camera_cells": camera_cells,
            "graphical_layer_streams": layer_stats,
            "unknown_data_stream": data_stats,
            "collision_streams": collision_stats,
            "encoded_end": offset,
            "normalized_size": len(data),
            "trailing_bytes": len(data) - offset,
        },
    )


def differential_validate_bma_auxiliary(
    resources: Iterable[tuple[str, bytes]],
) -> dict[str, Any]:
    """Compare normalized BMAs' auxiliary layers with SkyTemple."""

    try:
        from skytemple_files.graphics.bma.handler import BmaHandler
    except ImportError as exc:  # pragma: no cover - optional validation dependency
        raise ReconstructionError(
            "skytemple-files is required for BMA differential validation"
        ) from exc

    entries: list[dict[str, Any]] = []
    collision_counts: dict[str, int] = {}
    data_count = 0
    for name, data in resources:
        ours = decode_bma_auxiliary_layers(data, name)
        reference = BmaHandler.deserialize(data)
        reference_unknown = (
            bytes(reference.unknown_data_block)
            if reference.unknown_data_block is not None
            else None
        )
        reference_collisions = tuple(
            bytes(bool(value) for value in layer)
            for layer in (reference.collision, reference.collision2)
            if layer is not None
        )
        require(
            (ours.width, ours.height)
            == (reference.map_width_camera, reference.map_height_camera),
            f"{name}: SkyTemple camera-dimension mismatch",
        )
        require(
            ours.unknown_data == reference_unknown,
            f"{name}: SkyTemple unknown-data mismatch",
        )
        require(
            ours.collisions == reference_collisions,
            f"{name}: SkyTemple collision mismatch",
        )
        collision_key = str(len(ours.collisions))
        collision_counts[collision_key] = collision_counts.get(collision_key, 0) + 1
        data_count += ours.unknown_data is not None
        entries.append(
            {
                "resource": name,
                "normalized_size": len(data),
                "normalized_sha256": sha256(data),
                "camera_width": ours.width,
                "camera_height": ours.height,
                "unknown_data": None
                if ours.unknown_data is None
                else {
                    "size": len(ours.unknown_data),
                    "sha256": sha256(ours.unknown_data),
                    "nonzero_cells": sum(value != 0 for value in ours.unknown_data),
                    "distinct_values": sorted(set(ours.unknown_data)),
                },
                "collision_layers": [
                    {
                        "index": index,
                        "size": len(layer),
                        "sha256": sha256(layer),
                        "solid_cells": sum(layer),
                    }
                    for index, layer in enumerate(ours.collisions)
                ],
                "encoded_end": ours.encoded_end,
                "match": True,
            }
        )
    return {
        "implementation": "tools/pmdred_dungeon_ground.py::decode_bma_auxiliary_layers",
        "reference": "skytemple-files BmaHandler.deserialize",
        "resource_count": len(entries),
        "unknown_data_resource_count": data_count,
        "collision_layer_count_histogram": collision_counts,
        "all_match": True,
        "entries": entries,
    }


def decode_bma_terrain(data: bytes, context: str) -> tuple[list[int], dict[str, Any]]:
    """Decode the terrain layer while retaining the runtime's 64-cell stride."""

    # Import lazily so this library remains an adapter over the authoritative
    # regional parser rather than a duplicate BMA implementation.
    import audit_pmdred_eu_rom as ground_audit

    require(len(data) >= 12, f"{context}: truncated BMA")
    (
        width_tiles,
        height_tiles,
        tiling_width,
        tiling_height,
        width_chunks,
        height_chunks,
    ) = data[:6]
    layers, has_data, collision_layers = struct.unpack_from("<HHH", data, 6)
    require(layers == 1, f"{context}: direct dungeon Ground requires one terrain layer")
    logical_layers, end, layer_stats = ground_audit.decode_bma_layers(
        data, 12, width_chunks, height_chunks, layers, context
    )
    logical = logical_layers[0]
    terrain: list[int] = []
    for row in range(height_chunks):
        start = row * width_chunks
        terrain.extend(logical[start : start + width_chunks])
        terrain.extend([0] * (MATERIAL_STRIDE - width_chunks))
    metadata = {
        "header": {
            "map_width_tiles": width_tiles,
            "map_height_tiles": height_tiles,
            "tiling_width": tiling_width,
            "tiling_height": tiling_height,
            "map_width_chunks": width_chunks,
            "map_height_chunks": height_chunks,
            "num_layers": layers,
            "has_data_layer": has_data,
            "collision_layers": collision_layers,
        },
        "terrain_layer_end": end,
        "terrain_layer": layer_stats[0],
        "runtime_stride": MATERIAL_STRIDE,
        "runtime_terrain_cells": len(terrain),
        "runtime_terrain_u16le_sha256": sha256(
            struct.pack(f"<{len(terrain)}H", *terrain)
        ),
    }
    return terrain, metadata


def material_mask(
    x: int,
    y: int,
    height: int,
    terrain: Sequence[int],
    default: int,
) -> int:
    def at(px: int, py: int) -> int:
        if px < 0 or py < 0 or px >= MATERIAL_STRIDE or py >= height:
            return default
        return terrain[py * MATERIAL_STRIDE + px]

    base = at(x, y)
    offsets = (
        at(x, y + 1),
        at(x + 1, y + 1),
        at(x + 1, y),
        at(x + 1, y - 1),
        at(x, y - 1),
        at(x - 1, y - 1),
        at(x - 1, y),
        at(x - 1, y + 1),
    )
    if base == 1:
        mask = 0xFF
        for bit, value in enumerate(offsets):
            if value == 0:
                mask &= ~(1 << bit)
        return mask | 0x200
    if base in (2, 3):
        mask = 0xFF
        for bit, value in enumerate(offsets):
            if value != base:
                mask &= ~(1 << bit)
        return mask | 0x100
    mask = 0
    for bit, value in enumerate(offsets):
        if value == 0:
            mask |= 1 << bit
    return mask


def compose_ground_chunks(
    terrain: Sequence[int],
    height: int,
    tileset: int,
    material: bytes,
    *,
    default: int,
) -> list[int]:
    """Reproduce ``sub_80ADD9C``/``sub_80ADFB8`` for Ground rendering."""

    require(
        len(terrain) == MATERIAL_STRIDE * height,
        "terrain buffer does not use stride 64",
    )
    output: list[int] = []
    if tileset >= 64:
        require(
            len(material) == EMAP_DECOMPRESSED_SIZE, "special EMAP must be 0x240 bytes"
        )
        for y in range(height):
            for x in range(MATERIAL_STRIDE):
                output.append(
                    material[y * SPECIAL_MAP_SIZE + x] if x < 24 and y < 24 else default
                )
    else:
        require(
            len(material) == CEX_DECOMPRESSED_SIZE, "regular CEX must be 0x930 bytes"
        )
        for y in range(height):
            for x in range(MATERIAL_STRIDE):
                mask = material_mask(x, y, height, terrain, default)
                index = mask * 3
                require(
                    index < 0x900, f"CEX mask index 0x{index:X} exceeds variant table"
                )
                # The direct Ground path always uses the first of three CEX variants.
                output.append(material[index])
    require(
        all(chunk < GROUND_CHUNK_COUNT for chunk in output),
        "composed chunk exceeds CEL count",
    )
    return output


def parse_ground_palette(data: bytes) -> list[tuple[int, int, int, int]]:
    color_count = GROUND_PALETTE_COUNT * 16
    require(
        len(data) == color_count * 4,
        "dungeon palette must contain exactly 192 RGB records",
    )
    colors = [tuple(data[index * 4 : index * 4 + 4]) for index in range(color_count)]
    # Ground's direct loader publishes 12 palettes and forces each 4bpp
    # palette's transparent color zero to black while advancing over source 0.
    ground = colors[:]
    for palette in range(GROUND_PALETTE_COUNT):
        ground[palette * 16] = (0, 0, 0, 0)
    return ground


def palette_at_tick(
    base: Sequence[tuple[int, int, int, int]],
    animations: Sequence[AnimationRecord],
    tick: int,
) -> list[tuple[int, int, int, int]]:
    """Return direct-Ground palette state after ``tick`` update calls."""

    require(tick >= 0, "animation tick must be nonnegative")
    palette = list(base)
    require(
        len(palette) == GROUND_PALETTE_COUNT * 16,
        "Ground palette must contain 192 colors",
    )
    for record in animations:
        if not record.active or tick < record.duration:
            continue
        expiry = tick // record.duration
        color_index = (expiry - 1) % record.count
        palette[160 + record.index] = record.colors[color_index]
    return palette


def gba_display_channel(value: int) -> int:
    value5 = (value & 0xF8) >> 3
    return (value5 << 3) | (value5 >> 2)


def gba_display_rgb(color: Sequence[int]) -> tuple[int, int, int]:
    return tuple(gba_display_channel(value) for value in color[:3])  # type: ignore[return-value]


class DungeonGroundRenderer:
    """Cached 4bpp/CEL renderer with GBA palette quantization."""

    def __init__(self, font: bytes, cel: bytes):
        require(
            len(font) > 0 and len(font) % 32 == 0,
            "font output must contain whole 4bpp tiles",
        )
        require(
            len(font) <= GROUND_TILE_COUNT * 32,
            "font output exceeds 512 addressable tiles",
        )
        require(
            len(cel) == CEL_DECOMPRESSED_SIZE, "CEL output must be exactly 0x1194 bytes"
        )
        self.font = font
        self.tile_count = len(font) // 32
        self.descriptors = struct.unpack(f"<{GROUND_CHUNK_COUNT * 9}H", cel)
        self.tile_cache: dict[
            tuple[int, tuple[tuple[int, int, int, int], ...]], Image.Image
        ] = {}
        self.chunk_cache: dict[
            tuple[int, tuple[tuple[int, int, int, int], ...]], Image.Image
        ] = {}

    def _tile(
        self, descriptor: int, palette: Sequence[tuple[int, int, int, int]]
    ) -> Image.Image:
        palette_index = (descriptor >> 12) & 0xF
        require(
            palette_index < GROUND_PALETTE_COUNT,
            f"CEL uses unavailable palette {palette_index}",
        )
        palette_row = tuple(palette[palette_index * 16 : palette_index * 16 + 16])
        key = (descriptor, palette_row)
        if key in self.tile_cache:
            return self.tile_cache[key]
        tile_index = descriptor & 0x3FF
        require(tile_index < self.tile_count, f"CEL uses unavailable tile {tile_index}")
        source = self.font[tile_index * 32 : tile_index * 32 + 32]
        image = Image.new("RGBA", (8, 8), (0, 0, 0, 0))
        pixels = image.load()
        for y in range(8):
            for pair in range(4):
                value = source[y * 4 + pair]
                for side, color_index in enumerate((value & 0x0F, value >> 4)):
                    if color_index:
                        r, g, b = gba_display_rgb(palette_row[color_index])
                        pixels[pair * 2 + side, y] = (r, g, b, 255)
        if descriptor & 0x0400:
            image = image.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        if descriptor & 0x0800:
            image = image.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
        self.tile_cache[key] = image
        return image

    def _chunk(
        self, chunk_id: int, palette: Sequence[tuple[int, int, int, int]]
    ) -> Image.Image:
        require(0 <= chunk_id < GROUND_CHUNK_COUNT, f"invalid chunk {chunk_id}")
        start = chunk_id * 9
        descriptors = self.descriptors[start : start + 9]
        used_palettes = sorted({(descriptor >> 12) & 0xF for descriptor in descriptors})
        require(
            all(index < GROUND_PALETTE_COUNT for index in used_palettes),
            "chunk uses palette outside 0..11",
        )
        palette_key = tuple(
            color
            for index in used_palettes
            for color in palette[index * 16 : index * 16 + 16]
        )
        key = (chunk_id, palette_key)
        if key in self.chunk_cache:
            return self.chunk_cache[key]
        image = Image.new("RGBA", (24, 24), (0, 0, 0, 0))
        for index, descriptor in enumerate(descriptors):
            tile = self._tile(descriptor, palette)
            image.alpha_composite(tile, ((index % 3) * 8, (index // 3) * 8))
        self.chunk_cache[key] = image
        return image

    def used_animation_indices(
        self,
        chunks: Sequence[int],
        visible_width: int,
        visible_height: int,
    ) -> set[int]:
        indices: set[int] = set()
        for y in range(visible_height):
            for x in range(visible_width):
                chunk = chunks[y * MATERIAL_STRIDE + x]
                for descriptor in self.descriptors[chunk * 9 : chunk * 9 + 9]:
                    palette_index = (descriptor >> 12) & 0xF
                    if palette_index not in (10, 11):
                        continue
                    tile_index = descriptor & 0x3FF
                    require(
                        tile_index < self.tile_count,
                        f"CEL uses unavailable tile {tile_index}",
                    )
                    source = self.font[tile_index * 32 : tile_index * 32 + 32]
                    for value in source:
                        for color_index in (value & 0x0F, value >> 4):
                            if color_index:
                                indices.add(palette_index * 16 + color_index - 160)
        return indices

    def render(
        self,
        chunks: Sequence[int],
        width_chunks: int,
        height_chunks: int,
        width_pixels: int,
        height_pixels: int,
        palette: Sequence[tuple[int, int, int, int]],
    ) -> Image.Image:
        require(
            len(chunks) == MATERIAL_STRIDE * height_chunks,
            "composed chunks have wrong stride",
        )
        require(
            width_chunks <= MATERIAL_STRIDE,
            "visible chunk width exceeds runtime stride",
        )
        image = Image.new("RGB", (width_chunks * 24, height_chunks * 24), (0, 0, 0))
        for y in range(height_chunks):
            for x in range(width_chunks):
                chunk = self._chunk(chunks[y * MATERIAL_STRIDE + x], palette)
                image.paste(chunk, (x * 24, y * 24), chunk)
        require(
            width_pixels <= image.width and height_pixels <= image.height,
            "camera crop exceeds chunks",
        )
        return image.crop((0, 0, width_pixels, height_pixels))


def animation_cycle_metadata(
    base_palette: Sequence[tuple[int, int, int, int]],
    records: Sequence[AnimationRecord],
    used_indices: Iterable[int],
) -> dict[str, Any]:
    used = set(used_indices)
    active = [record for record in records if record.active]
    used_active = [record for record in active if record.index in used]
    global_cycle = math.lcm(*(record.cycle_ticks for record in active)) if active else 0
    visible_cycle = (
        math.lcm(*(record.cycle_ticks for record in used_active)) if used_active else 0
    )
    return {
        "startup_model": (
            "Direct Ground load publishes the raw 12-palette source first. Each active record retains "
            "that raw slot for duration ticks, publishes record color 0 at the first expiry, then advances."
        ),
        "tick_definition": "one call to the Ground palette-animation update path",
        "used_animation_record_indices": sorted(used),
        "active_record_count": len(active),
        "used_active_record_count": len(used_active),
        "global_steady_cycle_ticks": global_cycle,
        "visible_steady_cycle_ticks": visible_cycle,
        "records": [
            record.as_dict(base_palette[160 + record.index]) for record in records
        ],
    }


def preview_event_ticks(
    records: Sequence[AnimationRecord],
    used_indices: Iterable[int],
    max_frames: int,
) -> list[int]:
    require(max_frames >= 1, "preview must allow at least one frame")
    used = set(used_indices)
    heap: list[tuple[int, int]] = []
    for record in records:
        if record.active and record.index in used:
            heapq.heappush(heap, (record.duration, record.index))
    ticks = [0]
    by_index = {record.index: record for record in records}
    while heap and len(ticks) <= max_frames:
        tick = heap[0][0]
        changed: list[int] = []
        while heap and heap[0][0] == tick:
            _, index = heapq.heappop(heap)
            changed.append(index)
        ticks.append(tick)
        for index in changed:
            heapq.heappush(heap, (tick + by_index[index].duration, index))
    if len(ticks) == 1:
        ticks.append(6)
    return ticks


def save_animation_preview(
    path: Path,
    renderer: DungeonGroundRenderer,
    chunks: Sequence[int],
    geometry: dict[str, int],
    base_palette: Sequence[tuple[int, int, int, int]],
    records: Sequence[AnimationRecord],
    used_indices: Iterable[int],
    *,
    max_frames: int = 32,
) -> dict[str, Any]:
    event_ticks = preview_event_ticks(records, used_indices, max_frames)
    state_ticks = event_ticks[:-1]
    durations = [
        event_ticks[index + 1] - event_ticks[index] for index in range(len(state_ticks))
    ]
    frames: list[Image.Image] = []
    frame_ticks: list[int] = []
    frame_durations: list[int] = []
    frame_pixel_hashes: list[str] = []
    for tick, duration in zip(state_ticks, durations):
        palette = palette_at_tick(base_palette, records, tick)
        image = renderer.render(
            chunks,
            geometry["map_width_chunks"],
            geometry["map_height_chunks"],
            geometry["map_width_tiles"] * 8,
            geometry["map_height_tiles"] * 8,
            palette,
        )
        pixel_hash = sha256(image.tobytes())
        if frames and pixel_hash == frame_pixel_hashes[-1]:
            frame_durations[-1] += duration
            continue
        frames.append(image)
        frame_ticks.append(tick)
        frame_durations.append(duration)
        frame_pixel_hashes.append(pixel_hash)

    path.parent.mkdir(parents=True, exist_ok=True)
    duration_ms = [
        max(1, round(ticks * 1000 / GBA_FRAME_RATE_HZ)) for ticks in frame_durations
    ]
    frames[0].save(
        path,
        "PNG",
        save_all=len(frames) > 1,
        append_images=frames[1:],
        duration=duration_ms,
        loop=0,
        # Every stored state is a complete RGB frame. APNG disposal NONE keeps
        # decoder compositing byte-identical to those canonical full states.
        disposal=0,
        optimize=False,
    )
    file_data = path.read_bytes()
    return {
        "format": "APNG" if len(frames) > 1 else "PNG",
        "scope": "exact direct-Ground startup prefix; loops for visual preview only",
        "timing": {
            "authoritative_unit": "Ground palette update ticks",
            "gba_master_clock_hz": GBA_MASTER_CLOCK_HZ,
            "gba_cycles_per_frame": GBA_CYCLES_PER_FRAME,
            "gba_frame_rate_hz": GBA_FRAME_RATE_HZ,
            "apng_milliseconds": "nearest integer per stored state; exact durations remain in ticks",
        },
        "requested_max_state_frames": max_frames,
        "stored_frame_count": len(frames),
        "frame_start_ticks": frame_ticks,
        "frame_duration_ticks": frame_durations,
        "frame_duration_ms": duration_ms,
        "frame_pixel_sha256": frame_pixel_hashes,
        "file_size": len(file_data),
        "file_sha256": sha256(file_data),
    }
