"""Câblage narratif canonique des 51 donjons Ch.6-32.

Ce module calcule, **depuis les définitions** (`DungeonDefs/canonical/*.json`) et
l'état réel du dépôt, le câblage complet d'un donjon reconstruit :

* quel Ground reçoit le joueur à la fin de chaque segment ;
* quel donjon suit (chaîne canonique pied -> cime : Mt. Blaze -> Mt. Blaze Peak,
  Frosty Forest -> Frosty Grotto, ...) ;
* quelle scène finale joue la conclusion.

Deux règles verrouillées :

1. **Ground de cinématique = Ground du combat = Ground final canonique** quand ce
   Ground existe.  Aucune arène séparée, aucune téléportation vers un décor
   inventé : la scène est jouée sur le Ground canonique et le run s'y termine.
2. **Boss internes au donjon** (Buried Relic / Meteor Cave) : la salle fixe
   `.rsmap` est un étage du donjon (`fixed_floors`), jamais un Ground narratif.
   Ces donjons n'ont donc pas de Ground de fin et le module ne leur en invente
   aucun.

Le module produit :

* `Data/Script/halcyon/zone/<id>/init.lua` — script de zone canonique généré
  (l'ancien est archivé sous `RESERVE/legacy_ch6_32/zone_scripts/<id>/`) ;
* les recâblages des scripts de Ground dont l'appel `EnterDungeon` /
  `ContinueDungeon` visait une zone supprimée ou un segment disparu ;
* le bloc `wiring` de chaque définition, pour que le câblage soit une donnée
  inspectable et non du code caché.
"""
from __future__ import annotations

import json
import re
import shutil
from dataclasses import dataclass, field
from functools import lru_cache
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[2]
DEF_DIR = ROOT / "DungeonDefs" / "canonical"
ZONE_DIR = ROOT / "Data" / "Zone"
GROUND_DIR = ROOT / "Data" / "Ground"
SCRIPT_GROUND = ROOT / "Data" / "Script" / "halcyon" / "ground"
SCRIPT_ZONE = ROOT / "Data" / "Script" / "halcyon" / "zone"
ARCHIVE = ROOT / "RESERVE" / "legacy_ch6_32" / "zone_scripts"

MARKER = "-- [dungeon_builder] script de zone canonique généré"

#: Chaînes canoniques PMD Red « pied -> cime » : le donjon parent ne se termine
#: pas sur une scène, il enchaîne sur le donjon suivant via son Ground de relais.
#: Source : docs/ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md (§2) et
#: docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md (entrée / relais / fin).
CHAINS: Dict[str, str] = {
    "mt_blaze": "mt_blaze_peak",
    "mt_thunder": "mt_thunder_peak",
    "mt_freeze": "mt_freeze_peak",
    "frosty_forest": "frosty_grotto",
    "magma_cavern": "magma_cavern_pit",
    "sky_tower": "sky_tower_summit",
}


#: Grounds de scène qui appartiennent clairement à un donjon du périmètre sans
#: être déclarés dans `scenes` (scènes de chapitre écrites avant la
#: reconstruction).  `segment = -1` signifie « dernier segment ».
EXTRA_GROUND_ROLES: Dict[str, Tuple[str, int, str]] = {
    "gloomy_forest_entrance": (
        "gloomy_forest", 0,
        "porte d'entrée des Bois Sombres : elle ouvre le donjon reconstruit à son premier étage"),
    "gloomy_forest_miniboss": (
        "gloomy_forest", -1,
        "scène de mi-parcours des Bois Sombres : elle rend la main au dernier segment, "
        "où se trouve l'étage d'arène"),
}

CALL_RE = re.compile(
    r"(?P<call>ContinueDungeon|EnterDungeon)\(\s*(?P<q>['\"])(?P<zone>[a-z0-9_]+)(?P=q)"
    r"\s*,\s*(?P<segment>-?\d+)\s*,\s*(?P<floor>-?\d+)"
)


def _read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def _write_def(path: Path, payload) -> None:
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


@dataclass
class SegmentExit:
    segment: int
    kind: str          # "ground" | "zone" | "end_run"
    target: str
    reason: str

    def to_dict(self) -> Dict[str, object]:
        return dict(self.__dict__)


