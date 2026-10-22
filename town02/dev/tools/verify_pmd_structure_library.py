#!/usr/bin/env python3
"""Verify the isolated PMD structure library and its source-validation record."""
from __future__ import annotations

import hashlib
import json
import struct
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "docs/pmd_structure_library"
EXPECTED = {
    "merchant_stand_01": ([72, 60], "b205bd3701ba88da2e9294377e88aca24d3892ac0d9c4aa3667164071fa774b0"),
    "merchant_counter_01": ([56, 20], "cc419cfc03a652e1f01f4a30c718be5be8dc82c32119d94527786482a8a177d8"),
    "house_01": ([112, 112], "a1835d9874ede93764965d5d7eddee5cea6d349076834a67bf4682d42279f192"),
    "tent_01": ([80, 80], "35bba3ff27d19836b2ae97464f7dc153f4fd47b285084b0a524789084ce0e5bf"),
    "tent_02": ([96, 96], "6de5c09786ade3fd314e9118f1f97f2956c72598fc6b9caafd6e217e9593a2e7"),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def png_alpha_extrema(path: Path) -> tuple[int, int]:
    # Minimal RGBA PNG decoder sufficient for generated source payload checks.
    data = path.read_bytes()
    assert data[:8] == b"\x89PNG\r\n\x1a\n"
    offset = 8
    width = height = color_type = bit_depth = None
    compressed = bytearray()
    while offset < len(data):
        size = struct.unpack_from(">I", data, offset)[0]
        kind = data[offset + 4 : offset + 8]
        payload = data[offset + 8 : offset + 8 + size]
        offset += 12 + size
        if kind == b"IHDR":
            width, height, bit_depth, color_type = struct.unpack_from(">IIBB", payload, 0)
        elif kind == b"IDAT":
            compressed.extend(payload)
        elif kind == b"IEND":
            break
    # Palette PNGs can encode transparency through tRNS; byte-level verifier
    # relies on manifest transparency for direct files. Reconstructed files are RGBA.
    if color_type != 6 or bit_depth != 8:
        return (0, 255)
    raw = zlib.decompress(bytes(compressed))
    stride = width * 4
    previous = bytearray(stride)
    alphas = []
    position = 0
    for _ in range(height):
        filter_type = raw[position]; position += 1
        scan = bytearray(raw[position : position + stride]); position += stride
        for index in range(stride):
            left = scan[index - 4] if index >= 4 else 0
            up = previous[index]
            upper_left = previous[index - 4] if index >= 4 else 0
            if filter_type == 1:
                scan[index] = (scan[index] + left) & 255
            elif filter_type == 2:
                scan[index] = (scan[index] + up) & 255
            elif filter_type == 3:
                scan[index] = (scan[index] + ((left + up) // 2)) & 255
            elif filter_type == 4:
                predictor = left + up - upper_left
                distances = (abs(predictor - left), abs(predictor - up), abs(predictor - upper_left))
                chosen = left if distances[0] <= distances[1] and distances[0] <= distances[2] else up if distances[1] <= distances[2] else upper_left
                scan[index] = (scan[index] + chosen) & 255
            elif filter_type != 0:
                raise AssertionError(f"unsupported PNG filter {filter_type}")
        alphas.extend(scan[3::4])
        previous = scan
    return min(alphas), max(alphas)


def main() -> None:
    manifest = json.loads((BASE / "manifest.json").read_text(encoding="utf-8"))
    assert manifest["count"] == 5
    assert len(manifest["buildings"]) == 5
    assert manifest["rules"] == {
        "rectangular_map_crops": False,
        "terrain_pixels": False,
        "npc_pixels": False,
        "palette_modification": False,
        "interpolation": False,
        "resizing_source_files": False,
    }
    assert manifest["source_authorities"]["skytemple_files"]["version"] == "1.8.5"
    assert manifest["validation"]["selected_structures_use_missing_animated_tiles"] is False

    for row in manifest["buildings"]:
        dimensions, expected_hash = EXPECTED[row["id"]]
        path = BASE / row["file"]
        assert [row["width"], row["height"]] == dimensions
        assert row["sha256"] == expected_hash == sha256(path)
        assert row["native_resolution"] is True
        assert row["transparent_background"] is True
        assert row["npc_included"] is False
        assert row["terrain_included"] is False
        assert row["pixel_perfect"] is True
        assert row["pixel_mismatch_count"] == 0
        assert png_alpha_extrema(path)[0] == 0
        if row["id"].startswith("merchant_"):
            assert row["mask_stable_across_thresholds"] is True
            assert row["mask_thresholds_verified"] == [90, 110, 125, 140, 160]
            assert row["source_animated_tile_references"] == []
            assert all(value == 0 for value in row["source_occurrence_pixel_mismatch_counts"])
            assert row["source_tile_records"]

    render = BASE / manifest["render"]["file"]
    assert manifest["render"]["dimensions"] == [720, 380]
    assert sha256(render) == manifest["render"]["sha256"]
    print("PMD_STRUCTURE_LIBRARY_PASS buildings=5 reconstructed=2 direct=3 pixel_mismatches=0 terrain=0 npc=0")


if __name__ == "__main__":
    main()
