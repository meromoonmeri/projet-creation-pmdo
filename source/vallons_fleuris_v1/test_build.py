#!/usr/bin/env python3
"""Tests structurels des restitutions FVF1/EVF1 et de leur provenance native."""
from __future__ import annotations

import json
import sys
import unittest
import zipfile
from pathlib import Path
from xml.etree import ElementTree as ET

import numpy as np
from PIL import Image
from scipy import ndimage as nd

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from source.vallons_fleuris_v1 import build as build_module  # noqa: E402

CASES = {
    "FVF1": "fin_vallon_fleuri_sanctuaire_v1",
    "EVF1": "entree_vallon_fleuri_sud_nord_v1",
}


class VallonsFleurisBuildTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.assertTrue((ROOT / "apercu_vallons_fleuris_v1.html").is_file(), "Exécuter build.py d'abord")
        cls.river_assets = build_module.native_metano_river_tiles()

    def load(self, code, rel):
        slug = CASES[code]
        with Image.open(ROOT / "renders" / slug / rel) as im:
            return im.copy()

    def manifest(self, code):
        return json.loads((ROOT / "renders" / CASES[code] / "manifest.json").read_text())

    def water_frames(self, code):
        manifest = self.manifest(code)
        return [Image.open(ROOT / path).convert("RGBA") for path in manifest["water"]["output_frame_paths"]]

    def test_canvas_provenance_and_explicit_animation_status(self):
        for code in CASES:
            with self.subTest(code=code):
                manifest = self.manifest(code)
                self.assertEqual(manifest["canvas_px"], [768, 576])
                self.assertEqual(manifest["grid_8px"], [96, 72])
                self.assertFalse(manifest["art_approved"])
                self.assertFalse(manifest["runtime_tested"])
                self.assertFalse(manifest["canonical_flower_frames_verified"])

                water = manifest["water"]
                self.assertEqual(water["source_sheets"], [
                    f"Metano_Town_River_Animation_{i}" for i in range(1, 5)
                ])
                self.assertEqual(water["source_active_river_cells"], 3200)
                self.assertEqual(water["source_opaque_water_cells"], 2365)
                self.assertEqual(water["source_animated_opaque_water_cells"], 477)
                self.assertEqual(water["source_unique_animated_opaque_sequences"], 361)
                self.assertEqual(water["source_opaque_non_surface_cells_excluded"], 85)
                self.assertEqual(water["source_shoreline_cells"], 750)
                self.assertEqual(water["source_animated_shoreline_cells"], 656)
                self.assertEqual(water["source_unique_shoreline_sequences"], 566)
                self.assertEqual(water["source_unique_animated_shoreline_sequences"], 507)
                self.assertEqual(water["source_unique_shoreline_alpha_patterns"], 278)
                self.assertEqual(water["surface_patch"]["source_texloc_top_left_xy_cells"], [128, 4])
                self.assertEqual(water["surface_patch"]["source_grid_cells"], [8, 8])
                self.assertEqual(water["surface_patch"]["size_px"], [64, 64])
                self.assertEqual(water["surface_patch"]["phase_changed_pixels_vs_1"], [4, 5, 11])
                self.assertLessEqual(max(water["surface_patch"]["repeat_edge_mean_abs_rgb_difference_per_phase"]), 2.0)
                self.assertEqual(water["frame_count"], 4)
                self.assertEqual(water["frame_length_ticks"], 10)
                self.assertEqual(water["phase_order"], [1, 2, 3, 4])
                self.assertTrue(water["native_pixels_unchanged"])
                self.assertFalse(water["canonical_metano_layout_claim"])

                flowers = manifest["flowers"]
                self.assertEqual(flowers["status"], "official_frames_missing")
                self.assertFalse(flowers["animation_applied"])
                self.assertFalse(flowers["synthetic_fallback"])
                self.assertTrue(flowers["original_generated_flower_art_preserved_static"])
                self.assertIn("2cwdrrs469f61.gif", flowers["request"])
                self.assertEqual(flowers["animated_count"], 0)

    def test_native_water_frames_animate_both_surface_and_shoreline(self):
        for code in CASES:
            with self.subTest(code=code):
                manifest = self.manifest(code)
                water_record = manifest["water"]
                water = np.asarray(self.load(code, "masks/masque_eau.png").convert("L")) > 0
                frames = [np.asarray(frame) for frame in self.water_frames(code)]
                self.assertEqual(len(frames), 4)
                self.assertGreater(int(water.sum()), 10000)
                for rgba in frames:
                    self.assertEqual(rgba.shape, (576, 768, 4))
                    self.assertTrue(np.array_equal(rgba[:, :, 3] > 0, water))
                    self.assertGreaterEqual(len(np.unique(rgba[water, :3], axis=0)), 6)
                    self.assertFalse(np.any(rgba[~water, 3]))
                differences = [int((np.any(frames[0] != frame, axis=2) & water).sum())
                               for frame in frames[1:]]
                self.assertEqual(differences, water_record["output_phase_changed_pixels_vs_1"])
                self.assertTrue(all(value > int(water.sum() * 0.05) for value in differences))

                # The edge modules themselves must change in every transition, not just
                # the repeated surface patch or the separate sparkle layer.
                shoreline_differences = water_record["output_shoreline_phase_changed_pixels_vs_1"]
                self.assertEqual(len(shoreline_differences), 3)
                self.assertTrue(all(value > 2000 for value in shoreline_differences), shoreline_differences)
                self.assertGreater(water_record["output_shoreline_cells"], 100)

    def test_surface_patch_and_matched_native_shoreline_are_pixel_exact(self):
        source_by_xy = {
            tuple(entry["source_texloc_xy_cells"]): entry
            for entry in self.river_assets["shoreline_tiles"]
        }
        patch_frames = [np.asarray(frame, dtype=np.uint8)
                        for frame in self.river_assets["surface_patch_frames"]]
        for code in CASES:
            with self.subTest(code=code):
                manifest = self.manifest(code)
                water_record = manifest["water"]
                water = np.asarray(self.load(code, "masks/masque_eau.png").convert("L")) > 0
                output_frames = [np.asarray(frame) for frame in self.water_frames(code)]
                placements = water_record["placements"]
                expected_edge_cells = []
                for y in range(72):
                    for x in range(96):
                        cell = water[y * 8:(y + 1) * 8, x * 8:(x + 1) * 8]
                        if 0 < int(cell.sum()) < 64:
                            expected_edge_cells.append((x, y))
                self.assertEqual(len(placements), len(expected_edge_cells))
                self.assertEqual(water_record["output_shoreline_cells"], len(expected_edge_cells))
                self.assertEqual([tuple(p["destination_xy_cells"]) for p in placements], expected_edge_cells)

                for phase in range(4):
                    patch = patch_frames[phase]
                    expected = np.tile(patch, (9, 12, 1))
                    expected[~water] = 0
                    for placement in placements:
                        x, y = placement["destination_xy_cells"]
                        source = source_by_xy[tuple(placement["source_texloc_xy_cells"])]
                        target = water[y * 8:(y + 1) * 8, x * 8:(x + 1) * 8]
                        source_masks = source["alpha_masks"]
                        mean_mismatch = sum(int((np.asarray(mask, dtype=bool) ^ target).sum())
                                             for mask in source_masks) / 4
                        self.assertAlmostEqual(placement["mean_alpha_mask_mismatch_px"], mean_mismatch)
                        native = np.asarray(source["frames"][phase], dtype=np.uint8)
                        cell = expected[y * 8:(y + 1) * 8, x * 8:(x + 1) * 8].copy()
                        visible = (native[:, :, 3] > 0) & target
                        cell[visible] = native[visible]
                        cell[:, :, 3] = target.astype(np.uint8) * 255
                        expected[y * 8:(y + 1) * 8, x * 8:(x + 1) * 8] = cell
                    expected[~water] = 0
                    expected[:, :, 3] = water.astype(np.uint8) * 255
                    self.assertTrue(np.array_equal(output_frames[phase], expected))

                self.assertLessEqual(max(p["mean_alpha_mask_mismatch_px"] for p in placements), 11)

    def test_original_decor_and_static_flower_art_are_preserved(self):
        for code in CASES:
            with self.subTest(code=code):
                manifest = self.manifest(code)
                decor_record = next(entry for entry in manifest["inputs"] if entry["role"] == "decor")
                source = Image.open(ROOT / decor_record["file"]).convert("RGB")
                expected = np.asarray(build_module.normalize_rgb(source).convert("RGBA"))
                actual = np.asarray(self.load(code, "layers/01_decor_hors_eau_fleurs_statiques.png").convert("RGBA"))
                water = np.asarray(self.load(code, "masks/masque_eau.png").convert("L")) > 0
                self.assertTrue(np.array_equal(actual[~water], expected[~water]))
                self.assertFalse(np.any(actual[water, 3]))

                slug = CASES[code]
                render_dir = ROOT / "renders" / slug
                self.assertFalse((render_dir / "layers/Fleur_SkyPeak_reference_7x7.png").exists())
                self.assertFalse((render_dir / "masks/masque_fleurs_animees.png").exists())
                self.assertFalse(any((render_dir / "animation/fleurs").glob("*.png"))
                                 if (render_dir / "animation/fleurs").exists() else False)

    def test_no_magenta_rim_is_left_in_visible_decor(self):
        for code in CASES:
            with self.subTest(code=code):
                slug = CASES[code]
                water = np.asarray(Image.open(ROOT / "renders" / slug / "masks/masque_eau.png").convert("L")) > 0
                decor = np.asarray(Image.open(ROOT / "renders" / slug / "layers/01_decor_hors_eau_fleurs_statiques.png").convert("RGBA"))
                r, g, b = decor[:, :, :3].astype(np.int16).transpose(2, 0, 1)
                dist = nd.distance_transform_edt(~water)
                rose = ((decor[:, :, 3] > 0) & (dist <= 3.0) & (r > 130) & (b > 110)
                        & (r > g * 1.15) & (b > g * 1.15))
                self.assertEqual(int(rose.sum()), 0, f"Frange rose restante près de l'eau: {int(rose.sum())} px")

    def test_native_sparkles_stay_inside_water(self):
        for code in CASES:
            with self.subTest(code=code):
                slug = CASES[code]
                manifest = self.manifest(code)
                water = np.asarray(Image.open(ROOT / "renders" / slug / "masks/masque_eau.png").convert("L")) > 0
                self.assertEqual(manifest["sparkles"]["source"], "source/eau_metano/natifs/Metano_Town_River_Sparkles.tile")
                self.assertTrue(manifest["sparkles"]["native_pixels_unchanged"])
                self.assertEqual(manifest["sparkles"]["transformations"], [])
                self.assertGreaterEqual(manifest["sparkles"]["count"], 2)
                for i in range(1, 5):
                    layer = np.asarray(Image.open(ROOT / "renders" / slug / f"animation/scintillements/{code}_scintillements_phase_{i}.png").convert("RGBA"))
                    self.assertFalse(np.any((layer[:, :, 3] > 0) & ~water))

    def test_complete_review_webp_and_png(self):
        for code in CASES:
            with self.subTest(code=code):
                slug = CASES[code]
                still = self.load(code, f"review/{code}_scene_t000.png")
                self.assertEqual(still.size, (768, 576))
                anim_path = ROOT / "renders" / slug / f"review/{code}_scene_animee.webp"
                with Image.open(anim_path) as anim:
                    self.assertEqual(anim.size, (768, 576))
                    self.assertEqual(anim.n_frames, 24)
                zoom = self.load(code, f"review/{code}_zoom_eau_metano.png")
                self.assertEqual(zoom.size, (432, 288))

    def test_multilayer_openraster_and_interactive_viewer(self):
        html = (ROOT / "apercu_vallons_fleuris_v1.html").read_text(encoding="utf-8")
        self.assertIn("const MAPS=", html)
        self.assertIn("FVF1", html)
        self.assertIn("EVF1", html)
        self.assertIn("Metano Town River", html)
        self.assertIn("2cwdrrs469f61.gif", html)
        self.assertNotIn("localhost", html.lower())
        self.assertNotIn("A‑B‑A‑C", html)
        self.assertNotIn("131,218,230", html)
        for code in CASES:
            with self.subTest(code=code):
                slug = CASES[code]
                ora = next((ROOT / "renders" / slug).glob(f"{code}_*_calques.ora"))
                with zipfile.ZipFile(ora) as z:
                    self.assertEqual(z.read("mimetype"), b"image/openraster")
                    stack = ET.fromstring(z.read("stack.xml"))
                    names = [layer.attrib["name"] for layer in stack.find("stack").findall("layer")]
                    self.assertEqual(len(names), 4)
                    self.assertIn("02 Eau + berges animées natives Metano Town River · phase 1/4", names)
                    self.assertFalse(any("skypeak" in name.lower() or "sprite" in name.lower() for name in names))
                    merged = Image.open(__import__("io").BytesIO(z.read("mergedimage.png")))
                    self.assertEqual(merged.size, (768, 576))


if __name__ == "__main__":
    unittest.main(verbosity=2)
