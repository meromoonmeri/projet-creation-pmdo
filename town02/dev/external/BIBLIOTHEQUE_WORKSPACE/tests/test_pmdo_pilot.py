#!/usr/bin/env python3
"""Qualification gates for the staged Relict Map 012 PMDO pilot."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

WORKSPACE = Path(__file__).resolve().parents[1]
REPO_ROOT = WORKSPACE.parents[1]
GAME_ROOT = WORKSPACE / "games/relict"
IR_PATH = GAME_ROOT / "conversion/ir/map_012.json"
PILOT_ROOT = GAME_ROOT / "conversion/pmdo_pilot/map_012"
GROUND_PATH = PILOT_ROOT / "Data/Ground/relict_map_012_pilot.rsground"
TILE_PATH = PILOT_ROOT / "Content/Tile/relict_map_012_pilot_Base.tile"
REPORT_PATH = PILOT_ROOT / "reports/conversion_report.json"
TOOLS = WORKSPACE / "tools"
sys.path.insert(0, str(TOOLS))

from build_common_map_ir import validate_ir  # noqa: E402
from convert_map_ir_to_pmdo import read_tile  # noqa: E402
from inventory_relict import sha256_file  # noqa: E402


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


class RelictPMDOPilotTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.ir = load(IR_PATH)
        cls.ground = load(GROUND_PATH)
        cls.obj = cls.ground["Object"]
        cls.report = load(REPORT_PATH)

    def test_01_common_ir_contract_and_source_gate(self):
        validate_ir(self.ir)
        self.assertEqual(self.ir["schema_version"], "1.0.0")
        self.assertEqual(self.ir["status"], "SOURCE_DOCUMENTED")
        self.assertEqual(self.ir["identity"]["game_id"], "relict")
        self.assertEqual(self.ir["identity"]["source_map_id"], 12)
        self.assertFalse(self.ir["target_contract"]["runtime_destination_allowed"])
        self.assertTrue((WORKSPACE / "schemas/map_ir.schema.json").is_file())

    def test_02_ir_normalized_tiles_are_complete_and_hashed(self):
        used = {
            value
            for layer in self.ir["tile_layers"]["layers"]
            for row in layer["rows"]
            for value in row
        }
        catalog = {row["tile_id"]: row for row in self.ir["tile_layers"]["tile_catalog"]}
        self.assertEqual(set(catalog), used)
        self.assertEqual(catalog[0]["frames"], [])
        frame_count = 0
        for tile_id, tile in catalog.items():
            for frame in tile["frames"]:
                path = GAME_ROOT / frame["file"]
                self.assertEqual(sha256_file(path), frame["sha256"], tile_id)
                frame_count += 1
        self.assertEqual(frame_count, 225)

    def test_03_ground_geometry_layers_and_collision_are_exact(self):
        self.assertEqual(self.obj["TexSize"], 4)
        self.assertEqual(len(self.obj["Layers"]), 3)
        self.assertEqual(
            [(len(layer["Tiles"]), len(layer["Tiles"][0])) for layer in self.obj["Layers"]],
            [(35, 33), (35, 33), (35, 33)],
        )
        self.assertEqual((len(self.obj["obstacles"]), len(self.obj["obstacles"][0])), (140, 132))
        masks = self.ir["collision"]["allowed_direction_masks"]
        for x in range(140):
            for y in range(132):
                expected = 1 if masks[y // 4][x // 4] == 0 else 0
                self.assertEqual(self.obj["obstacles"][x][y]["Tags"], expected)
        self.assertEqual(self.report["technical_validation"]["blocked_source_tiles"], 974)
        self.assertEqual(self.report["technical_validation"]["free_source_tiles"], 181)
        self.assertEqual(self.report["technical_validation"]["partial_directional_masks"], [])

    def test_04_pmdo_atlas_and_animation_timing_round_trip(self):
        tile_size, payloads = read_tile(TILE_PATH)
        self.assertEqual(tile_size, 32)
        self.assertEqual(len(payloads), 133)
        self.assertTrue(all(payload.startswith(b"\x89PNG\r\n\x1a\n") for payload in payloads.values()))
        self.assertEqual(self.report["technical_validation"]["animated_catalog_tile_count"], 24)
        self.assertEqual(self.report["technical_validation"]["animation_frame_count"], 192)
        self.assertEqual(self.report["technical_validation"]["animation_durations_ms"], [250])
        self.assertEqual(self.report["technical_validation"]["animation_frame_lengths_pmdo"], [15])

    def test_05_static_visual_validation_is_pixel_exact(self):
        self.assertEqual(self.report["result"], "PMDO_PILOT_STATIC_VALIDATION_PASS")
        self.assertEqual(
            self.report["visual_validation"]["composite_tick_000"]["different_pixels"], 0
        )
        self.assertEqual(
            self.report["visual_validation"]["composite_tick_000"]["max_channel_delta"], 0
        )
        for layer in self.report["visual_validation"]["layers"]:
            self.assertEqual(layer["different_pixels"], 0)
            self.assertEqual(layer["max_channel_delta"], 0)
            self.assertEqual(layer["output_sha256"], layer["expected_sha256"])

    def test_06_forbidden_content_and_runtime_boundaries_hold(self):
        serialized = GROUND_PATH.read_text(encoding="utf-8-sig").casefold()
        for forbidden in ("missingno", "npcchar", "baseform", "graphics/characters"):
            self.assertNotIn(forbidden, serialized)
        checks = self.report["forbidden_content_check"]
        self.assertTrue(all(value is False for value in checks.values()))
        self.assertFalse((REPO_ROOT / "Data/Ground/relict_map_012_pilot.rsground").exists())
        self.assertFalse((REPO_ROOT / "Content/Tile/relict_map_012_pilot_Base.tile").exists())
        self.assertFalse(self.report["runtime_destination_written"])
        self.assertFalse(self.obj["Released"])

    def test_07_status_does_not_overclaim_runtime_validation(self):
        self.assertEqual(self.report["conversion_status"], "PMDO_CONVERTED")
        self.assertEqual(self.report["adaptation_status"], "ADAPTATION_REQUIRED")
        self.assertEqual(self.report["runtime_validation_status"], "NOT_RUN")
        self.assertGreaterEqual(len(self.report["adaptation_required"]), 5)
        self.assertIn(3, self.report["retained_sidecar_semantics"]["terrain_tags"])
        self.assertIn(7, self.report["retained_sidecar_semantics"]["terrain_tags"])

    def test_08_converter_is_reproducible(self):
        with tempfile.TemporaryDirectory(prefix="relict-pmdo-pilot-") as temporary:
            result = subprocess.run(
                [
                    sys.executable,
                    str(TOOLS / "convert_map_ir_to_pmdo.py"),
                    "--ir", str(IR_PATH),
                    "--game-root", str(GAME_ROOT),
                    "--output", temporary,
                ],
                cwd=REPO_ROOT,
                check=True,
                capture_output=True,
                text=True,
            )
            summary = json.loads(result.stdout)
            self.assertEqual(summary["result"], "PMDO_PILOT_STATIC_VALIDATION_PASS")
            regenerated = Path(temporary)
            self.assertEqual(
                sha256_file(regenerated / "Data/Ground/relict_map_012_pilot.rsground"),
                sha256_file(GROUND_PATH),
            )
            self.assertEqual(
                sha256_file(regenerated / "Content/Tile/relict_map_012_pilot_Base.tile"),
                sha256_file(TILE_PATH),
            )
            regenerated_report = load(regenerated / "reports/conversion_report.json")
            self.assertEqual(regenerated_report, self.report)

    def test_09_exact_pmdo_runtime_evidence_passes(self):
        runtime_root = PILOT_ROOT / "runtime"
        runtime = load(runtime_root / "runtime_report.json")
        self.assertEqual(runtime["result"], "PMDO_RUNTIME_VALIDATION_PASS")
        self.assertEqual(runtime["validation_status"], "PMDO_VALIDATED")
        self.assertEqual(runtime["adaptation_status"], "ADAPTATION_REQUIRED")
        self.assertEqual(runtime["authority"]["pmdo_version"], "0.8.12")
        self.assertEqual(
            runtime["authority"]["pmdo_sha256"],
            "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327",
        )
        self.assertTrue(all(value == "PASS" for value in runtime["runtime_probes"].values()))
        samples = runtime["visual_validation"]["samples"]
        self.assertEqual([sample["pmdo_tick"] for sample in samples], [0, 15])
        self.assertNotEqual(
            samples[0]["environment_evidence_sha256"],
            samples[1]["environment_evidence_sha256"],
        )
        for sample in samples:
            self.assertEqual(sample["environment_different_pixel_count"], 0)
            self.assertEqual(sample["environment_max_channel_delta"], 0)
            self.assertEqual(sample["actor_excluded_pixel_count"], 200)
            self.assertFalse(sample["raw_runtime_pixels_exported"])
            self.assertEqual(
                sample["environment_evidence_sha256"], sample["expected_sha256"]
            )
        self.assertTrue(all(value is False for value in runtime["forbidden_content_check"].values()))


if __name__ == "__main__":  # pragma: no cover
    unittest.main(verbosity=2)
