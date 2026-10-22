require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_cafe_ch_5 = {}

function metano_cafe_ch_5.SetupGround()
	local gulpin, lickitung, cleffa, aggron = 
		CharacterEssentials.MakeCharactersFromList({
			{'Gulpin', 'Cafe_Table_2'},
			{'Lickitung', 'Cafe_Table_1'},
			{'Cleffa', 'Cafe_Table_13'},
			{'Aggron', 'Cafe_Table_15'}
		})
	
		
	GAME:FadeIn(20)
end


function metano_cafe_ch_5.Lickitung_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "C'était gentil de la part de " .. CharacterEssentials.GetCharacterName("Shuckle") .. " d'offrir des boissons aujourd'hui,[pause=10] mais...")
	--GROUND:CharSetEmote(chara, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF5_001']))
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_5.Gulpin_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Une boisson offerte par " .. CharacterEssentials.GetCharacterName("Shuckle") .. "...[pause=0] C'est un rêve qui devient réalité !", "Inspired")
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF5_002']))
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF5_003']))
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_5.Cleffa_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Vous êtes rentrés ![pause=0] Toute la ville ne parle que de votre expédition !", "Happy")
		UI:WaitShowDialogue("Une lumière au sommet de la montagne...[pause=0] C'est vrai ?[pause=0] Vous l'avez VUE ?[pause=0] De près ?")
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue("Quand je serai grande,[pause=10] moi aussi je verrai des choses que personne ne croit.[pause=0] C'est décidé depuis aujourd'hui.")
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "C'est vrai que la guilde part TOUTE ENTIÈRE ?[pause=0] Même le grand Tropius ?", "Surprised")
		UI:WaitShowDialogue("Maman dit que c'est du jamais-vu depuis avant ma naissance.[pause=0] Et maman est née il y a TRÈS longtemps.[pause=0] Genre,[pause=10] trente ans.")
	else
		GeneralFunctions.StartConversation(chara, "Chuuut...[pause=0] J'écoute les grands parler de l'expédition.[pause=0] Si je fais semblant de boire mon jus,[pause=10] personne ne me remarque.", "Normal")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("...Vous n'allez pas me dénoncer,[pause=10] hein ?")
	end
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_5.Aggron_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Alors c'est vous,[pause=10] les héros du moment.[pause=0] Hmph.[pause=0] Asseyez-vous,[pause=10] je vous offre une tournée.", "Normal")
		UI:WaitShowDialogue("À votre âge,[pause=10] j'ai tenté la traversée de la steppe.[pause=0] Seul.[pause=0] Je me suis perdu deux jours et j'ai fini raccompagné par un troupeau d'Écrémeuh.")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("Alors trois donjons et un sommet ?[pause=0] Oui.[pause=0] Vous avez mérité votre tournée.")
		if not SV.Chapter5.LegendTitansHeard then
			GAME:WaitFrames(20)
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue("...Des ruines dans les montagnes,[pause=10] dites-vous ?[pause=0] Hmph.[pause=0] Ça me rappelle une vieille histoire de mineur.")
			UI:ResetSpeaker()
			UI:ChoiceMenuYesNo("Écouter la légende de Rubble ?", false)
			UI:WaitForChoice()
			if UI:ChoiceResult() then
				metano_cafe_ch_5.LegendOfTheTitans(chara)
			end
		end
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "Une expédition complète vers le nord...[pause=0] Ça ne s'était pas vu depuis l'ancien Maître de Guilde.", "Normal")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("Et la dernière fois,[pause=10] tous ne sont pas revenus.[pause=0] ...Bah.[pause=0] Oubliez ce que je viens de dire.[pause=0] Les vieux radotent,[pause=10] c'est connu.")
	else
		GeneralFunctions.StartConversation(chara, "Ce café est le seul endroit de la ville où le tabouret supporte mon poids.[pause=0] Je le sais.[pause=0] Je les ai tous testés.", "Normal")
		UI:WaitShowDialogue("Le Kecleon du marché me doit encore deux tabourets,[pause=10] d'ailleurs.[pause=0] Mais ça,[pause=10] c'est entre lui et moi.")
	end
	GeneralFunctions.EndConversation(chara)
end 

--------------------------------------------------------------------
-- LÉGENDE : « Les Trois Serviteurs et le Colosse » (Rubble, ex-mineur)
-- Mentions : Regirock, Regice, Registeel, et « le Colosse » (Regigigas,
-- jamais nommé). Prépare le ch7 (Aegis Cave) sans rien divulguer.
-- OST : In the Depths of the Pit. Mise en scène : le café se fige.
--------------------------------------------------------------------
function metano_cafe_ch_5.LegendOfTheTitans(chara)
	local hero = CH('PLAYER')
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(50)
	SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
	GAME:WaitFrames(30)

	UI:SetSpeaker(chara)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("Quand je travaillais à la mine,[pause=10] les anciens nous interdisaient de creuser passé la septième galerie.[pause=0] Vous savez pourquoi ?")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("On raconte...[pause=20] qu'aux premiers jours du monde,[pause=10] trois serviteurs furent taillés dans la matière brute.")
	UI:WaitShowDialogue("Un dans la roche,[pause=10] qu'on nomme [color=#FFA500]Regirock[color].[pause=0] Un dans la glace éternelle,[pause=10] [color=#00FFFF]Regice[color].[pause=0] Un dans un métal qui ne rouille jamais,[pause=10] [color=#C0C0C0]Registeel[color].")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(chara, "glowing", 1)
	UI:WaitShowDialogue("Trois serviteurs.[pause=0] Pas trois maîtres.[pause=0] Car on raconte aussi qu'ils furent bâtis pour SERVIR quelque chose de plus grand.")
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue("Un Colosse.[pause=0] Si vaste qu'il aurait remorqué les continents à la force des bras.[pause=0] Si vieux que la mousse a poussé sur ses épaules pendant son sommeil.")
	UI:WaitShowDialogue("Et on raconte...[pause=20] qu'il dort encore.[pause=0] Sous des ruines,[pause=10] quelque part au nord.[pause=0][br]Avec,[pause=10] dans la poitrine,[pause=10] un cœur qui bat trop lentement pour qu'on l'entende.")

	GAME:WaitFrames(30)
	GeneralFunctions.HeroDialogue(hero, "(Un cœur qui bat sous des ruines...[pause=0] Pourquoi est-ce que ça me donne des frissons ?)", "Worried")

	UI:SetSpeaker(chara)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("La septième galerie rendait un son creux quand on frappait la paroi.[pause=0] CREUX.[pause=0] Vous comprenez ?")
	GAME:WaitFrames(15)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue("...Bah.[pause=0] C'est une histoire de mineurs.[pause=0] On en racontait des dizaines pour passer le temps sous terre.[pause=0] Buvez,[pause=10] ça refroidit.")

	SV.Chapter5.LegendTitansHeard = true
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(30)
	SOUND:PlayBGM("Spinda's Cafe.ogg", true)
end
--[[
	GeneralFunctions.StartConversation(chara, "Vous partez en expédition aujourd'hui,[pause=10] n'est-ce pas ?[pause=0] Vous devriez prendre quelques boissons de " .. CharacterEssentials.GetCharacterName("Shuckle") .. " avec vous.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF5_004']))
	GeneralFunctions.EndConversation(chara)
	
	GeneralFunctions.StartConversation(chara, "Emportez autant de boissons de " .. CharacterEssentials.GetCharacterName("Shuckle") .. " que possible pendant votre expédition...")
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF5_005']))
	GeneralFunctions.EndConversation(chara)
]]--

