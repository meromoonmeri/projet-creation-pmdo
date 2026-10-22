require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_second_floor_ch_2 = {}



function guild_second_floor_ch_2.SetupGround()

	if not SV.Chapter2.FinishedTraining then
		--day 1: before training

		local zangoose, seviper =
			CharacterEssentials.MakeCharactersFromList({
				{'Zangoose', 'Right_Duo_1'},
				{'Seviper', 'Right_Duo_2'},
				{'Zigzagoon', 'Left_Solo'}
			})

		GROUND:CharSetAnim(zangoose, 'Idle', true)
		GROUND:CharSetAnim(seviper, 'Idle', true)


		AI:SetCharacterAI(zangoose, "halcyon.ai.ground_talking", false, 240, 60, 210, false, 'Angry', {seviper})
		AI:SetCharacterAI(seviper, "halcyon.ai.ground_talking", false, 240, 180, 110, false, 'Angry', {zangoose})

	elseif SV.Chapter2.FinishedNumelTantrum and not SV.Chapter2.FinishedFirstDay then
		--day 1: after training
		local bagon, doduo, audino =
			CharacterEssentials.MakeCharactersFromList({
				{'Doduo', 'Left_Duo_1'},
				{'Bagon', 'Left_Duo_2'},
				{'Audino', 'Generic_Spawn_6'}
			})

		AI:SetCharacterAI(bagon, "halcyon.ai.ground_talking", false, 240, 60, 210, true, 'Default', {doduo})
		AI:SetCharacterAI(doduo, "halcyon.ai.ground_talking", false, 240, 180, 110, true, 'Default', {bagon})

		AI:SetCharacterAI(audino, "origin.ai.ground_default", RogueElements.Loc(432, 288), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	elseif SV.Chapter2.FinishedFirstDay then
	--day 2 after getting the first job but before wiping in the dungeon

		local cleffa, aggron =
			CharacterEssentials.MakeCharactersFromList({
				{'Cleffa', 'Right_Duo_1'},
				{'Aggron', 'Right_Duo_2'}
			})

		AI:SetCharacterAI(cleffa, "halcyon.ai.ground_talking", true, 240, 60, 210, false, 'Angry', {aggron})
		AI:SetCharacterAI(aggron, "halcyon.ai.ground_talking", false, 240, 120, 110, false, 'Scared', {cleffa})

	--(noctowl and camerupt would be moved to upstairs and her house respectively if you wipe)
		if SV.Chapter2.FinishedCameruptRequestScene and not SV.Chapter2.EnteredRiver then
			local noctowl, camerupt =
			CharacterEssentials.MakeCharactersFromList({
				{'Noctowl', 80, 224, Direction.Down},
				{'Camerupt', 112, 224, Direction.Down}
			})
		end


	end

	GAME:FadeIn(20)

end

function guild_second_floor_ch_2.CameruptRequestCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")

	GAME:MoveCamera(160, 224, 1, false)

	local noctowl, cleffa, aggron =
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 340, 280, Direction.Left},
			{'Cleffa', 'Right_Duo_1'},
			{'Aggron', 'Right_Duo_2'}
		})

	--set up cleffa and aggron like we do in setup ground so that they act properly after the cutscene and without leaving and coming back to refresh the
	AI:SetCharacterAI(cleffa, "halcyon.ai.ground_talking", true, 240, 60, 210, false, 'Angry', {aggron})
	AI:SetCharacterAI(aggron, "halcyon.ai.ground_talking", false, 240, 120, 110, false, 'Scared', {cleffa})

	GROUND:TeleportTo(partner, 340, 280, Direction.Left)
	GROUND:TeleportTo(hero, 340, 280, Direction.Left)
	SOUND:StopBGM()

	GAME:FadeIn(40)
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 192, 280, false, 1)
												  GROUND:MoveToPosition(noctowl, 136, 224, false, 1)
												  GROUND:MoveToPosition(noctowl, 80, 224, false, 1)
												  GeneralFunctions.FaceMovingCharacter(noctowl, partner, 4, Direction.Down) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
												  GROUND:MoveToPosition(partner, 152, 280, false, 1)
												  GROUND:MoveToPosition(partner, 128, 256, false, 1)
												  GROUND:MoveToPosition(partner, 88, 256, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(64)
												  GROUND:MoveToPosition(hero, 152, 280, false, 1)
												  GROUND:MoveToPosition(hero, 128, 256, false, 1)
												  GROUND:MoveToPosition(hero, 120, 256, false, 1)
  												  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(236)
												  GAME:MoveCamera(112, 224, 48, false) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	--local scarf_name = RogueEssence.Dungeon.InvItem("held_synergy_scarf"):GetDisplayName()
	--have to hardcode this so I can have it say scarves instead of scarf
	local scarf_name = STRINGS:Format('\\uE0AE')..'[color=#FFCEFF]Synergy Scarves[color]'

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_004']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_005']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_007']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_009'], scarf_name))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_011']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_012']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_013']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_014']))

	GAME:WaitFrames(20)

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_015']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_016']))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4)
	GROUND:CharSetAnim(noctowl, "Idle", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_017']))

	--camerupt comes in in a panic
	GAME:WaitFrames(40)
	SOUND:FadeOutBGM(120)
	local camerupt =
		CharacterEssentials.MakeCharactersFromList({
			{'Camerupt', 248, 208, Direction.Down}
		})

	GAME:WaitFrames(40)
	GeneralFunctions.LookAround(camerupt, 3, 4, false, false, true, Direction.DownLeft)
	GeneralFunctions.EmoteAndPause(camerupt, "Exclaim", true)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(camerupt, 112, 224, true, 2) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
											--SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
											GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
											GROUND:CharSetEmote(partner, "exclaim", 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
											GROUND:CharSetEmote(hero, "exclaim", 1) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GROUND:EntTurn(hero, Direction.Up)
	GROUND:EntTurn(partner, Direction.Up)

	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_018'], noctowl:GetDisplayName()))

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(noctowl, "Notice", true)
	GROUND:CharEndAnim(noctowl)
	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	GROUND:CharTurnToCharAnimated(noctowl, camerupt, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_019']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_020'], noctowl:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_021'], CharacterEssentials.GetCharacterName("Numel")))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(noctowl, "exclaim", 1)
	GROUND:CharSetEmote(partner, "shock", 1)
	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	GAME:WaitFrames(6)
	GROUND:CharSetEmote(hero, "shock", 1)
	GAME:WaitFrames(20)

	SOUND:PlayBGM('Growing Anxiety.ogg', false)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_022']))

	GAME:WaitFrames(10)
	GeneralFunctions.Hop(camerupt)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_024']))
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_025']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_026']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_027']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_028']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_029']))

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(C'est la mère qui se disputait avec son fils en ville hier.[pause=0]Il a semblé assez bouleversé après...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(And now he's gone missing...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(.........)", "Worried")

	GAME:WaitFrames(40)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim_Idea')
	GeneralFunctions.EmoteAndPause(hero, 'Exclaim', false)

	GeneralFunctions.HeroDialogue(hero, "(Attendez ![pause=0]C'est tout !)", "Surprised")
	GeneralFunctions.HeroDialogue(hero, "(Leur combat doit être la cause de sa disparition !)", "Surprised")

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(hero, camerupt, 4)
	GAME:WaitFrames(10)
	GeneralFunctions.HeroSpeak(hero, 60)

	GAME:WaitFrames(20)

	--SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
	coro1 = TASK:BranchCoroutine(function() --GROUND:CharSetEmote(camerupt, "exclaim", 1)
											GROUND:CharTurnToCharAnimated(camerupt, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() --GROUND:CharSetEmote(noctowl, "notice", 1)
											GROUND:CharTurnToCharAnimated(noctowl, hero, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											--GROUND:CharSetEmote(partner, "exclaim", 1)
											GROUND:CharTurnToCharAnimated(partner, hero, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_030']))

	GAME:WaitFrames(40)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_031']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_032']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(noctowl, camerupt, 4)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_033']))

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(camerupt, noctowl, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)

	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_034']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_035']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_036']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_037']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_038']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_039']))
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_040'], CharacterEssentials.GetCharacterName('Numel')))

	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_041']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_042']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_043']))

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(camerupt, "Exclaim", true)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_044']))

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, 'Question', true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_045']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(noctowl, partner, 4)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_046']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_047']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_048'], CharacterEssentials.GetCharacterName('Numel')))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_049']))

	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_050'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_051']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(camerupt, 'Shock', true)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion('Surprised')
	GeneralFunctions.Hop(camerupt)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_052']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(noctowl)
	GROUND:CharTurnToCharAnimated(noctowl, camerupt, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_053']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_054']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_055']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_056'], CharacterEssentials.GetCharacterName("Numel")))


	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(camerupt, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(noctowl, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharTurnToCharAnimated(hero, partner, 4) end)


	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_057']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_058'], CharacterEssentials.GetCharacterName("Numel")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_059']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_060'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_061'], hero:GetDisplayName()))

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_062'], hero:GetDisplayName()))

	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
	GROUND:CharTurnToCharAnimated(hero, camerupt, 4)

	GAME:WaitFrames(10)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_063'], CharacterEssentials.GetCharacterName('Numel')))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(noctowl, camerupt, 8)
	GAME:WaitFrames(60)
	GROUND:CharTurnToCharAnimated(noctowl, partner, 8)
	GAME:WaitFrames(60)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_064']))

	GAME:WaitFrames(20)
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", false)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_065']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_066']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_067']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_068'], zone:GetColoredName(), CharacterEssentials.GetCharacterName('Numel')))

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	GROUND:CharAnimateTurnTo(camerupt, Direction.Down, 4)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_069']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_070']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_071']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_072'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_073'], CharacterEssentials.GetCharacterName("Numel")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_074']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_075']))

	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_076'], hero:GetDisplayName(), CharacterEssentials.GetCharacterName("Numel")))


	GAME:WaitFrames(20)
	GROUND:CharEndAnim(hero)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GeneralFunctions.PanCamera()
	SV.Chapter2.FinishedCameruptRequestScene = true
	GAME:CutsceneMode(false)




