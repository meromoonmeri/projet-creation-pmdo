#!/usr/bin/env python3
"""Reconstruct a staging-only PMDO material bundle from Sinister Woods b41.

The procedural rows of dungeon ID 3 select tileset 41 in the EU ROM. This
script reads only the authenticated ROM archive, composes the three PMDO
AutoTile families from the real CEX neighborhood table, and writes an ignored
candidate under ``.runtime-cache``. It never writes Content/Tile or
Data/AutoTile production files.

The CEX has three source variants per neighborhood mask. They become the
three AutoTileAdjacent variants. CANM is decomposed into independent PMDO
TileLayer overlays, one layer per animated palette color, so records with
12-tick and 8-tick durations remain independent instead of being flattened
into a fake global frame schedule. The one-shot raw GBA startup hold is kept
in the manifest; cyclic PMDO layers begin at the first published CANM color
and therefore remain a certification gate until an exact one-shot adapter is
available.
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import shutil
import struct
import sys
from pathlib import Path
from typing import Any

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
TOOLS = ROOT / "tools"
sys.path.insert(0, str(TOOLS))
from pmdred_dungeon_ground import (  # noqa: E402
    DungeonArchive,
    EXPECTED_EU_ROM_SHA256,
    GROUND_CHUNK_COUNT,
    MATERIAL_STRIDE,
    gba_display_rgb,
    parse_canm,
    parse_ground_palette,
    sha256,
)

TOOL_VERSION = "2.0.0-b41-staging"
SHEET = "TreeshroudForest1"
TILE_SIZE = 24
ATLAS_COLUMNS = 16
# Exact switch order in RogueEssence.AutoTileAdjacent.cs. An absent field
# falls back to TilexFF, so all supported cases are emitted.
AUTOTILE_CODES = (
    0x00, 0x01, 0x02, 0x03, 0x13, 0x04, 0x05, 0x06, 0x26,
    0x07, 0x17, 0x27, 0x37, 0x08, 0x09, 0x89, 0x0A, 0x0B,
    0x1B, 0x8B, 0x9B, 0x0C, 0x4C, 0x0D, 0x4D, 0x8D, 0xCD,
    0x0E, 0x2E, 0x4E, 0x6E, 0x0F, 0x1F, 0x2F, 0x3F, 0x4F,
    0x5F, 0x6F, 0x7F, 0x8F, 0x9F, 0xAF, 0xBF, 0xCF, 0xDF,
    0xEF, 0xFF,
)
CATEGORY_PREFIX = {"wall": 0x000, "secondary": 0x100, "floor": 0x200}
CATEGORY_FILES = {
    "floor": "treeshroud_forest_1_floor.json",
    "wall": "treeshroud_forest_1_wall.json",
    "secondary": "treeshroud_forest_1_secondary.json",
}
EXPECTED = {
    "b41fon": (13280, "3ef1d008554a1b3bed72e7af2d199b590d682235aa010533bd2a367c7e661661"),
    "b41cel": (4500, "dedf44516ad9305d64ff67e14bb3c26b4ab53c2c439f3c078a43fa44c976e222"),
    "b41cex": (2352, "2396fa857763baea97cd2104e52c29434e560a390ffaaa95f69da667d87016ea"),
    "b41pal": (768, "f5345e09321e20b67339e561add912eaecfa329fda12d04e5788eefd8ae83fb3"),
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def write_tile(path: Path, entries: dict[tuple[int, int], Image.Image]) -> dict[str, Any]:
    """Write the PMDO tile-sheet format with deterministic PNG deduplication."""
    ordered = sorted(entries.items(), key=lambda item: (item[0][1], item[0][0]))
    encoded: list[tuple[tuple[int, int], bytes]] = []
    for key, image in ordered:
        buf = io.BytesIO()
        image.save(buf, format="PNG", optimize=True)
        encoded.append((key, buf.getvalue()))
    unique: list[bytes] = []
    offsets: dict[bytes, int] = {}
    position = 8 + len(encoded) * 16
    for _, png in encoded:
        if png not in offsets:
            offsets[png] = position
            unique.append(png)
            position += 8 + len(png)
    raw = bytearray(struct.pack("<II", TILE_SIZE, len(encoded)))
    for (x, y), png in encoded:
        raw.extend(struct.pack("<QQ", x | (y << 32), offsets[png]))
    for png in unique:
        raw.extend(struct.pack("<q", len(png)))
        raw.extend(png)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(raw)
    return {
        "path": str(path.relative_to(ROOT)),
        "sha256": sha256(bytes(raw)),
        "size": len(raw),
        "tile_size": TILE_SIZE,
        "tile_count": len(encoded),
        "unique_png_count": len(unique),
        "coordinates": {
            "columns": ATLAS_COLUMNS,
            "base_regions": 1,
            "record_regions": 16,
            "states_per_record": 16,
            "chunks_per_state": GROUND_CHUNK_COUNT,
        },
    }


def tile_coord(chunk_id: int, region: int, state: int = 0, *, raw: bool = False) -> dict[str, Any]:
    # region 0 is the static base layer. Regions 1..16 are CANM records;
    # each record owns 16 chunk-row blocks. Raw startup blocks are allocated
    # after those 17*16 state blocks and are addressed by record index.
    group = (17 * 16 + region) if raw else (region * 16 + state)
    return {
        "Sheet": SHEET,
        "TexLoc": {
            "X": chunk_id % ATLAS_COLUMNS,
            "Y": group * 16 + chunk_id // ATLAS_COLUMNS,
        },
    }


def chunk_descriptors(cel: bytes, chunk_id: int) -> tuple[int, ...]:
    return struct.unpack_from("<9H", cel, chunk_id * 18)


def render_filtered_chunk(
    font: bytes,
    cel: bytes,
    chunk_id: int,
    palette: list[tuple[int, int, int, int]],
    mode: str,
    record_index: int | None = None,
) -> Image.Image:
    """Render a chunk, optionally isolating the CANM palette color layer."""
    image = Image.new("RGBA", (24, 24), (0, 0, 0, 0))
    for descriptor_index, descriptor in enumerate(chunk_descriptors(cel, chunk_id)):
        palette_row = (descriptor >> 12) & 0xF
        tile_index = descriptor & 0x3FF
        hflip = bool(descriptor & 0x0400)
        vflip = bool(descriptor & 0x0800)
        require(tile_index * 32 + 32 <= len(font), f"chunk {chunk_id}: font tile {tile_index} out of bounds")
        tile = Image.new("RGBA", (8, 8), (0, 0, 0, 0))
        pixels = tile.load()
        source = font[tile_index * 32 : tile_index * 32 + 32]
        for y in range(8):
            for pair in range(4):
                value = source[y * 4 + pair]
                for side, color_index in enumerate((value & 0x0F, value >> 4)):
                    if color_index == 0:
                        continue
                    global_index = palette_row * 16 + color_index
                    if mode == "base" and 160 <= global_index < 176:
                        continue
                    if mode == "record" and global_index != 160 + int(record_index):
                        continue
                    r, g, b = gba_display_rgb(palette[global_index])
                    pixels[pair * 2 + side, y] = (r, g, b, 255)
        if hflip:
            tile = tile.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        if vflip:
            tile = tile.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
        image.alpha_composite(tile, ((descriptor_index % 3) * 8, (descriptor_index // 3) * 8))
    return image


def animated_indices(font: bytes, cel: bytes, chunk_id: int) -> list[int]:
    indices: set[int] = set()
    for descriptor in chunk_descriptors(cel, chunk_id):
        row = (descriptor >> 12) & 0xF
        if row not in (10, 11):
            continue
        tile_index = descriptor & 0x3FF
        for value in font[tile_index * 32 : tile_index * 32 + 32]:
            for color_index in (value & 0x0F, value >> 4):
                if color_index:
                    global_index = row * 16 + color_index
                    if 160 <= global_index < 176:
                        indices.add(global_index - 160)
    return sorted(indices)


def auto_tile_payload(
    category: str,
    cex: bytes,
    animated_by_chunk: dict[int, list[int]],
    records: list[Any],
    *,
    startup_adapter: bool,
) -> tuple[dict[str, Any], dict[str, Any]]:
    prefix = CATEGORY_PREFIX[category]
    tiles: dict[str, list[list[dict[str, Any]]]] = {}
    chunk_ids: set[int] = set()
    animated_codes: list[int] = []
    variant_chunk_ids: dict[str, list[int]] = {}
    max_layers = 1
    for code in AUTOTILE_CODES:
        variants: list[list[dict[str, Any]]] = []
        variant_ids: list[int] = []
        for variant in range(3):
            chunk_id = cex[(prefix + code) * 3 + variant]
            require(chunk_id < GROUND_CHUNK_COUNT, f"{category} 0x{code:02X}: invalid chunk {chunk_id}")
            variant_ids.append(chunk_id)
            chunk_ids.add(chunk_id)
        variant_chunk_ids[f"{code:02X}"] = variant_ids
        for chunk_id in variant_ids:
            used = animated_by_chunk[chunk_id]
            if used and code not in animated_codes:
                animated_codes.append(code)
            layers: list[dict[str, Any]] = [
                {"Frames": [tile_coord(chunk_id, 0)], "FrameLength": 999}
            ]
            for record_index in used:
                record = records[record_index]
                frames = []
                if startup_adapter:
                    frames.append(tile_coord(chunk_id, record_index, raw=True))
                frames.extend(
                    tile_coord(chunk_id, 1 + record_index, state)
                    for state in range(record.count)
                )
                layers.append({
                    "Frames": frames,
                    "FrameLength": record.duration,
                })
            max_layers = max(max_layers, len(layers))
            variants.append(layers)
        tiles[f"Tilex{code:02X}"] = variants
    payload = {
        "Version": "0.8.12.0",
        "Object": {
            "$type": "RogueEssence.Data.AutoTileData, RogueEssence",
            "Name": {
                "DefaultText": f"Sinister Woods b41 {category.title()}",
                "LocalTexts": {"fr": f"Bois Sinistre b41 — {category}"},
            },
            "Comment": (
                "STAGING ONLY. Generated from PMD Red EU b41 CEX/CEL/FON/PAL/CANM; "
                "not promoted. AutoTile variants preserve CEX variant 0..2 and "
                "CANM palette colors use independent overlay TileLayers."
            ),
            "Tiles": {
                "$type": "RogueEssence.Dungeon.AutoTileAdjacent, RogueEssence",
                **tiles,
            },
        },
    }
    evidence = {
        "category": category,
        "cex_mask_prefix": prefix,
        "supported_neighbor_code_count": len(AUTOTILE_CODES),
        "supported_neighbor_codes": [f"0x{x:02X}" for x in AUTOTILE_CODES],
        "variant_count": 3,
        "variant_chunk_ids": variant_chunk_ids,
        "unique_chunk_ids": sorted(chunk_ids),
        "animated_neighbor_codes": [f"0x{x:02X}" for x in animated_codes],
        "animated_neighbor_code_count": len(animated_codes),
        "max_tile_layers_per_variant": max_layers,
        "independent_canm_overlay_layers": True,
        "one_shot_startup_adapter_frames": startup_adapter,
    }
    return payload, evidence


def build(rom_path: Path, output: Path, *, startup_adapter: bool = False) -> dict[str, Any]:
    rom = rom_path.read_bytes()
    require(sha256(rom) == EXPECTED_EU_ROM_SHA256, "ROM is not the authenticated PMD Red EU ROM")
    archive = DungeonArchive(rom)
    source: dict[str, bytes] = {}
    source_meta: dict[str, dict[str, Any]] = {}
    for name in ("b41fon", "b41cel", "b41cex"):
        data, meta = archive.decompress(name, expected_size=EXPECTED[name][0])
        source[name] = data
        source_meta[name] = meta
    data, meta = archive.raw("b41pal", EXPECTED["b41pal"][0])
    source["b41pal"] = data
    source_meta["b41pal"] = meta
    for name, data in source.items():
        expected_size, expected_hash = EXPECTED[name]
        require(len(data) == expected_size, f"{name}: size drift")
        require(sha256(data) == expected_hash, f"{name}: hash drift")
    records, canm_meta = parse_canm(archive, "b41canm")
    require(canm_meta["active_record_count"] == 16, "b41canm must have 16 active records")
    require([r.index for r in records if r.active] == list(range(16)), "b41canm active indices drift")
    require(len(source["b41fon"]) % 32 == 0, "b41fon is not whole 4bpp tiles")
    require(len(source["b41cel"]) == GROUND_CHUNK_COUNT * 18, "b41cel is not 250 3x3 chunks")
    base_palette = parse_ground_palette(source["b41pal"])
    animated_by_chunk = {
        chunk_id: animated_indices(source["b41fon"], source["b41cel"], chunk_id)
        for chunk_id in range(GROUND_CHUNK_COUNT)
    }
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)

    # Region 0: each chunk with animated palette slots removed. Regions 1..16:
    # one independently animated record, one state row per record color.
    atlas_entries: dict[tuple[int, int], Image.Image] = {}
    for chunk_id in range(GROUND_CHUNK_COUNT):
        used = animated_by_chunk[chunk_id]
        mode = "base" if used else "full"
        atlas_entries[(chunk_id % ATLAS_COLUMNS, chunk_id // ATLAS_COLUMNS)] = render_filtered_chunk(
            source["b41fon"], source["b41cel"], chunk_id, base_palette, mode
        )
        for record_index in range(16):
            record = records[record_index]
            for state, color in enumerate(record.colors):
                palette = list(base_palette)
                palette[160 + record_index] = color
                atlas_entries[(chunk_id % ATLAS_COLUMNS, ((1 + record_index) * 16 + state) * 16 + chunk_id // ATLAS_COLUMNS)] = render_filtered_chunk(
                    source["b41fon"], source["b41cel"], chunk_id, palette, "record", record_index
                )
            if startup_adapter:
                atlas_entries[(chunk_id % ATLAS_COLUMNS, (17 * 16 + record_index) * 16 + chunk_id // ATLAS_COLUMNS)] = render_filtered_chunk(
                    source["b41fon"], source["b41cel"], chunk_id, base_palette, "record", record_index
                )
    tile_record = write_tile(output / "Content/Tile" / f"{SHEET}.tile", atlas_entries)
    auto_records = {}
    for category in ("floor", "wall", "secondary"):
        payload, evidence = auto_tile_payload(
            category, source["b41cex"], animated_by_chunk, records,
            startup_adapter=startup_adapter,
        )
        path = output / "Data/AutoTile" / CATEGORY_FILES[category]
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        auto_records[category] = {
            "path": str(path.relative_to(ROOT)),
            "sha256": sha256(path.read_bytes()),
            "size": path.stat().st_size,
            **evidence,
        }

    manifest = {
        "schema": "new-era.pmdred-eu.sinister-woods-b41-material-candidate.v2",
        "tool_version": TOOL_VERSION,
        "candidate_status": "STAGED_STARTUP_ADAPTER_CANDIDATE" if startup_adapter else "STAGED_NOT_PROMOTED",
        "authority": {
            "rom_sha256": EXPECTED_EU_ROM_SHA256,
            "dungeon_id": 3,
            "procedural_tileset": 41,
            "procedural_resources": ["b41fon", "b41cel", "b41cex", "b41pal", "b41canm"],
            "selection_source": "mapparam selector rows 1..12 for dungeon ID 3",
        },
        "namespace": {
            "sheet": SHEET,
            "autotile_files": dict(CATEGORY_FILES),
        },
        "source_resources": {
            name: {"size": len(source[name]), "sha256": sha256(source[name]), "archive": source_meta[name]}
            for name in source
        },
        "b41canm": {
            "record_count": len(records),
            "active_record_count": sum(record.active for record in records),
            "active_indices": [record.index for record in records if record.active],
            "root_sha256": canm_meta["root_sha256"],
            "records": [
                {
                    "index": record.index,
                    "count": record.count,
                    "duration_ticks": record.duration,
                    "cycle_ticks": record.cycle_ticks,
                    "colors_sha256": sha256(bytes(value for color in record.colors for value in color)),
                    "initial_raw_palette_color": list(base_palette[160 + record.index]) if record.active else None,
                    "first_published_color": list(record.colors[0]) if record.active else None,
                }
                for record in records
            ],
        },
        "source_geometry": {
            "font_tile_count": len(source["b41fon"]) // 32,
            "cel_chunk_count": len(source["b41cel"]) // 18,
            "cex_size": len(source["b41cex"]),
            "ground_palette_colors": len(base_palette),
            "pmdo_chunk_size": [24, 24],
            "animated_chunk_count": sum(bool(indices) for indices in animated_by_chunk.values()),
            "animated_palette_indices": list(range(16)),
        },
        "animation_adapter": {
            "independent_record_layers": True,
            "one_shot_startup_adapter": startup_adapter,
            "first_published_state_tick_by_record": {
                str(record.index): record.duration for record in records if record.active
            },
            "raw_gba_startup_palette_sha256": sha256(bytes(value for color in base_palette[160:176] for value in color)),
            "policy": (
                "Each active CANM record is a separate PMDO overlay layer with its source duration and color sequence. "
                + ("Raw startup frames are staged for the runtime one-shot adapter; the adapter must rotate each layer exactly once at its source duration." if startup_adapter else "The one-shot raw GBA startup hold is retained as evidence; cyclic layers begin with first published color and remain a certification gate until exact one-shot behavior is implemented.")
            ),
        },
        "atlas": tile_record,
        "autotiles": auto_records,
        "production_route": {
            "writes_production_content_tile": False,
            "writes_production_autotile": False,
            "resources_to_replace_only": [
                "TreeshroudForest1.tile",
                "Data/AutoTile/treeshroud_forest_1_floor.json",
                "Data/AutoTile/treeshroud_forest_1_wall.json",
                "Data/AutoTile/treeshroud_forest_1_secondary.json",
            ],
            "relic_forest_blobs_modified": False,
            "d04p01_d04p02_modified": False,
        },
    }
    (output / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=Path(".runtime-cache/downloads/pmdred-eu.gba"))
    parser.add_argument("--output", type=Path, default=Path(".runtime-cache/sinister-woods-b41-candidate"))
    parser.add_argument("--startup-adapter", action="store_true", help="include one-shot raw CANM frames for the staged runtime adapter")
    args = parser.parse_args()
    rom = args.rom if args.rom.is_absolute() else ROOT / args.rom
    output = args.output if args.output.is_absolute() else ROOT / args.output
    manifest = build(rom, output, startup_adapter=args.startup_adapter)
    print(json.dumps({"candidate": str(output), "atlas_sha256": manifest["atlas"]["sha256"], "status": manifest["candidate_status"]}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
