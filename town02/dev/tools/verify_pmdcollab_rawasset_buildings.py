#!/usr/bin/env python3
"""Verify the pinned PMDCollab RawAsset building inventory."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "docs/pmdcollab_rawasset_buildings"
EXPECTED_COMMIT = "03c80dad937911572f8fb19903771a47956fc696"
EXPECTED = {
    "House_Normal.None.png": ([112, 112], "a1835d9874ede93764965d5d7eddee5cea6d349076834a67bf4682d42279f192"),
    "Tent.Flip.png": ([80, 80], "35bba3ff27d19836b2ae97464f7dc153f4fd47b285084b0a524789084ce0e5bf"),
    "Tent_Plain.Flip.png": ([96, 96], "6de5c09786ade3fd314e9118f1f97f2956c72598fc6b9caafd6e217e9593a2e7"),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    manifest = json.loads((BASE / "manifest.json").read_text(encoding="utf-8"))
    assert manifest["source"]["commit"] == EXPECTED_COMMIT
    assert manifest["source"]["license_status"] == "NO_TOP_LEVEL_LICENSE_FOUND"
    assert manifest["counts"] == {
        "object_png_files": 89,
        "qualified_complete_buildings": 3,
        "excluded_map_or_tileset_sheets": 23,
    }
    assert manifest["rules"]["map_crops_allowed"] is False
    assert manifest["rules"]["tileset_fragments_allowed"] is False
    assert len(manifest["all_object_png_files"]) == 89
    assert len(manifest["excluded_map_or_tileset_sheets"]) == 23
    assert all(row["placement_allowed"] is False for row in manifest["excluded_map_or_tileset_sheets"])

    assert len(manifest["qualified_buildings"]) == 3
    for row in manifest["qualified_buildings"]:
        name = Path(row["path"]).name
        dimensions, expected_hash = EXPECTED[name]
        payload = BASE / row["payload"]
        assert row["dimensions"] == dimensions
        assert row["sha256"] == expected_hash
        assert row["payload_sha256"] == expected_hash
        assert sha256(payload) == expected_hash
        assert row["extraction"] == "WHOLE_SOURCE_PNG_BYTE_EXACT"
        assert row["placement_allowed"] is False

    render = BASE / manifest["render"]["file"]
    assert manifest["render"]["dimensions"] == [840, 230]
    assert sha256(render) == manifest["render"]["sha256"]
    exclusions = {Path(row["path"]).name for row in manifest["named_exclusions"]}
    assert exclusions == {"Block_Guild.None.png", "Storage.Flip.png", "Tile_Shop.None.png"}
    print("RAWASSET_BUILDING_INVENTORY_PASS objects=89 qualified=3 map_sheets=23 fragments=0")


if __name__ == "__main__":
    main()
