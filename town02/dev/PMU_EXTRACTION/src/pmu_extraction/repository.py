from __future__ import annotations

import gzip
import hashlib
import json
import re
import sqlite3
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any, Iterator

from .constants import MAP_MORAL, NPC_BEHAVIOR, TILE_FIELDS, TILE_TYPES, WEATHER
from .dat_maps import structural_fingerprint
from .util import atomic_write_json

STANDARD_RE = re.compile(r"^s\d+$")


def _as_bool(value: object) -> int:
    if isinstance(value, str):
        return int(value.lower() in {"1", "true", "yes"})
    return int(bool(value))


def load_sql_map(con: sqlite3.Connection, map_id: str) -> dict[str, Any]:
    con.row_factory = sqlite3.Row
    row = con.execute("SELECT * FROM maps WHERE map_id=?", (map_id,)).fetchone()
    if row is None:
        raise KeyError(map_id)
    data = dict(row)
    data["version"] = data["version"] if data["version"] is not None else "UNKNOWN"
    data["source_kind"] = "server_sql"
    for key in ("indoors", "hunger_enabled", "recruitment_enabled", "exp_enabled", "instanced"):
        data[key] = _as_bool(data.get(key))
    data["owner"] = "UNKNOWN"
    data["dungeon_index"] = "UNKNOWN"
    tile_rows = con.execute("SELECT * FROM tiles WHERE map_id=? ORDER BY x,y", (map_id,)).fetchall()
    data["tiles"] = []
    for tile_row in tile_rows:
        tile_dict = dict(tile_row)
        tile_dict.pop("map_id")
        data["tiles"].append(tile_dict)
    npc_rows = con.execute("SELECT * FROM map_npcs WHERE map_id=? ORDER BY slot", (map_id,)).fetchall()
    data["npcs"] = []
    for npc_row in npc_rows:
        npc_dict = dict(npc_row)
        npc_dict.pop("map_id")
        data["npcs"].append(npc_dict)
    data.pop("sql_present", None)
    return data


def load_dat_maps(directory: Path) -> dict[str, tuple[Path, dict[str, Any]]]:
    result = {}
    for path in sorted(directory.glob("*.json")):
        data = json.loads(path.read_text(encoding="utf-8"))
        result[data["map_id"]] = (path, data)
    return result


def normalized_common(map_data: dict[str, Any]) -> dict[str, Any]:
    keys = (
        "map_id", "revision", "max_x", "max_y", "name", "moral", "music", "indoors",
        "weather", "darkness", "hunger_enabled", "recruitment_enabled", "exp_enabled",
        "time_limit", "min_npcs", "max_npcs", "npc_spawn_time", "up_map", "down_map",
        "left_map", "right_map", "instanced", "npcs", "tiles",
    )
    output = {key: map_data.get(key) for key in keys}
    output["npcs"] = sorted(output["npcs"], key=lambda value: value["slot"])
    output["tiles"] = sorted(output["tiles"], key=lambda value: (value["x"], value["y"]))
    return output


def difference_summary(sql_map: dict[str, Any], dat_map: dict[str, Any]) -> dict[str, Any]:
    left = normalized_common(sql_map); right = normalized_common(dat_map)
    metadata_fields = [key for key in left if key not in {"tiles", "npcs"} and left[key] != right[key]]
    sql_tiles = {(tile["x"], tile["y"]): tile for tile in left["tiles"]}
    dat_tiles = {(tile["x"], tile["y"]): tile for tile in right["tiles"]}
    tile_differences = sum(sql_tiles.get(coord) != dat_tiles.get(coord) for coord in set(sql_tiles) | set(dat_tiles))
    return {
        "exact_common_structure": left == right,
        "metadata_fields_different": metadata_fields,
        "tile_coordinates_different": tile_differences,
        "npc_presets_different": left["npcs"] != right["npcs"],
        "sql_common_sha256": structural_fingerprint(left),
        "dat_common_sha256": structural_fingerprint(right),
    }


def write_gzip_json(path: Path, value: Any) -> str:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")
    with path.open("wb") as raw:
        with gzip.GzipFile(filename="", mode="wb", fileobj=raw, mtime=0, compresslevel=9) as stream:
            stream.write(payload)
    return hashlib.sha256(payload).hexdigest()


def read_gzip_json(path: Path) -> dict[str, Any]:
    with gzip.open(path, "rt", encoding="utf-8") as stream:
        return json.load(stream)


