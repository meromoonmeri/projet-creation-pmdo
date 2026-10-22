--[[
     Plage des Lucioles — littoral du continent du Bourg.

     Ground converti depuis le lot Explorers (beach). Spawners restaures
     le 2026-08-02 ; geometrie et collisions inchangees.

     Reseau canonique : est -> carrefour_sud
     L'ouverture de grotte a l'ouest n'est rattachee a aucune zone dans
     New Era : elle reste close et le dit, plutot que d'ouvrir sur rien.
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local plage_lucioles = {}

function plage_lucioles.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_plage_lucioles")
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
end

function plage_lucioles.Enter(map)
  GAME:FadeIn(20)
end

function plage_lucioles.Update(map, time) end

function plage_lucioles.GameSave(map)
  pcall(function() PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end)
end

function plage_lucioles.GameLoad(map)
  pcall(function() PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end)
  GAME:FadeIn(20)
end

function plage_lucioles.Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("carrefour_sud", "BeachEntranceMarker")
end

function plage_lucioles.Beach_Cave_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  GeneralFunctions.HeroDialogue(hero,
    "(L'entree est ensablee.[pause=15] Rien ne passe plus par la.)", "Normal")
end

return plage_lucioles
