require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

altere_pond_ch_5 = {}

function altere_pond_ch_5.SetupGround()
	--prevent player from going into relic forest before the expedition
	local forestBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
						RogueElements.Rect(904, 256, 8, 88),
						RogueElements.Loc(0, 0), 
						true, 
						"Event_Trigger_1")
																					
	forestBlock:ReloadEvents()

	GAME:GetCurrentGround():AddTempObject(forestBlock)
		
	GAME:FadeIn(20)
end

--Vieux Relicanth du lac : memoire vivante d'Altere, ton lent et sentencieux
function altere_pond_ch_5.Relicanth_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Mmm...[pause=0] Vous revoilà.[pause=0] L'étang m'a parlé de votre montagne bien avant votre retour.", "Normal", true, false)
		UI:WaitShowDialogue("L'eau descend des sommets,[pause=10] voyez-vous.[pause=0] Elle porte les nouvelles plus vite que les Roucool.")
		UI:WaitShowDialogue("Et ces temps-ci...[pause=0] l'eau qui descend du nord a un goût étrange.[pause=0] Un goût de lumière inquiète.[pause=0] Mmm.[pause=0] Vous savez de quoi je parle,[pause=10] je crois.")
		if not SV.Chapter5.LegendLakeHeard then
			GAME:WaitFrames(20)
			UI:WaitShowDialogue("Une lumière inquiète...[pause=0] Mmm.[pause=0] Cela me rappelle ce que ma grand-mère racontait sur les trois lacs.")
			UI:ResetSpeaker()
			UI:ChoiceMenuYesNo("Écouter la légende du vieux Relicanth ?", false)
			UI:WaitForChoice()
			if UI:ChoiceResult() then
				altere_pond_ch_5.LegendOfTheLakes(chara)
			end
		end
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "Mmm...[pause=0] Une expédition vers le nord.[pause=0] J'ai vu partir la dernière,[pause=10] il y a bien longtemps.", "Normal", true, false)
		UI:WaitShowDialogue("Je nageais déjà dans cet étang quand vos grands-parents apprenaient à marcher.[pause=0] Mmm.[pause=0][br]Les jeunes partent toujours vers le nord.[pause=0] Les sages reviennent toujours par le sud.")
		UI:WaitShowDialogue("...Ne me demandez pas ce que ça signifie.[pause=0] À mon âge,[pause=10] on dit les choses,[pause=10] et c'est aux jeunes de les comprendre.")
	else
		GeneralFunctions.StartConversation(chara, "Mmm...[pause=0] L'étang est calme aujourd'hui.[pause=0] Trop calme.[pause=0] Même les Magicarpe se taisent.", "Normal", true, false)
		UI:WaitShowDialogue("Quand les Magicarpe se taisent,[pause=10] c'est que le monde retient son souffle.[pause=0] Mmm.[pause=0] Ou qu'ils dorment.[pause=0] C'est l'un ou l'autre.")
	end
	GeneralFunctions.EndConversation(chara, false)
end 

--------------------------------------------------------------------
-- LÉGENDE : « Les Trois Lacs » (le vieux Relicanth)
-- Mentions : Uxie, Mesprit, Azelf — savoir, émotion, volonté.
-- Prépare les Sentiers du Savoir/Espoir/Courage (palier 5 du plan).
-- OST : Star Cave. Mise en scène : la surface de l'étang s'illumine.
--------------------------------------------------------------------
function altere_pond_ch_5.LegendOfTheLakes(chara)
	local hero = CH('PLAYER')
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(50)
	SOUND:PlayBGM('Star Cave.ogg', true)
	GAME:WaitFrames(30)

	UI:SetSpeaker(chara)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("On raconte...[pause=20] que lorsque le monde ouvrit les yeux pour la première fois,[pause=10] il ne savait rien,[pause=10] ne ressentait rien,[pause=10] ne voulait rien.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Alors trois étincelles descendirent se poser sur trois lacs.[pause=0] Mmm.[pause=0] Trois lacs si clairs qu'on ne sait jamais si l'on regarde l'eau ou le ciel.")
	GROUND:CharSetEmote(chara, "glowing", 1)
	UI:WaitShowDialogue("La première étincelle apprit au monde à SAVOIR.[pause=0] On la nomme [color=#FFFF00]Créhelf[color].[pause=0] Ceux qui croisent son regard,[pause=10] dit-on,[pause=10] oublient jusqu'à leur propre nom.")
	UI:WaitShowDialogue("La deuxième lui apprit à RESSENTIR.[pause=0] [color=#FF69B4]Créfollet[color].[pause=0] C'est elle qu'on remercie quand on pleure de joie sans savoir pourquoi.")
	UI:WaitShowDialogue("La troisième lui apprit à VOULOIR.[pause=0] [color=#00BFFF]Créfadet[color].[pause=0] Sans elle,[pause=10] mmm...[pause=10] personne ne se lèverait le matin.[pause=0] Personne ne partirait en expédition.")

	GAME:WaitFrames(30)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue("Ma grand-mère disait :[pause=10] «[pause=5] Tant que les trois lacs sont clairs,[pause=10] le monde sait,[pause=10] ressent et veut.[pause=5] »")
	UI:WaitShowDialogue("Mais elle disait aussi...[pause=20] «[pause=5] Le jour où une ombre boira l'un des trois lacs,[pause=10] le monde commencera à oublier.[pause=5] »[pause=0] Mmm.")

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Savoir,[pause=10] ressentir,[pause=10] vouloir...[pause=0] Et si les Anima des Cœurs étaient faits de la même eau ?)", "Worried")

	UI:SetSpeaker(chara)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue("Mmm.[pause=0] Vous avez le regard de quelqu'un qui vient de comprendre quelque chose.[pause=0] Gardez-le précieusement.[pause=0] C'est le cadeau de Créhelf.")

	SV.Chapter5.LegendLakeHeard = true
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(30)
	SOUND:PlayBGM('File Select.ogg', true)
end


function altere_pond_ch_5.Event_Trigger_1_Touch(obj, activator)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	
	GeneralFunctions.StartPartnerConversation(STRINGS:Format(STRINGS.MapStrings['AP5_004'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP5_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP5_002']))
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP5_003'], hero:GetDisplayName()))
	GeneralFunctions.EndConversation(partner)

end
