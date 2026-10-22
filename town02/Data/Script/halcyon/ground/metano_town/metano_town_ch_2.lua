require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_town_ch_2 = {}

function metano_town_ch_2.SetupGround()
	--objects/npcs that aren't for use in chapter 2
	GROUND:Hide('Red_Merchant')
	GROUND:Hide('Green_Merchant')
	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')
	GROUND:Hide('Cafe_Entrance')


	if SV.Chapter2.FirstMorningMeetingDone and not SV.Chapter2.FinishedTraining then
		--these objects prevent the player from going into the rest of the town too soon, as they must go to the dojo first and complete training
		local stoneBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
														RogueElements.Rect(896, 880, 16, 40),
														RogueElements.Loc(0, 0),
														true,
														"Event_Trigger_1")

		local bridgeBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
														RogueElements.Rect(464, 1184, 16, 64),
														RogueElements.Loc(0, 0),
														true,
														"Event_Trigger_2")

		local marketBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
														RogueElements.Rect(968, 1000, 16, 240),
														RogueElements.Loc(0, 0),
														true,
														"Event_Trigger_3")
		stoneBlock:ReloadEvents()
		bridgeBlock:ReloadEvents()
		marketBlock:ReloadEvents()

		GAME:GetCurrentGround():AddTempObject(stoneBlock)
		GAME:GetCurrentGround():AddTempObject(bridgeBlock)
		GAME:GetCurrentGround():AddTempObject(marketBlock)

		GAME:FadeIn(20)
	elseif SV.Chapter2.FinishedTraining and not SV.Chapter2.FinishedFirstDay then
		GROUND:AddMapStatus("dusk")--dusk
		local meditite, luxray, machamp, furret, wooper_girl, wooper_boy, electrike, lickitung, gulpin, nidorina, gloom, numel,
			  oddish, bellossom, floatzel, roselia, spinda, ludicolo, mawile, azumarill =
			CharacterEssentials.MakeCharactersFromList({
				{'Meditite', 552, 352, Direction.Down},
				{'Luxray', 'Town_Seat_1'},
				{'Machamp', 'Town_Seat_2'},
				{'Furret', 356, 764, Direction.Right},
				{'Wooper_Girl', 328, 1000, Direction.Right},
				{'Wooper_Boy', 360, 1000, Direction.Left},
				{'Electrike', 344, 976, Direction.Down},
				{'Lickitung', 1148, 604, Direction.Up},
				{'Gulpin', 1124, 628, Direction.UpRight},
				{'Nidorina', 536, 208, Direction.UpLeft},
				{'Gloom', 512, 184, Direction.DownRight},
				{'Numel', 192, 536, Direction.Left},
				{'Oddish', 408, 396, Direction.DownLeft},
				{'Bellossom', 472, 608, Direction.UpLeft},
				{'Floatzel', 714, 232, Direction.Up},
				{'Roselia', 1204, 1128, Direction.Down},
				{'Spinda', 1184, 1160, Direction.UpRight},
				{'Ludicolo', 1224, 1160, Direction.UpLeft},
				{'Mawile', 768, 600, Direction.Down},
				{'Azumarill', 272, 1208, Direction.Left},
				{'Mareep', 'Cafe_Seat_3'},
				{'Cranidos', 'Cafe_Seat_4'}
		})

		GROUND:CharSetAnim(furret, 'Sleep', true)
		AI:SetCharacterAI(mawile, "halcyon.ai.ground_default", RogueElements.Loc(752, 584), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(azumarill, "halcyon.ai.ground_default", RogueElements.Loc(256, 1192), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

		AI:SetCharacterAI(roselia, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {ludicolo, spinda})
		AI:SetCharacterAI(ludicolo, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {roselia, spinda})
		AI:SetCharacterAI(spinda, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {ludicolo, roselia})


		--place event trigger for numel's tantrum if he hasn't thrown it yet
		if not SV.Chapter2.FinishedNumelTantrum then
			local tantrumBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
												RogueElements.Rect(248, 472, 344, 120),
												RogueElements.Loc(0, 0),
												true,
												"Event_Trigger_4")

			--NPCs will get pushed outside of the large trigger area if it's not flagged as passible (i.e. no collision)
			tantrumBlock.Passable = true

			tantrumBlock:ReloadEvents()

			GAME:GetCurrentGround():AddTempObject(tantrumBlock)

			--place numel inside oddish for introductory cutscene, so their circles sync up well
			numel.CollisionDisabled = true
			GROUND:TeleportTo(numel, oddish.Position.X, oddish.Position.Y, Direction.DownLeft)

			if SV.Chapter2.FinishedTraining then --put a blockade in front of the guild if player has finished training but not numel scene
				local guildBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
												RogueElements.Rect(696, 896, 48, 8),
												RogueElements.Loc(0, 0),
												true,
												"Event_Trigger_5")
				guildBlock:ReloadEvents()

				GAME:GetCurrentGround():AddTempObject(guildBlock)
			end
		end

		--block player from leaving town north or east
		local northBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
										RogueElements.Rect(232, 8, 40, 8),
										RogueElements.Loc(0, 0),
										true,
										"Event_Trigger_6")

		local eastBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
										RogueElements.Rect(1496, 592, 8, 144),
										RogueElements.Loc(0, 0),
										true,
										"Event_Trigger_7")

		northBlock:ReloadEvents()
		eastBlock:ReloadEvents()

		GAME:GetCurrentGround():AddTempObject(northBlock)
		GAME:GetCurrentGround():AddTempObject(eastBlock)

		--let the cutscene handle the fade in if it hasnt played yet
		if SV.Chapter2.FinishedMarketIntro then
			GAME:FadeIn(20)
		end

	elseif SV.Chapter2.FinishedFirstDay then
		local lickitung, gulpin, mawile, azumarill, quagsire, oddish, sentret, bellossom, linoone, medicham, machamp,
		meditite, manetric, marill, jigglypuff, spheal, wooper_boy, wooper_girl, vileplume, luxray =
			CharacterEssentials.MakeCharactersFromList({
				{'Lickitung', 1148, 604, Direction.Up},
				{'Gulpin', 1124, 628, Direction.UpRight},
				{'Mawile', 648, 1272, Direction.Down},
				{'Azumarill', 272, 1208, Direction.Left},
				{'Quagsire', 714, 232, Direction.Up},
				{'Oddish', 312, 408, Direction.Down},--i wanted numel to play with us...
				{'Sentret', 312, 440, Direction.Up},--its ok he'll be back soon, let's play just the two of us
				{'Bellossom', 478, 686, Direction.Down},
				{'Linoone', 'Town_Seat_1'},
				{'Medicham', 'Town_Seat_2'},
				{'Machamp', 1264, 352, Direction.Down},--i'll search around town to find the kid! i'll help however i can!
				{'Meditite', 556, 216, Direction.Down},--meditating is hard, i dont really get it
				{'Manectric', 1144, 904, Direction.Down},--i dont know what I would do if my kid went missing!
				{'Marill', 1184, 1160, Direction.UpRight},
				{'Jigglypuff', 1224, 1160, Direction.UpLeft},
				{'Spheal', 1204, 1128, Direction.Down},
				{'Wooper_Boy', 744, 1144, Direction.Right},
				{'Wooper_Girl', 776, 1144, Direction.Left},
				{'Vileplume', 388, 716, Direction.DownRight},
				{'Luxray', 304, 1024, Direction.Down}
		})

		AI:SetCharacterAI(machamp, "halcyon.ai.ground_default", RogueElements.Loc(1248, 336), RogueElements.Loc(48, 48), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(mawile, "halcyon.ai.ground_default", RogueElements.Loc(624, 1248), RogueElements.Loc(48, 48), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(manetric, "halcyon.ai.ground_default", RogueElements.Loc(1104, 888), RogueElements.Loc(80, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(azumarill, "halcyon.ai.ground_default", RogueElements.Loc(256, 1192), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(luxray, "halcyon.ai.ground_default", RogueElements.Loc(272, 1008), RogueElements.Loc(80, 32), 1, 16, 32, 40, 180)

		local eastBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
										RogueElements.Rect(1496, 592, 8, 144),
										RogueElements.Loc(0, 0),
										true,
										"Event_Trigger_8")

		local northBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
										RogueElements.Rect(232, 8, 40, 8),
										RogueElements.Loc(0, 0),
										true,
										"Event_Trigger_9")

		eastBlock:ReloadEvents()
		northBlock:ReloadEvents()

		GAME:GetCurrentGround():AddTempObject(eastBlock)
		GAME:GetCurrentGround():AddTempObject(northBlock)

		GAME:FadeIn(20)
	else
		GAME:FadeIn(20)
	end
end

function metano_town_ch_2.Event_Trigger_1_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("C'est ainsi qu'on accède au marché.[pause=0]Je ne pense pas que Ledian Dojo soit ainsi.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_002'], CharacterEssentials.GetCharacterName("Noctowl")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_003']))

	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_2_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("C'est le chemin vers la zone d'habitation.[pause=0]Je ne pense pas que Ledian Dojo soit par là.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_004']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_005'], CharacterEssentials.GetCharacterName("Noctowl")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_006']))
	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_3_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("Hé,[pause=10]" .. hero:GetDisplayName() .. ",[pause=10] ça doit être l'échelle qui mène au dojo juste là-bas !", "Normal", false)
	GeneralFunctions.TurnTowardsLocation(partner, 924, 1128)
	GeneralFunctions.TurnTowardsLocation(hero, 924, 1128)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_007']))

	GeneralFunctions.EndConversation(partner)

end




function metano_town_ch_2.Event_Trigger_4_Touch(obj, activator)
	metano_town_ch_2.NumelTantrumCutscene()
end

function metano_town_ch_2.Event_Trigger_5_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("Hé,[pause=10]" .. hero:GetDisplayName() .. ",[pause=10] tu ne veux toujours pas regarder autour de toi en ville ?")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_008']))

	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_6_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("Ce chemin mène hors de la ville.[pause=0]Vous n'avez pas le temps de quitter la ville avant le dîner !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_009']))
	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_7_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("Ce chemin mène hors de la ville.[pause=0]Vous n'avez pas le temps de quitter la ville avant le dîner !")

	if SV.Chapter2.FinishedNumelTantrum then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_010']))
	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_011']))
	end
	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_8_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
	GeneralFunctions.StartPartnerConversation("Ce n'est pas le chemin vers " .. zone:GetColoredName() .. ".")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_012'], CharacterEssentials.GetCharacterName("Noctowl")))
	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_9_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")

	GeneralFunctions.StartPartnerConversation("C'est le chemin vers " .. zone:GetColoredName() .. ".")
	UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['MT2_013']), true)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result then
		GAME:CutsceneMode(true)
		GROUND:Hide('Event_Trigger_9')
		GROUND:Hide('North_Exit')

		local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 232, 8, false, 1)
													  GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
		local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 256, 8, false, 1)
													  GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
		TASK:JoinCoroutines({coro1, coro2})

		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_014']))

		if SV.Chapter2.EnteredRiver then
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_015'], hero:GetDisplayName()))
		else
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_016'], hero:GetDisplayName()))
		end

		GAME:WaitFrames(20)
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
		coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
		TASK:JoinCoroutines({coro1, coro2})

		GAME:WaitFrames(20)
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 244, -4, false, 1)
												GROUND:MoveToPosition(partner, 244, -24, false, 1) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
												GeneralFunctions.EightWayMove(hero, 244, -4, false, 1)
												GROUND:MoveToPosition(hero, 244, -24, false, 1) end)

		TASK:JoinCoroutines({coro1, coro2})
		SOUND:FadeOutBGM(60)
		GAME:FadeOut(false, 60)

		GAME:WaitFrames(120)

		GAME:CutsceneMode(false)
		GeneralFunctions.EndConversation(partner)
		SV.partner.Spawn = "Default"
        GAME:EnterGroundMap("illuminant_riverbed_entrance", 'Main_Entrance_Marker')


	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_017']))
		GeneralFunctions.EndConversation(partner)
	end

