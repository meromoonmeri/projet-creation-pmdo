require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_water_home_ch_4 = {}

function metano_water_home_ch_4.SetupGround()

	if not SV.Chapter4.FinishedGrove then

	else
		local floatzel  =
			CharacterEssentials.MakeCharactersFromList({
				{'Floatzel', 120, 128, Direction.Down}
			})

		AI:SetCharacterAI(floatzel, "halcyon.ai.ground_default", RogueElements.Loc(104, 112), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	end


	GAME:FadeIn(20)
end


function metano_water_home_ch_4.Floatzel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Je dois faire profil bas après mon braquage magistral jusqu'à ce que la chaleur se calme un peu.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWH4_001']))
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(chara, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWH4_002']))
	GROUND:CharSetEmote(chara, "", 0)
	GeneralFunctions.EndConversation(chara)
end
