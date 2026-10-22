#!/usr/bin/env python3
"""Inventory PMD Red staging and compare it with New Era without editing game data.

The tool treats a scene as dialogue + actors + spatial choreography + animation
+ direction + camera + VFX + audio + timing + transitions + event logic.  It
uses pinned pret station declarations for complete static action ordering and a
separately generated EU-ROM script report for regional French/text authority.
Outputs are audit documents only; Data/, Content/, and zone files are read-only.
"""

from __future__ import annotations

import argparse
import collections
import csv
import hashlib
import json
import re
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Any

ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"

SOURCE_DOMAIN_PREFIXES = {
    "dialogue": ("MSG_", "ASK", "CHOICE", "SPECIAL_TEXT"),
    "portrait_expression": ("PORTRAIT",),
    "movement_path": ("WALK_", "WARP_"),
    "animation_pose": ("SELECT_ANIMATION", "STOP_ANIMATION", "CMD_UNK_8D", "CMD_UNK_93"),
    "orientation": ("ROTATE_", "SET_DIR"),
    "camera": ("CAMERA_",),
    "vfx_transition": ("FLASH_", "BGCOLOR", "FADE", "SCREEN_"),
    "audio": ("BGM_", "FANFARE_", "WAIT_FANFARE"),
    "timing_sync": ("WAIT", "AWAIT_CUE", "ALERT_CUE"),
    "map_route": ("SELECT_MAP", "NEXT_DUNGEON", "JUMP_STATION", "CALL_STATION", "EXECUTE_STATION", "EXECUTE_SUBSTATION"),
    "event_logic": ("COND", "JUMPIF", "CJUMP", "VARIANT", "SCENARIO", "UPDATE_VAR", "SET_ARRAY", "CALL_LABEL", "JUMP_LABEL"),
}

NEW_DOMAIN_NAMES = {
    "dialogue": ("WaitShowDialogue", "WaitShowTitle", "ChoiceMenu", "WaitShowVoiceOver"),
    "portrait_expression": ("SetSpeaker", "SetEmotion", "Emote", "SetSpeakerEmotion"),
    "movement_path": ("MoveTo", "Walk", "TeleportTo", "MoveInDirection", "MoveToPosition"),
    "animation_pose": ("CharSetAnim", "CharSetAction", "Animate", "SetAnim"),
    "orientation": ("Turn", "Direction", "CharSetDir"),
    "camera": ("Camera",),
    "vfx_transition": ("Fade", "Flash", "BossFX", "Effect", "Emitter", "Screen", "Shake"),
    "audio": ("PlayBGM", "FadeOutBGM", "PlaySE", "PlayBattleSE", "PlayFanfare"),
    "timing_sync": ("WaitFrames", "JoinCoroutines", "BranchCoroutine", "WaitTask", "Wait"),
    "map_route": ("EnterGroundMap", "EnterDungeon", "EnterZone", "BossTransition"),
    "event_logic": ("Save", "Set", "Get", "Unlock", "Complete"),
}

DIRECT_CUTSCENE_TARGETS = {
    "articuno": "d10p03", "celebi": None, "deoxys": "d22p01", "entei": "d16p01",
    "groudon": "d12p04", "hooh": "d19p01", "jirachi": "d23p01", "kyogre": "d14p01",
    "latios": "d21p01", "lugia": "d15p01", "mankey": None, "meanies": "d04p02",
    "medicham": None, "mewtwo": "d20p01", "moltres": "d09p03", "raikou": "d17p01",
    "rayquaza": "d13p03", "regis": None, "skarmory": "d03p02", "smeargle": None,
    "suicune": "d18p01", "zapdos": "d06p03", "magma_cavern": "d12p02",
    "empty_summit": None, "no_one_here": None,
}


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            h.update(block)
    return h.hexdigest()


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def strip_lua_comments(text: str) -> str:
    text = re.sub(r"--\[\[.*?\]\]", "", text, flags=re.S)
    return "\n".join(line for line in text.splitlines() if not line.lstrip().startswith("--"))


def macro_calls(text: str) -> collections.Counter[str]:
    return collections.Counter(re.findall(r"\b([A-Z][A-Z0-9_]+)\s*\(", text))


def source_domains(macros: collections.Counter[str], effect_count: int) -> dict[str, int]:
    result: dict[str, int] = {}
    for domain, prefixes in SOURCE_DOMAIN_PREFIXES.items():
        result[domain] = sum(count for name, count in macros.items() if name.startswith(prefixes))
    result["vfx_transition"] += effect_count
    result["actors"] = macros.get("SELECT_LIVES", 0) + macros.get("SELECT_ENTITIES", 0)
    return result


