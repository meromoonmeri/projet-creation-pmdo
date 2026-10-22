#!/usr/bin/env python3
"""Inventory Relict's environmental maps without executing source code.

Outputs preserve every map tile value, raw collision table, derived directional
collision cell, and event/page placement. Character graphic identities are
irreversibly redacted to hashes so New Era actors can replace the source cast
without importing its sprites or names.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import struct
import subprocess
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

from ruby_marshal import (
    RubyObject,
    RubyTable,
    RubyUserData,
    decode_table,
    decode_text,
    ivar,
    load,
)

WORKSPACE = Path(__file__).resolve().parents[1]
REPO_ROOT = WORKSPACE.parents[1]
DEFAULT_SOURCE = REPO_ROOT / "external/BIBLIOTHEQUE/Relict/Relict V1.2/Relict"
DEFAULT_OUTPUT = WORKSPACE / "games/relict"
SOURCE_REPOSITORY = "https://github.com/meromoonmeri/BIBLIOTHEQUE"
EXPECTED_SOURCE_COMMIT = "6963878956ec4c53833c03f26aa6a9aafd17800f"
SCHEMA_VERSION = "1.0.0"
TILE_SIZE = 32

CANONICAL_MAP_RE = re.compile(r"^Map(?P<id>[0-9]{3})\.rxdata$")
VARIANT_MAP_RE = re.compile(r"^Map(?P<id>[0-9]{3}) \((?P<label>.+)\)\.rxdata$")

VISUAL_COMMANDS = {
    201: "map_transfer",
    202: "entity_relocation",
    203: "map_scroll",
    204: "map_visual_settings",
    207: "animation_on_entity",
    209: "forced_move_route",
    221: "transition_prepare",
    222: "transition_execute",
    223: "screen_tone",
    224: "screen_flash",
    225: "screen_shake",
    231: "picture_show",
    232: "picture_move",
    233: "picture_rotate",
    234: "picture_tone",
    235: "picture_erase",
    236: "weather",
}
EXCLUDED_COMMANDS = {
    101: "dialogue_commands_redacted",
    102: "choice_commands_redacted",
    401: "dialogue_continuation_commands_redacted",
    355: "script_commands_redacted",
    655: "script_continuation_commands_redacted",
    241: "audio_commands_redacted",
    242: "audio_commands_redacted",
    245: "audio_commands_redacted",
    246: "audio_commands_redacted",
    249: "audio_commands_redacted",
    250: "audio_commands_redacted",
}
DIRECTION_BITS = (("down", 0x01), ("left", 0x02), ("right", 0x04), ("up", 0x08))


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def write_json(path: Path, payload: Any) -> str:
    path.parent.mkdir(parents=True, exist_ok=True)
    data = (json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True) + "\n").encode()
    path.write_bytes(data)
    return sha256_bytes(data)


def relpath(path: Path, root: Path) -> str:
    return path.relative_to(root).as_posix()


def source_provenance(path: Path, source: Path, commit: str, source_format: str) -> dict[str, Any]:
    return {
        "repository": SOURCE_REPOSITORY,
        "commit": commit,
        "source_path": relpath(path, source.parents[2]),
        "sha256": sha256_file(path),
        "size_bytes": path.stat().st_size,
        "source_format": source_format,
        "extraction_method": "bounded pure-Python Ruby Marshal 4.8 reader; no source code execution",
        "license_status": "UNKNOWN",
    }


def slug(value: str) -> str:
    value = value.casefold().replace("'", "")
    value = re.sub(r"[^a-z0-9]+", "_", value).strip("_")
    return value or "unnamed"


def object_ivars(value: Any) -> dict[str, Any]:
    return value.ivars if isinstance(value, RubyObject) else {}


def table_rows(table: RubyTable) -> list[dict[str, Any]]:
    layers = []
    plane = table.x_size * table.y_size
    for z in range(table.z_size):
        rows = []
        offset = z * plane
        for y in range(table.y_size):
            start = offset + y * table.x_size
            rows.append(list(table.values[start : start + table.x_size]))
        flat = table.values[offset : offset + plane]
        layers.append({
            "index": z,
            "rows": rows,
            "nonzero_count": sum(value != 0 for value in flat),
            "unique_tile_id_count": len(set(flat)),
            "maximum_tile_id": max(flat, default=0),
        })
    return layers


def decode_table_values(value: Any) -> list[int]:
    if not isinstance(value, RubyUserData):
        return []
    return list(decode_table(value).values)


def safe_scalar_parameters(parameters: Any) -> tuple[list[Any], int, str | None]:
    if not isinstance(parameters, list):
        return [], 0, None
    safe: list[Any] = []
    redacted: list[str] = []
    for value in parameters:
        if value is None or isinstance(value, (bool, int, float)):
            safe.append(value)
        else:
            if isinstance(value, (bytes, bytearray, str)):
                redacted.append(decode_text(value))
            else:
                redacted.append(type(value).__name__)
    digest = sha256_bytes("\u241f".join(redacted).encode()) if redacted else None
    return safe, len(redacted), digest


def movement_route(route: Any) -> tuple[bool, bool, list[dict[str, Any]]]:
    if not isinstance(route, RubyObject):
        return False, False, []
    commands = []
    for command in ivar(route, "list", []) or []:
        if not isinstance(command, RubyObject):
            continue
        safe, count, digest = safe_scalar_parameters(ivar(command, "parameters", []))
        commands.append({
            "code": int(ivar(command, "code", 0)),
            "safe_parameters": safe,
            "redacted_parameter_count": count,
            "redacted_parameter_sha256": digest,
        })
    return bool(ivar(route, "repeat", False)), bool(ivar(route, "skippable", False)), commands


def condition_flags(condition: Any) -> dict[str, Any]:
    fields = (
        "switch1_valid", "switch2_valid", "variable_valid", "self_switch_valid",
        "switch1_id", "switch2_id", "variable_id", "variable_value", "self_switch_ch",
    )
    result = {}
    for field in fields:
        value = ivar(condition, field, False if field.endswith("_valid") else 0)
        if field == "self_switch_ch":
            value = decode_text(value)
        result[field] = value
    return result


def entity_placements(map_id: int, events: Any) -> tuple[dict[str, Any], dict[str, int]]:
    placements = []
    counts = Counter()
    if not isinstance(events, dict):
        events = {}
    for event_id, event in sorted(events.items(), key=lambda pair: int(pair[0])):
        if not isinstance(event, RubyObject):
            continue
        x = int(ivar(event, "x", 0))
        y = int(ivar(event, "y", 0))
        pages = ivar(event, "pages", []) or []
        event_has_graphic = False
        for page_index, page in enumerate(pages):
            if not isinstance(page, RubyObject):
                continue
            graphic = ivar(page, "graphic")
            character_name = decode_text(ivar(graphic, "character_name", ""))
            tile_id = int(ivar(graphic, "tile_id", 0))
            if character_name:
                classification = "CAST_PLACEHOLDER"
                identity_hash = sha256_bytes(character_name.encode())
                event_has_graphic = True
            elif tile_id > 0:
                classification = "ENVIRONMENTAL_TILE_ENTITY"
                identity_hash = None
                event_has_graphic = True
            else:
                classification = "LOGIC_MARKER"
                identity_hash = None
            counts[classification] += 1
            visual = Counter()
            excluded = Counter()
            for command in ivar(page, "list", []) or []:
                code = int(ivar(command, "code", 0))
                if code in VISUAL_COMMANDS:
                    visual[VISUAL_COMMANDS[code]] += 1
                if code in EXCLUDED_COMMANDS:
                    excluded[EXCLUDED_COMMANDS[code]] += 1
            repeat, skippable, route = movement_route(ivar(page, "move_route"))
            placements.append({
                "placeholder_id": f"map_{map_id:03d}_entity_{int(event_id):04d}_page_{page_index:02d}",
                "source_event_id": int(event_id),
                "page_index": page_index,
                "classification": classification,
                "position": {"x": x, "y": y},
                "graphic": {
                    "source_identity_redacted": True,
                    "source_identity_sha256": identity_hash,
                    "tile_id": tile_id,
                    "direction": int(ivar(graphic, "direction", 2)),
                    "pattern": int(ivar(graphic, "pattern", 0)),
                    "opacity": int(ivar(graphic, "opacity", 255)),
                    "blend_type": int(ivar(graphic, "blend_type", 0)),
                },
                "movement": {
                    "type": int(ivar(page, "move_type", 0)),
                    "speed": int(ivar(page, "move_speed", 3)),
                    "frequency": int(ivar(page, "move_frequency", 3)),
                    "walk_animation": bool(ivar(page, "walk_anime", True)),
                    "step_animation": bool(ivar(page, "step_anime", False)),
                    "direction_fix": bool(ivar(page, "direction_fix", False)),
                    "route_repeat": repeat,
                    "route_skippable": skippable,
                    "route_commands": route,
                },
                "collision": {
                    "through": bool(ivar(page, "through", False)),
                    "always_on_top": bool(ivar(page, "always_on_top", False)),
                    "dynamic": True,
                },
                "trigger": int(ivar(page, "trigger", 0)),
                "condition_flags": condition_flags(ivar(page, "condition")),
                "visual_commands": dict(sorted(visual.items())),
                "excluded_command_counts": dict(sorted(excluded.items())),
            })
        if event_has_graphic:
            counts["source_events_with_graphics"] += 1
    return {
        "schema_version": SCHEMA_VERSION,
        "map_id": map_id,
        "source_complete": True,
        "source_event_count": len(events),
        "page_placement_count": len(placements),
        "source_identities_redacted": True,
        "placements": placements,
    }, dict(counts)


def tileset_tables(tileset_id: int, tileset: RubyObject) -> dict[str, Any]:
    return {
        "schema_version": SCHEMA_VERSION,
        "tileset_id": tileset_id,
        "source_complete": True,
        "passage_flag_legend": {
            "down_blocked": 1,
            "left_blocked": 2,
            "right_blocked": 4,
            "up_blocked": 8,
            "star_no_effect_on_lower_layer": 16,
        },
        "passages": decode_table_values(ivar(tileset, "passages")),
        "priorities": decode_table_values(ivar(tileset, "priorities")),
        "terrain_tags": decode_table_values(ivar(tileset, "terrain_tags")),
    }


def derived_collision(
    table: RubyTable, passages: list[int], priorities: list[int], terrain_tags: list[int]
) -> dict[str, Any]:
    plane = table.x_size * table.y_size
    direction_rows = []
    terrain_rows = []
    top_tile_rows = []
    for y in range(table.y_size):
        direction_row = []
        terrain_row = []
        top_tile_row = []
        for x in range(table.x_size):
            tile_stack = [table.values[z * plane + y * table.x_size + x] for z in range(table.z_size)]
            allowed = 0
            effective_tile = 0
            terrain = 0
            for _, bit in DIRECTION_BITS:
                # RGSS1 checks layers top-down. A directional passage bit blocks
                # immediately; otherwise only a priority-0 tile decides passability.
                # Higher-priority overlays (including empty tile 0 here) are skipped.
                direction_allowed = True
                for tile_id in reversed(tile_stack):
                    if tile_id >= len(passages) or tile_id >= len(priorities):
                        direction_allowed = False
                        break
                    flag = passages[tile_id]
                    if (flag & bit) or (flag & 0x0F) == 0x0F:
                        direction_allowed = False
                        break
                    if priorities[tile_id] == 0:
                        direction_allowed = True
                        break
                if direction_allowed:
                    allowed |= bit
            for tile_id in reversed(tile_stack):
                if tile_id >= len(priorities):
                    break
                if priorities[tile_id] != 0:
                    continue
                effective_tile = tile_id
                terrain = terrain_tags[tile_id] if tile_id < len(terrain_tags) else 0
                break
            direction_row.append(allowed)
            terrain_row.append(terrain)
            top_tile_row.append(effective_tile)
        direction_rows.append(direction_row)
        terrain_rows.append(terrain_row)
        top_tile_rows.append(top_tile_row)
    return {
        "schema_version": SCHEMA_VERSION,
        "method": "RGSS1_STANDARD_PRIORITY_AND_PASSAGE_FLAGS",
        "custom_script_overrides_executed": False,
        "directions": {name: bit for name, bit in DIRECTION_BITS},
        "width": table.x_size,
        "height": table.y_size,
        "allowed_direction_masks": direction_rows,
        "effective_terrain_tags": terrain_rows,
        "effective_tile_ids": top_tile_rows,
    }


def image_dimensions(path: Path) -> tuple[int, int] | None:
    data = path.read_bytes()[:32]
    if data.startswith(b"\x89PNG\r\n\x1a\n") and len(data) >= 24:
        return struct.unpack(">II", data[16:24])
    if data[:6] in (b"GIF87a", b"GIF89a") and len(data) >= 10:
        return struct.unpack("<HH", data[6:10])
    if data.startswith(b"BM") and len(data) >= 26:
        return struct.unpack("<II", data[18:26])
    return None


def graphics_index(source: Path) -> dict[str, dict[str, list[Path]]]:
    result: dict[str, dict[str, list[Path]]] = {}
    for category in ("Tilesets", "Autotiles", "Fogs", "Panoramas", "Weather"):
        root = source / "Graphics" / category
        by_stem: dict[str, list[Path]] = defaultdict(list)
        if root.is_dir():
            for path in sorted(root.rglob("*")):
                if path.is_file():
                    by_stem[path.stem.casefold()].append(path)
        result[category] = by_stem
    return result


def dependency_record(kind: str, name: str, source: Path, index: dict[str, dict[str, list[Path]]], commit: str) -> dict[str, Any] | None:
    if not name:
        return None
    category = {
        "TILESET": "Tilesets", "AUTOTILE": "Autotiles", "FOG": "Fogs",
        "PANORAMA": "Panoramas", "WEATHER": "Weather",
    }[kind]
    matches = sorted(
        index[category].get(name.casefold(), []),
        key=lambda path: (
            "backup" in {part.casefold() for part in path.relative_to(source / "Graphics" / category).parts},
            len(path.relative_to(source / "Graphics" / category).parts),
            path.as_posix().casefold(),
        ),
    )
    if not matches:
        return {"kind": kind, "source_name": name, "resolved": False, "problems": ["SOURCE_FILE_MISSING"]}
    path = matches[0]
    dims = image_dimensions(path)
    return {
        "kind": kind,
        "source_name": name,
        "resolved": True,
        "source_path": relpath(path, source),
        "sha256": sha256_file(path),
        "size_bytes": path.stat().st_size,
        "dimensions": {"width_px": dims[0], "height_px": dims[1]} if dims else None,
        "ambiguous_match_count": len(matches),
        "problems": ["AMBIGUOUS_CASE_INSENSITIVE_MATCH"] if len(matches) > 1 else [],
        "source_commit": commit,
    }


def tileset_descriptor(tileset_id: int, tileset: RubyObject) -> dict[str, Any]:
    names = [decode_text(name) for name in (ivar(tileset, "autotile_names", []) or [])]
    names = (names + [""] * 7)[:7]
    return {
        "source_id": tileset_id,
        "name": decode_text(ivar(tileset, "tileset_name", "")),
        "autotile_slots": [{"slot": index, "name": name} for index, name in enumerate(names)],
        "panorama": decode_text(ivar(tileset, "panorama_name", "")),
        "fog": decode_text(ivar(tileset, "fog_name", "")),
    }


def visual_dependencies(tileset: RubyObject, source: Path, index: dict[str, dict[str, list[Path]]], commit: str) -> list[dict[str, Any]]:
    records = []
    candidates = [("TILESET", decode_text(ivar(tileset, "tileset_name", "")))]
    candidates.extend(("AUTOTILE", decode_text(name)) for name in (ivar(tileset, "autotile_names", []) or []))
    candidates.extend([
        ("PANORAMA", decode_text(ivar(tileset, "panorama_name", ""))),
        ("FOG", decode_text(ivar(tileset, "fog_name", ""))),
    ])
    seen = set()
    for kind, name in candidates:
        if not name or (kind, name.casefold()) in seen:
            continue
        seen.add((kind, name.casefold()))
        record = dependency_record(kind, name, source, index, commit)
        if record:
            records.append(record)
    return sorted(records, key=lambda row: (row["kind"], row["source_name"].casefold()))


def infer_zone_type(name: str) -> str:
    lowered = name.casefold()
    if any(word in lowered for word in ("scene", "intro", "ending", "escenas")):
        return "CINEMATIC"
    if "boss" in lowered:
        return "BOSS"
    if any(word in lowered for word in ("tower", "summit")):
        return "DUNGEON"
    if any(word in lowered for word in ("house", "retreat", "resting place")):
        return "INTERIOR"
    if any(word in lowered for word in ("icelands", "coastlands", "mt.coronet", "playa")):
        return "EXTERIOR"
    if any(word in lowered for word in ("templates", "events", "common", "refresh")):
        return "TEMPLATE"
    return "SPECIAL"


def git_source_commit(source: Path) -> str:
    submodule = source.parents[2]
    try:
        return subprocess.check_output(
            ["git", "-C", str(submodule), "rev-parse", "HEAD"], text=True
        ).strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return EXPECTED_SOURCE_COMMIT


def parse_map(path: Path) -> tuple[RubyObject, RubyTable]:
    value = load(path)
    if not isinstance(value, RubyObject) or value.class_name != "RPG::Map":
        raise ValueError(f"{path}: expected RPG::Map")
    table = decode_table(ivar(value, "data"))
    if table.x_size != int(ivar(value, "width")) or table.y_size != int(ivar(value, "height")):
        raise ValueError(f"{path}: map dimensions differ from Table")
    return value, table


def generated_ref(path: Path, output: Path) -> str:
    return relpath(path, output)


def process_map_artifacts(
    *, map_id: int, map_obj: RubyObject, table: RubyTable, tileset_table: dict[str, Any],
    output: Path, prefix: str,
) -> dict[str, Any]:
    layers_path = output / "zones/geometry" / f"{prefix}_layers.json"
    layer_payload = {
        "schema_version": SCHEMA_VERSION,
        "map_id": map_id,
        "width": table.x_size,
        "height": table.y_size,
        "layer_count": table.z_size,
        "encoding": "row-major-z-layers-json-u16",
        "all_source_values_preserved": True,
        "layers": table_rows(table),
    }
    layers_hash = write_json(layers_path, layer_payload)

    passages = tileset_table["passages"]
    priorities = tileset_table["priorities"]
    terrain_tags = tileset_table["terrain_tags"]
    collision_path = output / "zones/collision" / f"{prefix}_directional.json"
    collision_hash = write_json(
        collision_path, derived_collision(table, passages, priorities, terrain_tags)
    )

    entities_payload, entity_counts = entity_placements(map_id, ivar(map_obj, "events", {}))
    entities_path = output / "zones/entities" / f"{prefix}_entities.json"
    entities_hash = write_json(entities_path, entities_payload)
    return {
        "layers_path": layers_path,
        "layers_hash": layers_hash,
        "collision_path": collision_path,
        "collision_hash": collision_hash,
        "entities_path": entities_path,
        "entities_hash": entities_hash,
        "entity_payload": entities_payload,
        "entity_counts": entity_counts,
    }


def build(source: Path, output: Path) -> dict[str, Any]:
    source = source.resolve()
    output = output.resolve()
    if source == output or source in output.parents:
        raise ValueError("output must not contain or overwrite the source")
    if not (source / "Data/MapInfos.rxdata").is_file():
        raise ValueError(f"Relict source not found: {source}")
    if output.exists():
        # Source rebuilds must never erase the independently staged conversion
        # tree. All source-library outputs are still rebuilt from scratch.
        for child in output.iterdir():
            if child.name == "conversion":
                continue
            if child.is_dir():
                shutil.rmtree(child)
            else:
                child.unlink()
    output.mkdir(parents=True, exist_ok=True)

    commit = git_source_commit(source)
    map_infos = load(source / "Data/MapInfos.rxdata")
    tilesets = load(source / "Data/Tilesets.rxdata")
    if not isinstance(map_infos, dict) or not isinstance(tilesets, list):
        raise ValueError("unexpected RMXP index types")
    graphics = graphics_index(source)

    canonical: dict[int, Path] = {}
    variants: dict[int, list[tuple[str, Path]]] = defaultdict(list)
    for path in sorted((source / "Data").glob("Map*.rxdata")):
        match = CANONICAL_MAP_RE.match(path.name)
        if match:
            canonical[int(match.group("id"))] = path
            continue
        match = VARIANT_MAP_RE.match(path.name)
        if match:
            variants[int(match.group("id"))].append((match.group("label"), path))
    if set(canonical) != set(int(key) for key in map_infos):
        raise ValueError("MapInfos IDs and canonical Map files differ")

    used_tilesets: set[int] = set()
    parsed_maps: dict[int, tuple[RubyObject, RubyTable]] = {}
    parsed_variants: dict[Path, tuple[RubyObject, RubyTable]] = {}
    for map_id, path in sorted(canonical.items()):
        parsed_maps[map_id] = parse_map(path)
        used_tilesets.add(int(ivar(parsed_maps[map_id][0], "tileset_id", 0)))
    for rows in variants.values():
        for _, path in rows:
            parsed_variants[path] = parse_map(path)
            used_tilesets.add(int(ivar(parsed_variants[path][0], "tileset_id", 0)))

    tileset_payloads: dict[int, dict[str, Any]] = {}
    tileset_paths: dict[int, Path] = {}
    tileset_hashes: dict[int, str] = {}
    for tileset_id in sorted(used_tilesets):
        if tileset_id <= 0 or tileset_id >= len(tilesets) or not isinstance(tilesets[tileset_id], RubyObject):
            raise ValueError(f"missing tileset {tileset_id}")
        payload = tileset_tables(tileset_id, tilesets[tileset_id])
        path = output / "tilesets/collision" / f"tileset_{tileset_id:03d}.json"
        tileset_payloads[tileset_id] = payload
        tileset_paths[tileset_id] = path
        tileset_hashes[tileset_id] = write_json(path, payload)

    asset_usage: dict[tuple[str, str], set[str]] = defaultdict(set)
    asset_records: dict[tuple[str, str], dict[str, Any]] = {}
    zone_rows = []
    divergent_variants = 0
    equivalent_variants = 0
    total_pages = total_cast = total_environment = total_logic = 0

    for map_id, path in sorted(canonical.items()):
        map_obj, table = parsed_maps[map_id]
        info = map_infos[map_id]
        name = decode_text(ivar(info, "name", f"Map {map_id:03d}"))
        tileset_id = int(ivar(map_obj, "tileset_id", 0))
        tileset = tilesets[tileset_id]
        dependencies = visual_dependencies(tileset, source, graphics, commit)
        zone_id = f"relict_map_{map_id:03d}"
        for record in dependencies:
            if record.get("resolved"):
                key = (record["kind"], record["source_path"])
                asset_usage[key].add(zone_id)
                asset_records[key] = record

        artifacts = process_map_artifacts(
            map_id=map_id, map_obj=map_obj, table=table,
            tileset_table=tileset_payloads[tileset_id], output=output,
            prefix=f"map_{map_id:03d}",
        )
        counts = artifacts["entity_counts"]
        page_count = artifacts["entity_payload"]["page_placement_count"]
        total_pages += page_count
        total_cast += counts.get("CAST_PLACEHOLDER", 0)
        total_environment += counts.get("ENVIRONMENTAL_TILE_ENTITY", 0)
        total_logic += counts.get("LOGIC_MARKER", 0)

        variant_rows = []
        canonical_hash = sha256_file(path)
        for label, variant_path in sorted(variants.get(map_id, [])):
            variant_hash = sha256_file(variant_path)
            equivalent = variant_hash == canonical_hash
            variant_obj, variant_table = parsed_variants[variant_path]
            variant_tileset_id = int(ivar(variant_obj, "tileset_id", 0))
            variant_dependencies = visual_dependencies(
                tilesets[variant_tileset_id], source, graphics, commit
            )
            variant_usage_id = f"{zone_id}:variant:{slug(label)}"
            for record in variant_dependencies:
                if record.get("resolved"):
                    key = (record["kind"], record["source_path"])
                    asset_usage[key].add(variant_usage_id)
                    asset_records[key] = record
            row = {
                "source_path": relpath(variant_path, source),
                "source_label": label,
                "sha256": variant_hash,
                "size_bytes": variant_path.stat().st_size,
                "byte_identical_to_canonical": equivalent,
                "tileset_id": variant_tileset_id,
                "tileset": tileset_descriptor(variant_tileset_id, tilesets[variant_tileset_id]),
                "geometry": {
                    "width_tiles": variant_table.x_size,
                    "height_tiles": variant_table.y_size,
                    "layer_count": variant_table.z_size,
                },
                "visual_dependencies": variant_dependencies,
            }
            if equivalent:
                equivalent_variants += 1
                row["derived_artifacts"] = "REUSE_CANONICAL_BYTE_IDENTICAL"
            else:
                divergent_variants += 1
                variant_prefix = f"map_{map_id:03d}_variant_{slug(label)}"
                variant_artifacts = process_map_artifacts(
                    map_id=map_id, map_obj=variant_obj, table=variant_table,
                    tileset_table=tileset_payloads[variant_tileset_id], output=output,
                    prefix=variant_prefix,
                )
                row["derived_artifacts"] = {
                    "tile_layers": generated_ref(variant_artifacts["layers_path"], output),
                    "tile_layers_sha256": variant_artifacts["layers_hash"],
                    "directional_collision": generated_ref(variant_artifacts["collision_path"], output),
                    "directional_collision_sha256": variant_artifacts["collision_hash"],
                    "entity_placements": generated_ref(variant_artifacts["entities_path"], output),
                    "entity_placements_sha256": variant_artifacts["entities_hash"],
                }
            variant_rows.append(row)

        visual_counts = Counter()
        excluded_counts = Counter()
        for placement in artifacts["entity_payload"]["placements"]:
            visual_counts.update(placement["visual_commands"])
            excluded_counts.update(placement["excluded_command_counts"])
        problems = [
            f"MISSING_VISUAL_DEPENDENCY:{dep['kind']}:{dep['source_name']}"
            for dep in dependencies if not dep.get("resolved")
        ]
        if any(not row["byte_identical_to_canonical"] for row in variant_rows):
            problems.append("DIVERGENT_SOURCE_VARIANT_REQUIRES_REVIEW")

        zone_payload = {
            "schema_version": SCHEMA_VERSION,
            "zone_id": zone_id,
            "game_id": "relict",
            "source": source_provenance(path, source, commit, "RPG Maker XP Ruby Marshal 4.8 RPG::Map"),
            "name": name,
            "source_map_id": map_id,
            "parent_map_id": int(ivar(info, "parent_id", 0)),
            "source_order": int(ivar(info, "order", map_id)),
            "zone_type": infer_zone_type(name),
            "zone_type_inferred": True,
            "status": "SOURCE_EXTRACTED",
            "geometry": {
                "width_tiles": table.x_size,
                "height_tiles": table.y_size,
                "tile_size_px": TILE_SIZE,
                "width_px": table.x_size * TILE_SIZE,
                "height_px": table.y_size * TILE_SIZE,
                "layer_count": table.z_size,
            },
            "tileset": tileset_descriptor(tileset_id, tileset),
            "tile_layers": {
                "file": generated_ref(artifacts["layers_path"], output),
                "sha256": artifacts["layers_hash"],
                "all_source_values_preserved": True,
            },
            "collision": {
                "schema_version": SCHEMA_VERSION,
                "map_id": map_id,
                "source_complete": True,
                "tile_size_px": TILE_SIZE,
                "width": table.x_size,
                "height": table.y_size,
                "layer_count": table.z_size,
                "source_layers": {
                    "file": generated_ref(artifacts["layers_path"], output),
                    "sha256": artifacts["layers_hash"],
                    "encoding": "row-major-z-layers-json-u16",
                    "value_count": len(table.values),
                },
                "tileset_tables": {
                    "file": generated_ref(tileset_paths[tileset_id], output),
                    "sha256": tileset_hashes[tileset_id],
                    "passages_complete": True,
                    "priorities_complete": True,
                    "terrain_tags_complete": True,
                },
                "derived_directional_grid": {
                    "file": generated_ref(artifacts["collision_path"], output),
                    "sha256": artifacts["collision_hash"],
                    "method": "RGSS1_STANDARD_PRIORITY_AND_PASSAGE_FLAGS",
                    "directions": ["down", "left", "right", "up"],
                    "custom_script_overrides_executed": False,
                },
                "dynamic_entities": {
                    "file": generated_ref(artifacts["entities_path"], output),
                    "sha256": artifacts["entities_hash"],
                    "placements_complete": True,
                },
            },
            "entities": {
                "file": generated_ref(artifacts["entities_path"], output),
                "sha256": artifacts["entities_hash"],
                "placement_count": artifacts["entity_payload"]["source_event_count"],
                "page_placement_count": page_count,
                "cast_placeholder_count": counts.get("CAST_PLACEHOLDER", 0),
                "environmental_tile_entity_count": counts.get("ENVIRONMENTAL_TILE_ENTITY", 0),
                "logic_marker_count": counts.get("LOGIC_MARKER", 0),
                "source_identities_redacted": True,
            },
            "visual_dependencies": dependencies,
            "variants": variant_rows,
            "cinematic_visuals": {
                "visual_command_counts": dict(sorted(visual_counts.items())),
                "excluded_command_counts": dict(sorted(excluded_counts.items())),
                "dialogue_contents_exported": False,
                "script_bodies_exported": False,
            },
            "audio_context_present": bool(
                ivar(map_obj, "autoplay_bgm", False)
                and decode_text(ivar(ivar(map_obj, "bgm"), "name", ""))
            ),
            "problems": sorted(problems),
            "pmdo": {
                "conversion_started": False,
                "differences": [
                    "RMXP uses three 32px tile layers and per-tile passage flags.",
                    "Dynamic event collision and page conditions must become explicit PMDO entities.",
                    "Source cast graphics are redacted and require New Era replacements.",
                ],
                "adaptation_needs": [
                    "Map RMXP passage/priority/terrain semantics to RogueEssence terrain and collision.",
                    "Replace every CAST_PLACEHOLDER with an approved New Era actor.",
                    "Validate visual commands, movement routes, overlays and timings scene by scene.",
                ],
            },
        }
        zone_path = output / "metadata/zones" / f"map_{map_id:03d}.json"
        write_json(zone_path, zone_payload)
        zone_rows.append(zone_payload)

    asset_rows = []
    for (kind, source_path), used_by in sorted(asset_usage.items()):
        record = asset_records[(kind, source_path)]
        source_file = source / source_path
        asset_id = f"relict_{kind.casefold()}_{slug(Path(source_path).stem)}_{record['sha256'][:12]}"
        payload = {
            "schema_version": SCHEMA_VERSION,
            "asset_id": asset_id,
            "game_id": "relict",
            "kind": kind,
            "classification": "INCLUDED_ENVIRONMENTAL",
            "status": "SOURCE_EXTRACTED",
            "dimensions": record["dimensions"],
            "alpha": None,
            "provenance": source_provenance(source_file, source, commit, source_file.suffix.lower().lstrip(".") or "binary image"),
            "dependencies": [],
            "used_by_zones": sorted(used_by),
            "problems": record["problems"],
        }
        write_json(output / "metadata/assets" / f"{asset_id}.json", payload)
        asset_rows.append(payload)

    manifest_files = []
    timing_script = source / "Data/Scripts/006_Map renderer/001_TilemapRenderer.rb"
    animation_script = source / "Data/Scripts/005_Sprites/008_Sprite_AnimationSprite.rb"
    involved_paths = {
        source / "Data/MapInfos.rxdata",
        source / "Data/Tilesets.rxdata",
        source / "Data/CommonEvents.rxdata",
        source / "Data/Animations.rxdata",
        source / "mkxp.json",
        timing_script,
        animation_script,
    }
    involved_paths.update(canonical.values())
    involved_paths.update(path for values in variants.values() for _, path in values)
    involved_paths.update(source / key[1] for key in asset_usage)
    for path in sorted(involved_paths):
        manifest_files.append({
            "path": relpath(path, source),
            "sha256": sha256_file(path),
            "size_bytes": path.stat().st_size,
            "classification": (
                "STATIC_VISUAL_TIMING_AUTHORITY"
                if path in (timing_script, animation_script, source / "mkxp.json")
                else "REDACTED_VISUAL_TIMELINE_SOURCE"
                if path == source / "Data/CommonEvents.rxdata"
                else "INCLUDED_ENVIRONMENTAL_SOURCE"
            ),
        })
    schema_hashes = {
        relpath(path, WORKSPACE): sha256_file(path)
        for path in sorted((WORKSPACE / "schemas").glob("*.json"))
    }
    policy_hashes = {
        relpath(path, WORKSPACE): sha256_file(path)
        for path in sorted((WORKSPACE / "policies").glob("*.json"))
    }
    source_manifest = {
        "schema_version": SCHEMA_VERSION,
        "game_id": "relict",
        "source_repository": SOURCE_REPOSITORY,
        "source_commit": commit,
        "source_root": "Relict/Relict V1.2/Relict",
        "source_format": "RPG Maker XP / Pokemon Essentials Ruby Marshal 4.8",
        "execution_policy": "NO_SOURCE_CODE_EXECUTION",
        "canonical_map_count": len(canonical),
        "variant_map_count": sum(len(rows) for rows in variants.values()),
        "files": manifest_files,
        "schema_hashes": schema_hashes,
        "policy_hashes": policy_hashes,
        "pipeline_tool_hashes": {
            relpath(path, WORKSPACE): sha256_file(path)
            for path in sorted((WORKSPACE / "tools").glob("*.py"))
        },
    }
    write_json(output / "manifests/source_manifest.json", source_manifest)

    summary = {
        "schema_version": SCHEMA_VERSION,
        "game_id": "relict",
        "result": "SOURCE_INVENTORY_PASS",
        "canonical_map_count": len(canonical),
        "variant_map_count": sum(len(rows) for rows in variants.values()),
        "byte_identical_variant_count": equivalent_variants,
        "divergent_variant_count": divergent_variants,
        "used_tileset_count": len(used_tilesets),
        "environmental_asset_count": len(asset_rows),
        "entity_event_count": sum(row["entities"]["placement_count"] for row in zone_rows),
        "entity_page_placement_count": total_pages,
        "cast_placeholder_count": total_cast,
        "environmental_tile_entity_count": total_environment,
        "logic_marker_count": total_logic,
        "missing_dependency_count": sum(
            not dep.get("resolved", False)
            for row in zone_rows for dep in row["visual_dependencies"]
        ),
        "source_identities_redacted": True,
        "dialogue_contents_exported": False,
        "script_bodies_exported": False,
        "pmdo_conversion_started": False,
        "zone_ids": [row["zone_id"] for row in zone_rows],
    }
    write_json(output / "reports/inventory.json", summary)
    lines = [
        "# Relict — inventaire source v1", "",
        f"- Maps canoniques : **{summary['canonical_map_count']}**",
        f"- Variantes : **{summary['variant_map_count']}** "
        f"({equivalent_variants} identiques, {divergent_variants} divergentes)",
        f"- Tilesets utilisés : **{summary['used_tileset_count']}**",
        f"- Assets environnementaux résolus : **{summary['environmental_asset_count']}**",
        f"- Événements placés : **{summary['entity_event_count']}**",
        f"- Placements par page : **{summary['entity_page_placement_count']}**",
        f"- Placeholders de casting : **{summary['cast_placeholder_count']}**",
        f"- Entités décor tile : **{summary['environmental_tile_entity_count']}**",
        f"- Marqueurs logiques : **{summary['logic_marker_count']}**",
        f"- Dépendances manquantes : **{summary['missing_dependency_count']}**",
        "", "## Garanties", "",
        "- Toutes les valeurs des trois couches RMXP sont conservées.",
        "- Passages, priorités et terrain tags sont conservés intégralement.",
        "- Une grille collisionnelle directionnelle RGSS1 est dérivée pour chaque Map.",
        "- Toutes les coordonnées d'entités et tous leurs états par page sont conservés.",
        "- Les identités graphiques de casting sont remplacées par des hashes et placeholders.",
        "- Aucun dialogue, corps de script, exécutable, sprite humain ou Pokémon n'est exporté.",
        "- Aucune conversion PMDO n'est commencée.", "",
    ]
    (output / "reports/coverage.md").write_text("\n".join(lines), encoding="utf-8")
    phase_readmes = {
        "animations/README.md": """# Animations Relict

