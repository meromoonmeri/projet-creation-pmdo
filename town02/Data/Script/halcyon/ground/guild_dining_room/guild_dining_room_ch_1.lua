
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.CharacterEssentials'
require 'halcyon.GeneralFunctions'

guild_dining_room_ch_1 = {}


function guild_dining_room_ch_1.SetupGround()
	local snubbull = CharacterEssentials.MakeCharactersFromList({
		{'Snubbull', 288, 144, Direction.Down}
	})

	AI:SetCharacterAI(snubbull, "halcyon.ai.ground_default", RogueElements.Loc(272, 128), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	GAME:FadeIn(20)

end


function guild_dining_room_ch_1.Snubbull_Action(chara, activator)
	local snubbull = chara
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	if not SV.Chapter1.MetSnubbull then
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		GROUND:CharTurnToCharAnimated(hero, snubbull, 4)
		GROUND:CharTurnToCharAnimated(snubbull, hero, 4)
		GROUND:CharTurnToChar(partner, snubbull)



		GeneralFunctions.Complain(snubbull, true)
		GeneralFunctions.StartConversation(snubbull, "Ugh ![pause=0]Combien de fois dois-je vous le dire !?[pause=0]Arrêtez de vous faufiler ici pour prendre une collation après le dîner !", "Angry", true, true, false)
		GAME:WaitFrames(20)

		GROUND:CharSetEmote(snubbull, '', 0)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_001'], CharacterEssentials.GetCharacterName("Breloom")))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_002']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion('Normal')

		local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												GROUND:CharTurnToCharAnimated(snubbull, partner, 4) end)
		local coro2 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_038']))
												UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_003']))
												UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_004']))
												UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_039'])) end)
		TASK:JoinCoroutines({coro1, coro2})
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_005']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_006']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GROUND:CharSetEmote(partner, "sweating", 1)
		--SOUND:PlayBattleSE('EVT_Emote_Sweating')
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_007']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_008'], CharacterEssentials.GetCharacterName("Breloom")))
		GeneralFunctions.SetEmotion("Angry")
		GROUND:CharSetEmote(snubbull, "angry", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_009']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_010']))
		GAME:WaitFrames(20)

		GROUND:CharSetEmote(snubbull, "", 0)
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_011']))
		GAME:WaitFrames(40)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_012']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_013']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_014'], snubbull:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(snubbull)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_015']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_016'], partner:GetDisplayName(), hero:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(snubbull)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_017'], partner:GetDisplayName(), hero:GetDisplayName()))
		GAME:WaitFrames(20)

		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_018']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_019'], STRINGS:Format("\\u266A")))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_020']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_021']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_022']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Stunned")
		GROUND:CharSetEmote(partner, "sweating", 1)
		coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
		coro2 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_040']))
												UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_041'])) end)
		TASK:JoinCoroutines({coro1, coro2})
		GAME:WaitFrames(20)

		--hero knows things mechanics wise because the player does, but a player wouldn't actually know anything about how pokemon berries taste (besides basic ones maybe like pecha)
		--hero is also from a different world rather than living in the pokemon world and turning human. small distinction
	--	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	--	GAME:WaitFrames(20)
		--GROUND:CharTurnToCharAnimated(hero, snubbull, 4)
		--GAME:WaitFrames(20)
		--GROUND:CharTurnToCharAnimated(hero, partner, 4)
		--GAME:WaitFrames(20)
		--GROUND:CharTurnToCharAnimated(hero, snubbull, 4)
	--	GAME:WaitFrames(20)

		--GeneralFunctions.EmoteAndPause(hero, "Question", true)
		GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " ne semble pas trop enthousiasmé par ces plats.)", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(Est-ce que ce sont des goûts personnels de " .. GeneralFunctions.GetPronoun(partner, "their") .. ",[pause=10]ou ces repas sont-ils tout simplement horribles ?)", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(Je ne sais pas vraiment quel est le goût des aliments en tant que Pokémon...)", "Worried")
		GAME:WaitFrames(20)

		UI:SetSpeaker(snubbull)
		GeneralFunctions.SetEmotion("Special0")
		coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												GROUND:CharTurnToCharAnimated(hero, snubbull, 4) end)
		coro2 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_042'], STRINGS:Format("\\u266A"))) end)
		TASK:JoinCoroutines({coro1, coro2})
		GAME:WaitFrames(20)

		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_023']))
		--UI:WaitShowDialogue("The kind of ingredients that only a skilled adventurer would be able to procure!")
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_024']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_025']))
		GAME:WaitFrames(20)

		GeneralFunctions.Hop(snubbull)
		GROUND:CharSetAnim(snubbull, "None", true)--not in cutscene mode so this needs to be set back
		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_026']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_027'], STRINGS:Format("\\u266A")))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Sigh")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_028']))
		GAME:WaitFrames(20)

		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_029']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(snubbull)
		GeneralFunctions.SetEmotion("Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_030']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_031']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_032'], STRINGS:Format("\\u266A")))
		SV.Chapter1.MetSnubbull = true
		--every guildmate is talked to, signal player that they can go sleep now
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			GAME:WaitFrames(60)
			GROUND:CharTurnToCharAnimated(partner, hero, 4)
			UI:SetSpeaker(partner)
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_033'], hero:GetDisplayName()))
			GROUND:CharTurnToCharAnimated(hero, partner, 4)
			GAME:WaitFrames(12)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_034']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_035'], hero:GetDisplayName()))
		end
	else
		GROUND:CharTurnToChar(snubbull, hero)
		GeneralFunctions.StartConversation(snubbull, "Le repas de demain ne sera pas mon meilleur travail à cause des ingrédients...", "Special0")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_036']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GDR1_037'], STRINGS:Format("\\u266A")))
	end

	GeneralFunctions.EndConversation(snubbull)

end

return guild_dining_room_ch_1
