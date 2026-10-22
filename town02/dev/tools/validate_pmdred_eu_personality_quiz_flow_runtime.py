#!/usr/bin/env python3
"""Validate/archive PMDO evidence for the production-routed quiz flow."""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from collections import Counter
from pathlib import Path
from typing import Any

from PIL import Image, ImageChops

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_FIXTURE = ROOT / ".runtime-cache/pmdred-eu-personality-quiz-flow-fixture"
DEFAULT_OUTPUT = ROOT / "docs/pmdred_eu/narrative_migration/personality_quiz/runtime_flow"
EXPECTED_RNG = [
    ("question", 0), ("question", 4), ("question", 9), ("question", 12),
    ("question", 16), ("question", 20), ("question", 24), ("question", 28),
    ("tie", 0),
    ("question", 3), ("question", 7), ("question", 11), ("question", 15),
    ("question", 19), ("question", 23), ("question", 27), ("question", 31),
    ("tie", 4),
]
EXPECTED_ANSWERS = [
    ("hardy_1", 1), ("docile_1", 1), ("brave_2a", 1), ("brave_2b", 2),
    ("jolly_1", 1), ("impish_1", 1), ("naive_1", 1), ("timid_1", 1),
    ("hasty_1", 1),
    ("hardy_4", 1), ("docile_4", 1), ("brave_4", 1), ("jolly_4", 1),
    ("impish_4", 1), ("naive_4", 1), ("timid_4", 1), ("hasty_4", 1),
]
EXPECTED_COUNTS = {
    "QUIZ_TEXT_BEGIN": 46,
    "QUIZ_TEXT_END": 46,
    "QUIZ_CONTROL": 39,
    "QUIZ_CHOICE_BEGIN": 21,
    "QUIZ_CHOICE_END": 21,
    "QUIZ_RNG": 18,
    "QUIZ_ANSWER": 17,
    "QUIZ_PRELUDE_PAGE": 7,
    "QUIZ_QUESTIONS_SELECTED": 2,
    "QUIZ_GENDER": 2,
    "QUIZ_PERSONALITY": 2,
    "QUIZ_RECOMMENDATION": 2,
    "SCREENSHOT_REQUESTED": 2,
    "SCREENSHOT_COMPLETED": 2,
    "QUIZ_BRANCH": 1,
    "QUIZ_RESTART": 1,
    "QUIZ_COMPLETE": 1,
}


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


def only(events: list[dict[str, Any]], event: str) -> dict[str, Any]:
    rows = [row for row in events if row["event"] == event]
    require(len(rows) == 1, f"expected one {event}, got {len(rows)}")
    return rows[0]


