-- [dungeon_builder] scène canonique PMD Red — scène d07p01 (entrance).
--[[ grand_canyon_porte — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d07p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D07P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local grand_canyon_porte = {}

local SCENE = 'd07p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d07p01.cif.json).
local EVENTS = {
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D07P01_001'},
  {t='msg', key='SCENE_D07P01_002'},
  {t='msg', key='SCENE_D07P01_003'},
  {t='anim', id='2'},
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D07P01_004'},
  {t='anim', id='2'},
}

function grand_canyon_porte.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function grand_canyon_porte.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('great_canyon', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function grand_canyon_porte.Update(map) end
function grand_canyon_porte.GameSave(map) end
function grand_canyon_porte.GameLoad(map)
  GAME:FadeIn(20)
end

return grand_canyon_porte
