#!/usr/bin/env python3
"""Rebuild D55's three native fragments from the imported PMDO quarry data.

The previous passage_temps zone contained one three-floor segment with no item
or enemy pool.  D55 is Special Episode 5 (Team Charm), not a FutureArc hero
route dungeon, but its three independently persisted fragments still need real
native segment IDs and playable content.

This migration intentionally reuses Data/Zone/carriere_cuivre.json, imported
from PMDODump/DumpAsset, rather than inventing generators, species, items, or
traps.  Its first nine Copper Quarry floors are split into three three-floor
segments.  Core official zone pools are copied and their source floor ranges
are projected onto each local 0..2 segment.  Enemy levels alone are rescaled
with the repository's existing tier-chart policy from level 13 to level 22.
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
import copy
import json
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "Data/Zone/carriere_cuivre.json"
TARGET = ROOT / "Data/Zone/passage_temps.json"
INDEX = ROOT / "Data/Zone/index.idx"

SOURCE_LEVEL = 13
TARGET_LEVEL = 22
SEGMENT_LENGTH = 3
SEGMENT_COUNT = 3
MAX_ENEMY_LEVEL = 24
CORE_ZONE_STEPS = {
    "PMDC.LevelGen.SaveVarsZoneStep",
    "PMDC.LevelGen.FloorNameDropZoneStep",
    "RogueEssence.LevelGen.MoneySpawnZoneStep",
    "RogueEssence.LevelGen.ItemSpawnZoneStep",
    "RogueEssence.LevelGen.TeamSpawnZoneStep",
    "RogueEssence.LevelGen.TileSpawnZoneStep",
}
TITLES = (
    ("First Echo", "Premier écho"),
    ("Second Echo", "Deuxième écho"),
    ("Third Echo", "Troisième écho"),
)


def load(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8-sig") as stream:
        return json.load(stream)


def save(path: Path, data: dict[str, Any], indent: int) -> None:
    with path.open("w", encoding="utf-8-sig", newline="\n") as stream:
        json.dump(data, stream, ensure_ascii=False, indent=indent)


def short_type(node: dict[str, Any]) -> str:
    return str(node.get("$type", "")).split(",", 1)[0]


def project_ranges(node: Any, start: int, stop: int) -> Any | None:
    """Project half-open source Range values onto local floors.

    RogueElements.IntRange uses an inclusive Min and exclusive Max.  A list
    member whose own Range does not overlap this [start, stop) fragment is
    removed.  This matches PMDO's ranged item, team, trap, and spawn-rate
    entries.  The selected core steps do not contain SpreadPlan/FloorRange
    structures.
    """
    if isinstance(node, list):
        projected = []
        for value in node:
            converted = project_ranges(value, start, stop)
            if converted is not None:
                projected.append(converted)
        return projected

    if not isinstance(node, dict):
        return node

    result = {}
    for key, value in node.items():
        if key == "Range" and isinstance(value, dict) and {
            "Min", "Max"
        }.issubset(value):
            lower = max(int(value["Min"]), start)
            upper = min(int(value["Max"]), stop)
            if lower >= upper:
                return None
            shifted = copy.deepcopy(value)
            shifted["Min"] = lower - start
            shifted["Max"] = upper - start
            result[key] = shifted
        else:
            converted = project_ranges(value, start, stop)
            if converted is not None:
                result[key] = converted
    return result


def rescale_enemy_levels(node: Any) -> None:
    if isinstance(node, dict):
        level = node.get("Level")
        if isinstance(level, dict) and {"Min", "Max"}.issubset(level):
            for bound in ("Min", "Max"):
                original = int(level[bound])
                scaled = round(original * TARGET_LEVEL / SOURCE_LEVEL)
                level[bound] = min(MAX_ENEMY_LEVEL, max(3, scaled))
            level["Max"] = max(level["Min"], level["Max"])
        for value in node.values():
            rescale_enemy_levels(value)
    elif isinstance(node, list):
        for value in node:
            rescale_enemy_levels(value)


def build_segment(source: dict[str, Any], number: int) -> dict[str, Any]:
    start = number * SEGMENT_LENGTH
    stop = start + SEGMENT_LENGTH
    segment = {
        "$type": source["$type"],
        "Floors": copy.deepcopy(source["Floors"][start:stop]),
        "ZoneSteps": [],
        "IsRelevant": True,
        "Comment": (
            f"D55 Special Episode 5 fragment {number + 1}; Copper Quarry "
            f"floors {start + 1}-{stop} and core spawn tables reused from "
            "the PMDODump/DumpAsset import."
        ),
    }
    if len(segment["Floors"]) != SEGMENT_LENGTH:
        raise ValueError("Carrière de Cuivre does not expose nine source floors")

    for source_step in source["ZoneSteps"]:
        if short_type(source_step) not in CORE_ZONE_STEPS:
            continue
        step = project_ranges(copy.deepcopy(source_step), start, stop)
        if step is None:
            continue
        if short_type(step) == "PMDC.LevelGen.FloorNameDropZoneStep":
            english, french = TITLES[number]
            step["Name"] = {
                "DefaultText": f"Passage of Time — {english}\\nB{{0}}F",
                "LocalTexts": {
                    "fr": f"Passage du Temps — {french}\\n{{0}}SS"
                },
            }
        if short_type(step) == "RogueEssence.LevelGen.TeamSpawnZoneStep":
            rescale_enemy_levels(step)
        segment["ZoneSteps"].append(step)

    types = {short_type(step) for step in segment["ZoneSteps"]}
    required = {
        "RogueEssence.LevelGen.ItemSpawnZoneStep",
        "RogueEssence.LevelGen.TeamSpawnZoneStep",
        "RogueEssence.LevelGen.TileSpawnZoneStep",
    }
    if not required.issubset(types):
        raise ValueError(f"fragment {number + 1} lost core zone content: {types}")
    return segment


def build_zone(source_doc: dict[str, Any], previous_doc: dict[str, Any]) -> dict[str, Any]:
    source = source_doc["Object"]["Segments"][0]
    previous = previous_doc["Object"]
    result = copy.deepcopy(previous_doc)
    zone = result["Object"]
    zone["Name"] = {
        "DefaultText": "Passage of Time",
        "LocalTexts": {"fr": "Passage du Temps"},
    }
    zone["Released"] = True
    zone["Comment"] = (
        "D55 / Special Episode 5 (Team Charm), kept separate from FutureArc. "
        "Three native three-floor fragments reuse PMDODump/DumpAsset Copper "
        "Quarry generators and core content; enemy levels follow the New Era "
        "level-22 tier."
    )
    zone["Level"] = TARGET_LEVEL
    zone["LevelCap"] = True
    zone["TeamSize"] = 2
    zone["Segments"] = [
        build_segment(source, number) for number in range(SEGMENT_COUNT)
    ]
    zone["GroundMaps"] = []
    return result


def update_summary(index_doc: dict[str, Any], zone_doc: dict[str, Any]) -> dict[str, Any]:
    result = copy.deepcopy(index_doc)
    zone = zone_doc["Object"]
    summary = result["Object"]["passage_temps"]
    for key in (
        "ExpPercent", "Level", "LevelCap", "KeepSkills", "TeamRestrict",
        "TeamSize", "MoneyRestrict", "BagRestrict", "KeepTreasure",
        "BagSize", "Rescues", "Name", "Released",
    ):
        summary[key] = copy.deepcopy(zone[key])
    # ZoneEntrySummary.Rogue is an index flag, not ZoneData.Rogue; imported
    # playable zones in this repository consistently keep the summary at zero.
    summary["Rogue"] = 0
    summary["CountedFloors"] = SEGMENT_COUNT * SEGMENT_LENGTH
    summary["Grounds"] = []
    summary["Maps"] = [list(range(SEGMENT_LENGTH)) for _ in range(SEGMENT_COUNT)]
    return result


def content_counts(zone_doc: dict[str, Any]) -> list[tuple[int, int, int]]:
    counts = []
    for segment in zone_doc["Object"]["Segments"]:
        species = set()
        items = set()
        traps = set()

        def visit(node: Any, destination: set[str], key: str) -> None:
            if isinstance(node, dict):
                value = node.get(key)
                if isinstance(value, str) and value:
                    destination.add(value)
                for child in node.values():
                    visit(child, destination, key)
            elif isinstance(node, list):
                for child in node:
                    visit(child, destination, key)

        for step in segment["ZoneSteps"]:
            step_type = short_type(step)
            if step_type == "RogueEssence.LevelGen.TeamSpawnZoneStep":
                visit(step, species, "Species")
            elif step_type == "RogueEssence.LevelGen.ItemSpawnZoneStep":
                visit(step, items, "ID")
            elif step_type == "RogueEssence.LevelGen.TileSpawnZoneStep":
                visit(step, traps, "ID")
        counts.append((len(species), len(items), len(traps)))
    return counts


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="verify without writing")
    args = parser.parse_args()

    source_doc = load(SOURCE)
    current_zone = load(TARGET)
    current_index = load(INDEX)
    expected_zone = build_zone(source_doc, current_zone)
    expected_index = update_summary(current_index, expected_zone)
    zone_ok = current_zone == expected_zone
    index_ok = current_index == expected_index
    counts = content_counts(expected_zone)

    if args.check:
        if not zone_ok or not index_ok:
            print(
                "ERROR: passage_temps native fragments are stale "
                f"(zone={zone_ok}, index={index_ok})"
            )
            return 1
        print(f"OK: 3 native D55 segments, content counts (species/items/traps): {counts}")
        return 0

    if not zone_ok:
        save(TARGET, expected_zone, indent=1)
    if not index_ok:
        save(INDEX, expected_index, indent=2)
    print(
        "Rebuilt passage_temps: "
        f"zone_changed={not zone_ok}, index_changed={not index_ok}, "
        f"content={counts}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
