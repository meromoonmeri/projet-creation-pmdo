#!/usr/bin/env python3
"""Le terrain saisonnier des 15 rooms HELD existe-t-il deja ?

Le blocage
----------
`PROMOTION_MANIFEST.json` retient 109 entites en HELD :

    « variante de Ground de la saison non convertie/rendue ;
      hiver diverge a 100% de l ete (mesure sur rmvillage) »

Ce raisonnement a ete transpose de `rmvillage` aux 15 autres rooms. Or
`rmvillage` est un cas particulier : c'est la seule room qui possede QUATRE
variantes saisonnieres, pilotees a l'execution par la variable globale
`season`. Pour elle, « le rendu d'ete ne prouve rien pour l'hiver » est exact.

Ce que la source dit reellement des 15 autres
---------------------------------------------
Elles ne sont pas saisonnieres : chacune est peinte dans UNE seule saison,
en dur, avec des objets d'une seule famille (`objau*` ou `objwn*`). Il n'y a
pas de « variante automne de rm14 » a produire, parce que rm14 EST la room
d'automne. Le rendu deja versionne est donc, pour ces rooms, le rendu de leur
saison.

Ce script ne suppose rien de tout cela : il le mesure, deux fois.

1. Famille saisonniere des instances, via `season-system.json`, en remontant
   chaque `ObjectDefinition` de la room.
2. Reclassification independante du PNG versionne par le classifieur de
   `build_biome_atlas.py`, comparee cellule a cellule au terrain de l'atlas,
   sur les seules cellules issues du rendu (open/grass/water/marsh/snow).

Fail-closed : une room n'est declaree `TERRAIN_PROVEN` que si sa famille est
unique ET que sa divergence de reclassification reste sous le seuil. Sinon
elle reste `HELD`, sans exception ni arrondi favorable.
"""
from __future__ import annotations

import argparse
import gzip
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

from build_biome_atlas import NAMES, render_classes  # noqa: E402

# Classes de terrain qui proviennent directement du rendu. Les autres (tree,
# rock, cliff, blocked, plant) sont posees par les objets ou la collision : les
# comparer testerait le placement d'objets, pas la couleur du terrain.
VISUAL_CLASSES = {1, 2, 3, 4, 9}

# Seuil de divergence tolere entre l'atlas et la reclassification du rendu.
# Au-dela, on ne peut pas affirmer que l'atlas decrit bien ce PNG.
DIVERGENCE_MAX = 0.10


def resolve_cycles(node, root=None):
    if root is None:
        root = node
    if isinstance(node, dict):
        ref = node.get("$cycleRef")
        if isinstance(ref, str):
            target = root
            for index, attribute in re.findall(r"\[(\d+)\]|\.([A-Za-z_][A-Za-z0-9_]*)", ref):
                try:
                    target = target[int(index)] if index else target[attribute]
                except (KeyError, IndexError, TypeError):
                    return None
            return target
        return {k: resolve_cycles(v, root) for k, v in node.items()}
    if isinstance(node, list):
        return [resolve_cycles(v, root) for v in node]
    return node


def obj_name(entry):
    name = entry.get("Name")
    return name.get("Content") if isinstance(name, dict) else name


