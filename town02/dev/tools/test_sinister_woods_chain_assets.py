#!/usr/bin/env python3
"""Static asset contracts discovered by the real Sinister Woods chain replay."""
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class SinisterWoodsChainAssetTests(unittest.TestCase):
    def test_boss_map_is_deserializable_native_shape(self):
        path = ROOT / "Data/Map/gloomy_forest_boss.rsmap"
        data = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
        self.assertEqual(data["$type"], "RogueEssence.Dungeon.Map, RogueEssence")
        self.assertEqual(data["MapTeams"][0]["$type"], "RogueEssence.Dungeon.MonsterTeam, RogueEssence")
        player = data["MapTeams"][0]["Players"][0]
        self.assertIsInstance(player["Tactic"], dict)
        self.assertEqual(player["Tactic"]["ID"], "boss")
        effects = data["MapEffect"]["OnMapStarts"]
        self.assertEqual(
            [entry["Value"]["$type"] for entry in effects],
            [
                "PMDC.Dungeon.BattlePositionEvent, PMDC",
                "RogueEssence.Dungeon.SingleCharScriptEvent, RogueEssence",
                "RogueEssence.Dungeon.SingleCharScriptEvent, RogueEssence",
            ],
        )
        self.assertIsNone(effects[0]["Value"]["Positions"])

    def test_chain_fixture_copies_only_runtime_fixture_assets(self):
        source = (ROOT / "tools/build_sinister_woods_chain_fixture.py").read_text(encoding="utf-8")
        self.assertIn("production_assets_modified", source)
        self.assertIn("TreeshroudForest1", source)
        self.assertIn("gloomy_forest_boss_Canonical_Final_Render", source)
        # Shared Treeshroud is admitted only for protected legacy Grounds in
        # the ignored fixture; the production Sinister Woods zone still has no
        # Treeshroud procedural reference.
        zone = json.loads((ROOT / "Data/Zone/gloomy_forest.json").read_text(encoding="utf-8-sig"))["Object"]
        self.assertNotIn("treeshroud_forest_1_", json.dumps(zone))

    def test_entrance_dynamic_cast_does_not_require_preexisting_rivals(self):
        source = (ROOT / "Data/Script/halcyon/ground/gloomy_forest_entrance/gloomy_forest_entrance_ch_6.lua").read_text(encoding="utf-8")
        self.assertIn("local actor = CH(name)", source)
        self.assertIn("if actor ~= nil then GROUND:Hide(name) end", source)
        self.assertNotIn("GROUND:Hide(name) end\n  end", source)


if __name__ == "__main__":
    unittest.main(verbosity=2)
