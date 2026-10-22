#!/usr/bin/env python3
"""Qualification gates for all 552 Reminiscencia PMDO-target PNGs."""

from __future__ import annotations

import json
import sys
import unittest
from pathlib import Path

WORKSPACE = Path(__file__).resolve().parents[1]
GAME = WORKSPACE / "games/reminiscencia"
OUTPUT = GAME / "conversion/pmdo_renders"
MANIFEST = OUTPUT / "manifest.json"
EXPECTED_ARCHIVE_SHA = "cf74db06c2c06b36cdd88c3139ab8c123b932269c34e7b0f10349f05e475be08"
sys.path.insert(0, str(WORKSPACE / "tools"))

from inventory_relict import sha256_file  # noqa: E402
from png_rgba import load_png  # noqa: E402


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


class ReminiscenciaRendersTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = load(MANIFEST)
        cls.by_id = {row["map_id"]: row for row in cls.manifest["renders"]}

    def test_01_archive_identity_and_inventory_are_exact(self):
        metadata = load(GAME / "metadata/source_archive.json")
        self.assertEqual(metadata["verified_sha256"], EXPECTED_ARCHIVE_SHA)
        self.assertEqual(metadata["verified_size_bytes"], 341630283)
        self.assertEqual(metadata["acquisition_status"], "LFS_OBJECT_MATERIALIZED_AND_HASH_VERIFIED")
        self.assertFalse(metadata["source_code_executed"])
        self.assertFalse(metadata["raw_archive_tracked_in_new_era"])
        zips = [path.relative_to(GAME).as_posix() for path in GAME.rglob("*.zip")]
        self.assertEqual(zips, ["conversion/pmdo_candidates/reminiscencia_grounds.zip"])
        self.assertNotIn("ReminiscenciaV2_3.zip", zips)

    def test_02_every_map_has_one_hashed_png_at_source_dimensions(self):
        self.assertEqual(self.manifest["map_count"], 552)
        self.assertEqual(set(self.by_id), set(range(1, 553)))
        for map_id, row in self.by_id.items():
            path = OUTPUT / row["file"]
            self.assertTrue(path.is_file(), map_id)
            self.assertEqual(path.read_bytes()[:8], b"\x89PNG\r\n\x1a\n")
            self.assertEqual(sha256_file(path), row["sha256"])
            image = load_png(path)
            self.assertEqual((image.width, image.height), (row["width_px"], row["height_px"]))
            self.assertEqual(row["width_px"], row["width_tiles"] * 32)
            self.assertEqual(row["height_px"], row["height_tiles"] * 32)
            self.assertEqual(row["layer_count"], 3)
            self.assertEqual(row["pmdo_target_tex_size"], 4)
            self.assertFalse(row["actor_pixels_exported"])

    def test_03_complete_review_and_exclusion_counts_do_not_overclaim(self):
        self.assertEqual(self.manifest["result"], "RMXP_ARCHIVE_PMDO_RENDER_REVIEW_REQUIRED")
        self.assertEqual(self.manifest["status"], "ADAPTATION_REQUIRED")
        self.assertEqual(self.manifest["complete_environmental_render_count"], 522)
        self.assertEqual(self.manifest["missing_tile_map_count"], 29)
        self.assertEqual(self.manifest["excluded_visual_scene_count"], 1)
        expected_review = {
            325, 469, 515, 517, 518, 519, 520, 521, 522, 523, 524, 525,
            526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 537, 538,
            539, 548, 549, 550, 551,
        }
        self.assertEqual({row["map_id"] for row in self.manifest["missing_tiles"]}, expected_review)

    def test_04_casting_or_ui_baked_scene_is_redacted(self):
        exclusions = self.manifest["excluded_visual_scenes"]
        self.assertEqual(exclusions, [{
            "map_id": 463,
            "reason": "CASTING_OR_UI_BAKED_TILE_SCENE",
            "source_pixels_exported": False,
        }])
        row = self.by_id[463]
        self.assertFalse(row["source_pixels_exported"])
        self.assertEqual(row["excluded_visual_scene"], "CASTING_OR_UI_BAKED_TILE_SCENE")
        self.assertEqual(row["tileset_name"], "REDACTED")
        self.assertEqual(
            row["sha256"], "4d3e960cbeb74d49227e4bfdbacba7ae20ff8c44bdc070d9f0865d59f89b9ec3"
        )
        self.assertTrue(all(
            candidate["source_pixels_exported"]
            for map_id, candidate in self.by_id.items() if map_id != 463
        ))

    def test_05_global_and_paginated_contact_sheets_cover_every_map(self):
        contact = self.manifest["contact_sheet"]
        self.assertEqual(sha256_file(OUTPUT / contact["file"]), contact["sha256"])
        self.assertEqual((contact["width_px"], contact["height_px"]), (1120, 18648))
        pages = self.manifest["contact_pages"]
        self.assertEqual(len(pages), 12)
        self.assertEqual(sum(page["render_count"] for page in pages), 552)
        self.assertEqual((pages[0]["first_map_id"], pages[0]["last_map_id"]), (1, 50))
        self.assertEqual((pages[-1]["first_map_id"], pages[-1]["last_map_id"]), (551, 552))
        for page in pages:
            path = OUTPUT / page["file"]
            self.assertEqual(sha256_file(path), page["sha256"])
            self.assertEqual((page["width_px"], page["height_px"]), (1120, 1680))

    def test_06_only_environmental_derived_outputs_are_tracked(self):
        allowed = {".png", ".json"}
        files = [path for path in OUTPUT.rglob("*") if path.is_file()]
        self.assertEqual(len([path for path in files if path.parent == OUTPUT / "maps"]), 552)
        self.assertTrue(all(path.suffix in allowed for path in files))
        self.assertFalse(any("Audio" in path.parts or "Characters" in path.parts for path in files))
        self.assertFalse(self.manifest["source"]["source_code_executed"])
        self.assertFalse(self.manifest["source"]["actor_pixels_exported"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
