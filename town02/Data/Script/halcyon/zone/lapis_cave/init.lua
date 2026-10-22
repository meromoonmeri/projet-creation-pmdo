-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Grotte Lazuli (lapis_cave) — chapitre 10 PMD Red.
     Zone reconstruite par tools/dungeon_builder : 1 segment(s).
       * segment 0 : 14 étages procéduraux (RogueElements natif, biome
         lapis_gallery, DTEF lapis_cave). Correspond aux floors 1–14 ROM
         (aucun fixed_room dans la ROM pour ce donjon).
       * Après clear seg 0, transition vers le Ground canonique
         grotte_lazuli_fond (scène de fin canonique PMD Red d08p02).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local lapis_cave = {}

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
  PrintInfo('[lapis_cave] Ground absent de la zone : ' .. tostring(name))
  return 0
end

local RETURN_GROUND = 'grotte_lazuli_seuil'

function lapis_cave.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'lapis_cave'
end

function lapis_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function lapis_cave.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function lapis_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    -- Ground final canonique : cinématique, combat et fin au même endroit
    SV.CanonicalDungeons.Pending = 'lapis_cave_seg0'
    GAME:EnterZone(zone.ID, -1, ZONE_GROUND_IDX(zone, 'grotte_lazuli_fond'), 0)
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return lapis_cave
