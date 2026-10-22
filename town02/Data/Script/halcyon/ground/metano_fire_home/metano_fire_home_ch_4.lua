require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_fire_home_ch_4 = {}

function metano_fire_home_ch_4.SetupGround()

	if SV.Chapter4.FinishedGrove then
		local camerupt, numel  =
			CharacterEssentials.MakeCharactersFromList({
				{'Camerupt', 176, 80, Direction.Up},
				{'Numel', 152, 80, Direction.UpRight}
			})

	end

	GAME:FadeIn(20)
end

function metano_fire_home_ch_4.Camerupt_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Maintenant,[pause=10]" .. CH('Numel'):GetDisplayName() .. ",[pause=10] vous devez être patient ! Les gâteaux de lave[pause=0]mettent du temps à sortir parfaitement !", "Happy", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MFH4_001']))
	GeneralFunctions.EndConversation(chara)
end

function metano_fire_home_ch_4.Numel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Ohhh,[pause=10] je ne peux plus attendre ![pause=0]Je veux tellement un gâteau de lave !", "Worried", false)
	GeneralFunctions.EndConversation(chara)
end
