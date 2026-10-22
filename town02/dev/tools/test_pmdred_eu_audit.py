#!/usr/bin/env python3
"""Focused regression tests for the dependency-free EU Ground decoder."""

from __future__ import annotations

import json
import os
import struct
import unittest
from pathlib import Path

import audit_pmdred_eu_rom as audit


class ByteNrlTests(unittest.TestCase):
    def test_zero_run_uses_all_seven_count_bits(self) -> None:
        output, end, stats = audit.decode_byte_nrl(bytes((0x7F,)), 0, 128, "zero-run")
        self.assertEqual(output, bytes(128))
        self.assertEqual(end, 1)
        self.assertEqual(stats["produced"], 128)
        self.assertEqual(stats["output_overshoot"], 0)

    def test_zero_run_is_atomic_and_may_overshoot_target(self) -> None:
        output, end, stats = audit.decode_byte_nrl(bytes((0x7F,)), 0, 1, "atomic-run")
        self.assertEqual(output, b"\0")
        self.assertEqual(end, 1)
        self.assertEqual(stats["produced"], 128)
        self.assertEqual(stats["output_overshoot"], 127)

    def test_repeat_and_literal_ranges(self) -> None:
        repeated, repeat_end, _ = audit.decode_byte_nrl(bytes((0x81, 0xAB)), 0, 2, "repeat")
        literal, literal_end, _ = audit.decode_byte_nrl(bytes((0xC1, 0x12, 0x34)), 0, 2, "literal")
        self.assertEqual(repeated, b"\xAB\xAB")
        self.assertEqual(repeat_end, 2)
        self.assertEqual(literal, b"\x12\x34")
        self.assertEqual(literal_end, 3)


class BpcNormalizationTests(unittest.TestCase):
    def test_minimal_bpc_interleaves_high_then_low_planes(self) -> None:
        # One synthetic null tile, one stored 2x2 chunk.  The high plane is a
        # four-byte zero run; the low plane is a four-byte literal run.
        header = struct.pack("<8H", 2, 2, 1, 0, 0, 0, 0, 2)
        source = header + bytes((0x03, 0xC3, 1, 2, 3, 4))
        normalized, extent, metadata = audit.parse_bpc(source, "synthetic")
        self.assertEqual(extent, len(source))
        self.assertEqual(normalized[:16], header)
        self.assertEqual(normalized[16:], struct.pack("<4H", 1, 2, 3, 4))
        self.assertEqual(metadata["chunk_entry_count"], 4)


class TileStreamTests(unittest.TestCase):
    def test_literal_tile_stream_halfword_alignment_is_relative(self) -> None:
        source = bytes((0x1F,)) + bytes(range(32)) + b"\x00"
        output, end, stats = audit.decode_bpc_tiles(source, 0, 32, "tile")
        self.assertEqual(output, bytes(range(32)))
        self.assertEqual(end, 34)
        self.assertEqual(stats["produced"], 32)
        self.assertEqual(stats["compressed_bytes_before_halfword_alignment"], 33)
        self.assertEqual(stats["halfword_alignment_bytes"], 1)


