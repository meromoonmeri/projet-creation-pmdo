"""BPA (Background Palette-indexed Animated tiles) decoder for PMD Red.

BPA is the animated-tile companion of BPC/BMA. Its header describes:

    u8   num_tiles       // number of animated tiles in this file
    s16  num_frames      // number of frames per tile
    s32  duration_per_frame[num_frames]   // 4 bytes each; frame length
                                          // in game ticks (usually 60 fps)
    // Then num_tiles * num_frames * 32 bytes of 4bpp pixel data
    // (8x8 tiles, GBA layout).

Each BPA file animates ONE bank of tiles that swaps in and out of a
specific slot referenced by BPC.bpa_slot_tiles[slot_index]. Frames
loop.

This decoder reads the header + duration table + raw frame pixel data
and returns a BPA_IR-like typed record so downstream stages can render
animated previews or wire the frames into a PMDO animated-tile
mechanism.
"""
from __future__ import annotations

import struct
from dataclasses import dataclass, field
from typing import Optional


HEADER_FIXED_SIZE = 3           # num_tiles (u8) + num_frames (s16)
DURATION_ENTRY_SIZE = 4         # s32 per frame
TILE_BYTES = 32                 # 8x8 pixels @ 4bpp


@dataclass(frozen=True)
class BpaHeaderRaw:
    num_tiles:      int
    num_frames:     int
    frame_durations: tuple[int, ...]   # length == num_frames


@dataclass
class BpaDecodeStats:
    header_warnings: list[str] = field(default_factory=list)
    tiles_decoded: int = 0
    frames_decoded: int = 0
    bytes_consumed: int = 0


@dataclass
class BpaResult:
    header: BpaHeaderRaw
    # frame_pixels[frame][tile] -> 32 bytes of 4bpp pixel data
    frame_pixels: list[list[bytes]]
    stats: BpaDecodeStats


def _read_header(blob: bytes) -> BpaHeaderRaw:
    if len(blob) < HEADER_FIXED_SIZE:
        raise ValueError(
            f"BPA too short for header ({len(blob)} < {HEADER_FIXED_SIZE})"
        )
    num_tiles = blob[0]
    num_frames = struct.unpack_from("<h", blob, 1)[0]
    need_durations = num_frames * DURATION_ENTRY_SIZE
    if len(blob) < HEADER_FIXED_SIZE + need_durations:
        raise ValueError(
            f"BPA too short for {num_frames} duration entries"
        )
    durations = tuple(struct.unpack_from(
        f"<{num_frames}i", blob, HEADER_FIXED_SIZE
    ))
    return BpaHeaderRaw(
        num_tiles=num_tiles,
        num_frames=num_frames,
        frame_durations=durations,
    )


def _validate_header(h: BpaHeaderRaw) -> list[str]:
    w: list[str] = []
    if h.num_tiles == 0:
        w.append("num_tiles is zero")
    if h.num_frames <= 0:
        w.append(f"num_frames={h.num_frames} <= 0")
    if h.num_frames > 64:
        w.append(f"num_frames={h.num_frames} suspiciously large")
    if any(d <= 0 for d in h.frame_durations):
        w.append("some frame durations are non-positive")
    return w


def decode(
    blob: bytes,
    *,
    rom_sha256: str,
    rom_offset: int,
) -> BpaResult:
    """Decode a BPA blob header + frames pixel data.

    Frames are stored consecutively; each frame contains num_tiles
    8x8 tiles in GBA 4bpp order.
    """
    header = _read_header(blob)
    stats = BpaDecodeStats()
    stats.header_warnings = _validate_header(header)

    frame_pixels: list[list[bytes]] = []

    # Body cursor: header + durations
    body_start = HEADER_FIXED_SIZE + header.num_frames * DURATION_ENTRY_SIZE

    if stats.header_warnings and any(
        "is zero" in w or "<= 0" in w for w in stats.header_warnings
    ):
        stats.bytes_consumed = body_start
        return BpaResult(header=header, frame_pixels=[], stats=stats)

    tile_block_size = header.num_tiles * TILE_BYTES
    for frame_idx in range(header.num_frames):
        off = body_start + frame_idx * tile_block_size
        end = off + tile_block_size
        if end > len(blob):
            stats.header_warnings.append(
                f"frame {frame_idx} truncated: need {tile_block_size} bytes"
            )
            break
        this_frame: list[bytes] = []
        for tile_idx in range(header.num_tiles):
            tstart = off + tile_idx * TILE_BYTES
            this_frame.append(bytes(blob[tstart : tstart + TILE_BYTES]))
        frame_pixels.append(this_frame)
        stats.frames_decoded += 1
        stats.tiles_decoded += header.num_tiles

    stats.bytes_consumed = body_start + \
        stats.frames_decoded * tile_block_size

    return BpaResult(header=header, frame_pixels=frame_pixels, stats=stats)
