--[[
    init.lua — Vallée Fertile (vallee_fertile)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local vallee_fertile = {}

function vallee_fertile.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vallee_fertile")
  SV.TemporaryFlags.LastDungeonEntered = 'vallee_fertile'
end

function vallee_fertile.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function vallee_fertile.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function vallee_fertile.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_vallee_fertile result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return vallee_fertile
