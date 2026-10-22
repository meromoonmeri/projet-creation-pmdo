-- [dungeon_builder] scène canonique PMD Red — scène d09p03 (end).
--[[ d09p03 — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d09p03.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D09P03_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local d09p03 = {}

local SCENE = 'd09p03'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d09p03.cif.json).
local EVENTS = {
  {t='bgm', track='In the Depths of the Pit'},
  {t='camera', action='INIT_PAN'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D09P03_001'},
  {t='msg', key='SCENE_D09P03_002'},
  {t='msg', key='SCENE_D09P03_003'},
  {t='msg', key='SCENE_D09P03_004'},
  {t='msg', key='SCENE_D09P03_005'},
  {t='msg', key='SCENE_D09P03_006'},
  {t='msg', key='SCENE_D09P03_007'},
  {t='msg', key='SCENE_D09P03_008'},
  {t='msg', key='SCENE_D09P03_009'},
  {t='msg', key='SCENE_D09P03_010'},
  {t='msg', key='SCENE_D09P03_011'},
  {t='msg', key='SCENE_D09P03_012'},
  {t='msg', key='SCENE_D09P03_013'},
  {t='msg', key='SCENE_D09P03_014'},
  {t='msg', key='SCENE_D09P03_015'},
  {t='msg', key='SCENE_D09P03_016'},
  {t='msg', key='SCENE_D09P03_017'},
  {t='msg', key='SCENE_D09P03_018'},
  {t='msg', key='SCENE_D09P03_019'},
  {t='msg', key='SCENE_D09P03_020'},
  {t='msg', key='SCENE_D09P03_021'},
  {t='msg', key='SCENE_D09P03_022'},
  {t='msg', key='SCENE_D09P03_023'},
  {t='msg', key='SCENE_D09P03_024'},
  {t='msg', key='SCENE_D09P03_025'},
  {t='msg', key='SCENE_D09P03_026'},
  {t='msg', key='SCENE_D09P03_027'},
  {t='msg', key='SCENE_D09P03_028'},
  {t='msg', key='SCENE_D09P03_029'},
  {t='msg', key='SCENE_D09P03_030'},
  {t='msg', key='SCENE_D09P03_031'},
  {t='msg', key='SCENE_D09P03_032'},
  {t='msg', key='SCENE_D09P03_033'},
  {t='msg', key='SCENE_D09P03_034'},
  {t='msg', key='SCENE_D09P03_035'},
  {t='msg', key='SCENE_D09P03_036'},
  {t='msg', key='SCENE_D09P03_037'},
  {t='msg', key='SCENE_D09P03_038'},
  {t='bgm_fade', frames=150},
  {t='anim', id='2'},
  {t='anim', id='22'},
  {t='anim', id='23'},
  {t='anim', id='24'},
  {t='anim', id='25'},
  {t='anim', id='24'},
  {t='anim', id='25'},
  {t='anim', id='24'},
  {t='anim', id='25'},
  {t='anim', id='5'},
}

function d09p03.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d09p03.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['mt_blaze_peak'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function d09p03.Update(map) end
function d09p03.GameSave(map) end
function d09p03.GameLoad(map)
  GAME:FadeIn(20)
end

return d09p03
