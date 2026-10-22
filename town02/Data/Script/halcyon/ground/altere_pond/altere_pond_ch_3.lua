require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

altere_pond_ch_3 = {}


function altere_pond_ch_3.Relicanth_Action(chara, activator)
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	if not SV.Chapter3.DefeatedBoss then


		GeneralFunctions.StartConversation(chara, "Qui est là ?", "Normal", true, false)

		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP3_001'], chara:GetDisplayName(), partner:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(chara)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP3_002'], partner:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP3_003'], hero:GetDisplayName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP3_004']))

		GAME:WaitFrames(20)
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP3_005']))
	else
		GeneralFunctions.StartConversation(chara, partner:GetDisplayName() .. ".[pause=0]J'espère que vous et votre ami continuez à éviter les ennuis.", "Normal", true, false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP3_006']))
	end
	GeneralFunctions.EndConversation(chara, false)
end
