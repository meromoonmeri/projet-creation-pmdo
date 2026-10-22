require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

searing_tunnel_entrance_ch_5 = {}

function searing_tunnel_entrance_ch_5.SetupGround()
	if not SV.Chapter5.EnteredTunnel then
		local tropius, noctowl, mareep, cranidos, snubbull, audino, breloom, girafarig, tail =
		CharacterEssentials.MakeCharactersFromList({
			{'Tropius', 336, 112, Direction.Down},
			{'Noctowl', 224, 80, Direction.Down},
			{'Mareep', 276, 260, Direction.UpLeft},
			{'Cranidos', 240, 260, Direction.UpRight},
			{'Snubbull', 276, 224, Direction.DownLeft},
			{'Audino', 240, 224, Direction.DownRight},
			{'Breloom', 144, 80, Direction.DownLeft},
			{'Girafarig', 120, 104, Direction.UpRight}
		})

		--set rin and coco to spawn from the spawners, then spawn them
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		local growlithe = GROUND:SpawnerDoSpawn("TEAMMATE_2")

		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		local zigzagoon = GROUND:SpawnerDoSpawn("TEAMMATE_3")

	else
		local noctowl, tropius =
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 192, 80, Direction.Down},
			{'Tropius', 376, 128, Direction.Down}
		})

		--Noctowl catches his sleep now since Tropius has supply duty handled.
		GROUND:CharSetAnim(noctowl, "Sleep", true)

		--set rin and coco to spawn from the spawners, then spawn them
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		local growlithe = GROUND:SpawnerDoSpawn("TEAMMATE_2")

		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		local zigzagoon = GROUND:SpawnerDoSpawn("TEAMMATE_3")

		--teleport them to their new spot depending on where they should be.
		if SV.Chapter5.TunnelLastExitReason == 'Retreated' then
			GROUND:TeleportTo(growlithe, 440, 172, Direction.Down)
			GROUND:TeleportTo(zigzagoon, 440, 198, Direction.Up)
		else
			GROUND:TeleportTo(growlithe, 360, 152, Direction.Right)
			GROUND:TeleportTo(zigzagoon, 392, 152, Direction.Left)
		end
	end
end


