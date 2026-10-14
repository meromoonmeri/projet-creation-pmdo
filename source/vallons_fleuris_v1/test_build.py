#!/usr/bin/env python3
"""Tests structurels FVF1/EVF1 et séparation des sources générées/natives."""
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
                self.assertEqual(water["source_map_size_cells"], [142, 189])
                self.assertEqual(water["source_map_size_px"], [1136, 1512])
                self.assertEqual(water["source_map_bounds_xyxy_cells"], [45, 0, 141, 188])
                self.assertTrue(water["source_map_cell_coordinates_match_texloc"])
                self.assertTrue(water["source_map_layout_reconstructed_exactly"])
                self.assertEqual(water["source_component_count"], 5)
                self.assertEqual(len(water["source_components"]), 5)
                self.assertIn("generations/", water["generated_fill_source"])
                self.assertEqual(len(water["generated_fill_sha256"]), 64)
                self.assertTrue(water["output_animation"]["mask_fixed_for_all_phases"])
                self.assertEqual(water["frame_count"], 4)
                self.assertEqual(water["frame_length_ticks"], 10)
                self.assertEqual(water["phase_order"], [1, 2, 3, 4])
                self.assertTrue(water["canonical_source_map_reconstructed_exactly"])
                self.assertFalse(water["canonical_map_placement_in_generated_maps"])
                self.assertTrue(water["output_rgb_values_are_generated_map_samples"])
                self.assertFalse(water["output_rgb_values_are_native_map_samples"])
                self.assertFalse(water["output_map_coordinates_canonical"])
                self.assertFalse(water["surface_patch_repeated_at_native_scale"])
                self.assertFalse(water["individual_shoreline_tile_matching_used"])
                self.assertTrue(water["mask_clip_applied"])
                self.assertFalse(water["output_animation"]["canonical_animation_claim"])
                self.assertEqual(len(water["canonical_source_map_frames_saved"]), 4)
                self.assertEqual(len(water["source_map_frame_paths"]), 4)

                flowers = manifest["flowers"]
                self.assertEqual(flowers["status"], "official_frames_missing")
                self.assertFalse(flowers["animation_applied"])
                self.assertFalse(flowers["synthetic_fallback"])
                self.assertTrue(flowers["original_generated_flower_art_preserved_static"])
                self.assertIn("2cwdrrs469f61.gif", flowers["request"])
                self.assertEqual(flowers["animated_count"], 0)

    def test_generated_water_frames_animate_inside_fixed_magenta_mask(self):
        for code in CASES:
            with self.subTest(code=code):
                water_record = self.manifest(code)["water"]
                water = np.asarray(self.load(code, "masks/masque_eau.png").convert("L")) > 0
                frames = [np.asarray(frame) for frame in self.water_frames(code)]
                self.assertEqual(len(frames), 4)
                self.assertGreater(int(water.sum()), 10000)
                for rgba in frames:
                    self.assertEqual(rgba.shape, (576, 768, 4))
                    self.assertTrue(np.array_equal(rgba[:, :, 3] > 0, water))
                    self.assertGreaterEqual(len(np.unique(rgba[water, :3], axis=0)), 12)
                    self.assertFalse(np.any(rgba[~water, 3]))
                differences = [int((np.any(frames[0] != frame, axis=2) & water).sum())
                               for frame in frames[1:]]
                self.assertEqual(differences, water_record["output_phase_changed_pixels_vs_1"])
                self.assertTrue(all(value > int(water.sum() * 0.01) for value in differences))
                edge_differences = water_record["output_shoreline_phase_changed_pixels_vs_1"]
                self.assertEqual(len(edge_differences), 3)
                self.assertTrue(all(value > 100 for value in edge_differences), edge_differences)
                animation = water_record["output_animation"]
                self.assertEqual(animation["phase_count"], 4)
                self.assertEqual(animation["frame_length_ticks"], 10)
                self.assertTrue(animation["mask_fixed_for_all_phases"])
                self.assertFalse(animation["uses_native_metano_water_pixels"])
                self.assertFalse(animation["canonical_animation_claim"])

    def test_full_native_map_is_rebuilt_at_example_map_cell_equal_texloc(self):
        source_data = json.loads((ROOT / "source/eau_metano/animations_carte.json").read_text())
        river_records = [record for record in source_data["animations"] if record.get("layer") == "River"]
        self.assertEqual(len(river_records), 3200)
        native_frames = self.river_assets["canonical_map_frames"]
        self.assertEqual(len(native_frames), 4)
        self.assertEqual([frame.size for frame in native_frames], [(1136, 1512)] * 4)
        banks = [build_module.decode_native_tilebank(
            ROOT / f"source/eau_metano/natifs/Metano_Town_River_Animation_{phase}.tile", 8)
            for phase in range(1, 5)]
        active_cells = set()
        for record in river_records:
            cell = tuple(record["example_map_cell"])
            active_cells.add(cell)
            for phase, frame_record in enumerate(record["animation"]["Frames"]):
                texloc = (frame_record["TexLoc"]["X"], frame_record["TexLoc"]["Y"])
                self.assertEqual(cell, texloc)
                x, y = cell
                actual = np.asarray(native_frames[phase].crop((x * 8, y * 8, (x + 1) * 8, (y + 1) * 8)))
                expected = np.asarray(banks[phase][cell])
                self.assertTrue(np.array_equal(actual, expected), (phase, cell))
        alpha = np.asarray(native_frames[0].getchannel("A"))
        for y in range(189):
            for x in range(142):
                if (x, y) not in active_cells:
                    self.assertFalse(np.any(alpha[y * 8:(y + 1) * 8, x * 8:(x + 1) * 8]))

        exported = self.manifest("FVF1")["water"]["canonical_source_map_frames_saved"]
        self.assertEqual(len(exported), 4)
        for phase, path in enumerate(exported):
            with Image.open(ROOT / path) as saved:
                self.assertTrue(np.array_equal(np.asarray(saved), np.asarray(native_frames[phase])))

    def test_generated_fill_is_sampled_only_inside_original_mask(self):
        for code in CASES:
            with self.subTest(code=code):
                record = self.manifest(code)["water"]
                generated_path = ROOT / record["generated_fill_source"]
                self.assertEqual(build_module.sha256(generated_path), record["generated_fill_sha256"])
                generated = Image.open(generated_path).convert("RGB")
                self.assertEqual(generated.size, (1200, 896))
                water = np.asarray(self.load(code, "masks/masque_eau.png").convert("L")) > 0
                expected = np.asarray(build_module.normalize_rgb(generated).convert("RGB"))
                frames = [np.asarray(frame) for frame in self.water_frames(code)]
                self.assertTrue(np.array_equal(frames[0][water, :3], expected[water]))
                self.assertFalse(np.any(frames[0][~water, 3]))
                rebuilt, _, _, _ = build_module.generated_water_frames(water, generated, code)
                for phase in range(4):
                    self.assertTrue(np.array_equal(frames[phase], np.asarray(rebuilt[phase])))

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
                zoom = self.load(code, f"review/{code}_zoom_eau_generee.png")
                self.assertEqual(zoom.size, (432, 288))

    def test_multilayer_openraster_and_interactive_viewer(self):
        html = (ROOT / "apercu_vallons_fleuris_v1.html").read_text(encoding="utf-8")
        self.assertIn("const MAPS=", html)
        self.assertIn("FVF1", html)
        self.assertIn("EVF1", html)
        self.assertIn("Metano Town River", html)
        self.assertIn("example_map_cell", html)
        self.assertIn("142×189", html)
        self.assertIn("Calques sources complets", html)
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
                    self.assertIn("02 Eau générée façon Métano · masque magenta exact · phase 1/4", names)
                    self.assertFalse(any("skypeak" in name.lower() or "sprite" in name.lower() for name in names))
                    merged = Image.open(__import__("io").BytesIO(z.read("mergedimage.png")))
                    self.assertEqual(merged.size, (768, 576))


if __name__ == "__main__":
    unittest.main(verbosity=2)
