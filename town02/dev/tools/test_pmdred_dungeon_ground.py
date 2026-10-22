#!/usr/bin/env python3
"""Focused regressions for dungeon-backed PMD Red Ground reconstruction."""

from __future__ import annotations

import os
import struct
import tempfile
import unittest
from pathlib import Path

import audit_pmdred_eu_rom as ground_audit
from pmdred_dungeon_ground import (
    CEL_DECOMPRESSED_SIZE,
    CEX_DECOMPRESSED_SIZE,
    EXPECTED_EU_ROM_SHA256,
    GBA_CYCLES_PER_FRAME,
    GBA_FRAME_RATE_HZ,
    GBA_MASTER_CLOCK_HZ,
    GBA_ROM_BASE,
    MATERIAL_STRIDE,
    AnimationRecord,
    ArchiveEntry,
    DungeonArchive,
    DungeonGroundRenderer,
    PhysicalSpan,
    ReconstructionError,
    RomView,
    compose_ground_chunks,
    decode_bma_auxiliary_layers,
    decode_pmd_text_escapes,
    decompress_at4px,
    differential_validate_at4px,
    palette_at_tick,
    parse_french_dungeon_names,
    parse_ground_palette,
    parse_mapparam,
    save_animation_preview,
    sha256,
)


def make_at4px(
    tokens: list[tuple[bool, bytes]],
    output_size: int,
    flags: bytes = bytes(range(1, 10)),
) -> bytes:
    command_stream = bytearray()
    for group_start in range(0, len(tokens), 8):
        group = tokens[group_start : group_start + 8]
        control = 0
        for bit, (literal, _) in enumerate(group):
            if literal:
                control |= 0x80 >> bit
        command_stream.append(control)
        for _, data in group:
            command_stream.extend(data)
    total = 18 + len(command_stream)
    return (
        b"AT4PX"
        + struct.pack("<H", total)
        + flags
        + struct.pack("<H", output_size)
        + command_stream
    )


class At4pxDecoderTests(unittest.TestCase):
    def test_literals_and_one_byte_special_pattern_token(self) -> None:
        container = make_at4px(
            [(True, b"A"), (True, b"B"), (False, b"\x13")],
            output_size=4,
        )
        result, evidence = decompress_at4px(container, context="synthetic")
        self.assertEqual(result, b"AB\x33\x33")
        self.assertEqual(evidence["literal_tokens"], 2)
        self.assertEqual(evidence["special_pattern_tokens"], 1)
        self.assertEqual(evidence["back_reference_tokens"], 0)
        self.assertEqual(evidence["container_length"], len(container))

    def test_backreference_uses_12_bit_displacement_and_overlap(self) -> None:
        literals = [(True, bytes((index & 0xFF,))) for index in range(4096)]
        # command 3, displacement 0x0FF => source byte 255 at this point.
        container = make_at4px(literals + [(False, b"\x00\xff")], output_size=4099)
        result, evidence = decompress_at4px(container, context="backref")
        self.assertEqual(result[-3:], b"\xff\x00\x01")
        self.assertEqual(evidence["back_reference_tokens"], 1)

    def test_sequential_flag_remapping_can_cascade(self) -> None:
        # Initial command 6 matches flag 0 and becomes 31, then matches flag 1
        # and becomes 30. A list.index shortcut would incorrectly stop at 31.
        flags = bytes((3, 28, 1, 2, 4, 5, 6, 7, 8))
        container = make_at4px([(False, b"\x35")], output_size=2, flags=flags)
        result, evidence = decompress_at4px(container, context="sequential flags")
        self.assertEqual(result, b"\x56\x66")
        self.assertEqual(evidence["special_pattern_tokens"], 1)

    def test_rejects_truncated_container(self) -> None:
        container = make_at4px([(True, b"A")], output_size=1)
        with self.assertRaisesRegex(ReconstructionError, "truncated"):
            decompress_at4px(container[:-1], context="truncated")


