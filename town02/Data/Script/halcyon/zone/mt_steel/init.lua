-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Pic Ferreux (mt_steel) — chapitre 7 PMD Red.
     Zone reconstruite par tools/dungeon_builder : 2 segment(s).
       * segment 0 : 8 étages procéduraux (RogueElements natif, biome
         steel_slope, DTEF mt_steel_1). Correspond aux floors 1–8 ROM.
       * segment 1 : 1 étage boss fixe canonique (LoadGen +
         MappedRoomStep('mt_steel_boss')) — contrepartie pixel-exacte du
         Ground canonique d03p02, hébergeant Skarmory lvl 10
         (PMD_RED_ROM/FIXED_ROOM_MT_STEEL_SKARMORY).
       * Après clear seg 1, transition vers le Ground d03p02 pour la
         cinématique canonique "In The Depths Of The Pit" (post-Skarmory).
     Règle verrouillée : Ground de cinématique = Ground du combat (via
     contrepartie .rsmap) = Ground final canonique. Aucune arène séparée.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local mt_steel = {}

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
  PrintInfo('[mt_steel] Ground absent de la zone : ' .. tostring(name))
  return 0
end

local RETURN_GROUND = 'pic_ferreux_pied'

function mt_steel.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'mt_steel'
end

function mt_steel.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function mt_steel.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function mt_steel.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    -- Segment procédural terminé : on enchaîne sur le segment boss fixe
    -- (Skarmory sur la contrepartie .rsmap pixel-exacte de d03p02).
    -- EnterZone(zone, segmentID>=0, floor, entryPoint) charge un segment de
    -- donjon (au contraire de segmentID=-1 qui charge un GroundMap).
    GAME:EnterZone(zone.ID, 1, 0, 0)
  elseif segmentID == 1 then
    -- Boss Skarmory battu : transition vers le Ground canonique d03p02
    -- pour la cinématique canonique "In The Depths Of The Pit".
    -- Même pattern que silent_chasm/great_canyon : EnterZone(zone, -1,
    -- GroundIdx, 0) charge un GroundMap.
    SV.CanonicalDungeons.Pending = 'mt_steel_seg1'
    GAME:EnterZone(zone.ID, -1, ZONE_GROUND_IDX(zone, 'd03p02'), 0)
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return mt_steel
