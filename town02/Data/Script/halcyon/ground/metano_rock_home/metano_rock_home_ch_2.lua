require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_rock_home_ch_2 = {}

function metano_rock_home_ch_2.SetupGround()
	if not SV.Chapter2.FinishedFirstDay then
		local medicham  =
			CharacterEssentials.MakeCharactersFromList({
				{'Medicham', 152, 152, Direction.Left},

			})

		AI:SetCharacterAI(medicham, "halcyon.ai.ground_default", RogueElements.Loc(120, 120), RogueElements.Loc(64, 64), 1, 16, 64, 40, 180)
	end
	GAME:FadeIn(20)
end

function metano_rock_home_ch_2.Medicham_Action(chara, activator)
	--meditation and self reflection allow one to achieve inner peace.
	GeneralFunctions.StartConversation(chara, "Permettez une paix intérieure,[pause=10]permettra la méditation et l'auto-réflexion.")
	--I have been trying to teach this to my daughter, but I think she's struggling with it.
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MRH2_001']))
	GeneralFunctions.EndConversation(chara)
end
