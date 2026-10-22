require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_second_floor_ch_3 = {}



function guild_second_floor_ch_3.SetupGround()

	if not SV.Chapter3.DefeatedBoss then


		local mareep, cranidos, silcoon, metapod =
			CharacterEssentials.MakeCharactersFromList({
				{'Mareep', 360, 224, Direction.UpRight},
				{'Cranidos', 424, 224, Direction.UpLeft},
				{'Silcoon', 'Left_Duo_2'},
				{'Metapod', 'Left_Duo_1'}
			})
	else
		local spheal, jigglypuff, marill, doduo, bagon, audino =
			CharacterEssentials.MakeCharactersFromList({
				{'Spheal', 'Left_Trio_1'},
				{'Jigglypuff', 'Left_Trio_2'},
				{'Marill', 'Left_Trio_3'},
				{'Doduo', 'Right_Duo_1'},
				{'Bagon', 'Right_Duo_2'},
				{'Audino', 'Generic_Spawn_1'}
			})

		AI:SetCharacterAI(jigglypuff, "halcyon.ai.ground_talking", true, 240, 60, 130, false, 'Default', {marill, spheal})
		AI:SetCharacterAI(marill, "halcyon.ai.ground_talking", true, 240, 60, 0, false, 'Default', {jigglypuff, spheal})
		AI:SetCharacterAI(spheal, "halcyon.ai.ground_talking", true, 240, 60, 50, false, 'Default', {jigglypuff, marill})

		AI:SetCharacterAI(bagon, "halcyon.ai.ground_talking", true, 240, 60, 80, false, 'Default', {doduo})
		AI:SetCharacterAI(doduo, "halcyon.ai.ground_talking", true, 240, 60, 0, false, 'Default', {bagon})

		AI:SetCharacterAI(audino, "origin.ai.ground_default", RogueElements.Loc(176, 264), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)


	end


	GAME:FadeIn(20)

end

function guild_second_floor_ch_3.Spheal_Action(chara, activator)
	local item = RogueEssence.Dungeon.InvItem('gummi_blue')
	GeneralFunctions.StartConversation(chara, "Faisons ce travail ![pause=0]La récompense est un " .. item:GetDisplayName() .. " ![pause=0]Ils sont trop délicieux pour les laisser passer !", "Normal", false)
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Jigglypuff_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Certains travaux sont plus difficiles que d'autres.[pause=0]La difficulté d'un travail dépend du lieu et du type de mission.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_001']))
	--too long with no nicknames
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_002']))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Marill_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Notre équipe n'aime pas faire des missions hors-la-loi.[pause=0]Ils font trop peur !", "Worried")
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_003']))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Doduo_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Nous avons entendu dire que certains hors-la-loi utiliseraient d'autres Pokémon pour se défendre contre les équipes d'aventuriers.", "Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_004']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_005']))
	GeneralFunctions.EndConversation(chara)

end

function guild_second_floor_ch_3.Bagon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Certains hors-la-loi courent quand ils voient une équipe d'aventuriers.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_007'], CharacterEssentials.GetCharacterName("Doduo")))
	GeneralFunctions.EndConversation(chara)

end

