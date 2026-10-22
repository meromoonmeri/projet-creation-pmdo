require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_town_ch_3 = {}

function metano_town_ch_3.SetupGround()
	if SV.Chapter3.DefeatedBoss then
		--hide NPCs not in use for chapter 3 part 2
		GROUND:Hide('Swap_Owner')
		GROUND:Hide('Swap')

		local wooper_boy, wooper_girl, numel, nidoqueen, quagsire, zigzagoon, furret, sentret,
			  snubbull, mareep, cranidos, mawile, azumarill, electrike, meditite, machamp, medicham, linoone, manectric,
			  bellossom, floatzel, gloom, oddish =
			CharacterEssentials.MakeCharactersFromList({
				{'Wooper_Boy', 400, 880, Direction.Left},
				{'Wooper_Girl', 352, 952, Direction.DownRight},
				{'Numel', 192, 536, Direction.Left},
				{'Nidoqueen', 'Town_Seat_1'},
				{'Quagsire', 'Town_Seat_2'},
				{'Zigzagoon', 1232, 360, Direction.Up},
				{'Furret', 356, 764, Direction.Right},
				{'Sentret', 388, 716, Direction.Right},
				{'Snubbull', 1040, 864, Direction.UpRight},
				{'Mareep', 1120, 906, Direction.Right},
				{'Cranidos', 1160, 906, Direction.Left},
				{'Mawile', 1040, 1208, Direction.DownRight},
				{'Azumarill', 876, 1168, Direction.Up},
				{'Electrike', 400, 400, Direction.Right},
				{'Meditite', 440, 400, Direction.Left},
				{'Machamp', 760, 600, Direction.Down},
				{'Medicham', 536, 192, Direction.Down},
				{'Linoone', 891, 260, Direction.UpRight},
				{'Manectric', 1204, 1144, Direction.DownRight},
				{'Bellossom', 472, 608, Direction.UpLeft},
				{'Floatzel', 368, 1096, Direction.Up},
				{'Gloom', 'Cafe_Seat_4'},
				{'Oddish', 'Cafe_Seat_3'}
			})

		GROUND:CharSetAnim(furret, 'Sleep', true)
		GROUND:CharSetAnim(sentret, 'Sleep', true)

		AI:SetCharacterAI(wooper_girl, "halcyon.ai.ground_default", RogueElements.Loc(336, 936), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(zigzagoon, "halcyon.ai.ground_default", RogueElements.Loc(1216, 344), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(mawile, "halcyon.ai.ground_default", RogueElements.Loc(1024, 1192), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(machamp, "halcyon.ai.ground_default", RogueElements.Loc(744, 584), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(manectric, "halcyon.ai.ground_default", RogueElements.Loc(1176, 1112), RogueElements.Loc(64, 64), 1, 16, 32, 40, 180)


		--let the cutscene handle the fade in if it hasnt played yet
		if SV.Chapter3.FinishedMerchantIntro then
			GAME:FadeIn(20)
		end
	else

		--objects/npcs that aren't for use in chapter 3 part 1
		GROUND:Hide('Red_Merchant')
		GROUND:Hide('Green_Merchant')
		GROUND:Hide('Swap_Owner')
		GROUND:Hide('Swap')

		--trigger for partner pointing out cafe is open. only place if they havent done the cutscene for it yet
		if not SV.Chapter3.FinishedCafeCutscene then
			local cafeBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
																RogueElements.Rect(944, 584, 400, 160),
																RogueElements.Loc(0, 0),
																true,
																"Event_Trigger_1")

			cafeBlock:ReloadEvents()
			GAME:GetCurrentGround():AddTempObject(cafeBlock)
			--disable its collision so it doesn't displace other NPCs
			cafeBlock.Passable = true
		end



		local sentret, oddish, numel, camerupt, manectric, gloom, nidorina, mawile, furret, azumarill, nidoking, luxray,
			  linoone, electrike, wooper_girl, wooper_boy, audino, snubbull, meditite  =
			CharacterEssentials.MakeCharactersFromList({
				{'Sentret', 400, 424, Direction.DownRight},
				{'Oddish', 440, 424, Direction.DownLeft},
				{'Numel', 420, 456, Direction.Up},
				{'Camerupt', 'Town_Seat_1'},
				{'Manectric', 'Town_Seat_2'},
				{'Nidorina', 536, 208, Direction.UpLeft},
				{'Gloom', 512, 184, Direction.DownRight},
				{'Mawile', 1204, 1156, Direction.Down},
				{'Furret', 356, 764, Direction.Right},
				{'Azumarill', 888, 704, Direction.Down},
				{'Nidoking', 1160, 912, Direction.Left},
				{'Luxray', 624, 600, Direction.Down},
				{'Linoone', 'Cafe_Seat_2'},
				{'Electrike', 272, 1056, Direction.Right},
				{'Wooper_Girl', 306, 1036, Direction.DownLeft},
				{'Wooper_Boy', 306, 1076, Direction.UpLeft},
				{'Audino', 1264, 592, Direction.DownRight},
				{'Snubbull', 1040, 864, Direction.UpRight},
				{'Medicham', 888, 240, Direction.UpRight},
				{'Meditite', 520, 384, Direction.DownLeft}
			})


		GROUND:CharSetAnim(furret, 'Sleep', true)
		AI:SetCharacterAI(luxray, "halcyon.ai.ground_default", RogueElements.Loc(608, 584), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(mawile, "halcyon.ai.ground_default", RogueElements.Loc(1188, 1140), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(nidoking, "halcyon.ai.ground_default", RogueElements.Loc(1144, 896), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(audino, "halcyon.ai.ground_default", RogueElements.Loc(1248, 576), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)








		--let the cutscene handle the fade in if it hasnt played yet
		if SV.Chapter3.MetTeamStyle then
			GAME:FadeIn(20)
		end

	end

	--for debug purposes. makes it so the ground loads normally as long as i just set chapter to 3.
	if not SV.Chapter3.FinishedOutlawIntro then
		GAME:FadeIn(20)
	end

end


function metano_town_ch_3.Event_Trigger_1_Touch()
	metano_town_ch_3.CafeCutscene()
end


--partner points out that the cafe is open now
function metano_town_ch_3.CafeCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')

	--dummy is used to help coordinate character turning and camera movement. A bit of a hack tbh. It's crum because why not.
	local dummy = CharacterEssentials.MakeCharactersFromList({{'Tail'}})
	GROUND:TeleportTo(dummy, 1118, 576, Direction.Down)
	GROUND:Hide('Event_Trigger_1') --hide the trigger for the cutscene once it activates

	GeneralFunctions.StartPartnerConversation("Oh![pause=0] " .. hero:GetDisplayName() .. "![pause=0] Look!", "Normal", false)
	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dummy, 4)
												  GROUND:CharTurnToCharAnimated(hero, dummy, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({dummy}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 3) end)

	TASK:JoinCoroutines({coro1, coro2})

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_001']))
	GAME:WaitFrames(40)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({hero}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 3)
											GAME:MoveCamera(0, 0, 1, true) --return camera control
											end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4)
											GROUND:CharTurnToCharAnimated(hero, partner, 4) end)

	TASK:JoinCoroutines({coro1, coro2})
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_004']))

	SV.Chapter3.FinishedCafeCutscene = true
	GAME:GetCurrentGround():RemoveTempChar(dummy)
	GeneralFunctions.EndConversation(partner)
end


function metano_town_ch_3.MeetTeamStyle()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
	local luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({
		{"Luxio", 464, 1208, Direction.Right},
		{"Glameow", 432, 1224, Direction.Right},
		{"Cacnea", 432, 1192, Direction.Right}})

	GAME:MoveCamera(648, 1232, 1, false)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 624, 1064, Direction.Down)
	GROUND:TeleportTo(partner, 656, 1064, Direction.Down)

	GAME:FadeIn(40)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 656, 1248, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 624, 1248, false, 1)
												  GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)

	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_005'], hero:GetDisplayName(), CharacterEssentials.GetCharacterName("Sandile")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_006'], CharacterEssentials.GetCharacterName("Cranidos")))
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_007']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_008'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_009']))
	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharSetEmote(partner, "happy", 0)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_011'], CharacterEssentials.GetCharacterName("Cranidos")))
	GAME:WaitFrames(20)

	GeneralFunctions.DoAnimation(hero, "Nod")
	GeneralFunctions.DoAnimation(hero, "Nod")

	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_012']))

	GAME:WaitFrames(20)
	GROUND:CharEndAnim(partner)
	GROUND:CharSetEmote(partner, "", 0)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowTimedDialogue("Allez,[pause=10]" .. hero:GetDisplayName() .. "![pause=30]Allons au marché pour nous préparer à-", 40)
	GAME:WaitFrames(20)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)

	SOUND:FadeOutBGM(120)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Eh bien, bien, bien ![pause=30]Qu'avons-nous ici ?", 40) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GeneralFunctions.EmoteAndPause(partner, "Notice", false) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	SOUND:PlayBGM('Team Skull.ogg', true)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(luxio, 640, 1208, false, 1)
											GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveToPosition(glameow, 592, 1224, false, 1)
											GROUND:MoveToPosition(glameow, 616, 1200, false, 1)
											GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(cacnea, 656, 1192, false, 1)
											GROUND:MoveToPosition(cacnea, 664, 1200, false, 1)
											GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
												  GAME:WaitFrames(120)
												  GeneralFunctions.FaceMovingCharacter(partner, luxio, 4, Direction.Up) end)
	local coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4)
												  GAME:WaitFrames(120)
												  GeneralFunctions.FaceMovingCharacter(hero, luxio, 4, Direction.Up) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(20)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, glameow.CurrentForm.Species, glameow.CurrentForm.Form, glameow.CurrentForm.Skin, glameow.CurrentForm.Gender)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_013'], luxio:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_014'], glameow:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cacnea.CurrentForm.Species, cacnea.CurrentForm.Form, cacnea.CurrentForm.Skin, cacnea.CurrentForm.Gender)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_015']))

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxio, cacnea, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharTurnToCharAnimated(glameow, cacnea, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_016'], cacnea:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cacnea, luxio, 4)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_017']))

	GAME:WaitFrames(10)
	GeneralFunctions.Complain(luxio, true)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_018']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_019']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(luxio, "", 0)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxio, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(glameow, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(cacnea, partner, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(10)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_021']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_022']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cacnea, luxio, 4)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_023']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(glameow, luxio, 4)
	UI:SetSpeaker(glameow)
	GeneralFunctions.SetEmotion('Special1')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_024'], cacnea:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_025']))

	--emitter for sparkle effect on pose
	--each frame will last 3 frames
	local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Moonlight_Sparkles_2", 3))
	emitter.LocHeight = 14


	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4)
											SOUND:PlayBattleSE("_UNK_EVT_046")
											GROUND:PlayVFX(emitter, glameow.Position.X, glameow.Position.Y)
											GROUND:CharSetAction(glameow, RogueEssence.Ground.PoseGroundAction(glameow.Position, glameow.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 3)
											GROUND:CharAnimateTurnTo(cacnea, Direction.UpRight, 3)
											GROUND:CharAnimateTurnTo(cacnea, Direction.UpLeft, 3)
											GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 3)
											GeneralFunctions.Hop(cacnea)
											SOUND:PlayBattleSE("_UNK_EVT_014")
											GROUND:CharSetEmote(cacnea, "shock", 1)
											GROUND:AnimateInDirection(cacnea, "Hurt", Direction.Down, Direction.Down, 4, 1, 2)
											GROUND:CharSetAction(cacnea, RogueEssence.Ground.PoseGroundAction(cacnea.Position, cacnea.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Hurt")))
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:PlayVFX(emitter, luxio.Position.X, luxio.Position.Y)
											GROUND:CharSetAction(luxio, RogueEssence.Ground.PoseGroundAction(luxio.Position, luxio.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))  end)
	coro4 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_147'])) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	GeneralFunctions.SetEmotion("Special1")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_026']))

	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() SOUND:PlayBattleSE('EVT_Emote_Shock_2')
											GeneralFunctions.EmoteAndPause(partner, "Shock", false) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_027']))

	GAME:WaitFrames(20)
	GROUND:CharEndAnim(luxio)
	GROUND:CharEndAnim(glameow)
	GROUND:CharEndAnim(cacnea)
	--put cacnea back where he was before he slid on his face like an idiot
	GROUND:TeleportTo(cacnea, 664, 1200, Direction.Down)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_028']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_029']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_030']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_031'], CharacterEssentials.GetCharacterName("Tropius")))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_032']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_033']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	GROUND:CharSetEmote(hero, "exclaim", 1)
	GeneralFunctions.Complain(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_034']))


	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_035']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_036']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_037']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowTimedDialogue("Euh...[pause=30], je ne sais pas vraiment-", 40)

	GAME:WaitFrames(20)
	GROUND:MoveInDirection(luxio, Direction.Down, 8, false, 1)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Angry")
	GeneralFunctions.Complain(luxio, true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_038']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Shouting")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Je ne sais pas !!![pause=30]OK !?[pause=30]Je ne sais pas !", 60) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(luxio, "Exclaim", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharSetEmote(hero, "exclaim", 1) GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(25) GeneralFunctions.EmoteAndPause(glameow, "Notice", false) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(cacnea, "Exclaim", false) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(20)
	GROUND:AnimateInDirection(luxio, "Walk", Direction.Down, Direction.Up, 8, 1, 1)
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_039']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Determined")
	GeneralFunctions.DoubleHop(partner)
	--UI:WaitShowDialogue("But it doesn't matter why " .. CharacterEssentials.GetCharacterName("Tropius") .. " took us in!")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_040']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_041'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_042']))

	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(luxio, "Shock", false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(glameow, "Shock", false) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(cacnea, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Angry")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_148']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_149']))	end)
	TASK:JoinCoroutines({coro1, coro2})


	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_043']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_044']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(luxio, "Exclaim", true)
	UI:SetSpeaker(luxio)
	--GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_045']))


	GAME:WaitFrames(30)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharAnimateTurnTo(glameow, Direction.Right, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GROUND:CharAnimateTurnTo(cacnea, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	--GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_046']))
	GAME:WaitFrames(10)

	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(glameow, "Exclaim", false) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(cacnea, "Notice", false) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_047']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_048']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_049']))

	GAME:WaitFrames(30)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4) GAME:WaitFrames(20) GROUND:MoveInDirection(luxio, Direction.Down, 8, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_050']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_051']))

	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(luxio, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(glameow, Direction.DownRight, 4)
	GROUND:CharAnimateTurnTo(cacnea, Direction.DownLeft, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_052']))

	GAME:WaitFrames(20)

	--cacnea will later forget that this was just a temporary lie and think he's supposed to be nice to you still.
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Right, 4)
											GROUND:MoveInDirection(luxio, Direction.Right, 200, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(luxio) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveInDirection(glameow, Direction.Down, 16, false, 1)
											GROUND:CharTurnToChar(partner, glameow)
											GROUND:CharTurnToChar(hero, glameow)
											UI:SetSpeaker(glameow)
											UI:WaitShowTimedDialogue("Nous garderons un œil sur vous,[pause=10]mes chéris.[pause=30]J'espère que vous gardez également un œil sur nous.", 60)
											GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(glameow, Direction.Right, 4)
											GROUND:MoveInDirection(glameow, Direction.Right, 200, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(glameow) end)
	coro3 = TASK:BranchCoroutine(function()	GAME:WaitFrames(310)
											GROUND:MoveInDirection(cacnea, Direction.Down, 16, false, 1)
											GROUND:CharTurnToChar(partner, cacnea)
											GROUND:CharTurnToChar(hero, cacnea)
											UI:SetSpeaker(cacnea)
											GeneralFunctions.SetEmotion("Happy")
											UI:WaitShowTimedDialogue("Duh...[pause=30]Si le patron dit que ton équipe va bien,[pause=10]alors tu es bien avec moi aussi,[pause=10]huhuh.", 60)
											GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(cacnea, Direction.Right, 4)
											GROUND:MoveInDirection(cacnea, Direction.Right, 100, false, 1)
											SOUND:FadeOutBGM(120)
											GROUND:MoveInDirection(cacnea, Direction.Right, 100, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(cacnea) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(250)
											GeneralFunctions.FaceMovingCharacter(partner, glameow, 4, Direction.UpRight)
											GAME:WaitFrames(50)
											GROUND:CharTurnToCharAnimated(partner, cacnea, 4)
											GAME:WaitFrames(200)
											GeneralFunctions.FaceMovingCharacter(partner, cacnea, 4, Direction.UpRight)  end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(250)
											GeneralFunctions.FaceMovingCharacter(hero, glameow, 4, Direction.UpRight)
											GAME:WaitFrames(50)
											GeneralFunctions.FaceMovingCharacter(hero, cacnea, 4, Direction.UpRight)  end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_053']))
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_054'], CharacterEssentials.GetCharacterName("Cranidos")))

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Nous avons certainement eu affaire à beaucoup de Pokémon grossiers aujourd'hui.[pause=0]Tous les aventuriers,[pause=10]aussi...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Même si la plupart d'entre eux semblent sympas,[pause=10] je suppose que tous les aventuriers ne sont pas de gentils Pokémon.)", "Worried")

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_055']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_056']))

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Ils ont agi de manière hostile tout le temps jusqu'à la fin...[pause=0]Qu'est-ce qui a pu causer ce changement soudain ?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(De quoi chuchotaient-ils exactement,[pause=10]de toute façon ?)", "Worried")

	GAME:WaitFrames(20)
	--resuming playing whatever song is selected for town.
	SOUND:PlayBGM(SV.metano_town.Song, true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_057']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_058']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_059']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_060'], zone:GetColoredName(), CharacterEssentials.GetCharacterName("Mareep")))

	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera()
	SV.Chapter3.MetTeamStyle = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)


