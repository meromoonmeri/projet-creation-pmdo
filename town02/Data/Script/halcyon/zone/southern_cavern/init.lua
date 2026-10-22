-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Caverne Méridionale (southern_cavern) — chapitre 17.
     Zone reconstruite par tools/dungeon_builder : 3 segment(s).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local southern_cavern = {}

local LAST_SEGMENT = 2

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
  PrintInfo('[southern_cavern] Ground absent de la zone : ' .. tostring(name))
  return 0
end

local RETURN_GROUND = 'metano_town'

function southern_cavern.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'southern_cavern'
end

function southern_cavern.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function southern_cavern.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function southern_cavern.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    GAME:EnterDungeon('southern_cavern', 1, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  elseif segmentID == 1 then
    -- poursuite directe vers le segment 2 du même donjon
    GAME:EnterDungeon('southern_cavern', 2, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  elseif segmentID == 2 then
    -- aucun Ground final canonique : fin de run standard, aucun décor inventé
    SV.CanonicalDungeons['southern_cavern'] = true
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return southern_cavern
