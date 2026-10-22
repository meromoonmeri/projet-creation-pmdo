#!/usr/bin/env python3
"""Build the fail-closed PMD Red -> exact PMDO 0.8.12 opcode registry.

This registry proves source semantics and PMDO API availability separately.  It
never treats an API candidate, a converted Ground, or an environmental import
as a production-ready cinematic adapter.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
from collections import Counter
from pathlib import Path
from typing import Any

PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"
PMDO_RUNTIME_COMMIT = "61c005e1dc9fd4eee6e6e7fcde77364de33d291e"
PMDO_EXECUTABLE_SHA256 = "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327"
PMDO_PDB_SHA256 = "8a0b86b6115dcb9b99a34ef767bdc4cda1b9ab6082b49896a905d060d496937f"
PMDO_DUMP_TAG_COMMIT = "f7f79d1b2ebaf13633a4387cdb8deba73353a533"
PMDC_COMMIT = "e975bd33e32bc774a43fdab24dc2e781c5a38bab"
ROGUE_ESSENCE_COMMIT = "4961b2271bb0cace74f40f6a85e799e8e4848ace"
ROGUE_ELEMENTS_COMMIT = "a3869ec8f451ada25efdb453b85281fd098c1671"

EXPECTED_PRET_BLOBS = {
    "include/data_script.h": "5ed91e16fcb93817cc7a098908b0a6542bb6c01e",
    "include/constants/direction.h": "c2a1d19f632b0dc8817177f5a27f72b64ae4e4b4",
    "src/ground_script.c": "87431714802987dedbc0330b7338ad90f390ce0b",
    "src/direction_util.c": "ba6d169507615e34988dae40135ba39011ef840f",
    "src/textbox.c": "f2e66d8da1fa14b3ee216350c00a131698fa5a9a",
    "src/palette_util.c": "926d28d1ede0270717649e587edf569639245a27",
    "src/ground_lives.c": "d4a101ff03a49375cd363188ae6df16fec71d3ea",
    "include/structs/str_ground_script.h": "9582fa965c290850861d219d39e0c8083948308e",
}
EXPECTED_ROGUE_BLOBS = {
    "RogueEssence/Lua/ScriptGround.cs": "a23124550a82a2daa30c5fb9d01f0d1d2302d447",
    "RogueEssence/Lua/ScriptGame.cs": "87251bb66a58c4056b60c5ac10c903ee1ddb95d7",
    "RogueEssence/Lua/ScriptUI.cs": "fb769d1d3fd701d76f0fc559d8ccb9ac27b6c2fe",
    "RogueEssence/Lua/ScriptSound.cs": "fccdc2fe0602bf8aa1d33a4fa2588c1edb529ade",
}

# The three adapters below have an implementation-level equivalence in exact
# PMDO 0.8.12.  They still require a compiler-provided current actor where
# stated and do not make any scene routable by themselves.
PROVEN_ADAPTERS = {
    "WAIT": {
        "rule": "WAIT(frames) -> GAME:WaitFrames(frames)",
        "pmdo_calls": ["GAME:WaitFrames"],
        "preconditions": ["frames is an integer greater than or equal to zero"],
        "proof": "Both engines block the current script for an explicit count of 60 Hz frames.",
    },
    "BGM_FADEOUT": {
        "rule": "BGM_FADEOUT(frames) -> SOUND:FadeOutBGM(frames)",
        "pmdo_calls": ["SOUND:FadeOutBGM"],
        "preconditions": ["frames is an integer greater than or equal to zero"],
        "proof": "The PMD Red executor and exact PMDO API both fade the current BGM over the supplied frame count.",
    },
    "SET_DIR_WAIT": {
        "rule": "SET_DIR_WAIT(direction, frames) -> optional GROUND:EntTurn(actor, mapped_direction), then GAME:WaitFrames(frames)",
        "pmdo_calls": ["GROUND:EntTurn", "GAME:WaitFrames"],
        "preconditions": [
            "the compiler resolves the parent action to one GroundEntity",
            "PMD Red direction symbols are remapped by name, never cast numerically",
            "direction -1 preserves the current direction",
            "frames is an integer greater than or equal to zero",
        ],
        "proof": "The source command sets the parent direction unless it is -1 and then waits; both exact PMDO primitives expose those operations.",
    },
    "ROTATE_TO": {
        "rule": "ROTATE_TO(step_frames, transition, direction) -> symbol-remapped PMDO animated turn with the same one-step or two-step policy",
        "pmdo_calls": ["GROUND:CharAnimateTurn", "GROUND:CharAnimateTurnTo", "GROUND:EntTurn", "GAME:WaitFrames"],
        "preconditions": [
            "the compiler resolves the parent action to one GroundChar",
            "transition is one of the four policies occurring in the 27-asset corpus",
            "PMD Red direction symbols are remapped by name, never cast numerically",
            "step_frames is a positive integer",
        ],
        "source_helper_proof": {
            "path": "src/direction_util.c",
            "blob_sha": "ba6d169507615e34988dae40135ba39011ef840f",
            "lines": [90, 153],
        },
        "proof": "The locked source rotates one direction per delay for forced left/right and shortest policy 10, or two directions per delay for shortest policy 11; the adapter reproduces those visible steps.",
    },
    "CMD_UNK_92": {
        "rule": "CMD_UNK_92(step_frames, turn_step, target_transform) -> derive target from current direction, then perform the same forced animated turn",
        "pmdo_calls": ["GROUND:CharAnimateTurn"],
        "preconditions": [
            "the compiler resolves the parent action to one GroundChar",
            "turn_step and target_transform are one of the three combinations occurring in the corpus",
            "step_frames is a positive integer",
        ],
        "source_helper_proof": {
            "path": "src/direction_util.c",
            "blob_sha": "ba6d169507615e34988dae40135ba39011ef840f",
            "lines": [30, 86],
        },
        "proof": "The locked executor derives a fixed target with TransformDirection1, then uses TransformDirection2 for a forced one-direction step after each delay; the PMDO forced-turn primitive matches that sequence after explicit enum remapping.",
    },
}

PMDO_METHODS = {
    "GAME:WaitFrames": ("RogueEssence/Lua/ScriptGame.cs", "_WaitFrames"),
    "GAME:MoveCamera": ("RogueEssence/Lua/ScriptGame.cs", "_MoveCamera"),
    "GAME:MoveCameraToChara": ("RogueEssence/Lua/ScriptGame.cs", "_MoveCameraToChara"),
    "GAME:EnterDungeon": ("RogueEssence/Lua/ScriptGame.cs", "_EnterDungeon"),
    "GAME:EnterGroundMap": ("RogueEssence/Lua/ScriptGame.cs", "EnterGroundMap"),
    "GROUND:EntTurn": ("RogueEssence/Lua/ScriptGround.cs", "EntTurn"),
    "GROUND:CharAnimateTurn": ("RogueEssence/Lua/ScriptGround.cs", "_CharAnimateTurn"),
    "GROUND:CharAnimateTurnTo": ("RogueEssence/Lua/ScriptGround.cs", "_CharAnimateTurnTo"),
    "GROUND:MoveInDirection": ("RogueEssence/Lua/ScriptGround.cs", "_MoveInDirection"),
    "GROUND:MoveToPosition": ("RogueEssence/Lua/ScriptGround.cs", "_MoveToPosition"),
    "GROUND:AnimateToPosition": ("RogueEssence/Lua/ScriptGround.cs", "_AnimateToPosition"),
    "GROUND:TeleportTo": ("RogueEssence/Lua/ScriptGround.cs", "TeleportTo"),
    "GROUND:CharSetAnim": ("RogueEssence/Lua/ScriptGround.cs", "CharSetAnim"),
    "SOUND:PlayBGM": ("RogueEssence/Lua/ScriptSound.cs", "PlayBGM"),
    "SOUND:FadeOutBGM": ("RogueEssence/Lua/ScriptSound.cs", "FadeOutBGM"),
    "SOUND:PlayFanfare": ("RogueEssence/Lua/ScriptSound.cs", "PlayFanfare"),
    "SOUND:WaitFanfare": ("RogueEssence/Lua/ScriptSound.cs", "_WaitFanfare"),
    "UI:WaitShowDialogue": ("RogueEssence/Lua/ScriptUI.cs", "WaitShowDialogue"),
    "UI:WaitShowTimedDialogue": ("RogueEssence/Lua/ScriptUI.cs", "WaitShowTimedDialogue"),
    "UI:SetSpeaker": ("RogueEssence/Lua/ScriptUI.cs", "SetSpeaker"),
    "UI:SetSpeakerEmotion": ("RogueEssence/Lua/ScriptUI.cs", "SetSpeakerEmotion"),
    "UI:SetSpeakerLoc": ("RogueEssence/Lua/ScriptUI.cs", "SetSpeakerLoc"),
    "UI:BeginChoiceMenu": ("RogueEssence/Lua/ScriptUI.cs", "BeginChoiceMenu"),
    "UI:WaitForChoice": ("RogueEssence/Lua/ScriptUI.cs", "_WaitForChoice"),
}

# Semantics are deliberately concise and conservative.  "PARTIAL" means the
# locked decompilation still reaches an unnamed callback or state machine; it
# must not be promoted merely because a visually similar PMDO API exists.
RAW_META = {
    "01": ("PROVEN", "Requests a Ground transition with map id, mode byte and transition duration.", "ROUTE_BINDING_REQUIRED", ["GAME:EnterGroundMap"], ["canonical Ground and entrypoint binding", "transition-mode binding"]),
    "22": ("PARTIAL", "Starts palette transition controller A with the supplied duration and optionally blocks until the shared palette controller is idle.", "NO_EQUIVALENT_PROVEN", [], ["palette channel and blend curve are not exposed by a proven PMDO equivalent"]),
    "23": ("PARTIAL", "Starts the reverse operation of palette transition controller A and optionally blocks until the shared palette controller is idle.", "NO_EQUIVALENT_PROVEN", [], ["palette channel and blend curve are not exposed by a proven PMDO equivalent"]),
    "25": ("PARTIAL", "Starts palette transition controller B with the supplied duration and optionally blocks until the shared palette controller is idle.", "NO_EQUIVALENT_PROVEN", [], ["second palette channel semantics and PMDO equivalent remain unproved"]),
    "26": ("PARTIAL", "Starts the reverse operation of palette transition controller B and optionally blocks until the shared palette controller is idle.", "NO_EQUIVALENT_PROVEN", [], ["second palette channel semantics and PMDO equivalent remain unproved"]),
    "2D": ("PROVEN", "Binds a text portrait/name slot; submodes 7 and 9 used here derive display species and canonical actor name from the current action or an explicit target.", "TEXT_AND_ACTOR_BINDING_REQUIRED", ["UI:SetSpeaker"], ["source action identity to PMDO GroundChar binding", "portrait slot and format-buffer behavior"]),
    "2E": ("PROVEN", "Sets portrait placement and expression for a previously bound text portrait slot.", "PORTRAIT_BINDING_REQUIRED", ["UI:SetSpeakerEmotion", "UI:SetSpeakerLoc"], ["portrait-slot ownership", "Red portrait expression to PMDO emotion mapping"]),
    "3B": ("PARTIAL", "Invokes the source multipurpose callback dispatcher and branches on its return value.", "NO_EQUIVALENT_PROVEN", [], ["callback-specific game-state semantics must be proved for every selector"]),
    "52": ("PROVEN", "Sets bit flags on the current parent entity through its type-specific callback.", "ENTITY_FLAG_BINDING_REQUIRED", [], ["bit-level source flags to PMDO entity properties"]),
    "53": ("PROVEN", "Clears bit flags on the current parent entity through its type-specific callback.", "ENTITY_FLAG_BINDING_REQUIRED", [], ["bit-level source flags to PMDO entity properties"]),
    "54": ("PROVEN", "Selects the parent entity animation/event index and stores its previous direction.", "ANIMATION_BINDING_REQUIRED", ["GROUND:CharSetAnim"], ["source animation index to PMDO animation name", "entity type binding"]),
    "56": ("PARTIAL", "Writes two values into the parent type's callback-specific sprite state; for lives this controls fields unk16A and unk16C.", "NO_EQUIVALENT_PROVEN", [], ["callback fields remain unnamed", "no proven PMDO sprite-state equivalent"]),
    "59": ("PROVEN", "Applies an immediate relative pixel displacement to the parent and waits the command byte frame count.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:TeleportTo", "GAME:WaitFrames"], ["source collision callback behavior", "entity type and coordinate binding"]),
    "60": ("PROVEN", "Sets parent height from 24.8 fixed-point input and waits the command byte frame count.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:TeleportTo", "GAME:WaitFrames"], ["height origin and fixed-point conversion", "entity binding"]),
    "62": ("PROVEN", "Moves to a relative pixel target at a fixed 24.8 speed without changing facing, stopping on source collision.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:AnimateToPosition"], ["preserve active animation and facing", "source collision-stop equivalence"]),
    "70": ("PROVEN", "Moves parent height toward a fixed target at a fixed 24.8 speed.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:AnimateToPosition"], ["height interpolation and parent action binding"]),
    "72": ("PROVEN", "Interpolates from current position to a relative target over an explicit frame duration without changing facing.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:AnimateToPosition"], ["preserve active animation and facing", "coordinate binding"]),
    "7E": ("PROVEN", "Interpolates to a relative target without changing facing; duration is computed from distance and supplied speed.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:AnimateToPosition"], ["fixed-point speed and duration rounding equivalence"]),
    "84": ("PROVEN", "Interpolates to a relative target at supplied speed while updating facing from the movement vector.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:AnimateToPosition"], ["fixed-point speed and duration rounding equivalence"]),
    "89": ("PROVEN", "Sets an explicit direction, then walks in that direction at fixed 24.8 speed for the command byte frame count or until collision.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:MoveInDirection"], ["source collision-stop equivalence", "direction-symbol remap", "fixed-point speed conversion"]),
    "97": ("PARTIAL", "Configures the source global camera/pan state with three numeric parameters.", "NO_EQUIVALENT_PROVEN", ["GAME:MoveCamera"], ["camera state fields and coordinate semantics remain unnamed"]),
    "9B": ("PARTIAL", "Starts a blocking global camera movement targeting the current parent entity.", "CAMERA_BINDING_REQUIRED", ["GAME:MoveCameraToChara"], ["source camera speed/duration semantics", "parent entity binding"]),
    "DE": ("PARTIAL", "Blocks until the parent callback reports its sprite-related transition complete.", "NO_EQUIVALENT_PROVEN", [], ["callback-specific completion condition remains unnamed"]),
    "DF": ("PARTIAL", "Blocks until the shared source palette transition controller reports idle.", "NO_EQUIVALENT_PROVEN", [], ["palette-controller equivalent remains unproved"]),
}

KIND_META: dict[str, tuple[str, str, list[str], list[str]]] = {}


def define(kinds: str, semantic: str, status: str, calls: list[str] | None = None, blockers: list[str] | None = None) -> None:
    for kind in kinds.split():
        KIND_META[kind] = (semantic, status, calls or [], blockers or [])


def initialize_kind_meta() -> None:
    define("WAIT", "Blocks the current source action for an explicit frame count.", "ADAPTER_PROVEN", ["GAME:WaitFrames"])
    define("BGM_FADEOUT", "Fades the current background track over an explicit frame count.", "ADAPTER_PROVEN", ["SOUND:FadeOutBGM"])
    define("SET_DIR_WAIT", "Sets the current parent direction unless it is -1, then waits an explicit frame count.", "ADAPTER_PROVEN", ["GROUND:EntTurn", "GAME:WaitFrames"], ["current parent actor is compiler context"])
    define("BGM_SWITCH", "Replaces the current source BGM with a numeric music id.", "AUDIO_BINDING_REQUIRED", ["SOUND:PlayBGM"], ["source music id to exact PMDO asset"])
    define("BGM_FADEIN", "Starts a numeric source BGM with an explicit fade duration.", "AUDIO_BINDING_REQUIRED", ["SOUND:PlayBGM"], ["source music id to exact PMDO asset"])
    define("FANFARE_PLAY FANFARE_PLAY2", "Plays a numeric source sound/fanfare id.", "AUDIO_BINDING_REQUIRED", ["SOUND:PlayFanfare"], ["source sound id to exact PMDO asset and channel"])
    define("FANFARE_STOP2 FANFARE_FADEOUT2", "Stops or fades a numeric source sound on its source channel.", "AUDIO_BINDING_REQUIRED", [], ["source sound id and channel", "no exact PMDO fanfare stop/fade API proved"])
    define("WAIT_FANFARE1 WAIT_FANFARE2", "Blocks while the specified numeric source sound remains active.", "AUDIO_BINDING_REQUIRED", ["SOUND:WaitFanfare"], ["specific source sound id and channel semantics"])
    define("MSG_INSTANT", "Prints blocking instant-style source text without a bound portrait.", "TEXT_BINDING_REQUIRED", ["UI:WaitShowDialogue"], ["exact EU French text body"])
    define("MSG_NPC", "Prints blocking NPC-style source text using a portrait/speaker slot.", "TEXT_AND_ACTOR_BINDING_REQUIRED", ["UI:SetSpeaker", "UI:WaitShowDialogue"], ["exact EU French text body", "speaker-slot binding"])
    define("MSG_OVERHEARD", "Prints blocking overheard/background source dialogue.", "TEXT_BINDING_REQUIRED", ["UI:WaitShowDialogue"], ["exact EU French text body", "textbox-style parity"])
    define("MSG_ON_BG_AUTO", "Prints source background narration with automatic progression.", "TEXT_BINDING_REQUIRED", ["UI:WaitShowTimedDialogue"], ["exact EU French text body", "fade/timing parity"])
    define("PORTRAIT PORTRAIT_REP", "Sets portrait placement and expression for a source speaker slot.", "PORTRAIT_BINDING_REQUIRED", ["UI:SetSpeakerEmotion", "UI:SetSpeakerLoc"], ["speaker slot", "expression and placement mapping"])
    define("PORTRAIT_POS", "Offsets a source portrait slot by explicit screen coordinates.", "PORTRAIT_BINDING_REQUIRED", ["UI:SetSpeakerLoc"], ["speaker slot and coordinate-origin mapping"])
    define("TEXTBOX_AUTO_PRESS", "Configures independent source mid-message and end-message automatic button timers.", "NO_EQUIVALENT_PROVEN", [], ["PMDO SetAutoFinish has no proved dual timer equivalent"])
    define("ASK1 CHOICE", "Builds and displays a blocking source choice menu whose result selects a branch label.", "CONTROL_FLOW_COMPILER_REQUIRED", ["UI:BeginChoiceMenu", "UI:WaitForChoice"], ["exact EU French prompt and choices", "branch-label lowering"])
    define("MSG_VAR VARIANT VARIANT_DEFAULT", "Selects a source text variant from a script variable and contiguous variant records.", "CONTROL_FLOW_COMPILER_REQUIRED", ["UI:WaitShowDialogue"], ["script-variable model", "exact EU French text variants"])
    define("JUMPIF JUMPIF_ARRAY JUMPIF_EQUAL JUMPIF_SCENARIOCHECK COND COND_EQUAL CJUMP_SCENARIO_0 CJUMP_VAR", "Evaluates source script state and resolves a conditional label/variant branch.", "CONTROL_FLOW_COMPILER_REQUIRED", [], ["canonical script-variable and scenario-state adapter", "label lowering"])
    define("JUMP_LABEL LABEL", "Defines or jumps to a local source command-array label.", "CONTROL_FLOW_COMPILER_REQUIRED", [], ["label graph lowering"])
    define("CALL_SCRIPT JUMP_SCRIPT", "Calls or tail-jumps to a predefined source function script.", "CONTROL_FLOW_COMPILER_REQUIRED", [], ["predefined source function adapter and call-stack semantics"])
    define("CALL_STATION", "Calls another station script while preserving a one-level source return context.", "CONTROL_FLOW_COMPILER_REQUIRED", [], ["station graph resolution and source call-stack semantics"])
    define("EXECUTE_STATION", "Executes the selected map station for an explicit map/group/sector.", "CONTROL_FLOW_COMPILER_REQUIRED", [], ["station graph resolution and actor context"])
    define("ALERT_CUE", "Unlocks a numbered source script cue used to synchronize concurrent actor/event arrays.", "CONCURRENCY_COMPILER_REQUIRED", [], ["deterministic cue scheduler"])
    define("AWAIT_CUE", "Blocks and conditionally branches until a numbered source script cue is unlocked.", "CONCURRENCY_COMPILER_REQUIRED", [], ["deterministic cue scheduler and branch resolution"])
    define("CMD_UNK_E5", "Sets a cue branch discriminator, locks the numbered cue with a branch value, and blocks until release.", "CONCURRENCY_COMPILER_REQUIRED", [], ["deterministic cue scheduler and branch resolution"])
    define("UPDATE_VARINT", "Applies a source arithmetic/bit operation with an immediate value to a script variable.", "STATE_BINDING_REQUIRED", [], ["canonical variable identity and persistence mapping"])
    define("SET_DUNGEON_RES", "Writes source DUNGEON_RESULT and DUNGEON_ENTER variables.", "ROUTE_BINDING_REQUIRED", [], ["PMDO result/entry state mapping and journey outcome contract"])
    define("NEXT_DUNGEON", "Requests the next source dungeon and branches according to request availability.", "ROUTE_BINDING_REQUIRED", ["GAME:EnterDungeon"], ["canonical zone/segment/entry mapping", "route outcome semantics"])
    define("SELECT_MAP", "Selects a source Ground map and resets/reloads its map, link, lives and object state.", "GROUND_CONTEXT_REQUIRED", [], ["certified immutable Ground assertion", "source map id binding"])
    define("SELECT_ENTITIES", "Selects lives, objects, effects and events for a source group/sector.", "GROUND_CONTEXT_REQUIRED", [], ["source entity tables to transient PMDO actors/controllers"])
    define("SELECT_LIVES", "Selects source lives for a group/sector.", "GROUND_CONTEXT_REQUIRED", [], ["source lives to transient PMDO actor binding"])
    define("SELECT_OBJECTS", "Selects source objects for a group/sector.", "GROUND_CONTEXT_REQUIRED", [], ["source objects to transient PMDO entity binding"])
    define("SELECT_EFFECTS", "Selects source effects for a group/sector.", "GROUND_CONTEXT_REQUIRED", [], ["source effects to PMDO VFX/controller binding"])
    define("SELECT_EVENTS", "Selects source events for a group/sector.", "GROUND_CONTEXT_REQUIRED", [], ["source events to PMDO controller binding"])
    define("CANCEL_OBJECTS CANCEL_EFFECTS", "Cancels the selected source object/effect group and sector.", "GROUND_CONTEXT_REQUIRED", [], ["transient entity ownership and cancellation parity"])
    define("SELECT_ANIMATION", "Selects the parent entity animation/event index.", "ANIMATION_BINDING_REQUIRED", ["GROUND:CharSetAnim"], ["source animation index to PMDO animation name", "parent entity type"])
    define("ROTATE_TO", "Rotates the current parent toward an explicit source direction using a source transition policy and step delay.", "ADAPTER_PROVEN", ["GROUND:CharAnimateTurn", "GROUND:CharAnimateTurnTo", "GROUND:EntTurn", "GAME:WaitFrames"], ["current parent actor is compiler context"])
    define("CMD_UNK_92", "Rotates toward a direction derived from the current direction by a source direction transformation.", "ADAPTER_PROVEN", ["GROUND:CharAnimateTurn"], ["current parent actor is compiler context"])
    define("CMD_UNK_93", "Rotates toward a resolved source entity using a source direction transition policy.", "ORIENTATION_BINDING_REQUIRED", ["GROUND:CharAnimateTurn", "GROUND:CharAnimateTurnTo"], ["target and parent actor binding", "transition policy lowering"])
    define("WALK_RELATIVE", "Walks from current position to a relative pixel target at fixed 24.8 speed, updating facing and stopping on collision.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:MoveToPosition"], ["parent actor", "fixed-point speed conversion", "collision-stop equivalence"])
    define("WALK_GRID", "Walks to a source Ground link/waypoint at fixed 24.8 speed, updating facing and stopping on collision.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:MoveToPosition"], ["source link geometry", "parent actor", "collision-stop equivalence"])
    define("WALK_DIRECT", "Interpolates toward a source Ground link while updating facing over an explicit duration.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:AnimateToPosition"], ["source link geometry", "parent actor", "duration parity"])
    define("WARP_WAYPOINT", "Moves the parent immediately to a source Ground link position and optionally waits.", "ENTITY_AND_GEOMETRY_BINDING_REQUIRED", ["GROUND:TeleportTo", "GAME:WaitFrames"], ["source link geometry", "parent entity"])
    define("CAMERA_PAN", "Interpolates the source camera toward a Ground link target while updating pan state.", "CAMERA_BINDING_REQUIRED", ["GAME:MoveCamera"], ["source link geometry", "camera speed/duration parity"])
    define("FLASH_FROM FLASH_TO", "Runs a blocking source color/palette transition on an explicit palette channel.", "NO_EQUIVALENT_PROVEN", [], ["arbitrary RGB palette channel and blend-curve equivalent"])
    define("RENAME_ALLY", "Opens source ally naming for the selected party identity and writes the accepted name.", "STATE_BINDING_REQUIRED", [], ["party identity and PMDO naming-menu flow"])


initialize_kind_meta()


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git_output(root: Path, *args: str) -> str:
    return subprocess.check_output(["git", "-C", str(root), *args], text=True).strip()


def verify_checkout(root: Path, commit: str, blobs: dict[str, str]) -> None:
    if git_output(root, "rev-parse", "HEAD") != commit:
        raise ValueError(f"checkout commit mismatch: {root}")
    for rel, expected in blobs.items():
        path = root / rel
        if not path.is_file():
            raise FileNotFoundError(path)
        actual = git_output(root, "hash-object", rel)
        if actual != expected:
            raise ValueError(f"locked blob mismatch: {rel}: {actual} != {expected}")


def verify_pmdo_pdb(path: Path) -> None:
    if not path.is_file():
        raise FileNotFoundError(path)
    if sha256(path) != PMDO_PDB_SHA256:
        raise ValueError("exact PMDO RogueEssence PDB SHA-256 mismatch")
    source_link = (
        b"https://raw.githubusercontent.com/RogueCollab/RogueEssence/"
        + ROGUE_ESSENCE_COMMIT.encode("ascii")
        + b"/*"
    )
    if source_link not in path.read_bytes():
        raise ValueError("exact PMDO PDB does not attest the locked RogueEssence Source Link")


def parse_macros(path: Path) -> dict[str, dict[str, Any]]:
    rows: dict[str, dict[str, Any]] = {}
    pattern = re.compile(r"^\s*#define\s+([A-Z][A-Z0-9_]*)[^\n]*\{\s*CMD_BYTE_([0-9A-F]{2})\b")
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        match = pattern.search(line)
        if match:
            rows[match.group(1)] = {"opcode": match.group(2), "line": line_number}
    return rows


def case_lines(path: Path) -> dict[str, list[int]]:
    rows: dict[str, list[int]] = {}
    pattern = re.compile(r"\bcase\s+CMD_BYTE_([0-9A-F]{2})\s*:")
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        match = pattern.search(line)
        if match:
            rows.setdefault(match.group(1), []).append(line_number)
    return rows


def method_line(path: Path, method: str) -> int:
    pattern = re.compile(rf"\b{re.escape(method)}\s*\(")
    for line_number, line in enumerate(path.read_text(encoding="utf-8-sig").splitlines(), 1):
        if "public " in line and pattern.search(line):
            return line_number
    # LuaFunction fields such as WaitShowDialogue are public but not methods.
    field_pattern = re.compile(rf"\b{re.escape(method)}\s*;")
    for line_number, line in enumerate(path.read_text(encoding="utf-8-sig").splitlines(), 1):
        if "public " in line and field_pattern.search(line):
            return line_number
    raise ValueError(f"exact PMDO API method not found: {path}:{method}")


def action_counts(action_index: dict[str, Any], scope: dict[str, Any]) -> Counter[str]:
    selected = {row["asset"] for row in scope["scenes"] if row.get("dungeon_backed_relationship")}
    if len(selected) != 27:
        raise ValueError("expected exactly 27 dungeon-backed assets")
    result: Counter[str] = Counter()
    for asset in action_index["assets"]:
        if asset["asset"] not in selected:
            continue
        for array in asset["script_arrays"]:
            result.update(action["kind"] for action in array["actions"])
    return result


def source_info(kind: str, macros: dict[str, dict[str, Any]], cases: dict[str, list[int]]) -> tuple[str, str | None, int | None]:
    raw = re.fullmatch(r"RAW_OPCODE_0X([0-9A-F]{2})", kind)
    if raw:
        return raw.group(1), None, None
    macro = macros.get(kind)
    if macro is None:
        raise ValueError(f"no locked source macro/opcode found for {kind}")
    opcode = macro["opcode"]
    if opcode not in cases:
        raise ValueError(f"no source executor case found for {kind}/{opcode}")
    return opcode, kind, macro["line"]


def build(
    action_index: dict[str, Any],
    scope: dict[str, Any],
    pret_root: Path,
    rogue_root: Path,
    pmdo_pdb: Path,
) -> dict[str, Any]:
    verify_checkout(pret_root, PRET_COMMIT, EXPECTED_PRET_BLOBS)
    verify_checkout(rogue_root, ROGUE_ESSENCE_COMMIT, EXPECTED_ROGUE_BLOBS)
    verify_pmdo_pdb(pmdo_pdb)
    if action_index.get("pret_commit") != PRET_COMMIT:
        raise ValueError("source action authority is not pinned to the expected pret commit")

    macros = parse_macros(pret_root / "include/data_script.h")
    cases = case_lines(pret_root / "src/ground_script.c")
    counts = action_counts(action_index, scope)
    if sum(counts.values()) != 4967 or len(counts) != 88:
        raise ValueError("dungeon opcode authority totals changed")

    api_proof: dict[str, dict[str, Any]] = {}
    for api, (rel, method) in sorted(PMDO_METHODS.items()):
        api_proof[api] = {
            "source_path": rel,
            "source_blob_sha": EXPECTED_ROGUE_BLOBS[rel],
            "line": method_line(rogue_root / rel, method),
            "member": method,
        }

    entries = []
    status_actions: Counter[str] = Counter()
    status_kinds: Counter[str] = Counter()
    semantics_actions: Counter[str] = Counter()
    for kind in sorted(counts):
        opcode, macro_name, macro_line = source_info(kind, macros, cases)
        if kind.startswith("RAW_OPCODE_"):
            if opcode not in RAW_META:
                raise ValueError(f"missing conservative raw-opcode semantics: {kind}")
            semantic_status, semantic, status, calls, blockers = RAW_META[opcode]
        else:
            if kind not in KIND_META:
                raise ValueError(f"missing conservative kind semantics: {kind}")
            semantic, status, calls, blockers = KIND_META[kind]
            semantic_status = "PROVEN"
        if status == "ADAPTER_PROVEN" and kind not in PROVEN_ADAPTERS:
            raise ValueError(f"missing proved adapter contract: {kind}")
        status_actions[status] += counts[kind]
        status_kinds[status] += 1
        semantics_actions[semantic_status] += counts[kind]
        entry: dict[str, Any] = {
            "kind": kind,
            "occurrence_count": counts[kind],
            "source_opcode": f"0x{opcode}",
            "source_macro": macro_name,
            "source_semantics_status": semantic_status,
            "source_semantics": semantic,
            "source_proof": {
                "executor": {
                    "path": "src/ground_script.c",
                    "blob_sha": EXPECTED_PRET_BLOBS["src/ground_script.c"],
                    "case_lines": cases[opcode],
                }
            },
            "adapter_status": status,
            "pmdo_api_candidates": [
                {"api": api, **api_proof[api]} for api in calls
            ],
            "remaining_blockers": blockers,
            "runtime_ready": False,
        }
        if macro_name is not None:
            entry["source_proof"]["macro"] = {
                "path": "include/data_script.h",
                "blob_sha": EXPECTED_PRET_BLOBS["include/data_script.h"],
                "line": macro_line,
            }
        if kind in PROVEN_ADAPTERS:
            entry["proved_adapter"] = PROVEN_ADAPTERS[kind]
        entries.append(entry)

    result: dict[str, Any] = {
        "schema": "new-era.pmdred-eu-opcode-registry.v1",
        "result": "PMD_RED_OPCODE_REGISTRY_PASS",
        "meaning": "source semantics and exact PMDO API candidates inventoried; no scene or route is runtime-ready",
        "authority": {
            "pret": {
                "repository": "pret/pmd-red",
                "commit": PRET_COMMIT,
                "locked_blobs": EXPECTED_PRET_BLOBS,
            },
            "pmdo_0_8_12": {
                "runtime_repository": "meromoonmeri/RUNTIMEPMDO",
                "runtime_commit": PMDO_RUNTIME_COMMIT,
                "executable_sha256": PMDO_EXECUTABLE_SHA256,
                "rogue_essence_pdb_sha256": PMDO_PDB_SHA256,
                "pdb_sourcelink_rogue_essence_commit": ROGUE_ESSENCE_COMMIT,
                "pmdodump_tag": "v0.8.12",
                "pmdodump_tag_commit": PMDO_DUMP_TAG_COMMIT,
                "pmdc_commit": PMDC_COMMIT,
                "rogue_essence_commit": ROGUE_ESSENCE_COMMIT,
                "rogue_elements_commit": ROGUE_ELEMENTS_COMMIT,
                "locked_rogue_essence_blobs": EXPECTED_ROGUE_BLOBS,
            },
        },
        "direction_mapping": {
            "rule": "map symbols explicitly; numeric casts are forbidden because horizontal ordering is mirrored",
            "pmd_red": ["SOUTH", "SOUTHEAST", "EAST", "NORTHEAST", "NORTH", "NORTHWEST", "WEST", "SOUTHWEST"],
            "pmdo": ["Down", "DownLeft", "Left", "UpLeft", "Up", "UpRight", "Right", "DownRight"],
            "symbol_map": {
                "DIRECTION_SOUTH": "Direction.Down",
                "DIRECTION_SOUTHEAST": "Direction.DownRight",
                "DIRECTION_EAST": "Direction.Right",
                "DIRECTION_NORTHEAST": "Direction.UpRight",
                "DIRECTION_NORTH": "Direction.Up",
                "DIRECTION_NORTHWEST": "Direction.UpLeft",
                "DIRECTION_WEST": "Direction.Left",
                "DIRECTION_SOUTHWEST": "Direction.DownLeft",
            },
        },
        "asset_count": 27,
        "action_kind_count": len(entries),
        "action_count": sum(counts.values()),
        "source_semantics_action_counts": dict(sorted(semantics_actions.items())),
        "adapter_status_kind_counts": dict(sorted(status_kinds.items())),
        "adapter_status_action_counts": dict(sorted(status_actions.items())),
        "adapter_proven_kind_count": status_kinds["ADAPTER_PROVEN"],
        "adapter_proven_action_count": status_actions["ADAPTER_PROVEN"],
        "runtime_ready_kind_count": 0,
        "runtime_ready_asset_count": 0,
        "production_route_count": 0,
        "entries": entries,
    }
    canonical = json.dumps(entries, ensure_ascii=False, separators=(",", ":"), sort_keys=True).encode()
    result["registry_sha256"] = hashlib.sha256(canonical).hexdigest()
    return result


def main() -> int:
    repo = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-actions", type=Path, default=repo / "docs/pmdred_eu/narrative_audit/source_action_index.json")
    parser.add_argument("--narrative-scope", type=Path, default=repo / "docs/pmdred_eu/narrative_audit/narrative_scope.json")
    parser.add_argument("--pret-root", type=Path, default=repo / ".runtime-cache/pmd-red-bf0092")
    parser.add_argument("--rogue-root", type=Path, default=repo / ".runtime-cache/rogue-essence-0812")
    parser.add_argument("--pmdo-pdb", type=Path, default=repo / ".runtime-cache/pmdo-api-proof/RogueEssence.pdb")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = build(
        read_json(args.source_actions), read_json(args.narrative_scope),
        args.pret_root, args.rogue_root, args.pmdo_pdb,
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: result[key] for key in (
        "result", "asset_count", "action_kind_count", "action_count",
        "adapter_proven_kind_count", "adapter_proven_action_count",
        "runtime_ready_asset_count", "production_route_count",
    )}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
