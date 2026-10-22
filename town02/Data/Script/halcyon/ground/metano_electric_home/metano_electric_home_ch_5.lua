require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_electric_home_ch_5 = {}

function metano_electric_home_ch_5.SetupGround()
	
	local manectric, luxray  = 
		CharacterEssentials.MakeCharactersFromList({
			{'Manectric', 216, 130, Direction.Down},
			{'Luxray', 206, 194, Direction.Up}
		})
	
	GAME:FadeIn(20)
end


--Nice person and doting mother, but too enabling / oblivious of her husband's harsh approach - she just sees him as a big strong man instead of toxically masculine
function metano_electric_home_ch_5.Manectric_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Votre guilde part en expédition aujourd'hui ? Ça risque d'être difficile !")
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MEH5_001']))
	GeneralFunctions.EndConversation(chara)
end 

function metano_electric_home_ch_5.Luxray_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "J'ai entendu dire que la guilde partait aujourd'hui pour une expédition.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MEH5_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MEH5_003']))
	GeneralFunctions.EndConversation(chara)
end 


