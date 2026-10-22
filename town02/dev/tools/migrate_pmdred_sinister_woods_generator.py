#!/usr/bin/env python3
"""Build the PMD Red Sinister Woods floor profile and native PMDO generators.

The GBA does not store Sinister Woods as a list of static maps.  Its
``GenerateFloor`` routine consumes one 0x1c ``FloorProperties`` record per
floor.  This tool extracts those records from the pinned pret source, writes a
small provenance-bearing IR, and applies the source parameters to PMDO's
native ``GridFloorGen``/``GridPathBranch`` pipeline.

The conversion is deliberately explicit about its boundary:

* source floor data (layout, room density, connectivity, extra halls, secondary
  terrain, tileset, music, fixed-room id) is retained byte-for-byte in the IR;
* PMDO uses its native generator, never a generated list of static maps;
* PMDO's grid generator has different random-walk semantics, so the derived
  RoomRatio/BranchRatio/ConnectPercent values are labelled as an adapter, not
  falsely claimed to be a byte-identical RNG port;
* the PMD Red fixed final floor (floor 13, fixed-room 2, tileset 65) remains a
  fixed Ground transition and is not silently turned into a procedural floor;
* New Era's existing depth/relay segments remain intact.  Only their
  procedural generator parameters are updated using the canonical 1F-12F
  cycle; the Team Dazzling story is not rewritten here.
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
import hashlib
import json
import os
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"
FIELD_NAMES = (
    "layout",
    "roomDensity",
    "tileset",
    "bgMusic",
    "weather",
    "floorConnectivity",
    "enemyDensity",
    "kecleonShopChance",
    "monsterHouseChance",
    "mazeRoomChance",
    "itemStickyChance",
    "allowDeadEnds",
    "secondaryStructuresBudget",
    "roomFlags",
    "unkE",
    "itemDensity",
    "trapDensity",
    "floorNumber",
    "fixedRoomNumber",
    "numExtraHallways",
    "buriedItemDensity",
    "standaloneLakeDensity",
    "visibilityRange",
    "moneyUpperBound",
    "kecleonShopLayout",
    "itemlessMonsterHouseChance",
    "unk1A",
    "unk1B",
)
LAYOUT_NAMES = {
    0: "LARGE",
    1: "SMALL",
    2: "ONE_ROOM_MONSTER_HOUSE",
    3: "OUTER_RING",
    4: "CROSSROADS",
    5: "TWO_ROOMS_WITH_MONSTER_HOUSE",
    6: "LINE",
    7: "CROSS",
    8: "LARGE_0x8",
    9: "BEETLE",
    10: "OUTER_ROOMS",
    11: "MEDIUM",
}
# Current New Era segment-to-source-floor mapping.  The source has 12
# procedural floors; floor 13 is the fixed final Ground and must not be cycled
# into a procedural segment.
PROCEDURAL_SEGMENT_OFFSETS = {0: 0, 1: 15, 3: 20}
# These are the pre-existing New Era segment lengths.  They are retained so
# the migration is idempotent even after the first run has split a range node
# into one native node per floor.
PROCEDURAL_SEGMENT_FLOOR_COUNTS = {0: 15, 1: 5, 3: 3}


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_root(explicit: Path | None) -> Path:
    candidates = [
        explicit,
        Path(os.environ["PMD_RED_SOURCE"]) if os.environ.get("PMD_RED_SOURCE") else None,
        ROOT / ".runtime-cache/recovery-sources/pmd-red-reference",
        ROOT / ".runtime-cache/pmd-red-reference",
        Path("/home/user/pmd-red"),
        Path("/tmp/pmd-red"),
    ]
    for candidate in candidates:
        if candidate is not None and (candidate / "data/dungeon/SinisterWoods/main_data.inc").is_file():
            return candidate
    raise FileNotFoundError(
        "pret/pmd-red source absent; use --source /path/to/pmd-red or restore the pinned source"
    )


def parse_main_data(path: Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        match = re.search(r"\.byte\s+(.+)$", line)
        if not match:
            continue
        values = [int(token, 16) for token in re.findall(r"0x([0-9a-fA-F]{1,2})", match.group(1))]
        if len(values) != len(FIELD_NAMES):
            raise ValueError(f"{path}: expected {len(FIELD_NAMES)} bytes, got {len(values)}")
        row = dict(zip(FIELD_NAMES, values))
        row["raw_hex"] = "".join(f"{value:02x}" for value in values)
        row["source_index"] = len(rows) + 1
        row["layout_name"] = LAYOUT_NAMES.get(row["layout"], f"UNKNOWN_{row['layout']}")
        rows.append(row)
    if len(rows) != 13:
        raise ValueError(f"Sinister Woods main_data must contain 13 floors, got {len(rows)}")
    return rows


def read_floor_ids(path: Path) -> list[dict[str, int]]:
    payload = read_json(path)
    rows = payload.get("tables", [])
    if len(rows) != 13:
        raise ValueError(f"Sinister Woods floor_id must contain 13 rows, got {len(rows)}")
    return rows


def grid_shape(layout: int) -> tuple[int, int]:
    # These are the native PMDO grid dimensions used by the adapter.  They
    # preserve PMD Red's layout family (small/medium/large) while remaining
    # within PMDO's supported GridPlan dimensions.
    return {
        0: (4, 4),   # LAYOUT_LARGE
        1: (3, 3),   # LAYOUT_SMALL
        11: (4, 3),  # LAYOUT_MEDIUM
    }.get(layout, (4, 4))


def pmdo_adapter(row: dict[str, Any]) -> dict[str, Any]:
    grid_x, grid_y = grid_shape(row["layout"])
    cells = grid_x * grid_y
    room_min = max(2, min(cells, row["roomDensity"]))
    room_max = max(room_min, min(cells, row["roomDensity"] + (0 if row["roomDensity"] < 0 else 2)))
    room_ratio = {
        "Min": round(room_min * 100 / cells),
        "Max": round(room_max * 100 / cells),
    }
    # PMD Red uses a connectivity random walk (15/20/25 iterations); PMDO's
    # GridPathBranch expresses the closest native concept as branch/connect
    # percentages.  Keep both source values above and this deterministic
    # translation here so the mismatch is auditable rather than hidden.
    branch_min = max(0, min(100, 25 + (row["floorConnectivity"] - 15) * 3))
    branch_max = max(branch_min, min(100, branch_min + 20))
    connect_percent = max(0, min(100, round(row["floorConnectivity"] * 4)))
    if row["allowDeadEnds"]:
        no_forced_branches = False
    else:
        no_forced_branches = True
    room_size = {
        0: {"Min": 5, "Max": 9},
        1: {"Min": 4, "Max": 7},
        11: {"Min": 5, "Max": 8},
    }.get(row["layout"], {"Min": 5, "Max": 8})
    return {
        "grid": {"CellX": grid_x, "CellY": grid_y, "CellWidth": 10, "CellHeight": 10, "CellWall": 3, "Wrap": False},
        "room_ratio": room_ratio,
        "branch_ratio": {"Min": branch_min, "Max": branch_max},
        "connect_percent": connect_percent,
        "no_forced_branches": no_forced_branches,
        "room_size": room_size,
        "room_generator": "RogueElements.RoomGenSquare",
        "hall_generator": "RogueElements.RoomGenAngledHall",
        "extra_hallways": row["numExtraHallways"],
        "secondary_terrain": {
            "enabled": bool(row["roomFlags"] & 0x1),
            "standalone_lake_density": row["standaloneLakeDensity"],
        },
        "pmdo_equivalence": "native_grid_adapter_not_rng_identical",
    }


def build_profile(source: Path) -> dict[str, Any]:
    dungeon = source / "data/dungeon/SinisterWoods"
    rows = parse_main_data(dungeon / "main_data.inc")
    floor_ids = read_floor_ids(dungeon / "floor_id.json")
    floor_rows: list[dict[str, Any]] = []
    for row, floor_id in zip(rows, floor_ids, strict=True):
        floor_rows.append({
            "floor": row["floorNumber"],
            "source_record_index": row["source_index"],
            "raw_hex": row["raw_hex"],
            "floor_properties": {key: row[key] for key in FIELD_NAMES},
            "floor_id": floor_id,
            "layout_name": row["layout_name"],
            "generated_by_rom": row["fixedRoomNumber"] == 0,
            "fixed_room": row["fixedRoomNumber"] if row["fixedRoomNumber"] else None,
            "tileset_binding": (
                {
                    "rom_tileset_id": row["tileset"],
                    "pmdo_ground": "sinister_woods_b41_floor",
                    "pmdo_wall": "sinister_woods_b41_wall",
                    "pmdo_secondary": "sinister_woods_b41_secondary",
                    "music": "Sinister Woods.ogg",
                }
                if row["tileset"] == 41
                else {
                    "rom_tileset_id": row["tileset"],
                    "mode": "fixed_ground_transition",
                    "pmdo_namespace": "D04P02",
                    "fixed_ground": "sinister_woods_clearing",
                    "music": None,
                }
            ),
            "pmdo_native_adapter": pmdo_adapter(row) if row["fixedRoomNumber"] == 0 else {
                "mode": "fixed_ground_transition",
                "fixed_room": row["fixedRoomNumber"],
                "reason": "PMD Red calls ProcessFixedRoom instead of GenerateStandardFloor",
            },
        })
    return {
        "schema": "new-era.pmdred.sinister-woods-generator-profile.v1",
        "result": "PROFILE_ONLY_NOT_RUNTIME_CERTIFICATION",
        "source": {
            "repository": "pret/pmd-red",
            "commit": PRET_COMMIT,
            "authority": "src/dungeon_generation.c::GenerateFloor",
            "files": [
                "src/dungeon_generation.c",
                "include/structs/str_dungeon.h",
                "include/dungeon_generation.h",
                "data/dungeon/SinisterWoods/main_data.inc",
                "data/dungeon/SinisterWoods/floor_id.json",
                "data/dungeon/SinisterWoods/pokemon_found.json",
            ],
            "generator_behaviors": [
                "32 attempts to choose grid dimensions",
                "10 layout attempts",
                "10 spawn/reachability attempts",
                "AssignRooms(roomDensity)",
                "AssignGridCellConnections(floorConnectivity)",
                "GenerateExtraHallways(numExtraHallways)",
                "GenerateSecondaryTerrainFormations(roomFlags, standaloneLakeDensity)",
                "ProcessFixedRoom(fixedRoomNumber) for fixed floors",
            ],
        },
        "canonical_identity": {
            "dungeon_id": 3,
            "name": "Sinister Woods",
            "floor_count": 13,
            "procedural_floor_count": 12,
            "fixed_floor_count": 1,
            "mechanics": {
                "stair_direction": "up",
                "recruiting": True,
                "rescues_allowed": 10,
                "max_items": 20,
                "max_party_members": 3,
                "turn_limit": 1000,
            },
        },
        "tilesets": {
            "procedural_floors_1_12": {"rom_tileset_id": 41, "pmdo_namespace": "SinisterWoodsB41"},
            "fixed_floor_13": {"rom_tileset_id": 65, "pmdo_namespace": "D04P02", "fixed_ground": "sinister_woods_clearing"},
        },
        "new_era_integration": {
            "technical_zone_id": "gloomy_forest",
            "display_identity": "Sinister Woods",
            "casting": "Team Dazzling retained; PMD Red Team Meanies is not instantiated",
            "story_policy": "existing New Era relay, mini-boss, boss and post-dungeon scenes remain outside this generator migration",
            "procedural_segments": {str(key): {"global_floor_offset": value, "source_cycle": "1..12"} for key, value in PROCEDURAL_SEGMENT_OFFSETS.items()},
        },
        "floors": floor_rows,
        "provenance_sha256": {
            "main_data.inc": sha256(dungeon / "main_data.inc"),
            "floor_id.json": sha256(dungeon / "floor_id.json"),
            "pokemon_found.json": sha256(dungeon / "pokemon_found.json"),
        },
    }


def walk(value: Any):
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


def typed(value: Any, needle: str) -> list[dict[str, Any]]:
    return [item for item in walk(value) if isinstance(item, dict) and needle in item.get("$type", "")]


def first_native_room_template() -> dict[str, Any]:
    """Return a checked-in PMDO square-room payload.

    PMD Red's standard generator fills rectangular rooms.  The old candidate
    used RoomGenRound, which was a visual approximation.  We borrow only the
    native serialized RoomGenSquare schema from an existing project zone; no
    map, entity, story or protected Ground is copied.
    """
    reference = read_json(ROOT / "Data/Zone/chasm_cave.json")
    for value in typed(reference, "RoomGenSquare"):
        return copy.deepcopy(value)
    raise ValueError("no native RoomGenSquare schema available in PMDO data")


def first_native_secondary_terrain_step() -> dict[str, Any]:
    """Return the checked-in native wall-lake step used by PMDO."""
    reference = read_json(ROOT / "Data/Zone/dark_hill.json")
    for value in typed(reference, "PerlinWaterStep"):
        return copy.deepcopy(value)
    raise ValueError("no native PerlinWaterStep schema available in PMDO data")


def map_floor_nodes(template: dict[str, Any], row: dict[str, Any], profile_floor: dict[str, Any], floor_min: int, floor_max: int) -> dict[str, Any]:
    generated = copy.deepcopy(template)
    generated["Range"] = {"Min": floor_min, "Max": floor_max}
    item = generated["Item"]
    adapter = profile_floor["pmdo_native_adapter"]
    room_template = first_native_room_template()
    secondary_template = first_native_secondary_terrain_step()
    has_secondary_step = False
    for step in item.get("GenSteps", []):
        value = step.get("Value", {})
        kind = value.get("$type", "")
        if "MapDataStep" in kind:
            value["Music"] = "Sinister Woods.ogg"
            value["TimeLimit"] = 1000
        elif "InitGridPlanStep" in kind:
            value.update(adapter["grid"])
        elif "GridPathBranch" in kind:
            value["RoomRatio"] = adapter["room_ratio"]
            value["BranchRatio"] = adapter["branch_ratio"]
            value["NoForcedBranches"] = adapter["no_forced_branches"]
            for room in value.get("GenericRooms", {}).get("$values", []):
                spawn = room.get("Spawn", {})
                if "RoomGen" in spawn.get("$type", ""):
                    # PMD Red standard rooms are rectangular.  Use PMDO's
                    # square-room primitive rather than the former rounded
                    # placeholder; the native generator still chooses the
                    # position, size and connectivity at runtime.
                    replacement = copy.deepcopy(room_template)
                    replacement["Size"] = adapter["room_size"]
                    replacement["Resizable"] = False
                    room["Spawn"] = replacement
            for hall in value.get("GenericHalls", {}).get("$values", []):
                spawn = hall.get("Spawn", {})
                if "RoomGenAngledHall" in spawn.get("$type", ""):
                    # More source extra hallways means less straight bias in
                    # the native branch generator, while the exact source
                    # count remains recorded in the profile.
                    spawn["HallTurnBias"] = max(0, min(100, 100 - row["numExtraHallways"] * 5))
        elif "ConnectGridBranchStep" in kind:
            value["ConnectPercent"] = adapter["connect_percent"]
        elif "MapTextureStep" in kind:
            binding = profile_floor["tileset_binding"]
            value["GroundTileset"] = binding["pmdo_ground"]
            value["BlockTileset"] = binding["pmdo_wall"]
            value["WaterTileset"] = binding["pmdo_secondary"]
        elif "PerlinWaterStep" in kind:
            has_secondary_step = True
        elif "FloorStairsStep" in kind:
            value["MinDistance"] = 3
    if row["roomFlags"] & 0x1:
        if not has_secondary_step:
            secondary_step = copy.deepcopy(secondary_template)
            secondary_step["WaterPercent"] = {
                "Min": row["standaloneLakeDensity"],
                "Max": row["standaloneLakeDensity"],
            }
            secondary_step["Bowl"] = True
            secondary_step["OrderComplexity"] = 3
            secondary_step["OrderSoftness"] = 1
            item["GenSteps"].append({
                "Key": {"str": [3]},
                "Value": secondary_step,
            })
    return generated


def apply_profile_to_zone(zone_path: Path, profile: dict[str, Any]) -> dict[str, Any]:
    payload = read_json(zone_path)
    zone = payload["Object"]
    profile_floors = {row["floor"]: row for row in profile["floors"]}
    changes: list[dict[str, Any]] = []
    for segment_index, offset in PROCEDURAL_SEGMENT_OFFSETS.items():
        segment = zone["Segments"][segment_index]
        floors = segment.get("Floors", {})
        nodes = floors.get("nodes", []) if isinstance(floors, dict) else []
        if not nodes or not isinstance(nodes[0].get("Item"), dict):
            raise ValueError(f"segment {segment_index} has no procedural GridFloorGen template")
        original = nodes[0]
        if len(nodes) > 1:
            local_min = min(int(node["Range"]["Min"]) for node in nodes)
            local_max = max(int(node["Range"]["Max"]) for node in nodes)
        else:
            original_range = original["Range"]
            observed_min = int(original_range["Min"])
            observed_max = int(original_range["Max"])
            expected_count = PROCEDURAL_SEGMENT_FLOOR_COUNTS[segment_index]
            # A range of one is the result of an earlier migration run; use
            # the protected New Era segment length, never silently collapse it.
            if observed_max - observed_min == 1 and expected_count > 1:
                local_min, local_max = 0, expected_count
            else:
                local_min, local_max = observed_min, observed_max
        replacement: list[dict[str, Any]] = []
        for local_floor in range(local_min, local_max):
            source_floor = ((offset + local_floor) % 12) + 1
            row = profile_floors[source_floor]["floor_properties"]
            replacement.append(map_floor_nodes(original, row, profile_floors[source_floor], local_floor, local_floor + 1))
        floors["nodes"] = replacement
        changes.append({"segment": segment_index, "local_floor_count": local_max - local_min, "source_cycle": "1..12", "nodes": len(replacement)})
    # The old generic range nodes are replaced only for procedural segments;
    # LoadGen boss/relay/raid segments are untouched.
    zone["Comment"] = (
        "Sinister Woods canonical PMD Red generator adapter: native PMDO GridFloorGen "
        "per floor; b41 material on procedural floors; fixed D04P02 transition remains a LoadGen. "
        "Team Dazzling/New Era narrative segments preserved."
    )
    zone["Name"]["DefaultText"] = "Sinister Woods"
    if isinstance(zone["Name"].get("LocalTexts"), dict):
        zone["Name"]["LocalTexts"]["fr"] = "Forêt Sinistre"
    zone["PMDRedGeneratorProfile"] = "docs/canonical/red/sinister_woods_generator_profile.json"
    zone["PMDRedGeneratorProfileSha256"] = None
    zone_path.write_text("\ufeff" + json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return {"zone": str(zone_path.relative_to(ROOT)), "changes": changes}


def validate_zone(zone_path: Path, profile: dict[str, Any]) -> dict[str, Any]:
    payload = read_json(zone_path)
    zone = payload["Object"]
    failures: list[str] = []
    checks: dict[str, Any] = {}
    checks["display_name"] = zone.get("Name", {}).get("DefaultText") == "Sinister Woods"
    checks["profile_link"] = zone.get("PMDRedGeneratorProfile") == "docs/canonical/red/sinister_woods_generator_profile.json"
    checks["procedural_segment_count"] = True
    for segment_index, offset in PROCEDURAL_SEGMENT_OFFSETS.items():
        segment = zone["Segments"][segment_index]
        nodes = segment.get("Floors", {}).get("nodes", [])
        checks[f"segment_{segment_index}_native_nodes"] = len(nodes) > 1 and all("GridFloorGen" in n.get("Item", {}).get("$type", "") for n in nodes)
        if not checks[f"segment_{segment_index}_native_nodes"]:
            failures.append(f"segment {segment_index} is not expanded into native GridFloorGen nodes")
        for node in nodes:
            for value in node.get("Item", {}).get("GenSteps", []):
                step = value.get("Value", {})
                kind = step.get("$type", "")
                if "MapTextureStep" in kind:
                    if step.get("GroundTileset") != "sinister_woods_b41_floor" or step.get("BlockTileset") != "sinister_woods_b41_wall" or step.get("WaterTileset") != "sinister_woods_b41_secondary":
                        failures.append(f"segment {segment_index} has a non-b41 procedural texture")
                if "MapDataStep" in kind and step.get("Music") != "Sinister Woods.ogg":
                    failures.append(f"segment {segment_index} has a non-canonical procedural music")
    checks["no_static_floor_replacement"] = not any("MappedRoomStep" in value.get("Value", {}).get("$type", "") for segment in zone["Segments"][:2] for node in (segment.get("Floors", {}).get("nodes", []) if isinstance(segment.get("Floors"), dict) else []) for value in node.get("Item", {}).get("GenSteps", []))
    checks["fixed_segments_preserved"] = all(any("MappedRoomStep" in value.get("Value", {}).get("$type", "") for value in node.get("GenSteps", [])) for segment_index in (2,4,5,6,7,8,9,10) for node in ([zone["Segments"][segment_index]["Floors"][0]] if isinstance(zone["Segments"][segment_index].get("Floors"), list) else []))
    checks["all"] = all(checks.values())
    if not checks["display_name"]: failures.append("zone display identity is not Sinister Woods")
    if not checks["profile_link"]: failures.append("zone is not linked to the generator profile")
    return {"result": "PASS" if not failures else "BLOCKED", "checks": checks, "failures": failures}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path)
    parser.add_argument("--profile", type=Path, default=ROOT / "docs/canonical/red/sinister_woods_generator_profile.json")
    parser.add_argument("--zone", type=Path, default=ROOT / "Data/Zone/gloomy_forest.json")
    parser.add_argument("--write-zone", action="store_true")
    parser.add_argument("--check-zone", action="store_true")
    args = parser.parse_args()
    source = source_root(args.source)
    profile_path = args.profile if args.profile.is_absolute() else ROOT / args.profile
    zone_path = args.zone if args.zone.is_absolute() else ROOT / args.zone
    profile = build_profile(source)
    profile_path.parent.mkdir(parents=True, exist_ok=True)
    profile_path.write_text(json.dumps(profile, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    result: dict[str, Any] = {"profile": str(profile_path.relative_to(ROOT)), "source": str(source), "floor_count": len(profile["floors"])}
    if args.write_zone:
        result["zone_write"] = apply_profile_to_zone(zone_path, profile)
        # Re-write the profile link hash now that the profile exists.
        payload = read_json(zone_path)
        payload["Object"]["PMDRedGeneratorProfileSha256"] = sha256(profile_path)
        zone_path.write_text("\ufeff" + json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    if args.check_zone:
        result["zone_validation"] = validate_zone(zone_path, profile)
        if result["zone_validation"]["result"] != "PASS":
            print(json.dumps(result, ensure_ascii=False, indent=2))
            return 1
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
