"""Portage des cinématiques canoniques PMD Red sur leurs Grounds.

Constat à l'origine de ce module
--------------------------------
Les Grounds de PMD Red importés dans le mod (entrées, relais, arènes) ont été
récrits par des passes précédentes avec des cinématiques **inventées** :
« Veilleurs du Réseau des Anciens Chemins » et « cinématiques d'Ancrage
(Livre II) ». Résultat : des combats de boss apparaissaient dans des Grounds
d'**entrée** de donjon (`foret_tendre_oree`, `pic_ferreux_pied`,
`mont_grondant_pied`, `gouffre_muet_bord`, `grotte_statique_seuil`,
`bois_sombres_oree`) et de **relais** (`palier_celeste`), alors que le canon
n'y met aucun combat : dans PMD Red les boss sont soit à la scène de fin
(D06P03 Zapdos, D09P03 Moltres, D10P03 Articuno…), soit dans le donjon
lui-même (`src/dungeon_boss_dialogue.c`, `src/dungeon_cutscene_*.c`).

Ce que fait ce module
---------------------
Il régénère chaque Ground canonique du périmètre à partir du **squelette de
scène extrait de la ROM** (`RESERVE/red_scene_reference/<scene>.lua` : musique,
suite de dialogues, actions), et n'écrit aucune ligne de dialogue inventée :
les répliques sont des clés `SCENE_<ID>_<n>` du texte de la ROM. Tant que ces
clés ne sont pas importées (elles exigent la ROM EU de l'utilisateur, cf.
`tools/audit_pmdred_eu_rom.py`), la ligne est simplement sautée — la scène ne
raconte donc rien de faux.

La correspondance Ground ↔ scène ROM et le rôle (entrée / relais / fin) sont
ceux de `docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md`, lui-même issu de
`pmd_red_index.json` (map_id ENTRY/MID/END).
"""
from __future__ import annotations

import json
import re
import shutil
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Tuple

ROOT = Path(__file__).resolve().parents[2]
SCENE_REF = ROOT / "RESERVE" / "red_scene_reference"
SCENE_CIF = ROOT / "RESERVE" / "red_cinematics"
SCRIPT_GROUND = ROOT / "Data" / "Script" / "halcyon" / "ground"
GROUND_DIR = ROOT / "Data" / "Ground"
STRINGS_DIR = ROOT / "Strings"
ARCHIVE = ROOT / "RESERVE" / "legacy_ch6_32" / "invented_scenes"

MARKER = "-- [dungeon_builder] scène canonique PMD Red"

#: Ground du mod -> (scène ROM, rôle canonique).
#: Source : docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md §1 et §2.
CANON_SCENES: Dict[str, Tuple[str, str]] = {
    # D01-D13 : entrée / relais / fin
    "foret_tendre_oree": ("d01p01", "entrance"),
    "d01p02": ("d01p02", "end"),
    "grotte_statique_seuil": ("d02p01", "entrance"),
    "d02p02": ("d02p02", "end"),
    "pic_ferreux_pied": ("d03p01", "entrance"),
    "d03p02": ("d03p02", "end"),
    "bois_sombres_oree": ("d04p01", "entrance"),
    "gouffre_muet_bord": ("d05p01", "entrance"),
    "d05p02": ("d05p02", "end"),
    "mont_grondant_pied": ("d06p01", "entrance"),
    "d06p02": ("d06p02", "relay"),
    "d06p03": ("d06p03", "end"),
    "grand_canyon_porte": ("d07p01", "entrance"),
    "d07p02": ("d07p02", "end"),
    "grotte_lazuli_seuil": ("d08p01", "entrance"),
    "grotte_lazuli_fond": ("d08p02", "end"),
    "mont_cendre_pied": ("d09p01", "entrance"),
    "d09p02": ("d09p02", "relay"),
    "d09p03": ("d09p03", "end"),
    "foret_givree_oree": ("d10p01", "entrance"),
    "d10p02": ("d10p02", "relay"),
    "d10p03": ("d10p03", "end"),
    "mont_gele_pied": ("d11p01", "entrance"),
    "d11p02": ("d11p02", "relay"),
    "d11p03": ("d11p03", "end"),
    "gorge_ardente_porte": ("d12p01", "entrance"),
    "gorge_ardente_coeur": ("d12p02", "relay"),
    "fosse_ardente": ("d12p04", "end"),
    "arc_parvis_celeste": ("d13p01", "entrance"),
    "arc_palier_celeste": ("d13p02", "relay"),
    "arc_tour_ciel_sommet": ("d13p03", "end"),
    # D14-D25 : arènes de post-game (aucune entrée dans la source)
    "abime_tempetes": ("d14p01", "end"),
    "fosse_argentee": ("d15p01", "end"),
    "champ_braises": ("d16p01", "end"),
    "champ_foudre": ("d17p01", "end"),
    "champ_vent_boreal": ("d18p01", "end"),
    "sommet_aurore": ("d19p01", "end"),
    "antre_occident": ("d20p01", "end"),
    "cretes_boreales": ("d21p01", "end"),
    "vallon_perdu": ("d22p01", "end"),
    "sanctuaire_voeu": ("d23p01", "end"),
    "caverne_trouble_fond": ("d24p01", "end"),
    "caverne_trouble_autel": ("d24p02", "end"),
    "bois_des_plaintes": ("d25p01", "end"),
}

