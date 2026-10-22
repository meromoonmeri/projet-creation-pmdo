#!/usr/bin/env python3
"""Regressions for the definitive PMD Red EU → New Era product contract."""

from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTRACT_PATH = ROOT / "docs/pmdred_eu/narrative_migration/integration_contract.json"
PROGRESS_PATH = ROOT / "docs/pmdred_eu/narrative_migration/progress.json"
PERSONALITY_GROUND = ROOT / "Data/Ground/personality_test.rsground"
PERSONALITY_SCRIPT = ROOT / "Data/Script/halcyon/ground/personality_test/init.lua"


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class DefinitiveIntegrationContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.contract = read_json(CONTRACT_PATH)
        cls.progress = read_json(PROGRESS_PATH)

    def test_contract_rejects_parallel_campaign_and_second_quiz(self) -> None:
        self.assertEqual(self.contract["status"], "AUTHORITATIVE")
        self.assertEqual(self.contract["supersedes"]["parallel_pmd_red_campaign"], "REJECTED")
        self.assertEqual(self.contract["supersedes"]["independent_personality_quiz"], "FORBIDDEN")
        self.assertFalse(self.contract["personality_quiz"]["second_quiz_allowed"])
        self.assertFalse(self.contract["fugitive_arc"]["parallel_campaign_allowed"])
        self.assertEqual(self.contract["fugitive_arc"]["start_location"], "METANO_TOWN_SQUARE")

    def test_existing_personality_system_is_the_integration_target(self) -> None:
        quiz = self.contract["personality_quiz"]
        self.assertEqual(quiz["integration_mode"], "EXTEND_EXISTING_NEW_ERA_PERSONALITY_TEST")
        self.assertEqual(quiz["existing_ground"], "Data/Ground/personality_test.rsground")
        self.assertEqual(quiz["new_era_requirements"]["starter_catalogue"], "ALL_CURRENT_NEW_ERA_STARTERS")
        self.assertTrue(PERSONALITY_GROUND.is_file())
        startup = quiz["startup_non_regression"]
        self.assertFalse(startup["pmdred_quiz_at_new_game"])
        self.assertFalse(startup["pmdred_harness_at_new_game"])
        self.assertEqual(startup["current_activation"], "DORMANT")
        self.assertIn("POST_STARTUP", startup["activation_gate"])
        script = PERSONALITY_SCRIPT.read_text(encoding="utf-8")
        self.assertIn("function personality_test.CharacterSelect()", script)
        self.assertIn("halcyon.menu.character_menu", script)
        self.assertNotIn("pmdred_quiz_flow", script)

    def test_personality_ground_retains_two_layer_opposed_parallax(self) -> None:
        ground = read_json(PERSONALITY_GROUND)["Object"]
        self.assertEqual(ground["Background"]["$type"], "RogueEssence.Dungeon.LayeredBG, RogueEssence")
        layers = ground["Background"]["Layers"]
        self.assertEqual(len(layers), 2)
        observed = []
        for layer in layers:
            bg = layer["BG"]
            observed.append({
                "asset": f"Content/BG/{bg['BGAnim']['AnimIndex']}.dir",
                "alpha": bg["BGAnim"]["Alpha"],
                "movement_x": bg["BGMovement"]["X"],
                "repeat_x": bg["RepeatX"],
            })
        self.assertEqual(observed, self.contract["personality_quiz"]["parallax"]["layers"])
        self.assertEqual([row["movement_x"] for row in observed], [30, -30])
        for row in observed:
            self.assertTrue((ROOT / row["asset"]).is_file())

    def test_canonical_and_new_era_responsibilities_are_explicit(self) -> None:
        split = self.contract["authority_split"]
        self.assertIn("choreography", split["PMD_RED_EU_CANON"])
        self.assertIn("encounter_and_boss_staging", split["PMD_RED_EU_CANON"])
        self.assertIn("starter_catalogue", split["NEW_ERA_ADAPTATION"])
        self.assertIn("metano_town_start", split["NEW_ERA_ADAPTATION"])
        self.assertEqual(
            self.contract["provenance_labels"],
            ["PMD_RED_EU_CANON", "NEW_ERA_ADAPTATION", "NEW_ERA_NATIVE"],
        )
        self.assertFalse(self.contract["dungeons"]["static_boss_appearance_is_sufficient"])

    def test_progress_is_bound_to_the_contract_and_remains_partial(self) -> None:
        self.assertEqual(self.progress["definitive_integration_contract"], str(CONTRACT_PATH.relative_to(ROOT)))
        self.assertEqual(self.progress["definitive_integration_contract_sha256"], sha256(CONTRACT_PATH))
        self.assertFalse(self.progress["architecture"]["parallel_red_campaign"])
        self.assertFalse(self.progress["architecture"]["independent_second_quiz"])
        self.assertEqual(self.progress["summary"]["fully_migrated_scene_count"], 0)
        self.assertEqual(
            self.progress["current_lot"]["result"],
            "PASS_NORMAL_NEW_ERA_STARTUP_RESTORED",
        )
        self.assertFalse(self.progress["current_lot"]["full_quiz_integrated"])
        self.assertFalse(self.progress["personality_quiz"]["production_route_connected"])
        self.assertFalse(self.progress["personality_quiz"]["complete_new_era_starter_handoff_implemented"])
        self.assertFalse(self.progress["personality_quiz"]["complete_new_era_starter_handoff_validated"])
        self.assertFalse(self.progress["personality_quiz"]["complete_new_era_starter_handoff"])


if __name__ == "__main__":
    unittest.main()
