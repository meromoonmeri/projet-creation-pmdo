"""Pipeline context and stage result types.

Shared between all stages. The Context is created by pipeline.py from
CLI arguments and threaded through every stage. A StageResult is what a
stage returns; the pipeline aggregates results into the final report.
"""
from __future__ import annotations

import json
import logging
from dataclasses import dataclass, field
from datetime import datetime, timezone
from enum import Enum
from pathlib import Path
from typing import Any, Optional


ROM_EXPECTED_HASH = (
    "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
)
ROM_EXPECTED_SIZE = 33_554_432   # 32 MiB


class StageStatus(str, Enum):
    PASS = "PASS"
    SKIPPED = "SKIPPED"           # legit skip (e.g. no ROM present, dry-run)
    UNIMPLEMENTED = "UNIMPLEMENTED"
    UNKNOWN = "UNKNOWN"
    BLOCKED = "BLOCKED"
    FAIL = "FAIL"


@dataclass
class StageResult:
    stage: str
    status: StageStatus
    reason: str = ""
    metrics: dict[str, Any] = field(default_factory=dict)
    artefacts: list[str] = field(default_factory=list)   # paths written
    warnings: list[str] = field(default_factory=list)
    started_utc: str = field(
        default_factory=lambda: datetime.now(timezone.utc)
        .isoformat(timespec="seconds")
    )
    ended_utc: str = ""

    def to_json(self) -> dict[str, Any]:
        d = dict(self.__dict__)
        d["status"] = self.status.value
        return d


@dataclass
class Context:
    """Everything a stage may need. Immutable-ish once built."""

    repo_root: Path
    rom_input_dir: Path
    rom_output_dir: Path
    rom_cache_dir: Path
    pret_checkout: Optional[Path]   # dev/external/pret_pmd_red if present
    reserve_dir: Path               # dev/RESERVE/pmdred_direct (existing audit)
    dry_run: bool = True
    only_stages: Optional[list[str]] = None
    scope_grounds: Optional[list[str]] = None   # e.g. ["d01p02"]
    log: logging.Logger = field(default_factory=lambda: logging.getLogger("converter"))
    rom_path: Optional[Path] = None
    rom_actual_hash: Optional[str] = None

    def stage_output_dir(self, stage_name: str) -> Path:
        p = self.rom_output_dir / stage_name
        p.mkdir(parents=True, exist_ok=True)
        return p

    def write_json(self, dest: Path, obj: Any) -> None:
        dest.parent.mkdir(parents=True, exist_ok=True)
        # deterministic: sorted keys, fixed indent, LF line endings
        text = json.dumps(obj, indent=2, sort_keys=True, ensure_ascii=False)
        dest.write_text(text + "\n", encoding="utf-8", newline="\n")
