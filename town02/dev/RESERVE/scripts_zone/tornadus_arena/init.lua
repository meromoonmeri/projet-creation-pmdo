--[[
    init.lua — Arène de Tornadus (tornadus_arena) — ZONE DE TEST

    Combat isole dans Data/Map/mount_windswept_guardian.rsmap (l'arene du
    Sommet Venteux regeneree le 2026-08-05), sans passer par l'histoire.
    Modele : Data/Script/halcyon/zone/petit_tunnel/init.lua (donjon
    secondaire, retour Metano dans tous les cas).

    Retirable sans risque : ce fichier + Data/Zone/tornadus_arena.json +
    entree dans Data/Zone/index.idx + 1 ligne dans metano_town/init.lua +
    1 ligne dans services/debug_tools/init.lua.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local tornadus_arena = {}

function tornadus_arena.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_tornadus_arena")
  SV.TemporaryFlags.LastDungeonEntered = 'tornadus_arena'
end

function tornadus_arena.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function tornadus_arena.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function tornadus_arena.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_tornadus_arena result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Zone de test : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return tornadus_arena
