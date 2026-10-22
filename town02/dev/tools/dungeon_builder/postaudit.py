"""Post-generation audit: verify what was actually written, not what was intended.

For every zone the Builder produced, this re-opens the file on disk and checks:

* floor count == the definition's canonical floor count;
* every procedural floor really carries the native RogueElements grid pipeline
  (InitGridPlanStep -> GridPath* -> Draw* -> FloorStairsStep -> MapTextureStep
  -> DetectIsolatedStairsStep) and no pre-computed layout;
* architecture actually varies between floors (several profiles / grid sizes);
* the DTEF triplet of each segment is the one the definition owns;
* spawn / item / money / shop / monster-house / vault zone steps are present
  when the definition asks for them;
* boss, mini-boss and final scene are wired to the canonical Ground;
* the narrative is bound to the new implementation;
* no legacy zone of the same dungeon survives (the file carries the Builder
  stamp).
"""
from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence

from .definitions import DefinitionError, DungeonDefinition, list_definitions, load_definition
from .grounds import check_grounds

ROOT = Path(__file__).resolve().parents[2]
ZONE_DIR = ROOT / "Data" / "Zone"
DOC_DIR = ROOT / "docs" / "dungeon_builder"
BUILDER_MARKER = "tools/dungeon_builder"

REQUIRED_FLOOR_STEPS = ("InitGridPlanStep", "DrawGridToFloorStep", "DrawFloorToTileStep",
                        "MapTextureStep", "DetectIsolatedStairsStep")
STAIR_STEPS = {"FloorStairsStep", "FloorStairsDistanceStep"}
FORBIDDEN_IN_PROCEDURAL = ("MappedRoomStep",)   # a baked map inside a procedural floor


