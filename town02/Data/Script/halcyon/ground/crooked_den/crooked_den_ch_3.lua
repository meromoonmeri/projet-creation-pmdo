require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

crooked_den_ch_3 = {}


function crooked_den_ch_3.FirstPreBossScene()

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local sandile = CharacterEssentials.MakeCharactersFromList({{"Sandile", 172, 104, Direction.Up}})



	GAME:WaitFrames(60)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()

	GROUND:TeleportTo(hero, 188, 272, Direction.Up)
	GROUND:TeleportTo(partner, 156, 272, Direction.Up)
	GAME:MoveCamera(180, 120, 1, false)

	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)

	SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

	GAME:WaitFrames(30)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, sandile.CurrentForm.Species, sandile.CurrentForm.Form, sandile.CurrentForm.Skin, sandile.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Normal")
	GeneralFunctions.SetEmotion("Pain")
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_001']))
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(sandile, Direction.Left, 4)
	GROUND:MoveInDirection(sandile, Direction.Left, 24, false, 1)
	GROUND:CharAnimateTurnTo(sandile, Direction.Right, 4)
	GROUND:MoveInDirection(sandile, Direction.Right, 48, false, 1)
	GROUND:CharAnimateTurnTo(sandile, Direction.Left, 4)
	GROUND:MoveInDirection(sandile, Direction.Left, 24, false, 1)
	GROUND:CharAnimateTurnTo(sandile, Direction.Up, 4)

	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_002']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	SOUND:FadeOutBGM(120)
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Hé toi ![pause=30]H-tiens-le là !", 40) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(sandile, "Exclaim", true) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(sandile, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({hero, partner}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(40)
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", false)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 156, 136, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:MoveToPosition(hero, 188, 136, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(180, 120, 160, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_003'], sandile:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(sandile, "sweating", 1)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, sandile.CurrentForm.Species, sandile.CurrentForm.Form, sandile.CurrentForm.Skin, sandile.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_004']))

	--partner has been rehearsing this in their head the whole trip
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_005'], GAME:GetTeamName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_006']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(sandile, "Shock", true)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_007']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(sandile, "sweating", 1)
	GeneralFunctions.DoubleHop(sandile)

	--todo: make sandile tremble
	SOUND:FadeOutBGM(60)
	GeneralFunctions.SetEmotion("Crying")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_104']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_105']))end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Stunned")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_008']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Special2")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_009']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_010']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_011']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_012']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_013']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Stunned")
	GROUND:CharSetEmote(sandile, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_014']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_015'], _DATA:GetMonster("sandile"):GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_016']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_017']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_018']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_019']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_022']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_024']))
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_025']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_026']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_028']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_029']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_030']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_031']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_032']))

	--partner is sympathetic towards thwait and doesn't really consider him bad/an outlaw at this point, but obviously he still needs to own up to what he did.
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_033']))
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_034']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_035']))

	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowTimedDialogue("C'mon,[pause=10] " .. hero:GetDisplayName() .. ".[pause=0] Let's-", 40)

	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	local luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({
									{"Luxio", 172, 264, Direction.Up},
									{"Glameow", 156, 280, Direction.Up},
									{"Cacnea", 188, 280, Direction.Up}})
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Eh bien, bien, bien ![pause=30]Qu'avons-nous ici ?", 40) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) GeneralFunctions.EmoteAndPause(sandile, "Exclaim", false) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(32) GeneralFunctions.EmoteAndPause(hero, "Notice", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({luxio}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(sandile, Direction.Down, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	SOUND:PlayBGM('Team Skull.ogg', false)
	GeneralFunctions.EmoteAndPause(partner, 'Shock', true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_036']))

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(luxio, 172, 176, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:MoveToPosition(glameow, 156, 192, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:MoveToPosition(cacnea, 188, 192, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() GAME:MoveCamera(180, 152, 120, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_037']))


	GAME:WaitFrames(20)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_038']))

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(glameow, 156, 156, false, 1)
											GROUND:MoveToPosition(glameow, 160, 152, false, 1)
											GROUND:CharAnimateTurnTo(glameow, Direction.UpLeft, 4)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(cacnea, 188, 156, false, 1)
											GROUND:MoveToPosition(cacnea, 184, 152, false, 1)
											GROUND:CharAnimateTurnTo(cacnea, Direction.UpRight, 4)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Pain")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharWaitAnim(glameow, "Shoot") end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharWaitAnim(cacnea, "Shoot") end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											SOUND:PlayBattleSE('EVT_Tackle')
											GROUND:AnimateInDirection(partner, "Pain", Direction.Right, Direction.Left, 12, 1, 2)
											GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pain"))) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:AnimateInDirection(hero, "Pain", Direction.Left, Direction.Right, 12, 1, 2)
											GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pain"))) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) UI:WaitShowTimedDialogue("Urf!", 40) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(sandile, "Shock", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})

	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(luxio, 172, 104, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
											GROUND:AnimateToPosition(sandile, "Walk", Direction.Down, 172, 72, 1, 1, 0)
											GROUND:CharSetEmote(sandile, "shock", 1)
											GROUND:CharAnimateTurnTo(sandile, Direction.Left, 2)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(sandile, Direction.Down, 2)
											GROUND:CharAnimateTurnTo(sandile, Direction.Right, 2)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(sandile, Direction.Down, 2) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(glameow, Direction.UpLeft, 4)
											GeneralFunctions.EightWayMove(glameow, 160, 120, false, 1)
											GeneralFunctions.EightWayMove(glameow, 144, 88, false, 1)
											GROUND:CharAnimateTurnTo(glameow, Direction.UpRight, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(cacnea, Direction.UpRight, 4)
											GeneralFunctions.EightWayMove(cacnea, 184, 120, false, 1)
											GeneralFunctions.EightWayMove(cacnea, 200, 88, false, 1)
											GROUND:CharAnimateTurnTo(cacnea, Direction.UpLeft, 4) end)
	coro5 = TASK:BranchCoroutine(function() GAME:MoveCamera(180, 120, 32, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(10)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_039']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_040']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_041']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Pain")
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.Shake(hero)
											GAME:WaitFrames(30)
											GROUND:CharWaitAnim(hero, "Wake")
											GROUND:CharSetAnim(hero, "None", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.Shake(partner)
											GAME:WaitFrames(30)
											GROUND:CharWaitAnim(partner, "Wake")
											GROUND:CharSetAnim(partner, "None", true) end)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Urgh...", 80) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	--coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	--coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)

	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 156, 136, false, 2)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 188, 136, false, 2)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	GeneralFunctions.Hop(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_042']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(luxio)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4)
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_106'])) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)

	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(10)
	GROUND:CharSetEmote(hero, "exclaim", 1)
	GeneralFunctions.Recoil(partner)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_043']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_044']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_045']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_046']))

	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Shock", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_047']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_048'], luxio:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_049']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_050']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_051']))

	--if player died before making it to the end at least once
	if SV.Chapter3.FailedCavern then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_052']))
	end

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_053']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_054']))

	GAME:WaitFrames(10)
	GeneralFunctions.Complain(partner)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_055']))

	GAME:WaitFrames(10)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Angry")
	GeneralFunctions.Complain(luxio, true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_056']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_057']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_058']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_059']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_060']))

	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(luxio, "Shock", false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(glameow, "Exclaim", false) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(cacnea, "Shock", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_061']))

	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(luxio, glameow, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_062'], glameow:GetDisplayName()))

	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(luxio, cacnea, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_063'], cacnea:GetDisplayName()))

	GAME:WaitFrames(8)
	GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_064']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_065']))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(sandile, "sweating", 1)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_066']))

	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(luxio, sandile, 2)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Angry")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Non!", 60) end)
	--todo: replace this with regular recoil if sandile ever gets a pain sprite
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.Recoil(sandile, "None") end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(8)
	GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_067']))

	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(luxio, Direction.Down, 16, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:MoveInDirection(glameow, Direction.Down, 16, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:MoveInDirection(cacnea, Direction.Down, 16, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:AnimateInDirection(hero, "Walk", Direction.Up, Direction.Down, 16, 1, 1) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:AnimateInDirection(partner, "Walk", Direction.Up, Direction.Down, 16, 1, 1) end)
	coro6 = TASK:BranchCoroutine(function() GAME:MoveCamera(180, 152, 32, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
	GAME:WaitFrames(10)
	UI:SetSpeaker(glameow)
	GeneralFunctions.SetEmotion("Special1")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_068']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(cacnea)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_069']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_070']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_071'], hero:GetDisplayName()))

	COMMON.BossTransition()
	GAME:CutsceneMode(false)
	SV.Chapter3.EncounteredBoss = true
	--enter fight
	GAME:ContinueDungeon("crooked_cavern", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

end

--player used escape orb. Note: Mysterious force prevents orbs, so this shouldn't actually get used.
function crooked_den_ch_3.EscapedBoss()

end

--player was defeated.
function crooked_den_ch_3.DiedToBoss()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local sandile, luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({{"Sandile", 172, 72, Direction.Down},
																						{"Luxio", 172, 120, Direction.Down},
																						{"Glameow", 144, 104, Direction.Down},
																						{"Cacnea", 200, 104, Direction.Down}})

	GROUND:Hide(partner.EntName)
	GROUND:Hide(hero.EntName)

	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()

	GAME:MoveCamera(180, 120, 1, false)
	GAME:CutsceneMode(true)

	GAME:WaitFrames(60)
	GAME:FadeIn(40)

	GAME:WaitFrames(20)

	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(luxio, "Exclaim", true) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(glameow, "Exclaim", false) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(cacnea, "Question", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(luxio, 3, 4, true, false, false, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(glameow, 3, 4, true, false, false, Direction.DownRight) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.LookAround(cacnea, 3, 4, true, false, false, Direction.DownLeft) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})


	UI:SetSpeaker(cacnea)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_072']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_073']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetAnim(glameow, "Idle", true)
	GROUND:CharSetEmote(glameow, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_074']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(cacnea)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetAnim(cacnea, "Idle", true)
	GROUND:CharSetEmote(cacnea, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_075']))

	GAME:WaitFrames(40)
	GROUND:CharSetEmote(cacnea, "", 0)
	GROUND:CharSetEmote(glameow, "", 0)
	GROUND:CharEndAnim(cacnea)
	GROUND:CharEndAnim(glameow)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_076']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_077']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_078']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	GROUND:CharSetEmote(glameow, "happy", 0)
	GeneralFunctions.SetEmotion("Special1")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_079'], luxio:GetDisplayName()))

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(glameow, "", 0)
	GROUND:CharSetEmote(cacnea, "glowing", 0)
	UI:SetSpeaker(cacnea)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_080']))

	GAME:WaitFrames(40)
	GROUND:CharSetEmote(cacnea, "", 0)
	UI:SetSpeaker(luxio)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Up, 4)
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_107'])) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(glameow, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharAnimateTurnTo(cacnea, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_081']))

	GAME:WaitFrames(30)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(90)
	SV.Chapter3.LostToBoss = false--reset this flag
	--set generic flags
	SV.TemporaryFlags.Dinnertime = true
	SV.TemporaryFlags.Bedtime = true
	SV.TemporaryFlags.MorningWakeup = true
	SV.TemporaryFlags.MorningAddress = true

	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_dining_room", "Main_Entrance_Marker")