def _npc_definition(con: sqlite3.Connection, number: int) -> dict[str, Any] | None:
    con.row_factory = sqlite3.Row
    row = con.execute("SELECT * FROM npc_defs WHERE num=?", (number,)).fetchone()
    if row is None:
        return None
    result = dict(row)
    result["behavior_name"] = NPC_BEHAVIOR.get(result["behavior"], "UNKNOWN")
    # BasicMap.SpawnNpc proves that every map preset is instantiated as an ActiveNpc.
    # Humanoid-looking decoration stored in the five graphic layers remains tile art.
    result["functional_vs_decoration"] = "FUNCTIONAL_RUNTIME_ACTOR"
    result["initial_orientation"] = {
        "policy": "RUNTIME_RANDOM_CARDINAL",
        "possible_values": ["Up", "Down", "Left", "Right"],
        "source": "PMU-Server/Server/Maps/BasicMap.cs SpawnNpc",
    }
    return result


def build_map_manifest(map_data: dict[str, Any], provenance: dict[str, Any], canonical_path: Path, canonical_sha: str, con: sqlite3.Connection) -> dict[str, Any]:
    tile_types = Counter(tile["type"] for tile in map_data["tiles"])
    tilesets = Counter()
    layers = {}
    animation_cells = 0
    for base, base_set, anim, anim_set in (
        ("ground", "ground_tileset", "ground_anim", "ground_anim_tileset"),
        ("mask", "mask_tileset", "mask_anim", "mask_anim_tileset"),
        ("mask2", "mask2_tileset", "mask2_anim", "mask2_anim_tileset"),
        ("fringe", "fringe_tileset", "fringe_anim", "fringe_anim_tileset"),
        ("fringe2", "fringe2_tileset", "fringe2_anim", "fringe2_anim_tileset"),
    ):
        base_count = sum(tile[base] != 0 for tile in map_data["tiles"])
        anim_count = sum(tile[anim] != 0 for tile in map_data["tiles"])
        layers[base] = {"base_cells": base_count, "animated_replacement_cells": anim_count}
        animation_cells += anim_count
        for tile in map_data["tiles"]:
            if tile[base] != 0: tilesets[tile[base_set]] += 1
            if tile[anim] != 0: tilesets[tile[anim_set]] += 1
    attributes = []
    warps = []
    for tile in map_data["tiles"]:
        if tile["type"] != 0:
            attribute = {key: tile[key] for key in ("x", "y", "type", "data1", "data2", "data3", "string1", "string2", "string3", "light")}
            attribute["type_name"] = TILE_TYPES.get(tile["type"], "UNKNOWN")
            attributes.append(attribute)
            if tile["type"] == 2 and tile["data1"] > 0:
                warps.append({"x": tile["x"], "y": tile["y"], "target_map": f"s{tile['data1']}", "target_x": tile["data2"], "target_y": tile["data3"], "evidence": "Warp Data1/Data2/Data3"})
    npc_presets = []
    for preset in map_data["npcs"]:
        expanded = dict(preset)
        expanded["definition"] = _npc_definition(con, preset["number"])
        npc_presets.append(expanded)
    width = map_data["max_x"] + 1; height = map_data["max_y"] + 1
    complete = len(map_data["tiles"]) == width * height and len({(t["x"], t["y"]) for t in map_data["tiles"]}) == width * height
    return {
        "schema_version": 1,
        "status": "EXTRACTED" if complete else "PARTIAL",
        "map_id": map_data["map_id"], "name": map_data.get("name", ""),
        "revision": map_data.get("revision"),
        "dimensions": {"max_x_inclusive": map_data["max_x"], "max_y_inclusive": map_data["max_y"], "width_tiles": width, "height_tiles": height, "width_pixels": width * 32, "height_pixels": height * 32, "tile_size_pixels": 32},
        "properties": {
            "moral": {"value": map_data.get("moral"), "name": MAP_MORAL.get(map_data.get("moral"), "UNKNOWN")},
            "music": map_data.get("music"), "indoors": bool(map_data.get("indoors")),
            "weather": {"value": map_data.get("weather"), "name": WEATHER.get(map_data.get("weather"), "UNKNOWN")},
            "darkness": map_data.get("darkness"), "hunger_enabled": bool(map_data.get("hunger_enabled")),
            "recruitment_enabled": bool(map_data.get("recruitment_enabled")), "exp_enabled": bool(map_data.get("exp_enabled")),
            "time_limit": map_data.get("time_limit"), "instanced": bool(map_data.get("instanced")),
            "owner": map_data.get("owner", "UNKNOWN"), "dungeon_index": map_data.get("dungeon_index", "UNKNOWN"),
            "npc_population": {"minimum": map_data.get("min_npcs"), "maximum": map_data.get("max_npcs"), "spawn_time": map_data.get("npc_spawn_time")},
        },
        "cardinal_connections": {direction: (f"s{map_data.get(key)}" if (map_data.get(key) or 0) > 0 else None) for direction, key in (("up", "up_map"), ("down", "down_map"), ("left", "left_map"), ("right", "right_map"))},
        "warp_connections": warps,
        "layers": layers, "animated_replacement_reference_count": animation_cells,
        "animation": {"states": ["base", "animated_replacement"], "state_duration_ms": 250, "period_ms": 500, "source": "MapViewer.OnTick + MapRenderer.DrawTiles"},
        "tileset_reference_counts": {str(key): value for key, value in sorted(tilesets.items())},
        "tile_type_counts": {f"{key}:{TILE_TYPES.get(key, 'UNKNOWN')}": value for key, value in sorted(tile_types.items())},
        "attributes": attributes, "npc_presets": npc_presets,
        "structural_validation": {"expected_tiles": width * height, "actual_tiles": len(map_data["tiles"]), "unique_coordinates": len({(t["x"], t["y"]) for t in map_data["tiles"]}), "complete": complete},
        "canonical_structured_source": {"path": str(canonical_path), "uncompressed_json_sha256": canonical_sha},
        "provenance": provenance,
        "render": {"status": "DISCOVERED"},
    }


