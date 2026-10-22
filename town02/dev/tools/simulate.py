#!/usr/bin/env python3
"""Exécute réellement la logique Lua du mod dans un moteur RogueEssence simulé.

On ne relit pas le code : on le charge dans Lupa avec des stubs qui enregistrent
chaque appel moteur (EnterZone, EnterGroundMap, ContinueDungeon, EndDungeonRun...),
puis on rejoue les 3 scénarios demandés et on vérifie l'enchaînement obtenu.
"""
import os, sys, json
import lupa
from lupa import LuaRuntime

ROOT = os.environ.get('MOD_ROOT', os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
S = os.path.join(ROOT, 'Data/Script/halcyon')

class Engine:
    def __init__(self):
        self.log = []
        self.frames = 0
    def rec(self, kind, *a):
        self.log.append((kind, a))
        return None

def build(scenario_setup):
    """Construit un environnement Lua avec les stubs moteur + scriptvars du mod."""
    L = LuaRuntime(unpack_returned_tuples=True)
    eng = Engine()
    g = L.globals()

    # --- table de log accessible depuis Lua
    def rec(kind, *a):
        eng.log.append((kind, [x for x in a]))
    g.PYREC = rec

    # --- squelette moteur en Lua pur : chaque appel se journalise
    L.execute(r"""
local function mk(ns, names)
  local t = {}
  for _, n in ipairs(names) do
    t[n] = function(self, ...) PYREC(ns.."."..n, ...) end
  end
  -- toute méthode non prévue renvoie un stub journalisé (évite les nil)
  return setmetatable(t, {__index=function(tab, k)
    local f = function(self, ...) PYREC(ns.."."..k, ...) return 0 end
    rawset(tab, k, f)
    return f
  end})
end

GAME = mk("GAME", {"EnterZone","EnterGroundMap","EnterDungeon","ContinueDungeon",
  "EndDungeonRun","WaitFrames","FadeIn","FadeOut","CutsceneMode","MoveCamera",
  "UnlockDungeon","DungeonUnlocked","SetRescueAllowed","GetCurrentGround",
  "GetPlayerPartyMember","GetPlayerMoney","RemoveFromPlayerMoney","GetCurrentZone"})
GROUND = mk("GROUND", {"TeleportTo","MoveToPosition","MoveInDirection","CharSetAnim",
  "CharEndAnim","CharSetEmote","CharAnimateTurnTo","CharTurnToChar","CharTurnToCharAnimated",
  "Hide","Unhide","AddMapStatus","RemoveMapStatus","CharSetAction","EntTurn","PlayVFX",
  "ObjectSetAnim","ObjectSetDefaultAnim"})
UI = mk("UI", {"WaitShowDialogue","ShowDialogue","WaitShowTimedDialogue","SetSpeaker",
  "SetSpeakerEmotion","ResetSpeaker","BeginChoiceMenu","WaitForChoice","ChoiceMenuYesNo",
  "WaitShowTitle","WaitHideTitle","WaitShowBG","WaitHideBG","SetAutoFinish","SetCenter",
  "WaitShowVoiceOver","DestinationMenu","SetChoiceLoc","SetSpeakerName"})
SOUND = mk("SOUND", {"PlayBGM","StopBGM","FadeOutBGM","PlayBattleSE","PlaySE","LoopSE","FadeOutSE"})
AI = mk("AI", {"DisableCharacterAI","EnableCharacterAI","SetCharacterAI"})
DEBUG = mk("DEBUG", {"EnableDbgCoro"})
TASK = {}
function TASK:BranchCoroutine(f) if type(f)=="function" then local ok,e=pcall(f) end return {} end
function TASK:JoinCoroutines(t) end
function TASK:WaitTask(t) end
MISSION_GEN = { SortTaken=function() end, DIFF_TO_MONEY={} }

function PrintInfo(s) end
function print(...) end
function CH(n) return {EntName=n, Position={X=0,Y=0}, IsInteracting=false,
                       GetDisplayName=function() return n end} end
function MRKR(n) return {Position={X=0,Y=0}, Direction=0} end

UI.ChoiceResult = function() return CHOICE_RESULT end
GAME.DungeonUnlocked = function(self, z) return true end
GAME.GetCurrentGround = function() return {Name={ToLocal=function() return "map" end}} end
GAME.GetPlayerPartyMember = function(self,i) return CH("Member"..tostring(i)) end

STRINGS = { Format=function(self,s,...) return s end,
            FormatKey=function(self,k,...) return k end,
            MapStrings=setmetatable({},{__index=function(t,k) return k end}) }

Direction = setmetatable({},{__index=function(t,k) return k end})
Gender = {Male=1,Female=2,Genderless=0,Unknown=-1}
DrawLayer = {Top="Top"}
function Color(...) return {} end

RogueEssence = {
  Data = { GameProgress = {
      ResultType = {Unknown=-1,Downed=0,Failed=1,Cleared=2,Escaped=3,TimedOut=4,GaveUp=5,Rescue=6},
      DungeonStakes = {Risk="Risk",None="None"} },
    Gender = {Unknown=-1}, DataManager = {DataType={Zone="Zone"}} },
  Dungeon = { MonsterID=function(...) return {} end, InvItem=function(...) return {GetDisplayName=function() return "item" end} end,
              ZoneLoc=function(...) return {} end },
  Ground = { GroundChar=function(...) return CH("tmp") end,
             GroundObject=function(...) return {ReloadEvents=function() end} end,
             PoseGroundAction=function(...) return {} end },
  Content = { ObjAnimData=function(...) return {} end, FlashEmitter=function() return {} end,
              BGAnimData=function(...) return {} end,
              GraphicsManager={GetAnimIndex=function(...) return 0 end} },
  Script = { TriggerResult=function() return {} end,
             LuaEngine={EEntLuaEventTypes={EntSpawned=0}} },
  LevelGen = {},
}
RogueElements = { Loc=function(x,y) return {X=x,Y=y} end, Rect=function(...) return {} end }

_DATA = { Save={ActiveTeam={Rank="normal"}, Rescue=nil, RescuesLeft=0,
                GetDungeonUnlock=function() return "Completed" end},
          DataIndices={Zone={Get=function(self,z) return {GetColoredName=function() return z end,
                             Name={ToLocal=function() return z end}} end}},
          GetZone=function(self,z) return {GroundMaps={}} end,
          GetMonster=function(self,m) return {GetColoredName=function() return m end} end }
_DUNGEON = { LogMsg=function(...) end }
_MENU = { SetDialogue=function(...) return {} end }
_ZONE = {}
COMMON = { RespawnAllies=function() end, ExitDungeonMissionCheck=function(...) return false end,
           EndDungeonDay=function(...) PYREC("COMMON.EndDungeonDay", ...) end,
           BossTransition=function() PYREC("COMMON.BossTransition") end,
           EndSession=function(...) PYREC("COMMON.EndSession", ...) end,
           GroundInteract=function(...) end, EndRescue=function(...) end,
           CreateWalkArea=function(...) end }
CONFIG = { Initialize=function() end, UseNicknames=function() return true end,
           RegularStarters=function() return true end }
CHOICE_RESULT = true
function MonsterID(...) return {} end
function Loc(x,y) return {X=x,Y=y} end
""")

    # --- scriptvars du mod (vrai fichier)
    L.execute(open(os.path.join(S, 'scriptvars.lua'), encoding='utf-8').read())
    # --- helpers réels dont on a besoin
    for f in ['GeneralFunctions.lua', 'CharacterEssentials.lua']:
        src = open(os.path.join(S, f), encoding='utf-8').read()
        src = src.replace("require 'origin.common'", "")
        src = src.replace("require 'halcyon.CharacterEssentials'", "")
        src = src.replace("require 'halcyon.GeneralFunctions'", "")
        src = src.replace("require 'halcyon.PartnerEssentials'", "")
        try:
            L.execute(src)
        except Exception as e:
            pass
    scenario_setup(L, eng)
    return L, eng
