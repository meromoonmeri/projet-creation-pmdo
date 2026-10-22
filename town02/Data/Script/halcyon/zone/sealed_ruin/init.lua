--[[
    init.lua — Sealed Ruin (dungeon 29, arc du futur main story).
    Zone PMDO native : LayeredSegment -> 8 floors, monster house 5%.
    Entrée : d20p11a (m18b0601). Sortie : retour d20p11a -> Sealed Ruin Pit.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.future_arc._future_dungeons_common'

local sealed_ruin = {}

function sealed_ruin.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_sealed_ruin")
  SV.TemporaryFlags.LastDungeonEntered = 'sealed_ruin'
end

function sealed_ruin.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function sealed_ruin.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function sealed_ruin.ExitSegment(zone, result, rescue, segmentID, mapID)
  FutureDungeonCommon.HandleExit(result, rescue, zone, segmentID, 'd20p11a')
end

return sealed_ruin
