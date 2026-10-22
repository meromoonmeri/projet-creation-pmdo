#!/usr/bin/env python3
"""Compile all 27 dungeon-backed PMD Red scene graphs into immutable IR.

The IR preserves every ordered source action, including unknown raw opcodes. It
contains no copyrighted dialogue body and registers no production route.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import re
from collections import Counter
from pathlib import Path
from typing import Any


# Only primitives with an implementation-level equivalence certified by
# PMD_RED_OPCODE_REGISTRY.json and implemented fail-closed in
# CanonicalPrimitiveAdapters.lua may appear here.
PROVEN_ADAPTER_KINDS = {"WAIT", "BGM_FADEOUT", "SET_DIR_WAIT", "ROTATE_TO", "CMD_UNK_92"}


def read(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def digest(value: Any) -> str:
    return hashlib.sha256(json.dumps(value, ensure_ascii=False, separators=(",", ":"), sort_keys=True).encode()).hexdigest()


def channel(name: str) -> dict[str, Any]:
    match = re.search(r"_(lives|objects|events)(\d+)_", name)
    return {"kind": match.group(1), "index": int(match.group(2))} if match else {"kind": "station", "index": None}


def text_hashes(signature: str) -> list[str]:
    return re.findall(r"<TEXT_SHA256:([0-9a-f]+)>", signature)


def proved_operands(kind: str, signature: str) -> dict[str, Any]:
    if kind in {"WAIT", "BGM_FADEOUT"}:
        match = re.fullmatch(rf"{kind}\((\d+)\)", signature)
        if match is None:
            raise ValueError(f"invalid proved {kind} signature: {signature}")
        return {"frames": int(match.group(1))}
    if kind == "SET_DIR_WAIT":
        match = re.fullmatch(r"SET_DIR_WAIT\((DIRECTION_[A-Z]+|-1),\s*(\d+)\)", signature)
        if match is None:
            raise ValueError(f"invalid proved SET_DIR_WAIT signature: {signature}")
        direction: str | int = -1 if match.group(1) == "-1" else match.group(1)
        return {"direction": direction, "frames": int(match.group(2))}
    if kind == "ROTATE_TO":
        match = re.fullmatch(
            r"ROTATE_TO\((\d+),\s*(DIR_TRANS_(?:SPINRIGHT1|SPINLEFT1|10|11)),\s*(DIRECTION_[A-Z]+)\)",
            signature,
        )
        if match is None:
            raise ValueError(f"invalid proved ROTATE_TO signature: {signature}")
        return {"step_frames": int(match.group(1)), "transition": match.group(2), "direction": match.group(3)}
    if kind == "CMD_UNK_92":
        match = re.fullmatch(
            r"CMD_UNK_92\((\d+),\s*([12]),\s*(DIR_TRANS_(?:SPINRIGHT2|SPINLEFT2|FLIP))\)",
            signature,
        )
        if match is None:
            raise ValueError(f"invalid proved CMD_UNK_92 signature: {signature}")
        return {"step_frames": int(match.group(1)), "turn_step": int(match.group(2)), "target_transform": match.group(3)}
    raise ValueError(f"no proved operand compiler for {kind}")


def build(action_index: dict[str, Any], scope: dict[str, Any], dungeon_manifest: dict[str, Any]) -> dict[str, Any]:
    scope_rows = {row["asset"]: row for row in scope["scenes"] if row.get("dungeon_backed_relationship")}
    relationships = {row["stable_ground_id"]: row for row in dungeon_manifest["relationships"]}
    source_rows = {row["asset"]: row for row in action_index["assets"]}
    if len(scope_rows) != 27 or len(relationships) != 27:
        raise ValueError("dungeon-backed authority must contain exactly 27 relationships")
    assets = []
    global_kinds = Counter()
    total_actions = total_arrays = 0
    for asset in sorted(scope_rows):
        if asset not in source_rows or asset not in relationships:
            raise ValueError(f"missing source authority for {asset}")
        source = source_rows[asset]
        scene = scope_rows[asset]
        relation = relationships[asset]
        arrays = []
        asset_kinds = Counter()
        unknown = Counter()
        text_refs = []
        for array_index, script in enumerate(source["script_arrays"]):
            actions = []
            for action_index_value, action in enumerate(script["actions"]):
                kind = action["kind"]
                signature = action["signature"]
                hashes = text_hashes(signature)
                text_refs.extend(hashes)
                asset_kinds[kind] += 1
                global_kinds[kind] += 1
                if kind.startswith(("RAW_OPCODE_", "CMD_UNK_", "CJUMP_UNK_")):
                    unknown[kind] += 1
                if kind in PROVEN_ADAPTER_KINDS:
                    adapter_status = "ADAPTER_PROVEN"
                elif kind.startswith(("RAW_OPCODE_", "CMD_UNK_", "CJUMP_UNK_")):
                    adapter_status = "UNMAPPED_PRESERVED"
                else:
                    adapter_status = "MAPPING_REQUIRED"
                compiled_action = {
                    "sequence": action_index_value,
                    "kind": kind,
                    "signature": signature,
                    "text_hashes": hashes,
                    "adapter_status": adapter_status,
                }
                if adapter_status == "ADAPTER_PROVEN":
                    compiled_action["operands"] = proved_operands(kind, signature)
                actions.append(compiled_action)
            arrays.append({
                "sequence": array_index,
                "name": script["name"],
                "source_comment": script.get("source_comment"),
                "channel": channel(script["name"]),
                "actions": actions,
                "action_count": len(actions),
                "actions_sha256": digest(actions),
            })
        total_arrays += len(arrays)
        count = sum(row["action_count"] for row in arrays)
        total_actions += count
        assets.append({
            "asset": asset,
            "dungeon": {
                "id": relation["dungeon"]["id"],
                "name_fr": relation["dungeon"]["french_name_primary"],
                "playable_floor_count": relation["dungeon"]["playable_floor_count"],
                "ground_role": relation["role"]["classification"],
            },
            "authority": {
                "station_header": source["source_station_header"],
                "eu_graph_status": scene["eu_authority"]["status"],
                "regional_ground_id": scene["eu_authority"].get("regional_ground_id"),
                "french_text_block_count": scene["eu_authority"].get("french_text_block_count", 0),
                "french_text_aggregate_sha256": scene["eu_authority"].get("french_text_aggregate_sha256"),
                "provenance": "PMD_RED_EU_CANON",
            },
            "initial_entity_positions": scene["source"]["initial_entity_positions"],
            "script_array_count": len(arrays),
            "action_count": count,
            "action_kind_counts": dict(sorted(asset_kinds.items())),
            "unknown_opcode_counts": dict(sorted(unknown.items())),
            "text_reference_hashes": sorted(set(text_refs)),
            "script_arrays": arrays,
            "ir_sha256": digest(arrays),
            "runtime_ready": False,
            "production_route_written": False,
        })
    adapter_counts = Counter(
        action["adapter_status"]
        for asset in assets
        for array in asset["script_arrays"]
        for action in array["actions"]
    )
    result = {
        "schema": "new-era.pmdred-eu-dungeon-scene-ir.v2",
        "result": "PMD_RED_DUNGEON_SCENE_IR_PASS",
        "meaning": "all source actions preserved; only separately proved primitives are adapted; text binding and runtime validation remain required",
        "pret_commit": action_index["pret_commit"],
        "asset_count": len(assets),
        "script_array_count": total_arrays,
        "action_count": total_actions,
        "action_kind_counts": dict(sorted(global_kinds.items())),
        "unknown_action_count": sum(
            count for asset in assets for count in asset["unknown_opcode_counts"].values()
        ),
        "adapter_status_action_counts": dict(sorted(adapter_counts.items())),
        "adapter_proven_action_count": adapter_counts["ADAPTER_PROVEN"],
        "runtime_ready_asset_count": 0,
        "production_route_count": 0,
        "assets": assets,
    }
    result["ir_sha256"] = digest(assets)
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    repo = Path(__file__).resolve().parents[1]
    parser.add_argument("--source-actions", type=Path, default=repo / "docs/pmdred_eu/narrative_audit/source_action_index.json")
    parser.add_argument("--narrative-scope", type=Path, default=repo / "docs/pmdred_eu/narrative_audit/narrative_scope.json")
    parser.add_argument("--dungeon-manifest", type=Path, default=repo / "docs/pmdred_eu/dungeon_grounds/manifest.json")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    for path in (args.source_actions, args.narrative_scope, args.dungeon_manifest):
        if not path.is_file():
            raise FileNotFoundError(path)
    result = build(read(args.source_actions), read(args.narrative_scope), read(args.dungeon_manifest))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: result[key] for key in ("result", "asset_count", "script_array_count", "action_count", "unknown_action_count", "adapter_proven_action_count", "runtime_ready_asset_count")}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
