require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_guildmasters_room_ch_1 = {}

--TASK:BranchCoroutine(guild_guildmasters_room_ch_1.MeetGuildmaster)
function guild_guildmasters_room_ch_1.MeetGuildmaster()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local tropius = CH('Tropius')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(192, 112, 1, false)
	GROUND:EntTurn(tropius, Direction.Up)

	local box = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Yellow_Box", 1), --anim data. Don't set that number to 0 for valid anims
								 				 RogueElements.Rect(184, 144, 16, 16),--xy coords, then size
								  				 RogueElements.Loc(4, 14), --offset
												 true,
												 "Yellow_Box")--object entity name
	box:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(box)
	GROUND:ObjectSetDefaultAnim(box, 'Yellow_Box', 0, 0, 0,Direction.Down)
	GROUND:Hide(box.EntName)
	local noctowl =
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 184, 288, Direction.Up}
		})

	GROUND:TeleportTo(hero, 168, 344, Direction.Up)
	GROUND:TeleportTo(partner, 200, 344, Direction.Up)

	GAME:FadeIn(40)

	GAME:WaitFrames(60)
	UI:SetSpeaker('[color=#00FFFF]Guildmaster[color]', true, tropius.CurrentForm.Species, tropius.CurrentForm.Form, tropius.CurrentForm.Skin, tropius.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_002']))

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 184, 224, false, 1)
												  GeneralFunctions.EightWayMove(noctowl, 152, 120, false, 1)
												  GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:MoveToPosition(hero, 168, 152, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(partner, 200, 152, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(40)

	--noctowl tells tropius
	GROUND:CharTurnToCharAnimated(noctowl, tropius, 4)
--	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_003']))

	GROUND:CharTurnToCharAnimated(noctowl, hero, 4)
	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(tropius, hero, 4)
	GAME:WaitFrames(20)
	UI:SetSpeaker('[color=#00FFFF]Guildmaster[color]', true, tropius.CurrentForm.Species, tropius.CurrentForm.Form, tropius.CurrentForm.Skin, tropius.CurrentForm.Gender)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_004'], tropius:GetDisplayName()))
	UI:SetSpeaker(tropius)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_005'], noctowl:GetDisplayName()))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_006']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_007']))

	--partner speaks up
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_008']))
	GAME:WaitFrames(20)

	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	GeneralFunctions.SetEmotion('Pain')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_009']))

	GAME:WaitFrames(20)
	GeneralFunctions.ShakeHead(partner)
	GAME:WaitFrames(10)

	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_011']))
	GAME:WaitFrames(20)
	GeneralFunctions.Hop(partner)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_012'], partner:GetDisplayName()))
	--GAME:WaitFrames(20)
	--GeneralFunctions.HeroDialogue(hero, "(Guess it's my turn now then.)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)

	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_013'], partner:GetDisplayName(), hero:GetDisplayName()))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_014']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_015']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_016']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_017']))
	GAME:WaitFrames(10)
	GeneralFunctions.Hop(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_018']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(tropius, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_019']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	GROUND:CharSetEmote(tropius, "", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_020']))
	GAME:WaitFrames(20)

	--[[
	--Huh? trying times? what do you mean? something's wrong with the world or something?
	--this part rmeoved because I decided that the calamity (the blight) should only start to manifest once the hero comes to the world
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_022']))

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(hero, "Question", true)
	GeneralFunctions.HeroDialogue(hero, "(Huh?[pause=0] Issues with life forces?[pause=0] What is he talking about?)", "Worried")
	GAME:WaitFrames(20)
	]]--

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Normal")
--	UI:WaitShowDialogue("But I'm getting offtopic.[pause=0] What's important right now is your apprenticeship!")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_024']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_025']))

	--what kind of questions is he about to ask us, oh goodness
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(hero, 'Sweating', false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, 'Sweating', true) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_026']))
	GAME:WaitFrames(20)

	--question 1: why do you wanna be an adventurer?
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_027'], partner:GetDisplayName()))
	GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 4)
	GAME:WaitFrames(16)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_028']))

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_029']))
	GeneralFunctions.SetEmotion("Inspired")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_030']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_031']))


	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_032']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_033']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_034']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_035']))
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_036']))
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_037'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	--hero question 1 response
	GeneralFunctions.HeroDialogue(hero, "(Euh...[pause=0]C'est une bonne question en fait.[pause=0]Je n'y ai pas beaucoup réfléchi.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Cela avait l'air amusant,[pause=10]bien sûr,[pause=10]mais je n'avais pas vraiment d'autres options compte tenu de ma situation.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Je ne suis pas vraiment sûr de ma réponse alors...)", "Worried")
	UI:BeginChoiceMenu("(...Pourquoi est-ce que je veux être un aventurier ?)", {"C'est très amusant", "Résoudre des mystères", partner:GetDisplayName() .. " est mon ami"}, 3, 3)
	UI:WaitForChoice()

	--menu with 3 options here:
	--Solve my origins (but i cant say that so i'll say solve mysteries of the world)
	--it's really fun
	--partner is my friend and they wanna be one
	local result = UI:ChoiceResult()
	GAME:WaitFrames(20)
	if result == 1 then
		GeneralFunctions.HeroDialogue(hero, "(Hmm...[pause=0]Je suppose que ça avait l'air amusant quand " .. partner:GetDisplayName() .. " me l'a décrit.)", "Worried")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroDialogue(hero, "(Je vais alors utiliser cela comme réponse !)", "Normal")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroSpeak(hero, 60)
		GAME:WaitFrames(20)
		UI:SetSpeaker(tropius)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_038']))
		GAME:WaitFrames(20)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_090']))--foreshadowing

	elseif result == 2 then
		GeneralFunctions.HeroDialogue(hero, "(En vérité,[pause=10] j'aimerais savoir qui j'étais et comment j'ai perdu la mémoire.)", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(Être un aventurier semble pouvoir m'aider avec ça...)", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(Mais " .. partner:GetDisplayName() .. " a dit que je ne devrais dire à personne que j'étais un humain...)", "Worried")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroDialogue(hero, "(Je suppose que si je le formule d'une certaine manière, cela ne semblera pas suspect.)", "Normal")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroSpeak(hero, 60)
		GAME:WaitFrames(20)
		UI:SetSpeaker(tropius)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_039']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_040']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_091']))--foreshadowing
	else
		GeneralFunctions.HeroDialogue(hero, "(La seule raison pour laquelle je suis ici en premier lieu est à cause de " .. partner:GetDisplayName() .. "...)", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(Je ne connais pas encore très bien " .. GeneralFunctions.GetPronoun(partner, "them") .. ",[pause=10]mais " .. GeneralFunctions.GetPronoun(partner, "they're") .. " reste mon seul ami au monde...)", "Worried")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroDialogue(hero, "(Donc je suppose que la vraie raison pour laquelle je suis ici pour être un aventurier est à cause de " .. partner:GetDisplayName() .. " !)", "Normal")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroSpeak(hero, 60)
		GAME:WaitFrames(20)
		UI:SetSpeaker(tropius)
		--tropius likes this answer, partner is surprised by your answer
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "exclaim", 1)
											    GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		TASK:JoinCoroutines({coro1, coro2})
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_041']))
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		GAME:WaitFrames(16)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_042']))
		GAME:WaitFrames(20)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_043']))
		GAME:WaitFrames(20)
		GeneralFunctions.SetEmotion("Worried")--foreshadowing
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_092']))--FORESHADOWING
		GeneralFunctions.SetEmotion("Normal")
	end
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GAME:WaitFrames(40)
	--hmm, how to reconcile that tropius wants to teach people the error of his ways but turned away team style because they were vain and had poor morals?
	--either: they got kicked out because they weren't changing or were acting up, or they weren't allowed to join in the first place because of their bad attitude/philosophy


	--looks at noctowl, they agree that they should be allowed to apprentice here
	--that was too easy... as it this was meant to happen...
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_044']))
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	GROUND:CharTurnToCharAnimated(noctowl, tropius, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_045'], noctowl:GetDisplayName()))

--	GAME:WaitFrames(20)
--	UI:SetSpeaker(noctowl)
--	UI:WaitShowDialogue("Of course I have thoughts,[pause=10] Guildmaster.[pause=0] I spend a lot of my time thinking,[pause=10] after all.")
--	GAME:WaitFrames(20)
--	UI:SetSpeaker(tropius)
--	UI:WaitShowDialogue("...What I meant was,[pause=10] do you have any thoughts on our prospective recruits here?")

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_046']))
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_047']))
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)
	GAME:WaitFrames(10)


	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_048']))


	--yay we did it!!
	--GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeaker(partner)
	GROUND:CharSetAnim(partner, "Idle", true)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_049']))

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(10)

	GROUND:CharSetEmote(partner, "happy", 0)
	GROUND:CharSetAnim(hero, "Idle", true)
	GeneralFunctions.SetEmotion("Joyous")
	GeneralFunctions.DoubleHop(partner, nil, nil, nil, true, true)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_050'], hero:GetDisplayName()))

	GAME:WaitFrames(40)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(tropius, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_051']))
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	GAME:WaitFrames(20)


	--what is your team's name?
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_052']))

	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	GAME:WaitFrames(12)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_053']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_054']))

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)

	--give team name, tropius gives a couple of items and some adventurers tool (like a badge to tp others and urselves out of dungeons)
	--then noctowl shows u to ur room

	GAME:WaitFrames(12)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_055'], hero:GetDisplayName()))

	--give team name
	GAME:WaitFrames(20)
	UI:ResetSpeaker()
	local yesnoResult = false
	while not yesnoResult do
		UI:NameMenu("Quel sera le nom de votre équipe ?", "Tu n'as pas besoin d'inclure « Équipe » dans le nom.", 60)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		GAME:SetTeamName(result)
		UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['GMR1_056'], GAME:GetTeamName()), true)
		UI:WaitForChoice()
		yesnoResult = UI:ChoiceResult()
	end

	UI:SetSpeaker(partner)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_057'], GAME:GetTeamName()))

	--I'll register you as your teamname then!
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_058'], GAME:GetTeamName()))
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)

	GAME:WaitFrames(12)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_059']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_060']))
	GAME:WaitFrames(20)

	GROUND:MoveInDirection(tropius, Direction.Down, 16, false, 1)
	GAME:WaitFrames(10)
	--tropius walks forward and places a chest
	SOUND:PlayBattleSE('EVT_CH02_Item_Place')
	GROUND:Unhide("Yellow_Box")
	GAME:WaitFrames(20)
	GROUND:AnimateInDirection(tropius, "Walk", Direction.Down, Direction.Up, 16, 1, 1)
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_061']))
	GAME:WaitFrames(20)

	--open the box
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	GAME:WaitFrames(10)
	GROUND:ObjectSetAnim(box, 4, 0, 5, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(box, 'Yellow_Box', 0, 5, 5, Direction.Down)
	SOUND:PlayBattleSE('EVT_CH02_Box_Open')
	GeneralFunctions.Monologue(hero:GetDisplayName() .. " a ouvert la boîte.")

	--local scarf_name = RogueEssence.Dungeon.InvItem("held_synergy_scarf"):GetDisplayName()
	--have to hardcode this so I can have it say scarves instead of scarf
	local scarf_name = STRINGS:Format('\\uE0AE')..'[color=#FFCEFF]Synergy Scarves[color]'

	--pipe dream todo: have scarves for the sprites from now on
	GAME:WaitFrames(20)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_062']))
	SOUND:PlayFanfare("Fanfare/Item")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_063']))
	SOUND:PlayFanfare("Fanfare/Item")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_064']))
	SOUND:PlayFanfare("Fanfare/Item")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_065']))
	SOUND:PlayFanfare("Fanfare/Item")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_066'], scarf_name))
	UI:SetCenter(false)


	GAME:WaitFrames(30)
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_067']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_068']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_069']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_070']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_071']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_072']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_073']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_074']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_075']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_076']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_077'], scarf_name))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_078']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_079']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_080']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_081']))
	GeneralFunctions.SetEmotion("Happy")--change to a wink? how do you wink when only one eye shows
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_082']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_083']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_084']))


	--thank you for the items and letting us join guildmaster
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_085']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_086']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_087']))

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_088'], hero:GetDisplayName()))

	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR1_089']))

	--pose before fading out
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GROUND:CharSetEmote(tropius, "glowing", 0) end)
	GAME:WaitFrames(120)

	--rank up to normal rank upon joining guild
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	_DATA.Save.ActiveTeam:SetRank("normal")
	GAME:GivePlayerItem("held_synergy_scarf", 2)--give 2 vibrant scarves
	GAME:CutsceneMode(false)
	GAME:WaitFrames(60)
	GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")

end
