--[[
    init.lua — Bosquet Voilé (bosquet_voile)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.SuaireArc'

local bosquet_voile = {}

function bosquet_voile.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bosquet_voile")
  SV.TemporaryFlags.LastDungeonEntered = 'bosquet_voile'
end

function bosquet_voile.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function bosquet_voile.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function bosquet_voile.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_bosquet_voile result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  -- Arc 2 « Ce que la brume emporte » : l'acte se joue a la sortie du donjon,
  -- une seule fois, et seulement si les actes precedents sont faits.
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    if SuaireArc.PlayAct('bosquet_voile') then
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
      return
    end
  end

  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return bosquet_voile