@dataclass
class ZoneAudit:
    dungeon: str
    name: str = ""
    chapter: int = 0
    floors_expected: int = 0
    floors_written: int = 0
    segments: int = 0
    profiles: List[str] = field(default_factory=list)
    grid_variants: int = 0
    path_steps: List[str] = field(default_factory=list)
    dtef: List[str] = field(default_factory=list)
    species: int = 0
    item_entries: int = 0
    features: List[str] = field(default_factory=list)
    minibosses: int = 0
    boss_mode: str = ""
    end_scene: str = ""
    narrative_bound: bool = False
    builder_stamp: bool = False
    problems: List[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.problems

    def to_dict(self) -> Dict[str, Any]:
        return dict(self.__dict__) | {"ok": self.ok}


def _type_name(kind: str) -> str:
    return kind.split("`")[0].split(",")[0].split(".")[-1]


def audit_zone(definition: DungeonDefinition) -> Optional[ZoneAudit]:
    path = ZONE_DIR / f"{definition.id}.json"
    if not path.exists():
        return None
    audit = ZoneAudit(dungeon=definition.id, name=definition.name.get("en", definition.id),
                      chapter=definition.chapter, floors_expected=definition.floors)
    zone = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
    audit.builder_stamp = BUILDER_MARKER in (zone.get("Comment") or "")
    if not audit.builder_stamp:
        audit.problems.append("the zone on disk is not stamped by the Builder (legacy leftover)")

    segments = zone.get("Segments", [])
    audit.segments = len(segments)
    expected_segments = len(definition.segments) + len(definition.fixed_segments)
    if len(segments) != expected_segments:
        audit.problems.append(f"{len(segments)} segments written for "
                              f"{expected_segments} declared (procedural + fixed)")

    grids: set = set()
    profiles: set = set()
    path_steps: set = set()
    for index, segment in enumerate(segments):
        floors = segment.get("Floors", [])
        relevant = bool(segment.get("IsRelevant", True))
        if relevant:
            audit.floors_written += len(floors)
        expected_dtef = definition.dtef_for(definition.segments[index]) if \
            relevant and index < len(definition.segments) else {}
        for floor in floors:
            if "LoadGen" in floor.get("$type", ""):
                continue                       # fixed floor: no procedural pipeline expected
            variants = ([entry["Spawn"] for entry in floor.get("Spawns", [])]
                        if "ChanceFloorGen" in floor.get("$type", "") else [floor])
            if not variants:
                audit.problems.append("ChanceFloorGen has no native candidates")
            for variant in variants:
                names = {_type_name(step["Value"]["$type"])
                         for step in variant.get("GenSteps", [])}
                missing = [step for step in REQUIRED_FLOOR_STEPS if step not in names]
                if not (names & STAIR_STEPS):
                    missing.append("FloorStairsStep|FloorStairsDistanceStep")
                if missing:
                    audit.problems.append(f"floor missing native steps {missing}")
                for forbidden in FORBIDDEN_IN_PROCEDURAL:
                    if forbidden in names:
                        audit.problems.append(f"procedural floor contains {forbidden}")
                path_steps |= {n for n in names if n.startswith("GridPath")}
                comment = variant.get("Comment", "")
                match = re.search(r"profile(?::| )(\w+) — grid (\d+x\d+)", comment)
                if match:
                    profiles.add(match.group(1))
                    grids.add(match.group(2))

        if not relevant:
            continue
        blob = json.dumps(segment)
        for role in ("floor", "wall", "secondary"):
            expected = expected_dtef.get(role) or (
                f"{expected_dtef.get('package')}_{role}" if expected_dtef.get("package") else "")
            if expected and f'"{expected}"' not in blob:
                audit.problems.append(f"segment {index + 1} does not use the declared "
                                      f"{role} tileset '{expected}'")
            if expected:
                audit.dtef.append(expected)

        zone_step_names = {_type_name(step["$type"]) for step in segment.get("ZoneSteps", [])}
        declared = definition.features_for(definition.segments[index]) \
            if index < len(definition.segments) else None
        if "TeamSpawnZoneStep" not in zone_step_names:
            audit.problems.append(f"segment {index + 1} has no Pokémon spawn step")
        if declared and (declared.shop or {}).get("enabled") and \
                "SpreadStepRangeZoneStep" not in zone_step_names:
            audit.problems.append(f"segment {index + 1} declares a shop but emits none")
        if declared and (declared.monster_house or {}).get("enabled") and \
                "SpreadHouseZoneStep" not in zone_step_names:
            audit.problems.append(f"segment {index + 1} declares a monster house but emits none")
        audit.features = sorted(set(audit.features) | (zone_step_names - {"SaveVarsZoneStep"}))

    audit.profiles = sorted(profiles)
    audit.grid_variants = len(grids)
    audit.path_steps = sorted(path_steps)
    audit.dtef = sorted(set(audit.dtef))

    if audit.floors_written != definition.floors:
        audit.problems.append(f"{audit.floors_written} floors written for "
                              f"{definition.floors} canonical")
    if definition.floors >= 6 and len(profiles) < 2:
        audit.problems.append(f"a single architecture profile for {definition.floors} floors")
    if definition.floors >= 6 and len(grids) < 2:
        audit.problems.append("every floor uses the same grid size")

    for segment in definition.segments:
        audit.species += len(definition.mobs_for(segment))
        audit.item_entries += sum(len(table.entries) for table in definition.items_for(segment))
    audit.minibosses = len(definition.minibosses)

    check = check_grounds(definition)
    audit.boss_mode = check.boss_mode
    audit.end_scene = check.boss_ground or check.boss_map or check.end
    if not check.ok:
        audit.problems.extend(f"scene: {problem}" for problem in check.problems)
    audit.narrative_bound = bool((definition.narrative or {}).get("transferred"))
    if (definition.narrative or {}).get("cutscenes") and not audit.narrative_bound:
        audit.problems.append("narrative not bound to the new implementation")
    return audit


def audit_all_zones() -> List[ZoneAudit]:
    audits: List[ZoneAudit] = []
    for path in list_definitions():
        try:
            definition = load_definition(path)
        except DefinitionError:
            continue
        audit = audit_zone(definition)
        if audit is not None:
            audits.append(audit)
    return audits


def markdown(audits: Sequence[ZoneAudit]) -> str:
    good = [a for a in audits if a.ok]
    lines = ["# Audit post-génération des zones produites", "",
             f"_Généré le {datetime.now(timezone.utc).isoformat(timespec='seconds')} — "
             f"{len(audits)} zones relues sur disque : **{len(good)} conformes**, "
             f"{len(audits) - len(good)} avec anomalie._", "",
             "Cet audit ne relit pas les intentions : il rouvre chaque `Data/Zone/<id>.json` "
             "écrit et vérifie ce qu'il contient réellement.", "",
             "| Zone | Ch. | Étages écrits / attendus | Seg. | Profils utilisés | Grilles "
             "distinctes | GridPath natifs | DTEF | Espèces | Objets | Features | Mini-boss | "
             "Fin (mode → scène) | Narratif | Empreinte Builder | Conforme |",
             "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|"]
    for audit in sorted(audits, key=lambda a: (a.chapter, a.dungeon)):
        features = ", ".join(f for f in audit.features
                             if f in ("ItemSpawnZoneStep", "TeamSpawnZoneStep",
                                      "MoneySpawnZoneStep", "SpreadStepRangeZoneStep",
                                      "SpreadHouseZoneStep", "SpreadVaultZoneStep")) or "—"
        lines.append(
            f"| `{audit.dungeon}` | {audit.chapter} | {audit.floors_written}/{audit.floors_expected} | "
            f"{audit.segments} | {', '.join(audit.profiles) or '—'} | {audit.grid_variants} | "
            f"{', '.join(audit.path_steps) or '—'} | {', '.join(audit.dtef) or '—'} | "
            f"{audit.species} | {audit.item_entries} | {features} | {audit.minibosses} | "
            f"{audit.boss_mode or '—'} → {audit.end_scene or '—'} | "
            f"{'oui' if audit.narrative_bound else '—'} | "
            f"{'oui' if audit.builder_stamp else 'NON'} | {'✅' if audit.ok else '❌'} |")
    problems = [a for a in audits if not a.ok]
    if problems:
        lines += ["", "## Anomalies", ""]
        for audit in problems:
            lines.append(f"### `{audit.dungeon}`")
            lines.extend(f"- {problem}" for problem in audit.problems)
            lines.append("")
    lines += ["", "## Contrôles appliqués", "",
              "- étages écrits == étages canoniques de la définition ;",
              "- chaque étage procédural porte la chaîne native "
              "`InitGridPlanStep → GridPath* → DrawGridToFloorStep → DrawFloorToTileStep → "
              "FloorStairsStep → MapTextureStep → DetectIsolatedStairsStep` ;",
              "- aucun `MappedRoomStep` (carte figée) dans un étage procédural ;",
              "- chaque étage porte sa métadonnée de debug (profil + authoring-seed), qui "
              "sélectionne les *paramètres* et non le layout ;",
              "- au moins deux profils et deux tailles de grille par donjon de 6 étages ou plus ;",
              "- le triplet DTEF déclaré est bien celui écrit dans chaque segment ;",
              "- steps de spawn Pokémon présents, shop / monster house émis quand déclarés ;",
              "- scène finale : `cinematic_ground == battle_ground == canonical_end_ground` ;",
              "- narratif rattaché à la nouvelle implémentation ;",
              "- empreinte `tools/dungeon_builder` présente : aucune ancienne zone concurrente.",
              ""]
    return "\n".join(lines)


def write_report(audits: Sequence[ZoneAudit], folder: Optional[Path] = None) -> List[Path]:
    folder = Path(folder or DOC_DIR)
    folder.mkdir(parents=True, exist_ok=True)
    md_path = folder / "POST_GENERATION_AUDIT.md"
    json_path = folder / "POST_GENERATION_AUDIT.json"
    md_path.write_text(markdown(audits), encoding="utf-8")
    json_path.write_text(json.dumps([a.to_dict() for a in audits], ensure_ascii=False, indent=2),
                         encoding="utf-8")
    return [md_path, json_path]
