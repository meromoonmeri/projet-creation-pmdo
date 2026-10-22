--[[
    init.lua — Chasm Cave (dungeon 27, arc du futur main story).
    Zone PMDO native : LayeredSegment -> 8 floors (GridFloorGen) procéduraux.
    Tables Pokémon/items/traps NDS intégrées (mappa_s.bin).
    Entrée : d18p11a (m17a0601). Sortie : retour d18p11a -> Dark Hill.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.future_arc._future_dungeons_common'

local chasm_cave = {}

function chasm_cave.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_chasm_cave")
  SV.TemporaryFlags.LastDungeonEntered = 'chasm_cave'
end

function chasm_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function chasm_cave.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function chasm_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  FutureDungeonCommon.HandleExit(result, rescue, zone, segmentID, 'd18p11a')
end

return chasm_cave
