"""Fixed Grounds (entrance / midpoint / end) and boss-scene arbitration.

Hard rules enforced here — a future dungeon cannot break them by accident:

* `entrance`, `mid` and the end scene are FIXED Grounds, never procedural;
* **if the dungeon owns a usable canonical end Ground, the final battle happens
  on it** (`boss.mode = "canonical_ground"`).  Declaring `arena_rsmap` while
  such a Ground exists is a hard error, not a warning;
* `arena_rsmap` is only legal when no canonical end Ground can be found; the
  `.rsmap` must already exist in `Data/Map` before it is converted to a Ground.
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Sequence

from .scenes import ACTIVE_GROUND, NONE, readiness, scenes_for

ROOT = Path(__file__).resolve().parents[2]
GROUND_DIR = ROOT / "Data" / "Ground"
MAP_DIR = ROOT / "Data" / "Map"

CANONICAL_GROUND = "canonical_ground"
ARENA_RSMAP = "arena_rsmap"
BOSS_MODES = (CANONICAL_GROUND, ARENA_RSMAP)

#: suffixes that identify a "end of dungeon" Ground in this project's naming
END_SUFFIXES = ("clearing", "end", "fond", "fin", "summit", "sommet", "depths", "profondeurs",
                "bottom", "peak", "final", "core", "coeur", "altar", "autel", "sanctuaire",
                "den", "crucible", "guardian", "boss")


@dataclass
class GroundCheck:
    entrance: str = ""
    cinematic_ground: str = ""
    battle_ground: str = ""
    scene_state: str = ""
    mid: str = ""
    end: str = ""
    boss_mode: str = ""
    boss_ground: str = ""
    boss_map: str = ""
    canonical_end_candidates: List[str] = field(default_factory=list)
    ok: bool = True
    problems: List[str] = field(default_factory=list)
    notes: List[str] = field(default_factory=list)

    def to_dict(self) -> Dict[str, object]:
        return dict(self.__dict__)


def ground_exists(name: str, ground_dir: Optional[Path] = None) -> bool:
    return bool(name) and ((ground_dir or GROUND_DIR) / f"{name}.rsground").exists()


def map_exists(name: str, map_dir: Optional[Path] = None) -> bool:
    return bool(name) and ((map_dir or MAP_DIR) / f"{name}.rsmap").exists()


def find_canonical_end_grounds(definition, ground_dir: Optional[Path] = None) -> List[str]:
    """Scan `Data/Ground` for an existing end-of-dungeon scene of this dungeon.

    Matching uses the dungeon id plus any `aliases` declared in the definition
    (e.g. `gloomy_forest` also answers to `sinister_woods`), combined with the
    project's end-scene suffixes.
    """
    ground_dir = ground_dir or GROUND_DIR
    names = {definition.id}
    names |= {str(a) for a in getattr(definition, "aliases", []) or []}
    found: List[str] = []
    for path in sorted(ground_dir.glob("*.rsground")):
        stem = path.stem
        for base in names:
            if not stem.startswith(base):
                continue
            suffix = stem[len(base):].strip("_")
            if suffix and any(re.fullmatch(rf"{s}\d*", suffix) for s in END_SUFFIXES):
                found.append(stem)
                break
    return found


def check_grounds(definition, ground_dir: Optional[Path] = None,
                  map_dir: Optional[Path] = None) -> GroundCheck:
    grounds = definition.fixed_grounds or {}
    check = GroundCheck(entrance=grounds.get("entrance", ""), mid=grounds.get("mid", ""),
                        end=grounds.get("end", ""))

    for role in ("entrance", "mid", "end"):
        name = grounds.get(role, "")
        if not name:
            check.notes.append(f"no fixed '{role}' Ground declared")
            continue
        if not ground_exists(name, ground_dir):
            check.problems.append(f"{role} Ground '{name}.rsground' missing from Data/Ground")

    midpoint = definition.midpoint or {}
    if midpoint:
        template = midpoint.get("template", "")
        if template and not ground_exists(template, ground_dir):
            check.problems.append(f"midpoint template Ground '{template}' missing")
        if not midpoint.get("retexture"):
            check.problems.append("midpoint must declare 'retexture' (biome tileset of this dungeon)")
        if not grounds.get("mid"):
            check.notes.append(
                f"midpoint Ground still to be produced: template '{midpoint.get('template', '?')}' "
                f"retextured with '{midpoint.get('retexture', '?')}' "
                f"(floor {midpoint.get('floor', '?')}) — never generated procedurally")
        for feature in ("checkpoint", "heal", "save", "rest"):
            if not midpoint.get(feature, False):
                check.notes.append(f"midpoint does not provide '{feature}'")

    candidates = find_canonical_end_grounds(definition, ground_dir)

    # the PMD Red scene inventory is authoritative: a scene that exists there,
    # even archived, forbids a separate arena
    scene_set = scenes_for(definition.name.get("en", definition.id))
    scene_end = scene_set.canonical_end if scene_set else None
    scene_state, scene_reason = readiness(scene_end)
    check.scene_state = scene_state
    if scene_end and scene_end.exists:
        check.cinematic_ground = check.battle_ground = scene_end.name
        if scene_end.name not in candidates:
            candidates.append(scene_end.name)
    declared = definition.scenes or {}
    if declared:
        for role in ("cinematic_ground", "battle_ground"):
            value = declared.get(role, "")
            if value and declared.get("canonical_end_ground") and \
                    value != declared["canonical_end_ground"]:
                check.problems.append(
                    f"scenes.{role} must equal scenes.canonical_end_ground "
                    "(one single space for cutscene + battle)")
        if declared.get("cinematic_ground"):
            check.cinematic_ground = declared["cinematic_ground"]
        if declared.get("battle_ground"):
            check.battle_ground = declared["battle_ground"]
    check.canonical_end_candidates = candidates

    boss = definition.boss or {}
    check.boss_mode = boss.get("mode", "")
    if not boss:
        check.notes.append("no boss scene declared")
        check.ok = not check.problems
        return check

    if check.boss_mode not in BOSS_MODES:
        check.problems.append(
            f"boss.mode must be one of {BOSS_MODES}, got '{check.boss_mode}'")
        check.ok = False
        return check

    if check.boss_mode == CANONICAL_GROUND:
        ground = boss.get("ground") or grounds.get("end", "")
        check.boss_ground = ground
        if not ground:
            check.problems.append("boss.mode=canonical_ground requires 'ground' "
                                  "(or fixed_grounds.end)")
        elif not ground_exists(ground, ground_dir):
            if boss.get("pending_integration"):
                check.problems.append(
                    f"REQUIRES_INTEGRATION: canonical scene '{ground}' "
                    f"({boss.get('source_asset', 'archived')}) must be restored/converted as the "
                    "cinematic + battle Ground — no separate arena")
            else:
                check.problems.append(f"boss Ground '{ground}' declared canonical but missing")
        else:
            check.notes.append(f"final battle stays on the canonical end Ground '{ground}' "
                               "(no separate arena created)")
        if candidates and ground and ground not in candidates:
            check.notes.append(f"declared boss Ground '{ground}' is not among the detected "
                               f"canonical end scenes {candidates}")
        if boss.get("map"):
            check.boss_map = boss["map"]
            if not map_exists(check.boss_map, map_dir):
                check.problems.append(
                    f"boss scene map '{check.boss_map}.rsmap' declared but missing")
            else:
                check.notes.append(
                    f"scene source of truth: {check.boss_map}.rsmap matches the end Ground")
    else:  # ARENA_RSMAP
        if scene_end and scene_end.exists:
            check.problems.append(
                "boss.mode=arena_rsmap is forbidden: the PMD Red scene inventory lists "
                f"'{scene_end.name}' ({scene_end.state}) for this dungeon — {scene_reason}")
        if candidates:
            check.problems.append(
                "boss.mode=arena_rsmap is forbidden: this dungeon already owns a canonical end "
                f"Ground ({', '.join(candidates)}). Fight there with mode=canonical_ground.")
        arena = boss.get("map", "")
        check.boss_map = arena
        if not arena:
            check.problems.append("boss.mode=arena_rsmap requires a 'map' (.rsmap arena)")
        elif not map_exists(arena, map_dir):
            check.problems.append(
                f"dedicated arena '{arena}.rsmap' must exist in Data/Map before conversion")
        else:
            check.notes.append(f"dedicated arena scene: {arena}.rsmap (source of truth) "
                               "→ to be converted into a boss Ground")
        ground = boss.get("ground", "")
        check.boss_ground = ground
        if ground and not ground_exists(ground, ground_dir):
            check.notes.append(f"arena Ground '{ground}' not converted yet")

    for miniboss in definition.minibosses or []:
        map_id = miniboss.get("map", "")
        if map_id and not map_exists(map_id, map_dir):
            check.problems.append(f"miniboss arena '{map_id}.rsmap' missing from Data/Map")

    check.ok = not check.problems
    return check
