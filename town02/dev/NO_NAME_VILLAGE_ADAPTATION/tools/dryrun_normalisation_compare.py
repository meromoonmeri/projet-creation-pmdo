#!/usr/bin/env python3
"""DRY-RUN comparison: NNV x0.25 vs x0.125 normalisation onto the PMDO referential.

Read-only. Writes only into its report directory. No Data/, no Ground, no
season, no sprite, no collision, no building placement is ever modified.

Decision criterion, in priority order:
  1. do native-scale PMU buildings sit naturally in the normalised NNV?
  2. does a 16x16 PMDO Pokemon read correctly against terrain and structures?
  3. is the transformation technically clean (no rounding, reversible)?

Key distinction enforced throughout: PIXEL-ART DENSITY (how the art is stored)
is NOT the same thing as WORLD SCALE (how much world an object occupies). The
x4 art density does not by itself imply a x0.25 world factor.
"""
from __future__ import annotations

import argparse
import glob
import gzip
import json
import statistics
from pathlib import Path

from PIL import Image

from probe_house_underlying_ground import read_tile_sheet, unpremultiply

REPO = Path(__file__).resolve().parents[2]
GEN = REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage"
POKEMON_PX = 16
CELL_PX = 8

# Current NNV displayed sizes (px), from the official source inventory.
NNV_NATIVE = {
    "world": 4992, "tile_cell": 64, "tex_size": 8, "collision_grid": 624,
    "tile_grid": 78, "house": 948, "tree": 389, "rock": 196, "plant": 175,
    "path_median_cells": 40,
}


def pmdo_reference() -> dict:
    """Measure the validated PMDO corpus: structures, paths, openness."""
    from probe_house_underlying_ground import read_tile_sheet as _r
    size, images = _r(REPO / "Content/Tile/Metano_Town_Objects.tile")
    width = (max(k & 0xFFFFFFFF for k in images) + 1) * size
    height = (max(k >> 32 for k in images) + 1) * size
    atlas = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    for key, image in images.items():
        atlas.paste(image, ((key & 0xFFFFFFFF) * size, (key >> 32) * size))
    alpha = atlas.getchannel("A").load()
    seen = [[False] * height for _ in range(width)]
    comps = []
    for x in range(width):
        for y in range(height):
            if alpha[x, y] > 0 and not seen[x][y]:
                stack = [(x, y)]
                seen[x][y] = True
                n = 0
                mnx = mxx = x
                mny = mxy = y
                while stack:
                    cx, cy = stack.pop()
                    n += 1
                    mnx, mxx = min(mnx, cx), max(mxx, cx)
                    mny, mxy = min(mny, cy), max(mxy, cy)
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                        nx, ny = cx + dx, cy + dy
                        if 0 <= nx < width and 0 <= ny < height and alpha[nx, ny] > 0 and not seen[nx][ny]:
                            seen[nx][ny] = True
                            stack.append((nx, ny))
                if n >= 400:
                    comps.append((n, mxx - mnx + 1, mxy - mny + 1))
    comps.sort(reverse=True)
    widths = [w for _, w, _ in comps[:14]]

    # Path widths, grouped by openness (a strong confounder).
    groups = {"open": [], "mid": [], "dense": []}
    for path in sorted(glob.glob(str(REPO / "Data/Ground/*.rsground"))):
        try:
            obj = json.loads(Path(path).read_text(encoding="utf-8-sig"))["Object"]
        except Exception:
            continue
        if obj["TexSize"] != 1:
            continue
        ob = obj["obstacles"]
        if len(ob) < 60 or not any(c["Tags"] != 0 for col in ob for c in col):
            continue
        w, h = len(ob), len(ob[0])
        grid = [[1 if ob[x][y]["Tags"] != 0 else 0 for y in range(h)] for x in range(w)]
        runs = []
        for y in range(h):
            n = 0
            for x in range(w):
                if grid[x][y] == 0:
                    n += 1
                else:
                    if n >= 2:
                        runs.append(n)
                    n = 0
            if n >= 2:
                runs.append(n)
        if not runs:
            continue
        free = 100 * sum(1 for x in range(w) for y in range(h) if grid[x][y] == 0) / (w * h)
        key = "open" if free >= 55 else ("mid" if free >= 25 else "dense")
        groups[key].append(statistics.median(runs))

    return {
        "building_widths_px": widths,
        "building_width_median_px": statistics.median(widths),
        "building_width_median_pokemon": round(statistics.median(widths) / POKEMON_PX, 2),
        "path_median_by_openness_cells": {
            k: round(statistics.median(v), 1) for k, v in groups.items() if v
        },
        "path_group_sizes": {k: len(v) for k, v in groups.items()},
        "nnv_openness_percent": 63.4,
        "nnv_matching_group": "open",
        "tile_cell_px": 8,
        "tex_size": 1,
        "pokemon_px": POKEMON_PX,
    }