@dataclass
class GroundFix:
    path: str
    call: str
    old: Tuple[str, int, int]
    new: Optional[Tuple[str, int, int]]
    reason: str
    kind: str = "rebind"        # "rebind" | "end_run"

    def to_dict(self) -> Dict[str, object]:
        return {
            "path": self.path,
            "call": self.call,
            "kind": self.kind,
            "old": {"zone": self.old[0], "segment": self.old[1], "floor": self.old[2]},
            "new": ({"zone": self.new[0], "segment": self.new[1], "floor": self.new[2]}
                    if self.new else {"action": "EndDungeonRun"}),
            "reason": self.reason,
        }


@dataclass
class DungeonWiring:
    dungeon: str
    segments: int
    entrance_ground: str = ""
    relay_ground: str = ""
    end_ground: str = ""
    next_zone: str = ""
    boss_mode: str = ""
    exits: List[SegmentExit] = field(default_factory=list)
    zone_script: str = ""
    archived_script: str = ""
    notes: List[str] = field(default_factory=list)

    def to_dict(self) -> Dict[str, object]:
        return {
            "dungeon": self.dungeon,
            "segments": self.segments,
            "entrance_ground": self.entrance_ground,
            "relay_ground": self.relay_ground,
            "end_ground": self.end_ground,
            "next_zone": self.next_zone,
            "boss_mode": self.boss_mode,
            "segment_exits": [e.to_dict() for e in self.exits],
            "zone_script": self.zone_script,
            "archived_script": self.archived_script,
            "notes": self.notes,
            "rule": ("cinématique = combat = fin sur le Ground canonique ; boss interne = "
                     "étage fixe du donjon, jamais un Ground inventé"),
        }


@dataclass
class GroundScript:
    ground: str
    role: str
    dungeon: str
    action: str          # "enter_zone" | "end_run"
    target: str
    reason: str

    def to_dict(self) -> Dict[str, object]:
        return dict(self.__dict__)


