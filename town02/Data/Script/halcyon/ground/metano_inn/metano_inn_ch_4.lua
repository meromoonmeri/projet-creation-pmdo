require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_inn_ch_4 = {}

function metano_inn_ch_4.SetupGround()

	if not SV.Chapter4.FinishedGrove then
		local smeargle =
			CharacterEssentials.MakeCharactersFromList({
				{'Smeargle', 128, 128, Direction.Left},
				{'Nidoqueen', 256, 116, Direction.Right},
				{'Nidoran_M', 288, 116, Direction.Left},
				{'Nidoking', 'Innkeeper_Left'}
			})

		AI:SetCharacterAI(smeargle, "halcyon.ai.ground_default", RogueElements.Loc(112, 112), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
	else
		local skorupi, nidorina, nidoqueen, nidoran_m =
			CharacterEssentials.MakeCharactersFromList({
				{'Skorupi', 317, 210, Direction.Down},
				{'Nidorina', 240, 168, Direction.DownLeft},
				{'Nidoqueen', 'Innkeeper_Right'},
				{'Nidoran_M', 176, 120, Direction.UpLeft}
			})

		AI:SetCharacterAI(nidoran_m, "halcyon.ai.ground_default", RogueElements.Loc(160, 104), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)

	end

	GAME:FadeIn(20)
end


function metano_inn_ch_4.Passerby_1_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "J'espère que je n'ai pas laissé de tache de peinture sur le lit pendant que je dormais.")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI4_001']))
	else
		GeneralFunctions.StartConversation(chara, "La nourriture de l'auberge est tellement bonne ![pause=0]Tellement meilleure que la merde de chez nous !", "Inspired")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_inn_ch_4.Nidoqueen_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "C'mon " .. CharacterEssentials.GetCharacterName("Nidoran_M") .. "![pause=0] Say mama,[pause=10] say mama!", "Normal", false)
	else

	end
	GeneralFunctions.EndConversation(chara)
end

function metano_inn_ch_4.Nidorina_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		--this might be nidorina's calling? cooking, that is
		GeneralFunctions.StartConversation(chara, "Des parents stupides me font encore travailler à l'auberge...[pause=0]Me font préparer la nourriture...", "Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI4_002']))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_inn_ch_4.Nidoran_M_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, ".........", "Normal", false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI4_003']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI4_004']))
	else
		GeneralFunctions.StartConversation(chara, "Uhhyeee!")
	end
	GeneralFunctions.EndConversation(chara)
end


function metano_inn_ch_4.Innkeeper_Desk_Right_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		local nidoqueen = CH('Nidoqueen')
		GeneralFunctions.StartConversation(nidoqueen, "Je commence à m'inquiéter pour mon plus petit.", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI4_005']))
		GeneralFunctions.EndConversation(nidoqueen)
	end
end

function metano_inn_ch_4.Innkeeper_Desk_Left_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local nidoking = CH('Nidoking')
		GeneralFunctions.StartConversation(nidoking, "Les affaires ont été un peu lentes ces derniers temps...[pause=0]On dirait que nous n'avons qu'un seul invité par jour !", "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI4_006']))
		GeneralFunctions.EndConversation(nidoking)
	else

	end
end