end



function metano_town_ch_2.MarketIntro()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local green_kec = CH('Shop_Owner')
	local purple_kec = CH('TM_Owner')
	local kangaskhan = CH('Storage_Owner')
	local murkrow = CH('Bank_Owner')
	local sneasel = CH('Appraisal')
	local slowpoke = CH('Tutor_Owner')
	local ambipom = CH('Swap_Owner')

	GAME:CutsceneMode(true)
	GROUND:CharSetAnim(green_kec, 'Idle', true)
	GROUND:CharSetAnim(purple_kec, 'Idle', true)
	GROUND:CharSetAnim(slowpoke, 'Idle', true)
	GROUND:CharSetAnim(kangaskhan, 'Idle', true)
	GROUND:CharSetAnim(murkrow, 'Idle', true)
	GROUND:CharSetAnim(sneasel, 'Idle', true)
	GROUND:CharSetAnim(CH('Ludicolo'), 'Idle', true)
	GROUND:CharSetAnim(CH('Roselia'), 'Idle', true)
	GROUND:CharSetAnim(CH('Spinda'), 'Idle', true)
	GROUND:CharSetAnim(CH('Musician'), 'Idle', true)

	AI:DisableCharacterAI(partner)
	GeneralFunctions.CenterCamera({hero, partner})
	GAME:FadeIn(20)


	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_018']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_019']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_020']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_021']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_022']))
	GAME:WaitFrames(10)

	GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.UpRight)
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_023']))

	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_024']))

	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.DownRight, 4)
												  GeneralFunctions.EightWayMove(partner, 984, 1208, false, 1)
												  GeneralFunctions.EightWayMove(partner, 1032, 1208, false, 1)
												  GeneralFunctions.EightWayMove(partner, 1096, 1136, false, 1)
												  GeneralFunctions.EightWayMove(partner, 1096, 944, false, 1)
												  GeneralFunctions.EightWayMove(partner, 1152, 904, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(15)
												  GROUND:CharAnimateTurnTo(hero, Direction.DownRight, 4)
												  GeneralFunctions.EightWayMove(hero, 984, 1208, false, 1)
												  GeneralFunctions.EightWayMove(hero, 1032, 1208, false, 1)
												  GeneralFunctions.EightWayMove(hero, 1096, 1136, false, 1)
												  GeneralFunctions.EightWayMove(hero, 1096, 944, false, 1)
												  GeneralFunctions.EightWayMove(hero, 1120, 904, false, 1)
												  GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(936, 1160, 12, false)
												  GAME:MoveCamera(992, 1216, 56, false)
												  GAME:MoveCamera(1040, 1216, 48, false)
												  GAME:MoveCamera(1104, 1152, 64, false)
												  GAME:MoveCamera(1104, 952, 200, false)
												  GAME:MoveCamera(1128, 928, 24, false)
												  GAME:MoveCamera(1128, 912, 16, false)
												  GAME:MoveCamera(1144, 912, 16, false) end)


	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_025']))

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, purple_kec, 4)
											GROUND:CharTurnToCharAnimated(hero, purple_kec, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({green_kec, purple_kec}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_026'], _DATA:GetMonster(green_kec.CurrentForm.Species).Name:ToLocal(), green_kec:GetDisplayName(), purple_kec:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_027']))

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, kangaskhan, 4)
											GROUND:CharTurnToCharAnimated(hero, kangaskhan, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({kangaskhan}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_028'], _DATA:GetMonster(kangaskhan.CurrentForm.Species).Name:ToLocal(), kangaskhan:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_029']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_030'], CharacterEssentials.GetCharacterName("Ledian")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_031'], kangaskhan:GetDisplayName()))

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, sneasel, 4)
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({sneasel}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_032'], sneasel:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_033']))

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, murkrow, 4)
											GROUND:CharTurnToCharAnimated(hero, murkrow, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({murkrow}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_034']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_035'], murkrow:GetDisplayName()))

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, slowpoke, 4)
											GROUND:CharTurnToCharAnimated(hero, slowpoke, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({slowpoke}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_036'], slowpoke:GetDisplayName()))

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, ambipom, 4)
											GROUND:CharTurnToCharAnimated(hero, ambipom, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({ambipom}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_037'], ambipom:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_038'], ambipom:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharTurnToChar(partner, hero)
	GROUND:CharTurnToChar(hero, partner)
	GeneralFunctions.CenterCamera({hero, partner}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 3)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_039']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_040']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_041']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_042']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_043']))

	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera()

	GROUND:CharEndAnim(green_kec)
	GROUND:CharEndAnim(purple_kec)
	GROUND:CharEndAnim(sneasel)
	GROUND:CharEndAnim(kangaskhan)
	GROUND:CharEndAnim(murkrow)
	GROUND:CharEndAnim(slowpoke)
	GROUND:CharEndAnim(CH('Ludicolo'))
	GROUND:CharEndAnim(CH('Roselia'))
	GROUND:CharEndAnim(CH('Spinda'))
	GROUND:CharEndAnim(CH('Musician'))

	SV.Chapter2.FinishedMarketIntro = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)


