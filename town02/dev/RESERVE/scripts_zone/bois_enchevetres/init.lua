--[[ Premier Berceau — Donjon-Ancrage (Livre II, ch26). Vague 3.
     Segment 5 = arene de revanche (mew/hoopa). LegendZones key: first_cradle_wilds ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'
require 'halcyon.LegendArc'

local bois_enchevetres = {}

function bois_enchevetres.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_enchevetres")
  SV.TemporaryFlags.LastDungeonEntered = 'bois_enchevetres'
end

function bois_enchevetres.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function bois_enchevetres.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function bois_enchevetres.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_bois_enchevetres result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  if segmentID == 4 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- Cinematique du gardien avant l'arene (vague 7).
    GAME:EnterGroundMap('arene_clairiere_secrete', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 5 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('first_cradle')
      --Adieu du gardien : le combat ne le tue pas, il le STABILISE.
      --Sans cette scene la victoire etait un simple fondu (audit boss : 17/100).
      LegendArc.Victory('first_cradle')
      LegendZones.SetDefeated('first_cradle_hoopa')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['first_cradle'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return bois_enchevetres
