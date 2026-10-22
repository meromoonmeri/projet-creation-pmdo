"""Ground map conversion table resolver.

PMD Red keeps a global table that maps each ground map id (index into
the ground_map_table) to a `GroundConversionStruct`:

    struct GroundConversionStruct {   // 12 bytes
        s16 unk0;
        s16 groundPlaceId;
        s16 mapFileTableId;
        s16 unk6;
        const u8 *text;               // ROM pointer to a name string
    };

The layout is public (documented in the pret decompilation under MIT
and referenced by name in this project). The `text` pointer is an ARM
ROM address that points at a null-terminated ASCII debug name — a
strong structural fingerprint we use to locate the table in the ROM
without any hand-fed offset.

Resolution strategy:
  1. Scan the ROM for runs of 12-byte records where:
       - unk0, groundPlaceId, mapFileTableId, unk6 are plausibly small
         s16 values (< 4096 in magnitude),
       - text is a plausible ROM pointer, and dereferencing it lands
         on an ASCII string starting with a lower-case letter (the
         convention used by every debug name in this table).
  2. Keep the longest such run: it is the conversion table.
  3. Emit a ResolvedConversionTable with per-entry (map_id, text) so
     downstream stages can attach a canonical name to every ground.

Nothing from the ROM is copied here; the resolver only records
offsets, lengths and structural facts.
"""
from __future__ import annotations

import string
from dataclasses import dataclass, field
from typing import Optional

from converter.rom.rom_file import RomFile


RECORD_SIZE = 12
_S16_MAX_MAGNITUDE = 4096            # per-field sanity bound
_NAME_MAX_LEN = 96                   # never reads past this many bytes
_NAME_MIN_LEN = 3
# Valid characters in the debug names used by the game's ground table:
# lower-case ASCII letters, digits, underscore, dot, slash and space.
_NAME_ALLOWED = frozenset(
    string.ascii_lowercase + string.digits + "_./ -"
)
# First-character predicate: names either start with a lower-case letter
# (bare identifier convention), an underscore (the European ROM uses
# "__ground_amd_conversion_NNNNN" debug names) or a '.' / '/' when the
# debug string is a path such as
# "../data/ground/ground_data_d01p02_station.c".
_NAME_FIRST_ALLOWED = frozenset(string.ascii_lowercase + "_./")


@dataclass(frozen=True)
class ConversionEntry:
    """One decoded conversion record."""

    offset: int                       # file-relative record start
    unk0: int
    ground_place_id: int
    map_file_table_id: int
    unk6: int
    text_offset: int                  # file-relative offset of the name
    text: str                         # decoded ASCII name


@dataclass
class ResolvedConversionTable:
    status: str                       # "RESOLVED" | "UNRESOLVED"
    reason: str = ""
    table_offset: Optional[int] = None
    entry_count: int = 0
    entries: list[ConversionEntry] = field(default_factory=list)

    def by_map_file_id(self) -> dict[int, ConversionEntry]:
        return {e.map_file_table_id: e for e in self.entries}


# ---------------------------------------------------------------- helpers


def _read_s16(data: bytes, off: int) -> int:
    v = data[off] | (data[off + 1] << 8)
    return v - 0x10000 if v >= 0x8000 else v


def _read_u32(data: bytes, off: int) -> int:
    return (
        data[off]
        | (data[off + 1] << 8)
        | (data[off + 2] << 16)
        | (data[off + 3] << 24)
    )


def _read_ascii_name(rom: RomFile, offset: int) -> Optional[str]:
    """Read a null-terminated ASCII debug name at `offset`.

    Returns None if the bytes there do not look like a valid name.
    """
    if offset < 0 or offset >= rom.size:
        return None
    length = min(_NAME_MAX_LEN, rom.size - offset)
    raw = rom.read(offset, length)
    end = raw.find(b"\x00")
    if end < 0 or end < _NAME_MIN_LEN:
        return None
    try:
        text = raw[:end].decode("ascii")
    except UnicodeDecodeError:
        return None
    if not text or text[0] not in _NAME_FIRST_ALLOWED:
        return None
    if any(ch not in _NAME_ALLOWED for ch in text):
        return None
    return text


def _looks_like_record(rom: RomFile, off: int) -> Optional[ConversionEntry]:
    """Try to interpret `off` as a GroundConversionStruct start.

    Returns the decoded entry or None if the record fails any of the
    structural checks (s16 bounds, ROM pointer, text validity).
    """
    if off + RECORD_SIZE > rom.size:
        return None
    rec = rom.read(off, RECORD_SIZE)
    unk0             = _read_s16(rec, 0)
    ground_place_id  = _read_s16(rec, 2)
    map_file_table_id = _read_s16(rec, 4)
    unk6             = _read_s16(rec, 6)
    text_ptr         = _read_u32(rec, 8)

    if abs(unk0) > _S16_MAX_MAGNITUDE:
        return None
    if abs(ground_place_id) > _S16_MAX_MAGNITUDE:
        return None
    if abs(map_file_table_id) > _S16_MAX_MAGNITUDE:
        return None
    if abs(unk6) > _S16_MAX_MAGNITUDE:
        return None
    if not RomFile.looks_like_rom_pointer(text_ptr):
        return None
    try:
        text_off = rom.pointer_to_offset(text_ptr)
    except Exception:
        return None
    text = _read_ascii_name(rom, text_off)
    if text is None:
        return None
    return ConversionEntry(
        offset=off,
        unk0=unk0,
        ground_place_id=ground_place_id,
        map_file_table_id=map_file_table_id,
        unk6=unk6,
        text_offset=text_off,
        text=text,
    )


# ---------------------------------------------------------------- resolver


def resolve(rom: RomFile, *, min_entries: int = 32) -> ResolvedConversionTable:
    """Find the ground_map_conversion_table in the ROM.

    Linear scan, 4-byte stride. Whenever a candidate record parses,
    we try to extend the run for as long as consecutive records also
    parse. The longest run of length >= `min_entries` wins.

    Complexity: single ROM pass at a 4-byte stride. On a 32 MiB ROM
    this is ~4 s of Python CPU time on a typical laptop.
    """
    best_start: Optional[int] = None
    best_entries: list[ConversionEntry] = []

    # Skip the boot header region.
    off = 0x200
    end = rom.size
    while off + RECORD_SIZE <= end:
        first = _looks_like_record(rom, off)
        if first is None:
            off += 4
            continue

        entries = [first]
        cursor = off + RECORD_SIZE
        while cursor + RECORD_SIZE <= end:
            nxt = _looks_like_record(rom, cursor)
            if nxt is None:
                break
            entries.append(nxt)
            cursor += RECORD_SIZE

        if len(entries) > len(best_entries):
            best_entries = entries
            best_start = off

        # Skip past this run so we do not rescan its contents.
        off = cursor + 4 if len(entries) > 1 else off + 4

    if best_start is None or len(best_entries) < min_entries:
        return ResolvedConversionTable(
            status="UNRESOLVED",
            reason=(
                f"no run of >= {min_entries} plausible "
                f"GroundConversionStruct records found "
                f"(best={len(best_entries)})"
            ),
        )

    return ResolvedConversionTable(
        status="RESOLVED",
        reason=(
            f"longest structurally valid run: {len(best_entries)} records "
            f"starting at {best_start:#010x}"
        ),
        table_offset=best_start,
        entry_count=len(best_entries),
        entries=best_entries,
    )
