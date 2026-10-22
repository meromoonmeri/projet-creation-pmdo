require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_cave_ch_4 = {}

function metano_cave_ch_4.SetupGround()

	if SV.Chapter4.FinishedGrove then
		local oddish =
			CharacterEssentials.MakeCharactersFromList({
				{'Oddish', 272, 136, Direction.Right}
			})

		AI:SetCharacterAI(oddish, "halcyon.ai.ground_talking", false, 60, 60, 0, false, 'Default', {CH('Sunflora')})

		--She is trying to ignore oddish
		GROUND:EntTurn(CH('Sunflora'), Direction.Down)
	end

	GAME:FadeIn(20)
end

function metano_cave_ch_4.Sunflora_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "...La guilde monte bientôt une expédition,[pause=10] hein ?", "Worried", true, false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC4_001']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC4_002']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC4_003']))
	else
		GeneralFunctions.StartConversation(chara, "...Pourriez-vous sortir cet enfant d'ici ?", "Worried", true, false)
		GeneralFunctions.SetEmotion("Pain")
		--UI:WaitShowDialogue("I'd prefer to be alone,[pause=10] but she doesn't seem to understand...")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC4_004']))
	end
	GeneralFunctions.EndConversation(chara, false)
end

function metano_cave_ch_4.Oddish_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Salut dame bizarre ![pause=0]Vous devez être seule ici, toute seule.[pause=0]Ce n'est pas grave, je vous tiendrai compagnie !", "Happy", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC4_005']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC4_006']))
	GeneralFunctions.EndConversation(chara)
end
