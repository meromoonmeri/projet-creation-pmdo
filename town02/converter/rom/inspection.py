"""High-level ROM inspection: run all generic scans and emit a report.

Consumes the RomFile, header, pointer scan and compression sniff
primitives to build a global "what does this ROM contain?" picture
without touching any game-specific assumption. The output feeds stages
s01+ so they can locate regions of interest without hand-fed offsets.

Emitted artefacts live under converter/rom_output/inspection/. They
list *what was found in the local ROM*, never its byte contents beyond
tiny hex previews used for debugging (offsets + lengths only).
"""
from __future__ import annotations

import json
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

from converter.rom.compression import CompressionKind, sniff_header
from converter.rom.header import GbaHeader, read_header
from converter.rom.pointer_scan import PointerTable, iter_pointer_tables
from converter.rom.rom_file import RomFile


@dataclass
class InspectionReport:
    rom_path: str
    rom_size: int
    rom_sha256: str
    header: dict
    pointer_tables_found: int
    pointer_tables_top: list[dict] = field(default_factory=list)
    compression_signatures: dict = field(default_factory=dict)

    def to_json(self) -> dict:
        return {
            "rom_path":                str(self.rom_path),
            "rom_size":                self.rom_size,
            "rom_sha256":              self.rom_sha256,
            "header":                  self.header,
            "pointer_tables_found":    self.pointer_tables_found,
            "pointer_tables_top":      self.pointer_tables_top,
            "compression_signatures":  self.compression_signatures,
        }


def _header_to_json(h: GbaHeader) -> dict:
    return {
        "game_title":         h.game_title,
        "game_code":          h.game_code,
        "maker_code":         h.maker_code,
        "region_hint":        h.region_hint,
        "fixed_96_ok":        h.fixed_96_ok,
        "software_version":   h.software_version,
        "complement_check":   h.complement_check,
        "header_looks_valid": h.header_looks_valid,
    }


def _table_to_json(t: PointerTable) -> dict:
    return {
        "offset":      f"{t.offset:#010x}",
        "count":       t.count,
        "span_bytes":  t.span_bytes,
        "min_target":  f"{t.min_target:#x}",
        "max_target":  f"{t.max_target:#x}",
    }


def _sample_compression_kinds(
    rom: RomFile, candidates: list[int], sample_cap: int = 4096
) -> dict[str, int]:
    """For each candidate offset, sniff the compression header byte and
    tally the kinds. `candidates` is truncated to `sample_cap` to keep
    the scan bounded on huge ROMs."""
    counts: Counter[str] = Counter()
    for off in candidates[:sample_cap]:
        # Read only 4 bytes; sniff_header needs no more.
        try:
            head = rom.read(off, 4)
        except IndexError:
            continue
        h = sniff_header(head)
        if h.kind is not CompressionKind.UNKNOWN:
            counts[h.kind.value] += 1
    return dict(counts)


def inspect(
    rom: RomFile,
    *,
    out_dir: Optional[Path] = None,
    max_pointer_tables_kept: int = 32,
) -> InspectionReport:
    """Full generic inspection pass on the user's local ROM.

    Never uses game-specific offsets. Everything discovered here is
    derived from the ROM bytes and from public GBA hardware spec.
    """
    header = read_header(rom.read(0, 0xC0))

    # Enumerate pointer tables (bounded pass).
    tables = list(iter_pointer_tables(rom, min_entries=8))
    tables.sort(key=lambda t: t.count, reverse=True)
    top = tables[:max_pointer_tables_kept]

    # For every unique target of the top tables, sniff a compression
    # signature. This gives us a quick global picture ("how many LZ77
    # streams are referenced by the biggest tables?") without decoding.
    targets: set[int] = set()
    for t in top:
        # We don't have per-entry offsets kept in PointerTable to save
        # memory; re-read the entries lazily here.
        for i in range(t.count):
            targets.add(rom.pointer_to_offset(rom.read_u32(t.offset + i * 4)))

    comp = _sample_compression_kinds(rom, sorted(targets))

    report = InspectionReport(
        rom_path=str(rom.path),
        rom_size=rom.size,
        rom_sha256=rom.sha256(),
        header=_header_to_json(header),
        pointer_tables_found=len(tables),
        pointer_tables_top=[_table_to_json(t) for t in top],
        compression_signatures=comp,
    )

    if out_dir is not None:
        out_dir.mkdir(parents=True, exist_ok=True)
        (out_dir / "inspection.json").write_text(
            json.dumps(report.to_json(), indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
        )

    return report
