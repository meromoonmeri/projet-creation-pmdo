#!/usr/bin/env python3
"""Qualification of the Relict source inventory and redaction boundary."""

from __future__ import annotations

import hashlib
import importlib.util
import json
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

WORKSPACE = Path(__file__).resolve().parents[1]
REPO_ROOT = WORKSPACE.parents[1]
SOURCE = REPO_ROOT / "external/BIBLIOTHEQUE/Relict/Relict V1.2/Relict"
TRACKED = WORKSPACE / "games/relict"
TOOLS = WORKSPACE / "tools"
sys.path.insert(0, str(TOOLS))

SPEC = importlib.util.spec_from_file_location("inventory_relict", TOOLS / "inventory_relict.py")
assert SPEC and SPEC.loader
INVENTORY = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(INVENTORY)

BUILD_SPEC = importlib.util.spec_from_file_location("build_relict_library", TOOLS / "build_relict_library.py")
assert BUILD_SPEC and BUILD_SPEC.loader
PIPELINE = importlib.util.module_from_spec(BUILD_SPEC)
BUILD_SPEC.loader.exec_module(PIPELINE)

from png_rgba import load_png


def load_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_library_files(root: Path):
    return [
        path for path in sorted(root.rglob("*"))
        if path.is_file()
        and not (
            path.relative_to(root).parts
            and path.relative_to(root).parts[0] == "conversion"
        )
    ]


def tree_hashes(root: Path) -> dict[str, str]:
    # These manifests are gated separately. source_manifest inventories every
    # tool in the shared multi-game workspace and legitimately changes when an
    # isolated Reminiscencia converter is added.
    excluded = {"manifests/generated_hashes.sha256", "manifests/source_manifest.json"}
    return {
        path.relative_to(root).as_posix(): sha256_file(path)
        for path in source_library_files(root)
        if path.relative_to(root).as_posix() not in excluded
    }


