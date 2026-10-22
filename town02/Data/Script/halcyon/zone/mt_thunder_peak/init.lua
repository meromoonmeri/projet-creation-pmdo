-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ mt_thunder_peak — chapitre PMD Red.
     Zone reconstruite par tools/dungeon_builder : 2 segment(s).
       * segment 0 : étages procéduraux (RogueElements natif).
       * segment 1 : étage boss fixe canonique (LoadGen +
         MappedRoomStep('mt_thunder_peak_boss')) — contrepartie pixel-exacte du
         Ground canonique d06p03.
       * Après clear seg 1, transition vers le Ground canonique d06p03
         pour la cinématique de fin canonique.
     Règle verrouillée : Ground de cinématique = Ground du combat (via
     contrepartie .rsmap) = Ground final canonique. Aucune arène séparée.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local mt_thunder_peak = {}

local LAST_SEGMENT = 1

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
  PrintInfo('[mt_thunder_peak] Ground absent de la zone : ' .. tostring(name))
  return 0
end

-- Return Ground when player fails/escapes. The peak entrance script (the
-- base dungeon's relay Ground, e.g. d06p02 for mt_thunder_peak) already
-- came from a canonical Ground; on failure we fall back to the peak's
-- own entrance so the player is not stranded.
local RETURN_GROUND = 'd06p03'

function mt_thunder_peak.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'mt_thunder_peak'
end

function mt_thunder_peak.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function mt_thunder_peak.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function mt_thunder_peak.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    -- Segment procédural terminé : on enchaîne sur le segment boss fixe.
    GAME:EnterZone(zone.ID, 1, 0, 0)
  elseif segmentID == 1 then
    -- Boss battu : transition vers le Ground canonique de fin.
    SV.CanonicalDungeons.Pending = 'mt_thunder_peak_seg1'
    GAME:EnterZone(zone.ID, -1, ZONE_GROUND_IDX(zone, 'd06p03'), 0)
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return mt_thunder_peak
