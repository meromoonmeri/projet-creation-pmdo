"""Scan a GBA ROM for pointer tables.

A pointer table in a GBA ROM is a run of 32-bit little-endian words,
each one a valid ARM ROM address (top byte 0x08 or 0x09, word-aligned).
Identifying pointer tables is a foundational step for any converter
because most game data lives at the end of a chain of tables.

This module is generic: it makes no PMD-Red-specific assumption. Higher
layers (converter/pmdred/) will consume the tables identified here and
apply game-specific validation to keep the true positives.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable

from converter.rom.rom_file import RomFile


@dataclass(frozen=True)
class PointerTable:
    """A candidate contiguous run of ROM pointers."""

    offset: int             # file-relative start of the table
    count: int              # number of pointer entries
    span_bytes: int         # count * 4
    min_target: int         # min target offset the entries point to
    max_target: int         # max target offset

    @property
    def end_offset(self) -> int:
        return self.offset + self.span_bytes


def iter_pointer_tables(
    rom: RomFile,
    *,
    min_entries: int = 4,
    scan_start: int = 0x200,        # skip the header
    scan_end: int | None = None,
    stride: int = 4,
) -> Iterable[PointerTable]:
    """Yield candidate pointer tables found in `rom`.

    A "table" is a run of `>= min_entries` consecutive word-aligned
    32-bit words that all decode to valid ROM offsets. Zero words act
    as separators (many tables end on a zero terminator).

    Complexity: single linear pass across the ROM at a 4-byte stride.
    On a 32 MiB ROM this is ~2 seconds of CPU in pure Python; good
    enough for one-shot scans, and later stages can cache the result.
    """
    end = rom.size if scan_end is None else min(rom.size, scan_end)
    off = (scan_start + 3) & ~3    # 4-byte align

    while off + 4 <= end:
        # Try to start a run here.
        first = rom.maybe_read_pointer(off)
        if first is None:
            off += stride
            continue

        # Extend as long as consecutive words are valid ROM pointers.
        run_start = off
        entries: list[int] = [first]
        cursor = off + 4
        while cursor + 4 <= end:
            nxt = rom.maybe_read_pointer(cursor)
            if nxt is None:
                break
            entries.append(nxt)
            cursor += 4

        if len(entries) >= min_entries:
            yield PointerTable(
                offset=run_start,
                count=len(entries),
                span_bytes=len(entries) * 4,
                min_target=min(entries),
                max_target=max(entries),
            )

        # Jump past this run (or past the single failed word).
        off = cursor + 4 if len(entries) >= min_entries else off + stride
