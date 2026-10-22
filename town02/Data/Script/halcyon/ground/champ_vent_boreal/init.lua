-- [dungeon_builder] scène canonique PMD Red — scène d18p01 (end).
--[[ champ_vent_boreal — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d18p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D18P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local champ_vent_boreal = {}

local SCENE = 'd18p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d18p01.cif.json).
local EVENTS = {
  {t='bgm', track='In the Depths of the Pit'},
  {t='bgm_fade', frames=60},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D18P01_001'},
  {t='msg', key='SCENE_D18P01_002'},
  {t='msg', key='SCENE_D18P01_003'},
  {t='msg', key='SCENE_D18P01_004'},
  {t='msg', key='SCENE_D18P01_005'},
  {t='msg', key='SCENE_D18P01_006'},
  {t='bgm_fade', frames=30},
  {t='msg', key='SCENE_D18P01_007'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D18P01_008'},
  {t='msg', key='SCENE_D18P01_009'},
  {t='bgm', track='In the Depths of the Pit'},
  {t='msg', key='SCENE_D18P01_010'},
  {t='msg', key='SCENE_D18P01_011'},
  {t='msg', key='SCENE_D18P01_012'},
  {t='msg', key='SCENE_D18P01_013'},
  {t='msg', key='SCENE_D18P01_014'},
  {t='msg', key='SCENE_D18P01_015'},
  {t='msg', key='SCENE_D18P01_016'},
  {t='msg', key='SCENE_D18P01_017'},
  {t='msg', key='SCENE_D18P01_018'},
  {t='msg', key='SCENE_D18P01_019'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='19'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='22'},
  {t='anim', id='2'},
}

function champ_vent_boreal.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function champ_vent_boreal.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['northwind_field'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function champ_vent_boreal.Update(map) end
function champ_vent_boreal.GameSave(map) end
function champ_vent_boreal.GameLoad(map)
  GAME:FadeIn(20)
end

return champ_vent_boreal
