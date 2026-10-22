require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

vast_steppe_entrance_ch_5 = {}

function vast_steppe_entrance_ch_5.SetupGround()

	if not SV.Chapter5.EnteredSteppe then
		local noctowl, tropius, mareep, cranidos, zigzagoon, growlithe, breloom, girafarig, tail =
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 352, 280, Direction.DownLeft},
			{'Tropius', 272, 272, Direction.Right},
			{'Mareep', 86, 384, Direction.DownRight},
			{'Cranidos', 86, 420, Direction.UpRight},
			{'Zigzagoon', 122, 420, Direction.UpLeft},
			{'Growlithe', 122, 384, Direction.DownLeft},
			{'Breloom', 336, 408, Direction.Down},
			{'Girafarig', 336, 440, Direction.Up},
			{'Tail'}
		})

		--set rin and coco to spawn from the spawners, then spawn them
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		local snubbull = GROUND:SpawnerDoSpawn("TEAMMATE_2")

		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		local audino = GROUND:SpawnerDoSpawn("TEAMMATE_3")

	else
		local noctowl, tropius =
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 352, 280, Direction.DownRight},
			{'Tropius', 376, 304, Direction.UpLeft}
		})

		--set rin and coco to spawn from the spawners, then spawn them
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		local snubbull = GROUND:SpawnerDoSpawn("TEAMMATE_2")

		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		local audino = GROUND:SpawnerDoSpawn("TEAMMATE_3")

		--teleport them to their new spot.
		GROUND:TeleportTo(snubbull, 224, 216, Direction.Right)
		GROUND:TeleportTo(audino, 272, 216, Direction.Left)
	end
end


