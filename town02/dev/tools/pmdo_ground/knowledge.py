#!/usr/bin/env python3
"""Read-only knowledge base over native PMDO zones, Grounds and resources."""
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
import hashlib
import json
import re
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


def load_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def walk(value, path=""):
    yield path, value
    if isinstance(value, dict):
        for key, child in value.items():
            yield from walk(child, path + "/" + str(key))
    elif isinstance(value, list):
        for index, child in enumerate(value):
            yield from walk(child, path + f"/{index}")


def _range(value):
    if not isinstance(value, dict):
        return None
    if "Min" in value and "Max" in value:
        return [value["Min"], value["Max"]]
    return None


def _item_category(item_id):
    prefixes = {
        "berry_": "berry", "seed_": "seed", "food_": "food", "orb_": "orb",
        "wand_": "wand", "machine_": "machine", "held_": "held", "ammo_": "ammo",
        "evo_": "evolution", "loot_": "treasure", "key": "key",
    }
    return next((category for prefix, category in prefixes.items() if item_id.startswith(prefix)), "other")


def _zone_profile(path: Path):
    data = load_json(path)
    obj = data.get("Object", {})
    types = Counter()
    textures, species, items, shops, neutral, boss_maps = [], [], [], [], [], []
    for node_path, value in walk(obj):
        if not isinstance(value, dict):
            continue
        type_name = value.get("$type", "").split(",")[0]
        if type_name:
            types[type_name] += 1
        if "GroundTileset" in value and "BlockTileset" in value:
            bundle = [value.get(key, "") for key in ("GroundTileset", "BlockTileset", "WaterTileset")]
            if bundle not in textures:
                textures.append(bundle)
        base = value.get("BaseForm")
        if isinstance(base, dict) and base.get("Species"):
            species.append({
                "species": base["Species"], "level": _range(value.get("Level")),
                "tactic": value.get("Tactic"), "path": node_path,
            })
        spawn = value.get("Spawn")
        if isinstance(spawn, dict) and isinstance(spawn.get("Value"), str) and spawn["Value"]:
            item_id = spawn["Value"]
            items.append({"item_id": item_id, "category": _item_category(item_id), "rate": value.get("Rate"), "path": node_path})
        if "ShopStep" in type_name:
            shops.append({
                "path": node_path, "item_count": len(value.get("Items", [])),
                "items": [row.get("Spawn", {}).get("Value") for row in value.get("Items", []) if row.get("Spawn", {}).get("Value")],
                "security_status": value.get("SecurityStatus"),
                "shopkeeper_species": sorted({
                    row.get("Spawn", {}).get("BaseForm", {}).get("Species")
                    for row in value.get("Mobs", []) if row.get("Spawn", {}).get("BaseForm", {}).get("Species")
                }),
            })
        if "NpcDialogueBattleEvent" in type_name or ("MobSpawnInteractable" in type_name and value.get("Script") != "ShopkeeperInteract"):
            neutral.append({"path": node_path, "type": type_name, "message_key": value.get("Message", {}).get("Key")})
        if "MappedRoomStep" in type_name and value.get("MapID"):
            boss_maps.append(value["MapID"])
    ranges = []
    for segment_index, segment in enumerate(obj.get("Segments", [])):
        floors = segment.get("Floors")
        count = len(floors.get("nodes", [])) if isinstance(floors, dict) else len(floors or [])
        ranges.append({"segment": segment_index, "type": segment.get("$type", "").split(",")[0], "floor_entries": count, "comment": segment.get("Comment", "")})
    return {
        "zone_id": path.stem,
        "name": obj.get("Name", {}),
        "comment": obj.get("Comment", ""),
        "segment_count": len(obj.get("Segments", [])),
        "segments": ranges,
        "ground_maps": obj.get("GroundMaps", []),
        "texture_bundles": textures,
        "species": species,
        "species_ids": sorted({row["species"] for row in species}),
        "items": items,
        "item_ids": sorted({row["item_id"] for row in items}),
        "item_categories": dict(Counter(row["category"] for row in items)),
        "shops": shops,
        "neutral_encounters": neutral,
        "mapped_boss_grounds": sorted(set(boss_maps)),
        "rule_types": {key: count for key, count in types.items() if any(token in key for token in ("Trap", "MonsterHouse", "Status", "Shop", "Spawn", "Terrain", "Money", "Water"))},
        "source_file": f"Data/Zone/{path.name}",
        "source_sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
    }


def _cell_has_frames(cell):
    return any(layer.get("Frames") for layer in cell.get("Layers", [])) or bool(cell.get("AutoTileset"))


