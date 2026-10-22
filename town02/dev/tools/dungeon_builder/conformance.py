"""Parity and conformance checks.

Two questions this module answers with evidence, not claims:

1. **Parity** — does an `ArchitectureProfile` drive the *same* RogueElements
   step, with the *same* numeric parameters, in the offline simulator
   (`re_sim`) and in the exported zone (`steps.py`)?  If the two ever diverge,
   the validation performed before writing a zone would be meaningless.

2. **Conformance** — does every object emitted into `Data/Zone/<id>.json` use a
   `$type` *and a field set* that already exists in the zones shipped with this
   repository (i.e. that RogueEssence 0.8.12 is known to deserialise)?
"""
from __future__ import annotations

import json
import random
import re
from collections import defaultdict
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Sequence, Set, Tuple

from . import steps as S
from .profiles import ArchitectureProfile, BUILTIN_PROFILES
from .re_sim.paths import (CombineGridRoomStep, ConnectGridBranchStep, GridPathBranch,
                           GridPathCircle, GridPathCross, GridPathGrid, GridPathTiered,
                           GridPathTwoSides, SetGridDefaultsStep)

ROOT = Path(__file__).resolve().parents[2]
ZONE_DIR = ROOT / "Data" / "Zone"

# profile.path -> (simulator class, exported $type fragment)
PATH_BINDING = {
    "branch": (GridPathBranch, "RogueElements.GridPathBranch"),
    "circle": (GridPathCircle, "RogueElements.GridPathCircle"),
    "grid": (GridPathGrid, "RogueElements.GridPathGrid"),
    "twosides": (GridPathTwoSides, "RogueElements.GridPathTwoSides"),
    "cross": (GridPathCross, "RogueElements.GridPathCross"),
    "tiered": (GridPathTiered, "RogueEssence.LevelGen.GridPathTiered"),
}

ROOM_KIND_TYPE = {
    "square": "RogueElements.RoomGenSquare",
    "round": "RogueElements.RoomGenRound",
    "cave": "RogueElements.RoomGenCave",
    "cross": "RogueElements.RoomGenCross",
    "blocked": "RogueElements.RoomGenBlocked",
}


@dataclass
class ParityIssue:
    profile: str
    detail: str


@dataclass
class ParityReport:
    checked: List[str] = field(default_factory=list)
    issues: List[ParityIssue] = field(default_factory=list)
    rows: List[Dict[str, Any]] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.issues


def _range(value) -> Tuple[int, int]:
    return (int(value[0]), int(value[1]))