--this is one long ass continuous cutscene
--TASK:BranchCoroutine(searing_tunnel_entrance_ch_5.ArrivalDinnerNightAndAddressCutscene)
function searing_tunnel_entrance_ch_5.ArrivalDinnerNightAndAddressCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local tunnel = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('searing_tunnel')
	local steppe = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('vast_steppe')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GAME:MoveCamera(160, 168, 1, false)
	GROUND:AddMapStatus("dusk")--dusk

	--for debug purposes
	GAME:FadeOut(false, 1)

	local hay_bed = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)

	GROUND:TeleportTo(hero, -32, 144, Direction.Right)
	GROUND:TeleportTo(partner, -32, 176, Direction.Right)

	local audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos =
	CharacterEssentials.MakeCharactersFromList({
		{'Audino', -64, 184, Direction.Right},
		{'Snubbull', -64, 136, Direction.Right},
		{'Girafarig', 254, 141, Direction.Right},
		{'Breloom', 181, 195, Direction.DownLeft},
		{'Growlithe'},
		{'Zigzagoon'},
		{'Tropius'},
		{'Noctowl'},
		{'Mareep'},
		{'Cranidos'}
	})

	GROUND:CharSetAnim(breloom, "Idle", true)
	GROUND:CharSetAnim(girafarig, "Idle", true)

	--if you failed in the steppe at all, you get here later than Ganlon's team.
	if SV.Chapter5.LostSteppe then
		GROUND:Unhide('Cranidos')
		GROUND:Unhide('Mareep')
		GROUND:Unhide('Growlithe')
		GROUND:Unhide('Zigzagoon')

		GROUND:TeleportTo(cranidos, 120, 96, Direction.UpRight)
		GROUND:TeleportTo(mareep, 144, 72, Direction.DownLeft)
		GROUND:CharSetAnim(mareep, "Idle", true)
		AI:SetCharacterAI(mareep, "halcyon.ai.ground_talking", false, 60, 60, 0, false, 'Default', {cranidos})

		GROUND:TeleportTo(zigzagoon, 224, 200, Direction.UpRight)
		GROUND:TeleportTo(growlithe, 248, 176, Direction.DownLeft)
		GROUND:CharSetAnim(zigzagoon, "Idle", true)
		GROUND:CharSetAnim(growlithe, "Idle", true)
		AI:SetCharacterAI(growlithe, "halcyon.ai.ground_talking", false, 60, 60, 0, false, 'Default', {zigzagoon})
	end

	--This is done like this so I can copy and paste this code into other scenes that have a similar set up and only change one value
	--to get all the beds and campfire to spawn relative to that spot.
	local bedRelativeX = 114
	local bedRelativeY = 84
	local bed1X, bed6X = bedRelativeX + 78, bedRelativeX + 78
	local bed2X, bed5X = bedRelativeX + 123, bedRelativeX + 123
	local bed3X, bed4X = bedRelativeX + 156, bedRelativeX + 156
	local bed7X, bed10X = bedRelativeX + 33, bedRelativeX + 33
	local bed8X, bed9X = bedRelativeX, bedRelativeX

	local bed11X, bed11Y = 312, 108
	local bed12X, bed12Y = 344, 132

	local bed1Y = bedRelativeY
	local bed2Y, bed10Y = bedRelativeY + 11, bedRelativeY + 11
	local bed3Y, bed9Y = bedRelativeY + 44, bedRelativeY + 44
	local bed4Y, bed8Y = bedRelativeY + 84, bedRelativeY + 84
	local bed5Y, bed7Y = bedRelativeY + 117, bedRelativeY + 117
	local bed6Y = bedRelativeY + 128


	--Beds. Start with top center, go clockwise, then do the two off to the side.
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed1X, bed1Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed2X, bed2Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed3X, bed3Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed4X, bed4Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed5X, bed5Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed6X, bed6Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed7X, bed7Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed8X, bed8Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed9X, bed9Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed10X, bed10Y)))

	--bed 11/12 are a bit more free form in where they go.
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed11X, bed11Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed12X, bed12Y)))


	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_001'], steppe:GetColoredName()))
	GAME:WaitFrames(20)
	UI:SetSpeaker(snubbull)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_002']))
	GAME:WaitFrames(20)

	GAME:FadeIn(40)
	SOUND:PlayBGM('At the End of the Day.ogg', true)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 92, 176, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames (10) GROUND:MoveToPosition(hero, 92, 144, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GROUND:MoveToPosition(audino, 60, 184, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:MoveToPosition(snubbull, 60, 136, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_003']))

	GAME:WaitFrames(20)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(breloom, "exclaim", 1)
											GROUND:CharEndAnim(breloom)
											GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharSetEmote(girafarig, "notice", 1)
											GAME:WaitFrames(20)
											GROUND:CharEndAnim(girafarig)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharEndAnim(cranidos)
											GROUND:CharAnimateTurnTo(cranidos, Direction.DownLeft, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharEndAnim(mareep)
											AI:DisableCharacterAI(mareep)
											GROUND:CharSetEmote(mareep, "", 0)
											GROUND:CharAnimateTurnTo(mareep, Direction.DownLeft, 4) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharEndAnim(zigzagoon)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharEndAnim(growlithe)
											AI:DisableCharacterAI(growlithe)
											GROUND:CharSetEmote(growlithe, "", 0)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})

	GAME:WaitFrames(10)
	UI:SetSpeaker(girafarig)
	GeneralFunctions.SetEmotion("Happy")
	if SV.Chapter5.LostSteppe then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_004']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_005']))
	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_006']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_007']))
	end

	GAME:WaitFrames(20)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_008']))
	if SV.Chapter5.LostSteppe then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_009'], noctowl:GetDisplayName()))
	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_010']))
	end
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_011']))


	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_012'], breloom:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(snubbull)
	GeneralFunctions.SetEmotion("Special0")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(snubbull, Direction.DownRight, 4)
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_201'])) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(breloom, Direction.DownLeft, 4)
											GROUND:CharSetAnim(breloom, "Idle", true) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Right, 4)
											GROUND:CharSetAnim(girafarig, "Idle", true) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharTurnToCharAnimated(cranidos, mareep, 4) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
											GROUND:CharSetAnim(mareep, "Idle", true) end)
	local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4)
												  GROUND:CharSetAnim(zigzagoon, "Idle", true) end)
	local coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
												   GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4)
												   GROUND:CharSetAnim(growlithe, "Idle", true) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_013']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(snubbull)
	GeneralFunctions.SetEmotion("Special0")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_014'], STRINGS:Format("\\u266A")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_015'], STRINGS:Format("\\uE0A3")))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_016'], hero:GetDisplayName(), partner:GetDisplayName(), audino:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_017'], STRINGS:Format("\\u266A")))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_018']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(snubbull)
	GeneralFunctions.SetEmotion("Special0")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_019']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_020'], STRINGS:Format("\\u266A")))


	GAME:WaitFrames(10)
	UI:SetSpeaker(audino)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(snubbull, Direction.UpRight, 4)
											GeneralFunctions.EightWayMove(snubbull, 352, 112, false, 1)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(60)
											GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_021']))
											GeneralFunctions.SetEmotion("Sigh")
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_022']))
											GAME:WaitFrames(20)
											GeneralFunctions.SetEmotion("Normal")
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_202'])) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(70)
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(76)
											GROUND:CharAnimateTurnTo(hero, Direction.DownLeft, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_024']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_025']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_026']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_028']))
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(audino, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_029'], snubbull:GetDisplayName()))
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(audino, "", 0)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_030']))

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_031'], hero:GetDisplayName()))
	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_032']))
	GROUND:CharTurnToCharAnimated(partner, audino, 4)
	GROUND:CharTurnToCharAnimated(hero, audino, 4)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_033'], audino:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_034']))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
											GeneralFunctions.EightWayMove(partner, 352, 160, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
											GROUND:CharAnimateTurnTo(hero, Direction.DownRight, 4)
											GeneralFunctions.EightWayMove(hero, 352, 160, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(36)
											--GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)
											GeneralFunctions.EightWayMove(audino, 352, 160, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(120)
											SOUND:FadeOutBGM(60)
											GAME:FadeOut(false, 60) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(80)

	--unhide them if they didn't get here before you
	if not SV.Chapter5.LostSteppe then
		GROUND:Unhide('Cranidos')
		GROUND:Unhide('Mareep')
		GROUND:Unhide('Growlithe')
		GROUND:Unhide('Zigzagoon')
	end

	GROUND:Unhide('Tropius')
	GROUND:Unhide('Noctowl')

	GROUND:CharSetAnim(hero, "Eat", true)
	GROUND:CharSetAnim(partner, "Eat", true)
	GROUND:CharSetAnim(tropius, "Eat", true)
	GROUND:CharSetAnim(noctowl, "Eat", true)
	GROUND:CharSetAnim(cranidos, "Eat", true)
	GROUND:CharSetAnim(mareep, "Eat", true)
	GROUND:CharSetAnim(girafarig, "Eat", true)
	GROUND:CharSetAnim(breloom, "Eat", true)
	GROUND:CharSetAnim(audino, "Eat", true)
	GROUND:CharSetAnim(snubbull, "Eat", true)
	GROUND:CharSetAnim(growlithe, "Eat", true)
	GROUND:CharSetAnim(zigzagoon, "Eat", true)

	GROUND:CharSetEmote(hero, "eating", 0)
	GROUND:CharSetEmote(partner, "eating", 0)
	GROUND:CharSetEmote(tropius, "eating", 0)
	GROUND:CharSetEmote(noctowl, "eating", 0)
	GROUND:CharSetEmote(cranidos, "eating", 0)
	GROUND:CharSetEmote(mareep, "eating", 0)
	GROUND:CharSetEmote(girafarig, "eating", 0)
	GROUND:CharSetEmote(breloom, "eating", 0)
	GROUND:CharSetEmote(audino, "eating", 0)
	GROUND:CharSetEmote(snubbull, "eating", 0)
	GROUND:CharSetEmote(growlithe, "eating", 0)
	GROUND:CharSetEmote(zigzagoon, "eating", 0)

	--add 13 to x of the bed, 10 to y of the bed to get where the characters should sit.
	GROUND:TeleportTo(hero, bed1X + 13, bed1Y + 10, Direction.Down)
	GROUND:TeleportTo(partner, bed2X + 13, bed2Y + 10, Direction.Down)
	GROUND:TeleportTo(growlithe, bed3X + 13, bed3Y + 10, Direction.Down)
	GROUND:TeleportTo(zigzagoon, bed4X + 13, bed4Y + 10, Direction.Up)
	GROUND:TeleportTo(audino, bed5X + 13, bed5Y + 10, Direction.Up)
	GROUND:TeleportTo(snubbull, bed6X + 13, bed6Y + 10, Direction.Up)
	GROUND:TeleportTo(mareep, bed7X + 13, bed7Y + 10, Direction.Up)
	GROUND:TeleportTo(cranidos, bed8X + 13, bed8Y + 10, Direction.Up)
	GROUND:TeleportTo(girafarig, bed9X + 13, bed9Y + 10, Direction.Left)
	GROUND:TeleportTo(breloom, bed10X + 13, bed10Y + 10, Direction.Down)
	GROUND:TeleportTo(tropius, bed11X + 13, bed11Y + 10, Direction.Down)
	GROUND:TeleportTo(noctowl, bed12X + 13, bed12Y + 10, Direction.Down)

	--spawn in food
	local food1 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0),
													RogueElements.Rect(bed1X + 13, bed1Y + 22, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food1")
	local food2 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0),
													RogueElements.Rect(bed2X + 13, bed2Y + 22, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food2")
	local food3 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0),
													RogueElements.Rect(bed3X + 13, bed3Y + 22, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food3")
	local food4 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0),
													RogueElements.Rect(bed4X + 13, bed4Y, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food4")
	local food5 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0),
													RogueElements.Rect(bed5X + 13, bed5Y, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food5")
	local food6 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0),
													RogueElements.Rect(bed6X + 13, bed6Y, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food6")
	local food7 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0),
													RogueElements.Rect(bed7X + 13, bed7Y, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food7")
	local food8 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0),
													RogueElements.Rect(bed8X + 13, bed8Y, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food8")
	local food9 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0),
													RogueElements.Rect(bed9X + 13, bed9Y + 22, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food9")
	local food10 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0),
													RogueElements.Rect(bed10X + 13, bed10Y + 22, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food10")
	local food11 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ItemAnimData("Banana_Yellow", 1, 0, 0), --itemanimdata for the banana instead!
													RogueElements.Rect(bed11X + 13, bed11Y + 22, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food11")
	local food12 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0),
													RogueElements.Rect(bed12X + 13, bed12Y + 22, 16, 16),
													RogueElements.Loc(0, 0),
													false,
													"Food12")

	food1:ReloadEvents()
	food2:ReloadEvents()
	food3:ReloadEvents()
	food4:ReloadEvents()
	food5:ReloadEvents()
	food6:ReloadEvents()
	food7:ReloadEvents()
	food8:ReloadEvents()
	food9:ReloadEvents()
	food10:ReloadEvents()
	food11:ReloadEvents()
	food12:ReloadEvents()

	GAME:GetCurrentGround():AddTempObject(food1)
	GAME:GetCurrentGround():AddTempObject(food2)
	GAME:GetCurrentGround():AddTempObject(food3)
	GAME:GetCurrentGround():AddTempObject(food4)
	GAME:GetCurrentGround():AddTempObject(food5)
	GAME:GetCurrentGround():AddTempObject(food6)
	GAME:GetCurrentGround():AddTempObject(food7)
	GAME:GetCurrentGround():AddTempObject(food8)
	GAME:GetCurrentGround():AddTempObject(food9)
	GAME:GetCurrentGround():AddTempObject(food10)
	GAME:GetCurrentGround():AddTempObject(food11)
	GAME:GetCurrentGround():AddTempObject(food12)

	--GAME:MoveCamera(160, 168, 1, false)

	local stopEating = false
	UI:SetSpeaker('', false, "", -1, "", RogueEssence.Data.Gender.Unknown)
	SOUND:LoopSE('Dinner Eating')
	local coro1 = TASK:BranchCoroutine(function() GAME:FadeIn(40) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:MoveCamera(248, 168, 180, false)
												  GAME:WaitFrames(120)
												  stopEating = true end)
	local coro3 = TASK:BranchCoroutine(function() while not stopEating do
													UI:WaitShowTimedDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_213']), 6)
												  end
												  SOUND:FadeOutSE('Dinner Eating', 120)
												  GAME:FadeOut(false, 120)  end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(60)

	GAME:GetCurrentGround():RemoveTempObject(food1)
	GAME:GetCurrentGround():RemoveTempObject(food2)
	GAME:GetCurrentGround():RemoveTempObject(food3)
	GAME:GetCurrentGround():RemoveTempObject(food4)
	GAME:GetCurrentGround():RemoveTempObject(food5)
	GAME:GetCurrentGround():RemoveTempObject(food6)
	GAME:GetCurrentGround():RemoveTempObject(food7)
	GAME:GetCurrentGround():RemoveTempObject(food8)
	GAME:GetCurrentGround():RemoveTempObject(food9)
	GAME:GetCurrentGround():RemoveTempObject(food10)
	GAME:GetCurrentGround():RemoveTempObject(food11)
	GAME:GetCurrentGround():RemoveTempObject(food12)

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(tropius)
	GROUND:CharEndAnim(noctowl)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(snubbull)
	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)

	GROUND:CharSetEmote(hero, "", 0)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(noctowl, "", 0)
	GROUND:CharSetEmote(cranidos, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(girafarig, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	GROUND:CharSetEmote(snubbull, "", 0)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)

	GROUND:CharTurnToChar(hero, partner)
	GROUND:CharTurnToChar(partner, hero)
	GROUND:CharTurnToChar(growlithe, zigzagoon)
	GROUND:CharTurnToChar(zigzagoon, growlithe)

	GROUND:TeleportTo(breloom, 357, 174, Direction.Up)

	GROUND:CharSetAnim(tropius, "Sleep", true)
	GAME:WaitFrames(6)--to desync their breathing
	GROUND:CharSetAnim(cranidos, "Sleep", true)
	GAME:WaitFrames(6)
	GROUND:CharSetAnim(mareep, "EventSleep", true)
	GAME:WaitFrames(8)
	GROUND:CharSetAnim(girafarig, "Sleep", true)
	GAME:WaitFrames(6)
	GROUND:CharSetAnim(audino, "EventSleep", true)
	GAME:WaitFrames(4)
	GROUND:CharSetAnim(snubbull, "Sleep", true)

	GROUND:CharSetAnim(partner, "Idle", true)
	GROUND:CharSetAnim(hero, "Idle", true)
	GROUND:CharSetAnim(zigzagoon, "Idle", true)
	GROUND:CharSetAnim(growlithe, "Idle", true)

	--set it to night with a nice little camp fire
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(bedRelativeX + 80, bedRelativeY + 62)))
	GROUND:RemoveMapStatus("dusk")
	GROUND:AddMapStatus("darkness")


	--Kino tells you to sleep. Also says that Phileas is still up to help guard. he doesnt need much sleep and he's best adapted for keeping watch at night
	--partner, hero, growlithe, and zigzagoon discuss the fun they've been having.
	--talk about their partners. talk about what might be at the end of the expedition
	--it's zigzagoon's first expedition, but growlithe has been with the guild as long as he can remember so he's been on them before (though not when he was young)
	--they eventually decide to go to sleep, partner and hero chat briefly, partner goes to sleep. Hero thinks about the strange feeling getting stronger.
	--Hasn't brought it up because there hasn't been much reason to (could be more bullshit)
	--eventually decides he needs to get some rest and goes to sleep.
	GAME:FadeIn(40)
	SOUND:LoopSE('AMB_Fire_Loud')

	GAME:WaitFrames(40)
	GROUND:CharSetAnim(breloom, "Idle", true)
	GAME:WaitFrames(60)
	GROUND:CharEndAnim(breloom)

	GAME:WaitFrames(20)
	--freeze phileas briefly in the first frame of his sleep animation to simulate him nodding
	--TODO: Improve this scene with more animations if they're made for breloom or noctowl
	GROUND:CharSetAction(noctowl, RogueEssence.Ground.FrameGroundAction(noctowl.Position, noctowl.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep"), 0))
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(noctowl)
	GAME:WaitFrames(30)

	--expeditionTODO: Make this camera movement cleaner
	GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4)
	GeneralFunctions.EightWayMoveRS(breloom, 312, 158, false, 1)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(breloom, 240, 144, false, 1)
											GROUND:CharAnimateTurnTo(breloom, Direction.UpRight, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(28)
											GAME:MoveCamera(264, 168, 16, false)
											GAME:MoveCamera(264, 140, 28, false)
											end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_035']))

	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharEndAnim(partner) GROUND:CharTurnToCharAnimated(partner, breloom, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharEndAnim(hero) GROUND:CharTurnToCharAnimated(hero, breloom, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:CharEndAnim(growlithe) GROUND:CharTurnToCharAnimated(growlithe, breloom, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:CharEndAnim(zigzagoon) GROUND:CharTurnToCharAnimated(zigzagoon, breloom, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(10)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_036']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_203'], breloom:GetDisplayName()))
											GeneralFunctions.SetEmotion("Happy")
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_037']))
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharTurnToCharAnimated(breloom, zigzagoon, 4)
											end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_038'], breloom:GetDisplayName(), noctowl:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_039']))
	GAME:WaitFrames(12)

	GROUND:CharTurnToCharAnimated(breloom, partner, 4)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_040'], noctowl:GetDisplayName(), _DATA:GetMonster('noctowl'):GetColoredName()))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_041']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_042']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_043']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_044'], breloom:GetDisplayName()))

	--GAME:WaitFrames(12)
	--GROUND:CharTurnToCharAnimated(breloom, growlithe, 4)
	--UI:SetSpeaker(breloom)
	--GeneralFunctions.SetEmotion("Happy")
	--UI:WaitShowDialogue("Sleep tight![pause=0] Make sure you don't stay up too much longer.")

	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Joyous")
	--todo: improve breloom animations here if animations get added.
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4)
											GROUND:CharSetEmote(growlithe, "glowing", 0)
											--UI:WaitShowDialogue("I dunno how I'm gonna get to sleep,[pause=10] ruff![pause=0] I'm still too[script=0] worked up![pause=0] Today was so much fun!", {function() TASK:BranchCoroutine(function() GROUND:CharSetAction(breloom, RogueEssence.Ground.FrameGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep"), 0)) end) end})
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_045']))
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharTurnToCharAnimated(partner, growlithe, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4)
											GeneralFunctions.EightWayMove(breloom, 192, 120, false, 1)
											GeneralFunctions.EightWayMoveRS(breloom, bed10X + 13, bed10Y + 10, false, 1)
											GROUND:CharAnimateTurnTo(breloom, Direction.Down, 4)
											end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")

	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_204'], audino:GetDisplayName(), snubbull:GetDisplayName()))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_046']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_047']))
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:CharTurnToCharAnimated(growlithe, partner, 4 ) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4 ) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) 	--kino lies down here, but doesn't fall asleep immediately
											GROUND:CharSetAction(breloom, RogueEssence.Ground.FrameGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep"), 0))
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_048'], mareep:GetDisplayName(), cranidos:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_049']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_050']))
	--these notes are gonna be about movement speed in his almanac later. Also L-Shaped positioning

	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_051']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_052']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_053']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_054']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_055'], partner:GetDisplayName(), hero:GetDisplayName()))
	--really excited to see who we get to team up with tomorrow

	GAME:WaitFrames(20)
	--hero zones out
	GROUND:EntTurn(hero, Direction.Down)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_056']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_057']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_058']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_059']))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_060']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_061']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_062']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_063']))

	--use this to flag the side conversation to stop
	local stopTalking = false

	SOUND:FadeOutSE('AMB_Fire_Loud', 60)
	GAME:WaitFrames(20)
	--he falls asleep
	GROUND:CharSetAnim(breloom, "Sleep", true)
	GAME:WaitFrames(10)
	GAME:MoveCamera(213, 140, 51, false)
	GAME:WaitFrames(20)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Worried")
	--hero zones out during this conversation
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_205']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_064']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_065'], breloom:GetDisplayName(), girafarig:GetDisplayName()))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_066']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_067']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_068']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_069']))
											stopTalking = true
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_070']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_071']), {function() TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "question", 1) end) end})
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_072']), {function() TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "happy", 3) end) end})
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_073']), {function() TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "happy", 3) end) end})
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											while not stopTalking do
												GROUND:CharSetAnim(zigzagoon, "Idle", true)
												GROUND:CharSetEmote(zigzagoon, "happy", 0)
												GAME:WaitFrames(60)
												GROUND:CharEndAnim(zigzagoon)
												GROUND:CharSetEmote(zigzagoon, "", 0)
												GAME:WaitFrames(40)
												if stopTalking then break end

												GROUND:CharSetAnim(partner, "Idle", true)
												GROUND:CharSetEmote(partner, "happy", 0)
												GAME:WaitFrames(60)
												GROUND:CharEndAnim(partner)
												GROUND:CharSetEmote(partner, "", 0)
												GAME:WaitFrames(40)
												if stopTalking then break end

												GROUND:CharSetAnim(growlithe, "Idle", true)
												GROUND:CharSetEmote(growlithe, "happy", 0)
												GAME:WaitFrames(60)
												GROUND:CharEndAnim(growlithe)
												GROUND:CharSetEmote(growlithe, "", 0)
												GAME:WaitFrames(40)

											end

											GROUND:CharTurnToCharAnimated(partner, hero, 4)
											GROUND:CharTurnToCharAnimated(growlithe, hero, 4)
											GROUND:CharTurnToCharAnimated(zigzagoon, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	SOUND:FadeInSE('AMB_Fire_Loud', 60)
	GAME:WaitFrames(30)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_074'], hero:GetDisplayName()))

	GAME:WaitFrames(10)
	GROUND:CharSetEmote(partner, "", 0)
	GeneralFunctions.EmoteAndPause(hero, "Exclaim", true)
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_075']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_076']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, growlithe, 4)
	GROUND:CharTurnToCharAnimated(hero, zigzagoon, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_077']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_078']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_079']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_080']))

	GAME:WaitFrames(60)
	SOUND:FadeOutSE('AMB_Fire_Loud', 60)
	GAME:FadeOut(false, 60)

	GAME:WaitFrames(120)


	--setup things for the morning
	GROUND:CharSetAnim(zigzagoon, 'EventSleep', true)
	GROUND:CharSetAnim(growlithe, 'Sleep', true)
	GROUND:CharSetAnim(hero, 'EventSleep', true)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(tropius)

	GROUND:TeleportTo(audino, 205, 158, Direction.Down)
	GROUND:TeleportTo(tropius, 312, 152, Direction.Left)
	GROUND:TeleportTo(noctowl, 336, 176, Direction.Left)

	GROUND:EntTurn(zigzagoon, Direction.Right)
	GROUND:EntTurn(hero, Direction.Right)
	GROUND:EntTurn(partner, Direction.Left)
	GROUND:EntTurn(growlithe, Direction.Down)

	GAME:MoveCamera(212, 160, 1, false)


	--cleanup things for the morning
	--remove the fire, remove darkness
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(12)
	GROUND:RemoveMapStatus("darkness")

	UI:SetAutoFinish(true)
	UI:WaitShowVoiceOver("Le lendemain matin...\n\n", -1)
	UI:SetAutoFinish(false)



	GAME:WaitFrames(60)
	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_081']))
	GAME:FadeIn(40)
	GAME:WaitFrames(20)

	SOUND:PlayBattleSE("DUN_Heal_Bell")
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GAME:WaitFrames(100)
	GROUND:CharEndAnim(audino)
	GAME:WaitFrames(20)

	--Everyone wakes up, besides Kino
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.Shake(hero)
											GAME:WaitFrames(20)
											GeneralFunctions.DoAnimation(hero, 'Wake')
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(hero, audino, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.Shake(partner)
											GAME:WaitFrames(20)
											GeneralFunctions.DoAnimation(partner, 'Wake')
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(partner, audino, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.Shake(zigzagoon)
											GAME:WaitFrames(20)
											GeneralFunctions.DoAnimation(zigzagoon, 'Wake')
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(zigzagoon, audino, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GeneralFunctions.Shake(growlithe)
											GAME:WaitFrames(70)
											GROUND:CharEndAnim(growlithe)
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(growlithe, audino, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GeneralFunctions.Shake(snubbull)
											GAME:WaitFrames(90)
											GROUND:CharEndAnim(snubbull)
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(snubbull, audino, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.Shake(mareep)
											GAME:WaitFrames(20)
											GeneralFunctions.DoAnimation(mareep, 'Wake')
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(mareep, audino, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GeneralFunctions.Shake(cranidos)
											GAME:WaitFrames(10)
											GeneralFunctions.Shake(cranidos)
											GAME:WaitFrames(70)
											GROUND:CharEndAnim(cranidos)
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(cranidos, audino, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.Shake(girafarig)
											GAME:WaitFrames(80)
											GROUND:CharEndAnim(girafarig)
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(girafarig, audino, 4)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	SOUND:PlayBGM("Do Your Best, As Always!.ogg", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_082']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_083']))

	GAME:WaitFrames(40)
	GeneralFunctions.EmoteAndPause(audino, "Notice", true)
	GROUND:CharTurnToCharAnimated(audino, breloom, 4)
	GAME:WaitFrames(10)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_084'], breloom:GetDisplayName()))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_085'], breloom:GetDisplayName()))

	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(audino, 160, 144, false, 1)
											GeneralFunctions.EightWayMove(audino, 160, 121, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, audino, 4, Direction.DownLeft) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, audino, 4, Direction.Left) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(cranidos, audino, 4, Direction.Up) end)
	coro5 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(mareep, audino, 4, Direction.Up) end)
	coro6 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(zigzagoon, audino, 4, Direction.UpLeft) end)
	coro7 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(girafarig, audino, 4, Direction.UpRight) end)
	coro8 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(snubbull, audino, 4, Direction.UpLeft) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	GAME:WaitFrames(10)
	GeneralFunctions.Complain(audino)
	GeneralFunctions.SetEmotion("Shouting")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_086'], breloom:GetDisplayName()))
	GAME:WaitFrames(20)

	SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true)
	UI:SetSpeaker(breloom)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_087']))
	GAME:WaitFrames(20)

	GeneralFunctions.EmoteAndPause(audino, "Sweatdrop", true)
	GAME:WaitFrames(10)
	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_088']))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(audino, Direction.DownRight, 4)
	--GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_089']))
	GAME:WaitFrames(40)

	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)

	GROUND:CharEndAnim(breloom)

	GROUND:TeleportTo(tropius, 320, 120, Direction.Down)
	GROUND:TeleportTo(noctowl, 280, 128, Direction.Down)

	GROUND:TeleportTo(partner, 256, 160, Direction.UpRight)
	GROUND:TeleportTo(hero, 256, 192, Direction.UpRight)

	GROUND:TeleportTo(breloom, 288, 160, Direction.Up)
	GROUND:TeleportTo(girafarig, 288, 192, Direction.Up)

	GROUND:TeleportTo(snubbull, 320, 160, Direction.Up)
	GROUND:TeleportTo(audino, 320, 192, Direction.Up)

	GROUND:TeleportTo(mareep, 352, 160, Direction.Up)
	GROUND:TeleportTo(cranidos, 352, 192, Direction.Up)

	GROUND:TeleportTo(growlithe, 384, 160, Direction.UpLeft)
	GROUND:TeleportTo(zigzagoon, 384, 192, Direction.UpLeft)

	GeneralFunctions.CenterCamera({snubbull, tropius})

	--remove beds
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)

	GAME:WaitFrames(60)

	GAME:FadeIn(40)
	SOUND:PlayBGM("Spring Cave.ogg", true)

	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_090']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_091'], tunnel:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_092']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_093'], ruins:GetColoredName()))
	GAME:WaitFrames(20)
	GROUND:CharTurnToChar(tropius, breloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_094'], breloom:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_095']))
	GAME:WaitFrames(10)

	--coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
	--										GROUND:MoveInDirection(breloom, Direction.Up, 16, false, 1)
	--										GROUND:CharAnimateTurnTo(breloom, Direction.Down, 4)
	--										end)
	--coro2 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(noctowl, "Walk", Direction.Down, Direction.Up, 8, 1, 1) end)

	--TASK:JoinCoroutines({coro1, coro2})


	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_206']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_096']))
											GeneralFunctions.SetEmotion("Worried")
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_097']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_098']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_099']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_100']))
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(mareep, Direction.Left, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(audino, Direction.UpLeft, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
											end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9})

	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GROUND:EntTurn(tropius, Direction.Down)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_207']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_101']))
											--UI:WaitShowDialogue("Maybe i make a comment about the unstability being especially worrying") --KINO will comment on the instability being strange. Tropius doesn't need to be the one to foreshadow every time, too spoonfeedy i think.
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_102']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_103'], noctowl:GetDisplayName()))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_104']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_105'], mareep:GetDisplayName(), cranidos:GetDisplayName(), audino:GetDisplayName(), snubbull:GetDisplayName()))
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
											end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4)
											end)
	--coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
	--										GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	--										end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.DownLeft, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Right, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(breloom, Direction.Right, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Right, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_106']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(cranidos)
	UI:WaitShowTimedDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_214']), 40)
	GAME:WaitFrames(20)

	GeneralFunctions.DoubleHop(mareep)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetAnim(mareep, "Idle", true)
	UI:SetSpeaker(mareep)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_107']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_108'], cranidos:GetDisplayName()))
	GAME:WaitFrames(20)

	GROUND:CharEndAnim(mareep)
	GROUND:CharSetEmote(mareep, "", 0)
	UI:SetSpeaker(cranidos)
	GeneralFunctions.SetEmotion("Surprised")
	GROUND:CharSetEmote(cranidos, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_109']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_208'], partner:GetDisplayName(), hero:GetDisplayName(), zigzagoon:GetDisplayName(), growlithe:GetDisplayName()))
								 end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
											end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
											end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4) end)
	local coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11})

	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Right, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.Right, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Left, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(breloom, Direction.DownLeft, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_110']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_111']))
	GAME:WaitFrames(40)


	GROUND:CharTurnToChar(tropius, growlithe)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_209'], growlithe:GetDisplayName()))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_112']))
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											 GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4) end)
	coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											 GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11})
	GAME:WaitFrames(20)

	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_113'], tropius:GetDisplayName()))
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(tropius, partner, 4)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_114'], zigzagoon:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	--GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_115']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_116']))
	GAME:WaitFrames(30)

	GROUND:EntTurn(tropius, Direction.Down)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_117']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_118']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_119'], ruins:GetColoredName()))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_120']))
	GAME:WaitFrames(20)

	--well we have our team. Let's get ready and roll out.
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
	GROUND:EntTurn(breloom, Direction.Up)
	GROUND:EntTurn(girafarig, Direction.Up)
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
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_121']))

	GAME:WaitFrames(60)
	GAME:FadeOut(false, 60)

	--Clean up the existing spawns, then call SetupGround to spawn them in.
	--Record the level of Rin and Coco for later use. Check to make sure they exist before doing so (mostly just so I can run this scene without needing them in the party)
	if GAME:GetPlayerPartyCount() > 2 then
		SV.GuildSidequests.SnubbullLevel = GAME:GetPlayerPartyMember(2).Level
		SV.GuildSidequests.AudinoLevel = GAME:GetPlayerPartyMember(3).Level
	end

	--Default the party DESTRUCTIVELY to delete Rin and Coco.
	GeneralFunctions.DefaultParty(false, true)
	--reinitialize the hero and partner variables after respawning the party.
	--Failing to do this has later functions try to teleport the "old" versions of them, causing a phantom glitch. dunno why, since i thought i fixed default party...
	hero = CH('PLAYER')
	partner = CH('Teammate1')
	partner.CollisionDisabled = true

	--Setup Hyko and Almotz.
	local growlithe_id = RogueEssence.Dungeon.MonsterID("growlithe", 0, "normal", Gender.Male)
	local growlithe_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, growlithe_id, SV.GuildSidequests.GrowlitheLevel, "flash_fire", 0)
	growlithe_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	growlithe_monster.Nickname = CharacterEssentials.GetCharacterName('Growlithe', true)
	growlithe_monster.MetAt = "Adventurer's Guild"
	growlithe_monster.IsPartner = true
	growlithe_monster.IsFounder = true

	growlithe_monster:ReplaceSkill("flame_wheel", 0, true)
	growlithe_monster:ReplaceSkill("bite", 1, true)
	growlithe_monster:ReplaceSkill("close_combat", 2, true)
	growlithe_monster:ReplaceSkill("roar", 3, false)

	GAME:AddPlayerTeam(growlithe_monster)
	growlithe_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    growlithe_monster.ActionEvents:Add(talk_evt)
	growlithe_monster:RefreshTraits()

	local zigzagoon_id = RogueEssence.Dungeon.MonsterID("zigzagoon", 0, "normal", Gender.Male)
	local zigzagoon_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, zigzagoon_id, SV.GuildSidequests.ZigzagoonLevel, "pickup", 0)
	zigzagoon_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	zigzagoon_monster.Nickname = CharacterEssentials.GetCharacterName('Zigzagoon', true)
	zigzagoon_monster.MetAt = "Adventurer's Guild"
	zigzagoon_monster.IsPartner = true
	zigzagoon_monster.IsFounder = true

	zigzagoon_monster:ReplaceSkill("headbutt", 0, true)
	zigzagoon_monster:ReplaceSkill("helping_hand", 1, false)
	zigzagoon_monster:ReplaceSkill("pin_missile", 2, true)
	zigzagoon_monster:ReplaceSkill("odor_sleuth", 3, false)

	GAME:AddPlayerTeam(zigzagoon_monster)
	zigzagoon_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    zigzagoon_monster.ActionEvents:Add(talk_evt)
	zigzagoon_monster:RefreshTraits()

	--Assign importances to identify who they are. Do this instead of just checking species just in case randomizers down the road or something.
	local gTbl = LTBL(GAME:GetPlayerPartyMember(2))
	local zTbl = LTBL(GAME:GetPlayerPartyMember(3))

	gTbl.Importance = "Growlithe"
	zTbl.Importance = "Zigzagoon"



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

	tropius, noctowl, mareep, cranidos, snubbull, audino, breloom, girafarig, tail =
		CharacterEssentials.MakeCharactersFromList({
			{'Tropius', 336, 112, Direction.Left},
			{'Noctowl', 304, 112, Direction.Right},
			{'Mareep', 276, 260, Direction.UpLeft},
			{'Cranidos', 240, 260, Direction.UpRight},
			{'Snubbull', 276, 224, Direction.DownLeft},
			{'Audino', 240, 224, Direction.DownRight},
			{'Breloom', 144, 80, Direction.DownLeft},
			{'Girafarig', 120, 104, Direction.UpRight}
		})

	--set hyko and almotz to spawn from the spawners, then spawn them
	GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
	growlithe = GROUND:SpawnerDoSpawn("TEAMMATE_2")

	GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
	zigzagoon = GROUND:SpawnerDoSpawn("TEAMMATE_3")


	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:TeleportTo(hero, 258, 176, Direction.Down)
	GROUND:TeleportTo(partner, 258, 144, Direction.Down)
	GAME:MoveCamera(0, 0, 1, true)


	GAME:WaitFrames(20)
	GAME:FadeIn(60)

	SV.Chapter5.FinishedTunnelIntro = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)