#: Marqueurs de contenu inventé : cinématiques de « Veilleur » / d'« Ancrage ».
INVENTED_MARKERS = ("Veilleur", "Ancrage", "BossFX", "BossMusic", "BossTransition",
                    "MakeCharactersFromList")

DIALOGUE_RE = re.compile(r'STRINGS:FormatKey\("([A-Z0-9_]+)"\)')


def _normalise(name: str) -> str:
    # les pistes du script ROM sont des symboles « MUS_MT_THUNDER »
    name = re.sub(r"^MUS_", "", name)
    return re.sub(r"[^a-z0-9]", "", name.lower())


def available_music() -> Dict[str, str]:
    """Titres de musique réellement présents (mod + jeu de base)."""
    found: Dict[str, str] = {}
    listing = Path(__file__).resolve().parent / "data" / "base_music.txt"
    if listing.is_file():
        for line in listing.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if line and not line.startswith("#"):
                found[_normalise(line)] = line
    mod_music = ROOT / "Content" / "Music"
    if mod_music.is_dir():
        for path in mod_music.iterdir():
            found[_normalise(path.stem)] = path.stem
    return found


def resolve_music(name: str) -> str:
    """Nom de piste réel correspondant au titre du squelette ROM.

    Les squelettes citent la piste sans ponctuation (« Mt Thunder ») alors que
    le fichier s'appelle « Mt. Thunder.ogg ». On rapproche les deux par
    normalisation ; sans correspondance, on ne joue rien plutôt que d'inventer.
    """
    if not name:
        return ""
    return available_music().get(_normalise(name), "")
BGM_RE = re.compile(r"GAME:PlayBGM\('([^']+)'")


@dataclass
class ScenePort:
    ground: str
    scene: str
    role: str
    lines: List[str] = field(default_factory=list)
    music: str = ""
    music_wanted: str = ""
    events: List[dict] = field(default_factory=list)
    undecoded: int = 0
    invented_before: bool = False
    archived: str = ""

    def to_dict(self) -> Dict[str, object]:
        return dict(self.__dict__)


def available_string_keys() -> set:
    """Clés de dialogue réellement présentes dans les Strings du mod."""
    keys: set = set()
    if not STRINGS_DIR.is_dir():
        return keys
    for path in STRINGS_DIR.glob("*.resx"):
        text = path.read_text(encoding="utf-8", errors="replace")
        keys.update(re.findall(r'name="([A-Z0-9_]+)"', text))
    return keys


def read_reference_raw(scene: str) -> Tuple[List[str], str]:
    """Dialogues (clés, dans l'ordre) et musique du squelette ROM."""
    path = SCENE_REF / f"{scene}.lua"
    if not path.is_file():
        return [], ""
    text = path.read_text(encoding="utf-8", errors="replace")
    music = ""
    match = BGM_RE.search(text)
    if match:
        music = match.group(1)
    return DIALOGUE_RE.findall(text), music


def read_sequence(scene: str) -> Tuple[List[dict], str, int]:
    """Séquence canonique complète extraite de la ROM.

    `RESERVE/red_cinematics/<scene>.cif.json` donne l'ordre exact des
    évènements du script d'origine : Dialog, Audio (SWITCH/FADEOUT), Effect
    (SHAKE), Camera (INIT_PAN), Animation (anim_id). Les clés de dialogue
    viennent du squelette `RESERVE/red_scene_reference/<scene>.lua`, dans le
    même ordre.
    """
    keys, wanted = read_reference_raw(scene)
    path = SCENE_CIF / f"{scene}.cif.json"
    if not path.is_file():
        return ([{"t": "msg", "key": k} for k in keys], resolve_music(wanted), 0)
    raw = json.loads(path.read_text(encoding="utf-8")).get("raw_sequence", [])
    events: List[dict] = []
    undecoded = 0
    dialogue = list(keys)
    for item in raw:
        kind = item.get("type")
        action = item.get("action")
        if kind == "Dialog":
            if dialogue:
                events.append({"t": "msg", "key": dialogue.pop(0)})
            else:
                undecoded += 1
        elif kind == "Audio" and action == "SWITCH":
            track = resolve_music(item.get("track", "") or "")
            events.append({"t": "bgm", "track": track})
            if not track:
                undecoded += 1
        elif kind == "Audio" and action == "FADEOUT":
            events.append({"t": "bgm_fade", "frames": int(item.get("frames") or 30)})
        elif kind == "Effect" and action == "SHAKE":
            events.append({"t": "shake", "frames": int(item.get("frames") or 30)})
        elif kind == "Camera":
            events.append({"t": "camera", "action": str(action)})
            undecoded += 1
        elif kind == "Animation":
            events.append({"t": "anim", "id": str(item.get("anim_id"))})
            undecoded += 1
        else:
            undecoded += 1
    for key in dialogue:            # sécurité : aucune réplique perdue
        events.append({"t": "msg", "key": key})
    return events, resolve_music(wanted), undecoded


