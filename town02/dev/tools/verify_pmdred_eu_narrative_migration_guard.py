#!/usr/bin/env python3
"""Freeze and verify immutable inputs for the PMD Red EU narrative migration.

This guard consumes the already-qualified Ground promotion records and the
completed narrative audit.  It does not convert, regenerate, index, promote, or
runtime-validate any Ground.  The write mode is create-only; normal migration
jobs use the check mode before and after every scene batch.
"""

from __future__ import annotations
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any, Iterable

SCHEMA = "new-era.pmdred-eu-narrative-migration-protected-baseline.v1"
DEFAULT_BASELINE = Path("docs/pmdred_eu/narrative_migration/protected_baseline.json")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def unique_rows(rows: Iterable[dict[str, str]]) -> list[dict[str, str]]:
    by_path: dict[str, dict[str, str]] = {}
    for row in rows:
        path = row["path"]
        previous = by_path.get(path)
        if previous is not None:
            require(previous["sha256"] == row["sha256"], f"conflicting baseline hash: {path}")
            continue
        by_path[path] = row
    return [by_path[path] for path in sorted(by_path)]


def current_row(root: Path, relative: str, role: str) -> dict[str, str]:
    path = root / relative
    require(path.is_file(), f"protected file missing: {relative}")
    return {"path": relative, "sha256": sha256_file(path), "role": role}


def build_baseline(root: Path) -> dict[str, Any]:
    progress_path = root / "docs/pmdred_eu/pmdo_validation/progress.json"
    final_audit_path = root / "docs/pmdred_eu/pmdo_validation/FINAL_AUDIT.json"
    scope_path = root / "docs/pmdred_eu/narrative_audit/narrative_scope.json"
    progress = read_json(progress_path)
    final_audit = read_json(final_audit_path)
    scope = read_json(scope_path)

    require(final_audit["result"] == "PASS_219_OF_219", "qualified Ground final audit is not PASS_219_OF_219")
    require(len(progress["grounds"]) == 219, "qualified Ground progress does not contain 219 rows")
    require(len(scope["chapter_1_to_5"]["explicit_files"]) == 99, "narrative audit does not contain 99 protected chapter files")

    ground_rows: list[dict[str, str]] = []
    for ground in progress["grounds"]:
        checks = ground.get("promoted_destination_checks", [])
        require(len(checks) == 2, f"{ground['id']}: expected exact Ground+tile destination checks")
        for check in checks:
            require(check["result"] == "PASS", f"{ground['id']}: historical destination check was not PASS")
            relative = check["path"]
            path = root / relative
            require(path.is_file(), f"{ground['id']}: promoted destination missing: {relative}")
            actual = sha256_file(path)
            require(actual == check["expected_sha256"], f"{ground['id']}: promoted destination drift before migration: {relative}")
            ground_rows.append({
                "path": relative,
                "sha256": check["expected_sha256"],
                "role": f"qualified_{check['role']}",
                "ground_id": ground["id"],
            })
    require(len(ground_rows) == 438, "expected 438 immutable Ground/tile destinations")

    chapter_rows = [
        current_row(root, relative, "chapter_1_to_5_explicitly_protected")
        for relative in scope["chapter_1_to_5"]["explicit_files"]
    ]

    routed = [scene for scene in scope["scenes"] if scene["new_era"]["in_fugitive_sequence"]]
    require(len(routed) == 27, "narrative audit does not contain 27 active FugitiveArc routes")
    historical_paths = {
        "Data/Script/halcyon/FugitiveArc.lua",
        "Data/Script/halcyon/FugitiveCinematics.lua",
        "Data/Script/halcyon/scriptvars.lua",
        "Data/Script/halcyon/arc_fugitif/strings.fr.resx",
        "Data/Zone/master_zone.json",
    }
    for scene in routed:
        historical_paths.add(scene["new_era"]["scene_file"])
        historical_paths.update(scene["new_era"]["ground_init_routes"])
    historical_rows = [
        current_row(root, relative, "preserved_new_era_historical_integration")
        for relative in sorted(historical_paths)
    ]

    return {
        "schema": SCHEMA,
        "created_at": "2026-08-12",
        "policy": {
            "grounds": "immutable certified inputs; scripts adapt to them",
            "chapters_1_to_5": "no overwrite, reroute, or flag reuse",
            "fugitive_arc": "parallel PMD Red EU namespace only",
            "write_mode": "create-only",
        },
        "authorities": {
            "final_ground_audit": str(final_audit_path.relative_to(root)),
            "final_ground_audit_sha256": sha256_file(final_audit_path),
            "ground_progress": str(progress_path.relative_to(root)),
            "ground_progress_sha256": sha256_file(progress_path),
            "narrative_scope": str(scope_path.relative_to(root)),
            "narrative_scope_sha256": sha256_file(scope_path),
        },
        "counts": {
            "qualified_ground_ids": 219,
            "immutable_ground_and_tile_files": len(ground_rows),
            "chapter_1_to_5_files": len(chapter_rows),
            "active_fugitive_routes": len(routed),
            "historical_integration_files": len(historical_rows),
        },
        "qualified_ground_destinations": ground_rows,
        "chapter_1_to_5_files": unique_rows(chapter_rows),
        "historical_integration_files": unique_rows(historical_rows),
    }


def verify_baseline(root: Path, baseline: dict[str, Any]) -> list[dict[str, str]]:
    require(baseline.get("schema") == SCHEMA, "unsupported migration baseline schema")
    failures: list[dict[str, str]] = []
    groups = (
        "qualified_ground_destinations",
        "chapter_1_to_5_files",
        "historical_integration_files",
    )
    for group in groups:
        rows = baseline.get(group)
        require(isinstance(rows, list), f"baseline group missing: {group}")
        for row in rows:
            path = root / row["path"]
            if not path.is_file():
                failures.append({"path": row["path"], "reason": "missing", "group": group})
                continue
            actual = sha256_file(path)
            if actual != row["sha256"]:
                failures.append({
                    "path": row["path"],
                    "reason": "sha256_mismatch",
                    "expected_sha256": row["sha256"],
                    "actual_sha256": actual,
                    "group": group,
                })
    return failures


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline", type=Path, default=DEFAULT_BASELINE)
    parser.add_argument("--write-baseline", action="store_true", help="create the baseline; refuses overwrite")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    baseline_path = args.baseline if args.baseline.is_absolute() else root / args.baseline

    if args.write_baseline:
        require(not baseline_path.exists(), f"refusing to overwrite baseline: {baseline_path}")
        baseline = build_baseline(root)
        baseline_path.parent.mkdir(parents=True, exist_ok=True)
        baseline_path.write_text(json.dumps(baseline, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    else:
        require(baseline_path.is_file(), f"baseline missing: {baseline_path}")
        baseline = read_json(baseline_path)

    failures = verify_baseline(root, baseline)
    if failures:
        print(json.dumps({"result": "FAIL", "failures": failures}, ensure_ascii=False, indent=2))
        return 1
    print("PMDRED_EU_NARRATIVE_MIGRATION_GUARD_PASS", json.dumps(baseline["counts"], sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
