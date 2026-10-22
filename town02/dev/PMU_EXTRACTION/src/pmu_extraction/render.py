from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw, ImageFont

from .constants import LAYER_PAIRS, TILE_SIZE
from .repository import read_gzip_json
from .tilesets import TileArchive
from .util import atomic_write_json, sha256_file


class Renderer:
    def __init__(self, tiles_directory: Path):
        self.archives: dict[int, TileArchive] = {}
        for path in sorted(tiles_directory.glob("Tiles*.tile"), key=lambda p: int(p.stem.removeprefix("Tiles"))):
            number = int(path.stem.removeprefix("Tiles"))
            archive = TileArchive(path, number)
            archive.__enter__()
            self.archives[number] = archive
        self.invalid_references: list[dict[str, Any]] = []

    def close(self):
        for archive in self.archives.values(): archive.__exit__(None, None, None)

    def tile(self, map_id: str, x: int, y: int, layer: str, tileset: int, tile_number: int) -> Image.Image:
        archive = self.archives.get(tileset)
        if archive is None:
            self.invalid_references.append({"map_id": map_id, "x": x, "y": y, "layer": layer, "tileset": tileset, "tile": tile_number, "reason": "missing tileset"})
            archive = self.archives[0]
            tile_number = 0
        elif not 0 <= tile_number < archive.tile_count:
            self.invalid_references.append({"map_id": map_id, "x": x, "y": y, "layer": layer, "tileset": tileset, "tile": tile_number, "reason": "out-of-range tile; original client falls back to tile 0"})
        return archive.image(tile_number)

    def render(self, map_data: dict[str, Any], animated: bool) -> Image.Image:
        width = (map_data["max_x"] + 1) * TILE_SIZE
        height = (map_data["max_y"] + 1) * TILE_SIZE
        # The integrated MapViewer.CaptureMapImage fills its destination white.
        output = Image.new("RGBA", (width, height), (255, 255, 255, 255))
        for tile in map_data["tiles"]:
            x, y = tile["x"], tile["y"]
            for base, base_set, anim, anim_set in LAYER_PAIRS:
                field, set_field = (anim, anim_set) if animated and tile[anim] != 0 else (base, base_set)
                tile_number = tile[field]
                if tile_number == 0:
                    continue
                image = self.tile(map_data["map_id"], x, y, field, tile[set_field], tile_number)
                output.alpha_composite(image, (x * TILE_SIZE, y * TILE_SIZE))
        return output.convert("RGB")


def images_equal(left: Path, right: Path) -> bool:
    with Image.open(left) as a, Image.open(right) as b:
        return a.size == b.size and a.mode == b.mode and a.tobytes() == b.tobytes()