def manifest_markdown(manifest: dict[str, Any]) -> str:
    dims = manifest["dimensions"]
    lines = [
        f"# {manifest['map_id']} — {manifest['name'] or '(sans nom)'}", "",
        f"- **État source :** `{manifest['status']}`",
        f"- **Révision :** `{manifest['revision']}`",
        f"- **Dimensions :** {dims['width_tiles']}×{dims['height_tiles']} tiles / {dims['width_pixels']}×{dims['height_pixels']} px",
        f"- **Source canonique :** `{manifest['provenance']['selected_source']}`",
        f"- **Cellules animées (références) :** {manifest['animated_replacement_reference_count']}",
        f"- **NPC presets :** {len(manifest['npc_presets'])}",
        f"- **Warps directs :** {len(manifest['warp_connections'])}", "",
        "## Connexions cardinales", "",
    ]
    for direction, target in manifest["cardinal_connections"].items():
        lines.append(f"- {direction}: `{target or 'aucune'}`")
    lines += ["", "## Couches", ""]
    for layer, counts in manifest["layers"].items():
        lines.append(f"- **{layer}** : {counts['base_cells']} base, {counts['animated_replacement_cells']} remplacements animés")
    lines += ["", "## Provenance", "", "```json", json.dumps(manifest["provenance"], ensure_ascii=False, indent=2, sort_keys=True), "```", ""]
    return "\n".join(lines)


