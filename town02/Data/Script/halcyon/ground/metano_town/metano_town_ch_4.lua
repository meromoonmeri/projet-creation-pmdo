require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_town_ch_4 = {}

function metano_town_ch_4.SetupGround()
	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')

	--trigger for audino showing you the signpost/cafe stuff
	if not SV.Chapter4.FinishedSignpostCutscene then
		local signBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
															RogueElements.Rect(1360, 584, 8, 56),
															RogueElements.Loc(0, 0),
															true,
															"Event_Trigger_1")

		signBlock:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(signBlock)
	end

	if not SV.Chapter4.FinishedGrove then
		local spinda, ludicolo, roselia, nidorina, gloom, wooper_girl, wooper_boy,
			  electrike, medicham, camerupt, bellossom, manectric, numel, sentret,
			  mawile, luxray, floatzel, oddish, zigzagoon, quagsire, machamp =
			CharacterEssentials.MakeCharactersFromList({
				{'Spinda', 1204, 1160, Direction.Up},
				{'Ludicolo', 1184, 1128, Direction.DownRight},
				{'Roselia', 1224, 1128, Direction.DownLeft},
				{'Nidorina', 512, 184, Direction.DownRight},
				{'Gloom', 536, 208, Direction.UpLeft},
				{'Wooper_Girl', 184, 896, Direction.Down},
				{'Wooper_Boy', 160, 840, Direction.UpLeft},
				{'Electrike', 232, 872, Direction.Left},
				{'Medicham', 624, 512, Direction.Up},
				{'Camerupt', 'Town_Seat_2'},
				{'Bellossom', 'Town_Seat_1'},
				{'Manectric', 1256, 360, Direction.DownLeft},
				{'Numel', 400, 432, Direction.Right},
				{'Sentret', 432, 432, Direction.Left},
				{'Mawile', 320, 1208, Direction.Left},
				{'Luxray', 320, 1016, Direction.UpRight},
				{'Floatzel', 992, 800, Direction.DownRight},
				{'Oddish', 872, 566, Direction.Up},
				{'Zigzagoon', 200, 688, Direction.UpRight},
				{'Quagsire', 1104, 1040, Direction.Up},
				{'Machamp', 576, 704, Direction.Down}

			})

		AI:SetCharacterAI(manectric, "halcyon.ai.ground_default", RogueElements.Loc(1248, 344), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(mawile, "halcyon.ai.ground_default", RogueElements.Loc(304, 1192), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(luxray, "halcyon.ai.ground_default", RogueElements.Loc(304, 1000), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(zigzagoon, "halcyon.ai.ground_default", RogueElements.Loc(184, 672), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(quagsire, "halcyon.ai.ground_default", RogueElements.Loc(1088, 1024), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	else
		local quagsire, furret, meditite, wooper_boy, wooper_girl, machamp, medicham, manectric, nidoking,
			  linoone, gloom, mawile, electrike, snubbull, sentret, doduo, bagon =
			CharacterEssentials.MakeCharactersFromList({
				{'Quagsire', 1040, 864, Direction.UpRight},
				{'Furret', 356, 764, Direction.Right},
				{'Meditite', 416, 416, Direction.Down},
				{'Wooper_Boy', 440, 448, Direction.UpLeft},
				{'Wooper_Girl', 392, 448, Direction.UpRight},
				{'Machamp', 'Town_Seat_1'},
				{'Medicham', 'Town_Seat_2'},
				{'Manectric', 1256, 336, Direction.UpRight},
				{'Nidoking', 1136, 896, Direction.Left},
				{'Linoone', 'Cafe_Seat_6'},
				{'Gloom', 864, 360, Direction.Left},
				{'Mawile', 1032, 1232, Direction.DownRight},
				{'Electrike', 288, 992, Direction.DownRight},
				{'Snubbull', 632, 1208, Direction.Up},
				{'Sentret', 416, 720, Direction.DownRight},
				{'Doduo', 1188, 1156, Direction.Right},
				{'Bagon', 1230, 1156, Direction.Left}
			})

		AI:SetCharacterAI(manectric, "halcyon.ai.ground_default", RogueElements.Loc(1248, 320), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(nidoking, "halcyon.ai.ground_default", RogueElements.Loc(1136, 896), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(gloom, "halcyon.ai.ground_default", RogueElements.Loc(848, 344), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(mawile, "halcyon.ai.ground_default", RogueElements.Loc(1016, 1216), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(electrike, "halcyon.ai.ground_default", RogueElements.Loc(272, 976), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(snubbull, "halcyon.ai.ground_default", RogueElements.Loc(616, 1192), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

		GROUND:CharSetAnim(furret, 'Sleep', true)

	end

	GAME:FadeIn(20)

end

function metano_town_ch_4.Event_Trigger_1_Touch(obj, activator)
	metano_town_ch_4.SignpostIntroductionCutscene()
end


function metano_town_ch_4.SignpostIntroductionCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local audino, cafe_dummy = CharacterEssentials.MakeCharactersFromList({
		{"Audino", 1152, 608, Direction.Right},
		{"Tail"},--dummy
	})

	GROUND:TeleportTo(cafe_dummy, 1118, 576, Direction.Down)
	--disable this cutscene's event trigger
	GROUND:Hide('Event_Trigger_1')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:SetSpeaker(audino:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)

	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue(partner:GetDisplayName() .. "![pause=30]" .. hero:GetDisplayName() .. "![pause=30]W-attendez !", 60) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(hero, "Notice", true) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EightWayMove(hero, 1336, 592, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EightWayMove(partner, 1336, 624, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(audino, 1304, 608, false, 2) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GAME:MoveCamera(1328, 616, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1328, 616, 1), false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(audino, "sweating", 1)
	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_001']))
	GAME:WaitFrames(40)

	GeneralFunctions.ShakeHead(audino)
	GAME:WaitFrames(10)
	GeneralFunctions.Hop(audino)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_002']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_003'], audino:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_004']))
	--GROUND:EntTurn(audino, Direction.UpRight)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_005']))

	GAME:WaitFrames(10)


	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(36) GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(audino, 1390, 608, false, 1)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GAME:MoveCamera(1352, 616, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1352, 616, 1), false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_006']), {function() return GeneralFunctions.Hop(audino) end})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_007']))
	GAME:WaitFrames(10)

	local post = OBJ("Assembly")
	SOUND:PlayBattleSE('EVT_Assembly_Bell')
	GROUND:ObjectSetAnim(post, 6, 0, 3, Direction.Down, 1)
	GAME:WaitFrames(24)
	GROUND:ObjectSetAnim(post, 10, 0, 3, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(post, 'Assembly', 0, 0, 0, Direction.Down)
	GAME:WaitFrames(60)

	GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_008']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_009']))

	--GAME:WaitFrames(20)
	--coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Right, 4) end)
	--coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	--coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	--TASK:JoinCoroutines({coro1, coro2, coro3})

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_010']))
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GROUND:CharSetEmote(audino, "exclaim", 1)
	GAME:WaitFrames(40)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_011']))
	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({cafe_dummy}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 3) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_012'], CharacterEssentials.GetCharacterName("Shuckle")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_013']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_014']))

	GAME:WaitFrames(20)
	GROUND:EntTurn(hero, Direction.Right)
	GROUND:EntTurn(partner, Direction.Right)
	GROUND:EntTurn(audino, Direction.Left)
	GAME:MoveCamera(1352, 616, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1352, 616, 3), false)

	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_015']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_016']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_017']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_018']))

	GAME:WaitFrames(10)


	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
											GROUND:MoveToPosition(audino, 1248, 608, false, 2)
											GROUND:MoveToPosition(audino, 1152, 704, false, 2)
											GAME:GetCurrentGround():RemoveTempChar(audino) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GeneralFunctions.PanCamera()
	SV.Chapter4.FinishedSignpostCutscene = true
	GAME:CutsceneMode(false)


