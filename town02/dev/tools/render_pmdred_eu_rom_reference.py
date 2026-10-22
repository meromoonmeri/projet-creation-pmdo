#!/usr/bin/env python3
"""Independent EU-ROM Ground reference renderer and runtime sample planner.

This module intentionally does not import the converter, candidate auditor, tile
reader, Ground reader, or their parsing helpers.  It starts from the freshly
normalized BPL/BPC/BPA/BMA byte streams extracted from the authenticated
European ROM and implements the documented Red Rescue Team formats directly.
The runtime comparator uses it as a separate expected-image authority.

A plan covers tick zero plus both sides of every frame boundary throughout two
complete local cycles of every distinct map-cell animation dependency set.  It
therefore proves combined BPL/BPA timing and post-wrap stability without
attempting the irrelevant Ground-wide LCM of mutually independent cells (which
can exceed one million source ticks).
"""

from __future__ import annotations

import argparse
import dataclasses
import hashlib
import json
import math
import struct
from pathlib import Path
from typing import Iterable, Sequence

from PIL import Image

SCHEMA = "pmdred-eu-independent-rom-reference-v2"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
SOURCE_TICKS_PER_PMDO_FRAME_TICK = 120


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def read_json(path: Path) -> object:
    return json.loads(path.read_text(encoding="utf-8-sig"))


@dataclasses.dataclass(frozen=True)
class PaletteAnimation:
    duration: int
    frames: tuple[tuple[tuple[int, int, int, int], ...], ...]

    @property
    def cycle(self) -> int:
        return self.duration * len(self.frames)


@dataclasses.dataclass(frozen=True)
class PaletteSet:
    base: tuple[tuple[tuple[int, int, int, int], ...], ...]
    animated: tuple[PaletteAnimation | None, ...]


@dataclasses.dataclass(frozen=True)
class Bpc:
    cell_width: int
    cell_height: int
    tiles: tuple[bytes, ...]
    chunks: tuple[tuple[int, ...], ...]


@dataclasses.dataclass(frozen=True)
class Bpa:
    tile_count: int
    source_durations: tuple[int, ...]
    durations: tuple[int, ...]
    frames: tuple[tuple[bytes, ...], ...]

    @property
    def cycle(self) -> int:
        return sum(self.durations)


@dataclasses.dataclass(frozen=True)
class Bma:
    tile_width: int
    tile_height: int
    cell_width: int
    cell_height: int
    layer_count: int
    layers: tuple[tuple[int, ...], ...]
    unknown_data: bytes | None
    collisions: tuple[bytes, ...]
    encoded_end: int


@dataclasses.dataclass(frozen=True)
class GroundResources:
    ground: str
    names: dict[str, object]
    hashes: dict[str, str]
    palettes: PaletteSet
    bpc: Bpc
    bpa: tuple[Bpa | None, ...]
    bma: Bma


@dataclasses.dataclass(frozen=True)
class RenderedGround:
    width: int
    height: int
    rgba: bytes


def _palette(data: bytes, offset: int, context: str) -> tuple[tuple[tuple[int, int, int, int], ...], int]:
    require(offset + 60 <= len(data), f"{context}: truncated 15-colour palette")
    colors: list[tuple[int, int, int, int]] = [(0, 0, 0, 0)]
    for index in range(15):
        pos = offset + index * 4
        colors.append((data[pos], data[pos + 1], data[pos + 2], 255))
    return tuple(colors), offset + 60


def parse_bpl(data: bytes, context: str) -> PaletteSet:
    require(len(data) >= 4, f"{context}: truncated BPL")
    count, animation_flag = struct.unpack_from("<hh", data, 0)
    require(0 < count <= 16, f"{context}: invalid palette count {count}")
    require(animation_flag in (0, 1), f"{context}: invalid animation flag")
    offset = 4
    base: list[tuple[tuple[int, int, int, int], ...]] = []
    for _ in range(count):
        colors, offset = _palette(data, offset, context)
        base.append(colors)
    animated: list[PaletteAnimation | None] = [None] * count
    if animation_flag:
        require(offset + count * 4 <= len(data), f"{context}: truncated BPL animation table")
        specs = [struct.unpack_from("<hh", data, offset + index * 4) for index in range(count)]
        offset += count * 4
        for palette_index, (duration, frame_count) in enumerate(specs):
            require(duration >= 0 and frame_count >= 0, f"{context}: invalid palette animation")
            if frame_count:
                require(duration > 0, f"{context}: animated palette has zero duration")
                frames = []
                for _ in range(frame_count):
                    colors, offset = _palette(data, offset, context)
                    frames.append(colors)
                animated[palette_index] = PaletteAnimation(duration, tuple(frames))
    require(offset == len(data), f"{context}: BPL has {len(data) - offset} trailing bytes")
    return PaletteSet(tuple(base), tuple(animated))


