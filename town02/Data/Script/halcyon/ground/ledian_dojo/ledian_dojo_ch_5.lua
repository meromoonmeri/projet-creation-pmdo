require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

ledian_dojo_ch_5 = {}

--NOTE: Gible and Ledian appear on the map without needing to be spawned in.
function ledian_dojo_ch_5.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		GROUND:TeleportTo(CH('Gible'), 144, 160, Direction.Up)
		
		local azumarill = 
			CharacterEssentials.MakeCharactersFromList({
				{'Azumarill', 144, 128, Direction.Down}
			})

	else 
		GROUND:TeleportTo(CH('Gible'), 224, 224, Direction.UpRight)
		
		local azumarill = 
			CharacterEssentials.MakeCharactersFromList({
				{'Azumarill', 256, 192, Direction.DownLeft}
			})

	end

end

function ledian_dojo_ch_5.Gible_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Vous êtes revenus ![pause=0] Alors ?[pause=0] ALORS ?[pause=0] Le gardien du sommet,[pause=10] il était grand comment ?[pause=0] Grand comme le dojo ?[pause=0] Plus grand ?!", "Inspired")
		UI:WaitShowDialogue("Maître Ledian dit que je dois d'abord battre le labyrinthe des débutants avant de rêver aux gardiens.[pause=0][br]Mais je RÊVE QUAND MÊME.[pause=0] Il ne peut pas contrôler mes rêves.")
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "L'expédition part aujourd'hui,[pause=10] pas vrai ?[pause=0] J'ai demandé à venir.[pause=0] On m'a dit non.[pause=0] TROIS fois.", "Sad")
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue("Alors je m'entraîne ici en attendant.[pause=0] À votre retour,[pause=10] je veux entendre TOUS les détails.[pause=0] Surtout les combats.[pause=0] SURTOUT les combats.")
	else
		GeneralFunctions.StartConversation(chara, "Cent pompes de nageoires par jour ![pause=0] C'est mon programme ![pause=0] Enfin,[pause=10] c'était.[pause=0] Je me suis arrêté à douze.", "Normal")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("Mais douze,[pause=10] c'est déjà onze de plus qu'hier ![pause=0] La progression,[pause=10] c'est ça le secret.[pause=0] Maître Ledian l'a dit.[pause=0] Enfin,[pause=10] un truc dans le genre.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Azumarill est place par SetupGround ci-dessus, et init.lua:135 dispatche
--Azumarill_Action vers ce fichier. Le handler manquait ici alors qu'il
--existe au ch4 : l'assert(pcall(load(...))) levait a chaque interaction et
--le PNJ restait muet. Meme voix qu'au ch4 (la mere inquiete pour Gible),
--avancee d'un chapitre : l'entrainement a porte ses fruits.
function ledian_dojo_ch_5.Azumarill_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Vous revoila ![pause=0] " .. chara:GetDisplayName() .. " n'a pas arrete de parler de vous pendant votre absence.", "Happy", false)
		UI:WaitShowDialogue("Il s'entraine tous les matins maintenant.[pause=0] Tous les matins ![pause=10] Je ne sais pas si je dois m'en rejouir ou m'en inquieter.")
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "Vous partez en expedition aujourd'hui ?[pause=0] " .. chara:GetDisplayName() .. " a demande a vous suivre,[pause=10] vous savez.", "Worried", false)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("J'ai dit non.[pause=0] Il est encore petit.[pause=15] Mais rentrez-nous entiers,[pause=10] sinon il ne me le pardonnera jamais.")
	else
		GeneralFunctions.StartConversation(chara, "Merci encore d'avoir aide " .. chara:GetDisplayName() .. " a s'entrainer.[pause=0] Il a beaucoup moins peur qu'avant.", "Happy", false)
		UI:WaitShowDialogue("Douze pompes de nageoires,[pause=10] il m'a dit.[pause=0] Je crois qu'il en a fait quatre.[pause=15] Mais il les a faites.")
	end
	GeneralFunctions.EndConversation(chara)
end
