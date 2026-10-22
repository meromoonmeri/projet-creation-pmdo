#!/usr/bin/env python3
"""Inventory PMU-Client assets and extract whole embedded PNG tile records.

This tool never crops a tilesheet.  PMU .tile archives contain one complete PNG
record per 32x32 tile; selected records are copied byte-for-byte.  Pillow is
only used to inspect alpha bounds and build a contact sheet.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import struct
from collections import Counter
from io import BytesIO
from pathlib import Path

from PIL import Image, ImageDraw

SOURCE_REPOSITORY = "https://github.com/Sprinkoringo/PMU-Client"
SOURCE_COMMIT = "c25c01f9879369647cd5a19731b2e4e5acd33e67"
TILE_SIZE = 32


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def parse_archive(path: Path):
    data = path.read_bytes()
    width, height = struct.unpack_from("<ii", data, 0)
    columns, rows = width // TILE_SIZE, height // TILE_SIZE
    count = columns * rows
    header_size = 8 + count * 12
    if header_size > len(data):
        raise ValueError(f"invalid PMU tile header: {path}")
    records = []
    for index in range(count):
        position, size = struct.unpack_from("<qi", data, 8 + index * 12)
        start = header_size + position
        raw = data[start : start + size]
        if len(raw) != size or not raw.startswith(b"\x89PNG\r\n\x1a\n"):
            raise ValueError(f"invalid embedded PNG {path.name}:{index}")
        image = Image.open(BytesIO(raw)).convert("RGBA")
        if image.size != (TILE_SIZE, TILE_SIZE):
            raise ValueError(f"unexpected tile size {path.name}:{index}: {image.size}")
        alpha = image.getchannel("A")
        records.append((index, raw, image, alpha.getbbox(), alpha.getextrema()))
    return data, width, height, columns, rows, records


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--client", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    parser.add_argument(
        "--candidate-archive",
        default="all",
        help="Archive filename or 'all' (default) for exhaustive extraction",
    )
    args = parser.parse_args()

    root = args.client.resolve()
    out = args.out.resolve()
    tile_dir = root / "resources/GFX/Tiles"
    candidate_root = out / "isolated_candidates"
    candidate_root.mkdir(parents=True, exist_ok=True)

    extension_counts = Counter(
        (path.suffix.lower() or "[none]")
        for path in root.rglob("*")
        if path.is_file() and ".git" not in path.parts
    )
    archive_rows = []
    candidate_rows = []
    contact_sheets = []

    for path in sorted(tile_dir.glob("*.tile")):
        data, width, height, columns, rows, records = parse_archive(path)
        raw_hashes = {sha256(raw) for _, raw, _, _, _ in records}
        blank = sum(bounds is None for _, _, _, bounds, _ in records)
        transparent = sum(bounds is not None and extrema[0] == 0 for _, _, _, bounds, extrema in records)
        opaque = sum(bounds is not None and extrema == (255, 255) for _, _, _, bounds, extrema in records)
        interior = [
            record
            for record in records
            if record[3] is not None
            and record[3][0] > 0
            and record[3][1] > 0
            and record[3][2] < TILE_SIZE
            and record[3][3] < TILE_SIZE
        ]
        archive_rows.append(
            {
                "name": path.name,
                "bytes": len(data),
                "sha256": sha256(data),
                "declared_width": width,
                "declared_height": height,
                "columns": columns,
                "rows": rows,
                "embedded_png_records": len(records),
                "unique_embedded_png_records": len(raw_hashes),
                "fully_transparent_records": blank,
                "records_with_transparency": transparent,
                "fully_opaque_records": opaque,
                "strict_interior_alpha_candidates": len(interior),
            }
        )
        if args.candidate_archive != "all" and path.name != args.candidate_archive:
            continue

        archive_candidate_dir = candidate_root / path.stem
        png_dir = archive_candidate_dir / "tiles"
        png_dir.mkdir(parents=True, exist_ok=True)
        seen = set()
        candidate_images = []
        for index, raw, image, bounds, _ in interior:
            digest = sha256(raw)
            if digest in seen:
                continue
            seen.add(digest)
            filename = f"tile_{index:04d}.png"
            relative_file = f"isolated_candidates/{path.stem}/tiles/{filename}"
            (png_dir / filename).write_bytes(raw)
            candidate_rows.append(
                {
                    "archive": path.name,
                    "record_index": index,
                    "file": relative_file,
                    "bytes": len(raw),
                    "sha256": digest,
                    "dimensions": [TILE_SIZE, TILE_SIZE],
                    "alpha_bbox": list(bounds),
                    "extraction": "WHOLE_EMBEDDED_PNG_RECORD_BYTE_EXACT",
                    "status": "GEOMETRICALLY_ISOLATED_CANDIDATE",
                    "visually_qualified": False,
                    "placement_allowed": False,
                }
            )
            candidate_images.append((index, image))

        if candidate_images:
            sheet_columns = 10
            cell_width, cell_height = 64, 48
            sheet_rows = math.ceil(len(candidate_images) / sheet_columns)
            sheet = Image.new(
                "RGBA",
                (sheet_columns * cell_width, sheet_rows * cell_height),
                (28, 28, 28, 255),
            )
            draw = ImageDraw.Draw(sheet)
            for item, (index, image) in enumerate(candidate_images):
                x = (item % sheet_columns) * cell_width
                y = (item // sheet_columns) * cell_height
                background = Image.new("RGBA", (TILE_SIZE, TILE_SIZE), (55, 55, 55, 255))
                background.alpha_composite(image)
                sheet.alpha_composite(background, (x + 16, y))
                draw.text((x + 2, y + 34), str(index), fill="white")
            relative_sheet = f"isolated_candidates/{path.stem}/contact_sheet.png"
            sheet.save(out / relative_sheet, optimize=True)
            contact_sheets.append(
                {
                    "archive": path.name,
                    "file": relative_sheet,
                    "unique_candidates": len(candidate_images),
                }
            )

    inventory = {
        "schema": 1,
        "source": {
            "repository": SOURCE_REPOSITORY,
            "commit": SOURCE_COMMIT,
            "license_file": "LICENSE",
            "credits_file": "Asset Credits.txt",
        },
        "scope": {
            "client_files_without_git": sum(extension_counts.values()),
            "extension_counts": dict(sorted(extension_counts.items())),
            "tile_archives": len(archive_rows),
            "candidate_archive_scope": args.candidate_archive,
        },
        "rules": {
            "map_crops_allowed": False,
            "partial_tile_records_allowed": False,
            "extraction": "whole embedded PNG records only",
            "candidate_is_certification": False,
        },
        "tile_archives": archive_rows,
        "candidate_count": len(candidate_rows),
        "contact_sheets": contact_sheets,
        "candidates": candidate_rows,
        "status": "INVENTORIED_CANDIDATES_NOT_VISUALLY_QUALIFIED_NOT_PLACED",
    }
    out.mkdir(parents=True, exist_ok=True)
    (out / "inventory.json").write_text(json.dumps(inventory, indent=2) + "\n", encoding="utf-8")
    print(
        "PMU_ASSET_INVENTORY_PASS "
        f"archives={len(archive_rows)} records={sum(row['embedded_png_records'] for row in archive_rows)} "
        f"candidates={len(candidate_rows)}"
    )


if __name__ == "__main__":
    main()