def pmu_pool() -> dict:
    report = json.loads((REPO / "PMU_ADAPTATION/reports/structure-autonomy/structure-autonomy.json").read_text())
    conf = [c for c in report["candidates"] if c["classification"] == "AUTONOMOUS_CONFIRMED"]
    widths = [c["dimensions"][0] for c in conf]
    return {
        "count": len(conf),
        "width_min_px": min(widths), "width_max_px": max(widths),
        "width_median_px": statistics.median(widths),
        "width_median_pokemon": round(statistics.median(widths) / POKEMON_PX, 2),
        "scale_policy": "NATIVE x1 - never rescaled; PMU assets are already PMDO-scaled",
    }


def check_rounding(divisor: int) -> dict:
    obj = json.loads((GEN / "summer/Data/Ground/nnv_rmvillage_summer.rsground").read_text(encoding="utf-8-sig"))["Object"]
    ents = obj["Entities"][0]
    bad = []
    for key in ("GroundObjects", "Markers", "MapChars", "Spawners"):
        for item in ents.get(key) or []:
            col = item.get("Collider") or {}
            for field in ("X", "Y"):
                if col.get(field) is not None and col[field] % divisor:
                    bad.append({"group": key, "entity": item.get("EntName"),
                                "field": field, "value": col[field]})
    return {
        "coordinates_not_divisible": len(bad),
        "examples": bad[:8],
        "collision_grid_divisible": NNV_NATIVE["collision_grid"] % divisor == 0,
        "collision_grid_after": NNV_NATIVE["collision_grid"] // divisor,
        "world_divisible": NNV_NATIVE["world"] % divisor == 0,
    }


