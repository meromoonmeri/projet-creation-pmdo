#!/usr/bin/env python3
"""Validate and reproducibly regenerate staged PMD Red direct Ground candidates."""

from __future__ import annotations

import argparse
import io
import json
import math
import struct
import tempfile
from collections import defaultdict
from pathlib import Path
from typing import Any

import audit_pmdred_eu_rom as ground_audit
from migrate_pmdred_dungeon_grounds import migrate
from PIL import Image
from pmdred_dungeon_ground import (
    CEL_DECOMPRESSED_SIZE,
    CEX_DECOMPRESSED_SIZE,
    EMAP_DECOMPRESSED_SIZE,
    EXPECTED_EU_ROM_SHA256,
    GBA_CYCLES_PER_FRAME,
    GBA_MASTER_CLOCK_HZ,
    GRAPHICS_REMAP_COUNT,
    GRAPHICS_REMAP_OFFSET,
    MATERIAL_STRIDE,
    WATER_TYPE_COUNT,
    WATER_TYPE_OFFSET,
    DungeonArchive,
    DungeonGroundRenderer,
    ReconstructionError,
    compose_ground_chunks,
    decode_bma_auxiliary_layers,
    decode_bma_terrain,
    gba_display_rgb,
    palette_at_tick,
    parse_canm,
    parse_french_dungeon_names,
    parse_ground_palette,
    parse_mapparam,
    require,
    sha256,
)

EXPECTED_FILE_COUNT = 176


def tree_records(root: Path) -> dict[str, dict[str, Any]]:
    return {
        path.relative_to(root).as_posix(): {
            "size": path.stat().st_size,
            "sha256": sha256(path.read_bytes()),
        }
        for path in sorted(root.rglob("*"))
        if path.is_file()
    }


def read_tile(path: Path) -> dict[tuple[int, int], bytes]:
    data = path.read_bytes()
    require(len(data) >= 8, f"{path}: truncated tile header")
    table_offset, count = struct.unpack_from("<II", data)
    require(table_offset == 8, f"{path}: unexpected tile table offset")
    require(8 + count * 16 <= len(data), f"{path}: truncated tile table")
    entries: dict[tuple[int, int], bytes] = {}
    payload_cache: dict[int, bytes] = {}
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", data, 8 + index * 16)
        location = (key & 0xFFFFFFFF, key >> 32)
        require(location not in entries, f"{path}: duplicate tile location {location}")
        if offset not in payload_cache:
            require(offset + 8 <= len(data), f"{path}: truncated PNG payload length")
            size = struct.unpack_from("<Q", data, offset)[0]
            require(offset + 8 + size <= len(data), f"{path}: truncated PNG payload")
            payload_cache[offset] = data[offset + 8 : offset + 8 + size]
        payload = payload_cache[offset]
        image = Image.open(io.BytesIO(payload))
        image.load()
        require(image.size == (8, 8), f"{path}: atlas image is not 8x8")
        require(image.mode == "RGB", f"{path}: atlas image is not opaque RGB")
        entries[location] = payload
    require(count == len(entries), f"{path}: tile entry count mismatch")
    return entries


def load_ground(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))["Object"]


def png_pixels(payload: bytes) -> bytes:
    image = Image.open(io.BytesIO(payload))
    image.load()
    return image.convert("RGB").tobytes()


def opaque_tile_pixels(image: Image.Image) -> bytes:
    opaque = Image.new("RGB", (8, 8), (0, 0, 0))
    opaque.paste(image, (0, 0), image)
    return opaque.tobytes()


def canonical_cells(
    renderer: DungeonGroundRenderer,
    chunks: list[int],
    width_chunks: int,
    height_chunks: int,
    width_tiles: int,
    height_tiles: int,
) -> dict[int, list[tuple[int, int]]]:
    cells: dict[int, list[tuple[int, int]]] = defaultdict(list)
    for chunk_y in range(height_chunks):
        for chunk_x in range(width_chunks):
            chunk = chunks[chunk_y * MATERIAL_STRIDE + chunk_x]
            descriptors = renderer.descriptors[chunk * 9 : chunk * 9 + 9]
            for index, descriptor in enumerate(descriptors):
                x = chunk_x * 3 + index % 3
                y = chunk_y * 3 + index // 3
                if x < width_tiles and y < height_tiles:
                    cells[descriptor].append((x, y))
    require(
        sum(len(value) for value in cells.values()) == width_tiles * height_tiles,
        "canonical CEL descriptors do not cover the BMA camera",
    )
    return dict(cells)