def parse_bpc(data: bytes, context: str) -> Bpc:
    require(len(data) >= 16, f"{context}: truncated BPC")
    cell_width, cell_height, tile_count = struct.unpack_from("<HHH", data, 0)
    chunk_count = struct.unpack_from("<H", data, 14)[0]
    require(cell_width in (2, 3) and cell_height in (2, 3), f"{context}: invalid cell dimensions")
    require(tile_count >= 1 and chunk_count >= 1, f"{context}: invalid BPC counts")
    offset = 16
    tiles: list[bytes] = [bytes(32)]
    for _ in range(tile_count - 1):
        require(offset + 32 <= len(data), f"{context}: truncated BPC tile")
        tiles.append(data[offset : offset + 32])
        offset += 32
    entries_per_chunk = cell_width * cell_height
    chunks: list[tuple[int, ...]] = [tuple(0 for _ in range(entries_per_chunk))]
    for _ in range(chunk_count - 1):
        size = entries_per_chunk * 2
        require(offset + size <= len(data), f"{context}: truncated BPC chunk")
        chunks.append(struct.unpack_from(f"<{entries_per_chunk}H", data, offset))
        offset += size
    require(offset == len(data), f"{context}: BPC has {len(data) - offset} trailing bytes")
    return Bpc(cell_width, cell_height, tuple(tiles), tuple(chunks))


def parse_bpa(data: bytes, context: str) -> Bpa:
    require(len(data) >= 4, f"{context}: truncated BPA")
    tile_count = data[0]
    frame_count = struct.unpack_from("<h", data, 2)[0]
    require(tile_count > 0 and frame_count > 0, f"{context}: invalid BPA counts")
    require(4 + frame_count * 4 <= len(data), f"{context}: truncated BPA durations")
    source_durations = struct.unpack_from(f"<{frame_count}i", data, 4)
    require(all(value >= 0 for value in source_durations), f"{context}: negative BPA duration")
    offset = 4 + frame_count * 4
    frames: list[tuple[bytes, ...]] = []
    for _ in range(frame_count):
        tiles = []
        for _ in range(tile_count):
            require(offset + 32 <= len(data), f"{context}: truncated BPA graphics")
            tiles.append(data[offset : offset + 32])
            offset += 32
        frames.append(tuple(tiles))
    require(offset == len(data), f"{context}: BPA has {len(data) - offset} trailing bytes")
    # Red's BPA timer is post-decremented: source value N displays for N+1 ticks.
    durations = tuple(value + 1 for value in source_durations)
    return Bpa(tile_count, tuple(source_durations), durations, tuple(frames))


def _decode_bma_graphics(
    data: bytes, offset: int, width: int, height: int, layer_count: int, context: str
) -> tuple[tuple[tuple[int, ...], ...], int]:
    layers: list[tuple[int, ...]] = []
    memory_stride = 64
    for layer_index in range(layer_count):
        memory: list[int] = []
        logical: list[int] = []
        for row_index in range(height):
            row: list[int] = []
            produced = 0
            while produced < width:
                require(offset < len(data), f"{context}: truncated BMA graphics command")
                command = data[offset]
                offset += 1
                run = (command & 0x3F) + 1
                if command < 0x80:
                    pairs: Iterable[tuple[int, int]] = ((0, 0) for _ in range(run))
                elif command < 0xC0:
                    require(offset + 3 <= len(data), f"{context}: truncated repeated BMA pair")
                    packed = int.from_bytes(data[offset : offset + 3], "little")
                    offset += 3
                    pair = (packed & 0xFFF, (packed >> 12) & 0xFFF)
                    pairs = (pair for _ in range(run))
                else:
                    literal: list[tuple[int, int]] = []
                    require(offset + run * 3 <= len(data), f"{context}: truncated literal BMA pairs")
                    for _ in range(run):
                        packed = int.from_bytes(data[offset : offset + 3], "little")
                        offset += 3
                        literal.append((packed & 0xFFF, (packed >> 12) & 0xFFF))
                    pairs = literal
                for pair in pairs:
                    for value in pair:
                        if row_index:
                            require(len(row) < memory_stride, f"{context}: BMA row exceeds stride 64")
                            value ^= memory[(row_index - 1) * memory_stride + len(row)]
                        row.append(value)
                produced += run * 2
            require(len(row) <= memory_stride, f"{context}: BMA row exceeds stride 64")
            logical.extend(row[:width])
            memory.extend(row + [0] * (memory_stride - len(row)))
        layers.append(tuple(logical))
    return tuple(layers), offset


