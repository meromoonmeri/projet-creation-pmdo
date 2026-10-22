--[[ Mer des Tempêtes Sans Fin — zone add-on (Réseau des Anciens Chemins, id origine 19).
     Progression fidèle pret/pmd-red : 41 étages.
     Aucun impact histoire : entrée/sortie via master_zone carte 1 (Metano). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.VeilleurArc'

local new_era_zone_19 = {}

function new_era_zone_19.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_new_era_zone_19")
end

function new_era_zone_19.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function new_era_zone_19.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function new_era_zone_19.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end


  -- Veilleur du Réseau : segment 1 = arène (gyarados).
  if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- Veilleur : passage par le ground partage, qui enchaine vers l'arene (seg 1).
    GAME:EnterGroundMap('abime_tempetes', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 1 then
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
      if SV.Reseau.Veilleurs == nil then SV.Reseau.Veilleurs = {} end
      SV.Reseau.Veilleurs['new_era_zone_19'] = true
      --Adieu du Veilleur : il n'est pas vaincu, il est RELEVE.
      --Sans cette scene la victoire se resumait a UNE replique du
      --partenaire, et le Veilleur ne repondait jamais a la question
      --qu'il avait posee avant le combat (audit boss : 24/100).
      VeilleurArc.Victory('new_era_zone_19')
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      GeneralFunctions.SetEmotion("Happy")
      UI:WaitShowDialogue("Lame-de-Fond replonge.[pause=20] La Mer des Tempêtes s'ouvre enfin.")
    else
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      GeneralFunctions.SetEmotion("Sad")
      UI:WaitShowDialogue("La mer nous a recrachés...[pause=20] Cette tempête n'a pas dit son dernier mot.")
    end
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return new_era_zone_19