end


function searing_tunnel_entrance_ch_5.Tropius_Action(chara, activator)
	--Will hand out the supplies if needed this time. Will be in a bit of a panic if you wipe. You can also
	--speak to him after wiping to the boss, which prompts Hyko to get you to not give details about the boss
	--since he wouldn't want the guildmaster to flip
	if not SV.Chapter5.EnteredTunnel then
	GeneralFunctions.StartConversation(chara, "Équipe " .. GAME:GetTeamName() .. "...[pause=0] Je compte sur vous pour traverser ce prochain donjon sans danger.", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_122']))
	elseif SV.Chapter5.TunnelLastExitReason == 'Died' then
	GeneralFunctions.StartConversation(chara, "Soyez plus prudents lors de votre prochaine tentative.[pause=0]\nJe ne veux pas vous voir tous K.O. une nouvelle fois !", "Worried")
	elseif SV.Chapter5.TunnelLastExitReason == 'Escaped' then
	GeneralFunctions.StartConversation(chara, "Bonne chance et faites attention lors de votre prochaine tentative.[pause=0]\nN'hésitez pas à fuir encore si la situation dégénère !", "Normal")
	elseif SV.Chapter5.TunnelLastExitReason == 'Retreated' then
	GeneralFunctions.StartConversation(chara, "Bonne chance et faites attention lors de votre prochaine tentative.[pause=0]\nEt souvenez-vous,[pause=10] ne revenez ici qu'en cas de besoin !", "Normal")
	end

	--Say something extra if you've encountered the boss.
	--TODO: Improve this. Dialogue and choreography could use a tuneup.
	if SV.Chapter5.EncounteredBoss and not SV.Chapter5.GrowlitheTropiusBossInterrupt then
		local partner = CH('Teammate1')
		local hero = CH('PLAYER')
		local growlithe = CH('Teammate2')
		local zigzagoon = CH('Teammate3')

		GAME:WaitFrames(40)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_123']))
		GAME:WaitFrames(20)

		GROUND:CharTurnToChar(chara, partner)
		UI:SetSpeaker(chara)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_124']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_215']), 40) end)
		local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
													  GROUND:CharSetAnim(growlithe, "None", true)
													  GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true)
													  end)
		TASK:JoinCoroutines({coro1, coro2})
		GROUND:CharTurnToCharAnimated(growlithe, chara, 4)
		UI:SetSpeaker(growlithe)
		GeneralFunctions.SetEmotion("Surprised")
		coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_210'])) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(chara, growlithe, 4) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharTurnToCharAnimated(partner, growlithe, 4) end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:CharTurnToCharAnimated(hero, growlithe, 4) end)
		local coro5 = TASK:BranchCoroutine(function() GROUND:CharSetAnim(zigzagoon, "None", true) GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)

		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
		GAME:WaitFrames(20)

		UI:SetSpeaker(chara)
		coro1 = TASK:BranchCoroutine(function()	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_211']))
												UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_125']))
												UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_126']))
												end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:CharTurnToCharAnimated(hero, chara, 4) end)
		coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharTurnToCharAnimated(zigzagoon, chara, 4) end)
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

		GAME:WaitFrames(20)

		UI:SetSpeaker(growlithe)
		GROUND:CharSetEmote(growlithe, "sweating", 1)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_127'], chara:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(chara)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_128'], growlithe:GetDisplayName()))
		GAME:WaitFrames(20)


		--teleport over to them to reduce the gap if the reason you're out here is due to retreating.
		if SV.Chapter5.TunnelLastExitReason == 'Retreated' then
			GAME:FadeOut(false, 20)
			AI:DisableCharacterAI(partner)
			GROUND:TeleportTo(partner, 408, 172, Direction.Right)
			GROUND:TeleportTo(hero, 408, 196, Direction.UpRight)
			GROUND:CharTurnToChar(zigzagoon, growlithe)
			GROUND:CharTurnToChar(growlithe, partner)
			GROUND:CharEndAnim(chara)
			GROUND:EntTurn(chara, Direction.Down)
			GROUND:CharTurnToCharAnimated(partner, growlithe, 4)
			AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
			AI:EnableCharacterAI(partner)
			GAME:WaitFrames(20)
			GAME:FadeIn(20)
		else
			GROUND:CharEndAnim(chara)
			GROUND:EntTurn(chara, Direction.Down)
			GROUND:CharTurnToCharAnimated(partner, growlithe, 4)
		end

		--[[
		--This will probably look a little weird depending on how weird you can get the player/partner before talking to Penticus.
		if SV.Chapter5.TunnelLastExitReason == 'Retreated' then
			AI:DisableCharacterAI(partner)
			coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 408, 196, false, 1)
													GROUND:CharSetAnim(partner, "None", true)
													GROUND:CharTurnToChar(partner, growlithe)
													end)
			coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, zigzagoon, 4)
													GeneralFunctions.EightWayMove(hero, 408, 172, false, 1)
													GROUND:CharSetAnim(hero, "None", true)
													GROUND:CharTurnToChar(hero, zigzagoon)
													end)
			coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
													GeneralFunctions.FaceMovingCharacter(growlithe, hero, 4, Direction.Left) end)
			coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
													GeneralFunctions.FaceMovingCharacter(zigzagoon, partner, 4, Direction.Left) end)
			TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
			AI:EnableCharacterAI(partner)
		end
		]]--
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_216']), 40) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:CharTurnToCharAnimated(hero, growlithe, 4) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
		GAME:WaitFrames(10)

		UI:SetSpeaker(growlithe)
		GROUND:CharTurnToCharAnimated(growlithe, partner, 4)
		GeneralFunctions.SetEmotion("Pain")
		GROUND:CharSetEmote(growlithe, "sweating", 1)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_129']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_130'], _DATA:GetMonster('slugma'):GetColoredName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_131']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_132']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_133']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_134']))
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_135']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(growlithe)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_136']))
		GAME:WaitFrames(20)

		GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4)
		GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4)
		GROUND:CharEndAnim(zigzagoon)
		GROUND:CharEndAnim(growlithe)
		SV.Chapter5.GrowlitheTropiusBossInterrupt = true
	end

	GeneralFunctions.EndConversation(chara)

