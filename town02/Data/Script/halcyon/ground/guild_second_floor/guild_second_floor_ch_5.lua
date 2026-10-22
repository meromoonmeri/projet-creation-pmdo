require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_second_floor_ch_5 = {}

function guild_second_floor_ch_5.SetupGround()
	--Hide real assembly during chapter 5, replace it with a temp object that acts as a note that can be used to dismiss any extra party members you have
	GROUND:Hide('Assembly_Owner')
	GROUND:Hide('Assembly')

	local assembly_note = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Paper_1", 1, 0, 0),
												RogueElements.Rect(560, 200, 32, 16),
												RogueElements.Loc(-8, 4),
												false,
												"Event_Object_1")
	assembly_note:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(assembly_note)

	local roselia, ludicolo, spinda, seviper, zangoose =
			CharacterEssentials.MakeCharactersFromList({
				{'Roselia', 'Left_Trio_2'},
				{'Ludicolo', 'Left_Trio_3'},
				{'Spinda', 'Left_Trio_1'},
				{'Seviper', 'Right_Duo_2'},
				{'Zangoose', 'Right_Duo_1'}
			})

	AI:SetCharacterAI(roselia, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {ludicolo, spinda})
	AI:SetCharacterAI(ludicolo, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {roselia, spinda})
	AI:SetCharacterAI(spinda, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {ludicolo, roselia})


	GAME:FadeIn(20)

end


function guild_second_floor_ch_5.Event_Object_1_Action(chara, activator)
	local hero = CH('PLAYER')
    local partner = CH('Teammate1')
	partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)

	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_001'], CharacterEssentials.GetCharacterName("Audino")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_004'], CharacterEssentials.GetCharacterName("Audino")))

	if GAME:GetPlayerPartyCount() > 2 then
		GAME:WaitFrames(20)
		UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['G2F5_005']))
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		if result then
			GeneralFunctions.DefaultParty(false)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_006']))
			AI:EnableCharacterAI(partner)
			AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
		end
	end

	UI:SetCenter(false)

	partner.IsInteracting = false
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)

end


function guild_second_floor_ch_5.Roselia_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Bah ![pause=0] Une expédition ?[pause=0] Nous ne savons rien de tout ça. " ..  STRINGS:Format("\\u266A"), "Normal", true, false)
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_5.Ludicolo_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Ouais ![pause=0]Nous ferons la fête avec les Pokémon que nous secourrons !", "Normal", true, false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_007']))
	GeneralFunctions.EndConversation(chara)

end

function guild_second_floor_ch_5.Spinda_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Lah ![pause=0] Aucune tâche ne résiste à la danse.", "Normal", true, false)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_008']))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_5.Seviper_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "On dirait que la guilde part soudainement en expédition.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_011'], CharacterEssentials.GetCharacterName("Zangoose")))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_5.Zangoose_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Heureusement, le bureau de poste de Békipan s'occupera des tableaux pendant que la guilde sera fermée.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F5_012'], CharacterEssentials.GetCharacterName("Seviper")))
	GeneralFunctions.EndConversation(chara)
end



