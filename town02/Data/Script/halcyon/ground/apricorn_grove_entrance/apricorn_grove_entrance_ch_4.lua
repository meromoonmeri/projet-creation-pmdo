require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

apricorn_grove_entrance_ch_4 = {}


function apricorn_grove_entrance_ch_4.FirstAttemptCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(164, 184, 1, false)
	GROUND:TeleportTo(hero, 140, 320, Direction.Up)
	GROUND:TeleportTo(partner, 172, 320, Direction.Up)
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 156, 352, Direction.Up)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 188, 352, Direction.Up)
	end
	
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Star Cave.ogg', false)
	GAME:WaitFrames(20)
	--standard practice for teammates 2 and 3. Teammate 2 should be in the middle behind the two of them (or something else that's appropriate if needed)
	--teammate3 should be to the side of either player or partner, depending on what works best or is convenient.
	--exit a coroutine immediately if team2 or team3 doesn't exist.
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 172, 200, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 140, 200, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 156, 232, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 188, 232, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	--UI:WaitShowDialogue("This should be the forest that " .. CharacterEssentials.GetCharacterName("Tropius") .. " told us about.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_002']))
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	GeneralFunctions.Hop(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharSetAnim(partner, "Idle", true)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_003'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_004']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_005']))

	--should player comment on being excited about a new exploration opportunity? They already expressed this kind of sentiment with the expedition, which is probably more fitting anyway.
	--Probably should not comment, i think the happy and strange feelings about adventuring should stay ultimately related to the Anima Core stuff
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(partner)
	GROUND:CharSetEmote(partner, "", 0)
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_007'], hero:GetDisplayName()))
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveToPosition(partner, 172, 32, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveToPosition(hero, 140, 32, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(22) GROUND:MoveToPosition(team2, 156, 64, false, 1) end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(26) GROUND:MoveToPosition(team3, 188, 64, false, 1) end end)
	
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:CutsceneMode(false)
	SV.Chapter4.EnteredGrove = true 
	GAME:EnterDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end


--Came out the front end for the first time. Show them confused and to teach the player that the dungeon goes both ways
function apricorn_grove_entrance_ch_4.FirstComeOutFront()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	local guest1 = CH('Guest1')
	local guest2 = CH('Guest2')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(164, 184, 1, false)
	GROUND:TeleportTo(hero, 140, 40, Direction.Down)
	GROUND:TeleportTo(partner, 172, 40, Direction.Down)
	
	--Check if we have a guest. If we do, overwrite team2 or team3 accordingly based on party size so they take that slot in the cutscene.
	if guest1 ~= nil then
		if GAME:GetPlayerPartyCount() == 2 then 
			team2 = guest1 
		else
			team3 = guest1
		end
	end 
	
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 156, 16, Direction.Down)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 188, 16, Direction.Down)
	end
	
	GAME:WaitFrames(60)
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 172, 144, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 140, 144, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 156, 120, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 188, 120, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	GROUND:CharSetEmote(partner, "question", 1)
	SOUND:PlayBattleSE('EVT_Emote_Confused')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_008']))
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(partner, 3, 4, true, false, false, Direction.Down)
											GAME:WaitFrames(10)
											GROUND:MoveToPosition(partner, 172, 200, false, 1) 
											GeneralFunctions.LookAround(partner, 3 , 4, true, true, false, Direction.Right) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(hero, 3, 4, true, false, false, Direction.Down)
											GAME:WaitFrames(14)
											GROUND:MoveToPosition(hero, 140, 200, false, 1) 
											GeneralFunctions.LookAround(hero, 3 , 4, true, false, false, Direction.Left) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then 
											GAME:WaitFrames(6)
											GeneralFunctions.LookAround(team2, 3, 4, true, false, false, Direction.Down)
											GAME:WaitFrames(20)
											GROUND:MoveToPosition(team2, 156, 176, false, 1) 
											GeneralFunctions.LookAround(team2, 3 , 4, true, false, false, Direction.Down) end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then 
											GAME:WaitFrames(6)
											GeneralFunctions.LookAround(team3, 3, 4, true, false, false, Direction.Down)
											GAME:WaitFrames(20)
											GROUND:MoveToPosition(team3, 188, 176, false, 1) 
											GeneralFunctions.LookAround(team3, 3 , 4, true, false, false, Direction.DownLeft) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function()	GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_009']))
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Shock", true)
	GeneralFunctions.SetEmotion("Surprised")
	SOUND:PlayBGM('Star Cave.ogg', false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_010']))
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_011']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_012']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_013']), {function() return GeneralFunctions.Hop(partner) end})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_014'], hero:GetDisplayName()))
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveToPosition(partner, 172, 32, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveToPosition(hero, 140, 32, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then 
											GROUND:CharAnimateTurnTo(team2, Direction.Up, 4)
											GROUND:MoveToPosition(team2, 156, 8, false, 1) end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then 
											GROUND:CharAnimateTurnTo(team3, Direction.Up, 4)
											GROUND:MoveToPosition(team3, 188, 8, false, 1) end end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:CutsceneMode(false)
	SV.Chapter4.BacktrackedOutGroveYet = true 
	GAME:ContinueDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

--died or escaped the previous time
function apricorn_grove_entrance_ch_4.SubsequentAttemptCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(164, 184, 1, false)
	GROUND:TeleportTo(hero, 140, 320, Direction.Up)
	GROUND:TeleportTo(partner, 172, 320, Direction.Up)
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 156, 352, Direction.Up)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 188, 352, Direction.Up)
	end
	
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Star Cave.ogg', false)
	GAME:WaitFrames(20)
	--standard practice for teammates 2 and 3. Teammate 2 should be in the middle behind the two of them (or something else that's appropriate if needed)
	--teammate3 should be to the side of either player or partner, depending on what works best or is convenient.
	--exit a coroutine immediately if team2 or team3 doesn't exist.
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 172, 200, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 140, 200, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 156, 232, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 188, 232, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_015']))
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_016']))

	--should player comment on being excited about a new exploration opportunity? They already expressed this kind of sentiment with the expedition, which is probably more fitting anyway.
	--Probably should not comment, i think the happy and strange feelings about adventuring should stay ultimately related to the Anima Core stuff
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_017']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_018'], hero:GetDisplayName()))
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveToPosition(partner, 172, 32, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveToPosition(hero, 140, 32, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(22) GROUND:MoveToPosition(team2, 156, 64, false, 1) end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(26) GROUND:MoveToPosition(team3, 188, 64, false, 1) end end)
	
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

--made it to the end, but didn't have enough mons to grab the treasure
function apricorn_grove_entrance_ch_4.FailedNoFullTeamReattempt()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(164, 184, 1, false)
	GROUND:TeleportTo(hero, 140, 320, Direction.Up)
	GROUND:TeleportTo(partner, 172, 320, Direction.Up)
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 156, 352, Direction.Up)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 188, 352, Direction.Up)
	end
	
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Star Cave.ogg', false)
	GAME:WaitFrames(20)
	--standard practice for teammates 2 and 3. Teammate 2 should be in the middle behind the two of them (or something else that's appropriate if needed)
	--teammate3 should be to the side of either player or partner, depending on what works best or is convenient.
	--exit a coroutine immediately if team2 or team3 doesn't exist.
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 172, 200, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 140, 200, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 156, 232, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 188, 232, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_019']))
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_020']))

	--should player comment on being excited about a new exploration opportunity? They already expressed this kind of sentiment with the expedition, which is probably more fitting anyway.
	--Probably should not comment, i think the happy and strange feelings about adventuring should stay ultimately related to the Anima Core stuff
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AGE4_022'], hero:GetDisplayName()))
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveToPosition(partner, 172, 32, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveToPosition(hero, 140, 32, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(22) GROUND:MoveToPosition(team2, 156, 64, false, 1) end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(26) GROUND:MoveToPosition(team3, 188, 64, false, 1) end end)
	
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

return apricorn_grove_entrance_ch_4