class RelictInventoryQualification(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.summary = load_json(TRACKED / "reports/inventory.json")
        cls.zones = [load_json(path) for path in sorted((TRACKED / "metadata/zones").glob("*.json"))]

    def test_source_is_pinned_and_never_modified(self):
        commit = subprocess.check_output(
            ["git", "-C", str(SOURCE.parents[2]), "rev-parse", "HEAD"], text=True
        ).strip()
        self.assertEqual(commit, INVENTORY.EXPECTED_SOURCE_COMMIT)
        self.assertEqual(
            subprocess.check_output(
                ["git", "-C", str(SOURCE.parents[2]), "status", "--porcelain"], text=True
            ),
            "",
        )
        manifest = load_json(TRACKED / "manifests/source_manifest.json")
        self.assertEqual(manifest["source_commit"], commit)
        self.assertEqual(manifest["execution_policy"], "NO_SOURCE_CODE_EXECUTION")
        for row in manifest["files"]:
            path = SOURCE / row["path"]
            self.assertTrue(path.is_file(), row["path"])
            self.assertEqual(sha256_file(path), row["sha256"])
            self.assertNotIn("Scripts.rxdata", row["path"])
            self.assertNotIn("Game.exe", row["path"])

    def test_complete_map_variant_collision_and_entity_inventory(self):
        self.assertEqual(self.summary["canonical_map_count"], 28)
        self.assertEqual(self.summary["variant_map_count"], 8)
        self.assertEqual(self.summary["byte_identical_variant_count"], 2)
        self.assertEqual(self.summary["divergent_variant_count"], 6)
        self.assertEqual(len(self.zones), 28)
        self.assertEqual({row["source_map_id"] for row in self.zones}, set(range(1, 29)))
        self.assertTrue(all(row["status"] == "SOURCE_DOCUMENTED" for row in self.zones))
        self.assertTrue(all(row["source_documentation"]["collision_complete"] for row in self.zones))
        self.assertEqual(self.summary["entity_event_count"], 100)
        self.assertEqual(self.summary["entity_page_placement_count"], 115)
        self.assertEqual(self.summary["cast_placeholder_count"], 68)
        self.assertEqual(self.summary["environmental_tile_entity_count"], 5)
        self.assertEqual(self.summary["logic_marker_count"], 42)
        self.assertEqual(self.summary["missing_dependency_count"], 0)
        for zone in self.zones:
            width = zone["geometry"]["width_tiles"]
            height = zone["geometry"]["height_tiles"]
            layers = zone["geometry"]["layer_count"]
            self.assertEqual(zone["collision"]["source_layers"]["value_count"], width * height * layers)
            self.assertTrue(zone["collision"]["source_complete"])
            self.assertTrue(zone["collision"]["dynamic_entities"]["placements_complete"])
            for section, key in (
                (zone["tile_layers"], "file"),
                (zone["collision"]["derived_directional_grid"], "file"),
                (zone["collision"]["tileset_tables"], "file"),
                (zone["entities"], "file"),
            ):
                path = TRACKED / section[key]
                self.assertTrue(path.is_file(), path)
                self.assertEqual(sha256_file(path), section["sha256"])

    def test_all_entity_positions_and_collision_flags_are_preserved_but_cast_is_redacted(self):
        classifications = {"CAST_PLACEHOLDER", "ENVIRONMENTAL_TILE_ENTITY", "LOGIC_MARKER"}
        for zone in self.zones:
            entities = load_json(TRACKED / zone["entities"]["file"])
            self.assertTrue(entities["source_complete"])
            self.assertTrue(entities["source_identities_redacted"])
            for placement in entities["placements"]:
                self.assertIn(placement["classification"], classifications)
                self.assertRegex(
                    placement["placeholder_id"],
                    r"^map_[0-9]{3}_entity_[0-9]{4}_page_[0-9]{2}$",
                )
                self.assertGreaterEqual(placement["position"]["x"], 0)
                self.assertLess(placement["position"]["x"], zone["geometry"]["width_tiles"])
                self.assertGreaterEqual(placement["position"]["y"], 0)
                self.assertLess(placement["position"]["y"], zone["geometry"]["height_tiles"])
                self.assertTrue(placement["graphic"]["source_identity_redacted"])
                self.assertIn("through", placement["collision"])
                self.assertIn("always_on_top", placement["collision"])
                self.assertIn("route_commands", placement["movement"])
                if placement["classification"] == "CAST_PLACEHOLDER":
                    self.assertRegex(
                        placement["graphic"]["source_identity_sha256"], r"^[0-9a-f]{64}$"
                    )

    def test_generated_outputs_contain_no_forbidden_asset_or_dialogue_payload(self):
        forbidden_keys = {
            "character_name", "event_name", "dialogue", "dialogue_text",
            "script_body", "trainer_name", "pokemon_species",
        }
        forbidden_paths = (
            "Graphics/Characters", "Graphics/Pokemon", "Graphics/Trainers",
            "Graphics/UI", "Game.exe", "Scripts.rxdata", ".dll",
        )
        for path in source_library_files(TRACKED):
            self.assertIn(path.suffix, {".json", ".md", ".sha256", ".png"})
            if path.suffix == ".png":
                self.assertEqual(path.read_bytes()[:8], b"\x89PNG\r\n\x1a\n")
                continue
            text = path.read_text(encoding="utf-8")
            for value in forbidden_paths:
                self.assertNotIn(value, text, f"{path}: {value}")
            if path.suffix == ".json":
                def walk(value):
                    if isinstance(value, dict):
                        for key, child in value.items():
                            self.assertNotIn(key, forbidden_keys, f"{path}: {key}")
                            walk(child)
                    elif isinstance(value, list):
                        for child in value:
                            walk(child)
                walk(json.loads(text))
        self.assertFalse(self.summary["dialogue_contents_exported"])
        self.assertFalse(self.summary["script_bodies_exported"])
        self.assertFalse(self.summary["pmdo_conversion_started"])

    def test_multilayer_collision_and_placeholder_previews_are_complete(self):
        manifest = load_json(TRACKED / "previews/manifest.json")
        self.assertEqual(manifest["result"], "PREVIEW_RENDER_PASS")
        self.assertEqual(manifest["canonical_preview_count"], 28)
        self.assertEqual(manifest["divergent_variant_preview_count"], 6)
        self.assertEqual(manifest["map_preview_count"], 34)
        self.assertEqual(manifest["tileset_reference_count"], 10)
        self.assertEqual(manifest["missing_tile_ids"], [])
        self.assertEqual(len(manifest["map_contact_sheet_order"]), 34)
        contact_path = TRACKED / manifest["map_contact_sheet"]["file"]
        self.assertEqual(sha256_file(contact_path), manifest["map_contact_sheet"]["sha256"])
        self.assertEqual((load_png(contact_path).width, load_png(contact_path).height), (800, 840))
        placeholder_difference_seen = False
        collision_colors = set()
        for preview in manifest["previews"]:
            files = {Path(row["file"]).name: row for row in preview["files"]}
            self.assertTrue({"layer_00.png", "layer_01.png", "layer_02.png", "composite.png", "collision.png", "entities_placeholders.png"} <= set(files))
            for row in preview["files"]:
                path = TRACKED / row["file"]
                self.assertEqual(sha256_file(path), row["sha256"])
                image = load_png(path)
                self.assertEqual(image.width, row["width_px"])
                self.assertEqual(image.height, row["height_px"])
            composite = TRACKED / files["composite.png"]["file"]
            entities = TRACKED / files["entities_placeholders.png"]["file"]
            placeholder_difference_seen |= composite.read_bytes() != entities.read_bytes()
            collision = load_png(TRACKED / files["collision.png"]["file"])
            collision_colors.update(
                tuple(collision.pixels[index : index + 4])
                for index in range(0, len(collision.pixels), 4)
            )
        self.assertTrue(placeholder_difference_seen)
        self.assertIn((38, 170, 70, 190), collision_colors)
        self.assertIn((215, 45, 45, 220), collision_colors)

    def test_animated_autotiles_are_exported_frame_by_frame(self):
        manifest = load_json(TRACKED / "animations/manifest.json")
        self.assertEqual(manifest["result"], "AUTOTILE_FRAME_EXTRACTION_PASS")
        self.assertEqual(manifest["animated_autotile_count"], 17)
        self.assertEqual(manifest["unsupported_autotile_count"], 0)
        self.assertEqual(manifest["timing_exact_count"], 17)
        self.assertEqual(manifest["timing_audit_required_count"], 0)
        self.assertEqual(manifest["timing_authority"]["default_duration_ms"], 250)
        self.assertEqual(sum(row["frame_count"] for row in manifest["animations"]), 88)
        for row in manifest["animations"]:
            metadata_path = TRACKED / row["metadata"]
            self.assertEqual(sha256_file(metadata_path), row["metadata_sha256"])
            metadata = load_json(metadata_path)
            self.assertEqual(metadata["frame_count"], len(metadata["layers"][0]["frames"]))
            self.assertEqual(metadata["status"], "SOURCE_DOCUMENTED")
            self.assertEqual(metadata["timing_authority"], "SOURCE_EXACT")
            self.assertEqual(metadata["timing_provenance"]["units"], "1/20 second")
            for index, frame in enumerate(metadata["layers"][0]["frames"]):
                self.assertEqual(frame["duration_ms"], 250)
                self.assertEqual(frame["file"], f"layers/layer_00/frame_{index:03d}.png")
                frame_path = metadata_path.parent / frame["file"]
                self.assertEqual(sha256_file(frame_path), frame["sha256"])

    def test_environmental_timelines_fogs_overlays_and_review_queue(self):
        manifest = load_json(TRACKED / "vfx/manifest.json")
        self.assertEqual(manifest["result"], "ENVIRONMENTAL_VFX_AUDIT_PASS")
        self.assertEqual(manifest["map_timeline_count"], 34)
        self.assertEqual(manifest["unresolved_environment_count"], 0)
        self.assertGreater(manifest["common_event_timeline_count"], 0)
        self.assertEqual(manifest["environment_asset_count"], 9)
        self.assertEqual(manifest["picture_transition_review_count"], 0)
        self.assertEqual(manifest["manual_picture_decision_count"], 9)
        self.assertEqual(manifest["excluded_picture_count"], 4)
        self.assertEqual(manifest["included_environmental_picture_count"], 5)
        self.assertFalse(manifest["dialogue_contents_exported"])
        self.assertFalse(manifest["script_bodies_exported"])
        self.assertEqual(manifest["redacted_script_command_count"], 1143)
        self.assertEqual(manifest["script_visual_block_count"], 199)
        self.assertEqual(manifest["script_visual_call_count"], 204)
        self.assertEqual(manifest["static_script_visual_audit_required_count"], 0)
        self.assertEqual(manifest["event_timing_authority"]["nominal_frame_rate"], 40)
        self.assertFalse(manifest["event_timing_authority"]["fixed_framerate_override_active"])
        for row in manifest["timelines"]:
            path = TRACKED / row["file"]
            self.assertEqual(sha256_file(path), row["sha256"])
            payload = load_json(path)
            self.assertFalse(payload["dialogue_contents_exported"])
            self.assertFalse(payload["script_bodies_exported"])
            for sequence in payload["sequences"]:
                indices = [command["source_index"] for command in sequence["timeline"]]
                self.assertEqual(indices, sorted(indices))
        for row in manifest["review_queue"]:
            self.assertRegex(row["source_identity_sha256"], r"^[0-9a-f]{64}$")
            self.assertFalse(row["pixels_exported"])
            self.assertNotIn("name", row)
            self.assertNotIn("source_path", row)
        self.assertEqual(manifest["review_queue"], [])
        for row in manifest["excluded_assets"]:
            self.assertIn(row["status"], {"EXCLUDED_CHARACTER", "EXCLUDED_UI"})
            self.assertFalse(row["pixels_exported"])
            self.assertNotIn("name", row)
            self.assertNotIn("source_path", row)
        animated = [row for row in manifest["environment_assets"] if "/animations/" in row["output"]]
        self.assertEqual(len(animated), manifest["animated_environment_count"])
        timing_rows = []
        for row in animated:
            metadata = load_json(TRACKED / row["output"])
            self.assertEqual(metadata["timing_authority"], "SOURCE_EXACT")
            self.assertTrue(metadata["loop"])
            durations = sorted({frame["duration_ms"] for frame in metadata["layers"][0]["frames"]})
            timing_rows.append((metadata["frame_count"], durations))
        self.assertEqual(
            sorted(timing_rows),
            [(4, [300]), (12, [100]), (144, [70, 100])],
        )

    def test_map_triggered_animation_frames_and_transforms_are_documented(self):
        manifest = load_json(TRACKED / "animations/map_effects/manifest.json")
        self.assertEqual(manifest["result"], "MAP_ANIMATION_EXTRACTION_PASS")
        self.assertEqual(manifest["used_animation_count"], 10)
        self.assertEqual(manifest["total_frame_count"], 231)
        self.assertEqual(manifest["timing_exact_count"], 10)
        self.assertEqual(manifest["unsupported_transform_count"], 0)
        self.assertFalse(manifest["audio_pixels_or_binaries_exported"])
        self.assertEqual(
            {row["source_animation_id"] for row in manifest["animations"]},
            {3, 4, 8, 9, 10, 11, 12, 17, 18, 19},
        )
        for row in manifest["animations"]:
            metadata_path = TRACKED / row["metadata"]
            self.assertEqual(sha256_file(metadata_path), row["metadata_sha256"])
            metadata = load_json(metadata_path)
            self.assertEqual(metadata["timing_authority"], "SOURCE_EXACT")
            self.assertEqual(metadata["timing_provenance"]["constant"], 20)
            self.assertEqual(metadata["frame_count"], len(metadata["cells_by_frame"]))
            self.assertTrue(metadata["contexts"])
            self.assertTrue(all(frame["duration_ms"] == 50 for frame in metadata["layers"][0]["frames"]))
            for timing in metadata["source_timings"]:
                self.assertFalse(timing["audio_exported"])

    def test_generated_hash_manifest_covers_every_output(self):
        manifest_path = TRACKED / "manifests/generated_hashes.sha256"
        rows = {}
        for line in manifest_path.read_text().splitlines():
            digest, relative = line.split("  ", 1)
            rows[relative] = digest
        expected_paths = {
            path.relative_to(TRACKED).as_posix()
            for path in source_library_files(TRACKED)
            if path != manifest_path
        }
        self.assertEqual(set(rows), expected_paths)
        for relative, digest in rows.items():
            self.assertEqual(sha256_file(TRACKED / relative), digest)

    def test_schema_contracts_are_closed_and_status_vocabulary_is_exact(self):
        schemas = {path.name: load_json(path) for path in (WORKSPACE / "schemas").glob("*.json")}
        self.assertEqual(
            schemas["status.schema.json"]["enum"],
            [
                "SOURCE_EXTRACTED", "SOURCE_DOCUMENTED", "PMDO_CONVERTED",
                "PMDO_VALIDATED", "ADAPTATION_REQUIRED", "UNSUPPORTED",
            ],
        )
        for name in (
            "asset.schema.json", "animation.schema.json", "collision.schema.json",
            "entity-placement.schema.json", "provenance.schema.json", "visual-timeline.schema.json",
            "zone.schema.json",
        ):
            self.assertFalse(schemas[name]["additionalProperties"], name)
            self.assertTrue(schemas[name]["required"], name)
        zone_schema = schemas["zone.schema.json"]
        allowed = set(zone_schema["properties"])
        required = set(zone_schema["required"])
        for zone in self.zones:
            self.assertTrue(required <= set(zone))
            self.assertFalse(set(zone) - allowed)

    def test_inventory_is_byte_reproducible(self):
        (REPO_ROOT / ".runtime-cache").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=REPO_ROOT / ".runtime-cache") as temp:
            output = Path(temp) / "relict"
            result = PIPELINE.build(SOURCE, output)
            self.assertEqual(result["result"], "RELICT_SOURCE_LIBRARY_PASS")
            self.assertEqual(result["inventory"]["canonical_map_count"], 28)
            self.assertEqual(result["documented_zone_count"], 28)
            self.assertEqual(result["previews"]["map_preview_count"], 34)
            self.assertEqual(result["animations"]["animated_autotile_count"], 17)
            self.assertEqual(result["vfx"]["result"], "ENVIRONMENTAL_VFX_AUDIT_PASS")
            self.assertEqual(result["map_animations"]["used_animation_count"], 10)
            self.assertEqual(tree_hashes(output), tree_hashes(TRACKED))


if __name__ == "__main__":
    unittest.main(verbosity=2)
