#!/usr/bin/env python3
"""Audit all 219 archive-backed PMD Red EU Ground candidates.

The candidate root is deliberately external/ignored.  This audit authenticates
its deterministic conversion report, compares every graphical tile at every
source-local animation tick across two complete local cycles, checks collision
against the independently decoded BMA auxiliary stream, and reconciles every
candidate with the preserved legacy reserve.  The second cycle is mandatory:
it detects serialized PMDO schedules that agree initially but drift at wrap.
It does not claim that canonical scripts, music, entries/exits, or exact-PMDO
runtime behavior have already been reconstructed.
"""
from __future__ import annotations

import argparse
import concurrent.futures
import hashlib
import json
import math
import os
import sys
from collections import Counter
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

import convert_red_all as converter
from pmdred_dungeon_ground import decode_bma_auxiliary_layers
from render_ground_png import read_tile_sheet

DIRECT_TYPES = {10, 11}
GROUND_COMPONENTS = (
    "TexSize", "Layers", "obstacles", "Entities", "EdgeView", "Music",
    "Decorations", "Background", "BlankBG", "NoSwitching", "ViewCenter",
    "ViewOffset",
)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def source_paths(source: Path, dependency: dict[str, Any]) -> dict[str, Path | None]:
    paths: dict[str, Path | None] = {
        "bpl": source / f"{dependency['bpl']}.bpl",
        "bpc": source / f"{dependency['bpc']}.bpc",
        "bma": source / f"{dependency['bma']}.bma",
    }
    for slot in range(4):
        name = dependency[f"bpa_{slot}"]
        paths[f"bpa_{slot}"] = source / f"{name}.bpa" if name is not None else None
    return paths


def cell_period(
    chunk_ids: list[int],
    chunks: list[list[int]],
    tile_count: int,
    bpa_slots: list[dict[str, Any] | None],
    renderer: converter.Renderer,
    palette_specs: list[tuple[int, int]],
    animated_palettes: dict[int, list[list[tuple[int, int, int, int]]]],
) -> int:
    period = 1
    used_bpa_slots: set[int] = set()
    used_palettes: set[int] = set()
    for chunk_id in chunk_ids:
        if not 0 < chunk_id < len(chunks):
            continue
        for entry in chunks[chunk_id]:
            tile_index = entry & 0x3FF
            palette_index = (entry >> 12) & 0xF
            if tile_index >= tile_count:
                location = renderer.bpa_location(tile_index)
                if location is not None:
                    used_bpa_slots.add(location[0])
            if palette_index in animated_palettes:
                used_palettes.add(palette_index)
    for slot_index in used_bpa_slots:
        slot = bpa_slots[slot_index]
        assert slot is not None
        if slot["nf"] > 1 and slot["cycle"] > 0:
            period = math.lcm(period, slot["cycle"])
    for palette_index in used_palettes:
        duration, frame_count = palette_specs[palette_index]
        period = math.lcm(period, duration * frame_count)
    return period


