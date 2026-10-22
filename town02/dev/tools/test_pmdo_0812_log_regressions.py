#!/usr/bin/env python3
"""Static regressions for the PMDO 0.8.12 errors reported on 2026-08-12."""

from __future__ import annotations

import json
import unittest
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ZONE_DIR = ROOT / "Data/Zone"
MIGRATED = {
    "chasm_cave": (8, 8, 0),
    "dark_hill": (15, 15, 15),
    "dusk_forest": (8, 8, 8),
    "sealed_ruin": (8, 8, 8),
    "sealed_ruin_pit": (6, 6, 6),
    "spiritomb_room": (1, 1, 0),
}
FLOOR_PREFIX = "RogueElements.FloorStairsStep`3"
DETECT_PREFIX = "RogueElements.DetectIsolatedStairsStep`3"
MAP_ARGS = (
    "[[RogueEssence.LevelGen.MapGenContext, RogueEssence],"
    "[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],"
    "[RogueEssence.LevelGen.MapGenExit, RogueEssence]], RogueElements"
)
LIST_ARGS = (
    "[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence],"
    "[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],"
    "[RogueEssence.LevelGen.MapGenExit, RogueEssence]], RogueElements"
)
CANONICAL_FLOOR = {FLOOR_PREFIX + MAP_ARGS, FLOOR_PREFIX + LIST_ARGS}
CANONICAL_DETECT = {DETECT_PREFIX + MAP_ARGS, DETECT_PREFIX + LIST_ARGS}
WALL_STENCIL_TYPE = (
    "RogueElements.MapTerrainStencil`1"
    "[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements"
)


def walk(value):
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


class PMDO0812LogRegressions(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.zones = {
            path.stem: json.loads(path.read_text(encoding="utf-8-sig"))
            for path in sorted(ZONE_DIR.glob("*.json"))
        }

    def test_all_stair_generic_types_are_pmdo_0812_compatible(self):
        floor_types = Counter()
        detect_types = Counter()
        forbidden = []
        for zone_id, payload in self.zones.items():
            for node in walk(payload):
                if not isinstance(node, dict):
                    continue
                type_name = node.get("$type", "")
                if type_name.startswith(FLOOR_PREFIX):
                    floor_types[type_name] += 1
                if type_name.startswith(DETECT_PREFIX):
                    detect_types[type_name] += 1
                if (
                    "RogueElements.TeamSpawner" in type_name
                    or "RogueEssence.Dungeon.StairsTile" in type_name
                    or type_name == "RogueElements.WaterTerrainStencil, RogueElements"
                ):
                    forbidden.append((zone_id, type_name))
        self.assertFalse(forbidden)
        self.assertEqual(set(floor_types), CANONICAL_FLOOR)
        self.assertEqual(set(detect_types), CANONICAL_DETECT)

    def test_migration_inventory_and_water_semantics(self):
        actual = {}
        for zone_id, payload in self.zones.items():
            floor = detect = wall_water = 0
            for node in walk(payload):
                if not isinstance(node, dict):
                    continue
                type_name = node.get("$type", "")
                floor += type_name == FLOOR_PREFIX + MAP_ARGS
                detect += type_name == DETECT_PREFIX + MAP_ARGS
                if type_name.startswith("RogueElements.PerlinWaterStep`1"):
                    stencil = node.get("TerrainStencil")
                    if stencil == {
                        "$type": WALL_STENCIL_TYPE,
                        "Room": False,
                        "Wall": True,
                        "Blocked": False,
                        "Not": False,
                    }:
                        wall_water += 1
            if zone_id in MIGRATED:
                actual[zone_id] = (floor, detect, wall_water)
        self.assertEqual(actual, MIGRATED)
        self.assertEqual(sum(row[0] for row in actual.values()), 46)
        self.assertEqual(sum(row[1] for row in actual.values()), 46)
        self.assertEqual(sum(row[2] for row in actual.values()), 37)

    def test_spiritomb_room_is_valid_and_migrated(self):
        spiritomb = self.zones["spiritomb_room"]
        self.assertEqual(spiritomb["Object"]["Name"]["DefaultText"], "Spiritomb Room")
        types = [
            node.get("$type", "") for node in walk(spiritomb) if isinstance(node, dict)
        ]
        self.assertIn(FLOOR_PREFIX + MAP_ARGS, types)
        self.assertIn(DETECT_PREFIX + MAP_ARGS, types)

    def test_future_dungeon_generator_cannot_restore_legacy_types(self):
        text = (ROOT / "tools/gen_future_dungeons.py").read_text()
        self.assertNotIn("[RogueElements.TeamSpawner, RogueElements]", text)
        self.assertNotIn("[RogueEssence.Dungeon.StairsTile, RogueEssence]", text)
        self.assertNotIn("RogueElements.WaterTerrainStencil, RogueElements", text)
        self.assertIn(FLOOR_PREFIX + MAP_ARGS, text)
        self.assertIn(DETECT_PREFIX + MAP_ARGS, text)
        self.assertIn(WALL_STENCIL_TYPE, text)

    def test_register_monster_uses_exact_monster_id_overload(self):
        path = ROOT / "Data/Script/halcyon/services/debug_tools/init.lua"
        text = path.read_text()
        self.assertIn(
            "_DATA.Save:RegisterMonster(_DATA.Save.ActiveTeam.Players[0].BaseForm)",
            text,
        )
        self.assertNotIn("RegisterMonster(_DATA.Save.ActiveTeam.Players[0].BaseForm.Species)", text)


if __name__ == "__main__":
    unittest.main()
