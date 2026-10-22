-- [dungeon_builder] scène canonique PMD Red — scène d25p01 (end).
--[[ bois_des_plaintes — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d25p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D25P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local bois_des_plaintes = {}

local SCENE = 'd25p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d25p01.cif.json).
local EVENTS = {
  {t='bgm', track='In the Depths of the Pit'},
  {t='bgm_fade', frames=120},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D25P01_001'},
  {t='anim', id='2'},
  {t='anim', id='2'},
}

function bois_des_plaintes.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function bois_des_plaintes.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['howling_forest'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function bois_des_plaintes.Update(map) end
function bois_des_plaintes.GameSave(map) end
function bois_des_plaintes.GameLoad(map)
  GAME:FadeIn(20)
end

return bois_des_plaintes
