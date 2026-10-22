require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_water_home_ch_2 = {}

function metano_water_home_ch_2.SetupGround()


	if not SV.Chapter2.FinishedFirstDay then

		local quagsire  =
			CharacterEssentials.MakeCharactersFromList({
				{'Quagsire', 216, 120, Direction.Down}
			})

	else
		local floatzel  =
			CharacterEssentials.MakeCharactersFromList({
				{'Floatzel', 188, 96, Direction.Down}
			})

		GROUND:CharSetAnim(floatzel, "Sleep", true)
	end



	GAME:FadeIn(20)
end

function metano_water_home_ch_2.Quagsire_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Wooper_Girl") .. " et " .. CharacterEssentials.GetCharacterName('Wooper_Boy') .. " sont toujours là pour essayer de comprendre leurs plans pour la journée.", "Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWH2_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWH2_002']))
	GeneralFunctions.EndConversation(chara)
end

--floatzel needs to remain asleep, but more importantly needs to not show a portrait as there is no sleeping portrait for him, which is why we need to reimplment startconversation here partially
function metano_water_home_ch_2.Floatzel_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	partner.IsInteracting = true

	UI:SetSpeaker(chara:GetDisplayName(),true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)

	GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWH2_003']))

    TASK:JoinCoroutines({coro1})
	UI:WaitDialog()
	--todo: better sleeping onomatopoeia?
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWH2_004']))

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