def new_calls(text: str) -> list[str]:
    code = strip_lua_comments(text)
    return [match.group(2) for match in re.finditer(
        r"\b(GAME|GROUND|SOUND|UI|TASK|COMMON|BossFX|CharacterEssentials|GeneralFunctions)\s*[:.]\s*([A-Za-z_][A-Za-z0-9_]*)\s*\(",
        code,
    )]


def new_domains(text: str) -> dict[str, int]:
    names = new_calls(text)
    result = {
        domain: sum(any(fragment.lower() in name.lower() for fragment in fragments) for name in names)
        for domain, fragments in NEW_DOMAIN_NAMES.items()
    }
    result["actors"] = sum(name in {"MakeCharactersFromList", "MakeCharacters", "GetCharacter", "CH"} for name in names)
    result["event_logic"] += len(re.findall(r"\bSV\.", strip_lua_comments(text)))
    return result


def redact_action(line: str) -> str:
    line = line.strip().rstrip(",")
    strings = re.findall(r'"(?:\\.|[^"\\])*"', line)
    for value in strings:
        digest = hashlib.sha256(value.encode()).hexdigest()[:16]
        line = line.replace(value, f'"<TEXT_SHA256:{digest}>"')
    return re.sub(r"\s+", " ", line)


def command_arrays(source: str) -> list[dict[str, Any]]:
    pattern = re.compile(r"static const struct ScriptCommand\s+(\w+)\[\]\s*=\s*\{\s*/\*([^*]*)\*/")
    arrays = []
    for match in pattern.finditer(source):
        end = source.find("\n};", match.end())
        if end < 0:
            continue
        body = source[match.end():end]
        actions = []
        for line in body.splitlines():
            stripped = line.strip()
            if not stripped or stripped.startswith("//") or stripped.startswith("DEBUGINFO_O"):
                continue
            macro = re.match(r"(?:LABEL\([^)]*\),\s*)?([A-Z][A-Z0-9_]+)\s*\(", stripped)
            raw = re.match(r"\{\s*(0x[0-9a-fA-F]+)", stripped)
            if macro or raw:
                actions.append({
                    "kind": macro.group(1) if macro else "RAW_OPCODE_" + raw.group(1).upper(),
                    "signature": redact_action(stripped),
                })
        comment = re.sub(r"\s+", " ", match.group(2)).strip()
        arrays.append({"name": match.group(1), "source_comment": comment, "actions": actions})
    return arrays


def parse_entity_positions(source: str) -> list[dict[str, Any]]:
    positions = []
    pattern = re.compile(r"static const struct GroundLivesData\s+(\w+)\[\]\s*=\s*\{(.*?)\n\};", re.S)
    row = re.compile(
        r"/\*\s*(\d+)\s*\*/\s*\{\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*\{\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*([^,}]+)\s*,\s*([^}]+)\}",
        re.S,
    )
    for block in pattern.finditer(source):
        for found in row.finditer(block.group(2)):
            positions.append({
                "array": block.group(1), "index": int(found.group(1)), "kind": int(found.group(2)),
                "unknown_1": int(found.group(3)), "width": int(found.group(4)), "height": int(found.group(5)),
                "x_tiles": int(found.group(6)), "y_tiles": int(found.group(7)),
                "x_flags": found.group(8).strip(), "y_flags": found.group(9).strip(),
            })
    return positions


def parse_links(source: str) -> list[dict[str, int]]:
    links = []
    for match in re.finditer(
        r"/\*\s*link\s+(\d+)\s*\*/\s*\{\s*\{\s*/\*x\*/\s*(-?\d+)\s*,\s*/\*y\*/\s*(-?\d+).*?/\*w\*/\s*(\d+)\s*,\s*/\*h\*/\s*(\d+)\s*,\s*/\*ret\*/\s*(\d+)",
        source,
    ):
        links.append({"index": int(match.group(1)), "x_tiles": int(match.group(2)), "y_tiles": int(match.group(3)), "width": int(match.group(4)), "height": int(match.group(5)), "return_id": int(match.group(6))})
    return links


def extract_central_scenes(text: str) -> dict[str, str]:
    starts = list(re.finditer(r"^\s{2}([a-z0-9_]+)\s*=\s*function\(\)\s*$", text, re.M))
    result = {}
    for index, match in enumerate(starts):
        end = starts[index + 1].start() if index + 1 < len(starts) else text.find("\n}", match.end())
        result[match.group(1)] = text[match.start():end if end >= 0 else len(text)]
    return result


