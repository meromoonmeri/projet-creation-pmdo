require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

ledian_dojo_ch_2 = {}

--NOTE: Gible and Ledian appear on the map without needing to be spawned in.
function ledian_dojo_ch_2.SetupGround()

end


--nothing to put here
function ledian_dojo_ch_2.Sensei_Action(chara, activator)

end

function ledian_dojo_ch_2.Gible_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Isn't Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " amazing?")
	GeneralFunctions.EndConversation(chara)
end


function ledian_dojo_ch_2.PreTrainingCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local gible = CH('Gible')
	local ledian = CH('Sensei')
	GROUND:Hide('Dungeon_Entrance')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(204, 120, 1, false)
	GROUND:TeleportTo(ledian, 196, 340, Direction.Down)
	GROUND:TeleportTo(gible, 264, 172, Direction.DownLeft)
	local lesson = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("beginner_lesson")
	local maze = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("normal_maze")
	GAME:FadeIn(20)

	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												  GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2})


	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_002']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_004']))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(20)

	GeneralFunctions.LookAround(partner, 2, 4, false, false, true, Direction.DownRight)
	--GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Notice", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_005']))
	GAME:WaitFrames(8)

	GROUND:CharAnimateTurnTo(hero, Direction.DownRight, 4)
	GeneralFunctions.EmoteAndPause(gible, "Exclaim", true)
	GAME:WaitFrames(30)
	GROUND:CharAnimateTurnTo(gible, Direction.Left, 4)
	GROUND:MoveToPosition(gible, 208, 172, false, 1)
	GROUND:EntTurn(partner, Direction.Down)
	GROUND:EntTurn(hero, Direction.Down)
	GROUND:MoveToPosition(gible, 196, 160, false, 1)
	GROUND:CharAnimateTurnTo(gible, Direction.Up, 4)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, gible.CurrentForm.Species, gible.CurrentForm.Form, gible.CurrentForm.Skin, gible.CurrentForm.Gender)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_006']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_007'], ledian:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_008']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, gible.CurrentForm.Species, gible.CurrentForm.Form, gible.CurrentForm.Skin, gible.CurrentForm.Gender)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_009'], ledian:GetDisplayName()))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(gible, Direction.Down, 4)
												  GROUND:MoveToPosition(gible, 196, 208, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(26)
												  GROUND:MoveToPosition(partner, 184, 184, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(36)
												  GROUND:MoveToPosition(hero, 208, 184, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
												  GAME:MoveCamera(204, 192, 72, false) end)


	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})


	GROUND:CharSetEmote(gible, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_010'], ledian:GetDisplayName()))
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(gible, "", 0)
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(ledian, 196, 240, false, 1)

	GAME:WaitFrames(90)

	UI:SetSpeaker(ledian)
	GeneralFunctions.SetEmotion("Shouting")
	--GROUND:CharAnimateTurnTo(ledian, Direction.Up, 4)

	coro1 = TASK:BranchCoroutine(function()	ledian_dojo_ch_2.Hwacha(ledian) end)
	coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("HWACHA!", 40) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.Recoil(partner, nil, nil, nil, nil, false) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetEmote(hero, "exclaim", 1) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(40)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_011'], gible:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(gible)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_012']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(ledian)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_013']))

	GAME:WaitFrames(20)


	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(gible, Direction.Right, 4)
											GROUND:MoveToPosition(gible, 256, 208, false, 1)
											GROUND:CharAnimateTurnTo(gible, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:MoveToPosition(ledian, 196, 208, false, 1) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_014']))
	GAME:WaitFrames(20)

	--Ledian inspects the duo
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(ledian, "Walk", Direction.Up, 176, 208, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.UpRight, 160, 192, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.Right, 160, 184, 1, 1, 0) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(hero, ledian, 4, Direction.Left) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(partner, ledian, 4, Direction.Left) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(60)

	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(ledian, "Walk", Direction.Right, 160, 184, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.UpRight, 176, 208, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.Up, 216, 208, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.UpLeft, 232, 192, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.Left, 232, 184, 1, 1, 0) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, ledian, 4, Direction.Right) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, ledian, 4, Direction.Right) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(gible, ledian, 4, Direction.UpLeft) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(60)

	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(ledian, "Walk", Direction.Left, 232, 176, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.DownLeft, 216, 160, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.Down, 196, 160, 1, 1, 0)
											GROUND:CharEndAnim(ledian) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, ledian, 4, Direction.Up) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, ledian, 4, Direction.Up)
											GROUND:EntTurn(partner, Direction.Up) end)
	coro4 = TASK:BranchCoroutine(function() GAME:MoveCamera(204, 168, 24, false) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(40)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweating", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(hero, "Sweating", false) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Shouting")

	coro1 = TASK:BranchCoroutine(function()	ledian_dojo_ch_2.Hwacha(ledian) end)
	coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("HWACHA!", 40) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.Recoil(partner, nil, nil, nil, nil, false) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetEmote(hero, "exclaim", 1) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(60)

	--they're a bit unnerved by Ledian
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_015']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_016'], ledian:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_017'], CharacterEssentials.GetCharacterName("Noctowl")))

	GAME:WaitFrames(20)
	UI:SetSpeaker(ledian)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_018'], lesson:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_019']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_020'], maze:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_021']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_022']))

	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:BeginChoiceMenu("Selon vous, lequel devrions-nous faire ?[pause=10]" .. hero:GetDisplayName() .. " ?", {lesson:GetColoredName() .. " (tutorial)", maze:GetColoredName() .. " (skip tutorial)"}, 1, 2)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	GAME:WaitFrames(20)

	if result == 2 then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_023'], maze:GetColoredName()))
		GAME:WaitFrames(20)

		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
		UI:SetSpeaker(ledian)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_024']))
		UI:BeginChoiceMenu("Etes-vous sûr de ne pas vouloir passer le " .. lesson:GetColoredName() .. " ?[pause=0]Il a beaucoup à apprendre !", {lesson:GetColoredName() .. " (tutorial)", maze:GetColoredName() .. " (skip tutorial)"}, 1, 2)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		GAME:WaitFrames(20)

	end

	if result == 1 then
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_025'], lesson:GetColoredName()))
		GAME:WaitFrames(20)
	end


	UI:SetSpeaker(ledian)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_026']))
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_027']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_028'], partner:GetDisplayName(), hero:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(ledian)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_029']))
	GAME:WaitFrames(20)

	if result == 1 then
		GROUND:CharTurnToCharAnimated(ledian, hero, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_030'], hero:GetDisplayName()))

		GAME:WaitFrames(12)
		GROUND:CharTurnToCharAnimated(ledian, partner, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_031'], partner:GetDisplayName(), gible:GetDisplayName()))

		GAME:WaitFrames(20)
		UI:SetSpeaker(gible)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_032']), {function() return GeneralFunctions.Hop(gible) end})

		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_033']))

		GAME:WaitFrames(16)
		GROUND:CharAnimateTurnTo(ledian, Direction.Down, 4)
		UI:SetSpeaker(ledian)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_034']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_035']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_036']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_037']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_038']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_039']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_040']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_041'], CharacterEssentials.GetCharacterName('Kangaskhan'), CharacterEssentials.GetCharacterName('Murkrow')))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_042']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_043']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_044']))

		GAME:WaitFrames(40)

		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
												GROUND:AnimateInDirection(hero, "Walk", Direction.Left, Direction.Right, 8, 1, 1)
												GAME:WaitFrames(22)
												GeneralFunctions.FaceMovingCharacter(hero, ledian, 4, Direction.Down)
												GAME:WaitFrames(10)
												GROUND:MoveInDirection(hero, Direction.Down, 136, false, 1) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
												GROUND:AnimateInDirection(partner, "Walk", Direction.Right, Direction.Left, 8, 1, 1)
												GAME:WaitFrames(22)
												GeneralFunctions.FaceMovingCharacter(partner, ledian, 4, Direction.Down)
												GAME:WaitFrames(10)
												GROUND:MoveInDirection(partner, Direction.Down, 136, false, 1) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												GROUND:MoveInDirection(ledian, Direction.Down, 196, false, 1) end)
		coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												GeneralFunctions.FaceMovingCharacter(gible, ledian, 4, Direction.Left)
												GAME:WaitFrames(10)
												GROUND:MoveToPosition(gible, 224, 240, false, 1)
												GROUND:MoveInDirection(gible, Direction.Down, 120, false, 1) end)
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(136) SOUND:FadeOutBGM() GAME:FadeOut(false, 40) end)


		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

		SV.Chapter2.StartedTraining = true
		GeneralFunctions.SendInvToStorage()--clear inventory
		GAME:CutsceneMode(false)
		GAME:UnlockDungeon("beginner_lesson")
		GAME:EnterDungeon("beginner_lesson", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.None, true, false)
	end

	if result == 2 then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_045'], maze:GetColoredName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_046']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_047']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_048'], CharacterEssentials.GetCharacterName('Kangaskhan'), CharacterEssentials.GetCharacterName('Murkrow')))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_049']))

		GAME:WaitFrames(40)

		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
												GROUND:AnimateInDirection(hero, "Walk", Direction.Left, Direction.Right, 8, 1, 1)
												GAME:WaitFrames(20)
												GeneralFunctions.FaceMovingCharacter(hero, ledian, 4, Direction.Down)
												GAME:WaitFrames(10)
												GROUND:MoveInDirection(hero, Direction.Down, 136, false, 1) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
												GROUND:AnimateInDirection(partner, "Walk", Direction.Right, Direction.Left, 8, 1, 1)
												GAME:WaitFrames(20)
												GeneralFunctions.FaceMovingCharacter(partner, ledian, 4, Direction.Down)
												GAME:WaitFrames(10)
												GROUND:MoveInDirection(partner, Direction.Down, 136, false, 1) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												GROUND:MoveInDirection(ledian, Direction.Down, 196, false, 1) end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(120) SOUND:FadeOutBGM() GAME:FadeOut(false, 40) end)


		TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

		SV.Chapter2.StartedTraining = true
		SV.Chapter2.SkippedTutorial = true
		GeneralFunctions.SendInvToStorage()--clear inventory
		GAME:CutsceneMode(false)
		GAME:UnlockDungeon("normal_maze")
		GAME:EnterDungeon("normal_maze", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	end
end

--used for Ledian's HWACHA! - similar to Yoomtah!
function ledian_dojo_ch_2.Hwacha(chara)
	--setup flashes
	local emitter = RogueEssence.Content.FlashEmitter()
	emitter.FadeInTime = 2
	emitter.HoldTime = 4
	emitter.FadeOutTime = 2
	emitter.StartColor = Color(0, 0, 0, 0)
	emitter.Layer = DrawLayer.Top
	emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
	GROUND:CharSetAnim(chara, "Hop", true)
	GROUND:PlayVFX(emitter, chara.Position.X, chara.Position.Y)
	SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(14)
	GROUND:PlayVFX(emitter, chara.Position.X, chara.Position.Y)
	SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(10)
	GROUND:CharEndAnim(chara)
end

--cutscene that plays if you fail the training maze or tutorial before finishing it for the first time
function ledian_dojo_ch_2.FailedTrainingCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local gible = CH('Gible')
	local ledian = CH('Sensei')
	GROUND:Hide('Dungeon_Entrance')
	GAME:CutsceneMode(true)
	GAME:MoveCamera(204, 184, 1, false)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	if SV.Chapter2.SkippedTutorial then
		GROUND:TeleportTo(ledian, 196, 176, Direction.Down)
		GROUND:TeleportTo(hero, 208, 200, Direction.Up)
		GROUND:TeleportTo(partner, 184, 200, Direction.Up)
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("normal_maze")
		GAME:FadeIn(40)

		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Pain")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_050']))

		GAME:WaitFrames(20)
		UI:SetSpeaker(ledian)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_051']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_052']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_053']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_054']))

		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)

		GAME:WaitFrames(20)
		local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Nod') end)
		local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
		TASK:JoinCoroutines({coro1, coro2})

		GAME:WaitFrames(20)
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
							GROUND:MoveInDirection(hero, Direction.Down, 120, false, 1) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
							GROUND:MoveInDirection(partner, Direction.Down, 120, false, 1) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})

		GAME:CutsceneMode(false)
		GAME:EnterDungeon("normal_maze", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	else
		GROUND:TeleportTo(ledian, 196, 176, Direction.Down)
		GROUND:TeleportTo(hero, 196, 200, Direction.Up)
		GROUND:Hide('Teammate1')
		GROUND:Hide('Gible')
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("beginner_lesson")
		GAME:FadeIn(40)

		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(hero, 'Sweating', true)
		GAME:WaitFrames(20)
		GeneralFunctions.HeroDialogue(hero, "(Urf...[pause=0]C'est difficile...)", "Pain")
		GAME:WaitFrames(20)

		UI:SetSpeaker(ledian)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_055']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_056']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_057']))


		GAME:WaitFrames(20)
		local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
							GROUND:MoveInDirection(hero, Direction.Down, 120, false, 1) end)
		local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
							GROUND:MoveInDirection(ledian, Direction.Down, 120, false, 1) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})

		GAME:CutsceneMode(false)
		GAME:EnterDungeon("beginner_lesson", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.None, true, false)
	end
