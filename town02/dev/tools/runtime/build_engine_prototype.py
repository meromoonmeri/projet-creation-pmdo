#!/usr/bin/env python3
"""Install an isolated, engine-native RogueElements prototype zone.

The target must be a disposable copy/hard-link mirror of the mod.  This script
never writes to the repository's ``Data/Zone``.  It serializes three real PMDO
``GridFloorGen`` pipelines (branching, looping, large_rooms); the PMDO runtime
then supplies the seeds and executes RogueElements.
"""
from __future__ import annotations

import argparse
import json
import random
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
from perimeter_guard import install as _install_perimeter_guard  # noqa: E402
_install_perimeter_guard()

from dungeon_builder.definitions import DungeonDefinition, Segment  # noqa: E402
from dungeon_builder.dtef import resolve as resolve_dtef  # noqa: E402
from dungeon_builder.profiles import customize  # noqa: E402
from dungeon_builder.zone_export import floor_gen_steps  # noqa: E402

ZONE_ID = "__dungeon_builder_prototype"
PROFILES = ("branching", "looping", "large_rooms")
# Experimental overrides are deliberately local to this isolated fixture.  A
# profile is promoted into production only after the engine proves it avoids
# degenerate floors across at least ten accepted runtime seeds.
PROFILE_OVERRIDES = {
    "branching": {},
    "looping": {
        "grid_x": (5, 7), "grid_y": (4, 6),
        "room_ratio": (75, 95), "branch_ratio": (55, 95),
        "connect_percent": 65, "default_ratio": (5, 20),
    },
    "large_rooms": {
        "grid_x": (5, 7), "grid_y": (4, 6),
        "cell_width": (10, 14), "cell_height": (9, 13),
        "room_ratio": (80, 100), "branch_ratio": (65, 105),
        "connect_percent": 45, "combine_rate": 20,
    },
}
AUTHORING_SEED = 0xDBA11D20260823


def write_bom_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\ufeff" + json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def build_zone() -> dict:
    segment = Segment(name="engine_prototype", floors=(1, len(PROFILES)), biome="test")
    definition = DungeonDefinition(
        id=ZONE_ID,
        name={"en": "Dungeon Builder Engine Prototype"},
        chapter=0,
        floors=len(PROFILES),
        segments=[segment],
        source="ISOLATED_TEST_FIXTURE",
        biome="test",
        music="",
        dtef={
            "floor": "tiny_meadow_floor",
            "wall": "tiny_meadow_wall",
            "secondary": "tiny_meadow_secondary",
            "name": "tiny_meadow",
            "element": "normal",
        },
        stairs={"min_distance": 4, "exit_tile": "stairs_go_down"},
        variation={"time_limit": 1500, "max_foes": 0, "respawn_time": 100},
        released=False,
    )
    package = resolve_dtef(definition.dtef, strict=True)
    floors = []
    for floor, name in enumerate(PROFILES, start=1):
        # This RNG only chooses authoring parameters such as grid dimensions.
        # The actual floor geometry is generated later by PMDO's ReRandom.
        authoring = random.Random(AUTHORING_SEED + floor)
        gen, _ = floor_gen_steps(
            definition,
            segment,
            customize(name, PROFILE_OVERRIDES[name]),
            package,
            floor,
            authoring,
            authoring_seed=AUTHORING_SEED + floor,
        )
        gen["Comment"] = f"isolated prototype — profile:{name} — runtime seed supplied by PMDO"
        floors.append(gen)

    return {
        "Version": "0.8.12.0",
        "Object": {
            "$type": "RogueEssence.Data.ZoneData, RogueEssence",
            "Name": {"DefaultText": "Dungeon Builder Engine Prototype", "LocalTexts": {}},
            "Released": False,
            "Comment": (
                "ISOLATED TEST FIXTURE. RogueElements runs in PMDO; no canonical dungeon, "
                "Ground, map, scene, Pokemon table, or item table is written."
            ),
            "NoEXP": False,
            "ExpPercent": 100,
            "Level": 1,
            "LevelCap": False,
            "KeepSkills": False,
            "TeamRestrict": False,
            "TeamSize": -1,
            "MoneyRestrict": False,
            "BagRestrict": -1,
            "KeepTreasure": False,
            "BagSize": -1,
            "Persistent": False,
            "Rescues": 0,
            "Rogue": 0,
            "Segments": [{
                "$type": "RogueEssence.LevelGen.LayeredSegment, RogueEssence",
                "Floors": floors,
                "ZoneSteps": [],
                "IsRelevant": True,
                "Comment": "three isolated native profiles",
            }],
            "GroundMaps": [],
        },
    }


def register(index_path: Path) -> None:
    index = json.loads(index_path.read_text(encoding="utf-8-sig"))
    index["Object"][ZONE_ID] = {
        "$type": "RogueEssence.Data.ZoneEntrySummary, RogueEssence",
        "ExpPercent": 100,
        "Level": 1,
        "LevelCap": False,
        "KeepSkills": False,
        "TeamRestrict": False,
        "TeamSize": -1,
        "MoneyRestrict": False,
        "BagRestrict": -1,
        "KeepTreasure": False,
        "BagSize": -1,
        "Rescues": 0,
        "CountedFloors": len(PROFILES),
        "Rogue": 0,
        "Grounds": [],
        "Maps": [list(range(len(PROFILES)))],
        "Name": {"DefaultText": "Dungeon Builder Engine Prototype", "LocalTexts": {}},
        "Released": False,
        "Comment": "isolated engine prototype",
        "SortOrder": 0,
    }
    write_bom_json(index_path, index)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mod_root", type=Path, help="disposable mod mirror to modify")
    args = parser.parse_args()
    mod_root = args.mod_root.resolve()
    index_path = mod_root / "Data" / "Zone" / "index.idx"
    if not index_path.is_file():
        raise SystemExit(f"missing disposable Zone index: {index_path}")
    zone_path = mod_root / "Data" / "Zone" / f"{ZONE_ID}.json"
    write_bom_json(zone_path, build_zone())
    register(index_path)
    print(zone_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
