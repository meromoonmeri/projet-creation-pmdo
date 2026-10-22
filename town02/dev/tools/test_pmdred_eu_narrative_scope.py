#!/usr/bin/env python3
"""Focused regressions for the read-only narrative-scope auditor."""

from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path

TOOLS = Path(__file__).parent
SPEC = importlib.util.spec_from_file_location(
    "audit_pmdred_eu_narrative_scope", TOOLS / "audit_pmdred_eu_narrative_scope.py"
)
assert SPEC and SPEC.loader
AUDIT = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = AUDIT
SPEC.loader.exec_module(AUDIT)


class NarrativeScopeAuditTests(unittest.TestCase):
    def test_lua_comments_are_not_counted_as_execution(self) -> None:
        text = """-- GROUND:MoveToPosition(actor, 8, 8, false, 1)
GAME:WaitFrames(10)
UI:WaitShowDialogue(\"bonjour\")
"""
        domains = AUDIT.new_domains(text)
        self.assertEqual(domains["movement_path"], 0)
        self.assertEqual(domains["timing_sync"], 2)  # WaitFrames + dialogue wait
        self.assertEqual(domains["dialogue"], 1)

    def test_source_domains_keep_choreography_separate(self) -> None:
        macros = AUDIT.macro_calls(
            "WALK_GRID(256, 0), ROTATE_TO(4, 11, 2), CAMERA_PAN(256, 4), "
            "WAIT(30), ALERT_CUE(3), MSG_NPC(1, _(\"x\")), BGM_SWITCH(7),"
        )
        domains = AUDIT.source_domains(macros, effect_count=2)
        self.assertEqual(domains["movement_path"], 1)
        self.assertEqual(domains["orientation"], 1)
        self.assertEqual(domains["camera"], 1)
        self.assertEqual(domains["timing_sync"], 2)
        self.assertEqual(domains["dialogue"], 1)
        self.assertEqual(domains["audio"], 1)
        self.assertEqual(domains["vfx_transition"], 2)

    def test_action_index_redacts_text_but_retains_arguments(self) -> None:
        value = AUDIT.redact_action('MSG_NPC(1, _("Texte secret"))')
        self.assertNotIn("Texte secret", value)
        self.assertIn("TEXT_SHA256", value)
        self.assertIn("MSG_NPC(1", value)

    def test_central_scene_extraction(self) -> None:
        scenes = AUDIT.extract_central_scenes(
            "X = {\n  first = function()\nGAME:WaitFrames(1)\n  end,\n"
            "  second = function()\nGAME:WaitFrames(2)\n  end,\n}\n"
        )
        self.assertEqual(set(scenes), {"first", "second"})
        self.assertIn("WaitFrames(1)", scenes["first"])
        self.assertIn("WaitFrames(2)", scenes["second"])

    def test_domain_status_never_calls_unproven_execution_conserved(self) -> None:
        self.assertEqual(AUDIT.domain_status(4, 0), ["PORTÉ"])
        self.assertEqual(AUDIT.domain_status(4, 2), ["ADAPTÉ"])
        self.assertEqual(AUDIT.domain_status(0, 2), ["ADAPTÉ"])
        self.assertEqual(AUDIT.domain_status(0, 0), ["CONSERVÉ"])

    def test_scene_receives_one_primary_classification_with_explicit_priority(self) -> None:
        classify = AUDIT.primary_scene_classification
        self.assertEqual(classify(routed=True, has_new_era_module=False, has_exact_eu_graph=False)[0], "CONFLIT")
        self.assertEqual(classify(routed=False, has_new_era_module=False, has_exact_eu_graph=False)[0], "PORTÉ")
        self.assertEqual(classify(routed=False, has_new_era_module=True, has_exact_eu_graph=False)[0], "DÉPENDANCE")
        self.assertEqual(classify(routed=False, has_new_era_module=True, has_exact_eu_graph=True)[0], "ADAPTÉ")


if __name__ == "__main__":
    unittest.main()
