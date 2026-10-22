require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_cafe_ch_4 = {}

function metano_cafe_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		local gulpin, lickitung, linoone =
			CharacterEssentials.MakeCharactersFromList({
				{'Gulpin', 'Cafe_Table_2'},
				{'Lickitung', 'Cafe_Table_1'},
				{'Linoone', 'Cafe_Table_14'}
			})
	else
		local gulpin, lickitung, mareep, cranidos =
			CharacterEssentials.MakeCharactersFromList({
				{'Gulpin', 'Cafe_Table_2'},
				{'Lickitung', 'Cafe_Table_1'},
				{'Mareep', 'Cafe_Table_9'},
				{'Cranidos', 'Cafe_Table_10'}
			})
	end

	GAME:FadeIn(20)
end



function metano_cafe_ch_4.Lickitung_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local item = RogueEssence.Dungeon.InvItem('cafe_endurance_tonic')
		GeneralFunctions.StartConversation(chara, "Vous entendez la nouvelle ?[pause=0]" .. CharacterEssentials.GetCharacterName("Shuckle") .. " vient d'ajouter une nouvelle boisson au menu.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_001'], item:GetDisplayName()))
	else
		GeneralFunctions.StartConversation(chara, "Outre ses boissons,[pause=10]" .. CharacterEssentials.GetCharacterName("Shuckle") .. " propose également un plat du jour qu'il vend à côté.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_002']))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_cafe_ch_4.Gulpin_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local item = RogueEssence.Dungeon.InvItem('cafe_endurance_tonic')
		GeneralFunctions.StartConversation(chara, "Tellement savoureux...[pause=0]Quand je bois du " .. item:GetDisplayName() .. ",[pause=10] j'ai l'impression que rien ne peut m'arrêter...", "Inspired")
	else
		local item = RogueEssence.Dungeon.InvItem('food_apple_perfect')
		GeneralFunctions.StartConversation(chara, "Une fois,[pause=10]" .. CharacterEssentials.GetCharacterName("Shuckle") .. " avait un " .. item:GetDisplayName() .. " comme spécial du jour !", "Normal")
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_003']))
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_004']))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_cafe_ch_4.Linoone_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Je suis toujours en train de lire ce livre sur les donjons mystères.[pause=0]Ce chapitre parle des escaliers dans les donjons.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_005']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_006']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_007']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_008']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_009']))
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)

end


function metano_cafe_ch_4.Cranidos_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		if not SV.Chapter4.CranidosBlush then
			GeneralFunctions.StartConversation(chara, "Même à l'approche de l'expédition,[pause=10] je préfère continuer à arrêter les hors-la-loi plutôt que de me reposer ici.")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_010'], CharacterEssentials.GetCharacterName("Mareep")))
			GAME:WaitFrames(40)
			GeneralFunctions.EmoteAndPause(chara, "Exclaim", true)
			--GROUND:CharSetEmote(chara, "sweating", 1)
			GeneralFunctions.SetEmotion("Surprised")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_011']))
			GeneralFunctions.EmoteAndPause(chara, "Sweating", true)
			GeneralFunctions.SetEmotion("Special0")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_012']))
			SV.Chapter4.CranidosBlush = true
		else
			GeneralFunctions.StartConversation(chara, "H-hé...[pause=0]S'il te plaît, ne lui dis pas ce que j'ai dit plus tôt...", "Special0")
		end
	end
	GeneralFunctions.EndConversation(chara)

end

function metano_cafe_ch_4.Mareep_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "Salut vous deux ![pause=0]Moi et " .. CharacterEssentials.GetCharacterName("Cranidos") .. " nous détendons ici jusqu'à ce que l'expédition sta-a-a-arts !", "Happy")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF4_013']))
	end
	GeneralFunctions.EndConversation(chara)

end
