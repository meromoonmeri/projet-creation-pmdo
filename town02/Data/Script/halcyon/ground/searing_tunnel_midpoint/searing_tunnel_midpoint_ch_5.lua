require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

searing_tunnel_midpoint_ch_5 = {}

function searing_tunnel_midpoint_ch_5.SetupGround()
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	
	if SV.Chapter5.TunnelMidpointState == 'FirstArrival' then
		GROUND:TeleportTo(zigzagoon, 216, 256, Direction.Up)
		GROUND:TeleportTo(growlithe, 236, 296, Direction.UpLeft)
		
	elseif SV.Chapter5.TunnelMidpointState == 'DeathArrival' then
		GROUND:TeleportTo(zigzagoon, 204, 208, Direction.Right)
		GROUND:TeleportTo(growlithe, 236, 208, Direction.Left)	
	elseif SV.Chapter5.TunnelMidpointState == 'RepeatArrival' then
		--use a more generic arrangement for them.
		GROUND:TeleportTo(zigzagoon, 172, 292, Direction.Up)
		GROUND:TeleportTo(growlithe, 172, 264, Direction.Down)	
	end
	
	GAME:FadeIn(20)
end




function searing_tunnel_midpoint_ch_5.Growlithe_Action(chara, activator)
	local slugma_species = _DATA:GetMonster('slugma'):GetColoredName()
	if SV.Chapter5.GrowlitheTropiusBossInterrupt then -- Use these lines if you attempted to tell the Guildmaster about the boss in the way.
	GeneralFunctions.StartConversation(chara, "Merci encore de ne pas avoir dénoncé la tribu de " .. CharacterEssentials.GetCharacterName("Tropius") .. ".[pause=0] Ça compte beaucoup pour moi,[pause=10] wouf.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_001'], slugma_species))
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_002'], CharacterEssentials.GetCharacterName("Tropius")))
	elseif SV.Chapter5.DiedToBoss then -- If you've died to the boss at all, then use those lines (unless the special Penticus dialogue was triggered)
	GeneralFunctions.StartConversation(chara, "Nous ne devons pas perdre espoir,[pause=10] wouf !")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_003'], slugma_species))
	elseif SV.Chapter5.TunnelMidpointState == 'FirstArrival' then
	GeneralFunctions.StartConversation(chara, "La dernière partie sera difficile ![pause=0] Mais je sais que nous pouvons y arriver,[pause=10] wouf !")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_004']))
	elseif SV.Chapter5.TunnelMidpointState == 'DeathArrival' then
	GeneralFunctions.StartConversation(chara, "Cette dernière partie n'est pas facile...", "Pain")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_005']))
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_006']))
	else--RepeatArrival
	GeneralFunctions.StartConversation(chara, "Nous sommes revenus au point de contrôle,[pause=10] wouf !")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_007']))
	end
	GeneralFunctions.EndConversation(chara)
end 

function searing_tunnel_midpoint_ch_5.Zigzagoon_Action(chara, activator)
	local slugma_species = _DATA:GetMonster('slugma'):GetColoredName()
	if SV.Chapter5.GrowlitheTropiusBossInterrupt then -- Use these lines if you attempted to tell the Guildmaster about the boss in the way.
	GeneralFunctions.StartConversation(chara, "Nous aurions peut-être dû demander de l'aide au Maître de Guilde pour la tribu de " .. slugma_species .. "...", "Worried")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_008'], CH('Teammate2'):GetDisplayName()))
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_009'], CH('PLAYER'):GetDisplayName(), CH('Teammate1'):GetDisplayName()))
	elseif SV.Chapter5.DiedToBoss then -- If you've died to the boss at all, then use those lines (unless the special Penticus dialogue was triggered)
	GeneralFunctions.StartConversation(chara, "Hmm.[pause=0] La tribu de " .. slugma_species .. " risque probablement de nous attaquer encore...", "Worried")
		GeneralFunctions.SetEmotion("Pain")
		GROUND:CharSetEmote(chara, "sweating", 1)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_010']))
	elseif SV.Chapter5.TunnelMidpointState == 'FirstArrival' then
	GeneralFunctions.StartConversation(chara, "Nous pouvons utiliser le rocher de Kangourex ici pour préparer la dernière étape.")
		GROUND:CharSetEmote(chara, "sweating", 1)
		GeneralFunctions.SetEmotion("Pain")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_011']))
	elseif SV.Chapter5.TunnelMidpointState == 'DeathArrival' then
	GeneralFunctions.StartConversation(chara, "Cette grotte devient de plus en plus difficile...[pause=0] et de plus en plus chaude !", "Pain")
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_012']))
	else--RepeatArrival
	GeneralFunctions.StartConversation(chara, "Préparons-nous rapidement avec le rocher de Kangourex.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_013']))
		GROUND:CharSetEmote(chara, "sweating", 1)
		GeneralFunctions.SetEmotion("Pain")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_014']))
	end
	GeneralFunctions.EndConversation(chara)
end 

function searing_tunnel_midpoint_ch_5.ContinueScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local coro1, coro2, coro3, coro4

	GROUND:Hide('North_Exit')
		
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 208, 120, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											GROUND:CharSetAnim(hero, "None", true) end)	
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 232, 120, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											GROUND:CharSetAnim(partner, "None", true) end) 
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 228, 128) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	--different movement pattern depending on where they are
	if SV.Chapter5.TunnelMidpointState == 'FirstArrival' then
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
												GeneralFunctions.EightWayMove(growlithe, 244, 256, false, 1)
												GeneralFunctions.EightWayMoveRS(growlithe, 236, 152, false, 1)
												GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) 
												GROUND:CharSetAnim(growlithe, "None", true) end)
		
		coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)
												GeneralFunctions.EightWayMoveRS(zigzagoon, 196, 248, false, 1)
												GeneralFunctions.EightWayMoveRS(zigzagoon, 204, 152, false, 1)
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												GROUND:CharSetAnim(zigzagoon, "None", true) end)
	
		coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 228, 160)
												GAME:WaitFrames(76)--time the wait so the second pan's end coincides with growlithe getting to his spot. (he gets there last) 
												GeneralFunctions.PanCamera(nil, nil, false, nil, 228, 120)
												end)
												
		TASK:JoinCoroutines({coro1, coro2, coro3})

	elseif SV.Chapter5.TunnelMidpointState == 'DeathArrival' then
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
												GeneralFunctions.EightWayMoveRS(growlithe, 236, 152, false, 1)
												GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) 
												GROUND:CharSetAnim(growlithe, "None", true) end)
		
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												GeneralFunctions.EightWayMoveRS(zigzagoon, 204, 152, false, 1)
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												GROUND:CharSetAnim(zigzagoon, "None", true) end)
		TASK:JoinCoroutines({coro1, coro2})
	
	else--RepeatArrival
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(growlithe, 236, 152, false, 1)
												GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) 
												GROUND:CharSetAnim(growlithe, "None", true) end)
	
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
												GeneralFunctions.EightWayMoveRS(zigzagoon, 188, 200, false, 1)
												GeneralFunctions.EightWayMove(zigzagoon, 204, 152, false, 1)
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												GROUND:CharSetAnim(zigzagoon, "None", true) end)

		coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 228, 160)
												GAME:WaitFrames(72)--time the wait so the second pan's end coincides with zigzagoon getting to his spot. (he gets there last) 
												GeneralFunctions.PanCamera(nil, nil, false, nil, 228, 120)
												end)
		TASK:JoinCoroutines({coro1, coro2, coro3})

	end
	
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Happy")
	
	if SV.Chapter5.TunnelMidpointState == 'FirstArrival' then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_015']))
	elseif SV.Chapter5.TunnelMidpointState == 'DeathArrival' then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_016']))
	else--RepeatArrival
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_017']))
	end 
	
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveInDirection(partner, Direction.Up, 72, false, 1) end)			
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveInDirection(hero, Direction.Up, 72, false, 1) end)		
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GROUND:MoveInDirection(growlithe, Direction.Up, 72, false, 1) end)			
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:MoveInDirection(zigzagoon, Direction.Up, 72, false, 1) end)	
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GAME:FadeOut(false, 40) end)


	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})	
	
	GAME:EnterDungeon("searing_tunnel", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end


--TASK:BranchCoroutine(searing_tunnel_midpoint_ch_5.FirstArrival)
function searing_tunnel_midpoint_ch_5.FirstArrival()

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
	--We've made it pretty far...
	--Ugh, this heat is sweltering! I hope we don't have too much farther to go.
	--Almotz explains it can't be far now, since they've hit a midpoint
	--A midpoint? 
	--Yeah, it's a rest area some dungeons have. We can use the Kanga rock here to get ready for the last stretch of the dungeon
	--The last bit will be pretty tough though, so let's make sure we're ready before we continue on.
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	
	GAME:CutsceneMode(true)
	GROUND:Hide('South_Exit')
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 208, 416, Direction.Up)
	GROUND:TeleportTo(partner, 232, 416, Direction.Up)
	GROUND:TeleportTo(growlithe, 236, 432, Direction.Up)
	GROUND:TeleportTo(zigzagoon, 204, 432, Direction.Up)
	
	GAME:MoveCamera(228, 264, 1, false)
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Lower Spring Cave.ogg', true)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
												  GROUND:MoveToPosition(hero, 208, 264, false, 1) 
												  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 232, 264, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
												  GROUND:MoveToPosition(zigzagoon, 204, 296, false, 1) 
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
												  GROUND:MoveToPosition(growlithe, 236, 296, false, 1)
												  GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_018']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_019']))

	GeneralFunctions.EmoteAndPause(zigzagoon, "Sweating", true)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_020']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	GROUND:CharTurnToChar(partner, zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_022'], zigzagoon:GetDisplayName()))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	GROUND:CharTurnToChar(zigzagoon, partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_023']))
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_024']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_025']))
	GAME:WaitFrames(10)
	
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
											GeneralFunctions.EightWayMoveRS(partner, 248, 276, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
											end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
											GeneralFunctions.EightWayMoveRS(hero, 192, 276, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
											end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EightWayMove(zigzagoon, 216, 256, false, 1)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(growlithe, zigzagoon) 
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_026']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_027']))
	GAME:WaitFrames(12)
		
	GROUND:CharTurnToCharAnimated(zigzagoon, partner, 4)
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_028']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_029']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_030']))
	GAME:WaitFrames(10)
	
	GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
	--GeneralFunctions.EightWayMoveRS(growlithe, 224, 272, false, 1)
	--GROUND:EntTurn(growlithe, Direction.Up)

	GROUND:Unhide('South_Exit')
	SV.Chapter5.PlayedMidpointIntro = true
	GeneralFunctions.PanCamera()	
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)
	
