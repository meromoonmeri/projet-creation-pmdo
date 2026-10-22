"""Narrative rebinding: keep cutscenes pointing at the rebuilt dungeons.

When the Builder replaces a legacy zone, its floor/segment layout changes.  Any
Lua cutscene that sends the player back into the dungeon
(`GAME:EnterDungeon('<id>', <segment>, <floor>, ...)`) therefore has to be
re-bound, otherwise the scene would drop the player into a segment that no
longer exists.

This module:

* scans `Data/Script` for `EnterDungeon` calls that target a dungeon owned by
  the Builder;
* validates every call against the current definition (segment index in range,
  floor index in range);
* rewrites the broken ones using an explicit, justified table — never a guess;
* reports whatever it cannot bind so it stays visible.
"""
from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[2]
SCRIPT_DIR = ROOT / "Data" / "Script"
DEF_DIR = ROOT / "DungeonDefs" / "canonical"

ENTER_RE = re.compile(r"EnterDungeon\(\s*'([a-z0-9_]+)'\s*,\s*(\d+)\s*,\s*(\d+)")

#: (script, old dungeon, old segment) -> (new dungeon, new segment, new floor, reason)
#: Each entry states *why* the scene now points there.
REBIND: Dict[Tuple[str, str, int], Tuple[str, int, int, str]] = {
    ("Data/Script/halcyon/ground/d09p03/init.lua", "mt_blaze", 2): (
        "mt_blaze_peak", 0, 0,
        "d09p03 est la scène du sommet (Sulfura) : la suite canonique est la Cime du Mont "
        "Cendré, désormais un donjon à part entière de 3 étages"),
    ("Data/Script/halcyon/ground/d10p03/init.lua", "frosty_forest", 2): (
        "frosty_grotto", 0, 0,
        "d10p03 est la scène de fin de la Forêt Givrée (Artikodin) : la suite canonique est la "
        "Grotte Givrée, désormais un donjon à part entière de 5 étages"),
    ("Data/Script/halcyon/ground/d10p02/init.lua", "frosty_forest", 1): (
        "frosty_forest", 0, 4,
        "d10p02 est le relais de mi-parcours : la Forêt Givrée reconstruite tient en un seul "
        "segment de 9 étages, le relais renvoie donc au même segment à l'étage 5"),
}


@dataclass
class Reference:
    path: str
    dungeon: str
    segment: int
    floor: int
    valid: bool = True
    rebound_to: Optional[Tuple[str, int, int]] = None
    reason: str = ""

    def to_dict(self) -> Dict[str, object]:
        return dict(self.__dict__)


@dataclass
class BindingReport:
    references: List[Reference] = field(default_factory=list)
    rewritten: List[str] = field(default_factory=list)
    unresolved: List[Reference] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.unresolved


def dungeon_shapes(def_dir: Optional[Path] = None) -> Dict[str, Tuple[int, int, List[List[int]]]]:
    shapes: Dict[str, Tuple[int, int, List[List[int]]]] = {}
    for path in sorted((def_dir or DEF_DIR).glob("*.json")):
        try:
            raw = json.loads(path.read_text(encoding="utf-8-sig"))
        except json.JSONDecodeError:
            continue
        shapes[raw["id"]] = (len(raw.get("segments", [])), int(raw.get("floors", 0)),
                             [segment["floors"] for segment in raw.get("segments", [])])
    return shapes


def scan(script_dir: Optional[Path] = None,
         shapes: Optional[Dict[str, Tuple[int, int, List[List[int]]]]] = None) -> BindingReport:
    shapes = shapes if shapes is not None else dungeon_shapes()
    report = BindingReport()
    for path in sorted((script_dir or SCRIPT_DIR).rglob("*.lua")):
        text = path.read_text(encoding="utf-8", errors="ignore")
        for match in ENTER_RE.finditer(text):
            dungeon, segment, floor = match.group(1), int(match.group(2)), int(match.group(3))
            if dungeon not in shapes:
                continue
            segments, total, ranges = shapes[dungeon]
            valid = segment < segments
            if valid and segment < len(ranges):
                length = ranges[segment][1] - ranges[segment][0] + 1
                valid = floor < length
            reference = Reference(str(path.relative_to(ROOT)), dungeon, segment, floor, valid)
            report.references.append(reference)
            if not valid:
                report.unresolved.append(reference)
    return report


def rebind(report: BindingReport, dry_run: bool = False,
           shapes: Optional[Dict[str, Tuple[int, int, List[List[int]]]]] = None) -> BindingReport:
    shapes = shapes if shapes is not None else dungeon_shapes()
    still_unresolved: List[Reference] = []
    for reference in report.unresolved:
        key = (reference.path, reference.dungeon, reference.segment)
        target = REBIND.get(key)
        if target is None:
            still_unresolved.append(reference)
            continue
        dungeon, segment, floor, reason = target
        segments, _, ranges = shapes.get(dungeon, (0, 0, []))
        if segment >= segments or (segment < len(ranges) and
                                   floor >= ranges[segment][1] - ranges[segment][0] + 1):
            reference.reason = f"rebinding target out of range: {dungeon} segment {segment}"
            still_unresolved.append(reference)
            continue
        path = ROOT / reference.path
        text = path.read_text(encoding="utf-8")
        old = re.compile(rf"EnterDungeon\(\s*'{reference.dungeon}'\s*,\s*{reference.segment}\s*,"
                         rf"\s*{reference.floor}")
        new_text, count = old.subn(f"EnterDungeon('{dungeon}', {segment}, {floor}", text)
        if count == 0:
            still_unresolved.append(reference)
            continue
        marker = (f"-- [dungeon_builder] scène re-raccordée au donjon reconstruit : "
                  f"{reference.dungeon} seg {reference.segment} -> {dungeon} seg {segment} "
                  f"étage {floor}. {reason}\n")
        if marker not in new_text:
            new_text = marker + new_text
        if not dry_run:
            path.write_text(new_text, encoding="utf-8")
        reference.rebound_to = (dungeon, segment, floor)
        reference.reason = reason
        report.rewritten.append(reference.path)
    report.unresolved = still_unresolved
    return report