--TASK:BranchCoroutine(vast_steppe_entrance_ch_5.ArrivalCutscene)
function vast_steppe_entrance_ch_5.ArrivalCutscene()

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:Hide('Supply_Bag')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('vast_steppe')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GAME:MoveCamera(256, 296, 1, false)

	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, breloom, mareep, cranidos =
	CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 248, 452, Direction.Up},
		{'Noctowl', 216, 452, Direction.Up},
		{'Audino', 268, 524, Direction.Up},
		{'Snubbull', 260, 484, Direction.Up},
		{'Growlithe', 204, 484, Direction.Up},
		{'Zigzagoon', 196, 516, Direction.Up},
		{'Girafarig', 264, 444, Direction.Up},
		{'Breloom', 232, 452, Direction.Up},
		{'Mareep', 236, 476, Direction.Up},
		{'Cranidos', 228, 524, Direction.Up}})

	GROUND:TeleportTo(hero, 300, 508, Direction.Up)
	GROUND:TeleportTo(partner, 292, 476, Direction.Up)



	GAME:FadeIn(40)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GAME:WaitFrames(40)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(girafarig, Direction.Up, 172, false, 1)
												  GROUND:CharAnimateTurnTo(girafarig, Direction.Down, 4)
												  end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(breloom, Direction.Up, 180, false, 1)
												  GROUND:CharAnimateTurnTo(breloom, Direction.Down, 4)
												  end)
	TASK:JoinCoroutines({coro1, coro2})
	GeneralFunctions.DoubleHop(breloom)

	UI:SetSpeaker(breloom)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(breloom, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_001']))
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(breloom, "", 0)

	--everyone comes walking in
	SOUND:LoopSE("Guild's Feet Pitterpatter")
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(tropius, Direction.Up, 180, false, 1)
											GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(noctowl, Direction.Up, 188, false, 1)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
											end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(audino, Direction.Up, 196, false, 1)
												  end)
	local coro4 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(snubbull, Direction.Up, 184, false, 1)
												  end)
	local coro5 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(growlithe, Direction.Up, 180, false, 1)
												  GROUND:MoveInDirection(growlithe, Direction.UpRight, 8, false, 1)
												  GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
												  end)
	local coro6 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(zigzagoon, Direction.Up, 188, false, 1)
												  GROUND:MoveInDirection(zigzagoon, Direction.UpRight, 8, false, 1)
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												  end)
	local coro7 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(mareep, Direction.Up, 176, false, 1)
												  end)
	local coro8 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(cranidos, Direction.Up, 196, false, 1)
												  end)
	local coro9 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(partner, 284, 296, false, 1)
											      GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
												  end)
	local coro10 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(hero, 292, 324, false, 1)
												   GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4)
												   end)
    local coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(80)
												   GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4)
												   GeneralFunctions.EightWayMoveRS(breloom, 184, 272, false, 1)
												   GROUND:CharAnimateTurnTo(breloom, Direction.DownRight, 4)
												   end)
	local coro12 = TASK:BranchCoroutine(function() GAME:WaitFrames(86)
												   GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4)
												   GeneralFunctions.EightWayMoveRS(girafarig, 192, 248, false, 1)
												   GROUND:CharAnimateTurnTo(girafarig, Direction.DownRight, 4)
												   end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12})
	SOUND:StopSE("Guild's Feet Pitterpatter")

	--phileas, reinier, and kino discuss a bit while penticus is distracted by the unmoving flower
	GAME:WaitFrames(30)
	GeneralFunctions.SetEmotion("Normal")

	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_119']))
								 end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(mareep, Direction.UpLeft, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22)
											GROUND:CharAnimateTurnTo(snubbull, Direction.UpLeft, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(audino, Direction.UpLeft, 4)
											end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharAnimateTurnTo(tropius, Direction.Left, 4)
											end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Left, 4)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})

	--GeneralFunctions.DoubleHop(growlithe, 'None', 6, 6, true, true)
	--UI:SetSpeaker(growlithe)
	--GeneralFunctions.SetEmotion("Joyous")
	--UI:WaitShowDialogue("Ruff![pause=0] We're finally here![pause=0] I can't wait for this adventure,[pause=10] ruff!")

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_002'], zone:GetColoredName()))

	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(breloom, Direction.Right, 4)
	GROUND:CharAnimateTurnTo(girafarig, Direction.Right, 4)

	UI:SetSpeaker(breloom)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_003']))
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_004']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(breloom)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_005']))
	GAME:WaitFrames(10)

	GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4)
	GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_007']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_008']))
	GROUND:CharAnimateTurnTo(breloom, Direction.DownRight, 4)
	GROUND:CharAnimateTurnTo(girafarig, Direction.DownRight, 4)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_009']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_010']))
	GAME:WaitFrames(30)

	UI:SetSpeaker(zigzagoon)
	--GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_011'], breloom:GetDisplayName(), girafarig:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(girafarig)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_012']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_013']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(girafarig)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_014']))
	GAME:WaitFrames(60)
	GeneralFunctions.EmoteAndPause(girafarig, "Sweating", true)
	GeneralFunctions.SetEmotion("Sad")
	--wrap in a branch coroutine so the script = 0 tag does not make you wait for the action to finish. Do not need to join the coroutine back in.
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_015']), {function() TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(tropius, Direction.Right, 4) end) end})
	GAME:WaitFrames(12)

	GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_016'], girafarig:GetDisplayName(), CharacterEssentials.GetCharacterName("Tail")))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(girafarig, Direction.Down, 4)
	GeneralFunctions.Complain(girafarig, true)
	UI:SetSpeaker(girafarig)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_017']))
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(girafarig, "", 0)

	UI:SetSpeaker(breloom)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_018']))

	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(breloom, Direction.DownRight, 4)
	GROUND:CharAnimateTurnTo(girafarig, Direction.DownRight, 4)

	--tropius wanders over to the still flower
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_019'], girafarig:GetDisplayName(), zone:GetColoredName()))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_020']))
	--wrap in a branch coroutine so the script = 0 tag does not make you wait for the action to finish. Do not need to join the coroutine back in.
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_021']), {function() TASK:BranchCoroutine(function() GROUND:MoveInDirection(tropius, Direction.Right, 24, false, 1) end) end})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_022']))
	GAME:WaitFrames(20)

	--seems like it could be dangerous...
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.DownRight, 4)
											GROUND:CharSetAnim(growlithe, "Idle", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
											GROUND:CharSetAnim(zigzagoon, "Idle", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.Down, 4)
											GROUND:CharSetAnim(mareep, "Idle", true) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)
											GROUND:CharSetAnim(audino, "Idle", true) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.DownRight, 4)
											GROUND:CharSetAnim(snubbull, "Idle", true) end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											 GROUND:CharSetAnim(partner, "Idle", true) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	UI:SetSpeaker(snubbull)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_023']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(cranidos)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_024']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_025']))
	GAME:WaitFrames(22)

	--Worry not says phileas. That's why we have our strategy of larger teams after all. Guildmaster? Guildmaster??
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_026']))
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
											GROUND:CharEndAnim(growlithe) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
											GROUND:CharEndAnim(zigzagoon) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharEndAnim(mareep)
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.UpLeft, 4)
											GROUND:CharEndAnim(audino)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharEndAnim(snubbull)
											GROUND:CharAnimateTurnTo(snubbull, Direction.UpLeft, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4) end)
	coro8 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
											GROUND:CharEndAnim(partner) end)
	coro9 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(breloom, Direction.Right, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
						                    GROUND:CharAnimateTurnTo(girafarig, Direction.DownRight, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9})

	GAME:WaitFrames(10)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_028']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_120']), {function() TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4) end) end})--wrap in a branch coroutine so the script = 0 tag does not make you wait for the action to finish. Do not need to join the coroutine back in.
	GAME:WaitFrames(50)

	GeneralFunctions.EmoteAndPause(noctowl, "Question", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_029']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")

	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(50)
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_121'])) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4)
											GROUND:MoveInDirection(noctowl, Direction.Right, 24, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GeneralFunctions.FaceMovingCharacter(growlithe, noctowl, 4, Direction.UpRight)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GeneralFunctions.FaceMovingCharacter(zigzagoon, noctowl, 4, Direction.UpRight)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GeneralFunctions.FaceMovingCharacter(cranidos, noctowl, 4, Direction.UpRight)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.FaceMovingCharacter(mareep, noctowl, 4, Direction.UpRight)
											end)
	coro7 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(audino, noctowl, 4, Direction.Up)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GeneralFunctions.FaceMovingCharacter(snubbull, noctowl, 4, Direction.Up)
											end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(hero, noctowl, 4, Direction.UpLeft)
											end)
	coro10 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl, 4, Direction.UpLeft)
											 end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})

	GAME:WaitFrames(10)
	GeneralFunctions.Complain(noctowl)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_030']))

	GAME:WaitFrames(10)
	--GeneralFunctions.Recoil(tropius, "Hurt", 10, 10, true, false)
	--GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_031'], noctowl:GetDisplayName()))
	GAME:WaitFrames(20)

	--todo: an emotion for noctowl here maybe? he never really shows emotion, but the guildmaster is acting odd here too.
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_032']))
	GAME:WaitFrames(20)

	--... Oh, right! Of course!
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_033']))

	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)


	--As you know our strat is to split up into teams. Kino and Reinier will stay as 2 and lead the way.
	--me and phileas will remain back and hand out supplies to anyone who's struggling to get through the dungeon.
	--Now, for the teams...
	GeneralFunctions.SetEmotion("Normal")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_122']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_034'], breloom:GetDisplayName(), girafarig:GetDisplayName()))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_035'], noctowl:GetDisplayName()))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_036']))
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpRight, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpRight, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9})


	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_037']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_038'], snubbull:GetDisplayName(), audino:GetDisplayName(), partner:GetDisplayName(), hero:GetDisplayName()))
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Right, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.Right, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Right, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_039']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_040']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_123'], mareep:GetDisplayName(), cranidos:GetDisplayName(), zigzagoon:GetDisplayName()))
								 end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpRight, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpRight, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9})
	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.DownRight, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.DownLeft, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Left, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
											GROUND:CharEndAnim(partner) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_041']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(mareep)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_042']))
	GAME:WaitFrames(40)

	--Ruff, Penticus... What about me? You didn't call my name! What team am I on?
	GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4)
	SOUND:FadeOutBGM(120)
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_043'], tropius:GetDisplayName()))
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpRight, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpRight, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})

	GAME:WaitFrames(10)

	--UI:SetSpeaker(zigzagoon)
	--GeneralFunctions.SetEmotion("Worried")
	--UI:WaitShowDialogue("Hey,[pause=10] you're right,[pause=10] " .. growlithe:GetDisplayName() .. "![pause=0] You forgot to call his name out with mine,[pause=10] Guildmaster!")
	--GAME:WaitFrames(20)

	--O-oh! You're on my team of course!
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	UI:SetSpeaker(tropius)
	GeneralFunctions.EmoteAndPause(tropius, "Question", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_044']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_045'], zigzagoon:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	--GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_046'], growlithe:GetDisplayName()))
	GAME:WaitFrames(20)

	--...But... I want to adventure with Almotz! And everyone else!
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_047']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_048'], zigzagoon:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_049']))
	GAME:WaitFrames(20)


	--you know how i worry...
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_050'], growlithe:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_051']))
	GAME:WaitFrames(20)

	--Penticus, please...
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_052']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_053']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_054']))
	GAME:WaitFrames(20)

	--
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_055']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_056']))

	GAME:WaitFrames(40)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_057']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true)
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharSetAnim(growlithe, "Idle", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_058']), {function() GeneralFunctions.Hop(growlithe) end})
	GAME:WaitFrames(20)

	GROUND:CharEndAnim(growlithe)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_059']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_060'], zigzagoon:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_061'], tropius:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_062'], mareep:GetDisplayName(), cranidos:GetDisplayName(), zigzagoon:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_063']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(mareep)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_064']))
	GAME:WaitFrames(30)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_065']))
	GAME:WaitFrames(60)

	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_066']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_067']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_068']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_069']))

	GAME:WaitFrames(20)

	--well we have our team. Let's get ready and roll out.
	--hero is distracted with that feeling. Been getting a little bit stronger as they get further out. WHAT DOES IT MEAN???
	--snap out of it hero! -- ACTUALLY DO THIS NEXT DUNGEON OR DURING THE NIGHT. THIS SCENE'S A BIT DENSE AS IT IS.
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	GROUND:CharSetEmote(partner, "happy", 0)

	--turn pokemon so pose is appropriate
	GROUND:EntTurn(growlithe, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Up)
	GROUND:EntTurn(snubbull, Direction.Up)
	GROUND:EntTurn(audino, Direction.Up)
	GROUND:EntTurn(mareep, Direction.Up)
	GROUND:EntTurn(cranidos, Direction.Up)
	GROUND:EntTurn(breloom, Direction.Down)
	GROUND:EntTurn(girafarig, Direction.Down)
	GROUND:EntTurn(partner, Direction.Up)
	GROUND:EntTurn(hero, Direction.Up)

	GROUND:CharSetAction(growlithe, RogueEssence.Ground.PoseGroundAction(growlithe.Position, growlithe.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(zigzagoon, RogueEssence.Ground.PoseGroundAction(zigzagoon.Position, zigzagoon.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(breloom, RogueEssence.Ground.PoseGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(girafarig, RogueEssence.Ground.PoseGroundAction(girafarig.Position, girafarig.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(cranidos, RogueEssence.Ground.PoseGroundAction(cranidos.Position, cranidos.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(mareep, RogueEssence.Ground.PoseGroundAction(mareep.Position, mareep.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(snubbull, RogueEssence.Ground.PoseGroundAction(snubbull.Position, snubbull.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_070']))

	GAME:WaitFrames(60)
	GAME:FadeOut(false, 60)

	--Clean up the existing spawns, then call SetupGround to spawn them in.
	--GeneralFunctions.DefaultParty(false)
	--reinitialize the hero and partner variables after respawning the party.
	--Failing to do this has later functions try to teleport the "old" versions of them, causing a phantom glitch.
	--hero = CH('PLAYER')
	--partner = CH('Teammate1')
	--partner.CollisionDisabled = true

	--Setup Coco and Rin.
	local snubbull_id = RogueEssence.Dungeon.MonsterID("snubbull", 0, "normal", Gender.Female)
	local snubbull_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, snubbull_id, SV.GuildSidequests.SnubbullLevel, "run_away", 0)
	snubbull_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	snubbull_monster.Nickname = CharacterEssentials.GetCharacterName('Snubbull', true)
	snubbull_monster.MetAt = "Adventurer's Guild"
	snubbull_monster.IsPartner = true
	snubbull_monster.IsFounder = true

	--snubbull's stats are kinda dookie in comparison to audino, so boost her up a bit.
	snubbull_monster.MaxHPBonus = 1
	snubbull_monster.SpeedBonus = 5

	snubbull_monster:ReplaceSkill("bite", 0, true)
	snubbull_monster:ReplaceSkill("lick", 1, true)
	snubbull_monster:ReplaceSkill("smelling_salts", 2, true)
	snubbull_monster:ReplaceSkill("charm", 3, false)

	GAME:AddPlayerTeam(snubbull_monster)
	snubbull_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    snubbull_monster.ActionEvents:Add(talk_evt)
	snubbull_monster:RefreshTraits()

	local audino_id = RogueEssence.Dungeon.MonsterID("audino", 0, "normal", Gender.Female)
	local audino_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, audino_id, SV.GuildSidequests.AudinoLevel, "regenerator", 0)
	audino_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	audino_monster.Nickname = CharacterEssentials.GetCharacterName('Audino', true)
	audino_monster.MetAt = "Adventurer's Guild"
	audino_monster.IsPartner = true
	audino_monster.IsFounder = true

	audino_monster:ReplaceSkill("double_slap", 0, true)
	audino_monster:ReplaceSkill("heal_bell", 1, true)
	audino_monster:ReplaceSkill("disarming_voice", 2, true)
	audino_monster:ReplaceSkill("helping_hand", 3, false)


	GAME:AddPlayerTeam(audino_monster)
	audino_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    audino_monster.ActionEvents:Add(talk_evt)
	audino_monster:RefreshTraits()

	--prevent heal bell from being unlearned.
	GAME:LockSkill(GAME:GetPlayerPartyMember(3), 1)

	--Assign importances to identify who they are. Do this instead of just checking species just in case randomizers down the road or something.
	local sTbl = LTBL(GAME:GetPlayerPartyMember(2))
	local aTbl = LTBL(GAME:GetPlayerPartyMember(3))

	sTbl.Importance = "Snubbull"
	aTbl.Importance = "Audino"

	GAME:GetCurrentGround():RemoveTempChar(breloom)
	GAME:GetCurrentGround():RemoveTempChar(girafarig)
	GAME:GetCurrentGround():RemoveTempChar(tropius)
	GAME:GetCurrentGround():RemoveTempChar(noctowl)
	GAME:GetCurrentGround():RemoveTempChar(snubbull)
	GAME:GetCurrentGround():RemoveTempChar(audino)
	GAME:GetCurrentGround():RemoveTempChar(growlithe)
	GAME:GetCurrentGround():RemoveTempChar(zigzagoon)
	GAME:GetCurrentGround():RemoveTempChar(cranidos)
	GAME:GetCurrentGround():RemoveTempChar(mareep)

	noctowl, tropius, mareep, cranidos, zigzagoon, growlithe, breloom, girafarig, tail =
	CharacterEssentials.MakeCharactersFromList({
		{'Noctowl', 352, 280, Direction.DownLeft},
		{'Tropius', 272, 272, Direction.Right},
		{'Mareep', 86, 384, Direction.DownRight},
		{'Cranidos', 86, 420, Direction.UpRight},
		{'Zigzagoon', 122, 420, Direction.UpLeft},
		{'Growlithe', 122, 384, Direction.DownLeft},
		{'Breloom', 336, 408, Direction.Down},
		{'Girafarig', 336, 440, Direction.Up},
		{'Tail'}
	})

	--set rin and coco to spawn from the spawners, then spawn them
	GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
	snubbull = GROUND:SpawnerDoSpawn("TEAMMATE_2")

	GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
	audino = GROUND:SpawnerDoSpawn("TEAMMATE_3")

	GROUND:Unhide('Supply_Bag')

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:TeleportTo(hero, 240, 344, Direction.Down)
	GROUND:TeleportTo(partner, 240, 312, Direction.Down)
	GAME:MoveCamera(0, 0, 1, true)


	GAME:WaitFrames(20)
	GAME:FadeIn(60)

	partner.CollisionDisabled = true--redisable partner's collision. Something is causing this to be set to false earlier in the script...
	SV.Chapter5.FinishedSteppeIntro = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)

end


function vast_steppe_entrance_ch_5.Tropius_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	if SV.Chapter5.NeedGiveSupplies then
	GeneralFunctions.StartConversation(chara, "Vous avez du mal avec le donjon ?[pause=0] " .. CharacterEssentials.GetCharacterName("Noctowl") .. " peut vous remettre sur pied avec des provisions !")
	elseif SV.Chapter5.EnteredSteppe then
	GeneralFunctions.StartConversation(chara, "Donjon difficile,[pause=10] hein ?[pause=0] Ne vous inquiétez pas,[pause=10] je sais que vous pouvez y arriver !")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_071']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_072']))
	elseif not SV.Chapter5.SpokeToTropiusSteppe then
		--hints as his relationship with growlithe, as well as the larger issue here. Should also have a small sense of urgency.
		--May be a bit of a tell don't show here with regards to how the expedition's been going so far...
	GeneralFunctions.StartConversation(chara, "Bonjour,[pause=10] Équipe " .. GAME:GetTeamName() .. " ![pause=0] Comment se passe l'expédition jusqu'ici ?")
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_073']))
		GAME:WaitFrames(20)

		GROUND:CharTurnToChar(chara, partner)
		UI:SetSpeaker(chara)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_074']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_075']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_076']))

		GAME:WaitFrames(40)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_077']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(chara)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_078']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_079'], CharacterEssentials.GetCharacterName("Growlithe")))
		GAME:WaitFrames(20)

		UI:SetSpeaker(chara)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_080']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_081']))
		GAME:WaitFrames(20)

		GROUND:CharAnimateTurnTo(chara, Direction.Right, 4)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_082']))
		GAME:WaitFrames(40)

		GROUND:CharTurnToCharAnimated(chara, hero, 4)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_083'], CharacterEssentials.GetCharacterName("Audino"), CharacterEssentials.GetCharacterName("Snubbull")))
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_084']))
		SV.Chapter5.SpokeToTropiusSteppe = true
	else
	GeneralFunctions.StartConversation(chara, "Vous deux,[pause=10] " .. CharacterEssentials.GetCharacterName("Audino") .. ",[pause=10] et " .. CharacterEssentials.GetCharacterName("Snubbull") .. " devriez avancer.[pause=0] Nous n'avons pas de temps à perdre !", "Normal")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_085']))
	end
	GeneralFunctions.EndConversation(chara)
end

function vast_steppe_entrance_ch_5.Noctowl_Action(chara, activator)
	if SV.Chapter5.NeedGiveSupplies then
	GeneralFunctions.StartConversation(chara, "Vous avez eu des ennuis,[pause=0] je vois.[pause=0] Prenez ceci,[pause=10] cela devrait vous aider.")
		GAME:WaitFrames(20)
		GeneralFunctions.RewardItem("food_apple")
		GeneralFunctions.RewardItem("berry_oran")
		GeneralFunctions.RewardItem("berry_leppa")
		GAME:WaitFrames(20)
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_086']))
		SV.Chapter5.NeedGiveSupplies = false
	elseif SV.Chapter5.EnteredSteppe then
	GeneralFunctions.StartConversation(chara, "Je suis certain que ces provisions vous aideront lors de votre prochaine tentative.[pause=0] Bon voyage.")
	else
	GeneralFunctions.StartConversation(chara, "Si le donjon mystère vous pose problème,[pause=10] venez me voir.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_087']))
	end
	GeneralFunctions.EndConversation(chara)
end

function vast_steppe_entrance_ch_5.Breloom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Bonne chance dans la steppe ![pause=0] Si vous ne faites pas attention,[pause=10] les choses peuvent vite mal tourner !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_088']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_089'], CharacterEssentials.GetCharacterName("Girafarig")))
	GeneralFunctions.EndConversation(chara)
