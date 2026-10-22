--[[
    init.lua — Petit Tunnel (petit_tunnel)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local petit_tunnel = {}

function petit_tunnel.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_petit_tunnel")
  SV.TemporaryFlags.LastDungeonEntered = 'petit_tunnel'
end

function petit_tunnel.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function petit_tunnel.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function petit_tunnel.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_petit_tunnel result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return petit_tunnel
