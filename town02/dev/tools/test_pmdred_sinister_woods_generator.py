#!/usr/bin/env python3
"""Static contract tests for the PMD Red Sinister Woods generator adapter.

These tests do not certify the PMDO executable.  They prove only that the
checked-in source profile and the serialized ZoneData are wired to PMDO's
native procedural steps, with the b41 material and the fixed final Ground
kept distinct.
"""
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROFILE_PATH = ROOT / "docs/canonical/red/sinister_woods_generator_profile.json"
ZONE_PATH = ROOT / "Data/Zone/gloomy_forest.json"


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def steps(node):
    return [entry["Value"] for entry in node.get("Item", node).get("GenSteps", [])]


def walk(value):
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


def find_step(node, token: str):
    return next(value for value in walk(node) if isinstance(value, dict) and token in value.get("$type", ""))


class SinisterWoodsProfileTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.profile = load(PROFILE_PATH)
        cls.zone = load(ZONE_PATH)["Object"]

    def test_profile_is_source_derived_and_explicitly_not_a_runtime_verdict(self):
        self.assertEqual(self.profile["schema"], "new-era.pmdred.sinister-woods-generator-profile.v1")
        self.assertEqual(self.profile["source"]["repository"], "pret/pmd-red")
        self.assertEqual(self.profile["source"]["commit"], "bf0092d0e34fd8e49b859a0b5f96f00740faa42d")
        self.assertEqual(self.profile["result"], "PROFILE_ONLY_NOT_RUNTIME_CERTIFICATION")
        self.assertEqual(len(self.profile["floors"]), 13)

    def test_canonical_floor_properties_and_tilesets(self):
        floors = self.profile["floors"]
        self.assertEqual([row["floor"] for row in floors], list(range(1, 14)))
        self.assertTrue(all(row["floor_properties"]["tileset"] == 41 for row in floors[:12]))
        self.assertEqual(floors[12]["floor_properties"]["tileset"], 65)
        self.assertEqual(floors[12]["floor_properties"]["fixedRoomNumber"], 2)
        self.assertTrue(all(row["tileset_binding"]["music"] == "Sinister Woods.ogg" for row in floors[:12]))
        self.assertIsNone(floors[12]["tileset_binding"]["music"])

    def test_display_identity_and_profile_link(self):
        self.assertEqual(self.zone["Name"]["DefaultText"], "Sinister Woods")
        self.assertEqual(self.zone["Name"]["LocalTexts"]["fr"], "Forêt Sinistre")
        self.assertEqual(self.zone["PMDRedGeneratorProfile"], "docs/canonical/red/sinister_woods_generator_profile.json")

    def test_all_procedural_floors_are_native_and_use_b41(self):
        for segment_index in (0, 1, 3):
            nodes = self.zone["Segments"][segment_index]["Floors"]["nodes"]
            self.assertGreater(len(nodes), 1)
            for node in nodes:
                self.assertIn("GridFloorGen", node["Item"]["$type"])
                self.assertIsNotNone(find_step(node, "InitGridPlanStep"))
                self.assertIsNotNone(find_step(node, "GridPathBranch"))
                self.assertIsNotNone(find_step(node, "ConnectGridBranchStep"))
                self.assertIsNotNone(find_step(node, "FloorStairsStep"))
                texture = find_step(node, "MapTextureStep")
                self.assertEqual(texture["GroundTileset"], "sinister_woods_b41_floor")
                self.assertEqual(texture["BlockTileset"], "sinister_woods_b41_wall")
                self.assertEqual(texture["WaterTileset"], "sinister_woods_b41_secondary")
                data = find_step(node, "MapDataStep")
                self.assertEqual(data["Music"], "Sinister Woods.ogg")
                self.assertEqual(data["TimeLimit"], 1000)
                self.assertFalse(any("RoomGenRound" in value.get("$type", "") for value in walk(node) if isinstance(value, dict)))
                self.assertTrue(any("RoomGenSquare" in value.get("$type", "") for value in walk(node) if isinstance(value, dict)))

    def test_canonical_secondary_terrain_flags_are_represented_by_native_step(self):
        # Source floors 8F-10F set ROOM_FLAG_ALLOW_SECONDARY_TERRAIN and the
        # adapter adds PMDO's native wall-lake generator.  The other source
        # floors do not get a fabricated water pass.
        first_segment = self.zone["Segments"][0]["Floors"]["nodes"]
        for index, node in enumerate(first_segment[:12]):
            has_perlin = any("PerlinWaterStep" in value.get("$type", "") for value in steps(node))
            if index in (7, 8, 9):
                self.assertTrue(has_perlin, f"canonical secondary terrain missing at local floor {index}")
            else:
                self.assertFalse(has_perlin, f"fabricated secondary terrain at local floor {index}")

    def test_fixed_story_segments_remain_load_generators(self):
        for segment_index in (2, 4, 5, 6, 7, 8, 9, 10):
            floors = self.zone["Segments"][segment_index]["Floors"]
            self.assertIsInstance(floors, list)
            self.assertTrue(any("LoadGen" in floor.get("$type", "") for floor in floors))
            self.assertTrue(any("MappedRoomStep" in value.get("$type", "") for value in walk(floors) if isinstance(value, dict)))

    def test_old_relic_blob_path_is_absent_from_zone(self):
        payload = json.dumps(self.zone, ensure_ascii=False)
        self.assertNotIn("LoadBlobStep", payload)
        self.assertNotIn("ReverseRelicForest", payload)
        self.assertNotIn("relic_forest_blob_", payload)


if __name__ == "__main__":
    unittest.main(verbosity=2)
