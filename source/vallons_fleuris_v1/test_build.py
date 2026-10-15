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
                window = water["output_native_source_window"]
                self.assertEqual(window["source_window_size_cells"], [96, 72])
                self.assertTrue(window["native_scale"])
                self.assertEqual(manifest["water"]["visual_reference"], "marvelousvalley.mp4")
                self.assertFalse(manifest["water"]["visual_reference_used_as_pixel_source"])
                self.assertTrue(water["output_animation"]["native_frame_pixels_used"])
                self.assertTrue(water["output_animation"]["mask_fixed_for_all_phases"])
                self.assertEqual(water["frame_count"], 4)
                self.assertEqual(water["frame_length_ticks"], 10)
                self.assertEqual(water["phase_order"], [1, 2, 3, 4])
                self.assertTrue(water["canonical_source_map_reconstructed_exactly"])
                self.assertFalse(water["canonical_map_layout_preserved_in_biome_maps"])
                self.assertFalse(water["output_rgb_values_are_generated_map_samples"])
                self.assertTrue(water["output_rgb_values_are_native_map_samples"])
                self.assertFalse(water["output_map_coordinates_canonical"])
                self.assertFalse(water["surface_patch_repeated_at_native_scale"])
                self.assertFalse(water["individual_shoreline_tile_matching_used"])
                self.assertTrue(water["mask_clip_applied"])
                self.assertFalse(water["output_animation"]["full_canonical_map_layout_retained_in_biome"])
                self.assertEqual(len(water["canonical_source_map_frames_saved"]), 4)
                self.assertEqual(len(water["source_map_frame_paths"]), 4)

                flowers = manifest["flowers"]
                self.assertEqual(flowers["status"], "official_frames_missing")
                self.assertFalse(flowers["animation_applied"])
                self.assertFalse(flowers["synthetic_fallback"])
                self.assertTrue(flowers["original_generated_flower_art_preserved_static"])
                self.assertIn("2cwdrrs469f61.gif", flowers["request"])
                self.assertEqual(flowers["animated_count"], 0)

    def test_native_water_frames_animate_inside_fixed_magenta_mask(self):
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
                    self.assertFalse(np.any(rgba[~water, 3]))
                differences = [int((np.any(frames[0] != frame, axis=2) & water).sum())
                               for frame in frames[1:]]
                self.assertEqual(differences, water_record["output_phase_changed_pixels_vs_1"])
                self.assertTrue(all(value > int(water.sum() * 0.008) for value in differences))
                edge_differences = water_record["output_shoreline_phase_changed_pixels_vs_1"]
                self.assertEqual(len(edge_differences), 3)
                self.assertTrue(all(value > 100 for value in edge_differences), edge_differences)
                animation = water_record["output_animation"]
                self.assertEqual(animation["phase_count"], 4)
                self.assertEqual(animation["frame_length_ticks"], 10)
                self.assertTrue(animation["mask_fixed_for_all_phases"])
                self.assertTrue(animation["native_frame_pixels_used"])
                self.assertFalse(animation["full_canonical_map_layout_retained_in_biome"])
                self.assertFalse(animation["rotation_mirror_resize_recolor"])

    def test_native_blue_shoreline_layer_uses_opaque_metano_bank_pixels(self):
        for code in CASES:
            with self.subTest(code=code):
                manifest = self.manifest(code)
                record = manifest["shoreline"]
                water_record = manifest["water"]
                water = np.asarray(self.load(code, "masks/masque_eau.png").convert("L")) > 0
                edge = water & (nd.distance_transform_edt(water) <= record["edge_width_px"])
                self.assertEqual(record["frame_count"], 4)
                self.assertEqual(record["output_edge_pixels_per_frame"], int(edge.sum()))
                self.assertTrue(record["native_frame_pixels_used"])
                self.assertTrue(record["native_rgb_unchanged"])
                self.assertTrue(record["inner_edge_clipped_to_target_mask"])
                self.assertFalse(record["individual_shoreline_tile_matching_used"])
                self.assertFalse(record["repeated_patch_used"])
                self.assertFalse(record["video_pixels_used"])
                self.assertEqual(len(record["output_frame_paths"]), 4)
                x0, y0, x1, y1 = water_record["output_native_source_window"]["source_window_xyxy_px"]
                for phase, path in enumerate(record["output_frame_paths"]):
                    output = np.asarray(Image.open(ROOT / path).convert("RGBA"))
                    self.assertTrue(np.array_equal(output[:, :, 3] > 0, edge))
                    source_rgba = np.asarray(self.river_assets["canonical_map_frames"][phase].crop((x0, y0, x1, y1)))
                    alpha = source_rgba[:, :, 3]
                    coverage = (alpha > 0).reshape(72, 8, 96, 8).sum(axis=(1, 3))
                    partial_cells = (coverage > 0) & (coverage < 64)
                    partial_pixels = np.repeat(np.repeat(partial_cells, 8, axis=0), 8, axis=1)
                    rgb = source_rgba[:, :, :3].astype(np.int16)
                    donors = (partial_pixels & (alpha == 255)
                              & (rgb[:, :, 0] < 110) & (rgb[:, :, 1] < 160)
                              & (rgb[:, :, 2] >= 180) & (rgb[:, :, 2] > rgb[:, :, 1] * 1.15))
                    self.assertGreater(int(donors.sum()), 100)
                    _, nearest = nd.distance_transform_edt(~donors, return_indices=True)
                    expected_rgb = source_rgba[nearest[0], nearest[1], :3]
                    self.assertTrue(np.array_equal(output[edge, :3], expected_rgb[edge]))

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

    def test_native_map_crop_samples_real_frames_at_1to1(self):
        for code in CASES:
            with self.subTest(code=code):
                record = self.manifest(code)["water"]
                water = np.asarray(self.load(code, "masks/masque_eau.png").convert("L")) > 0
                frames = [np.asarray(frame) for frame in self.water_frames(code)]
                window = record["output_native_source_window"]
                x0, y0, x1, y1 = window["source_window_xyxy_px"]
                self.assertEqual([x1 - x0, y1 - y0], [768, 576])
                self.assertEqual(window["source_window_size_cells"], [96, 72])
                self.assertTrue(window["native_scale"])
                self.assertFalse(window["resized"])
                self.assertFalse(window["recolored"])
                self.assertFalse(window["mirror"])
                self.assertEqual(window["rotation_degrees"], 0)
                self.assertGreater(window["mask_vs_native_surface_iou"], 0.1)
                source_calm_grid = np.zeros((189, 142), dtype=bool)
                for sx, sy in self.river_assets["_source_calm_water_cells_xy"]:
                    source_calm_grid[sy, sx] = True
                source_window_grid = source_calm_grid[y0 // 8:y1 // 8, x0 // 8:x1 // 8]
                calm_surface_valid = np.repeat(np.repeat(source_window_grid, 8, axis=0), 8, axis=1)
                self.assertEqual(int(source_window_grid.sum()), window["source_calm_surface_cells_in_window"])
                self.assertGreaterEqual(window["source_river_alpha_cells_in_window"], int(source_window_grid.sum()))
                base_rgb = np.asarray(record["source_calm_water_base_rgb_native"], dtype=np.int16)
                donor_min_delta = window["native_color_donor_min_channel_delta"]
                self.assertEqual(donor_min_delta, -10)
                for phase, source_frame in enumerate(self.river_assets["canonical_map_frames"]):
                    source_rgba = np.asarray(source_frame.crop((x0, y0, x1, y1)))
                    valid = (calm_surface_valid & (source_rgba[:, :, 3] == 255)
                             & np.all(source_rgba[:, :, :3].astype(np.int16) >= base_rgb + donor_min_delta, axis=2))
                    self.assertGreater(int(valid.sum()), 0)
                    _, nearest = nd.distance_transform_edt(~valid, return_indices=True)
                    expected_rgb = source_rgba[nearest[0], nearest[1], :3]
                    output_rgb = frames[phase][water, :3].astype(np.int16)
                    self.assertTrue(np.array_equal(output_rgb, expected_rgb[water]))
                    self.assertTrue(np.all(output_rgb >= base_rgb + donor_min_delta))
                    self.assertTrue(np.array_equal(frames[phase][:, :, 3] > 0, water))

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
                self.assertGreaterEqual(manifest["sparkles"]["count"], 25)
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
                zoom = self.load(code, f"review/{code}_zoom_eau_metano_native.png")
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
        self.assertIn("marvelousvalley.mp4", html)
        self.assertIn('class="reference-video" controls', html)
        self.assertIn('src="marvelousvalley.mp4"', html)
        self.assertIn("aucune frame vidéo n’est utilisée comme pixel source", html)
        self.assertIn("source_calm_water_base_rgb_native", html)
        self.assertIn("Rive bleue native Metano", html)
        self.assertIn("liseré intérieur de 1,5 px", html)
        for code in CASES:
            with self.subTest(code=code):
                slug = CASES[code]
                ora = next((ROOT / "renders" / slug).glob(f"{code}_*_calques.ora"))
                with zipfile.ZipFile(ora) as z:
                    self.assertEqual(z.read("mimetype"), b"image/openraster")
                    stack = ET.fromstring(z.read("stack.xml"))
                    names = [layer.attrib["name"] for layer in stack.find("stack").findall("layer")]
                    self.assertEqual(len(names), 5)
                    self.assertIn("02 Surface calme native Metano · fenêtre 1:1 · phase 1/4", names)
                    self.assertIn("03 Liseré de rive bleue native Metano · source alpha-partielle · phase 1/4", names)
                    self.assertIn("04 Scintillements natifs Metano River · phase 1/4", names)
                    self.assertFalse(any("skypeak" in name.lower() or "sprite" in name.lower() for name in names))
                    merged = Image.open(__import__("io").BytesIO(z.read("mergedimage.png")))
                    self.assertEqual(merged.size, (768, 576))


if __name__ == "__main__":
    unittest.main(verbosity=2)
