--[[
    metano_grass_home_ch_6.lua

    LA MAISON DE BOGEN ET CHRYSI — chapitre 6 (foyer jusqu'ici muet)
    ================================================================
    metano_grass_home n'avait aucun scenario au-dela du chapitre 4 :
    init.lua ne couvrait que les chapitres 2 a 4, retombant sur un
    simple GAME:FadeIn(20) ensuite.

    CASTING (verifie CharacterEssentials.lua) :
      Vileplume = Bogen (mari, angoisse chronique - "J'ai entendu dire
                  que...", "Le monde est peut-etre un endroit dangereux")
      Bellossom = Chrysi (epouse, rassurante - "Oh mon cheri, tu
                  t'inquietes trop !"). Vend des fleurs en ville
                  (TownLife.TOURNEES.Bellossom), donc absente du foyer
                  une partie du temps : Bogen est vu SEUL au marche
                  (TownVoices.CH6.Vileplume, ton "Worried" constant).

    DEUX FILS :
      1. REACTION A L'ACTUALITE — Bogen angoisse a l'idee de trois
         rivales celebres en ville (fidele a son trait : il s'inquiete
         de tout). Chrysi le rassure, fidele au patron ch4
         (Bellossom_Vileplume_Conversation).
      2. CONTINUITE PERSONNELLE — le couple parle des enfants
         (Gloom/Oddish, deja mentionnes ch2-ch4 comme leur famille).

    ETATS (memes conditions que Ch6State()) :
      early / pre / during / post, sur SV.Chapter6.DazzlingIntroPlayed
      / MissionAccepted / MissionComplete.

    Position reprise a l'identique du chapitre 4 (verifiee praticable
    sur le rsground) : Vileplume (96,136), Bellossom (96,192).

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

metano_grass_home_ch_6 = {}

function metano_grass_home_ch_6.SetupGround()
	--Positions reprises du chapitre 4 (verifiees praticables).
	local vileplume, bellossom =
		CharacterEssentials.MakeCharactersFromList({
			{'Vileplume', 96, 136, Direction.Up},
			{'Bellossom', 96, 192, Direction.Down}
		})

	GAME:FadeIn(20)
end

function metano_grass_home_ch_6.Vileplume_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MGH6_007']), "Normal")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH6_008']))
	elseif SV.Chapter6.MissionAccepted then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MGH6_005']), "Worried")
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH6_006']))
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MGH6_003']), "Worried")
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH6_004']))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MGH6_001']), "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH6_002']))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_grass_home_ch_6.Bellossom_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MGH6_013']), "Happy")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MGH6_011']), "Happy")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH6_012']))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MGH6_009']), "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MGH6_010']))
	end
	GeneralFunctions.EndConversation(chara)
end