def _ground_profile(path: Path):
    data = load_json(path)
    obj = data.get("Object", {})
    obstacles = obj.get("obstacles", [])
    width, height = len(obstacles), len(obstacles[0]) if obstacles else 0
    tags = [[int(obstacles[x][y].get("Tags", 0)) for y in range(height)] for x in range(width)] if obstacles else []
    masks = Counter()
    for x in range(width):
        for y in range(height):
            blocked = tags[x][y] != 0
            mask = 0
            for bit, (dx, dy) in enumerate(((0, -1), (1, 0), (0, 1), (-1, 0))):
                nx, ny = x + dx, y + dy
                if 0 <= nx < width and 0 <= ny < height and (tags[nx][ny] != 0) == blocked:
                    mask |= 1 << bit
            masks[f"{'blocked' if blocked else 'open'}:{mask:02x}"] += 1
    sheets, animation_lengths = Counter(), Counter()
    layers = []
    water_cells = set()
    for layer_index, layer in enumerate(obj.get("Layers", [])):
        name = str(layer.get("Name") or f"layer_{layer_index}")
        tiles = layer.get("Tiles", [])
        non_empty = 0
        for x, column in enumerate(tiles):
            for y, cell in enumerate(column):
                if _cell_has_frames(cell):
                    non_empty += 1
                    if any(word in name.casefold() for word in ("water", "river", "lac", "rivière")):
                        water_cells.add((x, y))
                if cell.get("AutoTileset"):
                    sheets[cell["AutoTileset"]] += 1
                for tile_layer in cell.get("Layers", []):
                    for frame in tile_layer.get("Frames", []):
                        if frame.get("Sheet"):
                            sheets[frame["Sheet"]] += 1
                        if tile_layer.get("FrameLength"):
                            animation_lengths[int(tile_layer["FrameLength"])] += 1
        layers.append({"name": name, "width": len(tiles), "height": len(tiles[0]) if tiles else 0, "non_empty_cells": non_empty})
    object_names, marker_names, char_count, spawner_count = [], [], 0, 0
    for entity_layer in obj.get("Entities", []):
        char_count += len(entity_layer.get("MapChars", []))
        spawner_count += len(entity_layer.get("Spawners", []))
        object_names += [row.get("EntName") for row in entity_layer.get("GroundObjects", []) if row.get("EntName")]
        marker_names += [row.get("EntName") for row in entity_layer.get("Markers", []) if row.get("EntName")]
    return {
        "ground_id": path.stem,
        "name": obj.get("Name", {}),
        "size_cells": [width, height],
        "size_pixels": [width * 8, height * 8],
        "tex_size": obj.get("TexSize", 1),
        "music": obj.get("Music"),
        "view_center": obj.get("ViewCenter"),
        "view_offset": obj.get("ViewOffset"),
        "layers": layers,
        "sheets": dict(sheets),
        "animation_frame_lengths": dict(animation_lengths),
        "water_visual_cell_count": len(water_cells),
        "collision_counts": dict(Counter(str(tags[x][y]) for x in range(width) for y in range(height))),
        "topology_grammar": dict(masks),
        "objects": sorted(set(object_names)),
        "markers": sorted(set(marker_names)),
        "map_char_count": char_count,
        "spawner_count": spawner_count,
        "viewport_policy": "local_follow_camera" if width > 50 or height > 40 else "native_default",
        "source_file": f"Data/Ground/{path.name}",
        "source_sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
    }


def _map_profile(path: Path):
    data = load_json(path)
    obj = data.get("Object", {})
    tiles = obj.get("Tiles", [])
    width, height = len(tiles), len(tiles[0]) if tiles else 0
    texture = obj.get("TextureMap", {})
    return {
        "map_id": path.stem,
        "size_cells": [width, height],
        "entry_points": len(obj.get("EntryPoints", [])),
        "team_spawn_count": len(obj.get("TeamSpawns", [])),
        "script_events": sorted(obj.get("ScriptEvents", {}).keys()) if isinstance(obj.get("ScriptEvents"), dict) else [],
        "texture_bundle": [texture.get(key, "") for key in ("GroundTileset", "BlockTileset", "WaterTileset")] if isinstance(texture, dict) else [],
        "view_center": obj.get("ViewCenter"), "view_offset": obj.get("ViewOffset"),
        "source_file": f"Data/Map/{path.name}",
        "source_sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
    }


def _autotile_profile(path: Path):
    data = load_json(path)
    obj = data.get("Object", {})
    tiles = obj.get("Tiles", {})
    sheets, frame_lengths = Counter(), Counter()
    animated_variants = 0
    for _, value in walk(tiles):
        if not isinstance(value, dict):
            continue
        frames = value.get("Frames", [])
        if len(frames) > 1:
            animated_variants += 1
        if value.get("FrameLength") is not None:
            frame_lengths[int(value["FrameLength"])] += 1
        for frame in frames:
            if frame.get("Sheet"):
                sheets[frame["Sheet"]] += 1
    variant_keys = sorted(key for key in tiles if key.startswith("Tilex"))
    return {
        "autotile_id": path.stem,
        "name": obj.get("Name", {}),
        "grammar_type": tiles.get("$type", "").split(",")[0],
        "variant_keys": variant_keys,
        "variant_count": len(variant_keys),
        "sheets": dict(sheets),
        "frame_lengths": dict(frame_lengths),
        "animated_variant_count": animated_variants,
        "orientation_policy": "native_neighbor_variant_keys_no_arbitrary_flip",
        "source_file": f"Data/AutoTile/{path.name}",
        "source_sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
    }


