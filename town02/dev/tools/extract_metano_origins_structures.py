#!/usr/bin/env python3
"""Extract isolated Metano and Explorers of Sky: Origins structures.

Only PMDO object layers are rendered for Metano; terrain/base/river/cliff
layers and entities are never included.  Curated masks remove neighbouring
object-layer decoration.  Origins assets are split on their declared static
animation-frame boundaries, never from a map render.
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import math
import struct
from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw

ORIGINS_COMMIT = "159084383056c9552d174a87cbe098b933fc4a67"
METANO_LAYERS = (4, 5, 6, 7, 8, 9, 10)

# Coordinates are native Metano pixels. Polygons use crop-local pixels.
METANO_SPECS = (
    {
        "id": "metano_cafe",
        "role": "cafe",
        "roi": (960, 496, 1240, 624),
        "seed": (1148, 580),
        "polygon": None,
        "cleanup": (),
        "source_entity": "Cafe_Entrance",
    },
    {
        "id": "metano_kecleon_shop",
        "role": "kecleon_shop",
        "roi": (1024, 760, 1136, 880),
        "seed": (1080, 824),
        "polygon": ((32, 0), (80, 0), (80, 8), (96, 8), (96, 24), (104, 24), (104, 40), (112, 40), (112, 104), (104, 104), (104, 112), (96, 112), (96, 120), (16, 120), (16, 112), (8, 112), (8, 104), (0, 104), (0, 48), (8, 48), (8, 32), (16, 32), (16, 16), (32, 16)),
        "cleanup": ((88, 0, 104, 24), (104, 112, 112, 120)),
        "source_entity": "Shop",
    },
    {
        "id": "metano_house_normal",
        "role": "normal_home",
        "roi": (208, 552, 288, 663),
        "seed": (256, 622),
        "polygon": ((24, 0), (72, 0), (72, 8), (80, 8), (80, 24), (80, 88), (72, 88), (72, 104), (64, 104), (64, 111), (16, 111), (16, 104), (8, 104), (8, 88), (0, 88), (0, 48), (8, 48), (8, 32), (16, 32), (16, 8), (24, 8)),
        "cleanup": ((0, 0, 16, 32),),
        "source_entity": "Normal_Home_Entrance",
    },
    {
        "id": "metano_house_rock",
        "role": "rock_home",
        "roi": (520, 400, 624, 512),
        "seed": (576, 470),
        "polygon": ((40, 16), (72, 16), (72, 24), (88, 24), (88, 32), (96, 32), (96, 48), (104, 48), (104, 96), (96, 96), (96, 112), (88, 112), (88, 120), (16, 120), (16, 112), (8, 112), (8, 96), (0, 96), (0, 56), (8, 56), (8, 40), (16, 40), (16, 32), (32, 32), (32, 24), (40, 24)),
        "cleanup": ((0, 0, 32, 24), (72, 0, 104, 24), (96, 24, 104, 112)),
        "source_entity": "Rock_Home_Entrance",
    },
    {
        "id": "metano_house_fire",
        "role": "fire_home",
        "roi": (168, 405, 280, 504),
        "seed": (224, 465),
        "polygon": ((40, 0), (72, 0), (72, 8), (80, 8), (80, 16), (88, 16), (88, 24), (96, 24), (96, 40), (104, 40), (104, 72), (112, 72), (112, 88), (104, 88), (104, 99), (8, 99), (8, 88), (0, 88), (0, 72), (8, 72), (8, 40), (16, 40), (16, 24), (24, 24), (24, 16), (32, 16), (32, 8), (40, 8)),
        "cleanup": ((0, 0, 32, 16), (80, 0, 112, 16)),
        "source_entity": "Fire_Home_Entrance",
    },
)

BLOCKED_METANO = (
    {"id": "metano_house_grass", "reason": "fence/sign/flowers remain graphically connected to the house in the available object layer"},
    {"id": "metano_house_water", "reason": "bucket/rocks/flowers remain graphically connected to the house in the available object layer"},
    {"id": "metano_house_electric", "reason": "tree/flowers/sign decoration remains graphically connected to the house in the available object layer"},
)

ORIGINS_SHEETS = (
    {"id": "origins_windmill", "file": "Windmill.dir", "frame_width": 64, "frame_height": 72, "frames": 4},
    {"id": "origins_well", "file": "Well.dir", "frame_width": 72, "frame_height": 56, "frames": 4},
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_package(project: Path, cache: dict, sheet: str):
    if sheet in cache:
        return cache[sheet]
    raw = (project / "Content/Tile" / f"{sheet}.tile").read_bytes()
    tile_size, count = struct.unpack_from("<II", raw, 0)
    cells = {}
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        if (x, y) in cells:
            continue
        length = struct.unpack_from("<Q", raw, offset)[0]
        cells[(x, y)] = Image.open(io.BytesIO(raw[offset + 8 : offset + 8 + length])).convert("RGBA")
    cache[sheet] = tile_size, cells
    return cache[sheet]


def load_ground(project: Path, name: str):
    return json.loads((project / "Data/Ground" / f"{name}.rsground").read_text(encoding="utf-8-sig"))["Object"]


def render_object_layers(project: Path, ground_name: str):
    ground = load_ground(project, ground_name)
    pitch = 8 * ground.get("TexSize", 1)
    width, height = len(ground["Layers"][0]["Tiles"]), len(ground["Layers"][0]["Tiles"][0])
    image = Image.new("RGBA", (width * pitch, height * pitch), (0, 0, 0, 0))
    cache = {}
    for layer_index in METANO_LAYERS:
        layer = ground["Layers"][layer_index]
        for x, column in enumerate(layer["Tiles"]):
            for y, cell in enumerate(column):
                for tile_layer in cell.get("Layers", []):
                    frames = tile_layer.get("Frames", [])
                    if not frames:
                        continue
                    frame = frames[0]
                    sheet = frame.get("Sheet", "")
                    if not sheet:
                        continue
                    _, cells = load_package(project, cache, sheet)
                    location = frame.get("TexLoc", {})
                    tile = cells.get((location.get("X"), location.get("Y")))
                    if tile is not None:
                        image.alpha_composite(tile, (x * pitch, y * pitch))
    return ground, image


def apply_mask(source: Image.Image, spec: dict):
    x0, y0, x1, y1 = spec["roi"]
    crop = source.crop(spec["roi"]).convert("RGBA")
    alpha = crop.getchannel("A")
    if spec["polygon"] is not None:
        polygon = Image.new("L", crop.size, 0)
        ImageDraw.Draw(polygon).polygon(spec["polygon"], fill=255)
        alpha = Image.composite(alpha, Image.new("L", crop.size, 0), polygon)
    for left, top, right, bottom in spec["cleanup"]:
        ImageDraw.Draw(alpha).rectangle((left, top, right - 1, bottom - 1), fill=0)

    local_seed = (spec["seed"][0] - x0, spec["seed"][1] - y0)
    if not alpha.getpixel(local_seed):
        raise ValueError(f"transparent mask seed for {spec['id']}: {local_seed}")
    component = {local_seed}
    queue = deque([local_seed])
    while queue:
        x, y = queue.popleft()
        for point in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= point[0] < crop.width and 0 <= point[1] < crop.height and point not in component and alpha.getpixel(point):
                component.add(point); queue.append(point)
    output = Image.new("RGBA", crop.size, (0, 0, 0, 0))
    for x, y in component:
        output.putpixel((x, y), crop.getpixel((x, y)))
    bbox = output.getchannel("A").getbbox()
    if bbox is None:
        raise ValueError(f"empty result for {spec['id']}")
    return output.crop(bbox), [x0 + bbox[0], y0 + bbox[1]], component


def source_records(ground: dict, spec: dict, component: set):
    x0, y0, _, _ = spec["roi"]
    records = set()
    for px, py in component:
        map_x, map_y = (x0 + px) // 8, (y0 + py) // 8
        for layer_index in METANO_LAYERS:
            cell = ground["Layers"][layer_index]["Tiles"][map_x][map_y]
            for tile_layer in cell.get("Layers", []):
                frames = tile_layer.get("Frames", [])
                if not frames:
                    continue
                frame = frames[0]
                sheet = frame.get("Sheet", "")
                location = frame.get("TexLoc", {})
                if sheet:
                    records.add((layer_index, map_x, map_y, sheet, location.get("X"), location.get("Y")))
    return [
        {"layer": layer, "map_cell": [mx, my], "sheet": sheet, "texloc": [tx, ty]}
        for layer, mx, my, sheet, tx, ty in sorted(records)
    ]


def first_dir_png(path: Path):
    raw = path.read_bytes()
    length = struct.unpack_from("<Q", raw, 0)[0]
    payload = raw[8 : 8 + length]
    if not payload.startswith(b"\x89PNG\r\n\x1a\n"):
        raise ValueError(f"invalid PMDO object payload: {path}")
    return payload, Image.open(io.BytesIO(payload)).convert("RGBA")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project", required=True, type=Path)
    parser.add_argument("--origins", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    args = parser.parse_args()
    project, origins, out = args.project.resolve(), args.origins.resolve(), args.out.resolve()
    buildings = out / "buildings"
    buildings.mkdir(parents=True, exist_ok=True)
    rows = []

    for ground_name, variant in (("metano_town", "day"), ("metano_town_nuit", "night")):
        ground, source = render_object_layers(project, ground_name)
        for spec in METANO_SPECS:
            image, origin, component = apply_mask(source, spec)
            output = buildings / f"{spec['id']}_{variant}.png"
            image.save(output, optimize=True)
            mismatches = 0
            for y in range(image.height):
                for x in range(image.width):
                    pixel = image.getpixel((x, y))
                    if pixel[3] and pixel != source.getpixel((origin[0] + x, origin[1] + y)):
                        mismatches += 1
            if mismatches:
                raise ValueError(f"pixel mismatch in {output}: {mismatches}")
            rows.append({
                "id": f"{spec['id']}_{variant}", "role": spec["role"], "variant": variant,
                "file": f"buildings/{output.name}", "source_map": ground_name,
                "source_entity_authority": spec["source_entity"], "source_position_px": origin,
                "source_layers": list(METANO_LAYERS), "source_tile_records": source_records(ground, spec, component),
                "width": image.width, "height": image.height, "sha256": sha256(output),
                "native_resolution": True, "transparent_background": image.getchannel("A").getextrema()[0] == 0,
                "npc_included": False, "terrain_included": False, "pixel_perfect": True,
                "pixel_mismatch_count": 0, "mask_method": "CURATED_OBJECT_LAYER_POLYGON_PLUS_CONNECTED_COMPONENT",
                "status": "PIXEL_EXACT_SOURCE_STRUCTURE",
            })

    # Origins object sheets contain four static animation frames side by side.
    for spec in ORIGINS_SHEETS:
        source_path = origins / "Content/Object" / spec["file"]
        payload, sheet = first_dir_png(source_path)
        expected_size = (spec["frame_width"] * spec["frames"], spec["frame_height"])
        if sheet.size != expected_size:
            raise ValueError(f"unexpected sheet geometry for {source_path}: {sheet.size} != {expected_size}")
        for frame_index in range(spec["frames"]):
            box = (frame_index * spec["frame_width"], 0, (frame_index + 1) * spec["frame_width"], spec["frame_height"])
            frame = sheet.crop(box)
            output = buildings / f"{spec['id']}_frame_{frame_index}.png"
            frame.save(output, optimize=True)
            rows.append({
                "id": f"{spec['id']}_frame_{frame_index}", "role": spec["id"].removeprefix("origins_"),
                "variant": f"animation_frame_{frame_index}", "file": f"buildings/{output.name}",
                "source_map": None, "source_tileset": f"Content/Object/{spec['file']}",
                "source_sheet_sha256": hashlib.sha256(payload).hexdigest(), "source_frame_box": list(box),
                "width": frame.width, "height": frame.height, "sha256": sha256(output),
                "native_resolution": True, "transparent_background": frame.getchannel("A").getextrema()[0] == 0,
                "npc_included": False, "terrain_included": False, "pixel_perfect": True,
                "pixel_mismatch_count": 0, "mask_method": "SOURCE_OBJECT_ANIMATION_FRAME_BOUNDARY",
                "status": "PIXEL_EXACT_SOURCE_STRUCTURE",
            })

    # Compact labeled render; payloads are not rescaled in buildings/.
    columns, card_width, card_height = 4, 260, 210
    preview = Image.new("RGBA", (columns * card_width, math.ceil(len(rows) / columns) * card_height), (24, 28, 34, 255))
    draw = ImageDraw.Draw(preview)
    for index, row in enumerate(rows):
        x, y = index % columns * card_width, index // columns * card_height
        draw.rectangle((x + 4, y + 4, x + card_width - 4, y + card_height - 4), fill=(38, 44, 54, 255), outline=(82, 94, 112, 255))
        image = Image.open(out / row["file"]).convert("RGBA")
        scale = min(180 / image.width, 145 / image.height, 2)
        shown = image.resize((round(image.width * scale), round(image.height * scale)), Image.Resampling.NEAREST)
        preview.alpha_composite(shown, (x + (card_width - shown.width) // 2, y + 10))
        draw.text((x + 10, y + 165), row["id"], fill="white")
        draw.text((x + 10, y + 184), f"{row['width']}x{row['height']}  {row['sha256'][:14]}", fill=(175, 195, 215, 255))
    preview_path = out / "library.png"
    preview.save(preview_path, optimize=True)

    manifest = {
        "schema": 1,
        "source_authorities": {
            "metano": {"repository": "current New Era project", "maps": ["metano_town", "metano_town_nuit"]},
            "explorers_of_sky_origins": {"repository": "https://github.com/Minemaker0430/ExplorersOfSkyOrigins", "commit": ORIGINS_COMMIT, "license_status": "NO_TOP_LEVEL_LICENSE_FOUND"},
        },
        "rules": {"rectangular_map_crops": False, "terrain_layers_used": [], "npc_layers_used": [], "palette_modification": False, "interpolation_source": False, "resizing_source": False},
        "count": len(rows), "buildings": rows,
        "blocked_not_exported": list(BLOCKED_METANO),
        "render": {"file": "library.png", "dimensions": list(preview.size), "sha256": sha256(preview_path)},
        "status": "SOURCE_STRUCTURES_EXTRACTED_PIXEL_EXACT_NOT_PMDO_RUNTIME_VALIDATED_NOT_PLACED",
    }
    (out / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"METANO_ORIGINS_STRUCTURE_LIBRARY_PASS buildings={len(rows)} metano=10 origins=8 blocked=3")


if __name__ == "__main__":
    main()