end

function vast_steppe_entrance_ch_5.Girafarig_Action(chara, activator)
	local tail = CH('Tail')
	GeneralFunctions.StartConversation(chara, "Je ne me souviens peut-être pas de ce que contenait chaque donjon,[pause=10] mais je me souviens qu'ils avaient tous des boutiques de Kecleon !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_090']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_091']))
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_092']))
	--UI:WaitShowDialogue("Because believe me,[pause=10] you do NOT want to steal from a Kecleon Shop.")
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_093'], tail:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(tail)
	GeneralFunctions.SetEmotion("Special0")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_094']))
	GeneralFunctions.EndConversation(chara)
end

function vast_steppe_entrance_ch_5.Growlithe_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Nous devons être très prudents,[pause=10]comme " .. CharacterEssentials.GetCharacterName("Tropius") .. " l'a demandé.", "Normal", false)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_095']))
	GeneralFunctions.EndConversation(chara)
end

function vast_steppe_entrance_ch_5.Zigzagoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Je suis content que le Maître de Guilde vous ait acceptés dans notre équipe,[pause=10] " .. CharacterEssentials.GetCharacterName("Growlithe") .. ".", "Normal", false)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_096']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_097']))
	GeneralFunctions.EndConversation(chara)
end

function vast_steppe_entrance_ch_5.Audino_Action(chara, activator)
	if SV.Chapter5.NeedGiveSupplies then
	GeneralFunctions.StartConversation(chara, "Vous devriez aller prendre quelques provisions auprès de " .. CharacterEssentials.GetCharacterName("Noctowl") .. " ![pause=0] Nous pourrions avoir besoin d'aide pour notre prochaine tentative !")

	elseif SV.Chapter5.EnteredSteppe then
	GeneralFunctions.StartConversation(chara, "Oh,[pause=10] vous avez les provisions de " .. CharacterEssentials.GetCharacterName("Noctowl") .. " ![pause=0] Merveilleux !", "Happy")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_098']))
	else
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Snubbull") .. " et moi sommes prêts à partir dès que vous le serez ![pause=0] Dites-le-nous simplement !")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_099']))
	end
	GeneralFunctions.EndConversation(chara)