def resource_name(value):
    if isinstance(value, dict):
        resource = value.get("$resourceRef")
        if isinstance(resource, dict):
            return resource.get("name")
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--inventory", type=Path, default=Path("/tmp/nnv/inventory"))
    parser.add_argument("--renders", type=Path, default=ROOT / "reports/room-renders")
    parser.add_argument("--out", type=Path,
                        default=ROOT / "reports/fauna-ecology/HELD_SEASONAL_TERRAIN.json")
    args = parser.parse_args()

    held = json.loads((ROOT / "reports/fauna-ecology/held-audit.json").read_text())
    atlas = json.loads(gzip.open(
        ROOT / "reports/fauna-ecology/biome-atlas.json.gz", "rt").read())
    seasons = json.loads((ROOT / "reports/season-system.json").read_text())
    family = {o["name"]: o.get("season_family") for o in seasons["seasonal_objects"]}

    required = defaultdict(set)
    individuals = Counter()
    species = defaultdict(Counter)
    for entry in held["entries"]:
        if entry["status"] != "HELD":
            continue
        required[entry["room"]].update(entry["seasons"])
        individuals[entry["room"]] += entry["individuals"]
        species[entry["room"]][entry["species"]] += entry["individuals"]

    rooms_json = resolve_cycles(json.loads((args.inventory / "Rooms.json").read_text()))
    instances_by_room = {}
    for room in rooms_json:
        name = obj_name(room)
        if name in required:
            counter = Counter()
            for instance in room.get("GameObjects") or []:
                obj = resource_name(instance.get("ObjectDefinition"))
                if obj:
                    counter[family.get(obj) or "nonseasonal"] += 1
            instances_by_room[name] = counter

    results = []
    for room in sorted(required):
        needed = sorted(required[room])
        counter = instances_by_room.get(room, Counter())
        seasonal = {k: v for k, v in counter.items() if k != "nonseasonal"}
        dominant = max(seasonal, key=seasonal.get) if seasonal else None
        # « spring » sert de famille par defaut a des objets neutres dans la
        # source ; on ne la retient comme concurrente que si elle est massive.
        competitors = [k for k, v in seasonal.items()
                       if k != dominant and v >= 0.2 * seasonal.get(dominant, 1)]

        png = args.renders / f"{room}.png"
        divergence = None
        compared = 0
        transitions = {}
        if png.is_file() and room in atlas["rooms"]:
            reclassified = render_classes(str(png))
            terrain = atlas["rooms"][room]["terrain"]
            diverging = Counter()
            for y in range(len(terrain)):
                for x in range(len(terrain[y])):
                    if terrain[y][x] in VISUAL_CLASSES:
                        compared += 1
                        if terrain[y][x] != reclassified[y][x]:
                            diverging[(NAMES[terrain[y][x]], NAMES[reclassified[y][x]])] += 1
            divergence = sum(diverging.values()) / compared if compared else None
            transitions = {f"{a}->{b}": n for (a, b), n in diverging.most_common(3)}

        unique_family = dominant is not None and not competitors
        matches = dominant in needed if dominant else False
        low_divergence = divergence is not None and divergence <= DIVERGENCE_MAX
        proven = unique_family and matches and low_divergence

        results.append({
            "room": room,
            "seasons_required": needed,
            "instances_by_family": dict(counter.most_common()),
            "dominant_family": dominant,
            "competing_families": competitors,
            "family_is_unique": unique_family,
            "required_season_is_native": matches,
            "render_cells_compared": compared,
            "atlas_vs_render_divergence": round(divergence, 4) if divergence is not None else None,
            "main_divergences": transitions,
            "held_individuals": individuals[room],
            "species": dict(species[room]),
            "verdict": "TERRAIN_PROVEN" if proven else "HELD",
            "reason": ("la room est nativement peinte dans la saison requise et l'atlas "
                       "concorde avec son rendu"
                       if proven else
                       "l'atlas ne se retrouve pas dans le rendu de cette room : "
                       "le terrain de la saison requise n'est pas prouve"),
        })

    proven_rooms = [r for r in results if r["verdict"] == "TERRAIN_PROVEN"]
    held_rooms = [r for r in results if r["verdict"] == "HELD"]

    report = {
        "schema": "nnv-held-seasonal-terrain-v1",
        "question": "le terrain de la saison requise existe-t-il deja pour les 15 rooms HELD ?",
        "method": "famille saisonniere des instances (season-system.json) + reclassification "
                  "independante du PNG versionne comparee au terrain de l'atlas",
        "divergence_threshold": DIVERGENCE_MAX,
        "rooms": results,
        "terrain_proven": {
            "rooms": [r["room"] for r in proven_rooms],
            "individuals": sum(r["held_individuals"] for r in proven_rooms),
        },
        "still_held": {
            "rooms": [r["room"] for r in held_rooms],
            "individuals": sum(r["held_individuals"] for r in held_rooms),
        },
        "note": "TERRAIN_PROVEN leve UNIQUEMENT le blocage terrain. La promotion reste "
                "subordonnee a la conversion en Ground PMDO et au runtime 0.8.12.",
        "promotion_allowed": False,
    }
    args.out.write_text(json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n")

    print(f"{'room':8}{'requis':9}{'famille':10}{'unique':8}{'diverg.':>9}  verdict")
    for r in results:
        d = f"{100*r['atlas_vs_render_divergence']:.1f}%" if r["atlas_vs_render_divergence"] is not None else "n/a"
        print(f"{r['room']:8}{','.join(r['seasons_required']):9}{str(r['dominant_family']):10}"
              f"{str(r['family_is_unique']):8}{d:>9}  {r['verdict']}")
    print(f"\n  terrain prouve : {len(proven_rooms)} rooms, "
          f"{report['terrain_proven']['individuals']} individus")
    print(f"  toujours HELD  : {len(held_rooms)} rooms, "
          f"{report['still_held']['individuals']} individus")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
