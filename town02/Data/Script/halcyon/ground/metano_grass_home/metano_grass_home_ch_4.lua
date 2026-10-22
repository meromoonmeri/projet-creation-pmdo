require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_grass_home_ch_4 = {}

function metano_grass_home_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		local vileplume  =
			CharacterEssentials.MakeCharactersFromList({
				{'Vileplume', 120, 192, Direction.Up}
			})
	else
		local vileplume  =
			CharacterEssentials.MakeCharactersFromList({
				{'Vileplume', 96, 136, Direction.Down},
				{'Bellossom', 96, 192, Direction.Up}
			})
	end

	GAME:FadeIn(20)
end

function metano_grass_home_ch_4.Vileplume_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Avec l'augmentation récente des donjons mystérieux et des hors-la-loi,[pause=10] je suis étonné de voir à quel point la ville peut rester si calme.", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_001']))
		GeneralFunctions.EndConversation(chara)
	else
		metano_grass_home_ch_4.Bellossom_Vileplume_Conversation(chara)
	end
end

function metano_grass_home_ch_4.Bellossom_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		metano_grass_home_ch_4.Bellossom_Vileplume_Conversation(chara)
	end
end


function metano_grass_home_ch_4.Bellossom_Vileplume_Conversation(chara)
	local bellossom = CH('Bellossom')
	local vileplume = CH('Vileplume')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(vileplume, 'None', true)
	GROUND:CharSetAnim(bellossom, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(vileplume)
	GeneralFunctions.SetEmotion("Worried")
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_002']))
    TASK:JoinCoroutines({coro1})

	GAME:WaitFrames(20)
	UI:SetSpeaker(bellossom)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_004']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(vileplume, "sweating", 1)
	UI:SetSpeaker(vileplume)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_005']))

	GROUND:CharEndAnim(vileplume)
	GROUND:CharEndAnim(bellossom)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

--[[function metano_grass_home_ch_4.Bellossom_Vileplume_Conversation(chara, activator)
	local bellossom = CH('Bellossom')
	local vileplume = CH('Vileplume')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	partner.IsInteracting = true
	GROUND:CharSetAnim(vileplume, 'None', true)
	GROUND:CharSetAnim(bellossom, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(vileplume)
	GeneralFunctions.SetEmotion("Worried")
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_006']))
    TASK:JoinCoroutines({coro1})

	GAME:WaitFrames(20)
	UI:SetSpeaker(bellossom)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_007']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_008']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(vileplume)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_010']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(bellossom)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH4_011']))

	GROUND:CharEndAnim(medicham)
	GROUND:CharEndAnim(machamp)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end]]--
