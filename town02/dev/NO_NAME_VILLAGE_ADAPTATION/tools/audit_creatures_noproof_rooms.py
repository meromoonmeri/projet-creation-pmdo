#!/usr/bin/env python3
"""Audit des creatures des 11 rooms NO_PROOF, meme methode que les 34 rooms promues.

Regle NNV/PMDO absolue : aucun humain, aucune creature non-Pokemon dans le
resultat final. Tout etre vivant devient un Pokemon.

Methode, identique a `AUDIT_CREATURES_SOURCE.json` et volontairement immunisee
aux noms : une creature est un objet GameMaker descendant de `objbgmob` (faune
d'ambiance) ou `objmob` (monstres). La hierarchie est remontee via
`GameObjects[i]["ParentId"]`, jamais devinee.

Le nom trompe, et cela a deja ete verifie sur ce projet : `objauplant30` et
`objsmplant93` contiennent « ant » mais sont des plantes ; `objbf09` a pour
parent `objbf0noncol`, un buisson ; `objwf0` descend de `objwfs0`, une fleur
d'eau. Ces faux positifs sont ici re-testes, pas supposes.

Sortie fail-closed : tout objet creature sans Pokemon assigne est liste dans
`sans_pokemon`, et le script sort en erreur. Aucun casting n'est invente.
"""
from __future__ import annotations

import argparse
import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

CREATURE_ROOTS = ("objbgmob", "objmob")
NOPROOF_ROOMS = ("rm38", "rm47", "rm48", "rm49", "rm57", "rm68", "rm77",
                 "rmcave1", "rmcave1_0", "rmcave1_1", "rmcave1_2")

# Indices de nom, utilises UNIQUEMENT pour lever des suspects a verifier par
# hierarchie ; jamais pour classer.
ANIMAL_HINTS = ("bird", "bug", "fly", "frog", "fish", "mob", "cat", "dog", "rat",
                "bee", "ant", "worm", "snake", "moth", "crab", "deer", "wolf",
                "butterfly", "beetle", "spider", "mouse", "owl", "duck")


def load(inventory: Path, name: str):
    return json.loads((inventory / f"{name}.json").read_text())


def resolve_cycles(node, root=None, path=None):
    """Les JSON UndertaleModTool remplacent tout objet deja serialise par
    {"$cycleRef": "$[27].Layers[5].Data"}. Sans resolution, une couche sur deux
    parait vide."""
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


def object_name(entry) -> str:
    name = entry.get("Name")
    if isinstance(name, dict):
        return name.get("Content") or ""
    return name or ""


def build_hierarchy(objects) -> tuple[dict, dict]:
    names = {index: object_name(entry) for index, entry in enumerate(objects)}
    parents = {}
    for index, entry in enumerate(objects):
        parent = entry.get("ParentId")
        parent_index = None
        if isinstance(parent, dict):
            resource = parent.get("$resourceRef")
            if isinstance(resource, dict):
                parent_index = resource.get("index")
        elif isinstance(parent, int) and parent >= 0:
            parent_index = parent
        parents[index] = parent_index
    return names, parents


def ancestry(index, names, parents) -> list[str]:
    chain, seen = [], set()
    current = parents.get(index)
    while current is not None and current not in seen:
        seen.add(current)
        chain.append(names.get(current, ""))
        current = parents.get(current)
    return chain


def resource_name(value) -> str | None:
    if isinstance(value, dict):
        resource = value.get("$resourceRef")
        if isinstance(resource, dict):
            return resource.get("name")
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--inventory", type=Path, default=Path("/tmp/nnv/inventory"))
    parser.add_argument("--out", type=Path,
                        default=ROOT / "reports/noproof-rooms/AUDIT_CREATURES_NOPROOF.json")
    args = parser.parse_args()

    objects = load(args.inventory, "GameObjects")
    rooms = resolve_cycles(load(args.inventory, "Rooms"))
    names, parents = build_hierarchy(objects)

    creatures = {
        names[index] for index in range(len(objects))
        if names[index] and set(ancestry(index, names, parents)) & set(CREATURE_ROOTS)
    }

    casting_source = json.loads(
        (ROOT / "reports/fauna-ecology/AUDIT_CREATURES_SOURCE.json").read_text())
    casting = {obj: data["pokemon"]
               for obj, data in casting_source["objets_creature_dans_les_34_rooms"].items()}
    species_config = json.loads((ROOT / "config/fauna-species.json").read_text())
    for species_name, species in species_config["species"].items():
        for source in species.get("source_objects", []):
            casting.setdefault(source, species_name)

    per_room, counts, suspects = {}, Counter(), {}
    for room in rooms:
        room_name = object_name(room)
        if room_name not in NOPROOF_ROOMS:
            continue
        found = Counter()
        for instance in room.get("GameObjects") or []:
            obj = resource_name(instance.get("ObjectDefinition"))
            if not obj:
                continue
            if obj in creatures:
                found[obj] += 1
                counts[obj] += 1
            elif any(hint in obj.lower() for hint in ANIMAL_HINTS):
                chain = None
                for index in range(len(objects)):
                    if names[index] == obj:
                        chain = ancestry(index, names, parents)
                        break
                suspects[obj] = {
                    "hierarchie": chain,
                    "verdict": "NON_CREATURE",
                    "preuve": "aucun ancetre objbgmob/objmob",
                }
        per_room[room_name] = dict(found.most_common())

    coverage, missing = {}, []
    for obj, total in counts.most_common():
        pokemon = casting.get(obj)
        coverage[obj] = {
            "instances": total,
            "pokemon": pokemon,
            "rooms": sum(1 for r in per_room.values() if obj in r),
        }
        if not pokemon:
            missing.append(obj)

    report = {
        "schema": "nnv-audit-creatures-noproof-v1",
        "note": "creatures identifiees par la hierarchie GameMaker (descendants de "
                "objbgmob ou objmob), jamais par leur nom",
        "creature_roots": list(CREATURE_ROOTS),
        "rooms_auditees": list(NOPROOF_ROOMS),
        "objets_creature_par_room": per_room,
        "couverture": coverage,
        "total_creatures": sum(counts.values()),
        "objets_distincts": len(counts),
        "sans_pokemon": missing,
        "suspects_de_nom_verifies_non_creatures": suspects,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n")

    print(f"  rooms auditees        : {len(per_room)}")
    print(f"  creatures instanciees : {report['total_creatures']}")
    print(f"  objets distincts      : {report['objets_distincts']}")
    for obj, data in coverage.items():
        print(f"    {obj:20} {data['instances']:>5} -> {data['pokemon'] or 'AUCUN'}")
    print(f"  suspects de nom ecartes sur preuve : {len(suspects)}")
    if missing:
        print(f"  SANS POKEMON : {missing}")
        raise SystemExit("ECHEC: des creatures n'ont aucun Pokemon assigne")
    print("  0 creature sans Pokemon")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
