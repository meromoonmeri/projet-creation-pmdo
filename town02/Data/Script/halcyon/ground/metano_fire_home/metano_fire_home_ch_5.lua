require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_fire_home_ch_5 = {}

function metano_fire_home_ch_5.SetupGround()

	local camerupt  = 
		CharacterEssentials.MakeCharactersFromList({
			{'Camerupt', 256, 136, Direction.Down}
		})

	
	GAME:FadeIn(20)
end

function metano_fire_home_ch_5.Camerupt_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition and not SV.Chapter5.LegendEarthHeard then
		GeneralFunctions.StartConversation(chara, "Vous voilà rentrés ![pause=0] Mon petit garçon n'a pas dormi de la semaine tellement il attendait vos histoires.", "Happy")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Un tunnel de lave,[pause=10] m'a-t-on dit ?[pause=0] Vous savez...[pause=10] dans ma famille,[pause=10] on se transmet une histoire sur le feu qui dort sous la terre.")
		UI:ResetSpeaker()
		UI:ChoiceMenuYesNo("Écouter l'histoire de Dotra ?", false)
		UI:WaitForChoice()
		if UI:ChoiceResult() then
			metano_fire_home_ch_5.LegendOfTheEarth(chara)
			return
		end
		GeneralFunctions.EndConversation(chara)
		return
	end
	GeneralFunctions.StartConversation(chara, "Mon petit garçon travaille si dur ces derniers temps,[pause=10] je suis si fière de lui !", "Happy")
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MFH5_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MFH5_002']))
	GeneralFunctions.EndConversation(chara)
end 

--------------------------------------------------------------------
-- LÉGENDE : « Celui qui Dort sous les Volcans » (Dotra, mère Camerupt)
-- Mentions : Groudon (jamais rencontre), la terre qui s'etend.
-- Transmission familiale : la legende des Camerupt, de mere en enfant.
-- OST : In the Depths of the Pit. Ton : intime, au coin du feu.
--------------------------------------------------------------------
function metano_fire_home_ch_5.LegendOfTheEarth(chara)
	local hero = CH('PLAYER')
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(50)
	SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
	GAME:WaitFrames(30)

	UI:SetSpeaker(chara)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("Chez les Camerupt,[pause=10] chaque mère la raconte à ses petits,[pause=10] le soir de leur première éruption.[pause=0] Ma mère me l'a racontée.[pause=0] Sa mère avant elle.")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(chara, "glowing", 1)
	UI:WaitShowDialogue("On raconte...[pause=20] qu'avant les continents,[pause=10] il n'y avait que l'océan.[pause=0] Et que du fond de l'océan monta un géant écarlate.")
	UI:WaitShowDialogue("[color=#FF0000]Groudon[color].[pause=0] Chacun de ses pas soulevait une île.[pause=0] Chaque battement de son cœur crachait une montagne.[pause=0] C'est lui qui a étendu la terre où nous marchons.")
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue("Puis,[pause=10] son œuvre finie,[pause=10] il s'est couché dans une caverne de magma...[pause=10] et il s'est endormi.[pause=0] Pas mort.[pause=0] ENDORMI.[pause=0] La nuance fait toute l'histoire.")
	UI:WaitShowDialogue("Chaque volcan du monde,[pause=10] disait ma mère,[pause=10] est un de ses ronflements.[pause=0] Et chaque tremblement de terre...[pause=20] un mauvais rêve.")

	GAME:WaitFrames(30)
	GeneralFunctions.HeroDialogue(hero, "(Le Tunnel Incandescent...[pause=0] Le clan de Limagma qui monte la garde...[pause=0] Sur quoi tout ce petit monde veille-t-il vraiment ?)", "Worried")

	UI:SetSpeaker(chara)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue("Mon petit,[pause=10] à la fin,[pause=10] demande toujours :[pause=10] «[pause=5] Et s'il se réveille ?[pause=5] »[pause=0] Et je réponds ce que ma mère répondait :")
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("«[pause=5] Tant qu'il y aura des cœurs qui battent au-dessus de lui,[pause=10] il rêvera qu'il n'est pas seul.[pause=0] Et il dormira tranquille.[pause=5] »")

	SV.Chapter5.LegendEarthHeard = true
	GAME:WaitFrames(30)
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(30)
	GeneralFunctions.EndConversation(chara)
end 
