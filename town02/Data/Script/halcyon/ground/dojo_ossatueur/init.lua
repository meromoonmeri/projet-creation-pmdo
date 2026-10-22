--[[
     Dojo de Maitre Ossovan — salle d'entrainement du Bourg.

     Ground converti depuis le lot Explorers (marowak_dojo).
     Entites et sorties restaurees le 2026-08-02.

     Reseau canonique :
       sud  -> bourg_comptoir
       nord -> dedale du dojo (dojo_ossatueur_final), non rattache a une
               zone dans New Era : l'acces reste ferme et le dit.
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ComptoirVoices'

local dojo_ossatueur = {}

function dojo_ossatueur.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_dojo_ossatueur")
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
end

function dojo_ossatueur.Enter(map)
  GAME:FadeIn(20)
end

function dojo_ossatueur.Update(map, time) end

function dojo_ossatueur.GameSave(map)
  pcall(function() PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end)
end

function dojo_ossatueur.GameLoad(map)
  pcall(function() PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end)
  GAME:FadeIn(20)
end

function dojo_ossatueur.Marowak_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  ComptoirVoices.Talk(chara, 'Marowak')
end

function dojo_ossatueur.MarowakDojoExit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("bourg_comptoir", "MarowakDojoEntranceMarker")
end

function dojo_ossatueur.MarowakDojoDungeonEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  local chara = CH('Marowak')
  if chara ~= nil then
    GeneralFunctions.StartConversation(chara,
      "Le dedale est ferme.[pause=15] Revenez quand vos jambes suivront votre ambition.", 'Determined')
    GeneralFunctions.EndConversation(chara)
  end
end

return dojo_ossatueur
