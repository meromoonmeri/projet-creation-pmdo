require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.guild_third_floor_lobby.guild_third_floor_lobby_helper'


guild_third_floor_lobby_ch_4 = {}

function guild_third_floor_lobby_ch_4.SetupGround()

	local noctowl = CharacterEssentials.MakeCharactersFromList({
		{'Noctowl', 'Noctowl'}
	})

	GAME:FadeIn(20)
end



----------------
--NPC Scripts
----------------
function guild_third_floor_lobby_ch_4.Noctowl_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
		GeneralFunctions.StartConversation(chara, "Le maître de guilde vous a demandé d'explorer le " .. zone:GetColoredName() .. " récemment découvert.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_001']))
		GeneralFunctions.EndConversation(chara)
	else
		guild_third_floor_lobby_helper.GenericNoctowlResponse()
	end
end


------------------------
--Post Address Scripts
------------------------

--Player's last dungeon wasn't the grove and they haven't reached the end of the grove yet.
function guild_third_floor_lobby_ch_4.NotEnteredGrove()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_002'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_003'], zone:GetColoredName()))

	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

--player died before making it to the glade
function guild_third_floor_lobby_ch_4.FailedGroveBeforeEnd()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_004'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_005'], zone:GetColoredName()))

	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

--player failed to grab the apricorn, but did reach the glade.
function guild_third_floor_lobby_ch_4.FailedToGrabApricorn()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)


	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_006'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_007'], zone:GetColoredName()))

	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end