end



--cutscene that plays after finishing training maze or tutorial for first time.
function ledian_dojo_ch_2.PostTrainingCutscene()

	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local gible = CH('Gible')
	local ledian = CH('Sensei')
	GROUND:Hide('Dungeon_Entrance')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(204, 184, 1, false)
	if SV.Chapter2.SkippedTutorial then
		GROUND:TeleportTo(ledian, 196, 176, Direction.Down)
		GROUND:TeleportTo(hero, 208, 200, Direction.Up)
		GROUND:TeleportTo(partner, 184, 200, Direction.Up)
		GROUND:EntTurn(gible, Direction.UpLeft)
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("normal_maze")
		GAME:FadeIn(40)

		GAME:WaitFrames(40)
		GeneralFunctions.EmoteAndPause(ledian, 'Exclaim', true)
		UI:SetSpeaker(ledian)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_058'], zone:GetColoredName()))

		GAME:WaitFrames(20)
		GeneralFunctions.SetEmotion("Shouting")
		local coro1 = TASK:BranchCoroutine(function() ledian_dojo_ch_2.Hwacha(ledian) end)
		local coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("HWACHA!", 40) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
										GROUND:CharSetEmote(hero, "exclaim", 1) end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
													  GeneralFunctions.Recoil(partner, nil, nil, nil, nil, false)end)
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Joyous")
		GeneralFunctions.Hop(partner)
		GeneralFunctions.Hop(partner)
		GROUND:CharSetEmote(partner, "glowing", 0)
		GROUND:CharSetAnim(partner, "Idle", true)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_059'], hero:GetDisplayName()))

		GAME:WaitFrames(20)
		UI:SetSpeaker(ledian)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_060'], zone:GetColoredName()))

		GROUND:CharEndAnim(partner)
		GROUND:CharSetEmote(partner, "", 0)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)

		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_061']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_062']))
		--Training mazes and more advanced lessons will unlock with certain rank thresholds. Some may be unlocked as you progress in the game anyway. Still figuring this out.
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_063']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_064']))

		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_065'], ledian:GetDisplayName()))

		GAME:WaitFrames(20)
		UI:SetSpeaker(ledian)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_066']))

		GAME:WaitFrames(20)
		GeneralFunctions.PanCamera()

		GAME:UnlockDungeon("beginner_lesson")--unlock the basic lesson
		GROUND:Unhide("Dungeon_Entrance")
		SV.Chapter2.FinishedDojoCutscenes = true
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
		GAME:CutsceneMode(false)
	else
		GROUND:TeleportTo(ledian, 196, 176, Direction.Down)
		GROUND:TeleportTo(hero, 196, 200, Direction.Up)
		GROUND:TeleportTo(partner, 184, 320, Direction.Up)
		GROUND:TeleportTo(gible, 208, 320, Direction.Up)
		GeneralFunctions.CenterCamera({ledian, hero})
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("beginner_lesson")
		GAME:FadeIn(40)

		GAME:WaitFrames(40)
		GeneralFunctions.EmoteAndPause(ledian, 'Exclaim', true)
		UI:SetSpeaker(ledian)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_067'], zone:GetColoredName()))

		GAME:WaitFrames(20)
		GeneralFunctions.SetEmotion("Shouting")
		local coro1 = TASK:BranchCoroutine(function() ledian_dojo_ch_2.Hwacha(ledian) end)
		local coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("HWACHA!", 40) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
													  GROUND:CharSetEmote(hero, "exclaim", 1) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})

		GAME:WaitFrames(40)
		GeneralFunctions.EmoteAndPause(ledian, "Notice", true)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_068'], zone:GetColoredName()))


		coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												GROUND:MoveToPosition(partner, 184, 280, false, 1)
												GeneralFunctions.EmoteAndPause(partner, "Exclaim", false)
												GROUND:MoveToPosition(partner, 184, 224, false, 1)
												GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(gible, 208, 224, false, 1) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
												GeneralFunctions.EmoteAndPause(hero, "Exclaim", true) end)

		TASK:JoinCoroutines({coro1, coro2, coro3})

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Inspired")
		GROUND:CharTurnToChar(hero, partner)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_069'], hero:GetDisplayName(), zone:GetColoredName()))
		GeneralFunctions.Hop(partner)
		GeneralFunctions.Hop(partner)
		GeneralFunctions.SetEmotion("Joyous")
		GROUND:CharSetEmote(partner, "glowing", 0)
		GROUND:CharSetAnim(partner, "Idle", true)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_070']))

		GAME:WaitFrames(20)
		UI:SetSpeaker(ledian)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_071'], zone:GetColoredName()))

		GROUND:CharEndAnim(partner)
		GROUND:CharSetEmote(partner, "", 0)
		GROUND:CharTurnToCharAnimated(partner, ledian, 4)
		GROUND:CharTurnToCharAnimated(hero, ledian, 4)

		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_072']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_073']))
		--Training mazes and more advanced lessons will unlock with certain rank thresholds. Some may be unlocked as you progress in the game anyway. Still figuring this out.
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_074']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_075']))

		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_076'], ledian:GetDisplayName()))

		GAME:WaitFrames(20)
		UI:SetSpeaker(ledian)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD2_077']))

		GAME:WaitFrames(20)
		GeneralFunctions.PanCamera()

		GAME:UnlockDungeon("normal_maze")--unlock the first training maze
		GROUND:Unhide("Dungeon_Entrance")
		SV.Chapter2.FinishedDojoCutscenes = true
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
		GAME:CutsceneMode(false)


	end


end
