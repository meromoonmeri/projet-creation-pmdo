#!/usr/bin/env python3
"""Validate the real PMDO chapter-6 Sinister Woods chain staging replay.

This evidence covers the engine-loaded Ground/map transition chain and its
native procedural segments.  The fixture deliberately seeds the already-known
chapter-6 flags so it can exercise every branch without pretending that an
input replay is the full player campaign.  The verdict therefore remains
non-production until the narrative scenes and battle outcomes are certified
separately.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_SEGMENTS = [0, 1, 2, 3, 4]
EXPECTED_GROUNDS = [
    "gloomy_forest_entrance",
    "gloomy_forest_midpoint",
    "gloomy_forest_miniboss",
    "gloomy_forest_miniboss",
    "sinister_woods_clearing",
]
FORBIDDEN = (
    "Missing Data",
    "Exception Depth",
    "Lua Trace",
    "RUNTIME_FAIL",
    "Could not deserialize",
    "Error importing",
    "KeyNotFoundException",
    "NullReferenceException",
    "Invalid Zone Name",
    "ScriptGround.Hide",
)


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fixture", type=Path, default=ROOT / ".runtime-cache/sinister-woods-chain-fixture")
    parser.add_argument("--events", type=Path, default=Path("/tmp/sinister_woods_chain_probe.jsonl"))
    parser.add_argument("--output", type=Path, default=ROOT / "docs/pmdred_eu/dungeon_grounds/SINISTER_WOODS_CHAIN_RUNTIME_2026-08-21.json")
    args = parser.parse_args()
    fixture = args.fixture if args.fixture.is_absolute() else ROOT / args.fixture
    events_path = args.events if args.events.is_absolute() else ROOT / args.events
    output = args.output if args.output.is_absolute() else ROOT / args.output
    runtime_path = fixture / "runtime.log"
    termination_path = fixture / "termination.json"
    manifest_path = fixture / "fixture_manifest.json"
    map_path = ROOT / "Data/Map/gloomy_forest_boss.rsmap"
    for path in (events_path, runtime_path, termination_path, manifest_path, map_path):
        if not path.is_file():
            raise SystemExit(f"missing chain evidence input: {path}")
    events = [json.loads(line) for line in events_path.read_text(encoding="utf-8").splitlines() if line.strip()]
    termination = read_json(termination_path)
    manifest = read_json(manifest_path)
    log = runtime_path.read_text(encoding="utf-8", errors="replace")
    diagnostics = {token: len(re.findall(re.escape(token), log)) for token in FORBIDDEN if token in log}
    requested_ground_ids = [event["id"] for event in events if event.get("event") == "enter_ground"]
    maps = [event for event in events if event.get("event") == "map"]
    segments = [event.get("segment") for event in maps]
    boss_map = read_json(map_path)["Object"]
    effect_types = [event["Value"].get("$type") for event in boss_map["MapEffect"]["OnMapStarts"]]
    checks = {
        "input_replay_installed": any(event.get("event") == "input_replay" for event in events),
        "bootstrap_chapter_6": any(event.get("event") == "bootstrap" and event.get("chapter") == 6 for event in events),
        "ground_request_order": requested_ground_ids == EXPECTED_GROUNDS,
        "segment_order": segments == EXPECTED_SEGMENTS,
        "procedural_maps_use_sinister_music": all(event.get("music") == "Sinister Woods.ogg" for event in maps if event.get("segment") in (0, 1, 3)),
        "all_maps_have_collision_probes": all(event.get("free_collision") and event.get("blocked_collision") for event in maps if event.get("segment") in (0, 1, 2, 3)),
        "mini_boss_map_loaded": any(event.get("segment") == 2 and event.get("width") == 19 and event.get("height") == 19 for event in maps),
        "final_boss_map_loaded": any(event.get("segment") == 4 and event.get("music") == "Boss Battle!.ogg" for event in maps),
        "boss_map_type_is_native": boss_map.get("$type") == "RogueEssence.Dungeon.Map, RogueEssence",
        "boss_team_type_is_native": boss_map.get("MapTeams", [{}])[0].get("$type") == "RogueEssence.Dungeon.MonsterTeam, RogueEssence",
        "boss_tactic_is_serialized_object": isinstance(boss_map.get("MapTeams", [{}])[0].get("Players", [{}])[0].get("Tactic"), dict),
        "boss_effect_types_are_explicit": all(effect_types),
        "normal_engine_exit": termination.get("termination", {}).get("kind") == "NORMAL_EXIT" and termination.get("termination", {}).get("returncode") == 0,
        "terminal_event_seen": termination.get("terminal_seen") is True and events[-1].get("event") == "end",
        "no_forbidden_diagnostics": not diagnostics,
        "fixture_is_non_production": manifest.get("production_assets_modified") is False,
    }
    result = "PMDO_SINISTER_WOODS_CHAIN_RUNTIME_PASS_NON_PRODUCTION" if all(checks.values()) else "PMDO_SINISTER_WOODS_CHAIN_RUNTIME_BLOCKED"
    evidence = {
        "schema": "new-era.pmdred-eu.sinister-woods-chain-runtime.v1",
        "result": result,
        "scope": "real PMDO fixture: chapter-6 Ground/map order and native dungeon segment loading",
        "not_certified": [
            "full player-controlled chapter-6 narrative",
            "Team Dazzling cinematic certification",
            "battle outcome certification",
            "New Game to ending traversal",
        ],
        "provenance": {
            "pret_commit": "bf0092d0e34fd8e49b859a0b5f96f00740faa42d",
            "fixture_manifest_sha256": sha(manifest_path),
            "events_sha256": sha(events_path),
            "runtime_log_sha256": sha(runtime_path),
            "termination_sha256": sha(termination_path),
            "boss_map_sha256": sha(map_path),
        },
        "runtime": {
            "event_count": len(events),
            "grounds": requested_ground_ids,
            "segments": segments,
            "maps": maps,
            "diagnostics": diagnostics,
        },
        "checks": checks,
        "production_route_certified": False,
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"result": result, "checks": checks, "output": str(output.relative_to(ROOT))}, ensure_ascii=False, indent=2))
    return 0 if result.endswith("PASS_NON_PRODUCTION") else 1


if __name__ == "__main__":
    raise SystemExit(main())
