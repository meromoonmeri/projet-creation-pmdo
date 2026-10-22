#!/usr/bin/env python3
"""Validate an actual PMDO replay of the native Sinister Woods generator.

The runtime process is executed by the fixture runner; this validator consumes
its real event stream, termination record and log.  It deliberately emits a
non-production verdict: this lot certifies the procedural generator/material
runtime only, not the full Team Dazzling narrative journey.
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
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_SEGMENTS = (0, 1, 3)
FORBIDDEN_DIAGNOSTICS = (
    "Missing Data",
    "Exception Depth",
    "Lua Trace",
    "RUNTIME_FAIL",
    "Could not deserialize",
    "Error importing",
    "KeyNotFoundException",
    "NullReferenceException",
    "Invalid Zone Name",
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fixture", type=Path, default=ROOT / ".runtime-cache/sinister-woods-procedural-fixture")
    parser.add_argument("--events", type=Path)
    parser.add_argument("--output", type=Path, default=ROOT / "docs/pmdred_eu/dungeon_grounds/SINISTER_WOODS_PMDO_NATIVE_GENERATOR_RUNTIME_2026-08-21.json")
    args = parser.parse_args()
    fixture = args.fixture if args.fixture.is_absolute() else ROOT / args.fixture
    events_path = args.events or (Path("/tmp/sinister_woods_procedural_probe.jsonl"))
    if not events_path.is_absolute():
        events_path = ROOT / events_path
    termination_path = fixture / "termination.json"
    runtime_path = fixture / "runtime-game.log"
    manifest_path = fixture / "fixture_manifest.json"
    zone_path = ROOT / "Data/Zone/gloomy_forest.json"
    profile_path = ROOT / "docs/canonical/red/sinister_woods_generator_profile.json"
    for required in (events_path, termination_path, runtime_path, manifest_path, zone_path, profile_path):
        if not required.is_file():
            raise SystemExit(f"missing runtime evidence input: {required}")
    events = [json.loads(line) for line in events_path.read_text(encoding="utf-8").splitlines() if line.strip()]
    termination = read_json(termination_path)
    manifest = read_json(manifest_path)
    runtime_log = runtime_path.read_text(encoding="utf-8", errors="replace")
    diagnostics = {
        token: len(re.findall(re.escape(token), runtime_log))
        for token in FORBIDDEN_DIAGNOSTICS
        if token in runtime_log
    }
    maps = [event for event in events if event.get("event") == "map"]
    enters = [event for event in events if event.get("event") == "enter"]
    checks = {
        "bootstrap_present": bool(events and events[0].get("event") == "bootstrap"),
        "entered_expected_segments": [event.get("segment") for event in enters] == list(EXPECTED_SEGMENTS),
        "mapped_expected_segments": [event.get("segment") for event in maps] == list(EXPECTED_SEGMENTS),
        "all_maps_have_canonical_music": all(event.get("music") == "Sinister Woods.ogg" for event in maps),
        "all_maps_have_free_and_blocked_collision": all(event.get("free_collision_probe") and event.get("blocked_collision_probe") for event in maps),
        "deep_shadow_on_deep_segment": maps[-1].get("deep_shadow_setter") is True if maps else False,
        "dusk_on_deep_segment": maps[-1].get("dusk") is True if maps else False,
        "normal_exit_code_zero": termination.get("termination", {}).get("returncode") == 0 and termination.get("termination", {}).get("kind") == "NORMAL_EXIT",
        "engine_terminal_event": bool(termination.get("terminal_seen")) and bool(events and events[-1].get("event") == "end"),
        "no_forbidden_runtime_diagnostics": not diagnostics,
        "fixture_zone_matches_production_zone": manifest.get("zone_sha256") == sha256(zone_path),
        "fixture_material_is_unique_namespace": manifest.get("material_sheet") == "SinisterWoodsB41" and "sinister_woods_b41_floor.json" in json.dumps(manifest),
    }
    result = "PMDO_NATIVE_GENERATOR_RUNTIME_PASS_NON_PRODUCTION" if all(checks.values()) else "PMDO_NATIVE_GENERATOR_RUNTIME_BLOCKED"
    evidence = {
        "schema": "new-era.pmdred-eu.sinister-woods-native-generator-runtime.v1",
        "result": result,
        "scope": "actual PMDO 0.8.12 fixture replay of native procedural generation/material for segments 0, 1 and 3",
        "not_certified": [
            "full Team Dazzling narrative chain",
            "boss/relay/victory/defeat journey",
            "full chapter 6 to ending traversal",
            "byte-identical PMD Red RNG stream",
        ],
        "provenance": {
            "pret_commit": "bf0092d0e34fd8e49b859a0b5f96f00740faa42d",
            "rom_sha256": "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd",
            "zone": str(zone_path.relative_to(ROOT)),
            "zone_sha256": sha256(zone_path),
            "generator_profile": str(profile_path.relative_to(ROOT)),
            "generator_profile_sha256": sha256(profile_path),
            "fixture_manifest_sha256": sha256(manifest_path),
            "events_sha256": sha256(events_path),
            "runtime_log_sha256": sha256(runtime_path),
            "termination_sha256": sha256(termination_path),
        },
        "runtime": {
            "pmdo_termination": termination.get("termination"),
            "terminal_seen": termination.get("terminal_seen"),
            "event_count": len(events),
            "maps": maps,
            "diagnostics": diagnostics,
        },
        "checks": checks,
        "production_route_promoted": False,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"result": result, "checks": checks, "output": str(args.output.relative_to(ROOT))}, ensure_ascii=False, indent=2))
    return 0 if result.endswith("PASS_NON_PRODUCTION") else 1


if __name__ == "__main__":
    raise SystemExit(main())
