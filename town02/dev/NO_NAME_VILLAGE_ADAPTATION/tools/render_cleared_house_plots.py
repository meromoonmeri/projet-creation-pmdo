#!/usr/bin/env python3
"""Render the four rmvillage house plots CLEARED, ready for a PMU building.

Conceptual removal applied here, and nothing more:

    NNV structure  + NNV door/entry + NNV structure collision  = REMOVED
    NNV terrain (ground/groundtex/grass0/grass1)                = KEPT
    NNV trees, roads, rocks, decoration, everything else        = KEPT

No PMU building is chosen or placed. No door is created. No tile is invented.
No empty space is filled. The owner selects the replacement buildings later;
this tool only prepares and documents a clean, reversible plot.

Reversibility: the tool never writes into `Data/` and never edits the tracked
season Grounds. It renders PNGs and emits a removal manifest listing the exact
layers, cells, entities and collision cells a real removal would have to touch,
so the operation can be replayed or undone precisely.

Removal targets are source-proved, not guessed:
  * structure pixels      -> layers `NNV HouseBelow`, `NNV sHouseBelow`
  * door pixels           -> one cell each on `NNV instances`, verified to
                             contain only the door panel
  * door entity + collider-> `Exit_Door_*` GroundObjects
  * structure collision   -> 8 px obstacle cells inside the structure footprint
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

from PIL import Image

from probe_house_underlying_ground import (
    CELL,
    GRID,
    HOUSES,
    read_tile_sheet,
    tex_key,
    unpremultiply,
)

REPO = Path(__file__).resolve().parents[2]
GENERATED = REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage"

STRUCTURE_LAYERS = {"NNV HouseBelow", "NNV sHouseBelow"}
TERRAIN_LAYERS = {"NNV ground", "NNV groundtex", "NNV grass0", "NNV grass1"}

# Door panel cells on `NNV instances`, keyed by door entity instance id.
# The door graphic spans several 64 px cells; the exact block was read from the
# layer (contiguous filled cells around the door collider, isolated from the
# rest of the layer's 118 filled cells). Width x height in cells:
#   106508 player    3x3 starting (14,51)
#   106510 logger    2x3 starting (17,30)
#   106511 carpenter 3x3 starting (34, 9)
#   106509 hunter    2x3 starting (61,32)
DOOR_BLOCKS = {
    106508: {"origin": (14, 51), "size": (3, 3)},
    106510: {"origin": (17, 30), "size": (2, 3)},
    106511: {"origin": (34, 9), "size": (3, 3)},
    106509: {"origin": (61, 32), "size": (2, 3)},
}


def door_cells(door_id: int) -> set[tuple[int, int]]:
    block = DOOR_BLOCKS[door_id]
    ox, oy = block["origin"]
    w, h = block["size"]
    return {(ox + dx, oy + dy) for dx in range(w) for dy in range(h)}


def composite(layers, sheets, x0, y0, width, height, skip_layers, skip_cells) -> Image.Image:
    canvas = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    for layer in layers:
        if not layer.get("Visible") or layer["Name"] in skip_layers:
            continue
        drop = skip_cells.get(layer["Name"], set())
        tiles = layer["Tiles"]
        columns = len(tiles)
        scale = GRID // columns
        cell = CELL * scale
        for cx in range(max(0, x0 // cell), min(columns, (x0 + width - 1) // cell + 1)):
            for cy in range(max(0, y0 // cell), min(len(tiles[0]), (y0 + height - 1) // cell + 1)):
                if (cx, cy) in drop:
                    continue
                stack = tiles[cx][cy].get("Layers") or []
                if not stack:
                    continue
                frames = stack[0].get("Frames") or []
                if not frames:
                    continue
                frame = frames[0]
                if frame["Sheet"] not in sheets:
                    continue
                _, images = sheets[frame["Sheet"]]
                block = images.get(tex_key(frame["TexLoc"]["X"], frame["TexLoc"]["Y"]))
                if block is not None:
                    canvas.alpha_composite(block, (cx * cell - x0, cy * cell - y0))
    return canvas


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--season", default="summer")
    parser.add_argument("--margin", type=int, default=192)
    parser.add_argument("--out", type=Path, default=REPO / "NO_NAME_VILLAGE_ADAPTATION/reports/cleared-house-plots")
    arguments = parser.parse_args()

    ground_path = GENERATED / arguments.season / f"Data/Ground/nnv_rmvillage_{arguments.season}.rsground"
    obj = json.loads(ground_path.read_text(encoding="utf-8-sig"))["Object"]
    layers = obj["Layers"]
    obstacles = obj["obstacles"]
    doors = {g["EntName"]: g for g in obj["Entities"][0]["GroundObjects"] if g["EntName"].startswith("Exit_Door")}

    sheets = {}
    for tile_path in (GENERATED / arguments.season / "Content/Tile").glob("*.tile"):
        size, images = read_tile_sheet(tile_path)
        sheets[tile_path.stem] = (size, {key: unpremultiply(value) for key, value in images.items()})

    arguments.out.mkdir(parents=True, exist_ok=True)
    records = []
    for name, meta in HOUSES.items():
        ax, ay = meta["anchor"]
        tx, ty = meta["trim"]
        width, height = meta["size"]
        x0, y0 = ax + tx, ay + ty
        door_id = meta["door"]
        cells = door_cells(door_id)
        door_entity = f"Exit_Door_{door_id}"

        vx0, vy0 = max(0, x0 - arguments.margin), max(0, y0 - arguments.margin)
        vw, vh = width + arguments.margin * 2, height + arguments.margin * 2

        before = composite(layers, sheets, vx0, vy0, vw, vh, set(), {})
        after = composite(
            layers, sheets, vx0, vy0, vw, vh,
            skip_layers=STRUCTURE_LAYERS,
            skip_cells={"NNV instances": cells},
        )
        before.save(arguments.out / f"{name}_before.png")
        after.save(arguments.out / f"{name}_cleared.png")

        # Collision cells the removal must clear (8 px grid, structure footprint).
        blocked = []
        for cx in range(x0 // 8, (x0 + width - 1) // 8 + 1):
            for cy in range(y0 // 8, (y0 + height - 1) // 8 + 1):
                if 0 <= cx < len(obstacles) and 0 <= cy < len(obstacles[0]):
                    if obstacles[cx][cy]["Tags"] != 0:
                        blocked.append([cx, cy])

        alpha = after.getchannel("A")
        data = list(alpha.get_flattened_data()) if hasattr(alpha, "get_flattened_data") else list(alpha.getdata())
        crop = after.crop((arguments.margin, arguments.margin, arguments.margin + width, arguments.margin + height))
        calpha = crop.getchannel("A")
        cdata = list(calpha.get_flattened_data()) if hasattr(calpha, "get_flattened_data") else list(calpha.getdata())
        opaque = sum(1 for v in cdata if v > 0)

        records.append({
            "structure_id": name,
            "sprite": meta["sprite"],
            "plot_origin_px": [x0, y0],
            "plot_size_px": [width, height],
            "removed": {
                "structure_layers": sorted(STRUCTURE_LAYERS),
                "door_entity": door_entity,
                "door_collider": doors[door_entity]["Collider"],
                "door_cells_on_instances_layer": sorted(list(c) for c in cells),
                "door_block_size_cells": list(DOOR_BLOCKS[door_id]["size"]),
                "structure_collision_cells_8px": len(blocked),
            },
            "kept": {
                "terrain_layers": sorted(TERRAIN_LAYERS),
                "other_nnv_layers": [
                    l["Name"] for l in layers
                    if l["Name"] not in STRUCTURE_LAYERS and l["Name"] not in TERRAIN_LAYERS
                ],
                "note": "trees, roads, rocks, cliffs, plants and empty space stay exactly as NNV authored them",
            },
            "cleared_plot_coverage_percent": round(100.0 * opaque / len(cdata), 4) if cdata else 0.0,
            "renders": {
                "before": f"{name}_before.png",
                "cleared": f"{name}_cleared.png",
            },
            "pmu_building": "NOT_SELECTED — the owner chooses the replacement asset later",
            "status": "PLOT_CLEARED_READY_FOR_MANUAL_BUILDING_SELECTION",
        })
        print(f"{name:20} cleared plot coverage={records[-1]['cleared_plot_coverage_percent']:7.3f}%  "
              f"collision cells to clear={len(blocked)}")

    manifest = {
        "schema": "new-era.nnv-cleared-house-plots.v1",
        "season": arguments.season,
        "read_only": True,
        "applied_to_map": False,
        "rule": "NNV structure + NNV door/entry + NNV structure collision are removed; "
                "NNV terrain and all other NNV environment are kept; no PMU asset is placed",
        "reversibility": "no tracked Ground is edited; this manifest lists every layer, cell, entity "
                         "and collision cell a real removal would touch",
        "houses": records,
    }
    (arguments.out / "cleared-house-plots.json").write_text(
        json.dumps(manifest, indent=2, sort_keys=True, ensure_ascii=False) + "\n"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
