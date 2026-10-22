--[[
    init.lua — Antre de l'Énigme (antre_enigme)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.SuaireArc'

local antre_enigme = {}

function antre_enigme.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_antre_enigme")
  SV.TemporaryFlags.LastDungeonEntered = 'antre_enigme'
end

function antre_enigme.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function antre_enigme.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function antre_enigme.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_antre_enigme result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  -- Arc 2 « Ce que la brume emporte » : l'acte se joue a la sortie du donjon,
  -- une seule fois, et seulement si les actes precedents sont faits.
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    if SuaireArc.PlayAct('antre_enigme') then
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
      return
    end
  end

  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return antre_enigme
