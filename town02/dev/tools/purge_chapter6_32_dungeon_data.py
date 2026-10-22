#!/usr/bin/env python3
"""Remove the current New Era dungeon data slated for chapter-6+ remigration.

This is a destructive, explicitly allow-listed migration tool.  It removes
only active ZoneData and static dungeon maps/grounds for the chapter 6-10
substitutes currently present in this repository.  Narrative Lua scripts are
kept so New Era's story can be reattached to the canonical PMD Red locations.

Hard safety boundaries:

* never touches RESERVE or external archive-backed sources;
* never touches the 27 protected FugitiveArc grounds/routes;
* never touches D04P01/D04P02-named archive assets or relic_forest_blob_*;
* never guesses ownership: a static map/ground shared with a kept zone is kept;
* --dry-run is the default; --apply is required for deletion.
"""
from __future__ import annotations
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---

import argparse
import copy
import json
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
# Explicitly existing chapter-6+ New Era dungeon substitutes/old routes.  The
# later chapter-11..32 main zones listed in planning docs are not present as
# Data/Zone files, so they produce no deletion here.
PURGE_ZONES = {
    "gloomy_forest": 6,
    "magma_cavern": 7,
    "waterfall_pond": 8,
    "poisonous_forest": 9,
    "sky_tower": 10,
    "crevasse_geode": 6,
    "desert_oublies": 6,
    "jardin_energie": 7,
    "toundra_desolee": 8,
    "bassin_tari": 9,
    "marais_errants": 9,
    "col_foudre": 10,
    "falaises_envol": 10,
    "sentier_enneige": 10,
}
# These Grounds are the protected FugitiveArc staging route.  Read them from
# the source Lua as an extra guard and keep this minimum explicit list in case
# a source formatting change prevents extraction.
FUGITIVE_GROUNDS_FALLBACK = {
    "a02p01", "a02p02", "a02p03", "a02p04", "grotte_lazuli_seuil",
    "grotte_lazuli_fond", "mont_cendre_pied", "d09p02", "d09p03",
    "a03p01", "a03p02", "a03p03", "foret_givree_oree", "d10p02",
    "d10p03", "mont_gele_pied", "d11p02", "d11p03", "gorge_ardente_porte",
    "gorge_ardente_coeur", "fosse_ardente", "arc_parvis_celeste",
    "arc_palier_celeste", "arc_tour_ciel_sommet", "t01p01", "a04p01", "a05p03",
}
PROTECTED_GROUND_NAMES = FUGITIVE_GROUNDS_FALLBACK | {
    "d04p01", "d04p02", "sinister_woods_clearing",
}
PROTECTED_MAP_PREFIXES = ("relic_forest_blob_", "d04p01", "d04p02")


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_json(path: Path, value: Any) -> None:
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def walk(value: Any):
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


def extract_fugitive_grounds() -> set[str]:
    path = ROOT / "Data/Script/halcyon/FugitiveArc.lua"
    if not path.is_file():
        return set(FUGITIVE_GROUNDS_FALLBACK)
    text = path.read_text(encoding="utf-8", errors="ignore")
    found = set(re.findall(r"ground\s*=\s*'([^']+)'", text))
    return found | FUGITIVE_GROUNDS_FALLBACK


def refs_for_zone(path: Path) -> tuple[set[str], set[str]]:
    data = read_json(path)["Object"]
    maps: set[str] = set()
    grounds = set(data.get("GroundMaps", []))
    for value in walk(data):
        if not isinstance(value, dict):
            continue
        for key in ("MapID", "map", "Map"):
            if isinstance(value.get(key), str) and value[key]:
                maps.add(value[key])
    return maps, grounds


def map_owners(zone_paths: list[Path]) -> dict[str, set[str]]:
    owners: dict[str, set[str]] = {}
    for path in zone_paths:
        maps, _ = refs_for_zone(path)
        for map_id in maps:
            owners.setdefault(map_id, set()).add(path.stem)
    return owners


def ground_owners(zone_paths: list[Path]) -> dict[str, set[str]]:
    owners: dict[str, set[str]] = {}
    for path in zone_paths:
        # master_zone is only the global routing container; it is not an
        # ownership claim on a chapter dungeon Ground.  Otherwise every
        # chapter Ground would appear shared and nothing could be purged.
        if path.stem == "master_zone":
            continue
        _, grounds = refs_for_zone(path)
        for ground_id in grounds:
            owners.setdefault(ground_id, set()).add(path.stem)
    return owners


