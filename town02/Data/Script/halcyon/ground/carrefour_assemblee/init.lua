--[[
     Carrefour de l'Assemblee — plaque tournante du continent du Bourg.

     Ground converti depuis le lot Explorers (crossroads_assembly).
     Entites et sorties restaurees depuis la source le 2026-08-02 ;
     geometrie et collisions inchangees.

     Reseau canonique :
       ouest -> bourg_comptoir  (Bourg du Comptoir)
       nord  -> guilde_parvis   (parvis de la Guilde)
       sud   -> carrefour_sud   (carrefour Sud, puis la plage)
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ComptoirVoices'

local carrefour_assemblee = {}

function carrefour_assemblee.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_carrefour_assemblee")
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
end

function carrefour_assemblee.Enter(map)
  GAME:FadeIn(20)
end

function carrefour_assemblee.Update(map, time) end

function carrefour_assemblee.GameSave(map)
  pcall(function() PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end)
end

function carrefour_assemblee.GameLoad(map)
  pcall(function() PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end)
  GAME:FadeIn(20)
end

-- Habitants du carrefour.
function carrefour_assemblee.Bidoof_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara,
    "Trois routes partent d'ici.[pause=15] Prenez celle qui descend si vous cherchez la mer.", 'Normal')
  GeneralFunctions.EndConversation(chara)
end

function carrefour_assemblee.Marill_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara,
    "On se donne rendez-vous ici, d'habitude.[pause=15] C'est le seul endroit que tout le monde trouve.", 'Happy')
  GeneralFunctions.EndConversation(chara)
end

-- Sorties.
function carrefour_assemblee.TreasureTownEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("bourg_comptoir", "CrossRoadsAssemblyEntranceMarker")
end

function carrefour_assemblee.GuildOutsideEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("guilde_parvis", "CrossRoadsEntranceMarker")
end

function carrefour_assemblee.CrossRoadsSouthEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("carrefour_sud", "CrossRoadsAssemblyEntranceMarker")
end

-- Entree de donjon heritee de la source : aucune zone rattachee dans
-- New Era pour l'instant. Neutralisee explicitement.
function carrefour_assemblee.DungeonEntrance_Touch(obj, activator) end

function carrefour_assemblee.TreasureSpindaCafeEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:FadeOut(false,20)
  GAME:EnterGroundMap('treasure_spinda_cafe','Main_Entrance_Marker')
end

return carrefour_assemblee
