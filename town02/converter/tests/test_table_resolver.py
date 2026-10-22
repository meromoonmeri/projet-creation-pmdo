"""Tests for the PMD Red table resolver.

Builds a synthetic ROM (never any real game content) that contains one
pointer table matching a synthetic TableSpec, and proves the resolver
picks it. Also proves that a spec without a matching candidate returns
UNRESOLVED with a specific reason (no fabricated PASS).
"""
from __future__ import annotations

import struct
from pathlib import Path

from converter.aux_sources.pret import PretCheckout, PretEnum
from converter.pmdred.table_resolver import TableSpec, resolve
from converter.rom.compression import CompressionKind
from converter.rom.pointer_scan import iter_pointer_tables
from converter.rom.rom_file import RomFile


def _synth_rom(tmp_path: Path) -> Path:
    """A synthetic ROM with:
      * a pointer table of 6 entries at 0x1000, pointing to 6 targets
      * each target starts with an LZ77 header byte 0x10 followed by a
        small compressed body (we do not need the body to decompress
        for the resolver to score the compression signature).
    """
    data = bytearray(0x8000)
    # Targets at 0x2000, 0x2100, ... 0x2500
    for i in range(6):
        tgt = 0x2000 + i * 0x100
        # Write pointer entry
        struct.pack_into("<I", data, 0x1000 + i * 4, 0x08000000 + tgt)
        # Write a plausible LZ77 header at the target
        data[tgt] = 0x10                    # LZ77 signature nibble
        data[tgt + 1] = 0x40                # 64 bytes uncompressed (dummy)
    p = tmp_path / "synthetic.gba"
    p.write_bytes(bytes(data))
    return p


def _fake_pret_with_enum(n_members: int) -> PretCheckout:
    e = PretEnum(
        name="SynthShapes",
        members={f"SYN_{i}": i for i in range(n_members)},
    )
    return PretCheckout(root=Path("/nonexistent"), enums_by_name={e.name: e})


def test_resolver_picks_matching_table(tmp_path: Path) -> None:
    p = _synth_rom(tmp_path)
    with RomFile.open(p) as rom:
        tables = list(iter_pointer_tables(rom, min_entries=4))
        assert tables, "should find at least the synthetic pointer table"
        pret = _fake_pret_with_enum(6)   # expect 6 entries, matches table
        specs = [TableSpec(
            role="synthetic",
            pret_enum_for_count="SynthShapes",
            target_compression=CompressionKind.LZ77,
        )]
        out = resolve(rom, tables, specs, pret)
        assert len(out) == 1
        r = out[0]
        assert r.status == "RESOLVED", r
        assert r.count == 6
        assert r.offset == 0x1000
        assert r.match_score >= 0.7


def test_resolver_returns_unresolved_with_reason(tmp_path: Path) -> None:
    p = _synth_rom(tmp_path)
    with RomFile.open(p) as rom:
        tables = list(iter_pointer_tables(rom, min_entries=4))
        pret = _fake_pret_with_enum(999)  # no table has 999 entries
        specs = [TableSpec(
            role="unfindable",
            pret_enum_for_count="SynthShapes",
            target_compression=CompressionKind.LZ77,
        )]
        out = resolve(rom, tables, specs, pret)
        assert out[0].status == "UNRESOLVED"
        assert out[0].reason           # non-empty reason mandatory
        assert out[0].offset is None
