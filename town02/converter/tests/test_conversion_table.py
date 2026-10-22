"""Tests for the ground_map_conversion_table auto-resolver.

Builds a synthetic ROM (never any real game content) containing:
  * a run of well-formed GroundConversionStruct records whose text
    pointers resolve to plausible debug names,
  * plus random noise before and after.

Proves the resolver picks the run and extracts (map_file_table_id,
debug_text) for each entry.
"""
from __future__ import annotations

import struct
from pathlib import Path

from converter.pmdred.conversion_table import RECORD_SIZE, resolve
from converter.pmdred.scene_binding import (
    build_bindings,
    canonical_id_from_debug_text,
)
from converter.rom.rom_file import RomFile


def _pack_record(
    unk0: int, place: int, map_id: int, unk6: int, text_ptr_gba: int,
) -> bytes:
    return struct.pack(
        "<hhhhI", unk0, place, map_id, unk6, text_ptr_gba
    )


def _build_rom_with_conversion_table(tmp_path: Path, num_entries: int = 40) -> Path:
    """Layout:
      [0x0000 .. 0x0400)  header + junk padding
      [0x0400 .. 0x0400 + N*12)  the conversion table records
      [0x2000 .. )               debug name strings (one per record)
    """
    size = 0x10000
    data = bytearray(b"\x00" * size)

    # Fill some noise so the scanner has to actually work.
    for off in range(0x200, 0x0400, 4):
        # non-pointer noise
        data[off:off + 4] = b"\xAB\xCD\xEF\x00"

    # Write debug names first so we know their offsets.
    text_offsets: list[int] = []
    cursor = 0x2000
    for i in range(num_entries):
        # Encoded name already contains the trailing \x00 terminator;
        # do not add extra padding between entries or the recorded
        # offsets would go stale.
        name = (
            f"../data/ground/ground_data_"
            f"d{i:02d}p01_station.c"
        ).encode("ascii") + b"\x00"
        text_offsets.append(cursor)
        data[cursor:cursor + len(name)] = name
        cursor += len(name)

    # Write records.
    for i in range(num_entries):
        rec = _pack_record(
            unk0=i % 10,
            place=100 + i,
            map_id=i,
            unk6=0,
            text_ptr_gba=0x08000000 + text_offsets[i],
        )
        data[0x0400 + i * RECORD_SIZE : 0x0400 + (i + 1) * RECORD_SIZE] = rec

    p = tmp_path / "synth.gba"
    p.write_bytes(bytes(data))
    return p


def test_resolver_finds_synthetic_conversion_table(tmp_path: Path) -> None:
    p = _build_rom_with_conversion_table(tmp_path, num_entries=40)
    with RomFile.open(p) as rom:
        result = resolve(rom, min_entries=20)
    assert result.status == "RESOLVED", result.reason
    assert result.entry_count == 40
    assert result.table_offset == 0x0400
    # Text extraction works.
    assert result.entries[0].text.startswith("../data/ground/ground_data_d00p01")
    assert result.entries[5].map_file_table_id == 5


def test_canonical_id_extraction() -> None:
    assert canonical_id_from_debug_text(
        "../data/ground/ground_data_d01p02_station.c"
    ) == "d01p02"
    assert canonical_id_from_debug_text(
        "../data/ground/ground_data_t01_station.c"
    ) == "t01"
    assert canonical_id_from_debug_text("no match here") is None


def test_build_bindings_maps_map_ids_to_canonical_names(tmp_path: Path) -> None:
    p = _build_rom_with_conversion_table(tmp_path, num_entries=40)
    with RomFile.open(p) as rom:
        table = resolve(rom, min_entries=20)
    bindings = build_bindings(table)
    assert len(bindings) == 40
    # Every synthetic name matches the pattern, so all bindings should
    # resolve to a canonical id.
    assert all(b.canonical_ground_id is not None for b in bindings)
    assert bindings[7].canonical_ground_id == "d07p01"
    assert bindings[7].map_file_table_id == 7


def test_resolver_rejects_when_below_min_entries(tmp_path: Path) -> None:
    p = _build_rom_with_conversion_table(tmp_path, num_entries=5)
    with RomFile.open(p) as rom:
        result = resolve(rom, min_entries=32)
    assert result.status == "UNRESOLVED"
    assert result.reason
