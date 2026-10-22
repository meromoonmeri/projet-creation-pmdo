"""Vérification d'exclusivité du périmètre Ch.6-32.

Question à laquelle ce module répond, et rien d'autre : **les 51 zones produites
par le Builder sont-elles les seules implémentations actives des donjons des
chapitres 6 à 32, et une ancienne zone / un ancien générateur / un ancien script
peut-il encore reprendre la main ?**

Sept contrôles, tous sur l'état réel du dépôt :

1. `definitions` — 51 définitions, 51 zones, 51 entrées d'index, correspondance 1:1.
2. `builder_fingerprint` — chaque zone du périmètre porte l'empreinte du Builder.
3. `zone_scripts` — chaque script de zone du périmètre est celui généré par le
   Builder (aucun script hérité d'une ancienne implémentation encore branché).
4. `purged_substitutes` — les substituts supprimés (`tools/purge_chapter6_32_dungeon_data.py`)
   n'ont plus ni zone, ni script de zone actif.
5. `dungeon_references` — tout `EnterDungeon` / `ContinueDungeon` du dépôt vise une
   zone existante, un segment existant et un étage existant.
6. `legacy_writers` — tout ancien outil capable d'écrire dans `Data/Zone`,
   `Data/Script/halcyon/zone` ou `DungeonDefs` porte le verrou `perimeter_guard`.
7. `scene_rule` — règle verrouillée : Ground de cinématique = Ground du combat =
   Ground final canonique ; boss internes = salle fixe `.rsmap` en étage.

Les zones hors périmètre ne sont jamais modifiées ni corrigées : elles sont
seulement listées quand elles référencent le périmètre.
"""
from __future__ import annotations

import json
import re
import shutil
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[2]
DEF_DIR = ROOT / "DungeonDefs" / "canonical"
ZONE_DIR = ROOT / "Data" / "Zone"
GROUND_DIR = ROOT / "Data" / "Ground"
SCRIPT_DIR = ROOT / "Data" / "Script"
SCRIPT_ZONE = SCRIPT_DIR / "halcyon" / "zone"
TOOLS_DIR = ROOT / "tools"
QUARANTINE = ROOT / "RESERVE" / "legacy_ch6_32" / "zone_scripts"

BUILDER_FINGERPRINT = "built by tools/dungeon_builder"
ZONE_SCRIPT_MARKER = "-- [dungeon_builder] script de zone canonique généré"
GUARD_MARK = "perimeter_guard"

CALL_RE = re.compile(
    r"(ContinueDungeon|EnterDungeon)\(\s*(['\"])([a-z0-9_]+)\2\s*,\s*(-?\d+)\s*,\s*(-?\d+)")

#: Substituts Ch.6-32 supprimés par tools/purge_chapter6_32_dungeon_data.py.
#: Ceux qui ont un équivalent canonique sont désormais des zones du Builder ;
#: les autres ne doivent plus rien avoir d'actif.
PURGED_SUBSTITUTES = {
    "gloomy_forest", "magma_cavern", "waterfall_pond", "poisonous_forest", "sky_tower",
    "crevasse_geode", "desert_oublies", "jardin_energie", "toundra_desolee", "bassin_tari",
    "marais_errants", "col_foudre", "falaises_envol", "sentier_enneige",
}


@dataclass
class Finding:
    check: str
    severity: str           # "error" | "blocked" | "info"
    subject: str
    detail: str

    def to_dict(self) -> Dict[str, str]:
        return dict(self.__dict__)


@dataclass
class ExclusivityReport:
    perimeter: List[str] = field(default_factory=list)
    findings: List[Finding] = field(default_factory=list)
    counts: Dict[str, int] = field(default_factory=dict)

    @property
    def errors(self) -> List[Finding]:
        return [f for f in self.findings if f.severity == "error"]

    @property
    def blocked(self) -> List[Finding]:
        return [f for f in self.findings if f.severity == "blocked"]

    @property
    def ok(self) -> bool:
        return not self.errors

    def to_dict(self) -> Dict[str, object]:
        return {
            "perimeter": self.perimeter,
            "counts": self.counts,
            "findings": [f.to_dict() for f in self.findings],
            "ok": self.ok,
        }


def _read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def _definitions() -> Dict[str, dict]:
    defs: Dict[str, dict] = {}
    for path in sorted(DEF_DIR.glob("*.json")):
        raw = _read_json(path)
        defs[str(raw.get("id") or path.stem)] = raw
    return defs


def _zone_shapes() -> Dict[str, List[int]]:
    shapes: Dict[str, List[int]] = {}
    for path in sorted(ZONE_DIR.glob("*.json")):
        obj = _read_json(path)["Object"]
        shapes[path.stem] = [len(seg.get("Floors", [])) for seg in obj.get("Segments", [])]
    return shapes


