require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

relic_forest_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
function relic_forest_ch_1.Intro_Cutscene()
	--First cutscene
	GAME:CutsceneMode(true)
	GROUND:Hide('Teammate1')
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()

	local hero = CH('PLAYER')
	local marker = MRKR("WakeupLocation")
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)

	--set auto finish has it so the voiceover fades in and out as the complete line
	--rather than typing it out like in the personality quiz
	UI:SetAutoFinish(true)

	--chapter 1 title card
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapitre 1\n\nUn Autre Commencement\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_1", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(180)


  	UI:WaitShowVoiceOver(".........", -1)
  	UI:WaitShowVoiceOver("...Les yeux proches pour rêver de royaumes fantastiques...", -1)
	UI:WaitShowVoiceOver("...Les yeux ouverts pour rencontrer la réalité franche...", -1)
	UI:WaitShowVoiceOver("...Worlds apart, yet intertwined.", -1)
	UI:WaitShowVoiceOver(".........", -1)
	UI:WaitShowVoiceOver("Où est-ce que cela vous mène ?", -1)

	UI:SetAutoFinish(false)

	GAME:WaitFrames(120)

	GAME:FadeIn(120)
	GAME:WaitFrames(120)
	UI:ResetSpeaker()
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	GeneralFunctions.SetEmotion('Pain')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_001']))
	GAME:WaitFrames(60)
	GAME:FadeOut(false, 120)

	SV.Chapter1.PlayedIntroCutscene = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")



end


