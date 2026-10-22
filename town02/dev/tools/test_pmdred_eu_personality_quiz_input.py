#!/usr/bin/env python3
"""Regressions for the real-PMDO FrameInput personality-quiz gate."""

from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BUILDER = ROOT / "tools/build_pmdred_eu_personality_quiz_input_fixture.py"
RUNTIME = ROOT / "docs/pmdred_eu/narrative_migration/personality_quiz/runtime_input"
INIT = ROOT / "Data/Script/halcyon/ground/personality_test/init.lua"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class PersonalityQuizInputTests(unittest.TestCase):
    def test_fixture_uses_engine_frame_input_not_injected_choice_results(self) -> None:
        source = BUILDER.read_text()
        self.assertIn("RogueEssence.DiagManager", source)
        self.assertIn("ActiveDebugReplay", source)
        self.assertIn("RogueEssence.FrameInput", source)
        self.assertIn("Microsoft.Xna.Framework.Input.Keys", source)
        self.assertIn("self.Keys.Enter", source)
        flow_options = source[source.index("local options={{"):source.index("Flow.PlayCanonicalPrelude(options)")]
        self.assertNotIn("choose=", flow_options)
        self.assertIn("QUIZ_CHOICE_BEGIN", flow_options)

    def test_archived_input_runtime_is_historical_and_integral(self) -> None:
        validation = json.loads((RUNTIME / "validation.json").read_text())
        self.assertEqual(validation["result"], "PHYSICAL_CONFIRM_INPUT_PASS_LIVE_CREATION_PARTIAL")
        self.assertFalse(validation["full_quiz_integrated"])
        self.assertTrue(validation["production_personality_test_routed"])
        self.assertEqual(
            sha256(INIT),
            "e417364941cc7c5e53002f72633b7050b610601eaaa538e903556f1fbd766bac",
        )
        self.assertNotIn("pmdred_quiz_flow", INIT.read_text())
        self.assertEqual(validation["input"]["mechanism"], "RogueEssence.DiagManager.ActiveDebugReplay")
        self.assertEqual(validation["input"]["queued_confirm_pulses"], 74)
        self.assertEqual(validation["input"]["real_begin_choice_menu_count"], 10)
        self.assertEqual(validation["input"]["real_choice_result_count"], 10)
        self.assertEqual(validation["timeline"]["event_count"], 212)
        self.assertEqual(validation["timeline"]["question_answer_count"], 8)
        self.assertIn("directional cursor navigation", validation["not_yet_validated"][0])
        self.assertIn("LIVE_CHARACTER_CREATION", validation["promotion"])
        rows = (RUNTIME / "evidence_hashes.sha256").read_text().splitlines()
        self.assertEqual(len(rows), 6)
        for row in rows:
            expected, relative = row.split("  ", 1)
            self.assertEqual(sha256(RUNTIME / relative), expected)


if __name__ == "__main__":
    unittest.main(verbosity=2)