end


function metano_town_ch_4.Snubbull_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "L'autre soir, au dîner, j'ai entendu parler de l'énorme abricorne que vous avez trouvé lors de votre récente aventure.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_019']))
		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_020']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_021'], STRINGS:Format("\\u266A")))

	end
	GeneralFunctions.EndConversation(chara)
--[[Removed to add more characters talking about their successful apricorn get.
GeneralFunctions.StartConversation(chara, "With the expedition getting closer,[pause=10] I'm wondering more and more what we'll find on it.")
		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_022'], STRINGS:Format("\\u266A")))
]]--
end

function metano_town_ch_4.Zigzagoon_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Cette expédition a l'air absolument incroyable ![pause=0]Je n'y ai jamais participé auparavant !", "Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_023']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_024'], CharacterEssentials.GetCharacterName("Growlithe")))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_025']))
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_4.Roselia_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Tah ![pause=0] Les abricornes permettent de recruter davantage de Pokémon dans ton équipe ! " .. STRINGS:Format("\\u266A"), "Normal", true, false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_026'], STRINGS:Format("\\u266A")))
	else

	end
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_4.Ludicolo_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Yah![pause=0]je vais m'évider des abricornes puis les remplir de cailloux !", "Normal", true, false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_027']))
	else

	end
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_4.Spinda_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Lah ![pause=0]Il me faut trouver des abricornes,[pause=10]ils ont la forme parfaite pour jongler !", "Normal", true, false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_028']))
	else

	end
	GeneralFunctions.EndConversation(chara)

