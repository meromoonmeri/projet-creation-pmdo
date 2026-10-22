require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_fire_home_ch_2 = {}

function metano_fire_home_ch_2.SetupGround()

	if SV.Chapter2.EnteredRiver or not SV.Chapter2.FinishedFirstDay then --camerupt isn't in her home on the 2nd day, but comes back after you fail the river dungeon
		local camerupt  =
			CharacterEssentials.MakeCharactersFromList({
				{'Camerupt', 144, 152, Direction.Right},

			})

		AI:SetCharacterAI(camerupt, "halcyon.ai.ground_default", RogueElements.Loc(112, 120), RogueElements.Loc(64, 64), 1, 16, 64, 40, 180)
	end

	GAME:FadeIn(20)
end

function metano_fire_home_ch_2.Camerupt_Action(chara, activator)
	if SV.Chapter2.EnteredRiver then
	GeneralFunctions.StartConversation(chara, "S'il vous plaît,[pause=10]trouvez mon petit garçon ![pause=0]Il représente tout pour moi !", 'Teary-Eyed')
	else
		GeneralFunctions.StartConversation(chara, "Mon fils...[pause=0]Je l'aime en morceaux,[pause=10]mais...", "Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MFH2_001']))
	end
	GeneralFunctions.EndConversation(chara)
end
