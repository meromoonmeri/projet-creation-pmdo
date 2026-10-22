#!/usr/bin/env python3
"""Create a deterministic unique-name copy of a staged b41 candidate.

The shared Treeshroud names are consumed by Relic Forest, arenas and Grounds.
This tool changes only serialized asset names/paths in an ignored candidate; it
does not alter pixels, chunks, palettes, CANM frames, or production files.
"""
from __future__ import annotations

import argparse
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OLD_SHEET = "TreeshroudForest1"
OLD_FILES = {
    "floor": "treeshroud_forest_1_floor.json",
    "wall": "treeshroud_forest_1_wall.json",
    "secondary": "treeshroud_forest_1_secondary.json",
}


def build(source: Path, output: Path, sheet: str, prefix: str) -> Path:
    if output.exists():
        shutil.rmtree(output)
    shutil.copytree(source, output)
    auto_files = {category: f"{prefix}_{category}.json" for category in OLD_FILES}
    old_tile = output / "Content/Tile" / f"{OLD_SHEET}.tile"
    new_tile = output / "Content/Tile" / f"{sheet}.tile"
    old_tile.rename(new_tile)
    for category, old_name in OLD_FILES.items():
        old_path = output / "Data/AutoTile" / old_name
        new_path = output / "Data/AutoTile" / auto_files[category]
        text = old_path.read_text(encoding="utf-8")
        text = text.replace(OLD_SHEET, sheet)
        old_path.unlink()
        new_path.write_text(text, encoding="utf-8")
    manifest_path = output / "manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    manifest["namespace"] = {"sheet": sheet, "autotile_files": auto_files}
    manifest["candidate_status"] = "STAGED_STARTUP_ADAPTER_CANDIDATE" if manifest.get("animation_adapter", {}).get("one_shot_startup_adapter") else "STAGED_UNIQUE_NAMESPACE_CANDIDATE"
    manifest["atlas"]["path"] = str(new_tile.relative_to(ROOT))
    manifest["autotiles"] = {
        category: {**record, "path": str((output / "Data/AutoTile" / auto_files[category]).relative_to(ROOT))}
        for category, record in manifest["autotiles"].items()
    }
    manifest["production_route"]["namespace"] = "UNIQUE_SINISTER_WOODS_B41"
    manifest["production_route"]["resources_to_replace_only"] = [
        str(new_tile.relative_to(ROOT)),
        *(str((output / "Data/AutoTile" / auto_files[category]).relative_to(ROOT)) for category in ("floor", "wall", "secondary")),
    ]
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    validation = output / "validation.json"
    if validation.exists():
        validation.unlink()
    return output


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=Path(".runtime-cache/sinister-woods-b41-startup-candidate"))
    parser.add_argument("--output", type=Path, default=Path(".runtime-cache/sinister-woods-b41-unique-candidate"))
    parser.add_argument("--sheet", default="SinisterWoodsB41")
    parser.add_argument("--prefix", default="sinister_woods_b41")
    args = parser.parse_args()
    source = args.source if args.source.is_absolute() else ROOT / args.source
    output = args.output if args.output.is_absolute() else ROOT / args.output
    print(build(source, output, args.sheet, args.prefix))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
