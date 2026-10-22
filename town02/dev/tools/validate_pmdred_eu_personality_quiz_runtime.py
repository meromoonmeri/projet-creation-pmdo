#!/usr/bin/env python3
"""Validate and archive the real-PMDO personality-quiz core evidence.

This gate deliberately covers only ROM-backed data, canonical selection/scoring,
the BraveQuest2B branch, tie resolution, and New Era's existing animated
parallax.  It must not claim that the production UI/route is integrated yet.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from pathlib import Path
from typing import Any

from PIL import Image, ImageChops

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_FIXTURE = ROOT / ".runtime-cache/pmdred-eu-personality-quiz-fixture"
DEFAULT_OUTPUT = ROOT / "docs/pmdred_eu/narrative_migration/personality_quiz/runtime_core"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
EXPECTED_SELECTED = [
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


def validate(fixture: Path) -> tuple[dict[str, Any], list[Path]]:
    required = {
        name: fixture / name
        for name in (
            "events.jsonl", "termination.json", "runtime.log", "index.log",
            "fixture_manifest.json",
        )
    }
    for path in required.values():
        require(path.is_file(), f"runtime evidence missing: {path}")

    events = [json.loads(line) for line in required["events.jsonl"].read_text().splitlines()]
    require(len(events) == 33, f"expected 33 ordered runtime events, got {len(events)}")
    require([row["sequence"] for row in events] == list(range(1, 34)), "event sequence is not contiguous")
    frames = [row["frame"] for row in events]
    require(frames == sorted(frames), "runtime frames moved backwards")
    require(events[-1]["event"] == "end", "terminal event is missing")
    require(not any(row["event"] == "RUNTIME_FAIL" for row in events), "runtime emitted RUNTIME_FAIL")

    expected_event_order = [
        "BOOTSTRAP", "ENTER_ZONE_REQUEST", "GROUND_ASSERTED",
        "PRESENTATION_ACTORS_HIDDEN", "DATA_ASSERTED",
        *("RNG_DRAW" for _ in range(9)),
        "QUESTIONS_SELECTED",
        *("ANSWER_APPLIED" for _ in range(8)),
        "SCORING_ASSERTED", "BRANCH_ASSERTED", "TIE_ASSERTED",
        "SCREENSHOT_REQUESTED", "SCREENSHOT_COMPLETED",
        "SCREENSHOT_REQUESTED", "SCREENSHOT_COMPLETED",
        "PARALLAX_TIMELINE_COMPLETED", "RUNTIME_RESULT", "end",
    ]
    require([row["event"] for row in events] == expected_event_order, "runtime event order differs")

    data = next(row for row in events if row["event"] == "DATA_ASSERTED")
    require(
        (data["personalities"], data["selectable_questions"], data["branch_questions"], data["asked_questions"])
        == (13, 55, 1, 8),
        "runtime data inventory differs",
    )
    draws = [row for row in events if row["event"] == "RNG_DRAW"]
    require([row["value"] for row in draws] == [0, 1, 4, 8, 12, 16, 20, 24, 28], "RNG replay differs")
    require(all(row["maximum"] == 55 for row in draws), "question RNG bound differs")
    selected = next(row for row in events if row["event"] == "QUESTIONS_SELECTED")
    require(selected["questions"] == EXPECTED_SELECTED, "question selection/order differs")
    require(selected["rejected_category_draws"] == 1, "category rejection was not observed")
    answers = [row for row in events if row["event"] == "ANSWER_APPLIED"]
    require([row["question"] for row in answers] == EXPECTED_SELECTED, "scoring question order differs")
    require(all(row["answer"] == 1 for row in answers), "deterministic answer replay differs")
    scoring = next(row for row in events if row["event"] == "SCORING_ASSERTED")
    require(
        scoring["result"] == "naive" and scoring["max_points"] == 5 and scoring["history_count"] == 8,
        "canonical deterministic score differs",
    )
    branch = next(row for row in events if row["event"] == "BRANCH_ASSERTED")
    require(
        branch["source"] == "brave_2a"
        and branch["target"] == "brave_2b"
        and branch["result_points"] == 4,
        "BraveQuest2B branch/effect differs",
    )
    tie = next(row for row in events if row["event"] == "TIE_ASSERTED")
    require(tie["tie_start"] == 5 and tie["result"] == "naive", "strict-greater tie resolution differs")

    requests = [row for row in events if row["event"] == "SCREENSHOT_REQUESTED"]
    completions = [row for row in events if row["event"] == "SCREENSHOT_COMPLETED"]
    require([row["phase"] for row in requests] == ["parallax_early", "parallax_late"], "capture requests differ")
    require([row["phase"] for row in completions] == ["parallax_early", "parallax_late"], "capture completion differs")
    for request, completion in zip(requests, completions, strict=True):
        require(request["frame"] <= completion["frame"], f"{request['phase']}: capture frame order differs")
    timeline = next(row for row in events if row["event"] == "PARALLAX_TIMELINE_COMPLETED")
    require(
        timeline["elapsed_frames"] == 120
        and timeline["back_movement_x"] == 30
        and timeline["front_movement_x"] == -30,
        "parallax timeline declaration differs",
    )
    result = next(row for row in events if row["event"] == "RUNTIME_RESULT")
    require(result["result"] == "PASS", "runtime result did not pass")

    termination = read_json(required["termination.json"])
    term = termination["termination"]
    require(termination["terminal_seen"], "termination runner did not observe end")
    require(termination["graceful_exit_observed"], "native PMDO unload was not observed")
    require(not termination["requested_signal_sent"], "watchdog signal was sent")
    require(not termination["residual_processes_after_cleanup"], "residual PMDO process remains")
    require(term["result"] == "PASS" and term["kind"] == "NORMAL_EXIT", "termination did not pass")
    require(term["normal_exit"] and term["returncode"] == 0, "PMDO did not exit normally with zero")
    require(not term["segmentation_fault"] and not term["forced_kill"], "unsafe PMDO termination")

    runtime_log = required["runtime.log"].read_text(errors="replace")
    forbidden = ("RUNTIME_FAIL", "Exception Depth", "Could not find value", "Lua Trace")
    require(not any(value in runtime_log for value in forbidden), "runtime log contains an engine/Lua failure")
    index_log = required["index.log"].read_text(errors="replace")
    require("Could not deserialize" not in index_log and "Error importing" not in index_log, "fixture indexing failed")

    manifest = read_json(required["fixture_manifest.json"])
    require(manifest["schema"] == "new-era.pmdred-eu-personality-quiz-runtime-fixture.v1", "fixture schema differs")
    require(not manifest["source_index_symlinks"], "fixture exposed writable source indexes")
    for relative, expected_hash in manifest["tracked_hashes"].items():
        require(sha256_file(ROOT / relative) == expected_hash, f"tracked fixture input drift: {relative}")

    authority = read_json(ROOT / "docs/pmdred_eu/narrative_migration/personality_quiz_fr_eu.json")
    require(authority["authority"]["rom_sha256"] == ROM_SHA256, "quiz authority ROM hash differs")
    require(authority["authority"]["record_count"] == 219, "ROM-backed record count differs")
    require(authority["rules"]["selectable_question_count"] == 55, "authority selectable count differs")
    require(authority["rules"]["branch_question_count"] == 1, "authority branch count differs")

    ground = read_json(ROOT / "Data/Ground/personality_test.rsground")["Object"]
    require(ground["AssetName"] == "personality_test", "target Ground identity differs")
    layers = ground["Background"]["Layers"]
    require(len(layers) == 2, "personality_test parallax layer count differs")
    expected_layers = [
        ("Dream_Back", 255, 30, True),
        ("Dream_Front", 128, -30, True),
    ]
    actual_layers = [
        (
            row["BG"]["BGAnim"]["AnimIndex"],
            row["BG"]["BGAnim"]["Alpha"],
            row["BG"]["BGMovement"]["X"],
            row["BG"]["RepeatX"],
        )
        for row in layers
    ]
    require(actual_layers == expected_layers, "serialized New Era parallax differs")

    screenshots = sorted(
        (fixture / "appdata/SCREENSHOT").glob("*.png"),
        key=lambda path: (path.stat().st_mtime_ns, path.name),
    )
    require(len(screenshots) == 2, f"expected two synchronized captures, got {len(screenshots)}")
    images = [Image.open(path).convert("RGB") for path in screenshots]
    require(all(image.size == (320, 240) for image in images), "unexpected PMDO capture dimensions")
    difference = ImageChops.difference(images[0], images[1])
    require(difference.getbbox() is not None, "parallax captures are visually identical")
    changed_pixels = sum(
        pixel != (0, 0, 0) for pixel in difference.get_flattened_data()
    )
    require(changed_pixels > 0, "parallax produced no changed pixels")
    capture_rows = [
        {
            "phase": phase,
            "source_file": path.name,
            "width": image.width,
            "height": image.height,
            "sha256": sha256_file(path),
        }
        for phase, path, image in zip(
            ("parallax_early", "parallax_late"), screenshots, images, strict=True
        )
    ]

    report = {
        "schema": "new-era.pmdred-eu-personality-quiz-runtime-validation.v1",
        "result": "CORE_PASS_NOT_PRODUCTION_ROUTED",
        "full_quiz_integrated": False,
        "classification": {
            "rom_text_questions_answers_effects": "PMD_RED_EU_CANON",
            "target_ground_and_parallax": "NEW_ERA_NATIVE",
            "injected_rng_and_fixture_lifecycle": "NEW_ERA_ADAPTATION",
        },
        "validated_scope": [
            "219 aligned EU ROM French records",
            "55 directly selectable questions plus branch-only BraveQuest2B",
            "eight distinct-category selections with observed rejection",
            "answer effects and deterministic scoring",
            "BraveQuest2A to BraveQuest2B branch",
            "strict-greater cyclic tie resolution",
            "tracked personality_test Ground and two-layer animated parallax",
            "normal native PMDO unload",
        ],
        "not_yet_validated": [
            "production personality_test entry routing",
            "interactive question/gender UI and all user-choice paths",
            "canonical introduction, BGM, SFX, palettes, VFX, and timings",
            "result handoff to the complete New Era starter catalogue",
            "starter/partner creation and final transition",
        ],
        "authority": {
            "rom_sha256": ROM_SHA256,
            "record_count": 219,
            "authority_sha256": sha256_file(ROOT / "docs/pmdred_eu/narrative_migration/personality_quiz_fr_eu.json"),
            "quiz_data_sha256": sha256_file(ROOT / "Data/Script/halcyon/ground/personality_test/pmdred_quiz_data.lua"),
            "quiz_engine_sha256": sha256_file(ROOT / "Data/Script/halcyon/ground/personality_test/pmdred_quiz_engine.lua"),
        },
        "pmdo": {
            "version": "0.8.12",
            "termination": term,
            "event_count": len(events),
            "last_runtime_frame": events[-1]["frame"],
        },
        "selection_replay": {
            "draws": [row["value"] for row in draws],
            "selected_questions": selected["questions"],
            "result": scoring["result"],
        },
        "parallax": {
            "serialized_layers": [
                {"asset": asset, "alpha": alpha, "movement_x": movement, "repeat_x": repeat}
                for asset, alpha, movement, repeat in expected_layers
            ],
            "requested_elapsed_frames": timeline["elapsed_frames"],
            "changed_rgb_pixels": changed_pixels,
            "captures": capture_rows,
        },
        "promotion": "FORBIDDEN_UNTIL_INTERACTIVE_PRODUCTION_TIMELINE_AND_NEW_ERA_STARTER_HANDOFF_PASS",
    }
    return report, screenshots


def archive(fixture: Path, output: Path, report: dict[str, Any], screenshots: list[Path]) -> None:
    require(not output.exists(), f"refusing to overwrite runtime evidence: {output}")
    output.mkdir(parents=True)
    for name in ("events.jsonl", "termination.json", "runtime.log", "index.log", "fixture_manifest.json"):
        shutil.copy2(fixture / name, output / name)
    capture_dir = output / "captures"
    capture_dir.mkdir()
    for phase, screenshot in zip(("parallax_early", "parallax_late"), screenshots, strict=True):
        shutil.copy2(screenshot, capture_dir / f"{phase}.png")
    (output / "validation.json").write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    paths = sorted(
        path for path in output.rglob("*")
        if path.is_file() and path.name != "evidence_hashes.sha256"
    )
    with (output / "evidence_hashes.sha256").open("w", encoding="utf-8", newline="\n") as stream:
        for path in paths:
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
    print("PMDRED_EU_PERSONALITY_QUIZ_CORE_PASS", json.dumps({
        "events": report["pmdo"]["event_count"],
        "captures": len(screenshots),
        "changed_rgb_pixels": report["parallax"]["changed_rgb_pixels"],
        "result": report["result"],
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
