require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_water_home_ch_5 = {}

function metano_water_home_ch_5.SetupGround()
	

	local floatzel, quagsire  = 
		CharacterEssentials.MakeCharactersFromList({
			{'Floatzel', 232, 120, Direction.Down},
			{'Quagsire', 232, 168, Direction.Up}
		})
	
	GAME:FadeIn(20)
end


--Tweed (Floatzel) : le magouilleur au grand coeur, plans foireux en serie
function metano_water_home_ch_5.Floatzel_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Psst.[pause=0] Vous revenez de l'expédition,[pause=10] pas vrai ?[pause=0] J'ai une proposition COMMERCIALE.", "Happy")
		UI:WaitShowDialogue("Des visites guidées «[pause=5] Sur les traces des héros[pause=5] ».[pause=0] Vous racontez,[pause=10] je vends les billets.[pause=0][br]Soixante-quarante.[pause=0] Le soixante pour moi,[pause=10] évidemment,[pause=10] c'est mon idée.")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("...Maris me fait les gros yeux.[pause=0] Bon.[pause=0] Cinquante-cinquante.[pause=0] Elle négocie dur,[pause=10] même sans parler.")
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "La guilde entière qui part vers le nord...[pause=0] Vous savez ce que ça veut dire ?[pause=0] Des maisons vides.[pause=0] Des clients captifs.[pause=0] UN MARCHÉ.", "Inspired")
		UI:WaitShowDialogue("Je lance un service de garde de plantes vertes.[pause=0] Tarif unique,[pause=10] paiement d'avance,[pause=10] résultats non garantis.")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Quoi ?[pause=0] C'est écrit dans les conditions générales.[pause=0] En tout petit.[pause=0] Sous l'aileron.")
	else
		GeneralFunctions.StartConversation(chara, "Chaque grand esprit a connu l'échec.[pause=0] Moi,[pause=10] j'en suis à mon quarante-septième.[pause=0] Ça prouve ma grandeur.", "Normal")
		UI:WaitShowDialogue("Le prochain plan est infaillible.[pause=0] Je ne peux rien dire,[pause=10] sauf trois mots :[pause=10] baies,[pause=10] abonnement,[pause=10] livraison.")
	end
	GeneralFunctions.EndConversation(chara)
end 

--Maris (Quagsire) : flegme absolu, la voix de la raison (au grand desespoir de Tweed)
function metano_water_home_ch_5.Quagsire_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Vous voilà rentrés.[pause=0] Bien.[pause=0] Tweed prépare une «[pause=5] proposition commerciale[pause=5] ».[pause=0] Fuyez pendant qu'il compte ses parts.", "Normal")
		UI:WaitShowDialogue("Booon...[pause=0] Cela dit,[pause=10] je suis contente que tout le monde soit revenu entier.[pause=0] La ville était étrange,[pause=10] sans la guilde.[pause=0] Trop calme.[pause=0] Même pour moi.")
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "Tweed veut monter un «[pause=5] service de garde de plantes[pause=5] ».[pause=0] Il a déjà tué trois cactus.[pause=0] Les siens.", "Normal")
		UI:WaitShowDialogue("Bonne expédition,[pause=10] vous.[pause=0] Et ne vous pressez pas.[pause=0] Les montagnes sont là depuis longtemps.[pause=0] Elles attendront bien que vous soyez prudents.")
	else
		GeneralFunctions.StartConversation(chara, "Booon...[pause=0] Encore une belle journée pour ne rien précipiter.", "Normal")
		UI:WaitShowDialogue("Tweed dit que je manque d'ambition.[pause=0] Je dis que j'ai l'ambition d'être tranquille.[pause=0] On n'a pas fini d'en débattre.[pause=0] Enfin,[pause=10] lui débat.[pause=0] Moi j'écoute.")
	end
	GeneralFunctions.EndConversation(chara)
end 

--Maris explains to Tweed why his plan wasn't going to work, Tweed understands but then doubles down and says he just needs a better scheme. Maris groans.
function metano_water_home_ch_5.Floatzel_Quagsire_Conversation(chara, activator)
	local tweed = CH('Floatzel')
	local maris = CH('Quagsire')
	if tweed == nil or maris == nil then return end
	UI:SetSpeaker(maris)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("...et c'est pour ça que vendre l'eau de pluie «[pause=5] millésimée[pause=5] » ne marchera pas,[pause=10] Tweed.[pause=0] Tout le monde a un toit.")
	UI:SetSpeaker(tweed)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue("Tu as raison...[pause=0] Tu as toujours raison,[pause=10] Maris...")
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue("Il me faut juste un MEILLEUR plan ![pause=0] L'eau de pluie d'ALTITUDE ![pause=0] Récoltée sur le Mont Venteux ![pause=0] LES GENS PAIERONT POUR LE PRESTIGE !")
	UI:SetSpeaker(maris)
	GROUND:CharSetEmote(maris, "sweating", 1)
	UI:WaitShowDialogue("Boooooooon...")
end