end

function searing_tunnel_entrance_ch_5.Noctowl_Action(chara, activator)
	--Guildmaster insisted on handing out potential supplies to your team, so talk to him.
	--...Why does the Guildmaster worry over Hyko so much? There's a reason... But it's not my story to tell.

	--Grande veillee de legende : apres la rencontre du clan Slugma, Phileas
	--repond a la question que tout le monde se pose (pourquoi defendent-ils
	--ce tunnel ?) par la legende du Fourneau et des Coeurs.
	if SV.Chapter5.EncounteredBoss and not SV.Chapter5.LegendFurnaceHeard and not SV.Chapter5.EnteredTunnel then
		GeneralFunctions.StartConversation(chara, "Hou...[pause=0] Vous avez donc croisé le clan de Limagma.[pause=0] Et vous vous demandez pourquoi ils se battent avec une telle rage.", "Normal")
		UI:WaitShowDialogue("Venez.[pause=0] Rassemblez l'équipe près du feu.[pause=0] Il est temps que je vous raconte ce que disent les archives.")
		GeneralFunctions.EndConversation(chara)
		searing_tunnel_entrance_ch_5.FurnaceLegendScene()
		return
	end

	if SV.Chapter5.EnteredTunnel then
	--He sleeps if you die and visit him. This is where he finds his rest after all.
		UI:ResetSpeaker(false)
		UI:SetCenter(true)
	GeneralFunctions.StartConversation(chara, "(" .. chara:GetDisplayName() .. " dort.)\n(Il doit rattraper son sommeil...)", "Normal", false, false, false)
		UI:SetCenter(false)
		GeneralFunctions.EndConversation(chara, false)
	elseif SV.Chapter5.SpokeToNoctowlTunnel then
	GeneralFunctions.StartConversation(chara, "Comme je l'ai dit,[pause=10]le Maître de Guilde a insisté pour distribuer lui-même les provisions à votre équipe.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_137']))
		GeneralFunctions.EndConversation(chara)
	else
		local partner = CH('Teammate1')

	GeneralFunctions.StartConversation(chara, "Le Maître de Guilde a insisté pour distribuer lui-même les provisions à votre équipe.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_138']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_139']))
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_140'], chara:GetDisplayName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_141'], CharacterEssentials.GetCharacterName("Growlithe")))
		GAME:WaitFrames(20)

		UI:SetSpeaker(chara)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_142']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_143'], CharacterEssentials.GetCharacterName("Growlithe")))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_144'], CharacterEssentials.GetCharacterName("Growlithe")))
		GAME:WaitFrames(20)

		UI:SetSpeaker(chara)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_145']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_146']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Sad")
		GROUND:CharSetEmote(partner, "sweating", 1)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_147']))

		SV.Chapter5.SpokeToNoctowlTunnel = true
		GeneralFunctions.EndConversation(chara)

	end


