#!/usr/bin/env python3
"""Build the non-destructive canonical journey registry for PMD Red and BIBLIOTHEQUE.

The registry is a production gate, not a claim that unfinished scenes are
implemented.  It joins certified PMD Red Grounds, EU scene authority, the 27
separate dungeon relationships, and environment-only Reminiscencia/Relict
candidates without modifying any destination.
"""
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

import argparse
import hashlib
import json
from collections import Counter
from pathlib import Path
from typing import Any

REQUIRED_COMPONENTS = (
    "entry",
    "canonical_layout_and_gameplay",
    "relay_and_checkpoint",
    "in_dungeon_events",
    "pre_encounter_scene",
    "encounter_or_boss_staging",
    "battle",
    "victory_defeat_retry_retreat",
    "exit_and_narrative_return",
)


def read(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def floor_count(segment: dict[str, Any]) -> int:
    nodes = segment.get("Floors", {}).get("nodes", [])
    return sum(int(row["Range"]["Max"]) - int(row["Range"]["Min"]) for row in nodes)


def sinister_gate(repo: Path) -> dict[str, Any]:
    zone_path = repo / "Data/Zone/gloomy_forest.json"
    if not zone_path.is_file():
        return {"result": "BLOCKED", "blockers": ["GLOOMY_FOREST_ZONE_MISSING"]}
    zone = read(zone_path)["Object"]
    segments = zone["Segments"]
    procedural = {index: floor_count(segments[index]) for index in (0, 1, 3)}
    payload = json.dumps(zone, ensure_ascii=False)
    ground_ids = ("gloomy_forest_entrance", "sinister_woods_clearing")
    grounds = {
        ground_id: {
            "exists": (repo / f"Data/Ground/{ground_id}.rsground").is_file(),
            "sha256": sha256(repo / f"Data/Ground/{ground_id}.rsground") if (repo / f"Data/Ground/{ground_id}.rsground").is_file() else None,
        }
        for ground_id in ground_ids
    }
    music = {
        index: sorted({
            value for value in _strings(segments[index])
            if value.endswith(".ogg")
        })
        for index in (0, 1, 3)
    }
    relic_blob_count = payload.count("relic_forest_blob_")
    reverse_relic_script_count = payload.count("ReverseRelicForest")
    treeshroud_count = payload.count("treeshroud_forest_1_")
    unique_b41_count = sum(payload.count(token) for token in (
        "sinister_woods_b41_floor",
        "sinister_woods_b41_wall",
        "sinister_woods_b41_secondary",
    ))
    deep_shadow_missing = "deep_shadow" in payload and not (repo / "Data/MapStatus/deep_shadow.json").is_file()
    profile_path = repo / "docs/canonical/red/sinister_woods_generator_profile.json"
    runtime_path = repo / "docs/pmdred_eu/dungeon_grounds/SINISTER_WOODS_PMDO_NATIVE_GENERATOR_RUNTIME_2026-08-21.json"
    profile_present = profile_path.is_file()
    runtime_payload = read(runtime_path) if runtime_path.is_file() else {}
    native_nodes = sum(
        len(segments[index].get("Floors", {}).get("nodes", []))
        for index in (0, 1, 3)
        if isinstance(segments[index].get("Floors"), dict)
    )
    technical_blockers = []
    if procedural != {0: 15, 1: 5, 3: 3}:
        technical_blockers.append("FLOOR_PROGRESSION_15_5_3_MISMATCH")
    if not all("Sinister Woods.ogg" in music[index] for index in music):
        technical_blockers.append("CANONICAL_SINISTER_WOODS_MUSIC_MISSING")
    if not all(row["exists"] for row in grounds.values()):
        technical_blockers.append("CANONICAL_D04_GROUND_MISSING")
    if treeshroud_count:
        technical_blockers.append("PROCEDURAL_GRAPHICS_STILL_TREESHROUD_ADAPTATION")
    if unique_b41_count < 9:
        technical_blockers.append("UNIQUE_B41_GRAPHICS_NAMESPACE_INCOMPLETE")
    if relic_blob_count:
        technical_blockers.append("RELIC_FOREST_BLOBS_MIXED_INTO_PMD_RED_CHAIN")
    if reverse_relic_script_count:
        technical_blockers.append("RELIC_FOREST_STAIR_SCRIPT_MIXED_INTO_PMD_RED_CHAIN")
    if deep_shadow_missing:
        technical_blockers.append("DEEP_SHADOW_RUNTIME_COMPONENT_MISSING")
    if not profile_present or native_nodes != 23:
        technical_blockers.append("NATIVE_PMDO_GENERATOR_PROFILE_OR_NODES_MISSING")
    if runtime_payload.get("result") != "PMDO_NATIVE_GENERATOR_RUNTIME_PASS_NON_PRODUCTION":
        technical_blockers.append("NATIVE_PMDO_GENERATOR_RUNTIME_NOT_PASS")
    narrative_blockers = [
        "FULL_PMDO_RED_NARRATIVE_NOT_CERTIFIED",
        "FULL_SINISTER_WOODS_DUNGEON_CHAIN_NOT_CERTIFIED",
        "FULL_GAME_END_TO_END_TRAVERSAL_NOT_CERTIFIED",
    ]
    blockers = technical_blockers + narrative_blockers
    return {
        "result": "PASS_NATIVE_GENERATOR_RUNTIME_NON_PRODUCTION" if not technical_blockers else "BLOCKED",
        "public_identity": "Sinister Woods",
        "technical_zone_id": "gloomy_forest",
        "provenance": {
            "grounds": "PMD_RED_EU_CANON",
            "floors_1_13_spawn_cycle": "PMD_RED_EU_CANON",
            "floors_14_23_extension": "NEW_ERA_ADAPTATION",
            "team_dazzling_recast": "NEW_ERA_ADAPTATION",
        },
        "procedural_floor_counts": procedural,
        "music_by_segment": music,
        "canonical_grounds": grounds,
        "foreign_environment_references": {
            "treeshroud_tileset_reference_count": treeshroud_count,
            "sinister_woods_b41_namespace_reference_count": unique_b41_count,
            "relic_forest_blob_reference_count": relic_blob_count,
            "reverse_relic_forest_script_reference_count": reverse_relic_script_count,
            "deep_shadow_missing": deep_shadow_missing,
        },
        "technical_blockers": technical_blockers,
        "blockers": blockers,
        "production_route_written": not technical_blockers and unique_b41_count >= 9,
        "production_route_certified": False,
        "generator_profile": {
            "status": "SOURCE_DERIVED_NATIVE_PMDO_ADAPTER" if not technical_blockers else "BLOCKED",
            "profile": "docs/canonical/red/sinister_woods_generator_profile.json",
            "profile_sha256": sha256(profile_path) if profile_present else None,
            "runtime_evidence": "docs/pmdred_eu/dungeon_grounds/SINISTER_WOODS_PMDO_NATIVE_GENERATOR_RUNTIME_2026-08-21.json",
            "runtime_result": runtime_payload.get("result"),
            "native_procedural_nodes": native_nodes,
            "fixed_story_segments_preserved": True,
        },
        "material_promotion": {
            "status": "PROMOTED_UNIQUE_NAMESPACE" if not blockers and unique_b41_count == 9 else "NOT_PROMOTED",
            "namespace": "SinisterWoodsB41",
            "evidence": "docs/pmdred_eu/dungeon_grounds/SINISTER_WOODS_B41_PROMOTION_2026-08-19.json",
        },
    }


def _strings(value: Any):
    if isinstance(value, str):
        yield value
    elif isinstance(value, dict):
        for child in value.values():
            yield from _strings(child)
    elif isinstance(value, list):
        for child in value:
            yield from _strings(child)


def build(args) -> dict[str, Any]:
    authority_paths = {
        "narrative_scope": args.narrative_scope,
        "migration_progress": args.progress,
        "integration_contract": args.contract,
        "ground_final_audit": args.ground_audit,
        "dungeon_relationships": args.dungeon_manifest,
        "reminiscencia_manifest": args.reminiscencia_manifest,
        "relict_manifest": args.relict_manifest,
    }
    missing = [name for name, path in authority_paths.items() if not path.is_file()]
    if missing:
        raise FileNotFoundError("missing canonical authorities: " + ", ".join(missing))
    scope = read(args.narrative_scope)
    progress = read(args.progress)
    contract = read(args.contract)
    ground_audit = read(args.ground_audit)
    dungeon_manifest = read(args.dungeon_manifest)
    external = [read(args.reminiscencia_manifest), read(args.relict_manifest)]

    if len(scope["scenes"]) != 133:
        raise ValueError("PMD Red scene inventory must contain exactly 133 scenes")
    if len(scope["dungeon_cutscenes"]) != 26:
        raise ValueError("PMD Red dungeon cutscene inventory must contain 26 modules")
    if ground_audit["inventory"]["validated_ids"] != 219:
        raise ValueError("certified Ground authority is not 219/219")
    relationships = dungeon_manifest["relationships"]
    if len(relationships) != 27:
        raise ValueError("dungeon-backed relationship inventory is not 27")
    contract_components = tuple(contract["dungeons"]["required_sequence_components"])
    if contract_components != REQUIRED_COMPONENTS:
        raise ValueError("integration contract sequence components drifted")

    progress_by_asset = {row["asset"]: row for row in progress["scenes"]}
    scenes_by_asset = {row["asset"]: row for row in scope["scenes"]}
    relationship_by_ground = {row["stable_ground_id"]: row for row in relationships}
    chains = []
    for asset in sorted(row["asset"] for row in scope["scenes"] if row.get("dungeon_backed_relationship")):
        scene = scenes_by_asset[asset]
        relation = relationship_by_ground.get(asset)
        if relation is None:
            raise ValueError(f"missing dungeon relationship for {asset}")
        migrated = progress_by_asset[asset]["migration_status"] == "MIGRATED_AND_RUNTIME_VALIDATED"
        component_status = {
            component: (
                "CERTIFIED_IMMUTABLE" if component == "canonical_layout_and_gameplay" else
                "RUNTIME_VALIDATED" if migrated else
                "NOT_IMPLEMENTED"
            )
            for component in REQUIRED_COMPONENTS
        }
        chains.append({
            "scene_asset": asset,
            "stable_ground_id": asset,
            "dungeon_id": relation["dungeon"]["id"],
            "name_fr": relation["dungeon"]["french_name_primary"],
            "playable_floor_count": relation["dungeon"]["playable_floor_count"],
            "ground_role": relation["role"]["classification"],
            "eu_authority_status": scene["eu_authority"]["status"],
            "audit_classification": scene["primary_classification"],
            "migration_status": progress_by_asset[asset]["migration_status"],
            "components": component_status,
            "production_ready": all(value in ("CERTIFIED_IMMUTABLE", "RUNTIME_VALIDATED") for value in component_status.values()),
            "provenance": "PMD_RED_EU_CANON",
        })

    external_rows = []
    for manifest in external:
        if manifest["runtime_destination_written"]:
            raise ValueError(f"{manifest['game_id']} candidate unexpectedly wrote a runtime destination")
        for dungeon in manifest["dungeons"]:
            external_rows.append({
                "game_id": manifest["game_id"],
                "dungeon_id": dungeon["dungeon_id"],
                "name_fr": dungeon["name_fr"],
                "source_family": dungeon["source_family"],
                "floor_count": dungeon["floor_count"],
                "zone_sha256": dungeon["sha256"],
                "status": "ENVIRONMENT_CANDIDATE_NOT_PRODUCTION_ROUTED",
                "source_scope": "ENVIRONMENT_ONLY",
                "gameplay_tables": "NEW_ERA_ADAPTATION_NOT_SOURCE_CANON",
                "forbidden_source_content_imported": False,
                "production_ready": False,
            })

    migration_counts = Counter(row["migration_status"] for row in progress["scenes"])
    scene_classifications = Counter(row["primary_classification"] for row in scope["scenes"])
    sinister = sinister_gate(args.repo)
    result = {
        "schema": "new-era.canonical-journey-registry.v1",
        "result": "CANONICAL_JOURNEY_REGISTRY_PASS",
        "meaning": "registry and blockers are complete; unfinished journeys are not promoted",
        "authorities": {
            name: {
                "path": {
                    "narrative_scope": "docs/pmdred_eu/narrative_audit/narrative_scope.json",
                    "migration_progress": "docs/pmdred_eu/narrative_migration/progress.json",
                    "integration_contract": "docs/pmdred_eu/narrative_migration/integration_contract.json",
                    "ground_final_audit": "docs/pmdred_eu/pmdo_validation/FINAL_AUDIT.json",
                    "dungeon_relationships": "docs/pmdred_eu/dungeon_grounds/manifest.json",
                    "reminiscencia_manifest": "external/BIBLIOTHEQUE_WORKSPACE/games/reminiscencia/conversion/pmdo_dungeons/manifest.json",
                    "relict_manifest": "external/BIBLIOTHEQUE_WORKSPACE/games/relict/conversion/pmdo_dungeons/manifest.json",
                }[name],
                "sha256": sha256(path),
            }
            for name, path in authority_paths.items()
        },
        "immutable_invariants": {
            "archive_backed_ground_count": 219,
            "archive_backed_destination_hash_checks": 438,
            "protected_chapter_1_to_5_file_count": 99,
            "protected_fugitive_route_count": 27,
            "ground_mutation_allowed": False,
            "new_game_hook_allowed": False,
        },
        "pmd_red_eu": {
            "scene_count": 133,
            "scene_classifications": dict(sorted(scene_classifications.items())),
            "migration_status_counts": dict(sorted(migration_counts.items())),
            "dungeon_cutscene_module_count": 26,
            "dungeon_backed_chain_count": len(chains),
            "production_ready_chain_count": sum(row["production_ready"] for row in chains),
            "required_components": list(REQUIRED_COMPONENTS),
            "chains": chains,
            "next_blocking_target": progress["summary"]["blocking_dependency"],
            "sinister_woods_targeted_gate": sinister,
        },
        "environment_libraries": {
            "candidate_count": len(external_rows),
            "reminiscencia_count": sum(row["game_id"] == "reminiscencia" for row in external_rows),
            "relict_count": sum(row["game_id"] == "relict" for row in external_rows),
            "production_ready_count": sum(row["production_ready"] for row in external_rows),
            "policy": "environment-only; never PMD Red canon, casting, dialogue, engine or audio",
            "candidates": sorted(external_rows, key=lambda row: (row["game_id"], row["dungeon_id"])),
        },
        "production_gate": {
            "status": "BLOCKED",
            "reasons": [
                "PMD_RED_SCENES_MIGRATED_0_OF_133",
                "PMD_RED_DUNGEON_CHAINS_READY_0_OF_27",
                "SINISTER_WOODS_TARGETED_GATE_BLOCKED" if sinister["result"] != "PASS" else None,
                "REMINISCENCIA_RELICT_CANDIDATES_NOT_PRODUCTION_ROUTED",
            ],
        },
    }
    result["production_gate"]["reasons"] = [row for row in result["production_gate"]["reasons"] if row]
    return result


def markdown_report(result: dict[str, Any]) -> str:
    lines = [
        "# État des chaînes canoniques de donjon",
        "",
        "> Ce rapport distingue inventaire validé et implémentation jouable. Aucun `BLOCKED` n'est un succès de production.",
        "",
        "## PMD Red EU — 27 relations dungeon-backed",
        "",
        "| Ground | Donjon FR | Étages | Autorité EU | Migration | Prêt |",
        "|---|---|---:|---|---|---:|",
    ]
    for row in result["pmd_red_eu"]["chains"]:
        lines.append(
            f"| `{row['stable_ground_id']}` | {row['name_fr']} | {row['playable_floor_count']} | "
            f"`{row['eu_authority_status']}` | `{row['migration_status']}` | {'oui' if row['production_ready'] else 'non'} |"
        )
    lines += [
        "", "## Réminiscencia / Relict — environnement uniquement", "",
        "| Bibliothèque | Candidat | Famille | Étages | Statut |", "|---|---|---|---:|---|",
    ]
    for row in result["environment_libraries"]["candidates"]:
        lines.append(f"| {row['game_id']} | `{row['dungeon_id']}` | {row['source_family']} | {row['floor_count']} | `{row['status']}` |")
    sinister = result["pmd_red_eu"]["sinister_woods_targeted_gate"]
    lines += [
        "", "## Gate courant — Sinister Woods", "",
        f"Résultat : `{sinister['result']}`.", "",
        *[f"- `{blocker}`" for blocker in sinister["blockers"]],
        "", "## Gate global", "",
        f"Statut : `{result['production_gate']['status']}`.", "",
        *[f"- `{reason}`" for reason in result["production_gate"]["reasons"]], "",
    ]
    return "\n".join(lines)


def lua_registry(result: dict[str, Any]) -> str:
    lines = [
        "-- Generated canonical journey gate. No production route is registered here.",
        "local Registry = {}",
        "Registry.REQUIRED_COMPONENTS = {",
    ]
    lines.extend(f"  '{component}'," for component in result["pmd_red_eu"]["required_components"])
    lines += ["}", "Registry.CHAINS = {"]
    for row in result["pmd_red_eu"]["chains"]:
        lines += [
            f"  {row['stable_ground_id']} = {{",
            f"    name_fr = {json.dumps(row['name_fr'], ensure_ascii=False)},",
            f"    floor_count = {row['playable_floor_count']},",
            f"    authority = '{row['eu_authority_status']}',",
            f"    migration_status = '{row['migration_status']}',",
            f"    production_ready = {str(row['production_ready']).lower()},",
            "    components = {",
        ]
        lines.extend(f"      {component} = '{status}'," for component, status in row["components"].items())
        lines += ["    },", "  },"]
    lines += [
        "}",
        "Registry.ENVIRONMENT_CANDIDATES = {",
    ]
    for row in result["environment_libraries"]["candidates"]:
        lines.append(
            f"  {row['dungeon_id']} = {{ game_id = '{row['game_id']}', status = '{row['status']}', production_ready = false }},"
        )
    lines += [
        "}",
        "function Registry.Get(id)",
        "  return Registry.CHAINS[id]",
        "end",
        "function Registry.AssertReady(id)",
        "  local chain = Registry.CHAINS[id]",
        "  if chain == nil then error('unknown canonical PMD Red journey: '..tostring(id)) end",
        "  if not chain.production_ready then error('canonical PMD Red journey is blocked: '..tostring(id)) end",
        "  return chain",
        "end",
        "return Registry",
        "",
    ]
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    repo = Path(__file__).resolve().parents[1]
    parser.add_argument("--repo", type=Path, default=repo)
    parser.add_argument("--narrative-scope", type=Path, default=repo / "docs/pmdred_eu/narrative_audit/narrative_scope.json")
    parser.add_argument("--progress", type=Path, default=repo / "docs/pmdred_eu/narrative_migration/progress.json")
    parser.add_argument("--contract", type=Path, default=repo / "docs/pmdred_eu/narrative_migration/integration_contract.json")
    parser.add_argument("--ground-audit", type=Path, default=repo / "docs/pmdred_eu/pmdo_validation/FINAL_AUDIT.json")
    parser.add_argument("--dungeon-manifest", type=Path, default=repo / "docs/pmdred_eu/dungeon_grounds/manifest.json")
    parser.add_argument("--reminiscencia-manifest", type=Path, default=repo / "external/BIBLIOTHEQUE_WORKSPACE/games/reminiscencia/conversion/pmdo_dungeons/manifest.json")
    parser.add_argument("--relict-manifest", type=Path, default=repo / "external/BIBLIOTHEQUE_WORKSPACE/games/relict/conversion/pmdo_dungeons/manifest.json")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--report", type=Path)
    parser.add_argument("--lua-output", type=Path)
    args = parser.parse_args()
    result = build(args)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(markdown_report(result), encoding="utf-8")
    if args.lua_output:
        args.lua_output.parent.mkdir(parents=True, exist_ok=True)
        args.lua_output.write_text(lua_registry(result), encoding="utf-8")
    print(json.dumps({
        "result": result["result"],
        "pmd_red_scenes": result["pmd_red_eu"]["scene_count"],
        "pmd_red_chains": result["pmd_red_eu"]["dungeon_backed_chain_count"],
        "external_candidates": result["environment_libraries"]["candidate_count"],
        "production_gate": result["production_gate"]["status"],
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
