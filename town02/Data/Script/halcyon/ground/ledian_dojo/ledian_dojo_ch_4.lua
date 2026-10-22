require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

ledian_dojo_ch_4 = {}

--NOTE: Gible and Ledian appear on the map without needing to be spawned in.
function ledian_dojo_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		GROUND:TeleportTo(CH('Gible'), 144, 160, Direction.Up)

		local azumarill =
			CharacterEssentials.MakeCharactersFromList({
				{'Azumarill', 144, 128, Direction.Down}
			})

	else
		GROUND:TeleportTo(CH('Gible'), 224, 224, Direction.UpRight)

		local azumarill =
			CharacterEssentials.MakeCharactersFromList({
				{'Azumarill', 256, 192, Direction.DownLeft}
			})

	end

end

--todo: depending on when the first trial is added, perhaps replace dialogue here with info on trials?
function ledian_dojo_ch_4.Gible_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Bien sûr ![pause=0]Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " et moi serions heureux de vous aider à vous entraîner !", "Normal", false)
	else
		GeneralFunctions.StartConversation(chara, "Pas de problème ![pause=0]Je suis heureux que nous ayons pu vous aider à devenir plus fort et plus confiant !", "Happy", false)
	end
	GeneralFunctions.EndConversation(chara)
end



function ledian_dojo_ch_4.Azumarill_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Pouvez-vous aider " .. chara:GetDisplayName() .. " à devenir fort afin que les hors-la-loi ne blessent pas " .. chara:GetDisplayName() .. " ?", "Worried", false)
	else
		GeneralFunctions.StartConversation(chara, "Merci beaucoup d'avoir aidé " .. chara:GetDisplayName() .. " à s'entraîner dans le dojo !", "Happy", false)
		UI:WaitShowDialogue(chara:GetDisplayName() .. " a beaucoup moins peur maintenant que " .. chara:GetDisplayName() .. " est devenu plus fort !")
	end
	GeneralFunctions.EndConversation(chara)
end
