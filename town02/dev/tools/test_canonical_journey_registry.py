#!/usr/bin/env python3
"""Regression tests for the canonical journey production gate."""
from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class CanonicalJourneyRegistryTests(unittest.TestCase):
    authority: Path

    @classmethod
    def setUpClass(cls):
        cls.authority = Path(AUTHORITY).resolve()

    def command(self, output: Path, report: Path | None = None, lua_output: Path | None = None):
        command = [
            "python3", str(ROOT / "tools/build_canonical_journey_registry.py"),
            "--repo", str(ROOT),
            "--narrative-scope", str(self.authority / "narrative_scope.json"),
            "--progress", str(self.authority / "progress.json"),
            "--contract", str(self.authority / "contract.json"),
            "--ground-audit", str(self.authority / "final_audit.json"),
            "--dungeon-manifest", str(self.authority / "dungeon_manifest.json"),
            "--reminiscencia-manifest", str(self.authority / "remin_manifest.json"),
            "--relict-manifest", str(self.authority / "relict_manifest.json"),
            "--output", str(output),
        ]
        if report is not None:
            command.extend(("--report", str(report)))
        if lua_output is not None:
            command.extend(("--lua-output", str(lua_output)))
        return command

    def test_registry_is_complete_conservative_and_deterministic(self):
        with tempfile.TemporaryDirectory(dir=ROOT / ".runtime-cache") as temp:
            first, second = Path(temp) / "first.json", Path(temp) / "second.json"
            subprocess.run(self.command(first), cwd=ROOT, check=True, capture_output=True)
            subprocess.run(self.command(second), cwd=ROOT, check=True, capture_output=True)
            self.assertEqual(first.read_bytes(), second.read_bytes())
            data = json.loads(first.read_text())
        self.assertEqual(data["result"], "CANONICAL_JOURNEY_REGISTRY_PASS")
        self.assertEqual(data["pmd_red_eu"]["scene_count"], 133)
        self.assertEqual(data["pmd_red_eu"]["dungeon_cutscene_module_count"], 26)
        self.assertEqual(data["pmd_red_eu"]["dungeon_backed_chain_count"], 27)
        self.assertEqual(data["pmd_red_eu"]["production_ready_chain_count"], 0)
        self.assertEqual(data["environment_libraries"]["candidate_count"], 22)
        self.assertEqual(data["environment_libraries"]["reminiscencia_count"], 17)
        self.assertEqual(data["environment_libraries"]["relict_count"], 5)
        self.assertEqual(data["environment_libraries"]["production_ready_count"], 0)
        self.assertEqual(data["production_gate"]["status"], "BLOCKED")
        self.assertTrue(all(not row["forbidden_source_content_imported"] for row in data["environment_libraries"]["candidates"]))
        self.assertTrue(all(set(row["components"]) == set(data["pmd_red_eu"]["required_components"]) for row in data["pmd_red_eu"]["chains"]))
        sinister = data["pmd_red_eu"]["sinister_woods_targeted_gate"]
        self.assertEqual(sinister["result"], "BLOCKED")
        self.assertIn("PROCEDURAL_GRAPHICS_STILL_TREESHROUD_ADAPTATION", sinister["blockers"])
        self.assertIn("RELIC_FOREST_BLOBS_MIXED_INTO_PMD_RED_CHAIN", sinister["blockers"])
        documented_gate = json.loads((ROOT / "docs/canonical_journeys/SINISTER_WOODS_GATE.json").read_text())
        self.assertEqual({key: value for key, value in documented_gate.items() if key != "schema"}, sinister)

    def test_documented_registry_matches_rebuild(self):
        documented = ROOT / "docs/canonical_journeys/CANONICAL_JOURNEY_REGISTRY.json"
        with tempfile.TemporaryDirectory(dir=ROOT / ".runtime-cache") as temp:
            rebuilt = Path(temp) / "registry.json"
            report = Path(temp) / "report.md"
            lua_output = Path(temp) / "registry.lua"
            subprocess.run(self.command(rebuilt, report, lua_output), cwd=ROOT, check=True, capture_output=True)
            self.assertEqual(hashlib.sha256(documented.read_bytes()).hexdigest(), hashlib.sha256(rebuilt.read_bytes()).hexdigest())
            self.assertEqual((ROOT / "docs/canonical_journeys/JOURNEY_STATUS.md").read_bytes(), report.read_bytes())
            self.assertEqual((ROOT / "Data/Script/halcyon/pmdred_eu/CanonicalJourneyRegistry.lua").read_bytes(), lua_output.read_bytes())
            lua = lua_output.read_text()
            self.assertNotIn("EnterDungeon", lua)
            self.assertNotIn("EnterGroundMap", lua)
            self.assertIn("function Registry.AssertReady", lua)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--authority", required=True)
    args, unittest_args = parser.parse_known_args()
    AUTHORITY = args.authority
    unittest.main(argv=[__file__, *unittest_args], verbosity=2)
