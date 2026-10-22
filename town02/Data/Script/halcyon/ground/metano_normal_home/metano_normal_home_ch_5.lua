require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_normal_home_ch_5 = {}

function metano_normal_home_ch_5.SetupGround()
	local furret, linoone, sentret =
		CharacterEssentials.MakeCharactersFromList({
			{'Furret', 104, 152, Direction.Right},
			{'Linoone', 104, 152, Direction.Right},
			{'Sentret', 104, 152, Direction.Right}
		})

end

--his family sees him off. Wishes him luck, tells him to stay safe, find something cool, etc.
function metano_normal_home_ch_5.Farewell_Cutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	local furret = CH('Furret')
	local linoone = CH('Linoone')
	local sentret = CH('Sentret')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)

	local zigzagoon = CharacterEssentials.MakeCharactersFromList({
			{'Zigzagoon', 172, 120, Direction.Up}
		})

	GROUND:TeleportTo(linoone, 172, 88, Direction.Down)
	GROUND:TeleportTo(furret, 148, 104, Direction.DownRight)
	GROUND:TeleportTo(sentret, 196, 104, Direction.DownLeft)

	GeneralFunctions.CenterCamera({hero, partner})

	GAME:FadeIn(20)

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_001'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	SOUND:FadeOutBGM(60)
	GeneralFunctions.PanCamera(nil, nil, false, 1.5, 184, 112)
	GAME:WaitFrames(20)

	SOUND:PlayBGM("Sympathy.ogg", true)
	UI:SetSpeaker(linoone)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_002']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_003']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(furret)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_004']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_005'], CharacterEssentials.GetCharacterName("Breloom"), CharacterEssentials.GetCharacterName("Girafarig")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_006']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(linoone)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_007']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(furret)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(furret, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_008']))
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(furret, "", 0)
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_009']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_011']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_012'], CharacterEssentials.GetCharacterName("Growlithe")))
	GAME:WaitFrames(20)

	GeneralFunctions.DoubleHop(sentret, nil, nil, nil, nil, true)
	UI:SetSpeaker(sentret)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_013']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_014'], zigzagoon:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_015'], sentret:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(linoone)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_016'], zigzagoon:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_017']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_018']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_019']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(furret)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_021']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_022']))
	GAME:WaitFrames(10)

	GeneralFunctions.Hop(zigzagoon)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_024']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_025']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(linoone)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_026']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_027']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(sentret)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_028']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(furret)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_029']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_030']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_031']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(linoone)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_032']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(sentret)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_033']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_034'], sentret:GetDisplayName()))
	GAME:WaitFrames(20)


	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_035'], CharacterEssentials.GetCharacterName("Growlithe")))
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_036']))
	GAME:WaitFrames(30)

	GeneralFunctions.DoubleHop(zigzagoon)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_037']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(sentret)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_038'], zigzagoon:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(furret)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_039']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(linoone)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_040'], zigzagoon:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_041']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_042']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_043'], hero:GetDisplayName(), partner:GetDisplayName()))
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_044']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_045']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_046']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_047'], zigzagoon:GetDisplayName()))
	GAME:WaitFrames(20)

	--todo: blush for almotz if the portrait ever comes up
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_048']))
	GAME:WaitFrames(30)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_049']))
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_050'], CharacterEssentials.GetCharacterName("Growlithe")))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_051'], hero:GetDisplayName(), zigzagoon:GetDisplayName()))
	GAME:WaitFrames(20)

	GeneralFunctions.Hop(zigzagoon)
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_052']))

	GAME:WaitFrames(20)

	--sync this up better...
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
												  GAME:WaitFrames(30)
												  GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
												  GAME:WaitFrames(20)
												  GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 4)
												  GAME:WaitFrames(24)
												  GROUND:CharSetAction(zigzagoon, RogueEssence.Ground.PoseGroundAction(zigzagoon.Position, zigzagoon.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(120)

	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(zigzagoon)
	GAME:WaitFrames(40)

	--they leave, end cutscene.



--[[

	second draft
	Linoone: ...You're leaving on the expedition today?

	zigzagoon: Yup. The Guildmaster announced we'd be departing later today.

	Furret: It's kinda sudden though, isn't it? You said the guild was going on an expedition, but we thought there'd be more warning!

	zigzagoon: Yeah. The Guildmaster wants us to leave now that Kino and Reinier are back.
	I thought he'd give them a day or two to rest, but it seems he's eager to get going.

	Linoone: It's unfortunate you have to leave on such little notice, but... we understand. I'm sure your Guildmaster knows best.

	Furret: Sounds more to me like he's just as excited as you are for this expedition, hehe!

	zigzagoon: Hehe, maybe. It is all very exciting, but...
	I'm feeling nervous too. This is my first expedition... It's daunting.
	I've studied and trained and prepared but, I'm still worried I might not pull my weight...
	I don't want to let Hyko, the Guildmaster, or anyone else down!

	Sentret: No way! You're an adventurer, and adventurers are awesome!
	You're gonna do a great job, Almotz! And the expedition's gonna be a big success, and you're gonna find something really cool!

	zigzagoon: Timmi...

	Linoone: Your brother's right, Almotz.
	I'm worried about all the trouble and dangers you'll face on your journey ahead...
	But you're a smart and capable Pokemon. I know you'll do great.
	Just stay safe, okay? We don't want to see you hurt. Keep your wits about you!

	Furret: And don't push yourself too hard. Make sure you get plenty of rest!
	I know this expedition is very important and a lot of work, but you have to take care of yourself too, you know?

	zigzagoon: Mom... Dad...
	(nods)
	Yeah! You're right! I can do this!
	I'm gonna try my absolute hardest! I'll learn and do everything that I can!
	I'll make you and everyone else proud!

	Linoone: I know you will. And when you come back home...
	...Be sure to share with me all your writings. I'd love to read about your adventure!

	Timmi: Oh, I'd love it if you brought home a really cool treasure! Something really awesome!

	Furret: Hey, you know what I'd love...?

	*hugs his son*

	Furret: ...A hug!

	zigzagoon: Dad...

	Linoone: You know, I'd love one too.

	Sentret: Oh, me too!

	(her and timmi join in)

	Zigzagoon: Mom... Timmi...

	(pause, hug eventually ends)

	zigzagoon: ...Well, I'd better get going. I still need to prepare with Hyko for our long journey ahead.

	(slowly walks away while they watch him, then he turns back towards them)

	zigzagoon: Goodbye, everyone. I'll... I'll do my best!

	Timmi: Bye, Almotz! Hope you find lots of cool stuff!

	Furret: Good luck! Don't push yourself too hard!

	Linoone: Almotz... enjoy the expedition. I know how fulfilling adventuring is for you.
	Just... come back home safe.

	zigzagoon: (nods (or jumps because no nod anim)) I will! See you all again soon!

	(walks away, eventually finds you and the player just eavesdropping in)

	zigzagoon (surprised): O-oh! Player, partner! H-how long have you been standing there?

	Partner (Sweating): U-um, a little while, sorry. We didn't mean to intrude on you like this...

	zigzagoon: No, it's okay. It is a little embarrassing, but...
	I care about my family a lot, so it doesn't bother me if other people know that.

	Partner: Aww, that's sweet, Almotz. I can see your family cares about you deeply too.

	zigzagoon: Heheh...

	(pause)

	Zigzagoon: Well, I'd better go prepare for the expedition.
	(sigh) I know Hyko probably hasn't gotten much work done without me...

	Partner: Hero and I should go get ready too. Let's make this expedition a success, Almotz!

	zigzagoon (nod): Yeah! Let's all do our best!

	(All turn towards the camera and strike a pose - afer a short pause, Almotz leaves, and you get control back)

	first draft
	UI:SetSpeaker(linoone)
	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	GeneralFunctions.EmoteAndPause(linoone, "Shock", false)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_053']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_054']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(furret)
	GeneralFunctions.SetEmotion("Worried")
	GROUND:CharSetEmote(furret, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_055']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_056']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_057'], CharacterEssentials.GetCharacterName("Breloom"), CharacterEssentials.GetCharacterName("Girafarig")))
	GAME:WaitFrames(20)

	UI:SetSpeaker(linoone)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_058']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_059']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_060'], CharacterEssentials.GetCharacterName("Growlithe")))
	GAME:WaitFrames(20)



	]]--

	SV.Chapter5.SawZigzagoonFamilyCutscene = true

	--SORTIE GARANTIE. La scene armait CutsceneMode(true) ligne 26 et
	--DisableCharacterAI ligne 27 sans jamais les desarmer : le commentaire
	--« they leave, end cutscene. » ligne 260 disait l'intention, le code
	--manquait. Consequence en jeu : GroundScene.ProcessInput sort en
	--yield break tant que Save.CutsceneMode est vrai (GroundScene.cs:176),
	--donc plus aucune entree joueur, menu compris. Et comme CutsceneMode
	--est un champ de la SAUVEGARDE (ScriptGame.cs:1382), le gel survivait
	--au rechargement, avec SawZigzagoonFamilyCutscene deja pose : la scene
	--ne se rejouait pas et rien ne remettait la main au joueur.
	--Patron repris de RaidScenes.lua:313-320.
	pcall(function()
		UI:ResetSpeaker()
		if partner ~= nil then
			AI:EnableCharacterAI(partner)
			AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
		end
	end)
	GAME:CutsceneMode(false)

