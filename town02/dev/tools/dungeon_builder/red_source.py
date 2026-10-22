"""Extract a provenance-bearing canonical dungeon manifest from pret/pmd-red.

This module does not generate PMDO maps.  It preserves the ROM-disassembly
records needed by the canonical adapter: per-floor generation bytes, referenced
Pokemon/item/trap tables, fixed-room classification, tileset IDs and checksums.
"""
from __future__ import annotations

import hashlib
import json
import re
import subprocess
from pathlib import Path
from typing import Any

FIELD_NAMES = (
    "layout", "roomDensity", "tileset", "bgMusic", "weather",
    "floorConnectivity", "enemyDensity", "kecleonShopChance",
    "monsterHouseChance", "mazeRoomChance", "itemStickyChance",
    "allowDeadEnds", "secondaryStructuresBudget", "roomFlags", "unkE",
    "itemDensity", "trapDensity", "floorNumber", "fixedRoomNumber",
    "numExtraHallways", "buriedItemDensity", "standaloneLakeDensity",
    "visibilityRange", "moneyUpperBound", "kecleonShopLayout",
    "itemlessMonsterHouseChance", "unk1A", "unk1B",
)


class RedSourceError(ValueError):
    pass


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def commit_of(root: Path) -> str:
    try:
        return subprocess.run(
            ["git", "rev-parse", "HEAD"], cwd=root, check=True,
            capture_output=True, text=True,
        ).stdout.strip()
    except (OSError, subprocess.CalledProcessError):
        return "UNKNOWN"


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def _record(values: list[int]) -> dict[str, Any]:
    record = dict(zip(FIELD_NAMES, values))
    record["raw_hex"] = "".join(f"{value:02x}" for value in values)
    return record


def parse_main_data(path: Path) -> list[dict[str, Any]]:
    """Parse local files where each `.byte` line is one FloorProperties row."""
    records = []
    for line in path.read_text(encoding="utf-8").splitlines():
        match = re.search(r"\.byte\s+(.+)$", line)
        if not match:
            continue
        values = [int(token, 16) for token in re.findall(r"0x([0-9a-fA-F]{1,2})", match.group(1))]
        if len(values) != len(FIELD_NAMES):
            raise RedSourceError(
                f"{path}: expected {len(FIELD_NAMES)} bytes, got {len(values)}")
        records.append(_record(values))
    if not records:
        raise RedSourceError(f"{path}: no FloorProperties records")
    return records


def parse_global_main_data(path: Path) -> tuple[int, list[dict[str, Any]]]:
    """Parse the global tail, whose 28-byte rows may cross assembler lines.

    pret keeps early story dungeons in included per-dungeon files and appends
    later/post-game records as one continuous byte stream.  `MainData` IDs are
    absolute, so return both the number of included records and the inline rows.
    """
    text = path.read_text(encoding="utf-8")
    included = 0
    for relative in re.findall(r'^#include\s+"([^"]+/main_data\.inc)"', text, re.MULTILINE):
        included += len(parse_main_data(path.parent / relative))
    values: list[int] = []
    for line in text.splitlines():
        match = re.search(r"\.byte\s+(.+)$", line)
        if match:
            values.extend(int(token, 16)
                          for token in re.findall(r"0x([0-9a-fA-F]{1,2})", match.group(1)))
    width = len(FIELD_NAMES)
    if not values or len(values) % width:
        raise RedSourceError(
            f"{path}: global stream has {len(values)} bytes, not a multiple of {width}")
    return included, [_record(values[pos:pos + width])
                      for pos in range(0, len(values), width)]


def table_at(values: list[dict], index: object, label: str) -> dict:
    if not isinstance(index, int) or not (0 <= index < len(values)):
        raise RedSourceError(f"invalid {label} table index {index!r}")
    return values[index]


def resolve_pokemon_table(dungeon_root: Path, local_tables: list[dict], local_base: int,
                          absolute_id: int, local_path: Path) -> tuple[dict, Path]:
    local_index = absolute_id - local_base
    if 0 <= local_index < len(local_tables):
        return local_tables[local_index], local_path
    # A few dungeons deliberately borrow encounter tables owned by another
    # dungeon (for example Fantasy Strait 24F and Far-Off Sea 61F-64F reuse
    # Silver Trench tables). Resolve that absolute ID instead of treating the
    # local JSON as a self-contained zero-based array.
    for path in sorted(dungeon_root.glob("*/pokemon_found.json")):
        floor_path = path.parent / "floor_id.json"
        if not floor_path.is_file():
            continue
        tables = read_json(path)["tables"]
        floor_ids = read_json(floor_path)["tables"]
        if not floor_ids:
            continue
        base = int(floor_ids[0]["Pokemon"])
        index = absolute_id - base
        if 0 <= index < len(tables):
            return tables[index], path
    raise RedSourceError(f"unresolved absolute Pokemon table ID {absolute_id}")


