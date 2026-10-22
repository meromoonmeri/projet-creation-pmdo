#!/usr/bin/env python3
"""Materialize a canonical PMD Red Ground with preserved project entities only.

This is the durable counterpart of the integration-preserving migration already
used for ``t01p01``.  The authenticated canonical Ground supplies every visual,
collision, animation, geometry, and non-entity value.  Existing project Markers
and Spawners are copied byte-semantically into the canonical entity layers;
MapChars and GroundObjects are rejected rather than approximated or discarded.
The official fixture builder independently proves the resulting difference is
ordered additive Markers/Spawners only before PMDO can load it.
"""

from __future__ import annotations

import argparse
import copy
import hashlib
import importlib.util
import json
import os
import shutil
from pathlib import Path
from typing import Any


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_json_bom(path: Path, value: object) -> None:
    path.write_bytes(
        ("\ufeff" + json.dumps(value, ensure_ascii=False, separators=(",", ":"))).encode(
            "utf-8"
        )
    )


def load_fixture_builder(root: Path):
    path = root / "tools/build_pmdred_eu_runtime_fixture.py"
    spec = importlib.util.spec_from_file_location("pmdred_fixture_builder", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load fixture builder {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def entity_summary(layers: list[dict[str, Any]]) -> dict[str, Any]:
    marker_names = [
        marker.get("EntName") for layer in layers for marker in layer.get("Markers", [])
    ]
    spawners = [
        {"NPCName": spawner.get("NPCName"), "EntName": spawner.get("EntName")}
        for layer in layers
        for spawner in layer.get("Spawners", [])
    ]
    return {
        "markers": len(marker_names),
        "spawners": len(spawners),
        "map_characters": sum(len(layer.get("MapChars", [])) for layer in layers),
        "ground_objects": sum(len(layer.get("GroundObjects", [])) for layer in layers),
        "marker_names": marker_names,
        "spawner_names": spawners,
    }


def materialize(
    root: Path,
    asset: str,
    canonical_root: Path,
    active_ground: Path,
    output: Path,
) -> dict[str, Any]:
    if output.exists():
        raise ValueError(f"refusing existing output {output}")
    canonical_ground = canonical_root / "grounds" / f"{asset}.rsground"
    canonical_tile = canonical_root / "tiles" / f"{asset}_Base.tile"
    conversion_report = canonical_root / "conversion_report.json"
    if not all(path.is_file() for path in (canonical_ground, canonical_tile, conversion_report)):
        raise ValueError(f"missing authenticated canonical inputs for {asset}")
    if not active_ground.is_file():
        raise ValueError(f"missing active project Ground {active_ground}")

    report = read_json(conversion_report)
    row = next((item for item in report.get("results", []) if item.get("asset") == asset), None)
    if row is None:
        raise ValueError(f"{asset} is absent from the conversion report")
    expected = row["output_sha256"]
    if expected != {
        "rsground": sha256_file(canonical_ground),
        "tile": sha256_file(canonical_tile),
    }:
        raise ValueError("canonical inputs differ from the authenticated conversion report")

    canonical = read_json(canonical_ground)
    active = read_json(active_ground)
    canonical_object = canonical.get("Object", {})
    active_object = active.get("Object", {})
    if canonical_object.get("AssetName") != asset or active_object.get("AssetName") != asset:
        raise ValueError("canonical or active Ground AssetName differs from the selected ID")
    canonical_layers = canonical_object.get("Entities")
    active_layers = active_object.get("Entities")
    if not isinstance(canonical_layers, list) or not isinstance(active_layers, list):
        raise ValueError("Ground entity layers are not serialized lists")
    if len(canonical_layers) != len(active_layers):
        raise ValueError("active and canonical Ground entity-layer counts differ")

    active_entities = entity_summary(active_layers)
    if active_entities["map_characters"] or active_entities["ground_objects"]:
        raise ValueError(
            "active Ground contains MapChars/GroundObjects; narrow entity integration cannot preserve it"
        )
    if not active_entities["markers"] and not active_entities["spawners"]:
        raise ValueError("active Ground contains no project Markers or Spawners to preserve")

    integrated = copy.deepcopy(canonical)
    integrated_layers = integrated["Object"]["Entities"]
    layer_records: list[dict[str, int]] = []
    for index, (canonical_layer, active_layer, integrated_layer) in enumerate(
        zip(canonical_layers, active_layers, integrated_layers, strict=True)
    ):
        # Current canonical conversion Grounds are entity-free.  Refuse an
        # ambiguous merge instead of deduplicating or guessing if that changes.
        for category in ("Markers", "Spawners", "MapChars", "GroundObjects"):
            if canonical_layer.get(category, []):
                raise ValueError(
                    f"canonical entity layer {index} has nonempty {category}; explicit merge required"
                )
        markers = copy.deepcopy(active_layer.get("Markers", []))
        spawners = copy.deepcopy(active_layer.get("Spawners", []))
        integrated_layer["Markers"] = markers
        integrated_layer["Spawners"] = spawners
        layer_records.append(
            {"layer": index, "added_markers": len(markers), "added_spawners": len(spawners)}
        )

    output_ground = output / "grounds" / f"{asset}.rsground"
    output_tile = output / "tiles" / f"{asset}_Base.tile"
    output_ground.parent.mkdir(parents=True)
    output_tile.parent.mkdir(parents=True)
    write_json_bom(output_ground, integrated)
    shutil.copyfile(canonical_tile, output_tile)
    shutil.copyfile(conversion_report, output / "conversion_report.json")

    builder = load_fixture_builder(root)
    proof = builder.verify_additive_entity_integration(output_ground, canonical_ground)
    if proof.get("mode") != "additive_markers_spawners_only":
        raise ValueError("official fixture builder rejected the narrow entity proof")
    if proof["integrated_ground_sha256"] != sha256_file(output_ground):
        raise ValueError("official entity proof hash differs from materialized Ground")
    if sha256_file(output_tile) != sha256_file(canonical_tile):
        raise ValueError("materialization changed the canonical tile bytes")

    record = {
        "schema": 1,
        "ground": asset,
        "result": "PASS_ADDITIVE_MARKERS_SPAWNERS_ONLY",
        "canonical_root": str(canonical_root.relative_to(root)),
        "canonical_ground": str(canonical_ground.relative_to(root)),
        "canonical_ground_sha256": sha256_file(canonical_ground),
        "canonical_tile": str(canonical_tile.relative_to(root)),
        "canonical_tile_sha256": sha256_file(canonical_tile),
        "active_ground": str(active_ground.relative_to(root)),
        "active_ground_sha256": sha256_file(active_ground),
        "active_entities": active_entities,
        "layers": layer_records,
        "integrated_ground": str(output_ground.relative_to(root)),
        "integrated_ground_sha256": sha256_file(output_ground),
        "integrated_tile": str(output_tile.relative_to(root)),
        "integrated_tile_sha256": sha256_file(output_tile),
        "tile_bytes_unchanged": True,
        "official_fixture_builder_proof": proof,
        "non_entity_values_source": "authenticated canonical Ground",
        "preserved_entity_categories": ["Markers", "Spawners"],
        "rejected_entity_categories": ["MapChars", "GroundObjects"],
    }
    (output / "entity_integration.json").write_text(
        json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return record


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--id", required=True)
    parser.add_argument(
        "--canonical-root",
        type=Path,
        default=Path(".runtime-cache/pmdred-eu-remaining-regenerated-v201"),
    )
    parser.add_argument("--active-ground", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    asset = args.id.lower()

    def rooted(path: Path) -> Path:
        return path if path.is_absolute() else root / path

    active = rooted(args.active_ground or Path(f"Data/Ground/{asset}.rsground"))
    record = materialize(
        root,
        asset,
        rooted(args.canonical_root),
        active,
        rooted(args.output),
    )
    print(
        "PMDRED_EU_ENTITY_INTEGRATION_PASS "
        f"ground={asset} markers={record['active_entities']['markers']} "
        f"spawners={record['active_entities']['spawners']} "
        f"integrated_sha256={record['integrated_ground_sha256']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
