-- [dungeon_builder] scène canonique PMD Red — scène d02p01 (entrance).
--[[ grotte_statique_seuil — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d02p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D02P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local grotte_statique_seuil = {}

local SCENE = 'd02p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d02p01.cif.json).
local EVENTS = {
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D02P01_001'},
  {t='msg', key='SCENE_D02P01_002'},
  {t='msg', key='SCENE_D02P01_003'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D02P01_004'},
  {t='msg', key='SCENE_D02P01_005'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D02P01_006'},
  {t='msg', key='SCENE_D02P01_007'},
  {t='msg', key='SCENE_D02P01_008'},
  {t='msg', key='SCENE_D02P01_009'},
  {t='msg', key='SCENE_D02P01_010'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
  {t='anim', id='2'},
}

function grotte_statique_seuil.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function grotte_statique_seuil.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('thunderwave_cave', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function grotte_statique_seuil.Update(map) end
function grotte_statique_seuil.GameSave(map) end
function grotte_statique_seuil.GameLoad(map)
  GAME:FadeIn(20)
end

return grotte_statique_seuil
