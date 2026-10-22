require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_cave_ch_3 = {}

function metano_cave_ch_3.SetupGround()
	GAME:FadeIn(20)
end

function metano_cave_ch_3.Sunflora_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "...Cet enfant qui a disparu.[pause=0]A-t-il déjà été sauvé ?", "Worried", true, false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC3_001']))
	else
		GeneralFunctions.StartConversation(chara, "...Outlaws,[pause=10] huh?", "Worried", true, false)
		GeneralFunctions.SetEmotion("Pain")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC3_002']))
	end
	GeneralFunctions.EndConversation(chara, false)
end