def _decode_generic(data: bytes, offset: int, size: int, context: str) -> tuple[bytes, int]:
    output = bytearray()
    while len(output) < size:
        require(offset < len(data), f"{context}: truncated generic NRL")
        command = data[offset]
        offset += 1
        run = command + 1 if command < 0x80 else (command & 0x3F) + 1
        if command < 0x80:
            output.extend(bytes(run))
        elif command < 0xC0:
            require(offset < len(data), f"{context}: truncated repeated generic NRL")
            output.extend(bytes((data[offset],)) * run)
            offset += 1
        else:
            require(offset + run <= len(data), f"{context}: truncated literal generic NRL")
            output.extend(data[offset : offset + run])
            offset += run
    return bytes(output[:size]), offset


def _decode_collision(data: bytes, offset: int, width: int, height: int, context: str) -> tuple[bytes, int]:
    size = width * height
    deltas = bytearray()
    while len(deltas) < size:
        require(offset < len(data), f"{context}: truncated collision RLE")
        command = data[offset]
        offset += 1
        deltas.extend(bytes((command >> 7,)) * ((command & 0x7F) + 1))
    decoded = bytearray(size)
    for index, delta in enumerate(deltas[:size]):
        decoded[index] = delta ^ (decoded[index - width] if index >= width else 0)
    return bytes(decoded), offset


def parse_bma(data: bytes, context: str) -> Bma:
    require(len(data) >= 12, f"{context}: truncated BMA")
    tile_width, tile_height, tiling_width, tiling_height, cell_width, cell_height = data[:6]
    layer_count, has_data, collision_count = struct.unpack_from("<HHH", data, 6)
    require(tiling_width in (2, 3) and tiling_height in (2, 3), f"{context}: invalid BMA tiling")
    require(layer_count in (1, 2), f"{context}: invalid BMA layer count")
    require(has_data in (0, 1) and collision_count in (0, 1, 2), f"{context}: invalid BMA flags")
    layers, offset = _decode_bma_graphics(data, 12, cell_width, cell_height, layer_count, context)
    unknown = None
    if has_data:
        unknown, offset = _decode_generic(data, offset, tile_width * tile_height, context)
    collisions = []
    for index in range(collision_count):
        layer, offset = _decode_collision(data, offset, tile_width, tile_height, f"{context}/collision-{index}")
        collisions.append(layer)
    require(offset == len(data), f"{context}: BMA has {len(data) - offset} trailing bytes")
    return Bma(
        tile_width,
        tile_height,
        cell_width,
        cell_height,
        layer_count,
        layers,
        unknown,
        tuple(collisions),
        offset,
    )


def load_ground(source_dir: Path, row: dict[str, object]) -> GroundResources:
    ground = str(row["asset"])
    names = dict(row["resources"])
    expected_hashes = dict(row["source_normalized_sha256"])

    def resource(name: str, extension: str) -> bytes:
        path = source_dir / f"{name}.{extension}"
        data = path.read_bytes()
        require(sha256_bytes(data) == expected_hashes[name], f"{ground}: normalized {name} hash mismatch")
        return data

    bpl_name = str(names["bpl"])
    bpc_name = str(names["bpc"])
    bma_name = str(names["bma"])
    bpa_names = list(names.get("bpa", []))
    slots: list[Bpa | None] = []
    for name in bpa_names:
        slots.append(None if name is None else parse_bpa(resource(str(name), "bpa"), f"{ground}/{name}"))
    return GroundResources(
        ground=ground,
        names=names,
        hashes=expected_hashes,
        palettes=parse_bpl(resource(bpl_name, "bpl"), f"{ground}/{bpl_name}"),
        bpc=parse_bpc(resource(bpc_name, "bpc"), f"{ground}/{bpc_name}"),
        bpa=tuple(slots),
        bma=parse_bma(resource(bma_name, "bma"), f"{ground}/{bma_name}"),
    )


