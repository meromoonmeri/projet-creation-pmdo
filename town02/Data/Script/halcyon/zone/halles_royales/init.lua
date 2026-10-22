--[[
    init.lua — Vague 2 (halles_royales)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local halles_royales = {}

function halles_royales.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_halles_royales")
  SV.TemporaryFlags.LastDungeonEntered = 'halles_royales'
end

function halles_royales.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function halles_royales.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function halles_royales.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_halles_royales result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return halles_royales
