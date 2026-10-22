#!/usr/bin/env python3
from __future__ import annotations

import gzip
import hashlib
import json
import tarfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPORTS = ROOT / "reports"
OFFICIAL = ROOT / "extracted/official"


class OfficialExtractionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.report = json.loads((REPORTS / "official-extraction.json").read_text())

    def test_source_and_reader_gate(self) -> None:
        self.assertEqual(self.report["status"], "OFFICIAL_MODEL_EXTRACTED_EXHAUSTIVELY")
        self.assertEqual(self.report["source"]["data_win_sha256"], "2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227")
        self.assertEqual(self.report["reader"]["library"], "UndertaleModLib")
        self.assertEqual(self.report["getter_errors"], 0)

    def test_exact_resource_counts(self) -> None:
        counts = self.report["resource_counts"]
        expected = {
            "Rooms": 98, "GameObjects": 727, "Sprites": 2775,
            "Sounds": 388, "EmbeddedAudio": 388, "EmbeddedTextures": 96,
            "TexturePageItems": 9134, "Code": 2188, "Strings": 22228,
        }
        for name, count in expected.items():
            self.assertEqual(counts[name], count, name)

    def test_raw_vm_and_gml_coverage(self) -> None:
        self.assertEqual(self.report["raw_vm"]["code_entries"], 2188)
        self.assertEqual(self.report["raw_vm"]["instruction_count"], 273883)
        self.assertTrue(self.report["raw_vm"]["complete"])
        self.assertEqual(self.report["gml"]["entries"], 2188)
        self.assertEqual(self.report["gml"]["decompiled_bodies"], 2025)
        self.assertEqual(self.report["gml"]["anonymous_child_aliases"], 161)
        self.assertEqual(self.report["gml"]["failures"], 2)
        with tarfile.open(OFFICIAL / "decompiled-gml.tar.gz", "r:gz") as archive:
            names = [row.name for row in archive.getmembers() if row.isfile()]
        self.assertEqual(len(names), 2188)
        self.assertIn("gml_Object_objstage_Step_2.gml", names)

    def test_all_frames_masks_and_audio(self) -> None:
        graphics = self.report["graphics"]
        self.assertEqual(graphics["sprites"], 2775)
        self.assertEqual(graphics["sprite_frames"], 9084)
        self.assertEqual(graphics["texture_page_items"], 9134)
        self.assertEqual(graphics["collision_masks"], 653)
        audio = json.loads((REPORTS / "audio-manifest.json").read_text())
        self.assertEqual(audio["embedded_audio_count"], 388)
        self.assertEqual(audio["sound_resource_count"], 388)
        self.assertEqual(audio["unmapped_embedded_audio"], [])
        self.assertEqual(audio["invalid_audio_ids"], [])

    def test_binary_blobs_are_content_addressed(self) -> None:
        blobs = sorted((OFFICIAL / "blobs").glob("*.bin"))
        self.assertEqual(len(blobs), 471)
        for path in blobs:
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), path.stem)

    def test_inventory_archives_are_valid(self) -> None:
        rows = self.report["inventories"]
        self.assertEqual(len(rows), 31)
        for row in rows:
            path = ROOT / row["archive"]
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), row["archive_sha256"])
            with gzip.open(path, "rb") as stream:
                first = stream.read(1)
            self.assertIn(first, (b"[", b"{"))

    def test_official_hash_manifest(self) -> None:
        for line in (REPORTS / "official-artifact-hashes.sha256").read_text().splitlines():
            expected, relative = line.split("  ", 1)
            path = ROOT / relative
            self.assertTrue(path.is_file(), relative)
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), expected, relative)

    def test_season_and_time_logic_are_source_proven(self) -> None:
        season = json.loads((REPORTS / "season-vm-evidence.json").read_text())
        self.assertEqual(season["status"], "SOURCE_PROVEN_EXACT_VM_LOGIC")
        self.assertEqual(season["limitations"], [])
        self.assertEqual(season["seasons"]["winter"]["tilesets"]["ground"], 27)
        self.assertEqual(season["seasons"]["autumn"]["tilesets"]["groundtex"], 4)
        time = json.loads((REPORTS / "time-system.json").read_text())
        self.assertEqual(time["observed_values"], [0, 1, 2, 3])
        self.assertEqual(time["reference_count"], 39)


if __name__ == "__main__":
    unittest.main()
