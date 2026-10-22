#!/usr/bin/env python3
"""Regression tests for the create-only narrative migration guard."""

from __future__ import annotations

import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path

TOOLS = Path(__file__).parent
SPEC = importlib.util.spec_from_file_location(
    "verify_pmdred_eu_narrative_migration_guard",
    TOOLS / "verify_pmdred_eu_narrative_migration_guard.py",
)
assert SPEC and SPEC.loader
GUARD = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = GUARD
SPEC.loader.exec_module(GUARD)


class NarrativeMigrationGuardTests(unittest.TestCase):
    def test_duplicate_paths_require_the_same_hash(self) -> None:
        rows = [
            {"path": "same", "sha256": "a", "role": "first"},
            {"path": "same", "sha256": "a", "role": "second"},
        ]
        self.assertEqual(len(GUARD.unique_rows(rows)), 1)
        rows[1]["sha256"] = "b"
        with self.assertRaisesRegex(ValueError, "conflicting baseline hash"):
            GUARD.unique_rows(rows)

    def test_verify_reports_drift_without_modifying_the_file(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            protected = root / "protected.lua"
            protected.write_text("original\n", encoding="utf-8")
            digest = GUARD.sha256_file(protected)
            baseline = {
                "schema": GUARD.SCHEMA,
                "qualified_ground_destinations": [
                    {"path": "protected.lua", "sha256": digest, "role": "ground"}
                ],
                "chapter_1_to_5_files": [],
                "historical_integration_files": [],
            }
            self.assertEqual(GUARD.verify_baseline(root, baseline), [])
            protected.write_text("changed\n", encoding="utf-8")
            failures = GUARD.verify_baseline(root, baseline)
            self.assertEqual(len(failures), 1)
            self.assertEqual(failures[0]["reason"], "sha256_mismatch")
            self.assertEqual(protected.read_text(encoding="utf-8"), "changed\n")


if __name__ == "__main__":
    unittest.main()
