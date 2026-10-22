require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

searing_crucible_ch_5 = {}


--TASK:BranchCoroutine(function() searing_crucible_ch_5.FirstPreBossScene() end)
function searing_crucible_ch_5.FirstPreBossScene()

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
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')

	--prep the slugmas now. Hide them now, unhide them when it's time.
	local slugma_boy = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Male)
	local slugma_girl = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Female)
	
	local slugma_boy_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 184), Direction.Right, 'Slugma', 'Slugma_Boy_1')
	local slugma_boy_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(328, 244), Direction.Left, 'Slugma', 'Slugma_Boy_2')
	local slugma_boy_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(184, 268), Direction.Right, 'Slugma', 'Slugma_Boy_3')
	local slugma_boy_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 328), Direction.Left, 'Slugma', 'Slugma_Boy_4')
	
	local slugma_girl_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 184), Direction.Left, 'Slugma', 'Slugma_Girl_1')
	local slugma_girl_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(184, 244), Direction.Right, 'Slugma', 'Slugma_Girl_2')
	local slugma_girl_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(328, 268), Direction.Left, 'Slugma', 'Slugma_Girl_3')
	local slugma_girl_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 328), Direction.Right, 'Slugma', 'Slugma_Girl_4')
	
	slugma_boy_1:ReloadEvents()
	slugma_boy_2:ReloadEvents()
	slugma_boy_3:ReloadEvents()
	slugma_boy_4:ReloadEvents()
	slugma_girl_1:ReloadEvents()
	slugma_girl_2:ReloadEvents()
	slugma_girl_3:ReloadEvents()
	slugma_girl_4:ReloadEvents()
	
	GAME:GetCurrentGround():AddTempChar(slugma_boy_1)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_2)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_3)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_4)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_1)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_2)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_3)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_4)
	
	GROUND:Hide('Slugma_Boy_1')
	GROUND:Hide('Slugma_Boy_2')
	GROUND:Hide('Slugma_Boy_3')
	GROUND:Hide('Slugma_Boy_4')
	GROUND:Hide('Slugma_Girl_1')
	GROUND:Hide('Slugma_Girl_2')
	GROUND:Hide('Slugma_Girl_3')
	GROUND:Hide('Slugma_Girl_4')
	
	local magcargo = 
		CharacterEssentials.MakeCharactersFromList({
			{'Magcargo', 256, 192, Direction.Down}
		})
	GROUND:Hide('Magcargo')
	
	if partner ~= nil then AI:DisableCharacterAI(partner) end
	SOUND:StopBGM()
	
	GROUND:TeleportTo(hero, 240, 472, Direction.Up)
	GROUND:TeleportTo(partner, 272, 472, Direction.Up)
	GROUND:TeleportTo(growlithe, 240, 504, Direction.Up)
	GROUND:TeleportTo(zigzagoon, 272, 504, Direction.Up)
	GAME:MoveCamera(264, 336, 1, false)
		
	GAME:CutsceneMode(true)
	GAME:WaitFrames(60)

	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	
	SOUND:PlayBGM('In the Depths of the Pit.ogg', false)
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												  GeneralFunctions.EightWayMove(hero, 244, 312, false, 1)
											      end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 268, 312, false, 1)
											      end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
												  GeneralFunctions.EightWayMoveRS(growlithe, 240, 344, false, 1)
												  GROUND:EntTurn(growlithe, Direction.Up)
											      end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
												  GeneralFunctions.EightWayMoveRS(zigzagoon, 272, 344, false, 1)
												  GROUND:EntTurn(zigzagoon, Direction.Up)
											      end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Up)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
											GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Right)
											end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(growlithe, 3, 4, false, false, false, Direction.Left) 
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GeneralFunctions.LookAround(zigzagoon, 3, 4, false, false, true, Direction.Down)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_002']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_003']))
	GeneralFunctions.SetEmotion("Pain")
	GROUND:CharSetEmote(zigzagoon, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_004']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_005']))
	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_007']))
	GAME:WaitFrames(10)
	--they're interrupted by the ground shaking, and the lava flowing (magcargo doesn't have influence over these lava flows)
	--having the lava show up first also makes magcargo believe you're the one causing them (you showed up and it acted up)

	--takes about 20f to react to slugma materialization. each frame of materialization is 3 frames

	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveInDirection(partner, Direction.Up, 120, false, 1) end)			
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveInDirection(hero, Direction.Up, 114, false, 1) end)		
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GROUND:MoveInDirection(growlithe, Direction.Up, 110, false, 1) end)			
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:MoveInDirection(zigzagoon, Direction.Up, 106, false, 1) end)	
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GAME:MoveCamera(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y - 72, 72, false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	local continueScene = true
	SOUND:StopBGM()
    SOUND:LoopSE("Light Earthquake")
	GeneralFunctions.SetEmotion("Surprised")
	coro1 = TASK:BranchCoroutine(function() while continueScene do
												GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
												GAME:WaitFrames(30)
											end
											end)
	coro2 = TASK:BranchCoroutine(function() SOUND:PlayBattleSE('EVT_Emote_Exclaim_Surprised')
											GeneralFunctions.Recoil(partner, "Hurt", 10, 10, false, false)
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_008']))
											continueScene = false
											end)
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(hero, Direction.Up, 6, false, 1) --move the last little bit to get to the spot before reacting
											GROUND:CharSetEmote(hero, "shock", 1) 
											end)
	coro4 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(growlithe, Direction.Up, 10, false, 1) --move the last little bit to get to the spot before reacting
											GROUND:CharSetEmote(zigzagoon, "shock", 1)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(zigzagoon, Direction.Up, 14, false, 1) --move the last little bit to get to the spot before reacting
											GeneralFunctions.Recoil(growlithe, "Hurt", 10, 10, false, false)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	    

	--Lava starts spawning 80 frames in.
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
											GAME:WaitFrames(30)
											searing_crucible_ch_5.SpawnLava() end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)	--20
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)--28
											GAME:WaitFrames(10)--38
											GROUND:CharAnimateTurnTo(partner, Direction.DownRight, 4)--50
											GAME:WaitFrames(10)--60
											GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)--68
											GAME:WaitFrames(10)--78
											GROUND:CharAnimateTurnTo(partner,Direction.Right, 4)--90
											GAME:WaitFrames(10)--100
											--SOUND:PlayBattleSE('EVT_Emote_Shock')
											GeneralFunctions.Recoil(partner, "Hurt", 10, 10, false, false)									
											GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 2)
											GROUND:MoveInDirection(partner, Direction.Down, 24, true, 2)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)	--20
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)--28
											GAME:WaitFrames(10)--38
											GROUND:CharAnimateTurnTo(hero, Direction.DownLeft, 4)--50
											GAME:WaitFrames(10)--60
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)--68
											GAME:WaitFrames(10)--78
											GROUND:CharAnimateTurnTo(hero,Direction.Left, 4)--94
											GAME:WaitFrames(10)--94
											GROUND:CharSetEmote(hero, "exclaim", 1)
											GAME:WaitFrames(38)
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 2)
											GROUND:MoveInDirection(hero, Direction.Down, 24, true, 2)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)	--26
											GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)--34
											GAME:WaitFrames(10)--44
											GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 4)--52
											GAME:WaitFrames(10)--62
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4)--74
											GAME:WaitFrames(10)--84
											GROUND:CharAnimateTurnTo(growlithe,Direction.UpLeft, 4)--92
											GAME:WaitFrames(10)--102
											GROUND:CharSetEmote(growlithe, "shock", 1)
											GAME:WaitFrames(36)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 2)
											GROUND:MoveInDirection(growlithe, Direction.Down, 24, true, 2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)	--22
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)--30
											GAME:WaitFrames(10)--40
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpRight, 4)--52
											GAME:WaitFrames(10)--62
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 4)--74
											GAME:WaitFrames(10)--84
											GROUND:CharAnimateTurnTo(zigzagoon,Direction.UpRight, 4)--96
											GAME:WaitFrames(10)--106
											GROUND:CharSetEmote(zigzagoon, "shock", 1)
											GAME:WaitFrames(32)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 2)
											GROUND:MoveInDirection(zigzagoon, Direction.Down, 24, true, 2)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
											end)											
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
-- GROUND:AnimateInDirection(zigzagoon, "Walk", zigzagoon.Direction, Direction.Down, 8, 1, 1)
											
	GAME:WaitFrames(30)
	
	coro1 = TASK:BranchCoroutine(function()	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) 
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
											GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)										
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)										
											end)	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_009']))
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_010']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_011']))
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_012']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_013']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_014']))

	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_015']))
	
	
	--You arrived and then the lava shifted. You must be the cause! You and all the other outlanders that have been passing through!
	GAME:WaitFrames(60)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_016']))
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	GAME:WaitFrames(40)
	GeneralFunctions.LookAround(partner, 2, 4, false, true, false, Direction.Down)
	GAME:WaitFrames(10)
	
	GROUND:EntTurn(partner, Direction.DownLeft)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_017']))
	GAME:WaitFrames(10)
		
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) 
											GROUND:CharAnimateTurnTo(hero, Direction.DownRight, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4)										
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)										
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_018']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_019']))
	GAME:WaitFrames(40)
	
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_082']))
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) 
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) 
											GeneralFunctions.EmoteAndPause(hero, "Notice", false) 
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(22) 
											GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", false) 
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(28) 
											GeneralFunctions.EmoteAndPause(zigzagoon, "Exclaim", false) 
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function()	GeneralFunctions.LookAround(partner, 2, 4, false, true, true, Direction.Right)
											end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) 
											GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.UpLeft)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
											GeneralFunctions.LookAround(growlithe, 2, 4, false, false, false, Direction.DownLeft)										
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
											GeneralFunctions.LookAround(zigzagoon, 2, 4, false, false, true, Direction.Down)									
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_020']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_022']))
	GAME:WaitFrames(20)
	

    local materializeAnimLeft = RogueEssence.Content.AnimData("Slugma_Materialize", 3)
    local materializeAnimRight = RogueEssence.Content.AnimData("Slugma_Materialize", 3)
    local leftFlip = 1
    local rightFlip = 0
    local fliptype = luanet.import_type('RogueEssence.Content.SpriteFlip')

    materializeAnimLeft.AnimFlip =  LUA_ENGINE:LuaCast(leftFlip, fliptype)
    materializeAnimRight.AnimFlip =  LUA_ENGINE:LuaCast(rightFlip, fliptype)
    
    local slugma_anim_left_1 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_1 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_2 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_2 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_3 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_3 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_4 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_4 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    

    --Threat.ogg
    SOUND:PlayBGM('Rising Fear.ogg', true)

	--4 sets of spawning
    coro1 = TASK:BranchCoroutine(function()	SOUND:PlaySE('Slugma Materialize')
											slugma_anim_right_1:SetupEmitted(RogueElements.Loc(slugma_boy_1.Position.X + 8, slugma_boy_1.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_1:SetupEmitted(RogueElements.Loc(slugma_girl_1.Position.X + 8, slugma_girl_1.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_1, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_1, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(68)
											GROUND:Unhide('Slugma_Boy_1')
											GROUND:Unhide('Slugma_Girl_1')
											GAME:WaitFrames(20)
											--bootleg animate turn to, im NOT nesting coroutines.
											GROUND:EntTurn(slugma_boy_1, Direction.DownRight)
											GROUND:EntTurn(slugma_girl_1, Direction.DownLeft)
											GAME:WaitFrames(4)
											GROUND:EntTurn(slugma_boy_1, Direction.Down)
											GROUND:EntTurn(slugma_girl_1, Direction.Down)
											GROUND:CharSetAnim(slugma_boy_1, "Idle", true)
											GROUND:CharSetAnim(slugma_girl_1, "Idle", true)
											end)

    coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(80)
											SOUND:PlaySE('Slugma Materialize')
											slugma_anim_right_2:SetupEmitted(RogueElements.Loc(slugma_girl_2.Position.X + 8, slugma_girl_2.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_2:SetupEmitted(RogueElements.Loc(slugma_boy_2.Position.X + 8, slugma_boy_2.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_2, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_2, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(68)
											GROUND:Unhide('Slugma_Boy_2')
											GROUND:Unhide('Slugma_Girl_2')
											GAME:WaitFrames(20)
											GROUND:CharSetAnim(slugma_boy_2, "Idle", true)
											GROUND:CharSetAnim(slugma_girl_2, "Idle", true)
											end)
	
	coro3 = TASK:BranchCoroutine(function()	GAME:WaitFrames(160)
											SOUND:PlaySE('Slugma Materialize')
											slugma_anim_right_3:SetupEmitted(RogueElements.Loc(slugma_boy_3.Position.X + 8, slugma_boy_3.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_3:SetupEmitted(RogueElements.Loc(slugma_girl_3.Position.X + 8, slugma_girl_3.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_3, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_3, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(68)
											GROUND:Unhide('Slugma_Boy_3')
											GROUND:Unhide('Slugma_Girl_3')
											GAME:WaitFrames(20)
											GROUND:CharSetAnim(slugma_boy_3, "Idle", true)
											GROUND:CharSetAnim(slugma_girl_3, "Idle", true)
											end)
											
	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(240)
											SOUND:PlaySE('Slugma Materialize')
											slugma_anim_right_4:SetupEmitted(RogueElements.Loc(slugma_girl_4.Position.X + 8, slugma_girl_4.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_4:SetupEmitted(RogueElements.Loc(slugma_boy_4.Position.X + 8, slugma_boy_4.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_4, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_4, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(68)
											GROUND:Unhide('Slugma_Boy_4')
											GROUND:Unhide('Slugma_Girl_4')
											GAME:WaitFrames(20)
											--bootleg animate turn to, im NOT nesting coroutines.
											GROUND:EntTurn(slugma_boy_4, Direction.UpLeft)
											GROUND:EntTurn(slugma_girl_4, Direction.UpRight)
											GAME:WaitFrames(4)
											GROUND:EntTurn(slugma_boy_4, Direction.Up)
											GROUND:EntTurn(slugma_girl_4, Direction.Up)
											GROUND:CharSetAnim(slugma_boy_4, "Idle", true)
											GROUND:CharSetAnim(slugma_girl_4, "Idle", true)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)	
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) 
											--SOUND:PlayBattleSE('EVT_Emote_Shock')
											GROUND:CharSetEmote(partner, "shock", 1)
											GAME:WaitFrames(60)
											--GROUND:CharSetEmote(partner, "exclaim", 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
											GAME:WaitFrames(50)
											GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.Right)
											end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(42)	
												GROUND:CharSetEmote(hero, "exclaim", 1)
												GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) 
												GAME:WaitFrames(60)
												GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
												GAME:WaitFrames(10)
												--GROUND:CharSetEmote(hero, "notice", 1)
												GAME:WaitFrames(46)
												GeneralFunctions.LookAround(hero, 4, 4, true, false, false, Direction.Left)
												end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(46)	
												GROUND:CharSetEmote(growlithe, "shock", 1)
												GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) 
												GAME:WaitFrames(60)
												GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
												GAME:WaitFrames(10)
												--GROUND:CharSetEmote(growlithe, "exclaim", 1)
												GAME:WaitFrames(50)
												GeneralFunctions.LookAround(growlithe, 4, 4, true, false, false, Direction.Left)
												end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(48)	
												GROUND:CharSetEmote(zigzagoon, "shock", 1)
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) 
												GAME:WaitFrames(60)
												--GROUND:CharSetEmote(zigzagoon, "exclaim", 1)
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
												GAME:WaitFrames(50)
												GeneralFunctions.LookAround(zigzagoon, 4, 4, true, false, false, Direction.Right)
												end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_023']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_024'], _DATA:GetMonster('slugma'):GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_025']))
	GAME:WaitFrames(10)
	
	
	--TODO: slow the movement speed down of the slugmas here if possible.
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(slugma_boy_1, Direction.Down, 16, false, 1) GROUND:CharSetAnim(slugma_boy_1, "Idle", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GROUND:MoveInDirection(slugma_girl_1, Direction.Down, 16, false, 1) GROUND:CharSetAnim(slugma_girl_1, "Idle", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:MoveInDirection(slugma_girl_2, Direction.Right, 16, false, 1) GROUND:CharSetAnim(slugma_girl_2, "Idle", true) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:MoveInDirection(slugma_boy_2, Direction.Left, 16, false, 1) GROUND:CharSetAnim(slugma_boy_2, "Idle", true) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:MoveInDirection(slugma_boy_3, Direction.Right, 16, false, 1) GROUND:CharSetAnim(slugma_boy_3, "Idle", true) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:MoveInDirection(slugma_girl_3, Direction.Left, 16, false, 1) GROUND:CharSetAnim(slugma_girl_3, "Idle", true) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:MoveInDirection(slugma_girl_4, Direction.Up, 16, false, 1) GROUND:CharSetAnim(slugma_girl_4, "Idle", true) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) GROUND:MoveInDirection(slugma_boy_4, Direction.Up, 16, false, 1) GROUND:CharSetAnim(slugma_boy_4, "Idle", true) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	
	--GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(partner, "Walk", partner.Direction, 266, 246, 4, 1, 0) 
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GROUND:AnimateToPosition(growlithe, "Walk", growlithe.Direction, 246, 266, 1, 1, 0)  end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:AnimateToPosition(zigzagoon, "Walk", zigzagoon.Direction, 266, 266, 1, 1, 0) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:AnimateToPosition(hero, "Walk", hero.Direction, 246, 246, 1, 1, 0)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_026']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_028']))
	GAME:WaitFrames(20)
	
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_029']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_030']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_031']))
	GAME:WaitFrames(10)

	--magcargo spawns in via the heatran effect
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 6, 30))
											GAME:WaitFrames(10)	
											SOUND:PlayBattleSE("_UNK_EVT_003")
										--RESTAURE (comparaison Palikadude/Halcyon, branche working-copy,
										--2026-07) : retour a l'effet signature d'origine — Magcargo surgit
										--dans une colonne de flamme (Sacred_Fire_Ranger, calque Front), et
										--non plus sous le flash blanc generique du LOT 2.1. Port exact de
										--leur bloc (anim au pixel magcargo.Position.X + 8, Unhide a t=3).
										--L'AnimData n'est dans AUCUN des deux depots : il sort du contenu
										--de base du moteur, comme Slugma_Materialize (meme cas). Filet
										--pcall : si l'anim manquait chez un joueur, repli au flash blanc
										--a sa position — la scene continue dans tous les cas.
										local okFlamme = pcall(function()
											local arriveAnim = RogueEssence.Content.StaticAnim(RogueEssence.Content.AnimData("Sacred_Fire_Ranger", 3), 1)
											arriveAnim:SetupEmitted(RogueElements.Loc(magcargo.Position.X + 8, magcargo.Position.Y), 32, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(arriveAnim, RogueEssence.Content.DrawLayer.Front)
										end)
										if not okFlamme then BossFX.Flash(magcargo.Position.X, magcargo.Position.Y, 3, 5, 20) end
										GAME:WaitFrames(3)
										GROUND:Unhide('Magcargo')
										GAME:WaitFrames(37)	
											end)

	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 4, 1, 1)
											GROUND:CharSetEmote(partner, "shock", 1)
											GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 4, 1, 1)
											GROUND:CharSetEmote(hero, "exclaim", 1)
											GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											end)	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(growlithe, "None", growlithe.Direction, Direction.Down, 4, 1, 1)
											GROUND:CharSetEmote(growlithe, "shock", 1)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(zigzagoon, "None", zigzagoon.Direction, Direction.Down, 4, 1, 1)
											GROUND:CharSetEmote(zigzagoon, "shock", 1)
											GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(20)
											
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, magcargo.CurrentForm.Species, magcargo.CurrentForm.Form, magcargo.CurrentForm.Skin, magcargo.CurrentForm.Gender)				
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_032'], magcargo:GetDisplayName(), _DATA:GetMonster('slugma'):GetColoredName()))
	UI:SetSpeaker(magcargo)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_033']))

	--LOT 4 : la Voix mysterieuse s'invite avant l'epreuve du feu.
	GAME:WaitFrames(20)
	BossFX.Voice('SC5_085')
	--"Voici la fournaise. Brule, ou deviens digne."
	GAME:WaitFrames(20)
	
	--Setup for lavaflow variables will happen in the zone's enter segment.
	COMMON.BossTransition()
	GAME:CutsceneMode(false)	
	SV.Chapter5.EncounteredBoss = true
	--enter fight
	GAME:ContinueDungeon("searing_tunnel", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	
end

function searing_crucible_ch_5.SecondPreBossScene()

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
	--instead of having it play out like the first time, cut right to the chase of being surrounded again. sky does this a lot and,
	--while it is the lazy option, do you really want to see the same animation again? It'd be really contrived too at that part, or at least more so.
	--Magcargo says you continue to defile the lands and cause this crap. You truly are scum.
	--they try to speak up but get interrupted
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')

	--prep the slugmas now. Hide them now, unhide them when it's time.
	local slugma_boy = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Male)
	local slugma_girl = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Female)
	
	local slugma_boy_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 200), Direction.Down, 'Slugma', 'Slugma_Boy_1')
	local slugma_boy_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(312, 244), Direction.Left, 'Slugma', 'Slugma_Boy_2')
	local slugma_boy_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(200, 268), Direction.Right, 'Slugma', 'Slugma_Boy_3')
	local slugma_boy_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 312), Direction.Up, 'Slugma', 'Slugma_Boy_4')
	
	local slugma_girl_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 200), Direction.Down, 'Slugma', 'Slugma_Girl_1')
	local slugma_girl_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(200, 244), Direction.Right, 'Slugma', 'Slugma_Girl_2')
	local slugma_girl_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(312, 268), Direction.Left, 'Slugma', 'Slugma_Girl_3')
	local slugma_girl_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 312), Direction.Up, 'Slugma', 'Slugma_Girl_4')
	
	slugma_boy_1:ReloadEvents()
	slugma_boy_2:ReloadEvents()
	slugma_boy_3:ReloadEvents()
	slugma_boy_4:ReloadEvents()
	slugma_girl_1:ReloadEvents()
	slugma_girl_2:ReloadEvents()
	slugma_girl_3:ReloadEvents()
	slugma_girl_4:ReloadEvents()
	
	GAME:GetCurrentGround():AddTempChar(slugma_boy_1)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_2)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_3)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_4)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_1)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_2)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_3)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_4)
	

	local magcargo = 
		CharacterEssentials.MakeCharactersFromList({
			{'Magcargo', 256, 192, Direction.Down}
		})
	

	if partner ~= nil then AI:DisableCharacterAI(partner) end
	SOUND:StopBGM()
	
	GROUND:TeleportTo(hero, 246, 246, Direction.Up)
	GROUND:TeleportTo(partner, 266, 246, Direction.Up)
	GROUND:TeleportTo(growlithe, 246, 266, Direction.Up)
	GROUND:TeleportTo(zigzagoon, 266, 266, Direction.Up)
	GAME:MoveCamera(264, 264, 1, false)
	GAME:CutsceneMode(true)
	
	--spawn in the lava without any animation or anything.
	searing_crucible_ch_5.SpawnLava(false)

	--do this during the fade out: we need the wait frames to desync them, but we dont want it to take extra time to "load in", so do this as part of the 60 frames we'd want to wait for the display.
	GROUND:CharSetAnim(slugma_boy_1, "Idle", true)
	GROUND:CharSetAnim(slugma_girl_1, "Idle", true)
	GAME:WaitFrames(10)--desync anims
	GROUND:CharSetAnim(slugma_boy_2, "Idle", true)
	GROUND:CharSetAnim(slugma_girl_2, "Idle", true)
	GAME:WaitFrames(10)--desync anims
	GROUND:CharSetAnim(slugma_boy_3, "Idle", true)
	GROUND:CharSetAnim(slugma_girl_3, "Idle", true)
	GAME:WaitFrames(10)--desync anims
	GROUND:CharSetAnim(slugma_boy_4, "Idle", true)
	GROUND:CharSetAnim(slugma_girl_4, "Idle", true)
	GAME:WaitFrames(30)
		
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	
	GAME:WaitFrames(60)
	
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	
	SOUND:PlayBGM('Rising Fear.ogg', false)
	
	GAME:WaitFrames(40)
	
	UI:SetSpeaker(magcargo)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_034']))
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_035']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_036']))

	GAME:WaitFrames(20)	
	UI:SetSpeaker(magcargo)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_037']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_038']))
	
	
	--Setup for lavaflow variables will happen in the zone's enter segment.
	COMMON.BossTransition()
	GAME:CutsceneMode(false)	
	--enter fight
	GAME:ContinueDungeon("searing_tunnel", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	
	
end

--TASK:BranchCoroutine(searing_crucible_ch_5.DefeatedBoss)
-- Corps de la cinematique, appele sous pcall par DefeatedBoss() : toute erreur
-- Lua ici ne doit JAMAIS laisser le joueur sur un ecran noir definitif.
local function DefeatedBossBody()

	--LE NOIR ET LE GEL, AVANT TOUTE MISE EN PLACE.
	--
	--BUG CORRIGE (signale en jeu, deux fois : « l'ecran noir se rallume un
	--bref moment encore sur le crucible »). C'est CETTE fonction, pas la
	--scene d'arrivee au camp corrigee precedemment.
	--
	--Chemin reel apres la victoire sur Magcargo :
	--  EndSegment (GameManager.cs:952) pose FadeOut(false) -> noir
	--    -> OnExitSegment (l.1017)
	--    -> zone/searing_tunnel:226  GeneralFunctions.EndDungeonRun(...)
	--    -> GAME:EndDungeonRun -> Save.EndGame (display=false)
	--    -> GAME:EnterZone -> searing_crucible.Enter -> PlotScripting
	--    -> DefeatedBoss -> ICI.
	--
	--Or cette fonction executait 63 LIGNES avant son FadeIn(40) :
	--  8 x AddTempChar (les Slugma), SOUND:StopBGM, 4 x TeleportTo,
	--  GAME:MoveCamera, puis CutsceneMode(true) pose TARD, puis
	--  GAME:WaitFrames(60).
	--Ces 60+ frames sont RENDUES. GAME:FadeOut etant bloquant
	--(ScriptGame.cs:1590) et FadeInternal rendant la main a chaque frame
	--(FadeEffect.cs:30-42), rien ne garantissait le noir pendant ce
	--montage : le joueur voyait le Creuset se recomposer — camera qui
	--saute, Slugma qui apparaissent — pendant environ une seconde.
	--Le WaitFrames(60) explique exactement le « bref moment » decrit.
	--
	--Ces deux lignes sont donc les toutes premieres, avant meme les CH().
	--FadeOut(false,1) sur ecran deja noir est un no-op (FadeEffect.cs:63) :
	--gratuit quand le noir d'EndSegment a tenu, salvateur sinon.
	--CutsceneMode(true) des maintenant gele ProcessInput
	--(GroundScene.cs:176) pendant tout le montage, au lieu de 63 lignes
	--plus bas. Patron identique a hero_dream/init.lua:45-46.
	pcall(function() GAME:FadeOut(false, 1) end)
	pcall(function() GAME:CutsceneMode(true) end)
	--magcargo is actually defeated, and offers his neck metaphorically to the stone, party explains that they didn't even want to fight
	--magcargo explains he thought the outlanders were causing all the issues the tunnel's been experiencing
	--after they disappear, partner should mention that he's glad hyko and almotz were there. Just him and the palyer wouldn't have been able to deal with all those enemies at once
	--this took so long to sort out, it's probably night by now! We have to hurry ahead!
	--commenting on his exit being as dramatic as his entrance (with sweatdrops)
	--magcargo realizes he endangered his tribe by attacking you without listening to what you had to say... he apologizes
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')

	--prep the slugmas now. Hide them now, unhide them when it's time.
	local slugma_boy = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Male)
	local slugma_girl = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Female)
	
	local slugma_boy_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 200), Direction.Down, 'Slugma', 'Slugma_Boy_1')
	local slugma_boy_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(312, 244), Direction.Left, 'Slugma', 'Slugma_Boy_2')
	local slugma_boy_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(200, 268), Direction.Right, 'Slugma', 'Slugma_Boy_3')
	local slugma_boy_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 312), Direction.Up, 'Slugma', 'Slugma_Boy_4')
	
	local slugma_girl_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(292, 200), Direction.Down, 'Slugma', 'Slugma_Girl_1')
	local slugma_girl_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(200, 244), Direction.Right, 'Slugma', 'Slugma_Girl_2')
	local slugma_girl_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(312, 268), Direction.Left, 'Slugma', 'Slugma_Girl_3')
	local slugma_girl_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(220, 312), Direction.Up, 'Slugma', 'Slugma_Girl_4')
	
	slugma_boy_1:ReloadEvents()
	slugma_boy_2:ReloadEvents()
	slugma_boy_3:ReloadEvents()
	slugma_boy_4:ReloadEvents()
	slugma_girl_1:ReloadEvents()
	slugma_girl_2:ReloadEvents()
	slugma_girl_3:ReloadEvents()
	slugma_girl_4:ReloadEvents()
	
	GAME:GetCurrentGround():AddTempChar(slugma_boy_1)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_2)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_3)
	GAME:GetCurrentGround():AddTempChar(slugma_boy_4)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_1)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_2)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_3)
	GAME:GetCurrentGround():AddTempChar(slugma_girl_4)
	

	local magcargo = 
		CharacterEssentials.MakeCharactersFromList({
			{'Magcargo', 256, 192, Direction.Down}
		})
	
	GROUND:CharSetAnim(magcargo, "Charge", true)
	
	
	if partner ~= nil then AI:DisableCharacterAI(partner) end
	SOUND:StopBGM()
	
	GROUND:TeleportTo(hero, 244, 240, Direction.Up)
	GROUND:TeleportTo(partner, 268, 240, Direction.Up)
	GROUND:TeleportTo(growlithe, 240, 272, Direction.Up)
	GROUND:TeleportTo(zigzagoon, 272, 272, Direction.Up)
	GAME:MoveCamera(264, 264, 1, false)
	GAME:CutsceneMode(true)
	
	GAME:WaitFrames(60)
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(magcargo)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_039']))
	GAME:WaitFrames(10)
	
	--setup flash emitter 
    local center = GAME:GetCameraCenter()
	local emitter = RogueEssence.Content.FlashEmitter()
	emitter.FadeInTime = 2
    emitter.HoldTime = 2
    emitter.FadeOutTime = 2
    emitter.StartColor = Color(0, 0, 0, 0)
    emitter.Layer = DrawLayer.Top
    emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
    GROUND:PlayVFX(emitter, center.X, center.Y)
    SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(16)
    GROUND:PlayVFX(emitter, center.X, center.Y)
    SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(46)
	
	GROUND:CharEndAnim(magcargo)
	GAME:WaitFrames(20)

	--He collapses
	GeneralFunctions.PoseAndWait(magcargo, "Special0")
	GAME:WaitFrames(30)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_040']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_041']))
	
	--The slugmas all bow as well now, in sync.
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.PoseAndWait(slugma_boy_1, "Special0") end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.PoseAndWait(slugma_girl_1, "Special0") end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.PoseAndWait(slugma_boy_2, "Special0") end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.PoseAndWait(slugma_girl_2, "Special0") end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GeneralFunctions.PoseAndWait(slugma_boy_3, "Special0") end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GeneralFunctions.PoseAndWait(slugma_girl_3, "Special0") end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GeneralFunctions.PoseAndWait(slugma_boy_4, "Special0") end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GeneralFunctions.PoseAndWait(slugma_girl_4, "Special0") end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	
	--player's party look at each other and sweat
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(30)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GeneralFunctions.EmoteAndPause(growlithe, "Sweatdrop", false) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.EmoteAndPause(zigzagoon, "Sweatdrop", false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
		
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_042']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_043']))
	GAME:WaitFrames(40)
	
	UI:SetSpeaker(magcargo)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_044']))
 
	--They raise their heads back up.
	--TODO: Make sure Audino fixes this
	GeneralFunctions.ReversePoseAndWait(magcargo, "Special0")
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.ReversePoseAndWait(slugma_boy_1, "Special0") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.ReversePoseAndWait(slugma_girl_1, "Special0") end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.ReversePoseAndWait(slugma_boy_2, "Special0") end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.ReversePoseAndWait(slugma_girl_2, "Special0") end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GeneralFunctions.ReversePoseAndWait(slugma_boy_3, "Special0") end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GeneralFunctions.ReversePoseAndWait(slugma_girl_3, "Special0") end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GeneralFunctions.ReversePoseAndWait(slugma_boy_4, "Special0") end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GeneralFunctions.ReversePoseAndWait(slugma_girl_4, "Special0") end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})	
	GAME:WaitFrames(20)
	
	SOUND:PlayBGM('In the Depths of the Pit.ogg', false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_045']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_046']))
	--he bows again
	GROUND:CharSetAction(magcargo, RogueEssence.Ground.PoseGroundAction(magcargo.Position, magcargo.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex('Special0')))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_047']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_048']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_049']))
	GAME:WaitFrames(20)
	
	--Magcargo rises back up
	GeneralFunctions.ReversePoseAndWait(magcargo, "Special0")
	UI:SetSpeaker(magcargo)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_050']))
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_051']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_052']))
	GAME:WaitFrames(20)
	
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_053']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(magcargo)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_054']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_055']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_056']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_057']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_058']))
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_059']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_060']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_061']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_062']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_063']))
	GAME:WaitFrames(20)
	
	GeneralFunctions.EmoteAndPause(magcargo, "Sweatdrop", true)
	UI:SetSpeaker(magcargo)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_064']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_065']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_066']))
	--bows once more
	GROUND:CharSetAction(magcargo, RogueEssence.Ground.PoseGroundAction(magcargo.Position, magcargo.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex('Special0')))
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_067']))
	
	GAME:WaitFrames(30)
	--Magcargo rises back up
	GeneralFunctions.ReversePoseAndWait(magcargo, "Special0")
	GAME:WaitFrames(30)
	GROUND:CharAnimateTurnTo(magcargo, Direction.DownLeft, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(magcargo, Direction.DownRight, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(magcargo, Direction.Down, 4)
	GAME:WaitFrames(40)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_068']))
	GAME:WaitFrames(10)
	
	
	--Party looks around at them as the slugmas dematerialize. They're startled when Magcargo explodes to disappear
	local materializeAnimLeft = RogueEssence.Content.AnimData("Slugma_Materialize_Reverse", 3)
    local materializeAnimRight = RogueEssence.Content.AnimData("Slugma_Materialize_Reverse", 3)
    local leftFlip = 1
    local rightFlip = 0
    local fliptype = luanet.import_type('RogueEssence.Content.SpriteFlip')

    materializeAnimLeft.AnimFlip =  LUA_ENGINE:LuaCast(leftFlip, fliptype)
    materializeAnimRight.AnimFlip =  LUA_ENGINE:LuaCast(rightFlip, fliptype)
    
    local slugma_anim_left_1 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_1 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_2 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_2 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_3 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_3 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    local slugma_anim_left_4 = RogueEssence.Content.StaticAnim(materializeAnimLeft, 1)
    local slugma_anim_right_4 = RogueEssence.Content.StaticAnim(materializeAnimRight, 1)
    

	--4 sets of despawning
    coro1 = TASK:BranchCoroutine(function()	--bootleg animate turn to, im NOT nesting coroutines.
											GROUND:EntTurn(slugma_boy_4, Direction.UpLeft)
											GROUND:EntTurn(slugma_girl_4, Direction.UpRight)
											GAME:WaitFrames(4)
											GROUND:EntTurn(slugma_boy_4, Direction.Left)
											GROUND:EntTurn(slugma_girl_4, Direction.Right)
											GAME:WaitFrames(16)											
											SOUND:PlaySE('Slugma Materialize')
											GROUND:Hide('Slugma_Boy_4')
											GROUND:Hide('Slugma_Girl_4')
											slugma_anim_left_4:SetupEmitted(RogueElements.Loc(slugma_boy_4.Position.X + 8, slugma_boy_4.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_right_4:SetupEmitted(RogueElements.Loc(slugma_girl_4.Position.X + 8, slugma_girl_4.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_4, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_4, RogueEssence.Content.DrawLayer.Front)
											end)

    coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(100)
											SOUND:PlaySE('Slugma Materialize')
											GROUND:Hide('Slugma_Boy_3')
											GROUND:Hide('Slugma_Girl_3')
											slugma_anim_right_3:SetupEmitted(RogueElements.Loc(slugma_boy_3.Position.X + 8, slugma_boy_3.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_3:SetupEmitted(RogueElements.Loc(slugma_girl_3.Position.X + 8, slugma_girl_3.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_3, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_3, RogueEssence.Content.DrawLayer.Front)
											end)
	
	coro3 = TASK:BranchCoroutine(function()	GAME:WaitFrames(180)
											SOUND:PlaySE('Slugma Materialize')
											GROUND:Hide('Slugma_Boy_2')
											GROUND:Hide('Slugma_Girl_2')
											slugma_anim_left_2:SetupEmitted(RogueElements.Loc(slugma_boy_2.Position.X + 8, slugma_boy_2.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_right_2:SetupEmitted(RogueElements.Loc(slugma_girl_2.Position.X + 8, slugma_girl_2.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_2, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_2, RogueEssence.Content.DrawLayer.Front)
											end)				
	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(240)
											--bootleg animate turn to, im NOT nesting coroutines.
											GROUND:EntTurn(slugma_boy_1, Direction.DownRight)
											GROUND:EntTurn(slugma_girl_1, Direction.DownLeft)
											GAME:WaitFrames(4)
											GROUND:EntTurn(slugma_boy_1, Direction.Right)
											GROUND:EntTurn(slugma_girl_1, Direction.Left)
											GAME:WaitFrames(16)		
											SOUND:PlaySE('Slugma Materialize')
											GROUND:Hide('Slugma_Boy_1')
											GROUND:Hide('Slugma_Girl_1')
											slugma_anim_right_1:SetupEmitted(RogueElements.Loc(slugma_boy_1.Position.X + 8, slugma_boy_1.Position.Y + 11), 0, RogueElements.Dir8.Down)
											slugma_anim_left_1:SetupEmitted(RogueElements.Loc(slugma_girl_1.Position.X + 8, slugma_girl_1.Position.Y + 11), 0, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(slugma_anim_left_1, RogueEssence.Content.DrawLayer.Front)
											GROUND:PlayVFXAnim(slugma_anim_right_1, RogueEssence.Content.DrawLayer.Front)
											GAME:WaitFrames(80)--Let the final animation coroutine finish before joining
											end)
	
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(50)	
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) 
											GAME:WaitFrames(60)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
											GAME:WaitFrames(130)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(60)	
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) 
											GAME:WaitFrames(60)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
											GAME:WaitFrames(130)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(52)	
											GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 4) 
											GAME:WaitFrames(60)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
											GAME:WaitFrames(130)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(56)	
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 4) 
											GAME:WaitFrames(60)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
											GAME:WaitFrames(130)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	GAME:WaitFrames(10)
	
	--magcargo explodes to leave
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 6, 30))
											GAME:WaitFrames(10)	
											SOUND:StopBGM()
										SOUND:PlayBattleSE("_UNK_EVT_003")
										--RESTAURE (meme comparaison du LOT 2.1) : la sortie de Magcargo
										--rejoue l'explosion de flamme d'origine (Sacred_Fire_Ranger,
										--calque Front, magcargo.Position.X + 8, Hide a t=3) au lieu du
										--flash blanc generique du LOT 2.2. Le son redevient celui du jeu
										--d'origine (_UNK_EVT_003, comme a l'apparition). Filet pcall :
										--repli au flash blanc si l'anim manque chez un joueur.
										local okFlamme2 = pcall(function()
											local arriveAnim2 = RogueEssence.Content.StaticAnim(RogueEssence.Content.AnimData("Sacred_Fire_Ranger", 3), 1)
											arriveAnim2:SetupEmitted(RogueElements.Loc(magcargo.Position.X + 8, magcargo.Position.Y), 32, RogueElements.Dir8.Down)
											GROUND:PlayVFXAnim(arriveAnim2, RogueEssence.Content.DrawLayer.Front)
										end)
										if not okFlamme2 then
											local flash = RogueEssence.Content.FlashEmitter()
											flash.FadeInTime = 2
											flash.HoldTime = 2
											flash.FadeOutTime = 20
											flash.StartColor = Color(255, 255, 255, 0)
											flash.Layer = DrawLayer.Top
											flash.Anim = RogueEssence.Content.BGAnimData("White", 0)
											GROUND:PlayVFX(flash, magcargo.Position.X, magcargo.Position.Y)
										end
										GAME:WaitFrames(3)
										GROUND:Hide('Magcargo')
											end)

	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 4, 1, 1)
											GeneralFunctions.Recoil(partner, "Hurt", 10, 10, false, false)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 4, 1, 1)
											GROUND:CharSetEmote(hero, "shock", 1)
											end)	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(growlithe, "None", growlithe.Direction, Direction.Down, 4, 1, 1)
											GeneralFunctions.Recoil(growlithe, "Hurt", 10, 10, false, false)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:AnimateInDirection(zigzagoon, "None", zigzagoon.Direction, Direction.Down, 4, 1, 1)
											GeneralFunctions.Recoil(zigzagoon, "Hurt", 10, 10, false, false)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(90)
		
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GeneralFunctions.EmoteAndPause(growlithe, "Sweatdrop", false) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.EmoteAndPause(zigzagoon, "Sweatdrop", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro4})
	GAME:WaitFrames(10)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_069']))
	GAME:WaitFrames(40)
	
	--phew... im glad that's over
	--thank goodness we had you there growlithe and zigzagoon
	--makes me wonder though... if the tunnel wasn't always like this, what's changed?
	--dunno...
	--Oh crud, we gotta hurry to the next camp!
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	SOUND:PlayBGM('In the Depths of the Pit.ogg', false)
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_070']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_071']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_072'], growlithe:GetDisplayName(), zigzagoon:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_073'], hero:GetDisplayName()))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_074']))
	GAME:WaitFrames(20)
	
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpRight, 4)
	GAME:WaitFrames(60)
	GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_075']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_076']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_077']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_078']))
	--UI:WaitShowDialogue("But it explains why the lava suddenly blocked our path as we tried to pass through here.")
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['SC5_083'], magcargo:GetDisplayName()), "Worried")
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['SC5_084']), "Worried")
	GAME:WaitFrames(60)
	
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	GeneralFunctions.Recoil(partner, nil, nil, nil, nil, false)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_079']))
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) 
											GeneralFunctions.EmoteAndPause(hero, "Notice", false) 
											end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true) 
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
											GeneralFunctions.EmoteAndPause(zigzagoon, "Exclaim", false) 
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	--GAME:WaitFrames(10)
	GROUND:CharTurnToChar(growlithe, partner)
	GAME:WaitFrames(2)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
								
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_080'], magcargo:GetDisplayName()))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_081']))

	--LOT 4 : le partenaire fixe le cap sur la derniere etape de l'expedition.
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['SC5_086']))
	--"Apres le feu... il ne reste que le vent. Le Mont Venteux nous attend."
	GAME:WaitFrames(20)
	
	--they leave
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveInDirection(partner, Direction.Up, 120, false, 2) end)			
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveInDirection(hero, Direction.Up, 114, false, 2) end)		
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
											GROUND:MoveInDirection(growlithe, Direction.Up, 110, false, 2) end)			
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:MoveInDirection(zigzagoon, Direction.Up, 106, false, 2) end)	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	--LE NOIR S'APPLIQUE APRES LA MARCHE, PAS PENDANT (deroule valide par
	--le joueur : dialogues -> deplacement visible -> ecran noir -> 2
	--repliques sur le noir -> le noir se leve sur le camp). Le fondu
	--branche dans la marche effacait les marcheurs a mi-trajet ; un
	--fondu trop tardif laissait revoir le creuset apres le noir. Ici :
	--la marche se termine en pleine lumiere, PUIS le noir tombe, tenu
	--sans trou jusqu'a la scene d'arrivee.
	SOUND:FadeOutBGM(40)
	GAME:FadeOut(false, 40)
	GAME:WaitFrames(50)
