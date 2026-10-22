#!/usr/bin/env python3
"""Focused tests for exact EU Ground script extraction helpers."""

from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("audit_pmdred_eu_ground_scripts.py")
SPEC = importlib.util.spec_from_file_location("audit_pmdred_eu_ground_scripts", MODULE_PATH)
assert SPEC and SPEC.loader
AUDIT = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = AUDIT
SPEC.loader.exec_module(AUDIT)


class GroundScriptAuditTests(unittest.TestCase):
    def test_candidate_registry_is_complete_and_unique(self) -> None:
        self.assertEqual(len(AUDIT.CANDIDATES), 27)
        self.assertEqual(len({asset for asset, _ in AUDIT.CANDIDATES}), 27)
        self.assertEqual(len({regional for _, regional in AUDIT.CANDIDATES}), 27)
        self.assertEqual(AUDIT.CANDIDATES[0], ("d01p02", 184))
        self.assertEqual(AUDIT.CANDIDATES[-1], ("d25p01", 227))

    def test_committed_report_accounts_for_every_source_declaration(self) -> None:
        report = AUDIT.json.loads(
            (MODULE_PATH.parents[1] / "docs/pmdred_eu/ground_scripts.json").read_text()
        )
        totals = report["totals"]
        self.assertEqual(totals["source_declaration_count"], 267)
        self.assertEqual(totals["owned_command_root_count"], 267)
        self.assertEqual(totals["unowned_source_declaration_count"], 0)
        self.assertEqual(totals["undeclared_eu_command_root_count"], 0)

    def test_late_load_map_id_is_normalized_regionally(self) -> None:
        early = AUDIT.CommandCore(0x08, 0, 0, 100, 0)
        late = AUDIT.CommandCore(0x08, 0, 0, 179, 0)
        unrelated = AUDIT.CommandCore(0x09, 0, 0, 179, 0)
        self.assertEqual(AUDIT.normalized_source_core(early), early)
        self.assertEqual(AUDIT.normalized_source_core(late).arg1, 184)
        self.assertEqual(AUDIT.normalized_source_core(unrelated), unrelated)

    def test_lcs_retains_eu_variant_expansion(self) -> None:
        source = [
            AUDIT.CommandCore(0x08, 0, 0, 179, 0),
            AUDIT.CommandCore(0x34, 0, 1, 0, 0),
            AUDIT.CommandCore(0xF0, 0, 0, 0, 0),
        ]
        eu = [
            AUDIT.CommandCore(0x08, 0, 0, 184, 0),
            AUDIT.CommandCore(0xCF, 2, 40, 1, 0),
            AUDIT.CommandCore(0xD0, 0, 1, 0, 0),
            AUDIT.CommandCore(0xD1, 0, 0, 0, 0),
            AUDIT.CommandCore(0xF0, 0, 0, 0, 0),
        ]
        self.assertEqual(AUDIT.lcs_matches(source, eu), [(0, 0), (2, 4)])

    def test_five_language_text_block_order_and_raw_evidence(self) -> None:
        texts = ["English", "Deutsch", "français", "italiano", "español"]
        payload = b"".join(text.encode("latin-1") + b"\0" for text in texts)
        reader = AUDIT.RomReader(payload)
        block = AUDIT.decode_text_block(reader, AUDIT.ROM_BASE, "fixture")
        self.assertEqual(
            [block["languages"][language]["text"] for language in AUDIT.LANGUAGES],
            texts,
        )
        self.assertEqual(block["languages"]["fr"]["raw_hex"], "français".encode("latin-1").hex())

    def test_source_structure_parser_attaches_ref_command_owner(self) -> None:
        parsed = AUDIT.parse_source_structure([
            ["H", "1", "1"],
            ["G", "0", "1"],
            ["S", "0", "0", "0", "0", "0", "0", "1"],
            ["R", "T", "0", "0", "0", "7", "1", "station_script"],
            ["K", "0", "0102030405060708"],
        ])
        self.assertEqual(parsed["owners"][("T", 0, 0, 0, 0)], "station_script")
        self.assertEqual(parsed["refs"][("T", 0, 0, 0)]["id"], 7)
        self.assertEqual(parsed["links"], ["0102030405060708"])


if __name__ == "__main__":
    unittest.main()