def validate(fixture: Path) -> tuple[dict[str, Any], list[Path]]:
    paths = {
        name: fixture / name
        for name in ("events.jsonl", "termination.json", "runtime.log", "index.log", "fixture_manifest.json")
    }
    for path in paths.values():
        require(path.is_file(), f"runtime evidence missing: {path}")
    events = [json.loads(line) for line in paths["events.jsonl"].read_text().splitlines()]
    require(len(events) == 246, f"expected 246 runtime events, got {len(events)}")
    require([row["sequence"] for row in events] == list(range(1, 247)), "event sequence is not contiguous")
    frames = [row["frame"] for row in events]
    require(frames == sorted(frames), "runtime frames moved backwards")
    require(events[-1]["event"] == "end", "terminal event missing")
    require(not any(row["event"] == "RUNTIME_FAIL" for row in events), "runtime emitted RUNTIME_FAIL")
    counts = Counter(row["event"] for row in events)
    for event, expected in EXPECTED_COUNTS.items():
        require(counts[event] == expected, f"{event} count differs: {counts[event]}")

    begins = [row for row in events if row["event"] == "QUIZ_TEXT_BEGIN"]
    ends = [row for row in events if row["event"] == "QUIZ_TEXT_END"]
    require([row["context"] for row in begins] == [row["context"] for row in ends], "text begin/end contexts differ")
    require(all(end["frame"] > begin["frame"] for begin, end in zip(begins, ends, strict=True)), "a PMDO text page consumed no frames")
    prelude = only(events, "QUIZ_PRELUDE_BEGIN")
    require(prelude["page_count"] == 7, "canonical prelude page count differs")
    prelude_pages = [row for row in events if row["event"] == "QUIZ_PRELUDE_PAGE"]
    require([row["key"] for row in prelude_pages] == [
        "PMDRED_EU_S01_001", "PMDRED_EU_S01_002", "PMDRED_EU_S01_003",
        "PMDRED_EU_S01_004", "PMDRED_EU_S01_005",
        "PMDRED_EU_S01_006_A", "PMDRED_EU_S01_006_B",
    ], "canonical prelude order differs")
    bgm_switch = only(events, "QUIZ_BGM_SWITCH")
    fade_in = only(events, "QUIZ_PALETTE_FADE_IN_END")
    require(bgm_switch["cue"] == "Welcome to the World of Pokémon!.ogg", "BGM switch differs")
    require(fade_in["frames"] == 30 and fade_in["source_opcode"] == "CMD_BYTE_22", "fade-in mapping differs")

    rng = [row for row in events if row["event"] == "QUIZ_RNG"]
    require([(row["purpose"], row["value"]) for row in rng] == EXPECTED_RNG, "two-attempt RNG replay differs")
    require(all(row["maximum"] == (55 if row["purpose"] == "question" else 13) for row in rng), "RNG bounds differ")
    answers = [row for row in events if row["event"] == "QUIZ_ANSWER"]
    require([(row["question"], row["answer"]) for row in answers] == EXPECTED_ANSWERS, "answer/branch replay differs")
    branch = only(events, "QUIZ_BRANCH")
    require((branch["source"], branch["target"]) == ("brave_2a", "brave_2b"), "BraveQuest2B branch differs")
    genders = [row["choice"] for row in events if row["event"] == "QUIZ_GENDER"]
    require(genders == [3, 2], "New Era non-binary/female paths differ")
    personalities = [
        (row["personality"], row["tie_start"])
        for row in events if row["event"] == "QUIZ_PERSONALITY"
    ]
    require(personalities == [("naive", 0), ("brave", 4)], "personality results differ")
    recommendations = [row for row in events if row["event"] == "QUIZ_RECOMMENDATION"]
    require([
        (row["personality"], row["species"], row["historical_gender_column"], row["new_era_non_binding"])
        for row in recommendations
    ] == [
        ("naive", "totodile", 1, True),
        ("brave", "charmander", 2, True),
    ], "canonical recommendation/New Era adaptation differs")
    choice_ends = [row for row in events if row["event"] == "QUIZ_CHOICE_END"]
    confirmation_results = [row["result"] for row in choice_ends if row["context"] == "recommendation_confirmation"]
    require(confirmation_results == [2, 1], "restart then confirm branch differs")
    complete = only(events, "QUIZ_COMPLETE")
    require(complete["personality"] == "brave" and complete["recommendation"] == "charmander", "final flow result differs")
    asserted = only(events, "FLOW_RESULT_ASSERTED")
    require(
        asserted["personality"] == "brave"
        and asserted["choice"] == 2
        and asserted["recommendation"] == "charmander",
        "fixture final result assertion differs",
    )
    catalogue = only(events, "CATALOGUE_ASSERTED")
    require(catalogue["context"] == "move_never_filter" and catalogue["species"] == "charmander", "full catalogue prioritization differs")
    nickname = only(events, "PARTNER_NICKNAME_ASSERTED")
    require(nickname["context"] == "Quel sera le nom de votre | partenaire?", "partner nickname prompt differs")
    bgm_fade = only(events, "QUIZ_BGM_FADEOUT")
    fade_out_begin = only(events, "QUIZ_PALETTE_FADE_OUT_BEGIN")
    fade_out_end = only(events, "QUIZ_PALETTE_FADE_OUT_END")
    require(bgm_fade["frames"] == 30, "BGM fade duration differs")
    require(
        fade_out_begin["frames"] == 30
        and fade_out_begin["source_opcode"] == "CMD_BYTE_23"
        and fade_out_end["frames"] == 30,
        "fade-out mapping differs",
    )
    event_names = [row["event"] for row in events]
    require(
        event_names.index("QUIZ_BGM_SWITCH") < event_names.index("QUIZ_PALETTE_FADE_IN_END")
        < event_names.index("QUIZ_QUESTIONS_SELECTED")
        < event_names.index("QUIZ_COMPLETE")
        < event_names.index("CATALOGUE_ASSERTED")
        < event_names.index("QUIZ_BGM_FADEOUT")
        < event_names.index("QUIZ_PALETTE_FADE_OUT_END"),
        "presentation/audio/result order differs",
    )
    require(only(events, "RUNTIME_RESULT")["result"] == "PASS", "runtime result did not pass")

    termination = read_json(paths["termination.json"])
    term = termination["termination"]
    require(termination["terminal_seen"] and termination["graceful_exit_observed"], "normal unload was not observed")
    require(not termination["requested_signal_sent"], "watchdog signal was sent")
    require(not termination["residual_processes_after_cleanup"], "residual PMDO process remains")
    require(term["result"] == "PASS" and term["kind"] == "NORMAL_EXIT", "termination did not pass")
    require(term["normal_exit"] and term["returncode"] == 0, "PMDO did not exit normally with zero")

    runtime_log = paths["runtime.log"].read_text(errors="replace")
    require(not any(value in runtime_log for value in ("RUNTIME_FAIL", "Exception Depth", "Could not find value", "Lua Trace")), "runtime log contains an engine/Lua failure")
    index_log = paths["index.log"].read_text(errors="replace")
    require("Could not deserialize" not in index_log and "Error importing" not in index_log, "fixture indexing failed")
    manifest = read_json(paths["fixture_manifest.json"])
    require(manifest["schema"] == "new-era.pmdred-eu-personality-quiz-flow-runtime-fixture.v1", "fixture schema differs")
    require(not manifest["source_index_symlinks"], "fixture exposes writable source indexes")
    require("injected fixture choices" in manifest["choice_mode"], "fixture did not declare injected choices")
    for relative, expected in manifest["tracked_hashes"].items():
        require(sha256_file(ROOT / relative) == expected, f"tracked fixture input drift: {relative}")

    production = (ROOT / "Data/Script/halcyon/ground/personality_test/init.lua").read_text()
    required_production_tokens = (
        "local PmdRedQuizFlow = require 'halcyon.ground.personality_test.pmdred_quiz_flow'",
        "PmdRedQuizFlow.PlayCanonicalPrelude()",
        "local quiz_result = PmdRedQuizFlow.Run()",
        "SV.PersonalityTest.Personality = quiz_result.personality",
        "PmdRedQuizFlow.PrioritizeRecommendation(",
        "PmdRedQuizFlow.ShowPartnerPrompt()",
        "PmdRedQuizFlow.PartnerNicknamePrompt()",
        "PmdRedQuizFlow.ShowEndText()",
        "PmdRedQuizFlow.FadeOutCanonical()",
    )
    require(all(token in production for token in required_production_tokens), "production personality_test routing token missing")
    require("Bienvenue dans le monde des Pokémon !" not in production, "superseded New Era pseudo-quiz introduction remains")
    require("Es-tu un garçon, une fille ou non binaire ?" not in production, "duplicate player gender prompt remains")
    require(production.index("PmdRedQuizFlow.Run()") < production.index("if CONFIG.RegularStarters() then", production.index("PmdRedQuizFlow.Run()")), "quiz does not precede existing selector")

    screenshots = sorted(
        (fixture / "appdata/SCREENSHOT").glob("*.png"),
        key=lambda path: (path.stat().st_mtime_ns, path.name),
    )
    require(len(screenshots) == 2, f"expected two recommendation captures, got {len(screenshots)}")
    images = [Image.open(path).convert("RGB") for path in screenshots]
    require(all(image.size == (320, 240) for image in images), "unexpected capture dimensions")
    difference = ImageChops.difference(images[0], images[1])
    require(difference.getbbox() is not None, "two flow captures are visually identical")
    changed_pixels = sum(pixel != (0, 0, 0) for pixel in difference.get_flattened_data())
    capture_rows = [
        {
            "context": context,
            "source_file": path.name,
            "width": image.width,
            "height": image.height,
            "sha256": sha256_file(path),
        }
        for context, path, image in zip(("recommendation_1", "recommendation_2"), screenshots, images, strict=True)
    ]

    report = {
        "schema": "new-era.pmdred-eu-personality-quiz-flow-runtime-validation.v1",
        "result": "FLOW_PASS_PRODUCTION_ROUTED_INTERACTIVE_INPUT_PARTIAL",
        "full_quiz_integrated": False,
        "production_personality_test_routed": True,
        "classification": {
            "introduction_questions_scoring_descriptions_palette_audio": "PMD_RED_EU_CANON",
            "complete_catalogue_recommendation_and_non_binary_choice": "NEW_ERA_ADAPTATION",
            "ground_parallax_hero_partner_creation_systems": "NEW_ERA_NATIVE",
        },
        "validated_scope": [
            "tracked production personality_test module parsed and loaded by PMDO with only Enter inert in the ignored fixture",
            "seven exact French EU introduction pages through real PMDO text UI",
            "BGM switch and 30-frame CMD_BYTE_22-equivalent fade-in",
            "two complete deterministic quiz attempts, one restart, 16 direct questions and BraveQuest2B",
            "all prompts and answer labels passed through real PMDO text UI",
            "canonical gender choices plus preserved New Era non-binary adaptation",
            "description, recommendation, confirmation, partner prompt, nickname prompt and end text",
            "move-never-filter recommendation over a New Era catalogue fixture",
            "30-frame BGM fade and CMD_BYTE_23-equivalent fade-out",
            "normal native PMDO unload",
        ],
        "not_yet_validated": [
            "physical interactive menu input and cursor navigation; choices were injected by the ignored fixture",
            "all 55 direct question choice combinations and all tie seeds",
            "actual hero/partner menu completion, assets, abilities, moves and save serialization",
            "final transition to relic_forest after live character creation",
            "full s01 harness handoff into the production personality_test flow",
        ],
        "timeline": {
            "event_count": len(events),
            "last_runtime_frame": events[-1]["frame"],
            "text_page_count": counts["QUIZ_TEXT_BEGIN"],
            "choice_prompt_count": counts["QUIZ_CHOICE_BEGIN"],
            "restart_count": counts["QUIZ_RESTART"],
            "branch_count": counts["QUIZ_BRANCH"],
            "answer_count": counts["QUIZ_ANSWER"],
        },
        "pmdo": {"version": "0.8.12", "termination": term},
        "captures": {"changed_rgb_pixels": changed_pixels, "rows": capture_rows},
        "authority": {
            "flow_sha256": sha256_file(ROOT / "Data/Script/halcyon/ground/personality_test/pmdred_quiz_flow.lua"),
            "production_init_sha256": sha256_file(ROOT / "Data/Script/halcyon/ground/personality_test/init.lua"),
            "ground_sha256": sha256_file(ROOT / "Data/Ground/personality_test.rsground"),
        },
        "promotion": "INTERACTIVE_INPUT_AND_LIVE_CHARACTER_CREATION_GATE_REQUIRED_BEFORE_FULL_PASS",
    }
    return report, screenshots


def archive(fixture: Path, output: Path, report: dict[str, Any], screenshots: list[Path]) -> None:
    require(not output.exists(), f"refusing to overwrite runtime evidence: {output}")
    output.mkdir(parents=True)
    for name in ("events.jsonl", "termination.json", "runtime.log", "index.log", "fixture_manifest.json"):
        shutil.copy2(fixture / name, output / name)
    capture_dir = output / "captures"
    capture_dir.mkdir()
    for context, screenshot in zip(("recommendation_1", "recommendation_2"), screenshots, strict=True):
        shutil.copy2(screenshot, capture_dir / f"{context}.png")
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
    report, screenshots = validate(fixture)
    if not args.check_only:
        archive(fixture, output, report, screenshots)
    print("PMDRED_EU_PERSONALITY_QUIZ_FLOW_PASS", json.dumps({
        "events": report["timeline"]["event_count"],
        "text_pages": report["timeline"]["text_page_count"],
        "choice_prompts": report["timeline"]["choice_prompt_count"],
        "result": report["result"],
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
