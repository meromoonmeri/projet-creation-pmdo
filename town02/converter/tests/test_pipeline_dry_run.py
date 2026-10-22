"""Pipeline dry-run test.

Runs the full pipeline in a temporary workspace with NO ROM present,
and checks that each stage reports the honest expected status:

  s00_detect       SKIPPED (no ROM in rom_input/)
  s01_extract      SKIPPED (no authenticated ROM)
  s02_decode       UNIMPLEMENTED (decoders are stubs)
  s03_normalise    UNIMPLEMENTED (nothing decoded)
  s04_map          UNIMPLEMENTED (nothing normalised)
  s05_emit         UNIMPLEMENTED (nothing mapped)
  s06_validate     SKIPPED (nothing emitted)
  s07_runtime      SKIPPED or UNIMPLEMENTED (no runtime harness wired)
  s08_report       PASS (always aggregates)

This test enforces that a fresh checkout, with no ROM and no runtime,
never produces a fake PASS on anything content-related.
"""
from __future__ import annotations

import json
from pathlib import Path

from converter.pipeline import main


REPO_ROOT = Path(__file__).resolve().parents[2]


def _read_report() -> dict:
    report_path = REPO_ROOT / "converter" / "rom_output" / "s08_report" / "report.json"
    return json.loads(report_path.read_text(encoding="utf-8"))


def _rom_present() -> bool:
    rom_dir = REPO_ROOT / "converter" / "rom_input"
    if not rom_dir.is_dir():
        return False
    return any(p.suffix.lower() == ".gba" for p in rom_dir.iterdir())


def test_dry_run_pipeline_is_honest() -> None:
    import pytest
    if _rom_present():
        pytest.skip(
            "authenticated ROM present in converter/rom_input/: the "
            "empty-state honesty contract does not apply (stages "
            "legitimately PASS on real input)"
        )
    exit_code = main(["--dry-run", "-v"])
    # Honest gaps are not failures. Exit code should not be a hard FAIL.
    assert exit_code in (0,), (
        f"Pipeline should not report hard FAIL when only honest gaps "
        f"exist. Got exit_code={exit_code}"
    )

    report = _read_report()
    by_stage = {s["stage"]: s for s in report["stages"]}

    # Stages that MUST refuse a fake PASS in the empty state.
    # Acceptable honest statuses: SKIPPED (no ROM) or UNIMPLEMENTED
    # (stub logic). Never PASS on empty input.
    HONEST_EMPTY = {"SKIPPED", "UNIMPLEMENTED"}
    for content_stage in (
        "s02_decode",
        "s03_normalise",
        "s04_map",
        "s05_emit",
    ):
        assert by_stage[content_stage]["status"] in HONEST_EMPTY, (
            f"{content_stage} must not PASS with no upstream input. "
            f"Got: {by_stage[content_stage]}"
        )
        assert by_stage[content_stage]["reason"], (
            f"{content_stage} must give a reason when {by_stage[content_stage]['status']}"
        )

    # s00 must be SKIPPED (no ROM) — not PASS, not FAIL.
    assert by_stage["s00_detect"]["status"] in ("SKIPPED",), (
        f"s00_detect with no ROM should be SKIPPED. "
        f"Got: {by_stage['s00_detect']}"
    )

    # s01 must not silently succeed when s00 did not authenticate a ROM.
    assert by_stage["s01_extract"]["status"] in ("SKIPPED", "UNIMPLEMENTED"), (
        f"s01_extract without an authenticated ROM must not PASS. "
        f"Got: {by_stage['s01_extract']}"
    )

    # s06 static checks: no artefact => SKIPPED (no fake PASS).
    assert by_stage["s06_validate"]["status"] in ("SKIPPED",), (
        f"s06_validate with nothing emitted must be SKIPPED, not PASS. "
        f"Got: {by_stage['s06_validate']}"
    )

    # s07 runtime: must never invent a PASS.
    assert by_stage["s07_runtime"]["status"] in ("SKIPPED", "UNIMPLEMENTED"), (
        f"s07_runtime must never fake a PASS. Got: {by_stage['s07_runtime']}"
    )

    # s08 always aggregates. It is not present in the aggregated
    # `stages` list (it aggregates the OTHERS), but its output files
    # must exist on disk.
    report_dir = REPO_ROOT / "converter" / "rom_output" / "s08_report"
    assert (report_dir / "report.json").is_file()
    assert (report_dir / "report.md").is_file()
