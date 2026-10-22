require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_third_floor_lobby_ch_1 = {}

function guild_third_floor_lobby_ch_1.SetupGround()
	local door = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Closed_Guild_Door", 1, 0, 0),
													RogueElements.Rect(416, 160, 64, 64),
													RogueElements.Loc(0, -8),
													false,
													"Event_Object_1")
	door:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(door)

	GROUND:Hide('Door_Exit')
	GAME:FadeIn(20)
end

function guild_third_floor_lobby_ch_1.Event_Object_1_Action(obj, activator)
	local hero = CH('PLAYER')
    local partner = CH('Teammate1')
	partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)

	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_001']))
	UI:SetCenter(false)

	partner.IsInteracting = false
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
end


--TASK:BranchCoroutine(guild_third_floor_lobby_ch_1.GoToGuildmasterRoom)
--follow noctowl to guildmaster's room
function guild_third_floor_lobby_ch_1.GoToGuildmasterRoom()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(600, 240, 1, false)


	local door = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Closed_Guild_Door", 1, 0, 0),
													RogueElements.Rect(416, 160, 64, 64),
													RogueElements.Loc(0, -8),
													false,
													"Closed_Door")
	door:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(door)

	local noctowl =
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 600, 240, Direction.Up}
		})


	GAME:FadeIn(40)

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_003']))

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Left, 4)
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 440, 240, false, 1)
												  GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(15)
												  GROUND:MoveToPosition(partner, 584, 240, false, 1)
												  GeneralFunctions.EightWayMove(partner, 472, 240, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(15)
												  GROUND:EntTurn(hero, Direction.DownLeft)
												  GAME:WaitFrames(32)
												  GeneralFunctions.EightWayMove(hero, 512, 240, false, 1)
												  GeneralFunctions.EightWayMove(hero, 472, 272, false, 1)
												  GROUND:CharTurnToChar(hero, noctowl) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:MoveCamera(466, 240, 136, false)	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	--wait there please.
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_004']))

	--[[GeneralFunctions.DoubleHop(partner, 'None', 6, 6)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_005']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_006']))
	]]--
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4)


	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(noctowl, Direction.Up, 16, false, 1)
											end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, noctowl) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	--open and close the door
	GROUND:Hide(door.EntName)
	SOUND:PlayBattleSE('EVT_Chest_Click')
	GAME:WaitFrames(40)
	GROUND:MoveInDirection(noctowl, Direction.Up, 8, false, 1)
	GROUND:Hide(noctowl.EntName)
	GAME:WaitFrames(20)
	GROUND:Unhide(door.EntName)
	SOUND:PlayBattleSE('EVT_Chest_Click')


	GAME:WaitFrames(60)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.DoubleHop(partner, nil, nil, nil, nil, true)

	--omg im so excited but also so scared
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharSetAnim(partner, "Idle", true)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_007']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_008'], noctowl:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_009']))
	--need to group these together for the script=0 call next line.
	function HopThenIdle()
		GeneralFunctions.Hop(partner)
		GROUND:CharSetAnim(partner, "Idle", true)
	end
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_010']), {function() return HopThenIdle() end})