end


function metano_town_ch_2.NumelTantrumCutscene()
	local numel = CH('Numel')
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local machamp = CH('Machamp')
	local luxray = CH('Luxray')
	local oddish = CH('Oddish')
	local meditite = CH('Meditite')
	local bellossom = CH('Bellossom')
	local camerupt = CharacterEssentials.MakeCharactersFromList({
				{'Camerupt', 0, 0, Direction.Right}
		})
	--Hide Camerupt until she is ready to pop into frame
	GROUND:Hide('Camerupt')
	GROUND:TeleportTo(camerupt, 248, 536, Direction.Right)

	--remove trigger for the cutscene
	GROUND:Hide('Event_Trigger_4')

	GAME:CutsceneMode(true)
	GROUND:CharSetAnim(machamp, "Idle", true)
	GROUND:CharSetAnim(luxray, "Idle", true)
	GROUND:CharSetAnim(meditite, "Idle", true)
	GROUND:CharSetAnim(bellossom, "Idle", true)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_044'], hero:GetDisplayName()))
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(20)

	--set this to true to stop their running
	local stopRunning = false

	--This flag is used to make numel do an extra lap if oddish hasn't stopped when numel tries to stop running. This is to prevent an issue where oddish would clip through numel if numel stopped before oddish did.
	local oddishStopped = false

	--they play tag until numel's mama calls for him
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, numel, 4)
												  GROUND:CharTurnToCharAnimated(hero, numel, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
												  while not stopRunning do
													GeneralFunctions.RunInCircle(numel, 12, 2, false, false) end
													if not oddishStopped then GeneralFunctions.RunInCircle(numel, 12, 2, false, false) end --do an extra lap to prevent clipping
													GeneralFunctions.EmoteAndPause(numel, "Exclaim", false) end)
	local coro3 = TASK:BranchCoroutine(function() while not stopRunning do
													GeneralFunctions.RunInCircle(oddish, 12, 2, false, false) end
													oddishStopped = true
													GROUND:MoveInDirection(oddish, Direction.DownLeft, 12, false, 2)
													GeneralFunctions.EmoteAndPause(oddish, "Exclaim", true) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:MoveCamera(428, 464, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 428, 464, 3), false)
												  GAME:WaitFrames(20)
												  SOUND:PlayBGM('Heartwarming.ogg', false)
												  UI:SetSpeaker(oddish)
												  GeneralFunctions.SetEmotion("Happy")
												  GROUND:CharSetEmote(oddish, "glowing", 0)
												  UI:WaitShowTimedDialogue("Haha,[pause=10]tu ne m'attraperas jamais,[pause=10]" .. numel:GetDisplayName() .. " !", 60)
												  GAME:WaitFrames(20)
												  GROUND:CharSetEmote(oddish, "", 0)
												  GROUND:CharSetEmote(numel, "glowing", 0)
												  UI:SetSpeaker(numel)
												  GeneralFunctions.SetEmotion("Happy")
												  UI:WaitShowTimedDialogue("Oui, je le ferai ![pause=30]Je vais y aller,[pause=10]" .. oddish:GetDisplayName() .. " !", 60)
												  GAME:WaitFrames(20)
												  GROUND:CharSetEmote(numel, "", 0)
												  UI:SetSpeaker(partner)
												  GeneralFunctions.SetEmotion("Happy")
												  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_045']))
												  GAME:WaitFrames(20)
												  GeneralFunctions.HeroDialogue(hero, "(Aww,[pause=10]c'est plutôt mignon.[pause=0]Ils ont vraiment beaucoup d'énergie !)", "Happy")
												  GAME:WaitFrames(40)
												  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
												  UI:WaitShowTimedDialogue(numel:GetDisplayName() .. "!", 60)
												  GROUND:Unhide("Camerupt")
												  stopRunning = true end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(camerupt, 288, 536, false, 1)
											GROUND:MoveToPosition(camerupt, 348, 476, false, 1)
											GROUND:MoveToPosition(camerupt, 396, 476, false, 1)
											GeneralFunctions.EightWayMove(camerupt, numel.Position.X, numel.Position.Y + 48, false, 1)
											end)

	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(numel, camerupt, 4, Direction.Down) end)

	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(oddish, camerupt, 4, Direction.DownRight) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_046'], numel:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_047']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(numel)
	GeneralFunctions.Hop(numel)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_048'], oddish:GetDisplayName()))

	GAME:WaitFrames(10)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.EmoteAndPause(camerupt, "Notice", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_049']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_050']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(numel, "Exclaim", true)
	GeneralFunctions.ShakeHead(numel)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Sad")
	SOUND:FadeOutBGM(120)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_051']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_052'], numel:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_053']))

	GAME:WaitFrames(10)
	GeneralFunctions.Complain(numel)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Determined")
	GROUND:CharSetEmote(numel, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_054']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_055'], oddish:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharEndAnim(machamp)
	GROUND:CharEndAnim(luxray)


	coro1 = TASK:BranchCoroutine(function() --GeneralFunctions.EmoteAndPause(machamp, "Notice", false)
											GROUND:CharTurnToCharAnimated(machamp, numel, 4) end)
	coro2 = TASK:BranchCoroutine(function() --GeneralFunctions.EmoteAndPause(luxray, "Notice", false)
											GROUND:CharTurnToCharAnimated(luxray, numel, 4) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)
	GeneralFunctions.EmoteAndPause(camerupt, "Exclaim", true)
	GROUND:CharAnimateTurnTo(camerupt, Direction.Down, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(camerupt, "Sweating", true)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_056'], numel:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_057']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(camerupt, numel, 4)
	GAME:WaitFrames(10)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_058'], numel:GetDisplayName()))

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(numel, "Exclaim", true)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_059']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_060']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Angry")
	GROUND:CharSetEmote(numel, "angry", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_061']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_062']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_063']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_064']))

	GAME:WaitFrames(10)
	GROUND:CharSetEmote(numel, "", 0)

	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(camerupt, "Walk", Direction.Left, Direction.Right, 12, 1, 2)
											GeneralFunctions.FaceMovingCharacter(camerupt, numel, 4, Direction.DownLeft) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(oddish, numel, 4, Direction.DownLeft) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(machamp, numel, 4, Direction.DownLeft) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(luxray, numel, 4, Direction.DownLeft) end)
	local coro5 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(numel, 408, 476, true, 3)
												  GROUND:MoveToPosition(numel, 348, 476, true, 3)
												  GROUND:MoveToPosition(numel, 288, 536, true, 3)
												  GROUND:MoveToPosition(numel, 248, 536, true, 3) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(40)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxray, camerupt, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(machamp, camerupt, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(oddish, camerupt, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(camerupt, Direction.Down, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(40)
	GeneralFunctions.EmoteAndPause(camerupt, "Sweatdrop", true)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_065']))

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(camerupt, 400, 476, false, 1)
											GROUND:MoveToPosition(camerupt, 348, 476, false, 1)
											GROUND:MoveToPosition(camerupt, 288, 536, false, 1)
											GROUND:MoveToPosition(camerupt, 248, 536, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(oddish, camerupt, 4, Direction.Down) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(machamp, camerupt, 4, Direction.DownLeft) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(luxray, camerupt, 4, Direction.DownLeft) end)


	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GROUND:TeleportTo(numel, 192, 536, Direction.Left)
	GAME:GetCurrentGround():RemoveTempChar(camerupt)

	GAME:WaitFrames(20)

	--player and partner lament on what they just saw, partner mentions they should head to the guild when player is ready to eat dinner
	SOUND:FadeOutBGM(120)
	GROUND:CharSetAnim(oddish, "Idle", true)
	GROUND:CharSetAnim(numel, "Idle", true)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxray, machamp, 4)
											GROUND:CharSetAnim(luxray, "Idle", true) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharSetAnim(machamp, "Idle", true)
											GROUND:CharTurnToCharAnimated(machamp, luxray, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(0, 0, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, hero.Position.X + 8, hero.Position.Y + 8, 3), true) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	--resuming playing whatever song is selected for town.
	SOUND:PlayBGM(SV.metano_town.Song, true)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_066']))

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(J'ai l'impression qu'il y avait plus dans cette bagarre qu'une simple querelle de famille...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Mais je suppose que ce ne sont pas vraiment nos affaires,[pause=10]en tout cas...)", "Worried")

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)


	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_067']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_068']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_069']))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_070']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_071']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_072']))

	GROUND:CharEndAnim(oddish)
	GROUND:CharEndAnim(luxray)
	GROUND:CharEndAnim(machamp)
	GROUND:CharEndAnim(bellossom)
	GROUND:CharEndAnim(meditite)
	GROUND:CharEndAnim(numel)
	GROUND:Hide('Event_Trigger_5')--remove event trigger blocking you from entering the guild
	SV.Chapter2.FinishedNumelTantrum = true
	numel.CollisionDisabled = false
	GAME:CutsceneMode(false)


