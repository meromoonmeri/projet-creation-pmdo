--[[
    metano_normal_home_ch_6.lua

    LA MAISON DE JAK ET LEBIURE — chapitre 6 (foyer jusqu'ici muet)
    ================================================================
    metano_normal_home n'avait aucun scenario au-dela du chapitre 5.

    ETAT VERIFIE (erreur de premiere version corrigee) : l'expedition
    du Mont Venteux est terminee a la fin du chapitre 5 (zone/
    mount_windswept/init.lua:116, la bascule Chapter5->6 a deja eu
    lieu). Almotz (Zigzagoon) est donc DE RETOUR, sain et sauf, et
    vit sa routine de PNJ en ville des le ch6 : metano_town_ch_6.lua
    le rend interactif (Zigzagoon_Action), avec une replique
    d'encouragement adressee au HEROS ET AU PARTENAIRE qui partent
    cette fois affronter Zeraora (MT6_064 : "{0} et {1} vont y aller,
    hein ? Ils sont courageux. Ou fous. Ou les deux."). Almotz
    n'accompagne pas cette mission : ce n'est plus son expedition.

    Autre fait etabli (MT6_094, apres mission) : c'est ALMOTZ qui
    raconte l'exploit du duo A SA PROPRE FAMILLE ("Almotz a raconte
    votre exploit a sa famille. Sa mere a pleure. De fierte, je
    crois."). La famille n'attend donc aucune lettre : elle a deja
    Almotz sous son toit, et c'est LUI qui leur rapporte les
    nouvelles de la ville, pas l'inverse.

    CASTING (verifie CharacterEssentials.lua + ch5) :
      Furret   = Jak (pere, "huit petits a la maison")
      Linoone  = Lebiure (mere)
      Sentret  = Timmi (petit frere, veut devenir explorateur)
      Zigzagoon = Almotz (grand frere, de retour de son expedition
                  ch5 - PAS absent au ch6)

    DEUX FILS :
      1. REACTION A L'ACTUALITE — la famille, forte du recul
         d'Almotz sur sa propre expedition (ch5), juge les rivales a
         l'aune de ce qu'elles savent d'un vrai voyage difficile :
         ni impressionnees ni mefiantes, juste dubitatives qu'on
         puisse refuser d'aider un enfant.
      2. CONTINUITE — Almotz est rentre changé (fil ch5 : il partait
         nerveux, incertain de sa place) ; sa famille le voit
         differemment maintenant, plus confiant, et le raconte a
         qui veut l'entendre.

    ETATS : early / pre / during / post, sur SV.Chapter6.
    DazzlingIntroPlayed / MissionAccepted / MissionComplete.

    Positions reprises des POSITIONS FINALES de la scene d'adieu ch5
    (verifiees praticables) : Linoone (172,88), Furret (148,104),
    Sentret (196,104).

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

metano_normal_home_ch_6 = {}

function metano_normal_home_ch_6.SetupGround()
	local linoone, furret, sentret =
		CharacterEssentials.MakeCharactersFromList({
			{'Linoone', 172, 88, Direction.Down},
			{'Furret', 148, 104, Direction.DownRight},
			{'Sentret', 196, 104, Direction.DownLeft}
		})

	GAME:FadeIn(20)
end

function metano_normal_home_ch_6.Furret_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MNH6_007']), "Happy")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MNH6_001']), "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH6_002'], CharacterEssentials.GetCharacterName("Zigzagoon")))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MNH6_005']), "Happy")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_normal_home_ch_6.Linoone_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MNH6_008']), "Happy")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MNH6_003']), "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH6_004'], CharacterEssentials.GetCharacterName("Zigzagoon")))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MNH6_006']), "Normal")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_normal_home_ch_6.Sentret_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MNH6_012'], CharacterEssentials.GetCharacterName("Zigzagoon")), "Inspired")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MNH6_009']), "Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH6_010'], CharacterEssentials.GetCharacterName("Zigzagoon")))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MNH6_011']), "Happy")
	end
	GeneralFunctions.EndConversation(chara)
end
