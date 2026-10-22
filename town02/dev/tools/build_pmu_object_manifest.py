#!/usr/bin/env python3
"""Build the PMU qualified-object manifest and its labeled PNG render."""
from __future__ import annotations

import hashlib
import json
import math
from collections import Counter
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "docs/pmu_asset_inventory"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def category(label: str) -> str:
    rules = (
        ("books_and_documents", ("book", "letter", "paper", "parchment", "newspaper", "map", "ink")),
        ("plants_and_natural_decor", ("flower", "plant", "sprout", "coral", "mushroom", "bamboo", "stone", "berry")),
        ("containers_and_storage", ("pot", "bottle", "barrel", "tub", "container", "chest", "cabinet", "dresser")),
        ("furniture_and_textiles", ("stool", "table", "shelf", "bookcase", "mat", "cushion", "vanity", "plank")),
        ("lighting_and_tableware", ("candelabrum", "lamp", "tea", "dish", "candle")),
        ("weapons_armor_and_tools", ("shield", "spear", "horn", "chain", "grate", "key", "ring", "coin", "tool", "scale")),
        ("wall_art_and_fixtures", ("framed", "frame", "wall", "plaque", "panel", "pipe", "mantel")),
        ("toys_and_miscellaneous", ("teddy", "hook", "handle")),
    )
    for name, terms in rules:
        if any(term in label for term in terms):
            return name
    return "miscellaneous_decor"


def main() -> None:
    qualified_path = BASE / "qualified_small_objects.json"
    source = json.loads(qualified_path.read_text(encoding="utf-8"))
    objects = []
    for row in source["objects"]:
        objects.append(
            {
                "id": f"pmu_{row['archive'].removesuffix('.tile').lower()}_{row['record_index']:04d}",
                "label": row["label"],
                "category": category(row["label"]),
                "source_archive": row["archive"],
                "source_record_index": row["record_index"],
                "png": row["file"],
                "dimensions": row["dimensions"],
                "bytes": row["bytes"],
                "sha256": row["sha256"],
                "alpha_bbox": row["alpha_bbox"],
                "extraction": row["extraction"],
                "source_status": row["status"],
                "pmdo_conversion": row["pmdo_conversion"],
                "runtime_validation": row["runtime_validation"],
                "placement_allowed": row["placement_allowed"],
            }
        )

    columns = 4
    card_width, card_height = 250, 92
    header_height = 90
    rows = math.ceil(len(objects) / columns)
    render = Image.new("RGBA", (columns * card_width, header_height + rows * card_height), (20, 23, 28, 255))
    draw = ImageDraw.Draw(render)
    draw.text((20, 14), "PMU — 83 objets source autonomes vérifiés", fill=(255, 255, 255, 255))
    draw.text((20, 36), "Source: Sprinkoringo/PMU-Client @ c25c01f9879369647cd5a19731b2e4e5acd33e67", fill=(180, 190, 205, 255))
    draw.text((20, 58), "PNG 32x32 complets — aucune découpe de map — PMDO: NOT_RUN — NNV: NOT_PLACED", fill=(245, 185, 80, 255))

    for position, obj in enumerate(objects):
        col, row = position % columns, position // columns
        x, y = col * card_width, header_height + row * card_height
        fill = (31, 36, 44, 255) if (col + row) % 2 == 0 else (37, 42, 51, 255)
        draw.rectangle((x + 4, y + 4, x + card_width - 4, y + card_height - 4), fill=fill, outline=(70, 78, 92, 255))
        tile = Image.open(BASE / obj["png"]).convert("RGBA").resize((64, 64), Image.Resampling.NEAREST)
        checker = Image.new("RGBA", (64, 64), (64, 68, 74, 255))
        checker.alpha_composite(tile)
        render.alpha_composite(checker, (x + 12, y + 14))
        draw.text((x + 86, y + 14), obj["id"], fill=(245, 245, 245, 255))
        draw.text((x + 86, y + 34), obj["label"], fill=(160, 220, 180, 255))
        draw.text((x + 86, y + 54), obj["category"], fill=(165, 180, 210, 255))
        draw.text((x + 86, y + 72), obj["sha256"][:16], fill=(130, 138, 150, 255))

    render_path = BASE / "manifest.png"
    render.save(render_path, optimize=True)
    categories = Counter(obj["category"] for obj in objects)
    manifest = {
        "schema": 1,
        "title": "PMU qualified standalone source objects",
        "source": source["source"],
        "rules": {
            "map_crops": False,
            "resizing_of_source_payloads": False,
            "source_payload": "WHOLE_EMBEDDED_PNG_RECORD_BYTE_EXACT",
            "render_scaling": "2X_NEAREST_NEIGHBOR_PREVIEW_ONLY",
        },
        "count": len(objects),
        "category_counts": dict(sorted(categories.items())),
        "render": {
            "file": "manifest.png",
            "width": render.width,
            "height": render.height,
            "sha256": sha256(render_path),
        },
        "objects": objects,
        "status": "SOURCE_OBJECTS_MANIFESTED_PMDO_CONVERSION_NOT_RUN_NOT_PLACED",
    }
    (BASE / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"PMU_OBJECT_MANIFEST_PASS objects={len(objects)} render={render.width}x{render.height}")


if __name__ == "__main__":
    main()