end



function metano_town_ch_4.Linoone_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "Je viens de terminer ce livre détaillant les donjons mystérieux.[pause=0]Ce fut une lecture excellente et informative.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_029']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_030']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_031']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_032']))
	end
	GeneralFunctions.EndConversation(chara)

end


function metano_town_ch_4.Mawile_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Hé,[pause=10] c'est vous deux ![pause=0]Quels sont mes aventuriers préférés en train de faire aujourd'hui ?", "Happy")
		--GAME:WaitFrames(20)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_033']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_034']))
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_035']))
	else
		GeneralFunctions.StartConversation(chara, "Oh,[pause=10]vous voilà tous les deux ![pause=0]Comment s'est passée votre exploration de cette forêt ?", "Happy")
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_036']))
		GeneralFunctions.SetEmotion("Joyous")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_037']))
		GROUND:CharSetEmote(chara, "", 0)
	end
	GeneralFunctions.EndConversation(chara)
--[[
		Repurpose this in chapter 5's dialogue for Mawile.
		GeneralFunctions.StartConversation(chara, "I overheard that the guild is going on an expedition soon![pause=0] That sounds like it'll be a lot of fun for you two!")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_038']))
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_039']))
		GAME:WaitFrames(20)
		GeneralFunctions.SetEmotion("Joyous")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_040']))
		GROUND:CharSetEmote(chara, "", 0)
]]--
end

function metano_town_ch_4.Electrike_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Vous savez que je peux vous voir tous les deux,[pause=10] n'est-ce pas ?", "Normal", false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_041']))
		GAME:WaitFrames(20)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_042']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_043'], CharacterEssentials.GetCharacterName("Wooper_Girl"), CharacterEssentials.GetCharacterName("Wooper_Boy")))
	else
		GeneralFunctions.StartConversation(chara, "Les jumeaux dérangent quelqu'un d'autre pour une fois.[pause=0]Ce pauvre Pokémon...")
		GeneralFunctions.SetEmotion("Joyous")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_044']))
		GROUND:CharSetEmote(chara, "", 0)
	end
	GeneralFunctions.EndConversation(chara)

end



function metano_town_ch_4.Wooper_Boy_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Héhé ![pause=0]Je suis le meilleur à cache-cache !", "Happy", false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_045'], CharacterEssentials.GetCharacterName("Wooper_Girl"), CharacterEssentials.GetCharacterName("Electrike")))
		GeneralFunctions.EndConversation(chara)
	else
		if not SV.Chapter4.WoopersMedititeConvo then
			metano_town_ch_4.Meditite_Woopers_Dialogue(chara)
		else
			GeneralFunctions.StartConversation(chara, "Je vais gagner aux lutteurs de sumo ![pause=0]Personne ne va me repousser !", "Happy", false)
			GeneralFunctions.EndConversation(chara)
		end
	end
end

