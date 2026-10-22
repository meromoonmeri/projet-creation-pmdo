"""Resolve PMD Red data tables from a generic pointer-table inspection.

Strategy: the inspection stage (converter/rom/inspection.py) enumerates
plausible pointer tables in the ROM. For each *role* we care about
(dungeon-info table, ground-info table, script table, ...), we describe
its expected structural fingerprint here (entry count taken from a pret
enum, target payload compression, target size range) and pick the
candidate that matches. This means the converter locates the tables by
itself, without any hand-fed offset.

If no candidate matches, we say so explicitly (Candidate returned with
status = UNRESOLVED and a reason). We never guess.

Nothing in this module reads or reproduces game content: it works on
the small InspectionReport summary and on pret enum sizes.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional

from converter.aux_sources.pret import PretCheckout
from converter.rom.compression import CompressionKind, sniff_header
from converter.rom.pointer_scan import PointerTable
from converter.rom.rom_file import RomFile


# ---------------------------------------------------------------- specs


@dataclass(frozen=True)
class TableSpec:
    """Structural description of a data table we want to locate.

    The resolver picks the pointer-table candidate that best matches
    this spec, or returns UNRESOLVED with a reason if none does.
    """

    role: str                       # short label, e.g. "dungeon_info"
    pret_enum_for_count: Optional[str]  # enum whose member count == table count
    min_count: Optional[int] = None     # allow a range instead of an exact hit
    max_count: Optional[int] = None
    target_min_bytes: Optional[int] = None
    target_max_bytes: Optional[int] = None
    target_compression: Optional[CompressionKind] = None
    notes: str = ""


# ---------------------------------------------------------------- results


@dataclass
class ResolvedTable:
    role: str
    status: str                     # "RESOLVED" | "UNRESOLVED"
    reason: str = ""
    offset: Optional[int] = None
    count: Optional[int] = None
    entries: list[int] = field(default_factory=list)  # target offsets
    match_score: float = 0.0

    def to_json(self) -> dict:
        return {
            "role":        self.role,
            "status":      self.status,
            "reason":      self.reason,
            "offset":      None if self.offset is None else f"{self.offset:#010x}",
            "count":       self.count,
            "match_score": round(self.match_score, 3),
            # entries kept as decimal offsets to stay compact
            "entries":     self.entries[:8],   # only a preview
            "entries_total": len(self.entries),
        }


# ---------------------------------------------------------------- resolver


def _score_candidate(
    spec: TableSpec,
    table: PointerTable,
    rom: RomFile,
    expected_count: Optional[int],
) -> tuple[float, str]:
    """Return (score in [0..1], per-check reason string).

    Score components (each contributes evenly, missing spec fields are
    skipped and do not penalise):
      A. count matches expected_count (exact) or fits [min, max]
      B. target payloads have the expected compression signature
      C. target payload sizes fit [target_min_bytes, target_max_bytes]
    """
    reasons: list[str] = []
    total = 0
    matched = 0.0

    # A. count check
    if expected_count is not None:
        total += 1
        if table.count == expected_count:
            matched += 1.0
            reasons.append(f"count={table.count} == expected {expected_count}")
        else:
            reasons.append(
                f"count={table.count} != expected {expected_count}"
            )
    elif spec.min_count is not None or spec.max_count is not None:
        total += 1
        lo = spec.min_count or 1
        hi = spec.max_count or 10_000_000
        if lo <= table.count <= hi:
            matched += 1.0
            reasons.append(f"count={table.count} in [{lo},{hi}]")
        else:
            reasons.append(f"count={table.count} outside [{lo},{hi}]")

    # B. target compression signature check
    if spec.target_compression is not None:
        total += 1
        hits = 0
        # Sniff the first 8 entries only, this is enough as a fingerprint.
        sample_n = min(8, table.count)
        for i in range(sample_n):
            ptr_off = table.offset + i * 4
            try:
                target = rom.pointer_to_offset(rom.read_u32(ptr_off))
                head = rom.read(target, 4)
            except Exception:  # noqa: BLE001
                continue
            if sniff_header(head).kind is spec.target_compression:
                hits += 1
        if hits >= max(1, sample_n // 2):
            matched += hits / sample_n
            reasons.append(
                f"compression hits {hits}/{sample_n} match "
                f"{spec.target_compression.value}"
            )
        else:
            reasons.append(
                f"compression hits {hits}/{sample_n} do not match "
                f"{spec.target_compression.value}"
            )

    # C. target payload size range
    if spec.target_min_bytes is not None or spec.target_max_bytes is not None:
        total += 1
        lo = spec.target_min_bytes or 0
        hi = spec.target_max_bytes or (1 << 30)
        sample_n = min(16, table.count)
        entries = []
        for i in range(sample_n):
            ptr_off = table.offset + i * 4
            try:
                target = rom.pointer_to_offset(rom.read_u32(ptr_off))
                entries.append(target)
            except Exception:  # noqa: BLE001
                continue
        # Use gaps between consecutive targets as a proxy for payload size,
        # which works for tables of contiguous records; do a soft check.
        entries.sort()
        gaps = [b - a for a, b in zip(entries, entries[1:])]
        good = sum(1 for g in gaps if lo <= g <= hi)
        if gaps and good / len(gaps) >= 0.5:
            matched += good / len(gaps)
            reasons.append(
                f"gap size {good}/{len(gaps)} fit [{lo},{hi}]"
            )
        else:
            reasons.append(
                f"gap size {good}/{len(gaps) or 0} outside [{lo},{hi}]"
            )

    score = matched / total if total else 0.0
    return score, " | ".join(reasons)


def resolve(
    rom: RomFile,
    tables: list[PointerTable],
    specs: list[TableSpec],
    pret: Optional[PretCheckout],
) -> list[ResolvedTable]:
    """Return one ResolvedTable per spec.

    The best-scoring candidate above a fixed threshold wins. Any spec
    left without a good match yields status=UNRESOLVED with a reason,
    never a fabricated result.
    """
    THRESHOLD = 0.7
    out: list[ResolvedTable] = []
    for spec in specs:
        # Determine expected count from the pret enum, when possible.
        expected_count: Optional[int] = None
        if spec.pret_enum_for_count and pret is not None:
            e = pret.get_enum(spec.pret_enum_for_count)
            if e is not None and e.members:
                expected_count = len(e.members)

        best_table: Optional[PointerTable] = None
        best_score = 0.0
        best_reason = ""
        for t in tables:
            score, why = _score_candidate(spec, t, rom, expected_count)
            if score > best_score:
                best_score = score
                best_reason = why
                best_table = t

        if best_table is not None and best_score >= THRESHOLD:
            entries = []
            for i in range(best_table.count):
                try:
                    entries.append(
                        rom.pointer_to_offset(
                            rom.read_u32(best_table.offset + i * 4)
                        )
                    )
                except Exception:  # noqa: BLE001
                    break
            out.append(ResolvedTable(
                role=spec.role,
                status="RESOLVED",
                reason=best_reason,
                offset=best_table.offset,
                count=best_table.count,
                entries=entries,
                match_score=best_score,
            ))
        else:
            reason = (
                f"no candidate scored >= {THRESHOLD} "
                f"(best={best_score:.2f}); {best_reason or 'no candidates'}"
            )
            if expected_count is None and spec.pret_enum_for_count:
                reason += (
                    f"; pret enum {spec.pret_enum_for_count!r} not found "
                    f"in local checkout (loader returned no data)"
                )
            out.append(ResolvedTable(
                role=spec.role, status="UNRESOLVED", reason=reason,
            ))
    return out