end





--Growlithe himself is behind the desk, so there's an obj on the desk that we interact with to actually talk with him
function metano_town_ch_2.Growlithe_Desk_Action(chara, activator)
	local growlithe = CH('Growlithe')
	if not SV.Chapter2.FinishedTraining then
		GeneralFunctions.StartConversation(growlithe, "Qu'est-ce que c'est, fraise[pause=10]?[pause=0]Vous recherchez le Dojo Ledian ?")
		GAME:WaitFrames(20)
		GROUND:EntTurn(growlithe, Direction.DownRight)

		local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownRight, 4) end)
		local coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 4) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(928, 1120, 120, false) end)

		TASK:JoinCoroutines({coro1, coro2, coro3})
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_073']))
		GAME:WaitFrames(20)
		GAME:MoveCamera(0, 0, 120, true)

		GROUND:EntTurn(growlithe, Direction.Right)

		coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(CH('Teammate1'), growlithe, 4) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(CH('PLAYER'), growlithe, 4) end)

		TASK:JoinCoroutines({coro1, coro2})
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_074']))
	elseif not SV.Chapter2.FinishedNumelTantrum then
		GeneralFunctions.StartConversation(growlithe, "J'espère que votre entraînement s'est bien passé,[pause=10]!", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_075'], CharacterEssentials.GetCharacterName('Snubbull')))
	elseif not SV.Chapter2.FinishedFirstDay then
		GeneralFunctions.StartConversation(growlithe, "J'espère que votre entraînement s'est bien passé,[pause=10]!", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_076']))
	elseif not SV.Chapter2.EnteredRiver then
		GeneralFunctions.StartConversation(growlithe, CharacterEssentials.GetCharacterName("Camerupt") .. " est passé par ici plus tôt en panique,[pause=10]collerette...[pause=0]Je ne pouvais même pas l'empêcher de demander ce qui n'allait pas !", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_077']))
	else
		GeneralFunctions.StartConversation(growlithe, "J'ai découvert votre mission pour retrouver " .. CharacterEssentials.GetCharacterName('Numel') .. ". La disparition de ZXQVAR0QXZ explique pourquoi " .. CharacterEssentials.GetCharacterName("Camerupt") .. " était si hystérique l'autre jour, ruff[pause=10].")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_078']))
	end
	GeneralFunctions.EndConversation(growlithe)
end







function metano_town_ch_2.Wooper_Siblings_Introduction(chara)
	local dee = CH('Wooper_Girl')
	local dun = CH('Wooper_Boy')
	local electrike = CH('Electrike')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(dee, 'None', true)
	GROUND:CharSetAnim(electrike, 'None', true)
	GROUND:CharSetAnim(dun, 'None', true)

	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)

	UI:SetSpeaker(dee)
    --local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dee, 4) end)
    --local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dee, 4) end)

    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_079'], dun:GetDisplayName()))

    --TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)

	UI:SetSpeaker(dun)
   -- coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dun, 4) end)
   -- coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dun, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_080'], dee:GetDisplayName()))
	--TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)

	UI:SetSpeaker(dee)
   -- coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dee, 4) end)
    --coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dee, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_081'], dun:GetDisplayName()))
	--TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)

	UI:SetSpeaker(dun)
    --coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dun, 4) end)
   --coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dun, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_082'], dee:GetDisplayName()))
	--TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:SetSpeaker(dee)
  --  coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dee, 4) end)
   -- coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dee, 4) end)
	UI:WaitShowTimedDialogue("Je ne sais pas,[pause=10] qu'est-ce que-", 40)
	--TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(electrike)
	GeneralFunctions.EmoteAndPause(electrike, "Angry", true)
   -- coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, electrike, 4) end)
   -- coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, electrike, 4) end)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_083']))
	--TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_084']))
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_085']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(dee)
   -- coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dee, 4) end)
   -- coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dee, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_086'], dun:GetDisplayName()))
	--TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:SetSpeaker(dun)
    --coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dun, 4) end)
   -- coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dun, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_087'], dee:GetDisplayName()))
	--TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:SetSpeaker(dee)
    --coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dee, 4) end)
    --coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dee, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_088'], dun:GetDisplayName()))
	--TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:SetSpeaker(dun)
    --coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dun, 4) end)
    --coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dun, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_089'], dee:GetDisplayName()))
	--TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:SetSpeaker(electrike)
	GeneralFunctions.SetEmotion('Worried')
	GeneralFunctions.EmoteAndPause(electrike, "Sweatdrop", true)
    --coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, electrike, 4) end)
    --coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, electrike, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_090']))
	--TASK:JoinCoroutines({coro1, coro2})
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(electrike)
	GROUND:CharEndAnim(dun)
	GROUND:CharEndAnim(dee)

	partner.IsInteracting = false
	SV.Chapter2.WooperIntro = true