end

--Player Defeated boss
function crooked_den_ch_3.DefeatedBoss()

	--LE NOIR AVANT TOUTE MISE EN PLACE (correctif de retour de boss,
	--2026-07-30). Cette scene est jouee juste apres un EndSegment /
	--EnterZone : le moteur a pose le noir, mais rien ne le REPOSE ici.
	--Elle enchaine pourtant plusieurs appels moteur (creation de PNJ,
	--TeleportTo, MoveCamera, StopBGM) avant son FadeIn. GAME:FadeOut
	--etant bloquant (ScriptGame.cs:1590) et FadeInternal rendant la
	--main a chaque frame (FadeEffect.cs:30-42), ces appels laissent
	--passer des frames RENDUES sur une carte en cours de montage —
	--c'est l'apercu de zone signale en jeu. FadeOut(false,1) sur un
	--ecran deja noir est un no-op (FadeEffect.cs:63) : gratuit si le
	--noir a tenu, salvateur sinon.
	pcall(function() GAME:FadeOut(false, 1) end)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local sandile, luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({{"Sandile", 172, 72, Direction.Down},
																						{"Luxio", 172, 128, Direction.Down},
																						{"Glameow", 120, 112, Direction.Down},
																						{"Cacnea", 224, 112, Direction.Down}})

	GROUND:CharSetAction(glameow, RogueEssence.Ground.PoseGroundAction(glameow.Position, glameow.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
	GROUND:CharSetAction(cacnea, RogueEssence.Ground.PoseGroundAction(cacnea.Position, cacnea.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep")))
	GROUND:CharSetAnim(luxio, "Charge", true)
	GROUND:TeleportTo(hero, 188, 160, Direction.Up)
	GROUND:TeleportTo(partner, 156, 160, Direction.Up)
	GAME:MoveCamera(180, 120, 1, false)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()

	GAME:CutsceneMode(true)
	GAME:WaitFrames(60)
	GAME:FadeIn(40)

	GAME:WaitFrames(30)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Pain")

	--special message if you completely shit on them
	if SV.MapTurnCounter ~= nil then --nil check as a failsafe
		if SV.MapTurnCounter <= 5 then
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_082']))
			GAME:WaitFrames(20)
		end
	end
	SV.MapTurnCounter = nil
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_083']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_084']))

	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
	GROUND:CharSetEmote(luxio, "shock", 1)
	GROUND:CharSetAction(luxio, RogueEssence.Ground.PoseGroundAction(luxio.Position, luxio.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
	GAME:WaitFrames(80)

	UI:SetSpeaker(partner)
	GeneralFunctions.Hop(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_085'], hero:GetDisplayName()))
	--GeneralFunctions.SetEmotion("Normal")
	--UI:WaitShowDialogue("Now we can get back to our mission!")

	GAME:WaitFrames(20)
	SOUND:PlayBGM("In the Depths of the Pit.ogg", false)
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 142, 138, false, 1)
												  GROUND:MoveToPosition(partner, 142, 122, false, 1)
												  GeneralFunctions.EightWayMove(partner, 156, 104, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												  GeneralFunctions.EightWayMove(hero, 204, 138, false, 1)
												  GROUND:MoveToPosition(hero, 204, 122, false, 1)
												  GeneralFunctions.EightWayMove(hero, 188, 104, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(10)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_086'], sandile:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_087']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_088']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_089']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_090']))

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Teary-Eyed")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_091']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_092']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_093']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_094']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_095']))

	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_096'], hero:GetDisplayName()))

	GAME:WaitFrames(30)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(90)
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")

	--idea: Zhayn will go easy on Thwait because he knows that criminals can be reformed as he was himself a criminal once.
	--partner should also suggest they go easy on him he doesnt seem so bad
	--shuca will tell partner that finesse is needed sometimes, and they did the right thing.
end

--player died to boss, came back: play a different scene to reflect this and get back into the fight faster.
function crooked_den_ch_3.SecondPreBossScene()

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local sandile, luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({{"Sandile", 172, 72, Direction.Down},
																						{"Luxio", 172, 120, Direction.Up},
																						{"Glameow", 144, 104, Direction.UpRight},
																						{"Cacnea", 200, 104, Direction.UpLeft}})

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GeneralFunctions.StartTremble(sandile)
	GROUND:TeleportTo(hero, 188, 256, Direction.Up)
	GROUND:TeleportTo(partner, 156, 256, Direction.Up)
	GAME:MoveCamera(180, 120, 1, false)
	SOUND:StopBGM()
	GAME:WaitFrames(60)

	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 156, 152, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:MoveToPosition(hero, 188, 152, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_108'])) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
											GROUND:CharSetEmote(luxio, "exclaim", 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
												  GROUND:CharSetEmote(glameow, "exclaim", 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(28)
												  GROUND:CharSetEmote(cacnea, "exclaim", 1) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.StopTremble(sandile)
												  GROUND:CharSetEmote(sandile, "exclaim", 1) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(20)

	UI:SetSpeaker(cacnea)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_097']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_098']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_099']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_100'], sandile:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_101']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_102']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CD3_103']))

	COMMON.BossTransition()
	GAME:CutsceneMode(false)
	--enter fight
	GAME:ContinueDungeon("crooked_cavern", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

end



return crooked_den_ch_3




