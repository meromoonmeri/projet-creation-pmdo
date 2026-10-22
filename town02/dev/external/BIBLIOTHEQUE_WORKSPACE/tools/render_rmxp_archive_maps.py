#!/usr/bin/env python3
"""Render every environmental Map in an archived RMXP fangame.

This bounded extractor exists for LFS-hosted Reminiscencia/Nova sources. It
extracts into an ignored temporary directory, executes no source code, reads
Ruby Marshal with BIBLIOTHEQUE's parser, excludes actor graphics, and emits only
assembled environmental PNGs plus a hash manifest/contact sheet.
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import tempfile
import zipfile
from pathlib import Path
from typing import Any

from inventory_relict import (
    decode_text, graphics_index, ivar, load, parse_map, sha256_file,
    tileset_descriptor, visual_dependencies, write_json,
)
from png_rgba import RGBAImage, load_png, save_png
from render_pmdo_final_maps import draw_label, thumbnail
from render_relict_previews import TILE_SIZE, TileRenderer, render_layers
from ruby_marshal import RubyObject


DEFAULT_EXCLUDED_MAPS = {
    "reminiscencia": {
        463: "CASTING_OR_UI_BAKED_TILE_SCENE",
    },
    "nova": {},
}


def excluded_placeholder(width: int, height: int) -> RGBAImage:
    image = RGBAImage.empty(width, height, (18, 18, 24, 255))
    image.outline_rect(0, 0, width, height, (220, 45, 180, 255), min(8, width, height))
    limit = min(width, height)
    for offset in range(0, limit, 4):
        image.fill_rect(offset, offset, min(4, width - offset), min(4, height - offset), (120, 35, 100, 255))
        image.fill_rect(width - offset - 4, offset, min(4, width - offset), min(4, height - offset), (120, 35, 100, 255))
    return image


def safe_extract(archive: Path, destination: Path) -> None:
    with zipfile.ZipFile(archive) as source:
        for member in source.infolist():
            target = (destination / member.filename).resolve()
            if destination.resolve() not in target.parents and target != destination.resolve():
                raise ValueError(f"archive path traversal: {member.filename}")
        source.extractall(destination)


def discover_project(root: Path) -> Path:
    candidates = sorted(path.parent.parent for path in root.rglob("Data/MapInfos.rxdata"))
    if len(candidates) != 1:
        raise ValueError(f"expected one RMXP project, found {len(candidates)}: {candidates}")
    project = candidates[0]
    required = (project / "Data/Tilesets.rxdata", project / "Graphics/Tilesets")
    if not all(path.exists() for path in required):
        raise ValueError(f"incomplete RMXP project: {project}")
    return project


def row_major_layers(table) -> dict[str, Any]:
    plane = table.x_size * table.y_size
    layers = []
    for z in range(table.z_size):
        rows = []
        for y in range(table.y_size):
            rows.append([
                table.values[z * plane + y * table.x_size + x]
                for x in range(table.x_size)
            ])
        layers.append({"index": z, "rows": rows})
    return {"width": table.x_size, "height": table.y_size, "layers": layers}


def environmental_tile_events(map_obj: RubyObject) -> list[dict[str, int]]:
    result = []
    events = ivar(map_obj, "events", {}) or {}
    for event_id, event in sorted(events.items(), key=lambda row: int(row[0])):
        if not isinstance(event, RubyObject):
            continue
        pages = ivar(event, "pages", []) or []
        if not pages:
            continue
        page = pages[0]
        graphic = ivar(page, "graphic")
        tile_id = int(ivar(graphic, "tile_id", 0)) if isinstance(graphic, RubyObject) else 0
        opacity = int(ivar(graphic, "opacity", 255)) if isinstance(graphic, RubyObject) else 0
        if tile_id and opacity:
            result.append({
                "tile_id": tile_id,
                "opacity": opacity,
                "x": int(ivar(event, "x", 0)),
                "y": int(ivar(event, "y", 0)),
            })
    return result


def apply_opacity(image: RGBAImage, opacity: int) -> RGBAImage:
    result = RGBAImage(image.width, image.height, bytearray(image.pixels))
    for index in range(3, len(result.pixels), 4):
        result.pixels[index] = (result.pixels[index] * opacity + 127) // 255
    return result


def compose_map(
    source: Path, map_obj: RubyObject, table, tilesets: list[Any], graphics,
) -> tuple[RGBAImage, dict[str, Any]]:
    tileset_id = int(ivar(map_obj, "tileset_id", 0))
    if tileset_id <= 0 or tileset_id >= len(tilesets):
        raise ValueError(f"missing tileset {tileset_id}")
    tileset = tilesets[tileset_id]
    if not isinstance(tileset, RubyObject):
        raise ValueError(f"invalid tileset {tileset_id}")
    descriptor = tileset_descriptor(tileset_id, tileset)
    dependencies = visual_dependencies(tileset, source, graphics, "ARCHIVE_LFS_SOURCE")
    missing = [
        {"kind": row["kind"], "source_name": row["source_name"], "problems": row["problems"]}
        for row in dependencies if not row.get("resolved")
    ]
    renderer = TileRenderer(source, dependencies, descriptor)
    _, transparent = render_layers(row_major_layers(table), renderer)
    canvas = RGBAImage.empty(transparent.width, transparent.height, (0, 0, 0, 255))

    panorama_count = 0
    if descriptor["panorama"]:
        matches = [
            row for row in dependencies
            if row["kind"] == "PANORAMA" and row["source_name"].casefold() == descriptor["panorama"].casefold()
        ]
        if matches:
            panorama = load_png(source / matches[0]["source_path"])
            for y in range(0, canvas.height, panorama.height):
                for x in range(0, canvas.width, panorama.width):
                    canvas.alpha_over(panorama, x, y)
            panorama_count = 1
    canvas.alpha_over(transparent)

    tile_events = environmental_tile_events(map_obj)
    for event in tile_events:
        canvas.alpha_over(
            apply_opacity(renderer.tile(event["tile_id"]), event["opacity"]),
            event["x"] * TILE_SIZE,
            event["y"] * TILE_SIZE,
        )
    return canvas, {
        "tileset_id": tileset_id,
        "tileset_name": descriptor["name"],
        "panorama_count": panorama_count,
        "environmental_tile_event_count": len(tile_events),
        "fog_name": descriptor["fog"],
        "missing_tile_ids": sorted(renderer.missing_ids),
        "unresolved_visual_dependencies": missing,
    }


def contact_outputs(output: Path, records: list[dict[str, Any]]) -> tuple[dict[str, Any], list[dict[str, Any]]]:
    thumbs = []
    for row in records:
        image = load_png(output / row["file"])
        thumb = thumbnail(image, 224, 168)
        draw_label(thumb, f"{row['map_id']:03d}", 4, 4)
        thumbs.append(thumb)

    columns = 5
    rows = (len(thumbs) + columns - 1) // columns
    contact = RGBAImage.empty(columns * 224, rows * 168, (8, 8, 12, 255))
    for index, thumb in enumerate(thumbs):
        contact.alpha_over(thumb, (index % columns) * 224, (index // columns) * 168)
    contact_path = output / "contact_sheet.png"
    save_png(contact, contact_path)
    contact_record = {
        "file": contact_path.relative_to(output).as_posix(),
        "sha256": sha256_file(contact_path),
        "width_px": contact.width,
        "height_px": contact.height,
        "columns": columns,
    }

    page_records = []
    page_size = 50
    pages_root = output / "contact_pages"
    if pages_root.exists():
        shutil.rmtree(pages_root)
    pages_root.mkdir(parents=True)
    for start in range(0, len(thumbs), page_size):
        batch = thumbs[start : start + page_size]
        page = RGBAImage.empty(columns * 224, 10 * 168, (8, 8, 12, 255))
        for index, thumb in enumerate(batch):
            page.alpha_over(thumb, (index % columns) * 224, (index // columns) * 168)
        first_id = records[start]["map_id"]
        last_id = records[start + len(batch) - 1]["map_id"]
        path = pages_root / f"page_{start // page_size + 1:02d}_maps_{first_id:03d}_{last_id:03d}.png"
        save_png(page, path)
        page_records.append({
            "file": path.relative_to(output).as_posix(),
            "sha256": sha256_file(path),
            "first_map_id": first_id,
            "last_map_id": last_id,
            "render_count": len(batch),
            "width_px": page.width,
            "height_px": page.height,
        })
    return contact_record, page_records


def build(archive: Path, game_id: str, output: Path, extracted: Path | None = None) -> dict[str, Any]:
    archive = archive.resolve()
    output = output.resolve()
    if sha256_file(archive) == sha256_file(Path(__file__)):
        raise ValueError("archive sanity check failed")
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)

    temporary = None
    if extracted is None:
        temporary = tempfile.TemporaryDirectory(prefix=f"bibliotheque-{game_id}-")
        extraction_root = Path(temporary.name)
        safe_extract(archive, extraction_root)
        source = discover_project(extraction_root)
    else:
        source = extracted.resolve()
    try:
        map_infos = load(source / "Data/MapInfos.rxdata")
        tilesets = load(source / "Data/Tilesets.rxdata")
        if not isinstance(map_infos, dict) or not isinstance(tilesets, list):
            raise ValueError("unexpected RMXP indexes")
        maps = {}
        for path in sorted((source / "Data").glob("Map[0-9][0-9][0-9].rxdata")):
            maps[int(path.stem[3:])] = path
        if set(maps) != {int(key) for key in map_infos}:
            raise ValueError("MapInfos and Map files differ")
        graphics = graphics_index(source)
        records = []
        maps_root = output / "maps"
        maps_root.mkdir()
        exclusions = DEFAULT_EXCLUDED_MAPS[game_id]
        for order, (map_id, path) in enumerate(sorted(maps.items()), 1):
            map_obj, table = parse_map(path)
            exclusion_reason = exclusions.get(map_id)
            if exclusion_reason:
                image = excluded_placeholder(table.x_size * TILE_SIZE, table.y_size * TILE_SIZE)
                extras = {
                    "tileset_id": int(ivar(map_obj, "tileset_id", 0)),
                    "tileset_name": "REDACTED",
                    "panorama_count": 0,
                    "environmental_tile_event_count": 0,
                    "fog_name": "",
                    "missing_tile_ids": [],
                    "unresolved_visual_dependencies": [],
                }
            else:
                image, extras = compose_map(source, map_obj, table, tilesets, graphics)
            output_path = maps_root / f"map_{map_id:03d}.png"
            save_png(image, output_path)
            info = map_infos[map_id]
            name = decode_text(ivar(info, "name", f"Map {map_id:03d}"))
            record = {
                "map_id": map_id,
                "source_order": order,
                "source_name": name,
                "file": output_path.relative_to(output).as_posix(),
                "sha256": sha256_file(output_path),
                "width_tiles": table.x_size,
                "height_tiles": table.y_size,
                "width_px": image.width,
                "height_px": image.height,
                "layer_count": table.z_size,
                "actor_pixels_exported": False,
                "source_pixels_exported": not bool(exclusion_reason),
                "excluded_visual_scene": exclusion_reason,
                "pmdo_target_tex_size": 4,
                "pmdo_target_pitch_px": 32,
                **extras,
            }
            records.append(record)

        contact_record, contact_pages = contact_outputs(output, records)
        missing_maps = [
            {
                "map_id": row["map_id"],
                "missing_tile_ids": row["missing_tile_ids"],
                "unresolved_visual_dependencies": row["unresolved_visual_dependencies"],
            }
            for row in records
            if row["missing_tile_ids"] or row["unresolved_visual_dependencies"]
        ]
        manifest = {
            "schema_version": "1.0.0",
            "result": (
                "RMXP_ARCHIVE_PMDO_RENDER_PASS"
                if not missing_maps else "RMXP_ARCHIVE_PMDO_RENDER_REVIEW_REQUIRED"
            ),
            "status": "SOURCE_EXTRACTED" if not missing_maps else "ADAPTATION_REQUIRED",
            "game_id": game_id,
            "source": {
                "archive_name": archive.name,
                "archive_sha256": sha256_file(archive),
                "archive_size_bytes": archive.stat().st_size,
                "source_code_executed": False,
                "actor_pixels_exported": False,
            },
            "map_count": len(records),
            "complete_environmental_render_count": len(records) - len(missing_maps) - len(exclusions),
            "excluded_visual_scene_count": len(exclusions),
            "excluded_visual_scenes": [
                {"map_id": map_id, "reason": reason, "source_pixels_exported": False}
                for map_id, reason in sorted(exclusions.items())
            ],
            "missing_tile_map_count": len(missing_maps),
            "missing_tiles": missing_maps,
            "contact_sheet": contact_record,
            "contact_pages": contact_pages,
            "renders": records,
        }
        write_json(output / "manifest.json", manifest)
        return manifest
    finally:
        if temporary is not None:
            temporary.cleanup()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--archive", type=Path, required=True)
    parser.add_argument("--game-id", choices=("reminiscencia", "nova"), required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--extracted", type=Path)
    args = parser.parse_args()
    result = build(args.archive, args.game_id, args.output, args.extracted)
    print(json.dumps({
        "result": result["result"],
        "game_id": result["game_id"],
        "map_count": result["map_count"],
        "contact_sheet_sha256": result["contact_sheet"]["sha256"],
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