def read_reference(scene: str) -> Tuple[List[str], str, str]:
    lines, wanted = read_reference_raw(scene)
    return lines, resolve_music(wanted), wanted


def is_invented(ground: str) -> bool:
    directory = SCRIPT_GROUND / ground
    if not directory.is_dir():
        return False
    for lua in directory.glob("*.lua"):
        text = lua.read_text(encoding="utf-8", errors="replace")
        if MARKER in text:
            return False
        if any(token in text for token in INVENTED_MARKERS):
            return True
    return False


LUA_TEMPLATE = '''{marker} — scène {scene} ({role}).
--[[ {ground} — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/{scene}.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_{upper}_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : {role_fr} (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     {boss_note}
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local {var} = {{}}

local SCENE = '{scene}'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/{scene}.cif.json).
local EVENTS = {{
{events}
}}

function {var}.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function {var}.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
{transition}
end

function {var}.Update(map) end
function {var}.GameSave(map) end
function {var}.GameLoad(map)
  GAME:FadeIn(20)
end

return {var}
'''

ROLE_FR = {"entrance": "entrée du donjon — aucun combat",
           "relay": "relais de mi-parcours — aucun combat",
           "end": "scène de fin / arène du donjon"}


def transition_for(ground: str, role: str, wiring_index: Dict[str, dict]) -> str:
    """Suite du parcours, telle que le câblage la définit."""
    info = wiring_index.get(ground)
    if info is None:
        return ("  -- aucune suite câblée : la scène rend la main au jeu\n"
                "  GAME:CutsceneMode(false)")
    kind, target, marker = info["kind"], info["target"], info.get("marker")
    if kind == "enter_zone":
        segment = info.get("segment", 0)
        return ("  GAME:CutsceneMode(false)\n"
                "  GAME:FadeOut(false, 30)\n"
                f"  GAME:EnterDungeon('{target}', {segment}, 0, 0,\n"
                "    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)")
    return ("  GAME:CutsceneMode(false)\n"
            "  SV.CanonicalDungeons = SV.CanonicalDungeons or {}\n"
            f"  SV.CanonicalDungeons['{target}'] = true\n"
            "  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,\n"
            "    'master_zone', -1, 1, 0, true, true)")


def plan(wiring_index: Optional[Dict[str, dict]] = None) -> List[ScenePort]:
    wiring_index = wiring_index or {}
    ports: List[ScenePort] = []
    for ground, (scene, role) in sorted(CANON_SCENES.items()):
        if not (GROUND_DIR / f"{ground}.rsground").is_file():
            continue
        lines, music, wanted = read_reference(scene)
        events, _music, undecoded = read_sequence(scene)
        ports.append(ScenePort(ground=ground, scene=scene, role=role, lines=lines,
                               music=music, music_wanted=wanted, events=events,
                               undecoded=undecoded, invented_before=is_invented(ground)))
    return ports


def _render_events(port: ScenePort) -> str:
    rows = []
    for ev in port.events:
        if ev["t"] == "msg":
            rows.append(f"  {{t='msg', key='{ev['key']}'}},")
        elif ev["t"] == "bgm":
            track = ev.get("track") or ""
            rows.append(f"  {{t='bgm', track='{track}'}},")
        elif ev["t"] == "bgm_fade":
            rows.append(f"  {{t='bgm_fade', frames={ev.get('frames', 30)}}},")
        elif ev["t"] == "shake":
            rows.append(f"  {{t='shake', frames={ev.get('frames', 30)}}},")
        elif ev["t"] == "camera":
            rows.append(f"  {{t='camera', action='{ev.get('action')}'}},")
        elif ev["t"] == "anim":
            rows.append(f"  {{t='anim', id='{ev.get('id')}'}},")
    return "\n".join(rows)


