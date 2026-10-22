"""Global audit of every dungeon definition (step 6 gate).

Loads all `DungeonDefs/canonical/*.json` and answers, per dungeon, one question:
*could the Dungeon Builder generate this dungeon today, end to end?*

Nothing is guessed: whatever cannot be resolved is reported as an explicit
blocker, and the dungeon is marked FAIL.
"""
from __future__ import annotations

import json
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence, Tuple

from .definitions import (DefinitionError, DungeonDefinition, list_definitions, load_definition)
from .dtef import DtefError, check_tileset_uniqueness, resolve as resolve_dtef
from .grounds import check_grounds
from .profiles import customize

ROOT = Path(__file__).resolve().parents[2]
ZONE_DIR = ROOT / "Data" / "Zone"
ITEM_DIR = ROOT / "Data" / "Item"
STATUS_DIR = ROOT / "Data" / "MapStatus"
DOC_DIR = ROOT / "docs" / "dungeon_builder"


READY = "READY_FOR_GENERATION"
REQUIRES_INTEGRATION = "REQUIRES_INTEGRATION"
BLOCKED_TILESET = "BLOCKED_MISSING_TILESET"
BLOCKED_ASSET = "BLOCKED_MISSING_ASSET"
BLOCKED_SOURCE = "BLOCKED_MISSING_SOURCE"
BLOCKED_DEFINITION = "BLOCKED_INVALID_DEFINITION"
TAKEOVER_PENDING = "TAKEOVER_PENDING"
OWNED_BY_OTHER_AGENT = "OWNED_BY_OTHER_AGENT"   # out of scope only
SAFE_TO_BUILD = "SAFE_TO_BUILD"


@dataclass
class DungeonAudit:
    file: str
    dungeon: str = ""
    name: str = ""
    chapter: int = 0
    floors: int = 0
    segments: int = 0
    direction: str = ""
    dtef: str = ""
    profiles: List[str] = field(default_factory=list)
    species: int = 0
    item_entries: int = 0
    boss_mode: str = ""
    end_scene: str = ""
    midpoint: str = ""
    source: str = ""
    biome: str = ""
    cinematic_ground: str = ""
    cutscenes: int = 0
    red_cinematics: int = 0
    narrative_transferred: bool = False
    legacy_zone: str = ""
    battle_ground: str = ""
    canonical_end_ground: str = ""
    arena_rsmap: str = ""
    scene_state: str = ""
    ownership: str = SAFE_TO_BUILD
    readiness: str = READY
    blockers: List[str] = field(default_factory=list)
    notes: List[str] = field(default_factory=list)

    @property
    def status(self) -> str:
        return "PASS" if not self.blockers else "FAIL"

    def classify(self) -> None:
        """Turn the blocker list into one actionable readiness status."""
        text = " ".join(self.blockers)
        if not self.blockers:
            self.readiness = READY
        elif "REQUIRES_INTEGRATION" in text:
            self.readiness = REQUIRES_INTEGRATION
        elif "MISSING_TILESET" in text:
            self.readiness = BLOCKED_TILESET
        elif "MISSING_ASSET" in text:
            self.readiness = BLOCKED_ASSET
        elif "MISSING_SOURCE" in text or "MISSING_ITEM" in text:
            self.readiness = BLOCKED_SOURCE
        elif "TAKEOVER_PENDING" in text:
            self.readiness = TAKEOVER_PENDING
        elif "OUT_OF_SCOPE" in text:
            self.readiness = self.ownership
        else:
            self.readiness = BLOCKED_DEFINITION
        if "TAKEOVER_PENDING" in text:
            self.ownership = TAKEOVER_PENDING
            self.readiness = TAKEOVER_PENDING


