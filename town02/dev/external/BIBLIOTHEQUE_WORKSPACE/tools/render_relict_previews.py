#!/usr/bin/env python3
"""Render deterministic Relict map, layer, collision, and placeholder previews."""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from pathlib import Path
from typing import Any

from inventory_relict import DEFAULT_OUTPUT, DEFAULT_SOURCE, sha256_file, slug, write_json
from png_rgba import RGBAImage, load_png, save_png

TILE_SIZE = 32
AUTOTILE_PARTS = (
    (27, 28, 33, 34), (5, 28, 33, 34), (27, 6, 33, 34), (5, 6, 33, 34),
    (27, 28, 33, 12), (5, 28, 33, 12), (27, 6, 33, 12), (5, 6, 33, 12),
    (27, 28, 11, 34), (5, 28, 11, 34), (27, 6, 11, 34), (5, 6, 11, 34),
    (27, 28, 11, 12), (5, 28, 11, 12), (27, 6, 11, 12), (5, 6, 11, 12),
    (25, 26, 31, 32), (25, 6, 31, 32), (25, 26, 31, 12), (25, 6, 31, 12),
    (15, 16, 21, 22), (15, 16, 21, 12), (15, 16, 11, 22), (15, 16, 11, 12),
    (29, 30, 35, 36), (29, 30, 11, 36), (5, 30, 35, 36), (5, 30, 11, 36),
    (39, 40, 45, 46), (5, 40, 45, 46), (39, 6, 45, 46), (5, 6, 45, 46),
    (25, 30, 31, 36), (15, 16, 45, 46), (13, 14, 19, 20), (13, 14, 19, 12),
    (17, 18, 23, 24), (17, 18, 11, 24), (41, 42, 47, 48), (5, 42, 47, 48),
    (37, 38, 43, 44), (37, 6, 43, 44), (13, 18, 19, 24), (13, 14, 43, 44),
    (37, 42, 43, 48), (17, 18, 47, 48), (13, 18, 43, 48), (1, 2, 7, 8),
)


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def png_record(path: Path, root: Path) -> dict[str, Any]:
    image = load_png(path)
    return {
        "file": path.relative_to(root).as_posix(),
        "sha256": sha256_file(path),
        "width_px": image.width,
        "height_px": image.height,
    }


