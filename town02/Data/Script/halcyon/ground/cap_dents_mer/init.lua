--[[
     Cap des Dents de Mer — falaise surplombant le Bourg.

     Ground converti depuis le lot Explorers (habitat_sharpedo_bluff_day).
     Entites et sortie restaurees le 2026-08-02.

     Reseau canonique : est -> bourg_comptoir
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local cap_dents_mer = {}

function cap_dents_mer.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cap_dents_mer")
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
end

function cap_dents_mer.Enter(map)
  GAME:FadeIn(20)
end

function cap_dents_mer.Update(map, time) end

function cap_dents_mer.GameSave(map)
  pcall(function() PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end)
end

function cap_dents_mer.GameLoad(map)
  pcall(function() PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end)
  GAME:FadeIn(20)
end

function cap_dents_mer.SignSharpedoBluffDay_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  pcall(function()
    UI:ResetSpeaker()
    UI:WaitShowDialogue("« Cap des Dents de Mer.[pause=15] Bord instable.[pause=10] Ne pas s'approcher par vent fort. »")
  end)
end

function cap_dents_mer.TreasureTownEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("bourg_comptoir", "HabitatSharpedoBluffDayEntranceMarker")
end

return cap_dents_mer