def build_canonical_repository(sql_db: Path, dat_directory: Path, output_root: Path, global_manifest_path: Path) -> dict:
    maps_dir = output_root / "source" / "maps"
    manifests_dir = output_root / "source" / "manifests"
    markdown_dir = output_root / "source" / "manifests-md"
    maps_dir.mkdir(parents=True, exist_ok=True); manifests_dir.mkdir(parents=True, exist_ok=True); markdown_dir.mkdir(parents=True, exist_ok=True)
    dat_maps = load_dat_maps(dat_directory)
    con = sqlite3.connect(sql_db)
    con.row_factory = sqlite3.Row
    sql_ids = [row[0] for row in con.execute("SELECT map_id FROM maps ORDER BY CAST(SUBSTR(map_id,2) AS INTEGER)")]
    dat_standard_ids = [map_id for map_id in dat_maps if STANDARD_RE.fullmatch(map_id)]
    map_ids = sorted(set(sql_ids) | set(dat_standard_ids), key=lambda value: int(value[1:]))
    global_entries = []
    graph_edges = []
    tile_type_totals: Counter[int] = Counter()
    tileset_totals: Counter[int] = Counter()
    source_counts: Counter[str] = Counter()
    overlap_counts: Counter[str] = Counter()
    used_npcs: Counter[int] = Counter()
    for map_id in map_ids:
        sql_map = load_sql_map(con, map_id) if map_id in set(sql_ids) else None
        dat_info = dat_maps.get(map_id)
        dat_path, dat_map = dat_info if dat_info else (None, None)
        comparison = difference_summary(sql_map, dat_map) if sql_map and dat_map else None
        if dat_map and (not sql_map or dat_map["revision"] >= sql_map["revision"]):
            selected = dat_map; selected_source = "client_v9_dat"; selected_path = dat_path
        else:
            selected = sql_map; selected_source = "server_sql"; selected_path = sql_db
        source_counts[selected_source] += 1
        if comparison:
            overlap_counts["exact" if comparison["exact_common_structure"] else "different"] += 1
        provenance = {
            "selected_source": selected_source,
            "selection_rule": "higher revision; client V9 .dat wins revision ties because it is the exact client cache serializer output",
            "selected_revision": selected["revision"],
            "selected_path": str(selected_path),
            "sql": ({"available": True, "revision": sql_map["revision"], "database": str(sql_db)} if sql_map else {"available": False}),
            "client_dat": ({"available": True, "revision": dat_map["revision"], "decoded_json": str(dat_path)} if dat_map else {"available": False}),
            "overlap_comparison": comparison,
        }
        canonical_path = maps_dir / f"{map_id}.json.gz"
        canonical_sha = write_gzip_json(canonical_path, selected)
        manifest = build_map_manifest(selected, provenance, canonical_path, canonical_sha, con)
        manifest_path = manifests_dir / f"{map_id}.json"
        atomic_write_json(manifest_path, manifest)
        (markdown_dir / f"{map_id}.md").write_text(manifest_markdown(manifest), encoding="utf-8", newline="\n")
        for key, value in manifest["tile_type_counts"].items(): tile_type_totals[int(key.split(":",1)[0])] += value
        for key, value in manifest["tileset_reference_counts"].items(): tileset_totals[int(key)] += value
        for npc in selected["npcs"]: used_npcs[npc["number"]] += 1
        for direction, target in manifest["cardinal_connections"].items():
            if target: graph_edges.append({"source": map_id, "target": target, "kind": "cardinal", "direction": direction})
        for warp in manifest["warp_connections"]:
            graph_edges.append({"source": map_id, "target": warp["target_map"], "kind": "warp", "source_x": warp["x"], "source_y": warp["y"], "target_x": warp["target_x"], "target_y": warp["target_y"]})
        global_entries.append({
            "map_id": map_id, "name": selected.get("name", ""), "revision": selected["revision"],
            "status": manifest["status"], "selected_source": selected_source,
            "dimensions": manifest["dimensions"], "animated_reference_count": manifest["animated_replacement_reference_count"],
            "attribute_count": len(manifest["attributes"]), "npc_preset_count": len(manifest["npc_presets"]),
            "warp_count": len(manifest["warp_connections"]), "canonical_json_sha256": canonical_sha,
            "manifest": str(manifest_path), "canonical_source": str(canonical_path),
        })
    graph = {
        "status": "EXTRACTED",
        "scope": "cardinal map switchovers and direct TileType.Warp destinations; script-computed transitions remain explicitly UNVERIFIED",
        "nodes": [{"id": entry["map_id"], "name": entry["name"]} for entry in global_entries],
        "edges": graph_edges,
        "unresolved_targets": sorted({e["target"] for e in graph_edges} - set(map_ids)),
    }
    atomic_write_json(output_root / "source" / "connection-graph.json", graph)
    with (output_root / "source" / "connection-graph.dot").open("w", encoding="utf-8", newline="\n") as stream:
        stream.write("digraph PMU {\n")
        for edge in graph_edges:
            label = edge.get("direction", edge["kind"])
            stream.write(f'  "{edge["source"]}" -> "{edge["target"]}" [label="{label}"];\n')
        stream.write("}\n")
    npc_inventory = []
    for number, references in sorted(used_npcs.items()):
        definition = _npc_definition(con, number)
        npc_inventory.append({"number": number, "map_preset_references": references, "definition": definition, "status": "EXTRACTED" if definition else "UNKNOWN"})
    atomic_write_json(output_root / "source" / "npc-inventory.json", npc_inventory)
    global_manifest = {
        "schema_version": 1, "status": "EXTRACTED" if all(e["status"] == "EXTRACTED" for e in global_entries) else "PARTIAL",
        "phase": 1, "phase_2_pmdo": "BLOCKED until phase 1 SOURCE_CERTIFIED",
        "scope": "all canonical standard maps available from SQL plus standard client V9 .dat maps",
        "map_count": len(global_entries), "source_selection_counts": dict(source_counts),
        "sql_dat_overlap": dict(overlap_counts), "maps": global_entries,
        "inventories": {
            "tile_types": {f"{key}:{TILE_TYPES.get(key, 'UNKNOWN')}": value for key, value in sorted(tile_type_totals.items())},
            "tileset_references": {str(key): value for key, value in sorted(tileset_totals.items())},
            "used_npc_definitions": len(npc_inventory), "connection_edges": len(graph_edges),
        },
        "outputs": {"root": str(output_root), "graph": str(output_root / "source" / "connection-graph.json"), "npc_inventory": str(output_root / "source" / "npc-inventory.json")},
    }
    atomic_write_json(global_manifest_path, global_manifest)
    con.close()
    return global_manifest
