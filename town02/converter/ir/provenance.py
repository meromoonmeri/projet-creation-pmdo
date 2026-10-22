"""Provenance dataclass.

Every artefact emitted by the converter carries a Provenance instance so
we can trace every byte back to the ROM (or to an auxiliary source when
the ROM alone is not enough) and grade the confidence of the result.
"""
from __future__ import annotations

from dataclasses import dataclass, field, asdict
from datetime import datetime, timezone
from enum import Enum
from typing import Any, Optional


class Status(str, Enum):
    """Confidence grade attached to every emitted artefact.

    CANONICAL      : bit-for-bit re-encoding of a ROM region we fully
                     understand, deterministic across runs on the same
                     ROM hash.
    PORTED         : ROM-authoritative content mapped losslessly to the
                     PMDO representation (semantic loss = 0).
    PARTIAL        : ROM-authoritative content mapped with documented
                     loss (e.g. a GBA-only effect approximated in PMDO).
    RECONSTRUCTED  : inferred from an auxiliary source (pret/pmd-red,
                     SkyTemple documentation) when the ROM data alone
                     was insufficient to reproduce the behaviour.
    UNKNOWN        : the source data is present in the ROM but the
                     converter cannot decode it yet. Never a silent
                     drop: the raw bytes are archived and offset logged.
    BLOCKED        : the source data is understood but PMDO 0.8.12 has
                     no mechanism to express it faithfully. Reported.
    """

    CANONICAL = "CANONICAL"
    PORTED = "PORTED"
    PARTIAL = "PARTIAL"
    RECONSTRUCTED = "RECONSTRUCTED"
    UNKNOWN = "UNKNOWN"
    BLOCKED = "BLOCKED"


@dataclass(frozen=True)
class AuxRef:
    """Reference to an auxiliary source used alongside the ROM."""

    path: str          # e.g. "pret/pmd-red/data/scripts/intro.inc"
    sha256: str        # hash of that auxiliary file when converter ran
    reason: str        # why this aux source was needed


@dataclass
class Provenance:
    rom_sha256: str                     # must equal the expected ROM hash
    rom_offset: Optional[int] = None    # byte offset in the ROM, if known
    rom_length: Optional[int] = None    # bytes consumed at that offset
    extractor_version: str = ""
    extracted_at_utc: str = field(
        default_factory=lambda: datetime.now(timezone.utc).isoformat(
            timespec="seconds"
        )
    )
    auxiliary: list[AuxRef] = field(default_factory=list)
    status: Status = Status.UNKNOWN
    status_reason: str = ""

    def __post_init__(self) -> None:
        # Enforce the reason rule so the pipeline cannot silently ship
        # anything below PORTED/CANONICAL without an explanation.
        if self.status in (
            Status.PARTIAL,
            Status.RECONSTRUCTED,
            Status.UNKNOWN,
            Status.BLOCKED,
        ) and not self.status_reason.strip():
            raise ValueError(
                f"Provenance status {self.status.value} requires a "
                f"non-empty status_reason"
            )

    def to_json(self) -> dict[str, Any]:
        out = asdict(self)
        out["status"] = self.status.value
        return out
