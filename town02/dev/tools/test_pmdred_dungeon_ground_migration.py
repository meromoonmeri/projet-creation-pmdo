"""Focused regressions for direct Ground migration packing and scheduling."""

from __future__ import annotations

import struct
import tempfile
import unittest
from pathlib import Path

from migrate_pmdred_dungeon_grounds import (
    color_state_ids,
    reached_state_keys,
    write_tile,
)
from pmdred_dungeon_ground import AnimationRecord, PhysicalSpan
from validate_pmdred_dungeon_ground_migration import read_tile


class ColorStateTests(unittest.TestCase):
    def test_gba_quantization_coalesces_unobservable_source_colors(self) -> None:
        record = AnimationRecord(
            0,
            2,
            3,
            ((248, 0, 0, 0), (249, 0, 0, 255)),
            PhysicalSpan(0, 12, "synthetic"),
        )
        raw, cycle, colors = color_state_ids(record, (240, 0, 0, 7))
        self.assertEqual(raw, 0)
        self.assertEqual(cycle, [1, 1])
        self.assertEqual(colors, [(247, 0, 0), (255, 0, 0)])

    def test_reached_keys_include_raw_startup_and_complete_steady_cycle(self) -> None:
        records = [
            {"duration": 2, "raw": 0, "cycle": [1, 2]},
            {"duration": 3, "raw": 4, "cycle": [5, 6, 7]},
        ]
        keys = reached_state_keys(records)
        self.assertIn((0, 4), keys)
        self.assertTrue(all(len(key) == 2 for key in keys))
        # Every individual steady color must be represented by at least one
        # actually reached joint state; no Cartesian product is fabricated.
        self.assertEqual({key[0] for key in keys}, {0, 1, 2})
        self.assertEqual({key[1] for key in keys}, {4, 5, 6, 7})
        self.assertLess(len(keys), 3 * 4)


class TileAtlasTests(unittest.TestCase):
    def test_virtual_atlas_deduplicates_png_payloads_but_not_locations(self) -> None:
        # Minimal valid 8x8 RGB PNGs are easiest to obtain from Pillow through
        # the production helper's accepted payload interface.
        from migrate_pmdred_dungeon_grounds import png_bytes
        from PIL import Image

        red = png_bytes(Image.new("RGB", (8, 8), (255, 0, 0)))
        blue = png_bytes(Image.new("RGB", (8, 8), (0, 0, 255)))
        entries = [(0, red), (1, red), (1 << 32, blue)]
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "atlas.tile"
            write_tile(path, entries)
            decoded = read_tile(path)
            raw = path.read_bytes()
        self.assertEqual(set(decoded), {(0, 0), (1, 0), (0, 1)})
        self.assertEqual(decoded[(0, 0)], decoded[(1, 0)])
        # Both red table rows point at the same binary payload offset.
        first_offset = struct.unpack_from("<Q", raw, 8 + 8)[0]
        second_offset = struct.unpack_from("<Q", raw, 24 + 8)[0]
        self.assertEqual(first_offset, second_offset)


if __name__ == "__main__":
    unittest.main()