function relic_forest_ch_1.PartnerFindsHeroCutscene()
--[color=#FFFF00]Riolu[color]
--[color=#00FFFF]Erleuchtet[color]

	--clear party, set up party with hero as player and partner as partner
	GeneralFunctions.DefaultParty(true)
	--[[
	local h = GAME:GetPlayerAssemblyMember(0)
	local p = GAME:GetPlayerPartyMember(0)
	GAME:RemovePlayerAssembly(0)
	GAME:RemovePlayerTeam(0)

	GAME:AddPlayerTeam(h)
	GAME:AddPlayerTeam(p)
	GAME:SetTeamLeaderIndex(0)

	--spawn partner in manually, this is a special case because of party shenanigans
	COMMON.RespawnAllies()
	]]--



	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local marker = MRKR("WakeupLocation")
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)

	--remove yellow color coding put on partner's nickname before Relic Forest
	GAME:SetCharacterNickname(GAME:GetPlayerPartyMember(1), string.sub(GAME:GetCharacterNickname(GAME:GetPlayerPartyMember(1)), 16, string.len(GAME:GetCharacterNickname(GAME:GetPlayerPartyMember(1))) - 7))

	SOUND:StopBGM()
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(300, 536, 1, false)
	GROUND:TeleportTo(partner, 292, 616, Direction.Up)
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	SOUND:PlayBGM('In the Depths of the Pit.ogg', true)


	--walk into frame from the bottom
	GeneralFunctions.MoveCharAndCamera(partner, 292, 528, false, 1)
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Up)

	--celebrate that you made it through
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_002']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_003'], CharacterEssentials.GetCharacterName("Relicanth")))
	GAME:WaitFrames(40)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_004']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_005']))
	SOUND:PlayBattleSE('EVT_Emote_Startled_2')
	GeneralFunctions.DoubleHop(partner)
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_006']))
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GAME:WaitFrames(20)


	--look around a bit
	GeneralFunctions.LookAround(partner, 2, 4, false, true, false, Direction.Up)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Normal')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_007']))
	GAME:WaitFrames(20)

	--huh? something's over there?
	GeneralFunctions.MoveCharAndCamera(partner, 292, 408, false, 1)
	GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.UpLeft)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GROUND:CharSetEmote(partner, "notice", 1)
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_008']))
	GeneralFunctions.MoveCharAndCamera(partner, 292, 360, false, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)

	--"Waah! Someone has collapsed on the sand!"
	--SOUND:PlayBattleSE('EVT_Emote_Startled')
	--GROUND:CharSetAnim(partner, 'Hurt', true)
	--GROUND:CharSetEmote(partner, "shock", 1)
	GeneralFunctions.Recoil(partner)
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, 'None', true)

	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_009']))
	GeneralFunctions.MoveCharAndCamera(partner, 292, 272, true, 4)
	GeneralFunctions.MoveCharAndCamera(partner, 268, 272, true, 4)

	GAME:WaitFrames(10)
	GeneralFunctions.Hop(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_010']))
	GAME:WaitFrames(80)

	--step in and out twice, facing forward the entire time
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_011']))
	GROUND:MoveInDirection(partner, Direction.Left, 4, false, 2)
	GAME:WaitFrames(1)
	GROUND:AnimateInDirection(partner, "Walk", Direction.Left, Direction.Right, 4, 1, 2)
	GAME:WaitFrames(6)
	GROUND:MoveInDirection(partner, Direction.Left, 4, false, 2)
	GAME:WaitFrames(1)
	GROUND:AnimateInDirection(partner, "Walk", Direction.Left, Direction.Right, 4, 1, 2)

	--wakeup
	GAME:WaitFrames(40)
	GeneralFunctions.Shake(hero)
	GAME:WaitFrames(30)
	UI:SetSpeaker(hero)
	GeneralFunctions.HeroDialogue(hero, "(...)", "Pain")
	GROUND:CharSetAnim(hero, 'Wake', false)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, 'None', true)
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "exclaim", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim")
	GAME:WaitFrames(40)
	GROUND:AnimateInDirection(partner, "Walk", Direction.Left, Direction.Right, 8, 1, 1)

	GeneralFunctions.LookAround(hero, 4, 4, true, false, false, Direction.Right)
	GAME:WaitFrames(40)

	--partner is relieved you arent dead
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_012']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_013'], partner:GetDisplayName()))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_014']))

	--amnesia
	local hero_species = _DATA:GetMonster(hero.CurrentForm.Species):GetColoredName()
	local partner_species = _DATA:GetMonster(partner.CurrentForm.Species):GetColoredName()
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	GeneralFunctions.Recoil(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_015']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_016'], hero_species))

	--hero realizes they are a pokemon, pinches themselves to see if they are dreaming
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, "question", 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	GAME:WaitFrames(60)
	GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Right)
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(hero, "shock", 1)
	SOUND:PlayBattleSE("EVT_Emote_Shock")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format("(Qu-quoi !?[pause=0] Je suis " .. hero_species .. "!)"), "Surprised")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format("(Ce doit être un rêve ![pause=0] Il est impossible que je sois vraiment devenu " .. hero_species .. "!)"), "Surprised")
	GeneralFunctions.HeroDialogue(hero, "(Je vais juste me pincer tout de suite et me réveiller !)", "Surprised")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, "shock", 1)
	SOUND:PlayBattleSE("DUN_Bounced")--pinch sfx
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Yowch!)", "Pain")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(Je suis toujours là !?[pause=0]C'est en fait réel !?)", "Surprised")
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(hero, "sweating", 1)
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format("(I can't believe this...[pause=0] I'm really [a/an] " .. hero_species .. "...)"), "Worried")--at some point, should comment on how being a Pokémon is actually sick, just initially shocked and overwhelmed which is why they reacted like this
	GeneralFunctions.HeroDialogue(hero, "(Mais comment est-ce arrivé ?[pause=0]Je ne me souviens de rien...)", "Worried")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)

	--human? this a joke?
	GROUND:CharSetEmote(partner, "question", 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	GAME:WaitFrames(40)
	--maybe add a hop at the end of the dialogue
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_017']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_018']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_019'], hero_species))


	GROUND:CharSetEmote(hero, "exclaim", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GAME:WaitFrames(20)
	GeneralFunctions.ShakeHead(hero, nil, true)
	GAME:WaitFrames(10)

	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_021']))
	GAME:WaitFrames(20)


	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(hero, "sweating", 1)
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(Est-ce vraiment si difficile de croire que je suis un humain ?)", "Sad")
	GAME:WaitFrames(60)
	GeneralFunctions.HeroDialogue(hero, "(Ce " .. partner_species .. " ne me croit pas...[pause=0]Quelqu'un d'autre le ferait-il ?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Je ne me souviens de rien...[pause=0]Que vais-je faire ?)", "Worried")


	--partner realizes you're scared and lost
	GAME:WaitFrames(40)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GROUND:CharSetEmote(partner, "notice", 1)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_022'], GeneralFunctions.GetPronoun(hero, 'they', true), GeneralFunctions.Conjugate(hero, 'look'), GeneralFunctions.GetPronoun(hero, "they're", false)))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_023'], GeneralFunctions.GetPronoun(hero, 'they', true), GeneralFunctions.GetPronoun(hero, 'themself'), GeneralFunctions.GetPronoun(hero, 'they'), GeneralFunctions.GetPronoun(hero, "were")))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_024']))
	GAME:WaitFrames(40)

	--ok i believe you kinda
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_025']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_026']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_028']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_029']))
	GAME:WaitFrames(20)

	--name yourself
	GeneralFunctions.SetEmotion("Worried")
	GAME:WaitFrames(40)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_030']))
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(...Je ne pense même pas me souvenir de quelque chose d'aussi simple que ça...)", "Sad")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je pourrais simplement choisir quelque chose que j'aimerais appeler,[pause=10]je suppose.)", "Normal")
	GAME:WaitFrames(20)
	UI:ResetSpeaker()
	local yesnoResult = false
	while not yesnoResult do
		UI:NameMenu("Quel sera ton nom ?", "", 60)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		GAME:SetCharacterNickname(GAME:GetPlayerPartyMember(0), result)
		UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['RF1_031'], hero:GetDisplayName()))
		UI:WaitForChoice()
		yesnoResult = UI:ChoiceResult()
	end

	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_032'], hero:GetDisplayName()))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_033'], hero:GetDisplayName()))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_034']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_035']))



	--will you come with me back to metano town?
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Left)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_036']))
	--GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_037']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_038']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_039']))
	UI:BeginChoiceMenu("Alors,[pause=10]qu'en dites-vous ?[pause=0]Veux-tu venir avec moi ?", {"Go with " .. GeneralFunctions.GetPronoun(partner, 'them'), "Refuse"}, 1, 2)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	--if you say no, loop a dialogue until you say yes
	while result == 2 do
		GAME:WaitFrames(20)
		GeneralFunctions.Recoil(partner)
		GROUND:CharSetAnim(partner, 'None', true)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_040']))
		SOUND:PlayBattleSE('EVT_Emote_Sweating')
		GROUND:CharSetEmote(partner, "sweating", 1)
		GAME:WaitFrames(40)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_041'], hero:GetDisplayName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_042']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_043']))
		GAME:WaitFrames(20)
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_044']))
		UI:BeginChoiceMenu("Alors s'il vous plaît...[pause=0]Veux-tu revenir avec moi ?", {"Go with " ..  GeneralFunctions.GetPronoun(partner, 'them'), "Refuse"}, 1, 2)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
	end

	--player agrees
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(Je n'ai pas vraiment beaucoup d'options ici...)", "Worried")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Mais " .. partner:GetDisplayName() .. " semble gentil.[pause=0]S'en tenir à " .. GeneralFunctions.GetPronoun(partner, 'them') .. " pour l'instant semble être une bonne idée.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(En plus...[pause=0], j'ai un étrange bon pressentiment à propos de " .. partner:GetDisplayName() .. ".)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)

	--hooray we'll have to go thru the dungeon though
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_045']))
	GeneralFunctions.SetEmotion("Worried")
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(16)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_046']))
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GAME:WaitFrames(16)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_047']))

	--lets look around before leaving
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_048']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_049']))
	GAME:WaitFrames(20)


	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.MoveCharAndCamera(partner, 293, 247, false, 1)
											GeneralFunctions.MoveCharAndCamera(partner, 293, 218, false, 1) end)
	GAME:WaitFrames(40)
	GeneralFunctions.EightWayMove(hero, 270, 236, false, 1)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)

	--wow a stone tablet
	GeneralFunctions.EmoteAndPause(hero, "Question", true)
	GeneralFunctions.HeroDialogue(hero, "(Hein ?[pause=0]Il y a un obélisque en pierre ici.)", "Normal")

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Normal')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_050']))
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_051']))
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Normal')
	GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_052']))
	GeneralFunctions.SetEmotion('Worried')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_053']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Inspired')
	GeneralFunctions.Hop(partner)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_054']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_055']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	GROUND:CharSetEmote(partner, "", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_056']))
	GAME:WaitFrames(20)


	--touch the tablet
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:MoveToPosition(partner, 293, 210, false, 1)
	GAME:WaitFrames(20)
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GAME:WaitFrames(40)

	GeneralFunctions.Monologue(partner:GetDisplayName() .. " a frotté l'ancienne tablette de pierre.")
	UI:SetSpeaker(partner)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:AnimateToPosition(partner, "Walk", Direction.Up, 293, 218, 1, 1, 0)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)

	--ask hero to try
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_057'], hero:GetDisplayName()))

	--partner moves out of way, hero tries looking and touching
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(partner, "Walk", Direction.Left, 317, 218, 1, 1, 0) end)
	GAME:WaitFrames(32)
	GROUND:MoveToPosition(hero, 293, 218, false, 1)
	TASK:JoinCoroutines({coro1})
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	--sense a vague connection with the tablet

	GeneralFunctions.HeroDialogue(hero, "(C'est à droite de " .. partner:GetDisplayName() .. ".[pause=0]Il y a une écriture bizarre sur la tablette.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Je vais aussi essayer pour avoir de la chance alors.)", "Normal")
	GROUND:MoveToPosition(hero, 293, 210, false, 1)
	GAME:WaitFrames(20)
	GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))

	GAME:WaitFrames(40)
	GeneralFunctions.Monologue(hero:GetDisplayName() .. " a frotté l'ancienne tablette de pierre.")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, "notice", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Rien ne semble sortir de l'ordinaire ici,[pause=10]mais...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Quelque chose à propos de cette tablette me donne une étrange tension partout.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Mais pourquoi ?[pause=0]Il ne semble y avoir rien d'exceptionnel à propos de cette tablette...)", "Worried")
	GAME:WaitFrames(20)

	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:AnimateToPosition(hero, "Walk", Direction.Up, 293, 218, 1, 1, 0)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
	GAME:WaitFrames(16)
	GeneralFunctions.HeroSpeak(hero, 60)

	--couldnt really learn anything meaningful from touching the tablet.
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_058']))
	GAME:WaitFrames(20)
	--GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_059']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_060']))
	GAME:WaitFrames(20)

	--nothing else is nearby. Let's leave.
	GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.Left)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_061']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_062']))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_063']))
	GAME:WaitFrames(20)

	--leave together,
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 317, 298, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.WaitThenMove(hero, 293, 298, false, 1, 20) end)
	GAME:WaitFrames(40)
	GAME:FadeOut(false, 40)
	TASK:JoinCoroutines({coro1, coro2})

	SV.Chapter1.PartnerMetHero = true
	--set team name temporarily to hero and partners name
	GAME:SetTeamName(hero.Nickname .. " and " .. partner.Nickname)
	GAME:CutsceneMode(false)

	--relic forest dungeon round 2
	GAME:EnterDungeon("relic_forest", 0, 4, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)