end

function vast_steppe_entrance_ch_5.Snubbull_Action(chara, activator)
	if SV.Chapter5.NeedGiveSupplies then
	GeneralFunctions.StartConversation(chara, "Vous devriez aller voir " .. CharacterEssentials.GetCharacterName("Noctowl") .. ".[pause=0] Il devrait avoir des provisions pour nous.")
		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_100'], STRINGS:Format("\\u266A")))
	elseif SV.Chapter5.EnteredSteppe then
	GeneralFunctions.StartConversation(chara, "Hmmrh...[pause=0] Vous ne pouvez rien faire de spécial avec ces provisions.[pause=0] Quelle tristesse !", "Sad")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_101']))
	else
	GeneralFunctions.StartConversation(chara, "Préparez-vous pour le donjon devant vous avec le rocher de Kangourex à côté de moi.")
		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_102']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_103'], STRINGS:Format("\\u266A")))
	end
	GeneralFunctions.EndConversation(chara)
end

function vast_steppe_entrance_ch_5.Mareep_Action(chara, activator)
	vast_steppe_entrance_ch_5.Mareep_Cranidos_Conversation(chara, activator)
end

function vast_steppe_entrance_ch_5.Cranidos_Action(chara, activator)
	vast_steppe_entrance_ch_5.Mareep_Cranidos_Conversation(chara, activator)
