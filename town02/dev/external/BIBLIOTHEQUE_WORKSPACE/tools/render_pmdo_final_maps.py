#!/usr/bin/env python3
"""Render one final assembled PMDO-target PNG for every qualified Relict Map.

The render is an environmental overview, not a story screenshot: it assembles
panorama, all three map layers, visible environmental tile-events, and the peak
representative state of qualified screen/fog VFX. Source/New Era actors stay
absent. Divergent source variants receive their own PNG.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
from pathlib import Path
from typing import Any

from inventory_relict import DEFAULT_OUTPUT, DEFAULT_SOURCE, sha256_file, write_json
from png_rgba import RGBAImage, load_png, save_png
from render_relict_previews import TileRenderer

DEFAULT_TARGET = DEFAULT_OUTPUT / "conversion/pmdo_renders"
TILE_SIZE = 32

DIGITS = {
    "0": ("111", "101", "101", "101", "111"),
    "1": ("010", "110", "010", "010", "111"),
    "2": ("111", "001", "111", "100", "111"),
    "3": ("111", "001", "111", "001", "111"),
    "4": ("101", "101", "111", "001", "001"),
    "5": ("111", "100", "111", "001", "111"),
    "6": ("111", "100", "111", "101", "111"),
    "7": ("111", "001", "010", "010", "010"),
    "8": ("111", "101", "111", "101", "111"),
    "9": ("111", "101", "111", "001", "111"),
    "A": ("010", "101", "111", "101", "101"),
    "B": ("110", "101", "110", "101", "110"),
}


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def copy_image(image: RGBAImage) -> RGBAImage:
    return RGBAImage(image.width, image.height, bytearray(image.pixels))


def with_opacity(image: RGBAImage, opacity: int) -> RGBAImage:
    result = copy_image(image)
    opacity = max(0, min(255, opacity))
    for index in range(3, len(result.pixels), 4):
        result.pixels[index] = (result.pixels[index] * opacity + 127) // 255
    return result


def scale_nearest(image: RGBAImage, width: int, height: int) -> RGBAImage:
    result = RGBAImage.empty(width, height)
    for y in range(height):
        sy = min(image.height - 1, y * image.height // height)
        for x in range(width):
            sx = min(image.width - 1, x * image.width // width)
            src = (sy * image.width + sx) * 4
            dst = (y * width + x) * 4
            result.pixels[dst : dst + 4] = image.pixels[src : src + 4]
    return result


def additive_over(target: RGBAImage, source: RGBAImage, x: int, y: int) -> None:
    for sy in range(source.height):
        dy = y + sy
        if dy < 0 or dy >= target.height:
            continue
        for sx in range(source.width):
            dx = x + sx
            if dx < 0 or dx >= target.width:
                continue
            src = (sy * source.width + sx) * 4
            alpha = source.pixels[src + 3]
            if not alpha:
                continue
            dst = (dy * target.width + dx) * 4
            for channel in range(3):
                addition = (source.pixels[src + channel] * alpha + 127) // 255
                target.pixels[dst + channel] = min(255, target.pixels[dst + channel] + addition)
            target.pixels[dst + 3] = max(target.pixels[dst + 3], alpha)


def repeat_effect(
    target: RGBAImage, source: RGBAImage, opacity: int = 255,
    blend: int = 0, zoom_percent: int = 100,
) -> None:
    width = max(1, source.width * zoom_percent // 100)
    height = max(1, source.height * zoom_percent // 100)
    effect = scale_nearest(source, width, height) if (width, height) != (source.width, source.height) else source
    effect = with_opacity(effect, opacity)
    for y in range(0, target.height, effect.height):
        for x in range(0, target.width, effect.width):
            if blend == 1:
                additive_over(target, effect, x, y)
            else:
                target.alpha_over(effect, x, y)


def first_asset_frame(game_root: Path, asset: dict[str, Any]) -> Path:
    output = game_root / asset["output"]
    if output.suffix.lower() == ".png":
        return output
    metadata = load_json(output)
    return output.parent / metadata["layers"][0]["frames"][0]["file"]


def matching_commands(
    timeline: dict[str, Any], context: dict[str, Any], source_index: int,
) -> tuple[list[dict[str, Any]], int]:
    for sequence in timeline["sequences"]:
        if (
            sequence.get("source_event_id") == context.get("event_id")
            and sequence.get("page_index") == context.get("page_index")
        ):
            commands = sequence["timeline"]
            for position, command in enumerate(commands):
                if command["source_index"] == source_index:
                    return commands, position
    return [], -1


def picture_peak(
    timeline: dict[str, Any], context: dict[str, Any], source_index: int,
) -> tuple[int, int]:
    commands, position = matching_commands(timeline, context, source_index)
    if position < 0:
        return 255, 0
    show = commands[position]["parameters"]["numeric_and_safe_parameters"]
    picture_id = show[0]
    opacity = show[7]
    blend = show[8]
    for command in commands[position + 1 :]:
        if command["category"] == "picture_erase" and command["parameters"][0] == picture_id:
            break
        if command["category"] == "picture_move":
            values = command["parameters"]
            if values[0] == picture_id:
                opacity = max(opacity, values[8])
                blend = values[9]
    return opacity, blend


def effect_settings(
    asset: dict[str, Any], timeline: dict[str, Any], map_id: int,
) -> tuple[int, int, int, int]:
    contexts = [row for row in asset["contexts"] if row.get("map_id") == map_id]
    if not contexts:
        return 255, 0, 100, 1 << 30
    context = min(contexts, key=lambda row: row["source_index"])
    source_index = context["source_index"]
    if asset["kind"] == "ENVIRONMENT_OVERLAY":
        opacity, blend = picture_peak(timeline, context, source_index)
        return opacity, blend, 100, source_index
    if asset["kind"] == "FOG":
        commands, position = matching_commands(timeline, context, source_index)
        if position >= 0:
            values = commands[position]["parameters"]["values"]
            return values[1], values[2], values[3], source_index
        return 60, 0, 200, source_index
    return 255, 0, 100, source_index


def label_for_preview(preview_id: str) -> str:
    match = re.search(r"map_(\d{3})", preview_id)
    label = match.group(1) if match else "000"
    if "variant" in preview_id:
        label += "A" if "2025" in preview_id else "B"
    return label


def draw_label(image: RGBAImage, text: str, x: int, y: int) -> None:
    scale = 2
    width = len(text) * 8 + 4
    image.fill_rect(x, y, width, 14, (0, 0, 0, 220))
    cursor = x + 3
    for character in text:
        for py, row in enumerate(DIGITS[character]):
            for px, value in enumerate(row):
                if value == "1":
                    image.fill_rect(cursor + px * scale, y + 2 + py * scale, scale, scale, (255, 255, 255, 255))
        cursor += 8


def thumbnail(image: RGBAImage, width: int, height: int) -> RGBAImage:
    scale = min(width / image.width, height / image.height)
    out_width = max(1, int(image.width * scale))
    out_height = max(1, int(image.height * scale))
    resized = scale_nearest(image, out_width, out_height)
    result = RGBAImage.empty(width, height, (18, 18, 24, 255))
    result.alpha_over(resized, (width - out_width) // 2, (height - out_height) // 2)
    return result


def build(source: Path, game_root: Path, target: Path) -> dict[str, Any]:
    source = source.resolve()
    game_root = game_root.resolve()
    target = target.resolve()
    if target.exists():
        shutil.rmtree(target)
    maps_root = target / "maps"
    maps_root.mkdir(parents=True)

    preview_manifest = load_json(game_root / "previews/manifest.json")
    vfx_manifest = load_json(game_root / "vfx/manifest.json")
    outputs = []
    thumbs = []
    for preview in preview_manifest["previews"]:
        preview_id = preview["preview_id"]
        map_id = int(preview["zone_id"].rsplit("_", 1)[1])
        zone = load_json(game_root / f"metadata/zones/map_{map_id:03d}.json")
        timeline = load_json(game_root / f"vfx/timelines/maps/map_{map_id:03d}.json")
        layer_paths = [
            game_root / row["file"] for row in preview["files"]
            if re.search(r"/layer_\d\d\.png$", row["file"])
        ]
        layers = [load_png(path) for path in layer_paths]
        width, height = layers[0].width, layers[0].height
        canvas = RGBAImage.empty(width, height, (0, 0, 0, 255))

        assets = [
            asset for asset in vfx_manifest["environment_assets"]
            if any(context.get("map_id") == map_id for context in asset["contexts"])
        ]
        panoramas = [asset for asset in assets if asset["kind"] == "PANORAMA"]
        for asset in panoramas:
            repeat_effect(canvas, load_png(first_asset_frame(game_root, asset)))
        for layer in layers:
            canvas.alpha_over(layer)

        entities = load_json(game_root / f"zones/entities/map_{map_id:03d}_entities.json")
        visible_environment_entities = [
            row for row in entities["placements"]
            if row["classification"] == "ENVIRONMENTAL_TILE_ENTITY"
            and row["graphic"]["tile_id"]
            and row["graphic"]["opacity"]
        ]
        if visible_environment_entities:
            renderer = TileRenderer(source, zone["visual_dependencies"], zone["tileset"])
            for entity in visible_environment_entities:
                graphic = entity["graphic"]
                image = with_opacity(renderer.tile(graphic["tile_id"]), graphic["opacity"])
                position = entity["position"]
                if graphic["blend_type"] == 1:
                    additive_over(canvas, image, position["x"] * TILE_SIZE, position["y"] * TILE_SIZE)
                else:
                    canvas.alpha_over(image, position["x"] * TILE_SIZE, position["y"] * TILE_SIZE)
            if renderer.missing_ids:
                raise ValueError(f"{preview_id}: missing environmental tile IDs {renderer.missing_ids}")

        screen_effects = []
        for asset in assets:
            if asset["kind"] == "PANORAMA":
                continue
            opacity, blend, zoom, order = effect_settings(asset, timeline, map_id)
            screen_effects.append((order, asset, opacity, blend, zoom))
        screen_effects.sort(key=lambda row: (row[0], row[1]["asset_id"]))
        for _, asset, opacity, blend, zoom in screen_effects:
            repeat_effect(
                canvas, load_png(first_asset_frame(game_root, asset)),
                opacity=opacity, blend=blend, zoom_percent=zoom,
            )

        output_path = maps_root / f"{preview_id}.png"
        save_png(canvas, output_path)
        record = {
            "preview_id": preview_id,
            "map_id": map_id,
            "variant": preview["variant"],
            "file": output_path.relative_to(target).as_posix(),
            "sha256": sha256_file(output_path),
            "width_px": width,
            "height_px": height,
            "source_layer_count": len(layers),
            "panorama_count": len(panoramas),
            "screen_vfx_count": len(screen_effects),
            "visible_environmental_tile_entity_count": len(visible_environment_entities),
            "actor_pixels_exported": False,
            "pmdo_target_pitch_px": TILE_SIZE,
            "pmdo_target_tex_size": 4,
        }
        outputs.append(record)
        thumb = thumbnail(canvas, 224, 168)
        draw_label(thumb, label_for_preview(preview_id), 4, 4)
        thumbs.append(thumb)

    columns = 5
    rows = (len(thumbs) + columns - 1) // columns
    contact = RGBAImage.empty(columns * 224, rows * 168, (8, 8, 12, 255))
    for index, thumb in enumerate(thumbs):
        contact.alpha_over(thumb, (index % columns) * 224, (index // columns) * 168)
    contact_path = target / "contact_sheet.png"
    save_png(contact, contact_path)
    manifest = {
        "schema_version": "1.0.0",
        "result": "PMDO_FINAL_RENDER_PASS",
        "render_count": len(outputs),
        "canonical_map_count": sum(row["variant"] is None for row in outputs),
        "divergent_variant_count": sum(row["variant"] is not None for row in outputs),
        "policy": {
            "composition": [
                "panorama", "three source map layers", "visible environmental tile entities",
                "qualified screen overlays and fog at representative peak state",
            ],
            "screen_vfx_overview": "camera-space frames repeated over the full-map overview",
            "actors": "excluded; positions remain in entity sidecars",
            "target": "PMDO Ground TexSize 4 / 32 px graphical pitch",
        },
        "contact_sheet": {
            "file": contact_path.relative_to(target).as_posix(),
            "sha256": sha256_file(contact_path),
            "width_px": contact.width,
            "height_px": contact.height,
            "columns": columns,
            "label_policy": "three-digit map ID; A=2025 divergent variant, B=2026 divergent variant",
        },
        "renders": outputs,
    }
    write_json(target / "manifest.json", manifest)
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--game-root", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--output", type=Path, default=DEFAULT_TARGET)
    args = parser.parse_args()
    result = build(args.source, args.game_root, args.output)
    print(json.dumps({
        "result": result["result"],
        "render_count": result["render_count"],
        "contact_sheet_sha256": result["contact_sheet"]["sha256"],
        "output": str(args.output),
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