class RomAndSiroTests(unittest.TestCase):
    def test_rom_pointer_and_span_bounds(self) -> None:
        rom = RomView(bytes(range(32)))
        self.assertEqual(rom.resolve(GBA_ROM_BASE + 31, 1, "last").offset, 31)
        with self.assertRaises(ReconstructionError):
            rom.resolve(GBA_ROM_BASE + 32, 1, "end")
        with self.assertRaises(ReconstructionError):
            rom.span(30, 3, "overread")

    def test_siro_root_pointer_is_at_wrapper_plus_four(self) -> None:
        data = bytearray(128)
        data[0x20:0x24] = b"SIRO"
        data[0x24:0x28] = struct.pack("<I", GBA_ROM_BASE + 0x60)
        data[0x28:0x2C] = struct.pack("<I", 0)  # specifically not the root
        data[0x60:0x65] = b"AT4PX"
        archive = object.__new__(DungeonArchive)
        archive.rom = RomView(bytes(data))
        entry = ArchiveEntry(
            0,
            "test",
            0,
            GBA_ROM_BASE + 0x20,
            PhysicalSpan(0, 1, "name"),
            PhysicalSpan(0x20, 16, "wrapper"),
        )
        self.assertEqual(archive.siro_root(entry).offset, 0x60)

    def test_siro_rejects_out_of_rom_root(self) -> None:
        data = bytearray(64)
        data[0x20:0x24] = b"SIRO"
        data[0x24:0x28] = struct.pack("<I", GBA_ROM_BASE + len(data))
        archive = object.__new__(DungeonArchive)
        archive.rom = RomView(bytes(data))
        entry = ArchiveEntry(
            0,
            "test",
            0,
            GBA_ROM_BASE + 0x20,
            PhysicalSpan(0, 1, "name"),
            PhysicalSpan(0x20, 16, "wrapper"),
        )
        with self.assertRaises(ReconstructionError):
            archive.siro_root(entry)

    def test_direct_stream_cannot_cross_its_archive_container(self) -> None:
        container = make_at4px([(True, b"A")], output_size=1)
        archive = object.__new__(DungeonArchive)
        archive.rom = RomView(container + b"next entry")
        entry = ArchiveEntry(
            0,
            "test",
            0,
            GBA_ROM_BASE,
            PhysicalSpan(0, 1, "name"),
            PhysicalSpan(0, len(container) - 1, "truncated archive container"),
        )
        with self.assertRaisesRegex(ReconstructionError, "exceeds archive container"):
            archive.stream_span(entry)


class BmaAuxiliaryTests(unittest.TestCase):
    @staticmethod
    def fixture(collision_layers: int = 2, unknown: bool = True) -> bytes:
        # 2x2 camera, one 2x1 graphical row. The optional data block is
        # [0, 8, 8, 0]. Collision streams exercise vertical XOR reconstruction.
        header = bytes((2, 2, 2, 2, 2, 1)) + struct.pack(
            "<HHH", 1, int(unknown), collision_layers
        )
        graphical_layer = bytes((0x00,))
        unknown_data = bytes((0x00, 0x81, 0x08, 0x00)) if unknown else b""
        collision1 = bytes((0x00, 0x81, 0x00)) if collision_layers >= 1 else b""
        collision2 = bytes((0x80, 0x01, 0x80)) if collision_layers >= 2 else b""
        return header + graphical_layer + unknown_data + collision1 + collision2

    def test_unknown_data_and_two_collision_layers_remain_separate(self) -> None:
        data = self.fixture()
        decoded = decode_bma_auxiliary_layers(data, "synthetic")
        self.assertEqual((decoded.width, decoded.height), (2, 2))
        self.assertEqual(decoded.unknown_data, bytes((0, 8, 8, 0)))
        self.assertEqual(decoded.collisions[0], bytes((0, 1, 1, 1)))
        self.assertEqual(decoded.collisions[1], bytes((1, 0, 1, 1)))
        self.assertEqual(decoded.encoded_end, len(data))
        self.assertEqual(
            decoded.metadata["unknown_data_stream"]["distinct_values"], [0, 8]
        )

    def test_zero_and_one_collision_layer_boundaries(self) -> None:
        zero = decode_bma_auxiliary_layers(self.fixture(0, False), "zero")
        self.assertIsNone(zero.unknown_data)
        self.assertEqual(zero.collisions, ())
        self.assertEqual(zero.encoded_end, len(self.fixture(0, False)))

        one = decode_bma_auxiliary_layers(self.fixture(1, False), "one")
        self.assertIsNone(one.unknown_data)
        self.assertEqual(one.collisions, (bytes((0, 1, 1, 1)),))
        self.assertEqual(one.encoded_end, len(self.fixture(1, False)))

    def test_each_auxiliary_stream_rejects_truncation(self) -> None:
        complete = self.fixture()
        # Exercise truncation within the collision2 stream and at every earlier
        # optional-stream boundary, rather than relying on a single EOF case.
        for cut in (13, 16, 17, 20, 21, len(complete) - 1):
            with self.subTest(cut=cut), self.assertRaises(ReconstructionError):
                decode_bma_auxiliary_layers(complete[:cut], "truncated")


