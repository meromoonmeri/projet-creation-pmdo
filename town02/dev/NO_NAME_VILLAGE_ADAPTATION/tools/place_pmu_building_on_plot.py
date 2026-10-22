#!/usr/bin/env python3
"""Place a chosen PMU building on a cleared NNV plot, at NATIVE size.

Rule enforced, exactly as specified by the project owner:

    NNV terrain            = kept, untouched
    old NNV structure      = removed
    old NNV door/entry     = removed
    chosen PMU building    = placed at its NATIVE pixel size
    free terrain around it = stays NNV, deliberately

The new building does NOT have to match the old footprint. No upscale, no
rescale, no interpolation, no recolor is ever applied to the PMU asset. The
plot is only the area where the old house stood; leftover open ground around
the new building is the intended result, not a defect.

Gate: only `AUTONOMOUS_CONFIRMED` candidates may be placed. Anything
`REVIEW_REQUIRED` (e.g. the Tiles8 provenance divergence) or unknown is
refused rather than silently substituted.

This renders previews. It does not write into `Data/` and does not edit any
tracked Ground; interiors are explicitly out of scope for now.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

from PIL import Image

from probe_house_underlying_ground import CELL, GRID, HOUSES, read_tile_sheet, tex_key, unpremultiply
from render_cleared_house_plots import STRUCTURE_LAYERS, door_cells

REPO = Path(__file__).resolve().parents[2]
GENERATED = REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage"
LIBRARY = REPO / "docs/pmuniverse_buildings"
AUTONOMY = REPO / "PMU_ADAPTATION/reports/structure-autonomy/structure-autonomy.json"


def load_catalog() -> dict:
    report = json.loads(AUTONOMY.read_text())
    return {c["structure_id"]: c for c in report["candidates"]}


def composite(layers, sheets, x0, y0, width, height, skip_layers, skip_cells) -> Image.Image:
    canvas = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    for layer in layers:
        if not layer.get("Visible") or layer["Name"] in skip_layers:
            continue
        drop = skip_cells.get(layer["Name"], set())
        tiles = layer["Tiles"]
        columns = len(tiles)
        cell = CELL * (GRID // columns)
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
    parser.add_argument("--plot", required=True, choices=sorted(HOUSES), help="NNV plot to build on")
    parser.add_argument("--building", required=True, help="PMU structure id, e.g. tiles0_0357")
    parser.add_argument("--anchor", default="door", choices=["door", "center"],
                        help="where to stand the building: on the old door column, or plot center")
    parser.add_argument("--season", default="summer")
    parser.add_argument("--margin", type=int, default=192)
    parser.add_argument("--out", type=Path, default=REPO / "NO_NAME_VILLAGE_ADAPTATION/reports/pmu-placement")
    arguments = parser.parse_args()

    catalog = load_catalog()
    candidate = catalog.get(arguments.building)
    if candidate is None:
        raise SystemExit(f"INVALID_REFERENCE: {arguments.building} does not exist in the library")
    if candidate["classification"] != "AUTONOMOUS_CONFIRMED":
        raise SystemExit(
            f"REFUSED: {arguments.building} is {candidate['classification']} "
            f"(archive {candidate['source_archive']}); only AUTONOMOUS_CONFIRMED may be placed"
        )

    meta = HOUSES[arguments.plot]
    ax, ay = meta["anchor"]
    tx, ty = meta["trim"]
    pw, ph = meta["size"]
    x0, y0 = ax + tx, ay + ty

    ground_path = GENERATED / arguments.season / f"Data/Ground/nnv_rmvillage_{arguments.season}.rsground"
    obj = json.loads(ground_path.read_text(encoding="utf-8-sig"))["Object"]
    layers = obj["Layers"]
    doors = {g["EntName"]: g for g in obj["Entities"][0]["GroundObjects"]}
    door = doors[f"Exit_Door_{meta['door']}"]["Collider"]

    sheets = {}
    for tile_path in (GENERATED / arguments.season / "Content/Tile").glob("*.tile"):
        size, images = read_tile_sheet(tile_path)
        sheets[tile_path.stem] = (size, {k: unpremultiply(v) for k, v in images.items()})

    building = Image.open(LIBRARY / candidate["tracked_file"]).convert("RGBA")
    bw, bh = building.size
    if [bw, bh] != candidate["dimensions"]:
        raise SystemExit("asset dimensions differ from the certified manifest")

    # Native placement. The building keeps its own size; the plot is only a location.
    if arguments.anchor == "door":
        # Stand the building so its doorway sits where the village path already leads.
        px = door["X"] + door["Width"] // 2 - bw // 2
        py = door["Y"] + door["Height"] - bh
    else:
        px = x0 + (pw - bw) // 2
        py = y0 + (ph - bh) // 2

    vx0, vy0 = max(0, x0 - arguments.margin), max(0, y0 - arguments.margin)
    vw, vh = pw + arguments.margin * 2, ph + arguments.margin * 2

    cleared = composite(
        layers, sheets, vx0, vy0, vw, vh,
        skip_layers=STRUCTURE_LAYERS,
        skip_cells={"NNV instances": door_cells(meta["door"])},
    )
    placed = cleared.copy()
    placed.alpha_composite(building, (px - vx0, py - vy0))

    arguments.out.mkdir(parents=True, exist_ok=True)
    stem = f"{arguments.plot}__{arguments.building}"
    placed.save(arguments.out / f"{stem}_placed.png")

    record = {
        "schema": "new-era.nnv-pmu-native-placement.v1",
        "applied_to_map": False,
        "rule": "NNV terrain kept; old NNV structure and door removed; PMU building placed at native size; "
                "open terrain around the building is intentional NNV ground",
        "plot": {
            "id": arguments.plot,
            "origin_px": [x0, y0],
            "size_px": [pw, ph],
            "removed_door_entity": f"Exit_Door_{meta['door']}",
        },
        "building": {
            "structure_id": arguments.building,
            "classification": candidate["classification"],
            "source_archive": candidate["source_archive"],
            "source_atlas_bbox": candidate["source_atlas_bbox"],
            "native_size_px": [bw, bh],
            "opaque_pixels": candidate["opaque_pixels"],
            "tracked_sha256": candidate["tracked_sha256"],
            "rescaled": False,
            "recolored": False,
        },
        "placement": {
            "anchor_mode": arguments.anchor,
            "position_px": [px, py],
            "occupies_percent_of_old_plot": round(100.0 * bw * bh / (pw * ph), 2),
            "note": "coverage of the old plot is informational only; the new building is not required "
                    "to match the old footprint",
        },
        "interior": "NOT_LINKED — building -> interior association is deliberately out of scope for now",
        "render": f"{stem}_placed.png",
        "status": "NATIVE_PLACEMENT_PREVIEW",
    }
    (arguments.out / f"{stem}.json").write_text(json.dumps(record, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
    print(f"{arguments.plot} <- {arguments.building} {bw}x{bh}px native at ({px},{py}) [{arguments.anchor}]")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
