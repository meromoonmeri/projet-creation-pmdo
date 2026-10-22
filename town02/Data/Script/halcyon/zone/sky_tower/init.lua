-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Tour Céleste (sky_tower) — chapitre 10.
     Zone reconstruite par tools/dungeon_builder : 1 segment(s).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local sky_tower = {}

local LAST_SEGMENT = 0

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
  PrintInfo('[sky_tower] Ground absent de la zone : ' .. tostring(name))
  return 0
end

local RETURN_GROUND = 'arc_parvis_celeste'

function sky_tower.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'sky_tower'
end

function sky_tower.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function sky_tower.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function sky_tower.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    -- scène canonique de transition vers sky_tower_summit
    SV.CanonicalDungeons.Pending = 'sky_tower_seg0'
    -- arc_palier_celeste ne porte aucun marqueur : la scène téléporte
    -- elle-même le joueur, on entre donc par index.
    GAME:EnterGroundMap(ZONE_GROUND_IDX(zone, 'arc_palier_celeste'), 0)
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return sky_tower
