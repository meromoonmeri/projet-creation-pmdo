require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_electric_home_ch_2 = {}

function metano_electric_home_ch_2.SetupGround()

	if not SV.Chapter2.FinishedFirstDay then
		local manectric  =
			CharacterEssentials.MakeCharactersFromList({
				{'Manectric', 184, 162, Direction.Right}

			})
	else
		local electrike =
			CharacterEssentials.MakeCharactersFromList({
				{'Electrike', 144, 168, Direction.Right}
			})

		AI:SetCharacterAI(electrike, "halcyon.ai.ground_default", RogueElements.Loc(112, 136), RogueElements.Loc(64, 64), 1, 16, 32, 40, 180)

	end



	GAME:FadeIn(20)
end

function metano_electric_home_ch_2.Manectric_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Mon adorable garçon est en train de jouer avec ses amis en ce moment.")
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MEH2_001']))
	GeneralFunctions.EndConversation(chara)
end


function metano_electric_home_ch_2.Electrike_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Ne laissez personne savoir que je suis là ![pause=0]Je me cache à l'intérieur aujourd'hui.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MEH2_002']))
	GeneralFunctions.EndConversation(chara)
end