def domain_status(source_count: int, current_count: int, extra_missing: bool = False) -> list[str]:
    if source_count == 0:
        return ["CONSERVÉ"] if current_count == 0 else ["ADAPTÉ"]
    if current_count == 0:
        return ["PORTÉ"]
    result = ["ADAPTÉ"]
    if extra_missing:
        result.append("PORTÉ")
    return result


def primary_scene_classification(
    *, routed: bool, has_new_era_module: bool, has_exact_eu_graph: bool
) -> tuple[str, str]:
    """Choose exactly one scene-level class; domain statuses remain indicators."""
    if routed:
        return (
            "CONFLIT",
            "route FugitiveArc New Era active à préserver; restitution EU parallèle requise",
        )
    if not has_new_era_module:
        return (
            "PORTÉ",
            "scène canonique EU absente des modules New Era",
        )
    if not has_exact_eu_graph:
        return (
            "DÉPENDANCE",
            "graphe régional EU non encore décodé exactement; adaptateur requis avant décision de portage",
        )
    return (
        "ADAPTÉ",
        "module présent des deux côtés mais équivalence scénique complète non démontrée",
    )


def normalized_asset_name(value: str) -> str:
    return re.sub(r"[^a-z0-9]", "", value.lower().removeprefix("mus_").removesuffix(".ogg"))


