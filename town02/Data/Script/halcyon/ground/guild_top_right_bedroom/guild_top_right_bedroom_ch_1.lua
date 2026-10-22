require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.CharacterEssentials'
require 'halcyon.GeneralFunctions'

guild_top_right_bedroom_ch_1 = {}


function guild_top_right_bedroom_ch_1.SetupGround()
	local audino = CharacterEssentials.MakeCharactersFromList({
		{'Audino', 'Audino_Bed'}
	})

	GROUND:CharSetAnim(audino, "Sleep", true)

	GAME:FadeIn(20)

end

function guild_top_right_bedroom_ch_1.Audino_Action(chara, activator)
	local audino = CH('Audino')
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	GeneralFunctions.StartConversation(chara, "(" .. audino:GetDisplayName() .. " dort.)\n(Mieux vaut la laisser se reposer.)", "Normal", false, false, false)
	UI:SetCenter(false)
	GeneralFunctions.EndConversation(chara, false)
end



return guild_top_right_bedroom_ch_1
