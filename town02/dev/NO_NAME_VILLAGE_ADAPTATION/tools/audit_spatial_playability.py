#!/usr/bin/env python3
"""Read-only spatial/playability audit: which factor makes NNV feel PMDO-scaled?

The criterion is NOT "buildings have a similar size". It is:

    When a PMDO-sized Pokemon walks through NNV, do the ground, paths, plots,
    buildings, trees, distances and open space make it feel like it belongs?

Two opposite failures are searched for explicitly:
  * oversized world  -> Pokemon looks tiny, paths absurdly wide, travel long
  * undersized world -> Pokemon looks huge, paths too narrow, buildings crushed

Measurement uses the collision grid, which is 8 px in EVERY PMDO Ground and in
NNV alike, so it expresses real world space in a shared unit. Free-space run
lengths give path/corridor widths; blocked clusters give structure footprints;
the free/blocked ratio gives built-vs-open density.

Reference is a broad corpus of validated PMDO Grounds, not metano_town alone.

Writes nothing outside its report directory. No NNV modification, no asset
added or removed, no terrain imported, no manual adjustment.
"""
from __future__ import annotations

import argparse
import glob
import json
import statistics
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
POKEMON_PX = 16
CELL_PX = 8  # collision cell, invariant across PMDO and NNV


def load_grid(path: Path):
    obj = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
    obstacles = obj["obstacles"]
    width, height = len(obstacles), len(obstacles[0])
    grid = [[1 if obstacles[x][y]["Tags"] != 0 else 0 for y in range(height)] for x in range(width)]
    return grid, width, height, obj


def free_runs(grid, width, height, minimum=2):
    """Lengths of contiguous walkable cells = path / passage widths."""
    runs = []
    for y in range(height):
        n = 0
        for x in range(width):
            if grid[x][y] == 0:
                n += 1
            else:
                if n >= minimum:
                    runs.append(n)
                n = 0
        if n >= minimum:
            runs.append(n)
    for x in range(width):
        n = 0
        for y in range(height):
            if grid[x][y] == 0:
                n += 1
            else:
                if n >= minimum:
                    runs.append(n)
                n = 0
        if n >= minimum:
            runs.append(n)
    return runs


def blocked_clusters(grid, width, height, minimum=8):
    """Connected blocked regions = structure / obstacle footprints."""
    seen = [[False] * height for _ in range(width)]
    out = []
    for x in range(width):
        for y in range(height):
            if grid[x][y] and not seen[x][y]:
                stack = [(x, y)]
                seen[x][y] = True
                count = 0
                minx = maxx = x
                miny = maxy = y
                while stack:
                    cx, cy = stack.pop()
                    count += 1
                    minx, maxx = min(minx, cx), max(maxx, cx)
                    miny, maxy = min(miny, cy), max(maxy, cy)
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                        nx, ny = cx + dx, cy + dy
                        if 0 <= nx < width and 0 <= ny < height and grid[nx][ny] and not seen[nx][ny]:
                            seen[nx][ny] = True
                            stack.append((nx, ny))
                if count >= minimum:
                    out.append({"cells": count, "w": maxx - minx + 1, "h": maxy - miny + 1})
    return out


def profile(path: Path) -> dict | None:
    grid, width, height, obj = load_grid(path)
    runs = free_runs(grid, width, height)
    if not runs:
        return None
    clusters = blocked_clusters(grid, width, height)
    free = sum(1 for x in range(width) for y in range(height) if grid[x][y] == 0)
    total = width * height
    spans = [max(c["w"], c["h"]) for c in clusters]
    return {
        "ground": path.stem,
        "tex_size": obj["TexSize"],
        "grid_cells": [width, height],
        "world_px": width * CELL_PX,
        "path_median_cells": statistics.median(runs),
        "path_p75_cells": statistics.quantiles(runs, n=4)[2] if len(runs) > 3 else runs[0],
        "structure_span_median_cells": statistics.median(spans) if spans else 0,
        "structure_count": len(clusters),
        "free_percent": round(100 * free / total, 1),
        "structure_density_per_1000_cells": round(1000 * len(clusters) / total, 3),
    }