function metano_town_ch_4.Wooper_Girl_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Cet endroit est encore meilleur que celui de " .. CharacterEssentials.GetCharacterName("Wooper_Boy") .. " ![pause=0]Il n'y a aucune chance que " .. CharacterEssentials.GetCharacterName("Electrike") .. " me voie ici !", "Happy", false)
		GeneralFunctions.EndConversation(chara)
	else
		if not SV.Chapter4.WoopersMedititeConvo then
			metano_town_ch_4.Meditite_Woopers_Dialogue(chara)
		else
			GeneralFunctions.StartConversation(chara, "Nous n'avons jamais joué contre des lutteurs de sumo auparavant ![pause=0]Cela a l'air très amusant !", "Happy", false)
			GeneralFunctions.EndConversation(chara)
		end
	end
end

function metano_town_ch_4.Meditite_Woopers_Dialogue(chara)
	--local electrike = CH('Electrike')
	local meditite = CH('Meditite')
	local wooper_boy = CH('Wooper_Boy')
	local wooper_girl = CH('Wooper_Girl')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(meditite, 'None', true)
	--GROUND:CharSetAnim(electrike, 'None', true)
	GROUND:CharSetAnim(wooper_boy, 'None', true)
	GROUND:CharSetAnim(wooper_girl, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(wooper_boy)
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_046']))
    TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)

	UI:SetSpeaker(wooper_girl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_047'], meditite:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(meditite)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_048']))
	GAME:WaitFrames(40)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_049']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(wooper_boy)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_050']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(wooper_girl)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_051']))
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(meditite, "Shock", true)
	UI:SetSpeaker(meditite)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_052']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(wooper_boy)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_053']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(wooper_girl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_054']))
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(meditite, "Sweating", true)
	UI:SetSpeaker(meditite)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_055']))

	--GROUND:CharEndAnim(electrike)
	SV.Chapter4.WoopersMedititeConvo = true
	GROUND:CharEndAnim(meditite)
	GROUND:CharEndAnim(wooper_boy)
	GROUND:CharEndAnim(wooper_girl)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end


function metano_town_ch_4.Oddish_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "C'est ici que vit cette dame bizarre.", "Worried")
		--UI:WaitShowDialogue("Isn't she a Grass-type like me?[pause=0] The sun is so nice to be in!")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_056']))
	else
		--N/a
	end
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_4.Meditite_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		if not SV.Chapter4.WoopersMedititeConvo then
			metano_town_ch_4.Meditite_Woopers_Dialogue(chara)
		else
			GeneralFunctions.StartConversation(chara, "Je ne peux pas le croire...[pause=0]Je comprends les autres, les enfants...", "Stunned", false)
			GeneralFunctions.EndConversation(chara)
		end
	end
end

function metano_town_ch_4.Medicham_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--This mailbox my husband cherishes is garish. I wish I could get rid of it, but I don't want to upset him.
		GeneralFunctions.StartConversation(chara, "Garish est cette boîte aux lettres qui chérit mon mari.", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_057']))
		GeneralFunctions.EndConversation(chara)
	else
		if not SV.Chapter4.MedichamMachampArgument then
			metano_town_ch_4.Machamp_Medicham_Dialogue(chara)
		else
			GeneralFunctions.StartConversation(chara, "Dis-le comme ça quand tu,[pause=10]suppose que je trouve la boîte aux lettres assez drôle !", "Joyous", false)
			GeneralFunctions.EndConversation(chara)
		end
	end
end

function metano_town_ch_4.Machamp_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Cette forêt pleine d'Apricornes...[pause=0]Il s'avère qu'elle abrite un donjon mystérieux !")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_058']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_059']))
		GeneralFunctions.EndConversation(chara)
	else
		if not SV.Chapter4.MedichamMachampArgument then
			metano_town_ch_4.Machamp_Medicham_Dialogue(chara)
		else
			GeneralFunctions.StartConversation(chara, "Hoohoo ![pause=0]Je suis heureux que vous puissiez comprendre pourquoi j'aime la boîte aux lettres,[pause=10]très chère !", "Normal", false)
			GeneralFunctions.EndConversation(chara)
		end
	end
end

