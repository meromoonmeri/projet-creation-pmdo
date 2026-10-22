#!/usr/bin/env python3
"""Determine la saison NATIVE d'une room NNV, depuis la donnee seule.

Le defaut que cet outil repare
------------------------------
`convert_environment_room.py` ne se contente pas d'etiqueter la saison : il
SUBSTITUE le tileset de chaque couche selon la table de `season-vm-evidence.json`.
Convertir une room en `--season summer` remplace donc son tileset `ground` par
l'index 8 (herbe verte), quel que soit celui peint dans la source.

Consequence mesuree : les rooms d'hiver converties en `summer` sortaient avec un
sol VERT au lieu de la neige lavande. La source `rm58` est dominee par
(197,211,232) ; le converti l'etait par (105,182,91). Ce n'est pas un ecart de
teinte, c'est la mauvaise saison.

Methode
-------
Chaque couche `Tiles` de la room reference un `Background` par `$resourceRef`.
La table saisonniere associe, pour chaque saison, un index de tileset a chaque
nom de couche. On vote : pour chaque couche de la room, toute saison dont la
table donne exactement cet index pour cette couche gagne une voix.

La saison majoritaire est la saison native. Le vote est retourne en entier pour
que le desaccord soit visible plutot que masque.

Cas sans voix
-------------
Une room qui n'obtient AUCUNE voix (les grottes : `rmcave1`, `rmcave1_2`) n'a
aucune couche saisonniere. Elle est rendue `None` et non pas rangee d'office en
`summer` : pour elle la substitution ne s'applique a rien, le choix est neutre,
et le dire est plus honnete que de choisir en silence.
"""
from __future__ import annotations

import argparse
import gzip
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read_gzip(path: Path):
    with gzip.open(path, "rt", encoding="utf-8") as stream:
        return json.load(stream)


def resource_index(value):
    if isinstance(value, dict) and isinstance(value.get("$resourceRef"), dict):
        return value["$resourceRef"].get("index")
    return None


def build_reverse_table(season_vm: dict) -> dict:
    table: dict[tuple[str, int], set[str]] = {}
    for season, state in season_vm.items():
        for layer, index in state.get("tilesets", {}).items():
            table.setdefault((str(layer).casefold(), int(index)), set()).add(season)
    return table


def detect(room: dict, table: dict) -> dict:
    votes: dict[str, int] = {}
    layers = []
    for layer in room.get("Layers") or []:
        if (layer.get("LayerType") or {}).get("name") != "Tiles":
            continue
        data = layer.get("Data")
        if not isinstance(data, dict):
            continue
        index = resource_index(data.get("Background"))
        if index is None:
            continue
        name = str(layer.get("LayerName") or "").casefold()
        matched = sorted(table.get((name, index), ()))
        layers.append({"layer": name, "background_index": index, "seasons": matched})
        for season in matched:
            votes[season] = votes.get(season, 0) + 1

    ranked = sorted(votes.items(), key=lambda item: -item[1])
    native = ranked[0][0] if ranked else None
    unanimous = len(votes) == 1
    return {
        "native_season": native,
        "votes": votes,
        "unanimous": unanimous,
        "layers": layers,
        "note": ("aucune couche saisonniere : la substitution de tileset ne "
                 "s'applique a rien, le choix de saison est neutre"
                 if native is None else None),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--rooms", nargs="+", required=True)
    parser.add_argument("--extracted", type=Path, default=ROOT / "extracted/official")
    parser.add_argument("--season-vm", type=Path, default=ROOT / "reports/season-vm-evidence.json")
    parser.add_argument("--json", type=Path)
    args = parser.parse_args()

    rooms = {room["Name"]: room for room in read_gzip(args.extracted / "inventory/Rooms.json.gz")}
    table = build_reverse_table(json.loads(args.season_vm.read_text())["seasons"])

    results = {}
    for name in args.rooms:
        if name not in rooms:
            raise SystemExit(f"room inconnue : {name}")
        results[name] = detect(rooms[name], table)
        entry = results[name]
        print(f"{name:11} {entry['native_season'] or 'NEUTRE':7} "
              f"votes={entry['votes']} unanime={entry['unanimous']}")

    payload = {
        "schema": "new-era.nnv-native-season.v1",
        "method": "vote par couche : index de Background compare a la table saisonniere du VM",
        "source": str(args.season_vm.name),
        "rooms": results,
    }
    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(json.dumps(payload, indent=2, ensure_ascii=False, sort_keys=True) + "\n",
                             encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
