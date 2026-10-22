--[[
    metano_electric_home_ch_6.lua

    LA MAISON DE CAMENTRA ET RULUX — chapitre 6 (foyer jusqu'ici muet)
    ================================================================
    metano_electric_home avait ete corrige au chapitre 5 (bug de
    require manquant, cf. commentaire de init.lua) mais n'allait pas
    plus loin.

    CASTING (verifie CharacterEssentials.lua + commentaire ch5) :
      Manectric = Camentra (mere aimante, mais aveugle a l'attitude
                  rude de son mari - cf. commentaire ch5 :
                  "oblivious of her husband's harsh approach")
      Luxray    = Rulux (le mari en question, jamais entendu
                  directement au ch5 - seule Camentra parle de lui)

    Le registre du ch5 reste implicite (Camentra minimise, ne critique
    jamais Rulux ouvertement) : on le garde tel quel, sans l'aggraver
    ni le resoudre - ce n'est pas le sujet de ce foyer.

    DEUX FILS :
      1. REACTION A L'ACTUALITE — Camentra s'emerveille des rivales,
         Rulux les juge severement ("de vraies exploratrices ne
         posent pas") en position de connaisseur auto-proclame.
      2. CONTINUITE — Camentra reste dans son role etabli : douce,
         admirative, jamais completement consciente du decalage.

    ETATS : early / pre / during / post, sur SV.Chapter6.
    DazzlingIntroPlayed / MissionAccepted / MissionComplete.

    Positions reprises du chapitre 5 (verifiees praticables) :
      Manectric (216,130), Luxray (206,194).

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

metano_electric_home_ch_6 = {}

function metano_electric_home_ch_6.SetupGround()
	local manectric, luxray =
		CharacterEssentials.MakeCharactersFromList({
			{'Manectric', 216, 130, Direction.Down},
			{'Luxray', 206, 194, Direction.Up}
		})

	GAME:FadeIn(20)
end

function metano_electric_home_ch_6.Manectric_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MEH6_005']), "Happy")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MEH6_001']), "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MEH6_002']))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MEH6_007']), "Normal")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_electric_home_ch_6.Luxray_Action(chara, activator)
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MEH6_006']), "Normal")
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MEH6_003']), "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MEH6_004']))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MEH6_008']), "Normal")
	end
	GeneralFunctions.EndConversation(chara)
end