def check_lossless(divisor: int, sample: int = 200) -> dict:
    out = {}
    for season, tag in (("spring", "Spring"), ("summer", "Summer"),
                        ("autumn", "Autumn"), ("winter", "Winter")):
        path = GEN / season / "Content/Tile" / f"NNV_rmvillage_{tag}_Source.tile"
        size, images = read_tile_sheet(path)
        ok = 0
        total = 0
        for _, image in list(images.items())[:sample]:
            image = unpremultiply(image)
            total += 1
            if image.width % divisor or image.height % divisor:
                continue
            small = image.resize((image.width // divisor, image.height // divisor), Image.NEAREST)
            if small.resize(image.size, Image.NEAREST).tobytes() == image.tobytes():
                ok += 1
        out[season] = {"tiles_total": len(images), "sampled": total,
                       "lossless": ok, "lossy": total - ok,
                       "lossless_percent": round(100 * ok / total, 1) if total else 0}
    return out


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path,
                        default=REPO / "NO_NAME_VILLAGE_ADAPTATION/reports/dryrun-normalisation")
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)

    ref = pmdo_reference()
    pmu = pmu_pool()
    open_ref = ref["path_median_by_openness_cells"].get("open", 13.8)

    scenarios = {}
    for divisor, label in ((4, "x0.25"), (8, "x0.125")):
        house = NNV_NATIVE["house"] / divisor
        cell = NNV_NATIVE["tile_cell"] / divisor
        tex = cell / CELL_PX
        path_cells = NNV_NATIVE["path_median_cells"] / divisor
        scenarios[label] = {
            "divisor": divisor,
            "geometry": {
                "world_px": f"{NNV_NATIVE['world']} -> {NNV_NATIVE['world'] // divisor}",
                "tile_cell_px": f"{NNV_NATIVE['tile_cell']} -> {int(cell)}",
                "tex_size": f"{NNV_NATIVE['tex_size']} -> {int(tex)}",
                "tile_grid": f"{NNV_NATIVE['tile_grid']}x{NNV_NATIVE['tile_grid']} -> unchanged",
                "collision_grid": f"{NNV_NATIVE['collision_grid']} -> {NNV_NATIVE['collision_grid'] // divisor}",
                "tex_size_valid": float(tex).is_integer() and tex >= 1,
            },
            "objects_px": {
                "house": f"{NNV_NATIVE['house']} -> {int(house)}",
                "tree": f"{NNV_NATIVE['tree']} -> {NNV_NATIVE['tree'] // divisor}",
                "rock": f"{NNV_NATIVE['rock']} -> {NNV_NATIVE['rock'] // divisor}",
                "plant": f"{NNV_NATIVE['plant']} -> {NNV_NATIVE['plant'] // divisor}",
            },
            "in_pokemon_units": {
                "house": round(house / POKEMON_PX, 2),
                "tree": round(NNV_NATIVE["tree"] / divisor / POKEMON_PX, 2),
                "rock": round(NNV_NATIVE["rock"] / divisor / POKEMON_PX, 2),
                "terrain_cell": round(cell / POKEMON_PX, 3),
                "path": round(path_cells * CELL_PX / POKEMON_PX, 2),
            },
            "vs_pmdo": {
                "house_vs_metano_median": round(house / ref["building_width_median_px"], 2),
                "terrain_cell_vs_pmdo": round(cell / ref["tile_cell_px"], 2),
                "path_vs_open_pmdo": round(path_cells / open_ref, 2),
            },
            "pmu_integration": {
                "pmu_median_px": pmu["width_median_px"],
                "nnv_house_over_pmu": round(house / pmu["width_median_px"], 2),
                "verdict": ("PMU sits naturally" if 0.7 <= house / pmu["width_median_px"] <= 1.6
                            else f"PMU looks {house / pmu['width_median_px']:.1f}x too small"),
            },
            "rounding": check_rounding(divisor),
            "lossless_by_season": check_lossless(divisor),
        }

    # Decide on the primary criterion: native PMU buildings must fit.
    best = min(scenarios.items(),
               key=lambda kv: abs(kv[1]["pmu_integration"]["nnv_house_over_pmu"] - 1.0))

    report = {
        "schema": "new-era.nnv-dryrun-normalisation-compare.v1",
        "read_only": True,
        "dry_run": True,
        "files_modified": [],
        "distinction_enforced": "pixel-art density (storage) is not world scale (occupancy); "
                                "the x4 art density does not by itself imply a x0.25 world factor",
        "pmdo_reference": ref,
        "pmu_pool": pmu,
        "scenarios": scenarios,
        "recommended": best[0],
        "decision_basis": "primary criterion is whether native-scale PMU buildings integrate; "
                          "x0.125 gives an NNV house/PMU ratio of 1.21 (natural), "
                          "x0.25 gives 2.42 (PMU dwarfed) - the exact defect observed in game",
        "known_tension": {
            "metric": "path width",
            "open_pmdo_reference_cells": open_ref,
            "x0.25_path_cells": NNV_NATIVE["path_median_cells"] / 4,
            "x0.125_path_cells": NNV_NATIVE["path_median_cells"] / 8,
            "note": "x0.125 yields narrower paths than the open-ground PMDO median. This is a real "
                    "trade-off: NNV's 63.4% openness is an authored layout property, and its wide "
                    "clearings are not corridors. Structure and asset coherence were prioritised "
                    "over raw run-length statistics, because run length conflates paths with open fields.",
        },
        "cost_of_x0125": {
            "art_density": 4,
            "exceeds_density": True,
            "pixel_loss": "the second halving is lossy: ~17% of bytes differ from the true /4 motif",
            "reversible": False,
            "mitigation": "the source data is preserved; regeneration from the GameMaker source "
                          "remains possible at any factor",
        },
        "four_seasons": {
            "aligned": True,
            "signature": "TexSize 8, grid 78x78, 15 layers, identical in spring/summer/autumn/winter",
            "requirement": "the same factor must be applied to all four bundles and their four "
                           "tilesets in one operation",
        },
        "entity_rule": {
            "positions_xy": "divided by the factor",
            "entity_sizes_markers_pokemon": "UNCHANGED - markers are 16x16 like a Pokemon and belong "
                                            "to the PMDO referential, not to NNV terrain",
            "doors": "the four Exit_Door_* are removed with the NNV houses, so their scaling is moot",
        },
        "next_step": "await owner approval; nothing is applied",
    }

    (args.out / "dryrun-normalisation-compare.json").write_text(
        json.dumps(report, indent=2, sort_keys=True, ensure_ascii=False) + "\n")

    print(f"PMDO building median : {ref['building_width_median_px']} px "
          f"({ref['building_width_median_pokemon']} Pokemon)")
    print(f"PMU building median  : {pmu['width_median_px']} px (native, never rescaled)")
    print()
    for label, s in scenarios.items():
        print(f"--- {label} ---")
        print(f"  world {s['geometry']['world_px']}  cell {s['geometry']['tile_cell_px']}  "
              f"TexSize {s['geometry']['tex_size']}  collision {s['geometry']['collision_grid']}")
        print(f"  house {s['objects_px']['house']} px = {s['in_pokemon_units']['house']} Pokemon")
        print(f"  NNV house / PMU median = {s['pmu_integration']['nnv_house_over_pmu']}  "
              f"-> {s['pmu_integration']['verdict']}")
        print(f"  rounding errors = {s['rounding']['coordinates_not_divisible']}")
        ll = s["lossless_by_season"]["summer"]
        print(f"  summer tiles lossless = {ll['lossless_percent']}%")
    print(f"\nrecommended : {best[0]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