def build(root: Path, pret_root: Path, eu_report_path: Path, output: Path) -> dict[str, Any]:
    manifest = read_json(root / "docs/pmdred_eu/ground_manifest.json")
    progress = read_json(root / "docs/pmdred_eu/pmdo_validation/progress.json")
    direct_manifest = read_json(root / "docs/pmdred_eu/dungeon_grounds/manifest.json")
    eu_report = read_json(eu_report_path)
    conversion = {row["stable_ground_id"]: row for row in manifest["ground_conversion_table"]["entries"]}
    exact_eu = {row["asset"]: row for row in eu_report.get("candidates", [])}
    eu_gap_rows = eu_report.get("technical_gaps", eu_report.get("mismatches", []))
    eu_mismatches = {row["asset"]: row for row in eu_gap_rows}
    direct = {row["mapping"]["stable_ground_id"]: row for row in direct_manifest["relationships"]}
    validated = set(progress["validated_ids"])

    scene_root = root / "Data/Script/halcyon/arc_fugitif/scene"
    scene_files = {path.stem: path for path in scene_root.glob("*.lua")}
    central_path = root / "Data/Script/halcyon/FugitiveCinematics.lua"
    central_scenes = extract_central_scenes(central_path.read_text(encoding="utf-8"))
    arc_text = (root / "Data/Script/halcyon/FugitiveArc.lua").read_text(encoding="utf-8")
    sequence_rows = re.findall(r"\{\s*ground\s*=\s*'([^']+)'\s*,\s*scene\s*=\s*'([^']+)'\s*,\s*music\s*=\s*'([^']*)'", arc_text)
    routed_scenes = {scene for _ground, scene, _music in sequence_rows}
    route_by_scene = {scene: {"ground": ground, "music": music} for ground, scene, music in sequence_rows}
    init_routes: dict[str, list[str]] = collections.defaultdict(list)
    for path in (root / "Data/Script/halcyon/ground").glob("*/init.lua"):
        text = path.read_text(encoding="utf-8")
        for scene in re.findall(r"FugitiveArc\.Play\(['\"]([^'\"]+)", text):
            init_routes[scene].append(path.relative_to(root).as_posix())

    resx = ET.parse(root / "Data/Script/halcyon/arc_fugitif/strings.fr.resx").getroot()
    french_values = {node.get("name", ""): node.findtext("value") or "" for node in resx.findall("data")}

    station_dir = pret_root / "src/data/ground"
    station_paths = {}
    for path in station_dir.glob("ground_data_*_station.h"):
        asset = re.fullmatch(r"ground_data_(.+)_station\.h", path.name).group(1)
        if asset in conversion:
            station_paths[asset] = path
    if len(station_paths) != 133:
        raise ValueError(f"expected 133 EU station declarations, found {len(station_paths)}")
    missing_new_era_scene_files = sorted(set(station_paths) - set(scene_files))
    non_eu_new_era_scene_files = sorted(set(scene_files) - set(station_paths))

    scenes = []
    action_index = []
    all_source_macros = collections.Counter()
    all_current_domains = collections.Counter()
    raw_french_match_count = 0
    for asset in sorted(station_paths, key=lambda item: conversion[item]["map_id"]):
        source_path = station_paths[asset]
        source = source_path.read_text(encoding="utf-8")
        macros = macro_calls(source)
        all_source_macros.update(macros)
        effects = len(re.findall(r"static const struct GroundEffectData", source))
        source_domain = source_domains(macros, effects)
        arrays = command_arrays(source)
        positions = parse_entity_positions(source)
        links = parse_links(source)

        lua_path = scene_files.get(asset)
        lua = lua_path.read_text(encoding="utf-8") if lua_path else ""
        wrapper = bool(lua_path and "halcyon.FugitiveCinematics" in lua)
        implementation = central_scenes.get(asset, "") if wrapper else lua
        current_domain = new_domains(implementation)
        local_dialogue_calls = len(re.findall(r"\b(?:dial|hero_pense)\s*\(", strip_lua_comments(implementation)))
        current_domain["dialogue"] += local_dialogue_calls
        current_domain["portrait_expression"] += local_dialogue_calls
        current_domain["actors"] += len(re.findall(r"\bCH\s*\(", strip_lua_comments(implementation)))
        all_current_domains.update(current_domain)
        dialogue_keys = sorted(set(re.findall(r"SCENE_[A-Z0-9_]+", strip_lua_comments(implementation))))
        keys_nonempty = [key for key in dialogue_keys if french_values.get(key)]
        dialogue_call_lines = re.findall(
            r"(?:WaitShowDialogue|dial|hero_pense)\s*\([^\n]*", strip_lua_comments(implementation)
        )
        literal_dialogues = sum("STRINGS:FormatKey" not in line for line in dialogue_call_lines)
        commented_calls = len(re.findall(r"^\s*--\s*(?:GAME|GROUND|SOUND|UI|TASK|COMMON|BossFX|CharacterEssentials)\s*[:.]", lua, re.M))

        exact = exact_eu.get(asset)
        exact_french = []
        if exact:
            exact_french = [block["languages"]["fr"]["text"] for block in exact["text_blocks"]]
        current_nonempty_values = [french_values[key] for key in keys_nonempty]
        raw_matches = sum(value in exact_french for value in current_nonempty_values)
        raw_french_match_count += raw_matches
        french_hash = hashlib.sha256("\0".join(exact_french).encode("latin-1")).hexdigest() if exact_french else None

        domain_matrix = {}
        for domain in sorted(set(source_domain) | set(current_domain)):
            missing = domain == "dialogue" and bool(dialogue_keys) and len(keys_nonempty) < len(dialogue_keys)
            domain_indicators = domain_status(
                source_domain.get(domain, 0), current_domain.get(domain, 0), missing
            )
            domain_matrix[domain] = {
                "source_count": source_domain.get(domain, 0),
                "new_era_executed_count": current_domain.get(domain, 0),
                "primary_classification": domain_indicators[0],
                "secondary_indicators": domain_indicators[1:],
                "statuses": domain_indicators,
            }

        statuses = {status for row in domain_matrix.values() for status in row["statuses"]}
        statuses.add("DÉPENDANCE")  # immutable certified Ground and PMDO systems
        conflict_reasons = []
        if asset in routed_scenes or init_routes.get(asset):
            statuses.add("CONFLIT")
            conflict_reasons.append("active FugitiveArc route; preserve current New Era scene and flags")
        if asset.startswith("h"):
            statuses.add("DÉPENDANCE")
            conflict_reasons.append("Friend Area uses shared gFunctionScriptTable behavior; separate generic interaction adapter")
        if asset in eu_mismatches:
            statuses.add("DÉPENDANCE")
            conflict_reasons.append("EU graph needs dedicated decoder/interpreter before implementation")
        if asset in direct:
            statuses.add("DÉPENDANCE")
            conflict_reasons.append("one of 27 dungeon-backed relationships; keep separate from archive-backed Ground")
        if lua_path is None:
            statuses.add("PORTÉ")
            conflict_reasons.append("EU station s06 has no New Era scene module")

        primary_classification, primary_reason = primary_scene_classification(
            routed=asset in routed_scenes or bool(init_routes.get(asset)),
            has_new_era_module=lua_path is not None,
            has_exact_eu_graph=exact is not None,
        )
        statuses.add(primary_classification)
        secondary_indicators = sorted(statuses - {primary_classification})

        scene = {
            "asset": asset,
            "map_id": conversion[asset]["map_id"],
            "map_file_id": conversion[asset]["map_file_id"],
            "source": {
                "station_header": source_path.relative_to(pret_root).as_posix(),
                "sha256": sha256_file(source_path), "line_count": len(source.splitlines()),
                "command_array_count": len(arrays), "macro_call_count": sum(macros.values()),
                "macro_counts": dict(sorted(macros.items())), "domains": source_domain,
                "initial_entity_positions": positions, "ground_links": links,
                "final_position_basis": "ordered movement signatures per branch in source_action_index.json; deterministic end coordinates require opcode/branch replay",
            },
            "eu_authority": {
                "status": "EXACT_EU_GRAPH" if exact else "DECODER_DEPENDENCY",
                "regional_ground_id": conversion[asset]["map_id"],
                "exact_command_count": exact["summary"]["eu_command_count"] if exact else None,
                "french_text_block_count": len(exact_french) if exact else None,
                "french_text_aggregate_sha256": french_hash,
                "technical_gap": eu_mismatches.get(asset, {}).get("error"),
            },
            "new_era": {
                "scene_file": lua_path.relative_to(root).as_posix() if lua_path else None,
                "scene_sha256": sha256_file(lua_path) if lua_path else None,
                "implementation_source": (central_path.relative_to(root).as_posix() if wrapper else lua_path.relative_to(root).as_posix()) if lua_path else None,
                "wrapper_to_fugitive_cinematics": wrapper, "executed_api_call_count": len(new_calls(implementation)),
                "domains": current_domain, "commented_placeholder_call_count": commented_calls,
                "dialogue_key_count": len(dialogue_keys), "dialogue_key_nonempty_french_count": len(keys_nonempty),
                "literal_dialogue_call_count": literal_dialogues, "raw_exact_eu_french_match_count": raw_matches,
                "in_fugitive_sequence": asset in routed_scenes, "route": route_by_scene.get(asset),
                "ground_init_routes": sorted(init_routes.get(asset, [])),
            },
            "matrix": domain_matrix,
            "primary_classification": primary_classification,
            "primary_classification_reason": primary_reason,
            "secondary_indicators": secondary_indicators,
            "statuses": sorted(statuses), "conflict_reasons": conflict_reasons,
            "ground_policy": "CONSERVÉ: certified archive-backed Ground; no regeneration or geometry/visual edit",
            "dungeon_backed_relationship": asset in direct,
        }
        scenes.append(scene)
        action_index.append({
            "asset": asset, "source_station_header": source_path.relative_to(pret_root).as_posix(),
            "script_arrays": arrays,
        })

    # Full New Era Lua inventory, including immutable chapter 1-5 files.
    protected_pattern = re.compile(r"(?:_ch_|chapter[_ -]?)([1-5])(?:\D|$)", re.I)
    new_era_files = []
    protected_paths = []
    for path in sorted((root / "Data/Script").rglob("*.lua")):
        text = path.read_text(encoding="utf-8", errors="replace")
        relative = path.relative_to(root).as_posix()
        protected = bool(protected_pattern.search(relative))
        if protected:
            protected_paths.append(relative)
        new_era_files.append({
            "path": relative, "sha256": sha256_file(path), "line_count": len(text.splitlines()),
            "executed_api_call_count": len(new_calls(text)),
            "commented_api_call_count": len(re.findall(r"^\s*--\s*(?:GAME|GROUND|SOUND|UI|TASK|COMMON|BossFX|CharacterEssentials)\s*[:.]", text, re.M)),
            "pmdred_asset_references": sorted(set(re.findall(r"\b(?:[tabdhs]\d\dp\d\d[a-z]?|s\d\d(?:_(?:ger|fre|ita|spa))?)\b", text, re.I))),
            "chapters_1_to_5_protected": protected,
            "protection_primary_classification": "CONFLIT" if protected else "CONSERVÉ",
        })

    # Dungeon cutscene C inventory remains separate from station/Ground scripts.
    dungeon_cutscenes = []
    all_new_lua = "\n".join(path.read_text(encoding="utf-8", errors="replace") for path in (root / "Data/Script").rglob("*.lua"))
    dungeon_source_paths = sorted((pret_root / "src").glob("dungeon_cutscene_*.c"))
    dungeon_source_paths.insert(0, pret_root / "src/dungeon_cutscene.c")
    for path in dungeon_source_paths:
        name = path.stem.removeprefix("dungeon_cutscene_")
        if path.stem == "dungeon_cutscene":
            name = "engine_core"
        text = path.read_text(encoding="utf-8")
        actors = sorted(set(re.findall(r"\bMONSTER_[A-Z0-9_]+", text)))
        music = sorted(set(re.findall(r"\bMUS_[A-Z0-9_]+", text)))
        target = DIRECT_CUTSCENE_TARGETS.get(name)
        refs = sorted(actor for actor in actors if actor.removeprefix("MONSTER_").title().replace("_", "") in all_new_lua.replace("_", ""))
        statuses = ["DÉPENDANCE"]
        if target and target in routed_scenes:
            primary_classification = "CONFLIT"
            primary_reason = "cible Ground déjà routée par FugitiveArc; préserver l'implémentation New Era"
            statuses += ["CONFLIT", "ADAPTÉ"]
        elif name == "engine_core":
            primary_classification = "DÉPENDANCE"
            primary_reason = "moteur commun requis par les cinématiques spécialisées"
        else:
            primary_classification = "PORTÉ"
            primary_reason = "module canonique de cinématique de donjon sans restitution New Era fidèle démontrée"
            statuses.append("PORTÉ")
        dungeon_cutscenes.append({
            "id": name, "source_file": path.relative_to(pret_root).as_posix(), "sha256": sha256_file(path),
            "line_count": len(text.splitlines()), "actors": actors, "music": music,
            "dialogue_macro_count": sum(count for key, count in macro_calls(text).items() if key.startswith(("MSG_", "ASK", "CHOICE"))),
            "function_call_count": len(re.findall(r"\b[A-Za-z_][A-Za-z0-9_]*\s*\(", text)),
            "suggested_ground_dependency": target, "new_era_actor_name_hits": refs,
            "primary_classification": primary_classification,
            "primary_classification_reason": primary_reason,
            "secondary_indicators": sorted(set(statuses) - {primary_classification}),
            "statuses": sorted(set(statuses)),
            "scope_note": "separate in-dungeon/cutscene engine path; do not collapse into the 219 archive-backed Ground result",
        })

    # Music and actor asset dependencies.
    source_text = "\n".join(path.read_text(encoding="utf-8", errors="replace") for path in station_paths.values()) + "\n" + "\n".join((pret_root / row["source_file"]).read_text(encoding="utf-8", errors="replace") for row in dungeon_cutscenes)
    music_tokens = sorted(set(re.findall(r"\bMUS_[A-Z0-9_]+", source_text)))
    music_files = sorted(path.name for path in (root / "Content/Music").glob("*"))
    music_assets = []
    for token in music_tokens:
        matches = [name for name in music_files if normalized_asset_name(name) == normalized_asset_name(token)]
        music_classification = "ADAPTÉ" if matches else "PORTÉ"
        music_assets.append({"source_token": token, "exact_normalized_new_era_matches": matches, "primary_classification": music_classification, "status": music_classification, "requirement": "verify audio identity, loop points, volume and cue timing; filename similarity is not fidelity proof"})

    monster_defines = {name: int(value) for name, value in re.findall(r"^#define\s+(MONSTER_[A-Z0-9_]+)\s+(\d+)", (pret_root / "include/constants/monster.h").read_text(), re.M)}
    actor_tokens = sorted(set(re.findall(r"\bMONSTER_[A-Z0-9_]+", source_text)))
    actor_assets = []
    for token in actor_tokens:
        monster_id = monster_defines.get(token)
        chara = sorted(path.relative_to(root).as_posix() for path in (root / "Content/Chara").glob(f"{monster_id}.*")) if monster_id is not None else []
        portrait = sorted(path.relative_to(root).as_posix() for path in (root / "Content/Portrait").glob(f"{monster_id}.*")) if monster_id is not None else []
        actor_classification = "ADAPTÉ" if chara or portrait else "DÉPENDANCE"
        actor_assets.append({"source_token": token, "pmdred_monster_id": monster_id, "new_era_chara_overrides": chara, "new_era_portrait_overrides": portrait, "primary_classification": actor_classification, "status": actor_classification, "requirement": "PMDO base asset availability plus every required animation and portrait emotion must be runtime-probed"})

    relationships = []
    for row in direct_manifest["relationships"]:
        mapping = row["mapping"]
        relationships.append({
            "ground": mapping["stable_ground_id"], "dungeon_id": mapping["dungeon_id"],
            "french_name": row["dungeon"]["french_name_primary"], "playable_floor_count": row["dungeon"]["playable_floor_count"],
            "role": row["role"], "primary_classification": "DÉPENDANCE", "status": "DÉPENDANCE",
            "requirement": "keep separate; bind script/music/entry/exit only after its independent dungeon-backed promotion/runtime gate",
        })

    status_counts = collections.Counter(status for scene in scenes for status in scene["statuses"])
    primary_classification_counts = collections.Counter(
        scene["primary_classification"] for scene in scenes
    )
    exact_french_total = sum(scene["eu_authority"]["french_text_block_count"] or 0 for scene in scenes)
    current_key_total = sum(scene["new_era"]["dialogue_key_count"] for scene in scenes)
    current_nonempty_total = sum(scene["new_era"]["dialogue_key_nonempty_french_count"] for scene in scenes)
    all_resx_raw_exact_matches = 0
    for asset, exact in exact_eu.items():
        source_values = {block["languages"]["fr"]["text"] for block in exact["text_blocks"]}
        current_values = [value for key, value in french_values.items() if key.startswith(f"SCENE_{asset.upper()}_") and value]
        all_resx_raw_exact_matches += sum(value in source_values for value in current_values)
    report = {
        "schema": "new-era.pmdred-eu-narrative-scope-audit.v1",
        "generated_at": "2026-08-12",
        "result": "AUDIT_COMPLETE_NO_IN_GAME_CHANGE",
        "authority": {
            "eu_rom_sha256": ROM_SHA256, "pret_commit": PRET_COMMIT,
            "ground_manifest_sha256": sha256_file(root / "docs/pmdred_eu/ground_manifest.json"),
            "exact_eu_script_report": eu_report_path.relative_to(root).as_posix() if eu_report_path.is_relative_to(root) else str(eu_report_path),
            "exact_eu_script_report_sha256": sha256_file(eu_report_path),
            "exact_eu_graph_count": len(exact_eu), "decoder_dependency_count": len(eu_mismatches),
        },
        "scope": {
            "station_scene_count": len(scenes), "dungeon_cutscene_module_count": len(dungeon_cutscenes),
            "new_era_lua_file_count": len(new_era_files), "chapter_1_to_5_explicit_protected_file_count": len(protected_paths),
            "certified_archive_backed_ground_count": len(validated), "dungeon_backed_relationship_count": len(relationships),
        },
        "findings": {
            "source_station_macro_call_count": sum(all_source_macros.values()),
            "source_station_command_array_count": sum(scene["source"]["command_array_count"] for scene in scenes),
            "source_domain_counts": dict(sorted(sum((collections.Counter(scene["source"]["domains"]) for scene in scenes), collections.Counter()).items())),
            "new_era_executed_domain_counts": dict(sorted(all_current_domains.items())),
            "new_era_scene_file_count": len(scene_files),
            "missing_eu_scene_modules": missing_new_era_scene_files,
            "non_eu_scene_modules": non_eu_new_era_scene_files,
            "new_era_wrapper_scene_count": sum(scene["new_era"]["wrapper_to_fugitive_cinematics"] for scene in scenes),
            "new_era_commented_placeholder_call_count": sum(scene["new_era"]["commented_placeholder_call_count"] for scene in scenes),
            "new_era_routed_scene_count": len(routed_scenes), "new_era_french_resx_key_count": len(french_values),
            "new_era_french_resx_nonempty_count": sum(bool(value) for value in french_values.values()),
            "new_era_scene_dialogue_key_reference_count": current_key_total,
            "new_era_scene_dialogue_key_nonempty_reference_count": current_nonempty_total,
            "exact_eu_french_text_blocks_in_decoded_graphs": exact_french_total,
            "executed_scene_key_raw_exact_eu_french_match_count": raw_french_match_count,
            "all_nonempty_resx_raw_exact_eu_french_match_count": all_resx_raw_exact_matches,
            "primary_classification_counts": dict(sorted(primary_classification_counts.items())),
            "status_occurrences": dict(sorted(status_counts.items())),
            "verdict": "No current New Era scene has complete evidence for PMD Red EU dialogue, actors, choreography, camera, VFX, audio, timing, transitions and event logic together; no scene qualifies as fully CONSERVÉ narrative execution.",
        },
        "scenes": scenes,
        "non_eu_scene_variants": [
            {
                "asset": asset,
                "scene_file": scene_files[asset].relative_to(root).as_posix(),
                "sha256": sha256_file(scene_files[asset]),
                "primary_classification": "CONFLIT",
                "reason": "variante New Era/pret US absente du corpus EU; conserver hors matrice canonique EU",
            }
            for asset in non_eu_new_era_scene_files
        ],
        "dungeon_cutscenes": dungeon_cutscenes,
        "assets": {
            "music": music_assets,
            "actors": actor_assets,
            "sound_effects": {
                "primary_classification": "PORTÉ",
                "secondary_indicators": ["ADAPTÉ"],
                "policy": "source effect IDs require an explicit PMD Red→PMDO sound map and cue-timing validation",
            },
            "visual_effects_and_transitions": {
                "primary_classification": "PORTÉ",
                "secondary_indicators": ["ADAPTÉ"],
                "policy": "raw opcodes and GroundEffectData require visual equivalence tests; BossFX presence alone is not proof",
            },
            "french_dialogue_corpus": {
                "primary_classification": "PORTÉ",
                "secondary_indicators": ["DÉPENDANCE"],
                "policy": "import exact EU French text, markup, speaker variants and ordering after decoder closure",
            },
        },
        "dependencies": {
            "archive_backed_grounds": {
                "count": 219,
                "primary_classification": "DÉPENDANCE",
                "preservation_status": "CONSERVÉ",
                "policy": "immutable certified inputs",
                "entries": [
                    {"ground_id": ground_id, "primary_classification": "DÉPENDANCE", "preservation_status": "CONSERVÉ"}
                    for ground_id in sorted(validated)
                ],
            },
            "dungeon_backed_relationships": relationships,
            "systems": [
                {
                    "id": system_id,
                    "primary_classification": "DÉPENDANCE",
                    "requirement": requirement,
                }
                for system_id, requirement in (
                    ("ground_command_ir", "interpréteur/IR des commandes Ground PMD Red"),
                    ("multi_actor_scheduler", "scheduler ALERT_CUE/AWAIT_CUE déterministe"),
                    ("coordinate_adapter", "conversion exacte coordonnées, directions et vitesses"),
                    ("camera_adapter", "durées et easing caméra mesurés"),
                    ("portrait_variants", "portraits héros/partenaire et émotions"),
                    ("parallel_save_namespace", "flags PMD Red EU séparés de SV.FugitiveArc"),
                    ("ground_dungeon_battle_routes", "transitions, victoire, défaite et retours"),
                    ("timeline_capture_harness", "capture des frames, états finaux et événements audio"),
                )
            ],
        },
        "chapter_1_to_5": {
            "primary_classification": "CONFLIT",
            "status": "CONFLIT_PROTECTED",
            "policy": "no replacement, overwrite, reroute or flag reuse",
            "explicit_files": protected_paths,
            "explicit_file_classifications": [
                {"path": path, "primary_classification": "CONFLIT"}
                for path in protected_paths
            ],
        },
        "new_era_script_inventory": new_era_files,
        "migration_gate": "No in-game implementation until all PORTÉ/ADAPTÉ/CONFLIT/DEPENDANCE rows have an owner, exact source branch, PMDO mapping, asset gate and regression plan.",
    }

    output.mkdir(parents=True, exist_ok=True)
    (output / "narrative_scope.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    (output / "source_action_index.json").write_text(json.dumps({"schema": "new-era.pmdred-eu-source-action-index.v1", "pret_commit": PRET_COMMIT, "assets": action_index}, ensure_ascii=False, separators=(",", ":")) + "\n")
    with (output / "matrix.csv").open("w", encoding="utf-8", newline="") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow(["asset", "map_id", "eu_authority", "primary_classification", "primary_classification_reason", "secondary_indicators", "statuses", "routed", "source_arrays", "source_dialogues", "eu_french_blocks", "new_dialogues", "new_nonempty_fr", "source_movement", "new_movement", "source_camera", "new_camera", "source_vfx", "new_vfx", "source_audio", "new_audio", "source_timing", "new_timing", "source_route", "new_route", "conflicts"])
        for scene in scenes:
            sd, nd = scene["source"]["domains"], scene["new_era"]["domains"]
            writer.writerow([scene["asset"], scene["map_id"], scene["eu_authority"]["status"], scene["primary_classification"], scene["primary_classification_reason"], "+".join(scene["secondary_indicators"]), "+".join(scene["statuses"]), scene["new_era"]["in_fugitive_sequence"], scene["source"]["command_array_count"], sd["dialogue"], scene["eu_authority"]["french_text_block_count"], nd["dialogue"], scene["new_era"]["dialogue_key_nonempty_french_count"], sd["movement_path"], nd["movement_path"], sd["camera"], nd["camera"], sd["vfx_transition"], nd["vfx_transition"], sd["audio"], nd["audio"], sd["timing_sync"], nd["timing_sync"], sd["map_route"], nd["map_route"], " | ".join(scene["conflict_reasons"])])
    return report


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pret-root", type=Path, required=True)
    parser.add_argument("--eu-script-report", type=Path, required=True)
    parser.add_argument("--output", type=Path, default=Path("docs/pmdred_eu/narrative_audit"))
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    pret = args.pret_root if args.pret_root.is_absolute() else root / args.pret_root
    eu = args.eu_script_report if args.eu_script_report.is_absolute() else root / args.eu_script_report
    output = args.output if args.output.is_absolute() else root / args.output
    if subprocess.check_output(["git", "-C", str(pret), "rev-parse", "HEAD"], text=True).strip() != PRET_COMMIT:
        raise ValueError("pret checkout commit mismatch")
    report = build(root, pret, eu, output)
    print("PMDRED_EU_NARRATIVE_SCOPE_AUDIT_PASS", json.dumps(report["scope"], sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