end

function searing_tunnel_entrance_ch_5.Breloom_Action(chara, activator)
	--Reiterates how the place is unstable. It's strange, since he's heard of this place before, and it was never said to be unstable then! (his memory is good so HMMM)
	GeneralFunctions.StartConversation(chara, "Soyez prudents dans le tunnel.[pause=0] Toute cette lave est instable !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_148']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_149'], CharacterEssentials.GetCharacterName("Girafarig")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_150']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_151']))
	GeneralFunctions.EndConversation(chara)
end

function searing_tunnel_entrance_ch_5.Girafarig_Action(chara, activator)
	--Tells you about treasure boxes
	GeneralFunctions.StartConversation(chara, "Avez-vous trouvé des coffres au trésor ?")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_152'], CharacterEssentials.GetCharacterName("Breloom"), CharacterEssentials.GetCharacterName("Tail")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_153']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_154']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_155']))
	GeneralFunctions.SetEmotion("Worried")
	--translator's note: Haunch means butt
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_156']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_157'], CharacterEssentials.GetCharacterName("Sneasel")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_158']))
	GeneralFunctions.EndConversation(chara)
end

function searing_tunnel_entrance_ch_5.Growlithe_Action(chara, activator)
	--I'm heat resistant!
	if not SV.Chapter5.EnteredTunnel then
	GeneralFunctions.StartConversation(chara, "Nous sommes prêts quand vous voulez,[pause=10] wouf ![pause=0] Nous pouvons partir dès que vous êtes prêts !", "Happy")
	elseif SV.Chapter5.GrowlitheTropiusBossInterrupt then
		--Whisper this if you didn't retreat as the last exit reason; death/escape puts you next to Penticus after all.
		local prefix = '('
		local suffix = ')'
		if SV.Chapter5.TunnelLastExitReason == 'Retreated' then
			prefix = ''
			suffix = ''
		end
	GeneralFunctions.StartConversation(chara, prefix .. "Merci de ne pas avoir parlé à " .. CharacterEssentials.GetCharacterName("Tropius") .. " de la tribu " .. _DATA:GetMonster('slugma'):GetColoredName() .. ",[pause=10] wouf." .. suffix)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_159'], prefix, suffix))
	elseif SV.Chapter5.TunnelLastExitReason == 'Retreated' then
	GeneralFunctions.StartConversation(chara, "Ça ne me dérange pas de retraverser le tunnel.[pause=0] Cela nous permettra de vivre encore plus d'aventures,[pause=10] wouf !", "Happy")
	else--last exit reason was Died or Escaped
	GeneralFunctions.StartConversation(chara, "Ce donjon n'est pas facile,[pause=10] mais rien ne nous résiste,[pause=10] wouf !")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_160']))
	end
	GeneralFunctions.EndConversation(chara)
