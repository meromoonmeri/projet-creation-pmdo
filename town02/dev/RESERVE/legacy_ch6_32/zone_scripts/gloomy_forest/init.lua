require 'origin.common'
require 'halcyon.services.sinister_woods_b41_startup_adapter'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'
require 'halcyon.ReplayEnding'
require 'halcyon.DazzlingArc'
require 'halcyon.TownNight'
require 'halcyon.TownRaid'
require 'halcyon.LivingWorld'

local gloomy_forest = {}

--------------------------------------------------------------------
-- INDEX DES GROUNDS DE master_zone — resolus PAR NOM
--
-- CORRECTIF (audit 2026-08-04). Ce fichier ciblait des index ECRITS EN
-- DUR qui ne designaient plus les cartes voulues : master_zone a grossi
-- depuis, et tout ce qui suivait un ajout s'est decale.
--   61 -> mount_windswept_miniboss  (attendu : gloomy_forest_midpoint)
--   Le commentaire du code annoncait deja « gloomy_forest_midpoint ».
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
    PrintInfo("[gloomy_forest] ground introuvable dans master_zone : " .. tostring(name)
              .. " — repli sur " .. tostring(MASTER_FALLBACK))
    return MASTER_FALLBACK
  end
  return idx
end


function gloomy_forest.Init(zone)
	DEBUG.EnableDbgCoro()
	PrintInfo("=>> Init_gloomy_forest")
	SV.TemporaryFlags.LastDungeonEntered = 'gloomy_forest'
end

function gloomy_forest.EnterSegment(zone, rescuing, segmentID, mapID)
	-- Rescues allowed outside arenas, disallowed in the mini-boss arena
	-- (segment 2) and the boss fight (segment 4).
	if segmentID == 2 or segmentID == 4 then
		GAME:SetRescueAllowed(false)
	else
		GeneralFunctions.CheckAllowSetRescue(zone.ID)
	end
	if rescuing ~= true then
		COMMON.BeginDungeon(zone.ID, segmentID, mapID)
	end
end

function gloomy_forest.Rescued(zone, name, mail)
	COMMON.Rescued(zone, name, mail)
end

------------------------------------------------------------------
-- ExitSegment
------------------------------------------------------------------
-- Gloomy Forest segments (conception_donjons_segmentes.md, ch6+) :
--   0  = F01-F15 Sinister/Mystifying Forest
--   1  = F16-F20 continuité canonique (objectif de sauvetage Chenipent)
--   2  = ARENE MINI-BOSS (gloomy_forest_miniboss.rsmap : Tengalice + Cornèbre)
--   3  = F21-F23 Deep Shadow Forest
--   4  = boss (Zeraora, LoadGen gloomy_forest_boss.rsmap)
--   5  = Serment Verdoyant (revanche Zeraora, LegendZones 'verdant_oath')
--   6  = annexe Toupie
--   7  = Epreuve des Trois (duel Team Dazzling)
--   8-10 = pillards de Metano (raid nocturne, 3 vagues)
--
-- A mid-dungeon relay "gloomy_forest_midpoint" (master_zone mapID 61) sits between
-- segment 0 and segment 1. Dying past it respawns at the relay instead
-- of Metano Town. Faithful mirror of zone/searing_tunnel + zone/crooked_cavern.
-- See docs/audit_checkpoint_crooked_cavern.md (reusable pattern).
------------------------------------------------------------------
--Retour de fin de journee. N'est utilise QUE lorsque l'equipe rentre
--reellement dormir : les morts au-dela du relais de mi-donjon reapparaissent
--au relais (carte 61) et ne declenchent pas la nuit. Le corps de cette fonction vivait ici et a ete
--deplace dans TownNight.EndDay : les 8 autres donjons repetaient la meme
--sequence, la partager evite d'en maintenir neuf copies.
local function EndDayReturn(result)
	TownNight.EndDay(result, true)
end