end

--Have fun! Make sure to get plenty of rest!
function metano_normal_home_ch_5.Furret_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Vous êtes rentrés ![pause=0] Et Almotz aussi,[pause=10] entier des oreilles à la queue.[pause=0] Merci.[pause=0] Merci mille fois.", "Happy")
		UI:WaitShowDialogue("Il n'arrête pas de raconter la montagne aux petits.[pause=0] À chaque fois,[pause=10] le gardien devient plus grand et le vent plus fort.")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue("Ce soir,[pause=10] gratin de Baies Oran pour tout le monde.[pause=0] Et vous êtes invités.[pause=0] Ce n'est pas une question,[pause=10] c'est un fait.")
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "Oh,[pause=10] vous devez être les amis de mon fils ![pause=0] Il part avec vous,[pause=10] n'est-ce pas ?", "Normal")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue("Il a promis de revenir entier.[pause=0] Veillez à ce qu'il tienne parole,[pause=10] voulez-vous ?[pause=0] C'est mon aîné.[pause=0] Le premier à quitter le terrier.")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue("...Et dites-lui de manger.[pause=0] Il oublie de manger quand il est nerveux.[pause=0] Je vous ai glissé des Baies dans son sac.[pause=0] Ne lui dites pas.")
	else
		GeneralFunctions.StartConversation(chara, "Oh,[pause=10] vous devez être les amis de mon fils ![pause=0] Entrez,[pause=10] entrez.[pause=0] Chez nous,[pause=10] la porte ne ferme jamais vraiment.", "Happy")
		UI:WaitShowDialogue("Avec huit petits à la maison,[pause=10] fermer une porte n'a de toute façon aucun effet.[pause=0] Aucun.")
	end
	GeneralFunctions.EndConversation(chara)
