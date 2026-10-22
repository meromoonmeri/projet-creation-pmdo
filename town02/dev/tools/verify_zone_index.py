#!/usr/bin/env python3
"""Vérifie la cohérence des résumés de zones dont les segments sont actifs.

Le moteur valide les destinations de donjon contre Data/Zone/index.idx avant de
lire le JSON complet (ZoneEntrySummary.SegLocValid). Après une modification de
segmentation, un index ancien peut donc produire « Invalid Segment ID » ou
laisser une transition sous un écran noir.

Le vérificateur cible par défaut les quatre zones d'histoire dont la segmentation
ou les GroundMaps ont évolué dans les derniers lots :
`vast_steppe`, `searing_tunnel`, `mount_windswept`, `gloomy_forest`.
`--all` permet une inspection exploratoire des autres zones, mais les anciennes
zones à segments réservés ou à SingularSegment négatif sont signalées comme
non comparables plutôt que transformées en faux positifs.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

TARGET_ZONES = (
    "vast_steppe",
    "searing_tunnel",
    "mount_windswept",
    "gloomy_forest",
)


def load(path: Path):
    with path.open(encoding="utf-8-sig") as fh:
        return json.load(fh)


def segment_ids(segment: dict) -> list[int] | None:
    kind = segment.get("$type", "")
    if "RangeDictSegment" in kind:
        result: list[int] = []
        floors = segment.get("Floors") or {}
        for node in floors.get("nodes", []):
            value = node.get("Range") or {}
            result.extend(range(int(value["Min"]), int(value["Max"])))
        return result
    if "LayeredSegment" in kind:
        return list(range(len(segment.get("Floors") or [])))
    if "DictionarySegment" in kind:
        floors = segment.get("Floors") or {}
        return sorted(int(key) for key in floors if str(key).lstrip("-").isdigit())
    if "SingularSegment" in kind:
        span = segment.get("FloorSpan")
        if span is None or int(span) < 0:
            return None
        return list(range(int(span)))
    return None


def expected_summary(zone: dict):
    maps = []
    counted = 0
    for segment in zone.get("Segments", []):
        ids = segment_ids(segment)
        if ids is None:
            return None, None
        maps.append(ids)
        if segment.get("IsRelevant", False):
            counted += len(ids)
    return maps, counted


def inspect(root: Path, names: list[str]) -> int:
    idx_path = root / "Data/Zone/index.idx"
    idx = load(idx_path)["Object"]
    failures = 0

    for name in names:
        zone_path = root / "Data/Zone" / f"{name}.json"
        if not zone_path.exists():
            print(f"FAIL {name}: fichier JSON absent")
            failures += 1
            continue
        zone = load(zone_path)["Object"]
        summary = idx.get(name)
        if summary is None:
            print(f"FAIL {name}: entrée absente de index.idx")
            failures += 1
            continue
        maps, counted = expected_summary(zone)
        if maps is None:
            print(f"WARN {name}: type de segment non comparable")
            continue

        problems = []
        if summary.get("Grounds") != zone.get("GroundMaps", []):
            problems.append("Grounds")
        if summary.get("Maps") != maps:
            problems.append("Maps")
        if summary.get("CountedFloors") != counted:
            problems.append("CountedFloors")

        if problems:
            print(f"FAIL {name}: {', '.join(problems)}")
            print(f"  JSON : segments={len(zone.get('Segments', []))} maps={maps} counted={counted}")
            print(f"  IDX  : maps={summary.get('Maps')} counted={summary.get('CountedFloors')} grounds={summary.get('Grounds')}")
            failures += 1
        else:
            print(f"OK   {name}: {len(maps)} segments, {counted} floors, Grounds synchronisés")

    if failures:
        print(f"RESULTAT : {failures} incohérence(s)")
    else:
        print("RESULTAT : index des zones ciblées cohérent")
    return 1 if failures else 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", nargs="?", default=".")
    parser.add_argument("--all", action="store_true", help="inspecter aussi les autres zones comparables")
    args = parser.parse_args()
    root = Path(args.root).resolve()

    names = list(TARGET_ZONES)
    if args.all:
        names = sorted({p.stem for p in (root / "Data/Zone").glob("*.json")})
    return inspect(root, names)


if __name__ == "__main__":
    sys.exit(main())
