#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent
TOOL = ROOT / "tools/build_environment_inventory.py"
spec = importlib.util.spec_from_file_location("nnv_environment_inventory", TOOL)
module = importlib.util.module_from_spec(spec)
assert spec.loader is not None
sys.modules[spec.name] = module
spec.loader.exec_module(module)


class EnvironmentInventoryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.data = module.build(ROOT / "extracted/official", ROOT / "reports")
        cls.rooms = {room["name"]: room for room in cls.data["rooms"]}

    def test_official_scope_is_exhaustive_and_environment_only(self):
        self.assertEqual(self.data["summary"]["official_room_count"], 98)
        self.assertEqual(self.data["summary"]["environment_room_count"], 85)
        self.assertEqual(self.data["summary"]["excluded_system_room_count"], 13)
        self.assertEqual(len(self.data["rooms"]), 98)
        self.assertEqual(self.data["policy"]["scope"], "environment_only")

    def test_statuses_cannot_claim_unperformed_conversion(self):
        summary = self.data["summary"]
        self.assertEqual(summary["converted_room_count"], 0)
        self.assertEqual(summary["certified_room_count"], 0)
        self.assertEqual(summary["promoted_room_count"], 0)
        self.assertTrue(all(room["conversion_status"] != "CONVERTED" for room in self.data["rooms"]))

    def test_system_rooms_are_excluded_without_exporting_payload(self):
        room = self.rooms["mainmenu"]
        self.assertEqual(room["status"], "EXCLUDED_PROPRIETARY")
        self.assertEqual(room["tile_layers"], [])
        self.assertEqual(room["sprite_placements"], [])
        self.assertEqual(room["instances"], [])

    def test_village_preserves_source_geometry_and_native_adaptation_boundary(self):
        village = self.rooms["rmvillage"]
        self.assertEqual(village["dimensions_px"], [4992, 4992])
        self.assertEqual(village["layer_count"], 18)
        self.assertGreaterEqual(len(village["tile_layers"]), 6)
        self.assertTrue(any(row["object"]["name"] == "objdoor" and row["status"] == "ADAPTATION_REQUIRED" for row in village["instances"]))
        social_instances = [row for room in self.data["rooms"] for row in room["instances"]]
        self.assertTrue(any(row["object"]["name"].startswith("objmob") and row["status"] == "WILD_POKEMON_ADAPTATION_REQUIRED" for row in social_instances))
        self.assertTrue(any(row["object"]["name"] == "objplayerhouse" and row["status"] == "ADAPTATION_REQUIRED" for row in village["instances"]))
        self.assertTrue(all(row["import_policy"] != "import_GameMaker_behavior" for row in village["instances"]))

    def test_source_object_semantics_are_preserved_without_importing_code(self):
        contracts = {row["name"]: row for row in self.data["object_contracts"]}
        mob = contracts["objmob1"]
        self.assertEqual(mob["parent"]["name"], "objmob")
        self.assertIn("gml_Object_objmob1_Create_0", mob["event_code_refs"])
        self.assertIn("never execute or import GameMaker code", mob["source_code_policy"])

    def test_unknown_names_fail_closed(self):
        status, reason = module.classify_instance("objMysteryThing", "instances")
        self.assertEqual(status, "REVIEW_REQUIRED")
        self.assertIn("insufficient_semantic_evidence", reason)

    def test_semantic_hash_is_reproducible(self):
        copied = dict(self.data)
        recorded = copied.pop("inventory_sha256")
        self.assertEqual(recorded, module.digest(copied))


if __name__ == "__main__":
    unittest.main(verbosity=2)
