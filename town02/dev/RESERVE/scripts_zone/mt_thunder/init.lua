--[[ Trône de Magma — Donjon-Ancrage (Livre II, ch17). Vague 3.
     Segment 5 = arene de revanche (groudon). LegendZones key: high_conductor ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'
require 'halcyon.LegendArc'

local mt_thunder = {}

function mt_thunder.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mt_thunder")
  SV.TemporaryFlags.LastDungeonEntered = 'mt_thunder'
end

function mt_thunder.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function mt_thunder.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function mt_thunder.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_mt_thunder result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  if segmentID == 2 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- Cinematique du gardien avant l'arene (vague 7).
    GAME:EnterGroundMap('porte_plaines_foudre', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 3 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('high_conductor')
      --Adieu du gardien : le combat ne le tue pas, il le STABILISE.
      --Sans cette scene la victoire etait un simple fondu (audit boss : 17/100).
      LegendArc.Victory('high_conductor')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['high_conductor'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return mt_thunder
