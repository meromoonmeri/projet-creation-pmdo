#!/usr/bin/env python3
"""Static migration contract for the first PMD Red EU replay slice (s01)."""

from __future__ import annotations

import hashlib
import json
import re
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
AUTHORITY = ROOT / "docs/pmdred_eu/narrative_migration/scenes/s01/authority.json"
SCENE = ROOT / "Data/Script/halcyon/pmdred_eu/scene/s01.lua"
PLAYER = ROOT / "Data/Script/halcyon/pmdred_eu/ScenePlayer.lua"
STRINGS = ROOT / "Data/Script/halcyon/pmdred_eu/strings.fr.resx"
TEXTS_LUA = ROOT / "Data/Script/halcyon/pmdred_eu/FrenchText.lua"
RUNTIME_EVIDENCE = ROOT / "docs/pmdred_eu/narrative_migration/scenes/s01/runtime"


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def resx_values(path: Path) -> dict[str, str]:
    root = ET.parse(path).getroot()
    return {node.get("name", ""): node.findtext("value") or "" for node in root.findall("data")}


def decode_eu_markup(value: str) -> list[str]:
    value = value.replace("#+", "").replace("~2c", ",").replace("~27", "'")
    return [page.lstrip("\n") for page in value.split("#W")]


class SceneS01MigrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.authority = json.loads(AUTHORITY.read_text(encoding="utf-8"))
        cls.scene = SCENE.read_text(encoding="utf-8")
        cls.player = PLAYER.read_text(encoding="utf-8")
        cls.strings = resx_values(STRINGS)
        cls.runtime_texts = dict(re.findall(
            r"^\s*(PMDRED_EU_S01_[A-Z0-9_]+)\s*=\s*\[\[(.*?)\]\],",
            TEXTS_LUA.read_text(encoding="utf-8"),
            re.M | re.S,
        ))

    def test_authority_and_immutable_ground_hashes(self) -> None:
        authority = self.authority
        self.assertEqual(authority["authority"]["rom_sha256"], "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd")
        self.assertTrue(authority["authority"]["exact_eu_graph"])
        self.assertEqual(
            [command["op_hex"] for command in authority["source_script"]["commands"]],
            ["0x47", "0x08", *("0x37" for _ in range(6)), "0x30", "0x0C", "0x44", "0x22", "0x3C", "0x48", "0x23", "0xEF"],
        )
        ground = authority["immutable_ground"]
        self.assertEqual(sha256_file(ROOT / ground["ground"]), ground["ground_sha256"])
        self.assertEqual(sha256_file(ROOT / ground["tile"]), ground["tile_sha256"])
        audio = authority["audio"]
        self.assertEqual(sha256_file(ROOT / audio["pmdo_asset"]), audio["pmdo_sha256"])

    def test_french_runtime_pages_are_exact_eu_text(self) -> None:
        blocks = self.authority["french_text_blocks_execution_order"]
        self.assertEqual(len(blocks), 6)
        expected_pages = [decode_eu_markup(block["text"]) for block in blocks]
        actual_pages = [
            [self.strings["PMDRED_EU_S01_001"]],
            [self.strings["PMDRED_EU_S01_002"]],
            [self.strings["PMDRED_EU_S01_003"]],
            [self.strings["PMDRED_EU_S01_004"]],
            [self.strings["PMDRED_EU_S01_005"]],
            [self.strings["PMDRED_EU_S01_006_A"], self.strings["PMDRED_EU_S01_006_B"]],
        ]
        self.assertEqual(actual_pages, expected_pages)
        self.assertEqual(self.strings["PMDRED_EU_S01_006"], "\n".join(expected_pages[-1]))
        self.assertEqual(self.runtime_texts, self.strings)
        self.assertNotIn("FormatKey", self.player)

    def test_prelude_order_matches_source_until_explicit_dependency(self) -> None:
        source_ops = [
            "BGM_STOP", "SELECT_MAP",
            *("MSG_ON_BG" for _ in range(6)),
            "TEXTBOX_CLEAR", "SELECT_ENTITIES", "BGM_SWITCH",
        ]
        table = self.scene.split("local PRELUDE = {", 1)[1].split("}\n\nfunction s01.ReplayPrelude", 1)[0]
        implemented_ops = re.findall(r"\{op = '([^']+)'", table)
        self.assertEqual(implemented_ops, source_ops)
        self.assertEqual(self.authority["implemented_source_indices"], list(range(11)))
        self.assertIn("SPECIAL_TEXT_PERSONALITY_QUIZ_AND_PALETTE_0x22", self.scene)
        self.assertIn("not promotable yet", self.scene)

    def test_namespace_is_parallel_and_ground_mutation_is_absent(self) -> None:
        combined = self.scene + self.player
        self.assertNotRegex(combined, r"require\s+['\"]halcyon\.Fugitive")
        self.assertNotIn("SV.Chapter", combined)
        self.assertNotIn("SV.FugitiveArc", combined)
        self.assertNotRegex(combined, r"GROUND:(?:Add|Remove|SetTile|SetObstacle)")
        self.assertIn("certified_ground_state_no_mutation", combined)

    def test_unknown_continuation_fails_hard_instead_of_being_skipped(self) -> None:
        self.assertRegex(self.scene, r"error\('unmapped PMD Red EU s01 prelude opcode")
        self.assertRegex(self.scene, r"function s01\.Cutscene\(\)\s+error\(")
        self.assertEqual(self.authority["migration_status"], "IN_PROGRESS_DEPENDENCY_BLOCKED")

    def test_durable_runtime_evidence_is_partial_and_integral(self) -> None:
        validation = json.loads((RUNTIME_EVIDENCE / "validation.json").read_text())
        manifest = json.loads((RUNTIME_EVIDENCE / "fixture_manifest.json").read_text())
        self.assertEqual(manifest["scene_script_sha256"], sha256_file(SCENE))
        self.assertEqual(manifest["scene_player_sha256"], sha256_file(PLAYER))
        self.assertEqual(manifest["french_runtime_texts_sha256"], sha256_file(TEXTS_LUA))
        self.assertEqual(manifest["french_strings_sha256"], sha256_file(STRINGS))
        self.assertEqual(validation["result"], "PARTIAL_PASS_DEPENDENCY_BLOCKED")
        self.assertFalse(validation["full_scene_migrated"])
        self.assertEqual(validation["blocking_dependency"], "SPECIAL_TEXT_PERSONALITY_QUIZ_AND_PALETTE_0x22")
        self.assertEqual(validation["pmdo"]["termination"]["returncode"], 0)
        self.assertTrue(validation["pmdo"]["termination"]["normal_exit"])
        events = [json.loads(line) for line in (RUNTIME_EVIDENCE / "events.jsonl").read_text().splitlines()]
        self.assertEqual(len(events), 55)
        self.assertEqual(events[-1]["event"], "end")
        self.assertFalse(any(event["event"] == "RUNTIME_FAIL" for event in events))
        for line in (RUNTIME_EVIDENCE / "evidence_hashes.sha256").read_text().splitlines():
            digest, relative = line.split("  ", 1)
            self.assertEqual(sha256_file(RUNTIME_EVIDENCE / relative), digest)


if __name__ == "__main__":
    unittest.main()
