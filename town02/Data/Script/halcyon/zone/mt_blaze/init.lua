-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Mont Cendré (mt_blaze) — chapitre 9 PMD Red.
     Zone reconstruite par tools/dungeon_builder : 1 segment(s).
       * segment 0 : 12 étages procéduraux (RogueElements natif, biome
         blaze_slope, DTEF mt_blaze). Correspond aux floors 1–12 ROM
         (aucun fixed_room dans la ROM pour ce donjon).
       * Après clear seg 0, transition vers le Ground canonique d09p02
         (scène de relais PMD Red "Mt. Blaze").
     Règle verrouillée : Ground de cinématique = Ground final canonique.
     Aucune arène séparée, aucun midpoint générique inventé (le legacy
     Kangourex clone `mt_blaze_midpoint` est déprécié et remplacé par ce
     câblage canonique).
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local mt_blaze = {}

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
  PrintInfo('[mt_blaze] Ground absent de la zone : ' .. tostring(name))
  return 0
end

local RETURN_GROUND = 'mont_cendre_pied'

function mt_blaze.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'mt_blaze'
end

function mt_blaze.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function mt_blaze.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function mt_blaze.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    -- Ground final canonique : cinématique de relais Mt. Blaze puis
    -- transition vers mt_blaze_peak (chaînage story canonique).
    SV.CanonicalDungeons.Pending = 'mt_blaze_seg0'
    GAME:EnterZone(zone.ID, -1, ZONE_GROUND_IDX(zone, 'd09p02'), 0)
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return mt_blaze