end



function metano_town_ch_3.MerchantIntro()
	--Player and partner walk from bridge to guild, merchants notice them
	--they both start trying to get their attention and to get their business
	--they start arguing with each other that the other blows
	--partner asks what's going on here
	--merchants explain they sell different kinds of items, while dogging the other merchants

	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local stunky = CH('Red_Merchant')
	local farfetchd = CH('Green_Merchant')


	GAME:MoveCamera(648, 1264, 1, false)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 624, 1096, Direction.Down)
	GROUND:TeleportTo(partner, 656, 1096, Direction.Down)

	--they are arguing
	GROUND:EntTurn(stunky, Direction.Left)
	GROUND:EntTurn(farfetchd, Direction.Right)
	GROUND:CharSetEmote(stunky, "angry", 0)
	GROUND:CharSetEmote(farfetchd, "angry", 0)
	GROUND:CharSetAnim(stunky, "Idle", true)
	GROUND:CharSetAnim(farfetchd, "Idle", true)

	GAME:FadeIn(40)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 656, 1232, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 624, 1232, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(90)
												  GROUND:CharEndAnim(farfetchd)
												  GeneralFunctions.EmoteAndPause(farfetchd, "Exclaim", true)
												  GROUND:CharTurnToCharAnimated(farfetchd, partner, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(110)
												  GROUND:CharEndAnim(stunky)
												  GeneralFunctions.EmoteAndPause(stunky, "Notice", false)
												  GROUND:CharTurnToCharAnimated(stunky, partner, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, farfetchd.CurrentForm.Species, farfetchd.CurrentForm.Form, farfetchd.CurrentForm.Skin, farfetchd.CurrentForm.Gender)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "Ah, les aventuriers[pause=10]![pause=0]Venez découvrir ma belle sélection de marchandises,[pause=10]oui ?")
	GAME:WaitFrames(20)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, stunky.CurrentForm.Species, stunky.CurrentForm.Form, stunky.CurrentForm.Skin, stunky.CurrentForm.Gender)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "Êtes-vous fou ?[pause=0]Personne ne veut de votre fantaisie,[pause=10]des cochonneries hors de prix ![pause=0]Ils sont là pour mes bonnes affaires.")

	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(farfetchd, stunky, 4)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, farfetchd.CurrentForm.Species, farfetchd.CurrentForm.Form, farfetchd.CurrentForm.Skin, farfetchd.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Angry")
	GeneralFunctions.Complain(farfetchd, true)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "Il n'y a pas un seul habitant de cette belle ville qui achèterait vos déchets bon marché !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_061']))

	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(stunky, farfetchd, 4)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, stunky.CurrentForm.Species, stunky.CurrentForm.Form, stunky.CurrentForm.Skin, stunky.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Angry")
	GeneralFunctions.Complain(stunky, true)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "Continuez à mentir à tout le monde ![pause=0]Vous et moi savons tous les deux que mes produits sont de premier ordre !")
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_062']))
	GAME:WaitFrames(20)


	GROUND:CharSetEmote(farfetchd, "", 0)
	GROUND:CharSetEmote(stunky, "", 0)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(farfetchd, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(stunky, partner, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, farfetchd.CurrentForm.Species, farfetchd.CurrentForm.Form, farfetchd.CurrentForm.Skin, farfetchd.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Happy")
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "Ah,[pause=10]pardonnez-moi,[pause=10]mes amis ![pause=0]J'avais oublié mes manières là-bas !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_063'], farfetchd:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, stunky.CurrentForm.Species, stunky.CurrentForm.Form, stunky.CurrentForm.Skin, stunky.CurrentForm.Gender)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "Je m'appelle " .. stunky:GetDisplayName() .. ",[pause=10]et contrairement à ce snob,[pause=10]je vends des articles qui sont réellement utiles.[pause=0]Pour pas cher,[pause=10]aussi !")
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_064']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(farfetchd)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "Bien observé,[pause=10]mon ami ![pause=0]je vois que tu es aussi pointu que mon poireau !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_065'], stunky:GetDisplayName()))
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(stunky, farfetchd, 4)
	UI:SetSpeaker(stunky)
	GROUND:CharSetEmote(stunky, "angry", 0)
	GeneralFunctions.SetEmotion("Determined")
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "Je pense que vous voulez dire que " .. GeneralFunctions.GetPronoun(partner, "they're") .. " est suffisamment intelligent pour dépenser judicieusement l'argent de " .. GeneralFunctions.GetPronoun(partner, "their") .. " avec mes bas prix.")
	GAME:WaitFrames(20)


	GROUND:CharTurnToCharAnimated(farfetchd, stunky, 4)
	UI:SetSpeaker(farfetchd)
	GROUND:CharSetEmote(farfetchd, "angry", 0)
	GeneralFunctions.SetEmotion("Determined")
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "Pourquoi devrais-je dire ça ?[pause=0]J'ai dit " .. GeneralFunctions.GetPronoun(partner, "they're") .. " sage,[pause=10]pas idiot !")
	GAME:WaitFrames(30)


	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	local zigzagoon = CharacterEssentials.MakeCharactersFromList({
									{"Zigzagoon", 640, 1096, Direction.Down}
									})


	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Ils s'y mettent vraiment...", 60) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(zigzagoon, 640, 1208, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_066'], farfetchd:GetDisplayName(), stunky:GetDisplayName()))
	GAME:WaitFrames(10)

	GeneralFunctions.DuoTurnTowardsChar(zigzagoon)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_067']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_068']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_069']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_070']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_071']))
	GROUND:CharSetEmote(zigzagoon, "glowing", 0)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_072']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_073']))
	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
											GROUND:MoveToPosition(zigzagoon, 820, 1208, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(partner, zigzagoon, 4, Direction.UpRight) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(hero, zigzagoon, 4, Direction.Right)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(10)
	GAME:GetCurrentGround():RemoveTempChar(zigzagoon)


	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_074']))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_075']))
	GAME:WaitFrames(20)




	coro1 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(farfetchd, "", 0)
											GROUND:CharTurnToCharAnimated(farfetchd, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(stunky, "", 0)
											GROUND:CharTurnToCharAnimated(stunky, partner, 4) end)

	TASK:JoinCoroutines({coro1, coro2})


	UI:SetSpeaker(farfetchd)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "C'est exact.[pause=0]J'ai un objet rare à acheter chaque jour.")
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_076']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(stunky)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "Je vends toutes sortes d'articles différents,[pause=10]et je n'ai également qu'un seul article par jour.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_077']))
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_078']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	--GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_079']))

	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_080'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_081']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(farfetchd)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, farfetchd, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharTurnToCharAnimated(hero, farfetchd, 4) end)
    --too long with no nicknames
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_150'])) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(20)

	UI:SetSpeaker(stunky)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "Ils feront le bon choix, très bien[pause=10].[pause=0]C'est pourquoi ils achèteront chez moi et pas chez vous !")

	GAME:WaitFrames(30)
	GeneralFunctions.PanCamera()
	SV.Chapter3.FinishedMerchantIntro = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)


