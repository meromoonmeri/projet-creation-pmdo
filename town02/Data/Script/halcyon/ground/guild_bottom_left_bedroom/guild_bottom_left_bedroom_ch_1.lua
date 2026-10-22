require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.CharacterEssentials'
require 'halcyon.GeneralFunctions'

guild_bottom_left_bedroom_ch_1 = {}


function guild_bottom_left_bedroom_ch_1.SetupGround()
	local breloom, girafarig, tail = CharacterEssentials.MakeCharactersFromList({
		{'Breloom', 188, 210, Direction.Left},
		{'Girafarig', 156, 210, Direction.Right},
		{'Tail'}
	})

	GAME:FadeIn(20)

end

function guild_bottom_left_bedroom_ch_1.Girafarig_Action(chara, activator)
	if not SV.Chapter1.MetBreloomGirafarig then
		guild_bottom_left_bedroom_ch_1.Breloom_Action(chara, activator)
	else
		local girafarig = CH('Girafarig')
		local tail = CH('Tail')
		local hero = CH('PLAYER')
		GeneralFunctions.StartConversation(chara, "Nous sommes les apéritifs les plus expérimentés ici,[pause=10]alors venez nous voir si vous avez besoin de conseils ou d'aide !", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_001'], tail:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(tail)
		GeneralFunctions.SetEmotion('Special0')
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_002']))

		GeneralFunctions.EndConversation(chara)

	end
end


function guild_bottom_left_bedroom_ch_1.Breloom_Action(chara, activator)
	local breloom = CH('Breloom')
	local girafarig = CH('Girafarig')
	local tail = CH('Tail')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	if not SV.Chapter1.MetBreloomGirafarig then
		GAME:FadeOut(false, 40)
		GROUND:TeleportTo(partner, 188, 178, Direction.Down)
		GROUND:TeleportTo(hero, 156, 178, Direction.Down)
		AI:DisableCharacterAI(partner)
		GAME:CutsceneMode(true)
		GAME:MoveCamera(180, 188, 1, false)
		GAME:WaitFrames(20)
		GAME:FadeIn(40)
		GAME:WaitFrames(10)


		--GROUND:CharTurnToChar(partner, breloom)
		--GROUND:CharTurnToChar(hero, breloom)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_003']))
		GAME:WaitFrames(20)

		--GROUND:CharTurnToChar(partner, girafarig)
		--GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_004']))
		GAME:WaitFrames(20)


		--GROUND:CharTurnToChar(partner, breloom)
		--GROUND:CharTurnToChar(hero, breloom)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_005']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_006']))
		GAME:WaitFrames(20)

		--GROUND:CharTurnToChar(partner, girafarig)
		--GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_007']))
		GAME:WaitFrames(20)

		--GROUND:CharTurnToChar(partner, breloom)
		--GROUND:CharTurnToChar(hero, breloom)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_008']))
		GAME:WaitFrames(20)

		--GROUND:CharTurnToChar(partner, girafarig)
		--GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_009']))
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_055'], tail:GetDisplayName()))--change the reason crum is a pain in the tail? maybe something better
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_010']))
		GAME:WaitFrames(20)

		--UI:SetSpeaker(tail)
		--GeneralFunctions.SetEmotion('Special0')
		--UI:WaitShowDialogue(".........")
		--GAME:WaitFrames(20)

		--GROUND:CharTurnToChar(partner, breloom)
		--GROUND:CharTurnToChar(hero, breloom)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_011'], tail:GetDisplayName()))
		GAME:WaitFrames(20)

		--GROUND:CharTurnToChar(partner, girafarig)
		--GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Sad")
		UI:WaitShowTimedDialogue("Oui,[pause=10] il est simplement si gro-", 40)
		GeneralFunctions.EmoteAndPause(girafarig, "Exclaim", true)
		GeneralFunctions.SetEmotion("Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_012']))
		GAME:WaitFrames(10)

		--GROUND:CharTurnToChar(partner, breloom)
		--GROUND:CharTurnToChar(hero, breloom)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Joyous")
		GROUND:CharSetEmote(breloom, "glowing", 0)
		SOUND:PlayBattleSE('EVT_Emote_Startled_2')
		GeneralFunctions.DoubleHop(breloom)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_013']))
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(breloom, "", 0)

		--GROUND:CharTurnToChar(partner, breloom)
		--GROUND:CharTurnToChar(hero, breloom)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_014']))
		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(breloom, "Notice", true)
		--GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(breloom, partner, 4)
		GAME:WaitFrames(20)

		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_015']))
		GROUND:CharTurnToCharAnimated(girafarig, partner, 4)
		GROUND:CharTurnToCharAnimated(hero, breloom, 4)
		GAME:WaitFrames(12)

		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_016']))
		GAME:WaitFrames(10)

		GROUND:CharSetEmote(hero, "exclaim", 1)
		GeneralFunctions.Recoil(partner)
		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_017']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_018']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_019']))
		GAME:WaitFrames(10)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Sad")
		--GROUND:CharSetEmote(hero, "sweating", 1)
		GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_020']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Happy")
		GROUND:CharSetEmote(breloom, "glowing", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_021']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_022']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_023']))
		GAME:WaitFrames(20)

		GROUND:CharTurnToCharAnimated(girafarig, breloom, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Normal")
		local coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_056'])) end)
		local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
													  GROUND:CharTurnToCharAnimated(partner, girafarig, 4)
													  GROUND:CharTurnToCharAnimated(hero, girafarig, 4) end)
		TASK:JoinCoroutines({coro1, coro2})
		GAME:WaitFrames(20)

		GROUND:CharSetEmote(breloom, "", 0)
		GROUND:CharTurnToCharAnimated(breloom, girafarig, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_024']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Sigh")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_025']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_026']))
		GAME:WaitFrames(20)


		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		GeneralFunctions.SetEmotion("Normal")
		GROUND:CharTurnToChar(girafarig, partner)
		GROUND:CharTurnToCharAnimated(breloom, partner, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_027'], breloom:GetDisplayName()))
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_028'], girafarig:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_029']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_030'], partner:GetDisplayName(), hero:GetDisplayName()))
		GAME:WaitFrames(20)

		--GROUND:CharTurnToChar(partner, breloom)
		--GROUND:CharTurnToChar(hero, breloom)
		UI:SetSpeaker(breloom)
		GeneralFunctions.SetEmotion("Happy")
		coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_057'], breloom:GetDisplayName())) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
												GROUND:CharTurnToCharAnimated(partner, breloom, 4)
												GROUND:CharTurnToCharAnimated(hero, breloom, 4) end)
		TASK:JoinCoroutines({coro1, coro2})
		GAME:WaitFrames(20)

		--GROUND:CharTurnToChar(partner, girafarig)
		--GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(girafarig)
		GeneralFunctions.SetEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_031']))
		GAME:WaitFrames(20)

		GROUND:CharTurnToCharAnimated(partner, girafarig, 4)
		GROUND:CharTurnToCharAnimated(hero, girafarig, 4)
		GROUND:CharAnimateTurnTo(girafarig, partner.Direction, 4)
		GeneralFunctions.SetEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_032'], tail:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_033'], tail:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(tail)
		GeneralFunctions.SetEmotion('Special0')
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_034']))
		GAME:WaitFrames(20)

		GROUND:CharSetEmote(partner, "sweatdrop", 1)
		GeneralFunctions.EmoteAndPause(hero, 'Sweatdrop', true)
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Stunned")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_035']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(breloom)
		GeneralFunctions.SetEmotion("Pain")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_036']))
		GAME:WaitFrames(20)

		GROUND:CharTurnToCharAnimated(partner, breloom, 4)
		GROUND:CharTurnToCharAnimated(hero, breloom, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_037'], girafarig:GetDisplayName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_038']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_039']))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_040']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_041']))
		GAME:WaitFrames(20)

		GROUND:CharTurnToCharAnimated(partner, girafarig, 4)
		GROUND:CharTurnToCharAnimated(hero, girafarig, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_042'], tail:GetDisplayName()))
		GAME:WaitFrames(20)

		UI:SetSpeaker(tail)
		GeneralFunctions.SetEmotion('Special0')
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_043']))
		GAME:WaitFrames(20)

		GROUND:CharTurnToCharAnimated(girafarig, partner, 4)
		UI:SetSpeaker(girafarig)
		GeneralFunctions.SetEmotion("Happy")
		GeneralFunctions.Hop(girafarig)
		GROUND:CharSetEmote(girafarig, "glowing", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_044'], tail:GetDisplayName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_045']))
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(girafarig, "", 0)

		UI:SetSpeaker(partner)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_046']))
		GAME:WaitFrames(20)

		UI:SetSpeaker(breloom)
		GeneralFunctions.SetEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_047'], tail:GetDisplayName()))
		GAME:WaitFrames(20)

		GROUND:CharTurnToCharAnimated(partner, breloom, 4)
		GROUND:CharTurnToCharAnimated(hero, breloom, 4)
		--too long with no nicknames
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_048'], girafarig:GetDisplayName()))
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_049']))
		GAME:WaitFrames(20)

		--GROUND:CharTurnToChar(partner, girafarig)
		--GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(girafarig)
		GeneralFunctions.SetEmotion("Happy")
		coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_058']))
												UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_059'], tail:GetDisplayName())) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											    GROUND:CharTurnToCharAnimated(partner, girafarig, 4)
											    GROUND:CharTurnToCharAnimated(hero, girafarig, 4) end)
		TASK:JoinCoroutines({coro1, coro2})
		GAME:WaitFrames(20)

		UI:SetSpeaker(tail)
		GeneralFunctions.SetEmotion('Special0')
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_050']))
		GAME:WaitFrames(20)

		GeneralFunctions.PanCamera(180, 188)
		GROUND:CharTurnToChar(girafarig, breloom)
		GROUND:CharTurnToCharAnimated(breloom, girafarig)
		GROUND:CharSetAnim(breloom, "Idle", true)
		GROUND:CharSetAnim(girafarig, "Idle",true)
		SV.Chapter1.MetBreloomGirafarig = true
		--every guildmate is talked to, signal player that they can go sleep now
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			GAME:WaitFrames(60)
			GROUND:CharTurnToCharAnimated(partner, hero, 4)
			UI:SetSpeaker(partner)
			GeneralFunctions.SetEmotion("Normal")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_051'], hero:GetDisplayName()))
			GROUND:CharTurnToCharAnimated(hero, partner, 4)
			GAME:WaitFrames(12)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_052']))
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_053'], hero:GetDisplayName()))
		end
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
		GAME:CutsceneMode(false)
	else
		GeneralFunctions.StartConversation(chara, "Au fait,[pause=10] si jamais vous avez besoin d'aide pour quoi que ce soit,[pause=10]en particulier pour l'exploration,[pause=10]venez me voir ou " .. girafarig:GetDisplayName() .. " !", "Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBL1_054']))
		GeneralFunctions.EndConversation(chara)
	end
end

return guild_bottom_left_bedroom_ch_1