@dataclass
class WiringPlan:
    dungeons: List[DungeonWiring] = field(default_factory=list)
    ground_fixes: List[GroundFix] = field(default_factory=list)
    ground_scripts: List[GroundScript] = field(default_factory=list)
    unresolved: List[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.unresolved


def _ground_exists(name: str) -> bool:
    return bool(name) and (GROUND_DIR / f"{name}.rsground").is_file()


def _ground_script_text(name: str) -> str:
    directory = SCRIPT_GROUND / name
    if not directory.is_dir():
        return ""
    return "\n".join(p.read_text(encoding="utf-8", errors="replace")
                     for p in sorted(directory.glob("*.lua")))


def _is_arena_return_ground(name: str) -> bool:
    """Un Ground « retour d'arène » relance le donjon après sa cinématique.

    Ces Grounds (scènes d'Ancrage New Era) jouent la scène puis rendent la main
    au donjon via `ContinueDungeon` : le combat a lieu sur l'étage d'arène du
    donjon lui-même, jamais sur un décor séparé.  Ils se placent donc à la fin
    de l'avant-dernier segment, pas après le dernier.
    """
    return "ContinueDungeon" in _ground_script_text(name)



@lru_cache(maxsize=None)
def ground_entry_marker(ground: str) -> Optional[str]:
    """Marqueur d'entrée réellement présent dans le Ground, ou None.

    `GAME:EnterGroundMap(nom, marqueur)` passe par
    `GroundMap.GetEntryPointIdx`, qui lève `KeyNotFoundException` si le
    marqueur n'existe pas : viser `Main_Entrance_Marker` sans vérifier plante
    le jeu. Les Grounds de scène qui téléportent eux-mêmes le joueur n'ont
    aucun marqueur ; ils sont alors adressés par index (`GetEntryPoint(int)`
    renvoie Loc.Zero au lieu de lever).
    """
    path = GROUND_DIR / f"{ground}.rsground"
    if not path.is_file():
        return None
    try:
        raw = _read_json(path)["Object"]
    except (OSError, json.JSONDecodeError, KeyError):
        return None
    names: List[str] = []
    for layer in raw.get("Entities") or []:
        for marker in layer.get("Markers") or []:
            name = marker.get("EntName")
            if isinstance(name, str) and name:
                names.append(name)
    if "Main_Entrance_Marker" in names:
        return "Main_Entrance_Marker"
    return names[0] if names else None

def _zone_segments(dungeon: str) -> int:
    path = ZONE_DIR / f"{dungeon}.json"
    if not path.is_file():
        return 0
    return len(_read_json(path)["Object"].get("Segments", []))


def load_definitions() -> Dict[str, dict]:
    defs: Dict[str, dict] = {}
    for path in sorted(DEF_DIR.glob("*.json")):
        raw = _read_json(path)
        defs[str(raw.get("id") or path.stem)] = raw
    return defs


def plan(defs: Optional[Dict[str, dict]] = None) -> WiringPlan:
    """Calcule le câblage de chaque donjon du périmètre."""
    defs = defs if defs is not None else load_definitions()
    result = WiringPlan()
    owner: Dict[str, List[str]] = {}

    for dungeon, raw in sorted(defs.items()):
        scenes = raw.get("scenes") or {}
        boss = raw.get("boss") or {}
        nseg = _zone_segments(dungeon)
        if nseg == 0:
            result.unresolved.append(f"{dungeon}: aucune zone Data/Zone/{dungeon}.json")
            continue

        wiring = DungeonWiring(
            dungeon=dungeon,
            segments=nseg,
            entrance_ground=scenes.get("entrance_ground") or "",
            relay_ground=scenes.get("relay_ground") or "",
            end_ground=scenes.get("canonical_end_ground") or "",
            next_zone=CHAINS.get(dungeon, ""),
            boss_mode=str(boss.get("mode") or ""),
        )

        # Les donjons à boss interne (salle fixe .rsmap) ne reçoivent aucun
        # Ground narratif : la règle l'interdit explicitement.
        if wiring.boss_mode == "arena_rsmap":
            wiring.end_ground = ""
            wiring.notes.append(
                "boss interne : salle fixe .rsmap chargée en étage (fixed_floors), aucun Ground de scène")

        # Le donjon parent d'une chaîne ne joue pas la scène finale : elle
        # appartient à la cime.
        if wiring.next_zone:
            wiring.notes.append(
                f"chaîne canonique : la scène finale appartient à {wiring.next_zone}")

        # Certains donjons n'ont pas de Ground de fin canonique PMD Red mais un
        # Ground de gardien déclaré côté boss : c'est lui qui porte la scène.
        if not wiring.end_ground and str(boss.get("mode") or "") == "canonical_ground":
            candidate = str(boss.get("ground") or "")
            if _ground_exists(candidate):
                wiring.end_ground = candidate
                wiring.notes.append(
                    f"Ground de scène déclaré côté boss : {candidate} (aucun Ground de fin PMD Red)")

        internal_relay = f"{dungeon}_midpoint" if _ground_exists(f"{dungeon}_midpoint") else ""
        last = nseg - 1
        arena_return = (
            not wiring.next_zone
            and _ground_exists(wiring.end_ground)
            and _is_arena_return_ground(wiring.end_ground)
            and nseg >= 2
        )
        if arena_return:
            wiring.notes.append(
                f"{wiring.end_ground} est une scène d'Ancrage qui rend la main au donjon : "
                f"elle se joue à la fin du segment {last - 1}, le combat a lieu sur l'étage "
                f"d'arène du segment {last}")

        for segment in range(nseg):
            if arena_return and segment == last - 1:
                wiring.exits.append(SegmentExit(
                    segment, "ground", wiring.end_ground,
                    "cinématique du gardien puis retour dans le donjon pour le combat : "
                    "cinématique et combat au même endroit, aucune arène séparée"))
                continue
            if segment < last:
                if segment == 0 and internal_relay:
                    wiring.exits.append(SegmentExit(
                        segment, "ground", internal_relay,
                        "relais interne du donjon (station de mi-parcours) puis retour au segment suivant"))
                else:
                    wiring.exits.append(SegmentExit(
                        segment, "zone", dungeon,
                        f"poursuite directe vers le segment {segment + 1} du même donjon"))
                continue

            # dernier segment
            if wiring.next_zone:
                if _ground_exists(wiring.relay_ground):
                    wiring.exits.append(SegmentExit(
                        segment, "ground", wiring.relay_ground,
                        f"scène canonique de transition vers {wiring.next_zone}"))
                else:
                    wiring.exits.append(SegmentExit(
                        segment, "zone", wiring.next_zone,
                        f"enchaînement canonique direct vers {wiring.next_zone} (aucun Ground de relais)"))
            elif arena_return:
                wiring.exits.append(SegmentExit(
                    segment, "end_run", "master_zone",
                    "étage d'arène franchi : fin de run sur place, la scène a déjà été jouée"))
            elif _ground_exists(wiring.end_ground):
                wiring.exits.append(SegmentExit(
                    segment, "ground", wiring.end_ground,
                    "Ground final canonique : cinématique, combat et fin au même endroit"))
            else:
                if wiring.end_ground and not _ground_exists(wiring.end_ground):
                    result.unresolved.append(
                        f"{dungeon}: Ground final déclaré {wiring.end_ground} mais absent de Data/Ground")
                wiring.exits.append(SegmentExit(
                    segment, "end_run", "master_zone",
                    "aucun Ground final canonique : fin de run standard, aucun décor inventé"))

        wiring.zone_script = f"Data/Script/halcyon/zone/{dungeon}/init.lua"
        result.dungeons.append(wiring)

        for ground in (wiring.entrance_ground, wiring.relay_ground, wiring.end_ground):
            if ground:
                owner.setdefault(ground, []).append(dungeon)

    result.ground_fixes = _plan_ground_fixes(result, defs, owner)
    result.ground_scripts = _plan_ground_scripts(result)
    return result


GROUND_LUA_TEMPLATE = """{marker} — ne pas éditer à la main.
--[[ {ground} — {role} de {dungeon}.
     Ground canonique existant : la scène, le combat et la conclusion s'y
     déroulent au même endroit. Ce script assure uniquement la continuité du
     parcours ; les dialogues restent portés par la scène du Ground.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local {ground} = {{}}

function {ground}.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function {ground}.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
{body}
end

function {ground}.Update(map) end
function {ground}.GameSave(map) end
function {ground}.GameLoad(map)
  GAME:FadeIn(20)
end

return {ground}
"""


def _plan_ground_scripts(result: WiringPlan) -> List[GroundScript]:
    """Grounds utilisés par le câblage mais dépourvus de script : sans eux le
    parcours s'arrête sur un décor muet."""
    scripts: List[GroundScript] = []
    seen: set = set()
    for wiring in result.dungeons:
        for exit_ in wiring.exits:
            if exit_.kind != "ground" or exit_.target in seen:
                continue
            if (SCRIPT_GROUND / exit_.target).is_dir():
                continue
            seen.add(exit_.target)
            if exit_.target == wiring.relay_ground and wiring.next_zone:
                scripts.append(GroundScript(
                    exit_.target, "relais canonique", wiring.dungeon, "enter_zone",
                    wiring.next_zone,
                    f"scène de transition vers {wiring.next_zone} : sans script, le Ground "
                    "serait un cul-de-sac"))
            elif exit_.target == wiring.end_ground:
                scripts.append(GroundScript(
                    exit_.target, "Ground final canonique", wiring.dungeon, "end_run",
                    "master_zone",
                    "conclusion du donjon sur le Ground canonique : cinématique, combat et fin "
                    "au même endroit, puis retour"))
            else:
                scripts.append(GroundScript(
                    exit_.target, "relais interne", wiring.dungeon, "enter_zone", wiring.dungeon,
                    "station de mi-parcours : reprise du donjon au segment suivant"))
    return scripts


def render_ground_script(script: GroundScript, wiring: DungeonWiring) -> str:
    if script.action == "enter_zone":
        segment = 0
        if script.target == wiring.dungeon:
            segment = 1
        body = "\n".join([
            "  GAME:FadeOut(false, 30)",
            f"  GAME:EnterDungeon('{script.target}', {segment}, 0, 0,",
            "    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)",
        ])
    else:
        body = "\n".join([
            "  SV.CanonicalDungeons = SV.CanonicalDungeons or {}",
            f"  SV.CanonicalDungeons['{wiring.dungeon}'] = true",
            "  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,",
            "    'master_zone', -1, 1, 0, true, true)",
        ])
    return GROUND_LUA_TEMPLATE.format(
        marker=MARKER.replace("script de zone canonique", "script de Ground canonique"),
        ground=script.ground, role=script.role, dungeon=script.dungeon, body=body)


def _expected_targets(result: WiringPlan) -> Dict[str, Dict[str, object]]:
    """Cible canonique attendue pour chaque Ground câblé au périmètre."""
    expected: Dict[str, Dict[str, object]] = {}
    for wiring in result.dungeons:
        last = wiring.segments - 1
        if wiring.entrance_ground:
            expected.setdefault(wiring.entrance_ground, {
                "dungeon": wiring.dungeon, "role": "entrée",
                "mode": "rebind", "target": (wiring.dungeon, 0, 0),
                "reason": (f"Ground d'entrée de {wiring.dungeon} : il ouvre le donjon "
                           "reconstruit à son premier étage"),
            })
        for exit_ in wiring.exits:
            if exit_.kind != "ground":
                continue
            ground = exit_.target
            if ground == f"{wiring.dungeon}_midpoint":
                expected[ground] = {
                    "dungeon": wiring.dungeon, "role": "relais interne",
                    "mode": "rebind", "target": (wiring.dungeon, exit_.segment + 1, 0),
                    "reason": (f"station de mi-parcours de {wiring.dungeon} : elle rend la main "
                               f"au segment {exit_.segment + 1} du même donjon"),
                }
            elif ground == wiring.relay_ground and wiring.next_zone:
                expected[ground] = {
                    "dungeon": wiring.dungeon, "role": "relais canonique",
                    "mode": "rebind", "target": (wiring.next_zone, 0, 0),
                    "reason": (f"scène canonique de transition : elle enchaîne sur "
                               f"{wiring.next_zone}, donjon suivant de la chaîne PMD Red"),
                }
            elif ground == wiring.end_ground and exit_.segment < last:
                expected[ground] = {
                    "dungeon": wiring.dungeon, "role": "scène de gardien",
                    "mode": "rebind", "target": (wiring.dungeon, last, 0),
                    "reason": (f"scène du gardien puis combat sur l'étage d'arène du segment "
                               f"{last} de {wiring.dungeon} : cinématique et combat au même endroit"),
                }
            elif ground == wiring.end_ground:
                expected[ground] = {
                    "dungeon": wiring.dungeon, "role": "Ground final canonique",
                    "mode": "end_run", "target": None,
                    "reason": (f"conclusion de {wiring.dungeon} sur son Ground final : la scène "
                               "s'y termine, aucun renvoi vers une ancienne implémentation"),
                }
    wirings = {w.dungeon: w for w in result.dungeons}
    for ground, (dungeon, segment, reason) in EXTRA_GROUND_ROLES.items():
        wiring = wirings.get(dungeon)
        if wiring is None or ground in expected or not (SCRIPT_GROUND / ground).is_dir():
            continue
        target_segment = wiring.segments - 1 if segment < 0 else segment
        expected[ground] = {
            "dungeon": dungeon, "role": "scène de chapitre",
            "mode": "rebind", "target": (dungeon, target_segment, 0),
            "reason": reason,
        }

    for wiring in result.dungeons:
        midpoint = f"{wiring.dungeon}_midpoint"
        if midpoint in expected or not _ground_exists(midpoint):
            continue
        expected[midpoint] = {
            "dungeon": wiring.dungeon, "role": "relais interne orphelin",
            "mode": "end_run", "target": None,
            "reason": (f"{midpoint} n'a plus de segment intermédiaire dans {wiring.dungeon} "
                       "reconstruit : la station rend la main proprement au lieu de viser un "
                       "segment disparu"),
        }
    return expected
    """Position de fin (exclue) de l'appel Lua ouvert à partir de `start`."""
    depth = 0
    try:
        index = text.index("(", start)
    except ValueError:
        return -1
    for pos in range(index, len(text)):
        if text[pos] == "(":
            depth += 1
        elif text[pos] == ")":
            depth -= 1
            if depth == 0:
                return pos + 1
    return -1


def _call_span(text: str, start: int) -> int:
    """Position de fin (exclue) de l'appel Lua ouvert à partir de `start`."""
    depth = 0
    try:
        index = text.index("(", start)
    except ValueError:
        return -1
    for pos in range(index, len(text)):
        if text[pos] == "(":
            depth += 1
        elif text[pos] == ")":
            depth -= 1
            if depth == 0:
                return pos + 1
    return -1


END_RUN_CALL = ("GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "
                "'master_zone', -1, 1, 0, true, true)")


def _plan_ground_fixes(result: WiringPlan, defs: Dict[str, dict],
                       owner: Dict[str, List[str]]) -> List[GroundFix]:
    fixes: List[GroundFix] = []
    expected = _expected_targets(result)

    for ground, spec in sorted(expected.items()):
        script_dir = SCRIPT_GROUND / ground
        if not script_dir.is_dir():
            continue
        for lua in sorted(script_dir.glob("*.lua")):
            text = lua.read_text(encoding="utf-8", errors="replace")
            for match in CALL_RE.finditer(text):
                zone = match.group("zone")
                segment = int(match.group("segment"))
                floor = int(match.group("floor"))
                if spec["mode"] == "end_run":
                    fixes.append(GroundFix(
                        str(lua.relative_to(ROOT)), match.group("call"),
                        (zone, segment, floor), None, str(spec["reason"]), kind="end_run"))
                    continue
                target = spec["target"]
                if (zone, segment, floor) == target:
                    continue
                fixes.append(GroundFix(
                    str(lua.relative_to(ROOT)), match.group("call"),
                    (zone, segment, floor), target, str(spec["reason"]), kind="rebind"))
    return fixes


LUA_TEMPLATE = """{marker} — ne pas éditer à la main.
--[[ {title} ({dungeon}) — chapitre {chapter}.
     Zone reconstruite par tools/dungeon_builder : {segments} segment(s).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local {dungeon} = {{}}

local LAST_SEGMENT = {last}

local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("master_zone")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then return 1 end
  return idx
end

local function ZONE_GROUND_IDX(zone, name)
  for ii = 0, zone.GroundMaps.Count - 1 do
    if zone.GroundMaps[ii] == name then return ii end
  end
  PrintInfo('[{dungeon}] Ground absent de la zone : ' .. tostring(name))
  return 0
end

local RETURN_GROUND = {return_ground}

function {dungeon}.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = '{dungeon}'
end

function {dungeon}.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function {dungeon}.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function {dungeon}.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  if COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID) then return end
  SV.adventure.Thief = false
  SV.CanonicalDungeons = SV.CanonicalDungeons or {{}}

  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
    return
  end

{branches}
end

return {dungeon}
"""


PENDING_RE = re.compile(r"""Pending\s*==\s*['"]([A-Za-z0-9_]+)['"]""")


def _pending_key(ground: str, default: str) -> str:
    """Clé `SV.CanonicalDungeons.Pending` attendue par le script du Ground.

    Les scènes déjà écrites testent une clé précise ; le script de zone généré
    doit poser exactement celle-là, sinon la cinématique ne se déclenche pas.
    """
    text = _ground_script_text(ground)
    match = PENDING_RE.search(text)
    return match.group(1) if match else default


def _branch(exit_: SegmentExit, dungeon: str) -> str:
    head = f"  if segmentID == {exit_.segment} then" if exit_.segment == 0 \
        else f"  elseif segmentID == {exit_.segment} then"
    body = [f"    -- {exit_.reason}"]
    if exit_.kind == "ground":
        pending = _pending_key(exit_.target, f"{dungeon}_seg{exit_.segment}")
        body.append(f"    SV.CanonicalDungeons.Pending = '{pending}'")
        marker = ground_entry_marker(exit_.target)
        if marker:
            body.append(f"    GAME:EnterGroundMap('{exit_.target}', '{marker}')")
        else:
            body.append(f"    -- {exit_.target} ne porte aucun marqueur : la scène téléporte")
            body.append("    -- elle-même le joueur, on entre donc par index.")
            body.append(f"    GAME:EnterZone(zone.ID, -1, ZONE_GROUND_IDX(zone, '{exit_.target}'), 0)")
    elif exit_.kind == "zone":
        follow = 0 if exit_.target != dungeon else exit_.segment + 1
        body.append(f"    GAME:EnterDungeon('{exit_.target}', {follow}, 0, 0,")
        body.append("      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)")
    else:
        body.append(f"    SV.CanonicalDungeons['{dungeon}'] = true")
        body.append("    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, "
                    "GROUND_IDX(RETURN_GROUND), 0, true, true)")
    return head + "\n" + "\n".join(body)


def render_zone_script(wiring: DungeonWiring, definition: dict) -> str:
    branches = "\n".join(_branch(e, wiring.dungeon) for e in wiring.exits)
    branches += "\n  else\n    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, " \
                "GROUND_IDX(RETURN_GROUND), 0, true, true)\n  end"
    name = (definition.get("name") or {}).get("fr") or wiring.dungeon
    ret = f"'{wiring.entrance_ground}'" if wiring.entrance_ground else "'metano_town'"
    return LUA_TEMPLATE.format(
        marker=MARKER,
        title=name,
        dungeon=wiring.dungeon,
        chapter=definition.get("chapter", "?"),
        segments=wiring.segments,
        last=wiring.segments - 1,
        return_ground=ret,
        branches=branches,
    )


def apply(plan_result: Optional[WiringPlan] = None, *, defs: Optional[Dict[str, dict]] = None,
          write: bool = False) -> Dict[str, object]:
    """Écrit les scripts de zone et recâble les Grounds cassés."""
    defs = defs if defs is not None else load_definitions()
    result = plan_result or plan(defs)
    written: List[str] = []
    archived: List[str] = []
    patched: List[str] = []

    for wiring in result.dungeons:
        target = SCRIPT_ZONE / wiring.dungeon / "init.lua"
        content = render_zone_script(wiring, defs[wiring.dungeon])
        current = target.read_text(encoding="utf-8", errors="replace") if target.is_file() else ""
        if current.strip() == content.strip():
            continue
        if current and MARKER not in current:
            archive_dir = ARCHIVE / wiring.dungeon
            wiring.archived_script = str((archive_dir / "init.lua").relative_to(ROOT))
            if write:
                archive_dir.mkdir(parents=True, exist_ok=True)
                for lua in sorted(target.parent.glob("*.lua")):
                    shutil.copy2(lua, archive_dir / lua.name)
            archived.append(wiring.archived_script)
        if write:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(content, encoding="utf-8")
        written.append(str(target.relative_to(ROOT)))

    # Un même fichier peut porter plusieurs appels : on l'ouvre une seule fois.
    by_file: Dict[str, List[GroundFix]] = {}
    for fix in result.ground_fixes:
        by_file.setdefault(fix.path, []).append(fix)

    for rel_path, file_fixes in sorted(by_file.items()):
        path = ROOT / rel_path
        text = path.read_text(encoding="utf-8", errors="replace")
        original = text
        # On travaille de la fin vers le début pour ne pas décaler les offsets.
        for match in reversed(list(CALL_RE.finditer(text))):
            zone = match.group("zone")
            segment = int(match.group("segment"))
            floor = int(match.group("floor"))
            fix = next((f for f in file_fixes if f.old == (zone, segment, floor)), None)
            if fix is None:
                continue
            if fix.kind == "end_run":
                end = _call_span(text, match.start())
                if end < 0:
                    result.unresolved.append(f"{rel_path}: appel {zone} non refermé")
                    continue
                head = text.rfind("GAME:", 0, match.start())
                start = head if head >= 0 and head > match.start() - 8 else match.start()
                text = text[:start] + END_RUN_CALL + text[end:]
            else:
                new_zone, new_seg, new_floor = fix.new
                quote = match.group("q")
                replacement = (f"{match.group('call')}({quote}{new_zone}{quote}, "
                               f"{new_seg}, {new_floor}")
                text = text[:match.start()] + replacement + text[match.end():]
        if text == original:
            continue
        reasons = sorted({f.reason for f in file_fixes})
        header = "".join(f"-- [dungeon_builder] recâblage : {reason}\n" for reason in reasons)
        if header.split("\n")[0] not in text:
            text = header + text
        if write:
            path.write_text(text, encoding="utf-8")
        patched.append(rel_path)

    if write:
        _record_wiring(result, defs)

    generated_grounds: List[str] = []
    wirings = {w.dungeon: w for w in result.dungeons}
    for script in result.ground_scripts:
        wiring = wirings.get(script.dungeon)
        if wiring is None:
            continue
        target = SCRIPT_GROUND / script.ground / "init.lua"
        if target.is_file():
            continue
        if write:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(render_ground_script(script, wiring), encoding="utf-8")
        generated_grounds.append(str(target.relative_to(ROOT)))

    ground_maps = _sync_ground_maps(result, write=write)

    return {
        "ground_maps": ground_maps,
        "zone_scripts": written,
        "archived": archived,
        "ground_fixes": patched,
        "ground_scripts": generated_grounds,
        "unresolved": result.unresolved,
    }



def _sync_ground_maps(result: WiringPlan, *, write: bool) -> List[str]:
    """Déclare dans la zone les Grounds que son script appelle."""
    touched: List[str] = []
    for wiring in result.dungeons:
        path = ZONE_DIR / f"{wiring.dungeon}.json"
        if not path.is_file():
            continue
        payload = _read_json(path)
        obj = payload["Object"]
        grounds = list(obj.get("GroundMaps") or [])
        wanted = [e.target for e in wiring.exits if e.kind == "ground"]
        if wiring.entrance_ground:
            wanted.append(wiring.entrance_ground)
        missing = [g for g in wanted if g and g not in grounds]
        if not missing:
            continue
        obj["GroundMaps"] = grounds + missing
        if write:
            path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
                            encoding="utf-8-sig")
        touched.append(f"{wiring.dungeon}: +{', '.join(missing)}")
    return touched