end






function metano_town_ch_3.Wooper_Conversation(chara)
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

	UI:SetSpeaker(electrike)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_082'], CharacterEssentials.GetCharacterName("Numel")))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(dee, "Question", true)
	UI:SetSpeaker(dee)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_083']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(dun)
	GROUND:CharTurnToChar(dun, dee)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_084']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_085']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(electrike)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_086']))
	--UI:WaitShowDialogue("I think my mom said the spring is where the water in the river in town comes from.")

	GAME:WaitFrames(20)
	UI:SetSpeaker(dee)
	GROUND:CharTurnToChar(dun, electrike)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_087']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(dun)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_088']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(electrike)
	GeneralFunctions.EmoteAndPause(electrike, "Sweatdrop", true)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_089']))

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(electrike)
	GROUND:CharEndAnim(dun)
	GROUND:CharEndAnim(dee)

	partner.IsInteracting = false
end

function metano_town_ch_3.Meditite_Electrike_Conversation(chara)
	local meditite = CH('Meditite')
	local electrike = CH('Electrike')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(meditite, 'None', true)
	GROUND:CharSetAnim(electrike, 'None', true)

	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)

	UI:SetSpeaker(electrike)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_090'], meditite:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(meditite)
	--Yeah, I've never played that before, how do you play?
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_091']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(electrike)
	GeneralFunctions.EmoteAndPause(electrike, "Question", true)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_092']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(meditite)
	--I said I've never played that before, how do we play it?
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_093']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(electrike)
	GeneralFunctions.EmoteAndPause(electrike, "Sweatdrop", true)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_094']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_095']))


	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(electrike)
	GROUND:CharEndAnim(meditite)

	partner.IsInteracting = false
