#!/usr/bin/env python3
"""Regression tests for the deterministic PMDO Ground renderer."""

from __future__ import annotations

import io
import struct
import tempfile
import unittest
from pathlib import Path

from PIL import Image

from render_ground_png import read_tile_sheet


def png_bytes(colour: tuple[int, int, int, int]) -> bytes:
    output = io.BytesIO()
    Image.new("RGBA", (8, 8), colour).save(output, "PNG")
    return output.getvalue()


def tile_container(header_metadata: int, image: bytes) -> bytes:
    """Build the one-record dictionary format used by PMDO .tile files."""
    blob_offset = 8 + 16
    key = 7 | (11 << 32)
    return b"".join(
        (
            struct.pack("<II", header_metadata, 1),
            struct.pack("<QQ", key, blob_offset),
            struct.pack("<Q", len(image)),
            image,
        )
    )


class TileContainerTests(unittest.TestCase):
    def parse(self, data: bytes):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "fixture.tile"
            path.write_bytes(data)
            return read_tile_sheet(path)

    def test_converter_header_metadata_8(self):
        sheet = self.parse(tile_container(8, png_bytes((255, 0, 0, 255))))
        self.assertEqual(set(sheet), {(7, 11)})
        self.assertEqual(sheet[(7, 11)].getpixel((0, 0)), (255, 0, 0, 255))

    def test_editor_header_metadata_24_does_not_move_directory(self):
        sheet = self.parse(tile_container(24, png_bytes((0, 255, 0, 255))))
        self.assertEqual(set(sheet), {(7, 11)})
        self.assertEqual(sheet[(7, 11)].getpixel((0, 0)), (0, 255, 0, 255))

    def test_multiple_keys_may_share_one_payload_offset(self):
        image = png_bytes((0, 0, 255, 255))
        blob_offset = 8 + 2 * 16
        data = b"".join((
            struct.pack("<II", 24, 2),
            struct.pack("<QQ", 7 | (11 << 32), blob_offset),
            struct.pack("<QQ", 9 | (13 << 32), blob_offset),
            struct.pack("<Q", len(image)),
            image,
        ))
        sheet = self.parse(data)
        self.assertEqual(set(sheet), {(7, 11), (9, 13)})
        self.assertEqual(sheet[(7, 11)].tobytes(), sheet[(9, 13)].tobytes())

    def test_rejects_truncated_directory(self):
        with self.assertRaisesRegex(ValueError, "truncated tile index"):
            self.parse(struct.pack("<II", 8, 1))

    def test_rejects_blob_overlapping_directory(self):
        data = struct.pack("<IIQQ", 24, 1, 0, 8) + b"padding"
        with self.assertRaisesRegex(ValueError, "overlaps tile index"):
            self.parse(data)

    def test_rejects_blob_header_outside_container(self):
        data = struct.pack("<IIQQ", 8, 1, 0, 10_000)
        with self.assertRaisesRegex(ValueError, "offset is out of range"):
            self.parse(data)

    def test_rejects_blob_payload_outside_container(self):
        data = struct.pack("<IIQQQ", 8, 1, 0, 24, 100) + b"short"
        with self.assertRaisesRegex(ValueError, "tile blob 0 is truncated"):
            self.parse(data)


if __name__ == "__main__":
    unittest.main()
