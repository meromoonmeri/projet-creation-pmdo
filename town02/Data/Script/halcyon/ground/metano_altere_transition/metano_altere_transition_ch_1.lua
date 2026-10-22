require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

metano_altere_transition_ch_1 = {}




--cutscene after getting out of Relic Forest where partner reveals some info about themselves and our duo agree to sign up at the guild together
function metano_altere_transition_ch_1.HeartToHeartCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GROUND:AddMapStatus("dusk")--dusk
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--GAME:MoveCamera(232, 184, 1, false)
	GROUND:TeleportTo(partner, 260, 340, Direction.Right)
	GROUND:TeleportTo(hero, 264, 372, Direction.Right)
	GAME:MoveCamera(236, 184, 1, false)
	GROUND:Hide('South_Exit')
	GROUND:Hide('North_Exit')
	GAME:FadeIn(40)

	--Move to about mid screen, and have the conversation there.
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 240, 176, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 240, 208, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 240, 176, false, 1) end)
	GROUND:MoveToPosition(partner, 208, 176, false, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	TASK:JoinCoroutines({coro1})
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, true, Direction.Right)


	--conversation begins, hero wonders why they couldnt talk back at the pond and why partner was in relic forest to begin with
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Normal')

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_001']))
	--GeneralFunctions.HeroDialogue(hero, "(But what was wrong with staying near the pond?[pause=0] Something seems off...)", "Worried")
	--GeneralFunctions.HeroDialogue(hero, "(And why )", "Worried")


	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Normal')
	GeneralFunctions.EmoteAndPause(partner, 'Question', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_002']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Worried')
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_003']))
	GAME:WaitFrames(20)

	--they consider making something up and pause, but just decide to be honest
	GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true)
	GeneralFunctions.SetEmotion('Sad')
	SOUND:FadeOutBGM(120)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_004']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Normal')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_005'], zone:GetColoredName()))
	GeneralFunctions.SetEmotion('Sad')
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_007']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_011']))

	--wait, figured out? i.e. you've done this enough times to figure out a strategy?
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Cela signifie que " .. partner:GetDisplayName() .. " y est allé plus d'une fois...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Mais pourquoi " .. GeneralFunctions.GetPronoun(partner, 'they') .. " y irait-il plusieurs fois si " .. GeneralFunctions.GetPronoun(partner, "they're") .. " n'était pas autorisé ?)", "Worried")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.DownRight, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Sad')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_012']))
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_013']))
	GAME:WaitFrames(40)
	SOUND:PlayBGM("On the Beach at Dusk.ogg", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_014']))
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_015']))
	GAME:WaitFrames(10)

	--wtf is an adventurer
	GeneralFunctions.EmoteAndPause(hero, 'Question', true)
	--GeneralFunctions.HeroDialogue(hero, "(Adventurer?[pause=0] What's that?)", 'Worried')
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(10)

	--you dont know what an adventurer is?
	GeneralFunctions.EmoteAndPause(partner, 'Exclaim', true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Surprised')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_016']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Worried')
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_017']))

	--gush over how great adventuring is
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Inspired')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_018']))
--	GAME:WaitFrames(20)
--	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_019']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_021']))

	--GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_022']), {function() return GeneralFunctions.Hop(partner) end})
	--GeneralFunctions.Hop(partner, 'None', 10, 10, false, false)

	--hero is excited by the idea of adventurers because THATS WHY THEY CAME TO THIS WORLD :v)
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je dois dire...[pause=0]Cela semble très amusant !)", "Inspired")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)

	--why cant the partner join the guild themself?
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Happy')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_023']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Normal')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_024']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Sad')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_025']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_026']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Normal')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_028']))

	--get teary-eyed that you have nobody like that
	--music cue around here for beach song?
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Sad')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_029']))
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	GAME:WaitFrames(15)
--	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
--	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion('Teary-Eyed')
	--GeneralFunctions.StartTremble(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_030']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_031']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_032']))
	GAME:WaitFrames(20)
	--GeneralFunctions.StopTremble(partner)
	GeneralFunctions.ShakeHead(partner)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Sad")
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_033']))

	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_034'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_035']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_036']))
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. "...)", "Sad")

	--recruit the player
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_037'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_038']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_039']))

	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.DownLeft, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(.........)", "Sad")

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_040']))

	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_041']))
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GeneralFunctions.DoAnimation(partner, 'DeepBreath')

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)

	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_042']))
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(hero, "Exclaim", true)
	GeneralFunctions.SetEmotion('Sad')
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_043'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_044']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_045']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_046']))

	--Woah! I'm getting recruited out of the blue!
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Hmm...[pause=0]Que dois-je faire ?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Être un aventurier a l'air amusant,[pause=10]mais je ne connais pas très bien " .. partner:GetDisplayName() .. "...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Mais que ferais-je d'autre ?[pause=0]Je ne connais personne d'autre...)", "Worried")
	--add another option here maybe? couldnt think of anything at the time to put that was decent
	UI:BeginChoiceMenu("(Dois-je faire équipe avec " .. partner:GetDisplayName() .. " ?)", {"Faire équipe", "Non merci"}, 1, 2)
	UI:WaitForChoice()
	UI:SetSpeaker(partner)
	local result = UI:ChoiceResult()
	while result == 2 do
		GAME:WaitFrames(20)
		GeneralFunctions.Recoil(partner)
		GROUND:CharSetAnim(partner, 'None', true)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_047']))
		GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_048'], zone:GetColoredName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_049']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_050']))
		UI:BeginChoiceMenu("Alors s'il vous plaît,[pause=10] je vous en supplie...[pause=0]Formez une équipe d'aventuriers avec moi.", {"Faire équipe", "Non merci"}, 1, 2)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
	end

	GAME:WaitFrames(20)
	--if result == 3 then	end
	GeneralFunctions.HeroDialogue(hero, "(Je n'ai vraiment nulle part où aller ni personne d'autre vers qui me tourner...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " a été gentil et honnête avec moi jusqu'à présent...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(J'ai l'impression de pouvoir faire confiance à " .. GeneralFunctions.GetPronoun(partner, 'them') .. ".[pause=0]. Je ne vois aucune bonne raison de ne pas le faire.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Et être un aventurier, ça avait l'air vraiment cool...)", "Inspired")
	GeneralFunctions.HeroDialogue(hero, "(Alright![pause=0] Then it's decided!)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Qui sait ?[pause=0]Peut-être qu'ensemble nous découvrirons pourquoi je me suis transformé en Pokémon.)", "Normal")

	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)

	--you'll team with me!!??
	GAME:WaitFrames(20)
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_051']))
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(partner, 220, 176, true, 2)
	GeneralFunctions.DoubleHop(partner, nil, nil, nil, true, true)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(hero, "shock", 1)
	GROUND:CharSetEmote(partner, "happy", 0)
	GROUND:CharSetAnim(partner, 'Idle', true)--show idle anim to show their excitement (rather than none i.e. no anim)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_052']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_053']))
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GAME:WaitFrames(20)

	--we need to sign up at the guild
	GROUND:CharSetEmote(partner, "exclaim", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GeneralFunctions.SetEmotion("Surprised")
	GROUND:CharSetAnim(partner, 'None', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_054']))
	GAME:WaitFrames(20)

	GROUND:AnimateInDirection(partner, "Walk", Direction.Right, Direction.Left, 12, 1, 1)
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_055']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_056']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_057']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_058']))
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	TASK:JoinCoroutines({coro1})

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_059']))
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	TASK:JoinCoroutines({coro1})

	--lets go to the guild
	GeneralFunctions.DoubleHop(partner, nil, nil, nil, true, true)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharSetEmote(partner, "happy", 0)
	GROUND:CharSetAnim(partner, 'Idle', true)--show idle anim to show their excitement (rather than none i.e. no anim)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_060']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MAT1_061']))
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(partner, "", 0)

	--partner runs off to the guild in excitement, player has to run to catch up
	--SOUND:PlayBattleSE("_UNK_EVT_069")--run away sfx, maybe dont use tho?
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 208, -32, true, 4) end)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GeneralFunctions.EmoteAndPause(hero, "Exclaim", true)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowTimedDialogue("(H-hé ![pause=20]Attends !)", 60)
	GROUND:MoveToPosition(hero, 208, 176, true, 3)
	GROUND:MoveToPosition(hero, 208, -32, true, 3)
	TASK:JoinCoroutines({coro1})

	SOUND:FadeOutBGM(40)
	GAME:FadeOut(false, 40)
	--
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")





end