class BmaTests(unittest.TestCase):
    @staticmethod
    def pair24(first: int, second: int) -> bytes:
        return (first | (second << 12)).to_bytes(3, "little")

    def test_literal_rows_are_xored_with_previous_row(self) -> None:
        # Width three is physically decoded as two pairs per row.  The fourth
        # value is row padding and must not enter the logical 3x2 map.
        first_row = bytes((0xC1,)) + self.pair24(1, 2) + self.pair24(3, 4)
        second_row = bytes((0x81,)) + self.pair24(1, 1)
        layers, end, stats = audit.decode_bma_layers(
            first_row + second_row, 0, 3, 2, 1, "bma"
        )
        self.assertEqual(layers, [[1, 2, 3, 0, 3, 2]])
        self.assertEqual(end, len(first_row + second_row))
        self.assertEqual(stats[0]["row_output_overshoot"], 2)

    def test_data_and_collision_layers_are_decoded_and_hashed(self) -> None:
        # One 2x1 map layer (zero-pair), four data bytes, then 2x2 collision
        # deltas [0,1]/[1,0], yielding logical collision [0,1]/[1,1].
        header = bytes((2, 2, 2, 2, 2, 1)) + struct.pack("<HHH", 1, 1, 1)
        layer = bytes((0x00,))
        data_layer = bytes((0xC3, 4, 3, 2, 1))
        collision = bytes((0x00, 0x81, 0x00))
        source = header + layer + data_layer + collision
        _, extent, metadata = audit.parse_bma(source, "bma")
        self.assertEqual(extent, len(source))
        self.assertEqual(metadata["data_layer_stream"]["nonzero_cells"], 4)
        self.assertEqual(metadata["collision_streams"][0]["solid_cells"], 3)
        self.assertEqual(metadata["collision_streams"][0]["walkable_cells"], 1)


class GuardAndInferenceTests(unittest.TestCase):
    def test_eu_dependency_table_does_not_use_us_bound(self) -> None:
        self.assertEqual(audit.MAP_FILES_TABLE_COUNT, 262)
        self.assertEqual(len(audit.MAP_FILES_TABLE_FIELDS), 7)

    def test_truncated_stream_raises_audit_error(self) -> None:
        with self.assertRaises(audit.AuditError):
            audit.decode_byte_nrl(b"", 0, 1, "truncated")
        with self.assertRaises(audit.AuditError):
            audit.decode_generic_nrl(bytes((0x80,)), 0, 1, "truncated")

    def test_bpa_inference_includes_orphan_but_not_numbered_bpl(self) -> None:
        names = {"W03P01", "W03P011", "S01", "W04"}
        self.assertEqual(audit.infer_bpa_names(names, []), {"W03P011"})


@unittest.skipUnless(os.environ.get("PMDRED_EU_ROM"), "set PMDRED_EU_ROM for integration test")
class RegionalTableIntegrationTests(unittest.TestCase):
    def test_complete_dependency_table_includes_world_maps(self) -> None:
        rom = Path(os.environ["PMDRED_EU_ROM"]).read_bytes()
        rows = audit.parse_map_files_table(rom)
        self.assertEqual(len(rows), 262)
        self.assertEqual(
            [row["bpl"] for row in rows[-7:]],
            ["W01", "W03P01", "W03P02", "W03P03", "W04", "W05", "W06"],
        )
        conversions = audit.parse_ground_conversion_table(rom, rows)
        self.assertEqual(len(conversions), 246)
        self.assertEqual(conversions[-1]["map_file_id"], 254)
        floor_counts = audit.parse_dungeon_floor_counts(rom)
        self.assertEqual(len(floor_counts), 64)
        dungeon_maps, sentinel = audit.parse_map_to_dungeon_table(
            rom, conversions, floor_counts
        )
        self.assertEqual(len(dungeon_maps), 27)
        self.assertEqual(sentinel["map_id"], -1)
        self.assertEqual(
            (dungeon_maps[0]["map_id"], dungeon_maps[0]["dungeon_id"],
             dungeon_maps[0]["requested_floor_zero_based"]),
            (184, 0, 100),
        )


@unittest.skipUnless(os.environ.get("PMDRED_EU_ROM"), "set PMDRED_EU_ROM for integration test")
class DeterministicReportTests(unittest.TestCase):
    def test_report_reproduction_is_byte_deterministic(self) -> None:
        rom_path = Path(os.environ["PMDRED_EU_ROM"])
        rom = rom_path.read_bytes()
        first = audit.audit_rom(rom, rom_path.name)
        second = audit.audit_rom(rom, rom_path.name)
        options = {"ensure_ascii": False, "sort_keys": True, "indent": 2}
        self.assertEqual(
            json.dumps(first, **options) + "\n",
            json.dumps(second, **options) + "\n",
        )


if __name__ == "__main__":
    unittest.main()
