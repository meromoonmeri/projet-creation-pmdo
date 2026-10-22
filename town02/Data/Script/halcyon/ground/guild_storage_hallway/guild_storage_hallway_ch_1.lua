require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_storage_hallway_ch_1 = {}



--[[function guild_storage_hallway_ch_1.SetupGround()
	local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
														RogueElements.Rect(144, 88, 64, 16),
														RogueElements.Loc(0, 8),
														true,
														"Event_Trigger")
	  groundObj:ReloadEvents()
	  GAME:GetCurrentGround():AddTempObject(groundObj)

	  GAME:FadeIn(20)
end]]--

function guild_storage_hallway_ch_1.MeetAudino()

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	local audino = CharacterEssentials.MakeCharactersFromList({
		{'Audino', -20, 172, Direction.Right}
	})
	--need to spawn the partner at same location as hero and wait 32 frames before moving rather than 32 behind partner
	--putting partner too far out of bounds breaks their talk to script for whatever reason until the map reloads
	GAME:CutsceneMode(true)
	GROUND:Hide("Top_Exit")
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 168, -24, Direction.Down)
	GROUND:TeleportTo(partner, 168, -24, Direction.Down)
	GAME:MoveCamera(180, 148, 1, false)
	GAME:FadeIn(20)
	--GROUND:Hide("Event_Trigger")

	--UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	--UI:WaitShowDialogue("C-coming through!")

--[[	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Question", true)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
											GROUND:CharSetEmote(hero, "shock", 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GeneralFunctions.EmoteAndPause(partner, "Question", false)
												  GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
												  GAME:WaitFrames(10)
											      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end) ]]--

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 168, 172, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
												  GROUND:MoveToPosition(partner, 168, 140, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(153)
												  GROUND:MoveToPosition(audino, 152, 172, true, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, audino.CurrentForm.Species, audino.CurrentForm.Form, audino.CurrentForm.Skin, audino.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Pain")
	SOUND:StopBGM()

	--TODO: add animations for audino getting knocked to the ground as well if she ever gets animations for it.
	--you two dopes run into each other
	SOUND:PlayBattleSE('EVT_Tackle')
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(hero, "Pain", Direction.Left, Direction.Right, 4, 1, 4)
											GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pain"))) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(audino, "Hurt", Direction.Right, Direction.Left, 4, 1, 2)
											GROUND:CharSetAnim(audino, "Hurt", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(partner, 'Shock', false) end)
	local coro4 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Urf!", 60) end)
	--local coro5 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(partner, "Walk", Direction.Left, Direction.Right, 4, 1, 3) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})


	--GROUND:CharTurnToChar(partner, audino)
	GROUND:CharSetAnim(audino, "None", true)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Dizzy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_001'], CharacterEssentials.GetCharacterName("Snubbull")))
	GAME:WaitFrames(20)


	GeneralFunctions.ShakeHead(audino, nil, true)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(audino, "Exclaim", true)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_002']))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_003']))
	GeneralFunctions.SetEmotion("Teary-Eyed")
	GeneralFunctions.EmoteAndPause(audino, "Sweating", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_004']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_005']))
	GAME:WaitFrames(20)

	--GROUND:CharTurnToChar(partner, hero)
	GeneralFunctions.HeroDialogue(hero, "(Urgh...[pause=0]Cette folie a suffi à me donner un deuxième cas d'amnésie...)", "Dizzy")
	GAME:WaitFrames(20)

	--if you got hurt... I'd...
	GeneralFunctions.Shake(hero)
	GAME:WaitFrames(20)
	GROUND:CharWaitAnim(hero, "Wake")
	GROUND:CharSetAnim(hero, "None", true)
	GAME:WaitFrames(20)

	--GROUND:CharTurnToChar(partner, audino)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, audino.CurrentForm.Species, audino.CurrentForm.Form, audino.CurrentForm.Skin, audino.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_006']))
	GAME:WaitFrames(20)

	--GROUND:CharTurnToChar(partner, hero)
	GeneralFunctions.DoAnimation(hero, "Nod", false)
	GAME:WaitFrames(20)

	--GROUND:CharTurnToChar(partner, audino)
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_007']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_008']))
	GeneralFunctions.SetEmotion("Teary-Eyed")
	GeneralFunctions.StartTremble(audino)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_009']))
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(audino, "glowing", 0)
	GeneralFunctions.SetEmotion("Joyous")
	GeneralFunctions.StopTremble(audino)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_010']))
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(audino, "", 0)

	GROUND:CharTurnToChar(partner, audino)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_011']))
	GAME:WaitFrames(20)

	GROUND:CharTurnToChar(audino, partner)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, audino.CurrentForm.Species, audino.CurrentForm.Form, audino.CurrentForm.Skin, audino.CurrentForm.Gender)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_012']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_013']))
	GAME:WaitFrames(20)

	GeneralFunctions.EmoteAndPause(audino, "Exclaim", true)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_014']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_015']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_016'], partner:GetDisplayName(), hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_017']))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(audino, Direction.DownRight, 4)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, audino.CurrentForm.Species, audino.CurrentForm.Form, audino.CurrentForm.Skin, audino.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_018']))
	GAME:WaitFrames(20)

	GeneralFunctions.EmoteAndPause(audino, 'Exclaim', true)
	GROUND:CharAnimateTurnTo(audino, Direction.Right, 4)
	GROUND:CharSetEmote(audino, "sweating", 1)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_019']))
	GeneralFunctions.SetEmotion("Normal")
	--UI:WaitShowDialogue("With the messes that " .. CharacterEssentials.GetCharacterName("Cranidos") .. " makes,[pause=10] you'd have to try to be give me more work than he does!")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_020']))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_021'], audino:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_022'], audino:GetDisplayName()))
	GAME:WaitFrames(20)

	--what were you doing here rin? oh i was in the guldmasters room tidying up, dont go in there though
	GROUND:CharTurnToChar(audino, partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_023']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_024']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_025']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_026']))
	--too long with no nicknames
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_027']))
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_028']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_029']))
	GAME:WaitFrames(20)


	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_030']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_031']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_032']))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_033']))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
											GROUND:MoveToPosition(audino, 168, audino.Position.Y, false, 2)
											GROUND:MoveToPosition(audino, 168, -20, false, 2)
											GROUND:Hide("Audino") end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(partner, Direction.Right, 24, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
											GAME:WaitFrames(26)
											GeneralFunctions.FaceMovingCharacter(partner, audino, 4, Direction.UpLeft) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(hero, "Walk", Direction.Left, Direction.Right, 8, 1, 1)
											GAME:WaitFrames(42)
											GeneralFunctions.FaceMovingCharacter(hero, audino, 4, Direction.Up) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_034']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_035']))
	GAME:WaitFrames(40)

	GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
	GAME:WaitFrames(60)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_036']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_037']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_038']))
	GAME:WaitFrames(20)

	GROUND:CharEndAnim(hero)
	GeneralFunctions.PanCamera(180, 148)
	GROUND:Unhide("Top_Exit")
	GAME:GetCurrentGround():RemoveTempChar(audino)
	SV.Chapter1.MetAudino = true

	--every guildmate is talked to, signal player that they can go sleep now
	if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
		GAME:WaitFrames(60)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_039'], hero:GetDisplayName()))
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		GAME:WaitFrames(12)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_040']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GSH1_041'], hero:GetDisplayName()))
	end


	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)

	GAME:CutsceneMode(false)



end
