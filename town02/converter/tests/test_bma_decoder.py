"""Tests for the BMA decoder.

Builds synthetic BMA byte streams (never any real game content) to
prove the header parser, the NRL layer decompressor, and the collision
layer reader behave correctly on well-formed inputs and fail honestly
on malformed ones.
"""
from __future__ import annotations

import struct

import pytest

from converter.decoders.bma import (
    HEADER_SIZE,
    _decompress_layer_nrl,
    _read_header,
    _validate_header,
    decode,
)
from converter.stages.context import ROM_EXPECTED_HASH


# ---------------------------------------------------------------- header


def _pack_header(
    mw_t: int, mh_t: int,
    mw_c: int, mh_c: int,
    n_layers: int = 1,
    has_data: int = 0,
    has_coll: int = 1,
    tiling_w: int = 3, tiling_h: int = 3,
) -> bytes:
    return struct.pack(
        "<BBBBBBhhh",
        mw_t, mh_t, tiling_w, tiling_h, mw_c, mh_c,
        n_layers, has_data, has_coll,
    )


def test_header_reads_all_fields() -> None:
    h = _read_header(_pack_header(45, 42, 15, 14, n_layers=2,
                                  has_data=1, has_coll=2))
    assert h.map_width_tiles == 45 and h.map_height_tiles == 42
    assert h.tiling_width == 3 and h.tiling_height == 3
    assert h.map_width_chunks == 15 and h.map_height_chunks == 14
    assert h.num_layers == 2 and h.has_data_layer == 1
    assert h.has_collision == 2


def test_header_validation_catches_common_faults() -> None:
    # Bogus tiling
    warnings = _validate_header(_read_header(
        _pack_header(9, 9, 3, 3, tiling_w=2, tiling_h=2)
    ))
    assert any("tiling" in w for w in warnings)

    # width_chunks * 3 != width_tiles
    warnings = _validate_header(_read_header(
        _pack_header(10, 9, 3, 3)     # 3*3=9, not 10
    ))
    assert any("width_chunks" in w for w in warnings)


def test_header_short_input_raises() -> None:
    with pytest.raises(ValueError, match="too short"):
        _read_header(b"\x00" * (HEADER_SIZE - 1))


# ---------------------------------------------------------------- NRL


def test_nrl_zero_run_full_row() -> None:
    """One command byte 'cmd < 0x80' emits (cmd+1) pairs of zeros."""
    # width=6 chunks, height=1 row -> need 6 zeros = 3 pairs.
    # cmd=0x02 => 3 pairs of zero.
    blob = bytes([0x02])
    chunks, consumed = _decompress_layer_nrl(blob, 0,
                                             width_chunks=6, height_chunks=1)
    assert chunks == [0] * 6
    assert consumed == 1


def test_nrl_run_of_same_value_first_row() -> None:
    """cmd 0x80..0xBF: one 3-byte value, repeated (cmd - 0x7F) pairs of times."""
    # Emit 2 pairs (=4 chunks) of value 0x123/0x456.
    # cmd = 0x80 + (2 - 1) = 0x81 in this scheme; count_pairs = cmd - 0x7F = 2.
    value = (0x123) | (0x456 << 12)     # 3-byte little-endian
    b3 = bytes([value & 0xFF, (value >> 8) & 0xFF, (value >> 16) & 0xFF])
    blob = bytes([0x81]) + b3
    chunks, consumed = _decompress_layer_nrl(
        blob, 0, width_chunks=4, height_chunks=1
    )
    assert chunks == [0x123, 0x456, 0x123, 0x456]
    assert consumed == 4


def test_nrl_raw_block_first_row() -> None:
    """cmd 0xC0..0xFF: (cmd - 0xBF) pairs each with its OWN 3-byte value."""
    # 2 pairs = 4 chunks: (0x111,0x222) then (0x333,0x444).
    v1 = 0x111 | (0x222 << 12)
    v2 = 0x333 | (0x444 << 12)
    b1 = bytes([v1 & 0xFF, (v1 >> 8) & 0xFF, (v1 >> 16) & 0xFF])
    b2 = bytes([v2 & 0xFF, (v2 >> 8) & 0xFF, (v2 >> 16) & 0xFF])
    cmd = 0xBF + 2         # 2 pairs -> 0xC1
    blob = bytes([cmd]) + b1 + b2
    chunks, _c = _decompress_layer_nrl(blob, 0, width_chunks=4, height_chunks=1)
    assert chunks == [0x111, 0x222, 0x333, 0x444]


