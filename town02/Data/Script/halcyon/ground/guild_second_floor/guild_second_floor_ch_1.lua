require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_second_floor_ch_1 = {}




function guild_second_floor_ch_1.MeetNoctowl()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GeneralFunctions.CenterCamera({hero, partner})
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--[[
	--set up background pokemon
	--team rollout
	local marker1 = MRKR("Left_Trio_1")
	local marker2 = MRKR("Left_Trio_2")
	local marker3 = MRKR("Left_Trio_3")

	--todo: turn into templates?
	local jigglypuff = GROUND:CreateCharacter("Jigglypuff", "Jigglypuff", marker1.Position.X, marker1.Position.Y, "", "")
	local spheal = GROUND:CreateCharacter("Spheal", "Spheal", marker2.Position.X, marker2.Position.Y, "", "")
	local marill = GROUND:CreateCharacter("Marill", "Marill", marker3.Position.X, marker3.Position.Y, "", "")

	--Team
	marker1 = MRKR("Generic_Spawn_Duo_1")
	marker2 = MRKR("Generic_Spawn_Duo_2")

	local cleffa = GROUND:CreateCharacter("Cleffa", "Cleffa", marker1.Position.X, marker1.Position.Y, "", "")
	local aggron = GROUND:CreateCharacter("Aggron", "Aggron", marker2.Position.X, marker2.Position.Y, "", "")

	--Tsundere team
	marker1 = MRKR("Right_Duo_1")
	marker2 = MRKR("Right_Duo_2")

	local mareep = GROUND:CreateCharacter("Mareep", "Mareep", marker1.Position.X, marker1.Position.Y, "", "")
	local cranidos = GROUND:CreateCharacter("Cranidos", "Cranidos", marker2.Position.X, marker2.Position.Y, "", "")


	--team style. Spawn them and noctowl offscreen.
	local luxio = GROUND:CreateCharacter("GroundChar", "Luxio", 480, 280, "", "")
	local glameow = GROUND:CreateCharacter("GroundChar", "Glameow", 512, 280, "", "")
	local cacnea = GROUND:CreateCharacter("GroundChar", "Cacnea", 544, 280, "", "")
	local luxio = GROUND:CreateCharacter("GroundChar", "Noctowl", 480, 280, "", "")


	local spheal = CharacterEssentials.MakeCharacterAtMarker('Spheal', 'Left_Trio_1')
	local jigglypuff = CharacterEssentials.MakeCharacterAtMarker('Jigglypuff', 'Left_Trio_2')
	local marill = CharacterEssentials.MakeCharacterAtMarker('Marill', 'Left_Trio_3')

	local mareep = CharacterEssentials.MakeCharacterAtMarker('Mareep', 'Right_Duo_1')
	local cranidos = CharacterEssentials.MakeCharacterAtMarker('Cranidos', 'Right_Duo_2')

	local cleffa = CharacterEssentials.MakeCharacterAtMarker('Cleffa', 'Generic_Spawn_Duo_1')
	local aggron = CharacterEssentials.MakeCharacterAtMarker('Aggron', 'Generic_Spawn_Duo_2')
	]]--
	local spheal, jigglypuff, marill, mareep, cranidos, cleffa, aggron, cacnea, glameow, luxio, noctowl, zigzagoon =
		CharacterEssentials.MakeCharactersFromList({
			{'Spheal', 'Left_Trio_1'},
			{'Jigglypuff', 'Left_Trio_2'},
			{'Marill', 'Left_Trio_3'},
			{'Mareep', 'Right_Duo_1'},
			{'Cranidos', 'Right_Duo_2'},
			{'Cleffa', 'Generic_Spawn_Duo_1'},
			{'Aggron', 'Generic_Spawn_Duo_2'},
			{'Cacnea', 480, 280, Direction.Left},
			{"Glameow", 512, 280, Direction.Left},
			{"Luxio", 544, 280, Direction.Left},
			{"Noctowl", 440, 272, Direction.Left},
			{"Zigzagoon", 336, 336, Direction.Down}
		})

	GROUND:CharSetAnim(marill, 'Idle', true)
	GROUND:CharSetAnim(jigglypuff, 'Idle', true)
	GROUND:CharSetAnim(spheal, 'Idle', true)

	GROUND:CharSetAnim(cleffa, 'Idle', true)
	GROUND:CharSetAnim(aggron, 'Idle', true)

	GROUND:CharSetAnim(mareep, 'Idle', true)
	GROUND:CharSetAnim(cranidos, 'Idle', true)

	GROUND:CharSetAnim(zigzagoon, 'Idle', true)


	GAME:FadeIn(40)

	AI:SetCharacterAI(jigglypuff, "halcyon.ai.ground_talking", true, 240, 60, 130, false, 'Default', {marill, spheal})
	AI:SetCharacterAI(marill, "halcyon.ai.ground_talking", true, 240, 60, 0, false, 'Default', {jigglypuff})

	AI:SetCharacterAI(cleffa, "halcyon.ai.ground_talking", false, 240, 60, 210, false, 'Angry', {aggron})
	--AI:SetCharacterAI(aggron, "halcyon.ai.ground_talking", true, 240, 120, 110, false, 'Scared', {cleffa})

	AI:SetCharacterAI(mareep, "halcyon.ai.ground_talking", true, 240, 60, 90, false, 'Default', {cranidos})

	AI:SetCharacterAI(zigzagoon, "halcyon.ai.ground_default", RogueElements.Loc(320, 320), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)


	GAME:WaitFrames(20)

	--wow look at all these pokemon
	--hero lags behind a bit because of their amazement
	GeneralFunctions.EmoteAndPause(hero, "Exclaim", true)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Surprised")
	local coro1 = TASK:BranchCoroutine(function()  GROUND:MoveToPosition(partner, 232, 304, false, 1) end)
	UI:WaitShowTimedDialogue("(Woah ![pause=30]Cet endroit est immense !)", 70)
	TASK:JoinCoroutines({coro1})

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.WaitThenMove(hero, 264, 304, false, 1, 20) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurn(partner, Direction.Up, 4, true) GeneralFunctions.FaceMovingCharacter(partner, hero) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GAME:MoveCamera(256, 300, 84, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(6)

	--they converse a bit while waiting for Noctowl
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_002']))
	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	GROUND:CharSetEmote(partner, "", 0)


	--team style will be leaving in the background while some talking and thinking happens.
	--it's strangely comforting because you're meant to be in a guild

	coro1 = TASK:BranchCoroutine(function () guild_second_floor_ch_1.TeamStyleLeaving(cacnea, false) end)
	coro2 = TASK:BranchCoroutine(function () guild_second_floor_ch_1.TeamStyleLeaving(glameow, false) end)
	coro3 = TASK:BranchCoroutine(function () guild_second_floor_ch_1.TeamStyleLeaving(luxio, true) end)

	GeneralFunctions.LookAround(hero, 2, 4, true, false, false, Direction.Left)
	GeneralFunctions.HeroDialogue(hero, "(Cela fait certainement beaucoup de choses à assimiler...[pause=0]Il y a tellement de Pokémon...)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(J'imagine que la plupart de ces Pokémon sont des aventuriers...)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je dois dire,[pause=10] je me sens étrangement réconforté d'être ici.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(...je me demande pourquoi ?)", "Worried")
	--GAME:WaitFrames(40)
	--UI:SetSpeaker(partner)
	--GeneralFunctions.SetEmotion("Worried")
	--GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	--UI:WaitShowDialogue("Hmm...[pause=0] I wonder where " .. noctowl:GetDisplayName() .. " is?")
	--UI:WaitShowDialogue("I'm getting anxious waiting to see him...")
	GAME:WaitFrames(40)


	--noctowl conveniently arrives
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(hero, "Exclaim", true) GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro2 = TASK:BranchCoroutine(function () GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) end)
	UI:WaitShowTimedDialogue("Vous deux,[pause=20]qui venez d'arriver !", 60)

	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, noctowl, 4, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl, 4, Direction.Up) end)
	coro3 = TASK:BranchCoroutine(function()  GROUND:MoveToPosition(noctowl, 248, 272, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GROUND:EntTurn(partner, Direction.Up)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)


	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, noctowl.CurrentForm.Species, noctowl.CurrentForm.Form, noctowl.CurrentForm.Skin, noctowl.CurrentForm.Gender)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_003'], noctowl:GetDisplayName()))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	--too long with no nicknames
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_004'], CharacterEssentials.GetCharacterName("Growlithe")))
	GAME:WaitFrames(20)

	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_005']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_006']))

	--partner is still nervous
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_007']))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_008']))
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	GeneralFunctions.SetEmotion("Stunned")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_009']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_010']))

	GAME:WaitFrames(40)
	GeneralFunctions.EmoteAndPause(hero, "Notice", true)

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " semble tendu.[pause=0]" .. GeneralFunctions.GetPronoun(partner, "are", true) .. " " .. GeneralFunctions.GetPronoun(partner, "they", false) .. " trop nerveux pour parler ?)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Je ferais mieux de dire quelque chose...)", "Normal")


	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)

	--both are shocked by hero suddenly speaking up, though noctowl is because of the request rather than hero speaking
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(noctowl, "Exclaim", true) end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_011']))

	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GAME:WaitFrames(12)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	GeneralFunctions.Hop(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_012']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_013']))
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownLeft, 4)
	GAME:WaitFrames(16)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_014'], partner:GetDisplayName()))
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)

	--yes ive been here before...
	GROUND:EntTurn(partner, Direction.UpRight)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion('Sad')
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_015']))

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_016']))
	GAME:WaitFrames(10)

	GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)
	GAME:WaitFrames(12)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_017']))
	GAME:WaitFrames(20)
	GROUND:EntTurn(hero, Direction.UpLeft)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_018']))

	--tell noctowl your name
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_019'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_020'], hero:GetDisplayName()))
	GAME:WaitFrames(20)
	GROUND:EntTurn(noctowl, Direction.Down)


	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_021']))

	GROUND:EntTurn(hero, Direction.Up)
	GROUND:EntTurn(partner, Direction.Up)
	GROUND:EntTurn(noctowl, Direction.Down)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Exclaim", true) end)
	TASK:JoinCoroutines({coro1, coro2})

	--there's an opening!
	--todo: two hops
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharSetAnim(partner, 'Idle', true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_022']))
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, 'None', true)
	--todo: maybe have noctowl question the duo a bit more?


	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_023']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_024']))

	--todo: two hops
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_025']))
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, "None", true)

	--I will take you to the guildmaster
	UI:SetSpeaker(noctowl)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_026']))
	GAME:WaitFrames(40)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_027']))


	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_028']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_029']))

	GAME:WaitFrames(20)

	--[[
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
								AI:EnableCharacterAI(partner)
								AI:SetCharacterAI(partner, "halcyon.ai.ground_partner", noctowl, partner.Position) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
								GROUND:CharSetEmote(hero, "shock", 1)
								GeneralFunctions.FaceMovingCharacter(hero, partner, 4, Direction.UpRight)
								AI:SetCharacterAI(hero, "halcyon.ai.ground_partner", partner, partner.Position) end)
	--]]



	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 520, 272, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(54)
								GROUND:MoveInDirection(hero, Direction.UpRight, 32, false, 1)
								GROUND:MoveToPosition(hero, 500, 272, false, 1)  end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(58)
								GROUND:MoveInDirection(partner, Direction.UpRight, 32, false, 1)
								GROUND:MoveToPosition(partner, 500, 272, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(160) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_third_floor_lobby", "Main_Entrance_Marker")
--TASK:BranchCoroutine(guild_second_floor_ch_1.MeetNoctowl)

end



function guild_second_floor_ch_1.TeamStyleLeaving(chara, isLeader)
	GROUND:MoveToPosition(chara, 336, 280, false, 1)
	GROUND:MoveToPosition(chara, 272, 216, false, 1)
	if isLeader then
		GAME:WaitFrames(20)
		GROUND:CharAnimateTurnTo(chara, Direction.Down, 4)
		GAME:WaitFrames(60)
		GROUND:CharAnimateTurnTo(chara, Direction.Up, 4)
	end
	GROUND:MoveToPosition(chara, 272, 160, false, 1)
	GROUND:Hide(chara.EntName)

end


function guild_second_floor_ch_1.SetupGround()
	local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1),
													RogueElements.Rect(184, 192, 144, 16),
													RogueElements.Loc(0, 0),
													true,
													"Event_Trigger_1")
	groundObj:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(groundObj)

	local spheal, jigglypuff, marill, mareep, cranidos, cleffa, aggron, zigzagoon =
		CharacterEssentials.MakeCharactersFromList({
			{'Spheal', 'Left_Trio_1'},
			{'Jigglypuff', 'Left_Trio_2'},
			{'Marill', 'Left_Trio_3'},
			{'Mareep', 'Right_Duo_1'},
			{'Cranidos', 'Right_Duo_2'},
			{'Cleffa', 'Generic_Spawn_Duo_1'},
			{'Aggron', 'Generic_Spawn_Duo_2'},
			{"Zigzagoon", 336, 336, Direction.Down}
		})

	GROUND:CharSetAnim(marill, 'Idle', true)
	GROUND:CharSetAnim(jigglypuff, 'Idle', true)
	GROUND:CharSetAnim(spheal, 'Idle', true)

	GROUND:CharSetAnim(cleffa, 'Idle', true)
	GROUND:CharSetAnim(aggron, 'Idle', true)

	GROUND:CharSetAnim(mareep, 'Idle', true)
	GROUND:CharSetAnim(cranidos, 'Idle', true)

	GROUND:CharSetAnim(zigzagoon, 'Idle', true)

	AI:SetCharacterAI(jigglypuff, "halcyon.ai.ground_talking", true, 240, 60, 130, false, 'Default', {marill, spheal})
	AI:SetCharacterAI(marill, "halcyon.ai.ground_talking", true, 240, 60, 0, false, 'Default', {jigglypuff, spheal})
	AI:SetCharacterAI(spheal, "halcyon.ai.ground_talking", true, 240, 60, 50, false, 'Default', {jigglypuff, marill})

	AI:SetCharacterAI(cleffa, "halcyon.ai.ground_talking", false, 240, 60, 210, false, 'Angry', {aggron})
	--AI:SetCharacterAI(aggron, "halcyon.ai.ground_talking", true, 240, 120, 110, false, 'Scared', {cleffa})

	AI:SetCharacterAI(mareep, "halcyon.ai.ground_talking", true, 240, 60, 90, false, 'Default', {cranidos})

	AI:SetCharacterAI(zigzagoon, "origin.ai.ground_default", RogueElements.Loc(320, 320), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	GAME:FadeIn(20)
end




function guild_second_floor_ch_1.Event_Trigger_1_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("Hé,[pause=10]" .. hero:GetDisplayName() .. ",[pause=10] où vas-tu ?")
	GAME:WaitFrames(10)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_030']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_031']))
	if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_032']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_033']))
	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_034']))
	end
	GAME:WaitFrames(20)
	GeneralFunctions.EndConversation(partner)
