require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_grass_home_ch_3 = {}

function metano_grass_home_ch_3.SetupGround()
	if not SV.Chapter3.DefeatedBoss then
		local vileplume, bellossom  =
			CharacterEssentials.MakeCharactersFromList({
				{'Vileplume', 96, 192, Direction.Up},
				{'Bellossom', 96, 136, Direction.Down}
			})
	else
		local vileplume  =
			CharacterEssentials.MakeCharactersFromList({
				{'Vileplume', 200, 176, Direction.DownLeft}
			})

		AI:SetCharacterAI(vileplume, "halcyon.ai.ground_default", RogueElements.Loc(168, 144), RogueElements.Loc(64, 64), 1, 16, 32, 40, 180)
	end


	GAME:FadeIn(20)
end

function metano_grass_home_ch_3.Vileplume_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Le monde est peut-être un endroit dangereux,[pause=10] mais au moins il y a des aventuriers qui aident ceux qui sont en difficulté.", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH3_001']))
	else
		GeneralFunctions.StartConversation(chara, "Tous ces hors-la-loi...[pause=0]Cela doit être lié à tous les donjons mystérieux qui ont surgi ces derniers temps.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH3_002']))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_grass_home_ch_3.Bellossom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Mon mari est tellement inquiet.[pause=0]Il serait beaucoup plus heureux s'il arrêtait de trop réfléchir !")
	GeneralFunctions.EndConversation(chara)
end
