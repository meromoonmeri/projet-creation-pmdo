#!/usr/bin/env python3
"""Regressions for the restored New Era title-screen New Game path."""

from __future__ import annotations

import hashlib
import json
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INIT = ROOT / "Data/Script/halcyon/ground/personality_test/init.lua"
START = ROOT / "Data/StartParams.xml"
GROUND = ROOT / "Data/Ground/personality_test.rsground"
SCRIPTVARS = ROOT / "Data/Script/halcyon/scriptvars.lua"
MAIN = ROOT / "Data/Script/halcyon/main.lua"
RUNTIME = ROOT / "docs/pmdred_eu/narrative_migration/startup_regression/runtime"
RESTORED_INIT_SHA = "e417364941cc7c5e53002f72633b7050b610601eaaa538e903556f1fbd766bac"
GROUND_SHA = "76b3abc6953e9da4840c094494585c9a79057791ef66f81027e1541858eaeb8d"
SCRIPTVARS_SHA = "f3b59e7e36201f0c981c877babb3c3d2c88fb350780580144c9c85604c9e8d01"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class NewGameStartupRegressionTests(unittest.TestCase):
    def test_start_map_resolves_to_native_personality_selector(self) -> None:
        start = ET.parse(START).getroot()
        self.assertEqual(start.findtext("StartMap/Zone"), "master_zone")
        self.assertEqual(int(start.findtext("StartMap/Segment")), -1)
        self.assertEqual(int(start.findtext("StartMap/ID")), 31)
        self.assertEqual(int(start.findtext("StartMap/Entry")), 0)
        maps = json.loads((ROOT / "Data/Zone/master_zone.json").read_text(encoding="utf-8-sig"))["Object"]["GroundMaps"]
        self.assertEqual(maps[31], "personality_test")
        self.assertEqual(maps[40], "searing_crucible")

    def test_native_character_select_is_byte_exact_and_pmdred_is_dormant(self) -> None:
        text = INIT.read_text()
        self.assertEqual(sha256(INIT), RESTORED_INIT_SHA)
        self.assertIn("function personality_test.CharacterSelect()", text)
        self.assertIn("Bienvenue dans le monde des Pokémon !", text)
        self.assertIn("GAME:EnterGroundMap('relic_forest', 'Main_Entrance_Marker')", text)
        self.assertNotIn("pmdred_quiz_flow", text)
        self.assertNotIn("PmdRedQuizFlow", text)
        self.assertNotIn("SV.PersonalityTest", text)
        self.assertNotIn("halcyon.pmdred_eu", MAIN.read_text())

    def test_missingno_sentinels_were_not_replaced_or_promoted(self) -> None:
        self.assertEqual(sha256(GROUND), GROUND_SHA)
        self.assertEqual(sha256(SCRIPTVARS), SCRIPTVARS_SHA)
        ground = json.loads(GROUND.read_text(encoding="utf-8-sig"))["Object"]
        spawners = [value for layer in ground["Entities"] for value in layer.get("Spawners", [])]
        teammate = next(value for value in spawners if value["NPCName"] == "Teammate1")
        self.assertEqual(teammate["NPCChar"]["BaseForm"]["Species"], "missingno")
        self.assertIn('Starter = MonsterID("missingno", 0, "normal", Gender.Genderless)', SCRIPTVARS.read_text())
        self.assertEqual(ET.parse(START).getroot().findtext("DefaultMonster"), "missingno")

    def test_real_pmdo_new_game_evidence_passes(self) -> None:
        validation = json.loads((RUNTIME / "validation.json").read_text())
        self.assertEqual(validation["result"], "PASS_NORMAL_NEW_ERA_STARTUP_RESTORED")
        runtime = validation["runtime"]
        self.assertEqual(runtime["event_count"], 95)
        self.assertEqual(runtime["first_ground"]["asset"], "personality_test")
        self.assertEqual(runtime["normal_story_ground"]["asset"], "relic_forest")
        self.assertEqual(runtime["normal_story_ground"]["chapter"], 1)
        self.assertFalse(runtime["pmdred_triggered"])
        self.assertFalse(runtime["internal_seed_sentinel"]["visible"])
        for field in ("party_0", "party_1", "actor_player", "actor_teammate"):
            self.assertNotEqual(runtime["normal_story_ground"][field], "missingno")
        self.assertEqual(validation["protected_baseline"]["guard_result"], "PASS")
        rows = (RUNTIME / "evidence_hashes.sha256").read_text().splitlines()
        self.assertEqual(len(rows), 7)
        for row in rows:
            expected, relative = row.split("  ", 1)
            self.assertEqual(sha256(RUNTIME / relative), expected)


if __name__ == "__main__":
    unittest.main(verbosity=2)
