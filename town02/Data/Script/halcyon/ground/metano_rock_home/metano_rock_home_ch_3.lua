require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_rock_home_ch_3 = {}

function metano_rock_home_ch_3.SetupGround()
	if not SV.Chapter3.DefeatedBoss then
		local machamp  =
			CharacterEssentials.MakeCharactersFromList({
				{'Machamp', 98, 128, Direction.Down}

			})
	end

	GAME:FadeIn(20)
end

function metano_rock_home_ch_3.Machamp_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "C'est tellement génial que le petit " .. CharacterEssentials.GetCharacterName("Numel") .. " ait été retrouvé ![pause=0]Sa mère doit être si soulagée.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MRH3_001']))
	GeneralFunctions.EndConversation(chara)
end
