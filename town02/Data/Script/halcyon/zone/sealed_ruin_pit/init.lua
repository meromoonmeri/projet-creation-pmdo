--[[
    init.lua — Sealed Ruin Pit (dungeon 30, arc du futur main story).
    Zone PMDO native : LayeredSegment -> 6 floors, monster house 5%.
    Entrée : d21p21a (m18b0801). Sortie : retour d21p21a -> Spiritomb Room.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.future_arc._future_dungeons_common'

local sealed_ruin_pit = {}

function sealed_ruin_pit.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_sealed_ruin_pit")
  SV.TemporaryFlags.LastDungeonEntered = 'sealed_ruin_pit'
end

function sealed_ruin_pit.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function sealed_ruin_pit.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function sealed_ruin_pit.ExitSegment(zone, result, rescue, segmentID, mapID)
  FutureDungeonCommon.HandleExit(result, rescue, zone, segmentID, 'd21p21a')
end

return sealed_ruin_pit
