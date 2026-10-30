from __future__ import annotations

import json
from pathlib import Path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from source.pmdo_runtime.verify_destiny_ground_archive_0812 import (  # noqa: E402
    GroundRecord,
    inspect_ground,
    make_hook,
    replace_object_asset_name,
)


class GroundArchiveMetadataTests(unittest.TestCase):
    @staticmethod
    def ground(version: str = "0.7.4.0", tex_size: int = 3) -> bytes:
        column = [
            {"Bounds": {"X": 0, "Y": y * 8, "Width": 8, "Height": 8}, "Tags": 0}
            for y in range(tex_size)
        ]
        document = {
            "Version": version,
            "Object": {
                "$type": "RogueEssence.Ground.GroundMap, RogueEssence",
                "TexSize": tex_size,
                "Comment": {"AssetName": "nested_name_must_stay"},
                "AssetName": "legacy_sample",
                "Layers": [{"Tiles": [[{}], [{}]]}, {"Tiles": [[{}], [{}]]}],
                "obstacles": [column for _ in range(2 * tex_size)],
            },
        }
        return json.dumps(document).encode("utf-8")

    def test_uses_serialized_version_texsize_and_dimensions(self) -> None:
        result = inspect_ground(
            self.ground(),
            {"Version": "0.7.4.0", "texSize": 3, "grid": [2, 1], "layers": 2},
            {"gameVersion": "0.8.12.0"},
        )
        self.assertEqual(result["version"], "0.7.4.0")
        self.assertEqual(result["texSize"], 3)
        self.assertEqual(result["grid"], [2, 1])
        self.assertEqual(result["layers"], 2)

    def test_rejects_manifest_version_texsize_or_grid_mismatch(self) -> None:
        with self.assertRaisesRegex(ValueError, "Ground.Version"):
            inspect_ground(self.ground(), {"groundVersion": "0.8.12.0"}, {})
        with self.assertRaisesRegex(ValueError, "Ground.TexSize"):
            inspect_ground(self.ground(), {"texSize": 1}, {})
        with self.assertRaisesRegex(ValueError, "manifest grid"):
            inspect_ground(self.ground(), {"grid": [3, 1]}, {})

    def test_probe_alias_changes_only_object_asset_name(self) -> None:
        raw = self.ground()
        patched = replace_object_asset_name(raw, "legacy_sample", "probe_legacy_sample")
        document = json.loads(patched)
        self.assertEqual(document["Object"]["AssetName"], "probe_legacy_sample")
        self.assertEqual(document["Object"]["Comment"]["AssetName"], "nested_name_must_stay")
        self.assertEqual(json.loads(raw)["Object"]["AssetName"], "legacy_sample")

    def test_lua_hook_uses_each_maps_texsize_not_a_global_one(self) -> None:
        row = GroundRecord(
            source_row=1,
            source_entry_id="legacy_001",
            map_id="legacy_sample",
            runtime_id="legacy_sample",
            source_path="legacy_sample.rsground",
            version="0.7.4.0",
            tex_size=3,
            width=2,
            height=1,
            layers=2,
            sha256="0" * 64,
            alias_applied=False,
        )
        hook = make_hook([row], "probe.tsv").decode("utf-8")
        self.assertIn("gfx.DungeonTexSize=3", hook)
        self.assertIn("map.TexSize==test.texSize", hook)
        self.assertIn("texSize=3", hook)
        self.assertNotIn("map.TexSize==1", hook)


if __name__ == "__main__":
    unittest.main()