def render(port: ScenePort, wiring_index: Dict[str, dict]) -> str:
    var = port.ground if not port.ground[0].isdigit() else f"g_{port.ground}"
    boss = ""
    if port.role in ("entrance", "relay"):
        boss = ("Aucun boss ici : dans PMD Red les combats de gardien se jouent à la\n"
                "     scène de fin du donjon ou dans le donjon lui-même.")
    return LUA_TEMPLATE.format(
        marker=MARKER, scene=port.scene, role=port.role, ground=port.ground,
        upper=port.scene.upper(), role_fr=ROLE_FR[port.role], boss_note=boss, var=var,
        events=_render_events(port),
        transition=transition_for(port.ground, port.role, wiring_index))


def apply(wiring_index: Dict[str, dict], *, write: bool = False) -> Dict[str, object]:
    ports = plan(wiring_index)
    written, archived, skipped = [], [], []
    known = available_string_keys()
    missing_text = 0
    for port in ports:
        target = SCRIPT_GROUND / port.ground / "init.lua"
        content = render(port, wiring_index)
        current = target.read_text(encoding="utf-8", errors="replace") if target.is_file() else ""
        missing_text += sum(1 for key in port.lines if key not in known)
        if current.strip() == content.strip():
            skipped.append(port.ground)
            continue
        if current and MARKER not in current:
            destination = ARCHIVE / port.ground
            port.archived = str((destination / "init.lua").relative_to(ROOT))
            if write:
                destination.mkdir(parents=True, exist_ok=True)
                for lua in sorted(target.parent.glob("*.lua")):
                    shutil.copy2(lua, destination / lua.name)
            archived.append(port.archived)
        if write:
            target.parent.mkdir(parents=True, exist_ok=True)
            for lua in sorted(target.parent.glob("*.lua")):
                if lua.name != "init.lua":
                    lua.unlink()
            target.write_text(content, encoding="utf-8")
        written.append(str(target.relative_to(ROOT)))
    return {"ports": ports, "written": written, "archived": archived,
            "unchanged": skipped, "missing_text_keys": missing_text}


def report(result: Dict[str, object]) -> str:
    ports: List[ScenePort] = result["ports"]  # type: ignore[assignment]
    known = available_string_keys()
    lines = [
        "# Cinématiques canoniques PMD Red", "",
        "Chaque Ground canonique rejoue la scène de la ROM (structure extraite dans "
        "`RESERVE/red_scene_reference/`). Aucune réplique inventée : les dialogues sont "
        "les clés `SCENE_*` du texte de la ROM.", "",
        "Les cinématiques inventées qui occupaient ces Grounds (« Veilleurs du Réseau des "
        "Anciens Chemins », « cinématiques d'Ancrage ») sont archivées sous "
        "`RESERVE/legacy_ch6_32/invented_scenes/`.", "",
        "| Ground | Scène ROM | Rôle canonique | Évènements ROM | Répliques | Texte importé | Non décodés | Scène inventée avant |",
        "|---|---|---|---|---|---|---|---|",
    ]
    for port in ports:
        have = sum(1 for key in port.lines if key in known)
        lines.append(f"| `{port.ground}` | `{port.scene.upper()}` | {ROLE_FR[port.role]} | "
                     f"{len(port.events)} | {len(port.lines)} | {have}/{len(port.lines)} | "
                     f"{port.undecoded} | {'oui' if port.invented_before else 'non'} |")
    absent = sorted({p.music_wanted for p in ports if p.music_wanted and not p.music})
    if absent:
        lines += ["", "## Pistes de la ROM non importées dans le mod", "",
                  "Ces titres sont ceux des scènes de la ROM ; leur fichier audio n'existe pas "
                  "dans `Content/Music` (ni côté jeu de base). La scène se joue alors sans "
                  "changer la musique — aucun titre de remplacement n'est inventé.", ""]
        lines += [f"- `{name}`" for name in absent]
        lines.append("")

    total_lines = sum(len(p.lines) for p in ports)
    have_lines = sum(1 for p in ports for k in p.lines if k in known)
    lines += ["",
              f"**{len(ports)} Grounds canoniques**, {total_lines} répliques canoniques "
              f"référencées, {have_lines} dont le texte est présent dans `Strings/`.", "",
              "Le texte des répliques appartient à la ROM et n'est pas redistribué dans ce "
              "dépôt : importez-le depuis votre ROM EU avec `tools/audit_pmdred_eu_rom.py`, "
              "puis `tools/import_red_scene_strings.py`. Tant qu'une clé manque, la réplique "
              "est sautée en jeu — rien n'est inventé à la place.", ""]
    return "\n".join(lines)