end 

--TASK:BranchCoroutine(searing_tunnel_midpoint_ch_5.WipedCutscene)
function searing_tunnel_midpoint_ch_5.WipedCutscene()

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
	--Urf... Where are we?
	--Looks like we're back at the midpoint... If any of us faint past the midway point, looks like we get sent back here instead of the entrance.
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local coro1, coro2, coro3, coro4
	
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 208, 176, Direction.Left)
	GROUND:TeleportTo(partner, 232, 176, Direction.Right)
	GROUND:TeleportTo(zigzagoon, 204, 208, Direction.Right)
	GROUND:TeleportTo(growlithe, 236, 208, Direction.Left)
	
	--todo: if growlithe gets eventsleep/wake animations, use them here.
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(10)--to offset their breathing cycles
	GROUND:CharSetAnim(growlithe, "Sleep", true)
	GROUND:CharSetAnim(zigzagoon, "EventSleep", true)
	
	GAME:MoveCamera(228, 200, 1, false)
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Lower Spring Cave.ogg', true)
	GAME:WaitFrames(110)--slightly less than 120 frames so that the sleep animation doesnt barely start another frame before waking
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Wake')
											GAME:WaitFrames(10) 
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Left)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.DoAnimation(partner, 'Wake')
											GAME:WaitFrames(15) 
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Right)
											end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.DoAnimation(zigzagoon, 'Wake')
											GAME:WaitFrames(10) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(zigzagoon, 3, 4, false, false, true, Direction.Down)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) 
										    GeneralFunctions.DoAnimation(growlithe, 'Rumble')
											GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(growlithe, 3, 4, false, false, false, Direction.Down) 
											end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(30)
	
	coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_031']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_032']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_033']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	--Death was due to boss
	if SV.Chapter5.JustDiedToBoss then
		GAME:WaitFrames(10)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		GAME:WaitFrames(40)
		GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_034']))
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_035'], _DATA:GetMonster('slugma'):GetColoredName()))
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(zigzagoon)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_036']))
		GeneralFunctions.SetEmotion("Pain")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_037']))
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(growlithe)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_038']))
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_039'], growlithe:GetDisplayName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_040']))
	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_041']))
		--UI:WaitShowDialogue("We've got to be close to the end,[pause=10] we can't give up now!")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM5_042']))
	end
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(growlithe, zigzagoon, 4)
	GROUND:CharAnimateTurnTo(zigzagoon, growlithe, 4)

	--clear flags related to signaling this scene.
	SV.Chapter5.JustDiedToBoss = false
	SV.SearingTunnel.DiedPastCheckpoint = false
	GeneralFunctions.PanCamera()	
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)

end
