require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_rock_home_ch_4 = {}

function metano_rock_home_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		local meditite  =
			CharacterEssentials.MakeCharactersFromList({
				{'Meditite', 232, 184, Direction.Down}

			})

		AI:SetCharacterAI(meditite, "halcyon.ai.ground_default", RogueElements.Loc(216, 168), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)

	end

	GAME:FadeIn(20)
end

function metano_rock_home_ch_4.Meditite_Action(chara, activator)
	--I'm trying, but I'm struggling to make friends... It's really getting me down...
	--But I can't give up, or I'll never have any friends! I have to keep trying!
	GeneralFunctions.StartConversation(chara, "J'essaie,[pause=10]mais j'ai du mal à me faire des amis.[pause=0]Ça me déprime vraiment,[pause=10]c'est...", "Sad")
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MRH4_001']))
	GeneralFunctions.EndConversation(chara)
end
