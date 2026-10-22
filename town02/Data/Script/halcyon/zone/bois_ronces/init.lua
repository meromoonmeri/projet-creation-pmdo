--[[
    init.lua — Vague 2 (bois_ronces)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.SideExpeditions'

local bois_ronces = {}

function bois_ronces.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_ronces")
  SV.TemporaryFlags.LastDungeonEntered = 'bois_ronces'
end

function bois_ronces.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function bois_ronces.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function bois_ronces.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_bois_ronces result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Expedition de requete secondaire : si le joueur en avait
  -- une en cours sur cette zone, la victoire la valide.
  pcall(function() SideExpeditions.OnDungeonCleared('bois_ronces', result) end)

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return bois_ronces