function guild_second_floor_ch_3.Audino_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "De nouveaux emplois arrivent chaque jour sur les forums ![pause=0]Je le saurais,[pause=10]car c'est mon travail de garder les tableaux à jour !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_010'], STRINGS:LocalKeyString(9)))
	--too long with no nicknames
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_011']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_012']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_013']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_014']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_015']))
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_3.Silcoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Metapod") .. " et moi formons l'équipe[color=#FFA5FF]Flutter[color]!")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_016']))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Metapod_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Moi et " .. CharacterEssentials.GetCharacterName("Silcoon") .. " avons évolué récemment.")
	--too long with no nicknames
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_017']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_018']))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Mareep_Action(chara, activator)
	if SV.Chapter3.EnteredCavern then
		GeneralFunctions.StartConversation(chara, "Salut vous deux ![pause=0]J'ai du mal à attraper le\nba-a-a-addie ?")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_019']))
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_020']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_021']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_022']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_023']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_024']))
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_025']))
	else
		GeneralFunctions.StartConversation(chara, "Bonne chance à vous deux ![pause=0]Revenez nous parler si vous avez des problèmes !")
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Cranidos_Action(chara, activator)
	local hero = CH("PLAYER")
	local partner = CH('Teammate1')
	if SV.Chapter3.EnteredCavern then
		GeneralFunctions.StartConversation(chara, "Vous n'avez toujours pas attrapé ce hors-la-loi ?")
		GeneralFunctions.SetEmotion("Joyous")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_026']))

		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_027']))

		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_028'], chara:GetDisplayName(), CharacterEssentials.GetCharacterName("Mareep")))
		GROUND:CharSetEmote(chara, "", 0)
		GROUND:CharAnimateTurnTo(chara, Direction.UpLeft, 4)
	else
		GeneralFunctions.StartConversation(chara, "N'avez-vous pas un hors-la-loi à attraper ?[pause=0]Que faites-vous ici en train de me parler ?", "Determined")
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.OutlawRewardScene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")

	GAME:MoveCamera(400, 240, 1, false)

	local sandile, pawniard_boy, pawniard_girl, bisharp, noctowl =
		CharacterEssentials.MakeCharactersFromList({
			{'Sandile', 392, 224, Direction.Down},
			{'Pawniard_Boy', 368, 224, Direction.Down},
			{'Pawniard_Girl', 416, 224, Direction.Down},
			{'Bisharp', 392, 248, Direction.Down},
		--	{'Cranidos', 576, 100, Direction.Down},
		--	{'Mareep', 576, 100, Direction.Down},
			{'Noctowl', 448, 264, Direction.UpLeft}
		})

	--change his form from scarved to regular
	sandile.Data.BaseForm = RogueEssence.Dungeon.MonsterID("sandile", 0, "normal", Gender.Male)

	GROUND:Hide('Downwards_Stairs_Exit')

	GROUND:TeleportTo(partner, 376, 272, Direction.Up)
	GROUND:TeleportTo(hero, 408, 272, Direction.Up)
	SOUND:StopBGM()


	GAME:FadeIn(40)
	SOUND:PlayBGM("Job Clear!.ogg", true)

	GAME:WaitFrames(20)
	UI:SetSpeaker(bisharp)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_029'], bisharp:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_030']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_031']))

	--pose!
	GROUND:CharSetEmote(pawniard_boy, "happy", 0)
	GROUND:CharSetEmote(pawniard_girl, "happy", 0)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharSetAction(bisharp, RogueEssence.Ground.PoseGroundAction(bisharp.Position, bisharp.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharSetAction(pawniard_boy, RogueEssence.Ground.PoseGroundAction(pawniard_boy.Position, pawniard_boy.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:CharSetAction(pawniard_girl, RogueEssence.Ground.PoseGroundAction(pawniard_girl.Position, pawniard_girl.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) SOUND:PlayBattleSE('DUN_Fury_Cutter') end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(60)

	--UI:SetSpeaker(partner)
	--GeneralFunctions.SetEmotion("Sad")
	--UI:WaitShowDialogue(".........")
	--GAME:WaitFrames(20)

	GROUND:CharEndAnim(bisharp)
	GROUND:CharEndAnim(pawniard_boy)
	GROUND:CharEndAnim(pawniard_girl)
	GROUND:CharSetEmote(pawniard_boy, "", 0)
	GROUND:CharSetEmote(pawniard_girl, "", 0)
	GAME:WaitFrames(20)

	UI:SetSpeaker(bisharp)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_032']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_033']))

	GAME:WaitFrames(4)
	GROUND:CharTurnToCharAnimated(bisharp, sandile, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_034']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_035']))

	GAME:WaitFrames(30)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(bisharp, Direction.Left, 4)
											GROUND:MoveInDirection(bisharp, Direction.Left, 56, false, 1)
											GeneralFunctions.EmoteAndPause(bisharp, "Exclaim", true) end)

	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(pawniard_boy, Direction.Left, 4)
											GROUND:MoveInDirection(pawniard_boy, Direction.Left, 56, false, 1)
											GeneralFunctions.EmoteAndPause(pawniard_boy, "Exclaim", false) end)

	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(pawniard_girl, Direction.Left, 4)
											GROUND:MoveInDirection(pawniard_girl, Direction.Left, 56, false, 1)
											GeneralFunctions.EmoteAndPause(pawniard_girl, "Exclaim", false) end)

	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(sandile, Direction.Left, 4)
											GROUND:MoveInDirection(sandile, Direction.Left, 56, false, 1)
											GeneralFunctions.EmoteAndPause(sandile, "Shock", false) end)

	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.FaceMovingCharacter(partner, bisharp, 4, Direction.UpLeft)
											      SOUND:FadeOutBGM(120)
												  UI:WaitShowTimedDialogue("Wait!", 60) end)

	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.FaceMovingCharacter(hero, bisharp, 4, Direction.UpLeft)
												  GAME:WaitFrames(50)
												  GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(70) GeneralFunctions.EmoteAndPause(noctowl, "Notice", false) end)
	--local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GeneralFunctions.EmoteAndPause(mareep, "Exclaim", false) end)
	--local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(66) GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", false) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(bisharp, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(pawniard_boy, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(pawniard_girl, Direction.DownRight, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharTurnToCharAnimated(sandile, partner, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharTurnToCharAnimated(noctowl, partner, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
	UI:SetSpeaker(bisharp)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_036']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_037'], sandile:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_038']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_039']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_040']))

	GAME:WaitFrames(40)
	GROUND:EntTurn(hero, Direction.UpLeft)
	GROUND:EntTurn(noctowl, Direction.UpLeft)
	UI:SetSpeaker(bisharp)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_041']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_042']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_043']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_044']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_045']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_046']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_047']))

	GAME:WaitFrames(30)
	GROUND:CharAnimateTurnTo(bisharp, Direction.Left, 4)
	UI:SetSpeaker(bisharp)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_048']))
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(sandile, Direction.Left, 4)
											GROUND:MoveToPosition(sandile, 288, 224, false, 1)
											GROUND:MoveToPosition(sandile, 272, 208, false, 1)
											GROUND:MoveToPosition(sandile, 272, 184, false, 1)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(sandile, Direction.DownRight, 4)
											GAME:WaitFrames(20)
											--Sandile gets nudged by Pawniard
											--Not sure what this sfx is from exactly, but it's similar to the drowzee shove one (if it isn't the drowzee shove already) (which is _UNK_EVT_018)
											SOUND:PlayBattleSE('_UNK_EVT_015')
											GROUND:CharSetEmote(sandile, "shock", 1)
											GROUND:AnimateInDirection(sandile, "None", Direction.DownRight, Direction.Up, 4, 1, 1)
											GROUND:AnimateInDirection(sandile, "None", Direction.DownRight, Direction.Down, 4, 1, 1)
											GAME:WaitFrames(22)
											GROUND:CharAnimateTurnTo(sandile, Direction.Up, 4)
											GROUND:MoveToPosition(sandile, 272, 168, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(sandile)	end)
	coro2 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(pawniard_boy, Direction.Left, 4)
											GROUND:MoveToPosition(pawniard_boy, 288, 224, false, 1)
											GROUND:MoveToPosition(pawniard_boy, 272, 208, false, 1)
											GROUND:MoveToPosition(pawniard_boy, 272, 168, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(pawniard_boy) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(pawniard_girl, Direction.Left, 4)
											GROUND:MoveToPosition(pawniard_girl, 288, 224, false, 1)
											GROUND:MoveToPosition(pawniard_girl, 272, 208, false, 1)
											GROUND:CharAnimateTurnTo(pawniard_girl, Direction.Up, 4)
											GAME:WaitFrames(28)
											GROUND:MoveToPosition(pawniard_girl, 272, 200, false, 1)
											GAME:WaitFrames(60)
											GROUND:MoveToPosition(pawniard_girl, 272, 168, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(pawniard_girl) end)

	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:MoveToPosition(bisharp, 280, 248, false, 1)
											GROUND:MoveToPosition(bisharp, 272, 240, false, 1)
											GROUND:CharAnimateTurnTo(bisharp, Direction.Up, 4)
											GAME:WaitFrames(130)
											GROUND:MoveToPosition(bisharp, 272, 168, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(bisharp) end)


	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4)
											UI:WaitShowTimedDialogue("Oh...[pause=30] Poor " .. CharacterEssentials.GetCharacterName("Sandile") .. "...", 60) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(noctowl, 392, 240, false, 1)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	--im surprised to see you stick up for an outlaw... that's unusual. But it does seem to me as though he was an unusual outlaw.
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_120']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_049']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_050']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_051'], CharacterEssentials.GetCharacterName("Bisharp"))) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(10)
	GeneralFunctions.RewardItem(500, true)

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_052'], CharacterEssentials.GetCharacterName("Snubbull")))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_053']))

	GAME:WaitFrames(60)
	GAME:FadeOut(false, 60)
	SV.TemporaryFlags.Dinnertime = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_dining_room", "Main_Entrance_Marker")

