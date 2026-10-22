-- [dungeon_builder] scène canonique PMD Red — scène d24p02 (end).
--[[ caverne_trouble_autel — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d24p02.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D24P02_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local caverne_trouble_autel = {}

local SCENE = 'd24p02'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d24p02.cif.json).
local EVENTS = {
  {t='bgm', track=''},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D24P02_001'},
  {t='msg', key='SCENE_D24P02_002'},
  {t='anim', id='2'},
}

function caverne_trouble_autel.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function caverne_trouble_autel.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  -- aucune suite câblée : la scène rend la main au jeu
  GAME:CutsceneMode(false)
end

function caverne_trouble_autel.Update(map) end
function caverne_trouble_autel.GameSave(map) end
function caverne_trouble_autel.GameLoad(map)
  GAME:FadeIn(20)
end

return caverne_trouble_autel
