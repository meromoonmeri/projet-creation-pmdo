"""Takeover of legacy dungeon content.

Once a dungeon enters this Builder's scope, the previous implementation stops
being authoritative.  This module makes the replacement auditable instead of
destructive-by-surprise:

1. **scan** — list every legacy artefact attached to the dungeon: active zone,
   index entry, Grounds and `.rsmap` of its canonical scenes, ground/zone Lua
   scripts (active *and* archived), PMD Red cinematic IR, legacy generator
   scripts that mention it;
2. **classify** — `HARVEST` (data to reuse), `TRANSFER` (narrative content that
   must follow the dungeon), `REPLACE` (superseded by the new pipeline),
   `PROTECT` (out of scope, untouchable);
3. **plan** — write a manifest; deletion of `REPLACE` artefacts only happens
   with `--apply`, and only once the new zone exists and the dungeon is
   `READY_FOR_GENERATION`.

Nothing narrative is ever dropped: every cutscene found is recorded in the
definition's `narrative` block and re-attached to the new implementation.
"""
from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional, Sequence

from .definitions import DungeonDefinition
from .scenes import ACTIVE_GROUND, DungeonScenes, parse_inventory, scenes_for

ROOT = Path(__file__).resolve().parents[2]
ZONE_DIR = ROOT / "Data" / "Zone"
GROUND_DIR = ROOT / "Data" / "Ground"
MAP_DIR = ROOT / "Data" / "Map"
SCRIPT_GROUND = ROOT / "Data" / "Script" / "halcyon" / "ground"
SCRIPT_ZONE = ROOT / "Data" / "Script" / "halcyon" / "zone"
RESERVE = ROOT / "RESERVE"
RESERVE_SCRIPT_GROUND = RESERVE / "scripts_ground"
RESERVE_SCRIPT_ZONE = RESERVE / "scripts_zone"
RED_CINEMATICS = RESERVE / "red_cinematics"
DOC_DIR = ROOT / "docs" / "dungeon_builder"

HARVEST = "HARVEST"
TRANSFER = "TRANSFER"
REPLACE = "REPLACE"
REVIEW = "REVIEW"
PROTECT = "PROTECT"
CURRENT = "CURRENT"

#: marker written into the Comment of every zone produced by this Builder
BUILDER_MARKER = "tools/dungeon_builder"


@dataclass
class Artefact:
    kind: str                 # zone | ground | map | script_ground | script_zone | cinematic | tool
    path: str
    action: str               # HARVEST | TRANSFER | REPLACE | PROTECT
    reason: str = ""
    state: str = "active"     # active | archived

    def to_dict(self) -> Dict[str, str]:
        return dict(self.__dict__)


@dataclass
class TakeoverPlan:
    dungeon: str
    name: str = ""
    in_scope: bool = True
    artefacts: List[Artefact] = field(default_factory=list)
    narrative: Dict[str, List[str]] = field(default_factory=dict)
    notes: List[str] = field(default_factory=list)

    def by_action(self, action: str) -> List[Artefact]:
        return [a for a in self.artefacts if a.action == action]

    def to_dict(self) -> Dict[str, object]:
        return {
            "dungeon": self.dungeon,
            "name": self.name,
            "in_scope": self.in_scope,
            "narrative": self.narrative,
            "notes": self.notes,
            "artefacts": [a.to_dict() for a in self.artefacts],
        }


def _rel(path: Path) -> str:
    try:
        return str(path.relative_to(ROOT))
    except ValueError:
        return str(path)


def scene_names(definition: DungeonDefinition,
                inventory: Optional[Dict[str, DungeonScenes]] = None) -> List[str]:
    names: List[str] = []
    scenes = scenes_for(definition.name.get("en", definition.id), inventory)
    if scenes:
        for asset in [scenes.entrance, scenes.relay, *scenes.end]:
            if asset and asset.name:
                names.append(asset.name)
    for value in (definition.fixed_grounds or {}).values():
        if value:
            names.append(value)
    for key in ("ground", "map"):
        value = (definition.boss or {}).get(key)
        if value:
            names.append(value)
    midpoint = (definition.midpoint or {}).get("ground")
    if midpoint:
        names.append(midpoint)
    return sorted(set(names))