def _bpa_offsets(resources: GroundResources) -> tuple[int, ...]:
    offset = len(resources.bpc.tiles)
    result = []
    for slot in resources.bpa:
        result.append(offset)
        if slot is not None:
            offset += slot.tile_count
    return tuple(result)


def _bpa_location(resources: GroundResources, tile_index: int) -> tuple[int, int] | None:
    for slot_index, (offset, slot) in enumerate(zip(_bpa_offsets(resources), resources.bpa)):
        if slot is not None and offset <= tile_index < offset + slot.tile_count:
            return slot_index, tile_index - offset
    return None


ChannelKey = tuple[str, int]


def _entry_animation_keys(resources: GroundResources, entry: int) -> set[ChannelKey]:
    keys: set[ChannelKey] = set()
    palette_index = (entry >> 12) & 0xF
    if (
        palette_index < len(resources.palettes.animated)
        and resources.palettes.animated[palette_index] is not None
    ):
        keys.add(("BPL_PALETTE", palette_index))
    location = _bpa_location(resources, entry & 0x3FF)
    if location is not None:
        slot = resources.bpa[location[0]]
        assert slot is not None
        if slot.cycle > 1:
            keys.add(("BPA_TILE", location[0]))
    return keys


def cell_animation_channel_sets(resources: GroundResources) -> tuple[tuple[ChannelKey, ...], ...]:
    """Return distinct animation dependency sets used by individual map cells."""
    channel_sets: set[tuple[ChannelKey, ...]] = set()
    logical_count = resources.bma.cell_width * resources.bma.cell_height
    for logical_index in range(logical_count):
        keys: set[ChannelKey] = set()
        for layer in resources.bma.layers:
            chunk_id = layer[logical_index]
            if not 0 < chunk_id < len(resources.bpc.chunks):
                continue
            for entry in resources.bpc.chunks[chunk_id]:
                keys.update(_entry_animation_keys(resources, entry))
        if keys:
            channel_sets.add(tuple(sorted(keys)))
    return tuple(sorted(channel_sets))


def _describe_channel(resources: GroundResources, key: ChannelKey) -> dict[str, object]:
    kind, index = key
    if kind == "BPL_PALETTE":
        animation = resources.palettes.animated[index]
        assert animation is not None
        return {
            "kind": kind,
            "index": index,
            "frame_count": len(animation.frames),
            "frame_durations": [animation.duration] * len(animation.frames),
            "cycle": animation.cycle,
        }
    require(kind == "BPA_TILE", f"unknown animation channel kind {kind}")
    slot = resources.bpa[index]
    assert slot is not None
    return {
        "kind": kind,
        "index": index,
        "frame_count": len(slot.frames),
        "source_duration_values": list(slot.source_durations),
        "frame_durations": list(slot.durations),
        "cycle": slot.cycle,
    }


def used_animation_channels(resources: GroundResources) -> tuple[dict[str, object], ...]:
    """Return only animation primitives referenced by at least one map cell."""
    keys = {key for channel_set in cell_animation_channel_sets(resources) for key in channel_set}
    return tuple(_describe_channel(resources, key) for key in sorted(keys))


def _channel_key(channel: dict[str, object]) -> ChannelKey:
    return str(channel["kind"]), int(channel["index"])


def _channel_frame_starts(channel: dict[str, object]) -> tuple[int, ...]:
    cycle = int(channel["cycle"])
    cursor = 0
    starts = []
    for duration in channel["frame_durations"]:  # type: ignore[union-attr]
        starts.append(cursor)
        cursor += int(duration)
    require(cursor == cycle, "animation channel durations do not equal cycle")
    return tuple(starts)