end

function searing_tunnel_entrance_ch_5.Zigzagoon_Action(chara, activator)
	if not SV.Chapter5.EnteredTunnel then
		local berry_name = STRINGS:Format('\\uE0A3')..'[color=#FFCEFF]Rawst Berries[color]'
	GeneralFunctions.StartConversation(chara, "Hmm.[pause=0] Avec toute cette chaleur,[pause=10] ce donjon sera difficile si nous ne sommes pas préparés.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_161'], berry_name))
	elseif SV.Chapter5.GrowlitheTropiusBossInterrupt then
		--Whisper this if you didn't retreat as the last exit reason; death/escape puts you next to Penticus after all.
		local prefix = '('
		local suffix = ')'
		if SV.Chapter5.TunnelLastExitReason == 'Retreated' then
			prefix = ''
			suffix = ''
		end
	GeneralFunctions.StartConversation(chara, prefix .. "Je n'aime pas garder des secrets,[pause=10] mais je veux aussi continuer à partir à l'aventure avec " .. CharacterEssentials.GetCharacterName("Growlithe") .. "..." .. suffix, "Worried")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_162'], prefix, suffix))
	elseif SV.Chapter5.TunnelLastExitReason == 'Retreated' then
	GeneralFunctions.StartConversation(chara, "Rebrousser chemin après avoir atteint le point de contrôle n'était pas notre meilleure idée...", "Worried")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_163']))
	else--last exit reason was Died or Escaped
	GeneralFunctions.StartConversation(chara, "C'était rude...[pause=0] Mais si nous sommes plus malins la prochaine fois,[pause=10] je sais que nous y arriverons !")
	end
	GeneralFunctions.EndConversation(chara)
end

function searing_tunnel_entrance_ch_5.Audino_Action(chara, activator)
	--We're bound to get burned with all the lava and fire-types in there. Heal bell will be useful for us in there!
	local heal_bell = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("heal_bell")
	GeneralFunctions.StartConversation(chara, "Nous allons forcément être b-brûlés avec tous ces Pokémon Feu et cette lave...", "Worried", false)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_164'], heal_bell:GetColoredName()))
	GeneralFunctions.EndConversation(chara)
end

function searing_tunnel_entrance_ch_5.Snubbull_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Ce donjon est brûlant.[pause=0] Nous devrons être prudents ou la chaleur nous fera griller !", "Worried", false)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_165']))
	GeneralFunctions.SetEmotion("Special0")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_166'], STRINGS:Format("\\u266A")))
	GeneralFunctions.EndConversation(chara)
end

function searing_tunnel_entrance_ch_5.Mareep_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Nous allons vivre une formi-i-idable aventure ![pause=0] Cette équipe va être géniale !", "Happy", false)

	GeneralFunctions.EndConversation(chara)
end

--todo: should he be less uwu here and more angy? hard to strike a balance; i don't want to flanderize him too hard.
function searing_tunnel_entrance_ch_5.Cranidos_Action(chara, activator)
	if not SV.Chapter5.SpokeToCranidosTunnel then
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Mareep") .. ",[pause=10] je sais que tu es impatient de faire équipe,[pause=10] mais ne baisse pas ta garde.", "Worried", false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_167']), {function() TASK:BranchCoroutine(function() GROUND:CharSetEmote(chara, "sweating", 1) end) end})
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_168'], CharacterEssentials.GetCharacterName("Audino"), CharacterEssentials.GetCharacterName("Snubbull")))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_169']))
		GAME:WaitFrames(40)
		GeneralFunctions.EmoteAndPause(chara, "Exclaim", true)
		GROUND:CharTurnToCharAnimated(chara, CH('PLAYER'), 4)
		--GeneralFunctions.Complain(chara)
		--GROUND:CharSetAnim(chara, "None", true)
		GROUND:CharSetEmote(chara, "sweating", 1)
		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_170']))
		--UI:WaitShowDialogue("Shouldn't you greenhorns be getting yourselves ready!?")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_171'], CharacterEssentials.GetCharacterName("Mareep")))
		GROUND:CharSetEmote(chara, "", 0)
		SV.Chapter5.SpokeToCranidosTunnel = true
	else
	GeneralFunctions.StartConversation(chara, "Je vous ai dit de dégager ![pause=0] Ce donjon n'est pas une plaisanterie,[pause=10] alors cessez de perdre votre temps et allez vous préparer !", "Special0")
	end
	GeneralFunctions.EndConversation(chara)