------------------------
--Cutscene Scripts
------------------------
function guild_third_floor_lobby_ch_4.ExpeditionAnnouncementAddress()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig,
		  breloom, mareep, cranidos = guild_third_floor_lobby_helper.SetupMorningAddress()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')

	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_009'], breloom:GetDisplayName(), girafarig:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_011']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_012']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_013']))
	GAME:WaitFrames(10)


	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
												  GROUND:CharSetEmote(zigzagoon, "exclaim", 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(22)
												  GROUND:CharSetEmote(cranidos, "notice", 1) end)
	local coro4 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(mareep, "exclaim", 1) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
												  GROUND:CharSetEmote(audino, "notice", 1) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
												   GROUND:CharSetEmote(snubbull, "notice", 1) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharSetEmote(hero, "notice", 1) end)
	local coro8 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	GAME:WaitFrames(50)
	GROUND:CharSetAnim(growlithe, "Idle", true)
	GROUND:CharSetAnim(zigzagoon, "Idle", true)
	GROUND:CharSetAnim(audino, "Idle", true)
	GROUND:CharSetAnim(mareep, "Idle", true)

	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)

	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_014']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(mareep)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_015']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_016']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_017']))
	GAME:WaitFrames(20)

	--GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_018']))
	GAME:WaitFrames(20)

	--clear guildies emotes/anims
	--GROUND:CharEndAnim(growlithe)
	--GROUND:CharEndAnim(zigzagoon)
	--GROUND:CharEndAnim(mareep)
	--GROUND:CharEndAnim(audino)
	--GROUND:CharSetEmote(growlithe, "", 0)
	--GROUND:CharSetEmote(audino, "", 0)
	--GROUND:CharSetEmote(mareep, "", 0)

	GROUND:CharTurnToChar(noctowl, partner)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_019']))

	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharTurnToCharAnimated(snubbull, noctowl, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharTurnToCharAnimated(cranidos, noctowl, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharEndAnim(mareep)
															   GROUND:CharSetEmote(mareep, "", 0)
															   GROUND:CharTurnToCharAnimated(mareep, noctowl, 4) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharEndAnim(audino)
											GROUND:CharSetEmote(audino, "", 0)
											GROUND:CharTurnToCharAnimated(audino, noctowl, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharSetEmote(growlithe, "", 0)
											GROUND:CharEndAnim(growlithe)
											GROUND:CharTurnToCharAnimated(growlithe, noctowl, 4) end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharEndAnim(zigzagoon)
											GROUND:CharTurnToCharAnimated(zigzagoon, noctowl, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_021']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharSetAnim(partner, "Idle", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_022']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_023']))
	GAME:WaitFrames(10)

	GROUND:CharEndAnim(partner)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4) end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4) end)
	coro8 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_024']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_025']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_026'], breloom:GetDisplayName(), girafarig:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_027']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_028']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_029']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_030']))

	GROUND:CharSetEmote(tropius, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_031']))
	GAME:WaitFrames(20)


	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_032']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	GROUND:CharSetEmote(partner, "", 0)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_033']))
	GAME:WaitFrames(20)

	--HURRAH!
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	GROUND:CharSetEmote(partner, "happy", 0)

	--turn pokemon on the edges up so pose is appropriate
	GROUND:EntTurn(growlithe, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Up)
	GROUND:EntTurn(hero, Direction.Up)
	GROUND:EntTurn(partner, Direction.Up)

	GROUND:CharSetAction(growlithe, RogueEssence.Ground.PoseGroundAction(growlithe.Position, growlithe.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(zigzagoon, RogueEssence.Ground.PoseGroundAction(zigzagoon.Position, zigzagoon.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(cranidos, RogueEssence.Ground.PoseGroundAction(cranidos.Position, cranidos.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(mareep, RogueEssence.Ground.PoseGroundAction(mareep.Position, mareep.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(snubbull, RogueEssence.Ground.PoseGroundAction(snubbull.Position, snubbull.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_034']))
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	GROUND:CharSetEmote(partner, "", 0)

	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(snubbull)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)

	--everyone leaves
	GAME:WaitFrames(40)
	local coro1 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeave(growlithe) end)
	local coro2 = TASK:BranchCoroutine(function() --GAME:WaitFrames(6)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(zigzagoon) end)
	local coro3 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(mareep) end)
	local coro4 = TASK:BranchCoroutine(function() --GAME:WaitFrames(18)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(cranidos) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(snubbull) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(audino) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(26)
											 GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_035'], GAME:GetTeamName()))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 456, 272, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GeneralFunctions.EightWayMove(hero, 424, 272, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(tropius, partner, 4, Direction.Down) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(noctowl, partner, 4, Direction.DownRight) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(20)

	--While everyone is welcome of course on the expedition, Guildmaster wants to gauge your skills by sending you to the new forest.
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_036']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GeneralFunctions.Hop(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_037']))
	GAME:WaitFrames(10)


	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_038'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	--Same feeling they felt when joining the guild and meeting partner; the expedition is the way forward in their "mission"
	GeneralFunctions.HeroDialogue(hero, "(En entendant parler de cette expédition, je me sens tendu et excité ![pause=0]On dirait que ce sera très amusant !)", "Inspired")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_039']))
	GAME:WaitFrames(10)

	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_040']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_041']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_042']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_043']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_044']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_045']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_046']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_047'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_048']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_049']))
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_050']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_051']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_052'], CharacterEssentials.GetCharacterName("Breloom"), CharacterEssentials.GetCharacterName("Girafarig")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_053']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_054']))
	GAME:WaitFrames(10)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GeneralFunctions.DoubleHop(partner)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_055']))
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_056'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(tropius, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_057']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharEndAnim(partner)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_058']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_059']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_060']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_061']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_062']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_063'], noctowl:GetDisplayName()))
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(tropius, Direction.Up, 4)
	GROUND:MoveInDirection(tropius, Direction.Up, 24, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(tropius)

	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_064'], hero:GetDisplayName()))
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_065']))

	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L4_066'], hero:GetDisplayName(), zone:GetColoredName()))

	GAME:WaitFrames(20)
	SV.Chapter4.FinishedFirstAddress = true
	GAME:GetCurrentGround():RemoveTempChar(breloom)
	GAME:GetCurrentGround():RemoveTempChar(girafarig)
	GeneralFunctions.PanCamera()
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)


end