end

function metano_town_ch_3.Quagsire_Nidoqueen_Conversation(chara)
	local nidoqueen = CH('Nidoqueen')
	local quagsire = CH('Quagsire')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(nidoqueen, 'None', true)
	GROUND:CharSetAnim(quagsire, 'None', true)

	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)

	UI:SetSpeaker(quagsire)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_096']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(nidoqueen)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_097']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_098']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_099']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_100']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(quagsire)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_101']))

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(nidoqueen)
	GROUND:CharEndAnim(quagsire)

	partner.IsInteracting = false
end

function metano_town_ch_3.Oddish_Gloom_Conversation(chara)
	local gloom = CH('Gloom')
	local oddish = CH('Oddish')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(gloom, 'None', true)
	GROUND:CharSetAnim(oddish, 'None', true)

	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)

	UI:SetSpeaker(gloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_102'], oddish:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(oddish)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(oddish, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_103']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_104'], gloom:GetDisplayName()))
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(oddish, "", 0)
	UI:SetSpeaker(gloom)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_105']))

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(oddish)
	GROUND:CharEndAnim(gloom)

	partner.IsInteracting = false
end

function metano_town_ch_3.Quagsire_Action(chara, activator)
	metano_town_ch_3.Quagsire_Nidoqueen_Conversation(chara)