end




function searing_tunnel_entrance_ch_5.DiedCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local tropius = CH('Tropius')
	local noctowl = CH('Noctowl')
	local coro1, coro2, coro3, coro4

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GROUND:TeleportTo(partner, 396, 184, Direction.Right)
	GROUND:TeleportTo(hero, 356, 184, Direction.Left)

	--GROUND:CharSetAnim(noctowl, "Sleep", true)
	GAME:MoveCamera(384, 148, 1, false)

	--todo: if growlithe gets eventsleep/wake animations, use them here.
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(10)--to offset their breathing cycles
	GROUND:CharSetAnim(growlithe, "Sleep", true)
	GROUND:CharSetAnim(zigzagoon, "EventSleep", true)

	GAME:FadeIn(40)
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:WaitFrames(60)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_172'], growlithe:GetDisplayName()))
	GAME:WaitFrames(30)

	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_173']))
	GAME:WaitFrames(10)

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
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.DoAnimation(zigzagoon, 'Wake')
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(zigzagoon, 3, 4, false, false, true, Direction.Down)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(26)
										    GeneralFunctions.DoAnimation(growlithe, 'Rumble')
											GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(growlithe, 3, 4, false, false, false, Direction.Down)
											end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(30)

	coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Surprised")
	GROUND:CharSetEmote(tropius, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_174']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_175']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_176']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_177']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_178']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_179']))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(tropius, Direction.UpLeft, 4)
	GAME:WaitFrames(60)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_180']))
	GAME:WaitFrames(20)
	GeneralFunctions.RewardItem("food_apple")
	GeneralFunctions.RewardItem("berry_oran")
	GeneralFunctions.RewardItem("berry_oran")
	GeneralFunctions.RewardItem("berry_leppa")
	GeneralFunctions.RewardItem("berry_rawst")

	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_181']))
	GAME:WaitFrames(20)

	GeneralFunctions.PanCamera()

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	SV.Chapter5.PlayTempTunnelScene = false

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	GAME:CutsceneMode(false)

end

function searing_tunnel_entrance_ch_5.EscapedCutscene()

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local tropius = CH('Tropius')
	local noctowl = CH('Noctowl')
	local coro1, coro2, coro3, coro4

	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(partner, 396, 184, Direction.Up)
	GROUND:TeleportTo(hero, 356, 184, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Down)
	GROUND:EntTurn(growlithe, Direction.Down)

	--GROUND:CharSetAnim(noctowl, "Sleep", true)
	GAME:MoveCamera(384, 148, 1, false)

	GAME:FadeIn(40)
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_182']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Surprised")
	GROUND:CharSetEmote(tropius, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_183']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_212'])) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(20)

	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_184']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_185']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_186']))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(tropius, Direction.UpLeft, 4)
	GAME:WaitFrames(60)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_187']))
	GAME:WaitFrames(20)
	GeneralFunctions.RewardItem("food_apple")
	GeneralFunctions.RewardItem("berry_oran")
	GeneralFunctions.RewardItem("berry_rawst")

	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_188']))
	GAME:WaitFrames(20)


	GeneralFunctions.PanCamera()

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	SV.Chapter5.PlayTempTunnelScene = false

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	GAME:CutsceneMode(false)
end

function searing_tunnel_entrance_ch_5.RetreatedCutscene()

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local tropius = CH('Tropius')
	local noctowl = CH('Noctowl')
	local coro1, coro2, coro3, coro4, coro5

	GAME:CutsceneMode(true)
	GROUND:Hide('Dungeon_Entrance')
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 544, 148, Direction.Left)
	GROUND:TeleportTo(partner, 544, 172, Direction.Left)
	GROUND:TeleportTo(growlithe, 560, 144, Direction.Left)
	GROUND:TeleportTo(zigzagoon, 560, 176, Direction.Left)
	GROUND:TeleportTo(tropius, 376, 128, Direction.Down)
	--GROUND:CharSetAnim(noctowl, "Sleep", true)
	GROUND:CharSetAnim(tropius, "Idle", true)
	GAME:MoveCamera(424, 168, 1, false)


	GAME:FadeIn(40)
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:WaitFrames(10)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Surprised")
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(partner, 436, 188, false, 1)
											GROUND:MoveInDirection(partner, Direction.Left, 24, false, 1)
										    end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.EightWayMoveRS(hero, 436, 164, false, 1)
											GROUND:MoveInDirection(hero, Direction.Left, 24, false, 1)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EightWayMoveRS(growlithe, 448, 172, false, 1)
											GROUND:MoveInDirection(growlithe, Direction.Left, 8, false, 1)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GeneralFunctions.EightWayMoveRS(zigzagoon, 448, 198, false, 1)
											GROUND:MoveInDirection(zigzagoon, Direction.Left, 8, false, 1)
										    end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(100)
											GROUND:CharEndAnim(tropius)
											GeneralFunctions.EmoteAndPause(tropius, "Notice", true)
											GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 4)
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_189']))
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(20)

	UI:SetSpeaker(growlithe)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(growlithe, tropius, 4)
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_190']))
										    end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharTurnToCharAnimated(partner, tropius, 4)
										    end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharTurnToCharAnimated(hero, tropius, 4)
										    end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharTurnToCharAnimated(zigzagoon, tropius, 4)
										    end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(tropius, "Question", true)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_191']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_192']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_193']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_194']))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(tropius, Direction.UpLeft, 4)
	GAME:WaitFrames(60)
	GROUND:CharTurnToCharAnimated(tropius, hero, 4)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_195']))
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(tropius, Direction.DownRight, 20, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(growlithe, tropius) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, tropius) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(10)
	GeneralFunctions.RewardItem("food_apple")
	GeneralFunctions.RewardItem("berry_oran")
	GeneralFunctions.RewardItem("berry_rawst")

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(tropius, "Walk", Direction.DownRight, Direction.UpLeft, 20, 1, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(growlithe, tropius) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, tropius) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_196']))
	GAME:WaitFrames(20)

	GeneralFunctions.PanCamera()

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	SV.Chapter5.PlayTempTunnelScene = false
	GROUND:Unhide('Dungeon_Entrance')

	--he needs to face back down
	GROUND:EntTurn(tropius, Direction.Down)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	GAME:CutsceneMode(false)
end


