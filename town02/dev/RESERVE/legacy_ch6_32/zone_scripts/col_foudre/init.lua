--[[
    init.lua — Vague 2 (col_foudre)
    Donjon secondaire New Era (job board). Patron : zones secondaires existantes.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.SuaireArc'
require 'halcyon.SideExpeditions'

local col_foudre = {}

function col_foudre.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_col_foudre")
  SV.TemporaryFlags.LastDungeonEntered = 'col_foudre'
end

function col_foudre.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function col_foudre.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function col_foudre.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_col_foudre result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Expedition de requete secondaire : si le joueur en avait
  -- une en cours sur cette zone, la victoire la valide.
  pcall(function() SideExpeditions.OnDungeonCleared('col_foudre', result) end)

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  -- Arc 2 « Ce que la brume emporte » : l'acte se joue a la sortie du donjon,
  -- une seule fois, et seulement si les actes precedents sont faits.
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    if SuaireArc.PlayAct('col_foudre') then
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
      return
    end
  end

  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return col_foudre