def scan(definition: DungeonDefinition, inventory: Optional[Dict[str, DungeonScenes]] = None,
         scope: Optional[Sequence[str]] = None) -> TakeoverPlan:
    """Inventory everything the legacy implementation owns for this dungeon."""
    inventory = inventory if inventory is not None else parse_inventory()
    plan = TakeoverPlan(dungeon=definition.id, name=definition.name.get("en", definition.id))
    plan.in_scope = scope is None or definition.id in set(scope)

    # --- legacy zone ------------------------------------------------------
    zone_path = ZONE_DIR / f"{definition.id}.json"
    if zone_path.exists():
        try:
            built_here = BUILDER_MARKER in json.loads(
                zone_path.read_text(encoding="utf-8-sig"))["Object"].get("Comment", "")
        except (json.JSONDecodeError, KeyError, OSError):
            built_here = False
        if built_here:
            plan.artefacts.append(Artefact(
                "zone", _rel(zone_path), CURRENT,
                "already produced by this Builder: it is the current canonical implementation"))
        elif plan.in_scope:
            plan.artefacts.append(Artefact(
                "zone", _rel(zone_path), REPLACE,
                "legacy zone of a dungeon now owned by the Builder: regenerated from "
                f"DungeonDefs/canonical/{definition.path.name if definition.path else definition.id}"))
        else:
            plan.artefacts.append(Artefact("zone", _rel(zone_path), PROTECT,
                                           "out of this Builder's scope"))

    # --- canonical scenes: Grounds / maps ---------------------------------
    scenes = scenes_for(definition.name.get("en", definition.id), inventory)
    for name in scene_names(definition, inventory):
        ground = GROUND_DIR / f"{name}.rsground"
        rsmap = MAP_DIR / f"{name}.rsmap"
        if ground.exists():
            plan.artefacts.append(Artefact(
                "ground", _rel(ground), HARVEST,
                "canonical scene kept as-is: geometry, collisions, markers and objects are the "
                "source of truth for cutscene + battle"))
        if rsmap.exists():
            plan.artefacts.append(Artefact(
                "map", _rel(rsmap), HARVEST,
                "canonical scene available as a map: becomes the Ground of this very scene"))
        if not ground.exists() and not rsmap.exists():
            for folder in sorted(RESERVE.glob("*")):
                for suffix in (".rsground", ".rsmap"):
                    archived = folder / f"{name}{suffix}"
                    if archived.exists():
                        plan.artefacts.append(Artefact(
                            "ground" if suffix == ".rsground" else "map", _rel(archived), TRANSFER,
                            "archived canonical scene to restore into the new implementation",
                            state="archived"))

    # --- narrative: ground scripts, zone scripts, PMD Red cinematics ------
    cutscenes: List[str] = []
    for name in scene_names(definition, inventory):
        active = SCRIPT_GROUND / name
        if active.is_dir():
            plan.artefacts.append(Artefact("script_ground", _rel(active), TRANSFER,
                                           f"cutscene of scene '{name}' must follow the dungeon"))
            cutscenes.append(_rel(active))
        archived = RESERVE_SCRIPT_GROUND / name
        if archived.is_dir():
            plan.artefacts.append(Artefact("script_ground", _rel(archived), TRANSFER,
                                           f"archived cutscene of scene '{name}' to restore",
                                           state="archived"))
            cutscenes.append(_rel(archived))

    zone_script = SCRIPT_ZONE / definition.id
    if zone_script.is_dir():
        plan.artefacts.append(Artefact(
            "script_zone", _rel(zone_script), TRANSFER,
            "zone script (floor events, boss trigger) rebound to the regenerated zone"))
        cutscenes.append(_rel(zone_script))
    archived_zone_script = RESERVE_SCRIPT_ZONE / definition.id
    if archived_zone_script.is_dir():
        plan.artefacts.append(Artefact("script_zone", _rel(archived_zone_script), TRANSFER,
                                       "archived zone script to restore", state="archived"))

    cinematics: List[str] = []
    if scenes and scenes.code:
        for path in sorted(RED_CINEMATICS.glob(f"{scenes.code.lower()}p*.cif.json")):
            plan.artefacts.append(Artefact(
                "cinematic", _rel(path), TRANSFER,
                f"canonical PMD Red cutscene of {scenes.code}: audio, camera, dialogue and battle "
                "trigger to replay on the same Ground", state="archived"))
            cinematics.append(_rel(path))

    # --- legacy tooling ---------------------------------------------------
    # Only tools that *write* this dungeon's zone are relevant, and they are
    # never auto-deleted: a human decides, because many of them also carry
    # narrative or audit logic that must be preserved.
    for tool in sorted((ROOT / "tools").glob("*.py")):
        if tool.name.startswith("build_canonical_definitions") or "dungeon_builder" in tool.name:
            continue
        try:
            text = tool.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        if not re.search(rf"[\"']{re.escape(definition.id)}[\"']", text):
            continue
        writes_zone = ("Data/Zone" in text or "Data\\Zone" in text) and (
            "write_text" in text or "json.dump" in text or "open(" in text)
        if writes_zone:
            plan.artefacts.append(Artefact(
                "tool", _rel(tool), REVIEW if plan.in_scope else PROTECT,
                "legacy generator that writes this dungeon's zone: superseded by the Builder, "
                "to retire manually once the rebuild is validated"))

    plan.narrative = {"cutscenes": sorted(set(cutscenes)), "red_cinematics": cinematics}
    if not cutscenes and not cinematics:
        plan.notes.append("no narrative content found for this dungeon")
    return plan


