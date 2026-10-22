-- [dungeon_builder] scène canonique PMD Red — scène d20p01 (end).
--[[ antre_occident — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d20p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D20P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local antre_occident = {}

local SCENE = 'd20p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d20p01.cif.json).
local EVENTS = {
  {t='msg', key='SCENE_D20P01_001'},
  {t='msg', key='SCENE_D20P01_002'},
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D20P01_003'},
  {t='msg', key='SCENE_D20P01_004'},
  {t='msg', key='SCENE_D20P01_005'},
  {t='msg', key='SCENE_D20P01_006'},
  {t='msg', key='SCENE_D20P01_007'},
  {t='msg', key='SCENE_D20P01_008'},
  {t='msg', key='SCENE_D20P01_009'},
  {t='msg', key='SCENE_D20P01_010'},
  {t='msg', key='SCENE_D20P01_011'},
  {t='msg', key='SCENE_D20P01_012'},
  {t='msg', key='SCENE_D20P01_013'},
  {t='msg', key='SCENE_D20P01_014'},
  {t='msg', key='SCENE_D20P01_015'},
  {t='msg', key='SCENE_D20P01_016'},
  {t='msg', key='SCENE_D20P01_017'},
  {t='msg', key='SCENE_D20P01_018'},
  {t='msg', key='SCENE_D20P01_019'},
  {t='bgm_fade', frames=30},
  {t='msg', key='SCENE_D20P01_020'},
  {t='msg', key='SCENE_D20P01_021'},
  {t='msg', key='SCENE_D20P01_022'},
  {t='msg', key='SCENE_D20P01_023'},
  {t='msg', key='SCENE_D20P01_024'},
  {t='bgm', track=''},
  {t='msg', key='SCENE_D20P01_025'},
  {t='msg', key='SCENE_D20P01_026'},
  {t='msg', key='SCENE_D20P01_027'},
  {t='msg', key='SCENE_D20P01_028'},
  {t='msg', key='SCENE_D20P01_029'},
  {t='msg', key='SCENE_D20P01_030'},
  {t='msg', key='SCENE_D20P01_031'},
  {t='bgm', track='Boss Battle!'},
  {t='msg', key='SCENE_D20P01_032'},
  {t='msg', key='SCENE_D20P01_033'},
  {t='msg', key='SCENE_D20P01_034'},
  {t='bgm_fade', frames=60},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='anim', id='18'},
  {t='anim', id='2'},
  {t='anim', id='18'},
  {t='anim', id='2'},
  {t='anim', id='18'},
  {t='anim', id='2'},
}

function antre_occident.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function antre_occident.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['western_cave'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function antre_occident.Update(map) end
function antre_occident.GameSave(map) end
function antre_occident.GameLoad(map)
  GAME:FadeIn(20)
end

return antre_occident
