require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_normal_home_ch_4 = {}

function metano_normal_home_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		local furret =
			CharacterEssentials.MakeCharactersFromList({
				{'Furret', 104, 152, Direction.Right}
			})

		AI:SetCharacterAI(furret, "halcyon.ai.ground_default", RogueElements.Loc(88, 136), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	else

	end

	GAME:FadeIn(20)
end

function metano_normal_home_ch_4.Furret_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "J'ai tellement de tâches à accomplir dans la maison aujourd'hui.", "Normal")
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH4_001']))
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end
