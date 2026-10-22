#!/usr/bin/env python3
"""Build the game-neutral BIBLIOTHEQUE Map IR from qualified source evidence.

The first importer is Relict.  Nova and Reminiscencia importers must emit the
same schema, so target converters never learn a fangame's native format.
No source program is executed and no dialogue, casting identity or script body
is introduced by this stage.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any

from inventory_relict import DEFAULT_OUTPUT, DEFAULT_SOURCE, sha256_file, write_json
from png_rgba import save_png
from render_relict_previews import TileRenderer

REPO_ROOT = Path(__file__).resolve().parents[3]
DEFAULT_IR_ROOT = DEFAULT_OUTPUT / "conversion/ir"
ALLOWED_STATUS = {
    "SOURCE_EXTRACTED", "SOURCE_DOCUMENTED", "PMDO_CONVERTED",
    "PMDO_VALIDATED", "ADAPTATION_REQUIRED", "UNSUPPORTED",
}


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def file_ref(path: Path, relative_to: Path) -> dict[str, Any]:
    return {
        "path": path.relative_to(relative_to).as_posix(),
        "size_bytes": path.stat().st_size,
        "sha256": sha256_file(path),
    }


def contains_map_context(value: Any, map_id: int, zone_id: str) -> bool:
    if isinstance(value, dict):
        if value.get("map_id") == map_id or value.get("zone_id") == zone_id:
            return True
        return any(contains_map_context(item, map_id, zone_id) for item in value.values())
    if isinstance(value, list):
        return any(contains_map_context(item, map_id, zone_id) for item in value)
    return False


def animation_records(
    game_root: Path, manifest_rel: str, map_id: int, zone_id: str,
) -> list[dict[str, Any]]:
    manifest = load_json(game_root / manifest_rel)
    records = []
    for row in manifest.get("animations", []):
        metadata_path = game_root / row["metadata"]
        metadata = load_json(metadata_path)
        if contains_map_context(metadata.get("contexts", []), map_id, zone_id):
            records.append({
                "metadata_file": metadata_path.relative_to(game_root).as_posix(),
                "metadata_sha256": sha256_file(metadata_path),
                "metadata": metadata,
            })
    return records


def validate_matrix(name: str, matrix: list[list[int]], width: int, height: int) -> None:
    if len(matrix) != height or any(len(row) != width for row in matrix):
        raise ValueError(f"{name}: expected {width}x{height} row-major matrix")


def validate_ir(ir: dict[str, Any]) -> None:
    """Dependency-free structural gate mirroring the consequential schema rules."""

    required = {
        "schema_version", "identity", "status", "provenance", "geometry",
        "tile_layers", "collision", "entities", "environment", "animations",
        "target_contract",
    }
    if set(ir) != required:
        raise ValueError(f"IR root keys differ: {sorted(set(ir) ^ required)}")
    if ir["schema_version"] != "1.0.0" or ir["status"] not in ALLOWED_STATUS:
        raise ValueError("unsupported schema version or status")
    if ir["identity"]["game_id"] not in {"relict", "nova", "reminiscencia"}:
        raise ValueError("unknown game_id")
    geometry = ir["geometry"]
    width, height = geometry["width_tiles"], geometry["height_tiles"]
    if geometry["width_px"] != width * geometry["source_tile_size_px"]:
        raise ValueError("width pixel geometry mismatch")
    if geometry["height_px"] != height * geometry["source_tile_size_px"]:
        raise ValueError("height pixel geometry mismatch")
    layers = ir["tile_layers"]["layers"]
    if [row["index"] for row in layers] != list(range(len(layers))):
        raise ValueError("layer indices/order are not contiguous")
    for layer in layers:
        validate_matrix(f"layer {layer['index']}", layer["rows"], width, height)
    used_ids = {value for layer in layers for row in layer["rows"] for value in row}
    catalog = ir["tile_layers"]["tile_catalog"]
    catalog_ids = [row["tile_id"] for row in catalog]
    if catalog_ids != sorted(used_ids) or len(catalog_ids) != len(set(catalog_ids)):
        raise ValueError("tile catalog does not cover each used tile ID exactly once")
    for tile in catalog:
        if tile["transparent"] != (tile["tile_id"] == 0):
            raise ValueError("only canonical tile 0 may be transparent")
        if tile["tile_id"] and not tile["frames"]:
            raise ValueError("nontransparent catalog tile has no frames")
        if [frame["index"] for frame in tile["frames"]] != list(range(len(tile["frames"]))):
            raise ValueError("tile frame indices are not contiguous")
    validate_matrix("allowed_direction_masks", ir["collision"]["allowed_direction_masks"], width, height)
    validate_matrix("terrain_tags", ir["collision"]["terrain_tags"], width, height)
    if ir["entities"]["source_identities_redacted"] is not True:
        raise ValueError("entity identities are not redacted")
    if ir["target_contract"]["runtime_destination_allowed"] is not False:
        raise ValueError("staged IR unexpectedly allows a runtime destination")


def materialize_relict_tile_catalog(
    source: Path,
    game_root: Path,
    map_key: str,
    layers: list[dict[str, Any]],
    tileset: dict[str, Any],
    visual_assets: list[dict[str, Any]],
    autotiles: list[dict[str, Any]],
) -> list[dict[str, Any]]:
    """Normalize used RMXP tile IDs into source-agnostic RGBA frame assets."""

    for row in visual_assets:
        source_path = source / row["source_path"]
        if sha256_file(source_path) != row["sha256"]:
            raise ValueError(f"source visual hash changed: {source_path}")
    renderer_dependencies = [{**row, "resolved": True} for row in visual_assets]
    renderer = TileRenderer(source, renderer_dependencies, tileset)
    timing_by_name: dict[str, int] = {}
    for row in autotiles:
        metadata = row["metadata"]
        source_name = Path(metadata["provenance"]["source_path"]).stem.casefold()
        durations = {
            frame["duration_ms"]
            for layer in metadata["layers"]
            for frame in layer["frames"]
        }
        if len(durations) != 1 or metadata["timing_authority"] != "SOURCE_EXACT":
            raise ValueError(f"autotile timing is not a single exact duration: {source_name}")
        timing_by_name[source_name] = durations.pop()

    used_ids = sorted({value for layer in layers for row in layer["rows"] for value in row})
    asset_root = game_root / f"conversion/ir/assets/{map_key}/tiles"
    catalog = []
    for tile_id in used_ids:
        if tile_id == 0:
            catalog.append({"tile_id": 0, "transparent": True, "loop": False, "frames": []})
            continue
        frame_count = 1
        duration_ms = 1000
        if tile_id < 384:
            slot = tile_id // 48 - 1
            if slot < 0 or slot >= len(renderer.autotiles):
                raise ValueError(f"tile {tile_id}: invalid autotile slot")
            frame_count = renderer.animation_frame_count(renderer.autotiles[slot])
            source_name = tileset["autotile_slots"][slot]["name"]
            if frame_count > 1:
                duration_ms = timing_by_name.get(source_name.casefold(), 0)
                if not duration_ms:
                    raise ValueError(f"tile {tile_id}: no exact timing for animated {source_name}")
        frames = []
        for frame_index in range(frame_count):
            frame_path = asset_root / f"tile_{tile_id:05d}/frame_{frame_index:03d}.png"
            save_png(renderer.tile(tile_id, frame_index), frame_path)
            frames.append({
                "index": frame_index,
                "duration_ms": duration_ms,
                "file": frame_path.relative_to(game_root).as_posix(),
                "sha256": sha256_file(frame_path),
                "size_bytes": frame_path.stat().st_size,
            })
        catalog.append({
            "tile_id": tile_id,
            "transparent": False,
            "loop": frame_count > 1,
            "frames": frames,
        })
    if renderer.missing_ids:
        raise ValueError(f"tile normalization has missing IDs: {sorted(renderer.missing_ids)}")
    return catalog


def build_relict(game_root: Path, source: Path, map_id: int) -> dict[str, Any]:
    map_key = f"map_{map_id:03d}"
    zone_path = game_root / f"metadata/zones/{map_key}.json"
    zone = load_json(zone_path)
    if zone["status"] != "SOURCE_DOCUMENTED":
        raise ValueError(f"{zone_path}: source is not qualified")

    geometry_path = game_root / zone["tile_layers"]["file"]
    collision_path = game_root / zone["collision"]["derived_directional_grid"]["file"]
    entity_path = game_root / zone["entities"]["file"]
    timeline_path = game_root / f"vfx/timelines/maps/{map_key}.json"
    geometry = load_json(geometry_path)
    collision = load_json(collision_path)
    entities = load_json(entity_path)
    timeline = load_json(timeline_path)

    expected_hashes = {
        geometry_path: zone["tile_layers"]["sha256"],
        collision_path: zone["collision"]["derived_directional_grid"]["sha256"],
        entity_path: zone["entities"]["sha256"],
    }
    for path, expected in expected_hashes.items():
        actual = sha256_file(path)
        if actual != expected:
            raise ValueError(f"qualified input hash changed: {path}: {actual} != {expected}")

    visual_assets = []
    for row in zone["visual_dependencies"]:
        if not row["resolved"]:
            raise ValueError(f"unresolved visual dependency: {row['source_name']}")
        visual_assets.append({
            "kind": row["kind"],
            "source_name": row["source_name"],
            "source_path": row["source_path"],
            "sha256": row["sha256"],
            "width_px": row["dimensions"]["width_px"],
            "height_px": row["dimensions"]["height_px"],
        })

    autotiles = animation_records(
        game_root, "animations/manifest.json", map_id, zone["zone_id"]
    )
    map_effects = animation_records(
        game_root, "animations/map_effects/manifest.json", map_id, zone["zone_id"]
    )
    normalized_layers = [
        {"index": layer["index"], "rows": layer["rows"]}
        for layer in geometry["layers"]
    ]
    tile_catalog = materialize_relict_tile_catalog(
        source, game_root, map_key, normalized_layers, zone["tileset"],
        visual_assets, autotiles,
    )
    vfx_manifest_path = game_root / "vfx/manifest.json"
    vfx_manifest = load_json(vfx_manifest_path)
    environmental_vfx = [
        row for row in vfx_manifest["environment_assets"]
        if contains_map_context(row.get("contexts", []), map_id, zone["zone_id"])
    ]

    inputs = [
        file_ref(path, game_root)
        for path in (zone_path, geometry_path, collision_path, entity_path, timeline_path)
    ]
    for row in autotiles + map_effects:
        inputs.append(file_ref(game_root / row["metadata_file"], game_root))
    inputs.sort(key=lambda row: row["path"])

    ir = {
        "schema_version": "1.0.0",
        "identity": {
            "game_id": "relict",
            "zone_id": zone["zone_id"],
            "source_map_id": map_id,
            "source_name": zone["name"],
            "zone_type": zone["zone_type"],
            "variant_id": None,
        },
        "status": "SOURCE_DOCUMENTED",
        "provenance": {
            "source_repository": zone["source"]["repository"],
            "source_commit": zone["source"]["commit"],
            "source_path": zone["source"]["source_path"],
            "source_sha256": zone["source"]["sha256"],
            "inputs": inputs,
        },
        "geometry": {
            "width_tiles": zone["geometry"]["width_tiles"],
            "height_tiles": zone["geometry"]["height_tiles"],
            "source_tile_size_px": zone["geometry"]["tile_size_px"],
            "width_px": zone["geometry"]["width_px"],
            "height_px": zone["geometry"]["height_px"],
            "coordinate_origin": "TOP_LEFT_X_RIGHT_Y_DOWN",
        },
        "tile_layers": {
            "encoding": "ROW_MAJOR_U16_TILE_IDS",
            "draw_order": "ASCENDING_LAYER_INDEX",
            "layers": normalized_layers,
            "tileset": zone["tileset"],
            "visual_assets": visual_assets,
            "tile_catalog": tile_catalog,
        },
        "collision": {
            "semantics": "ALLOWED_EXIT_DIRECTIONS_PER_SOURCE_TILE",
            "direction_bits": {"down": 1, "left": 2, "right": 4, "up": 8},
            "allowed_direction_masks": collision["allowed_direction_masks"],
            "terrain_tags": collision["effective_terrain_tags"],
            "dynamic_entity_collision_separate": True,
        },
        "entities": {
            "source_complete": entities["source_complete"],
            "source_identities_redacted": entities["source_identities_redacted"],
            "placements": entities["placements"],
        },
        "environment": {
            "panorama": zone["tileset"]["panorama"],
            "fog": zone["tileset"]["fog"],
            "timeline": timeline,
        },
        "animations": {
            "autotiles": autotiles,
            "environmental_vfx": environmental_vfx,
            "map_effects": map_effects,
        },
        "target_contract": {
            "target": "PMDO_GROUND_0.8.12",
            "preserve": [
                "geometry", "tile_layer_order", "tile_alpha", "directional_collision",
                "terrain_tags", "autotile_frames", "autotile_timing", "environmental_vfx",
                "visual_timeline", "redacted_entity_placements",
            ],
            "forbid": [
                "casting_identity", "character_sprite", "dialogue", "script_body",
                "audio_binary", "runtime_write_before_validation",
            ],
            "runtime_destination_allowed": False,
        },
    }
    validate_ir(ir)
    return ir


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--game", choices=("relict", "nova", "reminiscencia"), default="relict")
    parser.add_argument("--map-id", type=int, required=True)
    parser.add_argument("--game-root", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if args.game != "relict":
        raise SystemExit(f"{args.game}: source importer not implemented yet")
    ir = build_relict(args.game_root, args.source, args.map_id)
    output = args.output or DEFAULT_IR_ROOT / f"map_{args.map_id:03d}.json"
    write_json(output, ir)
    print(json.dumps({
        "result": "MAP_IR_PASS",
        "output": output.as_posix(),
        "sha256": sha256_file(output),
        "layers": len(ir["tile_layers"]["layers"]),
        "placements": len(ir["entities"]["placements"]),
        "autotile_animations": len(ir["animations"]["autotiles"]),
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
