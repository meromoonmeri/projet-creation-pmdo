#!/usr/bin/env python3
"""Validate exact PMDO 0.8.12 evidence for dormant primitive adapters."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any

PMDO_SHA256 = "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327"
PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"
ROGUE_COMMIT = "4961b2271bb0cace74f40f6a85e799e8e4848ace"
DIRECTIONS = [
    ("DIRECTION_SOUTH", "Down: 0"),
    ("DIRECTION_SOUTHEAST", "DownRight: 7"),
    ("DIRECTION_EAST", "Right: 6"),
    ("DIRECTION_NORTHEAST", "UpRight: 5"),
    ("DIRECTION_NORTH", "Up: 4"),
    ("DIRECTION_NORTHWEST", "UpLeft: 3"),
    ("DIRECTION_WEST", "Left: 2"),
    ("DIRECTION_SOUTHWEST", "DownLeft: 1"),
]
ROTATIONS = [
    ("DIR_TRANS_SPINRIGHT1", "DIRECTION_NORTH"),
    ("DIR_TRANS_SPINLEFT1", "DIRECTION_EAST"),
    ("DIR_TRANS_10", "DIRECTION_WEST"),
    ("DIR_TRANS_11", "DIRECTION_NORTHEAST"),
]
RELATIVE_ROTATIONS = [
    (1, "DIR_TRANS_SPINRIGHT2"),
    (2, "DIR_TRANS_SPINLEFT2"),
    (2, "DIR_TRANS_FLIP"),
]


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_events(path: Path) -> list[dict[str, Any]]:
    rows = []
    for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        try:
            rows.append(json.loads(line))
        except json.JSONDecodeError as exc:
            raise ValueError(f"invalid event JSON at line {number}") from exc
    return rows


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", type=Path, required=True)
    parser.add_argument("--index-log", type=Path, required=True)
    parser.add_argument("--runtime-log", type=Path, required=True)
    parser.add_argument("--fixture-manifest", type=Path, required=True)
    parser.add_argument("--module", type=Path, required=True)
    parser.add_argument("--pmdo", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    required = [args.events, args.index_log, args.runtime_log, args.fixture_manifest, args.module, args.pmdo]
    for path in required:
        if not path.is_file():
            raise FileNotFoundError(path)
    if digest(args.pmdo) != PMDO_SHA256:
        raise ValueError("runtime is not the locked exact PMDO 0.8.12 executable")

    manifest = json.loads(args.fixture_manifest.read_text(encoding="utf-8"))
    if manifest["production_module_sha256"] != digest(args.module):
        raise ValueError("fixture did not load the published production adapter module")
    if manifest["certified_ground_revalidated"] or manifest["base_fixture_candidate_loaded"]:
        raise ValueError("primitive adapter fixture must not revalidate a certified Ground")
    if manifest["executed_ground_kind"] != "IGNORED_SYNTHETIC_FIXTURE_ONLY":
        raise ValueError("primitive adapter fixture did not use its isolated sink")

    events = read_events(args.events)
    kinds = [row.get("event") for row in events]
    expected_kinds = [
        "begin", "module_loaded", "wait_pass", "bgm_fadeout_pass",
        *("direction_pass" for _ in DIRECTIONS),
        *("rotation_pass" for _ in ROTATIONS),
        *("relative_rotation_pass" for _ in RELATIVE_ROTATIONS),
        "fail_closed_pass", "end",
    ]
    if kinds != expected_kinds:
        raise ValueError(f"unexpected exact-runtime event sequence: {kinds}")
    if events[0] != {"event": "begin", "runtime": "PMDO 0.8.12", "ground_loaded": "fixture_sink_only"}:
        raise ValueError("runtime did not begin in the isolated fixture sink")
    if events[1].get("pret_commit") != PRET_COMMIT or events[1].get("rogue_essence_commit") != ROGUE_COMMIT:
        raise ValueError("loaded adapter authority mismatch")
    wait = events[2]
    if wait.get("frames") != 3 or wait.get("service_update_delta", -1) < 0 or wait.get("tick_delta", -1) < 0:
        raise ValueError("WAIT adapter did not execute and resume in the managed PMDO coroutine")
    if events[3] != {"event": "bgm_fadeout_pass", "frames": 5}:
        raise ValueError("BGM_FADEOUT adapter failed")
    for event, (source, pmdo) in zip(events[4:12], DIRECTIONS):
        if event != {"event": "direction_pass", "source": source, "pmdo": pmdo}:
            raise ValueError(f"direction adapter mismatch: {event}")
    for event, (transition, target) in zip(events[12:16], ROTATIONS):
        if event != {"event": "rotation_pass", "transition": transition, "target": target}:
            raise ValueError(f"rotation adapter mismatch: {event}")
    for event, (turn_step, target_transform) in zip(events[16:19], RELATIVE_ROTATIONS):
        if event != {
            "event": "relative_rotation_pass", "turn_step": turn_step, "target_transform": target_transform,
        }:
            raise ValueError(f"relative rotation adapter mismatch: {event}")
    fail_closed = events[19]
    if fail_closed != {
        "event": "fail_closed_pass",
        "numeric_direction": True,
        "unknown_opcode": True,
        "missing_actor": True,
        "unsupported_rotation": True,
        "unsupported_relative_rotation": True,
    }:
        raise ValueError("adapter fail-closed checks did not all pass")
    end = events[20]
    if end != {
        "event": "end", "verdict": "PASS", "ground_loaded": "fixture_sink_only",
        "production_route_written": False,
    }:
        raise ValueError("exact runtime adapter validation did not terminate PASS")

    index_text = args.index_log.read_text(encoding="utf-8", errors="replace")
    runtime_text = args.runtime_log.read_text(encoding="utf-8", errors="replace")
    if "Script variables default values loaded!" not in index_text:
        raise ValueError("PMDO index gate did not load quest scripts")
    if '[PMDRED_PRIMITIVE_ADAPTER] {"event":"end","verdict":"PASS"' not in runtime_text:
        raise ValueError("runtime log does not contain the terminal PASS event")

    evidence = {
        path.name: {"bytes": path.stat().st_size, "sha256": digest(path)}
        for path in (args.events, args.index_log, args.runtime_log, args.fixture_manifest)
    }
    result = {
        "schema": "new-era.pmdred-eu-primitive-adapter-runtime-validation.v1",
        "result": "PASS_EXACT_PMDO_0_8_12",
        "meaning": "five dormant primitive adapters loaded and executed; no canonical scene or journey is runtime-ready",
        "runtime": {
            "name": "PMDO",
            "version": "0.8.12",
            "executable_sha256": PMDO_SHA256,
            "rogue_essence_commit": ROGUE_COMMIT,
        },
        "authority": {"pret_commit": PRET_COMMIT},
        "validated_primitives": {
            "WAIT": {"frames": 3, "managed_coroutine_resumed": True},
            "BGM_FADEOUT": {"frames": 5},
            "SET_DIR_WAIT": {"direction_symbol_count": 8, "preserve_direction_minus_one": True},
            "ROTATE_TO": {"transition_policy_count": 4, "step_frames": 2},
            "CMD_UNK_92": {"corpus_form_count": 3, "step_frames": 2},
        },
        "fail_closed": {
            "numeric_direction_rejected": True,
            "unknown_opcode_rejected": True,
            "missing_actor_rejected": True,
            "unsupported_rotation_rejected": True,
            "unsupported_relative_rotation_rejected": True,
        },
        "scope": {
            "executed_ground": "pmdred_eu_validation_sink",
            "executed_ground_kind": "IGNORED_SYNTHETIC_FIXTURE_ONLY",
            "certified_ground_revalidated": False,
            "production_ground_modified": False,
            "production_zone_modified": False,
            "production_route_written": False,
            "runtime_ready_asset_count": 0,
        },
        "evidence": evidence,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"result": result["result"], **result["scope"]}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
