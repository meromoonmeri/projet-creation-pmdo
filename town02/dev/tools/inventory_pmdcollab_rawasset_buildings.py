#!/usr/bin/env python3
"""Inventory complete buildings in PMDCollab/RawAsset without map crops."""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import shutil
from pathlib import Path

from PIL import Image, ImageDraw

SOURCE_REPOSITORY = "https://github.com/PMDCollab/RawAsset"
SOURCE_COMMIT = "03c80dad937911572f8fb19903771a47956fc696"
QUALIFIED = {"House_Normal.None.png", "Tent.Flip.png", "Tent_Plain.Flip.png"}
NAMED_EXCLUSIONS = {
    "Block_Guild.None.png": "24x24 logical marker, not a guild building",
    "Storage.Flip.png": "32x32 storage container, not a building",
    "Tile_Shop.None.png": "24x24 gameplay floor marker, not a physical merchant stand",
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def image_row(path: Path, root: Path) -> dict:
    with Image.open(path) as image:
        return {
            "path": str(path.relative_to(root)),
            "bytes": path.stat().st_size,
            "sha256": digest(path),
            "dimensions": [image.width, image.height],
            "mode": image.mode,
        }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rawasset", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    args = parser.parse_args()
    source = args.rawasset.resolve()
    out = args.out.resolve()
    payload_dir = out / "qualified"
    payload_dir.mkdir(parents=True, exist_ok=True)

    object_rows = []
    qualified_rows = []
    for path in sorted((source / "Object").glob("*.png")):
        row = image_row(path, source)
        row["qualified_complete_building"] = path.name in QUALIFIED
        row["status"] = "QUALIFIED_SOURCE_BUILDING" if path.name in QUALIFIED else "NOT_A_QUALIFIED_BUILDING"
        if path.name in NAMED_EXCLUSIONS:
            row["exclusion_reason"] = NAMED_EXCLUSIONS[path.name]
        object_rows.append(row)
        if path.name in QUALIFIED:
            target = payload_dir / path.name
            shutil.copyfile(path, target)
            copied = dict(row)
            copied["payload"] = str(target.relative_to(out))
            copied["payload_sha256"] = digest(target)
            copied["extraction"] = "WHOLE_SOURCE_PNG_BYTE_EXACT"
            copied["pmdo_conversion"] = "NOT_RUN"
            copied["runtime_validation"] = "NOT_RUN"
            copied["placement_allowed"] = False
            qualified_rows.append(copied)

    map_sheets = []
    for path in sorted((source / "Tile").rglob("*.png")):
        row = image_row(path, source)
        row["status"] = "EXCLUDED_MAP_OR_TILESET_SHEET"
        row["placement_allowed"] = False
        map_sheets.append(row)

    card_width, card_height = 280, 230
    render = Image.new("RGBA", (card_width * len(qualified_rows), card_height), (22, 25, 31, 255))
    draw = ImageDraw.Draw(render)
    for index, row in enumerate(qualified_rows):
        x = index * card_width
        draw.rectangle((x + 5, 5, x + card_width - 5, card_height - 5), fill=(34, 39, 48, 255), outline=(80, 90, 106, 255))
        image = Image.open(source / row["path"]).convert("RGBA")
        scale = min(160 / image.width, 150 / image.height, 1.5)
        preview = image.resize((round(image.width * scale), round(image.height * scale)), Image.Resampling.NEAREST)
        px = x + (card_width - preview.width) // 2
        render.alpha_composite(preview, (px, 20))
        draw.text((x + 12, 178), Path(row["path"]).name, fill=(245, 245, 245, 255))
        draw.text((x + 12, 198), f"{row['dimensions'][0]}x{row['dimensions'][1]}  {row['sha256'][:16]}", fill=(170, 190, 210, 255))
    render_path = out / "buildings.png"
    render.save(render_path, optimize=True)

    manifest = {
        "schema": 1,
        "source": {
            "repository": SOURCE_REPOSITORY,
            "commit": SOURCE_COMMIT,
            "license_status": "NO_TOP_LEVEL_LICENSE_FOUND",
            "provenance_status": "UPSTREAM_ATTRIBUTION_REVIEW_REQUIRED_BEFORE_PROMOTION",
        },
        "rules": {
            "map_crops_allowed": False,
            "tileset_fragments_allowed": False,
            "resizing_source_payloads_allowed": False,
        },
        "counts": {
            "object_png_files": len(object_rows),
            "qualified_complete_buildings": len(qualified_rows),
            "excluded_map_or_tileset_sheets": len(map_sheets),
        },
        "qualified_buildings": qualified_rows,
        "named_exclusions": [row for row in object_rows if "exclusion_reason" in row],
        "all_object_png_files": object_rows,
        "excluded_map_or_tileset_sheets": map_sheets,
        "render": {
            "file": "buildings.png",
            "dimensions": [render.width, render.height],
            "sha256": digest(render_path),
        },
        "status": "SOURCE_BUILDINGS_INVENTORIED_NOT_CONVERTED_NOT_RUNTIME_VALIDATED_NOT_PLACED",
    }
    (out / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(
        "RAWASSET_BUILDING_INVENTORY_PASS "
        f"objects={len(object_rows)} qualified={len(qualified_rows)} map_sheets={len(map_sheets)}"
    )


if __name__ == "__main__":
    main()
