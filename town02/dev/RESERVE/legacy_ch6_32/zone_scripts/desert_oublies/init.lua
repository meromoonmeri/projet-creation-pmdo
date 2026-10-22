--[[
    init.lua — Vague 2 (desert_oublies)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local desert_oublies = {}

function desert_oublies.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_desert_oublies")
  SV.TemporaryFlags.LastDungeonEntered = 'desert_oublies'
end

function desert_oublies.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function desert_oublies.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function desert_oublies.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_desert_oublies result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return desert_oublies
