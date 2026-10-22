"""BPC (Background Palette-indexed Chunks) decoder for PMD Red.

BPC is the tileset companion of BMA. Its header describes how many
8x8 tiles the tileset contains, how many chunks the map uses, and how
many tiles come from each of the 8 optional BPA animation slots. The
payload after the header is (numTiles - 1) * 16 bytes of 4bpp pixel
data (one 8x8 tile = 32 pixels = 16 bytes at 4bpp) followed by a
chunk-mapping compressed with a per-cell scheme.

Structural layout (from public pret ground_bg.c source, MIT):

    u8  chunk_width       // always 3
    u8  chunk_height      // always 3
    u8  num_tiles         // number of 8x8 tiles + 1 (null tile)
    u8  bpa_slot_num_tiles[8]
    u8  num_chunks        // number of chunk records + 1

Tile pixel data:  (num_tiles - 1) * 16 bytes, 4bpp, GBA tile ordering
                  (each row of 8 pixels packed low-nibble-first).
Chunk-mapping   :  compressed with a NRL scheme very similar to BMA
                  (0x00..0x7F literal-run count; 0x80..0xFF repeat).

This module decodes the header + the tile pixel block. The chunk
mapping is left for a follow-up (only needed to render the
tileset->screen composition, not to know what pixels the tileset
holds). The tile block alone is enough to check pixel-count parity
against the BMA and to render an inspection preview.
"""
from __future__ import annotations

import struct
from dataclasses import dataclass, field
from typing import Optional


HEADER_MIN_SIZE = 12    # chunk_w + chunk_h + num_tiles + 8xBPA + num_chunks
TILE_BYTES = 32         # 8x8 pixels @ 4bpp = 64 pixels * 4 bits = 32 bytes
MAX_BPA_SLOTS = 8


@dataclass(frozen=True)
class BpcHeaderRaw:
    chunk_width:       int
    chunk_height:      int
    num_tiles:         int   # includes the null tile
    bpa_slot_tiles:    tuple[int, ...]     # length = 8
    num_chunks:        int   # includes the null chunk


@dataclass
class BpcDecodeStats:
    header_warnings: list[str] = field(default_factory=list)
    tile_bytes_available: int = 0
    tile_bytes_consumed: int = 0
    tiles_decoded: int = 0
    tiles_expected: int = 0
    used_bpa_slots: int = 0


@dataclass
class BpcResult:
    header: BpcHeaderRaw
    tile_pixels: bytes    # concatenated 4bpp tile data, (num_tiles-1)*16 bytes
    stats: BpcDecodeStats


def _read_header(blob: bytes) -> BpcHeaderRaw:
    if len(blob) < HEADER_MIN_SIZE:
        raise ValueError(
            f"BPC too short for header ({len(blob)} < {HEADER_MIN_SIZE})"
        )
    (
        chunk_w, chunk_h, num_tiles,
        s0, s1, s2, s3, s4, s5, s6, s7,
        num_chunks,
    ) = struct.unpack_from("<BBBBBBBBBBBB", blob, 0)
    return BpcHeaderRaw(
        chunk_width=chunk_w,
        chunk_height=chunk_h,
        num_tiles=num_tiles,
        bpa_slot_tiles=(s0, s1, s2, s3, s4, s5, s6, s7),
        num_chunks=num_chunks,
    )


def _validate_header(h: BpcHeaderRaw) -> list[str]:
    w: list[str] = []
    if h.chunk_width != 3 or h.chunk_height != 3:
        w.append(f"chunk dims {h.chunk_width}x{h.chunk_height} != 3x3")
    if h.num_tiles == 0:
        w.append("num_tiles is zero")
    if h.num_chunks == 0:
        w.append("num_chunks is zero")
    if sum(h.bpa_slot_tiles) > 2048:
        w.append(f"suspicious BPA slot total {sum(h.bpa_slot_tiles)}")
    return w


def decode(
    blob: bytes,
    *,
    rom_sha256: str,
    rom_offset: int,
) -> BpcResult:
    """Decode a BPC blob header + static tile block.

    Chunk-mapping decompression is left out on purpose (see module
    docstring). The static tile block alone lets the pipeline:
      * know how many tiles the tileset carries,
      * cross-check tile-count parity vs BMA layer specs,
      * emit a PNG preview of the tileset for human inspection.
    """
    header = _read_header(blob)
    stats = BpcDecodeStats()
    stats.header_warnings = _validate_header(header)

    if stats.header_warnings and any(
        "is zero" in w or "!= 3x3" in w for w in stats.header_warnings
    ):
        return BpcResult(header=header, tile_pixels=b"", stats=stats)

    # Tile block starts right after the header. Real tile count is
    # (num_tiles - 1): the "null tile" is not stored.
    stats.tiles_expected = max(0, header.num_tiles - 1)
    need = stats.tiles_expected * TILE_BYTES
    have = len(blob) - HEADER_MIN_SIZE
    stats.tile_bytes_available = have

    tile_bytes = min(need, max(0, have))
    tile_pixels = bytes(blob[HEADER_MIN_SIZE : HEADER_MIN_SIZE + tile_bytes])
    stats.tile_bytes_consumed = tile_bytes
    stats.tiles_decoded = tile_bytes // TILE_BYTES
    stats.used_bpa_slots = sum(
        1 for n in header.bpa_slot_tiles if n > 0
    )

    if stats.tiles_decoded < stats.tiles_expected:
        stats.header_warnings.append(
            f"tile block truncated: got {stats.tiles_decoded} tiles, "
            f"expected {stats.tiles_expected}"
        )

    return BpcResult(header=header, tile_pixels=tile_pixels, stats=stats)


# ------------------------------------------------------------------ helpers


def decode_tile_4bpp_to_indices(tile: bytes) -> list[int]:
    """Return the 64 palette indices (0..15) of one 8x8 4bpp GBA tile.

    GBA 4bpp packs two pixels per byte, low-nibble first. Each row of
    8 pixels occupies 4 bytes; 8 rows = 32 pixels = 16 bytes.
    """
    if len(tile) != TILE_BYTES:
        raise ValueError(f"tile must be {TILE_BYTES} bytes, got {len(tile)}")
    out: list[int] = []
    for b in tile:
        out.append(b & 0x0F)
        out.append((b >> 4) & 0x0F)
    return out
