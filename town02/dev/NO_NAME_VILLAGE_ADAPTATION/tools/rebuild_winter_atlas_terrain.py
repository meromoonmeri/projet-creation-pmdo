#!/usr/bin/env python3
"""Regenere le terrain des 5 rooms d'hiver dans l'atlas, apres correction de is_snow_rgb.

Pourquoi
--------
`is_snow_rgb` exigeait (r>200, g>205, b>210) : un blanc franc. Les deux couleurs
qui couvrent le sol des rooms d'hiver NNV sont (197,211,232) et (180,185,227),
un lavande clair. Trop bleutees pour l'ancien seuil, pas assez vertes pour
`is_green_rgb`, elles finissaient en `open` -- alors que l'atlas, lui, les
comptait en `grass`. `rm58` declarait ainsi 2 711 cellules `grass` et 62 `snow`
sur une room entierement enneigee.

Consequence concrete : une entite placee sur une cellule `grass` d'hiver se
retrouvait sur de la neige. C'est le risque nomme dans PREUVE_SAISONNIERE.md.

Ce que fait cet outil
---------------------
Il rejoue UNIQUEMENT l'etage colorimetrique de `build_biome_atlas.build_room`
sur les 5 rooms d'hiver, avec `is_snow_rgb` corrige, et met a jour dans l'atlas
les seules cellules issues du rendu.

Ce qu'il ne touche pas, faute de pouvoir le reproduire ici : les cellules
posees par les objets (`tree`, `rock`, `plant`, `building`) et par la collision
(`blocked`). Les Grounds reconvertis de `/tmp/reconv` n'existent plus dans ce
bac a sable, et `object_cells` a besoin de `Rooms.json` structure. Ces classes
sont donc PRESERVEES telles quelles, jamais recalculees a l'aveugle.

Les cartes derivees (`walkable`, `near_*`, `open_space`, `counts`) sont
recalculees, car elles dependent du terrain.

`snow` etant walkable comme `grass`, la marchabilite ne change pas ; ce qui
change, c'est la NATURE du sol, donc l'adequation d'habitat d'une espece.
"""
from __future__ import annotations

import argparse
import gzip
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

from build_biome_atlas import (  # noqa: E402
    GRID, NAMES, T_BLOCKED, T_GRASS, T_MARSH, T_OPEN, T_PLANT, T_SNOW, T_WATER,
    dist_map, render_classes,
)

WINTER_ROOMS = ("rm37", "rm58", "rm59", "rm67", "rm69")

# Classes issues du rendu : ce sont les seules que l'on a le droit de reecrire.
VISUAL_CLASSES = {T_OPEN, T_GRASS, T_WATER, T_MARSH, T_SNOW}
WALKABLE = (T_OPEN, T_GRASS, T_PLANT, T_MARSH, T_SNOW)
T_TREE, T_ROCK, T_CLIFF = 5, 6, 7


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--atlas", type=Path,
                        default=ROOT / "reports/fauna-ecology/biome-atlas.json.gz")
    parser.add_argument("--renders", type=Path, default=ROOT / "reports/room-renders")
    parser.add_argument("--out", type=Path,
                        default=ROOT / "reports/fauna-ecology/WINTER_ATLAS_REBUILD.json")
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()

    with gzip.open(args.atlas, "rt") as stream:
        atlas = json.load(stream)

    report = []
    for room in WINTER_ROOMS:
        data = atlas["rooms"][room]
        terrain = data["terrain"]
        before = dict(data["counts"])

        reclassified = render_classes(str(args.renders / f"{room}.png"))

        changed = 0
        for y in range(GRID):
            for x in range(GRID):
                # On ne reecrit que ce qui vient du rendu. Un arbre, un rocher
                # ou une cellule bloquee par la collision reste intact.
                if terrain[y][x] in VISUAL_CLASSES and reclassified[y][x] in VISUAL_CLASSES:
                    if terrain[y][x] != reclassified[y][x]:
                        terrain[y][x] = reclassified[y][x]
                        changed += 1

        data["walkable"] = [[1 if terrain[y][x] in WALKABLE else 0 for x in range(GRID)]
                            for y in range(GRID)]
        data["swimmable"] = [[1 if terrain[y][x] == T_WATER else 0 for x in range(GRID)]
                             for y in range(GRID)]
        data["near_tree"] = dist_map(lambda x, y: terrain[y][x] == T_TREE)
        data["near_water"] = dist_map(lambda x, y: terrain[y][x] in (T_WATER, T_MARSH))
        data["near_rock"] = dist_map(lambda x, y: terrain[y][x] in (T_ROCK, T_CLIFF))
        data["near_plant"] = dist_map(lambda x, y: terrain[y][x] == T_PLANT)

        def openness(x, y):
            return sum(1 for dy in (-1, 0, 1) for dx in (-1, 0, 1)
                       if 0 <= x + dx < GRID and 0 <= y + dy < GRID
                       and terrain[y + dy][x + dx] != T_BLOCKED)
        data["open_space"] = [[openness(x, y) for x in range(GRID)] for y in range(GRID)]

        counts = {}
        for y in range(GRID):
            for x in range(GRID):
                key = NAMES[terrain[y][x]]
                counts[key] = counts.get(key, 0) + 1
        data["counts"] = counts

        report.append({
            "room": room,
            "cells_reclassified": changed,
            "counts_before": before,
            "counts_after": counts,
            "grass_before": before.get("grass", 0),
            "grass_after": counts.get("grass", 0),
            "snow_before": before.get("snow", 0),
            "snow_after": counts.get("snow", 0),
        })
        print(f"  {room:6} {changed:>5} cellules  grass {before.get('grass',0):>5} -> "
              f"{counts.get('grass',0):<5}  snow {before.get('snow',0):>4} -> {counts.get('snow',0)}")

    summary = {
        "schema": "nnv-winter-atlas-rebuild-v1",
        "cause": "is_snow_rgb exigeait un blanc franc (200/205/210) et ratait le lavande "
                 "clair de la neige NNV (197,211,232) et (180,185,227)",
        "scope": "seules les cellules issues du rendu sont reecrites ; tree/rock/plant/"
                 "blocked sont preservees faute de pouvoir les recalculer ici",
        "applied": args.apply,
        "rooms": report,
        "total_cells_reclassified": sum(r["cells_reclassified"] for r in report),
        "promotion_allowed": False,
    }
    args.out.write_text(json.dumps(summary, indent=2, ensure_ascii=False, sort_keys=True) + "\n")

    if args.apply:
        with gzip.open(args.atlas, "wt") as stream:
            json.dump(atlas, stream)
        print(f"\n  atlas reecrit : {args.atlas}")
    else:
        print("\n  simulation ; utiliser --apply pour reecrire l'atlas")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
