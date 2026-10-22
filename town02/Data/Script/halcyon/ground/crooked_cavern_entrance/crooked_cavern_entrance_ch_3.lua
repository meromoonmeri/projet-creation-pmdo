require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

crooked_cavern_entrance_ch_3 = {}


function crooked_cavern_entrance_ch_3.FirstAttemptCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)

	GROUND:TeleportTo(hero, 136, 256, Direction.Up)
	GROUND:TeleportTo(partner, 168, 256, Direction.Up)
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Mt. Horn.ogg', false)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 168, 168, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 136, 168, false, 1) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_001']))
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_002'], CharacterEssentials.GetCharacterName("Sandile")))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_003'], CharacterEssentials.GetCharacterName("Mareep")))
	GAME:WaitFrames(20)
	
	GeneralFunctions.DoubleHop(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_004'], CharacterEssentials.GetCharacterName('Cranidos')))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_005'], hero:GetDisplayName()))
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GROUND:MoveToPosition(partner, 152, 152, false, 1)
											GROUND:MoveToPosition(partner, 152, 72, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 152, 152, false, 1)
											GROUND:MoveToPosition(hero, 152, 72, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:CutsceneMode(false)
	SV.Chapter3.EnteredCavern = true 
	GAME:EnterDungeon("crooked_cavern", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

end 


--player died before ever seeing team style
function crooked_cavern_entrance_ch_3.LostBeforeStyle()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)

	GROUND:TeleportTo(hero, 136, 256, Direction.Up)
	GROUND:TeleportTo(partner, 168, 256, Direction.Up)
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Mt. Horn.ogg', false)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 168, 168, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 136, 168, false, 1) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_006']))
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_007'], CharacterEssentials.GetCharacterName("Sandile")))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_008']))
	GAME:WaitFrames(20)
	
	GeneralFunctions.DoubleHop(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_010'], CharacterEssentials.GetCharacterName('Cranidos')))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_011'], hero:GetDisplayName()))
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GROUND:MoveToPosition(partner, 152, 152, false, 1)
											GROUND:MoveToPosition(partner, 152, 72, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 152, 152, false, 1)
											GROUND:MoveToPosition(hero, 152, 72, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("crooked_cavern", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

end 

--player died after seeing team style
function crooked_cavern_entrance_ch_3.LostToStyle()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)

	GROUND:TeleportTo(hero, 136, 256, Direction.Up)
	GROUND:TeleportTo(partner, 168, 256, Direction.Up)
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Mt. Horn.ogg', false)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 168, 168, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 136, 168, false, 1) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_012']))
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_013'], CharacterEssentials.GetCharacterName("Sandile")))
	GAME:WaitFrames(20)
	
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_014']))
	
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CCE3_015'], hero:GetDisplayName()))
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GROUND:MoveToPosition(partner, 152, 152, false, 1)
											GROUND:MoveToPosition(partner, 152, 72, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 152, 152, false, 1)
											GROUND:MoveToPosition(hero, 152, 72, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("crooked_cavern", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

end 

return crooked_cavern_entrance_ch_3




