#!/usr/bin/env python3
"""Validate/archive real FrameInput evidence for PMD Red EU quiz menus."""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from collections import Counter
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_FIXTURE = ROOT / ".runtime-cache/pmdred-eu-personality-quiz-input-fixture"
DEFAULT_OUTPUT = ROOT / "docs/pmdred_eu/narrative_migration/personality_quiz/runtime_input"
EXPECTED_QUESTIONS = [
    "hardy_1", "docile_1", "brave_1", "jolly_1",
    "impish_1", "naive_1", "timid_1", "hasty_1",
]


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


def one(events: list[dict[str, Any]], name: str) -> dict[str, Any]:
    rows = [row for row in events if row["event"] == name]
    require(len(rows) == 1, f"expected one {name}, got {len(rows)}")
    return rows[0]


def validate(fixture: Path) -> dict[str, Any]:
    paths = {
        name: fixture / name
        for name in ("events.jsonl", "termination.json", "runtime.log", "index.log", "fixture_manifest.json")
    }
    for path in paths.values():
        require(path.is_file(), f"runtime evidence missing: {path}")
    events = [json.loads(line) for line in paths["events.jsonl"].read_text().splitlines()]
    require(len(events) == 212, f"expected 212 events, got {len(events)}")
    require([row["sequence"] for row in events] == list(range(1, 213)), "event sequence is not contiguous")
    frames = [row["frame"] for row in events]
    require(frames == sorted(frames), "runtime frames moved backwards")
    require(events[-1]["event"] == "end", "terminal event missing")
    require(not any(row["event"] == "RUNTIME_FAIL" for row in events), "runtime emitted RUNTIME_FAIL")
    counts = Counter(row["event"] for row in events)
    expected_counts = {
        "PHYSICAL_INPUT_QUEUED": 74,
        "QUIZ_TEXT_BEGIN": 27,
        "QUIZ_TEXT_END": 27,
        "QUIZ_CONTROL": 20,
        "QUIZ_CHOICE_BEGIN": 10,
        "QUIZ_CHOICE_END": 10,
        "QUIZ_RNG": 9,
        "QUIZ_ANSWER": 8,
        "QUIZ_PRELUDE_PAGE": 7,
    }
    for event, expected in expected_counts.items():
        require(counts[event] == expected, f"{event} count differs")

    queued = [row for row in events if row["event"] == "PHYSICAL_INPUT_QUEUED"]
    require(all(row["input_kind"] == "confirm" for row in queued), "non-confirm input leaked into first-option gate")
    require([row["replay_count"] for row in queued] == sorted(row["replay_count"] for row in queued), "replay queue shrank")
    require(all(row["replay_count"] > row["replay_index"] for row in queued), "queued input was already behind replay cursor")

    begins = [row for row in events if row["event"] == "QUIZ_TEXT_BEGIN"]
    ends = [row for row in events if row["event"] == "QUIZ_TEXT_END"]
    require([row["context"] for row in begins] == [row["context"] for row in ends], "text begin/end contexts differ")
    require(all(end["frame"] > begin["frame"] for begin, end in zip(begins, ends, strict=True)), "physical text input consumed no frames")
    choice_ends = [row for row in events if row["event"] == "QUIZ_CHOICE_END"]
    expected_contexts = [*(f"question:{value}" for value in EXPECTED_QUESTIONS), "gender", "recommendation_confirmation"]
    require([row["context"] for row in choice_ends] == expected_contexts, "physical choice context order differs")
    require(all(row["result"] == 1 for row in choice_ends), "first-option physical selection differs")
    answers = [row for row in events if row["event"] == "QUIZ_ANSWER"]
    require([(row["question"], row["answer"]) for row in answers] == [(value, 1) for value in EXPECTED_QUESTIONS], "physical answer order differs")
    require(one(events, "QUIZ_GENDER")["choice"] == 1, "physical gender choice differs")
    personality = one(events, "QUIZ_PERSONALITY")
    require(personality["personality"] == "naive" and personality["tie_start"] == 0, "physical personality result differs")
    recommendation = one(events, "QUIZ_RECOMMENDATION")
    require(recommendation["species"] == "totodile" and recommendation["historical_gender_column"] == 1, "physical recommendation differs")
    complete = one(events, "PHYSICAL_FLOW_RESULT_ASSERTED")
    require(
        complete["personality"] == "naive"
        and complete["choice"] == 1
        and complete["recommendation"] == "totodile",
        "physical final result differs",
    )
    replay = one(events, "REPLAY_STATE_ASSERTED")
    require(replay["replay_index"] > 60 and replay["replay_count"] > replay["replay_index"], "FrameInput replay was not consumed safely")
    require(one(events, "QUIZ_PALETTE_FADE_IN_END")["source_opcode"] == "CMD_BYTE_22", "fade-in opcode differs")
    require(one(events, "QUIZ_PALETTE_FADE_OUT_BEGIN")["source_opcode"] == "CMD_BYTE_23", "fade-out opcode differs")
    require(one(events, "RUNTIME_RESULT")["result"] == "PASS", "runtime result did not pass")

    termination = read_json(paths["termination.json"])
    term = termination["termination"]
    require(termination["terminal_seen"] and termination["graceful_exit_observed"], "normal PMDO unload not observed")
    require(not termination["requested_signal_sent"], "watchdog signal was sent")
    require(not termination["residual_processes_after_cleanup"], "residual PMDO process remains")
    require(term["result"] == "PASS" and term["kind"] == "NORMAL_EXIT", "termination did not pass")
    require(term["normal_exit"] and term["returncode"] == 0, "PMDO did not exit normally with zero")
    runtime_log = paths["runtime.log"].read_text(errors="replace")
    require(not any(value in runtime_log for value in ("RUNTIME_FAIL", "Exception Depth", "Could not find value", "Lua Trace")), "runtime log contains an engine/Lua failure")
    index_log = paths["index.log"].read_text(errors="replace")
    require("Could not deserialize" not in index_log and "Error importing" not in index_log, "fixture indexing failed")
    manifest = read_json(paths["fixture_manifest.json"])
    require(manifest["schema"] == "new-era.pmdred-eu-personality-quiz-input-runtime-fixture.v1", "fixture schema differs")
    require("ActiveDebugReplay" in manifest["input_mode"], "physical input mechanism not declared")
    require(not manifest["source_index_symlinks"], "fixture exposes writable source indexes")
    for relative, expected in manifest["tracked_hashes"].items():
        require(sha256_file(ROOT / relative) == expected, f"tracked fixture input drift: {relative}")

    return {
        "schema": "new-era.pmdred-eu-personality-quiz-input-runtime-validation.v1",
        "result": "PHYSICAL_CONFIRM_INPUT_PASS_LIVE_CREATION_PARTIAL",
        "full_quiz_integrated": False,
        "production_personality_test_routed": True,
        "input": {
            "mechanism": "RogueEssence.DiagManager.ActiveDebugReplay",
            "frame_input": "neutral and Microsoft.Xna.Framework.Input.Keys.Enter",
            "queued_confirm_pulses": counts["PHYSICAL_INPUT_QUEUED"],
            "consumed_replay_index": replay["replay_index"],
            "final_replay_count": replay["replay_count"],
            "real_begin_choice_menu_count": counts["QUIZ_CHOICE_BEGIN"],
            "real_choice_result_count": counts["QUIZ_CHOICE_END"],
        },
        "timeline": {
            "event_count": len(events),
            "last_runtime_frame": events[-1]["frame"],
            "text_page_count": counts["QUIZ_TEXT_BEGIN"],
            "question_answer_count": counts["QUIZ_ANSWER"],
            "choice_contexts": expected_contexts,
        },
        "validated_scope": [
            "real PMDO FrameInput pulses, not injected choice return values",
            "all seven introduction pages advanced physically",
            "eight real BeginChoiceMenu question confirmations",
            "real gender and recommendation confirmation menus",
            "description, reveal, partner prompt and end text advanced physically",
            "canonical BGM and 30-frame palette fade boundaries",
            "normal native PMDO unload",
        ],
        "not_yet_validated": [
            "directional cursor navigation and non-first answer options",
            "BraveQuest2B and restart under physical input (covered by deterministic flow gate only)",
            "live complete New Era hero selector and partner selector",
            "name-entry keyboard input, save serialization and relic_forest transition",
            "s01 harness handoff",
        ],
        "pmdo": {"version": "0.8.12", "termination": term},
        "authority": {
            "flow_sha256": sha256_file(ROOT / "Data/Script/halcyon/ground/personality_test/pmdred_quiz_flow.lua"),
            "production_init_sha256": sha256_file(ROOT / "Data/Script/halcyon/ground/personality_test/init.lua"),
            "ground_sha256": sha256_file(ROOT / "Data/Ground/personality_test.rsground"),
        },
        "promotion": "DIRECTIONAL_AND_LIVE_CHARACTER_CREATION_INPUT_GATES_REQUIRED_BEFORE_FULL_PASS",
    }