def extract(source_root: Path, folder: str) -> dict[str, Any]:
    root = source_root.resolve()
    dungeon_root = root / "data" / "dungeon"
    source_dir = dungeon_root / folder
    local_main = source_dir / "main_data.inc"
    files = {
        "main_data": local_main if local_main.is_file() else dungeon_root / "main_data.inc",
        "floor_id": source_dir / "floor_id.json",
        "pokemon": source_dir / "pokemon_found.json",
        "items": dungeon_root / "dungeon_item_data.json",
        "traps": dungeon_root / "trap_data.json",
        "dungeons": dungeon_root / "dungeon_data.json",
    }
    missing = [str(path) for path in files.values() if not path.is_file()]
    if missing:
        raise RedSourceError("missing source files: " + ", ".join(missing))

    floor_ids = read_json(files["floor_id"])["tables"]
    if local_main.is_file():
        main = parse_main_data(local_main)
        if len(main) != len(floor_ids):
            raise RedSourceError(
                f"{folder}: {len(main)} main records != {len(floor_ids)} floor ID records")
    else:
        global_offset, global_rows = parse_global_main_data(files["main_data"])
        main = []
        for ids in floor_ids:
            index = int(ids["MainData"]) - global_offset
            main.append(table_at(global_rows, index, "MainData"))
    pokemon = read_json(files["pokemon"])["tables"]
    items = read_json(files["items"])
    traps = read_json(files["traps"])

    pokemon_base = floor_ids[0]["Pokemon"]
    floors = []
    used_items, used_shops, used_houses, used_buried, used_traps = set(), set(), set(), set(), set()
    for number, (params, ids) in enumerate(zip(main, floor_ids, strict=True), start=1):
        pokemon_index = ids["Pokemon"] - pokemon_base
        pokemon_table, pokemon_source = resolve_pokemon_table(
            dungeon_root, pokemon, pokemon_base, int(ids["Pokemon"]), files["pokemon"])
        used_items.add(ids["Items"])
        used_shops.add(ids["KecleonShop"])
        used_houses.add(ids["MonsterRoomItems"])
        used_buried.add(ids["BuriedItems"])
        used_traps.add(ids["Traps"])
        floors.append({
            "floor": number,
            "classification": "fixed" if params["fixedRoomNumber"] else "procedural",
            "floor_properties": params,
            "table_ids": ids,
            "pokemon_absolute_id": int(ids["Pokemon"]),
            "pokemon_table_index": (pokemon_index
                                    if pokemon_source == files["pokemon"] else None),
            "pokemon_source": {
                "path": str(pokemon_source.relative_to(root)),
                "sha256": sha256(pokemon_source),
            },
            "pokemon": pokemon_table.get("pokemon", []),
        })

    def select(values: list[dict], indices: set[int], label: str) -> dict[str, dict]:
        return {str(index): table_at(values, index, label) for index in sorted(indices)}

    return {
        "schema": "new-era.canonical.pmd-red-dungeon.v1",
        "game": "PMD_RED",
        "dungeon_folder": folder,
        "source": {
            "kind": "PMD_RED_ROM",
            "proxy": "pret/pmd-red disassembly",
            "repository": "https://github.com/pret/pmd-red",
            "commit": commit_of(root),
            "files": {
                name: {"path": str(path.relative_to(root)), "sha256": sha256(path)}
                for name, path in files.items()
            },
        },
        "floor_count": len(floors),
        "procedural_floors": [row["floor"] for row in floors if row["classification"] == "procedural"],
        "fixed_floors": [row["floor"] for row in floors if row["classification"] == "fixed"],
        "floors": floors,
        "tables": {
            "items": select(items, used_items, "Items"),
            "shops": select(items, used_shops, "KecleonShop"),
            "monster_house_items": select(items, used_houses, "MonsterRoomItems"),
            "buried_items": select(items, used_buried, "BuriedItems"),
            "traps": select(traps, used_traps, "Traps"),
        },
        "notes": [
            "Raw probabilities and IDs are preserved; no PMDO mapping or level rescaling is applied here.",
            "A non-zero table ID does not imply the feature spawns: per-floor chance bytes remain authoritative.",
        ],
    }


def write_manifest(source_root: Path, folder: str, output: Path) -> Path:
    manifest = extract(source_root, folder)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return output
