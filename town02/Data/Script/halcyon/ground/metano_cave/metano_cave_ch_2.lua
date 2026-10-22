require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_cave_ch_2 = {}

function metano_cave_ch_2.SetupGround()
	GAME:FadeIn(20)
end

function metano_cave_ch_2.Sunflora_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then
		GeneralFunctions.StartConversation(chara, "Visitors...?", "Worried", true, false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC2_001']))
	else
		GeneralFunctions.StartConversation(chara, "...Un des enfants de la ville a disparu ?", "Worried", true, false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC2_002']))
	end
	GeneralFunctions.EndConversation(chara, false)
end