def plan() -> dict[str, Any]:
    zone_paths = sorted(ROOT.joinpath("Data/Zone").glob("*.json"))
    purge_paths = [ROOT / "Data/Zone" / f"{zone}.json" for zone in sorted(PURGE_ZONES) if (ROOT / "Data/Zone" / f"{zone}.json").is_file()]
    keep_paths = [path for path in zone_paths if path not in purge_paths]
    purge_map_owners = map_owners(purge_paths)
    keep_map_owners = map_owners(keep_paths)
    purge_ground_owners = ground_owners(purge_paths)
    keep_ground_owners = ground_owners(keep_paths)
    fugitive = extract_fugitive_grounds()

    delete_maps = []
    retained_maps = []
    for map_id, owners in sorted(purge_map_owners.items()):
        path = ROOT / "Data/Map" / f"{map_id}.rsmap"
        if not path.is_file():
            continue
        if any(map_id.startswith(prefix) for prefix in PROTECTED_MAP_PREFIXES) or map_id in keep_map_owners:
            retained_maps.append({"id": map_id, "owners": sorted(owners), "kept_owners": sorted(keep_map_owners.get(map_id, set())), "reason": "protected_or_shared"})
        else:
            delete_maps.append({"path": str(path.relative_to(ROOT)), "id": map_id, "owners": sorted(owners)})

    delete_grounds = []
    retained_grounds = []
    for ground_id, owners in sorted(purge_ground_owners.items()):
        path = ROOT / "Data/Ground" / f"{ground_id}.rsground"
        if not path.is_file():
            continue
        if ground_id in PROTECTED_GROUND_NAMES or ground_id in fugitive or ground_id in keep_ground_owners:
            retained_grounds.append({"id": ground_id, "owners": sorted(owners), "kept_owners": sorted(keep_ground_owners.get(ground_id, set())), "reason": "protected_or_shared"})
        else:
            delete_grounds.append({"path": str(path.relative_to(ROOT)), "id": ground_id, "owners": sorted(owners)})

    return {
        "schema": "new-era.pmdred.chapter6-32-dungeon-purge-plan.v1",
        "authority": "explicit user request, constrained by integration contract protected baselines",
        "purge_zones": [{"id": zone, "chapter": chapter, "path": str((ROOT / 'Data/Zone' / f'{zone}.json').relative_to(ROOT)), "exists": (ROOT / 'Data/Zone' / f'{zone}.json').is_file()} for zone, chapter in sorted(PURGE_ZONES.items())],
        "existing_zone_deletion_count": len(purge_paths),
        "planned_deletions": {
            "zone_data": [str(path.relative_to(ROOT)) for path in purge_paths],
            "static_maps": delete_maps,
            "dungeon_grounds": delete_grounds,
        },
        "retained_safety_exceptions": {
            "fugitive_arc_grounds": sorted(fugitive),
            "protected_or_shared_maps": retained_maps,
            "protected_or_shared_grounds": retained_grounds,
            "narrative_lua": "retained",
            "reserve_and_archive_sources": "untouched",
            "d04p01_d04p02": "untouched",
            "relic_forest_blob_assets": "untouched",
        },
        "future_chapters": "No Data/Zone main files for the planned chapter-11..32 names were present; no phantom files are deleted.",
    }


def apply(plan_data: dict[str, Any]) -> dict[str, Any]:
    deleted: list[str] = []
    for row in plan_data["planned_deletions"]["zone_data"]:
        path = ROOT / row
        if path.is_file():
            path.unlink()
            deleted.append(row)
    for category in ("static_maps", "dungeon_grounds"):
        for row in plan_data["planned_deletions"][category]:
            path = ROOT / row["path"]
            if path.is_file():
                path.unlink()
                deleted.append(row["path"])

    # Remove deleted zone summaries and deleted Ground IDs from the production
    # routing structures.  Do not touch scripts or protected routes.
    zone_index_path = ROOT / "Data/Zone/index.idx"
    zone_index = read_json(zone_index_path)
    for zone in PURGE_ZONES:
        zone_index.get("Object", {}).pop(zone, None)
    master_path = ROOT / "Data/Zone/master_zone.json"
    if master_path.is_file():
        master = read_json(master_path)
        master_obj = master["Object"]
        deleted_grounds = {row["id"] for row in plan_data["planned_deletions"]["dungeon_grounds"]}
        master_obj["GroundMaps"] = [ground for ground in master_obj.get("GroundMaps", []) if ground not in deleted_grounds]
        write_json(master_path, master)
        if "master_zone" in zone_index.get("Object", {}):
            zone_index["Object"]["master_zone"]["Grounds"] = list(master_obj["GroundMaps"])
    write_json(zone_index_path, zone_index)
    plan_data["applied_deletions"] = deleted
    plan_data["applied"] = True
    return plan_data


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apply", action="store_true", help="perform the allow-listed deletion")
    parser.add_argument("--manifest", type=Path, default=ROOT / "docs/pmdred_eu/chapter6_32_dungeon_purge_manifest.json")
    args = parser.parse_args()
    data = plan()
    data["applied"] = False
    if args.apply:
        data = apply(data)
    args.manifest.parent.mkdir(parents=True, exist_ok=True)
    write_json(args.manifest, data)
    print(json.dumps({
        "applied": data["applied"],
        "zones": len(data["planned_deletions"]["zone_data"]),
        "maps": len(data["planned_deletions"]["static_maps"]),
        "grounds": len(data["planned_deletions"]["dungeon_grounds"]),
        "manifest": str(args.manifest.relative_to(ROOT)) if args.manifest.is_relative_to(ROOT) else str(args.manifest),
    }, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
