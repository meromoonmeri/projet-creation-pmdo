#!/usr/bin/env python3
"""Build the PMDO-scoped environmental inventory for No Name Village.

This stage never emits PMDO content.  It separates source environmental facts
from proprietary gameplay/character systems and creates deterministic,
fail-closed adaptation contracts.  Unknown instances remain REVIEW_REQUIRED;
no heuristic classification can promote an asset to CONVERTED or CERTIFIED.
"""
from __future__ import annotations

import argparse
import gzip
import hashlib
import json
from collections import Counter
from pathlib import Path
from typing import Any

SCHEMA = "new-era.no-name-village.environment-inventory.v1"
SOURCE_DATA_WIN_SHA256 = "2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227"
ENVIRONMENT_ROOM_CATEGORIES = {"world", "interior", "cave"}

DECOR_LAYER_TOKENS = {
    "above", "below", "endvillage", "endvillage2", "housebelow", "shousebelow",
    "plants", "shadows", "trees", "vegetation",
}
FUNCTIONAL_TOKENS = (
    "collid", "door", "entrance", "exit", "house", "solid", "spawn", "transit", "warp",
)
DECOR_TOKENS = (
    "boulder", "bridge", "bush", "cliff", "decor", "fence", "flower", "grass", "ground",
    "hedge", "leaf", "log", "plant", "rock", "roof", "shadow", "snow", "stump", "tree",
    "veget", "wall", "water", "wood",
)
WILDLIFE_TOKENS = ("objmob", "objbmob")
SOCIAL_ROLE_TOKENS = (
    "carpenter", "farmer", "fisher", "herbalist", "hunter", "logger", "merchant",
    "seamstress", "shopkeeper", "villager",
)
PROPRIETARY_TOKENS = (
    "attack", "battle", "combat", "dialog", "enemy", "inventory", "manager", "menu",
    "npc", "player", "quest", "steam", "weapon",
)


def read_gzip(path: Path) -> Any:
    with gzip.open(path, "rt", encoding="utf-8") as stream:
        return json.load(stream)


def canonical_bytes(value: Any) -> bytes:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")


def digest(value: Any) -> str:
    return hashlib.sha256(canonical_bytes(value)).hexdigest()


def resource_ref(value: Any) -> dict[str, Any] | None:
    if not isinstance(value, dict):
        return None
    ref = value.get("$resourceRef")
    if not isinstance(ref, dict):
        return None
    return {key: ref.get(key) for key in ("category", "index", "name")}


def classify_instance(object_name: str, layer_name: str) -> tuple[str, str]:
    """Return a conservative source classification and its auditable reason."""
    obj = object_name.casefold()
    layer = layer_name.casefold()
    if "house" in obj:
        return "ADAPTATION_REQUIRED", "source_building_requires_native_PMDO_collision_door_and_interior_link"
    if any(token in obj for token in WILDLIFE_TOKENS):
        return "WILD_POKEMON_ADAPTATION_REQUIRED", "source_wildlife_behavior_requires_native_Pokemon_cast_encounter_and_routine"
    if any(token in obj for token in SOCIAL_ROLE_TOKENS):
        return "ROLE_ADAPTATION_REQUIRED", "source_social_function_requires_native_Pokemon_cast_and_New_Era_routine"
    if any(token in obj for token in FUNCTIONAL_TOKENS):
        return "ADAPTATION_REQUIRED", "environment_function_requires_native_pmdo_reconstruction"
    if any(token in obj for token in PROPRIETARY_TOKENS):
        return "EXCLUDED_PROPRIETARY", "source_sprite_or_proprietary_system_excluded; social_role_not_proven"
    if layer in DECOR_LAYER_TOKENS or any(token in obj for token in DECOR_TOKENS):
        return "EXTRACTED", "environment_decor_candidate; visual_review_required_before_conversion"
    return "REVIEW_REQUIRED", "insufficient_semantic_evidence; never auto-promote"


