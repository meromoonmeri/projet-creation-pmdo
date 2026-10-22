#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROVEN = {"WAIT", "BGM_FADEOUT", "SET_DIR_WAIT", "ROTATE_TO", "CMD_UNK_92"}


class OpcodeRegistryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.authority = Path(AUTHORITY).resolve()
        cls.pret_root = Path(PRET_ROOT).resolve()
        cls.rogue_root = Path(ROGUE_ROOT).resolve()
        cls.pmdo_pdb = Path(PMDO_PDB).resolve()

    def command(self, output: Path) -> list[str]:
        return [
            "python3", str(ROOT / "tools/build_pmdred_opcode_registry.py"),
            "--source-actions", str(self.authority / "source_action_index.json"),
            "--narrative-scope", str(self.authority / "narrative_scope.json"),
            "--pret-root", str(self.pret_root),
            "--rogue-root", str(self.rogue_root),
            "--pmdo-pdb", str(self.pmdo_pdb),
            "--output", str(output),
        ]

    def test_registry_is_deterministic_complete_and_fail_closed(self):
        documented = ROOT / "docs/canonical_journeys/PMD_RED_OPCODE_REGISTRY.json"
        with tempfile.TemporaryDirectory(dir=ROOT / ".runtime-cache") as temp:
            first, second = Path(temp) / "a.json", Path(temp) / "b.json"
            subprocess.run(self.command(first), cwd=ROOT, check=True, capture_output=True)
            subprocess.run(self.command(second), cwd=ROOT, check=True, capture_output=True)
            self.assertEqual(first.read_bytes(), second.read_bytes())
            self.assertEqual(
                hashlib.sha256(documented.read_bytes()).hexdigest(),
                hashlib.sha256(first.read_bytes()).hexdigest(),
            )
            raw = first.read_text(encoding="utf-8")
            data = json.loads(raw)

        self.assertNotIn(".runtime-cache", raw)
        self.assertEqual(data["result"], "PMD_RED_OPCODE_REGISTRY_PASS")
        self.assertEqual(data["asset_count"], 27)
        self.assertEqual(data["action_kind_count"], 88)
        self.assertEqual(data["action_count"], 4967)
        self.assertEqual(data["adapter_proven_kind_count"], 5)
        self.assertEqual(data["adapter_proven_action_count"], 782)
        self.assertEqual(data["runtime_ready_kind_count"], 0)
        self.assertEqual(data["runtime_ready_asset_count"], 0)
        self.assertEqual(data["production_route_count"], 0)
        self.assertEqual(
            data["authority"]["pmdo_0_8_12"]["pdb_sourcelink_rogue_essence_commit"],
            data["authority"]["pmdo_0_8_12"]["rogue_essence_commit"],
        )
        self.assertIn("numeric casts are forbidden", data["direction_mapping"]["rule"])

        entries = {entry["kind"]: entry for entry in data["entries"]}
        self.assertEqual(len(entries), 88)
        self.assertEqual({kind for kind, entry in entries.items() if entry["adapter_status"] == "ADAPTER_PROVEN"}, PROVEN)
        self.assertEqual(sum(entry["occurrence_count"] for entry in entries.values()), 4967)
        for kind, entry in entries.items():
            self.assertFalse(entry["runtime_ready"])
            self.assertTrue(entry["source_proof"]["executor"]["case_lines"])
            if kind.startswith("RAW_OPCODE_"):
                self.assertIsNone(entry["source_macro"])
                self.assertNotEqual(entry["adapter_status"], "ADAPTER_PROVEN")
            if kind in PROVEN:
                self.assertIn("proved_adapter", entry)
                self.assertTrue(entry["proved_adapter"]["pmdo_calls"])
                self.assertTrue(entry["pmdo_api_candidates"])

    def test_registry_covers_the_published_scene_ir_exactly(self):
        registry = json.loads((ROOT / "docs/canonical_journeys/PMD_RED_OPCODE_REGISTRY.json").read_text())
        scene_ir = json.loads((ROOT / "docs/canonical_journeys/PMD_RED_DUNGEON_SCENE_IR.json").read_text())
        registry_counts = {entry["kind"]: entry["occurrence_count"] for entry in registry["entries"]}
        self.assertEqual(registry_counts, scene_ir["action_kind_counts"])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--authority", required=True)
    parser.add_argument("--pret-root", required=True)
    parser.add_argument("--rogue-root", required=True)
    parser.add_argument("--pmdo-pdb", required=True)
    args, remaining = parser.parse_known_args()
    AUTHORITY = args.authority
    PRET_ROOT = args.pret_root
    ROGUE_ROOT = args.rogue_root
    PMDO_PDB = args.pmdo_pdb
    unittest.main(argv=[__file__, *remaining], verbosity=2)
