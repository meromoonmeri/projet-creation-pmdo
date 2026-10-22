--[[ Île des Longues Cendres — Donjon-Ancrage (Livre II, ch14). Vague 3.
     Segment 5 = arene de revanche (moltres). LegendZones key: long_ash_isle ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'
require 'halcyon.LegendArc'

local mt_blaze = {}

function mt_blaze.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mt_blaze")
  SV.TemporaryFlags.LastDungeonEntered = 'mt_blaze'
end

function mt_blaze.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function mt_blaze.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function mt_blaze.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_mt_blaze result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  if segmentID == 2 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- Cinematique du gardien avant l'arene (vague 7).
    GAME:EnterGroundMap('champ_braises', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 3 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('long_ash')
      --Adieu du gardien : le combat ne le tue pas, il le STABILISE.
      --Sans cette scene la victoire etait un simple fondu (audit boss : 17/100).
      LegendArc.Victory('long_ash')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['long_ash'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return mt_blaze
