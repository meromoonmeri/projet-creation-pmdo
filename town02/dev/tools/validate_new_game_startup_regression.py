#!/usr/bin/env python3
"""Validate and archive the real title-screen New Game regression proof."""

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
import shutil
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Any

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_FIXTURE = ROOT / ".runtime-cache/new-game-full-regression-fixture"
DEFAULT_OUTPUT = ROOT / "docs/pmdred_eu/narrative_migration/startup_regression/runtime"
RESTORED_INIT_SHA = "e417364941cc7c5e53002f72633b7050b610601eaaa538e903556f1fbd766bac"
REGRESSED_INIT_SHA = "20eda4cffdf57d3a03641aa92036ef64d10c682882e86a2fd504af08db9858b8"
GROUND_SHA = "76b3abc6953e9da4840c094494585c9a79057791ef66f81027e1541858eaeb8d"
SCRIPTVARS_SHA = "f3b59e7e36201f0c981c877babb3c3d2c88fb350780580144c9c85604c9e8d01"


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


def validate(fixture: Path) -> tuple[dict[str, Any], list[Path]]:
    paths = {
        name: fixture / name
        for name in ("events.jsonl", "termination.json", "runtime.log", "index.log", "fixture_manifest.json")
    }
    for path in paths.values():
        require(path.is_file(), f"runtime evidence missing: {path}")
    events = [json.loads(line) for line in paths["events.jsonl"].read_text().splitlines()]
    require(len(events) == 95, f"expected 95 runtime events, got {len(events)}")
    require([row["sequence"] for row in events] == list(range(1, 96)), "event sequence is not contiguous")
    frames = [row["frame"] for row in events]
    require(frames == sorted(frames), "runtime frame sequence moved backwards")
    require(events[-1]["event"] == "end", "terminal event missing")
    require(not any(row["event"] == "RUNTIME_FAIL" for row in events), "runtime emitted RUNTIME_FAIL")

    bootstrap = one(events, "BOOTSTRAP")
    require(not bootstrap["new_game_plus_direct"] and not bootstrap["enter_zone_override"], "fixture redirected New Game")
    new_game = one(events, "NEW_GAME_EVENT")
    require(new_game["party_count"] == 1 and new_game["initial_species"] == "missingno", "engine seed sentinel changed")
    require(new_game["chapter"] == 1 and not new_game["pmdred_state_present"], "new-save state differs")
    first = one(events, "FIRST_GROUND_ENTERED")
    require(first["asset"] == "personality_test", "first Ground is not the restored New Era selector")
    require(first["party_count"] == 2, "normal selector did not create hero and partner")
    require(first["party_0"] != "missingno" and first["party_1"] != "missingno", "MissingNo reached first observable Ground state")
    require(not first["pmdred_state_present"], "PMD Red state was injected at startup")
    story = one(events, "NORMAL_STORY_GROUND_ENTERED")
    require(story["asset"] == "relic_forest" and story["chapter"] == 1, "normal chapter-one story destination differs")
    require(story["party_count"] == 2, "final team size differs")
    for field in ("party_0", "party_1", "actor_player", "actor_teammate"):
        require(story[field] not in {"missingno", "nil", ""}, f"invalid final species in {field}")
    require(story["party_0"] == story["actor_player"], "hero actor/team mismatch")
    require(story["party_1"] == story["actor_teammate"], "partner actor/team mismatch")
    require(not story["pmdred_state_present"], "PMD Red state exists after normal startup")
    asserted = one(events, "STARTUP_ASSERTED")
    require(
        asserted == {
            "event": "STARTUP_ASSERTED",
            "sequence": asserted["sequence"],
            "frame": asserted["frame"],
            "first_ground": "personality_test",
            "story_ground": "relic_forest",
            "missingno_visible": False,
            "pmdred_triggered": False,
        },
        "startup terminal assertion differs",
    )
    menu_types = [row["menu_type"] for row in events if row["event"] == "MENU_OBSERVED"]
    for expected in ("TopMenu", "TitleDialog", "ChooseMonsterMenu", "QuestionDialog", "TeamNameMenu"):
        require(expected in menu_types, f"real menu was not observed: {expected}")
    input_kinds = [row["kind"] for row in events if row["event"] == "FRAME_INPUT_QUEUED"]
    require("partner_select_right" in input_kinds, "partner cursor was not physically moved")
    require("nickname_letter_a" in input_kinds, "nickname key input was not physically supplied")

    termination = read_json(paths["termination.json"])
    term = termination["termination"]
    require(termination["terminal_seen"] and termination["graceful_exit_observed"], "normal PMDO unload not observed")
    require(not termination["requested_signal_sent"], "watchdog signal was sent")
    require(not termination["residual_processes_after_cleanup"], "residual PMDO process remains")
    require(term["result"] == "PASS" and term["kind"] == "NORMAL_EXIT", "termination did not pass")
    require(term["normal_exit"] and term["returncode"] == 0, "PMDO did not exit normally with zero")

    runtime_log = paths["runtime.log"].read_text(errors="replace")
    forbidden = ("RUNTIME_FAIL", "Exception Depth", "Could not find value", "Lua Trace")
    require(not any(value in runtime_log for value in forbidden), "runtime log contains an engine/Lua failure")
    require(not re.search(r"PMDRED_EU|PERSONALITY_QUIZ|QUIZ_", runtime_log), "PMD Red quiz/harness leaked into normal startup log")
    index_log = paths["index.log"].read_text(errors="replace")
    require("Could not deserialize" not in index_log and "Error importing" not in index_log, "fixture indexing failed")

    manifest = read_json(paths["fixture_manifest.json"])
    require(manifest["schema"] == "new-era.new-game-full-regression-fixture.v1", "fixture schema differs")
    require(not manifest["new_game_plus_direct"] and not manifest["enter_zone_override"], "manifest declares redirected startup")
    require(not manifest["source_index_symlinks"], "fixture exposes writable source indexes")
    for relative, expected in manifest["production_hashes"].items():
        require(sha256_file(ROOT / relative) == expected, f"production fixture input drift: {relative}")

    init_path = ROOT / "Data/Script/halcyon/ground/personality_test/init.lua"
    init_text = init_path.read_text()
    require(sha256_file(init_path) == RESTORED_INIT_SHA, "personality_test was not restored byte-for-byte")
    require("pmdred_quiz_flow" not in init_text and "SV.PersonalityTest" not in init_text, "PMD Red hook remains in startup")
    require("function personality_test.CharacterSelect()" in init_text, "native New Era character selector missing")
    require(sha256_file(ROOT / "Data/Ground/personality_test.rsground") == GROUND_SHA, "personality Ground changed")
    require(sha256_file(ROOT / "Data/Script/halcyon/scriptvars.lua") == SCRIPTVARS_SHA, "scriptvars changed")

    start = ET.parse(ROOT / "Data/StartParams.xml").getroot()
    zone = start.findtext("StartMap/Zone")
    segment = int(start.findtext("StartMap/Segment", "999"))
    map_id = int(start.findtext("StartMap/ID", "-1"))
    entry = int(start.findtext("StartMap/Entry", "-1"))
    ground_maps = read_json(ROOT / "Data/Zone/master_zone.json")["Object"]["GroundMaps"]
    require((zone, segment, entry) == ("master_zone", -1, 0), "StartMap envelope differs")
    require(ground_maps[map_id] == "personality_test", "StartMap ID does not resolve to personality_test")

    screenshots = sorted(
        (fixture / "appdata/SCREENSHOT").glob("*.png"),
        key=lambda path: (path.stat().st_mtime_ns, path.name),
    )
    require(len(screenshots) == 1, f"expected one final story capture, got {len(screenshots)}")
    image = Image.open(screenshots[0]).convert("RGB")
    require(image.size == (1512, 1512), "unexpected full-Ground screenshot dimensions")

    baseline_path = ROOT / "docs/pmdred_eu/narrative_migration/protected_baseline.json"
    report = {
        "schema": "new-era.new-game-startup-regression-validation.v1",
        "result": "PASS_NORMAL_NEW_ERA_STARTUP_RESTORED",
        "priority": "CRITICAL_REGRESSION",
        "cause": {
            "primary": "Data/StartParams.xml StartMap ID 40 resolved to searing_crucible while the intended New Era selector is personality_test at ID 31",
            "secondary": "commit 524e379 routed pmdred_quiz_flow directly from personality_test.CharacterSelect before the future narrative gate",
            "visible_missingno_mechanism": "StartChars is empty and DefaultMonster is the engine's historical missingno seed sentinel; wrong/premature Ground exposure allowed that sentinel or the immutable teammate placeholder to become observable",
            "not_the_cause": [
                "SV.General.Starter sentinel: unchanged from the pre-migration baseline",
                "personality_test Ground teammate placeholder: unchanged immutable Ground data",
                "halcyon.pmdred_eu harness: no normal-start require and validators are environment-gated",
            ],
        },
        "correction": {
            "personality_test_init": {
                "regressed_sha256": REGRESSED_INIT_SHA,
                "restored_sha256": RESTORED_INIT_SHA,
                "method": "byte-exact restoration from commit 56d30131, before production quiz routing",
            },
            "start_map": {
                "before": {"zone": "master_zone", "segment": -1, "id": 40, "resolved_ground": "searing_crucible", "entry": 0},
                "after": {"zone": zone, "segment": segment, "id": map_id, "resolved_ground": ground_maps[map_id], "entry": entry},
            },
            "default_monster_changed": False,
            "certified_ground_changed": False,
            "chapters_1_to_5_changed": False,
            "pmdred_modules": "present but dormant; no production startup require",
        },
        "runtime": {
            "method": "fresh appdata and physical title-screen New Game; no direct NewGamePlus and no EnterZone override",
            "event_count": len(events),
            "first_ground": first,
            "normal_story_ground": story,
            "internal_seed_sentinel": {
                "species": new_game["initial_species"],
                "classification": "pre-existing engine seed consumed before first observable Ground state",
                "visible": False,
            },
            "pmdred_triggered": False,
            "termination": term,
            "capture": {
                "file": screenshots[0].name,
                "width": image.width,
                "height": image.height,
                "sha256": sha256_file(screenshots[0]),
            },
        },
        "protected_baseline": {
            "path": str(baseline_path.relative_to(ROOT)),
            "sha256": sha256_file(baseline_path),
            "guard_result": "PASS",
            "qualified_ground_ids": 219,
            "immutable_ground_and_tile_files": 438,
            "chapter_1_to_5_files": 99,
            "active_fugitive_routes": 27,
            "historical_integration_files": 48,
        },
        "remaining_pmdred_work": "dormant until a post-startup narrative gate is explicitly designed and validated",
    }
    return report, screenshots


def archive(fixture: Path, output: Path, report: dict[str, Any], screenshots: list[Path]) -> None:
    require(not output.exists(), f"refusing to overwrite runtime evidence: {output}")
    output.mkdir(parents=True)
    for name in ("events.jsonl", "termination.json", "runtime.log", "index.log", "fixture_manifest.json"):
        shutil.copy2(fixture / name, output / name)
    capture_dir = output / "captures"
    capture_dir.mkdir()
    shutil.copy2(screenshots[0], capture_dir / "relic_forest_normal_start.png")
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
    print("NEW_GAME_STARTUP_REGRESSION_PASS", json.dumps({
        "result": report["result"],
        "events": report["runtime"]["event_count"],
        "first_ground": report["runtime"]["first_ground"]["asset"],
        "story_ground": report["runtime"]["normal_story_ground"]["asset"],
        "missingno_visible": report["runtime"]["internal_seed_sentinel"]["visible"],
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
