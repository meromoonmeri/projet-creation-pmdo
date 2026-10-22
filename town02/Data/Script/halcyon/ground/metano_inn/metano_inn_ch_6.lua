--[[
    metano_inn_ch_6.lua

    L'AUBERGE DE PAWPA ET MONNA — chapitre 6 (etage jusqu'ici muet)
    ================================================================
    metano_inn n'avait aucun scenario au-dela du chapitre 5. Les deux
    comptoirs (Innkeeper_Desk_Left/Right) et les 3 PNJ de la famille
    tenant l'auberge etaient donc silencieux du ch6 au ch10 - deja
    signale dans init.lua (commentaire GeneralFunctions.ChapterDispatch)
    comme un manque, avec repli generique en attendant ce fichier.

    CASTING (verifie CharacterEssentials.lua + chapitres precedents) :
      Nidoking  = Pawpa (pere, tient le comptoir gauche, direct et bref)
      Nidoqueen = Monna (mere, tient le comptoir droit, protectrice)
      Nidorina  = Dottir (fille, aide "surtout quand papa regarde")
      Nidoran_M = Junior (client de passage recurrent depuis ch2-5,
                  PAS un membre de la famille - locataire regulier)

    DEUX FILS :
      1. REACTION A L'ACTUALITE — Pawpa juge l'auberge plus animee
         depuis l'arrivee des rivales (plus de clients de passage) ;
         Monna s'inquiete que Dottir veuille absolument les voir.
      2. CONTINUITE — Dottir reste dans son registre etabli (aide
         quand son pere regarde) mais s'echappe cette fois pour
         epier les clientes celebres.

    ETATS : early / pre / during / post, sur SV.Chapter6.
    DazzlingIntroPlayed / MissionAccepted / MissionComplete.

    Positions reprises des chapitres precedents (verifiees
    praticables) : Nidoking/Nidoqueen aux marqueurs Innkeeper_Left/
    Innkeeper_Right, Nidorina (240,168).

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

metano_inn_ch_6 = {}

function metano_inn_ch_6.SetupGround()
	local nidoqueen, nidorina, nidoking =
		CharacterEssentials.MakeCharactersFromList({
			{'Nidoqueen', 'Innkeeper_Right'},
			{'Nidorina', 240, 168, Direction.DownLeft},
			{'Nidoking', 'Innkeeper_Left'}
		})

	GAME:FadeIn(20)
end

function metano_inn_ch_6.Innkeeper_Desk_Left_Action(chara, activator)
	local nidoking = CH('Nidoking')
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(nidoking, STRINGS:Format(STRINGS.MapStrings['MI6_005']), "Happy")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(nidoking, STRINGS:Format(STRINGS.MapStrings['MI6_001']), "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI6_002']))
	else
		GeneralFunctions.StartConversation(nidoking, "Les affaires sont un peu calmes ces derniers temps...[pause=0] On ne reçoit qu'un ou deux clients par jour !", "Worried")
	end
	GeneralFunctions.EndConversation(nidoking)
end

function metano_inn_ch_6.Innkeeper_Desk_Right_Action(chara, activator)
	local nidoqueen = CH('Nidoqueen')
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(nidoqueen, STRINGS:Format(STRINGS.MapStrings['MI6_006']), "Happy")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(nidoqueen, STRINGS:Format(STRINGS.MapStrings['MI6_003']), "Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI6_004']))
	else
		GeneralFunctions.StartConversation(nidoqueen, "Je commence à m'inquiéter pour mon petit dernier.", "Worried")
	end
	GeneralFunctions.EndConversation(nidoqueen)
end

function metano_inn_ch_6.Nidorina_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MI6_009']), "Happy")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MI6_007']), "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI6_008']))
	else
		GeneralFunctions.StartConversation(chara, "J'aide à l'auberge quand je peux ![pause=0] Enfin...[pause=10] surtout quand papa regarde.", "Happy")
	end
	GeneralFunctions.EndConversation(chara)
end