def render_all(global_manifest_path: Path, tiles_directory: Path, output_root: Path, report_path: Path) -> dict:
    global_manifest = json.loads(global_manifest_path.read_text(encoding="utf-8"))
    render_root = output_root / "source" / "renders"
    render_root.mkdir(parents=True, exist_ok=True)
    renderer = Renderer(tiles_directory)
    entries = []
    try:
        for index, map_entry in enumerate(global_manifest["maps"], 1):
            map_data = read_gzip_json(Path(map_entry["canonical_source"]))
            map_dir = render_root / map_data["map_id"]
            map_dir.mkdir(parents=True, exist_ok=True)
            base_path = map_dir / "source.png"
            animated_path = map_dir / "frame-animated.png"
            base = renderer.render(map_data, animated=False)
            base.save(base_path, format="PNG", optimize=False, compress_level=9)
            animated = renderer.render(map_data, animated=True)
            has_animation = any(tile[anim] != 0 for tile in map_data["tiles"] for _, _, anim, _ in LAYER_PAIRS)
            if has_animation:
                animated.save(animated_path, format="PNG", optimize=False, compress_level=9)
                animation_distinct = base.tobytes() != animated.tobytes()
            else:
                animated_path.unlink(missing_ok=True)
                animation_distinct = False
            entry = {
                "map_id": map_data["map_id"], "status": "RENDERED", "source_png": str(base_path),
                "source_png_sha256": sha256_file(base_path), "dimensions_pixels": list(base.size),
                "animated_references_present": has_animation, "animated_frame_distinct": animation_distinct,
                "animated_png": str(animated_path) if has_animation else None,
                "animated_png_sha256": sha256_file(animated_path) if has_animation else None,
            }
            entries.append(entry)
            manifest_path = Path(map_entry["manifest"])
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            manifest["render"] = entry
            manifest["status"] = "RENDERED"
            atomic_write_json(manifest_path, manifest)
            map_entry["status"] = "RENDERED"
            map_entry["source_png"] = str(base_path)
            map_entry["source_png_sha256"] = entry["source_png_sha256"]
        invalid_by_map: dict[str, int] = {}
        for invalid in renderer.invalid_references:
            invalid_by_map[invalid["map_id"]] = invalid_by_map.get(invalid["map_id"], 0) + 1
        report = {
            "status": "RENDERED" if len(entries) == global_manifest["map_count"] else "PARTIAL",
            "map_count": len(entries), "render_root": str(render_root),
            "renderer_reference": "PMU MapRenderer.DrawTiles: base or animated replacement for Ground, Mask, Mask2, Fringe, Fringe2",
            "background_reference": "PMU MapViewer.CaptureMapImage: white",
            "dimensions_policy": "full inclusive 0..MaxX and 0..MaxY; corrects the original CaptureMapImage whole-map off-by-one allocation bug",
            "invalid_graphic_reference_count": len(renderer.invalid_references),
            "invalid_graphic_references_by_map": invalid_by_map,
            "invalid_graphic_references": renderer.invalid_references,
            "maps": entries,
        }
        atomic_write_json(report_path, report)
        # Rendering the selected canonical snapshot does not erase independent blocked
        # sources (for example encrypted V9 caches). Keep global incompleteness explicit.
        global_manifest["canonical_snapshot_render_status"] = report["status"]
        if global_manifest.get("blocked_standard_client_caches"):
            global_manifest["status"] = "PARTIAL"
        else:
            global_manifest["status"] = "RENDERED" if report["status"] == "RENDERED" else "PARTIAL"
        global_manifest["maps"] = global_manifest["maps"]
        global_manifest["render_report"] = str(report_path)
        global_manifest["invalid_graphic_reference_count"] = len(renderer.invalid_references)
        atomic_write_json(global_manifest_path, global_manifest)
        return report
    finally:
        renderer.close()


def make_contact_sheets(global_manifest_path: Path, output_directory: Path, columns: int = 8, cell_width: int = 192, cell_height: int = 160, per_sheet: int = 64) -> dict:
    manifest = json.loads(global_manifest_path.read_text(encoding="utf-8"))
    output_directory.mkdir(parents=True, exist_ok=True)
    sheets = []
    font = ImageFont.load_default()
    maps = [entry for entry in manifest["maps"] if entry.get("source_png")]
    for offset in range(0, len(maps), per_sheet):
        subset = maps[offset:offset + per_sheet]
        rows = (len(subset) + columns - 1) // columns
        sheet = Image.new("RGB", (columns * cell_width, rows * cell_height), "#20242a")
        draw = ImageDraw.Draw(sheet)
        for index, entry in enumerate(subset):
            col = index % columns; row = index // columns
            x0 = col * cell_width; y0 = row * cell_height
            with Image.open(entry["source_png"]) as image:
                image = image.convert("RGB")
                image.thumbnail((cell_width - 8, cell_height - 32), Image.Resampling.NEAREST)
                x = x0 + (cell_width - image.width) // 2
                y = y0 + 4 + (cell_height - 32 - image.height) // 2
                sheet.paste(image, (x, y))
            label = f"{entry['map_id']} {entry['name']}"
            draw.text((x0 + 4, y0 + cell_height - 24), label[:32], fill="white", font=font)
        path = output_directory / f"contact-{offset // per_sheet + 1:03d}.png"
        sheet.save(path, format="PNG", compress_level=9)
        sheets.append({"path": str(path), "sha256": sha256_file(path), "first_map": subset[0]["map_id"], "last_map": subset[-1]["map_id"], "map_count": len(subset)})
    report = {"status": "RENDERED", "sheet_count": len(sheets), "map_count": len(maps), "sheets": sheets, "thumbnail_resampling": "nearest-neighbor; sheets are indexes only and never geometry sources"}
    atomic_write_json(output_directory / "manifest.json", report)
    return report