def canonical_record_specs(
    renderer: DungeonGroundRenderer,
    descriptor: int,
    palette: list[tuple[int, int, int, int]],
    animations: list[Any],
    *,
    quantize_for_display: bool = True,
) -> list[dict[str, Any]]:
    palette_index = (descriptor >> 12) & 0xF
    if palette_index not in (10, 11):
        return []
    tile_index = descriptor & 0x3FF
    require(
        tile_index < renderer.tile_count, "descriptor references unavailable font tile"
    )
    source = renderer.font[tile_index * 32 : tile_index * 32 + 32]
    used_colors = {
        color for byte in source for color in (byte & 0x0F, byte >> 4) if color != 0
    }
    specs: list[dict[str, Any]] = []
    for index in sorted(palette_index * 16 + color - 160 for color in used_colors):
        record = animations[index]
        if not record.active:
            continue
        source_colors = [palette[160 + index], *record.colors]
        colors = (
            [gba_display_rgb(color) for color in source_colors]
            if quantize_for_display
            else [tuple(color[:3]) for color in source_colors]
        )
        identities: dict[tuple[int, int, int], int] = {}
        ids: list[int] = []
        for color in colors:
            if color not in identities:
                identities[color] = len(identities)
            ids.append(identities[color])
        specs.append(
            {
                "index": record.index,
                "duration": record.duration,
                "raw": ids[0],
                "cycle": ids[1:],
            }
        )
    return specs


def state_id(record: dict[str, Any], tick: int) -> int:
    if tick < record["duration"]:
        return record["raw"]
    expiry = tick // record["duration"]
    return record["cycle"][(expiry - 1) % len(record["cycle"])]


def canonical_state_ticks(records: list[dict[str, Any]]) -> dict[str, int]:
    if not records:
        return {"": 0}
    period = math.lcm(
        *(record["duration"] * len(record["cycle"]) for record in records)
    )
    event_ticks = {0}
    for record in records:
        event_ticks.update(
            range(record["duration"], 2 * period + 1, record["duration"])
        )
    reached: dict[str, int] = {}
    for tick in sorted(event_ticks):
        key = ",".join(str(state_id(record, tick)) for record in records)
        reached.setdefault(key, tick)
    return reached


def lua_sequence(table: Any) -> list[Any]:
    return [table[index] for index in range(1, len(table) + 1)]


