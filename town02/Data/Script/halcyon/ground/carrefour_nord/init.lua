--[[
     Carrefour Nord — la halte du départ.

     Ground converti depuis le lot Explorers (crossroads). Décor complet
     (3 078 tuiles), une seule zone franchissable, traversée sud -> nord
     vérifiée praticable sur la grille (55 cases).

     Marqueurs et spawners posés le 2026-08-02 : le ground n'en avait
     AUCUN, ce qui rendait tout EnterGroundMap vers cette carte
     impossible — le moteur exige un marqueur d'entrée nommé, et sans
     spawner d'équipe le partenaire n'apparaît pas.

     C'est ici que se joue la scène 10b de l'arc de l'accusation : la
     dernière parole avant la route. Le joueur voit d'où il vient
     (au sud, la ville) et où il va (au nord, l'inconnu).
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.AccusationArc'
require 'halcyon.FugitiveArc'

local carrefour_nord = {}

function carrefour_nord.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_carrefour_nord")
  -- Fondu posé en PREMIÈRE instruction : sans lui, le joueur voit la
  -- carte se composer pendant la mise en place (correctif généralisé
  -- du 2026-07-30, GAME:FadeOut est bloquant).
  pcall(function() GAME:FadeOut(false, 1) end)
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
end

function carrefour_nord.Enter(map)
  DEBUG.EnableDbgCoro()

  -- Scène 10b : la halte. Elle ne se joue qu'une fois, après la
  -- traversée de la ville (10a) et avant que FledGuild ne soit posé.
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 11 then
    local a = SV.AccusationArc
    if a ~= nil and a.Scene == 10 then
      AccusationArc.Play(AccusationArc.Scene10b_Carrefour, 'Scene10b_Carrefour')
      -- La scène pose Scene = 11 et FledGuild. Le duo reprend ensuite
      -- sa route : l'ARC FUGITIF canon (PMD Red), qui enchaîne
      -- A02P01 -> ... -> D13 Sky Tower -> Place -> rêve -> fin, puis
      -- débouche sur la Mare Altérée (altere_pond_ch_11).
      FugitiveArc.Begin()
      return
    end
  end

  GAME:FadeIn(20)
end

function carrefour_nord.Update(map, time) end

function carrefour_nord.GameSave(map)
  pcall(function() PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end)
end

function carrefour_nord.GameLoad(map)
  pcall(function() PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end)
  GAME:FadeIn(20)
end

return carrefour_nord
