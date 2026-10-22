--[[
     Parvis de la Guilde — abords de la guilde du continent du Bourg.

     Ground converti depuis le lot Explorers (guild_outside).
     Entites et sorties restaurees le 2026-08-02.

     Cette guilde n'est pas celle de Metano : c'est l'institution
     historique du Bourg du Comptoir. Ses étages historiques sont désormais accessibles aux visiteurs, sans adhésion obligatoire.

     Reseau canonique : sud -> carrefour_assemblee
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.LivingWorld'

local guilde_parvis = {}

function guilde_parvis.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_guilde_parvis")
  pcall(function() LivingWorld.SyncStory(); LivingWorld.ApplyOutdoor(true) end)
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
end

function guilde_parvis.Enter(map)
  GAME:FadeIn(20)
end

function guilde_parvis.Update(map, time) end

function guilde_parvis.GameSave(map)
  pcall(function() PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end)
end

function guilde_parvis.GameLoad(map)
  pcall(function() PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end)
  GAME:FadeIn(20)
end

function guilde_parvis.Bidoof_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara,
    "La Guilde accueille de nouveau les visiteurs.[pause=15] Vous pouvez consulter les missions sans devenir membres.", 'Sad')
  GeneralFunctions.EndConversation(chara)
end

function guilde_parvis.CrossRoadsEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("carrefour_assemblee", "GuildOutsideEntranceMarker")
end

function guilde_parvis.GuildEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap('sky_wigglytuff_guild_entrance', 'Main_Entrance_Marker')
end

return guilde_parvis
