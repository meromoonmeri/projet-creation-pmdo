#!/usr/bin/env python3
"""Validate the exact opt-in full s01 PMD Red EU runtime replay."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
FORBIDDEN = ("Missing Data", "Exception Depth", "Lua Trace", "RUNTIME_FAIL", "Could not deserialize", "Error importing")


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def validate(fixture: Path, output: Path) -> dict[str, Any]:
    events_path = fixture / "events.jsonl"
    term_path = fixture / "termination.json"
    runtime_path = fixture / "runtime.log"
    index_path = fixture / "index.log"
    for path in (events_path, term_path, runtime_path, index_path):
        require(path.is_file(), f"missing runtime evidence: {path}")
    events = [json.loads(line) for line in events_path.read_text().splitlines()]
    require(len(events) == 175, f"expected 175 full s01 events, got {len(events)}")
    require([event["sequence"] for event in events] == list(range(1, 176)), "event sequence is not contiguous")
    require([event["frame"] for event in events] == sorted(event["frame"] for event in events), "frames are not monotonic")
    names = [event["event"] for event in events]
    for required in (
        "RAW_OPCODE_0X22_BEGIN", "RAW_OPCODE_0X22_END", "QUIZ_COMPLETE",
        "QUIZ_BGM_FADEOUT", "QUIZ_PALETTE_FADE_OUT_BEGIN",
        "QUIZ_PALETTE_FADE_OUT_END", "SCENE_FULL_COMPLETED", "FULL_RESULT", "end",
    ):
        require(required in names, f"missing full s01 event: {required}")
    require("DEPENDENCY_BLOCKED" not in names, "full continuation still emitted dependency block")
    order = [
        "RAW_OPCODE_0X22_BEGIN", "RAW_OPCODE_0X22_END", "QUIZ_QUESTIONS_SELECTED",
        "QUIZ_COMPLETE", "QUIZ_BGM_FADEOUT", "QUIZ_PALETTE_FADE_OUT_BEGIN",
        "QUIZ_PALETTE_FADE_OUT_END", "SCENE_FULL_COMPLETED", "FULL_RESULT", "end",
    ]
    positions = [names.index(value) for value in order]
    require(positions == sorted(positions), "full source continuation order drifted")
    fade_in = next(event for event in events if event["event"] == "RAW_OPCODE_0X22_BEGIN")
    fade_out = next(event for event in events if event["event"] == "QUIZ_PALETTE_FADE_OUT_BEGIN")
    require(fade_in["source_opcode"] == "CMD_BYTE_22" and fade_in["frames"] == 30, "0x22 timing drift")
    require(fade_out["source_opcode"] == "CMD_BYTE_23" and fade_out["frames"] == 30, "0x23 timing drift")
    full = next(event for event in events if event["event"] == "FULL_RESULT")
    require(full["complete"] is True, "full result is not complete")
    quiz_complete = next(event for event in events if event["event"] == "QUIZ_COMPLETE")
    require(full["personality"] == quiz_complete["personality"], "result personality drift")
    require(full["recommendation"] == quiz_complete["recommendation"], "result recommendation drift")
    require(sum(event["event"] == "QUIZ_ANSWER" for event in events) == 9, "question answer count drift")
    require(sum(event["event"] == "QUIZ_CHOICE_BEGIN" for event in events) == 11, "choice count drift")
    require(sum(event["event"] == "QUIZ_TEXT_BEGIN" for event in events) >= 16, "full French text timeline is unexpectedly short")

    termination = json.loads(term_path.read_text())
    term = termination["termination"]
    require(termination["terminal_seen"] and termination["graceful_exit_observed"], "native terminal event/exit missing")
    require(not termination["requested_signal_sent"], "watchdog was used")
    require(not termination["residual_processes_before_cleanup"] and not termination["residual_processes_after_cleanup"], "residual PMDO process")
    require(term["result"] == "PASS" and term["kind"] == "NORMAL_EXIT" and term["returncode"] == 0, "PMDO termination failed")
    runtime_log = runtime_path.read_text(errors="replace")
    index_log = index_path.read_text(errors="replace")
    require(not any(value in runtime_log for value in FORBIDDEN), "forbidden runtime diagnostic")
    require(not any(value in index_log for value in FORBIDDEN), "forbidden index diagnostic")

    result = {
        "schema": "new-era.pmdred-eu.s01-full-runtime-validation.v1",
        "scene": "s01",
        "status": "FULL_SOURCE_SEQUENCE_RUNTIME_VALIDATED_DORMANT",
        "production_routed": False,
        "source_command_boundary": "BGM_STOP through CMD_BYTE_22 -> SPECIAL_TEXT_PERSONALITY_QUIZ -> BGM_FADEOUT -> CMD_BYTE_23 -> RET",
        "event_count": len(events),
        "frame_end": events[-1]["frame"],
        "quiz_answer_count": sum(event["event"] == "QUIZ_ANSWER" for event in events),
        "quiz_choice_count": sum(event["event"] == "QUIZ_CHOICE_BEGIN" for event in events),
        "quiz_text_page_count": sum(event["event"] == "QUIZ_TEXT_BEGIN" for event in events),
        "personality": full["personality"],
        "recommendation": full["recommendation"],
        "termination": term,
        "forbidden_diagnostics": [],
        "fixture_evidence": {
            "events_sha256": sha(events_path),
            "termination_sha256": sha(term_path),
            "runtime_log_sha256": sha(runtime_path),
            "index_log_sha256": sha(index_path),
        },
        "production_policy": "The normal New Era New Game remains untouched; this exact full replay is opt-in until the post-start narrative gate is explicitly integrated.",
        "remaining_scope": ["POST_START_NEW_ERA_GATE", "FULL_PMD_RED_CAMPAIGN"],
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fixture", type=Path, default=Path(".runtime-cache/pmdred-eu-s01-full-fixture"))
    parser.add_argument("--output", type=Path, default=Path("docs/pmdred_eu/narrative_migration/scenes/s01/full_runtime/validation.json"))
    args = parser.parse_args()
    fixture = args.fixture if args.fixture.is_absolute() else ROOT / args.fixture
    output = args.output if args.output.is_absolute() else ROOT / args.output
    result = validate(fixture, output)
    print(json.dumps({"status": result["status"], "events": result["event_count"], "frame_end": result["frame_end"], "personality": result["personality"], "recommendation": result["recommendation"]}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
