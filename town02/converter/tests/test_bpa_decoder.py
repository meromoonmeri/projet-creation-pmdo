"""Tests for the BPA decoder.

Synthetic byte blobs only; never touches real game content.
"""
from __future__ import annotations

import struct

from converter.decoders.bpa import (
    DURATION_ENTRY_SIZE,
    HEADER_FIXED_SIZE,
    TILE_BYTES,
    decode,
)
from converter.stages.context import ROM_EXPECTED_HASH


def _pack_bpa(num_tiles: int, durations: list[int],
              frame_pixels: list[list[bytes]]) -> bytes:
    """Build a synthetic BPA byte stream.

    `frame_pixels[frame_idx]` is a list of exactly `num_tiles` items,
    each a 32-byte tile.
    """
    n_frames = len(durations)
    header = struct.pack("<Bh", num_tiles, n_frames)
    dur_blob = struct.pack(f"<{n_frames}i", *durations)
    tiles = b""
    for frame in frame_pixels:
        for tile in frame:
            assert len(tile) == TILE_BYTES
            tiles += tile
    return header + dur_blob + tiles


def _synth_tile(byte_value: int) -> bytes:
    return bytes([byte_value] * TILE_BYTES)


def test_bpa_decodes_all_frames() -> None:
    # 2 tiles, 3 frames, distinctive pixel bytes so we can tell frames apart.
    frames = [
        [_synth_tile(0x11), _synth_tile(0x12)],
        [_synth_tile(0x21), _synth_tile(0x22)],
        [_synth_tile(0x31), _synth_tile(0x32)],
    ]
    blob = _pack_bpa(num_tiles=2, durations=[10, 20, 30],
                     frame_pixels=frames)
    r = decode(blob, rom_sha256=ROM_EXPECTED_HASH, rom_offset=0x2000)
    assert r.header.num_tiles == 2
    assert r.header.num_frames == 3
    assert r.header.frame_durations == (10, 20, 30)
    assert r.stats.header_warnings == []
    assert r.stats.frames_decoded == 3
    assert r.stats.tiles_decoded == 6
    # Frame ordering preserved, tile ordering preserved.
    assert r.frame_pixels[0][0][0] == 0x11
    assert r.frame_pixels[0][1][0] == 0x12
    assert r.frame_pixels[2][1][0] == 0x32


def test_bpa_truncated_body_reports_and_keeps_partial_frames() -> None:
    # Announce 3 frames but only supply 2 frames' worth of pixels.
    frames = [
        [_synth_tile(0x11), _synth_tile(0x12)],
        [_synth_tile(0x21), _synth_tile(0x22)],
    ]
    blob = _pack_bpa(num_tiles=2, durations=[10, 20, 30],
                     frame_pixels=frames)
    r = decode(blob, rom_sha256=ROM_EXPECTED_HASH, rom_offset=0)
    assert r.stats.frames_decoded == 2
    assert any("truncated" in w for w in r.stats.header_warnings)


def test_bpa_rejects_bogus_header() -> None:
    # num_tiles=0 => stop early with a warning, no pixel data.
    blob = struct.pack("<Bh", 0, 1) + struct.pack("<i", 4)
    r = decode(blob, rom_sha256=ROM_EXPECTED_HASH, rom_offset=0)
    assert r.frame_pixels == []
    assert any("is zero" in w for w in r.stats.header_warnings)


def test_bpa_header_size_calculation_matches_spec() -> None:
    # Just confirm the fixed constants a caller might rely on.
    assert HEADER_FIXED_SIZE == 3
    assert DURATION_ENTRY_SIZE == 4
    assert TILE_BYTES == 32
