--[[
    init.lua — Vague 2 (sentier_enneige)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local sentier_enneige = {}

function sentier_enneige.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_sentier_enneige")
  SV.TemporaryFlags.LastDungeonEntered = 'sentier_enneige'
end

function sentier_enneige.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function sentier_enneige.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function sentier_enneige.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_sentier_enneige result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return sentier_enneige
