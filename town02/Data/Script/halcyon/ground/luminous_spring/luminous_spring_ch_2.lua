require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

luminous_spring_ch_2 = {}


function luminous_spring_ch_2.FindNumelCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local numel = CharacterEssentials.MakeCharactersFromList({{"Numel", 292, 248, Direction.Up}})
	GAME:WaitFrames(60)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()

	GROUND:TeleportTo(hero, 276, 624, Direction.Up)
	GROUND:TeleportTo(partner, 308, 624, Direction.Up)
	GAME:MoveCamera(300, 600, 1, false)
	--Start numel's trembling
	--GeneralFunctions.StartTremble(numel)

	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)

	SOUND:PlayBGM('In the Depths of the Pit.ogg', true)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 308, 488, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 276, 488, false, 1) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_001']))
	GAME:WaitFrames(10)

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_003'], numel:GetDisplayName()))

	GAME:WaitFrames(20)

	GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.Up)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	GeneralFunctions.SetEmotion("Surprised")
	SOUND:FadeOutBGM(120)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_004'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:MoveCamera(300, 478, 1, false)
											GAME:MoveCamera(300, 256, 116, false) end)


	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)

	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_005']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_006'], numel:GetDisplayName()))

	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 308, 280, false, 2) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:MoveToPosition(hero, 276, 280, false, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_007'], numel:GetDisplayName(), hero:GetDisplayName()))
	GAME:WaitFrames(20)

	--GeneralFunctions.StopTremble(numel)
	GeneralFunctions.EmoteAndPause(numel, "Notice", true)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_008']))

	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(numel, Direction.Down, 4)
	GAME:WaitFrames(10)

	GeneralFunctions.Recoil(numel)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_009']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_010']))
	GeneralFunctions.SetEmotion("Normal")
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_011'], GAME:GetTeamName()))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(numel, "Exclaim", true)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_012']))


	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_013']))

	GAME:WaitFrames(10)
	SOUND:PlayBattleSE('EVT_Emote_Startled_2')
	GeneralFunctions.Hop(numel)
	GeneralFunctions.Hop(numel)

	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(numel, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_014']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_015']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_016']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_017']))
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_018'], numel:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(numel, "", 0)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_019']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_022']))
	GROUND:CharAnimateTurnTo(numel, Direction.Up, 4)
	--GAME:WaitFrames(10)
	GeneralFunctions.Complain(numel, true)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_023']))

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_024']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(numel, "", 0)
	GROUND:CharAnimateTurnTo(numel, Direction.Down, 4)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_025']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_026']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_027']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_028']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_029']))

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(numel, Direction.Right, 4)
											GROUND:MoveToPosition(numel, 324, 248, false, 1)
											GeneralFunctions.FaceMovingCharacter(numel, partner, 4, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EightWayMove(partner, 292, 248, false, 1)
											GeneralFunctions.MoveCharAndCamera(partner, 292, 192, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(60)
												  GROUND:MoveInDirection(hero, Direction.Up, 32, false, 1) end)


	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_030']))

	GAME:WaitFrames(20)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_031']))
	--GAME:WaitFrames(20)
	--UI:WaitShowDialogue("...........................")
	UI:SetCenter(false)
	GAME:WaitFrames(80)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_032']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_033']))

	GAME:WaitFrames(10)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_034'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 292, 216, false, 1)
											GROUND:MoveToPosition(hero, 292, 192, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function()	GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
											GROUND:MoveToPosition(partner, 340, 192, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(numel, hero, 4, Direction.Up) end)


	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je reste juste là,[pause=10]alors ?[pause=0]C'est assez bizarre...)", "Worried")

	GAME:WaitFrames(20)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_035']))
	GAME:WaitFrames(20)
	GeneralFunctions.Shake(hero)
	GAME:WaitFrames(10)
	UI:SetCenter(false)
	GeneralFunctions.EmoteAndPause(hero, "Notice", true)
	GeneralFunctions.HeroDialogue(hero, "(Je ressens quelque chose...[pause=0]étrange.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Est-ce que cela pourrait être la façon dont cette évolution est censée se ressentir ?)", "Worried")
	GAME:WaitFrames(40)

	GeneralFunctions.HeroDialogue(hero, "(...Non.[pause=0]Ça ne peut pas être.[pause=0]Cette tension étrange,[pause=10]Je l'ai déjà ressentie...[pause=0]Mais où ?)", "Worried")

	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	GAME:WaitFrames(40)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim_Idea')
	GeneralFunctions.EmoteAndPause(hero, 'Exclaim', false)
	GeneralFunctions.HeroDialogue(hero, "(Oh,[pause=10]c'est vrai !)", "Surprised")
	GeneralFunctions.HeroDialogue(hero, "(J'ai ressenti cela dans " .. zone:GetColoredName() .. "![pause=0]Quand j'ai touché cette tablette de pierre !)", "Surprised")

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Mais quelque chose de différent cette fois-ci.[pause=0]Cela me donne un peu la nausée,[pause=10]en fait.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(...Y a-t-il un problème avec le ressort ?)", "Worried")

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_036'], hero:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_037']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_038'], CharacterEssentials.GetCharacterName("Noctowl")))

	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, numel, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)

	TASK:JoinCoroutines({coro1, coro2})

	GROUND:CharTurnToCharAnimated(numel, partner, 4)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_039'], numel:GetDisplayName()))


	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(numel, "Exclaim", true)
	UI:SetSpeaker(numel)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_040']))
	GAME:WaitFrames(20)
	--GeneralFunctions.ShakeHead(numel, nil, true)

	GAME:WaitFrames(20)
	GeneralFunctions.Hop(numel)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LS2_041']))


	GAME:WaitFrames(30)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(90)
	SV.Chapter2.FinishedRiver = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")


end



return luminous_spring_ch_2




