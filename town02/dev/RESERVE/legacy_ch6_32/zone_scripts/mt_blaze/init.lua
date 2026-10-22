-- Mt. Blaze canonique PMD Red : 12F -> D09P02 -> Peak 3F -> D09P03/Moltres.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local mt_blaze = {}

function mt_blaze.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'mt_blaze'
end

function mt_blaze.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
  GAME:SetRescueAllowed(segmentID < 2)
end

function mt_blaze.Rescued(zone, name, mail) COMMON.Rescued(zone, name, mail) end

function mt_blaze.ExitSegment(zone, result, rescue, segmentID, mapID)
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  if exited then return end
  SV.adventure.Thief = false
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
    return
  end
  if segmentID == 0 then
    SV.CanonicalDungeons.Pending = 'mt_blaze_mid'
    GAME:EnterGroundMap('mt_blaze_midpoint', 'Main_Entrance_Marker')
  elseif segmentID == 1 then
    SV.CanonicalDungeons.Pending = 'mt_blaze_summit'
    GAME:EnterGroundMap('d09p03', 'Main_Entrance_Marker')
  else
    SV.CanonicalDungeons.MtBlazeCleared = true
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
  end
end

return mt_blaze
