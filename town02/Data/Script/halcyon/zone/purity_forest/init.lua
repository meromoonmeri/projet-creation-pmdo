-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Forêt de la Pureté (purity_forest) — chapitre 29.
     Zone reconstruite par tools/dungeon_builder : 4 segment(s).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local purity_forest = {}

local LAST_SEGMENT = 3

local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("master_zone")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then return 1 end
  return idx
end

local function ZONE_GROUND_IDX(zone, name)
  for ii = 0, zone.GroundMaps.Count - 1 do
    if zone.GroundMaps[ii] == name then return ii end
  end
  PrintInfo('[purity_forest] Ground absent de la zone : ' .. tostring(name))
  return 0
end

local RETURN_GROUND = 'metano_town'

function purity_forest.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'purity_forest'
end

function purity_forest.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function purity_forest.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function purity_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  if COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID) then return end
  SV.adventure.Thief = false
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}

  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
    return
  end

  if segmentID == 0 then
    -- poursuite directe vers le segment 1 du même donjon
    GAME:EnterDungeon('purity_forest', 1, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  elseif segmentID == 1 then
    -- poursuite directe vers le segment 2 du même donjon
    GAME:EnterDungeon('purity_forest', 2, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  elseif segmentID == 2 then
    -- poursuite directe vers le segment 3 du même donjon
    GAME:EnterDungeon('purity_forest', 3, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  elseif segmentID == 3 then
    -- Ground final canonique : cinématique, combat et fin au même endroit
    SV.CanonicalDungeons.Pending = 'purity_forest_seg3'
    GAME:EnterGroundMap('foret_guerison', 'Main_Entrance_Marker')
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return purity_forest
