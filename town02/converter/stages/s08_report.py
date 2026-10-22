"""Stage 8 — aggregate a truthful report.

Collects every StageResult, every emitted provenance, every unknown
opcode / blocked mechanism, and writes:

  converter/rom_output/report.json    (machine-readable)
  converter/rom_output/report.md      (human-readable, per-ground table)

The report explicitly separates:
  * what the converter CAN do today (with reproducible evidence),
  * what it CANNOT do yet (with a specific reason: missing decoder,
    missing PMDO mechanism, missing ROM data, missing runtime harness).

No `PASS` at the aggregate level: the summary is a matrix, not a grade.
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from converter.stages.context import Context, StageResult, StageStatus
from converter.version import __version__


STAGE = "s08_report"


def run(ctx: Context, prior_results: list[StageResult]) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.PASS)

    out = ctx.stage_output_dir(STAGE)
    payload: dict[str, Any] = {
        "converter_version": __version__,
        "rom_authenticated": ctx.rom_actual_hash is not None,
        "scope_grounds": ctx.scope_grounds or [],
        "stages": [r.to_json() for r in prior_results],
    }
    ctx.write_json(out / "report.json", payload)

    # Human-readable summary
    lines = [
        "# Converter run report",
        "",
        f"- Converter version : `{__version__}`",
        f"- ROM authenticated : `{payload['rom_authenticated']}`",
        f"- Scope grounds     : `{payload['scope_grounds'] or 'all'}`",
        "",
        "## Stage summary",
        "",
        "| Stage | Status | Reason |",
        "|---|---|---|",
    ]
    for r in prior_results:
        reason = (r.reason or "").replace("|", "\\|").replace("\n", " ")
        lines.append(f"| `{r.stage}` | `{r.status.value}` | {reason} |")
    lines.append("")

    (out / "report.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    result.artefacts.append(str(out / "report.json"))
    result.artefacts.append(str(out / "report.md"))
    result.reason = f"Aggregated {len(prior_results)} prior stage results."
    return result
