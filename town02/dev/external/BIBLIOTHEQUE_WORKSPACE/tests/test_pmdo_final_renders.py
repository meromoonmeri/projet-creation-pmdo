#!/usr/bin/env python3
"""Gates for the 34 assembled Relict PMDO-target PNG renders."""

from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

WORKSPACE = Path(__file__).resolve().parents[1]
REPO_ROOT = WORKSPACE.parents[1]
TOOLS = WORKSPACE / "tools"
GAME_ROOT = WORKSPACE / "games/relict"
OUTPUT = GAME_ROOT / "conversion/pmdo_renders"
SOURCE = REPO_ROOT / "external/BIBLIOTHEQUE/Relict/Relict V1.2/Relict"
sys.path.insert(0, str(TOOLS))

from inventory_relict import sha256_file  # noqa: E402
from png_rgba import load_png  # noqa: E402
from render_pmdo_final_maps import build  # noqa: E402


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


class PMDOFinalRendersTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = load(OUTPUT / "manifest.json")

    def test_01_all_canonical_maps_and_divergent_variants_are_rendered(self):
        self.assertEqual(self.manifest["result"], "PMDO_FINAL_RENDER_PASS")
        self.assertEqual(self.manifest["render_count"], 34)
        self.assertEqual(self.manifest["canonical_map_count"], 28)
        self.assertEqual(self.manifest["divergent_variant_count"], 6)
        ids = [row["preview_id"] for row in self.manifest["renders"]]
        self.assertEqual(len(ids), len(set(ids)))
        self.assertEqual(ids[0], "map_001")
        self.assertEqual(ids[-1], "map_028")

    def test_02_every_png_matches_declared_geometry_and_hash(self):
        for row in self.manifest["renders"]:
            path = OUTPUT / row["file"]
            self.assertEqual(path.read_bytes()[:8], b"\x89PNG\r\n\x1a\n")
            self.assertEqual(sha256_file(path), row["sha256"])
            image = load_png(path)
            self.assertEqual((image.width, image.height), (row["width_px"], row["height_px"]))
            self.assertEqual(row["source_layer_count"], 3)
            self.assertEqual(row["pmdo_target_pitch_px"], 32)
            self.assertEqual(row["pmdo_target_tex_size"], 4)
            self.assertFalse(row["actor_pixels_exported"])

    def test_03_pilot_map_matches_exact_runtime_validated_tick_zero(self):
        final = OUTPUT / "maps/map_012.png"
        pilot = GAME_ROOT / "conversion/pmdo_pilot/map_012/runtime/environment_tick_000.png"
        self.assertEqual(sha256_file(final), sha256_file(pilot))

    def test_04_environmental_assembly_is_present_where_documented(self):
        by_id = {row["preview_id"]: row for row in self.manifest["renders"]}
        self.assertEqual(by_id["map_016"]["panorama_count"], 1)
        self.assertEqual(by_id["map_016"]["screen_vfx_count"], 2)
        self.assertEqual(by_id["map_017"]["screen_vfx_count"], 2)
        self.assertEqual(by_id["map_017"]["visible_environmental_tile_entity_count"], 1)
        self.assertEqual(by_id["map_019"]["visible_environmental_tile_entity_count"], 1)
        self.assertEqual(by_id["map_028"]["panorama_count"], 1)

    def test_05_contact_sheet_is_complete_and_labeled(self):
        contact = self.manifest["contact_sheet"]
        path = OUTPUT / contact["file"]
        self.assertEqual(sha256_file(path), contact["sha256"])
        image = load_png(path)
        self.assertEqual((image.width, image.height), (1120, 1176))
        self.assertEqual(contact["columns"], 5)
        self.assertIn("A=2025", contact["label_policy"])

    def test_06_batch_renderer_is_byte_reproducible(self):
        with tempfile.TemporaryDirectory(prefix="relict-pmdo-renders-") as temporary:
            regenerated = Path(temporary)
            result = build(SOURCE, GAME_ROOT, regenerated)
            self.assertEqual(result, self.manifest)
            for row in self.manifest["renders"]:
                self.assertEqual(
                    sha256_file(regenerated / row["file"]),
                    sha256_file(OUTPUT / row["file"]),
                )
            self.assertEqual(
                sha256_file(regenerated / "contact_sheet.png"),
                sha256_file(OUTPUT / "contact_sheet.png"),
            )


if __name__ == "__main__":
    unittest.main(verbosity=2)
