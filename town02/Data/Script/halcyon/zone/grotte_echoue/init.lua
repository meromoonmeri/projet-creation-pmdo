--[[
    init.lua — Grotte de l'Échoué (grotte_echoue)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local grotte_echoue = {}

function grotte_echoue.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_echoue")
  SV.TemporaryFlags.LastDungeonEntered = 'grotte_echoue'
end

function grotte_echoue.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function grotte_echoue.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function grotte_echoue.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_grotte_echoue result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return grotte_echoue
