-- [dungeon_builder] scène canonique PMD Red — scène d21p01 (end).
--[[ cretes_boreales — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d21p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D21P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local cretes_boreales = {}

local SCENE = 'd21p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d21p01.cif.json).
local EVENTS = {
  {t='bgm', track='In the Depths of the Pit'},
  {t='bgm_fade', frames=60},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D21P01_001'},
  {t='msg', key='SCENE_D21P01_002'},
  {t='msg', key='SCENE_D21P01_003'},
  {t='msg', key='SCENE_D21P01_004'},
  {t='shake', frames=30},
  {t='anim', id='2'},
  {t='anim', id='19'},
  {t='anim', id='25'},
  {t='anim', id='33'},
  {t='anim', id='9'},
}

function cretes_boreales.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function cretes_boreales.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['northern_range'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function cretes_boreales.Update(map) end
function cretes_boreales.GameSave(map) end
function cretes_boreales.GameLoad(map)
  GAME:FadeIn(20)
end

return cretes_boreales