def test_nrl_second_row_xors_against_first() -> None:
    """On rows > 0 each emitted value XORs against the corresponding
    value 64 positions earlier. We build a 64-wide row (32 pairs)
    followed by a second row that emits 0-runs, and check the output
    equals the first row bit-for-bit."""
    # Row 1: 32 pairs of (0x100, 0x200) using run compression.
    v = 0x100 | (0x200 << 12)
    b3 = bytes([v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF])
    # cmd for 32 pairs run: cmd - 0x7F = 32 -> cmd = 0x9F
    row1 = bytes([0x9F]) + b3

    # Row 2: 32 pairs of zeros (which after XOR reproduces row 1).
    # cmd for 32 pairs of zeros: cmd + 1 = 32 -> cmd = 0x1F
    row2 = bytes([0x1F])

    blob = row1 + row2
    chunks, _c = _decompress_layer_nrl(blob, 0, width_chunks=64, height_chunks=2)
    # First 64 chunks: alternating 0x100 / 0x200.
    for i in range(32):
        assert chunks[i * 2] == 0x100 and chunks[i * 2 + 1] == 0x200
    # Second 64 chunks: XORed with previous row => zero XOR ref = ref
    for i in range(32):
        assert chunks[64 + i * 2] == 0x100
        assert chunks[64 + i * 2 + 1] == 0x200


# ---------------------------------------------------------------- decode


def test_decode_full_synthetic_bma() -> None:
    """One-layer BMA, 6x3 tiles = 2x1 chunks, one collision layer."""
    header = _pack_header(mw_t=6, mh_t=3, mw_c=2, mh_c=1,
                          n_layers=1, has_data=0, has_coll=1)
    # Layer body: emit 2 pairs of zeros (cmd=0x01 -> 2 pairs, 4 chunks).
    # We only have 2 chunks per row; a single pair is enough.
    # cmd=0x00 -> 1 pair (2 chunks) of zero -> fills our 2-wide row.
    layer_body = bytes([0x00])
    # Collision (EU RLE + vertical XOR delta): decoded target is
    # 9 solid cells then 9 empty on the 6x3 grid, i.e. row0 all solid,
    # row1 = 3 solid + 3 empty, row2 empty. The delta stream (value =
    # cell XOR cell-above) is: 6x1, 3x0, 6x1, 3x0. RLE bytes encode
    # bit7=value, low bits=count-1.
    collision = bytes([0x80 | 5, 0x02, 0x80 | 5, 0x02])
    blob = header + layer_body + collision

    ir, stats = decode(
        blob,
        ground_id="synth_bma",
        rom_sha256=ROM_EXPECTED_HASH,
        rom_offset=0x1000,
    )

    assert stats.header_warnings == []
    assert stats.layers_decoded == 1
    assert stats.collision_layers_decoded == 1
    assert stats.data_layer_present is False

    assert len(ir.layers) == 1
    assert ir.layers[0].width_chunks == 2
    assert ir.layers[0].height_chunks == 1
    assert ir.layers[0].chunk_indices == [0, 0]

    assert len(ir.collisions) == 1
    assert ir.collisions[0].width_tiles == 6
    assert ir.collisions[0].height_tiles == 3
    assert ir.collisions[0].solid_cells == 9

    # Aggregate provenance: PORTED (no downgrade)
    from converter.ir.provenance import Status
    assert ir.provenance.status == Status.PORTED


def test_decode_rejects_bogus_header_softly() -> None:
    """A header with zero width should not attempt NRL decompression."""
    blob = _pack_header(mw_t=0, mh_t=0, mw_c=0, mh_c=0,
                        n_layers=1, has_coll=0)
    ir, stats = decode(blob, ground_id="bad",
                       rom_sha256=ROM_EXPECTED_HASH, rom_offset=0)
    assert stats.header_warnings, "expected warnings on zero-sized header"
    assert ir.layers == [] and ir.collisions == []
    from converter.ir.provenance import Status
    assert ir.provenance.status == Status.UNKNOWN
