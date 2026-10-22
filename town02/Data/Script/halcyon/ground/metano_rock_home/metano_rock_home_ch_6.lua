--[[
    metano_rock_home_ch_6.lua

    LA MAISON DE NAMA — chapitre 6 (foyer jusqu'ici muet)
    ================================================================
    metano_rock_home n'avait aucun scenario au-dela du chapitre 4.

    CASTING (verifie CharacterEssentials.lua) :
      Medicham = Nama (mere, philosophie de la paix interieure par la
                 meditation - "permettra la meditation et
                 l'auto-reflexion")
      Meditite = Stei (fille, peine a se faire des amis - ch4 :
                 "j'ai du mal a me faire des amis")
      Machamp  = Savran (voisin de passage, apparait seul au ch3)

    Au ch6 c'est Nama qui tient la maison (registre etabli : calme,
    detachee, tournee vers l'interieur plutot que vers l'exterieur).

    DEUX FILS :
      1. REACTION A L'ACTUALITE — Nama applique sa philosophie a
         l'arrivee des rivales : ni impressionnee ni jalouse, elle y
         voit une occasion de parler d'elle-meme a Stei.
      2. CONTINUITE — Stei et ses difficultes sociales (fil ch4) : la
         mission de Chenipent (autre enfant en detresse) resonne pour
         elle.

    ETATS : early / pre / during / post, sur SV.Chapter6.
    DazzlingIntroPlayed / MissionAccepted / MissionComplete.

    Position reprise du chapitre 2 (verifiee praticable) :
      Medicham (152,152).

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

metano_rock_home_ch_6 = {}

function metano_rock_home_ch_6.SetupGround()
	local medicham =
		CharacterEssentials.MakeCharactersFromList({
			{'Medicham', 152, 152, Direction.Left}
		})

	GAME:FadeIn(20)
end

function metano_rock_home_ch_6.Medicham_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MRH6_005']), "Normal")
	elseif SV.Chapter6.MissionAccepted then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MRH6_003']), "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MRH6_004']))
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MRH6_001']), "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MRH6_002']))
	else
		GeneralFunctions.StartConversation(chara, "Permettez une paix intérieure,[pause=10] permettra la méditation et l'auto-réflexion.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MRH6_000']))
	end
	GeneralFunctions.EndConversation(chara)
end
