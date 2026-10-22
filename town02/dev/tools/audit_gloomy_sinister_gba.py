#!/usr/bin/env python3
"""Targeted PMD Red Sinister Woods gate; read-only and provenance aware."""
from __future__ import annotations
import json
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = Path(os.environ.get("PMD_RED_SOURCE", "/home/user/pmd-red")) / "data/dungeon/SinisterWoods/pokemon_found.json"


def source_tables():
    exception = {"MR_MIME": "mr_mime", "FARFETCHD": "farfetchd", "NIDORAN_F": "nidoran_f", "NIDORAN_M": "nidoran_m"}
    result = []
    for table in json.loads(SOURCE.read_text())["tables"]:
        rows = []
        for pokemon in table["pokemon"]:
            species = pokemon["species"].replace("MONSTER_", "")
            if pokemon["probability"] > 0 and species not in ("KECLEON", "DECOY"):
                rows.append((exception.get(species, species.lower()), pokemon["level"], pokemon["probability"]))
        result.append(rows)
    return result[:8] + [result[7]] + result[8:]


def actual_tables(zone, segment, count):
    spawn = next(row for row in zone["Segments"][segment]["ZoneSteps"] if "TeamSpawnZoneStep" in row["$type"])
    result = []
    for floor in range(count):
        rows = []
        for item in spawn["Spawns"]:
            if item["Range"] == {"Min": floor, "Max": floor + 1}:
                mob = item["Spawn"]["Spawn"]
                rows.append((mob["BaseForm"]["Species"], mob["Level"]["Min"], item["Rate"]))
        result.append(rows)
    return result


def main():
    source = source_tables()
    zone = json.loads((ROOT / "Data/Zone/gloomy_forest.json").read_text(encoding="utf-8-sig"))["Object"]
    actual = actual_tables(zone, 0, 15) + actual_tables(zone, 1, 5) + actual_tables(zone, 3, 3)
    expected = [source[index % 13] for index in range(23)]
    payload = json.dumps(zone)
    music = all("Sinister Woods.ogg" in json.dumps(zone["Segments"][index]) for index in (0, 1, 3))
    checks = {
        "23_floor_spawn_tables": len(actual) == 23,
        "species_level_probability_exact": actual == expected,
        "canonical_sinister_woods_music": music,
        "no_relic_forest_dependency": (
            "relic_forest_blob_" not in payload
            and "ReverseRelicForest" not in payload
        ),
        "no_treeshroud_graphics_substitution": "treeshroud_forest_1_" not in payload,
        "unique_b41_graphics_namespace_complete": all(
            token in payload
            for token in (
                "sinister_woods_b41_floor",
                "sinister_woods_b41_wall",
                "sinister_woods_b41_secondary",
            )
        ),
    }
    blockers = [name for name, passed in checks.items() if not passed]
    result = {
        "source": "pret/pmd-red data/dungeon/SinisterWoods at locked technical commit",
        "provenance": {
            "floors_1_13": "PMD_RED_EU_CANON",
            "floors_14_23": "NEW_ERA_ADAPTATION_REPEAT_OF_CANONICAL_TABLE_CYCLE",
            "grounds_d04p01_d04p02": "PMD_RED_EU_CANON",
            "team_dazzling_recast": "NEW_ERA_ADAPTATION",
        },
        "gba_table_count": 13,
        "pmdo_floor_count": 23,
        "checks": checks,
        "blockers": blockers,
        "result": "SINISTER_WOODS_CANONICAL_GATE_PASS" if not blockers else "SINISTER_WOODS_CANONICAL_GATE_BLOCKED",
        "runtime": "NOT_RUN_BY_THIS_STATIC_GATE",
        "production_route_written": False,
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if not blockers else 1


if __name__ == "__main__":
    raise SystemExit(main())