end

function metano_town_ch_3.Nidoqueen_Action(chara, activator)
	metano_town_ch_3.Quagsire_Nidoqueen_Conversation(chara)
end


function metano_town_ch_3.Electrike_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		metano_town_ch_3.Wooper_Conversation(chara)
	else
		metano_town_ch_3.Meditite_Electrike_Conversation(chara)
	end
end

function metano_town_ch_3.Wooper_Boy_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		metano_town_ch_3.Wooper_Conversation(chara)
	else
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Wooper_Girl") .. " ne me trouvera jamais ici ![pause=0]Cette cachette est la meilleure !", "Happy")
		GeneralFunctions.EndConversation(chara)
	end
end

function metano_town_ch_3.Wooper_Girl_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		metano_town_ch_3.Wooper_Conversation(chara)
	else
		GeneralFunctions.StartConversation(chara, "Moi et " .. CharacterEssentials.GetCharacterName("Wooper_Boy") .. " jouons à cache-cache !")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_106']))
		GeneralFunctions.EndConversation(chara)
	end
end

function metano_town_ch_3.Floatzel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Cela fait des heures que je me cache derrière ce buisson et les jumeaux ne m'ont toujours pas trouvé !", "Happy")
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_107']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Bellossom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "C'est une belle journée comme toujours ![pause=0]Mon jardin fleuri est également magnifique aujourd'hui !", "Happy")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Sentret_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Je suis heureux que vous soyez de retour " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0]Nous pouvons désormais tous jouer à nouveau ensemble !", "Happy", false)
		GeneralFunctions.EndConversation(chara)
	else
		GeneralFunctions.StartConversation(chara, "Je comprends pourquoi papa aime toujours faire une sieste ici au bord de la rivière maintenant...[pause=0]C'est sympa...", "Happy", false, false)
		GeneralFunctions.EndConversation(chara, false)
	end