def can_apply(plan: TakeoverPlan, definition: DungeonDefinition, readiness: str,
              zone_exists: bool) -> List[str]:
    """Deletion pre-conditions.  Anything returned here blocks `--apply`."""
    blockers: List[str] = []
    if not plan.in_scope:
        blockers.append("dungeon is out of this Builder's scope")
    if readiness != "READY_FOR_GENERATION":
        blockers.append(f"readiness is {readiness}, not READY_FOR_GENERATION")
    if not zone_exists:
        blockers.append("the new zone has not been generated yet")
    if plan.narrative["cutscenes"] or plan.narrative["red_cinematics"]:
        if not (definition.narrative or {}).get("transferred"):
            blockers.append("narrative content is not marked as transferred in the definition "
                            "(narrative.transferred)")
    return blockers


def apply_plan(plan: TakeoverPlan, dry_run: bool = True) -> List[str]:
    """Delete the REPLACE artefacts (never HARVEST/TRANSFER/PROTECT)."""
    removed: List[str] = []
    for artefact in plan.by_action(REPLACE):
        path = ROOT / artefact.path
        if not path.exists():
            continue
        removed.append(artefact.path)
        if not dry_run:
            if path.is_dir():
                for child in sorted(path.rglob("*"), reverse=True):
                    child.unlink() if child.is_file() else child.rmdir()
                path.rmdir()
            else:
                path.unlink()
    return removed


def markdown(plans: Sequence[TakeoverPlan]) -> str:
    lines = ["# Plan de reprise des donjons (takeover)", "",
             f"_Généré le {datetime.now(timezone.utc).isoformat(timespec='seconds')} — "
             f"{len(plans)} donjons analysés._", "",
             "`HARVEST` = donnée canonique réutilisée telle quelle · `TRANSFER` = contenu "
             "narratif/scène qui suit le donjon dans le nouveau pipeline · `REPLACE` = ancienne "
             "implémentation supprimée après reconstruction · `PROTECT` = hors périmètre, "
             "intouchable.", "",
             "| Donjon | HARVEST | TRANSFER | REPLACE | PROTECT | Cinématiques | Notes |",
             "|---|---|---|---|---|---|---|"]
    for plan in plans:
        lines.append(
            f"| `{plan.dungeon}` | {len(plan.by_action(HARVEST))} | {len(plan.by_action(TRANSFER))} | "
            f"{len(plan.by_action(REPLACE))} | {len(plan.by_action(PROTECT))} | "
            f"{len(plan.narrative.get('red_cinematics', []))} | {'; '.join(plan.notes) or '—'} |")
    lines.append("")
    for plan in plans:
        if not plan.artefacts:
            continue
        lines.append(f"## `{plan.dungeon}` — {plan.name}")
        lines.append("")
        for artefact in plan.artefacts:
            state = "" if artefact.state == "active" else " *(archivé)*"
            lines.append(f"- **{artefact.action}** `{artefact.path}`{state} — {artefact.reason}")
        lines.append("")
    return "\n".join(lines)


def write_report(plans: Sequence[TakeoverPlan], folder: Optional[Path] = None) -> List[Path]:
    folder = Path(folder or DOC_DIR)
    folder.mkdir(parents=True, exist_ok=True)
    md_path = folder / "TAKEOVER_PLAN.md"
    json_path = folder / "TAKEOVER_PLAN.json"
    md_path.write_text(markdown(plans), encoding="utf-8")
    json_path.write_text(json.dumps([plan.to_dict() for plan in plans], ensure_ascii=False,
                                    indent=2), encoding="utf-8")
    return [md_path, json_path]