end

function metano_town_ch_2.Wooper_Day_2_Conversation(chara)
	local dee = CH('Wooper_Girl')
	local dun = CH('Wooper_Boy')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(dee, 'None', true)
	GROUND:CharSetAnim(dun, 'None', true)

	--turn towards whoever we chose to interact with
	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)


	UI:SetSpeaker(dee)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_091'], dun:GetDisplayName(), CharacterEssentials.GetCharacterName('Electrike')))

	GAME:WaitFrames(20)
	UI:SetSpeaker(dun)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_092'], dee:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(dee)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_093']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(dun)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_094']))

	GROUND:CharEndAnim(dee)
	GROUND:CharEndAnim(dun)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false

end

--dee
function metano_town_ch_2.Wooper_Girl_Action(chara, activator)
	local dee = chara
	if SV.Chapter2.FinishedFirstDay then
		metano_town_ch_2.Wooper_Day_2_Conversation(dee)
	elseif SV.Chapter2.WooperIntro then
		GeneralFunctions.StartConversation(dee, "Je ne sais pas,[pause=10] que veux-tu faire aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Wooper_Boy") .. " ?", "Normal", false)
		GeneralFunctions.EndConversation(dee)
	else
		metano_town_ch_2.Wooper_Siblings_Introduction(chara)
	end
