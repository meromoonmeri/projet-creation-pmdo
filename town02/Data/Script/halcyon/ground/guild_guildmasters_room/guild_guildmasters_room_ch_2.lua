require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_guildmasters_room_ch_2 = {}


function guild_guildmasters_room_ch_2.Tropius_Action(chara, activator)
	if not SV.Chapter2.FinishedTraining then
		GeneralFunctions.StartConversation(chara, "Salut, équipe[pause=10]" .. GAME:GetTeamName() .. "![pause=0]Bonne chance à l'entraînement avec Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " aujourd'hui !")
	else
		--He gives you a reviver seed as a one-off to help you with your mission
		if not SV.Chapter2.TropiusGaveReviver then
			GeneralFunctions.StartConversation(chara, "Salut, équipe[pause=10]" .. GAME:GetTeamName() .. "![pause=0]J'ai entendu dire que vous aviez déjà obtenu votre première mission !")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_001']))
			GAME:WaitFrames(20)
			GeneralFunctions.RewardItem("seed_reviver")
			GAME:WaitFrames(20)
			UI:SetSpeaker(CH('Teammate1'))
			GeneralFunctions.SetEmotion("Inspired")
			GROUND:CharSetEmote(CH('Teammate1'), "happy", 0)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_002']))
			GAME:WaitFrames(20)
			GROUND:CharSetEmote(CH('Teammate1'), "", 0)
			UI:SetSpeaker(chara)
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_003']))
			SV.Chapter2.TropiusGaveReviver = true
		elseif not SV.Chapter2.EnteredRiver then
			GeneralFunctions.StartConversation(chara, "Bonne chance dans votre travail ![pause=0]Je sais que vous pouvez le faire !", "Happy")
		else--failed the dungeon at least once
			GeneralFunctions.StartConversation(chara, "Vous rencontrez des difficultés avec votre mission ?[pause=0]Le travail peut parfois être difficile !")
			GeneralFunctions.SetEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_004']))
		end
	end
	GeneralFunctions.EndConversation(chara)
end


--TASK:BranchCoroutine(guild_guildmasters_room_ch_2.MeetGuildmaster)
function guild_guildmasters_room_ch_2.NoctowlTropiusScene()
	local tropius = CH('Tropius')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:TeleportTo(tropius, 296, 208, Direction.Right)
	local noctowl, numel =
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 184, 360, Direction.Up},
			{"Numel"}
		})
	SOUND:StopBGM()
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--keep them offscreen for the entire cutscene
	GROUND:TeleportTo(hero, 400, 400, Direction.Up)
	GROUND:TeleportTo(partner, 400, 400, Direction.Up)

	GAME:MoveCamera(304, 216, 1, false)

	--window + nighttime darkness
	local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Night_Window", 1, 0, 0),
													   RogueElements.Rect(160, 24, 64, 64),
													   RogueElements.Loc(0, 0),
													   false,
													   "Window_Cutscene")
	groundObj:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(groundObj)
	GROUND:AddMapStatus("darkness")

	GAME:WaitFrames(100)
	GAME:FadeIn(40)

	GROUND:MoveToPosition(noctowl, 184, 272, false, 1)

	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(noctowl, 1, 4, false, false, true, Direction.UpRight)
	GeneralFunctions.EmoteAndPause(noctowl, "Notice", true)

	GROUND:MoveToPosition(noctowl, 248, 208, false, 1)
	GROUND:MoveToPosition(noctowl, 256, 208, false, 1)
	GAME:WaitFrames(10)

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_005']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(tropius, "Notice", true)
	GAME:WaitFrames(10)

	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_006'], noctowl:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_007']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_009']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_010'], hero:GetDisplayName(), partner:GetDisplayName()))
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(tropius, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_011']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_012']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(tropius, "", 0)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_013']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(tropius, "Question", true)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_014']))

	local numel_species = _DATA:GetMonster(numel.CurrentForm.Species):GetColoredName()
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_015'], GAME:GetTeamName(), numel_species))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_016']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Surprised")
	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	GeneralFunctions.EmoteAndPause(tropius, "Shock", false)
	--SOUND:PlayBGM('Growing Anxiety.ogg', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_017']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_018']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_019']))

	GAME:WaitFrames(40)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_020']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_021']))



	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_022']))

	--SOUND:FadeOutBGM(120)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(tropius, Direction.Up, 8)
	GAME:WaitFrames(60)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_024']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_025']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_026']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR2_027']))

	GAME:WaitFrames(20)
	GAME:FadeOut(false, 120)
	GAME:WaitFrames(120)
	GAME:CutsceneMode(false)

	--demo only, let player know end of demo
	--UI:ResetSpeaker()
	--UI:WaitShowDialogue("Thus ends Chapter 2, and thus ends the demo! Thank you for playing!")
	--UI:WaitShowDialogue("I hope you enjoyed it as much as I enjoyed making it.")
	--UI:WaitShowDialogue("Let me know if you found any bugs, what you enjoyed, what you didn't like.")
	--UI:WaitShowDialogue("Your feedback is invaluable to improving New Era : Abyss to Ascension!")
	--UI:WaitShowDialogue("I'll be setting plot flags to Chapter 3 now (none of which is scripted out).")
	--UI:WaitShowDialogue("Things may be unstable in this state as nothing is really properly programmed out for chapter 3.")
	--UI:WaitShowDialogue("But it's better than being stuck in a black screen, right?")
	--UI:WaitShowDialogue("Alright. Returning control... now!")

	--no temporary flags need to be set here.
	SV.ChapterProgression.Chapter = 3
	SV.ChapterProgression.CurrentStoryDungeon = "crooked_cavern" -- Crooked Cavern
	SV.Dojo.NewMazeUnlocked = true
	GAME:UnlockDungeon("grass_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("fire_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("water_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("crooked_cavern")--unlock chapter 3 dungeon
	--Vague 1 multi-sources : secondaires ch3
	GAME:UnlockDungeon("antre_enigme")
	--Vague 2 multi-sources : secondaire ch3
	GAME:UnlockDungeon("bois_ronces")
	GAME:UnlockDungeon("carriere_cuivre")
	GeneralFunctions.EndOfDay()--reset daily flags and increment day counter by 1
	GeneralFunctions.PromptChapterSaveAndQuit("guild_heros_room", "Main_Entrance_Marker", 2)

end

return guild_guildmasters_room_ch_2