end


function metano_town_ch_3.Oddish_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Hourra ![pause=0]Jouer sera plus amusant maintenant que " .. CharacterEssentials.GetCharacterName("Numel") .. " est de retour !", "Happy", false)
		GeneralFunctions.EndConversation(chara)
	else
		metano_town_ch_3.Oddish_Gloom_Conversation(chara)
	end
end

function metano_town_ch_3.Numel_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Jouons tous au tag ![pause=0]Je serai le premier !", "Happy", false)
	else
		GeneralFunctions.StartConversation(chara, "Je ne peux pas jouer avec les autres enfants aujourd'hui parce que je dois faire mes corvées...", "Worried")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_108']))
	end
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Mawile_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "La rumeur court dans la ville que vous avez réussi à sauver l'enfant disparu ![pause=0]C'est merveilleux !", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_109']))
	else
		local partner = CH('Teammate1')
		local hero = CH('PLAYER')
		GeneralFunctions.StartConversation(chara, partner:GetDisplayName() .. "![pause=0]" .. hero:GetDisplayName() .. "![pause=0]Avez-vous entendu ?")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_110']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_111']))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Nidorina_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Tu peux croire que mes parents m'ont gardé à l'intérieur pendant que ce gamin avait disparu ?", "Determined", false)
	--too long with no nicknames
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_112']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Gloom_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Peut-être que tes parents étaient juste inquiets...[pause=0]Mon père s'inquiète beaucoup.", "Worried", false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_113']))
		GeneralFunctions.EndConversation(chara)
	else
		metano_town_ch_3.Oddish_Gloom_Conversation(chara)
	end