end


--dun
function metano_town_ch_2.Wooper_Boy_Action(chara, activator)
	local dun = chara
	if SV.Chapter2.FinishedFirstDay then
		metano_town_ch_2.Wooper_Day_2_Conversation(dun)
	elseif SV.Chapter2.WooperIntro then
		GeneralFunctions.StartConversation(dun, "Je ne sais pas,[pause=10] que veux-tu faire aujourd'hui,[pause=10]" .. CharacterEssentials.GetCharacterName("Wooper_Girl") .. " ?", "Normal", false)
		GeneralFunctions.EndConversation(dun)
	else
		metano_town_ch_2.Wooper_Siblings_Introduction(chara)
	end
end

function metano_town_ch_2.Electrike_Action(chara, activator)
	local hero = CH('PLAYER')
	local electrike = chara
	if SV.Chapter2.WooperIntro then
		GeneralFunctions.StartConversation(electrike, "Help.[pause=0] Me.", "Worried")
		GeneralFunctions.EndConversation(electrike)
	else
		metano_town_ch_2.Wooper_Siblings_Introduction(chara)
	end
end


function metano_town_ch_2.Furret_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Aaah...[pause=0]C'est mon endroit préféré pour dormir~", "Happy", false, false)
	GeneralFunctions.EndConversation(chara, false)
end