end

--the duo wiped trying to make it back to town
function relic_forest_ch_1.WipedInForest()
	--reset party
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(294, 520, 1, false)
	GROUND:TeleportTo(hero, 276, 512, Direction.Left)
	GROUND:TeleportTo(partner, 308, 512, Direction.Right)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GROUND:CharSetAnim(hero, 'EventSleep', true)

	GAME:FadeIn(40)
	--SOUND:PlayBGM('In the Depths of the Pit.ogg', true) --the music has a bit of a delay to starting, so i think having it fade in as soon as the map loads is OK.

	GAME:WaitFrames(110)--slightly less than 120 frames so that the sleep animation doesnt barely start another frame before waking

	coro1 = TASK:BranchCoroutine(function () GeneralFunctions.DoAnimation(hero, 'Wake')
											 GAME:WaitFrames(10)
											 GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											 GAME:WaitFrames(40)
											 GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Left)
											 end)
	coro2 = TASK:BranchCoroutine(function () GAME:WaitFrames(10)
											 GeneralFunctions.DoAnimation(partner, 'Wake')
											 GAME:WaitFrames(15)
											 GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											 GAME:WaitFrames(40)
											 GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Right)
											 end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) --so he rotates down
											 GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function () GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2})


	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Pain')
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_064']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Normal')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_065'], hero:GetDisplayName()))

	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_066']))
	--UI:WaitShowDialogue("I wonder why that is?")

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_067']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RF1_068'], hero:GetDisplayName()), {function() return GeneralFunctions.Hop(partner) end})
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) GROUND:MoveToPosition(partner, 308, 612, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)  GROUND:MoveToPosition(hero, 276, 612, false, 1) end)
	GAME:WaitFrames(60)
	SOUND:FadeOutBGM(40)
	GAME:FadeOut(false, 40)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:CutsceneMode(false)

	--relic forest dungeon round 2
	GAME:EnterDungeon("relic_forest", 0, 4, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
end
