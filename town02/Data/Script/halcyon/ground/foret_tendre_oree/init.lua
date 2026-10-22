-- [dungeon_builder] scène canonique PMD Red — scène d01p01 (entrance).
--[[ foret_tendre_oree — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d01p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D01P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local foret_tendre_oree = {}

local SCENE = 'd01p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d01p01.cif.json).
local EVENTS = {
  {t='msg', key='SCENE_D01P01_001'},
  {t='msg', key='SCENE_D01P01_002'},
  {t='msg', key='SCENE_D01P01_003'},
  {t='msg', key='SCENE_D01P01_004'},
  {t='msg', key='SCENE_D01P01_005'},
  {t='msg', key='SCENE_D01P01_006'},
  {t='msg', key='SCENE_D01P01_007'},
  {t='msg', key='SCENE_D01P01_008'},
  {t='msg', key='SCENE_D01P01_009'},
  {t='bgm_fade', frames=30},
  {t='msg', key='SCENE_D01P01_010'},
  {t='msg', key='SCENE_D01P01_011'},
  {t='msg', key='SCENE_D01P01_012'},
  {t='msg', key='SCENE_D01P01_013'},
  {t='msg', key='SCENE_D01P01_014'},
  {t='anim', id='5'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D01P01_015'},
  {t='shake', frames=30},
  {t='msg', key='SCENE_D01P01_016'},
  {t='msg', key='SCENE_D01P01_017'},
  {t='msg', key='SCENE_D01P01_018'},
  {t='msg', key='SCENE_D01P01_019'},
  {t='msg', key='SCENE_D01P01_020'},
  {t='msg', key='SCENE_D01P01_021'},
  {t='msg', key='SCENE_D01P01_022'},
  {t='bgm_fade', frames=60},
  {t='msg', key='SCENE_D01P01_023'},
  {t='msg', key='SCENE_D01P01_024'},
  {t='msg', key='SCENE_D01P01_025'},
  {t='bgm', track=''},
  {t='msg', key='SCENE_D01P01_026'},
  {t='msg', key='SCENE_D01P01_027'},
  {t='msg', key='SCENE_D01P01_028'},
  {t='msg', key='SCENE_D01P01_029'},
  {t='msg', key='SCENE_D01P01_030'},
  {t='msg', key='SCENE_D01P01_031'},
  {t='msg', key='SCENE_D01P01_032'},
  {t='msg', key='SCENE_D01P01_033'},
  {t='msg', key='SCENE_D01P01_034'},
  {t='msg', key='SCENE_D01P01_035'},
  {t='anim', id='2'},
  {t='shake', frames=30},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D01P01_036'},
  {t='msg', key='SCENE_D01P01_037'},
  {t='msg', key='SCENE_D01P01_038'},
  {t='msg', key='SCENE_D01P01_039'},
  {t='msg', key='SCENE_D01P01_040'},
  {t='msg', key='SCENE_D01P01_041'},
  {t='msg', key='SCENE_D01P01_042'},
  {t='msg', key='SCENE_D01P01_043'},
  {t='msg', key='SCENE_D01P01_044'},
  {t='msg', key='SCENE_D01P01_045'},
  {t='msg', key='SCENE_D01P01_046'},
  {t='anim', id='2'},
  {t='shake', frames=30},
  {t='bgm', track=''},
  {t='bgm_fade', frames=30},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D01P01_047'},
  {t='msg', key='SCENE_D01P01_048'},
  {t='msg', key='SCENE_D01P01_049'},
  {t='msg', key='SCENE_D01P01_050'},
  {t='msg', key='SCENE_D01P01_051'},
  {t='msg', key='SCENE_D01P01_052'},
  {t='msg', key='SCENE_D01P01_053'},
  {t='msg', key='SCENE_D01P01_054'},
  {t='msg', key='SCENE_D01P01_055'},
  {t='msg', key='SCENE_D01P01_056'},
  {t='msg', key='SCENE_D01P01_057'},
  {t='msg', key='SCENE_D01P01_058'},
  {t='msg', key='SCENE_D01P01_059'},
  {t='msg', key='SCENE_D01P01_060'},
  {t='msg', key='SCENE_D01P01_061'},
  {t='msg', key='SCENE_D01P01_062'},
  {t='msg', key='SCENE_D01P01_063'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
}

function foret_tendre_oree.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function foret_tendre_oree.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('tiny_woods', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function foret_tendre_oree.Update(map) end
function foret_tendre_oree.GameSave(map) end
function foret_tendre_oree.GameLoad(map)
  GAME:FadeIn(20)
end

return foret_tendre_oree