def scan() -> ExclusivityReport:
    defs = _definitions()
    shapes = _zone_shapes()
    report = ExclusivityReport(perimeter=sorted(defs))
    add = report.findings.append

    # 1. définitions <-> zones <-> index
    index = _read_json(ZONE_DIR / "index.idx")["Object"]
    index_keys = {key for key in index if not key.startswith("$")}
    for dungeon in sorted(defs):
        if dungeon not in shapes:
            add(Finding("definitions", "error", dungeon, "aucune zone Data/Zone/<id>.json"))
        if dungeon not in index_keys:
            add(Finding("definitions", "error", dungeon, "absent de Data/Zone/index.idx"))
    orphan_index = sorted(index_keys - set(shapes))
    for zone in orphan_index:
        add(Finding("definitions", "error", zone, "présent dans l'index sans fichier de zone"))

    aliases: Dict[str, str] = {}
    for dungeon, raw in defs.items():
        for alias in raw.get("aliases") or []:
            aliases[alias] = dungeon
    for alias, dungeon in sorted(aliases.items()):
        if alias in shapes:
            add(Finding("definitions", "error", alias,
                        f"une zone porte encore l'ancien nom de {dungeon} : deux implémentations"))

    # 2. empreinte du Builder
    for dungeon in sorted(defs):
        path = ZONE_DIR / f"{dungeon}.json"
        if not path.is_file():
            continue
        if BUILDER_FINGERPRINT not in path.read_text(encoding="utf-8-sig"):
            add(Finding("builder_fingerprint", "error", dungeon,
                        "la zone ne porte pas l'empreinte du Builder"))

    # 3. scripts de zone du périmètre
    for dungeon in sorted(defs):
        script = SCRIPT_ZONE / dungeon / "init.lua"
        if not script.is_file():
            add(Finding("zone_scripts", "error", dungeon, "aucun script de zone"))
            continue
        if ZONE_SCRIPT_MARKER not in script.read_text(encoding="utf-8", errors="replace"):
            add(Finding("zone_scripts", "error", dungeon,
                        "script de zone hérité : il n'a pas été régénéré par le Builder"))

    # 4. substituts purgés
    for substitute in sorted(PURGED_SUBSTITUTES):
        if substitute in defs:
            continue  # remplacé par une zone canonique du Builder
        if substitute in shapes:
            add(Finding("purged_substitutes", "error", substitute,
                        "la zone du substitut existe encore"))
        if (SCRIPT_ZONE / substitute).is_dir():
            add(Finding("purged_substitutes", "error", substitute,
                        "script de zone du substitut encore actif dans Data/Script"))

    # 5. références de donjon
    broken = 0
    for lua in sorted(SCRIPT_DIR.rglob("*.lua")):
        text = lua.read_text(encoding="utf-8", errors="replace")
        for match in CALL_RE.finditer(text):
            zone, segment, floor = match.group(3), int(match.group(4)), int(match.group(5))
            rel = str(lua.relative_to(ROOT))
            if zone not in shapes:
                broken += 1
                severity = "blocked" if zone in PURGED_SUBSTITUTES else "error"
                add(Finding("dungeon_references", severity, rel,
                            f"{match.group(1)}('{zone}') : zone inexistante"))
            elif segment >= len(shapes[zone]):
                broken += 1
                severity = "blocked" if zone in defs else "error"
                add(Finding("dungeon_references", severity, rel,
                            f"{match.group(1)}('{zone}', {segment}) : le donjon reconstruit "
                            f"n'a que {len(shapes[zone])} segment(s)"))
            elif floor >= shapes[zone][segment]:
                broken += 1
                add(Finding("dungeon_references", "error", rel,
                            f"{match.group(1)}('{zone}', {segment}, {floor}) : étage hors bornes "
                            f"({shapes[zone][segment]} étages)"))

    # 6. anciens générateurs
    unguarded = 0
    for tool in sorted(TOOLS_DIR.rglob("*.py")):
        if ("dungeon_builder" in tool.parts
                or tool.name in ("perimeter_guard.py", "build_canonical_definitions.py")):
            continue
        text = tool.read_text(encoding="utf-8", errors="replace")
        touches = ("Data/Zone" in text or 'Data" / "Zone' in text
                   or "DungeonDefs" in text or "halcyon/zone" in text)
        writes = re.search(r"open\([^)]*['\"][wxa]|write_text\(|write_bytes\(|json\.dump\(", text)
        if not (touches and writes):
            continue
        if GUARD_MARK not in text:
            unguarded += 1
            add(Finding("legacy_writers", "error", str(tool.relative_to(ROOT)),
                        "ancien outil capable d'écrire dans le périmètre sans verrou "
                        "perimeter_guard"))

    # 7. règle des scènes
    for dungeon, raw in sorted(defs.items()):
        scenes = raw.get("scenes") or {}
        boss = raw.get("boss") or {}
        mode = str(boss.get("mode") or "")
        end = scenes.get("canonical_end_ground") or ""
        if end:
            for role in ("cinematic_ground", "battle_ground"):
                if scenes.get(role) != end:
                    add(Finding("scene_rule", "error", dungeon,
                                f"{role}={scenes.get(role)!r} ≠ canonical_end_ground={end!r}"))
            if not (GROUND_DIR / f"{end}.rsground").is_file():
                add(Finding("scene_rule", "error", dungeon,
                            f"Ground final {end} déclaré mais absent de Data/Ground"))
        if mode == "arena_rsmap":
            arena = str(boss.get("map") or "")
            if not (ROOT / "Data" / "Map" / f"{arena}.rsmap").is_file():
                add(Finding("scene_rule", "error", dungeon,
                            f"salle fixe {arena}.rsmap absente de Data/Map"))
            if boss.get("ground"):
                add(Finding("scene_rule", "error", dungeon,
                            "boss interne : un Ground narratif a été inventé alors que la règle "
                            "impose une salle fixe en étage"))
            zone_text = (ZONE_DIR / f"{dungeon}.json").read_text(encoding="utf-8-sig")
            if arena and arena not in zone_text:
                add(Finding("scene_rule", "error", dungeon,
                            f"la salle fixe {arena} n'est pas chargée par la zone"))

    report.counts = {
        "definitions": len(defs),
        "zones": len(shapes),
        "perimeter_zones": len([d for d in defs if d in shapes]),
        "out_of_scope_zones": len(set(shapes) - set(defs)),
        "broken_references": broken,
        "unguarded_legacy_writers": unguarded,
        "errors": len(report.errors),
        "blocked": len(report.blocked),
    }
    return report


