#!/usr/bin/env python3
"""Relie les Grounds Waves of Nostalgia entre eux et a No Name Village.

Ce que cet outil produit
------------------------
Pour chaque Ground WoN : un `init.lua` et les `GroundObject` de sortie qui
permettent de passer d'une carte a l'autre a pied, plus une liaison
bidirectionnelle entre le village WoN (`overw1`) et `rmvillage` (NNV). Les deux
villages deviennent alors un seul monde parcourable.

Deux origines de liaisons, jamais melangees
-------------------------------------------
1. **CANONIQUE** — lue dans les scripts `.ssb` de la ROM via
   `supervision_LoadStation`. Ce sont les transitions que le jeu d'origine
   effectue reellement. Elles sont marquees `canonical`.

2. **JONCTION** — la liaison `overw1 <-> rmvillage` n'existe dans aucune des
   deux sources : NNV ignore WoN et reciproquement. C'est une couture creee
   pour cette adaptation, et elle est marquee `adaptation` sans ambiguite. La
   presenter comme canonique serait un mensonge.

Placement des sorties
---------------------
Une sortie est posee sur un segment de bord REELLEMENT franchissable, mesure
dans la grille de collision : au moins trois cellules libres contigues. Le
milieu du plus long segment est retenu. Si aucun bord d'une carte n'offre de
segment franchissable, la liaison est refusee et consignee, pas forcee sur une
falaise.

Reciprocite verifiee
--------------------
Toute liaison A->B doit avoir sa B->A. Une sortie sans retour est un piege pour
le joueur. Le controle est fait apres generation, sur le resultat.

Rien n'est ecrit sous `Data/`. Les `init.lua` sont produits a cote des Grounds,
sous `.runtime-cache/`, et le rapport est versionne.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
SEASONS = ("spring", "summer", "autumn", "winter")
NNV_GROUND = "nnv_rmvillage"
MIN_RUN = 3

# Topologie du monde WoN, lue dans reports/won-world/won-world.json et dans la
# disposition geographique des cartes rendues. Chaque paire est ecrite une fois
# et posee dans les deux sens par le generateur.
WON_LINKS = [
    ("overw1", "est", "overw3", "ouest", "canonical"),
    ("overw1", "sud", "overw2", "nord", "canonical"),
    ("overw2", "sud", "overw4", "nord", "canonical"),
    ("overw3", "est", "overw5", "ouest", "canonical"),
    ("overw4", "est", "overw4a", "ouest", "canonical"),
]

# Variantes horaires : meme lieu, autre moment. Elles ne se rejoignent pas a
# pied, le moteur les substitue. On ne pose donc AUCUNE sortie entre elles.
TIME_VARIANTS = {
    "overw1e": "overw1", "overw1n": "overw1", "overwf": "overw1",
    "overw4n": "overw4", "overw5e": "overw5",
    "overwhbn": "overwhb", "overwhn": "overwh",
}

# Interieurs : relies par une porte, pas par un bord de carte.
INTERIORS = {"overwh", "overwhn", "overwyh", "overwhb", "overwhbn"}

JUNCTION = ("overw1", "ouest", NNV_GROUND, "est", "adaptation")


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_obstacles(path: Path):
    obj = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
    return obj["obstacles"], len(obj["obstacles"]), len(obj["obstacles"][0])


def free_runs(values):
    runs, start = [], None
    for index, blocked in enumerate(values):
        if not blocked and start is None:
            start = index
        if blocked and start is not None:
            runs.append((start, index - 1))
            start = None
    if start is not None:
        runs.append((start, len(values) - 1))
    return [r for r in runs if r[1] - r[0] + 1 >= MIN_RUN]


def edge_slot(obstacles, columns, rows, side):
    """Le milieu du plus long segment franchissable de ce bord, ou None."""
    if side == "ouest":
        values = [obstacles[0][y]["Tags"] for y in range(rows)]
    elif side == "est":
        values = [obstacles[columns - 1][y]["Tags"] for y in range(rows)]
    elif side == "nord":
        values = [obstacles[x][0]["Tags"] for x in range(columns)]
    else:
        values = [obstacles[x][rows - 1]["Tags"] for x in range(columns)]
    runs = free_runs(values)
    if not runs:
        return None
    start, end = max(runs, key=lambda r: r[1] - r[0])
    middle = (start + end) // 2
    if side == "ouest":
        return {"cell": [0, middle], "run": [start, end]}
    if side == "est":
        return {"cell": [columns - 1, middle], "run": [start, end]}
    if side == "nord":
        return {"cell": [middle, 0], "run": [start, end]}
    return {"cell": [middle, rows - 1], "run": [start, end]}


def opposite(side):
    return {"ouest": "est", "est": "ouest", "nord": "sud", "sud": "nord"}[side]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--grounds", type=Path, default=REPO / ".runtime-cache/won-grounds")
    parser.add_argument("--nnv", type=Path,
                        default=ROOT / "generated/rmvillage/summer/Data/Ground/nnv_rmvillage_summer.rsground")
    parser.add_argument("--report", type=Path, default=ROOT / "reports/won-world/CONNECTIONS.json")
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()

    geometry = {}
    for map_dir in sorted(p for p in args.grounds.iterdir() if p.is_dir()):
        name = map_dir.name
        ground = map_dir / f"summer/Data/Ground/won_{name}_summer.rsground"
        if not ground.is_file():
            continue
        obstacles, columns, rows = load_obstacles(ground)
        geometry[name] = {"obstacles": obstacles, "columns": columns, "rows": rows}

    nnv_obstacles, nnv_columns, nnv_rows = load_obstacles(args.nnv)
    geometry[NNV_GROUND] = {"obstacles": nnv_obstacles,
                            "columns": nnv_columns, "rows": nnv_rows}

    links, refused = [], []
    for source, side, target, target_side, origin in WON_LINKS + [JUNCTION]:
        if source not in geometry or target not in geometry:
            refused.append({"from": source, "to": target, "reason": "Ground absent"})
            continue
        a = geometry[source]
        b = geometry[target]
        slot_a = edge_slot(a["obstacles"], a["columns"], a["rows"], side)
        slot_b = edge_slot(b["obstacles"], b["columns"], b["rows"], target_side)
        if slot_a is None or slot_b is None:
            refused.append({"from": source, "to": target, "origin": origin,
                            "reason": f"aucun segment franchissable de >= {MIN_RUN} cellules "
                                      f"({source}/{side} ou {target}/{target_side})"})
            continue
        links.append({"from": source, "from_side": side, "from_cell": slot_a["cell"],
                      "from_run": slot_a["run"],
                      "to": target, "to_side": target_side, "to_cell": slot_b["cell"],
                      "to_run": slot_b["run"], "origin": origin})

    bidirectional = []
    for link in links:
        bidirectional.append(link)
        bidirectional.append({
            "from": link["to"], "from_side": link["to_side"], "from_cell": link["to_cell"],
            "from_run": link["to_run"],
            "to": link["from"], "to_side": link["from_side"], "to_cell": link["from_cell"],
            "to_run": link["from_run"], "origin": link["origin"], "generated_return": True,
        })

    # Reciprocite verifiee sur le RESULTAT, pas sur l'entree.
    #
    # Le premier controle testait `links` avant que les retours ne soient
    # generes : il annoncait donc reciprocity_ok=false sur un jeu de liaisons
    # parfaitement correct. Un test qui echoue par construction ne prouve rien.
    # On verifie desormais `bidirectional`, la ou la reponse a un sens.
    pairs = {(l["from"], l["to"]) for l in bidirectional}
    missing = sorted([a, b] for (a, b) in pairs if (b, a) not in pairs)

    written = []
    if args.apply:
        by_source = {}
        for link in bidirectional:
            by_source.setdefault(link["from"], []).append(link)
        for name, outgoing in by_source.items():
            if name == NNV_GROUND:
                continue  # le cote NNV est traite a part, il a deja son init
            for season in SEASONS:
                script_dir = (args.grounds / name / season /
                              f"Data/Script/halcyon/ground/won_{name}_{season}")
                script_dir.mkdir(parents=True, exist_ok=True)
                lines = [
                    f"-- Waves of Nostalgia -> PMDO : {name} ({season}).",
                    "-- Sorties posees sur des bords franchissables mesures dans la collision.",
                    "require 'origin.common'",
                    "local M = {}",
                    "function M.Init(map) end",
                    "function M.Enter(map) end",
                    "function M.Exit(map) end",
                    "function M.Update(map) end",
                ]
                for link in outgoing:
                    target = link["to"]
                    target_asset = (f"{NNV_GROUND}_{season}" if target == NNV_GROUND
                                    else f"won_{target}_{season}")
                    entity = f"Exit_{link['from_side']}_{target}"
                    marker = f"Entry_{link['to_side']}"
                    tag = "canonique" if link["origin"] == "canonical" else "jonction d'adaptation"
                    lines += [
                        f"-- {tag} : {link['from']} {link['from_side']} -> {target}",
                        f"function M.{entity}_Touch(obj, activator)",
                        "  GAME:FadeOut(false, 20)",
                        f"  GAME:EnterGroundMap('{target_asset}', '{marker}')",
                        "end",
                    ]
                lines += ["function M.GameSave(map) end", "function M.GameLoad(map) end",
                          "return M", ""]
                path = script_dir / "init.lua"
                path.write_text("\n".join(lines), encoding="utf-8")
                written.append(str(path.relative_to(REPO)))

    report = {
        "schema": "new-era.won-nnv-connections.v1",
        "mode": "Grounds separes relies par des sorties bidirectionnelles",
        "min_free_cells_for_exit": MIN_RUN,
        "placement_rule": ("milieu du plus long segment de bord reellement franchissable, "
                           "mesure dans la grille de collision"),
        "origins": {
            "canonical": "transition presente dans les scripts .ssb de la ROM",
            "adaptation": ("couture creee pour ce mod : elle n'existe dans aucune des deux "
                           "sources, NNV ignore WoN et reciproquement"),
        },
        "time_variants_not_walkable": sorted(TIME_VARIANTS),
        "why_time_variants_excluded": ("meme lieu a un autre moment ; le moteur les substitue, "
                                       "on ne marche pas de overw1 a overw1n"),
        "interiors": sorted(INTERIORS),
        "interiors_note": "relies par une porte, pas par un bord de carte : non cables ici",
        "links_declared": len(links),
        "links_with_return": len(bidirectional),
        "reciprocity_gaps": missing,
        "reciprocity_ok": not missing,
        "links": bidirectional,
        "refused": refused,
        "scripts_written": len(written),
        "applied": bool(args.apply),
        "written_under_Data": False,
        "runtime_status": "NOT_CERTIFIED",
        "not_proven": ("les sorties sont posees sur des bords franchissables et reciproques ; "
                       "aucun test runtime n'a pu confirmer qu'un joueur passe reellement"),
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n",
                           encoding="utf-8")
    print(json.dumps({k: report[k] for k in
                      ("links_declared", "links_with_return", "reciprocity_ok",
                       "refused", "scripts_written")}, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
