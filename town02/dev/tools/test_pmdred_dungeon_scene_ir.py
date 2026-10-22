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


class DungeonSceneIRTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.authority = Path(AUTHORITY).resolve()

    def command(self, output):
        return [
            "python3", str(ROOT / "tools/build_pmdred_dungeon_scene_ir.py"),
            "--source-actions", str(self.authority / "source_action_index.json"),
            "--narrative-scope", str(self.authority / "narrative_scope.json"),
            "--dungeon-manifest", str(self.authority / "dungeon_manifest.json"),
            "--output", str(output),
        ]

    def test_all_dungeon_actions_are_preserved_and_fail_closed(self):
        documented = ROOT / "docs/canonical_journeys/PMD_RED_DUNGEON_SCENE_IR.json"
        with tempfile.TemporaryDirectory(dir=ROOT / ".runtime-cache") as temp:
            first, second = Path(temp) / "a.json", Path(temp) / "b.json"
            subprocess.run(self.command(first), cwd=ROOT, check=True, capture_output=True)
            subprocess.run(self.command(second), cwd=ROOT, check=True, capture_output=True)
            self.assertEqual(first.read_bytes(), second.read_bytes())
            self.assertEqual(hashlib.sha256(documented.read_bytes()).hexdigest(), hashlib.sha256(first.read_bytes()).hexdigest())
            data = json.loads(first.read_text())
        self.assertEqual(data["result"], "PMD_RED_DUNGEON_SCENE_IR_PASS")
        self.assertEqual(data["asset_count"], 27)
        self.assertEqual(data["script_array_count"], 267)
        self.assertEqual(data["action_count"], 4967)
        self.assertEqual(data["unknown_action_count"], 712)
        self.assertEqual(data["adapter_proven_action_count"], 782)
        self.assertEqual(data["adapter_status_action_counts"], {
            "ADAPTER_PROVEN": 782,
            "MAPPING_REQUIRED": 3484,
            "UNMAPPED_PRESERVED": 701,
        })
        self.assertEqual(data["runtime_ready_asset_count"], 0)
        self.assertEqual(data["production_route_count"], 0)
        self.assertEqual(len({row["asset"] for row in data["assets"]}), 27)
        for asset in data["assets"]:
            self.assertFalse(asset["runtime_ready"])
            self.assertFalse(asset["production_route_written"])
            self.assertEqual([row["sequence"] for row in asset["script_arrays"]], list(range(asset["script_array_count"])))
            for array in asset["script_arrays"]:
                self.assertEqual([row["sequence"] for row in array["actions"]], list(range(array["action_count"])))
                for action in array["actions"]:
                    if action["kind"] in {"WAIT", "BGM_FADEOUT", "SET_DIR_WAIT", "ROTATE_TO", "CMD_UNK_92"}:
                        self.assertEqual(action["adapter_status"], "ADAPTER_PROVEN")
                        self.assertIn("operands", action)
                        if action["kind"] == "ROTATE_TO":
                            self.assertGreater(action["operands"]["step_frames"], 0)
                            self.assertIn(action["operands"]["transition"], {
                                "DIR_TRANS_SPINRIGHT1", "DIR_TRANS_SPINLEFT1", "DIR_TRANS_10", "DIR_TRANS_11",
                            })
                            self.assertIn("direction", action["operands"])
                        elif action["kind"] == "CMD_UNK_92":
                            self.assertGreater(action["operands"]["step_frames"], 0)
                            self.assertIn(action["operands"]["turn_step"], {1, 2})
                            self.assertIn(action["operands"]["target_transform"], {
                                "DIR_TRANS_SPINRIGHT2", "DIR_TRANS_SPINLEFT2", "DIR_TRANS_FLIP",
                            })
                        else:
                            self.assertIsInstance(action["operands"]["frames"], int)
                            self.assertGreaterEqual(action["operands"]["frames"], 0)
                            if action["kind"] == "SET_DIR_WAIT":
                                self.assertIn("direction", action["operands"])
                    elif action["kind"].startswith(("RAW_OPCODE_", "CMD_UNK_", "CJUMP_UNK_")):
                        self.assertEqual(action["adapter_status"], "UNMAPPED_PRESERVED")
                        self.assertNotIn("operands", action)
                    else:
                        self.assertEqual(action["adapter_status"], "MAPPING_REQUIRED")
                        self.assertNotIn("operands", action)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--authority", required=True)
    args, remaining = parser.parse_known_args()
    AUTHORITY = args.authority
    unittest.main(argv=[__file__, *remaining], verbosity=2)
