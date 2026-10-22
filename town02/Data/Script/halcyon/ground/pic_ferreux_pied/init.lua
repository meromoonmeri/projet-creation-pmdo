-- [dungeon_builder] scène canonique PMD Red — scène d03p01 (entrance).
--[[ pic_ferreux_pied — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d03p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D03P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local pic_ferreux_pied = {}

local SCENE = 'd03p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d03p01.cif.json).
local EVENTS = {
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D03P01_001'},
  {t='msg', key='SCENE_D03P01_002'},
  {t='shake', frames=30},
  {t='msg', key='SCENE_D03P01_003'},
  {t='msg', key='SCENE_D03P01_004'},
  {t='anim', id='2'},
  {t='anim', id='22'},
  {t='anim', id='2'},
  {t='anim', id='23'},
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D03P01_005'},
  {t='msg', key='SCENE_D03P01_006'},
  {t='shake', frames=30},
  {t='msg', key='SCENE_D03P01_007'},
  {t='msg', key='SCENE_D03P01_008'},
  {t='anim', id='2'},
  {t='anim', id='22'},
  {t='anim', id='2'},
  {t='anim', id='23'},
}

function pic_ferreux_pied.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function pic_ferreux_pied.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('mt_steel', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function pic_ferreux_pied.Update(map) end
function pic_ferreux_pied.GameSave(map) end
function pic_ferreux_pied.GameLoad(map)
  GAME:FadeIn(20)
end

return pic_ferreux_pied
