require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_electric_home_ch_4 = {}

function metano_electric_home_ch_4.SetupGround()

	if SV.Chapter4.FinishedGrove then
		local luxray  =
			CharacterEssentials.MakeCharactersFromList({
				{'Luxray', 216, 130, Direction.Down}
			})

	end

	GAME:FadeIn(20)
end

--perhaps change? two dogging on his sons in a row is a bit iffy perhaps
function metano_electric_home_ch_4.Luxray_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "S'associer à ces hooligans...[pause=0]Je ne comprends vraiment pas mon fils.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MEH4_001']))
	GeneralFunctions.EndConversation(chara)
end