def quarantine_legacy_zone_scripts(*, write: bool = False) -> List[str]:
    """Sort du dossier actif les scripts de zone des substituts supprimés.

    Ils ne peuvent plus être chargés (leur zone n'existe plus) mais ils restent
    du code d'ancienne implémentation dans l'arbre vivant : on les archive sous
    `RESERVE/legacy_ch6_32/zone_scripts/` au lieu de les détruire, pour que le
    contenu narratif reste récupérable.
    """
    defs = _definitions()
    shapes = _zone_shapes()
    moved: List[str] = []
    for directory in sorted(SCRIPT_ZONE.iterdir()):
        if not directory.is_dir():
            continue
        zone = directory.name
        if zone in shapes or zone in defs:
            continue
        if zone not in PURGED_SUBSTITUTES:
            # zone hors périmètre : on n'y touche pas.
            continue
        target = QUARANTINE / zone
        if write:
            target.parent.mkdir(parents=True, exist_ok=True)
            if target.exists():
                shutil.rmtree(target)
            shutil.move(str(directory), str(target))
        moved.append(str(directory.relative_to(ROOT)))
    return moved


def render(report: ExclusivityReport) -> str:
    lines = [
        "# Exclusivité du périmètre Ch.6-32", "",
        "Question vérifiée : *les 51 zones du Builder sont-elles les seules "
        "implémentations actives, et une ancienne zone / un ancien générateur / un ancien "
        "script peut-il reprendre la main ?*", "",
        "| Mesure | Valeur |", "|---|---|",
    ]
    for key, value in report.counts.items():
        lines.append(f"| {key} | {value} |")
    lines += ["", f"**Erreurs : {len(report.errors)} — points bloqués (décision narrative "
              f"requise) : {len(report.blocked)}**", ""]

    for severity, title in (("error", "Erreurs"), ("blocked", "Bloqué — décision narrative requise"),
                            ("info", "Informations")):
        items = [f for f in report.findings if f.severity == severity]
        if not items:
            continue
        lines += [f"## {title} ({len(items)})", "", "| Contrôle | Sujet | Détail |", "|---|---|---|"]
        for finding in items:
            lines.append(f"| `{finding.check}` | `{finding.subject}` | {finding.detail} |")
        lines.append("")

    lines += [
        "## Ce que ce rapport ne prétend pas", "",
        "- Il ne remplace pas l'exécution du moteur : la conformité statique n'est pas une "
        "validation runtime.",
        "- Il ne touche pas aux zones hors périmètre : elles restent la responsabilité de leurs "
        "auteurs.",
        "",
    ]
    return "\n".join(lines)