def object_contract(index: int, obj: dict[str, Any]) -> dict[str, Any]:
    code_refs = []
    for event_group in obj.get("Events") or []:
        for event in event_group or []:
            for action in event.get("Actions") or []:
                ref = resource_ref(action.get("CodeId"))
                if ref is not None and ref.get("name") is not None:
                    code_refs.append(ref["name"])
    return {
        "index": index,
        "name": obj.get("Name"),
        "parent": resource_ref(obj.get("ParentId")),
        "sprite": resource_ref(obj.get("Sprite")),
        "solid": obj.get("Solid"),
        "visible": obj.get("Visible"),
        "persistent": obj.get("Persistent"),
        "event_code_refs": sorted(set(code_refs)),
        "source_sha256": digest(obj),
        "source_code_policy": "semantic_evidence_only; never execute or import GameMaker code",
    }


def layer_instance_indices(layer: dict[str, Any]) -> list[int]:
    data = layer.get("Data")
    if not isinstance(data, dict):
        return []
    result = []
    for entry in data.get("Instances", []):
        if not isinstance(entry, dict):
            continue
        cycle = entry.get("$cycleRef", "")
        if ".GameObjects[" not in cycle:
            continue
        try:
            result.append(int(cycle.rsplit("[", 1)[1].rstrip("]")))
        except ValueError:
            continue
    return result


def tile_contract(layer: dict[str, Any]) -> dict[str, Any] | None:
    data = layer.get("Data")
    if not isinstance(data, dict) or "TileData" not in data:
        return None
    rows = data.get("TileData") or []
    width = max((len(row) for row in rows), default=0)
    tileset = resource_ref(data.get("Background"))
    values = Counter(value for row in rows for value in row)
    return {
        "layer": layer.get("LayerName"),
        "depth": layer.get("LayerDepth"),
        "visible": layer.get("IsVisible"),
        "grid": {"width": width, "height": len(rows)},
        "tileset": tileset,
        "nonzero_cells": sum(count for value, count in values.items() if value != 0),
        "distinct_tile_values": len(values),
        "tile_matrix_sha256": digest(rows),
        "status": "EXTRACTED",
        "next_status": "ADAPTATION_REQUIRED",
    }


def asset_contracts(layer: dict[str, Any]) -> list[dict[str, Any]]:
    assets = layer.get("AssetsData")
    if not isinstance(assets, dict):
        return []
    result = []
    for sprite in assets.get("Sprites") or []:
        result.append({
            "layer": layer.get("LayerName"),
            "depth": layer.get("LayerDepth"),
            "name": sprite.get("Name"),
            "sprite": resource_ref(sprite.get("Sprite")),
            "position": [sprite.get("X"), sprite.get("Y")],
            "scale": [sprite.get("ScaleX"), sprite.get("ScaleY")],
            "rotation": sprite.get("Rotation"),
            "color": sprite.get("Color"),
            "animation_speed": sprite.get("AnimationSpeed"),
            "source_sha256": digest(sprite),
            "status": "EXTRACTED",
            "next_status": "REVIEW_REQUIRED",
            "import_policy": "environment_visual_only; never import GameMaker behavior",
        })
    return result


