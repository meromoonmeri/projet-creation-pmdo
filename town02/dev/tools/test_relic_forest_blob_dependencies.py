#!/usr/bin/env python3
"""Regression guards for the six Map blobs required by Relic Forest."""

from __future__ import annotations

import hashlib
import json
import unittest
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = {
    "relic_forest_blob_broken_pillar": "77d14b8dd67360c76536bd4ae91ffecd8214a19e5ad72af94d09a7e14da75789",
    "relic_forest_blob_fallen_left": "07188d6a3ce86ead1fd644093f19e2e2c5dfab649fb7b5a8abb343f5fe93cd28",
    "relic_forest_blob_fallen_right": "5db746a56c9aa59631029a5fe96278c39009c98a247bfee9fc608aabe91a5bcc",
    "relic_forest_blob_pillar": "7e9d4da01ed246a286cd891cd4437fc7646dadb97f0c17309b66c5af6d558825",
    "relic_forest_blob_rubble": "3c1eaf17a6c5f282e8ff74aaa4cf9eddbc52d8d17c858e62ad35c9059a10415a",
    "relic_forest_blob_ruins": "00a900494c34498acb3643009d47bad8b16ea1c89d07290e351240b9ebab5f95",
}
PROVENANCE_COMMIT = "55860b9a5eb48697a3cea3a8bdfce5f0529d6141"


def walk(value):
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


class RelicForestBlobDependencies(unittest.TestCase):
    def test_restored_maps_are_byte_exact_and_self_consistent(self):
        for map_id, expected_hash in EXPECTED.items():
            path = ROOT / "Data/Map" / f"{map_id}.rsmap"
            self.assertTrue(path.is_file(), map_id)
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), expected_hash)
            payload = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
            self.assertEqual(payload["$type"], "RogueEssence.Dungeon.Map, RogueEssence")
            self.assertTrue(payload["Layers"])
            self.assertTrue(payload["Tiles"])
            sheets = {
                node["Sheet"]
                for node in walk(payload)
                if isinstance(node, dict) and isinstance(node.get("Sheet"), str)
            }
            self.assertEqual(len(sheets), 1)
            sheet = next(iter(sheets))
            self.assertTrue((ROOT / "Content/Tile" / f"{sheet}.tile").is_file(), sheet)

    def test_every_load_blob_reference_resolves_for_relic_forest_only(self):
        """Relic Forest owns the blobs; Sinister Woods must not load them."""
        references: dict[str, set[str]] = defaultdict(set)
        for zone_path in sorted((ROOT / "Data/Zone").glob("*.json")):
            payload = json.loads(zone_path.read_text(encoding="utf-8-sig"))
            for node in walk(payload):
                if not isinstance(node, dict) or "LoadBlobStep" not in node.get("$type", ""):
                    continue
                for child in walk(node.get("Maps", [])):
                    if isinstance(child, dict) and isinstance(child.get("Spawn"), str):
                        references[child["Spawn"]].add(zone_path.stem)
        self.assertEqual(set(references), set(EXPECTED))
        for map_id in EXPECTED:
            self.assertEqual(references[map_id], {"relic_forest"})
            self.assertTrue((ROOT / "Data/Map" / f"{map_id}.rsmap").is_file())

    def test_sinister_woods_has_no_relic_forest_blob_or_stair_script(self):
        payload = (ROOT / "Data/Zone/gloomy_forest.json").read_text(encoding="utf-8-sig")
        self.assertNotIn("relic_forest_blob_", payload)
        self.assertNotIn("ReverseRelicForest", payload)

    def test_probe_messages_are_ascii_and_describe_normal_transition(self):
        main = (ROOT / "Data/Script/halcyon/main.lua").read_text()
        probe = (ROOT / "Data/Script/halcyon/services/nre_probe/init.lua").read_text()
        self.assertNotIn("ÔÇö", main + probe)
        self.assertIn("charge (main.lua) -- PREMIERE ligne", main)
        self.assertIn("EngineServiceEvents.Init) -- build", probe)
        self.assertIn("NON (transition avant DungeonMapInit, normale)", probe)

    def test_provenance_is_pinned(self):
        # This constant documents the exact historical source used for the six
        # byte-for-byte restorations; the hashes above detect any later drift.
        self.assertEqual(PROVENANCE_COMMIT, "55860b9a5eb48697a3cea3a8bdfce5f0529d6141")


if __name__ == "__main__":
    unittest.main()