end

function searing_crucible_ch_5.DefeatedBoss()
	PrintInfo("[BossSeq][searing_crucible_ch_5] DefeatedBoss cutscene start")

	local ok, err = pcall(DefeatedBossBody)
	if not ok then
		PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
		pcall(function() GAME:FadeOut(false, 20) GAME:WaitFrames(20) end)
	end

	-- Sortie garantie : la suite de l'expedition (Mont) doit TOUJOURS s'ouvrir.
	--LE MODE CINEMATIQUE RESTE ACTIF PENDANT LA BASCULE (patron hero_dream) :
	--le couper ici laissait au moteur des frames de gameplay sur la carte
	--sortante pendant l'armement du changement — une fenetre ou l'ancienne
	--zone pouvait se redessiner a l'ecran. mount_windswept_entrance repose
	--le mode sans condition dans son Init.
	PrintInfo("[BossSeq][searing_crucible_ch_5] DefeatedBoss -> mount_windswept_entrance")
	GAME:EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker')
end



function searing_crucible_ch_5.SpawnLava(playAnimation)
	--lava stuff. initialize it before using it all
	local leftFlip = 1
	local rightFlip = 0
	local fliptype = luanet.import_type('RogueEssence.Content.SpriteFlip')
	--playAnimation = true to do the animation + sounds + shakes. false = to instantly set it up
	if playAnimation == nil then playAnimation = true end

	local lava_pool_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Lava_Pool_Connected', 4)
	local lava_pool_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Lava_Pool_Connected', 4)
	lava_pool_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)
	lava_pool_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)	
	
	local lava_anim_small_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Small_Lava_Stream', 4)
	local lava_anim_big_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Big_Lava_Stream', 4)
	lava_anim_small_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)
	lava_anim_big_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)

	local lava_anim_small_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Small_Lava_Stream', 4)
	local lava_anim_big_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Big_Lava_Stream', 4)
	lava_anim_small_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)
	lava_anim_big_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)
	
	
	if playAnimation then
		SOUND:LoopSE("Heavy Earthquake")
		GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 50))
		GAME:WaitFrames(50)

		SOUND:PlayBattleSE('_UNK_EVT_102')
		GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 5, 140))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_pool_left, RogueElements.Loc(5 * 24, 8 * 24)))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_pool_right, RogueElements.Loc(15 * 24, 8 * 24)))
		GAME:WaitFrames(40)

		SOUND:PlayBattleSE('_UNK_EVT_102')
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_left, RogueElements.Loc(7 * 24, 8 * 24)))
		--right needs to be offset on x axis by -24
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_right, RogueElements.Loc(14 * 24 - 24, 8 * 24)))
		GAME:WaitFrames(40)

		SOUND:PlayBattleSE('_UNK_EVT_102')
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_left, RogueElements.Loc(9 * 24, 8 * 24)))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_right, RogueElements.Loc(12 * 24 - 24, 8 * 24)))
		GAME:WaitFrames(60)
		SOUND:FadeOutSE("Heavy Earthquake", 90)
		SOUND:FadeOutSE("Light Earthquake", 90)	
		GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 50))
		GAME:WaitFrames(50)

		GROUND:MoveScreen(RogueEssence.Content.ScreenMover(1, 3, 40))
		GAME:WaitFrames(40)
	else
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_pool_left, RogueElements.Loc(5 * 24, 8 * 24)))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_pool_right, RogueElements.Loc(15 * 24, 8 * 24)))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_left, RogueElements.Loc(7 * 24, 8 * 24)))
		--right needs to be offset on x axis by -24
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_right, RogueElements.Loc(14 * 24 - 24, 8 * 24)))	
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_left, RogueElements.Loc(9 * 24, 8 * 24)))
		GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_right, RogueElements.Loc(12 * 24 - 24, 8 * 24)))
	end
end

