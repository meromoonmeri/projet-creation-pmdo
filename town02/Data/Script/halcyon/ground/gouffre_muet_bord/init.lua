-- [dungeon_builder] scène canonique PMD Red — scène d05p01 (entrance).
--[[ gouffre_muet_bord — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d05p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D05P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local gouffre_muet_bord = {}

local SCENE = 'd05p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d05p01.cif.json).
local EVENTS = {
  {t='bgm', track=''},
  {t='camera', action='INIT_PAN'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D05P01_001'},
  {t='msg', key='SCENE_D05P01_002'},
  {t='msg', key='SCENE_D05P01_003'},
  {t='msg', key='SCENE_D05P01_004'},
  {t='msg', key='SCENE_D05P01_005'},
  {t='msg', key='SCENE_D05P01_006'},
  {t='msg', key='SCENE_D05P01_007'},
  {t='msg', key='SCENE_D05P01_008'},
  {t='msg', key='SCENE_D05P01_009'},
  {t='msg', key='SCENE_D05P01_010'},
  {t='msg', key='SCENE_D05P01_011'},
  {t='msg', key='SCENE_D05P01_012'},
  {t='msg', key='SCENE_D05P01_013'},
  {t='msg', key='SCENE_D05P01_014'},
  {t='msg', key='SCENE_D05P01_015'},
  {t='msg', key='SCENE_D05P01_016'},
  {t='msg', key='SCENE_D05P01_017'},
  {t='msg', key='SCENE_D05P01_018'},
  {t='msg', key='SCENE_D05P01_019'},
  {t='msg', key='SCENE_D05P01_020'},
  {t='msg', key='SCENE_D05P01_021'},
  {t='msg', key='SCENE_D05P01_022'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D05P01_023'},
  {t='msg', key='SCENE_D05P01_024'},
  {t='msg', key='SCENE_D05P01_025'},
  {t='msg', key='SCENE_D05P01_026'},
  {t='msg', key='SCENE_D05P01_027'},
  {t='msg', key='SCENE_D05P01_028'},
  {t='msg', key='SCENE_D05P01_029'},
  {t='msg', key='SCENE_D05P01_030'},
  {t='msg', key='SCENE_D05P01_031'},
  {t='msg', key='SCENE_D05P01_032'},
  {t='msg', key='SCENE_D05P01_033'},
  {t='msg', key='SCENE_D05P01_034'},
  {t='msg', key='SCENE_D05P01_035'},
  {t='msg', key='SCENE_D05P01_036'},
  {t='msg', key='SCENE_D05P01_037'},
  {t='msg', key='SCENE_D05P01_038'},
  {t='anim', id='2'},
  {t='anim', id='8'},
  {t='anim', id='2'},
  {t='anim', id='2'},
}

function gouffre_muet_bord.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function gouffre_muet_bord.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('silent_chasm', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function gouffre_muet_bord.Update(map) end
function gouffre_muet_bord.GameSave(map) end
function gouffre_muet_bord.GameLoad(map)
  GAME:FadeIn(20)
end

return gouffre_muet_bord
