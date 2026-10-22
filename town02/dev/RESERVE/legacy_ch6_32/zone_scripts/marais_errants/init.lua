--[[
    init.lua — Vague 2 (marais_errants)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.SideExpeditions'
require 'halcyon.MeuteArc'

local marais_errants = {}

function marais_errants.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_marais_errants")
  SV.TemporaryFlags.LastDungeonEntered = 'marais_errants'
end

function marais_errants.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function marais_errants.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function marais_errants.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_marais_errants result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Expedition de requete secondaire : si le joueur en avait
  -- une en cours sur cette zone, la victoire la valide.
  pcall(function() SideExpeditions.OnDungeonCleared('marais_errants', result) end)

  -- Meute de Corboss : acte du fil recurrent ch8-ch10, joue a la
  -- sortie du donjon et une seule fois. Il sort en mode cinematique,
  -- d'ou le retour anticipe.
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    local joue = false
    pcall(function() joue = MeuteArc.PlayAct('marais_errants') end)
    if joue then
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
      return
    end
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return marais_errants