end



function guild_second_floor_ch_2.RescuedNumelCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")

	GAME:MoveCamera(112, 224, 1, false)

	local noctowl, numel, camerupt =
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 152, 248, Direction.UpLeft},
			{'Numel', 88, 224, Direction.Right},
			{'Camerupt', 120, 224, Direction.Left}
		})

	GROUND:TeleportTo(partner, 88, 256, Direction.Up)
	GROUND:TeleportTo(hero, 120, 256, Direction.Up)
	GAME:FadeIn(40)
	SOUND:PlayBGM("Job Clear!.ogg", true)

	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_077'], numel:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_078']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_079']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_080']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_081']))
	--UI:WaitShowDialogue("That's a lot of stress to put on you.[pause=0] But I only do it because I have to.")
	--too long with no nicknames
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_082']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_083']))

	GAME:WaitFrames(60)
	GROUND:CharAnimateTurnTo(camerupt, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(numel, Direction.Down, 4)
	GROUND:CharTurnToChar(partner, camerupt)
	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_084']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_085']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_086']))

	GAME:WaitFrames(20)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(camerupt, 120, 240, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, camerupt, 4, Direction.UpRight) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)


	GeneralFunctions.RewardItem(GeneralFunctions.GetFavoriteGummi(hero))
	GeneralFunctions.RewardItem(GeneralFunctions.GetFavoriteGummi(partner))
	GeneralFunctions.RewardItem(350, true)

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_087']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(camerupt, partner, 4)
	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_088']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_089']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_090']))
	GAME:WaitFrames(30)
	GROUND:CharAnimateTurnTo(camerupt, Direction.Down, 4)
	GROUND:AnimateToPosition(camerupt, "Walk", Direction.Down, 120, 224, 1, 1, 0)
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(camerupt, numel, 4)
	GROUND:CharTurnToCharAnimated(numel, camerupt, 4)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_091']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(numel, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_092']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(numel, "", 0)


	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(camerupt, Direction.Right, 4)
											GROUND:MoveToPosition(camerupt, 232, 224, false, 1)
											GROUND:MoveToPosition(camerupt, 280, 172, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(camerupt) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveToPosition(numel, 232, 224, false, 1)
											GROUND:MoveToPosition(numel, 280, 172, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(numel) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.FaceMovingCharacter(hero, camerupt, 4, Direction.UpRight) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.FaceMovingCharacter(partner, camerupt, 4, Direction.UpRight) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.FaceMovingCharacter(noctowl, camerupt, 4, Direction.UpRight) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Joyous")

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4)
											GeneralFunctions.DoubleHop(partner)
											GROUND:CharSetEmote(partner, "glowing", 0)
											GROUND:CharSetAnim(partner, "Idle", true)
											UI:WaitShowTimedDialogue("Haha,[pause=10]nous l'avons vraiment fait,[pause=10]" .. hero:GetDisplayName() .. " !", 60) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharTurnToCharAnimated(hero, partner, 4)
											GROUND:CharSetAnim(hero, "Idle", true)
											GROUND:CharSetEmote(hero, "glowing", 0) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.UpLeft, 4)
											GeneralFunctions.EightWayMove(noctowl, 104, 224, false, 1)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_093'], GAME:GetTeamName()))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetEmote(hero, "", 0)

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_094'], numel:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_095']))
	--UI:WaitShowDialogue("Ah,[pause=10] the follies of youth...")

	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_096'], noctowl:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_097']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_098']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_099']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_100']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(noctowl)
	GeneralFunctions.EmoteAndPause(noctowl, "Question", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_101']))

	GAME:WaitFrames(10)
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.Recoil(partner) end)
	--coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Shock", false) end)
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweating", true) end)
	--coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Shock", false) end)

	--TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_102'], numel:GetDisplayName(), hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_103']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_104']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_105']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_106']))


	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_107']))

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je n'arrive toujours pas à me débarrasser de ce sentiment que quelque chose n'allait pas au printemps.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Mais " .. noctowl:GetDisplayName() .. " nous dit de ne pas nous en inquiéter,[pause=10]alors peut-être que ce n'est pas grave...)", "Worried")


	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_108']))

	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('DUN_Belly')
	GAME:WaitFrames(40)

	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Exclaim", true) end)

	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToChar(noctowl, hero)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(partner, "glowing", 0)
	SOUND:PlayBGM('Heartwarming.ogg', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_109'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_110'], hero:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)


	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
											GROUND:MoveToPosition(hero, 300, 256, false, 1)
											SOUND:FadeOutBGM(120) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveToPosition(partner, 300, 256, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.FaceMovingCharacter(noctowl, hero, 4, Direction.Right) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_111']))
	GAME:WaitFrames(60)


	GAME:FadeOut(false, 60)
	SV.TemporaryFlags.Dinnertime = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_dining_room", "Main_Entrance_Marker")
end

function guild_second_floor_ch_2.Zangoose_Action(chara, activator)
	guild_second_floor_ch_2.Seviper_Action(chara, activator)
end

function guild_second_floor_ch_2.Seviper_Action(chara, activator)
	local zangoose = CH('Zangoose')
	local seviper = CH('Seviper')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	--Set zangoose and seviper to interacting to pause their talking AI
	zangoose.IsInteracting = true
	seviper.IsInteracting = true
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(seviper, 'None', true)
	GROUND:CharSetAnim(zangoose, 'None', true)
	UI:SetSpeaker(seviper)
	GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_112']))
	TASK:JoinCoroutines({coro1})
	UI:WaitDialog()

	GAME:WaitFrames(20)
	UI:SetSpeaker(zangoose)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_113']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(seviper)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_114']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(zangoose, seviper, 4)
	UI:SetSpeaker(zangoose)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_115']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(seviper, zangoose, 4)
	UI:SetSpeaker(seviper)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_116']))

	GAME:WaitFrames(20)
	--GeneralFunctions.EmoteAndPause(zangoose, "Sweating", true)
	GROUND:CharAnimateTurnTo(zangoose, Direction.Up, 4)
	UI:SetSpeaker(zangoose)
	--GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_117']))

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(seviper, Direction.Up, 4)
	UI:SetSpeaker(seviper)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_118']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_119']))
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(seviper)
	GROUND:CharEndAnim(zangoose)
	zangoose.IsInteracting = false
	seviper.IsInteracting = false
	partner.IsInteracting = false
