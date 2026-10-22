#!/usr/bin/env python3
"""Focused regressions for the 133-station EU evidence wrapper."""

from __future__ import annotations

import hashlib
import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import audit_pmdred_eu_all_ground_scripts as audit_tool


class AllGroundScriptAuditTests(unittest.TestCase):
    def test_compiler_object_paths_are_stable(self) -> None:
        first = audit_tool.normalize_technical_gap(
            RuntimeError("ld: /tmp/ccAbC123.o:(.data+0x8): undefined reference")
        )
        second = audit_tool.normalize_technical_gap(
            RuntimeError("ld: /tmp/ccZZ9x.o:(.data+0x8): undefined reference")
        )
        self.assertEqual(first, second)
        self.assertIn("/tmp/cc<OBJECT>.o", first)

    def test_retained_gap_is_a_dependency_not_a_false_pass(self) -> None:
        rom = b"test-rom"
        failure = audit_tool.AuditError(
            "h01p01: /tmp/ccRandom77.o: undefined reference to gFunctionScriptTable"
        )
        with tempfile.TemporaryDirectory() as temp:
            pret_root = Path(temp)
            (pret_root / "include").mkdir()
            (pret_root / "include/data_script.h").touch()
            with (
                mock.patch.object(audit_tool, "EXPECTED_ROM_SIZE", len(rom)),
                mock.patch.object(audit_tool, "EXPECTED_ROM_SHA256", hashlib.sha256(rom).hexdigest()),
                mock.patch.object(audit_tool, "compile_source_reference", side_effect=failure),
            ):
                report = audit_tool.audit(
                    rom,
                    pret_root,
                    "cc",
                    "authority.gba",
                    candidates_to_audit=(("h01p01", 42),),
                    allow_technical_gaps=True,
                )
        self.assertEqual(report["validation"]["status"], "dependency")
        self.assertEqual(report["candidate_count"], 0)
        self.assertEqual(report["requested_candidate_count"], 1)
        self.assertEqual(report["validation"]["technical_gap_count"], 1)
        self.assertIn("/tmp/cc<OBJECT>.o", report["technical_gaps"][0]["error"])

    def test_manifest_discovery_is_ordered_and_excludes_non_eu(self) -> None:
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            headers = root / "pret/src/data/ground"
            headers.mkdir(parents=True)
            entries = []
            for map_id in range(133):
                asset = f"x{map_id:03d}"
                (headers / f"ground_data_{asset}_station.h").touch()
                entries.append({"stable_ground_id": asset, "map_id": map_id})
            (headers / "ground_data_us_only_station.h").touch()
            manifest = root / "manifest.json"
            manifest.write_text(
                json.dumps({"ground_conversion_table": {"entries": entries}}),
                encoding="utf-8",
            )
            discovered = audit_tool.discover_all_station_candidates(root / "pret", manifest)
        self.assertEqual(len(discovered), 133)
        self.assertEqual(discovered[0], ("x000", 0))
        self.assertEqual(discovered[-1], ("x132", 132))
        self.assertNotIn(("us_only", 0), discovered)


if __name__ == "__main__":
    unittest.main()