def archive(fixture: Path, output: Path, report: dict[str, Any]) -> None:
    require(not output.exists(), f"refusing to overwrite runtime evidence: {output}")
    output.mkdir(parents=True)
    for name in ("events.jsonl", "termination.json", "runtime.log", "index.log", "fixture_manifest.json"):
        shutil.copy2(fixture / name, output / name)
    (output / "validation.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    evidence = sorted(path for path in output.rglob("*") if path.is_file() and path.name != "evidence_hashes.sha256")
    with (output / "evidence_hashes.sha256").open("w", newline="\n") as stream:
        for path in evidence:
            stream.write(f"{sha256_file(path)}  {path.relative_to(output).as_posix()}\n")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fixture", type=Path, default=DEFAULT_FIXTURE)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--check-only", action="store_true")
    args = parser.parse_args()
    fixture = args.fixture if args.fixture.is_absolute() else ROOT / args.fixture
    output = args.output if args.output.is_absolute() else ROOT / args.output
    report = validate(fixture)
    if not args.check_only:
        archive(fixture, output, report)
    print("PMDRED_EU_PERSONALITY_QUIZ_PHYSICAL_INPUT_PASS", json.dumps({
        "events": report["timeline"]["event_count"],
        "choices": report["input"]["real_choice_result_count"],
        "pulses": report["input"]["queued_confirm_pulses"],
        "result": report["result"],
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