function metano_town_ch_2.Meditite_Action(chara, activator)
	local meditite = chara
	if not SV.Chapter2.FinishedFirstDay then--first day dialogue
		GeneralFunctions.StartConversation(meditite, "..........", "Normal", false, false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_095']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_096']))
		GROUND:CharSetEmote(CH('Teammate1'), "sweatdrop", 1)
		GeneralFunctions.EmoteAndPause(CH('PLAYER'), 'Sweatdrop', true)
		UI:ResetSpeaker(false)
		UI:SetCenter(true)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_097']))
		UI:SetCenter(false)
	else --second day dialogue
		GeneralFunctions.StartConversation(meditite, "Ma mère essaie de m'apprendre la \"paix intérieure\", la \"méditation\" et tout ça...")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_098']))
	end
	GeneralFunctions.EndConversation(meditite)
end


function metano_town_ch_2.Lickitung_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then--first day dialogue
		GeneralFunctions.StartConversation(chara, "Apparemment,[pause=10]le café est fermé pour quelques jours...")
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_099']))
		GeneralFunctions.EndConversation(chara)
	else --second day dialogue
		GeneralFunctions.StartConversation(chara, "Comme le café va bientôt rouvrir,[pause=10] nous avons pensé que nous camperions ici jusqu'à son ouverture.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_100']))
		GeneralFunctions.EndConversation(chara)
	end
end


function metano_town_ch_2.Gulpin_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then--first day dialogue
		GeneralFunctions.StartConversation(chara, "...Hein ?[pause=0]Le café est fermé... ?")
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_101']))
		GeneralFunctions.EndConversation(chara)
	else --second day dialogue
		GeneralFunctions.StartConversation(chara, "...Combien de temps devrai-je attendre pour avoir ma précieuse boisson ?", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_102']))
		GeneralFunctions.EndConversation(chara)
	end
end


function metano_town_ch_2.Machamp_Luxray_Dialogue(chara)
	local machamp = CH('Machamp')
	local luxray = CH('Luxray')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(luxray, 'None', true)
	GROUND:CharSetAnim(machamp, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(machamp)
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_103'], CharacterEssentials.GetCharacterName('Camerupt')))
    TASK:JoinCoroutines({coro1})

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_104']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_105'], CharacterEssentials.GetCharacterName('Numel')))
	GAME:WaitFrames(20)

	UI:SetSpeaker(luxray)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_106']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_107']))
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(machamp, "sweating", 1)
	UI:SetSpeaker(machamp)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_108']))

	GROUND:CharEndAnim(luxray)
	GROUND:CharEndAnim(machamp)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false

end

function metano_town_ch_2.Machamp_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then --first day
		metano_town_ch_2.Machamp_Luxray_Dialogue(chara)
	else --second day
		GeneralFunctions.StartConversation(chara, "Le petit " .. CharacterEssentials.GetCharacterName("Numel") .. " s'est égaré et personne ne sait où il pourrait être.[pause=0]Sa pauvre mère s'inquiète pour ses morceaux.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_109']))
		GeneralFunctions.EndConversation(chara)
	end
end

function metano_town_ch_2.Luxray_Action(chara, activator)
	if SV.Chapter2.FinishedFirstDay then
		local numel_species = _DATA:GetMonster('numel'):GetColoredName()
		GeneralFunctions.StartConversation(chara, "J'ai appris que l'enfant " .. numel_species .. " avait disparu.[pause=0]Cela ne me surprend pas.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_110'], CharacterEssentials.GetCharacterName("Camerupt")))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_111']))
		GeneralFunctions.EndConversation(chara)
	else
		metano_town_ch_2.Machamp_Luxray_Dialogue(chara)
	end
end


function metano_town_ch_2.Nidorina_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "...[pause=30]...Vous faites partie d'une équipe d'aventuriers ?")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_112']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Gloom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Wow ![pause=0]Vous êtes deux aventuriers ?[pause=0]C'est tellement... !")
	GROUND:CharSetEmote(chara, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_113']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_114']))
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_2.Oddish_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then-- first day dialogue
		GeneralFunctions.StartConversation(chara, "J'aurais aimé que " .. CharacterEssentials.GetCharacterName('Numel') .. " n'ait pas à aller faire ses corvées...", "Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_115']))
	else
		GeneralFunctions.StartConversation(chara, "Où est " .. CharacterEssentials.GetCharacterName('Numel') .. " ce matin ?[pause=0]Je pensais qu'il allait jouer avec nous aujourd'hui !", "Sad", false)
	end

	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_2.Numel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Corvées stupides...[pause=0]Je déteste ramasser du bois de chauffage.[pause=0]Ça pue.", "Determined", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_116']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Floatzel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Voici le fameux puits à souhaits de Metano.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_117'], STRINGS:Format("\\uE024")))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_118']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_119'], STRINGS:Format("\\uE024")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_120']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Bellossom_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then
		GeneralFunctions.StartConversation(chara, "Tra-la-la " .. STRINGS:Format("\\u266A"), "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_121']))
	elseif not SV.Chapter2.EnteredRiver then
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Camerupt") .. " m'a demandé si j'avais vu " .. CharacterEssentials.GetCharacterName("Numel") .. " ce matin.[pause=0]Apparemment,[pause=10]a disparu...", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_122'], CharacterEssentials.GetCharacterName("Numel")))
		GeneralFunctions.SetEmotion("Normal")
		--too long with no nicknames
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_123'], CharacterEssentials.GetCharacterName("Camerupt")))
	else
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Camerupt") .. " a apprécié les fleurs que je lui ai apportées,[pause=10]mais elle semblait toujours déprimée.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_124'], CharacterEssentials.GetCharacterName("Numel")))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Azumarill_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then
		GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " dit qu'il fait beau dehors !", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_125'], chara:GetDisplayName(), chara:GetDisplayName()))
	else
		GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " a entendu dire que l'enfant avait disparu.[pause=0]" .. chara:GetDisplayName() .. " demande :[pause=10]\"où pourrait être l'enfant ?\"")
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_126'], chara:GetDisplayName(), chara:GetDisplayName()))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Mawile_Action(chara, activator)

	--[[
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, chara.CurrentForm.Species, chara.CurrentForm.Form, chara.CurrentForm.Skin, chara.CurrentForm.Gender)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local olddir = chara.Direction
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(chara, 'None', true)
	GROUND:CharTurnToChar(chara, partner)
	GROUND:CharTurnToChar(partner, chara)
	GROUND:CharTurnToChar(hero, chara)

	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_127'], partner:GetDisplayName()))
	GROUND:CharSetEmote(chara, "glowing", 0)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_128']))


	GAME:WaitFrames(20)
	GROUND:CharSetEmote(chara, "", 0)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_129'], chara:GetDisplayName()))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_130']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(chara, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_131']))

	GROUND:CharTurnToCharAnimated(chara, hero, 4)
	UI:SetSpeaker("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_132']))
	--]]


	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	if not SV.Chapter2.FinishedFirstDay then --first day dialogue
		GeneralFunctions.StartConversation(chara, "Hé,[pause=10]" .. partner:GetDisplayName() .. "![pause=0]Comment ça va ?", "Happy")
		GROUND:CharSetEmote(chara, "glowing", 0)
		GeneralFunctions.SetEmotion("Joyous")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_133']))

		GAME:WaitFrames(20)
		GROUND:CharSetEmote(chara, "", 0)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_134'], chara:GetDisplayName()))

		GAME:WaitFrames(20)
		UI:SetSpeaker(chara)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_135']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_136']))

	else --second day dialogue
		GeneralFunctions.StartConversation(chara, "J'ai entendu parler de l'enfant disparu.[pause=0]Tout le monde en parle.", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_137']))
	end
	GeneralFunctions.EndConversation(chara)

end


function metano_town_ch_2.Roselia_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Tah![pause=0]Nous sommes l'équipe[color=#FFA5FF]Cadence[color]![pause=0]Nous aimons danser !", "Normal", true, false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_138'], STRINGS:Format("\\u266A")))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Spinda_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Lah![pause=0]Viens prendre la pose avec moi !", "Normal", true, false)
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Ludicolo_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Yah![pause=0]C'est le meilleur endroit en ville pour danser !", "Normal", true, false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_139'], CharacterEssentials.GetCharacterName("Chatot")))
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_2.Mareep_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Salut vous deux ![pause=0]J'espère que votre première journée a été géniale !", "Happy")
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_140'], CharacterEssentials.GetCharacterName("Cranidos")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_141']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Cranidos_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Que voulez-vous maintenant, vous deux novices ?[pause=0]Un Pokémon ne peut-il pas se détendre après une longue journée de travail ?", "Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_142']))
	GeneralFunctions.EndConversation(chara)
