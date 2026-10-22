#!/usr/bin/env python3
"""Static gate for the complete, opt-in PMD Red EU s01 continuation.

The normal partial replay remains dependency-gated.  This gate verifies that
its explicit full-scene harness executes the exact source order:
0x22 palette fade-in, SPECIAL_TEXT_PERSONALITY_QUIZ, BGM_FADEOUT, 0x23 palette
fade-out, RET.  It must not connect the path to New Era's normal New Game.
"""
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCENE = ROOT / "Data/Script/halcyon/pmdred_eu/scene/s01.lua"
FLOW = ROOT / "Data/Script/halcyon/ground/personality_test/pmdred_quiz_flow.lua"
INIT = ROOT / "Data/Script/halcyon/ground/personality_test/init.lua"
AUTHORITY = ROOT / "docs/pmdred_eu/narrative_migration/scenes/s01/authority.json"


class S01FullSequence(unittest.TestCase):
    def test_authority_has_the_exact_five_continuation_commands(self):
        authority = json.loads(AUTHORITY.read_text(encoding="utf-8-sig"))
        commands = authority["source_script"]["commands"]
        self.assertEqual([row["op_hex"] for row in commands[11:]], ["0x22", "0x3C", "0x48", "0x23", "0xEF"])
        self.assertEqual([row["arg_short"] for row in commands[11:]], [30, 0, 30, 30, 0])
        self.assertEqual(authority["blocked_source_indices"], [11, 12, 13, 14, 15])

    def test_full_path_is_explicit_and_partial_path_stays_blocked(self):
        scene = SCENE.read_text(encoding="utf-8")
        self.assertIn("if options.execute_personality_quiz then", scene)
        self.assertIn("RAW_OPCODE_0X22_BEGIN", scene)
        self.assertIn("QuizFlow.Run(quiz_options)", scene)
        self.assertIn("QuizFlow.FadeOutCanonical(quiz_options)", scene)
        self.assertIn("SCENE_FULL_COMPLETED", scene)
        self.assertIn("ScenePlayer.Dependency(", scene)
        self.assertIn("SPECIAL_TEXT_PERSONALITY_QUIZ_AND_PALETTE_0x22", scene)
        self.assertNotIn("personality_test.CharacterSelect()", scene)

    def test_full_path_uses_the_existing_integrated_quiz_module(self):
        flow = FLOW.read_text(encoding="utf-8")
        init = INIT.read_text(encoding="utf-8")
        self.assertIn("function QuizFlow.Run(options)", flow)
        self.assertIn("function QuizFlow.FadeOutCanonical(options)", flow)
        # The New Era start route remains the native selector; this test does
        # not allow a hidden call from the new scene module.
        self.assertIn("personality_test.CharacterSelect()", init)
        self.assertNotIn("pmdred_quiz_flow", init)


if __name__ == "__main__":
    unittest.main()
