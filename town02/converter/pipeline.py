"""Converter pipeline entry point.

Usage:

    python -m converter.pipeline --scope d01p02
    python -m converter.pipeline --only-stages s00_detect,s01_extract
    python -m converter.pipeline --dry-run

The pipeline never modifies files under Data/ / Content/ / Strings/
unless stage s05_emit passes. All intermediate output goes to
converter/rom_output/ (git-ignored).
"""
from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path

from converter.stages import (
    s00_detect,
    s01_extract,
    s02_decode,
    s02_decode_ground,
    s03_normalise,
    s04_map,
    s05_emit,
    s06_validate,
    s07_runtime,
    s08_report,
    s09_report_dungeons,
    s10_promote,
)
from converter.stages.context import Context, StageResult, StageStatus


STAGES = [
    ("s00_detect", s00_detect),
    ("s01_extract", s01_extract),
    ("s02_decode", s02_decode),
    ("s02_decode_ground", s02_decode_ground),
    ("s03_normalise", s03_normalise),
    ("s04_map", s04_map),
    ("s05_emit", s05_emit),
    ("s06_validate", s06_validate),
    ("s07_runtime", s07_runtime),
    ("s09_report_dungeons", s09_report_dungeons),
    ("s10_promote", s10_promote),
]


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def _build_context(args: argparse.Namespace) -> Context:
    root = _repo_root()
    ctx = Context(
        repo_root=root,
        rom_input_dir=root / "converter" / "rom_input",
        rom_output_dir=root / "converter" / "rom_output",
        rom_cache_dir=root / "converter" / "rom_cache",
        pret_checkout=(root / "dev" / "external" / "pret_pmd_red")
        if (root / "dev" / "external" / "pret_pmd_red").is_dir()
        else None,
        reserve_dir=root / "dev" / "RESERVE" / "pmdred_direct",
        dry_run=args.dry_run,
        only_stages=(
            [s.strip() for s in args.only_stages.split(",") if s.strip()]
            if args.only_stages
            else None
        ),
        scope_grounds=(
            [s.strip() for s in args.scope.split(",") if s.strip()]
            if args.scope
            else None
        ),
    )
    ctx.rom_input_dir.mkdir(parents=True, exist_ok=True)
    ctx.rom_output_dir.mkdir(parents=True, exist_ok=True)
    ctx.rom_cache_dir.mkdir(parents=True, exist_ok=True)
    return ctx


def _configure_logging(verbose: bool) -> None:
    logging.basicConfig(
        format="%(asctime)s %(levelname)-7s %(name)s: %(message)s",
        level=logging.DEBUG if verbose else logging.INFO,
        stream=sys.stderr,
    )


def _should_run(stage_name: str, only: list[str] | None) -> bool:
    if not only:
        return True
    return stage_name in only


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(prog="converter", description=__doc__)
    p.add_argument("--dry-run", action="store_true",
                   help="Never write under Data/, Content/, Strings/. "
                        "Emit staging only.")
    p.add_argument("--only-stages", default="",
                   help="Comma-separated stage names to run (default: all).")
    p.add_argument("--scope", default="",
                   help="Comma-separated ground ids to process "
                        "(default: as decided by each stage).")
    p.add_argument("-v", "--verbose", action="store_true")
    args = p.parse_args(argv)

    _configure_logging(args.verbose)
    ctx = _build_context(args)
    log = logging.getLogger("converter.pipeline")

    results: list[StageResult] = []
    for name, mod in STAGES:
        if not _should_run(name, ctx.only_stages):
            log.info("skip stage %s (filtered out)", name)
            results.append(StageResult(stage=name, status=StageStatus.SKIPPED,
                                       reason="filtered out by --only-stages"))
            continue
        log.info("run stage %s", name)
        try:
            res = mod.run(ctx)
        except Exception as exc:  # noqa: BLE001
            log.exception("stage %s crashed", name)
            res = StageResult(stage=name, status=StageStatus.FAIL,
                              reason=f"crash: {exc!r}")
        res.ended_utc = res.started_utc  # will be overwritten by real timing later
        log.info("  -> %s: %s", res.status.value, res.reason or "(no reason)")
        results.append(res)

    # s08 always runs to aggregate what we have.
    log.info("run stage s08_report")
    try:
        s8 = s08_report.run(ctx, results)
    except Exception as exc:  # noqa: BLE001
        log.exception("s08 crashed")
        s8 = StageResult(stage="s08_report", status=StageStatus.FAIL,
                         reason=f"crash: {exc!r}")
    results.append(s8)

    # Exit code = worst status among the true stages (not counting SKIPPED).
    ranking = {
        StageStatus.PASS: 0,
        StageStatus.SKIPPED: 0,
        StageStatus.UNIMPLEMENTED: 0,   # not a failure, an honest gap
        StageStatus.UNKNOWN: 0,
        StageStatus.BLOCKED: 0,
        StageStatus.FAIL: 2,
    }
    worst = max((ranking[r.status] for r in results), default=0)
    return worst


if __name__ == "__main__":
    sys.exit(main())