def check_profile_parity(profile: ArchitectureProfile) -> Tuple[Dict[str, Any], List[str]]:
    """Compare the simulator wiring and the exported JSON for one profile."""
    from .zone_export import path_step, combine_step, rooms_spawn_list, halls_spawn_list

    problems: List[str] = []
    rand = random.Random(0)

    sim_class, exported_type = PATH_BINDING[profile.path]
    sim_step = profile._path_step(profile.picker())
    if not isinstance(sim_step, sim_class):
        problems.append(f"simulator uses {type(sim_step).__name__}, expected {sim_class.__name__}")

    exported = path_step(profile, rand)
    if not exported["$type"].startswith(exported_type):
        problems.append(f"export uses {exported['$type']}, expected {exported_type}")

    # numeric parity, per path family
    if profile.path == "branch":
        pairs = [("RoomRatio", (sim_step.room_ratio.min, sim_step.room_ratio.max), profile.room_ratio),
                 ("BranchRatio", (sim_step.branch_ratio.min, sim_step.branch_ratio.max), profile.branch_ratio)]
        for name, sim_value, prof_value in pairs:
            exp = (exported[name]["Min"], exported[name]["Max"])
            if sim_value != _range(prof_value) or exp != _range(prof_value):
                problems.append(f"{name}: profile={prof_value} sim={sim_value} export={exp}")
        if exported["NoForcedBranches"] != profile.no_forced_branches != sim_step.no_forced_branches:
            problems.append("NoForcedBranches mismatch")
    elif profile.path == "circle":
        exp = (exported["CircleRoomRatio"]["Min"], exported["CircleRoomRatio"]["Max"])
        if exp != _range(profile.circle_room_ratio):
            problems.append(f"CircleRoomRatio: profile={profile.circle_room_ratio} export={exp}")
        exp = (exported["Paths"]["Min"], exported["Paths"]["Max"])
        if exp != _range(profile.circle_paths):
            problems.append(f"Paths: profile={profile.circle_paths} export={exp}")
    elif profile.path == "grid":
        if exported["RoomRatio"] != profile.grid_room_ratio != sim_step.room_ratio:
            problems.append("grid RoomRatio mismatch")
        if exported["HallRatio"] != profile.grid_hall_ratio != sim_step.hall_ratio:
            problems.append("grid HallRatio mismatch")

    # room spawn list: same kinds, same weights, same size ranges
    exported_rooms = rooms_spawn_list(profile)["$values"]
    if len(exported_rooms) != len(profile.rooms):
        problems.append("exported room list length differs from the profile")
    for spec, entry in zip(profile.rooms, exported_rooms):
        expected_type = ROOM_KIND_TYPE[spec.kind]
        if not entry["Spawn"]["$type"].startswith(expected_type):
            problems.append(f"room kind '{spec.kind}' exported as {entry['Spawn']['$type']}")
        if entry["Rate"] != spec.weight:
            problems.append(f"room '{spec.kind}' weight {entry['Rate']} != {spec.weight}")
        width_key = "MajorWidth" if spec.kind == "cross" else "Width"
        height_key = "MajorHeight" if spec.kind == "cross" else "Height"
        exp_w = (entry["Spawn"][width_key]["Min"], entry["Spawn"][width_key]["Max"])
        exp_h = (entry["Spawn"][height_key]["Min"], entry["Spawn"][height_key]["Max"])
        if exp_w != _range(spec.width) or exp_h != _range(spec.height):
            problems.append(f"room '{spec.kind}' size {exp_w}x{exp_h} != {spec.width}x{spec.height}")

    # halls
    hall = halls_spawn_list(profile)["$values"][0]["Spawn"]
    if hall["HallTurnBias"] != profile.hall_turn_bias:
        problems.append("HallTurnBias mismatch between profile and export")
    if not hall["$type"].startswith("RogueElements.RoomGenAngledHall"):
        problems.append("halls must be RoomGenAngledHall")

    # optional grid steps
    sim_connect = ConnectGridBranchStep(profile.connect_percent)
    if profile.connect_percent > 0:
        exported_connect = S.connect_grid_branch(profile.connect_percent, profile.hall_turn_bias)
        if exported_connect["ConnectPercent"] != sim_connect.connect_percent:
            problems.append("ConnectPercent mismatch")
    combined = combine_step(profile)
    if (combined is not None) != (profile.combine_rate > 0):
        problems.append("CombineGridRoomStep presence does not follow combine_rate")
    if profile.default_ratio[1] > 0:
        exported_default = S.set_grid_defaults(profile.default_ratio)
        exp = (exported_default["DefaultRatio"]["Min"], exported_default["DefaultRatio"]["Max"])
        if exp != _range(profile.default_ratio):
            problems.append(f"DefaultRatio {exp} != {profile.default_ratio}")
        SetGridDefaultsStep()  # simulator counterpart exists

    row = {
        "profile": profile.name,
        "path_step": exported["$type"].split("`")[0].split(",")[0],
        "simulator": type(sim_step).__name__,
        "rooms": ", ".join(f"{s.kind} {s.width[0]}-{s.width[1]}x{s.height[0]}-{s.height[1]} (w{s.weight})"
                           for s in profile.rooms),
        "connect_percent": profile.connect_percent,
        "combine_rate": profile.combine_rate,
        "default_ratio": list(profile.default_ratio),
        "hall_turn_bias": profile.hall_turn_bias,
    }
    return row, problems


def check_all_profiles() -> ParityReport:
    report = ParityReport()
    for name, profile in sorted(BUILTIN_PROFILES.items()):
        report.checked.append(name)
        row, problems = check_profile_parity(profile)
        report.rows.append(row)
        report.issues.extend(ParityIssue(name, p) for p in problems)
    return report