def audit_candidate_worker(task: tuple[str, dict[str, Any], str, str]) -> dict[str, Any]:
    asset, dependency, source_text, candidate_text = task
    source = Path(source_text)
    candidate = Path(candidate_text)
    paths = source_paths(source, dependency)
    ground_path = candidate / "grounds" / f"{asset}.rsground"
    tile_path = candidate / "tiles" / f"{asset}_Base.tile"
    ground = read_json(ground_path)["Object"]
    sheet = read_tile_sheet(tile_path)

    palettes, palette_specs, animated_palettes = converter.parse_bpl(str(paths["bpl"]))
    chunk_width, chunk_height, bpc_tiles, chunks = converter.parse_bpc(str(paths["bpc"]))
    width, height, map_width, map_height, layer_count, map_layers = converter.decode_bma(
        str(paths["bma"])
    )
    bpa_slots = converter.parse_bpa(
        [str(paths[f"bpa_{slot}"]) if paths[f"bpa_{slot}"] else None for slot in range(4)]
    )
    renderer = converter.Renderer(
        bpc_tiles, bpa_slots, palettes, animated_palettes, palette_specs, chunks
    )

    layers = ground.get("Layers", [])
    if len(layers) != 1:
        raise ValueError(f"{asset}: candidate has {len(layers)} map layers, expected one")
    grid = layers[0].get("Tiles", [])
    if len(grid) != width or {len(column) for column in grid} != {height}:
        raise ValueError(f"{asset}: candidate grid dimensions differ from BMA camera")
    if ground.get("TexSize") != 1:
        raise ValueError(f"{asset}: candidate TexSize is not 1")
    if ground.get("AssetName") != asset:
        raise ValueError(f"{asset}: candidate AssetName mismatch")

    referenced_sheet_locations: set[tuple[int, int]] = set()
    tile_tick_comparisons = 0
    source_cell_ticks = 0
    animated_cells = 0
    maximum_cell_period = 1
    for cell_y in range(map_height):
        for cell_x in range(map_width):
            cell_index = cell_y * map_width + cell_x
            chunk_ids = [
                map_layers[layer][cell_y * 64 + cell_x] for layer in range(layer_count)
            ]
            period = cell_period(
                chunk_ids, chunks, len(bpc_tiles), bpa_slots, renderer,
                palette_specs, animated_palettes,
            )
            # Validate two complete source-local cycles.  One cycle cannot
            # detect a candidate whose serialized cycle was shortened by an
            # equal prefix/suffix and only drifts after its first wrap.
            source_cell_ticks += period * 2
            maximum_cell_period = max(maximum_cell_period, period)
            if period > 1:
                animated_cells += 1
            for tick in range(period * 2):
                expected_cell = converter.opaque(
                    renderer.chunk_cell(chunk_ids, tick, chunk_width, chunk_height)
                )
                for local_x in range(chunk_width):
                    for local_y in range(chunk_height):
                        tile_x = cell_x * chunk_width + local_x
                        tile_y = cell_y * chunk_height + local_y
                        if tile_x >= width or tile_y >= height:
                            continue
                        tile_layers = grid[tile_x][tile_y].get("Layers", [])
                        if len(tile_layers) != 1:
                            raise ValueError(
                                f"{asset}: ({tile_x},{tile_y}) has {len(tile_layers)} tile layers"
                            )
                        tile_layer = tile_layers[0]
                        frames = tile_layer.get("Frames", [])
                        frame_length = int(tile_layer.get("FrameLength", 0))
                        if not frames or frame_length <= 0:
                            raise ValueError(
                                f"{asset}: ({tile_x},{tile_y}) has invalid animation schedule"
                            )
                        frame = frames[(tick // frame_length) % len(frames)]
                        if frame.get("Sheet") != f"{asset}_Base":
                            raise ValueError(
                                f"{asset}: ({tile_x},{tile_y}) references foreign sheet "
                                f"{frame.get('Sheet')!r}"
                            )
                        location = frame.get("TexLoc", {})
                        key = (int(location.get("X", -1)), int(location.get("Y", -1)))
                        actual = sheet.get(key)
                        if actual is None:
                            raise ValueError(f"{asset}: missing sheet tile {key}")
                        referenced_sheet_locations.add(key)
                        expected = expected_cell.crop((
                            local_x * 8, local_y * 8,
                            (local_x + 1) * 8, (local_y + 1) * 8,
                        ))
                        tile_tick_comparisons += 1
                        if expected.tobytes() != actual.tobytes():
                            raise ValueError(
                                f"{asset}: graphical mismatch at map tile "
                                f"({tile_x},{tile_y}), source tick {tick}, sheet tile {key}"
                            )

    bma_data = paths["bma"].read_bytes()  # type: ignore[union-attr]
    auxiliary = decode_bma_auxiliary_layers(bma_data, dependency["bma"])
    if (auxiliary.width, auxiliary.height) != (width, height):
        raise ValueError(f"{asset}: independent BMA camera dimensions disagree")
    if len(auxiliary.collisions) > 1:
        raise ValueError(f"{asset}: more than one collision layer cannot map to PMDO")
    expected_collision = auxiliary.collisions[0] if auxiliary.collisions else bytes(width * height)
    obstacles = ground.get("obstacles", [])
    if len(obstacles) != width or {len(column) for column in obstacles} != {height}:
        raise ValueError(f"{asset}: obstacle dimensions differ from BMA camera")
    for x, column in enumerate(obstacles):
        for y, obstacle in enumerate(column):
            expected_bounds = {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8}
            if obstacle.get("Bounds") != expected_bounds:
                raise ValueError(f"{asset}: obstacle ({x},{y}) has noncanonical bounds")
            if bool(obstacle.get("Tags", 0)) != bool(expected_collision[y * width + x]):
                raise ValueError(f"{asset}: obstacle ({x},{y}) differs from BMA collision")

    entities = ground.get("Entities", [])
    entity_counts = Counter()
    for layer in entities:
        for collection in ("MapChars", "GroundObjects", "Spawners", "Markers"):
            entity_counts[collection] += len(layer.get(collection, []))
    if any(entity_counts.values()):
        raise ValueError(f"{asset}: graphical candidate fabricates event entities")

    return {
        "id": asset,
        "status": "pass",
        "map_file_id": dependency["map_file_id"],
        "resources": {
            "bpl": dependency["bpl"],
            "bpc": dependency["bpc"],
            "bma": dependency["bma"],
            "bpa": [dependency[f"bpa_{slot}"] for slot in range(4)],
        },
        "dimensions_tiles": [width, height],
        "graphical_layer_count": layer_count,
        "source_chunk_cell_count": map_width * map_height,
        "validated_local_cycle_count": 2,
        "source_cell_tick_count": source_cell_ticks,
        "tile_tick_comparison_count": tile_tick_comparisons,
        "animated_cell_count": animated_cells,
        "maximum_cell_period": maximum_cell_period,
        "referenced_sheet_tile_count": len(referenced_sheet_locations),
        "sheet_tile_count": len(sheet),
        "collision_layer_count": len(auxiliary.collisions),
        "solid_cell_count": sum(value != 0 for value in expected_collision),
        "unknown_bma_data_present": auxiliary.unknown_data is not None,
        "unknown_bma_data_nonzero_cells": (
            sum(value != 0 for value in auxiliary.unknown_data)
            if auxiliary.unknown_data is not None else 0
        ),
        "candidate_sha256": {
            "rsground": sha256_file(ground_path),
            "tile": sha256_file(tile_path),
        },
    }


def legacy_comparison(
    asset: str,
    candidate_root: Path,
    legacy_grounds: Path,
    legacy_tiles: Path,
) -> dict[str, Any]:
    candidate_ground_path = candidate_root / "grounds" / f"{asset}.rsground"
    candidate_tile_path = candidate_root / "tiles" / f"{asset}_Base.tile"
    legacy_ground_path = legacy_grounds / f"{asset}.rsground"
    legacy_tile_path = legacy_tiles / f"{asset}_Base.tile"
    if not legacy_ground_path.is_file() or not legacy_tile_path.is_file():
        return {"legacy_status": "canonical_missing_from_legacy"}

    candidate_ground = read_json(candidate_ground_path)["Object"]
    legacy_ground = read_json(legacy_ground_path)["Object"]
    changed_components = [
        component for component in GROUND_COMPONENTS
        if candidate_ground.get(component) != legacy_ground.get(component)
    ]
    candidate_without_comment = dict(candidate_ground)
    legacy_without_comment = dict(legacy_ground)
    candidate_without_comment.pop("Comment", None)
    legacy_without_comment.pop("Comment", None)
    legacy_entity_counts = Counter()
    legacy_entity_names: list[str] = []
    for layer in legacy_ground.get("Entities", []):
        for collection in ("MapChars", "GroundObjects", "Spawners", "Markers"):
            entities = layer.get(collection, [])
            legacy_entity_counts[collection] += len(entities)
            legacy_entity_names.extend(
                entity.get("EntName", "") for entity in entities if entity.get("EntName")
            )
    tile_equal = sha256_file(candidate_tile_path) == sha256_file(legacy_tile_path)
    semantic_equal_without_comment = candidate_without_comment == legacy_without_comment
    return {
        "legacy_status": (
            "exact_reusable" if tile_equal and semantic_equal_without_comment
            else "differs_from_canonical_regeneration"
        ),
        "tile_bytes_equal": tile_equal,
        "ground_semantic_equal_without_comment": semantic_equal_without_comment,
        "changed_ground_components": changed_components,
        "legacy_entity_counts": dict(sorted(legacy_entity_counts.items())),
        "legacy_entity_names": sorted(legacy_entity_names),
        "legacy_sha256": {
            "rsground": sha256_file(legacy_ground_path),
            "tile": sha256_file(legacy_tile_path),
        },
    }


def count_by(records: list[dict[str, Any]], path: tuple[str, ...]) -> dict[str, int]:
    counts: Counter[str] = Counter()
    for record in records:
        value: Any = record
        for key in path:
            value = value[key]
        counts[str(value)] += 1
    return dict(sorted(counts.items()))


def run(args: argparse.Namespace) -> int:
    manifest = read_json(args.manifest)
    conversion_entries = manifest["ground_conversion_table"]["entries"]
    remaining_entries = [
        entry for entry in conversion_entries if entry["conversion_type"] not in DIRECT_TYPES
    ]
    if len(remaining_entries) != 219:
        raise ValueError(f"expected 219 remaining conversions, found {len(remaining_entries)}")
    remaining_ids = {entry["stable_ground_id"] for entry in remaining_entries}
    canonical_ids = {entry["stable_ground_id"] for entry in conversion_entries}
    map_files = {
        entry["map_file_id"]: entry for entry in manifest["map_files_table"]["entries"]
    }
    dependencies = {
        entry["stable_ground_id"]: map_files[entry["map_file_id"]]
        for entry in remaining_entries
    }

    report_path = args.candidate_root / "conversion_report.json"
    conversion_report = read_json(report_path)
    manifest_hash = sha256_file(args.manifest)
    converter_hash = sha256_file(ROOT / "tools/convert_red_all.py")
    if conversion_report.get("source_manifest_sha256") != manifest_hash:
        raise ValueError("candidate conversion report does not authenticate this manifest")
    if conversion_report.get("converter", {}).get("sha256") != converter_hash:
        raise ValueError("candidate conversion report does not authenticate this converter")
    if conversion_report.get("failure_count") != 0:
        raise ValueError("candidate conversion report contains failures")
    conversion_results = {
        result["asset"]: result for result in conversion_report.get("results", [])
    }
    if set(conversion_results) != remaining_ids:
        raise ValueError("candidate conversion report inventory is not exactly the 219 remaining IDs")

    ground_inventory = {path.stem for path in (args.candidate_root / "grounds").glob("*.rsground")}
    tile_inventory = {
        path.name.removesuffix("_Base.tile")
        for path in (args.candidate_root / "tiles").glob("*_Base.tile")
    }
    if ground_inventory != remaining_ids or tile_inventory != remaining_ids:
        raise ValueError("candidate output inventory is not exactly the 219 remaining IDs")

    tasks = [
        (asset, dependencies[asset], str(args.source_dir), str(args.candidate_root))
        for asset in sorted(remaining_ids)
    ]
    records: list[dict[str, Any]] = []
    failures: list[dict[str, str]] = []
    with concurrent.futures.ProcessPoolExecutor(max_workers=args.workers) as pool:
        futures = {pool.submit(audit_candidate_worker, task): task[0] for task in tasks}
        complete = 0
        for future in concurrent.futures.as_completed(futures):
            asset = futures[future]
            complete += 1
            try:
                record = future.result()
                expected_hashes = conversion_results[asset].get("output_sha256", {})
                if record["candidate_sha256"] != expected_hashes:
                    raise ValueError(f"{asset}: files differ from authenticated conversion report")
                record["conversion_type"] = next(
                    entry["conversion_type"] for entry in remaining_entries
                    if entry["stable_ground_id"] == asset
                )
                record["weather_id"] = next(
                    entry["weather_id"] for entry in remaining_entries
                    if entry["stable_ground_id"] == asset
                )
                record["legacy"] = legacy_comparison(
                    asset, args.candidate_root, args.legacy_ground_dir, args.legacy_tile_dir
                )
                records.append(record)
                print(f"{complete:03d}/219 PASS {asset}", flush=True)
            except Exception as error:
                failures.append({"id": asset, "error": str(error)})
                print(f"{complete:03d}/219 FAIL {asset}: {error}", flush=True)
    records.sort(key=lambda record: record["id"])
    failures.sort(key=lambda record: record["id"])

    legacy_ground_ids = {path.stem for path in args.legacy_ground_dir.glob("*.rsground")}
    legacy_tile_ids = {
        path.name.removesuffix("_Base.tile") for path in args.legacy_tile_dir.glob("*_Base.tile")
    }
    if legacy_ground_ids != legacy_tile_ids:
        raise ValueError("legacy Ground/tile inventories disagree")
    legacy_extras = sorted(legacy_ground_ids - canonical_ids)
    canonical_missing = sorted(remaining_ids - legacy_ground_ids)

    legacy_status_counts = count_by(records, ("legacy", "legacy_status"))
    tile_equal_count = sum(
        record["legacy"].get("tile_bytes_equal") is True for record in records
    )
    component_change_counts = Counter(
        component
        for record in records
        for component in record["legacy"].get("changed_ground_components", [])
    )
    total_tile_tick_comparisons = sum(
        record["tile_tick_comparison_count"] for record in records
    )
    total_source_cell_ticks = sum(record["source_cell_tick_count"] for record in records)
    report = {
        "schema": "new-era.pmdred-eu-remaining-candidate-audit.v1",
        "scope": {
            "included": [
                "all 219 canonical conversion-table Grounds except direct types 10/11",
                "authenticated normalized EU resources and deterministic candidate outputs",
                "every graphical tile at every source-local animation tick across two complete local cycles",
                "BMA camera dimensions, collision, obstacle bounds, and unknown-data separation",
                "complete reconciliation with the preserved legacy reserve",
            ],
            "not_yet_proven": [
                "exact PMDO 0.8.12 loading and rendered screenshots",
                "canonical event entities, scripts, cinematics, entries, exits, and transitions",
                "canonical music assignment and playback",
            ],
        },
        "authority": {
            "rom_sha256": manifest["authority"]["rom"]["sha256"],
            "manifest": str(args.manifest.relative_to(ROOT)),
            "manifest_sha256": manifest_hash,
            "converter": "tools/convert_red_all.py",
            "converter_sha256": converter_hash,
            "conversion_report_sha256": sha256_file(report_path),
        },
        "summary": {
            "expected_candidate_count": 219,
            "passing_candidate_count": len(records),
            "failure_count": len(failures),
            "validated_local_cycle_count": 2,
            "source_cell_tick_count": total_source_cell_ticks,
            "tile_tick_comparison_count": total_tile_tick_comparisons,
            "all_graphical_tick_comparisons_exact": not failures and len(records) == 219,
            "canonical_ids_missing_from_legacy_count": len(canonical_missing),
            "legacy_noncanonical_extra_count": len(legacy_extras),
            "legacy_overlap_count": len(remaining_ids & legacy_ground_ids),
            "legacy_tile_byte_equal_count": tile_equal_count,
            "legacy_tile_byte_different_count": len(remaining_ids & legacy_ground_ids) - tile_equal_count,
            "legacy_status_counts": legacy_status_counts,
            "legacy_changed_component_counts": dict(sorted(component_change_counts.items())),
        },
        "inventory": {
            "canonical_ids_missing_from_legacy": canonical_missing,
            "legacy_ids_outside_canonical_conversion_table": legacy_extras,
        },
        "failures": failures,
        "candidates": records,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(report, ensure_ascii=False, sort_keys=True, indent=2) + "\n",
        encoding="utf-8",
    )
    print(
        f"COMPLETE {len(records)}/219 candidates; {total_tile_tick_comparisons} "
        f"tile/tick comparisons; {len(failures)} failures",
        flush=True,
    )
    return 0 if not failures and len(records) == 219 else 1


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    result.add_argument("--manifest", type=Path, default=ROOT / "docs/pmdred_eu/ground_manifest.json")
    result.add_argument("--source-dir", type=Path, required=True)
    result.add_argument("--candidate-root", type=Path, required=True)
    result.add_argument("--legacy-ground-dir", type=Path, default=ROOT / "RESERVE/red_grounds")
    result.add_argument("--legacy-tile-dir", type=Path, default=ROOT / "RESERVE/red_tiles")
    result.add_argument("--output", type=Path, required=True)
    result.add_argument("--workers", type=int, default=max(1, min(8, os.cpu_count() or 4)))
    return result


def main() -> int:
    return run(parser().parse_args())


if __name__ == "__main__":
    raise SystemExit(main())