end


function metano_town_ch_3.Azumarill_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " sait où se trouve l'enfant maintenant ![pause=0]Cela rend " .. chara:GetDisplayName() .. " heureux !", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_114'], chara:GetDisplayName()))
	else
		GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " entend parler de hors-la-loi effrayants tout le temps maintenant...[pause=0]" .. chara:GetDisplayName() .. " ne veut pas que les hors-la-loi battent " .. chara:GetDisplayName() .. " !", "Worried")
		--too long with no nicknames
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_115'], chara:GetDisplayName(), chara:GetDisplayName(), chara:GetDisplayName()))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Manectric_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Alors c'est vous qui avez sauvé le petit garçon de " .. CharacterEssentials.GetCharacterName("Camerupt") .. " ?")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_116']))
	else
		GeneralFunctions.StartConversation(chara, "L'activité supplémentaire des hors-la-loi ces derniers temps est censée être liée à l'augmentation du nombre de donjons mystérieux qui apparaissent.")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_117']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_118']))
		--GeneralFunctions.SetEmotion("Normal")
		--UI:WaitShowDialogue("But I know that you adventurers will keep us safe![pause=0] We're all counting on you!")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Camerupt_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Je ne peux toujours pas vous remercier assez pour avoir sauvé mon petit garçon !", "Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_119'], CharacterEssentials.GetCharacterName("Numel")))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Furret_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Ah,[pause=10] je peux à nouveau me détendre maintenant que " .. CharacterEssentials.GetCharacterName("Numel") .. " est de retour sain et sauf !", "Happy", false, false)
	else
		GeneralFunctions.StartConversation(chara, "La seule chose mieux que de dormir dans mon endroit préféré...", "Normal", false, false)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_120']))
	end
	GeneralFunctions.EndConversation(chara, false)
end