end




--npcs that only appear on day 2
function metano_town_ch_2.Quagsire_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "My husband has been throwing lots of "  .. STRINGS:Format("\\uE024") .. " into this well thinking it would actually grant him wishes.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_143'], STRINGS:Format("\\uE024")))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_144']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Sentret_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Je ne sais pas où se trouve " .. CharacterEssentials.GetCharacterName("Numel") .. "...[pause=0]Je suppose que nous devrons jouer sans lui aujourd'hui.", "Worried", false)
	GeneralFunctions.EndConversation(chara)
end



function metano_town_ch_2.Medicham_Linoone_Conversation(chara, activator)
	local linoone = CH('Linoone')
	local medicham = CH('Medicham')

	UI:SetSpeaker(medicham)
	GROUND:CharSetAnim(medicham, 'None', true)
	GROUND:CharSetAnim(linoone, 'None', true)
	--How's the book I suggested to you?
	GeneralFunctions.StartConversation(chara, "Livre que je vous ai proposé, comment ça va ?", "Normal", false, true, false)

	GAME:WaitFrames(20)
	UI:SetSpeaker(linoone)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_145']))
	GROUND:CharSetEmote(linoone, "sweating", 1)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_146']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(medicham)
	GeneralFunctions.SetEmotion("Worried")
	--It's been harder for me too lately. It'll be even harder now with Nubbor's disappearance weighing on my being...
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_147'], CharacterEssentials.GetCharacterName("Numel")))
	GeneralFunctions.EndConversation(chara)

	GROUND:CharEndAnim(linoone)
	GROUND:CharEndAnim(medicham)

end

function metano_town_ch_2.Medicham_Action(chara, activator)
	metano_town_ch_2.Medicham_Linoone_Conversation(chara, activator)
end

function metano_town_ch_2.Linoone_Action(chara, activator)
	metano_town_ch_2.Medicham_Linoone_Conversation(chara, activator)
end

function metano_town_ch_2.Manectric_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Le petit " .. CharacterEssentials.GetCharacterName("Numel") .. " a disparu...[pause=0]Je n'arrive pas à imaginer ce que vit sa mère.", "Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_148'], CharacterEssentials.GetCharacterName("Electrike")))
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_2.Vileplume_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Numel") .. " has disappeared...[pause=0] Poor kid.", "Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_149']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Marill_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Nous aiderions à retrouver l'enfant disparu...[pause=0]Mais malheureusement, nous avons d'autres tâches à accomplir.", "Worried")
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_150']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Spheal_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "J'espère que cet enfant disparu a pris un gros repas avant de disparaître...", "Worried")
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_151']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Jigglypuff_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Un autre Pokémon disparu...[pause=0]Il y a eu davantage de tâches de ce genre ces derniers temps.", "Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT2_152']))
	GeneralFunctions.EndConversation(chara)
end