def primitive_boundary_ticks(channels: Sequence[dict[str, object]]) -> tuple[int, ...]:
    """Return boundary samples for one primitive cycle of each channel."""
    ticks = {0}
    for channel in channels:
        cycle = int(channel["cycle"])
        for cursor in _channel_frame_starts(channel):
            ticks.add(cursor)
            ticks.add((cursor - 1) % cycle)
    return tuple(sorted(ticks))


def complete_cell_cycle_boundary_plan(
    resources: GroundResources,
    channels: Sequence[dict[str, object]],
) -> tuple[tuple[int, ...], tuple[dict[str, object], ...]]:
    """Sample every transition through two cycles of each cell dependency set.

    Separate cells do not interact, so taking a Ground-wide LCM creates no new
    observable state.  Within one cell, however, all referenced BPL/BPA
    channels combine; every primitive boundary must therefore be repeated
    throughout that cell's LCM.  A second full local cycle proves wrap and
    catches serialized schedules that drift only after initially matching.
    """
    by_key = {_channel_key(channel): channel for channel in channels}
    ticks = {0}
    schedules: list[dict[str, object]] = []
    for channel_set in cell_animation_channel_sets(resources):
        period = 1
        for key in channel_set:
            period = math.lcm(period, int(by_key[key]["cycle"]))
        first_cycle = {0}
        for key in channel_set:
            channel = by_key[key]
            cycle = int(channel["cycle"])
            for cycle_start in range(0, period, cycle):
                for frame_start in _channel_frame_starts(channel):
                    boundary = cycle_start + frame_start
                    first_cycle.add(boundary)
                    first_cycle.add((boundary - 1) % period)
        second_cycle = {period + tick for tick in first_cycle}
        ticks.update(first_cycle)
        ticks.update(second_cycle)
        schedules.append(
            {
                "channels": [f"{kind}:{index}" for kind, index in channel_set],
                "source_local_cycle": period,
                "first_cycle_boundary_sample_count": len(first_cycle),
                "two_cycle_boundary_sample_count": len(first_cycle) * 2,
                "maximum_sample_tick": period + max(first_cycle),
            }
        )
    return tuple(sorted(ticks)), tuple(schedules)


def _rgba_tile(tile: bytes, palette: Sequence[tuple[int, int, int, int]], horizontal: bool, vertical: bool) -> Image.Image:
    rgba = bytearray(8 * 8 * 4)
    for y in range(8):
        for pair_x in range(4):
            packed = tile[y * 4 + pair_x]
            for nibble, color_index in enumerate((packed & 0xF, packed >> 4)):
                if not color_index:
                    continue
                x = pair_x * 2 + nibble
                out_x = 7 - x if horizontal else x
                out_y = 7 - y if vertical else y
                position = (out_y * 8 + out_x) * 4
                rgba[position : position + 4] = bytes(palette[color_index])
    return Image.frombytes("RGBA", (8, 8), bytes(rgba))