function searing_tunnel_entrance_ch_5.Dungeon_Entrance_Touch(obj, activator)

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("searing_tunnel")

	local result = false

	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	local coro1 = TASK:BranchCoroutine(function() result = GeneralFunctions.StartPartnerYesNo("Sommes-nous prêts à partir,[pause=10] " .. hero:GetDisplayName() .. " ?") end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharTurnToCharAnimated(growlithe, hero, 4) GROUND:CharSetAnim(growlithe, "None", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:CharTurnToCharAnimated(zigzagoon, hero, 4) GROUND:CharSetAnim(zigzagoon, "None", true) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(10)
	if result then
		GROUND:Hide('Dungeon_Entrance')
		local face_direction = Direction.DownLeft
		if SV.Chapter5.TunnelLastExitReason ~= '' then
			face_direction = Direction.Left
		end

		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 480, 176, false, 1)
												GROUND:CharAnimateTurnTo(hero, face_direction, 4)
												GROUND:CharSetAnim(hero, "None", true) end)
		coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 480, 144, false, 1)
												GROUND:CharAnimateTurnTo(partner, face_direction, 4)
												GROUND:CharSetAnim(partner, "None", true) end)
		coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, 1, GAME:GetCameraCenter().X, 168) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})

		--different movement pattern depending on where they are
		if SV.Chapter5.TunnelLastExitReason == '' then--haven't entered yet
			coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(growlithe, 448, 148, false, 1)
													GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)
													GROUND:CharSetAnim(growlithe, "None", true) end)
			coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
													GeneralFunctions.EightWayMove(zigzagoon, 432, 216, false, 1)
													GeneralFunctions.EightWayMove(zigzagoon, 448, 172, false, 1)
													GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
													GROUND:CharSetAnim(zigzagoon, "None", true) end)
		elseif SV.Chapter5.TunnelLastExitReason == 'Retreated' then
			coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(growlithe, 448, 148, false, 1)
													GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)
													GROUND:CharSetAnim(growlithe, "None", true) end)
			coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
													GeneralFunctions.EightWayMove(zigzagoon, 448, 172, false, 1)
													GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
													GROUND:CharSetAnim(zigzagoon, "None", true) end)
		else--died or escaped or retreated
			coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
													GeneralFunctions.EightWayMoveRS(growlithe, 448, 148, false, 1)
													GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)
													GROUND:CharSetAnim(growlithe, "None", true) end)
			coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(zigzagoon, 448, 172, false, 1)
													GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
													GROUND:CharSetAnim(zigzagoon, "None", true) end)
		end

		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.FaceMovingCharacter(hero, zigzagoon) end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.FaceMovingCharacter(partner, growlithe) end)
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

		UI:SetSpeaker(growlithe)
		GeneralFunctions.SetEmotion("Happy")

		if not SV.Chapter5.EnteredTunnel then
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_197']))
		elseif not SV.Chapter5.EncounteredBoss then
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_198']))
		else
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_199'], _DATA:GetMonster('slugma'):GetColoredName()))
		end


		GAME:WaitFrames(10)
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
												GROUND:MoveInDirection(partner, Direction.Right, 72, false, 1) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
												GROUND:MoveInDirection(hero, Direction.Right, 72, false, 1) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
												GROUND:MoveInDirection(growlithe, Direction.Right, 72, false, 1) end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
													  GROUND:MoveInDirection(zigzagoon, Direction.Right, 72, false, 1) end)
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GAME:FadeOut(false, 40) end)


		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

		GeneralFunctions.EndConversation(partner)
		SV.Chapter5.EnteredTunnel = true
		GAME:EnterDungeon("searing_tunnel", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STE5_200']))
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EndConversation(partner) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) GROUND:CharEndAnim(growlithe) end)
		coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) GROUND:CharEndAnim(zigzagoon) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
	end

end


--------------------------------------------------------------------
-- CINÉMATIQUE DE LÉGENDE — « Le Fourneau et les Cœurs » (Phileas)
-- Grande veillée du camp du Tunnel : Phileas raconte la légende de
-- Heatran et des Cœurs de la terre devant toute l'expédition réunie.
-- Mentions : Heatran (le Fourneau), les « Cœurs » (Anima, sans le mot),
-- écho aux Ruines du nord. Groudon évoqué par Ganlon en contrepoint.
-- OST : I Saw Something Again... -> Rising Fear (montée) -> retour camp.
-- Mise en scène complète : cercle autour du feu, émotes, réactions.
-- Déclencheur : parler à Phileas après avoir rencontré le boss (clan
-- Slugma) — la légende répond à la question que tout le monde se pose.
--------------------------------------------------------------------
function searing_tunnel_entrance_ch_5.FurnaceLegendScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local noctowl = CH('Noctowl')
	local tropius = CH('Tropius')
	if noctowl == nil then GAME:FadeIn(20) return end

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(40)

	-- Toute l'equipe se rassemble autour de Phileas (positions walkables).
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 240, 280, false, 1) GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GeneralFunctions.EightWayMove(partner, 320, 280, false, 1) GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) if growlithe ~= nil then GeneralFunctions.EightWayMove(growlithe, 220, 260, false, 1) GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4) end end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) if zigzagoon ~= nil then GeneralFunctions.EightWayMove(zigzagoon, 340, 260, false, 1) GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4) end end)
	local coro5 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 280, 250) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GROUND:TeleportTo(noctowl, 280, 220, Direction.Down)
	GAME:WaitFrames(30)

	SOUND:PlayBGM('I Saw Something Again....ogg', true)
	GAME:WaitFrames(30)

	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("Hou...[pause=0] Vous vous demandez tous pourquoi le clan de Limagma défend ce tunnel comme une forteresse,[pause=10] n'est-ce pas ?")
	UI:WaitShowDialogue("Alors approchez.[pause=0] Ce que je vais vous raconter,[pause=10] je le tiens des archives les plus anciennes de la guilde.[pause=0][br]Et des soirs comme celui-ci sont faits pour les vieilles histoires.")

	GAME:WaitFrames(30)
	GROUND:CharSetEmote(noctowl, "glowing", 1)
	UI:WaitShowDialogue("On raconte...[pause=20] que sous la croûte du monde brûle un unique Fourneau.[pause=0] Et que dans ce Fourneau vit une créature de fonte et de magma.")
	UI:WaitShowDialogue("[color=#FF4500]Heatran[color],[pause=10] la nomment les textes.[pause=0] Ses pattes s'accrochent aux plafonds des cavernes comme les nôtres au sol.[pause=0] Son sang est le métal en fusion lui-même.")

	if zigzagoon ~= nil then
		GAME:WaitFrames(15)
		GROUND:CharSetEmote(zigzagoon, "shock", 1)
		UI:SetSpeaker(zigzagoon)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue("Au PLAFOND ?![pause=0] Les pattes au plafond ?[pause=0] Et ça dort la tête en bas ?!")
	end

	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("Hou hou...[pause=0] Nul ne le sait,[pause=10] jeune Almotz.[pause=0] Car nul ne l'a jamais vue dormir.[pause=0] Mais là n'est pas l'important.")
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue("L'important,[pause=10] c'est ce que le Fourneau RÉCHAUFFE.[pause=0] Les archives parlent de...[pause=20] Cœurs.[pause=0] Des foyers de vie enfouis,[pause=10] disséminés sous toute la région.")
	UI:WaitShowDialogue("Chaque source chaude,[pause=10] chaque vallée fertile,[pause=10] chaque forêt qui repousse plus vite qu'elle ne brûle...[pause=0] serait posée sur l'un de ces Cœurs.")

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Des Cœurs enfouis...[pause=0] La voix,[pause=10] la lumière,[pause=10] les gardiens...[pause=0] Tout tourne toujours autour de la même chose.)", "Worried")

	if growlithe ~= nil then
		UI:SetSpeaker(growlithe)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("Alors le clan de Limagma...[pause=10] Ils ne défendent pas leur territoire,[pause=10] wouf.[pause=0] Ils défendent un Cœur.")
	end

	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("Hou.[pause=0] Voilà pourquoi j'aime raconter aux jeunes esprits :[pause=10] ils comprennent vite.")

	-- Montee dramatique : ce que disent les dernieres pages des archives.
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(40)
	SOUND:PlayBGM('Rising Fear.ogg', true)
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue("Mais les dernières pages de ces archives...[pause=20] sont d'une autre encre.[pause=0] Plus sombre.[pause=0] Tracée à la hâte.")
	UI:WaitShowDialogue("«[pause=5] Les Cœurs faiblissent l'un après l'autre,[pause=10] écrit l'archiviste.[pause=0] Et le Fourneau gronde comme jamais.[pause=5] »")
	UI:WaitShowDialogue("«[pause=5] Si les Cœurs s'éteignent...[pause=20] même Heatran ne pourra pas rallumer le monde.[pause=5] »")

	GAME:WaitFrames(30)
	if partner ~= nil then
		GROUND:CharSetEmote(partner, "sweating", 1)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("Phileas...[pause=0] Ces archives datent de quand,[pause=10] exactement ?")
	end

	UI:SetSpeaker(noctowl)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(".........")
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("D'il y a fort longtemps.[pause=0] Rassure-toi.[pause=0] Hou...[pause=0] Mais je mentirais en disant que la lueur de votre montagne ne m'y a pas fait penser.")

	-- Detente : Ganlon casse l'ambiance, la vie reprend.
	if tropius ~= nil then
		GAME:WaitFrames(20)
		UI:SetSpeaker(tropius)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Il se fait tard.[pause=0] Merci,[pause=10] Phileas,[pause=10] pour cette...[pause=10] berceuse réconfortante.")
		UI:WaitShowDialogue("Demain,[pause=10] le tunnel nous attend.[pause=0] Et quoi que gardent ses habitants...[pause=10] nous passerons en respectant ce qu'ils protègent.")
	end

	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(30)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(30)

	SV.Chapter5.LegendFurnaceHeard = true
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:FadeIn(40)
end
