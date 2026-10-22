require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_inn_ch_5 = {}

function metano_inn_ch_5.SetupGround()
	local corvisquire, nidoqueen, nidoran_m, nidoking = 
		CharacterEssentials.MakeCharactersFromList({
			{'Corvisquire', 152, 200, Direction.UpLeft},
			{'Nidoqueen', 'Innkeeper_Right'},--Nidoqueen's spot 
			{'Nidoran_M', 240, 128, Direction.DownRight},
			{'Nidoking', 'Innkeeper_Left'}--Nidoking's spot
		})
	
	AI:SetCharacterAI(corvisquire, "halcyon.ai.ground_default", RogueElements.Loc(136, 184), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
	AI:SetCharacterAI(nidoran_m, "halcyon.ai.ground_default", RogueElements.Loc(224, 112), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)

	GAME:FadeIn(20)
end

--Cory cracking lame jokes
function metano_inn_ch_5.Passerby_1_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "On dirait que toute la ville CROÂ-sse au sujet de l'expédition de la guilde.", "Happy")
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI5_001']))
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI5_002']))
	--GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI5_003']))
	GeneralFunctions.EndConversation(chara)
	--The whole town seems extra busy today! What's everyone CROWING about?
	--Hmm, looks like nobody's INN
	--proceed with caw tion on the expedition
	--Hope they find something pretty FLY!
	--Birds of a feather?
	--They seem talon-ted
end



function metano_inn_ch_5.Nidoran_M_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Bref ![pause=0] J'ai vu passer le cortège du retour.[pause=0] Bref,[pause=10] vous étiez couverts de poussière.[pause=0] Bref,[pause=10] c'était magnifique.", "Inspired")
		UI:WaitShowDialogue("Un jour je raconterai que je vous ai parlé.[pause=0] Ici même.[pause=0] Bref.[pause=0] Historique.")
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "Bref ![pause=0] Il paraît que vous partez au nord.[pause=0] Bref,[pause=10] c'est loin.[pause=0] Bref,[pause=10] bonne chance.", "Normal")
		UI:WaitShowDialogue("Moi,[pause=10] le plus loin où je suis allé,[pause=10] c'est la rivière.[pause=0] Bref.[pause=0] Chacun son rythme.")
	else
		GeneralFunctions.StartConversation(chara, "Bref ![pause=0] Je séjourne ici en attendant que le café rouvre une table.[pause=0] Bref,[pause=10] c'est complet partout.[pause=0] Bref,[pause=10] la ville bouge trop en ce moment.", "Normal")
	end
	GeneralFunctions.EndConversation(chara)
end


function metano_inn_ch_5.Innkeeper_Desk_Right_Action(chara, activator) 
	local nidoqueen = CH('Nidoqueen')
	if SV.Chapter5.FinishedExpedition and not SV.Chapter5.LegendSkyHeard then
		GeneralFunctions.StartConversation(nidoqueen, "Vous êtes l'équipe qui a vu la lumière du sommet,[pause=10] n'est-ce pas ?[pause=0] Toute l'auberge en parle.", "Normal")
		UI:WaitShowDialogue("Une lumière en haut d'une montagne...[pause=0] Ma mère tenait cette auberge avant moi,[pause=10] et elle racontait une histoire,[pause=10] les soirs d'orage.")
		UI:ResetSpeaker()
		UI:ChoiceMenuYesNo("Écouter l'histoire de l'aubergiste ?", false)
		UI:WaitForChoice()
		if UI:ChoiceResult() then
			metano_inn_ch_5.LegendOfTheSky(nidoqueen)
		else
			GeneralFunctions.EndConversation(nidoqueen)
		end
		return
	end
	GeneralFunctions.StartConversation(nidoqueen, "Je commence à m'inquiéter pour mon petit dernier.", "Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI5_004']))
	GeneralFunctions.EndConversation(nidoqueen)
end

--------------------------------------------------------------------
-- LÉGENDE : « Le Gardien des Mers et le Gardien des Cieux »
-- Mentions : Lugia, Ho-Oh. Préfigure le Pic Céleste (ch10) : « il ne
-- descend que lorsque le ciel lui-même est en danger ».
-- OST : I Saw Something Again... Mise en scène : la pluie tambourine.
--------------------------------------------------------------------
function metano_inn_ch_5.LegendOfTheSky(chara)
	local hero = CH('PLAYER')
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(50)
	SOUND:PlayBGM('I Saw Something Again....ogg', true)
	GAME:WaitFrames(30)

	UI:SetSpeaker(chara)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("On raconte...[pause=20] que le ciel a deux gardiens,[pause=10] et qu'ils ne se rencontrent jamais.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Le premier vole si haut que ses plumes prennent les couleurs de l'arc-en-ciel.[pause=0][br][color=#FF4500]Ho-Oh[color],[pause=10] disait ma mère.[pause=0] Ceux qui l'aperçoivent reçoivent un bonheur éternel.")
	UI:WaitShowDialogue("Le second...[pause=10] dort au fond des mers,[pause=10] car son simple battement d'ailes déchaîne des tempêtes de quarante jours.[pause=0][br][color=#C0C0FF]Lugia[color].[pause=0] Le Gardien des Cieux qui vit sous l'eau.")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(chara, "glowing", 1)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue("Ma mère disait :[pause=10] «[pause=5] Si un jour tu vois Lugia hors de l'eau,[pause=10] ma fille,[pause=10] ne te réjouis pas.[pause=5] »")
	UI:WaitShowDialogue("«[pause=5] Car le Gardien des Cieux ne remonte...[pause=20] que lorsque le ciel lui-même est en danger.[pause=5] »")

	GAME:WaitFrames(30)
	GeneralFunctions.HeroDialogue(hero, "(Une lumière qui a peur,[pause=10] au sommet d'une montagne qui touche le ciel...[pause=0] J'espère que le Gardien dort encore.)", "Worried")

	UI:SetSpeaker(chara)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("Enfin ![pause=0] Ce sont des contes de comptoir.[pause=0] Ma mère en connaissait cent.[pause=0] Votre chambre est prête,[pause=10] si vous voulez dormir sur cette histoire.")

	SV.Chapter5.LegendSkyHeard = true
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(30)
	SOUND:PlayBGM('Treasure Town.ogg', true)
	GeneralFunctions.EndConversation(chara)
end

function metano_inn_ch_5.Innkeeper_Desk_Left_Action(chara, activator) 
	local nidoking = CH('Nidoking')
	GeneralFunctions.StartConversation(nidoking, "Les affaires sont un peu calmes ces derniers temps...[pause=0] On ne reçoit qu'un ou deux clients par jour !", "Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI5_005']))
	GeneralFunctions.EndConversation(nidoking)	
end