function metano_town_ch_3.Linoone_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Maintenant que les choses sont revenues à la normale,[pause=10] je peux me concentrer sur la lecture de ce livre que " .. CharacterEssentials.GetCharacterName("Medicham") .. " m'a recommandé.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_121']))
	else
		GeneralFunctions.StartConversation(chara, "Cet endroit au bord de la rivière est un endroit idéal pour lire.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_122']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_123']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_124']))
	end
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Luxray_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Hmmph.[pause=0]Le fils de " .. CharacterEssentials.GetCharacterName("Camerupt") .. " s'enfuit,[pause=10]et maintenant qu'il lui a été rendu,[pause=10] elle ne lui donne aucune punition ?")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_125']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Nidoking_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "C'est merveilleux que le jeune de " .. CharacterEssentials.GetCharacterName('Camerupt') .. " ait été sauvé sain et sauf.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_126']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Medicham_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		--My mind is clear and I can meditate again now that Nubbor's rescued.
		GeneralFunctions.StartConversation(chara, "Vider mon esprit et puis-je méditer à nouveau grâce au sauvetage de " .. CharacterEssentials.GetCharacterName("Numel") .. ".")
	else
		--This is the best place in town to meditate. Usually some older kids hang out here, but they're not here today.
		GeneralFunctions.StartConversation(chara, "Je trouve que la méditation se fait mieux dans cet endroit de la ville.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_127']))
	end
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_3.Meditite_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "J'aimerais pouvoir jouer avec les autres enfants.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_128']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_129']))
	else
		metano_town_ch_3.Meditite_Electrike_Conversation(chara)
	end
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_3.Machamp_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Oi![pause=0]Avez-vous entendu la nouvelle ?")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_130']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_131']))
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Growlithe_Desk_Action(chara, activator)
	local growlithe = CH('Growlithe')
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(growlithe, "J'ai entendu dire que vous aviez tous les deux sauvé la collerette " .. CharacterEssentials.GetCharacterName("Numel") .. ",[pause=10]!", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_132']))
	else
		GeneralFunctions.StartConversation(growlithe, "Excellent travail pour arrêter ce hors-la-loi " .. CharacterEssentials.GetCharacterName("Sandile") .. ", les gars ![pause=0]Vous avez été sur une lancée ces derniers temps, fraise[pause=10]!", "Happy")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_133']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_134'], CharacterEssentials.GetCharacterName("Tropius"), CharacterEssentials.GetCharacterName("Zigzagoon")))
	end
	GeneralFunctions.EndConversation(growlithe)
end

function metano_town_ch_3.Audino_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Oh,[pause=10] vous partez tous les deux pour la journée ?")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_135']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_136']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Snubbull_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Oh,[pause=10] la boutique Kecleon n'a plus d'Apricorns...", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_137']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_138']))
		GeneralFunctions.SetEmotion("Sad")
		--too long with no nicknames
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_139']))
	else
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Kecleon") .. " dit que la boutique Kecleon recevra bientôt une nouvelle livraison d'Apricorns.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_140']))
		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_141'], STRINGS:Format("\\u266A")))
	end
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_3.Zigzagoon_Action(chara, activator)
	--too long with no nicknames
	GeneralFunctions.StartConversation(chara, "Saviez-vous que vous pouvez consulter vos tâches actives pendant que vous êtes dans un donjon ?[pause=0]C'est parfait pour quelqu'un comme moi !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_142'], STRINGS:LocalKeyString(9)))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_143']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Mareep_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Fa-a-a-antastic vous deux ![pause=0]Je savais que vous pouviez na-a-a-ab ce méchant !", "Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_144']))
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Cranidos_Action(chara, activator)
	local sandile_species = _DATA:GetMonster('sandile'):GetColoredName()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
	GeneralFunctions.StartConversation(chara, "Quoi,[pause=10] suis-je censé être impressionné que vous ayez capturé ce " .. sandile_species .. " ?")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_145'], zone:GetColoredName()))
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT3_146']))
	SV.Chapter3.PostBossSpokeToCranidos = true
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.TrailerCameraPan()
	GROUND:Hide('Green_Merchant')
	GROUND:Hide('Red_Merchant')
	GAME:FadeOut(false, 1)
	GAME:WaitFrames(40)
	GAME:FadeIn(1)
	GAME:MoveCamera(436, 120, 1, false)
	GAME:MoveCamera(436, 1020, 450, false)

	GAME:FadeOut(false, 1)
	GAME:WaitFrames(40)

	GAME:MoveCamera(1130, 552, 1, false)
	GAME:FadeIn(1)
	GAME:MoveCamera(1130, 1252, 350, false)
	GAME:FadeOut(false, 1)
	GAME:WaitFrames(40)


	GAME:MoveCamera(666, 1200, 1, false)
	GAME:FadeIn(1)
	GAME:MoveCamera(666, 1040, 80, false)
	GAME:MoveCamera(746, 960, 40, false)
	GAME:MoveCamera(746, 792, 84, false)
	GAME:WaitFrames(120)
	GAME:FadeOut(false, 1)
	GAME:WaitFrames(40)

	GAME:WaitFrames(60)
	GAME:MoveCamera(0,0,1, true)
	GAME:FadeIn(1)


end
