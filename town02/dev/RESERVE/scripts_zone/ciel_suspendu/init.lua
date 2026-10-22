--[[ Assemblée des Cellules — Donjon-Ancrage (Livre II, ch30). Vague 3.
     Segment 1 = arene de revanche (zygarde). LegendZones key: cells_gathering ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'
require 'halcyon.LegendArc'

local ciel_suspendu = {}

function ciel_suspendu.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_ciel_suspendu")
  SV.TemporaryFlags.LastDungeonEntered = 'ciel_suspendu'
end

function ciel_suspendu.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function ciel_suspendu.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function ciel_suspendu.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_ciel_suspendu result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- Cinematique du gardien avant l'arene (vague 7).
    GAME:EnterGroundMap('terres_tues_porte', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 1 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('cells_gathering')
      --Adieu du gardien : le combat ne le tue pas, il le STABILISE.
      --Sans cette scene la victoire etait un simple fondu (audit boss : 17/100).
      LegendArc.Victory('cells_gathering')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['cells_gathering'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return ciel_suspendu