function gloomy_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
	GeneralFunctions.RestoreIdleAnim()
	DEBUG.EnableDbgCoro()
	PrintInfo("=>> ExitSegment_gloomy_forest result " .. tostring(result) .. " segment " .. tostring(segmentID))

	local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
	SV.adventure.Thief = false
	if exited == true then return end
  if segmentID == 6 then
    -- Annexe de la Toupie (etage mystere) : on ressort simplement de la salle,
    -- l'exploration du donjon reprend au meme titre qu'un etage traverse.
    GAME:WaitFrames(10)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
    return
  end

  -- PILLARDS DE METANO (segments 8, 9, 10). Ces trois arenes ne sont pas des
  -- etages de la Foret : ce sont les vagues de raid nocturne, hebergees ici
  -- parce qu'un segment doit appartenir a une zone existante. On rentre donc
  -- a la VILLE DE NUIT, pas au donjon.
  if segmentID >= 8 and segmentID <= 10 then
    GAME:WaitFrames(20)
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      -- Victoire : retour a la nuit. TownRaid.Pending est encore vrai, donc
      -- metano_town_nuit.Enter enchaine sur TownRaid.Victory().
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
      GAME:WaitFrames(20)
      TownNight.Enter()
    else
      -- Defaite : le heros s'ecroule sur la place (RaidScenes.Collapse,
      -- appele par TownRaid.Defeat), la ville est pillee, et il se reveille
      -- le lendemain a la chambre avec la guilde a son chevet.
      --
      -- On ne pose PAS Bedtime/MorningWakeup ici : le duo est deja
      -- inconscient, il n'y a pas de coucher a jouer. RaidScenes.Bedside
      -- assure a lui seul le reveil, le debrief et la remise en main.
      -- Seul MorningAddress reste, pour que la journee suivante enchaine
      -- normalement une fois les visiteurs sortis.
      pcall(function() TownRaid.Defeat() end)
      SV.TemporaryFlags.MorningAddress = true
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 2, 0, true, true)
    end
    return
  end

	if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
		-- *** CHECKPOINT (NEW) *** : stop at the relay instead of flowing directly
		-- into the depth floors. The relay's North exit starts segment 1.
		-- (Original was: GAME:ContinueDungeon("gloomy_forest", 1, 0, 0, ...).)
		SV.Chapter6.GloomyMidpointState = 'FirstArrival'
		GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('gloomy_forest_midpoint'), 0, false, false) --gloomy_forest_midpoint (mapID 61)
		return
	end

	if segmentID == 1 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
		-- Les étages F16-F20 de sauvetage sont derrière nous : le gardien du coeur attend
		-- (mini-boss, segment 2). La mission Chenipent doit etre remplie avant.
		if SV.Chapter6.ChenipentFound or ReplayEnding.IsCleared('gloomy_forest') then
			PrintInfo("[NREPROBE][transition] gloomy seg1 cleared -> miniboss ground")
			GAME:EnterGroundMap('gloomy_forest_miniboss', 'Main_Entrance_Marker')
		else
			-- The rescue objective is required before the heart of the forest opens.
			SV.Chapter6.MissionAccepted = false
			EndDayReturn(result)
		end
		return
	end

	if segmentID == 2 then
		-- ARENE MINI-BOSS : victoire ou defaite, on revient sur la ground de
		-- cinematique qui lit les flags (miroir exact de mount_windswept seg 1).
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
			SV.Chapter6.GloomyMiniBossDefeated = true
		else
			SV.Chapter6.GloomyMiniBossLost = true
		end
		PrintInfo("[NREPROBE][transition] gloomy seg2 (arene) -> miniboss ground")
		GAME:EnterGroundMap('gloomy_forest_miniboss', 'Main_Entrance_Marker')
		return
	end

	if segmentID == 3 then
		-- F21-F23 Deep Shadow : le coeur de la foret s'ouvre au bout.
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
			PrintInfo("[NREPROBE][transition] Sinister Woods seg3 -> clairiere canonique D04P02")
			GAME:EnterGroundMap('sinister_woods_clearing', 'Main_Entrance_Marker')
		elseif result == RogueEssence.Data.GameProgress.ResultType.Escaped then
			-- Escaped: leave to the entrance, NOT the relay (mirrors Searing Tunnel).
			GAME:WaitFrames(20)
			SV.Chapter6.MissionAccepted = false
			EndDayReturn(result)
		else
			-- Died: respawn at the relay.
			SV.GloomyForest.DiedPastCheckpoint = true
			SV.Chapter6.GloomyMidpointState = 'DeathArrival'
			GAME:WaitFrames(20)
			GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('gloomy_forest_midpoint'), 0, true, true) --relay (mapID 61)
			GAME:WaitFrames(20)
			GAME:EnterZone("master_zone", -1, GROUND_IDX('gloomy_forest_midpoint'), 0)
		end
		return
	end

	if segmentID == 1 and result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		-- *** CHECKPOINT (NEW) *** : died/escaped in the depth floors.
		if result == RogueEssence.Data.GameProgress.ResultType.Escaped then
			-- Escaped: leave to the entrance, NOT the relay (mirrors Searing Tunnel).
			GAME:WaitFrames(20)
			SV.Chapter6.MissionAccepted = false
			--Fuite volontaire : l'equipe abandonne pour aujourd'hui et rentre dormir.
			EndDayReturn(result)
		else
			-- Died: respawn at the relay.
			SV.GloomyForest.DiedPastCheckpoint = true
			SV.Chapter6.GloomyMidpointState = 'DeathArrival'
			GAME:WaitFrames(20)
			GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('gloomy_forest_midpoint'), 0, true, true) --relay (mapID 61)
			GAME:WaitFrames(20)
			GAME:EnterZone("master_zone", -1, GROUND_IDX('gloomy_forest_midpoint'), 0)
		end
		return
	end

	if segmentID == 4 then
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
			SV.Chapter6.GloomyBossEncountered = true
			SV.Chapter6.DefeatedGloomyBoss = true
			SV.Chapter6.MissionComplete = true
			SV.Chapter6.DazzlingPresenceStage = 5
			SV.Chapter6.DazzlingChapterResolved = true
			pcall(function()
				LivingWorld.Publish('chenipent_rescued','guild_report',
				  'Chenipent a été retrouvé dans les profondeurs de Gloomy Forest.',
				  {'guild','treasure','metano'},1)
				LivingWorld.Publish('dazzling_gloomy_rivalry','traveler_report',
				  'La Team Dazzling et une équipe de Metano ont traversé la forêt ensemble.',
				  {'treasure','guild','metano'},1)
			end)
			SV.Chapter6.DefeatedByZeraora = false
			SV.Chapter6.MissionAccepted = false
			--Scene d'apres-boss : la consequence se joue AVANT le retour en
			--ville, exactement comme aux chapitres 8, 9 et 10
			--(ChapterAftermath). Sans elle, le seul boss « personnage » du
			--chapitre s'eteignait sur un fondu au noir.
			DazzlingArc.GloomyVictory()
			--Le duel des Trois est desormais propose au relais : elles ont
			--suivi l'equipe et attendent au coeur de la clairiere.
			SV.Chapter6.DazzlingTrialOffered = true
			-- Beat the boss: return to town (UNCHANGED).
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
		else
			-- *** CHECKPOINT (NEW) *** : died/escaped to the boss (Zeraora) -> respawn at
			-- the relay (previously returned to town, mapID 1). GloomyBossEncountered
			-- stays true so the next gloomy_forest_boss visit plays the retry scene.
			SV.GloomyForest.DiedPastCheckpoint = true
			SV.Chapter6.GloomyMidpointState = 'DeathArrival'
			SV.Chapter6.DefeatedByZeraora = true
			SV.Chapter6.DiedToGloomyBoss = true
			SV.Chapter6.MissionAccepted = false
			GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('gloomy_forest_midpoint'), 0, true, true) --relay (mapID 61)
			GAME:WaitFrames(20)
			GAME:EnterZone("master_zone", -1, GROUND_IDX('gloomy_forest_midpoint'), 0)
		end
		return
	end

	------------------------------------------------------------------
	-- Segment 5 : arene de revanche Zeraora (zone "Serment Verdoyant").
	-- Accessible uniquement via le stand de Grodoudou, apres achat de la
	-- zone, et seulement si l'histoire a deja fait vaincre Zeraora
	-- (SV.Chapter6.DefeatedGloomyBoss). Ce n'est pas une rencontre
	-- aleatoire : c'est un retour volontaire sur les lieux.
	-- Ici le Zeraora n'est PAS Unrecruitable : le vaincre peut donc le
	-- faire rejoindre l'equipe selon les regles de recrutement normales.
	------------------------------------------------------------------
	------------------------------------------------------------------
	-- Segment 7 : le duel de la Team Dazzling (« L'Epreuve des Trois »).
	-- Combat SANS ENJEU : ni Coeur, ni fragment, ni progression de
	-- chapitre. Victoire comme defaite, on ressort au relais (carte 61)
	-- et la journee n'avance pas — c'est un match, pas une expedition.
	-- Les trois rivales sont Unrecruitable : ce sont des personnages
	-- d'histoire, elles ne rejoignent pas l'equipe.
	------------------------------------------------------------------
	if segmentID == 7 then
		------------------------------------------------------------------
		-- DEUX USAGES DU MEME SEGMENT, DISTINGUES PAR SV.Chapter6.PlazaMet
		--
		-- (a) LA CONFRONTATION DE LA PLACE (chapitre 6, premiere
		--     rencontre). Pose par DazzlingPlaza.ActeII juste avant le
		--     combat. La carte chargee est metano_town_duel.rsmap, qui
		--     EST la place de Metano. On ressort donc EN VILLE (carte 1)
		--     si l'on gagne, ou A LA GUILDE (carte 2) si l'on perd :
		--     les habitants ont porte le duo jusqu'a sa chambre.
		--
		-- (b) L'EPREUVE DES TROIS (duel amical de la Foret Lugubre),
		--     comportement d'origine, inchange : retour au relais 61.
		------------------------------------------------------------------
		if SV.Chapter6.PlazaMet and SV.Chapter6.PlazaOutcome == nil then
			if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
				--VICTOIRE : la scene se joue sur la place, donc apres le
				--retour en ville (carte 1). PlazaOutcome y sera pose.
				SV.Chapter6.PlazaPending = 'win'
				GAME:WaitFrames(20)
				GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
			else
				--DEFAITE : le passage en force et l'evanouissement se
				--jouent sur la place ; le chevet se joue a la guilde.
				--On repasse donc par la ville, qui enchainera sur la
				--chambre (carte 2) a la fin de DazzlingPlaza.Defaite().
				SV.Chapter6.PlazaPending = 'loss'
				GAME:WaitFrames(20)
				GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
			end
			return
		end

		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
			SV.Chapter6.DazzlingTrialCleared = true
			DazzlingArc.TrialVictory()
		else
			DazzlingArc.TrialDefeat()
		end
		--Le duel ne se represente pas : gagne ou perdu, il a eu lieu.
		SV.Chapter6.DazzlingTrialOffered = false
		GAME:WaitFrames(20)
		GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('gloomy_forest_midpoint'), 0, false, false)
		return
	end

	if segmentID == 5 then
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
			LegendZones.SetDefeated('verdant_oath')
		end
		-- Victoire comme defaite, on ressort en ville : aucune progression
		-- d'histoire n'est en jeu, et la journee n'avance pas.
		GAME:WaitFrames(20)
		GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
		return
	end

	-- Defaite ou fuite au segment 0 : l'equipe rentre a la guilde pour la fin de
	-- journee (diner -> nuit -> lendemain), comme dans les 7 autres donjons de
	-- l'histoire. Auparavant on ressortait carte 1 (Metano Town) en plein jour,
	-- sans diner ni nuit, et DaysPassed n'avancait pas.
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		GAME:WaitFrames(20)
	end
	SV.Chapter6.MissionAccepted = false
	EndDayReturn(result)
end

return gloomy_forest