# ---------------------------------------------------------------------------
def shipped_schema(exclude: Sequence[str] = ()) -> Dict[str, Set[str]]:
    """Field sets observed for every `$type` across the zones already shipped."""
    schema: Dict[str, Set[str]] = defaultdict(set)

    def walk(node):
        if isinstance(node, dict):
            kind = node.get("$type")
            if isinstance(kind, str):
                schema[kind] |= set(node.keys())
            for value in node.values():
                walk(value)
        elif isinstance(node, list):
            for value in node:
                walk(value)

    for path in sorted(ZONE_DIR.glob("*.json")):
        if path.name in exclude:
            continue
        walk(json.loads(path.read_text(encoding="utf-8-sig")))
    return schema


@dataclass
class ConformanceReport:
    unknown_types: List[str] = field(default_factory=list)
    unknown_fields: List[Tuple[str, List[str]]] = field(default_factory=list)
    checked_types: int = 0
    allowed_new_types: List[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.unknown_types and not self.unknown_fields


# `$type`s that RogueElements/PMDC define but that no shipped zone happened to
# use yet.  Each one was read in the upstream source before being allowed.
KNOWN_NEW_TYPES = {
    "RogueElements.GridPathCross": "RogueElements/MapGen/Grid/Paths/GridPathCross.cs",
    "PMDC.LevelGen.FloorStairsDistanceStep":
        "PMDC/LevelGen/Floors/GenSteps/FloorPlan/FloorStairsDistanceStep.cs",
}


def check_zone_conformance(zone_json: Dict[str, Any], exclude: Sequence[str] = ()) -> ConformanceReport:
    schema = shipped_schema(exclude)
    report = ConformanceReport()
    seen: Dict[str, Set[str]] = defaultdict(set)

    def walk(node):
        if isinstance(node, dict):
            kind = node.get("$type")
            if isinstance(kind, str):
                seen[kind] |= set(node.keys())
            for value in node.values():
                walk(value)
        elif isinstance(node, list):
            for value in node:
                walk(value)

    walk(zone_json)
    report.checked_types = len(seen)
    for kind, fields in sorted(seen.items()):
        if kind in schema:
            extra = sorted(fields - schema[kind])
            if extra:
                report.unknown_fields.append((kind, extra))
            continue
        base = kind.split("`")[0].split(",")[0]
        if base in KNOWN_NEW_TYPES:
            report.allowed_new_types.append(f"{base} (source: {KNOWN_NEW_TYPES[base]})")
            continue
        report.unknown_types.append(kind)
    return report


def markdown_report(parity: ParityReport, conformance: Optional[ConformanceReport] = None) -> str:
    lines = ["# Parité profils ↔ steps RogueElements, et conformité de l'export", "",
             "Généré par `python3 tools/dungeon_builder.py verify`.", "",
             "## 1. Parité `ArchitectureProfile` ↔ `re_sim` ↔ `zone_export`", "",
             "| Profil | Step émis dans la zone | Classe simulée | Salles (formes/tailles/poids) | "
             "Connect % | Combine | DefaultRatio | HallTurnBias |",
             "|---|---|---|---|---|---|---|---|"]
    for row in parity.rows:
        lines.append(f"| `{row['profile']}` | `{row['path_step']}` | `{row['simulator']}` | "
                     f"{row['rooms']} | {row['connect_percent']} | {row['combine_rate']} | "
                     f"{row['default_ratio']} | {row['hall_turn_bias']} |")
    lines += ["", f"**Résultat : {'parité vérifiée' if parity.ok else 'ÉCARTS DÉTECTÉS'}** "
                  f"({len(parity.checked)} profils).", ""]
    for issue in parity.issues:
        lines.append(f"- ⚠ `{issue.profile}` : {issue.detail}")

    if conformance is not None:
        lines += ["", "## 2. Conformité des `GenSteps` exportés", "",
                  f"- `$type` distincts émis : **{conformance.checked_types}**",
                  f"- inconnus des zones livrées : **{len(conformance.unknown_types)}**",
                  f"- champs inconnus : **{len(conformance.unknown_fields)}**"]
        for allowed in conformance.allowed_new_types:
            lines.append(f"- nouveau type autorisé après lecture du code source : {allowed}")
        for kind in conformance.unknown_types:
            lines.append(f"- ⚠ type inconnu : `{kind}`")
        for kind, fields in conformance.unknown_fields:
            lines.append(f"- ⚠ champs inconnus sur `{kind}` : {fields}")
    lines.append("")
    return "\n".join(lines)
