#!/usr/bin/env python3
"""Render PMDO ``.rsground`` tile layers to deterministic PNG reference images.

This renderer is intentionally narrow: it visualizes Ground tile geometry and
animation frames.  It does not pretend to reproduce RogueEssence lighting,
weather, camera effects, entities, decorations, or shaders.  Those remain
separate runtime-validation concerns.
"""

from __future__ import annotations

import argparse
import io
import json
import os
import struct
from pathlib import Path

from PIL import Image


def read_tile_sheet(path: Path) -> dict[tuple[int, int], Image.Image]:
    data = path.read_bytes()
    if len(data) < 8:
        raise ValueError(f"{path}: truncated tile header")
    _, count = struct.unpack_from("<II", data, 0)
    # The first uint is serialization metadata (8 in converter output, often
    # 24 in editor output), not the dictionary start.  Entries always follow
    # the eight-byte header; the second uint is their count.
    entries_offset = 8
    entries_end = entries_offset + count * 16
    if entries_end > len(data):
        raise ValueError(f"{path}: truncated tile index")
    result: dict[tuple[int, int], Image.Image] = {}
    for index in range(count):
        key, blob_offset = struct.unpack_from("<QQ", data, entries_offset + index * 16)
        if blob_offset < entries_end:
            raise ValueError(f"{path}: tile blob {index} overlaps tile index")
        if blob_offset + 8 > len(data):
            raise ValueError(f"{path}: tile blob {index} offset is out of range")
        (size,) = struct.unpack_from("<Q", data, blob_offset)
        start = blob_offset + 8
        end = start + size
        if end > len(data):
            raise ValueError(f"{path}: tile blob {index} is truncated")
        with Image.open(io.BytesIO(data[start:end])) as image:
            result[(key & 0xFFFFFFFF, key >> 32)] = image.convert("RGBA")
    return result


class SheetLoader:
    def __init__(self, tile_directories: list[Path]):
        self.tile_directories = tile_directories
        self.cache: dict[str, dict[tuple[int, int], Image.Image]] = {}

    def load(self, name: str) -> dict[tuple[int, int], Image.Image]:
        if name in self.cache:
            return self.cache[name]
        relative = Path(name + ".tile")
        candidates = [directory / relative for directory in self.tile_directories]
        path = next((candidate for candidate in candidates if candidate.is_file()), None)
        if path is None:
            raise FileNotFoundError(
                f"tile sheet {name!r} not found in "
                + ", ".join(str(directory) for directory in self.tile_directories)
            )
        sheet = read_tile_sheet(path)
        self.cache[name] = sheet
        return sheet


def ground_dimensions(layers: list[dict]) -> tuple[int, int]:
    widths = [len(layer.get("Tiles", [])) for layer in layers]
    width = max(widths, default=0)
    heights = {
        len(column)
        for layer in layers
        for column in layer.get("Tiles", [])
    }
    if len(heights) > 1:
        raise ValueError(f"inconsistent Ground tile-column heights: {sorted(heights)}")
    return width, next(iter(heights), 0)


def render_ground(path: Path, loader: SheetLoader, tick: int = 0) -> tuple[Image.Image, dict]:
    with path.open(encoding="utf-8-sig") as stream:
        document = json.load(stream)
    ground = document["Object"]
    layers = [layer for layer in ground.get("Layers", []) if layer.get("Visible", True)]
    width, height = ground_dimensions(layers)
    canvas = Image.new("RGBA", (width * 8, height * 8), (0, 0, 0, 255))
    used_sheets: set[str] = set()
    missing_cells = 0

    # PMDO serializes map layers from background to foreground.  Each cell may
    # itself have multiple composited tile layers in the same order.
    for map_layer in layers:
        columns = map_layer.get("Tiles", [])
        for x, column in enumerate(columns):
            for y, cell in enumerate(column):
                if not cell:
                    continue
                for tile_layer in cell.get("Layers", []):
                    frames = tile_layer.get("Frames", [])
                    if not frames:
                        continue
                    frame_length = max(1, int(tile_layer.get("FrameLength", 1)))
                    frame = frames[(tick // frame_length) % len(frames)]
                    sheet_name = frame.get("Sheet", "")
                    if not sheet_name:
                        missing_cells += 1
                        continue
                    used_sheets.add(sheet_name)
                    sheet = loader.load(sheet_name)
                    location = frame.get("TexLoc", {})
                    source = sheet.get((int(location.get("X", 0)), int(location.get("Y", 0))))
                    if source is None:
                        # Indexed RogueEssence sheets may omit coordinate 0,0
                        # as their transparent blank sentinel.
                        if (int(location.get("X", 0)), int(location.get("Y", 0))) == (0, 0):
                            continue
                        raise KeyError(
                            f"{path}: {sheet_name} lacks tile "
                            f"({location.get('X', 0)}, {location.get('Y', 0)})"
                        )
                    canvas.alpha_composite(source, (x * 8, y * 8))

    metadata = {
        "ground": path.stem,
        "dimensions_tiles": [width, height],
        "dimensions_pixels": list(canvas.size),
        "tick": tick,
        "visible_layer_count": len(layers),
        "sheets": sorted(used_sheets),
        "empty_sheet_references": missing_cells,
        "scope": "tile layers only; no entities/decorations/weather/lighting/shaders",
    }
    return canvas.convert("RGB"), metadata


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("grounds", nargs="*", help="Ground IDs (without .rsground); default: all")
    parser.add_argument("--ground-dir", default="Data/Ground")
    parser.add_argument("--tile-dir", action="append", dest="tile_dirs")
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--tick", type=int, default=0)
    parser.add_argument("--metadata", help="optional deterministic JSON inventory path")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    ground_dir = Path(args.ground_dir)
    tile_dirs = [Path(path) for path in (args.tile_dirs or ["Content/Tile", "Data/Tile"])]
    if args.grounds:
        paths = [ground_dir / (ground + ".rsground") for ground in args.grounds]
    else:
        paths = sorted(ground_dir.glob("*.rsground"))
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    loader = SheetLoader(tile_dirs)
    records = []
    failures = []
    for path in paths:
        try:
            image, metadata = render_ground(path, loader, args.tick)
            output_path = output_dir / (path.stem + ".png")
            image.save(output_path, "PNG", optimize=True)
            records.append(metadata)
            print(f"OK  {path.stem:<36} {image.width}x{image.height}")
        except Exception as error:
            failures.append({"ground": path.stem, "error": str(error)})
            print(f"ERR {path.stem:<36} {error}")
    if args.metadata:
        metadata_path = Path(args.metadata)
        metadata_path.parent.mkdir(parents=True, exist_ok=True)
        with metadata_path.open("w", encoding="utf-8", newline="\n") as stream:
            json.dump(
                {
                    "schema": "new-era.ground-tile-render.v1",
                    "ground_directory": str(ground_dir),
                    "tile_directories": [str(path) for path in tile_dirs],
                    "tick": args.tick,
                    "result_count": len(records),
                    "failure_count": len(failures),
                    "results": records,
                    "failures": failures,
                },
                stream,
                ensure_ascii=False,
                sort_keys=True,
                indent=2,
            )
            stream.write("\n")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
