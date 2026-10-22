-- [dungeon_builder] scène canonique PMD Red — scène d24p01 (end).
--[[ caverne_trouble_fond — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d24p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D24P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local caverne_trouble_fond = {}

local SCENE = 'd24p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d24p01.cif.json).
local EVENTS = {
  {t='bgm', track='In the Depths of the Pit'},
  {t='bgm_fade', frames=90},
  {t='camera', action='INIT_PAN'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D24P01_001'},
  {t='msg', key='SCENE_D24P01_002'},
  {t='msg', key='SCENE_D24P01_003'},
  {t='msg', key='SCENE_D24P01_004'},
  {t='msg', key='SCENE_D24P01_005'},
  {t='msg', key='SCENE_D24P01_006'},
  {t='msg', key='SCENE_D24P01_007'},
  {t='msg', key='SCENE_D24P01_008'},
  {t='msg', key='SCENE_D24P01_009'},
  {t='msg', key='SCENE_D24P01_010'},
  {t='msg', key='SCENE_D24P01_011'},
  {t='msg', key='SCENE_D24P01_012'},
  {t='msg', key='SCENE_D24P01_013'},
  {t='msg', key='SCENE_D24P01_014'},
  {t='msg', key='SCENE_D24P01_015'},
  {t='msg', key='SCENE_D24P01_016'},
  {t='msg', key='SCENE_D24P01_017'},
  {t='bgm', track=''},
  {t='msg', key='SCENE_D24P01_018'},
  {t='msg', key='SCENE_D24P01_019'},
  {t='msg', key='SCENE_D24P01_020'},
  {t='msg', key='SCENE_D24P01_021'},
  {t='msg', key='SCENE_D24P01_022'},
  {t='msg', key='SCENE_D24P01_023'},
  {t='msg', key='SCENE_D24P01_024'},
  {t='msg', key='SCENE_D24P01_025'},
  {t='msg', key='SCENE_D24P01_026'},
  {t='msg', key='SCENE_D24P01_027'},
  {t='msg', key='SCENE_D24P01_028'},
  {t='msg', key='SCENE_D24P01_029'},
  {t='msg', key='SCENE_D24P01_030'},
  {t='msg', key='SCENE_D24P01_031'},
  {t='msg', key='SCENE_D24P01_032'},
  {t='msg', key='SCENE_D24P01_033'},
  {t='msg', key='SCENE_D24P01_034'},
  {t='msg', key='SCENE_D24P01_035'},
  {t='msg', key='SCENE_D24P01_036'},
  {t='msg', key='SCENE_D24P01_037'},
  {t='msg', key='SCENE_D24P01_038'},
  {t='msg', key='SCENE_D24P01_039'},
  {t='msg', key='SCENE_D24P01_040'},
  {t='msg', key='SCENE_D24P01_041'},
  {t='msg', key='SCENE_D24P01_042'},
  {t='msg', key='SCENE_D24P01_043'},
  {t='anim', id='2'},
  {t='shake', frames=30},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='shake', frames=30},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='camera', action='INIT_PAN'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D24P01_044'},
  {t='msg', key='SCENE_D24P01_045'},
  {t='msg', key='SCENE_D24P01_046'},
  {t='msg', key='SCENE_D24P01_047'},
  {t='msg', key='SCENE_D24P01_048'},
  {t='msg', key='SCENE_D24P01_049'},
  {t='msg', key='SCENE_D24P01_050'},
  {t='msg', key='SCENE_D24P01_051'},
  {t='msg', key='SCENE_D24P01_052'},
  {t='msg', key='SCENE_D24P01_053'},
  {t='msg', key='SCENE_D24P01_054'},
  {t='msg', key='SCENE_D24P01_055'},
  {t='msg', key='SCENE_D24P01_056'},
  {t='msg', key='SCENE_D24P01_057'},
  {t='msg', key='SCENE_D24P01_058'},
  {t='msg', key='SCENE_D24P01_059'},
  {t='msg', key='SCENE_D24P01_060'},
  {t='msg', key='SCENE_D24P01_061'},
  {t='msg', key='SCENE_D24P01_062'},
  {t='msg', key='SCENE_D24P01_063'},
  {t='msg', key='SCENE_D24P01_064'},
  {t='msg', key='SCENE_D24P01_065'},
  {t='msg', key='SCENE_D24P01_066'},
  {t='msg', key='SCENE_D24P01_067'},
  {t='msg', key='SCENE_D24P01_068'},
  {t='msg', key='SCENE_D24P01_069'},
  {t='msg', key='SCENE_D24P01_070'},
  {t='msg', key='SCENE_D24P01_071'},
  {t='msg', key='SCENE_D24P01_072'},
  {t='msg', key='SCENE_D24P01_073'},
  {t='msg', key='SCENE_D24P01_074'},
  {t='msg', key='SCENE_D24P01_075'},
  {t='msg', key='SCENE_D24P01_076'},
  {t='msg', key='SCENE_D24P01_077'},
  {t='msg', key='SCENE_D24P01_078'},
  {t='msg', key='SCENE_D24P01_079'},
  {t='msg', key='SCENE_D24P01_080'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='anim', id='9'},
  {t='anim', id='2'},
  {t='anim', id='22'},
  {t='anim', id='2'},
}

function caverne_trouble_fond.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function caverne_trouble_fond.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['murky_cave'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function caverne_trouble_fond.Update(map) end
function caverne_trouble_fond.GameSave(map) end
function caverne_trouble_fond.GameLoad(map)
  GAME:FadeIn(20)
end

return caverne_trouble_fond
