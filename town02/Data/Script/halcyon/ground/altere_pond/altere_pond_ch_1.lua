require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

altere_pond_ch_1 = {}

function altere_pond_ch_1.LeaveNorthWalkSequence(chara)
	GROUND:MoveToPosition(chara, 312, 128, false, 1)
	GeneralFunctions.EightWayMove(chara, 264, -32, false, 1)
end


function altere_pond_ch_1.PrologueGoToRelicForest()
	--Cutscene where partner enters Relic Forest after passing by the guild
	--local hero = GAME:GetPartyMember(1)--and send the hero to assembly for now
	--GAME:RemovePlayerTeam(1)
	--GAME:AddPlayerAssembly(hero)
	--COMMON.RespawnAllies()

	local partner = CH('Teammate1')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	--print(partner:GetDisplayName())
	GROUND:Hide(CH('PLAYER').EntName)
	GROUND:Hide('East_Exit')--hide entrance prompt to go into relic forest
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(272, 8, 1, false)
	GROUND:TeleportTo(partner, 264, -32, Direction.Down)
	GAME:FadeIn(40)



	local coro1 = TASK:BranchCoroutine(function() GAME:FadeIn(40) end)
	GeneralFunctions.MoveCharAndCamera(partner, 264, 112, false, 1)
	TASK:JoinCoroutines({coro1})

	GeneralFunctions.MoveCharAndCamera(partner, 312, 112, false, 1)
	GeneralFunctions.MoveCharAndCamera(partner, 312, 128, false, 1)
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	--GeneralFunctions.LookAround(partner, 2, 4, false, false, GeneralFunctions.RandBool(), Direction.Down)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_004']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_005']))
	GAME:WaitFrames(20)
	GeneralFunctions.ShakeHead(partner)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_007']))
	GAME:WaitFrames(20)

	--walk down the steps
	GeneralFunctions.MoveCharAndCamera(partner, 312, 320, false, 1)



	--remember Relicanth is there
	local oldman = CH("Relicanth")
	GROUND:CharSetAnim(oldman, 'Idle', true)
	GeneralFunctions.SetEmotion("Surprised")
	GROUND:CharSetEmote(partner, "exclaim", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_008']))
	--print(oldman:GetDisplayName())
	GAME:WaitFrames(20)

	--Move camera to show relicanth, then move back
	coro1 = TASK:BranchCoroutine(function() GAME:MoveCamera(544, 328, 112, false) end)
	GROUND:CharTurnToCharAnimated(partner, oldman, 4)
	TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(120)
	GAME:MoveCamera(320, 328, 116, false)

	--Remember that relicanth told you not to go in the forest
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(partner, "sweating", 1)
	GAME:WaitFrames(40)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_009'], oldman:GetDisplayName()))
	--[[this spot of dialogue commented out for being redundant with some things the partner tells the player later
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_010']))
	UI:WaitShowDialogue('Something about ancient,[pause=10] powerful forces sleeping within there...')--foreshadow: the hero is the thing referred to here in a way.

	GAME:WaitFrames(20)
	--GROUND:CharSetEmote(partner, "question", 1)
	--SOUND:PlayBattleSE("EVT_Emote_Confused")
	--GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_011']))


	--Remember that you don't give a shit what relicanth has to say
	GeneralFunctions.SetEmotion("Normal")
	GAME:WaitFrames(20)
	--TODO:make him do a little jump
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_012']))
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_013']))
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurn(partner, Direction.Down, 4, false)
	GeneralFunctions.LookAround(partner, 3, 4, true, false, GeneralFunctions.RandBool(), Direction.Down)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_014'], oldman:GetDisplayName()))
	]]--

	--sneak off towards the treeline, fade to black
	GROUND:CharAnimateTurn(partner, Direction.DownLeft, 4, false)
	GAME:WaitFrames(16)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_015']))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 224, 400, false, 1) end)
	GAME:WaitFrames(40)
	GAME:FadeOut(false, 40)
	TASK:JoinCoroutines({coro1})

	GAME:WaitFrames(60)


	--Fade back in by the entrance to the forest
	GAME:MoveCamera(840, 312, 1, false)
	GROUND:TeleportTo(partner, 840, 432, Direction.Up)
	GAME:FadeIn(60)
	GROUND:MoveToPosition(partner, 840, 336, false, 1)

	--look all around
	GeneralFunctions.LookAround(partner, 5, 4, true, false, GeneralFunctions.RandBool(), Direction.Left)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_016']))
	GROUND:CharAnimateTurn(partner, Direction.Right, 4, false)
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_017'], zone:GetColoredName()))
	GAME:WaitFrames(20)

	--[[ removed as partner doesn't really need to hint that they're about to find the player
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_018'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_019']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_020']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_022']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_023']))
	GAME:WaitFrames(20)
]]--

	GROUND:MoveToPosition(partner, 880, 336, false, 1)
	GROUND:MoveToPosition(partner, 936, 280, false, 1)
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)

	SV.Chapter1.PartnerEnteredForest = true

	--move hero to assembly for first dungeon
	local p = GAME:GetPlayerPartyMember(0)
	GAME:RemovePlayerTeam(0)
	GAME:AddPlayerAssembly(p)

	--Append [color=#FFFF00] [color] to partner name so their name stays yellow while they're the leader; this will be removed at the start of the relic forest arrival script
	GAME:SetCharacterNickname(GAME:GetPlayerPartyMember(0), "[color=#FFFF00]" .. GAME:GetCharacterNickname(GAME:GetPlayerPartyMember(0)) .. "[color]")

	--enter dungeon
	GAME:CutsceneMode(false)
	GAME:UnlockDungeon("relic_forest")
	GAME:EnterDungeon("relic_forest", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
	--GAME:EnterGroundMap("relic_forest", "Main_Entrance_Marker")



end


--play this cutscene if you wiped in the forest as just the partner
function altere_pond_ch_1.WipedInForest()
	local partner = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GROUND:Hide('East_Exit')--hide entrance prompt to go into relic forest
	GAME:MoveCamera(840, 312, 1, false)
	GROUND:TeleportTo(partner, 840, 336, Direction.Right)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GAME:FadeIn(40)

	--wake up and look around
	GAME:WaitFrames(120)
	GeneralFunctions.DoAnimation(partner, 'Wake')
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Down)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Pain')
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_024']))
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)

	GeneralFunctions.SetEmotion('Normal')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_025']))
	GeneralFunctions.SetEmotion('Pain')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_026'], zone:GetColoredName()))

	GAME:WaitFrames(40)
	GeneralFunctions.ShakeHead(partner)
	GAME:WaitFrames(30)
	GeneralFunctions.SetEmotion('Normal')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_028']))

	GAME:WaitFrames(20)
	GROUND:MoveToPosition(partner, 880, 336, false, 1)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 936, 280, false, 1) end)
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)
	TASK:JoinCoroutines({coro1})

	GAME:CutsceneMode(false)
	--relic forest
	GAME:EnterDungeon("relic_forest", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)

