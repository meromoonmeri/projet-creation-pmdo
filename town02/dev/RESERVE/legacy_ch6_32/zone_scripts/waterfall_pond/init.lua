--[[
    init.lua
    Sanctuaire de Cristal (Crystal Sanctuary) — Chapitre 8
    conception_donjons_segmentes.md : etages + relais + 3F + mini-boss
    (Strassie + Momartik, segment 3) + 3F + boss Diancie (segment 5).
    Segment 6 : annexe Toupie (etage mystere).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.ChapterAftermath'
require 'halcyon.ReplayEnding'

local waterfall_pond = {}

--------------------------------------------------------------------
-- INDEX DES GROUNDS DE master_zone — resolus PAR NOM
--
-- CORRECTIF (audit 2026-08-04). Ce fichier ciblait des index ECRITS EN
-- DUR qui ne designaient plus les cartes voulues : master_zone a grossi
-- depuis, et tout ce qui suivait un ajout s'est decale.
--   46 -> vast_steppe_entrance  (attendu : metano_town)
--   Mourir dans la premiere moitie renvoyait a un donjon du chapitre 5.
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
    PrintInfo("[waterfall_pond] ground introuvable dans master_zone : " .. tostring(name)
              .. " — repli sur " .. tostring(MASTER_FALLBACK))
    return MASTER_FALLBACK
  end
  return idx
end


function waterfall_pond.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_waterfall_pond")
  SV.TemporaryFlags.LastDungeonEntered = 'waterfall_pond'
end

function waterfall_pond.EnterSegment(zone, rescuing, segmentID, mapID)
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
    if rescuing ~= true then
        COMMON.BeginDungeon(zone.ID, segmentID, mapID)
    end
end

function waterfall_pond.Rescued(zone, name, mail)
    COMMON.Rescued(zone, name, mail)
end

function waterfall_pond.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_waterfall_pond result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
      return
  end
  if segmentID == 6 then
    -- Annexe de la Toupie (etage mystere) : sortie douce.
    GAME:WaitFrames(10)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('metano_town'), 0, false, false)
    return
  end

  if segmentID == 0 then
      -- Galerie Cristalline : 12 etages
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('waterfall_pond', 8) then
          SV.Chapter8.ReachedCrystalRelay = true
          GAME:ContinueDungeon('waterfall_pond', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter8.LostCrystalGallery = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('metano_town'), 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Les cristaux...[pause=0] ils emprisonnent tout...[pause=15] meme la lumiere...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, GROUND_IDX('metano_town'), 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('metano_town'), 0, true, true)
          end
      end
  elseif segmentID == 1 then
      -- Relais
      if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX('metano_town'), 0, true, true)
      end
  elseif segmentID == 2 then
      -- Premier 3F des Salles des Glyphes : le mini-boss attend au bout.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('waterfall_pond', 8) then
          PrintInfo("[NREPROBE][transition] crystal seg2 cleared -> miniboss ground")
          GAME:ContinueDungeon('waterfall_pond', 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter8.LostGlyphHalls = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter8.SanctuaryMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('metano_town'), 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Les runes...[pause=0] elles parlent...[pause=20] mais on ne comprend pas...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, GROUND_IDX('metano_town'), 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('metano_town'), 0, true, true)
          end
      end
  elseif segmentID == 3 then
      -- ARENE MINI-BOSS (Strassie + Momartik) : victoire ou defaite, on
      -- revient sur la ground de cinematique qui lit les flags.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter8.CrystalMiniBossDefeated = true
      else
          SV.Chapter8.CrystalMiniBossLost = true
      end
      PrintInfo("[NREPROBE][transition] crystal seg3 (arene) -> miniboss ground")
      GAME:ContinueDungeon('waterfall_pond', 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  elseif segmentID == 4 then
      -- Second 3F des Salles des Glyphes : la chambre de Diancie s'ouvre.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('waterfall_pond', 8) then
          SV.Chapter8.ReachedDiancieChamber = true
          PrintInfo("[NREPROBE][transition] crystal seg4 cleared -> boss ground")
          GAME:ContinueDungeon('waterfall_pond', 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter8.LostGlyphHalls = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter8.SanctuaryMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('metano_town'), 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Les runes...[pause=0] elles parlent...[pause=20] mais on ne comprend pas...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, GROUND_IDX('metano_town'), 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('metano_town'), 0, true, true)
          end
      end
  elseif segmentID == 5 then
      -- Boss Diancie
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter8.DefeatedTerapagos = true
          SV.Chapter8.DefeatedDiancie = true -- compatibilité anciennes sauvegardes/scènes
          SV.Chapter8.ObtainedCrystalFragment = true
          SV.Chapter8.CrystalSanctuaryComplete = true
          --Scene d'apres-boss : la consequence se joue AVANT le retour a la
          --guilde. Sans elle, le combat le plus important du chapitre se
          --terminait par un simple fondu vers la fin de journee.
          ChapterAftermath.CrystalVictory()
          --Fin de chapitre : on rentre dormir a la guilde pour la veillee
          --(guild_heros_room_ch_8). Sans ces drapeaux la scene de chambre ne se
          --declenchait JAMAIS, et sans la carte 2 on ressortait au relais du donjon.
          SV.TemporaryFlags.Dinnertime = true
          SV.TemporaryFlags.Bedtime = true
          SV.TemporaryFlags.MorningWakeup = true
          SV.TemporaryFlags.MorningAddress = true
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 2, 0, true, true)
      else
          -- Le checkpoint est établi après F15. Une défaite contre Terapagos
          -- renvoie au relais, sans réinitialiser les flags narratifs ni le boss.
          SV.Chapter8.DiedToTerapagos = true
          SV.Chapter8.TerapagosDefeats = (SV.Chapter8.TerapagosDefeats or 0) + 1
          SV.Chapter8.SanctuaryMidState = 'TerapagosRespawn'
          GAME:WaitFrames(20)
          GAME:ContinueDungeon('waterfall_pond', 1, 0, 0,
            RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      end
  end
end

return waterfall_pond
