require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

altere_pond_ch_4 = {}


function altere_pond_ch_4.Relicanth_Action(chara, activator)
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local relicanth = CH('Relicanth')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	if not SV.Chapter4.FinishedGrove then
		if not SV.Chapter4.SpokeToRelicanthDayOne then
			GeneralFunctions.StartConversation(chara, partner:GetDisplayName() .. ",[pause=10]c'est vous ?[pause=0]Vous essayez de vous faufiler à nouveau dans " .. zone:GetColoredName() .. ",[pause=10]hmm ?", "Normal", true, false)

			GAME:WaitFrames(20)
			UI:SetSpeaker(partner)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP4_001'], CharacterEssentials.GetCharacterName("Relicanth")))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP4_002']))

			GAME:WaitFrames(20)
			UI:SetSpeaker(relicanth)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP4_003']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP4_004']))

			GAME:WaitFrames(20)
			UI:SetSpeaker(partner)
			GeneralFunctions.SetEmotion("Worried")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP4_005'], relicanth:GetDisplayName(), hero:GetDisplayName()))
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP4_006']))

			GAME:WaitFrames(20)
			UI:SetSpeaker(relicanth)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP4_007']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP4_008']))
			SV.Chapter4.SpokeToRelicanthDayOne = true
		else
			GeneralFunctions.StartConversation(chara, "Hmmph.[pause=0]Vous, les jeunes, semblez toujours avoir quelque chose dans votre assiette...", "Normal", true, false)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP4_009']))
		end
	else
		--tell a story. Perhaps something alluding to the upcoming expedition
		GeneralFunctions.StartConversation(chara, "Espace réservé. Je dois trouver plus de détails avant qu'il raconte son histoire. Désolé! :v)", "Normal", true, false)
	end
	GeneralFunctions.EndConversation(chara, false)
end
