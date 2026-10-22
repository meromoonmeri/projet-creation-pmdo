--[[
    init.lua — Grotte du Mystère (grotte_mystere)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.SuaireArc'

local grotte_mystere = {}

function grotte_mystere.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_mystere")
  SV.TemporaryFlags.LastDungeonEntered = 'grotte_mystere'
end

function grotte_mystere.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function grotte_mystere.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function grotte_mystere.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_grotte_mystere result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  -- Arc 2 « Ce que la brume emporte » : l'acte se joue a la sortie du donjon,
  -- une seule fois, et seulement si les actes precedents sont faits.
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    if SuaireArc.PlayAct('grotte_mystere') then
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
      return
    end
  end

  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return grotte_mystere
