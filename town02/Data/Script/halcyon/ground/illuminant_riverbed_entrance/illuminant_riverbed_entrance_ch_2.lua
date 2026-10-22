require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

illuminant_riverbed_entrance_ch_2 = {}


function illuminant_riverbed_entrance_ch_2.FirstAttemptCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	SOUND:PlayBGM('Craggy Coast.ogg', false)
	AI:DisableCharacterAI(partner)

	GROUND:TeleportTo(hero, 148, 256, Direction.Up)
	GROUND:TeleportTo(partner, 116, 256, Direction.Up)
	
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 116, 152, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 148, 152, false, 1) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['IRE2_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['IRE2_002'], CharacterEssentials.GetCharacterName("Noctowl"), CharacterEssentials.GetCharacterName("Numel")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['IRE2_003']))
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['IRE2_004'], CharacterEssentials.GetCharacterName("Camerupt"), CharacterEssentials.GetCharacterName("Numel")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['IRE2_005'], hero:GetDisplayName()))
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 128, 140, false, 1)
											GROUND:MoveToPosition(partner, 128, -24, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GeneralFunctions.EightWayMove(hero, 140, 152, false, 1)
											GeneralFunctions.EightWayMove(hero, 128, 140, false, 1)
											GROUND:MoveToPosition(hero, 128, -24, false, 1) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:FadeOut(false, 40)
	GAME:CutsceneMode(false)
	SV.Chapter2.EnteredRiver = true 
	GAME:EnterDungeon("illuminant_riverbed", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

end 

--a slightly different cutscene plays if you come back after failing to rescue numel
function illuminant_riverbed_entrance_ch_2.SubsequentAttemptCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	SOUND:PlayBGM('Craggy Coast.ogg', false)
	AI:DisableCharacterAI(partner)
	
	GROUND:TeleportTo(hero, 148, 256, Direction.Up)
	GROUND:TeleportTo(partner, 116, 256, Direction.Up)
	
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 116, 152, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 148, 152, false, 1) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['IRE2_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['IRE2_007'], CharacterEssentials.GetCharacterName("Noctowl"), CharacterEssentials.GetCharacterName("Numel")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['IRE2_008']))
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['IRE2_009'], CharacterEssentials.GetCharacterName("Camerupt"), CharacterEssentials.GetCharacterName("Numel")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['IRE2_010'], hero:GetDisplayName()))
	
	--GAME:WaitFrames(20)
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	--coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	--TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 128, 140, false, 1)
											GROUND:MoveToPosition(partner, 128, -24, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GeneralFunctions.EightWayMove(hero, 140, 152, false, 1)
											GeneralFunctions.EightWayMove(hero, 128, 140, false, 1)
											GROUND:MoveToPosition(hero, 128, -24, false, 1) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:FadeOut(false, 40)
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("illuminant_riverbed", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

end 

return illuminant_riverbed_entrance_ch_2




