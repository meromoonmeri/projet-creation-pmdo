from __future__ import annotations

import hashlib
import json
from pathlib import Path
import tempfile
import unittest

from source.pmdo_cote.installer_destiny_overlay import validate_overlay


class OverlayGroundMetadataTests(unittest.TestCase):
    def make_overlay(self, root: Path, rows: list[dict]) -> None:
        map_rows = []
        for index, row in enumerate(rows):
            map_id = row["mapId"]
            ground = {
                "Version": row["serializedVersion"],
                "Object": {"AssetName": map_id, "TexSize": row["serializedTexSize"]},
            }
            raw = (json.dumps(ground, separators=(",", ":")) + "\n").encode("utf-8")
            relative = f"Data/Ground/{map_id}.rsground"
            destination = root / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(raw)
            map_rows.append({
                "mapId": map_id,
                "groundFile": relative,
                "outputGroundSha256": hashlib.sha256(raw).hexdigest(),
                "groundVersion": row["expectedVersion"],
                "texSize": row["expectedTexSize"],
            })
        (root / "Documentation").mkdir(parents=True, exist_ok=True)
        (root / "Documentation/catalogue_manifest.json").write_text(
            json.dumps({"maps": map_rows}), encoding="utf-8"
        )

    def test_accepts_per_map_versions_and_texsizes(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            self.make_overlay(root, [
                {
                    "mapId": "legacy_tex3",
                    "serializedVersion": "0.7.4.0",
                    "expectedVersion": "0.7.4.0",
                    "serializedTexSize": 3,
                    "expectedTexSize": 3,
                },
                {
                    "mapId": "current_tex1",
                    "serializedVersion": "0.8.12.0",
                    "expectedVersion": "0.8.12.0",
                    "serializedTexSize": 1,
                    "expectedTexSize": 1,
                },
            ])
            manifest, grounds = validate_overlay(root)
            self.assertEqual(len(manifest["maps"]), 2)
            self.assertEqual(len(grounds), 2)

    def test_rejects_ground_version_mismatch(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            self.make_overlay(root, [{
                "mapId": "wrong_version",
                "serializedVersion": "0.7.4.0",
                "expectedVersion": "0.8.12.0",
                "serializedTexSize": 3,
                "expectedTexSize": 3,
            }])
            with self.assertRaisesRegex(ValueError, "Ground.Version différent"):
                validate_overlay(root)

    def test_rejects_texsize_mismatch(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            self.make_overlay(root, [{
                "mapId": "wrong_texsize",
                "serializedVersion": "0.7.4.0",
                "expectedVersion": "0.7.4.0",
                "serializedTexSize": 3,
                "expectedTexSize": 1,
            }])
            with self.assertRaisesRegex(ValueError, "Ground.TexSize différent"):
                validate_overlay(root)


if __name__ == "__main__":
    unittest.main()
