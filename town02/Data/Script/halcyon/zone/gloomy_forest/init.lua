-- [dungeon_builder] script de zone canonique généré — Sinister Woods route
-- DungeonDefs/canonical/sinister_woods.json.
-- Runtime segments: 0=1F-6F, 1=7F-12F, 2=D04P02 exact fixed battle map.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local gloomy_forest = {}
local LAST_SEGMENT = 2

local function MASTER_GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('master_zone')
    for ii = 0, zone.Grounds.Count - 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then return 1 end
  return idx
end

local function ReturnToTown(result)
  local town_idx = MASTER_GROUND_IDX('metano_town')
  if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') == '1' then
    PrintInfo('[SINISTER_ROUTE] EndDungeonRun headless begin town='..tostring(town_idx))
    local commit = GAME:_EndDungeonRun(result, 'master_zone', -1,
      town_idx, 0, false, false)
    commit:MoveNext() -- executes native EndGame through its terminal WaitForFrames(20)
    PrintInfo('[SINISTER_ROUTE] EndDungeonRun headless state committed; terminal wait skipped')
    GAME:EnterZone('master_zone', -1, town_idx, 0)
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1,
      town_idx, 0, true, true)
  end
end

local function ReturnToMidpoint()
  SV.GloomyForest = SV.GloomyForest or {}
  SV.GloomyForest.DiedPastCheckpoint = true
  SV.Chapter6.GloomyMidpointState = 'DeathArrival'
  GAME:EnterGroundMap('gloomy_forest_midpoint', 'Main_Entrance_Marker')
end

function gloomy_forest.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'gloomy_forest'
end

function gloomy_forest.EnterSegment(zone, rescuing, segmentID, mapID)
  if segmentID == LAST_SEGMENT then
    GAME:SetRescueAllowed(false)
  else
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
  end
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function gloomy_forest.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function gloomy_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo('[SINISTER_ROUTE] ExitSegment begin segment='..tostring(segmentID)..' result='..tostring(result))
  GeneralFunctions.RestoreIdleAnim()
  PrintInfo('[SINISTER_ROUTE] ExitSegment idle restored')
  DEBUG.EnableDbgCoro()
  if COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID) then
    PrintInfo('[SINISTER_ROUTE] ExitSegment intercepted by mission check')
    return
  end
  PrintInfo('[SINISTER_ROUTE] ExitSegment mission check passed')
  SV.adventure.Thief = false

  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped and segmentID >= 1 then
      ReturnToMidpoint()
    else
      ReturnToTown(result)
    end
    return
  end

  if segmentID == 0 then
    -- Supplemental New Era checkpoint after canonical 6F.
    SV.Chapter6.GloomyMidpointState = 'FirstArrival'
    PrintInfo('[SINISTER_ROUTE] ExitSegment segment0 -> gloomy_forest_midpoint')
    if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') == '1' then
      GAME:EnterZone(zone.ID, -1, 1, 0)
    else
      GAME:EnterGroundMap('gloomy_forest_midpoint', 'Main_Entrance_Marker')
    end
    PrintInfo('[SINISTER_ROUTE] ExitSegment segment0 transition completed')
  elseif segmentID == 1 then
    -- PMD Red fixed/event floor 13: D04P02 canonical Ground.
    PrintInfo('[SINISTER_ROUTE] ExitSegment segment1 -> sinister_woods_clearing')
    if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') == '1' then
      GAME:EnterZone(zone.ID, -1, 2, 0)
    else
      GAME:EnterGroundMap('sinister_woods_clearing', 'Main_Entrance_Marker')
    end
    PrintInfo('[SINISTER_ROUTE] ExitSegment segment1 transition completed')
  elseif segmentID == 2 then
    -- Battle occurred on the pixel-exact D04P02 map counterpart.
    SV.CanonicalDungeons = SV.CanonicalDungeons or {}
    SV.CanonicalDungeons.gloomy_forest = true
    SV.Chapter6.DefeatedGloomyBoss = true
    SV.Chapter6.MissionComplete = true
    SV.Chapter6.MissionAccepted = false
    PrintInfo('[SINISTER_ROUTE] ExitSegment segment2 flags committed')
    ReturnToTown(result)
  else
    ReturnToTown(result)
  end
end

return gloomy_forest
