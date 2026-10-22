from __future__ import annotations

import json
import re
import sqlite3
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

from .constants import LAYER_PAIRS, TILE_TYPES
from .repository import read_gzip_json
from .util import atomic_write_json

STORY_ACTIONS = {
    0: "Say", 1: "Pause", 2: "Padlock", 3: "MapVisibility", 4: "PlayMusic",
    5: "StopMusic", 6: "ShowImage", 7: "HideImage", 8: "Warp",
    9: "PlayerPadlock", 10: "ShowBackground", 11: "HideBackground",
    12: "CreateFNPC", 13: "MoveFNPC", 14: "WarpFNPC", 15: "ChangeFNPCDir",
    16: "DeleteFNPC", 17: "RunScript", 18: "HidePlayers", 19: "ShowPlayers",
    20: "FNPCEmotion", 21: "ChangeWeather", 22: "HideNPCs", 23: "ShowNPCs",
    24: "WaitForMap", 25: "WaitForLoc", 26: "AskQuestion", 27: "GoToSegment",
    28: "ScrollCamera", 29: "ResetCamera", 30: "AddTriggerEvent",
    31: "MovePlayer", 32: "ChangePlayerDir",
}

ITEM_FIELDS = (
    "num", "name", "info", "pic", "item_type", "data1", "data2", "data3",
    "price", "stack_cap", "bound", "loseable", "rarity", "req_data1",
    "req_data2", "req_data3", "req_data4", "req_data5", "scripted_req", "add_hp",
    "add_pp", "add_atk", "add_def", "add_spatk", "add_spdef", "add_speed",
    "add_exp", "attack_speed", "recruit_bonus",
)

# Only passive walkability/collision markers are omitted from the inline trigger index.
# Heal, Kill, Slippery and Slow actively affect an entrant and therefore remain triggers.
NON_TRIGGER_TILE_TYPES = {0, 1, 4, 10}


def _int(value: Any) -> int | None:
    try:
        return int(str(value))
    except (TypeError, ValueError):
        return None


def _map_id(value: Any) -> str | None:
    text = str(value).strip()
    if re.fullmatch(r"s\d+", text):
        return text
    if re.fullmatch(r"\d+", text) and int(text) > 0:
        return f"s{int(text)}"
    return None


def _parse_xy(value: Any) -> tuple[int | None, int | None]:
    bits = str(value).split(":")
    return (_int(bits[0]), _int(bits[1])) if len(bits) >= 2 else (None, None)


def _script_names(scripted_tiles_source: Path) -> dict[int, str]:
    text = scripted_tiles_source.read_text(encoding="utf-8", errors="replace")
    result: dict[int, str] = {}
    for match in re.finditer(
        r"case\s+(\d+)\s*:\s*(?:(?!case\s+\d+\s*:).)*?return\s+scriptNum\s*\+\s*\":\s*([^\"]+)\"",
        text,
        flags=re.DOTALL,
    ):
        result[int(match.group(1))] = match.group(2).strip()
    return result


def _load_stories(con: sqlite3.Connection) -> tuple[list[dict[str, Any]], dict[int, dict[str, Any]]]:
    con.row_factory = sqlite3.Row
    segment_rows = con.execute("SELECT * FROM story_segments ORDER BY story_num,segment").fetchall()
    parameter_rows = con.execute("SELECT * FROM story_params ORDER BY story_num,segment,name").fetchall()
    parameters: dict[tuple[int, int], dict[str, str]] = defaultdict(dict)
    for row in parameter_rows:
        parameters[(row["story_num"], row["segment"])][row["name"]] = row["value"]
    segments: dict[int, list[dict[str, Any]]] = defaultdict(list)
    for row in segment_rows:
        segments[row["story_num"]].append({
            "segment": row["segment"],
            "action": row["action"],
            "action_name": STORY_ACTIONS.get(row["action"], "UNKNOWN"),
            "param": row["param"],
            "parameters": parameters.get((row["story_num"], row["segment"]), {}),
        })
    stories = []
    by_num = {}
    for row in con.execute("SELECT * FROM stories ORDER BY num"):
        story = {
            "num_zero_based": row["num"],
            "tile_reference_value": row["num"] + 1,
            "name": row["name"],
            "declared_segment_count": row["segment_count"],
            "actual_segment_count": len(segments.get(row["num"], [])),
            "legacy_exit_map": row["exit_map"],
            "segments": segments.get(row["num"], []),
        }
        stories.append(story)
        by_num[row["num"]] = story
    return stories, by_num


