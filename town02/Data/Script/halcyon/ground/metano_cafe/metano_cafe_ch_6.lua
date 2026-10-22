--[[
    metano_cafe_ch_6.lua

    LE CAFE DE SHUCKLE — chapitre 6 (clients jusqu'ici muets)
    ================================================================
    metano_cafe n'avait aucun scenario au-dela du chapitre 5.

    CASTING (verifie CharacterEssentials.lua + ch5) :
      Gulpin    = Boosmu (gourmand compulsif, adore les boissons offertes)
      Lickitung = Urgil (client habituel, un peu blase)
      Cleffa    = Primonna (petite fille qui ecoute les conversations
                  des grands en cachette - fil "Chuuut... j'ecoute")
      Aggron    = Rubble (ex-mineur, raconte des legendes du passe -
                  cf. LegendOfTheTitans ch5, annonce deja Regirock/
                  Regice/Registeel/le Colosse pour le ch7)

    DEUX FILS :
      1. REACTION A L'ACTUALITE — le cafe est le lieu ou les rumeurs
         circulent : Boosmu s'emerveille, Urgil doute, Primonna
         espionne, Rubble reste distant (il a deja vu passer bien des
         "explorateurs celebres" en son temps).
      2. CONTINUITE — Rubble garde son registre de conteur : il ne
         raconte pas de nouvelle legende ici (celle du ch5 suffit),
         mais y fait une allusion discrete, en gardant le silence sur
         le fond (aucune revelation supplementaire avant le ch7).

    ETATS : early / pre / during / post, sur SV.Chapter6.
    DazzlingIntroPlayed / MissionAccepted / MissionComplete.

    Positions : memes marqueurs de table qu'au chapitre 5 (stables,
    verifies presents sur le rsground) : Cafe_Table_2, Cafe_Table_1,
    Cafe_Table_13, Cafe_Table_15.

    REGLES DU PROJET
      * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
      * La Voix ne parle jamais en ville.
      * Aucun personnage des jeux d'origine nomme.
      * Texte via STRINGS.MapStrings (fichier de GROUND).
      * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_cafe_ch_6 = {}

function metano_cafe_ch_6.SetupGround()
	local gulpin, lickitung, cleffa, aggron =
		CharacterEssentials.MakeCharactersFromList({
			{'Gulpin', 'Cafe_Table_2'},
			{'Lickitung', 'Cafe_Table_1'},
			{'Cleffa', 'Cafe_Table_13'},
			{'Aggron', 'Cafe_Table_15'}
		})

	GAME:FadeIn(20)
end

function metano_cafe_ch_6.Gulpin_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MCF6_005']), "Happy")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MCF6_001']), "Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF6_002']))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MCF6_009']), "Normal")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_cafe_ch_6.Lickitung_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MCF6_006']), "Normal")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MCF6_003']), "Normal")
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MCF6_010']), "Normal")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_cafe_ch_6.Cleffa_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MCF6_007']), "Happy")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MCF6_004']), "Surprised")
	else
		GeneralFunctions.StartConversation(chara, "Chuuut...[pause=0] J'écoute les grands parler des trois dames qui font sensation en ville.[pause=0] Ne dites rien.", "Normal")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_cafe_ch_6.Aggron_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MCF6_008']), "Normal")
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MCF6_011']), "Normal")
	end
	GeneralFunctions.EndConversation(chara)
end
