--[[ Plaines du Grand Arc — zone add-on (Réseau des Anciens Chemins, id origine Amp Plains).
     Progression fidèle pret/pmd-red : 10 étages + relais + 9 étages.
     Aucun impact histoire : entrée/sortie via master_zone carte 1 (Metano). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local new_era_sky_12 = {}

function new_era_sky_12.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_new_era_sky_12")
end

function new_era_sky_12.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function new_era_sky_12.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function new_era_sky_12.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  -- Segment 0 franchi : halte à la Station-Relais (Terminal de Sauvegarde).
  if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EnterGroundMap('new_era_sky_12_relais', 'Main_Entrance_Marker')
    return
  end

  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return new_era_sky_12
