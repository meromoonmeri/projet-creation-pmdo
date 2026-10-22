-- [dungeon_builder] scène canonique PMD Red — scène d01p02 (end).
--[[ d01p02 — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d01p02.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D01P02_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local d01p02 = {}

local SCENE = 'd01p02'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d01p02.cif.json).
local EVENTS = {
  {t='bgm', track='In the Depths of the Pit'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D01P02_001'},
  {t='msg', key='SCENE_D01P02_002'},
  {t='msg', key='SCENE_D01P02_003'},
  {t='msg', key='SCENE_D01P02_004'},
  {t='msg', key='SCENE_D01P02_005'},
  {t='msg', key='SCENE_D01P02_006'},
  {t='anim', id='2'},
  {t='anim', id='2'},
}

function d01p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d01p02.Enter(map)
  DEBUG.EnableDbgCoro()
  -- See d05p02.Enter for the SV.CanonicalDungeons marker rationale.
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['tiny_woods'] = true
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function d01p02.Update(map) end
function d01p02.GameSave(map) end
function d01p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d01p02
