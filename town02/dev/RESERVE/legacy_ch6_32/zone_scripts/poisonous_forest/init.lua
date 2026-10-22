--[[
    init.lua
    Marais de l'Oubli (Forgotten Marsh) — Chapitre 9
    conception_donjons_segmentes.md : berges + relais + 3F + mini-boss
    (Avaltout + Coatox, segment 3) + 3F + boss Mega-Blastoise (segment 5).
    Segment 6 : annexe Toupie (etage mystere).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.ChapterAftermath'
require 'halcyon.ReplayEnding'

local poisonous_forest = {}

--------------------------------------------------------------------
-- INDEX DES GROUNDS DE master_zone — resolus PAR NOM
--
-- CORRECTIF (audit 2026-08-04). Ce fichier ciblait des index ECRITS EN
-- DUR qui ne designaient plus les cartes voulues : master_zone a grossi
-- depuis, et tout ce qui suivait un ajout s'est decale.
--   46 -> vast_steppe_entrance     (attendu : poisonous_forest_entrance)
--   73 -> celestial_peak_entrance  (attendu : poisonous_forest_relay)
-- Meme defaut, meme remede que zone/cloven_ruins, zone/vast_steppe et
-- zone/celestial_peak : resolution par NOM a l'execution, qui ne peut
-- plus rederiver quand un ground est ajoute ou retire.
--------------------------------------------------------------------
local MASTER_FALLBACK = 1  -- metano_town

local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("master_zone")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then
    PrintInfo("[poisonous_forest] ground introuvable dans master_zone : " .. tostring(name)
              .. " — repli sur " .. tostring(MASTER_FALLBACK))
    return MASTER_FALLBACK
  end
  return idx
end


function poisonous_forest.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_poisonous_forest")
  SV.TemporaryFlags.LastDungeonEntered = 'poisonous_forest'
end

function poisonous_forest.EnterSegment(zone, rescuing, segmentID, mapID)
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
    if rescuing ~= true then
        COMMON.BeginDungeon(zone.ID, segmentID, mapID)
    end
end

function poisonous_forest.Rescued(zone, name, mail)
    COMMON.Rescued(zone, name, mail)
end

function poisonous_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_poisonous_forest result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
      return
  end
  if segmentID == 6 then
    -- Annexe de la Toupie (etage mystere) : sortie douce.
    GAME:WaitFrames(10)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
    return
  end

  if segmentID == 0 then
      -- Berges Putrides : 10 etages
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('poisonous_forest', 9) then
          SV.Chapter9.ReachedMarshRelay = true
          GAME:EnterGroundMap('poisonous_forest_relay', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter9.LostMarshBanks = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('poisonous_forest_entrance'), 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "La vase...[pause=0] elle nous aspire...[pause=20] vers le fond...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, GROUND_IDX('poisonous_forest_entrance'), 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('poisonous_forest_entrance'), 0, true, true)
          end
      end
  elseif segmentID == 1 then
      -- Relais
      if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:EnterGroundMap('poisonous_forest_relay', 'Main_Entrance_Marker')
      end
  elseif segmentID == 2 then
      -- Premier 3F des Abysses Vaseux : le mini-boss attend au bout.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('poisonous_forest', 9) then
          PrintInfo("[NREPROBE][transition] marsh seg2 cleared -> miniboss ground")
          GAME:EnterGroundMap('poisonous_forest_miniboss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter9.LostMarshDepths = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter9.MarshMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('poisonous_forest_relay'), 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Une ombre...[pause=0] dans la brume...[pause=30] elle nous regardait...", "Shock")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, GROUND_IDX('poisonous_forest_relay'), 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('poisonous_forest_relay'), 0, true, true)
          end
      end
  elseif segmentID == 3 then
      -- ARENE MINI-BOSS (Avaltout + Coatox) : victoire ou defaite, on
      -- revient sur la ground de cinematique qui lit les flags.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter9.MarshMiniBossDefeated = true
      else
          SV.Chapter9.MarshMiniBossLost = true
      end
      PrintInfo("[NREPROBE][transition] marsh seg3 (arene) -> miniboss ground")
      GAME:EnterGroundMap('poisonous_forest_miniboss', 'Main_Entrance_Marker')
  elseif segmentID == 4 then
      -- Second 3F des Abysses Vaseux — le Cercle du Suaire rode, et la
      -- cale de Laggron s'ouvre au bout.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('poisonous_forest', 9) then
          SV.Chapter9.ReachedMarshDepths = true
          SV.Chapter9.SawCercleDuSuaire = true
          PrintInfo("[NREPROBE][transition] marsh seg4 cleared -> boss ground")
          GAME:ContinueDungeon('poisonous_forest', 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter9.LostMarshDepths = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter9.MarshMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('poisonous_forest_relay'), 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Une ombre...[pause=0] dans la brume...[pause=30] elle nous regardait...", "Shock")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, GROUND_IDX('poisonous_forest_relay'), 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('poisonous_forest_relay'), 0, true, true)
          end
      end
  elseif segmentID == 5 then
      -- Boss Mega-Blastoise
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter9.DefeatedMegaBlastoise = true
          SV.Chapter9.PurifiedMarshCore = true
          SV.Chapter9.ForgottenMarshComplete = true
          --Scene d'apres-boss : la consequence se joue AVANT le retour a la
          --guilde. Sans elle, le combat le plus important du chapitre se
          --terminait par un simple fondu vers la fin de journee.
          ChapterAftermath.MarshVictory()
          --Fin de chapitre : on rentre dormir a la guilde pour la veillee
          --(guild_heros_room_ch_9). Sans ces drapeaux la scene de chambre ne se
          --declenchait JAMAIS, et sans la carte 2 on ressortait au relais du donjon.
          SV.TemporaryFlags.Dinnertime = true
          SV.TemporaryFlags.Bedtime = true
          SV.TemporaryFlags.MorningWakeup = true
          SV.TemporaryFlags.MorningAddress = true
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 2, 0, true, true)
      else
          SV.Chapter9.DiedToMegaBlastoise = true
          SV.Chapter9.MarshMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('poisonous_forest_relay'), 0, true, true)
          GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
              "Le marecage...[pause=0] nous engloutit...[pause=20] tout disparait...", "Pain")
          GAME:WaitFrames(20)
          GAME:EnterZone("master_zone", -1, GROUND_IDX('poisonous_forest_relay'), 0)
      end
  end
end

return poisonous_forest
