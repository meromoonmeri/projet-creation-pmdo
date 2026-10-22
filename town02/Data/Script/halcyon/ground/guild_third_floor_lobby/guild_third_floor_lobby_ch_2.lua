require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.guild_third_floor_lobby.guild_third_floor_lobby_helper'

guild_third_floor_lobby_ch_2 = {}

function guild_third_floor_lobby_ch_2.SetupGround()

	--noctowl should not appear if this is the 2nd day, as he would be down on the 2nd floor
	if SV.Chapter2.EnteredRiver or not SV.Chapter2.FinishedFirstDay then
		local noctowl = CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 'Noctowl'}
		})
		GROUND:CharSetAnim(noctowl, 'Idle', true)
	end

	GAME:FadeIn(20)
end



----------------
--NPC Scripts
----------------
function guild_third_floor_lobby_ch_2.Noctowl_Action(chara, activator)
	if not SV.Chapter2.EnteredRiver then
		GeneralFunctions.StartConversation(chara, "Allez au Ledian Dojo et suivez la leçon de base avec Sensei " .. CharacterEssentials.GetCharacterName('Ledian') .. ".")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_001']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_002']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_003']))
		GeneralFunctions.EndConversation(chara)
	else
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
		GeneralFunctions.StartConversation(chara, zone:GetColoredName() .. " est situé au nord de la ville.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_004'], CharacterEssentials.GetCharacterName("Numel")))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_005']))
		GeneralFunctions.EndConversation(chara)
	end
end



------------------------
--Cutscene Scripts
------------------------



function guild_third_floor_lobby_ch_2.FirstMorningMeeting()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--create characters
	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, breloom, mareep, cranidos =
		CharacterEssentials.MakeCharactersFromList({
			{'Tropius', 'Tropius'},
			{'Noctowl', 'Noctowl'},
			{'Audino', 'Audino'},
			{'Snubbull', 'Snubbull'},
			{'Growlithe', 'Growlithe'},
			{'Zigzagoon', 'Zigzagoon'},
			{'Girafarig', 'Girafarig'},
			{'Breloom', 'Breloom'},
			{'Mareep', 'Mareep'},
			{'Cranidos', 'Cranidos'}})

	GeneralFunctions.CenterCamera({snubbull, tropius})
	GROUND:TeleportTo(partner, 632, 336, Direction.Left)
	GROUND:TeleportTo(hero, 680, 336, Direction.Left)
	GAME:FadeIn(40)
	GAME:WaitFrames(40)

	--hero and partner rush in
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 400, 336, true, 3)
												  GeneralFunctions.EightWayMove(partner, MRKR("Partner").X, MRKR("Partner").Y, true, 3)
												  GROUND:CharAnimateTurnTo(partner, MRKR("Partner").Direction, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 400, 336, true, 3)
												  GeneralFunctions.EightWayMove(hero, MRKR("Hero").X, MRKR("Hero").Y, true, 3)
												  GROUND:CharAnimateTurnTo(hero, MRKR("Hero").Direction, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(40)

	--tropius looks around, looks like everyone's here
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 8)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 8)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 8)
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_006']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_007']))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_008'], GAME:GetTeamName(), hero:GetDisplayName(), partner:GetDisplayName()))
	GAME:WaitFrames(20)

	--everyone cheers!
	SOUND:LoopBattleSE('EVT_Applause_Cheer')
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(tropius, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(noctowl, hero, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
												  GROUND:CharSetEmote(growlithe, "happy", 0)
												  GROUND:CharSetAnim(growlithe, "Idle", true) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)
												  GROUND:CharSetEmote(zigzagoon, "glowing", 0)
												  GROUND:CharSetAnim(zigzagoon, "Idle", true) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
												  GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4) end)
	local coro6 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.Left, 4)
												  GROUND:CharSetEmote(mareep, "happy", 0)
												  GROUND:CharSetAnim(mareep, "Twirl", true) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4)
												  GROUND:CharSetAnim(breloom, "Idle", true) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4)
												  GROUND:CharSetEmote(girafarig, "happy", 0)
												  GROUND:CharSetAnim(girafarig, "Idle", true) end)
	local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											      GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
												  GROUND:CharSetEmote(audino, "glowing", 0)
												  GROUND:CharSetAnim(audino, "Idle", true) end)
	local coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												   GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4) end)
	local coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												   GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	local coro12 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	local coro13 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_067'])) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12, coro13})
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(partner, "happy", 0)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_009']))
	GAME:WaitFrames(40)
	GROUND:CharEndAnim(partner)
	SOUND:StopBattleSE('EVT_Applause_Cheer')

	--turn back towards guildmaster
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(growlithe, "", 0)
											GROUND:CharEndAnim(growlithe) end)
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)
	coro4 = TASK:BranchCoroutine(function() --GAME:WaitFrames(20)
											GROUND:CharSetEmote(zigzagoon, "", 0)
											GROUND:CharEndAnim(zigzagoon)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4) end)
	coro5 = TASK:BranchCoroutine(function() --GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro6 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(mareep, "", 0)
											GROUND:CharEndAnim(mareep)
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4) end)
	coro7 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											GROUND:CharEndAnim(breloom)
											GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4) end)
	coro8 = TASK:BranchCoroutine(function() --GAME:WaitFrames(20)
											GROUND:CharSetEmote(girafarig, "", 0)
											GROUND:CharEndAnim(girafarig)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4) end)
	coro9 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											GROUND:CharSetEmote(audino, "", 0)
											GROUND:CharEndAnim(audino)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro10 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											 GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4) end)
	coro11 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
										     GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	coro12 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "", 0)
											 GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12})

	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_011']))
	GAME:WaitFrames(20)

	--morning cheer
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_012']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_013']))
	GROUND:CharSetEmote(tropius, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_014']))
	GAME:WaitFrames(20)


	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_015']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_016']))
	GAME:WaitFrames(20)

	--HURRAH!
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	--turn pokemon on the edges up so pose is appropriate
	GROUND:EntTurn(growlithe, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Up)

	GROUND:CharSetAction(growlithe, RogueEssence.Ground.PoseGroundAction(growlithe.Position, growlithe.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(zigzagoon, RogueEssence.Ground.PoseGroundAction(zigzagoon.Position, zigzagoon.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(breloom, RogueEssence.Ground.PoseGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(girafarig, RogueEssence.Ground.PoseGroundAction(girafarig.Position, girafarig.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(cranidos, RogueEssence.Ground.PoseGroundAction(cranidos.Position, cranidos.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(mareep, RogueEssence.Ground.PoseGroundAction(mareep.Position, mareep.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(snubbull, RogueEssence.Ground.PoseGroundAction(snubbull.Position, snubbull.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_017']))
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(snubbull)

	--everyone leaves
	GAME:WaitFrames(40)
	coro1 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeave(growlithe) end)
	coro2 = TASK:BranchCoroutine(function() --GAME:WaitFrames(6)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(zigzagoon) end)
	coro3 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(mareep) end)
	coro4 = TASK:BranchCoroutine(function() --GAME:WaitFrames(18)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(cranidos) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(snubbull) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(audino) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(breloom) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(girafarig) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(26)
											 GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_018'], GAME:GetTeamName()))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 456, 272, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GeneralFunctions.EightWayMove(hero, 424, 272, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(tropius, partner, 4, Direction.Down) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(noctowl, partner, 4, Direction.DownRight) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	--tropius's little intro and check-in
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_019']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_021']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_022']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_024'], noctowl:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_025'], noctowl:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_026']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_027']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_028'], snubbull:GetDisplayName()))
	GeneralFunctions.SetEmotion("Normal")

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	GROUND:CharTurnToCharAnimated(noctowl, tropius, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_029'], noctowl:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_030']))

	--tropius takes his leave
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(84)
											GeneralFunctions.EightWayMove(noctowl, 440, 240, false, 1)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(tropius, Direction.Up, 4)
											GROUND:MoveInDirection(tropius, Direction.Up, 24, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(tropius) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_031']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_032'], CharacterEssentials.GetCharacterName('Ledian')))


	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_033']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_034']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_035']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_036']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_037']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_038']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_039']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_040'], noctowl:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_041']))
	GAME:WaitFrames(20)

	GeneralFunctions.PanCamera(448, 268)
	SV.Chapter2.FirstMorningMeetingDone = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)

	GAME:CutsceneMode(false)