end

function guild_second_floor_ch_2.Zigzagoon_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local zigzagoon = CH('Zigzagoon')

	GeneralFunctions.StartConversation(zigzagoon, "Hey Team " .. GAME:GetTeamName() .. ",[pause=10] comment se passe votre première journée ?")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_120']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_121'], CharacterEssentials.GetCharacterName("Noctowl"), CharacterEssentials.GetCharacterName("Ledian")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_122']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_123']))
	--UI:WaitShowDialogue("I know that I learned a lot of stuff from her!")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Bagon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Nous sommes l'équipe[color=#FFA5FF]Flight[color]![pause=0]Nous sommes une équipe d'aventuriers qui aime le ciel !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_124'], CharacterEssentials.GetCharacterName('Doduo')))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_125']))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Doduo_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Nous sommes venus ici pour trouver du travail,[pause=10] mais nous sommes arrivés ici un peu plus tard que nous l'aurions souhaité.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_126']))
	GeneralFunctions.SetEmotion("Stunned")
	GROUND:CharSetEmote(chara, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_127'], CharacterEssentials.GetCharacterName("Bagon")))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Audino_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "H-hé vous deux ![pause=0]J'espère que votre premier jour s'est bien passé !", "Happy")
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_128']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_129']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_130']))
	GeneralFunctions.EndConversation(chara)

