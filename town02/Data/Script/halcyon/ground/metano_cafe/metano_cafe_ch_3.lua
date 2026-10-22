require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_cafe_ch_3 = {}

function metano_cafe_ch_3.SetupGround()
	if not SV.Chapter3.DefeatedBoss then
		local breloom, girafarig, gulpin, lickitung =
			CharacterEssentials.MakeCharactersFromList({
				{'Breloom', 'Cafe_Table_9'},
				{'Girafarig', 'Cafe_Table_10'},
				{'Gulpin', 'Cafe_Table_2'},
				{'Lickitung', 'Cafe_Table_1'}
			})
	else
		local cleffa, aggron, gulpin, lickitung =
			CharacterEssentials.MakeCharactersFromList({
				{'Cleffa', 'Cafe_Table_5'},
				{'Aggron', 'Cafe_Table_6'},
				{'Gulpin', 'Cafe_Table_2'},
				{'Lickitung', 'Cafe_Table_1'}
			})
	end

	GAME:FadeIn(20)
end

function metano_cafe_ch_3.Initial_Girafarig_Breloom_Conversation(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local breloom = CH('Breloom')
	local girafarig = CH('Girafarig')

	GROUND:CharSetAnim(girafarig, 'None', true)
	GROUND:CharSetAnim(breloom, 'None', true)

	GROUND:CharTurnToChar(breloom, hero)
	GROUND:CharTurnToChar(girafarig, hero)

	-- Ouverture : l'odeur du café prend la scène avant les personnages.
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_000']))
	UI:SetCenter(false)
	UI:ResetSpeaker()
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(breloom, "happy", 0)
	GeneralFunctions.StartConversation(breloom, "Salut vous deux,[pause=10]je pense que je vous attraperais tous les deux fainéants au café maintenant qu'il est à nouveau ouvert,[pause=10]heheh !", "Happy")
	GROUND:CharSetEmote(breloom, "", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_001']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_002'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_003']))


	GAME:WaitFrames(20)
	GROUND:CharTurnToChar(partner, girafarig)
	GROUND:CharTurnToChar(hero, girafarig)
	UI:SetSpeaker(girafarig)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_004']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_005']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToChar(partner, breloom)
	GROUND:CharTurnToChar(hero, breloom)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_006']))
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_007']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_009'], girafarig:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_011']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_012']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_013'], hero:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	UI:SetSpeaker(girafarig)
	GROUND:CharTurnToChar(partner, girafarig)
	GROUND:CharTurnToChar(hero, girafarig)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_014']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToChar(partner, breloom)
	GROUND:CharTurnToChar(hero, breloom)
	UI:SetSpeaker(breloom)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_015'], girafarig:GetDisplayName()))


	GeneralFunctions.EndConversation(breloom)
	GROUND:CharTurnToChar(breloom, girafarig)
	GROUND:CharTurnToChar(girafarig, breloom)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	SV.Chapter3.BreloomGirafarigConvo = true
end


function metano_cafe_ch_3.Girafarig_Action(chara, activator)
	if SV.Chapter3.BreloomGirafarigConvo then
		GeneralFunctions.StartConversation(chara, "Un jour, vous atteindrez notre niveau ![pause=0]Nous et le reste de la guilde derrière vous nous élevons pour vous !", "Happy")
		GeneralFunctions.EndConversation(chara)
	else
		metano_cafe_ch_3.Initial_Girafarig_Breloom_Conversation(chara, activator)
	end
end

function metano_cafe_ch_3.Breloom_Action(chara, activator)
	if SV.Chapter3.BreloomGirafarigConvo then
		GeneralFunctions.StartConversation(chara, "Bonne chance dans votre travail de guilde ![pause=0]" .. CharacterEssentials.GetCharacterName("Girafarig") .. " et moi allons nous détendre ici jusqu'à notre départ pour notre voyage.", "Happy")
		GeneralFunctions.EndConversation(chara)
	else
		metano_cafe_ch_3.Initial_Girafarig_Breloom_Conversation(chara, activator)
	end
end


function metano_cafe_ch_3.Lickitung_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Avec le café à nouveau ouvert,[pause=10]et " .. CharacterEssentials.GetCharacterName("Gulpin") .. " pouvons à nouveau prendre nos boissons quotidiennes.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_016'], CharacterEssentials.GetCharacterName("Gulpin")))
	else
		local item = RogueEssence.Dungeon.InvItem('cafe_domi_blend')
		GeneralFunctions.StartConversation(chara, item:GetDisplayName() .. " est la spécialité de " .. CharacterEssentials.GetCharacterName("Shuckle") .. ".[pause=0]Malgré les ingrédients étranges,[pause=10]est très sain pour vous.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_017']))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_cafe_ch_3.Gulpin_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Hourra ![pause=0]Boisson précieuse,[pause=10]tu es à nouveau à moi pour savourer... !", "Happy")
	else
		GeneralFunctions.StartConversation(chara, "Mmmm...[pause=0] " .. STRINGS:Format('\\uE0A7').. "[color=#FFCEFF]Apple Cider[color]...[pause=0] Si délicieux et nourrissant...", "Inspired")
	end
	GeneralFunctions.EndConversation(chara)
end



function metano_cafe_ch_3.Cleffa_Action(chara, activator)
	local item = RogueEssence.Dungeon.InvItem('cafe_cheri_bomb')
	GeneralFunctions.StartConversation(chara, "Espèce d'idiot ![pause=0]C'est un café,[pause=10]" .. CharacterEssentials.GetCharacterName("Shuckle") .. " vend des boissons ![pause=0]Bien sur on va boire le " .. item:GetDisplayName() .. " !", "Determined", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_018']))
	GeneralFunctions.EndConversation(chara)
end

function metano_cafe_ch_3.Aggron_Action(chara, activator)
	local item = RogueEssence.Dungeon.InvItem('cafe_cheri_bomb')
	GeneralFunctions.StartConversation(chara, "Hé patron,[pause=10]J'ai reçu ce " .. item:GetDisplayName() .. " de " .. CharacterEssentials.GetCharacterName("Shuckle") .. ".", "Normal", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF3_019']))
	GeneralFunctions.EndConversation(chara)
end
