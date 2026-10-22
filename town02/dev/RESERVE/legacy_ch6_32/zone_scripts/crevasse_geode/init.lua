--[[
    init.lua — Vague 2 (crevasse_geode)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local crevasse_geode = {}

function crevasse_geode.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_crevasse_geode")
  SV.TemporaryFlags.LastDungeonEntered = 'crevasse_geode'
end

function crevasse_geode.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function crevasse_geode.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function crevasse_geode.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_crevasse_geode result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return crevasse_geode