def validate_rom_correspondence(rom_path: Path, candidate: Path) -> dict[str, int]:
    """Rederive every staged cell and visual state without migration helpers."""

    try:
        from lupa import LuaRuntime
    except ImportError as exc:  # pragma: no cover
        raise ReconstructionError("lupa is required for metadata validation") from exc

    rom = rom_path.read_bytes()
    require(
        sha256(rom) == EXPECTED_EU_ROM_SHA256, "validator ROM is not authoritative EU"
    )
    ground_audit.validate_rom(rom)
    archive = DungeonArchive(rom)
    floor_counts = ground_audit.parse_dungeon_floor_counts(rom)
    map_files = ground_audit.parse_map_files_table(rom)
    conversions = ground_audit.parse_ground_conversion_table(rom, map_files)
    mappings, sentinel = ground_audit.parse_map_to_dungeon_table(
        rom, conversions, floor_counts
    )
    require(
        len(mappings) == 27 and sentinel["map_id"] == -1, "ROM mapping table mismatch"
    )
    mapping_by_asset = {mapping["stable_ground_id"]: mapping for mapping in mappings}
    mapparam = parse_mapparam(archive, floor_counts)
    names = parse_french_dungeon_names(rom)
    remap = rom[GRAPHICS_REMAP_OFFSET : GRAPHICS_REMAP_OFFSET + GRAPHICS_REMAP_COUNT]
    water_types = rom[WATER_TYPE_OFFSET : WATER_TYPE_OFFSET + WATER_TYPE_COUNT]
    manifest = json.loads((candidate / "manifest.json").read_text(encoding="utf-8"))
    candidate_assets = [item["asset"] for item in manifest["grounds"]]
    require(
        len(candidate_assets) == len(set(candidate_assets))
        and set(candidate_assets) == set(mapping_by_asset),
        "candidate Ground inventory differs from the ROM mapping table",
    )
    lua = LuaRuntime(unpack_returned_tuples=True)
    displayed_states = 0
    raw_states = 0
    canonical_descriptors = 0
    active_canm_descriptors = 0
    runtime_mutated_descriptors = 0

    with tempfile.TemporaryDirectory(
        prefix="pmdred-direct-rom-validation-"
    ) as directory:
        extraction = Path(directory)
        ground_audit.audit_rom(rom, rom_path.name, extract_dir=extraction)
        for item in manifest["grounds"]:
            asset = item["asset"]
            require(
                asset in mapping_by_asset, f"{asset}: not in ROM direct mapping table"
            )
            mapping = mapping_by_asset[asset]
            require(
                item["mapping_index"] == mapping["index"],
                f"{asset}: mapping index mismatch",
            )
            dependency = map_files[mapping["map_file_id"]]
            require(
                item["source"]["map_file_id"] == mapping["map_file_id"]
                and item["source"]["bma"] == dependency["bma"],
                f"{asset}: Ground archive relationship differs from ROM",
            )
            bma = (extraction / f"{dependency['bma']}.bma").read_bytes()
            require(
                item["source"]["bma_sha256"] == sha256(bma),
                f"{asset}: BMA hash mismatch",
            )
            terrain, bma_metadata = decode_bma_terrain(bma, asset)
            auxiliary = decode_bma_auxiliary_layers(bma, asset)
            geometry = bma_metadata["header"]
            width = geometry["map_width_tiles"]
            height = geometry["map_height_tiles"]
            require(
                item["geometry"]["width"] == width
                and item["geometry"]["height"] == height,
                f"{asset}: geometry differs from ROM",
            )
            dungeon_id = mapping["dungeon_id"]
            selector_index = mapping["runtime_floor_zero_based"]
            selector = mapparam["selectors"][dungeon_id]["rows"][selector_index]
            prop = mapparam["properties"][selector["property_index"]]
            tileset = prop["tileset"]
            graphics = remap[tileset]
            require(
                item["dungeon"]
                == {
                    "id": dungeon_id,
                    "french_name": names[dungeon_id]["primary"],
                    "playable_floor_count": floor_counts[dungeon_id]["floor_count"] - 1,
                    "selector_row": selector_index,
                    "tileset": tileset,
                    "graphics_resource_index": graphics,
                },
                f"{asset}: dungeon relationship differs from ROM",
            )
            font_name = f"b{graphics:02d}fon"
            cel_name = f"b{graphics:02d}cel"
            material_name = (
                f"b{tileset:02d}emap0" if tileset >= 64 else f"b{graphics:02d}cex"
            )
            palette_name = f"b{tileset:02d}pal"
            canm_name = f"b{tileset:02d}canm"
            require(
                item["source"]["resources"]
                == [font_name, cel_name, material_name, palette_name, canm_name],
                f"{asset}: dungeon resources differ from ROM",
            )
            font, _ = archive.decompress(font_name)
            cel, _ = archive.decompress(cel_name, expected_size=CEL_DECOMPRESSED_SIZE)
            material, _ = archive.decompress(
                material_name,
                expected_size=(
                    EMAP_DECOMPRESSED_SIZE if tileset >= 64 else CEX_DECOMPRESSED_SIZE
                ),
            )
            palette_bytes, _ = archive.raw(palette_name, 12 * 16 * 4)
            animations, _ = parse_canm(archive, canm_name)
            palette = parse_ground_palette(palette_bytes)
            chunks = compose_ground_chunks(
                terrain,
                geometry["map_height_chunks"],
                tileset,
                material,
                default=3 if water_types[tileset] == 2 else 0,
            )
            renderer = DungeonGroundRenderer(font, cel)
            cells_by_descriptor = canonical_cells(
                renderer,
                chunks,
                geometry["map_width_chunks"],
                geometry["map_height_chunks"],
                width,
                height,
            )
            canonical_descriptors += len(cells_by_descriptor)

            collision_records = item["bma"]["collisions"]
            require(
                len(collision_records) == len(auxiliary.collisions),
                f"{asset}: collision count",
            )
            for record, canonical in zip(collision_records, auxiliary.collisions):
                require(
                    (candidate / record["path"]).read_bytes() == canonical,
                    f"{asset}: collision bytes",
                )
            unknown_record = item["bma"]["unknown_data"]
            if auxiliary.unknown_data is None:
                require(unknown_record is None, f"{asset}: fabricated unknown data")
            else:
                require(
                    unknown_record is not None
                    and (candidate / unknown_record["path"]).read_bytes()
                    == auxiliary.unknown_data,
                    f"{asset}: unknown data differs from ROM",
                )

            ground = load_ground(candidate / item["outputs"]["ground"]["path"])
            atlas_payloads = read_tile(
                candidate / item["outputs"]["tile_atlas"]["path"]
            )
            atlas_pixels = {
                location: png_pixels(payload)
                for location, payload in atlas_payloads.items()
            }
            descriptors_by_cell = {
                cell: descriptor
                for descriptor, cells in cells_by_descriptor.items()
                for cell in cells
            }
            for x in range(width):
                for y in range(height):
                    frame = ground["Layers"][0]["Tiles"][x][y]["Layers"][0]["Frames"][0]
                    location = (frame["TexLoc"]["X"], frame["TexLoc"]["Y"])
                    require(
                        frame["Sheet"] == f"{asset}_DirectBase", f"{asset}: wrong sheet"
                    )
                    expected = opaque_tile_pixels(
                        renderer._tile(descriptors_by_cell[(x, y)], palette)
                    )
                    require(
                        atlas_pixels[location] == expected,
                        f"{asset}: tick-zero cell {(x, y)}",
                    )

            metadata = lua.execute(
                (candidate / item["outputs"]["animation_metadata"]["path"]).read_text(
                    encoding="utf-8"
                )
            )
            require(
                metadata["asset"] == asset
                and metadata["sheet"] == f"{asset}_DirectBase"
                and metadata["gba_master_clock"] == GBA_MASTER_CLOCK_HZ
                and metadata["gba_cycles_per_frame"] == GBA_CYCLES_PER_FRAME,
                f"{asset}: metadata authority fields differ",
            )
            actual_metadata: dict[int, Any] = {}
            for descriptor_table in lua_sequence(metadata["descriptors"]):
                flat_cells = lua_sequence(descriptor_table["cells"])
                cells = [
                    (int(flat_cells[index]), int(flat_cells[index + 1]))
                    for index in range(0, len(flat_cells), 2)
                ]
                descriptor = descriptors_by_cell[cells[0]]
                require(
                    descriptor not in actual_metadata,
                    f"{asset}: duplicate descriptor metadata",
                )
                require(
                    cells == cells_by_descriptor[descriptor],
                    f"{asset}: descriptor cells differ",
                )
                actual_metadata[descriptor] = descriptor_table

            expected_animated: set[int] = set()
            asset_displayed_states = 0
            asset_raw_states = 0
            asset_active_canm_descriptors = 0
            asset_maximum_states = 0
            for descriptor in cells_by_descriptor:
                records = canonical_record_specs(
                    renderer, descriptor, palette, animations
                )
                raw_records = canonical_record_specs(
                    renderer,
                    descriptor,
                    palette,
                    animations,
                    quantize_for_display=False,
                )
                state_ticks = canonical_state_ticks(records)
                raw_state_ticks = canonical_state_ticks(raw_records)
                asset_displayed_states += len(state_ticks)
                asset_raw_states += len(raw_state_ticks)
                asset_maximum_states = max(asset_maximum_states, len(state_ticks))
                if records:
                    asset_active_canm_descriptors += 1
                if len(state_ticks) <= 1:
                    continue
                expected_animated.add(descriptor)
                table = actual_metadata.get(descriptor)
                require(
                    table is not None, f"{asset}: missing animated descriptor metadata"
                )
                table_records = lua_sequence(table["records"])
                require(
                    len(table_records) == len(records),
                    f"{asset}: record count mismatch",
                )
                for actual, expected in zip(table_records, records):
                    require(
                        int(actual["i"]) == expected["index"]
                        and int(actual["d"]) == expected["duration"]
                        and int(actual["r"]) == expected["raw"]
                        and [int(value) for value in lua_sequence(actual["c"])]
                        == expected["cycle"],
                        f"{asset}: CANM record metadata differs from ROM",
                    )
                states = table["states"]
                actual_keys = {str(key) for key, _ in states.items()}
                require(
                    actual_keys == set(state_ticks),
                    f"{asset}: reached state-key set differs",
                )
                for key, tick in state_ticks.items():
                    location_table = states[key]
                    location = (int(location_table[1]), int(location_table[2]))
                    require(
                        location in atlas_pixels,
                        f"{asset}: state references absent tile",
                    )
                    expected = opaque_tile_pixels(
                        renderer._tile(
                            descriptor, palette_at_tick(palette, animations, tick)
                        )
                    )
                    require(
                        atlas_pixels[location] == expected,
                        f"{asset}: ROM-derived visual state mismatch for {key}",
                    )
            require(
                set(actual_metadata) == expected_animated,
                f"{asset}: metadata contains noncanonical animated descriptors",
            )
            expected_counts = {
                "used_descriptors": len(cells_by_descriptor),
                "animated_descriptors": asset_active_canm_descriptors,
                "runtime_mutated_descriptors": len(expected_animated),
                "raw_palette_tuple_states": asset_raw_states,
                "visual_states": asset_displayed_states,
                "maximum_descriptor_visual_states": asset_maximum_states,
            }
            require(
                all(
                    item["animation"][key] == value
                    for key, value in expected_counts.items()
                ),
                f"{asset}: animation counts differ from independent ROM derivation",
            )
            displayed_states += asset_displayed_states
            raw_states += asset_raw_states
            active_canm_descriptors += asset_active_canm_descriptors
            runtime_mutated_descriptors += len(expected_animated)

    require(canonical_descriptors == 13_467, "ROM-derived descriptor total changed")
    require(active_canm_descriptors == 2_666, "ROM-derived active-CANM total changed")
    require(
        runtime_mutated_descriptors == 2_196,
        "ROM-derived runtime-mutated descriptor total changed",
    )
    require(raw_states == 31_002, "ROM-derived raw palette-tuple state total changed")
    require(displayed_states == 30_211, "ROM-derived displayed-state total changed")
    return {
        "canonical_descriptor_count": canonical_descriptors,
        "active_canm_descriptor_count": active_canm_descriptors,
        "runtime_mutated_descriptor_count": runtime_mutated_descriptors,
        "raw_palette_tuple_state_count": raw_states,
        "displayed_descriptor_state_count": displayed_states,
    }