def _static_script_transition(map_id: str, tile: dict[str, Any]) -> dict[str, Any] | None:
    """Return only destinations proved by the checked-in server implementation."""
    script = tile["data1"]
    target = None
    x = y = None
    condition = None
    evidence = None
    if script == 46:  # Dungeon Complete: param2 map, param3 x:y
        target = _map_id(tile["string2"])
        x, y = _parse_xy(tile["string3"])
        evidence = "ScriptedTiles.cs case 46: ExitDungeon(warpMap, warpX, warpY)"
    elif script in (72, 73):
        target = _map_id(tile["string1"])
        x, y = _int(tile["string2"]), _int(tile["string3"])
        evidence = f"ScriptedTiles.cs case {script}: PlayerWarp(param1,param2,param3)"
        condition = "monitor rank required"
    elif script == 57 and map_id == "s1545":
        target, x, y = "s1546", 9, 9
        evidence = "ScriptedTiles.cs case 57: constant pre-dungeon destination"
        condition = "source map is s1545"
    elif script == 63:
        target, x, y = "s1192", 10, 10
        evidence = "ScriptedTiles.cs case 63: constant PlayerWarp(1192,10,10)"
        condition = "no active tournament match-up"
    elif script == 66:
        target, x, y = "s737", 6, 41
        evidence = "ScriptedTiles.cs case 66: constant fallback PlayerWarp(737,6,41)"
        condition = "dynamic PlazaEntranceMap is empty; primary destination remains UNVERIFIED"
    if not target:
        return None
    return {
        "source": map_id, "target": target, "kind": "scripted_static",
        "source_x": tile["x"], "source_y": tile["y"], "target_x": x, "target_y": y,
        "script_index": script, "condition": condition, "evidence": evidence,
    }


def _story_warp_edges(map_id: str, tile: dict[str, Any], story: dict[str, Any]) -> list[dict[str, Any]]:
    output = []
    for segment in story["segments"]:
        if segment["action"] != 8:
            continue
        params = segment["parameters"]
        target = _map_id(params.get("MapID"))
        if not target:
            continue
        output.append({
            "source": map_id, "target": target, "kind": "story_static",
            "source_x": tile["x"], "source_y": tile["y"],
            "target_x": _int(params.get("X")), "target_y": _int(params.get("Y")),
            "story_num_zero_based": story["num_zero_based"], "story_name": story["name"],
            "story_segment": segment["segment"],
            "evidence": "TileType.Story or scripted story launcher -> StoryAction.Warp MapID/X/Y",
        })
    return output


