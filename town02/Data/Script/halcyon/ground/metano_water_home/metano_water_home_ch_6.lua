--[[
    metano_water_home_ch_6.lua

    LA MAISON DE TWEED ET MARIS — chapitre 6 (foyer jusqu'ici muet)
    ================================================================
    metano_water_home n'avait aucun scenario au-dela du chapitre 5.

    CASTING (verifie CharacterEssentials.lua + ch5) :
      Floatzel = Tweed (magouilleur au grand coeur, plans commerciaux
                 foireux en serie - "proposition COMMERCIALE")
      Quagsire = Maris (flegme absolu, voix de la raison, "Booon...")

    DEUX FILS, dans le registre deja etabli (ch5) :
      1. REACTION A L'ACTUALITE — Tweed y voit un plan commercial
         (merchandising Team Dazzling), Maris temporise.
      2. CONTINUITE — le duo garde son rapport habituel : lui s'emballe,
         elle absorbe.

    ETATS : early / pre / during / post, sur SV.Chapter6.
    DazzlingIntroPlayed / MissionAccepted / MissionComplete.

    Positions reprises du chapitre 5 (verifiees praticables) :
      Floatzel (232,120), Quagsire (232,168).

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

metano_water_home_ch_6 = {}

function metano_water_home_ch_6.SetupGround()
	local floatzel, quagsire =
		CharacterEssentials.MakeCharactersFromList({
			{'Floatzel', 232, 120, Direction.Down},
			{'Quagsire', 232, 168, Direction.Up}
		})

	GAME:FadeIn(20)
end

function metano_water_home_ch_6.Floatzel_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MWH6_007']), "Inspired")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWH6_008']))
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MWH6_001']), "Inspired")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWH6_002']))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MWH6_005']), "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWH6_006']))
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_water_home_ch_6.Quagsire_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MWH6_009']), "Normal")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MWH6_003']), "Normal")
		GROUND:CharSetEmote(chara, "sweating", 1)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWH6_004']))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MWH6_010']), "Normal")
	end
	GeneralFunctions.EndConversation(chara)
end