class TileRenderer:
    def __init__(self, source: Path, dependencies: list[dict[str, Any]], tileset: dict[str, Any]):
        self.source = source
        self.tileset_descriptor = tileset
        self.by_key = {
            (row["kind"], row["source_name"].casefold()): row
            for row in dependencies if row.get("resolved")
        }
        self.source_images: dict[Path, RGBAImage] = {}
        self.tile_cache: dict[int, RGBAImage] = {}
        self.autotile_cache: dict[tuple[int, int], RGBAImage] = {}
        self.missing_ids: set[int] = set()
        self.tileset_image = self._load_dependency("TILESET", tileset["name"])
        self.autotiles = [
            self._load_dependency("AUTOTILE", row["name"]) if row["name"] else None
            for row in tileset["autotile_slots"]
        ]

    def _load_dependency(self, kind: str, name: str) -> RGBAImage | None:
        row = self.by_key.get((kind, name.casefold()))
        if not row:
            return None
        path = self.source / row["source_path"]
        if path not in self.source_images:
            self.source_images[path] = load_png(path)
        return self.source_images[path]

    @staticmethod
    def animation_frame_count(image: RGBAImage | None) -> int:
        if image is None:
            return 0
        if image.height == 128:
            frame_count, remainder = divmod(image.width, 96)
            if frame_count and remainder == 0:
                return frame_count
            # Some Essentials projects append transparent alignment columns to
            # an otherwise standard 96×128 RMXP animation strip. Accept only
            # demonstrably empty right padding; never crop visible pixels.
            if frame_count and all(
                image.pixels[(y * image.width + x) * 4 + 3] == 0
                for y in range(image.height)
                for x in range(frame_count * 96, image.width)
            ):
                return frame_count
        if image.height == 32 and image.width % 32 == 0:
            return image.width // 32
        return 0

    def _missing(self, tile_id: int) -> RGBAImage:
        self.missing_ids.add(tile_id)
        image = RGBAImage.empty(32, 32, (255, 0, 255, 180))
        image.outline_rect(0, 0, 32, 32, (0, 0, 0, 255), 2)
        return image

    def tile(self, tile_id: int, frame: int = 0) -> RGBAImage:
        if tile_id == 0:
            return RGBAImage.empty(32, 32)
        if tile_id >= 384:
            if tile_id in self.tile_cache:
                return self.tile_cache[tile_id]
            if self.tileset_image is None:
                return self._missing(tile_id)
            index = tile_id - 384
            x = (index % 8) * 32
            y = (index // 8) * 32
            if x + 32 > self.tileset_image.width or y + 32 > self.tileset_image.height:
                return self._missing(tile_id)
            image = self.tileset_image.crop(x, y, 32, 32)
            self.tile_cache[tile_id] = image
            return image
        slot = tile_id // 48 - 1
        pattern = tile_id % 48
        if slot < 0 or slot >= len(self.autotiles) or self.autotiles[slot] is None:
            return self._missing(tile_id)
        image = self.autotiles[slot]
        frame_count = self.animation_frame_count(image)
        if frame_count == 0:
            return self._missing(tile_id)
        frame %= frame_count
        cache_key = (tile_id, frame)
        if cache_key in self.autotile_cache:
            return self.autotile_cache[cache_key]
        if image.height == 32:
            result = image.crop(frame * 32, 0, 32, 32)
        else:
            frame_image = image.crop(frame * 96, 0, 96, 128)
            result = RGBAImage.empty(32, 32)
            for quadrant, part in enumerate(AUTOTILE_PARTS[pattern]):
                part_index = part - 1
                quarter = frame_image.crop((part_index % 6) * 16, (part_index // 6) * 16, 16, 16)
                result.blit_replace(quarter, (quadrant % 2) * 16, (quadrant // 2) * 16)
        self.autotile_cache[cache_key] = result
        return result

    def reference_sheet(self) -> RGBAImage:
        rows = []
        if self.tileset_image is not None:
            rows.append(self.tileset_image)
        for image in self.autotiles:
            if image is None:
                continue
            frames = self.animation_frame_count(image)
            if not frames:
                continue
            width = min(image.width, 96 if image.height == 128 else 32)
            rows.append(image.crop(0, 0, width, image.height))
        width = max((row.width for row in rows), default=32)
        height = sum(row.height for row in rows) or 32
        result = RGBAImage.empty(width, height, (32, 32, 32, 255))
        y = 0
        for row in rows:
            result.alpha_over(row, 0, y)
            y += row.height
        return result


def resize_nearest(image: RGBAImage, width: int, height: int) -> RGBAImage:
    result = RGBAImage.empty(width, height)
    for y in range(height):
        source_y = min(image.height - 1, y * image.height // height)
        for x in range(width):
            source_x = min(image.width - 1, x * image.width // width)
            source_index = (source_y * image.width + source_x) * 4
            target_index = (y * width + x) * 4
            result.pixels[target_index : target_index + 4] = image.pixels[source_index : source_index + 4]
    return result


def render_layers(layer_payload: dict[str, Any], renderer: TileRenderer) -> tuple[list[RGBAImage], RGBAImage]:
    width = layer_payload["width"]
    height = layer_payload["height"]
    images = []
    composite = RGBAImage.empty(width * TILE_SIZE, height * TILE_SIZE)
    for layer in layer_payload["layers"]:
        image = RGBAImage.empty(width * TILE_SIZE, height * TILE_SIZE)
        for y, row in enumerate(layer["rows"]):
            for x, tile_id in enumerate(row):
                if tile_id:
                    image.blit_replace(renderer.tile(tile_id), x * TILE_SIZE, y * TILE_SIZE)
        composite.alpha_over(image)
        images.append(image)
    return images, composite


def collision_preview(collision: dict[str, Any]) -> RGBAImage:
    masks = collision["allowed_direction_masks"]
    height = len(masks)
    width = len(masks[0]) if height else 0
    image = RGBAImage.empty(width * TILE_SIZE, height * TILE_SIZE, (0, 0, 0, 255))
    for y, row in enumerate(masks):
        for x, mask in enumerate(row):
            if mask == 15:
                color = (38, 170, 70, 190)
            elif mask == 0:
                color = (215, 45, 45, 220)
            else:
                color = (235, 155, 35, 210)
            image.fill_rect(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE, color)
            image.outline_rect(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE, (0, 0, 0, 80), 1)
    return image


def placeholder_preview(composite: RGBAImage, entities: dict[str, Any]) -> RGBAImage:
    result = RGBAImage(composite.width, composite.height, bytearray(composite.pixels))
    first_pages = {}
    for placement in entities["placements"]:
        first_pages.setdefault(placement["source_event_id"], placement)
    for placement in first_pages.values():
        x = placement["position"]["x"] * TILE_SIZE
        y = placement["position"]["y"] * TILE_SIZE
        kind = placement["classification"]
        if kind == "CAST_PLACEHOLDER":
            color = (220, 50, 220, 255)
            result.fill_rect(x + 7, y + 3, 18, 26, (220, 50, 220, 125))
            result.outline_rect(x + 7, y + 3, 18, 26, color, 2)
        elif kind == "ENVIRONMENTAL_TILE_ENTITY":
            result.outline_rect(x + 2, y + 2, 28, 28, (40, 220, 235, 255), 3)
        else:
            result.fill_rect(x + 11, y + 11, 10, 10, (245, 220, 30, 230))
            result.outline_rect(x + 9, y + 9, 14, 14, (20, 20, 20, 255), 2)
    return result


def job_rows(inventory_root: Path) -> list[dict[str, Any]]:
    jobs = []
    for zone_path in sorted((inventory_root / "metadata/zones").glob("*.json")):
        zone = load_json(zone_path)
        jobs.append({
            "preview_id": f"map_{zone['source_map_id']:03d}",
            "zone_id": zone["zone_id"],
            "variant": None,
            "geometry_file": zone["tile_layers"]["file"],
            "collision_file": zone["collision"]["derived_directional_grid"]["file"],
            "entities_file": zone["entities"]["file"],
            "tileset": zone["tileset"],
            "dependencies": zone["visual_dependencies"],
        })
        for variant in zone["variants"]:
            if variant["byte_identical_to_canonical"]:
                continue
            artifacts = variant["derived_artifacts"]
            jobs.append({
                "preview_id": Path(artifacts["tile_layers"]).stem.removesuffix("_layers"),
                "zone_id": zone["zone_id"],
                "variant": variant["source_label"],
                "geometry_file": artifacts["tile_layers"],
                "collision_file": artifacts["directional_collision"],
                "entities_file": artifacts["entity_placements"],
                "tileset": variant["tileset"],
                "dependencies": variant["visual_dependencies"],
            })
    return jobs


def build(source: Path, inventory_root: Path) -> dict[str, Any]:
    source = source.resolve()
    inventory_root = inventory_root.resolve()
    preview_root = inventory_root / "previews"
    if preview_root.exists():
        shutil.rmtree(preview_root)
    preview_root.mkdir(parents=True)
    jobs = job_rows(inventory_root)
    outputs = []
    tileset_sheets = {}
    missing_ids = set()
    for job in jobs:
        renderer = TileRenderer(source, job["dependencies"], job["tileset"])
        layers_payload = load_json(inventory_root / job["geometry_file"])
        collision_payload = load_json(inventory_root / job["collision_file"])
        entities_payload = load_json(inventory_root / job["entities_file"])
        layers, composite = render_layers(layers_payload, renderer)
        destination = preview_root / "maps" / job["preview_id"]
        records = []
        for index, image in enumerate(layers):
            path = destination / f"layer_{index:02d}.png"
            save_png(image, path)
            records.append(png_record(path, inventory_root))
        composite_path = destination / "composite.png"
        save_png(composite, composite_path)
        records.append(png_record(composite_path, inventory_root))
        collision_path = destination / "collision.png"
        save_png(collision_preview(collision_payload), collision_path)
        records.append(png_record(collision_path, inventory_root))
        entities_path = destination / "entities_placeholders.png"
        save_png(placeholder_preview(composite, entities_payload), entities_path)
        records.append(png_record(entities_path, inventory_root))
        missing_ids.update(renderer.missing_ids)
        outputs.append({
            "preview_id": job["preview_id"],
            "zone_id": job["zone_id"],
            "variant": job["variant"],
            "files": records,
            "missing_tile_ids": sorted(renderer.missing_ids),
            "entity_placeholder_count": len({
                row["source_event_id"] for row in entities_payload["placements"]
            }),
        })
        tileset_id = job["tileset"]["source_id"]
        sheet_key = f"tileset_{tileset_id:03d}"
        if sheet_key not in tileset_sheets:
            path = preview_root / "tilesets" / f"{sheet_key}_reference.png"
            save_png(renderer.reference_sheet(), path)
            tileset_sheets[sheet_key] = png_record(path, inventory_root)
    contact_columns = 5
    thumb_width, thumb_height = 160, 120
    contact_rows = (len(outputs) + contact_columns - 1) // contact_columns
    contact = RGBAImage.empty(
        contact_columns * thumb_width, contact_rows * thumb_height, (28, 28, 28, 255)
    )
    contact_order = []
    for index, row in enumerate(outputs):
        composite_record = next(
            record for record in row["files"] if Path(record["file"]).name == "composite.png"
        )
        image = load_png(inventory_root / composite_record["file"])
        contact.alpha_over(
            resize_nearest(image, thumb_width, thumb_height),
            (index % contact_columns) * thumb_width,
            (index // contact_columns) * thumb_height,
        )
        contact_order.append(row["preview_id"])
    contact_path = preview_root / "maps_contact_sheet.png"
    save_png(contact, contact_path)
    contact_record = png_record(contact_path, inventory_root)

    result = {
        "schema_version": "1.0.0",
        "result": "PREVIEW_RENDER_PASS" if not missing_ids else "PREVIEW_RENDER_MISSING_TILES",
        "map_preview_count": len(outputs),
        "canonical_preview_count": sum(row["variant"] is None for row in outputs),
        "divergent_variant_preview_count": sum(row["variant"] is not None for row in outputs),
        "tileset_reference_count": len(tileset_sheets),
        "missing_tile_ids": sorted(missing_ids),
        "placeholder_policy": {
            "CAST_PLACEHOLDER": "magenta box",
            "ENVIRONMENTAL_TILE_ENTITY": "cyan outline",
            "LOGIC_MARKER": "yellow marker",
        },
        "map_contact_sheet": contact_record,
        "map_contact_sheet_order": contact_order,
        "previews": outputs,
        "tileset_references": tileset_sheets,
    }
    write_json(preview_root / "manifest.json", result)
    (preview_root / "README.md").write_text(
        "# Prévisualisations Relict\n\n"
        "Chaque Map possède ses couches séparées, un composite, un masque de collision "
        "et une vue où les entités sont remplacées par des placeholders neutres. "
        "Les variantes byte-identiques réutilisent la preview canonique ; les variantes "
        "divergentes ont leur propre rendu.\n",
        encoding="utf-8",
    )
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--inventory-root", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    result = build(args.source, args.inventory_root)
    print(json.dumps({key: value for key, value in result.items() if key != "previews"}, sort_keys=True))
    return 0 if not result["missing_tile_ids"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
