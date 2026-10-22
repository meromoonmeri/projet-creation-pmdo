#!/usr/bin/env python3
"""Audit the PMD Red Sinister Woods / New Era Relic Forest boundary.

This is deliberately a data audit, not a visual heuristic.  It follows every
current-runtime LoadBlobStep in Data/Zone, resolves each map id to its .rsmap,
then follows the map's sheet and AutoTileset references to the tile assets.
The audit also records the RelicForest stair-script dependency separately: it
is not a blob, but it is an inherited Relic Forest behaviour and must not be
silently left in the PMD Red zone.

The six blob maps and their tiles are *not* deleted by this tool.  They remain
owned by Data/Zone/relic_forest.json and are protected by the existing byte
hash regression test.
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
import hashlib
import json
import re
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any, Iterable

ROOT = Path(__file__).resolve().parents[1]
BLOB_IDS = (
    "relic_forest_blob_broken_pillar",
    "relic_forest_blob_fallen_left",
    "relic_forest_blob_fallen_right",
    "relic_forest_blob_pillar",
    "relic_forest_blob_rubble",
    "relic_forest_blob_ruins",
)
PROVENANCE_COMMIT = "55860b9a5eb48697a3cea3a8bdfce5f0529d6141"
# The template hash is the normalized LoadBlobStep node before this correction.
# It is also the hash of every owning Relic Forest LoadBlobStep.
CLONED_RELIC_LOAD_NODE_SHA256 = "b12dae34924ad092e0f62bcc54fab71247b9b105fd12e20e9876479218837c23"
ZONE_FILES = (ROOT / "Data/Zone/gloomy_forest.json", ROOT / "Data/Zone/relic_forest.json")
TOKEN_RE = re.compile(r"relic_forest_blob_[a-z0-9_]+")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def walk(value: Any, path: tuple[Any, ...] = ()) -> Iterable[tuple[tuple[Any, ...], Any]]:
    yield path, value
    if isinstance(value, dict):
        for key, child in value.items():
            yield from walk(child, path + (key,))
    elif isinstance(value, list):
        for index, child in enumerate(value):
            yield from walk(child, path + (index,))


def path_text(path: tuple[Any, ...]) -> str:
    return "/".join(str(part) for part in path)


def load_steps(payload: Any) -> list[tuple[tuple[Any, ...], dict[str, Any]]]:
    return [
        (path, value)
        for path, value in walk(payload)
        if isinstance(value, dict) and "LoadBlobStep" in value.get("$type", "")
    ]


def blob_spawns(node: dict[str, Any]) -> list[dict[str, Any]]:
    maps = node.get("Maps", [])
    return [child for child in maps if isinstance(child, dict) and isinstance(child.get("Spawn"), str)]


def scripts(payload: Any, script_name: str) -> list[tuple[tuple[Any, ...], dict[str, Any]]]:
    return [
        (path, value)
        for path, value in walk(payload)
        if isinstance(value, dict) and value.get("Script") == script_name
    ]


def stable_node_hash(node: dict[str, Any]) -> str:
    raw = json.dumps(node, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()


def zone_record(path: Path) -> dict[str, Any]:
    payload = read_json(path)
    loads = load_steps(payload)
    records = []
    for load_path, node in loads:
        spawns = blob_spawns(node)
        records.append(
            {
                "path": path_text(load_path),
                "node_sha256": stable_node_hash(node),
                "amount": node.get("Amount"),
                "spawn_ids": [row["Spawn"] for row in spawns],
                "spawn_rates": {row["Spawn"]: row.get("Rate") for row in spawns},
                "terrain_stencil_sha256": stable_node_hash(node.get("TerrainStencil", {})),
            }
        )
    relic_script_records = [
        {"path": path_text(script_path)} for script_path, _ in scripts(payload, "ReverseRelicForest")
    ]
    return {
        "path": str(path.relative_to(ROOT)),
        "sha256": sha256(path),
        "load_blob_step_count": len(loads),
        "blob_spawn_count": sum(len(blob_spawns(node)) for _, node in loads),
        "load_blob_steps": records,
        "reverse_relic_forest_script_count": len(relic_script_records),
        "reverse_relic_forest_scripts": relic_script_records,
        "blob_ids": sorted({spawn for record in records for spawn in record["spawn_ids"]}),
    }


def map_record(map_id: str) -> dict[str, Any]:
    map_path = ROOT / "Data/Map" / f"{map_id}.rsmap"
    reserve_path = ROOT / "RESERVE/maps" / f"{map_id}.rsmap"
    record: dict[str, Any] = {
        "id": map_id,
        "map_path": str(map_path.relative_to(ROOT)),
        "map_exists": map_path.is_file(),
        "map_sha256": sha256(map_path) if map_path.is_file() else None,
        "reserve_exists": reserve_path.is_file(),
        "reserve_sha256": sha256(reserve_path) if reserve_path.is_file() else None,
        "provenance_commit": PROVENANCE_COMMIT,
    }
    if not map_path.is_file():
        return record
    payload = read_json(map_path)["Object"]
    sheets = sorted(
        {
            value["Sheet"]
            for _, value in walk(payload)
            if isinstance(value, dict) and isinstance(value.get("Sheet"), str)
        }
    )
    autotiles = sorted(
        {
            value["AutoTileset"]
            for _, value in walk(payload)
            if isinstance(value, dict) and isinstance(value.get("AutoTileset"), str) and value["AutoTileset"]
        }
    )
    layer_shapes = []
    for layer in payload.get("Layers", []):
        tiles = layer.get("Tiles", []) if isinstance(layer, dict) else []
        layer_shapes.append({
            "name": layer.get("Name") if isinstance(layer, dict) else None,
            "rows": len(tiles),
            "columns": max((len(row) for row in tiles if isinstance(row, list)), default=0),
        })
    tile_records = []
    for sheet in sheets:
        tile_path = ROOT / "Content/Tile" / f"{sheet}.tile"
        tile_records.append(
            {
                "sheet": sheet,
                "path": str(tile_path.relative_to(ROOT)),
                "exists": tile_path.is_file(),
                "sha256": sha256(tile_path) if tile_path.is_file() else None,
            }
        )
    record.update(
        {
            "asset_name": payload.get("AssetName"),
            "sheets": sheets,
            "tile_assets": tile_records,
            "autotilesets": autotiles,
            "layer_shapes": layer_shapes,
            "map_tile_count": sum(len(row) for row in payload.get("Tiles", []) if isinstance(row, list)),
        }
    )
    return record


def repository_token_references() -> dict[str, Any]:
    groups: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for path in ROOT.rglob("*"):
        if not path.is_file() or ".git" in path.parts or ".runtime-cache" in path.parts:
            continue
        try:
            text = path.read_text(encoding="utf-8-sig")
        except (UnicodeDecodeError, OSError):
            continue
        matches = sorted(set(TOKEN_RE.findall(text)))
        if not matches:
            continue
        rel = str(path.relative_to(ROOT))
        if rel.startswith("Data/Zone/"):
            group = "current_runtime_zone"
        elif rel.startswith("Data/Map/") or rel.startswith("Content/Tile/"):
            group = "current_runtime_asset"
        elif rel.startswith("RESERVE/"):
            group = "reserve_source_copy"
        elif rel.startswith("external/"):
            group = "external_conversion_library"
        elif rel.startswith("docs/"):
            group = "audit_or_documentation"
        elif rel.startswith("tools/"):
            group = "audit_or_test_tool"
        else:
            group = "other"
        groups[group].append({"path": rel, "matches": matches, "occurrences": sum(text.count(x) for x in matches)})
    return {key: sorted(value, key=lambda row: row["path"]) for key, value in sorted(groups.items())}


def build(expect_separated: bool) -> dict[str, Any]:
    zones = {path.stem: zone_record(path) for path in ZONE_FILES}
    maps = {map_id: map_record(map_id) for map_id in BLOB_IDS}
    gloomy = zones["gloomy_forest"]
    relic = zones["relic_forest"]
    gloomy_load_templates = [row["node_sha256"] for row in gloomy["load_blob_steps"]]
    relic_load_templates = [row["node_sha256"] for row in relic["load_blob_steps"]]
    all_assets_resolve = all(
        row["map_exists"] and row["reserve_exists"] and all(tile["exists"] for tile in row.get("tile_assets", []))
        for row in maps.values()
    )
    checks = {
        "gloomy_forest_has_no_load_blob_steps": gloomy["load_blob_step_count"] == 0,
        "gloomy_forest_has_no_blob_spawn_ids": gloomy["blob_spawn_count"] == 0,
        "gloomy_forest_has_no_reverse_relic_forest_script": gloomy["reverse_relic_forest_script_count"] == 0,
        "relic_forest_retains_all_six_blob_ids": set(relic["blob_ids"]) == set(BLOB_IDS),
        "relic_forest_retains_five_blob_steps": relic["load_blob_step_count"] == 5,
        "all_six_maps_and_transitive_tiles_resolve": all_assets_resolve,
        "gloomy_load_template_was_cloned_from_relic_template_before_removal": bool(
            relic_load_templates
            and set(relic_load_templates) == {CLONED_RELIC_LOAD_NODE_SHA256}
            and (not gloomy_load_templates or set(gloomy_load_templates) == {CLONED_RELIC_LOAD_NODE_SHA256})
        ),
    }
    blockers = [name for name, passed in checks.items() if not passed]
    result = "SEPARATED" if not blockers else "BLOCKED"
    return {
        "schema": "new-era.pmdred-eu-sinister-woods-relic-forest-separation.v1",
        "authority": {
            "checkpoint": "c3ba0185ff3ea5bc0ad67edf0b3cc5e2928f09ee",
            "rom_sha256": "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd",
            "map_provenance_commit": PROVENANCE_COMMIT,
        },
        "scope": {
            "sinister_woods_zone": "Data/Zone/gloomy_forest.json",
            "relic_forest_zone": "Data/Zone/relic_forest.json",
            "runtime_asset_roots": ["Data/Map", "Content/Tile"],
            "external_conversion_libraries_are_not_runtime": True,
        },
        "findings": {
            "why_gloomy_forest_was_branded": "The LoadBlobStep node is byte-structurally identical to the Relic Forest node: same stencil, amount and six weighted map ids. The current zone was cloned from the PMDO Relic Forest dungeon template; the three current procedural segments retained that foreign decoration step. ReverseRelicForest was retained by the same template inheritance and mutates stairs using Chapter 1 Relic Forest flags.",
            "gloomy_forest_before_correction": {
                "load_blob_steps": 3,
                "blob_spawn_references": 18,
                "reverse_relic_forest_script_references": 3,
                "segments": [0, 1, 3],
            },
            "relic_forest_owner_after_correction": {
                "load_blob_steps": relic["load_blob_step_count"],
                "blob_spawn_references": relic["blob_spawn_count"],
                "blob_ids": list(BLOB_IDS),
                "reverse_relic_forest_script_references": relic["reverse_relic_forest_script_count"],
            },
            "transitive_asset_policy": "All six .rsmap files and all six Relic_Forest_Blob .tile sheets remain installed because relic_forest still resolves them. No asset was deleted. Each blob map also references treeshroud_forest_1_floor for its underlying unbreakable terrain; this shared dependency is recorded so the later b41 promotion cannot silently break Relic Forest.",
            "current_runtime_references": {
                "gloomy_forest": gloomy,
                "relic_forest": relic,
            },
            "map_assets": maps,
            "repository_token_references": repository_token_references(),
        },
        "checks": checks,
        "blockers": blockers,
        "result": result,
        "expected_separated": expect_separated,
        "production_route": {
            "gloomy_forest_load_blob_removed": result == "SEPARATED",
            "relic_forest_blob_assets_deleted": False,
            "d04p01_d04p02_touched": False,
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, help="write the JSON evidence here")
    parser.add_argument("--expect-separated", action="store_true", help="return failure unless the corrected wiring is present")
    args = parser.parse_args()
    result = build(args.expect_separated)
    text = json.dumps(result, ensure_ascii=False, indent=2) + "\n"
    if args.output:
        output = args.output if args.output.is_absolute() else ROOT / args.output
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(text, encoding="utf-8")
    print(text, end="")
    if args.expect_separated and result["result"] != "SEPARATED":
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
