#!/usr/bin/env python3
"""Stage exact EU-ROM direct dungeon Grounds as native PMDO candidates.

This is an adapt-first migration, not a live replacement.  It rederives all 27
Ground mappings from the checked European ROM, packs canonical 8x8 descriptor
states into one PMDO ``.tile`` archive per map, serializes exact map-relative
CANM scheduling metadata, and preserves BMA collision/data evidence.  Existing
Grounds, scripts, and reserve imports are inventoried but never overwritten.
"""

from __future__ import annotations

import argparse
import io
import json
import math
import shutil
import struct
import tempfile
from collections import defaultdict
from pathlib import Path
from typing import Any

import audit_pmdred_eu_rom as ground_audit
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
    AnimationRecord,
    DungeonArchive,
    DungeonGroundRenderer,
    ReconstructionError,
    compose_ground_chunks,
    decode_bma_auxiliary_layers,
    decode_bma_terrain,
    differential_validate_bma_auxiliary,
    gba_display_rgb,
    palette_at_tick,
    parse_canm,
    parse_french_dungeon_names,
    parse_ground_palette,
    parse_mapparam,
    require,
    sha256,
)

TOOL_VERSION = "1.0.0"
ATLAS_WIDTH = 128
SHEET_SUFFIX = "_DirectBase"
# First two fields are used/animated descriptor counts.  The third is the
# earlier raw RGBA palette-tuple count, retained so the staged generator proves
# why it is an upper bound rather than silently changing the audit result.
RAW_DESCRIPTOR_AUDIT = {
    "d01p02": (80, 0, 80),
    "d02p02": (127, 44, 560),
    "d03p02": (1030, 0, 1030),
    "d04p02": (199, 0, 199),
    "d05p02": (109, 0, 109),
    "d06p02": (185, 55, 1314),
    "d06p03": (879, 167, 1321),
    "d09p02": (150, 39, 419),
    "d09p03": (972, 151, 1335),
    "d10p02": (172, 54, 666),
    "d10p03": (825, 0, 825),
    "d11p02": (162, 47, 290),
    "d11p03": (1017, 8, 1093),
    "d12p02": (157, 157, 2111),
    "d12p04": (862, 364, 3387),
    "d13p02": (171, 61, 612),
    "d13p03": (989, 346, 2797),
    "d14p01": (1250, 297, 2792),
    "d15p01": (1202, 274, 4726),
    "d16p01": (199, 117, 675),
    "d17p01": (197, 39, 695),
    "d18p01": (198, 47, 312),
    "d19p01": (971, 0, 971),
    "d20p01": (49, 0, 49),
    "d21p01": (1035, 216, 1035),
    "d23p01": (97, 0, 97),
    "d25p01": (183, 183, 1502),
}

