--[[ Tour du Destin — zone add-on (Réseau des Anciens Chemins, id origine Destiny Tower).
     Progression fidèle pret/pmd-red : 99 étages.
     Aucun impact histoire : entrée/sortie via master_zone carte 1 (Metano). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local new_era_sky_61 = {}

function new_era_sky_61.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_new_era_sky_61")
end

function new_era_sky_61.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function new_era_sky_61.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function new_era_sky_61.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return new_era_sky_61
