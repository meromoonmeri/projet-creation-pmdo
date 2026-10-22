#!/usr/bin/env python3
"""Apply a strictly additive PMDO Sheet alias to an already authenticated fixture.

The regular runtime-fixture builder first authenticates the canonical conversion
against the pinned report and plan.  This postprocessor then changes only exact
serialized ``Sheet`` values in fixture-local Ground copies, keeps the canonical
.tile bytes unchanged under an alias, and restores any preexisting same-name
repository tile in the fixture.  It never edits the candidate root or repository
content.
"""

from __future__ import annotations

import argparse
import copy
import hashlib
import importlib.util
import json
import os
import re
from pathlib import Path
from typing import Any


def load_fixture_module(root: Path):
    path = root / "tools/build_pmdred_eu_runtime_fixture.py"
    spec = importlib.util.spec_from_file_location("pmdred_fixture_builder", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load fixture builder {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def json_bom_bytes(value: object) -> bytes:
    return (
        "\ufeff" + json.dumps(value, ensure_ascii=False, separators=(",", ":"))
    ).encode("utf-8")


def apply_sheet_alias(
    payload: dict[str, Any], canonical_sheet: str, aliased_sheet: str
) -> tuple[dict[str, Any], int]:
    """Copy a Ground while replacing only exact values of keys named Sheet."""
    if canonical_sheet == aliased_sheet:
        raise ValueError("sheet alias must differ from the canonical sheet name")
    if not re.fullmatch(r"[A-Za-z0-9_ -]+", aliased_sheet):
        raise ValueError(f"unsafe PMDO sheet alias {aliased_sheet!r}")

    rewritten = copy.deepcopy(payload)
    replacement_count = 0

    def visit(value: Any, path: tuple[str, ...] = ()) -> None:
        nonlocal replacement_count
        if isinstance(value, dict):
            for key, item in value.items():
                child_path = (*path, str(key))
                if key == "Sheet" and item == canonical_sheet:
                    value[key] = aliased_sheet
                    replacement_count += 1
                    continue
                if isinstance(item, str) and (
                    canonical_sheet in item or aliased_sheet in item
                ):
                    raise ValueError(
                        "sheet name occurs outside an exact Sheet value at "
                        + ".".join(child_path)
                    )
                visit(item, child_path)
        elif isinstance(value, list):
            for index, item in enumerate(value):
                visit(item, (*path, str(index)))

    visit(rewritten)
    if replacement_count == 0:
        raise ValueError(f"canonical sheet {canonical_sheet!r} is not referenced")
    return rewritten, replacement_count


def replace_file_atomically(path: Path, payload: bytes) -> None:
    temporary = path.with_name(path.name + ".alias.tmp")
    with temporary.open("wb") as stream:
        stream.write(payload)
        stream.flush()
        os.fsync(stream.fileno())
    os.replace(temporary, path)


def relative_or_absolute(path: Path, root: Path) -> str:
    try:
        return str(path.relative_to(root))
    except ValueError:
        return str(path)


def apply_alias(
    root: Path,
    fixture: Path,
    candidate_root: Path,
    asset: str,
    alias: str,
) -> dict[str, Any]:
    builder = load_fixture_module(root)
    manifest_path = fixture / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest.get("conversion_set") != "remaining":
        raise ValueError("sheet alias requires an authenticated remaining-set fixture")
    if manifest.get("candidate_count") != 1:
        raise ValueError("sheet alias postprocessing requires exactly one candidate")
    entry = manifest["entries"][0]
    if entry.get("id") != asset:
        raise ValueError(f"fixture candidate is not {asset}")
    if manifest.get("sheet_aliases") or entry.get("sheet_alias"):
        raise ValueError("fixture already contains sheet-alias metadata")

    canonical_sheet = f"{asset}_Base"
    if alias == canonical_sheet:
        raise ValueError("alias is identical to the canonical sheet")
    source_ground = candidate_root / "grounds" / f"{asset}.rsground"
    source_tile = candidate_root / "tiles" / f"{canonical_sheet}.tile"
    if not source_ground.is_file() or not source_tile.is_file():
        raise ValueError(f"missing canonical candidate files for {asset}")
    if entry.get("source_ground_sha256") != sha256_file(source_ground):
        raise ValueError("fixture manifest does not authenticate the canonical Ground")
    if entry.get("source_tile_sha256") != sha256_file(source_tile):
        raise ValueError("fixture manifest does not authenticate the canonical tile")

    canonical_payload = builder.read_json(source_ground)
    aliased_payload, canonical_rewrite_count = apply_sheet_alias(
        canonical_payload, canonical_sheet, alias
    )
    aliased_ground_bytes = json_bom_bytes(aliased_payload)
    aliased_ground_sha256 = hashlib.sha256(aliased_ground_bytes).hexdigest()
    # The transform is exactly reversible and therefore cannot alter geometry,
    # entities, texture coordinates, or any non-Sheet serialized value.
    normalized_payload, reverse_count = apply_sheet_alias(
        aliased_payload, alias, canonical_sheet
    )
    if reverse_count != canonical_rewrite_count or normalized_payload != canonical_payload:
        raise ValueError("sheet alias transform is not exactly reversible")

    quest = fixture / "quest"
    fixture_ground = quest / "Data/Ground" / f"{asset}.rsground"
    fixture_sink = quest / "Data/Ground/pmdred_eu_validation_sink.rsground"
    fixture_ground_payload, fixture_rewrite_count = apply_sheet_alias(
        builder.read_json(fixture_ground), canonical_sheet, alias
    )
    sink_payload, sink_rewrite_count = apply_sheet_alias(
        builder.read_json(fixture_sink), canonical_sheet, alias
    )
    if fixture_rewrite_count != canonical_rewrite_count:
        raise ValueError("fixture Ground Sheet count differs from canonical candidate")
    if sink_rewrite_count != canonical_rewrite_count:
        raise ValueError("fixture sink Sheet count differs from canonical candidate")

    canonical_fixture_tile = quest / "Content/Tile" / f"{canonical_sheet}.tile"
    alias_fixture_tile = quest / "Content/Tile" / f"{alias}.tile"
    historical_tile = root / "Content/Tile" / f"{canonical_sheet}.tile"
    repository_alias_tile = root / "Content/Tile" / f"{alias}.tile"
    if not canonical_fixture_tile.is_symlink():
        raise ValueError("canonical fixture tile is not the builder's isolated symlink")
    if sha256_file(canonical_fixture_tile) != sha256_file(source_tile):
        raise ValueError("canonical fixture tile differs from candidate bytes")
    if not historical_tile.is_file():
        raise ValueError("same-name historical tile is absent; alias is unnecessary")
    if sha256_file(historical_tile) == sha256_file(source_tile):
        raise ValueError("same-name historical tile is already byte-identical")
    existing_alias_destination_identical = False
    if repository_alias_tile.exists():
        if sha256_file(repository_alias_tile) != sha256_file(source_tile):
            raise ValueError("repository alias destination has different tile bytes")
        existing_alias_destination_identical = True
    fixture_alias_uses_promoted_destination = False
    if alias_fixture_tile.exists() or alias_fixture_tile.is_symlink():
        if (
            not existing_alias_destination_identical
            or not alias_fixture_tile.is_symlink()
            or sha256_file(alias_fixture_tile) != sha256_file(source_tile)
        ):
            raise ValueError("fixture alias destination already exists with unexpected content")
        fixture_alias_uses_promoted_destination = True

    index_path = quest / "Content/Tile/index.idx"
    fixture_nodes = builder.read_tile_index(index_path)
    repository_nodes = builder.read_tile_index(root / "Content/Tile/index.idx")
    candidate_node, candidate_end = builder.tile_node(source_tile.read_bytes())
    historical_node, historical_end = builder.tile_node(historical_tile.read_bytes())
    for path, payload, end in (
        (source_tile, source_tile.read_bytes(), candidate_end),
        (historical_tile, historical_tile.read_bytes(), historical_end),
    ):
        if payload[end + 8:end + 16] != b"\x89PNG\r\n\x1a\n":
            raise ValueError(f"{path}: missing PNG payload after tile index node")
    if fixture_nodes.get(canonical_sheet) != candidate_node:
        raise ValueError("fixture index does not contain the authenticated candidate node")
    if repository_nodes.get(canonical_sheet) != historical_node:
        raise ValueError("repository index does not authenticate the historical same-name tile")
    if alias in fixture_nodes or alias in repository_nodes:
        raise ValueError("sheet alias is not unique in the PMDO tile index")

    # Prepare all validated payloads before changing the fixture.
    fixture_nodes[canonical_sheet] = historical_node
    fixture_nodes[alias] = candidate_node
    temporary_index = index_path.with_name(index_path.name + ".alias.tmp")
    builder.write_tile_index(temporary_index, fixture_nodes)
    if builder.read_tile_index(temporary_index) != fixture_nodes:
        temporary_index.unlink(missing_ok=True)
        raise ValueError("aliased tile index failed exact write/read verification")

    replace_file_atomically(fixture_ground, json_bom_bytes(fixture_ground_payload))
    replace_file_atomically(fixture_sink, json_bom_bytes(sink_payload))
    canonical_fixture_tile.unlink()
    canonical_fixture_tile.symlink_to(historical_tile)
    if not fixture_alias_uses_promoted_destination:
        alias_fixture_tile.symlink_to(source_tile)
    os.replace(temporary_index, index_path)

    if sha256_file(canonical_fixture_tile) != sha256_file(historical_tile):
        raise ValueError("historical fixture tile restoration failed")
    if sha256_file(alias_fixture_tile) != sha256_file(source_tile):
        raise ValueError("candidate alias tile bytes changed")
    reloaded_nodes = builder.read_tile_index(index_path)
    if reloaded_nodes.get(canonical_sheet) != historical_node:
        raise ValueError("historical tile index node was not restored")
    if reloaded_nodes.get(alias) != candidate_node:
        raise ValueError("candidate alias tile index node was not installed")

    alias_record = {
        "method": "exact serialized Sheet-value alias with byte-identical candidate tile",
        "canonical_sheet": canonical_sheet,
        "runtime_sheet": alias,
        "rewrite_count": canonical_rewrite_count,
        "fixture_rewrite_count": fixture_rewrite_count,
        "sink_rewrite_count": sink_rewrite_count,
        "canonical_ground_sha256": sha256_file(source_ground),
        "aliased_ground_sha256": aliased_ground_sha256,
        "canonical_tile_sha256": sha256_file(source_tile),
        "runtime_tile_sha256": sha256_file(alias_fixture_tile),
        "tile_bytes_unchanged": sha256_file(alias_fixture_tile) == sha256_file(source_tile),
        "exactly_reversible": True,
        "historical_ground_modified": False,
        "historical_tile_modified": False,
        "historical_tile_sha256": sha256_file(historical_tile),
        "historical_tile_restored_in_fixture": True,
        "historical_index_node_restored_in_fixture": True,
        "candidate_index_node_added_only_under_alias": True,
        "existing_destination_identical": existing_alias_destination_identical,
        "fixture_alias_uses_promoted_destination": fixture_alias_uses_promoted_destination,
    }
    manifest["sheet_aliases"] = {asset: alias}
    manifest["replaced_fixture_local_tile_index_nodes"] = []
    manifest["sheet_alias_postprocessor"] = relative_or_absolute(Path(__file__), root)
    entry["runtime_tile"] = relative_or_absolute(alias_fixture_tile, root)
    entry["runtime_tile_sha256"] = sha256_file(alias_fixture_tile)
    entry["sheet_alias"] = alias_record
    manifest_path.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    return alias_record


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fixture", type=Path, required=True)
    parser.add_argument("--candidate-root", type=Path, required=True)
    parser.add_argument("--id", required=True)
    parser.add_argument("--alias", required=True)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]

    def rooted(path: Path) -> Path:
        return path if path.is_absolute() else root / path

    record = apply_alias(
        root,
        rooted(args.fixture),
        rooted(args.candidate_root),
        args.id.lower(),
        args.alias,
    )
    print(
        "PMDRED_EU_SHEET_ALIAS_PASS "
        f"ground={args.id.lower()} alias={args.alias} refs={record['rewrite_count']} "
        f"tile_sha256={record['runtime_tile_sha256']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
