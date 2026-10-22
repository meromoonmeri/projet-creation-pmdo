"""Tests for the BPC decoder.

Synthetic byte blobs only; never touches real game content.
"""
from __future__ import annotations

import struct

from converter.decoders.bpc import (
    HEADER_MIN_SIZE,
    TILE_BYTES,
    decode,
    decode_tile_4bpp_to_indices,
)
from converter.stages.context import ROM_EXPECTED_HASH


def _pack_header(num_tiles: int = 5, num_chunks: int = 3,
                 bpa_slots: tuple = (0,) * 8,
                 chunk_w: int = 3, chunk_h: int = 3) -> bytes:
    return struct.pack(
        "<BBBBBBBBBBBB",
        chunk_w, chunk_h, num_tiles,
        *bpa_slots,
        num_chunks,
    )


def test_bpc_header_and_static_tiles() -> None:
    # 5 tiles = 4 non-null tiles = 4 * 32 = 128 bytes of pixel data.
    header = _pack_header(num_tiles=5)
    pixels = bytes((i & 0xFF) for i in range(128))
    blob = header + pixels
    r = decode(blob, rom_sha256=ROM_EXPECTED_HASH, rom_offset=0x1000)
    assert r.header.num_tiles == 5
    assert r.stats.tiles_expected == 4
    assert r.stats.tiles_decoded == 4
    assert r.stats.tile_bytes_consumed == 128
    assert r.tile_pixels == pixels
    assert r.stats.header_warnings == []


def test_bpc_bpa_slots_counted() -> None:
    header = _pack_header(num_tiles=1, bpa_slots=(4, 0, 8, 0, 0, 0, 0, 2))
    r = decode(header, rom_sha256=ROM_EXPECTED_HASH, rom_offset=0)
    assert r.header.bpa_slot_tiles == (4, 0, 8, 0, 0, 0, 0, 2)
    assert r.stats.used_bpa_slots == 3


def test_bpc_truncated_tile_block_warned() -> None:
    # 10 tiles = 9 non-null tiles = 288 bytes; give 64.
    header = _pack_header(num_tiles=10)
    blob = header + b"\x00" * 64
    r = decode(blob, rom_sha256=ROM_EXPECTED_HASH, rom_offset=0)
    assert r.stats.tiles_expected == 9
    assert r.stats.tiles_decoded == 2
    assert any("truncated" in w for w in r.stats.header_warnings)


def test_bpc_rejects_bogus_header() -> None:
    header = _pack_header(num_tiles=0, num_chunks=0, chunk_w=2, chunk_h=2)
    r = decode(header, rom_sha256=ROM_EXPECTED_HASH, rom_offset=0)
    assert r.tile_pixels == b""
    assert any("is zero" in w or "!= 3x3" in w
               for w in r.stats.header_warnings)


def test_decode_tile_4bpp_unpacks_two_pixels_per_byte() -> None:
    # 8x8 pixels @ 4bpp = 32 bytes per tile.
    tile = bytes([0x21, 0x43] + [0] * 30)
    idx = decode_tile_4bpp_to_indices(tile)
    assert len(idx) == 64
    # Low nibble first: 0x21 -> [1, 2]; 0x43 -> [3, 4]
    assert idx[:4] == [1, 2, 3, 4]
    assert idx[4:] == [0] * 60