function metano_town_ch_4.Machamp_Medicham_Dialogue(chara)
	local machamp = CH('Machamp')
	local medicham = CH('Medicham')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local machamp_species = _DATA:GetMonster('machamp'):GetColoredName()

	partner.IsInteracting = true
	GROUND:CharSetAnim(medicham, 'None', true)
	GROUND:CharSetAnim(machamp, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(machamp)
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	SOUND:PlayBattleSE("EVT_Emote_Shock_Bad")
	GeneralFunctions.EmoteAndPause(machamp, "Shock", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_060']))
    TASK:JoinCoroutines({coro1})

	GAME:WaitFrames(20)
	UI:SetSpeaker(medicham)
	GeneralFunctions.SetEmotion("Worried")
	--Don't you think it's gaudy?
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_061']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(machamp)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_062']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_063'], machamp_species))
	GROUND:CharSetEmote(machamp, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_064']))
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(machamp, "", 0)
	UI:SetSpeaker(medicham)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_065']))

	GAME:WaitFrames(40)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(medicham, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_066']))
	--When you put it like that, I guess it is pretty funny!
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_067']))
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(medicham, "", 0)
	UI:SetSpeaker(machamp)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_068']))

	SV.Chapter4.MedichamMachampArgument = true
	GROUND:CharEndAnim(medicham)
	GROUND:CharEndAnim(machamp)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

function metano_town_ch_4.Growlithe_Desk_Action(chara, activator)
	local growlithe = CH('Growlithe')
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(growlithe, "Wow ![pause=0]Une expédition avec tout le monde ici à la guilde ![pause=0]Je suis tellement excité,[pause=10]ruff !", "Inspired")
		GeneralFunctions.SetEmotion("Joyous")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_069']))
	else
		GeneralFunctions.StartConversation(growlithe, CharacterEssentials.GetCharacterName("Breloom") .. " et " .. CharacterEssentials.GetCharacterName("Girafarig") .. " feraient mieux de se dépêcher, collerette[pause=10]!", "Happy")
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_070']))
	end
	GeneralFunctions.EndConversation(growlithe)
end

function metano_town_ch_4.Manectric_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "J'ai cette lettre que je veux envoyer à un de mes amis éloignés.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_071']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_072']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_073']))
	else
		GeneralFunctions.StartConversation(chara, "J'ai parlé davantage avec les employés de la poste,[pause=10]et ils ont accepté d'apporter ma lettre à mon ami !")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_074']))
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_075']))
		GAME:WaitFrames(30)
		GeneralFunctions.EmoteAndPause(chara, "Exclaim", true)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_076'], CharacterEssentials.GetCharacterName("Numel")))
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_077']))

	end
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_4.Sentret_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Je n'ai aucune corvée à faire ![pause=0]Mon père s'occupe d'eux,[pause=10]donc j'ai toujours le temps de jouer !", "Happy", false)
	else
		GeneralFunctions.StartConversation(chara, "Woah,[pause=10] vous êtes tous les deux des aventuriers de guilde, n'est-ce pas ?", "Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_078']))
		GAME:WaitFrames(10)
		SOUND:PlayBattleSE('EVT_Emote_Startled_2')
		GeneralFunctions.DoubleHop(chara)
		GROUND:CharSetEmote(chara, "happy", 0)
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_079']))
		GROUND:CharSetEmote(chara, "", 0)	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_4.Numel_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "J'ai travaillé très dur et j'ai terminé toutes mes corvées plus tôt ![pause=0]J'ai donc beaucoup de temps pour jouer aujourd'hui !", "Happy", false)
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_4.Floatzel_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Avec tous les hors-la-loi qui courent partout ces derniers temps,[pause=10] j'ai eu une excellente idée !")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_080']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_081']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_082']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_083']))
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_084']))
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_4.Quagsire_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Avez-vous vu mon mari quelque part ?", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_085']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_086']))
		GeneralFunctions.EndConversation(chara)
	else
		metano_town_ch_4.Quagsire_Kecleon_Dialogue(chara)
	end
end

function metano_town_ch_4.Quagsire_Kecleon_Dialogue(chara)
	local kecleon = CH('Shop_Owner')
	local quagsire = CH('Quagsire')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(quagsire, 'None', true)
	GROUND:CharSetAnim(kecleon, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:EntTurn(kecleon, Direction.DownLeft)

	UI:SetSpeaker(quagsire)
	GeneralFunctions.SetEmotion("Worried")
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_087']))
    TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)

	UI:SetSpeaker(kecleon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_088'], STRINGS:Format("\\u266A")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_089'], STRINGS:Format("\\u266A")))
	GAME:WaitFrames(20)

	UI:SetSpeaker(quagsire)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_090']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_091']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_092']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(kecleon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_093']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(quagsire)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_094']))



	GROUND:CharEndAnim(quagsire)
	GROUND:CharEndAnim(kecleon)
	GROUND:EntTurn(kecleon, Direction.Down)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