class CompositionTests(unittest.TestCase):
    def setUp(self) -> None:
        cex = bytearray(CEX_DECOMPRESSED_SIZE)
        for mask in range(0x300):
            cex[mask * 3] = mask % 250
        self.cex = bytes(cex)

    def test_regular_mask_order_and_material_stride(self) -> None:
        terrain = bytearray(MATERIAL_STRIDE * 3)
        for y in range(3):
            for x in range(3):
                terrain[y * MATERIAL_STRIDE + x] = 1
        chunks = compose_ground_chunks(bytes(terrain), 3, 0, self.cex, default=0)
        self.assertEqual(len(chunks), MATERIAL_STRIDE * 3)
        self.assertEqual(chunks[1 * MATERIAL_STRIDE + 1], 0x2FF % 250)
        # Top-left has S, SE, and E neighbors => mask bits 0, 1, and 2.
        self.assertEqual(chunks[0], 0x207 % 250)
        # Conversion still includes padded column 63 rather than tightening to a
        # declared camera width.
        self.assertEqual(chunks[MATERIAL_STRIDE - 1], 0x0FF % 250)

    def test_water_default_controls_outside_neighborhood(self) -> None:
        terrain = bytearray(MATERIAL_STRIDE)
        terrain[0] = 3
        dry = compose_ground_chunks(bytes(terrain), 1, 0, self.cex, default=0)
        water = compose_ground_chunks(bytes(terrain), 1, 0, self.cex, default=3)
        self.assertEqual(dry[0], 0x100 % 250)
        self.assertEqual(water[0], 0x1FB % 250)

    def test_special_emap_direct_and_outside_default(self) -> None:
        emap = bytes(index % 250 for index in range(24 * 24))
        terrain = bytes(MATERIAL_STRIDE * 25)
        chunks = compose_ground_chunks(terrain, 25, 64, emap, default=0)
        self.assertEqual(chunks[0], 0)
        self.assertEqual(chunks[23 * MATERIAL_STRIDE + 23], 575 % 250)
        self.assertEqual(chunks[24 * MATERIAL_STRIDE], 0)


class PaletteAndRenderingTests(unittest.TestCase):
    def test_pmd_text_hex_escapes(self) -> None:
        self.assertEqual(decode_pmd_text_escapes("Fosse d~27Argent"), "Fosse d'Argent")
        self.assertEqual(decode_pmd_text_escapes("tilde~ZZ"), "tilde~ZZ")

    def base_palette(self) -> list[tuple[int, int, int, int]]:
        palette = [(0, 0, 0, 0)] * 192
        palette[165] = (24, 40, 56, 9)
        return palette

    def test_palette_parser_requires_exact_192_records_and_forces_row_zero(
        self,
    ) -> None:
        raw = bytes(index % 256 for index in range(192 * 4))
        parsed = parse_ground_palette(raw)
        self.assertEqual(len(parsed), 192)
        for row in range(12):
            self.assertEqual(parsed[row * 16], (0, 0, 0, 0))
        with self.assertRaises(ReconstructionError):
            parse_ground_palette(raw + b"\0\0\0\0")

    def test_palette_startup_retains_raw_until_first_expiry(self) -> None:
        animations = [
            AnimationRecord(0, 0, 0, (), PhysicalSpan(0, 4, "inactive"))
            for _ in range(32)
        ]
        animations[5] = AnimationRecord(
            5, 2, 3, ((8, 16, 24, 0), (248, 240, 232, 0)), PhysicalSpan(0, 12, "active")
        )
        base = self.base_palette()
        self.assertEqual(palette_at_tick(base, animations, 0)[165], base[165])
        self.assertEqual(palette_at_tick(base, animations, 2)[165], base[165])
        self.assertEqual(palette_at_tick(base, animations, 3)[165], (8, 16, 24, 0))
        self.assertEqual(palette_at_tick(base, animations, 6)[165], (248, 240, 232, 0))

    def test_renderer_decodes_4bpp_and_crops_to_camera(self) -> None:
        font = bytes((0x11,)) * (512 * 32)
        cel = bytearray(CEL_DECOMPRESSED_SIZE)
        # Every one of the nine 8x8 tiles in chunk 0 references tile 0/palette 0.
        renderer = DungeonGroundRenderer(font, bytes(cel))
        palette = [(0, 0, 0, 0)] * 192
        palette[1] = (248, 0, 0, 0)
        chunks = [0] * MATERIAL_STRIDE
        image = renderer.render(chunks, 1, 1, 17, 19, palette)
        self.assertEqual(image.size, (17, 19))
        self.assertEqual(image.getpixel((0, 0)), (255, 0, 0))
        self.assertEqual(image.getpixel((16, 18)), (255, 0, 0))

    def test_apng_milliseconds_use_the_gba_frame_rate(self) -> None:
        self.assertAlmostEqual(
            GBA_FRAME_RATE_HZ,
            GBA_MASTER_CLOCK_HZ / GBA_CYCLES_PER_FRAME,
        )
        renderer = DungeonGroundRenderer(
            bytes((0x11,)) * 32, bytes(CEL_DECOMPRESSED_SIZE)
        )
        records = [
            AnimationRecord(
                0,
                2,
                16,
                ((0, 0, 0, 0), (8, 8, 8, 0)),
                PhysicalSpan(0, 12, "active"),
            )
        ]
        geometry = {
            "map_width_chunks": 1,
            "map_height_chunks": 1,
            "map_width_tiles": 3,
            "map_height_tiles": 3,
        }
        with tempfile.TemporaryDirectory() as temp:
            metadata = save_animation_preview(
                Path(temp) / "preview.png",
                renderer,
                [0] * MATERIAL_STRIDE,
                geometry,
                [(0, 0, 0, 0)] * 192,
                records,
                {0},
                max_frames=1,
            )
        self.assertEqual(metadata["frame_duration_ticks"], [16])
        self.assertEqual(metadata["frame_duration_ms"], [268])
        self.assertEqual(
            metadata["timing"]["gba_cycles_per_frame"], GBA_CYCLES_PER_FRAME
        )