def validate_candidate_tree(candidate: Path) -> dict[str, Any]:
    manifest = json.loads((candidate / "manifest.json").read_text(encoding="utf-8"))
    require(
        manifest["authority"]["rom_sha256"] == EXPECTED_EU_ROM_SHA256,
        "candidate manifest has wrong ROM authority",
    )
    require(manifest["summary"]["ground_count"] == 27, "expected 27 staged Grounds")
    require(
        manifest["summary"]["raw_palette_tuple_state_count"] == 31_002,
        "raw palette-tuple state count changed",
    )
    require(
        manifest["summary"]["visual_state_count"] == 30_211,
        "GBA visual state count changed",
    )
    require(
        manifest["summary"]["unique_atlas_tile_count"] == 29_515,
        "atlas deduplication count changed",
    )
    require(
        manifest["bma_auxiliary_differential"]["resource_count"] == 201
        and manifest["bma_auxiliary_differential"]["all_match"],
        "all-201 BMA differential is not passing",
    )
    require(
        manifest["scope"]["live_ground_replacements"] == 0
        and manifest["scope"]["live_tile_replacements"] == 0
        and manifest["scope"]["live_scene_replacements"] == 0,
        "candidate improperly claims live promotion",
    )

    atlas_total = 0
    solid_total = 0
    data_blocks = 0
    for item in manifest["grounds"]:
        asset = item["asset"]
        ground_path = candidate / item["outputs"]["ground"]["path"]
        tile_path = candidate / item["outputs"]["tile_atlas"]["path"]
        metadata_path = candidate / item["outputs"]["animation_metadata"]["path"]
        callback_path = candidate / item["outputs"]["callback_adapter"]["path"]
        for record, path in (
            (item["outputs"]["ground"], ground_path),
            (item["outputs"]["tile_atlas"], tile_path),
            (item["outputs"]["animation_metadata"], metadata_path),
            (item["outputs"]["callback_adapter"], callback_path),
        ):
            require(path.is_file(), f"{asset}: missing {path}")
            require(
                path.stat().st_size == record["size"], f"{asset}: output size mismatch"
            )
            require(
                sha256(path.read_bytes()) == record["sha256"],
                f"{asset}: output hash mismatch",
            )

        atlas = read_tile(tile_path)
        require(
            len(atlas) == item["animation"]["unique_atlas_tiles"],
            f"{asset}: atlas count mismatch",
        )
        atlas_total += len(atlas)
        ground = load_ground(ground_path)
        require(
            ground["Released"] is False, f"{asset}: unvalidated candidate is released"
        )
        require(ground["Music"] == "", f"{asset}: unvalidated music was installed")
        require(ground["AssetName"] == asset, f"{asset}: Ground asset mismatch")
        width = item["geometry"]["width"]
        height = item["geometry"]["height"]
        tiles = ground["Layers"][0]["Tiles"]
        obstacles = ground["obstacles"]
        require(
            len(tiles) == width and len(obstacles) == width, f"{asset}: width mismatch"
        )
        require(
            all(len(column) == height for column in tiles)
            and all(len(column) == height for column in obstacles),
            f"{asset}: height mismatch",
        )
        entities = ground["Entities"]
        require(
            all(
                not layer[kind]
                for layer in entities
                for kind in ("MapChars", "GroundObjects", "Spawners", "Markers")
            ),
            f"{asset}: unvalidated or fabricated entities were staged",
        )
        referenced = {
            (
                cell["Layers"][0]["Frames"][0]["TexLoc"]["X"],
                cell["Layers"][0]["Frames"][0]["TexLoc"]["Y"],
            )
            for column in tiles
            for cell in column
        }
        require(
            referenced <= set(atlas), f"{asset}: Ground references absent atlas tiles"
        )

        collision_records = item["bma"]["collisions"]
        require(
            len(collision_records) <= 1, f"{asset}: unresolved collision2 was staged"
        )
        collision = None
        if collision_records:
            collision_path = candidate / collision_records[0]["path"]
            collision = collision_path.read_bytes()
            require(
                len(collision) == width * height, f"{asset}: collision size mismatch"
            )
        obstacle_bytes = bytes(
            bool(obstacles[x][y]["Tags"]) for y in range(height) for x in range(width)
        )
        require(
            obstacle_bytes == (collision or bytes(width * height)),
            f"{asset}: serialized obstacles differ from canonical collision",
        )
        solid_total += sum(obstacle_bytes)
        if item["bma"]["unknown_data_present"]:
            data_blocks += 1
            unknown_record = item["bma"]["unknown_data"]
            unknown = (candidate / unknown_record["path"]).read_bytes()
            require(
                len(unknown) == width * height, f"{asset}: unknown-data size mismatch"
            )
            require(
                sum(value != 0 for value in unknown)
                == item["bma"]["unknown_data_nonzero_cells"],
                f"{asset}: unknown-data count mismatch",
            )
        metadata = metadata_path.read_text(encoding="utf-8")
        callbacks = callback_path.read_text(encoding="utf-8")
        require(
            metadata.startswith("-- Generated from the authoritative PMD Red EU ROM")
            and f'asset="{asset}"' in metadata,
            f"{asset}: malformed animation metadata",
        )
        require(
            "DirectAnimation.Start" in callbacks
            and "DirectAnimation.Update" in callbacks
            and "DirectAnimation.Finish" in callbacks
            and "DirectAnimation.Cancel" in callbacks,
            f"{asset}: incomplete callback ownership",
        )

    require(atlas_total == 29_515, "aggregate atlas count mismatch")
    require(data_blocks == 12, "direct Ground unknown-data count mismatch")
    records = tree_records(candidate)
    require(
        len(records) == EXPECTED_FILE_COUNT,
        f"expected {EXPECTED_FILE_COUNT} candidate files",
    )
    return {
        "ground_count": 27,
        "file_count": len(records),
        "atlas_tile_count": atlas_total,
        "solid_cell_count": solid_total,
        "unknown_data_ground_count": data_blocks,
    }


