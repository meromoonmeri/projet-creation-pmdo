require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_guildmasters_room_ch_4 = {}


function guild_guildmasters_room_ch_4.Tropius_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
		GeneralFunctions.StartConversation(chara, "Bonjour, équipe[pause=10]" .. GAME:GetTeamName() .. "![pause=0]Bonne chance pour explorer " .. zone:GetColoredName() .. " aujourd'hui !")
		if SV.Chapter3.TropiusGaveWand or SV.Chapter2.TropiusGaveReviver then
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_001']))
		else
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_002']))
		end
		GeneralFunctions.SetEmotion("Joyous")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_003']))
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(chara, "", 0)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_004']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_005']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_006']))
		SV.Chapter4.TropiusGaveAdvice = true
	else
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
		GeneralFunctions.StartConversation(chara, "Excellent travail encore, vous deux explorant " .. zone:GetColoredName() .. " ![pause=0]Je suis toujours incrédule face à la taille de cet Apricorn !", "Happy")
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_007']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_008'], CharacterEssentials.GetCharacterName("Breloom"), CharacterEssentials.GetCharacterName("Girafarig")))
	end
	GeneralFunctions.EndConversation(chara)
end


function guild_guildmasters_room_ch_4.PresentApricornCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local tropius = CH('Tropius')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	GROUND:Hide('Bottom_Exit')
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(192, 120, 1, false)
	SOUND:StopBGM()

	GROUND:TeleportTo(hero, 168, 256, Direction.Up)
	GROUND:TeleportTo(partner, 200, 256, Direction.Up)

	local noctowl =
	CharacterEssentials.MakeCharactersFromList({
		{"Noctowl", 152, 120, Direction.Up}
	})

	local team2 = GAME:GetPlayerPartyMember(2)
	local team3 = GAME:GetPlayerPartyMember(3)


	local apricorn = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Yellow_Box", 1), --anim data. Don't set that number to 0 for valid anims
								 				 RogueElements.Rect(184, 136, 16, 16),--xy coords, then size
								  				 RogueElements.Loc(0, 0), --offset
												 true,
												 "Apricorn_Big")--object entity name
	apricorn:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(apricorn)
	GROUND:ObjectSetDefaultAnim(apricorn, 'Apricorn_Big', 0, 0, 0,Direction.Down)
	GROUND:Hide(apricorn.EntName)

	--setup your teammates without using spawners
	local monster
	if team2 ~= nil then
		monster = RogueEssence.Dungeon.MonsterID(team2.CurrentForm.Species, team2.CurrentForm.Form, team2.CurrentForm.Skin, team2.CurrentForm.Gender)
		team2 = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(184, 288), Direction.Down, team2.Nickname, 'Teammate2')
		team2:ReloadEvents()
		GAME:GetCurrentGround():AddTempChar(team2)
	end

	if team3 ~= nil then
		monster = RogueEssence.Dungeon.MonsterID(team3.CurrentForm.Species, team3.CurrentForm.Form, team3.CurrentForm.Skin, team3.CurrentForm.Gender)
		team3 = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(216, 288), Direction.Down, team3.Nickname, 'Teammate3')
		team3:ReloadEvents()
		GAME:GetCurrentGround():AddTempChar(team3)
	end

	GROUND:CharTurnToChar(tropius, noctowl)
	GROUND:CharTurnToChar(noctowl, tropius)

	GROUND:CharSetAnim(tropius, "Idle", true)
	GROUND:CharSetAnim(noctowl, "Idle", true)

	GAME:FadeIn(40)
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)


	--partner and co walk in on guildmaster and noctowl talking.
	--Partner excitedly gets guildmasters attention
	--guildmaster notices them and happily greets them. Asks if they ended up finding anything from the dungeon
	--partner lights up and presents the Apricorn. Tropius and noctowl are surprised by the size of the Apricorn.
	--Noctowl notes it's quite rare for Apricorns to get that big, but they're more effective the bigger they are
	--Tropius agrees and note it's an amazing find. well done!
	--Oh, thank you guildmaster! Here, take it!
	--Tropius denies the apricorn, insists that since your team found the treasure they should keep it. You'll get more use out of it
	--You get the big apricorn.
	--Partner thanks guildmaster for their generosity.
	--ofc ofc. Looks like it's dinner time, we'll catch up!
	--player and partner goes, camera follows them out, then pans back to noctowl and tropius.
	--Noctowl notes it was quite early to send us on such a test. Is it truly wise to involve rookies with the meaning of this expedition?
	--Tropius replies with "We'll need all the talented hands we can get if our suspicions prove true..."

	GAME:WaitFrames(40)
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 200, 152, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 168, 152, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 184, 184, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 216, 184, false, 1) end end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_009']))
	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharEndAnim(tropius)
											GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharEndAnim(noctowl)
											GeneralFunctions.EmoteAndPause(noctowl, "Notice", false) end)
	TASK:JoinCoroutines({coro1, coro2})

	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_010'], GAME:GetTeamName()))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_011'], zone:GetColoredName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_012']))
	GAME:WaitFrames(20)

	--GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_013'], noctowl:GetDisplayName()))
	GAME:WaitFrames(20)

	--partner is just absolutely beaming the entire time
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_014']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_015']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_016']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_017']))
	GAME:WaitFrames(10)

	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	GROUND:MoveInDirection(partner, Direction.UpLeft, 8, false, 1)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE('EVT_CH02_Item_Place')
	GROUND:Unhide("Apricorn_Big")
	GROUND:EntTurn(hero, Direction.UpRight)
	GAME:WaitFrames(20)
	GROUND:AnimateInDirection(partner, "Walk", Direction.UpLeft, Direction.DownRight, 8, 1, 1)

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(noctowl, "Exclaim", 1)
	GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_018']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_019']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_020']))
	GAME:WaitFrames(10)

	GeneralFunctions.DoubleHop(partner)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_021']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_022']))
	GAME:WaitFrames(20)

	GROUND:CharEndAnim(partner)
	GROUND:EntTurn(partner, Direction.Up)
	GROUND:EntTurn(hero, Direction.Up)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_023']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")

	--slightly different dialogue if onix helped
	local onix_teammate, team2species, team3species
	if team2 ~= nil then team2species = team2.CurrentForm.Species end
	if team3 ~= nil then team3species = team3.CurrentForm.Species end

	if team2species == 'onix' then
		onix_teammate = team2
	elseif team3species == 'onix' then
		onix_teammate = team3
	end

	if onix_teammate ~= nil then
		GeneralFunctions.DuoTurnTowardsChar(onix_teammate)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_024'], onix_teammate:GetDisplayName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_025'], GeneralFunctions.GetPronoun(onix_teammate, "them")))
	else
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(hero, Direction.DownRight, 4) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(team3, Direction.UpLeft, 4) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_026']))
		--GAME:WaitFrames(20)
		--GeneralFunctions.SetEmotion("Normal")
		--UI:WaitShowDialogue("But honestly,[pause=10] my team did most of the work by acting as the base of the totem.[pause=0] My part was easy.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_027']))
	end
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")


	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_048']))
											UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_028']))
								 end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
								 GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
								 GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() if team2 ~= nil then
								 GAME:WaitFrames(14)
								 GROUND:CharAnimateTurnTo(team2, Direction.Up, 4) end end)
	local coro5 = TASK:BranchCoroutine(function() if team3 ~= nil then
												  GAME:WaitFrames(18)
												  GROUND:CharAnimateTurnTo(team3, Direction.Up, 4) end end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Joyous")
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_029']))
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(partner, "", 0)
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_030']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_031'], zone:GetColoredName()))
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_032']), {function() return GeneralFunctions.ShakeHead(tropius) end})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_033']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_034']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_035']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_036']))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	GROUND:MoveInDirection(partner, Direction.UpLeft, 8, false, 1)
	GAME:WaitFrames(10)
	GROUND:Hide("Apricorn_Big")
	SOUND:PlaySE('Event Item Pickup')
	GAME:WaitFrames(40)
	GeneralFunctions.RewardItem("apricorn_big")
	GAME:WaitFrames(20)
	GROUND:AnimateInDirection(partner, "Walk", Direction.UpLeft, Direction.DownRight, 8, 1, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_037']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_038']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_039']))


	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	GeneralFunctions.SetEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											GROUND:MoveInDirection(hero, Direction.Down, 240, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											GROUND:MoveInDirection(partner, Direction.Down, 240, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then
											GROUND:CharAnimateTurnTo(team2, Direction.Down, 4)
											GROUND:MoveInDirection(team2, Direction.Down, 80, false, 1)
											GROUND:MoveInDirection(team2, Direction.DownLeft, 8, false, 1)
											GROUND:MoveInDirection(team2, Direction.Down, 148, false, 1)
											end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then
											GROUND:CharAnimateTurnTo(team3, Direction.Down, 4)
											GROUND:MoveInDirection(team3, Direction.Down, 80, false, 1)
											GROUND:MoveInDirection(team3, Direction.DownLeft, 16, false, 1)
											GROUND:MoveInDirection(team3, Direction.Down, 140, false, 1) end end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) SOUND:FadeOutBGM(120) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.MoveCamera(192, 184, 1) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharSetEmote(tropius, "happy", 0)
												  UI:WaitShowTimedDialogue("Bon travail, équipe[pause=10]" .. GAME:GetTeamName() .. "![pause=30]Continuez votre bon travail !", 90)
												  GROUND:CharSetEmote(tropius, "", 0) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})

	GeneralFunctions.MoveCamera(192, 120, 1)
	GAME:WaitFrames(30)
	UI:SetSpeaker(noctowl)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_040']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_041']))
	GAME:WaitFrames(12)

	UI:SetSpeaker(tropius)
	GROUND:CharAnimateTurnTo(tropius, Direction.Left, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_042'], noctowl:GetDisplayName(), GAME:GetTeamName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_043']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_044']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_045']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_046']))

	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GMR4_047']))

	GAME:WaitFrames(60)
	GAME:FadeOut(false, 60)
	GAME:CutsceneMode(false)
	SV.TemporaryFlags.Dinnertime = true
	GAME:EnterGroundMap("guild_dining_room", "Main_Entrance_Marker")


end

return guild_guildmasters_room_ch_4