def _external_library_summary(repo):
    result = []
    games_root = repo / "external/BIBLIOTHEQUE_WORKSPACE/games"
    if games_root.exists():
        for game in sorted(path for path in games_root.iterdir() if path.is_dir()):
            counts = Counter()
            for path in game.rglob("*"):
                if path.is_file():
                    category = path.relative_to(game).parts[0] if len(path.relative_to(game).parts) > 1 else "root"
                    counts[category] += 1
            result.append({
                "library": game.name, "scope": "environment_only",
                "file_count": sum(counts.values()), "categories": dict(sorted(counts.items())),
                "root": f"external/BIBLIOTHEQUE_WORKSPACE/games/{game.name}",
                "policy": "metadata_and_materialized_environment_assets_only_no_cast_no_audio_engine",
            })
    result.append({
        "library": "PMDODump_and_DungeonPack_imports",
        "scope": "already_imported_project_references",
        "root": "Data + docs/INVENTAIRE_PMDODUMP_ET_DUNGEON_PACK.md",
        "policy": "reuse_imported_native_models_before_new_implementation",
    })
    return result


def analyze_references(repo: Path, output: Path | None = None, max_zones: int = 0, max_grounds: int = 96):
    repo = repo.resolve()
    zone_paths = sorted((repo / "Data/Zone").glob("*.json"))[:max_zones or None]
    # Relevant Grounds first, then smaller files so analysis remains bounded.
    preferred = [
        "searing_tunnel_midpoint", "vast_steppe_guardian", "mount_windswept_guardian",
        "searing_crucible", "crooked_den", "altere_pond", "relic_forest",
        "illuminant_riverbed_entrance", "forest_camp", "crooked_cavern_midpoint",
    ]
    all_grounds = list((repo / "Data/Ground").glob("*.rsground"))
    by_name = {path.stem: path for path in all_grounds}
    ground_paths = [by_name[name] for name in preferred if name in by_name]
    remaining = sorted((path for path in all_grounds if path not in ground_paths), key=lambda path: (path.stat().st_size, path.name))
    ground_paths = (ground_paths + remaining)[:max_grounds or None]
    zones, grounds, maps, autotiles, errors = [], [], [], [], []
    for path in zone_paths:
        try:
            zones.append(_zone_profile(path))
        except Exception as exception:
            errors.append({"file": path.as_posix(), "error": str(exception)})
    for path in ground_paths:
        try:
            grounds.append(_ground_profile(path))
        except Exception as exception:
            errors.append({"file": path.as_posix(), "error": str(exception)})
    map_paths = sorted((repo / "Data/Map").glob("*.rsmap"), key=lambda path: (0 if any(word in path.stem for word in ("boss", "guardian", "miniboss")) else 1, path.stat().st_size, path.name))[:96]
    for path in map_paths:
        try:
            maps.append(_map_profile(path))
        except Exception as exception:
            errors.append({"file": f"Data/Map/{path.name}", "error": str(exception)})
    for path in sorted((repo / "Data/AutoTile").glob("*.json")):
        try:
            autotiles.append(_autotile_profile(path))
        except Exception as exception:
            errors.append({"file": f"Data/AutoTile/{path.name}", "error": str(exception)})
    controller_paths = sorted((repo / "Data/Script/halcyon/ground").glob("*/init.lua")) + sorted((repo / "Data/Script/halcyon/zone").glob("*/init.lua"))
    controllers = [{
        "scope": "ground" if "/ground/" in path.as_posix() else "zone",
        "owner_id": path.parent.name,
        "source_file": path.relative_to(repo).as_posix(),
        "callbacks": sorted(set(re.findall(r"function\s+[A-Za-z0-9_]+\.([A-Za-z0-9_]+)\s*\(", path.read_text(encoding="utf-8-sig", errors="ignore")))),
    } for path in controller_paths]
    payload = {
        "schema_version": "1.4.0",
        "result": "REFERENCE_KNOWLEDGE_PASS" if not errors else "REFERENCE_KNOWLEDGE_PARTIAL",
        "zone_count": len(zones), "ground_count": len(grounds), "map_template_count": len(maps), "autotile_count": len(autotiles), "controller_count": len(controllers),
        "shop_reference_zones": [row["zone_id"] for row in zones if row["shops"]],
        "neutral_reference_zones": [row["zone_id"] for row in zones if row["neutral_encounters"]],
        "boss_reference_grounds": sorted({ground for row in zones for ground in row["mapped_boss_grounds"]}),
        "zones": zones, "grounds": grounds, "map_templates": maps, "autotiles": autotiles, "controllers": controllers,
        "external_libraries": _external_library_summary(repo), "errors": errors,
        "principles": {
            "implementation_source_of_truth": "repository_pmdo_data",
            "external_docs_role": "data_shape_only",
            "uncertain_evidence_policy": "conservative_contract_not_invention",
        },
    }
    if output:
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    return payload
