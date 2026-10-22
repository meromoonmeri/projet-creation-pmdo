require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.CharacterEssentials'
require 'halcyon.GeneralFunctions'

guild_bottom_right_bedroom_ch_4 = {}


function guild_bottom_right_bedroom_ch_4.SetupGround()
	if SV.Chapter4.FinishedGrove then
		local zigzagoon = CharacterEssentials.MakeCharactersFromList({
			{'Zigzagoon', 224, 248, Direction.DownLeft}
		})
	end

	GAME:FadeIn(20)

end

function guild_bottom_right_bedroom_ch_4.Zigzagoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Je reçois un avis de dernière minute avant l'expédition !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBR4_001']))
	GeneralFunctions.EndConversation(chara)
end


return guild_bottom_right_bedroom_ch_4