--[[ I think it's too early for serious emotional support between these two but im not deleting all this scripting
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_011']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_012']))

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(It must be hard for " .. partner:GetDisplayName() .. " to relax in a situation like this...)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(But if " .. GeneralFunctions.GetPronoun(partner, "they") .. " doesn't calm down,[pause=10] I don't think we have a shot at joining here.)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)

	--calm down partner!!
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_013']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_014']))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_015']))
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetEmote(partner, "", 0)

	GeneralFunctions.SetEmotion("Sigh")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("In...[pause=40] Out...[pause=40] In...[pause=40] Out...", 40) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, 'DeepBreath')
											GeneralFunctions.DoAnimation(partner, 'DeepBreath') end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	--todo: two hops
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_016']))
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_017']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_018']))

	--the partner is great he just needs to believe in himself :3
	--ty hero for the peptalk
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(It's hard for me to fully understand how " .. partner:GetDisplayName() .. " is feeling right now...)", "Sad")
	GeneralFunctions.HeroDialogue(hero, "(Truthfully,[pause=10] I hardly know " .. GeneralFunctions.GetPronoun(partner, "them") .. ".)", "Sad")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(But what I do understand is that this apprenticeship means more than anything in the world to "  .. GeneralFunctions.GetPronoun(partner, "them") .. ".)", "Determined")
	GeneralFunctions.HeroDialogue(hero, "(In the short time that I've been with " .. GeneralFunctions.GetPronoun(partner, "them") .. ",[pause=10] he rescued me and promised to help get to the bottom of my amnesia.)", "Determined")
	GeneralFunctions.HeroDialogue(hero, "(If that isn't the making of a great adventurer,[pause=10] then I don't know what is!)", "Determined")
	GeneralFunctions.HeroDialogue(hero, "(" .. GeneralFunctions.GetPronoun(partner, "they", true) .. " just needs to realize that and have a little more confidence![pause=0] Then I'm sure we can do it!)", "Determined")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_019']))
	--todo two hops
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_020']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_021']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_022'], hero:GetDisplayName()))
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I'm glad I was able to get through to " .. GeneralFunctions.GetPronoun(partner, "them") .. "!)", "Happy")
]]--

	--GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " seems to be more at ease now.[pause=0] Perhaps some of " .. GeneralFunctions.GetPronoun(partner, "their") .. " anxiety has melted away...)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je ne sais pas grand-chose de ce maître de guilde...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Mais " .. partner:GetDisplayName() .. " semble avoir une haute opinion de lui.[pause=0]Je suis curieux de voir à quoi il ressemble réellement.)", "Normal")
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetAnim(partner, "None", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_023']))
	GROUND:CharSetEmote(partner, "sweating", 1)
	GeneralFunctions.SetEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_024']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_025'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	GeneralFunctions.HeroDialogue(hero, "(En vérité,[pause=10] je ne sais pas ce qui va se passer une fois que nous aurons franchi cette porte...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Mais vu mon amnésie et les nerfs de " .. partner:GetDisplayName() .. ",[pause=10]nos chances ne me semblent pas trop grandes...)", "Worried")
	GAME:WaitFrames(20)

	GeneralFunctions.HeroDialogue(hero, "(Même ainsi...[pause=0], j'ai le fort sentiment que tout va s'arranger.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Ce sentiment...[pause=0]Cela me rend certain que nous rejoindrons la guilde !)", "Normal")
	GAME:WaitFrames(20)

	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_026']))
	GAME:WaitFrames(20)

	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_027']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_028']))
	GAME:WaitFrames(60)

	GROUND:Hide(door.EntName)
	SOUND:PlayBattleSE('EVT_Chest_Click')
	--noctowl returns
	--in general, when both the hero and partner are emoting at the same time to the same event, the hero should have a less extreme reaction
	--notice hero vs exclaim partner in this example
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
											GROUND:EntTurn(noctowl, Direction.Down)
											GROUND:Unhide(noctowl.EntName)
											GROUND:MoveInDirection(noctowl, Direction.Down, 24, false, 1)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetEmote(hero, "notice", 1)
											GROUND:CharTurnToCharAnimated(hero, noctowl, 4)
											GAME:WaitFrames(30)
											--SOUND:PlayBattleSE('EVT_Emote_Exclaim')
											GeneralFunctions.FaceMovingCharacter(hero, noctowl) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetAnim(partner, "None", true)
											GROUND:CharSetEmote(partner, "exclaim", 1)
											GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
											GAME:WaitFrames(20)
											GeneralFunctions.FaceMovingCharacter(partner, noctowl) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_029']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G3L1_030']))

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(noctowl, Direction.Up, 24, false, 1)
											GROUND:Hide(noctowl.EntName) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, noctowl) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(40)

	--let's do it!
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Nod') end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	GROUND:MoveToPosition(partner, 440, 240, false, 1)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 440, 216, false, 1) GROUND:Hide(hero.EntName) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 440, 216, false, 1) GROUND:Hide(partner.EntName) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:FadeOut(false, 40)
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_guildmasters_room", "Main_Entrance_Marker")

end