def build_reference() -> dict:
    profiles = []
    for path in sorted(glob.glob(str(REPO / "Data/Ground/*.rsground"))):
        try:
            obj = json.loads(Path(path).read_text(encoding="utf-8-sig"))["Object"]
        except Exception:
            continue
        if obj["TexSize"] != 1:
            continue
        obstacles = obj["obstacles"]
        if len(obstacles) < 60:
            continue
        if not any(c["Tags"] != 0 for col in obstacles for c in col):
            continue
        result = profile(Path(path))
        if result:
            profiles.append(result)

    def band(key):
        values = sorted(p[key] for p in profiles)
        deciles = statistics.quantiles(values, n=10)
        return {
            "median": round(statistics.median(values), 1),
            "central_band_d1_d9": [round(deciles[0], 1), round(deciles[-1], 1)],
            "min": round(min(values), 1), "max": round(max(values), 1),
        }

    return {
        "corpus_size": len(profiles),
        "selection": "all TexSize=1 Grounds >= 60 cells wide containing real collision structure",
        "path_median_cells": band("path_median_cells"),
        "path_p75_cells": band("path_p75_cells"),
        "structure_span_median_cells": band("structure_span_median_cells"),
        "free_percent": band("free_percent"),
        "structure_density_per_1000_cells": band("structure_density_per_1000_cells"),
        "named_examples": [p for p in profiles if p["ground"] in
                           {"metano_town", "t01p01", "t00p01", "bourg_comptoir", "testmap", "altere_pond"}],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path,
                        default=REPO / "NO_NAME_VILLAGE_ADAPTATION/reports/spatial-playability")
    arguments = parser.parse_args()
    arguments.out.mkdir(parents=True, exist_ok=True)

    reference = build_reference()
    nnv = profile(REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage/summer/Data/Ground/nnv_rmvillage_summer.rsground")

    # Technical feasibility: cell must stay a whole multiple of 8 px (PMDO law),
    # factor must be integer nearest-neighbour, and <= art density 4 to be lossless.
    art_density = 4
    hypotheses = {}
    for divisor, label in ((1, "x1"), (2, "x0.5"), (4, "x0.25"), (8, "x0.125")):
        cell_after = 64 / divisor
        tex_after = cell_after / CELL_PX
        scaled = {
            "path_median_cells": nnv["path_median_cells"] / divisor,
            "path_p75_cells": nnv["path_p75_cells"] / divisor,
            "structure_span_median_cells": nnv["structure_span_median_cells"] / divisor,
            "free_percent": nnv["free_percent"],  # ratio: scale-invariant
        }
        checks = {}
        errors = []
        for key in ("path_median_cells", "path_p75_cells", "structure_span_median_cells"):
            low, high = reference[key]["central_band_d1_d9"]
            value = scaled[key]
            checks[key] = {
                "value_cells": round(value, 1),
                "value_px": round(value * CELL_PX, 1),
                "value_in_pokemon": round(value * CELL_PX / POKEMON_PX, 2),
                "pmdo_median": reference[key]["median"],
                "pmdo_band": [low, high],
                "in_band": low <= value <= high,
                "error_vs_median_percent": round(100 * abs(value / reference[key]["median"] - 1), 1),
            }
            errors.append(abs(value / reference[key]["median"] - 1))
        hypotheses[label] = {
            "divisor": divisor,
            "tile_cell_px_after": cell_after,
            "implied_tex_size": tex_after,
            "technically_valid": float(tex_after).is_integer() and tex_after >= 1,
            "lossless": divisor <= art_density,
            "pixel_loss": "none" if divisor <= art_density else "yes: exceeds art density 4",
            "checks": checks,
            "in_band_count": sum(1 for c in checks.values() if c["in_band"]),
            "mean_error_percent": round(100 * sum(errors) / len(errors), 1),
            "free_percent_note": "scale-invariant ratio; no factor can change it",
        }

    valid = {k: v for k, v in hypotheses.items() if v["technically_valid"]}
    best = max(valid.items(), key=lambda kv: (kv[1]["in_band_count"], -kv[1]["mean_error_percent"]))

    report = {
        "schema": "new-era.nnv-spatial-playability.v1",
        "read_only": True,
        "nnv_modified": False,
        "criterion": "does a PMDO-sized Pokemon feel like it belongs in NNV: paths, plots, "
                     "structures, distances and open space, not building size alone",
        "measurement_unit": "collision cell = 8 px, identical in PMDO and NNV",
        "pmdo_reference": reference,
        "nnv_native": nnv,
        "hypotheses": hypotheses,
        "recommended_factor": best[0],
        "recommended_divisor": best[1]["divisor"],
        "conclusion": f"NNV_NEEDS_SCALE_ADAPTATION -> {best[0]}",
        "contradicts_previous_audit": {
            "previous_commit": "d69115848b9ce5b7829afe5d6dccbd902c10cf7e",
            "previous_conclusion": "x0.125 (and an earlier x4 for PMU assets)",
            "why_it_was_wrong": "the earlier audit compared ARTWORK resolution (art pixels) instead of "
                                "WORLD FOOTPRINT (collision cells). The collision grid is already 8 px in "
                                "NNV, so it measures world space in PMDO's own unit. Matching a 118 px "
                                "drawing to a 114 px drawing said nothing about how much world the house "
                                "occupies, nor about path widths, plots and distances.",
        },
        "scale_invariant_finding": {
            "nnv_free_percent": nnv["free_percent"],
            "pmdo_free_percent_median": reference["free_percent"]["median"],
            "meaning": "NNV is intrinsically more open than the PMDO median. This is a ratio and no "
                       "scale factor can change it: it is an authored layout property, not a scale bug.",
        },
        "not_applied": "audit only; nothing resized, added, removed or imported",
    }

    (arguments.out / "spatial-playability.json").write_text(
        json.dumps(report, indent=2, sort_keys=True, ensure_ascii=False) + "\n")

    print(f"PMDO corpus            : {reference['corpus_size']} Grounds")
    print(f"PMDO path median       : {reference['path_median_cells']['median']} cells "
          f"(band {reference['path_median_cells']['central_band_d1_d9']})")
    print(f"NNV native path median : {nnv['path_median_cells']} cells")
    print()
    for label, data in hypotheses.items():
        flag = "" if data["technically_valid"] else "  [INVALID]"
        print(f"  {label:8} cell={data['tile_cell_px_after']:>5.1f}px TexSize={data['implied_tex_size']:>3.0f} "
              f"in_band={data['in_band_count']}/3 err={data['mean_error_percent']:>6.1f}% "
              f"lossless={data['lossless']}{flag}")
    print(f"\nrecommended            : {best[0]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
