require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_fire_home_ch_3 = {}

function metano_fire_home_ch_3.SetupGround()

	if SV.Chapter3.DefeatedBoss then
		local camerupt  =
			CharacterEssentials.MakeCharactersFromList({
				{'Camerupt', 112, 104, Direction.UpLeft},

			})

	end

	GAME:FadeIn(20)
end

function metano_fire_home_ch_3.Camerupt_Action(chara, activator)
	--too long with no nicknames
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Numel") .. " s'acquitte mieux de ses tâches depuis que vous l'avez sauvé.[pause=0]Il a également été plus prévenant.")
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MFH3_001']))
	GeneralFunctions.EndConversation(chara)
end
