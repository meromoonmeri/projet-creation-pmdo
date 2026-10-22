--[[ Trône de Magma — Donjon-Ancrage (Livre II, ch24). Vague 3.
     Segment 3 = arene de revanche (groudon). LegendZones key: gear_heart ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'
require 'halcyon.LegendArc'

local atelier_coeur_mecanique = {}

function atelier_coeur_mecanique.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_atelier_coeur_mecanique")
  SV.TemporaryFlags.LastDungeonEntered = 'atelier_coeur_mecanique'
end

function atelier_coeur_mecanique.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function atelier_coeur_mecanique.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function atelier_coeur_mecanique.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_atelier_coeur_mecanique result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  if segmentID == 2 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- Cinematique du gardien avant l'arene (vague 7).
    GAME:EnterGroundMap('carriere_magnetique', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 3 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('gear_heart')
      --Adieu du gardien : le combat ne le tue pas, il le STABILISE.
      --Sans cette scene la victoire etait un simple fondu (audit boss : 17/100).
      LegendArc.Victory('gear_heart')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['gear_heart'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return atelier_coeur_mecanique
