-- [dungeon_builder] scène canonique PMD Red — scène d04p01 (entrance).
--[[ bois_sombres_oree — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d04p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D04P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local bois_sombres_oree = {}

local SCENE = 'd04p01'
-- Séquence canonique, dans l'ordre du script de la ROM
-- (RESERVE/red_cinematics/d04p01.cif.json).
local EVENTS = {
  {t='bgm', track='Sinister Woods'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D04P01_001'},
  {t='anim', id='2'},
  {t='bgm', track='Sinister Woods'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D04P01_002'},
  {t='anim', id='2'},
}

function bois_sombres_oree.Init(map)
  DEBUG.EnableDbgCoro()
  -- The canonical D04P01 Ground has no New Era teammate spawners. Do not call
  -- COMMON.RespawnAllies here: it would emit missing-spawner Lua exceptions.
end

local function EnterCanonicalDungeon()
  PrintInfo('[SINISTER_ROUTE] D04P01 scene complete; preparing segment 0')
  GAME:CutsceneMode(false)
  if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') ~= '1' then
    GAME:FadeOut(false, 30)
    GAME:WaitFrames(10)
  end
  PrintInfo('[SINISTER_ROUTE] D04P01 -> gloomy_forest segment 0')
  GAME:EnterDungeon('gloomy_forest', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
end

function bois_sombres_oree.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, EVENTS)
  GAME:CutsceneMode(false)
  -- D04P01 est l'entrée canonique : après sa scène, le trajet continue vers
  -- les floors 1-6. Aucun Ground New Era de substitution n'est intercalé.
  if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') ~= '1' then
    EnterCanonicalDungeon()
  end
end

function bois_sombres_oree.Update(map) end
function bois_sombres_oree.GameSave(map) end
function bois_sombres_oree.GameLoad(map)
  GAME:FadeIn(20)
end

return bois_sombres_oree
