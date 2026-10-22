--[[
    init.lua — Spiritomb Room (dungeon 31, arc du futur main story).

    SALLE FIXE (fixed floor 7, map D21P41A). SPIRITOMB (NPC_MIKARUGE, L51,
    weight 10000) est l'unique entité de l'arène, placée à (8,2) = (324,196) px.
    La scène canonique (m18b1101/1201/1301) se joue sur le ground d21p41a.
    Cette zone encapsule la rencontre : 1 floor, spawn Spiritomb garanti.
    Entrée : d21p21a (m18b1002). Sortie : d21p41a (scène de confiance) -> Dusk Forest.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.future_arc._future_dungeons_common'

local spiritomb_room = {}

function spiritomb_room.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_spiritomb_room")
  SV.TemporaryFlags.LastDungeonEntered = 'spiritomb_room'
end

function spiritomb_room.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function spiritomb_room.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function spiritomb_room.ExitSegment(zone, result, rescue, segmentID, mapID)
  FutureDungeonCommon.HandleExit(result, rescue, zone, segmentID, 'd21p41a')
end

return spiritomb_room
