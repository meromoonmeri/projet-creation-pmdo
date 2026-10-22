--[[
    init.lua — Carrière de Cuivre (carriere_cuivre)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.SideExpeditions'
require 'halcyon.MeuteArc'

local carriere_cuivre = {}

function carriere_cuivre.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_carriere_cuivre")
  SV.TemporaryFlags.LastDungeonEntered = 'carriere_cuivre'
end

function carriere_cuivre.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function carriere_cuivre.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function carriere_cuivre.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_carriere_cuivre result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Expedition de requete secondaire : si le joueur en avait
  -- une en cours sur cette zone, la victoire la valide.
  pcall(function() SideExpeditions.OnDungeonCleared('carriere_cuivre', result) end)

  -- Meute de Corboss : acte du fil recurrent ch8-ch10, joue a la
  -- sortie du donjon et une seule fois. Il sort en mode cinematique,
  -- d'ou le retour anticipe.
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    local joue = false
    pcall(function() joue = MeuteArc.PlayAct('carriere_cuivre') end)
    if joue then
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
      return
    end
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return carriere_cuivre