end





function altere_pond_ch_1.PartnerHeroReturn()
	--they made it back through the forest. it's evening now
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GROUND:AddMapStatus("dusk")--dusk
	GAME:CutsceneMode(true)
	GROUND:Hide('East_Exit')--hide entrance prompt to go into relic forest
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(840, 312, 1, false)
	GROUND:TeleportTo(partner, 936, 280, Direction.Right)
	GROUND:TeleportTo(hero, 968, 248, Direction.Right)
	GAME:FadeIn(40)

	--print(DUNGEON:DungeonDisplayName())
	--move into frame then look around
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 792, 344, false, 1) end)
	GeneralFunctions.EightWayMove(hero, 824, 344, false, 1)
	TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(15)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(partner, 3, 4, true, false, false, Direction.Right) end)
	GAME:WaitFrames(10)
	GeneralFunctions.LookAround(hero, 3, 4, true, false, false, Direction.Left)
	TASK:JoinCoroutines({coro1})

	--foreshadowing :v) hero has done this shit before in a past life (pmd1, 2, etc)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_029']))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_030'], hero:GetDisplayName()))
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_031']))
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GAME:WaitFrames(20)

	--look towards relicanth, partner suggests talking elsewhere
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_032']))
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(hero, 'Question', true)
	GeneralFunctions.HeroDialogue(hero, "(Hein ?[pause=0]Quel est le problème de parler ici ?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Eh bien,[pause=10] je suppose que je devrais suivre " .. partner:GetDisplayName() .. " de toute façon...)", "Worried")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP1_033']))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 840, 424, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
									   GeneralFunctions.EightWayMove(hero, 840, 392, false, 1) end)
	GAME:WaitFrames(40)
	GAME:FadeOut(false, 40)
	GAME:MoveCamera(272, 8, 1, false)
	TASK:JoinCoroutines({coro1, coro2})

	--Show them walking towards the transitionary map
	GROUND:TeleportTo(partner, 312, 256, Direction.Up)
	GROUND:TeleportTo(hero, 312, 288, Direction.Up)
	GAME:FadeIn(40)
	coro1 = TASK:BranchCoroutine(function() altere_pond_ch_1.LeaveNorthWalkSequence(hero) end)
	coro2 = TASK:BranchCoroutine(function() altere_pond_ch_1.LeaveNorthWalkSequence(partner) end)
	TASK:JoinCoroutines({coro1, coro2})
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)
	GAME:CutsceneMode(false)
	GAME:WaitFrames(30)--slight delay before loading next map to give the transition a moment to breathe
	GAME:EnterGroundMap("metano_altere_transition", "Main_Entrance_Marker")








end

function altere_pond_ch_1.test()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	AI:DisableCharacterAI(partner)
	GAME:CutsceneMode(true)
	GAME:MoveCamera(272, 8, 1, false)
	GROUND:TeleportTo(partner, 312, 256, Direction.Up)
	GROUND:TeleportTo(hero, 312, 288, Direction.Up)
	GAME:FadeIn(40)
	coro1 = TASK:BranchCoroutine(function() altere_pond_ch_1.LeaveNorthWalkSequence(hero) end)
	coro2 = TASK:BranchCoroutine(function() altere_pond_ch_1.LeaveNorthWalkSequence(partner) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:CutsceneMode(false)

end
