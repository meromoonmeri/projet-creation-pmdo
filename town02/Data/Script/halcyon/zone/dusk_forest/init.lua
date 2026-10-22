--[[
    init.lua — Dusk Forest (dungeon 32, arc du futur main story).
    Zone PMDO native : LayeredSegment -> 8 floors, dark F6-8, traps 8 F7-8.
    Entrée : d22p11a (m19a0301). Sortie : retour d22p11a -> climax (P08P01A).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.future_arc._future_dungeons_common'

local dusk_forest = {}

function dusk_forest.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_dusk_forest")
  SV.TemporaryFlags.LastDungeonEntered = 'dusk_forest'
end

function dusk_forest.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function dusk_forest.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function dusk_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  FutureDungeonCommon.HandleExit(result, rescue, zone, segmentID, 'd22p11a')
end

return dusk_forest