Phase suivante, non commencée. Toute animation environnementale devra être
extraite par couche en `frame_000.png`, `frame_001.png`, etc., avec durées,
boucle, contexte et provenance conformes à `schemas/animation.schema.json`.
Les animations de combat ou attachées au casting restent exclues.
""",
        "vfx/README.md": """# VFX environnementaux Relict

Phase suivante, non commencée. Seuls les effets appartenant à une zone
(météo, fog, lumière, overlay, particules et transitions) seront admis. Tout
effet attaché à un personnage, Pokémon ou combat sera exclu ou remplacé par un
placeholder documentaire.
""",
        "previews/README.md": """# Prévisualisations Relict

Aucun rendu n'est encore qualifié. Les futurs PNG devront être générés à partir
des couches inventoriées, appliquer les collisions séparément et remplacer les
68 placements de casting par des placeholders neutres. Aucune couche ne devra
être aplatie comme substitut à la donnée source.
""",
        "conversion/README.md": """# Conversion Relict → PMDO

Verrouillée pendant le Sprint 0–1. Aucun fichier PMDO ne doit être produit avant
validation complète des sources, collisions, placements d'entités, couches,
animations et VFX. Les placeholders de casting seront ensuite remplacés
uniquement par des acteurs approuvés de New Era.
""",
    }
    for relative, content in phase_readmes.items():
        path = output / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        # Conversion becomes an independent staged pipeline after source
        # qualification. Never overwrite its live architecture/procedure note.
        if relative == "conversion/README.md" and path.exists():
            continue
        path.write_text(content, encoding="utf-8")
    return summary


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    summary = build(args.source, args.output)
    print(json.dumps(summary, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
