#!/usr/bin/env python3
"""Selection board: every AUTONOMOUS_CONFIRMED building, native size, on each NNV plot.

Purpose: let the project owner choose one building per plot, on evidence, with
no artistic decision taken on their behalf.

For each of the four cleared plots this renders one contact sheet where every
eligible candidate is composited onto the SAME real NNV terrain, at its NATIVE
pixel size, with its id, dimensions and source archive printed next to it.

Hard rules, enforced in code:
  * only `AUTONOMOUS_CONFIRMED` candidates appear (Tiles8 stays excluded);
  * the building is never resized, recolored or interpolated;
  * NNV terrain is real, taken from the generated season Ground;
  * the old NNV structure and door are hidden virtually, preview only;
  * nothing is written to `Data/`; the map is never modified.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

from PIL import Image, ImageDraw

from probe_house_underlying_ground import CELL, GRID, HOUSES, read_tile_sheet, tex_key, unpremultiply
from render_cleared_house_plots import STRUCTURE_LAYERS, door_cells
from place_pmu_building_on_plot import composite, load_catalog

REPO = Path(__file__).resolve().parents[2]
GENERATED = REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage"
LIBRARY = REPO / "docs/pmuniverse_buildings"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--season", default="summer")
    parser.add_argument("--columns", type=int, default=6)
    parser.add_argument("--out", type=Path, default=REPO / "NO_NAME_VILLAGE_ADAPTATION/reports/pmu-placement/selection")
    arguments = parser.parse_args()

    catalog = load_catalog()
    candidates = sorted(
        (c for c in catalog.values() if c["classification"] == "AUTONOMOUS_CONFIRMED"),
        key=lambda c: (-(c["dimensions"][0] * c["dimensions"][1]), c["structure_id"]),
    )

    ground_path = GENERATED / arguments.season / f"Data/Ground/nnv_rmvillage_{arguments.season}.rsground"
    obj = json.loads(ground_path.read_text(encoding="utf-8-sig"))["Object"]
    layers = obj["Layers"]
    doors = {g["EntName"]: g for g in obj["Entities"][0]["GroundObjects"]}

    sheets = {}
    for tile_path in (GENERATED / arguments.season / "Content/Tile").glob("*.tile"):
        size, images = read_tile_sheet(tile_path)
        sheets[tile_path.stem] = (size, {k: unpremultiply(v) for k, v in images.items()})

    assets = {c["structure_id"]: Image.open(LIBRARY / c["tracked_file"]).convert("RGBA") for c in candidates}

    arguments.out.mkdir(parents=True, exist_ok=True)
    index = {}
    for plot, meta in HOUSES.items():
        ax, ay = meta["anchor"]
        tx, ty = meta["trim"]
        pw, ph = meta["size"]
        x0, y0 = ax + tx, ay + ty
        door = doors[f"Exit_Door_{meta['door']}"]["Collider"]

        # One shared terrain swatch, centred on the old doorway: the real plot.
        tile_w, tile_h = 320, 300
        cx = door["X"] + door["Width"] // 2
        sx0 = cx - tile_w // 2
        sy0 = door["Y"] + door["Height"] - tile_h + 40
        terrain = composite(
            layers, sheets, sx0, sy0, tile_w, tile_h,
            skip_layers=STRUCTURE_LAYERS,
            skip_cells={"NNV instances": door_cells(meta["door"])},
        )

        columns = arguments.columns
        rows = (len(candidates) + columns - 1) // columns
        label = 34
        cell_w, cell_h = tile_w + 10, tile_h + label + 10
        board = Image.new("RGBA", (cell_w * columns + 10, cell_h * rows + 60), (22, 22, 30, 255))
        draw = ImageDraw.Draw(board)
        draw.text((12, 10), f"{plot} — parcelle {pw}x{ph} px — {len(candidates)} candidats AUTONOMOUS_CONFIRMED, taille native", fill=(255, 255, 255, 255))
        draw.text((12, 26), "terrain NNV reel, structure + porte retirees virtuellement — APERCU, aucune modification de la map", fill=(150, 200, 255, 255))

        for position, candidate in enumerate(candidates):
            bx = 10 + (position % columns) * cell_w
            by = 60 + (position // columns) * cell_h
            cellimg = terrain.copy()
            asset = assets[candidate["structure_id"]]
            bw, bh = asset.size
            # native placement: doorway on the old entry column, feet on the path
            ox = (tile_w - bw) // 2
            oy = (tile_h - 40) - bh
            cellimg.alpha_composite(asset, (max(0, ox), max(0, oy)))
            board.alpha_composite(cellimg, (bx, by))
            draw.rectangle([bx, by, bx + tile_w - 1, by + tile_h - 1], outline=(70, 70, 85, 255))
            draw.text((bx + 4, by + tile_h + 3), candidate["structure_id"], fill=(255, 255, 255, 255))
            draw.text((bx + 4, by + tile_h + 16), f"{bw}x{bh} px  {candidate['source_archive'].replace('.tile','')}", fill=(160, 210, 160, 255))

        name = f"SELECTION_{plot}.png"
        board.convert("RGB").save(arguments.out / name, quality=95)
        index[plot] = {
            "board": name,
            "plot_size_px": [pw, ph],
            "candidate_count": len(candidates),
            "building": None,
            "owner_validated": False,
        }
        print(f"{plot:20} board -> {name} ({len(candidates)} candidats)")

    (arguments.out / "selection-index.json").write_text(json.dumps({
        "schema": "new-era.nnv-building-selection-board.v1",
        "stage": "PREVIEW_ONLY",
        "map_modified": False,
        "eligible": "AUTONOMOUS_CONFIRMED only; Tiles8 excluded pending PMU.zip",
        "provenance": {"canonical_authority": "PMU.zip",
                       "Tiles0.tile": "VALIDATED_AGAINST_PMU_ZIP",
                       "Tiles9.tile": "VALIDATED_AGAINST_PMU_ZIP",
                       "Tiles8.tile": "REVIEW_REQUIRED"},
        "candidates": [
            {"structure_id": c["structure_id"], "dimensions": c["dimensions"],
             "source_archive": c["source_archive"], "opaque_pixels": c["opaque_pixels"]}
            for c in candidates
        ],
        "plots": index,
    }, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
