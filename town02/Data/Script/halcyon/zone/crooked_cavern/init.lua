require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.TownNight'

local crooked_cavern = {}

--------------------------------------------------------------------
-- INDEX DES GROUNDS DE master_zone — resolus PAR NOM
--
-- CORRECTIF (audit 2026-08-04). Ce fichier ciblait des index ECRITS EN
-- DUR qui ne designaient plus les cartes voulues : master_zone a grossi
-- depuis, et tout ce qui suivait un ajout s'est decale.
--   60 -> searing_tunnel_miniboss  (attendu : crooked_cavern_midpoint)
--   Le commentaire du code annoncait deja « crooked_cavern_midpoint ».
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
    PrintInfo("[crooked_cavern] ground introuvable dans master_zone : " .. tostring(name)
              .. " — repli sur " .. tostring(MASTER_FALLBACK))
    return MASTER_FALLBACK
  end
  return idx
end

--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function crooked_cavern.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_crooked_cavern")

	--GAME:RemovePlayerGuest(0)
	--GAME:RemovePlayerGuest(0)
	--local guestCount = GAME:GetPlayerGuestCount()
	--for i = 1, guestCount, 1 do
	--	local g = GAME:RemovePlayerGuest(i-1)
	--end
  --Mark this as the last dungeon entered.
  SV.TemporaryFlags.LastDungeonEntered = 'crooked_cavern'

end

function crooked_cavern.EnterSegment(zone, rescuing, segmentID, mapID)
  -- Rescues are only allowed in the first half (segment 0); disallowed in the
  -- second half (segment 1, "Profondeurs") and the boss fight (segment 2).
  -- Mirrors searing_tunnel's rescue policy.
  if segmentID == 0 then
  	GeneralFunctions.CheckAllowSetRescue(zone.ID)
  else
	  GAME:SetRescueAllowed(false)
  end

	if rescuing ~= true then
		COMMON.BeginDungeon(zone.ID, segmentID, mapID)
	end
end

function crooked_cavern.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end