function metano_town_ch_4.Camerupt_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		metano_town_ch_4.Bellossom_Camerupt_Dialogue(chara)
	else

	end
end


function metano_town_ch_4.Bellossom_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		metano_town_ch_4.Bellossom_Camerupt_Dialogue(chara)
	else

	end
end

--they talk about chores, bellossom doesnt even think about them cuz she's a ditz
function metano_town_ch_4.Bellossom_Camerupt_Dialogue(chara)
	local bellossom = CH('Bellossom')
	local camerupt = CH('Camerupt')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(bellossom, 'None', true)
	GROUND:CharSetAnim(camerupt, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Happy")
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_095'], CharacterEssentials.GetCharacterName("Numel")))
	TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)

	UI:SetSpeaker(bellossom)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_096'], camerupt:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_097'], bellossom:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(bellossom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_098']))
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(camerupt, "Shock", true)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_099']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(bellossom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_100']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_101']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_102']))

	GROUND:CharEndAnim(bellossom)
	GROUND:CharEndAnim(camerupt)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end



function metano_town_ch_4.Luxray_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local wooper_species = _DATA:GetMonster('wooper'):GetColoredName()
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Electrike") .. " doit apprendre que ces jumeaux " .. wooper_species .. " désemparés ne valent pas la peine.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_103']))
	else

	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_4.Furret_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "Une fois toutes ces tâches terminées,[pause=10] je reviens à ce que j'aime faire le plus ~", "Happy", false, false)
	end
	GeneralFunctions.EndConversation(chara, false)
end


function metano_town_ch_4.Nidorina_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		metano_town_ch_4.Nidorina_Gloom_Dialogue(chara, activator)
	else
		--N/A
	end
end


function metano_town_ch_4.Gloom_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		metano_town_ch_4.Nidorina_Gloom_Dialogue(chara, activator)
	else
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Nidorina") .. " est resté coincé à l'auberge plus récemment.", "Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_104']))
		GeneralFunctions.EndConversation(chara)
	end
end


function metano_town_ch_4.Nidorina_Gloom_Dialogue(chara, activator)
	local nidorina = CH('Nidorina')
	local gloom = CH('Gloom')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(gloom, 'None', true)
	GROUND:CharSetAnim(nidorina, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(gloom)
	GeneralFunctions.SetEmotion("Worried")
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_105'], nidorina:GetDisplayName()))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_106']))
	TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)

	UI:SetSpeaker(nidorina)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_107']))
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_108']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(gloom)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_109']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_110']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(nidorina)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_111']))


	GROUND:CharEndAnim(gloom)
	GROUND:CharEndAnim(nidorina)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

function metano_town_ch_4.Nidoking_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "Salut à tous ![pause=0]Rendez-vous au Metano Inn pour le meilleur bed and breakfast sur des kilomètres !", "Happy")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_112']))
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_113']))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_4.Doduo_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "Nous avons entendu dire que la guilde allait bientôt organiser une expédition quelque part au nord.")
		GeneralFunctions.SetEmotion("Stunned")
		GROUND:CharSetEmote(chara, "sweating", 1)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_114']))
	end
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_4.Bagon_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "Donc la guilde part très bientôt en expédition,[pause=10] hein ?")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_115']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT4_116'], CharacterEssentials.GetCharacterName("Doduo")))
	end
	GeneralFunctions.EndConversation(chara)
end