end


function guild_third_floor_lobby_ch_2.BeforeFirstDinner()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--[[
	--create characters
	local snubbull, girafarig, breloom, tail =
		CharacterEssentials.MakeCharactersFromList({
			{'Snubbull', 'Snubbull'},
			{'Girafarig', 'Girafarig'},
			{'Breloom', 'Breloom'},
			{'Tail'})


	GAME:MoveCamera(232, 288, 1, false)
	GROUND:TeleportTo(partner, 632, 336, Direction.Left)
	GROUND:TeleportTo(hero, 680, 336, Direction.Left)
	GAME:FadeIn(40)

	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_042']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_043']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(breloom)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_044']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_045']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_046']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_047'], girafarig:GetDisplayName(), snubbull:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_048'], snubbull:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_049']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_050']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(girafarig)2
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_051'], snubbull:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_052']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_053'], CharacterEssentials.GetCharacterName("Tail")))

	GAME:WaitFrames(20)
	UI:SetSpeaker(tail)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_054']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_055']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_056']))
	]]--


	--create characters
	local snubbull, girafarig, breloom, zigzagoon, audino, tropius, noctowl, growlithe, cranidos, mareep =
		CharacterEssentials.MakeCharactersFromList({
			{'Snubbull', 32, 332, Direction.Right},
			{'Girafarig', 248, 332, Direction.Left},
			{'Breloom', 212, 332, Direction.Right},
			{'Zigzagoon', 200, 288, Direction.Down},
			{'Audino', 420, 332, Direction.Left},
			{'Tropius', 440, 332, Direction.Left},
			{'Noctowl', 440, 332, Direction.Left},
			{'Growlithe', 440, 288, Direction.Left},
			{'Cranidos', 440, 312, Direction.Left},
			{'Mareep', 440, 344, Direction.Left}
			})

	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	GAME:MoveCamera(232, 288, 1, false)
	GROUND:TeleportTo(hero, 420, 264, Direction.Left)
	GROUND:TeleportTo(partner, 420, 296, Direction.Left)
	GROUND:CharSetAnim(zigzagoon, "Idle", true)
	GROUND:CharSetAnim(breloom, "Idle", true)
	GROUND:CharSetAnim(girafarig, "Idle", true)
	GAME:FadeIn(20)

	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 264, 264, false, 1)
												  GROUND:CharAnimateTurnTo(hero, Direction.DownLeft) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 264, 296, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4) end)

	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_057']))

	GROUND:MoveToPosition(snubbull, 144, 332, false, 1)


	--put a sfx here
	UI:SetSpeaker(snubbull)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_058']))

	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
	coro1 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "exclaim", 1)
											GROUND:CharTurnToCharAnimated(partner, snubbull, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetEmote(hero, "notice", 1)
											GROUND:CharTurnToCharAnimated(partner, snubbull, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(girafarig, "notice", 1)
												  GROUND:CharEndAnim(girafarig)
												  GROUND:CharTurnToCharAnimated(girafarig, snubbull, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharSetEmote(breloom, "exclaim", 1)
											GROUND:CharEndAnim(breloom)
											GROUND:CharTurnToCharAnimated(breloom, snubbull, 4) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharSetEmote(zigzagoon, "exclaim", 1)
											GROUND:CharEndAnim(zigzagoon)
											GROUND:CharTurnToCharAnimated(zigzagoon, snubbull, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Special0")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_059'], STRINGS:Format("\\u266A")))

	--partner and hero are confused
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoubleHop(breloom) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.Hop(girafarig) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.DoubleHop(zigzagoon) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GROUND:CharSetAnim(zigzagoon, "Idle", true)
	GROUND:CharSetAnim(breloom, "Idle", true)
	GROUND:CharSetAnim(girafarig, "Idle", true)

	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(girafarig, "glowing", 0)

	SOUND:LoopBattleSE('EVT_Applause_Cheer')
	UI:SetSpeaker(breloom:GetDisplayName() .. ', ' .. girafarig:GetDisplayName() .. ', & ' .. zigzagoon:GetDisplayName(), false, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_060']))
	SOUND:StopBattleSE('EVT_Applause_Cheer')

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(girafarig, "", 0)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	GROUND:CharEndAnim(zigzagoon)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(breloom, 0, 332, false, 2) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EightWayMove(girafarig, 0, 332, false, 2) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(54)
											GeneralFunctions.EightWayMove(zigzagoon, 0, 332, false, 2) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4)
											GeneralFunctions.EightWayMove(snubbull, 0, 332, false, 2) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EmoteAndPause(hero, "Question", false) end)
	local coro6 = TASK:BranchCoroutine(function()
											GAME:WaitFrames(10)
											SOUND:PlayBattleSE('EVT_Emote_Confused')
											GROUND:CharSetEmote(partner, "question", 1)
											UI:WaitShowTimedDialogue("Hein ?[pause=30]Œuvre d'art ?[pause=30]Que se passe-t-il ?", 60) end)
	local coro7 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(audino, 232, 332, false, 1) end)


	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(audino, partner, 4)
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_061'], snubbull:GetDisplayName()))
											GeneralFunctions.SetEmotion("Normal")
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_068'])) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, audino, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.DownLeft, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_062']))


	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_063']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)

	--they walk off
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GeneralFunctions.EightWayMove(audino, 0, 332, false, 1)
											SOUND:FadeOutBGM(60)
											GAME:FadeOut(false, 60) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(9)
											GeneralFunctions.EightWayMove(hero, 264, 296, false, 1)
											GeneralFunctions.EightWayMove(hero, 0, 332, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
											GeneralFunctions.EightWayMove(partner, 0, 332, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(tropius, 130, 332, false, 1) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
											GeneralFunctions.EightWayMove(noctowl, 162, 332, false, 1) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(60)
											GROUND:MoveInDirection(growlithe, Direction.Left, 260, false, 1) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(120)
											GROUND:MoveInDirection(mareep, Direction.Left, 200, false, 1) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(130)
											GROUND:MoveInDirection(cranidos, Direction.Left, 200, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	GAME:WaitFrames(20)
	SV.TemporaryFlags.Dinnertime = true
	GAME:CutsceneMode(false)
	SV.partner.Spawn = 'Default'
	GAME:EnterGroundMap("guild_dining_room", "Main_Entrance_Marker")


end

function guild_third_floor_lobby_ch_2.PostSecondMorningAddress()
	local noctowl = CH('Noctowl')
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GROUND:CharTurnToCharAnimated(noctowl, partner, 4)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_064'], GAME:GetTeamName()))
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)


	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_065']))
	GAME:WaitFrames(20)

	local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4)
											GROUND:MoveInDirection(noctowl, Direction.Right, 200, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
											GROUND:MoveInDirection(partner, Direction.Right, 180, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
											GROUND:MoveInDirection(hero, Direction.Right, 180, false, 1)  end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(140)
												  SOUND:FadeOutBGM()
												  GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	GAME:CutsceneMode(false)
	SV.partner.Spawn = 'Default'
	GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")


end

function guild_third_floor_lobby_ch_2.FailedRiver()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L2_066'], hero:GetDisplayName(), zone:GetColoredName(), CharacterEssentials.GetCharacterName("Numel")))

	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)

end