def _known_items() -> set:
    # Mod-local items (Data/Item/*.json) shadow the base game items and are
    # authoritative. Plus every item shipped by the base game (audinowho/
    # DumpAsset, mirrored in tools/dungeon_builder/data/base_items.txt) is
    # available at runtime — the audit must not flag a base item as missing
    # just because we don't ship a mod-local override for it. This is the
    # same source of truth red_story_batch uses to build the item table.
    known = {path.stem for path in ITEM_DIR.glob("*.json")}
    base_items_file = Path(__file__).resolve().parent / "data" / "base_items.txt"
    if base_items_file.is_file():
        for line in base_items_file.read_text().splitlines():
            s = line.strip()
            if s and not s.startswith("#"):
                known.add(s)
    return known


def _known_statuses() -> set:
    return {path.stem for path in STATUS_DIR.glob("*.json")}


def audit_definition(path: Path, known_items: set, known_statuses: set,
                     zone_names: set) -> Tuple[DungeonAudit, Optional[DungeonDefinition]]:
    audit = DungeonAudit(file=path.name)
    try:
        definition = load_definition(path)
    except DefinitionError as exc:
        audit.blockers.append(f"BLOCKED/INVALID_DEFINITION: {exc}")
        try:    # keep the dungeon identity so the report stays readable
            raw = json.loads(path.read_text(encoding="utf-8-sig"))
            audit.dungeon = str(raw.get("id", path.stem))
            audit.name = (raw.get("name") or {}).get("en", audit.dungeon)
            audit.chapter = int(raw.get("chapter", 0) or 0)
            audit.floors = int(raw.get("floors", 0) or 0)
            audit.segments = len(raw.get("segments", []))
            audit.direction = str((raw.get("variation") or {}).get("direction", ""))
            audit.blockers.extend(str(b) for b in raw.get("blocked", []))
        except (json.JSONDecodeError, OSError, ValueError):
            audit.dungeon = path.stem
        audit.classify()
        return audit, None

    audit.dungeon = definition.id
    audit.name = definition.name.get("en", definition.id)
    audit.chapter = definition.chapter
    audit.floors = definition.floors
    audit.segments = len(definition.segments)
    audit.direction = str(definition.variation.get("direction", ""))
    audit.source = definition.source.split(" —")[0][:90]
    audit.biome = definition.biome
    declared = definition.scenes or {}
    audit.canonical_end_ground = declared.get("canonical_end_ground", "")
    audit.cinematic_ground = declared.get("cinematic_ground", "")
    audit.battle_ground = declared.get("battle_ground", "")
    audit.scene_state = declared.get("state", "")
    if (definition.boss or {}).get("mode") == "arena_rsmap":
        audit.arena_rsmap = (definition.boss or {}).get("map", "")
    narrative = definition.narrative or {}
    audit.cutscenes = len(narrative.get("cutscenes", []))
    audit.red_cinematics = len(narrative.get("red_cinematics", []))
    audit.narrative_transferred = bool(narrative.get("transferred"))
    audit.legacy_zone = (getattr(definition, "takeover", {}) or {}).get("legacy_zone", "") \
        if hasattr(definition, "takeover") else ""

    # blockers recorded by the extraction step itself
    audit.blockers.extend(definition.blocked)

    if not definition.source:
        audit.blockers.append("BLOCKED/MISSING_SOURCE: no canonical source recorded")
    if definition.chapter < 6 or definition.chapter > 32:
        audit.blockers.append(f"BLOCKED/OUT_OF_SCOPE: chapter {definition.chapter} outside Ch.6-32")
    if audit.direction not in ("fond", "sommet"):
        audit.blockers.append("BLOCKED/MISSING_SOURCE: variation.direction must be 'fond' or 'sommet'")

    # --- floors / segments (parse already refuses gaps; recheck defensively)
    covered: List[int] = []
    for segment in definition.segments:
        covered.extend(segment.floor_numbers)
    if sorted(covered) != list(range(1, definition.floors + 1)):
        audit.blockers.append("BLOCKED/INVALID_DEFINITION: segments do not cover 1..floors exactly")

    # --- tilesets
    for segment in definition.segments:
        spec = definition.dtef_for(segment)
        try:
            package = resolve_dtef(spec)
            audit.dtef = package.name or package.floor
        except DtefError as exc:
            audit.blockers.append(f"BLOCKED/MISSING_TILESET: {exc}")
            break

    # --- profiles
    names: List[str] = []
    for segment in definition.segments:
        choices = definition.profiles_for(segment)
        if not choices:
            audit.blockers.append(f"BLOCKED/INVALID_DEFINITION: segment '{segment.name}' has no profile")
            continue
        for choice in choices:
            try:
                customize(choice.name, choice.overrides)
            except KeyError as exc:
                audit.blockers.append(f"BLOCKED/INVALID_DEFINITION: {exc}")
            if choice.name not in names:
                names.append(choice.name)
    audit.profiles = names
    if len(names) < 2 and definition.floors > 3:
        audit.notes.append("a single architecture profile for the whole dungeon")

    # --- spawns / items
    for segment in definition.segments:
        mobs = definition.mobs_for(segment)
        audit.species += len(mobs)
        if not mobs:
            audit.blockers.append(f"BLOCKED/MISSING_SOURCE: segment '{segment.name}' has no species")
        for mob in mobs:
            if mob.level[0] < 1:
                audit.blockers.append(f"BLOCKED/INVALID_DEFINITION: {mob.species} has level < 1")
        tables = definition.items_for(segment)
        entries = sum(len(table.entries) for table in tables)
        audit.item_entries += entries
        for table in tables:
            unknown = [entry.item for entry in table.entries if entry.item not in known_items]
            if unknown:
                audit.blockers.append(
                    f"BLOCKED/MISSING_ITEM: {segment.name}: {', '.join(sorted(set(unknown))[:5])}")
    if audit.item_entries == 0:
        audit.notes.append("no floor items (canonical: money only)")

    # --- features
    for segment in definition.segments:
        features = definition.features_for(segment)
        shop = features.shop or {}
        if shop.get("enabled"):
            if not shop.get("items"):
                audit.blockers.append("BLOCKED/INVALID_DEFINITION: shop enabled without stock")
            unknown = [entry["item"] for entry in shop.get("items", [])
                       if entry.get("item") not in known_items]
            if unknown:
                audit.blockers.append(f"BLOCKED/MISSING_ITEM: shop stock {sorted(set(unknown))[:5]}")
            floors = shop.get("floors")
            if floors and (floors[0] < 1 or floors[1] > definition.floors):
                audit.blockers.append("BLOCKED/INVALID_DEFINITION: shop floors outside the dungeon")
        house = features.monster_house or {}
        if house.get("enabled"):
            floors = house.get("floors")
            if floors and (floors[0] < 1 or floors[1] > definition.floors):
                audit.blockers.append("BLOCKED/INVALID_DEFINITION: monster house floors outside the dungeon")
        for entry in features.weather or []:
            if entry.get("status") not in known_statuses:
                audit.blockers.append(f"BLOCKED/MISSING_ASSET: weather status '{entry.get('status')}'")

    # --- grounds, boss, midpoint
    check = check_grounds(definition)
    audit.boss_mode = check.boss_mode
    audit.end_scene = check.boss_ground or check.boss_map or check.end
    audit.midpoint = check.mid
    for problem in check.problems:
        audit.blockers.append(f"BLOCKED/SCENE: {problem}")
    audit.notes.extend(check.notes)

    for miniboss in definition.minibosses:
        levels = [mob.level[1] for segment in definition.segments
                  for mob in definition.mobs_for(segment)]
        if levels and int(miniboss.get("level", [0, 0])[1]) <= max(levels):
            audit.blockers.append(
                f"BLOCKED/INVALID_DEFINITION: miniboss {miniboss.get('species')} is not stronger "
                "than the dungeon residents")

    # --- boss coherence
    boss = definition.boss or {}
    if boss and not boss.get("roster") and boss.get("mode"):
        audit.notes.append("boss declared without a roster")

    # --- can the Builder actually generate this dungeon? (smoke test)
    if not audit.blockers:
        from .profiles import customize as _customize
        from .rng import DungeonRng as _Rng
        from .validation import validate_floor as _validate
        rng = _Rng(label=f"smoke:{definition.id}")
        sample_floors = sorted({1, max(1, definition.floors // 2), definition.floors})
        for floor in sample_floors:
            segment = definition.segment_for_floor(floor)
            if floor in segment.fixed_floors:
                continue
            profiles = [_customize(choice.name, choice.overrides)
                        for choice in definition.profiles_for(segment)]
            report, _ = _validate(floor, profiles, rng, count=5)
            if not report.ok:
                audit.blockers.append(
                    f"BLOCKED/GENERATION_FAILED: floor {floor} could not produce 5 valid, "
                    f"distinct layouts ({'; '.join(report.notes) or 'see validation'})")
                break
        else:
            audit.notes.append("generation smoke test passed (5 distinct valid layouts per "
                               "sampled floor)")

    audit.cinematic_ground = audit.cinematic_ground or check.cinematic_ground
    audit.battle_ground = audit.battle_ground or check.battle_ground

    # --- legacy implementation: takeover, not an excuse
    zone_path = ZONE_DIR / f"{definition.id}.json"
    rebuilt_here = False
    if zone_path.exists():
        try:
            rebuilt_here = "tools/dungeon_builder" in json.loads(
                zone_path.read_text(encoding="utf-8-sig"))["Object"].get("Comment", "")
        except (json.JSONDecodeError, KeyError, OSError):
            rebuilt_here = False
    if rebuilt_here:
        audit.blockers = [b for b in audit.blockers if "TAKEOVER_PENDING" not in b]
        audit.notes.append("legacy zone already replaced by this Builder")
    elif definition.id in zone_names:
        audit.legacy_zone = f"Data/Zone/{definition.id}.json"
        if not any("TAKEOVER_PENDING" in blocker for blocker in audit.blockers):
            audit.blockers.append(
                f"BLOCKED/TAKEOVER_PENDING: legacy zone {audit.legacy_zone} must be rebuilt by "
                "the Builder and then removed")
        audit.ownership = TAKEOVER_PENDING

    # --- narrative content must not be lost
    if (audit.cutscenes or audit.red_cinematics) and not audit.narrative_transferred:
        audit.blockers.append(
            "BLOCKED/NARRATIVE_NOT_TRANSFERRED: "
            f"{audit.cutscenes} cutscene folder(s) / {audit.red_cinematics} PMD Red cinematic(s) "
            "are not bound to the new implementation yet")
        audit.notes.append(
            f"{audit.cutscenes} cutscene folder(s) and {audit.red_cinematics} PMD Red cinematic(s) "
            "to re-attach (narrative.transferred is still false)")
    audit.classify()
    return audit, definition


def audit_all(folder: Optional[Path] = None) -> Tuple[List[DungeonAudit], List[str]]:
    known_items = _known_items()
    known_statuses = _known_statuses()
    zone_names = {path.stem for path in ZONE_DIR.glob("*.json")}
    audits: List[DungeonAudit] = []
    definitions: List[DungeonDefinition] = []
    for path in list_definitions(folder):
        audit, definition = audit_definition(path, known_items, known_statuses, zone_names)
        audits.append(audit)
        if definition is not None:
            definitions.append(definition)
    global_problems = check_tileset_uniqueness(definitions)
    for problem in global_problems:
        for audit in audits:
            if audit.dungeon and audit.dungeon in problem:
                audit.blockers.append(f"BLOCKED/SHARED_TILESET: {problem}")
    return audits, global_problems


LIMITS = [
    "Pas de runtime .NET dans cet environnement : la validation runtime in-engine "
    "(chargement réel d'une zone par RogueEssence) reste impossible ici ; les rapports "
    "laissent le champ « runtime » non renseigné.",
    "`GridPathTiered` / `GridPathTreads` restent hors profils tant que leur comportement réel "
    "n'a pas été lu dans les sources RogueEssence (dépôt non accessible publiquement).",
]


def markdown(audits: Sequence[DungeonAudit], global_problems: Sequence[str]) -> str:
    passed = [a for a in audits if a.status == "PASS"]
    failed = [a for a in audits if a.status == "FAIL"]
    ready = [a for a in audits if a.readiness == "READY_FOR_GENERATION"]
    counts: Dict[str, int] = {}
    for audit in audits:
        counts[audit.readiness] = counts.get(audit.readiness, 0) + 1
    lines = ["# Audit de readiness — 51 donjons canoniques Ch.6–32", "",
             f"_Généré le {datetime.now(timezone.utc).isoformat(timespec='seconds')} — "
             f"{len(audits)} définitions : **{len(ready)} READY_FOR_GENERATION**, "
             f"{len(audits) - len(ready)} non prêtes._", "",
             "Aucun étage procédural n'a été généré à cette étape ; `generate-all` n'a pas été lancé.",
             "", "## Répartition des statuts", "",
             "| Statut | Nombre |", "|---|---|"]
    for status, count in sorted(counts.items(), key=lambda kv: (-kv[1], kv[0])):
        lines.append(f"| `{status}` | {count} |")
    lines += ["", "## Tableau de readiness", "",
              "| DUNGEON | SOURCE CANONIQUE | BIOME | DIR. | FLOORS | SEG. | PROFILS ROGUEELEMENTS | "
              "DTEF | POKÉMON | OBJETS | MIDPOINT | CINEMATIC GROUND | BATTLE GROUND | "
              "CANONICAL END GROUND | ARENA RSMAP | CUTSCENES | LEGACY | STATUS | BLOCKING REASON |",
              "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|"]
    for audit in sorted(audits, key=lambda a: (a.readiness != "READY_FOR_GENERATION",
                                               a.chapter, a.dungeon)):
        reason = "; ".join(b.replace("BLOCKED/", "") for b in audit.blockers[:2]) or "—"
        lines.append(
            f"| `{audit.dungeon or audit.file}` | {audit.source or '—'} | {audit.biome or '—'} | "
            f"{audit.direction or '—'} | {audit.floors} | {audit.segments} | "
            f"{', '.join(audit.profiles) or '—'} | `{audit.dtef or '—'}` | {audit.species} | "
            f"{audit.item_entries} | {audit.midpoint or '—'} | {audit.cinematic_ground or '—'} | "
            f"{audit.battle_ground or '—'} | {audit.canonical_end_ground or '—'} | "
            f"{audit.arena_rsmap or '—'} | {audit.cutscenes}+{audit.red_cinematics} | "
            f"{audit.legacy_zone or '—'} | **{audit.readiness}** | {reason} |")

    lines += ["", "## Blocages détaillés", ""]
    for audit in sorted(failed, key=lambda a: (a.chapter, a.dungeon)):
        lines.append(f"### `{audit.dungeon or audit.file}` — {audit.name} (ch.{audit.chapter})")
        for blocker in audit.blockers:
            lines.append(f"- {blocker}")
        lines.append("")
    if global_problems:
        lines += ["## Conflits globaux", ""]
        lines.extend(f"- {problem}" for problem in global_problems)
        lines.append("")
    lines += ["## Limites connues de l'environnement", ""]
    lines.extend(f"- {limit}" for limit in LIMITS)
    lines.append("")
    return "\n".join(lines)


def write_report(audits: Sequence[DungeonAudit], global_problems: Sequence[str],
                 folder: Optional[Path] = None) -> List[Path]:
    folder = Path(folder or DOC_DIR)
    folder.mkdir(parents=True, exist_ok=True)
    md_path = folder / "AUDIT_51_DEFINITIONS.md"
    json_path = folder / "AUDIT_51_DEFINITIONS.json"
    md_path.write_text(markdown(audits, global_problems), encoding="utf-8")
    json_path.write_text(json.dumps({
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "total": len(audits),
        "pass": sum(1 for a in audits if a.status == "PASS"),
        "fail": sum(1 for a in audits if a.status == "FAIL"),
        "limits": LIMITS,
        "global_problems": list(global_problems),
        "dungeons": [a.__dict__ | {"status": a.status} for a in audits],
    }, ensure_ascii=False, indent=2), encoding="utf-8")
    return [md_path, json_path]
