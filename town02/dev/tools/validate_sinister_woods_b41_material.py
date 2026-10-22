#!/usr/bin/env python3
"""Independently validate the staged b41 PMDO material candidate.

This validator re-reads the authenticated ROM, re-derives the CEX chunk IDs,
CANM records and PMDO 24x24 render states, then checks every serialized
AutoTile variant and every referenced atlas frame. It never reads the
reconstruction script's manifest as authority for source bytes and never
writes production assets.
"""
from __future__ import annotations

import argparse
import io
import json
import struct
import sys
from pathlib import Path
from typing import Any

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from pmdred_dungeon_ground import (  # noqa: E402
    DungeonArchive,
    DungeonGroundRenderer,
    EXPECTED_EU_ROM_SHA256,
    GROUND_CHUNK_COUNT,
    gba_display_rgb,
    parse_canm,
    parse_ground_palette,
    sha256,
)

CODES = (
    0x00, 0x01, 0x02, 0x03, 0x13, 0x04, 0x05, 0x06, 0x26,
    0x07, 0x17, 0x27, 0x37, 0x08, 0x09, 0x89, 0x0A, 0x0B,
    0x1B, 0x8B, 0x9B, 0x0C, 0x4C, 0x0D, 0x4D, 0x8D, 0xCD,
    0x0E, 0x2E, 0x4E, 0x6E, 0x0F, 0x1F, 0x2F, 0x3F, 0x4F,
    0x5F, 0x6F, 0x7F, 0x8F, 0x9F, 0xAF, 0xBF, 0xCF, 0xDF,
    0xEF, 0xFF,
)
PREFIX = {"wall": 0x000, "secondary": 0x100, "floor": 0x200}
FILES = {
    "floor": "treeshroud_forest_1_floor.json",
    "wall": "treeshroud_forest_1_wall.json",
    "secondary": "treeshroud_forest_1_secondary.json",
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read_tile(path: Path) -> dict[tuple[int, int], Image.Image]:
    raw = path.read_bytes()
    require(len(raw) >= 8, "tile sheet header truncated")
    tile_size, count = struct.unpack_from("<II", raw, 0)
    require(tile_size == 24, f"candidate tile size is {tile_size}, expected 24")
    table: dict[tuple[int, int], int] = {}
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        x = key & 0xFFFFFFFF
        y = key >> 32
        require((x, y) not in table, f"duplicate atlas coordinate {x},{y}")
        table[(x, y)] = offset
    images: dict[tuple[int, int], Image.Image] = {}
    for key, offset in table.items():
        require(offset + 8 <= len(raw), f"atlas offset out of bounds {key}")
        length = struct.unpack_from("<q", raw, offset)[0]
        require(length > 0 and offset + 8 + length <= len(raw), f"atlas PNG span invalid {key}")
        image = Image.open(io.BytesIO(raw[offset + 8 : offset + 8 + length])).convert("RGBA")
        require(image.size == (24, 24), f"atlas image {key} has size {image.size}")
        images[key] = image
    return images


def coord(chunk_id: int, region: int, state: int = 0) -> tuple[int, int]:
    return (
        chunk_id % 16,
        ((region * 16 + state) * 16) + chunk_id // 16,
    )


def get_frame(layer: dict[str, Any], images: dict[tuple[int, int], Image.Image], sheet_name: str, index: int = 0) -> Image.Image:
    frame = layer["Frames"][index]
    require(frame["Sheet"] == sheet_name, "frame points to a foreign tile sheet")
    loc = frame["TexLoc"]
    key = (int(loc["X"]), int(loc["Y"]))
    require(key in images, f"frame references missing atlas coordinate {key}")
    return images[key]


def compose_layers(layers: list[dict[str, Any]], images: dict[tuple[int, int], Image.Image], states: dict[int, int], sheet_name: str) -> Image.Image:
    result = Image.new("RGBA", (24, 24), (0, 0, 0, 0))
    for layer_index, layer in enumerate(layers):
        frame_index = states.get(layer_index, 0)
        result.alpha_composite(get_frame(layer, images, sheet_name, frame_index))
    return result


def manual_palette(base: list[tuple[int, int, int, int]], records: list[Any], selected: dict[int, int]) -> list[tuple[int, int, int, int]]:
    palette = list(base)
    for index, state in selected.items():
        palette[160 + index] = records[index].colors[state]
    return palette


def validate(rom_path: Path, candidate: Path) -> dict[str, Any]:
    rom = rom_path.read_bytes()
    require(sha256(rom) == EXPECTED_EU_ROM_SHA256, "validator ROM hash mismatch")
    archive = DungeonArchive(rom)
    fon, _ = archive.decompress("b41fon", expected_size=13280)
    cel, _ = archive.decompress("b41cel", expected_size=4500)
    cex, _ = archive.decompress("b41cex", expected_size=2352)
    pal, _ = archive.raw("b41pal", 768)
    records, canm_meta = parse_canm(archive, "b41canm")
    require(canm_meta["active_record_count"] == 16, "CANM active count mismatch")
    base = parse_ground_palette(pal)
    renderer = DungeonGroundRenderer(fon, cel)
    animated_by_chunk = {
        chunk_id: sorted(renderer.used_animation_indices([chunk_id] + [0] * 63, 1, 1))
        for chunk_id in range(GROUND_CHUNK_COUNT)
    }
    candidate_manifest = json.loads((candidate / "manifest.json").read_text(encoding="utf-8"))
    namespace = candidate_manifest.get("namespace", {"sheet": "TreeshroudForest1", "autotile_files": dict(FILES)})
    sheet_name = namespace["sheet"]
    candidate_files = namespace["autotile_files"]
    startup_adapter = bool(candidate_manifest.get("animation_adapter", {}).get("one_shot_startup_adapter", False))
    atlas_path = candidate / "Content/Tile" / f"{sheet_name}.tile"
    images = read_tile(atlas_path)
    expected_atlas_coordinates = GROUND_CHUNK_COUNT * (1 + 16 * 16 + (16 if startup_adapter else 0))
    require(len(images) == expected_atlas_coordinates, f"atlas coordinate count {len(images)} != {expected_atlas_coordinates}")
    results: dict[str, Any] = {}
    layer_checks = 0
    pixel_checks = 0
    for category, filename in candidate_files.items():
        payload = json.loads((candidate / "Data/AutoTile" / filename).read_text(encoding="utf-8"))
        obj = payload["Object"]
        require(obj["$type"] == "RogueEssence.Data.AutoTileData, RogueEssence", f"{category}: wrong data type")
        tiles = obj["Tiles"]
        require(tiles["$type"] == "RogueEssence.Dungeon.AutoTileAdjacent, RogueEssence", f"{category}: wrong AutoTile type")
        actual_codes = [int(key.removeprefix("Tilex"), 16) for key in tiles if key.startswith("Tilex")]
        require(actual_codes == list(CODES), f"{category}: AutoTile code order/set differs from PMDO supported cases")
        category_result = {"codes": len(CODES), "variants": 3, "layer_checks": 0, "pixel_checks": 0, "animated_chunks": 0}
        for code in CODES:
            variants = tiles[f"Tilex{code:02X}"]
            require(len(variants) == 3, f"{category} 0x{code:02X}: variant count is not 3")
            expected_ids = [cex[(PREFIX[category] + code) * 3 + variant] for variant in range(3)]
            for variant, layers in enumerate(variants):
                chunk_id = expected_ids[variant]
                used = animated_by_chunk[chunk_id]
                expected_layer_count = 1 + len(used) if used else 1
                require(len(layers) == expected_layer_count, f"{category} 0x{code:02X} v{variant}: layer count drift")
                base_layer = layers[0]
                require(base_layer["FrameLength"] == 999 and len(base_layer["Frames"]) == 1, f"{category} 0x{code:02X} v{variant}: base layer drift")
                require(base_layer["Frames"][0]["TexLoc"] == {"X": chunk_id % 16, "Y": chunk_id // 16}, f"{category} 0x{code:02X} v{variant}: base coordinate drift")
                for layer_pos, record_index in enumerate(used, 1):
                    layer = layers[layer_pos]
                    record = records[record_index]
                    require(layer["FrameLength"] == record.duration, f"{category} 0x{code:02X} v{variant} r{record_index}: duration drift")
                    expected_frame_count = record.count + (1 if startup_adapter else 0)
                    require(len(layer["Frames"]) == expected_frame_count, f"{category} 0x{code:02X} v{variant} r{record_index}: frame count drift")
                    if startup_adapter:
                        raw_expected = {"X": chunk_id % 16, "Y": (17 * 16 + record_index) * 16 + chunk_id // 16}
                        require(layer["Frames"][0]["TexLoc"] == raw_expected, f"{category} 0x{code:02X} v{variant} r{record_index}: raw startup coordinate drift")
                    for state, frame in enumerate(layer["Frames"][1 if startup_adapter else 0:], 0):
                        expected = {"X": chunk_id % 16, "Y": ((1 + record_index) * 16 + state) * 16 + chunk_id // 16}
                        require(frame["TexLoc"] == expected, f"{category} 0x{code:02X} v{variant} r{record_index} s{state}: coordinate drift")
                    layer_checks += 1
                if used:
                    category_result["animated_chunks"] += 1
                # Compare every independent record state. Other animated
                # records are held at their first published color.
                for record_index in used:
                    record = records[record_index]
                    for state in range(record.count):
                        selected = {index: 0 for index in used}
                        selected[record_index] = state
                        expected_palette = manual_palette(base, records, selected)
                        expected_image = renderer._chunk(chunk_id, expected_palette)
                        actual_states = {0: 0}
                        frame_offset = 1 if startup_adapter else 0
                        for layer_pos, index in enumerate(used, 1):
                            actual_states[layer_pos] = (state if index == record_index else 0) + frame_offset
                        actual_image = compose_layers(layers, images, actual_states, sheet_name)
                        require(actual_image.tobytes() == expected_image.tobytes(), f"{category} 0x{code:02X} v{variant} r{record_index} s{state}: pixel composition mismatch")
                        pixel_checks += 1
        results[category] = category_result
    validation = {
        "schema": "new-era.pmdred-eu.sinister-woods-b41-material-validation.v1",
        "candidate": str(candidate.relative_to(ROOT)) if candidate.is_relative_to(ROOT) else str(candidate),
        "rom_sha256": EXPECTED_EU_ROM_SHA256,
        "source": {"b41fon_sha256": sha256(fon), "b41cel_sha256": sha256(cel), "b41cex_sha256": sha256(cex), "b41pal_sha256": sha256(pal), "b41canm_root_sha256": canm_meta["root_sha256"]},
        "atlas_sha256": sha256(atlas_path.read_bytes()),
        "categories": results,
        "layer_checks": layer_checks,
        "pixel_checks": pixel_checks,
        "canm_independent_durations": {str(record.index): record.duration for record in records if record.active},
        "startup_raw_palette_policy": "staged as a one-shot frame only when the startup adapter candidate is enabled",
        "startup_adapter_candidate": startup_adapter,
        "production_assets_written": False,
        "d04p01_d04p02_touched": False,
        "relic_forest_blobs_touched": False,
        "result": "PASS" if startup_adapter else "PASS_WITH_STARTUP_PHASE_GATE",
        "blockers": [] if startup_adapter else ["ONE_SHOT_GBA_STARTUP_PALETTE_HOLD_NOT_REPRESENTABLE_BY_CYCLIC_PMDO_TILELAYER"],
    }
    (candidate / "validation.json").write_text(json.dumps(validation, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return validation


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, default=Path(".runtime-cache/downloads/pmdred-eu.gba"))
    parser.add_argument("--candidate", type=Path, default=Path(".runtime-cache/sinister-woods-b41-candidate"))
    args = parser.parse_args()
    rom = args.rom if args.rom.is_absolute() else ROOT / args.rom
    candidate = args.candidate if args.candidate.is_absolute() else ROOT / args.candidate
    result = validate(rom, candidate)
    print(json.dumps({"result": result["result"], "blockers": result["blockers"], "pixel_checks": result["pixel_checks"]}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
