--[[
    init.lua — Vague 2 (jardin_energie)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local jardin_energie = {}

function jardin_energie.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_jardin_energie")
  SV.TemporaryFlags.LastDungeonEntered = 'jardin_energie'
end

function jardin_energie.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function jardin_energie.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function jardin_energie.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_jardin_energie result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return jardin_energie
