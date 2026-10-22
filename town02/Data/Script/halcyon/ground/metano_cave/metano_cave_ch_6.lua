--[[
    metano_cave_ch_6.lua

    LA GROTTE DE CIEL — chapitre 6 (habitante jusqu'ici muette)
    ================================================================
    metano_cave n'avait aucun scenario au-dela du chapitre 4. Sunflora
    (Ciel) est un MapChar PERMANENT du .rsground (triggerType 1) :
    elle existe deja sur la carte quel que soit le chapitre, seul son
    dialogue etait manquant du ch5 au ch10 (deja signale dans
    init.lua, avec un repli generique en attendant ce fichier).

    CASTING (verifie CharacterEssentials.lua + ch3-ch4) :
      Sunflora = Ciel (recluse, prefere l'obscurite de la grotte a la
                 lumiere du jour - ironie du prenom "Ciel" pour un
                 Pokemon qui se terre sous terre). Registre etabli :
                 phrases courtes, hesitantes ("..."), emotion
                 "Worried" recurrente, ne cherche jamais la compagnie
                 (cf. ch4 : "Pourriez-vous sortir cet enfant d'ici ?").

    UN SEUL FIL (elle n'a pas de second personnage avec qui dialoguer
    dans cette grotte au ch6 ; Oddish n'a pas de fichier ch6 et reste
    muette comme au ch1/ch5+, cf. audit_bugs deja identifie ce trou
    plus large sur Oddish - non traite ici, hors perimetre de ce PNJ) :
      REACTION A L'ACTUALITE, filtree par son isolement volontaire :
      Ciel n'a pas VU les rivales (elle ne sort jamais), seulement
      ENTENDU parler d'elles par les rares visiteurs de la grotte -
      cela reste coherent avec son personnage plutot que de la faire
      sortir a la rencontre de la ville.

    ETATS : early / pre / during / post, sur SV.Chapter6.
    DazzlingIntroPlayed / MissionAccepted / MissionComplete.

    Aucun SetupGround necessaire : Sunflora est permanente sur la
    carte, sa position (192,152) n'est pas a recreer.

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

metano_cave_ch_6 = {}

function metano_cave_ch_6.SetupGround()
	GAME:FadeIn(20)
end

function metano_cave_ch_6.Sunflora_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MC6_004']), "Worried", true, false)
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MC6_001']), "Worried", true, false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MC6_002']))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MC6_003']), "Worried", true, false)
	end
	GeneralFunctions.EndConversation(chara, false)
end
