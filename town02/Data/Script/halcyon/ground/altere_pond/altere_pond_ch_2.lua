require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

altere_pond_ch_2 = {}

function altere_pond_ch_2.SetupGround()
	--prevent player from going into relic forest during chapter 2
	if not SV.Chapter2.FinishedFirstDay then
		GROUND:AddMapStatus("dusk")--set dusk if first day
	end

	local forestBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
						RogueElements.Rect(904, 256, 8, 88),
						RogueElements.Loc(0, 0),
						true,
						"Event_Trigger_1")

	forestBlock:ReloadEvents()

	GAME:GetCurrentGround():AddTempObject(forestBlock)

	GAME:FadeIn(20)
end

function altere_pond_ch_2.Relicanth_Action(chara, activator)
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	GeneralFunctions.StartConversation(chara, partner:GetDisplayName() .. ",[pause=10]c'est vous ?[pause=0]Vous évitez les ennuis,[pause=10]j'ai confiance ?", "Normal", true, false)

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP2_001'], chara:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(chara)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP2_002'], zone:GetColoredName()))
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true)

	GROUND:CharTurnToCharAnimated(partner, chara, 4)
	GROUND:CharTurnToCharAnimated(hero, chara, 4)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP2_003']))
	GeneralFunctions.EndConversation(chara, false)
end

function altere_pond_ch_2.Event_Trigger_1_Touch(obj, activator)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	local zone2 = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")


	local partner = CH('Teammate1')
	local hero = CH('PLAYER')


	if SV.Chapter2.FinishedTraining and not SV.Chapter2.FinishedFirstDay then

		GeneralFunctions.StartPartnerConversation("Je ne pense pas que nous ayons le temps d'entrer dans " .. zone:GetColoredName() .. " avant le dîner.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP2_004']))

	else

		GeneralFunctions.StartPartnerConversation("Nous ne pouvons pas explorer " .. zone:GetColoredName() .. " maintenant !")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP2_005'], CharacterEssentials.GetCharacterName('Numel'), zone2:GetColoredName()))
	end

	GeneralFunctions.EndConversation(partner)

end