def _record_wiring(result: WiringPlan, defs: Dict[str, dict]) -> None:
    fixes_by_dungeon: Dict[str, List[Dict[str, object]]] = {}
    for wiring in result.dungeons:
        grounds = {wiring.entrance_ground, wiring.relay_ground, wiring.end_ground}
        for fix in result.ground_fixes:
            ground = Path(fix.path).parent.name
            if ground in grounds:
                fixes_by_dungeon.setdefault(wiring.dungeon, []).append(fix.to_dict())

    for wiring in result.dungeons:
        path = DEF_DIR / f"{wiring.dungeon}.json"
        if not path.is_file():
            # sinister_woods.json porte l'id gloomy_forest
            candidates = [p for p in DEF_DIR.glob("*.json")
                          if _read_json(p).get("id") == wiring.dungeon]
            if not candidates:
                continue
            path = candidates[0]
        raw = _read_json(path)
        payload = wiring.to_dict()
        payload["ground_rebinds"] = fixes_by_dungeon.get(wiring.dungeon, [])
        # Le câblage est une donnée de premier niveau : il ne se cache ni dans
        # le code, ni dans l'inventaire narratif hérité.
        raw["wiring"] = payload
        _write_def(path, raw)


def report(result: WiringPlan) -> str:
    lines = ["# Câblage narratif des 51 donjons Ch.6-32", "",
             "Règle verrouillée : **Ground de cinématique = Ground du combat = Ground final "
             "canonique**. Boss internes (Buried Relic, Meteor Cave) = salle fixe `.rsmap` "
             "chargée en étage, jamais un Ground inventé.", "",
             "| Donjon | Segments | Sorties de segment | Suite | Ground final |", "|---|---|---|---|---|"]
    for wiring in result.dungeons:
        exits = " · ".join(f"{e.segment}→{e.kind}:{e.target}" for e in wiring.exits)
        lines.append(f"| `{wiring.dungeon}` | {wiring.segments} | {exits} | "
                     f"{wiring.next_zone or '—'} | {wiring.end_ground or '—'} |")
    lines += ["", f"## Recâblages de Grounds ({len(result.ground_fixes)})", ""]
    if result.ground_fixes:
        lines += ["| Script | Appel | Ancien | Nouveau | Raison |", "|---|---|---|---|---|"]
        for fix in result.ground_fixes:
            lines.append(f"| `{fix.path}` | {fix.call} | `{fix.old[0]}`/{fix.old[1]} | "
                         f"{(chr(96)+fix.new[0]+chr(96)+chr(47)+str(fix.new[1])) if fix.new else 'fin de run'} | {fix.reason} |")
    else:
        lines.append("Aucun.")
    if result.unresolved:
        lines += ["", "## Non résolu", ""] + [f"- {item}" for item in result.unresolved]
    return "\n".join(lines) + "\n"
