-- [dungeon_builder] scène canonique PMD Red — scène d08p02 (end).
--[[ grotte_lazuli_fond — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d08p02.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D08P02_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local grotte_lazuli_fond = {}

local SCENE = 'd08p02'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d08p02.cif.json).
local EVENTS = {
  {t='bgm', track=''},
  {t='msg', key='SCENE_D08P02_001'},
  {t='msg', key='SCENE_D08P02_002'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D08P02_003'},
  {t='msg', key='SCENE_D08P02_004'},
  {t='msg', key='SCENE_D08P02_005'},
  {t='msg', key='SCENE_D08P02_006'},
  {t='anim', id='2'},
}

function grotte_lazuli_fond.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function grotte_lazuli_fond.Enter(map)
  DEBUG.EnableDbgCoro()
  -- See d05p02.Enter for the SV.CanonicalDungeons marker rationale:
  -- the marker must be set BEFORE the cinematic runs so any external observer
  -- (e.g. RedStoryRouteValidator via GroundMapInit) can detect that the
  -- canonical scene actually played, even if the subsequent EndDungeonRun
  -- unloads the runtime before the cinematic finishes.
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['lapis_cave'] = true
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function grotte_lazuli_fond.Update(map) end
function grotte_lazuli_fond.GameSave(map) end
function grotte_lazuli_fond.GameLoad(map)
  GAME:FadeIn(20)
end

return grotte_lazuli_fond