def _reconcile_blocked_sources(cache_root: Path, global_manifest: dict[str, Any]) -> dict[str, dict[str, Any]]:
    report_path = cache_root / "dat-extraction-report.json"
    report = json.loads(report_path.read_text(encoding="utf-8"))
    blocked = {
        row["map_id"]: row for row in report["blocked_maps"]
        if re.fullmatch(r"s\d+", row["map_id"])
    }
    standard_ids = {entry["map_id"] for entry in global_manifest["maps"]}
    for entry in global_manifest["maps"]:
        row = blocked.get(entry["map_id"])
        if not row:
            continue
        concise = {
            "status": "BLOCKED", "ciphertext_available": True,
            "path": row["path"], "sha256": row["sha256"], "reason": row["reason"],
        }
        entry["blocked_client_dat"] = concise
        manifest_path = Path(entry["manifest"])
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        manifest["provenance"]["client_dat"] = concise
        atomic_write_json(manifest_path, manifest)
    blocked_only = []
    for map_id, row in sorted(blocked.items(), key=lambda pair: int(pair[0][1:])):
        if map_id not in standard_ids:
            blocked_only.append({
                "map_id": map_id, "status": "BLOCKED", "ciphertext_available": True,
                "path": row["path"], "sha256": row["sha256"], "reason": row["reason"],
            })
    global_manifest["status"] = "PARTIAL"
    global_manifest["canonical_snapshot_render_status"] = "RENDERED"
    global_manifest["discovered_standard_map_count"] = len(standard_ids | set(blocked))
    global_manifest["blocked_standard_client_caches"] = {
        "count": len(blocked), "overlap_with_sql_snapshot": len(set(blocked) & standard_ids),
        "blocked_only_count": len(blocked_only), "blocked_only_maps": blocked_only,
        "effect": "No ciphertext is promoted into canonical IR; SQL snapshot outputs remain separately auditable.",
    }
    return blocked