------------------------------------------------------------------
-- ExitSegment
------------------------------------------------------------------
-- Crooked Cavern now has THREE segments (was two):
--   segment 0 = "Caverne Tortueuse"          (procedural, first half)
--   segment 1 = "Profondeurs"                 (procedural, harder second half — NEW)
--   segment 2 = boss arena (chapter_3_boss_fight via LoadGen; previously segment 1)
--
-- A mid-dungeon relay ground map "crooked_cavern_midpoint" (master_zone mapID 60)
-- sits between segment 0 and segment 1, with a Kangaskhan Rock (save + storage).
-- Dying in segment 1 or 2 respawns the player at the relay instead of the entrance.
--
-- This is a faithful mirror of zone/searing_tunnel/init.lua.
-- See audit_checkpoint_crooked_cavern.md for the full design + test checklist.
--
-- IMPORTANT (chapter-3 story gate): the boss run happens while
-- SV.Chapter3.FinishedRootScene == false. Once the root scene is done,
-- FinishedRootScene == true and the dungeon is "complete" (replays get a generic
-- ending). The checkpoint is therefore wired into the FinishedRootScene==false path.
------------------------------------------------------------------
function crooked_cavern.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

	if segmentID == 0 then -- Caverne Tortueuse (first half) exit segment
	  PrintInfo("=>> ExitSegment_crooked_cavern (first half) result "..tostring(result).." segment "..tostring(segmentID))

		local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)

		if exited == true then
			--do nothing (rescue mission handled)

		--Died or Escaped in the first half: send back to town (UNCHANGED from original).
		elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
			GAME:WaitFrames(20)

			--CHOIX DE FIN DE JOURNEE, variante a epilogue : la sauvegarde reste
			--l'avant-dernier acte et les repliques de defaite s'affichent APRES
			--l'ecran de resultats, comme dans le code d'origine.
			TownNight.EndDayWithEpilogue(result, function()
				if not SV.Chapter3.DefeatedBoss and result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then --team died before making it to the end for the first time.
					UI:SetSpeaker(GAME:GetPlayerPartyMember(1))--set partner as speaker
					GeneralFunctions.SetEmotion("Pain")
					UI:WaitShowDialogue("Urf...[pause=0]C'est plus difficile que prévu...")
					GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Nous ne pouvons pas continuer comme ça...[pause=0] Arrêtons-nous pour aujourd'hui.", "Pain")
					SV.Chapter3.FailedCavern = true--mark that they died before the end so Team Style can taunt them for this.
					GAME:WaitFrames(20)
				end
			end)

		--Cleared the first half.
		else
			if SV.Chapter3.FinishedRootScene then
				--Post-game replay: crooked_den shows a generic "nothing here" ending (UNCHANGED).
				SV.TemporaryFlags.Dinnertime = true
				SV.TemporaryFlags.Bedtime = true
				SV.TemporaryFlags.MorningWakeup = true
				SV.TemporaryFlags.MorningAddress = true
				GAME:EnterGroundMap('crooked_den', 'Main_Entrance_Marker')

			else
				-- *** CHECKPOINT (NEW) ***
				-- Boss run (FinishedRootScene == false): instead of going straight to
				-- crooked_den (the pre-boss scene), stop at the relay first. The relay's
				-- North exit then starts segment 1 (Profondeurs); clearing that reaches
				-- crooked_den's FirstPreBossScene (handled in segment 1 below).
				-- (Original line was: GAME:EnterZone("master_zone", -1, GROUND_IDX('crooked_den'), 0).)
				SV.Chapter3.CrookedMidpointState = 'FirstArrival'
				GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('crooked_cavern_midpoint'), 0, false, false) --crooked_cavern_midpoint (mapID 60)
			end
		end

	elseif segmentID == 1 then -- Profondeurs (second half, NEW) exit segment
	  PrintInfo("=>> ExitSegment_crooked_cavern (Profondeurs) result "..tostring(result).." segment "..tostring(segmentID))

		local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)

		if exited == true then
			--do nothing (rescue mission handled)

		--Escaped: leave the dungeon to the entrance, NOT the relay.
		--(Mirrors searing_tunnel: escape does not benefit from the checkpoint.)
		elseif result == RogueEssence.Data.GameProgress.ResultType.Escaped then
			GAME:WaitFrames(20)
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('crooked_cavern_entrance'), 0, true, true)

		--Died in the second half: respawn at the checkpoint.
		elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
			SV.CrookedCavern.DiedPastCheckpoint = true
			SV.Chapter3.CrookedMidpointState = 'DeathArrival'
			GAME:WaitFrames(20)
			GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('crooked_cavern_midpoint'), 0, true, true) --relay (mapID 60); this saves + applies standard loss penalties
			UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
			GeneralFunctions.SetEmotion("Pain")
			GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Urf...[pause=0] pas cette fois...", "Pain")
			GAME:WaitFrames(20)
			GAME:EnterZone("master_zone", -1, GROUND_IDX('crooked_cavern_midpoint'), 0) --travel to the relay

		--Cleared the second half: proceed to crooked_den pre-boss scene (UNCHANGED target;
		--this path was previously reached directly from segment 0).
		else
			GAME:EnterZone("master_zone", -1, GROUND_IDX('crooked_den'), 0) --crooked_den (mapID 42) -> FirstPreBossScene -> boss (segment 2)
		end

	else -- segment 2: boss arena (previously segment 1) exit segment
	  PrintInfo("=>> ExitSegment_crooked_den (boss) result "..tostring(result).." segment "..tostring(segmentID))

		if result == RogueEssence.Data.GameProgress.ResultType.Escaped then --should go unused due to the mysterious force
			SV.Chapter3.EscapedBoss = true
		elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
			SV.Chapter3.LostToBoss = true
		else
			SV.Chapter3.DefeatedBoss = true
		end

		if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
			-- *** CHECKPOINT (NEW) ***
			-- Died/escaped to the boss: respawn at the relay instead of crooked_den.
			-- (Original always did: GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('crooked_den'), 0, false, false).)
			-- The relay's WipedCutscene uses SV.Chapter3.LostToBoss to show boss-specific lines
			-- (crooked_den's DiedToBoss scene is thereby superseded but left in place).
			SV.CrookedCavern.DiedPastCheckpoint = true
			SV.Chapter3.CrookedMidpointState = 'DeathArrival'
			GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('crooked_cavern_midpoint'), 0, true, true) --relay (mapID 60)
			GAME:WaitFrames(20)
			GAME:EnterZone("master_zone", -1, GROUND_IDX('crooked_cavern_midpoint'), 0)
		else
			--Beat the boss: continue to crooked_den for the post-boss/root scene (UNCHANGED).
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('crooked_den'), 0, false, false) --crooked_den (mapID 42)
		end
	end
end


return crooked_cavern