# Exact observable states after the GBA 5-bit-to-display conversion.  Some
# distinct source RGB records quantize to the same displayed color.
EXPECTED_VISUAL_STATE_COUNTS = {
    "d01p02": 80,
    "d02p02": 530,
    "d03p02": 1030,
    "d04p02": 199,
    "d05p02": 109,
    "d06p02": 1231,
    "d06p03": 1321,
    "d09p02": 419,
    "d09p03": 1335,
    "d10p02": 612,
    "d10p03": 825,
    "d11p02": 246,
    "d11p03": 1093,
    "d12p02": 2039,
    "d12p04": 3387,
    "d13p02": 503,
    "d13p03": 2797,
    "d14p01": 2792,
    "d15p01": 4726,
    "d16p01": 593,
    "d17p01": 672,
    "d18p01": 312,
    "d19p01": 971,
    "d20p01": 49,
    "d21p01": 1035,
    "d23p01": 97,
    "d25p01": 1208,
}


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(value, indent=2, sort_keys=True, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


def file_record(path: Path, relative_to: Path | None = None) -> dict[str, Any]:
    data = path.read_bytes()
    display_path = path.relative_to(relative_to) if relative_to is not None else path
    return {"path": display_path.as_posix(), "size": len(data), "sha256": sha256(data)}


def png_bytes(image: Image.Image) -> bytes:
    stream = io.BytesIO()
    image.save(stream, "PNG", optimize=False)
    return stream.getvalue()


def opaque_tile(image: Image.Image) -> Image.Image:
    opaque = Image.new("RGB", (8, 8), (0, 0, 0))
    opaque.paste(image, (0, 0), image)
    return opaque


def write_tile(path: Path, entries: list[tuple[int, bytes]]) -> None:
    """Write PMDO's virtual tile atlas with deduplicated PNG payloads."""

    require(len({key for key, _ in entries}) == len(entries), "duplicate atlas key")
    payloads: dict[bytes, int] = {}
    ordered_payloads: list[bytes] = []
    header_size = 8 + len(entries) * 16
    offset = header_size
    for _, payload in entries:
        if payload not in payloads:
            payloads[payload] = offset
            ordered_payloads.append(payload)
            offset += 8 + len(payload)
    output = bytearray(struct.pack("<II", 8, len(entries)))
    for key, payload in entries:
        output.extend(struct.pack("<QQ", key, payloads[payload]))
    for payload in ordered_payloads:
        output.extend(struct.pack("<Q", len(payload)))
        output.extend(payload)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(output)


def color_state_ids(
    record: AnimationRecord,
    raw_color: tuple[int, int, int, int],
) -> tuple[int, list[int], list[tuple[int, int, int]]]:
    """Assign compact IDs after the GBA's observable 5-bit display conversion."""

    colors = [
        gba_display_rgb(raw_color),
        *(gba_display_rgb(color) for color in record.colors),
    ]
    identities: dict[tuple[int, int, int], int] = {}
    sequence: list[int] = []
    for color in colors:
        if color not in identities:
            identities[color] = len(identities)
        sequence.append(identities[color])
    by_id = [color for color, _ in sorted(identities.items(), key=lambda item: item[1])]
    return sequence[0], sequence[1:], by_id


def record_state_id(record_spec: dict[str, Any], tick: int) -> int:
    if tick < record_spec["duration"]:
        return record_spec["raw"]
    expiry = tick // record_spec["duration"]
    return record_spec["cycle"][(expiry - 1) % len(record_spec["cycle"])]


def reached_state_keys(record_specs: list[dict[str, Any]]) -> list[tuple[int, ...]]:
    if not record_specs:
        return [()]
    period = math.lcm(
        *(record["duration"] * len(record["cycle"]) for record in record_specs)
    )
    startup_end = max(record["duration"] for record in record_specs)
    event_ticks = {0, period}
    for record in record_specs:
        duration = record["duration"]
        event_ticks.update(range(duration, startup_end, duration))
        first = ((period + duration - 1) // duration) * duration
        event_ticks.update(range(first, period * 2, duration))
    keys: list[tuple[int, ...]] = []
    seen: set[tuple[int, ...]] = set()
    for tick in sorted(event_ticks):
        key = tuple(record_state_id(record, tick) for record in record_specs)
        if key not in seen:
            seen.add(key)
            keys.append(key)
    return keys


def used_record_indices(
    renderer: DungeonGroundRenderer,
    descriptor: int,
) -> list[int]:
    palette_index = (descriptor >> 12) & 0xF
    if palette_index not in (10, 11):
        return []
    tile_index = descriptor & 0x3FF
    require(
        tile_index < renderer.tile_count,
        f"descriptor uses unavailable tile {tile_index}",
    )
    source = renderer.font[tile_index * 32 : tile_index * 32 + 32]
    color_indices = {
        color for value in source for color in (value & 0x0F, value >> 4) if color != 0
    }
    return sorted(palette_index * 16 + color - 160 for color in color_indices)


def palette_for_key(
    base_palette: list[tuple[int, int, int, int]],
    record_specs: list[dict[str, Any]],
    key: tuple[int, ...],
) -> list[tuple[int, int, int, int]]:
    palette = list(base_palette)
    for record, state_id in zip(record_specs, key):
        r, g, b = record["colors"][state_id]
        palette[160 + record["index"]] = (r, g, b, 255)
    return palette


def lua_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def lua_metadata(asset: str, sheet: str, specs: list[dict[str, Any]]) -> str:
    """Serialize compact deterministic runtime data, omitting static descriptors."""

    lines = [
        "-- Generated from the authoritative PMD Red EU ROM. Do not hand-edit.",
        "return {",
        f"  asset={lua_string(asset)},sheet={lua_string(sheet)},layer=0,",
        f"  gba_master_clock={GBA_MASTER_CLOCK_HZ},gba_cycles_per_frame={GBA_CYCLES_PER_FRAME},",
        "  descriptors={",
    ]
    for spec in specs:
        if len(spec["states"]) <= 1:
            continue
        flat_cells = ",".join(str(value) for cell in spec["cells"] for value in cell)
        records = ",".join(
            f"{{i={record['index']},d={record['duration']},r={record['raw']},"
            f"c={{{','.join(str(value) for value in record['cycle'])}}}}}"
            for record in spec["records"]
        )
        states = ",".join(
            f"[{lua_string(key)}]={{{location[0]},{location[1]}}}"
            for key, location in spec["states"].items()
        )
        lines.append(
            f"    {{cells={{{flat_cells}}},records={{{records}}},states={{{states}}}}},"
        )
    lines.extend(["  }", "}", ""])
    return "\n".join(lines)


def callback_adapter(asset: str) -> str:
    return f"""-- Generated integration adapter; merge these callbacks, do not replace scene logic.
local DirectAnimation = require 'halcyon.RedDirectGroundAnimation'
local Metadata = require 'halcyon.ground.{asset}.animation_metadata'
local Adapter = {{}}

function Adapter.Init(map)
  DirectAnimation.Start(map, Metadata)
end

function Adapter.Update(map)
  DirectAnimation.Update(map)
end

function Adapter.Exit(map)
  DirectAnimation.Finish(map)
end

function Adapter.Cancel(map)
  DirectAnimation.Cancel(map)
end

return Adapter
"""


def empty_ground(
    asset: str,
    name: str,
    sheet: str,
    width: int,
    height: int,
    grid: list[list[dict[str, Any]]],
    collision: bytes | None,
    comment: str,
) -> dict[str, Any]:
    obstacles = []
    for x in range(width):
        column = []
        for y in range(height):
            blocked = bool(collision[y * width + x]) if collision is not None else False
            column.append(
                {
                    "Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8},
                    "Tags": 1 if blocked else 0,
                }
            )
        obstacles.append(column)
    return {
        "Version": "0.8.9.0",
        "Object": {
            "$type": "RogueEssence.Ground.GroundMap, RogueEssence",
            "TexSize": 1,
            "Name": {"DefaultText": name, "LocalTexts": {}},
            "Released": False,
            "Comment": comment,
            "obstacles": obstacles,
            "rand": {
                "$type": "RogueElements.ReRandom, RogueElements",
                "s": [0, 0, 0, 0],
            },
            "Status": {},
            "Background": {
                "$type": "RogueEssence.Dungeon.MapBG, RogueEssence",
                "MapLoc": {"X": 0, "Y": 0},
                "BGAnim": {
                    "AnimIndex": "",
                    "FrameTime": 1,
                    "StartFrame": -1,
                    "EndFrame": -1,
                    "AnimDir": -1,
                    "Alpha": 255,
                    "AnimFlip": 0,
                },
                "BGMovement": {"X": 0, "Y": 0},
                "Parallax": "0, 0",
                "RepeatX": False,
                "RepeatY": False,
            },
            "BlankBG": {
                "AutoTileset": "",
                "Associates": [],
                "Layers": [],
                "NeighborCode": -1,
            },
            "Layers": [
                {"Name": "Base canonique", "Layer": 0, "Visible": True, "Tiles": grid}
            ],
            "AssetName": asset,
            "Music": "",
            "EdgeView": 0,
            "NoSwitching": False,
            "ViewCenter": None,
            "ViewOffset": {"X": 0, "Y": 0},
            "ActiveChar": None,
            "Decorations": [
                {"Name": "Décor", "Layer": 0, "Visible": True, "Anims": []}
            ],
            "Entities": [
                {
                    "Name": "Événements à migrer depuis les scripts canoniques",
                    "Visible": True,
                    "MapChars": [],
                    "GroundObjects": [],
                    "Spawners": [],
                    "Markers": [],
                }
            ],
        },
    }


def prior_file(root: Path, relative: str) -> dict[str, Any] | None:
    path = root / relative
    if not path.is_file():
        return None
    data = path.read_bytes()
    return {"path": relative, "size": len(data), "sha256": sha256(data)}


def prior_inventory(root: Path, asset: str) -> dict[str, Any]:
    reserve_ground = prior_file(root, f"RESERVE/red_grounds/{asset}.rsground")
    reserve_tile = prior_file(root, f"RESERVE/red_tiles/{asset}_Base.tile")
    cinematic = prior_file(root, f"RESERVE/red_cinematics/{asset}.cif.json")
    live_ground = prior_file(root, f"Data/Ground/{asset}.rsground")
    live_tile = prior_file(root, f"Content/Tile/{asset}_Base.tile")
    return {
        "reserve_ground": reserve_ground,
        "reserve_tile": reserve_tile,
        "reserve_cinematic_inventory": cinematic,
        "live_ground": live_ground,
        "live_tile": live_tile,
        "disposition": {
            "graphics": "not reused; differs from authoritative direct-render path",
            "cinematic": "inventory clue only; requires direct EU event/script validation",
            "live_content": "unchanged by this staged migration",
        },
    }


def generate_descriptor_specs(
    renderer: DungeonGroundRenderer,
    chunks: list[int],
    width_chunks: int,
    height_chunks: int,
    width_tiles: int,
    height_tiles: int,
    base_palette: list[tuple[int, int, int, int]],
    animations: list[AnimationRecord],
) -> tuple[
    list[dict[str, Any]],
    list[tuple[int, bytes]],
    dict[tuple[int, ...], tuple[int, int]],
]:
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

    png_to_location: dict[bytes, tuple[int, int]] = {}
    location_to_png: list[tuple[int, bytes]] = []
    initial_locations: dict[tuple[int, ...], tuple[int, int]] = {}
    specs: list[dict[str, Any]] = []
    for descriptor in sorted(cells):
        record_specs: list[dict[str, Any]] = []
        for record_index in used_record_indices(renderer, descriptor):
            record = animations[record_index]
            if not record.active:
                continue
            raw_id, cycle_ids, colors = color_state_ids(
                record, base_palette[160 + record_index]
            )
            record_specs.append(
                {
                    "index": record.index,
                    "duration": record.duration,
                    "raw": raw_id,
                    "cycle": cycle_ids,
                    "colors": colors,
                }
            )
        keys = reached_state_keys(record_specs)
        states: dict[str, tuple[int, int]] = {}
        for key in keys:
            palette = palette_for_key(base_palette, record_specs, key)
            tile = opaque_tile(renderer._tile(descriptor, palette))
            payload = png_bytes(tile)
            if payload not in png_to_location:
                index = len(png_to_location)
                location = (index % ATLAS_WIDTH, index // ATLAS_WIDTH)
                png_to_location[payload] = location
                atlas_key = location[0] | (location[1] << 32)
                location_to_png.append((atlas_key, payload))
            location = png_to_location[payload]
            states[",".join(str(value) for value in key)] = location
        initial_key = tuple(record["raw"] for record in record_specs)
        initial_locations[(descriptor,)] = states[
            ",".join(str(value) for value in initial_key)
        ]
        specs.append(
            {
                "descriptor": descriptor,
                "cells": cells[descriptor],
                "records": record_specs,
                "states": states,
                "initial_key": ",".join(str(value) for value in initial_key),
            }
        )
    return specs, location_to_png, initial_locations


def candidate_grid(
    width: int,
    height: int,
    sheet: str,
    specs: list[dict[str, Any]],
) -> list[list[dict[str, Any]]]:
    locations: dict[tuple[int, int], tuple[int, int]] = {}
    for spec in specs:
        location = spec["states"][spec["initial_key"]]
        for cell in spec["cells"]:
            locations[cell] = location
    require(
        len(locations) == width * height, "descriptor cells do not cover camera grid"
    )
    grid: list[list[dict[str, Any]]] = []
    for x in range(width):
        column = []
        for y in range(height):
            tx, ty = locations[(x, y)]
            column.append(
                {
                    "AutoTileset": "",
                    "Associates": [],
                    "NeighborCode": -1,
                    "Layers": [
                        {
                            "Frames": [{"Sheet": sheet, "TexLoc": {"X": tx, "Y": ty}}],
                            "FrameLength": 60,
                        }
                    ],
                }
            )
        grid.append(column)
    return grid


def validate_tick_zero(
    renderer: DungeonGroundRenderer,
    chunks: list[int],
    geometry: dict[str, int],
    base_palette: list[tuple[int, int, int, int]],
    animations: list[AnimationRecord],
    specs: list[dict[str, Any]],
    atlas_entries: list[tuple[int, bytes]],
) -> str:
    by_location: dict[tuple[int, int], Image.Image] = {}
    for key, payload in atlas_entries:
        location = (key & 0xFFFFFFFF, key >> 32)
        by_location[location] = Image.open(io.BytesIO(payload)).convert("RGB")
    cells: dict[tuple[int, int], tuple[int, int]] = {}
    for spec in specs:
        location = spec["states"][spec["initial_key"]]
        for cell in spec["cells"]:
            cells[cell] = location
    actual = Image.new(
        "RGB",
        (geometry["map_width_tiles"] * 8, geometry["map_height_tiles"] * 8),
        (0, 0, 0),
    )
    for (x, y), location in cells.items():
        actual.paste(by_location[location], (x * 8, y * 8))
    expected = renderer.render(
        chunks,
        geometry["map_width_chunks"],
        geometry["map_height_chunks"],
        geometry["map_width_tiles"] * 8,
        geometry["map_height_tiles"] * 8,
        palette_at_tick(base_palette, animations, 0),
    )
    require(
        actual.tobytes() == expected.tobytes(),
        "candidate tick zero differs from ROM render",
    )
    return sha256(actual.tobytes())


def build_report(manifest: dict[str, Any]) -> str:
    lines = [
        "# Migration directe des Grounds de donjon — PMD Rouge EU",
        "",
        (
            "Cette étape met en réserve 27 candidats PMDO reconstruits depuis les octets de la ROM européenne. "
            "Elle **ne remplace aucun Ground actif** : les entrées, événements, musiques et chorégraphies doivent "
            "encore être validés directement contre les scripts EU avant promotion."
        ),
        "",
        f"- ROM : `{manifest['authority']['rom_sha256']}`",
        f"- Descripteurs utilisés : **{manifest['summary']['used_descriptor_count']:,}**",
        f"- Descripteurs liés à CANM : **{manifest['summary']['animated_descriptor_count']:,}**",
        f"- États de tuples PAL bruts (borne exploratoire) : **{manifest['summary']['raw_palette_tuple_state_count']:,}**",
        f"- États visuels GBA exacts avant déduplication inter-descripteur : **{manifest['summary']['visual_state_count']:,}**",
        f"- Images 8×8 uniques intégrées aux atlas `.tile` : **{manifest['summary']['unique_atlas_tile_count']:,}**",
        f"- BMAs comparés à SkyTemple : **{manifest['bma_auxiliary_differential']['resource_count']} / 201**",
        "",
        (
            "Le planificateur conserve le tick zéro PAL brut, les expirations indépendantes de chaque record CANM "
            "et la cadence GBA rationnelle. Les 31 002 tuples de couleurs source se réduisent à 30 211 états "
            "réellement affichables après la conversion couleur 5 bits du GBA; cette correction mesurée évite "
            "d'encoder des doublons invisibles. Les cellules sont groupées par descripteur et une texture n'est "
            "remplacée que lorsque sa clé visuelle change. Les blocs BMA inconnus sont archivés séparément de la collision."
        ),
        "",
        "| Ground | Donjon français | Grille | Descripteurs | CANM | PAL brut | États GBA | Atlas | Solides | Données BMA |",
        "|---|---|---:|---:|---:|---:|---:|---:|---:|---:|",
    ]
    for item in manifest["grounds"]:
        lines.append(
            f"| `{item['asset']}` | {item['dungeon']['french_name']} | "
            f"{item['geometry']['width']}×{item['geometry']['height']} | "
            f"{item['animation']['used_descriptors']} | "
            f"{item['animation']['animated_descriptors']} | "
            f"{item['animation']['raw_palette_tuple_states']} | "
            f"{item['animation']['visual_states']} | "
            f"{item['animation']['unique_atlas_tiles']} | "
            f"{item['bma']['solid_cells']} | "
            f"{item['bma']['unknown_data_nonzero_cells']} |"
        )
    lines.extend(
        [
            "",
            "## Barrière de promotion",
            "",
            (
                "Les candidats sont marqués `Released: false`, sans marqueur central inventé et sans musique supposée. "
                "La promotion devra fusionner `animation_callbacks.lua` dans les scripts existants plutôt que les "
                "remplacer, puis prouver entrées/sorties, événements, musique, réentrée et nettoyage."
            ),
            "",
        ]
    )
    return "\n".join(lines)


def migrate(rom_path: Path, output: Path, repo_root: Path) -> dict[str, Any]:
    rom = rom_path.read_bytes()
    rom_hash = sha256(rom)
    if rom_hash != EXPECTED_EU_ROM_SHA256:
        raise ReconstructionError(
            f"wrong ROM SHA-256 {rom_hash}; expected authoritative EU {EXPECTED_EU_ROM_SHA256}"
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
        len(mappings) == 27 and sentinel["map_id"] == -1, "invalid direct mapping table"
    )
    names = parse_french_dungeon_names(rom)
    mapparam = parse_mapparam(archive, floor_counts)
    remap = rom[GRAPHICS_REMAP_OFFSET : GRAPHICS_REMAP_OFFSET + GRAPHICS_REMAP_COUNT]
    water_types = rom[WATER_TYPE_OFFSET : WATER_TYPE_OFFSET + WATER_TYPE_COUNT]

    grounds: list[dict[str, Any]] = []
    with tempfile.TemporaryDirectory(prefix="pmdred-eu-migration-") as temp:
        extraction = Path(temp)
        ground_report = ground_audit.audit_rom(
            rom, rom_path.name, extract_dir=extraction
        )
        bma_resources = sorted(
            (path.stem, path.read_bytes()) for path in extraction.glob("*.bma")
        )
        bma_differential = differential_validate_bma_auxiliary(bma_resources)
        require(bma_differential["resource_count"] == 201, "expected 201 BMA resources")

        for mapping in mappings:
            asset = mapping["stable_ground_id"]
            dependency = map_files[mapping["map_file_id"]]
            bma = (extraction / f"{dependency['bma']}.bma").read_bytes()
            terrain, bma_metadata = decode_bma_terrain(bma, asset)
            auxiliary = decode_bma_auxiliary_layers(bma, asset)
            geometry = bma_metadata["header"]
            require(
                (auxiliary.width, auxiliary.height)
                == (geometry["map_width_tiles"], geometry["map_height_tiles"]),
                f"{asset}: BMA camera dimensions disagree",
            )
            require(
                len(auxiliary.collisions) <= 1,
                f"{asset}: PMDO collision2 mapping unresolved",
            )

            dungeon_id = mapping["dungeon_id"]
            selector_index = mapping["runtime_floor_zero_based"]
            selector = mapparam["selectors"][dungeon_id]["rows"][selector_index]
            prop = mapparam["properties"][selector["property_index"]]
            tileset = prop["tileset"]
            graphics = remap[tileset]
            default = 3 if water_types[tileset] == 2 else 0
            font_name = f"b{graphics:02d}fon"
            cel_name = f"b{graphics:02d}cel"
            material_name = (
                f"b{tileset:02d}emap0" if tileset >= 64 else f"b{graphics:02d}cex"
            )
            palette_name = f"b{tileset:02d}pal"
            canm_name = f"b{tileset:02d}canm"
            font, _ = archive.decompress(font_name)
            cel, _ = archive.decompress(cel_name, expected_size=CEL_DECOMPRESSED_SIZE)
            material, _ = archive.decompress(
                material_name,
                expected_size=EMAP_DECOMPRESSED_SIZE
                if tileset >= 64
                else CEX_DECOMPRESSED_SIZE,
            )
            palette_bytes, _ = archive.raw(palette_name, 12 * 16 * 4)
            animations, _ = parse_canm(archive, canm_name)
            palette = parse_ground_palette(palette_bytes)
            chunks = compose_ground_chunks(
                terrain,
                geometry["map_height_chunks"],
                tileset,
                material,
                default=default,
            )
            renderer = DungeonGroundRenderer(font, cel)
            specs, atlas_entries, _ = generate_descriptor_specs(
                renderer,
                chunks,
                geometry["map_width_chunks"],
                geometry["map_height_chunks"],
                geometry["map_width_tiles"],
                geometry["map_height_tiles"],
                palette,
                animations,
            )
            animated_descriptors = sum(bool(spec["records"]) for spec in specs)
            visual_states = sum(len(spec["states"]) for spec in specs)
            raw_counts = RAW_DESCRIPTOR_AUDIT[asset]
            expected_counts = (
                raw_counts[0],
                raw_counts[1],
                EXPECTED_VISUAL_STATE_COUNTS[asset],
            )
            actual_counts = (len(specs), animated_descriptors, visual_states)
            require(
                actual_counts == expected_counts,
                f"{asset}: descriptor-state audit {actual_counts} != {expected_counts}",
            )
            tick0_hash = validate_tick_zero(
                renderer, chunks, geometry, palette, animations, specs, atlas_entries
            )

            sheet = asset + SHEET_SUFFIX
            tile_path = output / "tiles" / f"{sheet}.tile"
            write_tile(tile_path, atlas_entries)
            grid = candidate_grid(
                geometry["map_width_tiles"], geometry["map_height_tiles"], sheet, specs
            )
            comment = (
                "Candidat PMD Rouge EU reconstruit directement depuis la ROM : graphismes CANM, "
                "collision et géométrie validés. Non promu : entrées, scripts, musique et chorégraphie "
                "restent à fusionner après validation canonique; aucun marqueur central n'est inventé."
            )
            ground = empty_ground(
                asset,
                names[dungeon_id]["primary"],
                sheet,
                geometry["map_width_tiles"],
                geometry["map_height_tiles"],
                grid,
                auxiliary.collisions[0] if auxiliary.collisions else None,
                comment,
            )
            ground_path = output / "grounds" / f"{asset}.rsground"
            ground_path.parent.mkdir(parents=True, exist_ok=True)
            ground_path.write_text(
                "\ufeff"
                + json.dumps(ground, ensure_ascii=False, separators=(",", ":")),
                encoding="utf-8",
            )
            metadata_path = output / "scripts" / asset / "animation_metadata.lua"
            metadata_path.parent.mkdir(parents=True, exist_ok=True)
            metadata_path.write_text(
                lua_metadata(asset, sheet, specs), encoding="utf-8"
            )
            callback_path = output / "scripts" / asset / "animation_callbacks.lua"
            callback_path.write_text(callback_adapter(asset), encoding="utf-8")

            evidence_dir = output / "evidence" / asset
            evidence_dir.mkdir(parents=True, exist_ok=True)
            unknown_path = None
            if auxiliary.unknown_data is not None:
                unknown_path = evidence_dir / "unknown_data.u8"
                unknown_path.write_bytes(auxiliary.unknown_data)
            collision_paths = []
            for index, collision in enumerate(auxiliary.collisions):
                collision_path = evidence_dir / f"collision{index + 1}.u8"
                collision_path.write_bytes(collision)
                collision_paths.append(collision_path)

            record = {
                "asset": asset,
                "mapping_index": mapping["index"],
                "dungeon": {
                    "id": dungeon_id,
                    "french_name": names[dungeon_id]["primary"],
                    "playable_floor_count": floor_counts[dungeon_id]["floor_count"] - 1,
                    "selector_row": selector_index,
                    "tileset": tileset,
                    "graphics_resource_index": graphics,
                },
                "geometry": {
                    "width": geometry["map_width_tiles"],
                    "height": geometry["map_height_tiles"],
                    "pixel_width": geometry["map_width_tiles"] * 8,
                    "pixel_height": geometry["map_height_tiles"] * 8,
                },
                "source": {
                    "map_file_id": mapping["map_file_id"],
                    "bma": dependency["bma"],
                    "bma_sha256": sha256(bma),
                    "resources": [
                        font_name,
                        cel_name,
                        material_name,
                        palette_name,
                        canm_name,
                    ],
                },
                "animation": {
                    "used_descriptors": len(specs),
                    "animated_descriptors": animated_descriptors,
                    "runtime_mutated_descriptors": sum(
                        len(spec["states"]) > 1 for spec in specs
                    ),
                    "raw_palette_tuple_states": raw_counts[2],
                    "visual_states": visual_states,
                    "unique_atlas_tiles": len(atlas_entries),
                    "maximum_descriptor_visual_states": max(
                        len(spec["states"]) for spec in specs
                    ),
                    "tick_zero_pixel_sha256": tick0_hash,
                },
                "bma": {
                    "collision_layers": len(auxiliary.collisions),
                    "solid_cells": sum(auxiliary.collisions[0])
                    if auxiliary.collisions
                    else 0,
                    "unknown_data_present": auxiliary.unknown_data is not None,
                    "unknown_data_nonzero_cells": sum(
                        value != 0 for value in auxiliary.unknown_data or b""
                    ),
                    "unknown_data_distinct_values": sorted(
                        set(auxiliary.unknown_data or b"")
                    ),
                    "unknown_data": None
                    if unknown_path is None
                    else file_record(unknown_path, output),
                    "collisions": [
                        file_record(path, output) for path in collision_paths
                    ],
                },
                "outputs": {
                    "ground": file_record(ground_path, output),
                    "tile_atlas": file_record(tile_path, output),
                    "animation_metadata": file_record(metadata_path, output),
                    "callback_adapter": file_record(callback_path, output),
                },
                "prior_inventory": prior_inventory(repo_root, asset),
                "promotion_status": "staged_only",
                "promotion_blockers": [
                    "canonical EU event actors/objects/markers and entrances",
                    "canonical EU music selection and transitions",
                    "scene callback merge without replacing existing narrative logic",
                    "engine loading, re-entry, exit cleanup, and visual runtime capture",
                ],
            }
            evidence_path = evidence_dir / "evidence.json"
            write_json(evidence_path, record)
            record["outputs"]["evidence"] = file_record(evidence_path, output)
            grounds.append(record)

    summary = {
        "ground_count": len(grounds),
        "used_descriptor_count": sum(
            item["animation"]["used_descriptors"] for item in grounds
        ),
        "animated_descriptor_count": sum(
            item["animation"]["animated_descriptors"] for item in grounds
        ),
        "runtime_mutated_descriptor_count": sum(
            item["animation"]["runtime_mutated_descriptors"] for item in grounds
        ),
        "raw_palette_tuple_state_count": sum(
            item["animation"]["raw_palette_tuple_states"] for item in grounds
        ),
        "visual_state_count": sum(
            item["animation"]["visual_states"] for item in grounds
        ),
        "unique_atlas_tile_count": sum(
            item["animation"]["unique_atlas_tiles"] for item in grounds
        ),
        "unknown_data_ground_count": sum(
            item["bma"]["unknown_data_present"] for item in grounds
        ),
    }
    require(
        summary["raw_palette_tuple_state_count"] == 31_002,
        "unexpected raw palette-tuple state count",
    )
    require(summary["visual_state_count"] == 30_211, "unexpected visual state count")
    manifest = {
        "schema": "pmdred-eu-direct-ground-migration-v1",
        "tool": {"name": Path(__file__).name, "version": TOOL_VERSION},
        "authority": {
            "game": "Pokémon Mystery Dungeon: Red Rescue Team (Europe) (En,Fr,De,Es,It)",
            "rom_sha256": rom_hash,
            "content_authority": "EU GBA ROM bytes",
            "technical_reference": "pret/pmd-red runtime semantics",
        },
        "scope": {
            "mode": "non-destructive reserve staging",
            "live_ground_replacements": 0,
            "live_tile_replacements": 0,
            "live_scene_replacements": 0,
            "canonical_graphics": True,
            "canonical_palette_animation": True,
            "canonical_collision": True,
            "canonical_unknown_data_preserved_as_evidence": True,
            "canonical_events_music_and_transitions": False,
        },
        "runtime": {
            "scheduler_module": "Data/Script/halcyon/RedDirectGroundAnimation.lua",
            "ownership": ["Start", "Update", "Finish", "Cancel"],
            "timing": {
                "gba_master_clock_hz": GBA_MASTER_CLOCK_HZ,
                "gba_cycles_per_frame": GBA_CYCLES_PER_FRAME,
                "pmdo_nominal_frames_per_second": 60,
                "conversion": "integer remainder; one 2-frame wait roughly every 219 GBA ticks",
            },
            "texture_updates": "grouped by CEL descriptor; only when visual key changes",
        },
        "fresh_ground_audit": {
            "resource_count": ground_report["ground_archive"]["entry_count"],
            "validation": ground_report["validation"],
        },
        "bma_auxiliary_differential": {
            key: bma_differential[key]
            for key in (
                "resource_count",
                "unknown_data_resource_count",
                "collision_layer_count_histogram",
                "all_match",
            )
        },
        "summary": summary,
        "grounds": grounds,
    }
    write_json(output / "manifest.json", manifest)
    (output / "report.md").write_text(build_report(manifest), encoding="utf-8")
    return manifest


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "rom", type=Path, help="authoritative EU Red Rescue Team GBA ROM"
    )
    parser.add_argument(
        "output", type=Path, help="new or empty reserve output directory"
    )
    parser.add_argument(
        "--repo-root",
        type=Path,
        default=Path(__file__).resolve().parent.parent,
        help="repository root used only to inventory existing candidates/live content",
    )
    parser.add_argument(
        "--overwrite", action="store_true", help="replace output directory only"
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.output.exists():
        if args.overwrite:
            resolved = args.output.resolve()
            root = args.repo_root.resolve()
            if resolved in (Path("/"), root) or root not in resolved.parents:
                raise SystemExit(f"refusing to remove unsafe output path {resolved}")
            shutil.rmtree(args.output)
        elif any(args.output.iterdir()):
            raise SystemExit(f"output is not empty: {args.output} (use --overwrite)")
    args.output.mkdir(parents=True, exist_ok=True)
    try:
        manifest = migrate(args.rom, args.output, args.repo_root)
    except (
        OSError,
        KeyError,
        IndexError,
        json.JSONDecodeError,
        ReconstructionError,
    ) as exc:
        raise SystemExit(f"direct Ground migration failed: {exc}") from exc
    print(
        f"Staged {manifest['summary']['ground_count']} Grounds, "
        f"{manifest['summary']['visual_state_count']} visual states, "
        f"{manifest['summary']['unique_atlas_tile_count']} unique atlas tiles"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