end

function guild_second_floor_ch_2.Noctowl_Action(chara, activator)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
	GeneralFunctions.StartConversation(chara, "Comme je l'ai dit plus tôt,[pause=10]" .. zone:GetColoredName() .. " est situé au nord de la ville.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_131'], CharacterEssentials.GetCharacterName("Numel")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_132']))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Camerupt_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "S'il vous plaît,[pause=10]trouvez mon petit garçon ![pause=0]Il représente tout pour moi !", 'Teary-Eyed')
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Cleffa_Aggron_Conversation(chara)
	local cleffa = CH('Cleffa')
	local aggron = CH('Aggron')

	UI:SetSpeaker(cleffa)
	GROUND:CharSetAnim(cleffa, 'None', true)
	GROUND:CharSetAnim(aggron, 'None', true)
	cleffa.IsInteracting = true
	aggron.IsInteracting = true
	GeneralFunctions.StartConversation(chara, "Nous avons besoin d'un hors-la-loi aux primes élevées pour compenser votre erreur de l'autre jour.[pause=0]Vous voyez quelque chose de décent ?", "Determined", false, true, false)
	SV.TemporaryFlags.OldDirection = Direction.None--hack to prevent target chara from turning back at the end of the conversation.
	GAME:WaitFrames(20)

	UI:SetSpeaker(aggron)
	GeneralFunctions.SetEmotion("Worried")
	GROUND:CharTurnToCharAnimated(aggron, cleffa, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_133']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cleffa, aggron, 4)
	UI:SetSpeaker(cleffa)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_134']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(aggron, "sweating", 1)
	UI:SetSpeaker(aggron)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F2_135']))
	GROUND:CharAnimateTurnTo(cleffa, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(aggron, Direction.Up, 4)
	GeneralFunctions.EndConversation(chara)
	GROUND:CharEndAnim(aggron)
	GROUND:CharEndAnim(cleffa)
	cleffa.IsInteracting = false
	aggron.IsInteracting = false
end

function guild_second_floor_ch_2.Cleffa_Action(chara, activator)
	guild_second_floor_ch_2.Cleffa_Aggron_Conversation(chara)
end

function guild_second_floor_ch_2.Aggron_Action(chara, activator)
	guild_second_floor_ch_2.Cleffa_Aggron_Conversation(chara)
end



return guild_second_floor_ch_2
