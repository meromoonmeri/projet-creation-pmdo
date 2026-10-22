require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_second_floor_ch_4 = {}

function guild_second_floor_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		local spheal, jigglypuff, marill, mareep, cranidos, snubbull =
			CharacterEssentials.MakeCharactersFromList({
				{'Spheal', 'Left_Trio_2'},
				{'Jigglypuff', 'Left_Trio_3'},
				{'Marill', 'Left_Trio_1'},
				{'Mareep', 'Generic_Spawn_Duo_1'},
				{'Cranidos', 'Generic_Spawn_Duo_2'},
				{'Snubbull', 'Generic_Spawn_2'}
			})


		AI:SetCharacterAI(jigglypuff, "halcyon.ai.ground_talking", true, 240, 60, 60, false, 'Default', {marill, spheal})
		AI:SetCharacterAI(marill, "halcyon.ai.ground_talking", true, 240, 60, 110, false, 'Default', {jigglypuff, spheal})
		AI:SetCharacterAI(spheal, "halcyon.ai.ground_talking", true, 240, 60, 10, false, 'Default', {jigglypuff, marill})


		AI:SetCharacterAI(mareep, "halcyon.ai.ground_talking", true, 240, 60, 90, false, 'Default', {cranidos})

		AI:SetCharacterAI(snubbull, "halcyon.ai.ground_default", RogueElements.Loc(snubbull.Position.X - 16, snubbull.Position.Y - 16), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	else
		local silcoon, metapod =
			CharacterEssentials.MakeCharactersFromList({
				{'Silcoon', 'Generic_Spawn_Duo_1'},
				{'Metapod', 'Generic_Spawn_Duo_2'},
				{'Zangoose', 'Right_Duo_1'},
				{'Seviper', 'Right_Duo_2'}

			})
	end

	--let the cutscene handle the fade in if one is needed
	if SV.Chapter4.FinishedAssemblyIntro then
		GAME:FadeIn(20)
	end
end



function guild_second_floor_ch_4.Mareep_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Cette expédition va être géniale ![pause=0]Je suis pleine d'enthousiasme de la tête aux queues !", "Joyous")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_001']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_002']))
	else

	end
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_4.Cranidos_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Je suis surpris que le maître de guilde autorise des novices comme vous à participer à l'expédition.")
		GeneralFunctions.SetEmotion("Joyous")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_003']))
		GROUND:CharSetEmote(chara, "", 0)
	else

	end
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_4.Snubbull_Action(chara, activator)
	local kecleon_species = _DATA:GetMonster('kecleon'):GetColoredName()
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Les abricornes sont enfin en stock au Kecleon Shop,[pause=10]mais mon plat devra attendre.")
		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_004'], STRINGS:Format("\\u266A")))
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end



function guild_second_floor_ch_4.Jigglypuff_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Normalement,[pause=10] si l'un des membres de votre équipe s'évanouit,[pause=10] toute l'équipe est expulsée du donjon.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_005']))
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_4.Marill_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Vous pouvez utiliser Apricorns pour recruter plus de membres dans votre équipe d'aventuriers,[pause=10] mais nous aimons le nôtre tel qu'il est.")
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_006']))
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_007']))
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_4.Spheal_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Tout le monde parle des abricornes,[pause=10]mais peu importe !")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_008']))
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end



function guild_second_floor_ch_4.Metapod_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		local move = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("poison_sting")
		local ability = _DATA:GetIntrinsic("shield_dust"):GetColoredName()
		local silcoon_species = _DATA:GetMonster('silcoon'):GetColoredName()
		local metapod_species = _DATA:GetMonster('metapod'):GetColoredName()
		GeneralFunctions.StartConversation(chara, "Les effets secondaires d’attaques comme " .. move:GetColoredName() .. " sont plus courants que vous ne le pensez.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_009']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_010'], ability))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_011'], metapod_species, silcoon_species))
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_012']))
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_4.Silcoon_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		local focus = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("focus_energy")
		local slash = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("slash")
		local leaf_blade = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("leaf_blade")

		GeneralFunctions.StartConversation(chara, "Les aventuriers comme vous doivent connaître les coups critiques,[pause=10] n'est-ce pas ?")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_013']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_014'], slash:GetColoredName(), leaf_blade:GetColoredName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_015'], focus:GetColoredName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_016']))
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_4.Seviper_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "La rumeur circule dans la rue que la guilde part en expédition très prochainement.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_017']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_018'], CharacterEssentials.GetCharacterName("Zangoose")))
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_4.Zangoose_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "Une expédition...[pause=0]Cela semble intéressant,[pause=10]mais nos compétences ne sont pas bien adaptées à l'exploration.")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_019'], CharacterEssentials.GetCharacterName("Seviper")))
	end
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_4.AudinoAssemblyIntro()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local audino = CH('Assembly_Owner')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")

	GAME:MoveCamera(504, 208, 1, false)

	GROUND:Hide('Upwards_Stairs_Exit')

	GROUND:TeleportTo(partner, 552, 100, Direction.Left)
	GROUND:TeleportTo(hero, 552, 100, Direction.Left)
	GROUND:Hide(hero.EntName)
	GROUND:Hide("Teammate1")

	GAME:FadeIn(40)
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
    local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(52)
												  GROUND:Unhide('Teammate1')
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(partner, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(partner, 492, 132, false, 1)
												  GeneralFunctions.EightWayMove(partner, 492, 168, false, 1)
												  GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:Unhide(hero.EntName)
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(hero, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(hero, 492, 132, false, 1)
												  GeneralFunctions.EightWayMove(hero, 492, 200, false, 1)
												  GeneralFunctions.EmoteAndPause(hero, "Exclaim", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(90)
												  GeneralFunctions.EmoteAndPause(audino, "Notice", false)
												  GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
												  GAME:WaitFrames(6)
												  GROUND:CharSetEmote(audino, "happy", 0)
												  UI:WaitShowTimedDialogue("H-hey![pause=30] " .. hero:GetDisplayName() .. "![pause=30] " .. partner:GetDisplayName() .. "!", 60) end)


	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(audino, "", 0)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 580, 216, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:MoveToPosition(partner, 492, 200, false, 1)
											GeneralFunctions.EightWayMove(partner, 556, 216, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GeneralFunctions.FaceMovingCharacter(audino, hero, 4, Direction.Down) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GAME:MoveCamera(576, 208, 72, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_020'], audino:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	local audino_species = _DATA:GetMonster('audino'):GetColoredName()
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_021'], audino_species))
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_022'], audino_species))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_023']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_024']))

	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)

	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_025'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	--too long with no nicknames
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_026']))

	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_027']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_028']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_029']))

	GAME:WaitFrames(20)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_030']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_031']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_032']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_033']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_034']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_035']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GROUND:CharSetEmote(audino, "sweating", 1)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_036']))
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_037']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_038']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_039']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_040']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_041']))
	--too long with no nicknames
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_042']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_043'], audino:GetDisplayName()))
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_044']))
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_045'], audino:GetDisplayName()))
	GAME:WaitFrames(10)

	--GeneralFunctions.Hop(partner)
	GeneralFunctions.SetEmotion("Inspired")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_046'], hero:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['G2F4_047'], zone:GetColoredName()))

	GAME:WaitFrames(20)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	partner.CollisionDisabled = true--redisable partner's collision. Something is causing this to be set to false earlier in the script...
	GeneralFunctions.PanCamera()
	GROUND:Unhide('Upwards_Stairs_Exit')
	SV.Chapter4.FinishedAssemblyIntro = true
	GAME:CutsceneMode(false)


end
