require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

ledian_dojo_ch_3 = {}

--NOTE: Gible and Ledian appear on the map without needing to be spawned in.
function ledian_dojo_ch_3.SetupGround()
	GROUND:TeleportTo(CH('Gible'), 144, 160, Direction.DownRight)
	AI:SetCharacterAI(CH('Gible'), "halcyon.ai.ground_default", RogueElements.Loc(128, 144), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
end


function ledian_dojo_ch_3.Gible_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Les labyrinthes d'entraînement du dojo sont parfaits pour acquérir plus d'expérience de combat !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD3_001'], CharacterEssentials.GetCharacterName("Ledian")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD3_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LD3_003'], CharacterEssentials.GetCharacterName("Ledian")))
	GeneralFunctions.EndConversation(chara)
end


