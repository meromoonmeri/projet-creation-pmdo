--[[
     Carrefour Sud — descente vers le littoral.

     Ground converti depuis le lot Explorers (crossroads_south).
     Entites et sorties restaurees le 2026-08-02.

     Reseau canonique :
       nord  -> carrefour_assemblee
       ouest -> plage_lucioles
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local carrefour_sud = {}

function carrefour_sud.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_carrefour_sud")
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
end

function carrefour_sud.Enter(map)
  GAME:FadeIn(20)
end

function carrefour_sud.Update(map, time) end

function carrefour_sud.GameSave(map)
  pcall(function() PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end)
end

function carrefour_sud.GameLoad(map)
  pcall(function() PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end)
  GAME:FadeIn(20)
end

function carrefour_sud.CrossRoadsAssemblyEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("carrefour_assemblee", "CrossRoadsSouthEntranceMarker")
end

function carrefour_sud.BeachEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("plage_lucioles", "Entrance")
end

return carrefour_sud