end

function vast_steppe_entrance_ch_5.Mareep_Cranidos_Conversation(chara, activator)
	local cranidos = CH('Cranidos')
	local mareep = CH('Mareep')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(mareep, 'None', true)
	GROUND:CharSetAnim(cranidos, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)

	GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

	UI:SetSpeaker(cranidos)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_104']))
    TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)

	UI:SetSpeaker(mareep)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_105'], cranidos:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(cranidos)
	GeneralFunctions.SetEmotion("Stunned")
	GROUND:CharSetEmote(cranidos, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_106']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_107'], CharacterEssentials.GetCharacterName("Growlithe")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_108']))

	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end




function vast_steppe_entrance_ch_5.FailedCutscene()

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local snubbull = CH('Teammate2')
	local audino = CH('Teammate3')
	local tropius = CH('Tropius')
	local noctowl = CH('Noctowl')
	local coro1, coro2, coro3

	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(partner, 264, 184, Direction.Right)
	GROUND:TeleportTo(hero, 232, 184, Direction.Left)

	GROUND:EntTurn(snubbull, Direction.Up)
	GROUND:EntTurn(audino, Direction.Up)

	GROUND:CharSetAnim(tropius, "Idle", true)
	GROUND:CharSetAnim(noctowl, "Idle", true)
	GAME:MoveCamera(256, 192, 1, false)

	if SV.Chapter5.DiedSteppe then
		GROUND:CharSetAnim(partner, "EventSleep", true)
		GROUND:CharSetAnim(hero, "EventSleep", true)

		GAME:FadeIn(40)
		SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
		GAME:WaitFrames(110)--slightly less than 120 frames so that the sleep animation doesnt barely start another frame before waking

		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Wake')
												GAME:WaitFrames(10)
												GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
												GAME:WaitFrames(40)
												GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Left)
												end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												GeneralFunctions.DoAnimation(partner, 'Wake')
												GAME:WaitFrames(15)
												GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
												GAME:WaitFrames(40)
												GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Right)
												end)
		TASK:JoinCoroutines({coro1, coro2})

		GAME:WaitFrames(30)

		coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
		coro2 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
		TASK:JoinCoroutines({coro1, coro2})
	elseif SV.Chapter5.EscapedSteppe then
		GROUND:EntTurn(hero, Direction.Down)
		GROUND:EntTurn(partner, Direction.Down)

		GAME:FadeIn(40)
		SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
		GAME:WaitFrames(20)
	end

	--todo: if snubbull gets eventsleep/wake animations, use them here.
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Pain')
	GROUND:CharSetEmote(partner, 'sweating', 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_109']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(snubbull)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_110'], CharacterEssentials.GetCharacterName("Breloom")))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	--GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_111']), {function() TASK:BranchCoroutine(function() GeneralFunctions.Hop(partner) end) end})
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_112'], CharacterEssentials.GetCharacterName("Noctowl")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_113']))

	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera()

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(audino, snubbull, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(snubbull, audino, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GROUND:CharEndAnim(tropius)
	GROUND:CharEndAnim(noctowl)
	SV.Chapter5.DiedSteppe = false
	SV.Chapter5.EscapedSteppe = false
	SV.Chapter5.NeedGiveSupplies = true

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	GAME:CutsceneMode(false)

end



function vast_steppe_entrance_ch_5.Dungeon_Entrance_Touch(obj, activator)

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local snubbull = CH('Teammate2')
	local audino = CH('Teammate3')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("vast_steppe")

	local result = false

	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	local coro1 = TASK:BranchCoroutine(function() result = GeneralFunctions.StartPartnerYesNo("Sommes-nous prêts à partir,[pause=10] " .. hero:GetDisplayName() .. " ?") end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharTurnToCharAnimated(audino, hero, 4) GROUND:CharSetAnim(audino, "None", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:CharTurnToCharAnimated(snubbull, hero, 4) GROUND:CharSetAnim(snubbull, "None", true) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(10)
	if result then
		GROUND:Hide('Dungeon_Entrance')

		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 264, 184, false, 1)
												GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
												GROUND:CharSetAnim(partner, "None", true) end)
		coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 232, 184, false, 1)
												GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
												GROUND:CharSetAnim(hero, "None", true) end)
		coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 256, 192) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})

		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(audino, 272, 216, false, 1)
												GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
												GROUND:CharSetAnim(audino, "None", true) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												GeneralFunctions.EightWayMove(snubbull, 224, 216, false, 1)
												GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
												GROUND:CharSetAnim(snubbull, "None", true) end)
		TASK:JoinCoroutines({coro1, coro2})


		UI:SetSpeaker(snubbull)


		if not SV.Chapter5.EnteredSteppe then
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_114'], STRINGS:Format("\\u266A")))
		else
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_115'], STRINGS:Format("\\u266A")))
		end


		GAME:WaitFrames(10)

		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
												GROUND:MoveInDirection(partner, Direction.Up, 100, false, 1) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
												GROUND:MoveInDirection(hero, Direction.Up, 100, false, 1) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
												GROUND:MoveInDirection(audino, Direction.Up, 90, false, 1) end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(26)
													  GROUND:MoveInDirection(snubbull, Direction.Up, 90, false, 1) end)
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)


		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

		GeneralFunctions.EndConversation(partner)
		SV.Chapter5.EnteredSteppe = true
		--Reset this flag if you go in case you go in without taking anything.
		SV.Chapter5.NeedGiveSupplies = false
		GAME:EnterDungeon("vast_steppe", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)


	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_116']))
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EndConversation(partner) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(snubbull, audino, 4) GROUND:CharEndAnim(snubbull) end)
		coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(audino, snubbull, 4) GROUND:CharEndAnim(audino) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
	end

