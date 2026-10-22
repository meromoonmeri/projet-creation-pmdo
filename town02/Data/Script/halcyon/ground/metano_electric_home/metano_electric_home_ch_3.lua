require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_electric_home_ch_3 = {}

function metano_electric_home_ch_3.SetupGround()

	if SV.Chapter3.DefeatedBoss then
		local luxray  =
			CharacterEssentials.MakeCharactersFromList({
				{'Luxray', 216, 130, Direction.Down}
			})

	end

	GAME:FadeIn(20)
end

function metano_electric_home_ch_3.Luxray_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Des hors-la-loi ?[pause=0]De quelle peur ai-je besoin d'eux ?")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MEH3_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MEH3_002']))
	GeneralFunctions.EndConversation(chara)
end


