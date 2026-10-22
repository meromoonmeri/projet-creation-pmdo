--[[
    metano_fire_home_ch_6.lua

    LA MAISON DE DOTRA — chapitre 6 (foyer jusqu'ici muet)
    ================================================================
    CE QUE CE FICHIER CORRIGE
    ------------------------------------------------------------------
    metano_fire_home n'avait aucun scenario au-dela du chapitre 5 :
    Data/Script/halcyon/ground/metano_fire_home/init.lua ne couvrait
    que les chapitres 2 a 5, et retombait sur un simple GAME:FadeIn(20)
    ensuite. La maison de Dotra (Camerupt) et Nubbor (Numel) restait
    donc vide de la meme maniere que 8 autres foyers de Metano des le
    retour de l'expedition du Mont Venteux.

    CE QUE RACONTE CETTE SCENE
    ------------------------------------------------------------------
    Deux fils, comme au chapitre 5 :
      1. REACTION A L'ACTUALITE — l'arrivee de la Team Dazzling, vue
         depuis un foyer ordinaire plutot que depuis la place publique
         (deja couverte par TownVoices.CH6 et metano_town_ch_6.lua).
      2. CONTINUITE PERSONNELLE — Nubbor grandit. Le fil est le meme
         qu'aux chapitres 2 a 5 (corvees, gateaux de lave, inquietude
         maternelle) : on ne l'abandonne pas au premier chapitre venu.

    ETATS (memes conditions que Ch6State() dans metano_town_ch_6.lua,
    relues directement sur SV.Chapter6 pour ne pas dupliquer une
    fonction locale a un autre fichier) :
      early   avant l'arrivee des rivales
      pre     les rivales sont en ville, la mission n'est pas prise
      during  l'equipe est partie affronter Zeraora
      post    la mission est terminee

    REGLES DU PROJET
      * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
      * La Voix ne parle jamais en ville.
      * Aucun personnage des jeux d'origine nomme.
      * Texte via STRINGS.MapStrings (fichier de GROUND, pas global).
      * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_fire_home_ch_6 = {}

function metano_fire_home_ch_6.SetupGround()
	--Position deja verifiee praticable au chapitre 5 (case libre,
	--aucune collision) : on la reprend a l'identique.
	local camerupt =
		CharacterEssentials.MakeCharactersFromList({
			{'Camerupt', 256, 136, Direction.Down}
		})

	GAME:FadeIn(20)
end

function metano_fire_home_ch_6.Camerupt_Action(chara, activator)
	local numel_name = CharacterEssentials.GetCharacterName("Numel")

	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MFH6_007'], numel_name), "Happy")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MFH6_008']))
	elseif SV.Chapter6.MissionAccepted then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MFH6_005']), "Worried")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MFH6_006'], numel_name))
	elseif SV.Chapter6.DazzlingIntroPlayed then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MFH6_003']), "Surprised")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MFH6_004'], numel_name))
	else
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MFH6_001']), "Normal")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MFH6_002'], numel_name))
	end
	GeneralFunctions.EndConversation(chara)
end