def _palette_at(resources: GroundResources, index: int, tick: int) -> tuple[tuple[int, int, int, int], ...]:
    index %= len(resources.palettes.base)
    animation = resources.palettes.animated[index]
    if animation is None:
        return resources.palettes.base[index]
    return animation.frames[(tick // animation.duration) % len(animation.frames)]


def _bpa_frame(slot: Bpa, tick: int) -> int:
    position = tick % slot.cycle
    cursor = 0
    for index, duration in enumerate(slot.durations):
        cursor += duration
        if position < cursor:
            return index
    raise AssertionError("unreachable BPA frame position")


def render_ground(resources: GroundResources, tick: int) -> RenderedGround:
    require(tick >= 0, "source tick must be nonnegative")
    width = resources.bma.tile_width * 8
    height = resources.bma.tile_height * 8
    output = Image.new("RGBA", (width, height), (0, 0, 0, 255))
    tile_cache: dict[tuple[int, int, int, bool, bool], Image.Image] = {}
    offsets = _bpa_offsets(resources)

    def tile_image(entry: int) -> Image.Image | None:
        tile_index = entry & 0x3FF
        if tile_index == 0:
            return None
        horizontal = bool((entry >> 10) & 1)
        vertical = bool((entry >> 11) & 1)
        palette_index = (entry >> 12) & 0xF
        animation = resources.palettes.animated[palette_index % len(resources.palettes.animated)]
        palette_frame = -1 if animation is None else (tick // animation.duration) % len(animation.frames)
        location = None
        for slot_index, (offset, slot) in enumerate(zip(offsets, resources.bpa)):
            if slot is not None and offset <= tile_index < offset + slot.tile_count:
                location = (slot_index, tile_index - offset)
                break
        bpa_frame = -1
        if tile_index < len(resources.bpc.tiles):
            graphics = resources.bpc.tiles[tile_index]
        elif location is not None:
            slot = resources.bpa[location[0]]
            assert slot is not None
            bpa_frame = _bpa_frame(slot, tick)
            graphics = slot.frames[bpa_frame][location[1]]
        else:
            graphics = bytes(32)  # patterned blank VRAM sentinel
        key = (tile_index, palette_index, palette_frame * 8192 + bpa_frame, horizontal, vertical)
        cached = tile_cache.get(key)
        if cached is None:
            cached = _rgba_tile(graphics, _palette_at(resources, palette_index, tick), horizontal, vertical)
            tile_cache[key] = cached
        return cached

    cell_pixel_width = resources.bpc.cell_width * 8
    cell_pixel_height = resources.bpc.cell_height * 8
    for cell_y in range(resources.bma.cell_height):
        for cell_x in range(resources.bma.cell_width):
            logical_index = cell_y * resources.bma.cell_width + cell_x
            for layer in reversed(resources.bma.layers):
                chunk_id = layer[logical_index]
                if not 0 < chunk_id < len(resources.bpc.chunks):
                    continue
                for tile_offset, entry in enumerate(resources.bpc.chunks[chunk_id]):
                    image = tile_image(entry)
                    if image is None:
                        continue
                    tile_x = cell_x * resources.bpc.cell_width + tile_offset % resources.bpc.cell_width
                    tile_y = cell_y * resources.bpc.cell_height + tile_offset // resources.bpc.cell_width
                    if tile_x < resources.bma.tile_width and tile_y < resources.bma.tile_height:
                        output.alpha_composite(image, (tile_x * 8, tile_y * 8))
    return RenderedGround(width, height, output.tobytes())


class GroundRenderSession:
    """Render repeated ticks while caching immutable and repeated cell states.

    This is an optimization of :func:`render_ground`, not a second rendering
    interpretation.  Ground cells never overlap, so cells without a used
    BPL/BPA channel can be baked once.  Animated cells are cached by their
    complete raw channel-frame state and pasted into an opaque black base.
    """

    def __init__(self, resources: GroundResources):
        self.resources = resources
        self.width = resources.bma.tile_width * 8
        self.height = resources.bma.tile_height * 8
        self.cell_width = resources.bpc.cell_width * 8
        self.cell_height = resources.bpc.cell_height * 8
        self.offsets = _bpa_offsets(resources)
        self.tile_locations: dict[int, tuple[int, int]] = {}
        for slot_index, (offset, slot) in enumerate(zip(self.offsets, resources.bpa)):
            if slot is not None:
                for local_index in range(slot.tile_count):
                    self.tile_locations[offset + local_index] = (slot_index, local_index)
        self.tile_cache: dict[tuple[int, int, int, bool, bool], Image.Image] = {}
        self.cell_cache: dict[
            tuple[tuple[int, ...], tuple[tuple[str, int, int], ...]], Image.Image
        ] = {}
        self.cell_signatures: tuple[tuple[int, ...], ...] = tuple(
            tuple(layer[index] for layer in resources.bma.layers)
            for index in range(resources.bma.cell_width * resources.bma.cell_height)
        )
        self.cell_channels: tuple[tuple[ChannelKey, ...], ...] = tuple(
            tuple(sorted(self._cell_channels(logical_index)))
            for logical_index in range(resources.bma.cell_width * resources.bma.cell_height)
        )
        self.dynamic_cells = tuple(
            index for index, channels in enumerate(self.cell_channels) if channels
        )
        self.base = Image.new("RGBA", (self.width, self.height), (0, 0, 0, 255))
        for logical_index, channels in enumerate(self.cell_channels):
            if not channels:
                self._paste_cell(self.base, logical_index, self._render_cell(logical_index, 0))

    def _cell_channels(self, logical_index: int) -> set[ChannelKey]:
        keys: set[ChannelKey] = set()
        for chunk_id in self.cell_signatures[logical_index]:
            if not 0 < chunk_id < len(self.resources.bpc.chunks):
                continue
            for entry in self.resources.bpc.chunks[chunk_id]:
                keys.update(_entry_animation_keys(self.resources, entry))
        return keys

    def _channel_state(self, key: ChannelKey, tick: int) -> int:
        kind, index = key
        if kind == "BPL_PALETTE":
            animation = self.resources.palettes.animated[index]
            assert animation is not None
            return (tick // animation.duration) % len(animation.frames)
        if kind == "BPA_TILE":
            slot = self.resources.bpa[index]
            assert slot is not None
            return _bpa_frame(slot, tick)
        raise AssertionError(f"unknown animation channel {key!r}")

    def _tile_image(self, entry: int, tick: int) -> Image.Image | None:
        tile_index = entry & 0x3FF
        if tile_index == 0:
            return None
        horizontal = bool((entry >> 10) & 1)
        vertical = bool((entry >> 11) & 1)
        palette_index = (entry >> 12) & 0xF
        animation = self.resources.palettes.animated[
            palette_index % len(self.resources.palettes.animated)
        ]
        palette_frame = -1 if animation is None else (
            tick // animation.duration
        ) % len(animation.frames)
        location = self.tile_locations.get(tile_index)
        bpa_frame = -1
        if tile_index < len(self.resources.bpc.tiles):
            graphics = self.resources.bpc.tiles[tile_index]
        elif location is not None:
            slot = self.resources.bpa[location[0]]
            assert slot is not None
            bpa_frame = _bpa_frame(slot, tick)
            graphics = slot.frames[bpa_frame][location[1]]
        else:
            graphics = bytes(32)
        key = (
            tile_index,
            palette_index,
            palette_frame * 8192 + bpa_frame,
            horizontal,
            vertical,
        )
        cached = self.tile_cache.get(key)
        if cached is None:
            cached = _rgba_tile(
                graphics,
                _palette_at(self.resources, palette_index, tick),
                horizontal,
                vertical,
            )
            self.tile_cache[key] = cached
        return cached

    def _render_cell(self, logical_index: int, tick: int) -> Image.Image:
        channels = self.cell_channels[logical_index]
        state = tuple(
            (kind, index, self._channel_state((kind, index), tick))
            for kind, index in channels
        )
        signature = self.cell_signatures[logical_index]
        cache_key = (signature, state)
        cached = self.cell_cache.get(cache_key)
        if cached is not None:
            return cached
        output = Image.new(
            "RGBA", (self.cell_width, self.cell_height), (0, 0, 0, 255)
        )
        for chunk_id in reversed(signature):
            if not 0 < chunk_id < len(self.resources.bpc.chunks):
                continue
            for tile_offset, entry in enumerate(self.resources.bpc.chunks[chunk_id]):
                image = self._tile_image(entry, tick)
                if image is None:
                    continue
                tile_x = tile_offset % self.resources.bpc.cell_width
                tile_y = tile_offset // self.resources.bpc.cell_width
                output.alpha_composite(image, (tile_x * 8, tile_y * 8))
        self.cell_cache[cache_key] = output
        return output

    def _paste_cell(self, output: Image.Image, logical_index: int, cell: Image.Image) -> None:
        cell_x = logical_index % self.resources.bma.cell_width
        cell_y = logical_index // self.resources.bma.cell_width
        output.paste(cell, (cell_x * self.cell_width, cell_y * self.cell_height))

    def render(self, tick: int) -> RenderedGround:
        require(tick >= 0, "source tick must be nonnegative")
        output = self.base.copy()
        for logical_index in self.dynamic_cells:
            self._paste_cell(output, logical_index, self._render_cell(logical_index, tick))
        return RenderedGround(self.width, self.height, output.tobytes())


def build_plan(source_dir: Path, conversion_report: Path, ids: Sequence[str] | None = None) -> dict[str, object]:
    report = read_json(conversion_report)
    assert isinstance(report, dict)
    rows = list(report["results"])
    by_id = {str(row["asset"]): row for row in rows}
    selected = list(ids) if ids else [str(row["asset"]) for row in rows]
    unknown = sorted(set(selected) - set(by_id))
    require(not unknown, "unknown Ground ids: " + ", ".join(unknown))
    grounds: dict[str, object] = {}
    for ground in selected:
        resources = load_ground(source_dir, by_id[ground])
        channels = used_animation_channels(resources)
        ticks, schedules = complete_cell_cycle_boundary_plan(resources, channels)
        collision = resources.bma.collisions[0] if resources.bma.collisions else bytes(resources.bma.tile_width * resources.bma.tile_height)
        grounds[ground] = {
            "resources": resources.names,
            "source_normalized_sha256": resources.hashes,
            "dimensions_tiles": [resources.bma.tile_width, resources.bma.tile_height],
            "dimensions_pixels": [resources.bma.tile_width * 8, resources.bma.tile_height * 8],
            "animation_channels": list(channels),
            "cell_animation_schedules": list(schedules),
            "complete_two_local_cycle_boundary_ticks": list(ticks),
            "sample_count": len(ticks),
            "collision_layer_count": len(resources.bma.collisions),
            "collision_sha256": sha256_bytes(collision),
            "solid_cells": sum(collision),
            "unknown_data": None if resources.bma.unknown_data is None else {
                "sha256": sha256_bytes(resources.bma.unknown_data),
                "nonzero_cells": sum(value != 0 for value in resources.bma.unknown_data),
            },
        }
    return {
        "schema": SCHEMA,
        "authority": {
            "region": "Europe (En,Fr,De,Es,It)",
            "authenticated_rom_sha256": ROM_SHA256,
            "normalized_extraction_directory": str(source_dir),
            "conversion_report": str(conversion_report),
            "conversion_report_sha256": sha256_file(conversion_report),
            "independence": "raw BPL/BPC/BPA/BMA parser and renderer; no converter/auditor/candidate parser imports",
        },
        "clock": {
            "source_tick": "one PMD Red Ground background update",
            "pmdo_total_frame_tick_multiplier": SOURCE_TICKS_PER_PMDO_FRAME_TICK,
            "native_pmdo_formula": "TotalFrameTick // (120 * FrameLength) % Frames.Count",
        },
        "coverage": {
            "strategy": "tick zero and both sides of every frame boundary throughout two complete cycles of every distinct map-cell BPL/BPA dependency set",
            "validated_local_cycle_count": 2,
            "ground_wide_lcm_bruteforced": False,
            "ground_count": len(selected),
            "sample_count": sum(int(grounds[ground]["sample_count"]) for ground in selected),  # type: ignore[index]
        },
        "ground_order": selected,
        "grounds": grounds,
    }


def parse_ids(value: str | None) -> list[str] | None:
    if not value:
        return None
    return [item.strip().lower() for item in value.split(",") if item.strip()]


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-dir", required=True, type=Path)
    parser.add_argument("--conversion-report", required=True, type=Path)
    parser.add_argument("--ids", help="comma-separated Ground ids")
    parser.add_argument("--plan", type=Path, help="write an independent runtime sample plan")
    parser.add_argument("--ground", help="render one Ground id")
    parser.add_argument("--tick", type=int, default=0)
    parser.add_argument("--output", type=Path, help="PNG output for --ground")
    args = parser.parse_args(argv)
    if args.plan:
        plan = build_plan(args.source_dir, args.conversion_report, parse_ids(args.ids))
        args.plan.parent.mkdir(parents=True, exist_ok=True)
        args.plan.write_text(json.dumps(plan, indent=2, sort_keys=True) + "\n", encoding="utf-8")
        print(f"plan: {plan['coverage']['ground_count']} Grounds, {plan['coverage']['sample_count']} samples -> {args.plan}")
    if args.ground:
        require(args.output is not None, "--ground requires --output")
        report = read_json(args.conversion_report)
        row = next((row for row in report["results"] if row["asset"] == args.ground), None)  # type: ignore[index]
        require(row is not None, f"unknown Ground {args.ground}")
        rendered = render_ground(load_ground(args.source_dir, row), args.tick)
        args.output.parent.mkdir(parents=True, exist_ok=True)
        Image.frombytes("RGBA", (rendered.width, rendered.height), rendered.rgba).save(args.output)
        print(f"rendered {args.ground} tick {args.tick} -> {args.output}")
    require(args.plan is not None or args.ground is not None, "request --plan and/or --ground")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
