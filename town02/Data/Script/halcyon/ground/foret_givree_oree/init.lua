-- [dungeon_builder] scène canonique PMD Red — scène d10p01 (entrance).
--[[ foret_givree_oree — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d10p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D10P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local foret_givree_oree = {}

local SCENE = 'd10p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d10p01.cif.json).
local EVENTS = {
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='bgm', track=''},
  {t='camera', action='INIT_PAN'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D10P01_001'},
  {t='msg', key='SCENE_D10P01_002'},
  {t='msg', key='SCENE_D10P01_003'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D10P01_004'},
  {t='msg', key='SCENE_D10P01_005'},
  {t='bgm_fade', frames=120},
  {t='camera', action='PAN'},
  {t='bgm_fade', frames=120},
  {t='camera', action='PAN'},
  {t='msg', key='SCENE_D10P01_006'},
  {t='bgm_fade', frames=120},
  {t='camera', action='PAN'},
  {t='bgm_fade', frames=120},
  {t='camera', action='PAN'},
  {t='anim', id='2'},
  {t='camera', action='PAN'},
  {t='camera', action='PAN'},
  {t='bgm', track=''},
  {t='msg', key='SCENE_D10P01_007'},
  {t='msg', key='SCENE_D10P01_008'},
  {t='msg', key='SCENE_D10P01_009'},
  {t='bgm', track=''},
  {t='anim', id='8'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D10P01_010'},
  {t='msg', key='SCENE_D10P01_011'},
  {t='anim', id='8'},
  {t='anim', id='2'},
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D10P01_012'},
  {t='msg', key='SCENE_D10P01_013'},
  {t='anim', id='2'},
  {t='bgm', track=''},
  {t='msg', key='SCENE_D10P01_014'},
  {t='msg', key='SCENE_D10P01_015'},
}

function foret_givree_oree.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function foret_givree_oree.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('frosty_forest', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function foret_givree_oree.Update(map) end
function foret_givree_oree.GameSave(map) end
function foret_givree_oree.GameLoad(map)
  GAME:FadeIn(20)
end

return foret_givree_oree
