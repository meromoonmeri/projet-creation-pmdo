"""Stage 1 — inspect and extract from the local ROM.

Two responsibilities:

  A. Generic inspection.
     Runs converter.rom.inspection.inspect() on the authenticated ROM.
     This gives us a machine-readable picture of the cartridge (header,
     pointer tables, compression signatures) WITHOUT any game-specific
     hard-coded offset. The report lands in
     converter/rom_output/s01_extract/inspection.json and drives
     everything downstream.

  B. Registry-driven byte-range copy (optional).
     If converter/registry/rom_regions.json declares regions, each
     region is copied out of the ROM into a .bin under rom_output/
     with a sidecar .json (offset, length, sha256). Downstream stages
     read those blobs; they never re-touch the ROM.

Neither responsibility ever writes ROM bytes back to the repository:
the extraction directory is git-ignored.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any

from converter.aux_sources.pret import load_pret_checkout
from converter.pmdred.specs import DEFAULT_SPECS
from converter.pmdred.table_resolver import resolve as resolve_tables
from converter.rom.inspection import inspect as inspect_rom
from converter.rom.pointer_scan import iter_pointer_tables
from converter.rom.rom_file import RomFile
from converter.stages.context import Context, StageResult, StageStatus
from converter.version import __version__


STAGE = "s01_extract"
REGISTRY_REL = "converter/registry/rom_regions.json"


def _load_registry(ctx: Context) -> dict[str, Any]:
    path = ctx.repo_root / REGISTRY_REL
    if not path.exists():
        return {"version": 0, "regions": []}
    return json.loads(path.read_text(encoding="utf-8"))


def _sha256(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()


def _extract_region(rom: RomFile, region: dict[str, Any],
                    out_dir: Path) -> dict[str, Any]:
    name = region["name"]
    offset = int(region["offset"], 0) if isinstance(region["offset"], str) \
        else int(region["offset"])
    length = int(region["length"], 0) if isinstance(region["length"], str) \
        else int(region["length"])
    if offset < 0 or length <= 0 or offset + length > rom.size:
        return {
            "name": name,
            "status": "SKIPPED",
            "reason": (
                f"Out-of-bounds region offset={offset:#x} length={length}"
            ),
        }
    blob = rom.read(offset, length)
    dest = out_dir / f"{name}.bin"
    dest.write_bytes(blob)
    sha = _sha256(blob)
    sidecar = {
        "name": name,
        "offset": offset,
        "length": length,
        "sha256": sha,
        "kind": region.get("kind", ""),
        "notes": region.get("notes", ""),
        "extractor_version": __version__,
    }
    (out_dir / f"{name}.json").write_text(
        json.dumps(sidecar, indent=2, sort_keys=True) + "\n",
        encoding="utf-8", newline="\n",
    )
    return {
        "name": name,
        "status": "EXTRACTED",
        "bytes": length,
        "sha256_head": sha[:16],
    }


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    out = ctx.stage_output_dir(STAGE)

    if ctx.rom_path is None or ctx.rom_actual_hash is None:
        result.reason = (
            "No authenticated ROM (s00_detect did not PASS). "
            "Nothing to inspect or extract."
        )
        return result

    # --- part A: generic inspection ------------------------------------
    with RomFile.open(ctx.rom_path) as rom:
        if rom.sha256() != ctx.rom_actual_hash:
            result.status = StageStatus.FAIL
            result.reason = (
                "ROM hash changed between s00 and s01 (file was modified "
                "under our feet)."
            )
            return result

        report = inspect_rom(rom, out_dir=out)
        result.metrics["header"] = report.header
        result.metrics["pointer_tables_found"] = report.pointer_tables_found
        result.metrics["compression_signatures"] = report.compression_signatures
        result.artefacts.append(str(out / "inspection.json"))

        # --- PMD-Red-specific table resolution -------------------------
        # We use the local pret/pmd-red checkout (git-ignored) as
        # documentation only, to know the expected entry counts. If the
        # checkout is absent, the resolver still runs but with less
        # information; each unresolved table gets an explicit reason.
        pret = load_pret_checkout(ctx.pret_checkout) \
            if ctx.pret_checkout else None
        # Re-scan tables with a lower min_entries threshold so the
        # resolver can consider medium-sized tables (some role tables
        # in PMD Red are smaller than the default 8 cut-off).
        tables = list(iter_pointer_tables(rom, min_entries=4))
        resolved = resolve_tables(rom, tables, DEFAULT_SPECS, pret)
        ctx.write_json(out / "resolved_tables.json", {
            "pret_checkout_present": pret is not None,
            "candidates_considered": len(tables),
            "specs_evaluated": len(DEFAULT_SPECS),
            "results": [r.to_json() for r in resolved],
        })
        result.artefacts.append(str(out / "resolved_tables.json"))
        result.metrics["tables_resolved"] = sum(
            1 for r in resolved if r.status == "RESOLVED"
        )
        result.metrics["tables_unresolved"] = sum(
            1 for r in resolved if r.status == "UNRESOLVED"
        )
        result.metrics["pret_checkout_present"] = pret is not None

        # --- part B: registry-driven raw extraction --------------------
        registry = _load_registry(ctx)
        regions = registry.get("regions", [])
        result.metrics["registry_regions_declared"] = len(regions)

        records: list[dict[str, Any]] = []
        for reg in regions:
            records.append(_extract_region(rom, reg, out))

        if records:
            ctx.write_json(out / "_manifest.json", {
                "registry_version": registry.get("version", 0),
                "extractor_version": __version__,
                "rom_sha256": ctx.rom_actual_hash,
                "regions": records,
            })
            result.artefacts.append(str(out / "_manifest.json"))
            extracted = sum(1 for r in records if r["status"] == "EXTRACTED")
            result.metrics["regions_extracted"] = extracted
            result.metrics["regions_skipped"] = len(records) - extracted

    # Verdict.
    # We PASS if inspection succeeded, even if the region registry is
    # empty: the inspection itself is genuine work (real bytes, real
    # tables, real sizes). Downstream stages will pick up from here.
    result.status = StageStatus.PASS
    result.reason = (
        f"Inspected ROM ({report.pointer_tables_found} pointer tables, "
        f"{sum(report.compression_signatures.values())} compressed refs); "
        f"resolved {result.metrics.get('tables_resolved', 0)}/"
        f"{len(DEFAULT_SPECS)} PMD Red table roles "
        f"(pret checkout: "
        f"{'present' if result.metrics.get('pret_checkout_present') else 'absent'}). "
        f"Registry: {len(regions)} declared regions"
        + (f", {result.metrics.get('regions_extracted', 0)} extracted."
           if regions else " (empty — inspection-only run).")
    )
    return result