end



function guild_second_floor_ch_1.Cleffa_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Espèce d'idiot ![pause=0]Nous n'avons pas pu atteindre la fin parce que vous ne faites pas votre part !", "Angry", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_035']))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_1.Aggron_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Désolé patron...[pause=0], j'essaierai de faire mieux la prochaine fois...", "Sad", false)
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_1.Marill_Action(chara, activator)
	local move = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("round")--healbell
	GeneralFunctions.StartConversation(chara, "Nous sommes l'équipe[color=#FFA5FF]Round[color]![pause=0]Nous sommes appelés ainsi parce que notre attaque signature est le mouvement " .. move:GetColoredName() .. " !")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_1.Jigglypuff_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Toutes les équipes d'aventuriers ne travaillent pas pour la guilde.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_036']))
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_1.Spheal_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Dépêchons-nous et trouvons le travail de demain, les gars[pause=10]...", "Normal", false)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_037']))
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_1.Zigzagoon_Action(chara, activator)
	local zigzagoon = chara
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')


	if not SV.Chapter1.MetZigzagoon then


		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, zigzagoon.CurrentForm.Species, zigzagoon.CurrentForm.Form, zigzagoon.CurrentForm.Skin, zigzagoon.CurrentForm.Gender)
		GeneralFunctions.StartConversation(zigzagoon, "Euh...[pause=0]Je ne pense pas vous avoir déjà vu auparavant.[pause=0]Êtes-vous une nouvelle équipe d'aventuriers ?", "Normal", true, true, false)

		GAME:WaitFrames(20)
		GeneralFunctions.SetEmotion("Happy")
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_038'], GAME:GetTeamName()))

		GAME:WaitFrames(15)
		GROUND:CharTurnToCharAnimated(zigzagoon, partner, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, zigzagoon.CurrentForm.Species, zigzagoon.CurrentForm.Form, zigzagoon.CurrentForm.Skin, zigzagoon.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_039']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_040']))
		GAME:WaitFrames(40)
		GeneralFunctions.EmoteAndPause(zigzagoon, "Exclaim", true)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_041']))

		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_042']))

		GAME:WaitFrames(20)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, zigzagoon.CurrentForm.Species, zigzagoon.CurrentForm.Form, zigzagoon.CurrentForm.Skin, zigzagoon.CurrentForm.Gender)
		GeneralFunctions.DoubleHop(zigzagoon)
		GROUND:CharSetAnim(zigzagoon, "None", true)--we're not in cutscene mode so this needs to be set again after hopping
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_043'], zigzagoon:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(zigzagoon)
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_044']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_045']))
		GAME:WaitFrames(20)

		GeneralFunctions.EmoteAndPause(partner, "Question", true)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_046']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(zigzagoon)
		GeneralFunctions.SetEmotion("Happy")
		--need to group these together for the script=0 call next line.
		function HopThenIdle()
			GeneralFunctions.Hop(CH('Zigzagoon'))
			GROUND:CharSetAnim(CH('Zigzagoon'), "None", true)
		end
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_047']), {function() return HopThenIdle() end})
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_048']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_049']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Inspired")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_050']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_051'], hero:GetDisplayName()))
		GAME:WaitFrames(20)

		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_052']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(zigzagoon)
		GeneralFunctions.SetEmotion("Joyous")
		--GeneralFunctions.DoubleHop(zigzagoon)
		GROUND:CharSetEmote(zigzagoon, "glowing", 0)
		--SOUND:PlayBattleSE('EVT_Emote_Startled_2')
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_053']))
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(zigzagoon, "", 0)

		GeneralFunctions.SetEmotion('Normal')
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_054']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_055']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_056']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_057']))
		GAME:WaitFrames(20)

		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_058']))
		GeneralFunctions.EmoteAndPause(zigzagoon, 'Sweatdrop', true)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_059']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_060'], partner:GetDisplayName(), hero:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(zigzagoon)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_061'], partner:GetDisplayName(), hero:GetDisplayName()))
		SV.Chapter1.MetZigzagoon = true

		GAME:WaitFrames(15)
		GROUND:CharTurnToCharAnimated(zigzagoon, hero, 4)
		GeneralFunctions.Hop(zigzagoon)
		GROUND:CharSetAnim(zigzagoon, "None", true)--we're not in cutscene mode so this needs to be set again after hopping
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_062'], GAME:GetTeamName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_063']))


		--every guildmate is talked to, signal player that they can go sleep now
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			GAME:WaitFrames(60)
			GROUND:CharTurnToCharAnimated(partner, hero, 4)
			UI:SetSpeaker(partner)
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_064'], hero:GetDisplayName()))
			GROUND:CharTurnToCharAnimated(hero, partner, 4)
			GAME:WaitFrames(12)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_065']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_066'], hero:GetDisplayName()))
		end

		GeneralFunctions.EndConversation(zigzagoon)
	else
		GeneralFunctions.StartConversation(chara, "J'ai hâte de m'entraîner à la guilde ici avec vous,[pause=10]Team " .. GAME:GetTeamName() .. " !", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_067']))
		GeneralFunctions.EndConversation(chara)
	end


end



function guild_second_floor_ch_1.Cranidos_Action(chara, activator)
	local cranidos = chara
	local mareep = CH('Mareep')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	if not SV.Chapter1.MetCranidosMareep then
		GAME:FadeOut(false, 40)
		AI:DisableCharacterAI(partner)
		AI:DisableCharacterAI(mareep)
		GROUND:TeleportTo(hero, 408, 280, Direction.Up)
		GROUND:TeleportTo(partner, 376, 280, Direction.UpRight)
		GAME:MoveCamera(400, 272, 1, false)
		GAME:CutsceneMode(true)
		GROUND:EntTurn(mareep, Direction.Up)
		GROUND:CharSetEmote(mareep, "", 0)
		GROUND:CharSetAnim(cranidos, 'None', true)
		GROUND:CharSetAnim(mareep, 'None', true)--cutscene mode wasn't changing their anims for some reason automatically
		GROUND:CharSetAnim(CH('Zigzagoon'), "Idle", true)

		partner.IsInteracting = true
		GAME:WaitFrames(20)
		GAME:FadeIn(40)


		UI:SetSpeaker(cranidos)
		GeneralFunctions.SetEmotion("Normal")
		--GROUND:CharTurnToCharAnimated(hero, cranidos, 4)
		GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
		--GROUND:CharTurnToCharAnimated(partner, cranidos, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)

		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_068']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		UI:WaitShowTimedDialogue("Mon partenaire ici et moi venons de rejoindre la guilde,[pause=10]donc nous sommes-", 40)
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		GROUND:CharTurnToCharAnimated(cranidos, partner, 4)
		SOUND:FadeOutBGM(120)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_069']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_070']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_071']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_072']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowTimedDialogue("Seulement un peu,[pause=10]mais-", 60)
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_073']))
		GROUND:CharSetEmote(cranidos, "glowing", 0)
		GeneralFunctions.SetEmotion("Joyous")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_074']))
		GAME:WaitFrames(10)
		GROUND:CharSetEmote(cranidos, "", 0)

		GROUND:CharSetEmote(hero, "exclaim", 1)
		GAME:WaitFrames(10)
		GeneralFunctions.Complain(partner)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_075']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Angry")
		SOUND:PlayBattleSE('EVT_Emote_Complain_2')
		GROUND:CharSetEmote(cranidos, "angry", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_076']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_077']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Angry")
		GROUND:CharSetEmote(partner, "angry", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_078']))
		GAME:WaitFrames(40)

		AI:DisableCharacterAI(mareep)
		GROUND:CharSetAnim(mareep, "None", true)
		GeneralFunctions.EmoteAndPause(mareep, "Exclaim", true)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, mareep.CurrentForm.Species, mareep.CurrentForm.Form, mareep.CurrentForm.Skin, mareep.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_079'], cranidos:GetDisplayName()))
		GAME:WaitFrames(20)

		GROUND:CharSetEmote(partner, "", 0)
		GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", true)
		GROUND:CharSetEmote(cranidos, "sweating", 1)
		UI:SetSpeaker(cranidos)
		GeneralFunctions.SetEmotion("Surprised")
		SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', false)
		GROUND:CharTurnToCharAnimated(cranidos, mareep, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_080']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, mareep.CurrentForm.Species, mareep.CurrentForm.Form, mareep.CurrentForm.Skin, mareep.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Inspired")
		GROUND:CharSetAnim(mareep, "Idle", true)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_081']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(cranidos)
		GeneralFunctions.SetEmotion("Stunned")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_082']))
		GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_083']))
		GAME:WaitFrames(20)

		GROUND:CharSetAnim(mareep, "None", true)
		GROUND:CharTurnToCharAnimated(mareep, hero, 4)
		GROUND:CharTurnToChar(hero, mareep)
		GROUND:CharTurnToChar(partner, mareep)
		GeneralFunctions.Hop(mareep)
		GeneralFunctions.Hop(mareep)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, mareep.CurrentForm.Species, mareep.CurrentForm.Form, mareep.CurrentForm.Skin, mareep.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Happy")
		GROUND:CharSetEmote(mareep, "happy", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_084'], mareep:GetDisplayName()))
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(mareep, "", 0)

		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		UI:SetSpeaker(mareep)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_085'], cranidos:GetDisplayName()))
		GAME:WaitFrames(40)

		GROUND:CharSetEmote(partner, "sweatdrop", 1)
		SOUND:PlayBattleSE('EVT_Emote_Sweatdrop')
		GAME:WaitFrames(6)
		GROUND:CharSetEmote(hero, "sweatdrop", 1)
		GAME:WaitFrames(50)
		GeneralFunctions.HeroDialogue(hero, "(Sweetie?)", "Stunned")
		GAME:WaitFrames(20)

		UI:SetSpeaker(mareep)
		GeneralFunctions.SetEmotion("Normal")
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_086']))
		GAME:WaitFrames(20)


		GROUND:CharTurnToCharAnimated(partner, mareep, 4)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Stunned")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_087'], partner:GetDisplayName(), hero:GetDisplayName(), GAME:GetTeamName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(mareep)
		GeneralFunctions.Hop(mareep)
		GeneralFunctions.SetEmotion("Happy")
		GROUND:CharSetEmote(mareep, "happy", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_088']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_089'], GAME:GetTeamName()))
		GROUND:CharSetEmote(mareep, "", 0)
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.Hop(partner)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_090']))
		GAME:WaitFrames(60)

		GeneralFunctions.EmoteAndPause(mareep, "Notice", true)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		UI:SetSpeaker(mareep)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_091'], cranidos:GetDisplayName()))
		GAME:WaitFrames(10)

		GROUND:CharSetEmote(cranidos, "shock", 1)
		SOUND:PlayBattleSE('EVT_Emote_Shock_Bad')
		GAME:WaitFrames(40)
		GROUND:CharTurnToCharAnimated(cranidos, mareep, 4)
		UI:SetSpeaker(cranidos)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_092']))
		GAME:WaitFrames(20)

		GROUND:CharTurnToCharAnimated(cranidos, hero)
		GROUND:CharTurnToChar(hero, cranidos)
		GROUND:CharTurnToChar(partner, cranidos)
		GeneralFunctions.SetEmotion("Pain")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_093']))
		GROUND:EntTurn(cranidos, Direction.DownRight)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_094']))
		GAME:WaitFrames(20)

		GROUND:CharSetEmote(partner, "sweatdrop", 1)
		GeneralFunctions.EmoteAndPause(hero, 'Sweatdrop', true)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Stunned")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_095']))
		GAME:WaitFrames(20)

		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(mareep, "Question", true)
		UI:SetSpeaker(mareep)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_096']))
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		GROUND:CharTurnToChar(hero, mareep)
		GROUND:CharTurnToChar(partner, mareep)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_097'], cranidos:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Stunned")
		GROUND:CharSetEmote(partner, "sweating", 1)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_098']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(mareep)
		GeneralFunctions.SetEmotion("Happy")
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_099']))
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_100']))
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_101'], cranidos:GetDisplayName()))
		GAME:WaitFrames(20)

		GROUND:CharTurnToChar(hero, cranidos)
		GROUND:CharTurnToChar(partner, cranidos)
		GeneralFunctions.EmoteAndPause(cranidos, "Sweating", true)
		GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 2)
		UI:SetSpeaker(cranidos)
		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_102']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(mareep)
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		GROUND:CharTurnToChar(hero, mareep)
		GROUND:CharTurnToChar(partner, mareep)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_103']))
		GAME:WaitFrames(20)

		--fade back in normal guild music
		SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_104']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_105']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_106'], cranidos:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_107'], mareep:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(mareep)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_108']))
		GAME:WaitFrames(20)

		GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
		GROUND:CharSetAnim(cranidos, 'Idle', true)
		GROUND:CharSetAnim(mareep, 'Idle', true)
		GROUND:CharSetAnim(CH('Zigzagoon'), 'Idle', true)
		AI:EnableCharacterAI(mareep)
		SV.Chapter1.MetCranidosMareep = true
		GeneralFunctions.PanCamera(400, 272)

		--every guildmate is talked to, signal player that they can go sleep now
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			GAME:WaitFrames(60)
			GROUND:CharTurnToCharAnimated(partner, hero, 4)
			UI:SetSpeaker(partner)
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_109'], hero:GetDisplayName()))
			GROUND:CharTurnToCharAnimated(hero, partner, 4)
			GAME:WaitFrames(12)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_110']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_111'], hero:GetDisplayName()))
		end
		GROUND:CharEndAnim(cranidos)
		GROUND:CharEndAnim(mareep)
		GROUND:CharEndAnim(CH('Zigzagoon'))
		partner.IsInteracting = false
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)


		GAME:CutsceneMode(false)

	else

		GeneralFunctions.StartConversation(chara, ".........", "Determined", false)
		GAME:WaitFrames(20)

		GeneralFunctions.Monologue("(" .. cranidos:GetDisplayName() .. " vous ignore.)")
		GeneralFunctions.EndConversation(chara)
	end
end

function guild_second_floor_ch_1.Mareep_Action(chara, activator)
	local mareep = chara
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	if not SV.Chapter1.MetCranidosMareep then
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, mareep.CurrentForm.Species, mareep.CurrentForm.Form, mareep.CurrentForm.Skin, mareep.CurrentForm.Gender)
		mareep.IsInteracting = true
		GeneralFunctions.StartConversation(chara, "Ooh,[pause=10]et ce travail ?[pause=0]Cet outla-a-a-aw a l'air d'être un vrai con ![pause=0]Faisons-les entrer !", "Normal", false, false, false)
		GAME:WaitFrames(20)
		UI:ResetSpeaker(false)
		UI:SetCenter(true)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_112']))
		UI:SetCenter(false)
		GeneralFunctions.EndConversation(chara, false)
		mareep.IsInteracting = false
	else
		GeneralFunctions.StartConversation(chara, "Vous allez avoir beaucoup de plaisir à travailler avec la guilde !", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_113']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F1_114'], CH('Cranidos'):GetDisplayName()))
		GeneralFunctions.EndConversation(chara)
	end
end


return guild_second_floor_ch_1