end


function guild_second_floor_ch_3.OutlawTutorialScene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")

	GAME:MoveCamera(400, 176, 1, false)

	local cranidos, mareep =
		CharacterEssentials.MakeCharactersFromList({
			{'Cranidos', 576, 100, Direction.Down},
			{'Mareep', 576, 100, Direction.Down},
			{'Silcoon', 'Left_Duo_2'},
			{'Metapod', 'Left_Duo_1'}
	})
	GROUND:Hide('Upwards_Stairs_Exit')

	GROUND:TeleportTo(partner, 576, 100, Direction.Down)
	GROUND:TeleportTo(hero, 576, 100, Direction.Down)
	SOUND:StopBGM()
	GROUND:Hide(hero.EntName)
	GROUND:Hide("Teammate1")
	GROUND:Hide("Mareep")
	GROUND:Hide("Cranidos")

	GAME:FadeIn(40)
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)

	GAME:WaitFrames(20)

	local coro1 = TASK:BranchCoroutine(function() GROUND:Unhide("Mareep")
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(mareep, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(mareep, 492, 184, false, 1)
												  GeneralFunctions.EightWayMove(mareep, 360, 224, false, 1)
												  GeneralFunctions.FaceMovingCharacter(mareep, partner, 4, Direction.Down)
												  GROUND:CharAnimateTurnTo(mareep, Direction.DownRight, 4) end)
    local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(52)
												  GROUND:Unhide("Teammate1")
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(partner, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(partner, 492, 184, false, 1)
												  GeneralFunctions.EightWayMove(partner, 376, 256, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
    local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(104)
												  GROUND:Unhide(hero.EntName)
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(hero, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(hero, 492, 184, false, 1)
												  GeneralFunctions.EightWayMove(hero, 408, 256, false, 1)
												  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
    local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(156)
												  GROUND:Unhide("Cranidos")
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(cranidos, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(cranidos, 492, 184, false, 1)
												  GeneralFunctions.EightWayMove(cranidos, 424, 224, false, 1)
												  GROUND:CharAnimateTurnTo(cranidos, Direction.DownLeft, 4) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(260)
												  GAME:MoveCamera(400, 224, 48, false) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_054']))

	GAME:WaitFrames(12)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_055'], CharacterEssentials.GetCharacterName("Noctowl")))

	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_056'], CharacterEssentials.GetCharacterName("Noctowl")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_057']))

	GAME:WaitFrames(12)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:EntTurn(hero, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_058']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_059']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_060']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_061']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Stunned")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_062']))

	GAME:WaitFrames(12)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.DownRight, 4)
											GeneralFunctions.DuoTurnTowardsChar(mareep) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(cranidos, mareep, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_063']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_064']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_065']))
	--GAME:WaitFrames(10)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_066']))

	GAME:WaitFrames(16)
	GROUND:CharAnimateTurnTo(cranidos, Direction.DownLeft, 4)
	UI:SetSpeaker(cranidos)
	GeneralFunctions.SetEmotion("Determined")
	--GROUND:CharSetEmote(cranidos, "happy", 0)

	--this is the extent of ganlon's "outbursts" because he's very clearly in shuca's attention
	coro1 = TASK:BranchCoroutine(function() --GeneralFunctions.Hop(cranidos)
								-- GeneralFunctions.Hop(cranidos)
								 UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_067']))
								 --GROUND:CharSetEmote(cranidos, "", 0)
								 end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
								 GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
								 GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
								 GROUND:CharAnimateTurnTo(mareep, Direction.Right, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(16)
	GROUND:CharAnimateTurnTo(mareep, Direction.DownRight)
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_068']))

	GAME:WaitFrames(12)
	GeneralFunctions.DuoTurnTowardsChar(mareep)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_069']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_070']))
	--todo: perhaps add shuca going bang! zoom! pow! and acting out the scene of her beating up an outlaw
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_071'], CharacterEssentials.GetCharacterName("Bisharp")))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_072'], CharacterEssentials.GetCharacterName("Bisharp")))

	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_073'], CharacterEssentials.GetCharacterName("Bisharp")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_074']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_075']))

	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_076']))

	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
	GROUND:CharTurnToCharAnimated(cranidos, mareep, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_077'], cranidos:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(cranidos)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_078'], mareep:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
	GeneralFunctions.DuoTurnTowardsChar(cranidos)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(cranidos, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_079']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_080']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_081'], cranidos:GetDisplayName()))

	GAME:WaitFrames(20)

	GROUND:CharSetEmote(cranidos, "", 0)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4)
								 GROUND:CharSetAnim(cranidos, "Idle", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
								 GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
								 GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
								 GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(10)

	UI:SetSpeaker(cranidos)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_082']))

	GAME:WaitFrames(80)
	GROUND:CharEndAnim(cranidos)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_083']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
	GROUND:CharTurnToCharAnimated(mareep, partner, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_084']))
	GAME:WaitFrames(20)

	SOUND:PlayBattleSE("_UNK_EVT_028") -- paper crumpling
	GAME:FadeOut(false, 20)
	UI:WaitShowBG("Wanted_Poster", 180, 20)
	GAME:WaitFrames(180)
	SOUND:PlayBattleSE("_UNK_EVT_028") -- paper crumpling
	UI:WaitHideBG(20)
	GAME:FadeIn(20)

	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_085'], _DATA:GetMonster("sandile"):GetColoredName(), CharacterEssentials.GetCharacterName("Sandile")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_086'], zone:GetColoredName()))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(mareep, "Exclaim", true)
	GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
	UI:SetSpeaker(mareep)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_087'], zone:GetColoredName()))

	GAME:WaitFrames(16)
	GROUND:CharAnimateTurnTo(mareep, Direction.DownRight, 4)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	GROUND:CharSetAnim(mareep, "Idle", true)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_088'], cranidos:GetDisplayName()))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_089'], zone:GetColoredName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	GROUND:CharEndAnim(mareep)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_090']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_091']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_092']))

	GAME:WaitFrames(10)

	SOUND:StopBGM()
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Shock", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)

	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_093']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_094']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_095'], cranidos:GetDisplayName()))

	GAME:WaitFrames(10)
	GeneralFunctions.DuoTurnTowardsChar(cranidos)
	GAME:WaitFrames(10)

	UI:SetSpeaker(cranidos)
	GROUND:CharSetEmote(cranidos, "glowing", 0)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_096']))

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(30)
	GROUND:CharSetEmote(cranidos, "", 0)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_097']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_098']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_099'], cranidos:GetDisplayName()))

	GAME:WaitFrames(10)
	GeneralFunctions.DuoTurnTowardsChar(cranidos)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_100']))


	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", true)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("EVT_Emote_Sweating")
	GROUND:CharSetEmote(cranidos, "sweating", 1)
	GROUND:CharAnimateTurnTo(cranidos, Direction.DownRight, 2)
	GAME:WaitFrames(20)
	UI:SetSpeaker(cranidos)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_101']))

	GAME:WaitFrames(30)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	UI:SetSpeaker(mareep)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_102']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_103']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_104']))

	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_105'], hero:GetDisplayName()))

	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(10)

	UI:SetSpeaker(mareep)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetAnim(mareep, "Idle", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_106']))

	GAME:WaitFrames(20)
	GROUND:CharEndAnim(mareep)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	GROUND:CharSetEmote(mareep, "", 0)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_107']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_108']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_109']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_110']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_111']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_112'], CharacterEssentials.GetCharacterName('Sandile')))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_113']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_114'], mareep:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_115'], cranidos:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_116']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_117']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_118']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F3_119'], hero:GetDisplayName()))

	GAME:WaitFrames(20)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	partner.CollisionDisabled = true--redisable partner's collision. Something is causing this to be set to false earlier in the script...
	GeneralFunctions.PanCamera()
	GROUND:Unhide('Upwards_Stairs_Exit')
	SV.Chapter3.FinishedOutlawIntro = true
	GAME:CutsceneMode(false)


	--i wasn't scared i was merely cold! they were a snorunt!!
end
