#!/usr/bin/env python3
"""Focused regressions for exact PMDO fixture Sheet aliasing."""

from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path

TOOLS = Path(__file__).parent
SPEC = importlib.util.spec_from_file_location(
    "apply_pmdred_eu_fixture_sheet_alias",
    TOOLS / "apply_pmdred_eu_fixture_sheet_alias.py",
)
assert SPEC and SPEC.loader
ALIAS = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = ALIAS
SPEC.loader.exec_module(ALIAS)


class SheetAliasTests(unittest.TestCase):
    def test_alias_changes_only_exact_sheet_values_and_is_reversible(self) -> None:
        source = {
            "Object": {
                "Layers": [{"Tiles": [{"Sheet": "h17p01_Base", "X": 4}]}],
                "Entities": [],
            }
        }
        aliased, count = ALIAS.apply_sheet_alias(
            source, "h17p01_Base", "h17p01_pmdred_Base"
        )
        self.assertEqual(count, 1)
        self.assertEqual(
            aliased["Object"]["Layers"][0]["Tiles"][0]["Sheet"],
            "h17p01_pmdred_Base",
        )
        self.assertEqual(source["Object"]["Layers"][0]["Tiles"][0]["Sheet"], "h17p01_Base")
        normalized, reverse_count = ALIAS.apply_sheet_alias(
            aliased, "h17p01_pmdred_Base", "h17p01_Base"
        )
        self.assertEqual(reverse_count, 1)
        self.assertEqual(normalized, source)

    def test_alias_rejects_name_outside_sheet_field(self) -> None:
        source = {"Object": {"Comment": "h17p01_Base", "Layers": []}}
        with self.assertRaisesRegex(ValueError, "outside an exact Sheet"):
            ALIAS.apply_sheet_alias(source, "h17p01_Base", "h17p01_pmdred_Base")

    def test_alias_rejects_missing_canonical_references(self) -> None:
        with self.assertRaisesRegex(ValueError, "is not referenced"):
            ALIAS.apply_sheet_alias(
                {"Object": {"Layers": []}}, "h17p01_Base", "h17p01_pmdred_Base"
            )

    def test_alias_rejects_unsafe_name(self) -> None:
        source = {"Object": {"Sheet": "h17p01_Base"}}
        with self.assertRaisesRegex(ValueError, "unsafe"):
            ALIAS.apply_sheet_alias(source, "h17p01_Base", "../escape")


if __name__ == "__main__":
    unittest.main()