def build_inventories(sql_db: Path, cache_root: Path, server_root: Path) -> dict[str, Any]:
    global_path = cache_root / "global-manifest.json"
    global_manifest = json.loads(global_path.read_text(encoding="utf-8"))
    blocked = _reconcile_blocked_sources(cache_root, global_manifest)
    inventory_root = cache_root / "source" / "inventories"
    inventory_root.mkdir(parents=True, exist_ok=True)

    con = sqlite3.connect(sql_db)
    con.row_factory = sqlite3.Row
    stories, stories_by_num = _load_stories(con)
    script_source = server_root / "Server/Script/ScriptedTiles.cs"
    script_names = _script_names(script_source)

    render_report = json.loads((cache_root / "render-report.json").read_text(encoding="utf-8"))
    render_by_map = {entry["map_id"]: entry for entry in render_report["maps"]}

    animation_maps = []
    npc_placements = []
    npc_definition_references: Counter[int] = Counter()
    object_references = []
    trigger_maps = []
    script_references: dict[int, list[dict[str, Any]]] = defaultdict(list)
    story_references: dict[int, list[dict[str, Any]]] = defaultdict(list)
    scripted_edges = []
    unknown_extensions = []

    for entry in global_manifest["maps"]:
        map_data = read_gzip_json(Path(entry["canonical_source"]))
        map_id = map_data["map_id"]
        animation_refs: dict[tuple[Any, ...], dict[str, Any]] = {}
        type_counts = Counter()
        trigger_locations = []
        for tile in map_data["tiles"]:
            type_counts[tile["type"]] += 1
            for base, base_set, animated, animated_set in LAYER_PAIRS:
                if tile[animated] == 0:
                    continue
                key = (base, tile[base_set], tile[base], tile[animated_set], tile[animated])
                ref = animation_refs.setdefault(key, {
                    "layer": base,
                    "base_frame": {"tileset": tile[base_set], "tile": tile[base]},
                    "animated_replacement_frame": {"tileset": tile[animated_set], "tile": tile[animated]},
                    "locations": [],
                })
                ref["locations"].append([tile["x"], tile["y"]])
            if tile["type"] not in NON_TRIGGER_TILE_TYPES:
                trigger = {
                    key: tile[key] for key in
                    ("x", "y", "type", "data1", "data2", "data3", "string1", "string2", "string3", "light")
                }
                trigger["type_name"] = TILE_TYPES.get(tile["type"], "UNKNOWN")
                trigger_locations.append(trigger)
            if tile["type"] in (3, 5, 6, 17, 39):
                item_num = tile["data1"] if tile["type"] in (3, 5, 6) else (tile["data2"] if tile["type"] == 39 else None)
                object_references.append({
                    "map_id": map_id, "x": tile["x"], "y": tile["y"],
                    "tile_type": tile["type"], "tile_type_name": TILE_TYPES.get(tile["type"], "UNKNOWN"),
                    "item_num": item_num,
                    "interpretation": (
                        "PROVEN: spawned item number (BasicMap.cs Item case)" if tile["type"] == 3
                        else "PROVEN: DropShop item number in Data2 (BasicMap.cs DropShop case)" if tile["type"] == 39
                        else "REFERENCE_PRESERVED; detailed runtime semantics are type-specific"
                    ),
                })
            if tile["type"] == 19:
                script_references[tile["data1"]].append({
                    "map_id": map_id, "x": tile["x"], "y": tile["y"],
                    "param1": tile["string1"], "param2": tile["string2"], "param3": tile["string3"],
                })
                edge = _static_script_transition(map_id, tile)
                if edge:
                    scripted_edges.append(edge)
                if tile["data1"] == 1:
                    story_num = (_int(tile["string1"]) or 0) - 1
                    if story_num in stories_by_num:
                        story_references[story_num].append({"map_id": map_id, "x": tile["x"], "y": tile["y"], "kind": "ScriptedTiles case 1"})
                        scripted_edges.extend(_story_warp_edges(map_id, tile, stories_by_num[story_num]))
            if tile["type"] == 28:
                story_num = tile["data1"] - 1
                if story_num in stories_by_num:
                    story_references[story_num].append({"map_id": map_id, "x": tile["x"], "y": tile["y"], "kind": "TileType.Story Data1-1"})
                    scripted_edges.extend(_story_warp_edges(map_id, tile, stories_by_num[story_num]))
            if tile["type"] not in TILE_TYPES:
                unknown_extensions.append({
                    "map_id": map_id, "x": tile["x"], "y": tile["y"], "type": tile["type"],
                    "payload": {key: tile[key] for key in ("data1", "data2", "data3", "string1", "string2", "string3", "light")},
                    "status": "UNKNOWN", "reason": "value absent from the public PMU TileType enum",
                })
        if animation_refs:
            animation_maps.append({
                "map_id": map_id, "name": map_data["name"],
                "reference_count": sum(len(ref["locations"]) for ref in animation_refs.values()),
                "unique_frame_pair_count": len(animation_refs),
                "rendered_states_pixel_distinct": render_by_map[map_id]["animated_frame_distinct"],
                "frame_pairs": list(animation_refs.values()),
            })
        for preset in map_data["npcs"]:
            npc_definition_references[preset["number"]] += 1
            npc_placements.append({
                "map_id": map_id, "map_name": map_data["name"], **preset,
                "classification": "FUNCTIONAL_RUNTIME_ACTOR",
                "initial_orientation": {
                    "policy": "RUNTIME_RANDOM_CARDINAL", "possible_values": ["Up", "Down", "Left", "Right"],
                    "status": "PROVEN", "source": "PMU-Server/Server/Maps/BasicMap.cs SpawnNpc",
                },
            })
        trigger_maps.append({
            "map_id": map_id, "name": map_data["name"],
            "tile_type_counts": {f"{key}:{TILE_TYPES.get(key, 'UNKNOWN')}": value for key, value in sorted(type_counts.items())},
            "interaction_trigger_count": len(trigger_locations), "interaction_triggers": trigger_locations,
            "canonical_ir": entry["canonical_source"],
        })

    npc_definitions = []
    for row in con.execute("SELECT * FROM npc_defs ORDER BY num"):
        definition = dict(row)
        references = npc_definition_references.get(definition["num"], 0)
        npc_definitions.append({
            "definition": definition, "map_preset_references": references,
            "classification_when_placed": "FUNCTIONAL_RUNTIME_ACTOR",
            "decorative_humanoid_note": "Humanoid-looking layer graphics remain tiles and are not promoted to NPC actors.",
        })

    item_definitions = []
    for row in con.execute("SELECT num,raw_json FROM item_defs ORDER BY num"):
        raw = json.loads(row["raw_json"])
        decoded = {ITEM_FIELDS[index] if index < len(ITEM_FIELDS) else f"unknown_{index}": value for index, value in enumerate(raw)}
        item_definitions.append(decoded)

    for story in stories:
        story["map_references"] = story_references.get(story["num_zero_based"], [])
        story["static_warp_segments"] = [segment for segment in story["segments"] if segment["action"] == 8]

    script_inventory = []
    all_script_ids = sorted(set(script_names) | set(script_references))
    for number in all_script_ids:
        script_inventory.append({
            "script_index": number, "name": script_names.get(number, "UNKNOWN"),
            "map_reference_count": len(script_references.get(number, [])),
            "map_references": script_references.get(number, []),
            "implementation_source": str(script_source),
        })

    animation_inventory = {
        "status": "EXTRACTED", "map_count": len(animation_maps),
        "timing": {"base_state_ms": 250, "animated_replacement_state_ms": 250, "period_ms": 500},
        "render_policy": "exact MapRenderer layer substitution; no interpolation",
        "maps": animation_maps,
    }
    npc_inventory = {
        "status": "EXTRACTED", "placement_count": len(npc_placements),
        "used_definition_count": len(npc_definition_references), "definition_count": len(npc_definitions),
        "runtime_proof": "BasicMap.SpawnNpc instantiates every map preset as an ActiveNpc and chooses a random cardinal direction.",
        "placements": npc_placements, "definitions": npc_definitions,
    }
    object_inventory = {
        "status": "EXTRACTED", "item_definition_count": len(item_definitions),
        "map_reference_count": len(object_references), "item_definitions": item_definitions,
        "map_references": object_references,
    }
    story_inventory = {
        "status": "EXTRACTED", "story_count": len(stories),
        "numbering": "SQL stories.num is zero-based; TileType.Story Data1 and scripted case 1 param1 are one-based and subtract one at runtime.",
        "stories": stories,
    }
    trigger_inventory = {
        "status": "PARTIAL" if unknown_extensions else "EXTRACTED", "map_count": len(trigger_maps),
        "scope": "interaction/event tiles are listed inline; collision/passability types point to each canonical IR to avoid duplicating millions of cells",
        "maps": trigger_maps,
    }
    unknown_inventory = {
        "status": "UNKNOWN", "count": len(unknown_extensions),
        "values": sorted({row["type"] for row in unknown_extensions}),
        "entries": unknown_extensions,
        "decision": "Preserved byte-for-byte in IR and rendering. No semantic label is invented without source evidence.",
    }

    outputs = {
        "animations": inventory_root / "animation-inventory.json",
        "npcs": inventory_root / "npc-inventory.json",
        "objects": inventory_root / "object-inventory.json",
        "stories": inventory_root / "story-inventory.json",
        "scripts": inventory_root / "scripted-tile-inventory.json",
        "triggers": inventory_root / "trigger-inventory.json",
        "unknown_tile_types": inventory_root / "unknown-tile-types.json",
    }
    for name, payload in (
        ("animations", animation_inventory), ("npcs", npc_inventory), ("objects", object_inventory),
        ("stories", story_inventory), ("scripts", {"status": "EXTRACTED", "scripts": script_inventory}),
        ("triggers", trigger_inventory), ("unknown_tile_types", unknown_inventory),
    ):
        atomic_write_json(outputs[name], payload)

    invalid_rows = render_report["invalid_graphic_references"]
    unique_invalid = []
    seen = set()
    for row in invalid_rows:
        key = tuple(row.get(name) for name in ("map_id", "x", "y", "layer", "tileset", "tile", "reason"))
        if key not in seen:
            seen.add(key)
            unique_invalid.append(row)
    invalid_by_map = Counter(row["map_id"] for row in unique_invalid)
    invalid_by_reference = Counter((row["tileset"], row["tile"], row["reason"]) for row in unique_invalid)
    invalid_report = {
        "status": "ANALYZED", "raw_render_event_count": len(invalid_rows),
        "deduplicated_event_count": len(unique_invalid),
        "duplicate_event_count": len(invalid_rows) - len(unique_invalid),
        "affected_map_count": len(invalid_by_map), "by_map": dict(sorted(invalid_by_map.items())),
        "unique_graphic_references": [
            {"tileset": key[0], "tile": key[1], "reason": key[2], "location_count": count}
            for key, count in sorted(invalid_by_reference.items())
        ],
        "events": unique_invalid,
        "renderer_behavior": "Official archive lookup semantics are retained: an out-of-range tile resolves to tile 0; source PNGs are not post-processed.",
    }
    invalid_path = inventory_root / "invalid-graphic-references.json"
    atomic_write_json(invalid_path, invalid_report)

    graph_path = cache_root / "source" / "connection-graph.json"
    graph = json.loads(graph_path.read_text(encoding="utf-8"))
    edge_keys = {
        (edge["source"], edge["target"], edge["kind"], edge.get("source_x"), edge.get("source_y"), edge.get("story_segment"), edge.get("script_index"))
        for edge in graph["edges"]
    }
    for edge in scripted_edges:
        key = (edge["source"], edge["target"], edge["kind"], edge.get("source_x"), edge.get("source_y"), edge.get("story_segment"), edge.get("script_index"))
        if key not in edge_keys:
            graph["edges"].append(edge)
            edge_keys.add(key)
    graph["scope"] = "cardinal transitions, TileType.Warp destinations, and only script/story destinations statically proved by public server source"
    graph["scripted_static_edge_count"] = sum(edge["kind"] in {"scripted_static", "story_static"} for edge in graph["edges"])
    graph["computed_destinations"] = "UNVERIFIED"
    node_ids = {node["id"] for node in graph["nodes"]}
    graph["unresolved_targets"] = sorted({edge["target"] for edge in graph["edges"]} - node_ids, key=lambda value: (_int(value[1:]) or 0))
    atomic_write_json(graph_path, graph)
    dot_path = cache_root / "source" / "connection-graph.dot"
    with dot_path.open("w", encoding="utf-8", newline="\n") as stream:
        stream.write("digraph PMU {\n")
        for edge in graph["edges"]:
            label = edge.get("direction", edge["kind"]).replace('"', "\\\"")
            stream.write(f'  "{edge["source"]}" -> "{edge["target"]}" [label="{label}"];\n')
        stream.write("}\n")

    global_manifest["inventories"].update({
        "animations": str(outputs["animations"]), "npcs": str(outputs["npcs"]),
        "objects": str(outputs["objects"]), "stories": str(outputs["stories"]),
        "scripted_tiles": str(outputs["scripts"]), "triggers": str(outputs["triggers"]),
        "unknown_tile_types": str(outputs["unknown_tile_types"]),
        "invalid_graphic_references": str(invalid_path),
        "connection_edges": len(graph["edges"]), "scripted_static_edges": graph["scripted_static_edge_count"],
    })
    global_manifest["outputs"]["graph"] = str(graph_path)
    global_manifest["unknown_tile_semantics"] = {"count": len(unknown_extensions), "values": unknown_inventory["values"], "status": "UNKNOWN"}
    atomic_write_json(global_path, global_manifest)
    con.close()

    report = {
        "status": "PARTIAL" if blocked or unknown_extensions else "EXTRACTED",
        "map_count": len(global_manifest["maps"]), "animation_map_count": len(animation_maps),
        "npc_placement_count": len(npc_placements), "item_definition_count": len(item_definitions),
        "story_count": len(stories), "scripted_static_edge_count": graph["scripted_static_edge_count"],
        "unknown_tile_count": len(unknown_extensions), "blocked_standard_client_cache_count": len(blocked),
        "invalid_graphic_raw_count": len(invalid_rows), "invalid_graphic_deduplicated_count": len(unique_invalid),
        "outputs": {name: str(path) for name, path in outputs.items()} | {"invalid_graphics": str(invalid_path), "graph": str(graph_path)},
    }
    atomic_write_json(cache_root / "inventory-report.json", report)
    return report