@unittest.skipUnless(
    os.environ.get("PMDRED_EU_ROM"), "set PMDRED_EU_ROM for integration tests"
)
class AuthoritativeEuRomTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.rom = Path(os.environ["PMDRED_EU_ROM"]).read_bytes()
        if sha256(cls.rom) != EXPECTED_EU_ROM_SHA256:
            raise unittest.SkipTest(
                "PMDRED_EU_ROM is not the authoritative European ROM"
            )
        cls.archive = DungeonArchive(cls.rom)

    def test_all_204_at4px_streams_match_skytemple(self) -> None:
        report = differential_validate_at4px(self.archive)
        self.assertEqual(report["stream_count"], 204)
        self.assertTrue(report["all_match"])
        self.assertEqual(sum(row["match"] for row in report["entries"]), 204)

    def test_all_27_mappings_select_canonical_eu_tilesets(self) -> None:
        expected = {
            "d01p02": 14,
            "d02p02": 50,
            "d03p02": 64,
            "d04p02": 65,
            "d05p02": 2,
            "d06p02": 42,
            "d06p03": 66,
            "d09p02": 46,
            "d09p03": 67,
            "d10p02": 36,
            "d10p03": 68,
            "d11p02": 47,
            "d11p03": 69,
            "d12p02": 48,
            "d12p04": 70,
            "d13p02": 35,
            "d13p03": 71,
            "d14p01": 74,
            "d15p01": 73,
            "d16p01": 59,
            "d17p01": 29,
            "d18p01": 9,
            "d19p01": 72,
            "d20p01": 38,
            "d21p01": 75,
            "d23p01": 7,
            "d25p01": 61,
        }
        counts = ground_audit.parse_dungeon_floor_counts(self.rom)
        files = ground_audit.parse_map_files_table(self.rom)
        conversions = ground_audit.parse_ground_conversion_table(self.rom, files)
        mappings, _ = ground_audit.parse_map_to_dungeon_table(
            self.rom, conversions, counts
        )
        params = parse_mapparam(self.archive, counts)
        actual = {}
        for mapping in mappings:
            selector = params["selectors"][mapping["dungeon_id"]]["rows"][
                mapping["runtime_floor_zero_based"]
            ]
            actual[mapping["stable_ground_id"]] = params["properties"][
                selector["property_index"]
            ]["tileset"]
        self.assertEqual(actual, expected)

    def test_french_names_expand_runtime_hex_escapes(self) -> None:
        names = parse_french_dungeon_names(self.rom)
        self.assertEqual(names[20]["primary"], "Fosse d'Argent")
        self.assertEqual(names[20]["strings"][0]["encoded_text"], "Fosse d~27Argent")


if __name__ == "__main__":
    unittest.main()
