#!/usr/bin/env python3
"""Generate and verify the durable 219-Ground PMDO validation checkpoint.

The tracked plan, static inventory, and per-Ground validation records are the
sources of truth.  Ignored runtime state is inspected but never treated as the
only progress record.  This tool intentionally fails if a promoted destination
or immutable evidence file no longer has the recorded SHA-256.
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
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
PLAN_PATH = Path("docs/pmdred_eu/runtime_reference_plan_v2.json")
AUDIT_PATH = Path("docs/pmdred_eu/remaining_grounds/candidate_audit.json")
MANIFEST_PATH = Path("docs/pmdred_eu/ground_manifest.json")
LOCK_PATH = Path("docs/pmdred_eu/pmdo_validation/runtime_dependencies.lock.json")
DUNGEON_PATH = Path("docs/pmdred_eu/dungeon_grounds/manifest.json")
DEFAULT_JSON = Path("docs/pmdred_eu/pmdo_validation/progress.json")
DEFAULT_MD = Path("docs/pmdred_eu/pmdo_validation/RESUME.md")
RUNTIME_COPY = Path(".runtime-cache/recovery/ground_validation_progress.json")


def read_json(path: Path) -> Any:
    return json.loads((ROOT / path).read_text(encoding="utf-8-sig"))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def rel_sha(path: str) -> str | None:
    absolute = ROOT / path
    return sha256(absolute) if absolute.is_file() else None


def git(*args: str) -> str:
    return subprocess.check_output(
        ["git", *args], cwd=ROOT, text=True, stderr=subprocess.DEVNULL
    ).strip()


def parse_hash_manifest(path: Path) -> list[tuple[str, str]]:
    rows: list[tuple[str, str]] = []
    for line in (ROOT / path).read_text().splitlines():
        if not line.strip():
            continue
        expected, name = line.split(None, 1)
        rows.append((expected, name.strip()))
    return rows


def evidence_integrity(evidence_dir: Path) -> dict[str, Any]:
    manifest = evidence_dir / "evidence_hashes.sha256"
    immutable_failures: list[dict[str, Any]] = []
    historical_drift: list[dict[str, Any]] = []
    checked = 0
    if not (ROOT / manifest).is_file():
        return {
            "result": "FAIL",
            "manifest": manifest.as_posix(),
            "checked": 0,
            "immutable_failures": [{"path": manifest.as_posix(), "error": "missing"}],
            "historical_progressive_drift": [],
        }

    mutable_prefixes = (
        "tools/",
        "Data/Zone/master_zone.json",
        "docs/canonical/red/upstream_ground_aliases.json",
    )
    for expected, name in parse_hash_manifest(manifest):
        checked += 1
        actual = rel_sha(name)
        if actual == expected:
            continue
        item = {"path": name, "expected_sha256": expected, "actual_sha256": actual}
        if name.startswith(evidence_dir.as_posix() + "/"):
            immutable_failures.append(item)
        elif name.startswith(mutable_prefixes):
            # Older evidence manifests freeze the then-current mutable tool or
            # append-only registry bytes. Later validated promotions can change
            # those paths without changing the archived pass itself.
            historical_drift.append(item)
        else:
            immutable_failures.append(item)
    return {
        "result": "PASS" if not immutable_failures else "FAIL",
        "manifest": manifest.as_posix(),
        "checked": checked,
        "immutable_failures": immutable_failures,
        "historical_progressive_drift": historical_drift,
    }


def tree_manifest_gate(spec: dict[str, Any], tree_path: Path) -> tuple[str, dict[str, Any]]:
    """Verify a restoration manifest and every file it authenticates."""
    manifest_value = spec.get("tree_manifest")
    expected_manifest = spec.get("tree_manifest_sha256")
    if not manifest_value or not expected_manifest:
        return "FAIL", {"error": "tree manifest contract absent"}
    manifest = ROOT / manifest_value
    if not manifest.is_file():
        return "MISSING", {"manifest": manifest_value}
    actual_manifest = sha256(manifest)
    details: dict[str, Any] = {
        "manifest": manifest_value,
        "expected_manifest_sha256": expected_manifest,
        "actual_manifest_sha256": actual_manifest,
    }
    if actual_manifest != expected_manifest:
        return "FAIL", details
    rows = parse_hash_manifest(Path(manifest_value))
    expected_count = spec.get("tree_file_count")
    details["checked_file_count"] = len(rows)
    if expected_count is not None and len(rows) != expected_count:
        details["expected_file_count"] = expected_count
        return "FAIL", details
    for expected, name in rows:
        relative = Path(name)
        if relative.is_absolute() or ".." in relative.parts:
            details["error"] = f"unsafe manifest path: {name}"
            return "FAIL", details
        candidate = tree_path / relative
        if not candidate.is_file() or sha256(candidate) != expected:
            details["first_mismatch"] = name
            return "FAIL", details
    return "PASS", details


def dependency_state(lock: dict[str, Any]) -> dict[str, Any]:
    """Evaluate every direct, tree, build, and import gate in the v2 lock."""
    state: dict[str, Any] = {}
    for section in ("artifacts", "derived_inputs"):
        for key, spec in lock[section].items():
            path_value = spec.get("local_path") or spec.get("path")
            if key == "runtime_reference_plan":
                path_value = spec["runtime_path"]
            elif key == "angle_swiftshader":
                path_value = spec["local_bundle_path"]
            elif key == "sdl_source":
                path_value = spec["local_source_path"]
            path = ROOT / path_value if path_value else None
            present = bool(path and path.exists())
            result: dict[str, Any] = {"path": path_value, "present": present}
            expected = spec.get("sha256")

            if expected:
                if path and path.is_file():
                    actual = sha256(path)
                    actual_bytes = path.stat().st_size
                    expected_bytes = spec.get("bytes")
                    result.update(
                        expected_sha256=expected,
                        actual_sha256=actual,
                        actual_bytes=actual_bytes,
                    )
                    if expected_bytes is not None:
                        result["expected_bytes"] = expected_bytes
                    result["hash_gate"] = (
                        "PASS"
                        if actual == expected
                        and (expected_bytes is None or actual_bytes == expected_bytes)
                        else "FAIL"
                    )
                else:
                    result.update(expected_sha256=expected, hash_gate="MISSING")
            elif not present:
                result["hash_gate"] = "MISSING"
            elif key in {"dumpasset", "normalized_extraction", "converter_candidates"}:
                gate, details = tree_manifest_gate(spec, path)
                result.update(details)
                result["hash_gate"] = gate
                if key == "dumpasset" and gate == "PASS":
                    marker = path / ".source-commit"
                    if not marker.is_file() or marker.read_text().strip() != spec["commit"]:
                        result["hash_gate"] = "FAIL"
                        result["source_marker"] = "MISMATCH"
                if key == "converter_candidates" and gate == "PASS":
                    report = ROOT / path_value / "conversion_report.json"
                    audit = ROOT / spec["audit_path"]
                    component_checks = {
                        "conversion_report": sha256(report) == spec["conversion_report_sha256"],
                        "audit": sha256(audit) == spec["audit_sha256"],
                    }
                    result["component_checks"] = component_checks
                    if not all(component_checks.values()):
                        result["hash_gate"] = "FAIL"
            elif key == "sdl_source":
                matches = sorted(ROOT.glob(spec["local_library_glob"]))
                actual = sha256(matches[0]) if len(matches) == 1 and matches[0].is_file() else None
                source_head = git("-C", spec["local_source_path"], "rev-parse", "HEAD")
                actual_bytes = matches[0].stat().st_size if len(matches) == 1 and matches[0].is_file() else None
                result.update(
                    expected_sha256=spec["expected_patched_library_sha256"],
                    actual_sha256=actual,
                    expected_bytes=spec["expected_patched_library_bytes"],
                    actual_bytes=actual_bytes,
                    source_head=source_head,
                    reproducibility=spec["independent_reproducibility_result"],
                )
                result["hash_gate"] = (
                    "PASS"
                    if actual == spec["expected_patched_library_sha256"]
                    and actual_bytes == spec["expected_patched_library_bytes"]
                    and source_head == spec["commit"]
                    and spec["independent_reproducibility_result"] == "PASS_BYTE_IDENTICAL"
                    else "FAIL"
                )
            elif key == "angle_swiftshader":
                checks = {
                    name: (path / name).is_file()
                    and sha256(path / name) == expected_hash
                    and (path / name).stat().st_size == spec["file_bytes"][name]
                    for name, expected_hash in spec["file_sha256"].items()
                }
                result["component_checks"] = checks
                result["hash_gate"] = "PASS" if all(checks.values()) else "FAIL"
            elif key == "technical_reference":
                head = git("-C", path_value, "rev-parse", "HEAD")
                result["source_head"] = head
                result["hash_gate"] = "PASS" if head == spec["commit"] else "FAIL"
            elif key == "python_environment":
                probe = subprocess.run(
                    [str(path / "bin/python"), "-c", (
                        "from importlib.metadata import version; "
                        "from PIL import Image; import skytemple_files; from lupa import LuaRuntime; "
                        "assert version('Pillow')=='12.3.0'; "
                        "assert version('skytemple-files')=='1.8.5'; "
                        "assert version('lupa')=='2.8'"
                    )],
                    cwd=ROOT,
                    capture_output=True,
                    text=True,
                )
                result["versions"] = spec["versions"]
                result["hash_gate"] = "PASS" if probe.returncode == 0 else "FAIL"
                if probe.returncode:
                    result["import_error"] = probe.stderr.strip()
            else:
                result["hash_gate"] = "FAIL"
                result["error"] = "lock component has no implemented gate"
            state[key] = result
    return state


def classification(record: dict[str, Any]) -> dict[str, Any]:
    source = record.get("special_classification", {}).get("canonical_source", {})
    return {
        "category": source.get("category") or source.get("classification"),
        "ground_map_symbol": source.get("ground_map_symbol"),
        "cinematic": source.get("cinematic"),
        "arena": source.get("arena"),
        "boss": source.get("boss"),
    }


def make_checkpoint() -> dict[str, Any]:
    plan = read_json(PLAN_PATH)
    audit = read_json(AUDIT_PATH)
    manifest = read_json(MANIFEST_PATH)
    lock = read_json(LOCK_PATH)
    dungeon = read_json(DUNGEON_PATH)
    order = plan["ground_order"]
    assert len(order) == 219 and len(set(order)) == 219
    assert audit["summary"]["passing_candidate_count"] == 219
    assert audit["summary"]["failure_count"] == 0 and not audit["failures"]
    assert audit["summary"]["all_graphical_tick_comparisons_exact"]
    assert all(item["status"] == "pass" for item in audit["candidates"])
    audit_by_id = {item["id"]: item for item in audit["candidates"]}
    manifest_by_id = {
        item["stable_ground_id"]: item
        for item in manifest["ground_conversion_table"]["entries"]
    }
    assert set(order) == set(audit_by_id)
    assert set(order).issubset(manifest_by_id)

    record_paths = sorted(
        ROOT.glob("docs/pmdred_eu/pmdo_validation/*_exhaustive_pass/validation_record.json")
    )
    records: dict[str, tuple[Path, dict[str, Any]]] = {}
    for absolute in record_paths:
        record = json.loads(absolute.read_text())
        ground = record["ground"]
        relative = absolute.relative_to(ROOT)
        if ground in records:
            raise AssertionError(f"duplicate validation record for {ground}")
        if ground not in audit_by_id:
            raise AssertionError(f"validated Ground absent from canonical inventory: {ground}")
        records[ground] = (relative, record)

    zone = read_json(Path("Data/Zone/master_zone.json"))["Object"]["GroundMaps"]
    grounds: list[dict[str, Any]] = []
    integrity_failures: list[dict[str, Any]] = []
    progressive_drift: list[dict[str, Any]] = []

    for index, ground in enumerate(order):
        candidate = audit_by_id[ground]
        identity = manifest_by_id[ground]
        base: dict[str, Any] = {
            "id": ground,
            "plan_index": index,
            "identity": identity,
            "resources": plan["grounds"][ground]["resources"],
            "dimensions_tiles": plan["grounds"][ground]["dimensions_tiles"],
            "candidate": {
                "ground_path": f".runtime-cache/pmdred-eu-remaining-regenerated-v201/grounds/{ground}.rsground",
                "tile_path": f".runtime-cache/pmdred-eu-remaining-regenerated-v201/tiles/{ground}_Base.tile",
                "ground_sha256": candidate["candidate_sha256"]["rsground"],
                "tile_sha256": candidate["candidate_sha256"]["tile"],
                "static_audit": candidate["status"].upper(),
                "legacy_reconciliation": candidate["legacy"],
            },
        }
        if ground not in records:
            base.update(
                runtime="NOT_RUN",
                visual_comparison={"result": "NOT_RUN", "comparative_png_paths": []},
                animation_validation={"result": "NOT_RUN"},
                collision_validation={"result": "NOT_RUN"},
                entry_exit_reentry={"result": "NOT_RUN"},
                cleanup_reload={"result": "NOT_RUN"},
                special_classification={
                    "result": "PENDING_AUTHENTICATED_TECHNICAL_IDENTITY_CHECK",
                    "cinematic": None,
                    "arena": None,
                    "boss": None,
                },
                definitive_destination={"promotion_status": "NOT_PROMOTED"},
                evidence=None,
            )
            grounds.append(base)
            continue

        record_path, record = records[ground]
        if record["runtime"] != "PASS":
            integrity_failures.append({"ground": ground, "error": "runtime record is not PASS"})
        destination = record["definitive_destination"]
        destination_checks = []
        for role, path_key, hash_key in (
            ("ground", "ground", "promoted_ground_sha256"),
            ("tile", "tile", "promoted_tile_sha256"),
        ):
            expected = destination[hash_key]
            actual = rel_sha(destination[path_key])
            check = {
                "role": role,
                "path": destination[path_key],
                "expected_sha256": expected,
                "actual_sha256": actual,
                "result": "PASS" if actual == expected else "FAIL",
            }
            destination_checks.append(check)
            if actual != expected:
                integrity_failures.append({"ground": ground, **check})
        evidence_dir = record_path.parent
        evidence_check = evidence_integrity(evidence_dir)
        if evidence_check["result"] != "PASS":
            integrity_failures.append({"ground": ground, **evidence_check})
        progressive_drift.extend(
            {"ground": ground, **item}
            for item in evidence_check["historical_progressive_drift"]
        )
        declared_zone_entry = destination.get("zone_registry_entry")
        zone_check = {
            "required_by_record": declared_zone_entry is not None,
            "declared": declared_zone_entry == ground if declared_zone_entry is not None else None,
            "current_occurrences": zone.count(ground),
            "current_index": zone.index(ground) if ground in zone else None,
        }
        if zone_check["required_by_record"] and (
            not zone_check["declared"] or zone_check["current_occurrences"] != 1
        ):
            integrity_failures.append(
                {"ground": ground, "error": "required zone registry declaration/occurrence mismatch", **zone_check}
            )
        base.update(
            runtime=record["runtime"],
            validated_at=record.get("validated_at"),
            validation_record=record_path.as_posix(),
            validation_record_sha256=sha256(ROOT / record_path),
            visual_comparison=record["visual_comparison"],
            animation_validation=record["animation_validation"],
            collision_validation=record["collision_validation"],
            entry_exit_reentry=record["entry_exit_reentry"],
            cleanup_reload=record["cleanup_reload"],
            special_classification=classification(record),
            definitive_destination=destination,
            provenance=record["provenance"],
            evidence={
                "directory": evidence_dir.as_posix(),
                "integrity": evidence_check,
            },
            promoted_destination_checks=destination_checks,
            zone_registry=zone_check,
        )
        grounds.append(base)

    validated = [ground for ground in order if ground in records]
    remaining = [ground for ground in order if ground not in records]
    prefix: list[str] = []
    for ground in order:
        if ground not in records:
            break
        prefix.append(ground)
    pilots = [ground for ground in validated if ground not in prefix]
    next_ground = remaining[0] if remaining else None
    assert validated == [item["id"] for item in grounds if item["runtime"] == "PASS"]
    assert len(validated) + len(remaining) == 219

    dependencies = dependency_state(lock)
    runtime_ready = all(item["hash_gate"] == "PASS" for item in dependencies.values())
    current_head = git("rev-parse", "HEAD")
    branch = git("branch", "--show-current")
    return {
        "schema": "new-era.pmdred-eu-exact-pmdo-progress.v1",
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "repository": {"branch": branch, "source_head": current_head},
        "scope": "219 canonical archive-backed Grounds; Ground-only until exhaustive validation is complete",
        "authority": {
            "eu_rom_sha256": manifest["authority"]["rom"]["sha256"],
            "runtime_plan": PLAN_PATH.as_posix(),
            "runtime_plan_sha256": sha256(ROOT / PLAN_PATH),
            "candidate_inventory": AUDIT_PATH.as_posix(),
            "candidate_inventory_sha256": sha256(ROOT / AUDIT_PATH),
            "ground_manifest": MANIFEST_PATH.as_posix(),
            "ground_manifest_sha256": sha256(ROOT / MANIFEST_PATH),
            "runtime_dependency_lock": LOCK_PATH.as_posix(),
            "runtime_dependency_lock_sha256": sha256(ROOT / LOCK_PATH),
        },
        "summary": {
            "canonical_ground_count": len(order),
            "static_pass_count": len(audit_by_id),
            "runtime_pass_and_promoted_count": len(validated),
            "remaining_count": len(remaining),
            "contiguous_plan_prefix_count": len(prefix),
            "out_of_order_pilot_count": len(pilots),
            "next_ground": next_ground,
            "runtime_dependencies_ready": runtime_ready,
            "checkpoint_integrity": "PASS" if not integrity_failures else "FAIL",
        },
        "validated_ids": validated,
        "contiguous_validated_prefix": prefix,
        "validated_out_of_order_pilots": pilots,
        "remaining_ids": remaining,
        "excluded_noncanonical_note": {
            "t01p06": "Reserve-only legacy ID; absent from the canonical 219-entry EU conversion table and never a substitute for any canonical Ground."
        },
        "dependencies": dependencies,
        "integrity": {
            "failures": integrity_failures,
            "historical_progressive_manifest_drift": progressive_drift,
            "drift_policy": "Mutable tools and the append-only zone registry can legitimately differ from older pass manifests. Every archived evidence file and every promoted destination must still match exactly.",
        },
        "known_issues": [
            {
                "status": "RESOLVED",
                "issue": "t01p05 reproduction recipe compared Boolean TERMINAL_SEEN with 72",
                "resolution": "Corrected to 1; transparent recipe-only record at docs/pmdred_eu/pmdo_validation/t01p05_exhaustive_pass/recipe_erratum.json",
            },
            {
                "status": "ACTIVE" if not runtime_ready else "RESOLVED",
                "issue": "Ignored exact-PMDO runtime and derived inputs were absent after workspace recreation",
                "resolution": "Run tools/restore_pmdred_eu_validation_runtime.sh; every restored dependency is hash-gated against runtime_dependencies.lock.json before use.",
            },
            {
                "status": "RESOLVED",
                "issue": "The tracked v2.0.0 candidate audit and authenticated v2.0.1 regeneration reported different t01p07 hashes",
                "resolution": "Both generations are preserved and reconciled in docs/pmdred_eu/remaining_grounds/candidate_regeneration_history.json; only v2.0.1 bytes were exact-engine tested and promoted.",
            },
            {
                "status": "CONSTRAINT",
                "issue": "PMDO_GROUND_VALIDATOR_EVENTS does not relocate the event stream",
                "resolution": "Use /tmp/pmdred_eu_ground_validator.jsonl and terminate the dedicated process group only after terminal and cleanup evidence.",
            },
        ],
        "resume": {
            "restore": "bash tools/restore_pmdred_eu_validation_runtime.sh",
            "verify_checkpoint": "python3 tools/update_pmdred_eu_validation_progress.py --check",
            "next_ground": next_ground,
            "next_recipe_template": "docs/pmdred_eu/pmdo_validation/t01p07_exhaustive_pass/commands.sh",
            "working_recipe": f".runtime-cache/{next_ground}-working-recipe.sh" if next_ground else None,
            "rule": f"Regenerate/restore exact inputs, hash-gate, validate {next_ground} in isolation, compare every planned tick, promote only after all runtime/lifecycle gates pass, then regenerate this checkpoint." if next_ground else "All canonical Grounds are validated; run final integrity and illustrated dungeon restitution reporting.",
        },
        "dungeon_restitution": {
            "manifest": DUNGEON_PATH.as_posix(),
            "manifest_sha256": sha256(ROOT / DUNGEON_PATH),
            "summary": dungeon["summary"],
            "relationship_count": len(dungeon["relationships"]),
            "status": "RETAINED; continue in parallel with each relevant Ground promotion and final illustrated mapping report",
        },
        "grounds": grounds,
    }


def render_markdown(data: dict[str, Any]) -> str:
    summary = data["summary"]
    lines = [
        "# PMD Red EU exact-PMDO Ground validation: resume checkpoint",
        "",
        f"Generated `{data['generated_at']}` from `{data['repository']['source_head']}` on "
        f"`{data['repository']['branch']}`.",
        "",
        "This file is a generated human-readable companion to [`progress.json`](progress.json). "
        "Regenerate both with `python3 tools/update_pmdred_eu_validation_progress.py --write`.",
        "",
        "## Authoritative progress",
        "",
        f"- Canonical archive-backed inventory: **{summary['canonical_ground_count']}** Grounds.",
        f"- Static audit: **{summary['static_pass_count']}/219 PASS** (necessary, not runtime proof).",
        f"- Exact PMDO 0.8.12 runtime PASS + promoted: **{summary['runtime_pass_and_promoted_count']}/219**.",
        f"- Remaining: **{summary['remaining_count']}**.",
        f"- Next canonical Ground: **`{summary['next_ground']}`**.",
        f"- Checkpoint integrity: **{summary['checkpoint_integrity']}**.",
        f"- Ignored runtime dependencies ready: **{str(summary['runtime_dependencies_ready']).lower()}**.",
        "- `t01p06` is reserve-only and outside the canonical conversion table; never validate it in place of a canonical ID.",
        "",
        "## Validated and promoted records",
        "",
        "| Ground | Plan # | Runtime | Visual samples | Mismatched pixels | Animation | Collision | Lifecycle | Classification | Promotion | Evidence |",
        "|---|---:|---|---:|---:|---|---|---|---|---|---|",
    ]
    for item in data["grounds"]:
        if item["runtime"] != "PASS":
            continue
        visual = item["visual_comparison"]
        special = item["special_classification"]
        flags = ", ".join(
            name for name in ("cinematic", "arena", "boss") if special.get(name)
        ) or "ordinary"
        sample_count = visual.get("exact_sample_count", visual.get("sample_count", "?"))
        mismatches = visual.get("mismatched_pixel_count", visual.get("mismatched_pixels", "?"))
        ev = item["evidence"]["directory"]
        lines.append(
            f"| `{item['id']}` | {item['plan_index']} | PASS | {sample_count} | {mismatches} | "
            f"{item['animation_validation']['result']} | {item['collision_validation']['result']} | "
            f"{item['entry_exit_reentry']['result']}/{item['cleanup_reload']['result']} | {flags} | "
            f"{item['definitive_destination']['promotion_status']} | [`{ev}`]({ev.removeprefix('docs/pmdred_eu/pmdo_validation/')}) |"
        )
    lines.extend(
        [
            "",
            "Validated IDs in canonical plan order: `" + "`, `".join(data["validated_ids"]) + "`.",
            "",
            "Contiguous prefix: `" + "`, `".join(data["contiguous_validated_prefix"]) + "`.",
            "",
            "Out-of-order validated pilots: `" + "`, `".join(data["validated_out_of_order_pilots"]) + "`.",
            "",
            "## Remaining canonical IDs (plan order)",
            "",
            "```text",
        ]
    )
    remaining = data["remaining_ids"]
    for start in range(0, len(remaining), 12):
        lines.append(" ".join(remaining[start : start + 12]))
    lines.extend(["```", "", "## Runtime restoration state", ""])
    lines.append("| Dependency | Present | Hash gate | Path |")
    lines.append("|---|---|---|---|")
    for key, dep in data["dependencies"].items():
        lines.append(
            f"| `{key}` | {str(dep['present']).lower()} | {dep['hash_gate']} | `{dep['path']}` |"
        )
    lines.extend(
        [
            "",
            "Restore and gate all ignored dependencies:",
            "",
            "```bash",
            data["resume"]["restore"],
            "python3 tools/update_pmdred_eu_validation_progress.py --check",
            "```",
            "",
            f"Use the latest bounded exact recipe as the audited template for `{data['resume']['next_ground']}` (never substitute reserve-only `t01p06`):",
            "",
            "```bash",
            f"cp {data['resume']['next_recipe_template']} {data['resume']['working_recipe']}",
            f"# Derive {data['resume']['next_ground']}-specific identity, hashes, ticks, collision probes, and counts from the authenticated plan/candidate before running.",
            "```",
            "",
            f"Continuation rule: {data['resume']['rule']}",
            "",
            "Do not promote on load success alone. Preserve reserve/history; require exact PNG comparison, all animation schedules through two local cycles, BMA movement/collision, entry/exit/re-entry, cleanup/reload, terminal evidence, and post-promotion indexing.",
            "",
            "## Known issues and resolutions",
            "",
        ]
    )
    for issue in data["known_issues"]:
        lines.append(f"- **{issue['status']}** — {issue['issue']}: {issue['resolution']}")
    drift = data["integrity"]["historical_progressive_manifest_drift"]
    lines.extend(
        [
            "",
            "## Evidence integrity policy",
            "",
            f"Archived evidence and promoted destination integrity: **{summary['checkpoint_integrity']}**. "
            f"There are **{len(drift)}** recorded older-manifest differences limited to mutable tools, "
            "identity records, or the append-only zone registry. They are retained in `progress.json`; "
            "they are not silently accepted for archived evidence or promoted asset bytes.",
            "",
            "## Dungeon restitution",
            "",
            f"The retained manifest contains **{data['dungeon_restitution']['relationship_count']}** relationships: "
            f"`{data['dungeon_restitution']['manifest']}` (`{data['dungeon_restitution']['manifest_sha256']}`). "
            "Its mappings, midpoint/relay, ending Grounds, tilesets, and equivalent geometry remain required in the final illustrated report.",
            "",
        ]
    )
    return "\n".join(lines)


def normalized_markdown_for_check(text: str) -> str:
    """Ignore only the unavoidable same-commit timestamp/parent-HEAD snapshot."""
    lines = text.splitlines()
    snapshot_lines = [index for index, line in enumerate(lines) if line.startswith("Generated `")]
    if len(snapshot_lines) != 1:
        raise ValueError("resume markdown must contain exactly one generated snapshot line")
    lines[snapshot_lines[0]] = "Generated `<informational-snapshot>`."
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true", help="write tracked checkpoint and runtime copy")
    parser.add_argument("--check", action="store_true", help="verify tracked checkpoint matches generated state")
    parser.add_argument("--json", type=Path, default=DEFAULT_JSON)
    parser.add_argument("--markdown", type=Path, default=DEFAULT_MD)
    args = parser.parse_args()
    if not args.write and not args.check:
        args.write = True

    data = make_checkpoint()
    rendered_json = json.dumps(data, indent=2, ensure_ascii=False) + "\n"
    rendered_md = render_markdown(data)

    # generated_at and repository.source_head are informational snapshots, not
    # semantic inputs.  A checkpoint written immediately before its own commit
    # necessarily records the parent commit; requiring equality afterward would
    # make every otherwise-current checkpoint stale by construction.
    if args.check:
        old = read_json(args.json)
        old.pop("generated_at", None)
        old.get("repository", {}).pop("source_head", None)
        expected = json.loads(rendered_json)
        expected.pop("generated_at", None)
        expected.get("repository", {}).pop("source_head", None)
        if old != expected:
            raise SystemExit("tracked progress.json is stale; run with --write")
        markdown_path = ROOT / args.markdown
        if not markdown_path.is_file() or normalized_markdown_for_check(
            markdown_path.read_text(encoding="utf-8")
        ) != normalized_markdown_for_check(rendered_md):
            raise SystemExit("tracked RESUME.md is stale; run with --write")
        if data["summary"]["checkpoint_integrity"] != "PASS":
            raise SystemExit("checkpoint integrity FAIL; inspect progress.json integrity.failures")
        print(
            f"PMDRED_EU_PROGRESS_PASS validated={data['summary']['runtime_pass_and_promoted_count']} "
            f"remaining={data['summary']['remaining_count']} next={data['summary']['next_ground']}"
        )

    if args.write:
        for relative, content in ((args.json, rendered_json), (args.markdown, rendered_md)):
            path = ROOT / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8")
        runtime = ROOT / RUNTIME_COPY
        runtime.parent.mkdir(parents=True, exist_ok=True)
        runtime.write_text(rendered_json, encoding="utf-8")
        print(
            f"PMDRED_EU_PROGRESS_WRITTEN validated={data['summary']['runtime_pass_and_promoted_count']} "
            f"remaining={data['summary']['remaining_count']} next={data['summary']['next_ground']}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
