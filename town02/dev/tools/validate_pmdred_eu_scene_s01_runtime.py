#!/usr/bin/env python3
"""Validate and archive the real-PMDO s01 prelude run.

This is intentionally a partial-scene gate.  It proves the exact portal prelude
through BGM_SWITCH, then requires the declared personality-quiz dependency.  It
must never report the full s01 scene as migrated.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from pathlib import Path
from typing import Any

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_FIXTURE = ROOT / ".runtime-cache/pmdred-eu-narrative-s01-fixture"
DEFAULT_OUTPUT = ROOT / "docs/pmdred_eu/narrative_migration/scenes/s01/runtime"
DEPENDENCY = "SPECIAL_TEXT_PERSONALITY_QUIZ_AND_PALETTE_0x22"


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
    events_path = fixture / "events.jsonl"
    termination_path = fixture / "termination.json"
    runtime_log_path = fixture / "runtime.log"
    index_log_path = fixture / "index.log"
    manifest_path = fixture / "fixture_manifest.json"
    for path in (events_path, termination_path, runtime_log_path, index_log_path, manifest_path):
        require(path.is_file(), f"runtime evidence missing: {path}")

    events = [json.loads(line) for line in events_path.read_text().splitlines()]
    require(len(events) == 55, f"expected 55 ordered runtime events, got {len(events)}")
    require([event["sequence"] for event in events] == list(range(1, 56)), "event sequence is not contiguous")
    frames = [event["frame"] for event in events]
    require(frames == sorted(frames), "runtime frame sequence moved backwards")
    require(events[-1]["event"] == "end", "terminal end event missing")
    require(not any(event["event"] == "RUNTIME_FAIL" for event in events), "runtime emitted RUNTIME_FAIL")

    expected_dialogues = [f"PMDRED_EU_S01_{index:03d}" for index in range(1, 7)]
    actual_dialogues = [event["key"] for event in events if event["event"] == "MSG_ON_BG_BEGIN"]
    require(actual_dialogues == expected_dialogues, "dialogue command order differs from the EU source")
    expected_pages = [*expected_dialogues[:5], "PMDRED_EU_S01_006_A", "PMDRED_EU_S01_006_B"]
    actual_pages = [event["page_key"] for event in events if event["event"] == "SCREENSHOT_COMPLETED"]
    require(actual_pages == expected_pages, "dialogue page/wait order differs from the EU source")
    page_timings = []
    for page_key in expected_pages:
        begin = next(event for event in events if event["event"] == "MSG_ON_BG_PAGE_BEGIN" and event["page_key"] == page_key)
        requested = next(event for event in events if event["event"] == "SCREENSHOT_REQUESTED" and event["page_key"] == page_key)
        completed = next(event for event in events if event["event"] == "SCREENSHOT_COMPLETED" and event["page_key"] == page_key)
        end = next(event for event in events if event["event"] == "MSG_ON_BG_PAGE_END" and event["page_key"] == page_key)
        require(begin["frame"] <= requested["frame"] <= completed["frame"] <= end["frame"], f"{page_key}: invalid frame ordering")
        require(end["frame"] > begin["frame"], f"{page_key}: UI page consumed no runtime frames")
        page_timings.append({
            "page_key": page_key,
            "begin_frame": begin["frame"],
            "capture_request_frame": requested["frame"],
            "capture_complete_frame": completed["frame"],
            "end_frame": end["frame"],
            "runtime_duration_frames": end["frame"] - begin["frame"],
        })

    important = [
        event["event"] for event in events
        if event["event"] in {
            "BGM_STOP_BEGIN", "BGM_STOP_END", "SELECT_MAP_ASSERTED",
            "PRESENTATION_ACTORS_HIDDEN", "TEXTBOX_CLEAR",
            "SELECT_ENTITIES_ASSERTED", "BGM_SWITCH_BEGIN", "BGM_SWITCH_END",
            "DEPENDENCY_BLOCKED", "RUNTIME_RESULT", "end",
        }
    ]
    require(important == [
        "BGM_STOP_BEGIN", "BGM_STOP_END", "SELECT_MAP_ASSERTED",
        "PRESENTATION_ACTORS_HIDDEN", "TEXTBOX_CLEAR",
        "SELECT_ENTITIES_ASSERTED", "BGM_SWITCH_BEGIN", "BGM_SWITCH_END",
        "DEPENDENCY_BLOCKED", "RUNTIME_RESULT", "end",
    ], "staging/audio/dependency order differs")
    hidden = next(event for event in events if event["event"] == "PRESENTATION_ACTORS_HIDDEN")
    require(hidden["actor_count"] >= 1, "fixture actor was not hidden from the actor-free source sector")
    blocked = next(event for event in events if event["event"] == "DEPENDENCY_BLOCKED")
    require(blocked["id"] == DEPENDENCY, "wrong dependency gate")
    result = next(event for event in events if event["event"] == "RUNTIME_RESULT")
    require(result["complete"] is False and result["dependency"] == DEPENDENCY, "partial scene was falsely marked complete")

    termination = read_json(termination_path)
    term = termination["termination"]
    require(termination["terminal_seen"], "termination runner did not observe end")
    require(termination["graceful_exit_observed"], "native PMDO unload was not observed")
    require(not termination["requested_signal_sent"], "watchdog signal was sent")
    require(not termination["residual_processes_before_cleanup"], "residual PMDO process before cleanup")
    require(not termination["residual_processes_after_cleanup"], "residual PMDO process after cleanup")
    require(term["result"] == "PASS" and term["kind"] == "NORMAL_EXIT", "PMDO termination did not pass")
    require(term["normal_exit"] and term["returncode"] == 0, "PMDO did not exit normally with code 0")
    require(not term["segmentation_fault"] and not term["forced_kill"], "unsafe PMDO termination")

    runtime_log = runtime_log_path.read_text(errors="replace")
    forbidden = ("RUNTIME_FAIL", "Exception Depth", "Could not find value", "Lua Trace")
    require(not any(value in runtime_log for value in forbidden), "runtime log contains a script/engine error")
    index_log = index_log_path.read_text(errors="replace")
    require("Could not deserialize" not in index_log and "Error importing" not in index_log, "fixture index failed")

    screenshots = sorted((fixture / "appdata/SCREENSHOT").glob("*.png"), key=lambda path: (path.stat().st_mtime_ns, path.name))
    require(len(screenshots) == 7, f"expected 7 synchronized presentation captures, got {len(screenshots)}")
    screenshot_rows = []
    for page_key, screenshot in zip(expected_pages, screenshots, strict=True):
        image = Image.open(screenshot).convert("RGBA")
        colors = image.getcolors(maxcolors=image.width * image.height)
        require(colors == [(image.width * image.height, (0, 0, 0, 255))], f"{page_key}: actor/effect leaked onto black MSG_ON_BG presentation")
        screenshot_rows.append({
            "page_key": page_key,
            "source_file": screenshot.name,
            "width": image.width,
            "height": image.height,
            "sha256": sha256_file(screenshot),
            "ground_frame": "fully_opaque_black_no_actor_or_effect",
        })

    pmdo_path = ROOT / ".runtime-cache/pmdo-headless-bundle/PMDO"
    sdl_path = next((ROOT / ".runtime-cache/dotnet-headless/PMDO").rglob("libSDL2-2.0.so.0"))
    dump_tree_manifest = ROOT / ".runtime-cache/DumpAsset.tree-sha256"
    transport_candidates = sorted((ROOT / ".runtime-cache/downloads").glob("DumpAsset-*.download.*"))
    require(sha256_file(pmdo_path) == "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327", "PMDO 0.8.12 executable lock mismatch")
    require(sha256_file(sdl_path) == "2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f", "patched SDL lock mismatch")
    require(sha256_file(dump_tree_manifest) == "42be740813125641bb5c3a15adefcb24b53e70fa5401863e3913b77ea0c2356d", "DumpAsset tree lock mismatch")
    require(len(dump_tree_manifest.read_text().splitlines()) == 11485, "DumpAsset tree inventory mismatch")
    report = {
        "schema": "new-era.pmdred-eu-narrative-scene-runtime-validation.v1",
        "scene": "s01",
        "result": "PARTIAL_PASS_DEPENDENCY_BLOCKED",
        "full_scene_migrated": False,
        "validated_boundary": "BGM_STOP through BGM_SWITCH after six exact EU MSG_ON_BG blocks",
        "blocking_dependency": DEPENDENCY,
        "runtime_environment": {
            "pmdo_0_8_12_sha256": sha256_file(pmdo_path),
            "patched_sdl_sha256": sha256_file(sdl_path),
            "dumpasset_tree_manifest_sha256": sha256_file(dump_tree_manifest),
            "dumpasset_tree_file_count": len(dump_tree_manifest.read_text().splitlines()),
            "dumpasset_tree_lock_result": "PASS",
            "dumpasset_transport_archive": ({
                "path": str(transport_candidates[0].relative_to(ROOT)),
                "observed_sha256": sha256_file(transport_candidates[0]),
                "locked_sha256": "956ad1047c8e66ea545c26033119e7e2fc3c1ff614ecfd37f96f57912178eb17",
                "result": "TRANSPORT_ARCHIVE_REGENERATED_BY_GITHUB; EXTRACTED_11485_FILE_TREE_MATCHES_LOCK",
            } if transport_candidates else None),
        },
        "pmdo": {
            "version": "0.8.12",
            "termination": term,
            "terminal_seen": termination["terminal_seen"],
            "graceful_exit_observed": termination["graceful_exit_observed"],
            "requested_signal_sent": termination["requested_signal_sent"],
            "residual_process_count": len(termination["residual_processes_after_cleanup"]),
        },
        "timeline": {
            "event_count": len(events),
            "contiguous_sequence": True,
            "monotonic_runtime_frames": True,
            "validated_boundary_frame": events[-1]["frame"],
            "dialogue_command_order": actual_dialogues,
            "dialogue_page_order": actual_pages,
            "dialogue_page_timings": page_timings,
            "audio_order": ["BGM_STOP", "BGM_SWITCH:MUS_WELCOME_TO_THE_WORLD_OF_POKEMON"],
            "source_sector_actor_count": 0,
            "fixture_actor_hidden_count": hidden["actor_count"],
            "movement": "NOT_APPLICABLE_IN_VALIDATED_BOUNDARY",
            "orientation": "NOT_APPLICABLE_IN_VALIDATED_BOUNDARY",
            "camera": "NOT_APPLICABLE_IN_VALIDATED_BOUNDARY",
            "vfx": "BLACK_MSG_ON_BG_PRESENTATION_ONLY_BEFORE_BLOCKING_PALETTE_OPCODE",
            "state_at_boundary": "cutscene prelude complete; exact quiz handoff deliberately blocked",
        },
        "captures": screenshot_rows,
        "capture_limitation": "PMDO _GROUND:Screenshot captures the Ground presentation layer, not UI glyph pixels. Exact French glyph input is therefore proven by ROM-backed static equality plus successful real UI calls and synchronized page events; it is not claimed as a dialogue pixel comparison.",
        "promotion": "FORBIDDEN_UNTIL_FULL_S01_QUIZ_PALETTE_FADE_AND_RETURN_PASS",
    }
    return report, screenshots


def archive(fixture: Path, output: Path, report: dict[str, Any], screenshots: list[Path]) -> None:
    require(not output.exists(), f"refusing to overwrite runtime evidence: {output}")
    output.mkdir(parents=True)
    for name in ("events.jsonl", "termination.json", "runtime.log", "index.log", "fixture_manifest.json"):
        shutil.copy2(fixture / name, output / name)
    capture_dir = output / "captures"
    capture_dir.mkdir()
    for index, screenshot in enumerate(screenshots, 1):
        shutil.copy2(screenshot, capture_dir / f"dialogue_page_{index:02d}.png")
    (output / "validation.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    paths = sorted(path for path in output.rglob("*") if path.is_file() and path.name != "evidence_hashes.sha256")
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
    print("PMDRED_EU_S01_RUNTIME_PARTIAL_PASS", json.dumps({
        "events": report["timeline"]["event_count"],
        "captures": len(report["captures"]),
        "dependency": report["blocking_dependency"],
        "normal_exit": report["pmdo"]["termination"]["normal_exit"],
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