def build(extracted: Path, reports: Path) -> dict[str, Any]:
    inventory = extracted / "inventory"
    rooms = read_gzip(inventory / "Rooms.json.gz")
    objects = read_gzip(inventory / "GameObjects.json.gz")
    room_index = json.loads((reports / "room-index.json").read_text(encoding="utf-8"))
    source_summary = json.loads((reports / "source-summary.json").read_text(encoding="utf-8"))
    structured = json.loads((extracted / "structured-manifest.json").read_text(encoding="utf-8"))

    if structured.get("counts", {}).get("Rooms") != len(rooms):
        raise ValueError("official room count disagrees with structured manifest")
    if len(room_index) != len(rooms):
        raise ValueError("room-index does not cover every official room")
    if source_summary.get("source", {}).get("sha256") != SOURCE_DATA_WIN_SHA256:
        raise ValueError("No Name Village source authority hash mismatch")

    categories = {row["name"]: row["category"] for row in room_index}
    object_names = [obj.get("Name") or f"GameObjects[{index}]" for index, obj in enumerate(objects)]
    object_contracts = [object_contract(index, obj) for index, obj in enumerate(objects)]
    result_rooms = []
    status_counts: Counter[str] = Counter()
    total_tile_layers = total_assets = total_instances = 0

    for room_index_value, room in enumerate(rooms):
        name = room.get("Name") or f"Rooms[{room_index_value}]"
        category = categories.get(name, "UNCLASSIFIED")
        included = category in ENVIRONMENT_ROOM_CATEGORIES
        room_status = "EXTRACTED" if included else "EXCLUDED_PROPRIETARY"
        tile_layers = []
        assets = []
        instances = []
        assigned_instances: dict[int, str] = {}

        for layer in room.get("Layers") or []:
            layer_name = layer.get("LayerName") or ""
            contract = tile_contract(layer)
            if contract is not None:
                tile_layers.append(contract)
            assets.extend(asset_contracts(layer))
            for index in layer_instance_indices(layer):
                assigned_instances[index] = layer_name

        if included:
            for index, placement in enumerate(room.get("GameObjects") or []):
                ref = resource_ref(placement.get("ObjectDefinition")) or {}
                obj_index = ref.get("index")
                object_name = ref.get("name")
                if object_name is None and isinstance(obj_index, int) and 0 <= obj_index < len(object_names):
                    object_name = object_names[obj_index]
                object_name = object_name or "UNKNOWN_OBJECT"
                layer_name = assigned_instances.get(index, "UNASSIGNED")
                status, reason = classify_instance(object_name, layer_name)
                status_counts[status] += 1
                instances.append({
                    "instance_id": placement.get("InstanceID"),
                    "object": {"index": obj_index, "name": object_name},
                    "layer": layer_name,
                    "position": [placement.get("X"), placement.get("Y")],
                    "scale": [placement.get("ScaleX"), placement.get("ScaleY")],
                    "rotation": placement.get("Rotation"),
                    "source_sha256": digest(placement),
                    "status": status,
                    "reason": reason,
                    "import_policy": (
                        "reconstruct_with_native_PMDO_marker/collider/warp" if status == "ADAPTATION_REQUIRED"
                        else "replace_with_native_wild_Pokemon_using_PMDO_entities_encounters_and_existing_AI" if status == "WILD_POKEMON_ADAPTATION_REQUIRED"
                        else "replace_with_native_Pokemon_actor_using_existing_LivingWorld_TownLife_TownPlace_systems" if status == "ROLE_ADAPTATION_REQUIRED"
                        else "visual_environment_only" if status == "EXTRACTED"
                        else "do_not_import" if status == "EXCLUDED_PROPRIETARY"
                        else "manual_semantic_review"
                    ),
                })
        else:
            status_counts[room_status] += len(room.get("GameObjects") or [])

        total_tile_layers += len(tile_layers)
        total_assets += len(assets)
        total_instances += len(instances)
        result_rooms.append({
            "source_room_index": room_index_value,
            "name": name,
            "category": category,
            "dimensions_px": [room.get("Width"), room.get("Height")],
            "grid_px": [room.get("GridWidth"), room.get("GridHeight")],
            "layer_count": len(room.get("Layers") or []),
            "source_sha256": digest(room),
            "status": room_status,
            "conversion_status": "UNIMPLEMENTED" if included else "EXCLUDED_PROPRIETARY",
            "certification_status": "NOT_TESTED",
            "tile_layers": tile_layers if included else [],
            "sprite_placements": assets if included else [],
            "instances": instances,
        })

    output = {
        "schema": SCHEMA,
        "authority": {
            "data_win_sha256": SOURCE_DATA_WIN_SHA256,
            "official_model_schema": structured.get("schema"),
            "official_model_sha256": hashlib.sha256((extracted / "structured-manifest.json").read_bytes()).hexdigest(),
            "room_inventory_sha256": hashlib.sha256((inventory / "Rooms.json.gz").read_bytes()).hexdigest(),
            "object_inventory_sha256": hashlib.sha256((inventory / "GameObjects.json.gz").read_bytes()).hexdigest(),
        },
        "policy": {
            "scope": "environment_only",
            "forbidden": ["source_human_sprites", "combat_system", "proprietary_gameplay", "proprietary_UI", "GameMaker_runtime_scripts"],
            "social_role_policy": "preserve proven social function; replace source actor with a native Pokemon using existing LivingWorld/TownLife/TownPlace and PMDO AI",
            "wildlife_policy": "preserve source wildlife density/placement/behavior class; map every role to native wild Pokemon, PMDO entities/encounters, and existing AI; never flatten wildlife into decoration",
            "season_policy": "port exact NNV objstage substitutions, objwinter particle families, footprints and audio; New Era Seasons supplies progression state only and generic seasonal particles are not substitutes",
            "existing_new_era_systems": ["halcyon.LivingWorld", "halcyon.TownLife", "halcyon.TownPlace", "halcyon.Seasons", "halcyon.Weather", "halcyon.ai.ground_default"],
            "status_order": ["EXTRACTED", "CONVERTED", "STRUCTURALLY_VALID", "VISUALLY_VALID", "RUNTIME_VALID", "CERTIFIED", "PROMOTED"],
            "fail_closed": True,
            "unknown_instance_status": "REVIEW_REQUIRED",
        },
        "object_contracts": object_contracts,
        "summary": {
            "official_room_count": len(rooms),
            "official_object_count": len(object_contracts),
            "environment_room_count": sum(row["status"] == "EXTRACTED" for row in result_rooms),
            "excluded_system_room_count": sum(row["status"] == "EXCLUDED_PROPRIETARY" for row in result_rooms),
            "tile_layer_count": total_tile_layers,
            "sprite_placement_count": total_assets,
            "instance_count": total_instances,
            "instance_status_counts": dict(sorted(status_counts.items())),
            "converted_room_count": 0,
            "certified_room_count": 0,
            "promoted_room_count": 0,
        },
        "rooms": result_rooms,
    }
    output["inventory_sha256"] = digest(output)
    return output


