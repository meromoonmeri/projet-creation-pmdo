#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_future_arc.py — INTÉGRATION PMDO de l'arc du futur (33 scènes, dont D55).

Génère :
  - Data/Script/halcyon/future_arc/FutureCast.lua  : spawner du cast New Era
  - Data/Script/halcyon/future_arc/FutureArc.lua   : runner de l'arc
  - Data/Script/halcyon/future_arc/spawns.lua      : données de spawn (générées)
  - Data/Script/halcyon/future_arc/scene/*.lua     : les scènes (copiées/renommées)
  - Data/Script/halcyon/ground/<zone>/init.lua     : 8 grounds
  - enregistrement des 8 zones dans Data/Zone/master_zone.json

Chorégraphie 1:1 — seul le cast change (directive utilisateur).
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---

import json
import os
import shutil
import collections

DOCS = "/home/user/V4/docs"
OUT = "/tmp/v4work"
SCENES_SRC = os.path.join(DOCS, "lua_arc_futur")
SCENES_DST = os.path.join(OUT, "Data/Script/halcyon/future_arc/scene")
ARC_DIR = os.path.join(OUT, "Data/Script/halcyon/future_arc")
IR_DIR = os.path.join(DOCS, "ssb_ir")

# Ordre canonique des scènes par zone (33 scènes).
# Les enter00/enter01 = scènes d'entrée de zone (jouées en premier).
ORDER = {
    "P05P01A": ["enter00", "m17a0103", "m19a0102", "n08a2008"],
    "P05P02A": ["enter00", "enter01", "m17a0104", "m17a0201", "m17a0301"],
    "P05P03A": ["enter00", "m17a0302", "m26a06d3"],
    "P05P04A": ["enter00", "m17a0401", "m17a0403"],
    "P06P01A": ["enter00", "m18a0401", "m26a0614"],
    "P07P01A": ["m18b1401", "m26a06e6"],
    "P08P01A": ["enter00", "t02a0303", "m19a0601", "m19d0612",
                "n08a2308", "n08a2408", "n08a2508", "n08a2608"],
    "P09P01A": ["enter00", "m19b1001", "m19b1007", "m19b1009", "m19d1072"],
}
ZONES = list(ORDER.keys())
ZONE_LUA = {z: z.lower() for z in ZONES}

# scènes antagoniste -> Necrozma (règle validée)
ANTAGONIST = {
    "P05P03A_m17a0302", "P05P03A_m26a06d3",
    "P09P01A_m19b1001", "P09P01A_m19b1007", "P09P01A_m19b1009", "P09P01A_m19d1072",
}

# espèces PMDO par entité (cast New Era)
SPECIES = {
    "NPC_YONOWAARU": ("dusknoir", "Male", "Dusknoir"),
    "NPC_YONOWAARU_N8": ("dusknoir", "Male", "Dusknoir"),
    "NPC_JUPUTORU": ("grovyle", "Male", "Grovyle"),
    "NPC_SEREBII": ("celebi", "Genderless", "Celebi"),
    "NPC_MIKARUGE": ("spiritomb", "Unknown", "Spiritomb"),  # ミカルゲ = SPIRITOMB, boss canonique du Sealed Ruin Pit
    "NPC_YAMIRAMI": ("sableye", "Male", "Sableye_1"),
    "NPC_YAMIRAMI2": ("sableye", "Male", "Sableye_2"),
    "NPC_YAMIRAMI3": ("sableye", "Male", "Sableye_3"),
    "NPC_YAMIRAMI4": ("sableye", "Male", "Sableye_4"),
    "NPC_YAMIRAMI5": ("sableye", "Male", "Sableye_5"),
    "NPC_YAMIRAMI6": ("sableye", "Male", "Sableye_6"),
    "PLAYER_FUTURE": ("__HERO__", "Unknown", "HeroFuture"),
}

# scèneKey -> nom de fichier module (unique)
def scene_key(z, s):
    return f"{z}_{s}"

def module_name(z, s):
    return f"{z.lower()}_{s}"


def lua_dir(d):
    return {"Down": "Direction.Down", "DownRight": "Direction.DownRight",
            "Right": "Direction.Right", "UpRight": "Direction.UpRight",
            "Up": "Direction.Up", "UpLeft": "Direction.UpLeft",
            "Left": "Direction.Left", "DownLeft": "Direction.DownLeft"}.get(d, "Direction.Down")


def build_spawns():
    """Génère les spawns depuis les IR (cible la plus fréquente + SSA fallback)."""
    from skytemple_files.common.ppmdu_config.xml_reader import Pmd2XmlReader
    from skytemple_files.script.ssa_sse_sss.model import Ssa
    sd = Pmd2XmlReader.load_default()
    BASE = "/tmp/pret-pmd-sky/files/language-specific/US/SCRIPT"
    DIRS = {0:"Down",1:"DownRight",2:"Right",3:"UpRight",4:"Up",5:"UpLeft",6:"Left",7:"DownLeft"}
    out = {}
    for p in sorted(os.listdir(IR_DIR)):
        if not (p.endswith('.json') and '_' in p):
            continue
        if any(x in p for x in ('_summary','_graph','_coverage','_spawns','_ssa_positions')):
            continue
        ir = json.load(open(os.path.join(IR_DIR, p)))
        z, s = ir['zone'], ir['scene']
        key = f"{z}_{s}"
        # contexte acteur
        ctx = {}; cur = None
        for op in ir['ops']:
            if op['name'] == 'lives':
                cur = op['resolved'][0] if isinstance(op['resolved'][0], str) else None
            ctx[op['seq']] = cur
        actors = sorted(set(v for v in ctx.values() if v))
        # + les locuteurs (message_SetFace/message_SetActor) — ex. SPIRITOMB
        for op in ir['ops']:
            if op['name'] in ('message_SetFace','message_SetActor'):
                for x in op.get('arg_specs', []):
                    if x['type'] == 'Entity' and isinstance(x['resolved'], str):
                        actors.append(x['resolved'])
        actors = sorted(set(actors))
        targets = collections.defaultdict(list)
        turn_dir = {}
        for op in ir['ops']:
            n = op['name']
            a = ctx.get(op['seq'])
            if a is None: continue
            if n in ('MovePositionMark','Move2PositionMark','SlidePositionMark','SetPositionMark'):
                pm = None
                for x in op.get('arg_specs', []):
                    if x['type'] == 'PositionMark': pm = x['resolved']
                if pm:
                    tx = pm['x_relative']*8 + (4 if pm['x_offset']>1 else 0)
                    ty = pm['y_relative']*8 + (4 if pm['y_offset']>1 else 0)
                    targets[a].append((tx, ty))
            if n == 'Turn2Direction' and a not in turn_dir:
                for x in op.get('arg_specs', []):
                    if x['type'] == 'Direction': turn_dir[a] = DIRS.get(x['raw'], 'Down')
        # SSA fallback
        ssa_pos = {}
        import os as _os
        ssa_path = f"{BASE}/{z}/{s}.ssa"
        if _os.path.exists(ssa_path):
            try:
                ssa = Ssa(sd.script_data, open(ssa_path,'rb').read())
                best = None; bs = -1
                for layer in ssa.layer_list:
                    names = {a.actor.name for a in layer.actors}
                    sc = len(names & set(actors))
                    if sc > bs: bs = sc; best = layer
                if best:
                    for a in best.actors:
                        pp = a.pos
                        ssa_pos[a.actor.name] = (pp.x_relative*8 + (4 if pp.x_offset>1 else 0),
                                                 pp.y_relative*8 + (4 if pp.y_offset>1 else 0))
            except Exception:
                pass
        spawns = {}
        for act in actors:
            tg = targets.get(act, [])
            if tg:
                x, y = collections.Counter(tg).most_common(1)[0][0]
            elif act in ssa_pos:
                x, y = ssa_pos[act]
            else:
                continue
            spawns[act] = {"x": x, "y": y, "dir": turn_dir.get(act, "Down")}
        out[key] = spawns
    return out


def main():
    spawns = build_spawns()
    os.makedirs(SCENES_DST, exist_ok=True)
    os.makedirs(ARC_DIR, exist_ok=True)

    # ---------- 1. copies des 33 scènes (renommées en <zone>_<scene>) ----------
    n_copied = 0
    for z, scs in ORDER.items():
        for s in scs:
            src = os.path.join(SCENES_SRC, f"{z}_{s}.lua")
            dst = os.path.join(SCENES_DST, f"{module_name(z,s)}.lua")
            if not os.path.exists(src):
                print("MANQUANT:", src); continue
            shutil.copy(src, dst)
            n_copied += 1
    print("scènes copiées:", n_copied)

    # ---------- 2. spawns.lua ----------
    lines = ["-- Généré par tools/gen_future_arc.py (données canoniques SSB/SSA).",
             "FutureCast_SPAWNS = {"]
    # Toutes les scènes des IR (arc P05-P09 + donjons D18-D22 dont SPIRITOMB)
    all_keys = set(spawns.keys())
    for z, scs in ORDER.items():
        for s in scs:
            key = f"{z}_{s}"
            sp = spawns.get(key, {})
            lines.append(f"  ['{key}'] = {{")
            for ent, info in sp.items():
                spc = SPECIES.get(ent, ("dusknoir", "Unknown", ent))
                lines.append(f"    ['{ent}'] = {{ species='{spc[0]}', gender='{spc[1]}', "
                             f"name='{spc[2]}', x={info['x']}, y={info['y']}, dir={lua_dir(info['dir'])} }},")
            lines.append("  },")
    for key in sorted(all_keys):
        if key in set(f"{z}_{s}" for z in ORDER for s in ORDER[z]):
            continue
        sp = spawns.get(key, {})
        lines.append(f"  ['{key}'] = {{")
        for ent, info in sp.items():
            spc = SPECIES.get(ent, ("dusknoir", "Unknown", ent))
            lines.append(f"    ['{ent}'] = {{ species='{spc[0]}', gender='{spc[1]}', "
                         f"name='{spc[2]}', x={info['x']}, y={info['y']}, dir={lua_dir(info['dir'])} }},")
        lines.append("  },")
    lines.append("}")
    lines.append("")
    lines.append("return FutureCast_SPAWNS")
    open(os.path.join(ARC_DIR, "spawns.lua"), "w", encoding="utf-8").write("\n".join(lines) + "\n")

    # ---------- 3. FutureCast.lua ----------
    ant = "\n".join(f"  ['{k}'] = true," for k in sorted(ANTAGONIST))
    cast_lua = """--[[
    FutureCast.lua — SPAWNER DU CAST NEW ERA (arc du futur).

    Chorégraphie 1:1 (directive utilisateur) : les personnages sont placés aux
    positions canoniques (SSB/SSA), seuls les ACTEURS sont New Era :
      Dusknoir / Grovyle (alliés du futur), Sableye (sbires de Necrozma),
      Celebi, héros/partenaire ; dans les scènes où l'acteur original joue le
      rôle d'ANTAGONISTE -> Necrozma (ANTAGONIST_SCENES).
    HeroFuture copie l'espèce du héros (le héros du futur, 30 ans plus tard).
]]
require 'origin.common'

FutureCast = {}

FutureCast.ANTAGONIST = {
%s
}

FutureCast.SPAWNS = require 'halcyon.future_arc.spawns'.FutureCast_SPAWNS

-- Crée un personnage au sol (nom explicite -> CH(name) fonctionne).
function FutureCast.Create(species, gender, name, x, y, dir)
  local g = RogueEssence.Data.Gender
  local monster = RogueEssence.Dungeon.MonsterID(species, 0, 'normal', g[gender])
  local chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(x, y), dir, name, name)
  chara:ReloadEvents()
  GAME:GetCurrentGround():AddTempChar(chara)
  chara:OnMapInit()
  AI:DisableCharacterAI(chara)
  return chara
end

-- Place le cast de la scène. Retourne la table nom -> chara.
function FutureCast.Spawn(sceneKey)
  local sp = FutureCast.SPAWNS[sceneKey]
  if sp == nil then return {} end
  local out = {}
  local hero = CH('PLAYER')
  local heroSpecies = 'bulbasaur'
  if hero ~= nil then heroSpecies = hero.CurrentForm.Species end
  local antagoniste = FutureCast.ANTAGONIST[sceneKey] == true
  for ent, info in pairs(sp) do
    -- PLAYER/ATTENDANT1 = l'équipe du joueur : téléportés plus bas, pas créés
    if ent == 'PLAYER' or ent == 'ATTENDANT1' then
      goto continue
    end
    local species = info.species
    local gender = info.gender
    local name = info.name
    if species == '__HERO__' then
      species = heroSpecies
    end
    if antagoniste and (ent == 'NPC_YONOWAARU' or ent == 'NPC_YONOWAARU_N8') then
      species, gender, name = 'necrozma', 'Genderless', 'Necrozma'
    end
    local c = FutureCast.Create(species, gender, name, info.x, info.y, info.dir)
    out[name] = c
    ::continue::
  end
  -- héros + partenaire : téléportés à leur position canonique
  local heroPos = sp['PLAYER']
  local partPos = sp['ATTENDANT1']
  if heroPos ~= nil and hero ~= nil then
    GROUND:TeleportTo(hero, heroPos.x, heroPos.y)
  end
  local partner = CH('Teammate1')
  if partPos ~= nil and partner ~= nil then
    GROUND:TeleportTo(partner, partPos.x, partPos.y)
  end
  return out
end

return FutureCast
""" % ant
    open(os.path.join(ARC_DIR, "FutureCast.lua"), "w", encoding="utf-8").write(cast_lua)

    # ---------- 4. FutureArc.lua (runner, 33 scènes) ----------
    seq_lines = []
    for z in ZONES:
        for s in ORDER[z]:
            seq_lines.append(f"  {{ ground='{ZONE_LUA[z]}', scene='{module_name(z,s)}' }},")
    sequence = "\n".join(seq_lines)
    runner = """--[[
    FutureArc.lua — ARC DU FUTUR (PMD Sky, arc des 8 zones, cast New Era).

    Reproduction 1:1 des cinématiques canoniques de Sky (P05P01A..P09P01A).
    Chorégraphie, positions, timings, animations, caméra, fades, SFX, BGM,
    transitions, flags, embranchements : intacts. Seul le CAST change
    (FutureCast). Les 33 scènes (dont les entrées de zone enter00/enter01 et
    la scène visuelle t02a0303) se jouent dans l'ordre canonique, enchaînées
    sur chaque ground, puis le passage au ground suivant.
]]
require 'origin.common'
require 'halcyon.future_arc.FutureCast'

FutureArc = {}

FutureArc.SEQUENCE = {
%s
}

FutureArc.INDEX = {}
FutureArc.BY_GROUND = {}
for i, step in ipairs(FutureArc.SEQUENCE) do
  FutureArc.INDEX[step.scene] = i
  if FutureArc.BY_GROUND[step.ground] == nil then FutureArc.BY_GROUND[step.ground] = {} end
  table.insert(FutureArc.BY_GROUND[step.ground], step)
end
FutureArc.NEXT_GROUND = {}
for i, step in ipairs(FutureArc.SEQUENCE) do
  if i < #FutureArc.SEQUENCE then
    FutureArc.NEXT_GROUND[step.ground] = FutureArc.SEQUENCE[i + 1].ground
  end
end

-- Démarre l'arc : entre dans le premier ground (p05p01a, repaire de Necrozma).
function FutureArc.Begin()
  DEBUG.EnableDbgCoro()
  if SV.FutureArc == nil then SV.FutureArc = {} end
  SV.FutureArc.Step = 1
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:EnterGroundMap(FutureArc.SEQUENCE[1].ground, 'Main_Entrance_Marker')
end

-- Joue toutes les scènes du ground courant puis passe au suivant.
function FutureArc.Play(ground)
  DEBUG.EnableDbgCoro()
  local steps = FutureArc.BY_GROUND[ground]
  if steps == nil then
    PrintInfo('[FutureArc] ground inconnu : ' .. tostring(ground))
    GAME:FadeIn(20)
    return
  end
  if SV.FutureArc == nil then SV.FutureArc = {} end
  if SV.FutureArc.Step == nil then SV.FutureArc.Step = 1 end
  local ok, err = pcall(function()
    for i = SV.FutureArc.Step, #steps, 1 do
      local step = steps[i]
      SV.FutureArc.Step = i
      -- place le cast New Era aux positions canoniques
      FutureCast.Spawn(step.scene)
      -- joue la scène (module Lua, chorégraphie 1:1)
      local mod = require('halcyon.future_arc.scene.' .. step.scene)
      if mod ~= nil and mod.Cutscene ~= nil then
        mod.Cutscene()
      end
      GAME:WaitFrames(10)
    end
    SV.FutureArc.Step = 1
    -- transition vers le ground suivant
    local nextGround = FutureArc.NEXT_GROUND[ground]
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    if nextGround ~= nil then
      GAME:EnterGroundMap(nextGround, 'Main_Entrance_Marker')
    else
      -- fin de l'arc du futur (à brancher sur la suite du chapitre)
      SV.FutureArc.Completed = true
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
      PrintInfo('[FutureArc] arc du futur terminé')
    end
  end)
  if not ok then
    PrintInfo('[FutureArc] interrompu sur ' .. tostring(ground) .. ' : ' .. tostring(err))
    pcall(function()
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end)
  end
end

-- Entrée dans le donjon D55 (Passage du Temps) depuis P08P01A.
-- Appelé par la fin de la scène n08a2308 (l'embuscade).
function FutureArc.EnterDungeon55()
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:EnterDungeon('passage_temps', 1, 0, false)
  GAME:FadeIn(20)
end

return FutureArc
""" % sequence
    open(os.path.join(ARC_DIR, "FutureArc.lua"), "w", encoding="utf-8").write(runner)

    # ---------- 5. init.lua des 8 grounds ----------
    for z in ZONES:
        gl = ZONE_LUA[z]
        d = os.path.join(OUT, "Data/Script/halcyon/ground", gl)
        os.makedirs(d, exist_ok=True)
        init = """--[[ {gl} — Arc du futur (PMD Sky, cast New Era).
     Ground pixel-perfect du port PMD-SKY-PMDO-PORT. La cinématique est jouée
     par FutureArc.Play (chorégraphie 1:1, cast New Era). ]]
require 'origin.common'
require 'halcyon.future_arc.FutureArc'

local {gl} = {{}}

function {gl}.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function {gl}.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  FutureArc.Play('{gl}')
end

function {gl}.Update(map) end
function {gl}.GameSave(map) end
function {gl}.GameLoad(map)
  GAME:FadeIn(20)
end

return {gl}
""".format(gl=gl)
        open(os.path.join(d, "init.lua"), "w", encoding="utf-8").write(init)
    print("init.lua écrits:", len(ZONES))

    # ---------- 6. enregistrement des zones ----------
    zj = os.path.join(OUT, "Data/Zone/master_zone.json")
    d = json.load(open(zj, encoding="utf-8"))
    gm = d["Object"]["GroundMaps"]
    added = [ZONE_LUA[z] for z in ZONES if ZONE_LUA[z] not in gm]
    d["Object"]["GroundMaps"] = gm + added
    json.dump(d, open(zj, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    print("zones ajoutées à master_zone:", added)

    print("CÂBLAGE TERMINÉ —", n_copied, "scènes")


if __name__ == "__main__":
    main()
