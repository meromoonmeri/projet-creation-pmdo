--[[ Cœur de la Fournaise-Mère — zone add-on (Réseau des Anciens Chemins, id origine 15).
     Progression fidèle pret/pmd-red : 24 étages + relais + 4 étages (cime).
     Aucun impact histoire : entrée/sortie via master_zone carte 1 (Metano). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.VeilleurArc'

local new_era_zone_15 = {}

function new_era_zone_15.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_new_era_zone_15")
end

function new_era_zone_15.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function new_era_zone_15.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function new_era_zone_15.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  -- Segment 0 franchi : halte à la Station-Relais (Terminal de Sauvegarde).
  if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EnterGroundMap('new_era_zone_15_relais', 'Main_Entrance_Marker')
    return
  end


  -- Veilleur du Réseau : segment 2 = arène (volcarona).
  if segmentID == 1 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- Veilleur : on passe par le ground cinematique, qui enchainera lui-meme
    -- le ContinueDungeon vers l'arene (segment 2).
    GAME:EnterGroundMap('fosse_ardente', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 2 then
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
      if SV.Reseau.Veilleurs == nil then SV.Reseau.Veilleurs = {} end
      SV.Reseau.Veilleurs['new_era_zone_15'] = true
      --Adieu du Veilleur : il n'est pas vaincu, il est RELEVE.
      --Sans cette scene la victoire se resumait a UNE replique du
      --partenaire, et le Veilleur ne repondait jamais a la question
      --qu'il avait posee avant le combat (audit boss : 24/100).
      VeilleurArc.Victory('new_era_zone_15')
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      GeneralFunctions.SetEmotion("Happy")
      UI:WaitShowDialogue("Soleil-de-Cendre replie ses ailes.[pause=20] Le cœur de la Fournaise-Mère bat plus doucement.")
    else
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      GeneralFunctions.SetEmotion("Sad")
      UI:WaitShowDialogue("Ses ailes de braise nous ont repoussés...[pause=20] La Fournaise garde son secret.")
    end
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return new_era_zone_15