end

--woah an expedition is so cool! Adventurers are so cool! I want to be like my big brother one day!
function metano_normal_home_ch_5.Sentret_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Mon grand frère a vu la LUMIÈRE de la montagne ![pause=0] En vrai ![pause=0] C'est le plus fort de tous les frères du monde !", "Inspired")
		UI:WaitShowDialogue("Il m'a rapporté un caillou du sommet.[pause=0] Je dors avec.[pause=0] Maman dit que c'est bizarre.[pause=0] Maman ne comprend rien aux cailloux de légende.")
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "Vous partez à l'aventure avec mon grand frère ?![pause=0] LA CHANCE ![pause=0] Moi je dois encore «[pause=5] grandir un peu[pause=5] ».[pause=0] Pfff.", "Inspired")
		UI:WaitShowDialogue("Un jour,[pause=10] je serai explorateur aussi ![pause=0] J'ai déjà un bandana.[pause=0] Enfin,[pause=10] c'est une chaussette.[pause=0] Mais nouée comme un bandana.")
	else
		GeneralFunctions.StartConversation(chara, "Chuuut ![pause=0] Je m'entraîne à ramper comme un explorateur ![pause=0] Vous m'avez vu ?[pause=0] Non ?[pause=0] PARFAIT.[pause=0] C'est le but.", "Happy")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_normal_home_ch_5.Linoone_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Vous êtes des aventuriers de la guilde,[pause=10]n'est-ce pas ?[pause=0]Mon fils,[pause=10]" .. CharacterEssentials.GetCharacterName("Zigzagoon") .. ",[pause=10]m'a déjà parlé de vous.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_061']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MNH5_062']))
	GeneralFunctions.EndConversation(chara)
end