def write_summary(path: Path, data: dict[str, Any]) -> None:
    summary = data["summary"]
    lines = [
        "# No Name Village — inventaire environnemental PMDO",
        "",
        "Cet inventaire est une séparation de périmètre reproductible, pas une conversion.",
        "Aucun personnage, système GameMaker ou script propriétaire n'est promu.",
        "",
        f"- Rooms officielles : **{summary['official_room_count']}**",
        f"- Contrats objets source : **{summary['official_object_count']}**",
        f"- Rooms environnementales : **{summary['environment_room_count']}**",
        f"- Rooms système exclues : **{summary['excluded_system_room_count']}**",
        f"- Layers de tiles inventoriés : **{summary['tile_layer_count']}**",
        f"- Placements sprite inventoriés : **{summary['sprite_placement_count']}**",
        f"- Instances environnementales examinées : **{summary['instance_count']}**",
        "- Grounds PMDO convertis/certifiés/promus : **0 / 0 / 0**",
        "",
        "## Statuts des instances",
    ]
    lines.extend(f"- `{key}` : {value}" for key, value in summary["instance_status_counts"].items())
    lines += [
        "",
        "`ROLE_ADAPTATION_REQUIRED` conserve une fonction sociale source sans importer son sprite",
        "ou son code : le casting sera un Pokémon natif branché sur les systèmes New Era existants.",
        "`WILD_POKEMON_ADAPTATION_REQUIRED` conserve densité, position et classe comportementale",
        "de la faune source ; elle devra devenir une population Pokémon native, jamais du décor.",
        "`REVIEW_REQUIRED` est volontairement bloquant. Les règles nominales ne constituent",
        "jamais une preuve suffisante pour importer un objet inconnu.",
        "",
        f"SHA-256 sémantique de l'inventaire : `{data['inventory_sha256']}`",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser()
    parser.add_argument("--extracted", type=Path, default=root / "extracted/official")
    parser.add_argument("--reports", type=Path, default=root / "reports")
    parser.add_argument("--output", type=Path, default=root / "reports/environment-inventory.json.gz")
    parser.add_argument("--summary", type=Path, default=root / "reports/environment-inventory.md")
    args = parser.parse_args()
    result = build(args.extracted, args.reports)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    payload = json.dumps(result, ensure_ascii=False, separators=(",", ":"), sort_keys=True).encode("utf-8") + b"\n"
    if args.output.suffix == ".gz":
        with args.output.open("wb") as raw:
            with gzip.GzipFile(filename="", fileobj=raw, mode="wb", compresslevel=9, mtime=0) as stream:
                stream.write(payload)
    else:
        args.output.write_bytes(payload)
    write_summary(args.summary, result)
    print("NNV_ENVIRONMENT_INVENTORY_PASS", json.dumps(result["summary"], sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