def validate_lua(root: Path, candidate: Path) -> None:
    try:
        from lupa import LuaRuntime
    except ImportError as exc:  # pragma: no cover - validation environment dependency
        raise ReconstructionError(
            "lupa is required for Lua migration validation"
        ) from exc

    lua = LuaRuntime(unpack_returned_tuples=True)
    for metadata in sorted((candidate / "scripts").glob("*/animation_metadata.lua")):
        value = lua.execute(metadata.read_text(encoding="utf-8"))
        require(
            value["asset"] == metadata.parent.name, f"{metadata}: Lua asset mismatch"
        )
        require(
            value["sheet"].endswith("_DirectBase"), f"{metadata}: Lua sheet mismatch"
        )

    lua.execute(
        """
RogueElements = {Loc = function(x, y) return {X=x,Y=y} end}
RogueEssence = {Dungeon = {TileFrame = function(loc, sheet)
  TILE_FRAME_CALLS = TILE_FRAME_CALLS + 1
  return {TexLoc=loc,Sheet=sheet}
end}}
GAME = {WaitFrames = function(_) error('scheduler should not run in lifecycle test') end}
TASK = {BranchCoroutine = function(_, fn) LAST_BRANCH = fn return fn end}
TILE_FRAME_CALLS = 0
function TEST_MAP()
  return {Layers={[0]={Tiles={[0]={[0]={Layers={[0]={Frames={[0]={}}}}}}}}}}
end
"""
    )
    module = lua.execute(
        (root / "Data/Script/halcyon/RedDirectGroundAnimation.lua").read_text(
            encoding="utf-8"
        )
    )
    data = lua.execute(
        "return {asset='test',sheet='sheet',layer=0,gba_master_clock=16777216,"
        "gba_cycles_per_frame=280896,descriptors={{cells={0,0},records={{i=1,d=2,r=0,c={1,0}}},"
        "states={['0']={1,2},['1']={3,4}}}}}"
    )
    map1 = lua.eval("TEST_MAP()")
    map2 = lua.eval("TEST_MAP()")
    module.Start(map1, data)
    require(module.ActiveAsset() == "test", "runtime module did not start")
    module.Start(map2, data)
    require(lua.globals().TILE_FRAME_CALLS == 2, "re-entry did not reapply tick zero")
    require(
        module.Cancel(map1) is False, "stale-map cancellation stopped current scheduler"
    )
    require(module.Finish(map2) is True, "runtime module did not finish")
    require(module.ActiveAsset() is None, "runtime module leaked active state")