end
--[[
function vast_steppe_entrance_ch_5.Oddish_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Salut, dame étrange ![pause=0] J'espère que tu vas bien ici ![pause=0]\nJe t'ai apporté des fleurs pour te remonter le moral !", "Happy", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_117']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSE5_118']))
	GeneralFunctions.EndConversation(chara)
end
]]--

--------------------------------------------------------------------
-- CINÉMATIQUE MAJEURE — « La Nuit où le Ciel a Tremblé »
-- Enjeu central de l'expédition : depuis le camp de la steppe, toute
-- l'expédition assiste au premier pulse du phénomène du sommet.
-- C'est LE moment où l'inquiétude descriptive devient réalité partagée.
-- Necrozma / l'Abîme ne sont pas nommés — on ne voit qu'une lumière et
-- une onde. Penticus prend sa décision devant tout le monde.
-- OST : silence -> Growing Anxiety -> Rising Fear -> Sympathy (retombée).
-- Déclencheur : première nuit après avoir vaincu le mini-boss steppe.
--------------------------------------------------------------------
function vast_steppe_entrance_ch_5.SkyTremorScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local tropius = CH('Tropius')
	local noctowl = CH('Noctowl')
	if tropius == nil or noctowl == nil then GAME:FadeIn(20) return end

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GROUND:AddMapStatus("darkness")

	-- Nuit au camp : chacun a sa place.
	GROUND:TeleportTo(hero, 270, 380, Direction.Up)
	GROUND:TeleportTo(partner, 330, 380, Direction.Up)
	GROUND:TeleportTo(tropius, 272, 272, Direction.Down)
	GROUND:TeleportTo(noctowl, 352, 280, Direction.DownLeft)
	if growlithe ~= nil then GROUND:TeleportTo(growlithe, 240, 340, Direction.UpRight) end
	if zigzagoon ~= nil then GROUND:TeleportTo(zigzagoon, 360, 340, Direction.UpLeft) end
	GAME:MoveCamera(300, 320, 1, false)

	GAME:FadeIn(60)
	GAME:WaitFrames(60)

	-- Calme avant. Une conversation ordinaire, presque douce.
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("La steppe est belle,[pause=10] la nuit.[pause=0] On dirait que les herbes respirent.")
	GeneralFunctions.HeroDialogue(hero, "(Première vraie nuit d'expédition...[pause=0] Si on m'avait dit,[pause=10] il y a quelques mois...)", "Happy")

	GAME:WaitFrames(40)

	-- PREMIER SIGNE : les Pokemon sauvages se taisent d'un coup.
	SOUND:FadeOutBGM(20)
	GAME:WaitFrames(50)
	if noctowl ~= nil then
		SOUND:PlayBattleSE("EVT_Emote_Confused")
		GROUND:CharSetEmote(noctowl, "question", 1)
		UI:SetSpeaker(noctowl)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("...Hou.[pause=0] Écoutez.")
		GAME:WaitFrames(30)
		UI:WaitShowDialogue("Les insectes.[pause=0] Les Hélédelle du bosquet.[pause=0] Le vent,[pause=10] même.[pause=0] TOUT s'est tu.")
	end

	SOUND:PlayBGM('Growing Anxiety.ogg', true)
	GAME:WaitFrames(30)

	if growlithe ~= nil then
		GROUND:CharSetEmote(growlithe, "shock", 1)
		SOUND:PlayBattleSE("EVT_Emote_Shock_2")
		UI:SetSpeaker(growlithe)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue("Wouf ![pause=0] Là ![pause=0] Au nord ![pause=0] REGARDEZ LE CIEL !")
	end

	-- LE PULSE : flash lointain + onde + tremblement. Toute la scene en VFX.
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, 60, 300, 240) end)
	TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)

	SOUND:PlayBattleSE("EVT_Battle_Flash")
	BossFX.Flash(300, 200, 4, 8, 40)
	GAME:WaitFrames(20)
	BossFX.Overlay("Cosmic_Power", 0, 0, 20, 90, 30, DrawLayer.Top)
	SOUND:PlayBattleSE("_UNK_EVT_102")
	BossFX.ShakeScreen(7, 40)
	GAME:WaitFrames(40)

	-- Reactions en cascade : chaque personnage a la sienne.
	if zigzagoon ~= nil then
		GROUND:CharSetEmote(zigzagoon, "sweating", 1)
		UI:SetSpeaker(zigzagoon)
		GeneralFunctions.SetEmotion("Shouting")
		UI:WaitShowDialogue("C'ÉTAIT QUOI ÇA ?![pause=0] La montagne vient de...[pause=10] de CLIGNER ?!")
	end

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue("Une lumière...[pause=0] jusqu'ici ?[pause=0] Le Mont Venteux est à des JOURS de marche !")

	GeneralFunctions.HeroDialogue(hero, "(Cette onde...[pause=0] je ne l'ai pas seulement vue.[pause=0] Je l'ai sentie passer À TRAVERS moi.)", "Surprised")

	SOUND:FadeOutBGM(30)
	GAME:WaitFrames(30)
	SOUND:PlayBGM('Rising Fear.ogg', true)

	-- Phileas met des mots. Penticus prend sa decision.
	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue("Hou...[pause=0] Les archives parlaient de «[pause=5] nuits où la montagne s'allume[pause=5] ».[pause=0] Je croyais à une image de poète.")
	UI:WaitShowDialogue("Ce n'était pas une image.[pause=0] C'était un COMPTE-RENDU.")

	GAME:WaitFrames(30)
	UI:SetSpeaker(tropius)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(30)
	UI:WaitShowDialogue("Écoutez-moi,[pause=10] tous.")
	UI:WaitShowDialogue("Ce que nous venons de voir,[pause=10] d'autres l'ont vu.[pause=0] À Metano.[pause=10] Dans les fermes.[pause=10] Partout.[pause=0] Et demain,[pause=10] la peur se mettra en route plus vite que nous.")
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue("Alors nous n'avons plus le droit d'échouer.[pause=0] Nous irons jusqu'au sommet.[pause=0] Nous découvrirons ce que c'est.[pause=0] Et nous reviendrons le dire.")
	UI:WaitShowDialogue("Pas pour la gloire de la guilde.[pause=0] Pour que chaque famille de la région puisse se coucher sans regarder le nord avec angoisse.")

	GAME:WaitFrames(30)
	if growlithe ~= nil then
		UI:SetSpeaker(growlithe)
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue("Wouf ![pause=0] À vos ordres ![pause=0] Jusqu'au sommet !")
	end
	if zigzagoon ~= nil then
		UI:SetSpeaker(zigzagoon)
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue("...Jusqu'au sommet.[pause=0] Et après,[pause=10] je rentre embrasser ma mère.[pause=0] Dans cet ordre précis.")
	end

	-- Retombee : Sympathy, le partenaire et le heros restent un instant.
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(40)
	SOUND:PlayBGM('Sympathy.ogg', true)
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue("" .. hero:GetDisplayName() .. "...[pause=0] Toi aussi tu l'as sentie,[pause=10] pas vrai ?[pause=0] L'onde.[pause=0] À l'intérieur.")
	GeneralFunctions.HeroDialogue(hero, "(Comme un battement de cœur.[pause=0] Un battement de cœur immense,[pause=10] et...[pause=10] irrégulier.)", "Worried")
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("Quoi que ce soit,[pause=10] là-haut...[pause=0] j'espère qu'on arrivera à temps.")

	GAME:WaitFrames(40)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(30)

	GROUND:RemoveMapStatus("darkness")
	SV.Chapter5.SkyTremorSceneSeen = true
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GAME:FadeIn(40)
end
