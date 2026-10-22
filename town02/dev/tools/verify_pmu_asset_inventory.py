#!/usr/bin/env python3
"""Verify the pinned PMU asset inventory and byte-exact candidate payloads."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "docs/pmu_asset_inventory"
EXPECTED_COMMIT = "c25c01f9879369647cd5a19731b2e4e5acd33e67"
EXPECTED_ARCHIVES = 11
EXPECTED_RECORDS = 52486
EXPECTED_CANDIDATES = 1189


def main() -> None:
    inventory = json.loads((BASE / "inventory.json").read_text(encoding="utf-8"))
    assert inventory["source"]["commit"] == EXPECTED_COMMIT
    assert len(inventory["tile_archives"]) == EXPECTED_ARCHIVES
    assert sum(row["embedded_png_records"] for row in inventory["tile_archives"]) == EXPECTED_RECORDS
    assert inventory["candidate_count"] == EXPECTED_CANDIDATES
    assert len(inventory["candidates"]) == EXPECTED_CANDIDATES
    assert inventory["rules"]["map_crops_allowed"] is False
    assert inventory["rules"]["partial_tile_records_allowed"] is False

    seen = set()
    by_key = {}
    for row in inventory["candidates"]:
        key = (row["archive"], row["record_index"])
        assert key not in seen
        seen.add(key)
        path = BASE / row["file"]
        payload = path.read_bytes()
        assert payload.startswith(b"\x89PNG\r\n\x1a\n")
        assert len(payload) == row["bytes"]
        assert hashlib.sha256(payload).hexdigest() == row["sha256"]
        assert row["dimensions"] == [32, 32]
        assert row["extraction"] == "WHOLE_EMBEDDED_PNG_RECORD_BYTE_EXACT"
        assert row["placement_allowed"] is False
        by_key[key] = row

    qualified = json.loads((BASE / "qualified_small_objects.json").read_text(encoding="utf-8"))
    assert qualified["count"] == 83
    assert len(qualified["objects"]) == 83
    for row in qualified["objects"]:
        key = (row["archive"], row["record_index"])
        assert key in by_key
        assert row["sha256"] == by_key[key]["sha256"]
        assert row["visually_qualified"] is True
        assert row["placement_allowed"] is False
        assert row["pmdo_conversion"] == "NOT_RUN"
        assert row["runtime_validation"] == "NOT_RUN"

    manifest = json.loads((BASE / "manifest.json").read_text(encoding="utf-8"))
    assert manifest["count"] == 83
    assert len(manifest["objects"]) == 83
    assert sum(manifest["category_counts"].values()) == 83
    assert manifest["render"]["width"] == 1000
    assert manifest["render"]["height"] == 2022
    render_path = BASE / manifest["render"]["file"]
    assert hashlib.sha256(render_path.read_bytes()).hexdigest() == manifest["render"]["sha256"]
    for row in manifest["objects"]:
        key = (row["source_archive"], row["source_record_index"])
        assert key in by_key
        assert row["sha256"] == by_key[key]["sha256"]
        assert row["placement_allowed"] is False

    print(
        "PMU_ASSET_INVENTORY_PASS "
        f"archives={EXPECTED_ARCHIVES} records={EXPECTED_RECORDS} "
        f"candidates={EXPECTED_CANDIDATES} manifested=83"
    )


if __name__ == "__main__":
    main()