def validate(rom: Path, candidate: Path, repo_root: Path) -> dict[str, Any]:
    candidate_summary = validate_candidate_tree(candidate)
    rom_correspondence = validate_rom_correspondence(rom, candidate)
    validate_lua(repo_root, candidate)
    with tempfile.TemporaryDirectory(prefix="pmdred-direct-repro-") as directory:
        regenerated = Path(directory) / "candidate"
        regenerated.mkdir()
        migrate(rom, regenerated, repo_root)
        regenerated_summary = validate_candidate_tree(regenerated)
        expected = tree_records(candidate)
        actual = tree_records(regenerated)
        require(set(actual) == set(expected), "regenerated candidate inventory differs")
        mismatches = [path for path in expected if expected[path] != actual[path]]
        require(
            not mismatches, f"regenerated candidate bytes differ: {mismatches[:10]}"
        )
    return {
        "candidate": candidate_summary,
        "rom_correspondence": rom_correspondence,
        "regenerated": regenerated_summary,
        "reproducible": True,
        "lua_lifecycle": True,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("rom", type=Path)
    parser.add_argument("candidate", type=Path)
    parser.add_argument(
        "--repo-root", type=Path, default=Path(__file__).resolve().parent.parent
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        result = validate(args.rom, args.candidate, args.repo_root)
    except (
        OSError,
        KeyError,
        IndexError,
        ValueError,
        json.JSONDecodeError,
        ReconstructionError,
    ) as exc:
        raise SystemExit(f"migration validation failed: {exc}") from exc
    summary = result["candidate"]
    print(
        f"Validated {summary['ground_count']} Grounds, {summary['file_count']} files, "
        f"{summary['atlas_tile_count']} atlas tiles; regeneration is byte-identical"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
