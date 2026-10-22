#!/usr/bin/env python3
"""Reconstruct a small, strictly validated PMD building library.

PMD Red BMA geometry is parsed by skytemple-files.  BPC/BPL are decoded with
PMD Red's format (which differs from the NDS BPC implementation).  Structures
are isolated with stable closed-contour masks; this is not a rectangular map
crop.  Every retained RGB pixel is copied unchanged from the source tile
render and traced back to BMA/BPC tile records.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import struct
from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw
from skytemple_files.graphics.bma.handler import BmaHandler

PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"
RAWSSET_COMMIT = "03c80dad937911572f8fb19903771a47956fc696"
MAP_ID = "T01P01"
MASK_THRESHOLDS = (90, 110, 125, 140, 160)
STRUCTURES = (
    {
        "id": "merchant_stand_01",
        "roi": (256, 200, 344, 276),
        "seed": (300, 235),
        "occurrences": [(264, 208)],
        "description": "enclosed outdoor service/merchant stand",
    },
    {
        "id": "merchant_counter_01",
        "roi": (624, 264, 696, 304),
        "seed": (660, 282),
        "occurrences": [(632, 272), (752, 272)],
        "description": "outdoor merchant counter; second map occurrence is pixel-identical",
    },
)
DIRECT_BUILDINGS = (
    ("house_01", "House_Normal.None.png"),
    ("tent_01", "Tent.Flip.png"),
    ("tent_02", "Tent_Plain.Flip.png"),
)


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def parse_bpl(path: Path):
    data = path.read_bytes()
    count = data[0]
    palettes = []
    offset = 4
    for _ in range(count):
        colors = [(0, 0, 0, 0)]
        for _ in range(15):
            colors.append((data[offset], data[offset + 1], data[offset + 2], 255))
            offset += 4
        palettes.append(colors)
    return palettes


def parse_bpc(path: Path):
    data = path.read_bytes()
    chunk_width, chunk_height, tile_count = struct.unpack_from("<HHH", data, 0)
    chunk_count = struct.unpack_from("<H", data, 14)[0]
    tiles = [bytes(32)] + [data[16 + i * 32 : 16 + (i + 1) * 32] for i in range(tile_count - 1)]
    offset = 16 + (tile_count - 1) * 32
    entries_per_chunk = chunk_width * chunk_height
    chunks = [[0] * entries_per_chunk]
    for _ in range(chunk_count - 1):
        chunks.append(list(struct.unpack_from(f"<{entries_per_chunk}H", data, offset)))
        offset += entries_per_chunk * 2
    return chunk_width, chunk_height, tiles, chunks


def render_source(bma, palettes, bpc):
    chunk_width, chunk_height, tiles, chunks = bpc
    width, height = bma.map_width_camera, bma.map_height_camera
    image = Image.new("RGBA", (width * 8, height * 8), (0, 0, 0, 255))
    missing_animated_tiles = set()
    for chunk_y in range(bma.map_height_chunks):
        for chunk_x in range(bma.map_width_chunks):
            chunk_id = bma.layer0[chunk_y * bma.map_width_chunks + chunk_x]
            if chunk_id <= 0 or chunk_id >= len(chunks):
                continue
            for index, entry in enumerate(chunks[chunk_id]):
                tile_index = entry & 0x3FF
                if tile_index == 0:
                    continue
                if tile_index >= len(tiles):
                    missing_animated_tiles.add(tile_index)
                    continue
                flip_x, flip_y, palette_index = (entry >> 10) & 1, (entry >> 11) & 1, (entry >> 12) & 0xF
                tile_x = chunk_x * chunk_width + index % chunk_width
                tile_y = chunk_y * chunk_height + index // chunk_width
                if tile_x >= width or tile_y >= height:
                    continue
                tile = tiles[tile_index]
                palette = palettes[palette_index % len(palettes)]
                for y in range(8):
                    for packed_x in range(4):
                        value = tile[y * 4 + packed_x]
                        for nibble, color_index in enumerate((value & 0xF, value >> 4)):
                            if color_index == 0:
                                continue
                            x = packed_x * 2 + nibble
                            output_x = 7 - x if flip_x else x
                            output_y = 7 - y if flip_y else y
                            image.putpixel((tile_x * 8 + output_x, tile_y * 8 + output_y), palette[color_index])
    return image, missing_animated_tiles


def closed_component_mask(source: Image.Image, roi, seed, threshold: int):
    crop = source.crop(roi).convert("RGBA")
    width, height = crop.size
    pixels = crop.load()
    barrier = {
        (x, y)
        for y in range(height)
        for x in range(width)
        if pixels[x, y][3] and max(pixels[x, y][:3]) < threshold
    }
    exterior = set()
    queue = deque()
    for x in range(width):
        for y in (0, height - 1):
            if (x, y) not in barrier and (x, y) not in exterior:
                exterior.add((x, y)); queue.append((x, y))
    for y in range(height):
        for x in (0, width - 1):
            if (x, y) not in barrier and (x, y) not in exterior:
                exterior.add((x, y)); queue.append((x, y))
    while queue:
        x, y = queue.popleft()
        for point in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= point[0] < width and 0 <= point[1] < height and point not in barrier and point not in exterior:
                exterior.add(point); queue.append(point)
    candidates = {(x, y) for y in range(height) for x in range(width) if (x, y) not in exterior}
    local_seed = (seed[0] - roi[0], seed[1] - roi[1])
    if local_seed not in candidates:
        raise ValueError(f"mask seed is not enclosed at threshold {threshold}: {local_seed}")
    component = {local_seed}
    queue = deque([local_seed])
    while queue:
        x, y = queue.popleft()
        for point in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if point in candidates and point not in component:
                component.add(point); queue.append(point)
    return crop, component


def structure_tile_provenance(bma, bpc, roi, component):
    chunk_width, chunk_height, tiles, chunks = bpc
    records = set()
    for local_x, local_y in component:
        global_x, global_y = roi[0] + local_x, roi[1] + local_y
        tile_x, tile_y = global_x // 8, global_y // 8
        chunk_x, chunk_y = tile_x // chunk_width, tile_y // chunk_height
        chunk_id = bma.layer0[chunk_y * bma.map_width_chunks + chunk_x]
        entry_index = (tile_y % chunk_height) * chunk_width + tile_x % chunk_width
        entry = chunks[chunk_id][entry_index]
        records.add((tile_x, tile_y, chunk_id, entry & 0x3FF, (entry >> 12) & 0xF, (entry >> 10) & 1, (entry >> 11) & 1))
    return [
        {
            "map_tile": [tx, ty], "chunk_id": chunk, "bpc_tile_index": tile,
            "palette_index": palette, "flip_x": bool(fx), "flip_y": bool(fy),
        }
        for tx, ty, chunk, tile, palette, fx, fy in sorted(records)
    ], len(tiles)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pret", required=True, type=Path)
    parser.add_argument("--rawasset", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    args = parser.parse_args()
    map_bg = args.pret.resolve() / "data/map_bg"
    rawasset = args.rawasset.resolve()
    out = args.out.resolve()
    buildings = out / "buildings"
    buildings.mkdir(parents=True, exist_ok=True)

    paths = {ext: map_bg / f"{MAP_ID}{ext}" for ext in (".bpl", "c.bpc", "m.bma")}
    bma = BmaHandler.deserialize(paths["m.bma"].read_bytes())
    palettes = parse_bpl(paths[".bpl"])
    bpc = parse_bpc(paths["c.bpc"])
    source_render, missing_animated = render_source(bma, palettes, bpc)

    rows = []
    for definition in STRUCTURES:
        masks = []
        crop = None
        for threshold in MASK_THRESHOLDS:
            crop, component = closed_component_mask(source_render, definition["roi"], definition["seed"], threshold)
            masks.append(component)
        if any(mask != masks[0] for mask in masks[1:]):
            raise ValueError(f"unstable semantic contour for {definition['id']}")
        component = masks[0]
        isolated = Image.new("RGBA", crop.size, (0, 0, 0, 0))
        for x, y in component:
            isolated.putpixel((x, y), crop.getpixel((x, y)))
        alpha_bbox = isolated.getchannel("A").getbbox()
        if alpha_bbox is None:
            raise ValueError(f"empty structure: {definition['id']}")
        isolated = isolated.crop(alpha_bbox)
        output = buildings / f"{definition['id']}.png"
        isolated.save(output, optimize=True)
        origin = [definition["roi"][0] + alpha_bbox[0], definition["roi"][1] + alpha_bbox[1]]

        # Pixel-perfect comparison against every declared map occurrence.
        occurrence_mismatches = []
        for occurrence in definition["occurrences"]:
            mismatch = 0
            for y in range(isolated.height):
                for x in range(isolated.width):
                    pixel = isolated.getpixel((x, y))
                    if pixel[3] and pixel != source_render.getpixel((occurrence[0] + x, occurrence[1] + y)):
                        mismatch += 1
            occurrence_mismatches.append(mismatch)
        mismatch = occurrence_mismatches[0]
        provenance, static_tile_count = structure_tile_provenance(bma, bpc, definition["roi"], component)
        animated_refs = sorted({row["bpc_tile_index"] for row in provenance if row["bpc_tile_index"] >= static_tile_count})
        if any(occurrence_mismatches) or animated_refs:
            raise ValueError(
                f"source validation failed for {definition['id']}: "
                f"occurrence_mismatches={occurrence_mismatches}, animated={animated_refs}"
            )
        rows.append(
            {
                "id": definition["id"],
                "file": f"buildings/{output.name}",
                "description": definition["description"],
                "source_map": "MAP_POKEMON_SQUARE / pret T01P01",
                "source_map_file_id": 1,
                "source_tileset": [path.name for path in paths.values()],
                "source_position_px": origin,
                "source_occurrences_px": [list(point) for point in definition["occurrences"]],
                "width": isolated.width,
                "height": isolated.height,
                "sha256": sha256_file(output),
                "native_resolution": True,
                "transparent_background": isolated.getchannel("A").getextrema()[0] == 0,
                "npc_included": False,
                "terrain_included": False,
                "pixel_perfect": mismatch == 0,
                "pixel_mismatch_count": mismatch,
                "source_occurrence_pixel_mismatch_counts": occurrence_mismatches,
                "mask_method": "STABLE_CLOSED_DARK_CONTOUR_COMPONENT",
                "mask_thresholds_verified": list(MASK_THRESHOLDS),
                "mask_stable_across_thresholds": True,
                "opaque_pixel_count": sum(isolated.getchannel("A").histogram()[1:]),
                "source_tile_records": provenance,
                "source_animated_tile_references": animated_refs,
                "status": "PIXEL_EXACT_SOURCE_STRUCTURE",
            }
        )

    for structure_id, filename in DIRECT_BUILDINGS:
        source = rawasset / "Object" / filename
        target = buildings / f"{structure_id}.png"
        shutil.copyfile(source, target)
        image = Image.open(target).convert("RGBA")
        rows.append(
            {
                "id": structure_id,
                "file": f"buildings/{target.name}",
                "description": "complete autonomous RawAsset object",
                "source_map": None,
                "source_tileset": f"PMDCollab/RawAsset Object/{filename}",
                "source_position_px": None,
                "width": image.width,
                "height": image.height,
                "sha256": sha256_file(target),
                "native_resolution": True,
                "transparent_background": image.getchannel("A").getextrema()[0] == 0,
                "npc_included": False,
                "terrain_included": False,
                "pixel_perfect": True,
                "pixel_mismatch_count": 0,
                "mask_method": "NOT_REQUIRED_WHOLE_SOURCE_PNG",
                "source_tile_records": [],
                "status": "PIXEL_EXACT_SOURCE_STRUCTURE",
            }
        )

    # Library render on a checkerless neutral background; source payloads remain unchanged.
    card_width, card_height = 240, 190
    preview = Image.new("RGBA", (card_width * 3, card_height * 2), (24, 28, 34, 255))
    draw = ImageDraw.Draw(preview)
    for index, row in enumerate(rows):
        x, y = index % 3 * card_width, index // 3 * card_height
        draw.rectangle((x + 4, y + 4, x + card_width - 4, y + card_height - 4), fill=(38, 44, 54, 255), outline=(82, 94, 112, 255))
        image = Image.open(out / row["file"]).convert("RGBA")
        scale = min(140 / image.width, 125 / image.height, 2)
        shown = image.resize((round(image.width * scale), round(image.height * scale)), Image.Resampling.NEAREST)
        preview.alpha_composite(shown, (x + (card_width - shown.width) // 2, y + 12))
        draw.text((x + 10, y + 145), row["id"], fill=(255, 255, 255, 255))
        draw.text((x + 10, y + 165), f"{row['width']}x{row['height']}  {row['sha256'][:14]}", fill=(175, 195, 215, 255))
    preview_path = out / "library.png"
    preview.save(preview_path, optimize=True)

    manifest = {
        "schema": 1,
        "source_authorities": {
            "pret_pmd_red": {"commit": PRET_COMMIT, "map": MAP_ID},
            "skytemple_files": {"version": "1.8.5", "role": "BMA geometry and layer decoding"},
            "pmdcollab_rawasset": {"commit": RAWSSET_COMMIT},
        },
        "source_hashes": {path.name: sha256_file(path) for path in paths.values()},
        "rules": {
            "rectangular_map_crops": False,
            "terrain_pixels": False,
            "npc_pixels": False,
            "palette_modification": False,
            "interpolation": False,
            "resizing_source_files": False,
        },
        "validation": {
            "source_render_dimensions": list(source_render.size),
            "missing_animated_tile_indices_outside_selected_structures": sorted(missing_animated),
            "selected_structures_use_missing_animated_tiles": False,
            "npc_absence_basis": "BMA/BPC/BPL MAP_BG graphics contain no actor sprite layer",
        },
        "count": len(rows),
        "buildings": rows,
        "render": {"file": "library.png", "dimensions": list(preview.size), "sha256": sha256_file(preview_path)},
        "status": "SOURCE_STRUCTURES_EXTRACTED_PIXEL_EXACT_NOT_PMDO_RUNTIME_VALIDATED_NOT_PLACED",
    }
    (out / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"PMD_STRUCTURE_LIBRARY_PASS buildings={len(rows)} reconstructed={len(STRUCTURES)} direct={len(DIRECT_BUILDINGS)}")


if __name__ == "__main__":
    main()
