--[[
    init.lua — Vague 2 (bois_filou)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local bois_filou = {}

function bois_filou.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_filou")
  SV.TemporaryFlags.LastDungeonEntered = 'bois_filou'
end

function bois_filou.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function bois_filou.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function bois_filou.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_bois_filou result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return bois_filou
