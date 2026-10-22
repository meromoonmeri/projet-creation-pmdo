--[[ Faille du Silence Long — zone add-on (Réseau des Anciens Chemins, id origine 4).
     Progression fidèle pret/pmd-red : 10 étages.
     Aucun impact histoire : entrée/sortie via master_zone carte 1 (Metano). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local new_era_zone_04 = {}

function new_era_zone_04.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_new_era_zone_04")
end

function new_era_zone_04.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function new_era_zone_04.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function new_era_zone_04.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  -- Reseau : premiere victoire = la voie s'ouvre, courte scene dans le ground d'origine.
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    if SV.Reseau == nil then SV.Reseau = {} end
    if SV.Reseau.VoiesOuvertes == nil then SV.Reseau.VoiesOuvertes = {} end
    if not SV.Reseau.VoiesOuvertes['new_era_zone_04'] then
      SV.Reseau.VoiesOuvertes['new_era_zone_04'] = true
      GAME:EnterGroundMap('gouffre_muet_bord', 'Main_Entrance_Marker')
      return
    end
  end

  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return new_era_zone_04
